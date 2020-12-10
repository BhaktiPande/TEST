using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using InsiderTradingDAL;
using System.Data;

namespace InsiderTradingMassUpload
{
    public class UserInfoSL
    {
        #region GetUserDetails
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoId"></param>
        /// <param name="o_nReturnValue"></param>
        /// <param name="o_nErroCode"></param>
        /// <param name="o_sErrorMessage"></param>
        /// <returns></returns>
        public InsiderTradingDAL.UserInfoDTO GetUserDetails(string i_sConnectionString, int i_nUserInfoId)
        {
            InsiderTradingDAL.UserInfoDTO res=null;
          
            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.GetUserDetails(i_sConnectionString, i_nUserInfoId);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }
        #endregion GetUserDetails

        #region ForgetPassword
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_objUserInfoDTO"></param>
        /// <returns></returns>
        public PasswordManagementDTO ForgetPassword(string i_sConnectionString, PasswordManagementDTO i_objPwdMgmtDTO)
        {
            PasswordManagementDTO res = null;

            try
            {
                //InsiderTradingDAL.UserInfoDAL objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL();
                using (var objUserInfoDAL = new InsiderTradingDAL.UserInfoDAL())
                {
                    res = objUserInfoDAL.ForgetPassword(i_sConnectionString, i_objPwdMgmtDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return res;
        }

        #endregion ForgetPassword

    }
}