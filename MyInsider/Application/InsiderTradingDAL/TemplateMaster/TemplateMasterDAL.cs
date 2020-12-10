using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using InsiderTradingDAL;

namespace InsiderTrading
{
    public class TemplateMasterDAL:IDisposable
    {
        const string sLookUpPrefix = "tra_msg_";
         
        #region GetDetails
        public TemplateMasterDTO GetDetails(string sConnectionString, int inp_iTemplateMasterId)
        {    
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
                    using (var scope = db.GetTransaction())
                    {
                     var res = db.Query<TemplateMasterDTO>("exec st_tra_TemplateMasterDetails @inp_iTemplateMasterId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iTemplateMasterId = inp_iTemplateMasterId,
                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage
                        }).Single<TemplateMasterDTO>();   
                        
                        #region Error Values
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookUpPrefix + out_nReturnValue;
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
                        return res;
                    }
                       #endregion Error Values
                    }
                }
            }
            catch(Exception exp)
            {
                 throw exp;
            }
            finally
            {

            }
            
        }
        #endregion GetDetails

        #region Save
        public TemplateMasterDTO SaveDetails(TemplateMasterDTO m_objTemplateMasterDTO, string sConnectionString, int nLoggedInUserId)
        {   
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
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<TemplateMasterDTO>("exec st_tra_TemplateMasterSave @inp_iTemplateMasterId,@inp_sTemplateName ,@inp_iCommunicationModeCodeId ,@inp_iDisclosureTypeCodeId	,@inp_iLetterForCodeId,@inp_bIsActive,@inp_dtDate,@inp_sToAddress1,@inp_sToAddress2,@inp_sSubject,@inp_sContents,@inp_sSignature,@inp_sCommunicationFrom,@inp_sSequenceNo,@inp_bIsCommunicationTemplate,@inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iTemplateMasterId	= m_objTemplateMasterDTO.TemplateMasterId,
		                    @inp_sTemplateName	=m_objTemplateMasterDTO.TemplateName	,
                            @inp_iCommunicationModeCodeId = m_objTemplateMasterDTO.CommunicationModeCodeId,
                            @inp_iDisclosureTypeCodeId = (m_objTemplateMasterDTO.DisclosureTypeCodeId == 0 ? null : m_objTemplateMasterDTO.DisclosureTypeCodeId),
		                    @inp_iLetterForCodeId = (m_objTemplateMasterDTO.LetterForCodeId == 0 ? null :m_objTemplateMasterDTO.LetterForCodeId),
		                    @inp_bIsActive = m_objTemplateMasterDTO.IsActive,
		                    @inp_dtDate = m_objTemplateMasterDTO.Date,
		                    @inp_sToAddress1 = m_objTemplateMasterDTO.ToAddress1,
		                    @inp_sToAddress2 = m_objTemplateMasterDTO.ToAddress2,
		                    @inp_sSubject = m_objTemplateMasterDTO.Subject,
		                    @inp_sContents = m_objTemplateMasterDTO.Contents,
		                    @inp_sSignature = m_objTemplateMasterDTO.Signature,
                            @inp_sCommunicationFrom = m_objTemplateMasterDTO.CommunicationFrom,
                            @inp_sSequenceNo = m_objTemplateMasterDTO.SequenceNo,
                            @inp_bIsCommunicationTemplate = m_objTemplateMasterDTO.IsCommunicationTemplate,
                            @inp_nUserId = nLoggedInUserId,
                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage

                        }).SingleOrDefault<TemplateMasterDTO>();
                        
                        #region Error Values
                         if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookUpPrefix + out_nReturnValue;
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
                        return res;
                    }
                        #endregion Error Values
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
        public bool Delete(string sConnectionString, int nTemplateMasterID, int nLoggedInUserId)
        {  
            #region Paramters
                bool bReturn = false;
                int out_nReturnValue;
                int out_nSQLErrCode;        
                string out_sSQLErrMessage;
                List<TemplateMasterDTO> res= null;
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
                    using (var scope = db.GetTransaction())
                    {
                     res = db.Query<TemplateMasterDTO>("exec st_tra_TemplateMasterDelete @inp_iTemplateMasterId,@inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iTemplateMasterId = nTemplateMasterID,

                            @inp_nUserId = nLoggedInUserId,
                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<TemplateMasterDTO>();

                        #region Error Values
                          if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookUpPrefix + out_nReturnValue;
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
                        scope.Complete();
                        bReturn = true;
                    }
                        #endregion Error Values
                    }   
                }
            }
            catch(Exception exp)
            {
                
                throw exp;
                //return bReturn;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion Delete       
        
        #region GetFAQList
        /// <summary>
        /// This function will be used to query the database to fetch the list of active FAQ.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="i_nUserTypeCodeId">The type of user i.e. for CO or for insider</param>
        /// <param name="inp_iPageSize">Values: 0, give all records. <pageNo>, give records for given page sizePage size</param>
        /// <param name="inp_iPageNo">Page number</param>
        /// <param name="inp_sSortField">The name of the field on which the list showuld be sorted. The name of the field will be as seen in the procedure st_tra_TemplateMasterFAQList.</param>
        /// <param name="inp_sSortOrder">Values: ASC/DESC, The order in which the list should be sorted.</param>
        /// <param name="inp_bForDashboard">Values: 1/0, This parameter will be used to decide if the call is for showing the FAQ list on dashboard or on FAQ List page</param>
        /// <returns></returns>
        public List<FAQDTO> GetFAQList(string sConnectionString, int inp_iUserTypeCodeId, int inp_iPageSize, int inp_iPageNo, string inp_sSortField, string inp_sSortOrder, bool inp_bForDashboard)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int nFAQListFor = 0;
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

                if (inp_bForDashboard)
                {
                    nFAQListFor = 1;
                }
                else
                {
                    nFAQListFor = 2;
                }

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<FAQDTO>("exec st_tra_TemplateMasterFAQList @inp_iListForPage, @inp_iUserTypeCodeId,@inp_iPageSize,@inp_iPageNo,@inp_sSortField,@inp_sSortOrder,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iListForPage = nFAQListFor,
                               @inp_iUserTypeCodeId = inp_iUserTypeCodeId,
                               @inp_iPageSize = inp_iPageSize,
                               @inp_iPageNo = inp_iPageNo,
                               @inp_sSortField = inp_sSortField,
                               @inp_sSortOrder = inp_sSortOrder,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).ToList<FAQDTO>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
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
                            return res;
                        }
                        #endregion Error Values
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
        #endregion GetFAQList

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

        #region GetTransactionLetterDetailsForGroup


        public TemplateMasterDTO GetTransactionLetterDetailsForGroup(string sConnectionString, int nDisclosureTypeCodeId, int nLetterForCodeId)
        {
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
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<TemplateMasterDTO>("exec st_tra_GetTemplateforGroup  @inp_iDisclosureTypeCodeId, @inp_iLetterForCodeId,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iDisclosureTypeCodeId = nDisclosureTypeCodeId,
                               inp_iLetterForCodeId = nLetterForCodeId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage,
                           }).Single<TemplateMasterDTO>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
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
                            return res;
                        }
                        #endregion Error Values
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
        #endregion GetTransactionLetterDetailsForGroup

        #region GetFormETemplate
        public TemplateMasterDTO GetFormETemplate(string sConnectionString)
        {
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
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<TemplateMasterDTO>("exec st_tra_CheckFormE_Template @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).SingleOrDefault<TemplateMasterDTO>();

                        #region Error Values
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
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
                            return res;
                        }
                        #endregion Error Values
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
        #endregion GetFormETemplate
    }
}
