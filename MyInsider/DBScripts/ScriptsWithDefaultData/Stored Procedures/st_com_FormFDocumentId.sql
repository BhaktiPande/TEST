IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_FormFDocumentId')
DROP PROCEDURE [dbo].[st_com_FormFDocumentId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the Form F document Id.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		26-Sep-2016

Modification History:
Modified By		Modified On		Description

Usage:
EXEC [st_com_FormFDocumentId] 132016, 133004
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_FormFDocumentId]
	 @inp_iMapToTypeCodeId			INT
	,@inp_iPurposeCodeId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_DOCUMENT_NOTFOUND INT = 11043 -- Document details do not exist..

	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		
			--Check if the UserInfo whose details are being updated exists
			IF (NOT EXISTS(SELECT DocumentObjectMapId FROM com_DocumentObjectMapping WHERE MapToTypeCodeId = @inp_iMapToTypeCodeId AND PurposeCodeId = @inp_iPurposeCodeId))
			BEGIN		
				SET @out_nReturnValue = @ERR_DOCUMENT_NOTFOUND
				RETURN (@out_nReturnValue)
			END

			SELECT MAX(DocumentId) FROM com_DocumentObjectMapping WHERE MapToTypeCodeId = @inp_iMapToTypeCodeId AND PurposeCodeId = @inp_iPurposeCodeId
				
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_DOCUMENT_NOTFOUND,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
