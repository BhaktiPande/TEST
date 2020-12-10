using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml;
using System.Text.RegularExpressions;
using System.Collections;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.ExtendedProperties;
using System.Reflection;
using System.Web;
using System.Xml;
using System.IO;
using System.Globalization;

namespace InsiderTradingExcelWriter.ExcelFacade
{
    public class CommonOpenXML
    {
        #region Variables and objects
        private static SpreadsheetDocument m_objSpreadsheetDocument = null;

        private static WorkbookPart m_objWorkBookPart;
        private static WorksheetPart m_objWorkSheetPart;

        private static Workbook m_objWorkbook;

        private static Worksheet m_objWorksheet;

        private static Sheets m_objSheets;

        private static SheetData m_objSheetData;

        private static SharedStringTablePart m_objSharedStringTablePart;

        private static List<string> m_lstSharedStrings;
        private static Hyperlinks m_objHyperlinks;
        private static Hyperlink m_objHyperlink;

        private static DefinedNames m_objDefinedNames;
        private static DefinedName m_objDefinedName;

        private static Row m_objRow;
        private static Cell m_objCell;

        private static TextCell m_objTextCell;
        private static NumericCell m_objNumericCell;
        private static FormulaCell m_objFormulaCell;

        private static int m_nTotalRows = 0;
        private static int m_nTotalCells = 0;
        private static int m_nActualRowIndex = 0;

        private static XmlDocument xwb = null;
        private static XmlElement eleWorkbook = null;
        #endregion // Variables and objects

        #region Properties
        #region TotalRows
        public static int TotalRows
        {
            get
            {
                return m_nTotalRows;
            }
            set
            {
                m_nTotalRows = value;
            }
        }
        #endregion // TotalRows

        #region TotalCells
        public static int TotalCells
        {
            get
            {
                return m_nTotalCells;
            }
            set
            {
                m_nTotalCells = value;
            }
        }
        #endregion // TotalCells

        #region ActualRowIndex
        public static int ActualRowIndex
        {
            get
            {
                return m_nActualRowIndex;
            }
            set
            {
                m_nActualRowIndex = value;
            }
        }
        #endregion // TotalRows

        #region SheetCount
        public static int SheetCount
        {
            get { return m_objSheets.Elements<Sheet>().Count(); }
        }
        #endregion // SheetCount
        #endregion // Properties

        /* Export Excel : Open XML objct creation and sheet creation */
        #region OpenFile
        public static void OpenFile(string i_sFIleName, bool i_bCreateNew)
        {
            if (i_bCreateNew)
            {
                m_objSpreadsheetDocument = SpreadsheetDocument.Create(i_sFIleName, SpreadsheetDocumentType.Workbook);
            }
            else
            {
                m_objSpreadsheetDocument = SpreadsheetDocument.Open(i_sFIleName, false);
            }
        }
        #endregion // OpenFile

        #region Functions by creating workbook.xml and sheet.xml using Xml functionality
        #region CreateWorkbook
        public static void CreateWorkbook(string sSheetName)
        {
            string sRelationshipID = string.Empty;
            uint nSheetID = 1;

            try
            {
                if (xwb == null)
                {
                    NameTable nt = new NameTable();
                    XmlNamespaceManager nsManager = new XmlNamespaceManager(nt);

                    xwb = new XmlDocument(nt);

                    //create a xml document for workbook.xml
                    //I believe this is what every .xml must have
                    xwb.AppendChild(xwb.CreateXmlDeclaration("1.0", "UTF-8", "yes"));

                    //add the root element,
                    //I Believe there are better ways to handle namespace
                    //if you know, please tell me
                    eleWorkbook = xwb.CreateElement("workbook");
                    eleWorkbook.SetAttribute(@"xmlns", "http://schemas.openxmlformats.org/spreadsheetml/2006/main");
                    eleWorkbook.SetAttribute(@"xmlns:r", "http://schemas.openxmlformats.org/officeDocument/2006/relationships");
                    xwb.AppendChild(eleWorkbook);
                    eleWorkbook.AppendChild(xwb.CreateElement("sheets"));
                }

                if (m_objWorkBookPart.Workbook != null && m_objWorkBookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>().Count() > 0)
                {
                    nSheetID = m_objWorkBookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>().Select(s => s.SheetId.Value).Max() + 1;
                }

                //nSheetID = nSheetID + 1;
                sRelationshipID = m_objWorkBookPart.GetIdOfPart(m_objWorkSheetPart);

                XmlElement eleSheet = xwb.CreateElement("sheet");
                eleSheet.SetAttribute(@"name", sSheetName);
                eleSheet.SetAttribute(@"sheetId", nSheetID.ToString());
                eleSheet.SetAttribute(@"id", "http://schemas.openxmlformats.org/officeDocument/2006/relationships", sRelationshipID);
                switch (nSheetID > 1)
                {
                    case true:
                        eleWorkbook.SelectSingleNode("sheets").AppendChild(eleSheet);
                        break;

                    default:
                        eleWorkbook.LastChild.AppendChild(eleSheet);
                        break;
                }

                //write this .xml to workbookpart
                Stream wbstream = m_objWorkBookPart.GetStream();
                xwb.Save(wbstream);
            }
            catch (Exception exp)
            {
                nSheetID = 0;
                ClearObjects();

                throw exp;
            }
        }
        #endregion // CreateWorkbook

        #region CreateSheet
        public static void CreateSheet(string sSheetName)
        {
            try
            {
                if (m_objWorkBookPart == null)
                {
                    m_objWorkBookPart = m_objSpreadsheetDocument.AddWorkbookPart();

                    //Style sheet
                    WorkbookStylesPart objWorkbookStylesPart = m_objSpreadsheetDocument.WorkbookPart.AddNewPart<WorkbookStylesPart>();
                    Stylesheet objStylesheet = new CustomStyleSheet();
                    objStylesheet.Save(objWorkbookStylesPart);

                    // Get the SharedStringTablePart. If it does not exist, create a new one.
                    if (m_objSpreadsheetDocument.WorkbookPart.GetPartsOfType<SharedStringTablePart>().Count() > 0)
                    {
                        m_objSharedStringTablePart = m_objSpreadsheetDocument.WorkbookPart.GetPartsOfType<SharedStringTablePart>().First();
                    }
                    else
                    {
                        m_objSharedStringTablePart = m_objSpreadsheetDocument.WorkbookPart.AddNewPart<SharedStringTablePart>();
                    }
                }

                m_objWorkSheetPart = m_objWorkBookPart.AddNewPart<WorksheetPart>();

                XmlDocument xws = new XmlDocument();
                xws.AppendChild(xws.CreateXmlDeclaration("1.0", "UTF-8", "yes"));

                XmlElement eleWorksheet = xws.CreateElement("worksheet");
                eleWorksheet.SetAttribute(@"xmlns", "http://schemas.openxmlformats.org/spreadsheetml/2006/main");
                eleWorksheet.SetAttribute(@"xmlns:r", "http://schemas.openxmlformats.org/officeDocument/2006/relationships");
                eleWorksheet.SetAttribute(@"name", sSheetName);
                xws.AppendChild(eleWorksheet);

                XmlElement eleSheetData = xws.CreateElement("sheetData");
                eleWorksheet.AppendChild(eleSheetData);

                Stream wsstream = m_objWorkSheetPart.GetStream();
                xws.Save(wsstream);

                CreateWorkbook(sSheetName);

                m_objSheetData = m_objWorkSheetPart.Worksheet.Descendants<SheetData>().First();
                //m_objSheetData = new SheetData();
            }
            catch (Exception exp)
            {
                ClearObjects();

                throw exp;
            }
        }
        #endregion // CreateSheet

