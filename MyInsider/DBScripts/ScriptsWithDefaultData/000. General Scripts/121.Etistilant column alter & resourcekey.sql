

ALTER TABLE usr_UserInfo
ALTER COLUMN FirstName NVARCHAR(MAX) 

ALTER TABLE usr_UserInfo
ALTER COLUMN MiddleName NVARCHAR(MAX)


ALTER TABLE usr_UserInfo
ALTER COLUMN LastName NVARCHAR(MAX)

IF NOT EXISTS(
SELECT TABLE_CATALOG 
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_NAME = 'rpt_EmployeeHoldingDetails' 
	AND COLUMN_NAME = 'PersonalAddress')
BEGIN
ALTER TABLE rpt_EmployeeHoldingDetails
Add  PersonalAddress NVARCHAR(MAX)
END

IF NOT EXISTS(
SELECT TABLE_CATALOG 
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_NAME = 'rpt_EmpDematwiseDetails' 
	AND COLUMN_NAME = 'PersonalAddress')
BEGIN
ALTER TABLE rpt_EmpDematwiseDetails
Add  PersonalAddress NVARCHAR(MAX)
END


ALTER TABLE tra_TradingTransactionUserDetails
ALTER COLUMN FirstName NVARCHAR(MAX) 

ALTER TABLE tra_TradingTransactionUserDetails
ALTER COLUMN MiddleName NVARCHAR(MAX)


ALTER TABLE tra_TradingTransactionUserDetails
ALTER COLUMN LastName NVARCHAR(MAX)

ALTER TABLE tra_TradingTransactionUserDetails
ALTER COLUMN Designation NVARCHAR(MAX)

ALTER TABLE tra_TradingTransactionUserDetails
ALTER COLUMN CompanyName nvarchar(MAX);

IF NOT EXISTS(SELECT * FROM  INFORMATION_SCHEMA.COLUMNS
          WHERE TABLE_NAME = 'usr_UserInfo'
			    AND COLUMN_NAME='PersonalAddress')
BEGIN

	ALTER TABLE usr_UserInfo ADD PersonalAddress varchar(50)  NULL
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54227)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54227,'usr_lbl_54227','Address (Personal)','en-US',103002,104002, 122004,'Address (Personal)',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54228)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54228,'usr_msg_54228','Special characters(*,(,),<,>) are not allowed.','en-US',103009,104001, 122052,'Special characters(*,(,),<,>) are not allowed.',1,GETDATE())
END




---For Massupload
update com_MassUploadExcelSheets set ColumnCount=25   where SheetName='EmpInsider'

update com_MassUploadExcelSheets set ColumnCount=25   where SheetName='NonEmpInsider'

if not exists(select * from com_MassUploadExcelDataTableColumnMapping 
where MassUploadDataTablePropertyNo=25 and	MassUploadDataTablePropertyName='PersonalAddress'
)
begin
	insert into com_MassUploadExcelDataTableColumnMapping (	MassUploadExcelDataTableColumnMappingId,	MassUploadExcelSheetId	,ExcelColumnNo	,MassUploadDataTableId	,MassUploadDataTablePropertyNo,
  MassUploadDataTablePropertyName,	MassUploadDataTablePropertyDataType,	MassUploadDataTablePropertyDataSize,
 RelatedMassUploadRelatedSheetId,	RelatedMassUploadExcelSheetColumnNo	,ApplicableDataCodeGroupId	,IsRequiredField	,
 ValidationRegularExpression,	MaxLength,	MinLength,	IsRequiredErrorCode	,ValidationRegExpressionErrorCode,	MaxLengthErrorCode,
 MinLengthErrorCode	,DependentColumnNo,	DependentColumnErrorCode,	DependentValueColumnNumber,	DependentValueColumnValue,
 DependentValueColumnErrorCode,	DefaultValue
)
select  5702 MassUploadExcelDataTableColumnMappingId,	1 MassUploadExcelSheetId	, 25 ExcelColumnNo	, 1 MassUploadDataTableId	, 25 MassUploadDataTablePropertyNo,
 'PersonalAddress' MassUploadDataTablePropertyName,'string' 	MassUploadDataTablePropertyDataType,500	MassUploadDataTablePropertyDataSize,
 0 RelatedMassUploadRelatedSheetId,	0 RelatedMassUploadExcelSheetColumnNo	, null ApplicableDataCodeGroupId	,0 IsRequiredField	,
 null ValidationRegularExpression,	500 MaxLength,	0 MinLength,	null IsRequiredErrorCode	,null  ValidationRegExpressionErrorCode,null 	MaxLengthErrorCode,
 null  MinLengthErrorCode	,null  DependentColumnNo,	null DependentColumnErrorCode,	null DependentValueColumnNumber,	null DependentValueColumnValue,
 null DependentValueColumnErrorCode,	null DefaultValue
