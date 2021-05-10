using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL 
{
   public class EmailPropertiesDAL : IDisposable
    {
        const String sLookupPrefix = "usr_msg_";
        public IEnumerable<EmailPropertiesDTO> GetEmailPropertiesDetailsForMail(string i_sConnectionString, EmailPropertiesDTO i_objEmailPropertiesDTO)
        {
            #region Paramters
            List<EmailPropertiesDTO> lstEmailProperties = null;
            string sErrCode = string.Empty;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            
            PetaPoco.Database db = null;
            #endregion Paramters

            try
            {

                #region Output Param
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                var inp_s_McqActivationDate = new SqlParameter("@inp_s_McqActivationDate", System.Data.SqlDbType.VarChar);
                inp_s_McqActivationDate.Value =DBNull.Value ;
                inp_s_McqActivationDate.Size = 15;
                
                var inp_s_LastDateOfSubmission = new SqlParameter("@inp_s_LastDateOfSubmission", System.Data.SqlDbType.VarChar);
                inp_s_LastDateOfSubmission.Value = DBNull.Value;
                inp_s_LastDateOfSubmission.Size = 15;

                #endregion Output Param

                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        lstEmailProperties = db.Query<EmailPropertiesDTO>("exec st_usr_EmailDetails @inp_s_Module,@inp_s_Flag,@inp_s_TemplateCode,@inp_s_UniqueID," +
                            "@inp_s_McqActivationDate,@inp_s_LastDateOfSubmission,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_s_Module = i_objEmailPropertiesDTO.Module,
                                inp_s_Flag = i_objEmailPropertiesDTO.Flag,
                                inp_s_TemplateCode = i_objEmailPropertiesDTO.TemplateCode,
                                inp_s_UniqueID= i_objEmailPropertiesDTO.UniqueID,
                                inp_s_McqActivationDate = inp_s_McqActivationDate,
                                inp_s_LastDateOfSubmission = inp_s_LastDateOfSubmission,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage
                            }).ToList();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Return Error Code
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
                            #endregion Return Error Code
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
                throw exp;
            }
            return lstEmailProperties;
        }
        //public IEnumerable<PlaceHolderDTO> GetPlaceHolderForMail(string i_sConnectionString, PlaceHolderDTO PlaceHolderDTO)
        //{
        //    #region Paramters
        //    List<PlaceHolderDTO> lstPlaceHolderDTO = null;
        //    string sErrCode = string.Empty;
        //    int out_nReturnValue;
        //    int out_nSQLErrCode;
        //    string out_sSQLErrMessage;
        //    PetaPoco.Database db = null;
        //    #endregion Paramters

        //    try
        //    {

        //        #region Output Param
        //        var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
        //        nReturnValue.Direction = System.Data.ParameterDirection.Output;
        //        //  nReturnValue.Value = 0;
        //        var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
        //        nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
        //        nSQLErrCode.Value = 0;
        //        var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
        //        sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
        //        sSQLErrMessage.Value = "";
        //        sSQLErrMessage.Size = 500;
        //        #endregion Output Param

        //        //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

        //        using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
        //        {
        //            using (var scope = db.GetTransaction())
        //            {
        //                lstPlaceHolderDTO = db.Query<PlaceHolderDTO>("exec st_usr_EmailPlaceHolder @out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
        //                    new
        //                    {
                               
        //                        out_nReturnValue = nReturnValue,
        //                        out_nSQLErrCode = nSQLErrCode,
        //                        out_sSQLErrMessage = sSQLErrMessage

        //                    }).ToList();

        //                if (Convert.ToInt32(nReturnValue.Value) != 0)
        //                {
        //                    #region Return Error Code
        //                    Exception e = new Exception();
        //                    out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
        //                    string sReturnValue = sLookupPrefix + out_nReturnValue;
        //                    e.Data[0] = sReturnValue;
        //                    if (nSQLErrCode.Value != System.DBNull.Value)
        //                    {
        //                        out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
        //                        e.Data[1] = out_nSQLErrCode;
        //                    }
        //                    if (sSQLErrMessage.Value != System.DBNull.Value)
        //                    {
        //                        out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
        //                        e.Data[2] = out_sSQLErrMessage;
        //                    }
        //                    Exception ex = new Exception(db.LastSQL.ToString(), e);
        //                    throw ex;
        //                    #endregion Return Error Code
        //                }
        //                else
        //                {
        //                    scope.Complete();
        //                }
        //            }
        //        }

        //    }
        //    catch (Exception exp)
        //    {
        //        throw exp;
        //    }
        //    return lstPlaceHolderDTO;
        //}
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
