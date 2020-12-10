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
using InsiderTrading.Filters;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class TradingWindowEventController : Controller
    {
        #region Index
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int FinancialYearId, int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            ComCodeSL objComCodeModel = new ComCodeSL();
            ComCodeDTO objComCodeDTO = new ComCodeDTO();
            DateTime objCurrentDateTime = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
            try
            {
                string sFinancialYear;
                objCurrentDateTime = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.FinancialYear).ToString(), null, null, null, null, true);
                ViewBag.FinancialYear = lstList;
                //for showing default current financial year on Trading Window Financial year page.
                sFinancialYear = Convert.ToString(objCurrentDateTime.Year);
                sFinancialYear = sFinancialYear + "-" + (Convert.ToInt32(sFinancialYear.Substring(2, 2)) + 1);                
                if (FinancialYearId == 0)
                {
                    foreach (var element in lstList)
                    {
                        if (element.Value == sFinancialYear)
                        {

                            ViewBag.FinancialYearId = element.Key;
                            FinancialYearId = Convert.ToInt32(element.Key);
                            break;
                        }
                    }                  
                }
                else
                {
                    ViewBag.FinancialYearId = FinancialYearId;
                }
                objComCodeDTO = objComCodeModel.GetDetails(objLoginUserDetails.CompanyDBConnectionString, FinancialYearId);
                ViewBag.FinancialPeriodTypeId = (objComCodeDTO.ParentCodeId == null ? 0 : Convert.ToInt32(objComCodeDTO.ParentCodeId));
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.FinancialPeriodType).ToString(), null, null, null, null, true);
                ViewBag.FinancialPeriodType = lstList;
                ViewBag.acid = acid;
                FillGrid(ConstEnum.GridType.TradingWindowEventListForFinancialPeriod, Convert.ToString(FinancialYearId), null, null);
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
                return View("View");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("View");
            }
            finally
            {
                objLoginUserDetails = null;
                lstList = null;
                objComCodeModel = null;
                objComCodeDTO = null;
            }

        }
        #endregion Index

        #region DropdownIndex
        [HttpPost]
        public JsonResult dropdownIndex(int FinancialYearId, int FinancialPeriodTypeId, int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            ComCodeSL objComCodeModel = new ComCodeSL();
            ComCodeDTO objComCodeDTO = new ComCodeDTO();
            Common.Common objCommon = new Common.Common();

            if (!objCommon.ValidateCSRFForAJAX())
            {
                return Json(new
                {
                    status = false,
                    Message = ""
                }, JsonRequestBehavior.AllowGet);
            }
            ViewBag.FinancialYearId = FinancialYearId;
            if (FinancialYearId != 0)
            {
                objComCodeDTO = objComCodeModel.GetDetails(objLoginUserDetails.CompanyDBConnectionString, FinancialYearId);
                FinancialPeriodTypeId = (objComCodeDTO.ParentCodeId == null ? 0 : Convert.ToInt32(objComCodeDTO.ParentCodeId));
            }
            return Json(new
            {
                status = true,
                FinancialPeriodTypeId = FinancialPeriodTypeId,
                Message = "Contact Successfully Submitted"

            }, JsonRequestBehavior.AllowGet);
            //return RedirectToAction("Index", "TradingWindowEvent", new { FinancialYearId = FinancialYearId, acid = acid });
        }
        #endregion DropdownIndex

        #region Create
        [HttpPost]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public JsonResult Create(List<TradingWindowEventModel> tradingWindowEventModel, int nFinancialYearCodeId, int nFinancialPeriodTypeCodeId, int acid, string __RequestVerificationToken, int formId)
        //public JsonResult Create(List<TradingWindowEventModel> tradingWindowEventModel, int nFinancialYearCodeId, int nFinancialPeriodTypeCodeId, int acid)
        {
            bool bReturn = true;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            TradingWindowEventSL objTradingWindowEventSL = new TradingWindowEventSL();
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return Json(new
                    {
                        status = false,
                        error = ""
                    }, JsonRequestBehavior.AllowGet);
                }
                #region Create Data Table tblTradingWindowEventType
                DataTable tblTradingWindowEventType = new DataTable("TradingWindowEventType");
                tblTradingWindowEventType.Columns.Add(new DataColumn("TradingWindowEventId", typeof(int)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("FinancialYearCodeId", typeof(int)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("FinancialPeriodCodeId", typeof(int)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("TradingWindowId", typeof(string)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("EventTypeCodeId", typeof(int)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("TradingWindowEventCodeId", typeof(int)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("ResultDeclarationDate", typeof(DateTime)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("WindowCloseDate", typeof(DateTime)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("WindowOpenDate", typeof(DateTime)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("DaysPriorToResultDeclaration", typeof(int)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("DaysPostResultDeclaration", typeof(int)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("WindowClosesBeforeHours", typeof(int)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("WindowClosesBeforeMinutes", typeof(int)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("WindowOpensAfterHours", typeof(int)));
                tblTradingWindowEventType.Columns.Add(new DataColumn("WindowOpensAfterMinutes", typeof(int)));
                #endregion Create Data Table tblTradingWindowEventType
                ModelState.Clear();
                foreach (var index in tradingWindowEventModel)
                {
                    DataRow row = tblTradingWindowEventType.NewRow();
                    DateTime now = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                    if (index.TradingWindowEventId != null)
                    {
                        row["TradingWindowEventId"] = index.TradingWindowEventId;
                    }

                    row["FinancialYearCodeId"] = nFinancialYearCodeId;

                    if (index.FinancialPeriodCodeId != null)
                    {
                        row["FinancialPeriodCodeId"] = index.FinancialPeriodCodeId;
                    }
                    if (index.TradingWindowId != null)
                    {
                        row["TradingWindowId"] = index.TradingWindowId;
                    }
                    if (index.ResultDeclarationDate != null)
                    {
                        row["ResultDeclarationDate"] = index.ResultDeclarationDate;
                    }
                    else
                    {
                        ModelState.AddModelError("ResultDeclarationDate", "Enter Result Declaration Date");//InsiderTrading.Common.Common.getResource("rul_msg_15083"));
                        bReturn = false;
                    }
                    if (index.WindowOpenDate != null)
                    {
                        row["WindowOpenDate"] = index.WindowOpenDate;
                    }
                    if (index.WindowCloseDate != null)
                    {
                        row["WindowCloseDate"] = index.WindowCloseDate;
                    }
                    if (index.DaysPriorToResultDeclaration != null)
                    {                        
                        row["DaysPriorToResultDeclaration"] = index.DaysPriorToResultDeclaration;
                    }
                    else
                    {
                        ModelState.AddModelError("DaysPriorToResultDeclaration", "Enter Days Prior To Result Declaration");//InsiderTrading.Common.Common.getResource("rul_msg_15083"));
                        bReturn = false;
                    }
                    if (index.DaysPostResultDeclaration != null)
                    {
                        row["DaysPostResultDeclaration"] = index.DaysPostResultDeclaration;
                    }
                    else
                    {
                        ModelState.AddModelError("DaysPriorToResultDeclaration", "Enter DaysPostResultDeclaration");//InsiderTrading.Common.Common.getResource("rul_msg_15083"));
                        bReturn = false;
                    }
                    if (!bReturn)
                    {
                        break;
                    }
                    tblTradingWindowEventType.Rows.Add(row);
                }
                if (!bReturn && !ModelState.IsValid)
                {
                    return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
                }
                bReturn = objTradingWindowEventSL.SaveDetails(objLoginUserDetails.CompanyDBConnectionString, tblTradingWindowEventType,nFinancialPeriodTypeCodeId, objLoginUserDetails.LoggedInUserID);
                // TODO: Add insert logic here
                return Json(new
                {
                    status = true,
                    Message = Common.Common.getResource("rul_msg_15380")//"Data saved successfully."

                }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
            }
            finally
            {
                objLoginUserDetails = null;
                objTradingWindowEventSL = null;
            }
        }
        #endregion Create

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
                    i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, "rul_msg_").ToList<PopulateComboDTO>());
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
