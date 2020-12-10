/*
	Scripts By Parag on 27 October 2016
	Resource for fixes made in axis bank code for date of acquisition validation
*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17530)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(17530, 'dis_msg_17530', 'Cannot submit disclosure because disclosure of earlier data of acquisition is not submitted. Please submit transcation whos date of acquisition earlier than current transcation''s date of acquistion.', 'Cannot submit disclosure because disclosure of earlier data of acquisition is not submitted. Please submit transcation whos date of acquisition earlier than current transcation''s date of acquistion.', 'en-US', 103009, 104001, 122048, 1, GETDATE())
END

/*
	Scripts By Tushar on 27 October 2016
	Resource for fixes made in axis bank code for calculating  Percentage of pre & post transaction for securities.
*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17531)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(17531, 'dis_msg_17531', 'Error occurred while calculating  Percentage of pre & post transaction for securities.', 'Error occurred while calculating  Percentage of pre & post transaction for securities.', 'en-US', 103009, 104001, 122048, 1, GETDATE())
END


/*
	Scripts By Parag on 07 October 2016
	Add follwoing scripts
		- activity and assign activity to role type 
		- activity URL mapping for page
		- new screen for restricted list setting page
*/

IF NOT EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID = 218)
BEGIN
	INSERT INTO usr_Activity
		(ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, [Description], StatusCodeID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES 
		(218, 'Restricted List', 'Restricted List Settings', 103301, NULL, 'Create right for Restricted List settings', 105001, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101002 AND ActivityId = 218)
BEGIN
	-- add activity for CO
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101002, ActivityId FROM usr_Activity WHERE ActivityID = 218
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 218 AND ControllerName = 'RestrictedList' AND ActionName = 'RestrictedListSettings')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(218, 'RestrictedList', 'RestrictedListSettings', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 218 AND ControllerName = 'RestrictedList' AND ActionName = 'SaveRestrictedListSettings')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(218, 'RestrictedList', 'SaveRestrictedListSettings', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122091)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(122091, 103301, 'Restricted List Settings', NULL, 122, 'Screen - Restricted List Settings', 1, 1, GETDATE(), 103)
END



/*
	Tushar 12-Oct-2016
	Description:- Activity,User type activity, Menus & activity url script for Security Transfer
	

*/

IF NOT EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID = 219)
BEGIN
	INSERT INTO usr_Activity
		(ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES 
		(219, 'Security Transfer', 'Holding List', 103002, NULL, 
		'Security Holding List', 105001, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID = 220)
BEGIN
	INSERT INTO usr_Activity
		(ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES 
		(220, 'Security Transfer', 'Transfer', 103002, NULL, 
		'Security', 105001, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID = 221)
BEGIN
	INSERT INTO usr_Activity
		(ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES 
		(221, 'Security Transfer', 'Security Transfer Report', 103002, NULL, 
		'Security Transfer Report - Insider', 105001, 1, GETDATE(), 1, GETDATE())
END

--Holding List
IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101003 AND ActivityId = 219)
BEGIN
	-- add activity for Employee
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101003, ActivityId FROM usr_Activity WHERE ActivityID = 219
END

IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101004 AND ActivityId = 219)
BEGIN
	-- add activity for Corporate User
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101004, ActivityId FROM usr_Activity WHERE ActivityID = 219
END

IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101006 AND ActivityId = 219)
BEGIN
	-- add activity for Non Employee
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101006, ActivityId FROM usr_Activity WHERE ActivityID = 219
END

--Transfer Screen
IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101003 AND ActivityId = 220)
BEGIN
	-- add activity for Employee
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101003, ActivityId FROM usr_Activity WHERE ActivityID = 220
END

IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101004 AND ActivityId = 220)
BEGIN
	-- add activity for Corporate User
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101004, ActivityId FROM usr_Activity WHERE ActivityID = 220
END

IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101006 AND ActivityId = 220)
BEGIN
	-- add activity for Non Employee
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101006, ActivityId FROM usr_Activity WHERE ActivityID = 220
END

--Transfer Report
IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101003 AND ActivityId = 221)
BEGIN
	-- add activity for Employee
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101003, ActivityId FROM usr_Activity WHERE ActivityID = 221
END

IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101004 AND ActivityId = 221)
BEGIN
	-- add activity for Corporate User
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101004, ActivityId FROM usr_Activity WHERE ActivityID = 221
END

IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101006 AND ActivityId = 221)
BEGIN
	-- add activity for Non Employee
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101006, ActivityId FROM usr_Activity WHERE ActivityID = 221
END

IF NOT EXISTS(SELECT MenuID FROM mst_MenuMaster WHERE MenuID = 54)
BEGIN
INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
VALUES
(54 ,'Security Transfer','Security Transfer','/SecurityTransfer/Index?acid=219',1498,1,102001,NULL,NULL,219,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 219 AND ControllerName = 'SecurityTransfer' AND ActionName = 'Index')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(219, 'SecurityTransfer', 'Index', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 220 AND ControllerName = 'SecurityTransfer' AND ActionName = 'Transfer')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(220, 'SecurityTransfer', 'Transfer', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 221 AND ControllerName = 'SecurityTransfer' AND ActionName = 'TransferReport')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(221, 'SecurityTransfer', 'TransferReport', NULL, 1, GETDATE(), 1, GETDATE())
END



/*
	
	CO 

*/


IF NOT EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID = 222)
BEGIN
	INSERT INTO usr_Activity
		(ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES 
		(222, 'Report', 'Security Transfer Report', 103011, NULL, 
		'Security Transfer Report - CO', 105001, 1, GETDATE(), 1, GETDATE())
END


IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101001 AND ActivityId = 222)
BEGIN
	-- add activity for Employee
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101001, ActivityId FROM usr_Activity WHERE ActivityID = 222
END

IF NOT EXISTS(SELECT ActivityId FROM usr_UserTypeActivity WHERE UserTypeCodeId = 101002 AND ActivityId = 222)
BEGIN
	-- add activity for Employee
	INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
	SELECT 101002, ActivityId FROM usr_Activity WHERE ActivityID = 222
END


IF NOT EXISTS(SELECT MenuID FROM mst_MenuMaster WHERE MenuID = 55)
BEGIN
INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
VALUES
(55 ,'Security Transfer Report','Security Transfer Report','/SecurityTransfer/TransferReportCO?acid=222',3509,36,102001,NULL,NULL,222,1,GETDATE(),1,GETDATE())
END


IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 222 AND ControllerName = 'SecurityTransfer' AND ActionName = 'TransferReportCO')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(222, 'SecurityTransfer', 'TransferReportCO', NULL, 1, GETDATE(), 1, GETDATE())
END


IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 13123)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(13123, 'cmp_ttl_13123', 'Company Level Configuration', 'en-US', 103005, 104006, 122084, 'Company Level Configuration', 1, GETDATE())
END


/*
	Scripts By Parag on 12 October 2016
	Add follwoing scripts for new menu for Restricted List setting
*/
IF NOT EXISTS(select MenuID from mst_MenuMaster where MenuID = 56)
BEGIN
	INSERT INTO mst_MenuMaster
		(MenuID, MenuName, [Description], MenuURL, DisplayOrder, ParentMenuID, StatusCodeID, ImageURL, ToolTipText, ActivityID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(56, 'Restricted List', 'Restricted List Menu', NULL, 51, NULL, 102001, 'glyphicon glyphicon-cog', NULL, 218, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(select MenuID from mst_MenuMaster where MenuID = 57)
BEGIN
	INSERT INTO mst_MenuMaster
		(MenuID, MenuName, [Description], MenuURL, DisplayOrder, ParentMenuID, StatusCodeID, ImageURL, ToolTipText, ActivityID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(57, 'Restricted List Settings', 'Restricted List Settings Sub-Menu', '/RestrictedList/RestrictedListSettings?acid=218', 5101, 56, 102001, NULL, NULL, 218, 1, GETDATE(), 1, GETDATE())
END

/*
	Scripts By Parag on 12 October 2016
	Add follwoing scripts for page resources and message
*/

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50368)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50368, 'rl_ttl_50368', 'Restricted List Settings', 'Restricted List Settings', 'en-US', 103301, 104006, 122091, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50369)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50369, 'rl_lbl_50369', 'Pre-clearance required', 'Pre-clearance required', 'en-US', 103301, 104002, 122091, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50370)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50370, 'rl_lbl_50370', 'Pre-clearance approval', 'Pre-clearance approval', 'en-US', 103301, 104002, 122091, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50371)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50371, 'rl_lbl_50371', 'Allow pre-clearance if non-implementing company Demat account is zero(0)', 'Allow pre-clearance if non-implementing company Demat account is zero(0)', 'en-US', 103301, 104002, 122091, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50372)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50372, 'rl_lbl_50372', 'Pre-Clearance Form required for restricted list company', 'Pre-Clearance Form required for restricted list company', 'en-US', 103301, 104002, 122091, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50373)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50373, 'rl_lbl_50373', 'Form F File', 'Form F File', 'en-US', 103301, 104002, 122091, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50374)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50374, 'rl_lbl_50374', 'Auto', 'Auto', 'en-US', 103301, 104002, 122091, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50375)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50375, 'rl_lbl_50375', 'Manual', 'Manual', 'en-US', 103301, 104002, 122091, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50376)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50376, 'rl_lbl_50376', 'Yes', 'Yes', 'en-US', 103301, 104002, 122091, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50377)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50377, 'rl_lbl_50377', 'No', 'No', 'en-US', 103301, 104002, 122091, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50378)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50378, 'rl_msg_50378', 'Restricted List Setting saved Successfully', 'Restricted List Setting saved Successfully', 'en-US', 103301, 104001, 122091, 1, GETDATE())
END

