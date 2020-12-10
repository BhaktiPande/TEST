using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace InsiderTrading.Common
{
    public enum DateCompareOperator
    {
        GreaterThan,
        GreaterThanOrEqual,
        LessThan,
        LessThanOrEqual
    }

    public enum DateCompareType
    {
        Date,
        DateTime,
        Integer
    }


   
    public sealed class DateCompareAttribute : ValidationAttribute, IClientValidatable
    {
        private DateCompareOperator operatorname = DateCompareOperator.GreaterThanOrEqual;
        private DateCompareType datecomparetype = DateCompareType.Date;
       // private DateCompareType numbercomparetype = DateCompareType.Integer;

        public string CompareToPropertyName { get; set; }
        public DateCompareOperator OperatorName { get { return operatorname; } set { operatorname = value; } }
        // public IComparable CompareDataType { get; set; }
        public DateCompareType CompareType { get { return datecomparetype; } set { datecomparetype = value; } }
        public string CompareDateFormat { get; set; }

      //  public DateCompareType NumberCompareType { get { return numbercomparetype; } set { numbercomparetype = value; } }

        public DateCompareAttribute() : base() { }
        //Override IsValid
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            string operstring = (OperatorName == DateCompareOperator.GreaterThan ?
            "greater than " : (OperatorName == DateCompareOperator.GreaterThanOrEqual ?
            "greater than or equal to " :
            (OperatorName == DateCompareOperator.LessThan ? "less than " :
            (OperatorName == DateCompareOperator.LessThanOrEqual ? "less than or equal to " : ""))));
            var basePropertyInfo = validationContext.ObjectType.GetProperty(CompareToPropertyName);

            var valOther = (IComparable)basePropertyInfo.GetValue(validationContext.ObjectInstance, null);

            var valThis = (IComparable)value;

            //check date is not null before comparing
            if ((valThis == null && valOther == null) || (valThis != null && valOther == null) || (valThis == null && valOther != null))
                return null;

            if ((operatorname == DateCompareOperator.GreaterThan && valThis.CompareTo(valOther) <= 0) ||
                (operatorname == DateCompareOperator.GreaterThanOrEqual && valThis.CompareTo(valOther) < 0) ||
                (operatorname == DateCompareOperator.LessThan && valThis.CompareTo(valOther) >= 0) ||
                (operatorname == DateCompareOperator.LessThanOrEqual && valThis.CompareTo(valOther) > 0))
                return new ValidationResult(base.ErrorMessage);
            return null;
        }
        #region IClientValidatable Members

        public IEnumerable<ModelClientValidationRule>
        GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            string errorMessage = this.FormatErrorMessage(metadata.DisplayName);
            ModelClientValidationRule compareRule = new ModelClientValidationRule();
            compareRule.ErrorMessage = errorMessage;
            compareRule.ValidationType = "datecompare";
            compareRule.ValidationParameters.Add("comparetopropertyname", CompareToPropertyName);
            compareRule.ValidationParameters.Add("operatorname", OperatorName.ToString());
            compareRule.ValidationParameters.Add("comparetype", CompareType.ToString());
            compareRule.ValidationParameters.Add("comparedateformat", CompareDateFormat.ToString());
            yield return compareRule;
        }

        #endregion
    }

    public enum GenericCompareOperator
    {
        GreaterThan,
        GreaterThanOrEqual,
        LessThan,
        LessThanOrEqual
    }

    public class AnnotationDateCompareFormat
    {
        public const string DDMMYYYY = "DDMMYYYY";
    }

    public sealed class GenericCompareAttribute : ValidationAttribute, IClientValidatable
    {
        private GenericCompareOperator operatorname = GenericCompareOperator.GreaterThanOrEqual;

        public string CompareToPropertyName { get; set; }
        public GenericCompareOperator OperatorName { get { return operatorname; } set { operatorname = value; } }
        // public IComparable CompareDataType { get; set; }

        private DateCompareType numbercomparetype = DateCompareType.Integer;

         public DateCompareType CompareType { get { return numbercomparetype; } set { numbercomparetype = value; } }

        public GenericCompareAttribute() : base() { }
        //Override IsValid
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            string operstring = (OperatorName == GenericCompareOperator.GreaterThan ?
            "greater than " : (OperatorName == GenericCompareOperator.GreaterThanOrEqual ?
            "greater than or equal to " :
            (OperatorName == GenericCompareOperator.LessThan ? "less than " :
            (OperatorName == GenericCompareOperator.LessThanOrEqual ? "less than or equal to " : ""))));
            var basePropertyInfo = validationContext.ObjectType.GetProperty(CompareToPropertyName);

            var valOther = (IComparable)basePropertyInfo.GetValue(validationContext.ObjectInstance, null);

            var valThis = (IComparable)value;
            if (valOther != null)
            {
                if ((operatorname == GenericCompareOperator.GreaterThan && valThis.CompareTo(valOther) <= 0) ||
                    (operatorname == GenericCompareOperator.GreaterThanOrEqual && valThis.CompareTo(valOther) < 0) ||
                    (operatorname == GenericCompareOperator.LessThan && valThis.CompareTo(valOther) >= 0) ||
                    (operatorname == GenericCompareOperator.LessThanOrEqual && valThis.CompareTo(valOther) > 0))
                    return new ValidationResult(base.ErrorMessage);
                return null;
            }
            else
            {
                return null;
            }
        }
        #region IClientValidatable Members

        public IEnumerable<ModelClientValidationRule>
        GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            string errorMessage = this.FormatErrorMessage(metadata.DisplayName);
            ModelClientValidationRule compareRule = new ModelClientValidationRule();
            compareRule.ErrorMessage = errorMessage;
            compareRule.ValidationType = "genericcompare";
            compareRule.ValidationParameters.Add("comparetopropertyname", CompareToPropertyName);
            compareRule.ValidationParameters.Add("operatorname", OperatorName.ToString());
            yield return compareRule;
        }

        #endregion
    }
}