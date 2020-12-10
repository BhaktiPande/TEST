-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 21-DEC-2016                                                 							=
-- Description : SCRIPTS FOR EMPLOYEE PERIOD END MASS UPLOAD LIST MASS-UPLOAD							=
-- ======================================================================================================


/* Insert Data into com_MassUploadExcelDataTableColumnMapping Table */

IF NOT EXISTS (SELECT MassUploadExcelDataTableColumnMappingId FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 206)
BEGIN 
	INSERT INTO com_MassUploadExcelDataTableColumnMapping 
	VALUES (206,15,3,11,4,'EmployeeName','string',300,0,0,NULL,0,NULL,300,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
END


/* INSERT DATA INTO COM_MASSUPLOAD PROCEDURE PARAMETERDETAILS TABLE */
IF NOT EXISTS (SELECT MassUploadProcedureParameterDetailsId FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 370)
BEGIN 
	INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId,MassUploadProcedureParameterNumber,MassUploadDataTableId,
			MassUploadExcelDataTableColumnMappingId,MassUploadProcedureParameterValue)
	VALUES 
		(370,15,4,11,206,NULL)
END