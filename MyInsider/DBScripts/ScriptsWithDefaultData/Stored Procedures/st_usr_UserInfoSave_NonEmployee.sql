IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoSave_NonEmployee')
DROP PROCEDURE [dbo].[st_usr_UserInfoSave_NonEmployee]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the non-employee User details

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		24-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		03-MAr-2015		Error code from authentication procedure is returned as it is
Tushar			26-May-2015		Insert/Update new column @inp_sDIN add
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_usr_UserInfoSave ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserInfoSave_NonEmployee]
	@inp_iUserInfoId				INT	OUTPUT
	,@inp_iUserTypeCodeID			INT -- 101002	CO User, 101003: Employee, 101004: Corporate User, 101006: Non Employee
	,@inp_sEmployeeId				NVARCHAR(50) = null
    ,@inp_iCompanyId				INT = null
    ,@inp_iUPSIAccessOfCompanyID	INT = null
    ,@inp_sFirstName				NVARCHAR(50) = null
    ,@inp_sMiddleName				NVARCHAR(50) = null
    ,@inp_sLastName					NVARCHAR(50) = null
    ,@inp_sAddressLine1				NVARCHAR(500) = null
    ,@inp_sAddressLine2				NVARCHAR(500) = null
    ,@inp_iCountryId				INT = null
    ,@inp_iStateId					INT = null
    ,@inp_sCity						NVARCHAR(100) = null
    ,@inp_sPinCode					NVARCHAR(50) = null
    ,@inp_sMobileNumber				NVARCHAR(15) = null
    ,@inp_sEmailId					NVARCHAR(250) = null
    ,@inp_sPAN						NVARCHAR(50) = null
    ,@inp_dtDateOfJoining			DATETIME = null
    ,@inp_dtDateOfBecomingInsider	DATETIME = null    
    ,@inp_sCategoryText				NVARCHAR(100) = null
    ,@inp_sSubCategoryText			NVARCHAR(100) = null
    ,@inp_sGradeText				NVARCHAR(100) = null
    ,@inp_sDesignationText			NVARCHAR(100) = null
    ,@inp_sSubDesignationText		NVARCHAR(100) = null
    ,@inp_sLocation					NVARCHAR(50) = null
    ,@inp_sDepartmentText			NVARCHAR(100) = null
	,@inp_iStatusCodeId				INT
    ,@inp_iLoggedInUserId			INT = null
    ,@inp_iIsInsider				INT
    ,@inp_sLoginID					VARCHAR(100) = null
    ,@inp_sPassword					VARCHAR(200) = null
	,@inp_sDIN						NVARCHAR(50)
	,@inp_sAllowUpsiUser			BIT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	AS
AS
BEGIN

	DECLARE @ERR_USERINFO_SAVE INT = 11202 -- Error occurred while saving details for employee.
	DECLARE @ERR_USERINFO_NOTFOUND INT = 11025 -- User does not exist
	DECLARE @ERR_LOGINALREADYEXISTS INT = 11028 -- Error occurred while saving login details for employee.
	--DECLARE @nUserTypeCode_Employee INT = 101006
	
	DECLARE @nRetValue INT = 0

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Save the UserInfo details
		IF @inp_iUserInfoId = 0
		BEGIN
			Insert into usr_UserInfo
			(
				EmailId, FirstName, MiddleName, LastName, EmployeeId, MobileNumber, CompanyId, UPSIAccessOfCompanyID,
				AddressLine1, AddressLine2, CountryId, StateId, City, PinCode, DateOfJoining, 
				DateOfBecomingInsider, PAN, CategoryText, SubCategoryText, GradeText, DesignationText, SubDesignationText,
				Location, DepartmentText, IsInsider, UserTypeCodeId, StatusCodeId,DIN,AllowUpsiUser,
				CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
			)
			Values
			(
				@inp_sEmailId, @inp_sFirstName, @inp_sMiddleName, @inp_sLastName, @inp_sEmployeeId, @inp_sMobileNumber, @inp_iCompanyId, @inp_iUPSIAccessOfCompanyID,
				@inp_sAddressLine1, @inp_sAddressLine2, @inp_iCountryId, @inp_iStateId, @inp_sCity, @inp_sPinCode, @inp_dtDateOfJoining, 
				@inp_dtDateOfBecomingInsider, @inp_sPAN, @inp_sCategoryText, @inp_sSubCategoryText, @inp_sGradeText, @inp_sDesignationText, @inp_sSubDesignationText,
				@inp_sLocation, @inp_sDepartmentText, @inp_iIsInsider, @inp_iUserTypeCodeID, @inp_iStatusCodeId,@inp_sDIN,@inp_sAllowUpsiUser,
				@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate() 
			)
			
			SET @inp_iUserInfoId = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			--Check if the UserInfo whose details are being updated exists
			IF (NOT EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId))
			BEGIN		
				SET @out_nReturnValue = @ERR_USERINFO_NOTFOUND
				RETURN (@out_nReturnValue)
			END
	
			UPDATE usr_UserInfo
			SET EmailId = @inp_sEmailId,
				FirstName = @inp_sFirstName,
				MiddleName = @inp_sMiddleName,
				LastName = @inp_sLastName,
				EmployeeId = @inp_sEmployeeId,
				MobileNumber = @inp_sMobileNumber,
				CompanyId = @inp_iCompanyId,
				UPSIAccessOfCompanyID = @inp_iUPSIAccessOfCompanyID,
				AddressLine1 = @inp_sAddressLine1,
				AddressLine2 = @inp_sAddressLine2,
				CountryId = @inp_iCountryId,
				StateId = @inp_iStateId,
				City = @inp_sCity,
				PinCode = @inp_sPinCode,
				DateOfJoining = @inp_dtDateOfJoining,
				DateOfBecomingInsider = @inp_dtDateOfBecomingInsider,
				PAN = @inp_sPAN,
				CategoryText = @inp_sCategoryText,
				SubCategoryText = @inp_sSubCategoryText,
				GradeText = @inp_sGradeText,
				DesignationText = @inp_sDesignationText,
				SubDesignationText = @inp_sSubDesignationText,
				Location = @inp_sLocation,
				DepartmentText = @inp_sDepartmentText,
				IsInsider = @inp_iIsInsider,
				--UserTypeCodeId,
				StatusCodeId = @inp_iStatusCodeId,
				DIN = @inp_sDIN,
				ModifiedBy	 = @inp_iLoggedInUserId,
				ModifiedOn	 = dbo.uf_com_GetServerDate(),
				AllowUpsiUser=@inp_sAllowUpsiUser
			WHERE UserInfoId = @inp_iUserInfoId	
			
		END
		
		EXEC @nRetValue = st_usr_AuthenticationSave
				@inp_iUserInfoId
				,@inp_sLoginId
				,@inp_sPassword
				,@inp_iLoggedInUserId
				,@out_nReturnValue OUTPUT
				,@out_nSQLErrCode OUTPUT
				,@out_sSQLErrMessage OUTPUT
						
		IF @out_nReturnValue <> 0
		BEGIN
			--IF @out_nReturnValue = 11027
			--BEGIN
			--	SET @out_nReturnValue = 11028
			--END				
			RETURN @out_nReturnValue
		END

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_USERINFO_SAVE, ERROR_NUMBER())
	END CATCH
END
GO


