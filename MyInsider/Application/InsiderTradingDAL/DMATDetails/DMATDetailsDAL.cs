using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class DMATDetailsDAL:IDisposable
    {
        const String sLookupPrefix = "usr_msg_";
        #region GetDetails
        public DMATDetailsDTO GetDMATDetails(string sConnectionString, int nDMATDetailsID)
        {
            List<DMATDetailsDTO> res = null;
            #region Paramters
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
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<DMATDetailsDTO>("exec st_usr_DMATDetails @inp_iDMATDetailsID, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iDMATDetailsID = nDMATDetailsID,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,
                        }).ToList<DMATDetailsDTO>();

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
                        return res.FirstOrDefault();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
        }
        #endregion GetDetails

        #region Save
        /// <summary>
        /// This method is used for save the DMATDetails
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <param name="m_objDMATDetailsDTO">DMAT Type Object</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Boolean value based on the result</returns>
        public DMATDetailsDTO SaveDMATDetails(string sConnectionString, DMATDetailsDTO m_objDMATDetailsDTO, int nLoggedInUserId)
        {
            List<DMATDetailsDTO> res = null;
            #region Paramters
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
                sSQLErrMessage.Size = 1000;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<DMATDetailsDTO>("exec st_usr_DMATDetailsSave @inp_iUserInfoID, @inp_sDEMATAccountNumber, @inp_sDPBank, @inp_sDPID, @inp_sTMID, @inp_sDescription, @inp_iAccountTypeCodeId, @inp_iLoggedInUserId, @inp_iDPBankCodeId, @inp_iDmatAccStatusCodeId, @inp_iDMATDetailsID OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iUserInfoID = m_objDMATDetailsDTO.UserInfoID,
                            inp_sDEMATAccountNumber = m_objDMATDetailsDTO.DEMATAccountNumber,
                            inp_sDPBank = m_objDMATDetailsDTO.DPBank,
                            inp_sDPID = m_objDMATDetailsDTO.DPID,
                            inp_sTMID = m_objDMATDetailsDTO.TMID,
                            inp_sDescription = (m_objDMATDetailsDTO.Description == null ? "" : m_objDMATDetailsDTO.Description),
                            inp_iAccountTypeCodeId = m_objDMATDetailsDTO.AccountTypeCodeId,
                            inp_iLoggedInUserId = nLoggedInUserId,
                            inp_iDPBankCodeId = m_objDMATDetailsDTO.DPBankCodeId,
                            inp_iDmatAccStatusCodeId = m_objDMATDetailsDTO.DmatAccStatusCodeId,
                            inp_iDMATDetailsID = m_objDMATDetailsDTO.DMATDetailsID,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,

                        }).ToList<DMATDetailsDTO>();

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
                        return res.FirstOrDefault();
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
        }
        #endregion Save

        #region Delete
        /// <summary>
        /// This method is used for delete the DMATDetails
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <param name="inp_iDMATDetailsID">DMATDetailsID</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Boolean value based on the result</returns>
        public bool DeleteDMATDetails(string i_sConnectionString, int inp_iDMATDetailsID, int nLoggedInUserId)
        {
            List<DMATDetailsDTO> res = null;
            bool bReturn = false;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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

                using (var db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<DMATDetailsDTO>("exec st_usr_DMATDetailsDelete @inp_iDMATDetailsID, @inp_iUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iDMATDetailsID = inp_iDMATDetailsID,
                            inp_iUserId = nLoggedInUserId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<DMATDetailsDTO>();

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
                        bReturn = false;
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }
                    else
                    {
                        bReturn = true;
                    }
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;            
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion Delete

        #region GetDMATHolderDetails
        public DMATAccountHolderDTO GetDMATHolderDetails(string sConnectionString, int nDMATAccountHolderID)
        {
            List<DMATAccountHolderDTO> res = null;
            #region Paramters
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
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<DMATAccountHolderDTO>("exec st_usr_DMATAccountHolderDetails @inp_iDMATAccountHolderId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iDMATAccountHolderId = nDMATAccountHolderID,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,
                        }).ToList<DMATAccountHolderDTO>();

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
                        return res.FirstOrDefault();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
        }
        #endregion GetDMATHolderDetails

        #region SaveDMATHolder
        /// <summary>
        /// This method is used for save the DMATDetails
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <param name="m_objDMATAccountHolder">DMAT Holder Type Object</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Boolean value based on the result</returns>
        public bool SaveDMATHolderDetails(string sConnectionString, DMATAccountHolderDTO m_objDMATAccountHolderDTO, int nLoggedInUserId)
        {
            bool bReturn = false;
            List<DMATAccountHolderDTO> res = null;
            #region Paramters
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
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<DMATAccountHolderDTO>("exec st_usr_DMATAccountHolderSave @inp_iDMATAccountHolderId, @inp_iDMATDetailsID, @inp_sAccountHolderName, @inp_sPAN, @inp_iRelationTypeCodeId, @inp_iLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iDMATAccountHolderId = m_objDMATAccountHolderDTO.DMATAccountHolderId,
                            inp_iDMATDetailsID = m_objDMATAccountHolderDTO.DMATDetailsID,
                            inp_sAccountHolderName = m_objDMATAccountHolderDTO.AccountHolderName,
                            inp_sPAN = m_objDMATAccountHolderDTO.PAN,
                            inp_iRelationTypeCodeId = m_objDMATAccountHolderDTO.RelationTypeCodeId,
                            inp_iLoggedInUserId = nLoggedInUserId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,

                        }).ToList<DMATAccountHolderDTO>();

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
                        bReturn = false;
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }
                    else
                    {
                        bReturn = true;
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion SaveDMATHolder

        #region DeleteDMATHolder
        /// <summary>
        /// This method is used for delete the DMATDetails
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <param name="inp_iDMATAccountHolderID">DMATAccountHolderID</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Boolean value based on the result</returns>
        public bool DeleteDMATHolder(string i_sConnectionString, int inp_iDMATAccountHolderID, int nLoggedInUserId)
        {
            List<DMATAccountHolderDTO> res = null;
            bool bReturn = false;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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

                using (var db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<DMATAccountHolderDTO>("exec st_usr_DMATAccountHolderDelete @inp_iDMATAccountHolderId, @inp_iUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iDMATAccountHolderId = inp_iDMATAccountHolderID,
                            inp_iUserId = nLoggedInUserId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<DMATAccountHolderDTO>();

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
                        bReturn = false;
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }
                    else
                    {
                        bReturn = true;
                    }
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion DeleteDMATHolder

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
