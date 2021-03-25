using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Collections.Specialized;
using System.Text;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;


namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class PreclearanceRequestController : Controller
    {
        private string sLookupPrefix = "tra_msg_";
        int nDisclosureCompletedFlag = 0;
        int groupId = 0;

        #region Insider All Action & Methods

        #region Index List Page
        /// <summary>
        /// 
        /// </summary>
        /// <param name="acid"></param>
        /// <param name="PreClearanceRequestID"></param>
        /// <param name="PreClearanceRequestStatus"></param>
        /// <param name="TradeDetailsID"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid, string PreClearanceRequestID = "", string PreClearanceRequestStatus = "", string TradeDetailsID = "", string IsFromDashboard = "", int TransactionMasterID = 0, int SecurityTypeId = 0, string TransactionDate = null, int TransactionTypeId = 0, string IsApprovedPCL = "")
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            UserInfoSL objUserInfoSL = new UserInfoSL();
            UserInfoDTO objUserInfoDTO = null;
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            try
            {
                if (IsApprovedPCL.ToLower() == "yes")
                {
                    return RedirectToAction("PreClearanceNotTakenAction", "PreclearanceRequest", new { acid = InsiderTrading.Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE, from = "FromTrans" });
                }

                ViewBag.ApprovedPCLCnt = false;
                if (IsApprovedPCL == "FromTrans")
                {
                    ViewBag.ApprovedPCLCnt = true;
                }
                ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
                ViewBag.EmployeeStatusList = FillComboValues(ConstEnum.ComboType.EmpStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.EmployeeStatus, null, null, null, null, true);
                ViewBag.preclearanceNotesList = null;
                ViewBag.preclearanceNotesList = InsiderTrading.Common.Common.getResource("dis_msg_50548").Split('|');

                ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
                ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
                ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
                ViewBag.Param2 = groupId;
                ViewBag.GroupID = groupId;
                FillGrid(Common.ConstEnum.GridType.ContinousDisclosureStatusList, objLoginUserDetails.LoggedInUserID.ToString(), null, null);
                objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                ViewBag.PreClearanceRequestID = PreClearanceRequestID;
                ViewBag.PreClearanceRequestStatus = PreClearanceRequestStatus;
                ViewBag.TradeDetailsID = TradeDetailsID;
                ViewBag.IsFromDashboard = IsFromDashboard;
                ViewBag.TransactionMasterId = TransactionMasterID;
                ViewBag.SecurityType = SecurityTypeId;
                ViewBag.TransactionDate = TransactionDate;
                ViewBag.TransactionType = TransactionTypeId;
                if (IsApprovedPCL.ToLower() == "no")
                    ViewBag.IsApprovedPCL = "yes";
                TempData.Remove("DuplicateTransaction");
                TempData.Remove("TradingTransactionModel");
                if (TransactionMasterID != 0 || SecurityTypeId != 0)
                {
                    TempData.Remove("SearchArray");
                }
                if (objUserInfoDTO.DateOfBecomingInsider != null)
                {
                    ViewBag.InsiderTypeUser = 1;
                }
                else
                {
                    ViewBag.InsiderTypeUser = 0;
                }

                ViewBag.ShowNonImplementingCompanyPCLlist = (objUserInfoDTO.DateOfBecomingInsider != null && objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.EmployeeType) ? true : false;
                TempData["ShowDupTransPopUp"] = null;
                TempData["SearchArray"] = null;
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
                objLoginUserDetails = null;
                objUserInfoSL = null;
                objUserInfoDTO = null;
                objPreclearanceRequestSL = null;
            }
        }
        #endregion Index List Page

        #region Create New Preclearance
        /// <summary>
        /// 
        /// </summary>
        /// <param name="PreclearanceRequestId"></param>
        /// <param name="CalledFrom"></param>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int acid, int PreclearanceRequestId, string CalledFrom, string blink = "", int prevpcid = 0)
        {
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            PreclearanceRequestModel objPreclearanceRequestModel = new PreclearanceRequestModel();
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            PreclearanceRequestDTO objPreclearanceRequestDTO = new PreclearanceRequestDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            int nIsPreviousPeriodEndSubmission;
            string sSubsequentPeriodEndOrPreciousPeriodEndResource = "";
            //InsiderDashboardModel objInsiderDashboardModel = null;
            // InsiderDashboardDTO objInsiderDashboardDTO = null;
            UserInfoDTO objUserInfoDTO = null;
            UserInfoSL objUserInfoSL1 = new UserInfoSL();
            ViewBag.ShowTradeNote = false;
            string sSubsequentPeriodEndResourceOwnSecurity = "";
            int RequiredModuleID = 0;
            PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL();
            string sSubsequentPeriodEndResourceOtherSecurity = "";
            if (PreclearanceRequestId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PreclearanceRequest, Convert.ToInt64(PreclearanceRequestId), objLoginUserDetails.LoggedInUserID))
            {
                return RedirectToAction("Unauthorised", "Home");
            }

            if (objLoginUserDetails.CompanyName.Contains(InsiderTrading.Common.ConstEnum.CLIENT_DB_NAME))
            {
                ViewBag.ShowTradeNote = true;
            }

            objPreclearanceRequestSL.GetLastPeriodEndSubmissonFlag(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, out nIsPreviousPeriodEndSubmission, out sSubsequentPeriodEndOrPreciousPeriodEndResource, out sSubsequentPeriodEndResourceOwnSecurity);
            if (nIsPreviousPeriodEndSubmission == 1)
            {
                ViewBag.IsPreviousPeriodEndSubmissionOwnSecurity = nIsPreviousPeriodEndSubmission;
                ViewBag.SubsequentPeriodEndOrPreciousPeriodEndResource = sSubsequentPeriodEndOrPreciousPeriodEndResource;
                ViewBag.SubsequentPeriodEndResourceOwnSecurity = sSubsequentPeriodEndResourceOwnSecurity;
            }
            //As per requirement user need to submit own and other security period end disclosure before taking preclearance vice versa (if required module is set to both)
            using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
            {
                InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                ViewBag.RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
            }
            if (RequiredModuleID == ConstEnum.Code.RequiredModuleBoth)
            {
                objPreclearanceRequestNonImplCompanySL.GetLastPeriodEndSubmissonFlag_OS(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, out nIsPreviousPeriodEndSubmission, out sSubsequentPeriodEndOrPreciousPeriodEndResource, out sSubsequentPeriodEndResourceOtherSecurity);
                if (nIsPreviousPeriodEndSubmission == 1)
                {
                    ViewBag.IsPreviousPeriodEndSubmissionOtherSecurity = nIsPreviousPeriodEndSubmission;
                    ViewBag.SubsequentPeriodEndResourceOtherSecurity = sSubsequentPeriodEndResourceOtherSecurity;
                }
            }
            /*     if (nIsPreviousPeriodEndSubmission == 1 && blink == "")
                 {
                
                     ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
                     ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                     ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
                     ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
                     ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
                     FillGrid(Common.ConstEnum.GridType.ContinousDisclosureStatusList, objLoginUserDetails.LoggedInUserID.ToString(), null, null);
                     objUserInfoDTO = objUserInfoSL1.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                     ViewBag.PreClearanceRequestID = "";
                     ViewBag.PreClearanceRequestStatus = "";
                     ViewBag.TradeDetailsID = "";
                     if (objUserInfoDTO.DateOfBecomingInsider != null)
                     {
                         ViewBag.InsiderTypeUser = 1;
                     }
                     else
                     {
                         ViewBag.InsiderTypeUser = 0;
                     }
                     ModelState.AddModelError("Error", " You can't create preclearance request previous period end is not submitted.");// Common.Common.GetErrorMessage(exp));
                     return View("Index");
                 }
                 else if (nIsPreviousPeriodEndSubmission == 1 && blink == "dashboard")
                 {
                     // check IsUserLogin flag in session, and set flag true -- this will indicate user is login and redirect here for first time 
                     if (!objLoginUserDetails.IsUserLogin)
                     {
                         objLoginUserDetails.IsUserLogin = true;

                         Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                     }

                     objInsiderDashboardModel = new InsiderDashboardModel();

                     using (InsiderDashboardSL objInsiderDashboardSL = new InsiderDashboardSL())
                     {
                         objInsiderDashboardDTO = objInsiderDashboardSL.GetDashboardDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                         Common.Common.CopyObjectPropertyByName(objInsiderDashboardDTO, objInsiderDashboardModel);
                     }

                     using (UserInfoSL objUserInfoSL = new UserInfoSL())
                     {

                         objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                         if (objUserInfoDTO.DateOfBecomingInsider != null)
                         {
                             ViewBag.InsiderTypeUser = 1;
                         }
                         else
                         {
                             ViewBag.InsiderTypeUser = 0;
                         }
                     }
                     ModelState.AddModelError("Error", " You can't create preclearance request previous period end is not submitted.");// Common.Common.GetErrorMessage(exp));
                     return View("~/Views/InsiderDashboard/Index.cshtml", objInsiderDashboardModel);
                 }*/
            //flag to show pre-clearance grid for Insider
            bool show_Insider_pre_clearance_list = false;

            //flag to show check box for security type share when per-clearance for "Cash and/or Cashless partial exercise"
            bool show_exercise_pool_quantity = false;
            bool show_select_pool_quantity_checkbox = false;
            decimal esop_exercise_qty = 0;
            decimal other_esop_exercise_qty = 0;
            ExerciseBalancePoolDTO objExerciseBalancePoolDTO;
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = null;
            int user_id = 0;

            try
            {

                if (CalledFrom == "View")
                {
                    ViewBag.ModeOfAcquisition = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ModeOfAcquisition, null, null, null, null, true);
                    objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                    ViewBag.IsPreClearanceEditable = objImplementedCompanyDTO.IsPreClearanceEditable;
                }

                //    ViewBag.TypeOfSecurityList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, true);
                ViewBag.CompanyList = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, true);

                objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                objPreclearanceRequestModel.CompanyId = objImplementedCompanyDTO.CompanyId;
                objPreclearanceRequestModel.CompanyName = objImplementedCompanyDTO.CompanyName;
                ViewBag.UserTypeCodeId = objLoginUserDetails.UserTypeCodeId;

                //check if new request for pre-clearance or exiting records for pre-clearance by checking pre-clearance request id
                if (PreclearanceRequestId == 0)
                {
                    objPreclearanceRequestModel.PreclearanceRequestForCodeId = Common.ConstEnum.Code.PreclearanceRequestForSelf; //142001;

                    ViewBag.UserInfoRelativeList = FillComboValues(ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString(), null, null, null, null, true);
                    ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);

                    DateTime currentDBDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                    objPreclearanceRequestModel.PreClearanceRequestedDate = currentDBDate;
                    if (objLoginUserDetails.CompanyName == "Infoedge")
                    {
                        objPreclearanceRequestModel.SecuritiesToBeTradedValue = null;
                    }
                    else
                    {
                        objPreclearanceRequestModel.SecuritiesToBeTradedValue = 0;
                    }
                }
                else
                {
                    //get saved pre clearance records details
                    objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, PreclearanceRequestId);

                    //check login user type 
                    if (objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin)
                    {
                        // block for CO and Admin User

                        ViewBag.UserInfoRelativeList = FillComboValues(ConstEnum.ComboType.UserRelativeList, objPreclearanceRequestDTO.UserInfoId.ToString(), null, null, null, null, true);
                        if (objPreclearanceRequestDTO.UserInfoIdRelative != null && objPreclearanceRequestDTO.UserInfoIdRelative > 0)
                        {
                            ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objPreclearanceRequestDTO.UserInfoIdRelative.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);
                        }
                        else
                        {
                            ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objPreclearanceRequestDTO.UserInfoId.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);
                        }
                    }
                    else
                    {
                        // block for Insider User

                        ViewBag.UserInfoRelativeList = FillComboValues(ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString(), null, null, null, null, true);
                        if (objPreclearanceRequestDTO.UserInfoIdRelative != null && objPreclearanceRequestDTO.UserInfoIdRelative > 0)
                        {
                            ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objPreclearanceRequestDTO.UserInfoIdRelative.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);
                        }
                        else
                        {
                            ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objPreclearanceRequestDTO.UserInfoId.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);
                        }
                    }

                    //copy DTO to Model 
                    Common.Common.CopyObjectPropertyByName(objPreclearanceRequestDTO, objPreclearanceRequestModel);
                }

                //check flag which used to show page is edit or view mode
                if (CalledFrom == "Edit")
                {
                    List<PopulateComboDTO> lstPopulateComboDTOProhibited = null; //list of securites not allowed to trade 

                    objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                    //check if trading policy is define for user or not 
                    if (objApplicableTradingPolicyDetailsDTO != null)
                    {
                        //get pre-clearance disclosure limit
                        int PreClrApprovalValidityLimit = objApplicableTradingPolicyDetailsDTO.PreClrApprovalValidityLimit;

                        ArrayList lst = new ArrayList();

                        lst.Add(PreClrApprovalValidityLimit);

                        ViewBag.AlertMessage = Common.Common.getResource("dis_msg_17093", lst);

                        //check pre-clearance need declaration for UPSI 
                        if (objApplicableTradingPolicyDetailsDTO.PreClrSeekDeclarationForUPSIFlag)
                        {
                            if (objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration == null)
                            {
                                objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration = "";
                            }
                            objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration = objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration.Replace(System.Environment.NewLine, "<br/>");
                            ViewBag.PreClrUPSIDeclarationMessage = objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration;
                        }

                        //check non trading flag 
                        if (objApplicableTradingPolicyDetailsDTO.NonTradingPeriodFlag)
                        {
                            lstPopulateComboDTOProhibited = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), null, null, null, false);

                            if (lstPopulateComboDTOProhibited != null && lstPopulateComboDTOProhibited.Count > 0)
                            {
                                ArrayList lstProhibitedTransaction = new ArrayList();

                                string ProhibitedTransaction = String.Join(", ", ((lstPopulateComboDTOProhibited.ConvertAll<string>(d => d.Value).ToArray())));

                                lstProhibitedTransaction.Add(ProhibitedTransaction);

                                lstProhibitedTransaction.Add(Common.Common.ApplyFormatting(objApplicableTradingPolicyDetailsDTO.WindowCloseDate, ConstEnum.DataFormatType.DateTime));
                                lstProhibitedTransaction.Add(Common.Common.ApplyFormatting(objApplicableTradingPolicyDetailsDTO.WindowOpenDate, ConstEnum.DataFormatType.DateTime));

                                ViewBag.NonTradingPeriodFlagMessage = Common.Common.getResource("dis_msg_17330", lstProhibitedTransaction);
                            }
                        }

                        //check pre-clearance disclosure limit 
                        if (PreClrApprovalValidityLimit > 0)
                        {
                            ViewBag.AlertDays = PreClrApprovalValidityLimit;//Common.Common.ApplyFormatting(dtCurrentDate,ConstEnum.DataFormatType.Date);
                        }

                        if (FillComboValues(ConstEnum.ComboType.TransactionTypeByTradingPolicy, objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), InsiderTrading.Common.ConstEnum.Code.PreclearanceRequest.ToString(), null, null, null, true).Count <= 1)
                        {
                            ModelState.AddModelError("Error", @InsiderTrading.Common.Common.getResource("dis_msg_17319"));
                        }
                    }

                    //check list of securites not allowed to trade 
                    if (lstPopulateComboDTOProhibited != null)
                    {
                        List<PopulateComboDTO> lstTransactionList = FillComboValues(ConstEnum.ComboType.TransactionTypeByTradingPolicy, objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), InsiderTrading.Common.ConstEnum.Code.PreclearanceRequest.ToString(), null, null, null, true);

                        //remove securites not allowed to trade from list of securites
                        foreach (var item in lstPopulateComboDTOProhibited)
                        {
                            lstTransactionList.RemoveAll(elem => elem.Key == item.Key);
                        }

                        ViewBag.TransactionList = lstTransactionList;
                    }
                    else
                    {
                        ViewBag.TransactionList = FillComboValues(ConstEnum.ComboType.TransactionTypeByTradingPolicy, objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), InsiderTrading.Common.ConstEnum.Code.PreclearanceRequest.ToString(), null, null, null, true);
                    }

                    TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();

                    //get the date in which trading is blocked
                    BlockedEventDTO objBlockedEventDTO = objTradingWindowEventSL.GetFutureBlockEvent(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID).FirstOrDefault();

                    //check for blocking period
                    if (objBlockedEventDTO != null)
                    {
                        ArrayList lstBlockedPeriodMessage = new ArrayList();

                        lstBlockedPeriodMessage.Add(Common.Common.ApplyFormatting(objBlockedEventDTO.WindowCloseDate, ConstEnum.DataFormatType.Date));
                        lstBlockedPeriodMessage.Add(Common.Common.ApplyFormatting(objBlockedEventDTO.WindowOpenDate, ConstEnum.DataFormatType.Date));

                        ViewBag.BlockedPeriodMessage = Common.Common.getResource("dis_msg_17332", lstBlockedPeriodMessage);
                    }

                    show_Insider_pre_clearance_list = true; //set flag to show insider per clearance list
                }
                else
                {
                    objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, (int)objPreclearanceRequestDTO.UserInfoId, (Int64)objPreclearanceRequestDTO.TransactionMasterId);

                    //check pre-clearance need declaration for UPSI 
                    if (objApplicableTradingPolicyDetailsDTO.PreClrSeekDeclarationForUPSIFlag)
                    {
                        if (objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration == null)
                        {
                            objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration = "";
                        }
                        objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration = objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration.Replace(System.Environment.NewLine, "<br/>");
                        ViewBag.PreClrUPSIDeclarationMessage = objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration;
                    }
                    if ((string.IsNullOrEmpty(objPreclearanceRequestDTO.ReasonForApprovalText)))
                        ViewBag.ApprovalReason = false;
                    else
                        ViewBag.ApprovalReason = true;
                    if ((string.IsNullOrEmpty(objPreclearanceRequestDTO.ReasonForApproval)))
                        ViewBag.ApprovalReasonText = false;
                    else
                        ViewBag.ApprovalReasonText = true;
                    ViewBag.TransactionList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                    ViewBag.TypeOfSecurityList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, true);
                }

                //check for contra trade, if user has to select or not, wheather to use security pool or do not use security pool 
                if (objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool
                    && objImplementedCompanyDTO.ContraTradeOption == InsiderTrading.Common.ConstEnum.Code.ContraTradeQuantiyBase)
                {
                    // set flag to show quantity from pool 
                    show_exercise_pool_quantity = true;

                    try
                    {
                        user_id = (CalledFrom == "Edit") ? objLoginUserDetails.LoggedInUserID : (int)objPreclearanceRequestDTO.UserInfoId;

                        //get security details from pool - for security type - share 
                        objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, user_id, ConstEnum.Code.SecurityTypeShares, Convert.ToInt32(objPreclearanceRequestDTO.DMATDetailsID));

                        if (objExerciseBalancePoolDTO != null)
                        {
                            esop_exercise_qty = objExerciseBalancePoolDTO.ESOPQuantity;
                            other_esop_exercise_qty = objExerciseBalancePoolDTO.OtherQuantity;
                        }
                    }
                    catch (Exception ex)
                    {
                        ModelState.AddModelError("Error", Common.Common.GetErrorMessage(ex));
                        return View("Index");
                    }

                    if (objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade == ConstEnum.Code.UserSelectionOnPreClearanceAndTradeDetailsSubmission)
                    {
                        show_select_pool_quantity_checkbox = true;
                    }
                }

                objPreclearanceRequestModel.UserInfoId = objLoginUserDetails.LoggedInUserID;

                ViewBag.CalledFrom = CalledFrom;
                ViewBag.UserInfoId = objLoginUserDetails.LoggedInUserID;
                ViewBag.UserInfoIdPassDMAT = objLoginUserDetails.LoggedInUserID;

                objPreclearanceRequestModel.DMATDetailsID1 = objPreclearanceRequestDTO.DMATDetailsID;

                ViewBag.acid = acid;

                ViewBag.show_Insider_pre_clearance_list = show_Insider_pre_clearance_list;

                ViewBag.back_link = blink;
                ViewBag.previous_preclearance_id = prevpcid;

                //set to show exercise pool quantiy or not 
                ViewBag.show_exercise_pool_quantity = show_exercise_pool_quantity;

                ViewBag.show_select_pool_quantity_checkbox = show_select_pool_quantity_checkbox;

                ViewBag.esop_exercise_qty = esop_exercise_qty;
                ViewBag.other_esop_exercise_qty = other_esop_exercise_qty;

                ViewBag.Show_Exercise_Pool = 1; // show hide on selection

                return View("Create", objPreclearanceRequestModel);
            }
            catch (Exception exp)
            {
                ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
                ViewBag.EmployeeStatusList = FillComboValues(ConstEnum.ComboType.EmpStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.EmployeeStatus, null, null, null, null, true);
                ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
                ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
                //ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
                ViewBag.Param1 = groupId;
                ViewBag.GroupID = groupId;
                FillGrid(Common.ConstEnum.GridType.ContinousDisclosureStatusList, objLoginUserDetails.LoggedInUserID.ToString(), null, null);
                objUserInfoDTO = objUserInfoSL1.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                ViewBag.PreClearanceRequestID = "";
                ViewBag.PreClearanceRequestStatus = "";
                ViewBag.TradeDetailsID = "";
                if (objUserInfoDTO.DateOfBecomingInsider != null)
                {
                    ViewBag.InsiderTypeUser = 1;
                }
                else
                {
                    ViewBag.InsiderTypeUser = 0;
                }
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Index");
            }
            finally
            {
                objTradingPolicySL = null;
                objPreclearanceRequestModel = null;
                objPreclearanceRequestSL = null;
                objPreclearanceRequestDTO = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
                objImplementedCompanyDTO = null;
                objExerciseBalancePoolDTO = null;
                objApplicableTradingPolicyDetailsDTO = null;
                // objInsiderDashboardModel = null;
                //objInsiderDashboardDTO = null;
                objUserInfoDTO = null;
                objUserInfoSL1 = null;
            }
        }
        #endregion Create New Preclearance

        #region Save Preclearance
        /// <summary>
        /// 
        /// </summary>
        /// <param name="userInfoModel"></param>
        /// <returns></returns>
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult Save(InsiderTrading.Models.PreclearanceRequestModel objPreclearanceRequestModel, string CalledFrom, int acid)
        {
            #region Variable & Object Declaration
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            //flag to show check box for security type share when per-clearance for "Cash and/or Cashless partial exercise"
            bool show_exercise_pool_quantity = false;
            bool show_select_pool_quantity_checkbox = false;
            decimal esop_exercise_qty = 0;
            decimal other_esop_exercise_qty = 0;
            ExerciseBalancePoolDTO objExerciseBalancePoolDTO;
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = null;
            PreclearanceRequestDTO objPreclearanceRequestDTO = new PreclearanceRequestDTO();
            Common.Common objCommon = new Common.Common();
            string sContraTradeDate = string.Empty;
            string sPeriodEnddate = string.Empty;
            string sApproveddate = string.Empty;
            string sPreValiditydate = string.Empty;
            string sProhibitOnPer = string.Empty;
            string sProhibitOnQuantity = string.Empty;
            #endregion Variable & Object Declaration

            #region try
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return Json(new
                    {
                        status = false,
                        msg = ""
                    }, JsonRequestBehavior.AllowGet);
                }
                if (objLoginUserDetails.CompanyName == "Infoedge")
                {
                    if (objPreclearanceRequestModel.SecuritiesToBeTradedValue == 0)
                    {
                        ModelState.AddModelError("PreclearanceRequestModel", "Value proposed to be traded can not be 0");
                    }
                }
                if (objPreclearanceRequestModel.PreclearanceRequestForCodeId == InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestForSelf)
                {
                    objPreclearanceRequestModel.UserInfoIdRelative = null;
                }
                else
                {
                    if (objPreclearanceRequestModel.UserInfoIdRelative == null || objPreclearanceRequestModel.UserInfoIdRelative <= 0)
                    {
                        ModelState.AddModelError("UserInfoIdRelative", "Select User Relative details.");
                    }
                }
                if (!ModelState.IsValid)
                {
                    return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
                }
                Common.Common.CopyObjectPropertyByName(objPreclearanceRequestModel, objPreclearanceRequestDTO);
                objPreclearanceRequestDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                objPreclearanceRequestDTO.UserInfoId = objLoginUserDetails.LoggedInUserID;
                objPreclearanceRequestDTO.PreclearanceStatusCodeId = InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestStatusConfirmed;
                objPreclearanceRequestDTO.PreclearanceNotTakenFlag = false;
                objPreclearanceRequestDTO.DMATDetailsID = objPreclearanceRequestModel.DMATDetailsID1;
                objPreclearanceRequestSL.Save(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestDTO, out sContraTradeDate, out sPeriodEnddate, out sApproveddate, out sPreValiditydate, out sProhibitOnPer, out sProhibitOnQuantity);

                TempData.Remove("SearchArray");
                return Json(new
                {
                    status = true,
                    msg = Common.Common.getResource("dis_btn_17100") //"Preclearance Request Save Successfully"
                });
            }
            #endregion try

            #region catch
            catch (Exception exp)
            {
                if (exp.InnerException.Data[0].ToString() == "dis_msg_17343")
                {
                    objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                    if (objApplicableTradingPolicyDetailsDTO != null)
                    {
                        List<PopulateComboDTO> lstTransactionList = FillComboValues(ConstEnum.ComboType.TransactionTypeByTradingPolicy, objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), InsiderTrading.Common.ConstEnum.Code.PreclearanceRequest.ToString(), null, null, null, false);
                        string stransaction = "";
                        foreach (var TransactionType in lstTransactionList)
                        {
                            if (Convert.ToInt32(TransactionType.Key) == objPreclearanceRequestModel.TransactionTypeCodeId)
                            {
                                stransaction = TransactionType.Value;
                            }
                        }

                        //string TransactionList = String.Join(", ", ((lstTransactionList.ConvertAll<string>(d => d.Value).ToArray())));
                        ArrayList lst = new ArrayList();
                        lst.Add(sContraTradeDate);//objApplicableTradingPolicyDetailsDTO.GenContraTradeNotAllowedLimit);
                        lst.Add(stransaction);
                        ModelState.AddModelError("Error", Common.Common.getResource("dis_msg_17343", lst));
                    }

                    //check for contra trade, if user has to select or not, wheather to use security pool or do not use security pool 
                    if (objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool)
                    {
                        // set flag to show quantity from pool 
                        show_exercise_pool_quantity = true;
                        try
                        {
                            //get security details from pool - for security type - share 
                            objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, ConstEnum.Code.SecurityTypeShares, Convert.ToInt32(objPreclearanceRequestModel.DMATDetailsID1));

                            if (objExerciseBalancePoolDTO != null)
                            {
                                esop_exercise_qty = objExerciseBalancePoolDTO.ESOPQuantity;
                                other_esop_exercise_qty = objExerciseBalancePoolDTO.OtherQuantity;
                            }
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }

                        if (objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade == ConstEnum.Code.UserSelectionOnPreClearanceAndTradeDetailsSubmission)
                        {
                            show_select_pool_quantity_checkbox = true;
                        }
                    }
                    //set to show exercise pool quantiy or not 
                    ViewBag.show_exercise_pool_quantity = show_exercise_pool_quantity;
                    ViewBag.show_select_pool_quantity_checkbox = show_select_pool_quantity_checkbox;
                    ViewBag.esop_exercise_qty = esop_exercise_qty;
                    ViewBag.other_esop_exercise_qty = other_esop_exercise_qty;
                    ViewBag.Show_Exercise_Pool = 1; // show hide on selection
                }
                else
                {
                    string alertMsg = Common.Common.GetErrorMessage(exp);
                    if (!string.IsNullOrEmpty(sPeriodEnddate))
                    {
                        DateTime dtEndDate = Convert.ToDateTime(sPeriodEnddate);
                        dtEndDate = Convert.ToDateTime(dtEndDate.AddDays(1));
                        alertMsg = alertMsg.Replace("$2", sPeriodEnddate);
                        alertMsg = alertMsg.Replace("$3", String.Format("{0:dd/MM/yyyy}", dtEndDate));
                    }
                    if (!string.IsNullOrEmpty(sApproveddate))
                    {
                        alertMsg = alertMsg.Replace("$1", sApproveddate);
                    }
                    if (!string.IsNullOrEmpty(sPreValiditydate))
                    {
                        alertMsg = alertMsg.Replace("$4", sPreValiditydate);
                    }
                    alertMsg = alertMsg.Replace("$5", sProhibitOnPer);
                    alertMsg = alertMsg.Replace("$6", sProhibitOnQuantity);
                    ModelState.AddModelError("Error", alertMsg);
                }
                return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
            }
            #endregion catch

            #region finally
            finally
            {
                ViewBag.TransactionList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                ViewBag.CompanyList = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, true);
                ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);
                if (objPreclearanceRequestModel.UserInfoIdRelative != null && objPreclearanceRequestModel.UserInfoIdRelative > 0)
                {
                    ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objPreclearanceRequestModel.UserInfoIdRelative.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);
                }
                else
                {
                    ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);

                }
                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                if (CalledFrom == "View")
                {
                    ViewBag.TypeOfSecurityList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, true);
                }
                else
                {
                    ViewBag.TypeOfSecurityList = FillComboValues(InsiderTrading.Common.ConstEnum.ComboType.ListofSecurityTypeapplicableTradingPolicy, objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), objPreclearanceRequestModel.TransactionTypeCodeId.ToString(), null, null, null, true);
                }
                objLoginUserDetails = null;
                objTradingPolicySL = null;
                objPreclearanceRequestSL = null;
                objExerciseBalancePoolDTO = null;
                objApplicableTradingPolicyDetailsDTO = null;
                objPreclearanceRequestDTO = null;
            }
            #endregion finally

        }
        #endregion Save Preclearance

        #region NSEProceedButton

        //public ActionResult SaveGroupDetails(int rowNum)
        //{


        //    List<GetPendingEmployees> pendingEmplst = (List<GetPendingEmployees>)Session["pendingEmplst"];
        //    var empDetails = pendingEmplst.Find(l => l.RowNum == rowNum);
        //    if (rowNum != 0)
        //    {
        //        LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
        //        using (NSEGroupSL objNSEGroupSL = new NSEGroupSL())
        //        {
        //            NSEGroupDetailsDTO objNSEGroupDetailsDTO = new NSEGroupDetailsDTO();
        //            objNSEGroupDetailsDTO.UserInfoId = empDetails.UserInfoId;
        //            objNSEGroupDetailsDTO.TransactionMasterId = empDetails.TransactionMasterID;
        //            objNSEGroupDetailsDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
        //            objNSEGroupDetailsDTO.GroupId = Convert.ToInt32(TempData["GroupId"].ToString());
        //            List<NSEGroupDetailsDTO> GrouplistDetails = objNSEGroupSL.Save_NSEGroup_Details(objLoginUserDetails.CompanyDBConnectionString, objNSEGroupDetailsDTO);
        //            foreach (var Grpdt in GrouplistDetails)
        //                TempData["NseGroupdetailsId"] = Grpdt.NSEGroupDetailsId;
        //            //TempData["Name"] = empDetails.Name;
        //            //TempData["rowNum"] = (empDetails.RowNum) - 1;                                                
        //            //Session["Counter"] = Convert.ToInt32(Session["Counter"]) + 1;                    
        //            //TempData["NseDownloadFlag"] = 1;
        //            //TempData["NseDownloadFlag1"] = 1;                    
        //            //pendingEmplst.RemoveAll(l => l.RowNum == rowNum);
        //            //Session["pendingEmplst"] = pendingEmplst;                    
        //            //return RedirectToAction("ViewLetter", "TradingTransaction", new { nTransactionMasterId = empDetails.TransactionMasterID, nDisclosureTypeCodeId = ConstEnum.Code.DisclosureTypeContinuous, nLetterForCodeId = ConstEnum.Code.DisclosureLetterUserInsider, acid = Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION });
        //        }
        //    }
        //    Session["Counter"] = null;            
        //    return RedirectToAction("Index", "NSEDownload", new { acid = Common.ConstEnum.UserActions.NSEDownload });
        //}

        //public ActionResult SaveGroupDetails(int rowNum)
        //{
        //    TempData["NseDownloadFlag"] = 0;
        //    TempData["NseDownloadFlag1"] = 0;
        //    TempData["Name"] = null;
        //    NSEGroupSL objNSEGroupSL = new NSEGroupSL();
        //    LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
        //    NSEGroupDTO objNSEGroupDTO = new NSEGroupDTO();
        //    NSEGroupDetailsDTO objNSEGroupDetailsDTO = new NSEGroupDetailsDTO();
        //    try
        //    {
        //        objNSEGroupDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
        //        int out_iTotalRecords = 0;
        //        PreclearanceRequestSL ObjPreclearanceRequest = new PreclearanceRequestSL();

        //        List<GetPendingEmployees> list = ObjPreclearanceRequest.Get_PendingEmployees(objLoginUserDetails.CompanyDBConnectionString, 114049, 0, 0,
        //                       null, null, out  out_iTotalRecords, null, null, null, null, null, null, null,
        //                       null, null, null, null, null, null, null, null, null, null, null, null, "154002", null,
        //                       null, null, null, null, null, null, null, null, null, null,
        //                       null, null, null,
        //                       null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
        //                      null, null);

        //        foreach (var Emp in list)
        //        {
        //            if (Emp.RowNum < rowNum || rowNum == 0)
        //            {
        //                int NseGroupdetailsId = 0;
        //                objNSEGroupDetailsDTO.UserInfoId = Emp.UserInfoId;
        //                objNSEGroupDetailsDTO.TransactionMasterId = Emp.TransactionMasterID;
        //                objNSEGroupDetailsDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
        //                objNSEGroupDetailsDTO.GroupId = Convert.ToInt32(TempData["GroupId"].ToString());

        //                List<NSEGroupDetailsDTO> GrouplistDetails = objNSEGroupSL.Save_NSEGroup_Details(objLoginUserDetails.CompanyDBConnectionString, objNSEGroupDetailsDTO);

        //                foreach (var Grpdt in GrouplistDetails)
        //                {
        //                    TempData["NseGroupdetailsId"] = Grpdt.NSEGroupDetailsId;
        //                }
        //                int nLetterForCodeId = ConstEnum.Code.DisclosureLetterUserInsider;
        //                int nDisclosureTypeCodeId = ConstEnum.Code.DisclosureTypeContinuous;
        //                int year = 0;
        //                int nTransactionMasterId = Emp.TransactionMasterID;
        //                TempData["Name"] = Emp.Name;
        //                int nTransactionLetterId = 0;
        //                int pdtypeId = 0;
        //                int period = 0;
        //                string pdtype = string.Empty;
        //                TemplateMasterDTO objTemplateMasterDTO = null;
        //                TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
        //                UserInfoDTO objUserInfoDTO = null;
        //                TempData["rowNum"] = Emp.RowNum;
        //                Session["Counter"] = Convert.ToInt32(Session["Counter"]) + 1;

        //                int acid = Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION;
        //                TempData["NseDownloadFlag"] = 1;
        //                TempData["NseDownloadFlag1"] = 1;
        //                return RedirectToAction("ViewLetter", "TradingTransaction", new { nTransactionMasterId, nDisclosureTypeCodeId, nLetterForCodeId, acid, nTransactionLetterId = 0, year = 0, period = 0, pdtypeId, pdtype });
        //            }
        //        }
        //        Session["Counter"] = null;
        //        //Session.Remove("Counter");
        //        return RedirectToAction("Index", "NSEDownload", new { acid = Common.ConstEnum.UserActions.NSEDownload });
        //    }
        //    catch (Exception exp)
        //    {
        //        return View();
        //    }
        //    finally
        //    {
        //        objNSEGroupSL = null;
        //        objLoginUserDetails = null;
        //        objNSEGroupDTO = null;
        //    }
        //}


        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult SaveNSEGroup1(int acid, FormCollection form)
        {
            TempData.Remove("SearchArray");
            var ErrorDictionary = new Dictionary<string, string>();
            int out_iTotalRecords = 0;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            int GroupId = 0;
            string HiddenInput = form["SPName"];
            int typeOfDownload = Convert.ToInt32(HiddenInput);
            string directory = ConfigurationManager.AppSettings["Document"];
            DirectoryInfo di;
            try
            {
                using (NSEGroupSL objNSEGroupSL = new NSEGroupSL())
                {
                    NSEGroupDTO objNSEGroupDTO = new NSEGroupDTO();
                    NSEGroupDetailsDTO objNSEGroupDetailsDTO = new NSEGroupDetailsDTO();

                    objNSEGroupDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    objNSEGroupDTO.TypeOfDownload = typeOfDownload;
                    List<NSEGroupDTO> grList = objNSEGroupSL.Save_New_NSEGroup(objLoginUserDetails.CompanyDBConnectionString, objNSEGroupDTO);
                    foreach (var grpId in grList)
                        GroupId = grpId.GroupId;

                    ViewBag.GroupId = GroupId;
                    objNSEGroupDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                }
                using (PreclearanceRequestSL ObjPreclearanceRequest = new PreclearanceRequestSL())
                {
                    List<GetPendingEmployees> list = ObjPreclearanceRequest.Get_PendingEmployees(objLoginUserDetails.CompanyDBConnectionString, 114049, 0, 0,
                                   null, null, out  out_iTotalRecords, null, null, null, null, null, null, null,
                                   null, null, null, null, null, null, null, null, null, null, null, null, "154002", null,
                                   null, null, null, null, null, null, null, null, null, null,
                                   null, null, null,
                                   null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
                                  null, null);

                    int totCount = list.Count();
                    if (!Directory.Exists(Path.Combine(directory, ConstEnum.Code.NseDocumentFormC.ToString(), GroupId.ToString())))
                        di = Directory.CreateDirectory(Path.Combine(directory, objLoginUserDetails.CompanyName, ConstEnum.Code.NseDocumentFormC.ToString(), GroupId.ToString()));

                    string OutputPathWithFileName = Path.Combine(directory, objLoginUserDetails.CompanyName, ConstEnum.Code.NseDocumentFormC.ToString(), GroupId.ToString());
                    for (int rowNum = 0; rowNum <= totCount; rowNum++)
                    {
                        var empDetails = list.Find(l => l.RowNum == rowNum);
                        int grDetlsId = 0;
                        if (rowNum != 0)
                        {
                            using (NSEGroupSL objNSEGroupSL = new NSEGroupSL())
                            {
                                NSEGroupDetailsDTO objNSEGroupDetailsDTO = new NSEGroupDetailsDTO();
                                NSEGroupDocumentMappingDTO objNSEGroupDocDTO = new NSEGroupDocumentMappingDTO();
                                objNSEGroupDetailsDTO.UserInfoId = empDetails.UserInfoId;
                                objNSEGroupDetailsDTO.TransactionMasterId = empDetails.TransactionMasterID;
                                objNSEGroupDetailsDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                                objNSEGroupDetailsDTO.GroupId = GroupId;
                                List<InsiderTradingDAL.NSEGroupDocumentMappingDTO> getDocList = objNSEGroupSL.Get_Singledocument_Details(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objNSEGroupDetailsDTO.TransactionMasterId));
                                string sGUID = getDocList.Find(d => d.MapToId == empDetails.TransactionMasterID).GUID.ToString();
                                List<NSEGroupDetailsDTO> grouplistDetails = objNSEGroupSL.Save_NSEGroup_Details(objLoginUserDetails.CompanyDBConnectionString, objNSEGroupDetailsDTO);
                                foreach (var grpDtlsId in grouplistDetails)
                                    grDetlsId = grpDtlsId.NSEGroupDetailsId;

                                objNSEGroupDocDTO.NSEGroupDetailsId = grDetlsId;
                                objNSEGroupDocDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;

                                bool bReturn = objNSEGroupSL.Save_New_NSEDocument(objLoginUserDetails.CompanyDBConnectionString, objNSEGroupDocDTO, Convert.ToString(sGUID.ToString()));
                                string sourceFileNameWithPath = Path.Combine(directory, objLoginUserDetails.CompanyName, ConstEnum.Code.NseDocumentFormC.ToString(), objNSEGroupDetailsDTO.TransactionMasterId.ToString(), Convert.ToString(sGUID.ToString()));
                                FileInfo file = new FileInfo(Path.Combine(directory, objLoginUserDetails.CompanyName, ConstEnum.Code.NseDocumentFormC.ToString(), objNSEGroupDetailsDTO.TransactionMasterId.ToString(), sGUID));
                                if (file.Exists)
                                {
                                    System.IO.File.Move(sourceFileNameWithPath, OutputPathWithFileName + "//" + sGUID);
                                }
                            }
                        }
                    }
                }
                return RedirectToAction("Index", "NSEDownload", new { acid = Common.ConstEnum.UserActions.NSEDownload });
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("ListByCO");
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion NSEProceedButton

        public ActionResult ViewPdf(string LetterStatus)
        {
            DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();
            List<DocumentDetailsModel> lstDocumentDetailsModel = new List<DocumentDetailsModel>();
            DocumentDetailsModel objDocumentDetailsModel = new DocumentDetailsModel();
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                string directory = ConfigurationManager.AppSettings["Document"];
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                DirectoryInfo di;
                Byte[] bytes;
                //Create a stream that we can write to, in this case a MemoryStream
                var ms = new MemoryStream();

                if (!Directory.Exists(Path.Combine(directory, ConstEnum.Code.NseDocumentFormC.ToString(), Convert.ToInt32(TempData["transId"]).ToString())))
                    di = Directory.CreateDirectory(Path.Combine(directory, Convert.ToString(objLoginUserDetails.CompanyName), ConstEnum.Code.NseDocumentFormC.ToString(), Convert.ToInt32(TempData["transId"]).ToString()));

                string LetterHTMLContent = Convert.ToString(TempData["LetterHTMLContent"]);
                string FormHTMLContent = Convert.ToString(TempData["FormHTMLContent"]);

                string path = Path.Combine(directory, Convert.ToString(objLoginUserDetails.CompanyName), ConstEnum.Code.NseDocumentFormC.ToString(), Convert.ToInt32(TempData["transId"]).ToString());
                string newFileName = Guid.NewGuid() + ".pdf";

                //Create an iTextSharp Document which is an abstraction of a PDF but **NOT** a PDF
                var doc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);

                Regex rRemScript = new Regex(@"<script[^>]*>[\s\S]*?</script>");
                LetterHTMLContent = rRemScript.Replace(LetterHTMLContent, "");
                FormHTMLContent = rRemScript.Replace(FormHTMLContent, "");

                FormHTMLContent = FormHTMLContent.Replace("Processing...", " ");

                Regex rReplaceScript = new Regex(@"<br>");
                LetterHTMLContent = rReplaceScript.Replace(LetterHTMLContent, "<br />");
                FormHTMLContent = rReplaceScript.Replace(FormHTMLContent, "<br />");

                string re1 = "(style)";
                string re2 = "(=)";
                string re3 = "(\"\")";
                Regex rReplaceStyle = new Regex(re1 + re2 + re3);
                FormHTMLContent = rReplaceStyle.Replace(FormHTMLContent, "style=\"border:1px solid black;border-spacing:0px;text-align:center\" ");

                Regex rReplaceImg = new Regex(@"<img[^>]*>");
                FormHTMLContent = rReplaceImg.Replace(FormHTMLContent, "<img src=\"" + Request.Url.Scheme + "://" + Request.Url.Authority + "/" + System.Reflection.Assembly.GetExecutingAssembly().GetName().Name + "/images/Logos/" + ((InsiderTrading.Common.LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails)).CompanyName + "/" + ((InsiderTrading.Common.LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails)).CompanyName + "_190X51.jpg" + "\"></img>");

                var ImageUrl = objLoginUserDetails.CompanyLogoURL;

                var writer = PdfWriter.GetInstance(doc, Response.OutputStream);

                writer = PdfWriter.GetInstance(doc, ms);
                doc.Open();
                doc.NewPage();
                if (LetterStatus == "True")
                {
                    var msCss = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent));

                    var msHtml = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent));

                    iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, msHtml, msCss);
                }
                doc.SetPageSize(PageSize.A4.Rotate());
                doc.NewPage();

                var msCss1 = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(FormHTMLContent));

                var msHtml1 = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(FormHTMLContent));
                //Parse the HTML
                iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, msHtml1, msCss1);
                doc.Close();
                //close the MemoryStream, grab all of the active bytes from the stream
                bytes = ms.ToArray();

                var fileUploadPath = path + "\\" + newFileName;
                System.IO.File.WriteAllBytes(fileUploadPath, bytes);

                var ErrorDictionary = new Dictionary<string, string>();

                objDocumentDetailsModel.MapToTypeCodeId = ConstEnum.Code.NseDocumentFormC;
                objDocumentDetailsModel.MapToId = Convert.ToInt32(TempData["transId"]);
                objDocumentDetailsModel.DocumentId = 0;
                objDocumentDetailsModel.GUID = newFileName;
                objDocumentDetailsModel.DocumentName = objLoginUserDetails.FirstName + " " + objLoginUserDetails.LastName;
                objDocumentDetailsModel.Description = string.Empty;
                objDocumentDetailsModel.DocumentPath = path + "\\" + newFileName;
                objDocumentDetailsModel.FileSize = 1325;
                objDocumentDetailsModel.FileType = ".pdf";
                lstDocumentDetailsModel.Add(objDocumentDetailsModel);

                using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                {
                    lstDocumentDetailsModel = objDocumentDetailsSL.SaveFormGDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, lstDocumentDetailsModel, ConstEnum.Code.NseDocumentFormC, Convert.ToInt32(TempData["transId"]), objLoginUserDetails.LoggedInUserID);
                }
                TempData["NseDownloadFlag1"] = 0;

                if (objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType)
                    return RedirectToAction("ListByCO", "PreclearanceRequest", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17346"));
                else
                    return RedirectToAction("ViewLetter", "TradingTransaction", new { nTransactionMasterId = Convert.ToInt32(TempData["transId"]), nDisclosureTypeCodeId = ConstEnum.Code.DisclosureTypeContinuous, nLetterForCodeId = ConstEnum.Code.DisclosureLetterUserInsider, acid = Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION });

            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("ListByCO");
            }
            finally
            {
                objDocumentDetailsDTO = null;
                objLoginUserDetails = null;
            }
        }

        private object GetXmlReader(string resultCache)
        {
            throw new NotImplementedException();
        }

        #region PreClearance Not Taken Action
        /// <summary>
        /// This method is used for the When PNT
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult PreClearanceNotTakenAction(int acid, string from = "")
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL();
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = null;
            try
            {
                if (from != "FromTrans")
                {
                    int localApprovedPCLCnt = 0;
                    List<ApprovedPCLDTO> lstApprovedPCLCnt = objTradingTransactionSL.GetApprovedPCLCntSL(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    foreach (var ApprovedPCLCnt in lstApprovedPCLCnt)
                    {
                        localApprovedPCLCnt = ApprovedPCLCnt.ApprovedPCLCnt;
                    }
                    if (localApprovedPCLCnt != 0)
                    {
                        return RedirectToAction("Index", "PreclearanceRequest", new { acid = (objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType) ? InsiderTrading.Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE : InsiderTrading.Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE , IsApprovedPCL = "FromTrans" });
                    }
                }

                TradingTransactionMasterDTO objTradingTransactionMasterDTO = new TradingTransactionMasterDTO();
                objTradingTransactionMasterDTO.TransactionMasterId = 0;
                objTradingTransactionMasterDTO.PreclearanceRequestId = null;
                objTradingTransactionMasterDTO.UserInfoId = objLoginUserDetails.LoggedInUserID;
                objTradingTransactionMasterDTO.DisclosureTypeCodeId = Common.ConstEnum.Code.DisclosureTypeContinuous;//147002;
                objTradingTransactionMasterDTO.TransactionStatusCodeId = Common.ConstEnum.Code.DisclosureStatusForNotConfirmed;// 148002;
                objTradingTransactionMasterDTO.NoHoldingFlag = false;
                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                objTradingTransactionMasterDTO.TradingPolicyId = objApplicableTradingPolicyDetailsDTO.TradingPolicyId;
                objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);
                return RedirectToAction("Index", "TradingTransaction", new { TransactionMasterId = objTradingTransactionMasterDTO.TransactionMasterId, acid = Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE, frm = from });
            }
            catch (Exception exp)
            {
                ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
                ViewBag.EmployeeStatusList = FillComboValues(ConstEnum.ComboType.EmpStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.EmployeeStatus, null, null, null, null, true);
                ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
                ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
                //   ViewBag.UserInfoRelativeList = FillComboValues(ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString(), null, null, null, null, true);
                //ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
                ViewBag.Param1 = groupId;

                FillGrid(Common.ConstEnum.GridType.ContinousDisclosureStatusList, objLoginUserDetails.LoggedInUserID.ToString(), null, null);
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Index");
            }
            finally
            {
                objLoginUserDetails = null;
                objTradingPolicySL = null;
                objTradingTransactionSL = null;
                objApplicableTradingPolicyDetailsDTO = null;
            }
        }
        #endregion PreClearance Not Taken Action

        #region Relative Drop Down Change Event
        /// <summary>
        /// This method call when relative drop down change value.
        /// </summary>
        /// <param name="objPreclearanceRequestModel"></param>
        /// <returns></returns>
        public ActionResult UserInfoIdRelativeChange(PreclearanceRequestModel objPreclearanceRequestModel)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ViewBag.UserTypeCodeId = objLoginUserDetails.UserTypeCodeId;
            try
            {
                if (objPreclearanceRequestModel.UserInfoIdRelative != null && objPreclearanceRequestModel.UserInfoIdRelative > 0)
                {
                    ViewBag.UserInfoIdPassDMAT = objPreclearanceRequestModel.UserInfoIdRelative;
                    ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objPreclearanceRequestModel.UserInfoIdRelative.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);
                }
                else
                {
                    ViewBag.UserInfoId = objPreclearanceRequestModel.UserInfoId;
                    ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);

                }
                if (ModelState.ContainsKey("DMATDetailsID1"))
                    ModelState["DMATDetailsID1"].Errors.Clear();
                return PartialView("_DEMATList", objPreclearanceRequestModel);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Create", objPreclearanceRequestModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion Relative Drop Down Change Event

        #region Preclearance Type Change Event
        /// <summary>
        /// 
        /// </summary>
        /// <param name="objPreclearanceRequestModel"></param>
        /// <returns></returns>
        public ActionResult LoadRelative(PreclearanceRequestModel objPreclearanceRequestModel)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                if (objPreclearanceRequestModel.PreclearanceRequestForCodeId == InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestForRelative)
                {
                    ViewBag.UserInfoRelativeList = FillComboValues(ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString(), null, null, null, null, true);
                }
                else
                {
                    ViewBag.UserInfoId = objPreclearanceRequestModel.UserInfoId;
                    ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);

                }
                return PartialView("_RelativeDetails", objPreclearanceRequestModel);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Create", objPreclearanceRequestModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion Preclearance Type Change Event

        #region loadDMAT
        /// <summary>
        /// 
        /// </summary>
        /// <param name="objPreclearanceRequestModel"></param>
        /// <returns></returns>
        public ActionResult loadDMAT(PreclearanceRequestModel objPreclearanceRequestModel)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                if (objPreclearanceRequestModel.UserInfoIdRelative != null && objPreclearanceRequestModel.UserInfoIdRelative > 0)
                {
                    ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objPreclearanceRequestModel.UserInfoIdRelative.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);
                }
                else
                {
                    ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);

                }
                return PartialView("_DEMATList", objPreclearanceRequestModel);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Create", objPreclearanceRequestModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion loadDMAT

        #region LoadSecurityType Partial View
        public ActionResult LoadSecurityType(PreclearanceRequestModel objPreclearanceRequestModel, string CalledFrom)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
            try
            {
                if (CalledFrom == "View")
                {
                    ViewBag.TypeOfSecurityList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, true);
                }
                else
                {
                    ViewBag.TypeOfSecurityList = FillComboValues(InsiderTrading.Common.ConstEnum.ComboType.ListofSecurityTypeapplicableTradingPolicy, objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), objPreclearanceRequestModel.TransactionTypeCodeId.ToString(), null, null, null, true);
                }
                if (ModelState.ContainsKey("SecurityTypeCodeId"))
                    ModelState["SecurityTypeCodeId"].Errors.Clear();
                return PartialView("SecurityTypeDetails", objPreclearanceRequestModel);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Create", objPreclearanceRequestModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objTradingPolicySL = null;
                objApplicableTradingPolicyDetailsDTO = null;
            }
        }
        #endregion LoadSecurityType Partial View

        #region LoadModeOfAquisition
        public ActionResult LoadModeOfAquisition(PreclearanceRequestModel objPreclearanceRequestModel, string CalledFrom)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

            try
            {
                if (CalledFrom == "View")
                {
                    ViewBag.ModeOfAcquisition = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ModeOfAcquisition, null, null, null, null, true);
                }
                else
                {
                    ViewBag.ModeOfAcquisition = FillComboValues(InsiderTrading.Common.ConstEnum.ComboType.ListofModeOfAcquisitionapplicableTradingPolicy, objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), objPreclearanceRequestModel.TransactionTypeCodeId.ToString(), objPreclearanceRequestModel.SecurityTypeCodeId.ToString(), null, null, true);
                }
                if (ModelState.ContainsKey("ModeOfAcquisitionCodeId"))
                    ModelState["ModeOfAcquisitionCodeId"].Errors.Clear();
                return PartialView("ModeOfAcqisition", objPreclearanceRequestModel);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Create", objPreclearanceRequestModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objTradingPolicySL = null;
                objApplicableTradingPolicyDetailsDTO = null;
            }
        }
        #endregion LoadModeOfAquisition

        #region LoadBalanceDMATwise
        public ActionResult LoadBalanceDMATwise(PreclearanceRequestModel objPreclearanceRequestModel, string CalledFrom)
        {
            ExerciseBalancePoolDTO objExerciseBalancePoolDTO = null;
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = new ApplicableTradingPolicyDetailsDTO();
            CompaniesSL objCompaniesSL = new CompaniesSL();
            //flag to show check box for security type share when per-clearance for "Cash and/or Cashless partial exercise"
            bool show_exercise_pool_quantity = false;
            bool show_select_pool_quantity_checkbox = false;
            decimal esop_exercise_qty = 0;
            decimal other_esop_exercise_qty = 0;
            try
            {
                ImplementedCompanyDTO objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                //check for contra trade, if user has to select or not, wheather to use security pool or do not use security pool 
                if (objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool
                    && objImplementedCompanyDTO.ContraTradeOption == InsiderTrading.Common.ConstEnum.Code.ContraTradeQuantiyBase)
                {
                    // set flag to show quantity from pool 
                    show_exercise_pool_quantity = true;

                    try
                    {
                        objPreclearanceRequestModel.UserInfoId = (CalledFrom == "Edit") ? objLoginUserDetails.LoggedInUserID : (int)objPreclearanceRequestModel.UserInfoId;

                        //get security details from pool - for security type - share 
                        objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, ConstEnum.Code.SecurityTypeShares, Convert.ToInt32(objPreclearanceRequestModel.DMATDetailsID1));

                        if (objExerciseBalancePoolDTO != null)
                        {
                            esop_exercise_qty = objExerciseBalancePoolDTO.ESOPQuantity;
                            other_esop_exercise_qty = objExerciseBalancePoolDTO.OtherQuantity;
                        }
                    }
                    catch (Exception ex)
                    {
                        ModelState.AddModelError("Error", Common.Common.GetErrorMessage(ex));
                        return View("Create", objPreclearanceRequestModel);
                    }

                    if (objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade == ConstEnum.Code.UserSelectionOnPreClearanceAndTradeDetailsSubmission)
                    {
                        show_select_pool_quantity_checkbox = true;
                    }
                }
                //set to show exercise pool quantiy or not 
                ViewBag.show_exercise_pool_quantity = show_exercise_pool_quantity;

                ViewBag.show_select_pool_quantity_checkbox = show_select_pool_quantity_checkbox;

                ViewBag.esop_exercise_qty = esop_exercise_qty;
                ViewBag.other_esop_exercise_qty = other_esop_exercise_qty;

                ViewBag.Show_Exercise_Pool = 1; // show hide on selection
                ViewBag.CalledFrom = CalledFrom;
            }
            catch (Exception exp)
            {

            }

            return PartialView("_DMATwiseBalance", objPreclearanceRequestModel);
            //return Json(new
            //{
            //    esop_exercise_qty = esop_exercise_qty,
            //    other_esop_exercise_qty = other_esop_exercise_qty,//objTradingPolicyModel.TradingPolicyName + InsiderTrading.Common.Common.getResource("rul_msg_15374"),//" Save Successfully",

            //});
        }
        #endregion LoadBalanceDMATwise

        #endregion Insider All Action & Methods

        #region  CO All Action & Methods

        #region CO List
        /// <summary>
        /// 
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult ListByCO(int acid, int GroupId = 0, int TransactionMasterID = 0, int SecurityTypeId = 0, string TransactionDate = null, int TransactionTypeId = 0, int UserId = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ViewBag.User = objLoginUserDetails.UserTypeCodeId;
            string chk_User = Convert.ToString(ViewBag.User);

            ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
            ViewBag.EmployeeStatusList = FillComboValues(ConstEnum.ComboType.EmpStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.EmployeeStatus, null, null, null, null, true);
            ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
            ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
            ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
            ViewBag.StockExchangeStatusList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, "IP", chk_User, true);
            ViewBag.NSEDownloadOptionsList = FillComboValues(ConstEnum.ComboType.NSEdownloadEventList, InsiderTrading.Common.ConstEnum.CodeGroup.NSEDownloadOptions, null, null, null, null, true);
            ViewBag.User = objLoginUserDetails.UserTypeCodeId;
            ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            ViewBag.GroupID = GroupId;
            ViewBag.UserAction = acid;
            ViewBag.TransactionMasterId = TransactionMasterID;
            ViewBag.SecurityTypeId = SecurityTypeId;
            ViewBag.TransactionDate = TransactionDate;
            ViewBag.TransactionTypeId = TransactionTypeId;
            ViewBag.UserID = UserId;
            TempData.Remove("DuplicateTransaction");
            TempData.Remove("TradingTransactionModel");
            if (TransactionMasterID != 0 || SecurityTypeId != 0)
            {
                TempData.Remove("SearchArray");
            }
            FillGrid(Common.ConstEnum.GridType.ContinuousDisclosureListForCO, "0", null, null);

            if (objLoginUserDetails.LoggedInUserID == 1)
            {
                ViewBag.COUserType = 0;
            }
            else
            {
                ViewBag.COUserType = 1;
            }

            PreclearanceRequestSL ObjPreclearanceRequest = new PreclearanceRequestSL();
            int out_iTotalRecords = 0;
            List<GetPendingEmployees> pendEmpLst = ObjPreclearanceRequest.Get_PendingEmployees(objLoginUserDetails.CompanyDBConnectionString, 114049, 0, 0,
                           null, null, out  out_iTotalRecords, null, null, null, null, null, null, null,
                           null, null, null, null, null, null, null, null, null, null, null, null, "154002", null,
                           null, null, null, null, null, null, null, null, null, null,
                           null, null, null,
                           null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
                          null, null);
            if (pendEmpLst.Count > 0)
                ViewBag.pendingEmpList = 1;
            return View("ListByCO");
        }
        #endregion CO List

        #region ApproveRejectAction
        //[AuthorizationPrivilegeFilter]
        /// <summary>
        /// 
        /// </summary>
        /// <param name="PreclearanceRequestId"></param>
        /// <param name="blink"></param>
        /// <param name="prevpcid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult ApproveRejectAction(long PreclearanceRequestId, int acid, string blink = "", int prevpcid = 0)
        {
            #region Variable & Object declaration
            //flag to show pre-clearance grid for CO
            bool show_CO_pre_clearance_list = false;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ViewBag.UserTypeCode = objLoginUserDetails.UserTypeCodeId;
            TradingPolicySL objTradingPolicySL = null;
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = null;
            ExerciseBalancePoolDTO objExerciseBalancePoolDTO;
            //flag to show check box for security type share when per-clearance for "Cash and/or Cashless partial exercise"
            bool show_exercise_pool_quantity = false;
            bool show_select_pool_quantity_checkbox = false;
            decimal esop_exercise_qty = 0;
            decimal other_esop_exercise_qty = 0;
            PreclearanceRequestModel objPreclearanceRequestModel = new PreclearanceRequestModel();
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            PreclearanceRequestDTO objPreclearanceRequestDTO = new PreclearanceRequestDTO();
            CompaniesSL objCompaniesSL = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            ViewBag.Show_CO_PreclearanceEditablePanel = false;
            #endregion  Variable & Object declaration

            #region try
            try
            {
                objTradingPolicySL = new TradingPolicySL();
                objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, PreclearanceRequestId);
                Common.Common.CopyObjectPropertyByName(objPreclearanceRequestDTO, objPreclearanceRequestModel);
                ViewBag.IsReject = false;
                ViewBag.IsApprove = false;
                ViewBag.IsPanelActive = false;
                //check if page is called from previous pre-clearance request grid in that case do not show pre clearance list 
                if (blink == "" || blink != "preclereq")
                {
                    show_CO_pre_clearance_list = true; //set flag to show CO per clearance list
                }
                ViewBag.show_CO_pre_clearance_list = show_CO_pre_clearance_list;
                ViewBag.back_link = blink;
                ViewBag.previous_preclearance_id = prevpcid;
                if (objPreclearanceRequestDTO.ContraTradePeriod != null)
                {
                    ArrayList lst = new ArrayList();
                    lst.Add(objPreclearanceRequestDTO.ContraTradePeriod);
                    ViewBag.contra_trade_period = lst;
                }
                objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, (int)objPreclearanceRequestDTO.UserInfoId, (Int64)objPreclearanceRequestDTO.TransactionMasterId);
                if (objImplementedCompanyDTO.ContraTradeOption == ConstEnum.Code.ContraTradeQuantiyBase)
                {
                    //check for contra trade, if user has to select or not, wheather to use security pool or do not use security pool 
                    if (objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool &&
                        (int)objPreclearanceRequestDTO.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeShares
                        )
                    {
                        // set flag to show quantity from pool 
                        show_exercise_pool_quantity = true;
                        try
                        {
                            //get security details from pool - for security type - share 
                            objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, (int)objPreclearanceRequestDTO.UserInfoId, ConstEnum.Code.SecurityTypeShares, Convert.ToInt32(objPreclearanceRequestDTO.DMATDetailsID));

                            if (objExerciseBalancePoolDTO != null)
                            {
                                esop_exercise_qty = objExerciseBalancePoolDTO.ESOPQuantity;
                                other_esop_exercise_qty = objExerciseBalancePoolDTO.OtherQuantity;
                            }
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }
                    }
                    if (objImplementedCompanyDTO.ContraTradeOption == ConstEnum.Code.ContraTradeQuantiyBase)
                    {
                        if (objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade == ConstEnum.Code.UserSelectionOnPreClearanceAndTradeDetailsSubmission
                                                    && (int)objPreclearanceRequestDTO.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeSell)
                        {
                            show_select_pool_quantity_checkbox = true;
                        }
                    }
                }
                //set to show exercise pool quantiy or not 
                ViewBag.IsPreClearanceEditable = objImplementedCompanyDTO.IsPreClearanceEditable;
                ViewBag.show_exercise_pool_quantity = show_exercise_pool_quantity;
                ViewBag.show_select_pool_quantity_checkbox = show_select_pool_quantity_checkbox;
                ViewBag.esop_exercise_qty = esop_exercise_qty;
                ViewBag.other_esop_exercise_qty = other_esop_exercise_qty;
                ViewBag.Show_Exercise_Pool = 0; // do not apply - show hide on selection - on page
                ViewBag.PreClrUPSIDeclarationMessage = objPreclearanceRequestDTO.PreClrUPSIDeclaration;
                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";
                List<PopulateComboDTO> lstDepartmentList = new List<PopulateComboDTO>();
                lstDepartmentList.Add(objPopulateComboDTO);
                lstDepartmentList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.ReasonforApproval).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.ReasonForApproveDropDown = lstDepartmentList;

                return View("PreClearanceApproveRejectRequest", objPreclearanceRequestModel);
            }
            #endregion try

            #region Catch
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Index");
            }
            #endregion Catch

            #region finally
            finally
            {
                objLoginUserDetails = null;
                objTradingPolicySL = null;
                objApplicableTradingPolicyDetailsDTO = null;
                objExerciseBalancePoolDTO = null;
                objPreclearanceRequestModel = null;
                objPreclearanceRequestSL = null;
                objPreclearanceRequestDTO = null;
            }
            #endregion finally
        }
        #endregion ApproveRejectAction

        #region ApproveRejectActionApprove
        /// <summary>
        /// 
        /// </summary>
        /// <param name="PreclearanceRequestId"></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        [Button(ButtonName = "ApproveAction")]
        [ActionName("ApproveRejectAction")]
        public ActionResult ApproveRejectActionApprove(long PreclearanceRequestId, string ReasonForApproval, string ReasonForApprovalCodeId, string SecuritiesApproved = "0", string PreclearanceValidityDate = "", string PreclearanceValidityDateChanged = "")
        {
            PreclearanceRequestModel objPreclearanceRequestModel = new PreclearanceRequestModel();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            string blink = "";
            int prevpcid = 0;
            string sPeriodEnddate = string.Empty;
            string sApproveddate = string.Empty;
            string sPreValiditydate = string.Empty;
            string sProhibitOnPer = string.Empty;
            string sProhibitOnQuantity = string.Empty;
            ViewBag.IsApprove = true;
            ViewBag.IsPanelActive = true;
            ViewBag.IsReject = false;
            ViewBag.Show_CO_PreclearanceEditablePanel = true;
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "Select";
            List<PopulateComboDTO> lstDepartmentList = new List<PopulateComboDTO>();
            lstDepartmentList.Add(objPopulateComboDTO);
            lstDepartmentList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.ReasonforApproval).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.ReasonForApproveDropDown = lstDepartmentList;

            PreclearanceRequestDTO objPreclearanceRequestDTO = null;
            PreclearanceRequestSL objPreclearanceRequestSL = null;

            TradingPolicySL objTradingPolicySL = null;

            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = null;

            ExerciseBalancePoolDTO objExerciseBalancePoolDTO;
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            CompaniesSL objCompaniesSL = new CompaniesSL();

            objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
            ViewBag.IsPreClearanceEditable = objImplementedCompanyDTO.IsPreClearanceEditable;

            //flag to show check box for security type share when per-clearance for "Cash and/or Cashless partial exercise"
            bool show_exercise_pool_quantity = false;
            bool show_select_pool_quantity_checkbox = false;
            decimal esop_exercise_qty = 0;
            decimal other_esop_exercise_qty = 0;
            ViewBag.show_CO_pre_clearance_list = false;
            try
            {

                objPreclearanceRequestSL = new PreclearanceRequestSL();
                objPreclearanceRequestDTO = new PreclearanceRequestDTO();
                objTradingPolicySL = new TradingPolicySL();
                bool show_CO_pre_clearance_list = false;
                TempData.Remove("SearchArray");
                objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, PreclearanceRequestId);
                Common.Common.CopyObjectPropertyByName(objPreclearanceRequestDTO, objPreclearanceRequestModel);
                ModelState.Clear();
                objPreclearanceRequestDTO.ReasonForApproval = ReasonForApproval;
                if (objImplementedCompanyDTO.IsPreClearanceEditable == 524001 && (objPreclearanceRequestDTO.TransactionTypeCodeId == 143001 || objPreclearanceRequestDTO.TransactionTypeCodeId == 143002))
                {
                    if (InsiderTrading.Common.Common.CanPerform(InsiderTrading.Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_EDIT_PRECLEARANCE_QUANTITY))
                    {
                        if (SecuritiesApproved != "" && Convert.ToDecimal(SecuritiesApproved) > 0)
                        {
                            decimal SecuritiesApprovedByCO = Convert.ToDecimal(SecuritiesApproved);

                            if (objPreclearanceRequestDTO.SecuritiesToBeTradedQty > SecuritiesApprovedByCO)
                            {
                                objPreclearanceRequestDTO.SecuritiesToBeTradedQty = SecuritiesApprovedByCO;
                            }
                            else
                            {
                                objPreclearanceRequestDTO.SecuritiesApproved = SecuritiesApprovedByCO;
                                ModelState.AddModelError("SecuritiesApprovedError", Common.Common.getResource("tra_msg_52117"));
                            }
                        }
                    }

                    if (InsiderTrading.Common.Common.CanPerform(InsiderTrading.Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_EDIT_PRECLEARANCE_VALIDITY))
                    {
                        if (PreclearanceValidityDateChanged != "")
                        {
                            DateTime PreclearanceValidityDateChangedByCO = DateTime.Parse(PreclearanceValidityDateChanged);

                            if (DateTime.Parse(PreclearanceValidityDate) > PreclearanceValidityDateChangedByCO && PreclearanceValidityDateChangedByCO > DateTime.Now)
                            {
                                objPreclearanceRequestDTO.PreclearanceValidityDateChanged = PreclearanceValidityDateChangedByCO;
                            }
                            else
                            {
                                objPreclearanceRequestDTO.PreclearanceValidityDateChanged = PreclearanceValidityDateChangedByCO;
                                ModelState.AddModelError("ChangedValidityDateError", Common.Common.getResource("tra_msg_52118"));
                            }

                        }
                    }
                }

                if (objPreclearanceRequestDTO.PreClrApprovalReasonReqFlag || !ModelState.IsValid)
                {
                    if ((ReasonForApprovalCodeId == null || ReasonForApprovalCodeId == "") || !ModelState.IsValid)
                    {                        
                        if(ReasonForApprovalCodeId == null || ReasonForApprovalCodeId == "")
                        {
                           ModelState.AddModelError("ReasonForApproval", "The Reason for Approval field is required");
                        }
                        else
                        {
                           objPreclearanceRequestDTO.ReasonForApprovalCodeId = Convert.ToInt32(ReasonForApprovalCodeId);
                        }

                        if (!ModelState.IsValid)
                        {
                           objPreclearanceRequestDTO.SecuritiesToBeTradedQty = objPreclearanceRequestModel.SecuritiesToBeTradedQty;
                           if (SecuritiesApproved != "")
                           { 
                              objPreclearanceRequestDTO.SecuritiesApproved = Convert.ToDecimal(SecuritiesApproved);
                           }
                        }

                        ViewBag.PreClrUPSIDeclarationMessage = objPreclearanceRequestDTO.PreClrUPSIDeclaration;

                        //check if page is called from previous pre-clearance request grid in that case do not show pre clearance list 
                        if (blink == "" || blink != "preclereq")
                        {
                            show_CO_pre_clearance_list = true; //set flag to show CO per clearance list
                        }

                        ViewBag.show_CO_pre_clearance_list = show_CO_pre_clearance_list;

                        ViewBag.back_link = blink;
                        ViewBag.previous_preclearance_id = prevpcid;

                        if (objPreclearanceRequestDTO.ContraTradePeriod != null)
                        {
                            ArrayList lst = new ArrayList();
                            lst.Add(objPreclearanceRequestDTO.ContraTradePeriod);
                            ViewBag.contra_trade_period = lst;
                        }

                        objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, (int)objPreclearanceRequestDTO.UserInfoId, (Int64)objPreclearanceRequestDTO.TransactionMasterId);

                        //check for contra trade, if user has to select or not, wheather to use security pool or do not use security pool 
                        if (objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool && (int)objPreclearanceRequestDTO.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeShares)
                        {
                            // set flag to show quantity from pool 
                            show_exercise_pool_quantity = true;

                            try
                            {
                                //get security details from pool - for security type - share 
                                objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, (int)objPreclearanceRequestDTO.UserInfoId, ConstEnum.Code.SecurityTypeShares, Convert.ToInt32(objPreclearanceRequestDTO.DMATDetailsID));

                                if (objExerciseBalancePoolDTO != null)
                                {
                                    esop_exercise_qty = objExerciseBalancePoolDTO.ESOPQuantity;
                                    other_esop_exercise_qty = objExerciseBalancePoolDTO.OtherQuantity;
                                }
                            }
                            catch (Exception ex)
                            {
                                throw ex;
                                //exception while fetching security balance 
                            }

                            if (objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade == ConstEnum.Code.UserSelectionOnPreClearanceAndTradeDetailsSubmission
                                    && (int)objPreclearanceRequestDTO.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeSell)
                            {
                                show_select_pool_quantity_checkbox = true;
                            }
                        }


                        //set to show exercise pool quantiy or not 
                        ViewBag.show_exercise_pool_quantity = show_exercise_pool_quantity;

                        ViewBag.show_select_pool_quantity_checkbox = show_select_pool_quantity_checkbox;

                        ViewBag.esop_exercise_qty = esop_exercise_qty;
                        ViewBag.other_esop_exercise_qty = other_esop_exercise_qty;

                        ViewBag.Show_Exercise_Pool = 0; // do not apply - show hide on selection - on page

                        Common.Common.CopyObjectPropertyByName(objPreclearanceRequestDTO, objPreclearanceRequestModel);

                        return View("PreClearanceApproveRejectRequest", objPreclearanceRequestModel);
                    }
                    else
                    {
                        objPreclearanceRequestDTO.PreclearanceStatusCodeId = ConstEnum.Code.PreclearanceRequestStatusApproved;
                        objPreclearanceRequestDTO.ReasonForRejection = null;
                        objPreclearanceRequestDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                        objPreclearanceRequestDTO.ReasonForApproval = ReasonForApproval;
                        if (ReasonForApprovalCodeId != "")
                            objPreclearanceRequestDTO.ReasonForApprovalCodeId = Convert.ToInt32(ReasonForApprovalCodeId);
                        else
                            objPreclearanceRequestDTO.ReasonForApprovalCodeId = null;
                        string sContraTradeDate;
                        objPreclearanceRequestDTO = objPreclearanceRequestSL.Save(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestDTO, out sContraTradeDate, out sPeriodEnddate, out sApproveddate, out sPreValiditydate, out sProhibitOnPer, out sProhibitOnQuantity);

                        return RedirectToAction("ListByCO", "PreClearanceRequest", new { acid = InsiderTrading.Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE });
                    }
                }
                else
                {
                    objPreclearanceRequestDTO.PreclearanceStatusCodeId = ConstEnum.Code.PreclearanceRequestStatusApproved;
                    objPreclearanceRequestDTO.ReasonForRejection = null;
                    objPreclearanceRequestDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    objPreclearanceRequestDTO.ReasonForApproval = ReasonForApproval;
                    if (ReasonForApprovalCodeId != "")
                        objPreclearanceRequestDTO.ReasonForApprovalCodeId = Convert.ToInt32(ReasonForApprovalCodeId);
                    else
                        objPreclearanceRequestDTO.ReasonForApprovalCodeId = null;
                    string sContraTradeDate;
                    objPreclearanceRequestDTO = objPreclearanceRequestSL.Save(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestDTO, out sContraTradeDate, out sPeriodEnddate, out sApproveddate, out sPreValiditydate, out sProhibitOnPer, out sProhibitOnQuantity);

                    return RedirectToAction("ListByCO", "PreClearanceRequest", new { acid = InsiderTrading.Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE });
                }

            }
            catch (Exception exp)
            {
                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, (int)objPreclearanceRequestDTO.UserInfoId, (Int64)objPreclearanceRequestDTO.TransactionMasterId);

                //check for contra trade, if user has to select or not, wheather to use security pool or do not use security pool 
                if (objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool && (int)objPreclearanceRequestDTO.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeShares)
                {
                    // set flag to show quantity from pool 
                    show_exercise_pool_quantity = true;

                    try
                    {
                        //get security details from pool - for security type - share 
                        objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, (int)objPreclearanceRequestDTO.UserInfoId, ConstEnum.Code.SecurityTypeShares, Convert.ToInt32(objPreclearanceRequestDTO.DMATDetailsID));

                        if (objExerciseBalancePoolDTO != null)
                        {
                            esop_exercise_qty = objExerciseBalancePoolDTO.ESOPQuantity;
                            other_esop_exercise_qty = objExerciseBalancePoolDTO.OtherQuantity;
                        }
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                        //exception while fetching security balance 
                    }

                    if (objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade == ConstEnum.Code.UserSelectionOnPreClearanceAndTradeDetailsSubmission
                            && (int)objPreclearanceRequestDTO.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeSell)
                    {
                        show_select_pool_quantity_checkbox = true;
                    }
                }


                //set to show exercise pool quantiy or not 
                ViewBag.show_exercise_pool_quantity = show_exercise_pool_quantity;

                ViewBag.show_select_pool_quantity_checkbox = show_select_pool_quantity_checkbox;

                ViewBag.esop_exercise_qty = esop_exercise_qty;
                ViewBag.other_esop_exercise_qty = other_esop_exercise_qty;

                ViewBag.Show_Exercise_Pool = 0; // do not apply - show hide on selection - on page

                objPreclearanceRequestDTO.SecuritiesToBeTradedQty = objPreclearanceRequestModel.SecuritiesToBeTradedQty;
                objPreclearanceRequestDTO.SecuritiesApproved = Convert.ToDecimal(SecuritiesApproved);

                Common.Common.CopyObjectPropertyByName(objPreclearanceRequestDTO, objPreclearanceRequestModel);

                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("PreClearanceApproveRejectRequest", objPreclearanceRequestModel);
            }
        }
        #endregion ApproveRejectActionApprove

        #region ApproveRejectActionReject
        /// <summary>
        /// 
        /// </summary>
        /// <param name="PreclearanceRequestId"></param>
        /// <param name="ReasonForRejection"></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        [Button(ButtonName = "RejectAction")]
        [ActionName("ApproveRejectAction")]
        public ActionResult ApproveRejectActionReject(long PreclearanceRequestId, string ReasonForRejection)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            string blink = "";
            int prevpcid = 0;
            string sPeriodEnddate = string.Empty;
            string sApproveddate = string.Empty;
            string sPreValiditydate = string.Empty;
            string sProhibitOnPer = string.Empty;
            string sProhibitOnQuantity = string.Empty;
            PreclearanceRequestModel objPreclearanceRequestModel = new PreclearanceRequestModel();

            PreclearanceRequestDTO objPreclearanceRequestDTO = null;
            PreclearanceRequestSL objPreclearanceRequestSL = null;

            TradingPolicySL objTradingPolicySL = null;

            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = null;

            ExerciseBalancePoolDTO objExerciseBalancePoolDTO;

            //flag to show check box for security type share when per-clearance for "Cash and/or Cashless partial exercise"
            bool show_exercise_pool_quantity = false;
            bool show_select_pool_quantity_checkbox = false;
            decimal esop_exercise_qty = 0;
            decimal other_esop_exercise_qty = 0;
            ViewBag.show_CO_pre_clearance_list = null;

            try
            {
                objPreclearanceRequestSL = new PreclearanceRequestSL();
                objPreclearanceRequestDTO = new PreclearanceRequestDTO();
                objTradingPolicySL = new TradingPolicySL();

                bool show_CO_pre_clearance_list = false;
                if (ReasonForRejection == null || ReasonForRejection == "")
                {
                    ViewBag.IsReject = true;
                    ModelState.Clear();
                    ModelState.AddModelError("ReasonForRejection", "The Reason for Rejection field is required");
                    objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, PreclearanceRequestId);
                    Common.Common.CopyObjectPropertyByName(objPreclearanceRequestDTO, objPreclearanceRequestModel);


                    ViewBag.IsPanelActive = true;
                    ViewBag.IsApprove = false;
                    ViewBag.PreClrUPSIDeclarationMessage = objPreclearanceRequestDTO.PreClrUPSIDeclaration;

                    PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                    objPopulateComboDTO.Key = "";
                    objPopulateComboDTO.Value = "Select";
                    List<PopulateComboDTO> lstDepartmentList = new List<PopulateComboDTO>();
                    lstDepartmentList.Add(objPopulateComboDTO);
                    lstDepartmentList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                        Convert.ToInt32(ConstEnum.CodeGroup.ReasonforApproval).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                    ViewBag.ReasonForApproveDropDown = lstDepartmentList;

                    //check if page is called from previous pre-clearance request grid in that case do not show pre clearance list 
                    if (blink == "" || blink != "preclereq")
                    {
                        show_CO_pre_clearance_list = true; //set flag to show CO per clearance list
                    }

                    ViewBag.show_CO_pre_clearance_list = show_CO_pre_clearance_list;

                    ViewBag.back_link = blink;
                    ViewBag.previous_preclearance_id = prevpcid;

                    if (objPreclearanceRequestDTO.ContraTradePeriod != null)
                    {
                        ArrayList lst = new ArrayList();
                        lst.Add(objPreclearanceRequestDTO.ContraTradePeriod);
                        ViewBag.contra_trade_period = lst;
                    }

                    objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, (int)objPreclearanceRequestDTO.UserInfoId, (Int64)objPreclearanceRequestDTO.TransactionMasterId);

                    //check for contra trade, if user has to select or not, wheather to use security pool or do not use security pool 
                    if (objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool && (int)objPreclearanceRequestDTO.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeShares)
                    {
                        // set flag to show quantity from pool 
                        show_exercise_pool_quantity = true;

                        try
                        {
                            //get security details from pool - for security type - share 
                            objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, (int)objPreclearanceRequestDTO.UserInfoId, ConstEnum.Code.SecurityTypeShares, Convert.ToInt32(objPreclearanceRequestDTO.DMATDetailsID));

                            if (objExerciseBalancePoolDTO != null)
                            {
                                esop_exercise_qty = objExerciseBalancePoolDTO.ESOPQuantity;
                                other_esop_exercise_qty = objExerciseBalancePoolDTO.OtherQuantity;
                            }
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                            //exception while fetching security balance 
                        }

                        if (objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade == ConstEnum.Code.UserSelectionOnPreClearanceAndTradeDetailsSubmission
                                && (int)objPreclearanceRequestDTO.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeSell)
                        {
                            show_select_pool_quantity_checkbox = true;
                        }
                    }


                    //set to show exercise pool quantiy or not 
                    ViewBag.show_exercise_pool_quantity = show_exercise_pool_quantity;

                    ViewBag.show_select_pool_quantity_checkbox = show_select_pool_quantity_checkbox;

                    ViewBag.esop_exercise_qty = esop_exercise_qty;
                    ViewBag.other_esop_exercise_qty = other_esop_exercise_qty;

                    ViewBag.Show_Exercise_Pool = 0; // do not apply - show hide on selection - on page

                    return View("PreClearanceApproveRejectRequest", objPreclearanceRequestModel);

                }

                objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, PreclearanceRequestId);

                objPreclearanceRequestDTO.PreclearanceStatusCodeId = ConstEnum.Code.PreclearanceRequestStatusRejected;
                objPreclearanceRequestDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                objPreclearanceRequestDTO.ReasonForRejection = ReasonForRejection;
                string sContraTradeDate;
                objPreclearanceRequestDTO = objPreclearanceRequestSL.Save(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestDTO, out sContraTradeDate, out sPeriodEnddate, out sApproveddate, out sPreValiditydate, out sProhibitOnPer, out sProhibitOnQuantity);
                TempData.Remove("SearchArray");
                return RedirectToAction("ListByCO", "PreClearanceRequest", new { acid = InsiderTrading.Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE });

            }
            catch (Exception exp)
            {
                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, (int)objPreclearanceRequestDTO.UserInfoId, (Int64)objPreclearanceRequestDTO.TransactionMasterId);

                //check for contra trade, if user has to select or not, wheather to use security pool or do not use security pool 
                if (objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool && (int)objPreclearanceRequestDTO.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeShares)
                {
                    // set flag to show quantity from pool 
                    show_exercise_pool_quantity = true;

                    try
                    {
                        //get security details from pool - for security type - share 
                        objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, (int)objPreclearanceRequestDTO.UserInfoId, ConstEnum.Code.SecurityTypeShares, Convert.ToInt32(objPreclearanceRequestDTO.DMATDetailsID));

                        if (objExerciseBalancePoolDTO != null)
                        {
                            esop_exercise_qty = objExerciseBalancePoolDTO.ESOPQuantity;
                            other_esop_exercise_qty = objExerciseBalancePoolDTO.OtherQuantity;
                        }
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                        //exception while fetching security balance 
                    }

                    if (objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade == ConstEnum.Code.UserSelectionOnPreClearanceAndTradeDetailsSubmission
                            && (int)objPreclearanceRequestDTO.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeSell)
                    {
                        show_select_pool_quantity_checkbox = true;
                    }
                }


                //set to show exercise pool quantiy or not 
                ViewBag.show_exercise_pool_quantity = show_exercise_pool_quantity;

                ViewBag.show_select_pool_quantity_checkbox = show_select_pool_quantity_checkbox;

                ViewBag.esop_exercise_qty = esop_exercise_qty;
                ViewBag.other_esop_exercise_qty = other_esop_exercise_qty;

                ViewBag.Show_Exercise_Pool = 0; // do not apply - show hide on selection - on page

                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("PreClearanceApproveRejectRequest", objPreclearanceRequestModel);
            }
        }
        #endregion ApproveRejectActionReject

        #region RejectionView
        /// <summary>
        /// 
        /// </summary>
        /// <param name="PreClearanceRequestId"></param>
        /// <param name="CalledFrom"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult RejectionView(long PreClearanceRequestId, int acid, string CalledFrom = "")
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            PreclearanceRequestModel objPreclearanceRequestModel = new PreclearanceRequestModel();
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            PreclearanceRequestDTO objPreclearanceRequestDTO = new PreclearanceRequestDTO();
            try
            {
                if (PreClearanceRequestId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PreclearanceRequest, Convert.ToInt64(PreClearanceRequestId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, PreClearanceRequestId);
                Common.Common.CopyObjectPropertyByName(objPreclearanceRequestDTO, objPreclearanceRequestModel);
                ViewBag.CalledFrom = CalledFrom;
                ViewBag.PreClrUPSIDeclarationMessage = objPreclearanceRequestDTO.PreClrUPSIDeclaration;
                return View("PreclearanceRejectionView", objPreclearanceRequestModel);

            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Index");
            }
            finally
            {
                objLoginUserDetails = null;
                objPreclearanceRequestModel = null;
                objPreclearanceRequestSL = null;
                objPreclearanceRequestDTO = null;
            }
        }
        #endregion RejectionView

        #region NotTradedViewView
        /// <summary>
        /// 
        /// </summary>
        /// <param name="PreClearanceRequestId"></param>
        /// <param name="CalledFrom"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult NotTradedViewView(long PreClearanceRequestId, int acid, string CalledFrom = "")
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                if (PreClearanceRequestId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PreclearanceRequest, Convert.ToInt64(PreClearanceRequestId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                PreclearanceRequestModel objPreclearanceRequestModel = new PreclearanceRequestModel();
                PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
                PreclearanceRequestDTO objPreclearanceRequestDTO = new PreclearanceRequestDTO();
                objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, PreClearanceRequestId);
                Common.Common.CopyObjectPropertyByName(objPreclearanceRequestDTO, objPreclearanceRequestModel);
                ViewBag.CalledFrom = CalledFrom;
                return View("NotTradedView", objPreclearanceRequestModel);

            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Index");
            }
        }
        #endregion NotTradedViewView

        #endregion  CO All Action & Methods

        #region Dashnoard

        #region Continuous Disclosures CO Dashnoard
        /// <summary>
        /// 
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult ContinuousDisclosuresCODashnoard(String inp_sParam, String isInsider, int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ViewBag.User = objLoginUserDetails.UserTypeCodeId;
            string chk_User = Convert.ToString(ViewBag.User);
            ViewBag.StockExchangeStatusList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, "IP", chk_User, true);
            ViewBag.NSEDownloadOptionsList = FillComboValues(ConstEnum.ComboType.NSEdownloadEventList, InsiderTrading.Common.ConstEnum.CodeGroup.NSEDownloadOptions, null, null, null, null, true);
            ViewData["inp_sParam"] = inp_sParam;
            ViewData["isInsider"] = isInsider;
            ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
            ViewBag.EmployeeStatusList = FillComboValues(ConstEnum.ComboType.EmpStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.EmployeeStatus, null, null, null, null, true);
            ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
            ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
            ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
            //ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            ViewBag.Param1 = groupId;
            ViewBag.GroupID = groupId;
            FillGrid(Common.ConstEnum.GridType.ContinuousDisclosureListForCO, "0", null, null);
            return View("ListByCO");
        }
        #endregion CO List

        #region Continuous Disclosures Insider Dashnoard
        /// <summary>
        /// 
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult ContinuousDisclosuresInsiderDashnoard(String inp_sParam, int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ViewBag.User = objLoginUserDetails.UserTypeCodeId;
            string chk_User = Convert.ToString(ViewBag.User);
            ViewBag.StockExchangeStatusList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, "IP", chk_User, true);
            ViewBag.NSEDownloadOptionsList = FillComboValues(ConstEnum.ComboType.NSEdownloadEventList, InsiderTrading.Common.ConstEnum.CodeGroup.NSEDownloadOptions, null, null, null, null, true);
            ViewData["inp_sParam"] = inp_sParam;
            ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
            ViewBag.EmployeeStatusList = FillComboValues(ConstEnum.ComboType.EmpStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.EmployeeStatus, null, null, null, null, true);
            ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
            ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
            ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
            //ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            ViewBag.Param1 = groupId;
            ViewBag.GroupID = groupId;
            FillGrid(Common.ConstEnum.GridType.ContinuousDisclosureListForCO, "0", null, null);
            return View("ListByCO");
        }
        #endregion

        #region Pre-clearances CO Dashboard
        /// <summary>
        /// 
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult PreClearancesCODashboard(int acid, String inp_sParam, String isInsider)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ViewBag.User = objLoginUserDetails.UserTypeCodeId;
            string chk_User = Convert.ToString(ViewBag.User);
            ViewBag.StockExchangeStatusList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, "IP", chk_User, true);
            ViewBag.NSEDownloadOptionsList = FillComboValues(ConstEnum.ComboType.NSEdownloadEventList, InsiderTrading.Common.ConstEnum.CodeGroup.NSEDownloadOptions, null, null, null, null, true);
            ViewData["inp_sParam"] = inp_sParam;
            ViewData["IsInsider"] = isInsider;
            ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
            ViewBag.EmployeeStatusList = FillComboValues(ConstEnum.ComboType.EmpStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.EmployeeStatus, null, null, null, null, true);
            ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
            ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
            ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
            //ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            ViewBag.Param1 = groupId;
            ViewBag.GroupID = groupId;
            FillGrid(Common.ConstEnum.GridType.ContinuousDisclosureListForCO, "0", null, null);
            return View("ListByCO");
        }
        #endregion Pre-clearances CO Dashboard

        #region Pre-clearances CO Dashboard
        /// <summary>
        /// 
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult TradeDetailsInsider(int acid, String inp_sParam, String isInsider)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ViewBag.User = objLoginUserDetails.UserTypeCodeId;
            string chk_User = Convert.ToString(ViewBag.User);
            ViewBag.StockExchangeStatusList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, "IP", chk_User, true);
            ViewBag.NSEDownloadOptionsList = FillComboValues(ConstEnum.ComboType.NSEdownloadEventList, InsiderTrading.Common.ConstEnum.CodeGroup.NSEDownloadOptions, null, null, null, null, true);
            ViewData["inp_sParam"] = inp_sParam;
            ViewData["IsInsider"] = isInsider;
            ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
            ViewBag.EmployeeStatusList = FillComboValues(ConstEnum.ComboType.EmpStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.EmployeeStatus, null, null, null, null, true);
            ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
            ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
            ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
            //ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            ViewBag.Param1 = groupId;
            ViewBag.GroupID = groupId;
            FillGrid(Common.ConstEnum.GridType.ContinuousDisclosureListForCO, "0", null, null);
            return View("ListByCO");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult TradeDetailsCO(int acid, String inp_sParam, String isInsider)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ViewBag.User = objLoginUserDetails.UserTypeCodeId;
            string chk_User = Convert.ToString(ViewBag.User);
            ViewBag.StockExchangeStatusList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, "IP", chk_User, true);
            ViewBag.NSEDownloadOptionsList = FillComboValues(ConstEnum.ComboType.NSEdownloadEventList, InsiderTrading.Common.ConstEnum.CodeGroup.NSEDownloadOptions, null, null, null, null, true);
            ViewData["inp_sParam"] = inp_sParam;
            ViewData["IsInsider"] = isInsider;
            ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
            ViewBag.EmployeeStatusList = FillComboValues(ConstEnum.ComboType.EmpStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.EmployeeStatus, null, null, null, null, true);
            ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
            ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
            ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
            ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            ViewBag.GroupID = groupId;
            //ViewBag.Param1 = groupId;
            FillGrid(Common.ConstEnum.GridType.ContinuousDisclosureListForCO, "0", null, null);
            return View("ListByCO");
        }
        #endregion Pre-clearances CO Dashboard

        #region Submission To Stock Exchange CO Dashboard
        /// <summary>
        /// 
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult SubmissionToStockExchangeCODashnoard(int acid, String inp_sParam, String isInsider)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            ViewBag.User = objLoginUserDetails.UserTypeCodeId;
            string chk_User = Convert.ToString(ViewBag.User);
            ViewData["inp_sParam"] = inp_sParam;
            ViewData["IsInsider"] = isInsider;
            ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
            ViewBag.EmployeeStatusList = FillComboValues(ConstEnum.ComboType.EmpStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.EmployeeStatus, null, null, null, null, true);
            ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
            ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
            ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
            ViewBag.StockExchangeStatusList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, "IP", chk_User, true);
            ViewBag.NSEDownloadOptionsList = FillComboValues(ConstEnum.ComboType.NSEdownloadEventList, InsiderTrading.Common.ConstEnum.CodeGroup.NSEDownloadOptions, null, null, null, null, true);
            ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            ViewBag.GroupID = groupId;
            //ViewBag.Param1 = groupId;
            FillGrid(Common.ConstEnum.GridType.ContinuousDisclosureListForCO, "0", null, null);
            return View("ListByCO");
        }
        #endregion Submission To Stock Exchange CO Dashboard

        #endregion

        #region backButtonAction
        /// <summary>
        /// 
        /// </summary>
        /// <param name="CalledFrom"></param>
        /// <returns></returns>
        public ActionResult backButtonAction(string CalledFrom)
        {
            if (CalledFrom == "Insider")
            {
                return RedirectToAction("Index", "PreClearanceRequest", new { acid = InsiderTrading.Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE });
            }
            else
            {
                return RedirectToAction("ListByCO", "PreClearanceRequest", new { acid = InsiderTrading.Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE });
            }
        }
        #endregion backButtonAction

        #region Get Designation list
        public JsonResult GetDesignationList()
        {
            LoginUserDetails objLoginUserDetails = null;
            List<PopulateComboDTO> DesignationList = null;
            List<String> DesginationNames = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                DesignationList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.DesignationList, null, null, null, null, null, false, sLookupPrefix);

                DesginationNames = new List<string>();

                foreach (PopulateComboDTO Desiganation in DesignationList)
                {
                    DesginationNames.Add(Desiganation.Value);
                }


                return Json(DesginationNames);
            }
            catch (Exception ex)
            {
                throw ex; ;
            }
            return null;
        }
        #endregion Get Designation list

        #region NoMoreTransaction
        /// <summary>
        /// 
        /// </summary>
        /// <param name="PreclearanceRequestId"></param>
        /// <param name="CalledFrom"></param>
        /// <returns></returns>
        public ActionResult NoMoreTransaction(int PreclearanceRequestId, string CalledFrom)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            ResourcesSL objResourcesSL = new ResourcesSL();
            try
            {
                if (PreclearanceRequestId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PreclearanceRequest, Convert.ToInt64(PreclearanceRequestId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                List<PopulateComboDTO> lstReasonsForNotTrading = new List<PopulateComboDTO>();
                lstReasonsForNotTrading = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ReasonForNotTrading, null, null, null, null, true);
                ViewBag.lstReasonsForNotTrading = lstReasonsForNotTrading;
                ViewBag.PreclearanceRequestId = PreclearanceRequestId;
                ViewBag.CalledFrom = CalledFrom;
                return PartialView("~/Views/TradingTransaction/NotTradedPopup.cshtml");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return RedirectToAction("Index");
            }

        }
        #endregion NoMoreTransaction

        #region TradingTransaction not traded Status
        [HttpPost]
        [TokenVerification]
        public JsonResult TransactionNotTraded(int nPreclearenceId, int nReasonForNotTrading, string sReasonForNotTradingText)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            string sPeriodEnddate = string.Empty;
            string sApproveddate = string.Empty;
            string sPreValiditydate = string.Empty;
            string sProhibitOnPer = string.Empty;
            string sProhibitOnQuantity = string.Empty;
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return Json(new
                    {
                        status = statusFlag,
                        Message = ErrorDictionary
                    }, JsonRequestBehavior.AllowGet);
                }
                LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
                PreclearanceRequestDTO objPreclearanceRequestDTO = new PreclearanceRequestDTO();
                objPreclearanceRequestDTO.PreclearanceRequestId = nPreclearenceId;
                objPreclearanceRequestDTO.ReasonForNotTradingCodeId = nReasonForNotTrading;
                objPreclearanceRequestDTO.ReasonForNotTradingText = sReasonForNotTradingText;
                objPreclearanceRequestDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                string sContraTradeDate;
                objPreclearanceRequestDTO = objPreclearanceRequestSL.Save(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestDTO, out sContraTradeDate, out sPeriodEnddate, out sApproveddate, out sPreValiditydate, out sProhibitOnPer, out sProhibitOnQuantity);
                ErrorDictionary.Add("success", Common.Common.getResource("tra_msg_16127"));
                statusFlag = true;
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
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }
        #endregion TradingTransaction not traded Status

        #region Get TMID for selected DMAT account
        [HttpPost]
        public JsonResult DMATCombo_OnChange(int nDMATDetailsID)
        {
            LoginUserDetails objLoginUserDetails = null;
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                {
                    objDMATDetailsDTO = objDMATDetailsSL.GetDMATDetails(objLoginUserDetails.CompanyDBConnectionString, nDMATDetailsID);
                }
                return Json(objDMATDetailsDTO.TMID);
            }
            catch
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objDMATDetailsDTO = null;
            }
        }
        #endregion

        #region DownloadFormE
        [ValidateInput(false)]
        [AuthorizationPrivilegeFilter]
        public ActionResult DownloadFormE(int acid, long PreclearanceRequestId, string DisplayCode)
        {

            LoginUserDetails objLoginUserDetails = null;
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            FormEDetailsDTO objFormEDetailsDTO = null;
            try
            {


                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objFormEDetailsDTO = objPreclearanceRequestSL.GetFormEDetails(objLoginUserDetails.CompanyDBConnectionString, Common.ConstEnum.Code.PreclearanceRequest, Convert.ToInt32(PreclearanceRequestId));
                /*  MemoryStream ms = new MemoryStream();
                  TextWriter tw = new StreamWriter(ms);
                  tw.WriteLine(objFormEDetailsDTO.GeneratedFormContents);
                  tw.Flush();
                  byte[] bytes = ms.ToArray();
                  ms.Close();

                  Response.Clear();
                  Response.ContentType = "application/force-download";
                  Response.AddHeader("content-disposition", "attachment;    filename=" + objFormEDetailsDTO.DisplayFileName + "." + "pdf");
                  Response.BinaryWrite(bytes);
                  Response.End();
                  return null;*/

                Response.Clear();
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/pdf";
                Response.AppendHeader("content-disposition", "attachment;filename=" + DisplayCode + ".pdf");
                Response.Flush();
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Buffer = true;

                // objFormEDetailsDTO = new FormEDetailsDTO();
                //  objFormEDetailsDTO.GeneratedFormContents = "<html><body>1.1.1	Description: Admin shall have the facility to set the configuration of trade details submission for insiders/employees in initial and period end disclosures.</body></html>";
                string LetterHTMLContent = objFormEDetailsDTO.GeneratedFormContents;
                Regex rReplaceScript = new Regex(@"<br>");
                LetterHTMLContent = rReplaceScript.Replace(LetterHTMLContent, "<br />");


                using (var ms = new MemoryStream())
                {
                    using (var doc = new Document(PageSize.A4, 30f, 30f, 30f, 30f))
                    {
                        using (var writer = PdfWriter.GetInstance(doc, Response.OutputStream))
                        {
                            doc.Open();
                            doc.NewPage();

                            using (var msCss = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent)))
                            {
                                using (var msHtml = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent)))
                                {
                                    iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, msHtml, msCss);
                                }
                            }

                            doc.Close();
                        }

                        Response.Write(doc);
                        Response.End();
                    }
                }
                return null;
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Warning", Common.Common.GetErrorMessage(exp));
                return View("Index");
            }
        }
        #endregion DownloadFormE


        #region Private Method

        #region FillComboValues
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sDBConnectionString"></param>
        /// <param name="i_nComboType"></param>
        /// <param name="i_sParam1"></param>
        /// <param name="i_sParam2"></param>
        /// <param name="i_sParam3"></param>
        /// <param name="i_sParam4"></param>
        /// <param name="i_sParam5"></param>
        /// <param name="i_bIsDefaultValue"></param>
        /// <param name="i_sLookupPrefix"></param>
        /// <returns></returns>
        private List<PopulateComboDTO> FillComboValues(string i_sDBConnectionString, int i_nComboType, string i_sParam1, string i_sParam2, string i_sParam3, string i_sParam4, string i_sParam5, bool i_bIsDefaultValue, string i_sLookupPrefix)
        {
            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> lstPopulateComboDTO = null;

            try
            {
                objPopulateComboDTO = new PopulateComboDTO();
                lstPopulateComboDTO = new List<PopulateComboDTO>();

                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";

                if (i_bIsDefaultValue)
                {
                    lstPopulateComboDTO.Add(objPopulateComboDTO);
                }

                lstPopulateComboDTO.AddRange(Common.Common.GetPopulateCombo(i_sDBConnectionString, i_nComboType, i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, i_sLookupPrefix).ToList<PopulateComboDTO>());

            }
            catch (Exception exp)
            {
                throw exp;
            }

            return lstPopulateComboDTO;
        }
        #endregion FillComboValues

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
                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";
                List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
                if (i_bIsDefaultValue)
                {
                    lstPopulateComboDTO.Add(objPopulateComboDTO);
                }



                lstPopulateComboDTO.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, i_nComboType,
                    i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, "cmp_msg_").ToList<PopulateComboDTO>());
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