
IF EXISTS(SELECT 1 FROM com_MassUploadExcelSheets WHERE SheetName = 'OnGoingContDisc_OtherSecurities' and MassUploadExcelSheetId = 59)
BEGIN
 update com_MassUploadExcelSheets set SheetName = 'OnGoingContDisc_OS', ColumnCount = 24 where SheetName = 'OnGoingContDisc_OtherSecurities' and MassUploadExcelSheetId = 59
END
 -- Insert into com_MassUploadExcelDataTableColumnMapping--

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5719)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
  MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
  RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
  ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
  DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
  VALUES (5719, 59, 0, 59, 1, 'TransactionMasterId', 'INT', 0, 0, 0, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, 0)
 END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5720)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5720, 59, 1, 59, 2, 'UserLoginName', 'string', 100, 0, 0, NULL, 1, NULL, 100, 0, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL)
 END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5721)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5721, 59, 2, 59, 3, 'RelationCodeId', 'INT', 0, 0, 0, 100, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL)
 END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5722)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5722, 59, 3, 59, 4, 'FirstLastName', 'string', 55, 0, 0, NULL, 1, NULL, 55, 0, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL)
 END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5723)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5723, 59, 4, 59, 5, 'DateOfAcquisition', 'DATETIME', 0, 0, 0, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5724)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5724, 59, 5, 59, 6, 'ModeOfAcquisitionCodeId', 'INT', 0, 0, 0, 149, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5725)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5725, 59, 6, 59, 7, 'DateOfInitimationToCompany', 'DATETIME', 0, 0, 0, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5726)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5726, 59, 7, 59, 8, 'SecuritiesHeldPriorToAcquisition', 'decimal', 0, 0, 0, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5727)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5727, 59, 8, 59, 9, 'DEMATAccountNo', 'string', 50, 0, 0, NULL, 1, NULL, 50, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5728)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5728, 59, 9, 59, 10, 'ExchangeCodeId', 'INT', 0, 0, 0, 116, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5729)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5729, 59, 10, 59, 11, 'TransactionTypeCodeId', 'INT', 0, 0, 0, 143, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5730)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5730, 59, 11, 59, 12, 'SecurityTypeCodeId', 'INT', 0, 0, 0, 139, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5731)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5731, 59, 12, 59, 13, 'PerOfSharesPreTransaction', 'decimal', 0, 0, 0, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5732)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5732, 59, 13, 59, 14, 'PerOfSharesPostTransaction', 'decimal', 0, 0, 0, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5733)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5733, 59, 14, 59, 15, 'Quantity', 'decimal', 0, 0, 0, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5734)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5734, 59, 15, 59, 16, 'Value', 'decimal', 0, 0, 0, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5735)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5735, 59, 16, 59, 17, 'ESOPQuantity', 'decimal', 0, 0, 0, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5736)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5736, 59, 17, 59, 18, 'OtherQuantity', 'decimal', 0, 0, 0, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5737)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5737, 59, 18, 59, 19, 'Quantity2', 'decimal', 0, 0, 0, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5738)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5738, 59, 19, 59, 20, 'Value2', 'decimal', 0, 0, 0, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5739)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5739, 59, 20, 59, 21, 'LotSize', 'INT', 0, 0, 0, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5740)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5740, 59, 21, 59, 22, 'ContractSpecification', 'string', 50, 0, 0, NULL, 0, NULL, 50, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5741)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5741, 59, 22, 59, 23, 'ISIN', 'string', 50, 0, 0, NULL, 1, NULL, 50, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId = 5742)
BEGIN
 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5742, 59, 23, 59, 24, 'CompanyName', 'string', 500, 0, 0, NULL, 0, NULL, 500, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) 
END
 
 -- Insert into com_MassUploadProcedureParameterDetails--

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5735)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5735, 59, 1, 59, NULL, 0)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5736)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5736, 59, 2, 59, 5720, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5737)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5737, 59, 3, 59, 5721, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5738)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5738, 59, 4, 59, 5722, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5739)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5739, 59, 5, 59, 5723, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5740)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5740, 59, 6, 59, 5724, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5741)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5741, 59, 7, 59, 5725, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5742)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5742, 59, 8, 59, 5726, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5743)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5743, 59, 9, 59, 5727, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5744)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5744, 59, 10, 59, 5728, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5745)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5745, 59, 11, 59, 5729, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5746)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5746, 59, 12, 59, 5730, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5747)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5747, 59, 13, 59, 5731, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5748)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5748, 59, 14, 59, 5732, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5749)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5749, 59, 15, 59, 5733, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5750)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5750, 59, 16, 59, 5734, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5751)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5751, 59, 17, 59, 5735, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5752)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5752, 59, 18, 59, 5736, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5753)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5753, 59, 19, 59, 5737, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5754)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5754, 59, 20, 59, 5738, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5755)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5755, 59, 21, 59, 5739, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5756)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5756, 59, 22, 59, 5740, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5757)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5757, 59, 23, 59, 5741, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5758)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5758, 59, 24, 59, 5742, NULL)
END

IF NOT EXISTS(SELECT 1 FROM com_MassUploadProcedureParameterDetails WHERE MassUploadProcedureParameterDetailsId = 5759)
BEGIN
 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5759, 59, 25, 59, NULL, 1) 
END