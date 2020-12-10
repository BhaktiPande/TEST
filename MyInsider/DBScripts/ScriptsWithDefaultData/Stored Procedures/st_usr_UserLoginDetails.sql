
/*---------------------------------------------------------
Created by:		Hemant Kawade
Created on:		19-Jun-2019
Description:	Get User login details for validate	
------------------------------------------------------------*/

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserLoginDetails')
DROP PROCEDURE [dbo].[st_usr_UserLoginDetails]
GO

CREATE PROCEDURE [dbo].[st_usr_UserLoginDetails] 
	@inp_LoggedUserId			VARCHAR(100),
	@inp_CalledFrom				VARCHAR(50),	
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
		IF(@inp_CalledFrom='Login')
		BEGIN
			SELECT SaltValue FROM usr_Authentication WHERE LoginID = @inp_LoggedUserId
		END
		ELSE
		BEGIN
			SELECT SaltValue FROM usr_Authentication WHERE UserInfoID = @inp_LoggedUserId
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
