using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public interface IGenericDTO<T>
    {   

        IEnumerable<T> ListALL(string sConnectionString, int inp_iGridType, int inp_iPageSize, int inp_iPageNo,
            string inp_sSortField, string inp_sSortOrder, string inp_sParam1, string inp_sParam2, string inp_sParam3, string inp_sParam4,
            string inp_sParam5, string inp_sParam6, string inp_sParam7, string inp_sParam8, string inp_sParam9,
            string inp_sParam10, string inp_sParam11, string inp_sParam12, string inp_sParam13, string inp_sParam14,
            string inp_sParam15, string inp_sParam16, string inp_sParam17, string inp_sParam18, string inp_sParam19,
            string inp_sParam20, string inp_sParam21, string inp_sParam22, string inp_sParam23, string inp_sParam24,
            string inp_sParam25, string inp_sParam26, string inp_sParam27, string inp_sParam28, string inp_sParam29,
            string inp_sParam30,
            string inp_sParam31, string inp_sParam32, string inp_sParam33, string inp_sParam34,
            string inp_sParam35, string inp_sParam36, string inp_sParam37, string inp_sParam38, string inp_sParam39,
            string inp_sParam40, string inp_sParam41, string inp_sParam42, string inp_sParam43, string inp_sParam44,
            string inp_sParam45, string inp_sParam46, string inp_sParam47, string inp_sParam48, string inp_sParam49,
            string inp_sParam50,
            out int out_iTotalRecords, string sLookupPrefix);
    }
}
