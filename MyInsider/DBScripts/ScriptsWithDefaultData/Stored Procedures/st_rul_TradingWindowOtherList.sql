IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingWindowOtherList')
DROP PROCEDURE [dbo].[st_rul_TradingWindowOtherList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list of trading window events of type other.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		22-Mar-2015

Modification History:
Modified By		Modified On		Description
Arundhati		26-Mar-2015		Conditions corrected.
Swapnil			20-Apr-2015		DisplayCode instead of CodeName for getting Trading Window Event Name.
Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rul_TradingWindowOtherList]
	@inp_iPageSize			INT = 10
	,@inp_iPageNo			INT = 1
	,@inp_sSortField		VARCHAR(255)
	,@inp_sSortOrder		VARCHAR(5)
	,@inp_iTradingWindowEventCodeId	INT
	,@inp_sTradingWindowId	VARCHAR(50)
	,@inp_dtWindowDateFrom	DATETIME
	,@inp_dtWindowDateTo	DATETIME
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_TRADINGWINDOWOTHER_LIST INT = 15015 -- Error occurred while fetching list of trading window events of type other.
	DECLARE @dtDefault DATETIME = CONVERT(DATETIME, '')
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		IF @inp_dtWindowDateFrom = @dtDefault
			SET @inp_dtWindowDateFrom = NULL
		
		IF @inp_dtWindowDateTo = @dtDefault
			SET @inp_dtWindowDateTo = NULL
		
			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'TWE.TradingWindowId '
		END 
		
		IF @inp_sSortField = 'rul_grd_15009' -- Trading Window ID
		BEGIN 
			SELECT @inp_sSortField = 'TWE.TradingWindowId ' 
		END 
		
		IF @inp_sSortField = 'rul_grd_15010' -- Trading Window Event
		BEGIN 
			SELECT @inp_sSortField = 'CdTWE.CodeName ' 
		END 
		
		IF @inp_sSortField = 'rul_grd_15011' -- Likely Declaration Date
		BEGIN 
			SELECT @inp_sSortField = 'TWE.ResultDeclarationDate ' 
		END 
		
		IF @inp_sSortField = 'rul_grd_15012' -- Window Closes On
		BEGIN 
			SELECT @inp_sSortField = 'TWE.WindowCloseDate ' 
		END 
		
		IF @inp_sSortField = 'rul_grd_15013' -- Window Opens On
		BEGIN 
			SELECT @inp_sSortField = 'TWE.WindowOpenDate ' 
		END 
		
		IF @inp_sSortField = 'rul_grd_15014' -- Status
		BEGIN 
			SELECT @inp_sSortField = 'CdTWEStatus.CodeName ' 
		END 
		
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',TWE.TradingWindowEventId),TWE.TradingWindowEventId '
		SELECT @sSQL = @sSQL + ' FROM rul_TradingWindowEvent TWE JOIN com_Code CdTWE ON  TWE.TradingWindowEventCodeId = CdTWE.CodeID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CdTWEStatus ON TWE.TradingWindowStatusCodeId = CdTWEStatus.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE EventTypeCodeId = 126002 '

		IF (@inp_iTradingWindowEventCodeId IS NOT NULL AND @inp_iTradingWindowEventCodeId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND TWE.TradingWindowEventCodeId = '+ CAST(@inp_iTradingWindowEventCodeId AS VARCHAR(20)) +' '
		END
		
		IF (@inp_sTradingWindowId IS NOT NULL AND @inp_sTradingWindowId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND TWE.TradingWindowId LIKE N''%' + @inp_sTradingWindowId + '%'' '
		END
		
		IF (@inp_dtWindowDateFrom IS NOT NULL OR @inp_dtWindowDateTo IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND ( '
			IF (@inp_dtWindowDateFrom IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' (TWE.WindowOpenDate >= CAST('''  + CAST(@inp_dtWindowDateFrom AS VARCHAR(23)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (TWE.WindowCloseDate IS NULL OR TWE.WindowCloseDate <= CAST('''  + CAST(@inp_dtWindowDateFrom AS VARCHAR(23)) + '''AS DATETIME)))'
			END
			
			IF (@inp_dtWindowDateFrom IS NOT NULL AND @inp_dtWindowDateTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' OR '
			END
			
			IF (@inp_dtWindowDateTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' (TWE.WindowOpenDate >= CAST('''  + CAST(@inp_dtWindowDateTo AS VARCHAR(23)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (TWE.WindowCloseDate IS NULL OR TWE.WindowCloseDate <= CAST('''  + CAST(@inp_dtWindowDateTo AS VARCHAR(23)) + ''' AS DATETIME)))'
			END
			
			IF (@inp_dtWindowDateFrom IS NOT NULL AND @inp_dtWindowDateTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' OR (''' + CAST(@inp_dtWindowDateFrom AS VARCHAR(23)) + ''' >= TWE.WindowOpenDate '
				SELECT @sSQL = @sSQL + ' AND (TWE.WindowCloseDate IS NULL OR CAST('''  + CAST(@inp_dtWindowDateTo AS VARCHAR(23)) + ''' AS DATETIME) <= TWE.WindowOpenDate ))'

				--SELECT @sSQL = @sSQL + ' OR (''' + CAST(@inp_dtWindowDateFrom AS VARCHAR(23)) + ''' <= TWE.WindowCloseDate '
				--SELECT @sSQL = @sSQL + ' AND (TWE.WindowCloseDate IS NULL OR '''  + CAST(@inp_dtWindowDateTo AS VARCHAR(23)) + ''' >= TWE.WindowCloseDate ))'
			END
			
			SELECT @sSQL = @sSQL + ' )'
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	TWE.TradingWindowEventId,
				TradingWindowId AS rul_grd_15009, -- Trading Window ID,
				CdTWE.DisplayCode AS rul_grd_15010, -- Trading Window Event,
				ResultDeclarationDate AS rul_grd_15011, -- Likely Declaration Date,
				WindowCloseDate AS rul_grd_15012, -- Window Closes On,
				WindowOpenDate AS rul_grd_15013, -- Window Opens On,
				CdTWEStatus.CodeName AS rul_grd_15014 -- Status
		FROM	#tmpList T INNER JOIN rul_TradingWindowEvent TWE ON T.EntityID = TWE.TradingWindowEventId
				JOIN com_Code CdTWE ON  TWE.TradingWindowEventCodeId = CdTWE.CodeID
				JOIN com_Code CdTWEStatus ON TWE.TradingWindowStatusCodeId = CdTWEStatus.CodeID
		WHERE	TWE.TradingWindowEventId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TRADINGWINDOWOTHER_LIST
	END CATCH
END
