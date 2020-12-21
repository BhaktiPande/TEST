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
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
     [RolePrivilegeFilter]
    public class TradingPolicy_OSController : Controller
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
                FillGrid(ConstEnum.GridType.TradingPolicyOtherSecurityList, null, null, null);
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
                FillGrid(InsiderTrading.Common.ConstEnum.GridType.TradingPolicyHistoryList_OS, TradingPolicyId.ToString(), null, null);
                return View("TradingPolicyHistoryList_OS");
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
        public ActionResult Create(int TradingPolicyId, string CalledFrom, int? ParentTradingPolicy, int acid)
        {
            #region Variable & Object Declaration
            TradingPolicyModel_OS objTradingPolicyModelOS = new TradingPolicyModel_OS();
            TradingPolicySL_OS objTradingPolicySLOS = new TradingPolicySL_OS();
            LoginUserDetails objLoginUserDetailsOS = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicyDTO_OS objTradingPolicyDTOOS = new TradingPolicyDTO_OS();
            List<PopulateComboDTO> lstAssignedContraTradeSecurityType = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstAssignedExceptionFor = new List<PopulateComboDTO>();
            List<TransactionSecurityMapConfigDTO_OS> lstTransactionSecurityMapConfigDTO = new List<TransactionSecurityMapConfigDTO_OS>();
            List<string> lst = new List<string>();
            ApplicabilitySL_OS objApplicabilitySL = new ApplicabilitySL_OS();
            List<TradingPolicyForTransactionSecurityDTO_OS> lstTradingPolicyForTransactionSecurityDTO = null;
            ApplicabilityDTO_OS objApplicabilityDTO = null;
            CompaniesSL objCompaniesSL = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            #endregion Variable & Object Declaration

            #region try
            try
            {
                #region Load Dropdown values
                ViewBag.TradingPolicyCodeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PolicyGroup, null, null, null, null, false);
                ViewBag.Transactiontradesinglemultiple = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionTradeSingleOrMultiple, null, null, null, null, false);
                ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                var GenExceptionForList_OS = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                GenExceptionForList_OS.RemoveRange(1, 3);
                ViewBag.GenExceptionForList = GenExceptionForList_OS;
                ViewBag.StExMultiTradeFreqList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.StExMultiTradeCalFinYearList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.CalendarOrFinancialYear, null, null, null, null, false);
                var TransactionTypeList_OS = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                TransactionTypeList_OS.RemoveRange(1, 3);
                ViewBag.TransactionTypeList = TransactionTypeList_OS;
                objTradingPolicyModelOS.AssignedPreClearancerequiredforTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimitsOS, Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(),TradingPolicyId.ToString(), null, null, null, false);
                ViewBag.ProhibitTransactionTypeList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), null, null, null, false);
                objTradingPolicyModelOS.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimitsOS, Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), TradingPolicyId.ToString(), null, null, null, false);
                objTradingPolicyModelOS.AllSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                objTradingPolicyModelOS.ContraTradeSelectedSecurityTypeList = FillComboValues(ConstEnum.ComboType.TradingPolicyContraTradeSelectedSecurity, InsiderTrading.Common.ConstEnum.Code.ContraTradeSelectedSecurity.ToString(), TradingPolicyId.ToString(), null, null, null, false);

                #endregion Load Dropdown values

                objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetailsOS.CompanyDBConnectionString, 0, 1);

                if (TradingPolicyId > 0)
                {
                    objTradingPolicyDTOOS = objTradingPolicySLOS.GetDetails(objLoginUserDetailsOS.CompanyDBConnectionString, TradingPolicyId);
                    if (objTradingPolicyDTOOS.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures != null)
                    {
                        ViewBag.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures = objTradingPolicyDTOOS.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures;
                    }
                    ViewBag.SeekDeclarationUPSIFlag = objTradingPolicyDTOOS.SeekDeclarationFromEmpRegPossessionOfUPSIFlag;

                    Common.Common.CopyObjectPropertyByName(objTradingPolicyDTOOS, objTradingPolicyModelOS);
                    objTradingPolicyModelOS.ThresholdLimtResetFlag = (objTradingPolicyModelOS.TradingThresholdLimtResetFlag != null && (bool)objTradingPolicyModelOS.TradingThresholdLimtResetFlag) ? TPYesNo_OS.Yes : TPYesNo_OS.No;

                    /*
                     *get Applicability details.
                     */
                    objApplicabilityDTO = objApplicabilitySL.GetDetails(objLoginUserDetailsOS.CompanyDBConnectionString, InsiderTrading.Common.ConstEnum.Code.TradingPolicy_OS, TradingPolicyId);
                    if (objApplicabilityDTO != null)
                    {
                        ViewBag.HasApplicabilityDefinedFlag = 1;
                    }
                    else
                    {
                        ViewBag.HasApplicabilityDefinedFlag = 0;
                    }
                    ViewBag.TradingPolicyType = objTradingPolicyModelOS.TradingPolicyForCodeId;
                    int CountUserAndOverlapTradingPolicy = 0;
                    objTradingPolicySLOS.GetUserwiseOverlapTradingPolicyCount(objLoginUserDetailsOS.CompanyDBConnectionString, TradingPolicyId, out CountUserAndOverlapTradingPolicy);
                    ViewBag.CountUserAndOverlapTradingPolicy = CountUserAndOverlapTradingPolicy;
                }
                else
                {
                    objTradingPolicyModelOS.PreClrProhibitNonTradePeriodFlag = true;
                    objTradingPolicyModelOS.PreClrReasonForNonTradeReqFlag = true;
                    objTradingPolicyModelOS.PreClrSeekDeclarationForUPSIFlag = true;
                    objTradingPolicyModelOS.PreClrReasonForNonTradeReqFlag = true;
                    objTradingPolicyModelOS.GenTradingPlanTransFlag = true;
                    objTradingPolicyModelOS.DiscloInitReqFlag = true;
                    objTradingPolicyModelOS.DiscloPeriodEndReqFlag = true;
                    objTradingPolicyModelOS.StExSubmitDiscloToCOByInsdrFlag = true;
                    objTradingPolicyModelOS.IsPreClearanceRequired = true;
                    objTradingPolicyModelOS.PreClrApprovalReasonReqFlag = true;
                }
                objTradingPolicyModelOS.AssignedGenExceptionForList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, TradingPolicyId.ToString(), Common.ConstEnum.Code.TradingPolicyExceptionforTransactionMode.ToString(),  null, null, null, false);//lstAssignedExceptionFor;
                ViewBag.CalledFrom = CalledFrom;
                ViewBag.ParentTradingPolicy = ParentTradingPolicy;
                ViewBag.OccurrenceFrequencyYearly = InsiderTrading.Common.ConstEnum.Code.Yearly;
                ViewBag.TradingPolicyEmployeeType = InsiderTrading.Common.ConstEnum.Code.TradingPolicyEmployeeType;
                ViewBag.MultipleTransactionTrade = InsiderTrading.Common.ConstEnum.Code.MultipleTransactionTrade;
                objTradingPolicyModelOS.TradingPolicyDocumentFile = Common.Common.GenerateDocumentList(Common.ConstEnum.Code.TradingPolicy_OS, TradingPolicyId, 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.TradingPolicyFile);
                lstTransactionSecurityMapConfigDTO = objTradingPolicySLOS.TransactionSecurityMapConfigList(objLoginUserDetailsOS.CompanyDBConnectionString, null).ToList<TransactionSecurityMapConfigDTO_OS>();
                objTradingPolicyModelOS.AllTransactionSecurityMappingList = lstTransactionSecurityMapConfigDTO;

                foreach (var item in objTradingPolicyModelOS.AssignedPreClearancerequiredforTransactionList)
                {
                    lst.Add(item.Key);
                }
                ViewBag.SelectPreclearanceTransaction = lst;
                if (TradingPolicyId > 0)
                {
                    lstTradingPolicyForTransactionSecurityDTO =
                            objTradingPolicySLOS.TradingPolicyForTransactionSecurityList(objLoginUserDetailsOS.CompanyDBConnectionString, TradingPolicyId, 132015).ToList<TradingPolicyForTransactionSecurityDTO_OS>();
                    ViewBag.TradingPolicyForTransactionSecurityList = lstTradingPolicyForTransactionSecurityDTO;
                }
                if (acid == InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_OTHER_SECURITY_VIEW)
                {
                    ViewBag.TradingPolicyUserAction = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_OTHER_SECURITY_VIEW;
                }
                else if (acid == InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_OTHER_SECURITY_CREATE)
                {
                    ViewBag.TradingPolicyUserAction = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_OTHER_SECURITY_CREATE;
                }
                else if (acid == InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_OTHER_SECURITY_EDIT)
                {
                    ViewBag.TradingPolicyUserAction = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_OTHER_SECURITY_EDIT;
                }

                ViewBag.ContraTradeOption = objImplementedCompanyDTO.ContraTradeOption;
                if (objImplementedCompanyDTO.ContraTradeOption == null)
                {
                    ModelState.AddModelError("Error", InsiderTrading.Common.Common.getResource("rul_msg_55273"));
                    if (objLoginUserDetailsOS.BackURL != null && objLoginUserDetailsOS.BackURL != "")
                    {
                        ViewBag.BackButton = true;
                        ViewBag.BackURL = objLoginUserDetailsOS.BackURL;
                        objLoginUserDetailsOS.BackURL = "";
                        Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetailsOS);
                    }
                    else
                    {
                        ViewBag.BackButton = false;
                    }
                    FillGrid(ConstEnum.GridType.TradingPolicyOtherSecurityList, null, null, null);
                    return View("Index");
                }
                ViewBag.AutoSubmitTransaction = objImplementedCompanyDTO.AutoSubmitTransaction;
                return View("Create", objTradingPolicyModelOS);
            }
            #endregion try

            #region catch
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Create", objTradingPolicyModelOS);
            }
            #endregion catch

            #region finally
            finally
            {
                objTradingPolicyModelOS = null;
                objTradingPolicySLOS = null;
                objLoginUserDetailsOS = null;
                objTradingPolicyDTOOS = null;
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
        public JsonResult BasicInfo(TradingPolicyModel_OS objTradingPolicyModel, string CalledFrom, string PreclearanceSecuritywisedata,
            string ContinousSecuritywisedata, string SelectedOptionsCheckBox, int acid, string SelectedSecurityTypeOptions)
        {
            List<PopulateComboDTO> lstAssignedSecurityType = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstAssignedExceptionFor = new List<PopulateComboDTO>();
            TradingPolicySL_OS objTradingPolicySLOS = new TradingPolicySL_OS();
            TradingPolicyDTO_OS objTradingPolicyDTOOS = new TradingPolicyDTO_OS();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            DataTable tblPreClearanceSecuritywise = new DataTable("PreClearanceSecuritywise");
            CompaniesSL objCompaniesSL = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            try
            {
                objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);

                #region Validation Part
                List<PreSecuritiesValuesModel_OS> PreClearanceSecuritywiseList = new List<PreSecuritiesValuesModel_OS>();
                List<PreSecuritiesValuesModel_OS> ContinousSecuritywiseList = new List<PreSecuritiesValuesModel_OS>();

                if (PreclearanceSecuritywisedata != null)
                {
                    PreClearanceSecuritywiseList = JsonConvert.DeserializeObject<List<PreSecuritiesValuesModel_OS>>(PreclearanceSecuritywisedata);
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

                            tblPreClearanceSecuritywise.Rows.Add(row);
                        }
                    }

                }
                if (ContinousSecuritywisedata != null)
                {
                    ContinousSecuritywiseList = JsonConvert.DeserializeObject<List<PreSecuritiesValuesModel_OS>>(ContinousSecuritywisedata);
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


                List<TransactionSecuritymap_OS> lstTransactionSecuritymap = new List<TransactionSecuritymap_OS>();
                if (SelectedOptionsCheckBox != null)
                {
                    lstTransactionSecuritymap = JsonConvert.DeserializeObject<List<TransactionSecuritymap_OS>>(SelectedOptionsCheckBox);
                }
                else
                {
                    lstTransactionSecuritymap = null;
                }

                DataTable tblPreclearanceTransactionSecurityMapping = new DataTable("tblPreclearanceTransactionSecurityMapping");
                tblPreclearanceTransactionSecurityMapping.Columns.Add(new DataColumn("MapToTypeCodeID", typeof(int)));
                tblPreclearanceTransactionSecurityMapping.Columns.Add(new DataColumn("TransactionModeCodeId", typeof(int)));
                tblPreclearanceTransactionSecurityMapping.Columns.Add(new DataColumn("SecurityTypeCodeId", typeof(int)));

                if (objTradingPolicyModel.SelectedPreClearancerequiredforTransaction != null)
                {
                    foreach (var TransItem in objTradingPolicyModel.SelectedPreClearancerequiredforTransaction)
                    {
                        if (TransItem.ToString() == "143001")
                        {
                            if (lstTransactionSecuritymap.Count(elem => elem.TransactionType.ToString() == "143001") <= 0)
                            {
                                ModelState.AddModelError("SelectedPreClearancerequiredforTransaction", InsiderTrading.Common.Common.getResource("rul_msg_55381"));
                            }
                        }
                        if (TransItem.ToString() == "143002")
                        {
                            if (lstTransactionSecuritymap.Count(elem => elem.TransactionType.ToString() == "143002") <= 0)
                            {
                                ModelState.AddModelError("SelectedPreClearancerequiredforTransaction", InsiderTrading.Common.Common.getResource("rul_msg_55382"));
                            }
                        }
                    }
                }
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
                        row["MapToTypeCodeID"] = 132015;
                        tblPreclearanceTransactionSecurityMapping.Rows.Add(row);

                    }
                }

                List<TransactionSecuritymap_OS> lstContraTradeSecuritymap = new List<TransactionSecuritymap_OS>();
                if (SelectedSecurityTypeOptions != null)
                {
                    lstContraTradeSecuritymap = JsonConvert.DeserializeObject<List<TransactionSecuritymap_OS>>(SelectedSecurityTypeOptions);
                }
                else
                {
                    lstContraTradeSecuritymap = null;
                }
                string sContraTradeSecurityTypeCommaSeparatedList = string.Join(",", lstContraTradeSecuritymap.Select(x => x.SecurityType));

                //Add new validation 
                if (objTradingPolicyModel.TradingPolicyId == null || objTradingPolicyModel.TradingPolicyId == 0)
                {
                    objTradingPolicyModel.CurrentHistoryCodeId = ConstEnum.Code.CurrentRecordCodeID; //134001 
                    objTradingPolicyModel.TradingPolicyParentId = null;
                }

               
                if (objTradingPolicyModel.TradingPolicyForCodeId == null || objTradingPolicyModel.TradingPolicyForCodeId <= 0)
                {
                    ModelState.AddModelError("TradingPolicyForCodeId", InsiderTrading.Common.Common.getResource("rul_msg_55308"));//"Mandatory : Trading Policy Type");
                }
                if (objTradingPolicyModel.SearchType == 528002 &&
                    (objTradingPolicyModel.SearchLimit == null || objTradingPolicyModel.SearchLimit <= 0))
                {
                    ModelState.AddModelError("SearchLimit", InsiderTrading.Common.Common.getResource("rul_msg_55369"));//"Mandatory : Trading Policy Type");
                }
                if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType && Convert.ToString(objTradingPolicyModel.PreClrTradesApprovalReqFlag) == null)
                    {
                        ModelState.AddModelError("PreClrTradesApprovalReqFlag", InsiderTrading.Common.Common.getResource("rul_msg_55106"));
                    }

                    if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType &&
                        objTradingPolicyModel.PreClrTradesApprovalReqFlag == false && Convert.ToString(objTradingPolicyModel.PreClrForAllSecuritiesFlag) == null)
                    {
                        ModelState.AddModelError("PreClrForAllSecuritiesFlag", InsiderTrading.Common.Common.getResource("rul_msg_55307"));// "Mandatory :- Approval Required for Single Transaction select security flag.");
                    }
                    if(objTradingPolicyModel.IsPreClearanceRequired == true && 
                    (objTradingPolicyModel.SelectedPreClearancerequiredforTransaction==null ||Convert.ToString(objTradingPolicyModel.SelectedPreClearancerequiredforTransaction) == ""))
                    {
                       ModelState.AddModelError("SelectedPreClearancerequiredforTransaction", InsiderTrading.Common.Common.getResource("rul_msg_55380"));
                    }


                if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType &&
                       objTradingPolicyModel.SelectedPreClearancerequiredforTransaction != null &&
                   (objTradingPolicyModel.IsPreClearanceRequired == true) &&
                   (objTradingPolicyModel.PreClrCOApprovalLimit == null))
                    {
                        ModelState.AddModelError("PreClrCOApprovalLimit", InsiderTrading.Common.Common.getResource("rul_msg_55109"));//Mandatory : Preclearance approval to be given within X days by CO.
                    }
                    if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType &&
                     objTradingPolicyModel.PreClrApprovalValidityLimit == null &&
                     (objTradingPolicyModel.IsPreClearanceRequired == true) &&
                     (objTradingPolicyModel.IsPreClearanceRequired == true))
                    {
                        ModelState.AddModelError("PreClrApprovalValidityLimit", InsiderTrading.Common.Common.getResource("rul_msg_55110"));//Mandatory : Preclearance approval validity X days (after approval is given excluding approval day).
                    }
                    if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType &&
                        objTradingPolicyModel.PreClrSeekDeclarationForUPSIFlag == true && (objTradingPolicyModel.PreClrUPSIDeclaration == null || objTradingPolicyModel.PreClrUPSIDeclaration == "")
                        && (objTradingPolicyModel.IsPreClearanceRequired == true))
                    {
                        ModelState.AddModelError("PreClrUPSIDeclaration", InsiderTrading.Common.Common.getResource("rul_msg_55111"));//Mandatory : Declaration for possession of UPSI to be sought from insider during preclearance.
                    }
                    if (objTradingPolicyModel.PreClrSeekDeclarationForUPSIFlag == false)
                    {
                        objTradingPolicyModel.PreClrUPSIDeclaration = null;
                    }

                if (objTradingPolicyModel.TradingPolicyForCodeId == Common.ConstEnum.Code.TradingPolicyInsiderType &&
                    (objTradingPolicyModel.IsPreClearanceRequired == true)
                          && !objTradingPolicyModel.PreClrTradesApprovalReqFlag && objTradingPolicyModel.PreClrSingMultiPreClrFlagCodeId == null)
                    {
                    ModelState.AddModelError("PreClrSingMultiPreClrFlagCodeId", InsiderTrading.Common.Common.getResource("rul_msg_55368")); //Mandatory: Select value for Single Pre-Clearance Request & Multiple Pre-Clearance Request.
                    }

                if ((objTradingPolicyModel.IsPreClearanceRequired == true) && (objTradingPolicyModel.PreclearanceWithoutPeriodEndDisclosure <= 0 || objTradingPolicyModel.PreclearanceWithoutPeriodEndDisclosure==null))
                    {
                    ModelState.AddModelError("PreclearanceWithoutPeriodEndDisclosure", InsiderTrading.Common.Common.getResource("rul_msg_55367"));//Mandatory : Preclearance Without Period End Disclosure.
                                        }



                    //  Validation For Initial Disclosure.

                    if (Convert.ToString(objTradingPolicyModel.DiscloInitReqFlag) == null)
                    {
                        ModelState.AddModelError("DiscloInitReqFlag", InsiderTrading.Common.Common.getResource("rul_msg_55113"));//Mandatory : Initial disclosure to be submitted by Insider/Employee to Company.
                    }
                    if (objTradingPolicyModel.DiscloInitReqFlag == true &&
                        (objTradingPolicyModel.DiscloInitLimit == null || objTradingPolicyModel.DiscloInitLimit <= 0))
                    {
                        ModelState.AddModelError("DiscloInitLimit", InsiderTrading.Common.Common.getResource("rul_msg_55114"));//Mandatory : Initial disclosure within X days of joining/being categorized as insider.
                    }
                    if (objTradingPolicyModel.DiscloInitReqFlag == true && objTradingPolicyModel.DiscloInitDateLimit == null)
                    {
                        ModelState.AddModelError("DiscloInitDateLimit", InsiderTrading.Common.Common.getResource("rul_msg_55115"));//Mandatory : Initial disclosure before X date of application go live.
                    }
                    if (objTradingPolicyModel.DiscloInitReqFlag == true && Convert.ToString(objTradingPolicyModel.DiscloInitSubmitToStExByCOFlag) == null)
                    {
                        ModelState.AddModelError("DiscloInitSubmitToStExByCOFlag", InsiderTrading.Common.Common.getResource("rul_msg_55116"));//Mandatory : Initial disclosure to be submitted by CO to stock exchange.
                    }


                    // Set some value to null in some cases

                    if (objTradingPolicyModel.DiscloInitReqFlag == false)
                    {
                        objTradingPolicyModel.DiscloInitLimit = null;
                        objTradingPolicyModel.DiscloInitDateLimit = null;
                    }


                    if (objTradingPolicyModel.IsPreClearanceRequired == false)
                    {
                        objTradingPolicyModel.PreClrSingleTransTradeNoShares = null;
                        objTradingPolicyModel.PreClrSingleTransTradePercPaidSubscribedCap = null;
                        objTradingPolicyModel.PreClrCOApprovalLimit = null;
                        objTradingPolicyModel.PreClrApprovalValidityLimit = null;
                        objTradingPolicyModel.PreClrTradeDiscloLimit = null;
                        objTradingPolicyModel.PreClrTradeDiscloShareholdLimit = null;
                        objTradingPolicyModel.PreClrMultipleAboveInCodeId = null;
                        objTradingPolicyModel.PreClrCOApprovalLimit = null;
                        objTradingPolicyModel.PreClrApprovalValidityLimit = null;

                    }

                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == false)
                    {
                        objTradingPolicyModel.PreClrTradeDiscloLimit = null;
                        objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId = null;
                        objTradingPolicyModel.PreClrTradeDiscloLimit = null;
                        objTradingPolicyModel.StExTradeDiscloSubmitLimit = null;
                    }

                    if (objTradingPolicyModel.StExSubmitTradeDiscloAllTradeFlag == true)
                    {
                        objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId = null;
                    }
                    if (objTradingPolicyModel.StExSubmitDiscloToStExByCOFlag == false)
                    {
                        objTradingPolicyModel.StExTradeDiscloSubmitLimit = null;
                    }
                    if (objTradingPolicyModel.DiscloPeriodEndReqFlag == false)
                    {
                        objTradingPolicyModel.DiscloPeriodEndFreq = null;
                        objTradingPolicyModel.DiscloPeriodEndToCOByInsdrLimit = null;
                        objTradingPolicyModel.DiscloPeriodEndSubmitToStExByCOLimit = null;
                    }
                    if (objTradingPolicyModel.DiscloPeriodEndSubmitToStExByCOFlag == false)
                    {
                        objTradingPolicyModel.DiscloPeriodEndSubmitToStExByCOLimit = null;
                    }
                    if (objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId == 136001)
                    {
                        objTradingPolicyModel.StExMultiTradeFreq = null;
                        objTradingPolicyModel.StExMultiTradeCalFinYear = null;
                    }

                    //Continuous Disclosure Validation

                    if (Convert.ToString(objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag) == null)
                    {
                        ModelState.AddModelError("StExSubmitDiscloToCOByInsdrFlag", InsiderTrading.Common.Common.getResource("rul_msg_55297"));//"Mandatory : Trade (Continous) Disclosure to be submitted by Insider/Employee to Company");
                    }
                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && (objTradingPolicyModel.StExTradePerformDtlsSubmitToCOByInsdrLimit == null || objTradingPolicyModel.StExTradePerformDtlsSubmitToCOByInsdrLimit <= 0))
                    {
                        ModelState.AddModelError("StExTradePerformDtlsSubmitToCOByInsdrLimit", InsiderTrading.Common.Common.getResource("rul_msg_55298"));//"Mandatory : Trading Details to be submitted by Insider/Employee to CO within");
                    }
                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && Convert.ToString(objTradingPolicyModel.StExSubmitTradeDiscloAllTradeFlag) == null)
                    {
                        ModelState.AddModelError("StExSubmitTradeDiscloAllTradeFlag", InsiderTrading.Common.Common.getResource("rul_msg_55118"));//Mandatory : Trade (continuous) disclosure to be submitted by Insider to CO for all trades.
                    }
                    if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && objTradingPolicyModel.StExSubmitTradeDiscloAllTradeFlag == false && objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId == null || objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId <= 0)
                    {
                   // ModelState.AddModelError("StExSingMultiTransTradeFlagCodeId", InsiderTrading.Common.Common.getResource("rul_msg_55119"));//Mandatory : Any one of - Single / Multiple transaction trade above.

                        if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && objTradingPolicyModel.StExSubmitTradeDiscloAllTradeFlag == false && objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId == InsiderTrading.Common.ConstEnum.Code.MultipleTransactionTrade &&
                       objTradingPolicyModel.StExMultiTradeFreq != null && objTradingPolicyModel.StExMultiTradeFreq == InsiderTrading.Common.ConstEnum.Code.Yearly &&
                        (objTradingPolicyModel.StExMultiTradeCalFinYear == null || objTradingPolicyModel.StExMultiTradeCalFinYear <= 0))
                        {
                            ModelState.AddModelError("StExTransTradeShareValue", InsiderTrading.Common.Common.getResource("rul_msg_55122"));//Mandatory : Calendar/Financial year type.
                        }
                        if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && Convert.ToString(objTradingPolicyModel.StExSubmitDiscloToStExByCOFlag) == null)
                        {
                            ModelState.AddModelError("StExSubmitDiscloToStExByCOFlag", InsiderTrading.Common.Common.getResource("rul_msg_55123"));//Mandatory : Trade (continuous) disclosure to be submitted to stock exchange by CO.
                        }
                        if (objTradingPolicyModel.StExSubmitDiscloToCOByInsdrFlag == true && objTradingPolicyModel.StExSubmitDiscloToStExByCOFlag == true
                            && objTradingPolicyModel.StExTradeDiscloSubmitLimit == null || objTradingPolicyModel.StExTradeDiscloSubmitLimit <= 0)
                        {
                            ModelState.AddModelError("StExTradeDiscloSubmitLimit", InsiderTrading.Common.Common.getResource("rul_msg_55124"));//Mandatory : Trade (continuous) disclosure submission to stock exchange by CO within X days of submission by insider/employee.
                        }
                }                                                                                                                                             // Period End Disclosure Validation

                    if (Convert.ToString(objTradingPolicyModel.DiscloPeriodEndReqFlag) == null)
                    {
                        ModelState.AddModelError("DiscloPeriodEndReqFlag", InsiderTrading.Common.Common.getResource("rul_msg_55125"));
                    }
                    if (objTradingPolicyModel.DiscloPeriodEndReqFlag == true && (objTradingPolicyModel.DiscloPeriodEndFreq == null || objTradingPolicyModel.DiscloPeriodEndFreq <= 0))
                    {
                        ModelState.AddModelError("DiscloPeriodEndFreq", InsiderTrading.Common.Common.getResource("rul_msg_55126"));
                    }
                    if (objTradingPolicyModel.DiscloPeriodEndReqFlag == true && (objTradingPolicyModel.DiscloPeriodEndToCOByInsdrLimit == null || objTradingPolicyModel.DiscloPeriodEndToCOByInsdrLimit <= 0))
                    {
                        ModelState.AddModelError("DiscloPeriodEndToCOByInsdrLimit", InsiderTrading.Common.Common.getResource("rul_msg_55127"));
                    }
                    if (objTradingPolicyModel.DiscloPeriodEndReqFlag == true && Convert.ToString(objTradingPolicyModel.DiscloPeriodEndSubmitToStExByCOFlag) == null)
                    {
                        ModelState.AddModelError("DiscloPeriodEndSubmitToStExByCOFlag", InsiderTrading.Common.Common.getResource("rul_msg_55128"));
                    }
                    if (objTradingPolicyModel.DiscloPeriodEndReqFlag == true && objTradingPolicyModel.DiscloPeriodEndSubmitToStExByCOFlag == true
                        && (objTradingPolicyModel.DiscloPeriodEndSubmitToStExByCOLimit == null || objTradingPolicyModel.DiscloPeriodEndSubmitToStExByCOLimit <= 0))
                    {
                        ModelState.AddModelError("DiscloPeriodEndSubmitToStExByCOLimit", InsiderTrading.Common.Common.getResource("rul_msg_55129"));
                    }
                    //General Validation

                    if (objTradingPolicyModel.GenContraTradeNotAllowedLimit == null || objTradingPolicyModel.GenContraTradeNotAllowedLimit <= 0)
                    {
                        ModelState.AddModelError("GenContraTradeNotAllowedLimit", InsiderTrading.Common.Common.getResource("rul_msg_55131"));
                    }

                    if (Convert.ToString(objTradingPolicyModel.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate) == null)
                    {
                        ModelState.AddModelError("GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate", InsiderTrading.Common.Common.getResource("rul_msg_55300"));
                    }

                if (objTradingPolicyModel.SeekDeclarationFromEmpRegPossessionOfUPSIFlag == true &&
                (objTradingPolicyModel.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures == null ||
                objTradingPolicyModel.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures == ""))
                {
                    ModelState.AddModelError("DeclarationFromInsiderAtTheTimeOfContinuousDisclosures", InsiderTrading.Common.Common.getResource("rul_msg_55371"));//Mandatory : Declaration for possession of UPSI to be sought from insider during continuous
                }

                if (objTradingPolicyModel.TradingPolicyStatusCodeId == null)
                {
                    objTradingPolicyModel.TradingPolicyStatusCodeId = InsiderTrading.Common.ConstEnum.Code.TradingPolicyStatusIncomplete; //141001;

                    if (objTradingPolicyModel.ApplicableFromDate != null && objTradingPolicyModel.ApplicableToDate != null)
                    {
                        DateTime dtFromDate = (DateTime)objTradingPolicyModel.ApplicableFromDate;
                        DateTime dtToDate = (DateTime)objTradingPolicyModel.ApplicableToDate;
                        DateTime dtCurrentDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString, false, "usr_com"); //(DateTime)objTradingPolicyModel.ApplicableToDate;
                        TimeSpan ts = dtFromDate - dtCurrentDate;
                        TimeSpan ts1 = dtToDate - dtCurrentDate;
                        TimeSpan ts2 = dtToDate - dtFromDate;
                        int? a = ts.Days;
                        int? a10 = ts1.Days;
                        int? a11 = ts2.Days;
                        if (a <= 0)
                        {
                            ModelState.AddModelError("ApplicableFromDate", InsiderTrading.Common.Common.getResource("rul_msg_55370"));//Applicable from date should be greater than todays date.
                        }
                        else if (a10 <= 0)
                        {
                            ModelState.AddModelError("ApplicableToDate", InsiderTrading.Common.Common.getResource("rul_msg_55212"));//To date should be grater than current date
                        }
                        else if (a11 <= 0)
                        {
                            ModelState.AddModelError("ApplicableToFromDate", InsiderTrading.Common.Common.getResource("rul_msg_55102"));//Applicable to date should be greater than from date.
                        }

                    }

                }
                else if (objTradingPolicyModel.TradingPolicyStatusCodeId == InsiderTrading.Common.ConstEnum.Code.TradingPolicyStatusActive)
                {
                    if (objTradingPolicyModel.ApplicableFromDate != null && objTradingPolicyModel.ApplicableToDate != null)
                    {
                        DateTime dtFromDate = (DateTime)objTradingPolicyModel.ApplicableFromDate;
                        DateTime dtToDate = (DateTime)objTradingPolicyModel.ApplicableToDate;
                        DateTime dtCurrentDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString, false, "usr_com"); //(DateTime)objTradingPolicyModel.ApplicableToDate;
                        TimeSpan ts=  dtFromDate- dtCurrentDate;
                        TimeSpan ts1 =  dtToDate - dtCurrentDate ;
                        TimeSpan ts2 = dtToDate - dtFromDate;
                        int? a = ts.Days;
                        int? a10 = ts1.Days;
                        int? a11 = ts2.Days;                        
                        if (a <= 0)
                        {
                            ModelState.AddModelError("ApplicableFromDate", InsiderTrading.Common.Common.getResource("rul_msg_55370"));//Applicable from date should be greater than todays date.
                        }
                        else if (a10 <= 0)
                        {
                            ModelState.AddModelError("ApplicableToDate", InsiderTrading.Common.Common.getResource("rul_msg_55212"));//To date should be grater than current date
                        }                       
                        else if (a11 <= 0)
                        {
                            ModelState.AddModelError("ApplicableToFromDate", InsiderTrading.Common.Common.getResource("rul_msg_55102"));//Applicable to date should be greater than from date.
                        }

                    }

                    if (objTradingPolicyModel.PreClrReasonForNonTradeReqFlag == false)
                    {
                        objTradingPolicyModel.PreClrCompleteTradeNotDoneFlag = false;
                        objTradingPolicyModel.PreClrPartialTradeNotDoneFlag = false;
                    }

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
                                            sErrorMessage = InsiderTrading.Common.Common.getResource("rul_msg_55292") + obj.Value;//Mandatory : Enter at least one entry for Preclearance Required security type :
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
                                        sErrorMessage = InsiderTrading.Common.Common.getResource("rul_msg_55292") + obj.Value;//Mandatory : Enter at least one entry for Preclearance Required security type :
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
                          && !objTradingPolicyModel.PreClrTradesApprovalReqFlag && Convert.ToString(objTradingPolicyModel.PreClrForAllSecuritiesFlag) != null)
                            {
                                if (objTradingPolicyModel.IsPreClearanceRequired == true)
                                {
                                    if (tblPreClearanceSecuritywise.Rows.Count <= 0)
                                    {

                                        ModelState.AddModelError("PreClrForAllSecuritiesFlag", InsiderTrading.Common.Common.getResource("rul_msg_55293"));//"Mandatory : Enter at least one entry for Preclearance Required security type");
                                    }
                                }

                            }
                        }
                    }

                  
                    ApplicabilityDTO_OS objApplicablityDTO = new ApplicabilityDTO_OS();
                    ApplicabilitySL_OS objApplicablitySL = new ApplicabilitySL_OS();
                    objApplicablityDTO = objApplicablitySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.TradingPolicy_OS, Convert.ToInt32(objTradingPolicyModel.TradingPolicyId));
                    if (objTradingPolicyModel.TradingPolicyId > 0 && objApplicablityDTO == null)
                    {
                        ModelState.AddModelError("", InsiderTrading.Common.Common.getResource("rul_msg_55302"));//"Mandatory : Applicability is not defined for this trading policy.");
                    }
                    

                }
                if (!ModelState.IsValid)
                {
                    return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
                }

                #endregion Validation Part


                InsiderTrading.Common.Common.CopyObjectPropertyByName(objTradingPolicyModel, objTradingPolicyDTOOS);
                objTradingPolicyDTOOS.LoggedInUserId = objLoginUserDetails.LoggedInUserID;

                if (objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId != null && objTradingPolicyModel.StExSingMultiTransTradeFlagCodeId == ConstEnum.Code.MultipleTransactionTrade)
                {
                    objTradingPolicyDTOOS.TradingThresholdLimtResetFlag = (objTradingPolicyModel.ThresholdLimtResetFlag == TPYesNo_OS.Yes) ? true : false;
                }
                else
                {
                    objTradingPolicyDTOOS.TradingThresholdLimtResetFlag = null;
                }

                if (objTradingPolicyModel.SelectedGenSecurityType != null && objTradingPolicyModel.SelectedGenSecurityType.Count() > 0)
                {
                    var sSubmittedSecurityTypeList = String.Join(",", objTradingPolicyModel.SelectedGenSecurityType);
                    objTradingPolicyDTOOS.GenSecurityType = sSubmittedSecurityTypeList;
                }
                if (objTradingPolicyModel.SelectedGenExceptionFor != null && objTradingPolicyModel.SelectedGenExceptionFor.Count() > 0)
                {
                    var sExceptionForList = String.Join(",", objTradingPolicyModel.SelectedGenExceptionFor);
                    objTradingPolicyDTOOS.GenExceptionFor = sExceptionForList;
                }

                if (objTradingPolicyModel.SelectedPreClearancerequiredforTransaction != null && objTradingPolicyModel.SelectedPreClearancerequiredforTransaction.Count() > 0)
                {
                    var sSelectedPreClearancerequiredforTransactionList = String.Join(",", objTradingPolicyModel.SelectedPreClearancerequiredforTransaction);
                    objTradingPolicyDTOOS.SelectedPreClearancerequiredforTransactionValue = sSelectedPreClearancerequiredforTransactionList;
                }

                if (objTradingPolicyDTOOS.SelectedPreClearancerequiredforTransactionValue == null)
                {
                    objTradingPolicyDTOOS.SelectedPreClearanceProhibitforNonTradingforTransactionValue = null;
                }

                if (objTradingPolicyModel.PreclearanceWithoutPeriodEndDisclosure == 0)
                {
                    objTradingPolicyModel.PreclearanceWithoutPeriodEndDisclosure = 188003;
                }

                if (objTradingPolicyModel.SelectedPreClrProhibitNonTradePeriodTransaction != null && objTradingPolicyModel.SelectedPreClrProhibitNonTradePeriodTransaction.Count() > 0)
                {
                    var sSelectedPreClrProhibitNonTradePeriodTransaction = String.Join(",", objTradingPolicyModel.SelectedPreClrProhibitNonTradePeriodTransaction);
                    objTradingPolicyDTOOS.SelectedPreClearanceProhibitforNonTradingforTransactionValue = sSelectedPreClrProhibitNonTradePeriodTransaction;
                }
                if (objTradingPolicyModel.GenCashAndCashlessPartialExciseOptionForContraTrade == 0)
                {
                    objTradingPolicyDTOOS.GenCashAndCashlessPartialExciseOptionForContraTrade = InsiderTrading.Common.ConstEnum.Code.ESOPExciseOptionFirstandThenOtherShares;
                }

                if (sContraTradeSecurityTypeCommaSeparatedList != null && sContraTradeSecurityTypeCommaSeparatedList != "")
                {
                    objTradingPolicyDTOOS.SelectedContraTradeSecuirtyType = sContraTradeSecurityTypeCommaSeparatedList;
                }


                //New column added on 2-Jun-2016(YES BANK customization)
                             

                if (objTradingPolicyDTOOS.SeekDeclarationFromEmpRegPossessionOfUPSIFlag == true &&
                    !(objTradingPolicyModel.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures == null ||
                objTradingPolicyModel.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures == ""))
                {
                    objTradingPolicyDTOOS.SeekDeclarationFromEmpRegPossessionOfUPSIFlag = objTradingPolicyModel.SeekDeclarationFromEmpRegPossessionOfUPSIFlag;
                    objTradingPolicyDTOOS.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures = objTradingPolicyModel.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures;
                    objTradingPolicyDTOOS.DeclarationToBeMandatoryFlag = objTradingPolicyModel.DeclarationToBeMandatoryFlag;
                    objTradingPolicyDTOOS.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag = objTradingPolicyModel.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag;
                }
                else
                {
                    objTradingPolicyDTOOS.SeekDeclarationFromEmpRegPossessionOfUPSIFlag = objTradingPolicyModel.SeekDeclarationFromEmpRegPossessionOfUPSIFlag;
                    objTradingPolicyDTOOS.DeclarationFromInsiderAtTheTimeOfContinuousDisclosures = string.Empty;
                    objTradingPolicyDTOOS.DeclarationToBeMandatoryFlag = false;
                    objTradingPolicyDTOOS.DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag = false;
                }

                //objTradingPolicyDTOOS.CurrentHistoryCodeId = 134001;// InsiderTrading.Common.ConstEnum.Code.CurrentRecord;
                objTradingPolicyDTOOS = objTradingPolicySLOS.Save(objLoginUserDetails.CompanyDBConnectionString, objTradingPolicyDTOOS, tblPreClearanceSecuritywise,
                    tblContinousSecuritywise, tblPreclearanceTransactionSecurityMapping);

                InsiderTrading.Common.Common.CopyObjectPropertyByName(objTradingPolicyDTOOS, objTradingPolicyModel);

                objTradingPolicyModel.ThresholdLimtResetFlag = (objTradingPolicyModel.TradingThresholdLimtResetFlag != null && (bool)objTradingPolicyModel.TradingThresholdLimtResetFlag) ? TPYesNo_OS.Yes : TPYesNo_OS.No;

                // return RedirectToAction("Create", new { TradingPolicyId = objTradingPolicyModel.TradingPolicyId, CalledFrom = CalledFrom });
                int? nTradingPolicyStatus = objTradingPolicyDTOOS.TradingPolicyStatusCodeId;
                string sMessage = "";
                if (nTradingPolicyStatus == InsiderTrading.Common.ConstEnum.Code.TradingPolicyStatusActive)
                {
                    ArrayList lst = new ArrayList();
                    lst.Add(objTradingPolicyModel.TradingPolicyName);
                    sMessage = InsiderTrading.Common.Common.getResource("rul_msg_55305", lst);
                }
                else
                if (nTradingPolicyStatus == InsiderTrading.Common.ConstEnum.Code.TradingPolicyStatusInactive)
                {
                    ArrayList lst = new ArrayList();
                    lst.Add(objTradingPolicyModel.TradingPolicyName);
                    sMessage = InsiderTrading.Common.Common.getResource("rul_msg_55304", lst);
                }
                else
                {
                    ArrayList lst = new ArrayList();
                    lst.Add(objTradingPolicyModel.TradingPolicyName);
                    sMessage = InsiderTrading.Common.Common.getResource("rul_msg_55305", lst);
                }
                return Json(new
                {
                    status = true,
                    msg = sMessage,
                    TradingPolicyId = objTradingPolicyModel.TradingPolicyId,
                    CalledFrom = CalledFrom,
                    TradingPolicyStatus = nTradingPolicyStatus
                });
            }
            catch (Exception exp)
            {
                
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));                

                return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
            }
            finally
            {
                ViewBag.TradingPolicyCodeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PolicyGroup, null, null, null, null, false);
                ViewBag.Transactiontradesinglemultiple = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionTradeSingleOrMultiple, null, null, null, null, false);
                ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                var GenExceptionForList_OS = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                GenExceptionForList_OS.RemoveRange(1, 3);
                ViewBag.GenExceptionForList = GenExceptionForList_OS;

                ViewBag.StExMultiTradeFreqList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.StExMultiTradeCalFinYearList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.CalendarOrFinancialYear, null, null, null, null, false);

                var TransactionTypeList_OS = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                TransactionTypeList_OS.RemoveRange(1, 3);
                ViewBag.TransactionTypeList = TransactionTypeList_OS;

                objTradingPolicyModel.AssignedPreClearancerequiredforTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimitsOS, Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TradingPolicySecuitywiseLimitsOS,  Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), objTradingPolicyModel.TradingPolicyId.ToString(), null, null, null, false);

                ViewBag.ProhibitTransactionTypeList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(),  null, null, null, false);

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
               
                ApplicabilitySL_OS objApplicabilitySL = new ApplicabilitySL_OS();
                ApplicabilityDTO_OS objApplicabilityDTO = objApplicabilitySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, InsiderTrading.Common.ConstEnum.Code.TradingPolicy_OS, Convert.ToInt32(objTradingPolicyModel.TradingPolicyId));
                if (objApplicabilityDTO != null)
                {
                    ViewBag.HasApplicabilityDefinedFlag = 1;
                }
                else
                {
                    ViewBag.HasApplicabilityDefinedFlag = 0;
                }
                ViewBag.TradingPolicyType = objTradingPolicyModel.TradingPolicyForCodeId;
                objTradingPolicyModel.TradingPolicyDocumentFile = Common.Common.GenerateDocumentList(Common.ConstEnum.Code.TradingPolicy_OS, Convert.ToInt32(objTradingPolicyModel.TradingPolicyId), 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.TradingPolicyFile);
                List<TransactionSecurityMapConfigDTO_OS> lstTransactionSecurityMapConfigDTO = new List<TransactionSecurityMapConfigDTO_OS>();

                lstTransactionSecurityMapConfigDTO = objTradingPolicySLOS.TransactionSecurityMapConfigList(objLoginUserDetails.CompanyDBConnectionString, null).ToList<TransactionSecurityMapConfigDTO_OS>();

                objTradingPolicyModel.AllTransactionSecurityMappingList = lstTransactionSecurityMapConfigDTO;

                List<string> lst = new List<string>();

                foreach (var item in objTradingPolicyModel.AssignedPreClearancerequiredforTransactionList)
                {
                    lst.Add(item.Key);
                }

                ViewBag.SelectPreclearanceTransaction = lst;

                if (objTradingPolicyModel.TradingPolicyId > 0)
                {
                    List<TradingPolicyForTransactionSecurityDTO_OS> lstTradingPolicyForTransactionSecurityDTO =
                            objTradingPolicySLOS.TradingPolicyForTransactionSecurityList(objLoginUserDetails.CompanyDBConnectionString, objTradingPolicyModel.TradingPolicyId, 132015).ToList<TradingPolicyForTransactionSecurityDTO_OS>();
                    ViewBag.TradingPolicyForTransactionSecurityList = lstTradingPolicyForTransactionSecurityDTO;
                }


            }
        }
        #endregion Save Trading Policy

        #region Cancel
        /// <summary>
        /// Save Trading Policy Other Security
        /// </summary>
        /// <param name="objTradingPolicyModel"></param>
        /// <returns></returns>
        [HttpPost]
        //  [Button(ButtonName = "Cancel")]
        ///  [ActionName("Cancel")]
        public ActionResult Cancel(TradingPolicyModel_OS objTradingPolicyModel, string CalledFrom, int TradingPolicyId, int ParentTradingPolicy = 0)
        {
            if (CalledFrom == "History")
            {
                return RedirectToAction("History", "TradingPolicy_OS", new { TradingPolicyId = ParentTradingPolicy, acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_OTHER_SECURITY_VIEW, CalledFrom = CalledFrom });
            }
            else
            {
                return RedirectToAction("Index", "TradingPolicy_OS", new { acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_OTHER_SECURITY_VIEW });
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
        public ActionResult ViewApplicablity_OS(int TradingPolicyID, string CalledFrom, int TradingPolicyForCodeTypeID, int acid, int? ParentTradingPolicy = 0)
        {
            return RedirectToAction("Index", "Applicability_OS", new { acid = acid, nApplicabilityType = ConstEnum.Code.TradingPolicy_OS, nMasterID = TradingPolicyID, CalledFrom = CalledFrom, CodeTypeId = TradingPolicyForCodeTypeID, ParentTradingPolicy = ParentTradingPolicy });
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
        public ActionResult DeleteTradingPolicy(int TradingPolicyId, int acid, int TradingPolicyForAction)
        {
            List<PopulateComboDTO> lstAssignedSecurityType = new List<PopulateComboDTO>();
            List<PopulateComboDTO> lstAssignedExceptionFor = new List<PopulateComboDTO>();
            TradingPolicySL_OS objTradingPolicySLOS = new TradingPolicySL_OS();
            TradingPolicyModel_OS objTradingPolicyModelOS = new TradingPolicyModel_OS();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ApplicabilitySL_OS objApplicabilitySL = new ApplicabilitySL_OS();
            ApplicabilityDTO_OS objApplicabilityDTO = null;
            List<TransactionSecurityMapConfigDTO_OS> lstTransactionSecurityMapConfigDTO = new List<TransactionSecurityMapConfigDTO_OS>();
            try
            {
                ViewBag.TradingPolicyUserAction = TradingPolicyForAction;
                bool bReturn = objTradingPolicySLOS.Delete(objLoginUserDetails.CompanyDBConnectionString, TradingPolicyId, objLoginUserDetails.LoggedInUserID);
                return RedirectToAction("Index", "TradingPolicy_OS", new { acid = InsiderTrading.Common.ConstEnum.UserActions.TRADING_POLICY_OTHER_SECURITY_VIEW }).Success(InsiderTrading.Common.Common.getResource("rul_msg_15373"));
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                TradingPolicyDTO_OS objTradingPolicyDTOOS = objTradingPolicySLOS.GetDetails(objLoginUserDetails.CompanyDBConnectionString, TradingPolicyId);
                Common.Common.CopyObjectPropertyByName(objTradingPolicyDTOOS, objTradingPolicyModelOS);

                objTradingPolicyModelOS.ThresholdLimtResetFlag = (objTradingPolicyModelOS.TradingThresholdLimtResetFlag != null && (bool)objTradingPolicyModelOS.TradingThresholdLimtResetFlag) ? TPYesNo_OS.Yes : TPYesNo_OS.No;
                ViewBag.TradingPolicyUserAction = TradingPolicyForAction;
                ViewBag.TradingPolicyCodeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PolicyGroup, null, null, null, null, false);
                ViewBag.Transactiontradesinglemultiple = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionTradeSingleOrMultiple, null, null, null, null, false);
                ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                var GenExceptionForList_OS = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                GenExceptionForList_OS.RemoveRange(1, 3);
                ViewBag.GenExceptionForList = GenExceptionForList_OS;

                ViewBag.StExMultiTradeFreqList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.StExMultiTradeCalFinYearList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.CalendarOrFinancialYear, null, null, null, null, false);

                var TransactionTypeList_OS = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                TransactionTypeList_OS.RemoveRange(1, 3);
                ViewBag.TransactionTypeList = TransactionTypeList_OS;

                objTradingPolicyModelOS.AssignedPreClearancerequiredforTransactionList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModelOS.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(),  null, null, null, false);

                objTradingPolicyModelOS.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModelOS.TradingPolicyId.ToString(), Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(),  null, null, null, false);

                ViewBag.ProhibitTransactionTypeList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(),  null, null, null, false);

                if (objTradingPolicyModelOS.GenSecurityType != null && objTradingPolicyModelOS.GenSecurityType != "")
                {
                    List<int> TagIds = objTradingPolicyModelOS.GenSecurityType.Split(',').Select(int.Parse).ToList();

                    foreach (var a in TagIds)
                    {
                        PopulateComboDTO obj = new PopulateComboDTO();
                        obj.Key = a.ToString();
                        obj.Value = "";
                        lstAssignedSecurityType.Add(obj);
                    }
                }
                if (objTradingPolicyModelOS.GenExceptionFor != null && objTradingPolicyModelOS.GenExceptionFor != "")
                {
                    List<int> TagIds1 = objTradingPolicyModelOS.GenExceptionFor.Split(',').Select(int.Parse).ToList();

                    foreach (var a in TagIds1)
                    {
                        PopulateComboDTO obj = new PopulateComboDTO();
                        obj.Key = a.ToString();
                        obj.Value = "";
                        lstAssignedExceptionFor.Add(obj);
                    }
                }

                objTradingPolicyModelOS.AssignedGenSecurityTypeList = lstAssignedSecurityType;
                objTradingPolicyModelOS.AssignedGenExceptionForList = lstAssignedExceptionFor;
                ViewBag.TradingPolicyId = objTradingPolicyModelOS.TradingPolicyId;
                ViewBag.CalledFrom = "Edit";
                ViewBag.OccurrenceFrequencyYearly = InsiderTrading.Common.ConstEnum.Code.Yearly;
                ViewBag.TradingPolicyEmployeeType = InsiderTrading.Common.ConstEnum.Code.TradingPolicyEmployeeType;
                ViewBag.MultipleTransactionTrade = InsiderTrading.Common.ConstEnum.Code.MultipleTransactionTrade;

                objApplicabilityDTO = objApplicabilitySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, InsiderTrading.Common.ConstEnum.Code.TradingPolicy_OS, Convert.ToInt32(objTradingPolicyModelOS.TradingPolicyId));
                if (objApplicabilityDTO != null)
                {
                    ViewBag.HasApplicabilityDefinedFlag = 1;
                }
                else
                {
                    ViewBag.HasApplicabilityDefinedFlag = 0;
                }
                ViewBag.TradingPolicyType = objTradingPolicyModelOS.TradingPolicyForCodeId;
                objTradingPolicyModelOS.TradingPolicyDocumentFile = Common.Common.GenerateDocumentList(Common.ConstEnum.Code.TradingPolicy_OS, Convert.ToInt32(objTradingPolicyModelOS.TradingPolicyId), 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.TradingPolicyFile);
                lstTransactionSecurityMapConfigDTO = objTradingPolicySLOS.TransactionSecurityMapConfigList(objLoginUserDetails.CompanyDBConnectionString, null).ToList<TransactionSecurityMapConfigDTO_OS>();
                objTradingPolicyModelOS.AllTransactionSecurityMappingList = lstTransactionSecurityMapConfigDTO;
                return View("Create", objTradingPolicyModelOS);

            }
            finally
            {

                lstAssignedSecurityType = null;
                lstAssignedExceptionFor = null;
                objTradingPolicySLOS = null;
                objTradingPolicyModelOS = null;
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
        public JsonResult DeleteFromGrid(int TradingPolicyId, int acid)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            TradingPolicySL_OS objTradingPolicySLOS = new TradingPolicySL_OS();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                bool bReturn = objTradingPolicySLOS.Delete(objLoginUserDetails.CompanyDBConnectionString, TradingPolicyId, objLoginUserDetails.LoggedInUserID);
                statusFlag = true;
                ErrorDictionary.Add("success", InsiderTrading.Common.Common.getResource("rul_msg_55306"));
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
        public ActionResult RadioButtonChangeTransaction(TradingPolicyModel_OS objTradingPolicyModel, int acid)
        {
            try
            {
                ViewBag.StExMultiTradeFreqList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.StExMultiTradeCalFinYearList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.CalendarOrFinancialYear, null, null, null, null, false);
                return null; //This is not in use of Continuous dis so we can return the null
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
        public ActionResult TradingPolicyForCodeType(TradingPolicyModel_OS objTradingPolicyModel, int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                               
                    var TransactionTypeList_OS = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                    TransactionTypeList_OS.RemoveRange(1, 3);
                    ViewBag.TransactionTypeList = TransactionTypeList_OS;
                    objTradingPolicyModel.AssignedPreClearancerequiredforTransactionList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(),  null, null, null, false);

                    objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), null, null, null, false);

                    ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);

                    ViewBag.ProhibitTransactionTypeList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), null, null, null, false);

                    objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), null, null, null, false);

                    List<TransactionSecurityMapConfigDTO_OS> lstTransactionSecurityMapConfigDTO = new List<TransactionSecurityMapConfigDTO_OS>();
                    TradingPolicySL_OS obj = new TradingPolicySL_OS();


                    lstTransactionSecurityMapConfigDTO = obj.TransactionSecurityMapConfigList(objLoginUserDetails.CompanyDBConnectionString, null).ToList<TransactionSecurityMapConfigDTO_OS>();

                    objTradingPolicyModel.AllTransactionSecurityMappingList = lstTransactionSecurityMapConfigDTO;
                    ViewBag.SelectPreclearanceTransaction = objTradingPolicyModel.SelectedPreClearancerequiredforTransaction;

                    if (objTradingPolicyModel.TradingPolicyId > 0)
                    {
                        List<TradingPolicyForTransactionSecurityDTO_OS> lstTradingPolicyForTransactionSecurityDTO =
                                obj.TradingPolicyForTransactionSecurityList(objLoginUserDetails.CompanyDBConnectionString, objTradingPolicyModel.TradingPolicyId, 132015).ToList<TradingPolicyForTransactionSecurityDTO_OS>();
                        ViewBag.TradingPolicyForTransactionSecurityList = lstTradingPolicyForTransactionSecurityDTO;
                    }
                    ViewBag.TradingPolicyUserAction = acid;
                    ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                    return PartialView("_PreclearanceRequirement_OS", objTradingPolicyModel);
                
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
        public ActionResult PreClearanceTransactionForTrade(TradingPolicyModel_OS objTradingPolicyModel, int acid)
        {
            try
            {
                if (!objTradingPolicyModel.PreClrTradesApprovalReqFlag)
                {
                    ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                    ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                    FillGrid(ConstEnum.GridType.TradingPolicySecuritywiseValueList_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), null);
                    ViewBag.TradingPolicyUserAction = acid;
                    return PartialView("_PreclearanceTransaction_OS", objTradingPolicyModel);
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
        public ActionResult PreClrSeekDeclarationForUPSIFlagURL(TradingPolicyModel_OS objTradingPolicyModel, int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                if (objTradingPolicyModel.PreClrSeekDeclarationForUPSIFlag)
                {
                    return PartialView("_SeekDeclarationUPSI_OS", objTradingPolicyModel);
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
        public ActionResult PreClrPartialTradeNotDoneFlagURL(TradingPolicyModel_OS objTradingPolicyModel, int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                if (objTradingPolicyModel.PreClrReasonForNonTradeReqFlag)
                {
                    return PartialView("_Preclrpartialtradenotdoneflag_OS", objTradingPolicyModel);
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
        public ActionResult DiscloInitReqFlagURL(TradingPolicyModel_OS objTradingPolicyModel, int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                if (objTradingPolicyModel.DiscloInitReqFlag)
                {
                    return PartialView("_InitialDisclosure_OS", objTradingPolicyModel);
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
        public ActionResult DiscloPeriodEndReqFlagURL(TradingPolicyModel_OS objTradingPolicyModel, int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                if (objTradingPolicyModel.DiscloPeriodEndReqFlag)
                {
                    ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                    return PartialView("_PeriodEndDisclosure_OS", objTradingPolicyModel);
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

        

        #region PreclearanceSecurityFlagChange
        [AuthorizationPrivilegeFilter]
        public ActionResult PreclearanceSecurityFlagChange(TradingPolicyModel_OS objTradingPolicyModel, string SelectedOptionsCheckBox, int acid)
        {

            try
            {
                FillGrid(ConstEnum.GridType.TradingPolicySecuritywiseValueList_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), "1");
                objTradingPolicyModel.PreClrForAllSecuritiesFlag = true; // set the by default All security type
                if (objTradingPolicyModel.PreClrForAllSecuritiesFlag)
                {
                    FillGrid(ConstEnum.GridType.TradingPolicySecuritywiseValueList_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), "1");
                }
                else
                {
                    FillGrid(ConstEnum.GridType.TradingPolicySecuritywiseValueList_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), "0");
                }
                ViewBag.TradingPolicyUserAction = acid;
                ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                return PartialView("_PreSecuritywiseLimitList_OS", objTradingPolicyModel);

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
        public ActionResult ContinousSecurityFlagChange(TradingPolicyModel_OS objTradingPolicyModel, int acid)
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
                return PartialView("_ContinousSecuritywiseValueList_OS", objTradingPolicyModel);
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
        public ActionResult ProhibitPreclearanceValueChange(TradingPolicyModel_OS objTradingPolicyModel, int acid)
        {
            try
            {
                ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                if (objTradingPolicyModel.SelectedPreClearancerequiredforTransaction != null && objTradingPolicyModel.SelectedPreClearancerequiredforTransaction.Count > 0)
                {
                    List<PopulateComboDTO> lst1 = new List<PopulateComboDTO>();
                    // List<PopulateComboDTO> lst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType.Substring(1,3), null, null, null, null, false);

                    var TransactionTypeList_OS = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                    TransactionTypeList_OS.RemoveRange(1, 3);
                    List<PopulateComboDTO> lst = TransactionTypeList_OS;

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
                    objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(), null, null, null, false);
                }
                ViewBag.TradingPolicyUserAction = acid;
                return PartialView("_ProhibitTradingNonTradingPeriod_OS", objTradingPolicyModel);

            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion ProhibitPreclearanceValueChange

        #region ContinuousDisclosureRequiredURL
        [AuthorizationPrivilegeFilter]
        public ActionResult ContinuousDisclosureRequiredURL(TradingPolicyModel_OS objTradingPolicyModel, int acid)
        {
            try
            {
                ViewBag.TradingPolicyUserAction = acid;
                return PartialView("_ContinuousDisclosureRequired_OS", objTradingPolicyModel);

            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion ContinuousDisclosureRequiredURL

        

        #region ContinuousLimitsURL
        [AuthorizationPrivilegeFilter]
        public ActionResult ContinuousLimitsURL(TradingPolicyModel_OS objTradingPolicyModel, int acid)
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
                return null;//This is not in use of Continuous dis so we can return the null

            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion ContinuousLimitsURL

        #region TransactionSecuityMappingChange
        [AuthorizationPrivilegeFilter]
        public ActionResult TransactionSecuityMappingChange(TradingPolicyModel_OS objTradingPolicyModel, int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            List<TransactionSecurityMapConfigDTO_OS> lstTransactionSecurityMapConfigDTO = new List<TransactionSecurityMapConfigDTO_OS>();
            TradingPolicySL_OS obj = new TradingPolicySL_OS();
            List<TradingPolicyForTransactionSecurityDTO_OS> lstTradingPolicyForTransactionSecurityDTO = null;
            try
            {
                lstTransactionSecurityMapConfigDTO = obj.TransactionSecurityMapConfigList(objLoginUserDetails.CompanyDBConnectionString, null).ToList<TransactionSecurityMapConfigDTO_OS>();
                objTradingPolicyModel.AllTransactionSecurityMappingList = lstTransactionSecurityMapConfigDTO;
                ViewBag.SelectPreclearanceTransaction = objTradingPolicyModel.SelectedPreClearancerequiredforTransaction;
                if (objTradingPolicyModel.TradingPolicyId > 0)
                {
                    lstTradingPolicyForTransactionSecurityDTO =
                            obj.TradingPolicyForTransactionSecurityList(objLoginUserDetails.CompanyDBConnectionString, objTradingPolicyModel.TradingPolicyId, 132015).ToList<TradingPolicyForTransactionSecurityDTO_OS>();
                    ViewBag.TradingPolicyForTransactionSecurityList = lstTradingPolicyForTransactionSecurityDTO;
                }
                var TransactionTypeList_OS = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, false);
                TransactionTypeList_OS.RemoveRange(1, 3);
                ViewBag.TransactionTypeList = TransactionTypeList_OS;

                objTradingPolicyModel.AssignedPreClearancerequiredforTransactionList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), null, null, null, false);
                objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(),  null, null, null, false);
                ViewBag.DiscloPeriodEndFreqLIst = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.OccurrenceFrequency, null, null, null, null, false);
                ViewBag.ProhibitTransactionTypeList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), null, null, null, false);
                objTradingPolicyModel.AssignedPreClrProhibitNonTradePeriodTransactionList = FillComboValues(Common.ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objTradingPolicyModel.TradingPolicyId.ToString(), Common.ConstEnum.Code.ProhibitPreclearanceDuringNonTrading.ToString(),  null, null, null, false);
                ViewBag.GenSecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
                return PartialView("PreclearanceTransactionSecurityMapping_OS", objTradingPolicyModel);

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
        public ActionResult ContraTradeSecuirtyMapping(TradingPolicyModel_OS objTradingPolicyModel, int acid)
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
                return PartialView("_ContraTradeSecurityMapping_OS", objTradingPolicyModel);

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

        public ActionResult ViewOverlappedUser(int TradingPolicyId, string ShowFrom)//TradingPolicyModel objTradingPolicyModel,string PreclearanceSecuritywisedata, string ContinousSecuritywisedata)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            try
            {

                ViewBag.TradingPolicyIDHideen = TradingPolicyId.ToString();
                ViewBag.ShowFrom = ShowFrom;
                FillGrid(ConstEnum.GridType.OverlappingTradingPolicyList_OS, TradingPolicyId.ToString(), null, null);
                return PartialView("~/Views/TradingPolicy_OS/ViewOverlapedUserList_OS.cshtml");
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
