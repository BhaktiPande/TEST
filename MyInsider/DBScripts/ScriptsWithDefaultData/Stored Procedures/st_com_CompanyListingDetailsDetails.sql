IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyListingDetailsDetails')
DROP PROCEDURE [dbo].[st_com_CompanyListingDetailsDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to fetch details of company listing details.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		25-Feb-2015

Modification History:
Modified By		Modified On		Description

Usage:
EXEC st_mst_CompanyList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_CompanyListingDetailsDetails]
	@inp_iCompanyListingDetailsID	INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_COMPANYLISTINGDETAILS_DETAILS INT = 13050 -- Error occurred while fetching listing details for a company.
	DECLARE @ERR_COMPANYLISTINGDETAILS_NOTFOUND INT = 13048 -- Listing details for a company does not exist.

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		--Check if the CompanyFaceValue whose details are being updated exists
		IF (NOT EXISTS(SELECT CompanyListingDetailsID FROM com_CompanyListingDetails WHERE CompanyListingDetailsID = @inp_iCompanyListingDetailsID))
		BEGIN			
			SET @out_nReturnValue = @ERR_COMPANYLISTINGDETAILS_NOTFOUND
			RETURN (@out_nReturnValue)
		END
	
		
		-- in case required to return for partial save case.
		SELECT CompanyListingDetailsID, CompanyId, StockExchangeID, DateOfListingFrom, DateOfListingTo
		FROM com_CompanyListingDetails
		WHERE CompanyListingDetailsID = @inp_iCompanyListingDetailsID
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COMPANYLISTINGDETAILS_DETAILS
	END CATCH
END
