IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyListingDetailsList')
DROP PROCEDURE [dbo].[st_com_CompanyListingDetailsList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list company listing details.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		22-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		25-Feb-2015		Join to code table is added in the output
Usage:
EXEC st_mst_CompanyList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_CompanyListingDetailsList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_iCompanyID				INT
	,@inp_iStockExchangeID			INT
	,@inp_dtDateOfListingFrom_Lower	DATETIME
	,@inp_dtDateOfListingFrom_Upper	DATETIME
	,@inp_dtDateOfListingTo_Lower	DATETIME
	,@inp_dtDateOfListingTo_Upper	DATETIME
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_COMPANYLISTINGDETAILS_LIST INT = 13022 -- Error occurred while fetching list of listing details for the company.

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
			SELECT @inp_sSortField = 'CStockEx.CodeName '
		END 

		IF @inp_sSortField = 'cmp_grd_13023' -- ', 'Stock Exchange Name'
		BEGIN 
			SELECT @inp_sSortField = 'CStockEx.CodeName '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13024' -- '', 'Stock Exchange Code'
		BEGIN 
			SELECT @inp_sSortField = 'CStockEx.DisplayCode '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13025' -- ', 'Date of Listing'
		BEGIN 
			SELECT @inp_sSortField = 'CL.DateOfListingFrom '
		END 

		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',CL.CompanyListingDetailsID),CL.CompanyListingDetailsID '
		SELECT @sSQL = @sSQL + ' FROM com_CompanyListingDetails CL '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CStockEx ON CL.StockExchangeID = CStockEx.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 AND CL.CompanyID = ' + CAST(@inp_iCompanyID AS VARCHAR(10)) + ' '


		IF (@inp_iStockExchangeID IS NOT NULL AND @inp_iStockExchangeID <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CL.StockExchangeID = '  + cast(@inp_iStockExchangeID AS VARCHAR(11)) + ' '
		END

		IF (@inp_dtDateOfListingFrom_Lower IS NOT NULL AND @inp_dtDateOfListingFrom_Lower <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CL.DateOfListingFrom >= '''  + cast(@inp_dtDateOfListingFrom_Lower AS VARCHAR(11)) + ''''
		END

		IF (@inp_dtDateOfListingFrom_Upper IS NOT NULL AND @inp_dtDateOfListingFrom_Upper <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CL.DateOfListingFrom <= '''  + cast(@inp_dtDateOfListingFrom_Upper AS VARCHAR(11)) + ''''
		END

		IF (@inp_dtDateOfListingTo_Lower IS NOT NULL AND @inp_dtDateOfListingTo_Lower <> 0 )
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CL.DateOfListingTo >= '  + CAST(@inp_dtDateOfListingTo_Lower AS VARCHAR(20)) 
		END

		IF (@inp_dtDateOfListingTo_Lower IS NOT NULL AND @inp_dtDateOfListingTo_Lower <> 0 )
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CL.DateOfListingTo <= '  + CAST(@inp_dtDateOfListingTo_Lower AS VARCHAR(20)) 
		END
		
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	CL.CompanyListingDetailsID,
				CStockEx.CodeName AS cmp_grd_13023,
				CStockEx.DisplayCode AS cmp_grd_13024,
				CL.DateOfListingFrom AS cmp_grd_13025
				--CA.AuthorizedShareCapitalDate AS cmp_grd_13017,
				--CA.AuthorizedShares AS cmp_grd_13018
		FROM	#tmpList T INNER JOIN
				com_CompanyListingDetails CL ON CL.CompanyListingDetailsID = T.EntityID
				JOIN com_Code CStockEx ON CL.StockExchangeID = CStockEx.CodeID
		WHERE   CL.CompanyListingDetailsID IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COMPANYLISTINGDETAILS_LIST
	END CATCH
END
