using InsiderTrading.Common;
using InsiderTrading.Filters;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new ELMAHHandleErrorAttribute());
            filters.Add(new HandleErrorAttribute());
            filters.Add(new GlobalFilter());
            //filters.Add(new AuthorizationPrivilegeFilter());
        }
    }
}
