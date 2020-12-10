/*-- ======================================================================================================
-- Author      : Priyanka Bhangale
-- CREATED DATE: 17-July-2019
-- Description : Script for Period End Disclosure - other securities Functionality.

Modified By			Modified On			Discription

Samadhan			21-Aug-2019          Script added for Form G placeholder,template
--
-- ======================================================================================================
*/
--INSERT SCRIPT FOR usr_Activity	
IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Disclosure Details for Insider- Other Securities' and UPPER(ActivityName)='Period End Disclosure - other securities' and ActivityID = 335)
BEGIN
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(335,'Disclosure Details for Insider- Other Securities','Period End Disclosure - other securities','103303',NULL,'Period End Disclosure - other securities',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (335,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (335,'101004')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (335,'101006')
END

IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Disclosure Details for CO- Other Securities' and UPPER(ActivityName)='Period End Disclosure - other securities' and ActivityID = 336)
BEGIN
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(336,'Disclosure Details for CO- Other Securities','Period End Disclosure - other securities','103303',NULL,'Period End Disclosure - other securities',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (336,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (336,'101002')
END

--INSERT SCRIPT FOR mst_MenuMaster for insider
IF NOT EXISTS (SELECT MenuID FROM mst_MenuMaster WHERE MenuID = 69)
BEGIN
	INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,
			ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES
	(
		69,'Period End Disclosures- Other Securities','Period End Disclosure- Other Securities',
		'PeriodEndDisclosure_OS/PeriodStatusOS?acid=335',2906,24,102001,NULL,NULL,335,1,GETDATE(),1,GETDATE()  
	)		
END

--INSERT SCRIPT FOR mst_MenuMaster for CO
IF NOT EXISTS (SELECT MenuID FROM mst_MenuMaster WHERE MenuID = 70)
BEGIN
	INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,
			ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES
	(
		70,'Period End Disclosures- Other Securities','Period End Disclosure- Other Securities',
		'PeriodEndDisclosure_OS/UserStatusOS?acid=336',2605,22,102001,NULL,NULL,336,1,GETDATE(),1,GETDATE()  
	)		

	UPDATE mst_MenuMaster SET DisplayOrder = 2606 WHERE MenuID = 58
END
----------------------------------------------------------------------
--INSERT script for usr_RoleActivity
CREATE TABLE #RolesByUserType(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId in (101003,101004,101006)
DECLARE @nCount INT = 1
DECLARE @nTotCount INT = 0
DECLARE @nRoleID INT = 0
SELECT @nTotCount = COUNT(RoleID) FROM #RolesByUserType

WHILE @nCount <= @nTotCount
BEGIN
	SET @nRoleID = (SELECT RoleID FROM #RolesByUserType WHERE ID = @nCount)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='335' AND RoleID = @nRoleID)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(335,@nRoleID,1,GETDATE(),1,GETDATE())
	END

	SET @nCount = @nCount + 1
	SET @nRoleID = 0
END
DROP TABLE #RolesByUserType

CREATE TABLE #RolesByUserTypeAdmin(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserTypeAdmin
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId in (101001,101002)

DECLARE @nCount1 INT = 1
DECLARE @nTotCount1 INT = 0
DECLARE @nRoleID1 INT = 0
SELECT @nTotCount1 = COUNT(RoleID) FROM #RolesByUserTypeAdmin

WHILE @nCount1 <= @nTotCount1
BEGIN
	SET @nRoleID1 = (SELECT RoleID FROM #RolesByUserTypeAdmin WHERE ID = @nCount1)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='336' AND RoleID = @nRoleID1)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(336,@nRoleID1,1,GETDATE(),1,GETDATE())
	END

	SET @nCount1 = @nCount1 + 1
	SET @nRoleID1 = 0
END
DROP TABLE #RolesByUserTypeAdmin
---------------------------------------------------------------------------

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'PeriodStatusOS') AND (UPPER(ControllerName) = 'PeriodEndDisclosure_OS'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(335,'PeriodEndDisclosure_OS','PeriodStatusOS',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'UserStatusOS') AND (UPPER(ControllerName) = 'PeriodEndDisclosure_OS'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(336,'PeriodEndDisclosure_OS','UserStatusOS',NULL,1,getdate(),1,getdate())		
END
---------------------------------------------------------------------------
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122111)
BEGIN
	INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES(122111,NULL,'Transaction Details List - Period End Disclosure for CO',NULL,122,'Transaction Details List - Period End Disclosure for CO',1,1,GETDATE(),121)
END
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122112)
BEGIN
	INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES(122112,NULL,'Transaction Details List(Other Security) - Period End Disclosure for Insider',NULL,122,'Transaction Details List(Other Security) - Period End Disclosure for Insider',1,1,GETDATE(),120)
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53117)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53117,'dis_ttl_53117','Period End Disclosure- Other Securities','en-US',103303,104006,122112,'Period End Disclosure- Other Securities',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53118)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53118,'dis_ttl_53118','Period End Disclosure- Other Securities','en-US',103303,104006,122111,'Period End Disclosure- Other Securities',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53119)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53119,'dis_lbl_53119','Employee Id','en-US',103303,104002,122112,'Employee Id',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53120)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53120,'dis_lbl_53120','Name','en-US',103303,104002,122112,'Name',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53121)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53121,'dis_lbl_53121','Financial Year','en-US',103303,104002,122112,'Financial Year',1,GETDATE())
END
------------------------Grid Start------------------------------
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114126)
BEGIN
	INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES (114126,NULL,'Period End (Other Securities) - Period Status',NULL,114,'Period End (Other Securities) - Period Status',1,1,GETDATE(),123)
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53122)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53122,'dis_grd_53122','Submission Period','en-US',103303,104003,122112,'Submission Period',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53123)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53123,'dis_grd_53123','Submission required till Date','en-US',103303,104003,122112,'Submission required till Date',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53124)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53124,'dis_grd_53124','Submission Details','en-US',103303,104003,122112,'Submission Details',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53125)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53125,'dis_grd_53125','Submission: Softcopy','en-US',103303,104003,122112,'Submission: Softcopy',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53126)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53126,'dis_grd_53126','Submission: Hardcopy','en-US',103303,104003,122112,'Submission: Hardcopy',1,GETDATE())
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114126 AND ResourceKey = 'dis_grd_53122')--Submission Period
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114126, 'dis_grd_53122', 1, 1, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114126 AND ResourceKey = 'dis_grd_53123')--Submission required till Date
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114126, 'dis_grd_53123', 1, 2, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114126 AND ResourceKey = 'dis_grd_53124')--Submission Details
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114126, 'dis_grd_53124', 1, 3, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114126 AND ResourceKey = 'dis_grd_53125')--Submission: Softcopy
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114126, 'dis_grd_53125', 1, 4, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114126 AND ResourceKey = 'dis_grd_53126')--Submission: Hardcopy
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114126, 'dis_grd_53126', 1, 5, 0, 155001, NULL ,NULL)
END
--------------------End Grid------------------------------
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53127)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53127,'dis_btn_53127','Add Missing Transaction','en-US',103303,104004,122112,'Add Missing Transaction',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53128)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53128,'dis_btn_53128','Confirm','en-US',103303,104004,122112,'Confirm',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53129)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53129,'dis_lbl_53129','Period','en-US',103303,104002,122112,'Period',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53130)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53130,'dis_btn_53130','Download Details','en-US',103303,104004,122112,'Download Details',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53131)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53131,'dis_ttl_53131','Click on Download Details to view Demat wise holdings for each security and company','en-US',103303,104005,122112,'Click on Download Details to view Demat wise holdings for each security and company',1,GETDATE())
END 
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53132)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53132,'dis_msg_53132','Error occurred while fetching Period End Disclosure summary companywise.','en-US',103303,104001,122112,'Error occurred while fetching Period End Disclosure summary companywise.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53133)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53133,'dis_msg_53133','Error occurred while fetching Period End Disclosure Transaction Details.','en-US',103303,104001,122112,'Error occurred while fetching Period End Disclosure Transaction Details.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53134)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53134,'dis_msg_53134','Error occurred while generating Period End Disclosure Transaction Details From G.','en-US',103303,104001,122112,'Error occurred while generating Period End Disclosure Transaction Details From G.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53135)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53135,'dis_msg_53135','Error occurred while generating Period End Disclosure From G letter content.','en-US',103303,104001,122112,'Error occurred while generating Period End Disclosure From G letter content.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54160)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54160,'dis_grd_54160','Insider Name','en-US',103303,104003,122112,'Insider Name',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54161)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54161,'dis_grd_54161','Relation','en-US',103303,104003,122112,'Relation',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54162)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54162,'dis_grd_54162','Security Type','en-US',103303,104003,122112,'Security Type',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54163)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54163,'dis_grd_54163','Holdings at beginning of the period','en-US',103303,104003,122112,'Holdings at beginning of the period',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54164)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54164,'dis_grd_54164','Bought during the period','en-US',103303,104003,122112,'Bought during the period',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54165)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54165,'dis_grd_54165','Sold during the period','en-US',103303,104003,122112,'Sold during the period',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54166)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54166,'dis_grd_54166','Holdings at end of the period','en-US',103303,104003,122112,'Holdings at end of the period',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54167)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54167,'dis_msg_54167','Are you sure you want to confirm period end holdings for your self and your relatives. You will not be able to update transactions during this period after clicking on the submit button','en-US',103303,104001,122112,'Are you sure you want to confirm period end holdings for your self and your relatives. You will not be able to update transactions during this period after clicking on the submit button',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54168)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54168,'dis_btn_54168','Yes I Confirm','en-US',103303,104004,122112,'Yes I Confirm',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54169)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54169,'dis_btn_54169','No, Go back','en-US',103303,104004,122112,'No, Go back',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54170)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54170,'dis_msg_54170','Error occurred while fetching Period End Disclosure summary for other securities','en-US',103303,104001,122112,'Error occurred while fetching Period End Disclosure summary for other securities',1,GETDATE())
END
------------------------Period End (Other Securities) - Period Summary Gird start-------------------
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114127)
BEGIN
	INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES (114127,NULL,'Period End (Other Securities) - Period Summary',NULL,114,'Period End (Other Securities) - Period Summary',1,1,GETDATE(),124)
