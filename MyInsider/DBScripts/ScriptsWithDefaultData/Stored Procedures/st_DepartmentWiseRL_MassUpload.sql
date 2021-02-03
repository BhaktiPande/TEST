
IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_DepartmentWiseRL_MassUpload')
	DROP PROCEDURE st_DepartmentWiseRL_MassUpload
GO
-- ======================================================================================================
-- Author      : GAURAV UGALE																			=
-- CREATED DATE: 27-JULY-2016                                                 							=
-- Description : THIS PROCEDURE USED FOR DEPARTMENT WISE RESTRICTED LIST COMPANY Mass-Upload			=
-- ======================================================================================================
/*
Modified By	Modified On	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/

CREATE PROCEDURE [dbo].[st_DepartmentWiseRL_MassUpload]
(
	
	@inp_CompanyName			NVARCHAR(500),
	@inp_ISINCode				NVARCHAR(500),
	@inp_ApplicableFrom			DATETIME,
	@inp_ApplicableTo			DATETIME,	
	@Inp_MassCounter			INT,
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
)
AS
BEGIN	
	print'A'
	DECLARE @CompanyId INT,	@MapToId INT, @ApplicabilityMstId INT
	DECLARE @ModuleCodeId INT = 103301 --ModuleCodeId for Restricted List
	DECLARE @StatusCodeId INT = 105001 --StatusCodeId is Active
	DECLARE @MapToTypeCodeId INT = 132012--Map To Type - Restricted List	
		
	BEGIN TRY
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			print @inp_CompanyName
	

		IF EXISTS(SELECT RlCompanyId FROM rl_CompanyMasterList WHERE ISINCode=@inp_ISINCode)
		BEGIN		
			SET @CompanyId = (SELECT RlCompanyId FROM rl_CompanyMasterList WHERE ISINCode=@inp_ISINCode)
			PRINT 'B'
			PRINT @inp_ApplicableFrom
			PRINT @inp_ApplicableTo
			IF NOT EXISTS(SELECT RlMasterId FROM rl_RistrictedMasterList WHERE CONVERT(DATE,ApplicableFromDate) = CONVERT(DATE,@inp_ApplicableFrom) AND CONVERT(DATE,ApplicableToDate) = CONVERT(DATE,@inp_ApplicableTo) AND RlCompanyId = @CompanyId AND MassCounter=@Inp_MassCounter)	
			BEGIN
				PRINT 'C'
				IF((CONVERT(DATE,@inp_ApplicableFrom)) >= CONVERT(DATE,dbo.uf_com_GetServerDate()))	
				BEGIN
					PRINT 'D'
					IF((CONVERT(DATE,@inp_ApplicableFrom)) <= (CONVERT(DATE,@inp_ApplicableTo)))	
					BEGIN
						PRINT 'E'
						INSERT INTO rl_RistrictedMasterList (RlCompanyId, ModuleCodeId, ApplicableFromDate, ApplicableToDate, StatusCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, MassCounter)
						VALUES (@CompanyId, @ModuleCodeId, @inp_ApplicableFrom, @inp_ApplicableTo, @StatusCodeId, 1, dbo.uf_com_GetServerDate(), 1, dbo.uf_com_GetServerDate(), @Inp_MassCounter)		
						SET @MapToId = Scope_Identity()
						SELECT 1 
						SET @out_nReturnValue = 0
						RETURN @out_nReturnValue
					END
					ELSE
					BEGIN
						PRINT 'F'
						SELECT 1
						SET @out_nReturnValue = 50078
						SET @out_nSQLErrCode    =  1
						SET @out_sSQLErrMessage =  'ApplicableTo date should be greater than or equal to ApplicableFrom date.'
						RETURN (@out_nReturnValue)
					END
				END
				ELSE
				BEGIN
					PRINT'G'
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
				SET @out_nReturnValue = 0	
				RETURN @out_nReturnValue
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