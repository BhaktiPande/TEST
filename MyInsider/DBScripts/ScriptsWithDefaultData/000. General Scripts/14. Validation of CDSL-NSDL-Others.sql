/*------------------------------------------------------------------------------------------------
Description:	Procedure perform Insert details
				
Created by:		Aniket Shingate.
Created on:		03-Mar-2016

Modification History:
Modified By		Modified ON			Description
AniketS			05-April-2016		Inserted new entries in com_code table
-------------------------------------------------------------------------------------------------*/

SET NOCOUNT ON;
IF NOT EXISTS (SELECT * FROM mst_Resource WHERE ResourceId = 50057)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50057,'usr_lbl_50057','Depository Name ', 'en-US', 103002, 104002, 122072, 'Depository Name ', 1, GETDATE())	
END

--Demat account note
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50058)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50058,'usr_lbl_50058','1. Under Depository Name, please enter NSDL, CDSL or others, but we have not provided option to update Depository name.', 'en-US', 103002, 104002, 122072, '1. In note we have mentioned: Under Depository Name, please enter NSDL, CDSL or others, but we have not provided option to update Depository name.', 1, GETDATE())	
END
ELSE
	UPDATE mst_Resource SET ResourceValue = '1. Under Depository Name: If you have a demat account, please select NSDL, CDSL. If you have physical shares, select Others' WHERE ResourceId = 50058
	

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50059)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50059,'usr_lbl_50059','2. If you have a Demat account with NSDL, please update your 8 digit Client ID number and DP id No. (DP id Start with "IN").', 'en-US', 103002, 104002, 122072, '2. Working should be: If you have a Demat account with NSDL, please update your 8 digit Client ID number and DP id No. (DP id Start with "IN")', 1, GETDATE())	
END
ELSE
	UPDATE mst_Resource SET ResourceValue = '2. If you have a Demat account with NSDL, please update your 8 digit Client ID number and DP ID Number (DP ID Start with "IN").' WHERE ResourceId = 50059

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50060)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50060,'usr_lbl_50060','3. Please update your 16 digit Client id Number (starting 8 digit will be your DP ID number)', 'en-US', 103002, 104002, 122072, '3. If you have a Demate account with CDSL, Please update your 16 digit Client id Number (starting 8 digit will be your DP ID number)', 1, GETDATE())	
END
ELSE
	UPDATE mst_Resource SET ResourceValue = '3. If you have a Demat account with CDSL, please update your 16 digit Client ID Number (starting 8 digits will be your DP ID number)' WHERE ResourceId = 50060
	
	
IF NOT EXISTS (SELECT * FROM mst_Resource WHERE ResourceId = 50061)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50061,'usr_lbl_50061','4. If you have physical shares, select “Physical Shares” under Depository Participant name and enter your folio number under Client ID (this will be auto populated under Depository Participant ID)', 'en-US', 103002, 104002, 122072, '4. If you have physical shares, select "Physical Shares" under Depository Participant name and enter your folio number under Client ID (this will be auto populated under Depository Participant ID) ', 1, GETDATE())	
END	

SET NOCOUNT OFF;