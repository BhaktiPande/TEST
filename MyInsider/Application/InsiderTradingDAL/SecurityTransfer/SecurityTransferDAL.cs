using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class SecurityTransferDAL : IDisposable
    {
        const string sLookUpPrefix = "usr_msg_";

        #region GetAvailableQuantityForIndividualDematOrAllDemat
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="i_nUserInfoID"></param>
        /// <param name="i_nSecurityTypeCodeID"></param>
        /// <param name="i_nDMATdetailsID"></param>
        /// <param name="i_nSecurityTransferOption"></param>
        /// <param name="out_dAvailableQuantity"></param>
        /// <returns></returns>
        public SecurityTransferDTO GetAvailableQuantityForIndividualDematOrAllDemat(string i_sConnectionString, int i_nUserInfoID, int i_nUserInfoRelativeID,
            int i_nSecurityTypeCodeID, int i_nDMATdetailsID,int i_nSecurityTransferOption,
            out decimal out_dAvailableQuantity, out decimal out_dAvailableESOPQuantity, out decimal out_dAvailableOtherQuantity)
        {
            SecurityTransferDTO res;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters
            try
            {
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                var dAvailableQuantity = new SqlParameter("@out_dAvailableQuantity", System.Data.SqlDbType.Decimal);
                dAvailableQuantity.Direction = System.Data.ParameterDirection.Output;
                var dAvailablePledgeQuantity = new SqlParameter("@out_dAvailablePledgeQuantity", System.Data.SqlDbType.Decimal);
                dAvailablePledgeQuantity.Direction = System.Data.ParameterDirection.Output;
                var dAvailableESOPQuantity = new SqlParameter("@out_dAvailableESOPQuantity", System.Data.SqlDbType.Decimal);
                dAvailableESOPQuantity.Direction = System.Data.ParameterDirection.Output;
                var dAvailableOtherQuantity = new SqlParameter("@out_dAvailableOtherQuantity", System.Data.SqlDbType.Decimal);
                dAvailableOtherQuantity.Direction = System.Data.ParameterDirection.Output;

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    db.CommandTimeout = 5000;
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<SecurityTransferDTO>("exec st_usr_GetAvailableQuantityForIndividualDematOrAllDemat @inp_iUserInfoID,@inp_iUserInfoRelativeID, @inp_iSecurityTypeCodeID,@inp_iDEMATdetailsID,@inp_iSecurityTransferOption,@out_dAvailableQuantity OUTPUT,@out_dAvailablePledgeQuantity OUTPUT,@out_dAvailableESOPQuantity OUTPUT,@out_dAvailableOtherQuantity OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                @inp_iUserInfoID = i_nUserInfoID,
                                @inp_iUserInfoRelativeID = i_nUserInfoRelativeID,
                                @inp_iSecurityTypeCodeID = i_nSecurityTypeCodeID,
                                inp_iDEMATdetailsID = i_nDMATdetailsID,
                                inp_iSecurityTransferOption = i_nSecurityTransferOption,
                                @out_dAvailableQuantity = dAvailableQuantity,
                                @out_dAvailablePledgeQuantity = dAvailablePledgeQuantity,
                                @out_dAvailableESOPQuantity = dAvailableESOPQuantity,
                                @out_dAvailableOtherQuantity = dAvailableOtherQuantity,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<SecurityTransferDTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }
                            //bReturn = false;
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            out_dAvailableQuantity = Convert.ToDecimal(dAvailableQuantity.Value);
                            out_dAvailableESOPQuantity = Convert.ToDecimal(dAvailableESOPQuantity.Value);
                            out_dAvailableOtherQuantity = Convert.ToDecimal(dAvailableOtherQuantity.Value);
                            scope.Complete();
                        }
                    }
                }


            }
            catch (Exception exp)
            {
                //bReturn = false;
                throw exp;
            }
            return res;
        }
        #endregion GetAvailableQuantityForIndividualDematOrAllDemat

        #region TransferBalance
        /// <summary>
        /// 
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="objSecurityTransferDTO"></param>
        /// <returns></returns>
        public InsiderTradingDAL.SecurityTransferDTO TransferBalance(string i_sConnectionString, SecurityTransferDTO objSecurityTransferDTO)
        {
            SecurityTransferDTO res;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters
            try
            {
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    db.CommandTimeout = 5000;
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<SecurityTransferDTO>("exec st_usr_SaveTransferBalanceLog @inp_iUserInfoId,@inp_iForUserInfoId, @inp_iSecurityTransferOption,@inp_dTransferQuantity," +
                                       "@inp_iSecurityTypeCodeID,@inp_iFromDEMATAcountID,@inp_iToDEMATAcountID,@inp_iTransferFor,@inp_dTransferESOPQuantity,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                @inp_iUserInfoId = objSecurityTransferDTO.UserInfoId,
                                @inp_iForUserInfoId = objSecurityTransferDTO.ForUserInfoId,
                                @inp_iSecurityTransferOption = objSecurityTransferDTO.SecurityTransferOption,
                                @inp_dTransferQuantity = objSecurityTransferDTO.TransferQuantity,
                                @inp_iSecurityTypeCodeID = objSecurityTransferDTO.SecurityTypeCodeID,
                                @inp_iFromDEMATAcountID = objSecurityTransferDTO.FromDEMATAcountID,
                                @inp_iToDEMATAcountID = objSecurityTransferDTO.ToDEMATAcountID,
                                @inp_iTransferFor = objSecurityTransferDTO.TransferFor,
                                @inp_dTransferESOPQuantity = objSecurityTransferDTO.TransferESOPQuantity,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<SecurityTransferDTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }
                            //bReturn = false;
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                        }
                    }
                }


            }
            catch (Exception exp)
            {
                //bReturn = false;
                throw exp;
            }
            return res;
        }
         #endregion TransferBalance


        #region GetPendingTransactionforSecurityTransfer

        public SecurityTransferDTO GetPendingTransactionforSecurityTransfer(string i_sConnectionString, int i_nUserInfoID,
            out int out_PendingPeriodEndCount, out int out_PendingTransactionsCountPNT, out int out_PendingTransactionsCountPCL)
        {
            SecurityTransferDTO res;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters
            try
            {
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                var dPendingPeriodEndCount = new SqlParameter("@out_PendingPeriodEndCount", System.Data.SqlDbType.Int);
                dPendingPeriodEndCount.Direction = System.Data.ParameterDirection.Output;
                var dPendingTransactionsCountPNT = new SqlParameter("@out_PendingTransactionsCountPNT", System.Data.SqlDbType.Int);
                dPendingTransactionsCountPNT.Direction = System.Data.ParameterDirection.Output;
                var dPendingTransactionsCountPCL = new SqlParameter("@out_PendingTransactionsCountPCL", System.Data.SqlDbType.Int);
                dPendingTransactionsCountPCL.Direction = System.Data.ParameterDirection.Output;


                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    db.CommandTimeout = 5000;
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<SecurityTransferDTO>("exec st_usr_PendingTransactionforSecurityTransfer @inp_iUserInfoID,@out_PendingPeriodEndCount OUTPUT,@out_PendingTransactionsCountPNT OUTPUT,@out_PendingTransactionsCountPCL OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                @inp_iUserInfoID = i_nUserInfoID,
                                @out_PendingPeriodEndCount = dPendingPeriodEndCount,
                                @out_PendingTransactionsCountPNT = dPendingTransactionsCountPNT,
                                @out_PendingTransactionsCountPCL = dPendingTransactionsCountPCL,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<SecurityTransferDTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }
                            //bReturn = false;
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            out_PendingPeriodEndCount = Convert.ToInt32(dPendingPeriodEndCount.Value);
                            out_PendingTransactionsCountPNT = Convert.ToInt32(dPendingTransactionsCountPNT.Value);
                            out_PendingTransactionsCountPCL = Convert.ToInt32(dPendingTransactionsCountPCL.Value);
                            scope.Complete();
                        }
                    }
                }


            }
            catch (Exception exp)
            {
                //bReturn = false;
                throw exp;
            }
            return res;
        }
        #endregion GetPendingTransactionforSecurityTransfer

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
