/*
	Created By  : Arvind	
	Created On  : 14-Feb-2019
	Description : This script is used to create a table with name 'usr_ContactDetails'
*/

--drop table usr_ContactDetails
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'usr_ContactDetails')
BEGIN
	CREATE TABLE dbo.usr_ContactDetails
	(
		
		Contact_id					INT IDENTITY(1,1) NOT NULL,
		MobileNumber				Varchar(250),
		UserInfoID                  INT NOT NULL,
		UserRelativeID              INT NOT NULL,
		CreatedBy                   INT,
		CreatedOn                   DateTime,
		UpdatedBy                   INT,
		UpdatedOn                   DateTime,
		
	)
END
