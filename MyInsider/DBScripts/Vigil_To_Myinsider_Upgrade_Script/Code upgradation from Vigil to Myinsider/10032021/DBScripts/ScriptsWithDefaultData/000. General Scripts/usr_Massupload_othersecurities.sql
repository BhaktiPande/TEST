IF NOT EXISTS(SELECT * FROM com_MassUploadExcel WHERE MassUploadExcelId = 57)
BEGIN
	INSERT INTO com_MassUploadExcel(MassUploadExcelId,MassUploadName,HasMultipleSheets,TemplateFileName)
	VALUES(57,'Initial Disclosure Mass Upload - Other Securities',0,'InitialDisclosureMassUpload_OtherSecuritiesTemplate')
END

IF NOT EXISTS(SELECT * FROM com_MassUploadExcel WHERE MassUploadExcelId = 58)
BEGIN
	INSERT INTO com_MassUploadExcel(MassUploadExcelId,MassUploadName,HasMultipleSheets,TemplateFileName)
	VALUES(58,'On Going Continuous Disclosure Mass Upload - Other Securities',0,'OnGoingContinuousDisclosuretransactions_OtherSecuritiesTemplate')
END