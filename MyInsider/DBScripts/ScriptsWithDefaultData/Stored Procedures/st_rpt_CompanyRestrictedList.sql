IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_CompanyRestrictedList')
	DROP PROCEDURE st_rpt_CompanyRestrictedList
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list of Company Restricted List.

Returns:		0, if Success.
				
Created by:		Sandesh Lname
Created on:		11-Mar-2020

Modification History:

Modified By		Modified On		Description

Usage:

EXEC st_rpt_DigitalDatabase
----------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rpt_CompanyRestrictedList]
	 @out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
    
	BEGIN TRY
			SET NOCOUNT ON;

		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

				SELECT RlCompanyId,CompanyName,BSECode,NSECode,ISINCode, 
				CASE StatusCodeId WHEN '105001' THEN 'Active' WHEN '105002' THEN 'InActive' END AS 'Status' FROM rl_CompanyMasterList 


	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  0
	END CATCH

END