        #region OpenXMLSheetAssignment
        public static void OpenXMLSheetAssignment(Columns objColumns, string i_sActiveCell, bool i_bFreezeHeader)
        {
            #region Variables and objects
            string sRelationshipID = string.Empty;
            #endregion

            #region TRY
            try
            {
                #region Create worksheet
                m_objWorksheet = m_objWorkSheetPart.Worksheet;
                #endregion

                if (i_sActiveCell != string.Empty)
                {
                    FreezePanes(i_sActiveCell, i_bFreezeHeader);
                }
                m_objWorksheet.Append(objColumns);

                SheetData objSheetData = m_objWorkSheetPart.Worksheet.Descendants<SheetData>().First();
                m_objWorksheet.RemoveChild<SheetData>(objSheetData);
                m_objWorksheet.Append(m_objSheetData);

                #region Append hyperlinks
                if (m_objHyperlinks != null && m_objHyperlinks.Count() > 0)
                {
                    m_objWorksheet.Append(m_objHyperlinks);
                }
                #endregion // Append hyperlinks
            }
            #endregion // TRY

            #region CATCH
            catch (Exception exp)
            {
                throw exp;
            }
            #endregion // CATCH
        }
        #endregion // OpenXMLSheetAssignment

        #region CloseSheet
        public static void CloseSheet()
        {
            ClearObjects();
            m_objSpreadsheetDocument.Close();
        }
        #endregion // CloseSheet

        private static void ClearObjects()
        {
            m_objWorkBookPart = null;
            m_objWorkSheetPart = null;
            xwb = null;
            eleWorkbook = null;
        }
        #endregion //Functions by creating workbook.xml and sheet.xml using Xml functionality


        #region OpenXMLObjectCreation
        public static void OpenXMLObjectCreation()
        {
            #region TRY
            try
            {
                //Create workbookpart
                m_objWorkBookPart = m_objSpreadsheetDocument.AddWorkbookPart();

                //Style sheet
                WorkbookStylesPart objWorkbookStylesPart = m_objSpreadsheetDocument.WorkbookPart.AddNewPart<WorkbookStylesPart>();
                Stylesheet objStylesheet = new CustomStyleSheet();
                objStylesheet.Save(objWorkbookStylesPart);

                m_objWorkbook = new Workbook();

                m_objSheets = new Sheets();
                //Added by Lankesh
                //This ensures editing of excel file without saving the file in first place.
                m_objWorkbook.Append(new BookViews(new WorkbookView()));

                m_objWorkbook.Append(m_objSheets);

                // Get the SharedStringTablePart. If it does not exist, create a new one.
                if (m_objSpreadsheetDocument.WorkbookPart.GetPartsOfType<SharedStringTablePart>().Count() > 0)
                {
                    m_objSharedStringTablePart = m_objSpreadsheetDocument.WorkbookPart.GetPartsOfType<SharedStringTablePart>().First();
                }
                else
                {
                    m_objSharedStringTablePart = m_objSpreadsheetDocument.WorkbookPart.AddNewPart<SharedStringTablePart>();
                }

               
            }
            #endregion // TRY

            #region CATCH
            catch (Exception exp)
            {
                throw exp;
            }
            #endregion // CATCH
        }
        #endregion // OpenXMLObjectCreation

        #region InsertSharedStringItem
        // Given text and a SharedStringTablePart, creates a SharedStringItem with the specified text 
        // and inserts it into the SharedStringTablePart. If the item already exists, returns its index.
        public static int InsertSharedStringItem(string text)
        {
            IEnumerable<SharedStringItem> IEobjSharedStringItem;
            SharedStringItem objSharedStringItem;
            int nIndex = -1;

            //FileLogger objFileLogger;

            try
            {
                //objFileLogger = new FileLogger();

                // If the part does not contain a SharedStringTable, create one.
                if (m_objSharedStringTablePart.SharedStringTable == null)
                {
                    m_objSharedStringTablePart.SharedStringTable = new SharedStringTable();
                }

                // Iterate through all the items in the SharedStringTable. If the text already exists, return its index.
                //objFileLogger.WriteLog(MethodBase.GetCurrentMethod().ReflectedType.Name + "::" + MethodBase.GetCurrentMethod().Name,
                //    BaseLogger.LogLevel.Error, "------------ " + text + " ------------", BaseLogger.LogType.DLLLog);
                IEobjSharedStringItem = m_objSharedStringTablePart.SharedStringTable.Elements<SharedStringItem>();
                if (IEobjSharedStringItem.Count() > 0)
                {
                    //nIndex = objSharedStringItem.Select((str, index) => new { ItemName = str.InnerText, Position = index }).Where(sText => sText.ItemName == text).First().Position;
                    objSharedStringItem = IEobjSharedStringItem.SingleOrDefault(str => str.InnerText.Trim() == text.Trim());
                    if (objSharedStringItem != null)
                    {
                        nIndex = IEobjSharedStringItem.Select((str, index) => new { ItemName = str, Position = index }).Where(ssItem => ssItem.ItemName.InnerText.Trim() == objSharedStringItem.InnerText.Trim()).First().Position;
                    }
                }
                if (nIndex < 0)
                {
                    nIndex = IEobjSharedStringItem.Count();

                    // The text does not exist in the part. Create the SharedStringItem and return its index.
                    objSharedStringItem = new SharedStringItem(new Text(text.Trim()));
                    m_objSharedStringTablePart.SharedStringTable.AppendChild(objSharedStringItem);
                    m_objSharedStringTablePart.SharedStringTable.Save();
                }
            }

            catch (Exception exp)
            {
                throw exp;
            }

            return nIndex;
        }
        #endregion // InsertSharedStringItem

