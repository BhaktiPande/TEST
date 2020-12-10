IF (OBJECT_ID('st_rl_RestrictedCompanyHistoryList','P') IS NOT NULL)
DROP PROCEDURE [st_rl_RestrictedCompanyHistoryList]

GO
/*
Description:	Procedure to list Restricted Company history.

Returns:		0, if Success.
				
Created by:		Priyanka Bhangale
Created on:		21-Nov-2017
*/

CREATE PROCEDURE [st_rl_RestrictedCompanyHistoryList]
	@inp_iPageSize					INT = 0
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5) 
	,@inp_iApplicabilityMstId		VARCHAR(300) = NULL
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_RESTRICTED_LIST		INT = 50019 -- Error occurred while fetching list of Restricted List
	DECLARE @nCompanyStatusActive       VARCHAR(50)
	DECLARE @RestrictedListMapToTypeCodeId INT = 132012
	DECLARE @IncludeCodeId INT = 150001
	DECLARE @VersionNo INT
	
	CREATE TABLE #TempNoOfUserCount(NoOfUserID INT, RlMasterID INT, ApplicabilityMstId INT)

	BEGIN TRY
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT @nCompanyStatusActive = 105001
		
		SELECT @VersionNo = RlMasterVersionNumber FROM rl_RistrictedMasterList WHERE RlMasterId = @inp_iApplicabilityMstId
			
		PRINT @VersionNo		

		--INSERT INTO #TempNoOfUserCount(NoOfUserID, RlMasterID, ApplicabilityMstId)
		--EXEC st_rul_ApplicabilityNoOfUserCount 'History'

		SELECT	rAm.UserCount AS NoOfUserId,RL.RlMasterId AS RlMasterID,rAM.ApplicabilityId
		INTO	#temp_NoOfEmpCount
		FROM	RL_RISTRICTEDMASTERLIST RL
		LEFT JOIN rul_ApplicabilityMaster rAM on RL.RlMasterId = rAM.MapToId 
		WHERE RL.StatusCodeId = @nCompanyStatusActive AND rAM.MapToTypeCodeId = 132012
		
		
				
		SELECT	RL.RlMasterId AS RlMasterId, 		
		(CASE RLCL.BSECode WHEN '' THEN 'Not Available' ELSE RLCL.BSECode END) AS usr_grd_50005,
		(CASE RLCL.ISINCode WHEN '' THEN 'Not Available' ELSE RLCL.ISINCode END) AS usr_grd_50007,
		(CASE RLCL.NSECode WHEN '' THEN 'Not Available' ELSE RLCL.NSECode END) AS usr_grd_50006,		
		RLCL.CompanyName AS usr_grd_50008, /*CompanyName*/
		CONVERT(DATE,RL.ApplicableFromDate,110) AS usr_grd_50009,
		CONVERT(DATE,RL.ApplicableToDate,110) AS usr_grd_50010,
		(ISNULL(UI.FirstName,'') +' '+ ISNULL(UI.LastName,'')) AS usr_grd_50011,		
		ISNULL(tEmp.NoOfUserId,0) AS usr_grd_50012,
		ISNULL(AM.ApplicabilityId,0) AS ApplicabilityId	
		FROM	rl_RistrictedMasterList RL 
				LEFT JOIN rul_ApplicabilityMaster AM ON AM.MapToId = RL.RlMasterId
				INNER JOIN rl_CompanyMasterList RLCL ON RL.RlCompanyId = RLCL.RlCompanyId
				INNER JOIN usr_UserInfo UI ON UI.UserInfoId = RL.CreatedBy	
				LEFT JOIN #temp_NoOfEmpCount tEmp ON tEmp.RlMasterId = Rl.RlMasterId AND AM.ApplicabilityId = tEmp.ApplicabilityId			
				LEFT JOIN com_Code CModule ON RL.ModuleCodeId = CModule.CodeID
				LEFT JOIN com_Code CStatus ON RL.StatusCodeId = CStatus.CodeID
		WHERE AM.MapToId = @inp_iApplicabilityMstId AND AM.MapToTypeCodeId= @RestrictedListMapToTypeCodeId
		 OR RL.RlMasterVersionNumber = @VersionNo
		ORDER BY RL.RlMasterId DESC,AM.ApplicabilityId DESC
		
		DROP TABLE #temp_NoOfEmpCount
		--DROP TABLE #TempNoOfUserCount
		RETURN 0
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_RESTRICTED_LIST
		RETURN @out_nReturnValue
	END CATCH
END
GO