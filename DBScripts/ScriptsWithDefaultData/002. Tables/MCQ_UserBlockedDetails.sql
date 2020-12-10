/*
	Created By  : Samadhan	
	Created On  : 14-June-2019
	Description : This script is used to create a table with name 'MCQ_UserBlockedDetails'
*/

--drop table MCQ_UserBlockedDetails
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'MCQ_UserBlockedDetails')
BEGIN
	CREATE TABLE dbo.MCQ_UserBlockedDetails
	(
		UBD_ID								INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_MCQ_UserBlockedDetails_UBD_ID PRIMARY KEY,
		UserInfoId							INT NOT NULL CONSTRAINT FK_MCQ_UserBlockedDetails_UserInfoId FOREIGN KEY (UserInfoId) REFERENCES USR_USERINFO (UserInfoId),
		IsBlocked  							BIT NOT NULL CONSTRAINT DF_MCQ_UserBlockedDetails_IsBlocked DEFAULT (0),
		Blocked_UnBlock_Reason				VARCHAR(MAX)  NULL,
	    Blocked_Date						DATETIME   NULL,
		UnBlocked_Date						DATETIME   NULL,
		FrequencyDateBYAdmin				DATETIME   NULL,
		ReasonForBlocking					VARCHAR(MAX)  NULL,
		MCQ_ExamDate						DATETIME,
		CreatedBy                   		INT,
		CreatedOn                   		DATETIME,
		UpdatedBy                   		INT,
		UpdatedOn                   		DATETIME
		
	)
END
