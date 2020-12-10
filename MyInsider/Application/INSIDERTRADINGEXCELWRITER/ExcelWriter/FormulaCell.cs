using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml;
using System.Reflection;

namespace InsiderTradingExcelWriter.ExcelFacade
{
    public class FormulaCell : Cell
    {
        /// <summary>
        /// This constructor creates a cell for formula.
        /// </summary>
        /// <param name="i_sColumn">Column Name</param>
        /// <param name="i_sText">Value</param>
        /// <param name="i_nRowIndex">Row Number</param>
        /// 
        public FormulaCell(string isColumn, string i_sFormulaValue, int i_nRowIndex)
        {
            //Creates a Formula cell using i_sFormulaValue
            this.CellFormula = new CellFormula { CalculateCell = true, Text = i_sFormulaValue };
            
            //Sets data type as numeric 
            this.DataType = CellValues.Number;

            //Sets Column, Row index
            this.CellReference = isColumn + i_nRowIndex;
        }        
    }
}