        #region OpenXMLWorksheetAssignmentWithPrintOptions
        public static void OpenXMLWorksheetAssignmentWithPrintOptions(string SheetName, Columns objColumns,
            string i_sActiveCell, bool i_bFreezeHeader)
        {
            #region TRY
            try
            {
                OpenXMLWorksheetAssignmentWithPrintOptions(SheetName, objColumns,
                    i_sActiveCell, i_bFreezeHeader, true, false, string.Empty);
            }
            #endregion // TRY

            #region CATCH
            catch (Exception exp)
            {
                throw exp;
            }
            #endregion // CATCH

        }

        public static void OpenXMLWorksheetAssignmentWithPrintOptions(string SheetName, Columns objColumns, string i_sActiveCell
            , bool i_bFreezeHeader, bool i_bSetPageSetupProperties, bool i_bSetPageTitles, string i_sPrintTitles)
        {
            #region Variables and objects
            uint nSheetID = 1;
            string sRelationshipID = string.Empty;
            Sheet objSheet;
            #endregion

            #region TRY
            try
            {
                #region Create worksheet
                m_objWorksheet = new Worksheet();
                #endregion

                if (i_sActiveCell != string.Empty)
                {
                    FreezePanes(i_sActiveCell, i_bFreezeHeader);
                }
                m_objWorksheet.Append(objColumns);

                #region Create sheet
                if (m_objSheets.Elements<Sheet>().Count() > 0)
                {
                    nSheetID = m_objSheets.Elements<Sheet>().Select(s => s.SheetId.Value).Max() + 1;
                }

                sRelationshipID = m_objWorkBookPart.GetIdOfPart(m_objWorkSheetPart);
                objSheet = new Sheet() { Id = sRelationshipID, SheetId = nSheetID, Name = SheetName };

                m_objSheets.Append(objSheet);
                #endregion

                m_objWorksheet.Append(m_objSheetData);

                if (i_bSetPageSetupProperties)
                {
                    SetPageSetupProperties();
                }

                if (i_bSetPageTitles)
                {
                    SetPageTitles(nSheetID - 1, i_sPrintTitles);
                }
            }
            #endregion // TRY

            #region CATCH
            catch (Exception exp)
            {
                throw exp;
            }
            #endregion // CATCH
        }
        #endregion // OpenXMLWorksheetAssignmentWithPrintOptions

        #region OpenXMLWorksheetAssignment
        public static void OpenXMLWorksheetAssignment(string SheetName, Columns objColumns, string i_sActiveCell, bool i_bFreezeHeader)
        {
            #region Variables and objects
            uint nSheetID = 1;
            string sRelationshipID = string.Empty;
            Sheet objSheet;
            #endregion

            #region TRY
            try
            {
                #region Create worksheet
                m_objWorksheet = new Worksheet();
                #endregion

                if (i_sActiveCell != string.Empty)
                {
                    FreezePanes(i_sActiveCell, i_bFreezeHeader);
                }
                m_objWorksheet.Append(objColumns);

                #region Create sheet
                if (m_objSheets.Elements<Sheet>().Count() > 0)
                {
                    nSheetID = m_objSheets.Elements<Sheet>().Select(s => s.SheetId.Value).Max() + 1;
                }

                sRelationshipID = m_objWorkBookPart.GetIdOfPart(m_objWorkSheetPart);
                objSheet = new Sheet() { Id = sRelationshipID, SheetId = nSheetID, Name = SheetName };

                m_objSheets.Append(objSheet);
                #endregion

                m_objWorksheet.Append(m_objSheetData);

                #region Append hyperlinks
                if (m_objHyperlinks != null && m_objHyperlinks.Count() > 0)
                {
                    m_objWorksheet.Append(m_objHyperlinks);
                }
                #endregion // Append hyperlinks
            }
            #endregion // TRY

            #region CATCH
            catch (Exception exp)
            {
                throw exp;
            }
            #endregion // CATCH
        }
        #endregion // OpenXMLWorksheetAssignment

        #region OpenXMLCreateWorkSheetPartSheetData
        public static void OpenXMLCreateWorkSheetPartSheetData()
        {
            m_objWorkSheetPart = m_objWorkBookPart.AddNewPart<WorksheetPart>();

            m_objSheetData = new SheetData();
        }
        #endregion // OpenXMLCreateWorkSheetPartSheetData

        #region SaveWorkSheet
        public static void SaveWorkSheet()
        {

            m_objWorkSheetPart.Worksheet = m_objWorksheet;
            m_objWorkSheetPart.Worksheet.Save();

        }
        #endregion // SaveWorkSheet

        #region CloseSpreadSheet
        public static void CloseSpreadSheet()
        {

            if (m_objDefinedNames != null)
            {
                m_objWorkbook.Append(m_objDefinedNames);
            }

            m_objSpreadsheetDocument.WorkbookPart.Workbook = m_objWorkbook;
            m_objSpreadsheetDocument.WorkbookPart.Workbook.Save();
            m_objSpreadsheetDocument.Close();
        }
        #endregion // CloseSpreadSheet

        #region Set column width
        #region CreateColumnData
        private static Column CreateColumnData(UInt32 StartColumnIndex, UInt32 EndColumnIndex, double ColumnWidth)
        {
            DocumentFormat.OpenXml.Spreadsheet.Column column;
            column = new DocumentFormat.OpenXml.Spreadsheet.Column();
            column.Min = StartColumnIndex;
            column.Max = EndColumnIndex;
            column.Width = ColumnWidth;
            column.CustomWidth = true;
            return column;
        }
        #endregion // CreateColumnData

        #region AssignColumnWidth
        public static Columns AssignColumnWidth(ArrayList i_arlColumnWidth)
        {
            string[] sColumnWidth;
            char[] chSeparator = { ':' };
            Columns objColumns;

            objColumns = new Columns();

            for (int i = 0; i < i_arlColumnWidth.Count; i++)
            {
                sColumnWidth = i_arlColumnWidth[i].ToString().Split(chSeparator);

                objColumns.Append(CreateColumnData(Convert.ToUInt32(sColumnWidth[0]), Convert.ToUInt32(sColumnWidth[1]), Convert.ToUInt32(sColumnWidth[2])));
            }

            return objColumns;
        }
        #endregion // AssignColumnWidth
        #endregion // Set column width

        #region CreateNewRow
        /// <summary>
        /// This function will create new row
        /// </summary>
        /// <param name="i_uRowIndex"></param>
        public static void CreateNewRow(uint i_uRowIndex)
        {
            m_objRow = new Row() { RowIndex = i_uRowIndex };
            m_nActualRowIndex = Convert.ToInt32(UInt32Value.ToUInt32(m_objRow.RowIndex));
        }

