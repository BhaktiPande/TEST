
IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_DepartmentWiseRLAppli_MassUpload')
	DROP PROCEDURE st_DepartmentWiseRLAppli_MassUpload
GO
-- ======================================================================================================
-- Author      : GAURAV UGALE																			=
-- CREATED DATE: 27-JULY-2016                                                 							=
-- Description : THIS PROCEDURE USED FOR DEPARTMENT WISE RESTRICTED LIST APPLICABILITY Mass-Upload		=
-- ======================================================================================================

/*
Modified By	Modified On	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/


CREATE PROCEDURE [dbo].[st_DepartmentWiseRLAppli_MassUpload]
(
	
	@inp_Department				VARCHAR(200),
	@inp_Designation			VARCHAR(200),
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
)
AS
BEGIN
	DECLARE @MapToId INT, @ApplicabilityMstId INT
	DECLARE @MapToTypeCodeId INT = 132012--Map To Type - Restricted List
	DECLARE @InsiderTypeCodeId INT = 101003--User type - Employee
	DECLARE @ApplicabilityVersionNumber INT = 1 --Applicability Version Number		
	DECLARE @DeptCodeGroupId INT = 110 -- Department Code
	DECLARE @DeigCodeGroupId INT = 109 -- Designation Code
	DECLARE @DepartmentId INT = 0
	DECLARE @DesignationId INT = 0
	DECLARE @MassCounter INT
	DECLARE @CompanyTable TABLE(Id INT PRIMARY KEY IDENTITY(1,1), CompanyId VARCHAR(100))
	DECLARE @CompanyMIN INT, @CompanyMAX INT, @UserMIN INT, @UserMAX INT
	
	BEGIN TRY
	
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''		
			
		SELECT @MassCounter = MAX(MassCounter) FROM rl_RistrictedMasterList	
		INSERT INTO @CompanyTable
		SELECT RlMasterId FROM rl_RistrictedMasterList WHERE MassCounter = @MassCounter
		
		SELECT @CompanyMIN = MIN(ID), 
			   @CompanyMAX = MAX(ID) 
		FROM @CompanyTable	
		
		SELECT @DepartmentId = CodeID FROM com_Code WHERE CodeName = @inp_Department AND CodeGroupId = @DeptCodeGroupId		
		
		IF(@inp_Designation IS NOT NULL)
		BEGIN			
			SELECT @DesignationId = CodeID FROM com_Code WHERE CodeName = @inp_Designation AND CodeGroupId = @DeigCodeGroupId
			IF(@DesignationId = 0 )
			BEGIN
				SELECT 1
				SET @out_nReturnValue = 50080
				SET @out_nSQLErrCode    =  1
				SET @out_sSQLErrMessage =  'Invalid value provided for Designation.'
				RETURN (@out_nReturnValue)
			END
		END
		
		IF(@DepartmentId = 0)
		BEGIN
			SELECT 1
			SET @out_nReturnValue = 50081
			SET @out_nSQLErrCode    =  1
			SET @out_sSQLErrMessage =  'Invalid value provided for Department.'
			RETURN (@out_nReturnValue)
		END
		
		IF EXISTS(SELECT Id FROM @CompanyTable)
		BEGIN
			WHILE (@CompanyMIN <= @CompanyMAX)
			BEGIN
					SELECT @MapToId = CompanyId FROM @CompanyTable WHERE ID = @CompanyMIN					
					
					IF NOT EXISTS (SELECT MapToId FROM rul_ApplicabilityMaster WHERE MapToId = @MapToId AND MapToTypeCodeId = @MapToTypeCodeId)
					BEGIN
						INSERT INTO rul_ApplicabilityMaster(MapToTypeCodeId, MapToId, VersionNumber, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
						VALUES(@MapToTypeCodeId, @MapToId, @ApplicabilityVersionNumber, 1, dbo.uf_com_GetServerDate(), 1, dbo.uf_com_GetServerDate())					
						SET @ApplicabilityMstId = SCOPE_IDENTITY()	
					END		
					ELSE
					BEGIN
						SET @ApplicabilityMstId = (SELECT ApplicabilityId FROM rul_ApplicabilityMaster WHERE MapToId = @MapToId AND MapToTypeCodeId = @MapToTypeCodeId)
					END
					
					IF (@DesignationId = 0)
					BEGIN
						IF NOT EXISTS (SELECT ApplicabilityDtlsId FROM rul_ApplicabilityDetails WHERE DepartmentCodeId = @DepartmentId AND ApplicabilityMstId = @ApplicabilityMstId)
						BEGIN
							INSERT INTO rul_ApplicabilityDetails (ApplicabilityMstId, InsiderTypeCodeId, DepartmentCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
							VALUES(@ApplicabilityMstId, @InsiderTypeCodeId, @DepartmentId, 1, dbo.uf_com_GetServerDate(), 1, dbo.uf_com_GetServerDate())	
						END
					END
					ELSE
					BEGIN
						IF NOT EXISTS (SELECT ApplicabilityDtlsId FROM rul_ApplicabilityDetails WHERE DepartmentCodeId = @DepartmentId AND DesignationCodeId = @DesignationId AND ApplicabilityMstId = @ApplicabilityMstId)
						BEGIN
							INSERT INTO rul_ApplicabilityDetails (ApplicabilityMstId, InsiderTypeCodeId, DepartmentCodeId ,DesignationCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
							VALUES(@ApplicabilityMstId, @InsiderTypeCodeId, @DepartmentId, @DesignationId, 1, dbo.uf_com_GetServerDate(), 1, dbo.uf_com_GetServerDate())	
						END
					END
				SET @CompanyMIN = @CompanyMIN + 1
			END	
			SELECT 1 
			SET @out_nReturnValue = 0
			RETURN @out_nReturnValue
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