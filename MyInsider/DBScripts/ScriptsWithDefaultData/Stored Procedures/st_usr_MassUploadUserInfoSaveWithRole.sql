IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_MassUploadUserInfoSaveWithRole')
DROP PROCEDURE [dbo].[st_usr_MassUploadUserInfoSaveWithRole]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save user info with role id from Mass Upload functionality.

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		23-Sep-2015

Modification History:
Modified By		Modified On		Description
Usage:
EXEC st_usr_MassUploadUserInfoSaveWithRole 2
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_MassUploadUserInfoSaveWithRole]
	@inp_iUserInfoId				INT
	,@inp_iUserTypeCodeID			INT -- 101002	CO User, 101003: Employee, 101004: Corporate User, 101006: Non Employee
    ,@inp_sEmailId					NVARCHAR(250) = null
    ,@inp_sFirstName				NVARCHAR(50) = null
    ,@inp_sMiddleName				NVARCHAR(50) = null
    ,@inp_sLastName					NVARCHAR(50) = null
    ,@inp_sEmployeeId				NVARCHAR(50) = null
    ,@inp_sMobileNumber				NVARCHAR(15) = null
	,@inp_iCompanyId				INT	
    ,@inp_sAddressLine1				NVARCHAR(500) = null
    ,@inp_sAddressLine2				NVARCHAR(500) = null
    ,@inp_iCountryId				INT = null
    ,@inp_iStateId					INT = null
    ,@inp_sCity						NVARCHAR(100) = null
    ,@inp_sPinCode					NVARCHAR(50) = null
    ,@inp_sContactPerson			NVARCHAR(100) = null
    ,@inp_dtDateOfJoining			DATETIME = null
    ,@inp_dtDateOfBecomingInsider	DATETIME = null
    ,@inp_sLandLine1				NVARCHAR(50) = null
    ,@inp_sLandLine2				NVARCHAR(50) = null
    ,@inp_sWebsite					NVARCHAR(500) = null
    ,@inp_sPAN						NVARCHAR(50) = null
    ,@inp_sTAN						NVARCHAR(50) = null
    ,@inp_sDescription				NVARCHAR(1024) = null
    ,@inp_iCategory					INT = null
    ,@inp_iSubCategory				INT = null
    ,@inp_iGradeId					INT = null
    ,@inp_iDesignationId			INT = null
    ,@inp_iSubDesignationId			INT = null
    ,@inp_sLocation					NVARCHAR(50) = null
    ,@inp_iDepartmentId				INT = null
    ,@inp_iUPSIAccessOfCompanyID	INT = null
    ,@inp_iParentId					INT = null
    ,@inp_iRelationWithEmployee		INT = null
	,@inp_iStatusCodeId				INT
    ,@inp_sCategoryText				NVARCHAR(100) = null
    ,@inp_sSubCategoryText			NVARCHAR(100) = null
    ,@inp_sGradeText				NVARCHAR(100) = null
    ,@inp_sDesignationText			NVARCHAR(100) = null
    ,@inp_sSubDesignationText		NVARCHAR(100) = null
    ,@inp_sDepartmentText			NVARCHAR(100) = null
    ,@inp_iLoggedInUserId			INT = null
    ,@inp_sLoginID					VARCHAR(100) = null
    ,@inp_sPassword					VARCHAR(200) = null
    ,@inp_iIsInsider				INT
    ,@inp_sCIN						NVARCHAR(50)
    ,@inp_sDIN						NVARCHAR(50)
    ,@inp_sRoleId					VARCHAR(500)
	,@inp_sPersonalAddress  		VARCHAR(50)= null
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	

AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_USER_SAVE INT = 11029
	DECLARE @nUserType_CO INT = 101002,
			@nUserType_Employee INT = 101003,
			@nUserType_CorporateUser INT = 101004,
			@nUserType_NonEmployee INT = 101006,
			@nUserType_Relative INT = 101007,
			@ERR_EMPLOYEEID_EXISTS INT = 11261,
			@ERR_LOGINID_EXISTS INT = 11262,
			@ERR_EMAILID_EXISTS INT = 11268,
			@ERR_MOBILENUMBER_EXISTS INT = 11269,
			@ERR_DUPLICATE_PAN_NUMBER INT = 11440	
	DECLARE @nTmpRetVal INT = 0
	DECLARE @DBNAME VARCHAR(100) = UPPER((SELECT DB_NAME()))
	DECLARE @FIND_YESBANK VARCHAR(50) = 'YESBANK'	
	
	DECLARE @UserMobNumber NVARCHAR(50)
	DECLARE @MobNumMaxLength INT = 15
	DECLARE @MobNumLenWithCounrtyCode INT = 13
	DECLARE @MobNumSplitContryCode INT = 4
	DECLARE @CountryCode NVARCHAR(50)='+91'
	DECLARE @MobNumber_WithoutCountyCode NVARCHAR(50)
	DECLARE @MobNumber_WithCountyCode NVARCHAR(50)	
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF @inp_Iuserinfoid=0
		BEGIN 
			SELECT @inp_iUserInfoId=isnull(userinfoid,0) from usr_userinfo where employeeid=@Inp_sEmployeeid
		END
		
		IF  (EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE EmployeeId = @inp_sEmployeeId AND (@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0 OR UserInfoId != @inp_iUserInfoId )
				AND UserTypeCodeId = @inp_iUserTypeCodeID ))
		BEGIN
			SET @out_nReturnValue = @ERR_EMPLOYEEID_EXISTS
			RETURN (@out_nReturnValue)
		END
		
		IF  (EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE EmailId = @inp_sEmailId AND (@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0 OR UserInfoId != @inp_iUserInfoId )
				AND UserTypeCodeId = @inp_iUserTypeCodeID AND (DateOfInactivation IS NULL OR DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE())))
		BEGIN
			SET @out_nReturnValue = @ERR_EMAILID_EXISTS
			RETURN (@out_nReturnValue)
		END		

		IF  (EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE PAN = @inp_sPAN AND (@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0 OR UserInfoId != @inp_iUserInfoId )
				AND UserTypeCodeId = @inp_iUserTypeCodeID AND (DateOfInactivation IS NULL OR DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE())))
		BEGIN
			SET @out_nReturnValue = @ERR_DUPLICATE_PAN_NUMBER
			RETURN (@out_nReturnValue)
		END
		
		--Check Mobile Number with or without country code
		SET @UserMobNumber = @inp_sMobileNumber
        IF(LEN(@UserMobNumber)= @MobNumLenWithCounrtyCode)
        BEGIN
          SET @MobNumber_WithoutCountyCode = SUBSTRING(@UserMobNumber,@MobNumSplitContryCode,@MobNumMaxLength)
          SET @MobNumber_WithCountyCode = @UserMobNumber
        END
        ELSE
        BEGIN
          SET @MobNumber_WithoutCountyCode = @UserMobNumber
          SET @MobNumber_WithCountyCode = @CountryCode + @UserMobNumber
        END
		
		IF(CHARINDEX(@FIND_YESBANK,@DBNAME) = 0)
		BEGIN
			IF(
				EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE (MobileNumber = @MobNumber_WithCountyCode OR MobileNumber = @MobNumber_WithoutCountyCode)
						AND UserTypeCodeId <> @nUserType_Relative AND UserTypeCodeId <> @nUserType_CO AND UserInfoId NOT IN (@inp_iUserInfoId) AND (@inp_iParentId IS NULL OR @inp_iParentId <> UserInfoId)
						AND (@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0 OR UserInfoId != @inp_iUserInfoId ) AND (DateOfInactivation IS NULL OR DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE()))
				
			)
			BEGIN
				SET @out_nReturnValue = @ERR_MOBILENUMBER_EXISTS
				RETURN (@out_nReturnValue)
			END
		END
		
		IF (((@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0) AND
			EXISTS(SELECT UserInfoId FROM usr_Authentication WHERE LoginID =  @inp_sLoginID))
			OR ((@inp_iUserInfoId IS NOT NULL OR @inp_iUserInfoId > 0) AND 
			EXISTS(SELECT UserInfoId FROM usr_Authentication WHERE LoginID =  @inp_sLoginID 
			AND UserInfoID <> @inp_iUserInfoId))) 
		BEGIN
			SET @out_nReturnValue = @ERR_LOGINID_EXISTS
			RETURN (@out_nReturnValue)
		END
		
		SET @inp_sPassword = NULL
		IF @inp_iUserInfoId = 0
		BEGIN
			SET @inp_sPassword = ''
		END
		ELSE
		BEGIN
			SELECT @inp_sPassword = Password FROM usr_Authentication WHERE UserInfoID = @inp_iUserInfoId
		END
				
		IF @inp_iUserTypeCodeID = @nUserType_CO
		BEGIN
			-- Call procedure to save CO user
			EXEC @nTmpRetVal = st_usr_UserInfoSave_CO 
				@inp_iUserInfoId OUTPUT, @inp_sEmployeeId, @inp_sEmailId, @inp_sFirstName, @inp_sMiddleName, @inp_sLastName, @inp_sMobileNumber,
				@inp_iCompanyId, @inp_iStatusCodeId, @inp_sLoginID, @inp_sPassword, @inp_iLoggedInUserId,	
				@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
		END
		ELSE IF @inp_iUserTypeCodeID = @nUserType_Employee
		BEGIN		
			-- Call procedure to save Employee user
			EXEC @nTmpRetVal = st_usr_UserInfoSave_Employee
					@inp_iUserInfoId OUTPUT, @inp_iUserTypeCodeID, @inp_sEmailId, @inp_sFirstName, @inp_sMiddleName, @inp_sLastName, @inp_sEmployeeId, @inp_sMobileNumber, @inp_iCompanyId,
					@inp_sAddressLine1, @inp_sAddressLine2, @inp_iCountryId, @inp_iStateId, @inp_sCity, @inp_sPinCode, @inp_dtDateOfJoining, @inp_dtDateOfBecomingInsider,
					@inp_sPAN, @inp_iCategory, @inp_iSubCategory, @inp_iGradeId, @inp_iDesignationId, @inp_iSubDesignationId, @inp_sLocation, @inp_iDepartmentId, @inp_iStatusCodeId, 
					@inp_iLoggedInUserId, @inp_sLoginID, @inp_sPassword, @inp_iIsInsider,@inp_sDIN, 
					NULL,NULL,NULL,0,@inp_sPersonalAddress,   
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
 	
		END
		ELSE IF @inp_iUserTypeCodeID = @nUserType_CorporateUser
		BEGIN
			-- Call procedure to save Corporate user
			EXEC @nTmpRetVal = st_usr_UserInfoSave_Corporate
					@inp_iUserInfoId OUTPUT, @inp_sEmailId, @inp_iCompanyId, @inp_sAddressLine1, @inp_sAddressLine2,
					@inp_iCountryId, @inp_iStateId, @inp_sCity, @inp_sPinCode, @inp_sContactPerson, @inp_dtDateOfBecomingInsider,
					@inp_sLandLine1, @inp_sLandLine2, @inp_sWebsite, @inp_sPAN, @inp_sTAN, @inp_sDescription, @inp_sDesignationText, -- @inp_iDesignationId,					
					@inp_iLoggedInUserId, @inp_sLoginID, @inp_sPassword,@inp_sCIN, @inp_sCategoryText, @inp_sSubCategoryText,0,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
				
		END
		ELSE IF @inp_iUserTypeCodeID = @nUserType_NonEmployee
		BEGIN
			EXEC @nTmpRetVal = st_usr_UserInfoSave_NonEmployee
					@inp_iUserInfoId OUTPUT, @inp_iUserTypeCodeID, @inp_sEmployeeId, @inp_iCompanyId, @inp_iUPSIAccessOfCompanyID,
					@inp_sFirstName, @inp_sMiddleName, @inp_sLastName, @inp_sAddressLine1, @inp_sAddressLine2, @inp_iCountryId,
					@inp_iStateId, @inp_sCity, @inp_sPinCode, @inp_sMobileNumber, @inp_sEmailId, @inp_sPAN, @inp_dtDateOfJoining,
					@inp_dtDateOfBecomingInsider, @inp_sCategoryText, @inp_sSubCategoryText, @inp_sGradeText, @inp_sDesignationText,
					@inp_sSubDesignationText, @inp_sLocation, @inp_sDepartmentText, @inp_iStatusCodeId, @inp_iLoggedInUserId,
					@inp_iIsInsider, @inp_sLoginID, @inp_sPassword,@inp_sDIN,0,@inp_sPersonalAddress, 
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
					
		END
		ELSE IF @inp_iUserTypeCodeID = @nUserType_Relative
		BEGIN
			-- Not yet done
			EXEC @nTmpRetVal = st_usr_UserInfoSave_Relative
					@inp_iUserInfoId OUTPUT, @inp_iParentId, @inp_sFirstName, @inp_sMiddleName, @inp_sLastName, @inp_sAddressLine1, @inp_sAddressLine2,
					@inp_iCountryId, @inp_iStateId, @inp_sCity, @inp_sPinCode, @inp_sMobileNumber, @inp_sEmailId, @inp_iRelationWithEmployee,
					@inp_sPAN, @inp_iStatusCodeId, @inp_iLoggedInUserId,102001,1,NULL,NULL,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		END

		IF @out_nReturnValue <> 0
		BEGIN
			RETURN @out_nReturnValue
		END
		ELSE
		BEGIN
			EXEC st_usr_UserRoleSave @inp_iUserInfoID,@inp_sRoleId,@inp_iLoggedInUserId,@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
		END
		
		IF @out_nReturnValue <> 0
		BEGIN
			RETURN @out_nReturnValue
		END
		
		SELECT @inp_iUserInfoId AS UserInfoId
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_USER_SAVE,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
