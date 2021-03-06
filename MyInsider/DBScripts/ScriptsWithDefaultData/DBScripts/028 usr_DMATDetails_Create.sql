/*
   30 January 201514:07:54
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
CREATE TABLE dbo.usr_DMATDetails
	(
	DMATDetailsID int NOT NULL,
	MainUserID int NOT NULL,
	UserID int NOT NULL,
	DEMATAccountNumber nvarchar(50) NOT NULL,
	DPBank nvarchar(200) NOT NULL,
	DPID varchar(50) NOT NULL,
	TMID varchar(50) NOT NULL,
	Description nvarchar(200) NOT NULL,
	CreatedBy int NOT NULL,
	CreatedOn datetime NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.usr_DMATDetails ADD CONSTRAINT
	PK_usr_DMATDetails PRIMARY KEY CLUSTERED 
	(
	DMATDetailsID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.usr_DMATDetails SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (28, '028 usr_DMATDetails_Create', 'To create DEMAT details table', 'Amar')