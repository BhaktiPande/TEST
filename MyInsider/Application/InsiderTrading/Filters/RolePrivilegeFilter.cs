using InsiderTradingEncryption;
using System;
using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using ImageGenerator;
using System.Drawing;
using System.IO;
using System.Drawing.Imaging;
using System.Configuration;

namespace InsiderTrading.Filters
{
    public class RolePrivilegeFilter:ActionFilterAttribute
    {
        //public override void OnActionExecuting(ActionExecutingContext filterContext)
        //{
        //    int acid = 0;
        //    try
        //    {

        //        LoginUserDetails loginUserDetails = null;
        //        loginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
        //        InsiderTradingDAL.SessionDetailsDTO objSessionDetailsDTO = null;
        //        if (loginUserDetails.CompanyDBConnectionString != null)
        //        {
        //            using (UserInfoSL objUserInfoSL = new UserInfoSL())
        //            {
        //                objSessionDetailsDTO = objUserInfoSL.SaveCookieStatus(loginUserDetails.CompanyDBConnectionString, loginUserDetails.LoggedInUserID, " ");
        //            }

        //            if (Convert.ToString(objSessionDetailsDTO.CookieName) == "Unauthorised")
        //            {
        //                using (var objUserInfoSL = new UserInfoSL())
        //                {
        //                    objUserInfoSL.DeleteFormToken(loginUserDetails.CompanyDBConnectionString, Convert.ToInt32(loginUserDetails.LoggedInUserID), 0);
        //                    objUserInfoSL.DeleteCookiesStatus(loginUserDetails.CompanyDBConnectionString, Convert.ToInt32(loginUserDetails.LoggedInUserID), "Delete");
        //                }
        //                throw new HttpException(401, "Unauthorized access");
        //            }
        //        }
        //        else
        //        {
        //            throw new HttpException(401, "Unauthorized access");
        //        }
                
                
        //        if (filterContext.HttpContext.Request.Params.GetValues("acid") != null)
        //            acid = Convert.ToInt32((filterContext.HttpContext.Request.Params["acid"].Contains(",")) ? filterContext.HttpContext.Request.Params["acid"].Split(',')[0] : filterContext.HttpContext.Request.Params["acid"]);
        //        else if (filterContext.ActionParameters.ContainsKey("acid"))
        //            acid = Convert.ToInt32(filterContext.ActionParameters["acid"]);
                

        //        if (!InsiderTrading.Common.Common.CanPerform(acid))
        //        {
        //            throw new HttpException(401, "Unauthorized access");
        //        }
        //        base.OnActionExecuting(filterContext);

        //    }
        //    catch (Exception ex)
        //    {
        //        using (var objUserInfoSL = new UserInfoSL())
        //        {
        //            LoginUserDetails objLoginUserDetails = null;
        //            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
        //            objUserInfoSL.DeleteFormToken(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objLoginUserDetails.LoggedInUserID), 0);
        //            objUserInfoSL.DeleteCookiesStatus(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objLoginUserDetails.LoggedInUserID), " ");
        //        }
        //        throw new HttpException(401, "Unauthorized access");
        //    }
        //}  
          
    }
}