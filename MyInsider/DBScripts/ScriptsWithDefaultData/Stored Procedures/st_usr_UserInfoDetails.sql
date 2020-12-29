IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoDetails')
DROP PROCEDURE [dbo].[st_usr_UserInfoDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the UserInfo details

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		10-Feb-2015

Modification History:
Modified By		Modified On		Description
Swapnil			10-feb-2015		Added Begin and End where record exist condition is checked.
Arundhati		11-Feb-2015		Removed parameter UserTypeCodeId
Arundhati		12-Feb-2015		Actual codenames are fetched for all codes, Password is included in the output
Arundhati		23-Feb-2015		Query for relative's details is added
Arundhati		24-Feb-2015		Query for Non-Employee is added
Arundhati		26-Feb-2015		Added IsInsider, UserTypeCodeId in output.
Ashish			27-Feb-2015		Added alias as RelationWithEmployee for EmployeeRelationTypeId in User Relation
Arundhati		03-Mar-2015		Company and status is added in the output query for CO details
Tushar			11-Mar-2015		Return LoginID for Corporate User.
Arundhati		16-Mar-2015		Instead of DesignationId, designationtext is stored
Swapnil			20-mAR-2015		Added companyName,stateName and countryname in corporateuser.
Arundhati		04-Apr-2015		Added rolelit in the output
Tushar			26-May-2015		Return new column CIN & DIN
Raghvendra		08-Jul-2015		Added column for companies ISIN number for the user.
Parag			09-Sep-2015		Made change to get flag for if user need to confirm personal details or not
Raghvendra		11-Dec-2015		Added missing UserTypeCodeId in the select when called for Corporate user.
Parag			12-Jan-2016		Made change to fix issue - when details shown from com_code table then first show display code and if not exists then show code 
ED			22-Mar-2016		Code integration with ED code on 22-Mar-2016
ED			05-Oct-2016			Updated the procedure with fix for getting error when fetching user details.
Usage:
EXEC st_usr_UserInfoDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_UserInfoDetails]
	@inp_iUserInfoId		INT,						-- Id of the UserInfo whose details are to be fetched.
	--@inp_iUserTypeCodeID    INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_USERINFO_GETDETAILS INT
	DECLARE @ERR_USERINFO_NOTFOUND INT
	DECLARE @iUserTypeCodeID INT
	DECLARE @nUserType_CO INT = 101002,
			@nUserType_Employee INT = 101003,
			@nUserType_CorporateUser INT = 101004,
			@nUserType_NonEmployee INT = 101006,
			@nUserType_Relative INT = 101007
	DECLARE @sRoles VARCHAR(500) = ''
	
	DECLARE @nConfirm_Personal_Details_Event		INT = 153043

	DECLARE @nReconfirmationDate		 DATETIME = NULL
	DECLARE @nCurrentDateTime			 DATETIME = NULL
	DECLARE @nFrequency			INT = 0

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
		SELECT	@ERR_USERINFO_NOTFOUND = 11025, -- User does not exist.
				@ERR_USERINFO_GETDETAILS = 11034

		--Check if the UserInfo whose details are being fetched exists
		IF (NOT EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId))
		BEGIN
				SET @out_nReturnValue = @ERR_USERINFO_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		-- Set UserType
		SELECT @iUserTypeCodeID = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId
		
		-- Fetch role list of users
		SELECT @sRoles = CONVERT(varchar(10), RoleID) + ',' + @sRoles
		FROM usr_UserRole where UserInfoID = @inp_iUserInfoId
		ORDER BY RoleID desc
		IF LEN(@sRoles) > 1
			SET @sRoles = SUBSTRING(@sRoles, 1, len(@sRoles) - 1)
		
		IF @iUserTypeCodeID = @nUserType_CO
		BEGIN
			Select UI.UserInfoId, UI.EmployeeId, UI.EmailId, UI.FirstName, 
				   UI.MiddleName, UI.LastName, UI.MobileNumber, UI.CompanyId, 				    
				   UI.StatusCodeId ,AUT.LoginID, AUT.Password,
				   CASE WHEN CdStatusCode.DisplayCode IS NULL OR CdStatusCode.DisplayCode = '' THEN CdStatusCode.CodeName ELSE CdStatusCode.DisplayCode END AS StatusCodeName, 
				   C.CompanyName, C.ISINNumber, @sRoles as SubmittedRoleIds,
				   NULL AS IsRequiredConfirmPersonalDetails -- In cas of CO user type no need to confirm perosonal details so set flag to "NULL" for default
			From   usr_UserInfo UI 
				   JOIN com_Code CdStatusCode ON UI.StatusCodeId = CdStatusCode.CodeID
				   JOIN mst_Company C ON UI.CompanyId = C.CompanyId
				   LEFT JOIN usr_Authentication AUT ON UI.UserInfoId = AUT.UserInfoID
			Where  UI.UserInfoId = @inp_iUserInfoId
		END
		ELSE IF @iUserTypeCodeID = @nUserType_Employee
		BEGIN
			SELECT @nCurrentDateTime = GETDATE()
			SELECT @nReconfirmationDate = REConfirmationDate from usr_Reconfirmmation where UserInfoID = @inp_iUserInfoId AND EntryFlag = 1
			select @nFrequency =ReConfirmationFreqId from com_PersonalDetailsConfirmation
			IF(@nReconfirmationDate IS NULL)
			BEGIN
			set @nReconfirmationDate = @nCurrentDateTime
			END
			Select UI.UserInfoId, UI.EmailId, UI.FirstName, UI.MiddleName, UI.LastName, UI.EmployeeId, UI.MobileNumber, UI.CompanyId, 
				   UI.AddressLine1, UI.AddressLine2, UI.CountryId, UI.StateId, UI.City, UI.PinCode, UI.DateOfJoining, UI.Location, 
				   UI.DateOfBecomingInsider,UI.Website, UI.PAN, UI.Description, UI.Category, UI.SubCategory, UI.GradeId, UI.DesignationId, UI.SubDesignationId,
				   UI.DepartmentId, UI.UPSIAccessOfCompanyID, UI.StatusCodeId, AUT.LoginID, AUT.Password,
				   UI.IsInsider, UI.UserTypeCodeId,UI.DoYouHaveDMATEAccountFlag,
				   --DM.DEMATAccountNumber, DM.DPBank, DM.DPID, DM.TMID, DM.Description,
				   --DD.DocumentName, DD.Description, DD.DocumentPath,
				   C.CompanyName,C.ISINNumber, 
				   CASE WHEN CdCategory.DisplayCode IS NULL OR CdCategory.DisplayCode = '' THEN CdCategory.CodeName ELSE CdCategory.DisplayCode END AS CategoryName, 
				   CASE WHEN CdCountry.DisplayCode IS NULL OR CdCountry.DisplayCode = '' THEN CdCountry.CodeName ELSE CdCountry.DisplayCode END AS CountryName,
				   CASE WHEN CdState.DisplayCode IS NULL OR CdState.DisplayCode = '' THEN CdState.CodeName ELSE CdState.DisplayCode END AS StateName, 
				   CASE WHEN CdSubCategory.DisplayCode IS NULL OR CdSubCategory.DisplayCode = '' THEN CdSubCategory.CodeName ELSE CdSubCategory.DisplayCode END AS SubCategoryName, 
				   CASE WHEN CdDepartment.DisplayCode IS NULL OR CdDepartment.DisplayCode = '' THEN CdDepartment.CodeName ELSE CdDepartment.DisplayCode END as DepartmentName, 
				   CASE WHEN CdDesignation.DisplayCode IS NULL OR CdDesignation.DisplayCode = '' THEN CdDesignation.CodeName ELSE CdDesignation.DisplayCode END AS DesignationName, 
				   CASE WHEN CdSubDesignation.DisplayCode IS NULL OR CdSubDesignation.DisplayCode = '' THEN CdSubDesignation.CodeName ELSE CdSubDesignation.DisplayCode END AS SubDesignationName,
				   CASE WHEN CdGrade.DisplayCode IS NULL OR CdGrade.DisplayCode = '' THEN CdGrade.CodeName ELSE CdGrade.DisplayCode END AS GradeName, 
				   CASE WHEN CdStatusCode.DisplayCode IS NULL OR CdStatusCode.DisplayCode = '' THEN CdStatusCode.CodeName ELSE CdStatusCode.DisplayCode END AS StatusCodeName, 
				   @sRoles as SubmittedRoleIds,UI.DIN, UI.ResidentTypeId,UI.UIDAI_IdentificationNo,UI.IdentificationTypeId,
				   CONVERT(bit, CASE WHEN (@nCurrentDateTime > @nReconfirmationDate OR EventLogId IS NULL) AND @nFrequency != 0 THEN 1 ELSE 0 END) AS IsRequiredConfirmPersonalDetails,UI.AllowUpsiUser,
				   ISNULL(UI.IsBlocked,0) as IsBlocked,
				   Rtrim( Ltrim( Blocked_UnBlock_Reason)) as Blocked_UnBlock_Reason, UI.PersonalAddress

				   --CONVERT(bit, CASE WHEN EventLogId IS NOT NULL THEN 1 ELSE 0 END) AS IsRequiredConfirmPersonalDetails
			From   usr_UserInfo UI 
				   LEFT JOIN usr_Authentication AUT ON UI.UserInfoId = AUT.UserInfoID
				   --LEFT JOIN usr_DMATDetails DM		ON UI.UserInfoId = DM.UserInfoID
				   --LEFT JOIN usr_DocumentDetails DD ON UI.UserInfoId = DD.UserInfoID
				   LEFT JOIN mst_Company C ON UI.CompanyId = C.CompanyId
				   LEFT JOIN com_Code CdCategory ON UI.Category = CdCategory.CodeID
				   LEFT JOIN com_Code CdCountry ON UI.CountryId = CdCountry.CodeID
				   LEFT JOIN com_Code CdState ON UI.StateId = CdState.CodeID
				   LEFT JOIN com_Code CdSubCategory ON UI.SubCategory = CdSubCategory.CodeID
				   LEFT JOIN com_Code CdDepartment ON UI.DepartmentId = CdDepartment.CodeID
				   LEFT JOIN com_Code CdDesignation ON UI.DesignationId = CdDesignation.CodeID
				   LEFT JOIN com_Code CdSubDesignation ON UI.SubDesignationId = CdSubDesignation.CodeID
				   LEFT JOIN com_Code CdGrade ON UI.GradeId = CdGrade.CodeID
				   LEFT JOIN com_Code CdStatusCode ON UI.StatusCodeId = CdStatusCode.CodeID
				   LEFT JOIN eve_EventLog ELog ON UI.UserInfoId = ELog.UserInfoId AND ELog.EventCodeId = @nConfirm_Personal_Details_Event
				   LEFT JOIN usr_Reconfirmmation RC ON UI.UserInfoId = RC.UserInfoId
			Where  UI.UserInfoId = @inp_iUserInfoId
		END
		ELSE IF @iUserTypeCodeID = @nUserType_CorporateUser
		BEGIN
			SELECT UI.UserInfoId, UI.EmailId, UI.MobileNumber, UI.CompanyId,C.CompanyName,C.ISINNumber,
				   UI.AddressLine1, UI.AddressLine2, UI.CountryId, 
				   CASE WHEN CdCountry.DisplayCode IS NULL OR CdCountry.DisplayCode = '' THEN CdCountry.CodeName ELSE CdCountry.DisplayCode END AS CountryName, 
				   UI.StateId,  
				   CASE WHEN CdState.DisplayCode IS NULL OR CdState.DisplayCode = '' THEN CdState.CodeName ELSE CdState.DisplayCode END AS StateName,
				   UI.City, UI.PinCode, UI.ContactPerson, 
				   UI.DateOfBecomingInsider, UI.LandLine1, UI.LandLine2, UI.Website, UI.PAN, UI.TAN, UI.Description,AUT.LoginID,
				   UI.DesignationText as DesignationName--UI.DesignationId	
				   , @sRoles as SubmittedRoleIds,UI.CIN,UI.UserTypeCodeId,
				   CONVERT(bit, CASE WHEN EventLogId IS NOT NULL THEN 0 ELSE 1 END) AS IsRequiredConfirmPersonalDetails, CategoryText AS CategoryName, SubCategoryText AS SubCategoryName,UI.AllowUpsiUser
				   ,UI.PersonalAddress
			FROM   usr_UserInfo UI
			LEFT JOIN usr_Authentication AUT ON UI.UserInfoId = AUT.UserInfoID
			LEFT JOIN mst_Company C ON UI.CompanyId = C.CompanyId
			LEFT JOIN com_Code CdCountry ON UI.CountryId = CdCountry.CodeID
			LEFT JOIN com_Code CdState ON UI.StateId = CdState.CodeID
			LEFT JOIN eve_EventLog ELog ON UI.UserInfoId = ELog.UserInfoId AND ELog.EventCodeId = @nConfirm_Personal_Details_Event
			Where  UI.UserInfoId = @inp_iUserInfoId			
		END
		ELSE IF @iUserTypeCodeID = @nUserType_NonEmployee
		BEGIN
			SELECT @nCurrentDateTime = GETDATE()
			SELECT @nReconfirmationDate = REConfirmationDate from usr_Reconfirmmation where UserInfoID = @inp_iUserInfoId AND EntryFlag = 1
			select @nFrequency =ReConfirmationFreqId from com_PersonalDetailsConfirmation
			IF(@nReconfirmationDate IS NULL)
			BEGIN
			set @nReconfirmationDate = @nCurrentDateTime
			END
				Select UI.UserInfoId, UI.EmployeeId, UI.UPSIAccessOfCompanyID, UI.FirstName, UI.MiddleName, UI.LastName, AUT.LoginID, AUT.Password,
				   UI.AddressLine1, UI.AddressLine2, UI.CountryId, UI.StateId, UI.City, UI.PinCode, 
				   UI.EmailId, UI.MobileNumber, UI.CompanyId, UI.PAN, 
				   UI.DateOfJoining, UI.DateOfBecomingInsider, UI.CategoryText AS CategoryName, UI.SubCategoryText AS SubCategoryName,
				   UI.GradeText AS GradeName, UI.DesignationText AS DesignationName, UI.SubDesignationText AS SubDesignationName, UI.DepartmentText AS DepartmentName, UI.Location, UI.StatusCodeId, 
				   C.CompanyName,C.ISINNumber, 
				   CASE WHEN CdStatusCode.DisplayCode IS NULL OR CdStatusCode.DisplayCode = '' THEN CdStatusCode.CodeName ELSE CdStatusCode.DisplayCode END AS StatusCodeName, 
				   CASE WHEN CdCountry.DisplayCode IS NULL OR CdCountry.DisplayCode = '' THEN CdCountry.CodeName ELSE CdCountry.DisplayCode END AS CountryName, 
				   CASE WHEN CdState.DisplayCode IS NULL OR CdState.DisplayCode = '' THEN CdState.CodeName ELSE CdState.DisplayCode END AS StateName,
				   UI.IsInsider, UI.UserTypeCodeId, @sRoles as SubmittedRoleIds,UI.DIN,
				   --CONVERT(bit, CASE WHEN EventLogId IS NOT NULL THEN 1 ELSE 0 END) AS IsRequiredConfirmPersonalDetails	
				    CONVERT(bit, CASE WHEN (@nCurrentDateTime > @nReconfirmationDate OR EventLogId IS NULL) AND @nFrequency != 0 THEN 1 ELSE 0 END) AS IsRequiredConfirmPersonalDetails,UI.AllowUpsiUser
					, UI.PersonalAddress
				   --CdCategory.CodeName AS CategoryName, CdSubCategory.CodeName AS SubCategoryName, 
				   --CdDepartment.CodeName as DepartmentName, CdDesignation.CodeName AS DesignationName,
				   --CdGrade.CodeName AS GradeName
			From   usr_UserInfo UI 
				   LEFT JOIN usr_Authentication AUT ON UI.UserInfoId = AUT.UserInfoID
				   LEFT JOIN mst_Company C ON UI.CompanyId = C.CompanyId
				   --LEFT JOIN com_Code CdCategory ON UI.Category = CdCategory.CodeID
				   LEFT JOIN com_Code CdCountry ON UI.CountryId = CdCountry.CodeID
				   LEFT JOIN com_Code CdState ON UI.StateId = CdState.CodeID
				   --LEFT JOIN com_Code CdSubCategory ON UI.Category = CdSubCategory.CodeID
				   --LEFT JOIN com_Code CdDepartment ON UI.DepartmentId = CdDepartment.CodeID
				   --LEFT JOIN com_Code CdDesignation ON UI.DesignationId = CdDesignation.CodeID
				   --LEFT JOIN com_Code CdGrade ON UI.GradeId = CdGrade.CodeID
				   LEFT JOIN com_Code CdStatusCode ON UI.StatusCodeId = CdStatusCode.CodeID 
				  LEFT JOIN eve_EventLog ELog ON UI.UserInfoId = ELog.UserInfoId AND ELog.EventCodeId = @nConfirm_Personal_Details_Event
				  LEFT JOIN usr_Reconfirmmation RC ON UI.UserInfoId = RC.UserInfoId
			Where  UI.UserInfoId = @inp_iUserInfoId
		END
		ELSE IF @iUserTypeCodeID = @nUserType_Relative
		BEGIN
			SELECT UI.UserInfoId, UI.FirstName, UI.MiddleName, UI.LastName, UI.AddressLine1, UI.AddressLine2, 
				UI.CountryId, UI.StateId, UI.City, UI.PinCode, UI.MobileNumber, UI.EmailId, UI.PAN,
				UR.RelationTypeCodeId, UR.UserInfoId AS ParentId,UI.RelativeStatus,UI.DoYouHaveDMATEAccountFlag,
				NULL AS IsRequiredConfirmPersonalDetails -- In cas of Relative, no need to confirm perosonal details so set flag to "NULL" for default
				,UI.UIDAI_IdentificationNo,UI.IdentificationTypeId
			FROM usr_UserInfo UI JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoIdRelative
			WHERE UI.UserInfoId = @inp_iUserInfoId
		END
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_USERINFO_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

