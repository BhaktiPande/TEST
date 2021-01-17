using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;
using iTextSharp.text;
using iTextSharp.text.pdf;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class PreclearanceRequestNonImplCompanyController : Controller
    {
        private string sLookupPrefix = "dis_msg_";
        int nDisclosureCompletedFlag = 0;
        int groupId = 0;

        #region Pre-clearance List for Insider
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            LoginUserDetails objLoginUserDetails = null;
            UserInfoDTO objUserInfoDTO = null;
            UserInfoSL objUserInfoSL = new UserInfoSL();
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            ViewBag.RequestStatusList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null);
            ViewBag.TransactionTypeList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null);
            objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
            if (objUserInfoDTO.DateOfBecomingInsider != null)
            {
                ViewBag.InsiderTypeUser = 1;
            }
            else
            {
                ViewBag.InsiderTypeUser = 0;
            }
            ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            ViewBag.GridType = Common.ConstEnum.GridType.InsiderNonImplementingPrelclearanceList;
            return View("Index");
        }
        #endregion Pre-clearance List

        #region Pre-clearance List for CO
        [AuthorizationPrivilegeFilter]
        public ActionResult COList(int acid)
        {
            LoginUserDetails objLoginUserDetails = null;
            UserInfoDTO objUserInfoDTO = null;
            UserInfoSL objUserInfoSL = new UserInfoSL();
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            ViewBag.RequestStatusList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null);
            ViewBag.TransactionTypeList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null);
            objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
            //ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            ViewBag.GridType = Common.ConstEnum.GridType.CONonImplementingPrelclearanceList;
            return View("COList");
        }
        #endregion Pre-clearance List

        #region DownloadFormE
        [ValidateInput(false)]
        [AuthorizationPrivilegeFilter]
        public ActionResult DownloadFormE(int acid, long PreclearanceRequestId, string DisplayCode)
        {
            LoginUserDetails objLoginUserDetails = null;
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            FormEDetailsDTO objFormEDetailsDTO = null;
            try
            {


                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objFormEDetailsDTO = objPreclearanceRequestSL.GetFormEDetails(objLoginUserDetails.CompanyDBConnectionString, Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany, Convert.ToInt32(PreclearanceRequestId));
                Response.Clear();
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/pdf";
                Response.AppendHeader("content-disposition", "attachment;filename=" + DisplayCode + ".pdf");
                Response.Flush();
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.Buffer = true;

                string LetterHTMLContent = objFormEDetailsDTO.GeneratedFormContents;
                Regex rReplaceScript = new Regex(@"<br>");
                LetterHTMLContent = rReplaceScript.Replace(LetterHTMLContent, "<br />");

                using (var ms = new MemoryStream())
                {
                    using (var doc = new Document(PageSize.A4, 30f, 30f, 30f, 30f))
                    {
                        using (var writer = PdfWriter.GetInstance(doc, Response.OutputStream))
                        {
                            doc.Open();
                            doc.NewPage();

                            using (var msCss = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent)))
                            {
                                using (var msHtml = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(LetterHTMLContent)))
                                {
                                    iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml(writer, doc, msHtml, msCss);
                                }
                            }

                            doc.Close();
                        }

                        Response.Write(doc);
                        Response.End();
                    }
                }
                return null;
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Warning", Common.Common.GetErrorMessage(exp));
                return View("Index");
            }
        }
        #endregion DownloadFormE

        #region Create Pre-clearance restricted List
        /// <summary>
        /// This method is used to create pre-clearance request
        /// </summary>
        /// <param name="acid"></param>
        /// <param name="search"></param>
        /// <param name="company"></param>
        /// <param name="backacid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public PartialViewResult Create(int acid, int search, int company, int backacid, bool module)
        {
            PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel = null;
            RestrictedListDTO objRestrictedListDTO = null;
            LoginUserDetails objLoginUserDetails = null;
            PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL();
            int nIsPreviousPeriodEndSubmission;
            string sSubsequentPeriodEndOrPreciousPeriodEndResource = "";
            string sSubsequentPeriodEndResourceOtherSecurity = "";
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                DateTime currentDBDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);

                objPreclearanceRequestNonImplCompanySL.GetLastPeriodEndSubmissonFlag_OS(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, out nIsPreviousPeriodEndSubmission, out sSubsequentPeriodEndOrPreciousPeriodEndResource, out sSubsequentPeriodEndResourceOtherSecurity);
                if (nIsPreviousPeriodEndSubmission == 1)
                {
                    ViewBag.IsPreviousPeriodEndSubmissionOtherSecurity = nIsPreviousPeriodEndSubmission;
                    ViewBag.SubsequentPeriodEndOrPreciousPeriodEndResource = sSubsequentPeriodEndOrPreciousPeriodEndResource;
                }

                objPreclearanceRequestNonImplCompanyModel = new PreclearanceRequestNonImplCompanyModel();
                objPreclearanceRequestNonImplCompanyModel.PreclearanceRequestForCodeId = PreclearanceRequestFor.Self;
                objPreclearanceRequestNonImplCompanyModel.PreclearanceStatusCodeId = null;
                objPreclearanceRequestNonImplCompanyModel.PreclearanceDate = currentDBDate;
                objPreclearanceRequestNonImplCompanyModel.UserInfoId = objLoginUserDetails.LoggedInUserID;
                objPreclearanceRequestNonImplCompanyModel.SecuritiesToBeTradedValue = 0;
                objPreclearanceRequestNonImplCompanyModel.RlSearchAuditId = search;

                //get company name from RL_companymasterList table
                using (RestrictedListSL objRestrictedListSL = new RestrictedListSL())
                {
                    objRestrictedListDTO = objRestrictedListSL.GetRestrictedListCompanyDetails(objLoginUserDetails.CompanyDBConnectionString, company);
                    objPreclearanceRequestNonImplCompanyModel.CompanyName = objRestrictedListDTO.CompanyName;
                    objPreclearanceRequestNonImplCompanyModel.CompanyId = (Int32)objRestrictedListDTO.RLCompanyId;
                }

                ViewBag.RelativeDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString());

                ViewBag.TransactionDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.TransactionType);

                ViewBag.SecurityDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType);

                ViewBag.ModeOfAcquisition = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.ModeOfAcquisition);

                ViewBag.DematAccountNumberList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_NonImplementingCompany.ToString());

                ViewBag.UserAction = acid;
                ViewBag.BackURLACID = backacid;
                ViewBag.Page = "PCL";
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                objPreclearanceRequestNonImplCompanySL = null;
                objLoginUserDetails = null;
                objRestrictedListDTO = null;
            }

            return PartialView("Create", objPreclearanceRequestNonImplCompanyModel);
        }
        #endregion Create Pre-clearance restricted List

        #region Get Demat List for User
        /// <summary>
        /// This method is used to get demat list for given user id
        /// </summary>
        /// <param name="id"></param>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult DematList(int id, int acid)
        {
            LoginUserDetails objLoginUserDetails = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                ViewBag.DematAccountNumberList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserDMATList, id.ToString(), ConstEnum.Code.PreClearanceType_NonImplementingCompany.ToString());

                ViewBag.IsFetch = true;
            }
            finally
            {
                objLoginUserDetails = null;
            }

            return PartialView("_DEMATList");
        }
        #endregion Get Demat List for User

        #region Save Pre-clearance request
        /// <summary>
        /// This method is used to save pre-clearance request
        /// </summary>
        /// <param name="objPreclearanceRequestNonImplCompanyModel"></param>
        /// <param name="acid"></param>
        /// <param name="backacid"></param>
        /// <returns></returns>
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        //[ValidateAntiForgeryToken]
        public ActionResult SavePreclearanceRequest(PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel, int acid, int backacid)
        {
            LoginUserDetails objLoginUserDetails = null;
            PreclearanceRequestNonImplCompanyDTO objPreclearanceRequestNonImplCompanyDTO = null;
            List<PreclearanceRequestNonImplCompanyModel> objPreclearanceRequestNonImplCompanyList = null;
            PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompany = null;

            string sucess_msg = "";

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                objPreclearanceRequestNonImplCompanyList = new List<PreclearanceRequestNonImplCompanyModel>();
                TemplateMasterDTO objTemplateMasterDTO = null;
                using (var objTemplateMasterSL = new TemplateMasterSL())
                {
                    objTemplateMasterDTO = objTemplateMasterSL.GetFormETemplate(objLoginUserDetails.CompanyDBConnectionString);
                    if (objTemplateMasterDTO != null)
                    {
                        ViewBag.IsFormEtemplateMsgShow = false;
                    }
                    else
                    {
                        ViewBag.IsFormEtemplateMsgShow = true;
                    }

                }
                if (!ViewBag.IsFormEtemplateMsgShow)
                {
                    if (TempData["List"] != null)
                    {
                        var oldList = (List<PreclearanceRequestNonImplCompanyModel>)TempData.Peek("List");
                        objPreclearanceRequestNonImplCompanyList.AddRange(oldList);
                    }
                    if (objPreclearanceRequestNonImplCompanyList != null)
                    {
                        if (objPreclearanceRequestNonImplCompanyModel.SequenceNo != 0)
                        {
                            var item = objPreclearanceRequestNonImplCompanyList.FirstOrDefault(x => x.SequenceNo == objPreclearanceRequestNonImplCompanyModel.SequenceNo);
                            if (item != null)
                                objPreclearanceRequestNonImplCompanyList.Remove(item);
                            TempData["List"] = objPreclearanceRequestNonImplCompanyList;
                            TempData.Keep();
                        }
                        objPreclearanceRequestNonImplCompany = FillListByModelValue(objPreclearanceRequestNonImplCompanyModel);
                        objPreclearanceRequestNonImplCompanyList.Add(objPreclearanceRequestNonImplCompany);
                        //add list to tempdata
                        TempData["List"] = objPreclearanceRequestNonImplCompanyList;
                        TempData.Keep();
                    }
                    else
                    {
                        objPreclearanceRequestNonImplCompanyList = new List<PreclearanceRequestNonImplCompanyModel>();
                        objPreclearanceRequestNonImplCompany = FillListByModelValue(objPreclearanceRequestNonImplCompanyModel);
                        //Add data to list
                        objPreclearanceRequestNonImplCompanyList.Add(objPreclearanceRequestNonImplCompany);
                        //add list to tempdata
                        TempData["List"] = objPreclearanceRequestNonImplCompanyList;
                        TempData.Keep();
                    }
                }
                else
                {
                    TempData["List"] = null;
                    TempData.Keep();
                    return RedirectToAction("RestrictedListSearch", "RestrictedList");
                }
                sucess_msg = Common.Common.getResource("dis_msg_17513");
                //Redirect to restricted list page
                ViewBag.InsiDiscoPreCleRequestNIC = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PRECLEARANCE_REQUEST_NONIMPLEMENTATION;
                ViewBag.RLSearchAudId = objPreclearanceRequestNonImplCompanyModel.RlSearchAuditId;
                ViewBag.RLCompId = objPreclearanceRequestNonImplCompanyModel.CompanyId;
                ViewBag.IRListSearch = ConstEnum.UserActions.INSIDER_RESTRICTED_LIST_SEARCH;
                ViewBag.GridAllow = true;
            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);

                ViewBag.RelativeDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString());

                ViewBag.TransactionDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.TransactionType);

                ViewBag.SecurityDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType);

                ViewBag.ModeOfAcquisitionDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.ModeOfAcquisition);

                ViewBag.DematAccountNumberList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_NonImplementingCompany.ToString());

                ViewBag.UserAction = acid;
                ViewBag.BackURLACID = backacid;

                return View("Create", objPreclearanceRequestNonImplCompanyModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }
            TempData["IsPreClearanceAllow"] = false;
            TempData["GridAllow"] = true;
            return RedirectToAction("RestrictedListSearch", "RestrictedList").Success(sucess_msg);
        }
        #endregion Save Pre-clearance request

        #region Add PreclearanceRequestNonImplCompanyModel data to list
        public PreclearanceRequestNonImplCompanyModel FillListByModelValue(PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel)
        {
            LoginUserDetails objLoginUserDetails = null;
            int sequenceNo;
            UserInfoSL objUserInfoSL = new UserInfoSL();
            InsiderTradingDAL.UserInfoDTO objUserInfoDTO = null;
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();

            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompany = new PreclearanceRequestNonImplCompanyModel();
            if (objPreclearanceRequestNonImplCompanyModel.SequenceNo != 0)
            {
                objPreclearanceRequestNonImplCompany.SequenceNo = objPreclearanceRequestNonImplCompanyModel.SequenceNo;
            }
            else
            {
                sequenceNo = Convert.ToInt32(TempData["SequenceNo"]);
                objPreclearanceRequestNonImplCompany.SequenceNo = (sequenceNo == 0) ? 1 : sequenceNo + 1;
                TempData["SequenceNo"] = objPreclearanceRequestNonImplCompany.SequenceNo;
                TempData.Keep();
            }
            objPreclearanceRequestNonImplCompany.CompanyId = objPreclearanceRequestNonImplCompanyModel.CompanyId;
            objPreclearanceRequestNonImplCompany.CompanyName = objPreclearanceRequestNonImplCompanyModel.CompanyName;
            objPreclearanceRequestNonImplCompany.PreclearanceRequestForCodeId = objPreclearanceRequestNonImplCompanyModel.PreclearanceRequestForCodeId;
            switch (Convert.ToInt32(objPreclearanceRequestNonImplCompany.PreclearanceRequestForCodeId))
            {
                case ConstEnum.Code.PreclearanceRequestForSelf:
                    objPreclearanceRequestNonImplCompany.TradedFor = "Self";
                    break;
                case ConstEnum.Code.PreclearanceRequestForRelative:
                    objPreclearanceRequestNonImplCompany.TradedFor = "Relative";
                    break;
            }
            if (Convert.ToInt32(objPreclearanceRequestNonImplCompany.PreclearanceRequestForCodeId) == ConstEnum.Code.PreclearanceRequestForSelf)
            {
                objPreclearanceRequestNonImplCompany.UserInfoId = objPreclearanceRequestNonImplCompanyModel.UserInfoId;
                objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestNonImplCompanyModel.UserInfoId);
                objPreclearanceRequestNonImplCompany.EmployeeName = objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
            }
            else
            {
                objPreclearanceRequestNonImplCompany.UserInfoId = objPreclearanceRequestNonImplCompanyModel.UserInfoId;
                objPreclearanceRequestNonImplCompany.UserInfoIdRelative = objPreclearanceRequestNonImplCompanyModel.UserInfoIdRelative;
                int userrelativeId = Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.UserInfoIdRelative);
                objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, userrelativeId);
                objPreclearanceRequestNonImplCompany.EmployeeName = objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
            }
            objPreclearanceRequestNonImplCompany.TransactionTypeCodeId = objPreclearanceRequestNonImplCompanyModel.TransactionTypeCodeId;
            var transactionType = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.TransactionType);
            foreach (var type in transactionType)
            {
                if (type.Key == objPreclearanceRequestNonImplCompanyModel.TransactionTypeCodeId.ToString())
                {
                    objPreclearanceRequestNonImplCompany.TransactionType = type.Value;
                }
            }
            objPreclearanceRequestNonImplCompany.SecurityTypeCodeId = objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId;
            var securityType = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType);
            foreach (var type in securityType)
            {
                if (type.Key == objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId.ToString())
                {
                    objPreclearanceRequestNonImplCompany.SecurityType = type.Value;
                }
            }
            objPreclearanceRequestNonImplCompany.SecuritiesToBeTradedQty = objPreclearanceRequestNonImplCompanyModel.SecuritiesToBeTradedQty;
            objPreclearanceRequestNonImplCompany.SecuritiesToBeTradedValue = objPreclearanceRequestNonImplCompanyModel.SecuritiesToBeTradedValue;
            objPreclearanceRequestNonImplCompany.ModeOfAcquisitionCodeId = objPreclearanceRequestNonImplCompanyModel.ModeOfAcquisitionCodeId;
            var modeOfAcq = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.ModeOfAcquisition);
            foreach (var type in modeOfAcq)
            {
                if (type.Key == objPreclearanceRequestNonImplCompanyModel.ModeOfAcquisitionCodeId.ToString())
                {
                    objPreclearanceRequestNonImplCompany.ModeOfAcquisition = type.Value;
                }
            }
            objPreclearanceRequestNonImplCompany.DMATDetailsID = objPreclearanceRequestNonImplCompanyModel.DMATDetailsID;
            using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
            {
                objDMATDetailsDTO = objDMATDetailsSL.GetDMATDetails(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestNonImplCompanyModel.DMATDetailsID);
            }
            objPreclearanceRequestNonImplCompany.DEMATAccountNumber = objDMATDetailsDTO.DEMATAccountNumber;
            objPreclearanceRequestNonImplCompany.PreclearanceStatusCodeId = ConstEnum.Code.PreclearanceRequestStatusConfirmed;
            objPreclearanceRequestNonImplCompany.ApprovedBy = objLoginUserDetails.LoggedInUserID;
            objPreclearanceRequestNonImplCompany.RlSearchAuditId = objPreclearanceRequestNonImplCompanyModel.RlSearchAuditId;
            objPreclearanceRequestNonImplCompany.PreclearanceDate = objPreclearanceRequestNonImplCompanyModel.PreclearanceDate;
            return objPreclearanceRequestNonImplCompany;
        }
        #endregion Add PreclearanceRequestNonImplCompanyModel data to list

        #region View Submitted Pre-clearance
        [AuthorizationPrivilegeFilter]
        public ActionResult View(int acid, long pclid)
        {
            PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel = null;
            PreclearanceRequestNonImplCompanyDTO objPreclearanceRequestNonImplCompanyDTO = null;
            LoginUserDetails objLoginUserDetails = null;
            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO = new ApplicableTradingPolicyDetailsDTO_OS();

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                objPreclearanceRequestNonImplCompanyModel = new PreclearanceRequestNonImplCompanyModel();

                using (PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL())
                {
                    objPreclearanceRequestNonImplCompanyDTO = objPreclearanceRequestNonImplCompanySL.GetPreclearanceRequestDetail(objLoginUserDetails.CompanyDBConnectionString, pclid);

                    Common.Common.CopyObjectPropertyByName(objPreclearanceRequestNonImplCompanyDTO, objPreclearanceRequestNonImplCompanyModel);
                }

                switch (objPreclearanceRequestNonImplCompanyDTO.PreclearanceRequestForCodeId)
                {
                    case ConstEnum.Code.PreclearanceRequestForSelf:
                        objPreclearanceRequestNonImplCompanyModel.PreclearanceRequestForCodeId = PreclearanceRequestFor.Self;
                        break;
                    case ConstEnum.Code.PreclearanceRequestForRelative:
                        objPreclearanceRequestNonImplCompanyModel.PreclearanceRequestForCodeId = PreclearanceRequestFor.Relative;
                        break;
                    default:
                        objPreclearanceRequestNonImplCompanyModel.PreclearanceRequestForCodeId = PreclearanceRequestFor.Self;
                        break;
                }
                int? userInfoId = objPreclearanceRequestNonImplCompanyDTO.UserInfoIdRelative == null ? objPreclearanceRequestNonImplCompanyDTO.UserInfoId : objPreclearanceRequestNonImplCompanyDTO.UserInfoIdRelative;
                ViewBag.RelativeDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserRelativeList, objPreclearanceRequestNonImplCompanyDTO.UserInfoId.ToString());

                ViewBag.TransactionDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.TransactionType);

                ViewBag.SecurityDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType);

                ViewBag.ModeOfAcquisition = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.ModeOfAcquisition);

                ViewBag.DematAccountNumberList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserDMATList, userInfoId.ToString(), ConstEnum.Code.PreClearanceType_NonImplementingCompany.ToString());

                ViewBag.UserAction = acid;

                ViewBag.Page = "View";
                ViewBag.Show_Exercise_Pool = 0;
                ViewBag.show_exercise_pool_quantity = false;
                
                int RequiredModuleID = 0;
                
                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                    TempData["EnableDisableQuantityValue"] = objInsiderInitialDisclosureDTO.EnableDisableQuantityValue;
                }
                ViewBag.RequiredModuleID = RequiredModuleID;
                

                //var EnableDisableQuantityValue = 0;
                //TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS = null;
                //using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                //{                  
                //    // objTradingTransactionMasterDTO_OS objInsiderInitialDisclosureDTO = null;
                //    objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                //    //RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                //    EnableDisableQuantityValue = objTradingTransactionMasterDTO_OS.EnableDisableQuantityValue;

                //}

                ViewBag.Fromedit = "FromEdit";
                TempData["SecuritiesToBeTradedQty"] = Convert.ToInt32(objPreclearanceRequestNonImplCompanyDTO.SecuritiesToBeTradedQty);
                TempData["SecuritiesToBeTradedValue"] = Convert.ToInt32(objPreclearanceRequestNonImplCompanyDTO.SecuritiesToBeTradedValue);
                
                if (RequiredModuleID == ConstEnum.Code.RequiredModuleOtherSecurity || RequiredModuleID == ConstEnum.Code.RequiredModuleBoth)
                {
                    using (TradingPolicySL_OS objTradingPolicySL_OS = new TradingPolicySL_OS())
                    {
                        objApplicableTradingPolicyDetailsDTO = objTradingPolicySL_OS.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString,Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.UserInfoId));
                        ViewBag.UPSISeekDeclarationRequiredFlag = objApplicableTradingPolicyDetailsDTO.PreClrSeekDeclarationForUPSIFlag;
                        ViewBag.UPSISeekDeclaration = objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration;
                    }
                    return View("CreatePreclearanceOS", objPreclearanceRequestNonImplCompanyModel);
                }
                else
                {
                    return View("Create", objPreclearanceRequestNonImplCompanyModel);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            finally
            {
                objLoginUserDetails = null;
                objPreclearanceRequestNonImplCompanyDTO = null;
                objApplicableTradingPolicyDetailsDTO = null;
            }

            return View("Create", objPreclearanceRequestNonImplCompanyModel);
        }
        #endregion View Submitted Pre-clearance

        #region Private Method
        private List<PopulateComboDTO> FillComboValues(string sDBConnectionString, int nComboType, string sParam1, string sParam2 = null)
        {
            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> lstPopulateComboDTO = null;

            string sParam3 = null;
            string sParam4 = null;
            bool bIsDefaultValue = true;

            try
            {
                objPopulateComboDTO = new PopulateComboDTO();
                lstPopulateComboDTO = new List<PopulateComboDTO>();

                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";

                if (bIsDefaultValue)
                {
                    lstPopulateComboDTO.Add(objPopulateComboDTO);
                }

                lstPopulateComboDTO.AddRange(Common.Common.GetPopulateCombo(sDBConnectionString, nComboType, sParam1, sParam2, sParam3, sParam4, sParam4, sLookupPrefix).ToList<PopulateComboDTO>());

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
        #endregion Private Method

        #region Get TMID for selected DMAT account
        [HttpPost]
        public JsonResult DMATCombo_OnChange(int nDMATDetailsID)
        {
            LoginUserDetails objLoginUserDetails = null;
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
                {
                    objDMATDetailsDTO = objDMATDetailsSL.GetDMATDetails(objLoginUserDetails.CompanyDBConnectionString, nDMATDetailsID);
                }
                return Json(objDMATDetailsDTO.TMID);
            }
            catch
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objDMATDetailsDTO = null;
            }
        }
        #endregion

        #region Edit Preclearance Request
        [AuthorizationPrivilegeFilter]
        public ViewResult Edit(int sequenceNo, bool formEAllowed, int acid)
        {
            PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel = null;
            List<PreclearanceRequestNonImplCompanyModel> preclearanceRequestList = null;
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                preclearanceRequestList = (List<PreclearanceRequestNonImplCompanyModel>)TempData["List"];
                objPreclearanceRequestNonImplCompanyModel = preclearanceRequestList.Where(x => x.SequenceNo == sequenceNo).SingleOrDefault();
                objPreclearanceRequestNonImplCompanyModel.PreclearanceStatusCodeId = null;
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.RelativeDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString());

                ViewBag.TransactionDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.TransactionType);

                ViewBag.SecurityDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType);

                ViewBag.ModeOfAcquisition = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.ModeOfAcquisition);

                ViewBag.DematAccountNumberList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_NonImplementingCompany.ToString());
                ViewBag.UserAction = acid;
                ViewBag.BackURLACID = InsiderTrading.Common.ConstEnum.UserActions.INSIDER_RESTRICTED_LIST_SEARCH;
                ViewBag.Page = "PCL";
                ViewBag.IsPreClearanceAllow = true;
                ViewBag.GridAllow = true;
                ViewBag.IsFormEtemplateMsgShow = formEAllowed;
                ViewData["PreClrModel"] = objPreclearanceRequestNonImplCompanyModel;
                ViewBag.RequiredModule = false;
            }
            catch
            {
                throw;
            }
            return View("~/Views/RestrictedList/RestrictedListSearch.cshtml", new RestrictedListModel());
        }
        #endregion


        #region Delete Preclearance Request
        [HttpPost]
        public ActionResult Delete(int sequenceNo, bool formEAllowed, int acid)
        {
            PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel = null;
            List<PreclearanceRequestNonImplCompanyModel> preclearanceRequestList = null;
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            try
            {
                preclearanceRequestList = (List<PreclearanceRequestNonImplCompanyModel>)TempData["List"];
                objPreclearanceRequestNonImplCompanyModel = preclearanceRequestList.FirstOrDefault(x => x.SequenceNo == sequenceNo);
                if (objPreclearanceRequestNonImplCompanyModel != null)
                    preclearanceRequestList.Remove(objPreclearanceRequestNonImplCompanyModel);
                TempData["List"] = preclearanceRequestList.Count == 0 ? null : preclearanceRequestList;
                TempData.Keep();
                if (preclearanceRequestList.Count == 0)
                {
                    TempData["IsPreClearanceAllow"] = false;
                    TempData["GridAllow"] = false;
                    TempData["List"] = null;
                }
                else
                {
                    TempData["IsPreClearanceAllow"] = false;
                    TempData["GridAllow"] = true;
                }
                ViewBag.IsFormEtemplateMsgShow = formEAllowed;
            }
            catch
            {
                throw;
            }
            var urlBuilder = new UrlHelper(Request.RequestContext);
            var url = urlBuilder.Action("RestrictedListSearch", "RestrictedList");
            return Json(new { status = "success", redirectUrl = url });
        }
        #endregion

        #region Delete All Preclearance Request
        [AuthorizationPrivilegeFilter]
        public ActionResult DeleteAll(int acid)
        {
            List<PreclearanceRequestNonImplCompanyModel> preclearanceRequestList = null;
            preclearanceRequestList = (List<PreclearanceRequestNonImplCompanyModel>)TempData["List"];
            if (preclearanceRequestList != null)
                preclearanceRequestList.Clear();
            TempData["List"] = preclearanceRequestList.Count == 0 ? null : preclearanceRequestList;
            TempData["IsPreClearanceAllow"] = false;
            TempData["GridAllow"] = false;
            return RedirectToAction("RestrictedListSearch", "RestrictedList");
        }
        #endregion

        #region Save All Preclearance Request
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult SaveAll(int acid)
        {
            List<PreclearanceRequestNonImplCompanyModel> preclearanceRequestList = null;
            DataTable dt_PreClearanceList;
            LoginUserDetails objLoginUserDetails = null;
            string sucess_msg = "";
            bool IsSave = false;
            try
            {
                preclearanceRequestList = (List<PreclearanceRequestNonImplCompanyModel>)TempData["List"];
                if (preclearanceRequestList.Count != 0)
                {
                    //Create DataTable
                    dt_PreClearanceList = new DataTable("PreclearanceRequestNonImplCompanyType");
                    dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceRequestId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("RlSearchAuditId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceRequestForCodeId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("UserInfoId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("UserInfoIdRelative", typeof(int)) { AllowDBNull = true });
                    dt_PreClearanceList.Columns.Add(new DataColumn("TransactionTypeCodeId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("SecurityTypeCodeId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("SecuritiesToBeTradedQty", typeof(decimal)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("SecuritiesToBeTradedValue", typeof(decimal)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("ModeOfAcquisitionCodeId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("DMATDetailsID", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceStatusCodeId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("CompanyId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("ApprovedBy", typeof(int)));

                    //Insert rows into datatable
                    foreach (var item in preclearanceRequestList)
                    {
                        DataRow draw = dt_PreClearanceList.NewRow();
                        draw["PreclearanceRequestId"] = item.PreclearanceRequestId;
                        draw["RlSearchAuditId"] = item.RlSearchAuditId;
                        switch (item.PreclearanceRequestForCodeId)
                        {
                            case PreclearanceRequestFor.Self:
                                draw["PreclearanceRequestForCodeId"] = ConstEnum.Code.PreclearanceRequestForSelf;
                                break;
                            case PreclearanceRequestFor.Relative:
                                draw["PreclearanceRequestForCodeId"] = ConstEnum.Code.PreclearanceRequestForRelative;
                                break;
                            default:
                                draw["PreclearanceRequestForCodeId"] = ConstEnum.Code.PreclearanceRequestForSelf;
                                break;
                        }
                        draw["UserInfoId"] = item.UserInfoId;
                        draw["UserInfoIdRelative"] = item.UserInfoIdRelative == null ? DBNull.Value : (object)item.UserInfoIdRelative;
                        draw["TransactionTypeCodeId"] = item.TransactionTypeCodeId;
                        draw["SecurityTypeCodeId"] = item.SecurityTypeCodeId;
                        draw["SecuritiesToBeTradedQty"] = item.SecuritiesToBeTradedQty;
                        draw["SecuritiesToBeTradedValue"] = item.SecuritiesToBeTradedValue;
                        draw["ModeOfAcquisitionCodeId"] = item.ModeOfAcquisitionCodeId;
                        draw["DMATDetailsID"] = item.DMATDetailsID;
                        draw["PreclearanceStatusCodeId"] = item.PreclearanceStatusCodeId;
                        draw["CompanyId"] = item.CompanyId;
                        draw["ApprovedBy"] = item.ApprovedBy;
                        dt_PreClearanceList.Rows.Add(draw);
                    }
                    //Save All
                    objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                    using (PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL())
                    {
                        IsSave = objPreclearanceRequestNonImplCompanySL.SavePreclearanceRequest(objLoginUserDetails.CompanyDBConnectionString, dt_PreClearanceList);

                        sucess_msg = Common.Common.getResource("dis_msg_17513");
                    }
                    preclearanceRequestList.Clear();
                    TempData["List"] = preclearanceRequestList.Count == 0 ? null : preclearanceRequestList;
                    TempData["IsPreClearanceAllow"] = false;
                    TempData["GridAllow"] = false;
                }
                else
                {
                    TempData["List"] = preclearanceRequestList;
                    TempData["IsPreClearanceAllow"] = false;
                    TempData["GridAllow"] = false;
                    return RedirectToAction("RestrictedListSearch", "RestrictedList");
                }
            }
            catch (Exception e)
            {
                throw;
            }
            return RedirectToAction("Index", "PreclearanceRequestNonImplCompany", new { acid = InsiderTrading.Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PRECLEARANCE_REQUEST_NONIMPLEMENTATION });
        }
        #endregion

        #region Cancel
        [AuthorizationPrivilegeFilter]
        public ActionResult Cancel(int acid, string page)
        {
            if (TempData["List"] == null && TempData["PreClrList"] == null)
            {
                TempData["IsPreClearanceAllow"] = false;
                TempData["GridAllow"] = false;
            }
            else
            {
                TempData["IsPreClearanceAllow"] = false;
                TempData["GridAllow"] = true;
            }
            if (page == "View")
            {
                return RedirectToAction("IndexOS", "PreclearanceRequestNonImplCompany", new { acid = InsiderTrading.Common.ConstEnum.UserActions.PreclearanceRequestOtherSecurities });
            }
            else
            {
                return RedirectToAction("RestrictedListSearch", "RestrictedList");
            }
        }
        #endregion

        #region Create Pre-clearance request other securities
        /// <summary>
        /// This method is used to create pre-clearance request
        /// </summary>
        /// <param name="acid"></param>
        /// <param name="search"></param>
        /// <param name="company"></param>
        /// <param name="backacid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult CreatePreclearanceOS(int acid, int search, int company, int backacid, bool module)
        {
            PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel = null;
            RestrictedListDTO objRestrictedListDTO = null;
            LoginUserDetails objLoginUserDetails = null;
            BalancePoolOSDTO objBalancePoolDTO = null;
            PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL();
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            TradingPolicySL_OS objTradingPolicySL_OS = new TradingPolicySL_OS();
            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO = new ApplicableTradingPolicyDetailsDTO_OS();
            CompaniesSL objCompaniesSL = new CompaniesSL();
            //flag to show check box for security type share when per-clearance for "Cash and/or Cashless partial exercise"
            bool show_exercise_pool_quantity = false;
            bool show_select_pool_quantity_checkbox = false;
            decimal virtual_exercise_qty = 0;
            decimal actual_exercise_qty = 0;
            int nIsPreviousPeriodEndSubmission;
            string sSubsequentPeriodEndOrPreciousPeriodEndResource = "";
            int RequiredModuleID = 0;
            string sSubsequentPeriodEndResourceOtherSecurity = "";
            string sSubsequentPeriodEndResourceOwnSecurity = "";
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                DateTime currentDBDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);

                objPreclearanceRequestNonImplCompanySL.GetLastPeriodEndSubmissonFlag_OS(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, out nIsPreviousPeriodEndSubmission, out sSubsequentPeriodEndOrPreciousPeriodEndResource, out sSubsequentPeriodEndResourceOtherSecurity);
                if (nIsPreviousPeriodEndSubmission == 1)
                {
                    ViewBag.IsPreviousPeriodEndSubmissionOtherSecurity = nIsPreviousPeriodEndSubmission;
                    ViewBag.SubsequentPeriodEndOrPreciousPeriodEndResource = sSubsequentPeriodEndOrPreciousPeriodEndResource;
                    ViewBag.SubsequentPeriodEndResourceOtherSecurity = sSubsequentPeriodEndResourceOtherSecurity;
                }
                //As per requirement user need to submit own and other security period end disclosure before taking preclearance vice versa (if required module is set to both)
                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                    ViewBag.RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                }
                if (RequiredModuleID == ConstEnum.Code.RequiredModuleBoth)
                {
                    objPreclearanceRequestSL.GetLastPeriodEndSubmissonFlag(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, out nIsPreviousPeriodEndSubmission, out sSubsequentPeriodEndOrPreciousPeriodEndResource, out sSubsequentPeriodEndResourceOwnSecurity);
                    if (nIsPreviousPeriodEndSubmission == 1)
                    {
                        ViewBag.IsPreviousPeriodEndSubmissionOwnSecurity = nIsPreviousPeriodEndSubmission;
                        ViewBag.SubsequentPeriodEndResourceOwnSecurity = sSubsequentPeriodEndResourceOwnSecurity;
                    }
                }

                objPreclearanceRequestNonImplCompanyModel = new PreclearanceRequestNonImplCompanyModel();
                objPreclearanceRequestNonImplCompanyModel.PreclearanceRequestForCodeId = PreclearanceRequestFor.Self;
                objPreclearanceRequestNonImplCompanyModel.PreclearanceStatusCodeId = null;
                objPreclearanceRequestNonImplCompanyModel.PreclearanceDate = currentDBDate;
                objPreclearanceRequestNonImplCompanyModel.UserInfoId = objLoginUserDetails.LoggedInUserID;
                objPreclearanceRequestNonImplCompanyModel.SecuritiesToBeTradedValue = 0;
                objPreclearanceRequestNonImplCompanyModel.RlSearchAuditId = search;

                //get company name from RL_companymasterList table
                using (RestrictedListSL objRestrictedListSL = new RestrictedListSL())
                {
                    objRestrictedListDTO = objRestrictedListSL.GetRestrictedListCompanyDetails(objLoginUserDetails.CompanyDBConnectionString, company);
                    objPreclearanceRequestNonImplCompanyModel.CompanyName = objRestrictedListDTO.CompanyName;
                    objPreclearanceRequestNonImplCompanyModel.CompanyId = (Int32)objRestrictedListDTO.RLCompanyId;
                }
                objPreclearanceRequestNonImplCompanyModel.UserInfoId = (int)objPreclearanceRequestNonImplCompanyModel.UserInfoId;

                ImplementedCompanyDTO objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);


                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL_OS.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                //check for contra trade, if user has to select or not, wheather to use security pool or do not use security pool 

                // set flag to show quantity from pool 
                show_exercise_pool_quantity = true;
                //get security details from pool - for security type - share 
                objBalancePoolDTO = objPreclearanceRequestNonImplCompanySL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId), Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.DMATDetailsID), objPreclearanceRequestNonImplCompanyModel.CompanyId);

                if (objBalancePoolDTO != null)
                {
                    virtual_exercise_qty = objBalancePoolDTO.VirtualQuantity;
                    actual_exercise_qty = objBalancePoolDTO.ActualQuantity;
                }
                //check list of securites not allowed to trade 
                List<PopulateComboDTO> TransactionList = FillComboValues(ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), null, null, null, true);
                if (TransactionList == null)
                    ViewBag.TransactionDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.TransactionType);
                else
                    ViewBag.TransactionDropDown = TransactionList;

                ViewBag.RelativeDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString());

                ViewBag.SecurityDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType);

                ViewBag.ModeOfAcquisition = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.ModeOfAcquisition);

                ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_NonImplementingCompany.ToString(), null, null, null, true);

                ViewBag.show_exercise_pool_quantity = show_exercise_pool_quantity;

                ViewBag.show_select_pool_quantity_checkbox = show_select_pool_quantity_checkbox;

                ViewBag.virtual_exercise_qty = virtual_exercise_qty;
                ViewBag.actual_exercise_qty = actual_exercise_qty;

                ViewBag.Show_Exercise_Pool = 1;
                ViewBag.UserAction = acid;
                ViewBag.BackURLACID = backacid;
                ViewBag.UserInfoIdPassDMAT = objLoginUserDetails.LoggedInUserID;
                ViewBag.UserInfoId = objLoginUserDetails.LoggedInUserID;
                ViewBag.UserTypeCodeId = objLoginUserDetails.UserTypeCodeId;
                ViewBag.UPSISeekDeclarationRequiredFlag = objApplicableTradingPolicyDetailsDTO.PreClrSeekDeclarationForUPSIFlag;
                ViewBag.UPSISeekDeclaration = objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration;
                
            }
            catch (Exception ex)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(ex.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                ViewBag.UserAction = 210;
                return RedirectToAction("RestrictedListSearch", "RestrictedList");
                //return RedirectToAction("RestrictedListSearch", "RestrictedList", new { acid = Convert.ToString(Common.ConstEnum.UserActions.INSIDER_RESTRICTED_LIST_SEARCH) }).Error(sErrMessage);
                //return PartialView("~/Views/RestrictedList/RestrictedListSearch.cshtml", new RestrictedListModel());

            }
            finally
            {
                objPreclearanceRequestNonImplCompanySL = null;
                objLoginUserDetails = null;
                objRestrictedListDTO = null;
            }

            return PartialView("CreatePreclearanceOS", objPreclearanceRequestNonImplCompanyModel);
        }
        #endregion Create Pre-clearance request other securities

        #region Save Pre-clearance request other securities
        /// <summary>
        /// This method is used to save pre-clearance request
        /// </summary>
        /// <param name="objPreclearanceRequestNonImplCompanyModel"></param>
        /// <param name="acid"></param>
        /// <param name="backacid"></param>
        /// <returns></returns>
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        //[ValidateAntiForgeryToken]
        public ActionResult SavePreclearanceRequestOS(PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel, int acid, int backacid)
        {
            LoginUserDetails objLoginUserDetails = null;
            PreclearanceRequestNonImplCompanyDTO objPreclearanceRequestNonImplCompanyDTO = null;
            List<PreclearanceRequestNonImplCompanyModel> objPreclearanceRequestNonImplCompanyList = null;
            PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompany = null;
            TradingPolicySL_OS objTradingPolicySL_OS = new TradingPolicySL_OS();
            TemplateMasterDTO objTemplateMasterDTO = null;
            string sContraTradeDate = string.Empty;
            string sucess_msg = "";
            bool out_bIsContraTrade = false;
            bool iIsAutoApproved = false;
            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objPreclearanceRequestNonImplCompanyList = new List<PreclearanceRequestNonImplCompanyModel>();
                using (var objTemplateMasterSL = new TemplateMasterSL())
                {
                    objTemplateMasterDTO = objTemplateMasterSL.GetFormETemplate(objLoginUserDetails.CompanyDBConnectionString);
                    if (objTemplateMasterDTO != null)
                    {
                        ViewBag.IsFormEtemplateMsgShow = false;
                    }
                    else
                    {
                        ViewBag.IsFormEtemplateMsgShow = true;
                    }

                }
                //Check Validations
                int preclearanceRequestId = 0;
                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL_OS.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                int tradingPolicyID = objApplicableTradingPolicyDetailsDTO.TradingPolicyId;
                using (PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL())
                {
                    int retunVal = objPreclearanceRequestNonImplCompanySL.ValidatePreclearanceRequest(objLoginUserDetails.CompanyDBConnectionString, preclearanceRequestId, tradingPolicyID, objPreclearanceRequestNonImplCompanyModel.UserInfoId, objPreclearanceRequestNonImplCompanyModel.UserInfoIdRelative,
                        objPreclearanceRequestNonImplCompanyModel.TransactionTypeCodeId, objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId, objPreclearanceRequestNonImplCompanyModel.SecuritiesToBeTradedQty, objPreclearanceRequestNonImplCompanyModel.SecuritiesToBeTradedValue, objPreclearanceRequestNonImplCompanyModel.CompanyId,
                        objPreclearanceRequestNonImplCompanyModel.ModeOfAcquisitionCodeId, objPreclearanceRequestNonImplCompanyModel.DMATDetailsID, out out_bIsContraTrade, out sContraTradeDate, out iIsAutoApproved);

                    if (iIsAutoApproved == true)
                    {
                        objPreclearanceRequestNonImplCompanyModel.IsAutoApproved = true;
                    }
                }


                if (!ViewBag.IsFormEtemplateMsgShow)
                {
                    if (TempData["PreClrList"] != null)
                    {
                        var oldList = (List<PreclearanceRequestNonImplCompanyModel>)TempData.Peek("PreClrList");
                        objPreclearanceRequestNonImplCompanyList.AddRange(oldList);
                    }
                    if (objPreclearanceRequestNonImplCompanyList != null)
                    {
                        if (objPreclearanceRequestNonImplCompanyModel.SequenceNo != 0)
                        {
                            var item = objPreclearanceRequestNonImplCompanyList.FirstOrDefault(x => x.SequenceNo == objPreclearanceRequestNonImplCompanyModel.SequenceNo);
                            if (item != null)
                                objPreclearanceRequestNonImplCompanyList.Remove(item);
                            TempData["PreClrList"] = objPreclearanceRequestNonImplCompanyList;
                            TempData.Keep();
                        }
                        objPreclearanceRequestNonImplCompany = FillListByModelValue_OS(objPreclearanceRequestNonImplCompanyModel);
                        objPreclearanceRequestNonImplCompanyList.Add(objPreclearanceRequestNonImplCompany);
                        //add list to tempdata
                        TempData["PreClrList"] = objPreclearanceRequestNonImplCompanyList;
                        TempData.Keep();
                    }
                    else
                    {
                        objPreclearanceRequestNonImplCompanyList = new List<PreclearanceRequestNonImplCompanyModel>();
                        objPreclearanceRequestNonImplCompany = FillListByModelValue_OS(objPreclearanceRequestNonImplCompanyModel);
                        //Add data to list
                        objPreclearanceRequestNonImplCompanyList.Add(objPreclearanceRequestNonImplCompany);
                        //add list to tempdata
                        TempData["PreClrList"] = objPreclearanceRequestNonImplCompanyList;
                        TempData.Keep();
                    }
                }
                else
                {
                    TempData["PreClrList"] = null;
                    TempData.Keep();
                    return RedirectToAction("RestrictedListSearch", "RestrictedList");
                }
                sucess_msg = Common.Common.getResource("dis_msg_17513");
                //Redirect to restricted list page
                ViewBag.InsiDiscoPreCleRequestNIC = ConstEnum.UserActions.PreclearanceRequestOtherSecurities;
                ViewBag.RLSearchAudId = objPreclearanceRequestNonImplCompanyModel.RlSearchAuditId;
                ViewBag.RLCompId = objPreclearanceRequestNonImplCompanyModel.CompanyId;
                ViewBag.IRListSearch = ConstEnum.UserActions.INSIDER_RESTRICTED_LIST_SEARCH;
                ViewBag.GridAllow = true;
            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                if (exp.InnerException.Data[0].ToString() == "dis_msg_53002")
                {
                    objApplicableTradingPolicyDetailsDTO = objTradingPolicySL_OS.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                    if (objApplicableTradingPolicyDetailsDTO != null)
                    {
                        List<PopulateComboDTO> lstTransactionList = FillComboValues(ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), null, null, null, false);
                        string stransaction = "";
                        foreach (var TransactionType in lstTransactionList)
                        {
                            if (Convert.ToInt32(TransactionType.Key) == objPreclearanceRequestNonImplCompanyModel.TransactionTypeCodeId)
                            {
                                stransaction = TransactionType.Value;
                            }
                        }
                        ArrayList lst = new ArrayList();
                        lst.Add(sContraTradeDate);//objApplicableTradingPolicyDetailsDTO.GenContraTradeNotAllowedLimit);
                        lst.Add(stransaction);
                        ModelState.AddModelError("Error", Common.Common.getResource("dis_msg_53002", lst));
                    }
                }
                else if (exp.InnerException.Data[0].ToString() == "dis_msg_52086")
                {
                    //string securityTypeText = null;
                    //ArrayList lst = new ArrayList();
                    //lst.Add(objPreclearanceRequestNonImplCompanyModel.CompanyName);
                    //var securityType = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType);
                    //foreach (var type in securityType)
                    //{
                    //    if (type.Key == objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId.ToString())
                    //    {
                    //        securityTypeText = type.Value;
                    //    }
                    //}
                    //lst.Add(securityTypeText);
                    ModelState.AddModelError("Error", Common.Common.getResource("dis_msg_52086"));
                }
                else{
                        string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                        ModelState.AddModelError("error", sErrMessage);
                }

                ViewBag.RelativeDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString());

                List<PopulateComboDTO> TransactionList = FillComboValues(ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), null, null, null, true);
                if (TransactionList == null)
                    ViewBag.TransactionDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.TransactionType);
                else
                    ViewBag.TransactionDropDown = TransactionList;

                ViewBag.SecurityDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType);

                if (objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId == 0)
                {
                    ViewBag.ModeOfAcquisition = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ModeOfAcquisition, null, null, null, null, true);
                }
                else
                {
                    ViewBag.ModeOfAcquisition = FillComboValues(InsiderTrading.Common.ConstEnum.ComboType.ListofModeOfAcquisitionapplicableTradingPolicyOS, objApplicableTradingPolicyDetailsDTO.TradingPolicyId.ToString(), objPreclearanceRequestNonImplCompanyModel.TransactionTypeCodeId.ToString(), objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId.ToString(), null, null, true);
                }

                if (objPreclearanceRequestNonImplCompanyModel.UserInfoIdRelative != null)
                {
                    ViewBag.DematAccountNumberList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserDMATList, objPreclearanceRequestNonImplCompanyModel.UserInfoIdRelative.ToString(), ConstEnum.Code.PreClearanceType_NonImplementingCompany.ToString());
                }
                else
                {
                    ViewBag.DematAccountNumberList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_NonImplementingCompany.ToString());
                }

                ViewBag.UserAction = acid;
                ViewBag.BackURLACID = backacid;
                ViewBag.Show_Exercise_Pool = 1;
                ViewBag.UserInfoIdPassDMAT = objLoginUserDetails.LoggedInUserID;
                ViewBag.UserInfoId = objLoginUserDetails.LoggedInUserID;
                ViewBag.IsPreClearanceAllow = true;
                if (TempData["PreClrList"] != null)
                {
                    ViewBag.GridAllow = true;
                    TempData["GridAllow"] = true;
                }
                else
                {
                    ViewBag.GridAllow = false;
                    TempData["GridAllow"] = false;
                }
                ViewData["PreClrModel"] = objPreclearanceRequestNonImplCompanyModel;
                ViewBag.RequiredModule = true;
                ViewBag.IsFormEtemplateMsgShow = objTemplateMasterDTO != null ? false : true;
                return View("~/Views/RestrictedList/RestrictedListSearch.cshtml", new RestrictedListModel());
            }
            finally
            {
                objLoginUserDetails = null;
            }
            TempData["IsPreClearanceAllow"] = false;
            TempData["GridAllow"] = true;
            return RedirectToAction("RestrictedListSearch", "RestrictedList").Success(sucess_msg);
        }
        #endregion Save Pre-clearance request other securities

        #region Add PreclearanceRequestNonImplCompanyModel data to list for other securities
        public PreclearanceRequestNonImplCompanyModel FillListByModelValue_OS(PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel)
        {
            LoginUserDetails objLoginUserDetails = null;
            int sequenceNo;
            UserInfoSL objUserInfoSL = new UserInfoSL();
            InsiderTradingDAL.UserInfoDTO objUserInfoDTO = null;
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();

            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompany = new PreclearanceRequestNonImplCompanyModel();
            if (objPreclearanceRequestNonImplCompanyModel.SequenceNo != 0)
            {
                objPreclearanceRequestNonImplCompany.SequenceNo = objPreclearanceRequestNonImplCompanyModel.SequenceNo;
            }
            else
            {
                sequenceNo = Convert.ToInt32(TempData["SequenceNo"]);
                objPreclearanceRequestNonImplCompany.SequenceNo = (sequenceNo == 0) ? 1 : sequenceNo + 1;
                TempData["SequenceNo"] = objPreclearanceRequestNonImplCompany.SequenceNo;
                TempData.Keep();
            }
            objPreclearanceRequestNonImplCompany.CompanyId = objPreclearanceRequestNonImplCompanyModel.CompanyId;
            objPreclearanceRequestNonImplCompany.CompanyName = objPreclearanceRequestNonImplCompanyModel.CompanyName;
            objPreclearanceRequestNonImplCompany.PreclearanceRequestForCodeId = objPreclearanceRequestNonImplCompanyModel.PreclearanceRequestForCodeId;
            switch (Convert.ToInt32(objPreclearanceRequestNonImplCompany.PreclearanceRequestForCodeId))
            {
                case ConstEnum.Code.PreclearanceRequestForSelf:
                    objPreclearanceRequestNonImplCompany.TradedFor = "Self";
                    break;
                case ConstEnum.Code.PreclearanceRequestForRelative:
                    objPreclearanceRequestNonImplCompany.TradedFor = "Relative";
                    break;
            }
            if (Convert.ToInt32(objPreclearanceRequestNonImplCompany.PreclearanceRequestForCodeId) == ConstEnum.Code.PreclearanceRequestForSelf)
            {
                objPreclearanceRequestNonImplCompany.UserInfoId = objPreclearanceRequestNonImplCompanyModel.UserInfoId;
                objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestNonImplCompanyModel.UserInfoId);
                objPreclearanceRequestNonImplCompany.EmployeeName = objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
            }
            else
            {
                objPreclearanceRequestNonImplCompany.UserInfoId = objPreclearanceRequestNonImplCompanyModel.UserInfoId;
                objPreclearanceRequestNonImplCompany.UserInfoIdRelative = objPreclearanceRequestNonImplCompanyModel.UserInfoIdRelative;
                int userrelativeId = Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.UserInfoIdRelative);
                objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, userrelativeId);
                objPreclearanceRequestNonImplCompany.EmployeeName = objUserInfoDTO.FirstName + " " + objUserInfoDTO.LastName;
            }
            objPreclearanceRequestNonImplCompany.TransactionTypeCodeId = objPreclearanceRequestNonImplCompanyModel.TransactionTypeCodeId;
            var transactionType = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.TransactionType);
            foreach (var type in transactionType)
            {
                if (type.Key == objPreclearanceRequestNonImplCompanyModel.TransactionTypeCodeId.ToString())
                {
                    objPreclearanceRequestNonImplCompany.TransactionType = type.Value;
                }
            }
            objPreclearanceRequestNonImplCompany.SecurityTypeCodeId = objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId;
            var securityType = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType);
            foreach (var type in securityType)
            {
                if (type.Key == objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId.ToString())
                {
                    objPreclearanceRequestNonImplCompany.SecurityType = type.Value;
                }
            }
            objPreclearanceRequestNonImplCompany.SecuritiesToBeTradedQty = objPreclearanceRequestNonImplCompanyModel.SecuritiesToBeTradedQty;
            objPreclearanceRequestNonImplCompany.SecuritiesToBeTradedValue = objPreclearanceRequestNonImplCompanyModel.SecuritiesToBeTradedValue;
            objPreclearanceRequestNonImplCompany.ModeOfAcquisitionCodeId = objPreclearanceRequestNonImplCompanyModel.ModeOfAcquisitionCodeId;
            var modeOfAcq = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.ModeOfAcquisition);
            foreach (var type in modeOfAcq)
            {
                if (type.Key == objPreclearanceRequestNonImplCompanyModel.ModeOfAcquisitionCodeId.ToString())
                {
                    objPreclearanceRequestNonImplCompany.ModeOfAcquisition = type.Value;
                }
            }
            objPreclearanceRequestNonImplCompany.DMATDetailsID = objPreclearanceRequestNonImplCompanyModel.DMATDetailsID;
            using (DMATDetailsSL objDMATDetailsSL = new DMATDetailsSL())
            {
                objDMATDetailsDTO = objDMATDetailsSL.GetDMATDetails(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestNonImplCompanyModel.DMATDetailsID);
            }
            objPreclearanceRequestNonImplCompany.DEMATAccountNumber = objDMATDetailsDTO.DEMATAccountNumber;
            objPreclearanceRequestNonImplCompany.PreclearanceStatusCodeId = ConstEnum.Code.PreclearanceRequestStatusConfirmed;
            objPreclearanceRequestNonImplCompany.ApprovedBy = objLoginUserDetails.LoggedInUserID;
            objPreclearanceRequestNonImplCompany.RlSearchAuditId = objPreclearanceRequestNonImplCompanyModel.RlSearchAuditId;
            objPreclearanceRequestNonImplCompany.PreclearanceDate = objPreclearanceRequestNonImplCompanyModel.PreclearanceDate;
            return objPreclearanceRequestNonImplCompany;
        }
        #endregion Add PreclearanceRequestNonImplCompanyModel data to list for other securities

        #region Save All Preclearance Request other securities
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult SaveAll_OS(int acid)
        {
            List<PreclearanceRequestNonImplCompanyModel> preclearanceRequestList = null;
            DataTable dt_PreClearanceList;
            LoginUserDetails objLoginUserDetails = null;
            string sucess_msg = "";
            PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL();
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            BalancePoolOSDTO objBalancePoolDTO = null;
            int RequiredModuleID = 0;
            int nIsPreviousPeriodEndSubmission;
            string sSubsequentPeriodEndOrPreciousPeriodEndResource = "";
            bool bReturn = false;
            string sSubsequentPeriodEndResourceOtherSecurity = "";
            string sSubsequentPeriodEndResourceOwnSecurity = "";
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                preclearanceRequestList = (List<PreclearanceRequestNonImplCompanyModel>)TempData["PreClrList"];
                if (preclearanceRequestList.Count != 0)
                {
                    var checkDuplicRecord = preclearanceRequestList.GroupBy(x => new { x.CompanyId, x.SecurityType, x.DEMATAccountNumber, x.CompanyName })
                        .Where(gr => gr.Count() > 1)
                        .Select(y => new PreclearanceRequestNonImplCompanyModel()
                        {
                            CompanyId = y.Key.CompanyId,
                            CompanyName = y.Key.CompanyName,
                            DEMATAccountNumber = y.Key.DEMATAccountNumber,
                            SecurityType = y.Key.SecurityType
                        });
                    foreach (var request in checkDuplicRecord)
                    {
                        string sErrMessage = Common.Common.getResource("dis_msg_53146").Replace("$1", request.CompanyName).Replace("$2", request.DEMATAccountNumber).Replace("$3", request.SecurityType);
                        ModelState.AddModelError("error", sErrMessage);
                    }

                    var tempSell = preclearanceRequestList.Where(p => p.TransactionTypeCodeId == Common.ConstEnum.Code.TransactionTypeSell)
                        .GroupBy(x => new { x.CompanyId, x.SecurityTypeCodeId, x.DMATDetailsID, x.CompanyName })
                        .Select(y => new PreclearanceRequestNonImplCompanyModel()
                        {
                            SecuritiesToBeTradedQty = y.Sum(s => s.SecuritiesToBeTradedQty),
                            CompanyId = y.Key.CompanyId,
                            CompanyName = y.Key.CompanyName,
                            DMATDetailsID = y.Key.DMATDetailsID,
                            SecurityTypeCodeId = y.Key.SecurityTypeCodeId
                        });
                    foreach (var request in tempSell)
                    {
                        if (request.CompanyId != 0 && request.DMATDetailsID != 0)
                        {
                            objBalancePoolDTO = objPreclearanceRequestNonImplCompanySL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, request.SecurityTypeCodeId, request.DMATDetailsID, request.CompanyId);
                            if (objBalancePoolDTO != null)
                            {
                                if (objBalancePoolDTO.VirtualQuantity < request.SecuritiesToBeTradedQty)
                                {
                                    string sErrMessage = Common.Common.getResource("tra_msg_53079").Replace("$1", "Sell").Replace("$2", request.CompanyName);
                                    ModelState.AddModelError("error", sErrMessage);
                                }
                            }
                        }
                    }

                    var tempPledge = preclearanceRequestList.Where(p => p.TransactionTypeCodeId == Common.ConstEnum.Code.TransactionTypePledge || p.TransactionTypeCodeId == Common.ConstEnum.Code.TransactionTypePledgeInvoke)
                        .GroupBy(x => new { x.CompanyId, x.SecurityTypeCodeId, x.DMATDetailsID, x.CompanyName })
                        .Select(y => new PreclearanceRequestNonImplCompanyModel()
                        {
                            SecuritiesToBeTradedQty = y.Sum(s => s.SecuritiesToBeTradedQty),
                            CompanyId = y.Key.CompanyId,
                            CompanyName = y.Key.CompanyName,
                            DMATDetailsID = y.Key.DMATDetailsID,
                            SecurityTypeCodeId = y.Key.SecurityTypeCodeId
                        });
                    foreach (var request in tempPledge)
                    {
                        if (request.CompanyId != 0 && request.DMATDetailsID != 0)
                        {
                            objBalancePoolDTO = objPreclearanceRequestNonImplCompanySL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, request.SecurityTypeCodeId, request.DMATDetailsID, request.CompanyId);
                            if (objBalancePoolDTO != null)
                            {
                                if (objBalancePoolDTO.VirtualQuantity < request.SecuritiesToBeTradedQty)
                                {
                                    string sErrMessage = Common.Common.getResource("tra_msg_53079").Replace("$1", "Pledge").Replace("$2", request.CompanyName);
                                    ModelState.AddModelError("error", sErrMessage);
                                }
                            }
                        }
                    }
                    var tempPledgeRevoke = preclearanceRequestList.Where(p => p.TransactionTypeCodeId == Common.ConstEnum.Code.TransactionTypePledgeRevoke)
                        .GroupBy(x => new { x.CompanyId, x.SecurityTypeCodeId, x.DMATDetailsID, x.CompanyName })
                        .Select(y => new PreclearanceRequestNonImplCompanyModel()
                        {
                            SecuritiesToBeTradedQty = y.Sum(s => s.SecuritiesToBeTradedQty),
                            CompanyId = y.Key.CompanyId,
                            CompanyName = y.Key.CompanyName,
                            DMATDetailsID = y.Key.DMATDetailsID,
                            SecurityTypeCodeId = y.Key.SecurityTypeCodeId
                        });
                    foreach (var request in tempPledgeRevoke)
                    {
                        if (request.CompanyId != 0 && request.DMATDetailsID != 0)
                        {
                            objBalancePoolDTO = objPreclearanceRequestNonImplCompanySL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, request.SecurityTypeCodeId, request.DMATDetailsID, request.CompanyId);
                            if (objBalancePoolDTO != null)
                            {
                                if (objBalancePoolDTO.PledgeQuantity < request.SecuritiesToBeTradedQty)
                                {
                                    string sErrMessage = Common.Common.getResource("tra_msg_53079").Replace("$1", "Pledge Revoke").Replace("$2", request.CompanyName);
                                    ModelState.AddModelError("error", sErrMessage);
                                }
                            }
                        }
                    }
                    if (ModelState.Count > 0 && ModelState.Keys.Contains("error") == true)
                    {
                        preclearanceRequestList[0].PreclearanceStatusCodeId = null;
                        ViewData["PreClrModel"] = (PreclearanceRequestNonImplCompanyModel)preclearanceRequestList[0];
                        ViewBag.IsPreClearanceAllow = true;
                        ViewBag.GridAllow = true;
                        using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                        {
                            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                            objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                            RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                        }
                        if (RequiredModuleID == ConstEnum.Code.RequiredModuleOtherSecurity || RequiredModuleID == ConstEnum.Code.RequiredModuleBoth)
                        {
                            ViewBag.RequiredModule = true;
                        }
                        else
                        {
                            ViewBag.RequiredModule = false;
                        }
                        TemplateMasterDTO objTemplateMasterDTO = null;
                        using (var objTemplateMasterSL = new TemplateMasterSL())
                        {
                            objTemplateMasterDTO = objTemplateMasterSL.GetFormETemplate(objLoginUserDetails.CompanyDBConnectionString);
                            if (objTemplateMasterDTO != null)
                            {
                                ViewBag.IsFormEtemplateMsgShow = false;
                            }
                            else
                            {
                                ViewBag.IsFormEtemplateMsgShow = true;
                            }

                        }
                        ViewBag.RelativeDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString());

                        ViewBag.TransactionDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.TransactionType);

                        ViewBag.SecurityDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType);

                        ViewBag.ModeOfAcquisition = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.ModeOfAcquisition);

                        ViewBag.DematAccountNumberList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_NonImplementingCompany.ToString());
                        ViewBag.UserAction = acid;
                        ViewBag.BackURLACID = InsiderTrading.Common.ConstEnum.UserActions.INSIDER_RESTRICTED_LIST_SEARCH;
                        objPreclearanceRequestNonImplCompanySL.GetLastPeriodEndSubmissonFlag_OS(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, out nIsPreviousPeriodEndSubmission, out sSubsequentPeriodEndOrPreciousPeriodEndResource, out sSubsequentPeriodEndResourceOtherSecurity);
                        if (nIsPreviousPeriodEndSubmission == 1)
                        {
                            ViewBag.IsPreviousPeriodEndSubmission = nIsPreviousPeriodEndSubmission;
                            ViewBag.SubsequentPeriodEndOrPreciousPeriodEndResource = sSubsequentPeriodEndOrPreciousPeriodEndResource;
                            ViewBag.SubsequentPeriodEndResourceOtherSecurity = sSubsequentPeriodEndResourceOtherSecurity;
                        }
                        if (RequiredModuleID == ConstEnum.Code.RequiredModuleBoth)
                        {
                            objPreclearanceRequestSL.GetLastPeriodEndSubmissonFlag(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, out nIsPreviousPeriodEndSubmission, out sSubsequentPeriodEndOrPreciousPeriodEndResource, out sSubsequentPeriodEndResourceOwnSecurity);
                            if (nIsPreviousPeriodEndSubmission == 1)
                            {
                                ViewBag.IsPreviousPeriodEndSubmissionOwnSecurity = nIsPreviousPeriodEndSubmission;
                                ViewBag.SubsequentPeriodEndResourceOwnSecurity = sSubsequentPeriodEndResourceOwnSecurity;
                            }
                        }
                        ViewBag.Show_Exercise_Pool = 1;
                        return View("~/Views/RestrictedList/RestrictedListSearch.cshtml", new RestrictedListModel());
                    }
                    else
                    {
                        if (preclearanceRequestList[0].PreclearanceStatusCodeId == null)
                            preclearanceRequestList[0].PreclearanceStatusCodeId = 144001;
                    }

                    //Create DataTable
                    dt_PreClearanceList = new DataTable("PreclearanceRequestNonImplCompanyType");
                    dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceRequestId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("RlSearchAuditId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceRequestForCodeId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("UserInfoId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("UserInfoIdRelative", typeof(int)) { AllowDBNull = true });
                    dt_PreClearanceList.Columns.Add(new DataColumn("TransactionTypeCodeId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("SecurityTypeCodeId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("SecuritiesToBeTradedQty", typeof(decimal)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("SecuritiesToBeTradedValue", typeof(decimal)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("ModeOfAcquisitionCodeId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("DMATDetailsID", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceStatusCodeId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("CompanyId", typeof(int)));
                    dt_PreClearanceList.Columns.Add(new DataColumn("ApprovedBy", typeof(int)));

                    //Insert rows into datatable
                    foreach (var item in preclearanceRequestList)
                    {
                        DataRow draw = dt_PreClearanceList.NewRow();
                        draw["PreclearanceRequestId"] = item.PreclearanceRequestId;
                        draw["RlSearchAuditId"] = item.RlSearchAuditId;
                        switch (item.PreclearanceRequestForCodeId)
                        {
                            case PreclearanceRequestFor.Self:
                                draw["PreclearanceRequestForCodeId"] = ConstEnum.Code.PreclearanceRequestForSelf;
                                break;
                            case PreclearanceRequestFor.Relative:
                                draw["PreclearanceRequestForCodeId"] = ConstEnum.Code.PreclearanceRequestForRelative;
                                break;
                            default:
                                draw["PreclearanceRequestForCodeId"] = ConstEnum.Code.PreclearanceRequestForSelf;
                                break;
                        }
                        draw["UserInfoId"] = item.UserInfoId;
                        draw["UserInfoIdRelative"] = item.UserInfoIdRelative == null ? DBNull.Value : (object)item.UserInfoIdRelative;
                        draw["TransactionTypeCodeId"] = item.TransactionTypeCodeId;
                        draw["SecurityTypeCodeId"] = item.SecurityTypeCodeId;
                        draw["SecuritiesToBeTradedQty"] = item.SecuritiesToBeTradedQty;
                        draw["SecuritiesToBeTradedValue"] = item.SecuritiesToBeTradedValue;
                        draw["ModeOfAcquisitionCodeId"] = item.ModeOfAcquisitionCodeId;
                        draw["DMATDetailsID"] = item.DMATDetailsID;
                        draw["PreclearanceStatusCodeId"] = item.PreclearanceStatusCodeId;
                        draw["CompanyId"] = item.CompanyId;
                        draw["ApprovedBy"] = item.ApprovedBy;
                        dt_PreClearanceList.Rows.Add(draw);
                    }
                    //Save All
                    int? preclearanceRequestId = null;
                    bool? preclearanceNotTakenFlag = false;
                    int? reasonForNotTradingCodeId = null;
                    string reasonForNotTradingText = null;
                    int? userID = null;
                    string preclearanceStatusCodeId = null;
                    string reasonForRejection = null;
                    string reasonForApproval = null;
                    int? ReasonForApprovalCodeId = null;
                    int? displaySequenceNo = null;
                    objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                    bReturn = objPreclearanceRequestNonImplCompanySL.SavePreclearanceRequest_OS(objLoginUserDetails.CompanyDBConnectionString, dt_PreClearanceList, preclearanceRequestId, preclearanceNotTakenFlag, reasonForNotTradingCodeId,
                    reasonForNotTradingText, userID, preclearanceStatusCodeId, reasonForRejection, reasonForApproval, ReasonForApprovalCodeId, displaySequenceNo);
                    if (bReturn)
                    {
                        sucess_msg = Common.Common.getResource("dis_msg_17513");
                    }
                    preclearanceRequestList.Clear();
                    TempData["PreClrList"] = preclearanceRequestList.Count == 0 ? null : preclearanceRequestList;
                    TempData["IsPreClearanceAllow"] = false;
                    TempData["GridAllow"] = false;
                }
                else
                {
                    TempData["PreClrList"] = preclearanceRequestList;
                    TempData["IsPreClearanceAllow"] = false;
                    TempData["GridAllow"] = false;
                    return RedirectToAction("RestrictedListSearch", "RestrictedList");
                }
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                objPreclearanceRequestNonImplCompanySL = null;
                objLoginUserDetails = null;
            }
            return RedirectToAction("IndexOS", "PreclearanceRequestNonImplCompany", new { acid = InsiderTrading.Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_PRECLEARANCE_REQUEST_NONIMPLEMENTATION });
        }
        #endregion Save All Preclearance Request other securities

        #region Delete Preclearance Request other securities
        [HttpPost]
        public ActionResult Delete_OS(int sequenceNo, bool formEAllowed, int acid)
        {
            PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel = null;
            List<PreclearanceRequestNonImplCompanyModel> preclearanceRequestList = null;
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                preclearanceRequestList = (List<PreclearanceRequestNonImplCompanyModel>)TempData["PreClrList"];
                objPreclearanceRequestNonImplCompanyModel = preclearanceRequestList.FirstOrDefault(x => x.SequenceNo == sequenceNo);
                if (objPreclearanceRequestNonImplCompanyModel != null)
                    preclearanceRequestList.Remove(objPreclearanceRequestNonImplCompanyModel);
                TempData["PreClrList"] = preclearanceRequestList.Count == 0 ? null : preclearanceRequestList;
                TempData.Keep();
                if (preclearanceRequestList.Count == 0)
                {
                    TempData["IsPreClearanceAllow"] = false;
                    TempData["GridAllow"] = false;
                    TempData["PreClrList"] = null;
                }
                else
                {
                    TempData["IsPreClearanceAllow"] = false;
                    TempData["GridAllow"] = true;
                }
                ViewBag.IsFormEtemplateMsgShow = formEAllowed;
                int RequiredModuleID = 0;
                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                }
                if (RequiredModuleID == ConstEnum.Code.RequiredModuleOtherSecurity || RequiredModuleID == ConstEnum.Code.RequiredModuleBoth)
                {
                    ViewBag.RequiredModule = true;
                }
                else
                {
                    ViewBag.RequiredModule = false;
                }
            }
            catch
            {
                throw;
            }
            var urlBuilder = new UrlHelper(Request.RequestContext);
            var url = urlBuilder.Action("RestrictedListSearch", "RestrictedList");
            return Json(new { status = "success", redirectUrl = url });
        }
        #endregion

        #region Delete All Preclearance Request other securities
        [AuthorizationPrivilegeFilter]
        public ActionResult DeleteAll_OS(int acid)
        {
            List<PreclearanceRequestNonImplCompanyModel> preclearanceRequestList = null;
            preclearanceRequestList = (List<PreclearanceRequestNonImplCompanyModel>)TempData["PreClrList"];
            if (preclearanceRequestList != null)
                preclearanceRequestList.Clear();
            TempData["PreClrList"] = preclearanceRequestList.Count == 0 ? null : preclearanceRequestList;
            TempData["IsPreClearanceAllow"] = false;
            TempData["GridAllow"] = false;
            return RedirectToAction("RestrictedListSearch", "RestrictedList");
        }
        #endregion other securities

        #region Edit Preclearance Request
        [AuthorizationPrivilegeFilter]
        public ViewResult Edit_OS(int sequenceNo, bool formEAllowed, int acid)
        {
            PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel = null;
            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO = new ApplicableTradingPolicyDetailsDTO_OS();
            List<PreclearanceRequestNonImplCompanyModel> preclearanceRequestList = null;
            LoginUserDetails objLoginUserDetails = null;
            BalancePoolOSDTO objBalancePoolDTO = null;
            PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL();
            TradingPolicySL_OS objTradingPolicySL_OS = new TradingPolicySL_OS();
            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO_OS = new ApplicableTradingPolicyDetailsDTO_OS();
            CompaniesSL objCompaniesSL = new CompaniesSL();
            //flag to show check box for security type share when per-clearance for "Cash and/or Cashless partial exercise"
            bool show_exercise_pool_quantity = false;
            bool show_select_pool_quantity_checkbox = false;
            decimal virtual_exercise_qty = 0;
            decimal actual_exercise_qty = 0;
            try
            {
                preclearanceRequestList = (List<PreclearanceRequestNonImplCompanyModel>)TempData["PreClrList"];
                objPreclearanceRequestNonImplCompanyModel = preclearanceRequestList.Where(x => x.SequenceNo == sequenceNo).SingleOrDefault();
                objPreclearanceRequestNonImplCompanyModel.PreclearanceStatusCodeId = null;
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                ViewBag.RelativeDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString());

                InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;

                objApplicableTradingPolicyDetailsDTO_OS = objTradingPolicySL_OS.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                List<PopulateComboDTO> TransactionList = FillComboValues(ConstEnum.ComboType.TransactionTypeByTradingPolicy_OS, objApplicableTradingPolicyDetailsDTO_OS.TradingPolicyId.ToString(), InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestNonImplementingCompany.ToString(), null, null, null, true);
                if (TransactionList == null)
                    ViewBag.TransactionDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.TransactionType);
                else
                    ViewBag.TransactionDropDown = TransactionList;

                ViewBag.SecurityDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.SecurityType);

                ViewBag.ModeOfAcquisition = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, Common.ConstEnum.CodeGroup.ModeOfAcquisition);

                if (objPreclearanceRequestNonImplCompanyModel.UserInfoIdRelative != null)
                {
                    ViewBag.DematAccountNumberList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserDMATList, objPreclearanceRequestNonImplCompanyModel.UserInfoIdRelative.ToString(), ConstEnum.Code.PreClearanceType_NonImplementingCompany.ToString());
                }
                else
                {
                    ViewBag.DematAccountNumberList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_NonImplementingCompany.ToString());
                }

                ViewBag.UserAction = acid;
                ViewBag.BackURLACID = InsiderTrading.Common.ConstEnum.UserActions.INSIDER_RESTRICTED_LIST_SEARCH;
                ViewBag.IsPreClearanceAllow = true;
                ViewBag.GridAllow = true;
                ViewBag.IsFormEtemplateMsgShow = formEAllowed;
                int RequiredModuleID = 0;
                objInsiderInitialDisclosureDTO = null;
                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                }
                if (RequiredModuleID == ConstEnum.Code.RequiredModuleOtherSecurity || RequiredModuleID == ConstEnum.Code.RequiredModuleBoth)
                {
                    ViewBag.RequiredModule = true;
                }
                else
                {
                    ViewBag.RequiredModule = false;
                }

                //check for contra trade, if user has to select or not, wheather to use security pool or do not use security pool 
                if(ViewBag.RequiredModule == true)
                {
                    using (TradingPolicySL_OS objTradingPolicySL_OSTP = new TradingPolicySL_OS())
                    {
                        objApplicableTradingPolicyDetailsDTO = objTradingPolicySL_OSTP.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.UserInfoId));
                        ViewBag.UPSISeekDeclarationRequiredFlag = objApplicableTradingPolicyDetailsDTO.PreClrSeekDeclarationForUPSIFlag;
                        ViewBag.UPSISeekDeclaration = objApplicableTradingPolicyDetailsDTO.PreClrUPSIDeclaration;
                    }
                }



                // set flag to show quantity from pool 
                show_exercise_pool_quantity = true;
                //get security details from pool
                objBalancePoolDTO = objPreclearanceRequestNonImplCompanySL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestNonImplCompanyModel.UserInfoId, Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId), Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.DMATDetailsID), objPreclearanceRequestNonImplCompanyModel.CompanyId);

                if (objBalancePoolDTO != null)
                {
                    virtual_exercise_qty = objBalancePoolDTO.VirtualQuantity;
                    actual_exercise_qty = objBalancePoolDTO.ActualQuantity;
                }
                ViewData["PreClrModel"] = objPreclearanceRequestNonImplCompanyModel;
                ViewBag.show_exercise_pool_quantity = show_exercise_pool_quantity;

                ViewBag.show_select_pool_quantity_checkbox = show_select_pool_quantity_checkbox;

                ViewBag.virtual_exercise_qty = virtual_exercise_qty;
                ViewBag.actual_exercise_qty = actual_exercise_qty;

                ViewBag.Show_Exercise_Pool = 1;
                ViewBag.UserAction = acid;
                var EnableDisableQuantityValue = 0;
                using (TradingTransactionSL_OS objTradingTransactionSL_OS = new TradingTransactionSL_OS())
                {
                    TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO_OS = null;
                    // objTradingTransactionMasterDTO_OS objInsiderInitialDisclosureDTO = null;
                    objTradingTransactionMasterDTO_OS = objTradingTransactionSL_OS.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                    //RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
                    EnableDisableQuantityValue = objTradingTransactionMasterDTO_OS.EnableDisableQuantityValue;
                    ViewBag.EnableDisableQuantityValue = objTradingTransactionMasterDTO_OS.EnableDisableQuantityValue;
                }
                ViewBag.SecuritiesToBeTradedQty = Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.SecuritiesToBeTradedQty);
                ViewBag.SecuritiesToBeTradedValue =Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.SecuritiesToBeTradedValue);
                ViewBag.Fromedit = "FromEdit";
            }
            catch
            {
                throw;
            }
            return View("~/Views/RestrictedList/RestrictedListSearch.cshtml", new RestrictedListModel());
        }
        #endregion

        #region Pre-clearance List other security for insider
        public ActionResult IndexOS(int acid, string PreClearanceRequestID = "", string PreClearanceRequestStatus = "", string TradeDetailsID = "", string IsFromDashboard = "", int TransactionMasterID = 0, int SecurityTypeId = 0, string TransactionDate = null, int TransactionTypeId = 0, string IsApprovedPCL = "")
        {
            LoginUserDetails objLoginUserDetails = null;
            UserInfoDTO objUserInfoDTO = null;
            UserInfoSL objUserInfoSL = new UserInfoSL();
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            ViewBag.RequestStatusList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null);
            ViewBag.TransactionTypeList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null);
            objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
            ViewBag.PreClearanceRequestID = PreClearanceRequestID;
            ViewBag.PreClearanceRequestStatus = PreClearanceRequestStatus;
            ViewBag.TradeDetailsID = TradeDetailsID;
            ViewBag.IsFromDashboard = IsFromDashboard;
            ViewBag.TransactionMasterId = TransactionMasterID;
            ViewBag.SecurityType = SecurityTypeId;
            ViewBag.TransactionDate = TransactionDate;
            ViewBag.TransactionType = TransactionTypeId;

            ViewBag.GridType = ConstEnum.GridType.PreclearanceList_OS_ForInsider;
            ViewBag.UserID = objLoginUserDetails.LoggedInUserID;
            return View();
        }
        #endregion

        #region Pre-clearance List other security for CO
        [AuthorizationPrivilegeFilter]
        public ActionResult CoIndex_OS(int acid)
        {
            LoginUserDetails objLoginUserDetails = null;
            UserInfoDTO objUserInfoDTO = null;
            UserInfoSL objUserInfoSL = new UserInfoSL();
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            ViewBag.RequestStatusList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null);
            ViewBag.TransactionTypeList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null);
            objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
            //ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            ViewBag.GridType = Common.ConstEnum.GridType.PreclearanceList_OS_ForCO;
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "Select";
            List<PopulateComboDTO> lstDepartmentList = new List<PopulateComboDTO>();
            lstDepartmentList.Add(objPopulateComboDTO);
            lstDepartmentList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.ReasonforApproval).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.ReasonForApproveDropDown = lstDepartmentList;
            return View("CoIndex_OS");
        }
        #endregion Pre-clearance List other security for CO

        #region LoadBalanceDMATwise
        public ActionResult LoadBalanceDMATwise(PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel)
        {
            BalancePoolOSDTO objBalancePoolDTO = null;
            PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicySL_OS objTradingPolicySL = new TradingPolicySL_OS();
            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO = new ApplicableTradingPolicyDetailsDTO_OS();
            CompaniesSL objCompaniesSL = new CompaniesSL();
            //flag to show check box for security type share when per-clearance for "Cash and/or Cashless partial exercise"
            bool show_exercise_pool_quantity = false;
            bool show_select_pool_quantity_checkbox = false;
            decimal virtual_exercise_qty = 0;
            decimal actual_exercise_qty = 0;
            try
            {
                InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                }
                if (objInsiderInitialDisclosureDTO.RequiredModule == InsiderTrading.Common.ConstEnum.Code.RequiredModuleBoth && objInsiderInitialDisclosureDTO.RequiredModule == InsiderTrading.Common.ConstEnum.Code.RequiredModuleOwnSecurity)
                {
                    objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestNonImplCompanyModel.UserInfoId);
                }
                ImplementedCompanyDTO objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);

                //check for contra trade, if user has to select or not, wheather to use security pool or do not use security pool 

                // set flag to show quantity from pool 
                show_exercise_pool_quantity = true;

                try
                {
                    objPreclearanceRequestNonImplCompanyModel.UserInfoId = (int)objPreclearanceRequestNonImplCompanyModel.UserInfoId;

                    //get security details from pool - for security type - share 
                    objBalancePoolDTO = objPreclearanceRequestNonImplCompanySL.GetSecurityBalanceDetailsFromPool(objLoginUserDetails.CompanyDBConnectionString, objPreclearanceRequestNonImplCompanyModel.UserInfoId, Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId), Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.DMATDetailsID), objPreclearanceRequestNonImplCompanyModel.CompanyId);

                    if (objBalancePoolDTO != null)
                    {
                        virtual_exercise_qty = objBalancePoolDTO.VirtualQuantity;
                        actual_exercise_qty = objBalancePoolDTO.ActualQuantity;
                    }
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("Error", Common.Common.GetErrorMessage(ex));
                    return View("CreatePreclearanceOS", objPreclearanceRequestNonImplCompanyModel);
                }

                if (objApplicableTradingPolicyDetailsDTO.GenCashAndCashlessPartialExciseOptionForContraTrade == ConstEnum.Code.UserSelectionOnPreClearanceAndTradeDetailsSubmission)
                {
                    show_select_pool_quantity_checkbox = true;
                }
                //set to show exercise pool quantiy or not 
                ViewBag.show_exercise_pool_quantity = show_exercise_pool_quantity;

                ViewBag.show_select_pool_quantity_checkbox = show_select_pool_quantity_checkbox;

                ViewBag.virtual_exercise_qty = virtual_exercise_qty;
                ViewBag.actual_exercise_qty = actual_exercise_qty;

                ViewBag.Show_Exercise_Pool = 1; // show hide on selection
            }
            catch (Exception exp)
            {

            }

            return PartialView("_DMATwiseBalance", objPreclearanceRequestNonImplCompanyModel);
            //return Json(new
            //{
            //    esop_exercise_qty = esop_exercise_qty,
            //    other_esop_exercise_qty = other_esop_exercise_qty,//objTradingPolicyModel.TradingPolicyName + InsiderTrading.Common.Common.getResource("rul_msg_15374"),//" Save Successfully",

            //});
        }
        #endregion LoadBalanceDMATwise

        #region LoadSecurityType
        public ActionResult LoadSecurityType(PreclearanceRequestNonImplCompanyModel objPreclearanceRequestModel, string CalledFrom)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicySL_OS objTradingPolicySL_OS = new TradingPolicySL_OS();
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO_OS = null;
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = null;
            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;

            int TradingPolicyID = 0;
            using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
            {
                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
            }
            if (objInsiderInitialDisclosureDTO.RequiredModule == InsiderTrading.Common.ConstEnum.Code.RequiredModuleBoth && objInsiderInitialDisclosureDTO.RequiredModule == InsiderTrading.Common.ConstEnum.Code.RequiredModuleOwnSecurity)
            {
                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objPreclearanceRequestModel.UserInfoId));
                TradingPolicyID = Convert.ToInt32(objApplicableTradingPolicyDetailsDTO.TradingPolicyId);
            }
            else
            {
                objApplicableTradingPolicyDetailsDTO_OS = objTradingPolicySL_OS.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objPreclearanceRequestModel.UserInfoId));
                TradingPolicyID = Convert.ToInt32(objApplicableTradingPolicyDetailsDTO_OS.TradingPolicyId);
            }
            try
            {
                if (objPreclearanceRequestModel.TransactionTypeCodeId != 0)
                    ViewBag.SecurityDropDown = FillComboValues(InsiderTrading.Common.ConstEnum.ComboType.ListofSecurityTypeapplicableTradingPolicyOS, Convert.ToString(TradingPolicyID), objPreclearanceRequestModel.TransactionTypeCodeId.ToString(), null, null, null, true);
                else
                    ViewBag.SecurityDropDown = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, true);
                if (ModelState.ContainsKey("SecurityTypeCodeId"))
                    ModelState["SecurityTypeCodeId"].Errors.Clear();
                return PartialView("_SecurityTypeDetails", objPreclearanceRequestModel);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("CreatePreclearanceOS", objPreclearanceRequestModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objTradingPolicySL_OS = null;
                objApplicableTradingPolicyDetailsDTO = null;
            }
        }
        #endregion LoadSecurityType

        #region LoadModeOfAquisition
        public ActionResult LoadModeOfAquisition(PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel, string CalledFrom)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicySL objTradingPolicySL = new TradingPolicySL();
            TradingPolicySL_OS objTradingPolicySL_OS = new TradingPolicySL_OS();
            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
            ApplicableTradingPolicyDetailsDTO objApplicableTradingPolicyDetailsDTO = null;
            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO_OS = null;
            int TradingPolicyID = 0;
            using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
            {
                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
            }
            if (objInsiderInitialDisclosureDTO.RequiredModule == InsiderTrading.Common.ConstEnum.Code.RequiredModuleBoth && objInsiderInitialDisclosureDTO.RequiredModule == InsiderTrading.Common.ConstEnum.Code.RequiredModuleOwnSecurity)
            {
                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.UserInfoId));
                TradingPolicyID = Convert.ToInt32(objApplicableTradingPolicyDetailsDTO.TradingPolicyId);
            }
            else
            {
                objApplicableTradingPolicyDetailsDTO_OS = objTradingPolicySL_OS.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objPreclearanceRequestNonImplCompanyModel.UserInfoId));
                TradingPolicyID = Convert.ToInt32(objApplicableTradingPolicyDetailsDTO_OS.TradingPolicyId);
            }

            try
            {
                if (objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId == 0)
                {
                    ViewBag.ModeOfAcquisition = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ModeOfAcquisition, null, null, null, null, true);
                }
                else
                {
                    ViewBag.ModeOfAcquisition = FillComboValues(InsiderTrading.Common.ConstEnum.ComboType.ListofModeOfAcquisitionapplicableTradingPolicyOS, Convert.ToString(TradingPolicyID), objPreclearanceRequestNonImplCompanyModel.TransactionTypeCodeId.ToString(), objPreclearanceRequestNonImplCompanyModel.SecurityTypeCodeId.ToString(), null, null, true);
                }
                if (ModelState.ContainsKey("ModeOfAcquisitionCodeId"))
                    ModelState["ModeOfAcquisitionCodeId"].Errors.Clear();
                return PartialView("_modeOfAcqisition", objPreclearanceRequestNonImplCompanyModel);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("CreatePreclearanceOS", objPreclearanceRequestNonImplCompanyModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objTradingPolicySL = null;
                objApplicableTradingPolicyDetailsDTO = null;
            }
        }
        #endregion LoadModeOfAquisition

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
                objPopulateComboDTO.Key = "";
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

        #region Preclearance Type Change Event
        /// <summary>
        /// 
        /// </summary>
        /// <param name="objPreclearanceRequestModel"></param>
        /// <returns></returns>
        public ActionResult LoadRelative(PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                if ((int)objPreclearanceRequestNonImplCompanyModel.PreclearanceRequestForCodeId == InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestForRelative)
                {
                    ViewBag.RelativeDropDown = FillComboValues(ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString(), null, null, null, null, true);
                    return PartialView("_RelativeDetails", objPreclearanceRequestNonImplCompanyModel);
                }
                else
                {
                    ViewBag.UserInfoId = objPreclearanceRequestNonImplCompanyModel.UserInfoId;
                    ViewBag.DematAccountNumberList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), ConstEnum.Code.PreClearanceType_ImplementingCompany.ToString(), null, null, null, true);
                    return PartialView("_DEMATList", objPreclearanceRequestNonImplCompanyModel);
                }
                //return PartialView("_RelativeDetails", objPreclearanceRequestNonImplCompanyModel);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("CreatePreclearanceOS", objPreclearanceRequestNonImplCompanyModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion Preclearance Type Change Event

        #region ViewNotTraded
        /// <summary>
        /// 
        /// </summary>
        /// <param name="PreClearanceRequestId"></param>
        /// <param name="CalledFrom"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult ViewNotTraded(int PreClearanceRequestId, int acid, string CalledFrom = "")
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                //if (PreClearanceRequestId != 0 && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PreclearanceRequestNonImplementingCompany, Convert.ToInt64(PreClearanceRequestId), objLoginUserDetails.LoggedInUserID))
                //{
                //    return RedirectToAction("Unauthorised", "Home");
                //}
                PreclearanceRequestNonImplCompanyModel objPreclearanceRequestNonImplCompanyModel = new PreclearanceRequestNonImplCompanyModel();
                PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL();
                PreclearanceRequestNonImplCompanyDTO objPreclearanceRequestNonImplCompanyDTO = new PreclearanceRequestNonImplCompanyDTO();
                objPreclearanceRequestNonImplCompanyDTO = objPreclearanceRequestNonImplCompanySL.GetPreclearanceRequestDetail(objLoginUserDetails.CompanyDBConnectionString, PreClearanceRequestId);
                Common.Common.CopyObjectPropertyByName(objPreclearanceRequestNonImplCompanyDTO, objPreclearanceRequestNonImplCompanyModel);
                ViewBag.CalledFrom = CalledFrom;
                return View("NotTraded", objPreclearanceRequestNonImplCompanyModel);

            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Index");
            }
        }
        #endregion NotTradedViewView

        #region backButtonAction
        /// <summary>
        /// 
        /// </summary>
        /// <param name="CalledFrom"></param>
        /// <returns></returns>
        public ActionResult backButtonAction(string CalledFrom)
        {
            if (CalledFrom == "Insider")
            {
                return RedirectToAction("IndexOS", "PreclearanceRequestNonImplCompany", new { acid = InsiderTrading.Common.ConstEnum.UserActions.PreclearanceRequestOtherSecurities });
            }
            else
            {
                return RedirectToAction("CoIndex_OS", "PreclearanceRequestNonImplCompany", new { acid = InsiderTrading.Common.ConstEnum.UserActions.PreclearanceRequestListCOOtherSecurities });
            }
        }
        #endregion backButtonAction

        #region PreClearance Not Taken Action
        /// <summary>
        /// This method is used for the When PNT
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult PreClearanceNotTakenAction(int acid, string from = "")
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            TradingPolicySL_OS objTradingPolicySL = new TradingPolicySL_OS();
            TradingTransactionSL_OS objTradingTransactionSL = new TradingTransactionSL_OS();
            ApplicableTradingPolicyDetailsDTO_OS objApplicableTradingPolicyDetailsDTO = null;
            try
            {
                if (from != "FromTrans")
                {
                    //int localApprovedPCLCnt = 0;
                    //List<ApprovedPCLDTO> lstApprovedPCLCnt = objTradingTransactionSL.GetApprovedPCLCntSL(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    //foreach (var ApprovedPCLCnt in lstApprovedPCLCnt)
                    //{
                    //    localApprovedPCLCnt = ApprovedPCLCnt.ApprovedPCLCnt;
                    //}
                    //if (localApprovedPCLCnt != 0)
                    //{
                    //    return RedirectToAction("IndexOS", "PreclearanceRequestNonImplCompany", new { acid = InsiderTrading.Common.ConstEnum.UserActions.PreclearanceRequestOtherSecurities, IsApprovedPCL = "FromTrans" });
                    //}
                }

                TradingTransactionMasterDTO_OS objTradingTransactionMasterDTO = new TradingTransactionMasterDTO_OS();
                objTradingTransactionMasterDTO.TransactionMasterId = 0;
                objTradingTransactionMasterDTO.PreclearanceRequestId = null;
                objTradingTransactionMasterDTO.UserInfoId = objLoginUserDetails.LoggedInUserID;
                objTradingTransactionMasterDTO.DisclosureTypeCodeId = Common.ConstEnum.Code.DisclosureTypeContinuous;//147002;
                objTradingTransactionMasterDTO.TransactionStatusCodeId = Common.ConstEnum.Code.DisclosureStatusForNotConfirmed;// 148002;
                objTradingTransactionMasterDTO.NoHoldingFlag = false;
                objApplicableTradingPolicyDetailsDTO = objTradingPolicySL.GetApplicableTradingPolicyDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                objTradingTransactionMasterDTO.TradingPolicyId = objApplicableTradingPolicyDetailsDTO.TradingPolicyId;
                objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);
                from = "pntButton";
                return RedirectToAction("Index", "TradingTransaction_OS", new { TransactionMasterId = objTradingTransactionMasterDTO.TransactionMasterId, acid = Common.ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE, nDisclosureTypeCodeId = objTradingTransactionMasterDTO.DisclosureTypeCodeId, nUserInfoId = objLoginUserDetails.LoggedInUserID, nUserTypeCodeId = objLoginUserDetails.UserTypeCodeId, frm = from });
            }
            catch (Exception exp)
            {
                ViewBag.RequestStatusList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null, null, null, null, true);
                ViewBag.EmployeeStatusList = FillComboValues(ConstEnum.ComboType.EmpStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.EmployeeStatus, null, null, null, null, true);
                ViewBag.TransactionTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null, null, null, null, true);
                ViewBag.DisclosureDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, "1", null, null, null, true);
                ViewBag.TradeDetailsList = FillComboValues(ConstEnum.ComboType.EventStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.DisclosureAndTradeDetailsStatus, null, null, null, null, true);
                //   ViewBag.UserInfoRelativeList = FillComboValues(ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString(), null, null, null, null, true);
                //ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
                //ViewBag.Param1 = groupId;

                //FillGrid(Common.ConstEnum.GridType.ContinousDisclosureStatusList, objLoginUserDetails.LoggedInUserID.ToString(), null, null);
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("Index");
            }
            finally
            {
                objLoginUserDetails = null;
                objTradingPolicySL = null;
                objTradingTransactionSL = null;
                objApplicableTradingPolicyDetailsDTO = null;
            }
        }
        #endregion PreClearance Not Taken Action

        #region ApprovePreclearanceRequest
        public JsonResult ApprovePreclearanceRequest(string arrSelectedElement, string ReasonForApproval, string ReasonForApprovalCodeId)
        {
            PreclearanceRequestNonImplCompanyDTO objPreclearanceRequestNonImplCompanyDTO = new PreclearanceRequestNonImplCompanyDTO();
            PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            DataTable dt_PreClearanceList;
            DataTable dt_preclearanceRequestId;
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            try
            {
                bool? preclearanceNotTakenFlag = false;
                int? reasonForNotTradingCodeId = null;
                string reasonForNotTradingText = null;
                int? userID = objLoginUserDetails.LoggedInUserID;
                int preclearanceStatusCodeId = ConstEnum.Code.PreclearanceRequestStatusApproved;
                string reasonForRejection = null;
                dt_PreClearanceList = new DataTable("PreclearanceRequestNonImplCompanyType");
                dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceRequestId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("RlSearchAuditId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceRequestForCodeId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("UserInfoId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("UserInfoIdRelative", typeof(int)) { AllowDBNull = true });
                dt_PreClearanceList.Columns.Add(new DataColumn("TransactionTypeCodeId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("SecurityTypeCodeId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("SecuritiesToBeTradedQty", typeof(decimal)));
                dt_PreClearanceList.Columns.Add(new DataColumn("SecuritiesToBeTradedValue", typeof(decimal)));
                dt_PreClearanceList.Columns.Add(new DataColumn("ModeOfAcquisitionCodeId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("DMATDetailsID", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceStatusCodeId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("CompanyId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("ApprovedBy", typeof(int)));
                DataRow draw = dt_PreClearanceList.NewRow();
                draw["PreclearanceRequestId"] = 0;
                draw["RlSearchAuditId"] = 0;
                draw["PreclearanceRequestForCodeId"] = 0;
                draw["UserInfoId"] = 0;
                draw["UserInfoIdRelative"] = DBNull.Value;
                draw["TransactionTypeCodeId"] = 0;
                draw["SecurityTypeCodeId"] = 0;
                draw["SecuritiesToBeTradedQty"] = 0.00;
                draw["SecuritiesToBeTradedValue"] = 0.00;
                draw["ModeOfAcquisitionCodeId"] = 0;
                draw["DMATDetailsID"] = 0;
                draw["PreclearanceStatusCodeId"] = 0;
                draw["CompanyId"] = 0;
                draw["ApprovedBy"] = 0;
                dt_PreClearanceList.Rows.Add(draw);
                string[][] arrPreclearanceID = null;
                if (arrSelectedElement != "")
                    arrPreclearanceID = JsonConvert.DeserializeObject<string[][]>(arrSelectedElement);

                dt_preclearanceRequestId = new DataTable("PreClearanceIDType");
                dt_preclearanceRequestId.Columns.Add(new DataColumn("PreclearanceRequestId", typeof(int)));
                dt_preclearanceRequestId.Columns.Add(new DataColumn("DisplaySequenceNo", typeof(int)));

                if (arrPreclearanceID != null)
                {
                    for (int i = 0; i < arrPreclearanceID[0].Length; i++)
                    {
                        DataRow row = null;
                        row = dt_preclearanceRequestId.NewRow();
                        row["PreclearanceRequestId"] = Convert.ToInt32(arrPreclearanceID[0][i]);
                        row["DisplaySequenceNo"] = Convert.ToInt32(arrPreclearanceID[1][i]);
                        dt_preclearanceRequestId.Rows.Add(row);
                        row = null;
                    }
                }

                bool bReturn = true;
                bReturn = objPreclearanceRequestNonImplCompanySL.PreclearanceRequestApproveRejectSave_OS(objLoginUserDetails.CompanyDBConnectionString, dt_PreClearanceList, dt_preclearanceRequestId, preclearanceNotTakenFlag, reasonForNotTradingCodeId,
                    reasonForNotTradingText, userID, preclearanceStatusCodeId, reasonForRejection, ReasonForApproval, int.Parse(ReasonForApprovalCodeId));

                if (bReturn)
                {
                    statusFlag = true;
                    ErrorDictionary.Add("success", "Preclearance approved successfully");
                }
                else
                {
                    ErrorDictionary.Add("error", "Preclearance approval failed");
                }
                return Json(new { status = statusFlag, Message = ErrorDictionary }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return Json(new { status = statusFlag, Message = ErrorDictionary }, JsonRequestBehavior.AllowGet);
            }
        }
        #endregion ApprovePreclearanceRequest

        #region RejectPreclearanceRequest
        public JsonResult RejectPreclearanceRequest(string arrSelectedElement, string ReasonForRejection)
        {
            PreclearanceRequestNonImplCompanyDTO objPreclearanceRequestNonImplCompanyDTO = new PreclearanceRequestNonImplCompanyDTO();
            PreclearanceRequestNonImplCompanySL objPreclearanceRequestNonImplCompanySL = new PreclearanceRequestNonImplCompanySL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            DataTable dt_PreClearanceList;
            DataTable dt_preclearanceRequestId;
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            try
            {
                bool? preclearanceNotTakenFlag = false;
                int? reasonForNotTradingCodeId = null;
                string reasonForNotTradingText = null;
                int? userID = objLoginUserDetails.LoggedInUserID;
                int preclearanceStatusCodeId = ConstEnum.Code.PreclearanceRequestStatusRejected;
                dt_PreClearanceList = new DataTable("PreclearanceRequestNonImplCompanyType");
                dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceRequestId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("RlSearchAuditId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceRequestForCodeId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("UserInfoId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("UserInfoIdRelative", typeof(int)) { AllowDBNull = true });
                dt_PreClearanceList.Columns.Add(new DataColumn("TransactionTypeCodeId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("SecurityTypeCodeId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("SecuritiesToBeTradedQty", typeof(decimal)));
                dt_PreClearanceList.Columns.Add(new DataColumn("SecuritiesToBeTradedValue", typeof(decimal)));
                dt_PreClearanceList.Columns.Add(new DataColumn("ModeOfAcquisitionCodeId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("DMATDetailsID", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("PreclearanceStatusCodeId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("CompanyId", typeof(int)));
                dt_PreClearanceList.Columns.Add(new DataColumn("ApprovedBy", typeof(int)));
                DataRow draw = dt_PreClearanceList.NewRow();
                draw["PreclearanceRequestId"] = 0;
                draw["RlSearchAuditId"] = 0;
                draw["PreclearanceRequestForCodeId"] = 0;
                draw["UserInfoId"] = 0;
                draw["UserInfoIdRelative"] = DBNull.Value;
                draw["TransactionTypeCodeId"] = 0;
                draw["SecurityTypeCodeId"] = 0;
                draw["SecuritiesToBeTradedQty"] = 0.00;
                draw["SecuritiesToBeTradedValue"] = 0.00;
                draw["ModeOfAcquisitionCodeId"] = 0;
                draw["DMATDetailsID"] = 0;
                draw["PreclearanceStatusCodeId"] = 0;
                draw["CompanyId"] = 0;
                draw["ApprovedBy"] = 0;
                dt_PreClearanceList.Rows.Add(draw);
                string[][] arrPreclearanceID = null;
                if (arrSelectedElement != "")
                    arrPreclearanceID = JsonConvert.DeserializeObject<string[][]>(arrSelectedElement);

                dt_preclearanceRequestId = new DataTable("PreClearanceIDType");
                dt_preclearanceRequestId.Columns.Add(new DataColumn("PreclearanceRequestId", typeof(int)));
                dt_preclearanceRequestId.Columns.Add(new DataColumn("DisplaySequenceNo", typeof(int)));

                if (arrPreclearanceID != null)
                {
                    for (int i = 0; i < arrPreclearanceID[0].Length; i++)
                    {
                        DataRow row = null;
                        row = dt_preclearanceRequestId.NewRow();
                        row["PreclearanceRequestId"] = Convert.ToInt32(arrPreclearanceID[0][i]);
                        row["DisplaySequenceNo"] = Convert.ToInt32(arrPreclearanceID[1][i]);
                        dt_preclearanceRequestId.Rows.Add(row);
                        row = null;
                    }
                }

                bool bReturn = true;
                bReturn = objPreclearanceRequestNonImplCompanySL.PreclearanceRequestApproveRejectSave_OS(objLoginUserDetails.CompanyDBConnectionString, dt_PreClearanceList, dt_preclearanceRequestId, preclearanceNotTakenFlag, reasonForNotTradingCodeId,
                    reasonForNotTradingText, userID, preclearanceStatusCodeId, ReasonForRejection, null, 0);

                if (bReturn)
                {
                    statusFlag = true;
                    ErrorDictionary.Add("success", "Preclearance rejected successfully");
                }
                else
                {
                    ErrorDictionary.Add("error", "Preclearance rejection failed");
                }
                return Json(new { status = statusFlag, Message = ErrorDictionary }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return Json(new { status = statusFlag, Message = ErrorDictionary }, JsonRequestBehavior.AllowGet);
            }
        }
        #endregion RejectPreclearanceRequest

        #region Pre-clearances CO Dashboard
        /// <summary>
        /// 
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult PreClearancesCODashboardOtherSecurities(int acid, String inp_sParam, String isInsider)
        {
            ViewData["inp_sParam"] = inp_sParam;
            ViewData["IsInsider"] = isInsider;
            LoginUserDetails objLoginUserDetails = null;
            UserInfoDTO objUserInfoDTO = null;
            UserInfoSL objUserInfoSL = new UserInfoSL();
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            ViewBag.RequestStatusList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceStatus, null);
            ViewBag.TransactionTypeList = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.TransactionType, null);
            objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
            //ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
            ViewBag.GridType = Common.ConstEnum.GridType.PreclearanceList_OS_ForCO;
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "Select";
            List<PopulateComboDTO> lstDepartmentList = new List<PopulateComboDTO>();
            lstDepartmentList.Add(objPopulateComboDTO);
            lstDepartmentList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.ReasonforApproval).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.ReasonForApproveDropDown = lstDepartmentList;
            return View("CoIndex_OS");
        }
        #endregion Pre-clearances CO Dashboard

    }
}