
/*---------------------------------------------------------
Created by:		Hemant Kawade
Created on:		27-OCT-2020
Description:	Validate OTP details by user info id.	
------------------------------------------------------------*/

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_ValidateOTPDetailsByUserId')
DROP PROCEDURE [dbo].[st_usr_ValidateOTPDetailsByUserId]
GO

CREATE PROCEDURE [dbo].[st_usr_ValidateOTPDetailsByUserId] 	
	@inp_OTPConfigurationSettingMasterID INT, 
	@inp_UserInfoId INT,  
	@inp_OTPCode NVARCHAR(50),
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

	DECLARE @CorrectOTPCode NVARCHAR(40);
	DECLARE @OTPExpiredOn DATETIME;
	DECLARE @IsAlreadyValidation BIT;

	SELECT @CorrectOTPCode= OTPCode  COLLATE Latin1_General_CS_AS, @OTPExpiredOn=OTPExpiredOn, @IsAlreadyValidation=ISNULL(IsValidated,0)
	FROM UserLoginOTPDetails  
	WHERE UserInfoId = @inp_UserInfoId 
	AND OTPConfigurationSettingMasterID = @inp_OTPConfigurationSettingMasterID 
	 
	--select @OTPExpiredOn,GETDATE()
	---Status 0 indicates OTP Already Validated.
	IF @IsAlreadyValidation=1
	BEGIN
		SELECT 0 AS ValidationStatus
	END
	---Status 1 indicates Validated Successfully.
	ELSE IF  ((@inp_OTPCode) COLLATE Latin1_General_CS_AS = (@CorrectOTPCode) COLLATE Latin1_General_CS_AS ) AND CONVERT(DATETIME,@OTPExpiredOn) > CONVERT(DATETIME,GETDATE())
	BEGIN
		SELECT 1 AS ValidationStatus;
		UPDATE UserLoginOTPDetails
		SET IsValidated=1
		WHERE UserInfoId = @inp_UserInfoId  
		AND OTPConfigurationSettingMasterID = @inp_OTPConfigurationSettingMasterID
	END
	---Status 2 indicates OTP is Correct but time expired.
	ELSE IF (@inp_OTPCode) COLLATE Latin1_General_CS_AS = (@CorrectOTPCode) COLLATE Latin1_General_CS_AS AND CONVERT(DATETIME,@OTPExpiredOn) < CONVERT(DATETIME,GETDATE())
	BEGIN
		SELECT 2 AS ValidationStatus
	END
	---Status 3 indicates OTP is InCorrect.
	ELSE IF (@inp_OTPCode) COLLATE Latin1_General_CS_AS <> (@CorrectOTPCode) COLLATE Latin1_General_CS_AS 
	BEGIN
		SELECT 3 AS ValidationStatus
	END
	ELSE
	BEGIN
		SELECT -1 AS ValidationStatus
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
