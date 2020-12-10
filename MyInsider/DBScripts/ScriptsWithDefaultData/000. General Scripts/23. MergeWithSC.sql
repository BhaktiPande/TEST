/* 
20-Jan-2016 : Script for Alter table to add new column in table 
*/

IF NOT EXISTS (SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL on SYSCOL.object_id = SYSTAB.object_id WHERE SYSTAB.NAME  = 'mst_Company' AND SYSCOL.NAME = 'AutoSubmitTransaction')
BEGIN
	ALTER TABLE mst_Company ADD AutoSubmitTransaction INT NULL
	
	INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
	VALUES (240, '240 mst_Company_Alter', 'mst_Company Alter to add new column for auto submit transaction configuration', 'Parag')
END
GO



/*
Script from Parag on 4-May-2016
Added group and code for auto submit transcation 

GroupId: 169
Auto submit transaction configuration
*/

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = '178')
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(178, NULL, 'Auto submit transaction', 'Auto submit transaction', 1, 0)

	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(178001, NULL, 'No Auto Submit', NULL, 178, 'No auto submit transaction', 1, 1, GETDATE(), 1),
		(178002, NULL, 'Auto Submit - Continuous Disclosure from Mass Upload', NULL, 178, 'Auto Submit - Continuous Disclosure from Mass Upload', 1, 1, GETDATE(), 2)
END
GO

/*
Script from Parag on 4 May 2016 -- 
Update default value for implementing company for auto submit transaction configuration 
*/

UPDATE mst_Company set AutoSubmitTransaction = 178001 WHERE IsImplementing = 1


/*
Script from Parag on 4 May 2016 -- 
Add resource for auto submit transaction error messages
*/
IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = '16431' AND ResourceKey = 'tra_msg_16431')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16431 ,'tra_msg_16431' ,'Error occured while auto submitting transaction' ,'Error occured while auto submitting transaction' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE())
END

IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = '16432' AND ResourceKey = 'tra_msg_16432')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES 
	(16432 ,'tra_msg_16432' ,'Error occured while auto submitting transaction initial disclosure' ,'Error occured while auto submitting transaction initial disclosure' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE())
END