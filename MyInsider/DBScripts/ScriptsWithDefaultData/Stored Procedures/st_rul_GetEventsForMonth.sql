IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_GetEventsForMonth')
DROP PROCEDURE [dbo].[st_rul_GetEventsForMonth]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get Blocked date of month.

Returns:		0, if Success.
				
Created by:		Swapnil M
Created on:		10-Apr-2015

Modification History:
Modified By		Modified On		Description
Tushar			03-Nov-2015		Trading Window Other event only activated event listed out.

Usage:
DECLARE @RC int
EXEC st_rul_GetEventsForMonth ,
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_GetEventsForMonth] 
	@dt_Month				DATETIME,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	
	BEGIN TRY
		DECLARE @dtEndDateOfMonth DATETIME
		DECLARE @dtStartDateOfMonth DATETIME
		DECLARE	@nEventTypeFinancialYear		INT = 126001
		DECLARE	@nEventTypeTradingWindowOther	INT	= 126002
		DECLARE @nTradingWindowStatusActive		INT = 131002
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;	
		
		SELECT @dtStartDateOfMonth = @dt_Month
		SELECT @dtEndDateOfMonth = DATEADD(D, -1, DATEADD(M, 1, @dtStartDateOfMonth))
		
		SELECT  ISNULL(CEvent.CodeName, '-')		AS EventName,
				ISNULL(CEvent.Description, '-')	AS EventDescription,
				rul.WindowCloseDate				AS WindowCloseDate,
				rul.WindowOpenDate				AS WindowOpenDate
		FROM	rul_TradingWindowEvent rul 
				LEFT JOIN com_Code CEvent 
						  ON rul.TradingWindowEventCodeId = CEvent.CodeID
		WHERE	@dtEndDateOfMonth >= convert(datetime, convert(varchar(11), rul.WindowCloseDate)) 
				AND @dtStartDateOfMonth <= convert(datetime, convert(varchar(11), rul.WindowOpenDate))
				AND (rul.EventTypeCodeId = @nEventTypeFinancialYear OR (rul.EventTypeCodeId = @nEventTypeTradingWindowOther AND rul.TradingWindowStatusCodeId = @nTradingWindowStatusActive))
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
	END CATCH
END