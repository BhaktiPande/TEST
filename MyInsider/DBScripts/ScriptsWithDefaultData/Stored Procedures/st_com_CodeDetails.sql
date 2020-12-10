IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CodeDetails')
DROP PROCEDURE [dbo].[st_com_CodeDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the Code details

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		17-Feb-2015

Modification History:
Modified By		Modified On	Description

Usage:
EXEC st_com_CodeDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CodeDetails]
	@inp_iCodeID			INT,							-- Id of the Code whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_CODE_GETDETAILS INT = 10013 -- Error occurred while fetching code details.
	DECLARE @ERR_CODE_NOTFOUND INT = 10009 -- Code does not exist.

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

		--Check if the Code whose details are being fetched exists
		IF (NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = @inp_iCodeID))
		BEGIN
				SET @out_nReturnValue = @ERR_CODE_NOTFOUND
				RETURN (@out_nReturnValue)
		END
				
		
		--Fetch the Code details
		SELECT  CodeID, CodeName, CodeGroupId, Description, IsVisible,IsActive,DisplayCode,ParentCodeId
		FROM	com_Code 
		WHERE	CodeID = @inp_iCodeID
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_CODE_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

