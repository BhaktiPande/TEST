-- ======================================================================================================
-- Author      : Priyanka Bhangale
-- CREATED DATE: 07-Feb-2019
-- Description : Script for Preclearance Request - other securities Functionality.
-- ======================================================================================================

--INSERT SCRIPT Add Resource Module
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 103303)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(103303, NULL, 'Transaction Data for Other Securities', NULL, 103, 'Resource Module - Transaction Data for Other Securities', 1, 1, GETDATE(), 303)
END

--INSERT SCRIPT FOR usr_Activity	
IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Disclosure Details for Insider- Other Securities' and UPPER(ActivityName)='Preclearance Request - other securities' and ActivityID = 239)
BEGIN
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(239,'Disclosure Details for Insider- Other Securities','Preclearance Request - other securities','103303',NULL,'Preclearance Request - other securities',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (239,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (239,'101004')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (239,'101006')
END

IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Disclosure Details for CO- Other Securities' and UPPER(ActivityName)='Preclearance Request List- other securities' and ActivityID = 240)
BEGIN
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(240,'Disclosure Details for CO- Other Securities','Preclearance Request List- other securities','103303',NULL,'Preclearance Request List- other securities',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (240,'101002')
END

--INSERT SCRIPT FOR mst_MenuMaster for insider
IF NOT EXISTS (SELECT MenuID FROM mst_MenuMaster WHERE MenuID = 62)
BEGIN
	INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,
			ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES
	(
		62,'Preclearances/Continuous Disclosures- Other Securities','Preclearances/Continuous Disclosures- Other Securities',
		'PreclearanceRequestNonImplCompany/IndexOS?acid=239',2904,24,102001,NULL,NULL,239,1,GETDATE(),1,GETDATE()  
	)	
	--changed display order of period end menu fro insider user
	UPDATE mst_MenuMaster SET DisplayOrder=2905 where MenuID=28		
END

--INSERT SCRIPT FOR mst_MenuMaster for CO
IF NOT EXISTS (SELECT MenuID FROM mst_MenuMaster WHERE MenuID = 63)
BEGIN
	INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,
			ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES
	(
		63,'Preclearances/Continuous Disclosures- Other Securities','Preclearances/Continuous Disclosures- Other Securities',
		'PreclearanceRequestNonImplCompany/CoIndex_OS?acid=240',2603,22,102001,NULL,NULL,240,1,GETDATE(),1,GETDATE()  
	)	
	--changed display order of period end menu fro CO user
	UPDATE mst_MenuMaster SET DisplayOrder=2604 where MenuID=31		
END

----INSERT SCRIPT FOR usr_RoleActivity
--IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='239' AND RoleID ='2')
--BEGIN
--		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
--		VALUES(239,2,1,GETDATE(),1,GETDATE())
--END

--IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='239' AND RoleID ='4')
--BEGIN
--		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
--		VALUES(239,4,1,GETDATE(),1,GETDATE())
--END

--IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='239' AND RoleID ='5')
--BEGIN
--		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
--		VALUES(239,5,1,GETDATE(),1,GETDATE())
--END

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
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='239' AND RoleID = @nRoleID)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(239,@nRoleID,1,GETDATE(),1,GETDATE())
	END

	SET @nCount = @nCount + 1
	SET @nRoleID = 0
END
DROP TABLE #RolesByUserType


----INSERT SCRIPT FOR usr_RoleActivity
--IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='240' AND RoleID ='3')
--	BEGIN			
--		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
--		VALUES(240,3,1,GETDATE(),1,GETDATE())	
--	END

CREATE TABLE #RolesByUserType1(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType1
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId in (101002)
DECLARE @nCount1 INT = 1
DECLARE @nTotCount1 INT = 0
DECLARE @nRoleID1 INT = 0
SELECT @nTotCount1 = COUNT(RoleID) FROM #RolesByUserType1