/*
	Scripts By Tushar on 13 October 2016
	Create table for Security Transfer log
*/

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'usr_SecurityTransferLog'))
BEGIN
CREATE TABLE usr_SecurityTransferLog
	(
		SecurityTransaferID BIGINT NOT NULL IDENTITY (1, 1), 
		UserInfoId INT NOT NULL CONSTRAINT FK_usr_SecurityTransfer_UserInfoId_usr_UserInfo_UserInfoId FOREIGN KEY(UserInfoId) REFERENCES usr_UserInfo(UserInfoId),
		ForUserInfoId INT NOT NULL CONSTRAINT FK_usr_SecurityTransfer_ForUserInfoId_usr_UserInfo_UserInfoId FOREIGN KEY(ForUserInfoId) REFERENCES usr_UserInfo(UserInfoId),
		FromDEMATAcountID INT NOT NULL CONSTRAINT FK_usr_SecurityTransfer_FromDEMATAcountID_usr_DMATDetails_DMATDetailsID FOREIGN KEY(FromDEMATAcountID) REFERENCES usr_DMATDetails(DMATDetailsID),
		SecurityTypeCodeID INT NOT NULL CONSTRAINT FK_usr_SecurityTransfer_SecurityTypeCodeID_com_Code_CodeID FOREIGN KEY(SecurityTypeCodeID) REFERENCES com_Code(CodeID),
		ToDEMATAcountID INT NOT NULL CONSTRAINT FK_usr_SecurityTransfer_ToDEMATAcountID_usr_DMATDetails_DMATDetailsID FOREIGN KEY(ToDEMATAcountID) REFERENCES usr_DMATDetails(DMATDetailsID),
		TransferDate DATETIME NOT NULL,
		TransferQuantity DECIMAL(15,0) NOT NULL,
		CreatedBy INT NOT NULL CONSTRAINT FK_usr_SecurityTransfer_CreatedBy_usr_UserInfo_UserInfoId FOREIGN KEY(CreatedBy) REFERENCES usr_UserInfo(UserInfoId),
		CreatedOn DATETIME NOT NULL,
		ModifiedBy INT NOT NULL CONSTRAINT FK_usr_SecurityTransfer_ModifiedBy_usr_UserInfo_UserInfoId FOREIGN KEY(ModifiedBy) REFERENCES usr_UserInfo(UserInfoId),
		ModifiedOn DATETIME NOT NULL,
	)
END

/*
	Scripts By Parag on 12 October 2016
	Add follwoing scripts for activity URL mapping for restricted list setting page
*/
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 218 AND ControllerName = 'Document' AND ActionName = 'UploadDocument')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(218, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 218 AND ControllerName = 'Document' AND ActionName = 'Download')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(218, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 218 AND ControllerName = 'Document' AND ActionName = 'DeleteSingleDocumentDetails')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(218, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50379)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(50379, 'rl_msg_50379', 'Current Form F File', 'Current Form F File', 'en-US', 103301, 104001, 122091, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 17529)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(17529, 'dis_msg_17529', 'Can not take pre-clearance because demat account do not have balance', 'Can not take pre-clearance because demat account do not have balance', 'en-US', 103009, 104001, 122086, 1, GETDATE())
END

