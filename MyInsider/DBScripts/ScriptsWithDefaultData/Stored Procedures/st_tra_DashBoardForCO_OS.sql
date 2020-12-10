IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_DashBoardForCO_OS')
DROP PROCEDURE [dbo].[st_tra_DashBoardForCO_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to get DashBoard Count for CO.

Returns:		0, if Success.
				
Created by:		Samadhan
Created on:		02-Feb-2020

Modification History:

EXEC st_tra_DashBoardForCO_OS
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_DashBoardForCO_OS]
	@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN	
	BEGIN TRY				

		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''		
		
		select (SELECT [count] FROM tra_CoDashboardCount WHERE DashboardCountId = 26)  AS PersonalDetailsConfirmation
		,(SELECT [count] FROM tra_CoDashboardCount WHERE DashboardCountId = 27)  AS PersonalDetailsReconfirmation	
		,(SELECT [count] FROM tra_CoDashboardCount WHERE DashboardCountId = 28)  AS InitialDisclosures_OS
		,(SELECT [count] FROM tra_CoDashboardCount WHERE DashboardCountId = 29)  AS InitialDisclosuresRelative_OS
		,(SELECT [count] FROM tra_CoDashboardCount WHERE DashboardCountId = 30)  AS TradeDetails_OS
		,(SELECT [count] FROM tra_CoDashboardCount WHERE DashboardCountId = 31)  AS PeriodendDisclosures_OS
		,(SELECT [count] FROM tra_CoDashboardCount WHERE DashboardCountId = 32)  AS PreclearanceApproval_OS
		,(SELECT [count] FROM tra_CoDashboardCount WHERE DashboardCountId = 33)  AS TradingPolicydueforExpiry_OS
		,(SELECT [count] FROM tra_CoDashboardCount WHERE DashboardCountId = 34)  AS PolicyDocumentdueforExpiry
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  ''
	END CATCH
END
GO
