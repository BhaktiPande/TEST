using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using InsiderTrading.Common;
using InsiderTradingDAL;
using Newtonsoft.Json;

namespace InsiderTrading.SL
{
    public class ReportsSL:IDisposable
    {
        string m_sFileName { get; set; }
        int m_nGridType { get; set; }
        string m_sOverrideGridType { get; set; }
        string[] m_sExcelColumnNames = new string[]{"","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ"};
        InsiderTradingExcelWriter.ExcelFacade.CommonOpenXMLObject m_objCommonOpenXMLObject;
        List<PopulateComboDTO> m_lstVisibleColumnHeaders = new List<PopulateComboDTO>();
        //This will be list of columns which will be shown in the excel. This will contain the parent columns also.
        List<string> m_lstToShowColumnHeadings = new List<string>();
        LoginUserDetails m_objLoginUserDetails;
        //The name of the column in which the Button controls are showin in the Data Grid
        const string GRID_CONTROL_COLUMN_NAME = "Action";
        int m_nRowCount;
        ArrayList m_lstMergeColumns = new ArrayList();
        //This will be list of columns which will be shown in excel data section. This will contain only the leaf level chile columns for 
        //which the data will be shown in the excel.
        List<string> m_lstToShowColumnHeadingsForDateColumnSequence = new List<string>();

        public ReportsSL()
        {

        }


