using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL.TwoFactorAuth.DTO;
using System;
using System.Collections.Generic;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    public class TwoFactorAuthController : Controller
    {
        // GET: TwoFactorAuth
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(string calledFrom = "")
        {
            List<OTPConfigurationDTO> lstOTPConfiguration = null;
            LoginUserDetails objLoginUserDetails = null;
            int OTPDigits = 0;
            bool IsAlphaNumeric = false;
            int OTPConfigMasterID = 1;
            int UserInfoID = 0;
            string EmailId = string.Empty;
            string UserFullName = string.Empty;
            int OTPExpirationTimeInSeconds = 0;
            string GeneratedOTP = string.Empty;
            string userLoginId = string.Empty;
            bool returnResult = false;
            bool IsSendMail = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                userLoginId = objLoginUserDetails.UserName;
                if (objLoginUserDetails.ErrorMessage != null || objLoginUserDetails.SuccessMessage != null)
                {
                    ViewBag.LoginError = objLoginUserDetails.ErrorMessage;
                    ViewBag.SuccessMessage = objLoginUserDetails.SuccessMessage;
                    objLoginUserDetails.ErrorMessage = null;
                    objLoginUserDetails.SuccessMessage = null;
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                }
                else
                {
                    using (TwoFactorAuthSL objOTPAuthDAL = new TwoFactorAuthSL())
                    {
                        lstOTPConfiguration = objOTPAuthDAL.GetOTPConfiguration(objLoginUserDetails.CompanyDBConnectionString);
                        foreach (var OTPConfig in lstOTPConfiguration)
                        {
                            OTPDigits = OTPConfig.OTPDigits;
                            IsAlphaNumeric = OTPConfig.IsAlphaNumeric;
                            OTPConfigMasterID = OTPConfig.OTPConfigurationSettingMasterID;
                            OTPExpirationTimeInSeconds = OTPConfig.OTPExpirationTimeInSeconds;
                        }

                        lstOTPConfiguration = objOTPAuthDAL.GetUserDeatailsForOTP(objLoginUserDetails.CompanyDBConnectionString, userLoginId);
                        foreach (var usrDetails in lstOTPConfiguration)
                        {
                            UserInfoID = usrDetails.UserInfoId;
                            EmailId = usrDetails.EmailID;
                            UserFullName = usrDetails.FullName;
                        }
                    }

                    Session["OTPDownTime"] = OTPExpirationTimeInSeconds;
                    Random RandomeNo = new Random();
                    string OTPCharacters = Common.Common.OTPAllowedCharacters(OTPDigits);
                    if (IsAlphaNumeric)
                    {
                        GeneratedOTP = OTPCharacters;
                    }
                    else
                    {
                        GeneratedOTP = Common.Common.OTPGeneratorUsingMD5AlgorithemAndDateTimeParameters(OTPCharacters, Convert.ToString(RandomeNo.Next(10)), OTPDigits);
                    }
                    if (EmailId.Length > 0)
                    {
                        if (GeneratedOTP.Length == OTPDigits)
                        {
                            using (TwoFactorAuthSL objSaveOTP = new TwoFactorAuthSL())
                            {
                                returnResult = objSaveOTP.SaveOTPDetails(objLoginUserDetails.CompanyDBConnectionString, OTPConfigMasterID, UserInfoID, EmailId, GeneratedOTP, OTPExpirationTimeInSeconds);
                            }
                            if (returnResult)
                            {
                                IsSendMail = Common.Common.SendOTPMail(EmailId, objLoginUserDetails.CompanyName, GeneratedOTP, UserFullName);
                            }
                        }
                    }
                    else
                    {
                        Session["OTPDownTime"] = 0;
                        objLoginUserDetails.SuccessMessage = null;
                        objLoginUserDetails.ErrorMessage = Common.Common.getResource("tfa_msg_61008");
                        Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                        Common.Common.WriteLogToFile(Common.Common.getResource("tfa_msg_61008"));
                        return RedirectToAction("Index", "TwoFactorAuth", new { acid = Convert.ToString(0), calledFrom = "" });
                    }
                    if (IsSendMail)
                    {
                        objLoginUserDetails.ErrorMessage = null;
                        objLoginUserDetails.SuccessMessage = Common.Common.getResource("tfa_msg_61006");
                        Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                        Common.Common.WriteLogToFile(Common.Common.getResource("tfa_msg_61006"));
                        return RedirectToAction("Index", "TwoFactorAuth", new { acid = Convert.ToString(0), calledFrom = "" });
                    }
                }
            }
            catch (Exception exp)
            {
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);

            }
            finally
            {
                objLoginUserDetails = null;
            }
            return View("~/Views/Account/TwoFactorAuth.cshtml");
        }

        [HttpPost]
        public ActionResult OTPAuthentication(TwoFactorAuthModel objtwoFactorModel)
        {
            List<OTPConfigurationDTO> lstOTPConfiguration = null;
            LoginUserDetails objLoginUserDetails = null;
            int OTPDigits = 0;
            bool IsAlphaNumeric = false;
            int OTPConfigMasterID = 1;
            int UserInfoID = 0;
            string EmailId = string.Empty;
            int OTPExpirationTimeInSeconds = 0;
            string GeneratedOTP = string.Empty;
            string userLoginId = string.Empty;
            int returnResult = 0;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                userLoginId = objLoginUserDetails.UserName;
                using (TwoFactorAuthSL objOTPAuthDAL = new TwoFactorAuthSL())
                {
                    lstOTPConfiguration = objOTPAuthDAL.GetOTPConfiguration(objLoginUserDetails.CompanyDBConnectionString);
                    foreach (var OTPConfig in lstOTPConfiguration)
                    {
                        OTPDigits = OTPConfig.OTPDigits;
                        IsAlphaNumeric = OTPConfig.IsAlphaNumeric;
                        OTPConfigMasterID = OTPConfig.OTPConfigurationSettingMasterID;
                        OTPExpirationTimeInSeconds = OTPConfig.OTPExpirationTimeInSeconds;
                    }

                    lstOTPConfiguration = objOTPAuthDAL.GetUserDeatailsForOTP(objLoginUserDetails.CompanyDBConnectionString, userLoginId);
                    foreach (var usrDetails in lstOTPConfiguration)
                    {
                        UserInfoID = usrDetails.UserInfoId;
                        EmailId = usrDetails.EmailID;
                    }
                    if (objtwoFactorModel.OTPCode.Length == OTPDigits)
                    {
                        returnResult = objOTPAuthDAL.ValidateOTPDetails(objLoginUserDetails.CompanyDBConnectionString, OTPConfigMasterID, UserInfoID, objtwoFactorModel.OTPCode);
                    }
                    else
                    {
                        returnResult = 3;
                    }
                }
                if (returnResult == 1)
                {
                    Session["loginStatus"] = 1;
                    Session["TwoFactor"] = 0;
                    return RedirectToAction("Index", "Home", new { acid = Convert.ToString(0), calledFrom = "Login" });
                }
                else if (returnResult == 2)
                {
                    objLoginUserDetails.SuccessMessage = null;
                    objLoginUserDetails.ErrorMessage = Common.Common.getResource("tfa_msg_61004");
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                    Common.Common.WriteLogToFile(Common.Common.getResource("tfa_msg_61004"));
                    return RedirectToAction("Index", "TwoFactorAuth", new { acid = Convert.ToString(0), calledFrom = "" });
                }
                else if (returnResult == 3)
                {
                    objLoginUserDetails.SuccessMessage = null;
                    objLoginUserDetails.ErrorMessage = Common.Common.getResource("tfa_msg_61003");
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                    Common.Common.WriteLogToFile(Common.Common.getResource("tfa_msg_61003"));
                    return RedirectToAction("Index", "TwoFactorAuth", new { acid = Convert.ToString(0), calledFrom = "" });
                }
                else
                {
                    return RedirectToAction("Index", "TwoFactorAuth", new { acid = Convert.ToString(0), calledFrom = "" });
                }
            }
            catch (Exception exp)
            {
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);
                ClearAllSessions();
                return RedirectToAction("Login", "Account");
            }
            finally
            {
                objLoginUserDetails = null;

            }
        }

        public ActionResult ResendOTP()
        {
            List<OTPConfigurationDTO> lstOTPConfiguration = null;
            LoginUserDetails objLoginUserDetails = null;
            int OTPDigits = 0;
            bool IsAlphaNumeric = false;
            int OTPConfigMasterID = 1;
            int UserInfoID = 0;
            string EmailId = string.Empty;
            string UserFullName = string.Empty;
            int OTPExpirationTimeInSeconds = 0;
            string GeneratedOTP = string.Empty;
            string userLoginId = string.Empty;
            bool returnResult = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                userLoginId = objLoginUserDetails.UserName;
                using (TwoFactorAuthSL objOTPAuthDAL = new TwoFactorAuthSL())
                {
                    lstOTPConfiguration = objOTPAuthDAL.GetOTPConfiguration(objLoginUserDetails.CompanyDBConnectionString);
                    foreach (var OTPConfig in lstOTPConfiguration)
                    {
                        OTPDigits = OTPConfig.OTPDigits;
                        IsAlphaNumeric = OTPConfig.IsAlphaNumeric;
                        OTPConfigMasterID = OTPConfig.OTPConfigurationSettingMasterID;
                        OTPExpirationTimeInSeconds = OTPConfig.OTPExpirationTimeInSeconds;
                    }

                    lstOTPConfiguration = objOTPAuthDAL.GetUserDeatailsForOTP(objLoginUserDetails.CompanyDBConnectionString, userLoginId);
                    foreach (var usrDetails in lstOTPConfiguration)
                    {
                        UserInfoID = usrDetails.UserInfoId;
                        EmailId = usrDetails.EmailID;
                        UserFullName = usrDetails.FullName;
                    }
                }
                Session["OTPDownTime"] = OTPExpirationTimeInSeconds;
                Random RandomeNo = new Random();
                string OTPCharacters = Common.Common.OTPAllowedCharacters(OTPDigits);
                if (IsAlphaNumeric)
                {
                    GeneratedOTP = OTPCharacters;
                }
                else
                {
                    GeneratedOTP = Common.Common.OTPGeneratorUsingMD5AlgorithemAndDateTimeParameters(OTPCharacters, Convert.ToString(RandomeNo.Next(10)), OTPDigits);
                }
                if (EmailId.Length > 0)
                {
                    if (GeneratedOTP.Length == OTPDigits)
                    {
                        using (TwoFactorAuthSL objSaveOTP = new TwoFactorAuthSL())
                        {
                            returnResult = objSaveOTP.SaveOTPDetails(objLoginUserDetails.CompanyDBConnectionString, OTPConfigMasterID, UserInfoID, EmailId, GeneratedOTP, OTPExpirationTimeInSeconds);
                        }
                        if (returnResult)
                        {
                            Common.Common.SendOTPMail(EmailId, objLoginUserDetails.CompanyName, GeneratedOTP, UserFullName);
                        }
                    }
                }
                else
                {
                    Session["OTPDownTime"] = 0;
                    objLoginUserDetails.SuccessMessage = null;
                    objLoginUserDetails.ErrorMessage = Common.Common.getResource("tfa_msg_61008");
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                    Common.Common.WriteLogToFile(Common.Common.getResource("tfa_msg_61008"));
                    return RedirectToAction("Index", "TwoFactorAuth", new { acid = Convert.ToString(0), calledFrom = "" });
                }
            }
            catch (Exception exp)
            {
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);

            }
            objLoginUserDetails.ErrorMessage = null;
            objLoginUserDetails.SuccessMessage = Common.Common.getResource("tfa_msg_61005");
            Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
            Common.Common.WriteLogToFile("OTP has been re-sent to your registered email id");
            return RedirectToAction("Index", "TwoFactorAuth", new { acid = Convert.ToString(0), calledFrom = "" });
        }

        /// <summary>
        /// Clearing all application sessions 
        /// </summary>
        private void ClearAllSessions()
        {
            Session.Clear();
            Session.RemoveAll();
        }

    }
}