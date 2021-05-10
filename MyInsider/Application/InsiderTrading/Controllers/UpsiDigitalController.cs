using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class UpsiDigitalController : Controller
    {
        DataTable dtEmailLog = null;
        DataRow DataRow = null;
        #region Index
        /// <summary>
        /// Dropdown Load Data And Gridview Data
        /// </summary>
        /// <returns></returns>
        public ActionResult Index()
        {
            TempData.Remove("ListUpsi");
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            ViewBag.GridType = ConstEnum.GridType.UpsiSharing_data;
            UpsiSharingData nUpsiSharingData = new UpsiSharingData();
            nUpsiSharingData.UserInfoId = objLoginUserDetails.LoggedInUserID;
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "Select";
            List<PopulateComboDTO> lstCategoryList = new List<PopulateComboDTO>();
            lstCategoryList.Add(objPopulateComboDTO);
            lstCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            Convert.ToInt32(ConstEnum.CodeGroup.CategoryOffinancial).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.CategoryDropDown1 = lstCategoryList;

            List<PopulateComboDTO> lstMultipleList = new List<PopulateComboDTO>();
            lstMultipleList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.Listofmultipleuser,
            null, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.Listofmultipleuser = lstMultipleList;

            List<PopulateComboDTO> lstReasonList = new List<PopulateComboDTO>();
            lstReasonList.Add(objPopulateComboDTO);
            lstReasonList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            Convert.ToInt32(ConstEnum.CodeGroup.ReasonforSharing).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.ReasonDropDown = lstReasonList;

            List<PopulateComboDTO> lstModeOfSharingListt = new List<PopulateComboDTO>();
            lstModeOfSharingListt.Add(objPopulateComboDTO);
            lstModeOfSharingListt.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            Convert.ToInt32(ConstEnum.CodeGroup.ModeOfSharing).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.ModeOfSharing = lstModeOfSharingListt;
            return View(nUpsiSharingData);
        }
        #endregion Index

        #region Create
        /// <summary>
        /// This method fill sharing info
        /// </summary>
        /// <returns></returns>
        public ActionResult Create()
        {
            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "Select";
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            UpsiSharingData nUpsiSharingData = new UpsiSharingData();

            List<PopulateComboDTO> lstCategoryList = new List<PopulateComboDTO>();
            lstCategoryList.Add(objPopulateComboDTO);
            lstCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            Convert.ToInt32(ConstEnum.CodeGroup.CategoryOffinancial).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.CategoryDropDown = lstCategoryList;

            List<PopulateComboDTO> lstReasonList = new List<PopulateComboDTO>();
            lstReasonList.Add(objPopulateComboDTO);
            lstReasonList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            Convert.ToInt32(ConstEnum.CodeGroup.ReasonforSharing).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.ReasonDropDown = lstReasonList;

            List<PopulateComboDTO> lstModeOfSharingList = new List<PopulateComboDTO>();
            lstModeOfSharingList.Add(objPopulateComboDTO);
            lstModeOfSharingList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            Convert.ToInt32(ConstEnum.CodeGroup.ModeOfSharing).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.ModeOfSharing = lstModeOfSharingList;

            List<PopulateComboDTO> lstMultipleList = new List<PopulateComboDTO>();
            lstMultipleList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.Listofmultipleuser,
            null, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());

            ViewBag.Listofmultipleuser = lstMultipleList;
            UpsiDTO objUpsiTempAutoId = null;
            using (var objUpsiAutoIDSL = new UpsiSL())
            {
                objUpsiTempAutoId = objUpsiAutoIDSL.GetDocumentAutoID(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                nUpsiSharingData.DocumentNumber = Convert.ToString(objUpsiTempAutoId.DocumentNo);
            }

            List<OtherUsersDetails> OtherUsersDetailsList = new List<OtherUsersDetails>();
            using (var objUserInfoSL = new UserInfoSL())
            {
                OtherUsersDetailsList = objUserInfoSL.GetOtherUserDetailsList(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, "");
            }

            var list = new List<SelectListItem>();
            foreach (var item in OtherUsersDetailsList)
            {
                list.Add(new SelectListItem { Text = item.Email, Value = item.Email });
            }
            ViewBag.OtherUsersDetailsList = list;


            ViewBag.UPSISetting = GetUPSISetting();


            return View("Create", nUpsiSharingData);
        }
        #endregion
        #region Add
        /// <summary>
        /// This method Add All Sharing Information one by one in grid view
        /// </summary>
        /// <param name="objUpsiSharingData"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult Add(UpsiSharingData objUpsiSharingData)
        {



            ModelState.Remove("KEY");
            ModelState.Add("KEY", new ModelState());
            ModelState.Clear();
            UpsiDTO objUpsiTempSharingData = new UpsiDTO();
            UpsiDTO objUpsiSharing = new UpsiDTO();
            bool isError = false; //flag to check for validation error 
            string sMsgDOS = "";
            int sequenceNo = 1;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            ViewBag.IsError = false;
            ViewBag.ModeofSharingIndex = 0;
            var SelectedIndex = -1;

            ViewBag.UPSISetting = GetUPSISetting();
            using (var objUpsiSL = new UpsiSL())
            {
                objUpsiSharing = objUpsiSL.GetUserInfo(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
            }
            UpsiSharingData objdata1 = new UpsiSharingData();
            List<UpsiSharingData> objdata = new List<UpsiSharingData>();

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "Select";

            List<PopulateComboDTO> lstCategoryList = new List<PopulateComboDTO>();
            lstCategoryList.Add(objPopulateComboDTO);
            lstCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            Convert.ToInt32(ConstEnum.CodeGroup.CategoryOffinancial).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.CategoryDropDown = lstCategoryList;

            List<PopulateComboDTO> lstReasonList = new List<PopulateComboDTO>();
            lstReasonList.Add(objPopulateComboDTO);
            lstReasonList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            Convert.ToInt32(ConstEnum.CodeGroup.ReasonforSharing).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.ReasonDropDown = lstReasonList;

            List<PopulateComboDTO> lstModeOfSharingList = new List<PopulateComboDTO>();
            lstModeOfSharingList.Add(objPopulateComboDTO);
            lstModeOfSharingList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            Convert.ToInt32(ConstEnum.CodeGroup.ModeOfSharing).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.ModeOfSharing = lstModeOfSharingList;

            try
            {
                if (objUpsiSharingData.SharingDate != null)
                {
                    DateTime current_date = Common.Common.GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);

                    //check and validate date of joining and date of becoming insider
                    if (objUpsiSharingData.SharingDate > current_date)
                    {
                        if (TempData["ListUpsi"] != null)
                        {
                            var oldList = (List<UpsiSharingData>)TempData.Peek("ListUpsi");
                            objdata.AddRange(oldList);
                        }
                        sMsgDOS = Common.Common.getResource("usr_msg_55063"); // "Date of Sharing should not be greater than today's date";
                        isError = true;

                    }
                    else
                    {
                        if (TempData["ListUpsi"] != null)
                        {
                            var oldList = (List<UpsiSharingData>)TempData.Peek("ListUpsi");
                            objdata.AddRange(oldList);
                        }
                        if (objUpsiSharingData.SequenceNo != 0)
                        {
                            var item = objdata.FirstOrDefault(x => x.SequenceNo == objUpsiSharingData.SequenceNo);
                            if (item != null)
                                objdata.Remove(item);
                            TempData["List"] = objUpsiSharingData;
                            TempData.Keep();
                        }
                        if (objUpsiSharingData.Listofmultipleuser != null)
                        {
                            if (objUpsiSharingData.Listofmultipleuser[0] != 0)
                            {
                                foreach (var UserInfoId in objUpsiSharingData.Listofmultipleuser)
                                {
                                    if (UserInfoId != 0)
                                    {
                                        using (var objUpsiSL = new UpsiSL())
                                        {
                                            UpsiSharingData objUpsiSharingDataTable = new UpsiSharingData();

                                            objUpsiTempSharingData = objUpsiSL.GetUserInfo(objLoginUserDetails.CompanyDBConnectionString, UserInfoId);
                                            objUpsiSharingDataTable.PAN = objUpsiTempSharingData.PAN;

                                            objUpsiSharingDataTable.Phone = objUpsiTempSharingData.MobileNumber;
                                            objUpsiSharingDataTable.Company_Name = objUpsiTempSharingData.CompanyName;
                                            objUpsiSharingDataTable.Company_Address = objUpsiTempSharingData.Address;
                                            objUpsiSharingDataTable.E_mail = objUpsiTempSharingData.EmailId;
                                            if (objLoginUserDetails.UserTypeCodeId == 101004)
                                            {
                                                if (string.IsNullOrEmpty(Convert.ToString(objUpsiTempSharingData.FirstName).Trim()))
                                                {
                                                    objUpsiSharingDataTable.Name = objUpsiTempSharingData.ContactPerson;
                                                }
                                                else
                                                {
                                                    objUpsiSharingDataTable.Name = objUpsiTempSharingData.FirstName;
                                                }
                                                if (objUpsiSharingData.Sharedbyo == "True")
                                                {
                                                    if (objLoginUserDetails.UserTypeCodeId == 101004)
                                                    {
                                                        objUpsiSharingDataTable.Sharedby = objUpsiSharing.ContactPerson;
                                                    }
                                                    else
                                                    {
                                                        objUpsiSharingDataTable.Sharedby = objLoginUserDetails.FirstName;
                                                    }
                                                    objUpsiSharingDataTable.UserInfoId = objLoginUserDetails.LoggedInUserID;
                                                }
                                                else
                                                {
                                                    objUpsiSharingDataTable.Sharedby = objUpsiSharingData.Sharedbynamea;
                                                    //objUpsiSharingDataTable.UserInfoId = objLoginUserDetails.LoggedInUserID;
                                                }
                                                objUpsiSharingDataTable.UserInfoId = objLoginUserDetails.LoggedInUserID;

                                            }
                                            else
                                            {
                                                if (string.IsNullOrEmpty(Convert.ToString(objUpsiTempSharingData.FirstName).Trim()))
                                                {
                                                    objUpsiSharingDataTable.Name = objUpsiTempSharingData.ContactPerson;
                                                }
                                                else
                                                {
                                                    objUpsiSharingDataTable.Name = objUpsiTempSharingData.FirstName;
                                                }

                                                if (objUpsiSharingData.Sharedbyo == "True")
                                                {
                                                    if (objLoginUserDetails.UserTypeCodeId == 101004)
                                                    {
                                                        objUpsiSharingDataTable.Sharedby = objUpsiSharing.ContactPerson;
                                                    }
                                                    else
                                                    {
                                                        objUpsiSharingDataTable.Sharedby = objLoginUserDetails.FirstName;
                                                    }
                                                    objUpsiSharingDataTable.UserInfoId = objLoginUserDetails.LoggedInUserID;
                                                }
                                                else
                                                {
                                                    objUpsiSharingDataTable.Sharedby = objUpsiSharingData.Sharedbynamea;
                                                    //objUpsiSharingDataTable.UserInfoId = objLoginUserDetails.LoggedInUserID;
                                                }
                                                //objUpsiSharingDataTable.Sharedby = objLoginUserDetails.FirstName;

                                                objUpsiSharingDataTable.UserInfoId = objLoginUserDetails.LoggedInUserID;
                                            }
                                            objUpsiSharingDataTable.SharingDate = objUpsiSharingData.SharingDate;
                                            objUpsiSharingDataTable.Comments = objUpsiSharingData.Comments;
                                            objUpsiSharingDataTable.Category_Shared = objUpsiSharingData.Category_Shared;
                                            objUpsiSharingDataTable.Reason_sharing = objUpsiSharingData.Reason_sharing;
                                            objUpsiSharingDataTable.ModeOfSharing = objUpsiSharingData.ModeOfSharing;
                                            objUpsiSharingDataTable.Time = objUpsiSharingData.Time;
                                            objUpsiSharingDataTable.DocumentNumber = objUpsiSharingData.DocumentNumber;
                                            objUpsiSharingDataTable.UserInfoId = objLoginUserDetails.LoggedInUserID;
                                            objUpsiSharingDataTable.PublishDate = objUpsiSharingData.PublishDate;
                                            objUpsiSharingDataTable.CHKUserAndOther = objUpsiSharingData.CHKUserAndOther;
                                            objUpsiSharingDataTable.UPSIRecipient = objUpsiSharingData.CHKUserAndOther == "True" ? "Register User" : "Unregister User";
                                            foreach (var type in lstCategoryList)
                                            {
                                                if (type.Key == objUpsiSharingData.Category_Shared.ToString())
                                                {
                                                    objUpsiSharingData.Category_Shared1 = type.Value;
                                                    objUpsiSharingDataTable.Category_Shared1 = type.Value;
                                                }
                                            }

                                            foreach (var type in lstReasonList)
                                            {
                                                if (type.Key == objUpsiSharingData.Reason_sharing.ToString())
                                                {
                                                    objUpsiSharingData.Reason_sharingdata = type.Value;
                                                    objUpsiSharingDataTable.Reason_sharingdata = type.Value;
                                                }
                                            }

                                            foreach (var type in lstModeOfSharingList)
                                            {
                                                SelectedIndex = SelectedIndex + 1;
                                                if (type.Key == objUpsiSharingData.ModeOfSharing.ToString())
                                                {
                                                    objUpsiSharingData.ModeOfSharingdata = type.Value;
                                                    objUpsiSharingDataTable.ModeOfSharingdata = type.Value;
                                                    ViewBag.ModeofSharingIndex = SelectedIndex;
                                                    break;
                                                }
                                            }

                                            objdata.Add(objUpsiSharingDataTable);
                                        }
                                    }

                                }
                            }
                        }
                        else
                        {
                            objUpsiSharingData.UPSIRecipient = objUpsiSharingData.CHKUserAndOther == "True" ? "Register User" : "Unregister User";
                            foreach (var type in lstCategoryList)
                            {
                                if (type.Key == objUpsiSharingData.Category_Shared.ToString())
                                {
                                    objUpsiSharingData.Category_Shared1 = type.Value;
                                }
                            }

                            foreach (var type in lstReasonList)
                            {
                                if (type.Key == objUpsiSharingData.Reason_sharing.ToString())
                                {
                                    objUpsiSharingData.Reason_sharingdata = type.Value;
                                }
                            }

                            foreach (var type in lstModeOfSharingList)
                            {
                                SelectedIndex = SelectedIndex + 1;
                                if (type.Key == objUpsiSharingData.ModeOfSharing.ToString())
                                {
                                    objUpsiSharingData.ModeOfSharingdata = type.Value;
                                    ViewBag.ModeofSharingIndex = SelectedIndex;
                                    break;
                                }
                            }

                            objdata.Add(objUpsiSharingData);

                            if (objUpsiSharingData.Sharedby == "True")
                            {
                                if (objLoginUserDetails.UserTypeCodeId == 101004)
                                {
                                    objUpsiSharingData.Sharedby = objUpsiSharing.ContactPerson;
                                }
                                else
                                {
                                    objUpsiSharingData.Sharedby = objLoginUserDetails.FirstName;
                                }
                                objUpsiSharingData.UserInfoId = objLoginUserDetails.LoggedInUserID;
                            }
                            else
                            {
                                objUpsiSharingData.Sharedby = objUpsiSharingData.Sharedbyname;
                                objUpsiSharingData.UserInfoId = objLoginUserDetails.LoggedInUserID;
                            }

                        }
                    }
                }
                if (isError)
                {
                    ModelState.Remove("KEY");
                    ModelState.Add("KEY", new ModelState());
                    ModelState.Clear();
                    if (sMsgDOS != "")
                    {
                        ModelState.AddModelError("Error", sMsgDOS);
                    }
                    if (TempData["ListUpsi"] != null)
                    {
                        ViewBag.IsError = false;
                    }
                    if (!ModelState.IsValid)
                    {
                        ViewBag.IsError = true;
                    }
                }
                sequenceNo = Convert.ToInt32(TempData["SequenceNo"]);
                objUpsiSharingData.SequenceNo = (sequenceNo == 0) ? 1 : sequenceNo + 1;
                TempData["SequenceNo"] = objUpsiSharingData.SequenceNo;

                List<PopulateComboDTO> lstMultipleList = new List<PopulateComboDTO>();
                lstMultipleList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.Listofmultipleuser,
                null, null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());

                ViewBag.Listofmultipleuser = lstMultipleList;
                TempData["ListUpsi"] = objdata;
                ViewBag.GridAllow = true;
                return View("Create", objUpsiSharingData);
            }
            catch (Exception exp)
            {

            }
            finally
            {
                //TempData.Remove("ListUpsi");
            }

            return View("Create");
            TempData.Remove("ListUpsi");
        }
        #endregion


        #region SaveAll
        /// <summary>
        /// This method Save All Sharing info in Database
        /// </summary>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        [HttpPost]
        public ActionResult SaveAll()
        {
            var ErrorDictionary = new Dictionary<string, string>();
            #region set dt column for email log
            dtEmailLog = new DataTable(); ;
            dtEmailLog.Columns.Add("ID", typeof(Int32));
            dtEmailLog.Columns["ID"].AutoIncrement = true;
            dtEmailLog.Columns["ID"].AutoIncrementSeed = 1;
            dtEmailLog.Columns["ID"].ReadOnly = true;
            dtEmailLog.Columns.Add("UserInfoId", typeof(string));
            dtEmailLog.Columns.Add("To", typeof(string));
            dtEmailLog.Columns.Add("CC", typeof(string));
            dtEmailLog.Columns.Add("BCC", typeof(string));
            dtEmailLog.Columns.Add("Subject", typeof(string));
            dtEmailLog.Columns.Add("Contents", typeof(string));
            dtEmailLog.Columns.Add("Signature", typeof(string));
            dtEmailLog.Columns.Add("CommunicationFrom", typeof(string));
            dtEmailLog.Columns.Add("ResponseStatusCodeId", typeof(string));
            dtEmailLog.Columns.Add("ResponseMessage", typeof(string));
            dtEmailLog.Columns.Add("CreatedBy", typeof(string));
            dtEmailLog.Columns.Add("CreatedOn", typeof(string));
            dtEmailLog.Columns.Add("ModifiedBy", typeof(string));
            dtEmailLog.Columns.Add("ModifiedOn", typeof(string));
            #endregion
            string strConfirmMessage = "";
            EmployeeModel objEmployeeModel = new EmployeeModel();
            UpsiSharingData objUpsiSharingData = new UpsiSharingData();
            UpsiDTO obgUpsiTempSharingData = new UpsiDTO();
            List<UpsiSharingData> UpsiSharingData = null;
            if (TempData["ListUpsi"] == null)
            {
                return RedirectToAction("Create", "UpsiDigital");
            }
            else
            {
                UpsiSharingData = (List<UpsiSharingData>)TempData["ListUpsi"];
                DataTable dt = new DataTable();
                dt.Columns.Add(new DataColumn("Company_Name", typeof(string)));
                dt.Columns.Add(new DataColumn("Company_Address", typeof(string)));
                dt.Columns.Add(new DataColumn("Category_Shared", typeof(int)));
                dt.Columns.Add(new DataColumn("Reason_sharing", typeof(int)));
                dt.Columns.Add(new DataColumn("Comments", typeof(string)));
                dt.Columns.Add(new DataColumn("PAN", typeof(string)));
                dt.Columns.Add(new DataColumn("Name", typeof(string)));
                dt.Columns.Add(new DataColumn("Phone", typeof(string)));
                dt.Columns.Add(new DataColumn("E_mail", typeof(string)));
                dt.Columns.Add(new DataColumn("SharingDate", typeof(DateTime)));
                dt.Columns.Add(new DataColumn("UserInfoId", typeof(int)));
                dt.Columns.Add(new DataColumn("ModeOfSharing", typeof(int)));
                dt.Columns.Add(new DataColumn("Time", typeof(TimeSpan)));
                dt.Columns.Add(new DataColumn("IsRegisteredUser", typeof(string)));
                dt.Columns.Add(new DataColumn("Temp2", typeof(string)));
                dt.Columns.Add(new DataColumn("Temp3", typeof(string)));
                dt.Columns.Add(new DataColumn("Temp4", typeof(string)));
                dt.Columns.Add(new DataColumn("Temp5", typeof(string)));
                dt.Columns.Add(new DataColumn("DocumentNumber", typeof(string)));
                dt.Columns.Add(new DataColumn("Sharedby", typeof(string)));
                dt.Columns.Add(new DataColumn("PublishDate", typeof(DateTime)));

                int rowCount = 0;
                foreach (var UsrContact in UpsiSharingData)
                {
                    if (!string.IsNullOrEmpty(UsrContact.UserInfoId.ToString()))
                    {
                        DataRow dr = dt.NewRow();
                        dt.Rows.Add(dr);
                        dt.Rows[rowCount]["Company_Name"] = UsrContact.Company_Name;
                        dt.Rows[rowCount]["Company_Address"] = UsrContact.Company_Address;
                        dt.Rows[rowCount]["Category_Shared"] = UsrContact.Category_Shared;
                        dt.Rows[rowCount]["Reason_sharing"] = UsrContact.Reason_sharing;
                        dt.Rows[rowCount]["Comments"] = UsrContact.Comments;
                        dt.Rows[rowCount]["PAN"] = UsrContact.PAN;
                        dt.Rows[rowCount]["Name"] = UsrContact.Name;
                        dt.Rows[rowCount]["Phone"] = UsrContact.Phone;
                        dt.Rows[rowCount]["E_mail"] = UsrContact.E_mail;
                        dt.Rows[rowCount]["SharingDate"] = UsrContact.SharingDate;
                        dt.Rows[rowCount]["UserInfoId"] = Convert.ToInt32(UsrContact.UserInfoId);
                        dt.Rows[rowCount]["ModeOfSharing"] = UsrContact.ModeOfSharing;
                        dt.Rows[rowCount]["Time"] = UsrContact.Time;
                        dt.Rows[rowCount]["IsRegisteredUser"] = UsrContact.CHKUserAndOther;
                        dt.Rows[rowCount]["Temp2"] = UsrContact.Temp2;
                        dt.Rows[rowCount]["Temp3"] = UsrContact.Temp3;
                        dt.Rows[rowCount]["Temp4"] = UsrContact.Temp4;
                        dt.Rows[rowCount]["Temp5"] = UsrContact.Temp5;
                        dt.Rows[rowCount]["DocumentNumber"] = UsrContact.DocumentNumber;
                        dt.Rows[rowCount]["Sharedby"] = UsrContact.Sharedby;
                        dt.Rows[rowCount]["PublishDate"] = (object)UsrContact.PublishDate ?? DBNull.Value;
                        rowCount = rowCount + 1;
                    }
                }
                LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                using (var objUpsiSL = new UpsiSL())
                {
                    obgUpsiTempSharingData = objUpsiSL.SaveUpsiList(objLoginUserDetails.CompanyDBConnectionString, dt);
                    strConfirmMessage = Common.Common.getResource("usr_msg_55077");
                }

                #region Email Send
                CompanyConfigurationDTO objCompanyConfigurationDTO = null;
                using (SL.CompaniesSL objCompaniesSL = new SL.CompaniesSL())
                {
                    objCompanyConfigurationDTO = objCompaniesSL.GetCompanyConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString);

                    if (objCompanyConfigurationDTO.TriggerEmailsUPSIUpdated == ConstEnum.Code.UPSI_TEmailUpdate_YesNoSettings_Yes)
                    {
                        List<string> s_Attachment = null;
                        EmailPropertiesDTO objEmailPropertiesDTO = new EmailPropertiesDTO();
                        objEmailPropertiesDTO.Module = "UPSI";
                        objEmailPropertiesDTO.Flag = "SELECT_EMAIL_PROPERTIES";
                        objEmailPropertiesDTO.TemplateCode = ConstEnum.Code.UPSI_UpdateTemplateCode.ToString();
                        objEmailPropertiesDTO.UniqueID = dt.Rows[0]["DocumentNumber"].ToString();
                        SL.EmailPropertiesSL oblEmailPropertiesSL = new SL.EmailPropertiesSL();
                        List<EmailPropertiesDTO> objEmailPropertiesDTOList = oblEmailPropertiesSL.GetEmailPropertiesDetailsForMail(objLoginUserDetails.CompanyDBConnectionString, objEmailPropertiesDTO);

                        try
                        {
                            foreach (var emailPropertiesDTO in objEmailPropertiesDTOList)
                        {
                            using (EmailProperties emailProperties = new EmailProperties(emailPropertiesDTO, s_Attachment))
                            {
                                
                                    SendMail.Instance().SendMailAlerts(objLoginUserDetails.CompanyName, emailProperties);
                                    AddEmailPropertiesToDT(emailProperties);
                                
                                
                            }
                        }
                        }
                        catch (Exception ex)
                        {

                            ModelState.Remove("KEY");
                            ModelState.Add("KEY", new ModelState());
                            ModelState.Clear();
                            string sErrMessage = Common.Common.getResource(ex.Message);
                            ModelState.AddModelError("error", sErrMessage);
                            ErrorDictionary = GetModelStateErrorsAsString();
                        }

                        if (dtEmailLog != null && dtEmailLog.Rows.Count > 0)
                        {
                            using (CommonSL objCommonSL = new CommonSL())
                            {
                                objCommonSL.SaveEamilLog(objLoginUserDetails.CompanyDBConnectionString, dtEmailLog);
                            }
                        }
                        #region Save email log for each email

                        #endregion
                    }
                }
                #endregion Email Send
            }
            TempData.Remove("ListUpsi");
            return RedirectToAction("Index", "UpsiDigital").Success(HttpUtility.UrlEncode(strConfirmMessage));

        }

        private void AddEmailPropertiesToDT(EmailProperties emailProperties)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            DataRow = dtEmailLog.NewRow();
            DataRow["UserInfoId"] = emailProperties.UserInfoId;
            DataRow["To"] = emailProperties.s_MailTo;
            DataRow["CC"] = emailProperties.s_MailCC;
            DataRow["Subject"] = emailProperties.s_MailSubject;
            DataRow["Contents"] = emailProperties.s_MailBody;
            DataRow["Signature"] = emailProperties.Signature;
            DataRow["CommunicationFrom"] = emailProperties.s_MailFrom;
            DataRow["ResponseStatusCodeId"] = "Success";
            DataRow["ResponseMessage"] = "Success";
            DataRow["CreatedBy"] = objLoginUserDetails.LoggedInUserID;
            DataRow["CreatedOn"] =  DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
            DataRow["ModifiedBy"] = objLoginUserDetails.LoggedInUserID;
            DataRow["ModifiedOn"] = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
            dtEmailLog.Rows.Add(DataRow);
        }
        #endregion

        #region publishdate
        /// <summary>
        /// This Method Open Publish Date PopUp
        /// </summary>
        /// <param name="UserInfoID"></param>
        /// <param name="UPSIDocumentId"></param>
        /// <returns></returns>
        [HttpPost]
        public PartialViewResult publishdate(int UserInfoID, int UPSIDocumentId, string SharingDate)
        {
            UpsiSharingData objUpsiSharingData = new UpsiSharingData();
            objUpsiSharingData.UserInfoId = UserInfoID;
            objUpsiSharingData.UPSIDocumentId = UPSIDocumentId;
            return PartialView("~/Views/UpsiDigital/_UpsiPublishdate.cshtml", objUpsiSharingData);
        }
        #endregion
        #region UpdateUpsidate
        /// <summary>
        /// This Method Update Publish Date In Database
        /// </summary>
        /// <param name="UserInfoId"></param>
        /// <param name="UPSIDocumentId"></param>
        /// <param name="Publishdate"></param>
        /// <returns></returns>
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult UpdateUpsidate(int UserInfoId, int UPSIDocumentId, DateTime Publishdate, string __RequestVerificationToken, int formId)
        {
            #region set dt column for email log
            dtEmailLog = new DataTable(); ;
            dtEmailLog.Columns.Add("ID", typeof(Int32));
            dtEmailLog.Columns["ID"].AutoIncrement = true;
            dtEmailLog.Columns["ID"].AutoIncrementSeed = 1;
            dtEmailLog.Columns["ID"].ReadOnly = true;
            dtEmailLog.Columns.Add("UserInfoId", typeof(string));
            dtEmailLog.Columns.Add("To", typeof(string));
            dtEmailLog.Columns.Add("CC", typeof(string));
            dtEmailLog.Columns.Add("BCC", typeof(string));
            dtEmailLog.Columns.Add("Subject", typeof(string));
            dtEmailLog.Columns.Add("Contents", typeof(string));
            dtEmailLog.Columns.Add("Signature", typeof(string));
            dtEmailLog.Columns.Add("CommunicationFrom", typeof(string));
            dtEmailLog.Columns.Add("ResponseStatusCodeId", typeof(string));
            dtEmailLog.Columns.Add("ResponseMessage", typeof(string));
            dtEmailLog.Columns.Add("CreatedBy", typeof(string));
            dtEmailLog.Columns.Add("CreatedOn", typeof(string));
            dtEmailLog.Columns.Add("ModifiedBy", typeof(string));
            dtEmailLog.Columns.Add("ModifiedOn", typeof(string));
            #endregion
            UpsiSharingData objUpsiSharingIndex = new UpsiSharingData();
            var ErrorDictionary = new Dictionary<string, string>();
            bool bReturn = false;
            UpsiDTO obgUpsiTempSharingData = new UpsiDTO();
            obgUpsiTempSharingData.UserInfoId = UserInfoId;
            obgUpsiTempSharingData.UPSIDocumentId = UPSIDocumentId;
            obgUpsiTempSharingData.PublishDate = Publishdate;

            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                using (var objUpsiSL = new UpsiSL())
                {
                    bReturn = objUpsiSL.SaveDetails(objLoginUserDetails.CompanyDBConnectionString, obgUpsiTempSharingData);
                    ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_55072"));
                    #region Email Send
                    CompanyConfigurationDTO objCompanyConfigurationDTO = null;
                    using (SL.CompaniesSL objCompaniesSL = new SL.CompaniesSL())
                    {
                        objCompanyConfigurationDTO = objCompaniesSL.GetCompanyConfigurationDetails(objLoginUserDetails.CompanyDBConnectionString);

                        if (objCompanyConfigurationDTO.TriggerEmailsUPSIpublished == ConstEnum.Code.UPSI_TEmailPublished_YesNoSettings_Yes)
                        {
                            List<string> s_Attachment = null;
                            EmailPropertiesDTO objEmailPropertiesDTO = new EmailPropertiesDTO();
                            objEmailPropertiesDTO.Module = "UPSI";
                            objEmailPropertiesDTO.Flag = "SELECT_EMAIL_PROPERTIES";
                            objEmailPropertiesDTO.TemplateCode = ConstEnum.Code.UPSI_PublishTemplateCode.ToString();
                            objEmailPropertiesDTO.UniqueID = UPSIDocumentId.ToString();
                            SL.EmailPropertiesSL oblEmailPropertiesSL = new SL.EmailPropertiesSL();
                            List<EmailPropertiesDTO> objEmailPropertiesDTOList = oblEmailPropertiesSL.GetEmailPropertiesDetailsForMail(objLoginUserDetails.CompanyDBConnectionString, objEmailPropertiesDTO);

                            foreach (var emailPropertiesDTO in objEmailPropertiesDTOList)
                            {
                                using (EmailProperties emailProperties = new EmailProperties(emailPropertiesDTO, s_Attachment))
                                {
                                    SendMail.Instance().SendMailAlerts(objLoginUserDetails.CompanyName, emailProperties);
                                    AddEmailPropertiesToDT(emailProperties);
                                }
                            }

                            if (dtEmailLog != null && dtEmailLog.Rows.Count > 0)
                            {
                                using (CommonSL objCommonSL = new CommonSL())
                                {
                                    objCommonSL.SaveEamilLog(objLoginUserDetails.CompanyDBConnectionString, dtEmailLog);
                                }
                            }
                        }
                    }
                    #endregion Email Send
                }
                PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "";
                objPopulateComboDTO.Value = "Select";
                List<PopulateComboDTO> lstCategoryList = new List<PopulateComboDTO>();
                lstCategoryList.Add(objPopulateComboDTO);
                lstCategoryList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.CategoryOffinancial).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.CategoryDropDown1 = lstCategoryList;

                List<PopulateComboDTO> lstReasonList = new List<PopulateComboDTO>();
                lstReasonList.Add(objPopulateComboDTO);
                lstReasonList.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.ReasonforSharing).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
                ViewBag.ReasonDropDown = lstReasonList;
            }
            catch (Exception ex)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(ex.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                ErrorDictionary = GetModelStateErrorsAsString();
            }
            finally
            {

            }
            return Json(new
            {
                status = bReturn,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }
        #region AutoCompleteSearchParameters
        /// <summary>
        /// This method is used to set parameters.
        /// </summary>
        /// <param name="rlm"></param>
        /// <returns></returns>
        private Hashtable AutoCompleteSearchParameters(UpsiSharingData rlm)
        {
            Hashtable HT_SearchParam = new Hashtable();
            HT_SearchParam.Add("Action", rlm.Action);
            HT_SearchParam.Add("CompanyName", rlm.Company_Name);
            HT_SearchParam.Add("CompanyAddress", rlm.Company_Address);

            return HT_SearchParam;
        }
        #endregion

        #region GetList
        /// <summary>
        /// This Method Auto serch Company Name
        /// </summary>
        /// <param name="term"></param>
        /// <returns></returns>

        public JsonResult GetList(string term = "")
        {
            try
            {
                UpsiDTO[] matching = null;
                //UpsiSL upsiListSL = null;
                UpsiSharingData restrictedListModel = new UpsiSharingData();
                //upsiListSL = new UpsiSL();
                LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                restrictedListModel.Action = "AUTOCOMPLETE";
                restrictedListModel.Company_Name = term;
                using (var upsiListSL = new UpsiSL())
                {

                    matching = String.IsNullOrEmpty(term) ? upsiListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).ToArray() :
                    upsiListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).Where(p => p.CompanyName.ToLower().Contains(term.ToLower())).ToArray();
                }
                return Json(matching.Select(m => new
                {
                    //Id = m.,
                    CompanyName = m.CompanyName
                }), JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return null;
            }
        }
        #endregion

        #region GetAddress
        /// <summary>
        /// This Method Auto Serch Compny Addresh
        /// </summary>
        /// <param name="term"></param>
        /// <returns></returns>

        public JsonResult GetAddress(string term = "")
        {
            try
            {
                UpsiDTO[] matching = null;
                UpsiSharingData restrictedListModel = new UpsiSharingData();
                LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                restrictedListModel.Action = "AUTOCOMPLETE";
                restrictedListModel.Company_Address = term;
                using (var upsiListSL = new UpsiSL())
                {
                    matching = String.IsNullOrEmpty(term) ? upsiListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).ToArray() :
                    upsiListSL.AutoCompleteListSL(objLoginUserDetails.CompanyDBConnectionString, AutoCompleteSearchParameters(restrictedListModel)).Where(p => p.CompanyAddress.ToLower().Contains(term.ToLower())).ToArray();
                }
                return Json(matching.Select(m => new
                {
                    //Id = m.,
                    CompanyAddress = m.CompanyAddress
                }), JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return null;
            }
        }
        #endregion

        #region Get UPSISetting
        /// <summary>
        /// This method Get UPSI Setting Sharedby value
        /// </summary>
        /// <returns></returns>
        private bool GetUPSISetting()
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            List<CompanySettingConfigurationDTO> lstCompanySettingConfigurationDTO = null;
            CompanyConfigurationDTO objCompanyConfigurationDTO = null;
            objCompanyConfigurationDTO = new CompanyConfigurationDTO();
            lstCompanySettingConfigurationDTO = null;
            bool UPSISetting = true;
            using (var objCompanyDAL = new CompanyDAL())
            {

                lstCompanySettingConfigurationDTO = objCompanyDAL.GetCompanySettingConfigurationList(objLoginUserDetails.CompanyDBConnectionString, Common.ConstEnum.Code.CompanyConfigType_UPSISetting);
                foreach (CompanySettingConfigurationDTO configSettingDTO in lstCompanySettingConfigurationDTO)
                {
                    var UPSISetting_Yes = Convert.ToInt32(configSettingDTO.ConfigurationValueCodeId);
                    if (UPSISetting_Yes == 192001)
                    {
                        UPSISetting = true;
                    }
                    else
                    {
                        UPSISetting = false;
                    }

                }


            }
            return UPSISetting;
        }
        #endregion

        #region Export UPSI Sharing Data
        /// <summary>
        /// this method Export Export UPSI Sharing Data On Click Index Page View
        /// </summary>
        /// <param name="objUpsiSharingData"></param>
        [HttpPost]
        public ActionResult ExportUpsiReport(UpsiSharingData objUpsiSharingData)
        {
            ModelState.Remove("KEY");
            ModelState.Add("KEY", new ModelState());
            ModelState.Clear();
            UpsiSharingData nobjUpsiSharingData = new UpsiSharingData();
            DateTime date = DateTime.Now;
            String Filedate = date.ToString("dd_MMM_yyyy");
            string exlFilename = string.Empty;
            string sConnectionString = string.Empty;
            string spName = string.Empty;
            string workSheetName = string.Empty;
            string cellRange = string.Empty;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            sConnectionString = objLoginUserDetails.CompanyDBConnectionString;
            SqlConnection con = new SqlConnection(sConnectionString);
            SqlCommand cmd = new SqlCommand();
            con.Open();
            DataTable dt = new DataTable();

            spName = "st_UpsiSharingDownLoadList";
            exlFilename = "Digital Database_" + Filedate + ".xls";
            workSheetName = "Digital Database";

            cmd = new SqlCommand(spName, con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@inp_iUserInfoId", objLoginUserDetails.LoggedInUserID);
            cmd.Parameters.Add("@inp_sCategoryShared", objUpsiSharingData.Category_SharedT);
            cmd.Parameters.Add("@inp_sReasonsharing", objUpsiSharingData.Reason_sharingT);
            cmd.Parameters.Add("@inp_sPAN", objUpsiSharingData.PANT);
            cmd.Parameters.Add("@inp_sName", objUpsiSharingData.NameT);
            cmd.Parameters.Add("@inp_sSharingDate", objUpsiSharingData.SharingDateT);
            SqlDataAdapter adp = new SqlDataAdapter(cmd);
            adp.Fill(dt);
            if (dt.Rows.Count <= 0)
            {
                ModelState.AddModelError("NoRecordFoundForDownload", Common.Common.getResource("usr_msg_55079"));
            }

            if (ModelState.IsValid)
            {
                Response.Clear();
                Response.Buffer = true;
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.Charset = "";
                Response.AddHeader("content-disposition", "attachment;filename=" + exlFilename + "");

                StringWriter sWriter = new StringWriter();
                System.Web.UI.HtmlTextWriter hWriter = new System.Web.UI.HtmlTextWriter(sWriter);
                System.Web.UI.WebControls.GridView dtGrid = new System.Web.UI.WebControls.GridView();

                dtGrid.DataSource = dt;
                dtGrid.DataBind();
                dtGrid.RenderControl(hWriter);
                Response.Write(@"<style> TD { mso-number-format:\@; } </style>");

                Response.Output.Write(sWriter.ToString());
                Response.Flush();
                Response.End();
            }

            ViewBag.GridType = ConstEnum.GridType.UpsiSharing_data;
            PopulateComboDTO objPopulateComboDTO1 = new PopulateComboDTO();
            objPopulateComboDTO1.Key = "";
            objPopulateComboDTO1.Value = "Select";
            List<PopulateComboDTO> lstCategoryListt = new List<PopulateComboDTO>();
            lstCategoryListt.Add(objPopulateComboDTO1);
            lstCategoryListt.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            Convert.ToInt32(ConstEnum.CodeGroup.CategoryOffinancial).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.CategoryDropDown1 = lstCategoryListt;
            PopulateComboDTO objPopulateComboDTOt = new PopulateComboDTO();
            List<PopulateComboDTO> lstReasonListt = new List<PopulateComboDTO>();
            lstReasonListt.Add(objPopulateComboDTOt);
            lstReasonListt.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
            Convert.ToInt32(ConstEnum.CodeGroup.ReasonforSharing).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.ReasonDropDown = lstReasonListt;
            return View("Index", nobjUpsiSharingData);

        }
        #endregion Export UPSI Sharing Data

        #region GetEmail
        /// <summary>
        /// This Method Auto Serch email
        /// </summary>
        /// <param name="term"></param>
        /// <returns></returns>

        public JsonResult GetEmail(string term = "")
        {
            try
            {
                LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                List<OtherUsersDetails> OtherUsersDetailsList = new List<OtherUsersDetails>();
                using (var objUserInfoSL = new UserInfoSL())
                {
                    OtherUsersDetailsList = objUserInfoSL.GetOtherUserDetailsList(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, term);
                }
                return Json(OtherUsersDetailsList.Select(m => new
                {
                    E_mail = m.Email,
                    m.Name,
                    m.PAN,
                    m.CompanyAddress,
                    m.CompanyName,
                    m.Phone

                }), JsonRequestBehavior.AllowGet);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return null;
            }
        }
        #endregion

        #region Dispose
        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
        #endregion Dispose

    }
}