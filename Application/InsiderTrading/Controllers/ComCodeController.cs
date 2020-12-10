using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading.Models;
using InsiderTradingDAL;
using InsiderTrading.Common;
using InsiderTrading.SL;
using InsiderTrading.Filters;
using System.ComponentModel;
using System.Collections;
using System.Web.Routing;


namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class ComCodeController : Controller
    {
        const string sLookUpPrefix = "mst_msg_";

        #region Index
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid, string CodeGroupId, int ParentCodeId)
        {
            ComCodeModel objComCodeModel = null;
            PopulateComboDTO objPopulateComboDTO = null;
            LoginUserDetails objLoginUserDetails = null;
            List<PopulateComboDTO> lstCodeGroup = null;

            try
            {
                ViewBag.GridType = ConstEnum.GridType.ComCodeList;
                ViewBag.Param1 = null;

                objComCodeModel = new ComCodeModel();
                objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0-0";
                objPopulateComboDTO.Value = "Select";
                ViewBag.CalledFrom = "List";

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                lstCodeGroup = new List<PopulateComboDTO>();
                lstCodeGroup.Add(objPopulateComboDTO);
                lstCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                    null, null, null, null, null, sLookUpPrefix));

                objComCodeModel.ParentCodeId = 0;
                if (CodeGroupId != null && CodeGroupId != "0-0")
                {
                    string[] arr = new String[2];
                    arr = CodeGroupId.Split(new string[] { "-" }, StringSplitOptions.None);
                    if (Convert.ToInt32(arr[1]) != 0)
                    {
                        objComCodeModel.ParentCodeId = ParentCodeId;
                        ViewBag.pcid = ParentCodeId;

                    }
                    else
                    {
                        objComCodeModel.ParentCodeId = 0;
                        ViewBag.pcid = 0;
                    }
                    ViewBag.CalledFrom = "SaveCancleDetails";
                }
                objComCodeModel.CodeGroupId = CodeGroupId;
                ViewBag.CodeGroupDropDown = lstCodeGroup;
                ViewBag.ParentCodeName = null;
                ViewBag.CodeGroupId = "0";

                ViewBag.UserAction = acid;
            }
            finally
            {
                objComCodeModel = null;
                objPopulateComboDTO = null;
                objLoginUserDetails = null;
                lstCodeGroup = null;
            }
            
            return View("Index", objComCodeModel);
        }
        #endregion Index

        #region BackToIndex
        [AuthorizationPrivilegeFilter]
        public ActionResult BackToIndex(int acid,string sCodeGroupId,string nParentId)
        {
            ComCodeModel objComCodeModel = null;
            PopulateComboDTO objPopulateComboDTO = null;
            LoginUserDetails objLoginUserDetails = null;
            List<PopulateComboDTO> lstCodeGroup = null;
            try
            {
                ViewBag.GridType = ConstEnum.GridType.ComCodeList;
                ViewBag.Param1 = null;
                
                objComCodeModel = new ComCodeModel();

                objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                lstCodeGroup = new List<PopulateComboDTO>();
                lstCodeGroup.Add(objPopulateComboDTO);
                lstCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                    null, null, null, null, null, sLookUpPrefix));

                ViewBag.CodeGroupDropDown = lstCodeGroup;
                ViewBag.ParentCodeName = null;
                objComCodeModel.CodeGroupId = sCodeGroupId;
                objComCodeModel.ParentCodeId = Convert.ToInt32(nParentId);
                ViewBag.CodeGroupId = "0";
            }
            finally
            {
                objComCodeModel = null;
                objPopulateComboDTO = null;
                objLoginUserDetails = null;
                lstCodeGroup = null;
            }

            return View("Index");
        }
        #endregion BackToIndex

        #region AddSingleCode
        [AuthorizationPrivilegeFilter]
        public ActionResult AddSingleCode(string CodeGroupId, int acid)
        {
            ComCodeModel objComCodeModel = null;
            PopulateComboDTO objPopulateComboDTO = null;
            LoginUserDetails objLoginUserDetails = null;

            List<PopulateComboDTO> lstCodeGroup = null;
            try
            {
                ViewBag.GridType = ConstEnum.GridType.ComCodeList;
                ViewBag.Param1 = null;

                objComCodeModel = new ComCodeModel();
                objPopulateComboDTO = new PopulateComboDTO();

                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                lstCodeGroup = new List<PopulateComboDTO>();
                lstCodeGroup.Add(objPopulateComboDTO);
                lstCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                    null, null, null, null, null, sLookUpPrefix));

                ViewBag.CodeGroupDropDown = lstCodeGroup;
                ViewBag.ParentCodeName = null;
                objComCodeModel.CodeGroupId = CodeGroupId;
                ViewBag.CodeGroupId = CodeGroupId;
            }
            finally
            {
                objPopulateComboDTO = null;
                objLoginUserDetails = null;

                lstCodeGroup = null;
            }
            
            return View("Index");
        }
        #endregion AddSingleCode       

        #region Create
        [HttpGet]
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(string CodeGroupId, int ParentCodeId, int acid, string frm = "", int pdid = 0, string view = "")
        {
            ComCodeModel objComCodeModel = null;
            PopulateComboDTO objPopulateComboDTO = null;
            ComCodeDTO objComCodeDTO = null;

            LoginUserDetails objLoginUserDetails = null;

            List<PopulateComboDTO> lstParentCodeGroup = null;
            List<PopulateComboDTO> lstLabelForParent = null;
            List<PopulateComboDTO> CodeName = null;
            List<PopulateComboDTO> lstCodeGroup = null;

            try
            {
                bool backToPolicyDocument = false;

                string ParentLabel = "";
                objComCodeModel = new ComCodeModel();
                objPopulateComboDTO = new PopulateComboDTO();

                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                ViewBag.GridType = ConstEnum.GridType.ComCodeList;

                objComCodeDTO = new ComCodeDTO();

                string[] arr = new String[2];
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                objComCodeDTO.CodeGroupId = CodeGroupId;
                arr = CodeGroupId.Split(new string[] { "-" }, StringSplitOptions.None);

                if (arr[1] != "0")
                {
                    objComCodeModel.ParentCodeId = ParentCodeId;
                    objComCodeDTO.ParentCodeId = ParentCodeId;
                    ViewBag.ParentCodeId = ParentCodeId;

                    objPopulateComboDTO.Key = "0";
                    objPopulateComboDTO.Value = "Select";

                    lstParentCodeGroup = new List<PopulateComboDTO>();
                    lstParentCodeGroup.Add(objPopulateComboDTO);
                    lstParentCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                        arr[1], null, null, null, null, sLookUpPrefix));

                    lstLabelForParent = new List<PopulateComboDTO>();
                    lstLabelForParent.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                        null, arr[1], null, null, null, sLookUpPrefix));

                    ParentLabel = lstLabelForParent.ElementAt<PopulateComboDTO>(0).Value;
                    if (ParentLabel.Contains("Master"))
                    {
                        ParentLabel = ParentLabel.Substring(0, (ParentLabel.Length - 7));
                    }

                    ViewBag.ParentCodeName = lstParentCodeGroup;

                    using (ComCodeSL objComCodeSL = new ComCodeSL())
                    {
                        objComCodeDTO = objComCodeSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, ParentCodeId);
                        ViewBag.ParentName = objComCodeDTO.CodeName;
                    }
                }
                else
                {
                    objComCodeDTO.CodeGroupId = CodeGroupId;
                    objComCodeDTO.ParentCodeId = ParentCodeId;
                    ViewBag.ParentCodeName = null;
                }

                CodeName = new List<PopulateComboDTO>();
                CodeName.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                    null, arr[0], null, null, null, sLookUpPrefix));
                ViewBag.CodeName = CodeName.ElementAt<PopulateComboDTO>(0).Value;


                ViewBag.ParentLabel = ParentLabel;
                lstCodeGroup = new List<PopulateComboDTO>();
                lstCodeGroup.Add(objPopulateComboDTO);
                lstCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                    null, null, null, null, null, sLookUpPrefix));


                objComCodeModel.CodeGroupId = CodeGroupId;
                objComCodeModel.ParentCodeId = ParentCodeId;
                if (objComCodeModel.ParentCodeId == null || objComCodeModel.ParentCodeId == 0)
                {
                    objComCodeModel.ParentCodeId = 0;
                }
                ViewBag.CodeGroupDropDown = lstCodeGroup;

                //check "frm" variable is set or not to check if oringial requrest came from policy document page to create policy document category 
                if (frm != "" && frm == "pdcategory")
                {
                    backToPolicyDocument = true;
                    ViewBag.PolicyDocument_id = pdid;
                    ViewBag.PolicyDocument_view = view;
                }
                ViewBag.frm = frm;
                ViewBag.backToPolicyDocument = backToPolicyDocument;

                ViewBag.UserAction = acid;

                if (frm != "" && frm == "pdcategory")
                {
                    return PartialView("Create", objComCodeModel);
                }
                else
                {
                    return View("Create", objComCodeModel);
                }
            }
            finally
            {
                objPopulateComboDTO = null;
                objComCodeDTO = null;

                objLoginUserDetails = null;

                lstParentCodeGroup = null;
                lstLabelForParent = null;
                CodeName = null;
                lstCodeGroup = null;
            }
        }

        
        [HttpPost]
        [Button(ButtonName = "Create")]
        [ActionName("Create")]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(ComCodeModel objComCodeModel, int acid, bool backpd = false, int pdid = 0, string view = "", string frm = "")
        {
            string sCodeGroupID = "";
            string sParentCodeId = "";

            bool backToPolicyDocument = false;

            LoginUserDetails objLoginUserDetails = null;
            ComCodeDTO objComCodeDTO = null;
            PopulateComboDTO objPopulateComboDTO = null;

            ArrayList lst = null;
            List<PopulateComboDTO> lstLabelForParent = null;
            List<PopulateComboDTO> CodeName = null;
            List<PopulateComboDTO> lstParentCodeGroup = null;
            try
            {
                string[] arr = new String[2];
                sCodeGroupID = objComCodeModel.CodeGroupId;

                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                objComCodeDTO = new ComCodeDTO();

                if (objComCodeModel.CodeID == null)
                {
                    objComCodeModel.CodeID = 0;
                }
                arr = objComCodeModel.CodeGroupId.Split(new string[] { "-" }, StringSplitOptions.None);
                objComCodeModel.CodeGroupId = arr[0];
                sParentCodeId = arr[1];

                Common.Common.CopyObjectPropertyByName(objComCodeModel, objComCodeDTO);
                
                objComCodeDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;

                using (ComCodeSL objComCodeSL = new ComCodeSL())
                {
                    objComCodeDTO = objComCodeSL.Save(objLoginUserDetails.CompanyDBConnectionString, objComCodeDTO);
                }
                
                if (objComCodeModel.ParentCodeId == 0 || objComCodeModel.ParentCodeId == null)
                {
                    objComCodeModel.CodeGroupId = objComCodeModel.CodeGroupId + "-" + 0;
                }
                else
                {
                    string ParentCodeId = objComCodeDTO.ParentCodeId.ToString().Substring(0, 3);
                    objComCodeModel.CodeGroupId = objComCodeModel.CodeGroupId + "-" + ParentCodeId;
                }

                lst = new ArrayList();
                lst.Add(objComCodeModel.CodeName);
                string msg = objComCodeModel.CodeName + " " +  Common.Common.getResource("mst_msg_10047");

                //check if back to policy document id flag is set or not to check if oringial requrest came from policy document page to create policy document category 
                if (backpd)
                {
                    string view_name = "";
                    string contorller_name = "PolicyDocuments";
                    RouteValueDictionary controller_paramter = new RouteValueDictionary();

                    if (pdid == 0)
                    {
                        view_name = "Create";

                        controller_paramter.Add("acid", Common.ConstEnum.UserActions.POLICY_DOCUMENT_CREATE);
                    }
                    else if (pdid > 0)
                    {
                        view_name = "Edit";

                        controller_paramter.Add("acid", Common.ConstEnum.UserActions.POLICY_DOCUMENT_EDIT);
                        controller_paramter.Add("pdid", pdid);
                        controller_paramter.Add("view", view);
                    }
                    else
                    {
                        view_name = "index";

                        controller_paramter.Add("acid", Common.ConstEnum.UserActions.RULES_POLICY_DOCUMENT_LIST);
                    }

                    msg = "Policy Document Category " + objComCodeModel.CodeName + " Created Sucessfully";

                    if (frm != "" && frm == "pdcategory")
                    {
                        return Json(new
                        {
                            status = true,
                            Message = msg,
                            CodeGroupId = objComCodeDTO.CodeGroupId,
                            CodeID = objComCodeDTO.CodeID,
                            DisplayCode = ((objComCodeDTO.DisplayCode != null && objComCodeDTO.DisplayCode != "") ? objComCodeDTO.DisplayCode : objComCodeDTO.CodeName),
                            IsActive = objComCodeDTO.IsActive,
                            IsVisible = objComCodeDTO.IsVisible,
                            ParentCodeId = objComCodeDTO.ParentCodeId
                        }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return RedirectToAction(view_name, contorller_name, controller_paramter).Success(msg);
                    }
                }
                if (frm != "" && frm == "pdcategory")
                {
                    return Json(new
                    {
                        status = true,
                        Message = Common.Common.getResource("tra_msg_16153"),
                        CodeGroupId = objComCodeModel.CodeGroupId,
                        ParentCodeId = objComCodeModel.ParentCodeId

                    }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return RedirectToAction("Index", "ComCode", new { acid = Common.ConstEnum.UserActions.OTHERMASTER_COMCODE_VIEW, CodeGroupId = objComCodeModel.CodeGroupId, ParentCodeId = objComCodeModel.ParentCodeId }).Success(msg);
                }
            }
            catch(Exception exp)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();

                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                string ParentLabel = "";

                if (frm != "" && frm == "pdcategory")
                { 
                    return Json(new
                    {
                        status = false,
                        error = ModelState.ToSerializedDictionary(),
                        Message = sErrMessage
                    }, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                    objPopulateComboDTO = new PopulateComboDTO();
                    objPopulateComboDTO.Key = "0";
                    objPopulateComboDTO.Value = "Select";
                    if (objComCodeModel.ParentCodeId != null && objComCodeModel.ParentCodeId != 0)
                    {
                        ViewBag.ParentCodeId = objComCodeModel.ParentCodeId;
                        objPopulateComboDTO.Key = "0";
                        objPopulateComboDTO.Value = "Select";

                        lstParentCodeGroup = new List<PopulateComboDTO>();
                        lstParentCodeGroup.Add(objPopulateComboDTO);
                        lstParentCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                            sParentCodeId, null, null, null, null, sLookUpPrefix));

                        lstLabelForParent = new List<PopulateComboDTO>();
                        lstLabelForParent.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                            null, sParentCodeId, null, null, null, sLookUpPrefix));

                        ParentLabel = lstLabelForParent.ElementAt<PopulateComboDTO>(0).Value;
                        if (ParentLabel.Contains("Master"))
                        {
                            ParentLabel = ParentLabel.Substring(0, (ParentLabel.Length - 7));
                        }

                        ViewBag.ParentCodeName = lstParentCodeGroup;

                        using (ComCodeSL objComCodeSL = new ComCodeSL())
                        {
                            objComCodeDTO = objComCodeSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objComCodeModel.ParentCodeId));

                            ViewBag.ParentName = objComCodeDTO.CodeName;
                        }
                    }
                    else
                    {
                        ViewBag.ParentCodeName = null;
                    }
                    
                    CodeName = new List<PopulateComboDTO>();
                    CodeName.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                        null, Convert.ToString(objComCodeModel.CodeGroupId), null, null, null, sLookUpPrefix));
                    ViewBag.CodeName = CodeName.ElementAt<PopulateComboDTO>(0).Value;


                    objComCodeModel.CodeGroupId = sCodeGroupID;
                    ViewBag.ParentLabel = ParentLabel;


                    if (objComCodeModel.ParentCodeId == null || objComCodeModel.ParentCodeId == 0)
                    {
                        objComCodeModel.ParentCodeId = 0;
                    }

                    //check if back to policy document id flag is set or not to check if oringial requrest came from policy document page to create policy document category 
                    if (backpd)
                    {
                        backToPolicyDocument = true;
                        ViewBag.PolicyDocument_id = pdid;
                        ViewBag.PolicyDocument_view = view;
                    }

                    ViewBag.backToPolicyDocument = backToPolicyDocument;
                    ViewBag.UserAction = acid;
                    return View("Create", objComCodeModel);
                }
            }
            finally
            {
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
                objComCodeDTO = null;

                lst = null;
                lstLabelForParent = null;
                CodeName = null;
                lstParentCodeGroup = null;
            }
        }
        #endregion Create

        #region Edit
        [AuthorizationPrivilegeFilter]
        public ActionResult Edit(int CodeId, int acid, string CalledFrom)
        {
            LoginUserDetails objLoginUserDetails = null;
            ComCodeModel objComCodeModel = null;
            
            PopulateComboDTO objPopulateComboDTO = null;
            ComCodeDTO objComCodeDTO = null;
            ComCodeDTO objComCodeDTO1 = null;
            string ParentLabel = "";

            List<PopulateComboDTO> CodeName = null;
            List<PopulateComboDTO> lstParentCodeGroup = null;
            List<PopulateComboDTO> lstLabelForParent = null;
            List<PopulateComboDTO> lstCodeGroup = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                objComCodeModel = new ComCodeModel();
                objPopulateComboDTO = new PopulateComboDTO();

                using (ComCodeSL objComCodeSL = new ComCodeSL())
                {
                    objComCodeDTO = objComCodeSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, CodeId);

                    CodeName = new List<PopulateComboDTO>();

                    CodeName.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                        null, objComCodeDTO.CodeGroupId, null, null, null, sLookUpPrefix));

                    ViewBag.CodeName = CodeName.ElementAt<PopulateComboDTO>(0).Value;

                    if (objComCodeDTO.ParentCodeId != null && objComCodeDTO.ParentCodeId != 0)
                    {
                        objComCodeDTO1 = objComCodeSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objComCodeDTO.ParentCodeId));
                        ViewBag.ParentName = objComCodeDTO1.CodeName;
                        string ParentCodeId = objComCodeDTO.ParentCodeId.ToString().Substring(0, 3);

                        objComCodeDTO.CodeGroupId = objComCodeDTO.CodeGroupId + "-" + ParentCodeId;
                        objPopulateComboDTO.Key = "0";
                        objPopulateComboDTO.Value = "Select";

                        lstParentCodeGroup = new List<PopulateComboDTO>();
                        lstParentCodeGroup.Add(objPopulateComboDTO);
                        lstParentCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                        ParentCodeId, null, null, null, null, sLookUpPrefix));

                        ViewBag.ParentCodeName = lstParentCodeGroup;

                        lstLabelForParent = new List<PopulateComboDTO>();
                        lstLabelForParent.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                            null, ParentCodeId, null, null, null, sLookUpPrefix));

                        ParentLabel = lstLabelForParent.ElementAt<PopulateComboDTO>(0).Value;
                        if (ParentLabel.Contains("Master"))
                        {
                            ParentLabel = ParentLabel.Substring(0, (ParentLabel.Length - 7));
                        }
                    }
                    else
                    {
                        objComCodeDTO.CodeGroupId = objComCodeDTO.CodeGroupId + "-" + 0;
                        objComCodeDTO.ParentCodeId = 0;
                    }
                }

                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";
                ViewBag.ParentLabel = ParentLabel;
                
                lstCodeGroup = new List<PopulateComboDTO>();
                lstCodeGroup.Add(objPopulateComboDTO);
                lstCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                    null, null, null, null, null, sLookUpPrefix));

                ViewBag.CodeGroupDropDown = lstCodeGroup;

                ViewBag.UserAction = acid;

                if (objComCodeDTO != null)
                {
                    Common.Common.CopyObjectPropertyByName(objComCodeDTO, objComCodeModel);

                    ViewBag.ParentId = objComCodeDTO.ParentCodeId;
                    return View("Create", objComCodeModel);
                }
            }
            finally
            {
                objLoginUserDetails = null;

                objPopulateComboDTO = null;
                objComCodeDTO = null;
                objComCodeDTO1 = null;

                CodeName = null;
                lstParentCodeGroup = null;
                lstLabelForParent = null;
                lstCodeGroup = null;
            }

            return View("Create");
        }

        #endregion Edit

        #region Delete
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [Button(ButtonName = "DeleteCode")]
        [ActionName("Create")]
        [AuthorizationPrivilegeFilter]
        public ActionResult DeleteCode(ComCodeModel objComCodeModel,int acid)//int CodeID, int ParentCodeId, string CodeGroupId, int acid)
        {
            bool bReturn = false;
            //int CodeID = 0;

            LoginUserDetails objLoginUserDetails = null;

          //  ComCodeModel objComCodeModel = null;
            PopulateComboDTO objPopulateComboDTO = null;
            ComCodeDTO objComCodeDTO = null;

            List<PopulateComboDTO> lstParentCodeGroup = null;
            List<PopulateComboDTO> lstLabelForParent = null;
            List<PopulateComboDTO> lstCodeGroup = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                string msg = "";

                using (ComCodeSL objComCodeSL = new ComCodeSL())
                {
                    bReturn = objComCodeSL.Delete(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID,Convert.ToInt32(objComCodeModel.CodeID));
                    ArrayList lst = new ArrayList();
                    msg = Common.Common.getResource("mst_msg_10048");
                }

                return RedirectToAction("Index", "ComCode", new { acid = Common.ConstEnum.UserActions.OTHERMASTER_COMCODE_VIEW, CodeGroupId = objComCodeModel.CodeGroupId, ParentCodeId = objComCodeModel.ParentCodeId }).Success(msg);
            }
            catch(Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());

                ModelState.AddModelError("Error", sErrMessage);
                string ParentLabel = "";

                objComCodeDTO = new ComCodeDTO();
               // objComCodeModel = new ComCodeModel();
                
                objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                ViewBag.GridType = ConstEnum.GridType.ComCodeList;

                
                string[] arr = new String[2];
                
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                
                //objComCodeDTO.CodeGroupId = CodeGroupId;
                arr = objComCodeModel.CodeGroupId.Split(new string[] { "-" }, StringSplitOptions.None);
                if (arr[1] != "0")
                {
                   // objComCodeModel.ParentCodeId = ParentCodeId;
                    //objComCodeDTO.ParentCodeId = ParentCodeId;
                     ViewBag.ParentCodeId = objComCodeModel.ParentCodeId;
                    
                    objPopulateComboDTO.Key = "0";
                    objPopulateComboDTO.Value = "Select";

                    lstParentCodeGroup = new List<PopulateComboDTO>();
                    lstParentCodeGroup.Add(objPopulateComboDTO);
                    lstParentCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                        arr[1], null, null, null, null, sLookUpPrefix));

                    lstLabelForParent = new List<PopulateComboDTO>();
                    lstLabelForParent.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                        null, arr[1], null, null, null, sLookUpPrefix));

                    ParentLabel = lstLabelForParent.ElementAt<PopulateComboDTO>(0).Value;
                    if (ParentLabel.Contains("Master"))
                    {
                        ParentLabel = ParentLabel.Substring(0, (ParentLabel.Length - 7));
                    }

                    ViewBag.ParentCodeName = lstParentCodeGroup;
                    objComCodeModel.CodeGroupId = arr[0];                
                }
                else
                {
                    //objComCodeDTO.CodeGroupId = CodeGroupId;
                   // objComCodeDTO.ParentCodeId = ParentCodeId;
                    ViewBag.ParentCodeName = null;
                }

                ViewBag.ParentLabel = ParentLabel;
                lstCodeGroup = new List<PopulateComboDTO>();
                lstCodeGroup.Add(objPopulateComboDTO);
                lstCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                    null, null, null, null, null, sLookUpPrefix));


                //objComCodeModel.CodeGroupId = CodeGroupId;
               // objComCodeModel.ParentCodeId = ParentCodeId;
                if (objComCodeModel.ParentCodeId == null || objComCodeModel.ParentCodeId == 0)
                {
                    objComCodeModel.ParentCodeId = 0;
                }
                ViewBag.CodeGroupDropDown = lstCodeGroup;
                ViewBag.UserAction = acid;
                return View("Create", objComCodeModel);
            }
            finally
            {
                objLoginUserDetails = null;

                objComCodeModel = null;
                objPopulateComboDTO = null;
                objComCodeDTO = null;

                lstParentCodeGroup = null;
                lstLabelForParent = null;
                lstCodeGroup = null;
            }
        }
        #endregion Delete

        #region DeleteFromGrid
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult DeleteFromGrid(int CodeID, int acid)
        {
            bool bReturn = false;
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();

            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                
                using (ComCodeSL objComCodeSL = new ComCodeSL())
                {   
                    bReturn = objComCodeSL.Delete(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, CodeID);
                    statusFlag = true;
                    ErrorDictionary.Add("success", "Record deleted");
                }
            }
            catch(Exception exp)
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

            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion DeleteFromGrid

        #region PopulateCombo_OnChange
           
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        public ActionResult PopulateCombo_OnChange(string CodeId, string CalledFrom, int ParentId, int acid)
        {
            LoginUserDetails objLoginUserDetails = null;

            ComCodeModel objComCodeModel = null;
            PopulateComboDTO objPopulateComboDTO = null;

            List<PopulateComboDTO> lstParentCodeGroup = null;
            List<PopulateComboDTO> lstLabelForParent = null;
            List<PopulateComboDTO> lstCodeGroup = null;

            string sView = string.Empty;
            Common.Common objCommon = new Common.Common();
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return RedirectToAction("Unauthorised", "Home");
                }
                string ParentLabel = "";
                string[] arr = new String[2];

                objComCodeModel = new ComCodeModel();
                objPopulateComboDTO = new PopulateComboDTO();

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                arr = CodeId.Split(new string[] { "-" }, StringSplitOptions.None);

                if (Convert.ToInt32(arr[1]) != 0)
                {
                    objPopulateComboDTO.Key = "0";
                    objPopulateComboDTO.Value = "Select";

                    lstParentCodeGroup = new List<PopulateComboDTO>();
                    lstParentCodeGroup.Add(objPopulateComboDTO);
                    lstParentCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                        arr[1], null, null, null, null, sLookUpPrefix));

                    lstLabelForParent = new List<PopulateComboDTO>();
                    lstLabelForParent.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                        null, arr[1], null, null, null, sLookUpPrefix));

                    ParentLabel = lstLabelForParent.ElementAt<PopulateComboDTO>(0).Value;
                    if (ParentLabel.Contains("Master"))
                    {
                        ParentLabel = ParentLabel.Substring(0, (ParentLabel.Length - 7));
                    }
                    if (CalledFrom == "Details")
                    {
                        ViewBag.ParentCodeName = lstParentCodeGroup;
                        ViewBag.SelectedValue = "0";
                    }
                    else if (CalledFrom == "List")
                    {
                        ViewBag.ParentCodeName = lstParentCodeGroup;
                    }
                }
                lstCodeGroup = new List<PopulateComboDTO>();
                lstCodeGroup.Add(objPopulateComboDTO);
                lstCodeGroup.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.CodeParentList,
                    null, null, null, null, null, sLookUpPrefix));

                objComCodeModel.CodeGroupId = CodeId;

                
                if (CalledFrom == "Details")
                {
                    ViewBag.ParentLabel = ParentLabel;
                    ViewBag.CodeGroupDropDown = lstCodeGroup;
                    sView = "PartialCreate";
                }
                else if (CalledFrom == "List")
                {
                    ViewBag.GridType = ConstEnum.GridType.ComCodeList;
                    if (arr[1] != "0")
                    {
                        ViewBag.ParentLabel = ParentLabel;
                        ViewBag.ParentId = ParentId;
                        objComCodeModel.ParentCodeId = ParentId;
                        ViewBag.CodeGroupDropDown = new SelectList(lstCodeGroup, "Key", "Value");
                        sView = "PartialIndex";
                    }
                    else if (ParentId == 0)
                    {
                        ViewBag.AddNew = 1;
                        sView = "PartialDataGrid";
                    }
                }

                ViewBag.UserAction = acid;
            }
            finally
            {
                objLoginUserDetails = null;

                objPopulateComboDTO = null;

                lstParentCodeGroup = null;
                lstLabelForParent = null;
                lstCodeGroup = null;
            }

            return PartialView(sView, objComCodeModel);
        }
        #endregion PopulateCombo_OnChange

        #region ParentPopulateCombo_OnChange
        
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        public ActionResult ParentPopulateCombo_OnChange(string CodeId, string CalledFrom, int ParentId, int acid)
        {
            Common.Common objCommon = new Common.Common();
            if (!objCommon.ValidateCSRFForAJAX())
            {
                return RedirectToAction("Unauthorised", "Home");
            }
            ViewBag.GridType = ConstEnum.GridType.ComCodeList;
            ViewBag.AddNew = ParentId;

            ViewBag.UserAction = acid;

            return PartialView("PartialDataGrid");
        }
        #endregion ParentPopulateCombo_OnChange

        #region Cancel
        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserInfoId"></param>
        /// <returns></returns>
        ///  
        [HttpPost]
        [Button(ButtonName = "Cancel")]
        [ActionName("Create")]
        public ActionResult Cancel(ComCodeModel objComCodeModel, int acid)
        {
            return RedirectToAction("Index", "ComCode", new { acid = ConstEnum.UserActions.OTHERMASTER_COMCODE_VIEW, CodeGroupId = objComCodeModel.CodeGroupId, ParentCodeId = objComCodeModel.ParentCodeId });
        }
        #endregion Cancel

        #region GetModelStateErrorsAsString
        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }
        #endregion GetModelStateErrorsAsString

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
    }
}


