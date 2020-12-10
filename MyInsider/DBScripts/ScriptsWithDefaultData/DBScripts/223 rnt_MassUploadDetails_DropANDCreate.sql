IF EXISTS(SELECT name FROM SYS.tables WHERE [name]='rnt_MassUploadDetails')	
BEGIN
DROP TABLE rnt_MassUploadDetails
END

GO

CREATE TABLE rnt_MassUploadDetails
(
	RntInfoId			INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	RntUploadDate		DATETIME NOT NULL,
	PANNumber			VARCHAR(20),
	SecurityType		VARCHAR(50),
	SecurityTypeCode	VARCHAR(50),
	DPID				VARCHAR(50),
	ClientId			VARCHAR(50),
	DematAccountNo		VARCHAR(50),
	UserInfoId			VARCHAR(50),
	UserName			VARCHAR(200),
	Shares				VARCHAR(50),
	CreatedBy			INT,
	CreatedOn			DATETIME,
	ModifiedBy			INT,
	ModifiedOn			DATETIME
)

GO
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (223, '223 rnt_MassUploadDetails_DropANDCreate', 'rnt_MassUploadDetails Drop AND Create', 'ED 04-Jan')