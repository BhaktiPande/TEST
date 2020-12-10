/******************************************************************************************************************
Description:	Routine to get Ids of Implementing companies listed in table Companies.

Returns:		
				
Created by:		Ashashree
Created on:		05-Jun-2015

Modification History:
Modified By		Modified On		Description
Tushar			13-Jun-2015		Return CompanyName,ConnectionDatabaseName

****************************************************************************************************************/
/*Drop procedure if already exists and then run the CREATE script*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_cmu_GetCompanyIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_cmu_GetCompanyIds]
GO

CREATE PROCEDURE [dbo].[st_cmu_GetCompanyIds]
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @ERR_GET_COMPANYIDS INT = 10005
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT CompanyId,CompanyName,ConnectionDatabaseName FROM Companies
				
		RETURN @out_nReturnValue
		
	END TRY
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue  = @ERR_GET_COMPANYIDS
		RETURN @out_nReturnValue		
	END CATCH
	
END
