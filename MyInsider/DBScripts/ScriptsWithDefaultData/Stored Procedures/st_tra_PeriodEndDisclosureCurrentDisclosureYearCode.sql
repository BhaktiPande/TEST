IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosureCurrentDisclosureYearCode')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosureCurrentDisclosureYearCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************************************************
Description:	Procedure to get period end disclosure's last current disclosure year code

Returns:		Return 0, if success.
				
Created by:		Parag
Created on:		07-May-2015
Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.


******************************************************************************************************************

Usage:

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosureCurrentDisclosureYearCode]
	@out_nCurrentDisclosureYearCode		INT OUTPUT,
	@out_nReturnValue 					INT = 0 OUTPUT,
	@out_nSQLErrCode 					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_CURRENTYEARCODE		INT = 17053  -- Error occurred while fetching current disclosure year code.
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
		
		SELECT @out_nCurrentDisclosureYearCode = CodeID FROM com_Code WHERE CodeGroupId = 125 AND CodeName LIKE CONVERT(VARCHAR(4), @nPeriodYear) + '%'
		
		SELECT 1 -- set this for petapoco lib
		
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CURRENTYEARCODE
	END CATCH
END
