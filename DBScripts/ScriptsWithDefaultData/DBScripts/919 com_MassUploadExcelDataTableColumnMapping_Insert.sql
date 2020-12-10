DELETE FROM com_MassUploadExcelDataTableColumnMapping
-----------------------------------------------Excel DTO Column Mapping entry in com_MassUploadExcelDataTableColumnMapping---------------------------------------
/*For Employee Insider*/
INSERT INTO com_MassUploadExcelDataTableColumnMapping (MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode) VALUES('1','1','0','1','1','UserInfoId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('2','1','1','1','2','UserName','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('3','1','2','1','3','LoginId','string','100','0','0',NULL,'1',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('4','1','3','1','4','CompanyId','INT','0','0','0','-1','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('5','1','4','1','5','FirstName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('6','1','5','1','6','MiddleName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('7','1','6','1','7','LastName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('8','1','7','1','8','AddressLine1','string','500','0','0',NULL,'1',NULL,'500','0',NULL,NULL,NULL,NULL,NULL,NULL),('9','1','8','1','9','PinCode','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('10','1','9','1','10','CountryId','INT','0','0','0','107','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('11','1','10','1','11','MobileNumber','string','10','0','0',NULL,'1','^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$','10','0',NULL,'usr_msg_11342',NULL,NULL,NULL,NULL),('12','1','11','1','12','EmailAddress','string','250','0','0',NULL,'1','^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+([A-Za-z0-9]+)*(.com|.COM|.co.in|.CO.IN|.edu|.EDU|.org|.ORG|.gov|.GOV|.net|.NET|.int|.INT|.mil|.MIL|.arpa|.ARPA|.tv|.TV|.asia|.ASIA|.aero|.AERO)$','250','0',NULL,'usr_lbl_11330',NULL,NULL,NULL,NULL),('13','1','12','1','13','PAN','string','50','0','0',NULL,'1','[A-Z]{5}[1-9]{4}[A-Z]{1}','50','0',NULL,'usr_msg_11343',NULL,NULL,NULL,NULL),('14','1','13','1','14','RoleId','INT','0','0','0','-2','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('15','1','14','1','15','DateOfJoining','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('16','1','15','1','16','DateOfBecomingInsider','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('17','1','16','1','17','Category','INT','0','0','0','112','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('18','1','17','1','18','SubCategory','INT','0','0','0','113','1',NULL,'0','0',NULL,NULL,NULL,NULL,'16',NULL),('19','1','18','1','19','Grade','INT','0','0','0','111','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('20','1','19','1','20','DesignationId','INT','0','0','0','109','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('21','1','20','1','21','SubDesignationId','INT','0','0','0','118','1',NULL,'0','0',NULL,NULL,NULL,NULL,'19',NULL),('22','1','21','1','22','Location','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('23','1','22','1','23','DepartmentId','INT','0','0','0','110','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('24','1','24','1','24','DIN','string','50','0','0',NULL,'0',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL)
/*For Non Employee Insider*/
INSERT INTO com_MassUploadExcelDataTableColumnMapping (MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode) VALUES('25','2','0','2','1','UserInfoId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('26','2','1','2','2','UserName','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('27','2','2','2','3','LoginId','string','100','0','0',NULL,'1',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('28','2','3','2','4','CompanyId','INT','0','0','0','-1','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('29','2','4','2','5','FirstName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('30','2','5','2','6','MiddleName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('31','2','6','2','7','LastName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('32','2','7','2','8','AddressLine1','string','500','0','0',NULL,'1',NULL,'500','0',NULL,NULL,NULL,NULL,NULL,NULL),('33','2','8','2','9','PinCode','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('34','2','9','2','10','CountryId','INT','0','0','0','107','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('35','2','10','2','11','MobileNumber','string','10','0','0',NULL,'1','^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$','10','0',NULL,'usr_msg_11342',NULL,NULL,NULL,NULL),('36','2','11','2','12','EmailAddress','string','250','0','0',NULL,'1','^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+([A-Za-z0-9]+)*(.com|.COM|.co.in|.CO.IN|.edu|.EDU|.org|.ORG|.gov|.GOV|.net|.NET|.int|.INT|.mil|.MIL|.arpa|.ARPA|.tv|.TV|.asia|.ASIA|.aero|.AERO)$','250','0',NULL,'usr_lbl_11330',NULL,NULL,NULL,NULL),('37','2','12','2','13','PAN','string','50','0','0',NULL,'1','[A-Z]{5}[1-9]{4}[A-Z]{1}','50','0',NULL,'usr_msg_11343',NULL,NULL,NULL,NULL),('38','2','13','2','14','RoleId','INT','0','0','0','-2','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('39','2','14','2','15','DateOfJoining','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('40','2','15','2','16','DateOfBecomingInsider','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('41','2','16','2','25','CategoryText','string','100','0','0',NULL,'0',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('42','2','17','2','26','SubCategoryText','string','100','0','0',NULL,'0',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('43','2','18','2','27','GradeText','string','100','0','0',NULL,'0',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('44','2','19','2','28','DesignationText','string','100','0','0',NULL,'0',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('45','2','20','2','29','SubDesignationText','string','100','0','0',NULL,'0',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('46','2','21','2','22','Location','string','50','0','0',NULL,'0',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('47','2','22','2','30','DepartmentText','string','100','0','0',NULL,'0',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('48','2','24','2','24','DIN','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL)
/*For Corporate Insider*/
INSERT INTO com_MassUploadExcelDataTableColumnMapping (MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode) VALUES('49','3','0','3','1','UserInfoId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('50','3','1','3','3','LoginId','string','100','0','0',NULL,'1',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('51','3','2','3','4','CompanyId','INT','0','0','0','-1','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('52','3','3','3','8','AddressLine1','string','500','0','0',NULL,'1',NULL,'500','0',NULL,NULL,NULL,NULL,NULL,NULL),('53','3','4','3','9','PinCode','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('54','3','5','3','10','CountryId','INT','0','0','0','107','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('55','3','6','3','12','EmailAddress','string','250','0','0',NULL,'1','^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+([A-Za-z0-9]+)*(.com|.COM|.co.in|.CO.IN|.edu|.EDU|.org|.ORG|.gov|.GOV|.net|.NET|.int|.INT|.mil|.MIL|.arpa|.ARPA|.tv|.TV|.asia|.ASIA|.aero|.AERO)$','250','0',NULL,'usr_lbl_11330',NULL,NULL,NULL,NULL),('56','3','7','3','13','PAN','string','50','0','0',NULL,'1','[A-Z]{5}[1-9]{4}[A-Z]{1}','50','0',NULL,'usr_msg_11343',NULL,NULL,NULL,NULL),('57','3','8','3','14','RoleId','INT','0','0','0','-2','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('58','3','9','3','15','TAN','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('59','3','10','3','16','DateOfBecomingInsider','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('60','3','11','3','32','Description','string','1024','0','0',NULL,'0',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('61','3','12','3','31','ContactPerson','string','100','0','0',NULL,'0',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('62','3','13','3','36','Website','string','500','0','0',NULL,'0','^(www|WWW)[.][A-Za-z-]{1,15}[.-/](com|COM|org|ORG|co.in|CO.IN|org|ORG|net|NET|int|INT|edu|EDU|gov|GOV|mil|MIL|arpa|ARPA|tv|TV|aero|AERO|asia|ASIA)$','100','0',NULL,'usr_msg_11340',NULL,NULL,NULL,NULL),('63','3','14','3','28','DesignationText','string','100','0','0',NULL,'0',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('64','3','15','3','33','Landline1','string','50','0','0',NULL,'0',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL),('65','3','16','3','34','LandLine2','string','50','0','0',NULL,'0',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('66','3','17','3','35','CIN','string','50','0','0',NULL,'0',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL)
/*For Employee Relatives*/
INSERT INTO com_MassUploadExcelDataTableColumnMapping (MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode) VALUES('67','4','0','4','1','UserInfoIdRelative','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('68','4','1','4','2','UserInfoId','INT','0','1','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('69','4','2','4','3','RelationTypeCodeId','INT','0','0','0','100','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('70','4','3','4','4','FirstName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('71','4','4','4','5','MiddleName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('72','4','5','4','6','LastName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('73','4','6','4','7','AddressLine1','string','500','0','0',NULL,'1',NULL,'500','0',NULL,NULL,NULL,NULL,NULL,NULL),('74','4','7','4','8','CountryId','INT','0','0','0','107','0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('75','4','8','4','9','PinCode','string','50','0','0',NULL,'0',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('76','4','9','4','10','MobileNumber','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('77','4','10','4','11','EmailAddress','string','250','0','0',NULL,'1','^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+([A-Za-z0-9]+)*(.com|.COM|.co.in|.CO.IN|.edu|.EDU|.org|.ORG|.gov|.GOV|.net|.NET|.int|.INT|.mil|.MIL|.arpa|.ARPA|.tv|.TV|.asia|.ASIA|.aero|.AERO)$','250','0',NULL,NULL,NULL,NULL,NULL,NULL),('78','4','11','4','12','PAN','string','50','0','0',NULL,'1','[A-Z]{5}[1-9]{4}[A-Z]{1}','50','0',NULL,'usr_msg_11343',NULL,NULL,NULL,NULL)
/*For Non Employee Relatives*/
INSERT INTO com_MassUploadExcelDataTableColumnMapping (MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode) VALUES('79','5','0','4','1','UserInfoIdRelative','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('80','5','1','4','2','UserInfoId','INT','0','2','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('81','5','2','4','3','RelationTypeCodeId','INT','0','0','0','100','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('82','5','3','4','4','FirstName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('83','5','4','4','5','MiddleName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('84','5','5','4','6','LastName','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('85','5','6','4','7','AddressLine1','string','500','0','0',NULL,'1',NULL,'500','0',NULL,NULL,NULL,NULL,NULL,NULL),('86','5','7','4','8','CountryId','INT','0','0','0','107','0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('87','5','8','4','9','PinCode','string','50','0','0',NULL,'0',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('88','5','9','4','10','MobileNumber','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('89','5','10','4','11','EmailAddress','string','250','0','0',NULL,'1','^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+([A-Za-z0-9]+)*(.com|.COM|.co.in|.CO.IN|.edu|.EDU|.org|.ORG|.gov|.GOV|.net|.NET|.int|.INT|.mil|.MIL|.arpa|.ARPA|.tv|.TV|.asia|.ASIA|.aero|.AERO)$','250','0',NULL,NULL,NULL,NULL,NULL,NULL),('90','5','11','4','12','PAN','string','50','0','0',NULL,'1','[A-Z]{5}[1-9]{4}[A-Z]{1}','50','0',NULL,'usr_msg_11343',NULL,NULL,NULL,NULL)
/*For Employee DEMAT details*/
INSERT INTO com_MassUploadExcelDataTableColumnMapping (MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode) VALUES('91','6','0','5','1','DEMATDetailsId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('92','6','1','5','2','UserInfoId','INT','0','1','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('93','6','2','5','3','DEMATAccountNumber','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('94','6','3','5','4','DPBankName','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('95','6','4','5','5','DPID','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('96','6','5','5','6','TMID','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('97','6','6','5','7','Description','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('98','6','7','5','8','AccountType','INT','0','0','0','121','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL)
/*For Non Employee DEMAT details*/
INSERT INTO com_MassUploadExcelDataTableColumnMapping (MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode) VALUES('99','7','0','5','1','DEMATDetailsId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('100','7','1','5','2','UserInfoId','INT','0','2','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('101','7','2','5','3','DEMATAccountNumber','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('102','7','3','5','4','DPBankName','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('103','7','4','5','5','DPID','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('104','7','5','5','6','TMID','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('105','7','6','5','7','Description','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('106','7','7','5','8','AccountType','INT','0','0','0','121','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL)
/*For Corporate DEMAT details*/
INSERT INTO com_MassUploadExcelDataTableColumnMapping (MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode) VALUES('107','8','0','5','1','DEMATDetailsId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('108','8','1','5','2','UserInfoId','INT','0','3','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('109','8','2','5','3','DEMATAccountNumber','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('110','8','3','5','4','DPBankName','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('111','8','4','5','5','DPID','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('112','8','5','5','6','TMID','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('113','8','6','5','7','Description','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('114','8','7','5','8','AccountType','INT','0','0','0','121','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL)
/*For Employee Relatives DEMAT*/
INSERT INTO com_MassUploadExcelDataTableColumnMapping (MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode) VALUES('115','9','0','5','1','DEMATDetailsId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('116','9','1','5','2','UserInfoId','INT','0','4','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('117','9','2','5','3','DEMATAccountNumber','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('118','9','3','5','4','DPBankName','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('119','9','4','5','5','DPID','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('120','9','5','5','6','TMID','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('121','9','6','5','7','Description','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('122','9','7','5','8','AccountType','INT','0','0','0','121','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL)
/*For Non Employee Relatives DEMAT*/
INSERT INTO com_MassUploadExcelDataTableColumnMapping (MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode) VALUES('123','10','0','5','1','DEMATDetailsId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('124','10','1','5','2','UserInfoId','INT','0','5','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('125','10','2','5','3','DEMATAccountNumber','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('126','10','3','5','4','DPBankName','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('127','10','4','5','5','DPID','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('128','10','5','5','6','TMID','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('129','10','6','5','7','Description','string','200','0','0',NULL,'1',NULL,'200','0',NULL,NULL,NULL,NULL,NULL,NULL),('130','10','7','5','8','AccountType','INT','0','0','0','121','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL)

/* Script sent on 13-Oct-2015 By Raghvendra */
INSERT INTO com_MassUploadExcelDataTableColumnMapping (MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode) VALUES('131','11','0','6','1','TransactionMasterId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('132','11','1','6','2','UserName','string','250','0','0',NULL,'1',NULL,'250','0',NULL,NULL,NULL,NULL,NULL,NULL),('133','11','2','6','3','PANNumber','string','100','0','0',NULL,'1','[A-Z]{5}[1-9]{4}[A-Z]{1}','10','0',NULL,NULL,NULL,NULL,NULL,NULL),('134','11','3','6','4','DateOfBecomingInsider','DATETIME','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('135','11','4','6','5','SecurityType','INT','0','0','0','139','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('136','11','5','6','6','ModeOfAcquisation','INT','0','0','0','149','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('137','11','6','6','7','DateOfIntimationToCompany','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('138','11','7','6','8','TradingForRelation','INT','0','0','0','100','0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('139','11','8','6','9','FirstNameLastName','string','500','0','0',NULL,'0',NULL,'500','0',NULL,NULL,NULL,NULL,NULL,NULL),('140','11','9','6','10','DEMATAccountNo','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL),('141','11','10','6','11','StockExchange','INT','0','0','0','116','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('142','11','11','6','12','PercentOfSecurities','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('143','11','12','6','13','LotSize','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('144','11','13','6','14','NumberOfSecurities','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL),('145','11','14','6','15','ValueOfSecurities','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL)



/* Scripts by Raghvendra on 14-Oct-2015*/

/*Adding the configuration for Dependent value validations required in case of Initial Disclosure Mass Upload*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET DependentValueColumnNumber = 4,DependentValueColumnValue = 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts'
WHERE MassUploadExcelDataTableColumnMappingId = 136

UPDATE com_MassUploadExcelDataTableColumnMapping SET DependentValueColumnNumber = 4,DependentValueColumnValue = 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts'
WHERE MassUploadExcelDataTableColumnMappingId = 138

UPDATE com_MassUploadExcelDataTableColumnMapping SET DependentValueColumnNumber = 4,DependentValueColumnValue = 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts'
WHERE MassUploadExcelDataTableColumnMappingId = 139

UPDATE com_MassUploadExcelDataTableColumnMapping SET DependentValueColumnNumber = 4,DependentValueColumnValue = 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts'
WHERE MassUploadExcelDataTableColumnMappingId = 140

UPDATE com_MassUploadExcelDataTableColumnMapping SET DependentValueColumnNumber = 4,DependentValueColumnValue = 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts'
WHERE MassUploadExcelDataTableColumnMappingId = 141

UPDATE com_MassUploadExcelDataTableColumnMapping SET DependentValueColumnNumber = 4,DependentValueColumnValue = 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts'
WHERE MassUploadExcelDataTableColumnMappingId = 142

UPDATE com_MassUploadExcelDataTableColumnMapping SET DependentValueColumnNumber = 4,DependentValueColumnValue = 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts'
WHERE MassUploadExcelDataTableColumnMappingId = 143

UPDATE com_MassUploadExcelDataTableColumnMapping SET DependentValueColumnNumber = 4,DependentValueColumnValue = 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts'
WHERE MassUploadExcelDataTableColumnMappingId = 144

UPDATE com_MassUploadExcelDataTableColumnMapping SET DependentValueColumnNumber = 4,DependentValueColumnValue = 'Shares,Warrants,Convertible Debentures,Future Contracts,Option Contracts'
WHERE MassUploadExcelDataTableColumnMappingId = 145

/*
Script from Raghvendra on 26-Oct-2015
Update query for adding the error code for invalid PAN number
*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET ValidationRegExpressionErrorCode= 'usr_msg_11343' where MassUploadExcelDataTableColumnMappingId = 133

/*Script sent by Raghvendra on 29-Oct-2015 */
/*Remove Lot Size Mandatory validation for Shares, Warrants and Convertable Debentures.*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET DependentValueColumnValue = 'Future Contracts,Option Contracts' 
WHERE MassUploadExcelDataTableColumnMappingId in (143)

/*Set default values for the integer fields used in Initial disclosure mass upload*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET DefaultValue = 0 
WHERE MassUploadExcelDataTableColumnMappingId in (145,144,143,142,141,138,136,135)
   
/*Update the PAN ValidationRegular Expression to allow 0 in the PAN number*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET ValidationRegularExpression = '[A-Z]{5}[0-9]{4}[A-Z]{1}' 
WHERE MassUploadExcelDataTableColumnMappingId in (90)

UPDATE com_MassUploadExcelDataTableColumnMapping SET ValidationRegularExpression = '^(www|WWW)[.][A-Za-z-0-9]{1,200}[.-/](com|COM|org|ORG|co.in|CO.IN|IN|in|org|ORG|net|NET|int|INT|edu|EDU|gov|GOV|mil|MIL|arpa|ARPA|tv|TV|aero|AERO|asia|ASIA)$' 
WHERE MassUploadExcelDataTableColumnMappingId in (62)

/* Update the PAN ValidationRegular Expression to allow 0 in the PAN number */
UPDATE com_MassUploadExcelDataTableColumnMapping SET ValidationRegularExpression = '[A-Z]{5}[0-9]{4}[A-Z]{1}' 
WHERE MassUploadExcelDataTableColumnMappingId in (13,37,56,78,133)

/* Sent by Raghvendra on 31-Oct-2015 */
/* Set correct regular expression for validating the email address in Mass Upload */
UPDATE com_MassUploadExcelDataTableColumnMapping 
SET ValidationRegularExpression = '^[_A-Za-z0-9-\\+]+([._A-Za-z0-9-]+)*@[A-Za-z0-9-]+([A-Za-z0-9]+)*(.com|.COM|.co.in|.CO.IN|.edu|.EDU|.org|.ORG|.gov|.GOV|.net|.NET|.int|.INT|.mil|.MIL|.arpa|.ARPA|.tv|.TV|.asia|.ASIA|.aero|.AERO|.in|.IN)$'
WHERE MassUploadExcelDataTableColumnMappingId IN (12,36,55,77,89)

/* Script from Raghvendra on 11-Dec-2015 */
--RegExp for Email Validation
UPDATE com_MassUploadExcelDataTableColumnMapping SET ValidationRegularExpression = '^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+([A-Za-z0-9]+)*[.](ac|academy|accountants|ag|agency|airforce|am|as|army|asia|at|az|bargains|be|best|bike|biz|blue|bz|build|builders|business|buzz|boutique|cab|camera|careers|cc|cd|ch|cheap|click|club|cn|clothing|cool|co.at|co.gg|co.il|co.in|co.je|co.nz|co.tm|co.tt|co.uk|co.vi|co.za|codes|coffee|company|computer|construction|contractors|com|com.ag|com.az|com.cn|com.es|com.fr|com.gr|com.hr|com.ph|com.ro|com.tw|com.vn|cooking|country|cruises|de|dental|diamonds|diet|digital|directory|dk|domains|engineering|enterprises|email|equipment|es|estate|eu|exchange|farm|fi|fishing|flights|florist|fo|fr|gallery|gent|gg|gift|graphics|gs|guitars|guru|healthcare|help|hk|holdings|holiday|hosting|house|info|international|in|it|immo|io|je|jp|kg|kitchen|kiwi|koeln|land|li|lighting|limo|link|london|management|marketing|me|menu|mobi|ms|name|navy|net|net.ag|net.cn|net.nz|net.pl|net.ru|network|ninja|nl|no|nu|ooo|org|org.uk|ph|photo|photos|photography|pink|pizza|pl|plumbing|property|pt|recipes|red|rentals|restaurant|ro|rodeo|ru|se|sh|shoes|singles|solar|support|systems|tc|tattoo|tel|technology|tips|tm|to|today|top|tt|training|tv|us|vacations|ventures|vc|villas|vg|vodka|voyage|vu|ws|watch|wiki|zone)' 
WHERE MassUploadExcelDataTableColumnMappingId in (12,36,55,77,89)

--RegExp for Website Validation
UPDATE com_MassUploadExcelDataTableColumnMapping SET ValidationRegularExpression = '^(www|WWW)[.][A-Za-z0-9-]{1,200}[.-/](ac|academy|accountants|ag|agency|airforce|am|as|army|asia|at|az|bargains|be|best|bike|biz|blue|bz|build|builders|business|buzz|boutique|cab|camera|careers|cc|cd|ch|cheap|click|club|cn|clothing|cool|co.at|co.gg|co.il|co.in|co.je|co.nz|co.tm|co.tt|co.uk|co.vi|co.za|codes|coffee|company|computer|construction|contractors|com|com.ag|com.az|com.cn|com.es|com.fr|com.gr|com.hr|com.ph|com.ro|com.tw|com.vn|cooking|country|cruises|de|dental|diamonds|diet|digital|directory|dk|domains|engineering|enterprises|email|equipment|es|estate|eu|exchange|farm|fi|fishing|flights|florist|fo|fr|gallery|gent|gg|gift|graphics|gs|guitars|guru|healthcare|help|hk|holdings|holiday|hosting|house|info|international|it|in|immo|io|je|jp|kg|kitchen|kiwi|koeln|land|li|lighting|limo|link|london|management|marketing|me|menu|mobi|ms|name|navy|net|net.ag|net.cn|net.nz|net.pl|net.ru|network|ninja|nl|no|nu|ooo|org|org.uk|ph|photo|photos|photography|pink|pizza|pl|plumbing|property|pt|recipes|red|rentals|restaurant|ro|rodeo|ru|se|sh|shoes|singles|solar|support|systems|tc|tattoo|tel|technology|tips|tm|to|today|top|tt|training|tv|us|vacations|ventures|vc|villas|vg|vodka|voyage|vu|ws|watch|wiki|zone)' 
WHERE MassUploadExcelDataTableColumnMappingId in (62)




/*Script received from KPCS while code merge on 18-Dec */
INSERT INTO com_MassUploadExcelDataTableColumnMapping
(MassUploadExcelDataTableColumnMappingId,MassUploadExcelSheetId,ExcelColumnNo,MassUploadDataTableId,MassUploadDataTablePropertyNo,
MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType,MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,
RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId,IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,
IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode,
DependentValueColumnNumber,DependentValueColumnValue,DependentValueColumnErrorCode)
Values (5000,51,0,51,1,'PANNumber','string',20,0,0,NULL,1,NULL,20,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5001,51,1,51,2,'SecurityType','string',20,0,0,NULL,1,NULL,20,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5002,51,2,51,3,'DPID','string',30,0,0,NULL,1,NULL,30,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5003,51,3,51,4,'ClientID','string',30,0,0,NULL,1,NULL,30,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5004,51,4,51,5,'DematAccount','string',50,0,0,NULL,1,NULL,50,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5005,51,5,51,6,'UserInfoId','string',50,0,0,NULL,1,NULL,50,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5006,51,6,51,7,'EmployeeName','string',200,0,0,NULL,1,NULL,200,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5007,51,7,51,8,'Shares','Decimal',0,0,0,NULL,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5008,51,8,51,9,'Equity','string',50,0,0,NULL,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5009,51,9,51,10,'Category','string',50,0,0,NULL,1,NULL,50,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)


/* Script sent by Raghvendra on 28-Dec-2015 */
INSERT INTO com_MassUploadExcelDataTableColumnMapping 
(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, 
MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,
RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,
IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode,
DependentValueColumnNumber,DependentValueColumnValue,DependentValueColumnErrorCode) 
VALUES
('146','12','0','8','1','PreclearanceRequestId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('147','12','1','8','2','UserName','string','100','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('148','12','2','8','3','RelationCodeId','INT','0','0','0','100','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('149','12','3','8','4','FirstLastName','string','55','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('150','12','4','8','5','DateApplyingForPreClearance','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('151','12','5','8','6','TransactionTypeCodeId','INT','0','0','0','143','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('152','12','6','8','7','SecurityTypeCodeId','INT','0','0','0','139','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('153','12','7','8','8','SecuritiesToBeTradedQty','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('154','12','8','8','9','SecuritiesToBeTradedValue','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('155','12','9','8','10','ProposedTradeRateRangeFrom','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('156','12','10','8','11','ProposedTradeRateRangeTo','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('157','12','11','8','12','DMATDetailsINo','string','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('158','12','12','8','13','PreclearanceStatusCodeId','INT','0','0','0','144','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('159','12','13','8','14','DateForApprovalRejection','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)


/* Script sent by Raghvendra on 29-Dec-2015 */
INSERT INTO com_MassUploadExcelDataTableColumnMapping 
(MassUploadExcelDataTableColumnMappingId, MassUploadExcelSheetId, ExcelColumnNo, MassUploadDataTableId, MassUploadDataTablePropertyNo, 
MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType, MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,
RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId, IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,
IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode,
DependentValueColumnNumber,DependentValueColumnValue,DependentValueColumnErrorCode, DefaultValue) 
VALUES
('160','13','0','9','1','TransactionMasterId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('161','13','1','9','2','PreclearanceId','INT','0','1','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('162','13','2','9','3','UserLoginName','string','100','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('163','13','3','9','4','RelationCodeId','INT','0','0','0','100','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('164','13','4','9','5','FirstLastName','string','55','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('165','13','5','9','6','DateOfAcquisition','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('166','13','6','9','7','ModeOfAcquisitionCodeId','INT','0','0','0','149','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('167','13','7','9','8','DateOfInitimationToCompany','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('168','13','8','9','9','SecuritiesHeldPriorToAcquisition','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('169','13','9','9','10','DEMATAccountNo','string','50','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('170','13','10','9','11','ExchangeCodeId','INT','0','0','0','116','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('171','13','11','9','12','TransactionTypeCodeId','INT','0','0','0','143','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('172','13','12','9','13','SecurityTypeCodeId','INT','0','0','0','139','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('173','13','13','9','14','PerOfSharesPreTransaction','decimal','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('174','13','14','9','15','PerOfSharesPostTransaction','decimal','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('175','13','15','9','16','Quantity','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('176','13','16','9','17','Value','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('177','13','17','9','18','Quantity2','decimal','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('178','13','18','9','19','Value2','decimal','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('179','13','19','9','20','LotSize','INT','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('180','13','20','9','21','ContractSpecification','string','50','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),

/* Script sent by Raghvendra on 29-Dec-2015 */
('181','14','0','10','1','TransactionMasterId','INT','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('182','14','1','10','2','UserLoginName','string','100','0','0',NULL,'1',NULL,'100','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('183','14','2','10','3','RelationCodeId','INT','0','0','0','100','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('184','14','3','10','4','FirstLastName','string','55','0','0',NULL,'1',NULL,'55','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('185','14','4','10','5','DateOfAcquisition','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('186','14','5','10','6','ModeOfAcquisitionCodeId','INT','0','0','0','149','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('187','14','6','10','7','DateOfInitimationToCompany','DATETIME','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('188','14','7','10','8','SecuritiesHeldPriorToAcquisition','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('189','14','8','10','9','DEMATAccountNo','string','50','0','0',NULL,'1',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('190','14','9','10','10','ExchangeCodeId','INT','0','0','0','116','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('191','14','10','10','11','TransactionTypeCodeId','INT','0','0','0','143','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('192','14','11','10','12','SecurityTypeCodeId','INT','0','0','0','139','1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('193','14','12','10','13','PerOfSharesPreTransaction','decimal','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('194','14','13','10','14','PerOfSharesPostTransaction','decimal','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('195','14','14','10','15','Quantity','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('196','14','15','10','16','Value','decimal','0','0','0',NULL,'1',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('197','14','16','10','17','ESOPQuantity','decimal','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('198','14','17','10','18','OtherQuantity','decimal','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('199','14','18','10','19','Quantity2','decimal','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('200','14','19','10','20','Value2','decimal','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('201','14','20','10','21','LotSize','INT','0','0','0',NULL,'0',NULL,'0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),
('202','14','21','10','22','ContractSpecification','string','50','0','0',NULL,'0',NULL,'50','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)

update com_MassUploadExcelDataTableColumnMapping SET RelatedMassUploadRelatedSheetId = 1 where MassUploadExcelDataTableColumnMappingId = 80
update com_MassUploadExcelDataTableColumnMapping SET RelatedMassUploadRelatedSheetId = 1 where MassUploadExcelDataTableColumnMappingId = 100
update com_MassUploadExcelDataTableColumnMapping SET RelatedMassUploadRelatedSheetId = 1 where MassUploadExcelDataTableColumnMappingId = 108
update com_MassUploadExcelDataTableColumnMapping SET RelatedMassUploadRelatedSheetId = 1 where MassUploadExcelDataTableColumnMappingId = 116
update com_MassUploadExcelDataTableColumnMapping SET RelatedMassUploadRelatedSheetId = 1 where MassUploadExcelDataTableColumnMappingId = 124

/*Script received from KPCS while code merge on 04-Jan-2016 START*/
--Changed the MassUploadDataTablePropertyDataType  from Decimal to string by ED
UPDATE com_MassUploadExcelDataTableColumnMapping SET MassUploadDataTablePropertyDataType = 'string' 
WHERE MassUploadExcelDataTableColumnMappingId = 5007 AND MassUploadExcelSheetId = 51 AND ExcelColumnNo = 7

--Removed columns Equity and Category by ED
DELETE FROM com_MassUploadExcelDataTableColumnMapping WHERE MassUploadExcelDataTableColumnMappingId IN(5008, 5009)

/*Script received from KPCS while code merge on 04-Jan-2016 END*/


/*Script received from KPCS while code merge on 08-Jan-2016 START*/
/*Make the Columns ClientId and Shares Required not mandatory*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN(5003, 5007)


/*Changes for making the Columns for Insider mass upload mandatory. Done for Non employee and corporate also and related sheets*/
/*Sent by Raghvendra on 14-Jan-2016 and added by Raghvendra*/
/*Make fields for EmpInsider non mandatory except for Sequenceno,UserName,LoginId,CompanyId and Role*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN(5,6,7,8,9,10,11,12,13,15,16,17,18,19,20,21,22,23,24)
/*Make fields for EmpInsider mandatory for Sequenceno,UserName,LoginId,CompanyId and Role*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 1 WHERE MassUploadExcelDataTableColumnMappingId IN(1,2,3,4,14)

/*Make fields for NonEmpInsider non mandatory except for Sequenceno,UserName,LoginId,CompanyId and Role*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN(29,30,31,32,33,34,35,36,37,39,40,41,42,43,44,45,46,47,48)
/*Make fields for NonEmpInsider mandatory for Sequenceno,UserName,LoginId,CompanyId and Role*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 1 WHERE MassUploadExcelDataTableColumnMappingId IN(25,26,27,28,38)

/*Make fields for Corporate Insider non mandatory except for Sequenceno,LoginId,CompanyId, Address and Role*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN(53,54,55,56,58,59,60,61,62,63,64,65,66)
/*Make fields for Corporate Insider mandatory for Sequenceno,LoginId,CompanyId, Address and Role*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 1 WHERE MassUploadExcelDataTableColumnMappingId IN(49,50,51,52,57)

/*Make fields for Emp Relatives non mandatory except for Sequenceno,UserId,Relation*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN(70,71,72,73,74,75,76,77,78)
/*Make fields for Emp Relatives mandatory for Sequenceno,UserId,Relation*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 1 WHERE MassUploadExcelDataTableColumnMappingId IN(67,68,69)

/*Make fields for Non Emp Relatives non mandatory except for Sequenceno,UserId, Relation and Country*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN(82,83,84,85,87,88,89,90)
/*Make fields for Non Emp Relatives mandatory for Sequenceno,UserId, Relation and Country*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 1 WHERE MassUploadExcelDataTableColumnMappingId IN(79,80,81,86)

/*Make fields for Emp Insider DEMAT non mandatory except for Sequenceno,UserInfoId,DEMATAccountNumber*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN(94,95,96,97,98)
/*Make fields for Emp Insider DEMAT mandatory for Sequenceno,UserInfoId,DEMATAccountNumber*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 1 WHERE MassUploadExcelDataTableColumnMappingId IN(91,92,93)

/*Make fields for Non Emp Insider DEMAT non mandatory except for Sequenceno,UserInfoId,DEMATAccountNumber*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN(102,103,104,105,106)
/*Make fields for Non Emp Insider DEMAT mandatory for Sequenceno,UserInfoId,DEMATAccountNumber*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 1 WHERE MassUploadExcelDataTableColumnMappingId IN(99,100,101)

/*Make fields for Corporate Insider DEMAT non mandatory except for Sequenceno,UserInfoId,DEMATAccountNumber*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN(110,111,112,113,114)
/*Make fields for Corporate Insider DEMAT mandatory for Sequenceno,UserInfoId,DEMATAccountNumber*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 1 WHERE MassUploadExcelDataTableColumnMappingId IN(107,108,109)

/*Make fields for Emp Relatives Insider DEMAT non mandatory except for Sequenceno,UserInfoId,DEMATAccountNumber*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN(118,119,120,121,122)
/*Make fields for Emp Relatives Insider DEMAT mandatory for Sequenceno,UserInfoId,DEMATAccountNumber*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 1 WHERE MassUploadExcelDataTableColumnMappingId IN(115,116,117)

/*Make fields for Non Emp Relatives Insider DEMAT non mandatory except for Sequenceno,UserInfoId,DEMATAccountNumber*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN(126,127,128,129,130)
/*Make fields for Non Emp Relatives Insider DEMAT mandatory for Sequenceno,UserInfoId,DEMATAccountNumber*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 1 WHERE MassUploadExcelDataTableColumnMappingId IN(123,124,125)


/*Changes for updating the regular expression for the Email fields used in Insider Mass Upload*/
/*Sent by Raghvendra on 15-Jan-2016 and added by Raghvendra*/
UPDATE com_MassUploadExcelDataTableColumnMapping SET ValidationRegularExpression='^(([""\/][_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-][""\/])*[""\/])|([_A-Za-z0-9-\\.\\+]+(\\.[_A-Za-z0-9-]+)*))[^\\.]@(?:([^-][A-Za-z0-9-.]+([A-Za-z0-9]+)(.ac|.academy|.accountants|.ag|.agency|.airforce|.am|.as|.army|.asia|.at|.az|.bargains|.be|.best|.bike|.biz|.blue|.bz|.build|.builders|.business|.buzz|.boutique|.cab|.camera|.careers|.cc|.cd|.ch|.cheap|.click|.club|.cn|.clothing|.cool|.co.at|.co.gg|.co.il|.co.in|.co.je|.co.nz|.co.tm|.co.tt|.co.uk|.co.vi|.co.za|.codes|.coffee|.company|.computer|.construction|.contractors|.com|.com.ag|.com.az|.com.cn|.com.es|.com.fr|.com.gr|.com.hr|.com.ph|.com.ro|.com.tw|.com.vn|.cooking|.country|.cruises|.de|.dental|.diamonds|.diet|.digital|.directory|.dk|.domains|.engineering|.enterprises|.email|.equipment|.es|.estate|.eu|.exchange|.farm|.fi|.fishing|.flights|.florist|.fo|.fr|.gallery|.gent|.gg|.gift|.graphics|.gs|.guitars|.guru|.healthcare|.help|.hk|.holdings|.holiday|.hosting|.house|.info|.international|.in|.it|.immo|.io|.je|.jp|.kg|.kitchen|.kiwi|.koeln|.land|.li|.lighting|.limo|.link|.london|.management|.marketing|.me|.menu|.mobi|.ms|.name|.navy|.net|.net.ag|.net.cn|.net.nz|.net.pl|.net.ru|.network|.ninja|.nl|.no|.nu|.ooo|.org|.org.uk|.ph|.photo|.photos|.photography|.pink|.pizza|.pl|.plumbing|.property|.pt|.recipes|.red|.rentals|.restaurant|.ro|.rodeo|.ru|.se|.sh|.shoes|.singles|.solar|.support|.systems|.tc|.tattoo|.tel|.technology|.tips|.tm|.to|.today|.top|.tt|.training|.tv|.us|.vacations|.ventures|.vc|.villas|.vg|.vodka|.voyage|.vu|.ws|.watch|.wiki|.zone))|([\[][0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}[\]])|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}))$'
WHERE MassUploadExcelDataTableColumnMappingId in (12,36,55,77,89)
/*Changes for updating the regular expression for the Website fields used in Corporate Insider Mass Upload*/
/*Sent by Raghvendra on 15-Jan-2016 and added by Raghvendra*/
Update com_MassUploadExcelDataTableColumnMapping SET ValidationRegularExpression = '^(?:(www|WWW)[.][A-Za-z0-9-]{1,200}([^-][A-Za-z0-9-.]+([A-Za-z0-9]+)(.ac|.academy|.accountants|.ag|.agency|.airforce|.am|.as|.army|.asia|.at|.az|.bargains|.be|.best|.bike|.biz|.blue|.bz|.build|.builders|.business|.buzz|.boutique|.cab|.camera|.careers|.cc|.cd|.ch|.cheap|.click|.club|.cn|.clothing|.cool|.co.at|.co.gg|.co.il|.co.in|.co.je|.co.nz|.co.tm|.co.tt|.co.uk|.co.vi|.co.za|.codes|.coffee|.company|.computer|.construction|.contractors|.com|.com.ag|.com.az|.com.cn|.com.es|.com.fr|.com.gr|.com.hr|.com.ph|.com.ro|.com.tw|.com.vn|.cooking|.country|.cruises|.de|.dental|.diamonds|.diet|.digital|.directory|.dk|.domains|.engineering|.enterprises|.email|.equipment|.es|.estate|.eu|.exchange|.farm|.fi|.fishing|.flights|.florist|.fo|.fr|.gallery|.gent|.gg|.gift|.graphics|.gs|.guitars|.guru|.healthcare|.help|.hk|.holdings|.holiday|.hosting|.house|.info|.international|.in|.it|.immo|.io|.je|.jp|.kg|.kitchen|.kiwi|.koeln|.land|.li|.lighting|.limo|.link|.london|.management|.marketing|.me|.menu|.mobi|.ms|.name|.navy|.net|.net.ag|.net.cn|.net.nz|.net.pl|.net.ru|.network|.ninja|.nl|.no|.nu|.ooo|.org|.org.uk|.ph|.photo|.photos|.photography|.pink|.pizza|.pl|.plumbing|.property|.pt|.recipes|.red|.rentals|.restaurant|.ro|.rodeo|.ru|.se|.sh|.shoes|.singles|.solar|.support|.systems|.tc|.tattoo|.tel|.technology|.tips|.tm|.to|.today|.top|.tt|.training|.tv|.us|.vacations|.ventures|.vc|.villas|.vg|.vodka|.voyage|.vu|.ws|.watch|.wiki|.zone))|([\[][0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}[\]])|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}))$'
WHERE MassUploadExcelDataTableColumnMappingId in (62)


/*Changes from ED during code integration on 4-Feb-2016*/
/* Script for NON TRADING DAY MASS UPLOAD */

INSERT INTO com_MassUploadExcelDataTableColumnMapping
(MassUploadExcelDataTableColumnMappingId,MassUploadExcelSheetId,ExcelColumnNo,MassUploadDataTableId,MassUploadDataTablePropertyNo,
MassUploadDataTablePropertyName,MassUploadDataTablePropertyDataType,MassUploadDataTablePropertyDataSize,RelatedMassUploadRelatedSheetId,
RelatedMassUploadExcelSheetColumnNo,ApplicableDataCodeGroupId,IsRequiredField,ValidationRegularExpression,MaxLength,MinLength,
IsRequiredErrorCode,ValidationRegExpressionErrorCode,MaxLengthErrorCode,MinLengthErrorCode,DependentColumnNo,DependentColumnErrorCode,
DependentValueColumnNumber,DependentValueColumnValue,DependentValueColumnErrorCode)
VALUES 
(5200,52,0,52,1,'Reason','string',200,0,0,NULL,1,NULL,200,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5201,52,1,52,2,'NonTradDay','datetime',0,0,0,NULL,1,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)


/*Start Change added by Raghvendra for making the PAN number and PercentOfShares column non mandatory in Initial disclosure mass upload*/
update com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN (133,142)
/*End Change added by Raghvendra for making the PAN number and PercentOfShares column non mandatory in Initial disclosure mass upload*/

/*Start Change added by Raghvendra for making the ProposedTradeRateRangeFrom and ProposedTradeRateRangeTo column non mandatory in Past preclearance disclosure mass upload*/
update com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0 WHERE MassUploadExcelDataTableColumnMappingId IN (155,156)
/*End Change added by Raghvendra for making the ProposedTradeRateRangeFrom and ProposedTradeRateRangeTo column non mandatory in Past preclearance disclosure mass upload*/

/*Start Change added by Raghvendra for making the  SecuritiesHeldPriorToAcquisition PerOfSharesPreTransaction PerOfSharesPostTransaction  non mandatory in Past transactions disclosure mass upload*/
update com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0,DefaultValue = 0 WHERE MassUploadExcelDataTableColumnMappingId IN (168,173,174)
/*End Change added by Raghvendra for making the  SecuritiesHeldPriorToAcquisition PerOfSharesPreTransaction PerOfSharesPostTransaction  non mandatory in Past transactions disclosure mass upload*/

/*Start Change added by Raghvendra for making the  SecuritiesHeldPriorToAcquisition PerOfSharesPreTransaction PerOfSharesPostTransaction  non mandatory in On Going transactions disclosure mass upload*/
update com_MassUploadExcelDataTableColumnMapping SET IsRequiredField = 0,DefaultValue = 0 WHERE MassUploadExcelDataTableColumnMappingId IN (188,193,194)
/*End Change added by Raghvendra for making the  SecuritiesHeldPriorToAcquisition PerOfSharesPreTransaction PerOfSharesPostTransaction  non mandatory in On Going transactions disclosure mass upload*/

/*Start Change added by Raghvendra for making the  [DPBank], [DPID], [TMID], [Description]*/
--Employee Insider DEMAT
UPDATE com_MassUploadExcelDataTableColumnMapping SET DefaultValue = '' WHERE MassUploadExcelDataTableColumnMappingId IN (94,95,96,97)
--Non Employee Insider DEMAT
UPDATE com_MassUploadExcelDataTableColumnMapping SET DefaultValue = '' WHERE MassUploadExcelDataTableColumnMappingId IN (102,103,104,105)
--Corporate Insider DEMAT
UPDATE com_MassUploadExcelDataTableColumnMapping SET DefaultValue = '' WHERE MassUploadExcelDataTableColumnMappingId IN (110,111,112,113)
/*End Change added by Raghvendra for making the  [DPBank], [DPID], [TMID], [Description]*/