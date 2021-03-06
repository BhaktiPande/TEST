/*
   Tuesday, May 26, 201512:02:41 PM
   User: sa
   Server: EMERGEBOI
   Database: KPCS_InsiderTrading_Company1
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT DF_usr_UserInfo_UserTypeCodeId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT DF_usr_UserInfo_StatusCodeId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT DF_usr_UserInfo_IsInsider
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT DF_usr_UserInfo_ResetPasswordFlag
GO
CREATE TABLE dbo.Tmp_usr_UserInfo
	(
	UserInfoId int NOT NULL IDENTITY (1, 1),
	EmailId nvarchar(250) NULL,
	FirstName nvarchar(50) NULL,
	MiddleName nvarchar(50) NULL,
	LastName nvarchar(50) NULL,
	EmployeeId nvarchar(50) NULL,
	MobileNumber nvarchar(15) NULL,
	CompanyId int NULL,
	AddressLine1 nvarchar(500) NULL,
	AddressLine2 nvarchar(500) NULL,
	CountryId int NULL,
	StateId int NULL,
	City nvarchar(100) NULL,
	PinCode nvarchar(50) NULL,
	ContactPerson nvarchar(100) NULL,
	DateOfJoining datetime NULL,
	DateOfBecomingInsider datetime NULL,
	LandLine1 varchar(50) NULL,
	LandLine2 varchar(50) NULL,
	Website nvarchar(500) NULL,
	PAN nvarchar(50) NULL,
	TAN nvarchar(50) NULL,
	Description nvarchar(1024) NULL,
	Category int NULL,
	SubCategory int NULL,
	GradeId int NULL,
	DesignationId int NULL,
	SubDesignationId int NULL,
	Location nvarchar(50) NULL,
	DepartmentId int NULL,
	UPSIAccessOfCompanyID int NULL,
	UserTypeCodeId int NOT NULL,
	StatusCodeId int NOT NULL,
	IsInsider int NOT NULL,
	CategoryText nvarchar(100) NULL,
	SubCategoryText nvarchar(100) NULL,
	GradeText nvarchar(100) NULL,
	DesignationText nvarchar(100) NULL,
	SubDesignationText nvarchar(100) NULL,
	DepartmentText nvarchar(100) NULL,
	ResetPasswordFlag int NOT NULL,
	DateOfSeparation datetime NULL,
	ReasonForSeparation nvarchar(200) NULL,
	CIN nvarchar(50) NULL,
	DIN nvarchar(50) NULL,
	CreatedBy int NULL,
	CreatedOn datetime NULL,
	ModifiedBy int NULL,
	ModifiedOn datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'Insider / Non-Insider'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_usr_UserInfo', N'COLUMN', N'Category'
GO
DECLARE @v sql_variant 
SET @v = N'0: Not insider, 1: Insider'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_usr_UserInfo', N'COLUMN', N'IsInsider'
GO
DECLARE @v sql_variant 
SET @v = N'For nonemployee, category is captures as text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_usr_UserInfo', N'COLUMN', N'CategoryText'
GO
DECLARE @v sql_variant 
SET @v = N'For nonemployee, subcategory is captures as text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_usr_UserInfo', N'COLUMN', N'SubCategoryText'
GO
DECLARE @v sql_variant 
SET @v = N'For nonemployee, grade is captures as text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_usr_UserInfo', N'COLUMN', N'GradeText'
GO
DECLARE @v sql_variant 
SET @v = N'For nonemployee, designation is captures as text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_usr_UserInfo', N'COLUMN', N'DesignationText'
GO
DECLARE @v sql_variant 
SET @v = N'For nonemployee, subdesignation is captures as text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_usr_UserInfo', N'COLUMN', N'SubDesignationText'
GO
DECLARE @v sql_variant 
SET @v = N'For nonemployee, department is captures as text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_usr_UserInfo', N'COLUMN', N'DepartmentText'
GO
DECLARE @v sql_variant 
SET @v = N'1: Need to reset flag, 0: Otherwise'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_usr_UserInfo', N'COLUMN', N'ResetPasswordFlag'
GO
ALTER TABLE dbo.Tmp_usr_UserInfo ADD CONSTRAINT
	DF_usr_UserInfo_UserTypeCodeId DEFAULT ((101001)) FOR UserTypeCodeId
GO
ALTER TABLE dbo.Tmp_usr_UserInfo ADD CONSTRAINT
	DF_usr_UserInfo_StatusCodeId DEFAULT ((102001)) FOR StatusCodeId
GO
ALTER TABLE dbo.Tmp_usr_UserInfo ADD CONSTRAINT
	DF_usr_UserInfo_IsInsider DEFAULT ((0)) FOR IsInsider
GO
ALTER TABLE dbo.Tmp_usr_UserInfo ADD CONSTRAINT
	DF_usr_UserInfo_ResetPasswordFlag DEFAULT ((1)) FOR ResetPasswordFlag
GO
SET IDENTITY_INSERT dbo.Tmp_usr_UserInfo ON
GO
IF EXISTS(SELECT * FROM dbo.usr_UserInfo)
	 EXEC('INSERT INTO dbo.Tmp_usr_UserInfo (UserInfoId, EmailId, FirstName, MiddleName, LastName, EmployeeId, MobileNumber, CompanyId, AddressLine1, AddressLine2, CountryId, StateId, City, PinCode, ContactPerson, DateOfJoining, DateOfBecomingInsider, LandLine1, LandLine2, Website, PAN, TAN, Description, Category, SubCategory, GradeId, DesignationId, SubDesignationId, Location, DepartmentId, UPSIAccessOfCompanyID, UserTypeCodeId, StatusCodeId, IsInsider, CategoryText, SubCategoryText, GradeText, DesignationText, SubDesignationText, DepartmentText, ResetPasswordFlag, DateOfSeparation, ReasonForSeparation, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT UserInfoId, EmailId, FirstName, MiddleName, LastName, EmployeeId, MobileNumber, CompanyId, AddressLine1, AddressLine2, CountryId, StateId, City, PinCode, ContactPerson, DateOfJoining, DateOfBecomingInsider, LandLine1, LandLine2, Website, PAN, TAN, Description, Category, SubCategory, GradeId, DesignationId, SubDesignationId, Location, DepartmentId, UPSIAccessOfCompanyID, UserTypeCodeId, StatusCodeId, IsInsider, CategoryText, SubCategoryText, GradeText, DesignationText, SubDesignationText, DepartmentText, ResetPasswordFlag, DateOfSeparation, ReasonForSeparation, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.usr_UserInfo WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_usr_UserInfo OFF
GO
ALTER TABLE dbo.cmu_NotificationDocReference
	DROP CONSTRAINT FK_cmu_NotificationDocReference_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.cmu_NotificationDocReference
	DROP CONSTRAINT FK_cmu_NotificationDocReference_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters
	DROP CONSTRAINT FK_cmu_NotificationQueueParameters_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters
	DROP CONSTRAINT FK_cmu_NotificationQueueParameters_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT FK_rul_PolicyDocument_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.rul_PolicyDocument
	DROP CONSTRAINT FK_rul_PolicyDocument_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize
	DROP CONSTRAINT FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_UserId
GO
ALTER TABLE dbo.rul_TradingWindowEvent
	DROP CONSTRAINT FK_rul_TradingWindowEvent_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize
	DROP CONSTRAINT FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.rul_TradingWindowEvent
	DROP CONSTRAINT FK_rul_TradingWindowEvent_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize
	DROP CONSTRAINT FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster
	DROP CONSTRAINT FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster
	DROP CONSTRAINT FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_DocumentDetails
	DROP CONSTRAINT FK_usr_DocumentDetails_usr_UserInfo_modifiedBy
GO
ALTER TABLE dbo.usr_DocumentDetails
	DROP CONSTRAINT FK_usr_DocumentDetails_usr_UserInfo_UserInfoID
GO
ALTER TABLE dbo.usr_DocumentDetails
	DROP CONSTRAINT FK_usr_DocumentDetails_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_RoleMaster
	DROP CONSTRAINT FK_usr_RoleMaster_usr_UserInfo_Createdy
GO
ALTER TABLE dbo.usr_RoleMaster
	DROP CONSTRAINT FK_usr_RoleMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.com_CompanyPaidUpAndSubscribedShareCapital
	DROP CONSTRAINT FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.com_CompanyPaidUpAndSubscribedShareCapital
	DROP CONSTRAINT FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters
	DROP CONSTRAINT FK_cmu_NotificationQueueParameters_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.com_CompanyListingDetails
	DROP CONSTRAINT FK_com_CompanyListingDetails_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.com_CompanyListingDetails
	DROP CONSTRAINT FK_com_CompanyListingDetails_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer
	DROP CONSTRAINT FK_com_CompanyComplianceOfficer_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer
	DROP CONSTRAINT FK_com_CompanyComplianceOfficer_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserRelation
	DROP CONSTRAINT FK_usr_UserRelation_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.usr_UserRelation
	DROP CONSTRAINT FK_usr_UserRelation_usr_UserInfo_UserInfoIdRelative
GO
ALTER TABLE dbo.usr_UserRelation
	DROP CONSTRAINT FK_usr_UserRelation_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_UserRelation
	DROP CONSTRAINT FK_usr_UserRelation_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.com_Code
	DROP CONSTRAINT FK_com_Code_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_Category
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_SubCategory
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_CountryId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_DepartmentId
GO
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT FK_tra_TemplateMaster_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_designationId
GO
ALTER TABLE dbo.tra_TemplateMaster
	DROP CONSTRAINT FK_tra_TemplateMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_GradeId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_StateId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_SubDesignationId
GO
ALTER TABLE dbo.usr_DelegationMaster
	DROP CONSTRAINT FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdFrom
GO
ALTER TABLE dbo.usr_DelegationMaster
	DROP CONSTRAINT FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdTo
GO
ALTER TABLE dbo.usr_DelegationMaster
	DROP CONSTRAINT FK_usr_DelegationMaster_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_DelegationMaster
	DROP CONSTRAINT FK_usr_DelegationMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_RoleActivity
	DROP CONSTRAINT FK_usr_RoleActivity_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_RoleActivity
	DROP CONSTRAINT FK_usr_RoleActivity_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_usr_UserInfo_UserId
GO
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_DMATDetails
	DROP CONSTRAINT FK_usr_DMATDetails_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_DMATDetails
	DROP CONSTRAINT FK_usr_DMATDetails_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_DMATDetails
	DROP CONSTRAINT FK_usr_DMATDetails_usr_UserInfo_UserInfoID
GO
ALTER TABLE dbo.cmu_NotificationQueue
	DROP CONSTRAINT FK_cmu_NotificationQueue_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.mst_Resource
	DROP CONSTRAINT FK_mst_Resource_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_DMATAccountHolder
	DROP CONSTRAINT FK_usr_DMATAccountHolder_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_DMATAccountHolder
	DROP CONSTRAINT FK_usr_DMATAccountHolder_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_usr_UserInfo_ForUserId
GO
ALTER TABLE dbo.mst_MenuMaster
	DROP CONSTRAINT FK_mst_MenuMaster_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.mst_MenuMaster
	DROP CONSTRAINT FK_mst_MenuMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserRole
	DROP CONSTRAINT FK_usr_UserRole_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_UserRole
	DROP CONSTRAINT FK_usr_UserRole_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_UserRole
	DROP CONSTRAINT FK_usr_UserRole_usr_UserInfo_UserID
GO
ALTER TABLE dbo.tra_TransactionDetails
	DROP CONSTRAINT FK_tra_TransactionDetails_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.tra_TransactionLetter
	DROP CONSTRAINT FK_tra_TransactionLetter_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_Authentication
	DROP CONSTRAINT FK_usr_Authentication_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.tra_TransactionLetter
	DROP CONSTRAINT FK_tra_TransactionLetter_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.com_CompanyFaceValue
	DROP CONSTRAINT FK_com_CompanyFaceValue_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.com_CompanyFaceValue
	DROP CONSTRAINT FK_com_CompanyFaceValue_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.com_CompanyAuthorizedShareCapital
	DROP CONSTRAINT FK_com_CompanyAuthorizedShareCapital_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.com_CompanyAuthorizedShareCapital
	DROP CONSTRAINT FK_com_CompanyAuthorizedShareCapital_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.tra_PreclearanceRequest
	DROP CONSTRAINT FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoIdRelative
GO
ALTER TABLE dbo.usr_UserResetPassword
	DROP CONSTRAINT FK_usr_UserResetPassword_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.mst_Company
	DROP CONSTRAINT FK_mst_Company_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.com_Document
	DROP CONSTRAINT FK_com_Document_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.mst_Company
	DROP CONSTRAINT FK_mst_Company_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.com_Document
	DROP CONSTRAINT FK_com_Document_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_mst_Company_CompanyId
GO
ALTER TABLE dbo.eve_EventLog
	DROP CONSTRAINT FK_eve_EventLog_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.rul_ApplicabilityMaster
	DROP CONSTRAINT FK_rul_ApplicabilityMaster_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.rul_ApplicabilityMaster
	DROP CONSTRAINT FK_rul_ApplicabilityMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT FK_tra_TransactionMaster_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.rul_ApplicabilityDetails
	DROP CONSTRAINT FK_rul_ApplicabilityDetails_usr_UserInfo_UserId
GO
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT FK_tra_TransactionMaster_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.rul_ApplicabilityDetails
	DROP CONSTRAINT FK_rul_ApplicabilityDetails_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.tra_TransactionMaster
	DROP CONSTRAINT FK_tra_TransactionMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.rul_ApplicabilityDetails
	DROP CONSTRAINT FK_rul_ApplicabilityDetails_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster
	DROP CONSTRAINT FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_UserId
GO
ALTER TABLE dbo.tra_TransactionSummary
	DROP CONSTRAINT FK_tra_TransactionSummary_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.tra_TransactionSummary
	DROP CONSTRAINT FK_tra_TransactionSummary_usr_UserInfo_UserInfoIdRelative
GO
DROP TABLE dbo.usr_UserInfo
GO
EXECUTE sp_rename N'dbo.Tmp_usr_UserInfo', N'usr_UserInfo', 'OBJECT' 
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	PK_usr_UserInfo PRIMARY KEY CLUSTERED 
	(
	UserInfoId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
CREATE TRIGGER [dbo].[tr_usr_UserInfo_UserCreated] ON dbo.usr_UserInfo
FOR INSERT
AS
BEGIN
	DECLARE @nEventCodeID INT = 153001
	
	DECLARE @nUserTypeCodeId_COUser INT = 101002
	DECLARE @nUserTypeCodeId_Employee INT = 101003
	DECLARE @nUserTypeCodeId_CorporateUser INT = 101004
	DECLARE @nUserTypeCodeId_NonEmployee INT = 101006
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * INTO #tmpValues_New FROM INSERTED

	-- 
	INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId)
	SELECT @nEventCodeID, GETDATE(), UserInfoId, null, null
	FROM #tmpValues_New
	WHERE UserTypeCodeId IN (@nUserTypeCodeId_COUser, @nUserTypeCodeId_CorporateUser, @nUserTypeCodeId_Employee, @nUserTypeCodeId_NonEmployee)
	
    -- Insert statements for trigger here

END
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionSummary ADD CONSTRAINT
	FK_tra_TransactionSummary_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionSummary ADD CONSTRAINT
	FK_tra_TransactionSummary_usr_UserInfo_UserInfoIdRelative FOREIGN KEY
	(
	UserInfoIdRelative
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionSummary SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionSummary', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummary', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionSummary', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_usr_UserInfo_UserId FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails ADD CONSTRAINT
	FK_rul_ApplicabilityDetails_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityDetails', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	FK_tra_TransactionMaster_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	FK_tra_TransactionMaster_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionMaster ADD CONSTRAINT
	FK_tra_TransactionMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_ApplicabilityMaster ADD CONSTRAINT
	FK_rul_ApplicabilityMaster_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityMaster ADD CONSTRAINT
	FK_rul_ApplicabilityMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_ApplicabilityMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_ApplicabilityMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.eve_EventLog ADD CONSTRAINT
	FK_eve_EventLog_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.eve_EventLog SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.eve_EventLog', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Document ADD CONSTRAINT
	FK_com_Document_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Document SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Document', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Company ADD CONSTRAINT
	FK_mst_Company_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Company ADD CONSTRAINT
	FK_mst_Company_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_mst_Company_CompanyId FOREIGN KEY
	(
	CompanyId
	) REFERENCES dbo.mst_Company
	(
	CompanyId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Company SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_UserResetPassword ADD CONSTRAINT
	FK_usr_UserResetPassword_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserResetPassword SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserResetPassword', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserResetPassword', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserResetPassword', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest ADD CONSTRAINT
	FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoIdRelative FOREIGN KEY
	(
	UserInfoIdRelative
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_PreclearanceRequest SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_PreclearanceRequest', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_CompanyAuthorizedShareCapital ADD CONSTRAINT
	FK_com_CompanyAuthorizedShareCapital_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyAuthorizedShareCapital ADD CONSTRAINT
	FK_com_CompanyAuthorizedShareCapital_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyAuthorizedShareCapital SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CompanyAuthorizedShareCapital', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CompanyAuthorizedShareCapital', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CompanyAuthorizedShareCapital', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_CompanyFaceValue ADD CONSTRAINT
	FK_com_CompanyFaceValue_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyFaceValue ADD CONSTRAINT
	FK_com_CompanyFaceValue_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyFaceValue SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CompanyFaceValue', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CompanyFaceValue', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CompanyFaceValue', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_Authentication ADD CONSTRAINT
	FK_usr_Authentication_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoID
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_Authentication SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_Authentication', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_Authentication', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_Authentication', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionLetter ADD CONSTRAINT
	FK_tra_TransactionLetter_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionLetter ADD CONSTRAINT
	FK_tra_TransactionLetter_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionLetter SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionLetter', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_UserRole ADD CONSTRAINT
	FK_usr_UserRole_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserRole ADD CONSTRAINT
	FK_usr_UserRole_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserRole ADD CONSTRAINT
	FK_usr_UserRole_usr_UserInfo_UserID FOREIGN KEY
	(
	UserInfoID
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserRole SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserRole', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserRole', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserRole', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_MenuMaster ADD CONSTRAINT
	FK_mst_MenuMaster_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_MenuMaster ADD CONSTRAINT
	FK_mst_MenuMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_MenuMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_MenuMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_MenuMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_MenuMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_usr_UserInfo_ForUserId FOREIGN KEY
	(
	ForUserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails ADD CONSTRAINT
	FK_tra_TransactionDetails_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TransactionDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TransactionDetails', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_DMATAccountHolder ADD CONSTRAINT
	FK_usr_DMATAccountHolder_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DMATAccountHolder ADD CONSTRAINT
	FK_usr_DMATAccountHolder_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DMATAccountHolder SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_DMATAccountHolder', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_DMATAccountHolder', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_DMATAccountHolder', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Resource ADD CONSTRAINT
	FK_mst_Resource_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Resource SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_DMATDetails ADD CONSTRAINT
	FK_usr_DMATDetails_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DMATDetails ADD CONSTRAINT
	FK_usr_DMATDetails_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DMATDetails ADD CONSTRAINT
	FK_usr_DMATDetails_usr_UserInfo_UserInfoID FOREIGN KEY
	(
	UserInfoID
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DMATDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_Activity ADD CONSTRAINT
	FK_usr_Activity_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_Activity ADD CONSTRAINT
	FK_usr_Activity_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_Activity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_Activity', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_usr_UserInfo_UserId FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueue ADD CONSTRAINT
	FK_cmu_NotificationQueue_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueue SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueue', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_RoleActivity ADD CONSTRAINT
	FK_usr_RoleActivity_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_RoleActivity ADD CONSTRAINT
	FK_usr_RoleActivity_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_RoleActivity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_DelegationMaster ADD CONSTRAINT
	FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdFrom FOREIGN KEY
	(
	UserInfoIdFrom
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DelegationMaster ADD CONSTRAINT
	FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdTo FOREIGN KEY
	(
	UserInfoIdTo
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DelegationMaster ADD CONSTRAINT
	FK_usr_DelegationMaster_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DelegationMaster ADD CONSTRAINT
	FK_usr_DelegationMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DelegationMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_DelegationMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_DelegationMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_DelegationMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	FK_tra_TemplateMaster_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TemplateMaster ADD CONSTRAINT
	FK_tra_TemplateMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tra_TemplateMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tra_TemplateMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_Code ADD CONSTRAINT
	FK_com_Code_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_Category FOREIGN KEY
	(
	Category
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_SubCategory FOREIGN KEY
	(
	SubCategory
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_CountryId FOREIGN KEY
	(
	CountryId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_DepartmentId FOREIGN KEY
	(
	DepartmentId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_designationId FOREIGN KEY
	(
	DesignationId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_GradeId FOREIGN KEY
	(
	GradeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_StateId FOREIGN KEY
	(
	StateId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_SubDesignationId FOREIGN KEY
	(
	SubDesignationId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_UserRelation ADD CONSTRAINT
	FK_usr_UserRelation_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserRelation ADD CONSTRAINT
	FK_usr_UserRelation_usr_UserInfo_UserInfoIdRelative FOREIGN KEY
	(
	UserInfoIdRelative
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserRelation ADD CONSTRAINT
	FK_usr_UserRelation_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserRelation ADD CONSTRAINT
	FK_usr_UserRelation_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserRelation SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserRelation', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserRelation', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserRelation', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer ADD CONSTRAINT
	FK_com_CompanyComplianceOfficer_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer ADD CONSTRAINT
	FK_com_CompanyComplianceOfficer_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyComplianceOfficer SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CompanyComplianceOfficer', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CompanyComplianceOfficer', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CompanyComplianceOfficer', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_CompanyListingDetails ADD CONSTRAINT
	FK_com_CompanyListingDetails_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyListingDetails ADD CONSTRAINT
	FK_com_CompanyListingDetails_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyListingDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CompanyListingDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CompanyListingDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CompanyListingDetails', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_CompanyPaidUpAndSubscribedShareCapital ADD CONSTRAINT
	FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyPaidUpAndSubscribedShareCapital ADD CONSTRAINT
	FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.com_CompanyPaidUpAndSubscribedShareCapital SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CompanyPaidUpAndSubscribedShareCapital', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CompanyPaidUpAndSubscribedShareCapital', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CompanyPaidUpAndSubscribedShareCapital', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_RoleMaster ADD CONSTRAINT
	FK_usr_RoleMaster_usr_UserInfo_Createdy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_RoleMaster ADD CONSTRAINT
	FK_usr_RoleMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_RoleMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_RoleMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_DocumentDetails ADD CONSTRAINT
	FK_usr_DocumentDetails_usr_UserInfo_modifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DocumentDetails ADD CONSTRAINT
	FK_usr_DocumentDetails_usr_UserInfo_UserInfoID FOREIGN KEY
	(
	UserInfoID
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DocumentDetails ADD CONSTRAINT
	FK_usr_DocumentDetails_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DocumentDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_DocumentDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_DocumentDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_DocumentDetails', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster ADD CONSTRAINT
	FK_cmu_CommunicationRuleModeMaster_usr_UserInfo_UserId FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModeMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModeMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_TradingWindowEvent ADD CONSTRAINT
	FK_rul_TradingWindowEvent_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingWindowEvent ADD CONSTRAINT
	FK_rul_TradingWindowEvent_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingWindowEvent SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingWindowEvent', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_UserId FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize ADD CONSTRAINT
	FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_CommunicationRuleModePersonalize SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_CommunicationRuleModePersonalize', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_PolicyDocument ADD CONSTRAINT
	FK_rul_PolicyDocument_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_PolicyDocument ADD CONSTRAINT
	FK_rul_PolicyDocument_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_PolicyDocument SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_PolicyDocument', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters ADD CONSTRAINT
	FK_cmu_NotificationQueueParameters_usr_UserInfo_UserInfoId FOREIGN KEY
	(
	UserInfoId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationQueueParameters SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationQueueParameters', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.cmu_NotificationDocReference ADD CONSTRAINT
	FK_cmu_NotificationDocReference_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationDocReference ADD CONSTRAINT
	FK_cmu_NotificationDocReference_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.cmu_NotificationDocReference SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.cmu_NotificationDocReference', 'Object', 'CONTROL') as Contr_Per 

--------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (143, '143 usr_UserInfo_Alter', 'Alter UserInfo add CIN DIN', 'Arundhati')
