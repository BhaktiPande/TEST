using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTradingDAL.InsiderInitialDisclosure.DTO;
using InsiderTradingMassUpload;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class MassUploadController : Controller
    {

        [AuthorizationPrivilegeFilter]
        public ActionResult AllMassUpload(int acid)
        {
            ViewBag.acid = acid;
            LoginUserDetails objLoginUserDetails = null;
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(Common.ConstEnum.SessionValue.UserDetails);
            List<MassUploadDTO> lstMassUploadDTO = new List<MassUploadDTO>();
            MassUploadSL massUploadSL = new MassUploadSL();
            List<RoleActivityDTO> lstRoleActivities;
            int roleId, RequiredModuleID;

            switch (objLoginUserDetails.UserTypeCodeId)
            {
                case InsiderTradingMassUpload.ConstEnum.UserTypeCodeId.Admin:
                    roleId = 1;
                    break;
                case InsiderTradingMassUpload.ConstEnum.UserTypeCodeId.COUserType:
                    roleId = 2;
                    break;
                default:
                    roleId = 7;
                    break;
            }

            using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
            {
                InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_mst_company_details(objLoginUserDetails.CompanyDBConnectionString);
                RequiredModuleID = objInsiderInitialDisclosureDTO.RequiredModule;
            }

            if (acid == 344)
            {
                using (var objRoleActivityDAL = new RoleActivityDAL())
                {
                    lstRoleActivities = objRoleActivityDAL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, roleId);
                }

                bool isOwnUnable = false;
                bool IsOtherEnable = false;

                int TradingPolicyID_OS = 0;
                InsiderInitialDisclosureDTO objInsiderInitialDisclosureDTO = null;
                using (var objInsiderInitialDisclosureSL = new InsiderInitialDisclosureSL())
                {
                    objInsiderInitialDisclosureDTO = objInsiderInitialDisclosureSL.Get_TradingPolicyID_forOS(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                    TradingPolicyID_OS = Convert.ToInt32(objInsiderInitialDisclosureDTO.TradingPolicyID_OS);

                }

                switch (RequiredModuleID)
                {
                    case Common.ConstEnum.Code.RequiredModuleOwnSecurity:
                        isOwnUnable = true;
                        lstMassUploadDTO = massUploadSL.GetUploadMassList(GetAllMassUpload(), isOwnUnable, IsOtherEnable, objLoginUserDetails.UserTypeCodeId);
                        break;
                    case Common.ConstEnum.Code.RequiredModuleOtherSecurity:
                        IsOtherEnable = true;
                        lstMassUploadDTO = massUploadSL.GetUploadMassList(GetAllMassUpload(), isOwnUnable, IsOtherEnable, objLoginUserDetails.UserTypeCodeId);
                        break;
                    case Common.ConstEnum.Code.RequiredModuleBoth:
                        isOwnUnable = true;
                        if (TradingPolicyID_OS != 0 && Convert.ToString(TradingPolicyID_OS) != "")
                        {
                            IsOtherEnable = true;
                        }
                        lstMassUploadDTO = massUploadSL.GetUploadMassList(GetAllMassUpload(), isOwnUnable, IsOtherEnable, objLoginUserDetails.UserTypeCodeId);
                        break;
                }
            }
            else
            {
                switch (RequiredModuleID)
                {
                    case Common.ConstEnum.Code.RequiredModuleOwnSecurity:
                        lstMassUploadDTO = GetAllMassUpload().Where(c => !c.MassUploadName.Contains("- Other")).ToList();
                        break;
                    case Common.ConstEnum.Code.RequiredModuleOtherSecurity:
                        lstMassUploadDTO = GetAllMassUpload().Where(c => c.MassUploadExcelId != 2 && c.MassUploadExcelId != 5 && c.MassUploadExcelId != 4 && c.MassUploadExcelId != 51).ToList();
                        break;
                    case Common.ConstEnum.Code.RequiredModuleBoth:
                        lstMassUploadDTO = GetAllMassUpload();
                        break;
                }
            }

            lstMassUploadDTO = massUploadSL.GetSequenceMassUploadList(lstMassUploadDTO);
            ViewBag.AllMassUpload = lstMassUploadDTO;
            return View("~/Views/Common/MassUpload.cshtml");
        }
        //
        // GET: /FileImport/
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid, int massuploadid = 0)
        {
            if (massuploadid == 0)
            {

                return RedirectToAction("AllMassUpload", "MassUpload", new { acid = acid });
            }
            else
            {
                ViewBag.MassUploadId = massuploadid;
                ViewBag.acid = acid;
                return PartialView();
            }
        }
        [AuthorizationPrivilegeFilter]
        public ActionResult OpenFileUploadDialog(int acid, int massuploadid)
        {
            ViewBag.MessageText = "Do you want to upload the selected file?";
            MassUploadModel objMassUploadModel = new MassUploadModel();
            LoginUserDetails objLoginUserDetails = null;

            MassUploadDTO objMassUploadDTO = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)InsiderTrading.Common.ConstEnum.SessionValue.UserDetails);
                objMassUploadModel.MassUploadFile = Common.Common.GenerateDocumentList(InsiderTrading.Common.ConstEnum.Code.MassUpload, 0, 0, null, 0);
                using (MassUploadSL objMassUploadSL = new MassUploadSL())
                {
                    int i_MaauploadCount = objMassUploadSL.GetRnTMassuploadDayCount(objLoginUserDetails.CompanyDBConnectionString);

                    ViewBag.massuploadid = massuploadid;
                    ViewBag.acid = acid;
                    ViewBag.MassUploadName = "";
                    using (var objMassUploadDAL = new MassUploadDAL())
                    {
                        objMassUploadDTO = objMassUploadDAL.GetSingleMassUploadsDetails(objLoginUserDetails.CompanyDBConnectionString, massuploadid);
                    }
                    if (objMassUploadDTO != null)
                    {
                        ViewBag.MassUploadName = objMassUploadDTO.MassUploadName;
                    }
                    if (massuploadid == InsiderTrading.Common.ConstEnum.MassUploadTypes.MASSUPLOAD_REGISTERANDTRANSFER
                        && i_MaauploadCount > 0)
                    {
                        ViewBag.MessageText = "You have already uploaded the data today. Do you still want to upload the new data? This will override your previous data. You can download the previous data report before uploading the new data.";
                    }
                }
                ViewBag.user_action = acid;
                if (TempData["IsError"] != null)
                {
                    //ViewBag.IsError = TempData["IsError"];
                    ViewBag.ErrorMessage = TempData["ErrorMessage"];
                    ViewBag.SuccessMessage = TempData["SuccessMessage"];
                    ViewBag.ErrorFileGuid = TempData["ErrorFileGuid"];
                    ViewBag.AllSheetErrors = TempData["AllSheetErrors"];
                    ViewBag.AllSheetErrorsPresent = TempData["AllSheetErrorsPresent"];
                }
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objMassUploadDTO = null;
            }
            return View("SelectFileToUpload", objMassUploadModel);
        }
        //[AuthorizationPrivilegeFilter]
        //public ActionResult SaveFromExcel()
        //{
        //    return View("SelectFileToUpload");
        //}

        [HttpPost]
        [Button(ButtonName = "Cancel")]
        [ActionName("SaveImportedRecordsProc")]
        public ActionResult Cancel(int acid)
        {
            return RedirectToAction("AllMassUpload", "MassUpload", new { acid = InsiderTrading.Common.ConstEnum.UserActions.MASSUPLOAD_LIST });
        }

        [AuthorizationPrivilegeFilter]
        public ActionResult SaveImportedRecordsProc(int acid, MassUploadModel objMassUploadModel, Dictionary<int, List<DocumentDetailsModel>> dicPolicyDocumentsUploadFileList, int massuploadid)
        {
            LoginUserDetails objLoginUserDetails = null;
            string sCurrentCompanyDBName = "";
            string sConnectionString = "";
            CompanyDTO objCompanyToMassUpload;

            Dictionary<string, DocumentDetailsDTO> objDocumentDetailsdDTO = new Dictionary<string, DocumentDetailsDTO>();
            string sFilePath = "";
            string sFileName = "";
            string sErrorMessage = "";
            //objDocumentDetailsdDTO.
            string directory = ConfigurationManager.AppSettings["Document"];
            Dictionary<string, List<MassUploadResponseDTO>> objSheetWiseError = new Dictionary<string, List<MassUploadResponseDTO>>();
            Dictionary<string, string> objInvalidSheetColumnError = new Dictionary<string, string>();
            MassUploadDTO objSelectedMassUploadDTO = new MassUploadDTO();

            string sErrorFileGuid = "";
            bool bErrorExistInExcelSheets = false;
            bool bCheckifExcelIsvalid = false;
            int nSavedMassUploadLogId = 0;

            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)InsiderTrading.Common.ConstEnum.SessionValue.UserDetails);
                objDocumentDetailsdDTO = objLoginUserDetails.DocumentDetails;
                sCurrentCompanyDBName = objLoginUserDetails.CompanyName;
                sConnectionString = objLoginUserDetails.CompanyDBConnectionString;

                using (var objCompaniesSL = new CompaniesSL())
                {
                    objCompanyToMassUpload = objCompaniesSL.getSingleCompanies(Common.Common.getSystemConnectionString(), objLoginUserDetails.CompanyName);
                }
                sConnectionString = objCompanyToMassUpload.CompanyConnectionStringWithTimeout(5000);
                ViewBag.acid = acid;
                if (dicPolicyDocumentsUploadFileList.ContainsKey(InsiderTrading.Common.ConstEnum.Code.MassUpload) && dicPolicyDocumentsUploadFileList[InsiderTrading.Common.ConstEnum.Code.MassUpload].Count > 0)
                {
                    if (dicPolicyDocumentsUploadFileList[InsiderTrading.Common.ConstEnum.Code.MassUpload].Count > 0)
                    {

                        using (var objMassUploadSL = new MassUploadSL())
                        {
                            objSelectedMassUploadDTO = objMassUploadSL.GetSingleMassUploadDetails(sConnectionString, massuploadid);
                        }
                        string sUploadedFileOriginalName = dicPolicyDocumentsUploadFileList[InsiderTrading.Common.ConstEnum.Code.MassUpload][0].DocumentName;
                        sUploadedFileOriginalName = sUploadedFileOriginalName.Substring(0, sUploadedFileOriginalName.IndexOf("."));
                        if (objSelectedMassUploadDTO.TemplateFileName != sUploadedFileOriginalName)
                        {
                            sErrorMessage = "The selected file name does not match with the Template to be used for \"" + objSelectedMassUploadDTO.MassUploadName + "\". Please select correct file and try again.";
                            TempData["ErrorMessage"] = sErrorMessage;
                            TempData["IsError"] = "1";
                            return RedirectToAction("OpenFileUploadDialog", "MassUpload", new { acid = ViewBag.acid, massuploadid = massuploadid });
                        }

                        sFileName = dicPolicyDocumentsUploadFileList[InsiderTrading.Common.ConstEnum.Code.MassUpload][0].GUID;
                    }
                    sFilePath = directory + "temp/" + sFileName;
                }

                if (sFileName == null || sFileName == "" || sFilePath == "")
                {
                    sErrorMessage = "File not selected.";
                    TempData["ErrorMessage"] = sErrorMessage;
                    TempData["IsError"] = "1";
                    return RedirectToAction("OpenFileUploadDialog", "MassUpload", new { acid = ViewBag.acid, massuploadid = massuploadid });
                }
                using (var objParameterisedMassUploadSL = new MassUploadSL(massuploadid, sConnectionString, sCurrentCompanyDBName))
                {
                    //objMassUploadSL = new InsiderTradingMassUpload.MassUploadSL(massuploadid, sConnectionString, sCurrentCompanyDBName);
                    //Add entry in the Log table and generate the MapToId (i.e. the log table id) for the document to be saved.
                    objParameterisedMassUploadSL.AddUpdateLogEntry(objLoginUserDetails.CompanyDBConnectionString, 0, massuploadid, InsiderTrading.Common.ConstEnum.Code.MassUploadStarted, null, "", "", objLoginUserDetails.LoggedInUserID, out nSavedMassUploadLogId);
                    //Save the document and add entry in the Document table
                    List<DocumentDetailsModel> objSavedDocumentDetialsModelList = new List<DocumentDetailsModel>();
                    using (var objDocumentDetailsSL = new DocumentDetailsSL())
                    {
                        objSavedDocumentDetialsModelList = objDocumentDetailsSL.SaveDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, dicPolicyDocumentsUploadFileList[InsiderTrading.Common.ConstEnum.Code.MassUpload], Convert.ToInt32(InsiderTrading.Common.ConstEnum.Code.MassUpload), nSavedMassUploadLogId, objLoginUserDetails.LoggedInUserID);
                    }

                    objParameterisedMassUploadSL.AddUpdateLogEntry(objLoginUserDetails.CompanyDBConnectionString, nSavedMassUploadLogId, massuploadid, InsiderTrading.Common.ConstEnum.Code.MassUploadStarted, objSavedDocumentDetialsModelList[0].DocumentId, "", "", objLoginUserDetails.LoggedInUserID, out nSavedMassUploadLogId);
                    objParameterisedMassUploadSL.SetUploadedfileGUID(objSavedDocumentDetialsModelList[0].GUID);
                    sFilePath = objSavedDocumentDetialsModelList[0].DocumentPath;
                    objParameterisedMassUploadSL.SetExcelFilePath(sFilePath);
                    objParameterisedMassUploadSL.SetEncryptionSaltValue(Common.ConstEnum.User_Password_Encryption_Key);

                    objParameterisedMassUploadSL.ExecuteMassUploadCall();

                    bCheckifExcelIsvalid = objParameterisedMassUploadSL.IsExcelValid();

                    if (!bCheckifExcelIsvalid)
                    {
                        //Check if there are errors in the excel sheet before processing it for mass upload insert.
                        //If all the data from the excel is valid then only let user impoert the excel file.
                        bErrorExistInExcelSheets = objParameterisedMassUploadSL.CheckIfErrorExistInExcelSheets();
                        Dictionary<string, List<MassUploadExcelSheetErrors>> objAllSheetColumnWiseErrorList = objParameterisedMassUploadSL.GetExcelSheetWiseErrors();

                        if (bErrorExistInExcelSheets)
                        {
                            TempData["AllSheetErrors"] = objAllSheetColumnWiseErrorList;
                            TempData["AllSheetErrorsPresent"] = bErrorExistInExcelSheets;
                            sErrorFileGuid = objParameterisedMassUploadSL.WriteErrorsToExcel(ConfigurationManager.AppSettings["ExportDocument"], ConfigurationManager.AppSettings["Document"]);
                            //Update the error log file name in log table
                            objParameterisedMassUploadSL.AddUpdateLogEntry(objLoginUserDetails.CompanyDBConnectionString, nSavedMassUploadLogId, massuploadid, Common.ConstEnum.Code.MassUploadFailed, null, sErrorFileGuid + ".xlsx", "", objLoginUserDetails.LoggedInUserID, out nSavedMassUploadLogId);
                            TempData["ErrorFileGuid"] = sErrorFileGuid;
                            TempData["SuccessMessage"] = "Successfully Imported the Excel";
                        }
                    }
                    else
                    {
                        sErrorMessage = "Uploaded excel is not valid. Please use the provided template for corresponding mass upload and try again.";
                        objParameterisedMassUploadSL.AddUpdateLogEntry(objLoginUserDetails.CompanyDBConnectionString, nSavedMassUploadLogId, massuploadid, Common.ConstEnum.Code.MassUploadFailed, null, "", sErrorMessage, objLoginUserDetails.LoggedInUserID, out nSavedMassUploadLogId);
                    }
                }
            }
            catch (Exception exp)
            {
                sErrorMessage = exp.Message;
                if (exp.Source == "Microsoft JET Database Engine")
                {
                    sErrorMessage = "Uploaded excel is not valid. Please use the provided template for corresponding mass upload and try again.";
                }
                using (var objMassUploadSL = new MassUploadSL())
                {
                    objMassUploadSL.AddUpdateLogEntry(objLoginUserDetails.CompanyDBConnectionString, nSavedMassUploadLogId, massuploadid, Common.ConstEnum.Code.MassUploadFailed, null, "", sErrorMessage, objLoginUserDetails.LoggedInUserID, out nSavedMassUploadLogId);
                }
            }
            finally
            {
                //objLoginUserDetails = null;
                objCompanyToMassUpload = null; ;
                objDocumentDetailsdDTO = null;
                objSheetWiseError = null;
                objInvalidSheetColumnError = null;
                objSelectedMassUploadDTO = null;
            }
            //TempData is equivalent to ViewBag, but TempData is used when sending the data during redirection
            if ((sErrorMessage != null && sErrorMessage != "") || bErrorExistInExcelSheets)
            {
                TempData["ErrorMessage"] = sErrorMessage;
                TempData["IsError"] = "1";
            }
            else
            {
                TempData["SuccessMessage"] = "Successfully Imported the Excel";
                TempData["IsError"] = "0";
                using (var objMassUploadSL = new MassUploadSL())
                {
                    objMassUploadSL.AddUpdateLogEntry(objLoginUserDetails.CompanyDBConnectionString, nSavedMassUploadLogId, massuploadid, Common.ConstEnum.Code.MassUploadCompleted, null, "", "", objLoginUserDetails.LoggedInUserID, out nSavedMassUploadLogId);
                }
            }
            objMassUploadModel.MassUploadFile = Common.Common.GenerateDocumentList(Common.ConstEnum.Code.MassUpload, 0, 0, null, 0);
            return RedirectToAction("OpenFileUploadDialog", "MassUpload", new { acid = ViewBag.acid, massuploadid = massuploadid });
        }

        /// <summary>
        /// This function will be used for downloading the errors generated when processing the Mass upload for the employees excel.
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public FileStreamResult DownloadErrorExcel(int acid, string fileguid)
        {
            string sExportDocumentPath = ConfigurationManager.AppSettings["Document"];
            string[] sFilesfromExportFolder = Directory.GetFiles(sExportDocumentPath);

            string sReportDownloadfileName = "MassUploadErrorLog.xlsx";
            DateTime objCurrentDate = DateTime.Now;
            string sFormattedCurrentDate = Common.Common.ApplyFormatting(objCurrentDate, Common.ConstEnum.DataFormatType.Date);

            //Delete the files whioch are created 5 min before
            foreach (string sOldExportFile in sFilesfromExportFolder)
            {
                FileInfo fi = new FileInfo(sOldExportFile);
                if (fi.LastAccessTime < DateTime.Now.AddMinutes(-5))
                {
                    fi.Delete();
                }
            }

            string sFilePathToDownload = sExportDocumentPath + "MassUploadError/" + fileguid + ".xlsx";
            return File(new FileStream(sFilePathToDownload, FileMode.Open), ".xlsx", sReportDownloadfileName);
        }

        /// <summary>
        /// This function will be used for downloading the excel template to be used for massupload for the given type.
        /// </summary>
        /// <returns></returns>
        /// 
        [AuthorizationPrivilegeFilter]
        public ActionResult DownloadTemplateExcel(int acid, string MassUploadId, string Type = "xls")
        {
            string sExportDocumentPath = ConfigurationManager.AppSettings["Document"] + "Templates/MassUpload/";
            string[] sFilesfromExportFolder = Directory.GetFiles(sExportDocumentPath);
            LoginUserDetails objLoginUserDetails = null;

            string sDownloadfileName = "";
            //MassUploadSL objMassUploadSL = new MassUploadSL();
            MassUploadDTO objMassUploadDTO = null;
            if (MassUploadId == "")
                MassUploadId = "0";
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)InsiderTrading.Common.ConstEnum.SessionValue.UserDetails);
                if (MassUploadId == "0")
                {
                    return RedirectToAction("AllMassUpload", "MassUpload",
                        new { acid = Common.ConstEnum.UserActions.MASSUPLOAD_LIST }).
                        Warning(HttpUtility.UrlEncode("Template file is missing, please contact the Administrator."));
                }
                using (var objMassUploadSL = new MassUploadSL())
                {
                    objMassUploadDTO = objMassUploadSL.GetSingleMassUploadDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(MassUploadId));
                }
                sDownloadfileName = objMassUploadDTO.TemplateFileName;
                string sFilePathToDownload = sExportDocumentPath + sDownloadfileName + "." + Type;
                return File(new FileStream(sFilePathToDownload, FileMode.Open), "." + Type, sDownloadfileName + "." + Type);
            }
            catch (Exception exp)
            {
                string sErrorMessage = exp.Message;

                return RedirectToAction("AllMassUpload", "MassUpload",
                        new { acid = Common.ConstEnum.UserActions.MASSUPLOAD_LIST }).
                        Warning(HttpUtility.UrlEncode("Template file is missing, please contact the Administrator."));
            }
            finally
            {
                objLoginUserDetails = null;
                objMassUploadDTO = null;
            }

        }

        #region GetAllMassUpload
        /// <summary>
        /// This function will return all the mass uploaded from the system, this is to show all the mass uploads on the AllMass uploads pages
        /// </summary>
        /// <returns></returns>
        private List<MassUploadDTO> GetAllMassUpload()
        {
            List<MassUploadDTO> lstMassUploadDTO = new List<MassUploadDTO>();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)Common.ConstEnum.SessionValue.UserDetails);
            try
            {
                using (var objMassUploadSL = new MassUploadSL())
                {
                    lstMassUploadDTO = objMassUploadSL.GetAllMassUpload(objLoginUserDetails.CompanyDBConnectionString);
                }
            }
            catch (Exception exp)
            {

            }
            return lstMassUploadDTO;
        }
        #endregion GetAllMassUpload

        /// <summary>
        /// This function will be used for downloading the excel containing the list of Employees with status if Period End is completed or not
        /// </summary>
        /// <returns></returns>
        public ActionResult DownloadPeriodEndPerformedExcel(int acid)
        {
            string[] m_sExcelColumnNames = new string[] { "", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
            string sTmpFileName = "ExcelDownload";
            string i_sExportDocumentFolderPath = ConfigurationManager.AppSettings["Document"];
            string MASSUPLOAD_ERROR_EXCEL_SHEET_NAME = "EmployeePeriodEnd";
            string ERROR_EXCEL_COLUMN1_HEADER = "UserInfoId";
            string ERROR_EXCEL_COLUMN2_HEADER = "LoginId";
            string ERROR_EXCEL_COLUMN3_HEADER = "Has Performed Period End";
            string ERROR_EXCEL_COLUMN4_HEADER = "EmployeeName";
            System.Collections.ArrayList arrColumnWidth = new System.Collections.ArrayList();
            int nExcelRowCounter = 1;
            InsiderTrading.SL.UserInfoSL objUserInfoSL = null;
            MassUploadSL objMassUploadSL = null;
            InsiderTradingExcelWriter.ExcelFacade.CommonOpenXMLObject objCommonOpenXMLObject;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)Common.ConstEnum.SessionValue.UserDetails);
            string sCompanyConnectionString = objLoginUserDetails.CompanyDBConnectionString;
            int nPeriodEndMassUploadId = 6;
            string sFilePathToDownload = null;
            try
            {
                using (objMassUploadSL = new MassUploadSL())
                {
                    MassUploadDTO objMassUploadDTO = objMassUploadSL.GetSingleMassUploadDetails(sCompanyConnectionString, nPeriodEndMassUploadId);
                    sTmpFileName = objMassUploadDTO.TemplateFileName;
                    MASSUPLOAD_ERROR_EXCEL_SHEET_NAME = objMassUploadDTO.SheetName;
                }
                string[] sFilesfromExportFolder = Directory.GetFiles(i_sExportDocumentFolderPath);
                //Delete the files which are created 5 min before from the Document folder
                foreach (string sOldExportFile in sFilesfromExportFolder)
                {
                    FileInfo fi = new FileInfo(sOldExportFile);
                    if (fi.LastAccessTime < DateTime.Now.AddMinutes(-5))
                    {
                        fi.Delete();
                    }
                }

                objCommonOpenXMLObject = new InsiderTradingExcelWriter.ExcelFacade.CommonOpenXMLObject();
                objCommonOpenXMLObject.OpenFile(i_sExportDocumentFolderPath + sTmpFileName + ".xlsx", true);
                objCommonOpenXMLObject.OpenXMLObjectCreation();
                objCommonOpenXMLObject.OpenXMLCreateWorkSheetPartSheetData();
                arrColumnWidth.Add("1:40:25");
                objCommonOpenXMLObject.AssignColumnWidth(arrColumnWidth);


                objCommonOpenXMLObject.CreateNewRow(nExcelRowCounter);
                objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[1], ERROR_EXCEL_COLUMN1_HEADER, nExcelRowCounter,
                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_NO_BORDER);
                objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[2], ERROR_EXCEL_COLUMN2_HEADER, nExcelRowCounter,
                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_NO_BORDER);
                objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[3], ERROR_EXCEL_COLUMN3_HEADER, nExcelRowCounter,
                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_NO_BORDER);
                objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[4], ERROR_EXCEL_COLUMN4_HEADER, nExcelRowCounter,
                    (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_NO_BORDER);
                nExcelRowCounter++;
                objCommonOpenXMLObject.AddToSheetData();
                GC.Collect();
                GC.WaitForFullGCComplete();

                using (objUserInfoSL = new SL.UserInfoSL())
                {
                    List<UserInfoDTO> objUserInfoList = objUserInfoSL.GetPeriodEndPerformedUserInfoList(sCompanyConnectionString);
                    int nCounter = 1;
                    foreach (UserInfoDTO objUserInfoDTO in objUserInfoList)
                    {
                        objCommonOpenXMLObject.CreateNewRow(nExcelRowCounter);
                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[1], nCounter.ToString(), nExcelRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.DEFAULT_NO_STYLE);
                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[2], objUserInfoDTO.LoginID, nExcelRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.DEFAULT_NO_STYLE);
                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[3], objUserInfoDTO.PeriodEndPerformed, nExcelRowCounter,
                           (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.DEFAULT_NO_STYLE);
                        objCommonOpenXMLObject.CreateTextCell(m_sExcelColumnNames[4], objUserInfoDTO.EmployeeName, nExcelRowCounter,
                            (int)InsiderTradingExcelWriter.ExcelFacade.ConstantEnum.OpenXMLStyleIndex.DEFAULT_NO_STYLE);
                        nExcelRowCounter++;
                        objCommonOpenXMLObject.AddToSheetData();
                        nCounter++;
                    }
                }

                objCommonOpenXMLObject.OpenXMLWorksheetAssignment(MASSUPLOAD_ERROR_EXCEL_SHEET_NAME, "", false);
                objCommonOpenXMLObject.SaveWorkSheet();
                objCommonOpenXMLObject.CloseSpreadSheet();

                sFilePathToDownload = i_sExportDocumentFolderPath + sTmpFileName + ".xlsx";
                if (!System.IO.File.Exists(sFilePathToDownload))
                {
                    sFilePathToDownload = null;
                }

            }
            catch (Exception exp)
            {
                string sErrorMessage = exp.Message;

                return RedirectToAction("AllMassUpload", "MassUpload",
                        new { acid = Common.ConstEnum.UserActions.MASSUPLOAD_LIST }).
                        Warning(HttpUtility.UrlEncode("Error occurred when downloading the template with data, please contact the Administrator.Error occurred is:" + sErrorMessage));
            }
            finally
            {
                objCommonOpenXMLObject = null;
            }

            if (sFilePathToDownload != null && sFilePathToDownload != "")
            {
                return File(new FileStream(sFilePathToDownload, FileMode.Open), ".xlsx", sTmpFileName + ".xlsx");
            }
            else
            {
                return RedirectToAction("AllMassUpload", "MassUpload",
                        new { acid = Common.ConstEnum.UserActions.MASSUPLOAD_LIST }).
                        Warning(HttpUtility.UrlEncode("Error occurred when downloading the template with data, please contact the Administrator.Error occurred is: File not created."));
            }
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }

    }
}