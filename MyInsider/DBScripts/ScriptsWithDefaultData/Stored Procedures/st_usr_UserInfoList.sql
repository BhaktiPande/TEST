IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoList')
DROP PROCEDURE [dbo].[st_usr_UserInfoList]
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
Arundhati		9-Feb-2015		Instead of CompanyNAme, CompanyId is captured.
Arundhati		11-Feb-2015		Error code is corrected for user list
Arundhati		12-Feb-2015		Last name is added in CO search list
Arundhati		28-Apr-2015		Employee list based on UserTypeCodeId
Parag			10-Aug-2015		Made change to add parameter - grid type - for employee list 
Gaurishankar	02-Nov-2015		Employee/Insider List should not display seprated users and added search parameters for User Separation.
Arundhati		09-Dec-2015		Changes for showing Employee Insider as separate type

Usage:
EXEC st_role_RoleAssignmentList 2
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserInfoList]
	@inp_iPageSize INT = 10
	,@inp_iPageNo INT = 1
	,@inp_sSortField VARCHAR(255)
	,@inp_sSortOrder	VARCHAR(5)
	,@inp_iUserTypeCodeID			INT -- 101002	CO User, 101003: Employee, 101004: Corporate User, 101006: Non Employee
    ,@inp_sEmailId					NVARCHAR(250) = null
    ,@inp_sFirstName				NVARCHAR(50) = null
    ,@inp_sMiddleName				NVARCHAR(50) = null
    ,@inp_sLastName					NVARCHAR(50) = null
    ,@inp_sEmployeeId				NVARCHAR(50) = null
    ,@inp_sMobileNumber				NVARCHAR(30) = null
	,@inp_iCompanyId				INT	
    ,@inp_sPAN						NVARCHAR(50) = null
    ,@inp_iCategory					INT = null
    ,@inp_iGradeId					INT = null
    ,@inp_iDesignationId			INT = null
    ,@inp_sLocation					NVARCHAR(50) = null
    ,@inp_iDepartmentId				INT = null
	,@inp_iStatusCodeId				INT
    ,@inp_iLoggedInUserId			INT = null
    ,@inp_sLoginID					VARCHAR(100) = null
    ,@inp_iIsInsider				INT
    ,@inp_nRoleId					INT
	,@inp_nUserTypeCodeId			INT
	,@inp_dtFromDateOfSeparation	DATETIME
	,@inp_dtToDateOfSeparation		DATETIME
	,@inp_dtFromDateOfInactivation	DATETIME
	,@inp_dtToDateOfInactivation	DATETIME
	,@inp_iGridType					INT = null
	,@inp_iIsInsiderFlag			INT = null -- 173001 : Insider, 173002 : Non Insider
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	--,@inp_iUserInfoId				INT
    --,@inp_sAddressLine1				NVARCHAR(500) = null
    --,@inp_sAddressLine2				NVARCHAR(500) = null
    --,@inp_iCountryId				INT = null
    --,@inp_iStateId					INT = null
    --,@inp_sCity						NVARCHAR(100) = null
    --,@inp_sPinCode					NVARCHAR(50) = null
    --,@inp_sContactPerson			NVARCHAR(100) = null
    --,@inp_dtDateOfJoining			DATETIME = null
    --,@inp_dtDateOfBecomingInsider	DATETIME = null
    --,@inp_sLandLine1				NVARCHAR(50) = null
    --,@inp_sLandLine2				NVARCHAR(50) = null
    --,@inp_sWebsite					NVARCHAR(500) = null
    --,@inp_sTAN						NVARCHAR(50) = null
    --,@inp_sDescription				NVARCHAR(1024) = null
    --,@inp_iSubCategory				INT = null
    --,@inp_iUPSIAccessOfCompanyID	INT = null
    --,@inp_iParentId					INT = null
    --,@inp_iRelationWithEmployee		INT = null
    --,@inp_sPassword					VARCHAR(200) = null
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_USER_LIST INT = 11039 -- Error occurred while fetching list of users.
	DECLARE @nUserType_CO INT = 101002,
			@nUserType_Employee INT = 101003,
			@nUserType_CorporateUser INT = 101004,
			@nUserType_NonEmployee INT = 101006,
			@nUserType_Relative INT = 101007
	DECLARE @nTmpRetVal INT


	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		IF @inp_iUserTypeCodeID = @nUserType_CO
		BEGIN
			-- Not yet done
			EXEC @nTmpRetVal = st_usr_UserInfoList_CO
				@inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder, @inp_sEmailId, @inp_sFirstName, @inp_sLastName, @inp_sEmployeeId,
				@inp_iCompanyId, @inp_iStatusCodeId, @inp_sLoginID, @inp_nRoleId,
				@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
			RETURN 0
		END
		ELSE IF @inp_iUserTypeCodeID IN (@nUserType_Employee, @nUserType_CorporateUser, @nUserType_NonEmployee)
		BEGIN
			EXEC @nTmpRetVal = 	st_usr_UserInfoList_Employee
					@inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder, @inp_sEmailId, @inp_sFirstName, @inp_sEmployeeId, @inp_sMobileNumber,
					@inp_iCompanyId, @inp_sPAN, @inp_iCategory, @inp_iGradeId, @inp_iDesignationId, @inp_sLocation, @inp_iDepartmentId, @inp_iStatusCodeId,
					@inp_iLoggedInUserId, @inp_sLoginID, @inp_iIsInsider, @inp_nRoleId, @inp_nUserTypeCodeId, 
					@inp_dtFromDateOfSeparation ,@inp_dtToDateOfSeparation	,@inp_dtFromDateOfInactivation	,@inp_dtToDateOfInactivation, @inp_iGridType,
					@inp_iIsInsiderFlag,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
					
			IF @out_nReturnValue <> 0
			BEGIN
				RETURN @out_nReturnValue
			END
			
		END
		ELSE IF @inp_iUserTypeCodeID = @nUserType_CorporateUser
		BEGIN
			-- Not yet done
			RETURN 0
		END
		ELSE IF @inp_iUserTypeCodeID = @nUserType_NonEmployee
		BEGIN
			-- Not yet done
			RETURN 0
		END
		ELSE IF @inp_iUserTypeCodeID = @nUserType_Relative
		BEGIN
			-- Not yet done
			RETURN 0
		END

		RETURN 0

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_USER_LIST
	END CATCH
END
