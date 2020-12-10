-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 27-JUL-2016                                                 							=
-- Description : SCRIPTS FOR RESTRICTED LIST MASS-UPLOAD												=
-- ======================================================================================================



/* INSERT INTO com_MassUploadExcel */
IF NOT EXISTS(SELECT MassUploadExcelId FROM com_MassUploadExcel WHERE MassUploadExcelId = 54)
BEGIN
	INSERT INTO com_MassUploadExcel(MassUploadExcelId, MassUploadName, HasMultipleSheets, TemplateFileName) 
	VALUES (54,'Restricted List Mass Upload',0,'RestrictedListMassUploadTemplate')
END

IF NOT EXISTS(SELECT MassUploadDataTableId FROM com_MassUploadDataTable WHERE MassUploadDataTableId = 54)
BEGIN
	INSERT INTO com_MassUploadDataTable (MassUploadDataTableId, MassUploadDataTableName) 
	VALUES (54, 'MassRestrictedListAppliDataTable')
END

/* Insert Data into com_MassUploadExcelSheets Table */
IF NOT EXISTS (SELECT MassUploadExcelSheetId FROM com_MassUploadExcelSheets WHERE MassUploadExcelSheetId = 54)
BEGIN
	INSERT INTO com_MassUploadExcelSheets(MassUploadExcelSheetId,MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
	VALUES 	(54,54,'RestrictedListMassUpload',1,NULL,'st_com_MassUploadCommonProcedureExecution',8)
END

/* Insert Data into com_MassUploadExcelDataTableColumnMapping Table */
IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5400)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5400,54,0,54,1,'EmployeeID','string',500,0,0,NULL,1,NULL,500,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5401)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5401,54,1,54,2,'EmployeeName','string',300,0,0,NULL,0,NULL,300,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5402)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5402,54,2,54,3,'CompanyName','string',300,0,0,NULL,1,NULL,300,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5403)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5403,54,3,54,4,'ISIN','string',50,0,0,NULL,0,NULL,500,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5404)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5404,54,4,54,5,'NSECode','string',50,0,0,NULL,0,NULL,50,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5405)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5405,54,5,54,6,'BSECode','string',50,0,0,NULL,0,NULL,50,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5406)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5406,54,6,54,7,'ApplicableFrom','Datetime',0,0,0,NULL,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5407)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5407,54,7,54,8,'ApplicableTo','Datetime',0,0,0,NULL,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END


/* INSERT DATA INTO COM_MASSUPLOAD PROCEDURE PARAMETERDETAILS TABLE */
IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5401)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5401,54,1,54,5400,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5402)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5402,54,2,54,5401,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5403)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5403,54,3,54,5402,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5404)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5404,54,4,54,5403,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5405)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5405,54,5,54,5404,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5406)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5406,54,6,54,5405,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5407)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5407,54,7,54,5406,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5408)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5408,54,8,54,5407,NULL)
END

/* ERROR MESSAGE FOR RESTRICTED LIST MASS-UPLOAD */

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50076)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50076, 'mst_lbl_50076','Invalid value provided for Company','en-US',103004,104002,122032,'Invalid value provided for Company',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50077)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50077, 'mst_lbl_50077','Invalid value provided for EmployeeId','en-US',103004,104002,122032,'Invalid value provided for EmployeeId',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50078)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50078, 'mst_lbl_50078','ApplicableTo date should be greater than or equal to ApplicableFrom date.','en-US',103004,104002,122032,'ApplicableTo date should be greater than or equal to ApplicableFrom date.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50079)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50079, 'mst_lbl_50079','ApplicableFrom date should be current or future date.','en-US',103004,104002,122032,'ApplicableFrom date should be current or future date.',1,GETDATE())
END

