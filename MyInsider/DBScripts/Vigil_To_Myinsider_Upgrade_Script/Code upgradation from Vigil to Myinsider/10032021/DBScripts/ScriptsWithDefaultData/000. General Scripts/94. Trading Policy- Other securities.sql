-- ======================================================================================================
-- Author      :Rajashri Sathe
-- CREATED DATE: 12-Des-2019
-- Description : Script for Trading Policy Other securities
-- ======================================================================================================
IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Trading Policy-Other Securities' and UPPER(ActivityName)='View' and ActivityID = 337)
BEGIN
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(337,'Trading Policy-Other Securities','View','103006',NULL,'Trading Policy-Other Securities',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (337,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (337,'101002')
END

IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Trading Policy-Other Securities' and UPPER(ActivityName)='Create' and ActivityID = 338)
BEGIN
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(338,'Trading Policy-Other Securities','Create','103006',NULL,'Trading Policy-Other Securities',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (338,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (338,'101002')
END

IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Trading Policy-Other Securities' and UPPER(ActivityName)='Edit' and ActivityID = 339)
BEGIN
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(339,'Trading Policy-Other Securities','Edit','103006',NULL,'Trading Policy-Other Securities',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (339,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (339,'101002')
END

IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Trading Policy-Other Securities' and UPPER(ActivityName)='Delete' and ActivityID = 340)
BEGIN
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(340,'Trading Policy-Other Securities','Delete','103006',NULL,'Trading Policy-Other Securities',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (340,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (340,'101002')
END

--INSERT SCRIPT FOR mst_MenuMaster for insider
IF NOT EXISTS (SELECT MenuID FROM mst_MenuMaster WHERE MenuID = 71)
BEGIN
	INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,
			ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES
	(
		71,'Trading Policy- Other Securities','Trading Policy- Other Securities',
		'TradingPolicy_OS/Index?acid=337',2004,5,102001,NULL,NULL,337,1,GETDATE(),1,GETDATE()  
	)	
	--changed display order of period end menu fro insider user
	UPDATE mst_MenuMaster SET DisplayOrder=2005 where MenuID=8	
	UPDATE mst_MenuMaster SET DisplayOrder=2006 where MenuID=9
	UPDATE mst_MenuMaster SET DisplayOrder=2007 where MenuID=48
END

------INSERT SCRIPT FOR Trading Policy Other Security Details Screen ------
IF NOT EXISTS (SELECT * FROM com_Code WHERE CodeID=122114)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
      (122114,'Trading Policy Other Securities Details',122,'Screen - Trading Policy Other Securities Details',1,1,114,null,103006,1,GETDATE())
END
GO

--INSERT SCRIPT FOR com_Code for grid
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=114129)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (114129,'Trading Policy Other Securities List',114,'Trading Policy Other Securities List',1,1,'129',null,null,1,GETDATE())
END

--INSERT SCRIPT FOR com_Code for Screen
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=112010)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (112010,'Insider Other Securities',112,'Insider Other Securities',1,1,'10',null,null,1,GETDATE())
END

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID=528)
BEGIN
	 INSERT INTO com_CodeGroup(CodeGroupID,COdeGroupName,[Description],IsVisible,IsEditable,ParentCodeGroupId)
	 VALUES
	 (528,'Allow Restricted List Search OS','Allow Restricted List Search OS',1,0,NULL)
END

--INSERT SCRIPT in com_Code for Perpetual
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=528001)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (528001,'Perpetual',528,'Perpetual',1,1,'1',null,null,1,GETDATE())
END
--INSERT SCRIPT in com_Code for Limited
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=528002)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (528002,'Limited',528,'Limited',1,1,'2',null,null,1,GETDATE())
END

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID=535)
BEGIN
	 INSERT INTO com_CodeGroup(CodeGroupID,COdeGroupName,[Description],IsVisible,IsEditable,ParentCodeGroupId)
	 VALUES
	 (535,'Pre-clearance approval Type','Pre-clearance approval Type',1,0,NULL)
END

--INSERT SCRIPT in com_Code for Auto
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=535001)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (535001,'Auto',535,'Auto',1,1,'1',null,null,1,GETDATE())
END
--INSERT SCRIPT in com_Code for Manual
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=535002)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (535002,'Manual',535,'Manual',1,1,'2',null,null,1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55364)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55364,'rul_lbl_55364','Pre-clearance approval','en-US','103006','104002','122114','Pre-clearance approval',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55365)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55365,'rul_lbl_55365','Auto','en-US','103006','104002','122114','Perpetual',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55366)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55366,'rul_lbl_55366','Manual','en-US','103006','104002','122114','Limited',1,GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=114150)
BEGIN
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114150,NULL,'Overlapping trading policy list for users of a trading policy For Other Securities',NULL,114,'Overlapping trading policy list for users of a trading policy For Other Securitie',1,1,GETDATE(),64)
END

GO

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=122115)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (122115,'Applicability_OS',122,'Applicability_OS',1,1,'115',null,null,1,GETDATE())
END
GO

--- INSERT SCRIPT FOR usr_UserRelation for activityId View------

If NOT EXISTS (SELECT ActivityId FROM [usr_UserTypeActivity] where ActivityId=337)
BEGIN
      INSERT INTO usr_UserTypeActivity(ActivityId,UserTypeCodeId)
	  VALUES
	  (337,101001)
END

--- INSERT SCRIPT FOR Admin Role----
CREATE TABLE #RolesByUserType1(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType1
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId in (101002,101001)
DECLARE @nCount1 INT = 1
DECLARE @nTotCount1 INT = 0
DECLARE @nRoleID1 INT = 0
SELECT @nTotCount1 = COUNT(RoleID) FROM #RolesByUserType1

WHILE @nCount1 <= @nTotCount1
BEGIN
	SET @nRoleID1 = (SELECT RoleID FROM #RolesByUserType1 WHERE ID = @nCount1)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='337' AND RoleID = @nRoleID1)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(337,@nRoleID1,1,GETDATE(),1,GETDATE())
	END

	SET @nCount1 = @nCount1 + 1
	SET @nRoleID1 = 0
END
DROP TABLE #RolesByUserType1



--- INSERT SCRIPT FOR usr_UserRelation for activityId Create----------

If NOT EXISTS (SELECT ActivityId FROM [usr_UserTypeActivity] where ActivityId=338)
BEGIN
      INSERT INTO usr_UserTypeActivity(ActivityId,UserTypeCodeId)
	  VALUES
	  (338,101001)
END

--- INSERT SCRIPT FOR Admin Role Create----
CREATE TABLE #RolesByUserType2(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType2
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId in (101002,101001)
DECLARE @nCount2 INT = 1
DECLARE @nTotCount2 INT = 0
DECLARE @nRoleID2 INT = 0
SELECT @nTotCount2 = COUNT(RoleID) FROM #RolesByUserType2

WHILE @nCount2 <= @nTotCount2
BEGIN
	SET @nRoleID2 = (SELECT RoleID FROM #RolesByUserType2 WHERE ID = @nCount2)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='338' AND RoleID = @nRoleID2)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(338,@nRoleID2,1,GETDATE(),1,GETDATE())
	END

	SET @nCount2 = @nCount2 + 1
	SET @nRoleID2 = 0
END
DROP TABLE #RolesByUserType2

--- INSERT SCRIPT FOR usr_UserRelation for activityId Edit

If NOT EXISTS (SELECT ActivityId FROM [usr_UserTypeActivity] where ActivityId=339)
BEGIN
      INSERT INTO usr_UserTypeActivity(ActivityId,UserTypeCodeId)
	  VALUES
	  (339,101001)
END

--- INSERT SCRIPT FOR Admin Role Edit----
CREATE TABLE #RolesByUserType3(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType3
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId in (101002,101001)
DECLARE @nCount3 INT = 1
DECLARE @nTotCount3 INT = 0
DECLARE @nRoleID3 INT = 0
SELECT @nTotCount3 = COUNT(RoleID) FROM #RolesByUserType3

WHILE @nCount3 <= @nTotCount3
BEGIN
	SET @nRoleID3 = (SELECT RoleID FROM #RolesByUserType3 WHERE ID = @nCount3)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='339' AND RoleID = @nRoleID3)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(339,@nRoleID3,1,GETDATE(),1,GETDATE())
	END

	SET @nCount3 = @nCount3 + 1
	SET @nRoleID3 = 0
END
DROP TABLE #RolesByUserType3


--- INSERT SCRIPT FOR usr_UserRelation for activityId delete

If NOT EXISTS (SELECT ActivityId FROM [usr_UserTypeActivity] where ActivityId=340)
BEGIN
      INSERT INTO usr_UserTypeActivity(ActivityId,UserTypeCodeId)
	  VALUES
	  (340,101001)
END

--- INSERT SCRIPT FOR Admin Role delete----
CREATE TABLE #RolesByUserType4(ID INT IDENTITY(1,1),RoleID INT)
INSERT INTO #RolesByUserType4
SELECT RoleId FROM usr_RoleMaster WHERE UserTypeCodeId in (101002,101001)
DECLARE @nCount4 INT = 1
DECLARE @nTotCount4 INT = 0
DECLARE @nRoleID4 INT = 0
SELECT @nTotCount4 = COUNT(RoleID) FROM #RolesByUserType4

WHILE @nCount4 <= @nTotCount4
BEGIN
	SET @nRoleID4 = (SELECT RoleID FROM #RolesByUserType4 WHERE ID = @nCount4)
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='340' AND RoleID = @nRoleID4)
	BEGIN
			INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			VALUES(340,@nRoleID4,1,GETDATE(),1,GETDATE())
	END

	SET @nCount4 = @nCount4 + 1
	SET @nRoleID4 = 0
END
DROP TABLE #RolesByUserType4

------INSERT SCRIPT FOR Trading Policy Other Security List ------
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=122113)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
      (122113,'Trading Policy Other Securities List',122,'Screen-Trading Policy Other Securities List',1,1,113,null,103006,1,GETDATE())
END


-----INSERT SCRIPT FOR ADD TRADING POLICY OTHER SECURITY BUTTUN ON SCREEN------
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55085)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55085,'rul_btn_55085','Add Trading Policy Other Securities','en-US','103006','104004','122113','Add Trading Policy Other Securities',1,GETDATE())
END


