/* Script By Tushar. Dated- 2 August 2017*/
/* Script for adding country code for Mobile Number for Employee and Non Employee Registration */
/* Updated by Novitkumar Magare. Dated- 11 July 2018*/
/* Updated country code for Mobile Number for Employee and Non Employee Registration in massupload functionality*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET ValidationRegularExpression='^(?:\d{1,15}|(\+91\d{10}|\+[1-8]\d{1,13}|\+(9[987654320])\d{1,12}))$' WHERE MassUploadExcelDataTableColumnMappingId IN(11,35,76,88)