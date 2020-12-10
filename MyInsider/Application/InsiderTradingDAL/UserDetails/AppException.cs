using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Security.Permissions;
using System.Text;

namespace InsiderTradingDAL.UserDetails
{
     [Serializable]
    public class AppException:ApplicationException
    {
        // private readonly string sMessage;
        // private readonly string sErrorCode;   

        // public AppException()
        // {

        // }
        //     public AppException(string message)   
        //: base(message)   
        //{   
        //}   
        //public AppException(String sMessage, Exception inner)
        //     : base(sMessage, inner)
        // {
        //}

        //public AppException(String sMessage, string sErrorCode)
        //{
        //    this.sMessage = sMessage;
        //    this.sErrorCode = sErrorCode;
        //}

        //[SecurityPermissionAttribute(SecurityAction.Demand, SerializationFormatter = true)]
        //// Protected for unsealed classes, private for sealed.   
        //protected AppException(SerializationInfo info, StreamingContext context)
        //    : base(info, context)
        //{
        //     this.sErrorCode = info.GetString("ErrorCode");   
           
   
        //}

        //[SecurityPermissionAttribute(SecurityAction.Demand, SerializationFormatter = true)]
        //public override void GetObjectData(SerializationInfo info, StreamingContext context)
        //{
        //    if (info == null)
        //    {
        //        throw new ArgumentNullException("info");
        //    }

        //    info.AddValue("sErrorCode", this.sErrorCode);

        //    // MUST call through to the base class to let it save its own state   
        //    base.GetObjectData(info, context);
        //}

        //public string ErrorCode
        //{
        //    get { return this.sErrorCode; }
        //}  
    }
}
