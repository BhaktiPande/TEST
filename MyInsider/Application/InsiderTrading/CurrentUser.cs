using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace InsiderTrading
{
    public class CurrentUser
    {
        private static string OLMID { get { return HttpContext.Current.User.Identity.Name; } }
        public static int EmpNumber
        {
            get
            {
                if (ConfigHelper.IsOLMID == 1)
                {
                    string strOLMID = HttpContext.Current.User.Identity.Name;
                    if (strOLMID.Contains('\\'))
                    {
                        string[] userName = strOLMID.Split('\\');
                        if (userName.Count() > 0)
                        {
                            strOLMID = userName[1];
                        }
                    }
                    List<SqlParameter> inputParams = new List<SqlParameter>();
                    inputParams.Add(new SqlParameter("@OLMID", SqlDbType.VarChar, 50) { Value = strOLMID });
                    string id = "1";// Convert.ToString(DBHelper.ExecuteScalar("<ADD Produre for user detail> ", inputParams));
                    if (string.IsNullOrEmpty(id))
                    {
                        return 0;
                    }
                    else
                    {
                        return Convert.ToInt32(id);
                    }
                }
                else
                {
                    return Convert.ToInt32(HttpContext.Current.User.Identity.Name);
                }
            }
        }
    }
    public static class ConfigHelper
    {
        public static int IsOLMID { get { return Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["IsOLMID"]); } }
        public static string DBconnecionstring { get { return Convert.ToString(System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"]); } }

    }
}