UPDATE com_MassUploadExcelDataTableColumnMapping	
SET DependentValueColumnValue='Shares,Warrants,Convertible Debentures,Other Securities,Option Contracts'	
WHERE MassUploadExcelDataTableColumnMappingId IN(136,138,139,140,141,142,144,145)	


UPDATE com_MassUploadExcelDataTableColumnMapping 
SET DependentValueColumnValue='Other Securities,Option Contracts' 
WHERE MassUploadExcelDataTableColumnMappingId in (143)



update mst_Resource set ResourceValue='Open Interest of the Other securities held at the time of becoming Promoter/member of Promoter group/ appointment of Director/KMP', 
OriginalResourceValue='Open Interest of the Other securities held at the time of becoming Promoter/member of Promoter group/ appointment of Director/KMP' 
where ResourceKey='dis_grd_17138'

 
update com_Code set CodeName='Other Securities',Description='Other Securities' where  CodeID=139004







