ALTER TABLE rnt_MassUploadHistory
ALTER COLUMN EmployeeName nvarchar(300);

ALTER TABLE rnt_MassUploadHistory
ALTER COLUMN Designation nvarchar(300);

ALTER TABLE rnt_MassUploadHistory
ALTER COLUMN CompanyName nvarchar(300);

----------------------------------------------------
ALTER TABLE rnt_MassUploadDetails
ALTER COLUMN UserName nvarchar(300);

ALTER TABLE tra_TradingTransactionUserDetails
ALTER COLUMN CompanyName nvarchar(1000);

ALTER TABLE tra_ContinuousDisc
ALTER COLUMN DesignationText nvarchar(1000);

ALTER TABLE tra_ContinuousDisc
ALTER COLUMN InsiderName nvarchar(Max);

