using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
     [PetaPoco.TableName("MCQ_QuestionBank")]
    public class MCQ_QUESTION_DTO
    {
         public int UserinfoID { get; set; }

         [PetaPoco.Column("QuestionID")]
         public int QuestionID { get; set; }

         [PetaPoco.Column("Question")]
         public string Question { get; set; }

         [PetaPoco.Column("AnswerTypes")]
         public int AnswerTypes { get; set; }
         
         [PetaPoco.Column("OptionNumbers")]
         public int OptionNumbers { get; set; }

         public string QuestionAnswer { get; set; }
         public string CorrectAnswer { get; set; }
         public string QuestionAnswerWithID { get; set; }
         public int AttemptNo { get; set; }

         public string FrequencyOfMCQs { get; set; }
         public int FalseAnswer { get; set; }
         public string ResultDuringFrequency { get; set; }
         public string UserMessage { get; set; }
         public string AttemptMessage { get; set; }
         public int TotalAttempts { get; set; }
         public string BlockedUserMessage { get; set; }
         public bool IsBlocked { get; set; }
         public bool BlockuserAfterExceedAtempts { get; set; }
         public bool FirstTimeLogin { get; set; }
         public bool BlockUserAfterDuration { get; set; }
         
    }

     [PetaPoco.TableName("MCQ_QuestionBankDetails")]
     public class MCQ_QUESTION_OPTION_DTO
     {
         public int UserInfoID { get; set; }
         [PetaPoco.Column("QuestionBankDetailsID")]
         public int QuestionBankDetailsID { get; set; }

         [PetaPoco.Column("OptionNo")]
         public string OptionNo { get; set; }

         [PetaPoco.Column("QuestionID")]
         public int QuestionID { get; set; }

         [PetaPoco.Column("QuestionsAnswer")]
         public string QuestionsAnswer { get; set; }

         [PetaPoco.Column("CorrectAnswer")]
         public string CorrectAnswer { get; set; }
         

     }
}
