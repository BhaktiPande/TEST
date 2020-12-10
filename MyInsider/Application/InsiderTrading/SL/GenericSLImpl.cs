using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading
{
    public class GenericSLImpl<T> : GenericDTOImpl<T>,IDisposable
    {

        #region ListAllDataTable
        /// <summary>
        /// This generic method is used for the fetching all list data.
        /// </summary>
        /// <param name="sConnectionString">Connection string</param>
        /// <param name="inp_iGridType">Grid Type</param>
        /// <param name="inp_iPageSize">Page Size</param>
        /// <param name="inp_iPageNo">Page Number</param>
        /// <param name="inp_sSortField">Sort Field</param>
        /// <param name="inp_sSortOrder">Sort Order</param>
        /// <param name="inp_sParam1">Paramater 1</param>
        /// <param name="inp_sParam2">Paramater 2</param>
        /// <param name="inp_sParam3">Paramater 3</param>
        /// <param name="inp_sParam4">Paramater 4</param>
        /// <param name="inp_sParam5">Paramater 5</param>
        /// <param name="inp_sParam6">Paramater 6</param>
        /// <param name="inp_sParam7">Paramater 7</param>
        /// <param name="inp_sParam8">Paramater 8</param>
        /// <param name="inp_sParam9">Paramater 9</param>
        /// <param name="inp_sParam10">Paramater 10</param>
        /// <param name="inp_sParam11">Paramater 11</param>
        /// <param name="inp_sParam12">Paramater 12</param>
        /// <param name="inp_sParam13">Paramater 13</param>
        /// <param name="inp_sParam14">Paramater 14</param>
        /// <param name="inp_sParam15">Paramater 15</param>
        /// <param name="inp_sParam16">Paramater 16</param>
        /// <param name="inp_sParam17">Paramater 17</param>
        /// <param name="inp_sParam18">Paramater 18</param>
        /// <param name="inp_sParam19">Paramater 19</param>
        /// <param name="inp_sParam20">Paramater 20</param>
        /// <param name="out_iTotalRecords">return Total Number of records</param>
        /// <param name="out_nReturnValue">Return Value</param>
        /// <param name="out_nSQLErrCode">SQL Server Error Code</param>
        /// <param name="out_sSQLErrMessage">SQL Error Message</param>
        /// <returns>List Of Generic DTO list</returns>
        public IEnumerable<T> ListAllDataTable(string sConnectionString, int inp_iGridType, int inp_iPageSize, int inp_iPageNo,
            string inp_sSortField, string inp_sSortOrder, string inp_sParam1, string inp_sParam2, string inp_sParam3, string inp_sParam4,
            string inp_sParam5, string inp_sParam6, string inp_sParam7, string inp_sParam8, string inp_sParam9,
            string inp_sParam10, string inp_sParam11, string inp_sParam12, string inp_sParam13, string inp_sParam14,
            string inp_sParam15, string inp_sParam16, string inp_sParam17, string inp_sParam18, string inp_sParam19,
            string inp_sParam20, string inp_sParam22, string inp_sParam21, string inp_sParam23, string inp_sParam24,
            string inp_sParam25, string inp_sParam26, string inp_sParam27, string inp_sParam28, string inp_sParam29,
            string inp_sParam30, out int out_iTotalRecords, string sLookUpPrefix)
        {
            out_iTotalRecords = 0; 
                      
            try
            {
                return ListALL(sConnectionString, inp_iGridType, inp_iPageSize, inp_iPageNo,
                      inp_sSortField, inp_sSortOrder, inp_sParam1, inp_sParam2, inp_sParam3, inp_sParam4,
                      inp_sParam5, inp_sParam6, inp_sParam7, inp_sParam8, inp_sParam9, inp_sParam10, inp_sParam11, inp_sParam12, inp_sParam13, inp_sParam14,
                      inp_sParam15, inp_sParam16, inp_sParam17, inp_sParam18, inp_sParam19, inp_sParam20, inp_sParam21, inp_sParam22, inp_sParam23, inp_sParam24,
                      inp_sParam25, inp_sParam26, inp_sParam27, inp_sParam28, inp_sParam29, inp_sParam30,
                       null, null, null, null, null, null, null, null, null, null,
                      null, null, null, null, null, null, null, null, null, null,
                      out  out_iTotalRecords, sLookUpPrefix);
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion ListAllDataTable

        #region ListAllDataTable
        /// <summary>
        /// This generic method is used for the fetching all list data.
        /// </summary>
        /// <param name="sConnectionString">Connection string</param>
        /// <param name="inp_iGridType">Grid Type</param>
        /// <param name="inp_iPageSize">Page Size</param>
        /// <param name="inp_iPageNo">Page Number</param>
        /// <param name="inp_sSortField">Sort Field</param>
        /// <param name="inp_sSortOrder">Sort Order</param>
        /// <param name="inp_sParam1">Paramater 1</param>
        /// <param name="inp_sParam2">Paramater 2</param>
        /// <param name="inp_sParam3">Paramater 3</param>
        /// <param name="inp_sParam4">Paramater 4</param>
        /// <param name="inp_sParam5">Paramater 5</param>
        /// <param name="inp_sParam6">Paramater 6</param>
        /// <param name="inp_sParam7">Paramater 7</param>
        /// <param name="inp_sParam8">Paramater 8</param>
        /// <param name="inp_sParam9">Paramater 9</param>
        /// <param name="inp_sParam10">Paramater 10</param>
        /// <param name="inp_sParam11">Paramater 11</param>
        /// <param name="inp_sParam12">Paramater 12</param>
        /// <param name="inp_sParam13">Paramater 13</param>
        /// <param name="inp_sParam14">Paramater 14</param>
        /// <param name="inp_sParam15">Paramater 15</param>
        /// <param name="inp_sParam16">Paramater 16</param>
        /// <param name="inp_sParam17">Paramater 17</param>
        /// <param name="inp_sParam18">Paramater 18</param>
        /// <param name="inp_sParam19">Paramater 19</param>
        /// <param name="inp_sParam20">Paramater 20</param>
        /// <param name="out_iTotalRecords">return Total Number of records</param>
        /// <param name="out_nReturnValue">Return Value</param>
        /// <param name="out_nSQLErrCode">SQL Server Error Code</param>
        /// <param name="out_sSQLErrMessage">SQL Error Message</param>
        /// <returns>List Of Generic DTO list</returns>
        public IEnumerable<T> ListAllDataTable(string sConnectionString, int inp_iGridType, int inp_iPageSize, int inp_iPageNo,
            string inp_sSortField, string inp_sSortOrder, string inp_sParam1, string inp_sParam2, string inp_sParam3, string inp_sParam4,
            string inp_sParam5, string inp_sParam6, string inp_sParam7, string inp_sParam8, string inp_sParam9,
            string inp_sParam10, string inp_sParam11, string inp_sParam12, string inp_sParam13, string inp_sParam14,
            string inp_sParam15, string inp_sParam16, string inp_sParam17, string inp_sParam18, string inp_sParam19,
            string inp_sParam20, out int out_iTotalRecords, string sLookUpPrefix)
        {
            out_iTotalRecords = 0; 
                      
            try
            {
                return ListALL(sConnectionString, inp_iGridType, inp_iPageSize, inp_iPageNo,
                      inp_sSortField, inp_sSortOrder, inp_sParam1, inp_sParam2, inp_sParam3, inp_sParam4,
                      inp_sParam5, inp_sParam6, inp_sParam7, inp_sParam8, inp_sParam9, inp_sParam10, inp_sParam11, inp_sParam12, inp_sParam13, inp_sParam14,
                      inp_sParam15, inp_sParam16, inp_sParam17, inp_sParam18, inp_sParam19, inp_sParam20,
                      null, null, null, null,null, null, null, null, null, null,
                      null, null, null, null,null, null, null, null, null, null,
                      null, null, null, null, null, null, null, null, null, null,
                      out  out_iTotalRecords, sLookUpPrefix);
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion ListAllDataTable

        //#region ListAllDataTableGrid
        ///// <summary>
        ///// Added method to have optional parameters.
        ///// </summary>
        ///// <param name="sConnectionString"></param>
        ///// <param name="inp_iGridType"></param>
        ///// <param name="inp_iPageSize"></param>
        ///// <param name="inp_iPageNo"></param>
        ///// <param name="inp_sSortField"></param>
        ///// <param name="inp_sSortOrder"></param>
        ///// <param name="out_iTotalRecords"></param>
        ///// <param name="sLookUpPrefix"></param>
        ///// <param name="inp_sParam1"></param>
        ///// <param name="inp_sParam2"></param>
        ///// <param name="inp_sParam3"></param>
        ///// <param name="inp_sParam4"></param>
        ///// <param name="inp_sParam5"></param>
        ///// <param name="inp_sParam6"></param>
        ///// <param name="inp_sParam7"></param>
        ///// <param name="inp_sParam8"></param>
        ///// <param name="inp_sParam9"></param>
        ///// <param name="inp_sParam10"></param>
        ///// <param name="inp_sParam11"></param>
        ///// <param name="inp_sParam12"></param>
        ///// <param name="inp_sParam13"></param>
        ///// <param name="inp_sParam14"></param>
        ///// <param name="inp_sParam15"></param>
        ///// <param name="inp_sParam16"></param>
        ///// <param name="inp_sParam17"></param>
        ///// <param name="inp_sParam18"></param>
        ///// <param name="inp_sParam19"></param>
        ///// <param name="inp_sParam20"></param>
        ///// <returns></returns>
        //public IEnumerable<T> ListAllDataTableGrid(string sConnectionString, int inp_iGridType, int inp_iPageSize, int inp_iPageNo,
        //    string inp_sSortField, string inp_sSortOrder, out int out_iTotalRecords, string sLookUpPrefix, string inp_sParam1 = null, string inp_sParam2 = null, string inp_sParam3 = null, string inp_sParam4 = null,
        //    string inp_sParam5 = null, string inp_sParam6 = null, string inp_sParam7 = null, string inp_sParam8 = null, string inp_sParam9 = null,
        //    string inp_sParam10 = null, string inp_sParam11 = null, string inp_sParam12 = null, string inp_sParam13 = null, string inp_sParam14 = null,
        //    string inp_sParam15 = null, string inp_sParam16 = null, string inp_sParam17 = null, string inp_sParam18 = null, string inp_sParam19 = null,
        //    string inp_sParam20 = null, string inp_sParam21 = null, string inp_sParam22 = null, string inp_sParam23 = null, string inp_sParam24 = null,
        //    string inp_sParam25 = null, string inp_sParam26 = null, string inp_sParam27 = null, string inp_sParam28 = null, string inp_sParam29 = null,
        //    string inp_sParam30 = null)
        //{
        //    out_iTotalRecords = 0; 

        //    try
        //    {
        //        return ListALL(sConnectionString, inp_iGridType, inp_iPageSize, inp_iPageNo,
        //              inp_sSortField, inp_sSortOrder, inp_sParam1, inp_sParam2, inp_sParam3, inp_sParam4,
        //              inp_sParam5, inp_sParam6, inp_sParam7, inp_sParam8, inp_sParam9, inp_sParam10, inp_sParam11, inp_sParam12, inp_sParam13, inp_sParam14,
        //              inp_sParam15, inp_sParam16, inp_sParam17, inp_sParam18, inp_sParam19, inp_sParam20, inp_sParam21, inp_sParam22, inp_sParam23, inp_sParam24,
        //              inp_sParam25, inp_sParam26, inp_sParam27, inp_sParam28, inp_sParam29, inp_sParam30,
        //              null, null, null, null, null, null, null, null, null, null,
        //              null, null, null, null, null, null, null, null, null, null,
        //              out  out_iTotalRecords, sLookUpPrefix);
        //    }
        //    catch (Exception exp)
        //    {
        //        throw exp;
        //    }

        //}
        //#endregion ListAllDataTableGrid

        #region ListAllDataTableGrid
      /// <summary>
        /// Added method to have optional parameters.
      /// </summary>
      /// <param name="sConnectionString"></param>
      /// <param name="inp_iGridType"></param>
      /// <param name="inp_iPageSize"></param>
      /// <param name="inp_iPageNo"></param>
      /// <param name="inp_sSortField"></param>
      /// <param name="inp_sSortOrder"></param>
      /// <param name="out_iTotalRecords"></param>
      /// <param name="sLookUpPrefix"></param>
      /// <param name="inp_sParam1"></param>
      /// <param name="inp_sParam2"></param>
      /// <param name="inp_sParam3"></param>
      /// <param name="inp_sParam4"></param>
      /// <param name="inp_sParam5"></param>
      /// <param name="inp_sParam6"></param>
      /// <param name="inp_sParam7"></param>
      /// <param name="inp_sParam8"></param>
      /// <param name="inp_sParam9"></param>
      /// <param name="inp_sParam10"></param>
      /// <param name="inp_sParam11"></param>
      /// <param name="inp_sParam12"></param>
      /// <param name="inp_sParam13"></param>
      /// <param name="inp_sParam14"></param>
      /// <param name="inp_sParam15"></param>
      /// <param name="inp_sParam16"></param>
      /// <param name="inp_sParam17"></param>
      /// <param name="inp_sParam18"></param>
      /// <param name="inp_sParam19"></param>
      /// <param name="inp_sParam20"></param>
      /// <param name="inp_sParam21"></param>
      /// <param name="inp_sParam22"></param>
      /// <param name="inp_sParam23"></param>
      /// <param name="inp_sParam24"></param>
      /// <param name="inp_sParam25"></param>
      /// <param name="inp_sParam26"></param>
      /// <param name="inp_sParam27"></param>
      /// <param name="inp_sParam28"></param>
      /// <param name="inp_sParam29"></param>
      /// <param name="inp_sParam30"></param>
      /// <param name="inp_sParam31"></param>
      /// <param name="inp_sParam32"></param>
      /// <param name="inp_sParam33"></param>
      /// <param name="inp_sParam34"></param>
      /// <param name="inp_sParam35"></param>
      /// <param name="inp_sParam36"></param>
      /// <param name="inp_sParam37"></param>
      /// <param name="inp_sParam38"></param>
      /// <param name="inp_sParam39"></param>
      /// <param name="inp_sParam40"></param>
      /// <param name="inp_sParam41"></param>
      /// <param name="inp_sParam42"></param>
      /// <param name="inp_sParam43"></param>
      /// <param name="inp_sParam44"></param>
      /// <param name="inp_sParam45"></param>
      /// <param name="inp_sParam46"></param>
      /// <param name="inp_sParam47"></param>
      /// <param name="inp_sParam48"></param>
      /// <param name="inp_sParam49"></param>
      /// <param name="inp_sParam50"></param>
      /// <returns></returns>
        public IEnumerable<T> ListAllDataTableGrid(string sConnectionString, int inp_iGridType, int inp_iPageSize, int inp_iPageNo,
            string inp_sSortField, string inp_sSortOrder, out int out_iTotalRecords, string sLookUpPrefix, string inp_sParam1 = null, string inp_sParam2 = null, string inp_sParam3 = null, string inp_sParam4 = null,
            string inp_sParam5 = null, string inp_sParam6 = null, string inp_sParam7 = null, string inp_sParam8 = null, string inp_sParam9 = null,
            string inp_sParam10 = null, string inp_sParam11 = null, string inp_sParam12 = null, string inp_sParam13 = null, string inp_sParam14 = null,
            string inp_sParam15 = null, string inp_sParam16 = null, string inp_sParam17 = null, string inp_sParam18 = null, string inp_sParam19 = null,
            string inp_sParam20 = null, string inp_sParam21 = null, string inp_sParam22 = null, string inp_sParam23 = null, string inp_sParam24 = null,
            string inp_sParam25 = null, string inp_sParam26 = null, string inp_sParam27 = null, string inp_sParam28 = null, string inp_sParam29 = null,
            string inp_sParam30 = null, string inp_sParam31 = null, string inp_sParam32 = null, string inp_sParam33 = null, string inp_sParam34 = null,
            string inp_sParam35 = null, string inp_sParam36 = null, string inp_sParam37 = null, string inp_sParam38 = null, string inp_sParam39 = null,
            string inp_sParam40 = null, string inp_sParam41 = null, string inp_sParam42 = null, string inp_sParam43 = null, string inp_sParam44 = null,
            string inp_sParam45 = null, string inp_sParam46 = null, string inp_sParam47 = null, string inp_sParam48 = null, string inp_sParam49 = null,
            string inp_sParam50 = null)
        {
            out_iTotalRecords = 0;

            try
            {
                return ListALL(sConnectionString, inp_iGridType, inp_iPageSize, inp_iPageNo,
                      inp_sSortField, inp_sSortOrder, inp_sParam1, inp_sParam2, inp_sParam3, inp_sParam4,
                      inp_sParam5, inp_sParam6, inp_sParam7, inp_sParam8, inp_sParam9, inp_sParam10, inp_sParam11, inp_sParam12, inp_sParam13, inp_sParam14,
                      inp_sParam15, inp_sParam16, inp_sParam17, inp_sParam18, inp_sParam19, inp_sParam20, inp_sParam21, inp_sParam22, inp_sParam23, inp_sParam24,
                      inp_sParam25, inp_sParam26, inp_sParam27, inp_sParam28, inp_sParam29, inp_sParam30,
                      inp_sParam31, inp_sParam32, inp_sParam33, inp_sParam34, inp_sParam35, inp_sParam36, inp_sParam37, inp_sParam38, inp_sParam39, inp_sParam40,
                      inp_sParam41, inp_sParam42, inp_sParam43, inp_sParam44, inp_sParam45, inp_sParam46, inp_sParam47, inp_sParam48, inp_sParam49, inp_sParam50,
                      out  out_iTotalRecords, sLookUpPrefix);
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion ListAllDataTableGrid

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
}