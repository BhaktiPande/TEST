using InsiderTrading.Common;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace InsiderTrading.SL
{
    public class UserInfoSL : IDisposable
    {
        #region ValidateUser
        /// <summary>
        /// This function will be used for validating if the given user is registered under the given company database.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserDetailsDTO"></param>
        public bool ValidateUser(string i_sConnectionString, AuthenticationDTO i_objAuthenticationDTO, ref UserInfoDTO o_objUserInfoDTO)
        {
            bool bReturn = false;
            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    bReturn = objUserInfoDAL.ValidateUser(i_sConnectionString, i_objAuthenticationDTO, ref o_objUserInfoDTO);
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
        public IEnumerable<UserInfoDTO> GetUserInfoList(string i_sConnectionString, UserInfoDTO i_objUserInfoDTO, out int o_nReturnValue, out int o_nErroCode,
            out string o_sErrorMessage)
        {
            IEnumerable<UserInfoDTO> userInfoList = null;
            o_nReturnValue = 0;
            o_nErroCode = 0;
            o_sErrorMessage = "";
            try
            {

                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    userInfoList = objUserInfoDAL.GetUserInfoList(i_sConnectionString, i_objUserInfoDTO);
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }

            return userInfoList;
        }
        #endregion GetUserInfoList

        #region InsertUpdateUserDetails
        /// <summary>
        /// This method is used for the insert/Update User details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">User Info Object</param>
        /// <returns></returns>
        public UserInfoDTO InsertUpdateUserDetails(string i_sConnectionString, UserInfoDTO i_objUserInfoDTO)
        {
            UserInfoDTO objUserInfoDTO = null;
            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    objUserInfoDTO = objUserInfoDAL.InsertUpdateUserDetails(i_sConnectionString, i_objUserInfoDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objUserInfoDTO;
        }

        #endregion InsertUpdateUserDetails

        #region Insert/Update/Delete
        public UserEducationDTO InsertUpdateUserEducationDetails(string i_sConnectionString, UserEducationDTO i_objUserEducationDTO)
        {
            UserEducationDTO objUserEducationDTO = null;
            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    objUserEducationDTO = objUserInfoDAL.InsertUpdateUserEducationDetails(i_sConnectionString, i_objUserEducationDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objUserEducationDTO;
        }
        public InsiderTradingDAL.UserEducationDTO GetUserDetails(string i_sConnectionString, int i_nUserInfoId, int UEW_id)
        {
            InsiderTradingDAL.UserEducationDTO res = null;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.GetUserEducationDetails(i_sConnectionString, i_nUserInfoId, UEW_id);
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
        /// <param name="i_objUserInfoDTO"></param>
        /// <returns></returns>
        public bool DeleteUserDetails(string i_sConnectionString, int i_nUserInfoId, int i_nLoggedInUserID)
        {
            bool bReturn = false;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    bReturn = objUserInfoDAL.DeleteUserDetails(i_sConnectionString, i_nUserInfoId, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
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
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.UserInfoDTO GetUserDetails(string i_sConnectionString, int i_nUserInfoId)
        {
            InsiderTradingDAL.UserInfoDTO res = null;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.GetUserDetails(i_sConnectionString, i_nUserInfoId);
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
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.UserInfoDTO GetUserSeparationDetails(string i_sConnectionString, int i_nUserInfoId)
        {
            InsiderTradingDAL.UserInfoDTO res = null;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.GetUserSeparationDetails(i_sConnectionString, i_nUserInfoId);
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
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_sLoginId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.UserInfoDTO GetUserAuthencticationDetails(string i_sConnectionString, string i_sLoginId)
        {
            InsiderTradingDAL.UserInfoDTO res = null;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.GetUserAuthencticationDetails(i_sConnectionString, i_sLoginId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetUserAuthencticationDetails

        #region GetLoginUserApplicableActions
        public void GetLoginUserApplicableActions(string i_sConnectionString, string i_sLoginId, out List<string> o_lstActivityActions, out List<int> o_lstActivityIds)
        {
            int out_iTotalRecords = 0;
            string sLookUpPrefix = "usr_msg_";
            IEnumerable<UserActivityDTO> lstActivityList = new List<UserActivityDTO>();
            //GenericSLImpl<UserActivityDTO> objGenericSLImpl = new GenericSLImpl<UserActivityDTO>();

            string sAcidURLMap = "";

            try
            {
                o_lstActivityActions = new List<string>();
                o_lstActivityIds = new List<int>();
                using (var objGenericSLImpl = new GenericSLImpl<UserActivityDTO>())
                {
                    lstActivityList = objGenericSLImpl.ListAllDataTable(i_sConnectionString, ConstEnum.GridType.ActivityList, 0, 1,
                       null, null, i_sLoginId, null, null, null, null, null,
                       null, null, null, null, null, null, null, null, null, null, null, null, null, null, out out_iTotalRecords, sLookUpPrefix);
                }
                foreach (UserActivityDTO objUserActivityDTO in lstActivityList)
                {
                    o_lstActivityIds.Add(objUserActivityDTO.ActivityId);

                    if (objUserActivityDTO.ControllerName != null)
                    {
                        string actionName = string.Empty;
                        if (!string.IsNullOrEmpty(objUserActivityDTO.ActionName))
                        {
                            actionName = objUserActivityDTO.ActionName.ToLower();
                        }

                        sAcidURLMap = objUserActivityDTO.ActivityId + "_" + objUserActivityDTO.ControllerName.ToLower() + "_" + actionName + ((objUserActivityDTO.ActionButtonName != null && objUserActivityDTO.ActionButtonName != "") ? "_" + objUserActivityDTO.ActionButtonName.ToLower() : "");
                        o_lstActivityActions.Add(sAcidURLMap);
                        sAcidURLMap = "";
                    }
                }

                o_lstActivityIds = o_lstActivityIds.Distinct().ToList();
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion GetLoginUserApplicableActions

        #region InsertUpdateUserSeparation
        /// <summary>
        /// This method is used for the insert/Update User Separation.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_tblUserInfo">User Info Datatable object</param>
        ///  /// <param name="i_nLoggedInUserID">Logged In User Id</param>
        /// <returns></returns>
        public Boolean SaveUserSeparation(string i_sConnectionString, DataTable i_tblUserInfo, int i_nLoggedInUserID)
        {
            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    objUserInfoDAL.SaveUserSeparation(i_sConnectionString, i_tblUserInfo, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return true;
        }
        #endregion InsertUpdateUserDetails

        #region Re Activate User
        /// <summary>
        /// This method is used for the Reactivate the inactive user
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_tblUserInfo">User Info Datatable object</param>
        ///  /// <param name="i_nLoggedInUserID">Logged In User Id</param>
        /// <returns></returns>
        public Boolean ReactivateUser(string i_sConnectionString, int i_UserInfoId, int i_nLoggedInUserID)
        {
            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    return objUserInfoDAL.ReactivateUser(i_sConnectionString, i_UserInfoId, i_nLoggedInUserID);
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
        /// <param name="i_objUserInfoDTO"></param>
        /// <returns></returns>
        public bool ChangePassword(string i_sConnectionString, ref PasswordManagementDTO i_objPwdMgmtDTO)
        {
            bool bReturn = false;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    bReturn = objUserInfoDAL.ChangePassword(i_sConnectionString, ref i_objPwdMgmtDTO);
                }
            }
            catch (Exception exp)
            {
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
        /// <param name="i_objUserInfoDTO"></param>
        /// <returns></returns>
        public PasswordManagementDTO ForgetPassword(string i_sConnectionString, PasswordManagementDTO i_objPwdMgmtDTO)
        {
            PasswordManagementDTO res = null;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.ForgetPassword(i_sConnectionString, i_objPwdMgmtDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }

        #endregion ForgetPassword

        #region GetUserFromHashCode
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserInfoDTO"></param>
        /// <returns></returns>
        public PasswordManagementDTO GetUserFromHashCode(string i_sConnectionString, string i_sHashCode)
        {
            PasswordManagementDTO res = null;

            try
            {
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.GetUserFromHashCode(i_sConnectionString, i_sHashCode);
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
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserInfoDTO"></param>
        /// <returns></returns>
        public InsiderTradingDAL.PasswordPolicyDTO GetPasswordPolicy(string i_sConnectionString)
        {
            PasswordPolicyDTO res = null;

            try
            {
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.GetPasswordPolicy(i_sConnectionString);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }

        #endregion GetPasswordPolicy

        #region UpdateUserLastLoginTime
        /// <summary>
        /// This function will be called for updating the users last login time. 
        /// The login time will be updated whenever user logins to the system.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserInfoDTO"></param>
        /// <returns></returns>
        public void UpdateUserLastLoginTime(string i_sConnectionString, string i_sLoginId)
        {
            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    objUserInfoDAL.UpdateUserLastLoginTime(i_sConnectionString, i_sLoginId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }

        #endregion ForgetPassword

        #region GetPeriodEndPerformedUserInfoList
        /// <summary>
        /// This method is used for fetching the list of users for whom the PerformedPeriodEnd flag is set i.e. 
        /// for Employees, Corporate and Non Employee types users.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string for which database</param>
        /// <returns>User Information List</returns>
        public List<UserInfoDTO> GetPeriodEndPerformedUserInfoList(string i_sConnectionString)
        {
            List<UserInfoDTO> userInfoList = new List<UserInfoDTO>();
            try
            {
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    userInfoList = objUserInfoDAL.GetPeriodEndPerformedUserInfoList(i_sConnectionString);
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }

            return userInfoList;
        }
        #endregion GetPeriodEndPerformedUserInfoList

        #region GetSessionandCookiesValue
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_sLoginId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.SessionDetailsDTO GetCookieStatus(string i_sConnectionString, int inp_UserId, string inp_CookieName, bool inp_isNew, bool inp_isUpdateCookie)
        {
            InsiderTradingDAL.SessionDetailsDTO res = null;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.GetCookieStatus(i_sConnectionString, inp_UserId, inp_CookieName, inp_isNew, inp_isUpdateCookie);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetSessionandCookiesValue

        #region SaveSessionandCookiesValue
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_sLoginId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.SessionDetailsDTO SaveCookieStatus(string i_sConnectionString, int inp_UserId, string inp_CookieName)
        {
            InsiderTradingDAL.SessionDetailsDTO res = null;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.SaveCookieStatus(i_sConnectionString, inp_UserId, inp_CookieName);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion SaveSessionandCookiesValue

        #region SaveSessionValue
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_sLoginId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.SessionDetailsDTO SaveSessionStatus(string i_sConnectionString, int inp_UserId, string inp_CookieName)
        {
            InsiderTradingDAL.SessionDetailsDTO res = null;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.SaveSessionStatus(i_sConnectionString, inp_UserId, inp_CookieName);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion SaveSessionandCookiesValue

        #region DeleteCookiesStatus
        /// <summary>
        /// This method is used for the insert/Update DMAT details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_nDMATAccountHoderID">DMATAccountHoderID to delete</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Returns boolean value based on the result</returns>
        public bool DeleteCookiesStatus(string i_sConnectionString, int i_nLoggedInUserID, string inp_CookieStatus)
        {
            bool bReturn = false;
            try
            {
                //DMATDetailsDAL objDMATDetailsDAL = new DMATDetailsDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    bReturn = objUserInfoDAL.DeleteCookiesStatus(i_sConnectionString, i_nLoggedInUserID, inp_CookieStatus);
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }

            return bReturn;
        }
        #endregion DeleteCookiesStatus


        #region GetFormTokenValue
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_sLoginId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.TokenDetailsDTO GetFormTokenStatus(string i_sConnectionString, int inp_UserId, string inp_TokenName, int inp_FormId)
        {
            InsiderTradingDAL.TokenDetailsDTO res = null;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.GetFormTokenStatus(i_sConnectionString, inp_UserId, inp_FormId, inp_TokenName);
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
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_sLoginId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.TokenDetailsDTO SaveFormTokenStatus(string i_sConnectionString, int inp_UserId, int inp_FormId, string inp_CookieName)
        {
            InsiderTradingDAL.TokenDetailsDTO res = null;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.SaveFormTokenStatus(i_sConnectionString, inp_UserId, inp_FormId, inp_CookieName);
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
        /// This method is used for the insert/Update DMAT details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_nDMATAccountHoderID">DMATAccountHoderID to delete</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Returns boolean value based on the result</returns>
        public bool DeleteFormToken(string i_sConnectionString, int i_nLoggedInUserID, int i_FormID)
        {
            bool bReturn = false;
            try
            {
                //DMATDetailsDAL objDMATDetailsDAL = new DMATDetailsDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    bReturn = objUserInfoDAL.DeleteFormToken(i_sConnectionString, i_nLoggedInUserID, i_FormID);
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }

            return bReturn;
        }
        #endregion DeleteDMATHolder

        #region GetContactDetails

        public List<ContactDetails> GetContactDetails(string i_sConnectionString, int i_nUserInfoId)
        {
            List<ContactDetails> lstGroupDocumentList = new List<ContactDetails>();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL(); 
            try
            {
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    lstGroupDocumentList = objUserInfoDAL.GetContactDetails(i_sConnectionString, i_nUserInfoId).ToList<ContactDetails>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstGroupDocumentList;
        }
        #endregion
        #region GetRelativeDetails

        public List<ContactDetails> GetRelativeDetails(string i_sConnectionString, int i_nUserInfoId)
        {
            List<ContactDetails> GetRelativeDetails = new List<ContactDetails>();
            //InsiderTradingDAL.CompanyDAL objCompanyDAL = new InsiderTradingDAL.CompanyDAL(); 
            try
            {
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    GetRelativeDetails = objUserInfoDAL.GetRelativeDetails(i_sConnectionString, i_nUserInfoId).ToList<ContactDetails>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return GetRelativeDetails;
        }
        #endregion

        #region InsertUpdatecontactDetails
        /// <summary>
        /// This method is used to save Contact Details List
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objPreclearanceRequestNonImplCompanyDTO"></param>
        /// <returns></returns>
        public ContactDetails InsertUpdatecontactDetails(string i_sConnectionString, DataTable dt_ContactDetails)
        {
            ContactDetails objContactDetailsDTO = null;

            try
            {
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    objContactDetailsDTO = objUserInfoDAL.InsertUpdatecontactDetails(i_sConnectionString, dt_ContactDetails);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return objContactDetailsDTO;

        }
        #endregion InsertUpdatecontactDetails

        #region Block/Unblock User

        public UserInfoDTO BlockUnblockUser(string i_sConnectionString, int UserInfoID, bool IsBlocked, string Blocked_UnBlock_Reason, int CreatedBy)
        {
            UserInfoDTO objUserInfoDTO = null;

            try
            {
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    objUserInfoDTO = objUserInfoDAL.BlockUnblockUser(i_sConnectionString, UserInfoID, IsBlocked, Blocked_UnBlock_Reason, CreatedBy);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return objUserInfoDTO;

        }
        #endregion InsertUpdatecontactDetails
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

        #region SaveUserEulaAcceptance
        /// <summary>
        /// This method is used for the insert/Update User Separation.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_tblUserInfo">User Info Datatable object</param>
        ///  /// <param name="i_nLoggedInUserID">Logged In User Id</param>
        /// <returns></returns>
        public Boolean SaveUserEulaAcceptance(string i_sConnectionString, int i_nUserInfo, int i_nDocumentID, bool i_nEulaAcceptanceFlag)
        {
            try
            {
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    objUserInfoDAL.SaveUserEulaAcceptance(i_sConnectionString, i_nUserInfo, i_nDocumentID, i_nEulaAcceptanceFlag);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return true;
        }
        #endregion SaveUserEulaAcceptance

        #region GetUserLoginDetails

        /// <summary>
        /// This method is used for the get user Details
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="LoggedInId">LoggedInId</param>
        /// <returns>Object Authentication DTO</returns>

        public List<AuthenticationDTO> GetUserLoginDetails(string i_sConnectionString, string LoggedInId, string CalledFrom)
        {
            List<AuthenticationDTO> lstUserLoginDetails = new List<AuthenticationDTO>();

            try
            {
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    lstUserLoginDetails = objUserInfoDAL.GetUserLoginDetails(i_sConnectionString, LoggedInId, CalledFrom).ToList<AuthenticationDTO>();
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
            bool bReturn = false;
            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    bReturn = objUserInfoDAL.CheckConcurrentSessionConfiguration(i_sConnectionString);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bReturn;
        }
    }
}