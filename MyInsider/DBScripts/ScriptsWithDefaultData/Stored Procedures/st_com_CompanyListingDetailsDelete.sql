IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyListingDetailsDelete')
DROP PROCEDURE [dbo].[st_com_CompanyListingDetailsDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to delete company listing details.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		22-Feb-2015

Modification History:
Modified By		Modified On		Description

Usage:
EXEC st_mst_CompanyList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_CompanyListingDetailsDelete]
	@inp_iCompanyListingDetailsID	INT
	,@inp_iLoggedInUserId			INT	-- Id of the user inserting/updating the CompanyFaceValue
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_COMPANYLISTINGDETAILS_DELETE INT = 13049 -- Error occurred while deleting listing details for a company.
	DECLARE @ERR_COMPANYLISTINGDETAILS_NOTFOUND INT = 13048 -- Listing details for a company does not exist.
	DECLARE @ERR_DEPENDENTINFOEXISTS INT = 13051 -- Cannot delete listing details for a company, as some dependent information exists for this listing details.
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Check if the CompanyFaceValue being deleted exists
		IF (NOT EXISTS(SELECT CompanyListingDetailsID FROM com_CompanyListingDetails WHERE CompanyListingDetailsID = @inp_iCompanyListingDetailsID))
		BEGIN
			SET @out_nReturnValue = @ERR_COMPANYLISTINGDETAILS_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		DELETE FROM com_CompanyListingDetails
		WHERE CompanyListingDetailsID = @inp_iCompanyListingDetailsID	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()

		IF ERROR_NUMBER() = 547 -- Dependent info exists
			SET @out_nReturnValue = @ERR_DEPENDENTINFOEXISTS
		ELSE
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_COMPANYLISTINGDETAILS_DELETE, ERROR_NUMBER())
	END CATCH
END