---rul_lbl_55086 policy name---
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55086)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55086,'rul_lbl_55086','Policy Name','en-US','103006','104002','122113','Policy Name',1,GETDATE())
END

---rul_lbl_55087 Applicable Form----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55087)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55087,'rul_lbl_55087','Applicable From','en-US','103006','104002','122113','Applicable From',1,GETDATE())
END

---rul_lbl_55088 applicable To-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55088)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55088,'rul_lbl_55088','Applicable To','en-US','103006','104002','122113','Applicable To',1,GETDATE())
END

---rul_grd_55089 Policy name----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55089)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55089,'rul_grd_55089','Policy Name','en-US','103006','104003','122113','Policy Name',1,GETDATE())
END

---rul_grd_55090 Applicable Form date----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55090)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55090,'rul_grd_55090','Applicable from date','en-US','103006','104003','122113','Applicable from date',1,GETDATE())
END


---rul_grd_55091 applicable To date-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55091)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55091,'rul_grd_55091','Applicable to date','en-US','103006','104003','122113','Applicable to date',1,GETDATE())
END


---rul_grd_55092 applicable To-----

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55092)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55092,'rul_grd_55092','Applicable to','en-US','103006','104003','122113','Applicable to',1,GETDATE())
END

---rul_grd_55093 Status-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55093)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55093,'rul_grd_55093','Status','en-US','103006','104003','122113','Status',1,GETDATE())
END


---rul_msg_55094 Error occurred while fetching trading policy other security list.-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55094)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55094,'rul_msg_55094','Error occurred while fetching trading policy other Securities list.','en-US','103006','104001','122113','Error occurred while fetching trading policy other Securities list.',1,GETDATE())
END


-----rul_grd_55095 Modified on-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55095)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55095,'rul_grd_55095','Modified on','en-US','103006','104003','122113','Modified on',1,GETDATE())
END


-----rul_grd_55096 Modified by-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55096)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55096,'rul_grd_55096','Modified by','en-US','103006','104003','122113','Modified by',1,GETDATE())
END

-----rul_grd_55135 Policy Name(History)-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55135)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55135,'rul_grd_55135','Policy Name','en-US','103006','104003','122113','Policy Name',1,GETDATE())
END


-----rul_grd_55136 Applicable from date(History)-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55136)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55136,'rul_grd_55136','Applicable from date','en-US','103006','104003','122113','Applicable from date',1,GETDATE())
END

-----rul_grd_55137 Applicable to date(History)-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55137)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55137,'rul_grd_55137','Applicable to date','en-US','103006','104003','122113','Applicable to date',1,GETDATE())
END


-----rul_grd_55138 Applicable to(History)-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55138)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55138,'rul_grd_55138','Applicable to','en-US','103006','104003','122113','Applicable to',1,GETDATE())
END

-----rul_grd_55139 Status(History)-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55139)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55139,'rul_grd_55139','Status','en-US','103006','104003','122113','Status',1,GETDATE())
END

-----rul_grd_55140 Modified on(History)-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55140)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55140,'rul_grd_55140','Modified on','en-US','103006','104003','122113','Modified on',1,GETDATE())
END

-----rul_grd_55141 Modified by(History)-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55141)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55141,'rul_grd_55141','Modified by','en-US','103006','104003','122113','Modified by',1,GETDATE())
END


-----usr_grd_11496 Action(exequted)-------
--IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=11496)
--BEGIN
--    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
--	VALUES
--     (11496,'usr_grd_11496','Action','en-US','103001','104003','122001','Action',1,GETDATE())
--END

------INSERT SCRIPT FOR Trading Policy Other Security ------
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=132022)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
      (132022,'Trading Policy Other Securities',132,'Map To Type - Trading Policy Other Securities',1,1,22,null,null,1,GETDATE())
END




------INSERT SCRIPT FOR Trading Policy Other Security History List ------
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=114130)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
      (114130,'Trading Policy Other Securities History List',114,'Trading Policy Other Securities History List',1,1,130,null,null,1,GETDATE())
END

-----rul_grd_55147 Type Of Security list -----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55147)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55147,'rul_grd_55147','Type Of Securities','en-US','103006','104003','122114','Type Of Securities',1,GETDATE())
END

-----rul_grd_55148 No. Of Share list -----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55148)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55148,'rul_grd_55148','No. Of Share','en-US','103006','104003','122114','No. Of Share',1,GETDATE())
END

-----rul_grd_55149 % Of Paid & Subscribed Capital list -----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55149)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55149,'rul_grd_55149','% Of Paid & Subscribed Capital','en-US','103006','104003','122114','% Of Paid & Subscribed Capital',1,GETDATE())
END


-----rul_grd_55150 Value Of Share list -----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55150)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55150,'rul_grd_55150','Value Of Share','en-US','103006','104003','122114','Value Of Share',1,GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=114131)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
      (114131,'Trading Policy Other Securitywise Limits',114,'Trading Policy Other Securitywise Limits',1,1,131,null,null,1,GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=114132)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
      (114132,'Applicability Search List_OS - Employee',114,'Applicability Search List_OS - Employee',1,1,132,null,null,1,GETDATE())
END


IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=114133)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
      (114133,'Applicability Association_OS - Employee List',114,'Applicability Association_OS - Employee List',1,1,133,null,null,1,GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=114139)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
      (114139,'Applicability association filter list_OS',114,'Applicability association filter list_OS',1,1,139,null,null,1,GETDATE())
END

---rul_lbl_55151 Trading Policy Other Security---
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55151)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55151,'rul_lbl_55151','Trading Policy Other Securities','en-US','103006','104002','122114','Trading Policy Other Securities',1,GETDATE())
END

---rul_lbl_55152 policy name---
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55152)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55152,'rul_lbl_55152','Policy Name','en-US','103006','104002','122114','Policy Name',1,GETDATE())
END

---rul_lbl_55153 Description---
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55153)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55153,'rul_lbl_55153','Description','en-US','103006','104002','122114','Description',1,GETDATE())
END

---rul_lbl_55154 Applicable Form----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55154)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55154,'rul_lbl_55154','Applicable From','en-US','103006','104002','122114','Applicable From',1,GETDATE())
END

---rul_lbl_55155 applicable To-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55155)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55155,'rul_lbl_55155','Applicable To','en-US','103006','104002','122114','Applicable To',1,GETDATE())
END

---rul_lbl_55156 No. of Equity Shares----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55156)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55156,'rul_lbl_55156','No. of Equity Shares','en-US','103006','104002','122114','No. of Equity Shares',1,GETDATE())
END

---rul_lbl_55157 Approval Required for All Trades----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55157)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55157,'rul_lbl_55157','Approval Required for All Trades','en-US','103006','104002','122114','Approval Required for All Trades',1,GETDATE())
END

---rul_lbl_55158 % of paid up & subscribed capital-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55158)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55158,'rul_lbl_55158','% of paid up & subscribed capital','en-US','103006','104002','122114','% of paid up & subscribed capital',1,GETDATE())
END


---rul_lbl_55159 Prohibit pre clearance during non-trading period:-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55159)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55159,'rul_lbl_55159','Prohibit pre clearance during non-trading period:','en-US','103006','104002','122114','Prohibit pre clearance during non-trading period:',1,GETDATE())
END

---rul_lbl_55160 Pre-clearance approval to be given within----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55160)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55160,'rul_lbl_55160','Pre-clearance approval to be given within','en-US','103006','104002','122114','Pre-clearance approval to be given within',1,GETDATE())
END

---rul_lbl_55161 Pre-clearance approval validity----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55161)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55161,'rul_lbl_55161','Pre-clearance approval validity','en-US','103006','104002','122114','Pre-clearance approval validity',1,GETDATE())
END


---rul_lbl_55162 Seek declaration from employee regarding  possession of UPSI-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55162)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55162,'rul_lbl_55162','Seek declaration from employee regarding  possession of UPSI','en-US','103006','104002','122114','Seek declaration from employee regarding  possession of UPSI',1,GETDATE())
END


---rul_lbl_55163 If Yes, Enter the declaration sought from the insider at the time of preclearance----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55163)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55163,'rul_lbl_55163','If Yes, Enter the declaration sought from the insider at the time of preclearance','en-US','103006','104002','122114','If Yes, Enter the declaration sought from the insider at the time of preclearance',1,GETDATE())
END

---rul_lbl_55164 Reason for non trade to be provided-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55164)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55164,'rul_lbl_55164','Reason for non trade to be provided','en-US','103006','104002','122114','Reason for non trade to be provided',1,GETDATE())
END


