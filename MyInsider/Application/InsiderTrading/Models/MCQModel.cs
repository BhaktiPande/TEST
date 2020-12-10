using InsiderTrading.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InsiderTrading.Models
{
    public class MCQModel //: MCQQuestionModel
    {
        [DefaultValue(0)]
        public int UserInfoID;
        public int MCQS_ID;
        public string Flag;
        [ActivityResourceKey("usr_lbl_54072")]
        [ResourceKey("usr_lbl_54072")]
        [DisplayName("usr_lbl_54072")]
        public bool FirstTimeLogin { get; set; }

        [ActivityResourceKey("usr_btn_54075")]
        [ResourceKey("usr_btn_54075")]
        [DisplayName("usr_btn_54075")]
        public bool IsSpecificPeriodWise { get; set; }

        //[ActivityResourceKey("usr_lbl_54074")]
        //[ResourceKey("usr_lbl_54074")]
        [DisplayName("usr_lbl_54074")]
        public int? FrequencyOfMCQ { get; set; }

        [ActivityResourceKey("usr_btn_54076")]
        [ResourceKey("usr_btn_54076")]
        [DisplayName("usr_btn_54076")]
        
        public bool IsDatewise { get; set; }



        [ActivityResourceKey("usr_btn_54076")]
        [ResourceKey("usr_btn_54076")]
        public DateTime? FrequencyDate { get; set; }

        [ActivityResourceKey("usr_lbl_54077")]
        [ResourceKey("usr_lbl_54077")]
        [DisplayName("usr_lbl_54077")]
        [RegularExpression(ConstEnum.DataValidation.NumbersOnly, ErrorMessage = "usr_msg_54144")]
        [Required]
        public int? FrequencyDuration { get; set; }

        [ActivityResourceKey("usr_lbl_54079")]
        [ResourceKey("usr_lbl_54079")]
        [DisplayName("usr_lbl_54079")]
        public bool BlockUserAfterDuration { get; set; }


        [ActivityResourceKey("usr_lbl_54080")]
        [ResourceKey("usr_lbl_54080")]
        [DisplayName("usr_lbl_54080")]
        public int NoOfQuestionForDisplay { get; set; }

        [ActivityResourceKey("usr_lbl_54081")]
        [ResourceKey("usr_lbl_54081")]
        [DisplayName("usr_lbl_54081")]
        [Required]
        public string AccessTOApplicationForWriteAnswer { get; set; }

        [ActivityResourceKey("usr_lbl_54083")]
        [ResourceKey("usr_lbl_54083")]
        [DisplayName("usr_lbl_54083")]
        public int NoOfAttempts { get; set; }

        [ActivityResourceKey("usr_lbl_54084")]
        [ResourceKey("usr_lbl_54084")]
        [DisplayName("usr_lbl_54084")]
        public bool BlockuserAfterExceedAtempts { get; set; }

        [ActivityResourceKey("usr_lbl_54085")]
        [ResourceKey("usr_lbl_54085")]
        [DisplayName("usr_lbl_54085")]
        public bool UnblockForNextFrequency { get; set; }


        [ActivityResourceKey("usr_lbl_54096")]
        [ResourceKey("usr_lbl_54096")]
        [DisplayName("usr_lbl_54096")]
        public string Question { get; set; }

        [ActivityResourceKey("usr_lbl_54097")]
        [ResourceKey("usr_lbl_54097")]
        [DisplayName("usr_lbl_54097")]
        public string Answer_Type { get; set; }

        [ActivityResourceKey("usr_lbl_54098")]
        [ResourceKey("usr_lbl_54098")]
        [DisplayName("usr_lbl_54098")]
        public int Option_number { get; set; }
        public string QuestionsAnswer { get; set; }
        public int QuestionID { get; set; }
        public List<string> objQuestionsAnswerList { get; set; }
        public List<string> objCorrectAnswerList { get; set; }
        public List<int> objQuestionBankDetailsIDList { get; set; }
       
        public List<MCQQuestionModel> objMCQQuestionModelAnswerList { get; set; }
        public List<MCQModel> objMCQModelList { get; set; }

        public MCQQuestionModel objMCQQuestionModel { get; set; }
        public MCQUserValidationModel objMCQUserValidationModel { get; set; }

    }
    public class MCQQuestionModel
    {
        public int QuestionID { get; set; }
        public int OptionNo { get; set; }
        public int QuestionBankDetailsID { get; set; }
        public string QuestionsAnswer { get; set; }
        public string CorrectAnswer { get; set; }
        public bool IsCheked { get; set; }
    }
    public class MCQUserValidationModel
    {
        public string FrequencyOfMCQs { get; set; }
        public int AttemptNos { get; set; }
        public int FalseAnswer { get; set; }
        public int CorrectAnswer { get; set; }
        public string ResultDuringFrequency { get; set; }
        public string UserMessage { get; set; }
        public string AttemptMessage { get; set; }
        public int TotalAttempts { get; set; }
        public string BlockedUserMessage { get; set; }
        public bool IsBlocked  { get; set; }
    }

    public class MCQReportModel
    {

        [ActivityResourceKey("usr_lbl_54125")]
        [ResourceKey("usr_lbl_54125")]
        [DisplayName("usr_lbl_54125")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string  EmployeeId { get; set; }
       
        public int UserInfoId { get; set; }

        [ActivityResourceKey("usr_lbl_54126")]
        [ResourceKey("usr_lbl_54126")]
        [DisplayName("usr_lbl_54126")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Name { get; set; }

        [ActivityResourceKey("usr_lbl_54127")]
        [ResourceKey("usr_lbl_54127")]
        [DisplayName("usr_lbl_54127")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Department { get; set; }

        [ActivityResourceKey("usr_lbl_54128")]
        [ResourceKey("usr_lbl_54128")]
        [DisplayName("usr_lbl_54128")]
        [RegularExpression(ConstEnum.DataValidation.SearchValidation, ErrorMessage = "rpt_msg_50521")]
        public string Designation { get; set; }

        [ActivityResourceKey("usr_lbl_54129")]
        [ResourceKey("usr_lbl_54129")]
        [DisplayName("usr_lbl_54129")]
        public string MCQ_Status { get; set; }

        [ActivityResourceKey("usr_lbl_54130")]
        [ResourceKey("usr_lbl_54130")]
        [DisplayName("usr_lbl_54130")]
        [Required]
        public DateTime ? From_Date { get; set; }

        [ActivityResourceKey("usr_lbl_54131")]
        [ResourceKey("usr_lbl_54131")]
        [DisplayName("usr_lbl_54131")]
        [Required]
        public DateTime ? To_Date { get; set; }

    }
}