        public static void CreateNewRow(uint i_uRowIndex, int i_nRowHeight)
        {
            m_objRow = new Row() { RowIndex = i_uRowIndex };
            m_objRow.Height = i_nRowHeight;
            m_objRow.CustomHeight = true;
            m_nActualRowIndex = Convert.ToInt32(UInt32Value.ToUInt32(m_objRow.RowIndex));
        }

        /// <summary>
        /// This functioon will be used when want to work with multiple rows simultaneously.
        /// </summary>
        /// <param name="i_uRowIndex"></param>
        /// <returns></returns>
        public static Row CreateReturnNewRow(uint i_uRowIndex)
        {
            m_objRow = new Row() { RowIndex = i_uRowIndex };

            return m_objRow;
        }

        public static Row CreateReturnNewRow(uint i_uRowIndex, int i_nRowHeight)
        {
            m_objRow = new Row() { RowIndex = i_uRowIndex };
            m_objRow.Height = i_nRowHeight;
            m_objRow.CustomHeight = true;

            return m_objRow;
        }
        #endregion // CreateNewRow

        #region CreateTextCell
        /// <summary>
        /// Use this function while inserting data in multiple rows simultaneously.
        /// </summary>
        /// <param name="objRow"></param>
        /// <param name="i_sColumnName"></param>
        /// <param name="i_nRowIndex"></param>
        /// <param name="i_sValue"></param>
        /// <param name="i_uStyleIndex"></param>
        public static void CreateTextCell(ref Row objRow, string i_sColumnName, string i_sValue, int i_nRowIndex, uint i_uStyleIndex)
        {
            #region TextCell
            m_objTextCell = new TextCell(i_sColumnName, i_sValue, i_nRowIndex);
            m_objTextCell.StyleIndex = i_uStyleIndex;
            objRow.Append(m_objTextCell);
            #endregion // TextCell
        }

        /// <summary>
        /// Use this function to insert data in a row.
        /// </summary>
        /// <param name="i_sColumnName"></param>
        /// <param name="i_nRowIndex"></param>
        /// <param name="i_sValue"></param>
        /// <param name="i_uStyleIndex"></param>
        public static void CreateTextCell(string i_sColumnName, string i_sValue, int i_nRowIndex, uint i_uStyleIndex)
        {
            #region TextCell
            m_objTextCell = new TextCell(i_sColumnName, i_sValue, i_nRowIndex);
            m_objTextCell.StyleIndex = i_uStyleIndex;
            m_objRow.Append(m_objTextCell);
            #endregion // TextCell
        }
        #endregion // CreateTextCell

        #region CreateNumericCell
        /// <summary>
        /// Use this function while inserting data in multiple rows simultaneously.
        /// </summary>
        /// <param name="objRow"></param>
        /// <param name="i_sColumnName"></param>
        /// <param name="i_nRowIndex"></param>
        /// <param name="i_sValue"></param>
        /// <param name="i_uStyleIndex"></param>
        public static void CreateNumericCell(ref Row objRow, string i_sColumnName, string i_sValue, int i_nRowIndex, uint i_uStyleIndex)
        {
            #region NumericCell
            m_objNumericCell = new NumericCell(i_sColumnName, i_sValue, i_nRowIndex);
            m_objNumericCell.StyleIndex = i_uStyleIndex;
            objRow.Append(m_objNumericCell);
            #endregion // NumericCell
        }

        /// <summary>
        /// Use this function to insert data in a row.
        /// </summary>
        /// <param name="i_sColumnName"></param>
        /// <param name="i_nRowIndex"></param>
        /// <param name="i_sValue"></param>
        /// <param name="i_uStyleIndex"></param>
        public static void CreateNumericCell(string i_sColumnName, string i_sValue, int i_nRowIndex, uint i_uStyleIndex)
        {
            #region NumericCell
            m_objNumericCell = new NumericCell(i_sColumnName, i_sValue, i_nRowIndex);
            m_objNumericCell.StyleIndex = i_uStyleIndex;
            m_objRow.Append(m_objNumericCell);
            #endregion // NumericCell
        }
        #endregion // CreateNumericCell

        #region CreateFormulaCell
        /// <summary>
        /// This function creates cell having formula
        /// </summary>
        /// <param name="i_sColumnName"></param>
        /// <param name="i_nRowIndex"></param>
        /// <param name="i_sValue"></param>
        /// <param name="i_uStyleIndex"></param>
        public static void CreateFormulaCell(string i_sColumnName, string i_sValue, int i_nRowIndex, uint i_uStyleIndex)
        {
            #region FormulaCell
            m_objFormulaCell = new FormulaCell(i_sColumnName, i_sValue, i_nRowIndex);
            m_objFormulaCell.StyleIndex = i_uStyleIndex;
            m_objRow.Append(m_objFormulaCell);
            #endregion // TextCell
        }
        #endregion // CreateFormulaCell

        #region AddToSheetData
        /// <summary>
        /// This function saves a row in a sheet data
        /// </summary>
        public static void AddToSheetData()
        {
            m_objSheetData.Append(m_objRow);
        }

        /// <summary>
        /// This function saves a row in a sheet data.
        /// </summary>
        /// <param name="objRow"></param>
        public static void AddToSheetData(Row objRow)
        {
            m_objSheetData.Append(objRow);
        }
        #endregion // AddToSheetData
        /* Export Excel : Open XML objct creation and sheet creation */

        /* Export Excel : Hyperlink creation */
        #region CreateHyperLinks
        public static void CreateHyperLinks()
        {
            m_objHyperlinks = new Hyperlinks();
        }
        #endregion // CreateHyperLinks

        #region CreateHyperLink
        public static void CreateHyperLink(string i_sReferredCell, string i_sReferredSheetName, string i_sText)
        {
            m_objHyperlink = new Hyperlink()
            {
                Reference = i_sReferredCell,
                Location = i_sReferredSheetName,
                Display = i_sText//dr["SCHEDULENO"].ToString()
            };

            m_objHyperlinks.Append(m_objHyperlink);
        }
        #endregion // CreateHyperLink
        /* Export Excel : Hyperlink creation */

        /* Export Excel : Page titles creation */
        #region CreatePageTitles
        public static void CreatePageTitles()
        {
            m_objDefinedNames = new DefinedNames();
        }
        #endregion // CreatePageTitles

        #region SetPageTitles
        public static void SetPageTitles(uint i_nSheetID, string i_sPageTitles)
        {
            m_objDefinedName = new DefinedName() { Name = "_xlnm.Print_Titles", LocalSheetId = i_nSheetID, Text = i_sPageTitles };

            m_objDefinedNames.Append(m_objDefinedName);
        }
        #endregion // SetPageTitles
        /* Export Excel : Page titles creation */