WHILE @nCount1 <= @nTotCount1
BEGIN
	SET @nRoleID1 = (SELECT RoleID FROM #RolesByUserType1 WHERE ID = @nCount1)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='240' AND RoleID = @nRoleID1)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(240,@nRoleID1,1,GETDATE(),1,GETDATE())
	END

	SET @nCount1 = @nCount1 + 1
	SET @nRoleID1 = 0
END
DROP TABLE #RolesByUserType1


IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'INDEXOS') AND (UPPER(ControllerName) = 'PreclearanceRequestNonImplCompany'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(239,'PreclearanceRequestNonImplCompany','IndexOS',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'SAVEPRECLEARANCEREQUESTOS') AND (UPPER(ControllerName) = 'PRECLEARANCEREQUESTNONIMPLCOMPANY'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(239,'PreclearanceRequestNonImplCompany','SavePreclearanceRequestOS',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'SAVEALL_OS') AND (UPPER(ControllerName) = 'PRECLEARANCEREQUESTNONIMPLCOMPANY'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(239,'PreclearanceRequestNonImplCompany','SaveAll_OS',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'DELETEALL_OS') AND (UPPER(ControllerName) = 'PRECLEARANCEREQUESTNONIMPLCOMPANY'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(239,'PreclearanceRequestNonImplCompany','DeleteAll_OS',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'CANCEL_OS') AND (UPPER(ControllerName) = 'PRECLEARANCEREQUESTNONIMPLCOMPANY'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(239,'PreclearanceRequestNonImplCompany','Cancel_OS',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ActivityURLMappingId FROM usr_ActivityURLMapping WHERE (UPPER(ActionName) = 'COINDEX_OS') AND (UPPER(ControllerName) = 'PreclearanceRequestNonImplCompany'))
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID,ControllerName,ActionName,ActionButtonName,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES	(240,'PreclearanceRequestNonImplCompany','CoIndex_OS',NULL,1,getdate(),1,getdate())		
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53001)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53001,'dis_btn_53001','Create Pre-Clearance Request','en-US',103303,104004,122102,'Create Pre-Clearance Request',1,GETDATE())
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OtherExcerciseOptionQty' AND OBJECT_ID = OBJECT_ID(N'[tra_TransactionDetails_OS]'))
BEGIN	
	ALTER TABLE tra_TransactionDetails_OS ADD [OtherExcerciseOptionQty] [DECIMAL](10,0) NOT NULL DEFAULT 0
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ReasonForNotTradingCodeId' AND OBJECT_ID = OBJECT_ID(N'[tra_PreclearanceRequest_NonImplementationCompany]'))
BEGIN	
	ALTER TABLE tra_PreclearanceRequest_NonImplementationCompany ADD [ReasonForNotTradingCodeId] [INT] NULL DEFAULT 0
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ReasonForNotTradingText' AND OBJECT_ID = OBJECT_ID(N'[tra_PreclearanceRequest_NonImplementationCompany]'))
BEGIN	
	ALTER TABLE tra_PreclearanceRequest_NonImplementationCompany ADD [ReasonForNotTradingText] [VARCHAR](30) NULL
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IsPartiallyTraded' AND OBJECT_ID = OBJECT_ID(N'[tra_PreclearanceRequest_NonImplementationCompany]'))
BEGIN	
	ALTER TABLE tra_PreclearanceRequest_NonImplementationCompany ADD [IsPartiallyTraded] INT NOT NULL DEFAULT 0
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ShowAddButton' AND OBJECT_ID = OBJECT_ID(N'[tra_PreclearanceRequest_NonImplementationCompany]'))
BEGIN	
	ALTER TABLE tra_PreclearanceRequest_NonImplementationCompany ADD [ShowAddButton] [INT] NOT NULL DEFAULT 0
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OtherExcerciseOptionQty' AND OBJECT_ID = OBJECT_ID(N'[tra_PreclearanceRequest_NonImplementationCompany]'))
BEGIN	
	ALTER TABLE tra_PreclearanceRequest_NonImplementationCompany ADD [OtherExcerciseOptionQty] [decimal](15, 4) NOT NULL DEFAULT 0.0000
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ReasonForApproval' AND OBJECT_ID = OBJECT_ID(N'[tra_PreclearanceRequest_NonImplementationCompany]'))
BEGIN	
	ALTER TABLE tra_PreclearanceRequest_NonImplementationCompany ADD [ReasonForApproval] [NVARCHAR](200) NULL
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ReasonForApprovalCodeId' AND OBJECT_ID = OBJECT_ID(N'[tra_PreclearanceRequest_NonImplementationCompany]'))
BEGIN	
	ALTER TABLE tra_PreclearanceRequest_NonImplementationCompany ADD ReasonForApprovalCodeId INT NULL
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122105)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(122105, NULL, 'PreClearance Request Details for Other Securities', 111, 122, 'Screen - PreClearance Request Details For Other Securities', 1, 1, GETDATE(), 1)
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53002)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53002,'dis_msg_53002','This Pre-clearance request violates Contra Trade rules.  Contra trading is not allowed till $1 for $2 transaction types.','en-US',103303,104001,122102,'This Pre-clearance request violates Contra Trade rules.  Contra trading is not allowed till $1 for $2 transaction types.',1,GETDATE())
END

