using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace InsiderTrading
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                 defaults: ConfigurationManager.AppSettings["IsADFSEnabled"].ToString() == "1" ?
                             new { controller = "ADAssertionConsumer", action = "Index", id = UrlParameter.Optional } :
                             new { controller = "Account", action = "Login", id = UrlParameter.Optional }
              //defaults: new { controller = "ADAssertionConsumer", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
