using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class MassUploadDAL:IDisposable
    {
        const string sLookupPrefix = "";

        #region GetDataTableName
        /// <summary>
        /// This function will be fetching the Data Table Name to be used for the given Datatable id
        /// </summary>
        /// <param name="i_nDataTableId"></param>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public string GetDataTableName(int i_nDataTableId, string sConnectionString)
        {
            List<MassUploadDTO> res = null;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            string sReturnDatatableName = "";
            #endregion Paramters
            try
            {
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";
                var sDataTableName = new SqlParameter("@out_sDatatableName", System.Data.SqlDbType.VarChar);
                sDataTableName.Direction = System.Data.ParameterDirection.Output;
                sDataTableName.Size = 200;
                sDataTableName.Value = "";

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<MassUploadDTO>("exec st_com_MassUploadGetDataTableName @inp_iMassUploadDataTableId,@out_sDatatableName OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iMassUploadDataTableId = i_nDataTableId,
                            out_sDatatableName = sDataTableName,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<MassUploadDTO>();
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }

                }
                sReturnDatatableName = Convert.ToString(sDataTableName.Value);
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return sReturnDatatableName;
            //return "MassEmployeeImportDataTable";
        }
        #endregion GetDataTableName

        #region GetMassUploadConfiguration
        /// <summary>
        ///  This function will return the Configuration for the MassUpload for given MassUploadId
        /// </summary>
        /// <param name="i_nMassUploadId">Mass Upload Id</param>
        /// <param name="sConnectionString">Database connection string</param>
        /// <returns>MassUploadDTO</returns>
        public IEnumerable<MassUploadDTO> GetMassUploadConfiguration(int i_nMassUploadId, string sConnectionString)
        {
            List<MassUploadDTO> res = null;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters
            try
            {

                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<MassUploadDTO>("exec st_com_MassUploadGetconfiguration @inp_iMassUploadId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_iMassUploadId = i_nMassUploadId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<MassUploadDTO>();
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetMassUploadConfiguration

        #region ExecuteMassUploadCall

        public void ExecuteMassUploadCall(int i_nMassUploadSheetId, DataTable i_objMassUploadDataTable,string i_sDataTableName, string i_sProcedureName, string i_sConnectionString,
            int i_nLoggedInUserID,out List<MassUploadResponseDTO> o_objReturnIdList, out string sSheetErrorMessageCode)
        {
            #region Paramters
            //int out_nReturnValue;
            //int out_nSQLErrCode;
            //string out_sSQLErrMessageCode;
            sSheetErrorMessageCode = "";
            //bool bReturn = true;
            //string out_sReturnBulkUserImport;
            #endregion Paramters
            o_objReturnIdList = new List<MassUploadResponseDTO>();
            try
            {
                #region Out Paramter
                var nout_nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nout_nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nout_nReturnValue.Value = 0;
                var nout_nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nout_nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nout_nSQLErrCode.Value = 0;
                var sout_sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.NVarChar);
                sout_sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sout_sSQLErrMessage.Size = 500;
                sout_sSQLErrMessage.Value = string.Empty;
                
                var inp_tblBulkUserEmployeeInsiderImport = new SqlParameter();
                inp_tblBulkUserEmployeeInsiderImport.DbType = DbType.Object;
                inp_tblBulkUserEmployeeInsiderImport.ParameterName = "@inp_tblBulkEmployeeInsiderImport";
                inp_tblBulkUserEmployeeInsiderImport.TypeName = "dbo.MassEmployeeInsiderImportDataTable";
                inp_tblBulkUserEmployeeInsiderImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 1)
                {
                    inp_tblBulkUserEmployeeInsiderImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkUserNonEmployeeInsiderImport = new SqlParameter();
                inp_tblBulkUserNonEmployeeInsiderImport.DbType = DbType.Object;
                inp_tblBulkUserNonEmployeeInsiderImport.ParameterName = "@inp_tblBulkNonEmployeeInsiderImport";
                inp_tblBulkUserNonEmployeeInsiderImport.TypeName = "dbo.MassNonEmployeeInsiderImportDataTable";
                inp_tblBulkUserNonEmployeeInsiderImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 2)
                {
                    inp_tblBulkUserNonEmployeeInsiderImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkUserCorpEmployeeInsiderImport = new SqlParameter();
                inp_tblBulkUserCorpEmployeeInsiderImport.DbType = DbType.Object;
                inp_tblBulkUserCorpEmployeeInsiderImport.ParameterName = "@inp_tblBulkCorpEmployeeInsiderImport";
                inp_tblBulkUserCorpEmployeeInsiderImport.TypeName = "dbo.MassCorpEmployeeInsiderImportDataTable";
                inp_tblBulkUserCorpEmployeeInsiderImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 3)
                {
                    inp_tblBulkUserCorpEmployeeInsiderImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkEmployeeRelativeImport = new SqlParameter();
                inp_tblBulkEmployeeRelativeImport.DbType = DbType.Object;
                inp_tblBulkEmployeeRelativeImport.ParameterName = "@inp_tblBulkEmpRelativesImport";
                inp_tblBulkEmployeeRelativeImport.TypeName = "dbo.MassRelativesImportDataTable";
                inp_tblBulkEmployeeRelativeImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 4)
                {
                    inp_tblBulkEmployeeRelativeImport.SqlValue = i_objMassUploadDataTable;
                }


                var inp_tblBulkNonEmployeeRelativeImport = new SqlParameter();
                inp_tblBulkNonEmployeeRelativeImport.DbType = DbType.Object;
                inp_tblBulkNonEmployeeRelativeImport.ParameterName = "@inp_tblBulkNonEmpRelativesImport";
                inp_tblBulkNonEmployeeRelativeImport.TypeName = "dbo.MassRelativesImportDataTable";
                inp_tblBulkNonEmployeeRelativeImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 5)
                {
                    inp_tblBulkNonEmployeeRelativeImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkEmployeeDMATDetailsImport = new SqlParameter();
                inp_tblBulkEmployeeDMATDetailsImport.DbType = DbType.Object;
                inp_tblBulkEmployeeDMATDetailsImport.ParameterName = "@inp_tblBulkEmpDMATDetailsImport";
                inp_tblBulkEmployeeDMATDetailsImport.TypeName = "dbo.IndividualDmatDetailsDataTable";
                inp_tblBulkEmployeeDMATDetailsImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 6)
                {
                    inp_tblBulkEmployeeDMATDetailsImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkNonEmployeeDMATDetailsImport = new SqlParameter();
                inp_tblBulkNonEmployeeDMATDetailsImport.DbType = DbType.Object;
                inp_tblBulkNonEmployeeDMATDetailsImport.ParameterName = "@inp_tblBulkNonEmpDMATDetailsImport";
                inp_tblBulkNonEmployeeDMATDetailsImport.TypeName = "dbo.IndividualDmatDetailsDataTable";
                inp_tblBulkNonEmployeeDMATDetailsImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 7)
                {
                    inp_tblBulkNonEmployeeDMATDetailsImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkCorpEmployeeDMATDetailsImport = new SqlParameter();
                inp_tblBulkCorpEmployeeDMATDetailsImport.DbType = DbType.Object;
                inp_tblBulkCorpEmployeeDMATDetailsImport.ParameterName = "@inp_tblBulkCorpEmpDMATDetailsImport";
                inp_tblBulkCorpEmployeeDMATDetailsImport.TypeName = "dbo.IndividualDmatDetailsDataTable";
                inp_tblBulkCorpEmployeeDMATDetailsImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 8)
                {
                    inp_tblBulkCorpEmployeeDMATDetailsImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkEmployeeRelativeDMATDetailsImport = new SqlParameter();
                inp_tblBulkEmployeeRelativeDMATDetailsImport.DbType = DbType.Object;
                inp_tblBulkEmployeeRelativeDMATDetailsImport.ParameterName = "@inp_tblBulkEmpRelativeDMATDetailsImport";
                inp_tblBulkEmployeeRelativeDMATDetailsImport.TypeName = "dbo.IndividualDmatDetailsDataTable";
                inp_tblBulkEmployeeRelativeDMATDetailsImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 9)
                {
                    inp_tblBulkEmployeeRelativeDMATDetailsImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkNonEmployeeRelativeDMATDetailsImport = new SqlParameter();
                inp_tblBulkNonEmployeeRelativeDMATDetailsImport.DbType = DbType.Object;
                inp_tblBulkNonEmployeeRelativeDMATDetailsImport.ParameterName = "@inp_tblBulkNonEmpRelativeDMATDetailsImport";
                inp_tblBulkNonEmployeeRelativeDMATDetailsImport.TypeName = "dbo.IndividualDmatDetailsDataTable";
                inp_tblBulkNonEmployeeRelativeDMATDetailsImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 10)
                {
                    inp_tblBulkNonEmployeeRelativeDMATDetailsImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkInitialDisclosureDetailsImport = new SqlParameter();
                inp_tblBulkInitialDisclosureDetailsImport.DbType = DbType.Object;
                inp_tblBulkInitialDisclosureDetailsImport.ParameterName = "@inp_tblBulkInitialDisclosureDetailsImport";
                inp_tblBulkInitialDisclosureDetailsImport.TypeName = "dbo.MassInitialDisclosureDataTable";
                inp_tblBulkInitialDisclosureDetailsImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 11)
                {
                    inp_tblBulkInitialDisclosureDetailsImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkRegisterTransferDetailsImport = new SqlParameter();
                inp_tblBulkRegisterTransferDetailsImport.DbType = DbType.Object;
                inp_tblBulkRegisterTransferDetailsImport.ParameterName = "@inp_tblBulkRegisterTransferDetailsImport";
                inp_tblBulkRegisterTransferDetailsImport.TypeName = "dbo.MassRegisterAndTransferDataTable";
                inp_tblBulkRegisterTransferDetailsImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 51)
                {
                    inp_tblBulkRegisterTransferDetailsImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkHistoryPreclearanceRequestImportDataTable = new SqlParameter();
                inp_tblBulkHistoryPreclearanceRequestImportDataTable.DbType = DbType.Object;
                inp_tblBulkHistoryPreclearanceRequestImportDataTable.ParameterName = "@inp_tblBulkHistoryPreclearanceRequestImportDataTable";
                inp_tblBulkHistoryPreclearanceRequestImportDataTable.TypeName = "dbo.MassHistoryPreclearanceRequestImportDataTable";
                inp_tblBulkHistoryPreclearanceRequestImportDataTable.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 12)
                {
                    inp_tblBulkHistoryPreclearanceRequestImportDataTable.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkHistoryTransactionImportDataTable = new SqlParameter();
                inp_tblBulkHistoryTransactionImportDataTable.DbType = DbType.Object;
                inp_tblBulkHistoryTransactionImportDataTable.ParameterName = "@inp_tblBulkHistoryTransactionImportDataTable";
                inp_tblBulkHistoryTransactionImportDataTable.TypeName = "dbo.MassHistoryTransactionImportDataTable";
                inp_tblBulkHistoryTransactionImportDataTable.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 13)
                {
                    inp_tblBulkHistoryTransactionImportDataTable.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkTransactionImportDataTable = new SqlParameter();
                inp_tblBulkTransactionImportDataTable.DbType = DbType.Object;
                inp_tblBulkTransactionImportDataTable.ParameterName = "@inp_tblBulkTransactionImportDataTable";
                inp_tblBulkTransactionImportDataTable.TypeName = "dbo.MassTransactionImportDataTable";
                inp_tblBulkTransactionImportDataTable.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 14)
                {
                    inp_tblBulkTransactionImportDataTable.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkNonTradingDaysDetailsImport = new SqlParameter();
                inp_tblBulkNonTradingDaysDetailsImport.DbType = DbType.Object;
                inp_tblBulkNonTradingDaysDetailsImport.ParameterName = "@inp_tblBulkNonTradingDaysDetailsImport";
                inp_tblBulkNonTradingDaysDetailsImport.TypeName = "dbo.MassNonTradingDaysDataTable";
                inp_tblBulkNonTradingDaysDetailsImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 52)
                {
                    inp_tblBulkNonTradingDaysDetailsImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkSeparationDataTableImport = new SqlParameter();
                inp_tblBulkSeparationDataTableImport.DbType = DbType.Object;
                inp_tblBulkSeparationDataTableImport.ParameterName = "@inp_tblBulkSeparationDataTableImport";
                inp_tblBulkSeparationDataTableImport.TypeName = "dbo.MassSeparationDataTable";
                inp_tblBulkSeparationDataTableImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 53)
                {
                    inp_tblBulkSeparationDataTableImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkRestrictedListAppliDataTableImport = new SqlParameter();
                inp_tblBulkRestrictedListAppliDataTableImport.DbType = DbType.Object;
                inp_tblBulkRestrictedListAppliDataTableImport.ParameterName = "@inp_tblBulkRestrictedListAppliDetailsDataTableImport";
                inp_tblBulkRestrictedListAppliDataTableImport.TypeName = "dbo.MassRestrictedListAppliDataTable";
                inp_tblBulkRestrictedListAppliDataTableImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 54)
                {
                    inp_tblBulkRestrictedListAppliDataTableImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkRestrictedLiMasterCompanyDataTableImport = new SqlParameter();
                inp_tblBulkRestrictedLiMasterCompanyDataTableImport.DbType = DbType.Object;
                inp_tblBulkRestrictedLiMasterCompanyDataTableImport.ParameterName = "@inp_tblBulkRestrictedLiMasterCompanyDataTableImport";
                inp_tblBulkRestrictedLiMasterCompanyDataTableImport.TypeName = "dbo.MassRistrictedMasterCompanyDataTable";
                inp_tblBulkRestrictedLiMasterCompanyDataTableImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 55)
                {
                    inp_tblBulkRestrictedLiMasterCompanyDataTableImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkMassDepartmentWiseRLDataTableImport = new SqlParameter();
                inp_tblBulkMassDepartmentWiseRLDataTableImport.DbType = DbType.Object;
                inp_tblBulkMassDepartmentWiseRLDataTableImport.ParameterName = "@inp_tblBulkMassDepartmentWiseRLDataTableImport";
                inp_tblBulkMassDepartmentWiseRLDataTableImport.TypeName = "dbo.MassDepartmentWiseRLDataTable";
                inp_tblBulkMassDepartmentWiseRLDataTableImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 56)
                {
                    inp_tblBulkMassDepartmentWiseRLDataTableImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkMassDepartmentWiseRLAppliDataTableImport = new SqlParameter();
                inp_tblBulkMassDepartmentWiseRLAppliDataTableImport.DbType = DbType.Object;
                inp_tblBulkMassDepartmentWiseRLAppliDataTableImport.ParameterName = "@inp_tblBulkMassDepartmentWiseRLAppliDataTableImport";
                inp_tblBulkMassDepartmentWiseRLAppliDataTableImport.TypeName = "dbo.MassDepartmentWiseRLAppliDataTable";
                inp_tblBulkMassDepartmentWiseRLAppliDataTableImport.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 57)
                {
                    inp_tblBulkMassDepartmentWiseRLAppliDataTableImport.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkMassEmployeePeriodEndDataTable = new SqlParameter();
                inp_tblBulkMassEmployeePeriodEndDataTable.DbType = DbType.Object;
                inp_tblBulkMassEmployeePeriodEndDataTable.ParameterName = "@inp_tblBulkMassEmployeePeriodEndDataTable";
                inp_tblBulkMassEmployeePeriodEndDataTable.TypeName = "dbo.MassEmployeePeriodEndDataTable";
                inp_tblBulkMassEmployeePeriodEndDataTable.SqlDbType = SqlDbType.Structured;
                if (i_nMassUploadSheetId == 15)
                {
                    inp_tblBulkMassEmployeePeriodEndDataTable.SqlValue = i_objMassUploadDataTable;
                }


                var inp_tblBulkInitialDisclosureDetailsImport_OtherSecurities = new SqlParameter
                {
                    DbType = DbType.Object,
                    ParameterName = "@inp_tblBulkInitialDisclosure_OtherSecuritiesDetailsImport",
                    TypeName = "dbo.MassInitialDisclosure_OtherSecuritiesDataTable",
                    SqlDbType = SqlDbType.Structured
                };
                if (i_nMassUploadSheetId == 58)
                {
                    inp_tblBulkInitialDisclosureDetailsImport_OtherSecurities.SqlValue = i_objMassUploadDataTable;
                }

                var inp_tblBulkTransactionImport_OtherSecuritiesDataTable = new SqlParameter
                {
                    DbType = DbType.Object,
                    ParameterName = "@inp_tblBulkTransactionImport_OtherSecuritiesDataTable",
                    TypeName = "dbo.MassTransactionImport_OtherSecuritiesDataTable",
                    SqlDbType = SqlDbType.Structured
                };
                if (i_nMassUploadSheetId == 59)
                {
                    inp_tblBulkTransactionImport_OtherSecuritiesDataTable.SqlValue = i_objMassUploadDataTable;
                }

                #endregion Out Paramter

                using (var db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    //using (var scope = db.GetTransaction())
                   // {
                    db.CommandTimeout = 15000;
                        var res = db.Query<MassUploadResponseDTO>("exec " + i_sProcedureName
                            + " @inp_nMassUploadSheetId, @inp_tblBulkEmployeeInsiderImport,@inp_tblBulkNonEmployeeInsiderImport,@inp_tblBulkCorpEmployeeInsiderImport "
                            + " ,@inp_tblBulkEmpRelativesImport,@inp_tblBulkNonEmpRelativesImport,@inp_tblBulkEmpDMATDetailsImport,@inp_tblBulkNonEmpDMATDetailsImport "
                            + " ,@inp_tblBulkCorpEmpDMATDetailsImport,@inp_tblBulkEmpRelativeDMATDetailsImport,@inp_tblBulkNonEmpRelativeDMATDetailsImport "
                            + " ,@inp_tblBulkInitialDisclosureDetailsImport,@inp_tblBulkRegisterTransferDetailsImport,@inp_tblBulkHistoryPreclearanceRequestImportDataTable"
                            + " ,@inp_tblBulkHistoryTransactionImportDataTable, @inp_tblBulkTransactionImportDataTable ,@inp_tblBulkNonTradingDaysDetailsImport ,@inp_tblBulkSeparationDataTableImport"
                            + " ,@inp_tblBulkRestrictedListAppliDetailsDataTableImport, @inp_tblBulkRestrictedLiMasterCompanyDataTableImport, @inp_tblBulkMassDepartmentWiseRLDataTableImport, @inp_tblBulkMassDepartmentWiseRLAppliDataTableImport"
                            + " ,@inp_tblBulkMassEmployeePeriodEndDataTable, @inp_tblBulkInitialDisclosure_OtherSecuritiesDetailsImport, @inp_tblBulkTransactionImport_OtherSecuritiesDataTable"
                            + " ,@inp_nLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            @inp_nMassUploadSheetId = i_nMassUploadSheetId,
                            @inp_tblBulkEmployeeInsiderImport = inp_tblBulkUserEmployeeInsiderImport,
                            @inp_tblBulkNonEmployeeInsiderImport = inp_tblBulkUserNonEmployeeInsiderImport,
                            @inp_tblBulkCorpEmployeeInsiderImport=inp_tblBulkUserCorpEmployeeInsiderImport,
                            @inp_tblBulkEmpRelativesImport = inp_tblBulkEmployeeRelativeImport,
                            @inp_tblBulkNonEmpRelativesImport = inp_tblBulkNonEmployeeRelativeImport,
                            @inp_tblBulkEmpDMATDetailsImport = inp_tblBulkEmployeeDMATDetailsImport,
                            @inp_tblBulkNonEmpDMATDetailsImport = inp_tblBulkNonEmployeeDMATDetailsImport,
                            @inp_tblBulkCorpEmpDMATDetailsImport = inp_tblBulkCorpEmployeeDMATDetailsImport,
                            @inp_tblBulkEmpRelativeDMATDetailsImport = inp_tblBulkEmployeeRelativeDMATDetailsImport,
                            @inp_tblBulkNonEmpRelativeDMATDetailsImport = inp_tblBulkNonEmployeeRelativeDMATDetailsImport,
                            @inp_tblBulkInitialDisclosureDetailsImport = inp_tblBulkInitialDisclosureDetailsImport,
                            @inp_tblBulkRegisterTransferDetailsImport = inp_tblBulkRegisterTransferDetailsImport,
                            @inp_tblBulkHistoryPreclearanceRequestImportDataTable = inp_tblBulkHistoryPreclearanceRequestImportDataTable,
                            @inp_tblBulkHistoryTransactionImportDataTable = inp_tblBulkHistoryTransactionImportDataTable,
                            @inp_tblBulkTransactionImportDataTable = inp_tblBulkTransactionImportDataTable,
                            @inp_tblBulkNonTradingDaysDetailsImport = inp_tblBulkNonTradingDaysDetailsImport,
                            @inp_tblBulkSeparationDataTableImport = inp_tblBulkSeparationDataTableImport,
                            @inp_tblBulkRestrictedListAppliDetailsDataTableImport = inp_tblBulkRestrictedListAppliDataTableImport,
                            @inp_tblBulkRestrictedLiMasterCompanyDataTableImport = inp_tblBulkRestrictedLiMasterCompanyDataTableImport,
                            @inp_tblBulkMassDepartmentWiseRLDataTableImport = inp_tblBulkMassDepartmentWiseRLDataTableImport,
                            @inp_tblBulkMassDepartmentWiseRLAppliDataTableImport = inp_tblBulkMassDepartmentWiseRLAppliDataTableImport,
                            @inp_tblBulkMassEmployeePeriodEndDataTable = inp_tblBulkMassEmployeePeriodEndDataTable,
                            @inp_tblBulkInitialDisclosure_OtherSecuritiesDetailsImport = inp_tblBulkInitialDisclosureDetailsImport_OtherSecurities,
                            @inp_tblBulkTransactionImport_OtherSecuritiesDataTable = inp_tblBulkTransactionImport_OtherSecuritiesDataTable,

                            @inp_nLoggedInUserId = i_nLoggedInUserID,
                            @out_nReturnValue = nout_nReturnValue,
                            @out_nSQLErrCode = nout_nSQLErrCode,
                            @out_sSQLErrMessage = sout_sSQLErrMessage,

                        }).ToList<MassUploadResponseDTO>();

                        #region Error Values
                        //if (Convert.ToInt32(nout_nReturnValue.Value) != 0)
                        //{
                        //    sSheetErrorMessageCode = Convert.ToString(nout_nReturnValue.Value);
                        //}
                        //else
                        //{
                            //string sCreatedUsersIdInSequence = Convert.ToString(sout_sReturnBulkUserImport.Value);
                            //string[] arrSplitResponse = sCreatedUsersIdInSequence.Split(new char[] { ',' });
                            //List<string> lstResponses = arrSplitResponse.OfType<string>().ToList();
                            o_objReturnIdList = res;
                           //scope.Complete();
                        //}
                        #endregion Error Values
                    //}
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            finally
            {

            }
        }
        #endregion

        #region GetAllComCodes
        /// <summary>
        /// This function will be fetching all the records from com_Code table
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public List<CodesDTO> GetAllComCodes(string sConnectionString)
        {
            List<CodesDTO> res = null;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters
            try
            {
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<CodesDTO>("exec st_com_MassUploadGetAllComCodes @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<CodesDTO>();
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetAllComCodes

        #region GetAllCompanyNames
        /// <summary>
        /// This function will be fetching all the records from mst_Company table
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public List<CompanyNamesDTO> GetAllCompanyNames(string sConnectionString)
        {
            List<CompanyNamesDTO> res = null;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters
            try
            {
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<CompanyNamesDTO>("exec st_com_MassUploadGetAllCompanies @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<CompanyNamesDTO>();
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetAllCompanyNames

        #region GetAllRoles
        /// <summary>
        /// This function will be fetching all the records from usr_RoleMaster table
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public List<RolesDTO> GetAllRoles(string sConnectionString)
        {
            List<RolesDTO> res = null;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters
            try
            {
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<RolesDTO>("exec st_com_MassUploadGetAllRoles @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<RolesDTO>();
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetAllRoles

        #region Add Update Log Entry
        /// <summary>
        /// This function will used for adding a log entry for the mass upload performed.
        /// </summary>
        /// <param name="i_nDataTableId"></param>
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public void AddUpdateLogEntry(string sConnectionString, int i_nMassUploadLogId, int i_nMassUploadTypeId,int i_nStatusCodeId,int? i_nUploadedDocumentId, string i_sErrorReportFileName, string i_sErrorMessage, 
            int i_nLoginUserId, out int o_nSavedMassUploadLogId)
        {
            string sErrCode = string.Empty;
            int res;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters
            try
            {
                var nSavedMassUploadLogId = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nSavedMassUploadLogId.Direction = System.Data.ParameterDirection.Output;

                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<int>("exec st_com_MassUploadManageMassUploadLogEntry @inp_iMassUploadLogId, @inp_iMassUploadTypeId,@inp_iStatusCodeId,@inp_iUploadedDocumentId, @inp_sErrorReportFileName, @inp_sErrorMessage,@inp_iLoginUserId ,@inp_iNewCreatedMassUploadLogId OUTPUT, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_iMassUploadLogId = i_nMassUploadLogId,
                                inp_iMassUploadTypeId = i_nMassUploadTypeId,
                                inp_iStatusCodeId = i_nStatusCodeId,
                                inp_iUploadedDocumentId = i_nUploadedDocumentId,
                                inp_sErrorReportFileName = i_sErrorReportFileName,
                                inp_sErrorMessage = i_sErrorMessage,
                                inp_iLoginUserId = i_nLoginUserId,
                                inp_iNewCreatedMassUploadLogId = nSavedMassUploadLogId,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).Single<int>();
                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            o_nSavedMassUploadLogId = Convert.ToInt32(nSavedMassUploadLogId.Value);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
        }
        #endregion  Add Update Log Entry

        #region GetAllMassUploads
        /// <summary>
        ///  This function will return all the MassUploads
        /// </summary>
        /// <param name="sConnectionString">Database connection string</param>
        /// <returns>MassUploadDTO</returns>
        public IEnumerable<MassUploadDTO> GetAllMassUploads(string sConnectionString)
        {
            List<MassUploadDTO> res = null;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters
            try
            {

                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<MassUploadDTO>("exec st_com_MassUploadGetAllMassUploads @inp_nMassUploadId, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_nMassUploadId = 0,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<MassUploadDTO>();
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetAllMassUploads

        #region GetSingleMassUploadsDetails
        /// <summary>
        ///  This function will return the Mass Upload Excel for given MassUploadId
        /// </summary>
        /// <param name="sConnectionString">Database connection string</param>
        /// <returns>MassUploadDTO</returns>
        public MassUploadDTO GetSingleMassUploadsDetails(string sConnectionString, int i_nMassUploadId)
        {
            List<MassUploadDTO> res = null;
            MassUploadDTO objReturnDTO = null;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters
            try
            {

                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<MassUploadDTO>("exec st_com_MassUploadGetAllMassUploads @inp_nMassUploadId, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_nMassUploadId = i_nMassUploadId,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<MassUploadDTO>();
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }
                    else
                    {
                        if (res != null && res.Count > 0)
                        {
                            objReturnDTO = res[0];
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return objReturnDTO;
        }
        #endregion GetSingleMassUploadsDetails
		
		#region GetRnTMassuploadDayCount
        /// <summary>
        /// This function will be used for getting current date massupload count
        /// </summary>       
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public int GetRnTMassuploadDayCount(string sConnectionString)
        {
            List<MassUploadDTO> res = null;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int sReturnCount = 0;
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
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";
                var sMassUploadCount = new SqlParameter("@out_sDatatableName", System.Data.SqlDbType.Int);
                sMassUploadCount.Direction = System.Data.ParameterDirection.Output;
                sMassUploadCount.Value = 0;

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<MassUploadDTO>("exec st_rnt_RnTMassUploadCount @out_sMassUploadCount OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            out_sMassUploadCount = sMassUploadCount,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<MassUploadDTO>();
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }

                }
                sReturnCount = Convert.ToInt32(sMassUploadCount.Value);
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return sReturnCount;
        }
        #endregion GetDataTableName

        #region GenerateHashCodesForUsers
        public void GenerateHashCodesForUsers(string i_sConnectionString, DataTable i_objHashDataTable)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters
            try
            {
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                var inp_tblEmployeeHashCodeObj = new SqlParameter();
                inp_tblEmployeeHashCodeObj.DbType = DbType.Object;
                inp_tblEmployeeHashCodeObj.ParameterName = "@inp_tblEmployeeHashCode";
                inp_tblEmployeeHashCodeObj.TypeName = "dbo.EmployeeHashCode";
                inp_tblEmployeeHashCodeObj.SqlDbType = SqlDbType.Structured;
                inp_tblEmployeeHashCodeObj.SqlValue = i_objHashDataTable;

                using (var db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    var res = db.Query<int>("exec st_usr_CreateHashCodesForUsers @inp_tblEmployeeHashCode, @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            inp_tblEmployeeHashCode = inp_tblEmployeeHashCodeObj,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<int>();
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        //Exception ex = new Exception(db.LastSQL.ToString(), e);
                        //throw ex;
                    }

                }
            }
            catch (Exception exp)
            {
                string message = exp.Message;
            }
        }
        #endregion GenerateHashCodesForUsers

        #region GetMassCounter
        /// <summary>
        /// This function will be used for getting massupload counter value for Dept wise RL Mass-Upload
        /// </summary>       
        /// <param name="sConnectionString"></param>
        /// <returns></returns>
        public int GetMassCounter(string sConnectionString)
        {
            List<MassUploadDTO> res = null;
            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            int sReturnCount = 0;
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
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";
                var sMassUploadCount = new SqlParameter("@out_sDatatableName", System.Data.SqlDbType.Int);
                sMassUploadCount.Direction = System.Data.ParameterDirection.Output;
                sMassUploadCount.Value = 0;

                using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<MassUploadDTO>("exec st_rl_Get_MassCounter @out_MassCounter OUTPUT,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                        new
                        {
                            out_MassCounter = sMassUploadCount,
                            out_nReturnValue = nReturnValue,
                            out_nSQLErrCode = nSQLErrCode,
                            out_sSQLErrMessage = sSQLErrMessage

                        }).ToList<MassUploadDTO>();
                    if (Convert.ToInt32(nReturnValue.Value) != 0)
                    {
                        Exception e = new Exception();
                        out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                        string sReturnValue = sLookupPrefix + out_nReturnValue;
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
                        Exception ex = new Exception(db.LastSQL.ToString(), e);
                        throw ex;
                    }

                }
                sReturnCount = Convert.ToInt32(sMassUploadCount.Value);
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return sReturnCount;
        }
        #endregion GetDataTableName

        #region GetAllRelativePAN
        /// <summary>
        /// This function will be fetching all the records of PAN of all relatives
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="sUserInfoId"></param>
        /// <returns></returns>
        public List<string> GetAllRelativePAN(string sConnectionString, int sUserInfoId)
        {
            List<string> res = null;
            using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
            {
                res = db.Query<string>("exec st_usr_RelativesPANList @UserInfoId",
                    new
                    {
                        UserInfoId = sUserInfoId
                    }).ToList<string>();
            }
            return res;
        }
        #endregion

        #region GetAllRelativeLoginId
        /// <summary>
        /// This function will be fetching all the records of Login Id's of all relatives
        /// </summary>
        /// <param name="sConnectionString"></param>
        /// <param name="sUserInfoId"></param>
        /// <returns></returns>
        public List<string> GetAllRelativeLoginId(string sConnectionString, int sUserInfoId)
        {
            List<string> res = null;
            using (var db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
            {
                res = db.Query<string>("exec st_usr_RelativesLoginIDList @UserInfoId",
                    new
                    {
                        UserInfoId = sUserInfoId
                    }).ToList<string>();
            }
            return res;
        }
        #endregion

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
