IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'RLCompanyId'
          AND Object_ID = Object_ID(N'schemaName.rpt_DefaulterReport_OS'))
BEGIN
	Alter table rpt_DefaulterReport_OS
	Add RLCompanyId INT;
END

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'RLApplicableFromDate'
          AND Object_ID = Object_ID(N'schemaName.rpt_DefaulterReport_OS'))
BEGIN
	Alter table rpt_DefaulterReport_OS
	Add RLApplicableFromDate Datetime;
END

IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'RLApplicableToDate'
          AND Object_ID = Object_ID(N'schemaName.rpt_DefaulterReport_OS'))
BEGIN
	Alter table rpt_DefaulterReport_OS
	Add RLApplicableToDate Datetime;
END

------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM com_Code WHERE CodeID=169010)
BEGIN
	INSERT INTO com_Code VALUES(
	169010,	'Traded of Restricted List Company',169,'Defaulter Report Status - Traded of Restricted List Company',	1,	1,	10,	NULL,	NULL,1,	GETDATE()
	)
END

IF NOT EXISTS(SELECT * FROM com_Code WHERE CodeID=170005)
BEGIN
	INSERT INTO com_Code VALUES(
	170005,	'Restricted List',170,'Non Compliance Type - Restricted List',	1,	1,	5,	NULL,	NULL,1,	GETDATE()
	)
END