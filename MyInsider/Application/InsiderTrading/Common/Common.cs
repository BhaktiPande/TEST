using InsiderTrading.Models;
using InsiderTrading.SL;
using InsiderTradingDAL;
using InsiderTradingEncryption;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Configuration;
using System.Web.Helpers;
using System.Web.Mvc;
using System.Web.Routing;

namespace InsiderTrading.Common
{
    public class Common
    {

        #region Can Perform Action
        /// <summary>
        /// This function will check if the login user has access to the activity with given activity id defined in the 
        /// constenum UserAction.
        /// </summary>
        /// <param name="i_nUserAction"></param>
        /// <returns>
        /// true: User can perform the action/activity
        /// false: User doesnot have permission to perform the action/activity
        /// </returns>
        public static bool CanPerform(int i_nUserAction)
        {
            bool bReturn = false;
            List<int> lstApplicationActionIds = null;
            LoginUserDetails objLoginUserDetails = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (objLoginUserDetails != null)
                {
                    lstApplicationActionIds = objLoginUserDetails.AuthorisedActionId;
                    if (lstApplicationActionIds.Contains(i_nUserAction))
                    {
                        bReturn = true;
                    }
                }
            }
            catch (Exception exp)
            {

            }
            finally
            {
                lstApplicationActionIds = null;
                objLoginUserDetails = null;
            }

            return bReturn;
        }
        #endregion Can Perform Action