/*	
	Raghvendra
	Created On:- 14-Oct-2016
	Description:- Create table to store placeholders categorized based on template communication mode code (CodeGroup : 156 from com_Code)
*/

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'com_PlaceholderMaster'))
BEGIN
	CREATE TABLE com_PlaceholderMaster
	(
		PlaceholderMasterId INT NOT NULL IDENTITY (1, 1),
		PlaceholderTag	NVARCHAR(512) NOT NULL,
		PlaceholderDisplayName NVARCHAR(1000) NOT NULL,
		PlaceholderGroupId INT NOT NULL CONSTRAINT FK_com_PlaceholderMaster_PlaceholderGroupId_com_Code_CodeID FOREIGN KEY(PlaceholderGroupId) REFERENCES com_Code(CodeID),
		PlaceholderDescription NVARCHAR(2000),
		IsVisible	BIT NOT NULL DEFAULT 1,
		DisplayOrder INT NOT NULL,
		CreatedBy INT NOT NULL CONSTRAINT FK_com_PlaceholderMaster_CreatedBy_UserInfo_UserInfoId FOREIGN KEY(CreatedBy) REFERENCES usr_UserInfo(UserInfoId),
		CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
		ModifiedBy INT NOT NULL CONSTRAINT FK_com_PlaceholderMaster_ModifiedBy_UserInfo_UserInfoId FOREIGN KEY(ModifiedBy) REFERENCES usr_UserInfo(UserInfoId),
		ModifiedOn DATETIME NOT NULL DEFAULT GETDATE(),
		CONSTRAINT [PK_com_PlaceholderMaster] PRIMARY KEY CLUSTERED 
		(
			[PlaceholderMasterId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

/* INSERT placeholders to the newly created table for Templates of Email and Form E */
--Insert placeholders related to Communication Mode : Email
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|LOGIN_ID|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|LOGIN_ID|~|', 'Login UserName', 156002, 'Username used for login', 1, 1, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|FIRST_NAME|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|FIRST_NAME|~|', 'Firstname/Contact Person', 156002, 'Firstname/Name of Contact Person as specified in user details', 1, 2, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|MIDDLE_NAME|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|MIDDLE_NAME|~|', 'Middlename', 156002, 'Middlename as specified in user details', 1, 3, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|LAST_NAME|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|LAST_NAME|~|', 'Lastname', 156002, 'Lastname as specified in user details', 1, 4, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|USER_ID|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|USER_ID|~|', 'EmployeeId', 156002, 'EmployeeId of Employee/Employee Insider, will be replaced as ''-'' when not applicable', 1, 5, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|COMPANY_NAME|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|COMPANY_NAME|~|', 'Company Name', 156002, 'Company name as specified in user details', 1, 6, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|EMAIL_ID|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|EMAIL_ID|~|', 'EmailId', 156002, 'EmailId as specified in user details', 1, 7, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|MOBILE_NUMBER|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|MOBILE_NUMBER|~|', 'Mobile Number', 156002, 'Mobile Number as specified in user details', 1, 8, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|COUNTRY|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|COUNTRY|~|', 'Country', 156002, 'Country as specified in user details', 1, 9, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|ADDRESS|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|ADDRESS|~|', 'Address', 156002, 'Address as specified in user details', 1, 10, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PIN_CODE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PIN_CODE|~|', 'Pincode', 156002, 'Pincode as specified in user details', 1, 11, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|GRADE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|GRADE|~|', 'Grade', 156002, 'Grade as specified in user details', 1, 12, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|DESIGNATION|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|DESIGNATION|~|', 'Designation', 156002, 'Designation as specified in user details', 1, 13, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|SUB_DESIGNATION|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|SUB_DESIGNATION|~|', 'Sub-Designation', 156002, 'Sub-Designation as specified in user details', 1, 14, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|CATEGORY|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|CATEGORY|~|', 'Category', 156002, 'Category as specified in user details', 1, 15, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|SUB_CATEGORY|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|SUB_CATEGORY|~|', 'Sub-Category', 156002, 'Sub-Category as specified in user details', 1, 16, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|LOCATION|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|LOCATION|~|', 'Location', 156002, 'Location as specified in user details', 1, 17, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|DEPARTMENT|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|DEPARTMENT|~|', 'Department', 156002, 'Department as specified in user details', 1, 18, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PAN|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PAN|~|', 'PAN', 156002, 'PAN as specified in user details', 1, 19, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|DATE_OF_JOINING|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|DATE_OF_JOINING|~|', 'Date of joining', 156002, 'Date of joining as specified in user details', 1, 20, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|DATE_OF_BECOMING_INSIDER|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|DATE_OF_BECOMING_INSIDER|~|', 'Date of becoming insider', 156002, 'Date of becoming insider as specified in user details', 1, 21, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|APP_URL|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|APP_URL|~|', 'Application startup URL', 156002, 'Application startup URL', 1, 22, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|APP_URL_ANCHOR|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|APP_URL_ANCHOR|~|', 'Link to Application startup URL', 156002, 'Link redirecting to Application startup URL', 1, 23, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|POLICY_DOC_NAME|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|POLICY_DOC_NAME|~|', 'Policy Document Name', 156002, 'Policy Document Name', 1, 24, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|POLICY_DOC_EXPIRY_DATE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|POLICY_DOC_EXPIRY_DATE|~|', 'Policy Document expiry date', 156002, 'Policy Document expiry date', 1, 25, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|POLICY_DOC_CREATE_DATE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|POLICY_DOC_CREATE_DATE|~|', 'Policy Document creation date', 156002, 'Policy Document creation date', 1, 26, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|POLICY_DOC_START_DATE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|POLICY_DOC_START_DATE|~|', 'Policy Document start date', 156002, 'Policy Document start date', 1, 27, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|TRADING_POLICY_NAME|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|TRADING_POLICY_NAME|~|', 'Trading Policy name', 156002, 'Trading Policy name', 1, 28, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|TRADING_POLICY_EXPIRY_DATE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|TRADING_POLICY_EXPIRY_DATE|~|', 'Trading Policy expiry date', 156002, 'Trading Policy expiry date', 1, 29, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|TRADING_POLICY_CREATE_DATE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|TRADING_POLICY_CREATE_DATE|~|', 'Trading Policy creation date', 156002, 'Trading Policy creation date', 1, 30, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|TRADING_POLICY_START_DATE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|TRADING_POLICY_START_DATE|~|', 'Trading Policy start date', 156002, 'Trading Policy start date', 1, 31, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_ID|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PRE_CLEAR_ID|~|', 'Preclearance Id', 156002, 'Preclearance Id', 1, 32, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_DATE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PRE_CLEAR_DATE|~|', 'Preclearance date', 156002, 'Preclearance date', 1, 33, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_APPROVE_REJECT|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PRE_CLEAR_APPROVE_REJECT|~|', 'Preclearance Approve/Reject', 156002, 'Preclearance Approve/Reject status', 1, 34, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_EXPIRY_DATE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PRE_CLEAR_EXPIRY_DATE|~|', 'Preclearance expiry date', 156002, 'Preclearance expiry date', 1, 35, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_REQUEST_FOR|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PRE_CLEAR_REQUEST_FOR|~|', 'Preclearance for self/relative', 156002, 'Preclearance requested for self/relative', 1, 36, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_DEMAT_ACC|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PRE_CLEAR_DEMAT_ACC|~|', 'Preclearance DEMAT account', 156002, 'DEMAT account associated with Preclearance', 1, 37, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_TRANSACTION_TYPE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PRE_CLEAR_TRANSACTION_TYPE|~|', 'Preclearance Transaction type', 156002, 'Transaction type specified in Preclearance request', 1, 38, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_SECURITY_TYPE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PRE_CLEAR_SECURITY_TYPE|~|', 'Preclearance Security type', 156002, 'Security type specified in Preclearance request', 1, 39, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_SECURITY_TO_BE_TRADE_QTY|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PRE_CLEAR_SECURITY_TO_BE_TRADE_QTY|~|', 'Preclearance trade quantity', 156002, 'Security trade quantity specified in Preclearance request', 1, 40, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PRE_CLEAR_VALUE_OF_PROPOSE_TRADE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PRE_CLEAR_VALUE_OF_PROPOSE_TRADE|~|', 'Preclearance trade value', 156002, 'Security trade value specified in Preclearance request', 1, 41, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|TRADING_WINDOW_EVENT_TYPE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|TRADING_WINDOW_EVENT_TYPE|~|', 'Trading window event type', 156002, 'Trading window event type', 1, 42, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|TRADING_WINDOW_ID|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|TRADING_WINDOW_ID|~|', 'Trading window ID', 156002, 'Trading window ID to identify the window', 1, 43, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|FINANCIAL_YEAR_CODE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|FINANCIAL_YEAR_CODE|~|', 'Trading window yearcode', 156002, 'Trading window : Financial yearcode', 1, 44, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|FINANCIAL_PERIOD_CODE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|FINANCIAL_PERIOD_CODE|~|', 'Trading window periodcode', 156002, 'Trading window : Financial periodcode', 1, 45, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|WINDOW_CLOSE_DATE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|WINDOW_CLOSE_DATE|~|', 'Trading window closing date', 156002, 'Trading window closing date', 1, 46, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|WINDOW_CLOSE_TIME|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|WINDOW_CLOSE_TIME|~|', 'Trading window closing time', 156002, 'Trading window closing time', 1, 47, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|WINDOW_OPEN_DATE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|WINDOW_OPEN_DATE|~|', 'Trading window opening date', 156002, 'Trading window opening date', 1, 48, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|WINDOW_OPEN_TIME|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|WINDOW_OPEN_TIME|~|', 'Trading window opening time', 156002, 'Trading window opening time', 1, 48, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|DISCLOSURE_LAST_SUBMIT_DATE|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|DISCLOSURE_LAST_SUBMIT_DATE|~|', 'Last date for disclosure submission', 156002, 'Last date for disclosure submission', 1, 50, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156002 AND LOWER(PlaceholderTag) = LOWER('|~|PERIOD_END_DISCLOSURE_DAYS_TO_SUBMIT|~|'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('|~|PERIOD_END_DISCLOSURE_DAYS_TO_SUBMIT|~|', 'Period end submission days available', 156002, 'Days available for submission of period end disclosure', 1, 51, 1, GETDATE(), 1, GETDATE())
END
GO

--Insert placeholders related to Communication Mode : Form E
-----------------User related placeholders
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_EMAILID]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_EMAILID]', 'EmailId', 156007, 'EmailId as specified in user details', 1, 1, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_FIRSTNAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_FIRSTNAME]', 'Firstname/Contact Person', 156007, 'Firstname/Name of Contact Person as specified in user details', 1, 2, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_MIDDLENAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_MIDDLENAME]', 'Middlename', 156007, 'Middlename as specified in user details', 1, 3, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_LASTNAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_LASTNAME]', 'Lastname', 156007, 'Lastname as specified in user details', 1, 4, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_EMPLOYEEID]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_EMPLOYEEID]', 'EmployeeId', 156007, 'EmployeeId of Employee/Employee Insider, will be replaced as ''-'' when not applicable', 1, 5, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_MOBILE_NUMBER]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_MOBILE_NUMBER]', 'Mobile Number', 156007, 'Mobile Number as specified in user details', 1, 6, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_COMPANY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_COMPANY]', 'Company Name', 156007, 'Company name as specified in user details', 1, 7, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_ADDR1]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_ADDR1]', 'Addressline 1', 156007, 'Addressline1 as specified in user details', 1, 8, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_ADDR2]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_ADDR2]', 'Addressline 2', 156007, 'Addressline2 as specified in user details', 1, 9, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_COUNTRY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_COUNTRY]', 'Country', 156007, 'Country as specified in user details', 1, 10, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_STATE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_STATE]', 'State', 156007, 'State as specified in user details', 1, 11, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_CITY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_CITY]', 'City', 156007, 'City as specified in user details', 1, 12, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_PINCODE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_PINCODE]', 'Pincode', 156007, 'Pincode as specified in user details', 1, 13, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_JOIN_DATE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_JOIN_DATE]', 'Date of joining', 156007, 'Date of joining as specified in user details', 1, 14, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_BECOMEINSIDER_DATE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_BECOMEINSIDER_DATE]', 'Date of becoming insider', 156007, 'Date of becoming insider as specified in user details', 1, 15, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_LANDLINE1]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_LANDLINE1]', 'Landline1', 156007, 'Landline1 as specified in user details', 1, 16, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_LANDLINE2]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_LANDLINE2]', 'Landline2', 156007, 'Landline2 as specified in user details', 1, 17, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_WEBSITE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_WEBSITE]', 'Website', 156007, 'Website as specified in user details', 1, 18, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_PAN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_PAN]', 'PAN', 156007, 'PAN as specified in user details', 1, 19, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_TAN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_TAN]', 'TAN', 156007, 'TAN as specified in user details', 1, 20, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_DESCRIPTN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_DESCRIPTN]', 'User Description', 156007, 'Description as specified in user details', 1, 21, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_CATEGORY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_CATEGORY]', 'Category', 156007, 'Category as specified in user details', 1, 22, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_SUBCATEGORY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_SUBCATEGORY]', 'Sub-Category', 156007, 'Sub-Category as specified in user details', 1, 23, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_GRADE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_GRADE]', 'Grade', 156007, 'Grade as specified in user details', 1, 24, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_DESIGNATN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_DESIGNATN]', 'Designation', 156007, 'Designation as specified in user details', 1, 25, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_SUBDESIGNATN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_SUBDESIGNATN]', 'Sub-Designation', 156007, 'Sub-Designation as specified in user details', 1, 26, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_DEPT]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_DEPT]', 'Department', 156007, 'Department as specified in user details', 1, 27, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_LOCATN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_LOCATN]', 'Location', 156007, 'Location as specified in user details', 1, 28, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_UPSI_ACCESSCOMPANY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_UPSI_ACCESSCOMPANY]', 'Company related to UPSI', 156007, 'UPSI Company as specified in user details', 1, 29, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_USERTYPE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_USERTYPE]', 'Usertype', 156007, 'Usertype as specified in user details', 1, 30, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_STATUS]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_STATUS]', 'Status : Active/Inactive', 156007, 'Status : Active/Inactive as specified in user details', 1, 31, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_SEPARATN_DATE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_SEPARATN_DATE]', 'Separation date', 156007, 'Separation date as specified in user details', 1, 32, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_SEPARATN_REASON]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_SEPARATN_REASON]', 'Separation reason', 156007, 'Separation reason as specified in user details', 1, 33, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_CIN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_CIN]', 'CIN', 156007, 'CIN as specified in user details', 1, 34, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_DIN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_DIN]', 'DIN', 156007, 'DIN as specified in user details', 1, 35, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_DAYTOBEACTIVE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_DAYTOBEACTIVE]', 'Active days after separation', 156007, 'Days to be active after separation, as specified in user details', 1, 36, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_INACTIVATN_DATE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_INACTIVATN_DATE]', 'Inactivation date', 156007, 'Inactivation date as specified in user details', 1, 37, 1, GETDATE(), 1, GETDATE())
END
GO
------------------Relative related placeholders
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_EMAILID]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_EMAILID]', 'Relative EmailId', 156007, 'EmailId as specified in relative user details', 1, 38, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_FIRSTNAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_FIRSTNAME]', 'Relative Firstname', 156007, 'Firstname as specified in relative user details', 1, 39, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_MIDDLENAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_MIDDLENAME]', 'Relative Middlename', 156007, 'Middlename as specified in relative user details', 1, 40, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_LASTNAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_LASTNAME]', 'Relative Lastname', 156007, 'Lastname as specified in relative user details', 1, 41, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_MOBILE_NUMBER]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_MOBILE_NUMBER]', 'Relative Mobile Number', 156007, 'Mobile Number as specified in relative user details', 1, 42, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_ADDR1]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_ADDR1]', 'Relative Addressline 1', 156007, 'Addressline 1 as specified in relative user details', 1, 43, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_ADDR2]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_ADDR2]', 'Relative Addressline 2', 156007, 'Addressline 2 as specified in relative user details', 1, 44, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_COUNTRY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_COUNTRY]', 'Relative Country', 156007, 'Country as specified in relative user details', 1, 45, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_STATE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_STATE]', 'Relative State', 156007, 'State as specified in relative user details', 1, 46, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_CITY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_CITY]', 'Relative City', 156007, 'City as specified in relative user details', 1, 47, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_PINCODE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_PINCODE]', 'Relative Pincode', 156007, 'Pincode as specified in relative user details', 1, 48, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_LANDLINE1]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_LANDLINE1]', 'Relative Landline1', 156007, 'Landline1 as specified in relative user details', 1, 49, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_LANDLINE2]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_LANDLINE2]', 'Relative Landline2', 156007, 'Landline2 as specified in relative user details', 1, 50, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_PAN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_PAN]', 'Relative PAN', 156007, 'PAN as specified in relative user details', 1, 51, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_USERTYPE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_USERTYPE]', 'Relative Usertype', 156007, 'Usertype as specified in relative user details', 1, 52, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_STATUS]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_STATUS]', 'Relative Status : Active/Inactive', 156007, 'Status : Active/Inactive, as specified in relative user details', 1, 53, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_RELATNWITHEMP]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_RELATNWITHEMP]', 'Relative-Employee Relationship', 156007, 'Relationship of relative with employee as specified in relative user details', 1, 54, 1, GETDATE(), 1, GETDATE())
END
GO
----------------DMAT related placeholders for user details
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_DMATACCNUMBER]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_DMATACCNUMBER]', 'DEMAT Account Number', 156007, 'DEMAT Account Number as specified in user details', 1, 55, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_DMATDPNAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_DMATDPNAME]', 'DEMAT DP Name', 156007, 'DEMAT Depository Participant Name as specified in user details', 1, 56, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_DMATDPID]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_DMATDPID]', 'DEMAT DPID', 156007, 'DEMAT Depository Participant ID as specified in user details', 1, 57, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_DMATTMID]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_DMATTMID]', 'DEMAT TMID', 156007, 'DEMAT TMID as specified in user details', 1, 58, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_DMATDESCRIPTN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_DMATDESCRIPTN]', 'DEMAT Description', 156007, 'DEMAT Description as specified in user details', 1, 59, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[USR_DMATACCOUNTTYPE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[USR_DMATACCOUNTTYPE]', 'DEMAT account type', 156007, 'DEMAT account type as specified in user details', 1, 60, 1, GETDATE(), 1, GETDATE())
END
GO
------------------DMAT related placeholders for relative details
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_DMATACCNUMBER]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_DMATACCNUMBER]', 'Relative: DEMAT Account Number', 156007, 'DEMAT Account Number as specified in relative user details', 1, 61, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_DMATDPNAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_DMATDPNAME]', 'Relative: DEMAT DP Name', 156007, 'DEMAT Depository Participant Name as specified in relative user details', 1, 62, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_DMATDPID]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_DMATDPID]', 'Relative: DEMAT DPID', 156007, 'DEMAT Depository Participant ID as specified in relative user details', 1, 63, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_DMATTMID]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_DMATTMID]', 'Relative: DEMAT TMID', 156007, 'DEMAT TMID as specified in relative user details', 1, 64, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_DMATDESCRIPTN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_DMATDESCRIPTN]', 'Relative: DEMAT Description', 156007, 'DEMAT Description as specified in relative user details', 1, 65, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[REL_DMATACCOUNTTYPE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[REL_DMATACCOUNTTYPE]', 'Relative: DEMAT account type', 156007, 'DEMAT account type as specified in relative user details', 1, 66, 1, GETDATE(), 1, GETDATE())
END
GO

