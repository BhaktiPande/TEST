
/*---------------------------------------------------------
Created by:		Hemant Kawade
Created on:		26-OCT-2020
Description:	Save OTP details.	
------------------------------------------------------------*/

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_SaveUserOTPDetails')
DROP PROCEDURE [dbo].[st_usr_SaveUserOTPDetails]
GO

CREATE PROCEDURE [dbo].[st_usr_SaveUserOTPDetails] 	
	@inp_OTPConfigurationSettingMasterID INT, 
	@inp_UserInfoId INT, 
	@inp_EmailId NVARCHAR(200), 
	@inp_OTPCode NVARCHAR(50),
	@inp_OTPExpirationTimeInSeconds INT,
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	BEGIN TRY
	SET NOCOUNT ON;

		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

	  IF EXISTS(SELECT * FROM UserLoginOTPDetails WHERE UserInfoId = @inp_UserInfoId  AND OTPConfigurationSettingMasterID = @inp_OTPConfigurationSettingMasterID)
	  BEGIN
			UPDATE UserLoginOTPDetails
			SET EmailID = @inp_EmailId,
			OTPCode=@inp_OTPCode,
			OTPSentOn=GETDATE(),
			OTPExpiredOn=DATEADD(ss,@inp_OTPExpirationTimeInSeconds,GETDATE()),
			IsValidated=0,
			UPDATED_BY = @inp_UserInfoId,
			UPDATED_ON = GETDATE()
			WHERE UserInfoId = @inp_UserInfoId 
			AND OTPConfigurationSettingMasterID = @inp_OTPConfigurationSettingMasterID

			SELECT 1
	  END
	  ELSE
	  BEGIN
			INSERT INTO UserLoginOTPDetails(OTPConfigurationSettingMasterID, UserInfoId, EmailID, OTPCode, OTPSentOn, OTPExpiredOn,
											IsValidated, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON)
			VALUES(@inp_OTPConfigurationSettingMasterID, @inp_UserInfoId, @inp_EmailId, @inp_OTPCode, GETDATE(), DATEADD(ss,@inp_OTPExpirationTimeInSeconds,GETDATE()),
					0, @inp_UserInfoId, GETDATE(), @inp_UserInfoId, GETDATE())

			SELECT 1
	  END
		
	SET NOCOUNT OFF;
	SET @out_nReturnValue = 0
	RETURN @out_nReturnValue 

	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  'Error while returning user Login details'
	END CATCH
END
GO
