IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_RestrictedList_MassUpload')
	DROP PROCEDURE st_RestrictedList_MassUpload
GO
-- ======================================================================================================
-- Author      : GAURAV UGALE																			=
-- CREATED DATE: 27-JULY-2016                                                 							=
-- Description : THIS PROCEDURE USED FOR RESTRICTED LIST Mass-Upload									=
-- ======================================================================================================
/*

Mmodified On	Modified By	Descriptiion
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/
CREATE PROCEDURE [dbo].[st_RestrictedList_MassUpload]
(
	@inp_EmployeeID				NVARCHAR(100),
	@inp_EmployeeName			NVARCHAR(100) = NULL,
	@inp_CompanyName			VARCHAR(200),
	@inp_ISIN					VARCHAR(50) = NULL,
	@inp_NSECode				VARCHAR(50)	= NULL,
	@inp_BSECode				VARCHAR(50)	= NULL,
	@inp_ApplicableFrom			DATETIME,
	@inp_ApplicableTo			DATETIME,	
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
)
AS
BEGIN	
	DECLARE @CompanyId INT,	@MapToId INT, @ApplicabilityMstId INT
	DECLARE @ModuleCodeId INT = 103301 --ModuleCodeId for Restricted List
	DECLARE @StatusCodeId INT = 105001 --StatusCodeId is Active
	DECLARE @MapToTypeCodeId INT = 132012--Map To Type - Restricted List
	DECLARE @InsiderTypeCodeId INT = 101003--User type - Employee
	DECLARE @IncludeExcludeCodeId INT = 150001-- Include insider for applicability association
	DECLARE @ApplicabilityVersionNumber INT = 1 --Applicability Version Number		
	DECLARE @UserInfoId INT
	
	BEGIN TRY
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''			
		
		IF EXISTS(SELECT RlCompanyId FROM rl_CompanyMasterList WHERE CompanyName = @inp_CompanyName)
		BEGIN
			SET @CompanyId = (SELECT RlCompanyId FROM rl_CompanyMasterList WHERE CompanyName = @inp_CompanyName)
			IF EXISTS (SELECT EmployeeId FROM usr_UserInfo WHERE EmployeeId = @inp_EmployeeID)
			BEGIN	
				print @inp_EmployeeID
				PRINT CONVERT(DATE,@inp_ApplicableFrom)
				PRINT CONVERT(DATE,dbo.uf_com_GetServerDate())
				IF((CONVERT(DATE,@inp_ApplicableFrom)) >= CONVERT(DATE,dbo.uf_com_GetServerDate()))	
				BEGIN
					IF((CONVERT(DATE,@inp_ApplicableFrom)) <= (CONVERT(DATE,@inp_ApplicableTo)))	
					BEGIN
						SET @UserInfoId = (SELECT UserInfoId FROM usr_UserInfo WHERE EmployeeId = @inp_EmployeeID)
						--Added into Restricted master list
						INSERT INTO rl_RistrictedMasterList (RlCompanyId, ModuleCodeId, ApplicableFromDate, ApplicableToDate, StatusCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
						VALUES (@CompanyId, @ModuleCodeId, @inp_ApplicableFrom, @inp_ApplicableTo, @StatusCodeId, @UserInfoId, dbo.uf_com_GetServerDate(), @UserInfoId, dbo.uf_com_GetServerDate())
						SET @MapToId = Scope_Identity()
						--
						INSERT INTO rul_ApplicabilityMaster(MapToTypeCodeId, MapToId, VersionNumber, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
						VALUES(@MapToTypeCodeId, @MapToId, @ApplicabilityVersionNumber, @UserInfoId, dbo.uf_com_GetServerDate(), @UserInfoId, dbo.uf_com_GetServerDate())
						SET @ApplicabilityMstId = Scope_Identity()
						--					
						INSERT INTO rul_ApplicabilityDetails (ApplicabilityMstId, InsiderTypeCodeId, UserId, IncludeExcludeCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
						VALUES(@ApplicabilityMstId, @InsiderTypeCodeId, @UserInfoId, @IncludeExcludeCodeId, @UserInfoId, dbo.uf_com_GetServerDate(), @UserInfoId, dbo.uf_com_GetServerDate())
						
						SELECT 1 
						SET @out_nReturnValue = 0
						RETURN @out_nReturnValue
					END
					ELSE
					BEGIN
						SELECT 1
						SET @out_nReturnValue = 50078
						SET @out_nSQLErrCode    =  1
						SET @out_sSQLErrMessage =  'ApplicableTo date should be greater than or equal to ApplicableFrom date.'
						RETURN (@out_nReturnValue)
					END
				END				
				ELSE
				BEGIN
					SELECT 1
					SET @out_nReturnValue = 50079
					SET @out_nSQLErrCode    =  1
					SET @out_sSQLErrMessage =  'ApplicableFrom date should be current or future date.'
					RETURN (@out_nReturnValue)
				END	
			END
			ELSE
			BEGIN
				SELECT 1
				SET @out_nReturnValue = 50077
				SET @out_nSQLErrCode    =  1
				SET @out_sSQLErrMessage =  'Invalid value provided for EmployeeId'
				RETURN (@out_nReturnValue)
			END
		END
		ELSE
		BEGIN
			SELECT 1
			SET @out_nReturnValue = 50076
			SET @out_nSQLErrCode    =  1
			SET @out_sSQLErrMessage =  'Invalid value provided for Company.'
			RETURN (@out_nReturnValue)
		END		 
	END TRY
	BEGIN CATCH
		SELECT 1
		SET @out_nReturnValue = ERROR_NUMBER()
		RETURN @out_nReturnValue
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue = @out_nSQLErrCode
	END CATCH
END