        /* Import Excel : Open XML objct creation and sheet creation */
        #region GetActiveSheetName
        /// <summary>
        /// Swapna  08-Oct-2013
        /// This function will return sheet name of active sheet
        /// </summary>
        /// <returns></returns>
        public static string GetActiveSheetName()
        {
            #region Variables and objects
            string sSheetName = string.Empty;

            IEnumerable<Sheet> objSheets = null;
            SheetView objSheetView;
            SheetViews objSheetViews;
            #endregion //Variables and objects


            //Get WorkBookPart from the SpreadSheetDocument
            m_objWorkBookPart = m_objSpreadsheetDocument.WorkbookPart;

            // Get all Sheets from Workbook Part
            //new changes by Lankesh Begins
            objSheets = m_objSpreadsheetDocument.WorkbookPart.Workbook.Descendants<Sheet>();
            //objSheets = m_objWorkBookPart.Workbook.GetFirstChild<Sheets>();


            // If sheets exists
            if (objSheets.Count() > 0)
            {
                //new changes by Lankesh Begins
                foreach (Sheet objSheet in objSheets)
                {
                    m_objWorkSheetPart = (WorksheetPart)m_objSpreadsheetDocument.WorkbookPart.GetPartById(objSheet.Id);
                    objSheetViews = m_objWorkSheetPart.Worksheet.GetFirstChild<SheetViews>();
                    objSheetView = objSheetViews.GetFirstChild<SheetView>();
                    if (objSheetView.TabSelected != null && objSheetView.TabSelected.Value)
                    {
                        sSheetName = objSheet.Name;
                    }
                }
            }

            objSheets = null;
            //new changes by Lankesh Ends

            return sSheetName;
        }
        #endregion // GetActiveSheetName

        #region GetWorkbookSheetDataObject
        /// <summary>
        ///     This function will fetch the firstSheet data object and WorkbookPart from SpreadsheetDocument object.
        /// </summary>
        /// <Author>
        ///     Abhishek
        /// </Author>
        /// <param name="i_ssDocument">
        ///     WorkbookDocument
        /// </param>
        /// <param name="sValue"></param>
        /// <returns></returns>
        public static bool GetWorkbookSheetDataObject()
        {
            #region Variables and objects
            bool bReturnValue = false;

            IEnumerable<Sheet> objSheets = null;
            SheetView objSheetView;
            SheetViews objSheetViews;

            m_objSheetData = null;
            #endregion //Variables and objects


            //Get WorkBookPart from the SpreadSheetDocument
            m_objWorkBookPart = m_objSpreadsheetDocument.WorkbookPart;

            // Get all Sheets from Workbook Part
            //new changes by Lankesh Begins
            objSheets = m_objSpreadsheetDocument.WorkbookPart.Workbook.Descendants<Sheet>();
            //objSheets = m_objWorkBookPart.Workbook.GetFirstChild<Sheets>();


            // If sheets exists
            if (objSheets.Count() > 0)
            {
                //new changes by Lankesh Begins
                foreach (Sheet objSheet in objSheets)
                {
                    m_objWorkSheetPart = (WorksheetPart)m_objSpreadsheetDocument.WorkbookPart.GetPartById(objSheet.Id);
                    objSheetViews = m_objWorkSheetPart.Worksheet.GetFirstChild<SheetViews>();
                    objSheetView = objSheetViews.GetFirstChild<SheetView>();
                    if (objSheetView.TabSelected != null && objSheetView.TabSelected.Value)
                    {
                        //Get WorkSheetPart of active sheet from workbookPart
                        //m_objWorkSheetPart = (WorksheetPart)m_objWorkBookPart.GetPartById(objSheet.Id.Value);

                        // Get SheetData from WorkSheetPart
                        m_objSheetData = m_objWorkSheetPart.Worksheet.GetFirstChild<SheetData>();
                        m_nTotalRows = m_objSheetData.Elements<Row>().Count();
                    }
                }
                bReturnValue = true;
            }

            objSheets = null;
            //new changes by Lankesh Ends
            return bReturnValue;
        }
        #endregion // GetWorkbookSheetDataObject

        #region GetWorkbookSheetDataObject
        /// <summary>
        ///     This function will fetch the firstSheet data object and WorkbookPart from SpreadsheetDocument object.
        /// </summary>
        /// <Author>
        ///     Abhishek
        /// </Author>
        /// <param name="i_ssDocument">
        ///     WorkbookDocument
        /// </param>
        /// <param name="sValue"></param>
        /// <returns></returns>
        public static bool GetWorkbookSheetDataObject(string i_sSheetName)
        {
            #region Variables and objects
            bool bReturnValue = false;

            IEnumerable<Sheet> objSheets = null;
            SheetView objSheetView;
            SheetViews objSheetViews;
            m_nTotalRows = 0;
            m_objSheetData = null;
            #endregion //Variables and objects


            //Get WorkBookPart from the SpreadSheetDocument
            m_objWorkBookPart = m_objSpreadsheetDocument.WorkbookPart;

            // Get all Sheets from Workbook Part
            //new changes by Lankesh Begins
            objSheets = m_objSpreadsheetDocument.WorkbookPart.Workbook.Descendants<Sheet>();
            //objSheets = m_objWorkBookPart.Workbook.GetFirstChild<Sheets>();


            // If sheets exists
            if (objSheets.Count() > 0)
            {
                //new changes by Lankesh Begins
                foreach (Sheet objSheet in objSheets)
                {
                    if (objSheet.Name == i_sSheetName)
                    {
                        m_objWorkSheetPart = (WorksheetPart)m_objSpreadsheetDocument.WorkbookPart.GetPartById(objSheet.Id);
                        SharedStringTablePart stringTable = null;
                        stringTable = m_objWorkBookPart.GetPartsOfType<SharedStringTablePart>().FirstOrDefault();

                        m_lstSharedStrings = new List<string>();
                        foreach (SharedStringItem item in stringTable.SharedStringTable.Elements<SharedStringItem>())
                        {
                            m_lstSharedStrings.Add(item.InnerText);
                        }
                        //objSheetViews = m_objWorkSheetPart.Worksheet.GetFirstChild<SheetViews>();

                        //objSheetView = objSheetViews.GetFirstChild<SheetView>();
                        //if (objSheetView.TabSelected != null && objSheetView.TabSelected.Value)
                        //{
                        //Get WorkSheetPart of active sheet from workbookPart
                        //m_objWorkSheetPart = (WorksheetPart)m_objWorkBookPart.GetPartById(objSheet.Id.Value);

                        // Get SheetData from WorkSheetPart
                        m_objSheetData = m_objWorkSheetPart.Worksheet.GetFirstChild<SheetData>();
                        m_nTotalRows = m_objSheetData.Elements<Row>().Count();
                        //}
                    }
                }
                bReturnValue = true;
            }

            objSheets = null;
            //new changes by Lankesh Ends
            return bReturnValue;
        }
        #endregion // GetWorkbookSheetDataObject

