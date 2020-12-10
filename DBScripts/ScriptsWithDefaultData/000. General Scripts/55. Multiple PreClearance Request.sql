-- ======================================================================================================
-- Author      : Priyanka Bhangale												=
-- CREATED DATE: 04-SEP-2017                                                 							=
-- Description : SCRIPTS FOR MULTIPLE PRECLEARANCE REQUEST FUNCTIONALITY     												=
-- ======================================================================================================
/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 507005)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (507005,'Multiple Pre-Clearance- Grid',185,'Multiple Pre-Clearance- Grid',1,1,1,NULL,NULL,1,GETDATE())
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50576)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50576,'rl_grd_50576','Company Name','en-US',507005,104003,185006,'Company Name',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50577)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50577,'rl_grd_50577','Traded For','en-US',507005,104003,185006,'Traded For',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50578)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50578,'rl_grd_50578','Name','en-US',507005,104003,185006,'Name',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50579)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50579,'rl_grd_50579','Transaction Type','en-US',507005,104003,185006,'Transaction Type',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50580)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50580,'rl_grd_50580','Security Type','en-US',507005,104003,185006,'Security Type',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50581)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50581,'rl_grd_50581','Quantity','en-US',507005,104003,185006,'Quantity',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50582)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50582,'rl_grd_50582','Value','en-US',507005,104003,185006,'Value',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50583)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50583,'rl_grd_50583','Mode Of Acquisition','en-US',507005,104003,185006,'Mode Of Acquisition',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50584)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50584,'rl_grd_50584','Demat Account No.','en-US',507005,104003,185006,'Demat Account No.',1,GETDATE())
END



/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rl_grd_50576')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (507005,'rl_grd_50576',1,1,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rl_grd_50577')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (507005,'rl_grd_50577',1,2,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rl_grd_50578')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (507005,'rl_grd_50578',1,3,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rl_grd_50579')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (507005,'rl_grd_50579',1,4,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rl_grd_50580')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (507005,'rl_grd_50580',1,5,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rl_grd_50581')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (507005,'rl_grd_50581',1,6,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rl_grd_50582')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (507005,'rl_grd_50582',1,7,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rl_grd_50583')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (507005,'rl_grd_50583',1,8,0,155001,NULL,NULL)
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rl_grd_50584')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (507005,'rl_grd_50584',1,9,0,155001,NULL,NULL)
END


/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_11073' and GridTypeCodeId=507005)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (507005,'usr_grd_11073',1,10,26,155001,NULL,NULL)
END

/*INSERT SCRIPT FOR usr_Activity*/	
BEGIN
	DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Disclosure Details for Insider' and UPPER(ActivityName)='Edit')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Disclosure Details for Insider','Edit','103008',NULL,'Disclosure Details for Insider -Edit Preclearance Request - NonImplementation Company',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Disclosure Details for Insider' and UPPER(ActivityName)='Delete')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Disclosure Details for Insider','Delete','103008',NULL,'Disclosure Details for Insider -Delete Preclearance Request - NonImplementation Company',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Disclosure Details for Insider' and UPPER(ActivityName)='DeleteAll')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Disclosure Details for Insider','DeleteAll','103008',NULL,'Disclosure Details for Insider -Delete All Preclearance Request - NonImplementation Company',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Disclosure Details for Insider' and UPPER(ActivityName)='SaveAll')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Disclosure Details for Insider','SaveAll','103008',NULL,'Disclosure Details for Insider -Save All Preclearance Request - NonImplementation Company',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Disclosure Details for Insider' and UPPER(ActivityName)='Cancel')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Disclosure Details for Insider','Cancel','103008',NULL,'Disclosure Details for Insider -Cancel Preclearance Request - NonImplementation Company',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'Edit') AND (UPPER(ControllerName) = 'PreclearanceRequestNonImplCompany'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(225,'PreclearanceRequestNonImplCompany','Edit',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'Delete') AND (UPPER(ControllerName) = 'PreclearanceRequestNonImplCompany'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(226,'PreclearanceRequestNonImplCompany','Delete',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'DeleteAll') AND (UPPER(ControllerName) = 'PreclearanceRequestNonImplCompany'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(227,'PreclearanceRequestNonImplCompany','DeleteAll',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'SaveAll') AND (UPPER(ControllerName) = 'PreclearanceRequestNonImplCompany'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(228,'PreclearanceRequestNonImplCompany','SaveAll',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'Cancel') AND (UPPER(ControllerName) = 'PreclearanceRequestNonImplCompany'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(229,'PreclearanceRequestNonImplCompany','Cancel',NULL,1,getdate(),1,getdate())		
END

--INSERT SCRIPT FOR usr_RoleActivity
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='225' AND RoleID ='2')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(225,2,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='225' AND RoleID ='4')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(225,4,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='225' AND RoleID ='5')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(225,5,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='226' AND RoleID ='2')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(226,2,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='226' AND RoleID ='4')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(226,4,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='226' AND RoleID ='5')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(226,5,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='227' AND RoleID ='2')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(227,2,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='227' AND RoleID ='4')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(227,4,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='227' AND RoleID ='5')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(227,5,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='228' AND RoleID ='2')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(228,2,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='228' AND RoleID ='4')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(228,4,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='228' AND RoleID ='5')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(228,5,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='229' AND RoleID ='2')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(229,2,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='229' AND RoleID ='4')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(229,4,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='229' AND RoleID ='5')
BEGIN			
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(229,5,1,GETDATE(),1,GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50585)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50585,'rl_btn_50585','Request Trade','en-US',103301,104004,122076,'Request Trade',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50586)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50586,'rl_btn_50586','Delete All','en-US',103301,104004,122076,'Delete All',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50587)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50587,'rl_lbl_50587','Preclearance Details','en-US',103301,104002,122076,'Preclearance Details',1,GETDATE())
END

--Script to update old maptoid with sequence no in tra_GeneratedFormDetails
UPDATE G SET G.MapToId= P.DisplaySequenceNo FROM tra_GeneratedFormDetails G
INNER JOIN tra_PreclearanceRequest_NonImplementationCompany P
ON G.MapToId = P.PreclearanceRequestId 
WHERE G.MapToTypeCodeId=132015

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50588)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50588,'rl_msg_50588','Form E Template is not available.','en-US',507005,104001,185006,'Form E Template is not available.',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50589)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50589,'rl_msg_50589','Error occurred while fetching FORM E Template','en-US',507005,104001,185006,'Error occurred while fetching FORM E Template',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50590)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50590,'rl_msg_50590','Form E Template is not available. Please contact Administrator.','en-US',507005,104001,185006,'Form E Template is not available. Please contact Administrator.',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50592)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50592,'rl_msg_50592','Are you sure want to delete the Pre-Clearance request?','en-US',507005,104001,185006,'Form E Template is not available. Please contact Administrator.',1,GETDATE())
END

--Script to update old maptoid with sequence no in eve_EventLog
UPDATE E SET E.MapToId= P.DisplaySequenceNo FROM eve_EventLog E
INNER JOIN tra_PreclearanceRequest_NonImplementationCompany P
ON E.MapToId = P.PreclearanceRequestId 
WHERE E.MapToTypeCodeId=132015