---rul_lbl_55165 Complete trade not done for Pre-clearance taken----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55165)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55165,'rul_lbl_55165','Complete trade not done for Pre-clearance taken','en-US','103006','104002','122114','Complete trade not done for Pre-clearance taken',1,GETDATE())
END


---rul_lbl_55166 Partial trade not done for Pre-clearance taken-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55166)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55166,'rul_lbl_55166','Partial trade not done for Pre-clearance taken','en-US','103006','104002','122114','Partial trade not done for Pre-clearance taken',1,GETDATE())
END


---rul_lbl_55167 Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55167)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55167,'rul_lbl_55167','Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within','en-US','103006','104002','122114','Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within',1,GETDATE())
END


---rul_lbl_55168 Trade (Continous) Disclosure to be submitted by Insider to CO all trades-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55168)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55168,'rul_lbl_55168','Trade (Continous) Disclosure to be submitted by Insider to CO all trades','en-US','103006','104002','122114','Trade (Continous) Disclosure to be submitted by Insider to CO all trades',1,GETDATE())
END


---rul_lbl_55169 Multiple Transaction Trade Above for----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55169)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55169,'rul_lbl_55169','Multiple Transaction Trade Above for','en-US','103006','104002','122114','Multiple Transaction Trade Above for',1,GETDATE())
END


---rul_lbl_55170 in----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55170)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55170,'rul_lbl_55170','in','en-US','103006','104002','122114','in',1,GETDATE())
END

---rul_lbl_55171 No. of Equity Shares-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55171)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55171,'rul_lbl_55171','No. of Equity Shares','en-US','103006','104002','122114','No. of Equity Shares',1,GETDATE())
END

---rul_lbl_55172 % of paid up & subscribed capital-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55172)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55172,'rul_lbl_55172','% of paid up & subscribed capital','en-US','103006','104002','122114','% of paid up & subscribed capital',1,GETDATE())
END

---rul_lbl_55173 Value of Share-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55173)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55173,'rul_lbl_55173','Value of Share','en-US','103006','104002','122114','Value of Share',1,GETDATE())
END

---rul_lbl_55174 Trade (Continous) Disclosure submission to Stock Exchange by CO within - -----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55174)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55174,'rul_lbl_55174','Trade (Continous) Disclosure submission to Stock Exchange by CO within - ','en-US','103006','104002','122114','Trade (Continous) Disclosure submission to Stock Exchange by CO within - ',1,GETDATE())
END

---rul_lbl_55175 Initial Disclosure  be submitted by the Insider/Employee to company-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55175)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55175,'rul_lbl_55175','Initial Disclosure  be submitted by the Insider/Employee to company','en-US','103006','104002','122114','Initial Disclosure  be submitted by the Insider/Employee to company',1,GETDATE())
END

---rul_lbl_55176 Initial Disclosure before-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55176)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55176,'rul_lbl_55176','Initial Disclosure before','en-US','103006','104002','122114','Initial Disclosure before',1,GETDATE())
END

---rul_lbl_55177 Period End Disclosures to be submitted by the Insider/Employee to Company : ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55177)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55177,'rul_lbl_55177','Period End Disclosures to be submitted by the Insider/Employee to Company : ','en-US','103006','104002','122114','Period End Disclosures to be submitted by the Insider/Employee to Company : ',1,GETDATE())
END

---rul_lbl_55178 Period End Disclosures----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55178)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55178,'rul_lbl_55178','Period End Disclosures','en-US','103006','104002','122114','Period End Disclosures',1,GETDATE())
END

---rul_lbl_55179 Security Type-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55179)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55179,'rul_lbl_55179','Securitie Type','en-US','103006','104002','122114','Securitie Type',1,GETDATE())
END


---rul_lbl_55180 Trading Plan-----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55180)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55180,'rul_lbl_55180','Trading Plan','en-US','103006','104002','122114','Trading Plan',1,GETDATE())
END

---rul_lbl_55181 Minimum holding period----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55181)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55181,'rul_lbl_55181','Minimum holding period','en-US','103006','104002','122114','Minimum holding period',1,GETDATE())
END

---rul_lbl_55182 Contra trade not allowed for----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55182)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55182,'rul_lbl_55182','Contra trade not allowed for','en-US','103006','104002','122114','Contra trade not allowed for',1,GETDATE())
END
---rul_lbl_55183 Exception for----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55183)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55183,'rul_lbl_55183','Exception for','en-US','103006','104002','122114','Exception for',1,GETDATE())
END

---rul_lbl_55184 Policy Status----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55184)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55184,'rul_lbl_55184','Policy Status','en-US','103006','104002','122114','Policy Status',1,GETDATE())
END


---rul_lbl_55185 Initial Disclosure to be submitted by the CO to Stock Exchange----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55185)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55185,'rul_lbl_55185','Initial Disclosure to be submitted by the CO to Stock Exchange','en-US','103006','104002','122114','Initial Disclosure to be submitted by the CO to Stock Exchange',1,GETDATE())
END

---rul_lbl_55186 Trade (Continous) Disclosure to be submitted to Stock Exchange by CO----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55186)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55186,'rul_lbl_55186','Trade (Continous) Disclosure to be submitted to Stock Exchange by CO','en-US','103006','104002','122114','Trade (Continous) Disclosure to be submitted to Stock Exchange by CO',1,GETDATE())
END
---rul_lbl_55187 Period End Disclosure to be submitted by Insider to CO within----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55187)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55187,'rul_lbl_55187','Period End Disclosure to be submitted by Insider to CO within','en-US','103006','104002','122114','Period End Disclosure to be submitted by Insider to CO within',1,GETDATE())
END
---rul_lbl_55188 Period End Disclosure to be submitted to Stock Exchanges by CO----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55188)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55188,'rul_lbl_55188','Period End Disclosure to be submitted to Stock Exchanges by CO','en-US','103006','104002','122114','Period End Disclosure to be submitted to Stock Exchanges by CO',1,GETDATE())
END
---rul_lbl_55189 Period End Disclosure to be submitted to Stock Exchanges by within----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55189)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55189,'rul_lbl_55189','Period End Disclosure to be submitted to Stock Exchanges by within','en-US','103006','104002','122114','Period End Disclosure to be submitted to Stock Exchanges by within',1,GETDATE())
END

---rul_lbl_55190 HardCopy----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55190)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55190,'rul_lbl_55190','HardCopy','en-US','103006','104002','122114','HardCopy',1,GETDATE())
END
---rul_lbl_55191 Initial Disclosure within----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55191)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55191,'rul_lbl_55191','Initial Disclosure within','en-US','103006','104002','122114','Initial Disclosure within',1,GETDATE())
END

---rul_lbl_55192 Trading Details to be submitted by Insider/Employee to CO within----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55192)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55192,'rul_lbl_55192','Trading Details to be submitted by Insider/Employee to CO within','en-US','103006','104002','122114','Trading Details to be submitted by Insider/Employee to CO within',1,GETDATE())
END

---rul_lbl_55193 Softcopy----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55193)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55193,'rul_lbl_55193','Softcopy','en-US','103006','104002','122114','Softcopy',1,GETDATE())
END
---rul_lbl_55194 Seek declaration from employee regarding possession of UPSI----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55194)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55194,'rul_lbl_55194','Seek declaration from employee regarding possession of UPSI','en-US','103006','104002','122114','Seek declaration from employee regarding possession of UPSI',1,GETDATE())
END
---rul_lbl_55195 Declaration to be Mandatory----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55195)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55195,'rul_lbl_55195','Declaration to be Mandatory','en-US','103006','104002','122114','Declaration to be Mandatory',1,GETDATE())
END
---rul_lbl_55196 Display the declaration post submission of Continuous Disclosure----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55196)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55196,'rul_lbl_55196','Display the declaration post submission of Continuous Disclosure','en-US','103006','104002','122114','Display the declaration post submission of Continuous Disclosure',1,GETDATE())
END
---rul_lbl_55197 Approval Required for Transaction Trade above:----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55197)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55197,'rul_lbl_55197','Approval Required for Transaction Trade above:','en-US','103006','104002','122114','Approval Required for Transaction Trade above:',1,GETDATE())
END
---rul_lbl_55198 Allow new pre clearance to be created when earlier preclearance is open----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55198)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55198,'rul_lbl_55198','Allow new pre clearance to be created when earlier preclearance is open','en-US','103006','104002','122114','Allow new pre clearance to be created when earlier preclearance is open',1,GETDATE())
END
---rul_lbl_55199 Multiple Pre-Clearance above in a:----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55199)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55199,'rul_lbl_55199','Multiple Pre-Clearance above in a:','en-US','103006','104002','122114','Multiple Pre-Clearance above in a:',1,GETDATE())
END
---rul_lbl_55200 Pre-Clearance approval based on limit exceeding of only:----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55200)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55200,'rul_lbl_55200','Pre-Clearance approval based on limit exceeding of only:','en-US','103006','104002','122114','Pre-Clearance approval based on limit exceeding of only:',1,GETDATE())
END
---rul_lbl_55201 Auto Approval Required below entered value:----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55201)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55201,'rul_lbl_55201','Auto Approval Required below entered value:','en-US','103006','104002','122114','Auto Approval Required below entered value:',1,GETDATE())
END
---rul_lbl_55202 Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55202)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55202,'rul_lbl_55202','Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction','en-US','103006','104002','122114','Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction',1,GETDATE())
END
---rul_lbl_55203 Threshold Limit Reset----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55203)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55203,'rul_lbl_55203','Threshold Limit Reset','en-US','103006','104002','122114','Threshold Limit Reset',1,GETDATE())
END
---rul_lbl_55204 Contra Trade Based On----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55204)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55204,'rul_lbl_55204','Contra Trade Based On','en-US','103006','104002','122114','Contra Trade Based On',1,GETDATE())
END
---rul_lbl_55205 If Yes, Enter the declaration sought from the insider at the time of continuous disclosures----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55205)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55205,'rul_lbl_55205','If Yes, Enter the declaration sought from the insider at the time of continuous disclosures','en-US','103006','104002','122114','If Yes, Enter the declaration sought from the insider at the time of continuous disclosures',1,GETDATE())
END