--List of validation messages
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53003)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53003,'dis_msg_53003','Trading policy is not defined for the user for which transaction is being entered. Please contact administrator.','en-US',103303,104001,122102,'Trading policy is not defined for the user for which transaction is being entered. Please contact administrator.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53004)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53004,'dis_msg_53004','Pre-clearance for the selected transation and security is not needed.','en-US',103303,104001,122102,'Pre-clearance for the selected transation and security is not needed.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53005)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53005,'dis_msg_53005','Error occurred while update balance pool.','en-US',103303,104001,122102,'Error occurred while update balance pool.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53006)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53006,'dis_msg_53006','Cannot submit reason for not trading, as details are entered but not yet submitted for a transaction.','en-US',103303,104001,122102,'Cannot submit reason for not trading, as details are entered but not yet submitted for a transaction.',1,GETDATE())
END

---Pre clearance request (other securities) Grid - Insider
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114118)
BEGIN
	INSERT INTO com_Code
	(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES 
	(114118,NULL,'Preclearance List (Other Securities) - For Insider',NULL,114,'Preclearance List (Other Securities) - For Insider',1,1,GETDATE(),94)
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53007)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53007,'dis_grd_53007','Employee ID','en-US',103009,104003,122105,'Employee ID',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53008)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53008,'dis_grd_53008','Employee Status','en-US',103009,104003,122087,'Employee Status',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53009)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53009,'dis_grd_53009','Security Name','en-US',103009,104003,122087,'Security Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53010)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53010,'dis_grd_53010','Demat Account No','en-US',103009,104003,122087,'Demat Account No',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53011)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53011,'dis_grd_53011','PAN','en-US',103009,104003,122087,'PAN',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53012)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53012,'dis_grd_53012','Trade Value','en-US',103009,104003,122087,'Trade Value',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53013)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53013, 'dis_grd_53013','Pre Clearance ID','en-US',103009,104003,122087,'Pre Clearance ID',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53014)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53014, 'dis_grd_53014','Request For','en-US',103009,104003,122087,'Request For',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53015)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53015, 'dis_grd_53015','Request Date','en-US',103009,104003,122087,'Request Date',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53016)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53016, 'dis_grd_53016','PreClearance Status','en-US',103009,104003,122087,'PreClearance Status',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53017)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53017, 'dis_grd_53017','Transaction Type','en-US',103009,104003,122087,'Transaction Type',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53018)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53018, 'dis_grd_53018','Securities','en-US',103009,104003,122087,'Securities',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53019)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53019, 'dis_grd_53019','Preclearance Qty','en-US',103009,104003,122087,'Preclearance Qty',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53020)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53020, 'dis_grd_53020','Trade Qty','en-US',103009,104003,122087,'Trade Qty',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53021)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53021, 'dis_grd_53021','Trading Details Submission','en-US',103009,104003,122087,'Trading Details Submission',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53022)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53022, 'dis_grd_53022','Disclosure Details Submission: Softcopy','en-US',103009,104003,122087,'Disclosure Details Submission: Softcopy',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53023)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53023, 'dis_grd_53023','Disclosure Details Submission: Hardcopy','en-US',103009,104003,122087,'Disclosure Details Submission: Hardcopy',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53024)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53024, 'dis_grd_53024','Submission to Stock Exchange','en-US',103009,104003,122087,'Submission to Stock Exchange',1,GETDATE())
END
GO

