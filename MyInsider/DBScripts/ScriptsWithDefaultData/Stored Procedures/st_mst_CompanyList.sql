IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_mst_CompanyList')
DROP PROCEDURE [dbo].[st_mst_CompanyList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list companies.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		18-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		24-Feb-2015		Sorting was not working
Tushar			21-May-2015		Sorting IsImplementing First and then Company Name sort ascending
Tushar			16-Jul-2015		Search for Wildcard character
Tushar			17-Jul-2015		Underscore character now search.

Usage:
EXEC st_mst_CompanyList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_mst_CompanyList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_sCompanyName				NVARCHAR(200)
	,@inp_sAddress					NVARCHAR(1024)
	,@inp_sWebsite					VARCHAR(512)
	,@inp_sEmailId					NVARCHAR(250)
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_COMPANY_LIST INT = 13005 -- Error occurred while fetching list of documents for user.

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
			SELECT @inp_sSortOrder = 'DESC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'C.ModifiedOn '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13001'  -- CompanyName,
		BEGIN 
			SELECT @inp_sSortField = 'C.IsImplementing DESC, C.CompanyName '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13002'  -- Website,
		BEGIN 
			SELECT @inp_sSortField = 'C.Website '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13003'  -- EmailId,
		BEGIN 
			SELECT @inp_sSortField = 'C.EmailId '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13006'  -- Address
		BEGIN 
			SELECT @inp_sSortField = 'C.Address '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13004'  -- IsImplementing
		BEGIN 
			SELECT @inp_sSortField = 'C.IsImplementing '
		END 
		
		print @inp_sSortField
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',C.CompanyId),C.CompanyId '
		SELECT @sSQL = @sSQL + ' FROM mst_Company C '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '


		IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')	
		BEGIN
		    SELECT	@inp_sCompanyName = REPLACE(@inp_sCompanyName, '[', '[\[]')
			SELECT	@inp_sCompanyName = REPLACE(@inp_sCompanyName, '/', '[/]')
			SELECT	@inp_sCompanyName = REPLACE(@inp_sCompanyName, '`', '[`]')
			SELECT	@inp_sCompanyName = REPLACE(@inp_sCompanyName, '_', '[_]')
			SELECT @sSQL = @sSQL + ' AND C.CompanyName LIKE N''%'+ @inp_sCompanyName +'%'' ESCAPE ''\''' 
		END
		
		IF (@inp_sAddress IS NOT NULL AND @inp_sAddress <> '')	
		BEGIN
			SELECT	@inp_sAddress = REPLACE(@inp_sAddress, '[', '[\[]')
			SELECT	@inp_sAddress = REPLACE(@inp_sAddress, '/', '[/]')
			SELECT	@inp_sAddress = REPLACE(@inp_sAddress, '`', '[`]')
			SELECT	@inp_sAddress = REPLACE(@inp_sAddress, '_', '[_]')
			SELECT @sSQL = @sSQL + ' AND C.Address LIKE N''%'+ @inp_sAddress +'%'' ESCAPE ''\'''
		END
		
		IF (@inp_sWebsite IS NOT NULL AND @inp_sWebsite <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND C.Website LIKE N''%'+ @inp_sWebsite +'%'' '
		END
		
		IF (@inp_sEmailId IS NOT NULL AND @inp_sEmailId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND C.EmailId LIKE N''%'+ @inp_sEmailId +'%'' '
		END
		
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	C.CompanyId AS CompanyId,
				C.CompanyName AS cmp_grd_13001, --CompanyName,
				C.Website AS cmp_grd_13002, --Website,
				C.EmailId AS cmp_grd_13003, --EmailId,
				C.Address as cmp_grd_13006, --Address
				C.IsImplementing AS cmp_grd_13004 --IsImplementing
		FROM	#tmpList T INNER JOIN
				mst_Company C ON C.CompanyId = T.EntityID
		WHERE   C.CompanyId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COMPANY_LIST
	END CATCH
END
