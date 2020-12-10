IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_UsersPolicyDocumentDetails')
DROP PROCEDURE [dbo].[st_rul_UsersPolicyDocumentDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get Policy Document Details.

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		23-Apr-2015
Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_rul_UsersPolicyDocumentDetails ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rul_UsersPolicyDocumentDetails]
	@inp_iPolicyDocumentId	INT,
	@inp_iDocumentId		INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_POLICYDOCUMENT_NOTFOUND INT = -1 --Policy Document details does not exist.
	DECLARE @ERR_DOCUMENT_NOTFOUND INT = -1
	DECLARE @ERR_USERSPOLICYDOCUMENTDETAILS INT = -1 -- Error occurred while fetching Policy document details.
	DECLARE @nRetValue INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		--Check if the details are being fetched exists
		IF (NOT EXISTS(select PolicyDocumentId from rul_PolicyDocument WHERE PolicyDocumentId = @inp_iPolicyDocumentId))
		BEGIN
				SET @out_nReturnValue = @ERR_POLICYDOCUMENT_NOTFOUND
				RETURN (@out_nReturnValue)
		END
		
		IF (NOT EXISTS(select DocumentId from com_Document WHERE DocumentId = @inp_iDocumentId))
		BEGIN
				SET @out_nReturnValue = @ERR_DOCUMENT_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the Policy Document details
		SELECT  PolicyDocumentId,
				PolicyDocumentName, 
				DocumentViewFlag, 
				DocumentViewAgreeFlag, 
				D.FileType				AS PolicyDocumentFileType,
				D.DocumentPath			AS PolicyDocumentPath
		FROM	rul_PolicyDocument PD 
				--left join com_Document D 
				left join com_DocumentObjectMapping dom on dom.MapToId = PD.PolicyDocumentId
				left join com_Document D on D.DocumentId = dom.DocumentId
		WHERE	PolicyDocumentId = @inp_iPolicyDocumentId AND D.DocumentId = @inp_iDocumentId

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_USERSPOLICYDOCUMENTDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END