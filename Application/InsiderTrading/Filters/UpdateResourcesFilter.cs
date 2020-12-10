using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using System.Web.Routing;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Web.Configuration;

namespace InsiderTrading.Filters
{
    public class UpdateResourcesFilter : ActionFilterAttribute
    {
       
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            CompilationSection compilationSection = (CompilationSection)System.Configuration.ConfigurationManager.GetSection(@"system.web/compilation");

            //UserInfoSL objUserInfoSL = new UserInfoSL();
            CompaniesSL objCompaniesSL = new CompaniesSL();
            ResourcesSL objResourcesSL = new ResourcesSL();
            InsiderTradingDAL.CompanyDTO objSelectedCompany = new CompanyDTO();
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)Common.Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
            string sConnectionString = "";
            if (objLoginUserDetails == null || objLoginUserDetails.CompanyName == null)
            {
                sConnectionString = Common.Common.getSystemConnectionString();
                Dictionary<string, string> lstCompanyResources = new Dictionary<string, string>();
                objResourcesSL.GetAllResources(sConnectionString, out lstCompanyResources);
                HttpContext.Current.Application.Set("InsiderTrading", lstCompanyResources);

                if (compilationSection.Debug)
                {
                    using (FileStream filestream = new FileStream((System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs/DebugLogs.txt")), FileMode.Append, FileAccess.Write, FileShare.ReadWrite))
                    {
                        StreamWriter sWriter = new StreamWriter(filestream);
                        sWriter.WriteLine("UpdateResourcesFilter--> OnActionExecuting method called and got Exception for - Login details || Company name is null :- " + DateTime.Now);
                        sWriter.WriteLine("--------------------------------------------------------------------");
                        sWriter.Close();
                        sWriter.Dispose();
                        filestream.Close();
                        filestream.Dispose();
                    }
                }
            }
            else
            {
                objSelectedCompany = objCompaniesSL.getSingleCompanies(Common.Common.getSystemConnectionString(), objLoginUserDetails.CompanyName);
                sConnectionString = objLoginUserDetails.CompanyDBConnectionString;
                Dictionary<string,string> objResourceFromContext = ((Dictionary<string, string>)HttpContext.Current.Application.Get(objLoginUserDetails.CompanyName));
                if (objSelectedCompany.nUpdateResources == 1 || (objResourceFromContext == null || objResourceFromContext.Count==0))
                {
                    Common.Common.UpdateCompanyResources(sConnectionString, objLoginUserDetails.CompanyName);
                }

                if (compilationSection.Debug)
                {
                    using (FileStream filestream = new FileStream((System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs/DebugLogs.txt")), FileMode.Append, FileAccess.Write, FileShare.ReadWrite))
                    {
                        StreamWriter sWriter = new StreamWriter(filestream);
                        sWriter.WriteLine("UpdateResourcesFilter--> OnActionExecuting method called :- " + DateTime.Now);
                        sWriter.WriteLine("--------------------------------------------------------------------");
                        sWriter.Close();
                        sWriter.Dispose();
                        filestream.Close();
                        filestream.Dispose();
                    }
                }
            }
                                    
            //Note: Fetch the activity access for user and load in session here
            
            base.OnActionExecuting(filterContext);
        }
    }
}