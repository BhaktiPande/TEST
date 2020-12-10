using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading_NotificationService
{
    class WindowsServiceEventLog
    {
        private System.Diagnostics.EventLog m_evtLogInsiderTradingWindowsService;

        #region Constructor
        public WindowsServiceEventLog()
        {
            m_evtLogInsiderTradingWindowsService = new System.Diagnostics.EventLog();
            if (!System.Diagnostics.EventLog.SourceExists("Insider Trading  Boroadcast Service"))
                System.Diagnostics.EventLog.CreateEventSource("Insider Trading  Boroadcast Service", "Application");

            m_evtLogInsiderTradingWindowsService.Source = "Insider Trading Boroadcast Service";
            m_evtLogInsiderTradingWindowsService.Log = "Application";
        }
        #endregion

        #region Destructor
        ~WindowsServiceEventLog()
        {
            m_evtLogInsiderTradingWindowsService.Dispose();
        }
        #endregion

        public void WriteEventLog(string i_sMethodName, string i_sMessage)
        {
            try
            {
                // if WriteEventLogFlag is set , then only write EventLogs
                if (Convert.ToInt32(ConfigurationManager.AppSettings.Get(WindowServiceConstEnum.AppSettingsKey.WriteEventLogFlag)) == 1)
                {
                    m_evtLogInsiderTradingWindowsService.WriteEntry(i_sMethodName + " - " + i_sMessage);//, EventLogEntryType.Information);
                }
            }
            catch
            {
            }
        }
    }
}
