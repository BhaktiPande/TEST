/*
	Created By  : Shubhangi	
	Created On  : 03-Jul-2019
	Description : This script is used to create a table with name 'MCQ_CheckUsrStatus'
*/

--drop table MCQ_UserResultDetails
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'MCQ_CheckUsrStatus')
BEGIN
	CREATE TABLE dbo.MCQ_CheckUsrStatus
	(
		ID									INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_MCQ_CheckUsrStatus_ID PRIMARY KEY,
		UserInfoId							INT NOT NULL CONSTRAINT FK_MCQ_CheckUsrStatus_UserInfoId FOREIGN KEY (UserInfoId) REFERENCES USR_USERINFO (UserInfoId),
		MCQStatus							BIT,
		MCQPerioEndDate						DATETIME,
		FrequencyDate						DATETIME,
		CreatedBy                   		INT,
		CreatedOn                   		DATETIME,
		UpdatedBy                   		INT,
		UpdatedOn                   		DATETIME		
	)
END

