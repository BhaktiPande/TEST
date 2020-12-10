/*
	Created By  : Shubhangi Gurude
	Created On  : 06-Sept-2019
	Description : This table is used to store UserId, Auth Token as Cookie Name and its timeout for Authentication purpose as suggested by VAPT issues
*/

IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'usr_UserValidSession')
BEGIN
	CREATE TABLE usr_UserValidSession
	(
		ID			INT IDENTITY NOT NULL,
		UserInfoId	INT	NOT NULL,		
		CookieName	NVARCHAR(500)	NOT NULL		
	)	
END
GO