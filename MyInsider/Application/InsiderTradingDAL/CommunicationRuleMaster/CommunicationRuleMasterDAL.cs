using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace InsiderTrading
{
    public class CommunicationRuleMasterDAL:IDisposable
    {
        const string sLookUpPrefix = "";
         
        #region GetDetails
        public CommunicationRuleMasterDTO GetDetails(string sConnectionString, int inp_iCommunicationRuleMasterId)
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
                     var res = db.Query<CommunicationRuleMasterDTO>("exec st_cmu_CommunicationRuleMasterDetails @inp_iRuleId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iRuleId = inp_iCommunicationRuleMasterId,

                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage
                        }).Single<CommunicationRuleMasterDTO>();   
                        
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
        public CommunicationRuleMasterDTO SaveDetails(CommunicationRuleMasterDTO objCommunicationRuleMasterDTO, DataTable tblCommunicationRuleModeMasterType, string sConnectionString, int nLoggedInUserId)
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
                var inp_tblCommunicationRuleModeMasterType = new SqlParameter();
                inp_tblCommunicationRuleModeMasterType.DbType = DbType.Object;
                inp_tblCommunicationRuleModeMasterType.ParameterName = "@inp_tblCommunicationRuleModeMasterType";
                inp_tblCommunicationRuleModeMasterType.TypeName = "dbo.CommunicationRuleModeMasterType";
                inp_tblCommunicationRuleModeMasterType.SqlValue = tblCommunicationRuleModeMasterType;
                inp_tblCommunicationRuleModeMasterType.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<CommunicationRuleMasterDTO>("exec st_cmu_CommunicationRuleMasterSave @inp_tblCommunicationRuleModeMasterType,@inp_iRuleId,@inp_sRuleName,@inp_sRuleDescription,@inp_sRuleForCodeId,@inp_iRuleCategoryCodeId,@inp_sInsiderPersonalizeFlag,@inp_sTriggerEventCodeId,@inp_sOffsetEventCodeId,@inp_iEventsApplyToCodeId,@inp_iRuleStatusCodeId,@inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_tblCommunicationRuleModeMasterType = inp_tblCommunicationRuleModeMasterType,
                            @inp_iRuleId = objCommunicationRuleMasterDTO.RuleId,
                            @inp_sRuleName = objCommunicationRuleMasterDTO.RuleName,
                            @inp_sRuleDescription = objCommunicationRuleMasterDTO.RuleDescription,
                            @inp_sRuleForCodeId = objCommunicationRuleMasterDTO.RuleForCodeId,
                            @inp_iRuleCategoryCodeId = objCommunicationRuleMasterDTO.RuleCategoryCodeId,
                            @inp_sInsiderPersonalizeFlag = objCommunicationRuleMasterDTO.InsiderPersonalizeFlag,
                            @inp_sTriggerEventCodeId = objCommunicationRuleMasterDTO.TriggerEventCodeId,
                            @inp_sOffsetEventCodeId = objCommunicationRuleMasterDTO.OffsetEventCodeId,
                            @inp_iEventsApplyToCodeId = (objCommunicationRuleMasterDTO.EventsApplyToCodeId == 0 ? null : objCommunicationRuleMasterDTO.EventsApplyToCodeId),
                            @inp_iRuleStatusCodeId = objCommunicationRuleMasterDTO.RuleStatusCodeId,

                            @inp_nUserId = nLoggedInUserId,
                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage

                        }).SingleOrDefault<CommunicationRuleMasterDTO>();
                        
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
        public CommunicationRuleMasterDTO Delete(string sConnectionString, int nLoggedInUserId, int nCommunicationRuleMasterID)
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
                     var res = db.Query<CommunicationRuleMasterDTO>("exec st_cmu_CommunicationRuleMasterDelete @inp_iRuleId,@inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_iRuleId = nCommunicationRuleMasterID,

                            @inp_nUserId = nLoggedInUserId,
                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage

                        }).Single<CommunicationRuleMasterDTO>(); 

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
