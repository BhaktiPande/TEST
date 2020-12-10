using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Reflection;
using DocumentFormat.OpenXml.Packaging;

namespace InsiderTradingExcelWriter.ExcelFacade
{
    public class TextCell : Cell
    {
        /// <summary>
        /// This constructor creates a cell of text type at said column, row index. 
        /// Also assigns text/value to that cell.
        /// </summary>
        /// <param name="i_sColumn">Column Name</param>
        /// <param name="i_sText">Value</param>
        /// <param name="i_nRowIndex">Row Number</param>
        public TextCell(string i_sColumn, string i_sValue, int i_nRowIndex)
        {
            #region COMMENT - Without shared string
            ////Set data type as text
            //this.DataType = CellValues.InlineString;

            ////Set index. For eg. "C1", "A12"... etc.
            //this.CellReference = i_sColumn + i_nRowIndex;

            ////Add text/value to the text cell.
            //this.InlineString = new InlineString { Text = new Text { Text = i_sValue } }; 
            #endregion // COMMENT - Without shared string

            int nIndex;
            nIndex = CommonOpenXML.InsertSharedStringItem(i_sValue);

            //Set data type as text
            this.DataType = CellValues.SharedString;

            //Set index. For eg. "C1", "A12"... etc.
            this.CellReference = i_sColumn + i_nRowIndex;

            //Add text/value to the text cell.
            this.CellValue = new CellValue(nIndex.ToString());
        }
    }
}
