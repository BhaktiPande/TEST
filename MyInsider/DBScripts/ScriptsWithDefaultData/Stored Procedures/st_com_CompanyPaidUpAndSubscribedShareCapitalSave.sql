IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyPaidUpAndSubscribedShareCapitalSave')
DROP PROCEDURE [dbo].[st_com_CompanyPaidUpAndSubscribedShareCapitalSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the CompanyPaidUpAndSubscribedShareCapital details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		25-Feb-2015
Modification History:
Modified By		Modified On	Description
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_com_CompanyPaidUpAndSubscribedShareCapitalSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanyPaidUpAndSubscribedShareCapitalSave] 
	@inp_iCompanyPaidUpAndSubscribedShareCapitalID			INT,
	@inp_dtPaidUpAndSubscribedShareCapitalDate				DATETIME,
	@inp_sPaidUpShare										DECIMAL(20,4),
	@inp_iCompanyID											INT,
	@inp_nLoggedInUserId									INT,						-- Id of the user inserting/updating the CompanyPaidUpAndSubscribedShareCapital
	@out_nReturnValue										INT = 0 OUTPUT,
	@out_nSQLErrCode										INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage										NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_SAVE INT = 13059 -- Error occurred while saving Paid Up & Subscribed Share Capital details of the company.
	DECLARE @ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_NOTFOUND INT = 13057 -- Paid Up & Subscribed Share Capital details for a company does not exist.

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
		SELECT	@ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_NOTFOUND = -9999,
				@ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_SAVE = -9999

		--Save the CompanyPaidUpAndSubscribedShareCapital details
		IF @inp_iCompanyPaidUpAndSubscribedShareCapitalID = 0
		BEGIN
			INSERT INTO com_CompanyPaidUpAndSubscribedShareCapital(
					PaidUpAndSubscribedShareCapitalDate,
					PaidUpShare,
					CompanyID,
					CreatedBy, CreatedOn, ModifiedBy,ModifiedOn )
			VALUES (
					@inp_dtPaidUpAndSubscribedShareCapitalDate,
					@inp_sPaidUpShare,
					@inp_iCompanyID,
					@inp_nLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_nLoggedInUserId, dbo.uf_com_GetServerDate() )
					
				SET	@inp_dtPaidUpAndSubscribedShareCapitalDate = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			--Check if the CompanyPaidUpAndSubscribedShareCapital whose details are being updated exists
			IF (NOT EXISTS(SELECT CompanyPaidUpAndSubscribedShareCapitalID FROM com_CompanyPaidUpAndSubscribedShareCapital WHERE CompanyPaidUpAndSubscribedShareCapitalID = @inp_iCompanyPaidUpAndSubscribedShareCapitalID))			
			BEGIN
				SET @out_nReturnValue = @ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_NOTFOUND
				RETURN (@out_nReturnValue)
			END
	
			UPDATE com_CompanyPaidUpAndSubscribedShareCapital
			SET 	PaidUpAndSubscribedShareCapitalDate = @inp_dtPaidUpAndSubscribedShareCapitalDate,
					PaidUpShare = @inp_sPaidUpShare,
					CompanyID = @inp_iCompanyID,
					ModifiedBy	= @inp_nLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE CompanyPaidUpAndSubscribedShareCapitalID = @inp_iCompanyPaidUpAndSubscribedShareCapitalID	
			
		END
		
		-- in case required to return for partial save case.
		SELECT CompanyPaidUpAndSubscribedShareCapitalID, PaidUpAndSubscribedShareCapitalDate, PaidUpShare, CompanyID 
		FROM com_CompanyPaidUpAndSubscribedShareCapital
		WHERE CompanyPaidUpAndSubscribedShareCapitalID = @inp_iCompanyPaidUpAndSubscribedShareCapitalID
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END