using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Common
{
    public class RegularExpressionWithOptionsAttribute : RegularExpressionAttribute, IClientValidatable
    {
        public RegularExpressionWithOptionsAttribute(string pattern) : base(pattern) { }

        public RegexOptions RegexOptions { get; set; }

        public override bool IsValid(object value)
        {
            if (string.IsNullOrEmpty(value as string))
                return true;

            return Regex.IsMatch(value as string, Pattern, RegexOptions);
        }

        public IEnumerable<System.Web.Mvc.ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            var rule = new ModelClientValidationRule
            {
                ErrorMessage = FormatErrorMessage(metadata.DisplayName),
                ValidationType = "regexwithoptions"
            };

            rule.ValidationParameters["pattern"] = Pattern;
            string flags = "";
            if ((RegexOptions & RegexOptions.Multiline) == RegexOptions.Multiline)
                flags += "m";
            if ((RegexOptions & RegexOptions.IgnoreCase) == RegexOptions.IgnoreCase)
                flags += "i";
            rule.ValidationParameters["flags"] = flags;

            yield return rule;
        }

    }



}
