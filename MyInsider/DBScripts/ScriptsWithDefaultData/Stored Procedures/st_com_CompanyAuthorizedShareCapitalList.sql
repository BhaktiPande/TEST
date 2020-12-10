IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyAuthorizedShareCapitalList')
DROP PROCEDURE [dbo].[st_com_CompanyAuthorizedShareCapitalList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list company authorized shares.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		20-Feb-2015

Modification History:
Modified By		Modified On		Description

Usage:
EXEC st_mst_CompanyList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_CompanyAuthorizedShareCapitalList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_iCompanyID				INT
	,@inp_dtAuthorizedShareCapitalDateFrom	DATETIME
	,@inp_dtAuthorizedShareCapitalDateTo	DATETIME
	,@inp_iAuthorizedSharesLower			DECIMAL(20, 4)
	,@inp_iAuthorizedSharesUpper			DECIMAL(20, 4)
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_COMPANYAUTSHARES_LIST INT = 13016 -- Error occurred while fetching list of face values for the company.

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
			SELECT @inp_sSortField = 'CA.AuthorizedShareCapitalDate '
		END 

		IF @inp_sSortField = 'cmp_grd_13017'
		BEGIN 
			SELECT @inp_sSortField = 'CA.AuthorizedShareCapitalDate '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13018'
		BEGIN 
			SELECT @inp_sSortField = 'CA.AuthorizedShares '
		END 

		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',CA.CompanyAuthorizedShareCapitalID),CA.CompanyAuthorizedShareCapitalID '
		SELECT @sSQL = @sSQL + ' FROM com_CompanyAuthorizedShareCapital CA '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 AND CA.CompanyID = ' + CAST(@inp_iCompanyID AS VARCHAR(10)) + ' '


		IF (@inp_dtAuthorizedShareCapitalDateFrom IS NOT NULL AND @inp_dtAuthorizedShareCapitalDateFrom <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CA.AuthorizedShareCapitalDate >= '''  + cast(@inp_dtAuthorizedShareCapitalDateFrom AS VARCHAR(11)) + ''''
		END

		IF (@inp_dtAuthorizedShareCapitalDateTo IS NOT NULL AND @inp_dtAuthorizedShareCapitalDateTo <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CA.AuthorizedShareCapitalDate <= '''  + cast(@inp_dtAuthorizedShareCapitalDateTo AS VARCHAR(11)) + ''''
		END

		IF (@inp_iAuthorizedSharesLower IS NOT NULL AND @inp_iAuthorizedSharesLower <> 0 )
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CA.AuthorizedShares >= '  + CAST(@inp_iAuthorizedSharesLower AS VARCHAR(20)) 
		END

		IF (@inp_iAuthorizedSharesUpper IS NOT NULL AND @inp_iAuthorizedSharesUpper <> 0 )
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CA.AuthorizedShares <= '  + CAST(@inp_iAuthorizedSharesUpper AS VARCHAR(20)) 
		END
		
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	CA.CompanyAuthorizedShareCapitalID,
				CA.AuthorizedShareCapitalDate AS cmp_grd_13017,
				CA.AuthorizedShares AS cmp_grd_13018
		FROM	#tmpList T INNER JOIN
				com_CompanyAuthorizedShareCapital CA ON CA.CompanyAuthorizedShareCapitalID = T.EntityID
		WHERE   CA.CompanyAuthorizedShareCapitalID IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COMPANYAUTSHARES_LIST
	END CATCH
END
