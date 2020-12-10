IF NOT EXISTS(SELECT name FROM SYS.tables WHERE [name]='rnt_MassUploadDetails_bak')
BEGIN
	CREATE TABLE rnt_MassUploadDetails_bak
	(	
		RntBackupId			INT IDENTITY(1,1),
		LotNumber			VARCHAR(50), 	
		BackUpDate			DATETIME,
		RntInfoId			INT,
		RntUploadDate		DATETIME,
		PANNumber			VARCHAR(50),
		SecurityType		VARCHAR(50),
		SecurityTypeCode	VARCHAR(50),
		DPID				VARCHAR(50),
		ClientId			VARCHAR(50),
		DematAccountNo		VARCHAR(50),
		UserInfoId			VARCHAR(50),
		UserName			VARCHAR(200),
		Shares				DECIMAL(10,0),
		Equity				DECIMAL(10,2),
		Category			VARCHAR(50),
		CreatedBy			INT,
		CreatedOn			DATETIME,
		ModifiedBy			INT,
		ModifiedOn			DATETIME
	)
END
GO

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (215, '215 rnt_MassUploadDetails_bak_Create', 'rnt_MassUploadDetails_bak Create', 'ED 18-Dec')