-----------User/Relative related common placeholder where value belonging to either User or Relative whichever is available will be replaced
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[UREL_FIRSTNAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[UREL_FIRSTNAME]', 'User/Relative Firstname', 156007, 'Firstname as specified in user/relative details', 1, 67, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[UREL_MIDDLENAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[UREL_MIDDLENAME]', 'User/Relative Middlename', 156007, 'Middlename as specified in user/relative details', 1, 68, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[UREL_LASTNAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[UREL_LASTNAME]', 'User/Relative Lastname', 156007, 'Lastname as specified in user/relative details', 1, 69, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[UREL_MOBILE_NUMBER]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[UREL_MOBILE_NUMBER]', 'User/Relative Mobile Number', 156007, 'Mobile Number as specified in user/relative details', 1, 70, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[UREL_PAN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[UREL_PAN]', 'User/Relative PAN', 156007, 'PAN as specified in user/relative details', 1, 71, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[UREL_DMATACCNUMBER]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[UREL_DMATACCNUMBER]', 'User/Relative DEMAT Account', 156007, 'DEMAT Account as specified in user/relative details', 1, 72, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[UREL_DMATDPNAME]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[UREL_DMATDPNAME]', 'User/Relative DEMAT DP Name', 156007, 'DEMAT Depository Participant Name as specified in user/relative details', 1, 73, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[UREL_DMATDPID]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[UREL_DMATDPID]', 'User/Relative DEMAT DPID', 156007, 'DEMAT Depository Participant ID as specified in user/relative details', 1, 74, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[UREL_DMATTMID]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[UREL_DMATTMID]', 'User/Relative DEMAT TMID', 156007, 'DEMAT TMID as specified in user/relative details', 1, 75, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[UREL_DMATDESCRIPTN]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[UREL_DMATDESCRIPTN]', 'User/Relative DEMAT Description', 156007, 'DEMAT Description as specified in user/relative details', 1, 76, 1, GETDATE(), 1, GETDATE())
END
GO

------Preclearance related placeholders
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_REQUESTFOR]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_REQUESTFOR]', 'Preclearance: for self/relative', 156007, 'Preclearance request for self/relative as specified in preclearance details', 1, 77, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_TRANSACTNTYPE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_TRANSACTNTYPE]', 'Preclearance: transaction type', 156007, 'Preclearance transaction type as specified in preclearance details', 1, 78, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_SECURITYTYPE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_SECURITYTYPE]', 'Preclearance: security type', 156007, 'Preclearance security type as specified in preclearance details', 1, 79, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_SECURITYTRADEQTY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_SECURITYTRADEQTY]', 'Preclearance: trade quantity', 156007, 'Preclearance trade quantity as specified in preclearance details', 1, 80, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_SECURITYTRADEVALUE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_SECURITYTRADEVALUE]', 'Preclearance: trade value', 156007, 'Preclearance trade value as specified in preclearance details', 1, 81, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_STATUS]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_STATUS]', 'Preclearance: status', 156007, 'Preclearance status as specified in preclearance details', 1, 82, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_IMPLEMENTCOMPANY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_IMPLEMENTCOMPANY]', 'Preclearance: Implementing company', 156007, 'Preclearance implementing company as specified in preclearance details', 1, 83, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_TRADERATEFRM]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_TRADERATEFRM]', 'Preclearance: from trade rate', 156007, 'Preclearance trade rate ''from'' as specified in preclearance details', 1, 84, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_TRADERATETO]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_TRADERATETO]', 'Preclearance: to trade rate', 156007, 'Preclearance trade rate ''to'' as specified in preclearance details', 1, 85, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_NOTTRADEDREASON]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_NOTTRADEDREASON]', 'Preclearance: not traded reason', 156007, 'Preclearance not traded reason as specified in preclearance details', 1, 86, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_NOTTRADEDREASONDTL]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_NOTTRADEDREASONDTL]', 'Preclearance: not traded reason details', 156007, 'Preclearance not traded reason details as specified in preclearance details', 1, 87, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_REJECTREASON]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_REJECTREASON]', 'Preclearance: rejection reason', 156007, 'Preclearance rejection reason as specified in preclearance details', 1, 88, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_EXERCISEOPTNQTY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_EXERCISEOPTNQTY]', 'Preclearance: ESOP Exercise Quantity', 156007, 'Preclearance ESOP exercise quantity as specified in preclearance details', 1, 89, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_OTHREXERCISEOPTNQTY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_OTHREXERCISEOPTNQTY]', 'Preclearance: Other Exercise Quantity', 156007, 'Preclearance other exercise quantity as specified in preclearance details', 1, 90, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_PLEDGEOPTNQTY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_PLEDGEOPTNQTY]', 'Preclearance: Pledge Quantity', 156007, 'Preclearance pledge quantity as specified in preclearance details', 1, 91, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_ACQUISITNMODE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_ACQUISITNMODE]', 'Preclearance: Acquisition mode', 156007, 'Preclearance acquisition mode as specified in preclearance details', 1, 92, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_BUYDATE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_BUYDATE]', 'Preclearance: Previous BUY date', 156007, 'Preclearance previous BUY date as specified in preclearance details', 1, 93, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_PREVAPPROVNUMBER]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_PREVAPPROVNUMBER]', 'Preclearance: Previous approved no.', 156007, 'Preclearance previous approved preclearance number as specified in preclearance details', 1, 94, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_PREVAPPROVNUMBERANDDATE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_PREVAPPROVNUMBERANDDATE]', 'Preclearance: Previous approved no. and date', 156007, 'Preclearance previous approved preclearance number and date as specified in preclearance details', 1, 95, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_REQUESTDATE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_REQUESTDATE]', 'Preclearance: request date', 156007, 'Preclearance request date as specified in preclearance details', 1, 96, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_APPROVEDDATE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_APPROVEDDATE]', 'Preclearance: approval date', 156007, 'Preclearance approval date as specified in preclearance details', 1, 97, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_APPROVEDBY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_APPROVEDBY]', 'Preclearance: approver name', 156007, 'Preclearance approver name as specified in preclearance details', 1, 98, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_TRADEDFORCOMPANY]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_TRADEDFORCOMPANY]', 'Preclearance: traded for company', 156007, 'Preclearance traded for company as specified in preclearance details', 1, 99, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[PCL_VALIDITYDAYS]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[PCL_VALIDITYDAYS]', 'Preclearance: validity days', 156007, 'Preclearance validity days as specified in applicable trading policy', 1, 100, 1, GETDATE(), 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007 AND LOWER(PlaceholderTag) = LOWER('[SRV_DATE]'))
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag, PlaceholderDisplayName, PlaceholderGroupId, PlaceholderDescription, IsVisible, DisplayOrder, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		('[SRV_DATE]', 'Server date', 156007, 'Server date', 1, 101, 1, GETDATE(), 1, GETDATE())
END
GO

