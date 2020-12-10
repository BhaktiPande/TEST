IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_GetFutureBlockEvent')
DROP PROCEDURE [dbo].[st_rul_GetFutureBlockEvent]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get Future Blocked event.

Returns:		0, if Success.
				
Created by:		Tushar
Created on:		08-Jul-2015

Modification History:
Modified By		Modified On		Description
Tushar			03-Nov-2015		Trading Window Other event only activated event listed out.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_GetFutureBlockEvent] 
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	
	BEGIN TRY
		DECLARE	@dtEndDateOfMonth				DATETIME
		DECLARE	@dtStartDateOfMonth				DATETIME
		DECLARE	@nEventTypeFinancialYear		INT = 126001
		DECLARE	@nEventTypeTradingWindowOther	INT	= 126002
		DECLARE @nTradingWindowStatusActive		INT = 131002
		
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;	
		
		SELECT  rul.TradingWindowId,
				rul.WindowCloseDate				AS WindowCloseDate,
				(rul.WindowOpenDate-1)				AS WindowOpenDate
		FROM	rul_TradingWindowEvent rul 
				LEFT JOIN com_Code CEvent 
						  ON rul.TradingWindowEventCodeId = CEvent.CodeID
		WHERE	dbo.uf_com_GetServerDate() <= CONVERT(DATETIME, CONVERT(VARCHAR(11), rul.WindowCloseDate)) 
		AND DATEDIFF(DAY,dbo.uf_com_GetServerDate(),rul.WindowCloseDate) <= 10
		AND (rul.EventTypeCodeId = @nEventTypeFinancialYear 
			 OR (rul.EventTypeCodeId = @nEventTypeTradingWindowOther AND rul.TradingWindowStatusCodeId = @nTradingWindowStatusActive))
		ORDER BY WindowCloseDate

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
	END CATCH
END