using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq; 
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Configuration;
using System.Data;

namespace InsiderTrading.Controllers
{
    [ValidateInput(false)]
    public class TradingTransaction_OSController : Controller
    {
        int nDisclosureCompletedFlag = 0;

        #region TradingTransaction Master details
        public TradingTransactionMasterDTO_OS MasterDetials(LoginUserDetails objLoginUserDetails, int nDisclosureTypeCodeId, int nUserInfoId, int nYearCode = 0, int nPeriodCode = 0, int nPeriodType = 0, string frm = "", int nUserTypeCodeId = 0)
        {
            TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS = null;
            
            Dictionary<String, Object> objList = null;

            try
            {
                objTradingTransactionMasterDTO_OS = new TradingTransactionMasterDTO_OS();

                if (frm == "Insider" && nUserTypeCodeId == 101003)
                {
                    objTradingTransactionMasterDTO_OS.InsiderIDFlag = true;
                }
                objTradingTransactionMasterDTO_OS.TransactionMasterId = 0;
                objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId = nDisclosureTypeCodeId;
                objTradingTransactionMasterDTO_OS.UserInfoId = nUserInfoId;
                objTradingTransactionMasterDTO_OS.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForNotConfirmed;
                objTradingTransactionMasterDTO_OS.NoHoldingFlag = false;

                //if (nYearCode != 0 && nPeriodCode != 0)
                //{
                //    using (PeriodEndDisclosureSL objPeriodEndDisclosureSL = new PeriodEndDisclosureSL())
                //    {
                //        objList = objPeriodEndDisclosureSL.GetPeriodStarEndDate(objLoginUserDetails.CompanyDBConnectionString, nYearCode, nPeriodCode, nPeriodType);

                //        objTradingTransactionMasterDTO.PeriodEndDate = Convert.ToDateTime(objList["end_date"]);
                //    }
                //}

                using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                {
                    objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO_OS, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);
                }
                ViewBag.UserTypeCodeId = objLoginUserDetails.UserTypeCodeId;
                return objTradingTransactionMasterDTO_OS;
                // return RedirectToAction("Index", "TradingTransaction", new { TransactionMasterId = objTradingTransactionMasterDTO.TransactionMasterId });
            }
            catch (Exception exp)
            {
                // return null;
                throw exp;
            }
            finally
            {
                objList = null;
                objTradingTransactionMasterDTO_OS = null;
            }
        }
        #endregion TradingTransaction Master details

