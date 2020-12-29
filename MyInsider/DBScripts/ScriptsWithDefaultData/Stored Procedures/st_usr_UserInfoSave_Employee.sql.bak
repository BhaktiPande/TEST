IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoSave_Employee')
DROP PROCEDURE [dbo].[st_usr_UserInfoSave_Employee]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the CR User details

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		05-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		10-Feb-2015		Value for CreatedBy was taken as @inp_iUserInfoId, it is changed to @inp_iLoggedInUserId 
Arundhati		11-Feb-2015		Parameter UserINfoId is made OUTPUT, so that for the new record, the actual value can be returned
Arundhati		03-MAr-2015		Error code from authentication procedure is returned as it is
Arundhati		08-May-2015		Added subdesignation paramater
Tushar			26-May-2015		Insert/Update new column @inp_sDIN add
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_usr_UserInfoSave ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserInfoSave_Employee]
	@inp_iUserInfoId				INT	OUTPUT
	,@inp_iUserTypeCodeID			INT -- 101002	CO User, 101003: Employee, 101004: Corporate User, 101006: Non Employee
    ,@inp_sEmailId					NVARCHAR(250) = null
    ,@inp_sFirstName				NVARCHAR(50) = null
    ,@inp_sMiddleName				NVARCHAR(50) = null
    ,@inp_sLastName					NVARCHAR(50) = null
    ,@inp_sEmployeeId				NVARCHAR(50) = null
    ,@inp_sMobileNumber				NVARCHAR(15) = null
    ,@inp_iCompanyId				INT = null
    ,@inp_sAddressLine1				NVARCHAR(500) = null
    ,@inp_sAddressLine2				NVARCHAR(500) = null
    ,@inp_iCountryId				INT = null
    ,@inp_iStateId					INT = null
    ,@inp_sCity						NVARCHAR(100) = null
    ,@inp_sPinCode					NVARCHAR(50) = null
    ,@inp_dtDateOfJoining			DATETIME = null
    ,@inp_dtDateOfBecomingInsider	DATETIME = null
    ,@inp_sPAN						NVARCHAR(50) = null
    ,@inp_iCategory					INT = null
    ,@inp_iSubCategory				INT = null
    ,@inp_iGradeId					INT = null
    ,@inp_iDesignationId			INT = null
    ,@inp_iSubDesignationId			INT = null
    ,@inp_sLocation					NVARCHAR(50) = null
    ,@inp_iDepartmentId				INT = null
	,@inp_iStatusCodeId				INT
    ,@inp_iLoggedInUserId			INT = null
    ,@inp_sLoginID					VARCHAR(100) = null
    ,@inp_sPassword					VARCHAR(200) = null
    ,@inp_iIsInsider				INT
    ,@inp_sDIN						NVARCHAR(50)
 --   ,@inp_sContactPerson			NVARCHAR(100) = null
 --   ,@inp_sLandLine1				NVARCHAR(50) = null
 --   ,@inp_sLandLine2				NVARCHAR(50) = null
 --   ,@inp_sWebsite					NVARCHAR(500) = null
 --   ,@inp_sTAN						NVARCHAR(50) = null
 --   ,@inp_sDescription				NVARCHAR(1024) = null
 --   ,@inp_iUPSIAccessOfCompanyID	INT = null
 --   ,@inp_iParentId					INT = null
 --   ,@inp_iRelationWithEmployee		INT = null
	,@inp_sResidentTypeId			INT=0
	,@inp_sUIDAI_IdentificationNo	varchar(50)= null
	,@inp_sIdentificationTypeId		INT=0
	,@inp_sAllowUpsiUser			BIT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	AS
AS
BEGIN

	DECLARE @ERR_USERINFO_SAVE INT = 11024 -- Error occurred while saving details for employee.
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
		
		IF(@inp_iCategory=0)
		BEGIN
		SET @inp_iCategory=NULL
		END
		
		IF(@inp_iSubCategory=0)
		BEGIN
		SET @inp_iSubCategory=NULL
		END	


		
		IF @inp_iUserInfoId = 0
		BEGIN
			Insert into usr_UserInfo
			(
				EmailId, FirstName, MiddleName, LastName, EmployeeId, MobileNumber, CompanyId, 
				AddressLine1, AddressLine2, CountryId, StateId, City, PinCode, DateOfJoining, 
				DateOfBecomingInsider, PAN, Category, SubCategory, GradeId, DesignationId, SubDesignationId,
				Location, DepartmentId, IsInsider,UserTypeCodeId,StatusCodeId,DIN,
				CreatedBy, CreatedOn, ModifiedBy,ModifiedOn,ResidentTypeId,UIDAI_IdentificationNo,IdentificationTypeId,AllowUpsiUser
				--, LoginID, Password
				--, ContactPerson, SubCategory, LandLine1, LandLine2, Website, TAN, Description, UPSIAccessOfCompanyID, ParentId, RelationWithEmployee
			)
			Values
			(
				@inp_sEmailId, @inp_sFirstName, @inp_sMiddleName, @inp_sLastName, @inp_sEmployeeId, @inp_sMobileNumber, @inp_iCompanyId,
				@inp_sAddressLine1, @inp_sAddressLine2, @inp_iCountryId, @inp_iStateId, @inp_sCity, @inp_sPinCode, @inp_dtDateOfJoining, 
				@inp_dtDateOfBecomingInsider, @inp_sPAN, @inp_iCategory, @inp_iSubCategory, @inp_iGradeId, @inp_iDesignationId, @inp_iSubDesignationId,
				@inp_sLocation, @inp_iDepartmentId, @inp_iIsInsider, @inp_iUserTypeCodeID, @inp_iStatusCodeId,@inp_sDIN,
				@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate() 
				,@inp_sResidentTypeId,@inp_sUIDAI_IdentificationNo,@inp_sIdentificationTypeId,@inp_sAllowUpsiUser
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
				AddressLine1 = @inp_sAddressLine1,
				AddressLine2 = @inp_sAddressLine2,
				CountryId = @inp_iCountryId,
				StateId = @inp_iStateId,
				City = @inp_sCity,
				PinCode = @inp_sPinCode,
				DateOfJoining = @inp_dtDateOfJoining,
				DateOfBecomingInsider = @inp_dtDateOfBecomingInsider,
				PAN = @inp_sPAN,
				Category = @inp_iCategory,
				SubCategory = @inp_iSubCategory,
				GradeId = @inp_iGradeId,
				DesignationId = @inp_iDesignationId,
				SubDesignationId = @inp_iSubDesignationId,
				Location = @inp_sLocation,
				DepartmentId = @inp_iDepartmentId,
				IsInsider = @inp_iIsInsider,
				--UserTypeCodeId,
				DIN = @inp_sDIN,
				StatusCodeId = @inp_iStatusCodeId,
				ModifiedBy	 = @inp_iLoggedInUserId,
				ModifiedOn	 = dbo.uf_com_GetServerDate(),
				ResidentTypeId=@inp_sResidentTypeId,
				UIDAI_IdentificationNo=@inp_sUIDAI_IdentificationNo,
				IdentificationTypeId=@inp_sIdentificationTypeId,
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