---rul_lbl_55206 FORM for implementing company Required----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55206)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55206,'rul_lbl_55206','FORM for implementing company Required','en-US','103006','104002','122114','FORM for implementing company Required',1,GETDATE())
END

---rul_lbl_55207 Enable Pre-clearance without submitting the Period End Disclosures----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55207)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55207,'rul_lbl_55207','Enable Pre-clearance without submitting the Period End Disclosures','en-US','103006','104002','122114','Enable Pre-clearance without submitting the Period End Disclosures',1,GETDATE())
END
---rul_lbl_55208 Reason for Pre-clearance approval to be provided----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55208)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55208,'rul_lbl_55208','Reason for Pre-clearance approval to be provided','en-US','103006','104002','122114','Reason for Pre-clearance approval to be provided',1,GETDATE())
END

-----------------------Message Script----------------------

---rul_msg_55209 Applicable to date should be on or after applicable from date. ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55209)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55209,'rul_msg_55209','Applicable to date should be on or after applicable from date.','en-US','103006','104001','122113','Applicable to date should be on or after applicable from date.',1,GETDATE())
END

---rul_msg_55210 Please enter alphanumerics only----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55210)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55210,'rul_msg_55201','Please enter alphanumerics only','en-US','103006','104001','122114','Please enter alphanumerics only',1,GETDATE())
END

---rul_msg_55211 Special characters(*,(,),<,>) are not allowed.----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55211)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55211,'rul_msg_55211','Special characters(*,(,),<,>) are not allowed.','en-US','103006','104001','122114','Special characters(*,(,),<,>) are not allowed.',1,GETDATE())
END

---rul_msg_55212 Applicable to date should be on or after applicable from date.----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55212)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55212,'rul_msg_55212','Applicable to date should be grater than Current date.','en-US','103006','104001','122113','Applicable to date should be grater than Current date.',1,GETDATE())
END

---rul_msg_55213 Enter No. of Share max 8 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55213)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55213,'rul_msg_55213','Enter No. of Share max 8 digit number','en-US','103006','104001','122114','Enter No. of Share max 8 digit number',1,GETDATE())
END

---rul_msg_55214 Enter valid % of paid up & subscribed capital----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55214)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55214,'rul_msg_55214','Enter valid % of paid up & subscribed capital','en-US','103006','104001','122114','Enter valid % of paid up & subscribed capital',1,GETDATE())
END

---rul_msg_55215 Enter Prelearance CO approval limit Max 2 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55215)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55215,'rul_msg_55215','Enter Preclearance CO approval limit Max 2 digit number','en-US','103006','104001','122114','Enter Preclearance CO approval limit Max 2 digit number',1,GETDATE())
END
---rul_msg_55216 Enter Prelearance approval limit Max 2 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55216)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55216,'rul_msg_55216','Enter Preclearance approval limit Max 2 digit number','en-US','103006','104001','122114','Enter Preclearance approval limit Max 2 digit number',1,GETDATE())
END
---rul_msg_55217 Special characters(*,(,),<,>) are not allowed.----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55217)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55217,'rul_msg_55217','Special characters(*,(,),<,>) are not allowed.','en-US','103006','104001','122114','Special characters(*,(,),<,>) are not allowed.',1,GETDATE())
END
---rul_msg_55218 Enter Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within- Max 2 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55218)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55218,'rul_msg_55218','Enter Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within- Max 2 digit number','en-US','103006','104001','122114','Enter Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within- Max 2 digit number',1,GETDATE())
END
---rul_msg_55219 Enter Trade Disclosure Within - Max 2 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55219)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55219,'rul_msg_55219','Enter Trade Disclosure Within - Max 2 digit number','en-US','103006','104001','122114','Enter Trade Disclosure Within - Max 2 digit number',1,GETDATE())
END

---rul_msg_55220 Enter No. of Share max 8 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55220)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55220,'rul_msg_55220','Enter No. of Share max 8 digit number','en-US','103006','104001','122114','Enter No. of Share max 8 digit number',1,GETDATE())
END

---rul_msg_55221 Enter valid % of paid up & subscribed capital----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55221)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55221,'rul_msg_55221','Enter valid % of paid up & subscribed capital','en-US','103006','104001','122114','Enter valid % of paid up & subscribed capital',1,GETDATE())
END


---rul_msg_55222 Enter Value of Share max 10 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55222)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55222,'rul_msg_55222','Enter Value of Share max 10 digit number','en-US','103006','104001','122114','Enter Value of Share max 10 digit number',1,GETDATE())
END

---rul_msg_55223 Enter Trade (Continous) Disclosure submission to Stock Exchange by CO within -  Max 2 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55223)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55223,'rul_msg_55223','Enter Trade (Continous) Disclosure submission to Stock Exchange by CO within -  Max 2 digit number','en-US','103006','104001','122114','Enter Trade (Continous) Disclosure submission to Stock Exchange by CO within -  Max 2 digit number',1,GETDATE())
END

---rul_msg_55224 Enter Initial Disclosure within Max 2 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55224)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55224,'rul_msg_55224','Enter Initial Disclosure within Max 2 digit number','en-US','103006','104001','122114','Enter Initial Disclosure within Max 2 digit number',1,GETDATE())
END

---rul_msg_55225 Enter Contra trade not allowed for Max 3 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55225)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55225,'rul_msg_55225','Enter Contra trade not allowed for Max 3 digit number','en-US','103006','104001','122114','Enter Contra trade not allowed for Max 3 digit number',1,GETDATE())
END

---rul_msg_55226 Enter Period End Disclosure to be submitted by Insider to CO within Max 2 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55226)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55226,'rul_msg_55226','Enter Period End Disclosure to be submitted by Insider to CO within Max 2 digit number','en-US','103006','104001','122114','Enter Period End Disclosure to be submitted by Insider to CO within Max 2 digit number',1,GETDATE())
END

---rul_msg_55227 Enter Period End Disclosure to be submitted to Stock Exchanges by CO within Max 2 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55227)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55227,'rul_msg_55227','Enter Period End Disclosure to be submitted to Stock Exchanges by CO within Max 2 digit number','en-US','103006','104001','122114','Enter Period End Disclosure to be submitted to Stock Exchanges by CO within Max 2 digit number',1,GETDATE())
END

---rul_msg_55228 Enter Trading Details to be submitted by Insider/Employee to CO within Max 2 digit number----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55228)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55228,'rul_msg_55228','Enter Trading Details to be submitted by Insider/Employee to CO within Max 2 digit number','en-US','103006','104001','122114','Enter Trading Details to be submitted by Insider/Employee to CO within Max 2 digit number',1,GETDATE())
END

---rul_msg_55229 Special characters(*,(,),<,>) are not allowed.----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55229)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55229,'rul_msg_55229','Special characters(*,(,),<,>) are not allowed.','en-US','103006','104001','122114','Special characters(*,(,),<,>) are not allowed.',1,GETDATE())
END


---rul_msg_55230 Enter Minimum holding period Max 2 digit number.----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55230)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55230,'rul_msg_55230','Enter Minimum holding period Max 2 digit number','en-US','103006','104001','122114','Enter Minimum holding period Max 2 digit number',1,GETDATE())
END


---rul_lbl_55231 FORM for implementing company Required----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55231)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55231,'rul_lbl_55231','Trade (Continuous) Disclosure to be submitted by Insider/Employee to Company','en-US','103006','104002','122114','Trade (Continuous) Disclosure to be submitted by Insider/Employee to Company',1,GETDATE())
END

---------------------------------Create.chtml------------------------------


---rul_ttl_55232 Trading Policy Other Securities  Details----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55232)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55232,'rul_ttl_55232','Trading Policy Other Securities  Details','en-US','103006','104006','122114','Trading Policy Other Securities  Details',1,GETDATE())
END


---rul_ttl_55233 Trading Policy Information----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55233)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55233,'rul_ttl_55233','Trading Policy  Information','en-US','103006','104006','122114','Trading Policy Information',1,GETDATE())
END

---rul_ttl_55234 Trading Policy ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55234)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55234,'rul_ttl_55234','Trading Policy','en-US','103006','104006','122114','Trading Policy',1,GETDATE())
END

---rul_lbl_55235 Trading Policy ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55235)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55235,'rul_lbl_55235','Trading Policy','en-US','103006','104002','122114','Trading Policy',1,GETDATE())
END

---rul_lbl_55236 Insider ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55236)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55236,'rul_lbl_55236','Insider','en-US','103006','104002','122114','Insider',1,GETDATE())
END

