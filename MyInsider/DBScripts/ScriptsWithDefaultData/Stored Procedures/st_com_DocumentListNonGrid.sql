IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_DocumentListNonGrid')
DROP PROCEDURE [dbo].[st_com_DocumentListNonGrid]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save user info.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		14-Apr-2015

Modification History:
Modified By		Modified On		Description

Usage:
EXEC usr_DocumentDetailsList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_DocumentListNonGrid]
	@inp_iMapToTypeCodeId			INT
	,@inp_iMapToId					INT
	,@inp_iPurposeCodeId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_Document_LIST INT = 11042	-- Error occurred while fetching list of documents for user.
	DECLARE @PEDocUploaded INT = 132026		--Map To Type - Period End Document Upload

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		if(@inp_iMapToTypeCodeId = @PEDocUploaded)
		BEGIN
			SELECT UD.*, DOM.DocumentObjectMapId, DOM.MapToTypeCodeId, DOM.MapToId, DOM.PurposeCodeId
			FROM com_Document UD 
			JOIN com_DocumentObjectMapping DOM ON UD.DocumentId = DOM.DocumentId
			WHERE DOM.MapToTypeCodeId = @inp_iMapToTypeCodeId  AND DOM.MapToId = @inp_iMapToId
			AND ISNULL(PurposeCodeId, 0) = ISNULL(0, 0)
		END
		ELSE
		BEGIN
			SELECT UD.*, DOM.DocumentObjectMapId, DOM.MapToTypeCodeId, DOM.MapToId, DOM.PurposeCodeId
			FROM com_Document UD JOIN com_DocumentObjectMapping DOM ON UD.DocumentId = DOM.DocumentId  
			WHERE MapToTypeCodeId = @inp_iMapToTypeCodeId  AND MapToId = @inp_iMapToId
			AND ISNULL(PurposeCodeId, 0) = ISNULL(@inp_iPurposeCodeId, 0)
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_Document_LIST
	END CATCH
END