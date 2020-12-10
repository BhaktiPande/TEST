using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class ApplicabilityController : Controller
    {
        //
        // GET: /Applicability/
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int nApplicabilityType, int nMasterID, string CalledFrom, int acid, int? CodeTypeId = 0, int? CodeTypeToId = 0, int? ParentTradingPolicy = 0, int? nApplicabilityId = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            ApplicabilitySL objApplicabilitySl = null;
            ApplicabilityDTO objApplicabilityDTO = null;
            UserInfoModel objUserInfoModel = null;

            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> lstGradeList = null;
            List<PopulateComboDTO> lstDesignationList = null;
            List<PopulateComboDTO> lstDepartmentList = null;
            List<PopulateComboDTO> lstCategoryList = null;
            List<PopulateComboDTO> lstSubCategoryList = null;
            List<PopulateComboDTO> lstRoleList = null;

            Dictionary<string, bool[]> objSelectionElement = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objUserInfoModel = new UserInfoModel();

                objSelectionElement = new Dictionary<string, bool[]>();

                //Here according to value 0/1 for the array of sequence 
                //["Select Insider", "All Employee","All Insider","select Insider - Emp insider", "select Insider - Corporate", "select Insider - Non Emp", "select Insider - Co insider"] respectively.
                objSelectionElement["default00"] = new[] { true, true, true, true, true, true, false, true };

                objSelectionElement[ConstEnum.Code.TradingPolicy + "" + ConstEnum.Code.TradingPolicyInsiderType + "0"] = new[] { true, false, true, true, true, true, false, false };
                objSelectionElement[ConstEnum.Code.TradingPolicy + "" + ConstEnum.Code.TradingPolicyEmployeeType + "0"] = new[] { true, true, false, false, false, false, false, true };
                objSelectionElement[ConstEnum.Code.CommunicationRule + "" + ConstEnum.Code.CommunicationRuleForUserTypeCO + "" + ConstEnum.Code.CommunicationRuleEventsToApplyUserTypeCO] = new[] { true, false, false, false, false, false, true, false };
                objSelectionElement[ConstEnum.Code.CommunicationRule + "" + ConstEnum.Code.CommunicationRuleForUserTypeCO + "" + ConstEnum.Code.CommunicationRuleEventsToApplyUserTypeInsider] = new[] { true, false, false, true, true, true, true, true };
                objSelectionElement[ConstEnum.Code.CommunicationRule + "" + ConstEnum.Code.CommunicationRuleForUserTypeInsider + "" + ConstEnum.Code.CommunicationRuleEventsToApplyUserTypeInsider] = new[] { true, true, true, true, true, true, false, true };
                objSelectionElement[ConstEnum.Code.RestrictedList + "0" + "0"] = new[] { true, true, false, true, false, false, false, false };

                objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "00";
                objPopulateComboDTO.Value = "Select";

                lstGradeList = new List<PopulateComboDTO>();
                lstGradeList.Add(objPopulateComboDTO);
                lstGradeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.GradeMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.GradeDropDown = lstGradeList;

                lstDesignationList = new List<PopulateComboDTO>();
                lstDesignationList.Add(objPopulateComboDTO);
                lstDesignationList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.DesignationMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                //PopulateComboDTO objPopulateComboDesignationDTO = new PopulateComboDTO();
                //objPopulateComboDesignationDTO.Key = "-1";
                //objPopulateComboDesignationDTO.Value = "Other";
                //lstDesignationList.Add(objPopulateComboDesignationDTO);
                ViewBag.DesignationDropDown = lstDesignationList;

                lstDepartmentList = new List<PopulateComboDTO>();
                lstDepartmentList.Add(objPopulateComboDTO);
                lstDepartmentList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.DepartmentMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.DepartmentDropDown = lstDepartmentList;
                //-------------------------------------------------------------------------------
                lstCategoryList = new List<PopulateComboDTO>();
                lstCategoryList.Add(objPopulateComboDTO);
                lstCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.CategoryMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.CategoryDropDown = lstCategoryList;

                lstSubCategoryList = new List<PopulateComboDTO>();
                lstSubCategoryList.Add(objPopulateComboDTO);
                lstSubCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.SubCategoryMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.SubCategoryDropDown = lstSubCategoryList;

                lstRoleList = new List<PopulateComboDTO>();
                lstRoleList.Add(objPopulateComboDTO);
                lstRoleList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.RoleList,
                    ConstEnum.Code.EmployeeType.ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.EmployeeTypeRoleDropDown = lstRoleList;
                //-------------------------------------------------------------------------------
                ViewBag.Applicability_Search_EmployeeInsider = InsiderTrading.Common.ConstEnum.GridType.Applicability_Search_EmployeeInsider;
                ViewBag.Applicability_Association_EmployeeInsider = InsiderTrading.Common.ConstEnum.GridType.Applicability_Association_EmployeeInsider;
                ViewBag.Applicability_Search_Corporate = InsiderTrading.Common.ConstEnum.GridType.Applicability_Search_Corporate;
                ViewBag.Applicability_Association_Corporate = InsiderTrading.Common.ConstEnum.GridType.Applicability_Association_Corporate;
                ViewBag.Applicability_Search_Non_Employee = InsiderTrading.Common.ConstEnum.GridType.Applicability_Search_Non_Employee;
                ViewBag.Applicability_Association_Non_Employee = InsiderTrading.Common.ConstEnum.GridType.Applicability_Association_Non_Employee;
                ViewBag.Applicability_Filter_EmployeeInsider = InsiderTrading.Common.ConstEnum.GridType.Applicability_Filter_EmployeeInsider;
                ViewBag.Applicability_Search_COInsider = InsiderTrading.Common.ConstEnum.GridType.Applicability_Search_COInsider;
                ViewBag.Applicability_Association_COInsider = InsiderTrading.Common.ConstEnum.GridType.Applicability_Association_COInsider;
                ViewBag.Applicability_Search_Employee = InsiderTrading.Common.ConstEnum.GridType.Applicability_Search_Employee;
                ViewBag.Applicability_Filter_Employee = InsiderTrading.Common.ConstEnum.GridType.Applicability_Filter_Employee;
                ViewBag.Applicability_Association_Employee = InsiderTrading.Common.ConstEnum.GridType.Applicability_Association_Employee;


                ViewBag.ApplicabilityType = nApplicabilityType;
                ViewBag.ApplicabilityID = nMasterID;
                ViewBag.CalledFrom = CalledFrom;
                ViewBag.VisibleElement = objSelectionElement["default00"];
                ViewBag.ParentTradingPolicy = ParentTradingPolicy;
                ViewBag.ApplicabilityIDFromHistory = nApplicabilityId;

                if (objSelectionElement.ContainsKey("" + nApplicabilityType.ToString() + "" + CodeTypeId.ToString() + "" + CodeTypeToId.ToString()))
                {
                    ViewBag.VisibleElement = objSelectionElement["" + nApplicabilityType.ToString() + "" + CodeTypeId.ToString() + "" + CodeTypeToId.ToString()];
                }

                using (objApplicabilitySl = new ApplicabilitySL())
                {
                    objApplicabilityDTO = objApplicabilitySl.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(nApplicabilityType), Convert.ToInt32(nMasterID));
                }

                if (objApplicabilityDTO != null)
                {
                    ViewBag.AllEmployeeFlag = objApplicabilityDTO.AllEmployeeFlag;
                    ViewBag.AllInsiderFlag = objApplicabilityDTO.AllInsiderFlag;
                    ViewBag.AllEmployeeInsiderFlag = objApplicabilityDTO.AllEmployeeInsiderFlag;
                    ViewBag.AllCoFlag = objApplicabilityDTO.AllCo;
                    ViewBag.AllCorporateInsiderFlag = objApplicabilityDTO.AllCorporateEmployees;
                    ViewBag.AllNonEmployeeInsiderFlag = objApplicabilityDTO.AllNonEmployee;
                    ViewBag.RecordCount = objApplicabilityDTO.RecordCount;
                }

                ViewBag.UserAction = acid;
            
            }
            finally
            {
                objLoginUserDetails = null;

                objPopulateComboDTO = null;
                objApplicabilityDTO = null;

                objSelectionElement = null;
                
                lstGradeList = null;
                lstDesignationList = null;
                lstDepartmentList = null;
            }

            return View(objUserInfoModel);
        }

        public class ApplicabilityFilter
        {
            public string ApplicabilityDtlsId { get; set; }
            public string DepartmentId { get; set; }
            public string GradeId { get; set; }
            public string DesignationId { get; set; }
            public string CategoryId { get; set; }
            public string SubCategoryId { get; set; }
            public string RoleId { get; set; }
        }

        public class NonInsEmpApplicabilityFilter
        {
            public string ApplicabilityDtlsId { get; set; }
            public string DepartmentId { get; set; }
            public string GradeId { get; set; }
            public string DesignationId { get; set; }
            public string CategoryId { get; set; }
            public string SubCategoryId { get; set; }
            public string RoleId { get; set; }
        }
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult Apply(string nAllEmployeeFlag, string nAllInsiderFlag, string nAllEmployeeInsiderFlag, string nAllCoFlag, string nAllCorporateInsiderFlag, string nAllNonEmployeeInsiderFlag, string sMapToId, string sMapToTypeCodeId, string arrIncluded, string arrExcluded, string arrFilter, string arrnonInsEmpFilter, int acid, string __RequestVerificationToken="",int formId =0)
        {
            bool statusFlag = false;
            
            var ErrorDictionary = new Dictionary<string, string>();

            string[][] arrApplicabilityInclude = null;
            string[] arrApplicabilityExclude = null;
            List<ApplicabilityFilter> arrFilterList = null;
            List<NonInsEmpApplicabilityFilter> arrFilterNonInsEmpList = null;

            LoginUserDetails objLoginUserDetails = null;

            DataTable tblApplicabilityUserIncludeExclude = null;
            DataTable tblApplicabilityFilterType = null;
            DataTable tblNonInsEmpApplicabilityFilterType = null;
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

                if (arrIncluded!="")
                    arrApplicabilityInclude = JsonConvert.DeserializeObject<string[][]>(arrIncluded);

                if (arrExcluded != "")
                    arrApplicabilityExclude = JsonConvert.DeserializeObject<string[]>(arrExcluded);

                if(arrFilter!="")
                    arrFilterList = JsonConvert.DeserializeObject<List<ApplicabilityFilter>>(arrFilter);


                if (arrnonInsEmpFilter != "")
                    arrFilterNonInsEmpList = JsonConvert.DeserializeObject<List<NonInsEmpApplicabilityFilter>>(arrnonInsEmpFilter);

                tblApplicabilityUserIncludeExclude = new DataTable("ApplicabilityUserIncludeExcludeType");

                tblApplicabilityUserIncludeExclude.Columns.Add(new DataColumn("UserId", typeof(int)));
                tblApplicabilityUserIncludeExclude.Columns.Add(new DataColumn("InsiderTypeCodeId", typeof(int)));
                tblApplicabilityUserIncludeExclude.Columns.Add(new DataColumn("IncludeExcludeCodeId", typeof(int)));

                if (arrApplicabilityInclude != null)
                {
                    for (int i = 0; i < arrApplicabilityInclude.Length; i++)
                    {
                        int UserTypeCodeId = i == 0 ? ConstEnum.Code.EmployeeType : i == 1 ? ConstEnum.Code.CorporateUserType : i == 2 ? ConstEnum.Code.NonEmployeeType : i == 3 ? ConstEnum.Code.COUserType : ConstEnum.Code.EmployeeType;

                        DataRow row = null;

                        for (int j = 0; j < arrApplicabilityInclude[i].Length; j++)
                        {
                            row = tblApplicabilityUserIncludeExclude.NewRow();

                            row["UserId"] = Convert.ToInt32(arrApplicabilityInclude[i][j]);
                            row["InsiderTypeCodeId"] = UserTypeCodeId;
                            row["IncludeExcludeCodeId"] = InsiderTrading.Common.ConstEnum.Code.IncludeTypeCode;

                            tblApplicabilityUserIncludeExclude.Rows.Add(row);
                        }

                        row = null;
                    }
                }

                if (arrApplicabilityExclude != null)
                {
                    DataRow row = null;

                    for (int i = 0; i < arrApplicabilityExclude.Length; i++)
                    {
                        row = tblApplicabilityUserIncludeExclude.NewRow();

                        row["UserId"] = Convert.ToInt32(arrApplicabilityExclude[i]);
                        row["InsiderTypeCodeId"] = ConstEnum.Code.EmployeeType;
                        row["IncludeExcludeCodeId"] = InsiderTrading.Common.ConstEnum.Code.ExcludeTypeCode;

                        tblApplicabilityUserIncludeExclude.Rows.Add(row);
                    }

                    row = null;
                }

                tblApplicabilityFilterType = new DataTable("ApplicabilityFilterType");

                tblApplicabilityFilterType.Columns.Add(new DataColumn("ApplicabilityDtlsId", typeof(int)));
                tblApplicabilityFilterType.Columns.Add(new DataColumn("DepartmentCodeId", typeof(int)));
                tblApplicabilityFilterType.Columns.Add(new DataColumn("GradeCodeId", typeof(int)));
                tblApplicabilityFilterType.Columns.Add(new DataColumn("DesignationCodeId", typeof(int)));
                tblApplicabilityFilterType.Columns.Add(new DataColumn("CategoryCodeId", typeof(int)));
                tblApplicabilityFilterType.Columns.Add(new DataColumn("SubCategoryCodeId", typeof(int)));
                tblApplicabilityFilterType.Columns.Add(new DataColumn("RoleId", typeof(int)));

                tblNonInsEmpApplicabilityFilterType = new DataTable("NonInsEmpApplicabilityFilterType");

                tblNonInsEmpApplicabilityFilterType.Columns.Add(new DataColumn("ApplicabilityDtlsId", typeof(int)));
                tblNonInsEmpApplicabilityFilterType.Columns.Add(new DataColumn("DepartmentCodeId", typeof(int)));
                tblNonInsEmpApplicabilityFilterType.Columns.Add(new DataColumn("GradeCodeId", typeof(int)));
                tblNonInsEmpApplicabilityFilterType.Columns.Add(new DataColumn("DesignationCodeId", typeof(int)));
                tblNonInsEmpApplicabilityFilterType.Columns.Add(new DataColumn("CategoryCodeId", typeof(int)));
                tblNonInsEmpApplicabilityFilterType.Columns.Add(new DataColumn("SubCategoryCodeId", typeof(int)));
                tblNonInsEmpApplicabilityFilterType.Columns.Add(new DataColumn("RoleId", typeof(int)));
                if (arrFilterList != null)
                {
                    DataRow row = null;

                    foreach (var objFilter in arrFilterList)
                    {
                        row = tblApplicabilityFilterType.NewRow();

                        row["ApplicabilityDtlsId"] = 0;
                        row["DepartmentCodeId"] = DBNull.Value;
                        row["GradeCodeId"] = DBNull.Value;
                        row["DesignationCodeId"] = DBNull.Value;
                        row["CategoryCodeId"] = DBNull.Value;
                        row["SubCategoryCodeId"] = DBNull.Value;
                        row["RoleId"] = DBNull.Value;

                        if (objFilter.ApplicabilityDtlsId != "" && objFilter.ApplicabilityDtlsId != "0")
                            row["ApplicabilityDtlsId"] = Convert.ToInt32(objFilter.ApplicabilityDtlsId);

                        if (objFilter.DepartmentId != "" && objFilter.DepartmentId != "0")
                            row["DepartmentCodeId"] = Convert.ToInt32(objFilter.DepartmentId);

                        if (objFilter.GradeId != "" && objFilter.GradeId != "0")
                            row["GradeCodeId"] = Convert.ToInt32(objFilter.GradeId);

                        if (objFilter.DesignationId != "" && objFilter.DesignationId != "0")
                            row["DesignationCodeId"] = Convert.ToInt32(objFilter.DesignationId);

                        if (objFilter.CategoryId != "" && objFilter.CategoryId != "0")
                            row["CategoryCodeId"] = Convert.ToInt32(objFilter.CategoryId);

                        if (objFilter.SubCategoryId != "" && objFilter.SubCategoryId != "0")
                            row["SubCategoryCodeId"] = Convert.ToInt32(objFilter.SubCategoryId);

                        if (objFilter.RoleId != "" && objFilter.RoleId != "0")
                            row["RoleId"] = Convert.ToInt32(objFilter.RoleId);

                        if (row["DesignationCodeId"] != DBNull.Value || row["GradeCodeId"] != DBNull.Value || row["DepartmentCodeId"] != DBNull.Value || row["CategoryCodeId"] != DBNull.Value || row["SubCategoryCodeId"] != DBNull.Value || row["RoleId"] != DBNull.Value)
                            tblApplicabilityFilterType.Rows.Add(row);
                    }

                    row = null;
                }
                if (arrFilterNonInsEmpList != null)
                {
                    DataRow row = null;

                    foreach (var objFilter in arrFilterNonInsEmpList)
                    {
                        row = tblNonInsEmpApplicabilityFilterType.NewRow();

                        row["ApplicabilityDtlsId"] = 0;
                        row["DepartmentCodeId"] = DBNull.Value;
                        row["GradeCodeId"] = DBNull.Value;
                        row["DesignationCodeId"] = DBNull.Value;
                        row["CategoryCodeId"] = DBNull.Value;
                        row["SubCategoryCodeId"] = DBNull.Value;
                        row["RoleId"] = DBNull.Value;

                        if (objFilter.ApplicabilityDtlsId != "" && objFilter.ApplicabilityDtlsId != "0")
                            row["ApplicabilityDtlsId"] = Convert.ToInt32(objFilter.ApplicabilityDtlsId);

                        if (objFilter.DepartmentId != "" && objFilter.DepartmentId != "0")
                            row["DepartmentCodeId"] = Convert.ToInt32(objFilter.DepartmentId);

                        if (objFilter.GradeId != "" && objFilter.GradeId != "0")
                            row["GradeCodeId"] = Convert.ToInt32(objFilter.GradeId);

                        if (objFilter.DesignationId != "" && objFilter.DesignationId != "0")
                            row["DesignationCodeId"] = Convert.ToInt32(objFilter.DesignationId);

                        if (objFilter.CategoryId != "" && objFilter.CategoryId != "0")
                            row["CategoryCodeId"] = Convert.ToInt32(objFilter.CategoryId);

                        if (objFilter.SubCategoryId != "" && objFilter.SubCategoryId != "0")
                            row["SubCategoryCodeId"] = Convert.ToInt32(objFilter.SubCategoryId);

                        if (objFilter.RoleId != "" && objFilter.RoleId != "0")
                            row["RoleId"] = Convert.ToInt32(objFilter.RoleId);

                        if (row["DesignationCodeId"] != DBNull.Value || row["GradeCodeId"] != DBNull.Value || row["DepartmentCodeId"] != DBNull.Value || row["CategoryCodeId"] != DBNull.Value || row["SubCategoryCodeId"] != DBNull.Value || row["RoleId"] != DBNull.Value)
                            tblNonInsEmpApplicabilityFilterType.Rows.Add(row);
                    }

                    row = null;
                }
                using (ApplicabilitySL objApplicabilitySl = new ApplicabilitySL())
                {
                    int nCountOverlapPolicy = 0;

                    objApplicabilitySl.InsertDeleteApplicability(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(sMapToTypeCodeId), Convert.ToInt32(sMapToId), Convert.ToInt32(nAllEmployeeFlag), Convert.ToInt32(nAllInsiderFlag), Convert.ToInt32(nAllEmployeeInsiderFlag), Convert.ToInt32(nAllCoFlag), Convert.ToInt32(nAllCorporateInsiderFlag), Convert.ToInt32(nAllNonEmployeeInsiderFlag), tblApplicabilityFilterType, tblNonInsEmpApplicabilityFilterType, tblApplicabilityUserIncludeExclude, objLoginUserDetails.LoggedInUserID, out nCountOverlapPolicy);

                    statusFlag = true;

                    ErrorDictionary.Add("success", "Applicability saved successfully.");
                    ErrorDictionary.Add("CountOverlapPolicy", Convert.ToString(nCountOverlapPolicy));
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

                arrApplicabilityInclude = null;
                arrApplicabilityExclude = null;
                arrFilterList = null;

                tblApplicabilityUserIncludeExclude = null;
                tblApplicabilityFilterType = null;
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

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }

        ////
        //// GET: /Applicability/Details/5
        //[AuthorizationPrivilegeFilter]
        //public ActionResult Details(int id, int acid)
        //{
        //    return View();
        //}

        ////
        //// GET: /Applicability/Create
        //[AuthorizationPrivilegeFilter]
        //public ActionResult Create(int acid)
        //{
        //    return View();
        //}

        ////
        //// POST: /Applicability/Create
        //[HttpPost]
        //[AuthorizationPrivilegeFilter]
        //public ActionResult Create(FormCollection collection, int acid)
        //{
        //    try
        //    {
        //        // TODO: Add insert logic here

        //        return RedirectToAction("Index");
        //    }
        //    catch
        //    {
        //        return View();
        //    }
        //}

        ////
        //// GET: /Applicability/Edit/5
        //[AuthorizationPrivilegeFilter]
        //public ActionResult Edit(int id)
        //{
        //    return View();
        //}

        ////
        //// POST: /Applicability/Edit/5
        //[HttpPost]
        //[AuthorizationPrivilegeFilter]
        //public ActionResult Edit(int id, FormCollection collection)
        //{
        //    try
        //    {
        //        // TODO: Add update logic here

        //        return RedirectToAction("Index");
        //    }
        //    catch
        //    {
        //        return View();
        //    }
        //}

        ////
        //// GET: /Applicability/Delete/5
        //[AuthorizationPrivilegeFilter]
        //public ActionResult Delete(int id)
        //{
        //    return View();
        //}

        ////
        //// POST: /Applicability/Delete/5
        //[HttpPost]
        //[AuthorizationPrivilegeFilter]
        //public ActionResult Delete(int id, FormCollection collection)
        //{
        //    try
        //    {
        //        // TODO: Add delete logic here

        //        return RedirectToAction("Index");
        //    }
        //    catch
        //    {
        //        return View();
        //    }
        //}
    }
}
