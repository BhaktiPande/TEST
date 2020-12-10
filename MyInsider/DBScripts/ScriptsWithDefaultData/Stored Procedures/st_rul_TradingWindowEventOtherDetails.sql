IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingWindowEventOtherDetails')
DROP PROCEDURE [dbo].[st_rul_TradingWindowEventOtherDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the TradingWindowEvent details

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		25-Mar-2015

Modification History:
Modified By		Modified On		Description
Swapnil			20-apr-2015		Added if-else for getting tradingWindowID
Swapnil			20-apr-2015		Removed if-else for getting tradingWindowID
Tushar			04-Nov-2015		Change related to the activate status shown and save from page.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_rul_TradingWindowEventOtherDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_TradingWindowEventOtherDetails]
	@inp_iTradingWindowEventId		INT,						-- Id of the TradingWindowEvent whose details are to be fetched.	
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TRADINGWINDOWEVENTOTHER_NOTFOUND		INT
	DECLARE @ERR_TRADINGWINDOWEVENTOTHER_GETDETAILS		INT

	DECLARE @sTradingWindowId NVARCHAR(100)
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		--Initialize variables
		SELECT	@ERR_TRADINGWINDOWEVENTOTHER_NOTFOUND = 15017,
				@ERR_TRADINGWINDOWEVENTOTHER_GETDETAILS = 15029
				
			
		--Check if the TradingWindowEvent whose details are being fetched exists
			IF (NOT EXISTS(SELECT TradingWindowEventId FROM rul_TradingWindowEvent WHERE TradingWindowEventId = @inp_iTradingWindowEventId))
			BEGIN	
					SET @out_nReturnValue = @ERR_TRADINGWINDOWEVENTOTHER_NOTFOUND
					RETURN (@out_nReturnValue)
			END		
			
			--Fetch the TradingWindowEvent details
			SELECT	
					DATEDIFF(DAY,WindowCloseDate,dbo.uf_com_GetServerDate()),
					TradingWindowEventId, 
					TradingWindowId,
					TradingWindowEventCodeId, 
					ResultDeclarationDate, 
					WindowCloseDate, 
					WindowOpenDate, 
					DaysPriorToResultDeclaration, 
					DaysPostResultDeclaration, 
					WindowClosesBeforeHours, 
					WindowClosesBeforeMinutes, 
					WindowOpensAfterHours, 
					WindowOpensAfterMinutes, 
					TradingWindowStatusCodeId,
					CASE WHEN DATEDIFF(DAY,WindowCloseDate,dbo.uf_com_GetServerDate())<= 0 THEN 1 ELSE 0 END AS ISEditWindow,
					CASE WHEN DATEDIFF(DAY,WindowOpenDate,dbo.uf_com_GetServerDate())<= 0 THEN 1 ELSE 0 END AS ISEditWindowOpenPart
			FROM	rul_TradingWindowEvent
			WHERE	TradingWindowEventId = @inp_iTradingWindowEventId	
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRADINGWINDOWEVENTOTHER_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

