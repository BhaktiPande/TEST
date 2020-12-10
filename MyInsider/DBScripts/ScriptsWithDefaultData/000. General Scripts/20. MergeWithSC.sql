/*
Script received from Tushar on 2 May 2016 -- Change for show Total Traded Quantity (Stock Exchange Submission)
*/

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17448) 
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17448,'dis_grd_17448','Total Traded Quantity','Total Traded Quantity','en-US',103008,104003,122057,1 , GETDATE())
END	
GO	
	
	
/*
Script received from Tushar on 2 May 2016 --  Change for show date in contra trade message
*/
UPDATE mst_Resource
SET ResourceValue = 'This Pre-clearance request violates Contra Trade rules.  Contra trading is not allowed till $1 for $2 transaction types.',
    OriginalResourceValue = 'This Pre-clearance request violates Contra Trade rules.  Contra trading is not allowed till $1 for $2 transaction types.'
WHERE ResourceId = 17343	
GO


/*
For grid type code id 114049
Script received from Tushar on 2 May 2016 -- Change for show Total Traded Quantity (Stock Exchange Submission)
*/
IF NOT EXISTS (SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114049 AND ResourceKey = 'dis_grd_17448') 
BEGIN
	INSERT INTO com_GridHeaderSetting 
	(GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
	values
	(114049,'dis_grd_17448',NULL,1,9,0,155001,NULL)
END	
GO	