--Map the grid header column resources to grid type for Pre-clearance Request List - Non-Implmentation company (For Insider)
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53013')--id
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53013', 1, 4, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53014')--req for
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53014', 1, 1, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53015')--date
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53015', 1, 6, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53016')--status
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53016', 1, 9, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53017')--trans type
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53017', 1, 10, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53018')-- securities
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53018', 1, 11, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53019')--pre quantity
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53019', 1, 12, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53020')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53020', 1, 13, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53021')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53021', 1, 15, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53022')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53022', 1, 16, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53023')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53023', 1, 17, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114118 AND ResourceKey = 'dis_grd_53024')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114118, 'dis_grd_53024', 0, 18, 0, 155001, NULL ,NULL)
END
GO

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53007')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114118,'dis_grd_53007',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53008')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114118,'dis_grd_53008',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53009')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114118,'dis_grd_53009',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53010')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114118,'dis_grd_53010',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53011')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114118,'dis_grd_53011',1,8,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53012')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114118,'dis_grd_53012',1,14,0,155001,NULL,NULL)
END

-------Update tradingPolicy table to generate preclearance form--------
UPDATE rul_TradingPolicy_OS SET IsPreclearanceFormForImplementingCompany = 1 WHERE TradingPolicyId = 1
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53025)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53025,'dis_btn_53025','Pre-Clearance Not Taken. Submit your trades','en-US',103303,104004,122102,'Pre-Clearance Not Taken. Submit your trades',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53026)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53026,'dis_lbl_53026','Available Balance in Demat Account:','en-US',103303,104002,122102,'Available Balance in Demat Account:',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53027)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53027,'dis_lbl_53027','Total Available Balance:','en-US',103303,104002,122102,'Total Available Balance:',1,GETDATE())
END

-----Error messages------------------
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53028)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53028,'dis_msg_53028','Error occurred while check last period end is submitted.','en-US',103303,104001,122102,'Error occurred while check last period end is submitted.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53029)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53029,'dis_msg_53029','You can''t create preclearance request, Previous period end is not submitted, please contact you Complaince Officer.','en-US',103303,104001,122102,'You can''t create preclearance request, Previous period end is not submitted, please contact you Complaince Officer.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53030)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53030,'dis_msg_53030','You can''t create preclearance request, Please submit your previous period end disclosures.','en-US',103303,104001,122102,'You can''t create preclearance request, Please submit your previous period end disclosures.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53031)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53031,'dis_msg_53031','Cannot create new preclearance request, as a period end disclosure is not yet submiited.','en-US',103303,104001,122102,'Cannot create new preclearance request, as a period end disclosure is not yet submiited.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53032)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53032,'dis_msg_53032','Security pool does not have sufficient quantity','en-US',103303,104001,122102,'Security pool does not have sufficient quantity',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53033)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53033,'dis_ttl_53033','Preclearances/Continuous Disclosures- Other Securities','en-US',103303,104006,122102,'Preclearances/Continuous Disclosures- Other Securities',1,GETDATE())
END


---Pre clearance request (other securities) Grid - For CO
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114119)
BEGIN
	INSERT INTO com_Code
	(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES 
	(114119,NULL,'Preclearance List (Other Securities) - For CO',NULL,114,'Preclearance List (Other Securities) - For CO',1,1,GETDATE(),94)
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53034)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53034,'dis_grd_53034','Employee ID','en-US',103009,104003,122105,'Employee ID',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53035)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53035,'dis_grd_53035','Employee Status','en-US',103009,104003,122087,'Employee Status',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53036)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53036,'dis_grd_53036','Security Name','en-US',103009,104003,122087,'Security Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53037)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53037,'dis_grd_53037','Demat Account No','en-US',103009,104003,122087,'Demat Account No',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53038)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53038,'dis_grd_53038','PAN','en-US',103009,104003,122087,'PAN',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53039)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53039,'dis_grd_53039','Trade Value','en-US',103009,104003,122087,'Trade Value',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53040)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53040, 'dis_grd_53040','Pre Clearance ID','en-US',103009,104003,122087,'Pre Clearance ID',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53041)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53041, 'dis_grd_53041','Request For','en-US',103009,104003,122087,'Request For',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53042)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53042, 'dis_grd_53042','Request Date','en-US',103009,104003,122087,'Request Date',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53043)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53043, 'dis_grd_53043','PreClearance Status','en-US',103009,104003,122087,'PreClearance Status',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53044)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53044, 'dis_grd_53044','Transaction Type','en-US',103009,104003,122087,'Transaction Type',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53045)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53045, 'dis_grd_53045','Securities','en-US',103009,104003,122087,'Securities',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53046)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53046, 'dis_grd_53046','Preclearance Qty','en-US',103009,104003,122087,'Preclearance Qty',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53047)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53047, 'dis_grd_53047','Trade Qty','en-US',103009,104003,122087,'Trade Qty',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53048)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53048, 'dis_grd_53048','Trading Details Submission','en-US',103009,104003,122087,'Trading Details Submission',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53049)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53049, 'dis_grd_53049','Disclosure Details Submission: Softcopy','en-US',103009,104003,122087,'Disclosure Details Submission: Softcopy',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53050)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53050, 'dis_grd_53050','Disclosure Details Submission: Hardcopy','en-US',103009,104003,122087,'Disclosure Details Submission: Hardcopy',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53051)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(53051, 'dis_grd_53051','Submission to Stock Exchange','en-US',103009,104003,122087,'Submission to Stock Exchange',1,GETDATE())
END