        #region GetCellValueFromSharedString
        /// <summary>
        /// 
        /// </summary>
        /// <Author>
        ///     Swapna, Rasika
        /// </Author>
        /// <param name="workbookPart"></param>
        /// <param name="sValue"></param>
        /// <returns></returns>
        private static string GetCellValueFromSharedString(string sValue)
        {
            SharedStringTablePart stringTable = null;

            stringTable = m_objWorkBookPart.GetPartsOfType<SharedStringTablePart>().FirstOrDefault();
            if (stringTable != null)
            {
                sValue = stringTable.SharedStringTable.ElementAt(int.Parse(sValue)).InnerText;
            }

            return sValue;
        }
        #endregion // GetCellValueFromSharedString

        #region GetRow
        public static int GetRow(int i_nRow)
        {
            int nActualRowIndex;

            m_objRow = m_objSheetData.Elements<Row>().ElementAt(i_nRow);
            nActualRowIndex = (int)UInt32Value.ToUInt32(m_objRow.RowIndex);
            m_nTotalCells = m_objRow.Elements<Cell>().Count();

            return nActualRowIndex;
        }
        #endregion //GetRow

        #region GetCellValue
        public static int GetCellValue(int i_nColumnIndex, out string sCellValue)
        {
            int nColumnIndex;
            string sColumnName = string.Empty;
            sCellValue = string.Empty;

            /* The "m_objRow.Elements<Cell>()" collection contains only non empty cells. 
             * Hence, if there exists any empty cells, nColumnIndex is set by considering its "CellReference".
             * 
             * e.g Excel row contains data from C6 to H6 where D6 and E6 are empty.
             * In this case, "m_objRow.Elements<Cell>().Count()" considers data only of cells C6, F6, G6 and H6 because these are non empty cells. 
             * nColumnIndex would be set as per the cell reference of these non empty cells. */
            m_objCell = m_objRow.Elements<Cell>().ElementAt(i_nColumnIndex);

            sColumnName = GetColumnName(m_objCell.CellReference.Value.ToString());
            nColumnIndex = EndRangeCharacterReverse(sColumnName);

            //if (nColumnIndex == (i_nColumnIndex + 1))
            //{
            sCellValue = m_objCell.InnerText;

            #region Shared String
            if (m_objCell.DataType != null)
            {
                sCellValue = GetCellValueFromSharedString(sCellValue);
            }
            #endregion

            ///////////// Mehul Shah 16/07/2013
            if (m_objCell.DataType == null) // objCell.CellFormula contains formula if a cell has formula.
            {
                if (m_objCell.InnerText == "")
                {

                    sCellValue = "";
                }
                //else
                //{
                //    double a = (double.Parse(sCellValue, System.Globalization.CultureInfo.InvariantCulture));
                //    sCellValue = (double.Parse(a.ToString(), System.Globalization.CultureInfo.InvariantCulture).ToString());
                //    sCellValue = DateTime.FromOADate(a).ToString();
                //}
            }
            ////////////////////


            DateTime objDateTimeValue;
            if (DateTime.TryParseExact(sCellValue, new string[] { "dd-MMM-yyyy", "dd-mm-yyyy", "yyyy-mm-dd" }, null, DateTimeStyles.None, out objDateTimeValue))
            {
                sCellValue = objDateTimeValue.ToShortDateString();
            }
            //if (m_objCell.CellFormula != null) // objCell.CellFormula contains formula if a cell has formula.
            //{
            //    sCellValue = m_objCell.CellValue.Text.ToString();
            //}

            //}
            //else
            //{
            //   sCellValue = "";
            //}





            return nColumnIndex - 1;
        }


        /// <summary>
        /// This function gives the cell value considering the empty cells mentioned by the nDifference value.
        /// </summary>
        /// <param name="i_nColumnIndex"></param>
        /// <param name="nDifference"></param>
        /// <param name="sCellValue"></param>
        /// <returns></returns>
        public static int GetCellValue(int i_nColumnIndex, int nDifference,bool isDate, out string sCellValue)
        {
            int nColumnIndex = 0;
            string sColumnName = string.Empty;
            sCellValue = string.Empty;

            /* The "m_objRow.Elements<Cell>()" collection contains only non empty cells. 
             * Hence, if there exists any empty cells, nColumnIndex is set by considering its "CellReference".
             * 
             * e.g Excel row contains data from C6 to H6 where D6 and E6 are empty.
             * In this case, "m_objRow.Elements<Cell>().Count()" considers data only of cells C6, F6, G6 and H6 because these are non empty cells. 
             * nColumnIndex would be set as per the cell reference of these non empty cells. */
            //m_objCell = m_objRow.Elements<Cell>().ElementAt(i_nColumnIndex);
            m_objCell = m_objRow.Elements<Cell>().ElementAtOrDefault(i_nColumnIndex - nDifference);
            //             m_objRow.Elements<Row>().ElementAtOrDefault(1);

            if (m_objCell != null)
            {
                sColumnName = GetColumnName(m_objCell.CellReference.Value.ToString());
                nColumnIndex = EndRangeCharacterReverse(sColumnName);
                sCellValue = m_objCell.InnerText;

                #region Shared String
                
                if (m_objCell.DataType != null)
                {
                    sCellValue = m_lstSharedStrings[Convert.ToInt32(sCellValue)];//GetCellValueFromSharedString(sCellValue);
                }
                #endregion

                if (m_objCell.DataType == null) // objCell.CellFormula contains formula if a cell has formula.
                {
                    if (m_objCell.InnerText == "")
                    {
                        sCellValue = "";
                    }
                    else
                    {
                        if(isDate)
                        {
                            sCellValue = DateTime.FromOADate(Convert.ToDouble(sCellValue)).ToString("dd-MM-yyyy");
                        }
                    }
                }

                //If the cell value is of type date then it will convert the date format in simgle format and return it.
                DateTime objDateTimeValue;
                if (DateTime.TryParseExact(sCellValue, new string[] { 
                                                                    "dd-MMM-yyyy", 
                                                                    "dd-MM-yyyy", 
                                                                    "yyyy-MM-dd", 
                                                                    "dd-MM-yy", 
                                                                    "dd-MMM-yy", 
                                                                    "d-MM-yyyy", 
                                                                    "d-M-yyyy", 
                                                                    "d-M-yy", 
                                                                    "dd-M-yyyy", 
                                                                    "d-MM-yyyy", 
                                                                    "dd/MMM/yyyy",
                                                                    "d/MMM/yyyy",
                                                                    "d/MM/yyyy",
                                                                    "dd/MM/yyyy",
                                                                    "d/M/yyyy",
                                                                    "MMM/dd/yyyy",
                                                                    "MMM/d/yyyy",
                                                                    "MM/d/yyyy",
                                                                    "MM/dd/yyyy",
                                                                    "M/d/yyyy"
                                                                    }, null, DateTimeStyles.None, out objDateTimeValue))
                {
                    sCellValue = objDateTimeValue.ToString("dd-MM-yyyy");
                }
            }
            else
            {
                sCellValue = "";
                nColumnIndex = i_nColumnIndex + 1;
            }
            if (sCellValue != null)
            sCellValue = sCellValue.Trim();
            return nColumnIndex - 1;
        }




