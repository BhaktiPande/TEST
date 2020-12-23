using InsiderTrading;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace InsiderTradingDAL
{
    public class UserInfoDAL : IDisposable //: GenericDTOImpl<UserInfoDTO>
    {
        const String sLookupPrefix = "usr_msg_";

        #region ValidateUser
        /// <summary>
        /// This function will be used for validating if the given user is registered under the given company database.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserDetailsDTO"></param>
        public bool ValidateUser(string i_sConnectionString, AuthenticationDTO i_objAuthenticationDTO, ref UserInfoDTO o_objUserInfoDTO)
        {
            List<UserInfoDTO> res = null;
            bool bReturn = false;
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
                nReturnValue.Value = 0;
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
                        res = db.Query<UserInfoDTO>("exec st_usr_ValidateUser @inp_sLoginId, @inp_sPassword,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_sLoginId = i_objAuthenticationDTO.LoginID,
                                inp_sPassword = i_objAuthenticationDTO.Password,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage
                            }).ToList<UserInfoDTO>();
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
                            if (res.Count > 0)
                            {
                                o_objUserInfoDTO = res[0];
                            }
                        }
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            return bReturn;
        }
        #endregion ValidateUser

        #region GetUserInfoList
        /// <summary>
        /// This method is used for get user info list by User Type.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <param name="i_objUserInfoDTO">User Type Object</param>
        /// <returns>User Information List</returns>
        public IEnumerable<UserInfoDTO> GetUserInfoList(string i_sConnectionString, UserInfoDTO i_objUserInfoDTO)
        {
            #region Paramters
            List<UserInfoDTO> lstUserInfoList = null;
            string sErrCode = string.Empty;
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
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                #endregion Output Param

                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        lstUserInfoList = db.Query<UserInfoDTO>("exec st_usr_UserInfoList @inp_iUserInfoId,@inp_iUserTypeCodeId,@inp_sFirstName,@inp_sLoginID"
                            + ",@inp_sCompanyName,@inp_iStatusCodeId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iUserInfoId = i_objUserInfoDTO.UserInfoId,
                                inp_iUserTypeCodeId = i_objUserInfoDTO.UserTypeCodeId,
                                inp_sFirstName = i_objUserInfoDTO.FirstName,
                                inp_sLoginID = i_objUserInfoDTO.LoginID,
                                inp_sCompanyName = i_objUserInfoDTO.CompanyName,
                                inp_iStatusCodeId = i_objUserInfoDTO.StatusCodeId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Return Error Code
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
                            #endregion Return Error Code
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
            return lstUserInfoList;
        }
        #endregion GetUserInfoList

        #region InsertUpdateUserDetails
        /// <summary>
        /// This method is used for the insert/Update User details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">User Info Object</param>
        /// <param name="out_nReturnValue">Return Value</param>
        /// <param name="out_nSQLErrCode">SQL Error Code</param>
        /// <param name="out_sSQLErrMessage">SQL Error Message</param>
        /// <returns></returns>
        public UserInfoDTO InsertUpdateUserDetails(string i_sConnectionString, UserInfoDTO i_objUserInfoDTO)
        {
            #region Paramters
            List<UserInfoDTO> res = null;
            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";



                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {


                        res = db.Fetch<UserInfoDTO>("exec  st_usr_UserInfoSave @inp_iUserInfoId, @inp_iUserTypeCodeID, @inp_sEmailId, @inp_sFirstName, @inp_sMiddleName, @inp_sLastName"
                                      + ", @inp_sEmployeeId, @inp_sMobileNumber, @inp_sCompanyId, @inp_sAddressLine1, @inp_sAddressLine2, @inp_iCountryId"
                                      + ", @inp_iStateId, @inp_sCity, @inp_sPinCode, @inp_sContactPerson, @inp_dtDateOfJoining, @inp_dtDateOfBecomingInsider, @inp_sLandLine1"
                                      + ", @inp_sLandLine2, @inp_sWebsite, @inp_sPAN, @inp_sTAN, @inp_sDescription, @inp_iCategory, @inp_iSubCategory, @inp_iGradeId, @inp_iDesignationId, @inp_iSubDesignationId"
                                      + ", @inp_sLocation, @inp_iDepartmentId, @inp_iUPSIAccessOfCompanyID, @inp_iParentId, @inp_iRelationWithEmployee, @inp_iStatusCodeId, @inp_sCategoryText, @inp_sSubCategoryText"
                                      + ", @inp_sGradeText, @inp_sDesignationText, @inp_sSubDesignationText, @inp_sDepartmentText, @inp_iLoggedInUserId"
                                      + ", @inp_sLoginID, @inp_sPassword, @inp_iIsInsider,@inp_sCIN,@inp_sDIN,@inp_sRelativeStatus,@inp_sDoYouHaveDMATEAccountFlag,@inp_sSaveNAddDematflag,@inp_sResidentTypeId,@inp_sUIDAI_IdentificationNo, @inp_sIdentificationTypeId,@inp_sAllowUpsiUser,@inp_sPersonalAddress, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {

                                inp_iUserInfoId = i_objUserInfoDTO.UserInfoId,
                                inp_iUserTypeCodeID = i_objUserInfoDTO.UserTypeCodeId,
                                inp_sEmailId = i_objUserInfoDTO.EmailId,
                                inp_sFirstName = i_objUserInfoDTO.FirstName,
                                inp_sMiddleName = i_objUserInfoDTO.MiddleName,
                                inp_sLastName = i_objUserInfoDTO.LastName,
                                inp_sEmployeeId = i_objUserInfoDTO.EmployeeId,
                                inp_sMobileNumber = i_objUserInfoDTO.MobileNumber,
                                inp_sCompanyId = i_objUserInfoDTO.CompanyId,
                                inp_sAddressLine1 = i_objUserInfoDTO.AddressLine1,
                                inp_sAddressLine2 = i_objUserInfoDTO.AddressLine2,
                                inp_iCountryId = i_objUserInfoDTO.CountryId,
                                inp_iStateId = i_objUserInfoDTO.StateId,
                                inp_sCity = i_objUserInfoDTO.City,
                                inp_sPinCode = i_objUserInfoDTO.PinCode,
                                inp_sContactPerson = i_objUserInfoDTO.ContactPerson,
                                inp_dtDateOfJoining = i_objUserInfoDTO.DateOfJoining,
                                inp_dtDateOfBecomingInsider = i_objUserInfoDTO.DateOfBecomingInsider,
                                inp_sLandLine1 = i_objUserInfoDTO.LandLine1,
                                inp_sLandLine2 = i_objUserInfoDTO.LandLine2,
                                inp_sWebsite = i_objUserInfoDTO.Website,
                                inp_sPAN = i_objUserInfoDTO.PAN,
                                inp_sTAN = i_objUserInfoDTO.TAN,
                                inp_sDescription = i_objUserInfoDTO.Description,
                                inp_iCategory = i_objUserInfoDTO.Category,
                                inp_iSubCategory = i_objUserInfoDTO.SubCategory,
                                inp_iGradeId = i_objUserInfoDTO.GradeId,
                                inp_iDesignationId = i_objUserInfoDTO.DesignationId,
                                inp_iSubDesignationId = i_objUserInfoDTO.SubDesignationId,
                                inp_sLocation = i_objUserInfoDTO.Location,
                                inp_iDepartmentId = i_objUserInfoDTO.DepartmentId,
                                inp_iUPSIAccessOfCompanyID = i_objUserInfoDTO.UPSIAccessOfCompanyID,
                                inp_iParentId = i_objUserInfoDTO.ParentId,
                                inp_iRelationWithEmployee = i_objUserInfoDTO.RelationTypeCodeId,
                                inp_iStatusCodeId = i_objUserInfoDTO.StatusCodeId,
                                inp_sCategoryText = i_objUserInfoDTO.CategoryName,
                                inp_sSubCategoryText = i_objUserInfoDTO.SubCategoryName,
                                inp_sGradeText = i_objUserInfoDTO.GradeName,
                                inp_sDesignationText = i_objUserInfoDTO.DesignationName,
                                inp_sSubDesignationText = i_objUserInfoDTO.SubDesignationName,
                                inp_sDepartmentText = i_objUserInfoDTO.DepartmentName,
                                inp_iLoggedInUserId = i_objUserInfoDTO.LoggedInUserId,
                                inp_sLoginID = i_objUserInfoDTO.LoginID,
                                inp_sPassword = i_objUserInfoDTO.Password,
                                inp_iIsInsider = i_objUserInfoDTO.IsInsider,
                                inp_sCIN = i_objUserInfoDTO.CIN,
                                inp_sDIN = i_objUserInfoDTO.DIN,
                                inp_sRelativeStatus = i_objUserInfoDTO.RelativeStatus,
                                inp_sDoYouHaveDMATEAccountFlag = i_objUserInfoDTO.DoYouHaveDMATEAccountFlag,
                                inp_sSaveNAddDematflag = i_objUserInfoDTO.SaveNAddDematflag,
                                inp_sResidentTypeId=i_objUserInfoDTO.ResidentTypeId,
                                inp_sUIDAI_IdentificationNo=i_objUserInfoDTO.UIDAI_IdentificationNo,
                                inp_sIdentificationTypeId=i_objUserInfoDTO.IdentificationTypeId,
                                inp_sAllowUpsiUser = i_objUserInfoDTO.AllowUpsiUser,
                                inp_sPersonalAddress=i_objUserInfoDTO.PersonalAddress,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList();


                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
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
                            #endregion  Error Code
                        }

                        else
                        {

                            var nReturnValue1 = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                            nReturnValue1.Direction = System.Data.ParameterDirection.Output;
                            nReturnValue1.Value = 0;
                            var nSQLErrCode1 = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                            nSQLErrCode1.Direction = System.Data.ParameterDirection.Output;
                            nSQLErrCode1.Value = 0;
                            var sSQLErrMessage1 = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                            sSQLErrMessage1.Direction = System.Data.ParameterDirection.Output;
                            sSQLErrMessage1.Size = 500;
                            sSQLErrMessage1.Value = "";

                            UserInfoDTO objUserInfoDTO = new UserInfoDTO();
                            objUserInfoDTO = res.FirstOrDefault<UserInfoDTO>();
                            var a = db.Query<UserRoleDTO>("exec st_usr_UserRoleSave @inp_iUserInfoID,@inp_sRoleIdList,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iUserInfoID = objUserInfoDTO.UserInfoId,
                                inp_sRoleIdList = i_objUserInfoDTO.SubmittedRoleIds,
                                inp_iLoggedInUserId = i_objUserInfoDTO.LoggedInUserId,
                                out_nReturnValue = nReturnValue1,
                                out_nSQLErrCode = nSQLErrCode1,
                                out_sSQLErrMessage = sSQLErrMessage1

                            }).SingleOrDefault<UserRoleDTO>();

                            if (Convert.ToInt32(nReturnValue.Value) != 0)
                            {
                                #region Error Code
                                Exception e = new Exception();
                                out_nReturnValue = Convert.ToInt32(nReturnValue1.Value);
                                string sReturnValue = sLookupPrefix + out_nReturnValue;
                                e.Data[0] = sReturnValue;
                                if (nSQLErrCode.Value != System.DBNull.Value)
                                {
                                    out_nSQLErrCode = Convert.ToInt32(nSQLErrCode1.Value);
                                    e.Data[1] = out_nSQLErrCode;
                                }
                                if (sSQLErrMessage.Value != System.DBNull.Value)
                                {
                                    out_sSQLErrMessage = Convert.ToString(sSQLErrMessage1.Value);
                                    e.Data[2] = out_sSQLErrMessage;
                                }
                                Exception ex = new Exception(db.LastSQL.ToString(), e);
                                throw ex;
                                #endregion  Error Code
                            }

                            else
                            {
                                scope.Complete();
                                return res.FirstOrDefault();
                            }
                        }

                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion InsertUpdateUserDetails

        #region InsertUpdateUserEducationDetails
        public UserEducationDTO InsertUpdateUserEducationDetails(string i_sConnectionString, UserEducationDTO i_objUserEducationDTO)
        {
            #region Paramters
            List<UserEducationDTO> res = null;
            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";



                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {


                        res = db.Fetch<UserEducationDTO>("exec  st_usr_UserEducationSave_Employee   @inp_iUserInfoID,@inp_iInstituteName,@inp_iCourseName, @inp_iEmployerName,@inp_iDesignation,@inp_iPMonth, @inp_iPYear,@inp_iToMonth,@inp_iToYear, @inp_iFlag ,@inp_iOperation,@inp_iCreatedBy,@inp_iUEW_id, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iUserInfoID = i_objUserEducationDTO.UserInfoId,
                                inp_iInstituteName = i_objUserEducationDTO.InstituteName,
                                inp_iCourseName = i_objUserEducationDTO.CourseName,
                                inp_iEmployerName = i_objUserEducationDTO.EmployerName,
                                inp_iDesignation = i_objUserEducationDTO.Designation,
                                inp_iPMonth = i_objUserEducationDTO.PMonth,
                                inp_iPYear = i_objUserEducationDTO.PYear,
                                inp_iToMonth = i_objUserEducationDTO.ToMonth,
                                inp_iToYear = i_objUserEducationDTO.ToYear,
                                inp_iFlag = i_objUserEducationDTO.Flag,
                                inp_iOperation = i_objUserEducationDTO.Operation,
                                inp_iCreatedBy = i_objUserEducationDTO.UserInfoId,
                                inp_iUEW_id = i_objUserEducationDTO.UEW_id,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList();


                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
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
                            #endregion  Error Code
                        }

                        else
                        {


                            scope.Complete();
                            return res.FirstOrDefault();
                        }

                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        public UserEducationDTO GetUserEducationDetails(string i_sConnectionString, int inp_iUserInfoId, int inp_UEW_id)
        {
            UserEducationDTO res = null;

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

                        res = db.Query<UserEducationDTO>("exec  st_usr_GetEducationDetails @UserInfoId,@UEW_id,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {

                                UserInfoId = inp_iUserInfoId,
                                UEW_id = inp_UEW_id,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<UserEducationDTO>();

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
                    }
                }


            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion

        #region Delete
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="inp_nUserInfoId"></param>
        /// <param name="inp_nUserId"></param>
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public bool DeleteUserDetails(string i_sConnectionString, int inp_iUserInfoId, int inp_nUserId)
        {
            List<UserInfoDTO> res = null;
            bool bReturn = false;
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

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<UserInfoDTO>("exec  st_usr_UserInfoDelete @inp_iUserInfoId, @inp_nUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iUserInfoId,
                                inp_nUserId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList<UserInfoDTO>();

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
        #endregion InsertUpdateUserDetails

        #region GetUserDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="inp_iUserInfoId"></param>
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.UserInfoDTO GetUserDetails(string i_sConnectionString, int inp_iUserInfoId)
        {
            UserInfoDTO res = null;

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
                        res = db.Query<UserInfoDTO>("exec  st_usr_UserInfoDetails @inp_iUserInfoId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iUserInfoId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<UserInfoDTO>();

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
                    }
                }


            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetUserDetails

        #region GetUserSeparationDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="inp_iUserInfoId"></param>
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.UserInfoDTO GetUserSeparationDetails(string i_sConnectionString, int inp_iUserInfoId)
        {
            UserInfoDTO res = null;

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
                        res = db.Query<UserInfoDTO>("exec  st_usr_UserInfoSeparationDetails @inp_iUserInfoId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iUserInfoId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<UserInfoDTO>();

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
                    }
                }


            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetUserSeparationDetails

        #region GetUserAuthencticationDetails
        /// <summary>
        /// Get User Aunthentication details
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="inp_sLoginId"></param>
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.UserInfoDTO GetUserAuthencticationDetails(string i_sConnectionString, string inp_sLoginId)
        {
            UserInfoDTO res = null;

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
                        res = db.Query<UserInfoDTO>("exec  st_usr_AuthenticationDetails @inp_sLoginId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_sLoginId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<UserInfoDTO>();

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
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetUserAuthencticationDetails

        #region SaveUserSeparation
        /// <summary>
        /// This method is used for the insert/Update User Separation
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_tblUserInfo">User Info Datatable Object</param>
        /// <param name="i_nLoggedInUserID">Logged In User Object</param>
        /// <param name="out_nReturnValue">Return Value</param>
        /// <param name="out_nSQLErrCode">SQL Error Code</param>
        /// <param name="out_sSQLErrMessage">SQL Error Message</param>
        /// <returns></returns>
        public Boolean SaveUserSeparation(string i_sConnectionString, DataTable i_tblUserInfo, int i_nLoggedInUserID)
        {
            #region Paramters
            List<UserInfoDTO> res = null;
            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";

                var inp_tblUserSeparationType = new SqlParameter();
                inp_tblUserSeparationType.DbType = DbType.Object;
                inp_tblUserSeparationType.ParameterName = "@inp_tblUserSeparationType";
                inp_tblUserSeparationType.TypeName = "dbo.UserSeparationType";
                inp_tblUserSeparationType.SqlValue = i_tblUserInfo;
                inp_tblUserSeparationType.SqlDbType = SqlDbType.Structured;
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {


                        res = db.Query<UserInfoDTO>("exec st_usr_UserInfoSeparationSave @inp_tblUserSeparationType, @inp_iLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_tblUserSeparationType = inp_tblUserSeparationType,
                            inp_iLoggedInUserId = i_nLoggedInUserID,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<UserInfoDTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
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
                            #endregion  Error Code
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
        #endregion SaveUserSeparation

        #region Re Activate User
        /// <summary>
        /// This method is used for the Reactivate the inactive user
        /// </summary>
        /// <param name="i_tblUserInfo">User Info Datatable Object</param>
        /// <param name="i_nLoggedInUserID">Logged In User Object</param>
        /// <param name="out_nReturnValue">Return Value</param>
        /// <param name="out_nSQLErrCode">SQL Error Code</param>
        /// <param name="out_sSQLErrMessage">SQL Error Message</param>
        /// <returns></returns>
        public Boolean ReactivateUser(string i_sConnectionString, int i_UserInfoId, int i_nLoggedInUserID)
        {
            #region Paramters
            List<UserInfoDTO> res = null;
            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";

                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {


                        res = db.Query<UserInfoDTO>("exec st_usr_UserInfoReactivateUser @inp_iUserInfoId, @inp_iLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iUserInfoId = i_UserInfoId,
                            inp_iLoggedInUserId = i_nLoggedInUserID,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<UserInfoDTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
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
                            #endregion  Error Code
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
        #endregion Re Activate User

        #region ChangePassword
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objPwdMgmtDTO"></param>        
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public bool ChangePassword(string i_sConnectionString, ref PasswordManagementDTO i_objPwdMgmtDTO)
        {
            List<UserInfoDTO> res = null;
            bool bReturn = false;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters
            try
            {
                var nOutUserInfoId = new SqlParameter("@out_nUpdatedUserId", System.Data.SqlDbType.Int);
                nOutUserInfoId.Direction = System.Data.ParameterDirection.Output;
                nOutUserInfoId.Value = 0;

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


                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<UserInfoDTO>("exec  st_usr_ChangePassword @inp_iUserInfoID, @inp_sOldPassword, @inp_sNewPassword, @inp_sHashValue,@inp_sSaltValue,@out_nUpdatedUserId OUTPUT, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                @inp_iUserInfoID = i_objPwdMgmtDTO.UserInfoID,
                                @inp_sOldPassword = i_objPwdMgmtDTO.OldPassword,
                                @inp_sNewPassword = i_objPwdMgmtDTO.NewPassword,
                                @inp_sHashValue = i_objPwdMgmtDTO.HashValue,
                                @inp_sSaltValue = i_objPwdMgmtDTO.SaltValue,
                                @out_nUpdatedUserId = nOutUserInfoId,
                                @out_nReturnValue = nReturnValue,
                                @out_nSQLErrCode = nSQLErrCode,
                                @out_sSQLErrMessage = sSQLErrMessage

                            }).ToList<UserInfoDTO>();

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
                            i_objPwdMgmtDTO.UserInfoID = Convert.ToInt32(nOutUserInfoId.Value);
                            scope.Complete();
                            bReturn = true;
                        }
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
        #endregion ChangePassword

        #region ForgetPassword
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objPwdMgmtDTO"></param>        
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.PasswordManagementDTO ForgetPassword(string i_sConnectionString, PasswordManagementDTO i_objPwdMgmtDTO)
        {
            PasswordManagementDTO res = null;

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
                nReturnValue.Value = 0;
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
                        res = db.Query<PasswordManagementDTO>("exec st_usr_UserResetPasswordSave @inp_iLoginId, @inp_sHashCode, @inp_sEmailID, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                @inp_iLoginId = i_objPwdMgmtDTO.LoginID,
                                @inp_sHashCode = i_objPwdMgmtDTO.HashValue,
                                @inp_sEmailID = i_objPwdMgmtDTO.EmailID,
                                @out_nReturnValue = nReturnValue,
                                @out_nSQLErrCode = nSQLErrCode,
                                @out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<PasswordManagementDTO>();

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
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion ForgetPassword

        #region UpdateUserLastLoginTime
        /// <summary>
        /// This function will be used for updating the users last login time.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="inp_nUserInfoId"></param>
        /// <param name="inp_nUserId"></param>
        /// <returns></returns>
        public bool UpdateUserLastLoginTime(string i_sConnectionString, string i_sLoginId)
        {
            int? res = null;
            bool bReturn = false;
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

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<int?>("exec  st_usr_UserUpdateLastLoginTime @inp_sLoginId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_sLoginId = i_sLoginId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).Single<int?>();

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
        #endregion UpdateUserLastLoginTime

        #region FetchUserTypeList
        /// <summary>
        /// This method is used for get user info list by User Type.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <param name="i_objUserInfoDTO">User Type Object</param>
        /// <returns>User Information List</returns>
        public List<UserInfoDTO> FetchUserTypeList(string i_sConnectionString, int i_nUserTypeCodeId)
        {
            #region Paramters
            List<UserInfoDTO> lstUserInfoList = null;
            string sErrCode = string.Empty;
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
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                #endregion Output Param

                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    lstUserInfoList = db.Query<UserInfoDTO>("exec st_usr_FetchUserListByType @inp_nUserTypeCodeId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                    new
                    {
                        inp_nUserTypeCodeId = i_nUserTypeCodeId,
                        out_nReturnValue = nReturnValue,
                        out_nSQLErrCode = nSQLErrCode,
                        out_sSQLErrMessage = sSQLErrMessage

                    }).ToList<UserInfoDTO>();

                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        #region Return Error Code
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
                        #endregion Return Error Code
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstUserInfoList;
        }
        #endregion FetchUserTypeList

        #region GetUserFromHashCode
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString">The connection string for company</param>
        /// <param name="i_sHashCode">The HashCode for finding the userinfoid for user for which the password change is getting done.</param>        
        /// <returns></returns>
        public InsiderTradingDAL.PasswordManagementDTO GetUserFromHashCode(string i_sConnectionString, string i_sHashCode)
        {
            PasswordManagementDTO res = null;

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
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    res = db.Query<PasswordManagementDTO>("exec st_usr_GetUserIdFromHashCode @inp_sHashCode, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_sHashCode = i_sHashCode,
                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage

                        }).FirstOrDefault<PasswordManagementDTO>();

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

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetUserFromHashCode

        #region GetPasswordPolicy
        /// <summary>
        /// Fetch the Password Policy to be used for validating password.
        /// </summary>
        /// <param name="i_sConnectionString">The connection string for company</param>
        /// <returns></returns>
        public InsiderTradingDAL.PasswordPolicyDTO GetPasswordPolicy(string i_sConnectionString)
        {
            PasswordPolicyDTO res = null;

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
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    res = db.Query<PasswordPolicyDTO>("exec st_usr_GetPasswordPolicy @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @out_nReturnValue = nReturnValue,
                            @out_nSQLErrCode = nSQLErrCode,
                            @out_sSQLErrMessage = sSQLErrMessage

                        }).FirstOrDefault<PasswordPolicyDTO>();

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

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetPasswordPolicy

        #region LoginSSOUserInfo
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="inp_iUserInfoId"></param>
        /// <param name="out_nReturnValue"></param>
        /// <param name="out_nSQLErrCode"></param>
        /// <param name="out_sSQLErrMessage"></param>
        /// <returns></returns>
        public UserInfoDTO LoginSSOUserInfo(string i_sConnectionString, Hashtable ht_Parameter)
        {
            UserInfoDTO res = null;

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
                string EmployeeId = Convert.ToString(ht_Parameter["EmployeeId"]);
                string EmailId = Convert.ToString(ht_Parameter["EmailId"]);

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<UserInfoDTO>("exec st_LoginSSODetails @inp_EmployeeId,@inp_EmailId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_EmployeeId = Convert.ToString(ht_Parameter["EmployeeId"]),
                                inp_EmailId = Convert.ToString(ht_Parameter["EmailId"]),
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<UserInfoDTO>();

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
                    }
                }


            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion LoginSSOUserInfo

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

        #region GetPeriodEndPerformedUserInfoList
        /// <summary>
        /// This method is used for fetching the list of users for whom the PerformedPeriodEnd flag is set i.e. 
        /// for Employees, Corporate and Non Employee types users.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <returns>User Information List</returns>
        public List<UserInfoDTO> GetPeriodEndPerformedUserInfoList(string i_sConnectionString)
        {
            #region Paramters
            List<UserInfoDTO> lstUserInfoList = null;
            string sErrCode = string.Empty;
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
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    lstUserInfoList = db.Query<UserInfoDTO>("exec st_usr_GetUserPeriodEndPerformedList @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList();

                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        #region Return Error Code
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
                        #endregion Return Error Code
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstUserInfoList;
        }
        #endregion GetPeriodEndPerformedUserInfoList

        #region getSessionandCookiesValue
        public InsiderTradingDAL.SessionDetailsDTO GetCookieStatus(string i_sConnectionString, int inp_UserId, string inp_CookieName, bool inp_isNew, bool inp_isUpdateCookie)
        {
            SessionDetailsDTO res = null;

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
                        res = db.Query<SessionDetailsDTO>("exec  st_usr_GetCookieStatus @inp_UserId,@inp_CookieName,@inp_isNew ,@inp_isUpdateCookie,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_UserId,
                                inp_CookieName,
                                inp_isNew,
                                inp_isUpdateCookie,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<SessionDetailsDTO>();

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
                                throw new Exception(Convert.ToString(sSQLErrMessage.Value));
                            }
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
        #endregion getSessionandCookiesValue

        #region SaveSessionandCookiesValue
        public InsiderTradingDAL.SessionDetailsDTO SaveCookieStatus(string i_sConnectionString, int inp_UserId, string inp_CookieName)
        {
            SessionDetailsDTO res = null;

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
                        res = db.Query<SessionDetailsDTO>("exec  st_usr_SaveCookieStatus @inp_UserId,@inp_CookieName,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_UserId,
                                inp_CookieName,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage
                            }).FirstOrDefault<SessionDetailsDTO>();

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
                                throw new Exception(Convert.ToString(sSQLErrMessage.Value));
                            }
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
        #endregion SaveSessionandCookiesValue

        #region SaveSessionandValue
        public InsiderTradingDAL.SessionDetailsDTO SaveSessionStatus(string i_sConnectionString, int inp_UserId, string inp_CookieName)
        {
            SessionDetailsDTO res = null;

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
                        res = db.Query<SessionDetailsDTO>("exec  st_usr_SaveSessionStatus @inp_UserId,@inp_CookieName,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_UserId,
                                inp_CookieName,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage
                            }).FirstOrDefault<SessionDetailsDTO>();

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
                                throw new Exception(Convert.ToString(sSQLErrMessage.Value));
                            }
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
        #endregion SaveSessionValue

        #region DeleteCookiesStatus
        /// <summary>
        /// This method is used for delete the DMATDetails
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <param name="inp_iDMATDetailsID">DMATDetailsID</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Boolean value based on the result</returns>
        public bool DeleteCookiesStatus(string i_sConnectionString, int inp_UserId, string inp_CookieStatus)
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
                    res = db.Query<DMATDetailsDTO>("exec st_usr_DeleteCookiesStatus @inp_UserId,@inp_CookieStatus, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_UserId,
                            inp_CookieStatus,
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
        #endregion DeleteCookiesStatus

        #region GetFormTokenValue
        public InsiderTradingDAL.TokenDetailsDTO GetFormTokenStatus(string i_sConnectionString, int inp_UserId, int inp_FormId, string inp_TokenName)
        {
            TokenDetailsDTO res = null;

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
                        res = db.Query<TokenDetailsDTO>("exec  st_usr_GetFormTokenStatus @inp_UserId,@inp_FormId,@inp_TokenName,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_UserId,
                                inp_FormId,
                                inp_TokenName,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<TokenDetailsDTO>();

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
                                throw new Exception(Convert.ToString(sSQLErrMessage.Value));
                            }
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
        #endregion GetFormTokenValue

        #region SaveFormTokenValue
        public InsiderTradingDAL.TokenDetailsDTO SaveFormTokenStatus(string i_sConnectionString, int inp_UserId, int inp_FormId, string inp_TokenName)
        {
            TokenDetailsDTO res = null;

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
                        res = db.Query<TokenDetailsDTO>("exec  st_usr_SaveFormTokenStatus @inp_UserId,@inp_FormId,@inp_TokenName,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_UserId,
                                inp_FormId,
                                inp_TokenName,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage
                            }).FirstOrDefault<TokenDetailsDTO>();

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
                                throw new Exception(Convert.ToString(sSQLErrMessage.Value));
                            }
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
        #endregion SaveFormTokenValue

        #region DeleteFormToken
        /// <summary>
        /// This method is used for delete the DMATDetails
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <param name="inp_iDMATDetailsID">DMATDetailsID</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Boolean value based on the result</returns>
        public bool DeleteFormToken(string i_sConnectionString, int inp_UserId, int inp_FormID)
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
                    res = db.Query<DMATDetailsDTO>("exec st_usr_DeleteFromToken @inp_UserId,@inp_FormID,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_UserId,
                            inp_FormID,
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
        #endregion DeleteFormToken


        #region GetContactDetails
        public IEnumerable<ContactDetails> GetContactDetails(string i_sConnectionString, int inp_iUserInfoId)
        {
            PetaPoco.Database db = null;

            IEnumerable<ContactDetails> ContactList = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        ContactList = db.Query<ContactDetails>("exec  st_usr_ContactDetailsGetlist @inp_iUserInfoId",
                            new
                            {
                                inp_iUserInfoId

                            }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return ContactList;
        }
        #endregion GetContactDetails

        #region InsertUpdatecontactDetails
        /// <summary>
        /// This method is used to save InsertUpdatecontactDetails List
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>
        public ContactDetails InsertUpdatecontactDetails(string sConnectionString, DataTable dt_ContactList)
        {
            #region Paramters
            ContactDetails res = null;

            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
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
                var inp_tblContactList = new SqlParameter();
                inp_tblContactList.DbType = DbType.Object;
                inp_tblContactList.ParameterName = "@inp_tblContactDetailsType";
                inp_tblContactList.TypeName = "dbo.ContactDetailsType";
                inp_tblContactList.SqlValue = dt_ContactList;
                inp_tblContactList.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter



                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {


                        res = db.Fetch<ContactDetails>("exec st_usr_ContactDetails @inp_tblContactDetailsType, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @inp_tblContactDetailsType = inp_tblContactList,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
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
                            #endregion  Error Code
                        }

                        else
                        {


                            scope.Complete();
                            return res;
                        }
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            //return res;
        }
        #endregion InsertUpdatecontactDetails

        #region GetRelativeDetails
        public IEnumerable<ContactDetails> GetRelativeDetails(string i_sConnectionString, int inp_iRelativeInfoId)
        {
            PetaPoco.Database db = null;

            IEnumerable<ContactDetails> ContactList = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        ContactList = db.Query<ContactDetails>("exec  st_usr_RelativeContactDetailsList @inp_iRelativeInfoId",
                            new
                            {
                                inp_iRelativeInfoId

                            }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return ContactList;
        }
        #endregion GetContactDetails

        #region Block/Unblock User
        public UserInfoDTO BlockUnblockUser(string sConnectionString, int UserInfoID, bool IsBlocked, string Blocked_UnBlock_Reason, int CreatedBy)
        {
            #region Paramters
            UserInfoDTO res = null;

            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
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



                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {


                        res = db.Fetch<UserInfoDTO>("exec st_usr_BlockUnblockUser @UserInfoID,@IsBlocked,@Blocked_UnBlock_Reason,@CreatedBy, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {
                               @UserInfoID = UserInfoID,
                               @IsBlocked = IsBlocked,
                               @Blocked_UnBlock_Reason = Blocked_UnBlock_Reason,
                               @CreatedBy = CreatedBy,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
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
                            #endregion  Error Code
                        }

                        else
                        {


                            scope.Complete();
                            return res;
                        }
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            //return res;
        }
        #endregion

        #region SaveUserEulaAcceptance
        /// <summary>
        /// This method is used for the insert/Update User Separation
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_tblUserInfo">User Info Datatable Object</param>
        /// <param name="i_nLoggedInUserID">Logged In User Object</param>
        /// <param name="out_nReturnValue">Return Value</param>
        /// <param name="out_nSQLErrCode">SQL Error Code</param>
        /// <param name="out_sSQLErrMessage">SQL Error Message</param>
        /// <returns></returns>
        public Boolean SaveUserEulaAcceptance(string i_sConnectionString, int i_nUserInfo, int i_nDocumentID, bool i_nEulaAcceptanceFlag)
        {
            #region Paramters
            int res = 0;
            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
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
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {


                        res = db.Query<int>("exec st_com_SaveUserEulaAcceptance @inp_iUserId, @inp_iDocumentID, @inp_iEulaAcceptanceFlag, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iUserId = i_nUserInfo,
                            inp_iDocumentID = i_nDocumentID,
                            inp_iEulaAcceptanceFlag = i_nEulaAcceptanceFlag,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).Single<int>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
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
                            #endregion  Error Code
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
        #endregion SaveUserEulaAcceptance

        #region GetUserLoginDetails
        /// <summary>
        /// This function will return a user logged in details saved in the system database
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <returns></returns>
        public IEnumerable<AuthenticationDTO> GetUserLoginDetails(string i_sConnectionString, string s_LoggedInId, string CalledFrom)
        {
            PetaPoco.Database db = null;

            IEnumerable<AuthenticationDTO> lstUserLoginDetails = null;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        lstUserLoginDetails = db.Query<AuthenticationDTO>("exec st_usr_UserLoginDetails @inp_LoggedUserId,@inp_CalledFrom",
                         new
                         {
                             inp_LoggedUserId = s_LoggedInId,
                             inp_CalledFrom = CalledFrom

                         }).ToList();
                        scope.Complete();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstUserLoginDetails;
        }
        #endregion GetUserLoginDetails

        public bool CheckConcurrentSessionConfiguration(string i_sConnectionString)
        {
            PetaPoco.Database db = null;

            int IsActiveConcurrentSession = 0;
            try
            {
                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        IsActiveConcurrentSession = db.Query<int>("exec st_usr_ConcurrentSessionConfiguration ",
                         new
                         {
                         }).Single<int>();
                        if (Convert.ToInt32(IsActiveConcurrentSession) != 0)
                        {
                            scope.Complete();
                            return true;
                        }

                        else
                        {
                            scope.Complete();
                            return false;
                        }

                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }

    }
}
