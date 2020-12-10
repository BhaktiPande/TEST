IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_RoleMasterDelete')
DROP PROCEDURE [dbo].[st_usr_RoleMasterDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Deletes the RoleMaster

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		16-Feb-2015

Modification History:
Modified By		Modified On	Description
Arundhati		04-Mar-2015	Error code corrected, Added check for default
Arundhati		27-Mar-2015	Error code added
Usage:
DECLARE @RC int
EXEC st_usr_RoleMasterDelete 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_RoleMasterDelete]
	-- Add the parameters for the stored procedure here
	@inp_iRoleId INT,							-- Id of the RoleMaster to be deleted
	@inp_nUserInfoId			INt ,						-- Id Used while updating audit table befoe deleting.	
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_ROLEMASTER_DELETE INT,
			@ERR_ROLEMASTER_NOTFOUND INT,
			@ERR_CANNOTDELETESINCEDEFAULT INT,
			@ERR_DEPENDENTINFOEXISTS INT

	BEGIN TRY

		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_ROLEMASTER_NOTFOUND = 12002,
				@ERR_ROLEMASTER_DELETE = 12009,
				@ERR_CANNOTDELETESINCEDEFAULT = 12027,
				@ERR_DEPENDENTINFOEXISTS = 12048
				
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		--Check if the RoleMaster being deleted exists
		IF (NOT EXISTS(SELECT RoleId FROM usr_RoleMaster WHERE RoleId = @inp_iRoleId))
		BEGIN
			SET @out_nReturnValue = @ERR_ROLEMASTER_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		IF EXISTS(SELECT RoleId FROM usr_RoleMaster WHERE RoleId = @inp_iRoleId AND IsDefault = 1)
		BEGIN
			SET @out_nReturnValue = @ERR_CANNOTDELETESINCEDEFAULT
			RETURN (@out_nReturnValue)		
		END
		
		DELETE FROM usr_RoleMaster
		WHERE RoleId = @inp_iRoleId


		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		IF ERROR_NUMBER() = 547 -- Dependent info exists
			SET @out_nReturnValue = @ERR_DEPENDENTINFOEXISTS
		ELSE
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_ROLEMASTER_DELETE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END

