/*
   30 January 201514:36:16
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
CREATE TABLE dbo.usr_DocumentDetails
	(
	DocumentDetailsID int NOT NULL,
	UserID int NOT NULL,
	GUID varchar(100) NOT NULL,
	DocumentName nvarchar(200) NOT NULL,
	Description nvarchar(512) NOT NULL,
	DocumentPath nvarchar(512) NOT NULL,
	FileSize nvarchar(20) NOT NULL,
	FileType nvarchar(50) NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.usr_DocumentDetails ADD CONSTRAINT
	PK_usr_DocumentDetails PRIMARY KEY CLUSTERED 
	(
	DocumentDetailsID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.usr_DocumentDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (30, '030 usr_DocumentDetails_Create', 'To create document details table', 'Amar')