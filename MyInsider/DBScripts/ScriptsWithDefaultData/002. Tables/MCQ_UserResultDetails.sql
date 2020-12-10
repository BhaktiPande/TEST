/*
	Created By  : Samadhan	
	Created On  : 20-June-2019
	Description : This script is used to create a table with name 'MCQ_UserResultDetails'
*/

--drop table MCQ_UserResultDetails
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'MCQ_UserResultDetails')
BEGIN
	CREATE TABLE dbo.MCQ_UserResultDetails
	(
		UR_ID								INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_MCQ_UserResultDetails_UR_ID PRIMARY KEY,
		UserInfoId							INT NOT NULL CONSTRAINT FK_MCQ_UserResultDetails_UserInfoId FOREIGN KEY (UserInfoId) REFERENCES USR_USERINFO (UserInfoId),
		AttemptNo  							INT NOT NULL,
		FalseAnswer							INT NOT NULL,
		CorrectAnswer						INT NOT NULL,
		ResultDuringFrequency				INT NOT NULL CONSTRAINT DF_MCQ_UserResultDetails_ResultDuringFrequency DEFAULT (0),
		MCQ_ExamDate						DATETIME,
		CreatedBy                   		INT,
		CreatedOn                   		DATETIME,
		UpdatedBy                   		INT,
		UpdatedOn                   		DATETIME
		
	)
END
