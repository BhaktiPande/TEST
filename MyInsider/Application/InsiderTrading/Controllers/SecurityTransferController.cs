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

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    public class SecurityTransferController : Controller
    {
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid, int PendingPeriodEndCount = 0, int PendingTransactionsCountPNT = 0, int PendingTransactionsCountPCL = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            @ViewBag.UserInfoId = objLoginUserDetails.LoggedInUserID;
            ViewBag.HoldingForList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.PreclearanceRequestor, null, null, null, null, false);
            ViewBag.SecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
            if (PendingPeriodEndCount > 0)
            {
                ModelState.AddModelError("HoldingList", Common.Common.getResource("usr_msg_11470"));
            }
            if (PendingTransactionsCountPNT > 0 || PendingTransactionsCountPCL > 0)
            {
                ModelState.AddModelError("HoldingList", Common.Common.getResource("usr_msg_11467"));  
            }  
         
            return View("HoldingList"); 
        }
        
        //
        // GET: /SecurityTransfer/
        [AuthorizationPrivilegeFilter]
        public ActionResult Transfer(int acid)
        {   
            SecurityTransferLogModel objSecurityTransferLogModel=new SecurityTransferLogModel();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            int PendingPeriodEndCount = 0;
            int PendingTransactionsCountPNT = 0;
            int PendingTransactionsCountPCL = 0;

            try{

                objSecurityTransferLogModel.TransferFor = InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestForSelf;
                objSecurityTransferLogModel.UserInfoId = objLoginUserDetails.LoggedInUserID;
                objSecurityTransferLogModel.ForUserInfoId = objLoginUserDetails.LoggedInUserID;
                objSecurityTransferLogModel.SecurityTransferOption = InsiderTrading.Common.ConstEnum.Code.SecurityTransferfromselectedDemataccount;
                //objSecurityTransferLogModel.TransferQuantity = null;

                using (var objSecurityTransferSL = new SecurityTransferSL())
                {
                    objSecurityTransferSL.GetPendingTransactionforSecurityTransfer(objLoginUserDetails.CompanyDBConnectionString,
                    objSecurityTransferLogModel.UserInfoId, out PendingPeriodEndCount, out PendingTransactionsCountPNT, out PendingTransactionsCountPCL);         
                }

            }catch(Exception){

            }
            finally{
                objLoginUserDetails = null;
            }

            if (PendingPeriodEndCount > 0)
            {
                acid = ConstEnum.UserActions.Security_Transfer_Holding_List;
                return RedirectToAction("Index", "SecurityTransfer", new { acid, PendingPeriodEndCount, PendingTransactionsCountPNT, PendingTransactionsCountPCL });
            }
            else if (PendingTransactionsCountPNT > 0 || PendingTransactionsCountPCL > 0)
            {
               acid = ConstEnum.UserActions.Security_Transfer_Holding_List;
               return RedirectToAction("Index", "SecurityTransfer", new { acid, PendingPeriodEndCount, PendingTransactionsCountPNT, PendingTransactionsCountPCL });
            }
            else
            {
                return View("TransferView", objSecurityTransferLogModel);
            }
            
        }

        [AuthorizationPrivilegeFilter]
        public ActionResult TransferReport(int acid)
        {
            return View("SecurityTransferReport");
        }

        [AuthorizationPrivilegeFilter]
        public ActionResult TransferReportCO(int acid)
        {
            ViewBag.GradeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.GradeMaster, null, null, null, null, false);
            ViewBag.DepartmentList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.DepartmentMaster, null, null, null, null, false);
            ViewBag.CompanyList = FillComboValues(ConstEnum.ComboType.CompanyList, null, null, null, null, null, false);
            ViewBag.UserTypeList = FillComboValues(ConstEnum.ComboType.UserType, null, null, null, null, null, false);
            ViewBag.SecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, false);
          //return View("ReportView");
           return View("SecurityTransferReport");
        }

        [HttpPost]
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        public JsonResult TransferBalance(SecurityTransferLogModel objSecurityTransferLogModel)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            SecurityTransferDTO objSecurityTransferDTO = new SecurityTransferDTO();
            
            try
            {
                Common.Common.CopyObjectPropertyByName(objSecurityTransferLogModel, objSecurityTransferDTO);

                using(var objSecurityTransferSL = new SecurityTransferSL())
                {
                    objSecurityTransferSL.TransferBalance(objLoginUserDetails.CompanyDBConnectionString, objSecurityTransferDTO);
                }
                return Json(new
                {
                    status = true,
                    msg = Common.Common.getResource("usr_msg_11471")
                });
            }
            catch (Exception exp)
            {
                if (ModelState.ContainsKey("TransferQuantity"))
                    ModelState["TransferQuantity"].Errors.Clear();
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }

        #region Transfer Type Change Event
        /// <summary>
        /// 
        /// </summary>
        /// <param name="objPreclearanceRequestModel"></param>
        /// <returns></returns>
        
        public ActionResult LoadRelative(SecurityTransferLogModel objSecurityTransferLogModel)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                if (objSecurityTransferLogModel.TransferFor == InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestForRelative)
                {
                    objSecurityTransferLogModel.UserInfoId = objLoginUserDetails.LoggedInUserID;
                    objSecurityTransferLogModel.ForUserInfoId = objSecurityTransferLogModel.ForUserInfoId;
                    ViewBag.UserInfoRelativeList = FillComboValues(ConstEnum.ComboType.UserRelativeList, objLoginUserDetails.LoggedInUserID.ToString(), null, null, null, null, true);
                }
                else
                {
                    objSecurityTransferLogModel.UserInfoId = objLoginUserDetails.LoggedInUserID;
                    objSecurityTransferLogModel.ForUserInfoId = objLoginUserDetails.LoggedInUserID;

                }
                ModelState.Clear();
               // objSecurityTransferLogModel.ForUserInfoId = objLoginUserDetails.LoggedInUserID;
                return PartialView("_RelativeDetails", objSecurityTransferLogModel);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("TransferView", objSecurityTransferLogModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion Transfer Type Change Event

        #region Load Selected Transfer Type 
      
        public ActionResult LoadSelectedTransferType(SecurityTransferLogModel objSecurityTransferLogModel)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                ViewBag.SecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode,InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, true);
                if (objSecurityTransferLogModel.TransferFor == InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestForRelative)
                {
                    objSecurityTransferLogModel.UserInfoId = objLoginUserDetails.LoggedInUserID;
                    objSecurityTransferLogModel.ForUserInfoId = objSecurityTransferLogModel.ForUserInfoId;
                    ViewBag.FromDEMATAcountList = FillComboValues(ConstEnum.ComboType.UserDMATList, objSecurityTransferLogModel.ForUserInfoId.ToString(), null, null, null, null, true);
                    ViewBag.ToDEMATAcountList = FillComboValues(ConstEnum.ComboType.UserDMATList, objSecurityTransferLogModel.ForUserInfoId.ToString(), null, null, null, null, true);
                }
                else
                {
                    objSecurityTransferLogModel.UserInfoId = objLoginUserDetails.LoggedInUserID;
                    objSecurityTransferLogModel.ForUserInfoId = objLoginUserDetails.LoggedInUserID;
                    ViewBag.UserInfoId = objSecurityTransferLogModel.UserInfoId;
                    ViewBag.FromDEMATAcountList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), null, null, null, null, true);
                    ViewBag.ToDEMATAcountList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), null, null, null, null, true);

                }
                ModelState.Clear();
                // objSecurityTransferLogModel.ForUserInfoId = objLoginUserDetails.LoggedInUserID;
                return PartialView("_IndividualAccountTransfer", objSecurityTransferLogModel);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("TransferView", objSecurityTransferLogModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion Load Selected Transfer Type

        #region Load All Transfer Type

        public ActionResult LoadAllTransferType(SecurityTransferLogModel objSecurityTransferLogModel)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            try
            {
                ViewBag.SecurityTypeList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.SecurityType, null, null, null, null, true);
                if (objSecurityTransferLogModel.TransferFor == InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestForRelative)
                {
                    objSecurityTransferLogModel.UserInfoId = objLoginUserDetails.LoggedInUserID;
                    objSecurityTransferLogModel.ForUserInfoId = objSecurityTransferLogModel.ForUserInfoId;
                    ViewBag.ToDEMATAcountList = FillComboValues(ConstEnum.ComboType.UserDMATList, objSecurityTransferLogModel.ForUserInfoId.ToString(), null, null, null, null, true);
                }
                else
                {
                    objSecurityTransferLogModel.UserInfoId = objLoginUserDetails.LoggedInUserID;
                    objSecurityTransferLogModel.ForUserInfoId = objLoginUserDetails.LoggedInUserID;
                    ViewBag.ToDEMATAcountList = FillComboValues(ConstEnum.ComboType.UserDMATList, objLoginUserDetails.LoggedInUserID.ToString(), null, null, null, null, true);

                }
                ModelState.Clear();
                // objSecurityTransferLogModel.ForUserInfoId = objLoginUserDetails.LoggedInUserID;
                return PartialView("_AllAccountTransfer", objSecurityTransferLogModel);
            }
            catch (Exception exp)
            {
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return View("TransferView", objSecurityTransferLogModel);
            }
            finally
            {
                objLoginUserDetails = null;
            }
        }
        #endregion Load All Transfer Type

        #region GetAvailableQuantityForIndividualDematOrAllDemat
        public JsonResult GetAvailableQuantityForIndividualDematOrAllDemat(SecurityTransferLogModel objSecurityTransferLogModel)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            decimal out_dAvailableQty=0;
            decimal out_dAvailableESOPQty = 0;
            decimal out_dAvailableOtherQty = 0;
            string sMessage="";
            string EsopQtyMessage = "";
            string OtherQtyMessage = "";
            try{

                using (var objSecurityTransferSL = new SecurityTransferSL())
                {
                    if (objSecurityTransferLogModel.TransferFor == InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestForSelf)
                    {
                        if (objSecurityTransferLogModel.SecurityTransferOption == InsiderTrading.Common.ConstEnum.Code.SecurityTransferfromselectedDemataccount)
                        {
                            objSecurityTransferSL.GetAvailableQuantityForIndividualDematOrAllDemat(objLoginUserDetails.CompanyDBConnectionString,
                                objSecurityTransferLogModel.UserInfoId,  objSecurityTransferLogModel.UserInfoId,objSecurityTransferLogModel.SecurityTypeCodeID, objSecurityTransferLogModel.FromDEMATAcountID,
                                objSecurityTransferLogModel.SecurityTransferOption, out out_dAvailableQty, out out_dAvailableESOPQty, out out_dAvailableOtherQty);
                            sMessage = InsiderTrading.Common.Common.getResource("usr_lbl_11453") + Convert.ToInt64(out_dAvailableQty).ToString();
                            EsopQtyMessage = InsiderTrading.Common.Common.getResource("usr_lbl_50651") + Convert.ToInt64(out_dAvailableESOPQty).ToString();
                            OtherQtyMessage = InsiderTrading.Common.Common.getResource("usr_lbl_50652") + Convert.ToInt64(out_dAvailableOtherQty).ToString();
                        }else if(objSecurityTransferLogModel.SecurityTransferOption == InsiderTrading.Common.ConstEnum.Code.SecurityTransferfromAllDemataccount){
                            objSecurityTransferSL.GetAvailableQuantityForIndividualDematOrAllDemat(objLoginUserDetails.CompanyDBConnectionString,
                               objSecurityTransferLogModel.UserInfoId, objSecurityTransferLogModel.UserInfoId, objSecurityTransferLogModel.SecurityTypeCodeID, objSecurityTransferLogModel.ToDEMATAcountID,
                               objSecurityTransferLogModel.SecurityTransferOption, out out_dAvailableQty, out out_dAvailableESOPQty, out out_dAvailableOtherQty);
                           
                            ArrayList lstQty = new ArrayList();
                            lstQty.Add(Convert.ToInt64(out_dAvailableQty).ToString());
                            sMessage = Common.Common.getResource("usr_lbl_11454", lstQty);
                            //sMessage = "<b>Total Available Quantity for transfer of all demat accounts : " + Convert.ToInt64(out_dAvailableQty).ToString() +
                               // "<br/>  (Excluding the demat account to which the quantity is to be transferred)</b>";
                        }
                    }else if(objSecurityTransferLogModel.TransferFor == InsiderTrading.Common.ConstEnum.Code.PreclearanceRequestForRelative){
                         if (objSecurityTransferLogModel.SecurityTransferOption == InsiderTrading.Common.ConstEnum.Code.SecurityTransferfromselectedDemataccount)
                        {
                            objSecurityTransferSL.GetAvailableQuantityForIndividualDematOrAllDemat(objLoginUserDetails.CompanyDBConnectionString,
                                objSecurityTransferLogModel.UserInfoId,  objSecurityTransferLogModel.ForUserInfoId,objSecurityTransferLogModel.SecurityTypeCodeID, objSecurityTransferLogModel.FromDEMATAcountID,
                                objSecurityTransferLogModel.SecurityTransferOption, out out_dAvailableQty, out out_dAvailableESOPQty, out out_dAvailableOtherQty);
                            sMessage = InsiderTrading.Common.Common.getResource("usr_lbl_11453") + Convert.ToInt64(out_dAvailableQty).ToString();
                            EsopQtyMessage = InsiderTrading.Common.Common.getResource("usr_lbl_50651") + Convert.ToInt64(out_dAvailableESOPQty).ToString();
                            OtherQtyMessage = InsiderTrading.Common.Common.getResource("usr_lbl_50652") + Convert.ToInt64(out_dAvailableOtherQty).ToString();
                        }else if(objSecurityTransferLogModel.SecurityTransferOption == InsiderTrading.Common.ConstEnum.Code.SecurityTransferfromAllDemataccount){
                            objSecurityTransferSL.GetAvailableQuantityForIndividualDematOrAllDemat(objLoginUserDetails.CompanyDBConnectionString,
                               objSecurityTransferLogModel.UserInfoId, objSecurityTransferLogModel.ForUserInfoId, objSecurityTransferLogModel.SecurityTypeCodeID, objSecurityTransferLogModel.ToDEMATAcountID,
                               objSecurityTransferLogModel.SecurityTransferOption, out out_dAvailableQty, out out_dAvailableESOPQty, out out_dAvailableOtherQty);
                           // sMessage = "<b>Total Available Quantity for transfer of all demat accounts : " + Convert.ToInt64(out_dAvailableQty).ToString() +
                            //   " <br/>(Excluding the demat account to which the quantity is to be transferred)</b>";
                            ArrayList lstQty = new ArrayList();
                            lstQty.Add(Convert.ToInt64(out_dAvailableQty).ToString());
                            sMessage = Common.Common.getResource("usr_lbl_11454", lstQty);
                        }
                    }
                }
                ModelState.Clear();
            }catch(Exception exp){
                ModelState.AddModelError("Error", Common.Common.GetErrorMessage(exp));
                return Json(new { status = false, error = ModelState.ToSerializedDictionary() });
            }
            finally
            {

            }

            return Json(new
            {
                status = true,
                Message = sMessage,
                ESOP_Qty_Message = EsopQtyMessage,
                Other_Qty_Message = OtherQtyMessage,
                Other_Than_Esop_Qty = out_dAvailableOtherQty,
                Esop_Qty = out_dAvailableESOPQty,
                ESOP_Other_TotalQty = out_dAvailableQty
            }, JsonRequestBehavior.AllowGet);
        }
        #endregion GetAvailableQuantityForIndividualDematOrAllDemat

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
	}
}