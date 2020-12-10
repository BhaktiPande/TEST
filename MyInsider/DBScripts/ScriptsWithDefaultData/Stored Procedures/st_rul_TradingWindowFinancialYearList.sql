IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingWindowFinancialYearList')
DROP PROCEDURE [dbo].[st_rul_TradingWindowFinancialYearList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Trading Window Financial year event.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		13-Mar-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	18-Mar-2015		CAST int to varchar for string concatination @sSQL.
Gaurishankar	23-Mar-2015		Change in select query for FinancialYearCodeId and FinancialPeriodCodeId
Gaurishankar	01-Apr-2015		Added parameter FinancialPeriodTypeCodeId and change sorting. 
Gaurishankar	02-Apr-2015		Added Result declration default date.
Gaurishankar	08-Jun-2015		auto populate TradingWindowId as 2015-16 A1.
Arundhati		31-Oct-2015		Codes (dates) for Period end date are changed. Now that are stored as the 1st of next month.

Usage:
EXEC st_rul_TradingWindowFinancialYearList 2
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_TradingWindowFinancialYearList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
    ,@inp_nFinancialYearCodeId		INT
    ,@inp_nFinancialPeriodTypeCodeId		INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_FINANCIALYEAR_LIST INT = 15008 -- Error occurred while fetching trading windows event details.
	DECLARE @nFINANCIAL_PERIOD_CODEGROUPID INT
	DECLARE @nFINANCIAL_RESULT_EVENT_TYPE_CODEID INT
	DECLARE @sYear VARCHAR(10), @nYear int
	BEGIN TRY
		
		SET NOCOUNT ON;
		SET @nFINANCIAL_PERIOD_CODEGROUPID = 124
		SET @nFINANCIAL_RESULT_EVENT_TYPE_CODEID = 126001
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		SELECT @sYear = Description FROM com_Code WHERE CodeId = @inp_nFinancialYearCodeId

		SELECT @nYear = SUBSTRING(@sYear, 1, 4)
			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		

	
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		--IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		--BEGIN 
			SELECT @inp_sSortField = 'C_FINANCIALPERIOD.CodeName '
		--END 

		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',C_FINANCIALPERIOD.CodeID),C_FINANCIALPERIOD.CodeID '				
		SELECT @sSQL = @sSQL + ' FROM com_Code C_FINANCIAL_YEAR
								INNER JOIN com_Code C_FINANCIALPERIOD_TYPE ON C_FINANCIALPERIOD_TYPE.CodeID =  ' + CAST(@inp_nFinancialPeriodTypeCodeId as VARCHAR(20) ) +' 
								INNER JOIN com_Code C_FINANCIALPERIOD ON C_FINANCIALPERIOD_TYPE.CodeID = C_FINANCIALPERIOD.ParentCodeId 
																	AND C_FINANCIALPERIOD.CodeGroupId = '+CAST(@nFINANCIAL_PERIOD_CODEGROUPID as NVARCHAR(10) )+'
								LEFT JOIN rul_TradingWindowEvent TWE ON C_FINANCIAL_YEAR.CodeID = TWE.FinancialYearCodeId 
																	AND C_FINANCIALPERIOD.CodeID = TWE.FinancialPeriodCodeId
								where C_FINANCIAL_YEAR.CodeID  = ' + CAST(@inp_nFinancialYearCodeId as VARCHAR(20) ) +'
										AND (TWE.EventTypeCodeId IS NULL OR TWE.EventTypeCodeId = '+CAST(@nFINANCIAL_RESULT_EVENT_TYPE_CODEID as VARCHAR(20) ) +' ) '
		
		EXEC(@sSQL)

		SELECT	TWE.TradingWindowEventId AS TradingWindowEventId --NO			
				,@inp_nFinancialYearCodeId AS FinancialYearCodeId -- NO
				,C_FINANCIALPERIOD.CodeID as FinancialPeriodCodeId -- NO
				,C_FINANCIALPERIOD.CodeName AS rul_grd_15001 --FINANCIALPERIOD_CODENAME
				,CASE WHEN (TWE.TradingWindowEventId IS NULL OR TWE.TradingWindowEventId = 0 ) THEN 
						@sYear + ' '+ C_FINANCIALPERIOD.CodeName 
						ELSE TWE.TradingWindowId  END AS rul_grd_15002
				,TWE.EventTypeCodeId -- no
				,TWE.DaysPriorToResultDeclaration AS rul_grd_15006
				,TWE.DaysPostResultDeclaration AS rul_grd_15007
				,CASE WHEN (TWE.ResultDeclarationDate IS NULL OR TWE.ResultDeclarationDate = '' ) THEN					
					CONVERT(DATETIME, DATEADD(DAY, -1, DATEADD(YEAR, (@nYear-1970), CONVERT(DATETIME, C_FINANCIALPERIOD.Description))))
					ELSE
						TWE.ResultDeclarationDate
					END AS rul_grd_15003
				,TWE.WindowCloseDate AS rul_grd_15004
				,TWE.WindowOpenDate AS rul_grd_15005
		FROM	 #tmpList T INNER JOIN
				 com_Code C_FINANCIALPERIOD ON C_FINANCIALPERIOD.CodeID = T.EntityID
				 LEFT JOIN rul_TradingWindowEvent TWE ON TWE.FinancialYearCodeId = @inp_nFinancialYearCodeId  AND C_FINANCIALPERIOD.CodeID = TWE.FinancialPeriodCodeId
		WHERE   C_FINANCIALPERIOD.CodeID IS NOT NULL AND (TWE.EventTypeCodeId IS NULL OR TWE.EventTypeCodeId = @nFINANCIAL_RESULT_EVENT_TYPE_CODEID )
				AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.EntityID
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_FINANCIALYEAR_LIST
	END CATCH
END
