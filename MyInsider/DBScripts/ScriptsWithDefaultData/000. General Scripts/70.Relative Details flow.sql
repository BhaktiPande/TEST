
-- ======================================================================================================
-- Author      : Tushar Wakchaure, NovitKumar Magare
-- CREATED DATE: 10-Oct-2018
-- Description : Script for Personal Details Confirmation Functionality.
-- ======================================================================================================


--Add colom in usr_UserInfo with name Status 

IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'usr_UserInfo' AND SYSCOL.NAME = 'RelativeStatus')
BEGIN
	ALTER TABLE usr_UserInfo ADD [RelativeStatus] INT NOT NULL DEFAULT(102001)
END

--Update relative page label 
update mst_Resource set ResourceValue='Relation With Insider' where ResourceId=11023

--Add new reourcekey for "Demat account available"
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50734)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50734,'usr_lbl_50734','Demat account available','en-US',103002,104002,122016,'Demat account available',1,GETDATE())
END

--Add new reourcekey for "SAVE & ADD DEMAT"
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50735)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50735,'com_btn_50735','SAVE & ADD DEMAT','en-US',103003,104004,122034,'SAVE & ADD DEMAT',1,GETDATE())
END

--12-11-18
--Add Reourcekey for 'Status' in Grid view
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50739)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50739,'usr_grd_50739','Status','en-US',103002,104003,122015,'Status',1,GETDATE())
END

--Add Reourcekey for 'Number of Demat Account' in Grid view
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50740)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50740,'usr_grd_50740','Number of Demat Account','en-US',103002,104003,122015,'Number of Demat Account',1,GETDATE())
END


/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_50739')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114010,'usr_grd_50739',1,7,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_50740')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114010,'usr_grd_50740',1,8,0,155001,NULL,NULL)
END

--22-11-2018
--Add new reourcekey for "Relative Details And DMAT Details Save Successfully"
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50754)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50754,'usr_msg_50754','Relative Details And DMAT Details Save Successfully','en-US',103002,104001,122073,'Relative Details And DMAT Details Save Successfully',1,GETDATE())
END

--23-11-2018

--Add new reourcekey for "Status" for GridView coloum name on grid

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50755)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50755,'usr_grd_50755','Status','en-US',103002,104003,122007,'Status',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_50755')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114005,'usr_grd_50755',1,7,0,155001,114074,'usr_grd_50755')
END

--04-12-2018
--Update Add Demate Button in Grideview to set the alignment as a right
update com_GridHeaderSetting  set ColumnAlignment = 155003 where ResourceKey = 'usr_grd_50740'


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50732)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50732,'cmp_ttl_50732','Personal Details Confirmation Setting','en-US',103005,104006,122084,'Personal Details Confirmation Setting',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50733)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50733,'cmp_lbl_50733','Reconfirmation Frequency','en-US',103005,104006,122084,'Reconfirmation Frequency',1,GETDATE())
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50737)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50737,'cmp_msg_50737','Personal Details Confirmation saved successfully','en-US',103005,104006,122084,'Personal Details Confirmation saved successfully',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50738)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50738,'cmp_msg_50738','Error occurred while fetching Personal Details Confirmation data.','en-US',103005,104001,122084,'Error occurred while fetching Personal Details Confirmation data.',1,GETDATE())
END

/* For User Dmat Module*/

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50751)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50751,'usr_lbl_50751','Status','en-US',103002,104002,122008,'Status',1,GETDATE())
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50752)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50752,'usr_grd_50752','Status','en-US',103002,104003,122007,'Status',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_50752')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114005,'usr_grd_50752',1,6,0,155001,NULL,NULL)
END

