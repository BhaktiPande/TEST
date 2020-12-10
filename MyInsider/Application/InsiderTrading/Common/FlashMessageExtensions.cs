using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Common
{
    internal static class FlashMessageExtensions
    {
        public static ActionResult Error(this ActionResult result, string message)
        {
            CreateCookieWithFlashMessage(Notification.Error, message.Replace("+", "%20"));
            return result;
        }

        public static ActionResult Warning(this ActionResult result, string message)
        {
            CreateCookieWithFlashMessage(Notification.Warning, message.Replace("+", "%20"));
            return result;
        }

        public static ActionResult Success(this ActionResult result, string message)
        {
            CreateCookieWithFlashMessage(Notification.Success, message.Replace("+", "%20"));
            return result;
        }

        public static ActionResult Information(this ActionResult result, string message)
        {
            CreateCookieWithFlashMessage(Notification.Info, message.Replace("+", "%20"));
            return result;
        }

        private static void CreateCookieWithFlashMessage(Notification notification, string message)
        {
            HttpCookie objFlashCookie = new HttpCookie(string.Format("Flash.{0}", notification), message) { Path = HttpContext.Current.Request.ApplicationPath };
            objFlashCookie.HttpOnly = false;
            
            HttpContext.Current.Response.Cookies.Add(objFlashCookie);
        }

        private enum Notification
        {
            Error,
            Warning,
            Success,
            Info
        }
    }
}