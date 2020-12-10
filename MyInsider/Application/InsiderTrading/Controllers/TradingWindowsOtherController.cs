using InsiderTrading.Common;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading.Models;
using InsiderTrading.Filters;
using InsiderTrading.SL;
using System.Globalization;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class TradingWindowsOtherController : Controller
    {
       // string sLookUpPrefix = "rul_msg_";

        #region Index
        // GET: /TradingWindowsOther/     
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            TradingWindowEventSearchViewModel objTradingWindowEventModel = new TradingWindowEventSearchViewModel();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            try
            {
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.TradingWindowEvent).ToString(), null, null, null, null, true);
                ViewBag.TradingWindowsOtherEvent = lstList;
                ViewBag.GridType = ConstEnum.GridType.TradingWindowsOtherList;
                return View("Index", objTradingWindowEventModel);
            }
            catch (Exception exp)
            {
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.TradingWindowEvent).ToString(), null, null, null, null, true);
                ViewBag.TradingWindowsOtherEvent = lstList;
                ViewBag.GridType = ConstEnum.GridType.TradingWindowsOtherList;
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index");
            }
            finally
            {
                objTradingWindowEventModel = null;
                objLoginUserDetails = null;
                lstList = null;
            }
        }
        #endregion Index

        #region Create
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int acid)
        {
            TradingWindowEventModel objTradingWindowEventModel = new TradingWindowEventModel();
            TradingWindowEventDTO objTradingWindowsEventDTO = new TradingWindowEventDTO();
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            try
            {
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.TradingWindowEvent).ToString(), null, null, null, null, true);
                ViewBag.TradingWindowsOtherEvent = lstList;
                var lstHrs = new List<PopulateComboDTO>();
                var lstmin = new List<PopulateComboDTO>();
            
                lstHrs.Add(new PopulateComboDTO() { Key = "", Value = "Hrs" });
                lstHrs.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_24HRS; i++)
                {
                    lstHrs.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                }
                ViewBag.Hrs = lstHrs;
                lstmin.Add(new PopulateComboDTO() { Key = "", Value = "Mins" });
                lstmin.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_MIN; i++)
                {
                    lstmin.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                }
                ViewBag.Mins = lstmin;

                objTradingWindowEventModel.TradingWindowId = "0";
                objTradingWindowEventModel.TradingWindowEventId = 0;
                ViewBag.lblWindowCloseDate = null;
                ViewBag.lblWindowClosesBeforeHours = -1;
                ViewBag.lblWindowClosesBeforeMinutes = -1;

                ViewBag.ISEditWindow = 1;
                ViewBag.ISEditWindowOpenPart = 1;
                ViewBag.TradingWindowOtherUserAction = InsiderTrading.Common.ConstEnum.UserActions.TRADING_WINDOW_OTHER_CREATE;
                return View("Create", objTradingWindowEventModel);
            }
            catch (Exception exp)
            {
                ViewBag.TradingWindowsOtherEvent = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.TradingWindowEvent).ToString(), null, null, null, null, true); ;
                ViewBag.GridType = ConstEnum.GridType.TradingWindowsOtherList;
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index");
            }
            finally
            {
                objTradingWindowEventModel = null;
                objTradingWindowsEventDTO = null;
                objTradingWindowEventSL = null;
                lstList = null;
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
            }
        }
        #endregion Create

        #region Save
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        [Button(ButtonName = "Create")]
        [ActionName("Create")]
        public ActionResult Create(TradingWindowEventModel objTradingWindowEventModel, int TradingWindowOtherUserAction)
        {
            TradingWindowEventDTO objTradingWindowsEventDTO = new TradingWindowEventDTO();
            TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            DateTime dtResultDeclaration = new DateTime();
            DateTime dtWindowsClosesBefore = new DateTime();
            DateTime dtWindowsOpenAfter = new DateTime();
            ApplicabilityDTO objApplicablityDTO = new ApplicabilityDTO();
            ApplicabilitySL objApplicablitySL = new ApplicabilitySL();
            TradingWindowEventDTO obj = null;
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            try
            {
                dtResultDeclaration = Convert.ToDateTime(objTradingWindowEventModel.ResultDeclarationDate);
                dtResultDeclaration = dtResultDeclaration.AddHours(Convert.ToDouble(objTradingWindowEventModel.Hours));
                dtResultDeclaration = dtResultDeclaration.AddMinutes(Convert.ToDouble(objTradingWindowEventModel.Minutes));
                objTradingWindowEventModel.ResultDeclarationDate = dtResultDeclaration;
                if (objTradingWindowEventModel.WindowCloseDate != null)
                {
                    dtWindowsClosesBefore = Convert.ToDateTime(objTradingWindowEventModel.WindowCloseDate);
                    dtWindowsClosesBefore = dtWindowsClosesBefore.AddHours(Convert.ToDouble(objTradingWindowEventModel.WindowClosesHours));
                    dtWindowsClosesBefore = dtWindowsClosesBefore.AddMinutes(Convert.ToDouble(objTradingWindowEventModel.WindowClosesMinutes));
                    objTradingWindowEventModel.WindowCloseDate = dtWindowsClosesBefore;
                }
                
                if (objTradingWindowEventModel.WindowOpenDate != null)
                {
                    dtWindowsOpenAfter = Convert.ToDateTime(objTradingWindowEventModel.WindowOpenDate);
                    dtWindowsOpenAfter = dtWindowsOpenAfter.AddHours(Convert.ToDouble(objTradingWindowEventModel.WindowOpensHours));
                    dtWindowsOpenAfter = dtWindowsOpenAfter.AddMinutes(Convert.ToDouble(objTradingWindowEventModel.WindowOpensMinutes));
                    objTradingWindowEventModel.WindowOpenDate = dtWindowsOpenAfter;
                }
                if (objTradingWindowEventModel.TradingWindowEventId == 0 || objTradingWindowEventModel.TradingWindowStatusCodeId==null)
                {
                    objTradingWindowEventModel.TradingWindowStatusCodeId = Common.ConstEnum.Code.PolicyDocumentWindowStatusIncomplete;
                }
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objTradingWindowEventModel, objTradingWindowsEventDTO);
                int nLoggedInUserId = objLoginUserDetails.LoggedInUserID;
                ViewBag.lblWindowCloseDate = null;
                ViewBag.lblWindowClosesBeforeHours = null;
                ViewBag.lblWindowClosesBeforeMinutes = null;
                obj =  objTradingWindowEventSL.SaveOtherEventDetails(objLoginUserDetails.CompanyDBConnectionString, objTradingWindowsEventDTO, nLoggedInUserId);
                objApplicablityDTO = objApplicablitySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.TradingWindowOther, Convert.ToInt32(obj.TradingWindowEventId));
                if (objApplicablityDTO != null)
                {
                    if (obj.TradingWindowStatusCodeId == ConstEnum.Code.PolicyDocumentWindowStatusActive)
                    {
                        return RedirectToAction("Index", "TradingWindowsOther", new { acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_WINDOW_OTHER_VIEW }).Success(Common.Common.getResource("rul_msg_15407"));
                    }
                    else if (obj.TradingWindowStatusCodeId == ConstEnum.Code.PolicyDocumentWindowStatusDeactive)
                    {
                        return RedirectToAction("Index", "TradingWindowsOther", new { acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_WINDOW_OTHER_VIEW }).Success(Common.Common.getResource("rul_msg_15408"));
                    }
                    return RedirectToAction("Edit", "TradingWindowsOther", new
                    {
                        TradingWindowEventId = obj.TradingWindowEventId,
                        acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_WINDOW_OTHER_EDIT,
                        CalledFrom = "Edit"
                    }).Success(Common.Common.getResource("rul_msg_15260"));
                }
                else
                {
                    return RedirectToAction("Edit", "TradingWindowsOther", new
                    {
                        TradingWindowEventId = obj.TradingWindowEventId,
                        acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_WINDOW_OTHER_EDIT,
                        CalledFrom= "Edit"
                    }).Success(Common.Common.getResource("rul_msg_15260"));
                }
               
            }
            catch(Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.TradingWindowEvent).ToString(), null, null, null, null, true);
                ViewBag.TradingWindowsOtherEvent = lstList;
                var lstHrs = new List<PopulateComboDTO>();
                var lstmin = new List<PopulateComboDTO>();
                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                lstHrs.Add(new PopulateComboDTO() { Key = "", Value = "Hrs" });             
                lstHrs.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_24HRS; i++)
                {
                    lstHrs.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                }
                ViewBag.Hrs = lstHrs;
                lstmin.Add(new PopulateComboDTO() { Key = "", Value = "Mins" });    
                lstmin.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_MIN; i++)
                {
                    lstmin.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                }
                ViewBag.Mins = lstmin;
                ViewBag.ISEditWindowOpenPart = 1;
                ViewBag.TradingWindowOtherUserAction = TradingWindowOtherUserAction;
                return View("Create", objTradingWindowEventModel);
            }
            finally
            {
                objTradingWindowsEventDTO = null;
                objTradingWindowEventSL = null;
                objLoginUserDetails = null;
                objApplicablityDTO = null;
                objApplicablitySL = null;
                obj = null;
                lstList = null;
            }
        }
        #endregion Save

        #region Edit
        [AuthorizationPrivilegeFilter]
        public ActionResult Edit(int TradingWindowEventId, int acid, string CalledFrom)
        {
            TradingWindowEventModel objTradingWindowEventModel = new TradingWindowEventModel();
            objTradingWindowEventModel.TradingWindowEventId = TradingWindowEventId;
            TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            TradingWindowEventDTO objTradingWindowEventDTO = null;
            try
            {
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.TradingWindowEvent).ToString(), null, null, null, null, true);
                ViewBag.TradingWindowsOtherEvent = lstList;
                var lstHrs = new List<PopulateComboDTO>();
                var lstmin = new List<PopulateComboDTO>();
                lstHrs.Add(new PopulateComboDTO() { Key = "", Value = "Hrs" }); 
                lstHrs.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_24HRS; i++)
                {
                    lstHrs.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                }
                ViewBag.Hrs = lstHrs;
                lstmin.Add(new PopulateComboDTO() { Key = "", Value = "Mins" });    
                lstmin.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_MIN; i++)
                {
                    lstmin.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                }
                ViewBag.Mins = lstmin;

                objTradingWindowEventDTO = objTradingWindowEventSL.GetDetailsOtherEvent(objLoginUserDetails.CompanyDBConnectionString, TradingWindowEventId);
                if (objTradingWindowEventDTO != null)
                {
                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objTradingWindowEventDTO, objTradingWindowEventModel);
                    DateTime dtResultDeclaration = new DateTime();
                    dtResultDeclaration = (DateTime)objTradingWindowEventModel.ResultDeclarationDate;
                    objTradingWindowEventModel.Hours = Convert.ToString(dtResultDeclaration.Hour);
                    objTradingWindowEventModel.Minutes = Convert.ToString(dtResultDeclaration.Minute);

                    var HourstoAdd = Convert.ToInt32(objTradingWindowEventModel.Hours) * -1;
                    var MinutesToAdd = Convert.ToInt32(objTradingWindowEventModel.Minutes) * -1;
                    dtResultDeclaration = dtResultDeclaration.AddHours(HourstoAdd);
                    dtResultDeclaration = dtResultDeclaration.AddMinutes(MinutesToAdd);
                    
                    DateTime dtWindowsClosesBefore = new DateTime();
                    dtWindowsClosesBefore = (DateTime)objTradingWindowEventModel.WindowCloseDate;
                    objTradingWindowEventModel.WindowClosesHours = dtWindowsClosesBefore.Hour;
                    objTradingWindowEventModel.WindowClosesMinutes = dtWindowsClosesBefore.Minute;
                    dtWindowsClosesBefore = dtWindowsClosesBefore.AddHours(Convert.ToInt32(objTradingWindowEventModel.WindowClosesHours) * -1);
                    dtWindowsClosesBefore = dtWindowsClosesBefore.AddMinutes(Convert.ToInt32(objTradingWindowEventModel.WindowClosesMinutes) * -1);

                    DateTime dtWindowsOpenAfter = new DateTime();
                    dtWindowsOpenAfter = (DateTime)objTradingWindowEventModel.WindowOpenDate;
                    objTradingWindowEventModel.WindowOpensHours = dtWindowsOpenAfter.Hour;
                    objTradingWindowEventModel.WindowOpensMinutes = dtWindowsOpenAfter.Minute;
                    dtWindowsOpenAfter = dtWindowsOpenAfter.AddHours(Convert.ToInt32(objTradingWindowEventModel.WindowOpensHours) * -1);
                    dtWindowsOpenAfter = dtWindowsOpenAfter.AddMinutes(Convert.ToInt32(objTradingWindowEventModel.WindowOpensMinutes) * -1);                   
                    objTradingWindowEventModel.WindowOpenDate = dtWindowsOpenAfter;
                    objTradingWindowEventModel.WindowCloseDate = dtWindowsClosesBefore;
                    objTradingWindowEventModel.ResultDeclarationDate = dtResultDeclaration;
                    ApplicabilitySL objApplicabilitySL = new ApplicabilitySL();
                    ApplicabilityDTO objApplicabilityDTO = objApplicabilitySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, InsiderTrading.Common.ConstEnum.Code.TradingWindowOther, TradingWindowEventId);
                    if (objApplicabilityDTO != null)
                    {
                        ViewBag.HasApplicabilityDefinedFlag = 1;
                    }
                    else
                    {
                        ViewBag.HasApplicabilityDefinedFlag = 0;
                    }
                     ViewBag.ISEditWindow = objTradingWindowEventDTO.ISEditWindow;
                     ViewBag.ISEditWindowOpenPart = objTradingWindowEventDTO.ISEditWindowOpenPart;
                     ViewBag.TradingWindowOtherUserAction = InsiderTrading.Common.ConstEnum.UserActions.TRADING_WINDOW_OTHER_EDIT;
                    return View("Create", objTradingWindowEventModel);
                }
                return View("Create");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.TradingWindowEvent).ToString(), null, null, null, null, true);
                ViewBag.TradingWindowsOtherEvent = lstList;
                var lstHrs = new List<PopulateComboDTO>();
                var lstmin = new List<PopulateComboDTO>();

                lstHrs.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_24HRS; i++)
                {
                    lstHrs.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                }
                ViewBag.Hrs = lstHrs;
                lstmin.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_MIN; i++)
                {
                    lstmin.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                }
                ViewBag.Mins = lstmin;
                return View("Create", objTradingWindowEventModel);
            }
            finally
            {
                objTradingWindowEventModel = null;
                objTradingWindowEventDTO = null;
                objTradingWindowEventSL = null;
                lstList = null;
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
            }
        }
        #endregion Edit

        #region Delete
        // GET: /CorporateUser/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        [Button(ButtonName = "DeleteEvent")]
        [ActionName("Create")]
        public ActionResult Delete(int TradingWindowEventId, int TradingWindowOtherUserAction)
        {

            TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingWindowEventModel objTradingWindowEventModel = new TradingWindowEventModel();
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            TradingWindowEventDTO objTradingWindowEventDTO = null;
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            try
            {
                objTradingWindowEventModel.TradingWindowEventId = TradingWindowEventId;
                objTradingWindowEventSL.DeleteOtherEventDetails(objLoginUserDetails.CompanyDBConnectionString, TradingWindowEventId, objLoginUserDetails.LoggedInUserID);
                return RedirectToAction("Index", "TradingWindowsOther", new { acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_WINDOW_OTHER_VIEW }).Success(Common.Common.getResource("rul_msg_15261"));                
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.TradingWindowEvent).ToString(), null, null, null, null, true);
                ViewBag.TradingWindowsOtherEvent = lstList;
                var lstHrs = new List<PopulateComboDTO>();
                var lstmin = new List<PopulateComboDTO>();
             
                lstHrs.Add(new PopulateComboDTO() { Key = "", Value = "Hrs" });
                lstHrs.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_24HRS; i++)
                {
                    lstHrs.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                }
                ViewBag.Hrs = lstHrs;
                lstmin.Add(new PopulateComboDTO() { Key = "", Value = "Mins" });
                lstmin.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_MIN; i++)
                {
                    lstmin.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                }
                ViewBag.Mins = lstmin;

                objTradingWindowEventDTO = objTradingWindowEventSL.GetDetailsOtherEvent(objLoginUserDetails.CompanyDBConnectionString, TradingWindowEventId);
                if (objTradingWindowEventDTO != null)
                {
                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objTradingWindowEventDTO, objTradingWindowEventModel);
                    DateTime dtResultDeclaration = new DateTime();
                    dtResultDeclaration = (DateTime)objTradingWindowEventModel.ResultDeclarationDate;
                    objTradingWindowEventModel.Hours = Convert.ToString(dtResultDeclaration.Hour);
                    objTradingWindowEventModel.Minutes = Convert.ToString(dtResultDeclaration.Minute);

                    var HourstoAdd = Convert.ToInt32(objTradingWindowEventModel.Hours) * -1;
                    var MinutesToAdd = Convert.ToInt32(objTradingWindowEventModel.Minutes) * -1;
                    dtResultDeclaration = dtResultDeclaration.AddHours(HourstoAdd);
                    dtResultDeclaration = dtResultDeclaration.AddMinutes(MinutesToAdd);

                    DateTime dtWindowsClosesBefore = new DateTime();
                    dtWindowsClosesBefore = (DateTime)objTradingWindowEventModel.WindowCloseDate;
                    objTradingWindowEventModel.WindowClosesHours = dtWindowsClosesBefore.Hour;
                    objTradingWindowEventModel.WindowClosesMinutes = dtWindowsClosesBefore.Minute;
                    dtWindowsClosesBefore = dtWindowsClosesBefore.AddHours(Convert.ToInt32(objTradingWindowEventModel.WindowClosesHours) * -1);
                    dtWindowsClosesBefore = dtWindowsClosesBefore.AddMinutes(Convert.ToInt32(objTradingWindowEventModel.WindowClosesMinutes) * -1);

                    DateTime dtWindowsOpenAfter = new DateTime();
                    dtWindowsOpenAfter = (DateTime)objTradingWindowEventModel.WindowOpenDate;
                    objTradingWindowEventModel.WindowOpensHours = dtWindowsOpenAfter.Hour;
                    objTradingWindowEventModel.WindowOpensMinutes = dtWindowsOpenAfter.Minute;
                    dtWindowsOpenAfter = dtWindowsOpenAfter.AddHours(Convert.ToInt32(objTradingWindowEventModel.WindowOpensHours) * -1);
                    dtWindowsOpenAfter = dtWindowsOpenAfter.AddMinutes(Convert.ToInt32(objTradingWindowEventModel.WindowOpensMinutes) * -1);
                    objTradingWindowEventModel.WindowOpenDate = dtWindowsOpenAfter;
                    objTradingWindowEventModel.WindowCloseDate = dtWindowsClosesBefore;
                    objTradingWindowEventModel.ResultDeclarationDate = dtResultDeclaration;
                    ViewBag.TradingWindowOtherUserAction = TradingWindowOtherUserAction;
                    return View("Create", objTradingWindowEventModel);
                }
                return View("Create");
            }
            finally
            {
                objTradingWindowEventSL = null;
                objLoginUserDetails = null;
                objTradingWindowEventModel = null;
                lstList = null;
                objTradingWindowEventDTO = null;
                objPopulateComboDTO = null;
            }
        }
        #endregion Delete

        #region DeleteFromGrid
        [AuthorizationPrivilegeFilter]
        public ActionResult DeleteFromGrid(int acid, string CalledFrom, int TradingWindowEventId)
        {
            bool bReturn = false;
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                bReturn = objTradingWindowEventSL.DeleteOtherEventDetails(objLoginUserDetails.CompanyDBConnectionString, TradingWindowEventId, objLoginUserDetails.LoggedInUserID);
                statusFlag = true;
                ErrorDictionary.Add("success", Common.Common.getResource("rul_msg_15261"));
            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                ErrorDictionary = GetModelStateErrorsAsString();
            }
            finally
            {       
                objTradingWindowEventSL = null;
                objLoginUserDetails = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
            
        }
        #endregion DeleteFromGrid

        #region View
        [AuthorizationPrivilegeFilter]
        public ActionResult View(int nUserInfoID, int acid)
        {           
                TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
                TradingWindowEventModel objTradingWindowEventModel = new TradingWindowEventModel();
                LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                try
                {
                    lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.TradingWindowEvent).ToString(), null, null, null, null, true);
                    ViewBag.TradingWindowsOtherEvent = lstList;
                    var lstHrs = new List<PopulateComboDTO>();
                    var lstmin = new List<PopulateComboDTO>();
                  

                    lstHrs.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                    for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_24HRS; i++)
                    {
                        lstHrs.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                    }
                    ViewBag.Hrs = lstHrs;
                    lstmin.Add(new PopulateComboDTO() { Key = "0", Value = "0" });
                    for (int i = 1; i < ConstEnum.TimeFormatType.TIMEFORMAT_MIN; i++)
                    {
                        lstmin.Add(new PopulateComboDTO() { Key = i.ToString(), Value = i.ToString() });
                    }
                    ViewBag.Mins = lstmin;

                    TradingWindowEventDTO objTradingWindowEventDTO = objTradingWindowEventSL.GetDetailsOtherEvent(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID);

                    if (objTradingWindowEventDTO != null)
                    {

                        InsiderTrading.Common.Common.CopyObjectPropertyByName(objTradingWindowEventDTO, objTradingWindowEventModel);
                        return View("View", objTradingWindowEventModel);
                    }


                    return View("View");
                }
                catch (Exception exp)
                {
                    lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.TradingWindowEvent).ToString(), null, null, null, null, true);
                    ViewBag.TradingWindowsOtherEvent = lstList;
                    ViewBag.GridType = ConstEnum.GridType.TradingWindowsOtherList;
                    string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                    ModelState.AddModelError("Error", sErrMessage);
                    return View("Index");
                }
                finally
                {
                    objTradingWindowEventSL = null;
                    objTradingWindowEventModel = null;
                    objLoginUserDetails = null;
                    lstList = null;
                    objPopulateComboDTO = null;
                }
        }

        #endregion View

        #region Cancle 
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Cancle")]
        [ActionName("Create")]
        public ActionResult Cancle()
        {
            return RedirectToAction("Index", "TradingWindowsOther", new { acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_WINDOW_OTHER_VIEW});
        }

        #endregion View

        #region GetTradingWindow
        [HttpPost]
        public ActionResult GetTradingWindow()
        {
            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            string sEventDate = "";
            DateTime dtTempDate = new DateTime();
            WeekForMonth weeks = new WeekForMonth();
            EventDTO objEventList = new EventDTO();
            TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                weeks.Year = null;
                DateTime now = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                ViewBag.CurrentMonth = now.ToString("MMMM");
                ViewBag.CurrentYear = now.Year;
                weeks = getCalender(Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString).Month, ViewBag.CurrentYear);
                DateTime FirstDayOfMonth = new DateTime(now.Year, now.Month, 1);

                Common.Common.WriteLogToFile("objLoginUserDetails " + ((objLoginUserDetails==null)?"is null":"not null"), System.Reflection.MethodBase.GetCurrentMethod());

                if (objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType
                  || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin)
                {
                    objEventList = objTradingWindowEventSL.GetCurrentEvent(objLoginUserDetails.CompanyDBConnectionString, 0);
                }
                else
                {
                    objEventList = objTradingWindowEventSL.GetCurrentEvent(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                }
                if (objEventList.WindowCloseDate != null)
                {
                    dtTempDate = Convert.ToDateTime(objEventList.WindowCloseDate);
                    sEventDate = dtTempDate.ToString("dd MMMM yyyy");
                }
                if (objEventList.WindowOpenDate != null)
                {
                    dtTempDate = Convert.ToDateTime(objEventList.WindowOpenDate);
                    sEventDate = "Closes: " + sEventDate + " - " + "Opens: " + dtTempDate.ToString("dd MMMM yyyy");
                }
                ViewBag.EventDate = sEventDate;
                weeks.Month = now.ToString("MMMM") + " " + now.Year.ToString();
                ViewBag.GridType = 114063;
                ViewBag.Param1 = FirstDayOfMonth.Year + "-" + FirstDayOfMonth.Month + "-" + FirstDayOfMonth.Day;  //Common.Common.ApplyFormatting(FirstDayOfMonth,Common.ConstEnum.DataFormatType.Date);

                Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());

                return PartialView("TradingWindowCalenderDashboard", weeks);
            }
            catch (Exception exp)
            {
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);

                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return PartialView("TradingWindowCalenderDashboard", weeks);
            }
            finally
            {
                weeks = null;
                objEventList = null;
                objTradingWindowEventSL = null;
            }
        }
        #endregion GetTradingWindow

        #region GetTradingWindow
        [HttpPost]
        public ActionResult GetTradingWindowCalendar(int Year, string sMonth, string CalledFrom)
        {
            string sEventDate = "";
            DateTime dtTempDate = new DateTime();
            EventDTO objEventList = new EventDTO();
            TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            WeekForMonth weeks = new WeekForMonth();
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                sMonth = sMonth.TrimStart();
                DateTime now = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                int nMonth = DateTime.ParseExact(sMonth, "MMMM", CultureInfo.CurrentCulture).Month;
                if (CalledFrom == "Prev")
                {
                    if (nMonth != 1)
                    {
                        nMonth = nMonth - 1;
                    }
                    else
                    {
                        nMonth = 12;
                        Year = Year - 1;
                    }
                }
                else if (CalledFrom == "Next")
                {
                    if (nMonth != 12)
                    {
                        nMonth = nMonth + 1;
                    }
                    else
                    {
                        nMonth = 1;
                        Year = Year + 1;
                    }
                }
                weeks = getCalender(nMonth, Year);
                DateTime FirstDayOfMonth = new DateTime(Year, nMonth, 1);


                if (objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType
                 || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin)
                {
                    objEventList = objTradingWindowEventSL.GetCurrentEvent(objLoginUserDetails.CompanyDBConnectionString, 0);
                }
                else
                {
                    objEventList = objTradingWindowEventSL.GetCurrentEvent(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                }
                if (objEventList.WindowCloseDate != null)
                {
                    dtTempDate = Convert.ToDateTime(objEventList.WindowCloseDate);
                    sEventDate = dtTempDate.ToString("dd MMMM yyyy");
                }
                if (objEventList.WindowOpenDate != null)
                {
                    dtTempDate = Convert.ToDateTime(objEventList.WindowOpenDate);
                    sEventDate = "Closes: " + sEventDate + " - " + "Opens: " + dtTempDate.ToString("dd MMMM yyyy");
                }
                ViewBag.EventDate = sEventDate;
                ViewBag.CurrentMonth = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(nMonth);
                ViewBag.CurrentYear = Year;
                ViewBag.GridType = 114063;
                DateTime d = new DateTime(Year, nMonth, 1);
                weeks.Month = d.ToString("MMMM") + " " + d.Year.ToString();
                // ViewBag.Param1 = Common.Common.ApplyFormatting(FirstDayOfMonth, Common.ConstEnum.DataFormatType.Date);// FirstDayOfMonth;
                ViewBag.Param1 = FirstDayOfMonth.Year + "-" + FirstDayOfMonth.Month + "-" + FirstDayOfMonth.Day;
                return PartialView("TradingWindowCalenderDashboard", weeks);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return PartialView("TradingWindowCalenderDashboard", weeks);
            }
            finally
            {
                weeks = null;
                objEventList = null;
                objTradingWindowEventSL = null;
                objLoginUserDetails = null;
            }
        }
        #endregion GetTradingWindow

        #region Calender

        #region Calender
       [AuthorizationPrivilegeFilter]
        public ActionResult Calender(int acid, string CalledFrom ="")
        {
            List<EventDTO> lstEventList = new List<EventDTO>();
            TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            WeekForMonth weeks = new WeekForMonth();
            try
            {
               
                weeks.Year = null;
                DateTime now = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                ViewBag.CurrentMonth = now.ToString("MMMM");
                ViewBag.CurrentYear = now.Year;
                weeks = getCalender(Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString).Month, ViewBag.CurrentYear);
                DateTime FirstDayOfMonth = new DateTime(now.Year, now.Month, 1);
                lstEventList.AddRange(objTradingWindowEventSL.GetEventForMonth(objLoginUserDetails.CompanyDBConnectionString, FirstDayOfMonth));
                ViewBag.EventList = lstEventList;
                weeks.Month = now.ToString("MMMM") + " " + now.Year.ToString();
                ViewBag.GridType = 114063;
                ViewBag.PageFrom = CalledFrom;
                ViewBag.Param1 = FirstDayOfMonth.Year + "-" + FirstDayOfMonth.Month + "-" + FirstDayOfMonth.Day;  //Common.Common.ApplyFormatting(FirstDayOfMonth,Common.ConstEnum.DataFormatType.Date);
                if (objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType
                    || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin)
                {
                    ViewBag.ViewCalenderAction = InsiderTrading.Common.ConstEnum.UserActions.TRADING_WINDOW_OTHER_VIEW;
                    ViewBag.LUID = 0;
                }
                else
                {
                    ViewBag.ViewCalenderAction = InsiderTrading.Common.ConstEnum.UserActions.INSIDER_TRADING_WINDOW_CALENDER_VIEW;
                    ViewBag.LUID = objLoginUserDetails.LoggedInUserID;
                }
               
                return View("TradingWindowCalender", weeks);
            }
            catch (Exception exp)
            {
                ViewBag.TradingWindowsOtherEvent = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.TradingWindowEvent).ToString(), null, null, null, null, true); ;
                ViewBag.GridType = ConstEnum.GridType.TradingWindowsOtherList;
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index");
            }
            finally
            {
                lstEventList = null;
                objTradingWindowEventSL = null;
                objLoginUserDetails = null;
                weeks = null;
            }
        }
        #endregion Calender

        #region HttpPost_Calender
        [HttpPost]
        //[ValidateAntiForgeryToken]
        [AuthorizationPrivilegeFilter]
        public ActionResult Calender(int Year, string sMonth, string CalledFrom, int acid, string PageFrom)
       {
           List<EventDTO> lstEventList = new List<EventDTO>();
           TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
           LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
           WeekForMonth weeks = new WeekForMonth();
           Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                sMonth = sMonth.TrimStart();
                DateTime now = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                int nMonth = DateTime.ParseExact(sMonth, "MMMM", CultureInfo.CurrentCulture).Month;
                if (CalledFrom == "Prev")
                {
                    if (nMonth != 1)
                    {
                        nMonth = nMonth - 1;
                    }
                    else
                    {
                        nMonth = 12;
                        Year = Year - 1;
                    }
                }
                else if (CalledFrom == "Next")
                {
                    if (nMonth != 12)
                    {
                        nMonth = nMonth + 1;
                    }
                    else
                    {
                        nMonth = 1;
                        Year = Year + 1;
                    }
                }
                weeks = getCalender(nMonth, Year);
                DateTime FirstDayOfMonth = new DateTime(Year, nMonth, 1);
                lstEventList.AddRange(objTradingWindowEventSL.GetEventForMonth(objLoginUserDetails.CompanyDBConnectionString, FirstDayOfMonth));
                ViewBag.EventList = lstEventList;
                ViewBag.CurrentMonth = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(nMonth);
                ViewBag.CurrentYear = Year;
                ViewBag.GridType = 114063;
                DateTime d = new DateTime(Year, nMonth, 1);
                weeks.Month = d.ToString("MMMM") + " " + d.Year.ToString();
                ViewBag.NewMonth = d.ToString("MMMM") + " " + d.Year.ToString();
                // ViewBag.Param1 = Common.Common.ApplyFormatting(FirstDayOfMonth, Common.ConstEnum.DataFormatType.Date);// FirstDayOfMonth;
                ViewBag.Param1 = FirstDayOfMonth.Year + "-" + FirstDayOfMonth.Month + "-" + FirstDayOfMonth.Day;
                ViewBag.PageFrom = PageFrom;
                if (objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType
                   || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin)
                {
                    ViewBag.ViewCalenderAction = InsiderTrading.Common.ConstEnum.UserActions.TRADING_WINDOW_OTHER_VIEW;
                    ViewBag.LUID = 0;
                }
                else
                {
                    ViewBag.ViewCalenderAction = InsiderTrading.Common.ConstEnum.UserActions.INSIDER_TRADING_WINDOW_CALENDER_VIEW;
                    ViewBag.LUID = objLoginUserDetails.LoggedInUserID;
                }
                return PartialView("_ViewEventCalender", weeks);
            }
            catch (Exception exp)
            {
                weeks.Year = null;
                DateTime now = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                ViewBag.CurrentMonth = now.ToString("MMMM");
                ViewBag.CurrentYear = now.Year;
                weeks = getCalender(Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString).Month, ViewBag.CurrentYear);
                DateTime FirstDayOfMonth = new DateTime(now.Year, now.Month, 1);
                lstEventList.AddRange(objTradingWindowEventSL.GetEventForMonth(objLoginUserDetails.CompanyDBConnectionString, FirstDayOfMonth));
                ViewBag.EventList = lstEventList;
                weeks.Month = now.ToString("MMMM") + " " + now.Year.ToString();
                ViewBag.GridType = 114063;
                ViewBag.PageFrom = CalledFrom;
                ViewBag.Param1 = FirstDayOfMonth.Year + "-" + FirstDayOfMonth.Month + "-" + FirstDayOfMonth.Day;  //Common.Common.ApplyFormatting(FirstDayOfMonth,Common.ConstEnum.DataFormatType.Date);
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("TradingWindowCalender", weeks);
            }
            finally
            {
                lstEventList = null;
                objTradingWindowEventSL = null;
                objLoginUserDetails = null;
                weeks = null;
            }
        }
        #endregion HttpPost_Calender

        #region HttpPost_Calender
        [HttpPost]
        //[ValidateAntiForgeryToken]
        public ActionResult ViewAll(int Year, string sMonth, string CalledFrom, int acid, string PageFrom="")
        {
            List<EventDTO> lstEventList = new List<EventDTO>();
            TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            WeekForMonth weeks = new WeekForMonth();
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                sMonth = sMonth.TrimStart();
                DateTime now = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                int nMonth = DateTime.ParseExact(sMonth, "MMMM", CultureInfo.CurrentCulture).Month;
                if (CalledFrom == "Prev")
                {
                    if (nMonth != 1)
                    {
                        nMonth = nMonth - 1;
                    }
                    else
                    {
                        nMonth = 12;
                        Year = Year - 1;
                    }
                }
                else if (CalledFrom == "Next")
                {
                    if (nMonth != 12)
                    {
                        nMonth = nMonth + 1;
                    }
                    else
                    {
                        nMonth = 1;
                        Year = Year + 1;
                    }
                }
                weeks = getCalender(nMonth, Year);
                DateTime FirstDayOfMonth = new DateTime(Year, nMonth, 1);
               
                lstEventList.AddRange(objTradingWindowEventSL.GetEventForMonth(objLoginUserDetails.CompanyDBConnectionString, FirstDayOfMonth));
                ViewBag.EventList = lstEventList;
                ViewBag.CurrentMonth = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(nMonth);
                ViewBag.CurrentYear = Year;
                ViewBag.GridType = 114063;
                DateTime d = new DateTime(Year, nMonth, 1);
                weeks.Month = d.ToString("MMMM") + " " + d.Year.ToString();
                ViewBag.Param1 = null;
                ViewBag.PageFrom = PageFrom;
                if (objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType
                   || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin)
                {
                    ViewBag.ViewCalenderAction = InsiderTrading.Common.ConstEnum.UserActions.TRADING_WINDOW_OTHER_VIEW;
                    ViewBag.LUID =0;
                }
                else
                {
                    ViewBag.ViewCalenderAction = InsiderTrading.Common.ConstEnum.UserActions.INSIDER_TRADING_WINDOW_CALENDER_VIEW;
                    ViewBag.LUID = objLoginUserDetails.LoggedInUserID;
                }
               
                return PartialView("_ViewEventCalender", weeks);
            }
            catch (Exception exp)
            {
                weeks.Year = null;
                DateTime now = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                ViewBag.CurrentMonth = now.ToString("MMMM");
                ViewBag.CurrentYear = now.Year;
                weeks = getCalender(Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString).Month, ViewBag.CurrentYear);
                DateTime FirstDayOfMonth = new DateTime(now.Year, now.Month, 1);
                lstEventList.AddRange(objTradingWindowEventSL.GetEventForMonth(objLoginUserDetails.CompanyDBConnectionString, FirstDayOfMonth));
                ViewBag.EventList = lstEventList;
                weeks.Month = now.ToString("MMMM") + " " + now.Year.ToString();
                ViewBag.GridType = 114063;
                ViewBag.PageFrom = CalledFrom;
                ViewBag.Param1 = FirstDayOfMonth.Year + "-" + FirstDayOfMonth.Month + "-" + FirstDayOfMonth.Day;  //Common.Common.ApplyFormatting(FirstDayOfMonth,Common.ConstEnum.DataFormatType.Date);
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("TradingWindowCalender", weeks);
            }
            finally
            {
                lstEventList = null;
                objTradingWindowEventSL = null;
                objLoginUserDetails = null;
                weeks = null;
            }
        }
        #endregion HttpPost_Calender

        #region getCalender
        public WeekForMonth getCalender(int nMonth, int Year)
        {
            List<DayDTO> lstList = new List<DayDTO>();
            DayDTO objDayDTO = new DayDTO();
            //sMonth = sMonth.TrimStart();
            //int nMonth = DateTime.ParseExact(sMonth, "MMMM", CultureInfo.CurrentCulture).Month;
            DateTime FirstDayOfMonth = new DateTime(Year, nMonth, 1);
            int nUserInfoId = 0;

            objDayDTO.DayCount = 0;
            objDayDTO.IsBlocked = 0;
            objDayDTO.TradingWindowEventId = 0;        
            lstList.Add(objDayDTO);
            TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            if(objLoginUserDetails.UserTypeCodeId == 101003 || objLoginUserDetails.UserTypeCodeId == 101004 || objLoginUserDetails.UserTypeCodeId == 101006)
            {
                nUserInfoId = objLoginUserDetails.LoggedInUserID;
            }
            lstList.AddRange(objTradingWindowEventSL.GetBlockedDatesOfMonth(objLoginUserDetails.CompanyDBConnectionString, FirstDayOfMonth, nUserInfoId));

            WeekForMonth weeks = new WeekForMonth();
            weeks.Week1 = new List<Day>();
            weeks.Week2 = new List<Day>();
            weeks.Week3 = new List<Day>();
            weeks.Week4 = new List<Day>();
            weeks.Week5 = new List<Day>();
            weeks.Week6 = new List<Day>();

            List<DateTime> dt = new List<DateTime>();
            dt = GetDates(Year, nMonth);

            foreach (DateTime day in dt)
            {
                switch (GetWeekOfMonth(day))
                {
                    case 1:
                        Day dy1 = new Day();

                        dy1.Date = day;
                        dy1._Date = day.ToShortDateString();
                        dy1.dateStr = day.ToString("MM/dd/yyyy");
                        dy1.dtDay = day.Day;
                        dy1.daycolumn = GetDateInfo(dy1.Date);
                        dy1.IsBlocked = lstList[day.Day].IsBlocked;    
                        dy1.TradingWindowEventId = lstList[day.Day].TradingWindowEventId;                  
                        weeks.Week1.Add(dy1);
                        break;
                    case 2:
                        Day dy2 = new Day();
                        dy2.Date = day;
                        dy2._Date = day.ToShortDateString();
                        dy2.dateStr = day.ToString("MM/dd/yyyy");
                        dy2.dtDay = day.Day;
                        dy2.daycolumn = GetDateInfo(dy2.Date);
                        dy2.IsBlocked = lstList[day.Day].IsBlocked;
                        dy2.TradingWindowEventId = lstList[day.Day].TradingWindowEventId;                      
                        weeks.Week2.Add(dy2);
                        break;
                    case 3:
                        Day dy3 = new Day();
                        dy3.Date = day;
                        dy3._Date = day.ToShortDateString();
                        dy3.dateStr = day.ToString("MM/dd/yyyy");
                        dy3.dtDay = day.Day;
                        dy3.daycolumn = GetDateInfo(dy3.Date);
                        dy3.IsBlocked = lstList[day.Day].IsBlocked;
                        dy3.TradingWindowEventId = lstList[day.Day].TradingWindowEventId;                      
                        weeks.Week3.Add(dy3);
                        break;
                    case 4:
                        Day dy4 = new Day();
                        dy4.Date = day;
                        dy4._Date = day.ToShortDateString();
                        dy4.dateStr = day.ToString("MM/dd/yyyy");
                        dy4.dtDay = day.Day;
                        dy4.daycolumn = GetDateInfo(dy4.Date);
                        dy4.IsBlocked = lstList[day.Day].IsBlocked;
                        dy4.TradingWindowEventId = lstList[day.Day].TradingWindowEventId;                       
                        weeks.Week4.Add(dy4);
                        break;
                    case 5:
                        Day dy5 = new Day();
                        dy5.Date = day;
                        dy5._Date = day.ToShortDateString();
                        dy5.dateStr = day.ToString("MM/dd/yyyy");
                        dy5.dtDay = day.Day;
                        dy5.daycolumn = GetDateInfo(dy5.Date);
                        dy5.IsBlocked = lstList[day.Day].IsBlocked;
                        dy5.TradingWindowEventId = lstList[day.Day].TradingWindowEventId;                     
                        weeks.Week5.Add(dy5);
                        break;
                    case 6:
                        Day dy6 = new Day();
                        dy6.Date = day;
                        dy6._Date = day.ToShortDateString();
                        dy6.dateStr = day.ToString("MM/dd/yyyy");
                        dy6.dtDay = day.Day;
                        dy6.daycolumn = GetDateInfo(dy6.Date);
                        dy6.IsBlocked = lstList[day.Day].IsBlocked;
                        dy6.TradingWindowEventId = lstList[day.Day].TradingWindowEventId;                     
                        weeks.Week6.Add(dy6);
                        break;
                };
            }
            while (weeks.Week1.Count < 7) // not starting from sunday
            {
                Day dy = null;
                weeks.Week1.Insert(0, dy);
            }

            if (nMonth == 12)
            {
                weeks.nextMonth = (01).ToString() + "/" + (Year + 1).ToString();
                weeks.prevMonth = (nMonth - 1).ToString() + "/" + (Year).ToString();
            }
            else if (nMonth == 1)
            {
                weeks.nextMonth = (nMonth + 1).ToString() + "/" + (Year).ToString();
                weeks.prevMonth = (12).ToString() + "/" + (Year - 1).ToString();
            }
            else
            {
                weeks.nextMonth = (nMonth + 1).ToString() + "/" + (Year).ToString();
                weeks.prevMonth = (nMonth - 1).ToString() + "/" + (Year).ToString();
            }
            return weeks; 
        }
        #endregion getCalender

        #region GetDates
        public static List<DateTime> GetDates(int year, int month)
        {
            return Enumerable.Range(1, DateTime.DaysInMonth(year, month))  // Days: 1, 2 ... 31 etc.
            .Select(day => new DateTime(year, month, day)) // Map each day to a date
            .ToList();
        }
        #endregion GetDates

        #region GetWeekOfMonth
        public static int GetWeekOfMonth(DateTime date)
        {
            DateTime beginningOfMonth = new DateTime(date.Year, date.Month, 1);
            while (date.Date.AddDays(1).DayOfWeek != DayOfWeek.Sunday)
                date = date.AddDays(1);
            return (int)Math.Truncate((double)date.Subtract(beginningOfMonth).TotalDays / 7f) + 1;
        }
        #endregion GetWeekOfMonth

        #region GetDateInfo
        public int GetDateInfo(DateTime now)
        {
            int dayNumber = 0;
            DateTime dt = now.Date;
            string dayStr = Convert.ToString(dt.DayOfWeek);

            if (dayStr.ToLower() == "sunday")
            {
                dayNumber = 0;
            }
            else if (dayStr.ToLower() == "monday")
            {
                dayNumber = 1;
            }
            else if (dayStr.ToLower() == "tuesday")
            {
                dayNumber = 2;
            }
            else if (dayStr.ToLower() == "wednesday")
            {
                dayNumber = 3;
            }
            else if (dayStr.ToLower() == "thursday")
            {
                dayNumber = 4;
            }
            else if (dayStr.ToLower() == "friday")
            {
                dayNumber = 5;
            }
            else if (dayStr.ToLower() == "saturday")
            {
                dayNumber = 6;
            }
            return dayNumber;
        }
        #endregion GetDateInfo

        #endregion Calender

        #region Private Methods

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
                    i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, "rul_msg_").ToList<PopulateComboDTO>());
                return lstPopulateComboDTO;
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion FillComboValues

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }
        #endregion Private Methods

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