--Add column in usr_DMATDetails
IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'usr_DMATDetails' AND SYSCOL.NAME = 'DmatAccStatusCodeId')
BEGIN
	ALTER TABLE usr_DMATDetails ADD DmatAccStatusCodeId INT NOT NULL DEFAULT(102001)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50764)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50764,'usr_btn_50764','I donot have Demat A/C, Proceed','en-US',103002,104004,122004,'I donot have Demat A/C, Proceed',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50765)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50765,'usr_btn_50765','Save & Proceed','en-US',103002,104004,122004,'Save & Proceed',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50766)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50766,'usr_btn_50766','Personal & Professional Details','en-US',103002,104004,122004,'Personal & Professional Details',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50767)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50767,'usr_btn_50767','Demat Details','en-US',103002,104004,122004,'Demat Details',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50768)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50768,'usr_btn_50768','Relative Details','en-US',103002,104004,122004,'Relative Details',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50769)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50769,'usr_btn_50769','Save & Proceed','en-US',103002,104004,122004,'Save & Proceed',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50770)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50770,'usr_lbl_50770','You have not provided the demat detail. Are you sure you want to proceed to fill the relatives information ?','en-US',103002,104002,122004,'You have not provided the demat detail. Are you sure you want to proceed to fill the relatives information ?',1,GETDATE())
END

--10-01-2019
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50772)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50772,'usr_btn_50772','I Do not Have Relatives Details To Add, Proceed','en-US',103002,104004,122016,'I Do not Have Relatives Details To Add',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50773)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50773,'usr_lbl_50773','I Do not Have Relatives Details To Add, Proceed ?','en-US',103002,104002,122016,'I Do not Have Relatives Details To Add, Proceed ?',1,GETDATE())
END

/* Update table mst_MenuMaster */
IF EXISTS(SELECT * FROM mst_MenuMaster WHERE MenuName = 'View My Details' AND MenuURL = '/Employee/ViewDetails?acid=81&nUserInfoID={UserInfoID}')
BEGIN
    UPDATE mst_MenuMaster SET MenuURL = '/Employee/Create?acid=7&nUserInfoID={UserInfoID}' WHERE MenuName = 'View My Details' AND MenuURL = '/Employee/ViewDetails?acid=81&nUserInfoID={UserInfoID}'
END

/* Update table mst_MenuMaster */
IF EXISTS(SELECT * FROM mst_MenuMaster WHERE MenuName = 'View My Details' AND MenuURL = '/Employee/ViewDetails?acid=83&nUserInfoID={UserInfoID}')
BEGIN
    UPDATE mst_MenuMaster SET MenuURL = '/NonEmployeeInsider/Create?acid=7&nUserInfoID={UserInfoID}' WHERE MenuName = 'View My Details' AND MenuURL = '/Employee/ViewDetails?acid=83&nUserInfoID={UserInfoID}'
END

--Add new reourcekey for "Do You Have Demat Account"
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50774)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50774,'usr_lbl_50774','Do You Have Demat Account','en-US',103002,104002,122016,'Do You Have Demat Account',1,GETDATE())
END

--Add colom in usr_UserInfo with name Status 

IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'usr_UserInfo' AND SYSCOL.NAME = 'DoYouHaveDMATEAccountFlag')
BEGIN
	ALTER TABLE usr_UserInfo ADD DoYouHaveDMATEAccountFlag INT NOT NULL DEFAULT(1)
END

--Add Add new resourcekey for "Confirm Details"
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50775)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50775,'usr_btn_50775','Confirm Details','en-US',103002,104004,122004,'Confirm Details',1,GETDATE())
END


--Add Add new resourcekey for Error msg is "Please select the confirmation checkbox to submit your Personal details."
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50776)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50776,'usr_msg_50776','Please select the confirmation checkbox to submit your Personal details.','en-US',103002,104004,122004,'Please select the confirmation checkbox to submit your Personal details.',1,GETDATE())
END

--Add Add new resourcekey for Comfirmation Check msg 
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50781)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50781,'usr_msg_50781','I here by declare that the information provided is correct to the best of my knowledge.','en-US',103002,104004,122004,'I here by declare that the information provided is correct to the best of my knowledge.',1,GETDATE())
END


