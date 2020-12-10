/*
	11-Feb-2016 : Script to created table to stored mapping for activity and URL
*/

Create Table usr_ActivityURLMapping
(
	ActivityURLMappingId INT NOT NULL IDENTITY (1, 1), 
	ActivityID INT NOT NULL, 
	ControllerName VARCHAR(500) NOT NULL,
	ActionName VARCHAR(500) NOT NULL,
	ActionButtonName VARCHAR(255) NULL,
	CreatedBy INT, 
	CreatedOn DATETIME, 
	ModifiedBy INT, 
	ModifiedOn DATETIME
)
GO

-- add foregin key on activity id field
ALTER TABLE usr_ActivityURLMapping ADD CONSTRAINT 
	FK_usr_ActivityURLMapping_usr_Activity_ActivityID  FOREIGN KEY(ActivityID) REFERENCES usr_Activity (ActivityID)
GO

-- add foregin key on created by field
ALTER TABLE usr_ActivityURLMapping ADD CONSTRAINT 
	FK_usr_ActivityURLMapping_usr_UserInfo_CreatedBy  FOREIGN KEY(CreatedBy) REFERENCES usr_UserInfo (UserInfoId)
GO

-- add foregin key on modified by field	
ALTER TABLE usr_ActivityURLMapping ADD CONSTRAINT 
	FK_usr_ActivityURLMapping_usr_UserInfo_ModifiedBy  FOREIGN KEY(ModifiedBy) REFERENCES usr_UserInfo (UserInfoId)
GO
------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (228, '228 usr_ActivityURLMapping_Create', 'Create usr_ActivityURLMapping table to stored URL and activity id mapping', 'Parag')
