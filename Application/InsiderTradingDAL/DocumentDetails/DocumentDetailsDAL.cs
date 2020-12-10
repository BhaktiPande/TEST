using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class DocumentDetailsDAL:IDisposable
    {
        const String sLookupPrefix = "usr_msg_";
        #region GetDetails
        public DocumentDetailsDTO GetDocumentDetails(string sConnectionString, int nDocumentDetailsID)
        {
            List<DocumentDetailsDTO> res = null;
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
                    res = db.Query<DocumentDetailsDTO>("exec st_com_DocumentDetails @inp_iDocumentDetailsID, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iDocumentDetailsID = nDocumentDetailsID,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,
                        }).ToList<DocumentDetailsDTO>();

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
        /// This method is used for the insert/Update Document details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="m_objDocumentDetailsDTO">DocumentDetailsID to delete</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Returns boolean value based on the result</returns>
        public DocumentDetailsDTO SaveDocumentDetails(string sConnectionString, DocumentDetailsDTO m_objDocumentDetailsDTO, int nLoggedInUserId)
        {
            List<DocumentDetailsDTO> res = null;
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
                    res = db.Query<DocumentDetailsDTO>("exec st_com_DocumentSave @inp_iDocumentDetailsID, @inp_sGUID, @inp_sDocumentName, @inp_sDescription, @inp_sDocumentPath, @inp_sFileSize, @inp_sFileType, @inp_iMapToTypeCodeId, @inp_iMapToId, @inp_iPurposeCodeId, @inp_iLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iDocumentDetailsID = m_objDocumentDetailsDTO.DocumentId,
                            inp_sGUID = m_objDocumentDetailsDTO.GUID,
                            inp_sDocumentName = m_objDocumentDetailsDTO.DocumentName,
                            inp_sDescription = m_objDocumentDetailsDTO.Description,
                            inp_sDocumentPath = m_objDocumentDetailsDTO.DocumentPath,
                            inp_sFileSize = m_objDocumentDetailsDTO.FileSize,
                            inp_sFileType = m_objDocumentDetailsDTO.FileType,
                            inp_iMapToTypeCodeId = m_objDocumentDetailsDTO.MapToTypeCodeId,
                            inp_iMapToId = m_objDocumentDetailsDTO.MapToId,
                            inp_iPurposeCodeId = m_objDocumentDetailsDTO.PurposeCodeId,
                            inp_iLoggedInUserId = nLoggedInUserId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage
                        }).ToList<DocumentDetailsDTO>();

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
        /// This method is used to delete the Document
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="inp_iDocumentDetailsID">DocumentDetailsID to delete</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Returns boolean value based on the result</returns>
        public bool DeleteDocumentDetails(string sConnectionString, int inp_iDocumentDetailsID, int nLoggedInUserId, int i_nMapToTypeCodeId, int i_nMapToId, int i_nPurposeCodeId = 0)
        {
            bool bReturn = false;
            List<DocumentDetailsDTO> res = null;
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
                    res = db.Query<DocumentDetailsDTO>("exec st_com_DocumentDelete @inp_iDocumentDetailsID, @inp_iUserId, @inp_iMapToTypeCodeId, @inp_iMapToId, @inp_iPurposeCodeId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iDocumentDetailsID = inp_iDocumentDetailsID,
                            inp_iUserId = nLoggedInUserId,
                            inp_iMapToTypeCodeId = i_nMapToTypeCodeId,
                            inp_iMapToId = i_nMapToId,
                            inp_iPurposeCodeId = i_nPurposeCodeId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage
                        }).ToList<DocumentDetailsDTO>();

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

        #region GetDetails
        public List<DocumentDetailsDTO> GetDocumentListNonGrid(string sConnectionString, int nMapToTypeCodeId, int nMapToId, int nPurposeCodeId)
        {
            List<DocumentDetailsDTO> res = null;
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
                    res = db.Query<DocumentDetailsDTO>("exec st_com_DocumentListNonGrid @inp_iMapToTypeCodeId, @inp_iMapToId, @inp_iPurposeCodeId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iMapToTypeCodeId = nMapToTypeCodeId,
                            inp_iMapToId = nMapToId,
                            inp_iPurposeCodeId = nPurposeCodeId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,
                        }).ToList<DocumentDetailsDTO>();

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
                        return res;
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

        #region GetDocumentCount
        public int GetDocumentCount(string sConnectionString, int nMapToTypeCodeId, int nMapToId)
        {
            int res = 0;
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
                    res = db.Query<int>("exec st_com_DocumentCount @inp_iMapToTypeCodeId, @inp_iMapToId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iMapToTypeCodeId = nMapToTypeCodeId,
                            inp_iMapToId = nMapToId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,
                        }).Single<int>();

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
                        return res;
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
        #endregion GetDocumentCount

        #region GetFormFDocumentId
        public int GetFormFDocumentId(string sConnectionString, int nMapToTypeCodeId, int nPurposeCodeId)
        {
            int res = 0;
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
                    res = db.Query<int>("exec st_com_FormFDocumentId @inp_iMapToTypeCodeId, @inp_iPurposeCodeId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iMapToTypeCodeId = nMapToTypeCodeId,
                            inp_iPurposeCodeId = nPurposeCodeId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage,
                        }).Single<int>();

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
                        return res;
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
        #endregion GetFormFDocumentId

        public DocumentDetailsDTO SaveFormGDocumentDetails(string sConnectionString, DocumentDetailsDTO m_objDocumentDetailsDTO, int nLoggedInUserId)
        {
            List<DocumentDetailsDTO> res = null;
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
                    res = db.Query<DocumentDetailsDTO>("exec st_com_DocumentSave @inp_iDocumentDetailsID, @inp_sGUID, @inp_sDocumentName, @inp_sDescription, @inp_sDocumentPath, @inp_sFileSize, @inp_sFileType, @inp_iMapToTypeCodeId, @inp_iMapToId, @inp_iPurposeCodeId, @inp_iLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iDocumentDetailsID = m_objDocumentDetailsDTO.DocumentId,
                            inp_sGUID = m_objDocumentDetailsDTO.GUID,
                            inp_sDocumentName = m_objDocumentDetailsDTO.DocumentName,
                            inp_sDescription = m_objDocumentDetailsDTO.Description,
                            inp_sDocumentPath = m_objDocumentDetailsDTO.DocumentPath,
                            inp_sFileSize = m_objDocumentDetailsDTO.FileSize,
                            inp_sFileType = m_objDocumentDetailsDTO.FileType,
                            inp_iMapToTypeCodeId = m_objDocumentDetailsDTO.MapToTypeCodeId,
                            inp_iMapToId = m_objDocumentDetailsDTO.MapToId,
                            inp_iPurposeCodeId = m_objDocumentDetailsDTO.PurposeCodeId,
                            inp_iLoggedInUserId = nLoggedInUserId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage
                        }).ToList<DocumentDetailsDTO>();

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
    }
}
