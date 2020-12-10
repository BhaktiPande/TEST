using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.SL;
using InsiderTradingDAL;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class FAQController : Controller
    {
        /// <summary>
        /// This action will be used for showing the FAQ section on the dashboard based on the user type.
        /// </summary>
        /// <returns></returns>
        /// 
        public ActionResult Index(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            
            //TemplateMasterSL objTemplateMasterSL = new TemplateMasterSL();
            List<FAQDTO> lstFAQList = new List<FAQDTO>();
            try
            {
                using (TemplateMasterSL objTemplateMasterSL = new TemplateMasterSL())
                {
                    lstFAQList = objTemplateMasterSL.GetFAQDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.UserTypeCodeId, 0, 1, "", "", true);
                }
                ViewBag.UserTypeCodeId = objLoginUserDetails.UserTypeCodeId;
                ViewBag.FAQList = lstFAQList;
                ViewBag.ForDashboard = true;
            }
            finally
            {
                lstFAQList = null;
            }
            return View("FAQDashboard");
        }

        /// <summary>
        /// This action will be used show the CO FAQ list showing all the FAQ's in tree structure for CO user
        /// </summary>
        /// <param name="acid"></param>
        /// <param name="parentid">The parent menuid, is case when a FAQ element is clicked on the dashboard then it should open the corresponding FAQ element.</param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult COFAQList(int acid, string parentid = "0")
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            //TemplateMasterSL objTemplateMasterSL = new TemplateMasterSL();
            List<FAQDTO> lstFAQList = new List<FAQDTO>();
            try
            {
                using (TemplateMasterSL objTemplateMasterSL = new TemplateMasterSL())
                {
                    lstFAQList = objTemplateMasterSL.GetFAQDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.UserTypeCodeId, 0, 1, "", "", false);
                }
                ViewBag.FAQList = lstFAQList;
                ViewBag.ForDashboard = false;
                ViewBag.ParentId = parentid;
            }
            finally
            {
                lstFAQList = null;
            }
            return View("FAQList");

        }

        /// <summary>
        /// This action will be used show the Insider FAQ detailed list showing all the FAQ's in tree structure
        /// </summary>
        /// <param name="acid"></param>
        /// <param name="parentid">The parent menuid, is case when a FAQ element is clicked on the dashboard then it should open the corresponding FAQ element.</param>/// 
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult InsiderFAQList(int acid, string parentid = "0")
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            //TemplateMasterSL objTemplateMasterSL = new TemplateMasterSL();
            List<FAQDTO> lstFAQList = new List<FAQDTO>();
            try
            {
                using (TemplateMasterSL objTemplateMasterSL = new TemplateMasterSL())
                {
                    lstFAQList = objTemplateMasterSL.GetFAQDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.UserTypeCodeId, 0, 1, "", "", false);
                }
                ViewBag.FAQList = lstFAQList;
                ViewBag.ForDashboard = false;
                ViewBag.ParentId = parentid;
            }
            finally
            {
                lstFAQList = null;
            }
            return View("FAQList");

        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
	}
}