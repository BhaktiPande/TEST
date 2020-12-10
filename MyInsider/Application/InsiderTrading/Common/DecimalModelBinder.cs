using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Common
{

  //  public class DecimalModelBinder : DefaultModelBinder
 //   {
        //public override object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        //{
        //    var valueProvider = bindingContext.ValueProvider.GetValue(bindingContext.ModelName);

        //    object result = null;
        //    try
        //    {
        //        if (!string.IsNullOrEmpty(valueProvider.AttemptedValue))
        //            result = decimal.Parse(valueProvider.AttemptedValue);
        //    }
        //    catch (FormatException e)
        //    {
        //        bindingContext.ModelState.AddModelError(bindingContext.ModelName, e);
        //    }

        //    return result;
        //}
    //}

    public class DecimalModelBinder : IModelBinder
    {
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
          /*  if (bindingContext.ModelType == typeof(decimal) || bindingContext.ModelType == typeof(Nullable<decimal>))
            {
                var valueProviderResult = bindingContext.ValueProvider.GetValue(bindingContext.ModelName);
                if (valueProviderResult != null)
                {
                    decimal result;
                    var array = valueProviderResult.RawValue as Array;
                    string value;
                    if (array != null && array.Length > 0)
                    {
                        value = array.GetValue(0).ToString().Replace(",", ""); ;
                        if (decimal.TryParse(value.ToString(), out result))
                        {
                            string val = result.ToString(CultureInfo.InvariantCulture.NumberFormat);
                            array.SetValue(val, 0);
                        }
                    }
                }
            }
            else*/
            if (bindingContext.ModelType == typeof(int) || bindingContext.ModelType == typeof(Nullable<int>))
            {
                var integerValue = bindingContext.ValueProvider.GetValue(bindingContext.ModelName);
                if (integerValue == null || integerValue.AttemptedValue == "")
                    return null;
                string actualValue = null;
                var modelState = new ModelState { Value = integerValue };
                var array = integerValue.RawValue as Array;
                if (array == null)
                {   array=new string[12];
                    if (integerValue.RawValue != null)
                    {
                        array.SetValue(integerValue.RawValue.ToString(), 0);
                    }
                }
                if (array != null && array.Length > 0)
                {
                    actualValue = array.GetValue(0).ToString().Replace(",", "");
                   
                }
                array.SetValue(actualValue.ToString(), 0);
                bindingContext.ModelState.SetModelValue(bindingContext.ModelName, bindingContext.ValueProvider.GetValue(bindingContext.ModelName));
                try
                {
                    return int.Parse(actualValue.ToString());
                }
                catch (Exception)
                {
                    bindingContext.ModelState.AddModelError(bindingContext.ModelName, String.Format("\"{0}\" is invalid, please provide a valid number.", bindingContext.ModelName));
                    return null;
                }
            }
            else if (bindingContext.ModelType == typeof(long) || bindingContext.ModelType == typeof(Nullable<long>))
            {
                var integerValue = bindingContext.ValueProvider.GetValue(bindingContext.ModelName);
                if (integerValue == null || integerValue.AttemptedValue == "")
                    return null;
                string actualValue = null;
                var modelState = new ModelState { Value = integerValue };
                var array = integerValue.RawValue as Array;
                if (array == null)
                {
                    array = new string[12];
                    if (integerValue.RawValue != null)
                    {
                        array.SetValue(integerValue.RawValue.ToString(), 0);
                    }
                }
                if (array != null && array.Length > 0)
                {
                    actualValue = array.GetValue(0).ToString().Replace(",", "");
                }
                array.SetValue(actualValue.ToString(), 0);
                bindingContext.ModelState.SetModelValue(bindingContext.ModelName, bindingContext.ValueProvider.GetValue(bindingContext.ModelName));
                try
                {
                    return long.Parse(actualValue.ToString());
                }
                catch (Exception)
                {
                    bindingContext.ModelState.AddModelError(bindingContext.ModelName, String.Format("\"{0}\" is invalid, please provide a valid number.", bindingContext.ModelName));
                    return null;
                }
            }
            else
            {
                return null;
            }
            //var res = base.BindModel(controllerContext, bindingContext);
           
        }
    }
}