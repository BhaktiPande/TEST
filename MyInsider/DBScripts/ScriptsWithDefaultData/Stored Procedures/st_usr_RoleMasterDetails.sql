IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_RoleMasterDetails')
DROP PROCEDURE [dbo].[st_usr_RoleMasterDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the RoleMaster details

Returns:		0, if Success.
				
Created by:		gaurishankar
Created on:		16-Feb-2015

Modification History:
Modified By		Modified On	Description

Usage:
EXEC st_usr_RoleMasterDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_RoleMasterDetails]
	@inp_iRoleId INT,							-- Id of the RoleMaster whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_ROLEMASTER_GETDETAILS INT
	DECLARE @ERR_ROLEMASTER_NOTFOUND INT
	DECLARE @IsActivityAssigned INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_ROLEMASTER_NOTFOUND = 12002,
				@ERR_ROLEMASTER_GETDETAILS = 12001

		--Check if the RoleMaster whose details are being fetched exists
		IF (NOT EXISTS(SELECT RoleId FROM usr_RoleMaster WHERE RoleId = @inp_iRoleId))
		BEGIN
			SET @out_nReturnValue = @ERR_ROLEMASTER_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		SELECT @IsActivityAssigned = count(ActivityId) FROM usr_RoleActivity WHERE RoleID = @inp_iRoleId
		
		--Fetch the RoleMaster details
		Select RoleId, RoleName, Description, StatusCodeId, LandingPageURL, UserTypeCodeId, IsDefault, @IsActivityAssigned as IsActivityAssigned
			From usr_RoleMaster
			Where RoleId = @inp_iRoleId
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_ROLEMASTER_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

