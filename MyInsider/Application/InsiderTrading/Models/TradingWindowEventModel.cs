
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsiderTrading.Common;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace InsiderTrading.Models
{
    public class TradingWindowEventModel
    {
       		[ScaffoldColumn(false)]
		[Required]
        [DisplayName("rul_lbl_15019")]
		public int? TradingWindowEventId { get; set; }

        
		public int? FinancialYearCodeId { get; set; }

     
		public int? FinancialPeriodCodeId { get; set; }

       
        [DisplayName("rul_grd_15009")]
		public string TradingWindowId { get; set; }

	//	[Required]     
		public int? EventTypeCodeId { get; set; }
        
        [Required]
        [RegularExpression("^(([0-9]*[1-9][0-9]*([.][0-9]+)?)|([0]+[.][0-9]*[1-9][0-9]*))$", ErrorMessage = "rul_msg_15425")]
		public int? TradingWindowEventCodeId { get; set; }

        [DisplayName("rul_grd_15010")]
        public string TradingWindowEvent { get; set; }

		[Required]
        [DisplayName("rul_lbl_15020")]
		public DateTime? ResultDeclarationDate { get; set; }

         [DisplayName("rul_lbl_15021")]
        public DateTime? ResultDeclarationTime { get; set; }

        [Required]
        [DisplayName("rul_lbl_15431")]
		public DateTime? WindowCloseDate { get; set; }

        [Required]
        [DisplayName("rul_lbl_15432")]       
		public DateTime? WindowOpenDate { get; set; }

		[Required]
        [Range(0, 999, ErrorMessage = "rul_msg_15435")]
		public int? DaysPriorToResultDeclaration { get; set; }

		[Required]
        [Range(0, 999, ErrorMessage = "rul_msg_15436")]
		public int? DaysPostResultDeclaration { get; set; }

        [DisplayName("WindowsClosesBeforeDays")]
        public int? WindowsClosesBeforeDays { get; set; }

        [DisplayName("WindowClosesBeforeHours")]
		public int? WindowClosesBeforeHours { get; set; }

        [DisplayName("WindowClosesBeforeMinutes")]
		public int? WindowClosesBeforeMinutes { get; set; }

        [DisplayName("WindowsOpenAfterDays")]
        public int? WindowsOpenAfterDays { get; set; }

        [DisplayName("WindowOpensAfterHours")]
		public int? WindowOpensAfterHours { get; set; }

        [DisplayName("WindowOpensAfterMinutes")]
		public int? WindowOpensAfterMinutes { get; set; }

        [DisplayName("rul_lbl_15022")]
        public string Hours { get; set; }

        [DisplayName("rul_lbl_15024")]
        public string Days { get; set; }

        [DisplayName("rul_lbl_15023")]
        public string Minutes { get; set; }

        public int? WindowClosesHours { get; set; }
        public int? WindowClosesMinutes { get; set; }
        public int? WindowOpensHours { get; set; }
        public int? WindowOpensMinutes { get; set; }

        [DisplayName("rul_lbl_15426")]
        public int? TradingWindowStatusCodeId { get; set; }

    }

    public class WeekForMonth
    {
        public List<Day> Week1 { get; set; } //days for week1
        public List<Day> Week2 { get; set; } //days for week2
        public List<Day> Week3 { get; set; } //days for week3
        public List<Day> Week4 { get; set; } //days for week4
        public List<Day> Week5 { get; set; } //days for week5
        public List<Day> Week6 { get; set; } //days for week6
        public string nextMonth { get; set; }
        public string prevMonth { get; set; }
        public string Month { get; set; }
        public int? Year { get; set; }    

    }

    public class Day
    {
        public DateTime Date { get; set; }
        public string _Date { get; set; }
        public string dateStr { get; set; }
        public int dtDay { get; set; }
        public int? daycolumn { get; set; }
        public int IsBlocked { get; set; }     
        public int? TradingWindowEventId { get; set; }
        public string EventName { get; set; }
        public string EventDescription { get; set; }
        public DateTime? WindowCloseDate { get; set; }
        public DateTime? WindowOpenDate { get; set; }
    }
}
