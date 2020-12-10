IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyPaidUpAndSubscribedShareCapitalDetails')
DROP PROCEDURE [dbo].[st_com_CompanyPaidUpAndSubscribedShareCapitalDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the CompanyPaidUpAndSubscribedShareCapital details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		24-Feb-2015

Modification History:
Modified By		Modified On	Description

Usage:
EXEC st_com_CompanyPaidUpAndSubscribedShareCapitalDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanyPaidUpAndSubscribedShareCapitalDetails]
	@inp_iCompanyPaidUpAndSubscribedShareCapitalID		INT,						-- Id of the CompanyPaidUpAndSubscribedShareCapital whose details are to be fetched.
	@out_nReturnValue									INT = 0 OUTPUT,
	@out_nSQLErrCode									INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage									NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_GETDETAILS INT = 13058 -- Error occurred while fetching Paid Up & Subscribed Share Capital details of the company.
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

		--Check if the CompanyPaidUpAndSubscribedShareCapital whose details are being fetched exists
		IF (NOT EXISTS(SELECT CompanyPaidUpAndSubscribedShareCapitalID FROM com_CompanyPaidUpAndSubscribedShareCapital WHERE CompanyPaidUpAndSubscribedShareCapitalID = @inp_iCompanyPaidUpAndSubscribedShareCapitalID))
		BEGIN
				SET @out_nReturnValue = @ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the CompanyPaidUpAndSubscribedShareCapital details
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
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

