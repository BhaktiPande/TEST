using InsiderTradingDAL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Globalization;
using System.Net.Mail;
using System.Reflection;
using System.Web;
using System.Linq;
using InsiderTradingMassUpload;

namespace InsiderTradingMassUpload
{
    public class Common
    {
        

        #region CopyObjectPropertyByName
        /// <summary>
        /// This function will be used for copying the properties from objSource object to objDestination object. 
        /// The properties with same anmes in both the objects will be copied.
        /// </summary>
        /// <param name="objSource">Object from which the properties should be copied</param>
        /// <param name="objDestination">Object to which the same named properties will get copied to</param>
        /// <returns></returns>
        public static Object CopyObjectPropertyByName(object objSource, object objDestination)
        {
            try
            {
                var sourceType = objSource.GetType();
                var targetType = objDestination.GetType();

                foreach (var property in sourceType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
                {
                    var targetProperty = targetType.GetProperty(property.Name, BindingFlags.Public | BindingFlags.Instance);
                    if (targetProperty != null
                         && targetProperty.CanWrite)
                    //&& targetProperty.IsAssignableFrom(property.PropertyType))
                    {
                        targetProperty.SetValue(objDestination, property.GetValue(objSource, null), null);
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objDestination;
        }
        #endregion CopyObjectPropertyByName

        #region Convert To String
        /// <summary>
        /// This method is used to Convert value into String.
        /// </summary>
        /// <param name="i_objValue"></param>
        /// <returns></returns>
        public static string ConvertToString(object i_objValue)
        {
            string sReturnValue = "";
            try
            {
                if (i_objValue != null && i_objValue.ToString().Trim() != "")
                {
                    //convert to string.
                    sReturnValue = i_objValue.ToString().Trim();
                }
                else
                {
                    sReturnValue = "";
                }
            }
            catch
            {
                sReturnValue = "";
            }
            return sReturnValue;
        }
        #endregion Convert To String

        #region Convert To Int32
        /// <summary>
        /// This method is used to Convert value into Int32.
        /// </summary>
        /// <param name="i_objValue"></param>
        /// <returns></returns>
        public static int ConvertToInt32(object i_objValue)
        {
            int nReturnValue = 0;
            try
            {
                if (i_objValue != null && i_objValue.ToString().Trim() != "")
                {
                    //convert to Int32.
                    nReturnValue = Convert.ToInt32(i_objValue.ToString().Trim());
                }
                else
                {
                    nReturnValue = 0;
                }
            }
            catch
            {
                nReturnValue = 0;
            }
            return nReturnValue;
        }
        #endregion Convert To Int32

        #region Convert To Int64
        /// <summary>
        /// This method is used to Convert value into Int64.
        /// </summary>
        /// <param name="i_objValue"></param>
        /// <returns></returns>
        public static Int64 ConvertToInt64(object i_objValue)
        {
            Int64 nReturnValue = 0;
            try
            {
                if (i_objValue != null && i_objValue.ToString().Trim() != "")
                {
                    //convert to Int32.
                    nReturnValue = Convert.ToInt64(i_objValue.ToString().Trim());
                }
                else
                {
                    nReturnValue = 0;
                }
            }
            catch
            {
                nReturnValue = 0;
            }
            return nReturnValue;
        }
        #endregion Convert To Int64

        #region Convert To Double
        /// <summary>
        /// This method is used to Convert value into Double.
        /// </summary>
        /// <param name="i_objValue"></param>
        /// <returns></returns>
        public static double ConvertToDouble(object i_objValue)
        {
            double dReturnValue = 0;
            try
            {
                if (i_objValue != null && i_objValue.ToString().Trim() != "")
                {
                    //convert to Int32.
                    dReturnValue = Convert.ToDouble(i_objValue.ToString().Trim());
                }
                else
                {
                    dReturnValue = 0;
                }
            }
            catch
            {
                dReturnValue = 0;
            }
            return dReturnValue;
        }
        #endregion Convert To Double

        #region Convert To Decimal
        /// <summary>
        /// This method is used to Convert value into Decimal.
        /// </summary>
        /// <param name="i_objValue"></param>
        /// <returns></returns>
        public static decimal ConvertToDecimal(object i_objValue)
        {
            decimal dReturnValue = 0;
            try
            {
                if (i_objValue != null && i_objValue.ToString().Trim() != "")
                {
                    //convert to Int32.
                    dReturnValue = Convert.ToDecimal(i_objValue.ToString().Trim());
                }
                else
                {
                    dReturnValue = 0;
                }
            }
            catch
            {
                dReturnValue = 0;
            }
            return dReturnValue;
        }
        #endregion Convert To Decimal

        #region Convert To boolean
        /// <summary>
        /// This method is used to Convert value into boolean.
        /// </summary>
        /// <param name="i_objValue"></param>
        /// <returns></returns>
        public static bool ConvertToBoolean(object i_objValue)
        {
            bool bReturnValue = false;
            try
            {
                if (i_objValue != null && i_objValue.ToString().Trim() != "")
                {
                    //convert to bool.
                    bReturnValue = Convert.ToBoolean(i_objValue.ToString().Trim());
                }
                else
                {
                    bReturnValue = false;
                }
            }
            catch
            {
                bReturnValue = false;
            }
            return bReturnValue;
        }
        #endregion Convert To boolean

        #region GetCurrentDate
        /// <summary>
        /// This method is used to get current DB date or date time
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="bDateWithTimestamp"></param>
        /// <param name="sLookupPrefix"></param>
        /// <returns></returns>
        public static DateTime GetCurrentDate(string i_sConnectionString, bool bDateWithTimestamp = false, string sLookupPrefix = "usr_com_")
        {
            DateTime currentDBDate;

            try
            {
                CommonDAL objCommonDal = new CommonDAL();
                currentDBDate = objCommonDal.GetCurrentDate(i_sConnectionString, bDateWithTimestamp, sLookupPrefix);
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return currentDBDate;
        }
        #endregion GetCurrentDate

        #region SubstringTillInstanceOf
        /// <summary>
        /// This function will be used for finding a substring for a delimitter string till the instance number given.
        /// Eg. If we have a string like 2.1.3.4 and if requested to get substring till second instance of '.', then this function will
        /// return 2.1, if requested till third instance then it will return 2.1.3
        /// </summary>
        /// <param name="i_sInputString"></param>
        /// <param name="i_sDelimitter"></param>
        /// <returns></returns>
        public static string SubstringTillInstanceOf(string i_sInputString, char i_sDelimitter , int i_nInstanceTillToTake){
            string[] inputStringParts = i_sInputString.Split(i_sDelimitter);
            string o_sOutputString = "";
            for (int counter = 0; counter < i_nInstanceTillToTake; counter++)
            {
                if (o_sOutputString != "")
                    o_sOutputString = o_sOutputString + ".";
                o_sOutputString += inputStringParts[counter];
            }
            return o_sOutputString;
        }
        #endregion SubstringTillInstanceOf

        /// <summary>
        /// This function will be used for creating the encrypted url to be used for change/forgot password to be used by user.
        /// </summary>
        /// <param name="i_sSelectedcompanyConnectionString"></param>
        /// <param name="i_nLoginId"></param>
        /// <param name="i_sCompanyId"></param>
        /// <returns></returns>
        public static bool CreateForgetPasswordHashLink(string i_sSelectedcompanyConnectionString, string i_sLoginName, string i_sUserEmailId, string i_sCompanyId, string i_sSaltValue)
        {
            PasswordManagementDTO objPwdMgmtDTO = new PasswordManagementDTO();
            UserInfoSL objUserInfoSL = new UserInfoSL();
            bool bReturn = false;
            InsiderTradingEncryption.DataSecurity objPwdHash = new InsiderTradingEncryption.DataSecurity();
            string sHashCode = "";
            try
            {
                sHashCode = objPwdHash.CreateHash(i_sLoginName.ToString() + i_sCompanyId, i_sSaltValue);

                objPwdMgmtDTO.CompanyID = i_sCompanyId;
                objPwdMgmtDTO.LoginID = i_sLoginName;
                objPwdMgmtDTO.EmailID = i_sUserEmailId;
                objPwdMgmtDTO.HashValue = sHashCode;
                
                objPwdMgmtDTO = objUserInfoSL.ForgetPassword(i_sSelectedcompanyConnectionString, objPwdMgmtDTO);
                bReturn = true;
            }
            catch (Exception exp)
            {

            }
            return bReturn;
        }

        #region ApplyFormatting
        /// <summary>
        /// This method is used to get the formatted data.
        /// </summary>
        /// <param name="i_oValue"></param>
        /// <param name="i_enDataFormatType"></param>
        /// <returns></returns>
        public static string ApplyFormatting(object i_oValue, ConstEnum.DataFormatType i_enDataFormatType)
        {
            DateTime dt;
            string sFormattedString = "";
            double dMoney;
            try
            {
                switch (i_enDataFormatType)
                {
                    case ConstEnum.DataFormatType.Date:
                        if (i_oValue != null && i_oValue != System.DBNull.Value)
                        {
                            dt = Convert.ToDateTime(i_oValue);
                            sFormattedString = dt.ToString(ConstEnum.DataFormatString.Date).ToString().ToUpper();
                            //sFormattedString = dt.ToString(System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.ShortDatePattern);
                            break;
                        }
                        break;

                    case ConstEnum.DataFormatType.DateTime:
                        if (i_oValue != null && i_oValue != System.DBNull.Value)
                        {
                            dt = Convert.ToDateTime(i_oValue);
                            sFormattedString = dt.ToString(ConstEnum.DataFormatString.DateTime);
                            //sFormattedString = dt.ToString(System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.ShortTimePattern);
                            break;
                        }
                        break;

                    case ConstEnum.DataFormatType.Time12:
                        if (i_oValue != null && i_oValue != System.DBNull.Value)
                        {
                            dt = Convert.ToDateTime(i_oValue);
                            sFormattedString = dt.ToString(ConstEnum.DataFormatString.Time12);
                        }
                        break;

                    case ConstEnum.DataFormatType.DateTime12:
                        dt = Convert.ToDateTime(i_oValue);
                        sFormattedString = dt.ToString(ConstEnum.DataFormatString.DateTime12).ToString().ToUpper();
                        break;

                    case ConstEnum.DataFormatType.DateTime12_ForFileName:
                        dt = Convert.ToDateTime(i_oValue);
                        sFormattedString = dt.ToString(ConstEnum.DataFormatString.DateTime12_ForFileName).ToString().ToUpper();
                        break;

                    case ConstEnum.DataFormatType.DateTime24:
                        if (i_oValue != null && i_oValue != System.DBNull.Value)
                        {
                            dt = Convert.ToDateTime(i_oValue);
                            sFormattedString = dt.ToString(ConstEnum.DataFormatString.DateTime24);
                        }
                        break;

                    case ConstEnum.DataFormatType.Decimal2:
                        if (i_oValue != null && i_oValue != System.DBNull.Value)
                        {
                            sFormattedString = string.Format(ConstEnum.DataFormatString.DecimalFormat, i_oValue);
                        }
                        break;

                    case ConstEnum.DataFormatType.Money:
                        dMoney = Common.ConvertToDouble(i_oValue);
                        sFormattedString = string.Format(ConstEnum.DataFormatString.MoneyFormat, dMoney);
                        break;

                    case ConstEnum.DataFormatType.MoneyWithOutDecimalPoint:
                        dMoney = Common.ConvertToDouble(i_oValue);
                        sFormattedString = string.Format(ConstEnum.DataFormatString.MoneyWithOutDecimalPointFormat, dMoney);
                        break;
                    case ConstEnum.DataFormatType.StandardDate:
                        dt = Convert.ToDateTime(i_oValue);
                        sFormattedString = dt.ToString(ConstEnum.DataFormatString.StandardDate);
                        break;
                    default:
                        sFormattedString = Convert.ToString(i_oValue);
                        break;
                }
            }
            catch
            {
                sFormattedString = Convert.ToString(i_oValue);
            }
            return sFormattedString;
        }
        #endregion ApplyFormatting

    }
}