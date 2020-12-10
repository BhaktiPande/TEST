IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyAuthorizedShareCapitalDelete')
DROP PROCEDURE [dbo].[st_com_CompanyAuthorizedShareCapitalDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Deletes the CompanyAuthorizedShareCapital

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		23-Feb-2015

Modification History:
Modified By		Modified On	Description


Usage:
DECLARE @RC int
EXEC st_com_CompanyAuthorizedShareCapitalDelete 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanyAuthorizedShareCapitalDelete]
	-- Add the parameters for the stored procedure here
	@inp_iCompanyAuthorizedShareCapitalID INT,							-- Id of the CompanyAuthorizedShareCapital to be deleted
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_COMPANYAUTHORIZEDSHARECAPITAL_DELETE INT = 13040, -- Error occurred while deleting authorized share capital details for a company.
			@ERR_COMPANYAUTHORIZEDSHARECAPITAL_NOTFOUND INT = 13041, -- Authorized share capital details does not exist
			@ERR_DEPENDENTINFOEXISTS INT = 13054 -- Cannot delete authorized share capital details for a company, as some dependent information exists for this listing details.

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


		--Initialize variables
	
		--Check if the CompanyAuthorizedShareCapital being deleted exists
		IF (NOT EXISTS(SELECT CompanyAuthorizedShareCapitalID FROM com_CompanyAuthorizedShareCapital WHERE CompanyAuthorizedShareCapitalID = @inp_iCompanyAuthorizedShareCapitalID))
		BEGIN
			SET @out_nReturnValue = @ERR_COMPANYAUTHORIZEDSHARECAPITAL_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		DELETE FROM com_CompanyAuthorizedShareCapital
		WHERE CompanyAuthorizedShareCapitalID = @inp_iCompanyAuthorizedShareCapitalID


		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		IF ERROR_NUMBER() = 547 -- Dependent info exists
			SET @out_nReturnValue = @ERR_DEPENDENTINFOEXISTS
		ELSE
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_COMPANYAUTHORIZEDSHARECAPITAL_DELETE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
