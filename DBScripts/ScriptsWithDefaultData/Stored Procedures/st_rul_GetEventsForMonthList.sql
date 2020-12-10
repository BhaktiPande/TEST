IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_GetEventsForMonthList')
DROP PROCEDURE [dbo].[st_rul_GetEventsForMonthList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		18-Jun-2015

Modification History:
Modified By		Modified On		Description
Tushar			22-Jun-2015		Modified query for date condition.
Gaurishankar	21-Jul-2015		Changes for When financial year Event is displayed then close reason not viewed in the grid.
Tushar			03-Nov-2015		Trading Window Other event only activated event listed out.
Tushar			17-Mar-2016		Listed Event by User ID.

Usage:
DECLARE @RC int
EXEC st_rul_GetEventsForMonthList ,
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_GetEventsForMonthList] 
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@dt_Month						DATETIME
	,@inp_iUserInfoID				INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	
	BEGIN TRY
		
		DECLARE @sSQL							NVARCHAR(MAX) = ''
		DECLARE @dtEndDateOfMonth				DATETIME
		DECLARE @dtStartDateOfMonth				DATETIME
		DECLARE @ERR_GETEVENT_LIST				INT = 15386 -- Error occurred while fetching list of transactions.
		DECLARE	@nEventTypeFinancialYear		INT = 126001
		DECLARE	@nEventTypeTradingWindowOther	INT	= 126002
		DECLARE @nTradingWindowStatusActive		INT = 131002
	
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
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
			SELECT @inp_sSortField = 'rul.WindowOpenDate'
		END 
		
		IF @inp_sSortField = 'rul_grd_15382'
		BEGIN 
			SELECT @inp_sSortField = 'CEvent.CodeName'
		END 
		
		IF @inp_sSortField = 'rul_grd_15383'
		BEGIN 
			SELECT @inp_sSortField = 'CEvent.Description'
		END 
		
		IF @inp_sSortField = 'rul_grd_15384'
		BEGIN 
			SELECT @inp_sSortField = 'rul.WindowCloseDate'
		END 
		
		IF @inp_sSortField = 'rul_grd_15385'
		BEGIN 
			SELECT @inp_sSortField = 'rul.WindowOpenDate'
		END 
		
		
		SELECT @dtStartDateOfMonth = @dt_Month
		SELECT @dtEndDateOfMonth = DATEADD(D, -1, DATEADD(M, 1, @dtStartDateOfMonth))
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',rul.TradingWindowEventId),rul.TradingWindowEventId '
		SELECT @sSQL = @sSQL + ' FROM rul_TradingWindowEvent rul '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CEvent ON rul.TradingWindowEventCodeId = CEvent.CodeID  '
		SELECT @sSQL = @sSQL + ' LEFT JOIN vw_ApplicableTradingWindowEventOtherForUser vwTWE ON vwTWE.MapToId = rul.TradingWindowEventId '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '
		SELECT @sSQL = @sSQL + ' AND (rul.EventTypeCodeId = ' + CONVERT(VARCHAR,@nEventTypeFinancialYear) + 
								' OR (rul.EventTypeCodeId = ' + CONVERT(VARCHAR,@nEventTypeTradingWindowOther) + 
								' AND rul.TradingWindowStatusCodeId = ' + CONVERT(VARCHAR,@nTradingWindowStatusActive) + ')) '
		
		IF @dt_Month IS NOT NULL AND @dt_Month <> ''
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CAST(''' +CAST(@dtEndDateOfMonth  AS NVARCHAR(25))+ '''  AS  DATETIME)>= CAST(CAST(rul.WindowCloseDate AS VARCHAR(25)) AS DATETIME)'
			SELECT @sSQL = @sSQL + ' AND CAST(''' + CAST(@dtStartDateOfMonth  AS NVARCHAR(25))+ '''  AS  DATETIME)<= CAST(CAST(rul.WindowOpenDate AS VARCHAR(25))  AS DATETIME)'
		END
	
		IF(@inp_iUserInfoID IS NOT NULL AND @inp_iUserInfoID > 0)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (((ISNULL(' + CONVERT(VARCHAR(MAX),@inp_iUserInfoId) + ', 0) = 0 OR UserInfoId = ' + CONVERT(VARCHAR(MAX),@inp_iUserInfoId) + ') AND rul.EventTypeCodeId = ' + CONVERT(VARCHAR,@nEventTypeTradingWindowOther) + ' ) OR rul.EventTypeCodeId = ' + CONVERT(VARCHAR,@nEventTypeFinancialYear) + ' ) '
		END
		print @sSQL
		EXEC(@sSQL)
		
		SELECT  ISNULL(CEvent.CodeName, '-')		AS rul_grd_15382,
				CASE WHEN rul.EventTypeCodeId = 126001 THEN 'Financial Result Declaration' ELSE  ISNULL(CEvent.Description, '-') END AS rul_grd_15383,
				rul.WindowCloseDate				AS rul_grd_15384,
				rul.WindowOpenDate				AS rul_grd_15385
		FROM	#tmpList T INNER JOIN 
				rul_TradingWindowEvent rul ON T.EntityID = rul.TradingWindowEventId
				LEFT JOIN com_Code CEvent 
						  ON rul.TradingWindowEventCodeId = CEvent.CodeID
		WHERE	rul.TradingWindowEventId IS NOT NULL AND((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_GETEVENT_LIST
	END CATCH
END