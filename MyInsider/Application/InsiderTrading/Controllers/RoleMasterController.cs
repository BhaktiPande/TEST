using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading;
using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using System.Web.Routing;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class RoleMasterController : Controller
    {
        //
        // GET: /RoleMaster/
        //[HttpPost]
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            RoleMasterSearchViewModel objRoleMasterModel = new RoleMasterSearchViewModel();
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            try
            {

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.RoleStatus).ToString(), null, null, null, null, true);
                ViewBag.RoleStatus = lstList;
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserType).ToString(), null, null, null, null, true);
                ViewBag.UserType = lstList;
                FillGrid(ConstEnum.GridType.RoleMasterList, null, null, null);
                return View("View1", objRoleMasterModel);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("View1", objRoleMasterModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objRoleMasterModel = null;
                lstList = null;
            }
        }

        //
        // GET: /RoleMaster/Create
        [HttpGet]
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int RoleId, int acid, string frm = "", int uid = 0)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstRoleStatusList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstUserTypeList = new List<PopulateComboDTO>();
            try
            {
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";
                lstRoleStatusList.Add(objPopulateComboDTO);
                lstRoleStatusList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.RoleStatus).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());

                lstUserTypeList.Add(objPopulateComboDTO);
                lstUserTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.UserType).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());

                ViewBag.RoleStatus = lstRoleStatusList; // new SelectList(lstRoleStatusList, "Key", "Value");
                ViewBag.UserType = lstUserTypeList;

                //set varible to check if user come on role page from role menu option or from employee/insider create/edit page
                string link_from = "";
                int user_id = 0;
                ViewBag.vwbUserTypeCodeId = 0;
                if (frm != "")
                {
                    link_from = frm;
                    user_id = uid;
                    switch (frm)
                    {
                        case "emp": //link from employee page
                            ViewBag.vwbUserTypeCodeId = ConstEnum.Code.EmployeeType;
                            ViewBag.UserTypeCodeId = ConstEnum.Code.EmployeeType;
                            break;
                        case "nonemp": //link from non employee page
                            ViewBag.vwbUserTypeCodeId = ConstEnum.Code.NonEmployeeType;
                            ViewBag.UserTypeCodeId = ConstEnum.Code.NonEmployeeType;
                            break;
                        case "corp": //link from corporate employee page
                            ViewBag.vwbUserTypeCodeId = ConstEnum.Code.CorporateUserType;
                            ViewBag.UserTypeCodeId = ConstEnum.Code.CorporateUserType;
                            break;
                        case "cousr": //link from CO user page
                            ViewBag.vwbUserTypeCodeId = ConstEnum.Code.COUserType;
                            ViewBag.UserTypeCodeId = ConstEnum.Code.COUserType;
                            break;
                        default:
                            //default return to role master list page                        
                            break;
                    }
                }
                ViewBag.link_from = link_from;
                ViewBag.user_id = user_id;

                ViewBag.user_action = acid;

                if (RoleId > 0)
                {
                    RoleMasterSL objRoleMasterSL = new RoleMasterSL();
                    RoleMasterModel objRoleMasterModel = new RoleMasterModel();
                    InsiderTradingDAL.RoleMasterDTO objRoleMasterDTO = objRoleMasterSL.GetRoleMasterDetails(objLoginUserDetails.CompanyDBConnectionString, RoleId);
                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objRoleMasterDTO, objRoleMasterModel);
                    ViewBag.IsDefault = objRoleMasterModel.IsDefault;
                    ViewBag.IsActivityAssigned = objRoleMasterDTO.IsActivityAssigned;
                    if (frm != "")
                    {
                        return PartialView("Create", objRoleMasterModel);
                    }
                    else
                    {
                        return View("Create", objRoleMasterModel);
                    }
                }
                else
                {
                    ViewBag.IsActivityAssigned = 0;
                    ViewBag.IsDefault = false;
                    if (frm != "")
                    {
                        return PartialView("Create");
                    }
                    else
                    {
                        return View("Create");
                    }

                }
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("View1");
            }
            finally
            {
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
                lstRoleStatusList = null;
                lstUserTypeList = null;
            }
        }

        #region Cancel Button Action
        public ActionResult Cancel(string frm = "", int uid = 0)
        {
            //check from where create role page is called and redirect back to same page
            if (frm != "")
            {
                string view_name = "";
                string contorller_name = "";
                RouteValueDictionary controller_paramter = new RouteValueDictionary();

                switch (frm)
                {
                    case "emp": //link from employee page
                        if (uid == 0)
                        {
                            //employee create page
                            view_name = "Create";
                            contorller_name = "Employee";
                            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_CREATE);
                        }
                        else
                        {
                            //employee edit page
                            view_name = "Create";
                            contorller_name = "Employee";
                            controller_paramter.Add("nUserInfoID", uid);
                            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT);
                        }
                        break;
                    case "nonemp": //link from non employee page
                        if (uid == 0)
                        {
                            //non employee create page
                            view_name = "Create";
                            contorller_name = "NonEmployeeInsider";
                            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_CREATE);
                        }
                        else
                        {
                            //non employee edit page
                            view_name = "Create";
                            contorller_name = "NonEmployeeInsider";
                            controller_paramter.Add("nUserInfoID", uid);
                            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT);
                        }
                        break;
                    case "corp": //link from corporate employee page
                        if (uid == 0)
                        {
                            //corporate employee create page
                            view_name = "index";
                            contorller_name = "CorporateUser";
                            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_CREATE);
                        }
                        else
                        {
                            //corporate employee edit page
                            view_name = "Edit";
                            contorller_name = "CorporateUser";
                            controller_paramter.Add("nUserInfoID", uid);
                            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.INSIDER_INSIDERUSER_EDIT);
                        }
                        break;
                    case "cousr": //link from CO user page
                        if (uid == 0)
                        {
                            //CO user create page
                            view_name = "Create";
                            contorller_name = "UserDetails";
                            //controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.CRUSER_COUSER_CREATE);
                        }
                        else
                        {
                            //CO user edit page
                            view_name = "Edit";
                            contorller_name = "UserDetails";
                            controller_paramter.Add("acid", InsiderTrading.Common.ConstEnum.UserActions.CRUSER_COUSER_EDIT);
                            controller_paramter.Add("CalledFrom", "Edit");
                            controller_paramter.Add("UserInfoID", uid);

                        }
                        break;
                    default:
                        //default return to role master list page
                        view_name = "Index";
                        contorller_name = "RoleMaster";
                        controller_paramter.Add("acid", Common.ConstEnum.UserActions.CRUSER_ROLEMASTER_VIEW);
                        break;
                }

                return RedirectToAction(view_name, contorller_name, controller_paramter);
            }

            return RedirectToAction("Index", "RoleMaster", new { acid = Common.ConstEnum.UserActions.CRUSER_ROLEMASTER_VIEW });

        }
        #endregion Cancel Button Action

        [HttpPost]
        [Button(ButtonName = "Save")]
        [ActionName("create")]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        [ValidateAntiForgeryToken]
        public ActionResult Create(RoleMasterModel objRoleMasterModel, int acid = 0, string frm = "", int uid = 0)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            RoleMasterSL objRoleMasterSL = new RoleMasterSL();
            InsiderTradingDAL.RoleMasterDTO objRoleMasterDTO = new InsiderTradingDAL.RoleMasterDTO();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            List<PopulateComboDTO> lstRoleStatusList = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstUserTypeList = new List<PopulateComboDTO>();
            try
            {
                if (Request.Params["authorization"] != null && Request.Params["authorization"] != "")
                {
                    acid = Convert.ToInt32(Request.Params["authorization"].Split(':')[1]);
                }
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objRoleMasterModel, objRoleMasterDTO);
                objRoleMasterDTO = objRoleMasterSL.InsertUpdateRoleMasterDetails(objLoginUserDetails.CompanyDBConnectionString, objRoleMasterDTO, objLoginUserDetails.LoggedInUserID);

                //check from where create role page is called and redirect back to same page
                if (frm != "")
                {
                    return Json(new
                    {
                        status = true,
                        url = Url.Action("Index", "RoleActivity", new { RoleId = objRoleMasterDTO.RoleId, CalledFrom = frm, acid = Common.ConstEnum.UserActions.CRUSER_ROLEMASTER_EDIT, uid = uid }),
                        RoleId = objRoleMasterDTO.RoleId,
                        CalledFrom = frm,
                        RoleName = objRoleMasterDTO.RoleName,
                        IsActive = (objRoleMasterDTO.StatusCodeId == ConstEnum.Code.RoleStatusActive ? true : false),
                        uid = uid
                    });
                    //return PartialView("RedirectToRoleActivity");
                    //return RedirectToAction("Index", "RoleActivity", new { RoleId = objRoleMasterDTO.RoleId, CalledFrom = frm, acid = ConstEnum.UserActions.CRUSER_ROLEMASTER_CREATE, uid = uid }).Success(Common.Common.getResource("usr_msg_12053"));
                }
                return RedirectToAction("Index", "RoleMaster", new { acid = Common.ConstEnum.UserActions.CRUSER_ROLEMASTER_VIEW }).Success(Common.Common.getResource("usr_msg_12053"));

            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                if (frm != "")
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
                    var RoleId = objRoleMasterModel.RoleId;
                    ViewBag.IsActivityAssigned = 0;
                    objPopulateComboDTO.Key = "0";
                    objPopulateComboDTO.Value = "Select";

                    lstRoleStatusList.Add(objPopulateComboDTO);
                    lstRoleStatusList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                        Convert.ToInt32(ConstEnum.CodeGroup.RoleStatus).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());

                    lstUserTypeList.Add(objPopulateComboDTO);
                    lstUserTypeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                        Convert.ToInt32(ConstEnum.CodeGroup.UserType).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());

                    //ViewBag.RoleStatus = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.RoleStatus).ToString(), null, null, null, null, true);
                    //ViewBag.UserType = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserType).ToString(), null, null, null, null, true);
                    ViewBag.RoleStatus = lstRoleStatusList; // new SelectList(lstRoleStatusList, "Key", "Value");
                    ViewBag.UserType = lstUserTypeList;
                    if (RoleId > 0)
                    {
                        objRoleMasterDTO = objRoleMasterSL.GetRoleMasterDetails(objLoginUserDetails.CompanyDBConnectionString, RoleId);
                        ViewBag.IsActivityAssigned = objRoleMasterDTO.IsActivityAssigned;
                    }
                    ViewBag.IsDefault = objRoleMasterModel.IsDefault;

                    //set varible to check if user come on role page from role menu option or from employee/insider create/edit page
                    string link_from = "";
                    int user_id = 0;
                    ViewBag.vwbUserTypeCodeId = 0;
                    if (frm != "")
                    {
                        link_from = frm;
                        user_id = uid;
                        switch (frm)
                        {
                            case "emp": //link from employee page
                                ViewBag.vwbUserTypeCodeId = ConstEnum.Code.EmployeeType;
                                ViewBag.UserTypeCodeId = ConstEnum.Code.EmployeeType;
                                break;
                            case "nonemp": //link from non employee page
                                ViewBag.vwbUserTypeCodeId = ConstEnum.Code.NonEmployeeType;
                                ViewBag.UserTypeCodeId = ConstEnum.Code.NonEmployeeType;
                                break;
                            case "corp": //link from corporate employee page
                                ViewBag.vwbUserTypeCodeId = ConstEnum.Code.CorporateUserType;
                                ViewBag.UserTypeCodeId = ConstEnum.Code.CorporateUserType;
                                break;
                            case "cousr": //link from CO user page
                                ViewBag.vwbUserTypeCodeId = ConstEnum.Code.COUserType;
                                ViewBag.UserTypeCodeId = ConstEnum.Code.COUserType;
                                break;
                            default:
                                //default return to role master list page                        
                                break;
                        }
                    }
                    ViewBag.link_from = link_from;
                    ViewBag.user_id = user_id;

                    ViewBag.user_action = acid;

                    return View("Create", objRoleMasterModel);
                }
            }
            finally
            {
                objLoginUserDetails = null;
                objRoleMasterSL = null;
                objRoleMasterDTO = null;
                objPopulateComboDTO = null;
                lstRoleStatusList = null;
                lstUserTypeList = null;
            }
        }

        //
        // GET: /RoleMaster/Edit/5
        [AuthorizationPrivilegeFilter]
        public ActionResult Edit(int RoleId, int acid)
        {
            return RedirectToAction("Index", "RoleActivity", new { RoleId = RoleId, CalledFrom = "RoleMaster", acid = acid });
        }

        //
        // GET: /RoleMaster/Delete/5
        [HttpPost]
        //Mantis Issue no 9343
        //[ValidateAntiForgeryToken]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult Delete(int RoleId, int acid)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            RoleMasterSL objRoleMasterSL = new RoleMasterSL();
            RoleMasterModel objRoleMasterModel = new RoleMasterModel();
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            try
            {
              
                bool result = objRoleMasterSL.DeleteRoleMasterDetails(objLoginUserDetails.CompanyDBConnectionString, RoleId, objLoginUserDetails.LoggedInUserID);
                //return RedirectToAction("Index", "RoleMaster", new { acid = InsiderTrading.Common.ConstEnum.UserActions.CRUSER_ROLEMASTER_VIEW }).Success("Role deleted successfully.");//Common.Common.getResource("tra_msg_12054"));
                statusFlag = true;
                ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_12054"));
            }
            catch (Exception exp)
            {

               
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.RoleStatus).ToString(), null, null, null, null, true);

                ViewBag.RoleStatus = lstList;
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserType).ToString(), null, null, null, null, true);
                ViewBag.UserType = lstList;
                FillGrid(ConstEnum.GridType.RoleMasterList, null, null, null);

                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                ErrorDictionary = GetModelStateErrorsAsString();
            }
            finally
            {
                objLoginUserDetails = null;
                objRoleMasterSL = null;
                objRoleMasterModel = null;
                lstList = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }

        #region Private Method

        #region FillComboValues
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_nComboType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        /// <param name="i_sParam4"></param>
        /// <param name="i_sParam5"></param>
        /// <returns></returns>
        private List<PopulateComboDTO> FillComboValues(int i_nComboType, string i_sParam1, string i_sParam2, string i_sParam3, string i_sParam4, string i_sParam5, bool i_bIsDefaultValue)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";
                List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
                if (i_bIsDefaultValue)
                {
                    lstPopulateComboDTO.Add(objPopulateComboDTO);
                }
                lstPopulateComboDTO.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, i_nComboType,
                    i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, "usr_msg_").ToList<PopulateComboDTO>());
                return lstPopulateComboDTO;
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion FillComboValues

        #region FillGrid
        /// <summary>
        /// 
        /// </summary>
        /// <param name="m_nGridType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        private void FillGrid(int m_nGridType, string i_sParam1, string i_sParam2, string i_sParam3)
        {
            ViewBag.GridType = m_nGridType;
            ViewBag.Param1 = i_sParam1;
            ViewBag.Param2 = i_sParam2;
            ViewBag.Param3 = i_sParam3;
        }
        #endregion FillGrid

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }
        #endregion Private Method

        #region Dispose
        /// <summary>
        /// Dispose Method
        /// </summary>
        /// <param name="disposing"></param>
        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
        #endregion Dispose
    }
}
