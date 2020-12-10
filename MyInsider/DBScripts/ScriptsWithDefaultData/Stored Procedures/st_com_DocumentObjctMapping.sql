IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_DocumentObjctMapping')
DROP PROCEDURE [dbo].[st_com_DocumentObjctMapping]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves demat details for Employee / Non-Employee type user.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		26-Mar-2015

Modification History:
Modified By		Modified On		Description

Usage:
EXEC st_usr_DMATDetailsSave 1, 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_DocumentObjctMapping]
	@inp_iDocumentObjctMapId		INT
	,@inp_iDocumentDetailsID		INT OUTPUT
	,@inp_iMapToTypeCodeId			INT
	,@inp_iMapToId					INT
	,@inp_iPurposeCodeId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_DOCUMENT_SAVE INT = 11044 -- Error occurred while saving document details
	DECLARE @ERR_DOCUMENT_NOTFOUND INT = 11043 -- Demat details does not exist.
	DECLARE @ERR_USERNOTVALIDFORDOCUMENT INT = 11041 -- Cannot save Document details. To save Document details, user should be of type employee or non-employee.
	
	DECLARE --@nUserType_CO INT = 101002,
			@nUserType_Employee INT = 101003,
			--@nUserType_CorporateUser INT = 101004,
			@nUserType_NonEmployee INT = 101006,
			@nUserType_Relative INT = 101007

	DECLARE @MAPTOTYPE_PolicyDocument INT = 132001
	DECLARE @MAPTOTYPE_TradingPolicy INT = 132002
	DECLARE @MAPTOTYPE_User INT = 132003
	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF @inp_iDocumentObjctMapId = 0
		BEGIN
			-- Insert new record
			INSERT INTO com_DocumentObjectMapping
				(DocumentId, MapToTypeCodeId, MapToId, PurposeCodeId)
			VALUES
				(@inp_iDocumentDetailsID, @inp_iMapToTypeCodeId, @inp_iMapToId, @inp_iPurposeCodeId)
			
			SET @inp_iDocumentObjctMapId = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			--Check if the UserInfo whose details are being updated exists
			IF (NOT EXISTS(SELECT @inp_iDocumentObjctMapId FROM com_DocumentObjectMapping WHERE DocumentObjectMapId = @inp_iDocumentObjctMapId))
			BEGIN		
				SET @out_nReturnValue = @ERR_DOCUMENT_NOTFOUND
				RETURN (@out_nReturnValue)
			END

			-- Update existing details
			UPDATE com_DocumentObjectMapping
			SET DocumentId = @inp_iDocumentDetailsID,
				MapToTypeCodeId = @inp_iMapToTypeCodeId,
				MapToId = @inp_iMapToId,
				PurposeCodeId = @inp_iPurposeCodeId
			WHERE DocumentObjectMapId = @inp_iDocumentObjctMapId
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_DOCUMENT_SAVE,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
