/*
	Author:	Hemant Kawade
	Create date: 22 Oct 2020
	Description: This Table is used to SAVE OTP Configuration. 
*/

IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'OTPConfigurationSettingMaster')
BEGIN

	CREATE TABLE OTPConfigurationSettingMaster
	(
		OTPConfigurationSettingMasterID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
		OTPExpirationTimeInSeconds INT NULL,
		OTPDigits INT NULL,
		AttemptAllowed INT NULL,
		IsOTPResendButtonEnable BIT DEFAULT 0,
		IsAlphaNumeric BIT ,
		IsActive BIT DEFAULT 0,
		CREATED_BY NVARCHAR(100) NOT NULL,
		CREATED_ON DATETIME NOT NULL,
		UPDATED_BY NVARCHAR(100) NOT NULL,
		UPDATED_ON DATETIME NOT NULL
	)
END
GO

BEGIN
	
	/* ****************************** OTP Configuration For Email *************************************/ 
	IF NOT EXISTS (SELECT OTPConfigurationSettingMasterID FROM OTPConfigurationSettingMaster WHERE OTPConfigurationSettingMasterID =1)
	BEGIN
		INSERT INTO OTPConfigurationSettingMaster
			(OTPExpirationTimeInSeconds,OTPDigits,AttemptAllowed,IsOTPResendButtonEnable,IsAlphaNumeric,IsActive,CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON )
		VALUES
			(120,4,5,1,1,1,'ADMIN', GETDATE(), 'ADMIN', GETDATE())	
	END

END
GO

