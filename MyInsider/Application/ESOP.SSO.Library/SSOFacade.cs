using System;

namespace ESOP.SSO.Library
{
    /// <summary>
    /// This class is a single class that represents an entire subsystem
    /// </summary>
    public class SSOFacade : IDisposable
    {
        #region Implementation of Singleton Pattern
        /// <summary>
        /// This is a singleton Pattern used for Facade
        /// </summary>
        private static SSOFacade _instance;

        /// <summary>
        /// Constructors of Facade class
        /// </summary>
        protected SSOFacade()
        {
        }

        /// <summary>
        /// Destructors of Facade class
        /// </summary>
        ~SSOFacade()
        {
            Dispose();
        }

        /// <summary>
        /// Creating a instance of a DBUtility class
        /// </summary>
        /// <returns>returning the instance of an object</returns>
        public static SSOFacade Instance()
        {
            if (_instance == null)
            {
                _instance = new SSOFacade();
            }
            return _instance;
        }
        #endregion

        /// <summary>
        /// This method is implemented as a facade (Design Pattern)
        /// </summary>
        public void ProcessData()
        {
            try
            {

            }
            catch (Exception ex)
            {

            }
            finally
            {

            }
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
