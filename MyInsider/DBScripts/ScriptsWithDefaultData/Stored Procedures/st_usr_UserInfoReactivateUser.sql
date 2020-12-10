IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoReactivateUser')
DROP PROCEDURE [dbo].[st_usr_UserInfoReactivateUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Update the user status as Activate and set Separation related fields as null.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		09-Dec-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_usr_UserInfoReactivateUser ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserInfoReactivateUser] 
	@inp_iUserInfoId	INT,
	@inp_iLoggedInUserId	INT,						-- Id of the user updating 
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @ERR_USERDETAILS_SAVE INT = 11231 -- Error occurred while saving User separation Details
	DECLARE @ERR_USERDETAILS_NOTFOUND INT = 11025 -- User does not exist.DECLARE @nStatusCodeId_Inactive int = 102002
	DECLARE @nStatusCodeId_Inactive int = 102002
	DECLARE @nStatusCodeId_Active int = 102001
	DECLARE @ERR_DUPLICATE_PAN_NUMBER INT = 11440,
			@ERR_EMAILID_EXISTS INT = 11268,
			@ERR_MOBILENUMBER_EXISTS INT = 11269
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		
		--Check if the User whose details are being updated exists				
		IF (NOT EXISTS(SELECT UF.UserInfoId 
						FROM usr_UserInfo UF 
						WHERE UF.UserInfoId = @inp_iUserInfoId
						))	
		BEGIN		
			SET @out_nReturnValue = @ERR_USERDETAILS_NOTFOUND
			RETURN (@out_nReturnValue)
		END			
			
		IF	(EXISTS(SELECT UF.UserInfoId FROM usr_UserInfo UF 
					 WHERE PAN IN(SELECT PAN FROM usr_UserInfo WHERE UserInfoId=@inp_iUserInfoId)
					 AND UF.DateOfSeparation IS NULL
					 ))			
		BEGIN
			SET @out_nReturnValue = @ERR_DUPLICATE_PAN_NUMBER
			RETURN (@out_nReturnValue)
		END	
		
		ELSE IF(EXISTS(SELECT UF.UserInfoId from usr_UserInfo UF 
					   WHERE EmailId IN(SELECT EmailId FROM usr_UserInfo WHERE UserInfoId=@inp_iUserInfoId)
					   AND UF.DateOfSeparation IS NULL
					   ))			
		BEGIN
			SET @out_nReturnValue = @ERR_EMAILID_EXISTS
			RETURN (@out_nReturnValue)
		END	
		
		ELSE IF(EXISTS(SELECT UF.UserInfoId from usr_UserInfo UF 
					   WHERE MobileNumber IN(SELECT MobileNumber FROM usr_UserInfo WHERE UserInfoId=@inp_iUserInfoId)
					   AND UF.DateOfSeparation IS NULL
					   ))			
		BEGIN
		
			SET @out_nReturnValue = @ERR_MOBILENUMBER_EXISTS
			RETURN (@out_nReturnValue)
		END
		
		UPDATE usr_UserInfo
			SET DateOfSeparation = NULL,
				DateOfInactivation = NULL,
				ReasonForSeparation = NULL,
				NoOfDaysToBeActive = NULL,
				StatusCodeId = @nStatusCodeId_Active,
				ModifiedBy = @inp_iLoggedInUserId,
				ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE UserInfoId = @inp_iUserInfoId AND StatusCodeId = @nStatusCodeId_Inactive
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_USERDETAILS_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH

END