/*

	Tushar 20-Oct-2016
	All scripts(alter table,resource & code insert) related to the Security Transfer.

*/

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 191)
BEGIN
	INSERT INTO com_CodeGroup 
	(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
	VALUES
	(191, NULL, 'Security Transfer Option', 'Security Transfer Option', 1, 0)
END
GO

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 191001)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(191001, NULL, 'Security Transfer from selected (Individual) Demat account', NULL, 191, 'Security Transfer from selected (Individual) Demat account', 1, 1, GETDATE(), 1)
END
GO

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 191002)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(191002, NULL, 'Security Transfer from All Demat account', NULL, 191, 'Security Transfer from All Demat account', 1, 1, GETDATE(), 1)
END
GO

IF NOT EXISTS(SELECT name FROM sys.all_columns WHERE name = N'SecurityTransferOption' AND object_id = OBJECT_ID(N'usr_SecurityTransferLog'))
BEGIN
	ALTER TABLE usr_SecurityTransferLog 
		ADD SecurityTransferOption INT NOT NULL DEFAULT 191001
		CONSTRAINT FK_usr_SecurityTransferLog_SecurityTransferOption_com_Code_CodeID FOREIGN KEY(SecurityTransferOption)REFERENCES com_Code(CodeID)  
END
GO

--resources 
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122092)
BEGIN
	INSERT INTO com_Code
		(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
	VALUES
		(122092, 103002, 'Securities Transfer', NULL, 122, 'Screen - Securities Transfer', 1, 1, GETDATE(), 103)
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11443)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11443, 'usr_ttl_11443', 'Securities Transfer', 'en-US', 103002, 104006, 122092, 'Securities Transfer', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11444)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11444, 'usr_lbl_11444', 'Self', 'en-US', 103002, 104002, 122092, 'Self', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11445)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11445, 'usr_lbl_11445', 'Relative', 'en-US', 103002, 104002, 122092, 'Relative', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11446)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11446, 'usr_lbl_11446', 'If Relatives', 'en-US', 103002, 104002, 122092, 'If Relatives', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11447)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11447, 'usr_lbl_11447', 'Security Transfer from selected (Individual) Demat account', 'en-US', 103002, 104002, 122092, 'Security Transfer from selected (Individual) Demat account', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11448)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11448, 'usr_lbl_11448', 'Security Transfer from All Demat account', 'en-US', 103002, 104002, 122092, 'Security Transfer from All Demat account', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11449)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11449, 'usr_lbl_11449', 'Security Type', 'en-US', 103002, 104002, 122092, 'Security Type', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11450)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11450, 'usr_lbl_11450', 'Demat Account Number', 'en-US', 103002, 104002, 122092, 'Demat Account Number', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11451)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11451, 'usr_lbl_11451', 'To which Demat Account Number', 'en-US', 103002, 104002, 122092, 'To which Demat Account Number', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11452)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11452, 'usr_lbl_11452', 'Quantity', 'en-US', 103002, 104002, 122092, 'Quantity', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11453)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11453, 'usr_lbl_11453', 'Total available Quantity : ', 'en-US', 103002, 104002, 122092, 'Total available Quantity : ', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11454)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11454, 'usr_lbl_11454', 'Total Available Quantity for transfer of all demat accounts : $1 (Excluding the demat account to which the quantity is to be transferred)', 'en-US', 103002, 104002, 122092, 'Total Available Quantity for transfer of all demat accounts : $1 (Excluding the demat account to which the quantity is to be transferred)', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11455)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11455, 'usr_msg_11455', 'Error occurred while fetching available quantity.', 'en-US', 103002, 104001, 122092, 'Error occurred while fetching available quantity.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11456)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11456, 'usr_msg_11456', 'Error occurred while securities transfer.', 'en-US', 103002, 104001, 122092, 'Error occurred while securities transfer.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11457)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11457, 'usr_msg_11457', 'Error occurred while securities transfer validation.', 'en-US', 103002, 104001, 122092, 'Error occurred while securities transfer validation.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11458)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11458, 'usr_msg_11458', 'User Information is mandatory.', 'en-US', 103002, 104001, 122092, 'User Information is mandatory.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11459)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11459, 'usr_msg_11459', 'User Relative Information is mandatory.', 'en-US', 103002, 104001, 122092, 'User Relative Information is mandatory.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11460)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11460, 'usr_msg_11460', 'Enter transfer quantity is greater than zero.', 'en-US', 103002, 104001, 122092, 'Enter transfer quantity is greater than zero.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11461)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11461, 'usr_msg_11461', 'Security Type is mandatory.', 'en-US', 103002, 104001, 122092, 'Security Type is mandatory.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11462)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11462, 'usr_msg_11462', 'From DEMAT Account is mandatory.', 'en-US', 103002, 104001, 122092, 'From DEMAT Account is mandatory.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11463)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11463, 'usr_msg_11463', 'To DEMAT Account is mandatory.', 'en-US', 103002, 104001, 122092, 'To DEMAT Account is mandatory.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11464)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11464, 'usr_msg_11464', 'You cannot transfer the securities, Transfer quantity is greater than the available quantity.', 'en-US', 103002, 104001, 122092, 'You cannot transfer the securities, Transfer quantity is greater than the available quantity.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11465)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11465, 'usr_msg_11465', 'You cannot transfer the securities, From Demat account number have some incomplete and pending transactions.', 'en-US', 103002, 104001, 122092, 'You cannot transfer the securities, From Demat account number have some incomplete and pending transactions.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11466)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11466, 'usr_msg_11466', 'You cannot transfer the securities, To Demat account number have some incomplete and pending transactions.', 'en-US', 103002, 104001, 122092, 'You cannot transfer the securities, To Demat account number have some incomplete and pending transactions.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11467)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11467, 'usr_msg_11467', 'You cannot transfer the securities, From and To Demat account number have some incomplete and pending transactions.', 'en-US', 103002, 104001, 122092, 'You cannot transfer the securities, From and To Demat account number have some incomplete and pending transactions.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11468)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11468, 'usr_msg_11468', 'Select From and To Demat account number different.', 'en-US', 103002, 104001, 122092, 'Select From and To Demat account number different.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11469)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11469, 'usr_msg_11469', 'You cannot transfer the securities, Pledge available quantity is greater than zero.', 'en-US', 103002, 104001, 122092, 'You cannot transfer the securities, Pledge available quantity is greater than zero.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11470)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11470, 'usr_msg_11470', 'You cannot transfer the securities, previous period end is not submitted.', 'en-US', 103002, 104001, 122092, 'You cannot transfer the securities, previous period end is not submitted.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11471)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11471, 'usr_msg_11471', 'Securities transfer successfully.', 'en-US', 103002, 104001, 122092, 'Securities transfer successfully.', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11472)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11472, 'usr_msg_11472', 'Are you sure want to confirm Securities Transfer?', 'en-US', 103002, 104001, 122092, 'Are you sure want to confirm Securities Transfer?', 1, GETDATE())
END
GO

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11473)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11473, 'usr_msg_11473', 'Confirm', 'en-US', 103002, 104001, 122092, 'Confirm', 1, GETDATE())
END
GO

