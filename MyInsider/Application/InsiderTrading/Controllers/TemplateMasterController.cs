using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class TemplateMasterController : Controller
    {
        #region Common objects
        StringWriter objContentsWriter = new StringWriter();
        StringWriter objSignatureWriter = new StringWriter();
        StringWriter objSubjectWriter = new StringWriter();
        StringWriter objTemplateWriter = new StringWriter();
        StringWriter objAddress1Writer = new StringWriter();
        StringWriter objAddress2Writer = new StringWriter();
        #endregion
        #region Index
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            TemplateMasterModel objTemplateMasterModel = new TemplateMasterModel();
            try
            {
                List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.RoleStatus).ToString(), null, null, null, null, true);

                ViewBag.TemplateStatus = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.CommunicationModes).ToString(), null, null, null, null, true);

                ViewBag.CommunicationMode = lstList;

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, Convert.ToInt32(ConstEnum.CodeGroup.DisclosureType).ToString(), null, null, null, null, true);
                ViewBag.DisclosureType = lstList;
                ViewBag.acid = acid;
                lstList = null;
                FillGrid(ConstEnum.GridType.TemplateMasteList, null, null, null);

                return View("View");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("View", objTemplateMasterModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objTemplateMasterModel = null;
            }
        }
        #endregion Index

        #region Create
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(int acid, int TemplateMasterId, string calledFrom = "")
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            //CompaniesSL objCompaniesSL = new CompaniesSL();
            ImplementedCompanyDTO objImplementedCompanyDTO = new ImplementedCompanyDTO();
            TemplateMasterModel objTemplateMasterModel = new TemplateMasterModel();
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();
            //TemplateMasterSL objTemplateMasterSL = new TemplateMasterSL();
            TemplateMasterDTO objTemplateMasterDTO = new TemplateMasterDTO();


            StringWriter objSignatureWriter = new StringWriter();
            StringWriter objSubjectWriter = new StringWriter();
            StringWriter objTemplateWriter = new StringWriter();
            StringWriter objAddress1Writer = new StringWriter();
            StringWriter objAddress2Writer = new StringWriter();

            //get list of communication mode
            lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.CommunicationModes, null, null, null, null, true);
            if (TemplateMasterId == 0)
            {
                List<PopulateComboDTO> lstListForRules = new List<PopulateComboDTO>();
                foreach (PopulateComboDTO objItem in lstList)
                {
                    if (objItem.Key != ConstEnum.Code.CommunicationModeForFormE.ToString())
                    {
                        lstListForRules.Add(objItem);
                    }
                }
                ViewBag.CommunicationMode = lstListForRules;
            }
            else
            {
                ViewBag.CommunicationMode = lstList;
            }

            //get list of disclousre type
            lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.DisclosureType, null, null, null, null, true);
            ViewBag.DisclosureType = lstList;

            //get list of user type for letter type communicaiton mode 
            lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.DisclosureLetterForUserType, ConstEnum.Code.CommunicationModeForLetter.ToString(), null, null, null, true);
            ViewBag.LetterFor = lstList;

            //get list of user type for FAQ type communicaiton mode 
            lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.DisclosureLetterForUserType, ConstEnum.Code.CommunicationModeForFAQ.ToString(), null, null, null, true);
            ViewBag.FAQFor = lstList;
            lstList = null;
            ViewBag.TemplateMasterId = TemplateMasterId;
            ViewBag.placeholderarr = "[]";
            if (TemplateMasterId > 0)
            {
                using (var objTemplateMasterSL = new TemplateMasterSL())
                {
                    objTemplateMasterDTO = objTemplateMasterSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, TemplateMasterId);
                }
                InsiderTrading.Common.Common.CopyObjectPropertyByName(objTemplateMasterDTO, objTemplateMasterModel);

                if (objTemplateMasterModel.CommunicationModeCodeId == ConstEnum.Code.CommunicationModeForEmail)
                {
                    objTemplateMasterModel.CommunicationFromEmail = objTemplateMasterModel.CommunicationFrom;
                }
                objTemplateMasterModel.Contents = objTemplateMasterModel.Contents.Replace("\\r\\n", Environment.NewLine);

                HttpUtility.HtmlDecode(objTemplateMasterModel.Contents, objContentsWriter);
                objTemplateMasterModel.Contents = objContentsWriter.ToString();

                HttpUtility.HtmlDecode(objTemplateMasterModel.Subject, objSubjectWriter);
                objTemplateMasterModel.Subject = objSubjectWriter.ToString();


                HttpUtility.HtmlDecode(objTemplateMasterModel.TemplateName, objTemplateWriter);
                objTemplateMasterModel.TemplateName = objTemplateWriter.ToString();

                if (objTemplateMasterModel.CommunicationModeCodeId == Common.ConstEnum.Code.CommunicationModeForEmail)
                {
                    List<string> lst = new List<string>();
                    MatchCollection mcol = Regex.Matches(objTemplateMasterModel.Contents, @"\|~\|(.*?)\|~\|");

                    foreach (Match m in mcol)
                    {
                        if (m != null && m.ToString() != "")
                        {
                            //objTemplateMasterModel.Contents = objTemplateMasterModel.Contents.Replace(m.ToString(), "[[[[" + m.ToString() + "]]]]");
                            objTemplateMasterModel.Contents = objTemplateMasterModel.Contents;
                        }
                    }

                }

                if (objTemplateMasterModel.CommunicationModeCodeId == Common.ConstEnum.Code.CommunicationModeForFormE)
                {
                    List<string> lst = new List<string>();
                    MatchCollection matPlaceholderPattern1 = Regex.Matches(objTemplateMasterModel.Contents, @" \[(.*?)\]");


                    foreach (Match m in matPlaceholderPattern1)
                    {
                        if (m != null && m.ToString() != "")
                        {
                            objTemplateMasterModel.Contents = objTemplateMasterModel.Contents.Replace(m.ToString(), " [" + m.ToString().Trim() + "]");
                        }
                    }

                    MatchCollection matPlaceholderPattern2 = Regex.Matches(objTemplateMasterModel.Contents, @">(\[{1})(.*?)\]");

                    foreach (Match m in matPlaceholderPattern2)
                    {
                        //lst.Add(m.ToString());
                        if (m != null && m.ToString() != "")
                        {
                            string sPlaceHolderToReplace = m.ToString().Substring(1);
                            objTemplateMasterModel.Contents = objTemplateMasterModel.Contents.Replace(m.ToString(), ">[" + sPlaceHolderToReplace.Trim() + "]");
                        }
                    }
                }

                if (objTemplateMasterModel.Signature != null)
                {
                    objTemplateMasterModel.Signature = objTemplateMasterModel.Signature.Replace("\\r\\n", Environment.NewLine);
                    HttpUtility.HtmlDecode(objTemplateMasterModel.Signature, objSignatureWriter);
                    objTemplateMasterModel.Signature = objSignatureWriter.ToString();
                }

                if (objTemplateMasterModel.ToAddress1 != null)
                {
                    objTemplateMasterModel.ToAddress1 = objTemplateMasterModel.ToAddress1.Replace("\\r\\n", Environment.NewLine);
                    HttpUtility.HtmlDecode(objTemplateMasterModel.ToAddress1, objAddress1Writer);
                    objTemplateMasterModel.ToAddress1 = objAddress1Writer.ToString();

                }

                //for communcition type letter -- check if checkbox address 2 optional is checked or not 
                // if checkbox is NOT checked then set null else replace new line character for text entered
                if (objTemplateMasterModel.CommunicationModeCodeId == ConstEnum.Code.CommunicationModeForLetter && !objTemplateMasterModel.IsCommunicationTemplate)
                {
                    objTemplateMasterModel.ToAddress2 = null;
                }
                else
                {
                    if (objTemplateMasterModel.ToAddress2 != null)
                    {
                        objTemplateMasterModel.ToAddress2 = objTemplateMasterModel.ToAddress2.Replace("\\r\\n", Environment.NewLine);
                        HttpUtility.HtmlDecode(objTemplateMasterModel.ToAddress2, objAddress2Writer);
                        objTemplateMasterModel.ToAddress2 = objAddress2Writer.ToString();
                    }
                }

                if (objTemplateMasterModel.CommunicationModeCodeId == ConstEnum.Code.CommunicationModeForFormE)
                {
                    //Fetch the list of placeholders as per the communication mode
                    lstList = FillComboValues(ConstEnum.ComboType.TemplateMasterPlaceholderList, objTemplateMasterModel.CommunicationModeCodeId.ToString(), null, null, null, null, false);

                    List<string[]> arrPlaceholdersList = new List<string[]>();
                    foreach (var placeholder in lstList)
                    {
                        string[] arrPlaceholder = new string[1];
                        arrPlaceholder[0] = placeholder.Value;
                        arrPlaceholdersList.Add(arrPlaceholder);
                    }

                    ViewBag.placeholderarr = JsonConvert.SerializeObject(arrPlaceholdersList).ToString();
                }
            }
            else
            {
                using (var objCompaniesSL = new CompaniesSL())
                {
                    objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                }
                //objTemplateMasterModel.CommunicationFrom = objImplementedCompanyDTO.EmailId;
                ViewBag.ImplementedCompanyEmailId = objImplementedCompanyDTO.EmailId;
            }

            ViewBag.CommunicationMode_id = objTemplateMasterModel.CommunicationModeCodeId;
            ViewBag.IsDisplayBackButton = true;
            ViewBag.calledFrom = calledFrom;
            ViewBag.acid = acid;
            if (calledFrom == "Communication")
            {
                ViewBag.IsDisplayBackButton = false;
                return PartialView("Create", objTemplateMasterModel);
            }
            else if (calledFrom == "CommunicationRule")
            {
                ViewBag.IsDisplayBackButton = false;
                return PartialView("Create", objTemplateMasterModel);
            }
            else
            {
                return View("Create", objTemplateMasterModel);
            }
        }
        #endregion Create

        #region PartialCreateView
        /// <summary>
        /// This method is used to fetch sub category drop down view (partial)
        /// </summary>
        /// <param name="category_id"></param>
        /// <returns></returns>
        public ActionResult PartialCreateView(int CommunicationMode_id)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();

            //get list of disclousre type
            lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.DisclosureType, null, null, null, null, true);
            ViewBag.DisclosureType = lstList;

            //get list of user type for letter type communicaiton mode 
            lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.DisclosureLetterForUserType, ConstEnum.Code.CommunicationModeForLetter.ToString(), null, null, null, true);
            ViewBag.LetterFor = lstList;

            //get list of user type for FAQ type communicaiton mode 
            lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.DisclosureLetterForUserType, ConstEnum.Code.CommunicationModeForFAQ.ToString(), null, null, null, true);
            ViewBag.FAQFor = lstList;

            ViewBag.CommunicationMode_id = CommunicationMode_id;
            return PartialView("PartialCreate");
        }
        #endregion PartialCreateView

        #region SaveAction
        [HttpPost]
        [ValidateAntiForgeryToken]
        //[TokenVerification]
        [Button(ButtonName = "Save")]
        [ActionName("SaveAction")]
        [AuthorizationPrivilegeFilter]
        public ActionResult SaveAction(int acid, TemplateMasterModel objTemplateMasterModel, string calledFrom)
        {

            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                // TODO: Add insert logic here
                objTemplateMasterModel.Contents = HttpUtility.HtmlEncode(objTemplateMasterModel.Contents);
                objTemplateMasterModel.Subject = HttpUtility.HtmlEncode(objTemplateMasterModel.Subject);
                objTemplateMasterModel.TemplateName = HttpUtility.HtmlEncode(objTemplateMasterModel.TemplateName);
                objTemplateMasterModel.Signature = HttpUtility.HtmlEncode(objTemplateMasterModel.Signature);

                string editorContent = Common.HtmlUtil.SanitizeHtml(objTemplateMasterModel.Contents);
                if (objTemplateMasterModel.CommunicationModeCodeId != Common.ConstEnum.Code.CommunicationModeForSMS && objTemplateMasterModel.CommunicationModeCodeId != Common.ConstEnum.Code.CommunicationModeForTextAlert)
                {
                    objTemplateMasterModel.Contents = editorContent.Replace(Environment.NewLine, "\\r\\n");
                    //objTemplateMasterModel.Contents = HttpUtility.HtmlEncode(editorContent);
                }

                if (objTemplateMasterModel.CommunicationModeCodeId == Common.ConstEnum.Code.CommunicationModeForFormE)
                {
                    objTemplateMasterModel.Contents = editorContent.Replace("[[", "[");
                    objTemplateMasterModel.Contents = editorContent.Replace("]]", "]");
                    //  objTemplateMasterModel.Contents = HttpUtility.HtmlEncode(editorContent);
                }

                if (objTemplateMasterModel.CommunicationModeCodeId == Common.ConstEnum.Code.CommunicationModeForEmail)
                {
                    objTemplateMasterModel.Contents = editorContent.Replace("[[|~|", "|~|");
                    objTemplateMasterModel.Contents = editorContent.Replace("|~|]]", "|~|");
                    // objTemplateMasterModel.Contents = HttpUtility.HtmlEncode(editorContent);
                }

                if (objTemplateMasterModel.Signature != null)
                {
                    objTemplateMasterModel.Signature = objTemplateMasterModel.Signature.Replace(Environment.NewLine, "\\r\\n");
                }

                if (objTemplateMasterModel.ToAddress1 != null)
                {
                    objTemplateMasterModel.ToAddress1 = objTemplateMasterModel.ToAddress1.Replace(Environment.NewLine, "\\r\\n");
                    objTemplateMasterModel.ToAddress1 = HttpUtility.HtmlEncode(objTemplateMasterModel.ToAddress1);
                }
                if (objTemplateMasterModel.CommunicationModeCodeId == Common.ConstEnum.Code.CommunicationModeForEmail && objTemplateMasterModel.CommunicationFrom != objTemplateMasterModel.CommunicationFromEmail)
                {
                    objTemplateMasterModel.CommunicationFrom = objTemplateMasterModel.CommunicationFromEmail;
                }
                //for communcition type letter -- check if checkbox address 2 optional is checked or not 
                // if checkbox is NOT checked then set null else replace new line character for text entered
                if (objTemplateMasterModel.CommunicationModeCodeId == ConstEnum.Code.CommunicationModeForLetter && !objTemplateMasterModel.IsCommunicationTemplate)
                {
                    objTemplateMasterModel.ToAddress2 = null;
                }
                else
                {
                    if (objTemplateMasterModel.ToAddress2 != null)
                    {
                        objTemplateMasterModel.ToAddress2 = objTemplateMasterModel.ToAddress2.Replace(Environment.NewLine, "\\r\\n");
                        objTemplateMasterModel.ToAddress2 = HttpUtility.HtmlEncode(objTemplateMasterModel.ToAddress2);
                    }
                }

                // TemplateMasterSL objTemplateMasterSL = new TemplateMasterSL();
                TemplateMasterDTO objTemplateMasterDTO = new TemplateMasterDTO();

                InsiderTrading.Common.Common.CopyObjectPropertyByName(objTemplateMasterModel, objTemplateMasterDTO);
                using (var objTemplateMasterSL = new TemplateMasterSL())
                {
                    objTemplateMasterDTO = objTemplateMasterSL.SaveDetails(objTemplateMasterDTO, objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                }
                if (calledFrom == "Communication")
                {
                    HttpUtility.HtmlDecode(objTemplateMasterDTO.TemplateName, objTemplateWriter);
                    //return RedirectToAction("Create", new { TemplateMasterId = objTemplateMasterDTO.TemplateMasterId, calledFrom = calledFrom });
                    return Json(new
                    {
                        status = true,
                        Message = Common.Common.getResource("tra_msg_16153"),//Common.Common.getResource("rul_msg_15380")//
                        CommunicationModeCodeId = objTemplateMasterDTO.CommunicationModeCodeId,
                        TemplateName = Convert.ToString(objTemplateWriter),
                        TemplateMasterId = objTemplateMasterDTO.TemplateMasterId
                    }, JsonRequestBehavior.AllowGet);
                }
                else if (calledFrom == "CommunicationRule")
                { //CommunicationRuleMaster/Index?acid=179
                    return Json(new
                    {
                        status = true,
                        Message = Common.Common.getResource("tra_msg_16153"),
                        CommunicationModeCodeId = objTemplateMasterDTO.CommunicationModeCodeId,
                        TemplateName = objTemplateMasterDTO.TemplateName,
                        TemplateMasterId = objTemplateMasterDTO.TemplateMasterId,
                        IsActive = objTemplateMasterDTO.IsActive

                    }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return RedirectToAction("Index", "TemplateMaster", new { acid = ConstEnum.UserActions.TEMPLATE_LIST_RIGHT }).Success(Common.Common.getResource("tra_msg_16153"));
                }
            }
            catch (Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                //return View();
                //return Json(new
                //{
                //    status = false,
                //    Message = sErrMessage
                //}, JsonRequestBehavior.AllowGet);
                ModelState.AddModelError("Error", sErrMessage);
                if (calledFrom == "Communication")
                {
                    return Json(new
                    {
                        status = false,
                        error = ModelState.ToSerializedDictionary(),
                        Message = sErrMessage
                    });
                }
                else if (calledFrom == "CommunicationRule")
                { //CommunicationRuleMaster/Index?acid=179
                    return Json(new
                    {
                        status = false,
                        error = ModelState.ToSerializedDictionary(),
                        Message = sErrMessage
                    }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();

                    //get list of communication mode
                    lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.CommunicationModes, null, null, null, null, true);
                    ViewBag.CommunicationMode = lstList;

                    //get list of disclousre type
                    lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.DisclosureType, null, null, null, null, true);
                    ViewBag.DisclosureType = lstList;

                    //get list of user type for letter type communicaiton mode 
                    lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.DisclosureLetterForUserType, ConstEnum.Code.CommunicationModeForLetter.ToString(), null, null, null, true);
                    ViewBag.LetterFor = lstList;

                    //get list of user type for FAQ type communicaiton mode 
                    lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.DisclosureLetterForUserType, ConstEnum.Code.CommunicationModeForFAQ.ToString(), null, null, null, true);
                    ViewBag.FAQFor = lstList;

                    ViewBag.TemplateMasterId = objTemplateMasterModel.TemplateMasterId;
                    ViewBag.CommunicationMode_id = objTemplateMasterModel.CommunicationModeCodeId;
                    ViewBag.IsDisplayBackButton = true;
                    ViewBag.calledFrom = calledFrom;

                    objTemplateMasterModel.Contents = objTemplateMasterModel.Contents.Replace("\\r\\n", Environment.NewLine);
                    HttpUtility.HtmlDecode(objTemplateMasterModel.Contents, objContentsWriter);
                    objTemplateMasterModel.Contents = objContentsWriter.ToString();

                    HttpUtility.HtmlDecode(objTemplateMasterModel.Subject, objSubjectWriter);
                    objTemplateMasterModel.Subject = objSubjectWriter.ToString();


                    HttpUtility.HtmlDecode(objTemplateMasterModel.TemplateName, objTemplateWriter);
                    objTemplateMasterModel.TemplateName = objTemplateWriter.ToString();

                    if (objTemplateMasterModel.Signature != null)
                    {
                        objTemplateMasterModel.Signature = objTemplateMasterModel.Signature.Replace("\\r\\n", Environment.NewLine);
                        HttpUtility.HtmlDecode(objTemplateMasterModel.Signature, objSignatureWriter);
                        objTemplateMasterModel.Signature = objSignatureWriter.ToString();
                    }

                    if (objTemplateMasterModel.ToAddress1 != null)
                    {
                        objTemplateMasterModel.ToAddress1 = objTemplateMasterModel.ToAddress1.Replace("\\r\\n", Environment.NewLine);
                        HttpUtility.HtmlDecode(objTemplateMasterModel.ToAddress1, objAddress1Writer);
                        objTemplateMasterModel.ToAddress1 = objAddress1Writer.ToString();

                    }

                    //for communcition type letter -- check if checkbox address 2 optional is checked or not 
                    // if checkbox is NOT checked then set null else replace new line character for text entered
                    if (objTemplateMasterModel.CommunicationModeCodeId == ConstEnum.Code.CommunicationModeForLetter && !objTemplateMasterModel.IsCommunicationTemplate)
                    {
                        objTemplateMasterModel.ToAddress2 = null;
                    }
                    else
                    {
                        if (objTemplateMasterModel.ToAddress2 != null)
                        {
                            objTemplateMasterModel.ToAddress2 = objTemplateMasterModel.ToAddress2.Replace("\\r\\n", Environment.NewLine);
                            HttpUtility.HtmlDecode(objTemplateMasterModel.ToAddress2, objAddress2Writer);
                            objTemplateMasterModel.ToAddress2 = objAddress2Writer.ToString();
                        }
                    }
                    lstList = null;

                    ViewBag.acid = acid;

                    return View("Create", objTemplateMasterModel);
                }
            }
            finally
            {
                objLoginUserDetails = null;
                objTemplateMasterModel = null;
            }
        }
        #endregion SaveAction

        #region Save
        //[HttpPost]
        //public JsonResult Save(TemplateMasterModel objTemplateMasterModel, string calledFrom)
        //{
        //    bool bStatus = false;
        //    string sMessage = null;
        //    int nCommunicationModeCodeId = 0;
        //    string sTemplateName = null;
        //    int nTemplateMasterId = 0;
        //    bool bIsActive = false;            

        //    try
        //    {
        //        // TODO: Add insert logic here

        //        if (objTemplateMasterModel.CommunicationModeCodeId != Common.ConstEnum.Code.CommunicationModeForSMS && objTemplateMasterModel.CommunicationModeCodeId != Common.ConstEnum.Code.CommunicationModeForTextAlert)
        //        {
        //            objTemplateMasterModel.Contents = objTemplateMasterModel.Contents.Replace(Environment.NewLine, "\\r\\n");
        //        }

        //        if (objTemplateMasterModel.Signature != null)
        //        {
        //            objTemplateMasterModel.Signature = objTemplateMasterModel.Signature.Replace(Environment.NewLine, "\\r\\n");
        //        }

        //        if (objTemplateMasterModel.ToAddress1 != null)
        //        {
        //            objTemplateMasterModel.ToAddress1 = objTemplateMasterModel.ToAddress1.Replace(Environment.NewLine, "\\r\\n");
        //        }

        //        //for communcition type letter -- check if checkbox address 2 optional is checked or not 
        //        // if checkbox is NOT checked then set null else replace new line character for text entered
        //        if (objTemplateMasterModel.CommunicationModeCodeId == ConstEnum.Code.CommunicationModeForLetter && !objTemplateMasterModel.IsCommunicationTemplate)
        //        {
        //            objTemplateMasterModel.ToAddress2 = null;
        //        }
        //        else
        //        {
        //            if (objTemplateMasterModel.ToAddress2 != null)
        //            {
        //                objTemplateMasterModel.ToAddress2 = objTemplateMasterModel.ToAddress2.Replace(Environment.NewLine, "\\r\\n");
        //            }
        //        }

        //        LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
        //        TemplateMasterSL objTemplateMasterSL = new TemplateMasterSL();
        //        TemplateMasterDTO objTemplateMasterDTO = new TemplateMasterDTO();

        //        InsiderTrading.Common.Common.CopyObjectPropertyByName(objTemplateMasterModel, objTemplateMasterDTO);

        //        objTemplateMasterDTO = objTemplateMasterSL.SaveDetails(objTemplateMasterDTO, objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);


        //                 bStatus = true;
        //                sMessage = Common.Common.getResource("tra_msg_16153");
        //                nCommunicationModeCodeId = objTemplateMasterDTO.CommunicationModeCodeId;
        //                sTemplateName = objTemplateMasterDTO.TemplateName;
        //                nTemplateMasterId = objTemplateMasterDTO.TemplateMasterId;
        //                bIsActive = objTemplateMasterDTO.IsActive;



        //        return Json(new {
        //            Status = bStatus,
        //            Message = sMessage,
        //            CommunicationModeCodeId = nCommunicationModeCodeId,
        //            TemplateName = sTemplateName,
        //            TemplateMasterId = nTemplateMasterId,
        //            IsActive = bIsActive
        //        }, JsonRequestBehavior.AllowGet);
        //    }
        //    catch (Exception exp)
        //    {
        //        ModelState.Remove("KEY");
        //        ModelState.Add("KEY", new ModelState());
        //        ModelState.Clear();
        //        string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
        //        //return View();
        //        //return Json(new
        //        //{
        //        //    status = false,
        //        //    Message = sErrMessage
        //        //}, JsonRequestBehavior.AllowGet);
        //        ModelState.AddModelError("Error", sErrMessage);
        //        bStatus = false;
        //        var error = ModelState.ToSerializedDictionary();
        //        sMessage = sErrMessage;

        //        return Json(new
        //        {
        //            Status = bStatus,
        //            error = error,
        //            Message = sMessage                     
        //        });


        //      }


        //}
        #endregion Save

        #region Delete
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult Delete(int acid, int TemplateMasterId)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            Common.Common objCommon = new Common.Common();
            try
            {
                // TemplateMasterSL objTemplateMasterSL = new TemplateMasterSL();
                //TemplateMasterModel objTemplateMasterModel = new TemplateMasterModel();
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return Json(new
                    {
                        status = statusFlag,
                        Message = ErrorDictionary
                    }, JsonRequestBehavior.AllowGet);
                }
                using (var objTemplateMasterSL = new TemplateMasterSL())
                {
                    bool result = objTemplateMasterSL.Delete(objLoginUserDetails.CompanyDBConnectionString, TemplateMasterId, objLoginUserDetails.LoggedInUserID);
                }
                // return RedirectToAction("Index", "TemplateMaster",new {acid = ConstEnum.UserActions.TEMPLATE_LIST_RIGHT });
                statusFlag = true;
                ErrorDictionary.Add("success", Common.Common.getResource("tra_msg_16175"));
            }
            catch (Exception exp)
            {
                //string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                //ModelState.AddModelError("Error", sErrMessage);
                TemplateMasterModel objTemplateMasterModel = new TemplateMasterModel();
                List<PopulateComboDTO> lstList = new List<PopulateComboDTO>();

                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.RoleStatus, null, null, null, null, true);
                ViewBag.TemplateStatus = lstList;

                //get list of communication mode
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.CommunicationModes, null, null, null, null, true);
                ViewBag.CommunicationMode = lstList;

                //get list of disclousre type
                lstList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.DisclosureType, null, null, null, null, true);
                ViewBag.DisclosureType = lstList;

                lstList = null;
                FillGrid(ConstEnum.GridType.TemplateMasteList, null, null, null);

                // return View("View", objTemplateMasterModel);
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
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion Delete

        #region Cancel Button Action
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Button(ButtonName = "Cancel")]
        [ActionName("SaveAction")]
        public ActionResult Cancel(string calledFrom)
        {
            if (calledFrom == "CommunicationRule" || calledFrom == "Communication")
            {
                return RedirectToAction("Index", "CommunicationRuleMaster", new { acid = ConstEnum.UserActions.COMMUNICATION_RULES_LIST_RIGHT });
            }
            else
            {
                return RedirectToAction("Index", "TemplateMaster", new { acid = ConstEnum.UserActions.TEMPLATE_LIST_RIGHT });
            }

        }
        #endregion Cancel Button Action

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
                    i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, "usr_msg_").ToList<PopulateComboDTO>());

                objPopulateComboDTO = null;
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

        #region GetModelStateErrorsAsString
        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }
        #endregion GetModelStateErrorsAsString
        #endregion Private Method

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }

    }
}
