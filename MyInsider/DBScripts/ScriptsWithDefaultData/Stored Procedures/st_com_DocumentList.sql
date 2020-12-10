IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_DocumentList')
DROP PROCEDURE [dbo].[st_com_DocumentList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save user info.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		26-Mar-2015

Modification History:
Modified By		Modified On		Description
Ashish			26-Mar-2015		Added columns during selection

Usage:
EXEC usr_DocumentDetailsList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_DocumentList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	--,@inp_iUserInfoID				INT
	,@inp_sGUID						NVARCHAR(100)	
	,@inp_sDocumentName				NVARCHAR(200)
	,@inp_sDescription				NVARCHAR(512)	
	,@inp_sDocumentPath				VARCHAR(512)
	,@inp_iFileSizeLower			BIGINT -- Filesize greater than this value
	,@inp_iFileSizeUpper			BIGINT -- Filesize greater than this value
	,@inp_sFileType					NVARCHAR(50)
	,@inp_iMapToTypeCodeId			INT
	,@inp_iMapToId					INT
	,@inp_iPurposeCodeId			INT
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

			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'UD.DocumentName '
		END 
		
		IF @inp_sSortField = 'usr_grd_11201'  -- Path
		BEGIN 
			SELECT @inp_sSortField = 'UD.DocumentPath '
		END 
		
		IF @inp_sSortField = 'usr_grd_11200'  -- Description
		BEGIN 
			SELECT @inp_sSortField = 'UD.Description '
		END 
		
		IF @inp_sSortField = 'usr_grd_11099' -- Name of Document
	
		BEGIN 
			SELECT @inp_sSortField = 'UD.DocumentName '
		END 
		
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UD.DocumentId),UD.DocumentId '
		SELECT @sSQL = @sSQL + ' FROM com_Document UD JOIN com_DocumentObjectMapping DOM ON UD.DocumentId = DOM.DocumentId '
		SELECT @sSQL = @sSQL + ' WHERE MapToTypeCodeId = ' + CAST(@inp_iMapToTypeCodeId AS VARCHAR(10)) + ' '
		SELECT @sSQL = @sSQL + ' AND MapToId = ' + CAST(@inp_iMapToId AS VARCHAR(10)) + ' '
		IF @inp_iPurposeCodeId IS NULL
			SELECT @sSQL = @sSQL + ' AND PurposeCodeId IS NULL '
		ELSE
			SELECT @sSQL = @sSQL + ' AND PurposeCodeId = ' + CAST(@inp_iPurposeCodeId AS VARCHAR(10)) + ' '

		IF (@inp_sGUID IS NOT NULL AND @inp_sGUID <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.GUID LIKE N''%'+ @inp_sGUID +'%'' '
		END
		
		IF (@inp_sDocumentName IS NOT NULL AND @inp_sDocumentName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.DocumentName LIKE N''%'+ @inp_sDocumentName +'%'' '
		END
		
		IF (@inp_sDescription IS NOT NULL AND @inp_sDescription <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.Description LIKE N''%'+ @inp_sDescription +'%'' '
		END
		
		IF (@inp_sDocumentPath IS NOT NULL AND @inp_sDocumentPath <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.DocumentPath LIKE N''%'+ @inp_sDocumentPath +'%'' '
		END

		IF (@inp_iFileSizeLower IS NOT NULL AND @inp_iFileSizeLower <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.FileSize > '+ CAST(@inp_iFileSizeLower AS VARCHAR(10)) + ' '
		END

		IF (@inp_iFileSizeUpper IS NOT NULL AND @inp_iFileSizeUpper <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.FileSize < '+ CAST(@inp_iFileSizeUpper AS VARCHAR(10)) + ' '
		END

		IF (@inp_sFileType IS NOT NULL AND @inp_sFileType <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.FileType LIKE N''%'+ @inp_sFileType +'%'' '
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	UD.DocumentId AS DocumentId,
				UD.DocumentName AS usr_grd_11099, -- DocumentName,
				UD.DocumentPath AS usr_grd_11201, -- DocumentPath,
				UD.FileSize AS FileSize,
				UD.FileType AS FileType,
				UD.GUID AS GUID,
				UD.Description AS usr_grd_11200, -- Description,
				UD.CreatedBy AS CreatedBy,
				UD.CreatedOn AS CreatedOn,
				UD.ModifiedBy AS ModifiedBy,
				UD.ModifiedOn AS ModifiedOn,
				UICreatedBy.FirstName AS CreatedByName,
				UIModifiedBy.FirstName AS ModifiedByName,
				DOM.MapToTypeCodeId as MapToTypeCodeId,
				DOM.MapToId as MapToId
		FROM	#tmpList T INNER JOIN
				com_Document UD ON UD.DocumentId = T.EntityID
				JOIN com_DocumentObjectMapping DOM ON UD.DocumentId = DOM.DocumentId 
				JOIN usr_UserInfo UICreatedBy ON UD.CreatedBy = UICreatedBy.UserInfoId
				JOIN usr_UserInfo UIModifiedBy ON UD.CreatedBy = UIModifiedBy.UserInfoId
		WHERE   UD.DocumentId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_Document_LIST
	END CATCH
END
