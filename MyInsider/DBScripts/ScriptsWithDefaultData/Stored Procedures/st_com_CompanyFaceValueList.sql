IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyFaceValueList')
DROP PROCEDURE [dbo].[st_com_CompanyFaceValueList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list company face values.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		20-Feb-2015

Modification History:
Modified By		Modified On		Description
Tushar			21-May-2015		Cast Face Value date in decimal format
Usage:
EXEC st_mst_CompanyList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_CompanyFaceValueList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_iCompanyID				INT
	,@inp_iCurrencyID				INT
	,@inp_dtFaceValueDateFrom		DATETIME
	,@inp_dtFaceValueDateTo			DATETIME
	,@inp_iFaceValueLower			DECIMAL(15, 4)
	,@inp_iFaceValueUpper			DECIMAL(15, 4)
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_COMPANYFACEVALUE_LIST INT = 13012 -- Error occurred while fetching list of face values for the company.

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
			SELECT @inp_sSortField = 'CF.FaceValueDate '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13013'
		BEGIN 
			SELECT @inp_sSortField = 'CF.FaceValueDate '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13014'
		BEGIN 
			SELECT @inp_sSortField = 'CF.FaceValue '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13015'
		BEGIN 
			SELECT @inp_sSortField = 'CCurrency.CodeName '
		END 

		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',CF.CompanyFaceValueID),CF.CompanyFaceValueID '
		SELECT @sSQL = @sSQL + ' FROM com_CompanyFaceValue CF '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CCurrency ON CCurrency.CodeID = CurrencyID '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 AND CF.CompanyID = ' + CAST(@inp_iCompanyID AS VARCHAR(10)) + ' '

		IF (@inp_iCurrencyID IS NOT NULL AND @inp_iCurrencyID <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CF.CurrencyID = '  + CAST(@inp_iCurrencyID AS VARCHAR(10)) 
		END

		IF (@inp_dtFaceValueDateFrom IS NOT NULL AND @inp_dtFaceValueDateFrom <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CF.FaceValueDate >= '''  + cast(@inp_dtFaceValueDateFrom AS VARCHAR(11)) + ''''
		END

		IF (@inp_dtFaceValueDateTo IS NOT NULL AND @inp_dtFaceValueDateTo <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CF.FaceValueDate <= '''  + cast(@inp_dtFaceValueDateTo AS VARCHAR(11)) + ''''
		END

		IF (@inp_iFaceValueLower IS NOT NULL AND @inp_iFaceValueLower <> 0 )
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CF.FaceValue >= '  + CAST(@inp_iFaceValueLower AS VARCHAR(20)) 
		END

		IF (@inp_iFaceValueUpper IS NOT NULL AND @inp_iFaceValueUpper <> 0 )
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CF.FaceValue <= '  + CAST(@inp_iFaceValueUpper AS VARCHAR(20)) 
		END
		
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	CompanyFaceValueID,
				FaceValueDate AS cmp_grd_13013,
				--FaceValue AS cmp_grd_13014,
				CAST(CONVERT(DECIMAL(10,2),FaceValue) AS NVARCHAR) AS cmp_grd_13014,
				CurrencyID,
				CCurrency.CodeName AS cmp_grd_13015 --CurrencyName
		FROM	#tmpList T INNER JOIN
				com_CompanyFaceValue CF ON CF.CompanyFaceValueID = T.EntityID
				JOIN com_Code CCurrency ON CCurrency.CodeID = CurrencyID
		WHERE   CF.CompanyFaceValueID IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COMPANYFACEVALUE_LIST
	END CATCH
END
