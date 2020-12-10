IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DocumentDetailsDelete')
DROP PROCEDURE [dbo].[st_usr_DocumentDetailsDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Deletes the Document details of a user

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		16-Feb-2015

Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_usr_DocumentDetailsDelete 1, 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_DocumentDetailsDelete]
	-- Add the parameters for the stored procedure here
	@inp_iDocumentDetailsID	INT,						-- Id of the UserInfo to be deleted
	@inp_iUserId			INt ,						-- Id Used while updating audit table befoe deleting.	
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_DocumentINFO_DELETE INT = 11062, -- Error occurred while deleting Document details.
			@ERR_DocumentINFO_NOTFOUND INT = 11063, -- Document info not found
			@ERR_DEPENDENTINFOEXISTS INT = 11064 -- Cannot delete this Document details, as some dependent information is dependent on this it.

	BEGIN TRY

		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
	
		--Check if the Document details being deleted exists
		IF (NOT EXISTS(SELECT UserInfoId FROM usr_DocumentDetails WHERE DocumentDetailsID = @inp_iDocumentDetailsID))
		BEGIN
			SET @out_nReturnValue = @ERR_DocumentINFO_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		DELETE FROM usr_DocumentDetails WHERE DocumentDetailsID = @inp_iDocumentDetailsID

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
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_DocumentINFO_DELETE, ERROR_NUMBER())
			
		RETURN @out_nReturnValue
	END CATCH
END

