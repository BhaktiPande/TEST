/*
   Friday, January 30, 20153:58:35 PM
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
CREATE TABLE dbo.Tmp_usr_UserInfo
	(
	UserInfoId int NOT NULL IDENTITY (1, 1),
	EmailId nvarchar(250) NULL,
	FirstName nvarchar(50) NULL,
	MiddleName nvarchar(50) NULL,
	LastName nvarchar(50) NULL,
	MobileNumber nvarchar(15) NOT NULL,
	CompanyName nvarchar(100) NULL,
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
	ParentId int NULL,
	RelationWithEmployee int NULL,
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
SET IDENTITY_INSERT dbo.Tmp_usr_UserInfo ON
GO
IF EXISTS(SELECT * FROM dbo.usr_UserInfo)
	 EXEC('INSERT INTO dbo.Tmp_usr_UserInfo (UserInfoId, EmailId, FirstName, MiddleName, LastName, MobileNumber, CompanyName, AddressLine1, AddressLine2, CountryId, StateId, City, PinCode, ContactPerson, DateOfJoining, DateOfBecomingInsider, LandLine1, LandLine2, Website, PAN, TAN, Description, Category, SubCategory, GradeId, DesignationId, Location, DepartmentId, UPSIAccessOfCompanyID, ParentId, RelationWithEmployee, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT UserInfoId, EmailId, FirstName, MiddleName, LastName, MobileNumber, CompanyName, AddressLine1, AddressLine2, CountryId, StateId, City, PinCode, ContactPerson, DateOfJoining, DateOfBecomingInsider, LandLine1, LandLine2, Website, PAN, TAN, Description, Category, SubCategory, Grade, Designation, Location, Department, UPSIAccessOfCompanyID, ParentId, RelationWithEmployee, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn FROM dbo.usr_UserInfo WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_usr_UserInfo OFF
GO
ALTER TABLE dbo.usr_DMATDetails
	DROP CONSTRAINT FK_usr_DMATDetails_usr_UserInfo_UserID
GO
ALTER TABLE dbo.usr_DMATDetails
	DROP CONSTRAINT FK_usr_DMATDetails_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_DMATDetails
	DROP CONSTRAINT FK_usr_DMATDetails_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_DocumentDetails
	DROP CONSTRAINT FK_usr_DocumentDetails_usr_UserInfo_UserID
GO
ALTER TABLE dbo.usr_DocumentDetails
	DROP CONSTRAINT FK_usr_DocumentDetails_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_DocumentDetails
	DROP CONSTRAINT FK_usr_DocumentDetails_usr_UserInfo_modifiedBy
GO
ALTER TABLE dbo.usr_Authentication
	DROP CONSTRAINT FK_usr_Authentication_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_Authentication
	DROP CONSTRAINT FK_usr_Authentication_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.mst_Department
	DROP CONSTRAINT FK_mst_Department_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.mst_Department
	DROP CONSTRAINT FK_mst_Department_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_RoleMaster
	DROP CONSTRAINT FK_usr_RoleMaster_usr_UserInfo_Createdy
GO
ALTER TABLE dbo.usr_RoleMaster
	DROP CONSTRAINT FK_usr_RoleMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.mst_Country
	DROP CONSTRAINT FK_mst_Country_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.mst_Country
	DROP CONSTRAINT FK_mst_Country_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.mst_State
	DROP CONSTRAINT FK_mst_State_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.mst_State
	DROP CONSTRAINT FK_mst_State_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.mst_Designation
	DROP CONSTRAINT FK_mst_Designation_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.mst_Designation
	DROP CONSTRAINT FK_mst_Designation_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.mst_Grade
	DROP CONSTRAINT FK_mst_Grade_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.mst_Grade
	DROP CONSTRAINT FK_mst_Grade_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_UserRole
	DROP CONSTRAINT FK_usr_UserRole_usr_UserInfo_UserID
GO
ALTER TABLE dbo.usr_UserRole
	DROP CONSTRAINT FK_usr_UserRole_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_UserRole
	DROP CONSTRAINT FK_usr_UserRole_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_Activity
	DROP CONSTRAINT FK_usr_Activity_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_RoleActivity
	DROP CONSTRAINT FK_usr_RoleActivity_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.usr_RoleActivity
	DROP CONSTRAINT FK_usr_RoleActivity_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.mst_MenuMaster
	DROP CONSTRAINT FK_mst_MenuMaster_usr_UserInfo_CreatedBy
GO
ALTER TABLE dbo.mst_MenuMaster
	DROP CONSTRAINT FK_mst_MenuMaster_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.mst_Resource
	DROP CONSTRAINT FK_mst_Resource_usr_UserInfo_ModifiedBy
GO
ALTER TABLE dbo.usr_DMATDetails
	DROP CONSTRAINT FK_usr_DMATDetails_usr_UserInfo_MainUserID
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
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.usr_RoleActivity SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_RoleActivity', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.usr_UserRole ADD CONSTRAINT
	FK_usr_UserRole_usr_UserInfo_UserID FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.usr_UserRole SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserRole', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserRole', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserRole', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Grade ADD CONSTRAINT
	FK_mst_Grade_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Grade ADD CONSTRAINT
	FK_mst_Grade_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Grade SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Grade', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Grade', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Grade', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Designation ADD CONSTRAINT
	FK_mst_Designation_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Designation ADD CONSTRAINT
	FK_mst_Designation_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Designation SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Designation', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Designation', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Designation', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_State ADD CONSTRAINT
	FK_mst_State_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_State ADD CONSTRAINT
	FK_mst_State_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_State SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_State', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_State', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_State', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Country ADD CONSTRAINT
	FK_mst_Country_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Country ADD CONSTRAINT
	FK_mst_Country_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Country SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Country', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Country', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Country', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
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
ALTER TABLE dbo.mst_Department ADD CONSTRAINT
	FK_mst_Department_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	CreatedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Department ADD CONSTRAINT
	FK_mst_Department_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	ModifiedBy
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.mst_Department SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Department', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Department', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Department', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_Authentication ADD CONSTRAINT
	FK_usr_Authentication_usr_UserInfo_CreatedBy FOREIGN KEY
	(
	AuthenticationId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_Authentication ADD CONSTRAINT
	FK_usr_Authentication_usr_UserInfo_ModifiedBy FOREIGN KEY
	(
	AuthenticationId
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
ALTER TABLE dbo.usr_DocumentDetails ADD CONSTRAINT
	FK_usr_DocumentDetails_usr_UserInfo_UserID FOREIGN KEY
	(
	UserID
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
ALTER TABLE dbo.usr_DocumentDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_DocumentDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_DocumentDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_DocumentDetails', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_DMATDetails ADD CONSTRAINT
	FK_usr_DMATDetails_usr_UserInfo_UserID FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
	FK_usr_DMATDetails_usr_UserInfo_MainUserID FOREIGN KEY
	(
	MainUserID
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_DMATDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_DMATDetails', 'Object', 'CONTROL') as Contr_Per 

GO
-----------------------------------------------------------------------------------------------------------------------



/*
   Friday, January 30, 20154:04:30 PM
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
ALTER TABLE dbo.mst_Designation SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Designation', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Designation', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Designation', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Grade SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Grade', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Grade', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Grade', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Department SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Department', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Department', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Department', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_State SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_State', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_State', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_State', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Country SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Country', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Country', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Country', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_mst_Country_CountryId FOREIGN KEY
	(
	CountryId
	) REFERENCES dbo.mst_Country
	(
	CountryID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_mst_State_StateId FOREIGN KEY
	(
	StateId
	) REFERENCES dbo.mst_State
	(
	StateID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_mst_Department_DepartmentId FOREIGN KEY
	(
	DepartmentId
	) REFERENCES dbo.mst_Department
	(
	DepartmentID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_mst_Grade_GradeId FOREIGN KEY
	(
	GradeId
	) REFERENCES dbo.mst_Grade
	(
	GradeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_mst_Designation_DesignationId FOREIGN KEY
	(
	DesignationId
	) REFERENCES dbo.mst_Designation
	(
	DesignationID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_usr_UserInfo_ParentId FOREIGN KEY
	(
	ParentId
	) REFERENCES dbo.usr_UserInfo
	(
	UserInfoId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.usr_UserInfo ADD CONSTRAINT
	FK_usr_UserInfo_com_Code_RelationCodeId FOREIGN KEY
	(
	RelationWithEmployee
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per 

GO
------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (34, '034 usr_UserInfo_Alter', 'To add references on User table', 'Arundhati')
