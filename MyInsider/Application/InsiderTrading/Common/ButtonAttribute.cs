using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;


namespace InsiderTrading
{   
    public class ButtonAttribute : ActionMethodSelectorAttribute
    {
        public string ButtonName { get; set; }

        //public int acid { get; set; }       

        public override bool IsValidForRequest(ControllerContext controllerContext, System.Reflection.MethodInfo methodInfo)
        {
            try
            {
                if (controllerContext.Controller.ValueProvider.GetValue(ButtonName) != null)
                {
                    var formCollection = new FormCollection(controllerContext.HttpContext.Request.Form);

                    string authorizationData = controllerContext.HttpContext.Request.Form["authorization"];
                    if (authorizationData != null)
                    {
                        string[] authorizations = authorizationData.Split(new char[] { ',' });
                        string acidToUse = "0";
                        foreach (string authorizationString in authorizations)
                        {
                            string[] parts = authorizationString.Split(new char[] { ':' });
                            if (parts[0] == ButtonName)
                            {
                                acidToUse = parts[1];
                            }
                        }
                        //Added the parameter acid received from request to the DataToken to be checked in AuthorizationPriveligeFilter for authorization
                        RouteData routeData = controllerContext.RouteData;
                        routeData.DataTokens["acid"] = acidToUse;
                        routeData.DataTokens["ButtonName"] = ButtonName;
                        controllerContext.RouteData = routeData; ;
                    }
                    return true;
                }
                
            }
            catch(Exception e)
            {
                if(e.GetType() == typeof(System.Web.HttpRequestValidationException))
                {
                    return true;
                }
            }
            return false;
        }
    }
}