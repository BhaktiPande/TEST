using InsiderTradingDAL.TwoFactorAuth.DTO;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

namespace InsiderTradingDAL.TwoFactorAuth
{
    public class TwoFactorAuthDAL : IDisposable
    {
        const String sLookupPrefix = "usr_msg_";

        public bool CheckIsOTPActived(string i_sConnectionString, string s_LoggedInId)
        {
            PetaPoco.Database db = null;

            int IsActiveOTP = 0;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        IsActiveOTP = db.Query<int>("exec st_usr_EmailOTPSettingActiveOrNot @inp_LoggedUserId",
                         new
                         {
                             inp_LoggedUserId = s_LoggedInId

                         }).Single<int>();
                        if (Convert.ToInt32(IsActiveOTP) != 0)
                        {
                            scope.Complete();
                            return true;
                        }

                        else
                        {
                            scope.Complete();
                            return false;
                        }

                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        /// <summary>
        /// This function will return a user logged in details saved in the system database
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<OTPConfigurationDTO> GetOTPConfiguration(string i_sConnectionString)
        {
            PetaPoco.Database db = null;

            IEnumerable<OTPConfigurationDTO> lstUserLoginDetails = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstUserLoginDetails = db.Query<OTPConfigurationDTO>("exec st_usr_GetOTPConfiguration",
                         new
                         {
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstUserLoginDetails;
        }
        public IEnumerable<OTPConfigurationDTO> GetUserDeatailsForOTP(string i_sConnectionString, string userLoginId)
        {
            PetaPoco.Database db = null;

            IEnumerable<OTPConfigurationDTO> lstUserLoginDetails = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstUserLoginDetails = db.Query<OTPConfigurationDTO>("exec st_usr_GetUserDetailsForOTP @inp_LoggedUserId",
                         new
                         {
                             inp_LoggedUserId = userLoginId
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstUserLoginDetails;
        }
        public Boolean SaveOTPDetails(string i_sConnectionString, int OTPConfigMasterId, int i_nUserInfo, string EmailID, string OTPCode, int OTPExpirationTime)
        {
            #region Paramters
            int res = 0;
            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters

            try
            {
                #region Output Param
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {


                        res = db.Query<int>("exec st_usr_SaveUserOTPDetails @inp_OTPConfigurationSettingMasterID, @inp_UserInfoId, @inp_EmailId, @inp_OTPCode,@inp_OTPExpirationTimeInSeconds, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_OTPConfigurationSettingMasterID = OTPConfigMasterId,
                            inp_UserInfoId = i_nUserInfo,
                            inp_EmailId = EmailID,
                            inp_OTPCode = OTPCode,
                            inp_OTPExpirationTimeInSeconds = OTPExpirationTime,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).Single<int>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
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
                            #endregion  Error Code
                        }

                        else
                        {
                            scope.Complete();
                            return true;
                        }

                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }

        public int ValidateOTPDetails(string i_sConnectionString, int OTPConfigMasterId, int i_nUserInfo, string OTPCode)
        {
            #region Paramters
            int res = 0;
            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters

            try
            {
                #region Output Param
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {


                        res = db.Query<int>("exec st_usr_ValidateOTPDetailsByUserId @inp_OTPConfigurationSettingMasterID, @inp_UserInfoId, @inp_OTPCode, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_OTPConfigurationSettingMasterID = OTPConfigMasterId,
                            inp_UserInfoId = i_nUserInfo,
                            inp_OTPCode = OTPCode,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).Single<int>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
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

        }

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
