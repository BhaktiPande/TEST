
/*
Script By - Gaurishankar
Script On - 07-Oct-2015
Script for - add new columns for update separation as per new design
				NoOfDaysToBeActive colums use to save no of days that user should active after date od separation. auto populated from masters 
				DateOfInactivation column use to save date of inactivation that is calculated based on date of separation and NoOfDaysToBeActive
*/

ALTER TABLE usr_UserInfo 
ADD  NoOfDaysToBeActive INT NULL
GO

ALTER TABLE usr_UserInfo 
ADD  DateOfInactivation DATETIME NULL
GO

----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (191, '191 usr_UserInfo_Alter', 'usr_UserInfo Alter', 'GS')
