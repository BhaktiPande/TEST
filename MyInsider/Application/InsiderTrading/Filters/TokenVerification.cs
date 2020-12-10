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
    public class TokenVerification : ActionFilterAttribute
    {
        //public override void OnActionExecuting(ActionExecutingContext filterContext)
        //{
        //    LoginUserDetails objLoginUserDetails = null;
        //    try
        //    {
        //        System.Text.StringBuilder result = new System.Text.StringBuilder();
        //        string formField = null;
        //        foreach (String key in filterContext.HttpContext.Request.Form.AllKeys)
        //        {
        //            //if(filterContext.HttpContext.Request.QueryString[key]!=null)
        //            //    result.Append(filterContext.HttpContext.Request.QueryString[key]);
        //            //else
        //            //    result.Append(filterContext.HttpContext.Request.Form[0].Contains("__RequestVerificationToken"));
        //            if(key == "__RequestVerificationToken")
        //            {
        //                formField = Convert.ToString(filterContext.HttpContext.Request.Form["__RequestVerificationToken"]);  
        //            }
        //        }
                             

        //        //if (formField ==null)
        //        //    formField = Convert.ToString(filterContext.ActionParameters["__RequestVerificationToken"]);

        //        if (formField == null && filterContext.ActionParameters.ContainsKey("__RequestVerificationToken"))
        //            formField = Convert.ToString(filterContext.ActionParameters["__RequestVerificationToken"]);
        //        else
        //        {
        //            foreach (String key in filterContext.HttpContext.Request.Params.AllKeys)
        //            {                       
        //                //if (filterContext.HttpContext.Request.QueryString[key] != null)
        //                //    result.Append(filterContext.HttpContext.Request.QueryString[key]);
        //                //else
        //                //    result.Append(filterContext.HttpContext.Request.Form[key]);
        //                if (key == "__RequestVerificationToken")
        //                {
        //                    formField = Convert.ToString(filterContext.HttpContext.Request.Params["__RequestVerificationToken"]);
        //                }
        //            }
        //        }


        //        int formId = 0;

        //        foreach (String key in filterContext.HttpContext.Request.Params.AllKeys)
        //        {
        //            //if (filterContext.HttpContext.Request.QueryString[key] != null)
        //            //    result.Append(filterContext.HttpContext.Request.QueryString[key]);
        //            //else
        //            //    result.Append(filterContext.HttpContext.Request.Form[key]);
        //            if (key == "formId")
        //            {
        //                formId = Convert.ToInt32(filterContext.HttpContext.Request.Params["formId"]);
        //            }
        //        }
        //            //Convert.ToInt32(filterContext.HttpContext.Request.Params["formId"]);
        //        if (formId == 0 && filterContext.ActionParameters.ContainsKey("formId"))
        //            formId = Convert.ToInt32(filterContext.ActionParameters["formId"]);

        //        if (formId != 0 && formField != null)
        //        {
        //            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
        //            using (var objUserInfoSL = new UserInfoSL())
        //            {
        //                TokenDetailsDTO objTokenDetailsDTO = new TokenDetailsDTO();
        //                objTokenDetailsDTO = objUserInfoSL.GetFormTokenStatus(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objLoginUserDetails.LoggedInUserID), formField, formId);

        //                if (objTokenDetailsDTO == null)
        //                {
        //                    objTokenDetailsDTO = objUserInfoSL.SaveFormTokenStatus(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objLoginUserDetails.LoggedInUserID), formId, formField);
        //                }
        //                else
        //                {

        //                    if (Convert.ToString(objTokenDetailsDTO.TokenName) == Convert.ToString(formField))
        //                    {
        //                        throw new HttpException(401, "Unauthorized access");
        //                    }
        //                    else
        //                        objTokenDetailsDTO = objUserInfoSL.SaveFormTokenStatus(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objLoginUserDetails.LoggedInUserID), formId, formField);
        //                }
        //            }
        //        }
        //        base.OnActionExecuting(filterContext);
        //    }
        //    catch (Exception ex)
        //    {
        //        using (var objUserInfoSL = new UserInfoSL())
        //        {
        //            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
        //            objUserInfoSL.DeleteFormToken(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objLoginUserDetails.LoggedInUserID),0);
        //            objUserInfoSL.DeleteCookiesStatus(objLoginUserDetails.CompanyDBConnectionString, Convert.ToInt32(objLoginUserDetails.LoggedInUserID), " ");
        //        }
        //       throw new HttpException(401, "Unauthorized access");
        //    }
        //}        
    }
}