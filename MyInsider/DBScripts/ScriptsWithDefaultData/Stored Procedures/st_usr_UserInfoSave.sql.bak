IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoSave')
DROP PROCEDURE [dbo].[st_usr_UserInfoSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save user info.

Returns:		0, if Success.
				
Created by:		Swapnil M
Created on:		06-Aug-2010

Modification History:
Modified By		Modified On		Description
Arundhati		09-Feb-2015		CompanyId is used instead of CompanyName
Arundhati		10-Feb-2015		Added call to save corporate user
Arundhati		11-Feb-2015		Parameter UserINfoId is made OUTPUT, so that for the new record, the actual value can be returned
Arundhati		20-Feb-2015		Call to procedure to add relative's record
Arundhati		24-Feb-2015		Added call to save non-employee
Arundhati		12-MAr-2015		Password should not be updated from usersave procedure.
Arundhati		16-Mar-2015		Instead of DesignationId, designationtext is stored for Corporate user
Arundhati		08-May-2015		Added subdesignation paramater
Tushar			26-May-2015		Insert/Update new column @inp_sDIN for Employee/NonEmployee And @inp_sCIN for Corporate Procedure pass
Tushar			06-Jun-2015		EmployeeID and Login ID Uniqueness check add
Tushar			08-Jun-2015		EmployeeID and Login ID Uniqueness check add
Tushar			12-Jun-2015		Change logi for EmployeeID and Login ID Uniqueness check
Gaurishankar	01-Jul-2015		Change for Mantis bug id 7461 : " Email ID, User ID & contact no. should be unique." 
								As per the discussion Employee can be CO AND Insider so added Unique check based on UserType.
ED				22-Mar-2016		Code integration done with ED code on 22-Mar-2016
Raghvendra		31-Mar-2016		Added the code change missed during code merge done on 22-Mar-2016.
Parag			14-Apr-2016		Made change in validation for mobile number. mobile number should be unique among user type except relative. 
								user's relative can have duplicate mobile number or same number same number as of user
Parag			15-Apr-2016		Made change to fix issue of phone number validation 
Parag			02-May-2016		Made change in validation for email same as mobile number
Parag			03-May-2016		Made change to fix in validation for email and mobile number
Raghvendra		04-MAy-2016		Added condition to validate if the duplicate PAN number is not added against a user.
Usage:
EXEC st_role_RoleAssignmentList 2
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserInfoSave]
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
	,@inp_sRelativeStatus			INT = null
	,@inp_sDoYouHaveDMATEAccountFlag INT = null
	,@inp_sSaveNAddDematflag	INT = 0
	,@inp_sResidentTypeId			INT=0
	,@inp_sUIDAI_IdentificationNo	varchar(50)= null
	,@inp_sIdentificationTypeId		INT=0
	,@inp_sAllowUpsiUser			BIT 
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
	DECLARE @ERR_PAN_NUMBER_FOR_DEMAT INT = 50594	
	
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

		IF(@inp_dtDateOfBecomingInsider IS NOT NULL)
		BEGIN
			Declare @inp_dtDateOfBecomingInsiderOnlyDate varchar(50) =Convert(date, @inp_dtDateOfBecomingInsider) 
			SET @inp_dtDateOfBecomingInsider=CONVERT(datetime, @inp_dtDateOfBecomingInsiderOnlyDate)+ convert (varchar,getdate(),108)
		END
		
		IF  (EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE EmployeeId = @inp_sEmployeeId AND (@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0 OR UserInfoId != @inp_iUserInfoId )
				AND UserTypeCodeId = @inp_iUserTypeCodeID ))
		BEGIN
			SET @out_nReturnValue = @ERR_EMPLOYEEID_EXISTS
			RETURN (@out_nReturnValue)
		END
		
		--Check PAN Number Entered or not for demat
		IF  (EXISTS(SELECT UF.PAN, UDEMAT.DEMATAccountNumber FROM usr_UserInfo AS UF INNER JOIN usr_DMATDetails AS UDEMAT ON UF.UserInfoID = UDEMAT.UserInfoId AND UF.UserInfoId = @inp_iUserInfoId ))
		BEGIN
		    IF(@inp_sPAN IS NULL)
		    BEGIN
			   SET @out_nReturnValue = @ERR_PAN_NUMBER_FOR_DEMAT
			   RETURN (@out_nReturnValue)
			END
		END
		-------Check Email Id is exist
		IF (@inp_iUserTypeCodeID = @nUserType_CO)
		BEGIN
			IF EXISTS(SELECT 1 FROM usr_UserInfo WHERE EmailId = @inp_sEmailId AND UserTypeCodeId = @nUserType_CO AND UserInfoId != @inp_iUserInfoId AND (DateOfInactivation IS NULL OR  DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE() AND @inp_iUserInfoId != 0))
				BEGIN	
					SET @out_nReturnValue = @ERR_EMAILID_EXISTS
					RETURN (@out_nReturnValue)	
				END
		END
		ELSE
		BEGIN
			IF(
					EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE EmailId = @inp_sEmailId 
							AND UserTypeCodeId <> @nUserType_Relative AND UserTypeCodeId <> @nUserType_CO AND (@inp_iParentId IS NULL OR @inp_iParentId <> UserInfoId)
							AND (@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0 OR UserInfoId != @inp_iUserInfoId ) AND (DateOfInactivation IS NULL OR DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE() AND @inp_iUserInfoId != 0))
					OR
					EXISTS(SELECT u.UserInfoId FROM usr_UserInfo u 
							JOIN usr_UserRelation ur ON u.UserInfoId = ur.UserInfoIdRelative 
							WHERE EmailId = @inp_sEmailId AND UserTypeCodeId = @nUserType_Relative
							AND (@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0 OR u.UserInfoId != @inp_iUserInfoId ) 
							AND (ur.UserInfoId <> @inp_iParentId) AND (DateOfInactivation IS NULL OR DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE() AND @inp_iUserInfoId!= 0 ))
				)
				BEGIN
					SET @out_nReturnValue = @ERR_EMAILID_EXISTS
					RETURN (@out_nReturnValue)
				END
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
		IF(@inp_iUserTypeCodeID != @nUserType_CO)
		BEGIN
			IF(
				EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE (MobileNumber = @MobNumber_WithCountyCode OR MobileNumber = @MobNumber_WithoutCountyCode)
						AND UserTypeCodeId <> @nUserType_Relative AND  UserTypeCodeId <> @nUserType_CO AND UserInfoId NOT IN (@inp_iUserInfoId) AND (@inp_iParentId IS NULL OR @inp_iParentId <> UserInfoId)
						AND (@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0 OR UserInfoId != @inp_iUserInfoId ) AND (DateOfInactivation IS NULL OR DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE() AND @inp_iUserInfoId!=0))
				OR
				EXISTS(SELECT u.UserInfoId FROM usr_UserInfo u 
						JOIN usr_UserRelation ur ON u.UserInfoId = ur.UserInfoIdRelative 
						WHERE (MobileNumber = @MobNumber_WithCountyCode OR MobileNumber = @MobNumber_WithoutCountyCode) AND UserTypeCodeId = @nUserType_Relative AND ur.UserInfoId NOT IN (@inp_iUserInfoId)
						AND (@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0 OR ur.UserInfoId != @inp_iUserInfoId ) 
						AND (ur.UserInfoId <> ISNULL(@inp_iParentId,0)) AND (DateOfInactivation IS NULL OR DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE() AND @inp_iUserInfoId!=0))
			)
			BEGIN
				SET @out_nReturnValue = @ERR_MOBILENUMBER_EXISTS
				RETURN (@out_nReturnValue)
			END
		END
		ELSE
		BEGIN
			IF(
				EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE (MobileNumber = @MobNumber_WithCountyCode OR MobileNumber = @MobNumber_WithoutCountyCode)
						AND UserTypeCodeId <> @nUserType_Relative AND  UserTypeCodeId <> @nUserType_Employee AND UserInfoId NOT IN (@inp_iUserInfoId) AND (@inp_iParentId IS NULL OR @inp_iParentId <> UserInfoId)
						AND (@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0 OR UserInfoId != @inp_iUserInfoId ) AND (DateOfInactivation IS NULL OR DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE() AND @inp_iUserInfoId!=0))
				OR
				EXISTS(SELECT u.UserInfoId FROM usr_UserInfo u 
						JOIN usr_UserRelation ur ON u.UserInfoId = ur.UserInfoIdRelative 
						WHERE (MobileNumber = @MobNumber_WithCountyCode OR MobileNumber = @MobNumber_WithoutCountyCode) AND UserTypeCodeId = @nUserType_Relative AND ur.UserInfoId NOT IN (@inp_iUserInfoId)
						AND (@inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0 OR ur.UserInfoId != @inp_iUserInfoId ) 
						AND (ur.UserInfoId <> @inp_iParentId) AND (DateOfInactivation IS NULL OR DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE() AND @inp_iUserInfoId!=0))
			)
			BEGIN
				SET @out_nReturnValue = @ERR_MOBILENUMBER_EXISTS
				RETURN (@out_nReturnValue)
			END
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

		--Check if the PAN number entered by user for saving/editing is not assigned to any other user/relative in the system
			IF (@inp_iUserTypeCodeID <> @nUserType_CO AND
			EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE PAN =  @inp_sPAN 
			AND UserInfoID <> @inp_iUserInfoId  AND (DateOfInactivation IS NULL OR DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE() and @inp_iUserInfoId!=0)))
		BEGIN
			SET @out_nReturnValue = @ERR_DUPLICATE_PAN_NUMBER
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
		print(@inp_sSaveNAddDematflag)
		--declare @inp_sSaveNAddDematflag int=0
		IF (@inp_sSaveNAddDematflag IS NULL OR @inp_sSaveNAddDematflag = 0 )
		BEGIN
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
						@inp_iLoggedInUserId, @inp_sLoginID, @inp_sPassword, @inp_iIsInsider,@inp_sDIN,@inp_sResidentTypeId,@inp_sUIDAI_IdentificationNo,@inp_sIdentificationTypeId,@inp_sAllowUpsiUser, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
			END
			ELSE IF @inp_iUserTypeCodeID = @nUserType_CorporateUser
			BEGIN
				-- Call procedure to save Corporate user
				EXEC @nTmpRetVal = st_usr_UserInfoSave_Corporate
						@inp_iUserInfoId OUTPUT, @inp_sEmailId, @inp_iCompanyId, @inp_sAddressLine1, @inp_sAddressLine2,
						@inp_iCountryId, @inp_iStateId, @inp_sCity, @inp_sPinCode, @inp_sContactPerson, @inp_dtDateOfBecomingInsider,
						@inp_sLandLine1, @inp_sLandLine2, @inp_sWebsite, @inp_sPAN, @inp_sTAN, @inp_sDescription, @inp_sDesignationText, -- @inp_iDesignationId,					
						@inp_iLoggedInUserId, @inp_sLoginID, @inp_sPassword,@inp_sCIN,@inp_sCategoryText, @inp_sSubCategoryText,@inp_sAllowUpsiUser,
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
						@inp_iIsInsider, @inp_sLoginID, @inp_sPassword,@inp_sDIN,@inp_sAllowUpsiUser,
						@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
	
			END
			ELSE IF @inp_iUserTypeCodeID = @nUserType_Relative
			BEGIN
				 --Not yet done
				 --For Mass Upload
				IF(@inp_sRelativeStatus IS NULL OR @inp_sDoYouHaveDMATEAccountFlag IS NULL)
				BEGIN
				SET @inp_sRelativeStatus = 102001
				SET @inp_sDoYouHaveDMATEAccountFlag = 1
				END
				EXEC @nTmpRetVal = st_usr_UserInfoSave_Relative
						@inp_iUserInfoId OUTPUT, @inp_iParentId, @inp_sFirstName, @inp_sMiddleName, @inp_sLastName, @inp_sAddressLine1, @inp_sAddressLine2,
						@inp_iCountryId, @inp_iStateId, @inp_sCity, @inp_sPinCode, @inp_sMobileNumber, @inp_sEmailId, @inp_iRelationWithEmployee,
						@inp_sPAN, @inp_iStatusCodeId, @inp_iLoggedInUserId,@inp_sRelativeStatus,@inp_sDoYouHaveDMATEAccountFlag,@inp_sUIDAI_IdentificationNo,@inp_sIdentificationTypeId,
						@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			END
		END
		IF @out_nReturnValue <> 0
		BEGIN
		--print(@out_nReturnValue)
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
