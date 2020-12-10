IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyComplianceOfficerSave')
DROP PROCEDURE [dbo].[st_com_CompanyComplianceOfficerSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save compliance officers for a company.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		25-Feb-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_mst_CompanyList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_CompanyComplianceOfficerSave]
	@inp_iCompanyComplianceOfficerId	INT
	,@inp_iCompanyID				INT
	,@inp_sComplianceOfficerName	NVARCHAR(100)
	,@inp_iDesignationId			INT
	,@inp_sAddress					NVARCHAR(255)
	,@inp_sPhoneNumber				NVARCHAR(20)
	,@inp_sEmailId					NVARCHAR(255)
	,@inp_iStatusCodeIdID			INT
	,@inp_dtApplicableFromDate		DATETIME
	,@inp_dtApplicableToDate		DATETIME
	,@inp_iLoggedInUserId			INT	-- Id of the user inserting/updating the CompanyFaceValue
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_COMPANYCOMPLIANCEOFFICERS_SAVE INT = 13042 -- Error occurred while saving compliance officer's details for the company.
	DECLARE @ERR_COMPLIANCEOFFIER_NOTFOUND INT = 13043 -- Compliance officer does not exist.
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
		IF @inp_iCompanyComplianceOfficerId IS NULL OR @inp_iCompanyComplianceOfficerId = 0
		BEGIN
			INSERT INTO com_CompanyComplianceOfficer(
					CompanyId, ComplianceOfficerName, DesignationId, Address, PhoneNumber, EmailId,
					ApplicableFromDate, ApplicableToDate, StatusCodeId,
					CreatedBy, CreatedOn, ModifiedBy,	ModifiedOn )
			VALUES (
					@inp_iCompanyID, @inp_sComplianceOfficerName, @inp_iDesignationId, @inp_sAddress, @inp_sPhoneNumber, @inp_sEmailId,
					@inp_dtApplicableFromDate, @inp_dtApplicableToDate, @inp_iStatusCodeIdID,
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate() )
		
			SET @inp_iCompanyComplianceOfficerId = SCOPE_IDENTITY()
		
		END
		ELSE
		BEGIN
			--Check if the CompanyFaceValue whose details are being updated exists
			IF (NOT EXISTS(SELECT CompanyComplianceOfficerId FROM com_CompanyComplianceOfficer WHERE CompanyComplianceOfficerId = @inp_iCompanyComplianceOfficerId))
			BEGIN			
				SET @out_nReturnValue = @ERR_COMPLIANCEOFFIER_NOTFOUND
				RETURN (@out_nReturnValue)
			END
	
			UPDATE com_CompanyComplianceOfficer
			SET 	ComplianceOfficerName = @inp_sComplianceOfficerName,
					DesignationId = @inp_iDesignationId,
					Address = @inp_sAddress,
					PhoneNumber = @inp_sPhoneNumber,
					EmailId = @inp_sEmailId,
					ApplicableFromDate = @inp_dtApplicableFromDate,
					ApplicableToDate = @inp_dtApplicableToDate,
					StatusCodeId = @inp_iStatusCodeIdID,
					ModifiedBy	= @inp_iLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE CompanyComplianceOfficerId = @inp_iCompanyComplianceOfficerId
			
		END
		
		-- in case required to return for partial save case.
		SELECT CompanyComplianceOfficerId, CompanyId, ComplianceOfficerName, DesignationId, Address, PhoneNumber, EmailId,
				ApplicableFromDate, ApplicableToDate, StatusCodeId
		FROM com_CompanyComplianceOfficer
		WHERE CompanyComplianceOfficerId = @inp_iCompanyComplianceOfficerId

	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COMPANYCOMPLIANCEOFFICERS_SAVE
	END CATCH
END
