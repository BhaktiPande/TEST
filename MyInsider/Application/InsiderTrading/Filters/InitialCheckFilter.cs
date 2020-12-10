using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using System.Web.Routing;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using InsiderTrading.Models;
using System.Reflection;

namespace InsiderTrading.Filters
{
    public class InitialCheckFilter : ActionFilterAttribute
    {

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            try
            {
                int RedirectionType;
                object path = null;
                string sController = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
                string sAction = filterContext.ActionDescriptor.ActionName;
                string ControllerAction = sController + sAction;               
                int ValidationType = ConstEnum.ValidateTo[ControllerAction];
                int LoggenInUserId = objLoginUserDetails.LoggedInUserID;
                CommonDAL objCommonDAL = new CommonDAL();
                CommonModel objCommonModel = new CommonModel();
                CommonDTO objCommonDTO = new CommonDTO();            
                objCommonDTO = objCommonDAL.InitialChecks(objLoginUserDetails.CompanyDBConnectionString, ValidationType, LoggenInUserId, out RedirectionType);
                if (RedirectionType != 0)
                {
                    path = ConstEnum.Redirect[RedirectionType];
                    var sType = path.GetType();
                    var values = new System.Web.Routing.RouteValueDictionary();
                    foreach (var prop in sType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
                    {
                        values.Add(prop.Name, Convert.ToString(prop.GetValue(path, null)));
                    }
                    if (objCommonDTO != null)
                    {
                        var sourceType = objCommonDTO.GetType();
                        foreach (var property in sourceType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
                        {
                            if (Convert.ToString(property.GetValue(objCommonDTO, null)) != null && Convert.ToString(property.GetValue(objCommonDTO, null)) != "")
                            {
                                values.Add(property.Name, Convert.ToString(property.GetValue(objCommonDTO, null)));
                            }
                        }
                    }
                    filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(values));
                }            
            }
            catch(Exception exp)
            {
                throw exp;
            }
        }
     
    }
}