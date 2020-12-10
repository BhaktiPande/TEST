using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
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
    public class EmployeeInsiderController : Controller
    {
        #region Create
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ActionResult Create(int nUserInfoID = 0)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            EmployeeModel objEmployeeModel = new EmployeeModel();
            UserInfoModel objUserInfoModel = new UserInfoModel();
            DMATDetailsModel objDMATDetailsModel = new DMATDetailsModel();
            DocumentDetailsModel objDocumentDetailsModel = new DocumentDetailsModel();
            UserInfoSL objUserInfoSL = new UserInfoSL();

            try
            {
                if (nUserInfoID != 0)
                {
                    UserInfoDTO objUserInfoDTO = new UserInfoDTO();
                    objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, nUserInfoID);
                    string sPwdMask = "●●●●●●●●●●●●●";
                    objUserInfoDTO.Password = sPwdMask.PadRight(15, '●');
                    Common.Common.CopyObjectPropertyByName(objUserInfoDTO, objUserInfoModel);
                    objDMATDetailsModel.UserInfoID = nUserInfoID;
                }

                objEmployeeModel.userInfoModel = objUserInfoModel;
                objEmployeeModel.dmatDetailsModel = objDMATDetailsModel;
                objEmployeeModel.documentDetailsModel = objDocumentDetailsModel;
                PopulateCombo();
                return View("Create",objEmployeeModel);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Create", objEmployeeModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objEmployeeModel = null;
                objUserInfoModel = null;
                objDMATDetailsModel = null;
                objDocumentDetailsModel = null;
                objUserInfoSL = null;
            }
           

        }
        #endregion Create

        #region Create
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(UserInfoModel objUserInfoModel, string OldPassword)
        {
            int nUserInfoID = 0;
            string Password = null;
            UserInfoSL objUserInfoSL = new UserInfoSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            UserInfoDTO objUserInfoDTO = new UserInfoDTO();
            try
            {
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objUserInfoModel, objUserInfoDTO);
                objUserInfoDTO.UserTypeCodeId = ConstEnum.Code.EmployeeType;
                objUserInfoDTO.IsInsider = ConstEnum.UserType.Insider;
                objUserInfoDTO.StatusCodeId = Common.Common.ConvertToInt32(ConstEnum.UserStatus.Active);
                objUserInfoDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                Common.Common.encryptData(objUserInfoModel.Password, out Password);
                if (!Password.Equals(OldPassword))
                {
                    objUserInfoDTO.Password = Password;
                }
                else
                {
                    objUserInfoDTO.Password = OldPassword;
                }
                if (objUserInfoDTO.StateId == 0)
                    objUserInfoDTO.StateId = null;
                if (objUserInfoDTO.CountryId == 0)
                    objUserInfoDTO.CountryId = null;
                if (objUserInfoDTO.Category == 0)
                    objUserInfoDTO.Category = null;
                if (objUserInfoDTO.SubCategory == 0)
                    objUserInfoDTO.SubCategory = null;
                if (objUserInfoDTO.GradeId == 0)
                    objUserInfoDTO.GradeId = null;
                if (objUserInfoDTO.DesignationId == 0)
                    objUserInfoDTO.DesignationId = null;
                if (objUserInfoDTO.DepartmentId == 0)
                    objUserInfoDTO.DepartmentId = null;
                objUserInfoDTO = objUserInfoSL.InsertUpdateUserDetails(objLoginUserDetails.CompanyDBConnectionString, objUserInfoDTO);
                if (objUserInfoDTO.UserInfoId != 0)
                {
                    nUserInfoID = objUserInfoDTO.UserInfoId;
                }
            }
            catch (Exception exp)
            {
                PopulateCombo();
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Create", objUserInfoModel);
            }
            finally
            {
                objUserInfoSL = null;
                objLoginUserDetails = null;
                objUserInfoDTO = null;
            }
            return RedirectToAction("Create", new { nUserInfoID = nUserInfoID });
        }
        #endregion Create

        private void PopulateCombo()
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "Select";

            List<PopulateComboDTO> lstCompanyList = new List<PopulateComboDTO>();
            lstCompanyList.Add(objPopulateComboDTO);
            lstCompanyList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CompanyList,
                null, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.CompanyDropdown = lstCompanyList;

            List<PopulateComboDTO> lstStateList = new List<PopulateComboDTO>();
            lstStateList.Add(objPopulateComboDTO);
            lstStateList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.StateMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.StateDropDown = lstStateList;

            List<PopulateComboDTO> lstCountryList = new List<PopulateComboDTO>();
            lstCountryList.Add(objPopulateComboDTO);
            lstCountryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.CountryMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.CountryDropDown = lstCountryList;

            List<PopulateComboDTO> lstCategoryList = new List<PopulateComboDTO>();
            lstCategoryList.Add(objPopulateComboDTO);
            lstCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.CategoryMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.CategoryDropDown = lstCategoryList;

            List<PopulateComboDTO> lstSubCategoryList = new List<PopulateComboDTO>();
            lstSubCategoryList.Add(objPopulateComboDTO);
            lstSubCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.SubCategoryMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.SubCategoryDropDown = lstSubCategoryList;

            List<PopulateComboDTO> lstGradeList = new List<PopulateComboDTO>();
            lstGradeList.Add(objPopulateComboDTO);
            lstGradeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.GradeMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.GradeDropDown = lstGradeList;

            List<PopulateComboDTO> lstDesignationList = new List<PopulateComboDTO>();
            lstDesignationList.Add(objPopulateComboDTO);
            lstDesignationList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.DesignationMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.DesignationDropDown = lstDesignationList;

            List<PopulateComboDTO> lstDepartmentList = new List<PopulateComboDTO>();
            lstDepartmentList.Add(objPopulateComboDTO);
            lstDepartmentList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.DepartmentMaster).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.DepartmentDropDown = lstDepartmentList;
        }

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