END


IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114127 AND ResourceKey = 'dis_grd_54160')--Insider Name
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114127, 'dis_grd_54160', 1, 1, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114127 AND ResourceKey = 'dis_grd_54161')--Relation
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114127, 'dis_grd_54161', 1, 2, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114127 AND ResourceKey = 'dis_grd_54162')--Security Type
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114127, 'dis_grd_54162', 1, 3, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114127 AND ResourceKey = 'dis_grd_54163')--Holdings at beginning of the period
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114127, 'dis_grd_54163', 1, 4, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114127 AND ResourceKey = 'dis_grd_54164')--Bought during the period
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114127, 'dis_grd_54164', 1, 5, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114127 AND ResourceKey = 'dis_grd_54165')--Sold during the period
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114127, 'dis_grd_54165', 1, 6, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114127 AND ResourceKey = 'dis_grd_54166')--Holdings at end of the period
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114127, 'dis_grd_54166', 1, 7, 0, 155001, NULL ,NULL)
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114127 AND ResourceKey = 'usr_grd_11073')--Holdings at end of the period
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114127, 'usr_grd_11073', 1, 8, 0, 155001, NULL ,NULL)
END

------------------------Period End (Other Securities) - Period Summary Gird END-------------------
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53136)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53136,'dis_msg_53136','You do not have any holdings/ transactions to download. Click on Confirm to proceed with your period end disclosures. Click on "Add Missing Transaction" to update details of missing transactions for the requisite period','en-US',103303,104001,122112,'You do not have any holdings/ transactions to download. Click on Confirm to proceed with your period end disclosures. Click on "Add Missing Transaction" to update details of missing transactions for the requisite period',1,GETDATE())
END
-------------------------Validation Messesages------------------------------------
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53137)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53137,'dis_msg_53137','Error occurred while validating transaction master entry.','en-US',103303,104001,122112,'Error occurred while validating transaction master entry.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53138)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53138,'dis_msg_53138','Cannot save details for continuous disclosure, since period end disclosure for the future period is entered.','en-US',103303,104001,122112,'Cannot save details for continuous disclosure, since period end disclosure for the future period is entered.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53139)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53139,'dis_msg_53139','Cannot submit Continuous disclosure, since period end disclosure for the past period is not submitted.','en-US',103303,104001,122112,'Cannot submit Continuous disclosure, since period end disclosure for the past period is not submitted.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53140)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53140,'dis_msg_53140','Cannot submit Period End disclosure, since period end disclosure for the past period is not submitted.','en-US',103303,104001,122112,'Cannot submit Period End disclosure, since period end disclosure for the past period is not submitted.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53141)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53141,'dis_msg_53141','Cannot submit Period End disclosure, since pre-clearances are open.','en-US',103303,104001,122112,'Cannot submit Period End disclosure, since pre-clearances are open.',1,GETDATE())
END
--Insert into com_GlobalRedirectionControllerActionPair
IF NOT EXISTS(select ID from com_GlobalRedirectionControllerActionPair WHERE ID = 11)
BEGIN
	INSERT INTO com_GlobalRedirectionControllerActionPair VALUES(11,'PeriodEndDisclosure_OSPeriodStatusOS',1,GETDATE())
