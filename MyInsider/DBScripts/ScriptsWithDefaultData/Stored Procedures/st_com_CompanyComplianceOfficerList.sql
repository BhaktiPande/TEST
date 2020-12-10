IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyComplianceOfficerList')
DROP PROCEDURE [dbo].[st_com_CompanyComplianceOfficerList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list compliance officers for a company.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		22-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		26-Feb-2015		Column aliases are corrected
Usage:
EXEC st_mst_CompanyList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_CompanyComplianceOfficerList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_iCompanyID				INT
	,@inp_sComplianceOfficerName	NVARCHAR(100)
	,@inp_iDesignationId			INT
	,@inp_sAddress					NVARCHAR(255)
	,@inp_sPhoneNumber				NVARCHAR(20)
	,@inp_sEmailId					NVARCHAR(255)
	,@inp_iStatusCodeIdID			INT
	,@inp_dtApplicableFromDate_Lower	DATETIME
	,@inp_dtApplicableFromDate_Upper	DATETIME
	,@inp_dtApplicableToDate_Lower	DATETIME
	,@inp_dtApplicableToDate_Upper	DATETIME
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_COMPANYCOMPLIANCEOFFICERS_LIST INT = 13026 -- Error occurred while fetching list of listing details for the company.

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
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'CC.ComplianceOfficerName '
		END 

		IF @inp_sSortField = 'cmp_grd_13027' --'Name'
		BEGIN 
			SELECT @inp_sSortField = 'CC.ComplianceOfficerName '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13028' -- 'Designation'
		BEGIN 
			SELECT @inp_sSortField = 'CDesignation.CodeName '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13029' -- 'Phone'
		BEGIN 
			SELECT @inp_sSortField = 'CC.PhoneNumber '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13030' -- 'Email ID'
		BEGIN 
			SELECT @inp_sSortField = 'CC.EmailId '
		END 

		IF @inp_sSortField = 'cmp_grd_13031' -- 'Address'
		BEGIN 
			SELECT @inp_sSortField = 'CC.Address '
		END 
		
		IF @inp_sSortField = 'cmp_grd_13032' -- 'Status'
		BEGIN 
			SELECT @inp_sSortField = 'CStatus.CodeName '
		END
		
		IF @inp_sSortField = 'cmp_grd_13033' -- 'Applicable From'
		BEGIN 
			SELECT @inp_sSortField = 'CC.ApplicableFromDate '
		END
		
		IF @inp_sSortField = 'cmp_grd_13034' -- 'Applicable To'
		BEGIN 
			SELECT @inp_sSortField = 'CC.ApplicableToDate '
		END 
		
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',CC.CompanyComplianceOfficerId),CC.CompanyComplianceOfficerId '
		SELECT @sSQL = @sSQL + ' FROM com_CompanyComplianceOfficer CC '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CStatus ON CC.StatusCodeId = CStatus.CodeID '		
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDesignation ON CC.DesignationId = CDesignation.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 AND CC.CompanyID = ' + CAST(@inp_iCompanyID AS VARCHAR(10)) + ' '

		IF (@inp_sComplianceOfficerName IS NOT NULL AND @inp_sComplianceOfficerName <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CC.ComplianceOfficerName = '''  + @inp_sComplianceOfficerName + ''' '
		END

		IF (@inp_sAddress IS NOT NULL AND @inp_sAddress <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CC.Address = '''  + @inp_sAddress + ''' '
		END

		IF (@inp_sPhoneNumber IS NOT NULL AND @inp_sPhoneNumber <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CC.PhoneNumber = '''  + @inp_sPhoneNumber + ''' '
		END

		IF (@inp_sEmailId IS NOT NULL AND @inp_sEmailId <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CC.EmailId = '''  + @inp_sEmailId + ''' '
		END

		IF (@inp_iDesignationId IS NOT NULL AND @inp_iDesignationId <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CC.DesignationId = '  + cast(@inp_iDesignationId AS VARCHAR(11)) + ' '
		END

		IF (@inp_iStatusCodeIdID IS NOT NULL AND @inp_iStatusCodeIdID <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CC.StatusCodeId = '  + cast(@inp_iStatusCodeIdID AS VARCHAR(11)) + ' '
		END

		IF (@inp_dtApplicableFromDate_Lower IS NOT NULL AND @inp_dtApplicableFromDate_Lower <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CC.ApplicableFromDate >= '''  + cast(@inp_dtApplicableFromDate_Lower AS VARCHAR(11)) + ''''
		END

		IF (@inp_dtApplicableFromDate_Upper IS NOT NULL AND @inp_dtApplicableFromDate_Upper <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CC.ApplicableFromDate <= '''  + cast(@inp_dtApplicableFromDate_Upper AS VARCHAR(11)) + ''''
		END

		IF (@inp_dtApplicableToDate_Lower IS NOT NULL AND @inp_dtApplicableToDate_Lower <> 0 )
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CC.ApplicableToDate >= '  + CAST(@inp_dtApplicableToDate_Lower AS VARCHAR(20)) 
		END

		IF (@inp_dtApplicableToDate_Upper IS NOT NULL AND @inp_dtApplicableToDate_Upper <> 0 )
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CC.ApplicableToDate <= '  + CAST(@inp_dtApplicableToDate_Upper AS VARCHAR(20)) 
		END
		
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	CC.CompanyComplianceOfficerId,
				CC.ComplianceOfficerName AS cmp_grd_13027,
				CDesignation.CodeName AS cmp_grd_13028,
				CC.PhoneNumber AS cmp_grd_13029,
				CC.EmailId AS cmp_grd_13030,
				CC.Address AS cmp_grd_13031,
				CStatus.CodeName AS cmp_grd_13032,
				CC.ApplicableFromDate AS cmp_grd_13033,
				CC.ApplicableToDate AS cmp_grd_13034
		FROM	#tmpList T INNER JOIN
				com_CompanyComplianceOfficer CC ON CC.CompanyComplianceOfficerId = T.EntityID
				LEFT JOIN com_Code CDesignation ON CC.DesignationId = CDesignation.CodeID
				JOIN com_Code CStatus ON CC.StatusCodeId = CStatus.CodeID
		WHERE   CC.CompanyComplianceOfficerId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COMPANYCOMPLIANCEOFFICERS_LIST
	END CATCH
END
