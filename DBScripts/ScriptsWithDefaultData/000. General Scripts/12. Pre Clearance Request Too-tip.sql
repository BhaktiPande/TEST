-- ======================================================================================
-- Author      : Gaurav Ugale															=
-- CREATED DATE: 04-APR-2016                                                 			=
-- Description : INSERT DATA INTO MST_RESOURCE FOR PRE CLEARANCE REQUEST TOO-TIP		=
--																						=		
-- ======================================================================================

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId IN (50054,50055))
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES 
	(50054,'mst_lbl_50054','Click here to Create a New Pre Clearance Request.     To submit trade details after Pre Clearance is approved, click on "Pending" for the specified pre Clearance ID in the grid below.','en-US',103009,104005,122046,'Click here to Create a New Pre Clearance Request.     To submit trade details after Pre Clearance is approved, click on "Pending" for the specified pre Clearance ID in the grid below.',1,GETDATE()),
	(50055,'mst_lbl_50055','If you are not required to take a Pre Clearance , click here to submit your trade details.     However if you have already taken a Pre Clearance, click on the "Pending" button  for the specific Pre Clearance ID in the grid below to submit your trade details.','en-US',103009,104005,122046,'If you are not required to take a Pre Clearance , click here to submit your trade details.     However if you have already taken a Pre Clearance, click on the "Pending" button  for the specific Pre Clearance ID in the grid below to submit your trade details.',1,GETDATE())
END


