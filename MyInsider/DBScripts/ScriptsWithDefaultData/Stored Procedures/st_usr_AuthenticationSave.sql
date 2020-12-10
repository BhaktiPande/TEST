IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_AuthenticationSave')
DROP PROCEDURE [dbo].[st_usr_AuthenticationSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves Authentication details

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		06-Feb-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int, @out_nReturnValue INT, @out_nSQLErrCode INT, @out_sSQLErrMessage VARCHAR(500)

EXEC @RC = st_usr_AuthenticationSave 1, 'Login1','Password1', @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_AuthenticationSave]
	@inp_iUserInfoId		INT
	,@inp_sLoginId			VARCHAR(100)
	,@inp_sPassword			VARCHAR(200)
	,@inp_iLoggedInUserId	INT
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_USERAUTHENTICATION_SAVE INT = 11026 -- Error occurred while saving login details for user.
	DECLARE @ERR_LOGINALREADYEXISTS INT = 11027 -- LoginId exists for another user.


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

		IF NOT EXISTS (select UserInfoId FROM usr_Authentication where UserInfoID = @inp_iUserInfoId)
		BEGIN
			-- Insert new record in authentication table
			IF EXISTS (SELECT * FROM usr_Authentication WHERE LoginID = @inp_sLoginId)
			BEGIN
				SET @out_nReturnValue = @ERR_LOGINALREADYEXISTS
				RETURN @ERR_LOGINALREADYEXISTS
			END
			
			INSERT INTO usr_Authentication
			(
				UserInfoId, LoginID, Password, 
				CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
			)
			VALUES
			(
				@inp_iUserInfoId, @inp_sLoginId, @inp_sPassword, 
				@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate()
			)
		END
		ELSE
		BEGIN
			-- Update record in authentication table
			IF EXISTS(SELECT UserInfoID FROM usr_Authentication WHERE UserInfoID <> @inp_iUserInfoId AND LoginID = @inp_sLoginId)
			BEGIN
				SET @out_nReturnValue = @ERR_LOGINALREADYEXISTS
				RETURN @ERR_LOGINALREADYEXISTS
			END
			
			UPDATE usr_Authentication
			SET	LoginID = @inp_sLoginId,
				Password = @inp_sPassword,
				ModifiedBy = @inp_iLoggedInUserId,
				ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE UserInfoID = @inp_iUserInfoId
			
		ENd
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_USERAUTHENTICATION_SAVE, ERROR_NUMBER())
		--RETURN @out_nReturnValue
	END CATCH
END
GO


