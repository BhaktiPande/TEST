IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rl_RestictedListCompanyDetails')
DROP PROCEDURE [dbo].[st_rl_RestictedListCompanyDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the Resticted list company details for given company id

Returns:		0, if Success.
				
Created by:		Parag
Created on:		20-Sept-2016

Modification History:
Modified By		Modified On	Description

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rl_RestictedListCompanyDetails]
	@inp_iCompanyId					INT,
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_RESTRICTEDCOMPANYCONFIGURATION_ERROR INT = 50082 --Error occured while fetching company details
	DECLARE @ERR_RESTRICTEDCOMPANYCONFIGURATION_NOTFOUND INT = 50083 -- Company details not found

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		-- check if configuration exists for configuration type
		IF NOT EXISTS(SELECT RlCompanyId FROM rl_CompanyMasterList WHERE RlCompanyId = @inp_iCompanyId)
		BEGIN
			SET @out_nReturnValue = @ERR_RESTRICTEDCOMPANYCONFIGURATION_NOTFOUND
			RETURN @out_nReturnValue
		END

		SELECT RlCompanyId, CompanyName, BSECode, NSECode, ISINCode from rl_CompanyMasterList WHERE RlCompanyId = @inp_iCompanyId

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_RESTRICTEDCOMPANYCONFIGURATION_ERROR, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

