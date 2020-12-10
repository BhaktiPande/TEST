IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingWindowEventOtherDelete')
DROP PROCEDURE [dbo].[st_rul_TradingWindowEventOtherDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Deletes the TradingWindowEvent

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		25-Mar-2015

Modification History:
Modified By		Modified On	Description


Usage:
DECLARE @RC int
EXEC st_rul_TradingWindowEventOtherDelete 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_TradingWindowEventOtherDelete]
	-- Add the parameters for the stored procedure here
	@inp_iTradingWindowEventId  INT,						-- Id of the TradingWindowEvent to be deleted
	@inp_nUserId				INT ,						-- Id Used while updating audit table befoe deleting.	
	@out_nReturnValue			INT = 0 OUTPUT,		
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_TRADINGWINDOWEVENTOTHER_NOTFOUND INT,
			@ERR_TRADINGWINDOWEVENTOTHER_DELETE INT

	BEGIN TRY

		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_TRADINGWINDOWEVENTOTHER_NOTFOUND = 15017,
				@ERR_TRADINGWINDOWEVENTOTHER_DELETE = 15028
	
		--Check if the TradingWindowEvent being deleted exists
		IF (NOT EXISTS(SELECT TradingWindowEventId FROM rul_TradingWindowEvent WHERE TradingWindowEventId = @inp_iTradingWindowEventId))
		BEGIN	
			SET @out_nReturnValue = @ERR_TRADINGWINDOWEVENTOTHER_NOTFOUND
			RETURN @out_nReturnValue
		END

		DELETE FROM rul_TradingWindowEvent
		WHERE TradingWindowEventId = @inp_iTradingWindowEventId

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_TRADINGWINDOWEVENTOTHER_DELETE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
