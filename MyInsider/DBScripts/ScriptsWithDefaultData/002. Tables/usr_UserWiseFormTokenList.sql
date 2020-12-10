/*
	Created By  : Shubhangi Gurude
	Created On  : 03-Sep-2019
	Description : This table is used to store UserId,FormId to maintain mapping between form and token, Auth Token of form as Token Name and its timeout for Authentication purpose as suggested by VAPT issues
*/

IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'usr_UserWiseFormTokenList')
BEGIN
	CREATE TABLE usr_UserWiseFormTokenList
	(
		ID			INT IDENTITY NOT NULL,
		UserInfoId	INT	NOT NULL,
		FormId		INT,
		TokenName	NVARCHAR(500)	NOT NULL,
		ExpireOn	DATETIME		NOT NULL
		CONSTRAINT PK_usr_UserWiseFormTokenList PRIMARY KEY (ID),
	)	
END
GO

