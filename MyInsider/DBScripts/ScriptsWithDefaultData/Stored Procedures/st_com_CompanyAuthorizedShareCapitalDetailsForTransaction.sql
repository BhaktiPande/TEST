IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyAuthorizedShareCapitalDetailsForTransaction')
DROP PROCEDURE [dbo].[st_com_CompanyAuthorizedShareCapitalDetailsForTransaction]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the CompanyAuthorizedShareCapital details on Date of acquisition for transaction.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		02-Dec-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	09-Jan-2016		As per requirement, system should consider "Paid Up & Subscribed Share Capital" for calculating % of Shareholding - Pre transaction & % of Shareholding - Post transaction. Currently system is considering "Authorized Capital" while calculating the same.

Usage:
EXEC st_com_CompanyAuthorizedShareCapitalDetailsForTransaction '2014-04-15'
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanyAuthorizedShareCapitalDetailsForTransaction]
	@inp_dtAuthorizedShareCapitalDate DATETIME,							-- DATE of the CompanyAuthorizedShareCapital whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_COMPANYAUTHORIZEDSHARECAPITAL_GETDETAILS INT = 13052 -- Error occurred while fetching authorized share capital details for a company.
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

		--Check if the CompanyAuthorizedShareCapital whose details are being fetched exists
		--IF (NOT EXISTS(SELECT CompanyAuthorizedShareCapitalID FROM com_CompanyAuthorizedShareCapital SC
		--														INNER JOIN mst_Company C ON SC.CompanyID = C.CompanyId
		--														WHERE C.IsImplementing = 1
		--														AND AuthorizedShareCapitalDate <= @inp_dtAuthorizedShareCapitalDate))
		IF (NOT EXISTS(SELECT CompanyPaidUpAndSubscribedShareCapitalID FROM com_CompanyPaidUpAndSubscribedShareCapital SC
																INNER JOIN mst_Company C ON SC.CompanyID = C.CompanyId
																WHERE C.IsImplementing = 1
																AND PaidUpAndSubscribedShareCapitalDate <= @inp_dtAuthorizedShareCapitalDate))
		BEGIN
				SET @out_nReturnValue = @ERR_COMPANYAUTHORIZEDSHARECAPITAL_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the CompanyAuthorizedShareCapital details
		--SELECT TOP 1 CompanyAuthorizedShareCapitalID, SC.CompanyID, AuthorizedShareCapitalDate, AuthorizedShares 
		--FROM com_CompanyAuthorizedShareCapital SC
		--INNER JOIN mst_Company C ON SC.CompanyID = C.CompanyId
		--WHERE C.IsImplementing = 1
		--AND AuthorizedShareCapitalDate <= @inp_dtAuthorizedShareCapitalDate
		--ORDER BY AuthorizedShareCapitalDate DESC
		
		SELECT TOP 1 CompanyPaidUpAndSubscribedShareCapitalID, SC.CompanyID, PaidUpAndSubscribedShareCapitalDate, PaidUpShare 
		FROM com_CompanyPaidUpAndSubscribedShareCapital SC
		INNER JOIN mst_Company C ON SC.CompanyID = C.CompanyId
		WHERE C.IsImplementing = 1
		AND PaidUpAndSubscribedShareCapitalDate <= @inp_dtAuthorizedShareCapitalDate
		ORDER BY PaidUpAndSubscribedShareCapitalDate DESC

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_COMPANYAUTHORIZEDSHARECAPITAL_NOTFOUND, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

