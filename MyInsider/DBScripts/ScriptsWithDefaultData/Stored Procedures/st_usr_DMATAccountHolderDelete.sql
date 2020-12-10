IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DMATAccountHolderDelete')
DROP PROCEDURE [dbo].[st_usr_DMATAccountHolderDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Deletes the DMAT Account Holder details of a user

Returns:		0, if Success.
				
Created by:		Ashish
Created on:		04-Mar-2015

Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_usr_DMATAccountHolderDelete 1, 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_DMATAccountHolderDelete]
	-- Add the parameters for the stored procedure here
	@inp_iDMATAccountHolderId INT,				
	@inp_iUserId			  INT,						-- Id Used while updating audit table befoe deleting.	
	@out_nReturnValue		  INT = 0 OUTPUT,		
	@out_nSQLErrCode		  INT = 0 OUTPUT,			-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		  NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_DMATHOLDERINFO_DELETE INT = 11218, -- Error occurred while deleting DMAT account holder''s details.
			@ERR_DMATHOLDERINFO_NOTFOUND INT = 11220, -- DMAT account holder does not exist
			@ERR_DEPENDENTINFOEXISTS INT = 11219 -- Cannot delete this DMAT account holder''s details, as some dependent information is dependent on it.

	BEGIN TRY

		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
	
		--Check if the DMAT details being deleted exists
		IF (NOT EXISTS(SELECT DMATAccountHolderId FROM usr_DMATAccountHolder WHERE DMATAccountHolderId = @inp_iDMATAccountHolderId))
		BEGIN
			SET @out_nReturnValue = @ERR_DMATHOLDERINFO_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		DELETE FROM usr_DMATAccountHolder WHERE DMATAccountHolderId = @inp_iDMATAccountHolderId

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
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_DMATHOLDERINFO_DELETE, ERROR_NUMBER())
			
		RETURN @out_nReturnValue
	END CATCH
END

