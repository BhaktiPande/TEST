using InsiderTrading_NotificationService.Interface;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.ServiceProcess;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace InsiderTrading_NotificationService
{
    public partial class InsiderTradingNotificationService : ServiceBase
    {
        private Thread m_thrBroadcastNotification = null;
        bool m_bIsServiceStopped = true;
        private WindowsServiceEventLog m_objWindowsServiceEventLog = null;
        string log = "";
        public InsiderTradingNotificationService()
        {   
            InitializeComponent();


            WindowServiceCommon.WriteErrorLog("INFO : Initialize Notification Service...........");

            m_objWindowsServiceEventLog = new WindowsServiceEventLog();
        }

        protected override void OnStart(string[] args)
        {

            //For Testing 

            //while (!Debugger.IsAttached)
            //{
            //    Thread.Sleep(1000);
          //  }
            m_bIsServiceStopped = false;
            m_thrBroadcastNotification = new Thread(new ThreadStart(BeginBroadcastProcess));
            m_thrBroadcastNotification.Start();
            

            WindowServiceCommon.WriteErrorLog("INFO : Thread started successfully...........");

            #region Event Log Start
            m_objWindowsServiceEventLog.WriteEventLog(MethodBase.GetCurrentMethod().ReflectedType.Name + "::" + MethodBase.GetCurrentMethod().Name, "ReminderService Started");
            #endregion
           
        }

        protected override void OnStop()
        {
            try
            {
                #region Event Log Start
                m_objWindowsServiceEventLog.WriteEventLog(MethodBase.GetCurrentMethod().ReflectedType.Name + "::" + MethodBase.GetCurrentMethod().Name, "ReminderService Stopped");
                #endregion

                m_bIsServiceStopped = true;
                Environment.Exit(-1);

                WindowServiceCommon.WriteErrorLog("INFO :Thread Stoped successfully...........");
            }
            catch (Exception exp)
            {
                #region Event Log
                m_objWindowsServiceEventLog.WriteEventLog(MethodBase.GetCurrentMethod().ReflectedType.Name + "::" + MethodBase.GetCurrentMethod().Name,
                    "Error while stoping Insider Trading Windows Broadcast Service." + exp.Message + ":" + exp.StackTrace);
                #endregion

                WindowServiceCommon.WriteErrorLog("ERROR: " + MethodBase.GetCurrentMethod() + " " + exp.Message);

            }
        }

        #region BeginBroadcastProcess
        /// <summary>
        /// Process will start
        /// </summary>
        private void BeginBroadcastProcess()
        {
            #region Varible Declaration
            EmailSend objBroadcastService = null;
            int nEmailServicePollTime = Convert.ToInt32(ConfigurationManager.AppSettings.Get(WindowServiceConstEnum.AppSettingsKey.ServicePollTime).ToString());//eTravelSEA_WinService.WindowsServiceConstEnum.GlobalValues.ServicePollTime;//This is the default poll time in hours
            int nServicePollTimeUnit = Convert.ToInt32(ConfigurationManager.AppSettings.Get(WindowServiceConstEnum.AppSettingsKey.ServicePollTimeUnit).ToString());//eTravelSEA_WinService.WindowsServiceConstEnum.GlobalValues.ServicePollTimeUnit;//This is the default poll time in hours
            int nServicePollTimeMilliSeconds = 10000;
            string dateFormat = string.Empty;
            #endregion Varible Declaration

            try
            {
                nServicePollTimeMilliSeconds = WindowServiceCommon.GetTimeDurationInMilliSeconds(nEmailServicePollTime, (WindowServiceConstEnum.TimeDurationType)nServicePollTimeUnit);
                WindowServiceCommon.WriteErrorLog("INFO: Before the while loop......" + Convert.ToString(nServicePollTimeMilliSeconds) + ":" + Convert.ToString(m_bIsServiceStopped));
                while (!this.m_bIsServiceStopped)
                {
                    #region Event Log Start
                    m_objWindowsServiceEventLog.WriteEventLog(MethodBase.GetCurrentMethod().ReflectedType.Name + "::" + MethodBase.GetCurrentMethod().Name, "The thread for Reminder Service has started.");
                    #endregion

                    WindowServiceCommon.WriteErrorLog("INFO: Begin Boradcast Prccess Start");

                    objBroadcastService = new EmailSend();

                    try
                    {
                        objBroadcastService.broadCast();
                    }
                    catch (Exception exp)
                    {
                       WindowServiceCommon.WriteErrorLog("ERROR: Error occurred while broadcasting. " + exp.Message);
                    }

                    WindowServiceCommon.WriteErrorLog("INFO: Begin Boradcast Prcess End");

                    WindowServiceCommon.WriteErrorLog("INFO: Thread Sleeps for : -" + nServicePollTimeMilliSeconds + " MiliSeconds");

                    Thread.Sleep(nServicePollTimeMilliSeconds);

                    WindowServiceCommon.WriteErrorLog("INFO: ================================================================================================");

                    WindowServiceCommon.WriteErrorLog("INFO: Thread Start again after sleep......");

                    #region Event Log
                    m_objWindowsServiceEventLog.WriteEventLog(MethodBase.GetCurrentMethod().ReflectedType.Name + "::" + MethodBase.GetCurrentMethod().Name,
                        "Thread Sleep for:- " + nServicePollTimeMilliSeconds + " MiliSeconds");
                    #endregion

                    objBroadcastService = null;
                }
               
            }
            catch (Exception exp)
            {
                if (m_objWindowsServiceEventLog != null)
                {

                    WindowServiceCommon.WriteErrorLog("ERROR: "+ MethodBase.GetCurrentMethod() + " " + exp.Message);

                    #region Event Log
                    m_objWindowsServiceEventLog.WriteEventLog(MethodBase.GetCurrentMethod().ReflectedType.Name + "::" + MethodBase.GetCurrentMethod().Name,
                        "Error while intializing Broadcast Service." + exp.Message + ":" + exp.StackTrace);
                    #endregion

                    #region Event Log Start
                    m_objWindowsServiceEventLog.WriteEventLog(MethodBase.GetCurrentMethod().ReflectedType.Name + "::" + MethodBase.GetCurrentMethod().Name, "ReminderService Stopped");
                    #endregion

                }
                // If Unhandled Exception occur the Service will stop....
                m_bIsServiceStopped = true;
                Environment.Exit(-1);

                WindowServiceCommon.WriteErrorLog("INFO :Thread stoped by unhandled error...........");


            }
            finally
            {
                if (objBroadcastService != null)
                {
                    objBroadcastService = null;
                }
              
            }
        }
        #endregion BeginBroadcastProcess
    }
}
