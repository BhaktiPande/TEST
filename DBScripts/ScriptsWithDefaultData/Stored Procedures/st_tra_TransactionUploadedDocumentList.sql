IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionUploadedDocumentList')
DROP PROCEDURE [dbo].[st_tra_TransactionUploadedDocumentList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	fetch list of uploaded documents for a transaction (initial / continuous / period-end)

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		15-Sep-2016

Modification History:
Modified By		Modified On		Description

Usage:
EXEC st_tra_TransactionUploadedDocumentList <MapToTypeId> <MapToId>
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TransactionUploadedDocumentList] 
	@inp_iPageSize							INT = 10,
	@inp_iPageNo							INT = 1,
	@inp_sSortField							VARCHAR(255),
	@inp_sSortOrder							VARCHAR(5),
	@inp_nMapToTypeCodeId					INT = 132005,
	@inp_nMapToId							INT,	--Id of transaction for which the corresponding documents are to be fetched
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT

AS
BEGIN
	DECLARE @ERR_FORM_GENERATION_FAIL		INT = 16451 --Error occurred while fetching list of uploaded document corresponding to a transaction

	DECLARE @sSQL							NVARCHAR(MAX) = ''
	DECLARE @nTransactionUploadedDocument	INT = 133003

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

		-- Set default sort order 
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END

		-- Set default sort field 
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'D.CreatedOn '
		END
		
		--IF @inp_sSortField = 'tra_grd_16450' 
		--BEGIN 
		--	SELECT @inp_sSortField = 'D.CreatedOn ' 
		--END

		/*Fetch the list of documents uploaded against the input transaction masterid (@inp_nMapToId)*/
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',D.DocumentId), D.DocumentId '
		SELECT @sSQL = @sSQL + ' FROM com_Document D INNER JOIN com_DocumentObjectMapping DOM '
		SELECT @sSQL = @sSQL + ' ON D.DocumentId = DOM.DocumentId AND DOM.MapToTypeCodeId = ' + CONVERT(VARCHAR(10),@inp_nMapToTypeCodeId) 
		SELECT @sSQL = @sSQL + ' AND DOM.MapToId = ' + CONVERT(VARCHAR(10),@inp_nMapToId) + 
							   ' AND PurposeCodeId = ' + CONVERT(VARCHAR(10),@nTransactionUploadedDocument)

		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT D.DocumentId, 
		T.RowNumber AS tra_grd_16448,
		D.DocumentName AS tra_grd_16449,
		REPLACE(CONVERT(VARCHAR(20), D.CreatedOn, 106), ' ', '/') AS tra_grd_16450
		FROM #tmpList T INNER JOIN com_Document D 
		ON T.EntityID = D.DocumentId
		WHERE	1=1 AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END TRY
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_FORM_GENERATION_FAIL, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH

END