--MassUpload data insert

IF NOT EXISTS(SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5703)
BEGIN
	INSERT INTO com_MassUploadProcedureParameterDetails
            ([MassUploadProcedureParameterDetailsId],[MassUploadSheetId],[MassUploadProcedureParameterNumber],[MassUploadDataTableId],[MassUploadExcelDataTableColumnMappingId],[MassUploadProcedureParameterValue])
	VALUES  (5703,4,48,4,NULL,NULL)
END

IF NOT EXISTS(SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5704)
BEGIN
	INSERT INTO com_MassUploadProcedureParameterDetails
            ([MassUploadProcedureParameterDetailsId],[MassUploadSheetId],[MassUploadProcedureParameterNumber],[MassUploadDataTableId],[MassUploadExcelDataTableColumnMappingId],[MassUploadProcedureParameterValue])
	VALUES  (5704,4,49,4,NULL,NULL)
END

IF NOT EXISTS(SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5705)
BEGIN
	INSERT INTO com_MassUploadProcedureParameterDetails
            ([MassUploadProcedureParameterDetailsId],[MassUploadSheetId],[MassUploadProcedureParameterNumber],[MassUploadDataTableId],[MassUploadExcelDataTableColumnMappingId],[MassUploadProcedureParameterValue])
	VALUES  (5705,4,50,4,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51000)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51000,'usr_btn_51000','You do not have rights to add Demat, please processed','en-US',103002,104004,122007,'You do not have rights to add Demat, please processed',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51001)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51001,'usr_btn_51001','You do not have rights to add relatives Details, please Proceed','en-US',103002,104004,122015,'You do not have rights to add relatives Details, please Proceed',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52088)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52088,'usr_lbl_52088','“Material financial relationship” is a relationship in which one person is a recipient of any kind of payment such as by way of a loan or gift during the immediately preceding twelve months, equivalent to at least 25% of such payer’s annual income but shall exclude relationships in which the payment is based on arm’s length transactions.','en-US',103002,104002,122016,'“Material financial relationship” is a relationship in which one person is a recipient of any kind of payment such as by way of a loan or gift during the immediately preceding twelve months, equivalent to at least 25% of such payer’s annual income but shall exclude relationships in which the payment is based on arm’s length transactions.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52094)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52094,'usr_lbl_52094','Immediate Relative means a spouse of a person, and includes parent, sibling, and child of such person or of the spouse, any of whom is either dependent financially on such person, or consults such person in taking decisions relating to trading in securities.','en-US',103002,104002,122016,'Immediate Relative means a spouse of a person, and includes parent, sibling, and child of such person or of the spouse, any of whom is either dependent financially on such person, or consults such person in taking decisions relating to trading in securities.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52095)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52095,'usr_lbl_52095','PLEASE NOTE:','en-US',103002,104002,122016,'PLEASE NOTE:',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52089)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52089, 'usr_msg_52089', 'Special characters(*,<,>) are not allowed.', 'Special characters(*,<,>) are not allowed.', 'en-Us', 103002, 104001, 122004, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52090)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52090, 'usr_lbl_52090', 'TMID', 'TMID', 'en-Us', 103002, 104002, 122073, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52091)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52091, 'usr_lbl_52091', 'Description', 'Description', 'en-Us', 103002, 104002, 122073, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52092)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52092, 'usr_lbl_52092', 'TMID', 'TMID', 'en-Us', 103002, 104002, 122072, 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52093)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES(52093, 'usr_lbl_52093', 'Description', 'Description', 'en-Us', 103002, 104002, 122072, 1 , GETDATE())
END

  --INSERT SCRIPT FOR usr_Activity	
 DECLARE @ActivityID BIGINT		
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Identification Type')
	BEGIN
		SELECT @ActivityID = 274 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Identification Type','103002',NULL,'Edit Permissions for Identification Type',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='274')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(274,'usr_lbl_54067','Identification Type')
END

