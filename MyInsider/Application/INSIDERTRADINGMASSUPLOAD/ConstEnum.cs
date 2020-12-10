    using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTradingMassUpload
{
    public class ConstEnum
    {
        #region DataFormatType
        //Define data format type.
        public enum DataFormatType
        {
            Date,
            Time12,
            DateTime,
            DateTime12,
            DateTime12_ForFileName,
            DateTime24,
            Decimal2,
            Money,
            MoneyWithOutDecimalPoint,
            StandardDate
        }
        #endregion DataFormatType

        #region TimeFormatType
        //Define data format type.
        public class TimeFormatType
        {
            public const int TIMEFORMAT_12HRS = 12;
            public const int TIMEFORMAT_24HRS = 24;
            public const int TIMEFORMAT_MIN = 60;

        }
        #endregion TimeFormatType

        #region DataFormatString
        //Stores the actual data format string required for formatting - used in the function ApplyFormatting (Common.cs)
        public class DataFormatString
        {
            public const string Date = "dd'/'MMM'/'yyyy";
            public const string Time12 = "hh:mm:ss tt";
            public const string Time24 = "hh:mm:ss";
            public const string DateTime = "dd'/'MM'/'yyyy HH:mm";
            public const string DateTime12 = "dd'/'MMM'/'yyyy hh:mm:ss tt";
            public const string DateTime12_ForFileName = "dd_MMM_yyyy hh_mm_ss tt";
            public const string DateTime24 = "dd'/'MM'/'yyyy HH:mm:ss";

            public const string DecimalFormat = "{0:0.00}";
            public const string MoneyFormat = "{0:#,##0.00}";
            public const string MoneyWithOutDecimalPointFormat = "{0}";
            public const string StandardDate = "yyyy'-'MM'-'dd";
            public const string BootstrapUIDateFormat = "dd'/'mm'/'yyyy";
            public const string BootstrapUIDateTimeFormat = "dd'/'mm'/'yyyy-hh:ii";
            public const string DateFormat = "ddd dd MMM yyyy";
        }
        #endregion DataFormatString

        #region UserTypeCodeId
        public class UserTypeCodeId
        {
            public const int Admin = 101001;
            public const int COUserType = 101002;
            public const int EmployeeType = 101003;
            public const int CorporateUserType = 101004;
            public const int SuperAdminType = 101005;
            public const int NonEmployeeType = 101006;
            public const int RelativeType = 101007;
        }
        #endregion UserTypeCodeId
    }
}