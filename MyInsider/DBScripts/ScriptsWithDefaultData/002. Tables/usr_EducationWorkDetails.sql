/*
	Created By  : Samadhan	
	Created On  : 11-Feb-2019
	Description : This script is used to create a table with name ''
*/

--drop table usr_EducationWorkDetails
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'usr_EducationWorkDetails')
BEGIN
	CREATE TABLE dbo.usr_EducationWorkDetails
	(
		
		UEW_id					    INT IDENTITY(1,1) NOT NULL,
		UserInfoID                  INT NOT NULL,
		InstituteName		        VARCHAR (250)  NULL,
		CourseName				    VARCHAR (250)  NULL,
		EmployerName		        VARCHAR (250)  NULL,
		Designation 		        VARCHAR (100)  NULL,
		PMonth                      VARCHAR(20)    NULL, --Passing month column also used for work From Month
		PYear						VARCHAR(20)	   NULL, --Passing Year column also used for work From Year
		ToMonth                     VARCHAR(20)    NULL,
		ToYear                      INT,
		Flag                        int, --1 : Education details 0 : Work details
		CreatedBy                   INT,
		CreatedOn                   DateTime,
		UpdatedBy                   INT,
		UpdatedOn                   DateTime,
		
		CONSTRAINT PK_User_EducationOrWorkId PRIMARY KEY (UEW_id),
	)
END
