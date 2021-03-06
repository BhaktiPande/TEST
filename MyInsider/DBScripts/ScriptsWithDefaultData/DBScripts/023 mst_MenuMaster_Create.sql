/*
   29 January 201516:35:29
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
CREATE TABLE dbo.mst_MenuMaster
	(
	MenuID int NOT NULL,
	MenuName nvarchar(200) NOT NULL,
	Description nvarchar(512) NULL,
	MenuURL nvarchar(512) NULL,
	DisplayOrder int NOT NULL,
	ParentMenuID int NULL,
	StatusCodeID int NOT NULL,
	ImageURL nvarchar(512) NULL,
	ToolTipText nvarchar(512) NULL,
	ActivityID int NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.mst_MenuMaster ADD CONSTRAINT
	PK_mst_MenuMaster PRIMARY KEY CLUSTERED 
	(
	MenuID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.mst_MenuMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (23, '023 mst_MenuMaster_Create', 'To create menu master table', 'Amar')