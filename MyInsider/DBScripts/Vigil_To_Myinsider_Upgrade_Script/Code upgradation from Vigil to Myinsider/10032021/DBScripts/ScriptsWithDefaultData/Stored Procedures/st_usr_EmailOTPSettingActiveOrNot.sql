
/*---------------------------------------------------------
Created by:		Hemant Kawade
Created on:		23-OCT-2020
Description:	Get OTP via email setting activate or not and check user type employee, co or both	
------------------------------------------------------------*/

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_EmailOTPSettingActiveOrNot')
DROP PROCEDURE [dbo].[st_usr_EmailOTPSettingActiveOrNot]
GO

CREATE PROCEDURE [dbo].[st_usr_EmailOTPSettingActiveOrNot] 
	@inp_LoggedUserId			VARCHAR(100),	
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

		DECLARE @UsertypeCode INT
		DECLARE @IsActivatedOTPviaEmailFor INT 
		DECLARE @OTPAuthApplicableUserType INT 
		DECLARE @OTPAuthApplicableUserTypeForboth INT = 537003
		DECLARE @OTPAuthApplicableUserTypeEMP INT = 537002
		DECLARE @OTPAuthApplicableUserTypeCO INT = 537001
		DECLARE @UsertypeCodeEMP INT = 101003
		DECLARE @UsertypeCodeEMPCU INT = 101004
		DECLARE @UsertypeCodeNonEMP INT = 101006
		DECLARE @UsertypeCodeCO INT = 101002		
		
		SELECT TOP 1 @IsActivatedOTPviaEmailFor = IsActivatedOTPviaEmailFor from mst_Company

		IF(@IsActivatedOTPviaEmailFor = 536001)
		BEGIN
		
			SELECT  @UsertypeCode = UserTypeCodeId
			FROM usr_Authentication A JOIN usr_UserInfo UF ON A.UserInfoID = UF.UserInfoId , mst_Company c
			WHERE LoginID = @inp_LoggedUserId and c.IsImplementing = 1

			SELECT TOP 1 @OTPAuthApplicableUserType = OTPAuthApplicableUserType FROM mst_Company WHERE IsImplementing = 1
			
			--For ApplicableUserType employee or both 
			IF(((@UsertypeCode = @UsertypeCodeEMP OR @UsertypeCode = @UsertypeCodeEMPCU OR @UsertypeCode = @UsertypeCodeNonEMP) AND @OTPAuthApplicableUserType = @OTPAuthApplicableUserTypeEMP) OR 
				((@UsertypeCode = @UsertypeCodeEMP OR @UsertypeCode = @UsertypeCodeEMPCU OR @UsertypeCode = @UsertypeCodeNonEMP) AND @OTPAuthApplicableUserType = @OTPAuthApplicableUserTypeForboth))
			BEgin
				SELECT 1
			END
			--For ApplicableUserType CO OR both 
			ELSE IF((@UsertypeCode = @UsertypeCodeCO AND @OTPAuthApplicableUserType = @OTPAuthApplicableUserTypeCO) OR 
					(@UsertypeCode = @UsertypeCodeCO AND @OTPAuthApplicableUserType = @OTPAuthApplicableUserTypeForboth))
			BEGIN
				SELECT 1
			END
			ELSE
			BEGIN
				SELECT 0
			END
		END
		ELSE
		BEGIN
			SELECT 0
		END
		
	SET NOCOUNT OFF;
	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  'Error while returning user Login details'
	END CATCH
END
GO
