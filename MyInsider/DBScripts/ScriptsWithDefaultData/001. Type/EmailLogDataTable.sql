
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_SaveEmailLog')
BEGIN
DROP PROCEDURE st_com_SaveEmailLog
END
IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'EmailLogDataTable')
BEGIN
	DROP TYPE EmailLogDataTable
END
GO
IF NOT EXISTS (SELECT 1 FROM SYS.TYPES ST JOIN SYS.SCHEMAS SS ON ST.schema_id = SS.schema_id WHERE (ST.name = N'EmailLogDataTable') AND (SS.name = N'dbo'))
CREATE TYPE EmailLogDataTable AS TABLE
(
	ID						INT,
	UserInfoId				INT DEFAULT null,
	[To]					VARCHAR(Max) DEFAULT null,
	CC						VARCHAR(MAX) DEFAULT NULL,
	BCC						VARCHAR(MAX) DEFAULT NULL,
	[Subject]				VARCHAR(250) DEFAULT NULL,
	Contents				VARCHAR(MAX) DEFAULT NULL,
	[Signature]				VARCHAR(250) DEFAULT NULL,
	CommunicationFrom		VARCHAR(MAX) DEFAULT NULL,
	ResponseStatusCodeId	VARCHAR(100) DEFAULT NULL,
	ResponseMessage			VARCHAR(MAX) DEFAULT NULL,
	CreatedBy				INT,
	CreatedOn				VARCHAR(50),
	ModifiedBy				INT,
	ModifiedOn				VARCHAR(50)
)