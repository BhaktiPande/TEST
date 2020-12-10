using System;
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
using Newtonsoft.Json;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class CommunicationRuleMasterController : Controller
    {
        bool isAllEdit = true;
        //
        // GET: /TemplateMaster/
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            TemplateMasterModel objTemplateMasterModel = new TemplateMasterModel();
            try
            {
                List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationRuleCategory).ToString(), null, null, null, null, true);
                ViewBag.RuleCategoryCodeId = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationRuleStatus).ToString(), null, null, null, null, true);
                ViewBag.RuleStatusCodeId = lstList;
                ViewBag.acid = acid;

                ViewBag.UserId = objLoginUserDetails.LoggedInUserID;
                FillGrid(ConstEnum.GridType.CommunicationRuleMasterList, null, null, null, Convert.ToString(objLoginUserDetails.LoggedInUserID), null);
                lstList = null;
                return View("View");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("View", objTemplateMasterModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objTemplateMasterModel = null;
            }
        }

        //
        // GET: /TemplateMaster/Create
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int acid, int RuleId)
        {
            bool allowChangeStatus = false;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            CommunicationRuleMasterModel objCommunicationRuleMasterModel = new CommunicationRuleMasterModel();
            try
            {
                List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
                //  CommunicationRuleMasterSL objCommunicationRuleMasterSL = new CommunicationRuleMasterSL();
                CommunicationRuleMasterDTO objCommunicationRuleMasterDTO = new CommunicationRuleMasterDTO();
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationRuleCategory).ToString(), null, null, null, null, true);
                ViewBag.RuleCategoryCodeList = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.Events).ToString(), null, null, null, null, false);
                ViewBag.TriggerEventCodeList = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListofEventsWithUserTypeForCommunicatioTriggerEvent, null, null, null, null, null, false);
                ViewBag.TriggerEventCodeWithUserTypeList = lstList;

                objCommunicationRuleMasterModel.AssignedTriggerEventCodeId = new List<PopulateComboDTO>();
                objCommunicationRuleMasterModel.AssignedOffsetEventCodeId = new List<PopulateComboDTO>();
                objCommunicationRuleMasterModel.InsiderPersonalize = YesNo.No;
                objCommunicationRuleMasterModel.RuleForCodeId_bool = YesNo.Yes;
                objCommunicationRuleMasterModel.EventsApplyToCodeId_bool = YesNo.Yes;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.Events).ToString(), null, null, null, null, false);
                ViewBag.OffsetEventCodeList = lstList;

                //lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationRuleStatus).ToString(), null, null, null, null, false);            
                //ViewBag.RuleStatusCodeId = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationModes).ToString(), Convert.ToInt32(ConstEnum.Code.CommunicationCategory).ToString(), null, null, null, true);
                ViewBag.CommunicationModes = lstList; //JsonConvert.SerializeObject(lstList);//Json(new(key=lstList[key], JsonRequestBehavior.AllowGet);

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationExecutionFrequency).ToString(), null, null, null, null, true);
                ViewBag.CommunicationExecutionFrequency = lstList;//JsonConvert.SerializeObject(lstList);//Json(new(key=lstList[key], JsonRequestBehavior.AllowGet);

                lstList = FillComboValues(ConstEnum.ComboType.TemplateList, null, null, null, null, null, true);
                ViewBag.TemplateList = lstList;//JsonConvert.SerializeObject(lstList);//Json(new(key=lstList[key], JsonRequestBehavior.AllowGet);
                lstList = null;
                FillGrid(ConstEnum.GridType.CommunicationRuleModesMasterList, Convert.ToString(objLoginUserDetails.LoggedInUserID), Convert.ToString(RuleId), null, null, null);
                ViewBag.showApplicabilityButton = false;
                ViewBag.RuleId = RuleId;
                ViewBag.UserId = objLoginUserDetails.LoggedInUserID;
                ViewBag.acid = acid;
                //objCommunicationRuleMasterModel.RuleForCodeId_Insider = false;
                //objCommunicationRuleMasterModel.RuleForCodeId_Co = false;
                if (RuleId > 0)
                {
                    using (var objCommunicationRuleMasterSL = new CommunicationRuleMasterSL())
                    {
                        objCommunicationRuleMasterDTO = objCommunicationRuleMasterSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, RuleId);
                    }

                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objCommunicationRuleMasterDTO, objCommunicationRuleMasterModel);
                    if (objCommunicationRuleMasterDTO.TriggerEventCodeId != null && objCommunicationRuleMasterDTO.TriggerEventCodeId != "")
                    {
                        List<int> TagIds1 = objCommunicationRuleMasterDTO.TriggerEventCodeId.Split(',').Select(int.Parse).ToList();

                        foreach (var a in TagIds1)
                        {
                            PopulateComboDTO obj = new PopulateComboDTO();
                            obj.Key = a.ToString();
                            obj.Value = "";
                            obj.OptionAttribute = objCommunicationRuleMasterModel.EventsApplyToCodeId.ToString();
                            objCommunicationRuleMasterModel.AssignedTriggerEventCodeId.Add(obj);
                        }
                    }
                    if (objCommunicationRuleMasterDTO.OffsetEventCodeId != null && objCommunicationRuleMasterDTO.OffsetEventCodeId != "")
                    {
                        List<int> TagIds1 = objCommunicationRuleMasterDTO.OffsetEventCodeId.Split(',').Select(int.Parse).ToList();

                        foreach (var a in TagIds1)
                        {
                            PopulateComboDTO obj = new PopulateComboDTO();
                            obj.Key = a.ToString();
                            obj.Value = "";
                            objCommunicationRuleMasterModel.AssignedOffsetEventCodeId.Add(obj);
                        }
                    }
                    if (objCommunicationRuleMasterDTO.RuleForCodeId != null && objCommunicationRuleMasterDTO.RuleForCodeId != "")
                    {
                        //List<int> TagIds1 = objCommunicationRuleMasterDTO.RuleForCodeId.Split(',').Select(int.Parse).ToList();

                        //foreach (var a in TagIds1)
                        //{
                        //    if (a == ConstEnum.Code.CommunicationRuleForUserTypeInsider)
                        //    {
                        //        objCommunicationRuleMasterModel.RuleForCodeId_Insider = true;
                        //    }
                        //    if (a == ConstEnum.Code.CommunicationRuleForUserTypeCO)
                        //    {
                        //        objCommunicationRuleMasterModel.RuleForCodeId_Co = true;
                        //    }

                        //}
                        objCommunicationRuleMasterModel.RuleForCodeId_bool = (objCommunicationRuleMasterDTO.RuleForCodeId == Convert.ToString(ConstEnum.Code.CommunicationRuleForUserTypeCO) ? YesNo.Yes : YesNo.No);
                    }

                    objCommunicationRuleMasterModel.EventsApplyToCodeId_bool = (objCommunicationRuleMasterModel.EventsApplyToCodeId == ConstEnum.Code.CommunicationRuleEventsToApplyUserTypeCO) ? YesNo.Yes : YesNo.No;


                    objCommunicationRuleMasterModel.InsiderPersonalize = (objCommunicationRuleMasterModel.InsiderPersonalizeFlag) ? YesNo.Yes : YesNo.No;

                    if ((objCommunicationRuleMasterModel.IsApplicabilityDefined != null && objCommunicationRuleMasterModel.IsApplicabilityDefined == true) || objCommunicationRuleMasterModel.RuleStatusCodeId == Convert.ToInt32(InsiderTrading.Models.CommunicationRuleMasterModel.RuleStatusCode.Active))
                    {
                        allowChangeStatus = true;
                    }
                    if (InsiderTrading.Common.Common.CanPerform(InsiderTrading.Common.ConstEnum.UserActions.COMMUNICATION_RULES_ADD_RIGHT) || InsiderTrading.Common.Common.CanPerform(InsiderTrading.Common.ConstEnum.UserActions.COMMUNICATION_RULES_EDIT_RIGHT))
                    {
                        ViewBag.showApplicabilityButton = true;
                    }
                }
                //check Rule status and by default set Rule status to inactive
                if (objCommunicationRuleMasterModel.RuleStatusCodeId != null)
                {
                    switch (objCommunicationRuleMasterModel.RuleStatusCodeId)
                    {
                        case ConstEnum.Code.CommunicationRuleStatusInactive:
                            objCommunicationRuleMasterModel.RuleStatus = InsiderTrading.Models.CommunicationRuleMasterModel.RuleStatusCode.Inactive;
                            break;
                        case ConstEnum.Code.CommunicationRuleStatusActive:
                            objCommunicationRuleMasterModel.RuleStatus = InsiderTrading.Models.CommunicationRuleMasterModel.RuleStatusCode.Active;
                            break;
                        default:
                            objCommunicationRuleMasterModel.RuleStatus = InsiderTrading.Models.CommunicationRuleMasterModel.RuleStatusCode.Inactive;
                            break;
                    }
                }
                else
                {
                    objCommunicationRuleMasterModel.RuleStatus = InsiderTrading.Models.CommunicationRuleMasterModel.RuleStatusCode.Inactive;
                }
                if (InsiderTrading.Common.Common.CanPerform(InsiderTrading.Common.ConstEnum.UserActions.COMMUNICATION_RULES_ADD_RIGHT) || InsiderTrading.Common.Common.CanPerform(InsiderTrading.Common.ConstEnum.UserActions.COMMUNICATION_RULES_EDIT_RIGHT))
                {
                    isAllEdit = true;
                }
                else
                {
                    isAllEdit = false;
                }

                ViewBag.CommunicationMode_id = (objCommunicationRuleMasterModel.RuleCategoryCodeId == null ? 0 : objCommunicationRuleMasterModel.RuleCategoryCodeId);
                ViewBag.allowChangeStatus = allowChangeStatus;
                ViewBag.isAllEdit = isAllEdit;

                objCommunicationRuleMasterDTO = null;
                lstList = null;
                //ViewBag.CommunicationMode_id = objCommunicationRuleMasterModel.CommunicationModeCodeId;
                return View("Create", objCommunicationRuleMasterModel);
            }
            catch (Exception exp)
            {
                return RedirectToAction("Index", "CommunicationRuleMaster", new { acid = ConstEnum.UserActions.COMMUNICATION_RULES_LIST_RIGHT });
            }
            finally
            {
                objLoginUserDetails = null;
                objCommunicationRuleMasterModel = null;
            }
        }

        #region PartialCreateView
        /// <summary>
        /// This method is used to fetch sub category drop down view (partial)
        /// </summary>
        /// <param name="category_id"></param>
        /// <returns></returns>
        public ActionResult PartialCreateView(int CommunicationMode_id)
        {
            Common.Common objCommon = new Common.Common();
            if (!objCommon.ValidateCSRFForAJAX())
            {
                return RedirectToAction("Unauthorised", "Home");
            }
            CommunicationRuleMasterModel objCommunicationRuleMasterModel = new CommunicationRuleMasterModel();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            ViewBag.isAllEdit = isAllEdit;
            lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.Events).ToString(), null, null, null, null, false);
            ViewBag.TriggerEventCodeList = lstList;
            lstList = FillComboValues(ConstEnum.ComboType.ListofEventsWithUserTypeForCommunicatioTriggerEvent, null, null, null, null, null, false);
            ViewBag.TriggerEventCodeWithUserTypeList = lstList;
            lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.Events).ToString(), null, null, null, null, false);
            ViewBag.OffsetEventCodeList = lstList;
            objCommunicationRuleMasterModel.AssignedTriggerEventCodeId = new List<PopulateComboDTO>();
            objCommunicationRuleMasterModel.AssignedOffsetEventCodeId = new List<PopulateComboDTO>();
            ViewBag.CommunicationMode_id = CommunicationMode_id;
            return PartialView("PartialCreate1", objCommunicationRuleMasterModel);
        }
        public ActionResult PartialCreateView2(int CommunicationMode_id)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            Common.Common objCommon = new Common.Common();
            if (!objCommon.ValidateCSRFForAJAX())
            {
                return RedirectToAction("Unauthorised", "Home");
            }
            ViewBag.isAllEdit = isAllEdit;
            ViewBag.CommunicationMode_id = CommunicationMode_id;
            return PartialView("PartialCreate2");
        }
        #endregion PartialCreateView
        //
        // POST: /CommunicationRuleMaster/Create
        //[HttpPost]
        //[Button(ButtonName = "Save")]
        //[ActionName("create")]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public JsonResult SaveCommunicationRule(int acid, CommunicationRuleMasterModel objCommunicationRuleMasterModel)
        {
            bool bReturn = true;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    Json(new { status = false, error = ModelState.ToSerializedDictionary() });
                }
                // TODO: Add insert logic here
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                // CommunicationRuleMasterSL objCommunicationRuleMasterSL = new CommunicationRuleMasterSL();
                CommunicationRuleMasterDTO objCommunicationRuleMasterDTO = new CommunicationRuleMasterDTO();
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objCommunicationRuleMasterModel, objCommunicationRuleMasterDTO);
                if (objCommunicationRuleMasterModel.SelectTriggerEventCodeId != null && objCommunicationRuleMasterModel.SelectTriggerEventCodeId.Count() > 0)
                {
                    var sSubmittedSecurityTypeList = String.Join(",", objCommunicationRuleMasterModel.SelectTriggerEventCodeId);
                    objCommunicationRuleMasterDTO.TriggerEventCodeId = sSubmittedSecurityTypeList;
                }
                if (objCommunicationRuleMasterModel.SelectOffsetEventCodeId != null && objCommunicationRuleMasterModel.SelectOffsetEventCodeId.Count() > 0)
                {
                    var sSubmittedSecurityTypeList = String.Join(",", objCommunicationRuleMasterModel.SelectOffsetEventCodeId);
                    objCommunicationRuleMasterDTO.OffsetEventCodeId = sSubmittedSecurityTypeList;
                }
                if (objCommunicationRuleMasterModel.RuleCategoryCodeId == ConstEnum.Code.CommunicationRuleCategoryAuto && ((objCommunicationRuleMasterDTO.TriggerEventCodeId == null || objCommunicationRuleMasterDTO.TriggerEventCodeId == "") && (objCommunicationRuleMasterDTO.OffsetEventCodeId == null || objCommunicationRuleMasterDTO.OffsetEventCodeId == "")))
                {
                    ModelState.AddModelError("TriggerEventCodeId", InsiderTrading.Common.Common.getResource("cmu_msg_18062"));
                    bReturn = false;
                }
                objCommunicationRuleMasterDTO.RuleForCodeId = "";
                if (objCommunicationRuleMasterModel.RuleForCodeId_bool != null)
                {
                    objCommunicationRuleMasterDTO.RuleForCodeId = (objCommunicationRuleMasterModel.RuleForCodeId_bool == YesNo.Yes) ? Convert.ToString(ConstEnum.Code.CommunicationRuleForUserTypeCO) : Convert.ToString(ConstEnum.Code.CommunicationRuleForUserTypeInsider);
                }
                if (objCommunicationRuleMasterModel.EventsApplyToCodeId_bool != null)
                {
                    objCommunicationRuleMasterDTO.EventsApplyToCodeId = (objCommunicationRuleMasterModel.EventsApplyToCodeId_bool == YesNo.Yes) ? ConstEnum.Code.CommunicationRuleEventsToApplyUserTypeCO : ConstEnum.Code.CommunicationRuleEventsToApplyUserTypeInsider;
                }
                if (objCommunicationRuleMasterModel.InsiderPersonalize != null)
                {
                    objCommunicationRuleMasterDTO.InsiderPersonalizeFlag = (objCommunicationRuleMasterModel.InsiderPersonalize == YesNo.Yes) ? true : false;
                }
                #region
                DataTable tblCommunicationRuleModeMasterType = new DataTable("CommunicationRuleModeMasterType");
                tblCommunicationRuleModeMasterType.Columns.Add(new DataColumn("RuleModeId", typeof(int)));
                tblCommunicationRuleModeMasterType.Columns.Add(new DataColumn("RuleId", typeof(int)));
                tblCommunicationRuleModeMasterType.Columns.Add(new DataColumn("ModeCodeId", typeof(int)));
                tblCommunicationRuleModeMasterType.Columns.Add(new DataColumn("TemplateId", typeof(int)));
                tblCommunicationRuleModeMasterType.Columns.Add(new DataColumn("WaitDaysAfterTriggerEvent", typeof(int)));
                tblCommunicationRuleModeMasterType.Columns.Add(new DataColumn("ExecFrequencyCodeId", typeof(int)));
                tblCommunicationRuleModeMasterType.Columns.Add(new DataColumn("NotificationLimit", typeof(int)));
                tblCommunicationRuleModeMasterType.Columns.Add(new DataColumn("UserId", typeof(int)));

                foreach (CommunicationRuleModeMasterModel CommunicationRuleModeMasterMode in objCommunicationRuleMasterModel.CommunicationRuleModeMasterModelList)
                {
                    DataRow row = tblCommunicationRuleModeMasterType.NewRow();
                    if (CommunicationRuleModeMasterMode.RuleModeId != null)
                    {
                        row["RuleModeId"] = CommunicationRuleModeMasterMode.RuleModeId;
                    }
                    else
                    {
                        row["RuleModeId"] = 0;
                    }

                    row["RuleId"] = objCommunicationRuleMasterModel.RuleId;

                    if (CommunicationRuleModeMasterMode.UserId != null)
                    {
                        row["UserId"] = CommunicationRuleModeMasterMode.UserId;
                    }
                    if (CommunicationRuleModeMasterMode.ModeCodeId != null && CommunicationRuleModeMasterMode.ModeCodeId != 0)
                    {
                        row["ModeCodeId"] = CommunicationRuleModeMasterMode.ModeCodeId;
                    }
                    else
                    {
                        ModelState.AddModelError("ModeCodeId", InsiderTrading.Common.Common.getResource("cmu_msg_18051"));
                        bReturn = false;
                    }
                    if (CommunicationRuleModeMasterMode.TemplateId != null && CommunicationRuleModeMasterMode.TemplateId != 0)
                    {
                        row["TemplateId"] = CommunicationRuleModeMasterMode.TemplateId;
                    }
                    else
                    {
                        ModelState.AddModelError("TemplateId", InsiderTrading.Common.Common.getResource("cmu_msg_18052"));
                        bReturn = false;
                    }
                    if (CommunicationRuleModeMasterMode.WaitDaysAfterTriggerEvent != null)
                    {
                        row["WaitDaysAfterTriggerEvent"] = CommunicationRuleModeMasterMode.WaitDaysAfterTriggerEvent;
                    }
                    else
                    {
                        ModelState.AddModelError("WaitDaysAfterTriggerEvent", InsiderTrading.Common.Common.getResource("cmu_msg_18053"));
                        bReturn = false;
                    }
                    if (CommunicationRuleModeMasterMode.ExecFrequencyCodeId != null && CommunicationRuleModeMasterMode.ExecFrequencyCodeId != 0)
                    {
                        row["ExecFrequencyCodeId"] = CommunicationRuleModeMasterMode.ExecFrequencyCodeId;
                    }
                    else
                    {
                        ModelState.AddModelError("ExecFrequencyCodeId", InsiderTrading.Common.Common.getResource("cmu_msg_18054"));
                        bReturn = false;
                    }
                    if (CommunicationRuleModeMasterMode.NotificationLimit != null)
                    {
                        row["NotificationLimit"] = CommunicationRuleModeMasterMode.NotificationLimit;
                    }
                    else
                    {
                        ModelState.AddModelError("NotificationLimit", InsiderTrading.Common.Common.getResource("cmu_msg_18055"));
                        bReturn = false;
                    }
                    if (!bReturn)
                    {
                        break;
                    }
                    tblCommunicationRuleModeMasterType.Rows.Add(row);
                }
                //check policy document windows status and by default set windows status to incomplete
                if (objCommunicationRuleMasterModel.RuleStatus != null)
                {
                    switch (objCommunicationRuleMasterModel.RuleStatus)
                    {
                        case InsiderTrading.Models.CommunicationRuleMasterModel.RuleStatusCode.Inactive:
                            objCommunicationRuleMasterDTO.RuleStatusCodeId = ConstEnum.Code.CommunicationRuleStatusInactive;
                            break;
                        case InsiderTrading.Models.CommunicationRuleMasterModel.RuleStatusCode.Active:
                            objCommunicationRuleMasterDTO.RuleStatusCodeId = ConstEnum.Code.CommunicationRuleStatusActive;
                            break;
                        default:
                            objCommunicationRuleMasterDTO.RuleStatusCodeId = ConstEnum.Code.CommunicationRuleStatusInactive;
                            break;
                    }
                }
                else
                {
                    objCommunicationRuleMasterDTO.RuleStatusCodeId = ConstEnum.Code.CommunicationRuleStatusInactive;
                }
                #endregion
                if (!bReturn && !ModelState.IsValid)
                {
                    #region Show error
                    List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();

                    lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationRuleCategory).ToString(), null, null, null, null, true);
                    ViewBag.RuleCategoryCodeList = lstList;

                    lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.Events).ToString(), null, null, null, null, false);
                    ViewBag.TriggerEventCodeList = lstList;

                    lstList = FillComboValues(ConstEnum.ComboType.ListofEventsWithUserTypeForCommunicatioTriggerEvent, null, null, null, null, null, false);
                    ViewBag.TriggerEventCodeWithUserTypeList = lstList;

                    objCommunicationRuleMasterModel.AssignedTriggerEventCodeId = new List<PopulateComboDTO>();
                    objCommunicationRuleMasterModel.AssignedOffsetEventCodeId = new List<PopulateComboDTO>();

                    lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.Events).ToString(), null, null, null, null, false);
                    ViewBag.OffsetEventCodeList = lstList;

                    //lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationRuleStatus).ToString(), null, null, null, null, false);            
                    //ViewBag.RuleStatusCodeId = lstList;

                    lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationModes).ToString(), Convert.ToInt32(ConstEnum.Code.CommunicationCategory).ToString(), null, null, null, true);
                    ViewBag.CommunicationModes = lstList; //JsonConvert.SerializeObject(lstList);//Json(new(key=lstList[key], JsonRequestBehavior.AllowGet);

                    lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationExecutionFrequency).ToString(), null, null, null, null, true);
                    ViewBag.CommunicationExecutionFrequency = lstList;//JsonConvert.SerializeObject(lstList);//Json(new(key=lstList[key], JsonRequestBehavior.AllowGet);

                    lstList = FillComboValues(ConstEnum.ComboType.TemplateList, null, null, null, null, null, true);
                    ViewBag.TemplateList = lstList;//JsonConvert.SerializeObject(lstList);//Json(new(key=lstList[key], JsonRequestBehavior.AllowGet);

                    if (objCommunicationRuleMasterModel.TriggerEventCodeId != null && objCommunicationRuleMasterModel.TriggerEventCodeId != "")
                    {
                        List<int> TagIds1 = objCommunicationRuleMasterModel.TriggerEventCodeId.Split(',').Select(int.Parse).ToList();

                        foreach (var a in TagIds1)
                        {
                            PopulateComboDTO obj = new PopulateComboDTO();
                            obj.Key = a.ToString();
                            obj.Value = "";
                            objCommunicationRuleMasterModel.AssignedTriggerEventCodeId.Add(obj);
                        }
                    }
                    if (objCommunicationRuleMasterModel.OffsetEventCodeId != null && objCommunicationRuleMasterModel.OffsetEventCodeId != "")
                    {
                        List<int> TagIds1 = objCommunicationRuleMasterModel.OffsetEventCodeId.Split(',').Select(int.Parse).ToList();

                        foreach (var a in TagIds1)
                        {
                            PopulateComboDTO obj = new PopulateComboDTO();
                            obj.Key = a.ToString();
                            obj.Value = "";
                            objCommunicationRuleMasterModel.AssignedOffsetEventCodeId.Add(obj);
                        }
                    }


                    FillGrid(ConstEnum.GridType.CommunicationRuleModesMasterList, Convert.ToString(objLoginUserDetails.LoggedInUserID), Convert.ToString(objCommunicationRuleMasterModel.RuleId), null, null, null);
                    ViewBag.showApplicabilityButton = false;
                    ViewBag.allowChangeStatus = false;

                    ViewBag.isAllEdit = false;
                    ViewBag.RuleId = objCommunicationRuleMasterModel.RuleId;
                    ViewBag.UserId = objLoginUserDetails.LoggedInUserID;
                    ViewBag.CommunicationMode_id = (objCommunicationRuleMasterModel.RuleCategoryCodeId == null ? 0 : objCommunicationRuleMasterModel.RuleCategoryCodeId);
                    if ((objCommunicationRuleMasterModel.IsApplicabilityDefined != null && objCommunicationRuleMasterModel.IsApplicabilityDefined == true) || objCommunicationRuleMasterModel.RuleStatusCodeId == Convert.ToInt32(InsiderTrading.Models.CommunicationRuleMasterModel.RuleStatusCode.Active))
                    {
                        ViewBag.allowChangeStatus = true;
                    }
                    if (InsiderTrading.Common.Common.CanPerform(InsiderTrading.Common.ConstEnum.UserActions.COMMUNICATION_RULES_ADD_RIGHT) || InsiderTrading.Common.Common.CanPerform(InsiderTrading.Common.ConstEnum.UserActions.COMMUNICATION_RULES_EDIT_RIGHT))
                    {
                        ViewBag.isAllEdit = true;
                        if (objCommunicationRuleMasterModel.RuleId != 0)
                        {
                            ViewBag.showApplicabilityButton = true;
                        }
                    }
                    //return View("Create", objCommunicationRuleMasterModel);
                    return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
                    #endregion
                }
                using (var objCommunicationRuleMasterSL = new CommunicationRuleMasterSL())
                {
                    objCommunicationRuleMasterDTO = objCommunicationRuleMasterSL.SaveDetails(objCommunicationRuleMasterDTO, tblCommunicationRuleModeMasterType, objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                }

                string SuccessMessage = Common.Common.getResource("cmu_msg_18020");
                bool bIsApplicabilityDefined = ((objCommunicationRuleMasterModel.IsApplicabilityDefined != null && objCommunicationRuleMasterModel.IsApplicabilityDefined == true) ? true : false);
                if (bIsApplicabilityDefined && (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.COUserType))
                {
                    SuccessMessage = ((objCommunicationRuleMasterDTO.RuleStatusCodeId == Convert.ToInt32(InsiderTrading.Models.CommunicationRuleMasterModel.RuleStatusCode.Active) ? Common.Common.getResource("cmu_msg_18065") : Common.Common.getResource("cmu_msg_18066")));
                }
                return Json(new
                {
                    status = true,
                    msg = SuccessMessage,
                    IsApplicabilityDefined = bIsApplicabilityDefined,
                    RuleId = objCommunicationRuleMasterDTO.RuleId
                });
                //return RedirectToAction("Create", "CommunicationRuleMaster", new { acid = ConstEnum.UserActions.COMMUNICATION_RULES_EDIT_RIGHT, RuleId = objCommunicationRuleMasterDTO.RuleId}).Success(Common.Common.getResource("cmu_msg_18020"));
            }
            catch (Exception exp)
            {
                List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationRuleCategory).ToString(), null, null, null, null, true);
                ViewBag.RuleCategoryCodeList = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.Events).ToString(), null, null, null, null, false);
                ViewBag.TriggerEventCodeList = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListofEventsWithUserTypeForCommunicatioTriggerEvent, null, null, null, null, null, false);
                ViewBag.TriggerEventCodeWithUserTypeList = lstList;

                objCommunicationRuleMasterModel.AssignedTriggerEventCodeId = new List<PopulateComboDTO>();
                objCommunicationRuleMasterModel.AssignedOffsetEventCodeId = new List<PopulateComboDTO>();

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.Events).ToString(), null, null, null, null, false);
                ViewBag.OffsetEventCodeList = lstList;

                //lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationRuleStatus).ToString(), null, null, null, null, false);            
                //ViewBag.RuleStatusCodeId = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationModes).ToString(), Convert.ToInt32(ConstEnum.Code.CommunicationCategory).ToString(), null, null, null, true);
                ViewBag.CommunicationModes = lstList; //JsonConvert.SerializeObject(lstList);//Json(new(key=lstList[key], JsonRequestBehavior.AllowGet);

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationExecutionFrequency).ToString(), null, null, null, null, true);
                ViewBag.CommunicationExecutionFrequency = lstList;//JsonConvert.SerializeObject(lstList);//Json(new(key=lstList[key], JsonRequestBehavior.AllowGet);

                lstList = FillComboValues(ConstEnum.ComboType.TemplateList, null, null, null, null, null, true);
                ViewBag.TemplateList = lstList;//JsonConvert.SerializeObject(lstList);//Json(new(key=lstList[key], JsonRequestBehavior.AllowGet);
                lstList = null;
                if (objCommunicationRuleMasterModel.TriggerEventCodeId != null && objCommunicationRuleMasterModel.TriggerEventCodeId != "")
                {
                    List<int> TagIds1 = objCommunicationRuleMasterModel.TriggerEventCodeId.Split(',').Select(int.Parse).ToList();

                    foreach (var a in TagIds1)
                    {
                        PopulateComboDTO obj = new PopulateComboDTO();
                        obj.Key = a.ToString();
                        obj.Value = "";
                        objCommunicationRuleMasterModel.AssignedTriggerEventCodeId.Add(obj);
                    }
                }
                if (objCommunicationRuleMasterModel.OffsetEventCodeId != null && objCommunicationRuleMasterModel.OffsetEventCodeId != "")
                {
                    List<int> TagIds1 = objCommunicationRuleMasterModel.OffsetEventCodeId.Split(',').Select(int.Parse).ToList();

                    foreach (var a in TagIds1)
                    {
                        PopulateComboDTO obj = new PopulateComboDTO();
                        obj.Key = a.ToString();
                        obj.Value = "";
                        objCommunicationRuleMasterModel.AssignedOffsetEventCodeId.Add(obj);
                    }
                }

                FillGrid(ConstEnum.GridType.CommunicationRuleModesMasterList, Convert.ToString(objLoginUserDetails.LoggedInUserID), Convert.ToString(objCommunicationRuleMasterModel.RuleId), null, null, null);
                ViewBag.showApplicabilityButton = false;
                ViewBag.UserAction = 119;
                ViewBag.RuleId = objCommunicationRuleMasterModel.RuleId;
                ViewBag.UserId = objLoginUserDetails.LoggedInUserID;
                ViewBag.CommunicationMode_id = (objCommunicationRuleMasterModel.RuleCategoryCodeId == null ? 0 : objCommunicationRuleMasterModel.RuleCategoryCodeId);
                if ((objCommunicationRuleMasterModel.IsApplicabilityDefined != null && objCommunicationRuleMasterModel.IsApplicabilityDefined == true) || objCommunicationRuleMasterModel.RuleStatusCodeId == Convert.ToInt32(InsiderTrading.Models.CommunicationRuleMasterModel.RuleStatusCode.Active))
                {
                    ViewBag.allowChangeStatus = true;
                }
                if (InsiderTrading.Common.Common.CanPerform(InsiderTrading.Common.ConstEnum.UserActions.COMMUNICATION_RULES_ADD_RIGHT) || InsiderTrading.Common.Common.CanPerform(InsiderTrading.Common.ConstEnum.UserActions.COMMUNICATION_RULES_EDIT_RIGHT))
                {
                    ViewBag.isAllEdit = true;
                    if (objCommunicationRuleMasterModel.RuleId != 0)
                    {
                        ViewBag.showApplicabilityButton = true;
                    }
                }
                //return View("Create", objCommunicationRuleMasterModel);
                return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }



        #region Cancel Button Action
        [HttpPost]      
        [Button(ButtonName = "Cancel")]
        [ActionName("create")]
        public ActionResult Cancel()
        {
            return RedirectToAction("Index", "CommunicationRuleMaster", new { acid = ConstEnum.UserActions.COMMUNICATION_RULES_LIST_RIGHT });

        }
        #endregion Cancel Button Action

        #region fillTemplateDropdown
        [HttpPost]

        //[Button(ButtonName = "dropdown")]
        //[ActionName("dropdownIndex")]
        public JsonResult fillTemplateDropdown(int CommunicationModeCodeId)
        {
            //LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            Common.Common objCommon = new Common.Common();
            if (!objCommon.ValidateCSRFForAJAX())
            {
                return Json(new
                {
                    status = false,
                    Message = ""
                }, JsonRequestBehavior.AllowGet);
            }
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            if (CommunicationModeCodeId != 0)
            {
                lstList = FillComboValues(ConstEnum.ComboType.TemplateList, Convert.ToString(CommunicationModeCodeId), null, null, null, null, true);
                ViewBag.TemplateList = lstList;
            }
            return Json(new
            {
                status = true,
                FinancialPeriodTypeId = lstList,
                Message = ""

            }, JsonRequestBehavior.AllowGet);
            //return RedirectToAction("Index", "TradingWindowEvent", new { FinancialYearId = FinancialYearId, acid = acid });
        }
        #endregion fillTemplateDropdown
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

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            try
            {
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";
                List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
                if (i_bIsDefaultValue)
                {
                    lstPopulateComboDTO.Add(objPopulateComboDTO);
                }
                lstPopulateComboDTO.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, i_nComboType,
                    i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, "tra_msg_").ToList<PopulateComboDTO>());
                return lstPopulateComboDTO;
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                objPopulateComboDTO = null;
                objLoginUserDetails = null;
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
        private void FillGrid(int m_nGridType, string i_sParam1, string i_sParam2, string i_sParam3, string i_sParam4, string i_sParam5)
        {
            ViewBag.GridType = m_nGridType;
            ViewBag.Param1 = i_sParam1;
            ViewBag.Param2 = i_sParam2;
            ViewBag.Param3 = i_sParam3;
            ViewBag.Param4 = i_sParam4;
            ViewBag.Param5 = i_sParam5;
        }
        #endregion FillGrid

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }

        #endregion Private Method
        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
    }
}
