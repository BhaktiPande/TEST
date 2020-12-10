IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosureCurrentDisclosurePeriodCode')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosureCurrentDisclosurePeriodCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************************************************
Description:	Procedure to get period end disclosure's last current disclosure period code

Returns:		Return 0, if success.
				
Created by:		Parag
Created on:		20-May-2015

Modification History:
Modified By		Modified On		Description
Arundhati		31-Oct-2015		Codes (dates) for Period end date are changed. Now that are stored as the 1st of next month.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

******************************************************************************************************************

Usage:

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosureCurrentDisclosurePeriodCode]
	@inp_iReturnSelect					INT = 1,
	@out_nCurrentDisclosurePeriodCode	INT OUTPUT,
	@out_nReturnValue 					INT = 0 OUTPUT,
	@out_nSQLErrCode 					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_CURRENTPERIODCODE		INT = 17172  -- Error occurred while fetching current disclosure period code.
	DECLARE @dtCurrentDate				DATETIME = dbo.uf_com_GetServerDate()
	DECLARE @nPeriodType				INT
	DECLARE @nPeriodYear				INT
	DECLARE @nYearStartMonth			INT
	DECLARE @nSecondPeriodStartMonth	INT

	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT @nPeriodType = CodeName FROM com_Code WHERE CodeID = 128002
		
		SELECT @nPeriodYear = YEAR(@dtCurrentDate) --get current year 
		SELECT @nYearStartMonth = 4 --month from which year start
		
		-- Set period duration
		SET @nSecondPeriodStartMonth = CASE @nPeriodType
			WHEN 123001 THEN 12 -- Annual
			WHEN 123002 THEN 6 	-- Half Yearly
			WHEN 123003 THEN 3 	-- Quarterly
			WHEN 123004 THEN 1  -- Monthly
			END
		
		-- Get Period start year
		IF MONTH(@dtCurrentDate) < @nYearStartMonth + @nSecondPeriodStartMonth
		BEGIN
			SET @nPeriodYear = @nPeriodYear - 1
		END
		
		SELECT TOP 1 
			@out_nCurrentDisclosurePeriodCode = CdPeriod.CodeID
		FROM 
			com_Code CdPeriod 
		WHERE 
			CdPeriod.ParentCodeId = @nPeriodType and CdPeriod.CodeGroupId = 124 and 
			DATEADD(DAY, -1, DATEADD(YEAR, @nPeriodYear-1970,convert(datetime, CdPeriod.Description))) < @dtCurrentDate
		ORDER BY CdPeriod.DisplayOrder DESC
		
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
		SET @out_nReturnValue	=  @ERR_CURRENTPERIODCODE
	END CATCH
END
