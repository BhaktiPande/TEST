using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public abstract class GenericDTOImpl<T> : IGenericDTO<T>,IDisposable
    {


        #region ListALL
        /// <summary>
        /// This generic method is used for the fetching all list data.
        /// </summary>
        /// <param name="sConnectionString">DB Connection string</param>
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
        /// <param name="inp_sParam21">Paramater 21</param>
        /// <param name="inp_sParam22">Paramater 22</param>
        /// <param name="inp_sParam23">Paramater 23</param>
        /// <param name="inp_sParam24">Paramater 24</param>
        /// <param name="inp_sParam25">Paramater 25</param>
        /// <param name="inp_sParam26">Paramater 26</param>
        /// <param name="inp_sParam27">Paramater 27</param>
        /// <param name="inp_sParam28">Paramater 28</param>
        /// <param name="inp_sParam29">Paramater 29</param>
        /// <param name="inp_sParam30">Paramater 30</param>
        /// <param name="out_iTotalRecords">return Total Number of records</param>
        /// <param name="out_nReturnValue">Return Value</param>
        /// <param name="out_nSQLErrCode">SQL Server Error Code</param>
        /// <param name="out_sSQLErrMessage">SQL Error Message</param>
        /// <returns>List Of Generic DTO list</returns>
        public IEnumerable<T> ListALL(string sConnectionString, int inp_iGridType, int inp_iPageSize, int inp_iPageNo,
            string inp_sSortField, string inp_sSortOrder, string inp_sParam1, string inp_sParam2, string inp_sParam3, string inp_sParam4,
            string inp_sParam5, string inp_sParam6, string inp_sParam7, string inp_sParam8, string inp_sParam9,
            string inp_sParam10, string inp_sParam11, string inp_sParam12, string inp_sParam13, string inp_sParam14,
            string inp_sParam15, string inp_sParam16, string inp_sParam17, string inp_sParam18, string inp_sParam19,
            string inp_sParam20, string inp_sParam21, string inp_sParam22, string inp_sParam23, string inp_sParam24,
            string inp_sParam25, string inp_sParam26, string inp_sParam27, string inp_sParam28, string inp_sParam29,
            string inp_sParam30,
            string inp_sParam31, string inp_sParam32, string inp_sParam33, string inp_sParam34,
            string inp_sParam35, string inp_sParam36, string inp_sParam37, string inp_sParam38, string inp_sParam39,
            string inp_sParam40, string inp_sParam41, string inp_sParam42, string inp_sParam43, string inp_sParam44,
            string inp_sParam45, string inp_sParam46, string inp_sParam47, string inp_sParam48, string inp_sParam49,
            string inp_sParam50,
            out int out_iTotalRecords, string sLookupPrefix)
        {
            List<T> res = null;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters
            try
            {
                var nTotalRecords = new SqlParameter("@out_iTotalRecords", System.Data.SqlDbType.Int);
                nTotalRecords.Direction = System.Data.ParameterDirection.Output;
                nTotalRecords.Value = 0;
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 1000;

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<T>("exec st_com_PopulateGrid @inp_iGridType,@inp_iPageSize,@inp_iPageNo,@inp_sSortField ,@inp_sSortOrder,@inp_sParam1,@inp_sParam2,"
                    +"@inp_sParam3 ,@inp_sParam4 ,@inp_sParam5 ,@inp_sParam6 ,@inp_sParam7,"
	                +"@inp_sParam8 ,@inp_sParam9 ,@inp_sParam10 ,@inp_sParam11 ,@inp_sParam12 ,@inp_sParam13 ,@inp_sParam14 ,"			
	                +"@inp_sParam15 ,@inp_sParam16 ,@inp_sParam17 ,	@inp_sParam18 ,@inp_sParam19 ,@inp_sParam20,"
                    +"@inp_sParam21 ,@inp_sParam22 ,@inp_sParam23 ,@inp_sParam24 ,"			
	                +"@inp_sParam25 ,@inp_sParam26 ,@inp_sParam27 ,	@inp_sParam28 ,@inp_sParam29 ,@inp_sParam30,"
                  +"@inp_sParam31,@inp_sParam32,@inp_sParam33,@inp_sParam34,@inp_sParam35,@inp_sParam36,@inp_sParam37,"
                    + "@inp_sParam38,@inp_sParam39,@inp_sParam40,@inp_sParam41,@inp_sParam42,@inp_sParam43,@inp_sParam44,@inp_sParam45,@inp_sParam46,"
                    + "@inp_sParam47,@inp_sParam48,@inp_sParam49,@inp_sParam50,"
                    + "@out_iTotalRecords OUTPUT ,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT ",
                        new
                        {
                            inp_iGridType,
                            inp_iPageSize,
                            inp_iPageNo,
                            inp_sSortField,
                            inp_sSortOrder,
                            inp_sParam1,
                            inp_sParam2,
                            inp_sParam3,
                            inp_sParam4,
                            inp_sParam5,
                            inp_sParam6,
                            inp_sParam7,
                            inp_sParam8,
                            inp_sParam9,
                            inp_sParam10,
                            inp_sParam11,
                            inp_sParam12,
                            inp_sParam13,
                            inp_sParam14,
                            inp_sParam15,
                            inp_sParam16,
                            inp_sParam17,
                            inp_sParam18,
                            inp_sParam19,
                            inp_sParam20,
                            inp_sParam21,
                            inp_sParam22,
                            inp_sParam23,
                            inp_sParam24,
                            inp_sParam25,
                            inp_sParam26,
                            inp_sParam27,
                            inp_sParam28,
                            inp_sParam29,
                            inp_sParam30,
                            inp_sParam31,
                            inp_sParam32,
                            inp_sParam33,
                            inp_sParam34,
                            inp_sParam35,
                            inp_sParam36,
                            inp_sParam37,
                            inp_sParam38,
                            inp_sParam39,
                            inp_sParam40,
                            inp_sParam41,
                            inp_sParam42,
                            inp_sParam43,
                            inp_sParam44,
                            inp_sParam45,
                            inp_sParam46,
                            inp_sParam47,
                            inp_sParam48,
                            inp_sParam49,
                            inp_sParam50,
                            out_iTotalRecords = nTotalRecords,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage


                        }).ToList<T>();

                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
                        e.Data[0] = sReturnValue;
                        if (nSQLErrCode.Value != System.DBNull.Value)
                        {
                            out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                            e.Data[1] = out_nSQLErrCode;
                        }
                        if (sSQLErrMessage.Value != System.DBNull.Value)
                        {
                            out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                            e.Data[2] = out_sSQLErrMessage;
                        }
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }
                    else
                    {
                        if (nTotalRecords.Value != DBNull.Value)
                        {
                            out_iTotalRecords = Convert.ToInt32(nTotalRecords.Value);
                        }
                        else
                        {
                            out_iTotalRecords = 0;
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion ListALL

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
