using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace InsiderTrading.Common
{
    class ResourceKeyAttribute : Attribute
    {
        public string Key { get; set; }

        public ResourceKeyAttribute(string key)
        {
            Key = key;
        }
    }

    class ActivityResourceKeyAttribute : Attribute
    {
        public string Key { get; set; }

        public ActivityResourceKeyAttribute(string key)
        {
            Key = key;
        }
    }
}