---rul_lbl_55237 Employee ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55237)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55237,'rul_lbl_55237','Employee','en-US','103006','104002','122114','Employee',1,GETDATE())
END


---rul_ttl_55238 Pre-Clearance Requirement ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55238)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55238,'rul_ttl_55238','Pre-Clearance Requirement','en-US','103006','104006','122114','Pre-Clearance Requirement',1,GETDATE())
END

---rul_ttl_55239 Disclosure Frequency - Initial Disclosures : ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55239)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55239,'rul_ttl_55239','Disclosure Frequency - Initial Disclosures :','en-US','103006','104006','122114','Disclosure Frequency - Initial Disclosures :',1,GETDATE())
END

---rul_lbl_55240 Initial Disclosure  be submitted by the Insider/Employee to company ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55240)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55240,'rul_lbl_55240','Initial Disclosure  be submitted by the Insider/Employee to company','en-US','103006','104002','122114','Initial Disclosure  be submitted by the Insider/Employee to company',1,GETDATE())
END

---rul_lbl_55241 Required ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55241)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55241,'rul_lbl_55241','Required','en-US','103006','104002','122114','Required',1,GETDATE())
END

---rul_lbl_55242 Not Required ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55242)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55242,'rul_lbl_55242','Not Required','en-US','103006','104002','122114','Not Required',1,GETDATE())
END

---rul_lbl_55243 If Required,----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55243)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55243,'rul_lbl_55243','If Required,','en-US','103006','104002','122114','If Required,',1,GETDATE())
END

---rul_ttl_55244 Disclosure Frequency - Trade (Continuous) Disclosures :----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55244)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55244,'rul_ttl_55244','Disclosure Frequency - Trade (Continuous) Disclosures :','en-US','103006','104006','122114','Disclosure Frequency - Trade (Continuous) Disclosures :',1,GETDATE())
END

---rul_lbl_55245 Trade (Continuous) Disclosure to be submitted by Insider/Employee to Company----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55245)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55245,'rul_lbl_55245','Trade (Continuous) Disclosure to be submitted by Insider/Employee to Company','en-US','103006','104002','122114','Trade (Continuous) Disclosure to be submitted by Insider/Employee to Company',1,GETDATE())
END

---rul_lbl_55246 Yes----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55246)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55246,'rul_lbl_55246','Yes','en-US','103006','104002','122114','Yes',1,GETDATE())
END

---rul_lbl_55247 No----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55247)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55247,'rul_lbl_55247','No','en-US','103006','104002','122114','No',1,GETDATE())
END
---rul_lbl_55248 If Yes, Enter the declaration sought from the insider at the time of continuous disclosures----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55248)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55248,'rul_lbl_55248','If Yes, Enter the declaration sought from the insider at the time of continuous disclosures','en-US','103006','104002','122114','If Yes, Enter the declaration sought from the insider at the time of continuous disclosures',1,GETDATE())
END

---rul_lbl_55249 Declaration to be Mandatory----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55249)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55249,'rul_lbl_55249','Declaration to be Mandatory','en-US','103006','104002','122114','Declaration to be Mandatory',1,GETDATE())
END
---rul_lbl_55250 Display the declaration post submission of Continuous Disclosure----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55250)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55250,'rul_lbl_55250','Display the declaration post submission of Continuous Disclosure','en-US','103006','104002','122114','Display the declaration post submission of Continuous Disclosure',1,GETDATE())
END

---rul_ttl_55251 Disclosure Frequency - Period End Disclosures :----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55251)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55251,'rul_ttl_55251','Disclosure Frequency - Period End Disclosures :','en-US','103006','104006','122114','Disclosure Frequency - Period End Disclosures :',1,GETDATE())
END

---rul_lbl_55252 Period End Disclosures to be submitted by the Insider/Employee to Company : ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55252)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55252,'rul_lbl_55252','Period End Disclosures to be submitted by the Insider/Employee to Company : ','en-US','103006','104002','122114','Period End Disclosures to be submitted by the Insider/Employee to Company : ',1,GETDATE())
END

---rul_ttl_55253 General ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55253)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55253,'rul_ttl_55253','General','en-US','103006','104006','122114','General',1,GETDATE())
END

---rul_lbl_55254 Minimum holding period ----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55254)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55254,'rul_lbl_55254','Minimum holding period ','en-US','103006','104002','122114','Minimum holding period',1,GETDATE())
END

---rul_lbl_55255 days----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55255)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55255,'rul_lbl_55255','days','en-US','103006','104002','122114','days',1,GETDATE())
END

---dis_lbl_55256 Equity Shares----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55256)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55256,'dis_lbl_55256','Equity Shares','en-US','103006','104002','122083','Equity Shares ',1,GETDATE())
END


---rul_lbl_55257 Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55257)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55257,'rul_lbl_55257','Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction','en-US','103006','104002','122114','Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction',1,GETDATE())
END

---rul_ttl_55258 Contra Trade----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55258)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55258,'rul_ttl_55258','Contra Trade','en-US','103006','104006','122114','Contra Trade',1,GETDATE())
END

---rul_lbl_55259 Contra Trade Based On----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55259)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55259,'rul_lbl_55259','Contra Trade Based On','en-US','103006','104002','122114','Contra Trade Based On',1,GETDATE())
END

---rul_lbl_55260 All Security Type----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55260)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55260,'rul_lbl_55260','All Security Type','en-US','103006','104002','122114','All Security Type',1,GETDATE())
END

---rul_lbl_55261 Contra trade not allowed for----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55261)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55261,'rul_lbl_55261','Contra trade not allowed for','en-US','103006','104002','122114','Contra trade not allowed for',1,GETDATE())
END

---rul_lbl_55262 days from opposite direction----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55262)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55262,'rul_lbl_55262','days from opposite direction','en-US','103006','104002','122114','days from opposite direction',1,GETDATE())
END

---rul_lbl_55263 Exception for----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55263)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55263,'rul_lbl_55263','Exception for','en-US','103006','104002','122114','Exception for',1,GETDATE())
END

---rul_msg_55264 Save Trading policy section to upload the documents.----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55264)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55264,'rul_msg_55264','Save Trading policy section to upload the documents.','en-US','103006','104001','122114','Save Trading policy section to upload the documents.',1,GETDATE())
END

---rul_lbl_55265 Files to Upload----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55265)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55265,'rul_lbl_55265','Files to Upload','en-US','103006','104002','122114','Files to Upload',1,GETDATE())
END

---rul_lbl_55266 Files Uploaded----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55266)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55266,'rul_lbl_55266','Files Uploaded','en-US','103006','104002','122113','Files Uploaded',1,GETDATE())
END

---rul_lbl_55267 Policy Status----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55267)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55267,'rul_lbl_55267','Policy Status','en-US','103006','104002','122114','Policy Status',1,GETDATE())
END

---rul_lbl_55268 ACTIVATE----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55268)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55268,'rul_lbl_55268','ACTIVATE','en-US','103006','104002','122114','ACTIVATE',1,GETDATE())
END

---rul_lbl_55269 DEACTIVATE----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55269)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55269,'rul_lbl_55269','DEACTIVATE','en-US','103006','104002','122114','DEACTIVATE',1,GETDATE())
END

---rul_btn_55270 Define Applicability----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55270)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55270,'rul_btn_55270','Define Applicability','en-US','103006','104004','122114','Define Applicability',1,GETDATE())
END

---rul_btn_55271 View Applicability----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55271)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55271,'rul_btn_55271','View Applicability','en-US','103006','104004','122114','View Applicability',1,GETDATE())
END

---rul_lbl_55272 Individual Security Type----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55272)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55272,'rul_lbl_55272','Individual Security Type','en-US','103006','104002','122114','Individual Security Type',1,GETDATE())
END

---------rul_msg_55273(exiquted)------
--IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55273)
--BEGIN
--    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
--	VALUES
--     (55273,'rul_msg_55273',' Set the Contra Trade Option for Selection of QTY Yes/No configuration. Please contact the Administrator','en-US','103006','104001','122114','Set the Contra Trade Option for Selection of QTY Yes/No configuration. Please contact the Administrator',1,GETDATE())
--END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55274)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55274,'rul_lbl_55274','days after trade is performed','en-US','103006','104002','122114','days after trade is performed',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55275)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55275,'rul_lbl_55275','days of submission by the Insider/Employee','en-US','103006','104002','122114','days of submission by the Insider/Employee',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55276)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55276,'rul_lbl_55276','Single Transaction Trade above','en-US','103006','104002','122114','Single Transaction Trade above',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55277)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55277,'rul_lbl_55277','Multiple Transaction Trade above','en-US','103006','104002','122114','Multiple Transaction Trade above',1,GETDATE())
END


IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55278)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55278,'rul_lbl_55278','Continuous Disclosure required  for trade above:','en-US','103006','104002','122114','Continuous Disclosure required  for trade above:',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55279)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55279,'rul_lbl_55279','For All Security Type','en-US','103006','104002','122114','For All Security Type',1,GETDATE())
END


IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55280)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55280,'rul_lbl_55280','For Selected Security type','en-US','103006','104002','122114','For Selected Security type',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55281)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55281,'rul_lbl_55281','days of joining/being categorised as insider','en-US','103006','104002','122114','days of joining/being categorised as insider',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55282)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55282,'rul_lbl_55282','of application go live','en-US','103006','104002','122114','of application go live',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55283)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55283,'rul_lbl_55283','days after the period end','en-US','103006','104002','122114','days after the period end',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55284)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55284,'rul_lbl_55284','days after Insiders last day submission','en-US','103006','104002','122114','days after Insiders last day submission',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55309)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55309,'rul_lbl_55309','Pre-Clearance required for','en-US','103006','104002','122114','Pre-Clearance required for',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55310)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55310,'rul_lbl_55310','Allow Restricted List Search','en-US','103006','104002','122114','Allow Restricted List Search',1,GETDATE())
END


IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55285)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55285,'rul_lbl_55285','days by Compliance Officer','en-US','103006','104002','122114','days by Compliance Officer',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55286)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55286,'rul_lbl_55286','days (after approval is given excluding approval day)','en-US','103006','104002','122114','days (after approval is given excluding approval day)',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55287)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55287,'rul_lbl_55287','Allow before & after period end last submission date','en-US','103006','104002','122114','Allow before & after period end last submission date',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55288)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55288,'rul_lbl_55288','Allow till period end last submission date','en-US','103006','104002','122114','Allow till period end last submission date',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55289)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55289,'rul_lbl_55289','Single Pre-Clearance Request','en-US','103006','104002','122114','Single Pre-Clearance Request',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55290)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55290,'rul_lbl_55290','Multiple Pre-Clearance Request','en-US','103006','104002','122114','Multiple Pre-Clearance Request',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55291)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55291,'rul_ttl_55291','Trading policy users with overlapping trading policy(s)','en-US','103006','104006','122114','Trading policy users with overlapping trading policy(s)',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55097)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55097,'rul_msg_55097','Error occurred while fetching trading policy details.','en-US','103006','104001','122114','Error occurred while fetching trading policy details.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55098)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55098,'rul_msg_55098','Trading Policy Other security does not exist.','en-US','103006','104001','122114','Trading Policy Other security does not exist.',1,GETDATE())
END


IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55099)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55099,'rul_msg_55099','Error occurred while saving trading policy details.','en-US','103006','104001','122114','Error occurred while saving trading policy details.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55100)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55100,'rul_msg_55100','Invalid change of status for trading policy.','en-US','103006','104001','122114','Invalid change of status for trading policy.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55101)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55101,'rul_msg_55101','Applicable from and to dates are mandatory for trading policy.','en-US','103006','104001','122114','Applicable from and to dates are mandatory for trading policy.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55102)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55102,'rul_msg_55102','Applicable to date should be greater than applicable from date.','en-US','103006','104001','122114','Applicable to date should be greater than applicable from date.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55103)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55103,'rul_msg_55103','Mandatory : Trading policy for Insider/Employee.','en-US','103006','104001','122114','Mandatory : Trading policy for Insider/Employee.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55104)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55104,'rul_msg_55104','Mandatory : Trading policy name.','en-US','103006','104001','122114','Mandatory : Trading policy name.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55105)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55105,'rul_msg_55105','Mandatory : Trading policy description.','en-US','103006','104001','122114','Mandatory : Trading policy description.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55106)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55106,'rul_msg_55106','Mandatory : Approval required for all trades.','en-US','103006','104001','122114','Mandatory : Approval required for all trades.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55107)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55107,'rul_msg_55107','Mandatory : Any one/all of - No of Equity shares/% of paid up & subscribed capital/Value of Equity share.','en-US','103006','104001','122114','Mandatory : Any one/all of - No of Equity shares/% of paid up & subscribed capital/Value of Equity share.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55108)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55108,'rul_msg_55108','Mandatory : Prohibit preclearance during non-trading period.','en-US','103006','104001','122114','Mandatory : Prohibit preclearance during non-trading period.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55109)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55109,'rul_msg_55109','Mandatory : Preclearance approval to be given within X days by CO.','en-US','103006','104001','122114','Mandatory : Preclearance approval to be given within X days by CO.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55110)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55110,'rul_msg_55110','Mandatory : Preclearance approval validity X days (after approval is given excluding approval day).','en-US','103006','104001','122114','Mandatory : Preclearance approval validity X days (after approval is given excluding approval day).',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55111)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55111,'rul_msg_55111','Mandatory : Declaration for possession of UPSI to be sought from insider during preclearance.','en-US','103006','104001','122114','Mandatory : Declaration for possession of UPSI to be sought from insider during preclearance.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55112)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55112,'rul_msg_55112','Mandatory : Any one/both of - Complete trade not done for preclearance taken / Partial trade not done for preclearance taken.','en-US','103006','104001','122114','Mandatory : Any one/both of - Complete trade not done for preclearance taken / Partial trade not done for preclearance taken.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55113)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55113,'rul_msg_55113','Mandatory : Initial disclosure to be submitted by Insider/Employee to Company.','en-US','103006','104001','122114','Mandatory : Initial disclosure to be submitted by Insider/Employee to Company.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55114)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55114,'rul_msg_55114','Mandatory : Initial disclosure within X days of joining/being categorized as insider.','en-US','103006','104001','122114','Mandatory : Initial disclosure within X days of joining/being categorized as insider.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55115)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55115,'rul_msg_55115','Mandatory : Initial disclosure before X date of application go live.','en-US','103006','104001','122114','Mandatory : Initial disclosure before X date of application go live.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55116)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55116,'rul_msg_55116','Mandatory : Initial disclosure to be submitted by CO to stock exchange.','en-US','103006','104001','122114','Mandatory : Initial disclosure to be submitted by CO to stock exchange.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55117)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55117,'rul_msg_55117','Mandatory : Trade (continuous) disclosure to be submitted by Insider/Employee to CO after preclearance approval transactions within X days.','en-US','103006','104001','122114','Mandatory : Trade (continuous) disclosure to be submitted by Insider/Employee to CO after preclearance approval transactions within X days.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55118)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55118,'rul_msg_55118','Mandatory : Trade (continuous) disclosure to be submitted by Insider to CO for all trades.','en-US','103006','104001','122114','Mandatory : Trade (continuous) disclosure to be submitted by Insider to CO for all trades.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55119)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55119,'rul_msg_55119','Mandatory : Any one of - Single / Multiple transaction trade above.','en-US','103006','104001','122114','Mandatory : Any one of - Single / Multiple transaction trade above.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55120)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55120,'rul_msg_55120','Mandatory : Any one/all of - No of Equity shares/% of paid up & subscribed capital/Value of Equity share.','en-US','103006','104001','122114','Mandatory : Any one/all of - No of Equity shares/% of paid up & subscribed capital/Value of Equity share.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55121)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55121,'rul_msg_55121','Mandatory : Any one/all of - Transaction frequency-calendar or financial year/ No of Equity shares/% of paid up & subscribed capital/Value of Equity share.','en-US','103006','104001','122114','Mandatory : Any one/all of - Transaction frequency-calendar or financial year/ No of Equity shares/% of paid up & subscribed capital/Value of Equity share.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55122)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55122,'rul_msg_55122','Mandatory : Calendar/Financial year type.','en-US','103006','104001','122114','Mandatory : Calendar/Financial year type.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55123)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55123,'rul_msg_55123','Mandatory : Trade (continuous) disclosure to be submitted to stock exchange by CO.','en-US','103006','104001','122114','Mandatory : Trade (continuous) disclosure to be submitted to stock exchange by CO.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55124)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55124,'rul_msg_55124','Mandatory : Trade (continuous) disclosure submission to stock exchange by CO within X days of submission by insider/employee.','en-US','103006','104001','122114','Mandatory : Trade (continuous) disclosure submission to stock exchange by CO within X days of submission by insider/employee.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55125)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55125,'rul_msg_55125','Mandatory : Period end disclosure to be submitted by Insider/Employee to company.','en-US','103006','104001','122114','Mandatory : Period end disclosure to be submitted by Insider/Employee to company.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55126)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55126,'rul_msg_55126','Mandatory : Period end disclosure frequency.','en-US','103006','104001','122114','Mandatory : Period end disclosure frequency.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55127)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55127,'rul_msg_55127','Mandatory : Period end disclosure to be submitted by insider to CO within X days after period end.','en-US','103006','104001','122114','Mandatory : Period end disclosure to be submitted by insider to CO within X days after period end.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55128)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55128,'rul_msg_55128','Mandatory : Period end disclosure to be submitted to stock exchange by CO.','en-US','103006','104001','122114','Mandatory : Period end disclosure to be submitted to stock exchange by CO.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55129)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55129,'rul_msg_55129','Mandatory : Period end disclosure to be submitted to stock exchange by CO within X days after insider last day submission.','en-US','103006','104001','122114','Mandatory : Period end disclosure to be submitted to stock exchange by CO within X days after insider last day submission.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55130)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55130,'rul_msg_55130','Mandatory : Minimum holding period X days.','en-US','103006','104001','122114','Mandatory : Minimum holding period X days.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55131)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55131,'rul_msg_55131','Mandatory : Contra trade not allowed for X days from opposite transaction.','en-US','103006','104001','122114','Mandatory : Contra trade not allowed for X days from opposite transaction.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55132)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55132,'rul_msg_55132','Trading policy name already exists.','en-US','103006','104001','122114','Trading policy name already exists.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55133)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55133,'rul_msg_55133',' Error occurred while fetching list for trading policy transaction security.','en-US','103006','104001','122114',' Error occurred while fetching list for trading policy transaction security.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55134)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55134,'rul_msg_55134',' Error occurred while fetching list of history records of trading policy other security.','en-US','103006','104001','122114',' Error occurred while fetching list of history records of trading policy other security.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55142)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55142,'rul_msg_55142','Error occurred while deleting trading policy other security.','en-US','103006','104001','122113',' Error occurred while deleting trading policy other security.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55143)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55143,'rul_msg_55143','Cannot delete trading policy because it is active with ongoing applicable date range.','en-US','103006','104001','122113',' Cannot delete trading policy because it is active with ongoing applicable date range.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55144)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55144,'rul_msg_55144','Cannot delete this policy as old version exists.','en-US','103006','104001','122113',' Cannot delete this policy as old version exists.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55145)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55145,'rul_msg_55145','Cannot delete this policy as the applicability period has started and it is applicable to one or more users.','en-US','103006','104001','122113',' Cannot delete this policy as the applicability period has started and it is applicable to one or more users.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55146)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55146,'rul_msg_55146',' Error occurred while fetching trading policy other security list.','en-US','103006','104001','122114',' Error occurred while fetching trading policy other security list.',1,GETDATE())
END


IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55273)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55273,'rul_msg_55273',' Set the Contra Trade Option for Selection of QTY Yes/No configuration. Please contact the Administrator','en-US','103006','104001','122114','Set the Contra Trade Option for Selection of QTY Yes/No configuration. Please contact the Administrator',1,GETDATE())
END


IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55292)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55292,'rul_msg_55292','Mandatory : Enter at least one entry for Preclearance Required security type :','en-US','103006','104001','122114','Mandatory : Enter at least one entry for Preclearance Required security type :',1,GETDATE())
END


IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55293)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55293,'rul_msg_55293','Mandatory : Enter at least one entry for Preclearance Required security type.','en-US','103006','104001','122114','Mandatory : Enter at least one entry for Preclearance Required security type.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55294)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55294,'rul_msg_55294','Mandatory : Enter at least one entry for Continous discosure security type.','en-US','103006','104001','122114','Mandatory : Enter at least one entry for Continous discosure security type.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55295)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55295,'rul_msg_55295','Mandatory :- Continous Disclosure please select secuity type flag.','en-US','103006','104001','122114','Mandatory :- Continous Disclosure please select secuity type flag.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55296)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55296,'rul_msg_55296','Mandatory: Select value for Single Pre-Clearance Request & Multiple Pre-Clearance Request.','en-US','103006','104001','122114','Mandatory: Select value for Single Pre-Clearance Request & Multiple Pre-Clearance Request.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55297)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55297,'rul_msg_55297','Mandatory : Trade (Continuous) Disclosure to be submitted by Insider/Employee to Company.','en-US','103006','104001','122114','Mandatory : Trade (Continuous) Disclosure to be submitted by Insider/Employee to Company.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55298)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55298,'rul_msg_55298','Mandatory : Trading Details to be submitted by Insider/Employee to CO within.','en-US','103006','104001','122114','Mandatory : Mandatory : Trading Details to be submitted by Insider/Employee to CO within.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55299)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55299,'rul_msg_55299','Mandatory: Select value for Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction.','en-US','103006','104001','122114','Mandatory: Select value for Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55300)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55300,'rul_msg_55300','Mandatory: Select Cash and Cashless Partial Exercise Option(EOSP & Other).','en-US','103006','104001','122114','Mandatory: Select Cash and Cashless Partial Exercise Option(EOSP & Other).',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55301)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55301,'rul_msg_55301','Mandatory:Please select at least on Security Type for Contra Trade based on.','en-US','103006','104001','122114','Mandatory:Please select at least on Security Type for Contra Trade based on.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55302)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55302,'rul_msg_55302','Mandatory: Applicability is not defined in this trading policy.','en-US','103006','104001','122114','Mandatory: Applicability is not defined in this trading policy.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55303)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55303,'rul_msg_55303','Mandatory:Please select at least on Security Type for Contra Trade based on.','en-US','103006','104001','122114','Mandatory:Please select at least on Security Type for Contra Trade based on.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55304)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55304,'rul_msg_55304','Policy Name :- $1 deactivate Successfully.','en-US','103006','104001','122114','Policy Name :- $1 deactivate Successfully.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55305)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55305,'rul_msg_55305','Policy Name :- $1 saved successfully.','en-US','103006','104001','122114','Policy Name :- $1 saved successfully.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55306)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55306,'rul_msg_55306','Trading Policy deleted successfully.','en-US','103006','104001','122114','Trading Policy deleted successfully.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55307)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55307,'rul_msg_55307','Mandatory :- Preclearance Requirement,please select security flag.','en-US','103006','104001','122114','Mandatory :- Preclearance Requirement,please select security flag.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55308)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55308,'rul_msg_55308','Mandatory : Trading Policy Type.','en-US','103006','104001','122114','Mandatory : Trading Policy Type.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55311)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55311,'rul_lbl_55311','Perpetual','en-US','103006','104002','122114','Perpetual',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55312)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55312,'rul_lbl_55312','Limited','en-US','103006','104002','122114','Limited',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55313)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55313,'rul_lbl_55313','Yes','en-US','103006','104002','122114','Yes',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55314)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55314,'rul_lbl_55314','No','en-US','103006','104002','122114','No',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55315)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55315,'rul_lbl_55315','Pre-Clearance required','en-US','103006','104002','122114','Pre-Clearance required',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55316)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55316,'rul_lbl_55316','Allow pre-clearance if non-implementing company Demat account is zero(0)','en-US','103006','104002','122114','Allow pre-clearance if non-implementing company Demat account is zero(0)',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55317)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55317,'rul_lbl_55317','Form F File','en-US','103006','104002','122114','Form F File',1,GETDATE())
END

--rul_lbl_55318 FORM for implementing company Required----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55318)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55318,'rul_lbl_55318','FORM Required','en-US','103006','104002','122114','FORM Required',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55319)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55319,'rul_lbl_55319','FORM F file','en-US','103006','104002','122114','FORM F file',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55320)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55320,'rul_lbl_55320','Pre-Clearance Form required for restricted list company','en-US','103006','104002','122114','Pre-Clearance Form required for restricted list company',1,GETDATE())
END


IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55321)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55321,'rul_lbl_55321','RLSearchLimit','en-US','103006','104002','122114','RLSearchLimit',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55322)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55322,'rl_msg_55322','Restricted list limited search field can not be Zero(0).It should be anything between 1 to 99','en-US','103006','104002','122114','Restricted list limited search field can not be Zero(0).It should be anything between 1 to 99',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55323)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55323,'rl_msg_55323','Restricted list limited search field must be numeric','en-US','103006','104002','122114','Restricted list limited search field must be numeric',1,GETDATE())
END

-----rul_grd_55147 Type Of Security list -----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55324)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55324,'rul_grd_55324','Type Of Securities','en-US','103006','104003','122114','Type Of Securities',1,GETDATE())
END

-----rul_grd_55148 No. Of Share list -----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55325)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55325,'rul_grd_55325','No. Of Share','en-US','103006','104003','122114','No. Of Share',1,GETDATE())
END

-----rul_grd_55149 % Of Paid & Subscribed Capital list -----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55326)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55326,'rul_grd_55326','% Of Paid & Subscribed Capital','en-US','103006','104003','122114','% Of Paid & Subscribed Capital',1,GETDATE())
END


-----rul_grd_55150 Value Of Share list -----
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55327)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55327,'rul_grd_55327','Value Of Share','en-US','103006','104003','122114','Value Of Share',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55367)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55367,'rul_msg_55367','Mandatory : Preclearance Without Period End Disclosure','en-US','103006','104001','122114','Mandatory : Preclearance Without Period End Disclosure',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55368)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55368,'rul_msg_55368','Mandatory: Select value for Single Pre-Clearance Request & Multiple Pre-Clearance Request.','en-US','103006','104001','122114','Mandatory: Select value for Single Pre-Clearance Request & Multiple Pre-Clearance Request.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55369)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55369,'rul_msg_55369','Mandatory: Enter Search Limit','en-US','103006','104001','122114','Mandatory: Enter Search Limit',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55370)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55370,'rul_msg_55370','Applicable from date should be greater than todays date.','en-US','103006','104001','122114','Applicable from date should be greater than todays date.',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55371)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55371,'rul_msg_55371','Mandatory : Declaration for possession of UPSI to be sought from insider during continuous','en-US','103006','104001','122114','Mandatory : Declaration for possession of UPSI to be sought from insider during continuous',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55380)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55380,'rul_msg_55380','Mandatory : Pre-Clearance required for - Transaction Type selection and Security Type selection','en-US','103006','104001','122114','Mandatory : Pre-Clearance required for - Transaction Type selection and Security Type selection',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55381)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55381,'rul_msg_55381','Mandatory :Select atleast one Security Type against the Buy','en-US','103006','104001','122114','Mandatory :Select atleast one Security Type against the Buy',1,GETDATE())
END
IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55382)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55382,'rul_msg_55382','Mandatory : Select atleast one Security Type against the Sell','en-US','103006','104001','122114','Mandatory : Select atleast one Security Type against the Sell',1,GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=515515)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
      (515515,'reason for not traded is not required',515,'reason for not traded is not required',1,1,145002,null,null,1,GETDATE())
END


