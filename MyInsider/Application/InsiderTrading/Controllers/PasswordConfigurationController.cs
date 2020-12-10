using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class PasswordConfigurationController : Controller
    {
        //
        // GET: /PasswordConfiguration/
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            PasswordConfigSL objPassConfigSL = new PasswordConfigSL();
            PasswordConfigModel objPassConfigModel = new PasswordConfigModel();
            PasswordConfigDTO objPassConfigDTO = new PasswordConfigDTO();
            objPassConfigDTO = objPassConfigSL.GetPasswordConfigDetails(objLoginUserDetails.CompanyDBConnectionString);
            InsiderTrading.Common.Common.CopyObjectPropertyByName(objPassConfigDTO, objPassConfigModel);
            ViewBag.Acid = acid;
            return View(objPassConfigModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [Button(ButtonName = "SavePasswordConfiguration")]
        [ActionName("SavePasswordConfiguration")]
        public ActionResult SavePasswordConfiguration(int acid, PasswordConfigModel objPassConfigModel)
        {
            if (objPassConfigModel.MinLength < 4)
            {
                ModelState.AddModelError("MinLength", Common.Common.getResource("pc_msg_50572"));
            }
            if(objPassConfigModel.MinLength>objPassConfigModel.MaxLength)
            {
                ModelState.AddModelError("MaxLength", Common.Common.getResource("pc_msg_50573"));
            }
            if (objPassConfigModel.LoginAttempts==0)
            {
                ModelState.AddModelError("LoginAttempts", Common.Common.getResource("pc_msg_50574"));
            }
            if (objPassConfigModel.MinAlphabets ==0 && objPassConfigModel.MinNumbers==0 && objPassConfigModel.MinSplChar== 0 && objPassConfigModel.MinUppercaseChar==0)
            {
                ModelState.AddModelError(" ", Common.Common.getResource("pc_msg_50575"));
            }
            int sum = objPassConfigModel.MinAlphabets + objPassConfigModel.MinNumbers + objPassConfigModel.MinSplChar + objPassConfigModel.MinUppercaseChar;
            if (sum > objPassConfigModel.MaxLength)
            {
                ModelState.AddModelError(" ", Common.Common.getResource("pc_msg_50575"));
            }
            if (objPassConfigModel.ExpiryReminder > objPassConfigModel.PassValidity)
            {
                ModelState.AddModelError(" ", Common.Common.getResource("pc_msg_50596"));
            }
            if (objPassConfigModel.PassValidity == 0)
            {
                ModelState.AddModelError(" ", Common.Common.getResource("pc_msg_50626"));
            }
            if (objPassConfigModel.MaxLength == 0)
            {
                objPassConfigModel.MaxLength = 20;
            }
            if (objPassConfigModel.PassValidity == 0)
            {
                objPassConfigModel.PassValidity = 45;
            }
            if (ModelState.IsValid)
            {
                LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                PasswordConfigSL objPassConfigSL = new PasswordConfigSL();
                PasswordConfigDTO objPassConfigDTO = new PasswordConfigDTO();
                objPassConfigModel.LastUpdatedBy = objLoginUserDetails.LoggedInUserID.ToString();
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objPassConfigModel, objPassConfigDTO);
                objPassConfigSL.SavePasswordConfigDetails(objLoginUserDetails.CompanyDBConnectionString, objPassConfigDTO);
                string AlertMessage = Common.Common.getResource("pc_msg_50571");
                return View("Index", objPassConfigModel).Success(HttpUtility.UrlEncode(AlertMessage));
            }
            return View("Index", objPassConfigModel); ;
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "ResetPasswordConfiguration")]
        [ActionName("SavePasswordConfiguration")]
        public ActionResult ResetPasswordConfiguration(FormCollection collection)
        {
            ModelState.Clear();
            PasswordConfigModel objPassConfigModel = new PasswordConfigModel();
            return View("Index",objPassConfigModel);
        }
	}
}