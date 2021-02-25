using InsiderTrading.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTradingDAL;
using InsiderTrading.Filters;

namespace InsiderTrading.Controllers
{
    //[RolePrivilegeFilter]
    public class DatatableGridController : Controller
    {

        //Ajax call for fetching grid data
        //[HttpPost]
        [AuthorizationPrivilegeFilter]
        public ActionResult AjaxHandler(String gridtype, String inp_sParam = "", String isInsider = "", int acid = 0, String ClearSearchFilter = "")
        {
            if (ClearSearchFilter == "True")
            {  
                TempData.Remove("SearchArray");
                JsonResult returnJson = Json(new
                {
                   status = false
                }, JsonRequestBehavior.AllowGet);
                return returnJson;
           
            }
            int out_iTotalRecords = 0;
            String sLookUpPrefix = "";
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            IEnumerable<Object> lstCRUserList = new List<Object>();
            // Change the received generic object to <key, value> pair as per required for datatable.
            List<Dictionary<string, Object>> lstUserList = new List<Dictionary<string, Object>>();
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return RedirectToAction("Unauthorised", "Home");
                }

                //Fetch Search parameters
                String sSearch = Request.Form["Search"];
                String[] arr = new string[51];
                arr = sSearch.Split(new string[] { "|#|" }, StringSplitOptions.None);
                for (int i = 0; i <= arr.Length - 1; i++)
                {
                    if (arr[i] == "" || arr[i] == "0")
                        arr[i] = null;
                }
                if (gridtype == "114122" && objLoginUserDetails.LoggedInUserID.ToString() != arr[0])
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                if (!IsNullOrEmpty(arr) &&
                    (gridtype == InsiderTrading.Common.ConstEnum.GridType.ContinuousDisclosureListForCO.ToString()
                    || gridtype == InsiderTrading.Common.ConstEnum.GridType.ContinousDisclosureStatusList.ToString()
                    || gridtype == InsiderTrading.Common.ConstEnum.GridType.Report_ContinuousReportEmployeeWise.ToString()
                    || gridtype == InsiderTrading.Common.ConstEnum.GridType.Report_InitialDisclosureEmployeeWise.ToString()
                    || gridtype == InsiderTrading.Common.ConstEnum.GridType.InitialDisclosureListForCO.ToString()
                    || gridtype == InsiderTrading.Common.ConstEnum.GridType.COUserList.ToString()
                    || gridtype == InsiderTrading.Common.ConstEnum.GridType.EmployeeUserList.ToString()
                    || (gridtype == InsiderTrading.Common.ConstEnum.GridType.RestrictedList.ToString() && arr[8]!="History")))
                {                  
                    TempData["SearchArray"] = arr;
                    TempData.Keep("SearchArray");
                }
                if (!IsNullOrEmpty(arr) && (gridtype == InsiderTrading.Common.ConstEnum.GridType.Report_ContinuousReportEmployeeIndividual.ToString()
                    || gridtype == InsiderTrading.Common.ConstEnum.GridType.Report_InitialDisclosureEmployeeIndividual.ToString()))
                {
                    TempData["ReportSearchArray"] = arr;
                    TempData.Keep("ReportSearchArray");
                }
                //Get sort column, direction, display length and page number
                String sSortCol = Request.Form["mDataProp_" + Request.Form["iSortCol_0"]];
                String sSortDir = Request.Form["sSortDir_0"];
                int nDisplayLength = Convert.ToInt32(Request.Form["iDisplayLength"]);
                int nPage = 0;
                if (nDisplayLength != 0)
                {
                    nPage = Convert.ToInt32(Request.Form["iDisplayStart"]) / nDisplayLength + 1;
                }

                using (GenericSLImpl<Object> objGenericSLImpl = new GenericSLImpl<Object>())
                {
                    //PENDING TRANSACTIONS DASHBOARD : Initial Disclosures-Insider
                    if (isInsider == "InitialDisInsider" && inp_sParam == "154002")
                    {
                        //nDisplayLength = 10;

                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               inp_sParam, arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], arr[24], arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    //PENDING TRANSACTIONS DASHBOARD : Initial Disclosures-Insider Relative
                    else if (isInsider == "InitialDisInsider-Relative" && inp_sParam == "154002")
                    {
                        //nDisplayLength = 10;

                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               inp_sParam, arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               "1", arr[21], arr[22], arr[23], arr[24], arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    //PENDING TRANSACTIONS DASHBOARD : Initial Disclosures-CO
                    else if (isInsider == "ContiDisCO" && inp_sParam == "154006")
                    {
                        //nDisplayLength = 10;
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               inp_sParam, arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], arr[24], arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    //PENDING TRANSACTIONS DASHBOARD : Continuous Disclosures-CO
                    else if (isInsider == "ContinouseDisCO" && inp_sParam == "114049")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               arr[6], "153019", arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], "2", arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }

