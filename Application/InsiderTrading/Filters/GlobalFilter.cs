using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InsiderTradingDAL;
using InsiderTrading.Common;
using System.Reflection;
using System.Web.Routing;

namespace InsiderTrading.Filters
{
    public class GlobalFilter : ActionFilterAttribute 
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            try
            {
                string[] Params = null;
                string sController = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
                string sAction = filterContext.ActionDescriptor.ActionName;
                string sControllerAction = sController + sAction;
                CommonDAL objCommonDAL = new CommonDAL();
                CommonDTO objCommonDTO = new CommonDTO();
                LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                if (objLoginUserDetails != null && objLoginUserDetails.CompanyDBConnectionString != null)
                {
                    objCommonDTO = objCommonDAL.GlobalRedirection(objLoginUserDetails.CompanyDBConnectionString, sControllerAction, objLoginUserDetails.LoggedInUserID);
                    //objCommonDTO = objCommonDAL.GlobalRedirectionForInitialCheck(objLoginUserDetails.CompanyDBConnectionString, sControllerAction, objLoginUserDetails.LoggedInUserID, out RedirectionType);
                    //if (RedirectionType != 0)//"temp" && RedirectionType != null)
                    //{
                    //    path = ConstEnum.Redirect[RedirectionType];
                    //    var sType = path.GetType();
                    var values = new System.Web.Routing.RouteValueDictionary();             
                    //    foreach (var prop in sType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
                    //    {
                    //        values.Add(prop.Name, Convert.ToString(prop.GetValue(path, null)));
                    //    }
                        if (objCommonDTO != null)
                        {
                            var sourceType = objCommonDTO.GetType();
                            foreach (var property in sourceType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
                            {
                                if (Convert.ToString(property.GetValue(objCommonDTO, null)) != null && Convert.ToString(property.GetValue(objCommonDTO, null)) != "")
                                {
                                    if (property.Name == "Parameter")
                                    {
                                        
                                      Params = Convert.ToString(property.GetValue(objCommonDTO, null)).Split(',');
                                    }
                                    else
                                    {
                                        values.Add(property.Name, Convert.ToString(property.GetValue(objCommonDTO, null)));
                                    }
                                }
                            }
                            if (Params != null)
                            {
                                for (int i = 0; i < Params.Length; i = i + 2)
                                {
                                    values.Add(Params[i], Params[i + 1]);
                                }
                            }
                        }
                       
                        if (values.Keys.Count != 0)
                        {
                            if (values.Values.Contains("UserDetails") && values.Values.Contains("ChangePassword"))
                            {
                                Common.Common.SetSessionValue("IsChangePassword", true);
                            }
                            else
                            {
                                Common.Common.SetSessionValue("IsChangePassword", false);
                            }
                            filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(values));
                        }
                    }
                //}
            }
            catch(Exception e)
            {
                throw e;
            }
        }
    }
}