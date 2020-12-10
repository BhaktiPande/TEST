IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_PasswordExpiryReminder')
DROP PROCEDURE [dbo].[st_cmu_PasswordExpiryReminder]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
This procedure is genrate password expiry reminder
				
Created by:		Priyanka
Created on:		28-Jul-2017

Usage:
EXEC st_cmu_PasswordExpiryReminder 3
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_cmu_PasswordExpiryReminder] 
	@inp_iUserId			INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @nPasswordValidity INT
	DECLARE @nExpiryReminder INT
	DECLARE @nFinalPasswordValidity INT
		
	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT @nPasswordValidity = PassValidity  FROM usr_PasswordConfig
		IF(@nPasswordValidity<>0)
		BEGIN
			SELECT @nExpiryReminder = (PassValidity - ExpiryReminder) FROM usr_PasswordConfig
			SELECT @nPasswordValidity = PassValidity FROM usr_PasswordConfig
			SET @nFinalPasswordValidity = @nPasswordValidity-1
						
			SELECT A.UserInfoID AS UserID,
			CASE WHEN @nFinalPasswordValidity = -1 THEN DATEADD(DAY, 0, A.ModifiedOn) ELSE DATEADD(DAY, @nFinalPasswordValidity, A.ModifiedOn) END AS ValidityDate,
			DATEADD(DAY, @nExpiryReminder, A.ModifiedOn) AS ExpiryReminderDate,
			A.ModifiedOn AS PasswordChangeDate
			FROM usr_Authentication A
			WHERE A.UserInfoID = @inp_iUserId
		END
		RETURN 0
	END TRY
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  ERROR_NUMBER()
	END CATCH
END