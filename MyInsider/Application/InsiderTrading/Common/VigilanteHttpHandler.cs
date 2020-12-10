using System.Web;

namespace InsiderTrading
{
    public class VigilanteHttpHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            if (context.Request.RawUrl.Contains("/Scripts") || context.Request.RawUrl.Contains("/images") || context.Request.RawUrl.Contains("/Document") || context.Request.RawUrl.Contains("/CommonSSRSReport") || context.Request.RawUrl.Contains("/Views") || context.Request.RawUrl.Contains("/Content"))
                context.Response.Redirect("~/account/login", false);
        }

        public bool IsReusable
        {
            get { return true; }
        }
    }
}