End



if not exists(select * from com_MassUploadProcedureParameterDetails 
where MassUploadSheetId=1 and	MassUploadProcedureParameterNumber=5717
)
begin
insert into com_MassUploadProcedureParameterDetails(MassUploadProcedureParameterDetailsId,MassUploadSheetId	,MassUploadProcedureParameterNumber,	MassUploadDataTableId,	
	MassUploadExcelDataTableColumnMappingId,	MassUploadProcedureParameterValue)
	select 5717 ,1,	5717,	1	,5702,	NULL
end



if not exists(select * from com_MassUploadExcelDataTableColumnMapping 
where MassUploadExcelSheetId=2 and	MassUploadDataTablePropertyName='PersonalAddress'
)
begin
	insert into com_MassUploadExcelDataTableColumnMapping (	MassUploadExcelDataTableColumnMappingId,	MassUploadExcelSheetId	,ExcelColumnNo	,MassUploadDataTableId	,MassUploadDataTablePropertyNo,
  MassUploadDataTablePropertyName,	MassUploadDataTablePropertyDataType,	MassUploadDataTablePropertyDataSize,
 RelatedMassUploadRelatedSheetId,	RelatedMassUploadExcelSheetColumnNo	,ApplicableDataCodeGroupId	,IsRequiredField	,
 ValidationRegularExpression,	MaxLength,	MinLength,	IsRequiredErrorCode	,ValidationRegExpressionErrorCode,	MaxLengthErrorCode,
 MinLengthErrorCode	,DependentColumnNo,	DependentColumnErrorCode,	DependentValueColumnNumber,	DependentValueColumnValue,
 DependentValueColumnErrorCode,	DefaultValue
)
select  5703 MassUploadExcelDataTableColumnMappingId,	2 MassUploadExcelSheetId	, 25 ExcelColumnNo	, 2 MassUploadDataTableId	, 25 MassUploadDataTablePropertyNo,
 'PersonalAddress' MassUploadDataTablePropertyName,'string' 	MassUploadDataTablePropertyDataType,500	MassUploadDataTablePropertyDataSize,
 0 RelatedMassUploadRelatedSheetId,	0 RelatedMassUploadExcelSheetColumnNo	, null ApplicableDataCodeGroupId	,0 IsRequiredField	,
 null ValidationRegularExpression,	500 MaxLength,	0 MinLength,	null IsRequiredErrorCode	,null  ValidationRegExpressionErrorCode,null 	MaxLengthErrorCode,
 null  MinLengthErrorCode	,null  DependentColumnNo,	null DependentColumnErrorCode,	null DependentValueColumnNumber,	null DependentValueColumnValue,
 null DependentValueColumnErrorCode,	null DefaultValue
End

if not exists(select * from com_MassUploadProcedureParameterDetails 
where MassUploadSheetId=2 and	MassUploadProcedureParameterNumber=5718
)
begin
insert into com_MassUploadProcedureParameterDetails(MassUploadProcedureParameterDetailsId,MassUploadSheetId	,MassUploadProcedureParameterNumber,	MassUploadDataTableId,	
	MassUploadExcelDataTableColumnMappingId,	MassUploadProcedureParameterValue)
	select 5718 ,2,	5718,	1	,5703,	NULL
end





if not exists(select * from com_MassUploadProcedureParameterDetails 
where MassUploadSheetId=3 and	MassUploadProcedureParameterNumber=5719
)
begin
insert into com_MassUploadProcedureParameterDetails(MassUploadProcedureParameterDetailsId,MassUploadSheetId	,MassUploadProcedureParameterNumber,	MassUploadDataTableId,	
	MassUploadExcelDataTableColumnMappingId,	MassUploadProcedureParameterValue)
	select 5719 ,3,	5719,	3	,Null,	NULL
end

if not exists(select * from com_MassUploadProcedureParameterDetails 
where MassUploadSheetId=4 and	MassUploadProcedureParameterNumber=5720
)
begin
insert into com_MassUploadProcedureParameterDetails(MassUploadProcedureParameterDetailsId,MassUploadSheetId	,MassUploadProcedureParameterNumber,	MassUploadDataTableId,	
	MassUploadExcelDataTableColumnMappingId,	MassUploadProcedureParameterValue)
	select 5720 ,4,	5720,	4	,Null,	NULL
end
if not exists(select * from com_MassUploadProcedureParameterDetails 
where MassUploadSheetId=5 and	MassUploadProcedureParameterNumber=5721
)
begin
insert into com_MassUploadProcedureParameterDetails(MassUploadProcedureParameterDetailsId,MassUploadSheetId	,MassUploadProcedureParameterNumber,	MassUploadDataTableId,	
	MassUploadExcelDataTableColumnMappingId,	MassUploadProcedureParameterValue)
	select 5721 ,5,	5721,	5	,Null,	NULL
end



