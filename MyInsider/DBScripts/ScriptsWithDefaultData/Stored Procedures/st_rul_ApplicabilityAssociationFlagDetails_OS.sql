IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_ApplicabilityAssociationFlagDetails_OS')
DROP PROCEDURE [dbo].[st_rul_ApplicabilityAssociationFlagDetails_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
Description: Fetch the flag values for AllEmployeeFlag, AllInsiderFlag, AllEmployeeInsiderFlag and 
			 the count of Corporate and NonEmployee users to whom the applicability is associated
			If AllEmployeeFlag=1 then there will be only one record in rul_ApplicabilityMaster_OS for combination MapToTypeCodeId-MapToId
			If AllInsiderFlag=1 then there will be only one record in rul_ApplicabilityMasteR_OS for combination MapToTypeCodeId-MapToId
			If AllEmployeeInsiderFlag = 1 then there can be more than 1 records in rul_ApplicabilityMaster_OS for combination MapToTypeCodeId-MapToId


Returns:		0, if Success.
				
Created by:		Rajashri
Usage:
EXEC st_rul_TradingPolicyDetails_OS 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_ApplicabilityAssociationFlagDetails_OS]
		@inp_nMapToTypeCodeId INT,							
		@inp_nMapToId			INT,
		@out_nReturnValue		INT = 0 OUTPUT,
		@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
		@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_APPLICABILITY_FLAGS_GETDETAILS	INT = -1
	DECLARE @nAppCorporateCnt					INT = 0
	DECLARE @nAppNonEmployeeCnt					INT = 0
	DECLARE @nApplicabilityMaxVersion			INT
	DECLARE @nUserTypeNonEmployeeCodeId			INT = 101006	--Code for UserType NonEmployee
	DECLARE @nUserTypeCorporateCodeId			INT = 101004	--Code for UserType Corporate
	DECLARE @nIncludeUserCodeId					INT = 150001	--Include user for applicability
	DECLARE @nRecordCnt INT = 0
	DECLARE @nApplicabilityRecordCnt INT = 0

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

		--If Applicability is defined for combination : MapToTypeCodeId-MapToId
		IF(EXISTS(SELECT ApplicabilityId FROM rul_ApplicabilityMaster_OS WHERE MapToTypeCodeId = @inp_nMapToTypeCodeId AND MapToId = @inp_nMapToId))
		BEGIN
			SELECT @nApplicabilityMaxVersion = ISNULL(MAX(VersionNumber), 0)
			FROM rul_ApplicabilityMaster_OS 
			WHERE MapToTypeCodeId = @inp_nMapToTypeCodeId AND MapToId = @inp_nMapToId 
			--print 'max applicability version : ' + CAST(@nApplicabilityMaxVersion AS VARCHAR)
			
			--Count the corporate users for whom applicability with max version is associated
			SELECT @nAppCorporateCnt = ISNULL(COUNT(ApplicabilityDtlsId), 0)
			FROM rul_ApplicabilityDetails_OS AD
			INNER JOIN rul_ApplicabilityMaster_OS AM
			ON AD.ApplicabilityMstId = AM.ApplicabilityId
			WHERE AM.MapToTypeCodeId = @inp_nMapToTypeCodeId
			AND AM.MapToId = @inp_nMapToId
			AND AD.InsiderTypeCodeId = @nUserTypeCorporateCodeId
			AND AD.IncludeExcludeCodeId = @nIncludeUserCodeId
			AND AM.VersionNumber = @nApplicabilityMaxVersion
			
			--Count the non-employee users for whom applicability with max version is associated
			SELECT @nAppNonEmployeeCnt = ISNULL(COUNT(ApplicabilityDtlsId), 0)
			FROM rul_ApplicabilityDetails_OS AD
			INNER JOIN rul_ApplicabilityMaster_OS AM
			ON AD.ApplicabilityMstId = AM.ApplicabilityId
			WHERE AM.MapToTypeCodeId = @inp_nMapToTypeCodeId
			AND AM.MapToId = @inp_nMapToId
			AND AD.InsiderTypeCodeId = @nUserTypeNonEmployeeCodeId
			AND AD.IncludeExcludeCodeId = @nIncludeUserCodeId
			AND AM.VersionNumber = @nApplicabilityMaxVersion

			SELECT @nApplicabilityRecordCnt = Count(ApplicabilityDtlsId)
			FROM rul_ApplicabilityDetails_OS AD
					INNER JOIN rul_ApplicabilityMaster_OS AM
					ON AD.ApplicabilityMstId = AM.ApplicabilityId
					WHERE AM.MapToTypeCodeId = @inp_nMapToTypeCodeId
					AND AM.MapToId = @inp_nMapToId
					AND AM.VersionNumber = @nApplicabilityMaxVersion
					
			SELECT @nRecordCnt = COUNT(AllEmployeeFlag) 
			FROM (
					SELECT DISTINCT ISNULL(AllEmployeeFlag,0) AS AllEmployeeFlag,  ISNULL(AllInsiderFlag,0) AS AllInsiderFlag, ISNULL(AllEmployeeInsiderFlag,0) AS AllEmployeeInsiderFlag, 
								ISNULL(AllCo,0) AS AllCo, ISNULL(AllCorporateEmployees,0) AS AllCorporateEmployees, ISNULL(AllNonEmployee,0) AS AllNonEmployee,
								@nAppCorporateCnt AS AssociatedCorporateCnt, @nAppNonEmployeeCnt AS AssociatedNonEmployeeCnt
					FROM rul_ApplicabilityDetails_OS AD
					INNER JOIN rul_ApplicabilityMaster_OS AM
					ON AD.ApplicabilityMstId = AM.ApplicabilityId
					WHERE AM.MapToTypeCodeId = @inp_nMapToTypeCodeId
					AND AM.MapToId = @inp_nMapToId
					AND AM.VersionNumber = @nApplicabilityMaxVersion
				 ) T
			--SELECT @nRecordCnt
			IF(@nRecordCnt > 1) /*records defined for corporate and non-employee and AllEmployeeInsiderFlag and AllEmployeeFlag is set*/
			BEGIN
				--print '1'
				SELECT CONVERT(BIT,MAX (CONVERT(INT,ISNULL(AllEmployeeFlag,0)))) AS AllEmployeeFlag,  CONVERT(BIT,MAX (CONVERT(INT,ISNULL(AllInsiderFlag,0)))) AS AllInsiderFlag, CONVERT(BIT,MAX (CONVERT(INT,ISNULL(AllEmployeeInsiderFlag,0)))) AS AllEmployeeInsiderFlag, 
								CONVERT(BIT,MAX (CONVERT(INT,ISNULL(AllCo,0)))) AS AllCo, CONVERT(BIT,MAX (CONVERT(INT,ISNULL(AllCorporateEmployees,0)))) AS AllCorporateEmployees, CONVERT(BIT,MAX (CONVERT(INT,ISNULL(AllNonEmployee,0)))) AS AllNonEmployee,
								@nAppCorporateCnt AS AssociatedCorporateCnt, @nAppNonEmployeeCnt AS AssociatedNonEmployeeCnt, @nApplicabilityRecordCnt AS RecordCount
				FROM rul_ApplicabilityDetails_OS AD
				INNER JOIN rul_ApplicabilityMaster_OS AM
				ON AD.ApplicabilityMstId = AM.ApplicabilityId
				WHERE AM.MapToTypeCodeId = @inp_nMapToTypeCodeId
				AND AM.MapToId = @inp_nMapToId
				AND AM.VersionNumber = @nApplicabilityMaxVersion
				--AND (AllEmployeeInsiderFlag = 1 OR AllEmployeeFlag = 1)
			END			
			ELSE
			BEGIN
				--print '2'
				SELECT DISTINCT ISNULL(AllEmployeeFlag,0) AS AllEmployeeFlag,  ISNULL(AllInsiderFlag,0) AS AllInsiderFlag, ISNULL(AllEmployeeInsiderFlag,0) AS AllEmployeeInsiderFlag, 
								ISNULL(AllCo,0) AS AllCo, ISNULL(AllCorporateEmployees,0) AS AllCorporateEmployees, ISNULL(AllNonEmployee,0) AS AllNonEmployee,
								@nAppCorporateCnt AS AssociatedCorporateCnt, @nAppNonEmployeeCnt AS AssociatedNonEmployeeCnt, @nApplicabilityRecordCnt AS RecordCount
				FROM rul_ApplicabilityDetails_OS AD
				INNER JOIN rul_ApplicabilityMaster_OS AM
				ON AD.ApplicabilityMstId = AM.ApplicabilityId
				WHERE AM.MapToTypeCodeId = @inp_nMapToTypeCodeId
				AND AM.MapToId = @inp_nMapToId
				AND AM.VersionNumber = @nApplicabilityMaxVersion
			END
		END
		--ELSE
		--BEGIN
		--	SELECT 0 AS AllEmployeeFlag, 0 AS AllInsiderFlag, 0 AS AllEmployeeInsiderFlag, @nAppCorporateCnt AS AssociatedCorporateCnt, @nAppNonEmployeeCnt AS AssociatedNonEmployeeCnt
		--END
	END TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_APPLICABILITY_FLAGS_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END