/*
	Tushar 20-Oct-2016
	Scripts resource insert related to the Security Transfer.
	

*/

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11485)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(11485, 'usr_msg_11485', 'You cannot transfer the securities, ESOP quantity is not zero.', 'en-US', 103002, 104001, 122092, 'You cannot transfer the securities, ESOP quantity is not zero.', 1, GETDATE())
END
GO
/*
	Scripts By Parag on 20 October 2016
	Add scripts for Security transfer 
*/

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11483)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(11483, 'usr_msg_11483', 'Error occured while updating demat balance while security transfer', 'Error occured while updating demat balance while security transfer', 'en-US', 103002, 104001, 122092, 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 11484)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
	(11484, 'usr_msg_11484', 'Error occured while updating demat quantity', 'Error occured while updating demat quantity', 'en-US', 103002, 104001, 122092, 1, GETDATE())
END

/*
	GS/Tushar:- 24 Oct-2016 
		Add Grid And Resources for Securities hoiling list & Security Transfer Report C0
*/
 
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114098)
BEGIN
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114098, null, 'Securities Holding List', NULL, 114, 'List of Securities Holding', 1, 1, GETDATE(), 98)
END
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122093)
BEGIN
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122093, 103002, 'Securities Holding List', NULL, 122, 'Screen - Securities Holding List', 1, 1, GETDATE(), 104)
END

--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11474)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11474, 'usr_grd_11474','Depository Name','en-US',103002,104003,122093,'Depository Name',1,GETDATE())
END
GO


--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11475)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11475, 'usr_grd_11475','DEMAT A/c Number','en-US',103002,104003,122093,'DEMAT A/c Number',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11476)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11476, 'usr_grd_11476','Depository Participant ID','en-US',103002,104003,122093,'Depository Participant ID',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11477)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11477, 'usr_grd_11477','Depository Participant Name','en-US',103002,104003,122093,'Depository Participant Name',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11478)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11478, 'usr_grd_11478','TMID','en-US',103002,104003,122093,'TMID',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11479)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11479, 'usr_grd_11479','Demat Account Type','en-US',103002,104003,122093,'Demat Account Type',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11480)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11480, 'usr_grd_11480','Relation','en-US',103002,104003,122093,'Relation',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11481)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11481, 'usr_grd_11481','Security Type','en-US',103002,104003,122093,'Security Type',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11482)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11482, 'usr_grd_11482','Holdings','en-US',103002,104003,122093,'Holdings',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114098 AND ResourceKey = 'usr_grd_11474')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114098, 'usr_grd_11474', 1, 1, 0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114098 AND ResourceKey = 'usr_grd_11475')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114098, 'usr_grd_11475', 1, 2, 0, 155002, NULL ,NULL)
END
GO

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114098 AND ResourceKey = 'usr_grd_11476')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114098, 'usr_grd_11476', 1, 3, 0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114098 AND ResourceKey = 'usr_grd_11477')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114098, 'usr_grd_11477', 1, 4, 0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114098 AND ResourceKey = 'usr_grd_11478')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114098, 'usr_grd_11478', 1, 5, 0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114098 AND ResourceKey = 'usr_grd_11479')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114098, 'usr_grd_11479', 1, 6, 0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114098 AND ResourceKey = 'usr_grd_11480')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114098, 'usr_grd_11480', 1, 7, 0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114098 AND ResourceKey = 'usr_grd_11481')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114098, 'usr_grd_11481', 1, 8, 0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114098 AND ResourceKey = 'usr_grd_11482')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114098, 'usr_grd_11482', 1, 9, 0, 155002, NULL ,NULL)
END
GO

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 219 AND ControllerName = 'DatatableGrid' AND ActionName = 'Index')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(219, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE())
END
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 219 AND ControllerName = 'DatatableGrid' AND ActionName = 'AjaxHandler')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(219, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 221 AND ControllerName = 'DatatableGrid' AND ActionName = 'Index')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(221, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE())
END
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 221 AND ControllerName = 'DatatableGrid' AND ActionName = 'AjaxHandler')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(221, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE())
END


IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 222 AND ControllerName = 'DatatableGrid' AND ActionName = 'Index')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(222, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE())
END
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 222 AND ControllerName = 'DatatableGrid' AND ActionName = 'AjaxHandler')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(222, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE())
END
/* -------------------------------------------------------------------------------------------------------------------------------------------------------

GridType 114099  Security Transfer Report

*/

  
 
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114099)
BEGIN
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114099, null, 'Securities Transfer Report For Co', NULL, 114, 'List of Securities Transfer Report For Co', 1, 1, GETDATE(), 98)
END
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122094)
BEGIN
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122094, 103011, 'Securities Transfer Report For Co', NULL, 122, 'Screen - Securities Transfer Report For Co', 1, 1, GETDATE(), 105)
END

