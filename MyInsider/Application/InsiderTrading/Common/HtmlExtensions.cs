using System;
using System.Linq.Expressions;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using System.Web.Routing;

namespace System.Web.Mvc
{
    public static class ResourceKeyExtension
    {
        public static MvcHtmlString ReourceKeyFor<TModel, TValue>(
                             this HtmlHelper<TModel> html,
                             Expression<Func<TModel, TValue>> expression)
        {
            var x = ModelMetadata.FromLambdaExpression<TModel, TValue>(expression, html.ViewData);
            if (x.AdditionalValues.ContainsKey("ResourceKey"))
                return new MvcHtmlString((string)x.AdditionalValues["ResourceKey"]);

            return new MvcHtmlString("");
        }

        public static MvcHtmlString ActivityResourceKeyFor<TModel, TValue>(
                             this HtmlHelper<TModel> html,
                             Expression<Func<TModel, TValue>> expression)
        {
            var x = ModelMetadata.FromLambdaExpression<TModel, TValue>(expression, html.ViewData);

            if (x.AdditionalValues.ContainsKey("ActivityResourceKey"))
                return new MvcHtmlString((string)x.AdditionalValues["ActivityResourceKey"]);

            return new MvcHtmlString("");
        }
    }
}



