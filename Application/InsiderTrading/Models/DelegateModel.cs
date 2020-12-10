
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsiderTrading.Common;

namespace InsiderTrading.Models
{
    public class DelegateModel : IValidatableObject
    {
        public int? DelegationId { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "Select From user")]
        [Display(Name = "From user")]
        public int? UserInfoIdFrom { get; set; }

        [Required]
        [DataType(DataType.Text)]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "Select To user")]
        [Display(Name = "To user")]
        public int? UserInfoIdTo { get; set; }

        [Required]
        [DataType(DataType.DateTime)]
        [Display(Name = "From date")]
        public DateTime? DelegationFrom { get; set; }

        [Required]
        [DataType(DataType.DateTime)]
        [Display(Name = "To date")]
        public DateTime? DelegationTo { get; set; }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            List<ValidationResult> res = new List<ValidationResult>();
            //if (Convert.ToString(DelegationFrom) == "")
            //    res.Add(new ValidationResult("The From Date field is required.", new[] { "DelegationFrom" }));
            //if (Convert.ToString(DelegationTo) == "")
            //    res.Add(new ValidationResult("The To Date field is required.", new[] { "DelegationTo" }));
            //if (Convert.ToString(DelegationFrom) != "" && DelegationFrom > DelegationTo)
            //{
            //    res.Add(new ValidationResult("To Date must be greater than FromDate", new[] { "DelegationTo" }));
            //}
            //if (UserInfoIdTo == 0)
            //    res.Add(new ValidationResult("The To User field is required.", new[] { "UserInfoIdTo" }));
            //if (UserInfoIdFrom == 0)
            //    res.Add(new ValidationResult("The From User field is required.", new[] { "UserInfoIdFrom" }));
            //if (UserInfoIdTo != 0 && UserInfoIdTo == UserInfoIdFrom)
            //    res.Add(new ValidationResult("Cannot delegate to same user", new[] { "UserInfoIdTo" }));

            return res;
        }
    }
}
