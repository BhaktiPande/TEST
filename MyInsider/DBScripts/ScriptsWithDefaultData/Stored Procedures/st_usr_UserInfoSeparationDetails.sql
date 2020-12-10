IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoSeparationDetails')
DROP PROCEDURE [dbo].[st_usr_UserInfoSeparationDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the UserInfo Sepration details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		12-Oct-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	23-Nov-2015		Added StatusCodeId for select.

Usage:
EXEC st_usr_UserInfoSeparationDetails 33
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserInfoSeparationDetails]
	@inp_iUserInfoId		INT,						-- Id of the UserInfo whose details are to be fetched.
	--@inp_iUserTypeCodeID    INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_USERINFO_GETDETAILS INT
	DECLARE @ERR_USERINFO_NOTFOUND INT
	DECLARE @iUserTypeCodeID INT
	DECLARE @nUserType_CO INT = 101002,
			@nUserType_Employee INT = 101003,
			@nUserType_CorporateUser INT = 101004,
			@nUserType_NonEmployee INT = 101006,
			@nUserType_Relative INT = 101007
	DECLARE @sRoles VARCHAR(500) = ''
	
	DECLARE @nConfirm_Personal_Details_Event		INT = 153043

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
				@ERR_USERINFO_GETDETAILS = 11034

		--Check if the UserInfo whose details are being fetched exists
		IF (NOT EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId))
		BEGIN
				SET @out_nReturnValue = @ERR_USERINFO_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		SELECT UserInfoID,
				EmployeeId,
				DateOfSeparation,
				ReasonForSeparation,
				CASE WHEN NoOfDaysToBeActive IS NULL 
						THEN (SELECT CAST(CodeName AS INT) FROM com_Code  WHERE CodeID = 128005)
						ELSE NoOfDaysToBeActive 
						END AS NoOfDaysToBeActive,
				DateOfInactivation,
				StatusCodeId
		FROM usr_UserInfo 
		WHERE UserInfoId = @inp_iUserInfoId

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_USERINFO_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

