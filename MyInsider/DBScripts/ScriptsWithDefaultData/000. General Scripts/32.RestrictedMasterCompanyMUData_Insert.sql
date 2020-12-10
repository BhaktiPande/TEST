
-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 27-JUL-2016                                                 							=
-- Description : SCRIPTS FOR RESTRICTED LIST MASTER COMPANY MASS-UPLOAD									=
-- ======================================================================================================

/* INSERT INTO com_MassUploadExcel */
IF NOT EXISTS(SELECT MassUploadExcelId FROM com_MassUploadExcel WHERE MassUploadExcelId = 55)
BEGIN
	INSERT INTO com_MassUploadExcel(MassUploadExcelId, MassUploadName, HasMultipleSheets, TemplateFileName) 
	VALUES (55,'Restricted List Master Company',0,'RLCompanyMassUploadTemplate')
END

IF NOT EXISTS(SELECT MassUploadDataTableId FROM com_MassUploadDataTable WHERE MassUploadDataTableId = 55)
BEGIN
	INSERT INTO com_MassUploadDataTable (MassUploadDataTableId, MassUploadDataTableName) 
	VALUES (55, 'MassRistrictedMasterCompanyDataTable')
END

/* Insert Data into com_MassUploadExcelSheets Table */
IF NOT EXISTS (SELECT MassUploadExcelSheetId FROM com_MassUploadExcelSheets WHERE MassUploadExcelSheetId = 55)
BEGIN
	INSERT INTO com_MassUploadExcelSheets(MassUploadExcelSheetId,MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
	VALUES 	(55,55,'RestrictedMasterCompany',1,NULL,'st_com_MassUploadCommonProcedureExecution',4)
END

/* Insert Data into com_MassUploadExcelDataTableColumnMapping Table */
IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5500)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5500,55,0,55,1,'CompanyName','string',200,0,0,NULL,1,NULL,200,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5501)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5501,55,1,55,2,'BSECode','string',50,0,0,NULL,0,NULL,200,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5502)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5502,55,2,55,3,'NSECode','string',50,0,0,NULL,0,NULL,200,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5503)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5503,55,3,55,4,'ISIN','string',50,0,0,NULL,1,NULL,200,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

/* INSERT DATA INTO COM_MASSUPLOAD PROCEDURE PARAMETERDETAILS TABLE */
IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5501)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5501,55,1,55,5500,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5502)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5502,55,2,55,5501,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5503)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5503,55,3,55,5502,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5504)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5504,55,4,55,5503,NULL)
END


/* ALLOW NULL FOR BSC AND NSE COLUMN IN rl_CompanyMasterList */

ALTER TABLE rl_CompanyMasterList
ALTER COLUMN BSECode VARCHAR(300) NULL 

ALTER TABLE rl_CompanyMasterList
ALTER COLUMN NSECode VARCHAR(300) NULL 

