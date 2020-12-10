IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoSave_Corporate')
DROP PROCEDURE [dbo].[st_usr_UserInfoSave_Corporate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the Corporate User details

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		10-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		10-Feb-2015		Authentication procedure is called.
Arundhati		11-Feb-2015		Parameter UserINfoId is made OUTPUT, so that for the new record, the actual value can be returned
Swapnil			11-Feb-2015		Added UserTypeCodeId parameter while creating new record.
Arundhati		16-Mar-2015		Instead of DesignationId, designationtext is stored
Tushar			26-May-2015		Insert/Update new column @inp_sCIN add
ED			22-Mar-2016		Code integration done with ED code on 22-Mar-2016
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_usr_UserInfoSave_Corporate ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_UserInfoSave_Corporate]
	 @inp_iUserInfoId				INT	OUTPUT
    ,@inp_sEmailId					NVARCHAR(250) = null   
	,@inp_iCompanyId				INT	
    ,@inp_sAddressLine1				NVARCHAR(500) = null
    ,@inp_sAddressLine2				NVARCHAR(500) = null
    ,@inp_iCountryId				INT = null
    ,@inp_iStateId					INT = null
    ,@inp_sCity						NVARCHAR(100) = null
    ,@inp_sPinCode					NVARCHAR(50) = null
    ,@inp_sContactPerson			NVARCHAR(100) = null  
    ,@inp_dtDateOfBecomingInsider	DATETIME = null
    ,@inp_sLandLine1				NVARCHAR(50) = null
    ,@inp_sLandLine2				NVARCHAR(50) = null
    ,@inp_sWebsite					NVARCHAR(500) = null
    ,@inp_sPAN						NVARCHAR(50) = null
    ,@inp_sTAN						NVARCHAR(50) = null
    ,@inp_sDescription				NVARCHAR(1024) = null   
    --,@inp_iDesignationId			INT = null  	
    ,@inp_sDesignationText			NVARCHAR(100) = null
    ,@inp_iLoggedInUserId			INT = null
    ,@inp_sLoginID					VARCHAR(100) = null
    ,@inp_sPassword					VARCHAR(200) = null
    ,@inp_sCIN						NVARCHAR(50)   
    ,@inp_sCategoryText				NVARCHAR(100) = null
    ,@inp_sSubCategoryText			NVARCHAR(100) = null
	,@inp_sAllowUpsiUser			BIT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN

	DECLARE @ERR_USERINFO_SAVE INT = 11032 -- Error occurred while saving CO user details.
	DECLARE @ERR_USERINFO_NOTFOUND INT = 11025 -- User does not exist.
	DECLARE @nUserTypeCode_Corporate INT = 101004
	DECLARE @nRetValue INT

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

		--Save the UserInfo details
		IF @inp_iUserInfoId = 0
		BEGIN
			INSERT INTO usr_UserInfo(
					EmailId,					
					CompanyId,
					AddressLine1,
					AddressLine2,
					CountryId,
					StateId,
					City,
					PinCode,
					ContactPerson,					
					DateOfBecomingInsider,
					LandLine1,
					LandLine2,
					Website,
					PAN,
					TAN,
					Description,					
					--DesignationId,					
					DesignationText,
					UserTypeCodeId,
					CIN,
					CategoryText,
					SubCategoryText,
					AllowUpsiUser,					
					CreatedBy, CreatedOn, ModifiedBy,ModifiedOn )
			Values (
					@inp_sEmailId,					
					@inp_iCompanyId,
					@inp_sAddressLine1,
					@inp_sAddressLine2,
					@inp_iCountryId,
					@inp_iStateId,
					@inp_sCity,
					@inp_sPinCode,
					@inp_sContactPerson,					
					@inp_dtDateOfBecomingInsider,
					@inp_sLandLine1,
					@inp_sLandLine2,
					@inp_sWebsite,
					@inp_sPAN,
					@inp_sTAN,
					@inp_sDescription,				
					--@inp_iDesignationId,									
					@inp_sDesignationText,
					@nUserTypeCode_Corporate,
					@inp_sCIN,
					@inp_sCategoryText,
					@inp_sSubCategoryText,
					@inp_sAllowUpsiUser,
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
			Set 	EmailId = @inp_sEmailId,
					CompanyId = @inp_iCompanyId,
					AddressLine1 = @inp_sAddressLine1,
					AddressLine2 = @inp_sAddressLine2,
					CountryId = @inp_iCountryId,
					StateId = @inp_iStateId,
					City = @inp_sCity,
					PinCode = @inp_sPinCode,
					ContactPerson = @inp_sContactPerson,
					DateOfBecomingInsider = @inp_dtDateOfBecomingInsider,
					LandLine1 = @inp_sLandLine1,
					LandLine2 = @inp_sLandLine2,
					Website = @inp_sWebsite,
					PAN = @inp_sPAN,
					TAN = @inp_sTAN,
					Description = @inp_sDescription,
					--DesignationId = @inp_iDesignationId,	
					DesignationText = @inp_sDesignationText,
					CIN = @inp_sCIN,	
					CategoryText = @inp_sCategoryText,
					SubCategoryText = @inp_sSubCategoryText,
					AllowUpsiUser=@inp_sAllowUpsiUser,			
					ModifiedBy	= @inp_iLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()

			Where UserInfoId = @inp_iUserInfoId	
			
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
			RETURN @out_nReturnValue
		END

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END TRY
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_USERINFO_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH

END
	