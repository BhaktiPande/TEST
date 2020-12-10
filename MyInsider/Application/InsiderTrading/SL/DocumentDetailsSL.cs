using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTradingDAL;
using InsiderTrading.Common;
using System.IO;
using System.Configuration;
using InsiderTrading.Models;

namespace InsiderTrading.SL
{
    public class DocumentDetailsSL:IDisposable
    {
        #region SaveDocumentDetails
        /// <summary>
        /// This method is used for the insert/Update SaveDocumentDetails details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objDocumentDetailsDTO">DocumentDetails Object</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Returns boolean value based on the result</returns>
        public List<DocumentDetailsModel> SaveDocumentDetails(string i_sConnectionString, List<DocumentDetailsModel> i_lstDocumentDetailsModel, int i_nMapToCodeTypeId, int i_nMaptoID, int i_nLoggedInUserId,string companyName=null)
        {
            List<DocumentDetailsModel> retListDocumentDetailsModel = new List<DocumentDetailsModel>();
            DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();
            string directory = ConfigurationManager.AppSettings["Document"];
            string rootDirectory = directory;
            DirectoryInfo di;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {                
                //DocumentDetailsDAL objDocumentDetailsDAL = new DocumentDetailsDAL();

                //check file is uploaded by checking document model
                if (i_lstDocumentDetailsModel != null && i_lstDocumentDetailsModel.Count > 0)
                {
                    foreach (DocumentDetailsModel objDocumentDetailsModel in i_lstDocumentDetailsModel)
                    {
                        //check file is uploaded for same code type as in model
                        if (objDocumentDetailsModel.MapToTypeCodeId == i_nMapToCodeTypeId)
                        {
                            //check GUID - guid null means file does not exists on system - either in temp folder or actual folder
                            if (objDocumentDetailsModel.GUID == null)
                            {
                                //check if actual file is uploaded by checking model document property
                                if (objDocumentDetailsModel.Document != null)
                                {
                                    //get file property for uploaded file and set model property

                                    string extension = System.IO.Path.GetExtension(objDocumentDetailsModel.Document.FileName);
                                    string newFileName = Guid.NewGuid() + extension;

                                    objDocumentDetailsModel.DocumentName = objDocumentDetailsModel.Document.FileName;
                                    objDocumentDetailsModel.GUID = newFileName;

                                    objDocumentDetailsModel.DocumentPath = Path.Combine(directory, objDocumentDetailsModel.MapToTypeCodeId.ToString(), objDocumentDetailsModel.MapToId.ToString(), newFileName);
                                    objDocumentDetailsModel.FileSize = objDocumentDetailsModel.Document.ContentLength;
                                    objDocumentDetailsModel.FileType = extension;

                                    //check directory folder and if not exists then create folder to upload file
                                    if (!Directory.Exists(Path.Combine(directory, objDocumentDetailsModel.MapToTypeCodeId.ToString(), objDocumentDetailsModel.MapToId.ToString())))
                                        di = Directory.CreateDirectory(Path.Combine(directory, objDocumentDetailsModel.MapToTypeCodeId.ToString(), objDocumentDetailsModel.MapToId.ToString()));

                                    //save existing document with new document uploaded
                                    objDocumentDetailsModel.Document.SaveAs(objDocumentDetailsModel.DocumentPath);

                                    Common.Common.CopyObjectPropertyByName(objDocumentDetailsModel, objDocumentDetailsDTO);

                                    //save record into DB for file upload
                                    using (var objDocumentDetailsDAL = new DocumentDetailsDAL())
                                    {
                                        objDocumentDetailsDTO = objDocumentDetailsDAL.SaveDocumentDetails(i_sConnectionString, objDocumentDetailsDTO, objLoginUserDetails.LoggedInUserID);
                                    }

                                    Common.Common.CopyObjectPropertyByName(objDocumentDetailsDTO, objDocumentDetailsModel);

                                    //add save/updated record into list 
                                    retListDocumentDetailsModel.Add(objDocumentDetailsModel);
                                }
                            }
                            else
                            {
                                // file is exists on system as GUID is exists

                                //check document id for existing records or new records
                                if (objDocumentDetailsModel.DocumentId != 0)
                                {
                                    //check if actual file is uploaded by checking model document property
                                    if (objDocumentDetailsModel.Document != null)
                                    {
                                        //get file property for uploaded file and set model property

                                        string extension = Path.GetExtension(objDocumentDetailsModel.Document.FileName);

                                        //set document path property because it is remove from UI
                                        objDocumentDetailsModel.DocumentPath = Path.Combine(directory, objDocumentDetailsModel.MapToTypeCodeId.ToString(), objDocumentDetailsModel.MapToId.ToString(), objDocumentDetailsModel.GUID);

                                        //rename existing file - break file and extention, add "_old" to file,  

                                        String file_name_without_ext = Path.GetFileNameWithoutExtension(objDocumentDetailsModel.DocumentPath);
                                        String old_file_extention = Path.GetExtension(objDocumentDetailsModel.DocumentPath);

                                        string src_file_folder = Path.GetDirectoryName(objDocumentDetailsModel.DocumentPath);
                                        String des_old_file_path = Path.Combine(src_file_folder, file_name_without_ext + "_old" + old_file_extention);

                                        File.Move(objDocumentDetailsModel.DocumentPath, des_old_file_path);

                                        //replace new file extenstion for existing guid 
                                        objDocumentDetailsModel.GUID = file_name_without_ext + extension;

                                        objDocumentDetailsModel.DocumentName = (objDocumentDetailsModel.MapToTypeCodeId == ConstEnum.Code.UserDocument) ? objDocumentDetailsModel.DocumentName: objDocumentDetailsModel.Document.FileName;
                                        objDocumentDetailsModel.DocumentPath = Path.Combine(directory, objDocumentDetailsModel.MapToTypeCodeId.ToString(), objDocumentDetailsModel.MapToId.ToString(), objDocumentDetailsModel.GUID);
                                        objDocumentDetailsModel.FileSize = objDocumentDetailsModel.Document.ContentLength;
                                        objDocumentDetailsModel.FileType = extension;

                                        //save existing document with new document uploaded
                                        objDocumentDetailsModel.Document.SaveAs(objDocumentDetailsModel.DocumentPath);//copy new file with same guid and new extension 
                                        
                                        //delete old file
                                        FileInfo del_file = new FileInfo(des_old_file_path);
                                        del_file.Delete();

                                        Common.Common.CopyObjectPropertyByName(objDocumentDetailsModel, objDocumentDetailsDTO);
                                    }
                                    else
                                    {
                                        using (var objDocumentDetailsDAL = new DocumentDetailsDAL())
                                        {
                                            objDocumentDetailsDTO = objDocumentDetailsDAL.GetDocumentDetails(i_sConnectionString, Convert.ToInt32(objDocumentDetailsModel.DocumentId));
                                        }
                                        objDocumentDetailsDTO.DocumentName = objDocumentDetailsModel.DocumentName;
                                        objDocumentDetailsDTO.Description = objDocumentDetailsModel.Description;
                                    }

                                    //update record into DB for file upload
                                    using (var objDocumentDetailsDAL = new DocumentDetailsDAL())
                                    {
                                        objDocumentDetailsDTO = objDocumentDetailsDAL.SaveDocumentDetails(i_sConnectionString, objDocumentDetailsDTO, objLoginUserDetails.LoggedInUserID);
                                    }

                                    Common.Common.CopyObjectPropertyByName(objDocumentDetailsDTO, objDocumentDetailsModel);

                                    //add save/updated record into list 
                                    retListDocumentDetailsModel.Add(objDocumentDetailsModel);
                                }
                                else if (objLoginUserDetails.DocumentDetails.Count > 0)//check user session for document uploaded when MaptoID not exists
                                {
                                    //i_nMaptoID is not exists so save document in temp folder

                                    Dictionary<string, DocumentDetailsDTO> objDetailsDTO = new Dictionary<string, DocumentDetailsDTO>();

                                    //get document details from session 
                                    foreach (KeyValuePair<string, DocumentDetailsDTO> entry in objLoginUserDetails.DocumentDetails)
                                    {
                                        objDetailsDTO.Add(entry.Key, (DocumentDetailsDTO)entry.Value);
                                    }

                                    //process details to save
                                    foreach (KeyValuePair<string, DocumentDetailsDTO> dicDocumentDetailsDTO in objDetailsDTO)
                                    {
                                        //check existing session document to update record - compare MapToTypeCodeId and GUID with already saved session records
                                        if (dicDocumentDetailsDTO.Value.MapToTypeCodeId == objDocumentDetailsModel.MapToTypeCodeId && dicDocumentDetailsDTO.Value.GUID == objDocumentDetailsModel.GUID)
                                        {
                                            dicDocumentDetailsDTO.Value.MapToId = i_nMaptoID;
                                            objDocumentDetailsDTO = dicDocumentDetailsDTO.Value;

                                            string sSourceFile = Path.Combine(directory, "temp", objDocumentDetailsDTO.GUID);

                                            string sTargetFile = string.Empty;
                                            if (companyName != null)
                                                sTargetFile = Path.Combine(directory, companyName, objDocumentDetailsDTO.MapToTypeCodeId.ToString(), objDocumentDetailsDTO.MapToId.ToString(), objDocumentDetailsDTO.GUID);
                                            else
                                                sTargetFile = Path.Combine(directory, objDocumentDetailsDTO.MapToTypeCodeId.ToString(), objDocumentDetailsDTO.MapToId.ToString(), objDocumentDetailsDTO.GUID);
                                            
                                            objDocumentDetailsDTO.DocumentPath = sTargetFile;

                                            //check temp folder exists
                                            if (Directory.Exists(Path.Combine(directory, "temp")))
                                            {
                                                if (companyName != null)
                                                {
                                                    if (!Directory.Exists(Path.Combine(directory, companyName, objDocumentDetailsDTO.MapToTypeCodeId.ToString(), objDocumentDetailsDTO.MapToId.ToString())))
                                                        di = Directory.CreateDirectory(Path.Combine(directory, companyName, objDocumentDetailsDTO.MapToTypeCodeId.ToString(), objDocumentDetailsDTO.MapToId.ToString()));
                                                }
                                                else
                                                { 
                                                //check directory folder and if not exists then create folder to upload file
                                                if (!Directory.Exists(Path.Combine(directory, objDocumentDetailsDTO.MapToTypeCodeId.ToString(), objDocumentDetailsDTO.MapToId.ToString())))
                                                    di = Directory.CreateDirectory(Path.Combine(directory, objDocumentDetailsDTO.MapToTypeCodeId.ToString(), objDocumentDetailsDTO.MapToId.ToString()));
                                                }
                                                //copy file from temp folder to target folder
                                                System.IO.File.Copy(sSourceFile, sTargetFile, true);

                                                //update record into DB for file upload
                                                using (var objDocumentDetailsDAL = new DocumentDetailsDAL())
                                                {
                                                    objDocumentDetailsDTO = objDocumentDetailsDAL.SaveDocumentDetails(i_sConnectionString, objDocumentDetailsDTO, objLoginUserDetails.LoggedInUserID);
                                                }

                                                //check if document details save in DB or not - if not save in DB then delete uploaded file
                                                if (objDocumentDetailsDTO == null)
                                                {
                                                    //delete uploaded file and throw exception

                                                    File.Delete(sTargetFile);
                                                    Exception ex = new Exception("Document Details not saved");
                                                    throw ex;
                                                }
                                                else
                                                {
                                                    DocumentDetailsModel objTempDocumentDetailsModel = new DocumentDetailsModel();    
           
                                                    Common.Common.CopyObjectPropertyByName(objDocumentDetailsDTO, objTempDocumentDetailsModel);

                                                    //add save/updated record into list 
                                                    retListDocumentDetailsModel.Add(objTempDocumentDetailsModel);
                                                    
                                                    //delete temp folder file
                                                    File.Delete(sSourceFile);
                                                    
                                                    //delete/remove from session 
                                                    objLoginUserDetails.DocumentDetails.Remove(dicDocumentDetailsDTO.Value.GUID);
                                                    
                                                    //reset session after remove/delete from session 
                                                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                                                    
                                                    //when all document are removed from session break loop
                                                    if (objLoginUserDetails.DocumentDetails.Count == 0)
                                                        break;
                                                }
                                            }
                                            else
                                            {
                                                Exception ex = new Exception("Source File does not exist");
                                                throw ex;
                                            }
                                        }
                                    }

                                    //save into user session
                                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return retListDocumentDetailsModel;
        }
        #endregion SaveDMATDetails

        #region DeleteDocumentDetails
        /// <summary>
        /// This method is used for the insert/Update SaveDocumentDetails details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_nDocumentDetailsID">DocumentDetailsID to delete</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Returns boolean value based on the result</returns>
        public bool DeleteDocumentDetails(string i_sConnectionString, int i_nDocumentDetailsID, int nLoggedInUserId, int i_nMapToTypeCodeId, int i_nMapToId, int i_nPurposeCodeId = 0)
        {
            bool bReturn = false;
            try
            {
                //DocumentDetailsDAL objDocumentDetailsDAL = new DocumentDetailsDAL();
                using (var objDocumentDetailsDAL = new DocumentDetailsDAL())
                {
                    bReturn = objDocumentDetailsDAL.DeleteDocumentDetails(i_sConnectionString, i_nDocumentDetailsID, nLoggedInUserId, i_nMapToTypeCodeId, i_nMapToId, i_nPurposeCodeId);
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }

            return bReturn;
        }
        #endregion DeleteDocumentDetails

        #region GetDetails
        /// <summary>
        /// This method is used to get Document details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_nDocumentDetailsID">DocumentDetailsID to delete</param>
        /// <returns>Returns boolean value based on the result</returns>
        public DocumentDetailsDTO GetDocumentDetails(string i_sConnectionString, int i_nDocumentDetailsID)
        {
            DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();
            try
            {
                //DocumentDetailsDAL objDocumentDetailsDAL = new DocumentDetailsDAL();
                using (var objDocumentDetailsDAL = new DocumentDetailsDAL())
                {
                    objDocumentDetailsDTO = objDocumentDetailsDAL.GetDocumentDetails(i_sConnectionString, i_nDocumentDetailsID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objDocumentDetailsDTO;
        }
        #endregion GetDetails

        #region GetList
        /// <summary>
        /// This method is used to get Document List.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_nDocumentDetailsID"></param>
        /// <returns>Returns boolean value based on the result</returns>
        public List<DocumentDetailsDTO> GetDocumentList(string i_sConnectionString, int i_nMapToTypeCodeId, int i_nMapToId, int i_nPurposeCodeId)
        {
            List<DocumentDetailsDTO> lstDocumentDetailsDTO = new List<DocumentDetailsDTO>();
            try
            {
                //DocumentDetailsDAL objDocumentDetailsDAL = new DocumentDetailsDAL();
                using (var objDocumentDetailsDAL = new DocumentDetailsDAL())
                {
                    lstDocumentDetailsDTO = objDocumentDetailsDAL.GetDocumentListNonGrid(i_sConnectionString, i_nMapToTypeCodeId, i_nMapToId, i_nPurposeCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return lstDocumentDetailsDTO;
        }
        #endregion GetDetails

        #region IDisposable Members
        /// <summary>
        /// Dispose Method for dispose object
        /// </summary>
        private void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        /// <summary>
        /// Interface for dispose class
        /// </summary>
        void IDisposable.Dispose()
        {
            Dispose(true);
        }


        /// <summary>
        /// virtual dispoase method
        /// </summary>
        /// <param name="disposing"></param>
        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }

        #endregion

        #region GetDocumentCount
        /// <summary>
        /// This method is used to get Document Count.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_nDocumentDetailsID">DocumentDetailsID to delete</param>
        /// <returns>Returns boolean value based on the result</returns>
        public int GetDocumentCount(string i_sConnectionString, int nMapToTypeCodeId, int nMapToId)
        {
            int returnValue = 0;
            try
            {
                using (var objDocumentDetailsDAL = new DocumentDetailsDAL())
                {
                    returnValue = objDocumentDetailsDAL.GetDocumentCount(i_sConnectionString, nMapToTypeCodeId, nMapToId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return returnValue;
        }
        #endregion GetDocumentCount

        #region GetFormFDocumentId
        /// <summary>
        /// This method is used to get Form F Document Id.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_nDocumentDetailsID">DocumentDetailsID to delete</param>
        /// <returns>Returns int value based on the result</returns>
        public int GetFormFDocumentId(string i_sConnectionString, int nMapToTypeCodeId, int nPurposeCodeId)
        {
            int returnValue = 0;
            try
            {
                using (var objDocumentDetailsDAL = new DocumentDetailsDAL())
                {
                    returnValue = objDocumentDetailsDAL.GetFormFDocumentId(i_sConnectionString, nMapToTypeCodeId, nPurposeCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return returnValue;
        }
        #endregion GetFormFDocumentId

        #region SaveFormGDocumentDetails
        /// <summary>
        /// This method is used for the insert/Update SaveDocumentDetails details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objDocumentDetailsDTO">DocumentDetails Object</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Returns boolean value based on the result</returns>
        public List<DocumentDetailsModel> SaveFormGDocumentDetails(string i_sConnectionString, List<DocumentDetailsModel> i_lstDocumentDetailsModel, int i_nMapToCodeTypeId, int i_nMaptoID, int i_nLoggedInUserId)
        {
            List<DocumentDetailsModel> retListDocumentDetailsModel = new List<DocumentDetailsModel>();
            DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();
            string directory = ConfigurationManager.AppSettings["Document"];
            string rootDirectory = directory;
            DirectoryInfo di;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                //check file is uploaded by checking document model
                if (i_lstDocumentDetailsModel != null && i_lstDocumentDetailsModel.Count > 0)
                {
                    foreach (DocumentDetailsModel objDocumentDetailsModel in i_lstDocumentDetailsModel)
                    {                  
                        Common.Common.CopyObjectPropertyByName(objDocumentDetailsModel, objDocumentDetailsDTO);

                        //save record into DB for file upload
                        using (var objDocumentDetailsDAL = new DocumentDetailsDAL())
                        {
                            objDocumentDetailsDTO = objDocumentDetailsDAL.SaveDocumentDetails(i_sConnectionString, objDocumentDetailsDTO, objLoginUserDetails.LoggedInUserID);
                        }

                        //add save/updated record into list 
                        retListDocumentDetailsModel.Add(objDocumentDetailsModel);                
                        
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return retListDocumentDetailsModel;
        }
        #endregion SaveFormGDocumentDetails
    }
}