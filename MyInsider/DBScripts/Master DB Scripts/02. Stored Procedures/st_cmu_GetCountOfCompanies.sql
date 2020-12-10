/******************************************************************************************************************
Description:	Routine to get count of Implementing companies listed in table Companies.

Returns:		
				
Created by:		Ashashree
Created on:		05-Jun-2015
Modification History:
Modified By		Modified On		Description

****************************************************************************************************************/
/*Drop procedure if already exists and then run the CREATE script*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_cmu_GetCountOfCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_cmu_GetCountOfCompanies]
GO


CREATE PROCEDURE [dbo].[st_cmu_GetCountOfCompanies]
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @ERR_GET_COUNTOFCOMPANIES INT = 10006
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT COUNT(CompanyId) AS CountOfCompanies FROM Companies
				
		RETURN @out_nReturnValue
		
	END TRY
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue  = @ERR_GET_COUNTOFCOMPANIES
		RETURN @out_nReturnValue		
	END CATCH
	
END
