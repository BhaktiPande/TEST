

IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'IsActivatedOTPviaEmailFor' AND Object_ID = Object_ID(N'mst_Company'))
BEGIN
	Alter table mst_Company
	ADD IsActivatedOTPviaEmailFor INT
END
GO
IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'OTPAuthApplicableUserType' AND Object_ID = Object_ID(N'mst_Company'))
BEGIN
	Alter table mst_Company
	ADD OTPAuthApplicableUserType INT
END
GO 
