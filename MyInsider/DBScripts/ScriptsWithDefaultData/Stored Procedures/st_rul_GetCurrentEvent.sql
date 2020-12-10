IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_GetCurrentEvent')
DROP PROCEDURE [dbo].[st_rul_GetCurrentEvent]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get Current Blocked date of month.

Returns:		0, if Success.
				
Created by:		Ashish Bhumkar
Created on:		10-July-2015

Modification History:
Modified By		Modified On		Description
Tushar			03-Nov-2015		Trading Window Other event only activated event listed out.
Tushar			17-Mar-2016		fetch current event by userinfoid if user is insider otherwise fetch current event
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_rul_GetCurrentEvent
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_GetCurrentEvent] 
	@inp_nUserInfoID		INT = 0,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN	
	BEGIN TRY
	
		DECLARE @dtTodayDate					DATETIME = dbo.uf_com_GetServerDate()
		DECLARE	@nEventTypeFinancialYear		INT = 126001
		DECLARE	@nEventTypeTradingWindowOther	INT	= 126002
		DECLARE @nTradingWindowStatusActive		INT = 131002
		
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;	
		
		IF EXISTS(SELECT TradingWindowEventId FROM rul_TradingWindowEvent rul 
				  LEFT JOIN com_Code CEvent ON rul.TradingWindowEventCodeId = CEvent.CodeID 
				  LEFT JOIN vw_ApplicableTradingWindowEventOtherForUser vwTWE ON vwTWE.MapToId = rul.TradingWindowEventId
				  WHERE	@dtTodayDate >= rul.WindowCloseDate
				AND @dtTodayDate <= rul.WindowOpenDate
				AND (rul.EventTypeCodeId = @nEventTypeFinancialYear OR (rul.EventTypeCodeId = @nEventTypeTradingWindowOther AND rul.TradingWindowStatusCodeId = @nTradingWindowStatusActive))
				AND (((ISNULL(@inp_nUserInfoID,0) = 0 OR UserInfoId = @inp_nUserInfoID) AND rul.EventTypeCodeId = 126002) OR rul.EventTypeCodeId = 126001)
				) 
		BEGIN
			SELECT  TOP 1 rul.WindowCloseDate AS WindowCloseDate,
					rul.WindowOpenDate AS WindowOpenDate
			FROM	rul_TradingWindowEvent rul 
			LEFT JOIN com_Code CEvent ON rul.TradingWindowEventCodeId = CEvent.CodeID
			 LEFT JOIN vw_ApplicableTradingWindowEventOtherForUser vwTWE ON vwTWE.MapToId = rul.TradingWindowEventId
			WHERE	@dtTodayDate >= rul.WindowCloseDate
					AND @dtTodayDate <= rul.WindowOpenDate
					AND (rul.EventTypeCodeId = @nEventTypeFinancialYear OR (rul.EventTypeCodeId = @nEventTypeTradingWindowOther AND rul.TradingWindowStatusCodeId = @nTradingWindowStatusActive))
					AND (((ISNULL(@inp_nUserInfoID,0) = 0 OR UserInfoId = @inp_nUserInfoID) AND rul.EventTypeCodeId = 126002) OR rul.EventTypeCodeId = 126001)
			ORDER BY rul.WindowCloseDate ASC
		END
		ELSE IF EXISTS(SELECT TradingWindowEventId FROM rul_TradingWindowEvent rul 
						LEFT JOIN com_Code CEvent 
						  ON rul.TradingWindowEventCodeId = CEvent.CodeID 
						   LEFT JOIN vw_ApplicableTradingWindowEventOtherForUser vwTWE ON vwTWE.MapToId = rul.TradingWindowEventId
						  WHERE	@dtTodayDate <= rul.WindowOpenDate
						  AND (rul.EventTypeCodeId = @nEventTypeFinancialYear OR (rul.EventTypeCodeId = @nEventTypeTradingWindowOther AND rul.TradingWindowStatusCodeId = @nTradingWindowStatusActive))
						  AND (((ISNULL(@inp_nUserInfoID,0) = 0 OR UserInfoId = @inp_nUserInfoID) AND rul.EventTypeCodeId = 126002) OR rul.EventTypeCodeId = 126001)
						  )
		BEGIN 
			SELECT  TOP 1 rul.WindowCloseDate AS WindowCloseDate,
					rul.WindowOpenDate AS WindowOpenDate
			FROM	rul_TradingWindowEvent rul 
					LEFT JOIN com_Code CEvent 
							  ON rul.TradingWindowEventCodeId = CEvent.CodeID
					 LEFT JOIN vw_ApplicableTradingWindowEventOtherForUser vwTWE ON vwTWE.MapToId = rul.TradingWindowEventId
			WHERE @dtTodayDate <= rul.WindowOpenDate
			AND (rul.EventTypeCodeId = @nEventTypeFinancialYear OR (rul.EventTypeCodeId = @nEventTypeTradingWindowOther AND rul.TradingWindowStatusCodeId = @nTradingWindowStatusActive))
			AND (((ISNULL(@inp_nUserInfoID,0) = 0 OR UserInfoId = @inp_nUserInfoID) AND rul.EventTypeCodeId = 126002) OR rul.EventTypeCodeId = 126001)
			ORDER BY rul.WindowCloseDate ASC
		END
		ELSE
		BEGIN
			SELECT null AS WindowCloseDate, null AS WindowOpenDate
		END
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
	END CATCH
END