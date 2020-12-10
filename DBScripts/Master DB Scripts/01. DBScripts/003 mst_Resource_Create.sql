/*
   Sunday, June 07, 20156:26:27 PM
   User: sa
   Server: FORINPOLITIX\MSSQLSERVER1
   Database: KPCS_InsiderTrading_Master
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
CREATE TABLE dbo.mst_Resource
	(
	ResourceId int NOT NULL IDENTITY (1, 1),
	ResourceKey varchar(15) NOT NULL,
	ResourceValue nvarchar(2000) NOT NULL,
	OriginalResourceValue nvarchar(2000) NOT NULL,
	ResourceCulture varchar(10) NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.mst_Resource ADD CONSTRAINT
	PK_mst_Resource PRIMARY KEY CLUSTERED 
	(
	ResourceId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.mst_Resource SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.mst_Resource', 'Object', 'CONTROL') as Contr_Per 

----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (3, '003 mst_Resource_Create.sql', 'Table mst_Resource Create', 'Ashashree')
