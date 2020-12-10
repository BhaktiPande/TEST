using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTradingDAL;

namespace InsiderTrading.SL
{
    public class DMATDetailsSL:IDisposable
    {
        #region SaveDMATDetails
        /// <summary>
        /// This method is used to get DMAT details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objDMATDetailsDTO">DMAT Details Object</param>
        /// <returns>Returns boolean value based on the result</returns>
        public DMATDetailsDTO SaveDMATDetails(string i_sConnectionString, DMATDetailsDTO i_objDMATDetailsDTO, int nLoggedInUserId)
        {
            try
            {
                DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
                //DMATDetailsDAL objDMATDetailsDAL = new DMATDetailsDAL();
                using (var objDMATDetailsDAL = new DMATDetailsDAL())
                {
                    objDMATDetailsDTO = objDMATDetailsDAL.SaveDMATDetails(i_sConnectionString, i_objDMATDetailsDTO, nLoggedInUserId);
                }
                return objDMATDetailsDTO;
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion SaveDMATDetails

        #region Delete
        /// <summary>
        /// This method is used for the insert/Update DMAT details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_nDMATDetailsID">DMATDetailsID to delete</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Returns boolean value based on the result</returns>
        public bool DeleteUserDetails(string i_sConnectionString, int i_nDMATDetailsID, int i_nLoggedInUserID)
        {
            bool bReturn = false;
            try
            {
                //DMATDetailsDAL objDMATDetailsDAL = new DMATDetailsDAL();
                using (var objDMATDetailsDAL = new DMATDetailsDAL())
                {
                    bReturn = objDMATDetailsDAL.DeleteDMATDetails(i_sConnectionString, i_nDMATDetailsID, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }

            return bReturn;
        }
        #endregion InsertUpdateUserDetails

        #region GetDetails
        /// <summary>
        /// This method is used for the insert/Update DMAT details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_nDMATDetailsID">DMATDetailsID to delete</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Returns boolean value based on the result</returns>
        public DMATDetailsDTO GetDMATDetails(string i_sConnectionString, int i_nDMATDetailsID)
        {
            DMATDetailsDTO objDMATDetailsDTO = new DMATDetailsDTO();
            try
            {                
                //DMATDetailsDAL objDMATDetailsDAL = new DMATDetailsDAL();
                using (var objDMATDetailsDAL = new DMATDetailsDAL())
                {
                    objDMATDetailsDTO = objDMATDetailsDAL.GetDMATDetails(i_sConnectionString, i_nDMATDetailsID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objDMATDetailsDTO;
        }
        #endregion GetDetails

        #region SaveDMATDetails
        /// <summary>
        /// This method is used to save DMAT Account Holder Details
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objDMATAccountHolderDTO">DMATHolder Details Object</param>
        /// <returns>Returns boolean value based on the result</returns>
        public bool SaveDMATHolderDetails(string i_sConnectionString, DMATAccountHolderDTO i_objDMATAccountHolderDTO, int nLoggedInUserId)
        {
            bool bReturn = false;
            try
            {
                //DMATDetailsDAL objDMATDetailsDAL = new DMATDetailsDAL();
                using (var objDMATDetailsDAL = new DMATDetailsDAL())
                {
                    bReturn = objDMATDetailsDAL.SaveDMATHolderDetails(i_sConnectionString, i_objDMATAccountHolderDTO, nLoggedInUserId);
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }

            return bReturn;
        }
        #endregion SaveDMATDetails

        #region DeleteDMATHolder
        /// <summary>
        /// This method is used for the insert/Update DMAT details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_nDMATAccountHoderID">DMATAccountHoderID to delete</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Returns boolean value based on the result</returns>
        public bool DeleteDMATHolder(string i_sConnectionString, int i_nDMATAccountHoderID, int i_nLoggedInUserID)
        {
            bool bReturn = false;
            try
            {
                //DMATDetailsDAL objDMATDetailsDAL = new DMATDetailsDAL();
                using (var objDMATDetailsDAL = new DMATDetailsDAL())
                {
                    bReturn = objDMATDetailsDAL.DeleteDMATHolder(i_sConnectionString, i_nDMATAccountHoderID, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                bReturn = false;
                throw exp;
            }

            return bReturn;
        }
        #endregion DeleteDMATHolder

        #region GetDMATHolderDetails
        /// <summary>
        /// This method is used to get DMATHolder details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_nDMATDetailsID">DMATDetailsID to delete</param>
        /// <param name="nLoggedInUserId">Logged In User</param>
        /// <returns>Returns boolean value based on the result</returns>
        public DMATAccountHolderDTO GetDMATHolderDetails(string i_sConnectionString, int i_nDMATAccountHolderID)
        {
            DMATAccountHolderDTO objDMATAccountHolderDTO = new DMATAccountHolderDTO();
            try
            {
                //DMATDetailsDAL objDMATDetailsDAL = new DMATDetailsDAL();
                using (var objDMATDetailsDAL = new DMATDetailsDAL())
                {
                    objDMATAccountHolderDTO = objDMATDetailsDAL.GetDMATHolderDetails(i_sConnectionString, i_nDMATAccountHolderID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objDMATAccountHolderDTO;
        }
        #endregion GetDMATHolderDetails

        #region IDisposable Members
        /// <summary>
        /// Dispose Method for dispose object
        /// </summary>
        private void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        /// <summary>
        /// Interface for dispose class
        /// </summary>
        void IDisposable.Dispose()
        {
            Dispose(true);
        }


        /// <summary>
        /// virtual dispoase method
        /// </summary>
        /// <param name="disposing"></param>
        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }
        #endregion

    }
}