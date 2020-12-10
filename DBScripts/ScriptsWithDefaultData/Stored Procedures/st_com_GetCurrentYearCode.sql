IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_GetCurrentYearCode')
DROP PROCEDURE [dbo].[st_com_GetCurrentYearCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************
Description:	Procedure to get each start and end date for period end

Returns:		Return 0, if success.
				
Created by:		Parag
Created on:		07-May-2015
Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

******************************************************************************************************************

Usage:

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_com_GetCurrentYearCode]
	@out_nCurrentYearCode	INT OUTPUT,
	@out_nReturnValue 		INT = 0 OUTPUT,
	@out_nSQLErrCode 		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_CURRENTYEARCODE		INT = 14024  -- Error occurred while fetching current year code.
	DECLARE @dtCurrentDate				DATETIME = dbo.uf_com_GetServerDate()
	DECLARE @nCurrentPeriodYear 		INT
	DECLARE @nCurrentPeriodMonth 		INT
	DECLARE @nYearStartMonth			INT = 4

	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SET @nCurrentPeriodYear = YEAR(@dtCurrentDate) -- get current year 
		SET @nCurrentPeriodMonth = MONTH(@dtCurrentDate) -- get current month 
		
		--set previous year as current year if start month is previous then year start month
		IF @nCurrentPeriodMonth < @nYearStartMonth 
		BEGIN
			SET @nCurrentPeriodYear = @nCurrentPeriodYear - 1 
		END
		
		SELECT @out_nCurrentYearCode = CodeID FROM com_Code WHERE CodeGroupId = 125 AND CodeName LIKE CONVERT(VARCHAR(4), @nCurrentPeriodYear) + '%'
		
		SELECT 1 -- set this for petapoco lib
		
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CURRENTYEARCODE
	END CATCH
END
