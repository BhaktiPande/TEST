using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using InsiderTradingDAL;

namespace InsiderTradingDAL
{
    public class ComCodeDAL:IDisposable
    {
        const string sLookUpPrefix = "mst_msg_";

        #region GetDetails
        public ComCodeDTO GetDetails(string sConnectionString, int inp_iCodeId)
        {
            #region Paramters            
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            ComCodeDTO res = null;
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
                        res = db.Query<ComCodeDTO>("exec st_com_CodeDetails @inp_iCodeID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iCodeID = inp_iCodeId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).Single<ComCodeDTO>();

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
        #endregion GetDetails

        #region Save
        public ComCodeDTO SaveDetails(string sConnectionString, ComCodeDTO m_objComCodeDTO)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            ComCodeDTO res = null;
            #endregion Paramters
            
            bool isSave = true; //flag to check if allow to save records 

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

                //check if Code is set visible false then check code is already used in other table by delete and rollback delete tranascation 
                //if delete is sucessful then allow to set code visible false else show error that code can't be set false
                if (m_objComCodeDTO.CodeID != 0 && !m_objComCodeDTO.IsVisible)
                {
                    var nReturnValue2 = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                    nReturnValue2.Direction = System.Data.ParameterDirection.Output;
                    nReturnValue2.Value = 0;
                    var nSQLErrCode2 = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                    nSQLErrCode2.Direction = System.Data.ParameterDirection.Output;
                    nSQLErrCode2.Value = 0;
                    var sSQLErrMessage2 = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                    sSQLErrMessage2.Direction = System.Data.ParameterDirection.Output;
                    sSQLErrMessage2.Value = "";

                    using (var db2 = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                    {
                        using (var scope2 = db2.GetTransaction())
                        {
                            res = db2.Query<ComCodeDTO>("exec st_com_CodeDelete @inp_iCodeID,@inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                               new
                               {
                                   @inp_iCodeID = m_objComCodeDTO.CodeID,
                                   @inp_nUserId = m_objComCodeDTO.LoggedInUserId,
                                   @out_nReturnValue = nReturnValue2,
                                   @out_nSQLErrCode = nSQLErrCode2,
                                   @out_sSQLErrMessage = sSQLErrMessage2

                               }).SingleOrDefault<ComCodeDTO>();

                            if (Convert.ToInt32(nReturnValue2.Value) != 0)
                            {
                                // return value is not 0 means there is reference key on other table and can't delete 
                                // so do NOT allow user to change visibility of code
                                isSave = false;

                                out_nReturnValue = 10052; //error msg - Cannot set code to invisible because code is already in use

                                string sReturnValue = sLookUpPrefix + out_nReturnValue;

                                Exception e = new Exception();
                                e.Data[0] = sReturnValue;

                                //if (nSQLErrCode.Value != System.DBNull.Value)
                                //{
                                //    out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                //    e.Data[1] = out_nSQLErrCode;
                                //}

                                //if (sSQLErrMessage.Value != System.DBNull.Value)
                                //{
                                //    out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                //    e.Data[2] = out_sSQLErrMessage;
                                //}

                                Exception ex = new Exception(db2.LastSQL.ToString(), e);
                                throw ex;
                            }
                            else
                            {
                                // return value is 0 means DB records can be deleted and there is no dependencey on code
                                // so allow user to change visibility of code
                                isSave = true;
                            }
                        }
                    }
                }

                //check flag to save or not 
                if (isSave)
                {
                    using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                    {
                        using (var scope = db.GetTransaction())
                        {
                             res = db.Query<ComCodeDTO>("exec st_com_CodeSave @inp_iCodeID,@inp_sCodeName,@inp_iCodeGroupId,@inp_sDescription,@inp_bIsVisible,@inp_bIsActive,@inp_sDisplayCode,@inp_iParentCodeId,@inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                               new
                               {
                                   @inp_iCodeID = m_objComCodeDTO.CodeID,
                                   @inp_sCodeName = m_objComCodeDTO.CodeName,
                                   @inp_iCodeGroupId = m_objComCodeDTO.CodeGroupId,
                                   @inp_sDescription = m_objComCodeDTO.Description,
                                   @inp_bIsVisible = m_objComCodeDTO.IsVisible,
                                   @inp_bIsActive = m_objComCodeDTO.IsActive,
                                   @inp_sDisplayCode = m_objComCodeDTO.DisplayCode,
                                   @inp_iParentCodeId = m_objComCodeDTO.ParentCodeId,
                                   @inp_nUserId = m_objComCodeDTO.LoggedInUserId,
                                   @out_nReturnValue = nReturnValue,
                                   @out_nSQLErrCode = nSQLErrCode,
                                   @out_sSQLErrMessage = sSQLErrMessage

                               }).SingleOrDefault<ComCodeDTO>();

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
        public bool Delete(string sConnectionString,int nLoggedInUserId,int nCodeID)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<ComCodeDTO> res = null;
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
                        res = db.Query<ComCodeDTO>("exec st_com_CodeDelete @inp_iCodeID,@inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iCodeID = nCodeID,
                               @inp_nUserId = nLoggedInUserId,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).ToList<ComCodeDTO>();

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
        #endregion Delete

        #region GetList
        public IEnumerable<ComCodeDTO> GetList(ComCodeDTO m_objComCodeDTO, string sConnectionString)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<ComCodeDTO> res = null;
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
                        res = db.Query<ComCodeDTO>("exec st_com_CodeList @inp_iCodeID,@inp_sCodeName,@inp_iCodeGroupId,@inp_sDescription,@inp_bIsVisible,@inp_nIsActive,@inp_iDisplayOrder,@inp_sDisplayCode,@inp_iParentCodeId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iCodeID = m_objComCodeDTO.CodeID,
                               @inp_sCodeName = m_objComCodeDTO.CodeName,
                               @inp_iCodeGroupId = m_objComCodeDTO.CodeGroupId,
                               @inp_sDescription = m_objComCodeDTO.Description,
                               @inp_bIsVisible = m_objComCodeDTO.IsVisible,
                               @inp_nIsActive = m_objComCodeDTO.IsActive,
                               @inp_iDisplayOrder = m_objComCodeDTO.DisplayOrder,
                               @inp_sDisplayCode = m_objComCodeDTO.DisplayCode,
                               @inp_iParentCodeId = m_objComCodeDTO.ParentCodeId,

                               out_nReturnValue = nReturnValue
                               ,
                               out_nSQLErrCode = nSQLErrCode
                               ,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).ToList<ComCodeDTO>();

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

        #endregion GetList

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
