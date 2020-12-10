using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DocumentFormat.OpenXml.Spreadsheet;

namespace InsiderTradingExcelWriter.ExcelFacade
{
    public class NumericCell : Cell
    {
        /// <summary>
        /// This constructor creates a cell of Numeric type at said column, row index. 
        /// Also assigns value to that cell.
        /// </summary>
        /// <param name="i_sColumn">Column Name</param>
        /// <param name="i_sText">Value</param>
        /// <param name="i_nRowIndex">Row Number</param>
        /// 
        public NumericCell(string i_sColumn, string i_sValue, int i_nRowIndex)
        {
            //Set data type as numeric
            this.DataType = CellValues.Number;

            //Set index. For eg. "C1", "A12"... etc.
            this.CellReference = i_sColumn + i_nRowIndex;

            //Add text/value to the text cell.
            this.CellValue = new CellValue(i_sValue);
        }
       
    }
}