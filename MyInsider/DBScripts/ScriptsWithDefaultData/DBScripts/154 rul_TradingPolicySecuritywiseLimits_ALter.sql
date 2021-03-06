/*
   Friday, July 03, 201511:12:14 AM
   User: sa
   Server: emergeboi
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
ALTER TABLE dbo.rul_TradingPolicySecuritywiseLimits
	DROP CONSTRAINT FK_rul_TradingPolicySecuritywiseLimits_com_Code_SecurityTypeCodeId
GO
ALTER TABLE dbo.rul_TradingPolicySecuritywiseLimits
	DROP CONSTRAINT FK_rul_TradingPolicySecuritywiseLimits_com_Code_MapToTypeCodeId
GO
ALTER TABLE dbo.com_Code SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.com_Code', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.rul_TradingPolicySecuritywiseLimits
	DROP CONSTRAINT FK_rul_TradingPolicySecuritywiseLimits_rul_TradingPolicy_TradingPolicyId
GO
ALTER TABLE dbo.rul_TradingPolicy SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicy', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_rul_TradingPolicySecuritywiseLimits
	(
	TradingPolicyId int NOT NULL,
	SecurityTypeCodeId int NULL,
	MapToTypeCodeId int NOT NULL,
	NoOfShares int NULL,
	PercPaidSubscribedCap decimal(15, 4) NULL,
	ValueOfShares decimal(18, 4) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_rul_TradingPolicySecuritywiseLimits SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.rul_TradingPolicySecuritywiseLimits)
	 EXEC('INSERT INTO dbo.Tmp_rul_TradingPolicySecuritywiseLimits (TradingPolicyId, SecurityTypeCodeId, MapToTypeCodeId, NoOfShares, PercPaidSubscribedCap, ValueOfShares)
		SELECT TradingPolicyId, SecurityTypeCodeId, MapToTypeCodeId, NoOfShares, PercPaidSubscribedCap, ValueOfShares FROM dbo.rul_TradingPolicySecuritywiseLimits WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.rul_TradingPolicySecuritywiseLimits
GO
EXECUTE sp_rename N'dbo.Tmp_rul_TradingPolicySecuritywiseLimits', N'rul_TradingPolicySecuritywiseLimits', 'OBJECT' 
GO
CREATE UNIQUE NONCLUSTERED INDEX Uk_rul_TradingPolicySecuritywiseLimits ON dbo.rul_TradingPolicySecuritywiseLimits
	(
	TradingPolicyId,
	SecurityTypeCodeId,
	MapToTypeCodeId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.rul_TradingPolicySecuritywiseLimits ADD CONSTRAINT
	FK_rul_TradingPolicySecuritywiseLimits_rul_TradingPolicy_TradingPolicyId FOREIGN KEY
	(
	TradingPolicyId
	) REFERENCES dbo.rul_TradingPolicy
	(
	TradingPolicyId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicySecuritywiseLimits ADD CONSTRAINT
	FK_rul_TradingPolicySecuritywiseLimits_com_Code_SecurityTypeCodeId FOREIGN KEY
	(
	SecurityTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.rul_TradingPolicySecuritywiseLimits ADD CONSTRAINT
	FK_rul_TradingPolicySecuritywiseLimits_com_Code_MapToTypeCodeId FOREIGN KEY
	(
	MapToTypeCodeId
	) REFERENCES dbo.com_Code
	(
	CodeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingPolicySecuritywiseLimits', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicySecuritywiseLimits', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicySecuritywiseLimits', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------

/*
   Friday, July 03, 201511:27:22 AM
   User: sa
   Server: emergeboi
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
ALTER TABLE dbo.rul_TradingPolicySecuritywiseLimits ADD CONSTRAINT
	CK_rul_TradingPolicySecuritywiseLimits_NoValuePer_AllNotNull CHECK (NoOfShares IS NOT NULL OR PercPaidSubscribedCap IS NOT NULL OR ValueOfShares IS NOT NULL)
GO
ALTER TABLE dbo.rul_TradingPolicySecuritywiseLimits SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.rul_TradingPolicySecuritywiseLimits', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicySecuritywiseLimits', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.rul_TradingPolicySecuritywiseLimits', 'Object', 'CONTROL') as Contr_Per 
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (154, '154 rul_TradingPolicySecuritywiseLimits_ALter', 'ALter rul_TradingPolicySecuritywiseLimits, allow null on NoOfShares, PercPaidSubscribedCap, ValueOfShares', 'Arundhati')