        public static int GetCellValue(Cell objCell, out string sCellValue)
        {
            int nColumnIndex;
            string sColumnName = string.Empty;
            sCellValue = string.Empty;

            sColumnName = GetColumnName(objCell.CellReference.Value.ToString());
            nColumnIndex = EndRangeCharacterReverse(sColumnName);

            sCellValue = objCell.InnerText;
            if (objCell.CellFormula != null) // objCell.CellFormula contains formula if a cell has formula.
            {
                sCellValue = objCell.CellValue.Text.ToString();
            }

            #region Shared String
            if (objCell.DataType != null)
            {
                sCellValue = GetCellValueFromSharedString(sCellValue);
            }
            #endregion

            return nColumnIndex - 1;
        }
        #endregion // GetCellValue


        #region ReleaseObjects
        public static void ReleaseObjects()
        {
	    if(m_objSpreadsheetDocument != null)            
		m_objSpreadsheetDocument.Close();
            m_objSheetData = null;
            m_objWorkBookPart = null;
            m_objWorkSheetPart = null;
            m_objSpreadsheetDocument = null;
        }
        #endregion // ReleaseObjects
        /* Import Excel : Open XML objct creation and sheet creation */

        // Given a cell name, parses the specified cell to get the row index.
        #region GetRowIndex
        private static uint GetRowIndex(string cellName)
        {
            // Create a regular expression to match the row index portion the cell name.
            Regex regex = new Regex(@"\d+");
            Match match = regex.Match(cellName);

            return uint.Parse(match.Value);
        }
        #endregion // GetRowIndex

        #region GetColumnName
        private static string GetColumnName(string cellName)
        {
            Regex regex = new Regex(@"[A-Za-z]+");
            Match match = regex.Match(cellName);

            return match.Value;
        }
        #endregion // GetColumnName