END

--Novit
-- Grid for list for CO
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114128)
BEGIN
	INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES (114128,NULL,'Period End (Other Securities) - List For CO',NULL,114,'Period End (Other Securities) - List For CO',1,1,GETDATE(),125)
END

-- Grid coloum PE for CO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51014)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51014,'dis_grd_51014','Employee Id','en-US',103303,104003,122111,'Employee Id',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51015)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51015,'dis_grd_51015','Name','en-US',103303,104003,122111,'Name',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51016)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51016,'dis_grd_51016','PAN','en-US',103303,104003,122111,'PAN',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51017)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51017,'dis_grd_51017','Employee Status','en-US',103303,104003,122111,'Employee Status',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51018)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51018,'dis_grd_51018','Designation','en-US',103303,104003,122111,'Designation',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51019)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51019,'dis_grd_51019','Submission required till Date','en-US',103303,104003,122111,'Submission required till Date',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51020)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51020,'dis_grd_51020','Submission Details','en-US',103303,104003,122111,'Submission Details',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51021)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51021,'dis_grd_51021','Submission Details: Softcopy','en-US',103303,104003,122111,'Submission Details: Softcopy',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51022)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51022,'dis_grd_51022','Submission Details:Hardcopy','en-US',103303,104003,122111,'Submission Details:Hardcopy',1,GETDATE())
END
--IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51023)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (51023,'dis_grd_51023','Submission to Stock Exchange','en-US',103303,104003,122111,'Submission to Stock Exchange',1,GETDATE())
--END
--IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51024)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (51024,'dis_grd_51024','History','en-US',103303,104003,122111,'History',1,GETDATE())
--END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51025)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51025,'dis_grd_51025','Category','en-US',103303,104003,122111,'Category',1,GETDATE())
END
------------------------------------------------------------------------------------------------------

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51014')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114128, 'dis_grd_51014', 1, 1, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51015')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114128, 'dis_grd_51015', 1, 2, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51016')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114128, 'dis_grd_51016', 1, 3, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51017')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114128, 'dis_grd_51017', 1, 4, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51018')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114128, 'dis_grd_51018', 1, 5, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51019')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114128, 'dis_grd_51019', 1, 6, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51020')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114128, 'dis_grd_51020', 1, 7, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51021')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114128, 'dis_grd_51021', 1, 8, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51022')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114128, 'dis_grd_51022', 1, 9, 0, 155001, NULL ,NULL)
END
--IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51023')
--BEGIN
--	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
--	VALUES (114128, 'dis_grd_51023', 1, 10, 0, 155001, NULL ,NULL)
--END
--IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51024')
--BEGIN
--	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
--	VALUES (114128, 'dis_grd_51024', 1, 11, 0, 155001, NULL ,NULL)
--END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114128 AND ResourceKey = 'dis_grd_51025')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114128, 'dis_grd_51025', 1, 12, 0, 155001, NULL ,NULL)
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53142)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53142,'dis_msg_53142','Please submit previous continuous disclosure transaction of other securities','en-US',103303,104001,122112,'Please submit previous continuous disclosure transaction of other securities',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53143)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53143,'dis_msg_53143','You can''t create preclearance request, Since previous period end of $1 is not submitted, please contact you Complaince Officer.','en-US',103303,104001,122112,'You can''t create preclearance request, Since previous period end of $1 is not submitted, please contact you Complaince Officer.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53144)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53144,'dis_msg_53144','You can''t create preclearance request, Please submit your previous period end disclosures of $1.','en-US',103303,104001,122112,'You can''t create preclearance request, Please submit your previous period end disclosures of $1.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51027)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51027,'dis_msg_51027','Soft copy submitted successfully. Now you can take a Printout of the Form G.','en-US',103303,104001,122111,'Soft copy submitted successfully. Now you can take a Printout of the Form G.',1,GETDATE())
END
----com_Code entry for 'Period End Disclosures Form G Open--
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 156010)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 156010,	'Period End Form for Other Securities',156,'Period End Form for Other Securities',1,1,10,NULL,	166002,1,	getdate())
END


