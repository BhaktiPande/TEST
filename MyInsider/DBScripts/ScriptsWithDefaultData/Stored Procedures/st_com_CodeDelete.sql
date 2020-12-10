IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CodeDelete')
DROP PROCEDURE [dbo].[st_com_CodeDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Deletes the Code

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		19-Feb-2015

Modification History:
Modified By		Modified On	Description


Usage:
DECLARE @RC int
EXEC st_com_CodeDelete 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CodeDelete]
	-- Add the parameters for the stored procedure here
	@inp_iCodeID			INT,							-- Id of the Code to be deleted
	@inp_nUserId			INT ,						-- Id Used while updating audit table befoe deleting.	
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_CODE_DELETE INT = 10012, -- Error occurred while deleting code.
			@ERR_CODE_NOTFOUND INT = 10009, -- Code does not exist.
			@ERR_DEPENDENTINFOEXISTS INT = 10011 -- Cannot delete the code, as some dependent information exists on it.
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
	
		--Check if the Code being deleted exists
		IF (NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = @inp_iCodeID))
		BEGIN
			SET @out_nReturnValue = @ERR_CODE_NOTFOUND
			RETURN @out_nReturnValue
		END
		
		DELETE FROM com_Code
		WHERE		CodeID = @inp_iCodeID

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
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_CODE_DELETE, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
	END CATCH
END

