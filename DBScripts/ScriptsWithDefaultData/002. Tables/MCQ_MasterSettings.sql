/*
	Created By  : Samadhan	
	Created On  : 15-April-2019
	Description : This script is used to create a table with name 'MCQ_MasterSettings'
*/
--drop table MCQ_MasterSettings
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'MCQ_MasterSettings')
BEGIN
	CREATE TABLE dbo.MCQ_MasterSettings
	(
		
		MCQS_ID					    		INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_MCQ_MasterSettings_MCQS_ID PRIMARY KEY ,
		FirstTimeLogin              		BIT NOT NULL CONSTRAINT DF_MCQ_MasterSettings_FirstTimeLogin DEFAULT (0) ,
		IsSpecificPeriodWise				BIT NOT NULL CONSTRAINT DF_MCQ_MasterSettings_IsSpecificPeriodWise DEFAULT (0) ,
		FrequencyOfMCQ						INT NULL,
		IsDatewise							BIT NOT NULL CONSTRAINT DF_MCQ_MasterSettings_IsDatewise DEFAULT (0) ,
		FrequencyDate 		        		DATETIME  NULL,
		FrequencyDuration           		INT, 
		BlockUserAfterDuration				BIT NOT NULL CONSTRAINT DF_MCQ_MasterSettings_BlockUserAfterDuration DEFAULT (0), 
		NoOfQuestionForDisplay      		INT,
		AccessTOApplicationForWriteAnswer	INT,
		NoOfAttempts                        int,
		BlockuserAfterExceedAtempts 		BIT NOT NULL CONSTRAINT DF_MCQ_MasterSettings_BlockuserAfterExceedAtempts DEFAULT (0),
		UnblockForNextFrequency				BIT NOT NULL CONSTRAINT DF_MCQ_MasterSettings_UnblockForNextFrequency DEFAULT (0),
		CreatedBy                   		INT,
		CreatedOn                   		DateTime,
		UpdatedBy                   		INT,
		UpdatedOn                   		DateTime
		
	)
END
