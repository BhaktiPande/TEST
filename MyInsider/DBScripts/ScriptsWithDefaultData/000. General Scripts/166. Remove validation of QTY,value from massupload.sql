
DECLARE @EnableDisableQuantity int; 

SELECT @EnableDisableQuantity = EnableDisableQuantityValue FROM mst_Company where IsImplementing=1

IF(@EnableDisableQuantity <> 400001)
BEGIN
	update com_MassUploadExcelDataTableColumnMapping set IsRequiredField = 0 where 
		MassUploadExcelDataTableColumnMappingId in(5714,5715,5716) and MassUploadExcelSheetId=58

	update com_MassUploadExcelDataTableColumnMapping set IsRequiredField = 0 where 
		MassUploadExcelDataTableColumnMappingId in(5733,5734) and MassUploadExcelSheetId=59
END
GO