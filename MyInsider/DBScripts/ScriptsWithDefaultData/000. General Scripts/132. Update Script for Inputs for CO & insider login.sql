
IF EXISTS (SELECT * FROM com_MassUploadExcel WHERE MassUploadExcelId = 54)
BEGIN
	update com_MassUploadExcel set MassUploadName='Employeewise restricted list',TemplateFileName='EmployeeWiseRestrictedlistTemplate' where MassUploadExcelId=54
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='usr_msg_55067')
BEGIN
	update mst_Resource set ResourceValue='Special characters e.g. (,-,),& are not allowed', OriginalResourceValue='Special characters e.g. (,-,),& are not allowed' where ResourceKey ='usr_msg_55067'
END

IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'EmployeeID' AND Object_ID = Object_ID(N'rpt_EmployeeHoldingDetails'))
BEGIN
	ALTER TABLE rpt_EmployeeHoldingDetails 
	ADD EmployeeID nvarchar(250) Null
END