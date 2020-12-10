IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_DocumentCount')
DROP PROCEDURE [dbo].[st_com_DocumentCount]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to get document count.

Returns:		0, if Success.
				
Created by:		Gaurishankar	
Created on:		17-Sept-2016

Modification History:
Modified By		Modified On		Description

Usage:
EXEC [st_com_DocumentCount] 132005 ,262
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_DocumentCount]
	@inp_iMapToTypeCodeId			INT
	,@inp_iMapToId					INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_Document_LIST INT = 11042 -- Error occurred while fetching list of documents for user.

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''


		SELECT COUNT(UD.DocumentId)
		--UD.*, DOM.DocumentObjectMapId, DOM.MapToTypeCodeId, DOM.MapToId, DOM.PurposeCodeId
		FROM com_Document UD JOIN com_DocumentObjectMapping DOM ON UD.DocumentId = DOM.DocumentId  
		WHERE MapToTypeCodeId = @inp_iMapToTypeCodeId  AND MapToId = @inp_iMapToId

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_Document_LIST
	END CATCH
END

