/*

Created By :- Tushar
Created On - 23 Mar 2016
Description :-  Alter Table rul_TradingPolicy

*/

IF NOT EXISTS(SELECT SYSCOL.NAME FROM SYS.columns SYSCOL INNER JOIN SYS.TABLES SYSTAB ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'rul_TradingPolicy' AND SYSCOL.NAME = 'ContraTradeBasedOn')
BEGIN
	ALTER TABLE rul_TradingPolicy ADD ContraTradeBasedOn INT NOT NULL DEFAULT 177001
END
GO


/* 
Received from Tushar: 22 Apr 2016
*/
IF NOT EXISTS(SELECT CODEID FROM com_Code WHERE CodeID = '132013')
BEGIN
	INSERT INTO com_Code
		(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(132013, 'Contra Trade', 132, 'Contra Trade', 1, 1, GETDATE(), 13)
END
GO


/* 
Received from Tushar: 22 Apr 2016
*/
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = '177')
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
		(177, ' Contra Trade Based On', ' Contra Trade Based On', 1, 0)
END
GO


IF NOT EXISTS(SELECT CODEID FROM com_Code WHERE CodeID = '177001')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(177001, 'All Security Type', 177, 'All Security Type', 1, 1, GETDATE(), 1),
		(177002, 'Individual Security Type', 177, 'Individual Security Type', 1, 1, GETDATE(), 2)
END
GO	


/*
Code Merge with ED on 25-Apr-2016
*/
UPDATE mst_MenuMaster SET MenuURL = '/InsiderInitialDisclosure/DisplayPolicy?CalledFrom=InsiderFAQ&acid=154&PolicyDocumentID=7&DocumentID=21' WHERE MenuID = 45 -- Insider
UPDATE mst_MenuMaster SET MenuURL = '/InsiderInitialDisclosure/DisplayPolicy?CalledFrom=COFAQ&acid=193&PolicyDocumentID=7&DocumentID=21' WHERE MenuID = 44 -- CO
GO

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 15454) 
BEGIN
	INSERT INTO mst_Resource(ResourceId,ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
		(15454,'rul_ttl_15454', 'Contra Trade', 'Contra Trade', 'en-US', 103006, 104006,122040,1, GETDATE()),
		(15455,'rul_lbl_15455', 'Contra Trade Based On', 'Contra Trade Based On', 'en-US', 103006, 104002,122040,1, GETDATE()),
		(15456,'rul_lbl_15456', 'All Security Type', 'All Security Type', 'en-US', 103006, 104002,122040,1, GETDATE()),
		(15457,'rul_lbl_15457', 'Individual Security Type', 'Individual Security Type', 'en-US', 103006, 104002,122040,1, GETDATE()),
		(15458,'rul_msg_15458', 'Mandatory:Please select at least on Security Type for Contra Trade based on.', 'Mandatory:Please select at least on Security Type for Contra Trade based on.', 'en-US', 103006, 104001,122040,1, GETDATE())
END
GO

