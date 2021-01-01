
--Display restricted list menu on admin side
IF NOT EXISTS(select 1 from usr_RoleActivity where ActivityID = 197 and RoleID=1)
BEGIN
	insert into usr_RoleActivity values(197,1,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS(select 1 from usr_RoleActivity where ActivityID = 198 and RoleID=1)
BEGIN
	insert into usr_RoleActivity values(198,1,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS(select 1 from usr_RoleActivity where ActivityID = 199 and RoleID=1)
BEGIN
	insert into usr_RoleActivity values(199,1,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS(select 1 from usr_RoleActivity where ActivityID = 200 and RoleID=1)
BEGIN
	insert into usr_RoleActivity values(200,1,1,GETDATE(),1,GETDATE())
END

--invisible column for No. count employee
IF EXISTS(select 1 from com_GridHeaderSetting where ResourceKey='usr_grd_50012')
BEGIN
	update com_GridHeaderSetting set IsVisible=0 where ResourceKey = 'usr_grd_50012' and GridTypeCodeId = 114079
END


--Massupload RL 
UPDATE com_MassUploadExcelSheets SET ColumnCount=5 WHERE SheetName='CompanyDetails' and MassUploadExcelSheetId = 56

IF NOT EXISTS(SELECT * FROM com_MassUploadExcelDataTableColumnMapping 
		WHERE MassUploadDataTablePropertyNo=2 AND MassUploadDataTablePropertyName='ISINCode' AND MassUploadExcelDataTableColumnMappingId = 5800)
BEGIN
	INSERT INTO com_MassUploadExcelDataTableColumnMapping (	
				MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo,
				MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,	
				RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength,	
				IsRequiredErrorCode, ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode,	
				DependentValueColumnNumber,	DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue
				)
	SELECT  5800 MassUploadExcelDataTableColumnMappingId, 56 MassUploadExcelSheetId, 1 ExcelColumnNo, 56 MassUploadDataTableId, 2 MassUploadDataTablePropertyNo,
		'ISINCode' MassUploadDataTablePropertyName, 'string' MassUploadDataTablePropertyDataType, 500 MassUploadDataTablePropertyDataSize,
		0 RelatedMassUploadRelatedSheetId,	0 RelatedMassUploadExcelSheetColumnNo, null ApplicableDataCodeGroupId, 1 IsRequiredField,
		null ValidationRegularExpression, 500 MaxLength,0 MinLength, null IsRequiredErrorCode, null  ValidationRegExpressionErrorCode,null 	MaxLengthErrorCode,
		null  MinLengthErrorCode, null  DependentColumnNo,	null DependentColumnErrorCode, null DependentValueColumnNumber,	null DependentValueColumnValue,
		null DependentValueColumnErrorCode,	null DefaultValue
End

Update com_MassUploadExcelDataTableColumnMapping set ExcelColumnNo = 2, MassUploadDataTablePropertyNo=3 where MassUploadExcelDataTableColumnMappingId=5601 and MassUploadDataTablePropertyName='ApplicableFrom'
Update com_MassUploadExcelDataTableColumnMapping set ExcelColumnNo = 3, MassUploadDataTablePropertyNo=4 where MassUploadExcelDataTableColumnMappingId=5602 and MassUploadDataTablePropertyName='ApplicableTo'
Update com_MassUploadExcelDataTableColumnMapping set ExcelColumnNo = 4, MassUploadDataTablePropertyNo=5 where MassUploadExcelDataTableColumnMappingId=5603 and MassUploadDataTablePropertyName='MassCounter'


IF NOT EXISTS(SELECT * FROM com_MassUploadProcedureParameterDetails 
			WHERE MassUploadSheetId=56 and	MassUploadProcedureParameterDetailsId = 5800)
BEGIN
	INSERT INTO com_MassUploadProcedureParameterDetails(
			MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,	
			MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue)
	SELECT 5800, 56, 2, 56, 5800, NULL
END

Update com_MassUploadProcedureParameterDetails SET MassUploadProcedureParameterNumber = 3 where MassUploadProcedureParameterDetailsId=5602 and MassUploadExcelDataTableColumnMappingId=5601
Update com_MassUploadProcedureParameterDetails SET MassUploadProcedureParameterNumber = 4 where MassUploadProcedureParameterDetailsId=5603 and MassUploadExcelDataTableColumnMappingId=5602
Update com_MassUploadProcedureParameterDetails SET MassUploadProcedureParameterNumber = 5 where MassUploadProcedureParameterDetailsId=5604 and MassUploadExcelDataTableColumnMappingId=5603

