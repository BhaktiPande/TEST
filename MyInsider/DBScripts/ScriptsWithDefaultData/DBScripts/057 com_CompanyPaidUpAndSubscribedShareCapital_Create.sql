/*
   Wednesday, February 18, 20154:18:07 PM
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
CREATE TABLE dbo.com_CompanyPaidUpAndSubscribedShareCapital
	(
	CompanyPaidUpAndSubscribedShareCapitalID int NOT NULL IDENTITY (1, 1),
	PaidUpAndSubscribedShareCapitalDate datetime NOT NULL,
	PaidUpShare decimal(20, 5) NOT NULL,
	CompanyID int NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.com_CompanyPaidUpAndSubscribedShareCapital ADD CONSTRAINT
	PK_com_CompanyPaidUpAndSubscribedShareCapital PRIMARY KEY CLUSTERED 
	(
	CompanyPaidUpAndSubscribedShareCapitalID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.com_CompanyPaidUpAndSubscribedShareCapital SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_CompanyPaidUpAndSubscribedShareCapital', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CompanyPaidUpAndSubscribedShareCapital', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CompanyPaidUpAndSubscribedShareCapital', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------------------------
/*
   Wednesday, February 18, 20154:19:37 PM
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
ALTER TABLE dbo.usr_UserInfo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.usr_UserInfo', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.mst_Company SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Company', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.com_CompanyPaidUpAndSubscribedShareCapital ADD CONSTRAINT
	FK_com_CompanyPaidUpAndSubscribedShareCapital_mst_Company_CompanyId FOREIGN KEY
	(
	CompanyID
	) REFERENCES dbo.mst_Company
	(
	CompanyId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
select Has_Perms_By_Name(N'dbo.com_CompanyPaidUpAndSubscribedShareCapital', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_CompanyPaidUpAndSubscribedShareCapital', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_CompanyPaidUpAndSubscribedShareCapital', 'Object', 'CONTROL') as Contr_Per 
-----------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (57, '057 com_CompanyPaidUpAndSubscribedShareCapital_Create', 'Create com_CompanyPaidUpAndSubscribedShareCapital', 'Arundhati')
