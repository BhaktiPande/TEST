IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoSeparationSave')
DROP PROCEDURE [dbo].[st_usr_UserInfoSeparationSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Save the Records for User Separation.

Returns:		0, if Success.
				
Created by:		Ashish
Created on:		09-Mar-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	12-Oct-2015		Change for single transaction save and added fields
Gaurishankar	23-Nov-2015		Upadate user status as Inactive if inactivation date is todays.
Raghvendra	07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_usr_SaveUserSeparation ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserInfoSeparationSave] 
	@inp_tblUserSeparationType UserSeparationType READONLY,
	@inp_iLoggedInUserId	INT,						-- Id of the user updating 
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @ERR_USERDETAILS_SAVE INT = 11231 -- Error occurred while saving User separation Details
	DECLARE @ERR_USERDETAILS_NOTFOUND INT = 11025 -- User does not exist.
	DECLARE @nUserInfoId INT
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
				
		SELECT TOP 10 @nUserInfoId = UserInfoId
		FROM @inp_tblUserSeparationType
		
		--Check if the RoleMaster whose details are being updated exists				
		IF (EXISTS(SELECT tmpUser.UserInfoId 
						FROM @inp_tblUserSeparationType tmpUser LEFT JOIN usr_UserInfo UF ON tmpUser.UserInfoId = UF.UserInfoId
						WHERE UF.UserInfoId IS NULL
						))	
		BEGIN		
			SET @out_nReturnValue = @ERR_USERDETAILS_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		--UPDATE UST
		--SET UST.DateOfInactivation = DATEADD(day,UST.NoOfDaysToBeActive,UST.DateOfSeparation)
		--FROM @inp_tblUserSeparationType UST
		
		UPDATE usr_UserInfo
		SET DateOfSeparation = UST.DateOfSeparation,
			ReasonForSeparation = UST.ReasonForSeparation,
			NoOfDaysToBeActive = UST.NoOfDaysToBeActive,
			DateOfInactivation = DATEADD(day,UST.NoOfDaysToBeActive,UST.DateOfSeparation),
			ModifiedBy = @inp_iLoggedInUserId,
			ModifiedOn = dbo.uf_com_GetServerDate()
		FROM @inp_tblUserSeparationType UST
		WHERE usr_UserInfo.UserInfoId = UST.UserInfoId	
		
		UPDATE usr_UserInfo
		SET StatusCodeId = 102002,
			ModifiedBy = @inp_iLoggedInUserId,
			ModifiedOn = dbo.uf_com_GetServerDate()
		FROM @inp_tblUserSeparationType UST
		WHERE usr_UserInfo.UserInfoId = UST.UserInfoId	
			AND dbo.uf_com_GetServerDate() >= (DATEADD(day,UST.NoOfDaysToBeActive,UST.DateOfSeparation))
		

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