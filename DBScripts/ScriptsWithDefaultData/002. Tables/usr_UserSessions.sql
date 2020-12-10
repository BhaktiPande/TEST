/*
	Created By  : Priyanka Wani
	Created On  : 07-April-2017
	Description : This table is used to store UserId, Auth Token as Cookie Name and its timeout for Authentication purpose as suggested by VAPT issues
*/

IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'usr_UserSessions')
BEGIN

	CREATE TABLE usr_UserSessions
	(
		UserName	VARCHAR(20)		NOT NULL,
		CookieName	NVARCHAR(500)	NOT NULL,
		ExpireOn	DATETIME		NOT NULL
	)	
END
GO
