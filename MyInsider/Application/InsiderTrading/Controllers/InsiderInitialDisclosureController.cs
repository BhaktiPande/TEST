using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class InsiderInitialDisclosureController : Controller
    {

        #region Insider initial disclosure
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid, int UserInfoId=0,int ReqModuleId=0)
        {
            //Checking setting for Required Module For Mst_Company Table
            LoginUserDetails objLoginUserDetails = null;
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            if (!(objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType))
            {
                UserInfoId = objLoginUserDetails.LoggedInUserID;
                ViewBag.show_cancel_btn = false;
            }
            //ImplementedCompanyDTO objImplementedCompanyDTO = null;
            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
            using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
            {
                
                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_TradingPolicyID_forOS(objLoginUserDetails.CompanyDBConnectionString, UserInfoId);
                ViewBag.TradingPolicyID_OS = objInsiderInitialDisclosureDTO.TradingPolicyID_OS;

                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                ViewBag.RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;

                return RedirectToAction("SecuritiesIndex", "InsiderInitialDisclosure", new { acid = acid,UserInfoId=UserInfoId, RequiredModuleID = @ViewBag.RequiredModuleID, requiredModuleIDOnbtnclick = ReqModuleId, TradingPolicyID_OS = ViewBag.TradingPolicyID_OS });
                
            }
            //return View();
        }
        #endregion Insider initial disclosure

        #region Insider initial disclosure For Implementing Company
        [AuthorizationPrivilegeFilter]
        public ActionResult SecuritiesIndex(int acid, int UserInfoId = 0, int RequiredModuleID = 0, int requiredModuleIDOnbtnclick = 0, int TradingPolicyID_OS=0)
        {
            LoginUserDetails objLoginUserDetails = null;
            InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = null;
            List<InsiderInitialDisclosureDTO> lstInsiderInitialDisclosureDTO = null;
            InsiderInitialDisclosureModel objInsiderInitialDisclosureModel = new InsiderInitialDisclosureModel();
            objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelEmployee1=new List<InsiderInitialDisclosureModelEmployee>();
            objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelInsider1 = new List<InsiderInitialDisclosureModelInsider>();
            ViewBag.show_cancel_btn = true;
            ViewBag.Change_Btn_Color = false;
            ViewBag.ShowOwnEmp = false;
            ViewBag.ShowOwnInsider= false;
            ViewBag.ShowOtherEmp = false;
            ViewBag.ShowOtherInsider = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL();
              
                if (!(objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType))
                {
                    UserInfoId = objLoginUserDetails.LoggedInUserID;
                    ViewBag.show_cancel_btn = false;
                }     
                ViewBag.UsrTypeCodeId = objLoginUserDetails.UserTypeCodeId;
                ViewBag.UsrTypeCodeIdEmp = objLoginUserDetails.UserTypeCodeId;

                if (requiredModuleIDOnbtnclick == 513001 || requiredModuleIDOnbtnclick == 513003 || ((RequiredModuleID == 513003 || RequiredModuleID == 513001) && requiredModuleIDOnbtnclick == 0 && TradingPolicyID_OS == 0))
                {
                    //get policy and event list (combine list)
                    lstInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.GetDashBoardDetails(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objLoginUserDetails.UserTypeCodeId).ToList();

                    //convert DTO object to model
                    foreach (InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO in lstInsiderInitialDisclosureDTO)
                    {
                        objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelEmployee = new InsiderInitialDisclosureModelEmployee();
                        Common.Common.CopyObjectPropertyByName(objInsiderInitialDisclosureDTO, objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelEmployee);

                        objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelEmployee1.Add(objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelEmployee);
                    }
                    if (lstInsiderInitialDisclosureDTO.Count > 0)
                        ViewBag.ShowOwnEmp = true;

                    lstInsiderInitialDisclosureDTO = null;
                    lstInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.GetDashBoardDetailsInsider(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objLoginUserDetails.UserTypeCodeId).ToList();

                    //convert DTO object to model
                    foreach (InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO in lstInsiderInitialDisclosureDTO)
                    {
                        objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelInsider = new InsiderInitialDisclosureModelInsider();
                        Common.Common.CopyObjectPropertyByName(objInsiderInitialDisclosureDTO, objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelInsider);

                        objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelInsider1.Add(objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelInsider);
                    }
                    
                    if (lstInsiderInitialDisclosureDTO.Count > 0)
                        ViewBag.ShowOwnInsider = true;
                }
                else
                {

                    ////get policy and event list (combine list)
                    //lstInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.GetDashBoardDetails_OS(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objLoginUserDetails.UserTypeCodeId).ToList();

                    ////convert DTO object to model
                    //foreach (InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO in lstInsiderInitialDisclosureDTO)
                    //{
                    //    objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelEmployee = new InsiderInitialDisclosureModelEmployee();
                    //    Common.Common.CopyObjectPropertyByName(objInsiderInitialDisclosureDTO, objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelEmployee);

                    //    objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelEmployee1.Add(objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelEmployee);
                    //}
                    //if (lstInsiderInitialDisclosureDTO.Count > 0)
                    //    ViewBag.ShowOtherEmp = true;

                    lstInsiderInitialDisclosureDTO = null;
                    lstInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.GetDashBoardDetailsInsider_OS(objLoginUserDetails.CompanyDBConnectionString, UserInfoId, objLoginUserDetails.UserTypeCodeId).ToList();

                    //convert DTO object to model
                    foreach (InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO in lstInsiderInitialDisclosureDTO)
                    {
                        objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelInsider = new InsiderInitialDisclosureModelInsider();
                        Common.Common.CopyObjectPropertyByName(objInsiderInitialDisclosureDTO, objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelInsider);

                        objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelInsider1.Add(objInsiderInitialDisclosureModel.InsiderInitialDisclosureModelInsider);
                    }

                    if (lstInsiderInitialDisclosureDTO.Count > 0)
                        ViewBag.ShowOtherInsider = true;

                }              

                ViewBag.UserInfoId = UserInfoId;
                ViewBag.UserInfoIdEmp = UserInfoId;

                bool bReturn = true;

                ViewBag.GridType = ConstEnum.GridType.InitialDisclosureListForEmployee;
                ViewBag.InsiderGridType = ConstEnum.GridType.InitialDisclosureListForInsider;
                ViewBag.Company = objLoginUserDetails.CompanyName;

                //ViewBag.PolicyDocumentList = lstDashBoeard;
                ViewBag.IsFirstLogin = bReturn;
                ViewBag.Incomplete = false;

                ViewBag.RequiredModuleID = RequiredModuleID;
                ViewBag.TradingPolicyID_OS = TradingPolicyID_OS;
               
                //if (requiredModuleIDOnbtnclick == 513001 || requiredModuleIDOnbtnclick == 513003)
                //return View("Index", lstInsiderInitialDisclosureModel);
                if (requiredModuleIDOnbtnclick == 513001 || requiredModuleIDOnbtnclick == 513003 || ((RequiredModuleID == 513003 ||RequiredModuleID == 513001) && requiredModuleIDOnbtnclick == 0 && TradingPolicyID_OS==0))
                {
                  ViewBag.Change_Btn_Color = true;
                  return View("Index", objInsiderInitialDisclosureModel);
                }
                else
                {
                  ViewBag.Change_Btn_Color = true;
                  return View("OtherSecuritiesIndex", objInsiderInitialDisclosureModel);           
                }
            }
            catch (Exception exp)
            {
                ViewBag.Incomplete = false;
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index", objInsiderInitialDisclosureModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objInsiderInitialDisclosureSL = null;
                lstInsiderInitialDisclosureDTO = null;
                objInsiderInitialDisclosureModel = null;
            }
        }
        #endregion Insider initial disclosure For Implementing Company

        #region FilterIndex
        [AuthorizationPrivilegeFilter]
        public ActionResult FilterIndex(int acid, int UserInfoId = 0, int ReqModuleId = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            if (!(objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == InsiderTrading.Common.ConstEnum.Code.COUserType))
            {
                UserInfoId = objLoginUserDetails.LoggedInUserID;
                ViewBag.show_cancel_btn = false;
            }
            //ImplementedCompanyDTO objImplementedCompanyDTO = null;
            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
            using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
            {

                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_TradingPolicyID_forOS(objLoginUserDetails.CompanyDBConnectionString, UserInfoId);
                ViewBag.TradingPolicyID_OS = objInsiderInitialDisclosureDTO.TradingPolicyID_OS;

                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                ViewBag.RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;

                return RedirectToAction("SecuritiesIndex", "InsiderInitialDisclosure", new { acid = 155, UserInfoId = UserInfoId, RequiredModuleID = @ViewBag.RequiredModuleID, requiredModuleIDOnbtnclick = ReqModuleId, TradingPolicyID_OS = ViewBag.TradingPolicyID_OS });
              }

        }
        #endregion FilterIndex

        #region List
        [AuthorizationPrivilegeFilter]
        public ActionResult List(int acid, string frm = "")
        {
            bool show_cancel_btn = false;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                ViewBag.UserInfoId = objLoginUserDetails.LoggedInUserID;
                ViewBag.GridType = ConstEnum.GridType.PolicyAgreedByUserList;
                ViewBag.Company = objLoginUserDetails.CompanyName;

                //check if frm variable to know from where this link is called ie from menu option or from initial disclosure page 
                //if called from initial disclosure page then set flag true to show cancel button 
                if (frm != "" && frm == "disclosure")
                {
                    show_cancel_btn = true;
                }

                ViewBag.show_cancel_btn = show_cancel_btn;

                ViewBag.UserAction = acid;

                return View("List");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("List");
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion List

        #region DisplayPolicy
        [AuthorizationPrivilegeFilter]
        public ActionResult DisplayPolicy(int acid, int PolicyDocumentID, int DocumentID, string CalledFrom, bool CalledFromHardCopy = false, int year = 0, int Period = 0, string frm = "", bool IsFromDashboard = false, int nUserInfoId = 0, string DiscType = "", int RequiredModuleID = 0)
        {
            DocumentDetailsSL objDocumentDetailsSL = null;
            List<DocumentDetailsDTO> objDocumentDetailsDTOList = null;
            string FAQMenuURL = string.Empty;
            string[] MenuURLParts = null;
            string PID = string.Empty;
            string ID = string.Empty;
          
            List<InsiderTradingDAL.MenuMasterDTO> menuList = new List<MenuMasterDTO>();
            ViewBag.RequiredModuleID = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOwnSecurity;
            menuList = (List<InsiderTradingDAL.MenuMasterDTO>)TempData["MenuList"];
           

            if (CalledFrom == "ViewAgree_OS")
                ViewBag.RequiredModuleID = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOtherSecurity;
            else           
                ViewBag.RequiredModuleID = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOwnSecurity;
            //Get the MenuURL of FAQ
            if (CalledFrom.ToUpper().Contains("FAQ") && IsFromDashboard)
            {
               foreach(InsiderTradingDAL.MenuMasterDTO item in menuList)
               {
                   if (!String.IsNullOrEmpty(item.MenuURL) && item.MenuURL.Contains("FAQ"))
                   {
                       FAQMenuURL = item.MenuURL;
                   }
               }
               if (!String.IsNullOrEmpty(FAQMenuURL))
                    MenuURLParts = FAQMenuURL.Split('&');
               if (MenuURLParts.Length > 0)
               {
                   for (int i = 0; i <= MenuURLParts.Length - 1; i++)
                   {
                       if (MenuURLParts[i].ToUpper().Contains("DOCUMENTID"))
                       {
                           if (MenuURLParts[i].ToUpper().Contains('='))
                           {
                               if (MenuURLParts[i].ToUpper().Contains("POLICY"))
                                   PID = MenuURLParts[i].Split('=')[1];
                               else
                                   ID = MenuURLParts[i].Split('=')[1];                              
                           }
                       }
                   }
                   PolicyDocumentID = Convert.ToInt32(PID);
                   DocumentID = Convert.ToInt32(ID);
               }              
            }
            
            Boolean isShowDownloadDocumentMsg = true; //flag used to show message to download file

            bool IsCalledFromReport = false; // flag used to show this page is show from Report page link
            bool HardCopyFileNotUploaded = false;
            UsersPolicyDocumentModel objUsersPolicyDocumentModel = new UsersPolicyDocumentModel();
            UsersPolicyDocumentDTO objUsersPolicyDocumentDTO = new UsersPolicyDocumentDTO();
            InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            int PurposeCodeId = 0;

            if (Convert.ToString(objLoginUserDetails.DateOfBecomingInsider).Equals("") && objLoginUserDetails.UserTypeCodeId.Equals(InsiderTrading.Common.ConstEnum.Code.EmployeeType) && (PolicyDocumentID == InsiderTrading.Common.ConstEnum.Code.FAQInsiderPolicyDocumentID || PolicyDocumentID == InsiderTrading.Common.ConstEnum.Code.FAQEmployeePolicyDocumentID))
            {
                PolicyDocumentID = InsiderTrading.Common.ConstEnum.Code.FAQInsiderPolicyDocumentID;
                DocumentID = InsiderTrading.Common.ConstEnum.Code.FAQDocumentID;
            }

            DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();

            UserPolicyDocumentEventLogDTO objUserPolicyDocumentEventLogDTO = null;
            try
            {
                if (DiscType == "OS")
                {
                    RequiredModuleID = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOtherSecurity;
                }
                else
                {
                    RequiredModuleID = InsiderTrading.Common.ConstEnum.Code.RequiredModuleOwnSecurity;
                }
                objDocumentDetailsSL = new DocumentDetailsSL();
                objUsersPolicyDocumentModel.PolicyDocumentId = PolicyDocumentID; //in case of hard copy display this value is MapToId
                objUsersPolicyDocumentModel.DocumentId = DocumentID;
                objUsersPolicyDocumentModel.CalledFrom = CalledFrom;
                objUsersPolicyDocumentModel.RequiredModuleID = RequiredModuleID;
              

               
                if (!CalledFromHardCopy && !Common.Common.CheckUserTypeAccess(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PolicyDocument, Convert.ToInt64(PolicyDocumentID), objLoginUserDetails.LoggedInUserID))
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                //check if to show policy document details or hard copy file and get details accourdingly 
                if (CalledFromHardCopy)
                {
                    //get hard copy document details 

                    //check if document has uploaded or not -- by checking document id - in case of not uploaded document id is "0"
                    if (DocumentID > 0)
                    {
                        objDocumentDetailsDTO = objDocumentDetailsSL.GetDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, DocumentID);
                    }
                    else
                    {
                        HardCopyFileNotUploaded = true;
                    }

                    //copy document details DTO into User policy document model
                    objUsersPolicyDocumentModel.DocumentId = objDocumentDetailsDTO.DocumentId;
                    objUsersPolicyDocumentModel.PolicyDocumentName = objDocumentDetailsDTO.DocumentName;
                    objUsersPolicyDocumentModel.PolicyDocumentFileType = objDocumentDetailsDTO.FileType;
                    objUsersPolicyDocumentModel.CalledFrom = CalledFrom;
                    objUsersPolicyDocumentModel.DocumentViewFlag = false;
                    objUsersPolicyDocumentModel.DocumentViewAgreeFlag = false;
                }
                else
                {
                    objUsersPolicyDocumentDTO = objInsiderInitialDisclosureSL.GetDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, PolicyDocumentID, DocumentID);
                    objUsersPolicyDocumentDTO.DocumentId = DocumentID;
                    Common.Common.CopyObjectPropertyByName(objUsersPolicyDocumentDTO, objUsersPolicyDocumentModel);
                }

                if (objUsersPolicyDocumentModel.DocumentViewAgreeFlag == true)
                {
                    ViewBag.ViewAgreeFlag = true;
                    ViewBag.ViewFlag = false;
                }
                else if (objUsersPolicyDocumentModel.DocumentViewFlag == true)
                {
                    ViewBag.ViewAgreeFlag = false;
                    ViewBag.ViewFlag = true;
                }

                ViewBag.CalledFrom = CalledFrom;
                ViewBag.Company = objLoginUserDetails.CompanyName;
                ViewBag.PDID = PolicyDocumentID;
                ViewBag.Year = year;
                ViewBag.Period = Period;
                ViewBag.nUserInfoId = nUserInfoId;
                int DocMapToTypeCodeId=0;

                //get document details - document id - to set and show document to user
                if (DiscType == "OS")
                {
                    DocMapToTypeCodeId = (CalledFromHardCopy) ? ConstEnum.Code.DisclosureTransactionforOS : ConstEnum.Code.PolicyDocument;
              
                }
                else
                {
                    DocMapToTypeCodeId = (CalledFromHardCopy) ? ConstEnum.Code.DisclosureTransaction : ConstEnum.Code.PolicyDocument;
               
                }

                //get details if document is uploaded by checking document id 
                if (DocumentID > 0)
                {
                    PurposeCodeId = (CalledFrom == "DisclosureDocuments") ? ConstEnum.Code.TransactionDetailsUpload : 0;

                    objDocumentDetailsDTOList = objDocumentDetailsSL.GetDocumentList(objLoginUserDetails.CompanyDBConnectionString, DocMapToTypeCodeId, PolicyDocumentID, PurposeCodeId);

                    ViewBag.DocumentId = objDocumentDetailsDTOList[0].DocumentId;
                    ViewBag.GUID = objDocumentDetailsDTOList[0].GUID;
                    ViewBag.DocumentName = objDocumentDetailsDTOList[0].DocumentName;
                    ViewBag.FileType = objDocumentDetailsDTOList[0].FileType;

                    //check for following file type and set flag to false so message to download file will not be appear
                    if (objDocumentDetailsDTOList[0].FileType == ".pdf")
                    {
                        isShowDownloadDocumentMsg = false;
                    }
                }

                //set flag to show download document message
                ViewBag.ShowDownloadDocumentMsg = isShowDownloadDocumentMsg;

                //check if in session "BackURL" is set or not -- this URL is set from report contoller 
                //if url is set then set flag true in viewbag for URL from Report page and reset backurl to empty 
                if (objLoginUserDetails.BackURL != null && objLoginUserDetails.BackURL != "")
                {
                    IsCalledFromReport = true;
                    ViewBag.ReturnUrl = objLoginUserDetails.BackURL;

                    objLoginUserDetails.BackURL = "";
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                }

                ViewBag.IsCalledFromReport = IsCalledFromReport;

                ViewBag.CalledFromHardCopy = CalledFromHardCopy;

                ViewBag.HardCopyFileNotUploaded = HardCopyFileNotUploaded;

                ViewBag.frm = frm;

                ViewBag.UserAction = acid;

                // check from where document is displayed -- if policy document is displayed to user which are view only and whoes status is view only 
                // then add event to viewed for user
                if (CalledFrom != null && (CalledFrom.ToLower() == "view" || CalledFrom.ToLower() == "viewagreelist"))
                {
                    //check is document show is view only document 
                    if (objUsersPolicyDocumentModel.DocumentViewAgreeFlag != true && objUsersPolicyDocumentModel.DocumentViewFlag == true)
                    {
                        objUserPolicyDocumentEventLogDTO = new UserPolicyDocumentEventLogDTO();

                        objUserPolicyDocumentEventLogDTO.EventCodeId = ConstEnum.Code.PolicyDocumentViewd;
                        objUserPolicyDocumentEventLogDTO.MapToTypeCodeId = ConstEnum.Code.PolicyDocument;
                        objUserPolicyDocumentEventLogDTO.MapToId = objUsersPolicyDocumentModel.PolicyDocumentId;

                        // save policy document viewed event 
                        objInsiderInitialDisclosureSL.SaveEvent(objLoginUserDetails.CompanyDBConnectionString, objUserPolicyDocumentEventLogDTO, objLoginUserDetails.LoggedInUserID);
                    }
                }
                
                return View("~/Views/InsiderInitialDisclosure/ViewDocument.cshtml", objUsersPolicyDocumentModel);
            }
            catch (Exception ex)
            {
                string sErrMessage = Common.Common.getResource(ex.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("~/Views/InsiderInitialDisclosure/ViewDocument.cshtml");
            }
            finally
            {
                objDocumentDetailsSL = null;
                objDocumentDetailsDTOList = null;
                objUsersPolicyDocumentModel = null;
                objUsersPolicyDocumentDTO = null;
                objInsiderInitialDisclosureSL = null;
                objLoginUserDetails = null;
                objDocumentDetailsDTO = null;
                objUserPolicyDocumentEventLogDTO = null;
            }
        }
        #endregion DisplayPolicy

        #region DisplayHardCopy
        [AuthorizationPrivilegeFilter]
        public ActionResult DisplayHardCopy(int acid, int DocumentID, string DocumentPath, int TransactionMasterId, int DisclosureTypeId, string CalledFrom)
        {
            UsersPolicyDocumentModel objUsersPolicyDocumentModel = new UsersPolicyDocumentModel();
            UsersPolicyDocumentDTO objUsersPolicyDocumentDTO = new UsersPolicyDocumentDTO();
            InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL();
            try
            {
                objUsersPolicyDocumentModel.PolicyDocumentPath = DocumentPath;
                objUsersPolicyDocumentModel.DocumentId = DocumentID;
                ViewBag.TransactionMasterId = TransactionMasterId;
                ViewBag.DisclosureTypeId = DisclosureTypeId;
                Common.Common.CopyObjectPropertyByName(objUsersPolicyDocumentDTO, objUsersPolicyDocumentModel);
                if (objUsersPolicyDocumentModel.DocumentViewAgreeFlag == true)
                {
                    ViewBag.ViewAgreeFlag = true;
                    ViewBag.ViewFlag = false;
                }
                else if (objUsersPolicyDocumentModel.DocumentViewFlag == true)
                {
                    ViewBag.ViewAgreeFlag = false;
                    ViewBag.ViewFlag = true;
                }
                ViewBag.CalledFrom = CalledFrom;
                return View("ViewDocument", objUsersPolicyDocumentModel);
            }
            catch
            {
                return View("ViewDocument");
            }
            finally
            {
                objUsersPolicyDocumentModel = null;
                objInsiderInitialDisclosureSL = null;
            }
        }
        #endregion DisplayHardCopy

        #region Generate Policy Document
        [AuthorizationPrivilegeFilter]
        public void Generate(UsersPolicyDocumentModel objUsersPolicyDocumentModel, int acid, int nDocumentId = 0)
        {
            String mimeType = "application/unknown";
            DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL();
            DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            System.IO.FileInfo fFile = null;

            try
            {
                Dictionary<String, String> mtypes = new Dictionary<string, string>()
               {
                   {".pdf", "application/pdf"},
                   {".png", "application/png"},
                   {".jpeg", "application/jpeg"},
                   {".jpg", "application/jpeg"},
                   {".txt", "text/plain"},
                   {".xls", "application/vnd.ms-excel"},
                   {".xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet "},
                   {".doc", "application/msword"},
                   {".docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"},
               };
                if (nDocumentId == 0)
                    objDocumentDetailsDTO = objDocumentDetailsSL.GetDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, objUsersPolicyDocumentModel.DocumentId);
                else
                    objDocumentDetailsDTO = objDocumentDetailsSL.GetDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, nDocumentId);

                fFile = new System.IO.FileInfo(objDocumentDetailsDTO.DocumentPath);
                Response.Clear();

                // ContentDisposition Value and Parameter are used. 
                // Meaning of Value [inline]        : Displayed automatically
                // Meaning of Parameter [filename]	: Name to be used when creating file 
                ContentDisposition contentDisposition = new ContentDisposition
                {
                    FileName = objDocumentDetailsDTO.DocumentName,
                    Inline = true
                };
                Response.AppendHeader("Content-Disposition", contentDisposition.ToString());

                String filetype = fFile.Extension.ToLower();
                if (mtypes.Keys.Contains<String>(filetype))
                {
                    mimeType = mtypes[filetype];
                }

                Response.ContentType = mimeType;
                Response.WriteFile(fFile.FullName);
                Response.End();




                //NOTE - ADDED ABOVE CODE TO HANDLE DIFFERENT FILE TYPE
                ////Response.AddHeader("Content-Length", fFile.Length.ToString());
                //if (fFile.Extension.ToLower() == ".pdf")
                //{
                //    Response.ContentType = "application/pdf";
                //    Response.WriteFile(fFile.FullName);
                //    Response.End();

                //}
                //else if (fFile.Extension.ToLower() == ".xls" || fFile.Extension.ToLower() == ".xlsx")
                //{
                //    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                //    Response.WriteFile(fFile.FullName);
                //    Response.End();

                //}
                //else if (fFile.Extension.ToLower() == ".png" || fFile.Extension.ToLower() == ".jpg")
                //{
                //    Response.ContentType = "image/png";
                //    Response.WriteFile(fFile.FullName);
                //    Response.End();

                //}
                //else if (fFile.Extension.ToLower() == ".docx" || fFile.Extension.ToLower() == ".doc")
                //{
                //    Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                //    Response.WriteFile(fFile.FullName);
                //    Response.End();

                //    //NOTE - Following code is commented because to make functionality similar to other file types
                //    //START COMMENT ===>
                //    //Microsoft.Office.Interop.Word.Application objWordApp = new Microsoft.Office.Interop.Word.Application();
                //    //object objWordFile = objUsersPolicyDocumentModel.PolicyDocumentPath;
                //    //object objNull = System.Reflection.Missing.Value;
                //    //Microsoft.Office.Interop.Word.Document WordDoc = objWordApp.Documents.Open(
                //    //ref objWordFile, ref objNull, ref objNull,
                //    //ref objNull, ref objNull, ref objNull,
                //    //ref objNull, ref objNull, ref objNull,
                //    //ref objNull, ref objNull, ref objNull, ref objNull, ref objNull, ref objNull, ref objNull);

                //    //WordDoc.ActiveWindow.Selection.WholeStory();
                //    //WordDoc.ActiveWindow.Selection.Copy();
                //    //string strWordText = WordDoc.Content.Text;
                //    //WordDoc.Close(ref objNull, ref objNull, ref objNull);
                //    //objWordApp.Quit(ref objNull, ref objNull, ref objNull);
                //    //Response.Write(strWordText);
                //    //END COMMENT <===
                //}
                //else if (fFile.Extension.ToLower() == ".txt")
                //{
                //    Response.ContentType = "application/text";
                //    Response.WriteFile(fFile.FullName);
                //    Response.End();
                //}


                //byte[] bytes = System.IO.File.ReadAllBytes(objUsersPolicyDocumentModel.PolicyDocumentPath);                
                //return File(bytes, "application/pdf");             
            }
            catch (Exception exp)
            {
                @ViewBag.ErrorMsg = exp.Message;

                //throw exp;
            }
            finally
            {
                objDocumentDetailsSL = null;
                objDocumentDetailsDTO = null;
                objLoginUserDetails = null;
                fFile = null;
            }
        }

        #endregion Generate Policy Document

        #region PartialViewDocument
        [AuthorizationPrivilegeFilter]
        public ActionResult PartialViewDocument(UsersPolicyDocumentModel objUsersPolicyDocumentModel, int acid)
        {
            return PartialView(objUsersPolicyDocumentModel);
        }
        #endregion PartialViewDocument

        #region Accept Button
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Accept")]
        [ActionName("PartialViewDocument")]
        [AuthorizationPrivilegeFilter]
        public ActionResult Accept(UsersPolicyDocumentModel objUsersPolicyDocumentModel, int acid)
        {
            bool bReturn = false;
            UserPolicyDocumentEventLogModel objUserPolicyDocumentEventLogModel = new UserPolicyDocumentEventLogModel();
            UserPolicyDocumentEventLogDTO objUserPolicyDocumentEventLogDTO = new UserPolicyDocumentEventLogDTO();
            InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
            try
            {
                objUserPolicyDocumentEventLogModel.EventCodeId = ConstEnum.Code.PolicyDocumentAgreed;
                objUserPolicyDocumentEventLogModel.MapToTypeCodeId = ConstEnum.Code.PolicyDocument;
                objUserPolicyDocumentEventLogModel.MapToId = objUsersPolicyDocumentModel.PolicyDocumentId;

                Common.Common.CopyObjectPropertyByName(objUserPolicyDocumentEventLogModel, objUserPolicyDocumentEventLogDTO);
                bReturn = objInsiderInitialDisclosureSL.SaveEvent(objLoginUserDetails.CompanyDBConnectionString, objUserPolicyDocumentEventLogDTO, objLoginUserDetails.LoggedInUserID);

                if (bReturn)
                {
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.GetInitialDisclosureDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID).FirstOrDefault();
                }

                if (objInsiderInitialDisclosureDTO.EventDate != null)
                {

                    return RedirectToAction("List", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_POLICY_DOCUMENT_LIST }).Success(InsiderTrading.Common.Common.getResource("dis_grd_17452"));//"Policy is accepted.");
                }
                else
                {
                    return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE, ReqModuleId=objUsersPolicyDocumentModel.RequiredModuleID }).Success(InsiderTrading.Common.Common.getResource("dis_grd_17452"));//"Policy is accepted.");
                }
            }
            catch
            {
                return View();
            }
            finally
            {
                objUserPolicyDocumentEventLogModel = null;
                objUserPolicyDocumentEventLogDTO = null;
                objInsiderInitialDisclosureSL = null;
                objLoginUserDetails = null;
            }
        }

        #endregion Accept Button

        #region Next Button
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Next")]
        [ActionName("PartialViewDocument")]
        [AuthorizationPrivilegeFilter]
        public ActionResult Next(UsersPolicyDocumentModel objUsersPolicyDocumentModel, int acid)
        {
            bool bReturn = false;
            UserPolicyDocumentEventLogModel objUserPolicyDocumentEventLogModel = new UserPolicyDocumentEventLogModel();
            UserPolicyDocumentEventLogDTO objUserPolicyDocumentEventLogDTO = new UserPolicyDocumentEventLogDTO();
            InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                objUserPolicyDocumentEventLogModel.EventCodeId = ConstEnum.Code.PolicyDocumentViewd;
                objUserPolicyDocumentEventLogModel.MapToTypeCodeId = ConstEnum.Code.PolicyDocument;
                objUserPolicyDocumentEventLogModel.MapToId = objUsersPolicyDocumentModel.PolicyDocumentId;
                Common.Common.CopyObjectPropertyByName(objUserPolicyDocumentEventLogModel, objUserPolicyDocumentEventLogDTO);
                bReturn = objInsiderInitialDisclosureSL.SaveEvent(objLoginUserDetails.CompanyDBConnectionString, objUserPolicyDocumentEventLogDTO, objLoginUserDetails.LoggedInUserID);
                return RedirectToAction("Index", "InsiderInitialDisclosure", new { acid = ConstEnum.UserActions.INSIDER_DISCLOSURE_DETAILS_INITIAL_DISCLOSURE }).Success("Policy is viewed.");
            }
            catch
            {
                return View();
            }
            finally
            {
                objUserPolicyDocumentEventLogModel = null;
                objUserPolicyDocumentEventLogDTO = null;
                objInsiderInitialDisclosureSL = null;
                objLoginUserDetails = null;
            }
        }
        #endregion Next Button

        #region Private Method

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

            return lstPopulateComboDTO;
        }
        #endregion FillComboValues

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
        #region DownloadFormBOS
        [ValidateInput(false)]
        [AuthorizationPrivilegeFilter]
        public ActionResult DownloadFormBOS(int acid, int MapToTypeCodeId = 0, int nTransactionMasterId = 0, string DisplayCode = "")
        {

            LoginUserDetails objLoginUserDetails = null;
            InsiderInitialDisclosureSL objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL();
            FormBDetails_OSDTO objFormBDetails_OSDTO = null;
            try
            {

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objFormBDetails_OSDTO = objInsiderInitialDisclosureSL.GetFormBDetails_OS(objLoginUserDetails.CompanyDBConnectionString, Common.ConstEnum.Code.DisclosureTransactionforOS, Convert.ToInt32(nTransactionMasterId));
              

                Response.Clear();
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/pdf";
                Response.AppendHeader("content-disposition", "attachment;filename=" + DisplayCode + ".pdf");
                Response.Flush();
                Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
                Response.Buffer = true;

                // objFormEDetailsDTO = new FormEDetailsDTO();
                //  objFormEDetailsDTO.GeneratedFormContents = "<html><body>1.1.1	Description: Admin shall have the facility to set the configuration of trade details submission for insiders/employees in initial and period end disclosures.</body></html>";
                string LetterHTMLContent = objFormBDetails_OSDTO.GeneratedFormContents;
                System.Text.RegularExpressions.Regex rReplaceScript = new System.Text.RegularExpressions.Regex(@"<br>");
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
                return View("OtherSecuritiesIndex");
            }
        }
        #endregion DownloadFormBOS


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
