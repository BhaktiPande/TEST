using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class ResourcesDAL:IDisposable
    {
        const string sLookUpPrefix = "mst_msg";

        /// <summary>
        /// This function will be used for fetching all the resources from the company database for 
        /// it to be updated in the cache in the application.
        /// </summary>
        /// <param name="i_sConnectionString"></param>
        /// <param name="lstResources"></param>
        public void GetAllResources(string i_sConnectionString, out Dictionary<string, string> lstResources)
        {
            lstResources = new Dictionary<string, string>();
            List<InsiderTradingDAL.ResourcesDTO> lstResourcesDTO = new List<ResourcesDTO>();
            try
            {
                using (var db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    lstResourcesDTO = db.Query<InsiderTradingDAL.ResourcesDTO>("Select * from mst_Resource").ToList<InsiderTradingDAL.ResourcesDTO>();
                }

                foreach (InsiderTradingDAL.ResourcesDTO objResourceObj in lstResourcesDTO)
                {
                    lstResources.Add(objResourceObj.ResourceKey, objResourceObj.ResourceValue);
                }
            }
            catch(Exception exp)
            {
               // throw exp;
            }
        }

        #region GetDetails
        /// <summary>
        /// This method is used for fetching details of resource key.
        /// </summary>
        /// <param name="i_sConnectionString">DB COnnection string</param>
        /// <param name="inp_sResourceKey">Resource Key</param>
        /// <returns>Object of ResourceDTO</returns>
        public ResourcesDTO GetDetails(string i_sConnectionString, string inp_sResourceKey)
        {
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            List<ResourcesDTO> res = null;
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
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<ResourcesDTO>("exec st_mst_ResourceDetails @inp_sResourceKey,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_sResourceKey = inp_sResourceKey,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage
                           }).ToList<ResourcesDTO>();

                        #region Error Values
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
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            return res.FirstOrDefault();
                        }
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion GetDetails

        #region Save
        /// <summary>
        /// This procedure is used for the update the resource key value.
        /// </summary>
        /// <param name="i_sConnectionString">DB Connection string</param>
        /// <param name="m_objResourceDTO">Object of Resource DTO</param>
        /// <returns>If saves return true otherwise false</returns>
        public bool Save(string i_sConnectionString, ResourcesDTO m_objResourceDTO)
        {
            #region Paramters
            bool bReturn = false;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            ResourcesDTO res = null;
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
                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {
                        res = db.Query<ResourcesDTO>("exec st_mst_ResourceSave @inp_sResourceKey,@inp_sResourceValue,@inp_bIsVisible,@inp_nSequenceNumber,@inp_nColumnWidth,@inp_nColumnAlignment,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                           new
                           {
                               inp_sResourceKey = m_objResourceDTO.ResourceKey,
                               inp_sResourceValue = m_objResourceDTO.ResourceValue,
                               inp_bIsVisible = m_objResourceDTO.IsVisible,
                               inp_nSequenceNumber = m_objResourceDTO.SequenceNumber,
                               inp_nColumnWidth = m_objResourceDTO.ColumnWidth,
                               inp_nColumnAlignment = m_objResourceDTO.ColumnAlignment,
                               out_nReturnValue = nReturnValue,
                               out_nSQLErrCode = nSQLErrCode,
                               out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault<ResourcesDTO>();

                        #region Error Values
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
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            bReturn = false;
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            bReturn = true;
                        }
                        #endregion Error Values
                    }
                }
            }
            catch (Exception exp)
            {
           
                throw exp;
            }

            return bReturn;
        }
        #endregion Save

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
