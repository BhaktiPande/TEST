using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.SessionState;
using System.Web.UI;
using InsiderTradingEncryption;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class CompanyController : Controller
    {

        #region Index Open Comapny master list Page
        //
        // GET: /Company/
         [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            #region Variable declaration
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            #endregion  Variable declaration

            #region try
            try
            {
                FillGrid(ConstEnum.GridType.Companyist, null, null, null);
                return View("Index");
            }
            #endregion try

            #region catch
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index");
            }
            #endregion Catch

            #region finally
            finally
            {
                objLoginUserDetails = null;
            }
            #endregion finally

        }
        #endregion Index Open Comapny master list Page

        #region Create Tab Section
         [AuthorizationPrivilegeFilter]
        public ActionResult Create(int CompanyId,int acid)
         {
            #region Variable Declaration
            CompaniesSL objCompaniesSL = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompanyModel objCompanyModel = new CompanyModel();
            #endregion Variable Declaration

            #region try 
            try
            {
                ViewBag.UserAction = acid;
                if (CompanyId > 0)
                {
                    objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, CompanyId, 0);
                    Common.Common.CopyObjectPropertyByName(objImplementedCompanyDTO, objCompanyModel);
                    ViewBag.CompanyId = CompanyId;
                   
                    if (objImplementedCompanyDTO != null)
                    {
                        if (objImplementedCompanyDTO.IsImplementing)
                        {
                            ViewBag.CalledFrom = "Edit";
                            return View("Create", objCompanyModel);
                        }
                        else
                        {
                            return View("CompanyInfo", objCompanyModel);
                        }
                    }
                    else
                    {
                        return View("Index", "Company");
                    }
                }
                else
                {
                    return View("CompanyInfo");
                }

            }
            #endregion try

            #region catch
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index", "Company");
            }
            #endregion catch

            #region finally
            finally
            {
                objCompaniesSL = null;
                objImplementedCompanyDTO = null;
                objLoginUserDetails = null;
                objCompanyModel = null;
            }
            #endregion finally

         }
        #endregion Create Tab Section

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
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion FillComboValues



        #region View Tab Section
        [AuthorizationPrivilegeFilter]
        public ActionResult View(int CompanyId, int acid)
        {
            #region Variable Declaration
            CompaniesSL objCompaniesSL = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompanyModel objCompanyModel = new CompanyModel();
            #endregion Variable Declarartion

            #region try
            try
            {
                if (CompanyId > 0)
                {
                    objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, CompanyId, 0);
                    Common.Common.CopyObjectPropertyByName(objImplementedCompanyDTO, objCompanyModel);
                    ViewBag.CompanyId = CompanyId;
                    if (objImplementedCompanyDTO != null)
                    {
                        if (objImplementedCompanyDTO.IsImplementing)
                        {
                            ViewBag.CalledFrom = "View";
                            return View("Create", objCompanyModel);
                        }
                        else
                        {
                            return View("ViewCompanyInfo", objCompanyModel);
                        }
                    }
                    else
                    {
                        return View("Index", "Company");
                    }
                }
                else
                {
                    return View("CompanyInfo");
                }

            }
            #endregion try

            #region catch
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index", "Company");
            }
            #endregion catch

            #region finally
            finally
            {
                objCompaniesSL = null;
                objImplementedCompanyDTO = null;
                objLoginUserDetails = null;
                objCompanyModel = null;
            }
            #endregion finally

        }
        #endregion Create Tab Section

        #region Company Basic Info all actions
       
        #region SaveImplementingCompanyBasinInfo
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveImplementingCompanyBasinInfo(CompanyModel objCompanyModel, int acid)
        {
            ViewBag.CalledFrom = "Edit";
            CompaniesSL objCompaniesSL = new CompaniesSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            InsiderTradingDAL.ImplementedCompanyDTO objImplementedCompanyDTO = new InsiderTradingDAL.ImplementedCompanyDTO();
            try
            {
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objCompanyModel, objImplementedCompanyDTO);
                objImplementedCompanyDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;

                using (DataSecurity ds = new DataSecurity())
                {
                    objImplementedCompanyDTO.SmtpPassword = ds.EncryptData(objImplementedCompanyDTO.SmtpPassword);
                }

                bool bReturn = objCompaniesSL.SaveDetails(objLoginUserDetails.CompanyDBConnectionString, objImplementedCompanyDTO);
                ViewBag.Success = "Success";
                return PartialView("CompanyInfo", objCompanyModel);//.Success("Company Name : - "+objCompanyModel.CompanyName + " Save Successfully");

            }
            catch (Exception exp)
            {
                ViewBag.Success = "Error";
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.UserAction = acid;
                return PartialView("CompanyInfo", objCompanyModel);
            }
            finally
            {
                objCompaniesSL = null;
                objLoginUserDetails = null;
                objImplementedCompanyDTO = null;
            }
        }
        #endregion SaveImplementingCompanyBasinInfo

        #region Save Company Details
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [Button(ButtonName = "SaveCompany")]
        [ActionName("SaveCompany")]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveCompany(CompanyModel objCompanyModel, int UserAction,int acid)
        {
            CompaniesSL objCompaniesSL = new CompaniesSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            InsiderTradingDAL.ImplementedCompanyDTO objImplementedCompanyDTO = new InsiderTradingDAL.ImplementedCompanyDTO();
            try
            {
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objCompanyModel, objImplementedCompanyDTO);
                objImplementedCompanyDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                objImplementedCompanyDTO.ISINNumber = null;
                bool bReturn = objCompaniesSL.SaveDetails(objLoginUserDetails.CompanyDBConnectionString, objImplementedCompanyDTO);
                ArrayList lst = new ArrayList();
                lst.Add(objCompanyModel.CompanyName.Replace("'", "\'").Replace("\"", "\""));
                string AlertMessage = Common.Common.getResource("cmp_msg_13107", lst);
                return RedirectToAction("Index", "Company", new { acid = InsiderTrading.Common.ConstEnum.UserActions.COMPANY_VIEW }).
                Success(HttpUtility.UrlEncode(AlertMessage));
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                if (ModelState.ContainsKey("ISINNumber"))
                    ModelState["ISINNumber"].Errors.Clear();
                if (ModelState.ContainsKey("IsImplementing"))
                    ModelState["IsImplementing"].Errors.Clear();
                ViewBag.UserAction = UserAction;
                return View("CompanyInfo", objCompanyModel);
            }
            finally
            {
                objCompaniesSL = null;
                objLoginUserDetails = null;
                objImplementedCompanyDTO = null;
            }
        }
        #endregion Save Company Details

        #region Cancel Button Action
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Cancel")]
        [ActionName("SaveCompany")]
        public ActionResult Cancel()
        {
            return RedirectToAction("Index", "Company", new { acid = InsiderTrading.Common.ConstEnum.UserActions.COMPANY_VIEW });

        }
        #endregion Cancel Button Action

        #region DeleteFromGrid
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult DeleteFromGrid(int CompanyId, int acid)
        {
            CompaniesSL objCompaniesSL = new CompaniesSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            InsiderTradingDAL.ImplementedCompanyDTO objImplementedCompanyDTO = new InsiderTradingDAL.ImplementedCompanyDTO();
            try
            {
                objImplementedCompanyDTO.CompanyId = CompanyId;
                objImplementedCompanyDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, CompanyId, 0);
                if (objImplementedCompanyDTO.IsImplementing)
                {
                    return RedirectToAction("Index", "Company", new { acid = InsiderTrading.Common.ConstEnum.UserActions.COMPANY_VIEW }).
                   Success(Common.Common.getResource("cmp_msg_13122"));
                }
                else
                {
                    objCompaniesSL.Delete(objLoginUserDetails.CompanyDBConnectionString, objImplementedCompanyDTO);
                }
                ArrayList lst = new ArrayList();
                lst.Add(objImplementedCompanyDTO.CompanyName.Replace("'", "\'").Replace("\"", "\"") + " ");
                string AlertMessage = Common.Common.getResource("cmp_msg_13108", lst);

                return RedirectToAction("Index", "Company", new { acid = InsiderTrading.Common.ConstEnum.UserActions.COMPANY_VIEW }).
                    Success(AlertMessage.Replace("+", "%20"));
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                if (sErrMessage == "")
                {
                    ModelState.AddModelError("Error", exp.InnerException.Data[2].ToString());
                }
                else
                {
                    ModelState.AddModelError("Error", sErrMessage);
                }
                FillGrid(ConstEnum.GridType.Companyist, null, null, null);
                ViewBag.UserAction = acid;
                return View("Index");
            }
            finally
            {
                objCompaniesSL = null;
                objLoginUserDetails = null;
                objImplementedCompanyDTO = null;
            }
        }
        #endregion DeleteFromGrid

        #endregion Company Basic Info all actions

        #region Face Value all actions

        #region Save Company Face Value Details
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveCompanyFaceValue(CompanyFaceValueModel objCompanyFaceValueModel, int acid)
        {
            CompanyFaceValueModel obj = new CompanyFaceValueModel();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
            InsiderTradingDAL.CompanyFaceValueDTO objCompanyFaceValueDTO = new InsiderTradingDAL.CompanyFaceValueDTO();
            ViewBag.CalledFrom = "Edit";
            try
            {
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objCompanyFaceValueModel, objCompanyFaceValueDTO);
                objCompanyFaceValueDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                objCompaniesSL.SaveCompanyFaceValueDetails(objLoginUserDetails.CompanyDBConnectionString, objCompanyFaceValueDTO);
                ViewBag.CurrencyDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CurrencyMaster).ToString(), null, null, null, null);
                FillGrid(ConstEnum.GridType.CompanyFaceValueList, objCompanyFaceValueModel.CompanyID.ToString(), null, null);
                ModelState.Clear();
                obj.CompanyID = objCompanyFaceValueModel.CompanyID;
                ViewBag.CompanyID = objCompanyFaceValueModel.CompanyID;
                return PartialView("FaceValue", obj);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.CurrencyDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CurrencyMaster).ToString(), null, null, null, null);
                FillGrid(ConstEnum.GridType.CompanyFaceValueList, objCompanyFaceValueModel.CompanyID.ToString(), null, null);
                return PartialView("FaceValue", objCompanyFaceValueModel);
            }
            finally
            {
                obj = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
                objCompanyFaceValueDTO = null;
            }
        }


        #endregion Save Company Face Value Details

        #region EditCompanyFaceValueDetails
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        public ActionResult EditCompanyFaceValueDetails(int CompanyFaceValueID, int acid)
        {
            CompanyFaceValueModel objCompanyFaceValueModel = new CompanyFaceValueModel();
            ViewBag.CalledFrom = "Edit";
            CompanyFaceValueDTO objCompanyFaceValueDTO = new CompanyFaceValueDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                if (CompanyFaceValueID > 0)
                {
                    ViewBag.CurrencyDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CurrencyMaster).ToString(), null, null, null, null);
                    objCompanyFaceValueDTO = objCompaniesSL.GetCompanyFaceValueDetails(objLoginUserDetails.CompanyDBConnectionString, CompanyFaceValueID);
                    Common.Common.CopyObjectPropertyByName(objCompanyFaceValueDTO, objCompanyFaceValueModel);
                    FillGrid(ConstEnum.GridType.CompanyFaceValueList, objCompanyFaceValueModel.CompanyID.ToString(), null, null);

                }
                return PartialView("FaceValue", objCompanyFaceValueModel);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.CurrencyDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CurrencyMaster).ToString(), null, null, null, null);
                FillGrid(ConstEnum.GridType.CompanyFaceValueList, objCompanyFaceValueModel.CompanyID.ToString(), null, null);
                return PartialView("FaceValue", objCompanyFaceValueModel);
            }
            finally
            {
                objCompanyFaceValueModel = null;
                objCompanyFaceValueDTO = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
            }
        }
        #endregion EditCompanyFaceValueDetails

        #region DeleteCompanyFaceValueDetails
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteCompanyFaceValueDetails(int CompanyFaceValueID, int CompanyId, int acid)
        {
            CompanyFaceValueModel objCompanyFaceValueModel = new CompanyFaceValueModel();
            CompanyFaceValueModel obj = new CompanyFaceValueModel();
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            ViewBag.CalledFrom = "Edit";
            CompanyFaceValueDTO objCompanyFaceValueDTO = new CompanyFaceValueDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
            try
            {
                if (CompanyFaceValueID > 0)
                {
                    objCompanyFaceValueDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    objCompanyFaceValueDTO.CompanyFaceValueID = CompanyFaceValueID;
                    objCompaniesSL.DeleteCompanyFaceValueDetails(objLoginUserDetails.CompanyDBConnectionString, objCompanyFaceValueDTO);
                    ViewBag.CurrencyDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CurrencyMaster).ToString(), null, null, null, null);
                    ModelState.Clear();
                    FillGrid(ConstEnum.GridType.CompanyFaceValueList, CompanyId.ToString(), null, null);
                    obj.CompanyID = CompanyId;
                    obj.CompanyFaceValueID = 0;
                }
                statusFlag = true;
                ErrorDictionary.Add("success", InsiderTrading.Common.Common.getResource("cmp_msg_13111"));
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
                objCompanyFaceValueModel = null;
                obj = null;
                objCompanyFaceValueDTO = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);

        }
        #endregion DeleteCompanyFaceValueDetails

        #endregion Face Value all actions

        #region Authorised Shares all actions

        #region Save Authorised Shares
        [HttpPost]
        [TokenVerification]
        [ValidateAntiForgeryToken]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveAuthorizedShareCapital(CompanyAuthorizedShareCapitalModel objCompanyAuthorizedShareCapitalModel, int acid)
        {
            ViewBag.CalledFrom = "Edit";
            CompaniesSL objCompaniesSL = new CompaniesSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            InsiderTradingDAL.CompanyAuthorizedShareCapitalDTO objCompanyAuthorizedShareCapitalDTO = new InsiderTradingDAL.CompanyAuthorizedShareCapitalDTO();
            try
            {
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objCompanyAuthorizedShareCapitalModel, objCompanyAuthorizedShareCapitalDTO);
                objCompanyAuthorizedShareCapitalDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                objCompaniesSL.SaveAuthorisedSharesDetails(objLoginUserDetails.CompanyDBConnectionString, objCompanyAuthorizedShareCapitalDTO);
                //Fill Grid
                FillGrid(ConstEnum.GridType.CompanyAuthorisedSharedCapitalList, objCompanyAuthorizedShareCapitalModel.CompanyID.ToString(), null, null);
                ModelState.Clear();
                CompanyAuthorizedShareCapitalModel obj = new CompanyAuthorizedShareCapitalModel();
                obj.CompanyID = objCompanyAuthorizedShareCapitalModel.CompanyID;
                ViewBag.CompanyID = objCompanyAuthorizedShareCapitalModel.CompanyID;
                return PartialView("AuthorizedShare", obj);

            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return PartialView("AuthorizedShare", objCompanyAuthorizedShareCapitalModel);
            }
            finally
            {
                objCompaniesSL = null;
                objLoginUserDetails = null;
                objCompanyAuthorizedShareCapitalDTO = null;

            }
        }
        #endregion Save Authorised Shares

        #region EditAuthorisedSharesDetails
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        public ActionResult EditAuthorisedSharesDetails(int CompanyAuthorizedShareCapitalID, int acid)
        {
            CompanyAuthorizedShareCapitalModel objCompanyAuthorizedShareCapitalModel = new CompanyAuthorizedShareCapitalModel();
            ViewBag.CalledFrom = "Edit";
            CompanyAuthorizedShareCapitalDTO objCompanyAuthorizedShareCapitalDTO = null;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                if (CompanyAuthorizedShareCapitalID > 0)
                {
                    objCompanyAuthorizedShareCapitalDTO = objCompaniesSL.GetAuthorisedShareCapitalDetails(objLoginUserDetails.CompanyDBConnectionString, CompanyAuthorizedShareCapitalID);
                    Common.Common.CopyObjectPropertyByName(objCompanyAuthorizedShareCapitalDTO, objCompanyAuthorizedShareCapitalModel);
                    FillGrid(ConstEnum.GridType.CompanyAuthorisedSharedCapitalList, objCompanyAuthorizedShareCapitalModel.CompanyID.ToString(), null, null);
                }
                return new JsonResult { Data = this.RenderRazorViewToString("AuthorizedShare", objCompanyAuthorizedShareCapitalModel) };
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return PartialView("AuthorizedShare", objCompanyAuthorizedShareCapitalModel);
            }
            finally
            {
                objCompanyAuthorizedShareCapitalModel = null;
                objCompanyAuthorizedShareCapitalDTO = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
            }
        }
        #endregion EditAuthorisedSharesDetails

        #region DeleteCompanyAuthorisedSharesDetails
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteCompanyAuthorisedSharesDetails(int CompanyAuthorizedShareCapitalID, int CompanyId, int acid)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            CompanyAuthorizedShareCapitalModel objCompanyAuthorizedShareCapitalModel = new CompanyAuthorizedShareCapitalModel();
            ViewBag.CalledFrom = "Edit";
            CompanyAuthorizedShareCapitalDTO objCompanyAuthorizedShareCapitalDTO = new CompanyAuthorizedShareCapitalDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
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
                if (CompanyAuthorizedShareCapitalID > 0)
                {
                    objCompanyAuthorizedShareCapitalDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    objCompanyAuthorizedShareCapitalDTO.CompanyAuthorizedShareCapitalID = CompanyAuthorizedShareCapitalID;
                    objCompaniesSL.DeleteCompanyAuthorizedShareCapitalDetails(objLoginUserDetails.CompanyDBConnectionString, objCompanyAuthorizedShareCapitalDTO);
                    ModelState.Clear();
                    FillGrid(ConstEnum.GridType.CompanyAuthorisedSharedCapitalList, CompanyId.ToString(), null, null);
                    objCompanyAuthorizedShareCapitalModel.CompanyID = CompanyId;
                    objCompanyAuthorizedShareCapitalModel.CompanyAuthorizedShareCapitalID = 0;
                }
                statusFlag = true;
                ErrorDictionary.Add("success", InsiderTrading.Common.Common.getResource("cmp_msg_13113"));
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
                objCompanyAuthorizedShareCapitalModel = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion DeleteCompanyAuthorisedSharesDetails

        #endregion  Authorised Shares all actions

        #region PaidUp And Subscribed Share Capital all actions

        #region Save Paid Up And Subscribed Share Capital
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public ActionResult SavePaidUpAndSubscribedShareCapital(CompanyPaidUpAndSubscribedShareCapitalModel objCompanyPaidUpAndSubscribedShareCapitalModel, int acid)
        {
            ViewBag.CalledFrom = "Edit";
            CompaniesSL objCompaniesSL = new CompaniesSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            InsiderTradingDAL.CompanyPaidUpAndSubscribedShareCapitalDTO objCompanyPaidUpAndSubscribedShareCapitalDTO = new InsiderTradingDAL.CompanyPaidUpAndSubscribedShareCapitalDTO();
            try
            {
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objCompanyPaidUpAndSubscribedShareCapitalModel, objCompanyPaidUpAndSubscribedShareCapitalDTO);
                objCompanyPaidUpAndSubscribedShareCapitalDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                if (objCompanyPaidUpAndSubscribedShareCapitalDTO.CompanyPaidUpAndSubscribedShareCapitalID == null)
                {
                    objCompanyPaidUpAndSubscribedShareCapitalDTO.CompanyPaidUpAndSubscribedShareCapitalID = 0;
                }
                objCompaniesSL.SaveCompanyPaidUpAndSubscribedShareCapitalDetails(objLoginUserDetails.CompanyDBConnectionString, objCompanyPaidUpAndSubscribedShareCapitalDTO);
                FillGrid(ConstEnum.GridType.CompanyPaidUpSubscribeShareCapitalList, objCompanyPaidUpAndSubscribedShareCapitalModel.CompanyID.ToString(), null, null);
                ModelState.Clear();
                CompanyPaidUpAndSubscribedShareCapitalModel obj = new CompanyPaidUpAndSubscribedShareCapitalModel();
                obj.CompanyID = objCompanyPaidUpAndSubscribedShareCapitalModel.CompanyID;
                ViewBag.CompanyID = objCompanyPaidUpAndSubscribedShareCapitalModel.CompanyID;
                return PartialView("PaidUpAndSubscribedShareCapital", obj);

            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return PartialView("PaidUpAndSubscribedShareCapital", objCompanyPaidUpAndSubscribedShareCapitalModel);
            }
            finally
            {
                objCompaniesSL = null;
                objLoginUserDetails = null;
                objCompanyPaidUpAndSubscribedShareCapitalDTO = null;
            }

        }
        #endregion Save Paid Up And Subscribed Share Capital

        #region EditPaidUpAndSubscribedShareCapital
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        public ActionResult EditPaidUpAndSubscribedShareCapital(int CompanyPaidUpAndSubscribedShareCapitalID, int acid)
        {
            CompanyPaidUpAndSubscribedShareCapitalModel objCompanyPaidUpAndSubscribedShareCapitalModel = new CompanyPaidUpAndSubscribedShareCapitalModel();
            ViewBag.CalledFrom = "Edit";
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                if (CompanyPaidUpAndSubscribedShareCapitalID > 0)
                {
                    CompanyPaidUpAndSubscribedShareCapitalDTO objCompanyPaidUpAndSubscribedShareCapitalDTO = null;
                    objCompanyPaidUpAndSubscribedShareCapitalDTO = objCompaniesSL.GetCompanyPaidUpAndSubscribedShareDetails(objLoginUserDetails.CompanyDBConnectionString,
                                       CompanyPaidUpAndSubscribedShareCapitalID);
                    Common.Common.CopyObjectPropertyByName(objCompanyPaidUpAndSubscribedShareCapitalDTO, objCompanyPaidUpAndSubscribedShareCapitalModel);
                    FillGrid(ConstEnum.GridType.CompanyPaidUpSubscribeShareCapitalList, objCompanyPaidUpAndSubscribedShareCapitalModel.CompanyID.ToString(), null, null);
                }
                return new JsonResult { Data = this.RenderRazorViewToString("PaidUpAndSubscribedShareCapital", objCompanyPaidUpAndSubscribedShareCapitalModel) };
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return PartialView("PaidUpAndSubscribedShareCapital", objCompanyPaidUpAndSubscribedShareCapitalModel);
            }
            finally
            {
                objCompanyPaidUpAndSubscribedShareCapitalModel = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
            }
        }
        #endregion EditPaidUpAndSubscribedShareCapital

        #region DeletePaidUpAndSubscribedShareCapital
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeletePaidUpAndSubscribedShareCapital(int CompanyPaidUpAndSubscribedShareCapitalID, int CompanyId, int acid)
        {
            CompanyPaidUpAndSubscribedShareCapitalModel objCompanyPaidUpAndSubscribedShareCapitalModel = new CompanyPaidUpAndSubscribedShareCapitalModel();
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            ViewBag.CalledFrom = "Edit";
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
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
                if (CompanyPaidUpAndSubscribedShareCapitalID > 0)
                {
                    objCompaniesSL.DeleteCompanyPaidUpAndSubscribedShareCapital(objLoginUserDetails.CompanyDBConnectionString, CompanyPaidUpAndSubscribedShareCapitalID);
                    ModelState.Clear();
                    FillGrid(ConstEnum.GridType.CompanyPaidUpSubscribeShareCapitalList, CompanyId.ToString(), null, null);
                    objCompanyPaidUpAndSubscribedShareCapitalModel.CompanyID = CompanyId;
                    objCompanyPaidUpAndSubscribedShareCapitalModel.CompanyPaidUpAndSubscribedShareCapitalID = 0;
                    statusFlag = true;
                    ErrorDictionary.Add("success", InsiderTrading.Common.Common.getResource("cmp_msg_13115"));
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
                objCompanyPaidUpAndSubscribedShareCapitalModel = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion DeletePaidUpAndSubscribedShareCapital

        #endregion  PaidUp And Subscribed Share Capital all actions

        #region Listing Details all actions

        #region SaveListingDetails
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveListingDetails(CompanyListingDetailsModel objCompanyListingDetailsModel, int acid)
        {
            ViewBag.CalledFrom = "Edit";
            CompaniesSL objCompaniesSL = new CompaniesSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            InsiderTradingDAL.CompanyListingDetailsDTO objCompanyListingDetailsDTO = new InsiderTradingDAL.CompanyListingDetailsDTO();
            try
            {
                if (objCompanyListingDetailsModel.DateOfListingTo != null)
                {
                    DateTime dtFromDate = (DateTime)objCompanyListingDetailsModel.DateOfListingFrom;
                    DateTime dtToDate = (DateTime)objCompanyListingDetailsModel.DateOfListingTo;
                    int? a = DateTime.Compare(dtFromDate.Date, dtToDate.Date);
                    if (a > 0)
                    {
                        ModelState.AddModelError("DateOfListingFrom", InsiderTrading.Common.Common.getResource("cmp_msg_13095"));
                    }
                }
                if (!ModelState.IsValid)
                {
                    ViewBag.StockExchangeList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.StockExchangeMaster).ToString(),
                   null, null, null, null);
                    FillGrid(ConstEnum.GridType.CompanyListingDetailsList, objCompanyListingDetailsModel.CompanyID.ToString(), null, null);
                    ViewBag.IsError = 1;
                    return PartialView("ListingDetails", objCompanyListingDetailsModel);
                }

                ViewBag.IsError = 0;
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objCompanyListingDetailsModel, objCompanyListingDetailsDTO);
                objCompanyListingDetailsDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                objCompaniesSL.SaveCompanyListingDetails(objLoginUserDetails.CompanyDBConnectionString, objCompanyListingDetailsDTO);
                ViewBag.StockExchangeList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.StockExchangeMaster).ToString(),
                    null, null, null, null);
                FillGrid(ConstEnum.GridType.CompanyListingDetailsList, objCompanyListingDetailsModel.CompanyID.ToString(), null, null);
                ModelState.Clear();
                CompanyListingDetailsModel obj = new CompanyListingDetailsModel();
                obj.CompanyID = objCompanyListingDetailsModel.CompanyID;
                ViewBag.CompanyID = objCompanyListingDetailsModel.CompanyID;
                return PartialView("ListingDetails", obj);

            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                ViewBag.IsError = 1;
                return PartialView("ListingDetails", objCompanyListingDetailsModel);
            }
            finally
            {
                objCompaniesSL = null;
                objLoginUserDetails = null;
                objCompanyListingDetailsDTO = null;
            }

        }
        #endregion SaveListingDetails

        #region EditListingDetails
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        public ActionResult EditListingDetails(int CompanyListingDetailsID, int acid)
        {
            CompanyListingDetailsModel objCompanyListingDetailsModel = new CompanyListingDetailsModel();
            CompanyListingDetailsDTO objCompanyListingDetailsDTO = null;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
            ViewBag.CalledFrom = "Edit";
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                if (CompanyListingDetailsID > 0)
                {
                    objCompanyListingDetailsDTO = objCompaniesSL.GetCompanyListingDetails(objLoginUserDetails.CompanyDBConnectionString,
                                       CompanyListingDetailsID);
                    Common.Common.CopyObjectPropertyByName(objCompanyListingDetailsDTO, objCompanyListingDetailsModel);

                    ViewBag.StockExchangeList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.StockExchangeMaster).ToString(),
                     null, null, null, null);
                    FillGrid(ConstEnum.GridType.CompanyListingDetailsList, objCompanyListingDetailsModel.CompanyID.ToString(), null, null);
                    return PartialView("ListingDetails", objCompanyListingDetailsModel);
                }
                else
                {
                    return PartialView("ListingDetails", objCompanyListingDetailsModel);
                }
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return PartialView("ListingDetails", objCompanyListingDetailsModel);
            }
            finally
            {
                objCompanyListingDetailsModel = null;
                objCompanyListingDetailsDTO = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
            }
        }
        #endregion EditListingDetails

        #region DeleteListingDetails
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteListingDetails(int CompanyListingDetailsID, int CompanyId, int acid)
        {
            CompanyListingDetailsDTO objCompanyListingDetailsDTO = new CompanyListingDetailsDTO();
            CompanyListingDetailsModel obj = new CompanyListingDetailsModel();
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            ViewBag.CalledFrom = "Edit";
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
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
                if (CompanyListingDetailsID > 0)
                {
                    objCompanyListingDetailsDTO.CompanyListingDetailsID = CompanyListingDetailsID;
                    objCompanyListingDetailsDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    objCompaniesSL.DeleteCompanyListingDetails(objLoginUserDetails.CompanyDBConnectionString, objCompanyListingDetailsDTO);
                    ViewBag.StockExchangeList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.StockExchangeMaster).ToString(),
                     null, null, null, null);
                    ModelState.Clear();
                    FillGrid(ConstEnum.GridType.CompanyListingDetailsList, CompanyId.ToString(), null, null);
                    obj.CompanyID = CompanyId;
                    obj.CompanyListingDetailsID = 0;
                }
                statusFlag = true;
                ErrorDictionary.Add("success", InsiderTrading.Common.Common.getResource("cmp_msg_13117"));
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
                objCompanyListingDetailsDTO = null;
                obj = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion DeleteListingDetails

        #endregion  Listing Details all actions

        #region Compliance Officer all actions

        #region SaveComplianceOfficer
        [HttpPost]
        [TokenVerification]
        [ValidateAntiForgeryToken]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveComplianceOfficer(CompanyComplianceOfficerModel objCompanyComplianceOfficerModel, int acid)
        {
            ViewBag.CalledFrom = "Edit";
            CompaniesSL objCompaniesSL = new CompaniesSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            InsiderTradingDAL.CompanyComplianceOfficerDTO objCompanyComplianceOfficerDTO = new InsiderTradingDAL.CompanyComplianceOfficerDTO();
            try
            {
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objCompanyComplianceOfficerModel, objCompanyComplianceOfficerDTO);
                objCompanyComplianceOfficerDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                if (objCompanyComplianceOfficerDTO.CompanyComplianceOfficerId == null)
                {
                    objCompanyComplianceOfficerDTO.CompanyComplianceOfficerId = 0;
                }
                objCompaniesSL.SaveCompanyComplianceOfficerDetails(objLoginUserDetails.CompanyDBConnectionString, objCompanyComplianceOfficerDTO);
                ViewBag.StatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null);
                ViewBag.DesignationList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.DesignationMaster).ToString(), null, null, null, null); ;
                FillGrid(ConstEnum.GridType.CompanyComplianceOfficerList, objCompanyComplianceOfficerModel.CompanyId.ToString(), null, null);
                ModelState.Clear();
                CompanyComplianceOfficerModel obj = new CompanyComplianceOfficerModel();
                obj.CompanyId = objCompanyComplianceOfficerModel.CompanyId;
                ViewBag.CompanyID = objCompanyComplianceOfficerModel.CompanyId;
                return PartialView("ComplianceOfficer", obj).Success("Data Save Successfully.");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return PartialView("ComplianceOfficer", objCompanyComplianceOfficerModel);
            }
            finally
            {
                objCompaniesSL = null;
                objLoginUserDetails = null;
                objCompanyComplianceOfficerDTO = null;
            }

        }
        #endregion SaveListingDetails

        #region EditComplianceOfficer
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        public ActionResult EditComplianceOfficer(int CompanyComplianceOfficerId, int acid)
        {
            CompanyComplianceOfficerModel objCompanyComplianceOfficerModel = new CompanyComplianceOfficerModel();
            ViewBag.CalledFrom = "Edit";
            CompanyComplianceOfficerDTO objCompanyComplianceOfficerDTO = null;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                if (CompanyComplianceOfficerId > 0)
                {
                    objCompanyComplianceOfficerDTO = objCompaniesSL.GetCompanyComplianceOfficerDetails(objLoginUserDetails.CompanyDBConnectionString,
                                       CompanyComplianceOfficerId);
                    Common.Common.CopyObjectPropertyByName(objCompanyComplianceOfficerDTO, objCompanyComplianceOfficerModel);
                    ViewBag.StatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null);
                    ViewBag.DesignationList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.DesignationMaster).ToString(), null, null, null, null); ;
                    FillGrid(ConstEnum.GridType.CompanyComplianceOfficerList, objCompanyComplianceOfficerModel.CompanyId.ToString(), null, null);
                    return PartialView("ComplianceOfficer", objCompanyComplianceOfficerModel);
                }
                else
                {
                    return PartialView("ComplianceOfficer", objCompanyComplianceOfficerModel);
                }
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return PartialView("ComplianceOfficer", objCompanyComplianceOfficerModel);
            }
            finally
            {
                objCompanyComplianceOfficerModel = null;
                objCompanyComplianceOfficerDTO = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
            }
        }
        #endregion EditComplianceOfficer

        #region DeleteComplianceOfficer
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteComplianceOfficer(int CompanyComplianceOfficerId, int CompanyId, int acid)
        {
            CompanyComplianceOfficerDTO objCompanyComplianceOfficerDTO = new CompanyComplianceOfficerDTO();
            CompanyComplianceOfficerModel obj = new CompanyComplianceOfficerModel();
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            ViewBag.CalledFrom = "Edit";
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompaniesSL objCompaniesSL = new CompaniesSL();
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
                if (CompanyComplianceOfficerId > 0)
                {
                    objCompanyComplianceOfficerDTO.CompanyComplianceOfficerId = CompanyComplianceOfficerId;
                    objCompanyComplianceOfficerDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    objCompaniesSL.DeleteCompanyComplianceOfficer(objLoginUserDetails.CompanyDBConnectionString, CompanyComplianceOfficerId);
                    ViewBag.StatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null);
                    ViewBag.DesignationList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.DesignationMaster).ToString(), null, null, null, null); ;
                    ModelState.Clear();
                    FillGrid(ConstEnum.GridType.CompanyComplianceOfficerList, CompanyId.ToString(), null, null);
                    obj.CompanyId = CompanyId;
                    obj.CompanyComplianceOfficerId = 0;
                }
                statusFlag = true;
                ErrorDictionary.Add("success", InsiderTrading.Common.Common.getResource("cmp_msg_13118"));
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
                objCompanyComplianceOfficerDTO = null;
                obj = null;
                objLoginUserDetails = null;
                objCompaniesSL = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion DeleteComplianceOfficer

        #endregion Compliance Officer all actions

        #region Company configuration all action

        #region Save configuration
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveCompanyConfiguration(int acid, CompanyConfigurationModel objCompanyConfigurationModel, int compid, Dictionary<int, List<DocumentDetailsModel>> dicEULAEcceptanceFileList,int documentID = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            CompanyConfigurationDTO objCompanyConfigurationDTO = null;
            List<DocumentDetailsModel> EULADocumentDetailsModelList = null;
            CompanyConfigurationModel objCompanyConfigurationModel2 = null;
            List<DocumentDetailsModel> EULADocList = new List<DocumentDetailsModel>();
            List<DocumentDetailsModel> lstDocumentDetailsModel = new List<DocumentDetailsModel>();
            try
            {
                bool Error = false;
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                if (objCompanyConfigurationModel.DefaultMailTo != null)
                {
                    foreach (var defaultMailTo in objCompanyConfigurationModel.DefaultMailTo)
                    {
                        if (defaultMailTo == "0")
                        {
                            Error = true;
                            return Json(new
                            {
                                status = false,
                                Message = "RequiredEmailError"
                            }, JsonRequestBehavior.AllowGet);
                        }
                        if (objCompanyConfigurationModel.DefaultMailCC != null)
                        {
                            foreach (var defaultMailCC in objCompanyConfigurationModel.DefaultMailCC)
                            {
                                if (defaultMailTo == defaultMailCC)
                                {
                                    Error = true;
                                   
                                }
                            }
                        }
                    }
                }
                else
                {
                    Error = true;
                    return Json(new
                    {
                        status = false,
                        Message = "RequiredEmailError"
                    }, JsonRequestBehavior.AllowGet);
                }
                if (Error)
                {
                    return Json(new
                    {
                        status = false,
                        Message = "EmailError"
                    }, JsonRequestBehavior.AllowGet);
                }
                if (dicEULAEcceptanceFileList.Count == 0 && documentID == 0 && objCompanyConfigurationModel.EULAAcceptanceSettings ==EULAAcceptanceSettingCode.YesSetting)
                {
                    return Json(new
                    {
                        status = false,
                        Message = "error"
                    }, JsonRequestBehavior.AllowGet); 
                }
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objCompanyConfigurationDTO = new CompanyConfigurationDTO();

                //convert into DTO and save
                objCompanyConfigurationDTO.InitialDisclosure = getEnterUploadSettingCodeId(objCompanyConfigurationModel.InitialDisclosure);
                objCompanyConfigurationDTO.ContinuousDisclosure = getEnterUploadSettingCodeId(objCompanyConfigurationModel.ContinuousDisclosure);
                objCompanyConfigurationDTO.PeriodEndDisclosure = getEnterUploadSettingCodeId(objCompanyConfigurationModel.PeriodEndDisclosure);

                objCompanyConfigurationDTO.PreClearanceImplementingCompany = getDematAccountSettingCodeId(objCompanyConfigurationModel.PreClearanceImplementingCompany);
                objCompanyConfigurationDTO.PreClearanceNonImplementingCompany = getDematAccountSettingCodeId(objCompanyConfigurationModel.PreClearanceNonImplementingCompany);
                objCompanyConfigurationDTO.InitialDisclosureTransaction = getDematAccountSettingCodeId(objCompanyConfigurationModel.InitialDisclosureTransaction);
                objCompanyConfigurationDTO.ContinuousDisclosureTransaction = getDematAccountSettingCodeId(objCompanyConfigurationModel.ContinuousDisclosureTransaction);
                objCompanyConfigurationDTO.PeriodEndDisclosureTransaction = getDematAccountSettingCodeId(objCompanyConfigurationModel.PeriodEndDisclosureTransaction);

                objCompanyConfigurationDTO.PreClearanceImplementingCompany_Mapping = getMappingId(objCompanyConfigurationModel.AllDematAccountList_PreClearanceImplementingCompany);
                objCompanyConfigurationDTO.PreClearanceNonImplementingCompany_Mapping = getMappingId(objCompanyConfigurationModel.AllDematAccountList_PreClearanceNonImplementingCompany);
                objCompanyConfigurationDTO.InitialDisclosureTransaction_Mapping = getMappingId(objCompanyConfigurationModel.AllDematAccountList_InitialDisclosureTransaction);
                objCompanyConfigurationDTO.ContinuousDisclosureTransaction_Mapping = getMappingId(objCompanyConfigurationModel.AllDematAccountList_ContinuousDisclosureTransaction);
                objCompanyConfigurationDTO.PeriodEndDisclosureTransaction_Mapping = getMappingId(objCompanyConfigurationModel.AllDematAccountList_PeriodEndDisclosureTransaction);
                objCompanyConfigurationDTO.EULAAcceptanceSettings = getEULAAcceptanceSettingCodeId(objCompanyConfigurationModel.EULAAcceptanceSettings);
                objCompanyConfigurationDTO.ReqiuredEULAReconfirmation = getReqiuredEULAReconfirmationCode(objCompanyConfigurationModel.ReqiuredEULAReconfirmation);
                objCompanyConfigurationDTO.UPSISetting = getUPSISettingCodeId(objCompanyConfigurationModel.UPSISetting);
                objCompanyConfigurationDTO.TriggerEmailsUPSIUpdated = getUPSIEmailUpdateSettingCodeId(objCompanyConfigurationModel.TriggerEmailsUPSIUpdated);
                objCompanyConfigurationDTO.TriggerEmailsUPSIpublished = getUPSIEmailPublishedSettingCodeId(objCompanyConfigurationModel.TriggerEmailsUPSIpublished);
                if (objCompanyConfigurationModel.DefaultMailTo!= null && objCompanyConfigurationModel.DefaultMailTo.Count() > 0)
                {
                    objCompanyConfigurationDTO.SubmittedDefaultMailTo = String.Join(",", objCompanyConfigurationModel.DefaultMailTo);
                }
                if (objCompanyConfigurationModel.DefaultMailCC != null && objCompanyConfigurationModel.DefaultMailCC.Count() > 0)
                {
                    objCompanyConfigurationDTO.SubmittedDefaultMailCC = String.Join(",", objCompanyConfigurationModel.DefaultMailCC);
                }

                if (dicEULAEcceptanceFileList.Count > 0) // file is uploaded and data found for file upload
                {
                    EULADocumentDetailsModelList = dicEULAEcceptanceFileList[ConstEnum.Code.EULAAcceptanceDocument];

                    int FileCounter = 0;
                    if (EULADocumentDetailsModelList != null)
                    {
                        foreach (DocumentDetailsModel objDocumentDetailsModel in EULADocumentDetailsModelList)
                        {
                            // check for uploaded document only
                            if (objDocumentDetailsModel.GUID != null)
                            {
                                FileCounter++;
                            }
                        }
                    }

                    using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                    {
                        if (FileCounter != 0)//document is uploaded for saving
                        {
                            //save / update Form F file 
                            EULADocList = objDocumentDetailsSL.SaveDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, EULADocumentDetailsModelList, ConstEnum.Code.EULAAcceptanceDocument, compid, objLoginUserDetails.LoggedInUserID);
                        }
                    }
                }
                objCompanyConfigurationDTO.EULAAcceptance_DocumentId = EULADocList.Count == 0 ? documentID : EULADocList[0].DocumentId;
                if (!Error)
                {
                    using (CompaniesSL objCompaniesSL = new CompaniesSL())
                    {
                        objCompaniesSL.SaveCompanyConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString, objCompanyConfigurationDTO, objLoginUserDetails.LoggedInUserID);
                    }
                }
                using (CompaniesSL objCompaniesSL = new CompaniesSL())
                {
                    objCompanyConfigurationDTO = objCompaniesSL.GetCompanyConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString);

                    objCompanyConfigurationModel2 = getCompanyConfigurationModel(objLoginUserDetails.CompanyDBConnectionString, objCompanyConfigurationDTO);
                }
                using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                {
                    //Get Document Details

                    lstDocumentDetailsModel = Common.Common.GenerateDocumentList(ConstEnum.Code.EULAAcceptanceDocument, compid, 0, null, 0);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {

            }

            ViewBag.CalledFrom = "Edit";
            ViewBag.CompanyId = compid;
            ViewData["DocumentDetailsModel"] = lstDocumentDetailsModel;
            ViewBag.UserAction = InsiderTrading.Common.ConstEnum.UserActions.COMPANY_VIEW;
            return PartialView("Configuration", objCompanyConfigurationModel2);
        }
        #endregion Save configuration

        #endregion Company configuration all action

        #region SavePersonalDetailsConfirmation
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public ActionResult SavePersonalDetailsConfirmation(PersonalDetailsConfirmationModel objPersonalDetailsConfirmationModel, int acid, int compid)
        {
            ViewBag.CalledFrom = "Edit";
            CompaniesSL objCompaniesSL = new CompaniesSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            InsiderTradingDAL.PersonalDetailsConfirmationDTO objPersonalDetailsConfirmationDTO = new InsiderTradingDAL.PersonalDetailsConfirmationDTO();
            try
            {
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objPersonalDetailsConfirmationModel, objPersonalDetailsConfirmationDTO);
                objPersonalDetailsConfirmationDTO.CompanyId = compid;
                objPersonalDetailsConfirmationDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                objCompaniesSL.SavePersonalDetailsConfirmation(objLoginUserDetails.CompanyDBConnectionString, objPersonalDetailsConfirmationDTO);

                return PartialView("PersonalDetailsConfirmation", objPersonalDetailsConfirmationModel);

            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return PartialView("PersonalDetailsConfirmation", objPersonalDetailsConfirmationModel);
            }
            finally
            {
                objCompaniesSL = null;
                objLoginUserDetails = null;
                objPersonalDetailsConfirmationDTO = null;
            }

        }
        #endregion SavePersonalDetailsConfirmation

        #region SaveEducationandWorkDetailsConfiguration
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveEducationandWorkDetailsConfiguration(WorkandEducationModel objWorkandEducationConfigurationModel, int acid, int compid)
        {
            ViewBag.CalledFrom = "Edit";
            ViewBag.PPD_WorkandeducationList = TempData.Peek("Workanducationlist");

            CompaniesSL objCompaniesSL = new CompaniesSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            InsiderTradingDAL.WorkandEducationDetailsConfigurationDTO objWorkandEducationDetailsConfigurationDTO = new InsiderTradingDAL.WorkandEducationDetailsConfigurationDTO();
            try
            {
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objWorkandEducationConfigurationModel, objWorkandEducationDetailsConfigurationDTO);
                objWorkandEducationDetailsConfigurationDTO.CompanyId = compid;
                objWorkandEducationDetailsConfigurationDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                objWorkandEducationDetailsConfigurationDTO.WorkandEducationDetailsConfigurationId = objWorkandEducationConfigurationModel.WorkandEducationMandatoryId;
                objCompaniesSL.SaveWorkandEducationDetailsConfiguration(objLoginUserDetails.CompanyDBConnectionString, objWorkandEducationDetailsConfigurationDTO);

                return PartialView("WorkandEducationDetails", objWorkandEducationConfigurationModel);

            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return PartialView("WorkandEducationDetails", objWorkandEducationConfigurationModel);
            }
            finally
            {
                objCompaniesSL = null;
                objLoginUserDetails = null;
                objWorkandEducationDetailsConfigurationDTO = null;
            }

        }
        #endregion SaveEducationandWorkDetailsConfiguration

        #region getAjaxTab
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <param name="CompanyId"></param>
        /// <returns></returns>
        public ActionResult getAjaxTab(int id, int CompanyId, int acid, string CalledFrom)
        {
            string viewName = string.Empty;
            ViewBag.CalledFrom = CalledFrom;

            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            CompanyModel objCompanyModel = null;
            ImplementedCompanyDTO objImplementedCompanyDTO = null;

            CompanyFaceValueModel objCompanyFaceValueModel = null;
            List<PopulateComboDTO> lstCurrency = null;

            CompanyAuthorizedShareCapitalModel objCompanyAuthorizedShareCapitalModel = null;

            CompanyPaidUpAndSubscribedShareCapitalModel objCompanyPaidUpAndSubscribedShareCapitalModel = null;

            CompanyListingDetailsModel objCompanyListingDetailsModel = null;
            List<PopulateComboDTO> lstStockExchangeList = null;

            CompanyComplianceOfficerModel objCompanyComplianceOfficerModel = null;
            List<PopulateComboDTO> lstStatusList = null;
            List<PopulateComboDTO> lstDesignationList = null;
            List<PopulateComboDTO> PPD_ReconfirmationList = null;
            

            CompanyConfigurationModel objCompanyConfigurationModel = null;
            CompanyConfigurationDTO objCompanyConfigurationDTO = null;

            PersonalDetailsConfirmationModel objPersonalDetailsConfirmationModel = null;
            PersonalDetailsConfirmationDTO objPersonalDetailsConfirmationDTO = null;
            

            #region CompanyInfo
            if (id == 1)
            {
                if (CompanyId > 0)
                {
                    objCompanyModel = new CompanyModel();

                    using (CompaniesSL objCompaniesSL = new CompaniesSL())
                    {
                        objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, CompanyId, 0);
                        InsiderTrading.Common.Common.CopyObjectPropertyByName(objImplementedCompanyDTO, objCompanyModel);

                        objImplementedCompanyDTO = null;
                    }

                    if (CalledFrom == "Edit")
                    {
                        return PartialView("CompanyInfo", objCompanyModel);
                    }
                    else
                    {
                        return PartialView("ViewCompanyInfo", objCompanyModel);
                    }
                }
                else
                {
                    return PartialView("CompanyInfo");

                }
            }
            #endregion CompanyInfo

            #region FaceValue
            else if (id == 2)
            {
                lstCurrency = new List<PopulateComboDTO>();

                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                lstCurrency.Add(objPopulateComboDTO);

                lstCurrency.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.CurrencyMaster).ToString(), null, null, null, null, "cmp_msg_").ToList<PopulateComboDTO>());


                ViewBag.CurrencyDropDown = lstCurrency;
                ViewBag.GridType = ConstEnum.GridType.CompanyFaceValueList;
                ViewBag.Param1 = CompanyId.ToString();
                ViewBag.CompanyId = CompanyId;

                lstCurrency = null;

                if (CompanyId > 0)
                {
                    return PartialView("FaceValue", objCompanyFaceValueModel);
                }
                else
                {
                    return PartialView("FaceValue", objCompanyFaceValueModel);
                }
            }
            #endregion FaceValue

            #region AuthorizedShare
            else if (id == 3)
            {
                ViewBag.GridType = ConstEnum.GridType.CompanyAuthorisedSharedCapitalList;
                ViewBag.Param1 = CompanyId.ToString();
                ViewBag.CompanyId = CompanyId;

                return PartialView("AuthorizedShare", objCompanyAuthorizedShareCapitalModel);

            }
            #endregion AuthorizedShare

            #region PaidUpAndSubscribedShareCapital
            else if (id == 4)
            {
                ViewBag.GridType = ConstEnum.GridType.CompanyPaidUpSubscribeShareCapitalList;
                ViewBag.Param1 = CompanyId.ToString();
                ViewBag.CompanyId = CompanyId;

                return PartialView("PaidUpAndSubscribedShareCapital", objCompanyPaidUpAndSubscribedShareCapitalModel);

            }
            #endregion PaidUpAndSubscribedShareCapital

            #region ListingDetails
            else if (id == 5)
            {
                lstStockExchangeList = new List<PopulateComboDTO>();

                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                lstStockExchangeList.Add(objPopulateComboDTO);
                lstStockExchangeList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.StockExchangeMaster).ToString(), null, null, null, null, "cmp_msg_").ToList<PopulateComboDTO>());

                ViewBag.StockExchangeList = lstStockExchangeList;
                ViewBag.GridType = ConstEnum.GridType.CompanyListingDetailsList;
                ViewBag.Param1 = CompanyId.ToString();
                ViewBag.CompanyId = CompanyId;

                lstStockExchangeList = null;

                return PartialView("ListingDetails", objCompanyListingDetailsModel);

            }
            #endregion ListingDetails

            #region ComplianceOfficer
            else if (id == 6)
            {
                objCompanyComplianceOfficerModel = new CompanyComplianceOfficerModel();
                lstStatusList = new List<PopulateComboDTO>();
                lstDesignationList = new List<PopulateComboDTO>();

                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                lstStatusList.Add(objPopulateComboDTO);
                lstStatusList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.UserStatus).ToString(), null, null, null, null, "cmp_msg_").ToList<PopulateComboDTO>());

                ViewBag.StatusList = lstStatusList;

                lstDesignationList.Add(objPopulateComboDTO);
                lstDesignationList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                    Convert.ToInt32(ConstEnum.CodeGroup.DesignationMaster).ToString(), null, null, null, null, "cmp_msg_").ToList<PopulateComboDTO>());

                ViewBag.DesignationList = lstDesignationList;
                ViewBag.GridType = ConstEnum.GridType.CompanyComplianceOfficerList;
                ViewBag.Param1 = CompanyId.ToString();
                ViewBag.CompanyId = CompanyId;

                lstStatusList = null;
                lstDesignationList = null;

                return PartialView("ComplianceOfficer", objCompanyComplianceOfficerModel);
            }
            #endregion ComplianceOfficer


            #region Personal Details Confirmation
            else if (id == 8)
            {
                PPD_ReconfirmationList = new List<PopulateComboDTO>();

                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                PPD_ReconfirmationList.Add(objPopulateComboDTO);
                PPD_ReconfirmationList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.OccurrenceFrequency).ToString(), null, null, null, null, "cmp_msg_").ToList<PopulateComboDTO>());

                ViewBag.PersonalDetails_ReconfirmationList = PPD_ReconfirmationList;
                PPD_ReconfirmationList = null;

                ViewBag.CalledFrom = CalledFrom;
                ViewBag.CompanyId = CompanyId;

                using (var objCompaniesSL = new CompaniesSL())
                {
                    objPersonalDetailsConfirmationDTO = objCompaniesSL.GetPersonal_Details_Confirmation_Frequency(objLoginUserDetails.CompanyDBConnectionString, CompanyId);
                }
                ViewBag.ConfirmationFrequency = objPersonalDetailsConfirmationDTO.ReconfirmationFrequencyId;
                return PartialView("PersonalDetailsConfirmation", objPersonalDetailsConfirmationModel);
            }
            #endregion Personal Details Confirmation

            #region Work and Education Details Configuration
            else if (id == 9)
            {
                List<PopulateComboDTO> PPD_WorkandeducationList  = new List<PopulateComboDTO>();

                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                PPD_WorkandeducationList.Add(objPopulateComboDTO);
                PPD_WorkandeducationList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.WorkandEducationDetailsConfiguration).ToString(), null, null, null, null, "cmp_msg_").ToList<PopulateComboDTO>());

                ViewBag.PPD_WorkandeducationList = PPD_WorkandeducationList;
                TempData["Workanducationlist"] = PPD_WorkandeducationList;
                

                ViewBag.CalledFrom = CalledFrom;
                ViewBag.CompanyId = CompanyId;
                WorkandEducationModel objWorkandEducationModel = new WorkandEducationModel();
                WorkandEducationDetailsConfigurationDTO objWorkandEducationDetailsConfigurationDTO = new WorkandEducationDetailsConfigurationDTO();
                using (var objCompaniesSL = new CompaniesSL())
                {
                    objWorkandEducationDetailsConfigurationDTO = objCompaniesSL.GetWorkandeducationDetailsConfiguration(objLoginUserDetails.CompanyDBConnectionString, 1);
                }
                if(objWorkandEducationDetailsConfigurationDTO!=null)
                {
                    objWorkandEducationModel.WorkandEducationMandatoryId = objWorkandEducationDetailsConfigurationDTO.WorkandEducationDetailsConfigurationId;
                }

                return PartialView("WorkandEducationDetails", objWorkandEducationModel);
            }
            #endregion Work and Education Details Configuration

            #region Configuration
            else
            {
                using (CompaniesSL objCompaniesSL = new CompaniesSL())
                {
                    objCompanyConfigurationDTO = objCompaniesSL.GetCompanyConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString);

                    objCompanyConfigurationModel = getCompanyConfigurationModel(objLoginUserDetails.CompanyDBConnectionString, objCompanyConfigurationDTO);
                }

                ViewBag.CalledFrom = CalledFrom;
                ViewBag.CompanyId = CompanyId;
                //Get Document Details
                List<DocumentDetailsModel> lstDocumentDetailsModel = new List<DocumentDetailsModel>();

                lstDocumentDetailsModel = Common.Common.GenerateDocumentList(ConstEnum.Code.EULAAcceptanceDocument, CompanyId, 0, null, 0);
                ViewData["DocumentDetailsModel"] = lstDocumentDetailsModel;
                ViewBag.UserAction = InsiderTrading.Common.ConstEnum.UserActions.COMPANY_VIEW;
                
                return PartialView("Configuration", objCompanyConfigurationModel);
            }
            #endregion Configuration

        }
        #endregion getAjaxTab

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
        private List<PopulateComboDTO> FillComboValues(int i_nComboType, string i_sParam1, string i_sParam2, string i_sParam3, string i_sParam4, string i_sParam5)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";
                List<PopulateComboDTO> lstPopulateComboDTO = new List<PopulateComboDTO>();
                lstPopulateComboDTO.Add(objPopulateComboDTO);
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

        #region get setting code for company configuration model

        private CompanyConfigurationModel getCompanyConfigurationModel(string CompanyDBConnectionString, CompanyConfigurationDTO objCompanyConfigurationDTO)
        {
            List<PopulateComboDTO> lstDPBankList = null;
            CompanyConfigurationModel objCompanyConfigurationModel = new CompanyConfigurationModel();

            objCompanyConfigurationModel.InitialDisclosure = getEnterUploadSettingCode(objCompanyConfigurationDTO.InitialDisclosure);
            objCompanyConfigurationModel.ContinuousDisclosure = getEnterUploadSettingCode(objCompanyConfigurationDTO.ContinuousDisclosure);
            objCompanyConfigurationModel.PeriodEndDisclosure = getEnterUploadSettingCode(objCompanyConfigurationDTO.PeriodEndDisclosure);

            objCompanyConfigurationModel.PreClearanceImplementingCompany = getDematAccountSettingCode(objCompanyConfigurationDTO.PreClearanceImplementingCompany);
            objCompanyConfigurationModel.PreClearanceNonImplementingCompany = getDematAccountSettingCode(objCompanyConfigurationDTO.PreClearanceNonImplementingCompany);
            objCompanyConfigurationModel.InitialDisclosureTransaction = getDematAccountSettingCode(objCompanyConfigurationDTO.InitialDisclosureTransaction);
            objCompanyConfigurationModel.ContinuousDisclosureTransaction = getDematAccountSettingCode(objCompanyConfigurationDTO.ContinuousDisclosureTransaction);
            objCompanyConfigurationModel.PeriodEndDisclosureTransaction = getDematAccountSettingCode(objCompanyConfigurationDTO.PeriodEndDisclosureTransaction);

            //set all DP bank list for transaction type
            lstDPBankList = new List<PopulateComboDTO>();
            lstDPBankList.AddRange(Common.Common.GetPopulateCombo(CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.DPName, null, null, null, null, "cmp_msg_").ToList<PopulateComboDTO>());

            objCompanyConfigurationModel.AllDematAccountList_PreClearanceImplementingCompany = getAllDematAccountList(lstDPBankList, objCompanyConfigurationDTO.PreClearanceImplementingCompany_Mapping);
            objCompanyConfigurationModel.AllDematAccountList_PreClearanceNonImplementingCompany = getAllDematAccountList(lstDPBankList, objCompanyConfigurationDTO.PreClearanceNonImplementingCompany_Mapping);
            objCompanyConfigurationModel.AllDematAccountList_InitialDisclosureTransaction = getAllDematAccountList(lstDPBankList, objCompanyConfigurationDTO.InitialDisclosureTransaction_Mapping);
            objCompanyConfigurationModel.AllDematAccountList_ContinuousDisclosureTransaction = getAllDematAccountList(lstDPBankList, objCompanyConfigurationDTO.ContinuousDisclosureTransaction_Mapping);
            objCompanyConfigurationModel.AllDematAccountList_PeriodEndDisclosureTransaction = getAllDematAccountList(lstDPBankList, objCompanyConfigurationDTO.PeriodEndDisclosureTransaction_Mapping);

            objCompanyConfigurationModel.EULAAcceptanceSettings = getEULAAcceptanceSettingCode(objCompanyConfigurationDTO.EULAAcceptanceSettings);
            objCompanyConfigurationModel.ReqiuredEULAReconfirmation = getReqiuredEULAReconfirmation(objCompanyConfigurationDTO.ReqiuredEULAReconfirmation);
            objCompanyConfigurationModel.UPSISetting = getUPSISettingCode(objCompanyConfigurationDTO.UPSISetting);

            objCompanyConfigurationModel.DefaultSetting = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.UPSIUserType.ToString(), null, null, null, null, true);
            objCompanyConfigurationModel.AssignedSetting = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.UPSIUserType.ToString(), "0", null, null, null, false);
            objCompanyConfigurationModel.DefaultSettingCC = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.UPSIUserType.ToString(), null, null, null, null, true);
            objCompanyConfigurationModel.AssignedSettingCC = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.UPSIUserType.ToString(), "0", null, null, null, false);

            objCompanyConfigurationModel.TriggerEmailsUPSIUpdated = getUPSIEmailUpdateSettingCode(objCompanyConfigurationDTO.TriggerEmailsUPSIUpdated);
            objCompanyConfigurationModel.TriggerEmailsUPSIpublished = getUPSIEmailPublishedSettingCode(objCompanyConfigurationDTO.TriggerEmailsUPSIpublished);
            if (!string.IsNullOrEmpty(objCompanyConfigurationDTO.SubmittedDefaultMailTo))
            {
                objCompanyConfigurationModel.DefaultMailTo = new List<string>();
                string[] MailTOList = objCompanyConfigurationDTO.SubmittedDefaultMailTo.Split(',');
                foreach (var mailTOList in MailTOList)
                {
                    objCompanyConfigurationModel.DefaultMailTo.Add(mailTOList);
                }
            }
            if (!string.IsNullOrEmpty(objCompanyConfigurationDTO.SubmittedDefaultMailCC))
            {
                objCompanyConfigurationModel.DefaultMailCC = new List<string>();
                string[] MailTOList = objCompanyConfigurationDTO.SubmittedDefaultMailCC.Split(',');
                foreach (var mailTOList in MailTOList)
                {
                    objCompanyConfigurationModel.DefaultMailCC.Add(mailTOList);
                }
            }
            if (objCompanyConfigurationDTO.UPSISetting == ConstEnum.Code.UPSI_YesNoSettings_No)
            {
                List<PopulateComboDTO> DefaultSettingList = new List<PopulateComboDTO>();
                foreach (PopulateComboDTO str in objCompanyConfigurationModel.DefaultSetting)
                {
                    if (str.Value != "Information shared by")
                    {
                        DefaultSettingList.Add(str);
                    }

                }
                objCompanyConfigurationModel.DefaultSetting = DefaultSettingList;
                DefaultSettingList = new List<PopulateComboDTO>(); 
                foreach (PopulateComboDTO str in objCompanyConfigurationModel.DefaultSettingCC)
                {
                    if (str.Value != "Information shared by")
                    {
                        DefaultSettingList.Add(str);
                    }

                }
                objCompanyConfigurationModel.DefaultSettingCC = DefaultSettingList;
                //code for remove shared by from  list
            }
            lstDPBankList = null;

            return objCompanyConfigurationModel;
        }

        private EnterUploadSettingCode getEnterUploadSettingCode(int codeId)
        {
            if (codeId == ConstEnum.Code.EnterUploadSetting_EnterDetails)
            {
                return EnterUploadSettingCode.EnterDetails;
            }
            else if (codeId == ConstEnum.Code.EnterUploadSetting_UploadDetails)
            {
                return EnterUploadSettingCode.UploadDetails;
            }
            else if (codeId == ConstEnum.Code.EnterUploadSetting_EnterAndUploadDetails)
            {
                return EnterUploadSettingCode.EnterAndUploadDetails;
            }
            else if (codeId == ConstEnum.Code.EnterUploadSetting_EnterOrDetails)
            {
                return EnterUploadSettingCode.EnterOrUploadDetails;
            }
            else if (codeId == ConstEnum.Code.EnterUploadSetting_EnterAndOrDetails)
            {
                return EnterUploadSettingCode.EnterAndOrUploadDetails;
            }
            else
            {
                return EnterUploadSettingCode.EnterDetails; // this default return if matching not found
            }
        }

        private DematAccountSettingCode getDematAccountSettingCode(int codeId)
        {
            if (codeId == ConstEnum.Code.DematAccountSetting_AllDemat)
            {
                return DematAccountSettingCode.AllDemat;
            }
            else if (codeId == ConstEnum.Code.DematAccountSetting_SelectedDemat)
            {
                return DematAccountSettingCode.SelectedDemat;
            }
            else
            {
                return DematAccountSettingCode.AllDemat; // this default return if matching not found
            }
        }

        private List<CommonListCheckbox> getAllDematAccountList(List<PopulateComboDTO> lstAllDematAccount, List<int> lstSelectedDematAccount)
        {
            List<CommonListCheckbox> lstAllDemat = new List<CommonListCheckbox>();

            if (lstAllDematAccount != null && lstAllDematAccount.Count() > 0)
            {
                foreach (PopulateComboDTO DPName in lstAllDematAccount)
                {
                    CommonListCheckbox objCommonListCheckbox = new CommonListCheckbox();

                    objCommonListCheckbox.id = Convert.ToInt32(DPName.Key);
                    objCommonListCheckbox.checkboxText = DPName.Value;

                    objCommonListCheckbox.selected = (lstSelectedDematAccount != null && lstSelectedDematAccount.Contains(objCommonListCheckbox.id)) ? true : false;

                    lstAllDemat.Add(objCommonListCheckbox);
                }
            }

            return lstAllDemat;
        }

        private int getEnterUploadSettingCodeId(EnterUploadSettingCode code)
        {
            int setting_code;

            switch (code)
            {
                case EnterUploadSettingCode.EnterDetails:
                    setting_code = ConstEnum.Code.EnterUploadSetting_EnterDetails;
                    break;
                case EnterUploadSettingCode.UploadDetails:
                    setting_code = ConstEnum.Code.EnterUploadSetting_UploadDetails;
                    break;
                case EnterUploadSettingCode.EnterAndUploadDetails:
                    setting_code = ConstEnum.Code.EnterUploadSetting_EnterAndUploadDetails;
                    break;
                case EnterUploadSettingCode.EnterOrUploadDetails:
                    setting_code = ConstEnum.Code.EnterUploadSetting_EnterOrDetails;
                    break;
                case EnterUploadSettingCode.EnterAndOrUploadDetails:
                    setting_code = ConstEnum.Code.EnterUploadSetting_EnterAndOrDetails;
                    break;
                default:
                    setting_code = ConstEnum.Code.EnterUploadSetting_EnterDetails;
                    break;
            }

            return setting_code;
        }

        private int getDematAccountSettingCodeId(DematAccountSettingCode code)
        {
            int setting_code;

            switch (code)
            {
                case DematAccountSettingCode.AllDemat:
                    setting_code = ConstEnum.Code.DematAccountSetting_AllDemat;
                    break;
                case DematAccountSettingCode.SelectedDemat:
                    setting_code = ConstEnum.Code.DematAccountSetting_SelectedDemat;
                    break;
                default:
                    setting_code = ConstEnum.Code.DematAccountSetting_AllDemat;
                    break;
            }

            return setting_code;
        }

        private List<int> getMappingId(List<CommonListCheckbox> lstchkbox)
        {
            List<int> lstMappingId = new List<int>();

            if (lstchkbox != null && lstchkbox.Count() > 0)
            {
                foreach (CommonListCheckbox objCommonListCheckbox in lstchkbox)
                {
                    if (objCommonListCheckbox.selected)
                    {
                        lstMappingId.Add(objCommonListCheckbox.id);
                    }
                }
            }

            return lstMappingId;
        }

        private EULAAcceptanceSettingCode getEULAAcceptanceSettingCode(int codeId)
        {
            if (codeId == ConstEnum.Code.CompanyConfig_YesNoSettings_Yes)
            {
                return EULAAcceptanceSettingCode.YesSetting;
            }
            else if (codeId == ConstEnum.Code.CompanyConfig_YesNoSettings_No)
            {
                return EULAAcceptanceSettingCode.NoSetting;
            }
            else
            {
                return EULAAcceptanceSettingCode.NoSetting;
            }
        }

        private int getEULAAcceptanceSettingCodeId(EULAAcceptanceSettingCode code)
        {
            int setting_code;

            switch (code)
            {
                case EULAAcceptanceSettingCode.YesSetting:
                    setting_code = ConstEnum.Code.CompanyConfig_YesNoSettings_Yes;
                    break;
                case EULAAcceptanceSettingCode.NoSetting:
                    setting_code = ConstEnum.Code.CompanyConfig_YesNoSettings_No;
                    break;
                default:
                    setting_code = ConstEnum.Code.CompanyConfig_YesNoSettings_No;
                    break;
            }

            return setting_code;
        }

        private UPSISettingCode getUPSISettingCode(int codeId)
        {
            if (codeId == ConstEnum.Code.UPSI_YesNoSettings_Yes)
            {
                return UPSISettingCode.YesSetting;
            }
            else if (codeId == ConstEnum.Code.UPSI_YesNoSettings_No)
            {
                return UPSISettingCode.NoSetting;
            }
            else
            {
                return UPSISettingCode.NoSetting;
            }
        }
        private int getUPSISettingCodeId(UPSISettingCode code)
        {
            int setting_code;
            switch (code)
            {
                case UPSISettingCode.YesSetting:
                    setting_code = ConstEnum.Code.UPSI_YesNoSettings_Yes;
                    break;
                case UPSISettingCode.NoSetting:
                    setting_code = ConstEnum.Code.UPSI_YesNoSettings_No;
                    break;
                default:
                    setting_code = ConstEnum.Code.UPSI_YesNoSettings_No;
                    break;
            }
            return setting_code;
        }
        private UPSIEmailUpdateSettingCode getUPSIEmailUpdateSettingCode(int codeId)
        {
            if (codeId == ConstEnum.Code.UPSI_TEmailUpdate_YesNoSettings_Yes)
            {
                return UPSIEmailUpdateSettingCode.YesSetting;
            }
            else if (codeId == ConstEnum.Code.UPSI_TEmailUpdate_YesNoSettings_No)
            {
                return UPSIEmailUpdateSettingCode.NoSetting;
            }
            else
            {
                return UPSIEmailUpdateSettingCode.NoSetting;
            }
        }
        private int getUPSIEmailUpdateSettingCodeId(UPSIEmailUpdateSettingCode code)
        {
            int setting_code;
            switch (code)
            {
                case UPSIEmailUpdateSettingCode.YesSetting:
                    setting_code = ConstEnum.Code.UPSI_TEmailUpdate_YesNoSettings_Yes;
                    break;
                case UPSIEmailUpdateSettingCode.NoSetting:
                    setting_code = ConstEnum.Code.UPSI_TEmailUpdate_YesNoSettings_No;
                    break;
                default:
                    setting_code = ConstEnum.Code.UPSI_TEmailUpdate_YesNoSettings_No;
                    break;
            }
            return setting_code;
        }
        private UPSIEmailPublishedSettingCode getUPSIEmailPublishedSettingCode(int codeId)
        {
            if (codeId == ConstEnum.Code.UPSI_TEmailPublished_YesNoSettings_Yes)
            {
                return UPSIEmailPublishedSettingCode.YesSetting;
            }
            else if (codeId == ConstEnum.Code.UPSI_TEmailPublished_YesNoSettings_No)
            {
                return UPSIEmailPublishedSettingCode.NoSetting;
            }
            else
            {
                return UPSIEmailPublishedSettingCode.NoSetting;
            }
        }
        private int getUPSIEmailPublishedSettingCodeId(UPSIEmailPublishedSettingCode code)
        {
            int setting_code;
            switch (code)
            {
                case UPSIEmailPublishedSettingCode.YesSetting:
                    setting_code = ConstEnum.Code.UPSI_TEmailPublished_YesNoSettings_Yes;
                    break;
                case UPSIEmailPublishedSettingCode.NoSetting:
                    setting_code = ConstEnum.Code.UPSI_TEmailPublished_YesNoSettings_No;
                    break;
                default:
                    setting_code = ConstEnum.Code.UPSI_TEmailPublished_YesNoSettings_No;
                    break;
            }
            return setting_code;
        }
        private EULARecomfirmationSettingCode getReqiuredEULAReconfirmation(int codeId)
        {
            if (codeId == ConstEnum.Code.CompanyConfig_EULAReconfirmation_All)
            {
                return EULARecomfirmationSettingCode.All;
            }
            else if (codeId == ConstEnum.Code.CompanyConfig_EULAReconfirmation_NotAccepted)
            {
                return EULARecomfirmationSettingCode.NotAccepted;
            }
            else
            {
                return EULARecomfirmationSettingCode.All;
            }
        }

        private int getReqiuredEULAReconfirmationCode(EULARecomfirmationSettingCode codeId)
        {
            int setting_code;
            switch (codeId)
            {
                case EULARecomfirmationSettingCode.All:
                    setting_code = ConstEnum.Code.CompanyConfig_EULAReconfirmation_All;
                    break;
                case EULARecomfirmationSettingCode.NotAccepted:
                    setting_code = ConstEnum.Code.CompanyConfig_EULAReconfirmation_NotAccepted;
                    break;
                default:
                    setting_code = ConstEnum.Code.CompanyConfig_EULAReconfirmation_All;
                    break;
            }
            return setting_code;
        }
        #endregion get setting code for company configuration model

        #endregion Private Method

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }

    }

    public static class ModelStateExtensions
    {
        public static IDictionary ToSerializedDictionary(this ModelStateDictionary modelState)
        {
            return modelState.ToDictionary(
                k => k.Key,
                v => v.Value.Errors.Select(x => x.ErrorMessage).ToArray()
            );
        }
    }

}