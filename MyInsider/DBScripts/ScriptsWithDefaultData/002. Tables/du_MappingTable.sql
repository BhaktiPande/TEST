/*
	CREATED BY  :	AKHILESH KAMATE
	CREATED ON  :	19-DEC-2015
	DESCRIPTION :	THIS TABLE IS USED TO MAINTAIN MAPPING TABLES
*/


IF NOT EXISTS(SELECT NAME FROM SYS.TABLES WHERE UPPER(NAME) = 'TEMP_TABLE_DU_MAPPINGTABLES')
	BEGIN
		SELECT * INTO TEMP_TABLE_DU_MAPPINGTABLES FROM du_MappingTables
	END
GO

IF OBJECT_ID('dbo.[FK_du_MappingTables_du_MappingExcelSheetDetails]') IS NOT NULL 
BEGIN
	ALTER TABLE du_MappingTables DROP CONSTRAINT [FK_du_MappingTables_du_MappingExcelSheetDetails]
END
GO

IF OBJECT_ID('dbo.[FK_du_MappingFields_du_MappingTables]') IS NOT NULL 
BEGIN
	ALTER TABLE du_MappingFields DROP CONSTRAINT [FK_du_MappingFields_du_MappingTables]
END
GO

IF OBJECT_ID('dbo.[FK_du_SFTPFileDetails_du_MappingTables]') IS NOT NULL 
BEGIN
	ALTER TABLE du_SFTPFileDetails DROP CONSTRAINT [FK_du_SFTPFileDetails_du_MappingTables]
END
GO

IF EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'du_MappingTables')
BEGIN
	DROP TABLE du_MappingTables
END
GO

IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE UPPER(NAME) = 'du_MappingTables')
BEGIN
	CREATE TABLE du_MappingTables
	(
		MappingTableID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
		ExcelSheetDetailsID INT NOT NULL,
		ActualTableName VARCHAR(50) NOT NULL,
		DisplayName VARCHAR(50) NOT NULL,
		FilePath VARCHAR(500),
		[FileName] VARCHAR(250),
		ExcelSheetName VARCHAR(250),
		UploadMode VARCHAR(100),
		Query TEXT,
		ConnectionString VARCHAR(MAX),
		IsSFTPEnable BIT DEFAULT 0,
		CreatedBy INT NOT NULL,
		CreatedOn DATETIME NOT NULL,
		ModifiedBy INT NOT NULL,
		ModifiedOn DATETIME NOT NULL,	
	) 
	
	ALTER TABLE [dbo].[du_MappingTables]  WITH CHECK ADD  CONSTRAINT [FK_du_MappingTables_du_MappingExcelSheetDetails] FOREIGN KEY([ExcelSheetDetailsID])
	REFERENCES [dbo].[du_MappingExcelSheetDetails] ([ExcelSheetDetailsID])
	
END
GO

IF ((SELECT COUNT(MappingTableID) FROM du_MappingTables) = 0)
BEGIN 
	
	IF EXISTS(SELECT NAME FROM SYS.TABLES WHERE UPPER(NAME) = 'TEMP_TABLE_DU_MAPPINGTABLES')	
	BEGIN
			
		SET IDENTITY_INSERT du_MappingTables ON
	
		INSERT INTO du_MappingTables
		(
			MappingTableID, ExcelSheetDetailsID, ActualTableName, DisplayName, FilePath, [FileName], ExcelSheetName, UploadMode, Query, ConnectionString, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
		)
		SELECT MappingTableID, ExcelSheetDetailsID, ActualTableName, DisplayName, FilePath, [FileName], ExcelSheetName, UploadMode, Query, ConnectionString, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
		FROM TEMP_TABLE_DU_MAPPINGTABLES

		SET IDENTITY_INSERT du_MappingTables OFF
		
		DROP TABLE TEMP_TABLE_DU_MAPPINGTABLES
	END	
	
	IF EXISTS (SELECT NAME FROM SYS.TABLES WHERE UPPER(NAME) = 'du_MappingFields')
	BEGIN
		ALTER TABLE [dbo].[du_MappingFields]  WITH CHECK ADD  CONSTRAINT [FK_du_MappingFields_du_MappingTables] FOREIGN KEY([MappingTableID])
		REFERENCES [dbo].[du_MappingTables] ([MappingTableID])
	END
	
	IF EXISTS (SELECT NAME FROM SYS.TABLES WHERE UPPER(NAME) = 'du_SFTPFileDetails')
	BEGIN
		ALTER TABLE [dbo].[du_SFTPFileDetails]  WITH CHECK ADD  CONSTRAINT [FK_du_SFTPFileDetails_du_MappingTables] FOREIGN KEY([MappingTableID])
		REFERENCES [dbo].[du_MappingTables] ([MappingTableID])
	END
END
GO

