using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.SL;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    public class ResourceController : Controller
    {
        //
        // GET: /Resource/
        [RolePrivilegeFilter]
        [AuthorizationPrivilegeFilter]
        public ActionResult Index(int acid)
        {
            try
            {
                ViewBag.ModuleList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ResourceModules.ToString(), null, null, null, null, true);
                ViewBag.CategoryList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ResourceCategory.ToString(), null, null, null, null, true);
                ViewBag.ScreenList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ResourceScreenType.ToString(), null, null, null, null, true);
                FillGrid(ConstEnum.GridType.ResourcesList, null, null, null, null, null);
                ViewBag.ResourceUserAction = acid;
                return View("Index");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index");
            }
        }

        [AuthorizationPrivilegeFilter]
        public ActionResult Edit(string ResourceKey,int acid)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ResourcesDTO objResourcesDTO = null;
            ResourcesSL objResourcesSL=new ResourcesSL();
            try
            {
                objResourcesDTO = objResourcesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, ResourceKey);
                ResourceModel objResourceModel = new ResourceModel();
                ViewBag.ColumnAlignmentList = FillComboValues(ConstEnum.ComboType.ListOfCode, InsiderTrading.Common.ConstEnum.CodeGroup.ColumnAlignment, null, null, null, null, true);
                Common.Common.CopyObjectPropertyByName(objResourcesDTO, objResourceModel);
                return PartialView("~/Views/Resource/Create.cshtml", objResourceModel);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return RedirectToAction("Index");
            }
            finally
            {
                objLoginUserDetails = null;
                objResourcesDTO = null;
                objResourcesSL = null;
            }

        }
       
        [HttpPost]
        [ValidateAntiForgeryToken]
        //[TokenVerification]
        [AuthorizationPrivilegeFilter]
        public JsonResult UpdateResourceValue(ResourceModel objResourceModel,int acid)
        {
            bool bReturn = false;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            ResourcesSL objResourcesSL = new ResourcesSL();
            ResourcesDTO objResourcesDTO = new ResourcesDTO();
            CompaniesSL objCompaniesSL = new CompaniesSL();
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            Common.Common objCommon = new Common.Common();
            string message=string.Empty;
            try
            {
                if (!objCommon.ValidateCSRFForAJAX())
                {
                    return Json(new
                    {
                        status = statusFlag,
                        Message = ErrorDictionary
                    }, JsonRequestBehavior.AllowGet);
                }
                Common.Common.CopyObjectPropertyByName(objResourceModel, objResourcesDTO);
                objResourcesDTO.LoggedInUserId = objLoginUserDetails.LoggedInUserID;
                bReturn = objResourcesSL.SaveDetails(objLoginUserDetails.CompanyDBConnectionString, objResourcesDTO);
                if (bReturn)
                {
                    objCompaniesSL.UpdateMasterCompanyDetails(Common.Common.getSystemConnectionString(), objLoginUserDetails.CompanyName, 1);
                    Common.Common.UpdateCompanyResources(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.CompanyName);
                    //return Json(new
                    //{
                    //    status = true,
                    //    Message = InsiderTrading.Common.Common.getResource("mst_msg_10049") //"Resource Update Successfully."

                    //}, JsonRequestBehavior.AllowGet);
                    statusFlag = true;
                    message= InsiderTrading.Common.Common.getResource("mst_msg_10049");
                }
                else
                {
                    statusFlag = false;
                    message = "Resource not saved.";
                }
                //return Json(new
                //{
                //    status = false,
                //    Message = "Resource not saved."

                //}, JsonRequestBehavior.AllowGet);
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
                objResourcesSL = null;
                objResourcesDTO = null;
                objCompaniesSL = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = message
            }, JsonRequestBehavior.AllowGet);
        }

        [AuthorizationPrivilegeFilter]
        public ActionResult ModuleCodeChange(int ParentId,int acid,int SelectedId = 0)
        {
            try
            {
                ViewBag.ScreenList = FillComboValues(ConstEnum.ComboType.ListOfCode, ConstEnum.CodeGroup.ResourceScreenType.ToString(), ParentId.ToString(), null, null, null, true);
                ViewBag.GridType = ConstEnum.GridType.ResourcesList;
                ViewBag.SelectedChildId = SelectedId;
                return PartialView("ScreenCodePartialView");
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View("Index");
            }
            finally
            {

            }
        }

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
        /// <param name="i_sParam4"></param>
        /// <param name="i_sParam5"></param>
        private void FillGrid(int m_nGridType, string i_sParam1, string i_sParam2, string i_sParam3, string i_sParam4, string i_sParam5)
        {
            ViewBag.GridType = m_nGridType;
            ViewBag.Param1 = i_sParam1;
            ViewBag.Param2 = i_sParam2;
            ViewBag.Param3 = i_sParam3;
            ViewBag.Param4 = i_sParam4;
            ViewBag.Param5 = i_sParam5;
        }
        #endregion FillGrid

        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }

        #endregion Private Method

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
    }
}