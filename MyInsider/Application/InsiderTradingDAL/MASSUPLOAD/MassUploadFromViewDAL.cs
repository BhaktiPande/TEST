using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public abstract class MassUploadFromViewDAL<T> : IMassUploadFromViewDAL<T>
    {


        #region FetchFromViewDAL
        /// <summary>
        /// This generic method is used for the fetching all data from view into the given DTO.
        /// </summary>
        /// <param name="sConnectionString">DB Connection string</param>
        /// <param name="i_sViewName">View Name</param>
        /// <returns>List Of Generic DTO list</returns>
        public IEnumerable<T> FetchFromViewDAL(string i_sConnectionString, string i_sViewname)
        {
            List<T> res = null;
            try
            {
                using (var db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    res = db.Query<T>("Select * from " + i_sViewname).ToList<T>();
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion FetchFromViewDAL

    }
}
