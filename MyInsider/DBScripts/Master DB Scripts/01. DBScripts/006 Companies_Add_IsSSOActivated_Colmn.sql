/*
	Created By  : Amin
	Created On  : 28-Dec-2017
	Description : This table is used to maintain the auto selection grants when employee goes to exercising his/her options. 
*/

USE Vigilante_Master

IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Companies' AND COLUMN_NAME = 'IsSSOActivated')
BEGIN
	ALTER TABLE COMPANIES ADD IsSSOActivated BIT DEFAULT(0) NOT NULL
END

IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Companies' AND COLUMN_NAME = 'SSOUrl')
BEGIN
	ALTER TABLE COMPANIES ADD SSOUrl varchar(50)
END
