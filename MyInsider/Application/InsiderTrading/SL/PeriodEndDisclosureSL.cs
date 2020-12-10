using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.SL
{
    public class PeriodEndDisclosureSL:IDisposable
    {
        #region Get period start and end date
        /// <summary>
        /// This method is used to get period's start and end date in year
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="YearCode"></param>
        /// <param name="PeriodCode"></param>
        /// <returns></returns>
        public Dictionary<String, Object> GetPeriodStarEndDate(string sConnectionString, int YearCode, int PeriodCode, int PeriodType)
        {
            var PeriodStartEndDate = new Dictionary<String, object>();

            try
            {
                //PeriodEndDisclosureDAL objPeriodEndDisclosureDAL = new PeriodEndDisclosureDAL();
                using (var objPeriodEndDisclosureDAL = new PeriodEndDisclosureDAL())
                {
                    PeriodStartEndDate = objPeriodEndDisclosureDAL.GetPeriodStarEndDate(sConnectionString, YearCode, PeriodCode, PeriodType);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return PeriodStartEndDate;
        }
        #endregion Get period start and end date

        #region Get lastest period end year code
        /// <summary>
        /// This method is used to lastest period end disclosure year code
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public int GetLastestPeriodEndYearCode(string sConnectionString)
        {
            int nYearCode = 0;

            try
            {
                //PeriodEndDisclosureDAL objPeriodEndDisclosureDAL = new PeriodEndDisclosureDAL();
                using (var objPeriodEndDisclosureDAL = new PeriodEndDisclosureDAL())
                {
                    nYearCode = objPeriodEndDisclosureDAL.GetLastestPeriodEndYearCode(sConnectionString);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return nYearCode;
        }
        #endregion Get lastest period end year code

        #region Get Closing Balance Of Annual Period
        /// <summary>
        /// This method is used to get Closing balance of annual period of that user.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public double GetClosingBalanceOfAnnualPeriod(string sConnectionString, int nUserInfoId, int nUserInfoIdRelative, int nSecurityTypeCodeId)
        {
            double nClosingBalance = 0;

            try
            {
                //PeriodEndDisclosureDAL objPeriodEndDisclosureDAL = new PeriodEndDisclosureDAL();
                using (var objPeriodEndDisclosureDAL = new PeriodEndDisclosureDAL())
                {
                    nClosingBalance = objPeriodEndDisclosureDAL.GetClosingBalanceOfAnnualPeriod(sConnectionString, nUserInfoId, nUserInfoIdRelative, nSecurityTypeCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return nClosingBalance;
        }
        #endregion Get Closing Balance Of Annual Period

        #region Get lastest period end period code
        /// <summary>
        /// This method is used to lastest period end disclosure year code
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public int GetLastestPeriodEndPeriodCode(string sConnectionString)
        {
            int nPeriodCode = 0;

            try
            {
                //PeriodEndDisclosureDAL objPeriodEndDisclosureDAL = new PeriodEndDisclosureDAL();
                using (var objPeriodEndDisclosureDAL = new PeriodEndDisclosureDAL())
                {
                    nPeriodCode = objPeriodEndDisclosureDAL.GetLastestPeriodEndPeriodCode(sConnectionString);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return nPeriodCode;
        }
        #endregion Get lastest period end period code
       
        #region Get impact on securities held post to acquisition
        /// <summary>
        /// This method is used to get impact on securities held post to acquisition.
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="nTransTypeCodeId"></param>
        /// <param name="nModeOfAcquisCodeId"></param>      
        /// <returns></returns>
        public int GetImpactOnPostQuantity(string sConnectionString, int nTransTypeCodeId, int nModeOfAcquisCodeId, int nSecurityTypeCodeId)
        {
            int nImpactOnPostQuantity = 0;

            try
            {
                //PeriodEndDisclosureDAL objPeriodEndDisclosureDAL = new PeriodEndDisclosureDAL();
                using (var objPeriodEndDisclosureDAL = new PeriodEndDisclosureDAL())
                {
                    nImpactOnPostQuantity = objPeriodEndDisclosureDAL.GetImpactOnPostQuantity(sConnectionString, nTransTypeCodeId, nModeOfAcquisCodeId, nSecurityTypeCodeId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return nImpactOnPostQuantity;
        }
        #endregion Get impact on securities held post to acquisition

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