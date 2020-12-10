IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_CommunicationRuleMasterList')
DROP PROCEDURE [dbo].[st_cmu_CommunicationRuleMasterList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Communication Rule Master list.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		28-May-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	07-07-2015		Corrected the condition for RuleForCodeId for search
Gaurishankar	28-08-2015		Admin and CO can see the all communication rule records
Gaurishankar	02-02-2016		Added condition for PersonalizeFlag, User can list communication Rule which is personalized and applicable to it.
Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_cmu_CommunicationRuleMasterList]
	@inp_iPageSize						INT = 10
	,@inp_iPageNo						INT = 1
	,@inp_sSortField					VARCHAR(255)
	,@inp_sSortOrder					VARCHAR(5)
	,@inp_sRuleName						NVARCHAR(255)	
	,@inp_nCommunicationModeCodeId		INT
	,@inp_iRuleStatusCodeId				INT
	,@inp_nLoggedInUserId				INT
	,@inp_bInsiderPersonalizeFlag		BIT
	,@out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_COMMUNICATIONRULEMASTER_LIST INT = 18017 -- Error occurred while fetching communication rule list..
	DECLARE @UserTypeCode	INT
	DECLARE @CommunicationRuleForUserType_Insider	INT
	DECLARE @UserType_Employee	INT
	DECLARE @UserType_CorporateUser	INT
	DECLARE @UserType_Relative	INT
	DECLARE @UserType_CO INT
	DECLARE @UserType_Admin INT
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		SELECT @CommunicationRuleForUserType_Insider = 159001,
				@UserType_Admin	= 101001,
				@UserType_CO	= 101002,
				@UserType_Employee	= 101003,
				@UserType_CorporateUser	= 101004,
				@UserType_Relative	= 101007
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		SELECT @UserTypeCode = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId = @inp_nLoggedInUserId
			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'UnionTable.RuleName '
		END 
		
		
		IF @inp_sSortField = 'cmu_grd_18001' -- RuleName
		BEGIN 
			SELECT @inp_sSortField = 'UnionTable.RuleName' 
		END 
		
		IF @inp_sSortField = 'cmu_grd_18002' -- Category
		BEGIN 
			SELECT @inp_sSortField = ' UnionTable.ModeCodeName '
		END 
		IF @inp_sSortField = 'cmu_grd_18006' -- Status
		BEGIN 
			SELECT @inp_sSortField = ' UnionTable.StatusCodeName '
		END 
		IF @inp_sSortField = 'cmu_grd_18005' -- Is Personalizable
		BEGIN 
			SELECT @inp_sSortField = ' UnionTable.InsiderPersonalizeFlag '
		END 
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UnionTable.RuleId),UnionTable.RuleId'
		SELECT @sSQL = @sSQL + ' FROM
									( '
										IF(@UserTypeCode IN (@UserType_Admin,@UserType_CO)) -- Not for CO or Andmin 
										BEGIN	
											SELECT @sSQL = @sSQL + 'SELECT CRM.RuleId,CRM.RuleName,CRM.RuleCategoryCodeId,
											CASE WHEN CCommMode.DisplayCode IS NULL THEN CCommMode.CodeName ELSE CCommMode.DisplayCode END AS ModeCodeName,
											CASE WHEN CStatuse.DisplayCode IS NULL THEN CStatuse.CodeName ELSE CStatuse.DisplayCode END AS StatusCodeName,
											CRM.RuleForCodeId,
												CRM.InsiderPersonalizeFlag,
												CRM.RuleStatusCodeId,
												 '+CAST(@inp_nLoggedInUserId AS VARCHAR(10))+' AS UserInfoId, '+CAST(@UserTypeCode AS VARCHAR(10))+'  AS UserTypeCodeId
											FROM cmu_CommunicationRuleMaster CRM
														
											JOIN com_Code CCommMode ON CRM.RuleCategoryCodeId = CCommMode.CodeID 
											JOIN com_Code CStatuse ON CRM.RuleStatusCodeId = CStatuse.CodeID 	'	
													
												--SELECT @sSQL = @sSQL + ' WHERE (CRM.CreatedBy = '+CAST(@inp_nLoggedInUserId AS VARCHAR(10))+' OR CRM.ModifiedBy = '+CAST(@inp_nLoggedInUserId AS VARCHAR(10))+') '
										END
										ELSE
										BEGIN
											SELECT @sSQL = @sSQL + ' 
											SELECT CRM.RuleId,CRM.RuleName,CRM.RuleCategoryCodeId,
											CASE WHEN CCommMode.DisplayCode IS NULL THEN CCommMode.CodeName ELSE CCommMode.DisplayCode END AS ModeCodeName,
											CASE WHEN CStatuse.DisplayCode IS NULL THEN CStatuse.CodeName ELSE CStatuse.DisplayCode END AS StatusCodeName,
											CRM.RuleForCodeId,
												CRM.InsiderPersonalizeFlag,
												CRM.RuleStatusCodeId,
												 CRForUser.UserInfoId, '+CAST(@UserTypeCode AS VARCHAR(10))+' AS UserTypeCodeId
											FROM cmu_CommunicationRuleMaster CRM
												INNER JOIN vw_ApplicableCommunicationRuleForUser CRForUser
													ON CRM.RuleId = CRForUser.RuleId													
											JOIN com_Code CCommMode ON CRM.RuleCategoryCodeId = CCommMode.CodeID 
											JOIN com_Code CStatuse ON CRM.RuleStatusCodeId = CStatuse.CodeID 				
											WHERE  CRForUser.UserInfoId = '+CAST(@inp_nLoggedInUserId AS VARCHAR(10))+' AND CRM.InsiderPersonalizeFlag = 1'
										END
									SELECT @sSQL = @sSQL + ' ) UnionTable
									WHERE 1 = 1'
		IF (@inp_sRuleName IS NOT NULL AND @inp_sRuleName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UnionTable.RuleName LIKE N''%'+ @inp_sRuleName +'%'' '
		END
		IF (@inp_nCommunicationModeCodeId IS NOT NULL AND @inp_nCommunicationModeCodeId <> 0)	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UnionTable.RuleCategoryCodeId = '+ CAST(@inp_nCommunicationModeCodeId AS VARCHAR(10)) + ' '
		END
		IF (@inp_iRuleStatusCodeId IS NOT NULL AND @inp_iRuleStatusCodeId <> 0)	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UnionTable.RuleStatusCodeId = '+ CAST(@inp_iRuleStatusCodeId AS VARCHAR(10)) + ' '
		END
		IF (@inp_bInsiderPersonalizeFlag IS NOT NULL AND @inp_bInsiderPersonalizeFlag <> 0)	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UnionTable.InsiderPersonalizeFlag = '+ CAST(@inp_bInsiderPersonalizeFlag AS VARCHAR(10)) + ' '
		END
		IF(@UserTypeCode IN (@UserType_Employee	,@UserType_CorporateUser,@UserType_Relative))
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UnionTable.RuleForCodeId =  '+ CAST(@CommunicationRuleForUserType_Insider AS VARCHAR(10)) +' '
		END
		--print(@sSQL)
		EXEC(@sSQL)
	
		
		SELECT	 CRM.RuleId
				,CRM.RuleName AS cmu_grd_18001
				,CASE WHEN CCommMode.DisplayCode IS NULL THEN CCommMode.CodeName ELSE CCommMode.DisplayCode END  AS cmu_grd_18002
				,CRM.InsiderPersonalizeFlag AS cmu_grd_18005
				,CASE WHEN CStatuse.DisplayCode IS NULL THEN CStatuse.CodeName ELSE CStatuse.DisplayCode END AS cmu_grd_18006 
				, STUFF((SELECT ' , ' +cast(CASE WHEN CModeCode.DisplayCode IS NULL THEN CModeCode.CodeName ELSE CModeCode.DisplayCode END as varchar(20)) + ' '
					  FROM cmu_CommunicationRuleModeMaster CRM2
					  JOIN com_Code CModeCode ON CModeCode.CodeID = CRM2.ModeCodeId
					  WHERE CRM.RuleId = CRM2.RuleId
					  AND CRM2.UserId IS NULL
						FOR XML PATH(''), TYPE
						).value('.', 'NVARCHAR(MAX)') 
					,1,2,'') AS cmu_grd_18004
		FROM	#tmpList T INNER JOIN cmu_CommunicationRuleMaster CRM  ON T.EntityID = CRM.RuleId				
				JOIN com_Code CCommMode ON CRM.RuleCategoryCodeId = CCommMode.CodeID 
				JOIN com_Code CStatuse ON CRM.RuleStatusCodeId = CStatuse.CodeID 				
		WHERE	CRM.RuleId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber

		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COMMUNICATIONRULEMASTER_LIST
	END CATCH
END
