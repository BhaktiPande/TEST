IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DMATDetailsDelete')
DROP PROCEDURE [dbo].[st_usr_DMATDetailsDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Deletes the DMAT details of a user

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		16-Feb-2015

Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_usr_DMATDetailsDelete 1, 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_DMATDetailsDelete]
	-- Add the parameters for the stored procedure here
	@inp_iDMATDetailsID		INT,						-- Id of the UserInfo to be deleted
	@inp_iUserId			INT ,						-- Id Used while updating audit table befoe deleting.	
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_DMATINFO_DELETE INT = 11059, -- Error occurred while deleting DMAT details.
			@ERR_DMATINFO_NOTFOUND INT = 11060, -- DMAT info not found
			@ERR_DEPENDENTINFOEXISTS INT = 11061, -- Cannot delete this DMAT details, as some dependent information is dependent on this it.
			@Stored_UserInfoId INT = 0 -- Get UserinfoId for there Demate Id.

	BEGIN TRY

	  SELECT @Stored_UserInfoId = UserInfoId FROM usr_DMATDetails WHERE DMATDetailsID = @inp_iDMATDetailsID

		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
	
		--Check if the DMAT details being deleted exists
		IF (NOT EXISTS(SELECT UserInfoId FROM usr_DMATDetails WHERE DMATDetailsID = @inp_iDMATDetailsID))
		BEGIN
			SET @out_nReturnValue = @ERR_DMATINFO_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		DELETE FROM usr_DMATDetails WHERE DMATDetailsID = @inp_iDMATDetailsID and UserInfoID=@inp_iUserId

		IF (NOT EXISTS(SELECT UserInfoId FROM usr_DMATDetails WHERE UserInfoId = @Stored_UserInfoId))
		BEGIN
			UPDATE usr_UserInfo SET DoYouHaveDMATEAccountFlag = 0 WHERE UserInfoId = @Stored_UserInfoId;
		END

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
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_DMATINFO_DELETE, ERROR_NUMBER())
			
		RETURN @out_nReturnValue
	END CATCH
END

