using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using iTextSharp.text;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ICSharpCode.SharpZipLib.Zip;
using System.Data;
using System.Web.UI.WebControls;
using System.Configuration;
using Newtonsoft.Json;
using System.Data.SqlClient;
using OfficeOpenXml;
using OfficeOpenXml.Style;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class NSEDownloadController : Controller
    {
        private string sLookupPrefix = "tra_msg_";
        int nDisclosureCompletedFlag = 0;

        #region Insider All Action & Methods

        #region Index List Page
        /// <summary>
        /// 
        /// </summary>
        /// <param name="acid"></param>
        /// <param name="PreClearanceRequestID"></param>
        /// <param name="PreClearanceRequestStatus"></param>
        /// <param name="TradeDetailsID"></param>
        /// <returns></returns>

        public ActionResult Index(int acid, string LetterStatus = null)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            UserInfoSL objUserInfoSL = new UserInfoSL();
            UserInfoDTO objUserInfoDTO = null;
            PreclearanceRequestSL objPreclearanceRequestSL = new PreclearanceRequestSL();
            try
            {
                ViewBag.LetterStatus = LetterStatus;
                ViewBag.NSEGroupNo = FillComboValues(ConstEnum.ComboType.NSEGroupNumber, InsiderTrading.Common.ConstEnum.CodeGroup.NSEDownloadOptions, null, null, null, null, true);
                ViewBag.GroupSubmissionStatus = FillComboValues(ConstEnum.ComboType.EventGroupStatusList, InsiderTrading.Common.ConstEnum.CodeGroup.NSEDownloadOptions, null, null, null, null, true);
                ViewBag.Param1 = objLoginUserDetails.LoggedInUserID;
                FillGrid(Common.ConstEnum.GridType.NSEDownload, "0", null, null);
                objUserInfoDTO = objUserInfoSL.GetUserDetails(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                return View("Index");
            }
            catch (Exception exp)
            {
                return View("Index");
            }
            finally
            {
                objLoginUserDetails = null;
                objUserInfoSL = null;
                objUserInfoDTO = null;
                objPreclearanceRequestSL = null;
            }
        }

        public void DownloadFls(int UserInfoIdCheck, int GroupId, DateTime? SubmissionDate)
        {
            #region DownloadZipFolder
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            using (NSEGroupSL ObjNSEGroupSL = new NSEGroupSL())
            {
                List<NSEGroupDocumentMappingDTO> list = ObjNSEGroupSL.Get_All_NSEGroupDocument(objLoginUserDetails.CompanyDBConnectionString, GroupId, UserInfoIdCheck);
                string downloadFle = string.Empty;
                string directory = ConfigurationManager.AppSettings["Document"];
                using (var zipStream = new ZipOutputStream(Response.OutputStream))
                {
                    if (UserInfoIdCheck == 1)
                    {
                        foreach (var downloadDt in list)
                            downloadFle = "attachment; filename=" + Convert.ToString(downloadDt.DownloadedDate) + ".zip";
                    }
                    else
                        downloadFle = "attachment; filename=" + Convert.ToString(SubmissionDate) + ".zip";

                    Response.AddHeader("Content-Disposition", downloadFle);
                    Response.ContentType = "application/zip";
                    int recCount=0;
                    string docName = string.Empty;
                    foreach (var docPath in list)
                    {
                        if (UserInfoIdCheck == 1)
                        {
                            recCount = recCount + 1;
                            docName = docPath.DocumentName + " " + "(" + recCount + ")" + ".pdf";
                        }
                        else
                            docName = docPath.DocumentName;
                       
                        string documentPath = (Path.Combine(directory, Convert.ToString(objLoginUserDetails.CompanyName), docPath.MapToTypeCodeId.ToString(), GroupId.ToString(), docPath.GUID));
                        byte[] fileBytes = System.IO.File.ReadAllBytes(documentPath);
                        var fileEntry = new ZipEntry(Path.GetFileName(documentPath).Replace(docPath.GUID,docName))
                        {
                            Size = fileBytes.Length,
                        };
                        zipStream.PutNextEntry(fileEntry);
                        zipStream.Write(fileBytes, 0, fileBytes.Length);
                    }
                    zipStream.Flush();
                    zipStream.Close();
                }
            }
            #endregion DownloadZipFolder
        }

        public void DownloadZipFolder(int acid, int GroupId)
        {
            //download Form C Pdf Files
            int UserInfoIdCheck = 1;
            DateTime? SubmitDt = null;
            DownloadFls(UserInfoIdCheck, GroupId, SubmitDt);
        }

        public void DownloadWordDocument()
        {
            string LetterHTMLContent = Convert.ToString(TempData["LetterHTMLContent"]);
            HttpContext.Response.Clear();
            HttpContext.Response.Charset = "";
            HttpContext.Response.ContentType = "application/msword";
            string strFileName = "Letter Template for Form C" + ".doc";
            HttpContext.Response.AddHeader("Content-Disposition", "inline;filename=" + strFileName);
            System.Text.StringBuilder strHTMLContent = new System.Text.StringBuilder();
            strHTMLContent.Append(LetterHTMLContent);
            HttpContext.Response.Write(strHTMLContent);
            HttpContext.Response.End();
            HttpContext.Response.Flush();
        }

        public void DownloadExcel(int acid, int GroupId)
        {
            int UserInfoIdCheck = 1;
            string exlFilename = string.Empty;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            using (NSEGroupSL ObjNSEGroupSL = new NSEGroupSL())
            {
                List<NSEGroupDocumentMappingDTO> listDownloadDate = ObjNSEGroupSL.Get_All_NSEGroupDocument(objLoginUserDetails.CompanyDBConnectionString, GroupId, UserInfoIdCheck);
                foreach (var downloadDt in listDownloadDate)
                    exlFilename = "attachment; filename=Stock Exchange Submission" + " " + Convert.ToString(downloadDt.DownloadedDate) + ".xlsx";
            }
            string sConnectionString = string.Empty;
            sConnectionString = objLoginUserDetails.CompanyDBConnectionString;
            SqlConnection con = new SqlConnection(sConnectionString);
            SqlCommand cmd = new SqlCommand();
            con.Open();
            DataTable dt = new DataTable();
            cmd = new SqlCommand("st_tra_NSEDownloadGroupWiseExcel", con);
            cmd.Parameters.AddWithValue("@GroupId", GroupId);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adp = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adp.Fill(dt);
            ExcelPackage excel = new ExcelPackage();
            var workSheet = excel.Workbook.Worksheets.Add("Stock Exchange Submission");
            var totalCols = dt.Columns.Count;
            var totalRows = dt.Rows.Count;
            workSheet.Cells["V1:AA1"].Merge = true;
            workSheet.Cells["V1:AA1"].Value = "Trading in derivatives";
            workSheet.Cells["V1:AA1"].Style.Border.Top.Style = workSheet.Cells["V1:AA1"].Style.Border.Bottom.Style = workSheet.Cells["V1:AA1"].Style.Border.Left.Style = workSheet.Cells["V1:AA1"].Style.Border.Right.Style = ExcelBorderStyle.Thin;
            workSheet.Cells["V1:AA1"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            workSheet.Cells["G2:I2"].Merge = true;
            workSheet.Cells["G2:I2"].Value = "Securities held prior*";
            workSheet.Cells["J2:M2"].Merge = true;
            workSheet.Cells["J2:M2"].Value = "Securities Acquired/Disposed";
            workSheet.Cells["N2:P2"].Merge = true;
            workSheet.Cells["N2:P2"].Value = "Securities held post*";
            workSheet.Cells["Q2:R2"].Merge = true;
            workSheet.Cells["Q2:R2"].Value = "Date of allotment advice/acquisition of shares/sale of shares*specify*";
            workSheet.Cells["S2"].Merge = true;
            workSheet.Cells["S2"].Value = "Date of intimation to Company*";
            workSheet.Cells["T2"].Merge = true;
            workSheet.Cells["T2"].Value = "Mode of Acquisition/Disposal";
            workSheet.Cells["U2"].Merge = true;
            workSheet.Cells["U2"].Value = "Type of Contract";
            workSheet.Cells["V2"].Merge = true;
            workSheet.Cells["V2"].Value = "Contract Specification from type of security";
            workSheet.Cells["W2:X2"].Merge = true;
            workSheet.Cells["W2:X2"].Value = "Buy";
            workSheet.Cells["Y2:Z2"].Merge = true;
            workSheet.Cells["Y2:Z2"].Value = "Sell";
            workSheet.Cells["AA2"].Merge = true;
            workSheet.Cells["AA2"].Value = "Exchange on which the trade was Executed*";
            workSheet.Cells["AB2"].Merge = true;
            workSheet.Cells["AB2"].Value = "Total Value In Aggregate";
            string cellRangeHeader = "A2:AB2";

            using (ExcelRange rngHeader = workSheet.Cells[cellRangeHeader])
            {
                rngHeader.Style.WrapText = true;
                rngHeader.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rngHeader.Style.Font.Bold = true;
                rngHeader.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                rngHeader.Style.Border.Top.Style = rngHeader.Style.Border.Bottom.Style = rngHeader.Style.Border.Left.Style = rngHeader.Style.Border.Right.Style = ExcelBorderStyle.Thin;
            }
            for (var col = 1; col <= totalCols; col++)
            {
                workSheet.Cells[3, col].Value = dt.Columns[col - 1].ColumnName;
                workSheet.Cells[3, col].Style.Font.Name = "Arial";
                workSheet.Cells[3, col].Style.Font.Size = 10;
                workSheet.Cells[3, col].Style.Font.Color.SetColor(System.Drawing.Color.Black);
                string cellRange = "A3:AB3";
                using (ExcelRange rng = workSheet.Cells[cellRange])
                {
                    rng.Style.WrapText = true;
                    rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    rng.Style.Font.Bold = true;
                    rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rng.Style.Border.Top.Style = rng.Style.Border.Bottom.Style = rng.Style.Border.Left.Style = rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                }
            }

            int excelRow = 3;
            for (var row = 0; row < totalRows; row++)
            {
                for (var col = 0; col < totalCols; col++)
                {
                    workSheet.Cells[excelRow + 1, col + 1].Value = dt.Rows[row][col].ToString();
                    workSheet.Cells[excelRow + 1, col + 1].Style.Border.Top.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Bottom.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Left.Style = workSheet.Cells[excelRow + 1, col + 1].Style.Border.Right.Style = ExcelBorderStyle.Thin;

                    workSheet.Cells[excelRow + 1, col + 1].Style.WrapText = true;
                    workSheet.Cells[excelRow + 1, col + 1].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                }
                excelRow++;
            }
            using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", exlFilename);
                excel.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }

        public ActionResult DownloadDocument(int acid, int GroupId)
        {
            LoginUserDetails objLoginUserDetails = null;
            TemplateMasterDTO objTemplateMasterDTO = null;            
            ViewBag.GroupID = GroupId;
            ViewBag.ShowNote = false;
            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            using (NSEGroupSL ObjNSEGroupSL = new NSEGroupSL())
            {
                List<NSEGroupDTO> lstSubmitDate = ObjNSEGroupSL.Get_Group_Date(objLoginUserDetails.CompanyDBConnectionString, GroupId);
                foreach (var submitdate in lstSubmitDate)
                {
                    DateTime? SubmissionDate = submitdate.SubmissionDate;
                    if (SubmissionDate.HasValue)
                    {
                        //download uploaded documents
                        int UserInfoIdCheck = 0;
                        DownloadFls(UserInfoIdCheck, GroupId, SubmissionDate);
                    }
                    else
                    {
                        TransactionLetterModel objTransactionLetterModel = new TransactionLetterModel();
                        objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                        using (TemplateMasterSL ObjTemplateMasterSL = new TemplateMasterSL())
                        {
                            int DisclosureTypeCodeId = ConstEnum.Code.DisclosureTypeContinuous;
                            int LetterCode = ConstEnum.Code.DisclosureLetterUserCO;
                            TempData["NseDownloadFlag"] = 1;
                            TempData["NseDownloadFlag2"] = 1;
                            objTemplateMasterDTO = ObjTemplateMasterSL.GetTransactionLetterDetailsForGroup(objLoginUserDetails.CompanyDBConnectionString, DisclosureTypeCodeId, LetterCode);
                            Common.Common.CopyObjectPropertyByName(objTemplateMasterDTO, objTransactionLetterModel);                            
                            objTransactionLetterModel.DisclosureTypeCodeId = ConstEnum.Code.DisclosureTypeContinuous;
                            objTransactionLetterModel.LetterForCodeId = LetterCode;
                            objTransactionLetterModel.CompanyLogo = objLoginUserDetails.CompanyLogoURL;
                            ViewBag.Layout = "~/Views/shared/_Layout.cshtml";
                            ViewBag.acid = acid;
                            ViewBag.EditLetter = false;
                            objLoginUserDetails.UserTypeCodeId = ConstEnum.Code.COUserType;
                        }
                        return View("~/Views/Pdf/Letter.cshtml", objTransactionLetterModel);
                    }
                }
            }
            return null;
        }

        public ActionResult ViewGroupDetails(int acid, int GroupId)
        {
            ViewBag.GroupID = GroupId;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            using (NSEGroupSL ObjNSEGroupSL = new NSEGroupSL())
            {
                List<NSEGroupDTO> lstDate = ObjNSEGroupSL.Get_Group_Date(objLoginUserDetails.CompanyDBConnectionString, GroupId);
                foreach (var submitdate in lstDate)
                {
                    DateTime? SubmissionDate = submitdate.SubmissionDate;
                    if (SubmissionDate.HasValue)
                    {
                        return RedirectToAction("ListByCO", "PreclearanceRequest", new { acid = ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE, GroupId });
                    }
                    else
                    {
                        FillGrid(Common.ConstEnum.GridType.NSEDownloadDeleteGroupDetails, "0", null, null);
                        return View("ViewGroupDetails");
                    }
                }
            }
            return null;
        }

        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteGroupDetails(string arrIncluded, int acid, int GroupId)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            try
            {
                string[][] arrGroupDetails = null;
                Common.Common objCommon = new Common.Common();

                if (arrIncluded != "")
                    arrGroupDetails = JsonConvert.DeserializeObject<string[][]>(arrIncluded);

                DataTable dtDeleteGroupDetails = new DataTable();
                dtDeleteGroupDetails.Columns.Add(new DataColumn("TransactionMasterID", typeof(int)));

                if (arrGroupDetails != null)
                {
                    for (int i = 0; i < arrGroupDetails.Length; i++)
                    {
                        DataRow row = null;
                        for (int j = 0; j < arrGroupDetails[i].Length; j++)
                        {
                            row = dtDeleteGroupDetails.NewRow();
                            row["TransactionMasterID"] = Convert.ToInt32(arrGroupDetails[i][j]);
                            dtDeleteGroupDetails.Rows.Add(row);
                        }
                        row = null;
                    }
                }
                bool bReturn = false;
                if (dtDeleteGroupDetails.Rows.Count == 0 || dtDeleteGroupDetails.Rows.Count < 0)
                {
                    ErrorDictionary.Add("error", "Record deletion failed");
                }
                else if (dtDeleteGroupDetails.Rows.Count > 0)
                {
                    for (int i = 0; i < dtDeleteGroupDetails.Rows.Count; i++)
                    {
                        int TransactionMasterId = Convert.ToInt32(dtDeleteGroupDetails.Rows[i]["TransactionMasterID"].ToString());

                        NSEGroupSL objNSEGroupSL = new NSEGroupSL();
                        LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                        List<InsiderTradingDAL.NSEGroupDocumentMappingDTO> list = objNSEGroupSL.Get_Singledocument_Details(objLoginUserDetails.CompanyDBConnectionString, TransactionMasterId);
                        InsiderTradingDAL.NSEGroupDetailsDTO objNSEGroupDetailsDTO = new InsiderTradingDAL.NSEGroupDetailsDTO();
                        objNSEGroupDetailsDTO.TransactionMasterId = TransactionMasterId;
                        objNSEGroupDetailsDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                        bReturn = objNSEGroupSL.Delete_User_From_NSEGroup(objLoginUserDetails.CompanyDBConnectionString, objNSEGroupDetailsDTO);
                        string directory = ConfigurationManager.AppSettings["Document"];
                        string OutputPathWithFileName = Path.Combine(directory, objLoginUserDetails.CompanyName, ConstEnum.Code.NseDocumentFormC.ToString(), TransactionMasterId.ToString());
                        foreach (var path in list)
                        {
                            string sGUID = Convert.ToString(path.GUID);
                            string sourceFileNameWithPath = Path.Combine(directory, objLoginUserDetails.CompanyName, ConstEnum.Code.NseDocumentFormC.ToString(), GroupId.ToString(), Convert.ToString(sGUID.ToString()));
                            FileInfo file = new FileInfo(Path.Combine(directory, objLoginUserDetails.CompanyName, ConstEnum.Code.NseDocumentFormC.ToString(), GroupId.ToString(), Convert.ToString(sGUID.ToString())));
                            if (file.Exists)
                                System.IO.File.Move(sourceFileNameWithPath, OutputPathWithFileName + "//" + sGUID);                            
                        }
                        statusFlag = true;
                    }
                    if (bReturn)
                    {
                        statusFlag = true;
                        ErrorDictionary.Add("success", "Record deleted successfully");
                    }
                    else
                    {
                        ErrorDictionary.Add("error", "Record deletion failed");
                    }
                }
                FillGrid(Common.ConstEnum.GridType.NSEDownloadDeleteGroupDetails, "0", null, null);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Json(new { status = statusFlag, Message = ErrorDictionary }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult UploadDocument(int acid, int GroupId)
        {
           
            NSEGroupSL ObjNSEGroupSL = new NSEGroupSL();            
            NSEGroupDocumentMappingModel objNSEDocumentModel = null;
            LoginUserDetails objLoginUserDetails = null;
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            objNSEDocumentModel = new NSEGroupDocumentMappingModel();
            ViewBag.UserAction = acid;
            DateTime? date = null;
            List<NSEGroupDTO> lstDate = ObjNSEGroupSL.Get_Group_Date(objLoginUserDetails.CompanyDBConnectionString, GroupId);
            foreach (var submitdate in lstDate)
            {
                date = submitdate.DownloadedDate;
            }       
            ViewBag.groupId = GroupId;
            ViewBag.DownloadDate = date;
            objNSEDocumentModel.NSEGroupDocumentFile = Common.Common.GenerateDocumentList(ConstEnum.Code.UploadNseDocument, 0, 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.NSEUploadFile);
            return View("NSEUploadDoc", objNSEDocumentModel);
        }

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Save")]
        [ActionName("UploadDocument")]
        [AuthorizationPrivilegeFilter]
        public ActionResult Save(InsiderTrading.Models.NSEGroupDocumentMappingModel objNSEGroupDocumentModel, Dictionary<int, List<DocumentDetailsModel>> dicPolicyDocumentsUploadFileList, int GroupId)
        {
            ModelState.Remove("KEY");
            ModelState.Add("KEY", new ModelState());
            ModelState.Clear();
            var StockExchangeDateSubmission = Request.Form["SubmissionFromDate"];
            LoginUserDetails objLoginUserDetails = null;          
            DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL();
            List<DocumentDetailsModel> UploadFileDocumentDetailsModelList = null;
            NSEGroupDocumentMappingDTO objNSEGroupDocDTO = new NSEGroupDocumentMappingDTO();
            NSEGroupDetailsDTO objNSEGroupDetailsDTO = new NSEGroupDetailsDTO();
            NSEGroupDTO objNSEGroupDTO = new NSEGroupDTO();
            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            DateTime? date = null;
            using (NSEGroupSL ObjNSEGroupSL = new NSEGroupSL())
            {
                List<NSEGroupDTO> lstDate = ObjNSEGroupSL.Get_Group_Date(objLoginUserDetails.CompanyDBConnectionString, GroupId);
                foreach (var submitdate in lstDate)
                {
                    date = submitdate.DownloadedDate;
                }
            }
            if (StockExchangeDateSubmission == "")
            {
                ModelState.AddModelError("DateOfSubmissionToNSE", Common.Common.getResource("nse_lbl_50535"));
            }
            else
            {
                objNSEGroupDTO.SubmissionDate = Convert.ToDateTime(StockExchangeDateSubmission);
                if (objNSEGroupDTO.SubmissionDate > Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString))
                {
                    ModelState.AddModelError("DateOfSubmissionToNSE", Common.Common.getResource("nse_lbl_50534"));
                }
                if (Convert.ToDateTime(date).Date > objNSEGroupDTO.SubmissionDate)
                {
                   ModelState.AddModelError("DateOfSubmissionToNSE", Common.Common.getResource("nse_lbl_50536"));
                }
                 
            }
            if (ModelState.IsValid)
            {                
                if (dicPolicyDocumentsUploadFileList.Count > 0) // file is uploaded and data found for file upload
                {
                    UploadFileDocumentDetailsModelList = dicPolicyDocumentsUploadFileList[ConstEnum.Code.UploadNseDocument];
                }
                List<DocumentDetailsModel> objSavedDocumentDetialsModelList = objDocumentDetailsSL.SaveDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, UploadFileDocumentDetailsModelList, ConstEnum.Code.UploadNseDocument, GroupId, objLoginUserDetails.LoggedInUserID,objLoginUserDetails.CompanyName);
                DocumentDetailsDTO objDocumentDetailsDTO = null;
                objDocumentDetailsDTO = new DocumentDetailsDTO();
                using (NSEGroupSL objNSEGroupSL = new NSEGroupSL())
                {
                    if (UploadFileDocumentDetailsModelList != null)
                    {
                        foreach (var fleGUID in UploadFileDocumentDetailsModelList)
                        {
                            objNSEGroupDetailsDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                            objNSEGroupDetailsDTO.GroupId = GroupId;
                            List<NSEGroupDetailsDTO> GrouplistDetails = objNSEGroupSL.Save_NSEGroup_Details(objLoginUserDetails.CompanyDBConnectionString, objNSEGroupDetailsDTO);
                            foreach (var nseuserId in GrouplistDetails)
                            {
                                objNSEGroupDocDTO.NSEGroupDetailsId = nseuserId.NSEGroupDetailsId;
                                objNSEGroupDetailsDTO.GroupId = Convert.ToInt32(GroupId);
                                bool bReturnDoc = objNSEGroupSL.Save_New_NSEDocument(objLoginUserDetails.CompanyDBConnectionString, objNSEGroupDocDTO, fleGUID.GUID);
                            }
                        }
                    }
                    objNSEGroupDTO.GroupId = GroupId;
                    objNSEGroupDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                    objNSEGroupDTO.StatusCodeId = 508007;
                    bool bReturn = objNSEGroupSL.Update_NSEGroup(objLoginUserDetails.CompanyDBConnectionString, objNSEGroupDTO);
                }
                TradingTransactionMasterDTO objTradingTransactionMasterDTO = null;
                using (TradingTransactionSL objTradingTransactionSL = new TradingTransactionSL())
                {
                    using (NSEGroupSL objNSEGroupSL = new NSEGroupSL())
                    {
                        List<NSEGroupDetailsDTO> grpTransIdList = objNSEGroupSL.Get_Group_TransactionId(objLoginUserDetails.CompanyDBConnectionString, GroupId);
                        foreach (var TransId in grpTransIdList)
                        {
                            objTradingTransactionMasterDTO = new TradingTransactionMasterDTO();
                            objTradingTransactionMasterDTO.TransactionMasterId = TransId.transId;
                            objTradingTransactionMasterDTO.TransactionStatusCodeId = ConstEnum.Code.DisclosureStatusForHardCopySubmittedByCO;
                            objTradingTransactionMasterDTO.HardCopyByCOSubmissionDate = Convert.ToDateTime(StockExchangeDateSubmission);
                            objTradingTransactionMasterDTO = objTradingTransactionSL.GetTradingTransactionMasterCreate(objLoginUserDetails.CompanyDBConnectionString, objTradingTransactionMasterDTO, objLoginUserDetails.LoggedInUserID, out nDisclosureCompletedFlag);
                        }
                    }
                }
                return RedirectToAction("Index", "NSEDownload", new { acid = ConstEnum.UserActions.NSEDownload });
            }
            else
            {
                ViewBag.groupId = GroupId;
                ViewBag.DownloadDate = date;
                ViewBag.UserAction = Common.ConstEnum.UserActions.NSEDownload;
                objNSEGroupDocumentModel.NSEGroupDocumentFile = Common.Common.GenerateDocumentList(ConstEnum.Code.UploadNseDocument, 0, 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.NSEUploadFile);              
                return View("NSEUploadDoc", objNSEGroupDocumentModel);
            }
        }
        #endregion Index List Page

        #endregion Insider All Action & Methods

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
                    lstPopulateComboDTO.Add(objPopulateComboDTO);
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