using System;
using System.Data;
using System.Data.SqlClient;

namespace ESOP.SSO.Library
{
    public class Generic : IDisposable
    {

        #region Implementation of Singleton Pattern

        /// <summary>
        /// This is a singleton Pattern used for DBUtility
        /// </summary>

        private static Generic _instance;

        /// <summary>
        /// Constructors of Generic class
        /// </summary>

        protected Generic()
        {
        }

        private DataTable dsAuthnRequest;
       
        /// <summary>
        /// Destructors of Generic class
        /// </summary>

        ~Generic()
        {
            Dispose();
        }

        /// <summary>
        /// Creating a instance of a DBUtility class
        /// </summary>
        /// <returns>returning the instance of an object</returns>

        public static Generic Instance()
        {
            if (_instance == null)
            {
                _instance = new Generic();
            }
            return _instance;
        }

        #endregion

        /// <summary>
        /// This method is used to fetch all the company list for whom the Scheduler need to be executed
        /// </summary>
        /// <returns>Returns the list of companies in the form of DataTable</returns>

        /// <summary>
        /// Set The Connection String Value of ESOPManager
        /// </summary>
        public string ConnectionStringValue { get; set; }
        /// <summary>
        /// Set The SSO LogFile Path
        /// </summary>
        public string SsoLogFilePath { get; set; }
        /// <summary>
        /// Set The SSO Log Store Location
        /// </summary>
        public string SsoLogStoreLocation { get; set; }
        /// <summary>
        /// Here Getting the all Company which has ssoconfiguration done.
        /// </summary>
        /// <returns>DataTable</returns>
        internal DataTable GetAllSsoCompanyList()
        {
            dsAuthnRequest = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionStringValue))
                {
                    try
                    {
                        using (var cmd = new SqlCommand("PROC_GET_SSOCONFIG_DETAILS", conn))
                        using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(cmd))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            sqlDataAdapter.Fill(dsAuthnRequest);
                        }
                    }
                    catch (Exception ex) { WriteLog.Instance().ExceptionErrorLog(ex); }
                    finally { conn.Close(); }
                }
            }
            catch (Exception ex) { WriteLog.Instance().ExceptionErrorLog(ex); }
            return dsAuthnRequest;
        }


        #region Implementing IDisposible
        /// <summary>
        /// Method to Dispose the class
        /// </summary>        

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion
    }
}
