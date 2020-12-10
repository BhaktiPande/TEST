/*
Script from Tushar on 21 Apr 2016 -- for showing error message on validation negative balance
*/

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '16430')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
	(16430,'tra_msg_16430', 'You cannot proceed these transaction quantity does not exist in the pool, you are missing some transaction or you enter more quantity than traded', 'You cannot proceed these transaction quantity does not exist in the pool, you are missing some transaction or you enter more quantity than traded', 'en-US', 103008, 104001,122036,1, GETDATE())
END