                    //PENDING TRANSACTIONS DASHBOARD : Continuous Disclosures-Insider
                    else if (isInsider == "ContiDisInsider" && inp_sParam == "144001")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               arr[6], "153019", arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], "3", arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    //PENDING TRANSACTIONS DASHBOARD : Period End Disclosures-Insider
                    else if (isInsider == "PeriodEndDisInsider" && inp_sParam == "154002")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               arr[6], inp_sParam, arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], arr[24], arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    //PENDING TRANSACTIONS DASHBOARD : Period End Disclosures-Insider
                    else if (isInsider == "PeriodEndDisCO")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               arr[6], arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], "1",
                               arr[20], arr[21], arr[22], arr[23], arr[24], arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    //PENDING TRANSACTIONS DASHBOARD : Trade details-Insider
                    else if (isInsider == "TradeDetailsInsider" && inp_sParam == "154002")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               inp_sParam, arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], "1", arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    //PENDING TRANSACTIONS DASHBOARD : Trade details-CO
                    else if (isInsider == "TradeDetailsCO" && inp_sParam == "154006")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               inp_sParam, arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], "1", arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    //PENDING TRANSACTIONS DASHBOARD : Submission to Stock Exchange-CO
                    else if (isInsider == "SubToStckExCO" && inp_sParam == "154002")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               arr[6], arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], inp_sParam, arr[19],
                               arr[20], arr[21], arr[22], arr[23], "1", arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    //PENDING TRANSACTIONS DASHBOARD : Pre-clearances-CO
                    else if (isInsider == "PreClearancesCO" && inp_sParam == "144001")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], inp_sParam, arr[3], arr[4], arr[5],
                               arr[6], arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], arr[24], arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    else if (isInsider == "PreClearancesCO_OS" && inp_sParam == "144001")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], inp_sParam, arr[5],
                               arr[6], arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], arr[24], arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    else if (isInsider == "PreClearancesCO_OS" && inp_sParam == "154002")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               inp_sParam, arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], arr[24], arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    //Defaulter DASHBOARD : Initial, Continouse, Period End, Pre-Clearance
                    else if (inp_sParam == "170001" || inp_sParam == "170002" || inp_sParam == "170003" || inp_sParam == "170004")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               arr[6], arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], arr[24], inp_sParam, arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    //Defaulter DASHBOARD : Contra Trade
                    else if (inp_sParam == "169007")
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               arr[6], arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], arr[24], arr[25], inp_sParam, arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                    else
                    {
                        lstCRUserList = objGenericSLImpl.ListAllDataTableGrid(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(gridtype), nDisplayLength, nPage,
                               sSortCol, sSortDir, out  out_iTotalRecords, sLookUpPrefix, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5],
                               arr[6], arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19],
                               arr[20], arr[21], arr[22], arr[23], arr[24], arr[25], arr[26], arr[27], arr[28], arr[29],
                               arr[30], arr[31], arr[32],
                               arr[33], arr[34], arr[35], arr[36], arr[37], arr[38], arr[39], arr[40], arr[41], arr[42], arr[43], arr[44], arr[45], arr[46], arr[47],
                              arr[48], arr[49]
                               );
                    }
                }
                
                foreach (dynamic objUserList in lstCRUserList)
                {
                    var dictionary = new Dictionary<string, Object>();
                    foreach (KeyValuePair<string, Object> kvp in objUserList) // enumerating over it exposes the Properties and Values as a KeyValuePair
                        dictionary.Add(kvp.Key, kvp.Value);
                    lstUserList.Add(dictionary);
                    dictionary = null;
                }
                JsonResult returnJson = Json(new
                {
                    aaData = lstUserList,
                    status = true,
                    draw = Request.Form["draw"],
                    iTotalRecords = out_iTotalRecords,
                    iTotalDisplayRecords = out_iTotalRecords
                }, JsonRequestBehavior.AllowGet);
                return returnJson;
            }
            catch (Exception exp)
            {
                lstUserList = new List<Dictionary<string, Object>>();
                JsonResult returnJson = Json(new
                {
                    aaData = lstUserList,
                    status = false,
                    draw = Request.Form["draw"],
                    iTotalRecords = 0,
                    iTotalDisplayRecords = 0
                }, JsonRequestBehavior.AllowGet);
                return returnJson;

            }
            finally
            {
                lstCRUserList = null;
                lstUserList = null;
            }
        }

        // Call to initialize grid datatable.
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(String type, String btnSearch, String sSortCol,String inp_sParam7, String isInsider, int acid = 0, bool bIsPagination = true, 
            bool bIsServerSide = true, String sDom = null, bool bIsActionCol = true, string sGridTagName = "DatatableGrid",
            string sNoRecordsfoundMessage = "No matching records found", int? OverrideGridType = null, string sCallBackFunction = "", string sDisplayLength = "",
            string sPagingLengthMenu = "", string sShowProcessing = "true")
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();

            List<PopulateComboDTO> lstCategoryList = new List<PopulateComboDTO>();

            lstCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ColumnHeader,
                type, "en-US", Convert.ToString(OverrideGridType), null, null, "usr_msg_").ToList<PopulateComboDTO>());

            if (type == "114023")//Select all Applicability for EmployeeInsider 
            {
                lstCategoryList[0].Value = "<input type='checkbox' name='select_all' value='1' id='select-all' GridType='"+ type +"'>";
            }

            if (type == "114132")//Select all Applicability for EmployeeInsider OS 
            {
                lstCategoryList[0].Value = "<input type='checkbox' name='select_all' value='1' id='select-all' GridType='" + type + "'>";
            }

            if ( type == "114089")//Select all Applicability for EmployeeNonInsider 
            {
                lstCategoryList[0].Value = "<input type='checkbox'  name='select_all_EmpNonIns' value='1' id='select_all_EmpNonIns' GridType='" + type + "'>";
            }
            if (type == "114029")//Select all Applicability for EmployeeNonInsider 
            {
                lstCategoryList[0].Value = "<input type='checkbox'  name='select_all_CorpIns' value='1' id='select_all_CorpIns' GridType='" + type + "'>";
            }
            if (type == "114027")//Select all Applicability for EmployeeNonInsider 
            {
                lstCategoryList[0].Value = "<input type='checkbox'  name='select_all_NonEmpIns' value='1' id='select_all_NonEmpIns' GridType='" + type + "'>";
            }
            if (type == "114055")//Select all Applicability for CO 
            {
                lstCategoryList[0].Value = "<input type='checkbox'  name='select_all_Co' value='1' id='select_all_Co' GridType='" + type + "'>";
            }
            if (type == "508008")//Select all Applicability for CO 
            {
                lstCategoryList[0].Value = "<input type='checkbox' name='select_all' value='1' id='select-all' GridType='" + type + "'>";
            }
            if (sNoRecordsfoundMessage == "")
                sNoRecordsfoundMessage = "No matching records found";
            if (!bIsActionCol)
            {
                lstCategoryList.RemoveAll(elem => elem.Key == "usr_grd_11073");
                lstCategoryList.RemoveAll(elem => elem.Key == "usr_grd_11085");
            }

            ViewBag.inp_sParam7 = inp_sParam7;
            ViewBag.IsInsider = isInsider;
            ViewBag.type = type;
            ViewBag.btnSearch = btnSearch;
            ViewBag.column = lstCategoryList;
            ViewBag.sortCol = sSortCol;
            ViewBag.acid = acid;
            ViewBag.bIsPagination = bIsPagination;
            ViewBag.bIsServerSide = bIsServerSide;
            ViewBag.sDom = sDom;
            ViewBag.sGridTagName = sGridTagName;
            ViewBag.NoRecordsfoundMessage = sNoRecordsfoundMessage;
            ViewBag.CallBackFunction = sCallBackFunction;
            ViewBag.sDisplayLength = sDisplayLength;
            ViewBag.sPagingLengthMenu = sPagingLengthMenu;
            ViewBag.sShowProcessing = sShowProcessing;
            return View();
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
        public static bool IsNullOrEmpty<T>(T[] array) where T : class
        {
            if (array == null || array.Length == 0)
                return true;
            else
                return array.All(item => item == null);
        }
    }
}
