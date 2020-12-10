using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;
using System.Data.SqlClient;

namespace InsiderTradingDAL.InsiderInitialDisclosure
{
    public class InsiderInitialDisclosureDAL : IDisposable
    {
        string sLookUpPrefix = "dis_msg_";

        #region SaveEvent
        public bool SaveEvent(string sConnectionString, UserPolicyDocumentEventLogDTO m_objUserPolicyDocumentEventLogDTO, int nLoggedInUserId)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<InsiderInitialDisclosureDTO> res = null;
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
                sSQLErrMessage.Size = 500;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<InsiderInitialDisclosureDTO>("exec st_eve_EventLogSave @inp_iEventCodeId,@inp_iMapToTypeCodeId,@inp_iMapToid,@inp_iUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iEventCodeId = m_objUserPolicyDocumentEventLogDTO.EventCodeId,
                               @inp_iMapToTypeCodeId = m_objUserPolicyDocumentEventLogDTO.MapToTypeCodeId,
                               @inp_iMapToid = m_objUserPolicyDocumentEventLogDTO.MapToId,
                               @inp_iUserId = nLoggedInUserId,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).ToList<InsiderInitialDisclosureDTO>();

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
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion SaveEvent

        #region SaveReconfirmation
        public bool SaveReconfirmation(string sConnectionString, int UserInfoId, int nLoggedInUserId)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<InsiderInitialDisclosureDTO> res = null;
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
                sSQLErrMessage.Size = 500;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<InsiderInitialDisclosureDTO>("exec st_usr_Reconfirmation @inp_iUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iUserId = nLoggedInUserId,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).ToList<InsiderInitialDisclosureDTO>();

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
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion SaveEvent

        #region GetDocumentDetails
        public UsersPolicyDocumentDTO GetDocumentDetails(string sConnectionString, int PolicyDocumentID, int DocumentID)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            UsersPolicyDocumentDTO res = null;
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
                sSQLErrMessage.Size = 500;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<UsersPolicyDocumentDTO>("exec st_rul_UsersPolicyDocumentDetails @inp_iPolicyDocumentId,@inp_iDocumentId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iPolicyDocumentId = PolicyDocumentID,
                               @inp_iDocumentId = DocumentID,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).Single<UsersPolicyDocumentDTO>();

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
        #endregion GetDocumentDetails

        #region GetDashBoardDetails
        public IEnumerable<InsiderInitialDisclosureDTO> GetDashBoardDetails(string sConnectionString, int UserInfoID, int UserTypeCodeID)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<InsiderInitialDisclosureDTO> res = null;
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
                sSQLErrMessage.Size = 500;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<InsiderInitialDisclosureDTO>("exec st_tra_InitialDisclosureStatusForUser_Employee @inp_iUserInfoID,@inp_iUserTypeID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iUserInfoID = UserInfoID,
                               @inp_iUserTypeID = UserTypeCodeID,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).ToList<InsiderInitialDisclosureDTO>();

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
        #endregion GetDashBoardDetails

        #region GetDashBoardDetailsInsider
        public IEnumerable<InsiderInitialDisclosureDTO> GetDashBoardDetailsInsider(string sConnectionString, int UserInfoID,int UserTypeCodeID)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<InsiderInitialDisclosureDTO> res = null;
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
                sSQLErrMessage.Size = 500;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<InsiderInitialDisclosureDTO>("exec st_tra_InitialDisclosureStatusForUser_Insider @inp_iUserInfoID,@inp_iUserTypeID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iUserInfoID = UserInfoID,
                               @inp_iUserTypeID = UserTypeCodeID,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).ToList<InsiderInitialDisclosureDTO>();

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
        #endregion GetDashBoardDetailsInsider

        //FOR OTHER SECURITIES EMPLOYEE
        #region GetDashBoardDetails_OS
        public IEnumerable<InsiderInitialDisclosureDTO> GetDashBoardDetails_OS(string sConnectionString, int UserInfoID, int UserTypeCodeID)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<InsiderInitialDisclosureDTO> res = null;
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
                sSQLErrMessage.Size = 500;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<InsiderInitialDisclosureDTO>("exec st_tra_InitialDisclosureStatusForUser_Employee_OS @inp_iUserInfoID,@inp_iUserTypeID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iUserInfoID = UserInfoID,
                               @inp_iUserTypeID = UserTypeCodeID,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).ToList<InsiderInitialDisclosureDTO>();

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
        #endregion GetDashBoardDetails_OS

        #region GetDashBoardDetailsInsider_OS
        public IEnumerable<InsiderInitialDisclosureDTO> GetDashBoardDetailsInsider_OS(string sConnectionString, int UserInfoID, int UserTypeCodeID)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<InsiderInitialDisclosureDTO> res = null;
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
                sSQLErrMessage.Size = 500;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<InsiderInitialDisclosureDTO>("exec st_tra_InitialDisclosureStatusForUser_Insider_OS @inp_iUserInfoID,@inp_iUserTypeID, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iUserInfoID = UserInfoID,
                               @inp_iUserTypeID = UserTypeCodeID,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).ToList<InsiderInitialDisclosureDTO>();

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
        #endregion GetDashBoardDetailsInsider_OS



        #region GetDashBoardInsiderCount
        public InsiderInitialDisclosureCountDTO GetDashBoardInsiderCount(string sConnectionString)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            InsiderInitialDisclosureCountDTO res = null;
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
                sSQLErrMessage.Size = 500;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<InsiderInitialDisclosureCountDTO>("exec st_tra_InitialDisclosureDashBoardForCO @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).FirstOrDefault<InsiderInitialDisclosureCountDTO>();

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
        #endregion GetDashBoardInsiderCount

        #region GetInitialDisclosureDetails
        public IEnumerable<InsiderInitialDisclosureDTO> GetInitialDisclosureDetails(string sConnectionString, int UserInfoID)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<InsiderInitialDisclosureDTO> res = null;
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
                sSQLErrMessage.Size = 500;
                #endregion Out Paramter

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<InsiderInitialDisclosureDTO>("exec st_tra_InitialDisclosureDetails @inp_iUserInfoID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iUserInfoID = UserInfoID,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).ToList<InsiderInitialDisclosureDTO>();

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
        #endregion GetInitialDisclosureDetails

        #region Get_mst_company_details
        /// <summary>
        /// This function will Get mst_company details
        /// </summary>
        /// <returns></returns>
        public InsiderInitialDisclosureDTO Get_mst_company_details(string inp_sConnectionString)
        {
            PetaPoco.Database db = null;
            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDTO();
            try
            {
                using (db = new PetaPoco.Database(inp_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objInsiderInitialDisclosureDAL = db.Query<InsiderInitialDisclosureDTO>("exec st_com_mst_Company_Details",
                             new
                             {
                                 
                             }).Single<InsiderInitialDisclosureDTO>();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objInsiderInitialDisclosureDAL;
        }
        #endregion Get_mst_company_details

        #region Get Form B OS Details

        public FormBDetails_OSDTO GetFormBOSDetails(string i_sConnectionString, int i_nMapToTypeCodeId, int i_nMapToId)
        {
            FormBDetails_OSDTO res = null;

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
                        res = db.Query<FormBDetails_OSDTO>("exec st_tra_GetGeneratedFormBDetails_OS @inp_iMapToTypeCodeId,@inp_iMapToId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                @inp_iMapToTypeCodeId = i_nMapToTypeCodeId,
                                @inp_iMapToId = i_nMapToId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<FormBDetails_OSDTO>();

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
                    }
                }


            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion Get Form B OS Details
        #region Get_TradingPolicyID_forOS
        /// <summary>
        /// This function will Get mst_company details
        /// </summary>
        /// <returns></returns>
        public InsiderInitialDisclosureDTO st_tra_GetTradingPolicyIDfor_OS(string inp_sConnectionString, int UserInfoID)
        {
            PetaPoco.Database db = null;
            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDAL = new InsiderInitialDisclosureDTO();
            try
            {
                using (db = new PetaPoco.Database(inp_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objInsiderInitialDisclosureDAL = db.Query<InsiderInitialDisclosureDTO>("exec st_tra_GetTradingPolicyIDfor_OS @inp_iUserInfoId",
                             new
                             {
                                 inp_iUserInfoId = UserInfoID
                             }).Single<InsiderInitialDisclosureDTO>();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objInsiderInitialDisclosureDAL;
        }
        #endregion Get_TradingPolicyID_forOS

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