--Map the grid header column resources to grid type for Pre-clearance Request List - Non-Implmentation company (For Insider)
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53040')--id
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53040', 1, 4, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53041')--req for
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53041', 1, 1, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53042')--date
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53042', 1, 6, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53043')--status
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53043', 1, 9, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53044')--trans type
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53044', 1, 10, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53045')-- securities
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53045', 1, 11, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53046')--pre quantity
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53046', 1, 12, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53047')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53047', 1, 13, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53048')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53048', 1, 15, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53049')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53049', 1, 16, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53050')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53050', 1, 17, 0, 155001, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114119 AND ResourceKey = 'dis_grd_53051')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114119, 'dis_grd_53051', 0, 18, 0, 155001, NULL ,NULL)
END
GO

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53034')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114119,'dis_grd_53034',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53035')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114119,'dis_grd_53035',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53036')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114119,'dis_grd_53036',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53037')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114119,'dis_grd_53037',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53038')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114119,'dis_grd_53038',1,8,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_53039')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114119,'dis_grd_53039',1,14,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ID FROM com_GlobalRedirectionControllerActionPair WHERE ID = 8)
BEGIN
INSERT INTO com_GlobalRedirectionControllerActionPair VALUES (8,'PreclearanceRequestNonImplCompanyIndexOS',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53092)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53092,'dis_lbl_53092','Pre-Clearance Approved Balance in Demat Account:','en-US',103303,104002,122102,'Available Balance in Demat Account:',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53093)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53093,'dis_lbl_53093','Total Pre-Clearance Approved Balance:','en-US',103303,104002,122102,'Total Pre-Clearance Approved Balance:',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53097)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53097,'dis_msg_53097','Pre-clearance is not needed, since the values provided are within limit. you can directly submit trade details.','en-US',103303,104001,122102,'Pre-clearance is not needed, since the values provided are within limit. you can directly submit trade details.',1,GETDATE())
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 153067)
BEGIN
	INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES(153067,NULL,'Pre-clearance expiry- Non-Implementation company',NULL,153,'Pre-clearance expiry- Non-Implementation company',1,1,GETDATE(),65)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_11228' and GridTypeCodeId = 114119)
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114119,'usr_grd_11228',1,0,0,155001,NULL,NULL)
END

