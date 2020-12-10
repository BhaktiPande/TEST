using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public interface IMassUploadFromViewDAL<T>
    {   

        IEnumerable<T> FetchFromViewDAL(string sConnectionString, string i_sViewName);
    }
}
