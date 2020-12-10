-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 05-APR-2016                                                 							=
-- Description : SCRIPTS FOR SEPARATION MASS-UPLOAD														=
-- ======================================================================================================


/* Insert Data into com_MassUploadExcel Table */
IF NOT EXISTS (SELECT MassUploadExcelId FROM com_MassUploadExcel WHERE MassUploadExcelId = 53)
BEGIN
	INSERT INTO com_MassUploadExcel (MassUploadExcelId, MassUploadName,HasMultipleSheets,TemplateFileName)
	VALUES (53,'Separation Mass Upload',0,'SeparationMassUploadTemplate')
END

/* Insert Data into com_MassUploadExcelSheets Table */
IF NOT EXISTS (SELECT MassUploadExcelSheetId FROM com_MassUploadExcelSheets WHERE MassUploadExcelSheetId = 53)
BEGIN
	INSERT INTO com_MassUploadExcelSheets(MassUploadExcelSheetId,MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
	VALUES 	(53,53,'Separation',1,NULL,'st_com_MassUploadCommonProcedureExecution',6)
END

/* Insert Data into com_MassUploadDataTable Table */
IF NOT EXISTS (SELECT MassUploadDataTableId FROM com_MassUploadDataTable WHERE MassUploadDataTableId = 53)
BEGIN
	INSERT INTO com_MassUploadDataTable(MassUploadDataTableId,MassUploadDataTableName) 
	VALUES (53,'MassSeparationDataTable')
END

/* Insert Data into com_MassUploadExcelDataTableColumnMapping Table */
IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5300)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping
		(MassUploadExcelDataTableColumnMappingId,MassUploadExcelSheetId,ExcelColumnNo,MassUploadDataTableId,MassUploadDataTablePropertyNo,
		MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType,MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,
		RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId,IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,
		IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode,
		DependentValueColumnNumber,DependentValueColumnValue,DependentValueColumnErrorCode)
	VALUES 
		(5300,53,0,53,1,'LoginId','String',200,0,0,NULL,1,NULL,200,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5301)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping
		(MassUploadExcelDataTableColumnMappingId,MassUploadExcelSheetId,ExcelColumnNo,MassUploadDataTableId,MassUploadDataTablePropertyNo,
		MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType,MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,
		RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId,IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,
		IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode,
		DependentValueColumnNumber,DependentValueColumnValue,DependentValueColumnErrorCode)
	VALUES 
		(5301,53,1,53,2,'EmployeeId','String',200,0,0,NULL,0,NULL,200,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5302)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping
		(MassUploadExcelDataTableColumnMappingId,MassUploadExcelSheetId,ExcelColumnNo,MassUploadDataTableId,MassUploadDataTablePropertyNo,
		MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType,MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,
		RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId,IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,
		IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode,
		DependentValueColumnNumber,DependentValueColumnValue,DependentValueColumnErrorCode)
	VALUES 
		(5302,53,2,53,3,'PAN','String',10,0,0,NULL,0,NULL,10,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5303)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping
		(MassUploadExcelDataTableColumnMappingId,MassUploadExcelSheetId,ExcelColumnNo,MassUploadDataTableId,MassUploadDataTablePropertyNo,
		MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType,MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,
		RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId,IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,
		IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode,
		DependentValueColumnNumber,DependentValueColumnValue,DependentValueColumnErrorCode)
	VALUES 
		(5303,53,3,53,4,'DateOfSeparation','Datetime',0,0,0,NULL,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5304)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping
		(MassUploadExcelDataTableColumnMappingId,MassUploadExcelSheetId,ExcelColumnNo,MassUploadDataTableId,MassUploadDataTablePropertyNo,
		MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType,MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,
		RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId,IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,
		IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode,
		DependentValueColumnNumber,DependentValueColumnValue,DependentValueColumnErrorCode)
	VALUES 
		(5304,53,4,53,5,'ReasonForSeparation','String',200,0,0,NULL,1,NULL,200,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5305)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping
		(MassUploadExcelDataTableColumnMappingId,MassUploadExcelSheetId,ExcelColumnNo,MassUploadDataTableId,MassUploadDataTablePropertyNo,
		MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType,MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,
		RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId,IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,
		IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode,
		DependentValueColumnNumber,DependentValueColumnValue,DependentValueColumnErrorCode)
	VALUES 
		(5305,53,5,53,6,'NoOfDaysToBeActive','Int',0,0,0,NULL,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END


/* Insert Data into com_MassUploadProcedureParameterDetails Table */
IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5301)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5301,53,1,53,5300,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5302)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5302,53,2,53,5301,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5303)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5303,53,3,53,5302,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5304)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5304,53,4,53,5303,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5305)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5305,53,5,53,5304,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5306)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5306,53,6,53,5305,NULL)
END

/* Separation Massupload LoginId Valodation */
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50056) 
BEGIN
	INSERT INTO mst_Resource 
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(50056,'mst_lbl_50056','Invalid value provided for LoginId','en-US',103004,104002,122032,'Invalid value provided for LoginId',1,GETDATE())
END