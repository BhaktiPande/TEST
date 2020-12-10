IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyComplianceOfficerDetails')
DROP PROCEDURE [dbo].[st_com_CompanyComplianceOfficerDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Fetch details of the compliance officer for a company

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		25-Feb-2015

Modification History:
Modified By		Modified On	Description


Usage:
DECLARE @RC int
EXEC st_com_CompanyComplianceOfficerDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanyComplianceOfficerDetails]
	-- Add the parameters for the stored procedure here
	@inp_iCompanyComplianceOfficerId INT,	-- Id of the complince officwer to be deleted
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_COMPLIANCEOFFICER_GETDETAILS INT = 13046, -- Error occurred while fetching details for compliance officer for a company
			@ERR_COMPLIANCEOFFICER_NOTFOUND INT = 13043 -- Compliance officer for a company does not exist.

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
	
		--Check if the CompanyFaceValue being deleted exists
		IF (NOT EXISTS(SELECT CompanyComplianceOfficerId FROM com_CompanyComplianceOfficer WHERE CompanyComplianceOfficerId = @inp_iCompanyComplianceOfficerId))
		BEGIN
			SET @out_nReturnValue = @ERR_COMPLIANCEOFFICER_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		SELECT CompanyComplianceOfficerId, CompanyId, ComplianceOfficerName, DesignationId, Address, PhoneNumber, EmailId,
				ApplicableFromDate, ApplicableToDate, StatusCodeId
		FROM com_CompanyComplianceOfficer
		WHERE CompanyComplianceOfficerId = @inp_iCompanyComplianceOfficerId

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_COMPLIANCEOFFICER_GETDETAILS, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
	END CATCH
END

