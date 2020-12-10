/*
	Created By  : Samadhan	
	Created On  : 15-April-2019
	Description : This script is used to create a table with name 'MCQ_QuestionBank'
*/

--drop table MCQ_QuestionBank
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'MCQ_QuestionBank')
BEGIN
	CREATE TABLE dbo.MCQ_QuestionBank
	(
		
		QuestionID					    	INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_MCQ_QuestionBank_QuestionID PRIMARY KEY ,
		Question		              		VARCHAR(250) NOT NULL,
		AnswerTypes							INT NOT NULL CONSTRAINT DF_MCQ_QuestionBank_AnswerTypes DEFAULT (2) ,
		OptionNumbers						INT NULL,
		CreatedBy                   		INT,
		CreatedOn                   		DATETIME,
		UpdatedBy                   		INT,
		UpdatedOn                   		DATETIME
		
	)
END
