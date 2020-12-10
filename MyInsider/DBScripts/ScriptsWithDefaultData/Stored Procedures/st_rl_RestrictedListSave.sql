IF (OBJECT_ID('st_rl_RestrictedListSave','P') IS NOT NULL)
DROP PROCEDURE st_rl_RestrictedListSave
GO

/*-------------------------------------------------------------------------------------------------
Description:	Received from Esop Direct on 13-Oct-2015
				Save Restricted List details

Returns:		0, if Success.
				
Created by:		Santosh Panchal
Created on:		16-Sept-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
BEGIN TRANSACTION T1
DECLARE @T1 RestrictedListType
INSERT INTO @T1 ([ComapnyId],[ModuleCodeId],[ApplicableFromDate],[ApplicableToDate]) 
Values (1,'103013','01-01-2010','01-03-2010')
DECLARE @RC int, @out_nReturnValue INT, @out_nSQLErrCode INT, @out_sSQLErrMessage VARCHAR(500)

EXEC @RC = st_rl_RestrictedListSave 39,39,@T1, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
ROLLBACK TRANSACTION T1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [st_rl_RestrictedListSave]
	@inp_iUserInfoId		INT,	
	@inp_iLoggedInUserId	INT,
	@inp_tblRLMasterType	RestrictedListType READONLY,
	@inp_iRlMasterId		INT = 0,
	@inp_sActionType		VARCHAR(10),
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_MASTERLIST_SAVE INT =50016,
			@StatusCodeId INT = 105001,
			@ModuleCodeId INT = 103301,--103013,
			@ApplicableToDate DATETIME,
			@CompanyId INT,
			@inp_ApplicableFrom DATETIME,
			@inp_ApplicableTo DATETIME,
			@RlMasterVersionNumber INT,
			@LastApplicabilityId  INT =0,
			@UserCount INT =0,
			@iRlMasterId INT =0,
			@MapToTypeCodeId INT =132012, --For Restricted List
			@OldRlMasterVersionNumber INT
			

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
		
		SET @CompanyId = (SELECT ComapnyId FROM @inp_tblRLMasterType)
		SET @inp_ApplicableFrom = (SELECT CONVERT(DATE,ApplicableFromDate) FROM @inp_tblRLMasterType)
		SET @inp_ApplicableTo = (SELECT CONVERT(DATE,ApplicableToDate) FROM @inp_tblRLMasterType)
		SET @RlMasterVersionNumber = (SELECT MAX(RlMasterVersionNumber) FROM rl_RistrictedMasterList)
		SET @RlMasterVersionNumber = @RlMasterVersionNumber + 1
				
		IF(@inp_iRlMasterId = 0)
		BEGIN
			IF NOT EXISTS (SELECT RlCompanyId FROM rl_RistrictedMasterList 
					 WHERE RlCompanyId = @CompanyId AND ApplicableFromDate = @inp_ApplicableFrom
						AND ApplicableToDate = @inp_ApplicableTo)
			BEGIN
				--Insert new record into table
				INSERT INTO rl_RistrictedMasterList(RlCompanyId,ModuleCodeId,ApplicableFromDate,ApplicableToDate,StatusCodeId,
					CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,RlMasterVersionNumber)		
				SELECT	ComapnyId,@ModuleCodeId,CONVERT(DATE,ApplicableFromDate),CONVERT(DATE,ApplicableToDate),@StatusCodeId,
						@inp_iLoggedInUserId,dbo.uf_com_GetServerDate(),@inp_iLoggedInUserId,dbo.uf_com_GetServerDate(),@RlMasterVersionNumber 
				FROM	@inp_tblRLMasterType
				SET @out_nReturnValue = 0				
				--SELECT SCOPE_IDENTITY()
				SELECT IDENT_CURRENT('rl_RistrictedMasterList')

				----Insert respective entries Into AppliablityMaster Table with UserCount by Default zero
				INSERT INTO 
					rul_ApplicabilityMaster
					(
								MapToTypeCodeId,
								MapToId,
								VersionNumber,
								CreatedBy,
								CreatedOn,
								ModifiedBy,
								ModifiedOn,
								UserCount
					)
					VALUES
					 (
								@MapToTypeCodeId,
								IDENT_CURRENT('rl_RistrictedMasterList'),
								1,
								@inp_iLoggedInUserId,
								dbo.uf_com_GetServerDate(),
								@inp_iLoggedInUserId,
								dbo.uf_com_GetServerDate(),
								0
					 )
			END
			ELSE
			BEGIN
				SELECT -10
				SET @out_nReturnValue = 0
			END
		END
		ELSE
		BEGIN
			IF (UPPER(@inp_sActionType)=UPPER('UPDATE'))
				BEGIN
					SELECT @ApplicableToDate = CONVERT(DATE,ApplicableToDate) FROM @inp_tblRLMasterType 
					SET @OldRlMasterVersionNumber = (SELECT TOP 1 RlMasterVersionNumber FROM rl_RistrictedMasterList WHERE RlMasterId = @inp_iRlMasterId)

					SELECT @iRlMasterId=IDENT_CURRENT('rl_RistrictedMasterList')					
					
					INSERT INTO rl_RistrictedMasterList(RlCompanyId,ModuleCodeId,ApplicableFromDate,ApplicableToDate,StatusCodeId,
					CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,RlMasterVersionNumber)		
					SELECT	ComapnyId,@ModuleCodeId,CONVERT(DATE,ApplicableFromDate),CONVERT(DATE,ApplicableToDate),@StatusCodeId,
						@inp_iLoggedInUserId,dbo.uf_com_GetServerDate(),@inp_iLoggedInUserId,dbo.uf_com_GetServerDate(),@OldRlMasterVersionNumber 
					FROM @inp_tblRLMasterType
					

					IF EXISTS(SELECT UserCount,ApplicabilityId FROM rul_ApplicabilityMaster WHERE MapToId=@iRlMasterId AND VersionNumber=(SELECT Max(VersionNumber) from rul_ApplicabilityMaster where MapToId=@iRlMasterId))
					BEGIN 
					SELECT @UserCount=UserCount,@LastApplicabilityId=ApplicabilityId FROM rul_ApplicabilityMaster WHERE MapToId=@iRlMasterId AND VersionNumber=(SELECT Max(VersionNumber) from rul_ApplicabilityMaster where MapToId=@iRlMasterId)
					
					--Insert respective entries Into AppliablityMaster Table
					INSERT INTO 
					rul_ApplicabilityMaster
					(
								MapToTypeCodeId,
								MapToId,
								VersionNumber,
								CreatedBy,
								CreatedOn,
								ModifiedBy,
								ModifiedOn,
								UserCount
					)
					VALUES
					 (
								@MapToTypeCodeId,
								IDENT_CURRENT('rl_RistrictedMasterList'),
								1,
								@inp_iLoggedInUserId,
								dbo.uf_com_GetServerDate(),
								@inp_iLoggedInUserId,
								dbo.uf_com_GetServerDate(),
								@UserCount
					 )
					----Insert entries Into ApplicabilityDetails Table
					CREATE TABLE #TempTable_ApplicabilityDetails
					 (
								ApplicabilityMstId BIGINT,
								AllEmployeeFlag BIT,
								AllInsiderFlag BIT,
								AllEmployeeInsiderFlag BIT,
								InsiderTypeCodeId INT,
								DepartmentCodeId INT,
								GradeCodeId INT,
								DesignationCodeId INT,
								UserId INT,
								IncludeExcludeCodeId INT,
								CreatedBy INT,
								CreatedOn DATETIME,
								ModifiedBy INT,
								ModifiedOn DATETIME,
								RoleId INT,
								Category INT,
								SubCategory INT,
								AllCo BIT,
								AllCorporateEmployees BIT,
								AllNonEmployee BIT,
								NonInsFltrDepartmentCodeId INT,
								NonInsFltrGradeCodeId INT,
								NonInsFltrDesignationCodeId INT,
								NonInsFltrRoleId INT,
								NonInsFltrCategory INT,
								NonInsFltrSubCategory INT
						)

					INSERT INTO #TempTable_ApplicabilityDetails
					SELECT  ApplicabilityMstId,
							AllEmployeeFlag,
							AllInsiderFlag,
							AllEmployeeInsiderFlag,
							InsiderTypeCodeId,
							DepartmentCodeId,
							GradeCodeId,
							DesignationCodeId,
							UserId,
							IncludeExcludeCodeId,
							CreatedBy,
							CreatedOn,
							ModifiedBy,
							ModifiedOn,
							RoleId,
							Category,
							SubCategory,
							AllCo,
							AllCorporateEmployees,
							AllNonEmployee,
							NonInsFltrDepartmentCodeId,
							NonInsFltrGradeCodeId,
							NonInsFltrDesignationCodeId,
							NonInsFltrRoleId,
							NonInsFltrCategory,
							NonInsFltrSubCategory
					FROM    rul_ApplicabilityDetails
					WHERE ApplicabilityMstId = @LastApplicabilityId		
							
					UPDATE #TempTable_ApplicabilityDetails
						   SET ApplicabilityMstId=IDENT_CURRENT('rul_ApplicabilityMaster'),
							   CreatedBy=@inp_iLoggedInUserId,
							   CreatedOn=dbo.uf_com_GetServerDate(),
							   ModifiedBy=@inp_iLoggedInUserId,
							   ModifiedOn=dbo.uf_com_GetServerDate()
						  WHERE ApplicabilityMstId=@LastApplicabilityId

					INSERT INTO rul_ApplicabilityDetails
					SELECT * FROM #TempTable_ApplicabilityDetails
					END
					SELECT IDENT_CURRENT('rl_RistrictedMasterList')
				END
			ELSE IF (UPPER(@inp_sActionType)=UPPER('DELETE'))
				BEGIN
					UPDATE rl_RistrictedMasterList set StatusCodeId = 105002 where RlMasterId = @inp_iRlMasterId
					UPDATE rul_ApplicabilityDetails SET IncludeExcludeCodeId = 105002 WHERE 
					ApplicabilityMstId IN (SELECT ApplicabilityId FROM rul_ApplicabilityMaster WHERE MapToId=@inp_iRlMasterId)	
					SELECT SCOPE_IDENTITY()
				END
			SET @out_nReturnValue = 0					
		END	
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_MASTERLIST_SAVE, ERROR_NUMBER())
		--RETURN @out_nReturnValue
	END CATCH
END
GO