UPDATE tra_TemplateMaster 
SET Contents = '<p style="text-align:center"><strong>FORM - E</strong>(for physical pre-clearance/e-mail)</p>    <p style="text-align:center">&nbsp;</p>    <p style="text-align:center"><em>[PCL_IMPLEMENTCOMPANY] Trading Code of Conduct</em></p>    <p style="text-align:center">APPLICATION TO TRADE</p>    <p>&nbsp;</p>    <p>To</p>    <p>Compliance Officer</p>    <p>From,</p>    <p>NAME OF EMPLOYEE :&nbsp;[USR_FIRSTNAME][USR_MIDDLENAME][USR_LASTNAME]</p>    <p>EMPLOYEE CODE :&nbsp; &nbsp; &nbsp;&nbsp;<u>[USR_EMPLOYEEID]</u></p>    <p>BRANCH/DEPARTMENT :<u>[USR_DEPT]</u></p>    <p>&nbsp;</p>    <p>With reference to the [PCL_IMPLEMENTCOMPANY]&nbsp;Trading Code of Conduct, I here by give notice that I / my affected person Mr/ Ms [USR_FIRSTNAME][USR_MIDDLENAME][USR_LASTNAME]propose to carry out the following transaction:-</p>    <p>(Note: For offline trades, please fill separate forms for self and each of affected person.The code number above should be of the person in whose name the transaction is proposed)</p>    <p>&nbsp;</p>    <p>&nbsp;</p>    <table border="1" cellpadding="10" cellspacing="0" style="width:100%">   <tbody>    <tr>     <td><strong>Name of the Security(ies) </strong></td>     <td><strong>Type of Security </strong></td>     <td><strong>Nature of Transaction </strong></td>     <td><strong>Quantity of Security (ies) </strong></td>     <td><strong>Indicative Price / Premium (for offline trade only) </strong></td>     <td><strong>Name of the Exchange </strong></td>     <td><strong>Date of purchase / allotment (applicable only if the application is in respect of sale of Securities) </strong></td>     <td><strong>*Previous approval no. and date for purchase/allotment)</strong></td>     <td><strong>Preclearance Status </strong></td>    </tr>    <tr>     <td>[PCL_TRADEDFORCOMPANY]</td>     <td>[PCL_SECURITYTYPE]</td>     <td>[PCL_TRANSACTNTYPE]</td>     <td>[PCL_SECURITYTRADEQTY]</td>     <td>Not Applicable</td>     <td>&nbsp;</td>     <td>[PCL_BUYDATE]</td>     <td>[PCL_PREVAPPROVNUMBERANDDATE]</td>     <td>[PCL_STATUS]</td>    </tr>   </tbody>  </table>    <p><strong>* applicable only if the application is in respect of sale of Securities for which an earlier purchase sanction was granted by the Compliance Officer</strong></p>    <p>&nbsp;</p>    <p>&nbsp;</p>    <p>&nbsp;</p>    <p>In this connection, I do hereby represent and undertake as follows:-</p>    <ol>   <li>That I am aware of the SEBI (Prohibition of Insider Trading) Regulations, 2015(Regulations) and the [PCL_IMPLEMENTCOMPANY] (Bank/Company)-Trading Code of Conduct and procedures made thereunder and have not contravened the Regulations and the Code/procedures laid down by the Bank for prevention of insider trading as notified by the Bank from time to time.</li>   <li>That I do not have any access nor have I received any &quot;Unpublished Price Sensitive Information&quot; as defined in the Regulations as amended up to and at the time of signing the undertaking in respect of the aforesaid securities.</li>   <li>That in case I have access to or receive &quot;Unpublished Price Sensitive Information&quot; after the signing of the undertaking but before the execution of any transactions in securities of the Company, I shall inform the Compliance Officer of the change in my position and that I would completely refrain from dealing in the securities of the company till the time such information becomes generally available or ceases to be price sensitive.</li>   <li>I am not trading in any securities including the Bank securities, which I have undertaken a contra-trade in the last 6 months, as the case may be subject to exception granted by Clause 9.5 of the Code of the Bank, if applicable.</li>   <li>I undertake to submit the necessary report within 2 trading days of execution of the transaction/a &#39;Nil&#39; report if the transaction is not undertaken.</li>   <li>I agree to comply with the provisions of the Code and provide any information related to the trade as may be required by the Compilance Officer and permit the company to disclosure such details to SEBI, if so required by SEBI.</li>   <li>That I have made a full and true disclosure in the matter.</li>  </ol>    <p>&nbsp;</p>    <p>Date:[PCL_REQUESTDATE]&nbsp;<u>[USR_LASTNAME]</u></p>    <p>&nbsp;</p>    <p>&nbsp;</p>    <p>(Signature) / (Approval by email)</p>    <p>&nbsp;</p>    <p>AUTHORISATION TO TRADE</p>    <p>The above transaction has been authorised. Your dealing must be completed within 7 trading days from the date of approval. (Including the date of approval).</p>    <p>&nbsp;</p>    <p>Date:[PCL_APPROVEDDATE]&nbsp;<u>[PCL_APPROVEDBY]</u></p>    <p>&nbsp;</p>    <p>&nbsp;</p>    <p>(Signature) / (Approval by email)</p>  '
WHERE TemplateMasterId = 2

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 53146)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (53146,'dis_msg_53146','You cannot take preclearance request for same $1 company, $2 demat account and $3 security type, Please recheck the preclearance request','en-US',103303,104001,122102,'You cannot take preclearance request for same $1 company, $2 demat account and $3 security type, Please recheck the preclearance request',1,GETDATE())
END
