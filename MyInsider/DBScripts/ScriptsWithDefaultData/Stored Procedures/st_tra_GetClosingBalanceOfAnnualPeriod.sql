IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetClosingBalanceOfAnnualPeriod')
DROP PROCEDURE [dbo].[st_tra_GetClosingBalanceOfAnnualPeriod]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************
Description:	Procedure to get Closing balance of annual period of that user.

Returns:		Return 0, if success.
				
Created by:		Gaurshankar
Created on:		02-Dec-2015
Modification History:
Modified By		Modified On		Description
Gaurishankar	2016-01-13		Change for datatype of @out_nClosingBalance as in tra_TransactionSummary

******************************************************************************************************************

Usage:

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_tra_GetClosingBalanceOfAnnualPeriod]
	@inp_nUserInfoId		INT ,
	@inp_nUserInfoIdRelative		INT ,
	@inp_nSecurityTypeCodeId		INT ,
	@out_nClosingBalance			DECIMAL(10,0) = 0 OUTPUT,
	@out_nReturnValue 					INT = 0 OUTPUT,
	@out_nSQLErrCode 					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_CURRENTYEARCODE		INT = 17053  -- Error occurred while fetching current disclosure year code.
	
	DECLARE @nPeriodCodeId INT

	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT @nPeriodCodeId = 124001
		
		  SELECT TOP 1  @out_nClosingBalance =  ClosingBalance FROM [dbo].[tra_TransactionSummary]
			  WHERE UserInfoId = @inp_nUserInfoId  --PeriodCodeId = @nPeriodCodeId
			  AND UserInfoIdRelative = @inp_nUserInfoIdRelative
			  AND SecurityTypeCodeId = @inp_nSecurityTypeCodeId
			  ORDER BY TransactionSummaryId DESC
		IF(@out_nClosingBalance IS NULL )
		BEGIN
			SELECT @out_nClosingBalance = 0
		END
		  
		
		SELECT 1 -- set this for petapoco lib
		
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  dbo.uf_com_GetErrorCode(@ERR_CURRENTYEARCODE, ERROR_NUMBER())
	END CATCH
END
