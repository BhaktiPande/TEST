/*
Script from Vivek Mathur on 14 June 2017 -- As requested by RBL, adding notes in resource to enable custom note display on Preclearance and Continuous disclosures page
Modification History:
Modified By		Modified On	Description
Vivek		    27-July-2017 updated the resources to store multiple notes separated by '|' character.
*/

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50546')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
	(50546,'dis_msg_50546', 'The pending days indicates the days within which this pre clearance request is required to be closed.', 'The pending days indicates the days within which this pre clearance request is required to be closed.', 'en-US', 103009, 104001,122044,1, GETDATE())
END


IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50547')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
	(50547,'dis_msg_50547', 'Trade details are required to be submitted within 2 days from the date of your transaction. In case the transaction is not undertaken, a report to that effect shall be filed in Form F within 2 trading days of the expiry of the validity of pre-clearance', 'Trade details are required to be submitted within 2 days from the date of your transaction. In case the transaction is not undertaken, a report to that effect shall be filed in Form F within 2 trading days of the expiry of the validity of pre-clearance', 'en-US', 103009, 104001,122044,1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50548')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
	(50548,'dis_msg_50548', 'Click on "Create Pre-Clearance Request" button to Create a New Pre Clearance Request. To submit trade details after Pre Clearance is approved, click on "Pending" for the specified pre Clearance ID in the grid below.', 'Click on "Create Pre-Clearance Request" button to Create a New Pre Clearance Request. To submit trade details after Pre Clearance is approved, click on "Pending" for the specified pre Clearance ID in the grid below.', 'en-US', 103009, 104001,122044,1, GETDATE())
END

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '50549')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
	(50549,'dis_msg_50549', 'If you are not required to take a Pre Clearance , click on "Pre-Clearance not required? Submit your Disclosures" button to submit your trade details. However if you have already taken a Pre Clearance, click on the "Pending" button  for the specific Pre Clearance ID in the grid below to submit your trade details.', 'If you are not required to take a Pre Clearance , click on "Pre-Clearance not required? Submit your Disclosures" button to submit your trade details. However if you have already taken a Pre Clearance, click on the "Pending" button  for the specific Pre Clearance ID in the grid below to submit your trade details.', 'en-US', 103009, 104001,122044,1, GETDATE())
END

IF EXISTS (SELECT * FROM mst_Resource where ResourceId = '50548')
BEGIN
	UPDATE mst_Resource
	SET ResourceValue = 'Click on "Create Pre-Clearance Request" button to Create a New Pre Clearance Request. To submit trade details after Pre Clearance is approved, click on "Pending" for the specified pre Clearance ID in the grid below.|If you are not required to take a Pre Clearance , click on "Pre-Clearance not required? Submit your Disclosures" button to submit your trade details. However if you have already taken a Pre Clearance, click on the "Pending" button  for the specific Pre Clearance ID in the grid below to submit your trade details.'
	, OriginalResourceValue = 'Click on "Create Pre-Clearance Request" button to Create a New Pre Clearance Request. To submit trade details after Pre Clearance is approved, click on "Pending" for the specified pre Clearance ID in the grid below.|If you are not required to take a Pre Clearance , click on "Pre-Clearance not required? Submit your Disclosures" button to submit your trade details. However if you have already taken a Pre Clearance, click on the "Pending" button  for the specific Pre Clearance ID in the grid below to submit your trade details.'
	WHERE ResourceId = '50548'
END

IF EXISTS (SELECT * FROM mst_Resource where ResourceId = '50549')
BEGIN
	UPDATE mst_Resource
	SET ResourceValue = 'Please note that additional demat accounts for self or dependents can be updated by clicking on tab User>View my details.'
	, OriginalResourceValue = 'Please note that additional demat accounts for self or dependents can be updated by clicking on tab User>View my details.'
	WHERE ResourceId = '50549'
END