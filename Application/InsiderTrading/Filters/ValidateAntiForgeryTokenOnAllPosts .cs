using InsiderTradingEncryption;
using System;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Configuration;

namespace InsiderTrading.Filters
{
    public class ValidateAntiForgeryTokenOnAllPosts : AuthorizeAttribute
    {
        CompilationSection compilationSection = (CompilationSection)System.Configuration.ConfigurationManager.GetSection(@"system.web/compilation");

        public override void OnAuthorization(System.Web.Mvc.AuthorizationContext filterContext)
        {
            if (compilationSection.Debug)
            {
                if (!Directory.Exists(System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs")))
                    Directory.CreateDirectory(System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs"));

                using (FileStream filestream = new FileStream((System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs/DebugLogs.txt")), FileMode.Append, FileAccess.Write, FileShare.ReadWrite))
                {
                    StreamWriter sWriter = new StreamWriter(filestream);
                    sWriter.WriteLine("Inside method OnAuthorization");
                    sWriter.Close();
                    sWriter.Dispose();
                    filestream.Close();
                    filestream.Dispose();
                }
            }

            var request = filterContext.HttpContext.Request;

            //  Only validate POSTs
            if (request.HttpMethod == WebRequestMethods.Http.Post)
            {
                if (compilationSection.Debug)
                {
                    using (FileStream filestream = new FileStream((System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs/DebugLogs.txt")), FileMode.Append, FileAccess.Write, FileShare.ReadWrite))
                    {
                        StreamWriter sWriter = new StreamWriter(filestream);
                        sWriter.WriteLine("Inside POST");
                        sWriter.Close();
                        sWriter.Dispose();
                        filestream.Close();
                        filestream.Dispose();
                    }
                }

                DataSecurity objDataSecurity = new DataSecurity();

                if (compilationSection.Debug)
                {
                    if (!Directory.Exists(System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs")))
                        Directory.CreateDirectory(System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs"));

                    using (FileStream filestream = new FileStream((System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs/DebugLogs.txt")), FileMode.Append, FileAccess.Write, FileShare.ReadWrite))
                    {
                        StreamWriter sWriter = new StreamWriter(filestream);
                        sWriter.WriteLine("request.Form[sCalledFrom]" + request.Form["sCalledFrom"]);
                        sWriter.WriteLine("objDataSecurity.CreateHash" + objDataSecurity.CreateHash(string.Format(Common.ConstEnum.s_SSO, Convert.ToString(DateTime.Now.Year)), Common.ConstEnum.User_Password_Encryption_Key));
                        sWriter.Close();
                        sWriter.Dispose();
                        filestream.Close();
                        filestream.Dispose();
                    }
                }

                string formField = null;
                string sCompanyName = null;

                foreach (String key in filterContext.HttpContext.Request.Form.AllKeys)
                {
                    if (key == "sCompanyName")
                    {
                        sCompanyName = Convert.ToString(filterContext.HttpContext.Request.Form["sCompanyName"]);
                    }
                }
                
                    foreach (String key in filterContext.HttpContext.Request.Form.AllKeys)
                    {
                        if (key == "FormID")
                        {
                            formField = Convert.ToString(filterContext.HttpContext.Request.Form["FormID"]);
                            HttpContext.Current.Session["formField"] = formField;
                        }
                    }                

                if (request.Form["sCalledFrom"] != objDataSecurity.CreateHash(string.Format(Common.ConstEnum.s_SSO, Convert.ToString(DateTime.Now.Year)), Common.ConstEnum.User_Password_Encryption_Key))
                {
                    if (formField == null)
                    {
                        new ValidateAntiForgeryTokenAttribute()
                             .OnAuthorization(filterContext);
                    }
                }
            }
        }
    }
}