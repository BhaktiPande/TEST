using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class DALConstEnum:IDisposable
    {
        #region ErrorCodePrefix
        /// <summary>
        /// This class is used to define Error Code Prefix
        /// </summary>
        public class ModuleName
        {
            public const string Common = "com_";
            public const string Master = "mst_";
            public const string User = "usr_";
            public const string Notification = "not_";

        }
        #endregion ModuleName

        #region ResourceMessageType
        /// <summary>
        /// This class is used to define Error Code Prefix
        /// </summary>
        public class ResourceMessageType
        {
            public const string Label = "lbl_";
            public const string Button = "btn_";
            public const string Link = "lnk_";
            public const string Message = "msg_";
            public const string GridColHeadder = "grd_";
            public const string ToolTip = "ttp_";

        }
        #endregion ResourceMessageType

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