--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19328)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19328, 'rpt_grd_19328','Security Type','en-US',103011,104003,122094,'Security Type',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19329)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19329, 'rpt_grd_19329','Depository Name','en-US',103011,104003,122094,'Depository Name',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19330)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19330, 'rpt_grd_19330','DEMAT A/c Number','en-US',103011,104003,122094,'DEMAT A/c Number',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19331)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19331, 'rpt_grd_19331','Depository Participant ID','en-US',103011,104003,122094,'Depository Participant ID',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19332)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19332, 'rpt_grd_19332','Depository Participant Name','en-US',103011,104003,122094,'Depository Participant Name',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19333)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19333, 'rpt_grd_19333','Depository Name','en-US',103011,104003,122094,'Depository Name',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19334)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19334, 'rpt_grd_19334','DEMAT A/c Number','en-US',103011,104003,122094,'DEMAT A/c Number',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19335)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19335, 'rpt_grd_19335','Depository Participant ID','en-US',103011,104003,122094,'Depository Participant ID',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19336)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19336, 'rpt_grd_19336','Depository Participant Name','en-US',103011,104003,122094,'Depository Participant Name',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19337)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19337, 'rpt_grd_19337','Transfer Date','en-US',103011,104003,122094,'Transfer Date',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19338)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19338, 'rpt_grd_19338','Transfer Quantity','en-US',103011,104003,122094,'Transfer Quantity',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19339)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19339, 'rpt_grd_19339','From DEMAT Information','en-US',103011,104003,122094,'From DEMAT Information',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19340)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19340, 'rpt_grd_19340','To DEMAT Information','en-US',103011,104003,122094,'To DEMAT Information',1,GETDATE())
END
GO

--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19341)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19341, 'rpt_grd_19341','Employee Id','en-US',103011,104003,122094,'Employee Id',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19342)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19342, 'rpt_grd_19342','Employee Name','en-US',103011,104003,122094,'Employee Name',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19343)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19343, 'rpt_grd_19343','PAN','en-US',103011,104003,122094,'PAN',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19344)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19344, 'rpt_grd_19344','Designation','en-US',103011,104003,122094,'Designation',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19345)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19345, 'rpt_grd_19345','Grade','en-US',103011,104003,122094,'Grade',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19346)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19346, 'rpt_grd_19346','Location','en-US',103011,104003,122094,'Location',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19347)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19347, 'rpt_grd_19347','Department','en-US',103011,104003,122094,'Department',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19348)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19348, 'rpt_grd_19348','Company Name','en-US',103011,104003,122094,'Company Name',1,GETDATE())
END
GO
--Insert resource keys for grid headers
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19349)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19349, 'rpt_grd_19349','Type Of Insider','en-US',103011,104003,122094,'Type Of Insider',1,GETDATE())
END
GO


IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19341')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19341', 1,10000,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19342')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19342',1, 20000,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19343')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19343',1, 30000,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19344')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19344',1, 40000,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19345')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19345',1, 50000,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19346')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19346',1, 60000,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19347')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19347', 1,70000, 0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19348')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19348',1, 80000,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19349')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19349',1, 90000, 0, 155002, NULL ,NULL)
END
GO

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19339')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19339',1, 100000, 0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19328')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19328',1, 110010,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19329')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19329',1, 120010,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19330')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19330',1, 130010,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19331')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19331', 1,140010,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19332')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19332',1, 150010, 0, 155002, NULL ,NULL)
END
GO

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19340')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19340',1, 160000,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19333')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19333',1, 170016, 0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19334')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19334',1, 180016,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19335')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19335',1, 190016,   0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19336')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19336',1, 200016,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19337')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19337',1, 210016,  0, 155002, NULL ,NULL)
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114099 AND ResourceKey = 'rpt_grd_19338')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES (114099, 'rpt_grd_19338',1, 220016,   0, 155002, NULL ,NULL)
END
GO
/*
	Tushar 25-Oct-2016
	Description:- Update activity URL for CO Security Transfer Report and menu and download report url add.

*/
IF NOT EXISTS(SELECT * FROM usr_ActivityURLMapping WHERE ActivityID = 222 AND ControllerName = 'Reports' AND ActionName = 'TransferReportCO')
BEGIN
	UPDATE usr_ActivityURLMapping
	SET ControllerName = 'Reports'
	WHERE ActivityID = 222 AND ControllerName = 'SecurityTransfer' AND ActionName = 'TransferReportCO'
END
GO
IF NOT EXISTS(SELECT MenuID FROM mst_MenuMaster WHERE MenuID = 55 AND MenuURL = '/Reports/TransferReportCO?acid=222')
BEGIN
	UPDATE mst_MenuMaster
	SET MenuURL = '/Reports/TransferReportCO?acid=222'
	WHERE MenuID = 55 AND MenuURL = '/SecurityTransfer/TransferReportCO?acid=222'
END
GO
IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 222 AND ControllerName = 'Reports' AND ActionName = 'ExportReport')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(222, 'Reports', 'ExportReport', NULL, 1, GETDATE(), 1, GETDATE())
END
GO
/*
	Tushar 25-Oct-2016
	Description:- Add Resources for Security Transfer report Co

*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19350)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19350, 'rpt_ttl_19350','Security Transfer Report','en-US',103011,104006,122094,'Security Transfer Report',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19351)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19351, 'rpt_lbl_19351','Employee ID','en-US',103011,104002,122094,'Employee ID',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19352)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19352, 'rpt_lbl_19352','Employee Name','en-US',103011,104002,122094,'Employee Name',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19353)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19353, 'rpt_lbl_19353','Designation','en-US',103011,104002,122094,'Designation',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19354)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19354, 'rpt_lbl_19354','Grade','en-US',103011,104002,122094,'Grade',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19355)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19355, 'rpt_lbl_19355','Location','en-US',103011,104002,122094,'Location',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19356)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19356, 'rpt_lbl_19356','Department','en-US',103011,104002,122094,'Department',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19357)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19357, 'rpt_lbl_19357','Company','en-US',103011,104002,122094,'Company',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19358)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19358, 'rpt_lbl_19358','User Type','en-US',103011,104002,122094,'User Type',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19359)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19359, 'rpt_lbl_19359','PAN','en-US',103011,104002,122094,'PAN',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19360)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19360, 'rpt_lbl_19360','Security Type','en-US',103011,104002,122094,'Security Type',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19361)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19361, 'rpt_lbl_19361','Demat Account Number','en-US',103011,104002,122094,'Demat Account Number',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19362)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19362, 'rpt_lbl_19362','Depository Name','en-US',103011,104002,122094,'Depository Name',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19363)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19363, 'rpt_lbl_19363','Transfer From Date','en-US',103011,104002,122094,'Transfer From Date',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19364)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19364, 'rpt_lbl_19364','Transfer To Date','en-US',103011,104002,122094,'Transfer To Date',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19365)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19365, 'rpt_lbl_19365','Depository Participant ID','en-US',103011,104002,122094,'Depository Participant ID',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19366)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19366, 'rpt_lbl_19366','Depository Participant Name','en-US',103011,104002,122094,'Depository Participant Name',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19367)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19367, 'rpt_lbl_19367','Transfer From Quantity','en-US',103011,104002,122094,'Transfer From Quantity',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19368)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19368, 'rpt_lbl_19368','Transfer To Quantity','en-US',103011,104002,122094,'Transfer To Quantity',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19369)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19369, 'rpt_msg_19369','Error occurred while fetching security transfer report.','en-US',103011,104001,122094,'Error occurred while fetching security transfer report.',1,GETDATE())
END
GO

/*
Raghvendra : 25-Oct-2015 : Making the Form E Template visible for editing via UI
*/
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 156007 AND IsVisible = 1)
BEGIN
	UPDATE com_Code SET IsVisible = 1 WHERE CodeID = 156007
END

/*
	Tushar	26-Oct-2016	
	Add Grid Resources for Security Transfer Report for Employee and their related scripts.
*/

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 114100)
BEGIN
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114100, null, 'Security Transfer Report for Employee', NULL, 114, 'Security Transfer Report for Employee', 1, 1, GETDATE(), 100)
END
GO

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 122095)
BEGIN
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122095, 103011, 'Security Transfer Report for Employee', NULL, 122, 'Screen - Security Transfer Report for Employee', 1, 1, GETDATE(), 106)
END

IF NOT EXISTS(SELECT * FROM usr_ActivityURLMapping WHERE ActivityID = 221 AND ControllerName = 'Reports' AND ActionName = 'TransferReport')
BEGIN
	UPDATE usr_ActivityURLMapping
	SET ControllerName = 'Reports'
	WHERE ActivityID = 221 AND ControllerName = 'SecurityTransfer' AND ActionName = 'TransferReport'
