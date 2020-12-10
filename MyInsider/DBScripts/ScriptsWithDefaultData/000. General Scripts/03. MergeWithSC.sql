/*
	Date : 11-Mar-2016
	Desc : Code integration with SC
*/


DELETE FROM usr_UserTypeActivity WHERE UserTypeCodeId IN (101001, 101002, 101005) AND ActivityId = 39 

UPDATE usr_Activity SET ActivityName = 'Create', Description = 'Create right for Separation details' WHERE ActivityID = 38
UPDATE usr_Activity SET ActivityName = 'Re-Activate', Description = 'Re-Activate right for Separation details' WHERE ActivityID = 40


--Script Received from Raghvendra on 19-Feb-2016
--Change for removing the un used ActivityId for MassUpload i.e. 195 and instead use 9
DELETE FROM usr_RoleActivity WHERE ActivityId = 195
DELETE FROM [usr_UserTypeActivity] WHERE ActivityId = 195

--Update the ACID for the menu link
UPDATE mst_MenuMaster SET MenuURL = 'MassUpload/AllMassUpload?acid=9', ActivityID = 9 WHERE MenuId = 46

DELETE FROM usr_Activity WHERE ActivityId = 195

--Update the screen code ID for the Mass Upload activity
UPDATE usr_Activity SET ModuleCodeID = 103013, ScreenName='Mass Upload',ActivityName='Perform Mass Upload',Description='Rights to perform Mass Upload' WHERE ActivityId = 9


/* Sent by GS 02-Mar-2016 */
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11437)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(11437, 'usr_ttl_11437', 'Employee/Insider Details', 'Employee/Insider Details', 'en-US', 103002, 104006, 122004, 1, GETDATE())
END


/* Sent by Raghvendra 09-Mar-2016 */
/*
Script Given by Raghvendra.
Script to increase the code length for the code used for Department.
The change is required in com_Code table but as there is a Foreign Key on usr_UserInfo table,
so we have to delete the foreign key first then updated the values for code in both the tables 
and then again apply the foreign key
Note: Execute this script only once if executed more than once then may corrupt the data.
*/

ALTER TABLE usr_UserInfo
DROP CONSTRAINT FK_usr_UserInfo_com_Code_DepartmentId
GO

DECLARE @CodeGroupId INT = 110   --For Department Code

UPDATE usr_UserInfo set DepartmentId = CONVERT(INT,SUBSTRING(CONVERT(VARCHAR(MAX),DepartmentId),0,4)+ '00' + SUBSTRING(CONVERT(VARCHAR(MAX),DepartmentId),4,3))

UPDATE com_Code set CodeID = CONVERT(INT,SUBSTRING(CONVERT(VARCHAR(MAX),CodeId),0,4)+ '00' + SUBSTRING(CONVERT(VARCHAR(MAX),CodeId),4,3))
where CodeGroupId = @CodeGroupId

ALTER TABLE usr_UserInfo 
ADD CONSTRAINT FK_usr_UserInfo_com_Code_DepartmentId FOREIGN KEY (DepartmentId) 
    REFERENCES com_Code (CodeId) 
GO

/*	End: Changes Made in ESOP  */

ALTER TABLE tra_TransactionDetails ALTER COLUMN DateOfInitimationToCompany DateTime NULL
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (229, '229 tra_TransactionDetails_Alter', 'Alter tra_TransactionDetails table to make date of intimating company field null', 'Raghvendra')
GO

BEGIN
	ALTER TABLE usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_DepartmentId
	

	DECLARE @CodeGroupId INT = 110   --For Department Code

	UPDATE usr_UserInfo set DepartmentId = CONVERT(INT,SUBSTRING(CONVERT(VARCHAR(MAX),DepartmentId),0,4)+ '00' + SUBSTRING(CONVERT(VARCHAR(MAX),DepartmentId),4,3))

	UPDATE com_Code set CodeID = CONVERT(INT,SUBSTRING(CONVERT(VARCHAR(MAX),CodeId),0,4)+ '00' + SUBSTRING(CONVERT(VARCHAR(MAX),CodeId),4,3))
	where CodeGroupId = @CodeGroupId

	ALTER TABLE usr_UserInfo 
	ADD CONSTRAINT FK_usr_UserInfo_com_Code_DepartmentId FOREIGN KEY (DepartmentId) 
		REFERENCES com_Code (CodeId) 
END
GO

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 16332)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES	
	(16332 ,'tra_msg_16332' ,'Date of intimation to company should be greater than or equal to Date of Acquisition','Date of intimation to company should be greater than or equal to Date of Acquisition' ,'en-US' ,103008 ,104001 ,122043 ,1 ,GETDATE())
END

INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
(122,'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()),
(122,'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()),
(122,'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()),
(123,'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()),
(123,'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()),
(123,'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()),
(121,'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE())

