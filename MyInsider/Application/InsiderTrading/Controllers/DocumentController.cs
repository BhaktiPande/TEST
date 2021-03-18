using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class DocumentController : Controller
    {
        const string sLookUpPrefix = "com_msg_";
        #region EditDocumentDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        public PartialViewResult EditDocument(int acid, int nMapToTypeCodeId, int nMapToId, int nDocumentDetailsID = 0, int nPurposeCodeId = 0)
        {
            try
            {
                ModelState.Clear();
                List<DocumentDetailsModel> lstDocumentDetailsModel = new List<DocumentDetailsModel>();
                lstDocumentDetailsModel = Common.Common.GenerateDocumentList(nMapToTypeCodeId, nMapToId, 0, null, 0, true, nDocumentDetailsID);

                ViewBag.UserAction = acid;

                return PartialView("~/Views/Common/DocumentDetailsModal.cshtml", lstDocumentDetailsModel);

            }
            catch (Exception exp)
            {
                return null;
            }

        }
        #endregion EditDocumentDetails

        #region Upload Document
        /// <summary>
        /// This method is used to upload document - upload new file 
        /// </summary>
        /// <param name="dicDocumentDetailsModel"></param>
        /// <param name="acid"></param>
        /// <param name="buttonName"></param>
        /// <param name="index"></param>
        /// <param name="divclone"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public JsonResult UploadDocument(Dictionary<int, List<DocumentDetailsModel>> dicDocumentDetailsModel, int acid, int buttonName, int index, string divclone)
        {
            var ErrorDictionary = new Dictionary<string, string>();

            String UploadStatusMsg = "";
            int UploadStatusCode = -1; //used to set upload status message - this is default return msg code 

            LoginUserDetails objLoginUserDetails = null;
            DocumentDetailsDTO objDocumentDetailsDTO = null;

            List<DocumentDetailsModel> lstSaveDetailsModel = null;
            List<Object> lstobject = null;
            try
            {
                string directory = ConfigurationManager.AppSettings["Document"];
                string rootDirectory = directory;
                DirectoryInfo di;

                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objDocumentDetailsDTO = new DocumentDetailsDTO();

                lstSaveDetailsModel = new List<DocumentDetailsModel>();
                lstobject = new List<object>();
                bool bFlag = false;     //flag used to 
                bool bReturnStatus = true;
                int nMapToId = 0;
                string newFileName = string.Empty;

                //check dictionary which content document uploade details - if it is not empty
                if (dicDocumentDetailsModel.Count != 0 && dicDocumentDetailsModel.ContainsKey(buttonName))
                {
                    List<DocumentDetailsModel> lstDocumentDetailsModel = new List<DocumentDetailsModel>();
                    List<string> lstExtensions = new List<string>();
                    lstExtensions.Add("pdf");
                    lstExtensions.Add("xls");
                    lstExtensions.Add("xlsx");
                    lstExtensions.Add("doc");
                    lstExtensions.Add("docx");
                    lstExtensions.Add("png");
                    lstExtensions.Add("jpg");
                    lstExtensions.Add("jpeg");
                    //lstExtensions.Add("html");
                    //lstExtensions.Add("htm");
                    lstDocumentDetailsModel = dicDocumentDetailsModel[buttonName];
                    int mapToId = lstDocumentDetailsModel.Where(c => c.MapToId != 0).Select(c => c.MapToId).FirstOrDefault();
                    int mapToTypeCodeId = lstDocumentDetailsModel.Where(c => c.MapToTypeCodeId != 0).Select(c => c.MapToTypeCodeId).FirstOrDefault();

                    //process each document model 
                    foreach (DocumentDetailsModel objDocumentDetailsModel in lstDocumentDetailsModel)
                    {
                        //Check file contains more than one dots
                        if (objDocumentDetailsModel.Document != null)
                        {
                            objDocumentDetailsModel.MapToId = mapToId;
                            objDocumentDetailsModel.MapToTypeCodeId = mapToTypeCodeId;
                            //check if actual file is uploaded by checking model document property
                            string extension = System.IO.Path.GetExtension(objDocumentDetailsModel.Document.FileName).ToLower();

                            if (extension != ".pdf" && acid == InsiderTrading.Common.ConstEnum.UserActions.CO_DISCLOSURE_DETAILS_CONTINUOUS_DISCLOSURE_LETTER_SUBMISSION && objLoginUserDetails.CompanyName.ToUpper().Contains(InsiderTrading.Common.ConstEnum.CLIENT_DB_NAME_IGNORE_DATABASE))
                            {
                                UploadStatusCode = 5;
                            }
                            else if (extension != ".html" && extension != ".htm" && acid == InsiderTrading.Common.ConstEnum.UserActions.COMPANY_VIEW)
                            {
                                UploadStatusCode = 6;
                            }
                            else
                            {
                                if (lstExtensions.Contains(extension.Remove(0, 1)))
                                {
                                    extension = System.IO.Path.GetExtension(objDocumentDetailsModel.Document.FileName).ToLower();
                                    newFileName = Guid.NewGuid() + extension;

                                    //check if document is uploaded for first time or updating existing document
                                    if (objDocumentDetailsModel.MapToId != 0)
                                    {
                                        //updating existing document record
                                        bFlag = true;
                                        nMapToId = objDocumentDetailsModel.MapToId;
                                        lstSaveDetailsModel.Add(objDocumentDetailsModel);
                                    }

                                    Common.Common.CopyObjectPropertyByName(objDocumentDetailsModel, objDocumentDetailsDTO);
                                    objDocumentDetailsDTO.DocumentName = objDocumentDetailsModel.Document.FileName;
                                    objDocumentDetailsDTO.GUID = newFileName;
                                    objDocumentDetailsDTO.DocumentPath = Path.Combine(directory, newFileName);
                                    objDocumentDetailsDTO.FileSize = objDocumentDetailsModel.Document.ContentLength;
                                    objDocumentDetailsDTO.FileType = extension;

                                    //get temp folder path
                                    directory = Path.Combine(directory, "temp");

                                    //if temp directory not exists then create temp folder
                                    if (!Directory.Exists(directory))
                                        di = Directory.CreateDirectory(directory);

                                    //check guid is set or document id set then remove temp folder file
                                    if ((objDocumentDetailsModel.DocumentId != 0 && objDocumentDetailsModel.DocumentId != null) || objDocumentDetailsModel.GUID != null)
                                    {
                                        //get file object and delete file
                                        FileInfo file = new FileInfo(Path.Combine(rootDirectory, "temp", objDocumentDetailsModel.GUID));
                                        file.Delete();
                                        //remove guid stored in session
                                        objLoginUserDetails.DocumentDetails.Remove(objDocumentDetailsModel.GUID);
                                    }
                                    //save file into temp folder with new name as guid
                                    objDocumentDetailsModel.Document.SaveAs(Path.Combine(directory, newFileName));

                                    //add uploaded file info into session variable
                                    objLoginUserDetails.DocumentDetails.Add(newFileName, objDocumentDetailsDTO);

                                    //save file information into user session
                                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);

                                    string IsofficeInstalled = ConfigurationManager.AppSettings["IsOfficeInstalled"];
                                    ///This block is used to check whether office is installed on server
                                    if (IsofficeInstalled == "true")
                                    {
                                        if (extension == ".doc" || extension == ".docx")
                                        {
                                            Microsoft.Office.Interop.Word._Application _appWord = new Microsoft.Office.Interop.Word.Application();
                                            Microsoft.Office.Interop.Word.Document doc = null;
                                            string pathToWordFile = Path.Combine(directory, newFileName);
                                            bool _hasMacroWord = false;
                                            try
                                            {
                                                doc = _appWord.Documents.Open(pathToWordFile, Type.Missing, true);
                                                Microsoft.Office.Interop.Word.Application wordApplication = new Microsoft.Office.Interop.Word.Application();
                                                wordApplication.DisplayAlerts = Microsoft.Office.Interop.Word.WdAlertLevel.wdAlertsNone;
                                                wordApplication.ShowVisualBasicEditor = false;
                                                _hasMacroWord = doc.HasVBProject;
                                                if (_hasMacroWord)
                                                    UploadStatusCode = 4;
                                                else
                                                {
                                                    UploadStatusCode = 0;
                                                }
                                                doc.Close(Type.Missing, Type.Missing, Type.Missing);
                                                // _appWord.Application.Quit(); // optional
                                                _appWord.Quit();
                                                System.Runtime.InteropServices.Marshal.FinalReleaseComObject(_appWord);
                                                _appWord = null;
                                                if (UploadStatusCode == 4)
                                                {
                                                    //get file object and delete file
                                                    FileInfo file = new FileInfo(Path.Combine(rootDirectory, "temp", newFileName));
                                                    file.Delete();
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                // optional: this Log function should be defined somewhere in your code                                     }
                                            }
                                            finally
                                            {
                                                if (_appWord != null)
                                                {
                                                    _appWord.Quit();
                                                    System.Runtime.InteropServices.Marshal.FinalReleaseComObject(_appWord);
                                                }

                                                doc.Close();
                                            }
                                        }
                                        else if (extension == ".xls" || extension == ".xlsx")
                                        {
                                            Microsoft.Office.Interop.Excel._Application _appExcel = new Microsoft.Office.Interop.Excel.Application();
                                            Microsoft.Office.Interop.Excel.Workbook _workbook = null;
                                            string pathToExcelFile = Path.Combine(directory, newFileName);
                                            bool _hasMacro = false;
                                            try
                                            {
                                                _workbook = _appExcel.Workbooks.Open(pathToExcelFile, Type.Missing, true);
                                                _hasMacro = _workbook.HasVBProject;
                                                if (_hasMacro)
                                                    UploadStatusCode = 4;
                                                else
                                                {
                                                    //lstobject.Add(dic); //set uploaded file into list to return 
                                                    UploadStatusCode = 0;
                                                }

                                                if (UploadStatusCode == 4)
                                                {
                                                    FileInfo file = new FileInfo(Path.Combine(rootDirectory, "temp", newFileName));
                                                    file.Delete();
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                // optional: this Log function should be defined somewhere in your code
                                            }
                                            finally
                                            {
                                                _workbook.Close(false, Type.Missing, Type.Missing);
                                                _workbook = null;

                                                _appExcel.Application.Quit();
                                                _appExcel.Quit();
                                                System.Runtime.InteropServices.Marshal.FinalReleaseComObject(_appExcel);
                                                _appExcel = null;

                                                //if (_appExcel != null)
                                                //{
                                                //    _appExcel.Quit();
                                                //    System.Runtime.InteropServices.Marshal.FinalReleaseComObject(_appExcel);
                                                //}
                                            }
                                        }
                                        else
                                        {
                                            UploadStatusCode = 0; //set return msg code 
                                        }
                                    }
                                    else
                                    {
                                        UploadStatusCode = 0; //set return msg code 
                                    }
                                    //block end


                                    if (UploadStatusCode != 4)
                                    {
                                        //set uploaded file information into dictionary to sent back as output
                                        Dictionary<string, string> dic = new Dictionary<string, string>();
                                        dic.Add("GUID", objDocumentDetailsDTO.GUID);
                                        dic.Add("DocumentID", objDocumentDetailsDTO.DocumentId.ToString());
                                        dic.Add("Index", objDocumentDetailsModel.Index.ToString());
                                        dic.Add("SubIndex", objDocumentDetailsModel.SubIndex.ToString());
                                        dic.Add("DocumentName", objDocumentDetailsDTO.DocumentName);
                                        dic.Add("FileType", objDocumentDetailsDTO.FileType);
                                        dic.Add("UserAction", acid.ToString());
                                        lstobject.Add(dic); //set uploaded file into list to return
                                        UploadStatusCode = 0; //set return msg code 
                                    }

                                }
                                else
                                {
                                    UploadStatusCode = 3; //set return msg code 
                                }
                            }

                        }
                        else
                        {
                            //UploadStatusCode = 2; //set return msg code 
                        }
                    }

                    //upload and update existing records
                    if (bFlag == true && UploadStatusCode != 4)
                    {
                        using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                        {
                            List<DocumentDetailsModel> retlistDocumentDetailsModel = new List<DocumentDetailsModel>();

                            FileInfo file = new FileInfo(Path.Combine(rootDirectory, "temp", newFileName));
                            file.Delete();
                            file = null;

                            try
                            {
                                //as uploading file for already existing record which has MaptoId - upload/save record directly
                                retlistDocumentDetailsModel = objDocumentDetailsSL.SaveDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, lstSaveDetailsModel, buttonName, nMapToId, objLoginUserDetails.LoggedInUserID);

                                lstobject.Clear();

                                foreach (DocumentDetailsModel objDocModel in retlistDocumentDetailsModel)
                                {
                                    //set uploaded file information into dictionary to sent back as output
                                    Dictionary<string, string> dic = new Dictionary<string, string>();
                                    dic.Add("GUID", objDocModel.GUID);
                                    dic.Add("DocumentID", objDocModel.DocumentId.ToString());
                                    dic.Add("Index", objDocModel.Index.ToString());
                                    dic.Add("SubIndex", objDocModel.SubIndex.ToString());
                                    dic.Add("DocumentName", objDocModel.DocumentName);
                                    dic.Add("FileType", objDocModel.FileType);
                                    dic.Add("UserAction", acid.ToString());

                                    lstobject.Add(dic);//set uploaded file into list to return 

                                    UploadStatusCode = 0; //set return msg code 
                                }
                            }
                            catch (Exception ex)
                            {
                                UploadStatusCode = 1;

                                file = new FileInfo(Path.Combine(rootDirectory, "temp", newFileName));
                                file.Delete();
                                file = null;
                            }

                        }
                    }

                    lstExtensions = null;
                }
                else
                {
                    UploadStatusCode = 1; //set return msg code 
                }

                switch (UploadStatusCode)
                {
                    case 0:
                        UploadStatusMsg = "Document uploaded successfully";
                        break;
                    case 1:
                        UploadStatusMsg = "Error occured while uploading file. Please try again";
                        bReturnStatus = false;
                        break;
                    case 2:
                        UploadStatusMsg = "File is not attached properly and thus not able to upload file. Please try again";
                        bReturnStatus = false;
                        break;
                    case 3:
                        UploadStatusMsg = "Only following file types can be uploaded: pdf,xls,xlsx,doc,docx,png,jpg,jpeg";
                        bReturnStatus = false;
                        break;
                    case 4:
                        UploadStatusMsg = "Uploaded file contains macros, please remove it and then upload";
                        bReturnStatus = false;
                        break;
                    case 5:
                        UploadStatusMsg = "Only pdf file can be uploaded";
                        bReturnStatus = false;
                        break;
                    case 6:
                        UploadStatusMsg = "Only html file can be uploaded";
                        bReturnStatus = false;
                        break;
                    default:
                        UploadStatusMsg = "Error occured while uploading file. Please try again";
                        bReturnStatus = false;
                        break;
                }

                ErrorDictionary.Add("Document", UploadStatusMsg);

                return Json(new
                {
                    status = bReturnStatus,
                    Message = ErrorDictionary,
                    obj = lstobject,
                    divclone = divclone
                }, "text/html");

            }
            catch (Exception exp)
            {
                return null;
            }
            finally
            {
                objLoginUserDetails = null;
                objDocumentDetailsDTO = null;
                lstSaveDetailsModel = null;
            }
        }
        #endregion UploadDocument

        #region SaveDocumentDetails
        [AuthorizationPrivilegeFilter]
        public JsonResult SaveDocumentDetails(int nMapToTypeCodeId, int nMapToId, string sDocName, string sDocDescription, int acid, string GUID, int nDocumentDetailsID = 0)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();

            LoginUserDetails objLoginUserDetails = null;
            DocumentDetailsDTO objDocumentDetailsDTO = null;
            List<DocumentDetailsModel> lstDocumentDetailsModel = null;
            DocumentDetailsModel objDocumentDetailsModel = null;
            try
            {
                if (GUID == null || GUID == "")
                {
                    string sErrMessage = "Please Upload Document";
                    ErrorDictionary.Add("Document", sErrMessage);
                }
                else
                {
                    objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                    objDocumentDetailsDTO = new DocumentDetailsDTO();
                    
                    lstDocumentDetailsModel = new List<DocumentDetailsModel>();
                    
                    objDocumentDetailsModel = new DocumentDetailsModel();

                    objDocumentDetailsModel.MapToTypeCodeId = nMapToTypeCodeId;
                    objDocumentDetailsModel.MapToId = nMapToId;
                    objDocumentDetailsModel.DocumentId = nDocumentDetailsID;
                    objDocumentDetailsModel.GUID = GUID;
                    objDocumentDetailsModel.DocumentName = sDocName;
                    objDocumentDetailsModel.Description = sDocDescription;
                    lstDocumentDetailsModel.Add(objDocumentDetailsModel);

                    using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                    {
                        lstDocumentDetailsModel = objDocumentDetailsSL.SaveDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, lstDocumentDetailsModel, nMapToTypeCodeId, nMapToId, objLoginUserDetails.LoggedInUserID);

                        if (lstDocumentDetailsModel.Count > 0)
                        {
                            statusFlag = true;
                        }
                    }
                }            
                return Json(new
                {
                    status = statusFlag,
                    Message = ErrorDictionary
                }, "text/html");
            }                
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                objLoginUserDetails = null;
                objDocumentDetailsDTO = null;
                lstDocumentDetailsModel = null;
                objDocumentDetailsModel = null;
            }
        }
        #endregion SaveDocumentDetails

        #region DeleteDocumentDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public JsonResult DeleteDocumentDetails(int acid, int nDocumentDetailsID, string sGUID, int nMapToTypeCodeId=0, int nMapToId=0, int nPurposeCodeId = 0)
        {
            bool bReturn = false;
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();

            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                
                using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                {
                    bReturn = objDocumentDetailsSL.DeleteDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, nDocumentDetailsID, objLoginUserDetails.LoggedInUserID, nMapToTypeCodeId, nMapToId, nPurposeCodeId);
                    if (bReturn)
                    {
                        string directory = ConfigurationManager.AppSettings["Document"];
                        FileInfo file = new FileInfo(Path.Combine(directory, nMapToTypeCodeId.ToString(), nMapToId.ToString(), sGUID));
                        file.Delete();
                        statusFlag = true;
                        ErrorDictionary.Add("success", "Record deleted");
                    }  
                }  
            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
            }
            finally
            {
                objLoginUserDetails = null;
            }

            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, "text/html");
        }
        #endregion DeleteDocumentDetails

        #region DeleteSingleDocumentDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name=""></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public JsonResult DeleteSingleDocumentDetails(int? nDocumentDetailsID, int nIndex, int nSubIndex, string GUID, int acid, int nMapToTypeCodeId=0, int nMapToId=0, int nPurposeCodeId = 0)
        {
            bool bReturn = false;
            bool statusFlag = false;
            bool userType = false;
            var ErrorDictionary = new Dictionary<string, string>();
            bool removeMapToId = true;
            LoginUserDetails objLoginUserDetails = null;
            Dictionary<string, DocumentDetailsDTO> dicDocumentDetailsDTO = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
              //  DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();
                string directory = ConfigurationManager.AppSettings["Document"];
                if (nDocumentDetailsID != null && nDocumentDetailsID != 0)
                {
                    
                    if (nMapToTypeCodeId == ConstEnum.Code.UserDocument)
                    {
                        userType = true;
                    }
                    if (acid == InsiderTrading.Common.ConstEnum.UserActions.COMPANY_VIEW)
                    {
                        removeMapToId = false;
                    }
                    using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                    {
                        bReturn = objDocumentDetailsSL.DeleteDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(nDocumentDetailsID), objLoginUserDetails.LoggedInUserID, nMapToTypeCodeId, nMapToId, Convert.ToInt32(nPurposeCodeId));
                        if (bReturn)
                        {
                            if (nMapToTypeCodeId != Common.ConstEnum.Code.TradingPolicy)
                            {
                                if (System.IO.File.Exists(Path.Combine(directory, nMapToTypeCodeId.ToString(), nMapToId.ToString(), GUID)))
                                {
                                    FileInfo file = new FileInfo(Path.Combine(directory, nMapToTypeCodeId.ToString(), nMapToId.ToString(), GUID));
                                    file.Delete();
                                }
                            }
                            statusFlag = true;
                            ErrorDictionary.Add("Document", "Record deleted");
                        }
                    }
                }
                else {
                    dicDocumentDetailsDTO = objLoginUserDetails.DocumentDetails;
                    if (dicDocumentDetailsDTO != null && dicDocumentDetailsDTO.Count > 0 && dicDocumentDetailsDTO.ContainsKey(GUID))
                    {
                     
                        if (System.IO.File.Exists(Path.Combine(directory, "temp", GUID)))
                        {
                            FileInfo file = new FileInfo(Path.Combine(directory, "temp", GUID));
                            file.Delete();
                        }
                        objLoginUserDetails.DocumentDetails.Remove(GUID);
                        Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                        statusFlag = true;
                        ErrorDictionary.Add("Document", "Record deleted");
                    }
                }
            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Document", sErrMessage);
            }
            finally
            {
                objLoginUserDetails = null;
                dicDocumentDetailsDTO = null;
            }

            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary,
                Index = nIndex,
                SubIndex = nSubIndex,
                userType = userType,
                removeMapToId = removeMapToId
            }, "text/html");
        }
        #endregion DeleteSingleDocumentDetails

        #region Download
        [AuthorizationPrivilegeFilter]
        public FileStreamResult Download(int nDocumentDetailsID, string GUID, string sDocumentName, string sFileType, int acid)
        {
            string directory = ConfigurationManager.AppSettings["Document"];
            string sExtension = "";

            LoginUserDetails objLoginUserDetails = null;
            DocumentDetailsDTO objDocumentDetailsDTO = null;
            try
            {
                if (nDocumentDetailsID == 0)
                {
                    directory = Path.Combine(directory, "temp", GUID);
                    if (System.IO.File.Exists(directory))
                    {
                        return File(new FileStream(directory, FileMode.Open), sFileType, sDocumentName);
                    }
                }
                else
                {
                    objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                    using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                    {
                        objDocumentDetailsDTO = objDocumentDetailsSL.GetDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, nDocumentDetailsID);

                        /*For user document, extensions are not stored in the file name, so that are to be explicitly concatenated */
                        if (objDocumentDetailsDTO.MapToTypeCodeId == ConstEnum.Code.UserDocument)
                        {
                            sExtension = objDocumentDetailsDTO.FileType;
                        }
                        directory = Path.Combine(directory, Common.Common.ConvertToString(objDocumentDetailsDTO.MapToTypeCodeId), Common.Common.ConvertToString(objDocumentDetailsDTO.MapToId), objDocumentDetailsDTO.GUID);
                        if (System.IO.File.Exists(directory))
                        {
                            return File(new FileStream(directory, FileMode.Open), objDocumentDetailsDTO.FileType, objDocumentDetailsDTO.DocumentName + sExtension/*+ objDocumentDetailsDTO.FileType*/);
                        }
                    }
                }
            }
            finally
            {
                objLoginUserDetails = null;
                objDocumentDetailsDTO = null;
            }
            
            return null;         
        }
        #endregion PopulateCombo

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
}