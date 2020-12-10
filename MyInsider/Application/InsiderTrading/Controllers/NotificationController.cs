using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading.Common;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using Newtonsoft.Json;
using InsiderTrading.Filters;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class NotificationController : Controller
    {
        //
        // GET: /TemplateMaster/
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid ,string CalledFrom = "")
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            NotificationModel objNotificationModel = new NotificationModel();
            try
            {
                List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationModes).ToString(), Convert.ToInt32(ConstEnum.Code.CommunicationCategory).ToString(), null, null, null, true);
                ViewBag.ModeCodeList = lstList;
                lstList = null;
                ViewBag.UserId = objLoginUserDetails.LoggedInUserID;
                if (CalledFrom == "OS")
                {
                    ViewBag.CalledFrom = CalledFrom;
                }
                else
                {
                    ViewBag.CalledFrom = null;
                }
                
                    FillGrid(ConstEnum.GridType.NotificationList, Convert.ToString(objLoginUserDetails.LoggedInUserID), null, null, null, null);

                

                return View("Index");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index");
            }
            finally
            {
                objNotificationModel = null;
                objLoginUserDetails = null;
            }
        }

        //
        // GET: /TemplateMaster/Create
        [AuthorizationPrivilegeFilter]
        public ActionResult View(int acid, int NotificationId)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            NotificationModel objNotificationModel = new NotificationModel();
            
            //CommunicationRuleMasterSL objCommunicationRuleMasterSL = new CommunicationRuleMasterSL();
            NotificationDTO objNotificationDTO = new NotificationDTO();
            //NotificationSL objNotificationSL = new NotificationSL();
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
             try
            {

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationModes).ToString(), Convert.ToInt32(ConstEnum.Code.CommunicationCategory).ToString(), null, null, null, true);
                ViewBag.ModeCodeList = lstList;
                if (NotificationId > 0)
                {
                    using (var objNotificationSL = new NotificationSL())
                    {
                        objNotificationDTO = objNotificationSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, NotificationId);
                    }
                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objNotificationDTO, objNotificationModel);
                    objNotificationModel.Contents = objNotificationModel.Contents.Replace("\\r\\n", "<br/>");
                    if (objNotificationModel.Signature != null)
                    {
                        objNotificationModel.Signature = objNotificationModel.Signature.Replace("\\r\\n", "<br/>");
                    }
             
                }
                ViewBag.ModeCodeId = objNotificationDTO.ModeCodeId;
                ViewBag.NotificationQueueId = NotificationId;
                ViewBag.UserId =  objLoginUserDetails.LoggedInUserID;
                           
                //ViewBag.CommunicationMode_id = objCommunicationRuleMasterModel.CommunicationModeCodeId;
                return View("View", objNotificationModel);
            }
             catch (Exception exp)
             {
                 //NotificationModel objNotificationModel = new NotificationModel();
                 string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                 ModelState.AddModelError("Error", sErrMessage);
                 return View("View", objNotificationModel);
            }
             finally
             {
                 objLoginUserDetails = null;
                 objNotificationModel = null;
                 objNotificationDTO = null;
                 lstList = null;
             } 
        }

        #region Cancel Button Action
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Cancel")]
        [ActionName("Cancel")]
        public ActionResult Cancel()
        {

            return RedirectToAction("Index", "Notification", new { acid = InsiderTrading.Common.ConstEnum.UserActions.NOTIFICATION_LIST_RIGHT });

        }
        #endregion Cancel Button Action

        #region DisplayAlert

        public ActionResult DisplayAlert()
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            NotificationModel objNotificationModel = new NotificationModel();

           // NotificationSL objNotificationSL = new NotificationSL();
            List<NotificationDTO> lstList = new List<NotificationDTO>();
            try
            {
                ViewBag.NoRecord = true;
                using (var objNotificationSL = new NotificationSL())
                {
                    lstList = objNotificationSL.GetNotificationAlertList(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, "ALERT");
                }
                if (lstList.Count > 0)
                {
                    foreach (var objItem in lstList)
                    {
                        objItem.Contents = objItem.Contents.Replace("<br />", Environment.NewLine);
                    }
                    ViewBag.NoRecord = false;
                }
                ViewBag.NotificationDictionary = lstList;
                
                //ViewBag.ModeCodeId = objNotificationDTO.ModeCodeId;
                //ViewBag.NotificationQueueId = NotificationId;
                //ViewBag.UserId = objLoginUserDetails.LoggedInUserID;

                //ViewBag.CommunicationMode_id = objCommunicationRuleMasterModel.CommunicationModeCodeId;
                return PartialView("PartialCreate");
            }
            catch (Exception exp)
            {
                //NotificationModel objNotificationModel = new NotificationModel();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("View", objNotificationModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objNotificationModel = null;
                lstList = null;
            }
        }
        #endregion DisplayAlert

        #region DashboardNotification

        public ActionResult DashboardNotification()
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            NotificationModel objNotificationModel = new NotificationModel();
            objLoginUserDetails.ShowNotificationPopup = false;
            Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
            //NotificationSL objNotificationSL = new NotificationSL();
            List<NotificationDTO> lstList = new List<NotificationDTO>();
            try
            {
                CheckAppliedModule();
                ViewBag.NoRecord = false;
                using (var objNotificationSL = new NotificationSL())
                {
                    lstList = objNotificationSL.GetDashboardNotificationList(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                }
                if (lstList.Count > 0)                {
                    
                    ViewBag.UserId = objLoginUserDetails.LoggedInUserID;
                   // FillGrid(ConstEnum.GridType.DashBboardNotificationList, Convert.ToString(objLoginUserDetails.LoggedInUserID), Convert.ToString(Common.ConstEnum.Code.CommunicationModeForEmail), null, null, null);
                    ViewBag.NotificationDictionary = lstList;
                    return PartialView("DashboardNotificationIndex");
                }
                else
                {
                    ViewBag.NoRecord = true;
                    return PartialView("DashboardNotificationIndex");
                }
            }
            catch (Exception exp)
            {
                //NotificationModel objNotificationModel = new NotificationModel();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.UserId = objLoginUserDetails.LoggedInUserID;
                FillGrid(ConstEnum.GridType.DashBboardNotificationList, Convert.ToString(objLoginUserDetails.LoggedInUserID), Convert.ToString(Common.ConstEnum.Code.CommunicationModeForEmail), null, null, null);

                return PartialView("DashboardNotificationIndex");
            }
            finally
            {
                objLoginUserDetails = null;
                objNotificationModel = null;
                lstList = null;
            }
        }
        #endregion DashboardNotification

        #region PopupNotification

        public ActionResult PopupNotification()
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            NotificationModel objNotificationModel = new NotificationModel();
            objLoginUserDetails.ShowNotificationPopup = false;
            Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
            //NotificationSL objNotificationSL = new NotificationSL();
            List<NotificationDTO> lstList = new List<NotificationDTO>();
            try
            {
                ViewBag.NoRecord = false;
                using (var objNotificationSL = new NotificationSL())
                {
                    lstList = objNotificationSL.GetNotificationAlertList(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, "POPUP");
                }
                if (lstList.Count > 0)
                {
                    foreach (var objItem in lstList)
                    {
                        objItem.Contents = objItem.Contents.Replace("<br />", Environment.NewLine);
                    }
                    ViewBag.NotificationDictionary = lstList;
                    return PartialView("PopupNotificationView");
                }
                else
                {
                    ViewBag.NoRecord = true;
                    return PartialView("PopupNotificationView");
                }
                
            }
            catch (Exception exp)
            {
                //NotificationModel objNotificationModel = new NotificationModel();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.NoRecord = true;
                
                return PartialView("PopupNotificationView");
            }
            finally
            {
                objLoginUserDetails = null;
                objNotificationModel = null;
                lstList = null;
            }
        }
        #endregion PopupNotification

        #region NotificationCount

        public ActionResult NotificationCount()
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            NotificationModel objNotificationModel = new NotificationModel();

            //NotificationSL objNotificationSL = new NotificationSL();
            List<NotificationDTO> lstList = new List<NotificationDTO>();
            try
            {
                ViewBag.NoRecord = true;
                using (var objNotificationSL = new NotificationSL())
                {
                    lstList = objNotificationSL.GetNotificationAlertList(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, "ALERTCOUNT");
                }
                if (lstList.Count > 0)
                {
                    foreach (var objItem in lstList)
                    {
                        if(objItem.AlertCount > 0)
                        {
                            ViewBag.AlertCount = objItem.AlertCount;
                            ViewBag.NoRecord = false;
                            break;
                        }
                    }                    
                    
                }
                return PartialView("NotificationCountView");
            }
            catch (Exception exp)
            {
                //NotificationModel objNotificationModel = new NotificationModel();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.AlertCount = 0;
                ViewBag.NoRecord = true;
                return PartialView("NotificationCountView");
            }
            finally
            {
                objLoginUserDetails = null;
                objNotificationModel = null;
                lstList = null;
            }
        }
        #endregion NotificationCount

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
                    i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, "tra_msg_").ToList<PopulateComboDTO>());
                return lstPopulateComboDTO;
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
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


        #region Notification for Other Securities Dahsboard


        public ActionResult DashboardNotification_OS()
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            NotificationModel objNotificationModel = new NotificationModel();
            objLoginUserDetails.ShowNotificationPopup = false;
            Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
            List<NotificationDTO> lstList = new List<NotificationDTO>();

            try
            {
                CheckAppliedModule();
                ViewBag.NoRecord_OS = false;
                using (var objNotificationSL_OS = new NotificationSL_OS())
                {
                    lstList = objNotificationSL_OS.GetDashboardNotificationList(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                }
                if (lstList.Count > 0)
                {

                    ViewBag.UserId = objLoginUserDetails.LoggedInUserID;
                    ViewBag.NotificationDictionary_OS = lstList;
                    return PartialView("DashboardNotificationIndex_OS");
                }
                else
                {
                    ViewBag.NoRecord_OS = true;
                    return PartialView("DashboardNotificationIndex_OS");
                }
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.UserId = objLoginUserDetails.LoggedInUserID;
                FillGrid(ConstEnum.GridType.DashBboardNotificationList, Convert.ToString(objLoginUserDetails.LoggedInUserID), Convert.ToString(Common.ConstEnum.Code.CommunicationModeForEmail), null, null, null);

                return PartialView("DashboardNotificationIndex_OS");
            }

        }

        private void CheckAppliedModule()
        {
            int RequiredModuleID;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
            {
                InsiderTradingDAL.InsiderInitialDisclosure.DTO.InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
            }
            switch (RequiredModuleID)
            {
                case ConstEnum.Code.RequiredModuleOwnSecurity:
                    ViewBag.RequiredModuleOwn = true;
                    ViewBag.RequiredModuleBoth = false;
                    ViewBag.RequiredModuleOther = false;
                    break;
                case ConstEnum.Code.RequiredModuleOtherSecurity:
                    ViewBag.RequiredModuleOwn = false;
                    ViewBag.RequiredModuleBoth = false;
                    ViewBag.RequiredModuleOther = true;
                    break;
                case ConstEnum.Code.RequiredModuleBoth:
                    ViewBag.RequiredModuleOwn = true;
                    ViewBag.RequiredModuleBoth = true;
                    ViewBag.RequiredModuleOther = true;
                    break;

            }
        }

        [AuthorizationPrivilegeFilter]
        public ActionResult ViewNofication_OS(int acid, int NotificationId)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            NotificationModel objNotificationModel = new NotificationModel();

            NotificationDTO objNotificationDTO = new NotificationDTO();

            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            try
            {

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationModes).ToString(), Convert.ToInt32(ConstEnum.Code.CommunicationCategory).ToString(), null, null, null, true);
                ViewBag.ModeCodeList = lstList;
                if (NotificationId > 0)
                {
                    using (var objNotificationSL = new NotificationSL_OS())
                    {
                        objNotificationDTO = objNotificationSL.GetDetails_OS(objLoginUserDetails.CompanyDBConnectionString, NotificationId);
                    }
                    InsiderTrading.Common.Common.CopyObjectPropertyByName(objNotificationDTO, objNotificationModel);
                    objNotificationModel.Contents = objNotificationModel.Contents.Replace("\\r\\n", "<br/>");
                    if (objNotificationModel.Signature != null)
                    {
                        objNotificationModel.Signature = objNotificationModel.Signature.Replace("\\r\\n", "<br/>");
                    }

                }
                ViewBag.ModeCodeId = objNotificationDTO.ModeCodeId;
                ViewBag.NotificationQueueId = NotificationId;
                ViewBag.UserId = objLoginUserDetails.LoggedInUserID;

                //ViewBag.CommunicationMode_id = objCommunicationRuleMasterModel.CommunicationModeCodeId;
                return View("ViewNofication_OS", objNotificationModel);
            }
            catch (Exception exp)
            {
                //NotificationModel objNotificationModel = new NotificationModel();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("ViewNofication_OS", objNotificationModel);
            }

        }
        #endregion Notification for Other Securities Dahsboard
        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
    }
}
