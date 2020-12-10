-- ======================================================================================================
-- Author      : Shubhangi Gurude,Tushar Wakchaure												=
-- CREATED DATE: 1-Feb-2017                                                 							=
-- Description : SCRIPT Used for NSE Group Creation  												=
-- ======================================================================================================

IF NOT EXISTS(SELECT NAME FROM SYS.TABLES  WHERE NAME  = 'tra_NSEGroup')
BEGIN
	CREATE TABLE dbo.tra_NSEGroup
	(
		GroupId        INT IDENTITY NOT NULL,
		DownloadedDate DATETIME NULL,
		SubmissionDate DATETIME NULL,
		StatusCodeId   INT NULL,
		TypeOfDownload INT NULL,
		DownloadStatus BIT NULL,
		CreatedBy      INT NULL,
		CreatedOn      DATETIME NULL,
		ModifiedBy     INT NULL,
		ModifiedOn     DATETIME NULL,
		CONSTRAINT PK_tra_NSEGroup PRIMARY KEY (GroupId),
		CONSTRAINT FK_tra_NSEGroup_com_Code FOREIGN KEY (StatusCodeId) REFERENCES dbo.com_Code (CodeID)
	)
END
GO