END
GO

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 221 AND ControllerName = 'Reports' AND ActionName = 'ExportReport')
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(221, 'Reports', 'ExportReport', NULL, 1, GETDATE(), 1, GETDATE())
END
GO

--Grid Resources

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19370)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19370, 'rpt_grd_19370','Security Type','en-US',103011,104003,122095,'Security Type',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19371)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19371, 'rpt_grd_19371','Depository Name','en-US',103011,104003,122095,'Depository Name',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19372)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19372, 'rpt_grd_19372','DEMAT A/c Number','en-US',103011,104003,122095,'DEMAT A/c Number',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19373)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19373, 'rpt_grd_19373','Depository Participant ID','en-US',103011,104003,122095,'Depository Participant ID',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19374)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19374, 'rpt_grd_19374','Depository Participant Name','en-US',103011,104003,122095,'Depository Participant Name',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19375)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19375, 'rpt_grd_19375','Depository Name','en-US',103011,104003,122095,'Depository Name',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19376)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19376, 'rpt_grd_19376','DEMAT A/c Number','en-US',103011,104003,122095,'DEMAT A/c Number',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19377)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19377, 'rpt_grd_19377','Depository Participant ID','en-US',103011,104003,122095,'Depository Participant ID',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19378)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19378, 'rpt_grd_19378','Depository Participant Name','en-US',103011,104003,122095,'Depository Participant Name',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19379)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19379, 'rpt_grd_19379','Transfer Date','en-US',103011,104003,122095,'Transfer Date',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19380)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19380, 'rpt_grd_19380','Transfer Quantity','en-US',103011,104003,122095,'Transfer Quantity',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19381)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19381, 'rpt_grd_19381','From DEMAT Information','en-US',103011,104003,122095,'From DEMAT Information',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19382)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19382, 'rpt_grd_19382','To DEMAT Information','en-US',103011,104003,122095,'To DEMAT Information',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19383)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19383, 'rpt_grd_19383','Employee Id','en-US',103011,104003,122095,'Employee Id',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19384)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19384, 'rpt_grd_19384','Employee Name','en-US',103011,104003,122095,'Employee Name',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19385)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19385, 'rpt_grd_19385','PAN','en-US',103011,104003,122095,'PAN',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19386)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19386, 'rpt_grd_19386','Designation','en-US',103011,104003,122095,'Designation',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19387)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19387, 'rpt_grd_19387','Grade','en-US',103011,104003,122095,'Grade',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19388)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19388, 'rpt_grd_19388','Location','en-US',103011,104003,122095,'Location',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19389)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19389, 'rpt_grd_19389','Department','en-US',103011,104003,122095,'Department',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19390)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19390, 'rpt_grd_19390','Company Name','en-US',103011,104003,122095,'Company Name',1,GETDATE())
END
GO
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 19391)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(19391, 'rpt_grd_19391','Type Of Insider','en-US',103011,104003,122095,'Type Of Insider',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19383')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19341', 0,10000,  0, 155001,114100, 'rpt_grd_19383')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19384')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19342',0, 20000,  0, 155001,114100, 'rpt_grd_19384')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19385')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19343',0, 30000,  0, 155001,114100, 'rpt_grd_19385')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19386')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19344',0, 40000,  0, 155001,114100, 'rpt_grd_19386')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19387')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19345',0, 50000,  0, 155001,114100, 'rpt_grd_19387')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19388')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19346',0, 60000,  0, 155001,114100, 'rpt_grd_19388')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19389')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19347', 0,70000, 0, 155001,114100, 'rpt_grd_19389')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19390')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19348',0, 80000,  0, 155001,114100, 'rpt_grd_19390')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19391')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19349',0, 90000, 0, 155001,114100, 'rpt_grd_19391')
END
GO

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19381')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19339',1, 100000, 0, 155001,114100, 'rpt_grd_19381')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19370')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19328',1, 110010,  0, 155001,114100, 'rpt_grd_19370')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19371')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19329',1, 120010,  0, 155001,114100, 'rpt_grd_19371')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19372')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19330',1, 130010,  0, 155001,114100, 'rpt_grd_19372')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19373')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19331', 1,140010,  0, 155001,114100, 'rpt_grd_19373')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19374')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19332',1, 150010, 0, 155001,114100, 'rpt_grd_19374')
END
GO

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19382')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19340',1, 160000,  0, 155001,114100, 'rpt_grd_19382')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19375')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19333',1, 170016, 0, 155001,114100, 'rpt_grd_19375')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19376')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19334',1, 180016,  0, 155001,114100, 'rpt_grd_19376')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19377')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19335',1, 190016,   0, 155001,114100, 'rpt_grd_19377')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19378')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19336',1, 200016,  0, 155001,114100, 'rpt_grd_19378')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19379')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19337',1, 210016,  0, 155001,114100, 'rpt_grd_19379')
END
GO
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE OverrideGridTypeCodeId = 114100 AND OverrideResourceKey = 'rpt_grd_19380')
BEGIN
	INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment, OverrideGridTypeCodeId, OverrideResourceKey)
	VALUES ( 114099 ,'rpt_grd_19338',1, 220016,   0, 155002,114100, 'rpt_grd_19380')
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11486)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11486, 'usr_msg_11486','Error occurred while fetching security holding list.','en-US',103002,104001,122093,'Error occurred while fetching security holding list.',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11487)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11487, 'usr_btn_11487','Transfer','en-US',103002,104004,122093,'Transfer',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11488)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11488, 'usr_btn_11488','Report','en-US',103002,104004,122093,'Report',1,GETDATE())
END
GO

/*
	
	Tushar 26-Oct-2016
	Hoilding List resources add
	
*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11489)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11489, 'usr_ttl_11489','Securities Holding List','en-US',103002,104006,122093,'Securities Holding List',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11490)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11490, 'usr_lbl_11490','Holding For','en-US',103002,104002,122093,'Holding For',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11491)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11491, 'usr_lbl_11491','Security Type','en-US',103002,104002,122093,'Security Type',1,GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11492)
BEGIN
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(11492, 'usr_lbl_11492','DEMAT Account Number','en-US',103002,104002,122093,'DEMAT Account Number',1,GETDATE())
END
GO


/*
	Scripts By Parag on 27 October 2016
	Resource for fixes made in axis bank code for date of acquisition validation
*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17530)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(17530, 'dis_msg_17530', 'Cannot submit disclosure because disclosure of earlier data of acquisition is not submitted. Please submit transcation whos date of acquisition earlier than current transcation''s date of acquistion.', 'Cannot submit disclosure because disclosure of earlier data of acquisition is not submitted. Please submit transcation whos date of acquisition earlier than current transcation''s date of acquistion.', 'en-US', 103009, 104001, 122048, 1, GETDATE())
END
GO

/*
	Scripts By Tushar on 27 October 2016
	Resource for fixes made in axis bank code for calculating  Percentage of pre & post transaction for securities.
*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17531)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(17531, 'dis_msg_17531', 'Error occurred while calculating  Percentage of pre & post transaction for securities.', 'Error occurred while calculating  Percentage of pre & post transaction for securities.', 'en-US', 103009, 104001, 122048, 1, GETDATE())
END
GO

/*
	Scripts By Parag on 02 November 2016
	Add resource for personal details confirmation message for each type of user
*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11493)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(11493, 'usr_lbl_11493', 'Are you sure you want to confirm personal details?', 'Are you sure you want to confirm personal details?', 'en-US', 103002, 104002, 122004, 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11494)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(11494, 'usr_lbl_11494', 'Are you sure you want to confirm personal details?', 'Are you sure you want to confirm personal details?', 'en-US', 103002, 104002, 122004, 1, GETDATE())
END
GO

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11495)
BEGIN
	INSERT INTO mst_Resource
		(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
	VALUES
		(11495, 'usr_lbl_11495', 'Are you sure you want to confirm personal details?', 'Are you sure you want to confirm personal details?', 'en-US', 103002, 104002, 122065, 1, GETDATE())
END
GO


/*
	Scripts By Raghvendra 3-Nov-2016
	Correct the screen code for the resources related to Popup to be shown for Enter and/or Upload functionality.
	Initially all the resources defined for Continuous and Period End had screen code as that of Initial Disclosure List.
	These scripts were sent to ESOP team on 3-Nov-2016 by Email.
*/

/*Continuous disclosure*/
UPDATE mst_Resource SET ScreenCodeId = 122066 WHERE ResourceId in (16462,16463,16464,16465,16466,16467,16468,16469,16470,16471)


/*Period End Disclosure*/
UPDATE mst_Resource SET ScreenCodeId = 122067 WHERE ResourceId in (16472,16473,16474,16475,16476,16477,16478,16479,16480,16481)