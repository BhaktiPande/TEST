IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyAuthorizedShareCapitalSave')
DROP PROCEDURE [dbo].[st_com_CompanyAuthorizedShareCapitalSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the CompanyAuthorizedShareCapital details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		23-Feb-2015
Modification History:
Modified By		Modified On	Description
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_com_CompanyAuthorizedShareCapitalSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanyAuthorizedShareCapitalSave] 
	@inp_iCompanyAuthorizedShareCapitalID				INT,
	@inp_iCompanyID										INT,
	@inp_dtAuthorizedShareCapitalDate					DATETIME,
	@inp_sAuthorizedShares								DECIMAL(20,4),
	@inp_iLoggedInUserId								INT,				-- Id of the user inserting/updating the CompanyAuthorizedShareCapital
	@out_nReturnValue									INT = 0 OUTPUT,
	@out_nSQLErrCode									INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage									NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_COMPANYAUTHORIZEDSHARECAPITAL_SAVE INT = 13053 -- Error occurred while saving authorized share capital details for a company.
	DECLARE @ERR_COMPANYAUTHORIZEDSHARECAPITAL_NOTFOUND INT = 13041 -- Authorized share capital details does not exist.

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

		--Save the CompanyAuthorizedShareCapital details
		IF @inp_iCompanyAuthorizedShareCapitalID IS NULL OR @inp_iCompanyAuthorizedShareCapitalID = 0
		BEGIN
			Insert into com_CompanyAuthorizedShareCapital(
					CompanyID,
					AuthorizedShareCapitalDate,
					AuthorizedShares,
					CreatedBy, CreatedOn, ModifiedBy,	ModifiedOn )
			Values (
					@inp_iCompanyID,
					@inp_dtAuthorizedShareCapitalDate,
					@inp_sAuthorizedShares,
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate() )
		END
		ELSE
		BEGIN
			--Check if the CompanyAuthorizedShareCapital whose details are being updated exists
			IF (NOT EXISTS(SELECT CompanyAuthorizedShareCapitalID FROM com_CompanyAuthorizedShareCapital WHERE CompanyAuthorizedShareCapitalID = @inp_iCompanyAuthorizedShareCapitalID))			
			BEGIN
				SET @out_nReturnValue = @ERR_COMPANYAUTHORIZEDSHARECAPITAL_NOTFOUND
				RETURN (@out_nReturnValue)
			END
	
			Update com_CompanyAuthorizedShareCapital
			Set 					CompanyID = @inp_iCompanyID,
					AuthorizedShareCapitalDate = @inp_dtAuthorizedShareCapitalDate,
					AuthorizedShares = @inp_sAuthorizedShares,
					ModifiedBy	= @inp_iLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()

			Where CompanyAuthorizedShareCapitalID = @inp_iCompanyAuthorizedShareCapitalID	
			
		END
		
		-- in case required to return for partial save case.
		Select CompanyAuthorizedShareCapitalID, CompanyID, AuthorizedShareCapitalDate, AuthorizedShares 
			From com_CompanyAuthorizedShareCapital
			Where CompanyAuthorizedShareCapitalID = @inp_iCompanyAuthorizedShareCapitalID
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_COMPANYAUTHORIZEDSHARECAPITAL_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END