        #region IsEditable
        public static RouteValueDictionary IsEditable(string i_sResourceKey, string i_sActivityResourceKey, object htmlAttributes = null, int flag = 0, int NonEmployeeFlag = 0)
        {
            RouteValueDictionary dictionary = new RouteValueDictionary();
            bool chkFlag = false;

            LoginUserDetails objLoginUserDetails = null;
            Dictionary<string, List<ActivityResourceMappingDTO>> dicActivityResourceMappingDTO = null;
            List<ActivityResourceMappingDTO> lstActivityResourceMappingDTO = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (objLoginUserDetails != null && objLoginUserDetails.ActivityResourceMapping.Count > 0)
                {
                    dicActivityResourceMappingDTO = objLoginUserDetails.ActivityResourceMapping;

                    if (dicActivityResourceMappingDTO.ContainsKey(i_sResourceKey))
                    {
                        lstActivityResourceMappingDTO = dicActivityResourceMappingDTO[i_sResourceKey];

                        foreach (ActivityResourceMappingDTO objActivityResourceMappingDTO in lstActivityResourceMappingDTO)
                        {
                            //check resouce key -- for there may be multiple key with same column name
                            if (i_sActivityResourceKey == objActivityResourceMappingDTO.ResourceKey)
                            {
                                if (objActivityResourceMappingDTO.IsForRelative == flag)
                                {
                                    chkFlag = true;
                                    if (NonEmployeeFieldDisable(i_sResourceKey, NonEmployeeFlag))
                                    {
                                        dictionary.Remove("disabled");
                                        dictionary.Remove("required");
                                        dictionary.Remove("data-val-required");
                                    }
                                    else
                                    {
                                        if (objActivityResourceMappingDTO.MandatoryFlag == ConstEnum.ResourceManditoryCode.Manditory)
                                        {
                                            dictionary.Add("required", "required");
                                            dictionary.Add("data-val-required", "The " + InsiderTrading.Common.Common.getResource(objActivityResourceMappingDTO.ResourceKey) + " is required.");
                                            dictionary.Add("data-val", "true");
                                        }
                                        else
                                        {
                                            dictionary.Remove("required");
                                            dictionary.Remove("data-val-required");

                                        }
                                        if (objActivityResourceMappingDTO.EditFlag == ConstEnum.ResourceEditableCode.Editable)
                                        {
                                            dictionary.Remove("disabled");
                                        }
                                        else
                                        {
                                            dictionary.Add("disabled", "disabled");
                                        }
                                    }
                                }
                            }
                        }
                        if (!chkFlag)
                        {
                            dictionary.Add("disabled", "disabled");
                            dictionary.Remove("required");
                            dictionary.Remove("data-val-required");
                        }
                    }
                    else
                    {
                        dictionary.Add("disabled", "disabled");
                        dictionary.Remove("required");
                        dictionary.Remove("data-val-required");
                    }
                }
                else
                {
                    dictionary.Add("disabled", "disabled");
                    dictionary.Remove("required");
                    dictionary.Remove("data-val-required");
                }
                foreach (PropertyInfo property in htmlAttributes.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance))
                {
                    if (property.Name.Contains("class"))
                    {
                        dictionary["class"] += " " + property.GetValue(htmlAttributes, null);
                    }
                    else if (property.Name.Contains("style"))
                    {
                        dictionary["style"] += " " + property.GetValue(htmlAttributes, null);
                    }
                    else
                    {
                        if (!dictionary.ContainsKey(property.Name))
                            dictionary.Add(property.Name, property.GetValue(htmlAttributes, null));
                    }
                }
            }
            catch (Exception exp)
            {

            }
            finally
            {
                objLoginUserDetails = null;
                dicActivityResourceMappingDTO = null;
                lstActivityResourceMappingDTO = null;
            }
            return dictionary;
        }
        #endregion IsEditable

        #region NonEmployeeFieldDisable
        /// <summary>        /// 
        /// </summary>
        /// <param name="i_sResourceKey"></param>
        /// <returns></returns>
        public static bool NonEmployeeFieldDisable(string i_sResourceKey, int NonEmployeeFlag)
        {
            bool bReturnValue = false;

            List<string> arrDisabledField = new List<string>();
            //arrDisabledField.Add("Category");
            //arrDisabledField.Add("SubCategory");
            ////arrDisabledField.Add("GradeId");
            //arrDisabledField.Add("DesignationId");
            //arrDisabledField.Add("SubDesignationId");
            //arrDisabledField.Add("Location");
            //arrDisabledField.Add("DepartmentId");

            LoginUserDetails objLoginUserDetails = null;
            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (NonEmployeeFlag == 1)
                {
                    if (arrDisabledField.Contains(i_sResourceKey))
                    {
                        bReturnValue = true;
                    }
                }

            }
            catch (Exception exp)
            {
                // throw exp;
            }
            finally
            {
                objLoginUserDetails = null;
                arrDisabledField = null;
            }
            return bReturnValue;
        }
        #endregion NonEmployeeFieldDisable

        #region Get Resource Message
        /// <summary>
        /// This function is used for fetching the resource message, for given resource key, from the contect collection.
        /// This function will fetch the company for the login user from the session and based on the company will fetch 
        /// the resource from corresponding company database. If resource is not found then it returns empty string.
        /// The resource string can be only the resource code whthout the code or else with the prefix for the code.
        /// </summary>
        /// <param name="i_sResourceKey"></param>
        /// <returns></returns>
        public static string getResource(string i_sResourceKey)
        {
            string sResourceMessage = "";
            string sOriginalResourceKey = i_sResourceKey;

            LoginUserDetails objLoginUserDetails = null;
            Dictionary<string, string> lstResourcesList = null;
            Dictionary<string, string> objSelectedDict = null;
            List<string> lstValue = null;

            try
            {
                if (i_sResourceKey != null)
                {
                    if (i_sResourceKey.Contains("_"))
                        i_sResourceKey = i_sResourceKey.Substring(i_sResourceKey.LastIndexOf("_") + 1);

                    objLoginUserDetails = (LoginUserDetails)Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                    string sCompanyName = "";
                    if (objLoginUserDetails != null)
                    {
                        sCompanyName = objLoginUserDetails.CompanyName;
                    }
                    else
                    {
                        //sCompanyName = "KPCS_InsiderTrading_Company1";
                        return "";
                    }

                    lstResourcesList = (Dictionary<string, string>)HttpContext.Current.Application.Get(sCompanyName);

                    if (lstResourcesList != null)
                    {
                        if (lstResourcesList.Any(kvp => kvp.Key.Contains(i_sResourceKey)))
                        {
                            objSelectedDict = lstResourcesList.Where(kvp => kvp.Key.Contains(i_sResourceKey)).ToDictionary(kvp => kvp.Key, kvp => kvp.Value);

                            lstValue = objSelectedDict.Values.ToList();

                            sResourceMessage = lstValue[0];
                        }
                        else
                        {
                            sResourceMessage = "";
                            //throw new Exception("Resource not available for company " + sCompanyName + " for resource key " + i_sResourceKey);
                        }

                    }
                }
            }
            catch (Exception exp)
            {
                // throw exp;
            }
            finally
            {
                objLoginUserDetails = null;
                lstResourcesList = null;
                objSelectedDict = null;
                lstValue = null;
            }
            return sResourceMessage;
        }
        #endregion Get Resource Message

        #region Get Resource Message For Selected Company
        /// <summary>
        /// This function is used for fetching the resource message, for given resource key for given company name, from the contect collection.
        /// This function will fetch resource based on the company provided the resource from corresponding company database. 
        /// If resource is not found then it returns empty string.
        /// The resource string can be only the resource code whthout the code or else with the prefix for the code.
        /// This function can be used when fetching resources for the selected company when user is not logged in.
        /// </summary>
        /// <param name="i_sResourceKey"></param>
        /// <returns></returns>
        public static string getResourceForGivenCompany(string i_sResourceKey, string i_sCompanyName)
        {
            string sResourceMessage = "";
            string sOriginalResourceKey = i_sResourceKey;

            Dictionary<string, string> lstResourcesList = null;
            Dictionary<string, string> objSelectedDict = null;
            List<string> lstValue = null;

            CompanyDTO objSelectedCompany = null;
            try
            {
                if (i_sCompanyName == null || i_sCompanyName == "")
                    return sResourceMessage;

                if (i_sResourceKey != null && i_sResourceKey != "")
                {
                    if (i_sResourceKey.Contains("_"))
                        i_sResourceKey = i_sResourceKey.Substring(i_sResourceKey.LastIndexOf("_") + 1);

                    lstResourcesList = (Dictionary<string, string>)HttpContext.Current.Application.Get(i_sCompanyName);

                    if (lstResourcesList != null)
                    {
                        if (lstResourcesList.Any(kvp => kvp.Key.Contains(i_sResourceKey)))
                        {
                            objSelectedDict = lstResourcesList.Where(kvp => kvp.Key.Contains(i_sResourceKey)).ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
                            lstValue = objSelectedDict.Values.ToList();
                            sResourceMessage = lstValue[0];
                        }
                        else
                        {
                            sResourceMessage = "";
                            //throw new Exception("Resource not available for company " + sCompanyName + " for resource key " + i_sResourceKey);
                        }

                    }

                    //Second attempt to update resources and searh resource
                    //If the resource message is not found in the Context against the given Company name then a second attempt will be made to refresh the
                    //company resource collection in context and again the message is tried to be fetched.
                    if (sResourceMessage == "")
                    {
                        using (CompaniesSL objCompaniesSL = new CompaniesSL())
                        {
                            objSelectedCompany = objCompaniesSL.getSingleCompanies(Common.getSystemConnectionString(), i_sCompanyName);
                        }

                        UpdateCompanyResources(objSelectedCompany.sCompanyConnectionString, i_sCompanyName);

                        lstResourcesList = (Dictionary<string, string>)HttpContext.Current.Application.Get(i_sCompanyName);

                        if (lstResourcesList != null)
                        {
                            if (lstResourcesList.Any(kvp => kvp.Key.Contains(i_sResourceKey)))
                            {
                                objSelectedDict = lstResourcesList.Where(kvp => kvp.Key.Contains(i_sResourceKey)).ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
                                lstValue = objSelectedDict.Values.ToList();
                                sResourceMessage = lstValue[0];
                            }
                            else
                            {
                                sResourceMessage = "";
                                //throw new Exception("Resource not available for company " + sCompanyName + " for resource key " + i_sResourceKey);
                            }
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                // throw exp;
            }
            finally
            {
                objSelectedCompany = null;
                lstResourcesList = null;
                objSelectedDict = null;
                lstValue = null;
            }
            return sResourceMessage;
        }
        #endregion Get Resource Message For Selected Company

        #region GetResourceMessage With Arguments
        /// <summary>
        /// This function is used for fetching the resource message, for given resource key, from the contect collection.
        /// This function will fetch the company for the login user from the session and based on the company will fetch 
        /// the resource from corresponding company database. If resource is not found then it returns empty string.
        /// And Main If you pass arguments then argument replace by string.
        /// </summary>
        /// <param name="i_nErrorCode"></param>
        public static string getResource(string i_sResourcesKey, ArrayList i_lstArguments)
        {

            string sResourceMessage = "";

            LoginUserDetails objLoginUserDetails = null;
            Dictionary<string, string> lstResourcesList = null;
            try
            {
                if (i_sResourcesKey != "")
                {
                    objLoginUserDetails = (LoginUserDetails)Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                    string sCompanyName = "";
                    if (objLoginUserDetails != null)
                    {
                        sCompanyName = objLoginUserDetails.CompanyName;
                    }
                    else
                    {
                        //sCompanyName = "KPCS_InsiderTrading_Company1";
                        return "";
                    }

                    lstResourcesList = (Dictionary<string, string>)HttpContext.Current.Application.Get(sCompanyName);

                    if (lstResourcesList != null)
                    {
                        if (lstResourcesList.ContainsKey(i_sResourcesKey))
                            sResourceMessage = lstResourcesList[i_sResourcesKey];
                        else
                        {
                            sResourceMessage = "";
                            //throw new Exception("Resource not available for company " + sCompanyName + " for resource key " + i_sResourceKey);
                        }

                    }

                    //  sResourceMessage = i_sResourcesKey;

                    for (int nCounter = 0; nCounter < i_lstArguments.Count; nCounter++)
                    {
                        sResourceMessage = sResourceMessage.Replace("$" + Convert.ToString(nCounter + 1), Convert.ToString(i_lstArguments[nCounter]));
                    }

                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                objLoginUserDetails = null;
                lstResourcesList = null;
            }
            return sResourceMessage;
        }
        #endregion GetResourceMessage With Arguments

        #region Encrypt Data
        /// <summary>
        /// This method is used for encrypting the data using the encryption mentioned in the Web.config file
        /// </summary>
        /// <param name="i_sString"></param>
        /// <param name="o_sEncryptedString"></param>
        /// <returns></returns>
        public static bool encryptData(string i_sString, out string o_sEncryptedString)
        {
            bool bReturn = false;
            o_sEncryptedString = "";
            string sEncryptionKey = "";
            try
            {
                InsiderTradingEncryption.DataSecurity objDataSecurity = new InsiderTradingEncryption.DataSecurity();

                sEncryptionKey = System.Configuration.ConfigurationManager.AppSettings["EncryptionString"];
                if (sEncryptionKey == null)
                {
                    objDataSecurity.SymmetricEncryption(i_sString, out o_sEncryptedString);
                }
                else
                {
                    objDataSecurity.SymmetricEncryption(i_sString, sEncryptionKey, out o_sEncryptedString);
                }


                bReturn = true;
            }
            catch (Exception exp)
            {
                bReturn = false;
            }
            return bReturn;
        }
        #endregion Encrypt Data

        #region Dencrypt Data
        /// <summary>
        /// This method is used for encrypting the data using the encryption mentioned in the Web.config file
        /// </summary>
        /// <param name="i_sEncryptedString"></param>
        /// <param name="o_sDencryptedString"></param>
        /// <returns></returns>
        public static bool dencryptData(string i_sEncryptedString, out string o_sDencryptedString)
        {
            bool bReturn = false;
            o_sDencryptedString = "";
            string sEncryptionKey = "";
            try
            {
                InsiderTradingEncryption.DataSecurity objDataSecurity = new InsiderTradingEncryption.DataSecurity();

                sEncryptionKey = System.Configuration.ConfigurationManager.AppSettings["EncryptionString"];
                if (sEncryptionKey == null)
                {
                    objDataSecurity.SymmetricDecryption(i_sEncryptedString, out o_sDencryptedString);
                }
                else
                {
                    objDataSecurity.SymmetricDecryption(i_sEncryptedString, sEncryptionKey, out o_sDencryptedString);
                }

                bReturn = true;
            }
            catch (Exception exp)
            {
                bReturn = false;
            }
            return bReturn;
        }
        #endregion Dencrypt Data

        #region getSystemConnectionString
        /// <summary>
        /// This function will return the Connection string for the system database which is mentioned in the Web.config file
        /// </summary>
        /// <returns></returns>
        public static string getSystemConnectionString()
        {
            Common.WriteLogToFile("GetSystemConnectionString method called ", System.Reflection.MethodBase.GetCurrentMethod());
            string sSystemDBConnectionString = "";
            try
            {
                using (DataSecurity datasecurity = new DataSecurity())
                {
                    Common.WriteLogToFile("Before connection string ", System.Reflection.MethodBase.GetCurrentMethod());
                    //sSystemDBConnectionString = datasecurity.DecryptData(System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
                    Common.WriteLogToFile("Before decrypt connection strng " + System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString(), System.Reflection.MethodBase.GetCurrentMethod());
                    sSystemDBConnectionString = datasecurity.DecryptData(System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
                    Common.WriteLogToFile("After Connection string " + sSystemDBConnectionString.ToString(), System.Reflection.MethodBase.GetCurrentMethod());
                }
            }
            catch (Exception exp)
            {
                Common.WriteLogToFile("caught exception while getting connection string ", System.Reflection.MethodBase.GetCurrentMethod(), exp);
            }

            return sSystemDBConnectionString;
        }
        #endregion getSystemConnectionString

        #region Get Session Value
        /// <summary>
        /// This method is used to Get Session Value.
        /// </summary>
        /// <param name="i_sSessionKey"></param>
        /// <returns>Value of Session Key</returns>
        public static object GetSessionValue(string i_sSessionKey)
        {
            object sSessionValue = "";
            try
            {
                sSessionValue = HttpContext.Current.Session[i_sSessionKey];
            }
            catch
            {
                sSessionValue = null;
            }
            return sSessionValue;
        }

        #endregion Get Session Value

        #region Set Session Value
        /// <summary>
        /// This method is used to Set value into session.
        /// </summary>
        /// <param name="i_SessionKey"></param>
        /// <param name="i_sSessionValue"></param>
        public static void SetSessionValue(string i_sSessionKey, object i_sSessionValue)
        {
            try
            {
                HttpContext.Current.Session[i_sSessionKey] = i_sSessionValue;
            }
            catch
            {
            }
        }

        #endregion Set Session Value

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

        #region CopyObjectPropertyByNameAndActivity
        public static Object CopyObjectPropertyByNameAndActivity(object objSource, object objDestination, int flag = 0)
        {
            LoginUserDetails objLoginUserDetails = null;
            Dictionary<string, List<ActivityResourceMappingDTO>> dicActivityResourceMappingDTO = null;
            List<ActivityResourceMappingDTO> lstActivityResourceMappingDTO = null;

            try
            {
                objLoginUserDetails = (LoginUserDetails)Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);

                if (objLoginUserDetails != null && objLoginUserDetails.ActivityResourceMapping.Count > 0)
                {
                    dicActivityResourceMappingDTO = objLoginUserDetails.ActivityResourceMapping;

                    var sourceType = objSource.GetType();
                    var targetType = objDestination.GetType();

                    foreach (var property in sourceType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
                    {
                        if (property.Name == "SubmittedRole")
                        {
                            if (dicActivityResourceMappingDTO.ContainsKey("UserRoleId"))
                            {
                                lstActivityResourceMappingDTO = dicActivityResourceMappingDTO["UserRoleId"];

                                foreach (ActivityResourceMappingDTO objActivityResourceMappingDTO in lstActivityResourceMappingDTO)
                                {
                                    if (objActivityResourceMappingDTO.IsForRelative == flag)
                                    {
                                        if (objActivityResourceMappingDTO.EditFlag == ConstEnum.ResourceEditableCode.Editable)
                                        {
                                            var targetProperty = targetType.GetProperty("SubmittedRoleIds", BindingFlags.Public | BindingFlags.Instance);

                                            if (property.GetValue(objSource, null) != null)
                                            {
                                                List<string> SubmittedRole = (List<string>)property.GetValue(objSource, null);
                                                var sSubmittedRoleList = String.Join(",", SubmittedRole);
                                                if (targetProperty != null
                                                    && targetProperty.CanWrite)
                                                {
                                                    targetProperty.SetValue(objDestination, sSubmittedRoleList, null);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (dicActivityResourceMappingDTO.ContainsKey(property.Name))
                        {
                            lstActivityResourceMappingDTO = dicActivityResourceMappingDTO[property.Name];

                            foreach (ActivityResourceMappingDTO objActivityResourceMappingDTO in lstActivityResourceMappingDTO)
                            {
                                if (objActivityResourceMappingDTO.IsForRelative == flag)
                                {
                                    if (objActivityResourceMappingDTO.EditFlag == ConstEnum.ResourceEditableCode.Editable)
                                    {
                                        var targetProperty = targetType.GetProperty(property.Name, BindingFlags.Public | BindingFlags.Instance);
                                        if (targetProperty != null
                                            && targetProperty.CanWrite)
                                        {
                                            targetProperty.SetValue(objDestination, property.GetValue(objSource, null), null);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                objLoginUserDetails = null;
                dicActivityResourceMappingDTO = null;
                lstActivityResourceMappingDTO = null;
            }
            return objDestination;
        }
        #endregion CopyObjectPropertyByNameAndActivity

        //#region GetUserPANDetails
        //public static List<PopulateComboDTO> GetUserPANDetails(int ComboTypeID, int UserInfoId)
        //{
        //    LoginUserDetails objLoginUserDetails = null;
        //    IEnumerable<UserPANDetailsDTO> objUserPANDetailsDTO = null;
        //    List<PopulateComboDTO> objPopulateCombo = new List<PopulateComboDTO>();
        //    try
        //    {
        //        PopulateComboDTO objPopulateComboSelect = new PopulateComboDTO();
        //        objPopulateComboSelect.Key = "0";
        //        objPopulateComboSelect.Value = "Select";
        //        objPopulateCombo.Add(objPopulateComboSelect);
        //        using (CommonSL objCommonSL = new CommonSL())
        //        {
        //            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
        //            objUserPANDetailsDTO = objCommonSL.GetUserPanDetails(objLoginUserDetails.CompanyDBConnectionString, ComboTypeID, UserInfoId);

        //            foreach (var item in objUserPANDetailsDTO)
        //            {
        //                PopulateComboDTO objCombo = new PopulateComboDTO();
        //                objCombo.Key = item.ID;
        //                objCombo.Value = item.EmployeeName + '-' + item.PAN + item.RelationType;
        //                objPopulateCombo.Add(objCombo);
        //            }
        //        }
        //        return objPopulateCombo;
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }
        //}
        //#endregion GetUserPANDetails

        #region GetPopulateCombo
        /// <summary>
        /// This function will be used for fetching the values for the combo box
        /// </summary>
        /// <param name="sConnectionString">Connection String</param>
        /// <param name="i_nComboType">Combo Type</param>
        /// <param name="i_sParam*">OptionalParameters</param>
        /// <returns></returns>
        public static IEnumerable<PopulateComboDTO> GetPopulateCombo(string sConnectionString, int i_nComboType, string i_sParam1,
           string i_sParam2, string i_sParam3, string i_sParam4, string i_sParam5, string sLookupPrefix)
        {
            IEnumerable<PopulateComboDTO> res = null;
            try
            {
                //CommonDAL objCommonDAL = new CommonDAL();
                using (CommonDAL objCommonDAL = new CommonDAL())
                {
                    res = objCommonDAL.GetPopulateCombo(sConnectionString, i_nComboType, i_sParam1, i_sParam2, i_sParam3, i_sParam4, i_sParam5, sLookupPrefix);
                }

            }
            catch (Exception exp)
            {

            }
            return res;
        }
        #endregion GetPopulateCombo


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

        #region UpdateCompanyResources
        public static void UpdateCompanyResources(string i_sCompanyConnectionString, string i_sCompanyName)
        {
            Common.WriteLogToFile("UpdateCompanyResources method called " + " Connection string :- " + i_sCompanyConnectionString + " Company name :- " + i_sCompanyName, System.Reflection.MethodBase.GetCurrentMethod());
            //ResourcesSL objResourcesSL = new ResourcesSL();
            //CompaniesSL objCompaniesSL = new CompaniesSL();
            Dictionary<string, string> lstCompanyResources = null;
            try
            {
                lstCompanyResources = new Dictionary<string, string>();
                using (ResourcesSL objResourcesSL = new ResourcesSL())
                {
                    objResourcesSL.GetAllResources(i_sCompanyConnectionString, out lstCompanyResources);
                }
                Common.WriteLogToFile("All Resources are set ", System.Reflection.MethodBase.GetCurrentMethod());
                HttpContext.Current.Application.Set(i_sCompanyName, lstCompanyResources);
                using (CompaniesSL objCompaniesSL = new CompaniesSL())
                {
                    objCompaniesSL.UpdateMasterCompanyDetails(Common.getSystemConnectionString(), i_sCompanyName, 0);
                }
                Common.WriteLogToFile("Master Company Updated ", System.Reflection.MethodBase.GetCurrentMethod());
            }
            catch (Exception exp)
            {
                Common.WriteLogToFile("caught exception in UpdateCompanyResources method ", System.Reflection.MethodBase.GetCurrentMethod(), exp);
                throw exp;
            }
            finally
            {
                lstCompanyResources = null;
            }
        }
        #endregion UpdateCompanyResources

        #region getAppSetting
        /// <summary>
        /// This function will return the AppSettings for the given App key from Web.config file app-settins section
        /// </summary>
        /// <returns></returns>
        public static string getAppSetting(string i_sAppKey)
        {
            string sSystemAppValue = "";
            try
            {
                sSystemAppValue = System.Configuration.ConfigurationManager.AppSettings[i_sAppKey].ToString();
            }
            catch (Exception exp)
            {

            }

            return sSystemAppValue;
        }
        #endregion getAppSetting

        #region GetCultureValue
        /// <summary>
        /// Method to get the culture value(currency)
        /// </summary>
        /// <returns>Parsed String or null</returns>
        public static string GetCultureValue()
        {
            string newString = null;
            try
            {
                newString = CultureInfo.CurrentCulture.NumberFormat.CurrencySymbol;
                //var culture = CultureInfo.CreateSpecificCulture("en-GB");
            }
            catch
            {
                newString = null;
            }
            return newString;
        }
        #endregion GetCultureValue

        #region GetErrorMessage
        /// <summary>
        /// This method is used for the reurn error message.
        /// </summary>
        /// <param name="exp">Exception</param>
        /// <returns>retrun Error Message string</returns>
        public static string GetErrorMessage(Exception exp)
        {
            string sErrorMessage = string.Empty;

            try
            {
                if (exp.InnerException != null && exp.InnerException.Data.Count > 0)
                {
                    if (exp.InnerException.Data[0] != null || Convert.ToString(exp.InnerException.Data[0]) != "")
                    {
                        sErrorMessage = getResource(exp.InnerException.Data[0].ToString());
                    }
                    if (sErrorMessage == null || sErrorMessage == "")
                    {
                        if (exp.InnerException.Data[1] != null && Convert.ToString(exp.InnerException.Data[1]) != "")
                        {
                            sErrorMessage = "Error Code : " + exp.InnerException.Data[1].ToString() + "   Error : " + exp.InnerException.Data[2].ToString();
                        }
                        else
                        {
                            sErrorMessage = "Error code " + exp.InnerException.Data[0] + " doesnot find in resource.";
                        }
                    }
                }
                else
                {
                    sErrorMessage = exp.Message;
                }
                return sErrorMessage;
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        #endregion GetErrorMessage

        #region SendMail
        /// <summary>
        /// This function will be used for sending the email related to forgot password to the user.
        /// </summary>
        /// <param name="sPasswordLink">The password change link to be sent to user in email</param>
        /// <param name="objPwdMgmtDTO">The object which will have details of the user to whom the email is to be sent</param>
        /// <param name="sUserCompanyName">The company database name, which is selected by user associated with.This will 
        /// be used for fetching the notification configuration settings for selected company.</param>
        /// <returns></returns>
        public static bool SendMail(string sPasswordLink, PasswordManagementDTO objPwdMgmtDTO, string sUserCompanyName)
        {
            bool bReturn = false;
            NotificationSL objNotificationSL = new NotificationSL();
            CompanyDetailsForNotificationDTO objCompanyDetailsForNotificationDTO;
            objCompanyDetailsForNotificationDTO = objNotificationSL.GetCompanyDetailsForNotification(Common.getSystemConnectionString(), 0, sUserCompanyName);
            SmtpClient client = new SmtpClient(objCompanyDetailsForNotificationDTO.SmtpServer);
            //Set the port for the SMTP client if available otherwise the default will be considered.
            if (sUserCompanyName.Contains("Kotak") || sUserCompanyName.Contains("Exide") || sUserCompanyName.Contains("TataCommunications") || sUserCompanyName.Contains("DCBBank") || sUserCompanyName.Contains("HIL") || sUserCompanyName.Contains("Accelya") || sUserCompanyName.Contains("Piramal") || sUserCompanyName.Contains("BCML") || sUserCompanyName.Contains("Titan") || sUserCompanyName.Contains("Hitech") || sUserCompanyName.Contains("Hexatradex"))
            {
                client.EnableSsl = false;
            }
            else
            {
                client.EnableSsl = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSsl"]);
            }
            client.UseDefaultCredentials = Convert.ToBoolean(ConfigurationManager.AppSettings["UseDefaultCredentials"]);
            if (objCompanyDetailsForNotificationDTO.SmtpPortNumber != null && objCompanyDetailsForNotificationDTO.SmtpPortNumber != "")
            {
                client.Port = Convert.ToInt32(objCompanyDetailsForNotificationDTO.SmtpPortNumber);
            }

            string FromEmaild = objCompanyDetailsForNotificationDTO.SmtpUserName;
            string pwd = objCompanyDetailsForNotificationDTO.SmtpPassword;
            System.Net.Mail.MailMessage mailMessage = new System.Net.Mail.MailMessage();

            if (FromEmaild != null && FromEmaild != string.Empty && pwd != null && pwd != string.Empty)
            {
                System.Net.NetworkCredential nCredentials = new System.Net.NetworkCredential(FromEmaild, pwd);
                client.Credentials = nCredentials;
            }
            //If FromEmailid from Master Database is not available then use the Email address from Web.config
            else if (FromEmaild == null || FromEmaild == string.Empty)
            {
                FromEmaild = Common.getAppSetting("AuthEID");
            }

            //mailMessage.From = new MailAddress((sUserCompanyName.ToString().ToUpper().Contains("PIRAMAL") && (objCompanyDetailsForNotificationDTO.FromMailID != null || objCompanyDetailsForNotificationDTO.FromMailID != "")) ? objCompanyDetailsForNotificationDTO.FromMailID : objCompanyDetailsForNotificationDTO.SmtpUserName);

            //If company = PIRAMAL && FromMailId has Proper value then take FromMailId 
            //Else (for any company) If FromMailId has Proper value then take FromMailId 
            //Else take SmtpUserName

            Regex regexValidEmailID = new Regex("^[a-zA-Z]+[a-zA-Z0-9]+[[a-zA-Z0-9-_.!#$%'*+/=?^]{1,20}@[a-zA-Z0-9]{1,20}.[a-zA-Z]{2,3}$");
            
                mailMessage.From = new MailAddress(
                       (sUserCompanyName.ToString().ToUpper().Contains("PIRAMAL") &&
                       string.IsNullOrEmpty(objCompanyDetailsForNotificationDTO.FromMailID)) ?
                       objCompanyDetailsForNotificationDTO.FromMailID :
                       (string.IsNullOrEmpty(objCompanyDetailsForNotificationDTO.SmtpUserName) || regexValidEmailID.IsMatch(objCompanyDetailsForNotificationDTO.SmtpUserName)) ?
                       objCompanyDetailsForNotificationDTO.SmtpUserName :
                       objCompanyDetailsForNotificationDTO.FromMailID);

            mailMessage.To.Add(objPwdMgmtDTO.EmailID);
            //Fetch the subject and the email body from selected company resources.
            string subject = Common.getResourceForGivenCompany("usr_msg_11282", sUserCompanyName);
            string message = Common.getResourceForGivenCompany("usr_msg_11283", sUserCompanyName);
            mailMessage.Subject = subject;
            //Add http to the link if not present, this is because if HTTP protocol is not specified then in Hotmail in the message body the link is
            //is changed to use https protocol.

            if (!sPasswordLink.StartsWith(HttpContext.Current.Request.Url.Scheme))
            {
                sPasswordLink = ConfigurationManager.AppSettings["ForgotPasswordDomainURL"].ToString() + sPasswordLink;
            }
            //Replace the place holders with the link with anchor tag and one without anchor tag.
            message = message.Replace(Environment.NewLine, "<br/>");
            message = message.Replace("$1", "<a href='" + sPasswordLink + "'>Change Password</a>");
            message = message.Replace("$2", sPasswordLink);
            mailMessage.Body = message;
            //mailMessage.Body = "<p>A request has been recieved to reset your password. If you did not initiate the request, then please ignore this email.</p>";
            //mailMessage.Body += "<p>Please click the following link to reset your password:<a href='" + sPasswordLink + "'>Link</a></p>";
            mailMessage.IsBodyHtml = true;
            try
            {
                WriteLogToFile("Mail for forgot Password is From: " + mailMessage.From.ToString(), System.Reflection.MethodBase.GetCurrentMethod(), null);
                WriteLogToFile("Mail for forgot Password is To: " + objPwdMgmtDTO.EmailID, System.Reflection.MethodBase.GetCurrentMethod(), null);
                WriteLogToFile("Mail for forgot Password is with smtp port no: " + objCompanyDetailsForNotificationDTO.SmtpPortNumber, System.Reflection.MethodBase.GetCurrentMethod(), null);
                WriteLogToFile("Mail for forgot Password is with smtp Server: " + objCompanyDetailsForNotificationDTO.SmtpServer, System.Reflection.MethodBase.GetCurrentMethod(), null);


                client.Send(mailMessage);
            }
            catch (Exception ex)
            {
                WriteLogToFile("Exception occurred ", System.Reflection.MethodBase.GetCurrentMethod(), ex);
                throw ex;
            }

            return bReturn;
        }
        #endregion SendMail

        public static bool SendOTPMail(string EmailId, string sUserCompanyName, string GeneratedOTP, string UserFullName)
        {
            bool bReturn = false;
            NotificationSL objNotificationSL = new NotificationSL();
            CompanyDetailsForNotificationDTO objCompanyDetailsForNotificationDTO;
            objCompanyDetailsForNotificationDTO = objNotificationSL.GetCompanyDetailsForNotification(Common.getSystemConnectionString(), 0, sUserCompanyName);
            SmtpClient client = new SmtpClient(objCompanyDetailsForNotificationDTO.SmtpServer);
            //Set the port for the SMTP client if available otherwise the default will be considered.
            if (sUserCompanyName.Contains("Kotak") || sUserCompanyName.Contains("Exide") || sUserCompanyName.Contains("TataCommunications") || sUserCompanyName.Contains("DCBBank") || sUserCompanyName.Contains("HIL") || sUserCompanyName.Contains("Accelya") || sUserCompanyName.Contains("Piramal") || sUserCompanyName.Contains("BCML") || sUserCompanyName.Contains("Hitech") || sUserCompanyName.Contains("Hexatradex"))
            {
                client.EnableSsl = false;
            }
            else
            {
                client.EnableSsl = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSsl"]);
            }
            client.UseDefaultCredentials = Convert.ToBoolean(ConfigurationManager.AppSettings["UseDefaultCredentials"]);
            if (objCompanyDetailsForNotificationDTO.SmtpPortNumber != null && objCompanyDetailsForNotificationDTO.SmtpPortNumber != "")
            {
                client.Port = Convert.ToInt32(objCompanyDetailsForNotificationDTO.SmtpPortNumber);
            }

            string FromEmaild = objCompanyDetailsForNotificationDTO.SmtpUserName;
            string pwd = objCompanyDetailsForNotificationDTO.SmtpPassword;
            System.Net.Mail.MailMessage mailMessage = new System.Net.Mail.MailMessage();

            if (FromEmaild != null && FromEmaild != string.Empty && pwd != null && pwd != string.Empty)
            {
                System.Net.NetworkCredential nCredentials = new System.Net.NetworkCredential(FromEmaild, pwd);
                client.Credentials = nCredentials;
            }
            //If FromEmailid from Master Database is not available then use the Email address from Web.config
            else if (FromEmaild == null || FromEmaild == string.Empty)
            {
                FromEmaild = Common.getAppSetting("AuthEID");
            }

            mailMessage.From = new MailAddress((sUserCompanyName.ToString().ToUpper().Contains("PIRAMAL") && (objCompanyDetailsForNotificationDTO.FromMailID != null || objCompanyDetailsForNotificationDTO.FromMailID != "")) ? objCompanyDetailsForNotificationDTO.FromMailID : objCompanyDetailsForNotificationDTO.SmtpUserName);
            mailMessage.To.Add(EmailId);
            //Fetch the subject and the email body from selected company resources.
            string subject = Common.getResourceForGivenCompany("tfa_msg_61002", sUserCompanyName);
            string message = Common.getResourceForGivenCompany("tfa_msg_61001", sUserCompanyName);
            message = message.Replace("$1", UserFullName);
            //message = message.Replace(Environment.NewLine, "<br/>");
            message = message.Replace("$2", GeneratedOTP);
            mailMessage.Subject = subject;

            mailMessage.Body = message;
            mailMessage.IsBodyHtml = true;
            try
            {
                client.Send(mailMessage);
                bReturn = true;
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return bReturn;
        }

        #region OTPgeneration
        /// <summary>
        /// SET OTP ALLOWED CHARACTER
        /// </summary>
        /// <param name="OTPLength"></param>
        /// <returns></returns>
        public static string OTPAllowedCharacters(int OTPLength)
        {
            string NewCharacters = "";
            string AllowedCharacters = "";
            AllowedCharacters = "1,2,3,4,5,6,7,8,9,0";
            AllowedCharacters += "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,";
            AllowedCharacters += "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,";
            char[] CharacterSeperator = { ',' };
            string[] AllowedCharacterArray = AllowedCharacters.Split(CharacterSeperator);
            Random RamdomNumber = new Random();
            for (int i = 0; i < Convert.ToInt32(OTPLength); i++)
            {
                NewCharacters += AllowedCharacterArray[RamdomNumber.Next(0, AllowedCharacterArray.Length)];

            }

            return NewCharacters;
        }
        /// <summary>
        /// GENERATE UNIQUE OTP
        /// </summary>
        /// <param name="uniqueIdentity"></param>
        /// <param name="uniqueUserIdentity"></param>
        /// <param name="OTPLength"></param>
        /// <returns></returns>
        public static string OTPGeneratorUsingMD5AlgorithemAndDateTimeParameters(string uniqueIdentity, string uniqueUserIdentity, int OTPLength)
        {
            string OneTimePassword = "";
            DateTime dateTime = DateTime.Now;
            string StringParsedDateUniqueElement = Convert.ToString(dateTime.Day);
            StringParsedDateUniqueElement = StringParsedDateUniqueElement + Convert.ToString(dateTime.Month);
            StringParsedDateUniqueElement = StringParsedDateUniqueElement + Convert.ToString(dateTime.Year);
            StringParsedDateUniqueElement = StringParsedDateUniqueElement + Convert.ToString(dateTime.Hour);
            StringParsedDateUniqueElement = StringParsedDateUniqueElement + Convert.ToString(dateTime.Minute);
            StringParsedDateUniqueElement = StringParsedDateUniqueElement + Convert.ToString(dateTime.Second);
            StringParsedDateUniqueElement = StringParsedDateUniqueElement + Convert.ToString(dateTime.Millisecond);
            StringParsedDateUniqueElement = StringParsedDateUniqueElement + uniqueUserIdentity;
            StringParsedDateUniqueElement = uniqueIdentity + StringParsedDateUniqueElement;
            using (MD5 md5 = MD5.Create())
            {
                //Get hash code of entered request id in byte format.
                byte[] _RequestByte = md5.ComputeHash(Encoding.UTF8.GetBytes(StringParsedDateUniqueElement));
                //convert byte array to integer.
                int _parsedReqestNo = BitConverter.ToInt32(_RequestByte, 0);
                string _strParsedReqestId = Math.Abs(_parsedReqestNo).ToString();
                //Check if length of hash code is less than 9.
                //If so, then prepend multiple zeros upto the length becomes atleast 9 characters.
                if (_strParsedReqestId.Length < 9)
                {
                    StringBuilder sb = new StringBuilder(_strParsedReqestId);
                    for (int k = 0; k < (9 - _strParsedReqestId.Length); k++)
                    {
                        sb.Insert(0, '0');
                    }
                    _strParsedReqestId = sb.ToString();
                }
                OneTimePassword = _strParsedReqestId;
            }

            if (OneTimePassword.Length >= OTPLength)
            {
                OneTimePassword = OneTimePassword.Substring(0, OTPLength);
            }
            return OneTimePassword;
        }
        #endregion OTPgeneration


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
            LoginUserDetails objLoginUserDetails = null;
            try
            {
                //CommonDAL objCommonDal = new CommonDAL();
                using (CommonDAL objCommonDal = new CommonDAL())
                {
                    if (i_sConnectionString == null || i_sConnectionString == "")
                    {
                        objLoginUserDetails = (LoginUserDetails)Common.GetSessionValue(ConstEnum.SessionValue.UserDetails);
                        i_sConnectionString = objLoginUserDetails.CompanyDBConnectionString;
                    }
                    currentDBDate = objCommonDal.GetCurrentDate(i_sConnectionString, bDateWithTimestamp, sLookupPrefix);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return currentDBDate;
        }
        #endregion GetCurrentDate

        #region IsTradingPolicyEdit
        /// <summary>
        /// This method is used for trading policy is editable or not
        /// </summary>
        /// <param name="sControl">Control Name</param>
        /// <param name="dtFromDate">Applicable From Date</param>
        /// <param name="TradingPolicyStatusCodeId">Trading Policy Status</param>
        /// <returns></returns>
        public static Dictionary<string, object> IsTradingPolicyEdit(string sControl, DateTime? dtFromDate, int? TradingPolicyStatusCodeId)
        {
            //var isAllEdit = true;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            var WSC_html_attr = new Dictionary<string, object> { };
            if (sControl == "Text")
            {
                WSC_html_attr.Add("class", "form-control");
            }
            else if (sControl == "Radio")
            {
                WSC_html_attr.Add("Checked", "checked");
            }
            else if (sControl == "RadioNull1")
            {
                WSC_html_attr.Add("Checked", "checked");
            }
            else if (sControl == "CheckBox")
            {
                WSC_html_attr.Add("class", "cr-check");
            }
            else if (sControl == "MultiSelect")
            {
                WSC_html_attr.Add("multiple", "multiple");
                WSC_html_attr.Add("class", "form-control multiselect");
            }
            else if (sControl == "TextNumber")
            {
                WSC_html_attr.Add("class", "form-control numericOnly");
            }
            else
            {
                WSC_html_attr.Add("class", "");
            }
            /*  if (dtFromDate != null)
              {
                  DateTime d = (DateTime)dtFromDate;

                  DateTime dtCurrentDate = GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);

                  if (TradingPolicyStatusCodeId == InsiderTrading.Common.ConstEnum.Code.TradingPolicyStatusActive && d.Date < dtCurrentDate)
                  {
                      WSC_html_attr.Add("disabled", "disabled");
                  }
                  else if (!isAllEdit)
                  {
                      WSC_html_attr.Add("disabled", "disabled");

                  }
              }*/
            return WSC_html_attr;

        }
        #endregion IsTradingPolicyEdit

        #region IsTradingPolicyEdit
        /// <summary>
        /// This method is used for trading policy is editable or not
        /// </summary>
        /// <param name="dtFromDate">Applicable From Date</param>
        /// <param name="TradingPolicyStatusCodeId">Trading Policy Status</param>
        /// <returns></returns>
        public static bool IsTradingPolicyEdit(DateTime? dtFromDate,
                           int? TradingPolicyStatusCodeId)
        {
            var isAllEdit = false;
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            if (dtFromDate != null)
            {
                DateTime d = (DateTime)dtFromDate;

                DateTime dtCurrentDate = GetCurrentDate(objLoginUserDetails.CompanyDBConnectionString);

                if (TradingPolicyStatusCodeId == InsiderTrading.Common.ConstEnum.Code.TradingPolicyStatusActive && d.Date < dtCurrentDate)
                {
                    isAllEdit = false;
                }
                else if (!isAllEdit)
                {
                    isAllEdit = true;

                }
            }
            return true;

        }
        #endregion IsTradingPolicyEdit

        #region GenerateDocumentList
        /// <summary>
        /// This method is used to fetch document details. If file/document are saved then details is fetch from DB else list of new object is send as output
        /// </summary>
        /// <param name="nMapToTypeCodeId"></param>
        /// <param name="nMapToId"></param>
        /// <param name="nIndex">Index of dictionary - This value is increase if MapToTypeCodeId is different and multiple control are used on same page</param>
        /// <param name="lstOldDocumentDetailsModel">This is list of existing model which should be pass only when MapToTypeCodeId is same </param>
        /// <param name="nPurposeCodeId"></param>
        /// <param name="nSingleFlag">This flag is used to fetch document details base on document details, if flag is false then document details are fetch base on MapToTypeCodeId and MapToId</param>
        /// <param name="nDocumentID"></param>
        /// <param name="nMaxFileUploadControl">No of control will be shown on page. Default is 1</param>
        /// <returns></returns>
        public static List<DocumentDetailsModel> GenerateDocumentList(int nMapToTypeCodeId, int nMapToId, int nIndex = 0, List<DocumentDetailsModel> lstOldDocumentDetailsModel = null, int nPurposeCodeId = 0, bool nSingleFlag = false, int nDocumentID = 0, int nMaxFileUploadControl = 1, bool bHideBlankRows = false)
        {
            List<DocumentDetailsModel> lstDocumentDetailsModel = new List<DocumentDetailsModel>();

            try
            {

                LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

                //check if doc/file is already saved by checking MapToId
                if (nMapToId != null && nMapToId != 0)
                {
                    //DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL();
                    List<DocumentDetailsDTO> lstDocumentDetailsDTO = new List<DocumentDetailsDTO>();

                    //check flag - this flag is true then fetch details from document id else fetch details from MapToId and MapToTypeCodeID
                    if (nSingleFlag)
                    {
                        //fetch document details from document Id - this code is currently used on employee document upload only 

                        DocumentDetailsDTO objDocumentDetailsDTO = new DocumentDetailsDTO();
                        DocumentDetailsModel objDocumentDetailsModel = new DocumentDetailsModel();
                        if (nDocumentID != 0)
                        {
                            using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                            {
                                objDocumentDetailsDTO = objDocumentDetailsSL.GetDocumentDetails(objLoginUserDetails.CompanyDBConnectionString, nDocumentID);
                            }
                            CopyObjectPropertyByName(objDocumentDetailsDTO, objDocumentDetailsModel);
                        }
                        objDocumentDetailsModel.MapToTypeCodeId = nMapToTypeCodeId;
                        objDocumentDetailsModel.MapToId = nMapToId;
                        objDocumentDetailsModel.PurposeCodeId = nPurposeCodeId;
                        objDocumentDetailsModel.Index = nIndex;
                        objDocumentDetailsModel.SubIndex = 0;
                        objDocumentDetailsModel.HideRow = false;
                        objDocumentDetailsModel.HasAddNewOption = false;
                        lstDocumentDetailsModel.Add(objDocumentDetailsModel);
                    }
                    else
                    {
                        //fetch document details from MapToId and MapToTypeCodeID

                        //get saved file list
                        using (DocumentDetailsSL objDocumentDetailsSL = new DocumentDetailsSL())
                        {
                            lstDocumentDetailsDTO = objDocumentDetailsSL.GetDocumentList(objLoginUserDetails.CompanyDBConnectionString, nMapToTypeCodeId, nMapToId, nPurposeCodeId);
                        }

                        int subidx_ctr = 0;
                        int details_count = lstDocumentDetailsDTO.Count;

                        if (details_count > 0)
                        {
                            //add modal obj already saved into list
                            foreach (DocumentDetailsDTO obj in lstDocumentDetailsDTO)
                            {
                                DocumentDetailsModel objDocDetailsModel = new DocumentDetailsModel();
                                CopyObjectPropertyByName(obj, objDocDetailsModel);
                                objDocDetailsModel.Index = nIndex;
                                objDocDetailsModel.SubIndex = subidx_ctr;
                                objDocDetailsModel.HideRow = false;
                                if (bHideBlankRows)
                                {
                                    objDocDetailsModel.HasAddNewOption = true;
                                }
                                else
                                {
                                    objDocDetailsModel.HasAddNewOption = false;
                                }
                                lstDocumentDetailsModel.Add(objDocDetailsModel);

                                subidx_ctr++;
                            }

                            //check if saved document/file count is less then max file upload - 
                            //if saved file count is less then add new object to list 
                            if (details_count < nMaxFileUploadControl)
                            {
                                //add new but empty modal for unsaved number of file control
                                for (int ctr = details_count; ctr < nMaxFileUploadControl; ctr++)
                                {
                                    DocumentDetailsModel objInitialModel = new DocumentDetailsModel();
                                    objInitialModel.MapToTypeCodeId = nMapToTypeCodeId;
                                    objInitialModel.MapToId = nMapToId;
                                    objInitialModel.PurposeCodeId = nPurposeCodeId;
                                    objInitialModel.Index = nIndex;
                                    objInitialModel.SubIndex = ctr;
                                    if (bHideBlankRows)
                                    {
                                        objInitialModel.HideRow = true;
                                        objInitialModel.HasAddNewOption = true;
                                    }
                                    else
                                    {
                                        objInitialModel.HasAddNewOption = false;
                                    }
                                    lstDocumentDetailsModel.Add(objInitialModel);
                                }
                            }
                        }
                        else
                        {
                            //document/files not saved so add new but empty model
                            for (int ctr = 0; ctr < nMaxFileUploadControl; ctr++)
                            {
                                DocumentDetailsModel objInitialModel = new DocumentDetailsModel();
                                objInitialModel.MapToTypeCodeId = nMapToTypeCodeId;
                                objInitialModel.MapToId = nMapToId;
                                objInitialModel.PurposeCodeId = nPurposeCodeId;
                                objInitialModel.Index = nIndex;
                                objInitialModel.SubIndex = ctr;
                                if (bHideBlankRows)
                                {
                                    objInitialModel.HideRow = true;
                                    objInitialModel.HasAddNewOption = true;
                                }
                                else
                                {
                                    objInitialModel.HasAddNewOption = false;
                                }
                                lstDocumentDetailsModel.Add(objInitialModel);
                            }
                        }
                    }
                }
                else
                {
                    //document/files not saved so add new but empty model
                    for (int ctr = 0; ctr < nMaxFileUploadControl; ctr++)
                    {
                        DocumentDetailsModel objDocumentDetailsModel = new DocumentDetailsModel();
                        objDocumentDetailsModel.MapToTypeCodeId = nMapToTypeCodeId;
                        objDocumentDetailsModel.MapToId = nMapToId;
                        objDocumentDetailsModel.PurposeCodeId = nPurposeCodeId;
                        objDocumentDetailsModel.Index = nIndex;
                        objDocumentDetailsModel.SubIndex = ctr;
                        if (bHideBlankRows)
                        {
                            objDocumentDetailsModel.HideRow = true;
                            objDocumentDetailsModel.HasAddNewOption = true;
                        }
                        else
                        {
                            objDocumentDetailsModel.HasAddNewOption = false;
                        }
                        lstDocumentDetailsModel.Add(objDocumentDetailsModel);
                    }
                }

                //following logic check if there is control of same MapToTypeCodeId then increment sub index for list 
                //NOTE - In case of MapToTypeCodeId is different then index is change 
                //however in following code MapToTypeCodeId is not compare before updating sub index
                if (lstOldDocumentDetailsModel != null && lstOldDocumentDetailsModel.Count > 0)
                {
                    int objIndex = 0; //variable to store last subindex
                    foreach (DocumentDetailsModel obj in lstOldDocumentDetailsModel)
                    {
                        if (obj.SubIndex > objIndex)
                        {
                            objIndex = obj.SubIndex; //set max sub index to variable used to stored last sub index
                        }
                    }
                    //update sub index for newly created list by added last sub index
                    foreach (DocumentDetailsModel obj in lstDocumentDetailsModel)
                    {
                        obj.SubIndex = ++objIndex;
                    }
                }
            }
            catch (Exception exp)
            {
            }
            return lstDocumentDetailsModel;
        }
        #endregion GenerateDocumentList

        #region GetCurrentYearCode
        /// <summary>
        /// This method is used to get current year code
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="sLookupPrefix"></param>
        /// <returns></returns>
        public static int GetCurrentYearCode(string i_sConnectionString, string sLookupPrefix = "usr_com_")
        {
            int currentYearCode;

            try
            {
                //CommonDAL objCommonDal = new CommonDAL();
                using (CommonDAL objCommonDal = new CommonDAL())
                {
                    currentYearCode = objCommonDal.GetCurrentYearCode(i_sConnectionString, sLookupPrefix);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return currentYearCode;
        }
        #endregion GetCurrentYearCode

        #region Get Configuration value from com code
        /// <summary>
        /// This method is used to get configuration code for code id
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="nCodeId"></param>
        /// <param name="sLookupPrefix"></param>
        /// <returns></returns>
        public static int GetConfiguartionCode(string i_sConnectionString, int nCodeId, string sLookupPrefix = "usr_com_")
        {
            int ConfigurationCode;

            try
            {
                //CommonDAL objCommonDal = new CommonDAL();
                using (CommonDAL objCommonDal = new CommonDAL())
                {
                    ConfigurationCode = objCommonDal.GetConfiguartionCode(i_sConnectionString, nCodeId, sLookupPrefix);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return ConfigurationCode;
        }
        #endregion Get Configuration value from com code

        /// <summary>
        /// This function will be used for finding a substring for a delimitter string till the instance number given.
        /// Eg. If we have a string like 2.1.3.4 and if requested to get substring till second instance of '.', then this function will
        /// return 2.1, if requested till third instance then it will return 2.1.3
        /// </summary>
        /// <param name="i_sInputString"></param>
        /// <param name="i_sDelimitter"></param>
        /// <returns></returns>
        public static string SubstringTillInstanceOf(string i_sInputString, char i_sDelimitter, int i_nInstanceTillToTake)
        {
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

        /// <summary>
        /// This function will be used for creating the encrypted url to be used for change/forgot password to be used by user.
        /// </summary>
        /// <param name="i_sSelectedcompanyConnectionString"></param>
        /// <param name="i_nLoginId"></param>
        /// <param name="i_sCompanyId"></param>
        /// <returns></returns>
        public static bool CreateForgetPasswordHashLink(string i_sSelectedcompanyConnectionString, string i_sLoginName, string i_sUserEmailId, string i_sCompanyId)
        {
            PasswordManagementDTO objPwdMgmtDTO = new PasswordManagementDTO();
            //UserInfoSL objUserInfoSL = new UserInfoSL();
            //CompaniesSL objCompanySL = new CompaniesSL();
            //ComCodeSL objComCodeSL = new ComCodeSL();
            string SaltValue = ConstEnum.User_Password_Encryption_Key;
            bool bReturn = false;
            InsiderTradingEncryption.DataSecurity objPwdHash = new InsiderTradingEncryption.DataSecurity();
            string sHashCode = "";
            try
            {
                sHashCode = objPwdHash.CreateHash(i_sLoginName.ToString() + i_sCompanyId, SaltValue);

                objPwdMgmtDTO.CompanyID = i_sCompanyId;
                objPwdMgmtDTO.LoginID = i_sLoginName;
                objPwdMgmtDTO.EmailID = i_sUserEmailId;
                objPwdMgmtDTO.HashValue = sHashCode;
                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {
                    objPwdMgmtDTO = objUserInfoSL.ForgetPassword(i_sSelectedcompanyConnectionString, objPwdMgmtDTO);
                }
                bReturn = true;
            }
            catch (Exception exp)
            {

            }
            return bReturn;
        }

        #region CheckUserTypeAccess
        /// <summary>
        /// This Function fetches the user access for that page as per parameters.
        /// Function for validating user access for specified page, user should not view or modify other user details.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_iMapToTypeCodeId"></param>
        /// <param name="i_iMapToId"></param>
        /// <param name="i_iLoggenInUserId"></param>
        /// <returns></returns>
        public static bool CheckUserTypeAccess(string i_sConnectionString, int i_iMapToTypeCodeId, Int64 i_iMapToId, int i_iLoggenInUserId)
        {
            bool bIsAccess = false; ;
            try
            {
                int nIsAccess;
                //CommonDAL objCommonDal = new CommonDAL();
                using (CommonSL objCommonSL = new CommonSL())
                {
                    objCommonSL.CheckUserTypeAccess(i_sConnectionString, i_iMapToTypeCodeId, i_iMapToId, i_iLoggenInUserId, out nIsAccess);
                }

                if (nIsAccess == 1)
                {
                    bIsAccess = true;
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return bIsAccess;
        }
        #endregion CheckUserTypeAccess

        #region ValidateCSRFForAJAX
        /// <summary>
        /// Method to validate the AJAX request for CSRF
        /// </summary>
        /// <returns></returns>
        public bool ValidateCSRFForAJAX()
        {
            bool bReturn = true;
            try
            {
                string cookieToken = "";
                string formToken = "";
                string[] sHeaderKeys = new string[0];
                string tokenHeaders;
                sHeaderKeys = HttpContext.Current.Request.Headers.AllKeys;
                if (sHeaderKeys == null)
                    sHeaderKeys = new string[0];
                sHeaderKeys = sHeaderKeys.Select(s => s.ToLowerInvariant()).ToArray();
                if (sHeaderKeys.Contains(ConstEnum.AntiForgeryTokenHeader.ToLower()))
                {
                    tokenHeaders = HttpContext.Current.Request.Headers[ConstEnum.AntiForgeryTokenHeader.ToLower()];
                    tokenHeaders = HttpUtility.UrlDecode(tokenHeaders);
                    string[] tokens = tokenHeaders.Split(':');
                    if (tokens.Length == 2)
                    {
                        cookieToken = tokens[0].Trim();
                        formToken = tokens[1].Trim();
                    }
                }
                AntiForgery.Validate(cookieToken, formToken);
            }
            catch (HttpAntiForgeryException csrfException)
            {
                bReturn = false;
            }
            catch (Exception exp)
            {
                bReturn = false;
            }
            return bReturn;
        }
        #endregion ValidateCSRFForAJAX

        #region Functions for generating random string for Encrypted URL seen in browser
        /// <summary>
        /// This function will get a random string from the predefined array and the string will be used to append to the start of the encrypted string
        /// seen in the browser for all GET calls.
        /// </summary>
        string[] CSRFTokenStartString = new string[] { "abc", "pqr", "stu", "vwx", "rty", "erf", "ytr", "der", "red", "rfe" };
        public string getRandomString()
        {
            int nRandomNumber = new Random().Next(0, 9);
            return CSRFTokenStartString[nRandomNumber];
        }

        /// <summary>
        /// This function will check if the first 3 characters from the endrypted query string is available in the predefined 
        /// strings array.
        /// </summary>
        /// <param name="sString"></param>
        /// <returns></returns>
        public bool CheckIfStringIsCorrect(string sString)
        {
            return CSRFTokenStartString.Contains(sString);
        }
        #endregion Functions for generating random string for Encrypted URL seen in browser

        public static void SetSessionAndCookiesValidationValue(string value)
        {
            //get user ip address
            string _UserIPAddress = (string.IsNullOrEmpty(HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"])) ?
                                            (string.IsNullOrEmpty(HttpContext.Current.Request.UserHostAddress) ?
                                                HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"] : HttpContext.Current.Request.UserHostAddress) :
                                        HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries).FirstOrDefault();

            //get browser information 
            string _browserInfo = HttpContext.Current.Request.Browser.Browser + HttpContext.Current.Request.Browser.Version + HttpContext.Current.Request.UserAgent
                                    + "~" + HttpContext.Current.Request.Browser.Platform
                                    + "~" + HttpContext.Current.Request.Browser.MajorVersion
                                    + "~" + HttpContext.Current.Request.Browser.MinorVersion
                                    + "~" + _UserIPAddress;

            //set common string used for validation
            string _session_cookies_common_value = value + "^" + DateTime.Now.Ticks + "^" + _browserInfo + "^" + System.Guid.NewGuid();

            if (HttpContext.Current.Request.Cookies[ConstEnum.CookiesValue.ValidationCookies] != null)
                _session_cookies_common_value = _session_cookies_common_value + "^" + HttpContext.Current.Request.Cookies[ConstEnum.CookiesValue.ValidationCookies].Value;

            string _sessionValue = _session_cookies_common_value;
            string _cookiesValue = _session_cookies_common_value;

            //set session validation key into session after encryption
            byte[] _encodeAsByte = System.Text.ASCIIEncoding.ASCII.GetBytes(_sessionValue);
            string _encryptedString = System.Convert.ToBase64String(_encodeAsByte);
            SetSessionValue(ConstEnum.SessionValue.SessionValidationKey, _encryptedString);

            //set cookies validation key into session after encryption
            string _encryptedCookiesString = "";
            encryptData(_cookiesValue, out _encryptedCookiesString);
            SetSessionValue(ConstEnum.SessionValue.CookiesValidationKey, _encryptedCookiesString);
        }

        /// <summary>
        /// This function will be used for validating the users Password for the configured Password policy
        /// </summary>
        /// <returns></returns>
        public bool ValidatePassword(string i_sConnectionString, string i_sUserLoginName, string i_sPasswordToValidate, string i_sHashedPassword, int userInfoId, out string o_sErrorMessage)
        {
            o_sErrorMessage = "";
            PasswordConfigDTO objPasswordConfig = new PasswordConfigDTO();
            bool isPasswordValid = false;

            try
            {
                /*
                    Fetch the configured Password policy details from table in company database
                    * Check the password string for different criterias in Password policy
                    * If all the criterias are passed then return true, else return false and set the error message in out parameter.
                    */
                using (PasswordConfigSL objPassConfigSL = new PasswordConfigSL())
                {
                    objPasswordConfig = objPassConfigSL.GetPasswordConfigDetails(i_sConnectionString);
                }
                if (i_sUserLoginName == null)
                    i_sUserLoginName = "";
                if (i_sPasswordToValidate == null)
                    i_sPasswordToValidate = "";

                //Check that the UserLoginName should not be same as PasswordToValidate
                if (i_sPasswordToValidate.ToLower().Contains(i_sUserLoginName.ToLower()))
                {
                    o_sErrorMessage = "Password should not contain user Login ID in it.";
                    isPasswordValid = false;
                }
                else
                {
                    isPasswordValid = true;
                }
                if (isPasswordValid)
                {
                    using (PasswordConfigSL objPassConfigSL = new PasswordConfigSL())
                    {
                        bool IsFound = false;
                        string saltValue = string.Empty;
                        string oldPasswordValue = string.Empty;
                        string newPasswordValue = string.Empty;

                        InsiderTradingEncryption.DataSecurity objPwdHash = new InsiderTradingEncryption.DataSecurity();
                        string userPasswordHashSalt = InsiderTrading.Common.ConstEnum.User_Password_Encryption_Key;

                        List<PasswordConfigDTO> lstUserPwdDetails = objPassConfigSL.CheckPasswordHistory(i_sConnectionString, userInfoId);
                        foreach (var UserPwdDetails in lstUserPwdDetails)
                        {
                            oldPasswordValue = UserPwdDetails.PasswordValue;
                            saltValue = UserPwdDetails.SaltValue;

                            string usrSaltValue = (saltValue == null || saltValue == string.Empty) ? userPasswordHashSalt : saltValue;

                            if (saltValue != null && saltValue != "")
                                newPasswordValue = objPwdHash.CreateHashToVerify(i_sPasswordToValidate, usrSaltValue);
                            else
                                newPasswordValue = objPwdHash.CreateHash(i_sPasswordToValidate, usrSaltValue);

                            if (oldPasswordValue == newPasswordValue)
                            {
                                IsFound = true;
                                break;
                            }
                        }

                        if (IsFound)
                        {
                            o_sErrorMessage = "New Password should not be Previously used password";
                            isPasswordValid = false;
                        }
                        else
                        {
                            isPasswordValid = true;
                        }
                    }
                }

                if (isPasswordValid && objPasswordConfig.MaxLength > 0)
                {
                    if (i_sPasswordToValidate.Length > objPasswordConfig.MaxLength)
                    {
                        o_sErrorMessage = "Password should contain maximum  " + Convert.ToString(objPasswordConfig.MaxLength) + " characters.";
                        isPasswordValid = false;
                    }
                    else
                    {
                        isPasswordValid = true;
                    }
                }
                if (isPasswordValid && objPasswordConfig.MinLength > 0)
                {
                    if (i_sPasswordToValidate.Length < objPasswordConfig.MinLength)
                    {
                        o_sErrorMessage = "Password should contain minimum " + Convert.ToString(objPasswordConfig.MinLength) + " characters.";
                        isPasswordValid = false;
                    }
                    else
                    {
                        isPasswordValid = true;
                    }
                }
                if (isPasswordValid && objPasswordConfig.MinNumbers > 0 && objPasswordConfig.MinNumbers != 0)
                {
                    string sRegularExpressionForNumber = "(?:\\d.*){" + Convert.ToString(objPasswordConfig.MinNumbers) + ",}";
                    if (!Regex.IsMatch(i_sPasswordToValidate as string, sRegularExpressionForNumber, RegexOptions.IgnoreCase))
                    {
                        o_sErrorMessage = "Password should contain minimum " + Convert.ToString(objPasswordConfig.MinNumbers) + " number characters.";
                        isPasswordValid = false;
                    }
                    else
                    {
                        isPasswordValid = true;
                    }
                }
                if (isPasswordValid && objPasswordConfig.MinAlphabets > 0 && objPasswordConfig.MinAlphabets != 0)
                {
                    string sRegularExpressionForAlphabets = "(?:[A-Za-z]){" + Convert.ToString(objPasswordConfig.MinAlphabets) + ",}";
                    if (!Regex.IsMatch(i_sPasswordToValidate as string, sRegularExpressionForAlphabets, RegexOptions.IgnoreCase))
                    {
                        o_sErrorMessage = "Password should contain minimum " + Convert.ToString(objPasswordConfig.MinAlphabets) + " alphabet characters.";
                        isPasswordValid = false;
                    }
                    else
                    {
                        isPasswordValid = true;
                    }
                }
                if (isPasswordValid && objPasswordConfig.MinSplChar > 0 && objPasswordConfig.MinSplChar != 0)
                {
                    string sRegularExpressionForSpecialCharacter = "(?:[!@#$%^&*]){" + Convert.ToString(objPasswordConfig.MinSplChar) + ",}";
                    var MinimumSplChar = objPasswordConfig.MinSplChar;
                    var pwdSpecialCharacterCount = Regex.Matches(i_sPasswordToValidate, "[!@#$%^&*]").Count;
                    if (pwdSpecialCharacterCount < MinimumSplChar)
                    {
                        o_sErrorMessage = "Password should contain minimum " + Convert.ToString(objPasswordConfig.MinSplChar) + " special character. Only (!,@,#,$,%,^,&,*) special characters are allowed.";
                        isPasswordValid = false;
                    }
                    else
                    {
                        var pwdSpecialRestrictedCharacterCount = Regex.Matches(i_sPasswordToValidate, @"[""'()+,-./:;<=>?_`{|}~\[\]\\]").Count;
                        if (pwdSpecialRestrictedCharacterCount == 0)
                        {
                            isPasswordValid = true;
                        }
                        else
                        {
                            o_sErrorMessage = "Password should contain minimum " + Convert.ToString(objPasswordConfig.MinSplChar) + " special character. Only (!,@,#,$,%,^,&,*) special characters are allowed.";
                            isPasswordValid = false;
                        }
                    }
                }
                if (isPasswordValid && objPasswordConfig.MinUppercaseChar > 0 && objPasswordConfig.MinUppercaseChar != 0)
                {
                    string sRegularExpressionForUpperCaseAlphabets = "(?:[A-Z]){" + Convert.ToString(objPasswordConfig.MinUppercaseChar) + ",}";
                    if (!Regex.IsMatch(i_sPasswordToValidate as string, sRegularExpressionForUpperCaseAlphabets))
                    {
                        o_sErrorMessage = "Password should contain minimum " + Convert.ToString(objPasswordConfig.MinUppercaseChar) + " upper case alphabet characters.";
                        isPasswordValid = false;
                    }
                    else
                    {
                        isPasswordValid = true;
                    }
                }
            }
            catch (Exception exp)
            {
                o_sErrorMessage = exp.Message;
                isPasswordValid = false;
            }
            return isPasswordValid;
        }

        #region Write Debug Log to File
        /// <summary>
        /// This method is used to write debug log to file. Log will be written when debug flag is set true in web config
        /// </summary>
        /// <param name="sRequestURL"></param>
        /// <param name="sClassName"></param>
        /// <param name="sMethodName"></param>
        /// <param name="sLogMessage"></param>
        public static void WriteLogToFile(string sLogMessage, System.Reflection.MethodBase objCurrentMethod = null, Exception ObjException = null)
        {
            CompilationSection compilationSection = (CompilationSection)System.Configuration.ConfigurationManager.GetSection(@"system.web/compilation");

            string LogFilePath = System.Web.HttpContext.Current.Server.MapPath("~/DebugLogs");

            string LogFileName = "VigilateLog_" + string.Format("{0:ddMMMMyyyy}", DateTime.Now) + ".txt";

            string LogSperator = " \t ";
            string LogString = "";

            string sNamespace = "";
            string sClassName = "";
            string sMethodName = "";
            string sParameter = "";

            try
            {
                if (objCurrentMethod != null)
                {
                    sNamespace = objCurrentMethod.ReflectedType.Namespace;
                    sClassName = objCurrentMethod.ReflectedType.Name;
                    sMethodName = objCurrentMethod.Name;
                    //sParameter = string.Join(",", objCurrentMethod.GetParameters().Select(o => string.Format("{0} {1}", o.ParameterType, o.Name)).ToArray());
                }

                //build log string
                LogString += DateTime.Now.ToString() + LogSperator;

                try
                {
                    LogString += HttpContext.Current.Request.Url.ToString() + LogSperator; //request url 
                }
                catch { }

                LogString += sNamespace + LogSperator;
                LogString += sClassName + LogSperator;
                LogString += sMethodName + LogSperator;
                LogString += sParameter + LogSperator;

                LogString += sLogMessage + LogSperator;

                if (ObjException != null)
                {
                    LogString += "Exception Message - " + ObjException.Message + LogSperator;
                    LogString += "Exception Trace - " + ObjException.ToString() + LogSperator;
                }

                //check if debug is true
                if (compilationSection.Debug == true)
                {
                    //check and create debug folder, if not exists, to write log
                    if (!Directory.Exists(LogFilePath))
                    {
                        Directory.CreateDirectory(LogFilePath);
                    }

                    // write log into file
                    using (FileStream objFileStream = new FileStream(Path.Combine(LogFilePath, LogFileName), FileMode.Append, FileAccess.Write, FileShare.ReadWrite))
                    {
                        StreamWriter objStreamWriter = new StreamWriter(objFileStream);

                        objStreamWriter.WriteLine(LogString);

                        objStreamWriter.Close();
                        objStreamWriter.Dispose();

                        objFileStream.Close();
                        objFileStream.Dispose();
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {
                compilationSection = null;
            }
        }
        #endregion Write Debug Log to File
    }

    /// <summary>
    /// This is a temporary class used for semuliting the results returned from the PasswordPolicy table.
    /// After implementation this class will be removed and data will be received from the DAL
    /// </summary>
    public class PasswordPolicy
    {
        public int nMaxLength { get; set; }
        public int nMinLength { get; set; }
        public int nMinNoOfAlphabets { get; set; }
        public int nMinNoOfNumbers { get; set; }
        public int nMinSpecialCharacters { get; set; }
        public int nMinUpperCaseLetters { get; set; }

    }

    public class SessionManagement : System.Web.HttpApplication
    {
        public void BindCookiesSessions(LoginUserDetails loginUserDetails, bool IsNew, HttpRequest httpRequest, HttpResponse httpResponse, string sessionValue)
        {
            #region WorkAround [START]
            if (httpRequest.Cookies[ConstEnum.CookiesValue.ValidationCookies] == null)
            {
                HttpCookie VigilanteCookie = new HttpCookie(ConstEnum.CookiesValue.ValidationCookies);
                VigilanteCookie.Value = HttpContext.Current.Session[ConstEnum.SessionValue.CookiesValidationKey].ToString();
                VigilanteCookie.HttpOnly = true;
                VigilanteCookie.Secure = ((HttpCookiesSection)System.Configuration.ConfigurationManager.GetSection(@"system.web/httpCookies")).RequireSSL;
                //VigilanteCookie.Expires = DateTime.Now.AddMinutes(20);
                VigilanteCookie.Path = httpRequest.ApplicationPath;
                httpResponse.Cookies.Set(VigilanteCookie);
                httpRequest.Cookies.Add(new HttpCookie(ConstEnum.CookiesValue.ValidationCookies));
            }
            #endregion WorkAround [END]

            //#region Session Fixation
            ////NOTE: Keep this Session and Auth Cookie check
            //InsiderTradingDAL.SessionDetailsDTO objSessionDetailsDTO = null;
            //string decrypteddata = null;
            //string encrypteddata = null;
            //string validationCookies = ConstEnum.CookiesValue.ValidationCookies;
            //string CookiesValidationKey = ConstEnum.SessionValue.CookiesValidationKey;
            //string str_currentUrl = string.Empty;

            //try
            //{
            //    if (sessionValue != "LOGOUT")
            //    {
            //        if (httpRequest.UrlReferrer == null && (!(httpRequest.RawUrl.ToUpper().Contains("LOGOUT".ToUpper()) || httpRequest.RawUrl.ToUpper().Contains("LOGIN".ToUpper()))))
            //            throw new Exception("Invalid Login");

            //        if ((HttpContext.Current.Session != null && HttpContext.Current.Session[CookiesValidationKey] != null && httpRequest.Cookies[validationCookies] != null) || IsNew)
            //        {

            //            if (!IsNew)
            //                Common.dencryptData(httpRequest.Cookies[validationCookies].Value, out decrypteddata);
            //            string strCookieName = (IsNew ? string.Empty : decrypteddata + '~' + DateTime.Now.DayOfWeek.ToString().ToUpper());

            //            //get user ip address
            //            string _UserIPAddress = (string.IsNullOrEmpty(httpRequest.ServerVariables["HTTP_X_FORWARDED_FOR"])) ?
            //                                            (string.IsNullOrEmpty(httpRequest.UserHostAddress) ?
            //                                                httpRequest.ServerVariables["REMOTE_ADDR"] : httpRequest.UserHostAddress) :
            //                                        httpRequest.ServerVariables["HTTP_X_FORWARDED_FOR"].Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries).FirstOrDefault();

            //            //get browser information 
            //            string _browserInfo = httpRequest.Browser.Browser + httpRequest.Browser.Version + httpRequest.UserAgent
            //                                    + "~" + httpRequest.Browser.Platform
            //                                    + "~" + httpRequest.Browser.MajorVersion
            //                                    + "~" + httpRequest.Browser.MinorVersion
            //                                    + "~" + _UserIPAddress;

            //            //set common string used for validation
            //            string _session_cookies_common_value = loginUserDetails.UserName + "^" + DateTime.Now.Ticks + "^" + _browserInfo + "^" + System.Guid.NewGuid();


            //            /* This logic makes sure that even if the ASP.NET_SessionId cookie value is known to the hijacker, 
            //            he will not be able to login to the application as we are checking for the new Session value with 
            //            the new cookie that is created by us and their GUID value is created by us. A hijacker can know the 
            //            Cookie value but he can’t know the Session value that is stored in the web server level, and as this 
            //            AuthToken value changes every time the user logs in, the older value will not work and the hijacker will 
            //            not be able to even guess this value. Unless the new Session (AuthToken) value and the new Cookie (AuthToken) 
            //            are the same, no one will be able to login to the application. */
            //            if (!IsNew)
            //            {
            //                Common.dencryptData(HttpContext.Current.Session[CookiesValidationKey].ToString(), out decrypteddata);
            //                Common.dencryptData(decrypteddata.Split('^')[4].ToString(), out decrypteddata);
            //                if (decrypteddata.Equals(string.Empty))
            //                {
            //                    Common.dencryptData(HttpContext.Current.Session[CookiesValidationKey].ToString(), out decrypteddata);
            //                    decrypteddata = decrypteddata.Split('^')[4].ToString();
            //                }
            //                else
            //                    decrypteddata = decrypteddata + '~' + DateTime.Now.DayOfWeek.ToString().ToUpper();
            //            }
            //            string sPrev_v_au2 = string.Empty;
            //            DateTime dtPrevDatetime = DateTime.Now;
            //            if (HttpContext.Current.Session["Prev_" + validationCookies] != null)
            //                sPrev_v_au2 = Convert.ToString(HttpContext.Current.Session["Prev_" + validationCookies]);

            //            if (HttpContext.Current.Session["dtPrevDatetime"] != null)
            //                dtPrevDatetime = Convert.ToDateTime(HttpContext.Current.Session["dtPrevDatetime"]).AddSeconds(30);

            //            using (DataSet ds_ByPassFileList = new DataSet("ds"))
            //            {
            //                string path = System.Configuration.ConfigurationManager.AppSettings["Binaries"];
            //                string ds_ByPassFileListString = string.Empty;
            //                string decryptedByPassFile;
            //                if (File.Exists(path + @"\ByPassFileListEncrypted.xml"))
            //                {
            //                    ds_ByPassFileListString = File.ReadAllText(path + @"\ByPassFileListEncrypted.xml");
            //                }
            //                File.Delete(path + @"\ByPassFileListDecrypted.xml");
            //                using (FileStream fs = File.Create(path + @"\ByPassFileListDecrypted.xml"))
            //                {
            //                    fs.Close();
            //                    Common.dencryptData(ds_ByPassFileListString, out decryptedByPassFile);
            //                    File.WriteAllText(path + @"\ByPassFileListDecrypted.xml", decryptedByPassFile);
            //                }
            //                ds_ByPassFileList.ReadXml(System.Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["Binaries"]) + @"\ByPassFileListDecrypted.xml");

            //                string str_virtualDirectoryName = HttpRuntime.AppDomainAppVirtualPath.ToString();
            //                str_currentUrl = (httpRequest.RawUrl.Length > 1 ? httpRequest.RawUrl.Replace((str_virtualDirectoryName.Equals("/") ? "GarbageValue" : str_virtualDirectoryName), string.Empty).ToUpper().TrimStart('/').Split('/')[0] : string.Empty);
            //                if ((!IsNew) && ((decrypteddata != strCookieName && strCookieName != sPrev_v_au2)) && !httpRequest.RawUrl.ToUpper().Contains("RESERVED.REPORTVIEWERWEBCONTROL") && !httpRequest.RawUrl.ToUpper().Contains("/COMMONSSRSREPORT/SSRSREPORTVIEWER") && (ds_ByPassFileList.Tables["PageName"].Select("PageName_Text like '%" + str_currentUrl + "%'").Length.Equals(0)) && dtPrevDatetime >= DateTime.Now)
            //                {
            //                    if ((httpRequest.RawUrl.ToUpper().Contains("LOGOUT".ToUpper())) || (httpRequest.RawUrl.ToUpper().Contains("LOGIN".ToUpper())))
            //                    {
            //                        //DO NOTHING
            //                    }
            //                    else
            //                        throw new Exception("Invalid Login");
            //                }
            //                else
            //                {
            //                    if (loginUserDetails == null)
            //                        loginUserDetails = (LoginUserDetails)Session[ConstEnum.SessionValue.UserDetails];

            //                    if (loginUserDetails == null)
            //                        return;

            //                    HttpContext.Current.Session["Prev_" + validationCookies] = decrypteddata;
            //                    HttpContext.Current.Session["dtPrevDatetime"] = DateTime.Now;

            //                    using (UserInfoSL objUserInfoSL = new UserInfoSL())
            //                    {
            //                        objSessionDetailsDTO = objUserInfoSL.GetCookieStatus(loginUserDetails.CompanyDBConnectionString, loginUserDetails.LoggedInUserID, decrypteddata, IsNew, true);
            //                        Common.encryptData(objSessionDetailsDTO.CookieName.Split('~')[0], out encrypteddata);
            //                        strCookieName = encrypteddata;

            //                        _session_cookies_common_value = _session_cookies_common_value + "^" + objSessionDetailsDTO.CookieName;
            //                        Common.encryptData(_session_cookies_common_value, out encrypteddata);
            //                        HttpContext.Current.Session[CookiesValidationKey] = encrypteddata;
            //                        if (httpRequest.Cookies[validationCookies] != null)
            //                        {
            //                            try
            //                            {
            //                                httpResponse.Cookies[validationCookies].Expires = DateTime.Now.AddYears(-1);
            //                            }
            //                            catch
            //                            { }
            //                            httpResponse.Cookies.Remove(validationCookies);
            //                        }

            //                        HttpCookie VigilanteCookie = new HttpCookie(validationCookies);
            //                        VigilanteCookie.Value = strCookieName;
            //                        VigilanteCookie.HttpOnly = true;
            //                        VigilanteCookie.Secure = ((HttpCookiesSection)System.Configuration.ConfigurationManager.GetSection(@"system.web/httpCookies")).RequireSSL;
            //                        VigilanteCookie.Expires = DateTime.Now.AddMinutes(20);
            //                        VigilanteCookie.Path = httpRequest.ApplicationPath;
            //                        httpResponse.Cookies.Set(VigilanteCookie);

            //                        if (IsNew)
            //                        {
            //                            HttpContext.Current.Session["Prev_" + validationCookies] = objSessionDetailsDTO.CookieName;
            //                            HttpContext.Current.Session["dtPrevDatetime"] = DateTime.Now;
            //                        }

            //                    }
            //                }
            //            }
            //        }
            //        else if (HttpContext.Current.Session == null || HttpContext.Current.Session[CookiesValidationKey] == null || httpRequest.Cookies[validationCookies] == null)
            //        {
            //            if ((httpRequest.RawUrl.ToUpper().Contains("LOGOUT".ToUpper())) || (httpRequest.RawUrl.ToUpper().Contains("LOGIN".ToUpper())))
            //            {
            //                //DO NOTHING
            //            }
            //            else
            //                throw new Exception("Invalid Login");
            //        }
            //    }
            //    else
            //    {
            //        if (loginUserDetails.CompanyDBConnectionString != null)
            //        {
            //            using (UserInfoSL objUserInfoSL = new UserInfoSL())
            //            {
            //                objSessionDetailsDTO = objUserInfoSL.GetCookieStatus(loginUserDetails.CompanyDBConnectionString, loginUserDetails.LoggedInUserID, sessionValue, IsNew, true);
            //            }
            //        }
            //    }
            //}
            //catch (Exception ex)
            //{
            //    if (ex.Message.ToString().Equals("Invalid Login"))
            //    {
            //        string[] str_Error = new string[3];
            //        str_Error[0] = "Request.Url:" + httpRequest.Url.ToString();
            //        str_Error[1] = ",Request.UrlReferrer:" + httpRequest.UrlReferrer.ToString();
            //        str_Error[2] = ",Request.RawUrl:" + str_currentUrl;
            //        File.AppendAllLines(Convert.ToString(ConfigurationManager.AppSettings["Binaries"]) + @"\" + DateTime.Now.ToString("ddMMMyyyy") + ".log", str_Error);
            //    }
            //    throw ex;
            //}
            //finally
            //{
            //    File.Delete(System.Configuration.ConfigurationManager.AppSettings["Binaries"] + @"\ByPassFileListDecrypted.xml");
            //}
            //#endregion

        }

        public void CheckCookiesSessions(LoginUserDetails loginUserDetails, bool IsNew, HttpRequest httpRequest, HttpResponse httpResponse, string sessionValue)
        {
            InsiderTradingDAL.SessionDetailsDTO objSessionDetailsDTO = null;
            if (loginUserDetails.CompanyDBConnectionString != null)
            {
                using (UserInfoSL objUserInfoSL = new UserInfoSL())
                {
                    objSessionDetailsDTO = objUserInfoSL.SaveCookieStatus(loginUserDetails.CompanyDBConnectionString, loginUserDetails.LoggedInUserID, (Convert.ToString(httpRequest.RequestContext.HttpContext.Session["GUIDSessionID"])).ToString());
                }
                if (objSessionDetailsDTO != null)
                {
                    if (objSessionDetailsDTO.CookieName == "Unauthorised")
                    {
                        throw new HttpException(403, "Your last session was terminated incorrectly or is still active. We are logging you out from all active sessions. Please re-login after 2 minutes.");
                    }
                    if (objSessionDetailsDTO.UserId != (Convert.ToInt32(loginUserDetails.LoggedInUserID)))
                    {
                        throw new HttpException(401, "Unauthorized access");
                    }
                }
            }
        }
    }


}