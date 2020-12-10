IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_CommunicationRuleModeMasterList')
DROP PROCEDURE [dbo].[st_cmu_CommunicationRuleModeMasterList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Communication Rule Mode list.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		11-May-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	19-Jun-2015		Change for select PersonalizeFlag
Gaurishankar	23-Jun-2015		Added column CModeCodeId for populate Template dropdown.
Gaurishankar	27-Jul-2015		Added check for Personalize flag ( i.e. when user already Personalize the CommunicationRule Mode then for same user the entry should not be Personalized)

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_cmu_CommunicationRuleModeMasterList]
	@inp_iPageSize						INT = 10
	,@inp_iPageNo						INT = 1
	,@inp_sSortField					VARCHAR(255)
	,@inp_sSortOrder					VARCHAR(5)
	,@inp_nCommunicationRuleMasterId	INT
	,@inp_nLoggedInUserId				INT
	,@out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @iTotalRecords INT
	DECLARE @ERR_COMMUNICATIONRULEMASTER_LIST INT = 18016 -- Error occurred while fetching list of Template.
	DECLARE @tmpRuleModeMaster TABLE (Id INT IDENTITY(1,1), RuleId INT, RuleModeId INT, ModeCodeId INT, UserId INT, UpdateFlag INT DEFAULT 0)

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		
		INSERT INTO @tmpRuleModeMaster(RuleId, RuleModeId, ModeCodeId, UserId)
				SELECT RuleId, RuleModeId, ModeCodeID, UserId FROM cmu_CommunicationRuleModeMaster CRMM
				WHERE  RuleId = @inp_nCommunicationRuleMasterId AND (UserId IS NULL OR UserId = @inp_nLoggedInUserId)
		if(EXISTS (SELECT RuleId FROM cmu_CommunicationRuleMaster WHERE  RuleId = @inp_nCommunicationRuleMasterId AND InsiderPersonalizeFlag = 1))
		BEGIN 
			UPDATE RMM
				SET UpdateFlag = 1
				--SELECT * 
				FROM @tmpRuleModeMaster RMM 
				INNER JOIN (
					SELECT RuleId, ModeCodeID, MAX(ISNULL(UserId,0)) AS UserInfoId FROM @tmpRuleModeMaster
					GROUP BY RuleId, ModeCodeId
				) T
				ON ISNULL(RMM.UserId,0) = T.UserInfoId AND RMM.ModeCodeId = T.ModeCodeId
				
				UPDATE @tmpRuleModeMaster
				SET UpdateFlag = 0
				WHERE UserId IS NOT NULL
		END
			
			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		INSERT INTO #tmpList (RowNumber, EntityID)
		SELECT  Id, RuleModeId FROM @tmpRuleModeMaster 


		SELECT	@iTotalRecords = COUNT(*)
		FROM	#tmpList
		IF @iTotalRecords > 0 
		BEGIN
		
				SELECT (CRM.Id - 1) AS RowCounter
						,CRMMGlobal.RuleModeId
						,CRMMGlobal.ModeCodeId AS cmu_grd_18007
						,CRM.UserId AS UserId
						,CRMMGlobal.ModeCodeId AS CModeCodeId
						,CModeCodeId.CodeName AS ModeCodeName
						,TM.TemplateMasterId AS cmu_grd_18008
						,TM.TemplateMasterId AS TemplateId
						,TM.TemplateName
						,CRMMGlobal.WaitDaysAfterTriggerEvent AS cmu_grd_18009
						,CRMMGlobal.ExecFrequencyCodeId AS cmu_grd_18010
						,CExecFrequencyCodeId.CodeName AS ExecFrequencyCodeName
						,CRMMGlobal.NotificationLimit AS cmu_grd_18011
						, CRMMGlobal.UserId AS GlobalUserId --This when NULL will indicate that RuleMode is Global RuleMode
						, CRM.UserId AS PersonalUserId
						,CRM.UpdateFlag AS PersonalizeFlag
		
				FROM @tmpRuleModeMaster CRM
				INNER JOIN cmu_CommunicationRuleModeMaster CRMMGlobal
						ON CRM.RuleModeId = CRMMGlobal.RuleModeId 
				INNER JOIN com_Code CModeCodeId ON CRMMGlobal.ModeCodeId = CModeCodeId.CodeID
				LEFT JOIN tra_TemplateMaster TM ON CRMMGlobal.TemplateId = TM.TemplateMasterId
				LEFT JOIN com_Code CExecFrequencyCodeId ON CRMMGlobal.ExecFrequencyCodeId = CExecFrequencyCodeId.CodeID
				
		END
		ELSE 
		BEGIN
			SELECT 0 AS RowCounter
				,null AS RuleModeId
				,null AS cmu_grd_18007
				,null AS CModeCodeId
				, '' AS ModeCodeName
				, null AS cmu_grd_18008
				, '' AS TemplateName
				,null AS cmu_grd_18009
				,null AS cmu_grd_18010
				,'' AS ExecFrequencyCodeName
				,null AS cmu_grd_18011
				, null AS GlobalUserId
				,null AS PersonalUserId	
				, 0 AS PersonalizeFlag
		END


		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COMMUNICATIONRULEMASTER_LIST
	END CATCH
END
