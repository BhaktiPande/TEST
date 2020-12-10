
/*
Script received from Raghvendra on 3-May-2016
Added a new Mode of acquisiton i.e. Bonus. This mode of acquisiton was added as per the request send by Deepak on 2-May-2016 in email.
*/
IF NOT EXISTS(SELECT * FROM com_Code WHERE CodeID = '149011')
BEGIN
	INSERT INTO com_Code VALUES (149011, 'Bonus', 149, 'Mode Of Acquisition - Bonus',1,1,11,NULL,NULL,1, GETDATE())
END
GO


/*
Script received from Tushar on 2 May 2016 -- 
Change for:- Tool tip to be provided for informing user to click on "Action" button to view his Demat details
*/
IF NOT EXISTS(SELECT * FROM mst_Resource WHERE ResourceId = '11439')
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(11439,'usr_ttl_11439','View DEMAT Details','View DEMAT Details','en-US',103002,104005,122015,1 , GETDATE())
END
GO


/*
Script received from Tushar on 2 May 2016 --  
*/
UPDATE mst_Resource SET ResourceValue = 'Total Traded Value', OriginalResourceValue = 'Total Traded Value' WHERE ResourceId = 17448