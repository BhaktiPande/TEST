using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class EmployeeModel
    {

        public UserInfoModel userInfoModel { get; set; }
        public DMATDetailsModel dmatDetailsModel { get; set; }
        public DocumentDetailsModel documentDetailsModel { get; set; }
        public MobileDetails MobileDetails { get; set; }
		public EducationDetailModel userEducationModel { get; set; }
    }

    public class EmployeeRelativeModel
    {
        public RelativeInfoModel userInfoModel { get; set; }
        public Relative_DMATDetailsModel dmatDetailsModel { get; set; }  
        public RelativeMobileDetail RelativeMobileDetails { get; set; }
        public DocumentDetailsModel documentDetailsModel { get; set; }
    }
   
}