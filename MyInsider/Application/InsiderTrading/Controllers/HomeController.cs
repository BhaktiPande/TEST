using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.SL;
using System;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    //  [AuthorizationPrivilegeFilter]
    public class HomeController : Controller
    {
        //This Action not get call for every user login the filter redirects to respective action itself
        [AuthorizationPrivilegeFilter(Order = 1)]
        [UpdateResourcesFilter(Order = 2)]

        public ActionResult Index(string calledFrom = "")
        {
            LoginUserDetails objLoginUserDetails = null;

            //Removing ) ACID for default activities for after loin page.
            Common.Common.WriteLogToFile("Start Method", System.Reflection.MethodBase.GetCurrentMethod());

            Session["IsOTPAuthPage"] = null;
            bool IsConcurrentSessionActive = false;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                ViewBag.LoginUserName = objLoginUserDetails.UserName;
                ViewBag.LoginUserCompany = objLoginUserDetails.CompanyName;

                InsiderTradingDAL.SessionDetailsDTO objSessionDetailsDTO = null;

                using (UserInfoSL objIsActiveCS = new UserInfoSL())
                {
                    IsConcurrentSessionActive = objIsActiveCS.CheckConcurrentSessionConfiguration(objLoginUserDetails.CompanyDBConnectionString);
                }

                if (IsConcurrentSessionActive)
                {
                    if (calledFrom == "Login")
                    {
                        using (UserInfoSL objUserInfoSL = new UserInfoSL())
                        {
                            objSessionDetailsDTO = objUserInfoSL.SaveSessionStatus(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, "CheckValidLogin");

                            if (objSessionDetailsDTO == null)
                            {
                                throw new System.Web.HttpException(401, "Unauthorized access");
                            }
                        }

                        using (UserInfoSL objUserInfoSL = new UserInfoSL())
                        {
                            objSessionDetailsDTO = objUserInfoSL.SaveSessionStatus(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, "FromLogin");

                            if (objSessionDetailsDTO != null)
                            {
                                if (objSessionDetailsDTO.UserId == (Convert.ToInt32(objLoginUserDetails.LoggedInUserID)))
                                {
                                    objUserInfoSL.DeleteCookiesStatus(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objLoginUserDetails.LoggedInUserID), "  ");
                                    //throw new System.Web.HttpException(401, "Unauthorized access"); 
                                }
                            }
                        }
                    }
                }

                if (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.Admin || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.COUserType)
                {
                    objLoginUserDetails.SelectedParentID = Common.ConstEnum.MenuID.CODASHBOARD;
                    objLoginUserDetails.SelectedChildId = "";
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);

                    Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());
                    if (IsConcurrentSessionActive)
                    {
                        if (calledFrom == "Login")
                        {
                            using (UserInfoSL objUserInfoSL = new UserInfoSL())
                            {
                                objSessionDetailsDTO = objUserInfoSL.SaveSessionStatus(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, (Convert.ToString(HttpContext.Session["GUIDSessionID"])).ToString());
                            }
                        }
                    }
                    return RedirectToAction("Index", "UpsiDigital");

                    //return RedirectToAction("Index", "CODashboard", new { acid = Common.ConstEnum.UserActions.CRUSER_COUSERDASHBOARD_DASHBOARD });
                }
                else if (objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.EmployeeType || objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.NonEmployeeType ||
                    objLoginUserDetails.UserTypeCodeId == ConstEnum.Code.CorporateUserType)
                {
                    objLoginUserDetails.SelectedParentID = Common.ConstEnum.MenuID.INSIDERDASHBOARD;
                    objLoginUserDetails.SelectedChildId = "";
                    Common.Common.SetSessionValue(ConstEnum.SessionValue.UserDetails, objLoginUserDetails);

                    Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());
                    //For MCQ
                    InsiderTradingDAL.ImplementedCompanyDTO objImplementedCompanyDTO = new InsiderTradingDAL.ImplementedCompanyDTO();
                    using (var objCompaniesSL = new InsiderTrading.SL.CompaniesSL())
                    {
                        objImplementedCompanyDTO = objCompaniesSL.GetDetails(objLoginUserDetails.CompanyDBConnectionString, 0, 1);
                    }
                    if (IsConcurrentSessionActive)
                    {
                        if (calledFrom == "Login")
                        {
                            using (UserInfoSL objUserInfoSL = new UserInfoSL())
                            {
                                objSessionDetailsDTO = objUserInfoSL.SaveSessionStatus(objLoginUserDetails.CompanyDBConnectionString, objLoginUserDetails.LoggedInUserID, (Convert.ToString(HttpContext.Session["GUIDSessionID"])).ToString());
                            }
                        }
                    }

                    //return RedirectToAction("Index", "UpsiDigital");
                    return RedirectToAction("Index", "InsiderDashboard", new { acid = Common.ConstEnum.UserActions.DASHBOARD_INSIDERUSER });

                }
                else
                {
                    Common.Common.WriteLogToFile("End Method", System.Reflection.MethodBase.GetCurrentMethod());

                    return RedirectToAction("Home", "About");
                }


            }
            catch (Exception exp)
            {
                Common.Common.WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), exp);
                return RedirectToAction("Home", "About");
            }

            finally
            {
                objLoginUserDetails = null;
            }
        }

        //   [AuthorizationPrivilegeFilter(Order = 1)]
        //    [UpdateResourcesFilter(Order = 2)]
        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";
            ViewBag.Title = "Vigilante System";
            return View("About");
        }
        [AuthorizationPrivilegeFilter(Order = 1)]
        [UpdateResourcesFilter(Order = 2)]
        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public ActionResult Unauthorised()
        {

            return RedirectToAction("LogOut", "Account").Success("abcd");
            //return View("UnauthorizedAcess");
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }

    }
}