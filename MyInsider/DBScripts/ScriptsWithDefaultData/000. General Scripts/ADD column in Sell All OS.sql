
IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'SecurityTypeCodeId'
          AND Object_ID = Object_ID(N'tra_SellAllValues_OS'))
BEGIN
	ALTER TABLE tra_SellAllValues_OS
	ADD SecurityTypeCodeId int null;
END