/* Script By Tushar. Dated- 2 August 2017*/
/* Script for adding country code for Mobile Number for Employee and Non Employee Registration */
UPDATE com_MassUploadExcelDataTableColumnMapping SET ValidationRegularExpression='^(?:\d{1,15}|\+91\d{10})$',MaxLength=15,ValidationRegExpressionErrorCode = 'usr_msg_11342' WHERE MassUploadExcelDataTableColumnMappingId IN(11,35,76,88)