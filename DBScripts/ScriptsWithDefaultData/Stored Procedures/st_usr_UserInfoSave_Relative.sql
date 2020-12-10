IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoSave_Relative')
DROP PROCEDURE [dbo].[st_usr_UserInfoSave_Relative]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the UserInfo details for relative. Also add/update record in Relationship table.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		20-Feb-2015
Modification History:
Modified By		Modified On	Description
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_usr_UserInfoSave ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserInfoSave_Relative] 
	@inp_iUserInfoId		INT	OUTPUT,
    @inp_iParentId			INT,
	@inp_sFirstName			NVARCHAR(100),
	@inp_sMiddleName		NVARCHAR(100),
	@inp_sLastName			NVARCHAR(100),
    @inp_sAddressLine1		NVARCHAR(500),
    @inp_sAddressLine2		NVARCHAR(500),
    @inp_iCountryId			INT,
    @inp_iStateId			INT,
    @inp_sCity				NVARCHAR(100),
    @inp_sPinCode			NVARCHAR(50),
	@inp_sMobileNumber		NVARCHAR(30),	-- MobileNumber    
	@inp_sEmailId			NVARCHAR(500), -- EmailId
    @inp_iRelationWithEmployee	INT,
    @inp_sPAN				NVARCHAR(50),
	@inp_iStatusCodeId		INT,
	@inp_iLoggedInUserId	INT,						-- Id of the user inserting/updating the UserInfo
	@inp_sRelativeStatus	INT,
	@inp_sDoYouHaveDMATEAccountFlag INT,
	@inp_sUIDAI_IdentificationNo	varchar(50)= null,
	@inp_sIdentificationTypeId		INT=0,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_USERRELATIONINFO_SAVE INT = 11092 -- Error occurred while saving relative's details.
	DECLARE @ERR_USERINFO_NOTFOUND INT = 11025 -- User does not exist.
	DECLARE @ERR_USERISNOTVALIDFORADDINGRELATIVE INT = 11093 -- User must be of type Employee / Non-employee, to add a relative's data

	DECLARE @nUserTypeCode_Employee INT = 101003
	DECLARE @nUserTypeCode_NonEmployee INT = 101006
	DECLARE @nUserTypeCode_Relative INT = 101007
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
		-- Check that the user exists for which the relative's record is to be added
		IF ((@inp_iUserInfoId <> 0 AND NOT EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId))
			OR NOT EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iParentId))
		BEGIN		
			SET @out_nReturnValue = @ERR_USERINFO_NOTFOUND
			RETURN (@out_nReturnValue)
		END

		-- Check the type of user is Employee or non employee for which the relative's record is being added
		IF (NOT EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iParentId 
						AND (UserTypeCodeId = @nUserTypeCode_Employee OR UserTypeCodeId = @nUserTypeCode_NonEmployee)))
		BEGIN		
			SET @out_nReturnValue = @ERR_USERISNOTVALIDFORADDINGRELATIVE
			RETURN (@out_nReturnValue)
		END
		
		IF @inp_iUserInfoId = 0
		BEGIN
			INSERT INTO usr_UserInfo(
					FirstName,
					MiddleName,
					LastName,
					AddressLine1,
					AddressLine2,
					CountryId,
					StateId,
					City,
					PinCode,
					MobileNumber,
					EmailId,
					PAN,
					UserTypeCodeId,
					StatusCodeId,
					IsInsider,
					CreatedBy, CreatedOn, ModifiedBy,ModifiedOn,RelativeStatus,DoYouHaveDMATEAccountFlag,UIDAI_IdentificationNo,IdentificationTypeId)
			VALUES (
			
					@inp_sFirstName,
					@inp_sMiddleName,
					@inp_sLastName,
					@inp_sAddressLine1,
					@inp_sAddressLine2,
					@inp_iCountryId,
					@inp_iStateId,
					@inp_sCity,
					@inp_sPinCode,
					@inp_sMobileNumber,
					@inp_sEmailId,
					@inp_sPAN,
					@nUserTypeCode_Relative,
					@inp_iStatusCodeId,
					0,
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate(),@inp_sRelativeStatus,@inp_sDoYouHaveDMATEAccountFlag,@inp_sUIDAI_IdentificationNo,@inp_sIdentificationTypeId)
					
			SET @inp_iUserInfoId = SCOPE_IDENTITY()
			

		END
		ELSE
		BEGIN
			--Check if the UserInfo whose details are being updated exists
	
			Update usr_UserInfo
			Set 	FirstName	 = @inp_sFirstName,
					MiddleName	 = @inp_sMiddleName,
					LastName	 = @inp_sLastName,
					AddressLine1 = @inp_sAddressLine1,
					AddressLine2 = @inp_sAddressLine2,
					CountryId	 = @inp_iCountryId,
					StateId		 = @inp_iStateId,
					City		 = @inp_sCity,
					PinCode		 = @inp_sPinCode,
					MobileNumber = @inp_sMobileNumber,					
					EmailId	     = @inp_sEmailId,
					PAN			 = @inp_sPAN,
					StatusCodeId = @inp_iStatusCodeId,
					ModifiedBy	 = @inp_iLoggedInUserId,
					ModifiedOn	 = dbo.uf_com_GetServerDate(),
					RelativeStatus = @inp_sRelativeStatus,
					DoYouHaveDMATEAccountFlag = @inp_sDoYouHaveDMATEAccountFlag,
					UIDAI_IdentificationNo=@inp_sUIDAI_IdentificationNo,
				    IdentificationTypeId=@inp_sIdentificationTypeId
			Where UserInfoId = @inp_iUserInfoId	
			
		END
		
		
		EXEC @nRetValue = st_usr_UserRelationSave
						@inp_iUserInfoId
						,@inp_iParentId
						,@inp_iRelationWithEmployee
						,@inp_iLoggedInUserId
						,@out_nReturnValue OUTPUT
						,@out_nSQLErrCode OUTPUT
						,@out_sSQLErrMessage OUTPUT
						
		IF @out_nReturnValue <> 0
		BEGIN
			RETURN @out_nReturnValue
		END

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_USERRELATIONINFO_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END