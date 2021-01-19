-- Insert into com_MassUploadExcelSheets --

INSERT INTO com_MassUploadExcelSheets(MassUploadExcelSheetId, MassUploadExcelId, SheetName, IsPrimarySheet, ParentSheetName, ProcedureUsed, ColumnCount)
							   VALUES(58, 57, 'InitialDisclosure_OS', 1, NULL, 'st_com_MassUploadCommonProcedureExecution', 17)

INSERT INTO com_MassUploadExcelSheets(MassUploadExcelSheetId, MassUploadExcelId, SheetName, IsPrimarySheet, ParentSheetName, ProcedureUsed, ColumnCount)
							   VALUES(59, 58, 'OnGoingContDisc_OtherSecurities', 1, NULL, 'st_com_MassUploadCommonProcedureExecution', 22)
							   

-- Insert into com_MassUploadDataTable --
							   
INSERT INTO com_MassUploadDataTable(MassUploadDataTableId, MassUploadDataTableName) VALUES(58, 'MassInitialDisclosure_OtherSecuritiesDataTable')

INSERT INTO com_MassUploadDataTable(MassUploadDataTableId, MassUploadDataTableName) VALUES(59, 'MassTransactionImport_OtherSecuritiesDataTable')


 -- Insert into com_MassUploadExcelDataTableColumnMapping--

INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5702, 58, 0, 58, 1, 'TransactionMasterId', 'INT', 0, 0, 0, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL)

 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5703, 58, 1, 58, 2, 'UserName', 'string', 250, 0, 0, NULL, 1, NULL, 250, 0, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL)

  INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5704, 58, 2, 58, 3, 'PANNumber', 'string', 100, 0, 0, NULL, 0, '[A-Z]{5}[0-9]{4}[A-Z]{1}', 10, 0, NULL, 'usr_msg_11343', NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL)

 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5705, 58, 3, 58, 4, 'DateOfBecomingInsider', 'DATETIME', 0, 0, 0, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL)

  INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5706, 58, 4, 58, 5, 'SecurityType', 'INT', 0, 0, 0, 139, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, 0)

   INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5707, 58, 5, 58, 6, 'ModeOfAcquisation', 'INT', 0, 0, 0, 149, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL,4, 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts', NULL, 0)

    INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5708, 58, 6, 58, 7, 'DateOfIntimationToCompany', 'DATETIME', 0, 0, 0, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL)

     INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5709, 58, 7, 58, 8, 'TradingForRelation', 'INT', 0, 0, 0, 100, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 4, 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts', NULL, 0)

      INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5710, 58, 8, 58, 9, 'FirstNameLastName', 'string', 500, 0, 0, NULL, 0, NULL, 500, 0, NULL, NULL, NULL, NULL, NULL, NULL, 4, 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts', NULL, NULL)

      INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5711, 58, 9, 58, 10, 'DEMATAccountNo', 'string', 50, 0, 0, NULL, 1, NULL, 50, 0, NULL, NULL, NULL, NULL, NULL, NULL, 4, 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts', NULL, NULL)

       INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5712, 58, 10, 58, 11, 'StockExchange', 'INT', 0, 0, 0, 116, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 4, 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts', NULL, 0)

        INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5713, 58, 11, 58, 12, 'PercentOfSecurities', 'decimal', 0, 0, 0, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 4, 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts', NULL, 0)


         INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5714, 58, 12, 58, 13, 'LotSize', 'INT', 0, 0, 0, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 4, 'Future Contracts,Option Contracts', NULL, 0)


         INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5715, 58, 13, 58, 14, 'NumberOfSecurities', 'decimal', 0, 0, 0, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 4, 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts', NULL, 0)


 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5716, 58, 14, 58, 15, 'ValueOfSecurities', 'decimal', 0, 0, 0, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 4, 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts', NULL, 0)


 INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5717, 58, 15, 58, 16, 'ISIN', 'string', 50, 0, 0, NULL, 1, NULL, 50, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)


  INSERT INTO com_MassUploadExcelDataTableColumnMapping(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId,
 MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName, MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize, RelatedMassUploadRelatedSheetId,
 RelatedMassUploadExcelSheetColumnNo, ApplicableDataCodeGroupId, IsRequiredField, ValidationRegularExpression, MaxLength, MinLength, IsRequiredErrorCode,
 ValidationRegExpressionErrorCode, MaxLengthErrorCode, MinLengthErrorCode, DependentColumnNo, DependentColumnErrorCode, DependentValueColumnNumber,
 DependentValueColumnValue, DependentValueColumnErrorCode, DefaultValue) 
 VALUES (5718, 58, 16, 58, 17, 'CompanyName', 'string', 500, 0, 0, NULL, 0, NULL, 500, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)

 -- Insert into com_MassUploadProcedureParameterDetails--

 INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5718, 58, 1, 58, 5703, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5719, 58, 2, 58, 5704, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5720, 58, 3, 58, 5709, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5721, 58, 4, 58, 5710, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5722, 58, 5, 58, 5706, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5723, 58, 6, 58, 5711, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5724, 58, 7, 58, 5713, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5725, 58, 8, 58, 5708, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5726, 58, 9, 58, 5707, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5727, 58, 10, 58, 5712, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5728, 58, 11, 58, 5715, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5729, 58, 12, 58, 5716, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5730, 58, 13, 58, 5714, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5731, 58, 14, 58, 5705, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5732, 58, 15, 58, 5717, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5733, 58, 16, 58, 5718, NULL)

INSERT INTO com_MassUploadProcedureParameterDetails (MassUploadProcedureParameterDetailsId, MassUploadSheetId, MassUploadProcedureParameterNumber, MassUploadDataTableId,
    MassUploadExcelDataTableColumnMappingId, MassUploadProcedureParameterValue) VALUES (5734, 58, 18, 58, NULL, 1)