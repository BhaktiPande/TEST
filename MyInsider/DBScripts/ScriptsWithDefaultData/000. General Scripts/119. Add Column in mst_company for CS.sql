
IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'IsActivatedConcurrentSession' AND Object_ID = Object_ID(N'mst_Company'))
BEGIN
	Alter table mst_Company
	ADD IsActivatedConcurrentSession INT default 538002
END
GO
