using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class PolicyDocumentsController : Controller
    {
        private string sLookupPrefix = "rul_msg_";

        #region Index
        //
        // GET: /PolicyDocuments/
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            //flag used to check which menu option page - rule or transaction - is shown
            bool is_rules_menu = true;
            bool isAllEdit = true;
            bool isAllSubCategoryList = true;

            LoginUserDetails objLoginUserDetails = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                ViewBag.DocumentCategoryDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.PolicyDocumentCategory, null, null, null, null, true, sLookupPrefix);

                ViewBag.DocumentSubCategoryDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.PolicyDocumentSubCategory, null, null, null, null, true, sLookupPrefix);

                ViewBag.GridType = ConstEnum.GridType.PoliycDocumentsList;

                //check if request come from rule menu option or transaction menu option by comparing list view activity id
                if (acid == ConstEnum.UserActions.RULES_POLICY_DOCUMENT_LIST)
                {
                    is_rules_menu = true;
                }
                else if (acid == ConstEnum.UserActions.TRANSACTION_POLICY_DOCUMENT_LIST)
                {
                    is_rules_menu = false;

                    //set following parameter to include/exclude status when grid list is display
                    ViewBag.StatusList = "" + ConstEnum.Code.PolicyDocumentWindowStatusIncomplete; //status for grid list 
                    ViewBag.IncludeStatus = 2; //1 means includes grid list status and 2 means exclude/don't show grid list status while showing grid list on page
                }

                ViewBag.rules_menu_page = is_rules_menu;
                ViewBag.isAllEdit = isAllEdit;
                ViewBag.isAllSubCategoryList = isAllSubCategoryList;

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

            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
            }

            return View("Index");
        }
        #endregion Index

        #region Create
        /// <summary>
        /// This method is used to return view to create new policy document
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int acid)
        {
            PolicyDocumentModel objPolicyDocumentModel = null;

            //following flag used for create page option and set if control are allowed to edit or not
            bool isSaveAllowed = true;
            bool isAllEdit = true;
            bool isPartialEdit = false;
            bool isNoEdit = false;

            bool showSaveButton = true;
            bool showApplicabilityButton = false;
            
            bool allowChangeStatus = false;
            bool isApplicabilitySet = false;
            string applicablityNotDefineMsg = "";

            LoginUserDetails objLoginUserDetails = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objPolicyDocumentModel = new PolicyDocumentModel();
                objPolicyDocumentModel.DocumentViewFlag = true;
                objPolicyDocumentModel.DocumentViewAgreeFlag = true;
                objPolicyDocumentModel.DisplayInPolicyDocument = YesNo.Yes;
                objPolicyDocumentModel.SendEmailUpdate = YesNo.Yes;
                objPolicyDocumentModel.WindowStatus = WindowStatusCode.Incomplete;

                DateTime currentDBDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                objPolicyDocumentModel.ApplicableFrom = currentDBDate;

                objPolicyDocumentModel.PolicyDocumentFile = Common.Common.GenerateDocumentList(ConstEnum.Code.PolicyDocument, 0, 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.PolicyDocumentFile);
                
                objPolicyDocumentModel.EmailAttachment = Common.Common.GenerateDocumentList(ConstEnum.Code.PolicyDocument, 0, 0, objPolicyDocumentModel.PolicyDocumentFile, ConstEnum.Code.EmailAttachment, false, 0, ConstEnum.FileUploadControlCount.PolicyDocumentEmailAttachment);
                
                ViewBag.DocumentCategoryDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.PolicyDocumentCategory, null, null, null, null, true, sLookupPrefix);
                ViewBag.CompanyDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CompanyList, null, null, null, null, null, true, sLookupPrefix);

                ViewBag.isSaveAllowed = isSaveAllowed;
                ViewBag.isAllEdit = isAllEdit;
                ViewBag.isPartialEdit = isPartialEdit;
                ViewBag.isNoEdit = isNoEdit;

                ViewBag.UserAction = acid;

                ViewBag.allowChangeStatus = allowChangeStatus;

                ViewBag.isApplicabilitySet = isApplicabilitySet;
                ViewBag.applicablityNotDefineMsg = applicablityNotDefineMsg;

                ViewBag.showSaveButton = showSaveButton;
                ViewBag.showApplicabilityButton = showApplicabilityButton;

                objPolicyDocumentModel.isSaveAllowed = isSaveAllowed;
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
            }

            return View("Create", objPolicyDocumentModel);
        }
        #endregion Create

        #region Cancel - Back
        /// <summary>
        /// This method will redirect to index page 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Cancel")]
        [ActionName("Create")]
        public ActionResult Cancel()
        {
            int activity_id = 0; 
            int policy_document_id = 0;

            if (Request.Params["authorization"] != null && Request.Params["authorization"] != "")
            {
                activity_id = Convert.ToInt32(Request.Params["authorization"].Split(':')[1]);
            }

            if (Request.Params["PolicyDocumentId"] != null && Request.Params["PolicyDocumentId"] != "")
            {
                policy_document_id = Convert.ToInt32(Request.Params["PolicyDocumentId"]);
            }

            string view_name = "";

            var dynamicRoutValues = new RouteValueDictionary();

            switch(activity_id){
                case ConstEnum.UserActions.POLICY_DOCUMENT_VIEW:
                    view_name = "Index";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.RULES_POLICY_DOCUMENT_LIST;
                    break;
                case ConstEnum.UserActions.POLICY_DOCUMENT_CREATE:
                    view_name = "Index";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.RULES_POLICY_DOCUMENT_LIST;
                    break;
                case ConstEnum.UserActions.POLICY_DOCUMENT_EDIT:
                    view_name = "Index";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.RULES_POLICY_DOCUMENT_LIST;
                    break;
                case ConstEnum.UserActions.TRANSACTION_POLICY_DOCUMENT_VIEW:
                    view_name = "View";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.TRANSACTION_POLICY_DOCUMENT_VIEW;
                    dynamicRoutValues["pdid"] = policy_document_id;
                    break;
                default:
                    view_name = "Index";
                    dynamicRoutValues["acid"] = ConstEnum.UserActions.RULES_POLICY_DOCUMENT_LIST;
                    break;
            }

            return RedirectToAction(view_name, "PolicyDocuments", dynamicRoutValues);
        }
        #endregion Cancel - Back

        #region Save (save/update records and show next screen)
        /// <summary>
        /// This method is used to save/update policy document record and redirect to applicability view 
        /// </summary>
        /// <param name="objPolicyDocumentModel"></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Save")]
        [ActionName("Create")]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult Save(InsiderTrading.Models.PolicyDocumentModel objPolicyDocumentModel, Dictionary<int, List<DocumentDetailsModel>> dicPolicyDocumentsUploadFileList, int acid)
        {
            //int acid = 0;
            LoginUserDetails objLoginUserDetails = null;
            PolicyDocumentDTO objPolicyDocumentDTO = null;
            PolicyDocumentDTO objPolicyDocumentDTO_BeforeSave = null;
            PolicyDocumentDTO o_objPolicyDocumentDTO = null;
            ApplicabilityDTO objApplicablityDTO = null;

            List<DocumentDetailsModel> UploadFileDocumentDetailsModelList = null;

            List<DocumentDetailsModel> PoliycDocumentList = null;
            List<DocumentDetailsModel> EmailAttachmentList = null;

            DocumentDetailsSL objDocumentDetailsSL = null;

            int pdocid = 0;
            int activity_id = 0;
            int policy_document_id = 0;

            bool bNoErrorMessage = true; //flag use to check if data is valid to save and redirect
            string sErrMessage = "";

            //following flag used for create page option and set if control are allowed to edit or not
            bool isSaveAllowed = true;
            bool isAllEdit = true;
            bool isPartialEdit = false;
            bool isNoEdit = false;

            bool showSaveButton = true;
            bool showApplicabilityButton = false;
            string applicablityCalledFrom = " ";

            bool allowChangeStatus = false;
            bool isApplicabilitySet = false;
            string applicablityNotDefineMsg = Common.Common.getResource("rul_msg_15252");

            string sucess_msg = "";

            try
            {
                try
                {
                    objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                    

                    if (Request.Params["authorization"] != null && Request.Params["authorization"] != "")
                    {
                        activity_id = Convert.ToInt32(Request.Params["authorization"].Split(':')[1]);
                    }

                    //if (objPolicyDocumentModel.isSaveAllowed)
                    //{
                    PoliycDocumentList = new List<DocumentDetailsModel>();
                    EmailAttachmentList = new List<DocumentDetailsModel>();
                    pdocid = (objPolicyDocumentModel.PolicyDocumentId == null) ? 0 : Convert.ToInt32(objPolicyDocumentModel.PolicyDocumentId);

                    //check and validate if file uploaded for policy document 
                    //This check is needed only for new and edit policy document to make sure user has uploaded file needed
                    #region temparary commented
                    //following code is commented until final solution to issue of save in case of edit is found
                    //if (dicPolicyDocumentsUploadFileList.Count > 0)
                    //{
                    //check at least one policy document is uploaded for policy
                    //email attachment are optional
                    if (dicPolicyDocumentsUploadFileList.Count > 0) // file is uploaded and data found for file upload
                    {
                        UploadFileDocumentDetailsModelList = dicPolicyDocumentsUploadFileList[ConstEnum.Code.PolicyDocument];
                    }

                    //check file upload by comparing purpose code id
                    int policyFileCounter = 0;
                    int emailAttachmentCounter = 0;
                    if (UploadFileDocumentDetailsModelList != null)
                    {
                        foreach (DocumentDetailsModel objDocumentDetailsModel in UploadFileDocumentDetailsModelList)
                        {
                            // check for uploaded document only
                            if (objDocumentDetailsModel.GUID != null)
                            {
                                if (objDocumentDetailsModel.PurposeCodeId == null || objDocumentDetailsModel.PurposeCodeId == 0) //file related to policy document
                                {
                                    policyFileCounter++;
                                    PoliycDocumentList.Add(objDocumentDetailsModel);
                                }
                                else if (objDocumentDetailsModel.PurposeCodeId == ConstEnum.Code.EmailAttachment) //file related to email attachment
                                {
                                    emailAttachmentCounter++;
                                    EmailAttachmentList.Add(objDocumentDetailsModel);
                                }
                            }
                        }
                    }

                    if (policyFileCounter == 0)//no document is uploaded 
                    {

                        PoliycDocumentList = Common.Common.GenerateDocumentList(ConstEnum.Code.PolicyDocument, pdocid, 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.PolicyDocumentFile);

                        if (pdocid == 0 || (pdocid > 0 && PoliycDocumentList[0].DocumentId == null)) //policy document is already saved 
                        {
                            bNoErrorMessage = false;
                            sErrMessage = Common.Common.getResource("rul_msg_15253");
                        }
                    }
                    if (emailAttachmentCounter == 0)
                    {
                        EmailAttachmentList = Common.Common.GenerateDocumentList(ConstEnum.Code.PolicyDocument, pdocid, 0, objPolicyDocumentModel.PolicyDocumentFile, ConstEnum.Code.EmailAttachment, false, 0, ConstEnum.FileUploadControlCount.PolicyDocumentEmailAttachment);
                    }
                    //}
                    //else
                    //{
                    //    //no file uploaded for document - show error and 
                    //    bNoErrorMessage = false;
                    //    sErrMessage = "Please upload policy document";

                    //    PoliycDocumentList = Common.Common.GenerateDocumentList(ConstEnum.Code.PolicyDocument, pdocid, 0, null, 0);
                    //    EmailAttachmentList = Common.Common.GenerateDocumentList(ConstEnum.Code.PolicyDocument, pdocid, 0, objPolicyDocumentModel.PolicyDocumentFile, ConstEnum.Code.EmailAttachment);
                    //}
                    #endregion temparary commented

                    allowChangeStatus = (pdocid > 0) ? true : false; //set flag to decide allow user to change policy document status or not


                    #region Validation of Applicable From Date Cannot Be Less Than Today's Date
                    if (objPolicyDocumentModel.ApplicableFrom < DateTime.Today)
                    {
                        string applicableFromDateValidation = Common.Common.getResource("rul_msg_50635");

                        ModelState.AddModelError("Error", applicableFromDateValidation);
                        bNoErrorMessage = false;
                    }
                    #endregion


                    //if file validation is success then save/redirect to applicability 
                    if (bNoErrorMessage)
                    {
                        objPolicyDocumentDTO = new PolicyDocumentDTO();

                        if (objPolicyDocumentModel.PolicyDocumentId == null)
                        {
                            //set policy document id as default for saving for first time
                            objPolicyDocumentModel.PolicyDocumentId = 0;
                        }

                        Common.Common.CopyObjectPropertyByName(objPolicyDocumentModel, objPolicyDocumentDTO);

                        //check if display in policy document radio button checked
                        if (objPolicyDocumentModel.DisplayInPolicyDocument != null)
                        {
                            objPolicyDocumentDTO.DisplayInPolicyDocumentFlag = (objPolicyDocumentModel.DisplayInPolicyDocument == YesNo.Yes) ? true : false;
                        }

                        //check if sent email update radio button checked
                        if (objPolicyDocumentModel.SendEmailUpdate != null)
                        {
                            objPolicyDocumentDTO.SendEmailUpdateFlag = (objPolicyDocumentModel.SendEmailUpdate == YesNo.Yes) ? true : false;
                        }

                        //check policy document windows status and by default set windows status to incomplete
                        if (objPolicyDocumentModel.WindowStatus != null)
                        {
                            switch (objPolicyDocumentModel.WindowStatus)
                            {
                                case WindowStatusCode.Incomplete:
                                    objPolicyDocumentDTO.WindowStatusCodeId = ConstEnum.Code.PolicyDocumentWindowStatusIncomplete;
                                    break;
                                case WindowStatusCode.Active:
                                    objPolicyDocumentDTO.WindowStatusCodeId = ConstEnum.Code.PolicyDocumentWindowStatusActive;
                                    break;
                                case WindowStatusCode.Deactive:
                                    objPolicyDocumentDTO.WindowStatusCodeId = ConstEnum.Code.PolicyDocumentWindowStatusDeactive;
                                    break;
                                default:
                                    objPolicyDocumentDTO.WindowStatusCodeId = ConstEnum.Code.PolicyDocumentWindowStatusIncomplete;
                                    break;
                            }
                        }
                        else
                        {
                            objPolicyDocumentDTO.WindowStatusCodeId = ConstEnum.Code.PolicyDocumentWindowStatusIncomplete;
                        }

                        objPolicyDocumentDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;

                        using (PolicyDocumentsSL objPolicyDocumentSL = new PolicyDocumentsSL())
                        {
                            //get already saved policy document details, if avaiable
                            if (pdocid > 0)
                            {
                                objPolicyDocumentDTO_BeforeSave = objPolicyDocumentSL.GetPolicyDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, pdocid);
                            }

                            o_objPolicyDocumentDTO = objPolicyDocumentSL.SavePolicyDocument(objLoginUserDetails.CompanyDBConnectionString, objPolicyDocumentDTO);

                        }

                        policy_document_id = Convert.ToInt32(o_objPolicyDocumentDTO.PolicyDocumentId);

                        allowChangeStatus = true; //set flag to decide allow user to change policy document status or not

                        //save file uploaded - only when saving document for first time - 
                        //in case of edit no need to save details because document are uploaded and records are updated directly
                        if (objPolicyDocumentModel.PolicyDocumentId == 0)
                        {
                            objDocumentDetailsSL = new DocumentDetailsSL();

                            //save / update policy document file 
                            List<DocumentDetailsModel> objSavedDocumentDetialsModelList = objDocumentDetailsSL.SaveDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, UploadFileDocumentDetailsModelList, ConstEnum.Code.PolicyDocument, policy_document_id, objLoginUserDetails.LoggedInUserID);
                            if (objSavedDocumentDetialsModelList.Count == 0)
                            {
                                bNoErrorMessage = false;
                                sErrMessage = Common.Common.getResource("rul_msg_15254");
                                showApplicabilityButton = false;
                            }
                            else
                            {
                                //set flag to show applicability button as files are uploded properly
                                showApplicabilityButton = true;
                            }
                        }
                        else
                        {
                            //set flag to show applicability button as policy document is saved
                            showApplicabilityButton = true;
                        }
                    }
                    //}
                    //else
                    //{
                    //    //policy document is not saved so get policy document to redirect to applicablity page
                    //    policy_document_id = Convert.ToInt32(objPolicyDocumentModel.PolicyDocumentId);
                    //}
                }
                catch (Exception exp)
                {
                    bNoErrorMessage = false;
                    sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                }

                using (ApplicabilitySL objApplicablitySL = new ApplicabilitySL())
                {
                    objApplicablityDTO = objApplicablitySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PolicyDocument, pdocid);
                }

                //set error message to model and show user error message
                if (!bNoErrorMessage)
                {
                    //error message is set - show user error message
                    ModelState.AddModelError("Error", sErrMessage);

                    //set file upload list 
                    objPolicyDocumentModel.PolicyDocumentFile = PoliycDocumentList;
                    objPolicyDocumentModel.EmailAttachment = EmailAttachmentList;

                    //remove description and path valiation for file upload
                    ModelState.Remove("[0].value[0].DocumentName");
                    ModelState.Remove("[0].value[0].Description");
                    ModelState.Remove("[0].value[0].Document");
                    ModelState.Remove("[0].value[1].DocumentName");
                    ModelState.Remove("[0].value[1].Description");
                    ModelState.Remove("[0].value[1].Document");

                    ModelState.Remove("[0].value[2].DocumentName");
                    ModelState.Remove("[0].value[2].Description");
                    ModelState.Remove("[0].value[2].Document");
                    ModelState.Remove("[0].value[3].DocumentName");
                    ModelState.Remove("[0].value[3].Description");
                    ModelState.Remove("[0].value[3].Document");

                    ModelState.Remove("[0].value[4].DocumentName");
                    ModelState.Remove("[0].value[4].Description");
                    ModelState.Remove("[0].value[4].Document");
                    ModelState.Remove("[0].value[5].DocumentName");
                    ModelState.Remove("[0].value[5].Description");
                    ModelState.Remove("[0].value[5].Document");

                    DateTime currentDBDate = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);
                    objPolicyDocumentModel.DBCurrentDate = currentDBDate;

                    ViewBag.DocumentCategoryDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.PolicyDocumentCategory, null, null, null, null, true, sLookupPrefix);
                    List<PopulateComboDTO> lstPopulateComboDTO = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.PolicyDocumentSubCategory, objPolicyDocumentModel.DocumentCategoryCodeId.ToString(), null, null, null, true, sLookupPrefix);

                    ViewBag.ShowDocumentSubCategoryDropDown = true;
                    if (lstPopulateComboDTO.Count <= 1)
                    {
                        ModelState.Remove("DocumentSubCategoryCodeId");
                        ViewBag.ShowDocumentSubCategoryDropDown = false;
                    }
                    ViewBag.DocumentSubCategoryDropDown = lstPopulateComboDTO;
                    ViewBag.CompanyDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CompanyList, null, null, null, null, null, true, sLookupPrefix);

                    //check and set flag for allow save and edit 
                    SetAllowEditSaveFlag(objPolicyDocumentModel, "e", out isSaveAllowed, out isAllEdit, out isPartialEdit, out isNoEdit);

                    ViewBag.isSaveAllowed = isSaveAllowed;
                    ViewBag.isAllEdit = isAllEdit;
                    ViewBag.isPartialEdit = isPartialEdit;
                    ViewBag.isNoEdit = isNoEdit;
                   
                    if (Request.Params["authorization"] != null && Request.Params["authorization"] != "")
                    {
                        acid = Convert.ToInt32(Request.Params["authorization"].Split(':')[1]);
                    }
                    ViewBag.UserAction = acid;

                    ViewBag.allowChangeStatus = allowChangeStatus; //set flag to decide allow user to change policy document status or not

                    //check if applicablity is define or not 
                    if (allowChangeStatus)
                    {
                        //check applicablity - if null then no applicablity is defined 
                        if (objApplicablityDTO != null)
                        {
                            //applicablity is set for policy document - set flag which is use to show applicablity msg if user select Activte status radio button
                            isApplicabilitySet = true;
                        }
                    }

                    ViewBag.isApplicabilitySet = isApplicabilitySet;
                    ViewBag.applicablityNotDefineMsg = applicablityNotDefineMsg;

                    ViewBag.showSaveButton = showSaveButton;
                    ViewBag.showApplicabilityButton = showApplicabilityButton;
                    if (showApplicabilityButton)
                    {
                        applicablityCalledFrom = "e";
                    }
                    ViewBag.applicablityCalledFrom = applicablityCalledFrom;

                    objPolicyDocumentModel.isSaveAllowed = isSaveAllowed;

                    return View("Create", objPolicyDocumentModel);
                }

                //check what changes has been saved and set message accordingly
                ArrayList msg_param_lst = new ArrayList();
                msg_param_lst.Add(objPolicyDocumentModel.PolicyDocumentName);

                sucess_msg = Common.Common.getResource("rul_msg_15412", msg_param_lst);

                if (objPolicyDocumentDTO_BeforeSave != null && o_objPolicyDocumentDTO != null)
                {
                    //check if policy document is status is change or not - if not same status means status is changed so show success message accordingly 
                    if (objPolicyDocumentDTO_BeforeSave.WindowStatusCodeId != o_objPolicyDocumentDTO.WindowStatusCodeId)
                    {
                        switch (o_objPolicyDocumentDTO.WindowStatusCodeId)
                        {
                            case ConstEnum.Code.PolicyDocumentWindowStatusActive:
                                sucess_msg = Common.Common.getResource("rul_msg_15413", msg_param_lst);
                                break;
                            case ConstEnum.Code.PolicyDocumentWindowStatusDeactive:
                                sucess_msg = Common.Common.getResource("rul_msg_15414", msg_param_lst);
                                break;
                        }
                    }
                }

                //check applicablity - if null then no applicablity is defined 
                if (objApplicablityDTO != null)
                {
                    //applicablity is already define so redirect user to policy document page 
                    return RedirectToAction("Index", "PolicyDocuments", new { acid = ConstEnum.UserActions.RULES_POLICY_DOCUMENT_LIST }).Success(sucess_msg);
                }
            }
            finally
            {
                objLoginUserDetails = null;
                objPolicyDocumentDTO = null;
                objPolicyDocumentDTO_BeforeSave = null;
                o_objPolicyDocumentDTO = null;
                objApplicablityDTO = null;

                UploadFileDocumentDetailsModelList = null;

                PoliycDocumentList = null;
                EmailAttachmentList = null;
            }

            //applicablity is NOT define so redirect to edit page where same page is shown 
            return RedirectToAction("Edit", "PolicyDocuments", new { acid = ConstEnum.UserActions.POLICY_DOCUMENT_EDIT, pdid = policy_document_id, view = "e" }).Success(sucess_msg);
        }
        #endregion Save (save/update records and show next screen)

        #region SubCategoryDropdown
        /// <summary>
        /// This method is used to fetch sub category drop down view (partial)
        /// </summary>
        /// <param name="category_id"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult SubCategory(int category_id, bool edit, int acid, bool subcat = false)
        {
            LoginUserDetails objLoginUserDetails = null;
            List<PopulateComboDTO> lstPopulateComboDTO = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                string category = category_id.ToString();

                //check subcat flag and category id -- if flag is true and category is 0 then set category to null -- to fetch all sub category list
                if (subcat && category_id == 0)
                {
                    category = null;
                }

                lstPopulateComboDTO = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.PolicyDocumentSubCategory, category, null, null, null, true, sLookupPrefix);

                if (lstPopulateComboDTO.Count <= 1)
                {
                    return Content("");
                }

                ViewBag.DocumentSubCategoryDropDown = lstPopulateComboDTO;

                ViewBag.isAllEdit = edit;

                ViewBag.GridType = ConstEnum.GridType.PoliycDocumentsList;
            }
            finally
            {
                objLoginUserDetails = null;
                lstPopulateComboDTO = null;
            }
            

            return PartialView("PartialSubCategory");
        }
        #endregion SubCategoryDropdown

        #region Edit
        /// <summary>
        /// This method is used to return view for edit policy document - either in edit mode or view only mode
        /// </summary>
        /// <param name="acid"></param>
        /// <param name="pdid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult Edit(int acid, int pdid, string view="")
        {
            PolicyDocumentModel objPolicyDocumentModel = null;
            LoginUserDetails objLoginUserDetails = null;
            PolicyDocumentDTO objPolicyDocumentDTO = null;
            ApplicabilityDTO objApplicablityDTO = null;

            //following flag used for edit page option and set if control are allowed to edit or not
            bool isSaveAllowed = true;
            bool isAllEdit = true;
            bool isPartialEdit = false;
            bool isNoEdit = false;

            bool showSaveButton = true;
            bool showApplicabilityButton = true;
            //string applicablityCalledFrom = " ";
            
            bool allowChangeStatus = true;
            bool isApplicabilitySet = false;
            string applicablityNotDefineMsg = Common.Common.getResource("rul_msg_15252");

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objPolicyDocumentModel = new PolicyDocumentModel();

                using (PolicyDocumentsSL objPolicyDocumentSL = new PolicyDocumentsSL())
                {
                    objPolicyDocumentDTO = objPolicyDocumentSL.GetPolicyDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, pdid);

                    Common.Common.CopyObjectPropertyByName(objPolicyDocumentDTO, objPolicyDocumentModel);
                }

                //check if display in policy document radio button checked
                //if (objPolicyDocumentModel.DisplayInPolicyDocumentFlag != null)
                //{
                    objPolicyDocumentModel.DisplayInPolicyDocument = (objPolicyDocumentModel.DisplayInPolicyDocumentFlag) ? YesNo.Yes : YesNo.No;
                //}
                
                //check if sent email update radio button checked
                //if (objPolicyDocumentModel.SendEmailUpdateFlag != null)
                //{
                    objPolicyDocumentModel.SendEmailUpdate = (objPolicyDocumentModel.SendEmailUpdateFlag) ? YesNo.Yes : YesNo.No;
                //}

                //check policy document windows status and by default set windows status to incomplete
                if (objPolicyDocumentModel.WindowStatusCodeId != null)
                {
                    switch (objPolicyDocumentModel.WindowStatusCodeId)
                    {
                        case ConstEnum.Code.PolicyDocumentWindowStatusIncomplete:
                            objPolicyDocumentModel.WindowStatus = WindowStatusCode.Incomplete;
                            break;
                        case ConstEnum.Code.PolicyDocumentWindowStatusActive:
                            objPolicyDocumentModel.WindowStatus = WindowStatusCode.Active;
                            break;
                        case ConstEnum.Code.PolicyDocumentWindowStatusDeactive:
                            objPolicyDocumentModel.WindowStatus = WindowStatusCode.Deactive;
                            break;
                        default:
                            objPolicyDocumentModel.WindowStatus = WindowStatusCode.Incomplete;
                            break;
                    }
                }
                else
                {
                    objPolicyDocumentModel.WindowStatus = WindowStatusCode.Incomplete;
                }

                //fetch details for document attach with policy and email attachment if any
                objPolicyDocumentModel.PolicyDocumentFile = Common.Common.GenerateDocumentList(ConstEnum.Code.PolicyDocument, pdid, 0, null, 0, false, 0, ConstEnum.FileUploadControlCount.PolicyDocumentFile);
                objPolicyDocumentModel.EmailAttachment = Common.Common.GenerateDocumentList(ConstEnum.Code.PolicyDocument, pdid, 0, objPolicyDocumentModel.PolicyDocumentFile, ConstEnum.Code.EmailAttachment, false, 0, ConstEnum.FileUploadControlCount.PolicyDocumentEmailAttachment);

                //check if file is uploaded for policy document so to show applicabity button 
                if (objPolicyDocumentModel.PolicyDocumentFile[0].DocumentId == null || objPolicyDocumentModel.PolicyDocumentFile[0].DocumentId == 0)
                {
                    showApplicabilityButton = false;
                }

                //set valued need on view page into viewbag
                ViewBag.DocumentCategoryDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.PolicyDocumentCategory, null, null, null, null, true, sLookupPrefix);
                List<PopulateComboDTO> lstPopulateComboDTO = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.PolicyDocumentSubCategory, objPolicyDocumentModel.DocumentCategoryCodeId.ToString(), null, null, null, true, sLookupPrefix);

                ViewBag.ShowDocumentSubCategoryDropDown = true;
                if (lstPopulateComboDTO.Count <= 1)
                {
                    ViewBag.ShowDocumentSubCategoryDropDown = false;
                }
                ViewBag.DocumentSubCategoryDropDown = lstPopulateComboDTO;
                ViewBag.CompanyDropDown = FillComboValues(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CompanyList, null, null, null, null, null, true, sLookupPrefix);

                //check and set flag for allow save and edit 
                SetAllowEditSaveFlag(objPolicyDocumentModel, view, out isSaveAllowed, out isAllEdit, out isPartialEdit, out isNoEdit);

                ViewBag.isSaveAllowed = isSaveAllowed;
                ViewBag.isAllEdit = isAllEdit;
                ViewBag.isPartialEdit = isPartialEdit;
                ViewBag.isNoEdit = isNoEdit;

                ViewBag.UserAction = acid;

                //check if request come from rule menu option or transaction menu option by comparing list view activity id 
                //and set to show next button or not which redirect to applicablity screen
                if (acid == ConstEnum.UserActions.POLICY_DOCUMENT_VIEW)
                {
                    showSaveButton = false;
                    showApplicabilityButton = true;
                    allowChangeStatus = false;  //set flag to decide allow user to change policy document status or not
                }
                else if (acid == ConstEnum.UserActions.TRANSACTION_POLICY_DOCUMENT_VIEW)
                {
                    showSaveButton = false;
                    showApplicabilityButton = false;
                    allowChangeStatus = false;  //set flag to decide allow user to change policy document status or not
                }
                
                //check if applicablity is define or not 
                if (allowChangeStatus)
                {
                    using (ApplicabilitySL objApplicablitySL = new ApplicabilitySL())
                    {
                        objApplicablityDTO = objApplicablitySL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PolicyDocument, pdid);
                    }

                    //check applicablity - if null then no applicablity is defined 
                    if (objApplicablityDTO != null)
                    {
                        //applicablity is set for policy document - set flag which is use to show applicablity msg if user select Activte status radio button
                        isApplicabilitySet = true;
                    }
                    else
                    {
                        allowChangeStatus = false;
                    }
                }

                ViewBag.allowChangeStatus = allowChangeStatus;
                ViewBag.isApplicabilitySet = isApplicabilitySet;
                ViewBag.applicablityNotDefineMsg = applicablityNotDefineMsg;

                ViewBag.showSaveButton = showSaveButton;

                ViewBag.showApplicabilityButton = showApplicabilityButton;
                ViewBag.applicablityCalledFrom = view;

                objPolicyDocumentModel.isSaveAllowed = isSaveAllowed;
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objPolicyDocumentDTO = null;
                objApplicablityDTO = null;
            }

            return View("Create", objPolicyDocumentModel);
        }
        #endregion Edit

        #region Delete
        /// <summary>
        /// This method is used to delete all policy document details
        /// NOTE - this delete is just mark data deleted and does not delete actual record from DB - so no need to delete policy document file uploaded and applicablity data
        /// </summary>
        /// <param name="acid"></param>
        /// <param name="pdid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult Delete(int acid, int pdid)
        {
            LoginUserDetails objLoginUserDetails = null;
            bool bReturn = false;
            var ErrorDictionary = new Dictionary<string, string>();
            bool statusFlag = false;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                using (PolicyDocumentsSL objPolicyDocumentSL = new PolicyDocumentsSL())
                {
                    //delete policy document details
                    //NOTE - this delete is just mark data deleted and NOT hard delete - so no need to delete policy document file uploaded and applicablity data 
                    bReturn = objPolicyDocumentSL.DeletePolicyDocument(objLoginUserDetails.CompanyDBConnectionString, pdid, objLoginUserDetails.LoggedInUserID);

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
            }

            return Json(new { status = statusFlag, Message = ErrorDictionary}, JsonRequestBehavior.AllowGet);
        }

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }
        #endregion Delete

        #region View (To whom policy document applicable)
        /// <summary>
        /// This method used to show to whom policy document is applicable and each applicable user's status regarding policy
        /// </summary>
        /// <param name="acid"></param>
        /// <param name="pdid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult View(int acid, int pdid)
        {
            PolicyDocumentModel objPolicyDocumentModel = null;
            LoginUserDetails objLoginUserDetails = null;
            PolicyDocumentDTO objPolicyDocumentDTO = null;
            List<DocumentDetailsDTO> objDocumentDetailsDTOList = null;

            int nAttachDocumentId = 0;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objPolicyDocumentModel = new PolicyDocumentModel();

                using (PolicyDocumentsSL objPolicyDocumentSL = new PolicyDocumentsSL())
                {
                    objPolicyDocumentDTO = objPolicyDocumentSL.GetPolicyDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, pdid);

                    Common.Common.CopyObjectPropertyByName(objPolicyDocumentDTO, objPolicyDocumentModel);
                }

                //check if display in policy document radio button checked
                //if (objPolicyDocumentModel.DisplayInPolicyDocumentFlag != null)
                //{
                    objPolicyDocumentModel.DisplayInPolicyDocument = (objPolicyDocumentModel.DisplayInPolicyDocumentFlag) ? YesNo.Yes : YesNo.No;
                //}

                //get document details - document id - to set and show document to user
                using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                {
                    objDocumentDetailsDTOList = objDocumentDetailsSL.GetDocumentList(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.Code.PolicyDocument, pdid, 0);
                    nAttachDocumentId = objDocumentDetailsDTOList.Count() == 0 ? 0 : objDocumentDetailsDTOList[0].DocumentId;
                    ViewBag.AttachDocumentId = nAttachDocumentId;
                }

                //check if sent email update radio button checked
                //if (objPolicyDocumentModel.SendEmailUpdateFlag != null)
                //{
                    objPolicyDocumentModel.SendEmailUpdate = (objPolicyDocumentModel.SendEmailUpdateFlag) ? YesNo.Yes : YesNo.No;
                //}

                //check policy document windows status and by default set windows status to incomplete
                if (objPolicyDocumentModel.WindowStatusCodeId != null)
                {
                    switch (objPolicyDocumentModel.WindowStatusCodeId)
                    {
                        case ConstEnum.Code.PolicyDocumentWindowStatusIncomplete:
                            objPolicyDocumentModel.WindowStatus = WindowStatusCode.Incomplete;
                            break;
                        case ConstEnum.Code.PolicyDocumentWindowStatusActive:
                            objPolicyDocumentModel.WindowStatus = WindowStatusCode.Active;
                            break;
                        case ConstEnum.Code.PolicyDocumentWindowStatusDeactive:
                            objPolicyDocumentModel.WindowStatus = WindowStatusCode.Deactive;
                            break;
                        default:
                            objPolicyDocumentModel.WindowStatus = WindowStatusCode.Incomplete;
                            break;
                    }
                }
                else
                {
                    objPolicyDocumentModel.WindowStatus = WindowStatusCode.Incomplete;
                }

                //to display employee insider list
                ViewBag.EmployeeInsiderGridType = ConstEnum.GridType.PolicyDocumentApplicablityList_Employee;

                //to display corporate insider list
                ViewBag.CorporateInsiderGridType = ConstEnum.GridType.PolicyDocumentApplicablityList_Corporate;

                //to display non employee insider list
                ViewBag.NonEmployeeInsiderGridType = ConstEnum.GridType.PolicyDocumentApplicablityList_NonEmployee;

                //to display employee list
                ViewBag.EmployeeGridType = ConstEnum.GridType.PolicyDocumentApplicablityList_EmployeeNotInsider;

            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                objPolicyDocumentDTO = null;
                objDocumentDetailsDTOList = null;
            }

            return View("View", objPolicyDocumentModel);
        }
        #endregion View (To whom policy document applicable)

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
                objPopulateComboDTO.Value = "";
                
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
            finally
            {
                objPopulateComboDTO = null;
            }

            return lstPopulateComboDTO;
        }
        #endregion FillComboValues

        #region SetAllowEditSaveFlag
        /// <summary>
        /// This method is used to check if policy document is for allowed to edit and save or not - and set flag accordingly 
        /// </summary>
        /// <param name="objPolicyDocumentModel"></param>
        /// <param name="call_for"></param>
        /// <param name="isSaveAllowed"></param>
        /// <param name="isAllEdit"></param>
        /// <param name="isPartialEdit"></param>
        /// <param name="isNoEdit"></param>
        private void SetAllowEditSaveFlag(PolicyDocumentModel objPolicyDocumentModel, string call_for, out bool isSaveAllowed, out bool isAllEdit, out bool isPartialEdit, out bool isNoEdit)
        {
            //set values for out parameter
            isSaveAllowed = isAllEdit = true;
            isPartialEdit = isNoEdit = false;

            //check edit view show allow to edit data or not. also check if edit is allowed then base on date edit will be for all field or selected field
            //check if request is to show page as view or edit 
            if (call_for == "" || call_for != "e")
            {
                //this is view only page
                isSaveAllowed = false;
                isAllEdit = false;
                isNoEdit = true;
            }
            else
            {
                //this is edit page
                if (objPolicyDocumentModel.ApplicableFrom != null && objPolicyDocumentModel.ApplicableTo != null)
                {
                    //check window status and if window is NOT incomplete then check user is allowed to all edit or partial edit base on current date
                    if (objPolicyDocumentModel.WindowStatus != null && objPolicyDocumentModel.WindowStatus != WindowStatusCode.Incomplete)
                    {
                        DateTime frm_date = ((DateTime)objPolicyDocumentModel.ApplicableFrom).Date;
                        DateTime to_date = ((DateTime)objPolicyDocumentModel.ApplicableTo).Date;
                        DateTime cur_date = ((DateTime)objPolicyDocumentModel.DBCurrentDate).Date;

                        //check if current date before or after the appilcation from date
                        if (cur_date < frm_date)
                        {
                            //allow user to edit all fields 
                            isAllEdit = true;
                        }
                        else if (cur_date >= frm_date && cur_date < to_date)
                        {
                            //allow user to partial edit ie can change applicable to date and windows status field
                            isAllEdit = false;
                            isPartialEdit = true;
                        }
                        else if (cur_date >= to_date)
                        {
                            //do not all user to edit anything
                            isAllEdit = false;
                            isNoEdit = true;

                            isSaveAllowed = false;
                        }
                    }
                }
            }
        }
        #endregion SetAllowEditSaveFlag

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
    }
}