        #region TradinTransactionList
        // GET: /Transaction/
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid, int TransactionMasterId = 0, int nDisclosureTypeCodeId = 0, int nUserInfoId = 0, int nUserTypeCodeId = 0, int nYearCode = 0, int nPeriodCode = 0, int PreclearanceRequestId = 0, string frm = "", int nPeriodType = 0, int ShowDocumentTab = 0, int SecurityTypeCode = 0, int ParentId = 0)
        {
            TradingTransactionModel_OS objTransactionModel_OS = null;

            TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS = null;
            TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS_forTPSetting = null;
            LoginUserDetails objLoginUserDetails = null;
            CompanySettingConfigurationDTO objCompanySettingConfigurationDTO = null;
            ViewBag.NoHolding = false;
            ViewBag.IsfromView = 0;
            ViewBag.Showenterbutton = true;
            bool bIsCOAdminUser = false;

            ViewBag.UserTypeId = nUserTypeCodeId;
            //if (nDisclosureTypeCodeId==InsiderTrading.Common.ConstEnum.Code.DisclosureTypeContinuous)
            //{
            //    if(PreclearanceRequestId==0)
            //    {
            //        ViewBag.UserTypeId = 101003;
            //    }
            //}
            ViewBag.Frm = frm;
            ViewBag.UserInfoId = nUserInfoId;
            try

            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                if (TransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(TransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                objTransactionModel_OS = new TradingTransactionModel_OS();


                using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                {
                    if (TransactionMasterId == 0)
                    {
                        if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                        {
                            objTradingTransactionMasterDTO_OS = new TradingTransactionMasterDTO_OS();

                            objTradingTransactionMasterDTO_OS.TransactionMasterId = 0;
                            objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId = nDisclosureTypeCodeId;
                            objTradingTransactionMasterDTO_OS.UserInfoId = nUserInfoId;
                            objTradingTransactionMasterDTO_OS.PreclearanceRequestId = PreclearanceRequestId;
                            objTradingTransactionMasterDTO_OS.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForNotConfirmed;
                            objTradingTransactionMasterDTO_OS.NoHoldingFlag = false;
                            objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO_OS, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);

                            objTradingTransactionMasterDTO_OS_forTPSetting = objTradingTransactionSL_OS.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO_OS.TransactionMasterId));

                            ViewBag.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures = objTradingTransactionMasterDTO_OS_forTPSetting.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures;
                            ViewBag.DeclarationToBeMandatoryFlag = objTradingTransactionMasterDTO_OS_forTPSetting.DeclarationToBeMandatoryFlag;
                            ViewBag.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag = objTradingTransactionMasterDTO_OS_forTPSetting.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag;
                            ViewBag.SeekDeclarationFromEmpRegPossessionOfUPSIFlag = objTradingTransactionMasterDTO_OS_forTPSetting.SeekDeclarationFromEmpRegPossessionOfUPSIFlag;
                            ViewBag.ReasonForNotTradedRequired = objTradingTransactionMasterDTO_OS_forTPSetting.PreClrReasonForNonTradeReqFlag;
                        }
                        else
                        {
                            objTradingTransactionMasterDTO_OS = MasterDetials(objLoginUserDetails, nDisclosureTypeCodeId, nUserInfoId, nYearCode, nPeriodCode, nPeriodType, frm, nUserTypeCodeId);
                        }
                    }
                    else
                    {
                        objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, TransactionMasterId);

                        ViewBag.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures = objTradingTransactionMasterDTO_OS.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures;
                        ViewBag.DeclarationToBeMandatoryFlag = objTradingTransactionMasterDTO_OS.DeclarationToBeMandatoryFlag;
                        ViewBag.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag = objTradingTransactionMasterDTO_OS.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag;
                        ViewBag.SeekDeclarationFromEmpRegPossessionOfUPSIFlag = objTradingTransactionMasterDTO_OS.SeekDeclarationFromEmpRegPossessionOfUPSIFlag;
                        ViewBag.ReasonForNotTradedRequired = objTradingTransactionMasterDTO_OS.PreClrReasonForNonTradeReqFlag;
                    }

                    objTransactionModel_OS.TradingTransactionUpload = Common.Common.GenerateDocumentList(ConstEnum.Code.DisclosureTransaction, Convert.ToInt32(objTradingTransactionMasterDTO_OS.TransactionMasterId), 0, null, ConstEnum.Code.TransactionDetailsUpload, false, 0, 10, true);

                    ViewBag.CDDuringPE = objTradingTransactionMasterDTO_OS.CDDuringPE;
                    ViewBag.HardCopyReq = objTradingTransactionMasterDTO_OS.HardCopyReq;
                    ViewBag.TransactionMasterId = objTradingTransactionMasterDTO_OS.TransactionMasterId;
                    ViewBag.nDisclosureTypeCodeId = objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId;
                    ViewBag.PreclearenceId = objTradingTransactionMasterDTO_OS.PreclearanceRequestId;
                    ViewBag.ShowDocumentTab = ShowDocumentTab;

                    if (ViewBag.nDisclosureTypeCodeId == InsiderTrading.Common.ConstEnum.Code.DisclosureTypeInitial)
                    {
                        FillGrid(ConstEnum.GridType.TradingTransaction_InitialDisclosure_for_Other_Securities_Self, ConstEnum.GridType.TradingTransaction_InitialDisclosure_for_Other_Securities_Relatives, acid, objLoginUserDetails, objTradingTransactionMasterDTO_OS.PreclearanceRequestId, Convert.ToInt32(objTradingTransactionMasterDTO_OS.TransactionMasterId), Convert.ToInt32(objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId), SecurityTypeCode, nUserInfoId, nUserTypeCodeId);
                        FillGrid(ConstEnum.GridType.TradingTransaction_InitialDisclosure_for_Other_Securities_Self, ConstEnum.GridType.TradingTransaction_InitialDisclosure_for_Other_Securities_Relatives, acid, objLoginUserDetails, objTradingTransactionMasterDTO_OS.PreclearanceRequestId, Convert.ToInt32(objTradingTransactionMasterDTO_OS.TransactionMasterId), Convert.ToInt32(objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId), SecurityTypeCode, nUserInfoId, nUserTypeCodeId);
                    }
                    else if (ViewBag.nDisclosureTypeCodeId == InsiderTrading.Common.ConstEnum.Code.DisclosureTypeContinuous)
                    {
                        FillGrid(ConstEnum.GridType.TradingTransaction_ContDisclosure_for_Other_Securities_Self, ConstEnum.GridType.TradingTransaction_ContDisclosure_for_Other_Securities_Relatives, acid, objLoginUserDetails, Convert.ToInt32(objTradingTransactionMasterDTO_OS.PreclearanceRequestId), Convert.ToInt32(objTradingTransactionMasterDTO_OS.TransactionMasterId), Convert.ToInt32(objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId), SecurityTypeCode, nUserInfoId, nUserTypeCodeId);
                        FillGrid(ConstEnum.GridType.TradingTransaction_ContDisclosure_for_Other_Securities_Self, ConstEnum.GridType.TradingTransaction_ContDisclosure_for_Other_Securities_Relatives, acid, objLoginUserDetails, Convert.ToInt32(objTradingTransactionMasterDTO_OS.PreclearanceRequestId), Convert.ToInt32(objTradingTransactionMasterDTO_OS.TransactionMasterId), Convert.ToInt32(objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId), SecurityTypeCode, nUserInfoId, nUserTypeCodeId);
                    }
                    //FillGridUploadedDocuments(ConstEnum.GridType.TransactionUploadedDocumentList, Convert.ToInt32(ConstEnum.Code.DisclosureTransaction), Convert.ToInt32(objTradingTransactionMasterDTO_OS.TransactionMasterId), acid);

                    if (objTradingTransactionMasterDTO_OS.PreclearanceRequestId != null && objTradingTransactionMasterDTO_OS.PreclearanceRequestId > 0)
                    {
                        TradingTransactionSummaryDTO_OS objTradingTransactionSummaryDTO_OS = new TradingTransactionSummaryDTO_OS();
                        objTradingTransactionSummaryDTO_OS = objTradingTransactionSL_OS.GetTransactionSummary(objLoginUserDetails.CompanyDBConnectionString, 0, Convert.ToInt64(objTradingTransactionMasterDTO_OS.PreclearanceRequestId));
                        ViewBag.ApprovedQuantity = Convert.ToInt64(objTradingTransactionSummaryDTO_OS.ApprovedQuantity).ToString("#,##0");
                        ViewBag.TradedQuantity = Convert.ToInt64(objTradingTransactionSummaryDTO_OS.TradedQuantity).ToString("#,##0"); ;
                        ViewBag.PendingQuantity = Convert.ToInt64(objTradingTransactionSummaryDTO_OS.PendingQuantity).ToString("#,##0"); ;
                    }

                    
                    using (TradingTransactionSL_OS objTradingTransactionSL_OSModule = new TradingTransactionSL_OS())
                    {
                        TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OSModule = null;
                        objTradingTransactionMasterDTO_OSModule = objTradingTransactionSL_OSModule.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                        ViewBag.EnableDisableQuantityValue = objTradingTransactionMasterDTO_OSModule.EnableDisableQuantityValue;
                    }

                    string panNumber = string.Empty;
                    string DateOfAcquisition = string.Empty;
                    string DateOfIntimation = string.Empty;
                    List<TradingTransactionMasterDTO_OS> lstPanNumber_OS = objTradingTransactionSL_OS.Get_PanNumber_OS(objTradingTransactionMasterDTO_OS, objLoginUserDetails.CompanyDBConnectionString);
                    foreach (var panNum in lstPanNumber_OS)
                    {
                        panNumber = panNum.PAN;
                        DateOfAcquisition = panNum.DateOfAcquisition;
                        DateOfIntimation = panNum.DateOfIntimation;
                    }
                    ViewBag.panNumber = panNumber;
                    ViewBag.DateOfAcquisition = DateOfAcquisition;
                    ViewBag.DateOfIntimation = DateOfIntimation;
                }

                using (CompaniesSL objCompaniesSL = new CompaniesSL())
                {
                    if (nDisclosureTypeCodeId == 0)
                    {
                        nDisclosureTypeCodeId = Convert.ToInt32(objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId);
                    }
                    objCompanySettingConfigurationDTO = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, Common.ConstEnum.Code.CompanyConfigType_EnterSettingOtherSecurities, nDisclosureTypeCodeId);

                    ImplementedCompanyDTO objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                    ViewBag.CompanyName = objImplementedCompanyDTO.CompanyName;

                    ViewBag.nConfigurationValueCodeId = 0;
                    if (objCompanySettingConfigurationDTO != null)
                    {
                        ViewBag.nConfigurationValueCodeId = objCompanySettingConfigurationDTO.ConfigurationValueCodeId;
                    }
                }
                ViewBag.IsTransactionSubmited = 0;

                if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                    ViewBag.IsfromView = frm;

                if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd && SecurityTypeCode != 0)
                {
                    ViewBag.IsfromView = 1;
                    ViewBag.TranactionMasterStatus = ConstEnum.Code.DisclosureStatusForConfirmed;
                    ViewBag.Showenterbutton = false;
                }
                else
                {
                    ViewBag.TranactionMasterStatus = objTradingTransactionMasterDTO_OS.TransactionStatusCodeId;
                }
                //Tushar
                //if (objTradingTransactionMasterDTO_OS.ConfirmCompanyHoldingsFor == null && objTradingTransactionMasterDTO_OS.ConfirmNonCompanyHoldingsFor != null)
                //{
                //    if (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.EmployeeType || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.CorporateUserType
                //        || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.NonEmployeeType || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.RelativeType)
                //    {
                //        if (objTradingTransactionMasterDTO_OS.TransactionStatusCodeId == ConstEnum.Code.DisclosureStatusForDocumentUploaded)
                //        {
                //            ViewBag.TranactionMasterStatus = ConstEnum.Code.DisclosureStatusForSubmitted;
                //            ViewBag.IsTransactionSubmitedByInsider = 1;
                //        }
                //    }
                //}
                ViewBag.NoHolding = objTradingTransactionMasterDTO_OS.NoHoldingFlag;
                ViewBag.nUserInfoId = objTradingTransactionMasterDTO_OS.UserInfoId;
                if ((objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType))
                {
                    ViewBag.ParentId = (ParentId == 0) ? nUserInfoId : ParentId;
                }
                else
                {
                    ViewBag.ParentId = ParentId;
                }
                ViewBag.UserAction = acid;
                ViewBag.CompanyName = objLoginUserDetails.CompanyName;

                //to check from where this page is called - currently used to return to per-clearance request page
                ViewBag.from = frm;
                ViewBag.Back_preclearance_id = PreclearanceRequestId;

                //check if login user is insider or CO/Admin, in case of Admin/CO set flag true else false
                bIsCOAdminUser = (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.COUserType) ? true : false;

                //set acid for letter base on disclosure type 
                int letter_acid = 0;
                switch (objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId)
                {
                    case ConstEnum.Code.DisclosureTypeInitial:
                        letter_acid = (bIsCOAdminUser) ? ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE_LETTER_SUBMISSION : ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE_LETTER_SUBMISSION;
                        break;
                    case ConstEnum.Code.DisclosureTypeContinuous:
                        letter_acid = (bIsCOAdminUser) ? ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION : ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION;
                        break;
                    case ConstEnum.Code.DisclosureTypePeriodEnd:
                        letter_acid = (bIsCOAdminUser) ? ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION : ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION;
                        break;
                }
                ViewBag.letter_acid = letter_acid;
                ViewBag.UserTypeCodeId = objLoginUserDetails.UserTypeCodeId;
                return View("View_OS", objTransactionModel_OS);

            }
            catch (Exception exp)
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.TransactionMasterId = 0;
                ViewBag.nDisclosureTypeCodeId = nDisclosureTypeCodeId;
                ViewBag.nUserInfoId = nUserInfoId;
                ViewBag.UserInfoId = nUserInfoId;
                ViewBag.CompanyName = "";
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("View_OS", objTransactionModel_OS);
            }
            finally
            {
                objLoginUserDetails = null;
                objTradingTransactionMasterDTO_OS = null;
                objTradingTransactionMasterDTO_OS_forTPSetting = null;
            }


        }
        #endregion TradinTransactionList

        #region Insider initial disclosure For Add Other Securities  (Other Securities)
        [AuthorizationPrivilegeFilter]
        public ActionResult OtherSecuritiesDetails(int acid = 0, int nUserInfoID = 0, int nTransactionMasterID = 0, int nSecurityTypeID = 0, int nTransactionTypeID = 0)
        {
            // Logic for Non - Implementing Company.
            LoginUserDetails objLoginUserDetails = null;
            TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.TransactionList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                ViewBag.TypeOfSecurityList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, true);
                ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);
                // objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                CreatePopulateData(372, 0, 155, 147001, 0, 0, 0, 0, 0);
                ViewBag.GridType = 114109;
                return View("OtherSecuritiesDetails");

            }
            catch (Exception exp)
            {
                ViewBag.GridType = 114109;
                return View("OtherSecuritiesDetails");
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion Insider initial disclosure For Add Other Securities  (Other Securities)
        

        #region TradingTransaction Submit Status
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult Submit(int nTradingTransactionMasterId, int nDisclosureTypecodeId, int acid, bool Chk_DeclaFrmInsContDis = false, bool bNoHolding = false, bool bDocumentStatus = false, int year = 0, int period = 0, int uid = 0, string __RequestVerificationToken = "", int formId = 0, int ParentId=0)
        {
            bool statusFlag = false;
            bool hardCopyReq = false;
            bool softCopReq = false;
            bool CDDuringPE = false;
            var ErrorDictionary = new Dictionary<string, string>();
            var redirectTo = string.Empty;
            var UserTypeCodeId = string.Empty;
            TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS = null;
            LoginUserDetails objLoginUserDetails = null;
            Common.Common objCommon = new Common.Common();
            var verify = Guid.NewGuid();
            int FormId = 0;
            try
            {
                //if (!objCommon.ValidateCSRFForAJAX())
                //{
                //    return Json(new
                //    {
                //        status = statusFlag,
                //        Message = ErrorDictionary
                //    }, JsonRequestBehavior.AllowGet);
                //}

                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                if (nDisclosureTypecodeId == InsiderTrading.Common.ConstEnum.Code.DisclosureTypeInitial)
                {
                    DataTable dt = new DataTable();

                    dt.Columns.Add(new DataColumn("TransactionMasterId", typeof(int)));
                    dt.Columns.Add(new DataColumn("SecurityTypeCodeId", typeof(int)));
                    dt.Columns.Add(new DataColumn("UserInfoId", typeof(int)));
                    dt.Columns.Add(new DataColumn("DMATDetailsID", typeof(int)));
                    dt.Columns.Add(new DataColumn("CompanyId", typeof(int)));
                    dt.Columns.Add(new DataColumn("ModeOfAcquisitionCodeId", typeof(int)));
                    dt.Columns.Add(new DataColumn("ExchangeCodeId", typeof(int)));
                    dt.Columns.Add(new DataColumn("TransactionTypeCodeId", typeof(int)));
                    dt.Columns.Add(new DataColumn("SecuritiesToBeTradedQty", typeof(decimal)));
                    dt.Columns.Add(new DataColumn("SecuritiesToBeTradedValue", typeof(decimal)));
                    dt.Columns.Add(new DataColumn("LotSize", typeof(int)));
                    dt.Columns.Add(new DataColumn("ContractSpecification", typeof(string)));

                    int rowCount = 0;
                    bool IsSave = false;
                    List<DuplicateTransactionDetailsDTO_OS> objDuplicateTransactionsDTO_OS = new List<DuplicateTransactionDetailsDTO_OS>();
                    using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                    {
                        objDuplicateTransactionsDTO_OS = objTradingTransactionSL_OS.CheckIntialDisclosureNoHolding_OS(objLoginUserDetails.CompanyDBConnectionString, nTradingTransactionMasterId);
                        foreach (var DmatItem in objDuplicateTransactionsDTO_OS)
                        {
                            DataRow dr = dt.NewRow();
                            dt.Rows.Add(dr);
                            dt.Rows[rowCount]["TransactionMasterId"] = nTradingTransactionMasterId;
                            dt.Rows[rowCount]["SecurityTypeCodeId"] = 0;
                            dt.Rows[rowCount]["UserInfoId"] = DmatItem.UserInfoID;
                            dt.Rows[rowCount]["DMATDetailsID"] = Convert.ToInt32(DmatItem.DMATDetailsID);
                            dt.Rows[rowCount]["CompanyId"] = 0;
                            dt.Rows[rowCount]["ModeOfAcquisitionCodeId"] = 149001;
                            dt.Rows[rowCount]["ExchangeCodeId"] = 116001;
                            dt.Rows[rowCount]["TransactionTypeCodeId"] = 143001;
                            dt.Rows[rowCount]["SecuritiesToBeTradedQty"] = 0;
                            dt.Rows[rowCount]["SecuritiesToBeTradedValue"] = 0;
                            dt.Rows[rowCount]["LotSize"] = 0;
                            dt.Rows[rowCount]["ContractSpecification"] = string.Empty;
                            rowCount = rowCount + 1;
                        }
                        if (rowCount != 0)
                            IsSave = objTradingTransactionSL_OS.InsertUpdateIDTradingTransactionDetails(objLoginUserDetails.CompanyDBConnectionString, dt);
                    }
                }

                objTradingTransactionMasterDTO_OS = new TradingTransactionMasterDTO_OS();
                objTradingTransactionMasterDTO_OS.TransactionMasterId = nTradingTransactionMasterId;
                objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId = nDisclosureTypecodeId;
                objTradingTransactionMasterDTO_OS.NoHoldingFlag = bNoHolding;

                if (bDocumentStatus)
                    objTradingTransactionMasterDTO_OS.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForDocumentUploaded;
                else
                    objTradingTransactionMasterDTO_OS.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForSubmitted;



                using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                {
                    TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_Details = objTradingTransactionSL_OS.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, nTradingTransactionMasterId);
                    if (objTradingTransactionMasterDTO_Details.TransactionStatusCodeId != objTradingTransactionMasterDTO_OS.TransactionStatusCodeId)
                    {
                        objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO_OS, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);
                        if (objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial && nDisclosureCompletedFlag == 1)
                        {
                            ErrorDictionary.Add("success", Common.Common.getResource("dis_msg_17344"));
                        }
                        else
                        {
                            ErrorDictionary.Add("success", Common.Common.getResource("tra_msg_16126"));
                        }
                    }
                    else
                    {
                        ErrorDictionary.Add("success", Common.Common.getResource("tra_msg_16126"));
                    }
                    statusFlag = true;
                    TradingTransactionMasterDTO_OS objTradingTransactionMasterDTOhardcopyReq = objTradingTransactionSL_OS.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, nTradingTransactionMasterId);
                    hardCopyReq = Convert.ToBoolean(objTradingTransactionMasterDTOhardcopyReq.HardCopyReq);
                    //CDDuringPE = Convert.ToBoolean(objTradingTransactionMasterDTOhardcopyReq.CDDuringPE);
                    softCopReq = Convert.ToBoolean(objTradingTransactionMasterDTOhardcopyReq.SoftCopyReq);
                    UserTypeCodeId = Convert.ToString(objLoginUserDetails.UserTypeCodeId);
                }
                TempData.Remove("SearchArray");              
                if (nDisclosureTypecodeId == 147001)
                {
                    FormId = 114;
                }
                else if (nDisclosureTypecodeId == 147002)
                {
                    FormId = 115;
                }
                else
                {
                    FormId = 116;
                }
            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                ErrorDictionary = GetModelStateErrorsAsString();
                if (nDisclosureTypecodeId == InsiderTrading.Common.ConstEnum.Code.DisclosureTypeContinuous)
                {
                    acid = Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION;
                }
                else
                {
                    acid = Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION;
                }
                using (var objUserInfoSL = new UserInfoSL())
                {
                    objUserInfoSL.DeleteFormToken(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objLoginUserDetails.LoggedInUserID), formId);
                }                
            }
            finally
            {
                objTradingTransactionMasterDTO_OS = null;
                objLoginUserDetails = null;
            }
            return Json(new
            {
                //public ActionResult SubmitSoftCopy(int acid, Int64 TransactionMasterId, int DisclosureTypeCodeId, long TransactionLetterId, int year = 0, int period = 0)
                UserTypeCodeId = UserTypeCodeId,                
                redirectTo = Url.Action("SubmitSoftCopy", "TradingTransaction_OS") + "?acid=" + acid +
                            "&TransactionMasterId=" + nTradingTransactionMasterId + "&DisclosureTypeCodeId=" + nDisclosureTypecodeId +
                            "&TransactionLetterId=0" + InsiderTrading.Common.ConstEnum.Code.DisclosureLetterUserInsider + "&year=" + year + "&period=" + period + "&uid=" + uid + "&__RequestVerificationToken=" + verify + "&formId" + FormId + "&ParentId=" + ParentId,

                CDDuringPE = CDDuringPE,
                softCopReq = softCopReq,
                hardCopyReq = hardCopyReq,
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion TradingTransaction Submit Status

        #region TradingTransaction not traded Status
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult TransactionNotTraded(int acid, int nPreclearenceId, int nReasonForNotTrading, string sReasonForNotTradingText, string __RequestVerificationToken = "", int formId = 0)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            LoginUserDetails objLoginUserDetails = null;
            PreclearanceRequestNonImplCompanyDTO objPreclearanceRequestNonImplCompanyDTO = null;
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
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                bool nPreclearanceNotTakenFlag = false;

                using (PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL())
                {
                    statusFlag = objPreclearanceRequestNonImplCompanySL.SavePreclearanceRequest_OS(objLoginUserDetails.CompanyDBConnectionString, null, nPreclearenceId, nPreclearanceNotTakenFlag, nReasonForNotTrading, sReasonForNotTradingText, objLoginUserDetails.LoggedInUserID, null, null, null, 0, null);

                    ErrorDictionary.Add("success", Common.Common.getResource("dis_msg_53053"));
                }
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
                objLoginUserDetails = null;
                objPreclearanceRequestNonImplCompanyDTO = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion TradingTransaction not traded Status

        #region TradingTransactionCreate/Edit get
        [AuthorizationPrivilegeFilter]
        [HttpGet]
        public ActionResult Create(int acid, int TransactionDetailsId = 0, Int64 TransactionMasterId = 0, int UserTypeCodeId = 0, int year = 0, int period = 0, int? SecurityTypeCodeId = null, int periodType = 0, string frm = "", int CompanyId = 0, int UserInfoId = 0)
        {
            TradingTransactionModel_OS objTransactionModel_OS = null;
            LoginUserDetails objLoginUserDetails = null;
            TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS = null;
            TradingPolicyDTO_OS objTradingPolicyDTO_OS = null;
            TradingTransactionDTO_OS objTradingTransactionDTO_OS = null;
            PreclearanceRequestNonImplCompanyDTO objPreclearanceRequestNonImplCompanyDTO = null;
            
            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO_OS = null;
            RestrictedListDTO objRestrictedListDTO = null;
            //ViewBag.ShowPopup = true;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                
                ViewBag.UserTypeCode = objLoginUserDetails.UserTypeCodeId;
                ViewBag.IsNegative = true;
                ViewBag.ShowTradeNote = false;

                ViewBag.UserTypeId = UserTypeCodeId;
                ViewBag.Frm = frm;
                ViewBag.ShowSaveAddMore_btn = true;          

                ViewBag.TypeOfSecurityList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, true);

                ////Tushar
                //if (TransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(TransactionMasterId), objLoginUserDetails.LoggedInUserID))
                //{
                //    return RedirectToAction("Unauthorised", "Home");
                //}

                using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                {

                    //Add New Code

                    var EnableDisableQuantityValue = 0;

                    // objTradingTransactionMasterDTO_OS objInsiderInitialDisclosureDTO = null;
                    objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    //RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                    EnableDisableQuantityValue = objTradingTransactionMasterDTO_OS.EnableDisableQuantityValue;
                    ViewBag.EnableDisableQuantityValue = objTradingTransactionMasterDTO_OS.EnableDisableQuantityValue;
                 


                    ////End OF New code

                    objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, TransactionMasterId);
                    
                    ViewBag.DisclosureTypeId = objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId;

                    if (objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId != ConstEnum.Code.DisclosureTypeInitial)
                    {
                        ViewBag.ShowSaveAddMore_btn = false;
                    }

                   

                    using (TradingPolicySL_OS objTradingPolicySL_OS = new TradingPolicySL_OS())
                    {
                        objTradingPolicyDTO_OS = objTradingPolicySL_OS.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO_OS.TradingPolicyId));

                        objTransactionModel_OS = new TradingTransactionModel_OS();

                        using (CompaniesSL objCompaniesSL = new CompaniesSL())
                        {
                            if (TransactionDetailsId > 0)
                            {
                                objTradingTransactionDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionDetails(objLoginUserDetails.CompanyDBConnectionString, TransactionDetailsId);

                                Common.Common.CopyObjectPropertyByName(objTradingTransactionDTO_OS, objTransactionModel_OS);

                            }
                            else
                            {
                                objTransactionModel_OS.CompanyId = CompanyId;
                                objTransactionModel_OS.SecurityTypeCodeId = Convert.ToInt32(SecurityTypeCodeId);
                                objTransactionModel_OS.TransactionMasterId = TransactionMasterId;
                                objTransactionModel_OS.UserTypeCodeId = UserTypeCodeId;

                            }
                        }

                        using (PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL())
                        {
                            if (Convert.ToInt64(objTradingTransactionMasterDTO_OS.PreclearanceRequestId) > 0)
                            {
                                objPreclearanceRequestNonImplCompanyDTO = objPreclearanceRequestNonImplCompanySL.GetPreclearanceRequestDetail(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt64(objTradingTransactionMasterDTO_OS.PreclearanceRequestId));

                                objTransactionModel_OS.TransactionTypeCodeId = Convert.ToInt32(objPreclearanceRequestNonImplCompanyDTO.TransactionTypeCodeId);
                                objTransactionModel_OS.ModeOfAcquisitionCodeId = Convert.ToInt32(objPreclearanceRequestNonImplCompanyDTO.ModeOfAcquisitionCodeId);

                                if (Convert.ToInt32(objPreclearanceRequestNonImplCompanyDTO.UserInfoIdRelative) > 0)
                                    objTransactionModel_OS.ForUserInfoId = Convert.ToInt32(objPreclearanceRequestNonImplCompanyDTO.UserInfoIdRelative);
                                else
                                    objTransactionModel_OS.ForUserInfoId = Convert.ToInt32(objPreclearanceRequestNonImplCompanyDTO.UserInfoId);

                                objTransactionModel_OS.DMATDetailsID = Convert.ToInt32(objPreclearanceRequestNonImplCompanyDTO.DMATDetailsID);
                                objTransactionModel_OS.CompanyId = Convert.ToInt32(objPreclearanceRequestNonImplCompanyDTO.CompanyId);
                                objTransactionModel_OS.CompanyName = objPreclearanceRequestNonImplCompanyDTO.CompanyName;

                                objTransactionModel_OS.b_IsInitialDisc = false;
                                objTransactionModel_OS.DateOfInitimationToCompany = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                            }
                            else
                            {
                                if (TransactionDetailsId <= 0 && objTransactionModel_OS.TransactionTypeCodeId != ConstEnum.Code.DisclosureTypeInitial)
                                {
                                    objTransactionModel_OS.DateOfInitimationToCompany = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                                }

                                objTransactionModel_OS.b_IsInitialDisc = true;
                            }
                            if (UserInfoId == 0)
                            {
                                UserInfoId = Convert.ToInt32(objTransactionModel_OS.ForUserInfoId);
                            }
                            if (TransactionDetailsId != 0 && UserTypeCodeId == ConstEnum.Code.RelativeType && Convert.ToInt64(objTradingTransactionMasterDTO_OS.PreclearanceRequestId) > 0)
                            {
                                UserInfoId = Convert.ToInt32(objTransactionModel_OS.ForUserInfoId);
                            }
                            if (objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId == 147002 && Convert.ToInt64(objTradingTransactionMasterDTO_OS.PreclearanceRequestId) > 0)
                            {
                                CreatePopulateData(UserInfoId, TransactionMasterId, acid, Convert.ToInt32(objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId), year, period, Convert.ToInt32(objTransactionModel_OS.SecurityTypeCodeId), Convert.ToInt64(objTradingTransactionMasterDTO_OS.PreclearanceRequestId), periodType, UserTypeCodeId);
                            }
                            else if (TransactionDetailsId > 0 && objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId == 147002)
                            {
                                CreatePopulateData(UserInfoId, TransactionMasterId, acid, Convert.ToInt32(objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId), year, period, Convert.ToInt32(objTransactionModel_OS.SecurityTypeCodeId), Convert.ToInt64(objTradingTransactionMasterDTO_OS.PreclearanceRequestId), periodType, UserTypeCodeId);
                            }
                            else
                            {
                                CreatePopulateData(Convert.ToInt32(objTradingTransactionMasterDTO_OS.UserInfoId), TransactionMasterId, acid, Convert.ToInt32(objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId), year, period, Convert.ToInt32(objTransactionModel_OS.SecurityTypeCodeId), Convert.ToInt64(objTradingTransactionMasterDTO_OS.PreclearanceRequestId), periodType, UserTypeCodeId);
                            }

                            objTransactionModel_OS.DateOfBecomingInsider = ViewBag.sDateOfBecomingInsider;
                            objApplicableTradingPolicyDetailsDTO_OS = objTradingPolicySL_OS.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO_OS.UserInfoId), TransactionMasterId);

                            //check if trading policy is define for user or not 
                            ////Tushar
                            //if (objApplicableTradingPolicyDetailsDTO_OS != null)
                            //{
                            //    ViewBag.GenCashAndCashlessPartialExciseOptionForContraTrade = objApplicableTradingPolicyDetailsDTO_OS.GenCashAndCashlessPartialExciseOptionForContraTrade;
                            //    ViewBag.UseExerciseSecurityPool = objApplicableTradingPolicyDetailsDTO_OS.UseExerciseSecurityPool;
                            //}

                            ////Tushar
                            //if (objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId != ConstEnum.Code.DisclosureTypeInitial)
                            //{
                            //    ExerciseBalancePoolDTO objExerciseBalancePoolDTO = new ExerciseBalancePoolDTO();
                            //    objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString,
                            //                               Convert.ToInt32(objTradingTransactionMasterDTO_OS.UserInfoId), ConstEnum.Code.SecurityTypeShares, objTransactionModel_OS.DMATDetailsID);

                            //    if (objExerciseBalancePoolDTO != null)
                            //    {
                            //        ViewBag.ESOPQuantity = objExerciseBalancePoolDTO.ESOPQuantity;
                            //        ViewBag.OtherQuantity = objExerciseBalancePoolDTO.OtherQuantity;
                            //    }
                            //    objTransactionModel_OS.b_IsInitialDisc = false;
                            //}
                        }
                    }

                    if (EnableDisableQuantityValue == 400002 || EnableDisableQuantityValue == 400003)
                    {
                        objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetQuantity(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId), Convert.ToInt32(objTradingTransactionMasterDTO_OS.UserInfoId));
                        ViewBag.Quantity = objTradingTransactionMasterDTO_OS.Quantity;
                        ViewBag.Value = objTradingTransactionMasterDTO_OS.Value;
                        ViewBag.LotSize = objTradingTransactionMasterDTO_OS.LotSize;
                        ViewBag.ContractSpecification = objTradingTransactionMasterDTO_OS.ContractSpecification;
                    }

                }


                ViewBag.ShowPopup = true;
                //get company name from RL_companymasterList table
                if (objTransactionModel_OS.TransactionDetailsId != 0)
                {
                    ViewBag.ShowSaveAddMore_btn = false;
                    using (RestrictedListSL objRestrictedListSL = new RestrictedListSL())
                    {
                        objRestrictedListDTO = objRestrictedListSL.GetRestrictedListCompanyDetails(objLoginUserDetails.CompanyDBConnectionString, objTransactionModel_OS.CompanyId);
                        objTransactionModel_OS.CompanyName = objRestrictedListDTO.CompanyName;
                        objTransactionModel_OS.CompanyId = (Int32)objRestrictedListDTO.RLCompanyId;
                    }
                }
                if (objTransactionModel_OS.DisclosureTypeCodeId != 147001)
                {
                    TradingTransactionDTO_OS TradingTransactionDTO_OS_SellAll = null;
                    using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                    {
                        TradingTransactionDTO_OS_SellAll = objTradingTransactionSL_OS.GetSellAllDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTransactionModel_OS.TransactionMasterId));
                    }
                    if (TradingTransactionDTO_OS_SellAll == null)
                    {
                        objTransactionModel_OS.SellAllFlag = false;
                        ViewBag.SellAllFlag = false;
                    }
                    else
                    {
                        objTransactionModel_OS.SellAllFlag = TradingTransactionDTO_OS_SellAll.SellAllFlag;
                        ViewBag.SellAllFlag = TradingTransactionDTO_OS_SellAll.SellAllFlag;
                    }
                }
                else
                {
                    objTransactionModel_OS.SellAllFlag = false;
                    ViewBag.SellAllFlag = false;
                }
                ViewBag.CompanyName = objLoginUserDetails.CompanyName;
                return View("Create_OS", objTransactionModel_OS);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View();
            }
            finally
            {
                objLoginUserDetails = null;
                objTradingTransactionMasterDTO_OS = null;
                objTradingPolicyDTO_OS = null;
                objTradingTransactionDTO_OS = null;
                objPreclearanceRequestNonImplCompanyDTO = null;
                objApplicableTradingPolicyDetailsDTO_OS = null;
            }
        }
        #endregion TradingTransactionCreate/Edit get

        #region TradingTransactionCreate/Edit post
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [Button(ButtonName = "Create")]
        [ActionName("Create")]
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(TradingTransactionModel_OS objTransactionModel_OS, int acid, int UserInfoId = 0, int DisclosureType = 0, int year = 0, int period = 0, long PreclearenceID = 0, int periodType = 0)
        {
            LoginUserDetails objLoginUserDetails = null;


            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO_OS = null;

            TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS = null;
            TradingPolicyDTO_OS objTradingPolicyDTO_OS = null;
            TradingTransactionDTO_OS objTradingTransactionDTO_OS = null;
            CompaniesSL objCompaniesSL1 = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            string nTransactionStatus = string.Empty;
            List<DuplicateTransactionDetailsDTO_OS> objDuplicateTransactionsDTO_OS = null;
            string alertMsg = string.Empty;
            string actionOne = string.Empty;
            string actionTwo = string.Empty;
            List<string> savedList = new List<string>();
            ViewBag.ShowPopup = false;
            ViewBag.UserInfoId = UserInfoId;
            //ViewBag.UserTypeCodeId = objTransactionModel_OS.UserTypeCodeId; 
            //Tushar
            string myHiddenInput = Request.Form["Hdn_AddMoreDetails"];
            ViewBag.SaveAndAddMore = myHiddenInput;
            int UserTypeId = Convert.ToInt32(Request.Form["Hdn_UserTypeCodeId"]);
            ViewBag.UserTypeId = UserTypeId;

            string Transaction_Frm = Request.Form["Hdn_From"];
            ViewBag.Frm = Transaction_Frm;
            ViewBag.ShowSaveAddMore_btn = true;

            ViewBag.DisclosureTypeId = DisclosureType;

            bool bIsValidDateOfAcquisition = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.IsNegative = true;
                ViewBag.UserTypeCode = objLoginUserDetails.UserTypeCodeId;
                ViewBag.postAcqNeMsg = Common.Common.getResource("tra_msg_16443");
                
                using (TradingTransactionSL_OS objTradingTransactionSL_OSModule = new TradingTransactionSL_OS())
                {
                    TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OSModule = null;
                    objTradingTransactionMasterDTO_OSModule = objTradingTransactionSL_OSModule.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    ViewBag.EnableDisableQuantityValue = Convert.ToInt32(objTradingTransactionMasterDTO_OSModule.EnableDisableQuantityValue);

                    if (ViewBag.EnableDisableQuantityValue == 400002 || ViewBag.EnableDisableQuantityValue == 400003)
                    {
                        objTradingTransactionMasterDTO_OSModule = null;
                        objTradingTransactionMasterDTO_OSModule = objTradingTransactionSL_OSModule.GetQuantity(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(DisclosureType), Convert.ToInt32(UserInfoId));
                        ViewBag.Quantity = objTradingTransactionMasterDTO_OSModule.Quantity;
                        ViewBag.Value = objTradingTransactionMasterDTO_OSModule.Value;
                        ViewBag.LotSize = objTradingTransactionMasterDTO_OSModule.LotSize;
                        ViewBag.ContractSpecification = objTradingTransactionMasterDTO_OSModule.ContractSpecification;
                    }
                }


                ////Tushar
                //if (objTransactionModel_OS.TransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(objTransactionModel_OS.TransactionMasterId), objLoginUserDetails.LoggedInUserID))
                //{
                //    return RedirectToAction("Unauthorised", "Home");
                //}

                CreatePopulateData(UserInfoId, objTransactionModel_OS.TransactionMasterId, acid, DisclosureType, year, period, objTransactionModel_OS.SecurityTypeCodeId, PreclearenceID, periodType, UserTypeId);
                ViewBag.TypeOfSecurityList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, true);

                objTransactionModel_OS.CompanyId = objTransactionModel_OS.CompanyId;
                objTransactionModel_OS.RLCompanyId = objTransactionModel_OS.CompanyId;

                using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                {
                    objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, objTransactionModel_OS.TransactionMasterId);

                    using (TradingPolicySL_OS objTradingPolicySL_OS = new TradingPolicySL_OS())
                    {
                        objTradingPolicyDTO_OS = objTradingPolicySL_OS.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO_OS.TradingPolicyId));

                        #region Validation Checks

                        if (objTransactionModel_OS.TransactionDetailsId != 0)
                        {
                            ViewBag.ShowSaveAddMore_btn = false;
                        }
                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial)
                        {
                            ViewBag.ShowSaveAddMore_btn = false;

                            if (objTransactionModel_OS.DateOfAcquisition == null)
                            {
                                ModelState.AddModelError("DateOfAcquisition", Common.Common.getResource("tra_msg_52097"));
                            }
                            else
                            {
                                if (objTransactionModel_OS.DateOfAcquisition > Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString))
                                {
                                    ModelState.AddModelError("DateOfAcquisition", Common.Common.getResource("tra_msg_52098"));
                                }
                                else
                                {
                                    bIsValidDateOfAcquisition = true;
                                }
                            }
                        }

                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial && objTransactionModel_OS.ModeOfAcquisitionCodeId <= 0)
                        {
                            ModelState.AddModelError("ModeOfAcquisitionCodeId", Common.Common.getResource("tra_msg_52099"));
                        }
                        ////Tushar
                        //if (objTransactionModel_OS.DateOfInitimationToCompany == null)
                        //{
                        //    ModelState.AddModelError("DateOfInitimationToCompany", Common.Common.getResource("tra_msg_16113"));
                        //}
                        //else
                        //{
                        //    if (objTransactionModel_OS.DateOfInitimationToCompany > Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString))
                        //    {
                        //        ModelState.AddModelError("DateOfInitimationToCompany", Common.Common.getResource("tra_msg_16114"));
                        //    }
                        //    if (objLoginUserDetails.UserTypeCodeId == Common.ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == Common.ConstEnum.Code.COUserType)
                        //    {
                        //        if (bIsValidDateOfAcquisition)
                        //        {
                        //            if (objTransactionModel_OS.DateOfInitimationToCompany < objTransactionModel_OS.DateOfAcquisition)
                        //            {
                        //                ModelState.AddModelError("DateOfInitimationToCompany", Common.Common.getResource("tra_msg_16332"));
                        //            }
                        //        }
                        //    }
                        //}

                        if (objTransactionModel_OS.ForUserInfoId <= 0)
                        {
                            ModelState.AddModelError("ForUserInfoId", Common.Common.getResource("tra_msg_52055"));
                        }

                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial && objTransactionModel_OS.ExchangeCodeId <= 0)
                        {
                            ModelState.AddModelError("ExchangeCodeId", Common.Common.getResource("tra_msg_52100"));
                        }

                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial && objTransactionModel_OS.TransactionTypeCodeId <= 0)
                        {
                            ModelState.AddModelError("TransactionTypeCodeId", Common.Common.getResource("tra_msg_52101"));
                        }

                        if (objTransactionModel_OS.DMATDetailsID <= 0)
                        {
                            ModelState.AddModelError("DMATDetailsID", Common.Common.getResource("tra_msg_52056"));
                        }

                        if (objTransactionModel_OS.SecurityTypeCodeId == 0)
                        {
                            ModelState.AddModelError("SecurityTypeCodeId", Common.Common.getResource("tra_msg_52057"));
                        }

                        if (objTransactionModel_OS.CompanyId == 0)
                        {
                            ModelState.AddModelError("CompanyName", Common.Common.getResource("tra_msg_52058"));
                        }

                        if (objTransactionModel_OS.Quantity == null || objTransactionModel_OS.Quantity <= 0)
                        {
                            ModelState.AddModelError("Quantity", Common.Common.getResource("tra_msg_52059"));
                        }

                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial)
                        {
                            if (objTransactionModel_OS.Value == null || objTransactionModel_OS.Value <= 0)
                            {
                                ModelState.AddModelError("Value", Common.Common.getResource("tra_msg_52102"));
                            }
                        }
                        if(objTransactionModel_OS.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeFutureContract
                            && objLoginUserDetails.CompanyName== "Myinsider_Shardul")
                        {
                            objTransactionModel_OS.LotSize = 1;
                            objTransactionModel_OS.ContractSpecification = null;
                        }
                          else  if (objTransactionModel_OS.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeOptionContract || objTransactionModel_OS.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeFutureContract)
                        {
                            if (objTransactionModel_OS.LotSize == null || objTransactionModel_OS.LotSize <= 0)
                            {
                                ModelState.AddModelError("LotSize", Common.Common.getResource("tra_msg_52060"));
                            }
                            if (objTransactionModel_OS.ContractSpecification == null || objTransactionModel_OS.ContractSpecification == "")
                            {
                                ModelState.AddModelError("ContractSpecification", Common.Common.getResource("tra_msg_52061"));
                            }
                        }
                        else
                        {
                            objTransactionModel_OS.LotSize = 0;
                            objTransactionModel_OS.ContractSpecification = null;

                        }

                        if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            objDuplicateTransactionsDTO_OS = objTradingTransactionSL_OS.CheckDuplicateTransaction_OS(objLoginUserDetails.CompanyDBConnectionString, objTransactionModel_OS.ForUserInfoId, objTransactionModel_OS.DMATDetailsID, objTransactionModel_OS.SecurityTypeCodeId, objTransactionModel_OS.CompanyId, objTransactionModel_OS.TransactionDetailsId);
                            if (objDuplicateTransactionsDTO_OS.Count != 0)
                            {
                                ModelState.AddModelError("DupliTransaction", Common.Common.getResource("tra_msg_52067"));
                            }
                        }

                        #endregion Validation Checks
                        if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            objTransactionModel_OS.TransactionTypeCodeId = ConstEnum.Code.TransactionTypeBuy;
                            objTransactionModel_OS.ExchangeCodeId = ConstEnum.Code.StockExchange_NSE;
                            objTransactionModel_OS.b_IsInitialDisc = true;
                            if (objTransactionModel_OS.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeSell)
                            {
                                objTransactionModel_OS.ModeOfAcquisitionCodeId = ConstEnum.Code.ModeOfAcquisition_MarketSale;
                            }
                            else
                            {
                                objTransactionModel_OS.ModeOfAcquisitionCodeId = ConstEnum.Code.ModeOfAcquisition_MarketPurchase;
                            }
                        }
                        else
                        {
                            objTransactionModel_OS.b_IsInitialDisc = false;
                        }
                        if (!ModelState.IsValid)
                        {
                            CreatePopulateData(UserInfoId, objTransactionModel_OS.TransactionMasterId, acid, DisclosureType, year, period, objTransactionModel_OS.SecurityTypeCodeId, PreclearenceID, periodType, UserTypeId);
                            objTransactionModel_OS.DateOfBecomingInsider = ViewBag.sDateOfBecomingInsider;
                            objApplicableTradingPolicyDetailsDTO_OS = objTradingPolicySL_OS.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objTransactionModel_OS.TransactionMasterId);

                            ////check if trading policy is define for user or not 
                            //if (objApplicableTradingPolicyDetailsDTO_OS != null)
                            //{
                            //    ViewBag.GenCashAndCashlessPartialExciseOptionForContraTrade = objApplicableTradingPolicyDetailsDTO_OS.GenCashAndCashlessPartialExciseOptionForContraTrade;
                            //    ViewBag.UseExerciseSecurityPool = objApplicableTradingPolicyDetailsDTO_OS.UseExerciseSecurityPool;
                            //}

                            return PartialView("Create_OS", objTransactionModel_OS);
                        }
                    }

                    objTradingTransactionDTO_OS = new TradingTransactionDTO_OS();

                    Common.Common.CopyObjectPropertyByName(objTransactionModel_OS, objTradingTransactionDTO_OS);
                    //For Employers and Insiders the DateOfIntemition to the company should always be the date when Insider Submitts the details. 
                    //So it is handled in the Submit procedure. For CO type user the date modified by user is saved against the transaction, the date should be >= date of acquisition
                    if (objLoginUserDetails.UserTypeCodeId != Common.ConstEnum.Code.Admin && objLoginUserDetails.UserTypeCodeId != Common.ConstEnum.Code.COUserType)
                    {
                        objTradingTransactionDTO_OS.DateOfInitimationToCompany = null;
                    }

                    objTradingTransactionDTO_OS.TransactionMasterId = Convert.ToInt32(objTradingTransactionMasterDTO_OS.TransactionMasterId);
                    objTradingTransactionDTO_OS.LoggedInUserId = Convert.ToInt32(objLoginUserDetails.LoggedInUserID);
                    objTradingTransactionDTO_OS.OtherExcerciseOptionQty = objTransactionModel_OS.Quantity;  
                    objTradingTransactionDTO_OS = objTradingTransactionSL_OS.InsertUpdateTradingTransactionDetails(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionDTO_OS, UserInfoId);
                    
                    objTradingTransactionDTO_OS.SellAllFlag = objTransactionModel_OS.SellAllFlag;
                    if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial)
                    {
                        objTradingTransactionDTO_OS = objTradingTransactionSL_OS.InsertUpdateSellAllDetails(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionDTO_OS, UserInfoId);
                    }
                        
                    

                }
                if (DisclosureType != InsiderTrading.Common.ConstEnum.Code.DisclosureTypeInitial)
                    ViewBag.UserTypeId = objTradingTransactionDTO_OS.UserTypeCodeId;

                return PartialView("Create_OS", objTransactionModel_OS).Success(Common.Common.getResource("tra_msg_16186"));

            }
            catch (Exception exp)
            {
                ViewBag.IsNegative = true;
                string sErrMessage;
                if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                {
                    objTransactionModel_OS.b_IsInitialDisc = true;
                }
                else
                {
                    ViewBag.ShowSaveAddMore_btn = false;
                    objTransactionModel_OS.b_IsInitialDisc = false;
                }
                CreatePopulateData(UserInfoId, objTransactionModel_OS.TransactionMasterId, acid, DisclosureType, year, period, objTransactionModel_OS.SecurityTypeCodeId, PreclearenceID, periodType, UserTypeId);
                objTransactionModel_OS.DateOfBecomingInsider = ViewBag.sDateOfBecomingInsider;
                using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                {
                    objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, objTransactionModel_OS.TransactionMasterId);

                    using (TradingPolicySL_OS objTradingPolicySL_OS = new TradingPolicySL_OS())
                    {
                        objApplicableTradingPolicyDetailsDTO_OS = objTradingPolicySL_OS.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objTransactionModel_OS.TransactionMasterId);

                        objTradingPolicyDTO_OS = objTradingPolicySL_OS.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO_OS.TradingPolicyId));

                        ////check if trading policy is define for user or not 
                        //if (objApplicableTradingPolicyDetailsDTO_OS != null)
                        //{
                        //    ViewBag.GenCashAndCashlessPartialExciseOptionForContraTrade = objApplicableTradingPolicyDetailsDTO_OS.GenCashAndCashlessPartialExciseOptionForContraTrade;
                        //    ViewBag.UseExerciseSecurityPool = objApplicableTradingPolicyDetailsDTO_OS.UseExerciseSecurityPool;
                        //}
                    }

                }

                ViewBag.postAcqNeMsg = Common.Common.getResource("tra_msg_16443");

                sErrMessage = Common.Common.GetErrorMessage(exp);// Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);

                if (objTransactionModel_OS.TransactionDetailsId != 0)
                {
                    ViewBag.ShowSaveAddMore_btn = false;
                }

                return PartialView("Create_OS", objTransactionModel_OS);
            }
            finally
            {
                objTradingTransactionMasterDTO_OS = null;
                objLoginUserDetails = null;
                objTradingPolicyDTO_OS = null;
                objTradingTransactionDTO_OS = null;
                objCompaniesSL1 = null;
                objImplementedCompanyDTO = null;
            }
        }
        #endregion TradingTransactionCreate/Edit post

        public ActionResult Test()
        {
            return View();
        }

        #region DeleteTradingTransaction
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult Delete(int acid, int TradingTransactionId)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();

            LoginUserDetails objLoginUserDetails = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                {
                    objTradingTransactionSL_OS.DeleteTradingTransactionDetails(objLoginUserDetails.CompanyDBConnectionString, TradingTransactionId, objLoginUserDetails.LoggedInUserID);
                    statusFlag = true;
                    ErrorDictionary.Add("success", Common.Common.getResource("tra_msg_16128"));
                }
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
                objLoginUserDetails = null;
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
        #endregion DeleteTradingTransaction

        #region DeleteTradingTransactionMaster
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public JsonResult DeleteMaster(int acid, int TradingTransactionMasterId)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();

            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                if (TradingTransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(TradingTransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    ModelState.Remove("KEY");
                    ModelState.Add("KEY", new ModelState());
                    ModelState.Clear();
                    string sErrMessage = "You are not authorized to perform this action. ";
                    ModelState.AddModelError("error", sErrMessage);
                    ErrorDictionary = GetModelStateErrorsAsString();
                }
                else
                {
                    using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                    {
                        objTradingTransactionSL_OS.DeleteTradingTransactionMaster(objLoginUserDetails.CompanyDBConnectionString, TradingTransactionMasterId, objLoginUserDetails.LoggedInUserID);
                        statusFlag = true;
                        ErrorDictionary.Add("success", Common.Common.getResource("tra_msg_16128"));
                    }
                }

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
                objLoginUserDetails = null;
            }

            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion DeleteTradingTransactionMaster

        #region IsVisibleTradingTransactionElement
        public static bool IsVisibleTradingTransactionElement(string property, int nDisclosureType, int nSecurityType)
        {
            bool bflag = true;

            List<String> lstElements = null;
            List<String> lstIncludeElements = null;

            try
            {
                lstElements = new List<string>() { "DateOfAcquisition", "SecuritiesPriorToAcquisition",
                "PerOfSharesPostTransaction", "TransactionTypeCodeId", "Quantity2", "Value2" };

                //Security type check to show hide values according to selection.
                lstIncludeElements = new List<string>();
                if (nSecurityType != ConstEnum.Code.SecurityTypeFutureContract && nSecurityType != ConstEnum.Code.SecurityTypeOptionContract)
                {
                    lstIncludeElements.Add("LotSize");
                    lstIncludeElements.Add("ContractSpecification");
                }
                else
                {
                    lstIncludeElements.Add("PerOfSharesPreTransaction");
                    lstIncludeElements.Add("PerOfSharesPostTransaction");
                }

                if (nDisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                {
                    if (lstElements.Contains(property) || lstIncludeElements.Contains(property))
                        bflag = false;
                }
                else
                {
                    if (lstIncludeElements.Contains(property))
                        bflag = false;
                }
            }
            finally
            {
                lstElements = null;
                lstIncludeElements = null;
            }

            return bflag;
        }
        #endregion IsVisibleTradingTransactionElement

        #region Create Letter
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult CreateLetter(int acid, Int64 nTransactionMasterId, int nDisclosureTypeCodeId, int nLetterForCodeId, Int64 nTransactionLetterId = 0, int year = 0, int period = 0, bool IsStockExchange = false, int pdtypeId = 0, string pdtype = null, int uid = 0)
        {
            TransactionLetterModel objTransactionLetterModel = null;
            TemplateMasterDTO objTemplateMasterDTO = null;
            LoginUserDetails objLoginUserDetails = null;
            ViewBag.IsFormCSubmitted = false;

            int nCommunicationModeCodeId = ConstEnum.Code.CommunicationModeForLetter;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                ViewBag.UserTypeCode = objLoginUserDetails.UserTypeCodeId;

                if (nTransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(nTransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                if (IsStockExchange)
                {
                    nLetterForCodeId = ConstEnum.Code.DisclosureLetterUserCO;
                }
                else
                {
                    nLetterForCodeId = ConstEnum.Code.DisclosureLetterUserInsider;
                }

                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTransactionLetterModel = new TransactionLetterModel();

                    objTemplateMasterDTO = objTradingTransactionSL.GetTransactionLetterDetails(objLoginUserDetails.CompanyDBConnectionString, nTransactionLetterId, nTransactionMasterId, nDisclosureTypeCodeId, nLetterForCodeId, nCommunicationModeCodeId);
                    Common.Common.CopyObjectPropertyByName(objTemplateMasterDTO, objTransactionLetterModel);
                    if (objTemplateMasterDTO.IsActive)
                    {
                        objTransactionLetterModel.ToAddress1 = objTransactionLetterModel.ToAddress1.Replace("\\r\\n", Environment.NewLine);

                        if (objTransactionLetterModel.ToAddress2 != null)
                        {
                            objTransactionLetterModel.ToAddress2 = objTransactionLetterModel.ToAddress2.Replace("\\r\\n", Environment.NewLine);
                        }

                        objTransactionLetterModel.Subject = objTransactionLetterModel.Subject.Replace("\\r\\n", Environment.NewLine);
                        objTransactionLetterModel.Contents = objTransactionLetterModel.Contents.Replace("\\r\\n", Environment.NewLine);
                        objTransactionLetterModel.Signature = objTransactionLetterModel.Signature.Replace("\\r\\n", Environment.NewLine);
                    }
                    objTransactionLetterModel.TransactionMasterId = nTransactionMasterId;
                    objTransactionLetterModel.DisclosureTypeCodeId = nDisclosureTypeCodeId;

                    if (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.COUserType)
                    {
                        if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            ViewBag.OverrideGridType = Convert.ToString(ConstEnum.GridType.TradingTransaction_ForLetter_InitialDisclosure_CO);
                        }
                        else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                        {
                            ViewBag.OverrideGridType = Convert.ToString(ConstEnum.GridType.TradingTransaction_ForLetter_ContinuousDisclosure_CO);
                        }
                        else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                        {
                            ViewBag.OverrideGridType = Convert.ToString(ConstEnum.GridType.TradingTransaction_ForLetter_PeriodEndDisclosure_CO);
                        }
                    }
                    else
                    {
                        if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            ViewBag.OverrideGridType = Convert.ToString(ConstEnum.GridType.TradingTransaction_ForLetter_InitialDisclosure_Insider);
                        }
                        else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                        {
                            ViewBag.OverrideGridType = Convert.ToString(ConstEnum.GridType.TradingTransaction_ForLetter_ContinuousDisclosure_Insider);
                        }
                        else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                        {
                            ViewBag.OverrideGridType = Convert.ToString(ConstEnum.GridType.TradingTransaction_ForLetter_PeriodEndDisclosure_Insider);
                        }
                    }
                    if (objTransactionLetterModel.TransactionLetterId >= 0)
                    {
                        DateTime currentDBDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                        objTransactionLetterModel.Date = currentDBDate;
                    }

                    //Follwoing code to set company logo need to be remove after column for company logo is added into table
                    objTransactionLetterModel.CompanyLogo = "images/logo-splash.png";
                }

                ViewBag.UserAction = acid;
                ViewBag.GridType = ConstEnum.GridType.TradingTransactionDetails;
                ViewBag.PeriodEndYear = year;
                ViewBag.PeriodEndPeriod = period;
                ViewBag.IsStockExchange = IsStockExchange;
                ViewBag.PeriodType = pdtype;
                ViewBag.PeriodTypeId = pdtypeId;
                ViewBag.uid = uid;

                //if (objLoginUserDetails.UserTypeCodeId != ConstEnum.Code.Admin && objLoginUserDetails.UserTypeCodeId != InsiderTrading.Common.ConstEnum.Code.COUserType)
                //{
                //using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                //{
                //    objTemplateMasterDTO = new TemplateMasterDTO();

                //    Common.Common.CopyObjectPropertyByName(objTransactionLetterModel, objTemplateMasterDTO);
                //    if (objTemplateMasterDTO.IsActive)
                //    {
                //        objTemplateMasterDTO = objTradingTransactionSL.InsertUpdateTradingTransactionLetterDetails(objLoginUserDetails.CompanyDBConnectionString, objTemplateMasterDTO, objLoginUserDetails.LoggedInUserID);
                //    }
                //}
                var verify = Guid.NewGuid();
                int FormId = 0;
                if (nDisclosureTypeCodeId == 147001)
                {
                    FormId = 114;
                }
                else if (nDisclosureTypeCodeId == 147002)
                {
                    FormId = 115;
                }
                else
                {
                    FormId = 116;
                }
                return RedirectToAction("SubmitSoftCopy", "TradingTransaction", new { acid = Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION, TransactionMasterId = nTransactionMasterId, DisclosureTypeCodeId = nDisclosureTypeCodeId, TransactionLetterId = InsiderTrading.Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_STOCK_EXCHANGE_SUBMISSION, year = year, period = period, __RequestVerificationToken = verify, formId = FormId });
                //}
                //else
                //{
                //    return View("CreateLetter", objTransactionLetterModel);
                //}
            }
            catch (Exception exp)
            {
                objTemplateMasterDTO = null;
                objLoginUserDetails = null;
            }
            finally
            {

            }
            return View("CreateLetter");
        }
        #endregion Create Letter

        #region Save/Update Letter Details
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "SaveLetter")]
        [ActionName("CreateLetter")]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveLetter(TransactionLetterModel objTransactionLetterModel, int year = 0, bool IsStockExchange = false, int period = 0, int pdtypeId = 0, string pdtype = null)
        {
            int acid = 0;
            LoginUserDetails objLoginUserDetails = null;
            TemplateMasterDTO objTemplateMasterDTO = null;
            TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
            PrintTemplateModel objPrintTemplateModel = null;
            int? nUserInfoIdLetterFor = 0;
            Dictionary<string, object> dicPeriodStartEnd = null;
            UserInfoDTO objUserInfoLetterFor = new UserInfoDTO();
            ViewBag.ShowNote = false;
            // objTransactionLetterModel.DisclosureTypeCodeId = 147002;
            try
            {
                if (Request.Params["authorization"] != null && Request.Params["authorization"] != "")
                {
                    acid = Convert.ToInt32(Request.Params["authorization"].Split(':')[1]);
                }

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (objTransactionLetterModel.TransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(objTransactionLetterModel.TransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                objPrintTemplateModel = new PrintTemplateModel();

                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTemplateMasterDTO = new TemplateMasterDTO();

                    Common.Common.CopyObjectPropertyByName(objTransactionLetterModel, objTemplateMasterDTO);
                    if (objTemplateMasterDTO.IsActive)
                    {
                        objTemplateMasterDTO = objTradingTransactionSL.InsertUpdateTradingTransactionLetterDetails(objLoginUserDetails.CompanyDBConnectionString, objTemplateMasterDTO, objLoginUserDetails.LoggedInUserID);
                    }
                    objTransactionLetterModel.TransactionLetterId = objTemplateMasterDTO.TransactionLetterId;

                    if (objTransactionLetterModel.TransactionLetterId == 0)
                    {
                        DateTime currentDBDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                        objTransactionLetterModel.Date = currentDBDate;
                    }

                    if (period != 0 && pdtypeId != 0)
                    {
                        using (PeriodEndDisclosureSL objPeriodEndDisclosure = new PeriodEndDisclosureSL())
                        {
                            dicPeriodStartEnd = objPeriodEndDisclosure.GetPeriodStarEndDate(objLoginUserDetails.CompanyDBConnectionString, year, period, pdtypeId);

                            DateTime dtStartDate = Convert.ToDateTime(dicPeriodStartEnd["start_date"]);
                            DateTime dtEndDate = Convert.ToDateTime(dicPeriodStartEnd["end_date"]);
                            String dtFormat = "dd/MMM/yyyy";
                            ViewBag.PeriodStartDate = dtStartDate.ToString(dtFormat);
                            ViewBag.PeriodEndDate = dtEndDate.ToString(dtFormat);
                        }
                    }

                    //Hard Core Need to change when path column is inserted in database
                    ViewBag.CompanyLogo = objLoginUserDetails.CompanyLogoURL;
                    ViewBag.transactionMasterId = objTransactionLetterModel.TransactionMasterId;
                    ViewBag.DisclosureTypeCodeId = objTransactionLetterModel.DisclosureTypeCodeId;
                    //objPrintTemplateModel.transactionLetterModel = objTransactionLetterModel;
                    ViewBag.Layout = "~/Views/shared/_Layout.cshtml";
                    ViewBag.EditLetter = true;
                    ViewBag.acid = acid;
                    ViewBag.year = year;
                    ViewBag.IsStockExchange = IsStockExchange;
                    ViewBag.Period = period;
                    ViewBag.PeriodType = pdtype;
                    ViewBag.IsFormCSubmitted = false;
                    objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, objTransactionLetterModel.TransactionMasterId);
                    ViewBag.UserId = (int)objTradingTransactionMasterDTO.UserInfoId;
                    nUserInfoIdLetterFor = objTradingTransactionMasterDTO.UserInfoId;
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoLetterFor = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, (int)nUserInfoIdLetterFor);

                        //check user type and set employee id and employee name/company name to be shown on letter after signature
                        if (objUserInfoLetterFor.UserTypeCodeId == ConstEnum.Code.CorporateUserType)
                        {
                            ViewBag.employeeId = null;
                            ViewBag.Name = "Company Name :  " + objUserInfoLetterFor.CompanyName;
                        }
                        else if (objUserInfoLetterFor.UserTypeCodeId == ConstEnum.Code.EmployeeType)
                        {
                            ViewBag.employeeId = "Employee Id :  " + objUserInfoLetterFor.EmployeeId;
                            ViewBag.Name = "Employee Name :  " + objUserInfoLetterFor.FirstName + " " + objUserInfoLetterFor.LastName;
                        }
                        else if (objUserInfoLetterFor.UserTypeCodeId == ConstEnum.Code.NonEmployeeType)
                        {
                            ViewBag.employeeId = "Employee Id :  " + objUserInfoLetterFor.EmployeeId;
                            ViewBag.Name = "Name :  " + objUserInfoLetterFor.FirstName + " " + objUserInfoLetterFor.LastName;
                        }
                    }
                    objTransactionLetterModel.LetterForUserDesignation = objUserInfoLetterFor.DesignationName;
                    objPrintTemplateModel.transactionLetterModel = objTransactionLetterModel;
                    using (CompaniesSL objCompaniesSL = new CompaniesSL())
                    {
                        ImplementedCompanyDTO objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                        ViewBag.CompanyName = objImplementedCompanyDTO.CompanyName;
                        ViewBag.CompanyISINNumber = objImplementedCompanyDTO.ISINNumber;
                    }

                    #region Set Grid Type
                    if (objTransactionLetterModel.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                    {
                        ViewBag.GridType = ConstEnum.GridType.InitialDisclosureLetterList;
                        ViewBag.GridType2 = ConstEnum.GridType.InitialDisclosureLetterListGrid2;
                    }
                    else if (objTransactionLetterModel.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                    {
                        if (objUserInfoLetterFor.UserTypeCodeId == ConstEnum.Code.NonEmployeeType || objUserInfoLetterFor.UserTypeCodeId == ConstEnum.Code.CorporateUserType)
                        {
                            ViewBag.GridType = ConstEnum.GridType.ContinuousDisclosureDataForLetterForNonEmployeeInsider;
                            ViewBag.GridType2 = ConstEnum.GridType.ContinuousDisclosureDataForLetterForNonEmployeeInsiderGrid2;
                        }
                        else
                        {
                            ViewBag.GridType = ConstEnum.GridType.ContinuousDisclosureDataForLetterForEmployeeInsider;
                            ViewBag.GridType2 = ConstEnum.GridType.ContinuousDisclosureDataForLetterForEmployeeInsiderGrid2;
                        }
                    }
                    else if (objTransactionLetterModel.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                    {
                        ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosureDataForLetterForEmployeeInsiderGrid1;
                        ViewBag.GridType2 = ConstEnum.GridType.PeriodEndDisclosureDataForLetterForEmployeeInsiderGrid2;
                    }
                    #endregion Set Grid Type
                }

                ModelState.Clear();

                if (IsStockExchange)
                {
                    objPrintTemplateModel.StockExchangeDocument = Common.Common.GenerateDocumentList(ConstEnum.Code.DisclosureTransaction, 0, 0, null, ConstEnum.Code.HardCopyByCOToExchange);
                    DateTime cur_date = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                    ViewBag.dtCurrent = Common.Common.ApplyFormatting(cur_date, Common.ConstEnum.DataFormatType.Date);
                    return View("~/Views/Pdf/StockExchangeLetterDetails.cshtml", objPrintTemplateModel);
                }
                else
                {
                    return View("~/Views/Pdf/TransactionDetails.cshtml", objPrintTemplateModel);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                objLoginUserDetails = null;
                objTemplateMasterDTO = null;
                objTradingTransactionMasterDTO = null;
            }

        }
        #endregion Save/Update Letter Details

        #region ViewLetter
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult ViewLetter(Int64 nTransactionMasterId, int nDisclosureTypeCodeId, int nLetterForCodeId, int acid, Int64 nTransactionLetterId = 0, int year = 0, int period = 0, int pdtypeId = 0, string pdtype = null, int uid = 0)
        {
            //const string sLookUpPrefix = "tra_msg_";

            LoginUserDetails objLoginUserDetails = null;
            TemplateMasterDTO objTemplateMasterDTO = null;
            TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
            UserInfoDTO objUserInfoDTO = null;
            Dictionary<string, object> dicPeriodStartEnd = null;
            ViewBag.acid = acid;
            ViewBag.ShowNote = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (nTransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(nTransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                int nCommunicationModeCodeId = ConstEnum.Code.CommunicationModeForLetter;
                TransactionLetterModel objTransactionLetterModel = new TransactionLetterModel();
                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTemplateMasterDTO = objTradingTransactionSL.GetTransactionLetterDetails(objLoginUserDetails.CompanyDBConnectionString, nTransactionLetterId, nTransactionMasterId, nDisclosureTypeCodeId, nLetterForCodeId, nCommunicationModeCodeId);

                    Common.Common.CopyObjectPropertyByName(objTemplateMasterDTO, objTransactionLetterModel);

                    objTransactionLetterModel.TransactionMasterId = nTransactionMasterId;
                    objTransactionLetterModel.DisclosureTypeCodeId = nDisclosureTypeCodeId;
                    //objTransactionLetterModel.DisclosureTypeCodeId = 147002;
                    objTransactionLetterModel.CompanyLogo = objLoginUserDetails.CompanyLogoURL;
                    if (objTransactionLetterModel.TransactionLetterId == 0)
                    {
                        DateTime currentDBDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                        objTransactionLetterModel.Date = currentDBDate;
                    }
                    if (period != 0 && pdtypeId != 0)
                    {
                        using (PeriodEndDisclosureSL objPeriodEndDisclosure = new PeriodEndDisclosureSL())
                        {
                            dicPeriodStartEnd = objPeriodEndDisclosure.GetPeriodStarEndDate(objLoginUserDetails.CompanyDBConnectionString, year, period, pdtypeId);

                            DateTime dtStartDate = Convert.ToDateTime(dicPeriodStartEnd["start_date"]);
                            DateTime dtEndDate = Convert.ToDateTime(dicPeriodStartEnd["end_date"]);
                            String dtFormat = "dd/MMM/yyyy";
                            ViewBag.PeriodStartDate = dtStartDate.ToString(dtFormat);
                            ViewBag.PeriodEndDate = dtEndDate.ToString(dtFormat);
                        }
                    }
                    ViewBag.year = year;
                    ViewBag.Period = period;
                    ViewBag.EditLetter = false;
                    ViewBag.PeriodType = pdtype;
                    ViewBag.Layout = "~/Views/shared/_Layout.cshtml";
                    ViewBag.acid = acid;
                    objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, nTransactionMasterId);
                    if (uid != 0)
                        ViewBag.UserId = (int)objTradingTransactionMasterDTO.UserInfoId;
                    else
                        ViewBag.UserId = uid;

                    ViewBag.transactionStatus = objTradingTransactionMasterDTO.TransactionStatusCodeId;
                    ViewBag.IsFormCSubmitted = true;
                    ViewBag.DisclosureTypeCodeId = objTransactionLetterModel.DisclosureTypeCodeId;

                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, (int)objTradingTransactionMasterDTO.UserInfoId);
                        ViewBag.CompanyName = objUserInfoDTO.CompanyName;
                        ViewBag.CompanyISINNumber = objUserInfoDTO.ISINNumber;
                        if (nDisclosureTypeCodeId == InsiderTrading.Common.ConstEnum.Code.DisclosureTypeContinuous && (acid == InsiderTrading.Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION || acid == InsiderTrading.Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION) && objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.EmployeeType && objLoginUserDetails.CompanyName.Contains(InsiderTrading.Common.ConstEnum.CLIENT_DB_NAME))
                        {
                            ViewBag.ShowNote = true;
                        }

                        //check user type and set employee id and employee name/company name to be shown on letter after signature
                        if (objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.CorporateUserType)
                        {
                            ViewBag.employeeId = null;
                            ViewBag.Name = "Company Name :  " + objUserInfoDTO.CompanyName;
                        }
                        else if (objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.EmployeeType)
                        {
                            ViewBag.employeeId = "Employee Id :  " + objUserInfoDTO.EmployeeId;
                            ViewBag.Name = "Employee Name :  " + objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
                        }
                        else if (objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.NonEmployeeType)
                        {
                            ViewBag.employeeId = "Employee Id :  " + objUserInfoDTO.EmployeeId;
                            ViewBag.Name = "Name :  " + objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
                        }
                    }

                    #region Set Grid Type
                    if (objTransactionLetterModel.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                    {
                        ViewBag.GridType = ConstEnum.GridType.InitialDisclosureLetterList;
                        ViewBag.GridType2 = ConstEnum.GridType.InitialDisclosureLetterListGrid2;
                    }
                    else if (objTransactionLetterModel.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                    {
                        if (objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.NonEmployeeType || objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.CorporateUserType)
                        {
                            ViewBag.GridType = ConstEnum.GridType.ContinuousDisclosureDataForLetterForNonEmployeeInsider;
                            ViewBag.GridType2 = ConstEnum.GridType.ContinuousDisclosureDataForLetterForNonEmployeeInsiderGrid2;
                        }
                        else
                        {
                            ViewBag.GridType = ConstEnum.GridType.ContinuousDisclosureDataForLetterForEmployeeInsider;
                            ViewBag.GridType2 = ConstEnum.GridType.ContinuousDisclosureDataForLetterForEmployeeInsiderGrid2;
                        }
                    }
                    else if (objTransactionLetterModel.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                    {
                        ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosureDataForLetterForEmployeeInsiderGrid1;
                        ViewBag.GridType2 = ConstEnum.GridType.PeriodEndDisclosureDataForLetterForEmployeeInsiderGrid2;
                    }
                    TempData["transId"] = nTransactionMasterId;
                    if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                    {
                        using (NSEGroupSL ObjNSEGroupSL = new NSEGroupSL())
                        {
                            List<NSEGroupDetailsDTO> lstGroupId = ObjNSEGroupSL.GetgroupId(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO.UserInfoId), Convert.ToInt32(objTradingTransactionMasterDTO.TransactionMasterId));
                            foreach (var grpId in lstGroupId)
                                ViewBag.GroupId = grpId.GroupId;
                        }
                    }

                    #endregion Set Grid Type
                }



                if (objLoginUserDetails.BackURL != null && objLoginUserDetails.BackURL != "")
                {
                    ViewBag.ReturnUrl = objLoginUserDetails.BackURL;
                    objLoginUserDetails.BackURL = "";
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                }

                return View("~/Views/Pdf/Letter.cshtml", objTransactionLetterModel);
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objTemplateMasterDTO = null;
                objTradingTransactionMasterDTO = null;
                objUserInfoDTO = null;
            }

            return View("CreateLetter");


        }
        #endregion ViewLetter

        #region ViewHardCopy
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult ViewHardCopy(Int64 nTransactionMasterId, int nDisclosureTypeCodeId, int acid, string CalledFrom, int year = 0, int Period = 0, int nUserInfoId = 0)
        {
            LoginUserDetails objLoginUserDetails = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (nTransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(nTransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                List<DocumentDetailsModel> lstDocumentDetailsModel = new List<DocumentDetailsModel>();

                lstDocumentDetailsModel = Common.Common.GenerateDocumentList(ConstEnum.Code.DisclosureTransactionforOS, Convert.ToInt32(nTransactionMasterId), 0, null, 0);

                ViewBag.TransactionMasterId = nTransactionMasterId;
                ViewBag.DisclosureType = nDisclosureTypeCodeId;
                ViewBag.year = year;
                ViewBag.CalledFrom = CalledFrom;

                //if (objLoginUserDetails.BackURL != null && objLoginUserDetails.BackURL != "")
                //{
                //    ViewBag.ReturnUrl = objLoginUserDetails.BackURL;
                //    objLoginUserDetails.BackURL = "";
                //    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                //}

                // As submitted hard copy document is need to show in view mode -- method to show document from insider initial disclosure controller is call 

                bool is_CO_User = (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.COUserType) ? true : false;

                string page_call_from = "";

                switch (nDisclosureTypeCodeId)
                {
                    case ConstEnum.Code.DisclosureTypeInitial:
                        //NO "CalledFrom" value is set for CO user 
                        page_call_from = is_CO_User ? "InitialCO_OS" : CalledFrom;
                        break;
                    case ConstEnum.Code.DisclosureTypeContinuous:
                        page_call_from = CalledFrom;    // set value because for this case "CalledFrom" is already set 
                        break;
                    case ConstEnum.Code.DisclosureTypePeriodEnd:
                        page_call_from = CalledFrom;    // set value because for this case "CalledFrom" is already set 
                        break;
                }

                InsiderInitialDisclosureController objInsiderInitialDisclosureController = new InsiderInitialDisclosureController();

                int PolicyDocumentID = lstDocumentDetailsModel[0].MapToId;
                int DocumentID = (lstDocumentDetailsModel[0].DocumentId != null) ? (int)lstDocumentDetailsModel[0].DocumentId : 0;

                return objInsiderInitialDisclosureController.DisplayPolicy(acid, PolicyDocumentID, DocumentID, page_call_from, true, year, Period, string.Empty, false, nUserInfoId, "OS");
                //return View("ViewHardCopy", lstDocumentDetailsModel);
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
            }

            return View("CreateLetter");

        }
        #endregion ViewHardCopy

        #region UploadHardDocument
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult UploadHardDocument(Int64 nTransactionMasterId, int nDisclosureTypeCodeId, int acid, int year = 0, int uid = 0, int ParentId = 0, string frm = "", int nUserInfoId = 0)
        {
            //const string sLookUpPrefix = "tra_msg_";
            try
            {
                List<DocumentDetailsModel> lstDocumentDetailsModel = new List<DocumentDetailsModel>();

                lstDocumentDetailsModel = Common.Common.GenerateDocumentList(ConstEnum.Code.DisclosureTransactionforOS, Convert.ToInt32(nTransactionMasterId), 0, null, 0);
                ViewBag.TransactionMasterId = nTransactionMasterId;
                ViewBag.DisclosureType = nDisclosureTypeCodeId;
                ViewBag.year = year;
 				ViewBag.UserId = uid;
                ViewBag.UserInfoId = nUserInfoId;
                ViewBag.UserAction = acid;

                return View("UploadHardDocument_OS", lstDocumentDetailsModel);
            }
            catch (Exception exp)
            {
                return null;
            }
        }
        #endregion UploadHardDocument

        #region SubmitHardCopy
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult SubmitHardCopy(Int64 nTransactionMasterId, int nDisclosureTypeCodeId, int acid, int year = 0, int uid = 0)
        {
            //const string sLookUpPrefix = "tra_msg_";
            LoginUserDetails objLoginUserDetails = null;
            TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS = null;
            List<DocumentDetailsModel> lstDocumentDetailsModel = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (nTransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(nTransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                lstDocumentDetailsModel = Common.Common.GenerateDocumentList(ConstEnum.Code.DisclosureTransaction, Convert.ToInt32(nTransactionMasterId), 0, null, 0);

                if (lstDocumentDetailsModel.Count > 0)
                {
                    using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                    {
                        objTradingTransactionMasterDTO_OS = new TradingTransactionMasterDTO_OS();
                        objTradingTransactionMasterDTO_OS.TransactionMasterId = nTransactionMasterId;
                        objTradingTransactionMasterDTO_OS.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForHardCopySubmitted;
                        objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO_OS, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);
                    }
                    TempData.Remove("SearchArray");

                    if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                    {
                        if (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.COUserType)
                        {
                            return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE_LETTER_SUBMISSION, UserInfoId = uid, ReqModuleId = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOtherSecurity }).Success(Common.Common.getResource("dis_lbl_52078"));
                        }
                        else
                        {
                            return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE, UserInfoId = uid, ReqModuleId = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOtherSecurity }).Success(Common.Common.getResource("dis_lbl_52078"));
                        }
                    }
                    else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                    {
                        if (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.COUserType)
                        {
                            return RedirectToAction("CoIndex_OS", "PreclearanceRequestNonImplCompany", new { acid = ConstEnum.UserActions.PreclearanceRequestListCOOtherSecurities }).Success(Common.Common.getResource("dis_lbl_52078"));
                        }
                        else
                        {
                            return RedirectToAction("IndexOS", "PreclearanceRequestNonImplCompany", new { acid = ConstEnum.UserActions.PreclearanceRequestOtherSecurities }).Success(Common.Common.getResource("dis_lbl_52078"));
                        }
                    }
                    else //DisclosureTypePeriodEnd
                    {
                        if (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.COUserType)
                            if (uid != 0)
                                return RedirectToAction("PeriodStatusOS", "PeriodEndDisclosure_OS", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS, year = year, uid = uid }).Success(Common.Common.getResource("dis_msg_17345"));
                            else
                            {
                            return RedirectToAction("UserStatusOS", "PeriodEndDisclosure_OS", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS, year = year }).Success(Common.Common.getResource("dis_msg_17345"));
                            }
                        else
                            return RedirectToAction("PeriodStatusOS", "PeriodEndDisclosure_OS", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS }).Success(Common.Common.getResource("dis_msg_17345"));
                    }
                }
                else
                {
                    ModelState.Remove("KEY");
                    ModelState.Add("KEY", new ModelState());
                    ModelState.Clear();
                    ModelState.AddModelError("Error", "Please Upload the file to submit");
                    ViewBag.TransactionMasterId = nTransactionMasterId;
                    ViewBag.DisclosureType = nDisclosureTypeCodeId;
                    ViewBag.year = year;
                    ViewBag.UserAction = acid;
                    return View("UploadHardDocument_OS", lstDocumentDetailsModel);
                }
            }
            catch (Exception exp)
            {
                lstDocumentDetailsModel = Common.Common.GenerateDocumentList(ConstEnum.Code.DisclosureTransaction, Convert.ToInt32(nTransactionMasterId), 0, null, 0);

                ViewBag.TransactionMasterId = nTransactionMasterId;
                ViewBag.DisclosureType = nDisclosureTypeCodeId;
                ViewBag.year = year;
                ViewBag.UserAction = acid;
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));

                return View("UploadHardDocument_OS", lstDocumentDetailsModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion SubmitHardCopy

        #region SubmitSoftCopy
        [AuthorizationPrivilegeFilter]
        //[TokenVerification]
        public ActionResult SubmitSoftCopy(int acid, Int64 TransactionMasterId, int DisclosureTypeCodeId, long TransactionLetterId, int year = 0, int period = 0, int uid = 0, string __RequestVerificationToken = "", int formId = 0, int ParentId= 0)
        {
            Dictionary<string, string> ErrorDictionary = new Dictionary<string, string>();
            //bool statusFlag = false;

            LoginUserDetails objLoginUserDetails = null;
            TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS = null;
            TransactionLetterDTO_OS objTransactionLetterDTO_OS = null;
            PrintTemplateModel objPrintTemplateModel = null;
            TemplateMasterDTO objTemplateMasterDTO = null;
            TransactionLetterModel objTransactionLetterModel = null;
            UserInfoDTO objUserInfoDTO = null;
            ViewBag.IsFormCSubmitted = false;
            ViewBag.acid = acid;
            ViewBag.ShowNote = false;
            bool IsSave = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (TransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(TransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                objTradingTransactionMasterDTO_OS = new TradingTransactionMasterDTO_OS();
                objTransactionLetterDTO_OS = new TransactionLetterDTO_OS();

                using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                {
                    objTransactionLetterDTO_OS.MapToTypeCodeId = InsiderTrading.Common.ConstEnum.Code.DisclosureTransactionforOS;
                    objTransactionLetterDTO_OS.MapToId = Convert.ToInt32(TransactionMasterId);
                    objTransactionLetterDTO_OS.inp_iYearCodeId = year;
                    objTransactionLetterDTO_OS.inp_iPeriodCodeID = period;
                    objTransactionLetterDTO_OS.LoggedInUserId = Convert.ToInt32(objLoginUserDetails.LoggedInUserID);
                    if (DisclosureTypeCodeId == InsiderTrading.Common.ConstEnum.Code.DisclosureTypeInitial)
                        IsSave = objTradingTransactionSL_OS.InsertTransactionFormDetails(objLoginUserDetails.CompanyDBConnectionString, objTransactionLetterDTO_OS);
                    else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                        IsSave = objTradingTransactionSL_OS.InsertTransactionFormDetails_ForTrade(objLoginUserDetails.CompanyDBConnectionString, objTransactionLetterDTO_OS);
                    else
                        IsSave = objTradingTransactionSL_OS.InsertTransactionFormDetails_ForPeriodEnd(objLoginUserDetails.CompanyDBConnectionString, objTransactionLetterDTO_OS);

                    objTradingTransactionMasterDTO_OS.TransactionMasterId = TransactionMasterId;
                    objTradingTransactionMasterDTO_OS.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForSoftCopySubmitted;
                    objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO_OS, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);
                    TempData.Remove("SearchArray");

                    if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                    {
                        //ParentId
                        //UserInfoId = objLoginUserDetails.LoggedInUserID,
                        int acid_init = (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.CorporateUserType) ? ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE : ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE;
                        return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = acid_init, UserInfoId = ParentId, ReqModuleId = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOtherSecurity }).Success(Common.Common.getResource("dis_msg_52072"));

                    }
                    else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                    {
                        if (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.COUserType)
                            return RedirectToAction("CoIndex_OS", "PreclearanceRequestNonImplCompany", new { acid = ConstEnum.UserActions.PreclearanceRequestListCOOtherSecurities }).Success(Common.Common.getResource("dis_msg_52073"));
                        else
                            return RedirectToAction("IndexOS", "PreclearanceRequestNonImplCompany", new { acid = ConstEnum.UserActions.PreclearanceRequestOtherSecurities }).Success(Common.Common.getResource("dis_msg_52073"));
                    }
                    else //DisclosureTypePeriodEnd
                    {
                        if (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.COUserType)
                            return RedirectToAction("PeriodStatusOS", "PeriodEndDisclosure_OS", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS, year = year, uid = uid }).Success(Common.Common.getResource("dis_msg_51027"));
                        else
                            return RedirectToAction("PeriodStatusOS", "PeriodEndDisclosure_OS", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_OS }).Success(Common.Common.getResource("dis_msg_51027"));
                    }
                }
            }
            catch (Exception ex)
            {
                objPrintTemplateModel = new PrintTemplateModel();
                objTransactionLetterModel = new TransactionLetterModel();

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                objTemplateMasterDTO = new TemplateMasterDTO();

                objTransactionLetterModel.TransactionLetterId = TransactionLetterId;

                using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                {
                    objTemplateMasterDTO = objTradingTransactionSL_OS.GetTransactionLetterDetails(objLoginUserDetails.CompanyDBConnectionString, TransactionLetterId, TransactionMasterId,
                    DisclosureTypeCodeId, 0, 0);

                    Common.Common.CopyObjectPropertyByName(objTemplateMasterDTO, objTransactionLetterModel);

                    //Hard Core Need to change when path column is inserted in database
                    ViewBag.CompanyLogo = objLoginUserDetails.CompanyLogoURL;
                    ViewBag.transactionMasterId = TransactionMasterId;
                    ViewBag.DisclosureTypeCodeId = DisclosureTypeCodeId;
                    objPrintTemplateModel.transactionLetterModel = objTransactionLetterModel;
                    ViewBag.Layout = "~/Views/shared/_Layout.cshtml";
                    ViewBag.EditLetter = true;
                    ViewBag.acid = acid;
                    ViewBag.year = year;

                    objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, TransactionMasterId);

                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, (int)objTradingTransactionMasterDTO_OS.UserInfoId);
                        ViewBag.CompanyName = objUserInfoDTO.CompanyName;
                        ViewBag.CompanyISINNumber = objUserInfoDTO.ISINNumber;
                    }

                    #region Set Grid Type
                    if (objTransactionLetterModel.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                    {
                        ViewBag.GridType = ConstEnum.GridType.InitialDisclosureLetterList;
                    }
                    else if (objTransactionLetterModel.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous || objTransactionLetterModel.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                    {
                        if (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.NonEmployeeType || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.CorporateUserType)
                        {
                            ViewBag.GridType = ConstEnum.GridType.ContinuousDisclosureDataForLetterForNonEmployeeInsider;
                        }
                        else
                        {
                            ViewBag.GridType = ConstEnum.GridType.ContinuousDisclosureDataForLetterForEmployeeInsider;
                        }
                    }
                    #endregion Set Grid Type
                }

                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(ex));

                return View("~/Views/Pdf/TransactionDetails.cshtml", objPrintTemplateModel);

            }
            finally
            {
                objLoginUserDetails = null;
                objTradingTransactionMasterDTO_OS = null;
                objTemplateMasterDTO = null;
                objUserInfoDTO = null;
            }

        }
        #endregion SubmitSoftCopy

        #region SubmitLetterToStockExchange
        [AuthorizationPrivilegeFilter]
        public ActionResult SubmitLetterToStockExchange(int acid, Int64 TransactionMasterId, int DisclosureTypeCodeId, DateTime? StockExchangeDateSubmission, int year = 0)
        {
            Dictionary<string, string> ErrorDictionary = new Dictionary<string, string>();
            //bool statusFlag = false;

            LoginUserDetails objLoginUserDetails = null;
            TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (TransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(TransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTradingTransactionMasterDTO = new TradingTransactionMasterDTO();

                    objTradingTransactionMasterDTO.TransactionMasterId = TransactionMasterId;
                    objTradingTransactionMasterDTO.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForHardCopySubmittedByCO;
                    objTradingTransactionMasterDTO.HardCopyByCOSubmissionDate = StockExchangeDateSubmission;

                    objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);

                    if (objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType)
                    {
                        if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            return RedirectToAction("Index", "COInitialDisclosure", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE });
                        }
                        else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                        {
                            return RedirectToAction("ListByCO", "PreclearanceRequest", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE });
                        }
                        else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                        {
                            return RedirectToAction("UsersStatus", "PeriodEndDisclosure", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE, year = year });
                        }
                        else
                        {
                            return null;
                        }
                    }
                    else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                    {
                        return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE });
                    }
                    else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                    {
                        return RedirectToAction("Index", "PreClearanceRequest", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE });
                    }
                    else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                    {
                        return RedirectToAction("PeriodStatus", "PeriodEndDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE, year = year });
                    }
                    else
                    {
                        return RedirectToAction("UploadHardDocument", "TradingTransaction", new { nTransactionMasterId = TransactionMasterId, acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE });
                    }
                }
            }
            catch (Exception ex)
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objTradingTransactionMasterDTO = null;
            }

        }
        #endregion SubmitLetterToStockExchange

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
            LoginUserDetails objLoginUserDetails = null;
            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> lstPopulateComboDTO = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                lstPopulateComboDTO = new List<PopulateComboDTO>();
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
            finally
            {
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
                lstPopulateComboDTO = null;
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
        private void FillGrid(int m_nGridType, int R_nGridType, int acid, LoginUserDetails objLoginUserDetails, long? preclearenceID, int nTransactionMasterID, int nDisclosureTypeCodeId, int nSecurityTypeCodeId = 0, int nUserInfoId = 0, int nUserTypeCodeId = 0)
        {
            List<PopulateComboDTO> lstSecurityList = null;
            List<PopulateComboDTO> lstReasonsForNotTrading = null;
            Dictionary<string, int> objSelectionElement = null;

            try
            {
                ViewBag.GridType = m_nGridType;
                //ViewBag.nYearCode = nYearCode;
                //ViewBag.nPeriodCode = nPeriodCode;
                //ViewBag.nPeriodType = nPeriodType;
                ViewBag.acid = acid;
                ViewBag.UserinfoId = nUserInfoId;
                ViewBag.nUserTypeCodeId = nUserTypeCodeId;
                ViewBag.RGridType = R_nGridType;

                lstSecurityList = new List<PopulateComboDTO>();
                lstSecurityList = FillComboValues(ConstEnum.ComboType.SecurityTypeListOS, ConstEnum.CodeGroup.SecurityType, preclearenceID.ToString(), nTransactionMasterID.ToString(), null, null, false);
                if (lstSecurityList.Count > 0)
                    ViewBag.SecurityType = lstSecurityList[0].Value;

                ViewBag.SecurityTypeCodeID = nSecurityTypeCodeId;
                lstReasonsForNotTrading = new List<PopulateComboDTO>();
                lstReasonsForNotTrading = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ReasonForNotTradingOS, null, null, null, null, true);
                ViewBag.lstReasonsForNotTrading = lstReasonsForNotTrading;
                ViewBag.LoginUserTypeCodeId = objLoginUserDetails.UserTypeCodeId;

                int? nOverrideGridType = null;
                int? nOverrideGridRelativeType = null;

                //objSelectionElement = new Dictionary<string, int>();
                //objSelectionElement["" + ConstEnum.Code.DisclosureTypeInitial + '_' + ConstEnum.Code.EmployeeType] = ConstEnum.GridType.TradingTransaction_InitialDisclosure_Insider;
                //objSelectionElement["" + ConstEnum.Code.DisclosureTypeInitial + '_' + ConstEnum.Code.COUserType] = ConstEnum.GridType.TradingTransaction_InitialDisclosure_CO;
                //objSelectionElement["" + ConstEnum.Code.DisclosureTypeInitial + '_' + ConstEnum.Code.Admin] = ConstEnum.GridType.TradingTransaction_InitialDisclosure_CO;
                //objSelectionElement["" + ConstEnum.Code.DisclosureTypeContinuous + '_' + ConstEnum.Code.EmployeeType] = ConstEnum.GridType.TradingTransaction_ContinuousDisclosure_Insider;
                //objSelectionElement["" + ConstEnum.Code.DisclosureTypeContinuous + '_' + ConstEnum.Code.COUserType] = ConstEnum.GridType.TradingTransaction_ContinuousDisclosure_CO;
                //objSelectionElement["" + ConstEnum.Code.DisclosureTypeContinuous + '_' + ConstEnum.Code.Admin] = ConstEnum.GridType.TradingTransaction_ContinuousDisclosure_CO;
                //objSelectionElement["" + ConstEnum.Code.DisclosureTypePeriodEnd + '_' + ConstEnum.Code.EmployeeType] = ConstEnum.GridType.TradingTransaction_PeriodEndDisclosure_Insider;
                //objSelectionElement["" + ConstEnum.Code.DisclosureTypePeriodEnd + '_' + ConstEnum.Code.COUserType] = ConstEnum.GridType.TradingTransaction_PeriodEndDisclosure_CO;
                //objSelectionElement["" + ConstEnum.Code.DisclosureTypePeriodEnd + '_' + ConstEnum.Code.Admin] = ConstEnum.GridType.TradingTransaction_PeriodEndDisclosure_CO;


                //if (nDisclosureTypeCodeId == 147001)
                //{
                //    if (objSelectionElement.ContainsKey("" + nDisclosureTypeCodeId + '_' + objLoginUserDetails.UserTypeCodeId) && (nSecurityTypeForGrid == 139004 || nSecurityTypeForGrid == 139005))
                //    {                       
                //        nOverrideGridType = Convert.ToInt32(ConstEnum.GridType.TradingTransaction_InitialDisclosure_Insider_OptionContract);
                //        nOverrideGridRelativeType = Convert.ToInt32(ConstEnum.GridType.TradingTransaction_InitialDisclosure_Relative_OptionContract);
                //    }
                //}
                //else
                //{
                //    if (objSelectionElement.ContainsKey("" + nDisclosureTypeCodeId + '_' + objLoginUserDetails.UserTypeCodeId))
                //    {
                //        nOverrideGridType = objSelectionElement["" + nDisclosureTypeCodeId + '_' + objLoginUserDetails.UserTypeCodeId];
                //    }
                //}
                ViewBag.OverrideGridType = nOverrideGridType;
                ViewBag.OverrideGridRelativeType = nOverrideGridRelativeType;

            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                lstSecurityList = null;
                lstReasonsForNotTrading = null;
                objSelectionElement = null;
            }
        }
        #endregion FillGrid

        #region FillGgridUploadedDocuments
        private void FillGridUploadedDocuments(int nGridTypeUploadedDocs, int nDisclosureTransaction, int nTransactionMasterID, int acid)
        {
            int? nDocUploadOverrideGridType = null;
            try
            {
                ViewBag.GridTypeUploadedDocs = nGridTypeUploadedDocs;
                ViewBag.nDisclosureTransaction = nDisclosureTransaction;
                ViewBag.nTransactionMasterID = nTransactionMasterID;
                ViewBag.nDocUploadOverrideGridType = nDocUploadOverrideGridType;
                ViewBag.acid = acid;


            }
            catch { }
            finally { }
        }
        #endregion FillGgridUploadedDocuments

        #region PopulateCombo_OnChange

        [HttpPost]
        //[ValidateAntiForgeryToken]
        public ActionResult PopulateCombo_OnChange(TradingTransactionModel_OS objTradingTransactionModel_OS, Boolean TransactionTypeCodeFlag, int DisclosureType)
        {
            LoginUserDetails objLoginUserDetails = null;
            List<PopulateComboDTO> lstList = null;
            Common.Common objCommon = new Common.Common();

            string sDematDisclosureType = "";
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return Json(new
                    {
                        status = false,
                        Message = ""
                    }, JsonRequestBehavior.AllowGet);
                }
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                lstList = new List<PopulateComboDTO>();
                lstList = FillComboValues(ConstEnum.ComboType.UserDMATList, Convert.ToString(objTradingTransactionModel_OS.ForUserInfoId), Convert.ToString(ConstEnum.Code.DisclosureTypePeriodEnd), null, null, null, true);
                ViewBag.UserDMAT = lstList;
                ViewBag.TransactionTypeCodeFlag = TransactionTypeCodeFlag;
            }
            finally
            {
                objLoginUserDetails = null;
                lstList = null;
            }
            //Tushar
            return PartialView("PartialCreate_OS", objTradingTransactionModel_OS);
        }
        #endregion PopulateCombo_OnChange

        #region ForUserInfoId_OnChange
        [HttpPost]
        public ActionResult ForUserInfoId_OnChange(int nUserInfoId, int nUserInfoIdRelative, int nSecurityTypeCodeId)
        {

            LoginUserDetails objLoginUserDetails = null;
            double nClosingBalance = 0;
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return Json(new
                    {
                        status = false,
                        Message = ""
                    }, JsonRequestBehavior.AllowGet);
                }
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                using (PeriodEndDisclosureSL objPeriodEndDisclosureSL = new PeriodEndDisclosureSL())
                {
                    nClosingBalance = objPeriodEndDisclosureSL.GetClosingBalanceOfAnnualPeriod(objLoginUserDetails.CompanyDBConnectionString, nUserInfoId, nUserInfoIdRelative, nSecurityTypeCodeId);

                    ViewBag.ClosingBalance = nClosingBalance;
                }

                return Json(new
                {
                    status = true,
                    Message = "",//Common.Common.getResource("rul_msg_15380")//
                    ClosingBalance = nClosingBalance
                }, JsonRequestBehavior.AllowGet);

            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return Json(new
                {
                    status = false,
                    error = ModelState.ToSerializedDictionary(),
                    sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString())
                }, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion ForUserInfoId_OnChange

        #region DateOfAcquisition_OnChange
        [HttpPost]
        public ActionResult DateOfAcquisition_OnChange(DateTime DateOfAcquisition)
        {

            LoginUserDetails objLoginUserDetails = null;
            CompanyPaidUpAndSubscribedShareCapitalDTO objCompanyAuthorizedShareCapitalDTO = null;
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return Json(new
                    {
                        status = false,
                        Message = "",
                    }, JsonRequestBehavior.AllowGet);
                }
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                using (CompaniesSL objCompaniesSL = new CompaniesSL())
                {
                    objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, DateOfAcquisition);

                    ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;

                    if (objCompanyAuthorizedShareCapitalDTO.PaidUpShare != 0)
                    {
                        return Json(new
                        {
                            status = true,
                            Message = "",//Common.Common.getResource("rul_msg_15380")//
                            Subscribedcapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare
                        }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        ModelState.Remove("KEY");
                        ModelState.Add("KEY", new ModelState());
                        ModelState.Clear();
                        ModelState.AddModelError("Error", "Invalid Subscribed capital");
                        return Json(new
                        {
                            status = false,
                            error = ModelState.ToSerializedDictionary(),
                            Message = "Invalid Subscribed capital"
                        }, JsonRequestBehavior.AllowGet);
                    }
                }
            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return Json(new
                {
                    status = false,
                    error = ModelState.ToSerializedDictionary(),
                    sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString())
                }, JsonRequestBehavior.AllowGet);
            }
            finally
            {
                objLoginUserDetails = null;
                objCompanyAuthorizedShareCapitalDTO = null;
            }
        }
        #endregion DateOfAcquisition_OnChange

        #region Populate data for Trading Transaction Create
        private void CreatePopulateData(int UserInfoId, long TransactionMasterId, int acid, int nDisclosureTypeCodeId, int year, int period, int nSecurityTypeCodeId, long nPreclearenceID = 0, int periodType = 0, int UserTypeCodeID = 0)
        //private void CreatePopulateData(int UserInfoId = 372, long TransactionMasterId = 0, int acid = 155, int nDisclosureTypeCodeId = 147001, int year = 0, int period = 0, int nSecurityTypeCodeId = 0, long nPreclearenceID = 0, int periodType = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            List<PopulateComboDTO> lstList = null;

            ComCodeDTO objComCodeDTO = null;
            UserInfoDTO objUserInfoDTO = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                ViewBag.DisclosureType = nDisclosureTypeCodeId;
                ViewBag.ReturnUrl = "";
                ViewBag.acid = acid;
                ViewBag.UserInfoId = UserInfoId;

                lstList = new List<PopulateComboDTO>();

                //if (UserTypeCodeID == ConstEnum.Code.EmployeeType)
                //{
                //  if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                //  {
                //      lstList = FillComboValues(ConstEnum.ComboType.UserPANList, Convert.ToString(UserInfoId), null, null, null, null, true);
                //      ViewBag.UserPan = lstList;
                //  }
                //  else
                //  {
                //      lstList = FillComboValues(ConstEnum.ComboType.UserPANListForCD, Convert.ToString(UserInfoId), null, null, null, null, true);
                //      ViewBag.UserPan = lstList;
                //  }
                //}
                //else if (UserTypeCodeID == ConstEnum.Code.RelativeType)
                //{
                //    lstList = FillComboValues(ConstEnum.ComboType.RelUserPANList, Convert.ToString(UserInfoId), null, null, null, null, true);
                //    ViewBag.UserPan = lstList;
                //}

                if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                {
                    if (UserTypeCodeID == ConstEnum.Code.EmployeeType)
                    {
                        lstList = FillComboValues(ConstEnum.ComboType.UserPANList, Convert.ToString(UserInfoId), null, null, null, null, true);
                        ViewBag.UserPan = lstList;
                    }
                    else
                    {
                        lstList = FillComboValues(ConstEnum.ComboType.RelUserPANList, Convert.ToString(UserInfoId), null, null, null, null, true);
                        ViewBag.UserPan = lstList;
                    }
                }
                else
                {
                    if (nPreclearenceID != 0 && UserTypeCodeID == ConstEnum.Code.RelativeType)
                    {
                        lstList = FillComboValues(ConstEnum.ComboType.RelUserPANList, Convert.ToString(UserInfoId), null, null, null, null, true);
                    }
                    else
                    {
                        lstList = FillComboValues(ConstEnum.ComboType.UserPANList, Convert.ToString(UserInfoId), null, null, null, null, true);
                    }
                    ViewBag.UserPan = lstList;
                }


                lstList = FillComboValues(ConstEnum.ComboType.TransactionType_PNT_OS, ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                ViewBag.TransactionType = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ModeOfAcquisition, null, null, null, null, true);
                ViewBag.ModeOfAcquisition = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.StockExchangeMaster, null, null, null, null, true);
                ViewBag.ExchangeTypeCode = lstList;
                ViewBag.SecurityTypeCodeId = nSecurityTypeCodeId;
                ViewBag.PreclearenceID = nPreclearenceID;
                ViewBag.TransactionTypeCodeFlag = false;
                if (nPreclearenceID != 0)
                {
                    ViewBag.TransactionTypeCodeFlag = true;
                }
                ViewBag.TransactionMasterId = TransactionMasterId;

                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {
                    objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId);

                    ViewBag.PAN = objUserInfoDTO.PAN;

                    if (objUserInfoDTO.UserTypeCodeId == null || objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.CorporateUserType)
                        ViewBag.Name = objUserInfoDTO.CompanyName;
                    else
                        ViewBag.Name = objUserInfoDTO.FirstName + ' ' + objUserInfoDTO.LastName;

                    ViewBag.Address = objUserInfoDTO.AddressLine1 + ' ' + objUserInfoDTO.AddressLine2;
                    ViewBag.MobileNumber = objUserInfoDTO.MobileNumber;

                    ViewBag.sDateOfBecomingInsider = objUserInfoDTO.DateOfBecomingInsider;
                }

                ViewBag.ParentId = objUserInfoDTO.ParentId;
                ViewBag.year = year;
                ViewBag.period = period;
                ViewBag.periodType = periodType;

                ////Tushar
                //using (ComCodeSL objComCodeSL = new ComCodeSL())
                //{
                //    objComCodeDTO = objComCodeSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, nSecurityTypeCodeId);

                //    ViewBag.SecurityTypeName = objComCodeDTO.CodeName;
                //}
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                objLoginUserDetails = null;
                lstList = null;

                objUserInfoDTO = null;
                objComCodeDTO = null;
            }
        }
        #endregion Populate data for Trading Transaction Create

        #endregion Private Method

        #region Cancel/Back from Letter and Stock Exchange Letter
        /// <summary>
        /// This method is used to redirect back from where view is shown
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Cancel")]
        [ActionName("CreateLetter")]
        public ActionResult Cancel()
        {
            int activity_id = 0;
            string view_name = "";
            string controller_name = "";

            var dynamicRoutValues = new RouteValueDictionary();

            if (Request.Params["authorization"] != null && Request.Params["authorization"] != "")
            {
                activity_id = Convert.ToInt32(Request.Params["authorization"].Split(':')[1]);
            }
            dynamicRoutValues = BackCancelButton(activity_id, ref view_name, ref controller_name);
            return RedirectToAction(view_name, controller_name, dynamicRoutValues);
        }
        #endregion Cancel/Back from Letter and Stock Exchange Letter

        #region Cancel/Back from View Letter
        /// <summary>
        /// This method is used to redirect back from where view is shown
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Cancel")]
        [ActionName("SubmitSoftCopy")]
        public ActionResult CancelViewLetter()
        {
            int activity_id = 0;
            string view_name = "";
            string controller_name = "";

            var dynamicRoutValues = new RouteValueDictionary();

            if (Request.Params["authorization"] != null && Request.Params["authorization"] != "")
            {
                activity_id = Convert.ToInt32(Request.Params["authorization"].Split(':')[1]);
            }
            dynamicRoutValues = BackCancelButton(activity_id, ref view_name, ref controller_name);
            return RedirectToAction(view_name, controller_name, dynamicRoutValues);
        }
        #endregion Cancel/Back from View Letter

        #region Print Letter
        [ValidateInput(false)]
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Print")]
        [ActionName("SubmitSoftCopy")]
        [AuthorizationPrivilegeFilter]
        public ActionResult PrintLetter(int acid, string LetterHTMLContent, string FormHTMLContent, string LetterStatus, FormCollection form)
        {
            string html = form["FormContent"];

            var NseDownloadFlag1 = TempData["NseDownloadFlag1"];
            var NseDownloadFlag2 = TempData["NseDownloadFlag2"];
            if (Convert.ToString(NseDownloadFlag1) == "1")
            {
                #region GeneratePDFIMPCode
                TempData["LetterHTMLContent"] = LetterHTMLContent;
                TempData["FormHTMLContent"] = FormHTMLContent;
                return RedirectToAction("ViewPdf", "PreclearanceRequest", new { LetterStatus });
                #endregion GeneratePDFIMPCode
            }
            else if (Convert.ToString(NseDownloadFlag2) == "1")
            {
                #region GenerateLetterCode
                TempData["LetterHTMLContent"] = LetterHTMLContent;
                return RedirectToAction("Index", "NSEDownload", new { acid = ConstEnum.UserActions.NSEDownload, LetterStatus });
                #endregion GenerateLetterCode
            }
            else
            {
                LoginUserDetails objLoginUserDetails = null;
                try
                {
                    Response.Clear();
                    Response.ClearContent();
                    Response.ClearHeaders();
                    Response.ContentType = "application/pdf";
                    Response.AppendHeader("content-disposition", "attachment;filename=PDFFile.pdf");
                    Response.Flush();
                    Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    Response.Buffer = true;

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

                    objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                    var ImageUrl = objLoginUserDetails.CompanyLogoURL;

                    using (var ms = new MemoryStream())
                    {
                        using (var doc = new Document(PageSize.A4, 10f, 10f, 10f, 0f))
                        {
                            using (var writer = PdfWriter.GetInstance(doc, Response.OutputStream))
                            {
                                doc.Open();
                                doc.NewPage();
                                if (LetterStatus == "True")
                                {
                                    using (var msCss = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent)))
                                    {
                                        using (var msHtml = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent)))
                                        {
                                            iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, msHtml, msCss);
                                        }
                                    }
                                }
                                doc.SetPageSize(PageSize.A4.Rotate());
                                doc.NewPage();

                                using (var msCss = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(FormHTMLContent)))
                                {
                                    using (var msHtml = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(FormHTMLContent)))
                                    {
                                        iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, msHtml, msCss);
                                    }
                                }

                                doc.Close();
                            }

                            Response.Write(doc);
                            Response.End();
                            return null;
                        }
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
                finally
                {
                    objLoginUserDetails = null;
                }

            }
        }
        #endregion Print Letter

        #region Print Submission to Stock exchange Letter
        [ValidateInput(false)]
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Print")]
        [ActionName("SubmitLetterToStockExchange")]
        [AuthorizationPrivilegeFilter]
        public void SubmitLetterToStockExchangePrintLetter(int acid, string LetterHTMLContent, string FormHTMLContent, string LetterStatus)
        {
            LoginUserDetails objLoginUserDetails = null;

            try
            {
                Response.Clear();
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/pdf";
                Response.AppendHeader("content-disposition", "attachment;filename=PDFFile.pdf");
                Response.Flush();
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Buffer = true;

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

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                var ImageUrl = objLoginUserDetails.CompanyLogoURL;

                using (var ms = new MemoryStream())
                {
                    using (var doc = new Document(PageSize.A4, 10f, 10f, 10f, 0f))
                    {
                        using (var writer = PdfWriter.GetInstance(doc, Response.OutputStream))
                        {
                            doc.Open();
                            doc.NewPage();
                            if (LetterStatus == "True")
                            {
                                using (var msCss = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent)))
                                {
                                    using (var msHtml = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent)))
                                    {
                                        iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, msHtml, msCss);
                                    }
                                }
                            }
                            doc.SetPageSize(PageSize.A4.Rotate());
                            doc.NewPage();

                            using (var msCss = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(FormHTMLContent)))
                            {
                                using (var msHtml = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(FormHTMLContent)))
                                {
                                    iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, msHtml, msCss);
                                }
                            }

                            doc.Close();
                        }

                        Response.Write(doc);
                        Response.End();
                        TempData.Remove("SearchArray");
                    }
                }
            }
            catch (Exception e)
            {
                throw e;

            }
            finally
            {
                objLoginUserDetails = null;
            }

        }
        #endregion Print Submission to Stock exchange Letter

        #region Cancel/Back from SubmitLetterToStockExchange
        /// <summary>
        /// This method is used to redirect back from where view is shown
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Cancel")]
        [ActionName("SubmitLetterToStockExchange")]
        public ActionResult CancelStockExchange()
        {
            int activity_id = 0;
            string view_name = "";
            string controller_name = "";

            var dynamicRoutValues = new RouteValueDictionary();

            if (Request.Params["authorization"] != null && Request.Params["authorization"] != "")
            {
                activity_id = Convert.ToInt32(Request.Params["authorization"].Split(':')[1]);
            }
            dynamicRoutValues = BackCancelButton(activity_id, ref view_name, ref controller_name);
            return RedirectToAction(view_name, controller_name, dynamicRoutValues);
        }
        #endregion Cancel/Back from SubmitLetterToStockExchange

        #region LoadBalanceDMATwise
        public ActionResult LoadBalanceDMATwise(TradingTransactionModel_OS objTradingTransactionModel_OS)
        {
            BalancePoolOSDTO objBalancePoolDTO_OS = null;
            PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL_OS = new PreclearanceRequestNonImplCompanySL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicySL_OS objTradingPolicySL_OS = new TradingPolicySL_OS();
            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO_OS = new ApplicableTradingPolicyDetailsDTO_OS();
            CompaniesSL objCompaniesSL = new CompaniesSL();
            TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS();
            TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS = new TradingTransactionMasterDTO_OS();
            decimal virtual_exercise_qty = 0;
            decimal actual_exercise_qty = 0;
            try
            {
                objApplicableTradingPolicyDetailsDTO_OS = objTradingPolicySL_OS.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionModel_OS.TransactionMasterId);
                if (objTradingTransactionMasterDTO_OS.DisclosureTypeCodeId != ConstEnum.Code.DisclosureTypeInitial)
                {
                    objBalancePoolDTO_OS = objPreclearanceRequestNonImplCompanySL_OS.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, Convert.ToInt32(objTradingTransactionModel_OS.SecurityTypeCodeId), Convert.ToInt32(objTradingTransactionModel_OS.DMATDetailsID), objTradingTransactionModel_OS.CompanyId);

                    if (objBalancePoolDTO_OS != null)
                    {
                        virtual_exercise_qty = objBalancePoolDTO_OS.VirtualQuantity;
                        actual_exercise_qty = objBalancePoolDTO_OS.ActualQuantity;

                        ViewBag.ClosingBalance = actual_exercise_qty;
                    }

                }
                if (objTradingTransactionModel_OS.TransactionDetailsId > 0)
                {
                    TradingTransactionDTO_OS objTradingTransactionDTO_OS = objTradingTransactionSL_OS.GetTradingTransactionDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionModel_OS.TransactionDetailsId));
                    //objTradingTransactionModel_OS.Quantity2 = objTradingTransactionDTO_OS.Quantity2;
                    //objTradingTransactionModel_OS.Value2 = objTradingTransactionDTO_OS.Value2;
                }
            }
            catch (Exception exp)
            {

            }

            if (Convert.ToInt32(objTradingTransactionModel_OS.SecurityTypeCodeId) != 0 && Convert.ToInt32(objTradingTransactionModel_OS.DMATDetailsID) != 0 && objTradingTransactionModel_OS.CompanyId != 0)
            {
                return PartialView("_DMATwiseBalance", objTradingTransactionModel_OS);
            }
            else
            {
                return null;
            }
            //return Json(new
            //{
            //    esop_exercise_qty = esop_exercise_qty,
            //    other_esop_exercise_qty = other_esop_exercise_qty,//objTradingPolicyModel.TradingPolicyName + InsiderTrading.Common.Common.getResource("rul_msg_15374"),//" Save Successfully",

            //});
        }
        #endregion LoadBalanceDMATwise

        private RouteValueDictionary BackCancelButton(int activity_id, ref string view_name, ref string controller_name)
        {
            RouteValueDictionary dynamicRoutValues = new RouteValueDictionary();
            switch (activity_id)
            {
                //For insider user soft copy redirect
                case ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE_LETTER_SUBMISSION:
                case ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE:
                    //view_name = "Index";
                    //controller_name = "InsiderInitialDisclosure";
                    //dynamicRoutValues["acid"] = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE;
                    //break;
                    view_name = "Index";
                    controller_name = "InsiderInitialDisclosure";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE;
                    dynamicRoutValues["UserInfoId"] = Convert.ToInt32(Request.Params["uid"]);
                    dynamicRoutValues["ReqModuleId"] = ConstEnum.Code.RequiredModuleOwnSecurity;
                    break;

                case ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION:
                    view_name = "IndexOS";
                    controller_name = "PreclearanceRequestNonImplCompany";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.PreclearanceRequestOtherSecurities;
                    break;

                case ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION:
                    view_name = "PeriodStatus";
                    controller_name = "PeriodEndDisclosure";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE;
                    break;

                //For CO user soft copy redirect
                case ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE_LETTER_SUBMISSION:
                case ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE:
                    view_name = "Index";
                    controller_name = "COInitialDisclosure";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE;
                    break;

                case ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION:
                case ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE:
                    view_name = "ListByCO";
                    controller_name = "PreclearanceRequest";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE;
                    break;

                case ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION:
                case ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE:
                    view_name = "PeriodStatus";
                    //view_name = "UsersStatus";
                    controller_name = "PeriodEndDisclosure";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE;

                    if (Request.Params["period"] != null && Request.Params["period"] != "")
                    {
                        dynamicRoutValues["period"] = Convert.ToInt32(Request.Params["period"]);
                    }

                    if (Request.Params["year"] != null && Request.Params["year"] != "")
                    {
                        dynamicRoutValues["year"] = Convert.ToInt32(Request.Params["year"]);
                    }
                    if (Request.Params["uid"] != null && Request.Params["uid"] != "")
                    {
                        dynamicRoutValues["uid"] = Convert.ToInt32(Request.Params["uid"]);
                    }
                    if (Convert.ToInt32(dynamicRoutValues["uid"].ToString()) == 0)
                    {
                        view_name = "UsersStatus";
                    }
                    break;

                //For CO user Stock Exchange redirect
                case ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE_STOCK_EXCHANGE_SUBMISSION:
                    view_name = "Index";
                    controller_name = "COInitialDisclosure";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE;
                    break;
                case ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_STOCK_EXCHANGE_SUBMISSION:
                    view_name = "ListByCO";
                    controller_name = "PreclearanceRequest";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE;
                    break;
                case ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_STOCK_EXCHANGE_SUBMISSION:
                    view_name = "UsersStatus";
                    controller_name = "PeriodEndDisclosure";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE;

                    if (Request.Params["period"] != null && Request.Params["period"] != "")
                    {
                        dynamicRoutValues["period"] = Convert.ToInt32(Request.Params["period"]);
                    }

                    if (Request.Params["year"] != null && Request.Params["year"] != "")
                    {
                        dynamicRoutValues["year"] = Convert.ToInt32(Request.Params["year"]);
                    }

                    break;
            }
            return dynamicRoutValues;
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }

        #region TradingTransaction Confirmationpopup
        [HttpPost]
        public ActionResult PopupConfirmation(int acid, int nTradingTransactionMasterId, int nDisclosureStatus, int nDisclosureTypecodeId, int nConfigurationValueCodeId, int nIsTransactionEnter, int nIsDuplicateRecordFound, int nFromSubmitPage, int nUserId = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.TradingTransactionMasterId = nTradingTransactionMasterId;
                ViewBag.DisclosureTypecodeId = nDisclosureTypecodeId;
                ViewBag.IsDocumentUploaded = 0;
                ViewBag.acid = acid;
                ViewBag.nDisclosureStatus = nDisclosureStatus;
                Dictionary<int, string[]> dicResource = new Dictionary<int, string[]>();
                string nTransactionStatus = string.Empty;
                List<DuplicateTransactionDetailsDTO_OS> objDuplicateTransactionsDTO_OS = null;
                string alertMsg = string.Empty;
                List<string> savedList = new List<string>();
                ViewBag.IsDuplicateRecordFound = 0;
                if (nDisclosureTypecodeId == ConstEnum.Code.DisclosureTypeInitial)
                {
                    using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                    {
                        objDuplicateTransactionsDTO_OS = objTradingTransactionSL_OS.CheckIntialDisclosureNoHolding_OS(objLoginUserDetails.CompanyDBConnectionString, nTradingTransactionMasterId);
                        foreach (var item in objDuplicateTransactionsDTO_OS)
                        {

                            alertMsg = Common.Common.getResource("tra_msg_52070");
                            alertMsg = alertMsg.Replace("$5", item.UserName);
                            alertMsg = alertMsg.Replace("$1", item.UserType);
                            alertMsg = alertMsg.Replace("$2", item.DMATAccountNo);
                            alertMsg = alertMsg.Replace("$3", item.DPName);
                            alertMsg = alertMsg.Replace("$4", item.DPID);
                            savedList.Add(alertMsg);
                            alertMsg = string.Empty;
                        }
                        if (savedList.Count > 0)
                        {
                            ViewBag.IsDuplicateRecordFound = 1;
                            ViewBag.MainHeading = Common.Common.getResource("tra_msg_52068");
                            //ViewBag.SavedHeading = Common.Common.getResource("tra_msg_50634").Replace("$1", Common.Common.getResource("tra_msg_50639"));
                            ViewBag.SavedMessage = savedList;
                            ViewBag.TransactionMasterID = nTradingTransactionMasterId;
                            ViewBag.UserID = nUserId;
                            ViewBag.LastHeading = Common.Common.getResource("tra_msg_52069");
                            ViewBag.UserType = objLoginUserDetails.UserTypeCodeId;
                        }
                    }
                }
                ViewBag.IsError = 0;
                ViewBag.DisclouserType = nDisclosureTypecodeId == ConstEnum.Code.DisclosureTypeContinuous ? ConstEnum.Code.DisclosureTypeContinuous : (nDisclosureTypecodeId == ConstEnum.Code.DisclosureTypePeriodEnd) ? ConstEnum.Code.DisclosureTypePeriodEnd : ConstEnum.Code.DisclosureTypeInitial;
                if (nDisclosureTypecodeId == ConstEnum.Code.DisclosureTypeContinuous)
                {
                    ViewBag.ErrorMessage = Common.Common.getResource("tra_msg_53095");
                    ViewBag.ButtonText = Common.Common.getResource("tra_btn_53096");
                    if (nConfigurationValueCodeId == ConstEnum.Code.EnterUploadSetting_EnterDetails && nIsTransactionEnter == 0)
                    {
                        ViewBag.IsError = 1;
                    }
                }
            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
            }
            finally
            {

            }
            return PartialView("TransactionConfirmationPopup_OS");
        }
        #endregion TradingTransaction Confirmationpopup

        #region TradingTransaction TransactionSubmitConfirmation
        [HttpPost]
        public ActionResult TransactionSubmitConfirmation(int acid, int nTradingTransactionMasterId, int nConfigurationValueCodeId, int rdo_nEnterHoldingFor, int rdo_nUploadHoldingFor)
        {
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.TradingTransactionMasterId = nTradingTransactionMasterId;
                //ViewBag.DisclosureTypecodeId = nDisclosureTypecodeId;
                ViewBag.ConfigurationValueCodeId = nConfigurationValueCodeId;
                //ViewBag.IsTransactionEnter = 1;
                //ViewBag.IsDocumentUploaded = 0;
                /* using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                 {
                     if (objDocumentDetailsSL.GetDocumentCount(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, nTradingTransactionMasterId) > 0)
                     {
                         ViewBag.IsDocumentUploaded = 1;
                     }
                 }*/
                // return PartialView("TransactionConfirmationPopup");
                //using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                //{
                //    objTradingTransactionSL.TradingTransactionConfirmHoldingsFor(nTradingTransactionMasterId, rdo_nEnterHoldingFor, rdo_nUploadHoldingFor, objLoginUserDetails.LoggedInUserID, objLoginUserDetails.CompanyDBConnectionString);
                //}
                return Json(new
                {
                    status = true,
                    Message = Common.Common.getResource("tra_msg_16153")
                }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                return Json(new
                {
                    status = false,
                    Message = sErrMessage
                }, JsonRequestBehavior.AllowGet);
            }
            finally
            {

            }
        }
        #endregion TradingTransaction TransactionSubmitConfirmation
    }
}
