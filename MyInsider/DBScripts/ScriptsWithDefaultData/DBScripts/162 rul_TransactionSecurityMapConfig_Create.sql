/*
   Friday, August 21, 20153:40:21 PM
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
CREATE TABLE dbo.rul_TransactionSecurityMapConfig
	(
	TransactionSecurityMapId int NOT NULL IDENTITY (1, 1),
	MapToTypeCodeId int NOT NULL,
	TransactionTypeCodeId int NOT NULL,
	SecurityTypeCodeId int NOT NULL
	)  ON [PRIMARY]
GO
DECLARE @v sql_variant 
SET @v = N'Running Id for the configuration table'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TransactionSecurityMapConfig', N'COLUMN', N'TransactionSecurityMapId'
GO
DECLARE @v sql_variant 
SET @v = N'Map type : 132004=preclearance, 132007=Prohibit Preclearance during non-trading'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TransactionSecurityMapConfig', N'COLUMN', N'MapToTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Transaction type code id : 143001=Buy, 143002=Sell, 143003=Cash exercise, 143004=Cashless All, 143005=Cashless partial'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TransactionSecurityMapConfig', N'COLUMN', N'TransactionTypeCodeId'
GO
DECLARE @v sql_variant 
SET @v = N'Security type code id : 139001=Shares, 139002=Warrants, 139003=Convertible Debentures, 139004=Future Contracts, 139005=Option Contracts'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'rul_TransactionSecurityMapConfig', N'COLUMN', N'SecurityTypeCodeId'
GO
ALTER TABLE dbo.rul_TransactionSecurityMapConfig ADD CONSTRAINT
	PK_rul_TransactionSecurityMapConfig PRIMARY KEY CLUSTERED 
	(
	TransactionSecurityMapId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.rul_TransactionSecurityMapConfig SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TransactionSecurityMapConfig', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TransactionSecurityMapConfig', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TransactionSecurityMapConfig', 'Object', 'CONTROL') as Contr_Per 


/*Add foreign key references and add unique key on MapToTypeCodeId + TransactionTypeCodeId + SecurityTypeCodeId*/

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
CREATE UNIQUE NONCLUSTERED INDEX IX_rul_TransactionSecurityMapConfig_MapType_TransactionType_SecurityType ON dbo.rul_TransactionSecurityMapConfig
	(
	MapToTypeCodeId,
	TransactionTypeCodeId,
	SecurityTypeCodeId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.rul_TransactionSecurityMapConfig ADD CONSTRAINT
	FK_rul_TransactionSecurityMapConfig_com_Code_MapToTypeCodeId FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TransactionSecurityMapConfig ADD CONSTRAINT
	FK_rul_TransactionSecurityMapConfig_com_Code_TransactionTypeCodeId FOREIGN KEY
	(
	TransactionTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TransactionSecurityMapConfig ADD CONSTRAINT
	FK_rul_TransactionSecurityMapConfig_com_Code_SecurityTypeCodeId FOREIGN KEY
	(
	SecurityTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TransactionSecurityMapConfig SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TransactionSecurityMapConfig', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TransactionSecurityMapConfig', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TransactionSecurityMapConfig', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (162, '162 rul_TransactionSecurityMapConfig_Create', 'Create rul_TransactionSecurityConfig', 'Ashashree')
