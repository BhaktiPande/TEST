using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using InsiderTrading.Common;
using InsiderTradingDAL;
namespace InsiderTrading.SL
{
    public class TradingWindowEventSL :IDisposable
    {
        #region SaveDetails
        /// <summary>
        /// This method is used for the insert/Update TradingWindowEvent Financial year details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public bool SaveDetails(string sConnectionString, DataTable db_tblTradingWindowEventType, int nFinancialPeriodTypeCodeId, int i_nLoggedInUserID)
        {
            bool bReturn = true;
            try
            {
                //TradingWindowEventDAL objTradingWindowEventDAL = new TradingWindowEventDAL();
                using (var objTradingWindowEventDAL = new TradingWindowEventDAL())
                {
                    bReturn = objTradingWindowEventDAL.SaveDetails(sConnectionString, db_tblTradingWindowEventType, nFinancialPeriodTypeCodeId, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bReturn;
        }
        #endregion SaveDetails

        #region SaveOtherEventDetails
        /// <summary>
        /// This method is used for the insert/Update TradingWindowEvent Financial year details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public TradingWindowEventDTO SaveOtherEventDetails(string sConnectionString, TradingWindowEventDTO objTradingWindowsEventDTO, int i_nLoggedInUserID)
        {
            TradingWindowEventDTO result = null;
            try
            {
                //TradingWindowEventDAL objTradingWindowEventDAL = new TradingWindowEventDAL();
                using (var objTradingWindowEventDAL = new TradingWindowEventDAL())
                {
                    result = objTradingWindowEventDAL.SaveOtherEventDetails(sConnectionString, objTradingWindowsEventDTO, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return result;
        }
        #endregion SaveOtherEventDetails

        #region DeleteOtherEventDetails
        /// <summary>
        /// This method is used for the insert/Update TradingWindowEvent Financial year details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public bool DeleteOtherEventDetails(string sConnectionString, int nTradingWindowEventId, int i_nLoggedInUserID)
        {
            bool bReturn = true;
            try
            {
                //TradingWindowEventDAL objTradingWindowEventDAL = new TradingWindowEventDAL();
                using (var objTradingWindowEventDAL = new TradingWindowEventDAL())
                {
                    bReturn = objTradingWindowEventDAL.DeleteOtherEventDetails(sConnectionString, nTradingWindowEventId, i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bReturn;
        }
        #endregion DeleteOtherEventDetails

        #region GetDetailsOtherEvent
        /// <summary>
        /// This method is used for the insert/Update TradingWindowEvent Financial year details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public TradingWindowEventDTO GetDetailsOtherEvent(string sConnectionString, int nTradingWindowEventId)
        {
            TradingWindowEventDTO res = null;
            try
            {
                //TradingWindowEventDAL objTradingWindowEventDAL = new TradingWindowEventDAL();
                using (var objTradingWindowEventDAL = new TradingWindowEventDAL())
                {
                    res = objTradingWindowEventDAL.GetDetailsOtherEvent(sConnectionString, nTradingWindowEventId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetDetailsOtherEvent

        #region GetBlockedDatesOfMonth
        /// <summary>
        /// This method is used for the insert/Update TradingWindowEvent Financial year details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public IEnumerable<DayDTO> GetBlockedDatesOfMonth(string sConnectionString, DateTime dtMonth, int nUserInfoId)
        {
            IEnumerable<DayDTO> res = null;
            try
            {
                //TradingWindowEventDAL objTradingWindowEventDAL = new TradingWindowEventDAL();
                using (var objTradingWindowEventDAL = new TradingWindowEventDAL())
                {
                    res = objTradingWindowEventDAL.GetBlockedDatesOfMonth(sConnectionString, dtMonth, nUserInfoId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetBlockedDatesOfMonth

        #region GetEventForMonth
        /// <summary>
        /// This method is used for the insert/Update TradingWindowEvent Financial year details.
        /// </summary>
        /// <param name="i_sConnectionString">Connection string</param>
        /// <param name="i_objUserInfoDTO">Role master Object</param>
        /// <returns></returns>
        public IEnumerable<EventDTO> GetEventForMonth(string sConnectionString, DateTime dtMonth)
        {
            IEnumerable<EventDTO> res = null;
            try
            {
                //TradingWindowEventDAL objTradingWindowEventDAL = new TradingWindowEventDAL();
                using (var objTradingWindowEventDAL = new TradingWindowEventDAL())
                {
                    res = objTradingWindowEventDAL.GetEventForMonth(sConnectionString, dtMonth);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetEventForMonth

        #region GetFutureBlockEvent

        public IEnumerable<BlockedEventDTO> GetFutureBlockEvent(string sConnectionString,int i_nLoggedInUserID)
        {
            IEnumerable<BlockedEventDTO> res = null;
            try
            {
                //TradingWindowEventDAL objTradingWindowEventDAL = new TradingWindowEventDAL();
                using (var objTradingWindowEventDAL = new TradingWindowEventDAL())
                {
                    res = objTradingWindowEventDAL.GetFutureBlockEvent(sConnectionString,i_nLoggedInUserID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetFutureBlockEvent

        #region GetCurrentEvent
        public EventDTO GetCurrentEvent(string sConnectionString,int UserInfoID=0)
        {
            EventDTO res = null;
            try
            {
                //TradingWindowEventDAL objTradingWindowEventDAL = new TradingWindowEventDAL();
                using (var objTradingWindowEventDAL = new TradingWindowEventDAL())
                {
                    res = objTradingWindowEventDAL.GetCurrentEvent(sConnectionString, UserInfoID);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetEventForMonth

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