IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingWindowEventOtherSave')
DROP PROCEDURE [dbo].[st_rul_TradingWindowEventOtherSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves and Update the Trading Window Financial year Event details

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		23-Mar-2015
Modification History:
Modified By		Modified On		Description
Swapnil			20-apr-2015		added method for geerating tradingWindowID
Swapnil			06-Jun-2015		Change in method while generating tradingWindowID.
Amar            12-Jun-2015     Added check for EventTypeCodeId while generating @sTradingWindowId during insert 
Tushar			04-Nov-2015		Change related to the activate status shown and save from page.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_rul_TradingWindowFinancialYearSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_TradingWindowEventOtherSave] 
	@inp_iTradingWindowEventId		INT,
	@inp_sTradingWindowId			VARCHAR(50),
	@inp_iTradingWindowEventCodeId	INT,
	@inp_dtResultDeclarationDate	DATETIME,
	@inp_dtWindowCloseDate			DATETIME,
	@inp_dtWindowOpenDate			DATETIME,
	@inp_iDaysPriorToResultDeclaration	INT,
	@inp_iWindowClosesBeforeHours	INT,
	@inp_iWindowClosesBeforeMinutes	INT,	
	@inp_iDaysPostResultDeclaration	INT,
	@inp_iWindowOpensAfterHours		INT,
	@inp_iWindowOpensAfterMinutes	INT,
	@inp_iTradingWindowStatusCodeId	INT,
	@inp_iLoggedInUserId	INT,									-- Id of the user inserting/updating the TradingWindowEvent
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TRADINGWINDOWEVENT_SAVE INT = 15016
	DECLARE @ERR_TRADINGWINDOWEVENT_NOTFOUND INT = 15017
	DECLARE @TRADINGWINDOWEVENTTYPE_OTHER INT = 126002
	DECLARE @sTradingWindowId NVARCHAR(100)
	DECLARE @ERR_WINDOWOPENDATE_GREATERTHANTODAYDATE	INT
	
	SET @ERR_WINDOWOPENDATE_GREATERTHANTODAYDATE = 15434		

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''	
		
		DECLARE @dtCurrentDate DATETIME = dbo.uf_com_GetServerDate()
			IF(@inp_dtWindowOpenDate <= @dtCurrentDate)
			BEGIN
			SET @out_nReturnValue = @ERR_WINDOWOPENDATE_GREATERTHANTODAYDATE 
				RETURN @out_nReturnValue
			END
		
		--Save the TradingWindowEvent details
		IF (@inp_iTradingWindowEventId = 0)
		BEGIN
		
			SELECT	@sTradingWindowId = convert(NVARCHAR(10),MAX(twe.TradingWindowId)) 
			FROM	rul_TradingWindowEvent twe 
			WHERE   CONVERT(INT,YEAR(CreatedOn)) = CONVERT(INT,YEAR(@inp_dtResultDeclarationDate))
			and EventTypeCodeId = @TRADINGWINDOWEVENTTYPE_OTHER
				   
			IF(@sTradingWindowId IS NULL)
			BEGIN
				SET @sTradingWindowId = CONVERT(VARCHAR(10), YEAR(@inp_dtResultDeclarationDate)) + '001'
			END
			ELSE
			BEGIN
				SET @sTradingWindowId  = CONVERT(INT,@sTradingWindowId) + 1
			END
	
			INSERT INTO rul_TradingWindowEvent
				(TradingWindowId, EventTypeCodeId, TradingWindowEventCodeId, ResultDeclarationDate, WindowCloseDate, WindowOpenDate,
				DaysPriorToResultDeclaration, DaysPostResultDeclaration, WindowClosesBeforeHours, WindowClosesBeforeMinutes,
				WindowOpensAfterHours, WindowOpensAfterMinutes, TradingWindowStatusCodeId,
				CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
			VALUES
				(@sTradingWindowId, @TRADINGWINDOWEVENTTYPE_OTHER, @inp_iTradingWindowEventCodeId, @inp_dtResultDeclarationDate, @inp_dtWindowCloseDate,
				@inp_dtWindowOpenDate, @inp_iDaysPriorToResultDeclaration, @inp_iDaysPostResultDeclaration, @inp_iWindowClosesBeforeHours, @inp_iWindowClosesBeforeMinutes,
				@inp_iWindowOpensAfterHours, @inp_iWindowOpensAfterMinutes, @inp_iTradingWindowStatusCodeId,
				@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate())
			
			SET @inp_iTradingWindowEventId = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN	

			--Check if the TradingWindowEvent whose details are being updated exists
			IF (NOT EXISTS(SELECT TradingWindowEventId FROM rul_TradingWindowEvent WHERE EventTypeCodeId = @TRADINGWINDOWEVENTTYPE_OTHER))
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGWINDOWEVENT_NOTFOUND
				RETURN @out_nReturnValue
			END
			
			
			
			--@inp_iWindowOpensAfterHours,@inp_iWindowOpensAfterMinutes
			
			
			
			UPDATE rul_TradingWindowEvent
			SET 	
					TradingWindowId = @inp_sTradingWindowId,
					TradingWindowEventCodeId = @inp_iTradingWindowEventCodeId,
					ResultDeclarationDate = @inp_dtResultDeclarationDate,					
					WindowCloseDate = @inp_dtWindowCloseDate,
					WindowOpenDate = @inp_dtWindowOpenDate,
					DaysPriorToResultDeclaration = @inp_iDaysPriorToResultDeclaration,
					DaysPostResultDeclaration = @inp_iDaysPostResultDeclaration,
					WindowClosesBeforeHours = @inp_iWindowClosesBeforeHours,
					WindowClosesBeforeMinutes = @inp_iWindowClosesBeforeMinutes,
					WindowOpensAfterHours = @inp_iWindowOpensAfterHours,
					WindowOpensAfterMinutes = @inp_iWindowOpensAfterMinutes,
					TradingWindowStatusCodeId = @inp_iTradingWindowStatusCodeId,
					ModifiedBy	= @inp_iLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE TradingWindowEventId = @inp_iTradingWindowEventId

		END	
		
		-- in case required to return for partial save case.
		Select TradingWindowEventId, TradingWindowId, EventTypeCodeId, TradingWindowEventCodeId, ResultDeclarationDate, WindowCloseDate, WindowOpenDate,
				DaysPriorToResultDeclaration, DaysPostResultDeclaration, WindowClosesBeforeHours, WindowClosesBeforeMinutes,
				WindowOpensAfterHours, WindowOpensAfterMinutes, TradingWindowStatusCodeId
		From rul_TradingWindowEvent
		WHERE TradingWindowEventId = @inp_iTradingWindowEventId
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_TRADINGWINDOWEVENT_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END