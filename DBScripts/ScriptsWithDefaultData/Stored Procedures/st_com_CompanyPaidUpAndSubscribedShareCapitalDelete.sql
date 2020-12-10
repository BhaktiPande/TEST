IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyPaidUpAndSubscribedShareCapitalDelete')
DROP PROCEDURE [dbo].[st_com_CompanyPaidUpAndSubscribedShareCapitalDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Deletes the CompanyPaidUpAndSubscribedShareCapital

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		24-Feb-2015

Modification History:
Modified By		Modified On	Description


Usage:
DECLARE @RC int
EXEC st_com_CompanyPaidUpAndSubscribedShareCapitalDelete 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanyPaidUpAndSubscribedShareCapitalDelete]
	-- Add the parameters for the stored procedure here
	@inp_iCompanyPaidUpAndSubscribedShareCapitalID		INT,	 -- Id of the CompanyPaidUpAndSubscribedShareCapital to be deleted
	@out_nReturnValue									INT = 0 OUTPUT,		
	@out_nSQLErrCode									INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage									NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_DELETE INT = 13055, -- Error occurred while deleting list of Paid Up & Subscribed Share Capital of the company.
			@ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_NOTFOUND INT = 13057, -- Paid Up & Subscribed Share Capital details for a company does not exist.
			@ERR_DEPENDENTINFOEXISTS INT = 13056 -- Cannot delete Paid Up & Subscribed Share Capital details for a company, as some dependent information exists on it.

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
				@ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_DELETE = -9999
	
		--Check if the CompanyPaidUpAndSubscribedShareCapital being deleted exists
		IF (NOT EXISTS(SELECT CompanyPaidUpAndSubscribedShareCapitalID FROM com_CompanyPaidUpAndSubscribedShareCapital WHERE CompanyPaidUpAndSubscribedShareCapitalID = @inp_iCompanyPaidUpAndSubscribedShareCapitalID))
		BEGIN
			SET @out_nReturnValue = @ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		DELETE FROM com_CompanyPaidUpAndSubscribedShareCapital
		WHERE CompanyPaidUpAndSubscribedShareCapitalID = @inp_iCompanyPaidUpAndSubscribedShareCapitalID


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
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_COMPANYPAIDUPANDSUBSCRIBEDSHARECAPITAL_DELETE, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
	END CATCH
END
