using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Collections;

namespace InsiderTradingDAL
{
    public class UpsiDAL : IDisposable
    {
        const String sLookupPrefix = "usr_msg_";
        #region SaveDetails
        /// <summary>
        /// This method is used for the saving Upsi Publish Date.
        /// <param name="sConnectionString">DB Connection String</param>
        /// <param name="m_objCompanyDTO"></param>
        /// <returns>if save then return true else return false</returns>
        public bool SaveDetails(string i_sConnectionString, UpsiDTO objUpsiTempSharingData)
        {
            #region Paramters
            UpsiDTO res = null;

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            bool bReturn = false;
            PetaPoco.Database db = null;
            #endregion Paramters

            try
            {
                #region Out Paramter
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                #endregion Out Paramter

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        //var res = db.Query<UpsiTempSharingData>("exec st_usr_UpsiTempDataDetails @inp_sCompanyName,@inp_sAddress,@inp_sCategory,@inp_sReason,@inp_sComments,@inp_sPAN, @inp_sName, @inp_sPhone, @inp_sEmailId, @inp_sSharingDate,@inp_sPublishDate,inp_sUsernfoId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        res = db.Query<UpsiDTO>("exec st_usr_UpsiPublishdate @inp_iUserInfoId,@inp_nUpsi_id,@inp_nPublishDate,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {

                                inp_iUserInfoId =objUpsiTempSharingData.UserInfoId,   
                                inp_nUpsi_id = objUpsiTempSharingData.UPSIDocumentId ,
                                inp_nPublishDate = objUpsiTempSharingData.PublishDate,
                                  
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).SingleOrDefault();

                         #region Error Values
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
                             bReturn = false;
                             throw ex;
                         }
                         else
                         {
                             scope.Complete();
                             bReturn = true;
                         }
                         //return bReturn;
                         #endregion Error Values

                        return bReturn;
                    }
                }
            }
            catch (Exception exp)
            {

                throw exp;
            }
        }
        #endregion SaveDetails


        #region SaveUpsiList
        /// <summary>
        /// This method is used to save Upsi Sharing Info List
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>
        public UpsiDTO SaveUpsiList(string sConnectionString, DataTable dt_UpsiList)
        {
            #region Paramters
            UpsiDTO res = null;

            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters

            try
            {
                #region Out Paramter
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                var inp_tblUpsiList = new SqlParameter();
                inp_tblUpsiList.DbType = DbType.Object;
                inp_tblUpsiList.ParameterName = "@inp_tblUpsiTempSharingDataType";
                inp_tblUpsiList.TypeName = "dbo.UpsiTempSharingDataType";
                inp_tblUpsiList.SqlValue = dt_UpsiList;
                inp_tblUpsiList.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter



                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {


                        res = db.Fetch<UpsiDTO>("exec st_usr_UpsiTempDataDetails @inp_tblUpsiTempSharingDataType, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_tblUpsiTempSharingDataType = inp_tblUpsiList,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            //string sReturnValue = sLookupPrefix + out_nReturnValue;
                            //e.Data[0] = sReturnValue;
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
                            #endregion  Error Code
                        }

                        else
                        {


                            scope.Complete();
                            return res;
                        }
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            //return res;
        }
        #endregion SaveUpsiList

        #region AutoCompleteList
        /// <summary>
        /// This method is used for the AutoComplete Upsi details.
        /// <param name="sConnectionString">DB Connection String</param>
        /// <param name="m_objCompanyDTO"></param>
        /// <returns></returns>
        public List<UpsiDTO> AutoCompleteList(string i_sConnectionString, Hashtable HT_SearchParam)
        {
            List<UpsiDTO> res = null;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters
            try
            {

                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<UpsiDTO>("exec st_UP_UPSIAutoList @inp_sAction, @inp_sCompanyName, @inp_sCompanyAddress, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_sAction = HT_SearchParam["Action"],

                                inp_sCompanyName = HT_SearchParam["CompanyName"],
                                inp_sCompanyAddress = HT_SearchParam["CompanyAddress"],
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList<UpsiDTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            //string sReturnValue = sLookupPrefix + out_nReturnValue;
                            //e.Data[0] = sReturnValue;
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
                            scope.Complete();
                            return res;
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion

        #region GetUserInfo
        /// <summary>
        /// This method is used for get user info list by selected User.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserInfoDTO">User Type Object</param>
        /// <returns>User Information List</returns>
        public UpsiDTO GetUserInfo(string i_sConnectionString, int UserInfo)
        {
            #region Paramters
            UpsiDTO lstUserInfo = null;
            string sErrCode = string.Empty;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters

            try
            {

                #region Output Param
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                #endregion Output Param

                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        lstUserInfo = db.Query<UpsiDTO>("exec st_UpsiUserList @inp_iUserInfoId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iUserInfoId = UserInfo,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).SingleOrDefault();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Return Error Code
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            //string sReturnValue = sLookupPrefix + out_nReturnValue;
                            //e.Data[0] = sReturnValue;
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
                            #endregion Return Error Code
                        }
                        else
                        {
                            scope.Complete();
                        }
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstUserInfo;
        }
        #endregion GetUserInfo

        #region GetDocumentAutoID
        /// <summary>
        /// This method is used for get user Get DocumentAuto ID.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <param name="i_objUserInfoDTO">User Type Object</param>
        /// <returns>User Information List</returns>
        public UpsiDTO GetDocumentAutoID(string i_sConnectionString, int UserInfo)
        {


            PetaPoco.Database db = null;
            UpsiDTO objUpsiTempSharingData = new UpsiDTO();
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objUpsiTempSharingData = db.Query<UpsiDTO>("exec st_UpsiAutoId @inp_iUserInfoId",
                             new
                             {
                                 inp_iUserInfoId = UserInfo
                             }).Single<UpsiDTO>();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objUpsiTempSharingData;           
        }
        #endregion GetDocumentAutoID


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
