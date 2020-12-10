using System;
using System.Web.Mvc;

using InsiderTrading.Common;

namespace InsiderTrading.Controllers
{
    public class ErrorController : Controller
    {
        //
        // GET: /Error/

        public ActionResult Index(int statusCode, Exception exception, string controller, string action)
        {
            Response.StatusCode = statusCode;
            if (statusCode == 404)
            {
                return RedirectToAction("HttpError404", "Error");
            }
            else
            {
                return RedirectToAction("HttpError505", "Error");
            }           

        }

        public ActionResult UnderConstruction()
        {

            return View("UnderConstruction");
    
        }

        public ActionResult HttpError404()
        {
            return View();
        }

        public ActionResult HttpError505()
        {
            return View();
        }

        public ActionResult HttpError401()
        {
            return RedirectToAction("LogOut", "Account").Success(" ");
        }

        #region Dispose
        /// <summary>
        /// Dispose Method
        /// </summary>
        /// <param name="disposing"></param>
        protected override void Dispose(bool disposing)
        {
            base.Dispose(true);
        }
        #endregion Dispose

   	}
}