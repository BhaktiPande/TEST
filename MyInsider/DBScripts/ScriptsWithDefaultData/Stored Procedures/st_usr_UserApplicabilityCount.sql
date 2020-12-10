IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserApplicabilityCount')
DROP PROCEDURE [dbo].[st_usr_UserApplicabilityCount]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************
Description:	Procedure to get applicablity count,  for user base on rule type,

Returns:		Return 0, if success.
				
Created by:		Parag
Created on:		10-Jul-2015

Modification History:
Modified By		Modified On		Description


******************************************************************************************************************

Usage:

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_usr_UserApplicabilityCount]
	@inp_iUserInfoId 		INT,
	@inp_nApplicabilityType INT,
	@out_nReturnValue 		INT = 0 OUTPUT,
	@out_nSQLErrCode 		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_USERRULEAPPLICABILITY		INT = -1 -- error code for user rule applicability not able to fetch properly 
	
	DECLARE @nRuleType_TradingPolicy		INT = 132002
	DECLARE @nRuleType_PolicyDocument		INT = 132001
	
	DECLARE @nWindowStatusCodeId_Active		INT = 131002
	
	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		-- check and return list any policy document list if applicable to user
		IF(@inp_nApplicabilityType = @nRuleType_PolicyDocument)
		BEGIN
			SELECT COUNT(APD.ApplicabilityMstId) 
			FROM 
				vw_ApplicablePolicyDocumentForUser APD 
			WHERE 
				APD.UserInfoId = @inp_iUserInfoId 
		END
		
		-- check and return list any trading policy list if applicable to user
		IF(@inp_nApplicabilityType = @nRuleType_TradingPolicy)
		BEGIN
			SELECT COUNT(ATP.ApplicabilityMstId) 
			FROM 
				vw_ApplicableTradingPolicyForUser ATP 
			WHERE 
				ATP.UserInfoId = @inp_iUserInfoId 
		END
		
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_USERRULEAPPLICABILITY
	END CATCH
END
