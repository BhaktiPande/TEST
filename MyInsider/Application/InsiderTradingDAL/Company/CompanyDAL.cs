using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class CompanyDAL:IDisposable
    {

        const String sLookupPrefix = "cmp_msg_";

        #region Main Company

        #region GetCompanyDetails
        /// <summary>
        /// This function will return a list of all the companies saved in the system database
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<InsiderTradingDAL.CompanyDTO> getCompaniesDetails(string i_sConnectionString)
        {   
            PetaPoco.Database db=null;
            IEnumerable<InsiderTradingDAL.CompanyDTO> lstCompanyList = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstCompanyList = db.Query<InsiderTradingDAL.CompanyDTO>("exec st_com_GetCompanyDetails ",
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
            return lstCompanyList;
        }
        #endregion GetCompanyDetails

        #region GetSingleCompanyDetails
        /// <summary>
        /// This function will return a list of all the companies saved in the system database
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public InsiderTradingDAL.CompanyDTO GetSingleCompanyDetails(string i_sConnectionString, string i_sCompanyDatabaseName)
        {   
            PetaPoco.Database db=null;
            InsiderTradingDAL.CompanyDTO objCompanyobject = new InsiderTradingDAL.CompanyDTO();
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objCompanyobject = db.Query<InsiderTradingDAL.CompanyDTO>("exec st_com_GetCompanyDetails @inp_sCompanyDatabaseName",
                             new
                             {
                                 inp_sCompanyDatabaseName = i_sCompanyDatabaseName
                             }).Single<InsiderTradingDAL.CompanyDTO>();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                if (exp.Message.ToString().Equals("Sequence contains no elements"))
                {
                    throw new Exception("Invalid Company Name", exp);
                }
                throw exp;
            }
            return objCompanyobject;
        }
        #endregion GetSingleCompanyDetails

        #region UpdateMasterCompanyDetails
        public int UpdateMasterCompanyDetails(string i_sConnectionString, string i_sCompanyDatabaseName, int i_nCompanyResourceUpdateStatus)
        {
            PetaPoco.Database db = null;
            int objCompanyobject = 0;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objCompanyobject = db.Execute("update Companies set UpdateResources = " + i_nCompanyResourceUpdateStatus + " where ConnectionDatabaseName = '" + i_sCompanyDatabaseName + "'");
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {

            }
            return objCompanyobject;
        }
        #endregion UpdateMasterCompanyDetails
        #endregion  Main Company

        #region Company Master Functions

        #region GetDetails
        /// <summary>
        /// This method is used for the get details of Company.
        /// </summary>
        /// <param name="sConnectionString">db Connection string</param>
        /// <param name="m_objCompanyDTO">Company DTO</param>
        /// <returns> return List Of Company DTO</returns>
        public ImplementedCompanyDTO GetDetails(string i_sConnectionString, int  i_nCompanyId,int i_nImplementing)
        {
            #region Paramters
            ImplementedCompanyDTO objImplementedCompanyDTO = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db=null;
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
                sSQLErrMessage.Value = "";
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objImplementedCompanyDTO = db.Query<ImplementedCompanyDTO>("exec st_mst_CompanyDetails @inp_iCompanyId,@inp_iGetImplementing,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iCompanyId = i_nCompanyId,
                                inp_iGetImplementing = i_nImplementing,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage
                            }).SingleOrDefault<ImplementedCompanyDTO>();

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
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            return objImplementedCompanyDTO;
                        }
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {
               
                throw exp;
            }

        }
        #endregion GetDetails

        #region Save
        /// <summary>
        /// This method is used for the saving company details.
        /// <param name="sConnectionString">DB Connection String</param>
       /// <param name="m_objCompanyDTO">ImplementedCompanyDTO objects</param>
       /// <returns>if save then return true else return false</returns>
        public bool SaveDetails(string i_sConnectionString,ImplementedCompanyDTO m_objCompanyDTO)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            bool bReturn = false;
            PetaPoco.Database db=null;
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
                        var res = db.Query<ImplementedCompanyDTO>("exec st_mst_CompanySave @inp_iCompanyId,@inp_sCompanyName,@inp_sAddress,@inp_sWebsite,@inp_sEmailId,@inp_sISINNumber,@inp_iLoggedInUserId, @inp_SmtpServer, @inp_SmtpPortNumber, @inp_SmtpUserName, @inp_SmtpPassword,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iCompanyId = m_objCompanyDTO.CompanyId,
                                inp_sCompanyName = m_objCompanyDTO.CompanyName,
                                inp_sAddress = m_objCompanyDTO.Address,
                                inp_sWebsite = m_objCompanyDTO.Website,
                                inp_sEmailId = m_objCompanyDTO.EmailId,
                                inp_sISINNumber = m_objCompanyDTO.ISINNumber,
                                inp_iLoggedInUserId = m_objCompanyDTO.LoggedInUserId,
                                inp_SmtpServer = m_objCompanyDTO.SmtpServer, 
                                inp_SmtpPortNumber = m_objCompanyDTO.SmtpPortNumber, 
                                inp_SmtpUserName = m_objCompanyDTO.SmtpUserName,
                                inp_SmtpPassword = m_objCompanyDTO.SmtpPassword,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).SingleOrDefault<ImplementedCompanyDTO>();

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
        #endregion Save

        #region Delete
        /// <summary>
        /// This method is used for the delete the company
        /// </summary>
        /// <param name="sConnectionString">DB COnnection string</param>
        /// <param name="m_objCompanyDTO">ImplementedCompanyDTO object</param>
        /// <returns>if delete return true else false</returns>
        public bool Delete(string i_sConnectionString, ImplementedCompanyDTO m_objCompanyDTO)
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
                        var res = db.Query<ImplementedCompanyDTO>("exec st_mst_CompanyDelete @inp_iCompanyId,@inp_nUserInfoId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iCompanyId = m_objCompanyDTO.CompanyId,
                                inp_nUserInfoId = m_objCompanyDTO.LoggedInUserId,
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
        #endregion Delete

        #endregion Company Master Functions

        #region Face Value Function 

        #region GetCompanyFaceValueDetails
        /// <summary>
        /// This method is used for the get face value details for the company.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyFaceValueID">Company Face Value ID</param>
        /// <returns>Object Face Value DTO</returns>
        public CompanyFaceValueDTO GetCompanyFaceValueDetails(string i_sConnectionString, int i_nCompanyFaceValueID)
        {
            #region Paramters
            CompanyFaceValueDTO objCompanyFaceValueDTO = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
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
                sSQLErrMessage.Value = "";
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objCompanyFaceValueDTO = db.Query<CompanyFaceValueDTO>("exec st_com_CompanyFaceValueDetails @inp_iCompanyFaceValueID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iCompanyFaceValueID = i_nCompanyFaceValueID,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage
                            }).SingleOrDefault<CompanyFaceValueDTO>();

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
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            return objCompanyFaceValueDTO;
                        }
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {
               
                throw exp;
            }

        }
        #endregion GetCompanyFaceValueDetails

        #region SaveCompanyFaceValueDetails
        /// <summary>
        /// This method is used for the sace Company Face Value details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyFaceValueDTO">Object of ComapnyFaceValue DTO</param>
        /// <returns></returns>
        public CompanyFaceValueDTO SaveCompanyFaceValueDetails(string i_sConnectionString, CompanyFaceValueDTO m_objCompanyFaceValueDTO)
        {
            #region Paramters
            CompanyFaceValueDTO objCompanyFaceValueDTO = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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

                        objCompanyFaceValueDTO = db.Query<CompanyFaceValueDTO>("exec st_com_CompanyFaceValueSave @inp_iCompanyFaceValueID,@inp_iCompanyID," +
                        "@inp_dtFaceValueDate,@inp_sFaceValue,@inp_iCurrencyID,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iCompanyFaceValueID = m_objCompanyFaceValueDTO.CompanyFaceValueID,
                                inp_iCompanyID = m_objCompanyFaceValueDTO.CompanyID,
                                inp_dtFaceValueDate = m_objCompanyFaceValueDTO.FaceValueDate,
                                inp_sFaceValue = m_objCompanyFaceValueDTO.FaceValue,
                                inp_iCurrencyID = m_objCompanyFaceValueDTO.CurrencyID,
                                inp_iLoggedInUserId = m_objCompanyFaceValueDTO.LoggedInUserId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).SingleOrDefault<CompanyFaceValueDTO>();

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
            return objCompanyFaceValueDTO;
        }
        #endregion SaveCompanyFaceValueDetails

        #region DeleteCompanyFaceValueDetails
        /// <summary>
        /// Delete Company Face Value details.
        /// </summary>
        /// <param name="sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyFaceValueDTO">Object of CompanyFaceValue DTO</param>
        /// <returns></returns>
        public bool DeleteCompanyFaceValueDetails(string i_sConnectionString, CompanyFaceValueDTO m_objCompanyFaceValueDTO)
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
                        var res = db.Query<CompanyFaceValueDTO>("exec st_com_CompanyFaceValueDelete @inp_iCompanyFaceValueID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iCompanyFaceValueID = m_objCompanyFaceValueDTO.CompanyFaceValueID,
                                //   inp_nUserId = m_objCompanyFaceValueDTO.LoggedInUserId,
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
        #endregion DeleteCompanyFaceValueDetails

        #endregion  Face Value Function

        #region Authorised Shares Function 

        #region GetAuthorisedShareCapitalDetails
        /// <summary>
        /// This method is used for the get Authorised share capital details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyAuthorizedShareCapitalID">Authorised Shared Capital DTO</param>
        /// <returns>Object of Authorised Share DTO</returns>
        public CompanyAuthorizedShareCapitalDTO GetAuthorisedShareCapitalDetails(string i_sConnectionString, int i_nCompanyAuthorizedShareCapitalID)
        {
            #region Paramters
            CompanyAuthorizedShareCapitalDTO objCompanyAuthorizedShareCapitalDTO = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
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
                sSQLErrMessage.Value = "";
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objCompanyAuthorizedShareCapitalDTO = db.Query<CompanyAuthorizedShareCapitalDTO>("exec st_com_CompanyAuthorizedShareCapitalDetails @inp_iCompanyAuthorizedShareCapitalID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iCompanyAuthorizedShareCapitalID = i_nCompanyAuthorizedShareCapitalID,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage
                            }).SingleOrDefault<CompanyAuthorizedShareCapitalDTO>();

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
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            return objCompanyAuthorizedShareCapitalDTO;
                        }
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {
             
                throw exp;
            }

        }
        #endregion GetAuthorisedShareCapitalDetails

        #region GetAuthorisedShareCapitalDetailsForTransactionOnDate
        /// <summary>
        /// This method is used for the get Authorised share capital details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyAuthorizedShareCapitalID">Authorised Shared Capital DTO</param>
        /// <returns>Object of Authorised Share DTO</returns>
        public CompanyPaidUpAndSubscribedShareCapitalDTO GetAuthorisedShareCapitalDetailsForTransactionOnDate(string i_sConnectionString, DateTime i_dtAuthorizedShareCapitalDate)
        {
            #region Paramters
            CompanyPaidUpAndSubscribedShareCapitalDTO objCompanyPaidUpAndSubscribedShareCapitalDTO = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
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
                sSQLErrMessage.Value = "";
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objCompanyPaidUpAndSubscribedShareCapitalDTO = db.Query<CompanyPaidUpAndSubscribedShareCapitalDTO>("exec st_com_CompanyAuthorizedShareCapitalDetailsForTransaction @inp_dtAuthorizedShareCapitalDate,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_dtAuthorizedShareCapitalDate = i_dtAuthorizedShareCapitalDate,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage
                            }).SingleOrDefault<CompanyPaidUpAndSubscribedShareCapitalDTO>();

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
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            return objCompanyPaidUpAndSubscribedShareCapitalDTO;
                        }
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {

                throw exp;
            }

        }
        #endregion GetAuthorisedShareCapitalDetailsForTransactionOnDate

        #region SaveAuthorisedShareDetails
        /// <summary>
        /// This method is used for the save Authorised share details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyAuthorizedShareCapitalDTO">Authorisede Shared DTO</param>
        /// <returns></returns>
        public CompanyAuthorizedShareCapitalDTO SaveAuthorisedSharesDetails(string i_sConnectionString, CompanyAuthorizedShareCapitalDTO m_objCompanyAuthorizedShareCapitalDTO)
        {
            #region Paramters
            CompanyAuthorizedShareCapitalDTO objCompanyAuthorizedShareCapitalDTO = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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

                        objCompanyAuthorizedShareCapitalDTO = db.Query<CompanyAuthorizedShareCapitalDTO>("exec st_com_CompanyAuthorizedShareCapitalSave @inp_iCompanyAuthorizedShareCapitalID,@inp_iCompanyID," +
                        "@inp_dtAuthorizedShareCapitalDate,@inp_sAuthorizedShares,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iCompanyAuthorizedShareCapitalID = m_objCompanyAuthorizedShareCapitalDTO.CompanyAuthorizedShareCapitalID,
                                inp_iCompanyID = m_objCompanyAuthorizedShareCapitalDTO.CompanyID,
                                inp_dtAuthorizedShareCapitalDate = m_objCompanyAuthorizedShareCapitalDTO.AuthorizedShareCapitalDate,
                                inp_sAuthorizedShares = m_objCompanyAuthorizedShareCapitalDTO.AuthorizedShares,
                                inp_iLoggedInUserId = m_objCompanyAuthorizedShareCapitalDTO.LoggedInUserId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).SingleOrDefault<CompanyAuthorizedShareCapitalDTO>();

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
            return objCompanyAuthorizedShareCapitalDTO;
        }
        #endregion SaveAuthorisedShareDetails

        #region DeleteCompanyAuthorizedShareCapitalDetails
        /// <summary>
        /// This method is used for the delete authorised share details.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="m_objCompanyAuthorizedShareCapitalDTO"></param>
        /// <returns></returns>
        public bool DeleteCompanyAuthorizedShareCapitalDetails(string i_sConnectionString, CompanyAuthorizedShareCapitalDTO m_objCompanyAuthorizedShareCapitalDTO)
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
                        var res = db.Query<CompanyFaceValueDTO>("exec st_com_CompanyAuthorizedShareCapitalDelete @inp_iCompanyAuthorizedShareCapitalID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iCompanyAuthorizedShareCapitalID = m_objCompanyAuthorizedShareCapitalDTO.CompanyAuthorizedShareCapitalID,
                                //  inp_nUserId = m_objCompanyAuthorizedShareCapitalDTO.LoggedInUserId,
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
        #endregion DeleteCompanyAuthorizedShareCapitalDetails

        #endregion Authorised Shares Function

        #region PaidUpAndSubscribedShareCapital

        #region GetCompanyPaidUpAndSubscribedShareDetails
        /// <summary>
        /// This method is used for the get company Paid & Subscribe Share capital details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyPaidUpAndSubscribedShareCapitalId">CompanyPaidUpAndSubscribedShareCapitalId</param>
        /// <returns></returns>
        public CompanyPaidUpAndSubscribedShareCapitalDTO GetCompanyPaidUpAndSubscribedShareDetails(string i_sConnectionString, int i_nCompanyPaidUpAndSubscribedShareCapitalId)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            CompanyPaidUpAndSubscribedShareCapitalDTO lstCompanyPaidUpAndSubscribedShareCapitalDTO = null;
            PetaPoco.Database db=null;
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
                #endregion

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstCompanyPaidUpAndSubscribedShareCapitalDTO = db.Query<CompanyPaidUpAndSubscribedShareCapitalDTO>("exec st_com_CompanyPaidUpAndSubscribedShareCapitalDetails @inp_iCompanyPaidUpAndSubscribedShareCapitalID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iCompanyPaidUpAndSubscribedShareCapitalID = i_nCompanyPaidUpAndSubscribedShareCapitalId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).SingleOrDefault<CompanyPaidUpAndSubscribedShareCapitalDTO>();

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
                            throw ex;
                        }
                        else { scope.Complete();
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
            return lstCompanyPaidUpAndSubscribedShareCapitalDTO;

        }
        #endregion GetCompanyPaidUpAndSubscribedShareDetails

        #region SaveCompanyPaidUpAndSubscribedShareCapitalDetails
        /// <summary>
        /// This method is used for the save company paid & subscribe share capital details.
        /// </summary>
        /// <param name="i_sConnectionString">DB connection string</param>
        /// <param name="m_objCompanyPaidUpAndSubscribedShareCapitalDTO">Object of CompanyPaidUpAndSubscribedShareCapitalDTO</param>
        /// <returns></returns>
        public bool SaveCompanyPaidUpAndSubscribedShareCapitalDetails(string i_sConnectionString, CompanyPaidUpAndSubscribedShareCapitalDTO m_objCompanyPaidUpAndSubscribedShareCapitalDTO)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            CompanyPaidUpAndSubscribedShareCapitalDTO objCompanyPaidUpAndSubscribedShareCapitalDTO = null;
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
                #endregion

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objCompanyPaidUpAndSubscribedShareCapitalDTO = db.Query<CompanyPaidUpAndSubscribedShareCapitalDTO>("exec st_com_CompanyPaidUpAndSubscribedShareCapitalSave @inp_iCompanyPaidUpAndSubscribedShareCapitalID,@inp_dtPaidUpAndSubscribedShareCapitalDate,@inp_sPaidUpShare,@inp_iCompanyID,@inp_nLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iCompanyPaidUpAndSubscribedShareCapitalID = m_objCompanyPaidUpAndSubscribedShareCapitalDTO.CompanyPaidUpAndSubscribedShareCapitalID,
                               inp_dtPaidUpAndSubscribedShareCapitalDate = m_objCompanyPaidUpAndSubscribedShareCapitalDTO.PaidUpAndSubscribedShareCapitalDate,
                               inp_sPaidUpShare = m_objCompanyPaidUpAndSubscribedShareCapitalDTO.PaidUpShare,
                               inp_iCompanyID = m_objCompanyPaidUpAndSubscribedShareCapitalDTO.CompanyID,
                               inp_nLoggedInUserId = m_objCompanyPaidUpAndSubscribedShareCapitalDTO.LoggedInUserId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<CompanyPaidUpAndSubscribedShareCapitalDTO>();

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
                return bReturn;
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion SaveCompanyPaidUpAndSubscribedShareCapitalDetails

        #region DeleteCompanyPaidUpAndSubscribedShareCapital
        /// <summary>
        /// This method is used for the delete Company Paid & Sunscribe Share capital details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyPaidUpAndSubscribedShareCapitalDTO">ID CompanyPaidUpAndSubscribedShareCapital</param>
        /// <returns></returns>
        public bool DeleteCompanyPaidUpAndSubscribedShareCapital(string i_sConnectionString, int i_nCompanyPaidUpAndSubscribedShareCapitalID)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            IEnumerable<CompanyPaidUpAndSubscribedShareCapitalDTO> res = null;
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
                #endregion

               using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<CompanyPaidUpAndSubscribedShareCapitalDTO>("exec st_com_CompanyPaidUpAndSubscribedShareCapitalDelete @inp_iCompanyPaidUpAndSubscribedShareCapitalID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iCompanyPaidUpAndSubscribedShareCapitalID = i_nCompanyPaidUpAndSubscribedShareCapitalID,
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
                return bReturn;
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion DeleteCompanyPaidUpAndSubscribedShareCapital

        #endregion PaidUpAndSubscribedShareCapital

        #region Listing Details

        #region GetCompanyListingDetailsDTODetails
        /// <summary>
        /// This method is used for the get Listing details.
        /// </summary>
        /// <param name="sConnectionString">DB Connection string</param>
        /// <param name="inp_iCompanyListingDetailsId">ID Company Listing details.</param>
        /// <returns></returns>
        public CompanyListingDetailsDTO GetCompanyListingDetails(string i_sConnectionString, int i_nCompanyListingDetailsId)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            CompanyListingDetailsDTO objCompanyListingDetailsDTO = null;
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
                        objCompanyListingDetailsDTO = db.Query<CompanyListingDetailsDTO>("exec st_com_CompanyListingDetailsDetails @inp_iCompanyListingDetailsID,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iCompanyListingDetailsID = i_nCompanyListingDetailsId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).SingleOrDefault<CompanyListingDetailsDTO>();

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
            return objCompanyListingDetailsDTO;

        }
        #endregion GetCompanyListingDetailsDTODetails

        #region SaveCompanyListingDetails
        /// <summary>
        /// This method is used for the save Company listing details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyListingDetailsDTO">Object of CompanyListinDetailsDTO</param>
        /// <returns></returns>
        public bool SaveCompanyListingDetails(string i_sConnectionString,CompanyListingDetailsDTO m_objCompanyListingDetailsDTO)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            CompanyListingDetailsDTO res = null;
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
                        res = db.Query<CompanyListingDetailsDTO>("exec st_com_CompanyListingDetailsSave @inp_iCompanyListingDetailsID,@inp_iCompanyID,@inp_iStockExchangeID,@inp_dtDateOfListingFrom,@inp_dtDateOfListingTo,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iCompanyListingDetailsID = m_objCompanyListingDetailsDTO.CompanyListingDetailsID,
                               inp_iCompanyID = m_objCompanyListingDetailsDTO.CompanyID,
                               inp_iStockExchangeID = m_objCompanyListingDetailsDTO.StockExchangeID,
                               inp_dtDateOfListingFrom = m_objCompanyListingDetailsDTO.DateOfListingFrom,
                               inp_dtDateOfListingTo = m_objCompanyListingDetailsDTO.DateOfListingTo,
                               inp_iLoggedInUserId = m_objCompanyListingDetailsDTO.LoggedInUserId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<CompanyListingDetailsDTO>();

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
                return bReturn;
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion SaveCompanyListingDetails

        #region DeleteCompanyListingDetails
        /// <summary>
        /// This methd is used for the delete company listing details.
        /// </summary>
        /// <param name="sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyListingDetailsID">ID of Company Listing details</param>
        /// <returns></returns>
        public bool DeleteCompanyListingDetails(string i_sConnectionString, CompanyListingDetailsDTO m_objCompanyListingDetailsDTO)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            IEnumerable<CompanyListingDetailsDTO> res = null;
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
                        res = db.Query<CompanyListingDetailsDTO>("exec st_com_CompanyListingDetailsDelete @inp_iCompanyListingDetailsID,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iCompanyListingDetailsID = m_objCompanyListingDetailsDTO.CompanyListingDetailsID,
                               inp_iLoggedInUserId = m_objCompanyListingDetailsDTO.LoggedInUserId,
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
                return bReturn;
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion DeleteCompanyListingDetails

        #endregion  Listing Details

        #region Compliance Officer

        #region GetCompanyComplianceOfficerDetails
        /// <summary>
        /// This method is used for the Company Compliance Officer details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyComplianceOfficerId">ID Company Compliance Officer</param>
        /// <returns></returns>
        public CompanyComplianceOfficerDTO GetCompanyComplianceOfficerDetails(string i_sConnectionString, int i_nCompanyComplianceOfficerId)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            CompanyComplianceOfficerDTO objCompanyComplianceOfficerDTO = null;
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
                        objCompanyComplianceOfficerDTO = db.Query<CompanyComplianceOfficerDTO>("exec st_com_CompanyComplianceOfficerDetails @inp_iCompanyComplianceOfficerId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iCompanyComplianceOfficerId = i_nCompanyComplianceOfficerId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).SingleOrDefault<CompanyComplianceOfficerDTO>();

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
            return objCompanyComplianceOfficerDTO;

        }
        #endregion GetCompanyComplianceOfficerDetails

        #region SaveCompanyComplianceOfficerDetails
        /// <summary>
        /// This method is used for the save COmpany COmpliance officer details.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objCompanyComplianceOfficerDTO">object of CompanyComplianceOfficerDTO</param>
        /// <returns></returns>
        public bool SaveCompanyComplianceOfficerDetails(string i_sConnectionString, CompanyComplianceOfficerDTO m_objCompanyComplianceOfficerDTO)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            CompanyComplianceOfficerDTO res = null;
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
                        res = db.Query<CompanyComplianceOfficerDTO>("exec st_com_CompanyComplianceOfficerSave @inp_iCompanyComplianceOfficerId,@inp_iCompanyId,@inp_sComplianceOfficerName,@inp_iDesignationId,@inp_sAddress,@inp_sPhoneNumber,@inp_sEmailId,@inp_iStatusCodeId,@inp_dtApplicableFromDate,@inp_dtApplicableToDate,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iCompanyComplianceOfficerId = m_objCompanyComplianceOfficerDTO.CompanyComplianceOfficerId,
                               inp_iCompanyId = m_objCompanyComplianceOfficerDTO.CompanyId,
                               inp_sComplianceOfficerName = m_objCompanyComplianceOfficerDTO.ComplianceOfficerName,
                               inp_iDesignationId = m_objCompanyComplianceOfficerDTO.DesignationId,
                               inp_sAddress = m_objCompanyComplianceOfficerDTO.Address,
                               inp_sPhoneNumber = m_objCompanyComplianceOfficerDTO.PhoneNumber,
                               inp_sEmailId = m_objCompanyComplianceOfficerDTO.EmailId,
                               inp_iStatusCodeId = m_objCompanyComplianceOfficerDTO.StatusCodeId,
                               inp_dtApplicableFromDate = m_objCompanyComplianceOfficerDTO.ApplicableFromDate,
                               inp_dtApplicableToDate = m_objCompanyComplianceOfficerDTO.ApplicableToDate,
                               inp_iLoggedInUserId = m_objCompanyComplianceOfficerDTO.LoggedInUserId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<CompanyComplianceOfficerDTO>();

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
                return bReturn;
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion SaveCompanyComplianceOfficerDetails

        #region DeleteCompanyComplianceOfficer
        /// <summary>
        /// This method is used for the delete Company Compliance officer.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="i_nCompanyComplianceOfficerId">Compliance Officer Id</param>
        /// <returns></returns>
        public bool DeleteCompanyComplianceOfficer(string i_sConnectionString, int i_nCompanyComplianceOfficerId)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            IEnumerable<CompanyComplianceOfficerDTO> res = null;
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
                #endregion

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<CompanyComplianceOfficerDTO>("exec st_com_CompanyComplianceOfficerDelete @inp_iCompanyComplianceOfficerId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iCompanyComplianceOfficerId = i_nCompanyComplianceOfficerId,
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
                return bReturn;
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion DeleteCompanyComplianceOfficer

        #endregion Compliance Officer

        #region Company setting configuration

        #region Get Company Setting Configuration Details List
        /// <summary>
        /// This method is used to get company setting configuration list for given configuration type
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="nConfigurationTypeCodeId"></param>
        /// <returns></returns>
        public List<CompanySettingConfigurationDTO> GetCompanySettingConfigurationList(string sConnectionString, int nConfigurationTypeCodeId)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<CompanySettingConfigurationDTO> res = null;
            PetaPoco.Database db = null;

            int? iConfigurationCodeId = null;
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
                        res = db.Query<CompanySettingConfigurationDTO>("exec st_com_CompanySettingConfigurationDetails @inp_iConfigurationTypeCodeId, @inp_iConfigurationCodeId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iConfigurationTypeCodeId = nConfigurationTypeCodeId,
                               @inp_iConfigurationCodeId = iConfigurationCodeId,

                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).ToList<CompanySettingConfigurationDTO>();

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
        #endregion Get Company Setting Configuration Details List

        #region Get Company Setting Configuration Details
        /// <summary>
        /// This method is used to get company setting configuration list for given configuration type and code
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="nConfigurationTypeCodeId"></param>
        /// <param name="nConfigurationCodeId"></param>
        /// <returns></returns>
        public CompanySettingConfigurationDTO GetCompanySettingConfiguration(string sConnectionString, int nConfigurationTypeCodeId, int nConfigurationCodeId)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            CompanySettingConfigurationDTO res = null;
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
                        res = db.Query<CompanySettingConfigurationDTO>("exec st_com_CompanySettingConfigurationDetails @inp_iConfigurationTypeCodeId, @inp_iConfigurationCodeId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iConfigurationTypeCodeId = nConfigurationTypeCodeId,
                               @inp_iConfigurationCodeId = nConfigurationCodeId,

                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).SingleOrDefault<CompanySettingConfigurationDTO>();

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
        #endregion Get Company Setting Configuration Details

        #region Get Company Setting Configuration Mapping Details List
        /// <summary>
        /// This method is used to get company setting configuration mapping list for given configuration
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="nMapToTypeCodeId"></param>
        /// <param name="nConfigurationMapToId"></param>
        /// <returns></returns>
        public List<CompanySettingConfigurationMappingDTO> GetCompanySettingConfigurationMappingList(string sConnectionString, int nMapToTypeCodeId, int nConfigurationMapToId)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<CompanySettingConfigurationMappingDTO> res = null;
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
                        res = db.Query<CompanySettingConfigurationMappingDTO>("exec st_com_CompanySettingConfigurationMappingDetails @inp_iMapToTypeCodeId, @inp_iConfigurationMapToId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_iMapToTypeCodeId = nMapToTypeCodeId,
                               @inp_iConfigurationMapToId = nConfigurationMapToId,

                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).ToList<CompanySettingConfigurationMappingDTO>();

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
        #endregion Get Company Setting Configuration Mapping Details List

        #region Save/Update Company Setting Configuration Details
        /// <summary>
        /// This method is used to update company setting configuraiton and related mapping details
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="dtUpdateConfiguration"></param>
        /// <param name="dtDeleteConfigurationMapping"></param>
        /// <param name="dtAddConfigurationMapping"></param>
        /// <returns></returns>
        public bool SaveCompanySettingConfiguration(string sConnectionString, DataTable dtUpdateConfiguration, DataTable dtDeleteConfigurationMapping, DataTable dtAddConfigurationMapping)
        {
            #region Paramters

            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int res;
            PetaPoco.Database db = null;

            bool retStatus = false;
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

                var inp_tblUpdateConfiguration = new SqlParameter();
                inp_tblUpdateConfiguration.DbType = DbType.Object;
                inp_tblUpdateConfiguration.ParameterName = "@inp_tblUpdateConfiguration";
                inp_tblUpdateConfiguration.TypeName = "dbo.CompanySettingConfigurationDataTable";
                inp_tblUpdateConfiguration.SqlDbType = SqlDbType.Structured;
                inp_tblUpdateConfiguration.SqlValue = dtUpdateConfiguration;

                var inp_tblDeleteConfigurationMapping = new SqlParameter();
                inp_tblDeleteConfigurationMapping.DbType = DbType.Object;
                inp_tblDeleteConfigurationMapping.ParameterName = "@inp_tblDeleteConfigurationMapping";
                inp_tblDeleteConfigurationMapping.TypeName = "dbo.CompanySettingConfigurationMappingDataTable";
                inp_tblDeleteConfigurationMapping.SqlDbType = SqlDbType.Structured;
                inp_tblDeleteConfigurationMapping.SqlValue = dtDeleteConfigurationMapping;

                var inp_tblAddConfigurationMapping = new SqlParameter();
                inp_tblAddConfigurationMapping.DbType = DbType.Object;
                inp_tblAddConfigurationMapping.ParameterName = "@inp_tblAddConfigurationMapping";
                inp_tblAddConfigurationMapping.TypeName = "dbo.CompanySettingConfigurationMappingDataTable";
                inp_tblAddConfigurationMapping.SqlDbType = SqlDbType.Structured;
                inp_tblAddConfigurationMapping.SqlValue = dtAddConfigurationMapping;

                #endregion Out Paramter

                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_com_CompanySettingConfigurationUpdate @inp_tblUpdateConfiguration, @inp_tblDeleteConfigurationMapping, @inp_tblAddConfigurationMapping, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_tblUpdateConfiguration = inp_tblUpdateConfiguration,
                               @inp_tblDeleteConfigurationMapping = inp_tblDeleteConfigurationMapping,
                               @inp_tblAddConfigurationMapping = inp_tblAddConfigurationMapping,

                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage
                           }).Single<int>();

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
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            retStatus = true;
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
            return retStatus;

        }
        #endregion Save/Update Company Setting Configuration Details

        #endregion Company setting configuration

        #region SavePersonalDetailsConfirmation
        /// <summary>
        /// This method is used for the save Personal Details Confirmation details.
        /// </summary>
        /// <returns></returns>
        public bool SavePersonalDetailsConfirmation(string i_sConnectionString, PersonalDetailsConfirmationDTO m_objPersonalDetailsConfirmationDTO)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PersonalDetailsConfirmationDTO res = null;
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
                        res = db.Query<PersonalDetailsConfirmationDTO>("exec st_usr_PersonalDetailsConfirmation @inp_iCompanyID, @inp_iReconfirmationFrequencyId, @inp_iLoggedInUserId, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iCompanyID = m_objPersonalDetailsConfirmationDTO.CompanyId,
                               inp_iReconfirmationFrequencyId = m_objPersonalDetailsConfirmationDTO.ReconfirmationFrequencyId,
                               inp_iLoggedInUserId = m_objPersonalDetailsConfirmationDTO.LoggedInUserId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<PersonalDetailsConfirmationDTO>();

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
                return bReturn;
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion SavePersonalDetailsConfirmation

        #region SaveWorkandEducationDetailsConfiguration
        /// <summary>
        /// This method is used for the save Personal Details Confirmation details.
        /// </summary>
        /// <returns></returns>
        public bool SaveWorkandEducationDetailsConfiguration(string i_sConnectionString, WorkandEducationDetailsConfigurationDTO m_objWorkandEducationDetailsConfigurationDTO)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            WorkandEducationDetailsConfigurationDTO res = null;
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
                        res = db.Query<WorkandEducationDetailsConfigurationDTO>("exec st_usr_WorkandEducationDetailsConfiguration @inp_iCompanyID, @inp_iWorkandEducationDetailsConfigurationId, @inp_iLoggedInUserId, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_iCompanyID = m_objWorkandEducationDetailsConfigurationDTO.CompanyId,
                               @inp_iWorkandEducationDetailsConfigurationId = m_objWorkandEducationDetailsConfigurationDTO.WorkandEducationDetailsConfigurationId,
                               inp_iLoggedInUserId = m_objWorkandEducationDetailsConfigurationDTO.LoggedInUserId,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<WorkandEducationDetailsConfigurationDTO>();

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
                return bReturn;
                throw exp;
            }
            finally
            {

            }
            return bReturn;
        }
        #endregion SaveWorkandEducationDetailsConfiguration

        #region GetWorkandeducationDetailsConfiguration
        /// <summary>
        /// This function will Get work and education details configuration
        /// </summary>
        /// <returns></returns>
        public InsiderTradingDAL.WorkandEducationDetailsConfigurationDTO GetWorkandeducationDetailsConfiguration(string inp_sConnectionString, int inp_iCompanyId)
        {
            PetaPoco.Database db = null;
            InsiderTradingDAL.WorkandEducationDetailsConfigurationDTO objCompanyDAL = new InsiderTradingDAL.WorkandEducationDetailsConfigurationDTO();
            try
            {
                using (db = new PetaPoco.Database(inp_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objCompanyDAL = db.Query<InsiderTradingDAL.WorkandEducationDetailsConfigurationDTO>("exec st_usr_GetworkandEducationDetailsConfiguration @inp_iCompanyId",
                             new
                             {
                                 inp_iCompanyId = inp_iCompanyId
                             }).Single<InsiderTradingDAL.WorkandEducationDetailsConfigurationDTO>();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCompanyDAL;
        }
        #endregion GetWorkandeducationDetailsConfiguration

        #region GetPersonal_Details_Confirmation_Frequency
        /// <summary>
        /// This function will Get Personal Details Confirmation Frequency
        /// </summary>
        /// <returns></returns>
        public InsiderTradingDAL.PersonalDetailsConfirmationDTO GetPersonal_Details_Confirmation_Frequency(string inp_sConnectionString, int inp_iCompanyId)
        {
            PetaPoco.Database db = null;
            InsiderTradingDAL.PersonalDetailsConfirmationDTO objCompanyDAL = new InsiderTradingDAL.PersonalDetailsConfirmationDTO();
            try
            {
                using (db = new PetaPoco.Database(inp_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        objCompanyDAL = db.Query<InsiderTradingDAL.PersonalDetailsConfirmationDTO>("exec st_usr_Check_Personal_Details_Confirmation_Frequency @inp_iCompanyId",
                             new
                             {
                                 inp_iCompanyId = inp_iCompanyId
                             }).Single<InsiderTradingDAL.PersonalDetailsConfirmationDTO>();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objCompanyDAL;
        }
        #endregion GetPersonal_Details_Confirmation_Frequency

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