--INSERT SCRIPT FOR usr_Activity	
BEGIN
	-- DECLARE @ActivityID BIGINT		

	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Identification Type')
	BEGIN
		SELECT @ActivityID = 275 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Identification Type','103002',NULL,'Mandatory Field - Identification Type',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='275')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(275,'usr_lbl_54067','Identification Type')
	END




--INSERT SCRIPT FOR usr_Activity	
BEGIN
	-- DECLARE @ActivityID BIGINT		

	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Relative-Identification Type')
	BEGIN
		SELECT @ActivityID = 276 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Relative-Identification Type','103002',NULL,'Mandatory Field - Relative-Identification Type',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='276')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(276,'usr_lbl_54068','Identification Type')
	END
	
	

--INSERT SCRIPT FOR usr_Activity	
BEGIN
	-- DECLARE @ActivityID BIGINT		

	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Relative-Identification Number')
	BEGIN
		SELECT @ActivityID = 277 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Relative-Identification Number','103002',NULL,'Mandatory Field - Relative-Identification Number',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='277')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(277,'usr_lbl_54069','Identification Number')
	END
	
	
  --INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Relative Identification Type')
	BEGIN
		SELECT @ActivityID = 278 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Relative Identification Type','103002',NULL,'Edit Permissions for Identification Type',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='278')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(278,'usr_lbl_54068','Identification Type')
END


  --INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Relative Identification Number')
	BEGIN
		SELECT @ActivityID = 279 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Relative Identification Number','103002',NULL,'Edit Permissions for Relative-Identification Number',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='279')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(279,'usr_lbl_54069','Identification Number')
END

create table #usr_Activity(ID int identity,RoleID int)
insert into #usr_Activity
select RoleID from usr_RoleMaster
Declare @nCount int =0
Declare @nTotCount int=0

select @nTotCount=COUNT(RoleID)  from #usr_Activity

while @nCount<@nTotCount
begin
declare @nRoleId int=0
select @nRoleId =RoleID from #usr_Activity where ID=@nCount+1


	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='274' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(274,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='275' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(275,@nRoleId,1,GETDATE(),1,GETDATE())
	END
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='276' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(276,@nRoleId,1,GETDATE(),1,GETDATE())
	END
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='277' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(277,@nRoleId,1,GETDATE(),1,GETDATE())
	END
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='278' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(278,@nRoleId,1,GETDATE(),1,GETDATE())
	END
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='279' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(279,@nRoleId,1,GETDATE(),1,GETDATE())
	END
set @nCount=@nCount+1
END

drop table #usr_Activity

-- Add Error msg on DMATE popup (Edit mode) for pending transactions (PNT,PCL). 
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51026)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51026,'usr_msg_51026','Please take action on your pending transactions then try to edit.','en-US',103001,104001,122008,'Please take action on your pending transactions then try to edit.',1,GETDATE())
END

--(01-01-2020)
-- Error msg on Relative page when we delete relative , first we need to delete relative Demat.

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51028)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51028,'usr_msg_51028','To delete the Relative, delete his demat details first','en-US',103002,104001,122004,'To delete the Relative, delete his demat details first',1,GETDATE())
END

--03-01-2020
--upto 20 digit number accepte.
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tra_TransactionDetails' AND COLUMN_NAME = 'PerOfSharesPreTransaction')
BEGIN	
ALTER TABLE tra_TransactionDetails ALTER COLUMN PerOfSharesPreTransaction decimal(20,2); 
ALTER TABLE tra_TransactionDetails ALTER COLUMN PerOfSharesPostTransaction decimal(20,2);
END

--06-01-2020
-- Add resource key for Add security type button on transaction details page
--Its for own security
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51029)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51029,'tra_btn_51029','Add','en-US',103008,104004,122066,'Add',1,GETDATE())
END

--Its for other security
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51030)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51030,'tra_btn_51030','Add','en-US',103303,104004,122107,'Add',1,GETDATE())
END