IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_CommunicationRuleMasterSave')
DROP PROCEDURE [dbo].[st_cmu_CommunicationRuleMasterSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the CommunicationRuleMaster details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		19-May-2015
Modification History:
Modified By		Modified On		Description
Gaurishankar	23-Jun-2015		Added check for Communication mode already exist.
Gaurishankar	24-Jun-2015		Change the error code
Gaurishankar	19-Jan-2016		Changes for delete the communication Rule mode.
Raghvendra	07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_cmu_CommunicationRuleMasterSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE  PROCEDURE [dbo].[st_cmu_CommunicationRuleMasterSave] 
	@inp_tblCommunicationRuleModeMasterType	CommunicationRuleModeMasterType READONLY,	
	@inp_iRuleId				INT,
	@inp_sRuleName				NVARCHAR(255),
	@inp_sRuleDescription		NVARCHAR(1024),
	@inp_sRuleForCodeId			VARCHAR(50),
	@inp_iRuleCategoryCodeId	INT,
	@inp_sInsiderPersonalizeFlag	BIT,
	@inp_sTriggerEventCodeId	VARCHAR(500),
	@inp_sOffsetEventCodeId		VARCHAR(500),
	@inp_iEventsApplyToCodeId	INT,
	@inp_iRuleStatusCodeId		INT,
	@inp_nUserId				INT,									-- Id of the user inserting/updating the CommunicationRuleMaster
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_COMMUNICATIONRULEMASTER_SAVE INT
	DECLARE @ERR_COMMUNICATIONRULEMASTER_NOTFOUND INT
	DECLARE @ERR_COMMUNICATIONRULEMASTER_COMMUNICATIONMODE_EXIST INT
	DECLARE @ERR_COMMUNICATIONRULEMASTER_RULENAME_EXIST INT
	DECLARE @ERR_COMMUNICATIONRULEMASTER_COMMUNICATIONMODE_DELETE INT
	DECLARE @nRuleIdCount_FOR_CO INT = 0
	DECLARE @nRuleIdCount_FOR_Insider INT = 0
	DECLARE @tblcmu_DELETECommunicationRuleModeMaster TABLE ( 
				[RuleModeId] [int] ,
				[ModeCodeId] [int] NOT NULL,
				[TemplateId] [int] NULL,
				[UserId] [int] NULL	
			)
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
	
		--Initialize variables
		SELECT	@ERR_COMMUNICATIONRULEMASTER_NOTFOUND = 18016,
				@ERR_COMMUNICATIONRULEMASTER_SAVE = 18018,
				@ERR_COMMUNICATIONRULEMASTER_RULENAME_EXIST = 18019,
				@ERR_COMMUNICATIONRULEMASTER_COMMUNICATIONMODE_EXIST = 18061,
				@ERR_COMMUNICATIONRULEMASTER_COMMUNICATIONMODE_DELETE = 18068

		SELECT @nRuleIdCount_FOR_CO = MAX (A.RuleIdCount) FROM (SELECT COUNT(RuleId) AS RuleIdCount
			  FROM @inp_tblCommunicationRuleModeMasterType
			  WHERE RuleId = @inp_iRuleId AND [UserId] IS NULL
			  GROUP BY ModeCodeId
			  ) A
		SELECT @nRuleIdCount_FOR_Insider = MAX (A.RuleIdCount) FROM (SELECT COUNT(RuleId) AS RuleIdCount
			  FROM @inp_tblCommunicationRuleModeMasterType
			  WHERE RuleId = @inp_iRuleId AND [UserId] IS NOT NULL
			  GROUP BY ModeCodeId
			  ) A
		IF @nRuleIdCount_FOR_CO > 1 OR @nRuleIdCount_FOR_Insider > 1
		BEGIN
			SET @out_nReturnValue = @ERR_COMMUNICATIONRULEMASTER_COMMUNICATIONMODE_EXIST
			RETURN @out_nReturnValue
		END
			  
		IF EXISTS(SELECT RuleId FROM cmu_CommunicationRuleMaster 
					WHERE RuleName = @inp_sRuleName AND (@inp_iRuleId = 0 OR RuleId != @inp_iRuleId))
		BEGIN
			SET @out_nReturnValue = @ERR_COMMUNICATIONRULEMASTER_RULENAME_EXIST
			RETURN @out_nReturnValue
		END
		--Save the CommunicationRuleMaster details
		IF @inp_iRuleId = 0
		BEGIN
			Insert into cmu_CommunicationRuleMaster(
					RuleName,
					RuleDescription,
					RuleForCodeId,
					RuleCategoryCodeId,
					InsiderPersonalizeFlag,
					TriggerEventCodeId,
					OffsetEventCodeId,
					EventsApplyToCodeId,
					RuleStatusCodeId,
					CreatedBy, CreatedOn, ModifiedBy,	ModifiedOn )
			Values (
					@inp_sRuleName,
					@inp_sRuleDescription,
					@inp_sRuleForCodeId,
					@inp_iRuleCategoryCodeId,
					@inp_sInsiderPersonalizeFlag,
					@inp_sTriggerEventCodeId,
					@inp_sOffsetEventCodeId,
					@inp_iEventsApplyToCodeId,
					@inp_iRuleStatusCodeId,
					@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate() )
					
			SELECT @inp_iRuleId = @@IDENTITY
			
			INSERT INTO [dbo].[cmu_CommunicationRuleModeMaster]
			   ([RuleId]
			   ,[ModeCodeId]
			   ,[TemplateId]
			   ,[WaitDaysAfterTriggerEvent]
			   ,[ExecFrequencyCodeId]
			   ,[NotificationLimit]
			   ,[UserId]
			   ,[CreatedBy]
			   ,[CreatedOn]
			   ,[ModifiedBy]
			   ,[ModifiedOn])
			SELECT @inp_iRuleId
			   ,[ModeCodeId]
			   ,[TemplateId]
			   ,[WaitDaysAfterTriggerEvent]
			   ,[ExecFrequencyCodeId]
			   ,[NotificationLimit]
			   ,[UserId]
			   ,@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate()
		   FROM @inp_tblCommunicationRuleModeMasterType
		END
		ELSE
		BEGIN
			--Check if the CommunicationRuleMaster whose details are being updated exists
			IF (NOT EXISTS(SELECT RuleId FROM cmu_CommunicationRuleMaster WHERE RuleId = @inp_iRuleId))			
			BEGIN	
				SET @out_nReturnValue = @ERR_COMMUNICATIONRULEMASTER_SAVE
				RETURN (@out_nReturnValue)
			END	
			Update cmu_CommunicationRuleMaster
			Set 	RuleName = @inp_sRuleName,
					RuleDescription = @inp_sRuleDescription,
					RuleForCodeId = @inp_sRuleForCodeId,
					RuleCategoryCodeId = @inp_iRuleCategoryCodeId,
					InsiderPersonalizeFlag = @inp_sInsiderPersonalizeFlag,
					TriggerEventCodeId = @inp_sTriggerEventCodeId,
					OffsetEventCodeId = @inp_sOffsetEventCodeId,
					EventsApplyToCodeId = @inp_iEventsApplyToCodeId,
					RuleStatusCodeId = @inp_iRuleStatusCodeId,
					ModifiedBy	= @inp_nUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()

			Where RuleId = @inp_iRuleId	
						
			INSERT INTO @tblcmu_DELETECommunicationRuleModeMaster				
				SELECT CRM.RuleModeId,CRM.ModeCodeId,CRM.TemplateId, CRM.UserId FROM cmu_CommunicationRuleModeMaster CRM
				LEFT JOIN @inp_tblCommunicationRuleModeMasterType TCRM ON CRM.RuleModeId = TCRM.RuleModeId AND 
				CRM.TemplateId = TCRM.TemplateId
				where CRM.RuleId = @inp_iRuleId AND CRM.UserId IS NULL AND TCRM.RuleModeId IS NULL
				
			IF EXISTS(SELECT RuleModeId FROM @tblcmu_DELETECommunicationRuleModeMaster)
			BEGIN
				IF EXISTS(SELECT NQ.NotificationQueueId FROM cmu_NotificationQueue NQ
						INNER JOIN cmu_CommunicationRuleModeMaster CRM ON NQ.RuleModeId = CRM.RuleModeId
						INNER JOIN @tblcmu_DELETECommunicationRuleModeMaster TDCRM ON CRM.TemplateId = TDCRM.TemplateId AND CRM.ModeCodeId = TDCRM.ModeCodeId
						WHERE CRM.RuleId = @inp_iRuleId
					)
				BEGIN
					SET @out_nReturnValue = @ERR_COMMUNICATIONRULEMASTER_COMMUNICATIONMODE_DELETE
					RETURN (@out_nReturnValue)
				END
				DELETE CRM
				FROM cmu_CommunicationRuleModeMaster CRM
				INNER JOIN @tblcmu_DELETECommunicationRuleModeMaster TDCRM ON CRM.TemplateId = TDCRM.TemplateId AND CRM.ModeCodeId = TDCRM.ModeCodeId
				WHERE CRM.RuleId = @inp_iRuleId
			END
			INSERT INTO [dbo].[cmu_CommunicationRuleModeMaster]
					   ([RuleId]
					   ,[ModeCodeId]
					   ,[TemplateId]
					   ,[WaitDaysAfterTriggerEvent]
					   ,[ExecFrequencyCodeId]
					   ,[NotificationLimit]
					   ,[UserId]
					   ,[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])
					SELECT @inp_iRuleId
					   ,[ModeCodeId]
					   ,[TemplateId]
					   ,[WaitDaysAfterTriggerEvent]
					   ,[ExecFrequencyCodeId]
					   ,[NotificationLimit]
					   ,[UserId]
					   ,@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate()
				   FROM @inp_tblCommunicationRuleModeMasterType
				   WHERE RuleModeId = 0
				   
				   UPDATE CRMM
				   SET [ModeCodeId] = TBLCRMM.[ModeCodeId]
					   ,[TemplateId] = TBLCRMM.[TemplateId]
					   ,[WaitDaysAfterTriggerEvent] = TBLCRMM.[WaitDaysAfterTriggerEvent]
					   ,[ExecFrequencyCodeId] = TBLCRMM.[ExecFrequencyCodeId]
					   ,[NotificationLimit] = TBLCRMM.[NotificationLimit]
					   ,[ModifiedBy] = @inp_nUserId
					   , ModifiedOn = dbo.uf_com_GetServerDate()
				   FROM [dbo].[cmu_CommunicationRuleModeMaster] CRMM
				   INNER JOIN @inp_tblCommunicationRuleModeMasterType TBLCRMM ON TBLCRMM.RuleModeId = CRMM.RuleModeId
				   WHERE TBLCRMM.RuleModeId IS NOT NULL OR TBLCRMM.RuleModeId != 0
		END
		
		-- in case required to return for partial save case.
		Select RuleId, RuleName, RuleDescription, RuleForCodeId, RuleCategoryCodeId, InsiderPersonalizeFlag, TriggerEventCodeId, OffsetEventCodeId, RuleStatusCodeId, EventsApplyToCodeId
			From cmu_CommunicationRuleMaster
			Where RuleId = @inp_iRuleId
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_COMMUNICATIONRULEMASTER_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END