using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL 
{
    public class MCQ_REPORT_DTO
    {
        public string EmployeeId { get; set; }
        public int UserInfoId { get; set; }
        public string Name { get; set; }
        public string Department { get; set; }
        public string Designation { get; set; }
        public string MCQ_Status { get; set; }
        public DateTime? From_Date { get; set; }
        public DateTime? To_Date { get; set; }
        public string PAN_Number { get; set; }	
        public DateTime? ActivationPeriod { get; set; }	 	 
        public string FrequencyOfMCQ { get; set; }	 	
        public DateTime? LastDateOfMCQ { get; set; }	
        public int AttemptNo	 { get; set; }	 
        public DateTime? LoginDateAndTime  { get; set; }	  
        public string AccountBlocked { get; set; }	 	
        public DateTime? Dateofblocking	{ get; set; }	
        public string  Reasonforblocking	{ get; set; }
        public DateTime? Unblockdates { get; set; }
        public string UnblockReason { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string Action { get; set; }
        public int DepartmentID { get; set; }
        public int DesignationID { get; set; }
        public string MCQ_ExamDate { get; set; }

    }
}
