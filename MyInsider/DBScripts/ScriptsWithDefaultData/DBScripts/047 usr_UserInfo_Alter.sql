/*
   Monday, February 09, 201512:16:44 PM
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
CREATE TABLE dbo.Tmp_usr_UserInfo
	(
	UserInfoId int NOT NULL IDENTITY (1, 1),
	EmailId nvarchar(250) NULL,
	FirstName nvarchar(50) NULL,
	MiddleName nvarchar(50) NULL,
	LastName nvarchar(50) NULL,
	EmployeeId nvarchar(50) NULL,
	MobileNumber nvarchar(15) NOT NULL,
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
	Location nvarchar(50) NULL,
	DepartmentId int NULL,
	UPSIAccessOfCompanyID int NULL,
	UserTypeCodeId int NOT NULL,
	StatusCodeId int NOT NULL,
	IsInsider int NOT NULL,
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
ALTER TABLE dbo.Tmp_usr_UserInfo ADD CONSTRAINT
	DF_usr_UserInfo_UserTypeCodeId DEFAULT ((101001)) FOR UserTypeCodeId
GO
ALTER TABLE dbo.Tmp_usr_UserInfo ADD CONSTRAINT
	DF_usr_UserInfo_StatusCodeId DEFAULT ((102001)) FOR StatusCodeId
GO
ALTER TABLE dbo.Tmp_usr_UserInfo ADD CONSTRAINT
	DF_usr_UserInfo_IsInsider DEFAULT ((0)) FOR IsInsider
GO
SET IDENTITY_INSERT dbo.Tmp_usr_UserInfo ON
GO
IF EXISTS(SELECT * FROM dbo.usr_UserInfo)
	 EXEC('INSERT INTO dbo.Tmp_usr_UserInfo (UserInfoId, EmailId, FirstName, MiddleName, LastName, EmployeeId, MobileNumber, AddressLine1, AddressLine2, CountryId, StateId, City, PinCode, ContactPerson, DateOfJoining, DateOfBecomingInsider, LandLine1, LandLine2, Website, PAN, TAN, Description, Category, SubCategory, GradeId, DesignationId, Location, DepartmentId, UPSIAccessOfCompanyID, UserTypeCodeId, StatusCodeId, IsInsider, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT UserInfoId, EmailId, FirstName, MiddleName, LastName, EmployeeId, MobileNumber, AddressLine1, AddressLine2, CountryId, StateId, City, PinCode, ContactPerson, DateOfJoining, DateOfBecomingInsider, LandLine1, LandLine2, Website, PAN, TAN, Description, Category, SubCategory, GradeId, DesignationId, Location, DepartmentId, UPSIAccessOfCompanyID, UserTypeCodeId, StatusCodeId, IsInsider, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.usr_UserInfo WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_usr_UserInfo OFF
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_DocumentDetails
	DROP CONSTRAINT FK_usr_DocumentDetails_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_DocumentDetails
	DROP CONSTRAINT FK_usr_DocumentDetails_usr_UserInfo_modifiedBy
GO
ALTER TABLE dbo.usr_DocumentDetails
	DROP CONSTRAINT FK_usr_DocumentDetails_usr_UserInfo_UserInfoID
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
ALTER TABLE dbo.usr_RoleMaster
	DROP CONSTRAINT FK_usr_RoleMaster_usr_UserInfo_Createdy
GO
ALTER TABLE dbo.usr_RoleMaster
	DROP CONSTRAINT FK_usr_RoleMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_usr_UserInfo_ModifiedBy
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
ALTER TABLE dbo.usr_UserRole
	DROP CONSTRAINT FK_usr_UserRole_usr_UserInfo_UserID
GO
ALTER TABLE dbo.mst_Resource
	DROP CONSTRAINT FK_mst_Resource_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_Authentication
	DROP CONSTRAINT FK_usr_Authentication_usr_UserInfo_UserInfoId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_CountryId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_DepartmentId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_designationId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_GradeId
GO
ALTER TABLE dbo.usr_UserInfo
	DROP CONSTRAINT FK_usr_UserInfo_com_Code_StateId
GO
ALTER TABLE dbo.com_Code
	DROP CONSTRAINT FK_com_Code_usr_UserInfo_ModifiedBy
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
ALTER TABLE dbo.usr_RoleActivity
	DROP CONSTRAINT FK_usr_RoleActivity_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_RoleActivity
	DROP CONSTRAINT FK_usr_RoleActivity_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.mst_Company
	DROP CONSTRAINT FK_mst_Company_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.mst_Company
	DROP CONSTRAINT FK_mst_Company_usr_UserInfo_ModifiedBy
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
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.mst_Company SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.usr_DocumentDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_DocumentDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_DocumentDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_DocumentDetails', 'Object', 'CONTROL') as Contr_Per 
------------------------------------------------------------------------------------------------------------

/*
   Monday, February 09, 201512:17:38 PM
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
ALTER TABLE dbo.mst_Company SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per 
------------------------------------------------------------------------------------------------------------

/*
   Monday, February 09, 20152:07:24 PM
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
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per 
------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (47, '047 usr_UserInfo_Alter', 'Added companyId, deleted CompanyName, added reference to mst_Company', 'Arundhati')
