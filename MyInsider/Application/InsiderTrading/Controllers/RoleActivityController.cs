using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using System.Web.Routing;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class RoleActivityController : Controller
    {
        //
        // GET: /RoleActivity/
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int RoleId, string CalledFrom, int acid, int uid = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            Dictionary<string, Dictionary<string, List<InsiderTradingDAL.RoleActivityDTO>>> objRoleActivityDictionary = null;

            RoleActivityModel objRoleActivityModel = null;
            RoleMasterDTO objRoleMasterDTO = null;
            ComCodeDTO objComCodeDTO = null;

            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> lstRoleList = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                
                //GenericSLImpl<InsiderTradingDAL.UserInfoDTO> objGenericSLImpl = new GenericSLImpl<InsiderTradingDAL.UserInfoDTO>();


                objRoleActivityModel = new RoleActivityModel();

                if (RoleId != 0)
                {
                    using (RoleActivitySL objRoleActivitySL = new RoleActivitySL())
                    {
                        objRoleActivityDictionary = objRoleActivitySL.GetRoleActivityDetails(objLoginUserDetails.CompanyDBConnectionString, RoleId);
                    }

                    using (RoleMasterSL objRoleMasterSL = new RoleMasterSL())
                    {
                        objRoleMasterDTO = objRoleMasterSL.GetRoleMasterDetails(objLoginUserDetails.CompanyDBConnectionString, RoleId);
                    }

                    using (ComCodeSL objComCodeSL = new ComCodeSL())
                    {
                        objComCodeDTO = objComCodeSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, objRoleMasterDTO.UserTypeCodeId);
                    }
                    
                    ViewBag.RoleName = objRoleMasterDTO.RoleName;
                    ViewBag.UserType = objComCodeDTO.CodeName;
                }
                else
                {
                    ViewBag.RoleName = "";
                    ViewBag.UserType = "";
                }
                ViewBag.CalledFrom = CalledFrom;

                ViewBag.RoleId = RoleId;
                ViewBag.ColumnCount = 3;
                if (CalledFrom == "RoleMaster")
                {

                    ViewBag.RoleActivityDictionary = objRoleActivityDictionary;
                }
                else if (CalledFrom == "RoleActivity")
                {
                    if (RoleId != 0)
                    {
                        ViewBag.RoleActivityDictionary = objRoleActivityDictionary;
                    }
                    
                    objPopulateComboDTO = new PopulateComboDTO();
                    objPopulateComboDTO.Key = "0";
                    objPopulateComboDTO.Value = "Select";

                    lstRoleList = new List<PopulateComboDTO>();

                    lstRoleList.Add(objPopulateComboDTO);
                    lstRoleList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RoleList,
                        null, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                    ViewBag.RoleList = lstRoleList; // new SelectList(lstRoleList, "Key", "Value");

                }
                else
                {
                    ViewBag.RoleActivityDictionary = objRoleActivityDictionary;
                }

                ViewBag.user_id = uid;

                ViewBag.user_action = acid;

                if (CalledFrom != "" && CalledFrom != "RoleMaster" && CalledFrom != "RoleActivity")
                {
                    return PartialView("Create", objRoleActivityModel);
                }
                else
                {
                    return View("Create", objRoleActivityModel);
                }
            }
            finally
            {
                objLoginUserDetails = null;
                objRoleActivityDictionary = null;
                objRoleMasterDTO = null;
                objComCodeDTO = null;

                objPopulateComboDTO = null;
                lstRoleList = null;
            }
        }

        //
        // GET: /RoleActivity/Details/5
        [AuthorizationPrivilegeFilter]
        public ActionResult Details(int id, int acid)
        {
            return View();
        }

        //
        // GET: /RoleActivity/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "dropdown")]
        [ActionName("Create")]
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int RoleId, string CalledFrom, int acid)
        {
            return RedirectToAction("Index", "RoleActivity", new { RoleId = RoleId, CalledFrom = CalledFrom, acid = acid });
        }

        //
        // POST: /RoleActivity/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [Button(ButtonName = "Create")]
        [ActionName("Create")]
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int[] chkActivity, int RoleId, string CalledFrom, int acid=0, int uid = 0)
        {
            bool returnValue = false;

            LoginUserDetails objLoginUserDetails = null;
            RoleMasterDTO objRoleMasterDTO = null;
            DataTable tblRoleActivity = null;
            RoleActivityModel objRoleActivityModel = null;
            ComCodeDTO objComCodeDTO = null;
            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> lstRoleList = null;

            try
            {
                tblRoleActivity = new DataTable("RoleActivityType");

                if (Request.Params["authorization"] != null && Request.Params["authorization"] != "")
                {
                    acid = Convert.ToInt32(Request.Params["authorization"].Split(':')[1]);
                }

                tblRoleActivity.Columns.Add(new DataColumn("RoleId", typeof(int)));
                tblRoleActivity.Columns.Add(new DataColumn("ActivityId", typeof(int)));
                
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                
                if (chkActivity != null)
                {
                    DataRow row = null;
                    foreach (int ActivityId in chkActivity)
                    {
                        row = tblRoleActivity.NewRow();
                        row["RoleId"] = RoleId;
                        row["ActivityId"] = ActivityId;
                        tblRoleActivity.Rows.Add(row);
                    }
                    row = null;
                }
                else
                {
                   // When all activity Ids is deleted then the param @inp_tblRoleActivityType have the ActivityId = 0
                    DataRow row = tblRoleActivity.NewRow();
                    row["RoleId"] = RoleId;
                    row["ActivityId"] = 0;
                    tblRoleActivity.Rows.Add(row);
                }

                using (RoleActivitySL objRoleActivitySL = new RoleActivitySL())
                {
                    returnValue = objRoleActivitySL.InsertDeleteRoleActivities(objLoginUserDetails.CompanyDBConnectionString, tblRoleActivity, objLoginUserDetails.LoggedInUserID);
                }
                
                using (RoleMasterSL objRoleMasterSL = new RoleMasterSL())
                {
                    objRoleMasterDTO = objRoleMasterSL.GetRoleMasterDetails(objLoginUserDetails.CompanyDBConnectionString, RoleId);
                }
                
                string successMessage = Common.Common.getResource("usr_msg_12055");
                
                successMessage = successMessage.Replace("{0}", (objRoleMasterDTO.RoleName.Replace("'", "\'").Replace("\"", "\"")));

                //check "CalledFrom" value and redirect back to show page related page
                if (CalledFrom == "emp" || CalledFrom == "nonemp" || CalledFrom == "corp" || CalledFrom == "cousr")
                {
                    //NOTE - Commented following code because it is not used after redirect call change to JSON response instead of redirect to page
                    #region COMMENTED CODE
                    ////string view_name = "";
                    ////string contorller_name = "";
                    //RouteValueDictionary controller_paramter = new RouteValueDictionary();
                    //string success_msg = Common.Common.getResource("usr_msg_12053");

                    //switch (CalledFrom)
                    //{
                    //    case "emp": //link from employee page
                    //        if (uid == 0)
                    //        {
                    //            //employee create page
                    //            //view_name = "Create";
                    //            //contorller_name = "Employee";
                    //            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_CREATE);
                    //        }
                    //        else
                    //        {
                    //            //employee edit page
                    //            //view_name = "Create";
                    //            //contorller_name = "Employee";
                    //            controller_paramter.Add("nUserInfoID", uid);
                    //            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT);
                    //        }
                    //        break;
                    //    case "nonemp": //link from non employee page
                    //        if (uid == 0)
                    //        {
                    //            //non employee create page
                    //            //view_name = "Create";
                    //            //contorller_name = "NonEmployeeInsider";
                    //            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_CREATE);
                    //        }
                    //        else
                    //        {
                    //            //non employee edit page
                    //            //view_name = "Create";
                    //            //contorller_name = "NonEmployeeInsider";
                    //            controller_paramter.Add("nUserInfoID", uid);
                    //            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT);
                    //        }
                    //        break;
                    //    case "corp": //link from corporate employee page
                    //        if (uid == 0)
                    //        {
                    //            //corporate employee create page
                    //            //view_name = "index";
                    //            //contorller_name = "CorporateUser";
                    //            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_CREATE);
                    //        }
                    //        else
                    //        {
                    //            //corporate employee edit page
                    //            //view_name = "Edit";
                    //            //contorller_name = "CorporateUser";
                    //            controller_paramter.Add("nUserInfoID", uid);
                    //            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT);
                    //        }
                    //        break;
                    //    case "cousr": //link from CO user page
                    //        if (uid == 0)
                    //        {
                    //            //CO user create page
                    //            //view_name = "Create";
                    //            //contorller_name = "UserDetails";
                    //            //controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.CRUSER_COUSER_CREATE);
                    //        }
                    //        else
                    //        {
                    //            //CO user edit page
                    //            //view_name = "Edit";
                    //            //contorller_name = "UserDetails";
                    //            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.CRUSER_COUSER_EDIT);
                    //            controller_paramter.Add("CalledFrom", "Edit");
                    //            controller_paramter.Add("UserInfoID", uid);

                    //        }
                    //        break;
                    //    default:
                    //        //default return to role master list page
                    //        //view_name = "Index";
                    //        //contorller_name = "RoleMaster";
                    //        controller_paramter.Add("acid", Common.ConstEnum.UserActions.CRUSER_ROLEMASTER_VIEW);
                    //        break;
                    //}
                    #endregion COMMENTED CODE
                    
                    return Json(new
                    {
                        status = true,
                        Message = Common.Common.getResource("tra_msg_16153"),
                        RoleName = objRoleMasterDTO.RoleName,
                        RoleId = objRoleMasterDTO.RoleId,
                        IsActive = (objRoleMasterDTO.StatusCodeId == ConstEnum.Code.RoleStatusActive ? true : false),
                        CalledFrom = CalledFrom

                    }, JsonRequestBehavior.AllowGet);
                    //return RedirectToAction(view_name, contorller_name, controller_paramter).Success(success_msg);
                }

                //return RedirectToAction("Index", "RoleActivity", new { RoleId = RoleId, CalledFrom = "RoleMaster", acid = InsiderTrading.Common.ConstEnum.UserActions.CRUSER_ROLEMASTER_EDIT }).Success(successMessage);
                return RedirectToAction("Index", "RoleMaster", new { acid = InsiderTrading.Common.ConstEnum.UserActions.CRUSER_ROLEMASTER_VIEW }).Success(successMessage);

            }
            catch (Exception exp)
            {
                string sErrMessage = "";
                if (exp.InnerException != null && exp.InnerException.Data != null && exp.InnerException.Data.Count > 0)
                {
                    sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                }
                else
                {
                    sErrMessage = exp.Message;
                }
                ModelState.AddModelError("Error", sErrMessage);
                if (CalledFrom != "" && (CalledFrom == "emp" || CalledFrom == "nonemp" || CalledFrom == "corp" || CalledFrom == "cousr"))
                {
                    return Json(new
                    {
                        status = false,
                        error = ModelState.ToSerializedDictionary(),
                        Message = sErrMessage
                    });
                }
                else
                {
                    objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                    Dictionary<string, Dictionary<string, List<InsiderTradingDAL.RoleActivityDTO>>> objRoleActivityDictionary = null;
                    //GenericSLImpl<InsiderTradingDAL.UserInfoDTO> objGenericSLImpl = new GenericSLImpl<InsiderTradingDAL.UserInfoDTO>();

                    if (RoleId != 0)
                    {
                        using (RoleActivitySL objRoleActivitySL = new RoleActivitySL())
                        {
                            objRoleActivityDictionary = objRoleActivitySL.GetRoleActivityDetails(objLoginUserDetails.CompanyDBConnectionString, RoleId);
                        }
                        
                        using (RoleMasterSL objRoleMasterSL = new RoleMasterSL())
                        {
                            objRoleMasterDTO = objRoleMasterSL.GetRoleMasterDetails(objLoginUserDetails.CompanyDBConnectionString, RoleId);
                        }

                        using (ComCodeSL objComCodeSL = new ComCodeSL())
                        {
                            objComCodeDTO = objComCodeSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, objRoleMasterDTO.UserTypeCodeId);
                        }

                        ViewBag.RoleName = objRoleMasterDTO.RoleName;
                        ViewBag.UserType = objComCodeDTO.CodeName;
                    }
                    else
                    {
                        ViewBag.RoleName = "";
                        ViewBag.UserType = "";
                    }
                    ViewBag.CalledFrom = CalledFrom;

                    ViewBag.RoleId = RoleId;
                    ViewBag.ColumnCount = 3;
                    if (CalledFrom == "RoleMaster")
                    {

                        ViewBag.RoleActivityDictionary = objRoleActivityDictionary;
                    }
                    else if (CalledFrom == "RoleActivity")
                    {
                        if (RoleId != 0)
                        {
                            ViewBag.RoleActivityDictionary = objRoleActivityDictionary;
                        }
                        
                        objPopulateComboDTO = new PopulateComboDTO();
                        objPopulateComboDTO.Key = "0";
                        objPopulateComboDTO.Value = "Select";

                        lstRoleList = new List<PopulateComboDTO>();

                        lstRoleList.Add(objPopulateComboDTO);
                        lstRoleList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RoleList,
                            null, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                        ViewBag.RoleList = lstRoleList; // new SelectList(lstRoleList, "Key", "Value");

                    }

                    ViewBag.user_id = uid;

                    ViewBag.user_action = acid;

                    return View("Create", objRoleActivityModel);
                }
            }
            finally
            {
                objLoginUserDetails = null;
                tblRoleActivity = null;
                objComCodeDTO = null;
                objRoleMasterDTO = null;
                objPopulateComboDTO = null;
                lstRoleList = null;
            }
        }

        #region Cancel Button Action

        [ActionName("Cancel")]
        public ActionResult Cancel(int RoleId = 0, string CalledFrom = "", int uid = 0)
        {
            //check "CalledFrom" value and redirect back to show role details again
            if (CalledFrom == "emp" || CalledFrom == "nonemp" || CalledFrom == "corp" || CalledFrom == "cousr")
            {
                return RedirectToAction("Create", "RoleMaster", new{ RoleId = RoleId, acid = Common.ConstEnum.UserActions.CRUSER_ROLEMASTER_EDIT, frm = CalledFrom, uid = uid });
            }

            return RedirectToAction("Index", "RoleMaster", new{acid = Common.ConstEnum.UserActions.CRUSER_ROLEMASTER_VIEW});

        }
        #endregion Cancel Button Action

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
    }
}
