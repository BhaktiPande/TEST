IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_PolicyDocumentList')
DROP PROCEDURE [dbo].[st_rul_PolicyDocumentList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Policy Documents.

Returns:		0, if Success.
				
Created by:		Ashashree
Created on:		23-Mar-2015

Modification History:
Modified By		Modified On		Description
Ashashree		1-May-2015		Made change to add CASE condition to display CodeName/ DisplayCode from com_Code table 
								for Category and Subcategory
Tushar			09-Jul-2015		Change query for From Date & To Date search parameters.

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rul_PolicyDocumentList]
	@inp_iPageSize									INT = 10
	,@inp_iPageNo									INT = 1
	,@inp_sSortField								VARCHAR(255)
	,@inp_sSortOrder								VARCHAR(5)
	,@inp_sPolicyDocumentName						NVARCHAR(100) = NULL
	,@inp_dtApplicableFrom							VARCHAR(25) = NULL
	,@inp_dtApplicableTo							VARCHAR(25) = NULL
	,@inp_iDocumentCategoryCodeId					INT = NULL
	,@inp_iDocumentSubCategoryCodeId				INT = NULL
	,@inp_sDocumentStatusList						VARCHAR(255) = NULL		-- Comma separated list of WindowStatusCodeId to be searched
	,@inp_bIncludeDocumentStatusFlag				INT = NULL		-- Flag to indicate whether the comma separated list of WindowStatusCodeId si to be included/excluded
	,@out_nReturnValue								INT = 0 OUTPUT
	,@out_nSQLErrCode								INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN

	DECLARE @sSQL						NVARCHAR(MAX) = ''
	DECLARE @ERR_POLICYDOCUMENT_LIST	INT = 15040 -- Error occurred while fetching list of Policy Documents.
	DECLARE @dtDefault					DATETIME = CONVERT(DATETIME, '')
	DECLARE @nPolicyDocumentIncomplete	INT
	DECLARE @nPolicyDocumentActive		INT
	DECLARE	@nPolicyDocumentInactive	INT

	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		IF @inp_dtApplicableFrom = @dtDefault
			SET @inp_dtApplicableFrom = NULL
		
		IF @inp_dtApplicableTo = @dtDefault
			SET @inp_dtApplicableTo = NULL
			
		IF @inp_bIncludeDocumentStatusFlag IS NULL
			SET @inp_bIncludeDocumentStatusFlag = 1 /*By default include the policy document status listed in the input @inp_sDocumentStatusList */
		
		SELECT	@nPolicyDocumentIncomplete = 131001,
				@nPolicyDocumentActive = 131002,
				@nPolicyDocumentInactive = 131003
		
		--construct comma separated list of WindowStatusCodeId
		IF (@inp_sDocumentStatusList IS NULL OR @inp_sDocumentStatusList = '')
			SET @inp_sDocumentStatusList = CAST(@nPolicyDocumentIncomplete AS VARCHAR) + ', ' + CAST(@nPolicyDocumentActive AS VARCHAR) + ', ' + CAST(@nPolicyDocumentInactive AS VARCHAR)
			
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'PD.PolicyDocumentName '
		END 			
		
		IF @inp_sSortField = 'rul_grd_15032' -- Document Name
		BEGIN 
			SELECT @inp_sSortField = 'PD.PolicyDocumentName ' 
		END
		
		IF @inp_sSortField = 'rul_grd_15033' -- Category
		BEGIN 
			SELECT @inp_sSortField = '(CASE WHEN CdPDCategory.DisplayCode IS NULL OR CdPDCategory.DisplayCode = '''' THEN CdPDCategory.CodeName ELSE CdPDCategory.DisplayCode END) ' --CdPDCategory.CodeName
		END
		
		IF @inp_sSortField = 'rul_grd_15034' -- Sub-category
		BEGIN 
			SELECT @inp_sSortField = '(CASE WHEN CdPDSubCategory.DisplayCode IS NULL OR CdPDSubCategory.DisplayCode = '''' THEN CdPDSubCategory.CodeName ELSE CdPDSubCategory.DisplayCode END) ' --CdPDSubCategory.CodeName
		END
		
		IF @inp_sSortField = 'rul_grd_15035' -- Applicable from
		BEGIN 
			SELECT @inp_sSortField = 'PD.ApplicableFrom ' 
		END
		
		IF @inp_sSortField = 'rul_grd_15036' -- Applicable to
		BEGIN 
			SELECT @inp_sSortField = 'PD.ApplicableTo ' 
		END
		
		IF @inp_sSortField = 'rul_grd_15037' -- View
		BEGIN 
			SELECT @inp_sSortField = 'PD.DocumentViewFlag ' 
		END
		
		IF @inp_sSortField = 'rul_grd_15038' -- Mandatory agree
		BEGIN 
			SELECT @inp_sSortField = 'PD.DocumentViewAgreeFlag ' 
		END
		
		IF @inp_sSortField = 'rul_grd_15039' -- Status
		BEGIN 
			SELECT @inp_sSortField = 'CdPDStatus.CodeName ' 
		END
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',PD.PolicyDocumentId),PD.PolicyDocumentId '
		SELECT @sSQL = @sSQL + ' FROM rul_PolicyDocument PD LEFT JOIN com_Code CdPDCategory ON PD.DocumentCategoryCodeId = CdPDCategory.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CdPDSubCategory ON PD.DocumentSubCategoryCodeId = CdPDSubCategory.CodeID '
		SELECT @sSQL = @sSQL + ' INNER JOIN com_Code CdPDStatus ON PD.WindowStatusCodeId = CdPDStatus.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE 1=1 '
		SELECT @sSQL = @sSQL + ' AND PD.IsDeleted = 0 ' --fetch only the non-deleted records
	
		--WindowStatusCodeId filter to include/exclude status
		IF(@inp_bIncludeDocumentStatusFlag = 2) 
			SELECT @sSQL = @sSQL + ' AND PD.WindowStatusCodeId NOT IN ( '
		ELSE
			SELECT @sSQL = @sSQL + ' AND PD.WindowStatusCodeId IN ( '
			
		SELECT @sSQL = @sSQL + @inp_sDocumentStatusList + ' ) '
			
		--PolicyDocumentName filter
		IF (@inp_sPolicyDocumentName IS NOT NULL AND @inp_sPolicyDocumentName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND PD.PolicyDocumentName LIKE N''%' + @inp_sPolicyDocumentName + '%'' '
		END
		
		--DocumentCategoryCodeId filter
		IF (@inp_iDocumentCategoryCodeId IS NOT NULL AND @inp_iDocumentCategoryCodeId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND PD.DocumentCategoryCodeId = '+ CAST(@inp_iDocumentCategoryCodeId AS VARCHAR(20)) +' '
		END
		
		--DocumentSubCategoryCodeId filter
		IF (@inp_iDocumentSubCategoryCodeId IS NOT NULL AND @inp_iDocumentSubCategoryCodeId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND PD.DocumentSubCategoryCodeId = '+ CAST(@inp_iDocumentSubCategoryCodeId AS VARCHAR(20)) +' '
		END
		
		--@inp_dtApplicableFrom, @inp_dtApplicableTo filters
		IF (@inp_dtApplicableFrom IS NOT NULL OR @inp_dtApplicableTo IS NOT NULL)
		BEGIN
			/*Input from-date should be less than input to-date*/
			--IF (@inp_dtApplicableFrom IS NOT NULL AND @inp_dtApplicableTo IS NOT NULL) 
			--BEGIN
			--	SELECT @sSQL = @sSQL + ' AND  CAST(''' + CAST(@inp_dtApplicableFrom AS VARCHAR(25)) + ''' AS DATETIME) <= '
			--	SELECT @sSQL = @sSQL  + ' CAST(''' + CAST(@inp_dtApplicableTo AS VARCHAR(25)) + ''' AS DATETIME) '
			--END
		
			SELECT @sSQL = @sSQL + ' AND ( '
			IF (@inp_dtApplicableFrom IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' (PD.ApplicableFrom >= CAST('''  + CAST(@inp_dtApplicableFrom AS VARCHAR(25)) + ''' AS DATETIME))'
				--SELECT @sSQL = @sSQL + ' AND (PD.ApplicableTo IS NULL OR PD.ApplicableTo >= CAST('''  + CAST(@inp_dtApplicableFrom AS VARCHAR(25)) + '''AS DATETIME) ) )'
			END
			
			IF (@inp_dtApplicableFrom IS NOT NULL AND @inp_dtApplicableTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' AND '
			END
			
			IF (@inp_dtApplicableTo IS NOT NULL)
			BEGIN
				--SELECT @sSQL = @sSQL + ' (PD.ApplicableFrom <= CAST('''  + CAST(@inp_dtApplicableTo AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' (PD.ApplicableTo <= CAST('''  + CAST(@inp_dtApplicableTo AS VARCHAR(25)) + ''' AS DATETIME) )'
			END
			
			IF (@inp_dtApplicableFrom IS NOT NULL AND @inp_dtApplicableTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' OR ( CAST (''' + CAST(@inp_dtApplicableFrom AS VARCHAR(25)) + ''' AS DATETIME) <= PD.ApplicableFrom '
				SELECT @sSQL = @sSQL + ' AND (( CAST(''' + CAST(@inp_dtApplicableTo AS VARCHAR(25)) + ''' AS DATETIME) >= PD.ApplicableTo) ) )'
			END
			
			SELECT @sSQL = @sSQL + ' )'
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)
		
		SELECT	PD.PolicyDocumentId AS PolicyDocumentId, 
		PD.PolicyDocumentName AS rul_grd_15032, /*PolicyDocumentName*/
		(CASE WHEN CdPDCategory.DisplayCode IS NULL OR CdPDCategory.DisplayCode = '' THEN CdPDCategory.CodeName ELSE CdPDCategory.DisplayCode END) AS rul_grd_15033, /*Category*/
		(CASE WHEN CdPDSubCategory.DisplayCode IS NULL OR CdPDSubCategory.DisplayCode = '' THEN CdPDSubCategory.CodeName ELSE CdPDSubCategory.DisplayCode END)  AS rul_grd_15034, /*Subcategory*/
		PD.ApplicableFrom AS rul_grd_15035,
		PD.ApplicableTo AS rul_grd_15036,
		PD.DocumentViewFlag AS rul_grd_15037,
		PD.DocumentViewAgreeFlag AS rul_grd_15038,
		CdPDStatus.CodeName AS rul_grd_15039
		FROM	#tmpList T INNER JOIN rul_PolicyDocument PD ON T.EntityID = PD.PolicyDocumentId
				LEFT JOIN com_Code CdPDCategory ON PD.DocumentCategoryCodeId = CdPDCategory.CodeID
				LEFT JOIN com_Code CdPDSubCategory ON PD.DocumentSubCategoryCodeId = CdPDSubCategory.CodeID
				INNER JOIN com_Code CdPDStatus ON PD.WindowStatusCodeId = CdPDStatus.CodeID
		WHERE	1=1 AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_POLICYDOCUMENT_LIST
	END CATCH
END