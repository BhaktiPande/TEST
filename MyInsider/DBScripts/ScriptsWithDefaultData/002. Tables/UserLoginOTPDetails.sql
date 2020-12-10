/*
	Author:	Hemant Kawade
	Create date: 22 Oct 2020
	Description: This Table is used to Save Generated OTP Details By UserInfoID. 
	
*/

IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'UserLoginOTPDetails')
BEGIN

	CREATE TABLE UserLoginOTPDetails
	(
		OTPDetailsID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
		OTPConfigurationSettingMasterID INT,
		UserInfoId INT NULL,
		EmailID NVARCHAR(100) NULL,
		OTPCode NVARCHAR(20),
		OTPSentOn DATETIME NULL,
		OTPExpiredOn DATETIME NULL,
		IsValidated BIT DEFAULT 0,
		CREATED_BY NVARCHAR(100) NOT NULL,
		CREATED_ON DATETIME NOT NULL,
		UPDATED_BY NVARCHAR(100) NOT NULL,
		UPDATED_ON DATETIME NOT NULL,
		FOREIGN KEY (OTPConfigurationSettingMasterID) REFERENCES OTPConfigurationSettingMaster(OTPConfigurationSettingMasterID)
	)
END
GO
