using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class TradingPolicyController : Controller
    {
        #region Trading Policy List
        /// <summary>
        /// This method is used for show trading policy list.
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                FillGrid(ConstEnum.GridType.TradingPolicyList, null, null, null);
                if (objLoginUserDetails.BackURL != null && objLoginUserDetails.BackURL != "")
                {
                    ViewBag.BackButton = true;
                    ViewBag.BackURL = objLoginUserDetails.BackURL;
                    objLoginUserDetails.BackURL = "";
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                }
                else
                {
                    ViewBag.BackButton = false;
                }
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
            }
        }
        #endregion Trading Policy List

        #region Trading Policy History List
        /// <summary>
        /// show trading policy histroy list.
        /// </summary>
        /// <param name="TradingPolicyId"></param>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult History(int TradingPolicyId, int acid, string CalledFrom)
        {
            try
            {
                ViewBag.Param1 = TradingPolicyId;
                ViewBag.CalledFrom = CalledFrom;
                ViewBag.ParentTradingPolicy = TradingPolicyId;
                FillGrid(InsiderTrading.Common.ConstEnum.GridType.TradingPolicyHistoryList, TradingPolicyId.ToString(), null, null);
                return View("TradingPolicyHistoryList");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index");
            }
            finally
            {

            }
        }
        #endregion Trading Policy History List

        #region Create Accordian Panel
        /// <summary>
        /// This method open the accordian panel
        /// </summary>
        /// <param name="TradingPolicyId"></param>
        /// <param name="CalledFrom"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int TradingPolicyId, string CalledFrom, int? ParentTradingPolicy,int acid)
        {
            #region Variable & Object Declaration
            TradingPolicyModel objTradingPolicyModel = new TradingPolicyModel();
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicyDTO objTradingPolicyDTO = new TradingPolicyDTO();
            List<PopulateComboDTO> lstAssignedContraTradeSecurityType = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstAssignedExceptionFor = new List<PopulateComboDTO>();
            List<TransactionSecurityMapConfigDTO> lstTransactionSecurityMapConfigDTO = new List<TransactionSecurityMapConfigDTO>();
            List<string> lst = new List<string>();
            ApplicabilitySL objApplicabilitySL = new ApplicabilitySL();
            List<TradingPolicyForTransactionSecurityDTO> lstTradingPolicyForTransactionSecurityDTO = null;
            ApplicabilityDTO objApplicabilityDTO = null;
            CompaniesSL objCompaniesSL = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO=new ImplementedCompanyDTO();
            #endregion Variable & Object Declaration

            #region try
            try
            {
                #region Load Dropdown values
                ViewBag.TradingPolicyCodeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PolicyGroup, null, null, null, null, false);
                ViewBag.Transactiontradesinglemultiple = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionTradeSingleOrMultiple, null, null, null, null, false);
                ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                ViewBag.GenExceptionForList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                ViewBag.StExMultiTradeFreqList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.StExMultiTradeCalFinYearList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.CalendarOrFinancialYear, null, null, null, null, false);
                ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                objTradingPolicyModel.AssignedPreClearancerequiredforTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.PreclearanceRequest.ToString(), TradingPolicyId.ToString(), null, null, null, false);
                ViewBag.ProhibitTransactionTypeList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.PreclearanceRequest.ToString(), TradingPolicyId.ToString(), null, null, null, false);
                objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), TradingPolicyId.ToString(), null, null, null, false);
                objTradingPolicyModel.AllSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                objTradingPolicyModel.ContraTradeSelectedSecurityTypeList = FillComboValues(ConstEnum.ComboType.TradingPolicyContraTradeSelectedSecurity, InsiderTrading.Common.ConstEnum.Code.ContraTradeSelectedSecurity.ToString(), TradingPolicyId.ToString(), null, null, null, false);
             
                #endregion Load Dropdown values

                objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);

                if (TradingPolicyId > 0)
                {
                    objTradingPolicyDTO = objTradingPolicySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, TradingPolicyId);
                    if (objTradingPolicyDTO.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures != null)
                    {
                        ViewBag.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures = objTradingPolicyDTO.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures;                        
                    }
                    ViewBag.SeekDeclarationUPSIFlag = objTradingPolicyDTO.SeekDeclarationFromEmpRegPossessionOfUPSIFlag;

                    Common.Common.CopyObjectPropertyByName(objTradingPolicyDTO, objTradingPolicyModel);
                    objTradingPolicyModel.ThresholdLimtResetFlag = (objTradingPolicyModel.TradingThresholdLimtResetFlag != null && (bool)objTradingPolicyModel.TradingThresholdLimtResetFlag) ? TPYesNo.Yes : TPYesNo.No;
                   
                    /*
                     *get Applicability details.
                     */
                    objApplicabilityDTO = objApplicabilitySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, InsiderTrading.Common.ConstEnum.Code.TradingPolicy, TradingPolicyId);
                    if (objApplicabilityDTO != null)
                    {
                        ViewBag.HasApplicabilityDefinedFlag = 1;
                    }
                    else
                    {
                        ViewBag.HasApplicabilityDefinedFlag = 0;
                    }
                    ViewBag.TradingPolicyType = objTradingPolicyModel.TradingPolicyForCodeId;
                    int CountUserAndOverlapTradingPolicy = 0;
                    objTradingPolicySL.GetUserwiseOverlapTradingPolicyCount(objLoginUserDetails.CompanyDBConnectionString, TradingPolicyId, out CountUserAndOverlapTradingPolicy);
                    ViewBag.CountUserAndOverlapTradingPolicy = CountUserAndOverlapTradingPolicy;
                }
                else
                {
                    objTradingPolicyModel.PreClrProhibitNonTradePeriodFlag = true;
                    objTradingPolicyModel.PreClrReasonForNonTradeReqFlag = true;
                    objTradingPolicyModel.PreClrSeekDeclarationForUPSIFlag = true;
                    objTradingPolicyModel.PreClrReasonForNonTradeReqFlag = true;
                    objTradingPolicyModel.GenTradingPlanTransFlag = true;
                    objTradingPolicyModel.DiscloInitReqFlag = true;
                    objTradingPolicyModel.DiscloPeriodEndReqFlag = true;
                    objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag = true;
                    objTradingPolicyModel.GenCashAndCashlessPartialExciseOptionForContraTrade = InsiderTrading.Common.ConstEnum.Code.ESOPExciseOptionFirstandThenOtherShares;
                    objTradingPolicyModel.ContraTradeBasedOn = InsiderTrading.Common.ConstEnum.Code.ContraTradeBasedOnAllSecurityType;
                }
                objTradingPolicyModel.AssignedGenExceptionForList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.TradingPolicyExceptionforTransactionMode.ToString(), TradingPolicyId.ToString(), null, null, null, false);//lstAssignedExceptionFor;
                ViewBag.CalledFrom = CalledFrom;
                ViewBag.ParentTradingPolicy = ParentTradingPolicy;
                ViewBag.OccurrenceFrequencyYearly = InsiderTrading.Common.ConstEnum.Code.Yearly;
                ViewBag.TradingPolicyEmployeeType = InsiderTrading.Common.ConstEnum.Code.TradingPolicyEmployeeType;
                ViewBag.MultipleTransactionTrade = InsiderTrading.Common.ConstEnum.Code.MultipleTransactionTrade;
                objTradingPolicyModel.TradingPolicyDocumentFile = Common.Common.GenerateDocumentList(Common.ConstEnum.Code.TradingPolicy, TradingPolicyId, 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.TradingPolicyFile);
                lstTransactionSecurityMapConfigDTO = objTradingPolicySL.TransactionSecurityMapConfigList(objLoginUserDetails.CompanyDBConnectionString, null).ToList<TransactionSecurityMapConfigDTO>();
                objTradingPolicyModel.AllTransactionSecurityMappingList = lstTransactionSecurityMapConfigDTO;
                
                foreach (var item in objTradingPolicyModel.AssignedPreClearancerequiredforTransactionList)
                {
                    lst.Add(item.Key);
                }
                ViewBag.SelectPreclearanceTransaction = lst;
                if (TradingPolicyId > 0)
                {
                    lstTradingPolicyForTransactionSecurityDTO =
                            objTradingPolicySL.TradingPolicyForTransactionSecurityList(objLoginUserDetails.CompanyDBConnectionString, TradingPolicyId, 132004).ToList<TradingPolicyForTransactionSecurityDTO>();
                    ViewBag.TradingPolicyForTransactionSecurityList = lstTradingPolicyForTransactionSecurityDTO;
                }
                if (acid == InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_VIEW)
                {
                    ViewBag.TradingPolicyUserAction = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_VIEW;
                }else if (acid == InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_CREATE){
                    ViewBag.TradingPolicyUserAction = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_CREATE;
                }
                else if (acid == InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_EDIT)
                {
                    ViewBag.TradingPolicyUserAction = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_EDIT;
                }

                
                ViewBag.ContraTradeOption = objImplementedCompanyDTO.ContraTradeOption;
                if (objImplementedCompanyDTO.ContraTradeOption==null)
                {
                    ModelState.AddModelError("Error", InsiderTrading.Common.Common.getResource("rul_msg_15447")); 
                    if (objLoginUserDetails.BackURL != null && objLoginUserDetails.BackURL != "")
                    {
                        ViewBag.BackButton = true;
                        ViewBag.BackURL = objLoginUserDetails.BackURL;
                        objLoginUserDetails.BackURL = "";
                        Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                    }
                    else
                    {
                        ViewBag.BackButton = false;
                    }
                    FillGrid(ConstEnum.GridType.TradingPolicyList, null, null, null);
                    return View("Index");
                }
                ViewBag.AutoSubmitTransaction = objImplementedCompanyDTO.AutoSubmitTransaction;
                return View("Create", objTradingPolicyModel);
            }
            #endregion try

            #region catch
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Create", objTradingPolicyModel);
            }
            #endregion catch

            #region finally
            finally
            {
                objTradingPolicyModel = null;
                objTradingPolicySL = null;
                objLoginUserDetails = null;
                objTradingPolicyDTO = null;
                lstAssignedExceptionFor = null;
                lstTransactionSecurityMapConfigDTO = null;
                objApplicabilitySL = null;
                lst = null;
                lstTradingPolicyForTransactionSecurityDTO = null;
                objApplicabilityDTO = null;
                objCompaniesSL = null;
                objImplementedCompanyDTO = null;
            }
            #endregion finally

        }
        #endregion Create Accordian Panel

        #region Save Trading Policy
        /// <summary>
        /// 
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <returns></returns>
        [HttpPost]
        //    [Button(ButtonName = "BasicInfo")]
        //  [ActionName("BasicInfo")]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult BasicInfo(TradingPolicyModel objTradingPolicyModel, string CalledFrom, string PreclearanceSecuritywisedata,
            string ContinousSecuritywisedata, string SelectedOptionsCheckBox, int acid, string SelectedSecurityTypeOptions)
        {
            List<PopulateComboDTO> lstAssignedSecurityType = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstAssignedExceptionFor = new List<PopulateComboDTO>();
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            TradingPolicyDTO objTradingPolicyDTO = new TradingPolicyDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            DataTable tblPreClearanceSecuritywise = new DataTable("PreClearanceSecuritywise");
            CompaniesSL objCompaniesSL = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            try
            {
                  objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);

                  if (objTradingPolicyModel.TradingPolicyForCodeId == ConstEnum.Code.TradingPolicyEmployeeType || 
                      objImplementedCompanyDTO.AutoSubmitTransaction == 178002)
                {
                    objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId = ConstEnum.Code.MultipleTransactionTrade;
                }

                #region Validation Part
                List<PreSecuritiesValuesModel> PreClearanceSecuritywiseList = new List<PreSecuritiesValuesModel>();
                List<PreSecuritiesValuesModel> ContinousSecuritywiseList = new List<PreSecuritiesValuesModel>();

                    if (PreclearanceSecuritywisedata != null)
                    {
                        PreClearanceSecuritywiseList = JsonConvert.DeserializeObject<List<PreSecuritiesValuesModel>>(PreclearanceSecuritywisedata);
                    }
                    else
                    {
                        PreClearanceSecuritywiseList = null;
                    }
                    tblPreClearanceSecuritywise.Columns.Add(new DataColumn("SecurityCodeID", typeof(int)));
                    tblPreClearanceSecuritywise.Columns.Add(new DataColumn("NoOfShare", typeof(int)));
                    tblPreClearanceSecuritywise.Columns.Add(new DataColumn("Capital", typeof(float)));
                    tblPreClearanceSecuritywise.Columns.Add(new DataColumn("ValueOfShare", typeof(float)));
                    if (PreClearanceSecuritywiseList != null)
                    {
                        foreach (var item in PreClearanceSecuritywiseList)
                        {
                            DataRow row = tblPreClearanceSecuritywise.NewRow();
                            // if (item.NoOfShare != null && item.Capital != null && item.ValueOfShare != null)
                            if (item.NoOfShare != null || item.Capital != null || item.ValueOfShare != null)
                            {
                                if (item.SecurityCodeID > 0)
                                {
                                    row["SecurityCodeID"] = item.SecurityCodeID;
                                }
                                else
                                {
                                    row["SecurityCodeID"] = DBNull.Value;
                                }
                                if (item.NoOfShare != null)
                                {
                                    row["NoOfShare"] = item.NoOfShare;
                                }
                                else
                                {
                                    row["NoOfShare"] = DBNull.Value;
                                }
                                if (item.Capital != null)
                                {
                                    row["Capital"] = item.Capital;
                                }
                                else
                                {
                                    row["Capital"] = DBNull.Value;
                                }
                                if (item.ValueOfShare != null)
                                {
                                    row["ValueOfShare"] = item.ValueOfShare;
                                }
                                else
                                {
                                    row["ValueOfShare"] = DBNull.Value;
                                }
                                //  row["Capital"] = item.Capital;
                                //  row["ValueOfShare"] = item.ValueOfShare;
                                tblPreClearanceSecuritywise.Rows.Add(row);
                            }
                        }

                }
                if (ContinousSecuritywisedata != null)
                {
                    ContinousSecuritywiseList = JsonConvert.DeserializeObject<List<PreSecuritiesValuesModel>>(ContinousSecuritywisedata);
                }
                else
                {
                    ContinousSecuritywiseList = null;
                }
               
                DataTable tblContinousSecuritywise = new DataTable("ContinousSecuritywise");
                tblContinousSecuritywise.Columns.Add(new DataColumn("SecurityCodeID", typeof(int)));
                tblContinousSecuritywise.Columns.Add(new DataColumn("NoOfShare", typeof(int)));
                tblContinousSecuritywise.Columns.Add(new DataColumn("Capital", typeof(float)));
                tblContinousSecuritywise.Columns.Add(new DataColumn("ValueOfShare", typeof(float)));


                if (ContinousSecuritywiseList != null)
                {
                    foreach (var item in ContinousSecuritywiseList)
                    {
                        DataRow row = tblContinousSecuritywise.NewRow();
                        //   if (item.NoOfShare != null && item.Capital != null && item.ValueOfShare != null)
                        if (item.NoOfShare != null || item.Capital != null || item.ValueOfShare != null)
                        {
                            if (item.SecurityCodeID > 0)
                            {
                                row["SecurityCodeID"] = item.SecurityCodeID;
                            }
                            else
                            {
                                row["SecurityCodeID"] = DBNull.Value;
                            }
                            if (item.NoOfShare != null)
                            {
                                row["NoOfShare"] = item.NoOfShare;
                            }
                            else
                            {
                                row["NoOfShare"] = DBNull.Value;
                            }
                            if (item.Capital != null)
                            {
                                row["Capital"] = item.Capital;
                            }
                            else
                            {
                                row["Capital"] = DBNull.Value;
                            }
                            if (item.ValueOfShare != null)
                            {
                                row["ValueOfShare"] = item.ValueOfShare;
                            }
                            else
                            {
                                row["ValueOfShare"] = DBNull.Value;
                            }
                            tblContinousSecuritywise.Rows.Add(row);
                        }
                    }
                }


                List<TransactionSecuritymap> lstTransactionSecuritymap = new List<TransactionSecuritymap>();
                if (SelectedOptionsCheckBox != null)
                {
                    lstTransactionSecuritymap = JsonConvert.DeserializeObject<List<TransactionSecuritymap>>(SelectedOptionsCheckBox);
                }
                else
                {
                    lstTransactionSecuritymap = null;
                }

                DataTable tblPreclearanceTransactionSecurityMapping = new DataTable("tblPreclearanceTransactionSecurityMapping");
                tblPreclearanceTransactionSecurityMapping.Columns.Add(new DataColumn("MapToTypeCodeID", typeof(int)));
                tblPreclearanceTransactionSecurityMapping.Columns.Add(new DataColumn("TransactionModeCodeId", typeof(int)));
                tblPreclearanceTransactionSecurityMapping.Columns.Add(new DataColumn("SecurityTypeCodeId", typeof(int)));


                if (lstTransactionSecuritymap != null)
                {
                    foreach (var item in lstTransactionSecuritymap)
                    {
                        DataRow row = tblPreclearanceTransactionSecurityMapping.NewRow();
                        //   if (item.NoOfShare != null && item.Capital != null && item.ValueOfShare != null)
                        if (item.SecurityType != null)
                        {
                            row["SecurityTypeCodeId"] = item.SecurityType;
                        }
                        else
                        {
                            row["SecurityTypeCodeId"] = DBNull.Value;
                        }
                        if (item.TransactionType != null)
                        {
                            row["TransactionModeCodeId"] = item.TransactionType;
                        }
                        else
                        {
                            row["TransactionModeCodeId"] = DBNull.Value;
                        }
                        row["MapToTypeCodeID"] = 132004;
                        tblPreclearanceTransactionSecurityMapping.Rows.Add(row);

                    }
                }

                List<TransactionSecuritymap> lstContraTradeSecuritymap = new List<TransactionSecuritymap>();
                if (SelectedSecurityTypeOptions != null)
                {
                    lstContraTradeSecuritymap = JsonConvert.DeserializeObject<List<TransactionSecuritymap>>(SelectedSecurityTypeOptions);
                }
                else
                {
                    lstContraTradeSecuritymap = null;
                }
                string sContraTradeSecurityTypeCommaSeparatedList = string.Join(",", lstContraTradeSecuritymap.Select(x => x.SecurityType));
                

                if (objTradingPolicyModel.TradingPolicyForCodeId == null || objTradingPolicyModel.TradingPolicyForCodeId <= 0)
                {
                    ModelState.AddModelError("TradingPolicyForCodeId", InsiderTrading.Common.Common.getResource("rul_msg_15368"));//"Mandatory : Trading Policy Type");
                }

                if (objTradingPolicyModel.TradingPolicyStatusCodeId == null)
                {
                    objTradingPolicyModel.TradingPolicyStatusCodeId = InsiderTrading.Common.ConstEnum.Code.TradingPolicyStatusIncomplete; //141001;

                    if (objTradingPolicyModel.ApplicableFromDate != null && objTradingPolicyModel.ApplicableToDate != null)
                    {
                        DateTime dtFromDate = (DateTime)objTradingPolicyModel.ApplicableFromDate;
                        DateTime dtToDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString, false, "usr_com"); //(DateTime)objTradingPolicyModel.ApplicableToDate;
                        int? a = DateTime.Compare(dtFromDate.Date, dtToDate.Date);
                    }
                }
                else if (objTradingPolicyModel.TradingPolicyStatusCodeId == InsiderTrading.Common.ConstEnum.Code.TradingPolicyStatusActive)
                {
                    if (objTradingPolicyModel.ApplicableFromDate != null && objTradingPolicyModel.ApplicableToDate != null)
                    {
                        DateTime dtFromDate = (DateTime)objTradingPolicyModel.ApplicableFromDate;
                        DateTime dtToDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString, false, "usr_com"); //(DateTime)objTradingPolicyModel.ApplicableToDate;

                        int? a = DateTime.Compare(dtFromDate.Date, dtToDate.Date);

                        if (a <= 0)
                        {
                            ModelState.AddModelError("ApplicableFromDate", InsiderTrading.Common.Common.getResource("rul_msg_15390"));//"From Date cannot be less than Current Date");
                        }
                    }

                    if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType && objTradingPolicyModel.PreClrTradesApprovalReqFlag == null)
                    {
                        ModelState.AddModelError("PreClrTradesApprovalReqFlag", InsiderTrading.Common.Common.getResource("rul_msg_15073"));
                    }

                    if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType &&
                        objTradingPolicyModel.PreClrTradesApprovalReqFlag == false &&
                        objTradingPolicyModel.PreClrForAllSecuritiesFlag == null)
                    {
                        ModelState.AddModelError("PreClrForAllSecuritiesFlag", InsiderTrading.Common.Common.getResource("rul_msg_15379"));// "Mandatory :- Approval Required for Single Transaction select security flag.");
                    }

                    //if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType && objTradingPolicyModel.SelectedPreClearancerequiredforTransaction != null)
                    //{
                    //    if (tblPreclearanceTransactionSecurityMapping.Rows.Count <= 0)
                    //    {

                    //        ModelState.AddModelError("SelectedPreClearancerequiredforTransaction", "Mandatory : Enter at least one entry for Preclearance Required for Secuity Type.");
                    //    }
                    //}

                    if (!objTradingPolicyModel.PreClrTradesApprovalReqFlag)
                    {
                        if (!objTradingPolicyModel.PreClrForAllSecuritiesFlag)
                        {

                            string sErrorMessage = "";
                            var distinctIds = tblPreclearanceTransactionSecurityMapping.AsEnumerable()
                                               .Select(s => new
                                               {
                                                   SecurityTypeCodeId = s.Field<int>("SecurityTypeCodeId"),
                                               })
                                               .Distinct().ToList();

                            foreach (var row in distinctIds)
                            {
                                List<PopulateComboDTO> securityList =
                                                   FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                                var obj = securityList.Find(x => x.Key == row.SecurityTypeCodeId.ToString());

                                var PreclearanceLimit = tblPreClearanceSecuritywise.AsEnumerable()
                                             .Select(s => new
                                             {
                                                 SecurityCodeID = s.Field<int?>("SecurityCodeID"),
                                                 NoOfShare = s.Field<int?>("NoOfShare"),
                                                 Capital = s.Field<float?>("Capital"),
                                                 ValueOfShare = s.Field<float?>("ValueOfShare"),
                                             })
                                               .ToList();



                                var objPreclearanceLimit = PreclearanceLimit.Find(x => x.SecurityCodeID == row.SecurityTypeCodeId);

                                if (objPreclearanceLimit != null)
                                {
                                    if (objPreclearanceLimit.NoOfShare == null && objPreclearanceLimit.Capital == null && objPreclearanceLimit.ValueOfShare == null)
                                    {

                                        if (sErrorMessage == "")
                                        {
                                            sErrorMessage = InsiderTrading.Common.Common.getResource("rul_msg_15422") + obj.Value;
                                        }
                                        else
                                        {
                                            sErrorMessage = sErrorMessage + ", " + obj.Value;
                                        }
                                        ModelState.AddModelError("PreClrForAllSecuritiesFlag", sErrorMessage);
                                    }
                                }
                                else
                                {
                                    if (sErrorMessage == "")
                                    {
                                        sErrorMessage = InsiderTrading.Common.Common.getResource("rul_msg_15422") + obj.Value;
                                    }
                                    else
                                    {
                                        sErrorMessage = sErrorMessage + ", " + obj.Value;
                                    }
                                }
                            }


                            if (sErrorMessage != "")
                            {

                                ModelState.AddModelError("PreClrForAllSecuritiesFlag", sErrorMessage);
                            }
                        }
                        else
                        {
                            if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType
                          && !objTradingPolicyModel.PreClrTradesApprovalReqFlag && objTradingPolicyModel.PreClrForAllSecuritiesFlag != null)
                            {
                                if (tblPreClearanceSecuritywise.Rows.Count <= 0)
                                {

                                    ModelState.AddModelError("PreClrForAllSecuritiesFlag", InsiderTrading.Common.Common.getResource("rul_msg_15369"));//"Mandatory : Enter at least one entry for Preclearance Required security type");
                                }


                            }
                        }
                    }

                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag && objTradingPolicyModel.StExSubmitTradeDiscloAllTradeFlag == false
                        && objTradingPolicyModel.StExForAllSecuritiesFlag != null)
                    {
                        if (tblContinousSecuritywise.Rows.Count <= 0)
                        {
                            ModelState.AddModelError("StExForAllSecuritiesFlag", InsiderTrading.Common.Common.getResource("rul_msg_15370"));//"Mandatory : Enter at least one entry for Continous discosure security type");
                        }
                    }

                    if (objTradingPolicyModel.StExSubmitTradeDiscloAllTradeFlag == false &&
                        objTradingPolicyModel.StExForAllSecuritiesFlag == null)
                    {
                        ModelState.AddModelError("StExForAllSecuritiesFlag", InsiderTrading.Common.Common.getResource("rul_msg_15378"));//"Mandatory :- Continous Disclosure please select secuity type flag.");
                    }
                    if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType &&
                        objTradingPolicyModel.SelectedPreClearancerequiredforTransaction != null  
                         && 
                        objTradingPolicyModel.PreClrCOApprovalLimit == null)
                    {
                        ModelState.AddModelError("PreClrCOApprovalLimit", InsiderTrading.Common.Common.getResource("rul_msg_15076"));
                    }
                    if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType &&
                         objTradingPolicyModel.PreClrApprovalValidityLimit == null)
                    {
                        ModelState.AddModelError("PreClrApprovalValidityLimit", InsiderTrading.Common.Common.getResource("rul_msg_15077"));
                    }
                    if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType &&
                        objTradingPolicyModel.PreClrSeekDeclarationForUPSIFlag == true
                        && (objTradingPolicyModel.PreClrUPSIDeclaration == null || objTradingPolicyModel.PreClrUPSIDeclaration == ""))
                    {
                        ModelState.AddModelError("PreClrUPSIDeclaration", InsiderTrading.Common.Common.getResource("rul_msg_15078"));
                    }
                    if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType &&
                        objTradingPolicyModel.PreClrReasonForNonTradeReqFlag == true
                       && ((objTradingPolicyModel.PreClrCompleteTradeNotDoneFlag == null || objTradingPolicyModel.PreClrCompleteTradeNotDoneFlag == false)
                           && (objTradingPolicyModel.PreClrPartialTradeNotDoneFlag == null || objTradingPolicyModel.PreClrPartialTradeNotDoneFlag == false)))
                    {
                        ModelState.AddModelError("PreClrPartialTradeNotDoneFlag", InsiderTrading.Common.Common.getResource("rul_msg_15079"));
                    }

                    if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType
                          && !objTradingPolicyModel.PreClrTradesApprovalReqFlag  && objTradingPolicyModel.PreClrSingMultiPreClrFlagCodeId == null)
                    {
                        ModelState.AddModelError("PreClrSingMultiPreClrFlagCodeId", InsiderTrading.Common.Common.getResource("rul_lbl_15445"));
                    }

                    /*
                        1. Validation For Initial Disclosure.
                     */
                    if (objTradingPolicyModel.DiscloInitReqFlag == null)
                    {
                        ModelState.AddModelError("DiscloInitReqFlag", InsiderTrading.Common.Common.getResource("rul_msg_15080"));
                    }
                    if (objTradingPolicyModel.DiscloInitReqFlag == true && 
                        (objTradingPolicyModel.DiscloInitLimit == null || objTradingPolicyModel.DiscloInitLimit <= 0))
                    {
                        ModelState.AddModelError("DiscloInitLimit", InsiderTrading.Common.Common.getResource("rul_msg_15081"));
                    }
                    if (objTradingPolicyModel.DiscloInitReqFlag == true && objTradingPolicyModel.DiscloInitDateLimit == null)
                    {
                        ModelState.AddModelError("DiscloInitDateLimit", InsiderTrading.Common.Common.getResource("rul_msg_15082"));
                    }
                    if (objTradingPolicyModel.DiscloInitReqFlag == true && objTradingPolicyModel.DiscloInitSubmitToStExByCOFlag == null)
                    {
                        ModelState.AddModelError("DiscloInitSubmitToStExByCOFlag", InsiderTrading.Common.Common.getResource("rul_msg_15083"));
                    }

                    //Continuous Disclosure Validation

                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == null)
                    {
                        ModelState.AddModelError("StExSubmitDiscloToCOByInsdrFlag", InsiderTrading.Common.Common.getResource("rul_msg_15371"));//"Mandatory : Trade (Continous) Disclosure to be submitted by Insider/Employee to Company");
                    }
                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && (objTradingPolicyModel.StExTradePerformDtlsSubmitToCOByInsdrLimit == null || objTradingPolicyModel.StExTradePerformDtlsSubmitToCOByInsdrLimit <= 0))
                    {
                        ModelState.AddModelError("StExTradePerformDtlsSubmitToCOByInsdrLimit", InsiderTrading.Common.Common.getResource("rul_msg_15372"));//"Mandatory : Trading Details to be submitted by Insider/Employee to CO within");
                    }
                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && objTradingPolicyModel.StExSubmitTradeDiscloAllTradeFlag == null)
                    {
                        ModelState.AddModelError("StExSubmitTradeDiscloAllTradeFlag", InsiderTrading.Common.Common.getResource("rul_msg_15085"));
                    }
                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && objTradingPolicyModel.StExSubmitTradeDiscloAllTradeFlag == false && objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId == null)
                    {
                        ModelState.AddModelError("StExSingMultiTransTradeFlagCodeId", InsiderTrading.Common.Common.getResource("rul_msg_15086"));
                    }

                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && objTradingPolicyModel.StExSubmitTradeDiscloAllTradeFlag == false && objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId == InsiderTrading.Common.ConstEnum.Code.MultipleTransactionTrade &&
                        objTradingPolicyModel.StExMultiTradeFreq == InsiderTrading.Common.ConstEnum.Code.Yearly &&
                        (objTradingPolicyModel.StExMultiTradeCalFinYear == null || objTradingPolicyModel.StExMultiTradeCalFinYear <= 0))
                    {
                        ModelState.AddModelError("StExTransTradeShareValue", InsiderTrading.Common.Common.getResource("rul_msg_15089"));
                    }
                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && objTradingPolicyModel.StExSubmitDiscloToStExByCOFlag == null)
                    {
                        ModelState.AddModelError("StExSubmitDiscloToStExByCOFlag", InsiderTrading.Common.Common.getResource("rul_msg_15090"));
                    }
                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && objTradingPolicyModel.StExSubmitDiscloToStExByCOFlag == true 
                        && objTradingPolicyModel.StExTradeDiscloSubmitLimit == null)
                    {
                        ModelState.AddModelError("StExTradeDiscloSubmitLimit", InsiderTrading.Common.Common.getResource("rul_msg_15091"));
                    }

                    // Period End Disclosure Validation

                    if (objTradingPolicyModel.DiscloPeriodEndReqFlag == null)
                    {
                        ModelState.AddModelError("DiscloPeriodEndReqFlag", InsiderTrading.Common.Common.getResource("rul_msg_15092"));
                    }
                    if (objTradingPolicyModel.DiscloPeriodEndReqFlag == true && (objTradingPolicyModel.DiscloPeriodEndFreq == null || objTradingPolicyModel.DiscloPeriodEndFreq <= 0))
                    {
                        ModelState.AddModelError("DiscloPeriodEndFreq", InsiderTrading.Common.Common.getResource("rul_msg_15093"));
                    }
                    if (objTradingPolicyModel.DiscloPeriodEndReqFlag == true && objTradingPolicyModel.DiscloPeriodEndToCOByInsdrLimit == null || objTradingPolicyModel.DiscloPeriodEndToCOByInsdrLimit <= 0)
                    {
                        ModelState.AddModelError("DiscloPeriodEndToCOByInsdrLimit", InsiderTrading.Common.Common.getResource("rul_msg_15094"));
                    }
                    if (objTradingPolicyModel.DiscloPeriodEndReqFlag == true && objTradingPolicyModel.DiscloPeriodEndSubmitToStExByCOFlag == null)
                    {
                        ModelState.AddModelError("DiscloPeriodEndSubmitToStExByCOFlag", InsiderTrading.Common.Common.getResource("rul_msg_15095"));
                    }
                    if (objTradingPolicyModel.DiscloPeriodEndReqFlag == true &&  objTradingPolicyModel.DiscloPeriodEndSubmitToStExByCOFlag == true 
                        && (objTradingPolicyModel.DiscloPeriodEndSubmitToStExByCOLimit == null || objTradingPolicyModel.DiscloPeriodEndSubmitToStExByCOLimit <= 0))
                    {
                        ModelState.AddModelError("DiscloPeriodEndSubmitToStExByCOLimit", InsiderTrading.Common.Common.getResource("rul_msg_15096"));
                    }

                    //General Validation

                    if (objTradingPolicyModel.GenMinHoldingLimit == null || objTradingPolicyModel.GenMinHoldingLimit < 0)
                    {
                        ModelState.AddModelError("GenMinHoldingLimit", InsiderTrading.Common.Common.getResource("rul_msg_15097"));
                    }
                    if (objTradingPolicyModel.GenContraTradeNotAllowedLimit == null || objTradingPolicyModel.GenContraTradeNotAllowedLimit <= 0)
                    {
                        ModelState.AddModelError("GenContraTradeNotAllowedLimit", InsiderTrading.Common.Common.getResource("rul_msg_15098"));
                    }

                  

                    if (objImplementedCompanyDTO.ContraTradeOption == InsiderTrading.Common.ConstEnum.Code.ContraTradeQuantiyBase 
                        && (objTradingPolicyModel.GenCashAndCashlessPartialExciseOptionForContraTrade == null 
                        || objTradingPolicyModel.GenCashAndCashlessPartialExciseOptionForContraTrade <= 0))
                    {
                        ModelState.AddModelError("GenCashAndCashlessPartialExciseOptionForContraTrade", InsiderTrading.Common.Common.getResource("rul_msg_15443"));
                    }
                    if (objTradingPolicyModel.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate == null)
                    {
                        ModelState.AddModelError("GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate", InsiderTrading.Common.Common.getResource("rul_msg_15444"));
                    }

                    if (lstContraTradeSecuritymap == null || lstContraTradeSecuritymap.Count <= 0)
                    {
                        ModelState.AddModelError("contratradesecuritytype", InsiderTrading.Common.Common.getResource("rul_msg_15458"));
                    }
                    ApplicabilityDTO objApplicablityDTO = new ApplicabilityDTO();
                    ApplicabilitySL objApplicablitySL = new ApplicabilitySL();
                    objApplicablityDTO = objApplicablitySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.TradingPolicy, Convert.ToInt32(objTradingPolicyModel.TradingPolicyId));
                    if (objTradingPolicyModel.TradingPolicyId > 0 && objApplicablityDTO == null)
                    {
                        ModelState.AddModelError("", InsiderTrading.Common.Common.getResource("rul_msg_15392"));//"Mandatory : Applicability is not defined for this trading policy.");
                    }


                }
                if (!ModelState.IsValid)
                {
                    // The user didn't select any value => redisplay the form
                    //return View("Create", objTradingPolicyModel);

                    // return View("Create", objPreclearanceRequestModel);
                    // return Json(ModelState);
                    return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
                }

                #endregion Validation Part

              
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objTradingPolicyModel, objTradingPolicyDTO);
                objTradingPolicyDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;

                if (objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId != null && objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId == ConstEnum.Code.MultipleTransactionTrade)
                {
                    objTradingPolicyDTO.TradingThresholdLimtResetFlag = (objTradingPolicyModel.ThresholdLimtResetFlag == TPYesNo.Yes) ? true : false;
                }
                else
                {
                    objTradingPolicyDTO.TradingThresholdLimtResetFlag = null;
                }

                if (objTradingPolicyModel.SelectedGenSecurityType != null && objTradingPolicyModel.SelectedGenSecurityType.Count() > 0)
                {
                    var sSubmittedSecurityTypeList = String.Join(",", objTradingPolicyModel.SelectedGenSecurityType);
                    objTradingPolicyDTO.GenSecurityType = sSubmittedSecurityTypeList;
                }
                if (objTradingPolicyModel.SelectedGenExceptionFor != null && objTradingPolicyModel.SelectedGenExceptionFor.Count() > 0)
                {
                    var sExceptionForList = String.Join(",", objTradingPolicyModel.SelectedGenExceptionFor);
                    objTradingPolicyDTO.GenExceptionFor = sExceptionForList;
                }

                if (objTradingPolicyModel.SelectedPreClearancerequiredforTransaction != null && objTradingPolicyModel.SelectedPreClearancerequiredforTransaction.Count() > 0)
                {
                    var sSelectedPreClearancerequiredforTransactionList = String.Join(",", objTradingPolicyModel.SelectedPreClearancerequiredforTransaction);
                    objTradingPolicyDTO.SelectedPreClearancerequiredforTransactionValue = sSelectedPreClearancerequiredforTransactionList;
                }

                if (objTradingPolicyModel.SelectedPreClrProhibitNonTradePeriodTransaction != null && objTradingPolicyModel.SelectedPreClrProhibitNonTradePeriodTransaction.Count() > 0)
                {
                    var sSelectedPreClrProhibitNonTradePeriodTransaction = String.Join(",", objTradingPolicyModel.SelectedPreClrProhibitNonTradePeriodTransaction);
                    objTradingPolicyDTO.SelectedPreClearanceProhibitforNonTradingforTransactionValue = sSelectedPreClrProhibitNonTradePeriodTransaction;
                }
                if (objTradingPolicyModel.GenCashAndCashlessPartialExciseOptionForContraTrade == null || objTradingPolicyModel.GenCashAndCashlessPartialExciseOptionForContraTrade == 0)
                {
                    objTradingPolicyDTO.GenCashAndCashlessPartialExciseOptionForContraTrade = InsiderTrading.Common.ConstEnum.Code.ESOPExciseOptionFirstandThenOtherShares;
                }

                if (sContraTradeSecurityTypeCommaSeparatedList != null && sContraTradeSecurityTypeCommaSeparatedList != "")
                {
                    objTradingPolicyDTO.SelectedContraTradeSecuirtyType = sContraTradeSecurityTypeCommaSeparatedList;
                }
                
                //New column added on 2-Jun-2016(YES BANK customization)
                if (objTradingPolicyDTO.SeekDeclarationFromEmpRegPossessionOfUPSIFlag == true)
                {
                    objTradingPolicyDTO.SeekDeclarationFromEmpRegPossessionOfUPSIFlag = objTradingPolicyModel.SeekDeclarationFromEmpRegPossessionOfUPSIFlag;
                    objTradingPolicyDTO.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures = objTradingPolicyModel.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures;
                    objTradingPolicyDTO.DeclarationToBeMandatoryFlag = objTradingPolicyModel.DeclarationToBeMandatoryFlag;
                    objTradingPolicyDTO.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag = objTradingPolicyModel.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag;
                }
                else
                {
                    objTradingPolicyDTO.SeekDeclarationFromEmpRegPossessionOfUPSIFlag = objTradingPolicyModel.SeekDeclarationFromEmpRegPossessionOfUPSIFlag;
                    objTradingPolicyDTO.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures = string.Empty;
                    objTradingPolicyDTO.DeclarationToBeMandatoryFlag = false;
                    objTradingPolicyDTO.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag = false;
                }

                objTradingPolicyDTO.CurrentHistoryCodeId = InsiderTrading.Common.ConstEnum.Code.CurrentRecord;
                objTradingPolicyDTO = objTradingPolicySL.Save(objLoginUserDetails.CompanyDBConnectionString, objTradingPolicyDTO, tblPreClearanceSecuritywise, 
                    tblContinousSecuritywise,tblPreclearanceTransactionSecurityMapping);
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objTradingPolicyDTO, objTradingPolicyModel);

                objTradingPolicyModel.ThresholdLimtResetFlag = (objTradingPolicyModel.TradingThresholdLimtResetFlag != null && (bool)objTradingPolicyModel.TradingThresholdLimtResetFlag) ? TPYesNo.Yes : TPYesNo.No;

                // return RedirectToAction("Create", new { TradingPolicyId = objTradingPolicyModel.TradingPolicyId, CalledFrom = CalledFrom });
                int? nTradingPolicyStatus = objTradingPolicyDTO.TradingPolicyStatusCodeId;
                string sMessage = "";
                if (nTradingPolicyStatus == InsiderTrading.Common.ConstEnum.Code.TradingPolicyStatusActive)
                {
                    ArrayList lst = new ArrayList();
                    lst.Add(objTradingPolicyModel.TradingPolicyName);
                    sMessage = InsiderTrading.Common.Common.getResource("rul_msg_15409", lst);
                }
                else if (nTradingPolicyStatus == InsiderTrading.Common.ConstEnum.Code.TradingPolicyStatusInactive)
                {
                    ArrayList lst = new ArrayList();
                    lst.Add(objTradingPolicyModel.TradingPolicyName);
                    sMessage = InsiderTrading.Common.Common.getResource("rul_msg_15410", lst);
                }
                else
                {
                    ArrayList lst = new ArrayList();
                    lst.Add(objTradingPolicyModel.TradingPolicyName);
                    sMessage = InsiderTrading.Common.Common.getResource("rul_msg_15374",lst);
                }
                return Json(new
                {
                    status = true,
                    msg = sMessage,//objTradingPolicyModel.TradingPolicyName + InsiderTrading.Common.Common.getResource("rul_msg_15374"),//" Save Successfully",
                    TradingPolicyId = objTradingPolicyModel.TradingPolicyId,
                    CalledFrom = CalledFrom,
                    TradingPolicyStatus = nTradingPolicyStatus
                });
            }
            catch (Exception exp)
            {
                //  ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                //     return View("Create", objTradingPolicyModel);
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                // return View("Create", objPreclearanceRequestModel);
                //  return Json(ModelState);

                return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
            }
            finally
            {
                ViewBag.TradingPolicyCodeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PolicyGroup, null, null, null, null, false);
                ViewBag.Transactiontradesinglemultiple = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionTradeSingleOrMultiple, null, null, null, null, false);
                ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                ViewBag.GenExceptionForList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                ViewBag.StExMultiTradeFreqList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.StExMultiTradeCalFinYearList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.CalendarOrFinancialYear, null, null, null, null, false);

                ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                objTradingPolicyModel.AssignedPreClearancerequiredforTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.PreclearanceRequest.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                ViewBag.ProhibitTransactionTypeList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.PreclearanceRequest.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                if (objTradingPolicyModel.GenSecurityType != null && objTradingPolicyModel.GenSecurityType != "")
                {
                    List<int> TagIds = objTradingPolicyModel.GenSecurityType.Split(',').Select(int.Parse).ToList();

                    foreach (var a in TagIds)
                    {
                        PopulateComboDTO obj = new PopulateComboDTO();
                        obj.Key = a.ToString();
                        obj.Value = "";
                        lstAssignedSecurityType.Add(obj);
                    }
                }
                if (objTradingPolicyModel.GenExceptionFor != null && objTradingPolicyModel.GenExceptionFor != "")
                {
                    List<int> TagIds1 = objTradingPolicyModel.GenExceptionFor.Split(',').Select(int.Parse).ToList();

                    foreach (var a in TagIds1)
                    {
                        PopulateComboDTO obj = new PopulateComboDTO();
                        obj.Key = a.ToString();
                        obj.Value = "";
                        lstAssignedExceptionFor.Add(obj);
                    }
                }

                objTradingPolicyModel.AssignedGenSecurityTypeList = lstAssignedSecurityType;
                objTradingPolicyModel.AssignedGenExceptionForList = lstAssignedExceptionFor;
                ViewBag.TradingPolicyId = objTradingPolicyModel.TradingPolicyId;
                ViewBag.CalledFrom = CalledFrom;
                ViewBag.OccurrenceFrequencyYearly = InsiderTrading.Common.ConstEnum.Code.Yearly;
                ViewBag.TradingPolicyEmployeeType = InsiderTrading.Common.ConstEnum.Code.TradingPolicyEmployeeType;
                ViewBag.MultipleTransactionTrade = InsiderTrading.Common.ConstEnum.Code.MultipleTransactionTrade;
                ApplicabilitySL objApplicabilitySL = new ApplicabilitySL();
                ApplicabilityDTO objApplicabilityDTO = objApplicabilitySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, InsiderTrading.Common.ConstEnum.Code.TradingPolicy, Convert.ToInt32(objTradingPolicyModel.TradingPolicyId));
                if (objApplicabilityDTO != null)
                {
                    ViewBag.HasApplicabilityDefinedFlag = 1;
                }
                else
                {
                    ViewBag.HasApplicabilityDefinedFlag = 0;
                }
                ViewBag.TradingPolicyType = objTradingPolicyModel.TradingPolicyForCodeId;
                objTradingPolicyModel.TradingPolicyDocumentFile = Common.Common.GenerateDocumentList(Common.ConstEnum.Code.TradingPolicy, Convert.ToInt32(objTradingPolicyModel.TradingPolicyId), 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.TradingPolicyFile);
                List<TransactionSecurityMapConfigDTO> lstTransactionSecurityMapConfigDTO = new List<TransactionSecurityMapConfigDTO>();

                lstTransactionSecurityMapConfigDTO = objTradingPolicySL.TransactionSecurityMapConfigList(objLoginUserDetails.CompanyDBConnectionString, null).ToList<TransactionSecurityMapConfigDTO>();

                objTradingPolicyModel.AllTransactionSecurityMappingList = lstTransactionSecurityMapConfigDTO;

                List<string> lst = new List<string>();

                foreach (var item in objTradingPolicyModel.AssignedPreClearancerequiredforTransactionList)
                {
                    lst.Add(item.Key);
                }

                ViewBag.SelectPreclearanceTransaction = lst;

                if (objTradingPolicyModel.TradingPolicyId > 0)
                {
                    List<TradingPolicyForTransactionSecurityDTO> lstTradingPolicyForTransactionSecurityDTO =
                            objTradingPolicySL.TradingPolicyForTransactionSecurityList(objLoginUserDetails.CompanyDBConnectionString, objTradingPolicyModel.TradingPolicyId, 132004).ToList<TradingPolicyForTransactionSecurityDTO>();
                    ViewBag.TradingPolicyForTransactionSecurityList = lstTradingPolicyForTransactionSecurityDTO;
                }


            }
        }
        #endregion Save Trading Policy

        #region Cancel
        /// <summary>
        /// Save Trading Policy
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <returns></returns>
        [HttpPost]
      //  [Button(ButtonName = "Cancel")]
      ///  [ActionName("Cancel")]
        public ActionResult Cancel(TradingPolicyModel objTradingPolicyModel, string CalledFrom,  int TradingPolicyId,int ParentTradingPolicy = 0)
        {
            if (CalledFrom == "History")
            {
                return RedirectToAction("History", "TradingPolicy", new { TradingPolicyId = ParentTradingPolicy, acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_VIEW, CalledFrom = CalledFrom });
            }
            else
            {
                return RedirectToAction("Index", "TradingPolicy", new { acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_VIEW });
            }
        }
        #endregion Cancel

        #region ViewApplicablity
        /// <summary>
        /// This method is used for the View Applicability and define applicability.
        /// </summary>
        /// <param name="TradingPolicyID"></param>
        /// <param name="CalledFrom"></param>
        /// <param name="TradingPolicyForCodeTypeID"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult ViewApplicablity(int TradingPolicyID, string CalledFrom, int TradingPolicyForCodeTypeID,int acid, int? ParentTradingPolicy = 0)
        {
            return RedirectToAction("Index", "Applicability", new { acid = acid, nApplicabilityType = ConstEnum.Code.TradingPolicy, nMasterID = TradingPolicyID, CalledFrom = CalledFrom, CodeTypeId = TradingPolicyForCodeTypeID, ParentTradingPolicy = ParentTradingPolicy });
        }
        #endregion ViewApplicablity

        #region Delete Trading Policy from details Page.
        /// <summary>
        /// Delete Trading Policy from details Page.
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <param name="TradingPolicyId"></param>
        /// <param name="CalledFrom"></param>
        /// <returns></returns>
      [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult DeleteTradingPolicy(int TradingPolicyId,int acid,int TradingPolicyForAction)
        {
            List<PopulateComboDTO> lstAssignedSecurityType = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstAssignedExceptionFor = new List<PopulateComboDTO>();
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            TradingPolicyModel objTradingPolicyModel = new TradingPolicyModel();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ApplicabilitySL objApplicabilitySL = new ApplicabilitySL();
            ApplicabilityDTO objApplicabilityDTO = null;
            List<TransactionSecurityMapConfigDTO> lstTransactionSecurityMapConfigDTO = new List<TransactionSecurityMapConfigDTO>();
            try
            {
                ViewBag.TradingPolicyUserAction = TradingPolicyForAction;
                bool bReturn = objTradingPolicySL.Delete(objLoginUserDetails.CompanyDBConnectionString, TradingPolicyId, objLoginUserDetails.LoggedInUserID);
                return RedirectToAction("Index", "TradingPolicy", new { acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_VIEW }).Success(InsiderTrading.Common.Common.getResource("rul_msg_15373"));
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                TradingPolicyDTO objTradingPolicyDTO = objTradingPolicySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, TradingPolicyId);
                Common.Common.CopyObjectPropertyByName(objTradingPolicyDTO, objTradingPolicyModel);

                objTradingPolicyModel.ThresholdLimtResetFlag = (objTradingPolicyModel.TradingThresholdLimtResetFlag != null && (bool)objTradingPolicyModel.TradingThresholdLimtResetFlag) ? TPYesNo.Yes : TPYesNo.No;
                ViewBag.TradingPolicyUserAction = TradingPolicyForAction;
                ViewBag.TradingPolicyCodeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PolicyGroup, null, null, null, null, false);
                ViewBag.Transactiontradesinglemultiple = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionTradeSingleOrMultiple, null, null, null, null, false);
                ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                ViewBag.GenExceptionForList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                ViewBag.StExMultiTradeFreqList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.StExMultiTradeCalFinYearList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.CalendarOrFinancialYear, null, null, null, null, false);

                ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                objTradingPolicyModel.AssignedPreClearancerequiredforTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.PreclearanceRequest.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                ViewBag.ProhibitTransactionTypeList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.PreclearanceRequest.ToString(), TradingPolicyId.ToString(), null, null, null, false);

                if (objTradingPolicyModel.GenSecurityType != null && objTradingPolicyModel.GenSecurityType != "")
                {
                    List<int> TagIds = objTradingPolicyModel.GenSecurityType.Split(',').Select(int.Parse).ToList();

                    foreach (var a in TagIds)
                    {
                        PopulateComboDTO obj = new PopulateComboDTO();
                        obj.Key = a.ToString();
                        obj.Value = "";
                        lstAssignedSecurityType.Add(obj);
                    }
                }
                if (objTradingPolicyModel.GenExceptionFor != null && objTradingPolicyModel.GenExceptionFor != "")
                {
                    List<int> TagIds1 = objTradingPolicyModel.GenExceptionFor.Split(',').Select(int.Parse).ToList();

                    foreach (var a in TagIds1)
                    {
                        PopulateComboDTO obj = new PopulateComboDTO();
                        obj.Key = a.ToString();
                        obj.Value = "";
                        lstAssignedExceptionFor.Add(obj);
                    }
                }

                objTradingPolicyModel.AssignedGenSecurityTypeList = lstAssignedSecurityType;
                objTradingPolicyModel.AssignedGenExceptionForList = lstAssignedExceptionFor;
                ViewBag.TradingPolicyId = objTradingPolicyModel.TradingPolicyId;
                ViewBag.CalledFrom = "Edit";
                ViewBag.OccurrenceFrequencyYearly = InsiderTrading.Common.ConstEnum.Code.Yearly;
                ViewBag.TradingPolicyEmployeeType = InsiderTrading.Common.ConstEnum.Code.TradingPolicyEmployeeType;
                ViewBag.MultipleTransactionTrade = InsiderTrading.Common.ConstEnum.Code.MultipleTransactionTrade;
                
                objApplicabilityDTO = objApplicabilitySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, InsiderTrading.Common.ConstEnum.Code.TradingPolicy, Convert.ToInt32(objTradingPolicyModel.TradingPolicyId));
                if (objApplicabilityDTO != null)
                {
                    ViewBag.HasApplicabilityDefinedFlag = 1;
                }
                else
                {
                    ViewBag.HasApplicabilityDefinedFlag = 0;
                }
                ViewBag.TradingPolicyType = objTradingPolicyModel.TradingPolicyForCodeId;
                objTradingPolicyModel.TradingPolicyDocumentFile = Common.Common.GenerateDocumentList(Common.ConstEnum.Code.TradingPolicy, Convert.ToInt32(objTradingPolicyModel.TradingPolicyId), 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.TradingPolicyFile);
                lstTransactionSecurityMapConfigDTO = objTradingPolicySL.TransactionSecurityMapConfigList(objLoginUserDetails.CompanyDBConnectionString, null).ToList<TransactionSecurityMapConfigDTO>();
                objTradingPolicyModel.AllTransactionSecurityMappingList = lstTransactionSecurityMapConfigDTO;
                return View("Create", objTradingPolicyModel);

            }
            finally
            {

                lstAssignedSecurityType = null;
                lstAssignedExceptionFor = null;
                objTradingPolicySL = null;
                objTradingPolicyModel = null;
                objLoginUserDetails = null;
                objApplicabilitySL = null;
                objApplicabilityDTO = null;
            }
        }
        #endregion Delete Trading Policy from details Page.

        #region Delete Trading Policy from list Page.
        /// <summary>
        /// #endregion  Delete Trading Policy from list Page.
        /// </summary>
        /// <param name="TradingPolicyId"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteFromGrid(int TradingPolicyId,int acid)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                bool bReturn = objTradingPolicySL.Delete(objLoginUserDetails.CompanyDBConnectionString, TradingPolicyId, objLoginUserDetails.LoggedInUserID);
                statusFlag = true;
                ErrorDictionary.Add("success", InsiderTrading.Common.Common.getResource("rul_msg_15373"));
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
        #endregion  Delete Trading Policy from list Page.

        #region Load Partial View Methods

        #region Load Single/Multiple Transaction Partial View
        /// <summary>
        /// Load Single/Multiple Transaction Partial View
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <returns></returns>
       [AuthorizationPrivilegeFilter]
        public ActionResult RadioButtonChangeTransaction(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                ViewBag.StExMultiTradeFreqList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.StExMultiTradeCalFinYearList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.CalendarOrFinancialYear, null, null, null, null, false);
                if (objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId == InsiderTrading.Common.ConstEnum.Code.MultipleTransactionTrade)
                {
                    return PartialView("_MultipleTransactionTrade", objTradingPolicyModel);
                }
                ViewBag.TradingPolicyUserAction = acid;
                return PartialView("_MultipleTransactionTrade", objTradingPolicyModel);
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
        }
        #endregion Load Single/Multiple Transaction Partial View

        #region Load Preclearance Requirement Partial View
        /// <summary>
        /// Load Preclearance Requirement Partial View
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult TradingPolicyForCodeType(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                if (objTradingPolicyModel.TradingPolicyForCodeId == InsiderTrading.Common.ConstEnum.Code.TradingPolicyInsiderType)// if (Value == 131001)
                {
                    ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                    objTradingPolicyModel.AssignedPreClearancerequiredforTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.PreclearanceRequest.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                    objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                    ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);

                    ViewBag.ProhibitTransactionTypeList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.PreclearanceRequest.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                    objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                    List<TransactionSecurityMapConfigDTO> lstTransactionSecurityMapConfigDTO = new List<TransactionSecurityMapConfigDTO>();
                    TradingPolicySL obj = new TradingPolicySL();


                    lstTransactionSecurityMapConfigDTO = obj.TransactionSecurityMapConfigList(objLoginUserDetails.CompanyDBConnectionString, null).ToList<TransactionSecurityMapConfigDTO>();

                    objTradingPolicyModel.AllTransactionSecurityMappingList = lstTransactionSecurityMapConfigDTO;
                    ViewBag.SelectPreclearanceTransaction = objTradingPolicyModel.SelectedPreClearancerequiredforTransaction;

                    if (objTradingPolicyModel.TradingPolicyId > 0)
                    {
                        List<TradingPolicyForTransactionSecurityDTO> lstTradingPolicyForTransactionSecurityDTO =
                                obj.TradingPolicyForTransactionSecurityList(objLoginUserDetails.CompanyDBConnectionString, objTradingPolicyModel.TradingPolicyId, 132004).ToList<TradingPolicyForTransactionSecurityDTO>();
                        ViewBag.TradingPolicyForTransactionSecurityList = lstTradingPolicyForTransactionSecurityDTO;
                    }
                    ViewBag.TradingPolicyUserAction = acid;
                    ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                    return PartialView("_PreclearanceRequirement", objTradingPolicyModel);
                }
                else
                {
                    return PartialView("_PreclearanceNotRequired");
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Load Preclearance Requirement Partial View

        #region Load Preclearance Transaction Partial View
        /// <summary> 
        /// Load Preclearance Transaction Partial View
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <returns></returns>
         [AuthorizationPrivilegeFilter]
        public ActionResult PreClearanceTransactionForTrade(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                if (!objTradingPolicyModel.PreClrTradesApprovalReqFlag)
                {
                    ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                    ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                    FillGrid(ConstEnum.GridType.TradingPolicySecuritywiseValueList, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequest.ToString(), null);
                    ViewBag.TradingPolicyUserAction = acid;
                    return PartialView("_PreclearanceTransaction", objTradingPolicyModel);
                }
                else
                {
                    return PartialView();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Load Preclearance Transaction Partial View

        #region Load Seek Declaration Partial View
        /// <summary>
        /// Load Seek Declaration Partial View
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <returns></returns>
       [AuthorizationPrivilegeFilter]
        public ActionResult PreClrSeekDeclarationForUPSIFlagURL(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                if (objTradingPolicyModel.PreClrSeekDeclarationForUPSIFlag)
                {
                    return PartialView("_SeekDeclarationUPSI", objTradingPolicyModel);
                }
                else
                {
                    return PartialView();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Load Seek Declaration Partial View

        #region Load Preclearance trade not done Partial View
        /// <summary>
        /// Load Preclearance trade not done Partial View
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <returns></returns>
       [AuthorizationPrivilegeFilter]
        public ActionResult PreClrPartialTradeNotDoneFlagURL(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                if (objTradingPolicyModel.PreClrReasonForNonTradeReqFlag)
                {
                    return PartialView("_Preclrpartialtradenotdoneflag", objTradingPolicyModel);
                }
                else
                {
                    return PartialView();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Load Preclearance trade not done Partial View

        #region Load Initial Disclosure Partial View
        /// <summary>
        /// Load Initial Disclosure Partial View
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult DiscloInitReqFlagURL(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                if (objTradingPolicyModel.DiscloInitReqFlag)
                {
                    return PartialView("_InitialDisclosure", objTradingPolicyModel);
                }
                else
                {
                    return PartialView();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Load Initial Disclosure Partial View

        #region Load Period End Disclosure Partial View
        /// <summary>
        /// Load Period End Disclosure Partial View
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult DiscloPeriodEndReqFlagURL(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                if (objTradingPolicyModel.DiscloPeriodEndReqFlag)
                {
                    ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                    return PartialView("_PeriodEndDisclosure", objTradingPolicyModel);
                }
                else
                {
                    return PartialView();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Load Period End Disclosure Partial View

        #region Load Year Type Partial View
        /// <summary>
        /// Load Year Type Partial View
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult StExMultiTradeFreqURL(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                ViewBag.StExMultiTradeCalFinYearList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.CalendarOrFinancialYear, null, null, null, null, false);
                return PartialView("_YearType", objTradingPolicyModel);
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion Load Year Type Partial View

        #region PreclearanceSecurityFlagChange
        [AuthorizationPrivilegeFilter]
        public ActionResult PreclearanceSecurityFlagChange(TradingPolicyModel objTradingPolicyModel, string SelectedOptionsCheckBox,int acid)
        {
            try
            {
                if (objTradingPolicyModel.PreClrForAllSecuritiesFlag)
                {
                    FillGrid(ConstEnum.GridType.TradingPolicySecuritywiseValueList, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequest.ToString(), "1");
                }
                else
                {
                    FillGrid(ConstEnum.GridType.TradingPolicySecuritywiseValueList, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequest.ToString(), "0");
                }
                ViewBag.TradingPolicyUserAction = acid;
                ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                return PartialView("_PreSecuritywiseLimitList", objTradingPolicyModel);

            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
        }
        #endregion PreclearanceSecurityFlagChange

        #region ContinousSecurityFlagChange
        [AuthorizationPrivilegeFilter]
        public ActionResult ContinousSecurityFlagChange(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                if (objTradingPolicyModel.TradingPolicyForCodeId == ConstEnum.Code.TradingPolicyEmployeeType)
                {
                    objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId = ConstEnum.Code.MultipleTransactionTrade;
                }
                if (objTradingPolicyModel.StExForAllSecuritiesFlag)
                {
                    FillGrid(ConstEnum.GridType.TradingPolicySecuritywiseValueList, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.DisclosureTransaction.ToString(), "1");
                }
                else
                {
                    FillGrid(ConstEnum.GridType.TradingPolicySecuritywiseValueList, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.DisclosureTransaction.ToString(), "0");
                }
                ViewBag.TradingPolicyUserAction = acid;
                return PartialView("_ContinousSecuritywiseValueList", objTradingPolicyModel);
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
        }
        #endregion ContinousSecurityFlagChange

        #region ProhibitPreclearanceValueChange
        [AuthorizationPrivilegeFilter]
        public ActionResult ProhibitPreclearanceValueChange(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                if (objTradingPolicyModel.SelectedPreClearancerequiredforTransaction != null && objTradingPolicyModel.SelectedPreClearancerequiredforTransaction.Count > 0)
                {
                    List<PopulateComboDTO> lst1 = new List<PopulateComboDTO>();
                    List<PopulateComboDTO> lst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);

                    foreach (var item in lst)
                    {
                        if (objTradingPolicyModel.SelectedPreClearancerequiredforTransaction.Contains(item.Key))
                        {
                            PopulateComboDTO obj = new PopulateComboDTO();
                            obj.Key = item.Key.ToString();
                            obj.Value = item.Value;
                            lst1.Add(obj);
                        }
                    }

                    ViewBag.ProhibitTransactionTypeList = lst1;//FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                    objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);
                }
                ViewBag.TradingPolicyUserAction = acid;
                return PartialView("_ProhibitTradingNonTradingPeriod", objTradingPolicyModel);

            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion ProhibitPreclearanceValueChange

        #region ContinuousDisclosureRequiredURL
        [AuthorizationPrivilegeFilter]
        public ActionResult ContinuousDisclosureRequiredURL(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                return PartialView("_ContinuousDisclosureRequired", objTradingPolicyModel);

            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion ContinuousDisclosureRequiredURL

        #region ContinuousDisclosureSubmissionStockExchangeURL
        [AuthorizationPrivilegeFilter]
        public ActionResult ContinuousDisclosureSubmissionStockExchangeURL(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                return PartialView("_ContinuousDisclosureSubmissionStockExchange", objTradingPolicyModel);

            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion ContinuousDisclosureSubmissionStockExchangeURL

        #region PeriodEndDisclosureSubmissionStockExchangeURL
        [AuthorizationPrivilegeFilter]
        public ActionResult PeriodEndDisclosureSubmissionStockExchangeURL(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                return PartialView("_PeriodEndDisclosureSubmissionStockExchange", objTradingPolicyModel);

            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion PeriodEndDisclosureSubmissionStockExchangeURL

        #region ContinuousLimitsURL
        [AuthorizationPrivilegeFilter]
        public ActionResult ContinuousLimitsURL(TradingPolicyModel objTradingPolicyModel,int acid)
        {
            try
            {
                if (objTradingPolicyModel.TradingPolicyForCodeId == ConstEnum.Code.TradingPolicyEmployeeType)
                {
                    objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId = ConstEnum.Code.MultipleTransactionTrade;
                }
                ViewBag.StExMultiTradeFreqList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.StExMultiTradeCalFinYearList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.CalendarOrFinancialYear, null, null, null, null, false);
                ViewBag.TradingPolicyUserAction = acid;
                return PartialView("_ContinuousLimits", objTradingPolicyModel);

            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion ContinuousLimitsURL

        #region TransactionSecuityMappingChange
        [AuthorizationPrivilegeFilter]
        public ActionResult TransactionSecuityMappingChange(TradingPolicyModel objTradingPolicyModel,int acid)
        {   
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            List<TransactionSecurityMapConfigDTO> lstTransactionSecurityMapConfigDTO = new List<TransactionSecurityMapConfigDTO>();
            TradingPolicySL obj = new TradingPolicySL();
            List<TradingPolicyForTransactionSecurityDTO> lstTradingPolicyForTransactionSecurityDTO = null;
            try
            {
                    lstTransactionSecurityMapConfigDTO = obj.TransactionSecurityMapConfigList(objLoginUserDetails.CompanyDBConnectionString, null).ToList<TransactionSecurityMapConfigDTO>();
                    objTradingPolicyModel.AllTransactionSecurityMappingList = lstTransactionSecurityMapConfigDTO;
                    ViewBag.SelectPreclearanceTransaction = objTradingPolicyModel.SelectedPreClearancerequiredforTransaction;
                    if (objTradingPolicyModel.TradingPolicyId > 0)
                    {
                        lstTradingPolicyForTransactionSecurityDTO =
                                obj.TradingPolicyForTransactionSecurityList(objLoginUserDetails.CompanyDBConnectionString, objTradingPolicyModel.TradingPolicyId, 132004).ToList<TradingPolicyForTransactionSecurityDTO>();
                        ViewBag.TradingPolicyForTransactionSecurityList = lstTradingPolicyForTransactionSecurityDTO;
                    }
                    ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                    objTradingPolicyModel.AssignedPreClearancerequiredforTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.PreclearanceRequest.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);
                    objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);
                    ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                    ViewBag.ProhibitTransactionTypeList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.PreclearanceRequest.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);
                    objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimits, Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);
                    ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                    return PartialView("PreclearanceTransactionSecurityMapping", objTradingPolicyModel);

            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                objLoginUserDetails = null;
                lstTransactionSecurityMapConfigDTO = null;
                obj = null;
                lstTradingPolicyForTransactionSecurityDTO = null;
            }
        }
        #endregion TransactionSecuityMappingChange

        #region ContraTradeSecuirtyMapping
        public ActionResult ContraTradeSecuirtyMapping(TradingPolicyModel objTradingPolicyModel, int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                //  objTradingPolicyModel.AllSecurityTypeList = FillComboValues(Common.ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                if (objTradingPolicyModel.TradingPolicyForCodeId == ConstEnum.Code.TradingPolicyInsiderType)
                {
                    objTradingPolicyModel.ContraTradeSelectedSecurityTypeList = FillComboValues(ConstEnum.ComboType.TradingPolicyContraTradeSelectedSecurity, InsiderTrading.Common.ConstEnum.Code.ContraTradeSelectedSecurity.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);
                }
                else
                {
                    List<PopulateComboDTO> lstPopulateComboDTO = FillComboValues(ConstEnum.ComboType.TradingPolicyContraTradeSelectedSecurity, InsiderTrading.Common.ConstEnum.Code.ContraTradeSelectedSecurity.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                    foreach (var item in lstPopulateComboDTO)
                    {
                        if (objTradingPolicyModel.TradingPolicyId <= 0)
                        {
                            item.Value = item.Value + item.Key;
                        }
                    }
                    objTradingPolicyModel.ContraTradeSelectedSecurityTypeList = lstPopulateComboDTO;
                }
                return PartialView("_ContraTradeSecurityMapping", objTradingPolicyModel);

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
        #endregion TransactionSecuityMappingChange

        #endregion Load Partial View Methods

        public ActionResult ViewOverlappedUser(int TradingPolicyId,string ShowFrom)//TradingPolicyModel objTradingPolicyModel,string PreclearanceSecuritywisedata, string ContinousSecuritywisedata)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
          
            try
            {
               
                ViewBag.TradingPolicyIDHideen = TradingPolicyId.ToString();
                ViewBag.ShowFrom = ShowFrom;
                FillGrid(ConstEnum.GridType.OverlappingTradingPolicyList, TradingPolicyId.ToString(), null, null);
                return PartialView("~/Views/TradingPolicy/ViewOverlapedUserList.cshtml");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return RedirectToAction("Index");
            }

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

        #region GetModelStateErrorsAsString
        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }
        #endregion GetModelStateErrorsAsString

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