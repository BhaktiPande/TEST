using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Common
{
    public class DecimalModelBinderNew : IModelBinder
    {
        public object BindModel(System.Web.Mvc.ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            var valueResult = bindingContext.ValueProvider.GetValue(bindingContext.ModelName);
            if (string.IsNullOrEmpty(valueResult.AttemptedValue))
            {
                return 0m;
            }
            var modelState = new ModelState { Value = valueResult };
            object actualValue = null;
            try
            {
                var array = valueResult.RawValue as Array;
                actualValue = Convert.ToDecimal(
                    valueResult.AttemptedValue.Replace(",", ""),
                    CultureInfo.InvariantCulture
                );

                array.SetValue(actualValue.ToString(), 0);
            }
            catch (FormatException e)
            {
                modelState.Errors.Add(e);
            }

            bindingContext.ModelState.Add(bindingContext.ModelName, modelState);
            return actualValue;
        }
    }
}