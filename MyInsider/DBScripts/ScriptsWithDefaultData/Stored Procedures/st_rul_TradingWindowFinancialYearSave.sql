IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingWindowFinancialYearSave')
DROP PROCEDURE [dbo].[st_rul_TradingWindowFinancialYearSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves and Update the Trading Window Financial year Event details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		19-Mar-2015
Modification History:
Modified By		Modified On		Description
Gaurishankar	02-Apr-2015		Changes for Year Validation and delete Old records
Arundhati		31-Oct-2015		Codes (dates) for Period end date are changed. Now that are stored as the 1st of next month.
Gaurishankar	09-Jan-2015		Update the parent code id of the Financial Year.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_rul_TradingWindowFinancialYearSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_TradingWindowFinancialYearSave] 
	@inp_tblTradingWindowEventType DBO.TradingWindowEventType READONLY,
	@inp_iFinancialPeriodTypeCodeId int,
	@inp_iLoggedInUserId	INT,									-- Id of the user inserting/updating the TradingWindowEvent
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TRADINGWINDOWEVENT_SAVE INT
	DECLARE @ERR_TRADINGWINDOWEVENT_NOTFOUND INT
	DECLARE @nFinancialYearCodeId INT
	DECLARE @nFinancialPeriodCodeId INT
	DECLARE @FINANCIALRESULCODEID INT = 126001
	DECLARE @dtResultDeclarationDate Datetime
	DECLARE @sYear VARCHAR(10), @nYear int,
			@dtFinancialYearStartDate Datetime , @dtFinancialYearEndDate Datetime
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

		--Initialize variables
		SELECT @ERR_TRADINGWINDOWEVENT_NOTFOUND = 15017, -- Not added in resource
				@ERR_TRADINGWINDOWEVENT_SAVE = 15018 -- Not added in resource
				
		SELECT TOP 1 @nFinancialYearCodeId = FinancialYearCodeId ,@nFinancialPeriodCodeId = FinancialPeriodCodeId FROM @inp_tblTradingWindowEventType 
		SELECT @dtResultDeclarationDate = MIN(ResultDeclarationDate) FROM [rul_TradingWindowEvent] where  FinancialYearCodeId = @nFinancialYearCodeId
		-- Get year from from Financial Year
		SELECT @sYear = Description FROM com_Code WHERE CodeId = @nFinancialYearCodeId
		SELECT @nYear = SUBSTRING(@sYear, 1, 4)
		--SELECT @dtFinancialYearStartDate = CONVERT(DATETIME, DATEADD(YEAR, (@nYear-1970), CONVERT(DATETIME, '01-Apr-1970'))),
		--	@dtFinancialYearEndDate = CONVERT(DATETIME, DATEADD(YEAR, (@nYear-1970), CONVERT(DATETIME, '31-Mar-1971')))
		SELECT @dtFinancialYearEndDate = DATEADD(DAY, -1, DATEADD(YEAR, @nYear - 1970, Description)) FROM com_Code where CodeId = 124001
		SELECT @dtFinancialYearStartDate = DATEADD(YEAR, -1, DATEADD(D, 1, @dtFinancialYearEndDate)) --FROM com_Code where CodeId = 124001
			
		IF(@dtFinancialYearEndDate < dbo.uf_com_GetServerDate())
		BEGIN
			SET @out_nReturnValue = @ERR_TRADINGWINDOWEVENT_SAVE
			RETURN @ERR_TRADINGWINDOWEVENT_SAVE
		END
		UPDATE com_Code SET ParentCodeId = @inp_iFinancialPeriodTypeCodeId
			WHERE CodeID = @nFinancialYearCodeId
		
		IF ( (dbo.uf_com_GetServerDate() < @dtFinancialYearStartDate) AND (EXISTS(SELECT CodeId FROM com_Code WHERE ParentCodeId != @inp_iFinancialPeriodTypeCodeId AND CodeID = @nFinancialYearCodeId)))
		BEGIN
			--UPDATE com_Code SET ParentCodeId = @inp_iFinancialPeriodTypeCodeId
			--WHERE CodeID = @nFinancialYearCodeId
			
			DELETE TWE 
			FROM rul_TradingWindowEvent TWE
			JOIN @inp_tblTradingWindowEventType TWET ON TWE.FinancialYearCodeId = TWET.FinancialYearCodeId
			WHERE TWE.EventTypeCodeId = @FINANCIALRESULCODEID			
			
		END
		
		IF EXISTS(SELECT  TWE.TradingWindowEventId FROM @inp_tblTradingWindowEventType TWET
							INNER JOIN rul_TradingWindowEvent TWE ON TWE.FinancialYearCodeId = TWET.FinancialYearCodeId
					WHERE	TWET.TradingWindowEventId IS NULL OR TWET.TradingWindowEventId = 0
		)
		BEGIN
			SET @out_nReturnValue = @ERR_TRADINGWINDOWEVENT_SAVE
			RETURN @ERR_TRADINGWINDOWEVENT_SAVE
		END
		IF EXISTS(SELECT  TWE.TradingWindowEventId FROM @inp_tblTradingWindowEventType TWET
							INNER JOIN rul_TradingWindowEvent TWE ON TWE.FinancialYearCodeId = TWET.FinancialYearCodeId
							AND (TWET.TradingWindowEventId IS NULL OR TWET.TradingWindowEventId = 0 OR TWET.TradingWindowEventId = TWE.TradingWindowEventId)
							WHERE TWE.FinancialPeriodCodeId != TWET.FinancialPeriodCodeId
		)
		BEGIN
			SET @out_nReturnValue = @ERR_TRADINGWINDOWEVENT_SAVE
			RETURN @ERR_TRADINGWINDOWEVENT_SAVE
		END
		--Save the TradingWindowEvent details
		IF (EXISTS(SELECT  TradingWindowEventId FROM @inp_tblTradingWindowEventType 
						WHERE	TradingWindowEventId IS NULL OR TradingWindowEventId = 0))
		BEGIN
			Insert into rul_TradingWindowEvent(
					FinancialYearCodeId,
					FinancialPeriodCodeId,
					TradingWindowId,
					EventTypeCodeId,
					ResultDeclarationDate,
					WindowCloseDate,
					WindowOpenDate,
					DaysPriorToResultDeclaration,
					DaysPostResultDeclaration,
					CreatedBy, CreatedOn, ModifiedBy,	ModifiedOn )
					SELECT	FinancialYearCodeId			
							,FinancialPeriodCodeId			
							,TradingWindowId				
							,@FINANCIALRESULCODEID
							,ResultDeclarationDate			
							,WindowCloseDate				
							,WindowOpenDate					
							,DaysPriorToResultDeclaration	
							,DaysPostResultDeclaration
							,@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate()
					FROM	@inp_tblTradingWindowEventType TWET
					WHERE	TradingWindowEventId IS NULL OR TradingWindowEventId = 0
			
		END
		--Check if the TradingWindowEvent whose details are being updated exists
		IF ( EXISTS(SELECT  TWE.TradingWindowEventId 
						FROM @inp_tblTradingWindowEventType TWET
						INNER JOIN rul_TradingWindowEvent TWE 
											ON	TWE.TradingWindowEventId = TWET.TradingWindowEventId 
												AND TWET.TradingWindowEventId IS NOT NULL 
												AND TWET.TradingWindowEventId <> 0
						)
			)
		BEGIN	
			Update TWE
			Set 	
					TradingWindowId = TWET.TradingWindowId,
					ResultDeclarationDate = TWET.ResultDeclarationDate,
					WindowCloseDate = TWET.WindowCloseDate,
					WindowOpenDate = TWET.WindowOpenDate,
					DaysPriorToResultDeclaration = TWET.DaysPriorToResultDeclaration,
					DaysPostResultDeclaration = TWET.DaysPostResultDeclaration,
					ModifiedBy	= @inp_iLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()
				FROM rul_TradingWindowEvent TWE
				INNER JOIN @inp_tblTradingWindowEventType TWET 
												ON	TWE.TradingWindowEventId = TWET.TradingWindowEventId 
												AND TWE.FinancialYearCodeId = TWET.FinancialYearCodeId
												AND TWE.FinancialPeriodCodeId = TWET.FinancialPeriodCodeId
												AND TWET.TradingWindowEventId IS NOT NULL 
												AND TWET.TradingWindowEventId <> 0
		END	

		
		-- in case required to return for partial save case.
		Select TradingWindowEventId, FinancialYearCodeId, FinancialPeriodCodeId, TradingWindowId, 
		EventTypeCodeId, TradingWindowEventCodeId, ResultDeclarationDate, 
		WindowCloseDate, WindowOpenDate, DaysPriorToResultDeclaration, DaysPostResultDeclaration, 
		WindowClosesBeforeHours, WindowClosesBeforeMinutes, WindowOpensAfterHours, WindowOpensAfterMinutes
			From @inp_tblTradingWindowEventType
			--WHERE FinancialYearCodeId = @nFinancialYearCodeId
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_TRADINGWINDOWEVENT_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END