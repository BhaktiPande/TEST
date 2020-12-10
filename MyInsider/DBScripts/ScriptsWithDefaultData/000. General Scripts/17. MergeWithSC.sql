/*------------------------------------------------------------------------------------------------
Description:	Procedure perform Insert details
				
Created by:		Aniket Shingate.
Created on:		03-Mar-2016

Modification History:
Modified By		Modified ON			Description
AniketS			05-April-2016		Inserted new entries in com_code table
-------------------------------------------------------------------------------------------------*/

UPDATE mst_MenuMaster SET MenuURL = '/InsiderInitialDisclosure/DisplayPolicy?CalledFrom=InsiderFAQ&acid=154&PolicyDocumentID=7&DocumentID=21' WHERE MenuID = 45 -- Inside

UPDATE mst_MenuMaster SET MenuURL = '/InsiderInitialDisclosure/DisplayPolicy?CalledFrom=COFAQ&acid=193&PolicyDocumentID=7&DocumentID=21' WHERE MenuID = 44 -- CO


IF NOT EXISTS (SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE ActivityURLMappingId = 604)
BEGIN
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES(193,'InsiderInitialDisclosure','DisplayPolicy',NULL,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE ActivityURLMappingId = 605)
BEGIN
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES(193,'InsiderInitialDisclosure','Generate',NULL,1,GETDATE(),1,GETDATE())
END

/*
Script from Raghvendra on 25-Apr-2016 -- 
Resource for the tooltip to be shown on mouse over of the Tabs seen on Personal details confirmation screen when personal details are not confirmed.
*/
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11438)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(11438,'usr_ttl_11438','You are required to confirm the personal details by clicking on "Confirm Personla Details" to open these details.','You are required to confirm the personal details by clicking on "Confirm Personla Details" to open these details.','en-US',103002,104005,122004,1, GETDATE())
END
