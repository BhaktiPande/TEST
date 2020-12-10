IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoSave_CO')
DROP PROCEDURE [dbo].[st_usr_UserInfoSave_CO]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the UserInfo details for CO user

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		05-Feb-2015
Modification History:
Modified By		Modified On	Description
Arundhati		6-Feb-2015	
Arundhati		9-Feb-2015	Instead of CompanyNAme, CompanyId is captured.
Arundhati		9-Feb-2015	Code was returning irrespective of whether the record is found or not, so update was not taking place.
Arundhati		11-Feb-2015		Parameter UserINfoId is made OUTPUT, so that for the new record, the actual value can be returned
Arundhati		03-MAr-2015	Error code from authentication procedure is returned as it is
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_usr_UserInfoSave ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserInfoSave_CO] 
	@inp_iUserInfoId		INT	OUTPUT,
    @inp_sEmployeeId		NVARCHAR(50),
	@inp_sEmailId			NVARCHAR(500), -- EmailId
	@inp_sFirstName			NVARCHAR(100),
	@inp_sMiddleName		NVARCHAR(100),
	@inp_sLastName			NVARCHAR(100),
	@inp_sMobileNumber		NVARCHAR(30),	-- MobileNumber
	@inp_iCompanyId			INT,	
	@inp_iStatusCodeId		INT,
    @inp_sLoginID			VARCHAR(100),
    @inp_sPassword			VARCHAR(200),
	--@inp_iUserTypeCodeId	INT,
	@inp_iLoggedInUserId	INT,						-- Id of the user inserting/updating the UserInfo
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_USERINFO_SAVE INT = 11030 -- Error occurred while saving CO user details.
	DECLARE @ERR_USERINFO_NOTFOUND INT = 11025 -- User does not exist.
	DECLARE @nUserTypeCode_CO INT = 101002
	DECLARE @nRetValue INT

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
			INSERT INTO usr_UserInfo(
					EmailId,
					EmployeeId,
					FirstName,
					MiddleName,
					LastName,
					MobileNumber,
					CompanyId,					
					UserTypeCodeId,
					StatusCodeId,
					CreatedBy, CreatedOn, ModifiedBy,ModifiedOn)
			VALUES (
					@inp_sEmailId,
					@inp_sEmployeeId,
					@inp_sFirstName,
					@inp_sMiddleName,
					@inp_sLastName,
					@inp_sMobileNumber,
					@inp_iCompanyId,				
					@nUserTypeCode_CO,
					@inp_iStatusCodeId,
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate() )
					
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
	
			Update usr_UserInfo
			Set 	EmailId	     = @inp_sEmailId,
					EmployeeId	 = @inp_sEmployeeId,
					FirstName	 = @inp_sFirstName,
					MiddleName	 = @inp_sMiddleName,
					LastName	 = @inp_sLastName,
					MobileNumber = @inp_sMobileNumber,
					CompanyId	 = @inp_iCompanyId,					
					--UserTypeCodeId = @inp_iUserTypeCodeId,
					StatusCodeId = @inp_iStatusCodeId,
					ModifiedBy	 = @inp_iLoggedInUserId,
					ModifiedOn	 = getdate()
			Where UserInfoId = @inp_iUserInfoId	
			
		END
		
		---- in case required to return for partial save case.
		--	Select UserInfoId, EmailId, FirstName, MiddleName, LastName, MobileNumber, CompanyName, AddressLine1, AddressLine2, 
		--  CountryId, StateId, City, PinCode, ContactPerson, DateOfJoining, DateOfBecomingInsider, LandLine1, LandLine2, Website, 
		--	PAN, TAN, Description, Category, SubCategory, GradeId, DesignationId, Location, DepartmentId, UPSIAccessOfCompanyID, UserTypeCodeId, 
		--  StatusCodeId
		--	From usr_UserInfo
		--	Where UserInfoId = @inp_iUserInfoId
		
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
			--	SET @out_nReturnValue = 11031
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
		RETURN @out_nReturnValue
	END CATCH
END