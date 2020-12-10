/*
	Created By  : Samadhan	
	Created On  : 15-April-2019
	Description : This script is used to create a table with name 'MCQ_QuestionBankDetails'
*/

--drop table MCQ_QuestionBankDetails
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'MCQ_QuestionBankDetails')
BEGIN
	CREATE TABLE dbo.MCQ_QuestionBankDetails
	(
		
		QuestionBankDetailsID				INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_MCQ_QuestionBankDetails_QuestionBankDetailsID PRIMARY KEY,
		OptionNo							CHAR(2) NOT NULL ,
		QuestionID  						INT NOT NULL CONSTRAINT FK_MCQ_QuestionBankDetails_QuestionID FOREIGN KEY (QuestionID) REFERENCES MCQ_QuestionBank (QuestionID),
		QuestionsAnswer						VARCHAR(250),
		CorrectAnswer						BIT  NOT NULL CONSTRAINT DF_MCQ_QuestionBankDetails_CorrectAnswer DEFAULT (0),
		CreatedBy                   		INT,
		CreatedOn                   		DateTime,
		UpdatedBy                   		INT,
		UpdatedOn                   		DateTime
	)
END
ALTER TABLE dbo.MCQ_QuestionBankDetails ALTER COLUMN  OptionNo char(2);
