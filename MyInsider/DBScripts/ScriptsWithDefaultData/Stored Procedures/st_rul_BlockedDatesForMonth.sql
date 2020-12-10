IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_BlockedDatesForMonth')
DROP PROCEDURE [dbo].[st_rul_BlockedDatesForMonth]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get Blocked date of month.

Returns:		0, if Success.
				
Created by:		Swapnil M
Created on:		07-Apr-2015

Modification History:
Modified By		Modified On		Description
Arundhati		23-Jul-2015		Changes made for userwise blocked events
Tushar			03-Nov-2015		Trading Window Other event only activated event listed out.

Usage:
DECLARE @RC int
EXEC st_rul_BlockedDatesForMonth ,
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_BlockedDatesForMonth] 
	@dt_Month				DATETIME,
	@inp_nUserInfoId		INT,	-- 0: if UserTypeCodeId is For admin/CO. For Employee, Non-Employee, Corporate user actual id of logged in user
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @ERR_BLOCKEDDATES_LIST INT = 15343
	
	BEGIN TRY
		DECLARE @dtEndDateOfMonth				DATETIME
		DECLARE @dtStartDateOfMonth				DATETIME
		DECLARE	@nEventTypeFinancialYear		INT = 126001
		DECLARE	@nEventTypeTradingWindowOther	INT	= 126002
		DECLARE @nTradingWindowStatusActive		INT = 131002
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;	
		
		SELECT @dtStartDateOfMonth = @dt_Month		
		--DECLARE @TmpTable TABLE(DayOfSelectedMonth DATETIME, IsBlocked INT DEFAULT 0,DayCount INT)
		DECLARE @TmpTable TABLE(DayOfSelectedMonth DATETIME, IsBlocked INT DEFAULT 0, DayCount INT, TradingWindowEventId INT, EventName NVARCHAR(512), EventDescription NVARCHAR(255), WindowCloseDate DATETIME, WindowOpenDate DATETIME)

		DECLARE @dtTemp DATETIME = @dt_Month
		Declare @iDayCount INT = 1			
		SELECT @dtEndDateOfMonth = DATEADD(D, -1, DATEADD(M, 1, @dtStartDateOfMonth))
		
		WHILE @dtTemp <= @dtEndDateOfMonth
		BEGIN
			INSERT INTO @TmpTable(DayOfSelectedMonth,DayCount) VALUES(@dtTemp,@iDayCount)
			SET @dtTemp = DATEADD(D, 1, @dtTemp)
			SET @iDayCount = @iDayCount + 1
		END
		
		UPDATE tmp
		SET IsBlocked = 1,
			TradingWindowEventId = rul.TradingWindowEventId
		FROM @TmpTable tmp JOIN rul_TradingWindowEvent rul ON 1 = 1
		WHERE @dtEndDateOfMonth >= rul.WindowCloseDate AND @dtStartDateOfMonth <= rul.WindowOpenDate
			AND convert(datetime, convert(varchar(11), rul.WindowCloseDate)) <= DayOfSelectedMonth AND convert(datetime, convert(varchar(11), rul.WindowOpenDate)) > DayOfSelectedMonth
			AND (ISNULL(@inp_nUserInfoId, 0) = 0 OR EventTypeCodeId = 126001)
			AND (rul.EventTypeCodeId = @nEventTypeFinancialYear OR (rul.EventTypeCodeId = @nEventTypeTradingWindowOther AND rul.TradingWindowStatusCodeId = @nTradingWindowStatusActive))

		-- BLock other events as per applicability
		UPDATE tmp
		SET IsBlocked = 1,
		TradingWindowEventId = rul.TradingWindowEventId
		FROM @TmpTable tmp JOIN rul_TradingWindowEvent rul ON 1 = 1
			JOIN vw_ApplicableTradingWindowEventOtherForUser vwTWE ON vwTWE.MapToId = rul.TradingWindowEventId		
		WHERE @dtEndDateOfMonth >= rul.WindowCloseDate AND @dtStartDateOfMonth <= rul.WindowOpenDate
			AND convert(datetime, convert(varchar(11), rul.WindowCloseDate)) <= DayOfSelectedMonth AND convert(datetime, convert(varchar(11), rul.WindowOpenDate)) > DayOfSelectedMonth
			AND EventTypeCodeId = 126002
			AND (ISNULL(@inp_nUserInfoId, 0) = 0 OR UserInfoId = @inp_nUserInfoId)
			AND (rul.EventTypeCodeId = @nEventTypeFinancialYear OR (rul.EventTypeCodeId = @nEventTypeTradingWindowOther AND rul.TradingWindowStatusCodeId = @nTradingWindowStatusActive))

		UPDATE tmp
		SET EventName = ISNULL(CEvent.CodeName, ''),
			EventDescription = ISNULL(CEvent.Description, ''),
			WindowCloseDate = rul.WindowCloseDate,
			WindowOpenDate = rul.WindowOpenDate
		FROM @TmpTable tmp JOIN rul_TradingWindowEvent rul ON tmp.TradingWindowEventId = rul.TradingWindowEventId
		LEFT JOIN com_Code CEvent ON rul.TradingWindowEventCodeId = CEvent.CodeID
		AND (rul.EventTypeCodeId = @nEventTypeFinancialYear OR (rul.EventTypeCodeId = @nEventTypeTradingWindowOther AND rul.TradingWindowStatusCodeId = @nTradingWindowStatusActive))

		SELECT IsBlocked,DayCount,TradingWindowEventId,EventName,EventDescription,WindowCloseDate,WindowOpenDate
		FROM @TmpTable

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()

		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_BLOCKEDDATES_LIST, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
GO


