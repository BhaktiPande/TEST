using InsiderTrading.Common;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;

namespace InsiderTrading.Controllers
{
    public class MenuController : Controller
    {
        const string sLookUpPrefix = "com_msg_";
        //
        // GET: /Menu/
        [ChildActionOnly]
        public PartialViewResult Index()
        {
            LoginUserDetails objLoginUserDetails = null;

            IEnumerable<InsiderTradingDAL.MenuMasterDTO> lstMenu = null;

            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                
                int out_iTotalRecords = 0;

                using (GenericSLImpl<InsiderTradingDAL.MenuMasterDTO> g = new GenericSLImpl<InsiderTradingDAL.MenuMasterDTO>())
                {
                    lstMenu = g.ListAllDataTable(objLoginUserDetails.CompanyDBConnectionString, Common.ConstEnum.GridType.MenuList, 10, 1,
                        null, null, objLoginUserDetails.LoggedInUserID.ToString(), null, null, null,
                        null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, out  out_iTotalRecords, sLookUpPrefix);

                    //Replace the query string parameter during building of the Menu
                    #region ReplaceQueryStringParameters
                    for (int key = 0; key < lstMenu.Count(); key++)
                    {

                        if (lstMenu.ElementAt(key).MenuURL != null && lstMenu.ElementAt(key).MenuURL.Contains("{UserInfoID}"))
                        {
                            lstMenu.ElementAt(key).MenuURL = lstMenu.ElementAt(key).MenuURL.Replace("{UserInfoID}", objLoginUserDetails.LoggedInUserID.ToString());
                        }
                    }
                    #endregion ReplaceQueryStringParameters
                }

                ViewBag.Menu = lstMenu;
                ViewBag.LoginUserName = objLoginUserDetails.UserName;
                ViewBag.IsChangePassword = Common.Common.GetSessionValue("IsChangePassword") == null ? false : Common.Common.GetSessionValue("IsChangePassword");
                Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());
                TempData["MenuList"] = lstMenu;
                return PartialView("_menuLayout", lstMenu);
            }
            catch (Exception exp)
            {
                Common.Common.WriteLogToFile("exception occured", System.Reflection.MethodBase.GetCurrentMethod(), exp);

                return PartialView("_menuLayout");
            }
            finally
            {
                objLoginUserDetails = null;
            }

        }

        #region Set Session for Selected Menu
        /// <summary>
        /// 
        /// </summary>
        /// <param name="SelectedParentId"></param>
        /// <returns></returns>
        public ActionResult SetSession(string SelectedParentId)
        {
            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            objLoginUserDetails.SelectedParentID = SelectedParentId;
            objLoginUserDetails.SelectedChildId = "";
            
            Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
            
            objLoginUserDetails = null;

            Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());

            return this.Json(new { success = true });
        }
        #endregion Set Session for Selected Menu

        #region GetSelectedMenu
        /// <summary>
        /// Get Selected Menu
        /// </summary>
        /// <returns></returns>
        public ActionResult GetSelectedMenu()
        {
            string returnString = "";
            string selectedChildId = "";
            
            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                returnString = objLoginUserDetails.SelectedParentID;
                selectedChildId = objLoginUserDetails.SelectedChildId;
            }
            catch (Exception exception)
            {
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exception);

                returnString = exception.Message;
            }
            finally
            {
                objLoginUserDetails = null;
            }

            Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());

            return this.Json(new { success = true, SelectedParentID = returnString, SelectedChildId = selectedChildId });
        }
        #endregion GetSelectedMenu

        public ActionResult SetChildSession(string SelectedChildId)
        {
            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            bool bReturn = false;
            if (objLoginUserDetails != null)
            {
                objLoginUserDetails.SelectedChildId = SelectedChildId;
                Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                bReturn = true;
            }

            Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());

            return this.Json(new { success = bReturn });
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }

        #region Restricted List- Clear pre-clearance request for non implementing company list 
        public ActionResult ClearPreClrList()
        {
            bool bReturn = false;
            if (TempData["List"] != null)
            {
                TempData.Remove("List");
                bReturn = true;
            }
            if (TempData["SearchArray"]!=null)
            {
                TempData.Remove("SearchArray");
                bReturn = true;
            }
            if (TempData["PreClrList"] != null)
            {
                TempData.Remove("PreClrList");
                bReturn = true;
            }
            else
                bReturn = false;
            return this.Json(new { success = bReturn });
        }
        #endregion
    }
}