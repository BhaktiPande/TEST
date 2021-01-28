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
    [RolePrivilegeFilter]
    [ValidateInput(false)]
    public class TradingTransactionController : Controller
    {
        int nDisclosureCompletedFlag = 0;

        #region TradingTransaction Master details
        public TradingTransactionMasterDTO MasterDetials(LoginUserDetails objLoginUserDetails, int nDisclosureTypeCodeId, int nUserInfoId, int nYearCode = 0, int nPeriodCode = 0, int nPeriodType = 0, string frm = "", int nUserTypeCodeId = 0)
        {
            TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
            Dictionary<String, Object> objList = null;

            try
            {
                objTradingTransactionMasterDTO = new TradingTransactionMasterDTO();

                if (frm == "Insider" && nUserTypeCodeId == 101003)
                {
                    objTradingTransactionMasterDTO.InsiderIDFlag = true;
                }
                objTradingTransactionMasterDTO.TransactionMasterId = 0;
                objTradingTransactionMasterDTO.DisclosureTypeCodeId = nDisclosureTypeCodeId;
                objTradingTransactionMasterDTO.UserInfoId = nUserInfoId;
                objTradingTransactionMasterDTO.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForNotConfirmed;
                objTradingTransactionMasterDTO.NoHoldingFlag = false;

                if (nYearCode != 0 && nPeriodCode != 0)
                {
                    using (PeriodEndDisclosureSL objPeriodEndDisclosureSL = new PeriodEndDisclosureSL())
                    {
                        objList = objPeriodEndDisclosureSL.GetPeriodStarEndDate(objLoginUserDetails.CompanyDBConnectionString, nYearCode, nPeriodCode, nPeriodType);

                        objTradingTransactionMasterDTO.PeriodEndDate = Convert.ToDateTime(objList["end_date"]);
                    }
                }

                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);
                }
                ViewBag.UserTypeCodeId = objLoginUserDetails.UserTypeCodeId;
                return objTradingTransactionMasterDTO;
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
                objTradingTransactionMasterDTO = null;
            }
        }
        #endregion TradingTransaction Master details

        #region TradinTransactionList
        // GET: /Transaction/
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid, int TransactionMasterId = 0, int nDisclosureTypeCodeId = 0, int nUserInfoId = 0, int nUserTypeCodeId = 0, int nYearCode = 0, int nPeriodCode = 0, int PreclearanceRequestId = 0, string frm = "", int nPeriodType = 0, int ShowDocumentTab = 0, int SecurityTypeCode = 0, int ParentId = 0, bool SubmitFlag = false)
        {
            TradingTransactionModel objTransactionModel = null;

            TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
            LoginUserDetails objLoginUserDetails = null;
            CompanySettingConfigurationDTO objCompanySettingConfigurationDTO = null;
            ViewBag.NoHolding = false;
            ViewBag.IsfromView = 0;
            ViewBag.Showenterbutton = true;
            bool bIsCOAdminUser = false;
            ViewBag.nUserTypeCodeId = nUserTypeCodeId;
            ViewBag.ShowOwnSecuritiesDeclaration = false;
            try
            {
                List<PopulateComboDTO> lstCurrency = null;
                lstCurrency = new List<PopulateComboDTO>();
                lstCurrency = FillComboValues(ConstEnum.ComboType.ListOfCode, "117", null, null, null, null, false);
                ViewBag.CurrencyList = lstCurrency;

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                if (TransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(TransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                objTransactionModel = new TradingTransactionModel();


                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    if (TransactionMasterId == 0)
                    {
                        if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                        {
                            objTradingTransactionMasterDTO = new TradingTransactionMasterDTO();

                            objTradingTransactionMasterDTO.TransactionMasterId = 0;
                            objTradingTransactionMasterDTO.DisclosureTypeCodeId = nDisclosureTypeCodeId;
                            objTradingTransactionMasterDTO.UserInfoId = nUserInfoId;
                            objTradingTransactionMasterDTO.PreclearanceRequestId = PreclearanceRequestId;
                            objTradingTransactionMasterDTO.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForNotConfirmed;
                            objTradingTransactionMasterDTO.NoHoldingFlag = false;
                            objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);
                        }
                        else
                        {

                            objTradingTransactionMasterDTO = MasterDetials(objLoginUserDetails, nDisclosureTypeCodeId, nUserInfoId, nYearCode, nPeriodCode, nPeriodType, frm, nUserTypeCodeId);
                            //objTradingTransactionMasterDTO = MasterDetials(objLoginUserDetails, nDisclosureTypeCodeId, nUserInfoId, nYearCode, nPeriodCode, nPeriodType, frm, nUserTypeCodeId);
                        }
                    }
                    else
                    {
                        objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, TransactionMasterId);
                        ViewBag.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures = objTradingTransactionMasterDTO.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures;
                        ViewBag.DeclarationToBeMandatoryFlag = objTradingTransactionMasterDTO.DeclarationToBeMandatoryFlag;
                        ViewBag.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag = objTradingTransactionMasterDTO.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag;
                        ViewBag.SeekDeclarationFromEmpRegPossessionOfUPSIFlag = objTradingTransactionMasterDTO.SeekDeclarationFromEmpRegPossessionOfUPSIFlag;
                    }

                    
                    objTransactionModel.TradingTransactionUpload = Common.Common.GenerateDocumentList(ConstEnum.Code.DisclosureTransaction, Convert.ToInt32(objTradingTransactionMasterDTO.TransactionMasterId), 0, null, ConstEnum.Code.TransactionDetailsUpload, false, 0, 10, true);

                    ViewBag.CDDuringPE = objTradingTransactionMasterDTO.CDDuringPE;
                    ViewBag.HardCopyReq = objTradingTransactionMasterDTO.HardCopyReq;
                    ViewBag.TransactionMasterId = objTradingTransactionMasterDTO.TransactionMasterId;
                    ViewBag.nDisclosureTypeCodeId = objTradingTransactionMasterDTO.DisclosureTypeCodeId;
                    ViewBag.PreclearenceId = objTradingTransactionMasterDTO.PreclearanceRequestId;
                    ViewBag.ShowDocumentTab = ShowDocumentTab;
                    if (SecurityTypeCode != 0)
                    {
                        Session["SubmitFlag"] = SubmitFlag;
                    }
                    if (ViewBag.nDisclosureTypeCodeId == InsiderTrading.Common.ConstEnum.Code.DisclosureTypeInitial)
                    {
                        int SecurityTypeGridCodeId = 0;
                        if (frm == "redirectview")
                        {
                            TempData["SecurityTypeCodeId"] = SecurityTypeCode;
                        }
                        else
                        {
                            if (TempData["SecurityTypeCodeId"] != null)
                            {
                                ViewBag.SecurityTypeCodeId = TempData["SecurityTypeCodeId"];
                                SecurityTypeGridCodeId = Convert.ToInt32(ViewBag.SecurityTypeCodeId);
                                if ((bool)Session["SubmitFlag"] == true)
                                {
                                    ViewBag.ShowOwnSecuritiesDeclaration = true;
                                }
                            }
                            else
                            {

                                List<PopulateComboDTO> lstSecurityList = null;
                                lstSecurityList = new List<PopulateComboDTO>();
                                lstSecurityList = FillComboValues(ConstEnum.ComboType.SecurityTypeList, ConstEnum.CodeGroup.SecurityType, null, Convert.ToInt32(objTradingTransactionMasterDTO.TransactionMasterId).ToString(), SecurityTypeCode.ToString(), null, false);
                                ViewBag.SecurityTypeCodeId = lstSecurityList.First().Key;                     
                                SecurityTypeGridCodeId = Convert.ToInt32(ViewBag.SecurityTypeCodeId);
                            }
                        }
                        FillGrid(ConstEnum.GridType.TradingTransaction_InitialDisclosure_Insider, ConstEnum.GridType.RelativeInitialDisclosureList, nYearCode, nPeriodCode, acid, objLoginUserDetails, objTradingTransactionMasterDTO.PreclearanceRequestId, Convert.ToInt32(objTradingTransactionMasterDTO.TransactionMasterId), Convert.ToInt32(objTradingTransactionMasterDTO.DisclosureTypeCodeId), nPeriodType, SecurityTypeCode, nUserInfoId, nUserTypeCodeId, SecurityTypeGridCodeId);
                        FillGrid(ConstEnum.GridType.TradingTransaction_InitialDisclosure_Insider, ConstEnum.GridType.RelativeInitialDisclosureList, nYearCode, nPeriodCode, acid, objLoginUserDetails, objTradingTransactionMasterDTO.PreclearanceRequestId, Convert.ToInt32(objTradingTransactionMasterDTO.TransactionMasterId), Convert.ToInt32(objTradingTransactionMasterDTO.DisclosureTypeCodeId), nPeriodType, SecurityTypeCode, nUserInfoId, nUserTypeCodeId, SecurityTypeGridCodeId);
                    }
                    else
                    {
                        FillGrid(ConstEnum.GridType.TradingTransactionDetails, 0, nYearCode, nPeriodCode, acid, objLoginUserDetails, objTradingTransactionMasterDTO.PreclearanceRequestId, Convert.ToInt32(objTradingTransactionMasterDTO.TransactionMasterId), Convert.ToInt32(objTradingTransactionMasterDTO.DisclosureTypeCodeId), nPeriodType, SecurityTypeCode, nUserInfoId);
                    }
                    FillGridUploadedDocuments(ConstEnum.GridType.TransactionUploadedDocumentList, Convert.ToInt32(ConstEnum.Code.DisclosureTransaction), Convert.ToInt32(objTradingTransactionMasterDTO.TransactionMasterId), acid);
                    //List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
                    //lstList = FillComboValues(ConstEnum.ComboType.UserPANList, Convert.ToString(objTradingTransactionMasterDTO.UserInfoId), null, null, null, null, true);

                    if (objTradingTransactionMasterDTO.PreclearanceRequestId != null && objTradingTransactionMasterDTO.PreclearanceRequestId > 0)
                    {
                        TradingTransactionSummaryDTO objTradingTransactionSummaryDTO = new TradingTransactionSummaryDTO();
                        objTradingTransactionSummaryDTO = objTradingTransactionSL.GetTransactionSummary(objLoginUserDetails.CompanyDBConnectionString, 0, Convert.ToInt64(objTradingTransactionMasterDTO.PreclearanceRequestId));
                        ViewBag.ApprovedQuantity = Convert.ToInt64(objTradingTransactionSummaryDTO.ApprovedQuantity).ToString("#,##0");
                        ViewBag.TradedQuantity = Convert.ToInt64(objTradingTransactionSummaryDTO.TradedQuantity).ToString("#,##0"); ;
                        ViewBag.PendingQuantity = Convert.ToInt64(objTradingTransactionSummaryDTO.PendingQuantity).ToString("#,##0"); ;
                    }

                    //objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, objTransactionModel.TransactionMasterId);

                    string panNumber = string.Empty;
                    string DateOfAcquisition = string.Empty;
                    List<TradingTransactionMasterDTO> lstPanNumber = objTradingTransactionSL.Get_PanNumber(objTradingTransactionMasterDTO, objLoginUserDetails.CompanyDBConnectionString);
                    foreach (var panNum in lstPanNumber)
                    {
                        panNumber = panNum.PAN;
                        DateOfAcquisition = panNum.DateOfAcquisition;
                    }
                    ViewBag.panNumber = panNumber;
                    ViewBag.DateOfAcquisition = DateOfAcquisition;
                }


                using (CompaniesSL objCompaniesSL = new CompaniesSL())
                {
                    if (nDisclosureTypeCodeId == 0)
                    {
                        nDisclosureTypeCodeId = Convert.ToInt32(objTradingTransactionMasterDTO.DisclosureTypeCodeId);
                    }
                    objCompanySettingConfigurationDTO = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, Common.ConstEnum.Code.CompanyConfigType_EnterUploadSetting, nDisclosureTypeCodeId);

                    ImplementedCompanyDTO objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                    ViewBag.CompanyName = objImplementedCompanyDTO.CompanyName;
                    ViewBag.ConfigurationValueCodeId = objCompanySettingConfigurationDTO.ConfigurationValueCodeId;

                    /*   if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                       {
                        
                       }
                       else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                       {
                           objCompanySettingConfigurationDTO = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, Common.ConstEnum.Code.CompanyConfigType_EnterUploadSetting, Common.ConstEnum.Code.EnterUpload_ContinuousDisclosure);
                       }
                       else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                       {
                           objCompanySettingConfigurationDTO = objCompaniesSL.GetEnterUploadSettingsConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, Common.ConstEnum.Code.CompanyConfigType_EnterUploadSetting, Common.ConstEnum.Code.EnterUpload_PeriodEndDisclosure);
                       }*/
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
                    ViewBag.TranactionMasterStatus = objTradingTransactionMasterDTO.TransactionStatusCodeId;
                }

                if (objTradingTransactionMasterDTO.ConfirmCompanyHoldingsFor == null && objTradingTransactionMasterDTO.ConfirmNonCompanyHoldingsFor != null)
                {
                    if (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.EmployeeType || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.CorporateUserType
                        || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.NonEmployeeType || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.RelativeType)
                    {
                        if (objTradingTransactionMasterDTO.TransactionStatusCodeId == ConstEnum.Code.DisclosureStatusForDocumentUploaded)
                        {
                            ViewBag.TranactionMasterStatus = ConstEnum.Code.DisclosureStatusForSubmitted;
                            ViewBag.IsTransactionSubmitedByInsider = 1;
                        }
                    }
                }

                if (objTradingTransactionMasterDTO.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial && objTradingTransactionMasterDTO.NoHoldingFlag == true)
                    ViewBag.NoHolding = false;
                else
                    ViewBag.NoHolding = objTradingTransactionMasterDTO.NoHoldingFlag;

                ViewBag.nUserInfoId = objTradingTransactionMasterDTO.UserInfoId;
                ViewBag.ParentId = ParentId;
                ViewBag.UserAction = acid;
               // ViewBag.CompanyName = objLoginUserDetails.CompanyName;

                //to check from where this page is called - currently used to return to per-clearance request page
                ViewBag.from = frm;
                ViewBag.Back_preclearance_id = PreclearanceRequestId;

                //check if login user is insider or CO/Admin, in case of Admin/CO set flag true else false
                bIsCOAdminUser = (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.COUserType) ? true : false;

                //set acid for letter base on disclosure type 
                int letter_acid = 0;
                switch (objTradingTransactionMasterDTO.DisclosureTypeCodeId)
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
                return View("View", objTransactionModel);
            }
            catch (Exception exp)
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.TransactionMasterId = 0;
                ViewBag.nDisclosureTypeCodeId = nDisclosureTypeCodeId;
                ViewBag.nUserInfoId = nUserInfoId;
                ViewBag.CompanyName = "";

                //Comment on 22-Sep-2016 because unnecessary code confirm by Reghvendra
                //FillGrid(ConstEnum.GridType.TradingTransactionDetails, nYearCode, nPeriodCode, acid, objLoginUserDetails, null, TransactionMasterId, nDisclosureTypeCodeId, nPeriodType);
                //FillGridUploadedDocuments(ConstEnum.GridType.TransactionUploadedDocumentList, Convert.ToInt32(ConstEnum.Code.DisclosureTransaction), Convert.ToInt32(objTradingTransactionMasterDTO.TransactionMasterId), acid);
                //using (CompaniesSL objCompaniesSL = new CompaniesSL())
                //{
                //    ImplementedCompanyDTO objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                //    ViewBag.CompanyName = objImplementedCompanyDTO.CompanyName;
                //}
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("View", objTransactionModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objTradingTransactionMasterDTO = null;
            }
        }
        #endregion TradinTransactionList

        #region TradingTransaction Submit Status
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult Submit(int nTradingTransactionMasterId, int nDisclosureTypecodeId, int acid, bool Chk_DeclaFrmInsContDis = false, bool bNoHolding = false, bool bDocumentStatus = false, int year = 0, int period = 0, int uid = 0, string __RequestVerificationToken="", int formId=0)
        {
            bool statusFlag = false;
            bool hardCopyReq = false;
            bool softCopReq = false;
            bool CDDuringPE = false;
            var ErrorDictionary = new Dictionary<string, string>();
            var redirectTo = string.Empty;
            var UserTypeCodeId = string.Empty;
            TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
            LoginUserDetails objLoginUserDetails = null;
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
                objTradingTransactionMasterDTO = new TradingTransactionMasterDTO();

                objTradingTransactionMasterDTO.TransactionMasterId = nTradingTransactionMasterId;
                objTradingTransactionMasterDTO.DisclosureTypeCodeId = nDisclosureTypecodeId;
                objTradingTransactionMasterDTO.NoHoldingFlag = bNoHolding;
                objTradingTransactionMasterDTO.SeekDeclarationFromEmpRegPossessionOfUPSIFlag = Chk_DeclaFrmInsContDis;

                if (bDocumentStatus)
                    objTradingTransactionMasterDTO.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForDocumentUploaded;
                else
                    objTradingTransactionMasterDTO.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForSubmitted;

                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    TradingTransactionMasterDTO objTradingTransactionMasterDTO_Details = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, nTradingTransactionMasterId);
                    if (objTradingTransactionMasterDTO_Details.TransactionStatusCodeId != objTradingTransactionMasterDTO.TransactionStatusCodeId)
                    {
                        objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);
                        if (objTradingTransactionMasterDTO.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial && nDisclosureCompletedFlag == 1)
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
                    TradingTransactionMasterDTO objTradingTransactionMasterDTOhardcopyReq = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, nTradingTransactionMasterId);
                    hardCopyReq = Convert.ToBoolean(objTradingTransactionMasterDTOhardcopyReq.HardCopyReq);
                    CDDuringPE = Convert.ToBoolean(objTradingTransactionMasterDTOhardcopyReq.CDDuringPE);
                    softCopReq = Convert.ToBoolean(objTradingTransactionMasterDTOhardcopyReq.SoftCopyReq);
                    UserTypeCodeId = Convert.ToString(objLoginUserDetails.UserTypeCodeId);
                }
                TempData.Remove("SearchArray");
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
                objTradingTransactionMasterDTO = null;
                objLoginUserDetails = null;
            }
            return Json(new
            {
                UserTypeCodeId = UserTypeCodeId,
                redirectTo = Url.Action("CreateLetter", "TradingTransaction") + "?acid=" + acid +
                            "&nTransactionMasterId=" + nTradingTransactionMasterId + "&nDisclosureTypeCodeId=" + nDisclosureTypecodeId +
                            "&nLetterForCodeId=0" + InsiderTrading.Common.ConstEnum.Code.DisclosureLetterUserInsider + "&nTransactionLetterId=0" + "&year=" + year + "&period=" + period + "&IsStockExchange = false" + "&pdtypeId = 0" + "&pdtype = null" + "@uid=" + uid,
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
        public JsonResult TransactionNotTraded(int acid, int nPreclearenceId, int nReasonForNotTrading, string sReasonForNotTradingText, string __RequestVerificationToken="", int formId=0)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            string sPeriodEndDate = string.Empty;
            string sApproveddate = string.Empty;
            string sPreValiditydate = string.Empty;
            string sProhibitOnPer = string.Empty;
            string sProhibitOnQuantity = string.Empty;
            LoginUserDetails objLoginUserDetails = null;
            PreclearanceRequestDTO objPreclearanceRequestDTO = null;
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

                objPreclearanceRequestDTO = new PreclearanceRequestDTO();

                objPreclearanceRequestDTO.PreclearanceRequestId = nPreclearenceId;
                objPreclearanceRequestDTO.ReasonForNotTradingCodeId = nReasonForNotTrading;
                objPreclearanceRequestDTO.ReasonForNotTradingText = sReasonForNotTradingText;
                objPreclearanceRequestDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;

                using (PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL())
                {
                    string sContraTradeDate;

                    objPreclearanceRequestDTO = objPreclearanceRequestSL.Save(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestDTO, out sContraTradeDate, out sPeriodEndDate, out sApproveddate, out sPreValiditydate, out sProhibitOnPer, out sProhibitOnQuantity);

                    ErrorDictionary.Add("success", Common.Common.getResource("tra_msg_16127"));

                    statusFlag = true;
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
                objPreclearanceRequestDTO = null;
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
        public ActionResult Create(int TransactionDetailsId, Int64 TransactionMasterId, int acid, int year, int period, int? SecurityTypeCodeId = null, int periodType = 0)
        {
            TradingTransactionModel objTransactionModel = null;
            CompanyPaidUpAndSubscribedShareCapitalDTO objCompanyAuthorizedShareCapitalDTO = null;
            LoginUserDetails objLoginUserDetails = null;
            TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
            TradingPolicyDTO objTradingPolicyDTO = null;
            TradingTransactionDTO objTradingTransactionDTO = null;
            ImplementedCompanyDTO objImplementedCompanyDTO = null;
            PreclearanceRequestDTO objPreclearanceRequestDTO = null;
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = null;
            //ViewBag.ShowPopup = true;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                ViewBag.UserTypeCode = objLoginUserDetails.UserTypeCodeId;
                ViewBag.IsNegative = true;
                ViewBag.ShowTradeNote = false;
                if (TransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(TransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, TransactionMasterId);

                    if (objTradingTransactionMasterDTO.CDDuringPE)
                        objTradingTransactionMasterDTO.DisclosureTypeCodeId = ConstEnum.Code.DisclosureTypePeriodEnd;

                    if (objTradingTransactionMasterDTO.DisclosureTypeCodeId != InsiderTrading.Common.ConstEnum.Code.DisclosureTypeInitial && objLoginUserDetails.CompanyName.Contains(InsiderTrading.Common.ConstEnum.CLIENT_DB_NAME))
                    {
                        ViewBag.ShowTradeNote = true;
                    }

                    using (TradingPolicySL objTradingPolicySL = new TradingPolicySL())
                    {
                        objTradingPolicyDTO = objTradingPolicySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO.TradingPolicyId));

                        ViewBag.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = (objTradingPolicyDTO.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate ? 1 : 0);

                        objTransactionModel = new TradingTransactionModel();

                        using (CompaniesSL objCompaniesSL = new CompaniesSL())
                        {
                            if (TransactionDetailsId > 0)
                            {
                                objTradingTransactionDTO = objTradingTransactionSL.GetTradingTransactionDetails(objLoginUserDetails.CompanyDBConnectionString, TransactionDetailsId);

                                Common.Common.CopyObjectPropertyByName(objTradingTransactionDTO, objTransactionModel);
                                if (objTransactionModel.SecurityTypeCodeId != null)
                                {
                                    ViewBag.IsNegative = objTradingTransactionSL.IsAllowNegativeBalanceForSecurity(Convert.ToInt32(objTransactionModel.SecurityTypeCodeId), objLoginUserDetails.CompanyDBConnectionString);
                                }
                                objTransactionModel.ESOPExcerciseOptionQtyModel = objTradingTransactionDTO.ESOPExcerciseOptionQty;
                                objTransactionModel.OtherExcerciseOptionQtyModel = objTradingTransactionDTO.OtherExcerciseOptionQty;

                                ViewBag.SubscribedCapital = 0;

                                if (objTradingTransactionMasterDTO.DisclosureTypeCodeId != ConstEnum.Code.DisclosureTypeInitial)
                                {
                                    objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, Convert.ToDateTime(objTransactionModel.DateOfAcquisition));

                                    ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;
                                }
                                else if (objTradingTransactionMasterDTO.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                                {
                                    objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, Convert.ToDateTime(Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString)));

                                    ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;
                                }
                                objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);

                                ViewBag.ContraTradeOption = objImplementedCompanyDTO.ContraTradeOption;
                                ViewBag.addSecuritiesNotes = null;
                                ViewBag.addSecuritiesNotes = InsiderTrading.Common.Common.getResource("dis_msg_50549").Split('|');
                            }
                            else
                            {
                                objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);

                                objTransactionModel.CompanyId = Convert.ToInt32(objImplementedCompanyDTO.CompanyId);
                                objTransactionModel.SecurityTypeCodeId = Convert.ToInt32(SecurityTypeCodeId);
                                objTransactionModel.TransactionMasterId = TransactionMasterId;
                                if (SecurityTypeCodeId != null)
                                {
                                    ViewBag.IsNegative = objTradingTransactionSL.IsAllowNegativeBalanceForSecurity(Convert.ToInt32(SecurityTypeCodeId), objLoginUserDetails.CompanyDBConnectionString);
                                }
                                ViewBag.SubscribedCapital = 0;
                                ViewBag.ContraTradeOption = objImplementedCompanyDTO.ContraTradeOption;
                                ViewBag.addSecuritiesNotes = null;
                                ViewBag.addSecuritiesNotes = InsiderTrading.Common.Common.getResource("dis_msg_50549").Split('|');
                                if (objTradingTransactionMasterDTO.DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                                {
                                    try
                                    {
                                        objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, Convert.ToDateTime(Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString)));
                                        ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;
                                    }
                                    catch (Exception e)
                                    {
                                        ViewBag.SubscribedCapital = 0;
                                        string sErrMessage = Common.Common.getResource(e.InnerException.Data[0].ToString());
                                        ModelState.AddModelError("Error", sErrMessage);
                                    }
                                }
                            }
                        }

                        using (PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL())
                        {
                            if (Convert.ToInt64(objTradingTransactionMasterDTO.PreclearanceRequestId) > 0)
                            {
                                objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt64(objTradingTransactionMasterDTO.PreclearanceRequestId));

                                objTransactionModel.TransactionTypeCodeId = Convert.ToInt32(objPreclearanceRequestDTO.TransactionTypeCodeId);
                                objTransactionModel.ModeOfAcquisitionCodeId = Convert.ToInt32(objPreclearanceRequestDTO.ModeOfAcquisitionCodeId);

                                if (Convert.ToInt32(objPreclearanceRequestDTO.UserInfoIdRelative) > 0)
                                    objTransactionModel.ForUserInfoId = Convert.ToInt32(objPreclearanceRequestDTO.UserInfoIdRelative);
                                else
                                    objTransactionModel.ForUserInfoId = Convert.ToInt32(objPreclearanceRequestDTO.UserInfoId);

                                objTransactionModel.DMATDetailsID = Convert.ToInt32(objPreclearanceRequestDTO.DMATDetailsID);

                                if (TransactionDetailsId <= 0)
                                {
                                    objTransactionModel.Quantity = Convert.ToInt64(objPreclearanceRequestDTO.QtyRemainForTrade);
                                    //objTransactionModel.Value = decimal.Round(Convert.ToDecimal(objPreclearanceRequestDTO.SecuritiesToBeTradedValue), 2);
                                }

                                objTransactionModel.ESOPExcerseOptionQtyFlag = objPreclearanceRequestDTO.ESOPExcerciseOptionQtyFlag;
                                objTransactionModel.OtherESOPExcerseOptionFlag = objPreclearanceRequestDTO.OtherESOPExcerciseOptionQtyFlag;

                                ViewBag.ESOPExcerseOptionQtyFlagValue = objPreclearanceRequestDTO.ESOPExcerciseOptionQtyFlag;
                                ViewBag.OtherESOPExcerseOptionFlagValue = objPreclearanceRequestDTO.OtherESOPExcerciseOptionQtyFlag;

                                objTransactionModel.b_IsInitialDisc = false;
                                objTransactionModel.DateOfInitimationToCompany = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                            }
                            else
                            {
                                if (TransactionDetailsId <= 0 && objTransactionModel.TransactionTypeCodeId != ConstEnum.Code.DisclosureTypeInitial)
                                {
                                    objTransactionModel.DateOfInitimationToCompany = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                                }

                                objTransactionModel.b_IsInitialDisc = true;
                            }

                            CreatePopulateData(Convert.ToInt32(objTradingTransactionMasterDTO.UserInfoId), TransactionMasterId, acid, Convert.ToInt32(objTradingTransactionMasterDTO.DisclosureTypeCodeId), year, period, Convert.ToInt32(objTransactionModel.SecurityTypeCodeId), Convert.ToInt64(objTradingTransactionMasterDTO.PreclearanceRequestId), periodType);

                            objTransactionModel.DateOfBecomingInsider = ViewBag.sDateOfBecomingInsider;
                            objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO.UserInfoId), TransactionMasterId);

                            //check if trading policy is define for user or not 
                            if (objApplicableTradingPolicyDetailsDTO != null)
                            {
                                ViewBag.GenCashAndCashlessPartialExciseOptionForContraTrade = objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade;
                                ViewBag.UseExerciseSecurityPool = objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool;
                            }

                            if (objTradingTransactionMasterDTO.DisclosureTypeCodeId != ConstEnum.Code.DisclosureTypeInitial)
                            {
                                ExerciseBalancePoolDTO objExerciseBalancePoolDTO = new ExerciseBalancePoolDTO();
                                objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString,
                                                           Convert.ToInt32(objTradingTransactionMasterDTO.UserInfoId), ConstEnum.Code.SecurityTypeShares, objTransactionModel.DMATDetailsID);

                                if (objExerciseBalancePoolDTO != null)
                                {
                                    ViewBag.ESOPQuantity = objExerciseBalancePoolDTO.ESOPQuantity;
                                    ViewBag.OtherQuantity = objExerciseBalancePoolDTO.OtherQuantity;
                                }
                                objTransactionModel.b_IsInitialDisc = false;
                            }
                        }
                    }
                }

                ViewBag.postAcqNeMsg = Common.Common.getResource("tra_msg_16443");

                if (TempData["TradingTransactionModel"] != null)
                {
                    TempData["DuplicateTransaction"] = false;
                    ViewBag.ShowPopup = true;
                    TradingTransactionModel tradingTransactionModel = (TradingTransactionModel)TempData["TradingTransactionModel"];
                    tradingTransactionModel.DateOfBecomingInsider = ViewBag.sDateOfBecomingInsider;
                    TempData.Remove("TradingTransactionModel");
                    return View("Create", tradingTransactionModel);
                }
                TempData["DuplicateTransaction"] = false;
                ViewBag.ShowPopup = true;
                return View("Create", objTransactionModel);
            }
            catch (Exception exp)
            {
                CompaniesSL objCompaniesSL = new CompaniesSL();
                objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                ViewBag.ContraTradeOption = objImplementedCompanyDTO.ContraTradeOption;
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View();
            }
            finally
            {
                objCompanyAuthorizedShareCapitalDTO = null;
                objLoginUserDetails = null;
                objTradingTransactionMasterDTO = null;
                objTradingPolicyDTO = null;
                objTradingTransactionDTO = null;
                objImplementedCompanyDTO = null;
                objPreclearanceRequestDTO = null;
                objApplicableTradingPolicyDetailsDTO = null;
            }
        }
        #endregion TradingTransactionCreate/Edit get

        #region TradingTransactionCreate/Edit post
        // [AuthorizationPrivilegeFilter]
        [HttpPost]
        [ValidateAntiForgeryToken]        
        [Button(ButtonName = "Create")]
        [ActionName("Create")]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult Create(TradingTransactionModel objTransactionModel, int acid, int UserInfoId, int DisclosureType, int year, int period, long PreclearenceID, int periodType)
        {
            LoginUserDetails objLoginUserDetails = null;

            CompanyPaidUpAndSubscribedShareCapitalDTO objCompanyAuthorizedShareCapitalDTO = null;
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = null;

            TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
            TradingPolicyDTO objTradingPolicyDTO = null;
            TradingTransactionDTO objTradingTransactionDTO = null;
            PreclearanceRequestDTO objPreclearanceRequestDTO = null;
            ExerciseBalancePoolDTO objExerciseBalancePoolDTO = null;
            CompaniesSL objCompaniesSL1 = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            string nTransactionStatus = string.Empty;
            List<DuplicateTransactionDetailsDTO> objDuplicateTransactionsDTO = null;
            string alertMsg = string.Empty;
            List<PopulateComboDTO> lstSecurityList = null;
            string securityType = null;
            string transactionType = null;
            string dateOfAcquisition = null;
            List<PopulateComboDTO> lstTransactionTypeList = null;
            List<PopulateComboDTO> lstModeOfAcqList = null;
            string transactionStatus = null;
            string cancelBtnText = null;
            int transactionMasterId = 0;
            string actionOne = string.Empty;
            string actionTwo = string.Empty;
            List<string> savedList = new List<string>();
            string ModeOfAcquisition = null;
            ViewBag.ShowPopup = false;

            bool bIsValidDateOfAcquisition = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.IsNegative = true;
                ViewBag.UserTypeCode = objLoginUserDetails.UserTypeCodeId;
                ViewBag.postAcqNeMsg = Common.Common.getResource("tra_msg_16443");
                if (objTransactionModel.TransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(objTransactionModel.TransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, objTransactionModel.TransactionMasterId);

                    int transactionId = 0;
                    DateTime dtPeriodEnd = Convert.ToDateTime(objTradingTransactionMasterDTO.PeriodEndDate);
                    bool cdDuringPE = true;
                    List<TradingTransactionMasterDTO> lstTransId = objTradingTransactionSL.Get_CDTransIdduringPE(objTradingTransactionMasterDTO, objLoginUserDetails.CompanyDBConnectionString, cdDuringPE);
                    foreach (var transId in lstTransId)
                        transactionId = Convert.ToInt32(transId.TransactionMasterId);


                    using (TradingPolicySL objTradingPolicySL = new TradingPolicySL())
                    {
                        objTradingPolicyDTO = objTradingPolicySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO.TradingPolicyId));

                        ViewBag.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = (objTradingPolicyDTO.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate ? 1 : 0);
                        ViewBag.SubscribedCapital = 0;

                        using (CompaniesSL objCompaniesSL = new CompaniesSL())
                        {
                            if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial && objTransactionModel.DateOfAcquisition != null)
                            {
                                objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, Convert.ToDateTime(objTransactionModel.DateOfAcquisition));

                                ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;
                            }

                            if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                            {
                                try
                                {
                                    objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, Convert.ToDateTime(Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString)));
                                    ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;
                                }
                                catch (Exception e)
                                {
                                    ViewBag.SubscribedCapital = 0;
                                    string sErrMessage = Common.Common.getResource(e.InnerException.Data[0].ToString());
                                    ModelState.AddModelError("Error", sErrMessage);
                                }
                            }
                        }

                        #region Validation Checks
                        //if (objTransactionModel.DateOfBecomingInsider == null)
                        //{
                        //    ModelState.AddModelError("DateOfBecomingInsider", Common.Common.getResource("tra_msg_16107"));
                        //}
                        //else
                        //{
                        //    if (objTransactionModel.DateOfBecomingInsider > Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString))
                        //    {
                        //        ModelState.AddModelError("DateOfBecomingInsider", Common.Common.getResource("tra_msg_16108"));
                        //    }
                        //}
                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial)
                        {
                            //if ((objTransactionModel.SecuritiesPriorToAcquisition == null || objTransactionModel.SecuritiesPriorToAcquisition < 0)
                            //    && objTradingTransactionSL.IsAllowNegativeBalanceForSecurity(Convert.ToInt32(objTransactionModel.SecurityTypeCodeId), objLoginUserDetails.CompanyDBConnectionString))
                            //{
                            //    ModelState.AddModelError("SecuritiesPriorToAcquisition", Common.Common.getResource("tra_msg_16109"));
                            //}
                            if (objTransactionModel.DateOfAcquisition == null)
                            {
                                ModelState.AddModelError("DateOfAcquisition", Common.Common.getResource("tra_msg_16110"));
                            }
                            else
                            {
                                if (objTransactionModel.DateOfAcquisition > Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString))
                                {
                                    ModelState.AddModelError("DateOfAcquisition", Common.Common.getResource("tra_msg_16111"));
                                }
                                else
                                {
                                    bIsValidDateOfAcquisition = true;
                                }
                            }
                        }
                        else
                        {
                            if (!objTradingTransactionSL.IsAllowNegativeBalanceForSecurity(Convert.ToInt32(objTransactionModel.SecurityTypeCodeId), objLoginUserDetails.CompanyDBConnectionString))
                            {
                                if (objTransactionModel.Quantity < 0)
                                {
                                    objTransactionModel.TransactionTypeCodeId = ConstEnum.Code.TransactionTypeSell;
                                    objTransactionModel.Quantity = objTransactionModel.Quantity * (-1);
                                }
                                else
                                {
                                    objTransactionModel.TransactionTypeCodeId = ConstEnum.Code.TransactionTypeBuy;
                                }
                            }
                            else
                            {
                                objTransactionModel.TransactionTypeCodeId = ConstEnum.Code.TransactionTypeBuy;
                            }

                            if (objTransactionModel.SecuritiesPriorToAcquisition == null)
                                objTransactionModel.SecuritiesPriorToAcquisition = 0;

                            if (objTransactionModel.PerOfSharesPostTransaction == null)
                                objTransactionModel.PerOfSharesPostTransaction = 0;
                        }
                        //if (objTransactionModel.ModeOfAcquisitionCodeId == null || objTransactionModel.ModeOfAcquisitionCodeId <= 0)
                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial && objTransactionModel.ModeOfAcquisitionCodeId <= 0)
                        {
                            ModelState.AddModelError("ModeOfAcquisitionCodeId", Common.Common.getResource("tra_msg_16112"));
                        }
                        if (objTransactionModel.DateOfInitimationToCompany == null)
                        {
                            ModelState.AddModelError("DateOfInitimationToCompany", Common.Common.getResource("tra_msg_16113"));
                        }
                        else
                        {
                            if (objTransactionModel.DateOfInitimationToCompany > Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString))
                            {
                                ModelState.AddModelError("DateOfInitimationToCompany", Common.Common.getResource("tra_msg_16114"));
                            }
                            if (objLoginUserDetails.UserTypeCodeId == Common.ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == Common.ConstEnum.Code.COUserType)
                            {
                                if (bIsValidDateOfAcquisition)
                                {
                                    if (objTransactionModel.DateOfInitimationToCompany < objTransactionModel.DateOfAcquisition)
                                    {
                                        ModelState.AddModelError("DateOfInitimationToCompany", Common.Common.getResource("tra_msg_16332"));
                                    }
                                }
                            }
                        }
                        //if (objTransactionModel.ForUserInfoId == null || objTransactionModel.ForUserInfoId <= 0)
                        if (objTransactionModel.ForUserInfoId <= 0)
                        {
                            ModelState.AddModelError("ForUserInfoId", Common.Common.getResource("tra_msg_16115"));
                        }
                        if (objTransactionModel.Quantity == null || objTransactionModel.Quantity <= 0)
                        {
                            //if (objTransactionModel.TransactionTypeCodeId != null && objTransactionModel.TransactionTypeCodeId > 0 && (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial || objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll))
                            if (objTransactionModel.TransactionTypeCodeId > 0 && (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial || objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll))
                            {
                                ModelState.AddModelError("Quantity", Common.Common.getResource("tra_msg_16184"));
                            }
                            else
                            {
                                if (objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeFutureContract || objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeOptionContract)
                                {
                                    ModelState.AddModelError("Quantity", Common.Common.getResource("tra_msg_16182"));
                                }
                                else if (acid != 155)
                                {
                                    ModelState.AddModelError("Quantity", Common.Common.getResource("tra_msg_16116"));
                                }
                            }

                        }
                        if (objTransactionModel.Value == null || objTransactionModel.Value <= 0)
                        {
                            //if (objTransactionModel.TransactionTypeCodeId != null && objTransactionModel.TransactionTypeCodeId > 0 && (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial || objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll))
                            if (objTransactionModel.TransactionTypeCodeId > 0 && (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial || objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll))
                            {
                                ModelState.AddModelError("Value", Common.Common.getResource("tra_msg_16185"));
                            }
                            else
                            {
                                if (objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeFutureContract || objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeOptionContract)
                                {
                                    if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial && (ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.EmployeeType || ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.CorporateUserType || ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.NonEmployeeType))
                                    { /*do nothing*/ }
                                    else
                                        ModelState.AddModelError("Value", Common.Common.getResource("tra_msg_16183"));
                                }
                                else
                                {
                                    if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial && (ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.EmployeeType || ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.CorporateUserType || ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.NonEmployeeType))
                                    { /*do nothing*/ }
                                    else
                                        ModelState.AddModelError("Value", Common.Common.getResource("tra_msg_16117"));
                                }
                            }
                        }
                        //if (objTransactionModel.ExchangeCodeId == null || objTransactionModel.ExchangeCodeId <= 0)
                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial && objTransactionModel.ExchangeCodeId <= 0)
                        {
                            ModelState.AddModelError("ExchangeCodeId", Common.Common.getResource("tra_msg_16118"));
                        }
                        //if (objTransactionModel.TransactionTypeCodeId == null || objTransactionModel.TransactionTypeCodeId <= 0)
                        if (objTransactionModel.TransactionTypeCodeId <= 0)
                        {
                            ModelState.AddModelError("TransactionTypeCodeId", Common.Common.getResource("tra_msg_16119"));
                        }
                        //if (objTransactionModel.DMATDetailsID == null || objTransactionModel.DMATDetailsID <= 0)
                        if (objTransactionModel.DMATDetailsID <= 0)
                        {
                            ModelState.AddModelError("DMATDetailsID", Common.Common.getResource("tra_msg_16120"));
                        }
                        if (objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeOptionContract || objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeFutureContract)
                        {
                            if (objTransactionModel.LotSize == null || objTransactionModel.LotSize <= 0)
                            {
                                ModelState.AddModelError("LotSize", Common.Common.getResource("tra_msg_16121"));
                            }
                            if (objTransactionModel.ContractSpecification == null || objTransactionModel.ContractSpecification == "")
                            {
                                ModelState.AddModelError("ContractSpecification", Common.Common.getResource("tra_msg_16326"));
                            }
                            if (objTransactionModel.PerOfSharesPreTransaction == null)
                                objTransactionModel.PerOfSharesPreTransaction = 0;

                            if (objTransactionModel.PerOfSharesPostTransaction == null)
                                objTransactionModel.PerOfSharesPostTransaction = 0;
                        }
                        else
                        {
                            if (objTransactionModel.PerOfSharesPreTransaction == null)
                            {
                                ModelState.AddModelError("PerOfSharesPreTransaction", Common.Common.getResource("tra_msg_16122"));
                            }

                            if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial && (objTransactionModel.PerOfSharesPostTransaction == null))
                            {
                                ModelState.AddModelError("PerOfSharesPostTransaction", Common.Common.getResource("tra_msg_16123"));
                            }
                            else
                            {
                                if (objTransactionModel.PerOfSharesPostTransaction == null)
                                    objTransactionModel.PerOfSharesPostTransaction = 0;
                            }

                            if (objTransactionModel.LotSize == null)
                                objTransactionModel.LotSize = 0;
                        }

                        if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll || objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial)
                        {
                            if (objTransactionModel.Quantity2 == null || objTransactionModel.Quantity2 <= 0)
                            {
                                ModelState.AddModelError("Quantity2", Common.Common.getResource("tra_msg_16124"));
                            }
                            else
                            {
                                if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll && objTransactionModel.Quantity != objTransactionModel.Quantity2)
                                {
                                    ModelState.AddModelError("Quantity2", Common.Common.getResource("tra_lbl_16149"));
                                }
                                if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial && objTransactionModel.Quantity < objTransactionModel.Quantity2)
                                {
                                    ModelState.AddModelError("Quantity2", Common.Common.getResource("tra_lbl_16150"));
                                }
                            }
                            if (objTransactionModel.Value2 == null || objTransactionModel.Value2 <= 0)
                            {
                                ModelState.AddModelError("Value2", Common.Common.getResource("tra_msg_16125"));
                            }
                            else
                            {
                                if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll && objTransactionModel.Value != objTransactionModel.Value2)
                                {
                                    ModelState.AddModelError("Value2", Common.Common.getResource("tra_lbl_16151"));
                                }
                                if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial && objTransactionModel.Value < objTransactionModel.Value2)
                                {
                                    ModelState.AddModelError("Value2", Common.Common.getResource("tra_lbl_16152"));
                                }
                            }
                        }
                        else
                        {
                            if (objTransactionModel.Quantity2 == null)
                                objTransactionModel.Quantity2 = 0;

                            if (objTransactionModel.Value2 == null)
                                objTransactionModel.Value2 = 0;
                        }
                        TempData.Keep("DuplicateTransaction");
                        //ViewBag.ShowPopup = false;
                        if (ModelState.IsValid && (bool)TempData["DuplicateTransaction"] == false)
                        {
                            objDuplicateTransactionsDTO = objTradingTransactionSL.CheckDuplicateTransaction(objLoginUserDetails.CompanyDBConnectionString, objTransactionModel.ForUserInfoId, objTransactionModel.SecurityTypeCodeId, objTransactionModel.TransactionTypeCodeId, objTransactionModel.DateOfAcquisition, objTransactionModel.TransactionDetailsId);
                            foreach (var item in objDuplicateTransactionsDTO)
                            {
                                if (item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForNotConfirmed
                                || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForConfirmed
                                || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForSoftCopySubmitted
                                || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForHardCopySubmitted
                                || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForHardCopySubmittedByCO
                                || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForSubmitted)
                                {
                                    alertMsg = Common.Common.getResource("tra_msg_50628");
                                    lstSecurityList = new List<PopulateComboDTO>();
                                    lstSecurityList = FillComboValues(ConstEnum.ComboType.SecurityTypeList, ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                                    foreach (var type in lstSecurityList)
                                    {
                                        if (item.SecurityType.ToString() == type.Key)
                                        {
                                            securityType = type.Value;
                                        }
                                    }
                                    dateOfAcquisition = item.DateOfAcquisition.Date.ToString("dd/MMM/yyyy");
                                    lstTransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                                    foreach (var type in lstTransactionTypeList)
                                    {
                                        if (item.TransactionType.ToString() == type.Key)
                                        {
                                            transactionType = type.Value;
                                        }
                                    }
                                    lstModeOfAcqList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ModeOfAcquisition, null, null, null, null, true);
                                    foreach (var type in lstModeOfAcqList)
                                    {
                                        if (item.ModeOfAcquisition.ToString() == type.Key)
                                        {
                                            ModeOfAcquisition = type.Value;
                                        }
                                    }
                                    transactionStatus = (item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForConfirmed) ? Common.Common.getResource("tra_msg_50632") : (item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForNotConfirmed) ? Common.Common.getResource("tra_msg_50631") : "";
                                    actionOne = Common.Common.getResource("tra_msg_50633");
                                    actionTwo = Common.Common.getResource("tra_msg_50635");
                                    alertMsg = alertMsg.Replace("$1", transactionType);
                                    alertMsg = alertMsg.Replace("$2", item.Relation);
                                    alertMsg = alertMsg.Replace("$3", dateOfAcquisition);
                                    alertMsg = alertMsg.Replace("$4", item.Quantity.ToString());
                                    alertMsg = alertMsg.Replace("$5", securityType);
                                    alertMsg = alertMsg.Replace("$6", item.Value.ToString());
                                    alertMsg = alertMsg.Replace("$7", ModeOfAcquisition);
                                    alertMsg = alertMsg.Replace("$8", item.ExchangeCode == Common.ConstEnum.Code.StockExchange_NSE ? Common.Common.getResource("tra_lbl_50644") : item.ExchangeCode == Common.ConstEnum.Code.StockExchange_BSE ? Common.Common.getResource("tra_lbl_50645") : "");
                                    alertMsg = alertMsg.Replace("$9", item.DMATAccountNo);
                                    alertMsg = alertMsg.Replace("#1", item.DPName);
                                    alertMsg = alertMsg.Replace("#2", item.DPID);
                                    alertMsg = alertMsg.Replace("#3", item.TMID);
                                    savedList.Add(alertMsg);
                                    cancelBtnText = Common.Common.getResource("tra_btn_50629").Replace("$1", Common.Common.getResource("tra_msg_50631")).Replace("$2", Common.Common.getResource("tra_msg_50632"));
                                    alertMsg = string.Empty;
                                }
                            }
                            if (savedList.Count > 0)
                            {
                                TempData["TradingTransactionModel"] = objTransactionModel;
                                TempData["DuplicateTransaction"] = true;
                                ViewBag.ShowPopup = true;
                                return Json(new
                                {
                                    status = true,
                                    MainHeading = Common.Common.getResource("tra_msg_50633"),
                                    SavedHeading = Common.Common.getResource("tra_msg_50634").Replace("$1", Common.Common.getResource("tra_msg_50639")),
                                    SavedMessage = savedList,
                                    CancelButtonText = cancelBtnText,
                                    TransactionMasterId = objTransactionModel.TransactionDetailsId,
                                    SecurityType = objTransactionModel.SecurityTypeCodeId,
                                    TransactionType = objTransactionModel.TransactionTypeCodeId,
                                    DateOfAcquisition = objTransactionModel.DateOfAcquisition,
                                    UserRole = objLoginUserDetails.UserTypeCodeId,
                                    UserID = objTransactionModel.ForUserInfoId,
                                    LastHeading = Common.Common.getResource("tra_msg_50636").Replace("$1", Common.Common.getResource("tra_msg_50637")).Replace("$2", Common.Common.getResource("tra_msg_50639"))
                                }, JsonRequestBehavior.AllowGet);
                            }
                        }

                        #endregion Validation Checks
                        if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            objTransactionModel.ExchangeCodeId = ConstEnum.Code.StockExchange_NSE;
                            objTransactionModel.b_IsInitialDisc = true;
                            if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeSell)
                            {
                                objTransactionModel.ModeOfAcquisitionCodeId = ConstEnum.Code.ModeOfAcquisition_MarketSale;
                            }
                            else
                            {
                                objTransactionModel.ModeOfAcquisitionCodeId = ConstEnum.Code.ModeOfAcquisition_MarketPurchase;
                            }
                        }
                        else
                        {
                            objTransactionModel.b_IsInitialDisc = false;
                        }
                        if (!ModelState.IsValid)
                        {
                            CreatePopulateData(UserInfoId, objTransactionModel.TransactionMasterId, acid, DisclosureType, year, period, objTransactionModel.SecurityTypeCodeId, PreclearenceID, periodType);
                            objTransactionModel.DateOfBecomingInsider = ViewBag.sDateOfBecomingInsider;
                            objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objTransactionModel.TransactionMasterId);

                            //check if trading policy is define for user or not 
                            if (objApplicableTradingPolicyDetailsDTO != null)
                            {
                                ViewBag.GenCashAndCashlessPartialExciseOptionForContraTrade = objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade;
                                ViewBag.UseExerciseSecurityPool = objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool;
                            }

                            using (PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL())
                            {
                                if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial)
                                {
                                    objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString,
                                                               Convert.ToInt32(UserInfoId), ConstEnum.Code.SecurityTypeShares, objTransactionModel.DMATDetailsID);

                                    if (objExerciseBalancePoolDTO != null)
                                    {
                                        ViewBag.ESOPQuantity = objExerciseBalancePoolDTO.ESOPQuantity;
                                        ViewBag.OtherQuantity = objExerciseBalancePoolDTO.OtherQuantity;
                                    }
                                }

                                if (objTradingTransactionMasterDTO.PreclearanceRequestId != null && objTradingTransactionMasterDTO.PreclearanceRequestId > 0)
                                {

                                    objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt64(objTradingTransactionMasterDTO.PreclearanceRequestId));
                                    objTransactionModel.ESOPExcerseOptionQtyFlag = objPreclearanceRequestDTO.ESOPExcerciseOptionQtyFlag;
                                    objTransactionModel.OtherESOPExcerseOptionFlag = objPreclearanceRequestDTO.OtherESOPExcerciseOptionQtyFlag;
                                    ViewBag.ESOPExcerseOptionQtyFlagValue = objPreclearanceRequestDTO.ESOPExcerciseOptionQtyFlag;
                                    ViewBag.OtherESOPExcerseOptionFlagValue = objPreclearanceRequestDTO.OtherESOPExcerciseOptionQtyFlag;
                                }
                            }
                            objImplementedCompanyDTO = objCompaniesSL1.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                            if (objTransactionModel.SecurityTypeCodeId != null)
                            {
                                ViewBag.IsNegative = objTradingTransactionSL.IsAllowNegativeBalanceForSecurity(Convert.ToInt32(objTransactionModel.SecurityTypeCodeId), objLoginUserDetails.CompanyDBConnectionString);
                            }
                            ViewBag.ContraTradeOption = objImplementedCompanyDTO.ContraTradeOption;
                            ViewBag.addSecuritiesNotes = null;
                            ViewBag.addSecuritiesNotes = InsiderTrading.Common.Common.getResource("dis_msg_50549").Split('|');
                            return PartialView("Create", objTransactionModel);
                        }
                    }

                    objTradingTransactionDTO = new TradingTransactionDTO();

                    Common.Common.CopyObjectPropertyByName(objTransactionModel, objTradingTransactionDTO);
                    //For Employers and Insiders the DateOfIntemition to the company should always be the date when Insider Submitts the details. 
                    //So it is handled in the Submit procedure. For CO type user the date modified by user is saved against the transaction, the date should be >= date of acquisition
                    if (objLoginUserDetails.UserTypeCodeId != Common.ConstEnum.Code.Admin && objLoginUserDetails.UserTypeCodeId != Common.ConstEnum.Code.COUserType)
                    {
                        objTradingTransactionDTO.DateOfInitimationToCompany = null;
                    }
                    objImplementedCompanyDTO = objCompaniesSL1.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                    if (objTradingTransactionDTO.SecurityTypeCodeId == Common.ConstEnum.Code.SecurityTypeShares)
                    {
                        if (objImplementedCompanyDTO.ContraTradeOption == InsiderTrading.Common.ConstEnum.Code.ContraTradeWithoutQuantiy
                            && DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            objTradingTransactionDTO.ESOPExcerciseOptionQty = 0;
                            objTradingTransactionDTO.OtherExcerciseOptionQty = objTransactionModel.Quantity;
                        }
                        else if (objImplementedCompanyDTO.ContraTradeOption == InsiderTrading.Common.ConstEnum.Code.ContraTradeQuantiyBase
                            && DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            objTradingTransactionDTO.ESOPExcerciseOptionQty = objTransactionModel.ESOPExcerciseOptionQtyModel;
                            objTradingTransactionDTO.OtherExcerciseOptionQty = objTransactionModel.OtherExcerciseOptionQtyModel;
                        }
                    }
                    else
                    {
                        objTradingTransactionDTO.ESOPExcerciseOptionQty = 0;
                        objTradingTransactionDTO.OtherExcerciseOptionQty = objTransactionModel.Quantity;
                    }

                    if (transactionId == 0)
                    {
                        if (DisclosureType == Common.ConstEnum.Code.DisclosureTypePeriodEnd)
                        {
                            using (TradingPolicySL objTradingPolicySL = new TradingPolicySL())
                            {
                                objTradingTransactionMasterDTO.TransactionMasterId = 0;
                                objTradingTransactionMasterDTO.PreclearanceRequestId = null;
                                objTradingTransactionMasterDTO.UserInfoId = UserInfoId;
                                objTradingTransactionMasterDTO.DisclosureTypeCodeId = Common.ConstEnum.Code.DisclosureTypeContinuous;//147002;
                                objTradingTransactionMasterDTO.TransactionStatusCodeId = Common.ConstEnum.Code.DisclosureStatusForNotConfirmed;// 148002;
                                objTradingTransactionMasterDTO.CDDuringPE = true;
                                objTradingTransactionMasterDTO.NoHoldingFlag = false;
                                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId);
                                objTradingTransactionMasterDTO.TradingPolicyId = objApplicableTradingPolicyDetailsDTO.TradingPolicyId;
                                objTradingTransactionMasterDTO.PeriodEndDate = dtPeriodEnd;
                                objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO, UserInfoId, out nDisclosureCompletedFlag);
                            }
                        }
                    }
                    objTradingTransactionDTO.TransactionMasterId = Convert.ToInt32(objTradingTransactionMasterDTO.TransactionMasterId);
                    objTradingTransactionDTO = objTradingTransactionSL.InsertUpdateTradingTransactionDetails(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionDTO, UserInfoId);
                }
                if ((bool)TempData["DuplicateTransaction"] == true)
                {
                    TempData.Remove("DuplicateTransaction");
                    return RedirectToAction("Index", "TradingTransaction", new { acid = acid, TransactionMasterId = objTradingTransactionMasterDTO.TransactionMasterId, nPeriodCode = period, nYearCode = year, nPeriodType = periodType }).Success(Common.Common.getResource("tra_msg_16186"));
                }
                else
                {
                    return Json(new
                    {
                        url = Url.Action("Index", "TradingTransaction", new { acid = acid, TransactionMasterId = objTradingTransactionMasterDTO.TransactionMasterId, nPeriodCode = period, nYearCode = year, nPeriodType = periodType })
                    }, JsonRequestBehavior.AllowGet).Success(Common.Common.getResource("tra_msg_16186"));
                }
            }
            catch (Exception exp)
            {
                ViewBag.IsNegative = true;
                string sErrMessage;
                if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                {
                    objTransactionModel.b_IsInitialDisc = true;
                }
                else
                {
                    objTransactionModel.b_IsInitialDisc = false;
                }
                CreatePopulateData(UserInfoId, objTransactionModel.TransactionMasterId, acid, DisclosureType, year, period, objTransactionModel.SecurityTypeCodeId, PreclearenceID, periodType);
                objTransactionModel.DateOfBecomingInsider = ViewBag.sDateOfBecomingInsider;
                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, objTransactionModel.TransactionMasterId);
                    if (objTransactionModel.SecurityTypeCodeId != null)
                    {
                        ViewBag.IsNegative = objTradingTransactionSL.IsAllowNegativeBalanceForSecurity(Convert.ToInt32(objTransactionModel.SecurityTypeCodeId), objLoginUserDetails.CompanyDBConnectionString);
                    }
                    using (TradingPolicySL objTradingPolicySL = new TradingPolicySL())
                    {
                        objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objTransactionModel.TransactionMasterId);

                        objTradingPolicyDTO = objTradingPolicySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO.TradingPolicyId));

                        ViewBag.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = (objTradingPolicyDTO.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate ? 1 : 0);
                        ViewBag.SubscribedCapital = 0;

                        using (CompaniesSL objCompaniesSL = new CompaniesSL())
                        {
                            if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial)
                            {
                                objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, Convert.ToDateTime(objTransactionModel.DateOfAcquisition));

                                ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;
                            }

                            if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                            {
                                try
                                {
                                    objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, Convert.ToDateTime(Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString)));
                                    ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;
                                }
                                catch (Exception e)
                                {
                                    ViewBag.SubscribedCapital = 0;
                                    sErrMessage = Common.Common.getResource(e.InnerException.Data[0].ToString());
                                    ModelState.AddModelError("Error", sErrMessage);
                                }
                            }
                        }

                        //check if trading policy is define for user or not 
                        if (objApplicableTradingPolicyDetailsDTO != null)
                        {
                            ViewBag.GenCashAndCashlessPartialExciseOptionForContraTrade = objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade;
                            ViewBag.UseExerciseSecurityPool = objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool;
                        }
                    }

                    using (PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL())
                    {
                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial)
                        {
                            objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString,
                                                       Convert.ToInt32(UserInfoId), ConstEnum.Code.SecurityTypeShares, objTransactionModel.DMATDetailsID);

                            if (objExerciseBalancePoolDTO != null)
                            {
                                ViewBag.ESOPQuantity = objExerciseBalancePoolDTO.ESOPQuantity;
                                ViewBag.OtherQuantity = objExerciseBalancePoolDTO.OtherQuantity;
                            }
                        }

                        if (objTradingTransactionMasterDTO.PreclearanceRequestId != null && objTradingTransactionMasterDTO.PreclearanceRequestId > 0)
                        {

                            objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt64(objTradingTransactionMasterDTO.PreclearanceRequestId));
                            objTransactionModel.ESOPExcerseOptionQtyFlag = objPreclearanceRequestDTO.ESOPExcerciseOptionQtyFlag;
                            objTransactionModel.OtherESOPExcerseOptionFlag = objPreclearanceRequestDTO.OtherESOPExcerciseOptionQtyFlag;
                            ViewBag.ESOPExcerseOptionQtyFlagValue = objPreclearanceRequestDTO.ESOPExcerciseOptionQtyFlag;
                            ViewBag.OtherESOPExcerseOptionFlagValue = objPreclearanceRequestDTO.OtherESOPExcerciseOptionQtyFlag;

                        }
                    }
                }

                ViewBag.postAcqNeMsg = Common.Common.getResource("tra_msg_16443");

                sErrMessage = Common.Common.GetErrorMessage(exp);// Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);

                objImplementedCompanyDTO = objCompaniesSL1.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                ViewBag.ContraTradeOption = objImplementedCompanyDTO.ContraTradeOption;
                ViewBag.addSecuritiesNotes = null;
                ViewBag.addSecuritiesNotes = InsiderTrading.Common.Common.getResource("dis_msg_50549").Split('|');

                return PartialView("Create", objTransactionModel);
            }
            finally
            {
                objTradingTransactionMasterDTO = null;
                objLoginUserDetails = null;
                objTradingPolicyDTO = null;
                objCompanyAuthorizedShareCapitalDTO = null;
                objPreclearanceRequestDTO = null;
                objTradingTransactionDTO = null;
                objExerciseBalancePoolDTO = null;
                objCompaniesSL1 = null;
                objImplementedCompanyDTO = null;
            }
        }
        #endregion TradingTransactionCreate/Edit post

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

                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTradingTransactionSL.DeleteTradingTransactionDetails(objLoginUserDetails.CompanyDBConnectionString, TradingTransactionId, objLoginUserDetails.LoggedInUserID);
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
                    using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                    {
                        objTradingTransactionSL.DeleteTradingTransactionMaster(objLoginUserDetails.CompanyDBConnectionString, TradingTransactionMasterId, objLoginUserDetails.LoggedInUserID);
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

                if (objLoginUserDetails.UserTypeCodeId != ConstEnum.Code.Admin && objLoginUserDetails.UserTypeCodeId != InsiderTrading.Common.ConstEnum.Code.COUserType)
                {
                    using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                    {
                        objTemplateMasterDTO = new TemplateMasterDTO();

                        Common.Common.CopyObjectPropertyByName(objTransactionLetterModel, objTemplateMasterDTO);
                        if (objTemplateMasterDTO.IsActive)
                        {
                            objTemplateMasterDTO = objTradingTransactionSL.InsertUpdateTradingTransactionLetterDetails(objLoginUserDetails.CompanyDBConnectionString, objTemplateMasterDTO, objLoginUserDetails.LoggedInUserID);
                        }
                    }
                    var verify = Guid.NewGuid();
                    int FormId=0;
                    if (nDisclosureTypeCodeId==147001)
                    {
                        FormId=111;
                    }
                    else if (nDisclosureTypeCodeId == 147002)
                    {
                        FormId=112;
                    }
                    else
                    {
                        FormId=113;
                    }
                    return RedirectToAction("SubmitSoftCopy", "TradingTransaction", new { acid = acid, TransactionMasterId = nTransactionMasterId, DisclosureTypeCodeId = nDisclosureTypeCodeId, TransactionLetterId = InsiderTrading.Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_STOCK_EXCHANGE_SUBMISSION, year = year, period = period, __RequestVerificationToken = verify, formId = FormId });
                }
                else
                {
                    return View("CreateLetter", objTransactionLetterModel);
                }
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
        [TokenVerification]
        [Button(ButtonName = "SaveLetter")]
        [ActionName("CreateLetter")]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveLetter(TransactionLetterModel objTransactionLetterModel, int year = 0, bool IsStockExchange = false, int period = 0, int pdtypeId = 0, string pdtype = null, int uid = 0)
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
                    if (uid == 0)
                        ViewBag.UserId = (int)objTradingTransactionMasterDTO.UserInfoId;
                    else
                        ViewBag.UserId = uid;

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

                lstDocumentDetailsModel = Common.Common.GenerateDocumentList(ConstEnum.Code.DisclosureTransaction, Convert.ToInt32(nTransactionMasterId), 0, null, 0);

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
                        page_call_from = is_CO_User ? "InitialCO" : CalledFrom;
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

                return objInsiderInitialDisclosureController.DisplayPolicy(acid, PolicyDocumentID, DocumentID, page_call_from, true, year, Period, string.Empty, false, nUserInfoId);

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
        public ActionResult UploadHardDocument(Int64 nTransactionMasterId, int nDisclosureTypeCodeId, int acid, int year = 0, int nUserInfoId = 0)
        {
            //const string sLookUpPrefix = "tra_msg_";
            try
            {
                List<DocumentDetailsModel> lstDocumentDetailsModel = new List<DocumentDetailsModel>();

                lstDocumentDetailsModel = Common.Common.GenerateDocumentList(ConstEnum.Code.DisclosureTransaction, Convert.ToInt32(nTransactionMasterId), 0, null, 0);
                ViewBag.TransactionMasterId = nTransactionMasterId;
                ViewBag.DisclosureType = nDisclosureTypeCodeId;
                ViewBag.year = year;
                ViewBag.UserInfoId = nUserInfoId;
                ViewBag.UserAction = acid;

                return View("UploadHardDocument", lstDocumentDetailsModel);
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
        public ActionResult SubmitHardCopy(Int64 nTransactionMasterId, int nDisclosureTypeCodeId, int acid, int year = 0)
        {
            //const string sLookUpPrefix = "tra_msg_";
            LoginUserDetails objLoginUserDetails = null;
            TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
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
                    using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                    {
                        objTradingTransactionMasterDTO = new TradingTransactionMasterDTO();

                        objTradingTransactionMasterDTO.TransactionMasterId = nTransactionMasterId;
                        objTradingTransactionMasterDTO.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForHardCopySubmitted;
                        objTradingTransactionMasterDTO.CDDuringPE = false;
                        objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);

                    }
                    TempData.Remove("SearchArray");
                    if (objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType)
                    {
                        if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            if (nDisclosureCompletedFlag == 1)
                            {
                                return RedirectToAction("Index", "COInitialDisclosure",
                                   new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17344"));
                            }
                            else
                            {
                                return RedirectToAction("Index", "COInitialDisclosure",
                                    new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17345"));
                            }
                        }
                        else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                        {
                            if (objTradingTransactionMasterDTO.CDDuringPE == true)
                            {
                                //return RedirectToAction("PeriodStatus", "PeriodEndDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE, year = year }).Success(Common.Common.getResource("dis_msg_17345"));
                                return RedirectToAction("UsersStatus", "PeriodEndDisclosure",
                                new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE, year = year }).Success(Common.Common.getResource("dis_msg_17345"));
                            }
                            else
                            {
                                return RedirectToAction("ListByCO", "PreclearanceRequest",
                                    new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17345"));
                            }
                        }
                        else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                        {
                            return RedirectToAction("UsersStatus", "PeriodEndDisclosure",
                                new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE, year = year }).Success(Common.Common.getResource("dis_msg_17345"));
                        }
                        else
                        {
                            return null;
                        }
                    }
                    else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                    {
                        if (nDisclosureCompletedFlag == 1)
                        {
                            return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17344"));
                        }
                        else
                        {
                            return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17345"));
                        }
                    }
                    else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                    {
                        if (objTradingTransactionMasterDTO.CDDuringPE == true)
                        {
                            return RedirectToAction("PeriodStatus", "PeriodEndDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE, year = year }).Success(Common.Common.getResource("dis_msg_17345"));
                        }
                        else
                        {
                            return RedirectToAction("Index", "PreClearanceRequest", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17345"));
                        }
                    }
                    else if (nDisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                    {
                        return RedirectToAction("PeriodStatus", "PeriodEndDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE, year = year }).Success(Common.Common.getResource("dis_msg_17345"));
                    }
                    else
                    {
                        return null;
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
                    return View("UploadHardDocument", lstDocumentDetailsModel);
                }
            }
            catch (Exception exp)
            {
                lstDocumentDetailsModel = Common.Common.GenerateDocumentList(ConstEnum.Code.DisclosureTransaction, Convert.ToInt32(nTransactionMasterId), 0, null, 0);                
                ViewBag.UserAction = acid;
                ViewBag.TransactionMasterId = nTransactionMasterId;
                ViewBag.DisclosureType = nDisclosureTypeCodeId;
                ViewBag.year = year;
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
               

                return View("UploadHardDocument", lstDocumentDetailsModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion SubmitHardCopy

        #region SubmitSoftCopy
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult SubmitSoftCopy(int acid, Int64 TransactionMasterId, int DisclosureTypeCodeId, long TransactionLetterId, int year = 0, int period = 0, string __RequestVerificationToken = "", int formId = 0)
        {
            Dictionary<string, string> ErrorDictionary = new Dictionary<string, string>();
            //bool statusFlag = false;

            LoginUserDetails objLoginUserDetails = null;
            TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
            PrintTemplateModel objPrintTemplateModel = null;
            TemplateMasterDTO objTemplateMasterDTO = null;
            TransactionLetterModel objTransactionLetterModel = null;
            UserInfoDTO objUserInfoDTO = null;
            ViewBag.IsFormCSubmitted = false;
            ViewBag.acid = acid;
            ViewBag.ShowNote = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (TransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(TransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                objTradingTransactionMasterDTO = new TradingTransactionMasterDTO();

                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTradingTransactionMasterDTO.TransactionMasterId = TransactionMasterId;
                    objTradingTransactionMasterDTO.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForSoftCopySubmitted;
                    objTradingTransactionMasterDTO.CDDuringPE = false;
                    objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);
                    TempData.Remove("SearchArray");

                    if ((objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType) && !DisclosureTypeCodeId.Equals(ConstEnum.Code.DisclosureTypeContinuous))
                    {
                        if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            if (nDisclosureCompletedFlag == 1)
                            {
                                return RedirectToAction("Index", "COInitialDisclosure", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17344"));
                            }
                            else
                            {
                                return RedirectToAction("Index", "COInitialDisclosure", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17346"));
                            }
                        }
                        //else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                        //{
                        //    return RedirectToAction("ListByCO", "PreclearanceRequest", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17346"));
                        //}
                        else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                        {
                            return RedirectToAction("UsersStatus", "PeriodEndDisclosure", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE, year = year }).Success(Common.Common.getResource("dis_msg_17346"));
                        }
                        else
                        {
                            return null;
                        }
                    }
                    else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeInitial)
                    {
                        //if (nDisclosureCompletedFlag == 1)
                        //{
                        //    return RedirectToAction("Index", "InsiderInitialDisclosure",
                        //        new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17344"));
                        //}
                        //else
                        //{
                        //    return RedirectToAction("Index", "InsiderInitialDisclosure",
                        //        new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE }).Success(Common.Common.getResource("dis_msg_17346"));
                        //}
                        return RedirectToAction("ViewLetter", "TradingTransaction", new { nTransactionMasterId = TransactionMasterId, nDisclosureTypeCodeId = ConstEnum.Code.DisclosureTypeInitial, nLetterForCodeId = ConstEnum.Code.DisclosureLetterUserInsider, acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE_LETTER_SUBMISSION });

                    }
                    else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypeContinuous)
                    {
                        TempData["NseDownloadFlag"] = 1;
                        TempData["NseDownloadFlag1"] = 1;
                        return RedirectToAction("ViewLetter", "TradingTransaction", new { nTransactionMasterId = TransactionMasterId, nDisclosureTypeCodeId = ConstEnum.Code.DisclosureTypeContinuous, nLetterForCodeId = ConstEnum.Code.DisclosureLetterUserInsider, acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION });
                    }
                    else if (DisclosureTypeCodeId == ConstEnum.Code.DisclosureTypePeriodEnd)
                    {
                        return RedirectToAction("ViewLetter", "TradingTransaction", new { nTransactionMasterId = TransactionMasterId, nDisclosureTypeCodeId = ConstEnum.Code.DisclosureTypePeriodEnd, nLetterForCodeId = ConstEnum.Code.DisclosureLetterUserInsider, acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION, year = year, period = period });
                    }
                    else
                    {
                        return RedirectToAction("UploadHardDocument", "TradingTransaction", new { nTransactionMasterId = TransactionMasterId, acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE });
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

                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTemplateMasterDTO = objTradingTransactionSL.GetTransactionLetterDetails(objLoginUserDetails.CompanyDBConnectionString, TransactionLetterId, TransactionMasterId,
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

                    objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, TransactionMasterId);

                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, (int)objTradingTransactionMasterDTO.UserInfoId);
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
                objTradingTransactionMasterDTO = null;
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
        private void FillGrid(int m_nGridType, int R_nGridType, int nYearCode, int nPeriodCode, int acid, LoginUserDetails objLoginUserDetails, long? preclearenceID, int nTransactionMasterID, int nDisclosureTypeCodeId, int nPeriodType, int nSecurityTypeCodeId = 0, int nUserInfoId = 0, int nUserTypeCodeId = 0, int nSecurityTypeForGrid = 0)
        {
            List<PopulateComboDTO> lstSecurityList = null;
            List<PopulateComboDTO> lstReasonsForNotTrading = null;
            Dictionary<string, int> objSelectionElement = null;

            try
            {
                ViewBag.GridType = m_nGridType;
                ViewBag.nYearCode = nYearCode;
                ViewBag.nPeriodCode = nPeriodCode;
                ViewBag.nPeriodType = nPeriodType;
                ViewBag.acid = acid;
                ViewBag.UserinfoId = nUserInfoId;
                ViewBag.nUserTypeCodeId = nUserTypeCodeId;
                ViewBag.RGridType = R_nGridType;

                lstSecurityList = new List<PopulateComboDTO>();
                lstSecurityList = FillComboValues(ConstEnum.ComboType.SecurityTypeList, ConstEnum.CodeGroup.SecurityType, preclearenceID.ToString(), nTransactionMasterID.ToString(), nSecurityTypeCodeId.ToString(), null, false);

                ViewBag.SecurityType = lstSecurityList;

                lstReasonsForNotTrading = new List<PopulateComboDTO>();
                lstReasonsForNotTrading = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ReasonForNotTrading, null, null, null, null, true);
                ViewBag.lstReasonsForNotTrading = lstReasonsForNotTrading;
                ViewBag.LoginUserTypeCodeId = objLoginUserDetails.UserTypeCodeId;

                int? nOverrideGridType = null;
                int? nOverrideGridRelativeType = null;

                objSelectionElement = new Dictionary<string, int>();
                objSelectionElement["" + ConstEnum.Code.DisclosureTypeInitial + '_' + ConstEnum.Code.EmployeeType] = ConstEnum.GridType.TradingTransaction_InitialDisclosure_Insider;
                objSelectionElement["" + ConstEnum.Code.DisclosureTypeInitial + '_' + ConstEnum.Code.NonEmployeeType] = ConstEnum.GridType.TradingTransaction_InitialDisclosure_Insider;
                objSelectionElement["" + ConstEnum.Code.DisclosureTypeInitial + '_' + ConstEnum.Code.CorporateUserType] = ConstEnum.GridType.TradingTransaction_InitialDisclosure_Insider;
                objSelectionElement["" + ConstEnum.Code.DisclosureTypeInitial + '_' + ConstEnum.Code.COUserType] = ConstEnum.GridType.TradingTransaction_InitialDisclosure_CO;
                objSelectionElement["" + ConstEnum.Code.DisclosureTypeInitial + '_' + ConstEnum.Code.Admin] = ConstEnum.GridType.TradingTransaction_InitialDisclosure_CO;
                objSelectionElement["" + ConstEnum.Code.DisclosureTypeContinuous + '_' + ConstEnum.Code.EmployeeType] = ConstEnum.GridType.TradingTransaction_ContinuousDisclosure_Insider;
                objSelectionElement["" + ConstEnum.Code.DisclosureTypeContinuous + '_' + ConstEnum.Code.COUserType] = ConstEnum.GridType.TradingTransaction_ContinuousDisclosure_CO;
                objSelectionElement["" + ConstEnum.Code.DisclosureTypeContinuous + '_' + ConstEnum.Code.Admin] = ConstEnum.GridType.TradingTransaction_ContinuousDisclosure_CO;
                objSelectionElement["" + ConstEnum.Code.DisclosureTypePeriodEnd + '_' + ConstEnum.Code.EmployeeType] = ConstEnum.GridType.TradingTransaction_PeriodEndDisclosure_Insider;
                objSelectionElement["" + ConstEnum.Code.DisclosureTypePeriodEnd + '_' + ConstEnum.Code.COUserType] = ConstEnum.GridType.TradingTransaction_PeriodEndDisclosure_CO;
                objSelectionElement["" + ConstEnum.Code.DisclosureTypePeriodEnd + '_' + ConstEnum.Code.Admin] = ConstEnum.GridType.TradingTransaction_PeriodEndDisclosure_CO;


                if (nDisclosureTypeCodeId == 147001)
                {
                    if (objSelectionElement.ContainsKey("" + nDisclosureTypeCodeId + '_' + objLoginUserDetails.UserTypeCodeId) && (nSecurityTypeForGrid == 139004 || nSecurityTypeForGrid == 139005))
                    {
                        nOverrideGridType = Convert.ToInt32(ConstEnum.GridType.TradingTransaction_InitialDisclosure_Insider_OptionContract);
                        nOverrideGridRelativeType = Convert.ToInt32(ConstEnum.GridType.TradingTransaction_InitialDisclosure_Relative_OptionContract);
                    }
                }
                else
                {
                    if (objSelectionElement.ContainsKey("" + nDisclosureTypeCodeId + '_' + objLoginUserDetails.UserTypeCodeId))
                    {
                        nOverrideGridType = objSelectionElement["" + nDisclosureTypeCodeId + '_' + objLoginUserDetails.UserTypeCodeId];
                    }
                }
                ViewBag.OverrideGridType = nOverrideGridType;
                ViewBag.OverrideGridRelativeType = nOverrideGridRelativeType;

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
        public ActionResult PopulateCombo_OnChange(TradingTransactionModel objTradingTransactionModel, Boolean TransactionTypeCodeFlag, int DisclosureType)
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
                lstList = FillComboValues(ConstEnum.ComboType.UserDMATList, Convert.ToString(objTradingTransactionModel.ForUserInfoId), Convert.ToString(ConstEnum.Code.DisclosureTypePeriodEnd), null, null, null, true);
                ViewBag.UserDMAT = lstList;
                ViewBag.TransactionTypeCodeFlag = TransactionTypeCodeFlag;
            }
            finally
            {
                objLoginUserDetails = null;
                lstList = null;
            }

            return PartialView("PartialCreate", objTradingTransactionModel);
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
        private void CreatePopulateData(int UserInfoId, long TransactionMasterId, int acid, int nDisclosureTypeCodeId, int year, int period, int nSecurityTypeCodeId, long nPreclearenceID = 0, int periodType = 0)
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

                lstList = FillComboValues(ConstEnum.ComboType.UserPANList, Convert.ToString(UserInfoId), null, null, null, null, true);
                ViewBag.UserPan = lstList;


                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                ViewBag.TransactionType = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ModeOfAcquisition, null, null, null, null, true);
                ViewBag.ModeOfAcquisition = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.StockExchangeMaster, null, null, null, null, true);
                ViewBag.ExchangeTypeCode = lstList;
                // ViewBag.SecurityTypeCodeId = SecurityTypeCodeId;
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

                ViewBag.year = year;
                ViewBag.period = period;
                ViewBag.periodType = periodType;

                using (ComCodeSL objComCodeSL = new ComCodeSL())
                {
                    objComCodeDTO = objComCodeSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, nSecurityTypeCodeId);

                    ViewBag.SecurityTypeName = objComCodeDTO.CodeName;
                }
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
        public ActionResult LoadBalanceDMATwise(TradingTransactionModel objTradingTransactionModel)
        {
            ExerciseBalancePoolDTO objExerciseBalancePoolDTO = null;
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = new ApplicableTradingPolicyDetailsDTO();
            CompaniesSL objCompaniesSL = new CompaniesSL();
            TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL();
            TradingTransactionMasterDTO objTradingTransactionMasterDTO = new TradingTransactionMasterDTO();
            try
            {
                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionModel.TransactionMasterId);
                if (objTradingTransactionMasterDTO.DisclosureTypeCodeId != ConstEnum.Code.DisclosureTypeInitial)
                {
                    objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString,
                                                Convert.ToInt32(objTradingTransactionMasterDTO.UserInfoId), ConstEnum.Code.SecurityTypeShares, objTradingTransactionModel.DMATDetailsID);

                    if (objExerciseBalancePoolDTO != null)
                    {
                        ViewBag.ESOPQuantity = objExerciseBalancePoolDTO.ESOPQuantity;
                        ViewBag.OtherQuantity = objExerciseBalancePoolDTO.OtherQuantity;
                    }
                    ViewBag.GenCashAndCashlessPartialExciseOptionForContraTrade = objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade;
                    ViewBag.UseExerciseSecurityPool = objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool;
                }
                if (objTradingTransactionModel.TransactionDetailsId > 0)
                {
                    TradingTransactionDTO objTradingTransactionDTO = objTradingTransactionSL.GetTradingTransactionDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionModel.TransactionDetailsId));
                    objTradingTransactionModel.Quantity2 = objTradingTransactionDTO.Quantity2;
                    objTradingTransactionModel.Value2 = objTradingTransactionDTO.Value2;
                }
            }
            catch (Exception exp)
            {

            }

            return PartialView("_DMATwiseBalance", objTradingTransactionModel);
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
                    view_name = "Index";
                    controller_name = "InsiderInitialDisclosure";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE;
                    dynamicRoutValues["UserInfoId"] = Convert.ToInt32(Request.Params["uid"]);
                    dynamicRoutValues["ReqModuleId"] = ConstEnum.Code.RequiredModuleOwnSecurity;
                    break;

                case ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION:
                    view_name = "Index";
                    controller_name = "PreClearanceRequest";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE;
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

        #region GetImpactOnPostQuantity
        [HttpPost]
        public ActionResult GetImpactOnPostQuantity(int nTransTypeCodeId, int nModeOfAcquisCodeId, int nSecurityTypeCodeId)
        {

            LoginUserDetails objLoginUserDetails = null;
            int nImpactOnPostQuantity = 0;
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
                    nImpactOnPostQuantity = objPeriodEndDisclosureSL.GetImpactOnPostQuantity(objLoginUserDetails.CompanyDBConnectionString, nTransTypeCodeId, nModeOfAcquisCodeId, nSecurityTypeCodeId);

                    ViewBag.ImpactOnPostQuantity = nImpactOnPostQuantity;
                }

                return Json(new
                {
                    status = true,
                    Message = "",//Common.Common.getResource("rul_msg_15380")//
                    ImpactOnPostQuantity = nImpactOnPostQuantity
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
        #endregion GetImpactOnPostQuantity


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
                if (nDisclosureTypecodeId == InsiderTrading.Common.ConstEnum.Code.DisclosureTypeInitial)
                {
                    nIsTransactionEnter = 1;
                }

                string sCompanyName = null;
                List<PopulateComboDTO> lstConfirmationForCompanyList = null;
                List<PopulateComboDTO> lstConfirmationForNonCompanyList = null;
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.TradingTransactionMasterId = nTradingTransactionMasterId;
                ViewBag.DisclosureTypecodeId = nDisclosureTypecodeId;
                ViewBag.ConfigurationValueCodeId = nConfigurationValueCodeId;
                ViewBag.IsTransactionEnter = nIsTransactionEnter;
                ViewBag.IsDocumentUploaded = 0;
                ViewBag.acid = acid;
                ViewBag.nDisclosureStatus = nDisclosureStatus;
                Dictionary<int, string[]> dicResource = new Dictionary<int, string[]>();
                string nTransactionStatus = string.Empty;
                List<DuplicateTransactionDetailsDTO> objDuplicateTransactionsDTO = null;
                string alertMsg = string.Empty;
                List<PopulateComboDTO> lstSecurityList = null;
                string securityType = null;
                string transactionType = null;
                string dateOfAcquisition = null;
                List<PopulateComboDTO> lstTransactionTypeList = null;
                List<PopulateComboDTO> lstModeOfAcqList = null;
                string transactionStatus = null;
                string actionOne = string.Empty;
                string actionTwo = string.Empty;
                List<string> savedList = new List<string>();
                string ModeOfAcquisition = null;

                if (nIsDuplicateRecordFound != 1)
                {
                    using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                    {
                        objDuplicateTransactionsDTO = objTradingTransactionSL.CheckDuplicateTransaction(objLoginUserDetails.CompanyDBConnectionString, 0, 0, 0, null, nTradingTransactionMasterId);
                        foreach (var item in objDuplicateTransactionsDTO)
                        {
                            if (item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForNotConfirmed
                            || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForConfirmed
                            || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForSoftCopySubmitted
                            || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForHardCopySubmitted
                            || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForHardCopySubmittedByCO
                            || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForSubmitted)
                            {
                                alertMsg = Common.Common.getResource("tra_msg_50628");
                                lstSecurityList = new List<PopulateComboDTO>();
                                lstSecurityList = FillComboValues(ConstEnum.ComboType.SecurityTypeList, ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                                foreach (var type in lstSecurityList)
                                {
                                    if (item.SecurityType.ToString() == type.Key)
                                    {
                                        securityType = type.Value;
                                    }
                                }
                                dateOfAcquisition = item.DateOfAcquisition.Date.ToString("dd/MMM/yyyy");
                                lstTransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                                foreach (var type in lstTransactionTypeList)
                                {
                                    if (item.TransactionType.ToString() == type.Key)
                                    {
                                        transactionType = type.Value;
                                    }
                                }
                                lstModeOfAcqList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ModeOfAcquisition, null, null, null, null, true);
                                foreach (var type in lstModeOfAcqList)
                                {
                                    if (item.ModeOfAcquisition.ToString() == type.Key)
                                    {
                                        ModeOfAcquisition = type.Value;
                                    }
                                }
                                transactionStatus = (item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForConfirmed) ? Common.Common.getResource("tra_msg_50632") : (item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForNotConfirmed) ? Common.Common.getResource("tra_msg_50631") : "";
                                actionOne = Common.Common.getResource("tra_msg_50633");
                                actionTwo = Common.Common.getResource("tra_msg_50635");
                                alertMsg = alertMsg.Replace("$1", transactionType);
                                alertMsg = alertMsg.Replace("$2", item.Relation);
                                alertMsg = alertMsg.Replace("$3", dateOfAcquisition);
                                alertMsg = alertMsg.Replace("$4", item.Quantity.ToString());
                                alertMsg = alertMsg.Replace("$5", securityType);
                                alertMsg = alertMsg.Replace("$6", item.Value.ToString());
                                alertMsg = alertMsg.Replace("$7", ModeOfAcquisition);
                                alertMsg = alertMsg.Replace("$8", item.ExchangeCode == Common.ConstEnum.Code.StockExchange_NSE ? Common.Common.getResource("tra_lbl_50644") : item.ExchangeCode == Common.ConstEnum.Code.StockExchange_BSE ? Common.Common.getResource("tra_lbl_50645") : "");
                                alertMsg = alertMsg.Replace("$9", item.DMATAccountNo);
                                alertMsg = alertMsg.Replace("#1", item.DPName);
                                alertMsg = alertMsg.Replace("#2", item.DPID);
                                alertMsg = alertMsg.Replace("#3", item.TMID);
                                savedList.Add(alertMsg);
                                alertMsg = string.Empty;
                            }
                        }
                        if (savedList.Count > 0)
                        {
                            ViewBag.IsDuplicateRecordFound = 1;
                            ViewBag.MainHeading = Common.Common.getResource("tra_msg_50633");
                            ViewBag.SavedHeading = Common.Common.getResource("tra_msg_50634").Replace("$1", Common.Common.getResource("tra_msg_50639"));
                            ViewBag.SavedMessage = savedList;
                            ViewBag.TransactionMasterID = nTradingTransactionMasterId;
                            ViewBag.UserID = nUserId;
                            ViewBag.LastHeading = Common.Common.getResource("tra_msg_50636").Replace("$1", Common.Common.getResource("tra_msg_50638")).Replace("$2", Common.Common.getResource("tra_msg_50640"));
                            ViewBag.UserType = objLoginUserDetails.UserTypeCodeId;
                        }
                    }
                }
                using (CompaniesSL objCompaniesSL = new CompaniesSL())
                {
                    ImplementedCompanyDTO objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                    sCompanyName = objImplementedCompanyDTO.CompanyName;
                }
                dicResource.Add(ConstEnum.Code.DisclosureTypeInitial, new string[] { 
                    ((Common.Common.getResource("tra_msg_16452")).Replace(Environment.NewLine, "<br />"))
                    ,((Common.Common.getResource("tra_msg_16453")).Replace(Environment.NewLine, "<br />").Replace("$2",sCompanyName))
                    ,((Common.Common.getResource("tra_msg_16454")).Replace(Environment.NewLine, "<br />").Replace("$2",sCompanyName))
                    ,((Common.Common.getResource("tra_msg_16455")).Replace(Environment.NewLine, "<br />"))
                    ,((Common.Common.getResource("tra_msg_16456")).Replace(Environment.NewLine, "<br />"))
                    ,((Common.Common.getResource("tra_msg_16457")).Replace(Environment.NewLine, "<br />").Replace("$2",sCompanyName))
                    ,Common.Common.getResource("tra_msg_16458")
                    ,Common.Common.getResource("tra_msg_16459")
                    ,Common.Common.getResource("tra_msg_16460")
                    ,Common.Common.getResource("tra_msg_16461")
                });
                dicResource.Add(ConstEnum.Code.DisclosureTypeContinuous, new string[] {
                    ((Common.Common.getResource("tra_msg_16462")).Replace(Environment.NewLine, "<br />"))
                    ,((Common.Common.getResource("tra_msg_16463")).Replace(Environment.NewLine, "<br />").Replace("$2",sCompanyName))
                    ,((Common.Common.getResource("tra_msg_16464")).Replace(Environment.NewLine, "<br />").Replace("$2",sCompanyName))
                    ,((Common.Common.getResource("tra_msg_16465")).Replace(Environment.NewLine, "<br />"))
                    ,((Common.Common.getResource("tra_msg_16466")).Replace(Environment.NewLine, "<br />"))
                    ,((Common.Common.getResource("tra_msg_16467")).Replace(Environment.NewLine, "<br />").Replace("$2",sCompanyName))
                    ,Common.Common.getResource("tra_msg_16468")
                    ,Common.Common.getResource("tra_msg_16469")
                    ,Common.Common.getResource("tra_msg_16470")
                    ,Common.Common.getResource("tra_msg_16471")
                });
                dicResource.Add(ConstEnum.Code.DisclosureTypePeriodEnd, new string[] { 
                    ((Common.Common.getResource("tra_msg_16472")).Replace(Environment.NewLine, "<br />"))
                    ,((Common.Common.getResource("tra_msg_16473")).Replace(Environment.NewLine, "<br />").Replace("$2",sCompanyName))
                    ,((Common.Common.getResource("tra_msg_16474")).Replace(Environment.NewLine, "<br />").Replace("$2",sCompanyName))
                    ,((Common.Common.getResource("tra_msg_16475")).Replace(Environment.NewLine, "<br />"))
                    ,((Common.Common.getResource("tra_msg_16476")).Replace(Environment.NewLine, "<br />"))
                    ,((Common.Common.getResource("tra_msg_16477")).Replace(Environment.NewLine, "<br />").Replace("$2",sCompanyName))
                    ,Common.Common.getResource("tra_msg_16478") // ok
                    ,Common.Common.getResource("tra_msg_16479") // Yes i confirm
                    ,Common.Common.getResource("tra_msg_16480") // NO
                    ,Common.Common.getResource("tra_msg_16481") // Upload Details
                });
                ViewBag.ResourceArrey = dicResource[nDisclosureTypecodeId];
                ViewBag.CompanyName = sCompanyName;
                lstConfirmationForCompanyList = new List<PopulateComboDTO>();
                lstConfirmationForCompanyList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.ConfirmationForCompanyHoldings).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.ConfirmationForCompanyDropDown = lstConfirmationForCompanyList;

                lstConfirmationForNonCompanyList = new List<PopulateComboDTO>();
                lstConfirmationForNonCompanyList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.ConfirmationForNonCompanyHoldings).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.ConfirmationForNonCompanyDropDown = lstConfirmationForNonCompanyList;
                using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                {
                    var returnValue = objDocumentDetailsSL.GetDocumentCount(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, nTradingTransactionMasterId);
                    if (returnValue > 0)
                    {
                        ViewBag.IsDocumentUploaded = 1;
                    }
                }
                ViewBag.IsError = 0;
                ViewBag.ErrorMessage = dicResource[nDisclosureTypecodeId][5];
                if (((nConfigurationValueCodeId == ConstEnum.Code.EnterUploadSetting_UploadDetails || nConfigurationValueCodeId == ConstEnum.Code.EnterUploadSetting_EnterAndUploadDetails)
                    && (nDisclosureStatus != ConstEnum.Code.DisclosureStatusForDocumentUploaded || ViewBag.IsDocumentUploaded == 0)))
                {
                    ViewBag.IsError = 1;
                    ViewBag.ErrorMessage = Common.Common.getResource("tra_msg_16482"); //Please save the uploaded documents.
                }
                else if ((nConfigurationValueCodeId == ConstEnum.Code.EnterUploadSetting_EnterDetails && nIsTransactionEnter == 0)
                   || (nConfigurationValueCodeId == ConstEnum.Code.EnterUploadSetting_UploadDetails && ViewBag.IsDocumentUploaded == 0)
                   || (nConfigurationValueCodeId == ConstEnum.Code.EnterUploadSetting_EnterOrDetails && ViewBag.IsDocumentUploaded == 0 && nIsTransactionEnter == 0)
                   || (nConfigurationValueCodeId == ConstEnum.Code.EnterUploadSetting_EnterAndUploadDetails && (ViewBag.IsDocumentUploaded == 0 || nIsTransactionEnter == 0))
                   || (nConfigurationValueCodeId == ConstEnum.Code.EnterUploadSetting_EnterAndOrDetails && nIsTransactionEnter == 0)
                   )
                {
                    ViewBag.IsError = 1;
                }
                // return PartialView("TransactionConfirmationPopup");

                if (nFromSubmitPage == 1)
                {
                    ViewBag.FromSubmitPage = 1;
                }
                else
                {
                    ViewBag.FromSubmitPage = 0;
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
            return PartialView("TransactionConfirmationPopup");


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
                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTradingTransactionSL.TradingTransactionConfirmHoldingsFor(nTradingTransactionMasterId, rdo_nEnterHoldingFor, rdo_nUploadHoldingFor, objLoginUserDetails.LoggedInUserID, objLoginUserDetails.CompanyDBConnectionString);
                }
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


        #region Show duplicate transaction Alert
        [HttpPost]
        public ActionResult CheckDuplicateTransaction(int acid, int UserInfoId, int DisclosureType, int year, int period, long PreclearenceID, int periodType)//string alertMessage, string cancelBtnText
        {
            if (TempData["TradingTransactionModel"] != null && (DisclosureType == ConstEnum.Code.DisclosureTypeContinuous || DisclosureType == ConstEnum.Code.DisclosureTypePeriodEnd))
            {
                TradingTransactionModel tradingTransactionModel = (TradingTransactionModel)TempData["TradingTransactionModel"];
                TempData["DuplicateTransaction"] = true;
                TempData.Remove("TradingTransactionModel");
                return Create(tradingTransactionModel, acid, UserInfoId, DisclosureType, year, period, PreclearenceID, periodType);
            }

            return null;
        }
        #endregion Show duplicate transaction Alert


        [HttpPost]
        [TokenVerification]
        public JsonResult GetDataTableDataForInitialDisclosure(List<DataItemForDemat> DematitemCollection, List<DataItemForRelative> RelativeitemCollection, int TransactionDetailsId, int TransactionMasterId, int acid, int UserInfoId, int DisclosureType, int SecurityTypeCodeId, int year, int period, long PreclearenceID, int periodType, string __RequestVerificationToken, int formId)
        {
            TradingTransactionModel objTransactionModel = new TradingTransactionModel();
            TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL();
            CompaniesSL objCompaniesSL = new CompaniesSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            var ErrorDictionary = new Dictionary<string, string>();
            ErrorDictionary.Add("Success", Common.Common.getResource("dis_msg_17344"));
            bool statusFlag = false;
            string sucess_msg = "";
            bool IsSave = false;
            int chkContraOption = 0;
            int SecurityTypeID = 0;
            bool SubmitFlag = false;
            try
            {
                objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);

                if (objImplementedCompanyDTO.ContraTradeOption == InsiderTrading.Common.ConstEnum.Code.ContraTradeQuantiyBase)
                {
                    chkContraOption = 1;
                }

                //shubhangi
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
                dt.Columns.Add(new DataColumn("ESOPQty", typeof(decimal)));
                dt.Columns.Add(new DataColumn("OtherthanESOPQty", typeof(decimal)));
                dt.Columns.Add(new DataColumn("Currency", typeof(int)));
                dt.Columns.Add(new DataColumn("SecuritiesToBeTradedValue", typeof(decimal)));
                dt.Columns.Add(new DataColumn("LotSize", typeof(int)));
                dt.Columns.Add(new DataColumn("ContractSpecification", typeof(string)));

                int rowCount = 0;
                foreach (var UsrRec in DematitemCollection)
                {
                    if (!string.IsNullOrEmpty(UsrRec.UserInfoId) && UsrRec.UserInfoId != "null" && UsrRec.UserInfoId != "")
                    {
                        DataRow dr = dt.NewRow();
                        dt.Rows.Add(dr);
                        dt.Rows[rowCount]["TransactionMasterId"] = TransactionMasterId;
                        dt.Rows[rowCount]["SecurityTypeCodeId"] = Convert.ToInt32(SecurityTypeCodeId);
                        dt.Rows[rowCount]["UserInfoId"] = UsrRec.UserInfoId;
                        if (!string.IsNullOrEmpty(UsrRec.dmatId) && UsrRec.dmatId != "null")
                        {
                            dt.Rows[rowCount]["DMATDetailsID"] = Convert.ToInt32(UsrRec.dmatId);
                        }
                        else
                        {
                            dt.Rows[rowCount]["DMATDetailsID"] = 0;
                        }
                        dt.Rows[rowCount]["CompanyId"] = Convert.ToInt32(objImplementedCompanyDTO.CompanyId);
                        dt.Rows[rowCount]["ModeOfAcquisitionCodeId"] = 149001;
                        dt.Rows[rowCount]["ExchangeCodeId"] = 116001;
                        dt.Rows[rowCount]["TransactionTypeCodeId"] = 143001;
                        dt.Rows[rowCount]["SecuritiesToBeTradedQty"] = Convert.ToDecimal(UsrRec.tra_grd_16195);
                        if (chkContraOption == 1)
                        {
                            dt.Rows[rowCount]["ESOPQty"] = Convert.ToDecimal(UsrRec.tra_grd_16196);
                            dt.Rows[rowCount]["OtherthanESOPQty"] = Convert.ToDecimal(UsrRec.tra_grd_16197);
                        }
                        else
                        {
                            dt.Rows[rowCount]["ESOPQty"] = 0;
                            dt.Rows[rowCount]["OtherthanESOPQty"] = Convert.ToDecimal(UsrRec.tra_grd_16195);
                        }                        
                        dt.Rows[rowCount]["SecuritiesToBeTradedValue"] = Convert.ToDecimal(UsrRec.tra_grd_16198);
                        dt.Rows[rowCount]["LotSize"] = Convert.ToInt32(UsrRec.tra_grd_16199);
                        dt.Rows[rowCount]["ContractSpecification"] = Convert.ToString(UsrRec.tra_grd_16200);
                        rowCount = rowCount + 1;
                    }
                }

                foreach (var UsrRelRec in RelativeitemCollection)
                {
                    if (!string.IsNullOrEmpty(UsrRelRec.RelUserInfoId))
                    {
                        DataRow dr = dt.NewRow();
                        dt.Rows.Add(dr);
                        dt.Rows[rowCount]["TransactionMasterId"] = TransactionMasterId;
                        dt.Rows[rowCount]["SecurityTypeCodeId"] = Convert.ToInt32(SecurityTypeCodeId);
                        dt.Rows[rowCount]["UserInfoId"] = UsrRelRec.RelUserInfoId;
                        if (!string.IsNullOrEmpty(UsrRelRec.relDmatId) && UsrRelRec.relDmatId != "null")
                        {
                            dt.Rows[rowCount]["DMATDetailsID"] = Convert.ToInt32(UsrRelRec.relDmatId);
                        }
                        else
                        {
                            dt.Rows[rowCount]["DMATDetailsID"] = 0;
                        }
                        dt.Rows[rowCount]["CompanyId"] = Convert.ToInt32(objImplementedCompanyDTO.CompanyId);
                        dt.Rows[rowCount]["ModeOfAcquisitionCodeId"] = 149001;
                        dt.Rows[rowCount]["ExchangeCodeId"] = 116001;
                        dt.Rows[rowCount]["TransactionTypeCodeId"] = 143001;
                        dt.Rows[rowCount]["SecuritiesToBeTradedQty"] = Convert.ToDecimal(UsrRelRec.tra_grd_50749);
                        dt.Rows[rowCount]["ESOPQty"] = 0;
                        dt.Rows[rowCount]["OtherthanESOPQty"] = Convert.ToDecimal(UsrRelRec.tra_grd_50749);
                        dt.Rows[rowCount]["SecuritiesToBeTradedValue"] = Convert.ToDecimal(UsrRelRec.tra_grd_50750);
                        dt.Rows[rowCount]["LotSize"] = Convert.ToInt32(UsrRelRec.tra_grd_50783);
                        dt.Rows[rowCount]["ContractSpecification"] = Convert.ToString(UsrRelRec.tra_grd_50784);
                        rowCount = rowCount + 1;
                    }
                }

                int DematitemCollectionCount = DematitemCollection.Count;
                //objTransactionModel.DateOfInitimationToCompany = null;//why this is null..
                objTransactionModel.DateOfInitimationToCompany = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);

                IsSave = objTradingTransactionSL.InsertUpdateIDTradingTransactionDetails(objLoginUserDetails.CompanyDBConnectionString, dt);

                sucess_msg = Common.Common.getResource("dis_msg_17513");
                statusFlag = true;

                var MatchString = false;
                List<PopulateComboDTO> lstSecurityList1 = null;
                lstSecurityList1 = new List<PopulateComboDTO>();
                lstSecurityList1 = FillComboValues(ConstEnum.ComboType.SecurityTypeList, ConstEnum.CodeGroup.SecurityType, "", TransactionMasterId.ToString(), "0", null, false);
                int SecurityTypeCnt = 1;
                foreach (var Securitylist in lstSecurityList1)
                {
                    if (Convert.ToInt32(Securitylist.Key) == SecurityTypeCodeId)
                    {
                        MatchString = true;
                        SecurityTypeID = Convert.ToInt32(Securitylist.Key);
                    }
                    else
                    {
                        if (MatchString == true)
                        {
                            MatchString = false;
                            SecurityTypeID = Convert.ToInt32(Securitylist.Key);
                            break;
                        }
                    }
                    SecurityTypeCnt = SecurityTypeCnt + 1;
                    //if (SecurityTypeCnt == lstSecurityList1.Count)
                    //    SecurityTypeID = SecurityTypeCodeId;
                    if (SecurityTypeCnt > lstSecurityList1.Count)
                        SubmitFlag = true;
                }


                objTransactionModel.ForUserInfoId = UserInfoId;
                objTransactionModel.TransactionDetailsId = Convert.ToInt32(TransactionDetailsId);
                objTransactionModel.SecurityTypeCodeId = Convert.ToInt32(SecurityTypeCodeId);
                objTransactionModel.TransactionMasterId = TransactionMasterId;
                objTransactionModel.Value = 0;
                objTransactionModel.ESOPExcerseOptionQtyFlag = false;
                objTransactionModel.OtherESOPExcerseOptionFlag = false;
            }
            catch (Exception ex)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                statusFlag = false;
                string sErrMessage = Common.Common.getResource(ex.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                ErrorDictionary = GetModelStateErrorsAsString();
            }
            finally
            {

            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary,
                SecurityTypeID = SecurityTypeID,
                SubmitFlag = SubmitFlag
            },
            JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "NewCreate")]
        [ActionName("NewCreate")]
        [AuthorizationPrivilegeFilter]
        public ActionResult NewCreate(TradingTransactionModel objTransactionModel, int acid, int UserInfoId, int DisclosureType, int year, int period, long PreclearenceID, int periodType, bool flag)
        {
            LoginUserDetails objLoginUserDetails = null;

            CompanyPaidUpAndSubscribedShareCapitalDTO objCompanyAuthorizedShareCapitalDTO = null;
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = null;

            TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
            TradingPolicyDTO objTradingPolicyDTO = null;
            TradingTransactionDTO objTradingTransactionDTO = null;
            PreclearanceRequestDTO objPreclearanceRequestDTO = null;
            ExerciseBalancePoolDTO objExerciseBalancePoolDTO = null;
            CompaniesSL objCompaniesSL1 = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            string nTransactionStatus = string.Empty;
            List<DuplicateTransactionDetailsDTO> objDuplicateTransactionsDTO = null;
            string alertMsg = string.Empty;
            List<PopulateComboDTO> lstSecurityList = null;
            string securityType = null;
            string transactionType = null;
            string dateOfAcquisition = null;
            List<PopulateComboDTO> lstTransactionTypeList = null;
            List<PopulateComboDTO> lstModeOfAcqList = null;
            string transactionStatus = null;
            string cancelBtnText = null;
            int transactionMasterId = 0;
            string actionOne = string.Empty;
            string actionTwo = string.Empty;
            List<string> savedList = new List<string>();
            string ModeOfAcquisition = null;

            bool bIsValidDateOfAcquisition = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.IsNegative = true;
                ViewBag.UserTypeCode = objLoginUserDetails.UserTypeCodeId;
                ViewBag.postAcqNeMsg = Common.Common.getResource("tra_msg_16443");
                if (objTransactionModel.TransactionMasterId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.DisclosureTransaction, Convert.ToInt64(objTransactionModel.TransactionMasterId), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, objTransactionModel.TransactionMasterId);

                    int transactionId = 0;
                    DateTime dtPeriodEnd = Convert.ToDateTime(objTradingTransactionMasterDTO.PeriodEndDate);
                    bool cdDuringPE = true;
                    List<TradingTransactionMasterDTO> lstTransId = objTradingTransactionSL.Get_CDTransIdduringPE(objTradingTransactionMasterDTO, objLoginUserDetails.CompanyDBConnectionString, cdDuringPE);
                    foreach (var transId in lstTransId)
                        transactionId = Convert.ToInt32(transId.TransactionMasterId);


                    using (TradingPolicySL objTradingPolicySL = new TradingPolicySL())
                    {
                        objTradingPolicyDTO = objTradingPolicySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO.TradingPolicyId));

                        ViewBag.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = (objTradingPolicyDTO.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate ? 1 : 0);
                        ViewBag.SubscribedCapital = 0;

                        using (CompaniesSL objCompaniesSL = new CompaniesSL())
                        {
                            if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial && objTransactionModel.DateOfAcquisition != null)
                            {
                                objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, Convert.ToDateTime(objTransactionModel.DateOfAcquisition));

                                ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;
                            }

                            if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                            {
                                try
                                {
                                    objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, Convert.ToDateTime(Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString)));
                                    ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;
                                }
                                catch (Exception e)
                                {
                                    ViewBag.SubscribedCapital = 0;
                                    string sErrMessage = Common.Common.getResource(e.InnerException.Data[0].ToString());
                                    ModelState.AddModelError("Error", sErrMessage);
                                }
                            }
                        }

                        #region Validation Checks
                        //if (objTransactionModel.DateOfBecomingInsider == null)
                        //{
                        //    ModelState.AddModelError("DateOfBecomingInsider", Common.Common.getResource("tra_msg_16107"));
                        //}
                        //else
                        //{
                        //    if (objTransactionModel.DateOfBecomingInsider > Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString))
                        //    {
                        //        ModelState.AddModelError("DateOfBecomingInsider", Common.Common.getResource("tra_msg_16108"));
                        //    }
                        //}
                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial)
                        {
                            //if ((objTransactionModel.SecuritiesPriorToAcquisition == null || objTransactionModel.SecuritiesPriorToAcquisition < 0)
                            //    && objTradingTransactionSL.IsAllowNegativeBalanceForSecurity(Convert.ToInt32(objTransactionModel.SecurityTypeCodeId), objLoginUserDetails.CompanyDBConnectionString))
                            //{
                            //    ModelState.AddModelError("SecuritiesPriorToAcquisition", Common.Common.getResource("tra_msg_16109"));
                            //}
                            if (objTransactionModel.DateOfAcquisition == null)
                            {
                                ModelState.AddModelError("DateOfAcquisition", Common.Common.getResource("tra_msg_16110"));
                            }
                            else
                            {
                                if (objTransactionModel.DateOfAcquisition > Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString))
                                {
                                    ModelState.AddModelError("DateOfAcquisition", Common.Common.getResource("tra_msg_16111"));
                                }
                                else
                                {
                                    bIsValidDateOfAcquisition = true;
                                }
                            }
                        }
                        else
                        {
                            if (!objTradingTransactionSL.IsAllowNegativeBalanceForSecurity(Convert.ToInt32(objTransactionModel.SecurityTypeCodeId), objLoginUserDetails.CompanyDBConnectionString))
                            {
                                if (objTransactionModel.Quantity < 0)
                                {
                                    objTransactionModel.TransactionTypeCodeId = ConstEnum.Code.TransactionTypeSell;
                                    objTransactionModel.Quantity = objTransactionModel.Quantity * (-1);
                                }
                                else
                                {
                                    objTransactionModel.TransactionTypeCodeId = ConstEnum.Code.TransactionTypeBuy;
                                }
                            }
                            else
                            {
                                objTransactionModel.TransactionTypeCodeId = ConstEnum.Code.TransactionTypeBuy;
                            }

                            if (objTransactionModel.SecuritiesPriorToAcquisition == null)
                                objTransactionModel.SecuritiesPriorToAcquisition = 0;

                            if (objTransactionModel.PerOfSharesPostTransaction == null)
                                objTransactionModel.PerOfSharesPostTransaction = 0;
                        }
                        //if (objTransactionModel.ModeOfAcquisitionCodeId == null || objTransactionModel.ModeOfAcquisitionCodeId <= 0)
                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial && objTransactionModel.ModeOfAcquisitionCodeId <= 0)
                        {
                            ModelState.AddModelError("ModeOfAcquisitionCodeId", Common.Common.getResource("tra_msg_16112"));
                        }
                        if (objTransactionModel.DateOfInitimationToCompany == null)
                        {
                            ModelState.AddModelError("DateOfInitimationToCompany", Common.Common.getResource("tra_msg_16113"));
                        }
                        else
                        {
                            if (objTransactionModel.DateOfInitimationToCompany > Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString))
                            {
                                ModelState.AddModelError("DateOfInitimationToCompany", Common.Common.getResource("tra_msg_16114"));
                            }
                            if (objLoginUserDetails.UserTypeCodeId == Common.ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == Common.ConstEnum.Code.COUserType)
                            {
                                if (bIsValidDateOfAcquisition)
                                {
                                    if (objTransactionModel.DateOfInitimationToCompany < objTransactionModel.DateOfAcquisition)
                                    {
                                        ModelState.AddModelError("DateOfInitimationToCompany", Common.Common.getResource("tra_msg_16332"));
                                    }
                                }
                            }
                        }
                        //if (objTransactionModel.ForUserInfoId == null || objTransactionModel.ForUserInfoId <= 0)
                        if (objTransactionModel.ForUserInfoId <= 0)
                        {
                            ModelState.AddModelError("ForUserInfoId", Common.Common.getResource("tra_msg_16115"));
                        }
                        if (objTransactionModel.Quantity == null || objTransactionModel.Quantity <= 0)
                        {
                            //if (objTransactionModel.TransactionTypeCodeId != null && objTransactionModel.TransactionTypeCodeId > 0 && (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial || objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll))
                            if (objTransactionModel.TransactionTypeCodeId > 0 && (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial || objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll))
                            {
                                ModelState.AddModelError("Quantity", Common.Common.getResource("tra_msg_16184"));
                            }
                            else
                            {
                                if (objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeFutureContract || objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeOptionContract)
                                {
                                    ModelState.AddModelError("Quantity", Common.Common.getResource("tra_msg_16182"));
                                }
                                else if (acid != 155)
                                {
                                    ModelState.AddModelError("Quantity", Common.Common.getResource("tra_msg_16116"));
                                }
                            }

                        }
                        if (objTransactionModel.Value == null || objTransactionModel.Value <= 0)
                        {
                            //if (objTransactionModel.TransactionTypeCodeId != null && objTransactionModel.TransactionTypeCodeId > 0 && (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial || objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll))
                            if (objTransactionModel.TransactionTypeCodeId > 0 && (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial || objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll))
                            {
                                ModelState.AddModelError("Value", Common.Common.getResource("tra_msg_16185"));
                            }
                            else
                            {
                                if (objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeFutureContract || objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeOptionContract)
                                {
                                    if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial && (ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.EmployeeType || ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.CorporateUserType || ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.NonEmployeeType))
                                    { /*do nothing*/ }
                                    else
                                        ModelState.AddModelError("Value", Common.Common.getResource("tra_msg_16183"));
                                }
                                else
                                {
                                    if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial && (ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.EmployeeType || ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.CorporateUserType || ViewBag.UserTypeCode == @InsiderTrading.Common.ConstEnum.Code.NonEmployeeType))
                                    { /*do nothing*/ }
                                    else
                                        ModelState.AddModelError("Value", Common.Common.getResource("tra_msg_16117"));
                                }
                            }
                        }
                        //if (objTransactionModel.ExchangeCodeId == null || objTransactionModel.ExchangeCodeId <= 0)
                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial && objTransactionModel.ExchangeCodeId <= 0)
                        {
                            ModelState.AddModelError("ExchangeCodeId", Common.Common.getResource("tra_msg_16118"));
                        }
                        //if (objTransactionModel.TransactionTypeCodeId == null || objTransactionModel.TransactionTypeCodeId <= 0)
                        if (objTransactionModel.TransactionTypeCodeId <= 0)
                        {
                            ModelState.AddModelError("TransactionTypeCodeId", Common.Common.getResource("tra_msg_16119"));
                        }
                        //if (objTransactionModel.DMATDetailsID == null || objTransactionModel.DMATDetailsID <= 0)
                        if (objTransactionModel.DMATDetailsID <= 0)
                        {
                            ModelState.AddModelError("DMATDetailsID", Common.Common.getResource("tra_msg_16120"));
                        }
                        if (objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeOptionContract || objTransactionModel.SecurityTypeCodeId == ConstEnum.Code.SecurityTypeFutureContract)
                        {
                            if (objTransactionModel.LotSize == null || objTransactionModel.LotSize <= 0)
                            {
                                ModelState.AddModelError("LotSize", Common.Common.getResource("tra_msg_16121"));
                            }
                            if (objTransactionModel.ContractSpecification == null || objTransactionModel.ContractSpecification == "")
                            {
                                ModelState.AddModelError("ContractSpecification", Common.Common.getResource("tra_msg_16326"));
                            }
                            if (objTransactionModel.PerOfSharesPreTransaction == null)
                                objTransactionModel.PerOfSharesPreTransaction = 0;

                            if (objTransactionModel.PerOfSharesPostTransaction == null)
                                objTransactionModel.PerOfSharesPostTransaction = 0;
                        }
                        else
                        {
                            if (objTransactionModel.PerOfSharesPreTransaction == null)
                            {
                                ModelState.AddModelError("PerOfSharesPreTransaction", Common.Common.getResource("tra_msg_16122"));
                            }

                            if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial && (objTransactionModel.PerOfSharesPostTransaction == null))
                            {
                                ModelState.AddModelError("PerOfSharesPostTransaction", Common.Common.getResource("tra_msg_16123"));
                            }
                            else
                            {
                                if (objTransactionModel.PerOfSharesPostTransaction == null)
                                    objTransactionModel.PerOfSharesPostTransaction = 0;
                            }

                            if (objTransactionModel.LotSize == null)
                                objTransactionModel.LotSize = 0;
                        }

                        if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll || objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial)
                        {
                            if (objTransactionModel.Quantity2 == null || objTransactionModel.Quantity2 <= 0)
                            {
                                ModelState.AddModelError("Quantity2", Common.Common.getResource("tra_msg_16124"));
                            }
                            else
                            {
                                if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll && objTransactionModel.Quantity != objTransactionModel.Quantity2)
                                {
                                    ModelState.AddModelError("Quantity2", Common.Common.getResource("tra_lbl_16149"));
                                }
                                if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial && objTransactionModel.Quantity < objTransactionModel.Quantity2)
                                {
                                    ModelState.AddModelError("Quantity2", Common.Common.getResource("tra_lbl_16150"));
                                }
                            }
                            if (objTransactionModel.Value2 == null || objTransactionModel.Value2 <= 0)
                            {
                                ModelState.AddModelError("Value2", Common.Common.getResource("tra_msg_16125"));
                            }
                            else
                            {
                                if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessAll && objTransactionModel.Value != objTransactionModel.Value2)
                                {
                                    ModelState.AddModelError("Value2", Common.Common.getResource("tra_lbl_16151"));
                                }
                                if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeCashlessPartial && objTransactionModel.Value < objTransactionModel.Value2)
                                {
                                    ModelState.AddModelError("Value2", Common.Common.getResource("tra_lbl_16152"));
                                }
                            }
                        }
                        else
                        {
                            if (objTransactionModel.Quantity2 == null)
                                objTransactionModel.Quantity2 = 0;

                            if (objTransactionModel.Value2 == null)
                                objTransactionModel.Value2 = 0;
                        }
                        TempData.Keep("DuplicateTransaction");
                        if (ModelState.IsValid && TempData["DuplicateTransaction"] != null && (bool)TempData["DuplicateTransaction"] == false)
                        {
                            objDuplicateTransactionsDTO = objTradingTransactionSL.CheckDuplicateTransaction(objLoginUserDetails.CompanyDBConnectionString, objTransactionModel.ForUserInfoId, objTransactionModel.SecurityTypeCodeId, objTransactionModel.TransactionTypeCodeId, objTransactionModel.DateOfAcquisition, objTransactionModel.TransactionDetailsId);
                            foreach (var item in objDuplicateTransactionsDTO)
                            {
                                if (item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForNotConfirmed
                                || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForConfirmed
                                || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForSoftCopySubmitted
                                || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForHardCopySubmitted
                                || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForHardCopySubmittedByCO
                                || item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForSubmitted)
                                {
                                    alertMsg = Common.Common.getResource("tra_msg_50628");
                                    lstSecurityList = new List<PopulateComboDTO>();
                                    lstSecurityList = FillComboValues(ConstEnum.ComboType.SecurityTypeList, ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                                    foreach (var type in lstSecurityList)
                                    {
                                        if (item.SecurityType.ToString() == type.Key)
                                        {
                                            securityType = type.Value;
                                        }
                                    }
                                    dateOfAcquisition = item.DateOfAcquisition.Date.ToString("dd/MMM/yyyy");
                                    lstTransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                                    foreach (var type in lstTransactionTypeList)
                                    {
                                        if (item.TransactionType.ToString() == type.Key)
                                        {
                                            transactionType = type.Value;
                                        }
                                    }
                                    lstModeOfAcqList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ModeOfAcquisition, null, null, null, null, true);
                                    foreach (var type in lstModeOfAcqList)
                                    {
                                        if (item.ModeOfAcquisition.ToString() == type.Key)
                                        {
                                            ModeOfAcquisition = type.Value;
                                        }
                                    }
                                    transactionStatus = (item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForConfirmed) ? Common.Common.getResource("tra_msg_50632") : (item.TransactionStatus == Common.ConstEnum.Code.DisclosureStatusForNotConfirmed) ? Common.Common.getResource("tra_msg_50631") : "";
                                    actionOne = Common.Common.getResource("tra_msg_50633");
                                    actionTwo = Common.Common.getResource("tra_msg_50635");
                                    alertMsg = alertMsg.Replace("$1", transactionType);
                                    alertMsg = alertMsg.Replace("$2", item.Relation);
                                    alertMsg = alertMsg.Replace("$3", dateOfAcquisition);
                                    alertMsg = alertMsg.Replace("$4", item.Quantity.ToString());
                                    alertMsg = alertMsg.Replace("$5", securityType);
                                    alertMsg = alertMsg.Replace("$6", item.Value.ToString());
                                    alertMsg = alertMsg.Replace("$7", ModeOfAcquisition);
                                    alertMsg = alertMsg.Replace("$8", item.ExchangeCode == Common.ConstEnum.Code.StockExchange_NSE ? Common.Common.getResource("tra_lbl_50644") : item.ExchangeCode == Common.ConstEnum.Code.StockExchange_BSE ? Common.Common.getResource("tra_lbl_50645") : "");
                                    alertMsg = alertMsg.Replace("$9", item.DMATAccountNo);
                                    alertMsg = alertMsg.Replace("#1", item.DPName);
                                    alertMsg = alertMsg.Replace("#2", item.DPID);
                                    alertMsg = alertMsg.Replace("#3", item.TMID);
                                    savedList.Add(alertMsg);
                                    cancelBtnText = Common.Common.getResource("tra_btn_50629").Replace("$1", Common.Common.getResource("tra_msg_50631")).Replace("$2", Common.Common.getResource("tra_msg_50632"));
                                    alertMsg = string.Empty;
                                }
                            }
                            if (savedList.Count > 0)
                            {
                                TempData["TradingTransactionModel"] = objTransactionModel;
                                TempData["DuplicateTransaction"] = true;
                                return Json(new
                                {
                                    status = true,
                                    MainHeading = Common.Common.getResource("tra_msg_50633"),
                                    SavedHeading = Common.Common.getResource("tra_msg_50634").Replace("$1", Common.Common.getResource("tra_msg_50639")),
                                    SavedMessage = savedList,
                                    CancelButtonText = cancelBtnText,
                                    TransactionMasterId = objTransactionModel.TransactionDetailsId,
                                    SecurityType = objTransactionModel.SecurityTypeCodeId,
                                    TransactionType = objTransactionModel.TransactionTypeCodeId,
                                    DateOfAcquisition = objTransactionModel.DateOfAcquisition,
                                    UserRole = objLoginUserDetails.UserTypeCodeId,
                                    UserID = objTransactionModel.ForUserInfoId,
                                    LastHeading = Common.Common.getResource("tra_msg_50636").Replace("$1", Common.Common.getResource("tra_msg_50637")).Replace("$2", Common.Common.getResource("tra_msg_50639"))
                                }, JsonRequestBehavior.AllowGet);

                            }
                        }

                        #endregion Validation Checks


                        if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            objTransactionModel.ExchangeCodeId = ConstEnum.Code.StockExchange_NSE;
                            objTransactionModel.b_IsInitialDisc = true;
                            if (objTransactionModel.TransactionTypeCodeId == ConstEnum.Code.TransactionTypeSell)
                            {
                                objTransactionModel.ModeOfAcquisitionCodeId = ConstEnum.Code.ModeOfAcquisition_MarketSale;
                            }
                            else
                            {
                                objTransactionModel.ModeOfAcquisitionCodeId = ConstEnum.Code.ModeOfAcquisition_MarketPurchase;
                            }
                        }
                        else
                        {
                            objTransactionModel.b_IsInitialDisc = false;
                        }
                        if (!ModelState.IsValid)
                        {
                            CreatePopulateData(UserInfoId, objTransactionModel.TransactionMasterId, acid, DisclosureType, year, period, objTransactionModel.SecurityTypeCodeId, PreclearenceID, periodType);
                            objTransactionModel.DateOfBecomingInsider = ViewBag.sDateOfBecomingInsider;
                            objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objTransactionModel.TransactionMasterId);

                            //check if trading policy is define for user or not 
                            if (objApplicableTradingPolicyDetailsDTO != null)
                            {
                                ViewBag.GenCashAndCashlessPartialExciseOptionForContraTrade = objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade;
                                ViewBag.UseExerciseSecurityPool = objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool;
                            }

                            using (PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL())
                            {
                                if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial)
                                {
                                    objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString,
                                                               Convert.ToInt32(UserInfoId), ConstEnum.Code.SecurityTypeShares, objTransactionModel.DMATDetailsID);

                                    if (objExerciseBalancePoolDTO != null)
                                    {
                                        ViewBag.ESOPQuantity = objExerciseBalancePoolDTO.ESOPQuantity;
                                        ViewBag.OtherQuantity = objExerciseBalancePoolDTO.OtherQuantity;
                                    }
                                }

                                if (objTradingTransactionMasterDTO.PreclearanceRequestId != null && objTradingTransactionMasterDTO.PreclearanceRequestId > 0)
                                {

                                    objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt64(objTradingTransactionMasterDTO.PreclearanceRequestId));
                                    objTransactionModel.ESOPExcerseOptionQtyFlag = objPreclearanceRequestDTO.ESOPExcerciseOptionQtyFlag;
                                    objTransactionModel.OtherESOPExcerseOptionFlag = objPreclearanceRequestDTO.OtherESOPExcerciseOptionQtyFlag;
                                    ViewBag.ESOPExcerseOptionQtyFlagValue = objPreclearanceRequestDTO.ESOPExcerciseOptionQtyFlag;
                                    ViewBag.OtherESOPExcerseOptionFlagValue = objPreclearanceRequestDTO.OtherESOPExcerciseOptionQtyFlag;
                                }
                            }
                            objImplementedCompanyDTO = objCompaniesSL1.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                            if (objTransactionModel.SecurityTypeCodeId != null)
                            {
                                ViewBag.IsNegative = objTradingTransactionSL.IsAllowNegativeBalanceForSecurity(Convert.ToInt32(objTransactionModel.SecurityTypeCodeId), objLoginUserDetails.CompanyDBConnectionString);
                            }
                            ViewBag.ContraTradeOption = objImplementedCompanyDTO.ContraTradeOption;
                            ViewBag.addSecuritiesNotes = null;
                            ViewBag.addSecuritiesNotes = InsiderTrading.Common.Common.getResource("dis_msg_50549").Split('|');
                            return PartialView("Index", objTransactionModel);
                        }
                    }

                    objTradingTransactionDTO = new TradingTransactionDTO();

                    Common.Common.CopyObjectPropertyByName(objTransactionModel, objTradingTransactionDTO);
                    //For Employers and Insiders the DateOfIntemition to the company should always be the date when Insider Submitts the details. 
                    //So it is handled in the Submit procedure. For CO type user the date modified by user is saved against the transaction, the date should be >= date of acquisition
                    if (objLoginUserDetails.UserTypeCodeId != Common.ConstEnum.Code.Admin && objLoginUserDetails.UserTypeCodeId != Common.ConstEnum.Code.COUserType)
                    {
                        objTradingTransactionDTO.DateOfInitimationToCompany = null;
                    }
                    objImplementedCompanyDTO = objCompaniesSL1.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                    if (objTradingTransactionDTO.SecurityTypeCodeId == Common.ConstEnum.Code.SecurityTypeShares)
                    {
                        if (objImplementedCompanyDTO.ContraTradeOption == InsiderTrading.Common.ConstEnum.Code.ContraTradeWithoutQuantiy
                            && DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            objTradingTransactionDTO.ESOPExcerciseOptionQty = 0;
                            objTradingTransactionDTO.OtherExcerciseOptionQty = objTransactionModel.Quantity;
                        }
                        else if (objImplementedCompanyDTO.ContraTradeOption == InsiderTrading.Common.ConstEnum.Code.ContraTradeQuantiyBase
                            && DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                        {
                            objTradingTransactionDTO.ESOPExcerciseOptionQty = objTransactionModel.ESOPExcerciseOptionQtyModel;
                            objTradingTransactionDTO.OtherExcerciseOptionQty = objTransactionModel.OtherExcerciseOptionQtyModel;
                        }
                    }
                    else
                    {
                        objTradingTransactionDTO.ESOPExcerciseOptionQty = 0;
                        objTradingTransactionDTO.OtherExcerciseOptionQty = objTransactionModel.Quantity;
                    }

                    if (transactionId == 0)
                    {
                        if (DisclosureType == Common.ConstEnum.Code.DisclosureTypePeriodEnd)
                        {
                            using (TradingPolicySL objTradingPolicySL = new TradingPolicySL())
                            {
                                objTradingTransactionMasterDTO.TransactionMasterId = 0;
                                objTradingTransactionMasterDTO.PreclearanceRequestId = null;
                                objTradingTransactionMasterDTO.UserInfoId = UserInfoId;
                                objTradingTransactionMasterDTO.DisclosureTypeCodeId = Common.ConstEnum.Code.DisclosureTypeContinuous;//147002;
                                objTradingTransactionMasterDTO.TransactionStatusCodeId = Common.ConstEnum.Code.DisclosureStatusForNotConfirmed;// 148002;
                                objTradingTransactionMasterDTO.CDDuringPE = true;
                                objTradingTransactionMasterDTO.NoHoldingFlag = false;
                                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId);
                                objTradingTransactionMasterDTO.TradingPolicyId = objApplicableTradingPolicyDetailsDTO.TradingPolicyId;
                                objTradingTransactionMasterDTO.PeriodEndDate = dtPeriodEnd;
                                objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO, UserInfoId, out nDisclosureCompletedFlag);
                            }
                        }
                    }
                    objTradingTransactionDTO.TransactionMasterId = Convert.ToInt32(objTradingTransactionMasterDTO.TransactionMasterId);
                    //objTradingTransactionDTO = objTradingTransactionSL.InsertUpdateTradingTransactionDetails(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionDTO, UserInfoId);

                }

                if (TempData["DuplicateTransaction"] != null && (bool)TempData["DuplicateTransaction"] == true)
                {
                    TempData.Remove("DuplicateTransaction");
                    return RedirectToAction("Index", "TradingTransaction", new { acid = acid, TransactionMasterId = objTradingTransactionMasterDTO.TransactionMasterId, nPeriodCode = period, nYearCode = year, nPeriodType = periodType }).Success(Common.Common.getResource("tra_msg_16186"));
                }
                else
                {
                    return Json(new
                    {
                        url = Url.Action("Index", "TradingTransaction", new { acid = acid, TransactionMasterId = objTradingTransactionMasterDTO.TransactionMasterId, nPeriodCode = period, nYearCode = year, nPeriodType = periodType })
                    }, JsonRequestBehavior.AllowGet).Success(Common.Common.getResource("tra_msg_16186"));

                }
            }
            catch (Exception exp)
            {
                ViewBag.IsNegative = true;
                string sErrMessage;
                if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                {
                    objTransactionModel.b_IsInitialDisc = true;
                }
                else
                {
                    objTransactionModel.b_IsInitialDisc = false;
                }
                CreatePopulateData(UserInfoId, objTransactionModel.TransactionMasterId, acid, DisclosureType, year, period, objTransactionModel.SecurityTypeCodeId, PreclearenceID, periodType);
                objTransactionModel.DateOfBecomingInsider = ViewBag.sDateOfBecomingInsider;
                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, objTransactionModel.TransactionMasterId);
                    if (objTransactionModel.SecurityTypeCodeId != null)
                    {
                        ViewBag.IsNegative = objTradingTransactionSL.IsAllowNegativeBalanceForSecurity(Convert.ToInt32(objTransactionModel.SecurityTypeCodeId), objLoginUserDetails.CompanyDBConnectionString);
                    }
                    using (TradingPolicySL objTradingPolicySL = new TradingPolicySL())
                    {
                        objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objTransactionModel.TransactionMasterId);

                        objTradingPolicyDTO = objTradingPolicySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objTradingTransactionMasterDTO.TradingPolicyId));

                        ViewBag.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = (objTradingPolicyDTO.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate ? 1 : 0);
                        ViewBag.SubscribedCapital = 0;

                        using (CompaniesSL objCompaniesSL = new CompaniesSL())
                        {
                            if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial)
                            {
                                objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, Convert.ToDateTime(objTransactionModel.DateOfAcquisition));

                                ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;
                            }

                            if (DisclosureType == ConstEnum.Code.DisclosureTypeInitial)
                            {
                                try
                                {
                                    objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetailsForTransactionOnDate(objLoginUserDetails.CompanyDBConnectionString, Convert.ToDateTime(Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString)));
                                    ViewBag.SubscribedCapital = objCompanyAuthorizedShareCapitalDTO.PaidUpShare;
                                }
                                catch (Exception e)
                                {
                                    ViewBag.SubscribedCapital = 0;
                                    sErrMessage = Common.Common.getResource(e.InnerException.Data[0].ToString());
                                    ModelState.AddModelError("Error", sErrMessage);
                                }
                            }
                        }

                        //check if trading policy is define for user or not 
                        if (objApplicableTradingPolicyDetailsDTO != null)
                        {
                            ViewBag.GenCashAndCashlessPartialExciseOptionForContraTrade = objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade;
                            ViewBag.UseExerciseSecurityPool = objApplicableTradingPolicyDetailsDTO.UseExerciseSecurityPool;
                        }
                    }

                    using (PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL())
                    {
                        if (DisclosureType != ConstEnum.Code.DisclosureTypeInitial)
                        {
                            objExerciseBalancePoolDTO = objPreclearanceRequestSL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString,
                                                       Convert.ToInt32(UserInfoId), ConstEnum.Code.SecurityTypeShares, objTransactionModel.DMATDetailsID);

                            if (objExerciseBalancePoolDTO != null)
                            {
                                ViewBag.ESOPQuantity = objExerciseBalancePoolDTO.ESOPQuantity;
                                ViewBag.OtherQuantity = objExerciseBalancePoolDTO.OtherQuantity;
                            }
                        }

                        if (objTradingTransactionMasterDTO.PreclearanceRequestId != null && objTradingTransactionMasterDTO.PreclearanceRequestId > 0)
                        {

                            objPreclearanceRequestDTO = objPreclearanceRequestSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt64(objTradingTransactionMasterDTO.PreclearanceRequestId));
                            objTransactionModel.ESOPExcerseOptionQtyFlag = objPreclearanceRequestDTO.ESOPExcerciseOptionQtyFlag;
                            objTransactionModel.OtherESOPExcerseOptionFlag = objPreclearanceRequestDTO.OtherESOPExcerciseOptionQtyFlag;
                            ViewBag.ESOPExcerseOptionQtyFlagValue = objPreclearanceRequestDTO.ESOPExcerciseOptionQtyFlag;
                            ViewBag.OtherESOPExcerseOptionFlagValue = objPreclearanceRequestDTO.OtherESOPExcerciseOptionQtyFlag;
                        }
                    }
                }

                ViewBag.postAcqNeMsg = Common.Common.getResource("tra_msg_16443");

                sErrMessage = Common.Common.GetErrorMessage(exp);// Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);

                objImplementedCompanyDTO = objCompaniesSL1.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                ViewBag.ContraTradeOption = objImplementedCompanyDTO.ContraTradeOption;
                ViewBag.addSecuritiesNotes = null;
                ViewBag.addSecuritiesNotes = InsiderTrading.Common.Common.getResource("dis_msg_50549").Split('|');
                return View("Index", objTransactionModel);
            }
            finally
            {
                objTradingTransactionMasterDTO = null;
                objLoginUserDetails = null;
                objTradingPolicyDTO = null;
                objCompanyAuthorizedShareCapitalDTO = null;
                objPreclearanceRequestDTO = null;
                objTradingTransactionDTO = null;
                objExerciseBalancePoolDTO = null;
                objCompaniesSL1 = null;
                objImplementedCompanyDTO = null;
            }
        }




    }
}
