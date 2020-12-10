
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using System.ComponentModel.DataAnnotations;

namespace InsiderTrading
{
    [PetaPoco.TableName("rul_TradingWindowEvent")]
    public class TradingWindowEventDTO
    {
        [PetaPoco.Column("TradingWindowEventId")]
        public int? TradingWindowEventId { get; set; }

        [PetaPoco.Column("FinancialYearCodeId")]
        public int? FinancialYearCodeId { get; set; }

        [PetaPoco.Column("FinancialPeriodCodeId")]
        public int? FinancialPeriodCodeId { get; set; }

        [PetaPoco.Column("TradingWindowId")]
        public string TradingWindowId { get; set; }

        [PetaPoco.Column("EventTypeCodeId")]
        public int? EventTypeCodeId { get; set; }

        [PetaPoco.Column("TradingWindowEventCodeId")]
        public int? TradingWindowEventCodeId { get; set; }

        [PetaPoco.Column("ResultDeclarationDate")]
        public DateTime? ResultDeclarationDate { get; set; }

        [PetaPoco.Column("WindowCloseDate")]
        public DateTime? WindowCloseDate { get; set; }

        [PetaPoco.Column("WindowOpenDate")]
        public DateTime? WindowOpenDate { get; set; }

        [PetaPoco.Column("DaysPriorToResultDeclaration")]
        public int? DaysPriorToResultDeclaration { get; set; }

        [PetaPoco.Column("DaysPostResultDeclaration")]
        public int? DaysPostResultDeclaration { get; set; }

        [PetaPoco.Column("WindowClosesBeforeHours")]
        public int? WindowClosesBeforeHours { get; set; }

        [PetaPoco.Column("WindowClosesBeforeMinutes")]
        public int? WindowClosesBeforeMinutes { get; set; }

        [PetaPoco.Column("WindowOpensAfterHours")]
        public int? WindowOpensAfterHours { get; set; }

        [PetaPoco.Column("WindowOpensAfterMinutes")]
        public int? WindowOpensAfterMinutes { get; set; }

        [PetaPoco.Column("TradingWindowStatusCodeId")]
        public int? TradingWindowStatusCodeId { get; set; }

        [PetaPoco.Column("ISEditWindow")]
        public int? ISEditWindow { get; set; }

        [PetaPoco.Column("ISEditWindowOpenPart")]
        public int? ISEditWindowOpenPart { get; set; }


    }

    public class WeekForMonthDTO
    {
        [PetaPoco.Column("Week1")]
        public List<DayDTO> Week1 { get; set; } //days for week1

        [PetaPoco.Column("Week2")]
        public List<DayDTO> Week2 { get; set; } //days for week2

        [PetaPoco.Column("Week3")]
        public List<DayDTO> Week3 { get; set; } //days for week3

        [PetaPoco.Column("Week4")]
        public List<DayDTO> Week4 { get; set; } //days for week4

        [PetaPoco.Column("Week5")]
        public List<DayDTO> Week5 { get; set; } //days for week5

        [PetaPoco.Column("Week6")]
        public List<DayDTO> Week6 { get; set; } //days for week6

        [PetaPoco.Column("nextMonth")]
        public string nextMonth { get; set; }

        [PetaPoco.Column("prevMonth")]
        public string prevMonth { get; set; }

        [PetaPoco.Column("Month")]
        public string Month { get; set; }

        [PetaPoco.Column("Year")]
        public int? Year { get; set; }

    }

    public class DayDTO
    {
         [PetaPoco.Column("Date")]
        public DateTime Date { get; set; }

         [PetaPoco.Column("_Date")]
        public string _Date { get; set; }

         [PetaPoco.Column("dateStr")]
        public string dateStr { get; set; }

         [PetaPoco.Column("dtDay")]
        public int dtDay { get; set; }

         [PetaPoco.Column("daycolumn")]
        public int? daycolumn { get; set; }

         [PetaPoco.Column("IsBlocked")]
        public int IsBlocked { get; set; }

        [PetaPoco.Column("DayCount")]
         public int DayCount { get; set; }

         [PetaPoco.Column("TradingWindowEventId")]
         public int? TradingWindowEventId { get; set; }       

    }

    public class EventDTO
    {
        [PetaPoco.Column("EventName")]
        public string EventName { get; set; }

        [PetaPoco.Column("EventDescription")]
        public string EventDescription { get; set; }

        [PetaPoco.Column("WindowCloseDate")]
        public DateTime? WindowCloseDate { get; set; }

        [PetaPoco.Column("WindowOpenDate")]
        public DateTime? WindowOpenDate { get; set; }
    }

    public class BlockedEventDTO
    {
        [PetaPoco.Column("WindowCloseDate")]
        public DateTime? WindowCloseDate { get; set; }

        [PetaPoco.Column("WindowOpenDate")]
        public DateTime? WindowOpenDate { get; set; }
    }
}
