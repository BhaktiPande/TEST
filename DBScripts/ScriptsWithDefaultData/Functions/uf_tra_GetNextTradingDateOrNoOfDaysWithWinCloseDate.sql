IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate')
	DROP FUNCTION uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate
GO

/*-------------------------------------------------------------------------------------------------
Description:	This routine calculate next trading date and no of trading days  
				And return date or no of days for trading - as varchar - which need to be type cast for use 
				
Created by:		Parag
Created on:		21-Jan-2016

Modification History:
Modified By		Modified On		Description
Parag			27-Jan-2016		Made change to calculate past dates base on flag

Usage :
--Following include "Form Date" in calucation
select dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(CONVERT(date, '2016-01-21'), null, CONVERT(date, '2016-01-29'), 1, 0, 0, 116001) -- return date
select dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(CONVERT(date, '2016-01-21'), 8, null, 1, 1, 0, 116001) -- return no of days

--Following exclude "From Date" in calculation
select dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(CONVERT(date, '2016-01-21'), null, CONVERT(date, '2016-01-29'), 0, 0, 0, 116001) -- return date
select dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(CONVERT(date, '2016-01-21'), 8, null, 0, 1, 0, 116001) -- return no of days

--NOTE: Holidays will be stored in table and we have configuration at implementing company that use calendar days or trading days 
--------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate]
(	
	@inp_dtFromDate			DATETIME,			-- date from which no of days to be caluculated
	@inp_nTradingDays		INT = NULL,			-- no of trading days to calculate, next trading date
	@inp_dtToDate			DATETIME = NULL,	-- date upto which no of days to be calculated
	@inp_bIncludeFromDate	BIT = 0,			-- flag to indicate if include from date into calculation - 1: include from Date, 0: exclude from date
	@inp_bRetOutDate		BIT = 1,			-- flag to indicate output as date or no of days - 1: Date 0: no of days 
	@inp_bCalcuatePastdate	BIT = 0,			-- flag to indicate if calcuate date after from date or prior (mostly used in trading window - not implemetned yet)
	@inp_nExchangeCodeId	INT = 116001,		-- Default exchange code (NOTE - currently exchange type will not be pass, this will be used in future)
	@inp_EventType			INT = NULL,	-- 126001-Trading Window Event Type - Financial Result,126002- Other
	@inp_WindowCloseDate    DATETIME = NULL
)
RETURNS VARCHAR(15) AS  
BEGIN
	DECLARE @sRetOutput VARCHAR(15)
	DECLARE @dtRetDate DATE
	DECLARE @nRetNoOfDays INT
	
	DECLARE @nTradingDaysCountType INT
	DECLARE @nDaysCount_TradingDays INT = 174001 
	DECLARE @nDaysCount_CalendarDays INT = 174002
	
	DECLARE @nBufferDays INT = CASE 
								WHEN @inp_nTradingDays IS NULL THEN 0 
								WHEN @inp_nTradingDays IS NOT NULL AND @inp_nTradingDays < 15 THEN 30 
								ELSE @inp_nTradingDays * 2 
								END
	DECLARE @dtNextDate DATETIME
	
	DECLARE @dtFrmDate	DATETIME = CONVERT(date, @inp_dtFromDate)
	DECLARE @dtToDate	DATETIME 
	DECLARE @dtTempToDate DATETIME
	
	DECLARE @nNonTradingDaysCount INT
	DECLARE @nTradingDaysCount INT
	
	DECLARE @TradingWindowEventTypeFinancialYear INT = 126001
	DECLARE @TradingWindowEventTypeOther INT = 126002
	DECLARE @nWindowOpenDaysCount INT
	DECLARE @FinalDate DATETIME=NULL
	-- get code from company table to check if company need to use trading days only or all days for trading
	SELECT @nTradingDaysCountType = TradingDaysCountType FROM mst_Company WHERE IsImplementing = 1
	
	-- Check if calculate date from trading date or from "to date"
	IF (@inp_nTradingDays IS NOT NULL)
	BEGIN
		SET @nTradingDaysCount = @inp_nTradingDays
		
		-- check if trading days count type 
		IF (@nTradingDaysCountType = @nDaysCount_TradingDays)
		BEGIN
			-- check if calculate past date or future date
			IF (@inp_bCalcuatePastdate = 1)
			BEGIN
				SET @dtTempToDate = @dtFrmDate
				SET @dtFrmDate = DATEADD(DAY, (@inp_nTradingDays+@nBufferDays)*-1, @dtFrmDate)
				
				-- check if from date is included or not
				-- if not included then consider from date from next day
				IF (@inp_bIncludeFromDate = 0)
				BEGIN
					SET @dtTempToDate = DATEADD(DAY, -1, @dtTempToDate)
				END
			END
			ELSE 
			BEGIN
				-- check if from date is included or not
				-- if not included then consider from date from next day
				IF (@inp_bIncludeFromDate = 0)
				BEGIN
					SET @dtFrmDate = DATEADD(DAY, 1, @dtFrmDate)
				END
				
				SET @dtTempToDate = DATEADD(DAY, @inp_nTradingDays+@nBufferDays, @dtFrmDate)
			END
			
			-- Fetch all dates between 	@dtFrmDate and @dtTempToDate. These will be available in 'DateRange' table
			;WITH DateRange AS
			(
			  SELECT @dtFrmDate DateValue
			  UNION ALL
			  SELECT DateValue + 1 FROM DateRange WHERE DateValue + 1 <= @dtTempToDate
			),
			-- From the data available in 'DateRange' table, exclude all Holidays.
			WorkingDays as
			(
				SELECT  
					DateValue, 
					CASE 
						WHEN @inp_bCalcuatePastdate = 1 THEN ROW_NUMBER() OVER(ORDER BY DateValue DESC)
						ELSE ROW_NUMBER() OVER(ORDER BY DateValue)
					END AS RowNum 
				FROM DateRange M
				LEFT JOIN NonTradingDays H on CONVERT(date,M.DateValue) = CONVERT(date, H.NonTradDay) AND H.Exchangetype = @inp_nExchangeCodeId
				WHERE H.NonTradDay is null 
			)
			
			-- And finally fetch the date at Row #@inp_iTradingDays
			select @dtToDate = DateValue from WorkingDays where RowNum = @inp_nTradingDays
			
			OPTION (MAXRECURSION 0)
		END
		ELSE IF (@nTradingDaysCountType = @nDaysCount_CalendarDays)
		BEGIN
			-- check if from date is included or not
			-- if included then consider from "from" date given
			IF (@inp_bIncludeFromDate = 1)
			BEGIN
				SET @inp_nTradingDays = @inp_nTradingDays - 1
			END
			
			IF(@inp_bCalcuatePastdate = 1)
			BEGIN
				SET @inp_nTradingDays = @inp_nTradingDays * -1
			END
			
			SET @dtToDate = DATEADD(DAY, @inp_nTradingDays, @dtFrmDate)
		END
	END
	ELSE IF (@inp_dtToDate IS NOT NULL)
	BEGIN
		SET @dtToDate = CONVERT(date, @inp_dtToDate)
		
		-- check if trading days count type 
		IF (@nTradingDaysCountType = @nDaysCount_TradingDays)
		BEGIN
			IF(@inp_bCalcuatePastdate = 1)
			BEGIN
				-- in case past date calculation swap from date with to date to get count
				SET @dtTempToDate = @dtFrmDate
				
				SET @dtFrmDate = @dtToDate
				SET @dtToDate = @dtTempToDate
			END
		
			SELECT @nNonTradingDaysCount = COUNT(*) FROM NonTradingDays 
			WHERE Exchangetype = @inp_nExchangeCodeId AND CONVERT(date, NonTradDay) >= @dtFrmDate AND CONVERT(date, NonTradDay) <= @dtToDate
			
			-- check if "from date" is included in calculation or not -- if not included then reduce count 
			IF (EXISTS (SELECT * FROM NonTradingDays WHERE Exchangetype = @inp_nExchangeCodeId AND CONVERT(date, NonTradDay) = @dtFrmDate))
			BEGIN
				-- decrease count becuase from date is not included
				SET @nNonTradingDaysCount =  @nNonTradingDaysCount - 1
			END
			
			-- get difference and substract non trading days(holiday)
			SET @nTradingDaysCount = DATEDIFF(DAY, @dtFrmDate, @dtToDate) - @nNonTradingDaysCount
		END
		ELSE IF (@nTradingDaysCountType = @nDaysCount_CalendarDays)
		BEGIN
			SET @nTradingDaysCount = DATEDIFF(DAY, @dtFrmDate, @dtToDate)
			
			IF(@inp_bCalcuatePastdate = 1)
			BEGIN
				SET @nTradingDaysCount = @nTradingDaysCount * -1
			END
		END
		
		-- check if from date is included or not .. if from date included then consider from "from" date given
		IF (@inp_bIncludeFromDate = 1)
		BEGIN
			IF(@nTradingDaysCount < 0)
			BEGIN
				SET @nTradingDaysCount = @nTradingDaysCount + -1
			END
			ELSE
			BEGIN
				SET @nTradingDaysCount = @nTradingDaysCount + 1
			END
		END
		
	END
	
	IF ((@inp_EventType = @TradingWindowEventTypeFinancialYear OR @inp_EventType = @TradingWindowEventTypeOther)AND (@inp_WindowCloseDate BETWEEN @inp_dtFromDate AND @dtToDate))
	BEGIN
		SET @nWindowOpenDaysCount = DATEDIFF(DAY, @dtToDate, @inp_WindowCloseDate)
		IF @nWindowOpenDaysCount=0
        BEGIN
			SET @dtToDate = DATEADD(DAY, -1, @dtToDate)
			SET @nTradingDaysCount = @nTradingDaysCount -1
		END
		ELSE 
		BEGIN
			SET @dtToDate = DATEADD(DAY, @nWindowOpenDaysCount-1, @dtToDate)
			SET @nTradingDaysCount = @nTradingDaysCount +@nWindowOpenDaysCount-1
		END
		
		IF (@nTradingDaysCountType = @nDaysCount_TradingDays)
		BEGIN
			SET @dtTempToDate=(SELECT CASE WHEN @dtTempToDate IS NULL THEN DATEADD(DAY, @inp_nTradingDays+@nBufferDays, @dtFrmDate)ELSE @dtTempToDate END) 
			;WITH DateRange AS
			(
				SELECT @dtFrmDate DateValue
				UNION ALL
				SELECT DateValue + 1 FROM DateRange WHERE DateValue + 1 <= @dtTempToDate
			),
			-- From the data available in 'DateRange' table, exclude all Holidays.
			WorkingDays as
			(
				SELECT  
				DateValue, 
				CASE 
					WHEN @inp_bCalcuatePastdate = 1 THEN ROW_NUMBER() OVER(ORDER BY DateValue DESC)
					ELSE ROW_NUMBER() OVER(ORDER BY DateValue)
					END AS RowNum 
				FROM DateRange M
				LEFT JOIN NonTradingDays H on CONVERT(date,M.DateValue) = CONVERT(date, H.NonTradDay) AND H.Exchangetype = @inp_nExchangeCodeId
				WHERE H.NonTradDay is null 
			)
			SELECT @FinalDate = DateValue FROM WorkingDays WHERE DateValue<=@dtToDate
			SELECT @dtToDate=CASE WHEN @FinalDate IS NULL OR @FinalDate='' THEN @inp_dtFromDate ELSE @FinalDate END
		END
	END
	
	SET @dtRetDate = @dtToDate
	
	SET @nRetNoOfDays = @nTradingDaysCount
	
	SET @sRetOutput = CASE WHEN	@inp_bRetOutDate = 1 THEN CONVERT(varchar, @dtRetDate) ELSE CONVERT(varchar, @nRetNoOfDays) END
		
	RETURN @sRetOutput
END