-----------------------------------------------/* INSERT INTO com_GridHeaderSetting*/-----------------------------------------
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55089')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114129,'rul_grd_55089',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55090')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114129,'rul_grd_55090',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55091')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114129,'rul_grd_55091',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55092')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114129,'rul_grd_55092',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55093')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114129,'rul_grd_55093',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_11073' and GridTypeCodeId='114129')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114129,'usr_grd_11073',1,9,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55135'and GridTypeCodeId='114130')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114130,'rul_grd_55135',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55136' and GridTypeCodeId='114130')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114130,'rul_grd_55136',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55137' and GridTypeCodeId='114130')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114130,'rul_grd_55137',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55138' and GridTypeCodeId='114130')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114130,'rul_grd_55138',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55139' and GridTypeCodeId='114130')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114130,'rul_grd_55139',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55140' and GridTypeCodeId='114130')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114130,'rul_grd_55140',1,6,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55141' and GridTypeCodeId='114130')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114130,'rul_grd_55141',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_11073' and GridTypeCodeId='114130')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114130,'usr_grd_11073',1,9,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55324' and GridTypeCodeId='114131')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114131,'rul_grd_55324',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55325' and GridTypeCodeId='114131')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114131,'rul_grd_55325',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55326' and GridTypeCodeId='114131')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114131,'rul_grd_55326',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55327' and GridTypeCodeId='114131')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114131,'rul_grd_55327',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_11228' and GridTypeCodeId='114132')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114132,'usr_grd_11228',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55330' and GridTypeCodeId='114132')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114132,'rul_grd_55330',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55331' and GridTypeCodeId='114132')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114132,'rul_grd_55331',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55332' and GridTypeCodeId='114132')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114132,'rul_grd_55332',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55333' and GridTypeCodeId='114132')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114132,'rul_grd_55333',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55334' and GridTypeCodeId='114132')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114132,'rul_grd_55334',1,6,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55342' and GridTypeCodeId='114132')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114132,'rul_grd_55342',1,7,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55343' and GridTypeCodeId='114132')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114132,'rul_grd_55343',1,8,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55344' and GridTypeCodeId='114132')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114132,'rul_grd_55344',1,9,0,155001,NULL,NULL)
END


IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_11228' and GridTypeCodeId='114133')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114133,'usr_grd_11228',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55330' and GridTypeCodeId='114133')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114133,'rul_grd_55330',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55331' and GridTypeCodeId='114133')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114133,'rul_grd_55331',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55332' and GridTypeCodeId='114133')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114133,'rul_grd_55332',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55333' and GridTypeCodeId='114133')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114133,'rul_grd_55333',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55334' and GridTypeCodeId='114133')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114133,'rul_grd_55334',1,6,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_11228' and GridTypeCodeId='114139')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114139,'usr_grd_11228',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55363' and GridTypeCodeId='114139')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114139,'rul_grd_55363',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55362' and GridTypeCodeId='114139')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114139,'rul_grd_55362',1,3,0,155001,NULL,NULL)
END
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55361' and GridTypeCodeId='114139')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114139,'rul_grd_55361',1,4,0,155001,NULL,NULL)
END
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55359' and GridTypeCodeId='114139')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114139,'rul_grd_55359',1,5,0,155001,NULL,NULL)
END
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55358' and GridTypeCodeId='114139')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114139,'rul_grd_55358',1,6,0,155001,NULL,NULL)
END
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55357' and GridTypeCodeId='114139')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114139,'rul_grd_55357',1,7,0,155001,NULL,NULL)
END


------------------------------Alter Trading Policy Table------------------------------------------------------
	 
IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'rul_TradingPolicy_OS' AND SYSCOL.NAME = 'IsPreClearanceRequired')
BEGIN
	ALTER TABLE rul_TradingPolicy_OS ADD IsPreClearanceRequired INT 
END

IF NOT EXISTS(select * from rl_RestrictedListConfig WHERE Id=1)
BEGIN
	insert into rl_RestrictedListConfig
	values (528001,NULL,535001,0,0)
END

IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'rul_TradingPolicy_OS' AND SYSCOL.NAME = 'RestrictedListConfigId')
BEGIN
	ALTER TABLE rul_TradingPolicy_OS
    ADD RestrictedListConfigId INTEGER
    FOREIGN KEY(RestrictedListConfigId) REFERENCES rl_RestrictedListConfig(Id);
END


IF NOT EXISTS ( SELECT * FROM rul_TransactionSecurityMapConfig_OS 
                    WHERE MapToTypeCodeId=132015 and TransactionTypeCodeId=143001 and SecurityTypeCodeId=139001)
BEGIN
 INSERT INTO rul_TransactionSecurityMapConfig_OS 

    SELECT 132015 AS MapToTypeCodeId,    143001 AS TransactionTypeCodeId,     139001 AS  SecurityTypeCodeId
    UNION  
    SELECT 132015 AS MapToTypeCodeId,    143001 AS TransactionTypeCodeId,     139002 AS  SecurityTypeCodeId
    UNION  
    Select 132015 AS MapToTypeCodeId,    143001 AS TransactionTypeCodeId,     139003 AS  SecurityTypeCodeId
    UNION  
    Select 132015 AS MapToTypeCodeId,    143001 AS TransactionTypeCodeId,     139004 AS  SecurityTypeCodeId
    UNION  
    Select 132015 AS MapToTypeCodeId,    143001 AS TransactionTypeCodeId,     139005 AS  SecurityTypeCodeId
    UNION  
    Select 132015 AS MapToTypeCodeId,    143002 AS TransactionTypeCodeId,     139001 AS  SecurityTypeCodeId
    UNION  
    Select 132015 AS MapToTypeCodeId,    143002 AS TransactionTypeCodeId,     139002 AS  SecurityTypeCodeId
    UNION  
    Select 132015 AS MapToTypeCodeId,    143002 AS TransactionTypeCodeId,     139003 AS  SecurityTypeCodeId
    UNION  
    Select 132015 AS MapToTypeCodeId,    143002 AS TransactionTypeCodeId,     139004 AS  SecurityTypeCodeId
    UNION  
    Select 132015 AS MapToTypeCodeId,    143002 AS TransactionTypeCodeId,     139005 AS  SecurityTypeCodeId
    UNION  
    Select 132015 AS MapToTypeCodeId,    143003 AS TransactionTypeCodeId,     139001 AS  SecurityTypeCodeId
    UNION  
    Select 132015 AS MapToTypeCodeId,    143004 AS TransactionTypeCodeId,     139001 AS  SecurityTypeCodeId
    UNION  
    Select 132015 AS MapToTypeCodeId,    143005 AS TransactionTypeCodeId,     139001 AS  SecurityTypeCodeId 

END

-----------------Code for Overlapping Trading Policy Details -------------------------------------------------------------



IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55374)
BEGIN
INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
VALUES
(55374, 'rul_grd_55374', 'User Id', 'en-Us', 103006, 104003, 122114, 'User Id', 1 , GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55375)
BEGIN
INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
VALUES
(55375, 'rul_grd_55375', 'User Type', 'en-Us', 103006, 104003, 122114, 'User Type', 1 , GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55376)
BEGIN
INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
VALUES
(55376, 'rul_grd_55376', 'Name', 'en-Us', 103006, 104003, 122114, 'Name', 1 , GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55377)
BEGIN
INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
VALUES
(55377, 'rul_grd_55377', 'Trading Policy Name', 'en-Us', 103006, 104003, 122114, 'Trading Policy Name', 1 , GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55378)
BEGIN
INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
VALUES
(55378, 'rul_grd_55378', 'Applicable From Date ', 'en-Us', 103006, 104003, 122114, 'Applicable From Date', 1 , GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55379)
BEGIN
INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
VALUES
(55379, 'rul_grd_55379', 'Applicable To Date ','en-Us', 103006, 104003, 122114,'Applicable To Date', 1 , GETDATE())
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55374')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES 
	(114150,'rul_grd_55374',1,1,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55375')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES 
	(114150,'rul_grd_55375',1,2,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55376')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES 
	(114150,'rul_grd_55376',1,3,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55377')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES 
	(114150,'rul_grd_55377',1,4,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55378')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES 
	(114150,'rul_grd_55378',1,5,0,155001,NULL,NULL)
END

IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'rul_grd_55379')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES 
	(114150,'rul_grd_55379',1,6,0,155001,NULL,NULL)
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55330)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55330,'rul_grd_55330','Employee Name','en-US','103006','104003','122115','Employee Name',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55331)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55331,'rul_grd_55331','Employee Id','en-US','103006','104003','122115','Employee Id',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55332)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55332,'rul_grd_55332','Department','en-US','103006','104003','122115','Department',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55333)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55333,'rul_grd_55333','Grade','en-US','103006','104003','122115','Grade',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55334)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55334,'rul_grd_55334','Designation','en-US','103006','104003','122115','Designation',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55342)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55342,'rul_grd_55342','Category','en-US','103006','104003','122115','Category',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55343)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55343,'rul_grd_55343','Sub Category','en-US','103006','104003','122115','Sub Category',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55344)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55344,'rul_grd_55344','Role','en-US','103006','104003','122115','Role',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55328)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55328,'rul_lbl_55328','Yes','en-US','103006','104002','122114','Yes',1,GETDATE())
END

IF NOT EXISTS (SELECT ResourceId from mst_Resource where ResourceId=55329)
BEGIN
    INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
	VALUES
     (55329,'rul_grd_55329','No','en-US','103006','104002','122114','No',1,GETDATE())
END


