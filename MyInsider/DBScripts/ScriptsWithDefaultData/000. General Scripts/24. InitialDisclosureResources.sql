/*------------------------------------------------------------------------------------------------
Description:	Procedure perform Insert details			
Created by:		Aniket Shingate.
Created on:		03-Mar-2016
-------------------------------------------------------------------------------------------------*/

/* INSERT VALUES INTO mst_Resource TABLE ---- START */
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50062)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50062, 'tra_lbl_50062', 
	'Note: The number of shares displayed under “Securities” is your balance of shares as on 1st April, 2016. Please note that transactions post 1st April, 2016 can be viewed on the “Preclearances / Continuous Disclosures” webpage. Please update shareholding of your relatives as on 1st April, 2016 by clicking on "Add Shares" link on this screen.', 
	'en-US', '103008', '104002', '122036', 
	'Note: The number of shares displayed under “Securities” is your balance of shares as on 1st April, 2016. Please note that transactions post 1st April, 2016 can be viewed on the “Preclearances / Continuous Disclosures” webpage. Please update shareholding of your relatives as on 1st April, 2016 by clicking on "Add Shares" link on this screen.', 1, 
	GETDATE() )
END
/* INSERT VALUES INTO mst_Resource TABLE ---- END */
