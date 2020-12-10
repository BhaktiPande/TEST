using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.SL;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class PeriodEndDisclosureController : Controller
    {
        private string sLookupPrefix = "tra_msg_";

        #region Index
        //
        // GET: /PeriodEndDisclosure/
        /// <summary>
        /// This is default view method 
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            String view_name = "";

            try
            {
                //check if request come from Insider menu option or transaction menu option by comparing list view activity id
                if (acid == ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE) //insider menu option 
                {
                    view_name = "PeriodStatus"; //set view name for insider menu option
                }
                else if (acid == ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE) // transcation menu optoin
                {
                    view_name = "UsersStatus"; //set view name for transcation menu option
                }
            }
            catch (Exception ex)
            {

            }

            return RedirectToAction(view_name, "PeriodEndDisclosure", new { acid = acid });
        }
        #endregion Index

        #region UsersStatus View
        [AuthorizationPrivilegeFilter]
        public ActionResult UsersStatus(int acid, int year = 0, int period = 0,int Uid=0)
        {
            LoginUserDetails objLoginUserDetails = null;

            int period_type_code = 0;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                
                //get financial year list
                List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
                List<PopulateComboDTO> lstYear = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.FinancialYear, null, null, null, null, sLookupPrefix).ToList<PopulateComboDTO>();

                //get current year 
                int CurrentYearCode = Common.Common.GetCurrentYearCode(objLoginUserDetails.CompanyDBConnectionString);

                //in dropdown list include years less then current year
                foreach (PopulateComboDTO yr in lstYear)
                {
                    if (CurrentYearCode >= Convert.ToInt32(yr.Key))
                    {
                        lstPopulateComboDTO.Add(yr);
                    }
                }

                ViewBag.FinancialYearDropDown = lstPopulateComboDTO;

                //show last period end year as default selected
                int lastPeriodEndYearCode = CurrentYearCode; 
                ViewBag.LastPeriodEndYear = (year == 0) ? lastPeriodEndYearCode : year;

                //get configuation code for period type 
                period_type_code = Common.Common.GetConfiguartionCode(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PeriodType);

                //get period type list 
                List<PopulateComboDTO> Periodlist = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.FinancialPeriod, period_type_code.ToString(), null, null, null, sLookupPrefix).ToList<PopulateComboDTO>();
                ViewBag.PeriodDropDown = Periodlist;

                ////show last period end year as default selected
                //using (PeriodEndDisclosureSL objPeriodEndDisclosureSL = new PeriodEndDisclosureSL())
                //{
                //    int lastPeriodEndPeriodCode = objPeriodEndDisclosureSL.GetLastestPeriodEndPeriodCode(objLoginUserDetails.CompanyDBConnectionString);
                //    ViewBag.LastPeriodEndPeriod = (period == 0) ? lastPeriodEndPeriodCode : period;
                //}

                //get trading submission status list
                ViewBag.TradingSubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "showuploaded", null, null, null, true, sLookupPrefix);

                //get soft copy submission status list
                ViewBag.SoftCopySubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                //get hard copy submission status list
                ViewBag.HardCopySubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                //get stock exchange submission status list
                ViewBag.StockExchangeSubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                ViewBag.EmployeeStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EmpStatusList, ConstEnum.CodeGroup.EmployeeStatus, "", null, null, null, true, sLookupPrefix);

                ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosureUsersStatusList;

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

            }
            catch (Exception ex)
            {

            }
            finally
            {
                objLoginUserDetails = null;
            }

            return View("UsersStatus");
        }
        #endregion UsersStatus View

        #region Period End Disclosures Insider
        [AuthorizationPrivilegeFilter]
        public ActionResult PeriodEndDisclosuresInsiderDashnoard(String inp_sParam, String isInsider, int acid, int year = 0, int period = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            
            ViewData["inp_sParam"] = inp_sParam;
            ViewData["IsInsider"] = isInsider;
            int period_type_code = 0;

            List<PopulateComboDTO> lstPopulateComboDTO = null;
            List<PopulateComboDTO> lstYear = null;
            List<PopulateComboDTO> Periodlist = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                
                lstPopulateComboDTO = new List<PopulateComboDTO>();
                lstYear = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.FinancialYear, null, null, null, null, sLookupPrefix).ToList<PopulateComboDTO>();

                int CurrentYearCode = Common.Common.GetCurrentYearCode(objLoginUserDetails.CompanyDBConnectionString);

                foreach (PopulateComboDTO yr in lstYear)
                {
                    if (CurrentYearCode >= Convert.ToInt32(yr.Key))
                    {
                        lstPopulateComboDTO.Add(yr);
                    }
                }

                ViewBag.FinancialYearDropDown = lstPopulateComboDTO;

                int lastPeriodEndYearCode = CurrentYearCode;
                ViewBag.LastPeriodEndYear = (year == 0) ? lastPeriodEndYearCode : year;

                period_type_code = Common.Common.GetConfiguartionCode(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PeriodType);

                Periodlist = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.FinancialPeriod, period_type_code.ToString(), null, null, null, sLookupPrefix).ToList<PopulateComboDTO>();
                ViewBag.PeriodDropDown = Periodlist;

                ViewBag.TradingSubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                ViewBag.SoftCopySubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                ViewBag.HardCopySubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                ViewBag.StockExchangeSubmittedStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EventStatusList, ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "", null, null, null, true, sLookupPrefix);

                ViewBag.EmployeeStatus = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.EmpStatusList, ConstEnum.CodeGroup.EmployeeStatus, "", null, null, null, true, sLookupPrefix);

                ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosureUsersStatusList;

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

            }
            catch (Exception ex)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                lstPopulateComboDTO = null;
                lstYear = null;
                Periodlist = null;
            }

            return View("UsersStatus");
        }
        #endregion Period End Disclosures Insider

        #region PeriodStatus View
        //[AuthorizationPrivilegeFilter]       
        public ActionResult PeriodStatus(int acid, int year = 0, int uid = 0, int ContDisCheck = 0, int PeriodEndDisCheck = 0, int IsIDPending = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            UserInfoDTO objUserInfoDTO = null;
            bool backToCOList = false;           

            int activity_id_disclosure = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE;
            int activity_id_disclosure_letter = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION;
            int activity_id_disclosure_letter_stockexchange = 0;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);                
                ViewBag.UserId = (uid == 0) ? objLoginUserDetails.LoggedInUserID : uid;
                ViewBag.activity_id = acid;

                if (IsIDPending > 0)
                    ModelState.AddModelError("IsIDPending", Common.Common.getResource("dis_msg_53145"));
               
                if (ContDisCheck > 0)
                    ModelState.AddModelError("ContinuousDisclosureStatus", Common.Common.getResource("dis_lbl_50591"));

                if (PeriodEndDisCheck > 0)
                    ModelState.AddModelError("PEDisclosureStatus", Common.Common.getResource("dis_msg_17391"));   

                //if login user is CO or admin then show back button on view which redirect back to CO screen for user list
                if (acid == ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE || objLoginUserDetails.UserTypeCodeId == 101001 || objLoginUserDetails.UserTypeCodeId == 101002)
                {
                    backToCOList = true; //set flag to show back button 

                    activity_id_disclosure = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE;
                    activity_id_disclosure_letter = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_LETTER_SUBMISSION;
                    activity_id_disclosure_letter_stockexchange = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE_STOCK_EXCHANGE_SUBMISSION;

                    //if activity id is for CO then fetch employee insider details 
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, uid);

                        ViewBag.EmployeeId = objUserInfoDTO.EmployeeId;
                        ViewBag.InsiderName = (objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.CorporateUserType) ? objUserInfoDTO.CompanyName : objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
                    }
                }
                
                //get current year 
                int CurrentYearCode = Common.Common.GetCurrentYearCode(objLoginUserDetails.CompanyDBConnectionString);

                //show last period end year as default selected
                int lastPeriodEndYearCode = CurrentYearCode;  

                ViewBag.LastPeriodEndYear = (year == 0) ? lastPeriodEndYearCode : year;

                //NOTE -- this year list should be from year when user has become insider. 
                //user should be not be able to see ealier year as there won't be any records for earlier year or date from system is implemeted which ever is later 
                List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
                List<PopulateComboDTO> lstYear = Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.FinancialYear, null, null, null, null, sLookupPrefix).ToList<PopulateComboDTO>();


                //in dropdown list include years less then current year
                foreach (PopulateComboDTO yr in lstYear)
                {
                    if (CurrentYearCode >= Convert.ToInt32(yr.Key))
                    {
                        lstPopulateComboDTO.Add(yr);
                    }
                }

                ViewBag.FinancialYearDropDown = lstPopulateComboDTO;

                ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosurePeriodStatusList;

                ViewBag.backToCOList = backToCOList;

                ViewBag.activity_id_disclosure = activity_id_disclosure;
                ViewBag.activity_id_disclosure_letter = activity_id_disclosure_letter;
                ViewBag.activity_id_disclosure_letter_stockexchange = activity_id_disclosure_letter_stockexchange;

            }
            catch (Exception ex)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objUserInfoDTO = null;
            }

            return View("PeriodStatus");
        }
        #endregion PeriodStatus View

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }

        #region Summary View
        [AuthorizationPrivilegeFilter]
        public ActionResult Summary(int acid, int period, int year, int pdtype, int uid=0, int tmid=0)
        {
            LoginUserDetails objLoginUserDetails = null;
            UserInfoDTO objUserInfoDTO = null;
            ViewBag.showAddTransactionBtn = false;
            DateTime dtEndDate=DateTime.Now;

            Dictionary<string, object> dicPeriodStartEnd = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                
                //set activity id for summary page as this page is access from both menu - insider and CO
                ViewBag.activity_id = acid;
                
                using(PeriodEndDisclosureSL objPeriodEndDisclosure = new PeriodEndDisclosureSL())
                {
                     dicPeriodStartEnd = objPeriodEndDisclosure.GetPeriodStarEndDate(objLoginUserDetails.CompanyDBConnectionString, year, period, pdtype);

                    DateTime dtStartDate = Convert.ToDateTime(dicPeriodStartEnd["start_date"]);
                    dtEndDate = Convert.ToDateTime(dicPeriodStartEnd["end_date"]);
                    String dtFormat = "dd MMM yyyy";
                    ViewBag.Period = dtStartDate.ToString(dtFormat) + " - " + dtEndDate.ToString(dtFormat);
                }

                //set input vaules for period end summary grid
                ViewBag.UserId = (uid == 0) ? objLoginUserDetails.LoggedInUserID : uid;
                ViewBag.YearCode = year;
                ViewBag.PeriodCode = period;
                ViewBag.PeriodType = pdtype;
                ViewBag.TransactionMasterId = (tmid == 0) ? "" : tmid.ToString();



                ViewBag.GridType = ConstEnum.GridType.PeriodEndDisclosurePeriodSummary;

                //if activity id is for CO then fetch employee insider details 
                if (acid == ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE)
                {
                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
                    {
                        objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, uid);

                        ViewBag.EmployeeId = objUserInfoDTO.EmployeeId;
                        ViewBag.InsiderName = (objUserInfoDTO.UserTypeCodeId == ConstEnum.Code.CorporateUserType) ? objUserInfoDTO.CompanyName : objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
                    }
                }
            }
            catch (Exception ex)
            {

            }
            finally
            {
                dicPeriodStartEnd = null;
                //objLoginUserDetails = null;
                objUserInfoDTO = null;
            }

            int contDisStatusCount = 0;
            int PEDisStatusCount = 0;
            int IsIDPending = 0;
            using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
            {
                acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PERIOD_END_DISCLOSURE;
                year = 0;
                List<ContinuousDisclosureStatusDTO> lstConDisclosureStatus = objTradingTransactionSL.Get_ContinuousDisclosureStatus(objLoginUserDetails.CompanyDBConnectionString, uid, dtEndDate);
                foreach (var contDisStatus in lstConDisclosureStatus)
                    contDisStatusCount = contDisStatus.ContDisPendingStatus;
                if (contDisStatusCount > 0)
                {                    
                    int ContDisCheck = contDisStatusCount;
                    return RedirectToAction("PeriodStatus", "PeriodEndDisclosure", new { acid, year, uid, ContDisCheck });
                }
                else
                {
                    List<ContinuousDisclosureStatusDTO> lstPEDisclosureStatus = objTradingTransactionSL.Get_PEDisclosureStatus(objLoginUserDetails.CompanyDBConnectionString, uid, dtEndDate);
                    foreach (var periodEndStatus in lstPEDisclosureStatus)
                    {
                        PEDisStatusCount = periodEndStatus.PEDisPendingStatus;
                        IsIDPending = periodEndStatus.IsRelativeFound;
                    }
                    if (IsIDPending > 0)
                    {
                        return RedirectToAction("PeriodStatus", "PeriodEndDisclosure", new { acid, year, uid, PEDisStatusCount, IsIDPending });
                    }
                    else if (PEDisStatusCount > 0)
                    {
                        int PeriodEndDisCheck = PEDisStatusCount;
                        return RedirectToAction("PeriodStatus", "PeriodEndDisclosure", new { acid, year, uid, PeriodEndDisCheck });
                    }
                    else
                    {
                        TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
                        objTradingTransactionMasterDTO = new TradingTransactionMasterDTO();
                        objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterDetails(objLoginUserDetails.CompanyDBConnectionString, tmid);
                        if (objTradingTransactionMasterDTO.TransactionStatusCodeId == 148002)
                            ViewBag.showAddTransactionBtn = true;

                        return View("Summary");
                    }
                }
            }
        }
        #endregion Summary View

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
            finally
            {
                objPopulateComboDTO = null;
            }

            return lstPopulateComboDTO;
        }
        #endregion FillComboValues

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

            }
            finally
            {
                objLoginUserDetails = null;
                DesignationList = null;
                DesginationNames = null;
            }
            return null;
        }
        #endregion Get Designation list

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
    }
}