-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 27-JUL-2016                                                 							=
-- Description : SCRIPTS FOR DEPARTMENT WISE RESTRICTED LIST MASS-UPLOAD								=
-- ======================================================================================================


--=================================== INSERT DATA FOR DEPARTMENT WISE RESTRICTED LIST MASS-UPLOAD SHEET 1 =============================================================--

/* INSERT INTO com_MassUploadExcel */
IF NOT EXISTS(SELECT MassUploadExcelId FROM com_MassUploadExcel WHERE MassUploadExcelId = 56)
BEGIN
	INSERT INTO com_MassUploadExcel(MassUploadExcelId, MassUploadName, HasMultipleSheets, TemplateFileName) 
	VALUES (56,'Department Wise Restricted List Mass Upload',1,'RLDepartmentWiseMassUploadTemplate')
END

IF NOT EXISTS(SELECT MassUploadDataTableId FROM com_MassUploadDataTable WHERE MassUploadDataTableId = 56)
BEGIN
	INSERT INTO com_MassUploadDataTable (MassUploadDataTableId, MassUploadDataTableName) 
	VALUES (56, 'MassDepartmentWiseRLDataTable')
END

/* Insert Data into com_MassUploadExcelSheets Table */
IF NOT EXISTS (SELECT MassUploadExcelSheetId FROM com_MassUploadExcelSheets WHERE MassUploadExcelSheetId = 56)
BEGIN
	INSERT INTO com_MassUploadExcelSheets(MassUploadExcelSheetId,MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
	VALUES 	(56,56,'CompanyDetails',1,NULL,'st_com_MassUploadCommonProcedureExecution',4)
END

/* Insert Data into com_MassUploadExcelDataTableColumnMapping Table */

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5600)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5600,56,0,56,1,'CompanyName','string',300,0,0,NULL,1,NULL,300,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5601)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5601,56,1,56,2,'ApplicableFrom','Datetime',0,0,0,NULL,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5602)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5602,56,2,56,3,'ApplicableTo','Datetime',0,0,0,NULL,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5603)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5603,56,3,56,4,'MassCounter','Int',0,0,0,NULL,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

/* INSERT DATA INTO COM_MASSUPLOAD PROCEDURE PARAMETERDETAILS TABLE */
IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5601)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5601,56,1,56,5600,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5602)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5602,56,2,56,5601,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5603)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5603,56,3,56,5602,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5604)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5604,56,4,56,5603,NULL)
END

/* ADD COLUMN IN rl_RistrictedMasterList TABLE FRO DEPARTMENT WISE RESTRICTED LIST MASS-UPLOAD */

IF NOT EXISTS(SELECT Name FROM sys.columns WHERE Name = N'MassCounter' AND Object_ID = Object_ID(N'rl_RistrictedMasterList'))
BEGIN
	ALTER TABLE rl_RistrictedMasterList
	ADD MassCounter INT
	CONSTRAINT [DEFAULT_MassCounter] DEFAULT (0) NOT NULL	
END

/* ERROR MESSAGE FOR RESTRICTED LIST MASS-UPLOAD */

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50076)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50076, 'mst_lbl_50076','Invalid value provided for Company','en-US',103004,104002,122032,'Invalid value provided for Company',1,GETDATE())
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

--=================================== INSERT DATA FOR DEPARTMENT WISE RESTRICTED LIST MASS-UPLOAD SHEET 2 ========================================================--

IF NOT EXISTS(SELECT MassUploadDataTableId FROM com_MassUploadDataTable WHERE MassUploadDataTableId = 57)
BEGIN
	INSERT INTO com_MassUploadDataTable (MassUploadDataTableId, MassUploadDataTableName) 
	VALUES (57, 'MassDepartmentWiseRLAppliDataTable')
END

/* Insert Data into com_MassUploadExcelSheets Table */
IF NOT EXISTS (SELECT MassUploadExcelSheetId FROM com_MassUploadExcelSheets WHERE MassUploadExcelSheetId = 57)
BEGIN
	INSERT INTO com_MassUploadExcelSheets(MassUploadExcelSheetId,MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
	VALUES 	(57,56,'DepartmentDetails',1,NULL,'st_com_MassUploadCommonProcedureExecution',2)
END

/* Insert Data into com_MassUploadExcelDataTableColumnMapping Table */
IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5700)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5700,57,0,57,1,'Department','string',300,0,0,NULL,1,NULL,300,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5701)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (5701,57,0,57,1,'Designation','string',300,0,0,NULL,0,NULL,300,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END

/* INSERT DATA INTO COM_MASSUPLOAD PROCEDURE PARAMETERDETAILS TABLE */

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5701)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5701,57,1,57,5700,NULL)
END

IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5702)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(5702,57,2,57,5701,NULL)
END

--/* ERROR MESSAGE FOR RESTRICTED LIST MASS-UPLOAD */

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50080)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50080, 'mst_lbl_50080','Invalid value provided for Designation.','en-US',103004,104002,122032,'Invalid value provided for Designation.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50081)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50081, 'mst_lbl_50081','nvalid value provided for Department.','en-US',103004,104002,122032,'Invalid value provided for Designation.',1,GETDATE())
END





