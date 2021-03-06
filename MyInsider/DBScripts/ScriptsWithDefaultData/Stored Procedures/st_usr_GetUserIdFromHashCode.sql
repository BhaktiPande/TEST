IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_GetUserIdFromHashCode')
DROP PROCEDURE [dbo].[st_usr_GetUserIdFromHashCode]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Fetch the details from ust_UserResetPasswpord for the given HashCode

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		18-Mar-2015

Modification History:
Modified By		Modified On		Description

Usage:
DECLARE @RC int
EXEC st_usr_GetUserIdFromHashCode ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_GetUserIdFromHashCode] 
	@inp_sHashCode			NVARCHAR(400),
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	
	DECLARE @nUserInfoId INT
	

	DECLARE @ERR_INVALIDLINK		INT	= 11257

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		

		select @nUserInfoId = UserInfoId from usr_UserResetPassword where HashCode = @inp_sHashCode

		IF (@nUserInfoId IS NULL OR @nUserInfoId = 0)
		BEGIN
			SET @out_nReturnValue = @ERR_INVALIDLINK
			RETURN @out_nReturnValue
		END
		
		SELECT top 1 A.LoginID AS LoginID, HashCode AS HashValue, A.UserInfoID AS UserInfoID FROM usr_UserResetPassword UP
		JOIN usr_Authentication A ON UP.UserInfoId = A.UserInfoID
		WHERE UP.HashCode = @inp_sHashCode		
		
			   
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  @ERR_INVALIDLINK
		RETURN @out_nReturnValue
	END CATCH
END