----com_Code entry for 'Period End Disclosures Form G Close--


--- com_PlaceholderMaster for Period End Disclosures Form G Open
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[PERIODEND_FREQUENCY]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[PERIODEND_FREQUENCY]',	'PERIOD END FREQUENCY'	,156010	,'PERIOD END FREQUENCY',	1,	1,	1	,GETDATE(),	1,GETDATE())
END

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[FROM_DATEOF_PERIODEND_DISCLOSURES]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[FROM_DATEOF_PERIODEND_DISCLOSURES]',	'PERIOD FROM DATE OF PERIOD END DISCLOSURES'	,156010	,'PERIOD FROM DATE OF PERIOD END DISCLOSURES',	1,	2,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[TO_DATEOF_PERIODEND_DISCLOSURES]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[TO_DATEOF_PERIODEND_DISCLOSURES]',	'PERIOD TO DATE OF PERIOD END DISCLOSURES'	,156010	,'PERIOD TO DATE OF PERIOD END DISCLOSURES',	1,	3,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[DATEOF_SUBMISSION]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[DATEOF_SUBMISSION]',	'DATE OF SUBMISSION'	,156010	,'DATE OF SUBMISSION',	1,	4,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[NAMEOF_COMPLIANCE_OFFICER]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[NAMEOF_COMPLIANCE_OFFICER]',	'NAME OF COMPLIANCE OFFICER'	,156010	,'NAME OF COMPLIANCE OFFICER',	1,	5,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[NAMEOF_IMPLEMENTING_COMPANY]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[NAMEOF_IMPLEMENTING_COMPANY]',	'NAME OF IMPLEMENTING COMPANY'	,156010	,'NAME OF IMPLEMENTING COMPANY',	1,	6,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[ISIN_NUMBER]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[ISIN_NUMBER]',	'ISIN NUMBER'	,156010	,'ISIN NUMBER',	1,	7,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[EMPLOYEE_NAME]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[EMPLOYEE_NAME]',	'EMPLOYEE NAME'	,156010	,'EMPLOYEE NAME',	1,	8,	1	,GETDATE(),	1,GETDATE())
END

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[EMPLOYEE_CODE]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[EMPLOYEE_CODE]',	'EMPLOYEE CODE'	,156010	,'EMPLOYEE CODE',	1,	9,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[DEPARTMENT]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[DEPARTMENT]',	'DEPARTMENT'	,156010	,'DEPARTMENT',	1,	10,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[DESIGNATION]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[DESIGNATION]',	'DESIGNATION'	,156010	,'DESIGNATION',	1,	11,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[NAME]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[NAME]',	'NAME'	,156010	,'NAME',	1,	12,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[PAN]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[PAN]',	'PAN'	,156010	,'PAN',	1,	13,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[CIN]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CIN]',	'CIN'	,156010	,'CIN',	1,	14,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[DIN]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[DIN]',	'DIN'	,156010	,'DIN',	1,	15,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[ADDRESS]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[ADDRESS]',	'ADDRESS'	,156010	,'ADDRESS',	1,	16,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[SUB_CATEGORYOF_PERSONS]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SUB_CATEGORYOF_PERSONS]',	'SUB CATEGORY OF PERSONS'	,156010	,'SUB CATEGORY OF PERSONS',	1,	17,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[DEMAT_ACCOUNT_NUMBER]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[DEMAT_ACCOUNT_NUMBER]',	'DEMAT ACCOUNT NUMBER'	,156010	,'DEMAT ACCOUNT NUMBER',	1,	18,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[SECURITY_TYPE]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SECURITY_TYPE]',	'SECURITY TYPE'	,156010	,'SECURITY TYPE',	1,	19,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[NAMEOF_TRADING_COMPANY]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[NAMEOF_TRADING_COMPANY]',	'NAME OF TRADING COMPANY'	,156010	,'NAME OF TRADING COMPANY',	1,	20,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[HOLDINGON_FROM_DATE]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[HOLDINGON_FROM_DATE]',	'HOLDING ON FROM DATE'	,156010	,'HOLDING ON FROM DATE',	1,	21,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[BOUGHT_DURING_PERIOD]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[BOUGHT_DURING_PERIOD]',	'BOUGHT DURING PERIOD'	,156010	,'BOUGHT DURING PERIOD',	1,	22,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[SOLD_DURING_PERIOD]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SOLD_DURING_PERIOD]',	'SOLD DURING PERIOD'	,156010	,'SOLD DURING PERIOD',	1,	23,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[HOLDINGON_TO_DATE]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[HOLDINGON_TO_DATE]',	'HOLDINGON TO DATE'	,156010	,'HOLDINGON TO DATE',	1,	24,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[SECURITIES_PLEDGED_DURINGTHE_PERIOD]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SECURITIES_PLEDGED_DURINGTHE_PERIOD]',	'SECURITIES PLEDGED DURING THE PERIOD'	,156010	,'SECURITIES PLEDGED DURING THE PERIOD',	1,	25,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[SECURITIES_UNPLEDGED_DURINGTHE_PERIOD]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SECURITIES_UNPLEDGED_DURINGTHE_PERIOD]',	'SECURITIES UNPLEDGED DURING THE PERIOD'	,156010	,'SECURITIES UNPLEDGED DURING THE PERIOD',	1,	26,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 AND PlaceholderTag='[SECURITIES_PLEDGED_AT_THE_END_OFTHE_PERIOD]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SECURITIES_PLEDGED_AT_THE_END_OFTHE_PERIOD]',	'SECURITIES PLEDGED AT THE END OF THE PERIOD'	,156010	,'SECURITIES PLEDGED AT THE END OF THE PERIOD',	1,	27,	1	,GETDATE(),	1,GETDATE())
END





--- com_PlaceholderMaster for Period End Disclosures Form G Close


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54171)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54171,'dis_msg_54171','Form G for OS not generated.','en-US',103303,104001,122112,'Form G for OS not generated.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54172)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54172,'dis_msg_54172','Error occurred while generating form G for other securities details.','en-US',103303,104001,122112,'Error occurred while generating form G for other securities details.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54173)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54173,'dis_lbl_54173','Period End Disclosure from for OS','en-US',103303,104002,122112,'Period End Disclosure from for OS',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54174)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54174,'dis_msg_54174','Configurable text from resource master.','en-US',103303,104001,122112,'Configurable text from resource master.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54175)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54175,'dis_msg_54175','No transaction during the selected period','en-US',103303,104001,122112,'No transaction during the selected period',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54176)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54176,'dis_msg_54176','You do not have any holdings/ transactions to download. You have already confirmed your period end disclosures.','en-US',103303,104001,122112,'You do not have any holdings/ transactions to download. You have already confirmed your period end disclosures.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53145)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53145,'dis_msg_53145','Initial Disclosure of relative is pending','en-US',103303,104001,122112,'Initial Disclosure of relative is pending',1,GETDATE())
END


