using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class PasswordConfigDAL : IDisposable
    {
        #region GetPasswordConfigDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="inp_iUserInfoId"></param>
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.PasswordConfigDTO GetPasswordConfigDetails(string i_sConnectionString)
        {
            PasswordConfigDTO res = null;

            string sErrCode = string.Empty;
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
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<PasswordConfigDTO>("exec st_usr_GetPasswordConfig @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<PasswordConfigDTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = out_nReturnValue.ToString();
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
                            scope.Complete();
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
        #endregion GetPasswordConfigDetails

        #region SavePasswordConfigDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="inp_iUserInfoId"></param>
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public Boolean SavePasswordConfigDetails(string i_sConnectionString, PasswordConfigDTO i_PasswordConfigObj)
        {
            List<PasswordConfigDTO> res = null;

            string sErrCode = string.Empty;
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
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<PasswordConfigDTO>("exec st_usr_SavePasswordConfig @inp_iPasswordConfigID,@inp_iMinLength,@inp_iMaxLength,@inp_iMinAlphabets,@inp_iMinNumbers,@inp_iMinSplChar,@inp_iMinUppercaseChar,@inp_iCountOfPassHistory,@inp_iPassValidity,@inp_iExpiryReminder,@inp_iLastUpdatedBy,@inp_iLoginAttempts, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {   
                                inp_iPasswordConfigID=i_PasswordConfigObj.PasswordConfigID,
                                inp_iMinLength=i_PasswordConfigObj.MinLength,
                                inp_iMaxLength=i_PasswordConfigObj.MaxLength,
                                inp_iMinAlphabets=i_PasswordConfigObj.MinAlphabets,
                                inp_iMinNumbers=i_PasswordConfigObj.MinNumbers,
                                inp_iMinSplChar=i_PasswordConfigObj.MinSplChar,
                                inp_iMinUppercaseChar=i_PasswordConfigObj.MinUppercaseChar,
                                inp_iCountOfPassHistory=i_PasswordConfigObj.CountOfPassHistory,
                                inp_iPassValidity=i_PasswordConfigObj.PassValidity,
                                inp_iExpiryReminder=i_PasswordConfigObj.ExpiryReminder,
                                inp_iLastUpdatedBy=i_PasswordConfigObj.LastUpdatedBy,
                                inp_iLoginAttempts = i_PasswordConfigObj.LoginAttempts,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList<PasswordConfigDTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = out_nReturnValue.ToString();
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
        #endregion SavePasswordConfigDetails

        //#region CheckPasswordHistory
        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="i_sConnectionString"></param>
        ///// <param name="inp_iUserInfoId"></param>
        ///// <param name="out_nReturnValue"></param>
        ///// <param name="out_nSQLErrCode"></param>
        ///// <param name="out_sSQLErrMessage"></param>
        ///// <returns></returns>
        //public Boolean CheckPasswordHistory(string i_sConnectionString,string i_sPassword,int i_sUserInfoId)
        //{
        //    List<PasswordConfigDTO> res = null;

        //    string sErrCode = string.Empty;
        //    #region Paramters
        //    int out_nReturnValue;
        //    int out_nSQLErrCode;
        //    string out_sSQLErrMessage;
        //    PetaPoco.Database db = null;
        //    #endregion Paramters
        //    try
        //    {
        //        var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
        //        nReturnValue.Direction = System.Data.ParameterDirection.Output;
        //        //  nReturnValue.Value = 0;
        //        var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
        //        nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
        //        nSQLErrCode.Value = 0;
        //        var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
        //        sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
        //        sSQLErrMessage.Value = "";
        //        sSQLErrMessage.Size = 500;
        //        //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

        //        using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
        //        {
        //            using (var scope = db.GetTransaction())
        //            {
        //                res = db.Query<PasswordConfigDTO>("exec st_usr_CheckPasswordHistory @inp_iUserInfoId, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
        //                    new
        //                    {                                
        //                        inp_iUserInfoId = i_sUserInfoId,
        //                        out_nReturnValue = nReturnValue,
        //                        out_nSQLErrCode = nSQLErrCode,
        //                        out_sSQLErrMessage = sSQLErrMessage

        //                    }).ToList<PasswordConfigDTO>();

        //                if ((Convert.ToInt32(nReturnValue.Value) != 0)&&(Convert.ToInt32(nReturnValue.Value) != 1))
        //                {
        //                    Exception e = new Exception();
        //                    out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
        //                    string sReturnValue = out_nReturnValue.ToString();
        //                    e.Data[0] = sReturnValue;
        //                    if (nSQLErrCode.Value != System.DBNull.Value)
        //                    {
        //                        out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
        //                        e.Data[1] = out_nSQLErrCode;
        //                    }
        //                    if (sSQLErrMessage.Value != System.DBNull.Value)
        //                    {
        //                        out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
        //                        e.Data[2] = out_sSQLErrMessage;
        //                    }

        //                    Exception ex = new Exception(db.LastSQL.ToString(), e);
        //                    throw ex;
        //                }
        //                else
        //                {
        //                    scope.Complete();
        //                    if (Convert.ToInt32(nReturnValue.Value) == 0)
        //                        return false;
        //                    else
        //                        return true;
        //                }
        //            }
        //        }


        //    }
        //    catch (Exception exp)
        //    {
        //        throw exp;
        //    }
        //}
        //#endregion SavePasswordConfigDetails


        #region CheckPasswordHistory
        /// <summary>
        /// This function will return a user logged in details saved in the system database
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<PasswordConfigDTO> CheckPasswordHistory(string i_sConnectionString,int i_sUserInfoId)
        {
            IEnumerable<PasswordConfigDTO> lstUserPwdDetails = null;

            string sErrCode = string.Empty;
            #region Paramters
            //int out_nReturnValue;
            //int out_nSQLErrCode;
            //string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters
            try
            {

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

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstUserPwdDetails = db.Query<PasswordConfigDTO>("exec st_usr_CheckPasswordHistory @inp_iUserInfoId, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                         new
                         {
                             inp_iUserInfoId = i_sUserInfoId,
                             out_nReturnValue = nReturnValue,
                             out_nSQLErrCode = nSQLErrCode,
                             out_sSQLErrMessage = sSQLErrMessage
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstUserPwdDetails;
        }
        #endregion CheckPasswordHistory

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
