using InsiderTrading.Common;
using InsiderTrading.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{

    [RolePrivilegeFilter]
    public class SSRSReportController : Controller
    {
        /// <summary>
        /// Method is used for Get Employee login RL Search Report
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        public ActionResult RestrictedListSearchReport(int acid)
        {
            try
            {
                
                ViewBag.Rights = true;                
                switch (acid)
                {
                    //This is CO Report - CO Report part is moved to Report controller
                    //case InsiderTrading.Common.ConstEnum.ReportIDMaster.COReportId:
                    //    ViewBag.RID = "b4czFb/7oAQ=";
                    //    break;
                    //This is Employee/Insider Report - Insider Report part is moved to Report controller
                    //case InsiderTrading.Common.ConstEnum.ReportIDMaster.EmpReportId:
                    //    ViewBag.RID = "EJLIsEY9uZo=";
                    //    break;
                }
                return View(acid);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View(acid);
            }
            
        }

        /// <summary>
        /// Method is used for Get Admin and Compliance Officer R&T Report
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        public ActionResult RnTReport(int acid)
        {
            try
            {
                
                ViewBag.Rights = true;
                switch (acid)
                {                    
                    case InsiderTrading.Common.ConstEnum.ReportIDMaster.RnTReportId:
                        ViewBag.RID = "/EFMo9hRx5g=";//3
                        break;                    
                }
                return View(acid);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View(acid);
            }

        }

        /// <summary>
        /// Method is used for Get CO login RL Search Report
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        public ActionResult CORLReport(int acid)
        {
            try
            {
                
                ViewBag.Rights = true;
                return View(acid);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View(acid);
            }
            
        }

        /// <summary>
        /// This method is used to Open View Error Log Report
        /// </summary>
        /// <param name="acid">int acid Report id</param>
        /// <returns>view for the ViewErrorLogReport</returns>
        public ActionResult ViewErrorLogReport(int acid)
        {
            try
            {   
                ViewBag.Rights = true;
                switch (acid)
                {
                    case InsiderTrading.Common.ConstEnum.ReportIDMaster.n_ViewErrorLogReportId:
                        ViewBag.RID = "06p6JFH6prI=";//ReportID=9
                        break;
                }

                return View(acid);
            }
            catch (Exception exp)
            {
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("Error", sErrMessage);
                return View(acid);
            }
        }
	}
}