        #region EndRangeCharacter
        public static string EndRangeCharacter(int i_nRangeNo)
        {

            string sRange = "";
            int nRangeValue1;
            int nRangeValue2;
            try
            {
                if (i_nRangeNo <= 26)
                {
                    nRangeValue1 = 64 + i_nRangeNo;
                    sRange = Convert.ToChar(nRangeValue1).ToString();
                }
                else
                {
                    if (i_nRangeNo % 26 != 0)
                    {
                        nRangeValue1 = 64 + Convert.ToInt32(i_nRangeNo / 26);
                        nRangeValue2 = 64 + Convert.ToInt32(i_nRangeNo % 26);
                    }
                    else
                    {
                        nRangeValue1 = 63 + Convert.ToInt32(i_nRangeNo / 26);
                        nRangeValue2 = 90 + Convert.ToInt32(i_nRangeNo % 26);
                    }
                    sRange = Convert.ToChar(nRangeValue1).ToString() + Convert.ToChar(nRangeValue2).ToString();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return sRange;
        }
        #endregion

        #region EndRangeCharacterReverse
        public static int EndRangeCharacterReverse(string i_sColumn)
        {
            #region Variables and objects
            string sRange = "";
            int nRangeValue1;
            int nRangeValue2;

            int nColumnIndex;
            #endregion

            #region TRY
            try
            {
                if (i_sColumn.Length == 1)
                {
                    nColumnIndex = Encoding.ASCII.GetBytes(i_sColumn)[0] - 64;
                }
                else
                {
                    sRange = i_sColumn.Substring(0, 1);
                    nRangeValue1 = Encoding.ASCII.GetBytes(sRange)[0];

                    sRange = i_sColumn.Substring(1, 1);
                    nRangeValue2 = Encoding.ASCII.GetBytes(sRange)[0];

                    if (nRangeValue2 - 90 == 0)
                    {
                        nColumnIndex = (nRangeValue1 - 63) * 26;
                    }
                    else
                    {
                        nColumnIndex = (nRangeValue2 - 64) + 26;
                    }
                }
            }
            #endregion // TRY

            #region CATCH
            catch (Exception exp)
            {
                throw exp;
            }
            #endregion // CATCH

            return nColumnIndex;
        }
        #endregion

        #region Merge cells
        #region CreateSpreadsheetCellIfNotExist
        // Given a Worksheet and a cell name, verifies that the specified cell exists.
        // If it does not exist, creates a new cell. 

        private static void CreateSpreadsheetCellIfNotExist(Worksheet worksheet, string cellName, uint i_unStyleIndexForMergedCells)
        {
            #region Variables and objects
            uint rowIndex = GetRowIndex(cellName);

            IEnumerable<Row> rows = worksheet.Descendants<Row>().Where(r => r.RowIndex.Value == rowIndex);
            #endregion

            #region TRY
            try
            {
                // If the Worksheet does not contain the specified row, create the specified row.
                // Create the specified cell in that row, and insert the row into the Worksheet.
                if (rows.Count() == 0)
                {
                    Row row = new Row() { RowIndex = new UInt32Value(rowIndex) };
                    Cell cell = new Cell() { CellReference = new StringValue(cellName), StyleIndex = i_unStyleIndexForMergedCells };
                    row.Append(cell);
                    worksheet.Descendants<SheetData>().First().Append(row);
                }
                else
                {
                    Row row = rows.First();

                    IEnumerable<Cell> cells = row.Elements<Cell>().Where(c => c.CellReference.Value == cellName);

                    // If the row does not contain the specified cell, create the specified cell.
                    if (cells.Count() == 0)
                    {
                        Cell cell = new Cell() { CellReference = new StringValue(cellName) };
                        row.Append(cell);
                    }
                }
            }
            #endregion // TRY

            #region CATCH
            catch (Exception exp)
            {
                throw exp;
            }
            #endregion // CATCH
        }
        #endregion // CreateSpreadsheetCellIfNotExist

        #region CellMerging
        public static void CellMerging(ArrayList i_arrMergeCell)
        {
            #region Variables and objects
            MergeCells objMergeCells;
            string sStartMergeCell = string.Empty;
            string sEndMergeCell = string.Empty;
            string[] arrCells;
            char[] sSeperator = { ':' };
            #endregion

            #region TRY
            try
            {
                #region Cell merging
                if (i_arrMergeCell != null)
                {
                    objMergeCells = new MergeCells();

                    for (int i = 0; i < i_arrMergeCell.Count; i++)
                    {
                        arrCells = i_arrMergeCell[i].ToString().Split(sSeperator);

                        sStartMergeCell = arrCells[0];
                        sEndMergeCell = arrCells[1];

                        //Note: Call to CreateSpreadsheetCellIfNotExist is commented because this was giving error while opening Excel file. 
                        // This is because, the cells are already gettnig created before merging, and following function was creating cells again resulting to error like "it could open the file after making changes in a xml file".
                        //CreateSpreadsheetCellIfNotExist(objWorksheet, sStartMergeCell, i_unStyleIndexForMergedCells);
                        //CreateSpreadsheetCellIfNotExist(objWorksheet, sEndMergeCell, i_unStyleIndexForMergedCells);

                        if (m_objWorksheet.Elements<MergeCells>().Count() > 0)
                        {
                            objMergeCells = m_objWorksheet.Elements<MergeCells>().First();
                        }
                        else
                        {
                            //Insert the objMergeCells object into specified position
                            if (m_objWorksheet.Elements<CustomSheetView>().Count() > 0)
                            {
                                m_objWorksheet.InsertAfter(objMergeCells, m_objWorksheet.Elements<CustomSheetView>().First());
                            }
                            else
                            {
                                m_objWorksheet.InsertAfter(objMergeCells, m_objWorksheet.Elements<SheetData>().First());
                            }
                        }

                        //create the merged cell and append it to MergeCells collection 
                        MergeCell objMergeCell = new MergeCell() { Reference = new StringValue(sStartMergeCell + ":" + sEndMergeCell) };
                        objMergeCells.Append(objMergeCell);
                    }
                }
                #endregion // Cell merging
            }
            #endregion // TRY

            #region CATCH
            catch (Exception exp)
            {
                throw exp;
            }
            #endregion // CATCH

        }
        #endregion // CellMerging

        #endregion // Merge cells

        #region FreezePanes
        public static void FreezePanes(string sActiveCell, bool i_bFreezeHeader)
        {
            #region Variables and objects
            uint nRowIndex;
            string sColumn;
            string[] sarrCellSplit;
            char[] carrSeparator = { ':' };
            int nColumnIndex;

            SheetViews objSheetViews;
            SheetView objSheetView;
            Pane objPane;
            Selection objSelection;
            #endregion

            #region TRY
            try
            {
                nRowIndex = GetRowIndex(sActiveCell);
                nRowIndex = nRowIndex - 1;

                sColumn = GetColumnName(sActiveCell);
                nColumnIndex = EndRangeCharacterReverse(sColumn) - 1;

                sarrCellSplit = sActiveCell.Split(carrSeparator[0]);

                objSheetViews = new SheetViews();
                objSheetView = new SheetView() { WorkbookViewId = 0U };

                objPane = new Pane();
                objPane.VerticalSplit = DoubleValue.FromDouble(nRowIndex);
                objPane.ActivePane = PaneValues.BottomLeft;
                if (i_bFreezeHeader == false)
                {
                    objPane.HorizontalSplit = DoubleValue.FromDouble(nColumnIndex);
                    objPane.ActivePane = PaneValues.BottomRight;
                }
                objPane.TopLeftCell = sarrCellSplit[0];

                objPane.State = PaneStateValues.Frozen;
                objSheetView.Append(objPane);

                objSelection = new Selection();
                objSelection.Pane = PaneValues.BottomLeft;
                if (i_bFreezeHeader == false)
                {
                    objSelection.Pane = PaneValues.BottomRight;
                }
                objSelection.ActiveCell = sarrCellSplit[0];
                objSelection.SequenceOfReferences = new ListValue<StringValue>() { InnerText = sActiveCell };
                objSheetView.Append(objSelection);
                objSheetViews.Append(objSheetView);

                m_objWorksheet.Append(objSheetViews);
            }
            #endregion // TRY

            #region CATCH
            catch (Exception exp)
            {
                throw exp;
            }
            #endregion // CATCH
        }
        #endregion // FreezePanes

        #region SetPageSetupProperties
        public static void SetPageSetupProperties()
        {
            /* Add page setup properties */
            #region Page setup properties
            PageSetup objPageSetup = m_objWorksheet.Descendants<PageSetup>().FirstOrDefault();
            if (objPageSetup == null)
            {
                objPageSetup = new PageSetup();
                m_objWorksheet.AppendChild<PageSetup>(objPageSetup);
            }

            //if (objPageSetup != null)
            {
                objPageSetup.Orientation = OrientationValues.Landscape;
                objPageSetup.PaperSize = ConstantEnum.PaperSize.LEGAL_PAPER;
            }
            #endregion //Page setup properties

            /* Add footer to each worksheet */
            #region Header-footer
            HeaderFooter objHeaderFooter = m_objWorksheet.Descendants<HeaderFooter>().FirstOrDefault();
            if (objHeaderFooter == null)
            {
                objHeaderFooter = new HeaderFooter();
                m_objWorksheet.AppendChild<HeaderFooter>(objHeaderFooter);
            }

            //if (objHeaderFooter != null)
            {
                objHeaderFooter.DifferentOddEven = false;
                objHeaderFooter.DifferentFirst = false;

                objHeaderFooter.EvenFooter = new EvenFooter();
                objHeaderFooter.EvenFooter.Text = "Page : &P  of &N";

                objHeaderFooter.OddFooter = new OddFooter();
                objHeaderFooter.OddFooter.Text = "Page : &P  of &N";
            }
            #endregion // Header-footer
        }
        #endregion // SetPageSetupProperties

        #region ApplyIndentation
        public static void ApplyIndentation(TextCell i_objTextCell, int i_nLevelNoLength)
        {
            #region Try
            try
            {
                //    Range rg = (Range)xlsWorksheet.Cells[i_nRowNo, i_nColumnNo];
                //    rg.IndentLevel = (object)i_nLevelNoLength;

                Alignment objAlignment = new Alignment() { Indent = 2 };
                i_objTextCell.Append(objAlignment);
            }
            #endregion

            #region Catch
            catch (Exception exp)
            {
                throw exp;
            }
            #endregion
        }
        #endregion // ApplyIndentatio
    }
}
