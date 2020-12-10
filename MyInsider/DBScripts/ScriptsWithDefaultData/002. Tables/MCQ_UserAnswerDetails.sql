/*
	Created By  : Samadhan	
	Created On  : 15-April-2019
	Description : This script is used to create a table with name 'MCQ_UserAnswerDetails'
*/

--drop table MCQ_UserAnswerDetails
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'MCQ_UserAnswerDetails')
BEGIN
	CREATE TABLE dbo.MCQ_UserAnswerDetails
	(
		UAD_ID								INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_MCQ_UserAnswerDetails_UAD_ID PRIMARY KEY,
		UserInfoId							INT NOT NULL CONSTRAINT FK_MCQ_UserAnswerDetails_UserInfoId FOREIGN KEY (UserInfoId) REFERENCES USR_USERINFO (UserInfoId),
		QuestionID  						INT NOT NULL CONSTRAINT FK_MCQ_UserAnswerDetails_QuestionID FOREIGN KEY (QuestionID) REFERENCES MCQ_QuestionBank (QuestionID),
		QuestionBankDetailsID				INT NOT NULL CONSTRAINT FK_MCQ_UserAnswerDetails_QuestionBankDetailsID FOREIGN KEY (QuestionBankDetailsID) REFERENCES MCQ_QuestionBankDetails (QuestionBankDetailsID),
		AttemptNo							INT NOT NULL,
		CorrectAnswer						BIT NOT NULL CONSTRAINT DF_MCQ_UserAnswerDetails_CorrectAnswer DEFAULT (0),
		CreatedBy                   		INT,
		CreatedOn                   		DATETIME,
		UpdatedBy                   		INT,
		UpdatedOn                   		DATETIME
		
	)
END