        #region Methods used for Report Excel Export
        public ReportsSL(int i_nGridType, string i_sOverrideGridType, string i_sFileName)
        {
            this.m_nGridType = i_nGridType;
            this.m_sFileName = i_sFileName;
            m_objCommonOpenXMLObject = new InsiderTradingExcelWriter.ExcelFacade.CommonOpenXMLObject();
            m_objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            m_nRowCount = 1;
            this.m_sOverrideGridType = i_sOverrideGridType;
        }
        /// <summary>
        /// This function will be used for creating a sheet to be added in the Excel. When the sheet is created then the report title 
        /// and the creation date are also added to the report sheet.
        /// </summary>
        /// <param name="sReportName">The name of the report</param>
        /// <param name="sFormattedCreationDate">The report creation date in format DD/MMM/YYYY</param>
        public void GenerateSheet(string sReportName, string sFormattedCreationDate)
        {
            int nReportNameLbl = 1, nReportNameValue = 2, nCreatedDateLabel = 3, nCreatedDateValue = 4;

            try
            {
                m_objCommonOpenXMLObject.OpenFile(this.m_sFileName, true);
                m_objCommonOpenXMLObject.OpenXMLObjectCreation();
                m_objCommonOpenXMLObject.OpenXMLCreateWorkSheetPartSheetData();

                m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);

                m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nReportNameLbl], "Report Name", m_nRowCount,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nReportNameValue], sReportName, m_nRowCount,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nCreatedDateLabel], "Created On", m_nRowCount,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nCreatedDateValue], sFormattedCreationDate, m_nRowCount,
                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                
                m_objCommonOpenXMLObject.AddToSheetData();

                m_nRowCount++;//Add blank rows after the report name row
            }
            catch (Exception exp)
            {

            }
        }


        /// <summary>
        /// This function is used for finding the total count of parent columns in the given columns list. 
        /// This is for merging the parent columns when thay have child columns under them in second row.
        /// </summary>
        /// <param name="lstPopulateComboDTO"></param>
        /// <param name="lstLevelTthreeList"></param>
        /// <returns></returns>
        private int FindTotalCounts(List<PopulateComboDTO> lstPopulateComboDTO, Dictionary<string, List<PopulateComboDTO>> lstLevelTthreeList)
        {
            int nTotalCount = 0;

            foreach (PopulateComboDTO objPopulateDTO in lstPopulateComboDTO)
            {
                if (lstLevelTthreeList.ContainsKey(objPopulateDTO.SequenceNumber))
                {
                    nTotalCount = nTotalCount + lstLevelTthreeList[objPopulateDTO.SequenceNumber].Count;
                }
                else
                {
                    nTotalCount = nTotalCount + 1;
                }
            }
            return nTotalCount;
        }

        /// <summary>
        /// This function is used for generating a parent child type column hierarchy in the report. 
        /// Currently it supports three level of parent-child level. The parent level columns are merged as 
        /// required.
        /// </summary>
        public void GenerateReportTableHeader()
        {
            int nFirstCellCounter = 1;
            //Different dictionaries for saperating the parent - child columns as per the level. 
            //For reports there are parent - child columns upto three levels.
            Dictionary<string, List<PopulateComboDTO>> objColumnToShowRow1 = new Dictionary<string, List<PopulateComboDTO>>();
            Dictionary<string, List<PopulateComboDTO>> objColumnToShowRow2 = new Dictionary<string, List<PopulateComboDTO>>();
            Dictionary<string, List<PopulateComboDTO>> objColumnToShowRow3 = new Dictionary<string, List<PopulateComboDTO>>();
            List<string> m_lstAllVisibleColumnsForData = new List<string>();

            bool hasParentClildColumnHierarchy = false;

            int nRemoveActionColumnIndex = 0;
            try
            {
                m_lstVisibleColumnHeaders.AddRange(Common.Common.GetPopulateCombo(m_objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ColumnHeader,
                   Convert.ToString(m_nGridType), "en-US", m_sOverrideGridType, null, null, "usr_msg_").ToList<PopulateComboDTO>());

                List<string> allKeys = new List<string>();
                int counter = 0;
                foreach (PopulateComboDTO objColumn in m_lstVisibleColumnHeaders)
                {
                    string sSeq = objColumn.SequenceNumber;
                    if (sSeq.Length > 4)
                    {
                        hasParentClildColumnHierarchy = true;
                    }
                    //For the columns from 1 to 9 the column sequence string size if 5 so one 0 is prefixed to it so that length 
                    //is same for all column sequences.
                    if (sSeq.Length < 6)
                        sSeq = "0" + sSeq;
                    allKeys.Add(sSeq);
                    if (objColumn.Key == "usr_grd_11073" || objColumn.Key == "rpt_grd_19312")
                        nRemoveActionColumnIndex = counter;
                    counter++;
                    m_lstAllVisibleColumnsForData.Add(objColumn.Key);
                }
                if(nRemoveActionColumnIndex != 0)
                    m_lstVisibleColumnHeaders.RemoveAt(nRemoveActionColumnIndex);

                //Check if the column considered has a child column present or else it is directly used.
                if (!hasParentClildColumnHierarchy)
                {
                    m_nRowCount++;
                    m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);
                    foreach (PopulateComboDTO objCellDTO in m_lstVisibleColumnHeaders)
                    {
                        if (objCellDTO.Value != GRID_CONTROL_COLUMN_NAME)
                        {
                            m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nFirstCellCounter], objCellDTO.Value, m_nRowCount,
                                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                            nFirstCellCounter++;
                            m_lstToShowColumnHeadings.Add(objCellDTO.Key);
                        }
                    }
                    //This is the additional column send on the UI for displaying the button controls in the grid.
                    m_objCommonOpenXMLObject.AddToSheetData();

                }
                else
                {
                    //Generate the column headers for columns which have parent column and muliple child columns type structure.


                    foreach (PopulateComboDTO objColumn in m_lstVisibleColumnHeaders)
                    {
                        string sColumnSequence = objColumn.SequenceNumber;
                        //For the columns from 1 to 9 the column sequence string size if 5 so one 0 is prefixed to it so that length 
                        //is same for all column sequences.
                        if (sColumnSequence.Length < 6)
                            sColumnSequence = "0" + sColumnSequence;
                        int percent = Convert.ToInt32(sColumnSequence) % 1000;
                        string stringPErcent = Convert.ToString(percent);
                        if (stringPErcent.Length < 2)
                            stringPErcent = "0" + stringPErcent;

                        if (percent == 0)
                        {
                            List<PopulateComboDTO> obj = new List<PopulateComboDTO>();
                            obj.Add(objColumn);
                            objColumnToShowRow1.Add(sColumnSequence, obj);
                            //objColumnToShowRow2.Add(sColumnSequence, new List<PopulateComboDTO>());
                        }
                        else
                        {
                            //has parent
                            List<string> keys1 = objColumnToShowRow1.Keys.ToList<string>();
                            var isPresentinOne = keys1.FirstOrDefault(stringToCheck => stringToCheck.StartsWith(stringPErcent));
                            if (isPresentinOne != null)
                            {
                                List<PopulateComboDTO> existsObj = new List<PopulateComboDTO>();
                                if (objColumnToShowRow1.ContainsKey(isPresentinOne))
                                {
                                    objColumnToShowRow1[isPresentinOne].Add(objColumn);
                                }
                                else
                                {
                                    List<PopulateComboDTO> obj = new List<PopulateComboDTO>();
                                    obj.Add(objColumn);
                                    objColumnToShowRow1.Add(isPresentinOne, obj);
                                }
                            }
                            else
                            {
                                List<string> keys2 = objColumnToShowRow2.Keys.ToList<string>();
                                //var isPresentinSecond = keys2.FirstOrDefault(stringToCheck => stringToCheck.StartsWith(stringPErcent));
                                var isParent = allKeys.FirstOrDefault(stringToCheck => stringToCheck.StartsWith(stringPErcent));
                                if (isParent != null)
                                {
                                    if (objColumnToShowRow2.ContainsKey(isParent))
                                    {
                                        objColumnToShowRow2[isParent].Add(objColumn);
                                        
                                    }
                                    else
                                    {
                                        List<PopulateComboDTO> obj = new List<PopulateComboDTO>();
                                        obj.Add(objColumn);
                                        objColumnToShowRow2.Add(isParent, obj);
                                        
                                    }
                                }
                            }
                        }
                    }

                    //Print the header lines
                    List<List<PopulateComboDTO>> DisctionaryValues = objColumnToShowRow1.Values.ToList<List<PopulateComboDTO>>();

                    //For creating first level report header row
                    m_nRowCount++;
                    m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);

                    bool hasChildColumns = false;
                    bool hasThirdLevel = false;
                    nFirstCellCounter = 1;
                    ArrayList objChild = new ArrayList();
                    int totalListCount = 0;
                    int outerCounter = 0;
                    foreach (List<PopulateComboDTO> objCellDTOList in DisctionaryValues)
                    {
                        totalListCount = totalListCount + objCellDTOList.Count;
                        if (objCellDTOList.Count > 1)
                        {
                            int rowCounter = 0;
                            int mergeCellFirst = 0;
                            int mergeCellLast = 0;
                            int toDoTillCount = FindTotalCounts(objCellDTOList, objColumnToShowRow2);
                            foreach (PopulateComboDTO objDTO in objCellDTOList)
                            {
                                if (rowCounter == 0)
                                {
                                    m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nFirstCellCounter], objDTO.Value, m_nRowCount,
                                                (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS);
                                    
                                    mergeCellFirst = nFirstCellCounter;
                                    nFirstCellCounter = nFirstCellCounter + 1;
                                    rowCounter++;
                                }

                                if (rowCounter < toDoTillCount-1)
                                    {
                                        m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nFirstCellCounter], "", m_nRowCount,
                                                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);

                                        mergeCellLast = nFirstCellCounter;
                                        nFirstCellCounter = nFirstCellCounter + 1;
                                        rowCounter++;
                                    }
                            }
                            outerCounter++;
                            if (mergeCellLast == 0)
                                mergeCellLast = mergeCellFirst;
                            m_lstMergeColumns.Add(m_sExcelColumnNames[mergeCellFirst] + Convert.ToString(m_nRowCount) + ":" + m_sExcelColumnNames[mergeCellLast] + Convert.ToString(m_nRowCount));
                            hasChildColumns = true;
                        }
                        else
                        {
                            if (objCellDTOList[0].Value != GRID_CONTROL_COLUMN_NAME)
                            {
                                m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nFirstCellCounter], objCellDTOList[0].Value, m_nRowCount,
                                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                                nFirstCellCounter = nFirstCellCounter + 1;

                                m_lstToShowColumnHeadings.Add(objCellDTOList[0].Key);
                            }
                        }
                    }
                    nFirstCellCounter = 1;
                    m_objCommonOpenXMLObject.AddToSheetData();
                    //For creating second level report header row
                    if (hasChildColumns)
                    {
                        m_nRowCount++;
                        m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);

                        foreach (List<PopulateComboDTO> objCellDTOList in DisctionaryValues)
                        {
                            if (objCellDTOList.Count > 1)
                            {
                                int rowCounter = 0;
                                foreach (PopulateComboDTO objDTO in objCellDTOList)
                                {
                                    
                                    if (rowCounter > 0)
                                    {
                                        m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nFirstCellCounter], objDTO.Value, m_nRowCount,
                                                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS);
                                        nFirstCellCounter = nFirstCellCounter + 1;
                                        m_lstToShowColumnHeadings.Add(objDTO.Key);
                                        if (objColumnToShowRow2.ContainsKey(objDTO.SequenceNumber))
                                        {
                                            hasThirdLevel = true;
                                            List<PopulateComboDTO> thirdDTOList = objColumnToShowRow2[objDTO.SequenceNumber];
                                            int thirdLevelCounter = 0;
                                            int mergeCellFirst = nFirstCellCounter-1;
                                            int mergeCellLast = 0;
                                            foreach (PopulateComboDTO objDTOThird in thirdDTOList)
                                            {
                                                if (thirdLevelCounter > 0)
                                                {
                                                    m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nFirstCellCounter], "", m_nRowCount,
                                                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                                                    nFirstCellCounter = nFirstCellCounter + 1;
                                                }
                                                thirdLevelCounter++;
                                            }
                                            mergeCellLast = nFirstCellCounter-1;

                                            if (mergeCellLast == 0)
                                                mergeCellLast = mergeCellFirst;
                                            m_lstMergeColumns.Add(m_sExcelColumnNames[mergeCellFirst] + Convert.ToString(m_nRowCount) + ":" + m_sExcelColumnNames[mergeCellLast] + Convert.ToString(m_nRowCount));
                                        }
                                    }
                                    rowCounter++;
                                }
                            }
                            else
                            {
                                if (objCellDTOList[0].Value != GRID_CONTROL_COLUMN_NAME)
                                {
                                    m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nFirstCellCounter], "", m_nRowCount,
                                                (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                                    nFirstCellCounter = nFirstCellCounter + 1;
                                }
                            }
                        }
                        m_objCommonOpenXMLObject.AddToSheetData();
                    }
                    nFirstCellCounter = 1;
                    //For creating third level column header row
                    if (hasThirdLevel)
                    {
                        m_nRowCount++;
                        m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);

                        foreach (List<PopulateComboDTO> objCellDTOList in DisctionaryValues)
                        {
                            if (objCellDTOList.Count > 1)
                            {
                                int rowCounter = 0;
                                foreach (PopulateComboDTO objDTO in objCellDTOList)
                                {
                                    if (rowCounter > 0)
                                    {
                                        if (objColumnToShowRow2.ContainsKey(objDTO.SequenceNumber))
                                        {
                                            List<PopulateComboDTO> thirdDTOList = objColumnToShowRow2[objDTO.SequenceNumber];
                                            foreach (PopulateComboDTO objDTOThird in thirdDTOList)
                                            {
                                                m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nFirstCellCounter], objDTOThird.Value, m_nRowCount,
                                                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                                                nFirstCellCounter = nFirstCellCounter + 1;
                                                m_lstToShowColumnHeadings.Add(objDTOThird.Key);
                                            }
                                        }
                                        else
                                        {
                                            m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nFirstCellCounter], "", m_nRowCount,
                                                (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                                            nFirstCellCounter = nFirstCellCounter + 1;
                                        }
                                    }
                                    rowCounter++;
                                }
                            }
                            else
                            {
                                if (objCellDTOList[0].Value != GRID_CONTROL_COLUMN_NAME)
                                {
                                    m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nFirstCellCounter], "", m_nRowCount,
                                                (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                                    nFirstCellCounter = nFirstCellCounter + 1;
                                }
                            }
                        }
                        m_objCommonOpenXMLObject.AddToSheetData();
                    }
                }
                //Find the list of columns which will be shown in the excel also the sequence for the columns to be shown will be same as followed in this list.
                m_lstToShowColumnHeadingsForDateColumnSequence = m_lstAllVisibleColumnsForData.Intersect(m_lstToShowColumnHeadings).ToList<string>();
                m_lstAllVisibleColumnsForData = null;
                m_lstMergeColumns = null;
                m_lstAllVisibleColumnsForData = null;
                objColumnToShowRow1 = null;
                objColumnToShowRow2 = null;
                objColumnToShowRow3 = null;
            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will set the width for the columns as per the GridType id
        /// </summary>
        public void SetColumnWidth()
        {
            ArrayList arrColumnWidth = null;
            try
            {
                arrColumnWidth = new ArrayList();
                if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_InitialDisclosureEmployeeWise))
                {
                    arrColumnWidth.Add("1:40:25");
                }
                else if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_InitialDisclosureEmployeeIndividual))
                {
                    //Add the width style for the applicable grids
                    arrColumnWidth.Add("1:40:25");
                }
                else if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_ContinuousReportEmployeeWise))
                {
                    //Add the width style for the applicable grids
                    arrColumnWidth.Add("1:40:25");
                }
                else if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_ContinuousReportEmployeeIndividual))
                {
                    //Add the width style for the applicable grids
                    arrColumnWidth.Add("1:40:25");
                }
                else if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeWise))
                {
                    //Add the width style for the applicable grids
                    arrColumnWidth.Add("1:40:25");
                }
                else if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividual))
                {
                    //Add the width style for the applicable grids
                    arrColumnWidth.Add("1:40:25");
                }
                else if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividualDetails))
                {
                    //Add the width style for the applicable grids
                    arrColumnWidth.Add("1:40:25");
                }
                else if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_PreclearenceReportEmployeeWise))
                {
                    //Add the width style for the applicable grids
                    arrColumnWidth.Add("1:40:25");
                }
                else if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_PreclearenceReportEmployeeIndividual))
                {
                    //Add the width style for the applicable grids
                    arrColumnWidth.Add("1:40:25");
                }
                else if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_RestrictedListSearch_CO))
                {
                    //Add the width style for the applicable grids
                    arrColumnWidth.Add("1:40:25");
                }
                else if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_RestrictedListSearch_Insider))
                {
                    //Add the width style for the applicable grids
                    arrColumnWidth.Add("1:40:25");
                }
                m_objCommonOpenXMLObject.AssignColumnWidth(arrColumnWidth);

            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will fetch the data with the filters applied and then add the data to the excel file.
        /// </summary>
        /// <param name="i_Search"></param>
        public void AddTableinSheet(string i_Search)
        {
            IEnumerable<Object> lstCRUserList = new List<Object>();
            //GenericSLImpl<Object> objGenericSLImpl = new GenericSLImpl<Object>();
            int out_iTotalRecords = 0;
            String sLookUpPrefix = "";
            int nCellCounter = 1;
            if (i_Search == null)
                i_Search = "";

            String[] arr = new string[21];
            String[] recArr = i_Search.Split(new string[] { "|_|" }, StringSplitOptions.None);
            for (int i = 0; i <= arr.Length - 1; i++)
            {
                if (i < recArr.Length)
                {
                    if (recArr[i] == "" || recArr[i] == "0")
                        arr[i] = null;
                    else
                        arr[i] = recArr[i];
                }
                else
                {
                    arr[i] = null;
                }
                
            }
            try
            {
                //Query to Grid
                using (var objGenericSLImpl = new GenericSLImpl<Object>())
                {
                    lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(m_objLoginUserDetails.CompanyDBConnectionString, m_nGridType, -1, 1,
                           "", "", out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                           arr[6], arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19]);
                }
               
                foreach (dynamic objUserList in lstCRUserList)
                {
                    m_nRowCount++;
                    m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);
                    nCellCounter = 1;
                    IDictionary<string, object> resultList = (IDictionary<string, object>)objUserList;

                    foreach (string sColumnToShow in m_lstToShowColumnHeadingsForDateColumnSequence)
                    {
                        
                        if (resultList.ContainsKey(sColumnToShow))
                        {
                            if (nCellCounter == 1 && m_nGridType == ConstEnum.GridType.Report_Defaulter && Convert.ToString(resultList[sColumnToShow]) == "1")
                            {
                                m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nCellCounter], "ž", m_nRowCount,
                                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.TEXT_PLANE_BACKGROUND_WINGDINGS_FONT_ORANGE);
                            }
                            else
                            {
                                m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nCellCounter], Convert.ToString(resultList[sColumnToShow]), m_nRowCount,
                                   (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                            }
                            
                            nCellCounter++;
                        }
                    }
                    m_objCommonOpenXMLObject.AddToSheetData();
                }
                lstCRUserList = null;
                m_lstToShowColumnHeadingsForDateColumnSequence = null;
            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will add the search criteria selected on the page used for filtering in the Excel export report.
        /// The i_sSearch will contain the search criteria in delimitted or json format.
        /// </summary>
        public void AddReportSearchCriteria(string i_sSearchCriteria)
        {
            int nCellCounter = 1;
            int nSearchCriteriaAdded = 0;
            m_nRowCount++;
            try
            {
                JavaScriptSerializer objJavascriptSerializer = new JavaScriptSerializer();
                var records = objJavascriptSerializer.Deserialize<List<SearchCriteria>>(i_sSearchCriteria);
                nCellCounter = 1;
                foreach (SearchCriteria objSearchCriteria in records)
                {
                    if (objSearchCriteria.value != "")
                    {
                        if (nSearchCriteriaAdded == 0)
                        {
                            m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);
                            m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[1], "Search Criteria Selected", m_nRowCount,
                                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                            //nCellCounter++;
                            m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[2], "", m_nRowCount,
                                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                          
                            m_objCommonOpenXMLObject.AddToSheetData();
                            m_nRowCount++;
                            m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);
                        }

                        
                        //nCellCounter++;
                        m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nCellCounter], objSearchCriteria.label, m_nRowCount,
                                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                        nCellCounter++;
                        m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nCellCounter], objSearchCriteria.value, m_nRowCount,
                                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        nCellCounter++;
                        if (nSearchCriteriaAdded !=0 && nSearchCriteriaAdded % 3 == 0)
                        {
                            nCellCounter = 1;
                            m_nRowCount++;
                            m_objCommonOpenXMLObject.AddToSheetData();
                            m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);
                        }
                        
                        nSearchCriteriaAdded++;
                    }
                }
                m_objCommonOpenXMLObject.AddToSheetData();
                m_nRowCount++;
            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will add the report header summary for the individual type reports. In this reports the summary for the individual Employee/Insider .. 
        /// record will be shown with its corresponding detail table.
        /// </summary>
        /// <param name="HeaderSummaryArr"></param>
        public void AddReportHeaderSummary(string[] HeaderSummaryArr)
        {
            JavaScriptSerializer objJavascriptSerializer = new JavaScriptSerializer();
            int nCellCounter = 0;
            m_nRowCount++;
            try
            {
                if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_InitialDisclosureEmployeeWise))
                {
                    //No header summary for this report...
                }
                else if (m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_InitialDisclosureEmployeeIndividual) ||
                    m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividual) ||
                    m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_PeriodEndDisclosureEmployeeIndividualDetails) ||
                    m_nGridType == Convert.ToInt32(ConstEnum.GridType.Report_ContinuousReportEmployeeIndividual))
                {
                    foreach(string HeaderSummary in HeaderSummaryArr)
                    {
                        var records = objJavascriptSerializer.Deserialize<List<InsiderTradingDAL.ReportHeaderKeyValueDTO>>(HeaderSummary);
                        nCellCounter = 0;
                        m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);
                        foreach (InsiderTradingDAL.ReportHeaderKeyValueDTO objReportHeaderParm in records)
                        {
                            if (nCellCounter == 6)
                            {
                                m_nRowCount++;
                                m_objCommonOpenXMLObject.AddToSheetData();
                                nCellCounter = 0;
                                m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);
                            }
                            //if (objReportHeaderParm.Key == "rpt_lbl_19027")
                            //{
                                //objReportHeaderParm.Value = (Convert.ToDateTime(objReportHeaderParm.Value)).ToShortDateString();
                            //}
                            nCellCounter++;
                            m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nCellCounter], Common.Common.getResource(objReportHeaderParm.Key), m_nRowCount,
                                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS);
                            nCellCounter++;
                            m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[nCellCounter], objReportHeaderParm.Value == null ? "" : objReportHeaderParm.Value, m_nRowCount,
                                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        }

                        m_nRowCount++;
                        m_objCommonOpenXMLObject.AddToSheetData();
                        nCellCounter = 0;
                        m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);

                        m_nRowCount++;
                        m_objCommonOpenXMLObject.CreateNewRow(m_nRowCount);
                        m_objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[1], "", m_nRowCount,
                                        (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS);
                        m_objCommonOpenXMLObject.AddToSheetData();
                        m_nRowCount++;
                    }
                }
            }
            catch (Exception exp)
            {

            }
        }

        /// <summary>
        /// This function will save the sheet to the excel work book
        /// </summary>
        /// <param name="i_sSheetName"></param>
        /// <param name="i_sFreezeActiveCell"></param>
        /// <param name="i_bFreezeHeader"></param>
        public void SaveToSheet(string i_sSheetName, string i_sFreezeActiveCell, bool i_bFreezeHeader)
        {
            m_objCommonOpenXMLObject.OpenXMLWorksheetAssignment(i_sSheetName, i_sFreezeActiveCell, i_bFreezeHeader);
            
        }

        /// <summary>
        /// This function will save the report by closing the worksheet.
        /// </summary>
        public void SaveReport()
        {
            m_objCommonOpenXMLObject.CellMerging(m_lstMergeColumns);
            m_objCommonOpenXMLObject.SaveWorkSheet();
            m_objCommonOpenXMLObject.CloseSpreadSheet();
            m_objCommonOpenXMLObject = null;
            
        }

        #endregion Methods used for Report Excel Export

        #region Methods for Report Fetch Data
        /// <summary>
        /// This function will return the header data seen on the Initial Disclosure Employee report.
        /// </summary>
        public IEnumerable<ReportHeaderKeyValueDTO> FetchReportHeaderKeyValueDetails(string i_sConnectionString, int i_nGridType, string[] i_sParamArr)
        {
            //GenericSLImpl<ReportHeaderKeyValueDTO> objGenericSLImpl = new GenericSLImpl<ReportHeaderKeyValueDTO>();
            IEnumerable<ReportHeaderKeyValueDTO> lstCRUserList = new List<ReportHeaderKeyValueDTO>();
            int out_iTotalRecords = 0;
            try
            {
                using (var objGenericSLImpl = new GenericSLImpl<ReportHeaderKeyValueDTO>())
                {
                    lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(i_sConnectionString, i_nGridType, 0, 1,
                           "", "ASC", out  out_iTotalRecords, "rpt_grd_", i_sParamArr[0], i_sParamArr[1], i_sParamArr[2], i_sParamArr[3], i_sParamArr[4], i_sParamArr[5],
                           i_sParamArr[6], i_sParamArr[7], i_sParamArr[8], i_sParamArr[9], i_sParamArr[10], i_sParamArr[11], i_sParamArr[12], i_sParamArr[13], i_sParamArr[14],
                           i_sParamArr[15], i_sParamArr[16], i_sParamArr[17], i_sParamArr[18], i_sParamArr[19]);
                }
            }
            catch (Exception exp)
            {

            }
            return lstCRUserList;
        }

        #endregion

         #region GetDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="inp_iDefaulterReportID"></param>
        /// <returns></returns>
        public DefaulterReportOverrideDTO GetDetails(string i_sConnectionString, long inp_iDefaulterReportID)
        {
            try
            {
                using (var objReportDAL = new ReportDAL())
                {
                    return objReportDAL.GetDetails(i_sConnectionString, inp_iDefaulterReportID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
         #endregion GetDetails

         #region UpdateNonComplainceOverided
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="m_iDefaulterReportID"></param>
        /// <param name="m_sReason"></param>
        /// <param name="m_iIsRemovedFromNonCompliance"></param>
        /// <returns></returns>
        public DefaulterReportOverrideDTO UpdateNonComplainceOverided(string i_sConnectionString, long? m_iDefaulterReportID, string m_sReason, int? m_iIsRemovedFromNonCompliance)
        {
            try
            {
                using (var objReportDAL = new ReportDAL())
                {
                    return objReportDAL.UpdateNonComplainceOverided(i_sConnectionString, m_iDefaulterReportID, m_sReason, m_iIsRemovedFromNonCompliance);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
         #endregion UpdateNonComplainceOverided

        #region IDisposable Members
        /// <summary>
        /// Dispose Method for dispose object
        /// </summary>
        private void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        /// <summary>
        /// Interface for dispose class
        /// </summary>
        void IDisposable.Dispose()
        {
            Dispose(true);
        }


        /// <summary>
        /// virtual dispoase method
        /// </summary>
        /// <param name="disposing"></param>
        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }

        #endregion
    }

    public class SearchCriteria
    {
        public string label;
        public string value;
    }
}