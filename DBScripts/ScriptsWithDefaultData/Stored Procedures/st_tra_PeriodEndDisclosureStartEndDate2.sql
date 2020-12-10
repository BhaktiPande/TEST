IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosureStartEndDate2')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosureStartEndDate2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************************************************
Description:	Procedure to get each start and end date for period end. This is the extension of the earlier procedure using the period type set in the parameter

Returns:		Return 0, if success.
				
Created by:		Arundhati
Created on:		26-Aug-2015

Modification History:
Modified By		Modified On		Description
Arundhati		31-Oct-2015		Codes (dates) for Period end date are changed. Now that are stored as the 1st of next month.
Tushar			22-Jan-2016		@inp_dtDate convert in date part because doesnot work for leap year.
******************************************************************************************************************

Usage:

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosureStartEndDate2]
	@inp_nYearCode 			INT OUTPUT,
	@inp_nPeriodCode 		INT OUTPUT,
	@inp_dtDate				DATETIME, -- If @inp_nYearCode & @inp_nPeriodCode are null, then the start and end dates are found using @inp_dtDate
	@inp_iPeriodType		INT,
	@inp_iReturnSelect		INT = 1,
	@out_dtStartDate		DATETIME OUTPUT,
	@out_dtEndDate			DATETIME OUTPUT,
	@out_nReturnValue 		INT = 0 OUTPUT,
	@out_nSQLErrCode 		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_PERIODENDDISCLOSURE_STARTENDDATE	INT = 17054 -- error code for start and end date not found
	DECLARE @nPeriodType 							INT
	DECLARE @nPeriodYear 							INT
	DECLARE @nDffInPeriodStartMonth 				INT
	DECLARE @nDiffInFromStartYear					INT
	DECLARE @nYearCode								INT
	DECLARE @nPeriodCode							INT
	DECLARE @dtDate									DATETIME

	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		-- Get period type
		SELECT @nPeriodType = @inp_iPeriodType--CodeName FROM com_Code WHERE CodeID = 128002
		
		SET @inp_dtDate = CONVERT(DATE,@inp_dtDate)
		
		-- Set YearCode				
		IF @inp_nYearCode IS NULL
		BEGIN
			SELECT @nPeriodYear = YEAR(@inp_dtDate)
			IF MONTH(@inp_dtDate) < 4
			BEGIN
				SET @nPeriodYear = @nPeriodYear - 1
			END
			SELECT @nYearCode = CodeID FROM com_Code WHERE CodeGroupId = 125 AND CodeName LIKE CONVERT(VARCHAR(4), @nPeriodYear) + '%'
		END
		ELSE
		BEGIN
			SET @nYearCode = @inp_nYearCode
			SET @nPeriodCode = @inp_nPeriodCode
			SELECT @nPeriodYear = CONVERT(INT,SUBSTRING(CodeName,0,5)) FROM com_Code WHERE CodeID = @nYearCode -- get year 			
			

		END
		--SELECT @nPeriodYear,@nYearCode,@nPeriodType,@inp_nPeriodCode
		
		SELECT TOP(1) @out_dtEndDate = DATEADD(DAY, -1, DATEADD(YEAR, @nPeriodYear - 1970, CONVERT(DATETIME, Description))),
					@nPeriodCode = CodeID
		FROM com_Code 
		WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType 
			AND ((@inp_nPeriodCode IS NOT NULL AND CodeID = @inp_nPeriodCode)
					OR (@inp_dtDate <= DATEADD(DAY, -1, DATEADD(YEAR, @nPeriodYear - 1970, CONVERT(DATETIME, Description)))))
		ORDER BY CONVERT(DATETIME, Description) ASC
		
		--select @out_dtEndDate
		SELECT @nDiffInFromStartYear = @nPeriodYear - 1970 -- difference in year for start of years
		
		-- Set period duration
		SET @nDffInPeriodStartMonth = CASE @nPeriodType
			WHEN 123001 THEN 11 -- Annual
			WHEN 123002 THEN 5 	-- Half Yearly
			WHEN 123003 THEN 2 	-- Quarterly
			WHEN 123004 THEN 0  -- Monthly
			END
		
		SELECT @dtDate = DATEADD(M, -@nDffInPeriodStartMonth, @out_dtEndDate)

		SELECT @out_dtStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, YEAR(@dtDate)) + '-' + CONVERT(VARCHAR, MONTH(@dtDate)) + '-1')
		
		IF @inp_nYearCode IS NULL
		BEGIN
			SELECT @inp_nPeriodCode = @nPeriodCode, @inp_nYearCode = @nYearCode
		END
		
		--SELECT 
		--	--DATEADD(dd,-(DAY(@mydate)-1),@mydate) -- to get first day of current month
		--	@out_dtStartDate = DATEADD(dd, -(DAY(DATEADD(MONTH, -@nDffInPeriodStartMonth, DATEADD(YEAR, @nDiffInFromStartYear, convert(datetime, CdPeriod.Description))))-1),DATEADD(MONTH, -@nDffInPeriodStartMonth, DATEADD(YEAR, @nDiffInFromStartYear, convert(datetime, CdPeriod.Description)))),
		--	@out_dtEndDate = DATEADD(YEAR, @nDiffInFromStartYear, convert(datetime, CdPeriod.Description)) 
		--FROM com_Code CdPeriod
		--WHERE
		--	CdPeriod.CodeID = @inp_nPeriodCode
		
		--check to select value or not
		IF @inp_iReturnSelect = 1 
		BEGIN 
			SELECT 1 -- set this for petapoco lib 
		END 
			
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PERIODENDDISCLOSURE_STARTENDDATE
	END CATCH
END
