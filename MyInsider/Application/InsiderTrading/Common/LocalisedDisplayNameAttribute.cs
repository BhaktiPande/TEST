using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Web;

namespace InsiderTrading.Common
{

    //public class LocalizedDisplayNameAttribute : DisplayNameAttribute
    //{
    //    private readonly PropertyInfo nameProperty;
    //    private readonly Type resourceTypeProp;
    //    private readonly string resourceIdProp;

    //    public LocalizedDisplayNameAttribute(string resourceId, Type resourceType = null)
    //        : base(resourceId)
    //    {
    //        resourceTypeProp = resourceType;
    //        resourceIdProp = resourceId;
    //        //if (resourceType == null)
    //        //{
    //        //    nameProperty = Common.getResource(resourceId);//resourceType.GetProperty(base.DisplayName,
    //        //                    //               BindingFlags.Static | BindingFlags.Public);
    //        //}
    //    }

    //    public override string DisplayName
    //    {
    //        get
    //        {
    //            if (resourceTypeProp == null)
    //            {
    //                return Common.getResource(resourceIdProp);
    //            }
    //            return base.DisplayName;
    //        }
    //    }
    //}


    public class LocalizedDisplayNameAttribute : DisplayNameAttribute
    {
        public LocalizedDisplayNameAttribute(string resourceId)
            : base(GetMessageFromResource(resourceId))
        { }

        private static string GetMessageFromResource(string resourceId)
        {
            return Common.getResource(resourceId);
        }
    }
}