using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTrading_NotificationService.Interface
{
    public interface IBroadcast
    {
        bool Broadcast();

        #region Properties
        String SubjectLine
        {
            get;
            set;
        }

        String Body
        {
            get;
            set;
        }

        List<string> Recipients
        {
            get;        
        }
        WindowServiceConstEnum.Code BroadcastResponseCode
        {
            get;
        }
        String BroadcastResponseMessage
        {
            get;
        }
        #endregion Properties
    }
 
}
