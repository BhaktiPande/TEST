-- ======================================================================================================
-- Author      : Shubhangi Gurude,Tushar Wakchaure												=
-- CREATED DATE: 1-Feb-2017                                                 							=
-- Description : SCRIPT Used to create document table which is used to save groupwise document details												=
-- ======================================================================================================

IF NOT EXISTS(SELECT NAME FROM SYS.TABLES  WHERE NAME  = 'tra_NSEDocumentDetails')
BEGIN
	CREATE TABLE dbo.tra_NSEDocumentDetails
	(
		DocumentdetailsId   BIGINT IDENTITY NOT NULL,
		NSEGroupDetailsId   BIGINT NULL,
		DocumentObjectMapId INT NULL,
		CreatedBy           INT NULL,
		CreatedOn           DATETIME NULL,
		ModifiedBy          INT NULL,
		ModifiedOn          DATETIME NULL
	)
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE CONSTRAINT_NAME = 'PK_tra_NSEDocumentDetails')
BEGIN
	ALTER TABLE tra_NSEDocumentDetails ADD CONSTRAINT PK_tra_NSEDocumentDetails PRIMARY KEY (DocumentdetailsId)
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE CONSTRAINT_NAME = 'FK_tra_NSEDocumentDetails_tra_NSEGroupDetails')
BEGIN
	ALTER TABLE tra_NSEDocumentDetails ADD CONSTRAINT FK_tra_NSEDocumentDetails_tra_NSEGroupDetails FOREIGN KEY (NSEGroupDetailsId) REFERENCES dbo.tra_NSEGroupDetails (NSEGroupDetailsId)
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE CONSTRAINT_NAME = 'FK_tra_NSEDocumentDetails_com_DocumentObjectMapping')
BEGIN
	ALTER TABLE tra_NSEDocumentDetails ADD CONSTRAINT FK_tra_NSEDocumentDetails_com_DocumentObjectMapping FOREIGN KEY (DocumentObjectMapId) REFERENCES dbo.com_DocumentObjectMapping (DocumentObjectMapId)
END
GO