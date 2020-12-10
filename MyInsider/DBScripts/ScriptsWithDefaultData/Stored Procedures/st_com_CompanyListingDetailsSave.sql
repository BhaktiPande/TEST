IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyListingDetailsSave')
DROP PROCEDURE [dbo].[st_com_CompanyListingDetailsSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list company listing details.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		22-Feb-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_mst_CompanyList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_CompanyListingDetailsSave]
	@inp_iCompanyListingDetailsID	INT
	,@inp_iCompanyID				INT
	,@inp_iStockExchangeID			INT
	,@inp_dtDateOfListingFrom		DATETIME
	,@inp_dtDateOfListingTo			DATETIME
	,@inp_iLoggedInUserId			INT	-- Id of the user inserting/updating the CompanyFaceValue
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_COMPANYLISTINGDETAILS_SAVE INT = 13047 -- Error occurred while saving listing details for a company.
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
		IF @inp_iCompanyListingDetailsID IS NULL OR @inp_iCompanyListingDetailsID = 0
		BEGIN
			INSERT INTO com_CompanyListingDetails(
					CompanyId, StockExchangeID, DateOfListingFrom, DateOfListingTo,
					CreatedBy, CreatedOn, ModifiedBy,	ModifiedOn )
			VALUES (
					@inp_iCompanyID, @inp_iStockExchangeID, @inp_dtDateOfListingFrom, @inp_dtDateOfListingTo,
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate() )
		
			SET @inp_iCompanyListingDetailsID = SCOPE_IDENTITY()
		
		END
		ELSE
		BEGIN
			--Check if the CompanyFaceValue whose details are being updated exists
			IF (NOT EXISTS(SELECT CompanyListingDetailsID FROM com_CompanyListingDetails WHERE CompanyListingDetailsID = @inp_iCompanyListingDetailsID))
			BEGIN			
				SET @out_nReturnValue = @ERR_COMPANYLISTINGDETAILS_NOTFOUND
				RETURN (@out_nReturnValue)
			END
	
			UPDATE com_CompanyListingDetails
			SET 	StockExchangeID = @inp_iStockExchangeID,
					DateOfListingFrom = @inp_dtDateOfListingFrom,
					DateOfListingTo = @inp_dtDateOfListingTo,
					ModifiedBy	= @inp_iLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE CompanyListingDetailsID = @inp_iCompanyListingDetailsID
			
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
		SET @out_nReturnValue	=  @ERR_COMPANYLISTINGDETAILS_SAVE
	END CATCH
END
