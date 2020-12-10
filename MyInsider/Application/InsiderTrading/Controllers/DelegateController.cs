using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTrading.Models;
using InsiderTradingDAL;
using InsiderTrading.Common;
using InsiderTrading.SL;
using System.Data;
using InsiderTrading.Filters;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class DelegateController : Controller
    {
        #region DelegationList
        // GET: /Delegate/
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            ViewBag.GridType = Common.ConstEnum.GridType.DelegateMasterList;
            PopulateCombo();
            return View(new DelegateModel());
        }
        #endregion DelegationList

        #region Delegation partial create
        [HttpPost]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public JsonResult Index(DelegateModel objDelegateModel, int acid)
        {
            bool bStatusFlag = false;
            int nPatrialSave = 0;
            var ErrorDictionary = new Dictionary<string, string>();
            Common.Common objCommon = new Common.Common();
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return Json(new
                    {
                        status = false,
                        msg = ErrorDictionary
                    }, JsonRequestBehavior.AllowGet);
                }
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                
                if (ModelState.IsValid)
                {
                    ViewBag.UserInfoIdFrom = objDelegateModel.UserInfoIdFrom;
                    ViewBag.UserInfoIdTo = objDelegateModel.UserInfoIdTo;
                    ViewBag.DelegationFrom = objDelegateModel.DelegationFrom;
                    ViewBag.DelegationTo = objDelegateModel.DelegationTo;
                    objDelegateModel.DelegationId = 0;
                    
                    DelegationMasterDTO objDelegationMasterDTO = new DelegationMasterDTO();

                    Common.Common.CopyObjectPropertyByName(objDelegateModel, objDelegationMasterDTO);

                    using (DelegationMasterSL objDelegationMasterSL = new DelegationMasterSL())
                    {
                        objDelegationMasterDTO = objDelegationMasterSL.SaveDetails(objDelegationMasterDTO, nPatrialSave, objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);
                        bStatusFlag = true;
                        ErrorDictionary.Add("id", Convert.ToString(objDelegationMasterDTO.DelegationId));
                    }
                }
                else
                {
                    ErrorDictionary = GetModelStateErrorsAsString();
                }
                
            }catch(Exception e)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(e.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                ErrorDictionary = GetModelStateErrorsAsString();
            }
            finally
            {
                objLoginUserDetails = null;
            }

            return Json(new
            {
                status = bStatusFlag,
                msg = ErrorDictionary,
                user_action = acid
            });

        }

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }
        #endregion Delegation partial create

        #region Delegation edit
        [AuthorizationPrivilegeFilter]
        public ActionResult Edit(int DelegationId, int acid)
        {
            DelegateModel objDelegateModel = new DelegateModel();
            objDelegateModel.DelegationId = DelegationId;
            return Create(objDelegateModel, acid);
        }
        #endregion Delegation edit

        #region Delegation Create
        // GET: /Delegate/Edit/5
        [AuthorizationPrivilegeFilter]
        public ActionResult Create(DelegateModel objDelegateModel, int acid)
        {
            LoginUserDetails objLoginUserDetails = null;
            DelegationMasterDTO objDelegationMasterDTO = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                
                if (Convert.ToInt32(objDelegateModel.DelegationId) != 0)
                {
                    objDelegationMasterDTO = new DelegationMasterDTO();

                    objDelegationMasterDTO.DelegationId = Convert.ToInt32(objDelegateModel.DelegationId);

                    using (DelegationMasterSL objDelegationMasterSL = new DelegationMasterSL())
                    {
                        objDelegationMasterDTO = objDelegationMasterSL.GetDetails(objDelegationMasterDTO, objLoginUserDetails.CompanyDBConnectionString);
                        InsiderTrading.Common.Common.CopyObjectPropertyByName(objDelegationMasterDTO, objDelegateModel);
                    }
                }

                GenerateDelegationDetails(Convert.ToInt32(objDelegateModel.DelegationId), Convert.ToInt32(objDelegateModel.UserInfoIdFrom), Convert.ToInt32(objDelegateModel.UserInfoIdTo));

                ViewBag.user_action = acid;

                return View("Edit", objDelegateModel);
            }
            catch(Exception e){
                string sErrMessage = Common.Common.getResource(e.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                return View("Edit", objDelegateModel);
            }
            finally
            {
                objLoginUserDetails = null;
                objDelegationMasterDTO = null;
            }
        }
        #endregion Delegation Create

        #region Delegation Edit post
        // POST: /Delegate/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public ActionResult Edit(int acid, int[] chkActivity,  DelegateModel objDelegateModel)
        {
            int nPartialSave = 1;

            DataTable tblDelefationDetailsActivity = null;

            DelegationMasterDTO objDelegationMasterDTO = null;
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                tblDelefationDetailsActivity = new DataTable("RoleActivityType");
                tblDelefationDetailsActivity.Columns.Add(new DataColumn("RoleId", typeof(int)));
                tblDelefationDetailsActivity.Columns.Add(new DataColumn("ActivityId", typeof(int)));

                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                
                objDelegationMasterDTO = new DelegationMasterDTO();
                Common.Common.CopyObjectPropertyByName(objDelegateModel, objDelegationMasterDTO);

                using (DelegationMasterSL objDelegationMasterSL = new DelegationMasterSL())
                {
                    objDelegationMasterDTO = objDelegationMasterSL.SaveDetails(objDelegationMasterDTO, nPartialSave, objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                    if (chkActivity != null && chkActivity.Length > 0)
                    {
                        DataRow row = null;
                        foreach (int ActivityId in chkActivity)
                        {
                            row = tblDelefationDetailsActivity.NewRow();
                            row["RoleId"] = objDelegationMasterDTO.DelegationId;
                            row["ActivityId"] = ActivityId;
                            tblDelefationDetailsActivity.Rows.Add(row);
                        }
                        row = null;
                    }
                    if (chkActivity != null && chkActivity.Length > 0)
                    {
                        objDelegationMasterSL.DelegationDetailsSaveDelete(objLoginUserDetails.CompanyDBConnectionString, tblDelefationDetailsActivity, objLoginUserDetails.LoggedInUserID);
                    }
                }
                
                // TODO: Add insert logic here
                // return RedirectToAction("Edit", "Delegate", new { id = id });
                return RedirectToAction("index", "Delegate", new { acid = ConstEnum.UserActions.DELEGATION_MASTER_VIEW });
            }
            catch(Exception e)
            {
                GenerateDelegationDetails(Convert.ToInt32(objDelegateModel.DelegationId), Convert.ToInt32(objDelegateModel.UserInfoIdFrom), Convert.ToInt32(objDelegateModel.UserInfoIdTo));
                string sErrMessage = Common.Common.getResource(e.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                return View("Edit", objDelegateModel);
            }
            finally
            {
                tblDelefationDetailsActivity = null;

                objDelegationMasterDTO = null;
                objLoginUserDetails = null;
            }
        }
        #endregion Delegation Edit post

        #region DelegationDelete
        // GET: /Delegate/Delete/5
        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public ActionResult Delete(int acid, int id)
        {
            bool bDeleteFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();

            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                using (DelegationMasterSL objDelegationMasterSL = new DelegationMasterSL())
                {
                    bDeleteFlag = objDelegationMasterSL.Delete(id, objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID);

                    if (bDeleteFlag)
                        ErrorDictionary.Add("success", "Successfully deleted the delegation record");
                }
            }
            catch(Exception e)
            {
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(e.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                ErrorDictionary = GetModelStateErrorsAsString();
            }
            finally
            {
                objLoginUserDetails = null;
            }

            return Json(new
            {
                status = bDeleteFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion DelegationDelete

        #region Private Methods
        private void GenerateDelegationDetails(int m_nDelegationMasterId, int m_nUserInfoIdFrom, int m_nUserInfoIdTo)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            Dictionary<string, Dictionary<string, List<InsiderTradingDAL.RoleActivityDTO>>> objRoleActivityDictionary = null;
            InsiderTrading.SL.DelegationMasterSL objDelegationMasterSL = new InsiderTrading.SL.DelegationMasterSL();
            objRoleActivityDictionary = objDelegationMasterSL.GetDelegationActivityDetails(objLoginUserDetails.CompanyDBConnectionString, m_nDelegationMasterId, m_nUserInfoIdFrom, m_nUserInfoIdTo);
            PopulateCombo();
            ViewBag.RoleActivityDictionary = objRoleActivityDictionary;
            ViewBag.ColumnCount = 3;
        }

        private void PopulateCombo()
        {
            LoginUserDetails objLoginUserDetails = null;
            PopulateComboDTO objPopulateComboDTO = null;
            List<PopulateComboDTO> lstPopulateComboDTO = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                objPopulateComboDTO = new PopulateComboDTO();
                objPopulateComboDTO.Key = "0";
                objPopulateComboDTO.Value = "Select";

                lstPopulateComboDTO = new List<PopulateComboDTO>();
                lstPopulateComboDTO.Add(objPopulateComboDTO);
                lstPopulateComboDTO.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, Common.ConstEnum.ComboType.COUserList,
                    null, null, null, null, null, "cmp_msg_").ToList<PopulateComboDTO>());

                ViewBag.FromUserList = lstPopulateComboDTO;
                ViewBag.ToUserList = lstPopulateComboDTO;
            }
            finally
            {
                objLoginUserDetails = null;
                objPopulateComboDTO = null;
                lstPopulateComboDTO = null;
            }
        }
        #endregion Private Methods

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
    }
}
