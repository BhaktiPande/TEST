IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_CommunicationRuleMasterDetails')
DROP PROCEDURE [dbo].[st_cmu_CommunicationRuleMasterDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the CommunicationRuleMaster details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		27-May-2015

Modification History:
Modified By		Modified On	Description

Usage:
EXEC st_cmu_CommunicationRuleMasterDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_cmu_CommunicationRuleMasterDetails]
	@inp_iRuleId INT,							-- Id of the CommunicationRuleMaster whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_COMMUNICATIONRULEMASTER_GETDETAILS INT
	DECLARE @ERR_COMMUNICATIONRULEMASTER_NOTFOUND INT
	DECLARE @IsApplicabilityDefined BIT =0
	DECLARE @MapToTypeCommunicationRule INT = 132006

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		

		--Initialize variables
		SELECT	@ERR_COMMUNICATIONRULEMASTER_NOTFOUND = 18016, 
				@ERR_COMMUNICATIONRULEMASTER_GETDETAILS = 18016

		--Check if the CommunicationRuleMaster whose details are being fetched exists
		IF (NOT EXISTS(SELECT RuleId FROM cmu_CommunicationRuleMaster WHERE RuleId = @inp_iRuleId))
		BEGIN	
				SET @out_nReturnValue = @ERR_COMMUNICATIONRULEMASTER_NOTFOUND
				RETURN (@out_nReturnValue)
		END
		
		
		IF ( EXISTS(SELECT ApplicabilityId FROM rul_ApplicabilityMaster WHERE MapToTypeCodeId = @MapToTypeCommunicationRule AND MapToId = @inp_iRuleId))
		BEGIN	
				SELECT @IsApplicabilityDefined = 1
		END

		--Fetch the CommunicationRuleMaster details
		Select RuleId, RuleName, RuleDescription, RuleForCodeId, RuleCategoryCodeId, InsiderPersonalizeFlag, TriggerEventCodeId,
				 OffsetEventCodeId, RuleStatusCodeId, EventsApplyToCodeId,
				 @IsApplicabilityDefined AS IsApplicabilityDefined, CreatedBy AS UserId
			From cmu_CommunicationRuleMaster 			
			Where RuleId = @inp_iRuleId
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_COMMUNICATIONRULEMASTER_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

