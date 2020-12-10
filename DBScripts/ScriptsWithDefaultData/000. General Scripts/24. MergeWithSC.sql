/*
Script received from Raghvendra on 11-May-2016

Added resource for the error message to be shown on the Stock Exchange Submission page. The resource can be seen under (Module)Disclosures>(Screen)TransactionLetter 
on the Resources screen.
*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17449)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17449, 'dis_msg_17449', 'Submission Date can not be after today''s date', 'Submission Date can not be after today''s date', 'en-Us', 103009, 104001, 122052, 1 , GETDATE()),
	(17450, 'dis_msg_17450', 'Please Upload Document', 'Please Upload Document', 'en-Us', 103009, 104001, 122052, 1 , GETDATE()),
	(17451, 'dis_msg_17451', 'Enter Submission Date', 'Enter Submission Date', 'en-Us', 103009, 104001, 122052, 1 , GETDATE())
END
