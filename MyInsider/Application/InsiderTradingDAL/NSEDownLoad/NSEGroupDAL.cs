using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

namespace InsiderTradingDAL
{
    public class NSEGroupDAL : IDisposable
    {
        const String sLookupPrefix = "nse_msg_";

        #region Main Group

        #region GetGroupDetails
        /// <summary>
        /// This function will return a list of all the Groups saved in the system database
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<NSEGroupDTO> getGroupsDetails(string i_sConnectionString)
        {
            PetaPoco.Database db = null;
            IEnumerable<NSEGroupDTO> lstGroupList = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstGroupList = db.Query<NSEGroupDTO>("exec st_tra_GetGroupDetails ",
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
            return lstGroupList;
        }
        #endregion GetGroupDetails

        #region GetSingleGroupDetails
        /// <summary>
        /// This function will return a list of all the Group saved in the system database
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public NSEGroupDTO GetSingleGroupDetails(string i_sConnectionString, int i_sGroupId)
        {
            PetaPoco.Database db = null;
            NSEGroupDTO objGroupobject = new NSEGroupDTO();
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objGroupobject = db.Query<NSEGroupDTO>("exec st_tra_GetGroupDetails @inp_iGroupID",
                             new
                             {
                                 inp_iGroupID = i_sGroupId
                             }).Single<NSEGroupDTO>();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objGroupobject;
        }
        #endregion GetSingleGroupDetails
        #endregion  Main Company
        #region Save
        /// <summary>
        /// This method is used to save Group Master entries.
        /// <param name="sConnectionString">DB Connection String</param>
        /// <param name="m_objGroupDTO">NSEGroupDTO objects</param>
        /// <returns>if save then return true else return false</returns>
        public IEnumerable<NSEGroupDTO> SaveGroup(string i_sConnectionString, NSEGroupDTO m_objGroupDTO)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            bool bReturn = false;
            PetaPoco.Database db = null;
            #endregion Paramters

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

            IEnumerable<NSEGroupDTO> lstGroup = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstGroup = db.Query<NSEGroupDTO>("exec st_mst_GroupSave @GroupId OUTPUT,@DownloadedDate,@SubmissionDate,@StatusCodeId,@TypeOfDownload,@DownloadStatus,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                         new
                         {
                             GroupId = m_objGroupDTO.GroupId,
                             DownloadedDate = DateTime.Now,//m_objGroupDTO.DownloadedDate,
                             SubmissionDate = m_objGroupDTO.SubmissionDate,
                             StatusCodeId = 508006,
                             TypeOfDownload = m_objGroupDTO.TypeOfDownload,
                             DownloadStatus = false,
                             inp_iLoggedInUserId = m_objGroupDTO.LoggedInUserId,
                             out_nReturnValue = 1,
                             out_nSQLErrCode = 1,
                             out_sSQLErrMessage = string.Empty
                         }).ToList();

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
                        #endregion Error Values
                        return lstGroup;
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion Save

        #region Update
        /// <summary>
        /// This method is used to Update Group Master entries.
        /// <param name="sConnectionString">DB Connection String</param>
        /// <param name="m_objGroupDTO">NSEGroupDTO objects</param>
        /// <returns>if update then return true else return false</returns>
        public bool UpdateGroup(string i_sConnectionString, NSEGroupDTO m_objGroupDTO)
        {
            #region Paramters
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
                        var res = db.Query<NSEGroupDTO>("exec st_mst_GroupSave @GroupId,@DownloadedDate,@SubmissionDate,@StatusCodeId,@TypeOfDownload,@DownloadStatus,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                GroupId = m_objGroupDTO.GroupId,
                                DownloadedDate = m_objGroupDTO.DownloadedDate,
                                SubmissionDate = m_objGroupDTO.SubmissionDate,
                                StatusCodeId = m_objGroupDTO.StatusCodeId,
                                TypeOfDownload = m_objGroupDTO.TypeOfDownload,
                                DownloadStatus = m_objGroupDTO.DownloadStatus,
                                inp_iLoggedInUserId = m_objGroupDTO.LoggedInUserId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage
                            }).SingleOrDefault<NSEGroupDTO>();

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
                        return bReturn;
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {

                throw exp;
            }
        }
        #endregion Update

        #region SaveGroupDetails
        /// <summary>
        /// This method is used to save Group details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objNSEGroupDetailsDTO">Object of NSEGroupDetailsDTO</param>
        /// <returns></returns>
        public IEnumerable<NSEGroupDetailsDTO> SaveGroupDetails(string i_sConnectionString, NSEGroupDetailsDTO m_objNSEGroupDetailsDTO)
        {

            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            bool bReturn = false;
            PetaPoco.Database db = null;
            #endregion Paramters
            IEnumerable<NSEGroupDetailsDTO> lstGroupDetails = null;

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
                        lstGroupDetails = db.Query<NSEGroupDetailsDTO>("exec st_tra_GroupDetailsSave @GroupId ,@UserInfoId,@TransactionMasterId, @inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                         new
                         {
                             GroupId = m_objNSEGroupDetailsDTO.GroupId,
                             TransactionMasterId = m_objNSEGroupDetailsDTO.TransactionMasterId,
                             UserInfoId = m_objNSEGroupDetailsDTO.UserInfoId,
                             inp_iLoggedInUserId = m_objNSEGroupDetailsDTO.LoggedInUserId,
                             out_nReturnValue = nReturnValue,
                             out_nSQLErrCode = nSQLErrCode,
                             out_sSQLErrMessage = sSQLErrMessage
                         }).ToList();


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
                        return lstGroupDetails;
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion SaveGroupeDetails

        #region DeleteGroupDetails
        /// <summary>
        /// This method is used to delete Group details
        /// </summary>
        /// <param name="sConnectionString">DB COnnection string</param>
        /// <param name="m_objNSEGroupDetailsDTO">NSEGroupDetailsDTO object</param>
        /// <returns>if delete return true else false</returns>
        public bool Delete(string i_sConnectionString, NSEGroupDetailsDTO m_objNSEGroupDetailsDTO)
        {
            #region Paramters
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
                sSQLErrMessage.Size = 9000000;
                sSQLErrMessage.Value = "";
                #endregion Out Paramter

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        var res = db.Query<ImplementedCompanyDTO>("exec st_tra_DeleteGroupDetails @i_TransactionMasterId,@inp_iUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                i_TransactionMasterId = m_objNSEGroupDetailsDTO.TransactionMasterId,
                                inp_iUserId = m_objNSEGroupDetailsDTO.LoggedInUserId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage
                            }).ToList();

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
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;

            }
            return bReturn;
        }
        #endregion DeleteGroupDetails

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

