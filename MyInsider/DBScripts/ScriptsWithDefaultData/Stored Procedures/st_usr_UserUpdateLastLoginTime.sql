IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserUpdateLastLoginTime')
DROP PROCEDURE [dbo].[st_usr_UserUpdateLastLoginTime]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Updates last login time for the user.

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		03-July-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC  'st_usr_UserUpdateLastLoginTime 1'
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_UserUpdateLastLoginTime]
	@inp_sLoginId			VARCHAR(100),						-- Id of the UserInfo whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_UPDATELASTLOGIN INT
	DECLARE @ERR_USERINFO_NOTFOUND INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Initialize variables
		SELECT	@ERR_USERINFO_NOTFOUND = 11025, -- User does not exist.
				@ERR_UPDATELASTLOGIN = 0

		--Check if the UserInfo whose details are being fetched exists
		IF (NOT EXISTS(SELECT UserInfoID FROM usr_Authentication WHERE LoginID = @inp_sLoginId))
		BEGIN
				SET @out_nReturnValue = @ERR_USERINFO_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		UPDATE usr_Authentication SET LastLoginTime = dbo.uf_com_GetServerDate() WHERE LoginID = @inp_sLoginId

		SET @out_nReturnValue = 0
		SELECT @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_UPDATELASTLOGIN, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

