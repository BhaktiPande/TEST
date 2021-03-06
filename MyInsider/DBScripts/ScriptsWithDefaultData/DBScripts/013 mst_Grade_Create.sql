/*
   29 January 201514:57:34
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
CREATE TABLE dbo.mst_Grade
	(
	GradeID int NOT NULL,
	GradeName nvarchar(512) NOT NULL,
	StatusCodeID int NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.mst_Grade ADD CONSTRAINT
	PK_mst_Grade PRIMARY KEY CLUSTERED 
	(
	GradeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.mst_Grade SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (13, '013 mst_Grade_Create', 'To create grade table', 'Amar')