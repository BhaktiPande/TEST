using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace InsiderTradingDAL
{
    public class PolicyDocumentDAL:IDisposable
    {
        const string sLookUpPrefix = "rul_msg_";
         
        #region GetDetails
        /// <summary>
        /// This method is used to get policy document details 
        /// </summary>
        /// <param name="sConnectionString">db connection string</param>
        /// <param name="inp_iPolicyDocumentId">policy document id</param>
        /// <returns></returns>
        public PolicyDocumentDTO GetDetails(string sConnectionString, int inp_iPolicyDocumentId)
        {
            #region Paramters
                
                int out_nReturnValue;
                int out_nSQLErrCode;        
                string out_sSQLErrMessage;
                PolicyDocumentDTO res= null;
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

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                     res = db.Query<PolicyDocumentDTO>("exec st_rul_PolicyDocumentDetails @inp_iPolicyDocumentId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iPolicyDocumentId = inp_iPolicyDocumentId,

                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage
                        }).SingleOrDefault<PolicyDocumentDTO>();   
                        
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
            return res;
            
        }
        #endregion GetDetails

        #region Save
        /// <summary>
        /// This method is used to save (insert/update) policy document details
        /// </summary>
        /// <param name="sConnectionString">db connection string</param>
        /// <param name="m_objPolicyDocumentDTO">policy document DTO</param>
        /// <returns></returns>
        public PolicyDocumentDTO SaveDetails(string sConnectionString, PolicyDocumentDTO m_objPolicyDocumentDTO)
        {
            #region Paramters
            
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PolicyDocumentDTO res = null;
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

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<PolicyDocumentDTO>("exec st_rul_PolicyDocumentSave @inp_iPolicyDocumentId,@inp_sPolicyDocumentName,@inp_iDocumentCategoryCodeId,@inp_iDocumentSubCategoryCodeId,@inp_dtApplicableFrom,@inp_dtApplicableTo,@inp_iCompanyId,@inp_bDisplayInPolicyDocumentFlag,@inp_bSendEmailUpdateFlag,@inp_bDocumentViewFlag,@inp_bDocumentViewAgreeFlag,@inp_iWindowStatusCodeId,@inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iPolicyDocumentId = m_objPolicyDocumentDTO.PolicyDocumentId,
                               @inp_sPolicyDocumentName = m_objPolicyDocumentDTO.PolicyDocumentName,
                               @inp_iDocumentCategoryCodeId = m_objPolicyDocumentDTO.DocumentCategoryCodeId,
                               @inp_iDocumentSubCategoryCodeId = m_objPolicyDocumentDTO.DocumentSubCategoryCodeId,
                               @inp_dtApplicableFrom = m_objPolicyDocumentDTO.ApplicableFrom,
                               @inp_dtApplicableTo = m_objPolicyDocumentDTO.ApplicableTo,
                               @inp_iCompanyId = m_objPolicyDocumentDTO.CompanyId,
                               @inp_bDisplayInPolicyDocumentFlag = m_objPolicyDocumentDTO.DisplayInPolicyDocumentFlag,
                               @inp_bSendEmailUpdateFlag = m_objPolicyDocumentDTO.SendEmailUpdateFlag,
                               @inp_bDocumentViewFlag = m_objPolicyDocumentDTO.DocumentViewFlag,
                               @inp_bDocumentViewAgreeFlag = m_objPolicyDocumentDTO.DocumentViewAgreeFlag,
                               @inp_iWindowStatusCodeId = m_objPolicyDocumentDTO.WindowStatusCodeId,

                               @inp_nUserId = m_objPolicyDocumentDTO.LoggedInUserId,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<PolicyDocumentDTO>();

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
            return res;
        }
        #endregion Save

        #region Delete
        /// <summary>
        /// This method is used to delete policy document and related information ie uploaded document and email upload
        /// </summary>
        /// <param name="sConnectionString">db connection string</param>
        /// <param name="nPolicyDocumentID">policy document id</param>
        /// <param name="nLoggedInUserID">logged in user id</param>
        /// <returns></returns>
        public bool Delete(string sConnectionString, int nPolicyDocumentID, int nLoggedInUserID)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PolicyDocumentDTO res = null;
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

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<PolicyDocumentDTO>("exec st_rul_PolicyDocumentDelete @inp_iPolicyDocumentId,@inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iPolicyDocumentId = nPolicyDocumentID,

                               @inp_nUserId = nLoggedInUserID,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<PolicyDocumentDTO>();

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
            catch (Exception exp)
            {
                //return bReturn;
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion Delete

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
