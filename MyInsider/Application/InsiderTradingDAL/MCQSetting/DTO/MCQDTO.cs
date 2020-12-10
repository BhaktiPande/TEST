using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    [PetaPoco.TableName("MCQ_MasterSettings")]
    public class MCQDTO
    {
        [PetaPoco.Column("MCQS_ID")]
        public int MCQS_ID	                            { get; set; }
		
        [PetaPoco.Column("FirstTimeLogin")]		    		
        public bool FirstTimeLogin                      { get; set; }  
       
        [PetaPoco.Column("IsSpecificPeriodWise")]	
        public bool IsSpecificPeriodWise	            { get; set; }
	    
        [PetaPoco.Column("FrequencyOfMCQ")]		
        public int?  FrequencyOfMCQ			            { get; set; }
	   
        [PetaPoco.Column("IsDatewise")]		
        public bool IsDatewise				            { get; set; }	
	    
        [PetaPoco.Column("FrequencyDate")]	
        public DateTime? FrequencyDate 		            { get; set; }  
 	    
        [PetaPoco.Column("FrequencyDuration")]	
        public int? FrequencyDuration                    { get; set; }   
	   
        [PetaPoco.Column("BlockUserAfterDuration")]	
        public bool BlockUserAfterDuration	            { get; set; }
	    
        [PetaPoco.Column("NoOfQuestionForDisplay")]		
        public int NoOfQuestionForDisplay              { get; set; }
  	   
        [PetaPoco.Column("AccessTOApplicationForWriteAnswer")]	
        public int AccessTOApplicationForWriteAnswer    { get; set; }
        
        [PetaPoco.Column("NoOfAttempts")]
        public int NoOfAttempts                        { get; set; }
        
        [PetaPoco.Column("BlockuserAfterExceedAtempts")]
        public bool BlockuserAfterExceedAtempts 		{ get; set; }
        
        [PetaPoco.Column("UnblockForNextFrequency")]
        public bool UnblockForNextFrequency             { get; set; }
        
        [PetaPoco.Column("CreatedBy")]
        public int CreatedBy                   		    { get; set; }
        
        [PetaPoco.Column("CreatedOn")]
        public DateTime CreatedOn                   	{ get; set; }
        
        [PetaPoco.Column("UpdatedBy")]
        public int UpdatedBy                   		    { get; set; }
        
        [PetaPoco.Column("UpdatedOn")]
        public DateTime UpdatedOn                   	{ get; set; }

        public int UserInfoID { get; set; }
        public bool MCQStatus { get; set; }
        public DateTime? MCQPerioEndDate{get;set;}
    }
}
