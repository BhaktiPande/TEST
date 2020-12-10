-- ======================================================================================================
-- Author      : Shubhangi Gurude,Tushar Wakchaure												=
-- CREATED DATE: 1-Feb-2017                                                 							=
-- Description : SCRIPT Used for NSE Group details table Creation  												=
-- ======================================================================================================

IF NOT EXISTS(SELECT NAME FROM SYS.TABLES  WHERE NAME  = 'tra_NSEGroupDetails')
BEGIN
	CREATE TABLE dbo.tra_NSEGroupDetails
	(
		NSEGroupDetailsId   BIGINT IDENTITY NOT NULL,
		GroupId             INT NULL,
		UserInfoId          INT NULL,
		TransactionMasterId BIGINT NULL,
		CreatedBy           INT NULL,
		CreatedOn           DATETIME NULL,
		ModifiedBy          INT NULL,
		ModifiedOn          DATETIME NULL,
		CONSTRAINT PK_tra_NSEGroupDetails PRIMARY KEY (NSEGroupDetailsId),
		CONSTRAINT FK_tra_NSEGroupDetails_tra_NSEGroup FOREIGN KEY (GroupId) REFERENCES dbo.tra_NSEGroup (GroupId),
		CONSTRAINT FK_tra_NSEGroupDetails_usr_UserInfo FOREIGN KEY (UserInfoId) REFERENCES dbo.usr_UserInfo (UserInfoId),
		CONSTRAINT FK_tra_NSEGroupDetails_tra_TransactionMaster FOREIGN KEY (TransactionMasterId) REFERENCES dbo.tra_TransactionMaster (TransactionMasterId)
	)
END
GO