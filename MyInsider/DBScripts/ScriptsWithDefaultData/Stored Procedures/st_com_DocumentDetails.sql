IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_DocumentDetails')
DROP PROCEDURE [dbo].[st_com_DocumentDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get Document Details.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		26-Mar-2015
Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_usr_DocumentDetails ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_DocumentDetails]
	@inp_iDocumentDetailsID		INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_DOCUMENTDETAILS_NOTFOUND INT = 11043 -- Document details does not exist.
	DECLARE @ERR_DOCUMENTDETAILS_GETDETAILS INT = 11204 -- Error occurred while fetching document details.
	DECLARE @nRetValue INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Check if the DMAT whose details are being fetched exists
		IF (NOT EXISTS(select DocumentId from com_Document WHERE DocumentId = @inp_iDocumentDetailsID))
		BEGIN
				SET @out_nReturnValue = @ERR_DOCUMENTDETAILS_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the Company details
		SELECT D.*, DOM.MapToTypeCodeId, DOM.MapToId, DOM.PurposeCodeId
		FROM com_Document D JOIN com_DocumentObjectMapping DOM ON D.DocumentId = DOM.DocumentId
		WHERE D.DocumentId = @inp_iDocumentDetailsID

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_DOCUMENTDETAILS_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END