        #region SaveNSEDocuments
        public bool SaveNSEDocument(string i_sConnectionString, NSEGroupDocumentMappingDTO m_objGroupDocumentDTO, string GUID)
        {
            #region Paramters
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
                        var res = db.Query<NSEGroupDTO>("exec st_tra_SaveNSEDocument @NSEGroupDetailsId, @inp_iDocumentDetailsID,@inp_iDocumentObjctMapId,@inp_sGUID, @inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                                                       new
                                                       {
                                                           NSEGroupDetailsId = m_objGroupDocumentDTO.NSEGroupDetailsId,
                                                           inp_iDocumentDetailsID = 0,
                                                           @inp_sGUID = GUID,
                                                           inp_iDocumentObjctMapId = m_objGroupDocumentDTO.DocumentObjectMapId,
                                                           inp_iLoggedInUserId = m_objGroupDocumentDTO.LoggedInUserId,
                                                           out_nReturnValue = 1,
                                                           out_nSQLErrCode = 1,
                                                           out_sSQLErrMessage = string.Empty
                                                       }).SingleOrDefault<NSEGroupDTO>();

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
                        return bReturn;
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {

                throw exp;
            }
        }
        #endregion SaveNSEDocuments

        #region GetGroupDetails
        /// <summary>
        /// This function will return a list of all the Groups saved in the system database
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<NSEGroupDocumentMappingDTO> GetNSEDocumentDetails(string i_sConnectionString, int i_sGroupId, int UserInfoIdCheck)
        {
            PetaPoco.Database db = null;

            IEnumerable<NSEGroupDocumentMappingDTO> lstGroupDocumentList = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstGroupDocumentList = db.Query<NSEGroupDocumentMappingDTO>("exec st_tra_GetNSEDocumentDetails @inp_iGroupID,@inp_UserInfoCheck",
                         new
                         {
                             inp_iGroupID = i_sGroupId,
                             inp_UserInfoCheck=UserInfoIdCheck
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstGroupDocumentList;
        }
        #endregion GetGroupDetails

        #region GetSingleNSEDocumentDetails
        /// <summary>
        /// This function will return a list of all the Groups saved in the system database
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<NSEGroupDocumentMappingDTO> GetSingleNSEDocumentDetails(string i_sConnectionString, int i_TransactionMasterId)
        {
            PetaPoco.Database db = null;

            IEnumerable<NSEGroupDocumentMappingDTO> lstSingleDocumentList = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstSingleDocumentList = db.Query<NSEGroupDocumentMappingDTO>("exec st_tra_GetFileDetails @i_TransactionMasterId",
                         new
                         {
                             i_TransactionMasterId = i_TransactionMasterId
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstSingleDocumentList;
        }
        #endregion GetSingleNSEDocumentDetails

        #region GetGroupwiseTransactionId
        /// <summary>
        /// This function will return specific groupwise transaction Id
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<NSEGroupDetailsDTO> GetGroupwiseTransactionId(string i_sConnectionString, int i_sGroupId)
        {
            PetaPoco.Database db = null;

            IEnumerable<NSEGroupDetailsDTO> lstTransIdList = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstTransIdList = db.Query<NSEGroupDetailsDTO>("exec st_tra_GetTransactionId @inp_iGroupID",
                         new
                         {
                             inp_iGroupID = i_sGroupId
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstTransIdList;
        }
        #endregion GetGroupwiseTransactionId

        #region GetdownloadSubmissionDate
        /// <summary>
        /// This function will return Download and Submission date
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<NSEGroupDTO> GetgroupDate(string i_sConnectionString, int i_sGroupId)
        {
            PetaPoco.Database db = null;

            IEnumerable<NSEGroupDTO> lstgrpDate = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstgrpDate = db.Query<NSEGroupDTO>("exec st_tra_GetgroupDate @inp_iGroupID",
                         new
                         {
                             inp_iGroupID = i_sGroupId
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstgrpDate;
        }
        #endregion GetdownloadSubmissionDate

        #region GetGroupId
        /// <summary>
        /// This function will return Group Id
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<NSEGroupDetailsDTO>GetgroupId(string i_sConnectionString, int i_UserInfoId, int i_TransMasterId)
        {
            PetaPoco.Database db = null;

            IEnumerable<NSEGroupDetailsDTO> lstgrpId = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstgrpId = db.Query<NSEGroupDetailsDTO>("exec st_tra_GetgroupId @inp_UserInfoId,@inp_TransMasterId",
                         new
                         {
                             inp_UserInfoId = i_UserInfoId,
                             inp_TransMasterId=i_TransMasterId
                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstgrpId;
        }
        #endregion GetGroupId
    }
}
