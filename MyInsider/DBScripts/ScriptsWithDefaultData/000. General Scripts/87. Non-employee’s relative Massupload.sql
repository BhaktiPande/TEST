-- ======================================================================================================
-- Author      : Priyanka Bhangale
-- CREATED DATE: 03-July-2019
-- Description : Script for unable to upload non-employee’s relative details
-- ======================================================================================================

DELETE FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5710
DELETE FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5711
DELETE FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5712
DELETE FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5713
DELETE FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5714
DELETE FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5715
DELETE FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5716

IF NOT EXISTS(SELECT * FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5710)
	INSERT INTO com_MassUploadProcedureParameterDetails VALUES(5710,5,48,4,NULL,null)

IF NOT EXISTS(SELECT * FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5711)
	INSERT INTO com_MassUploadProcedureParameterDetails VALUES(5711,5,49,4,NULL,null)

IF NOT EXISTS(SELECT * FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5712)
	INSERT INTO com_MassUploadProcedureParameterDetails VALUES(5712,5,50,4,NULL,null)

IF NOT EXISTS(SELECT * FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5713)
	INSERT INTO com_MassUploadProcedureParameterDetails VALUES(5713,5,51,4,NULL,null)

IF NOT EXISTS(SELECT * FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5714)
	INSERT INTO com_MassUploadProcedureParameterDetails VALUES(5714,5,52,4,NULL,null)

IF NOT EXISTS(SELECT * FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5715)
	INSERT INTO com_MassUploadProcedureParameterDetails VALUES(5715,5,53,4,NULL,null)

IF NOT EXISTS(SELECT * FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5716)
	INSERT INTO com_MassUploadProcedureParameterDetails VALUES(5716,5,54,4,NULL,null)
