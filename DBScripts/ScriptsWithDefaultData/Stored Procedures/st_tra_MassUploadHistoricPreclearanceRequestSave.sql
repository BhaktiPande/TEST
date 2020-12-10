IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_MassUploadHistoricPreclearanceRequestSave')
DROP PROCEDURE [dbo].[st_tra_MassUploadHistoricPreclearanceRequestSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure will be used for inserting the historic preclearance records for past 6 months.
				This is a one time activity for each implementation company setup. 

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		20-Dec-2015
Modification History:
Modified By		Modified On		Description


Usage:
DECLARE @RC int
EXEC st_tra_MassUploadHistoricPreclearanceRequestSave <parameters>

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_MassUploadHistoricPreclearanceRequestSave] 
	@inp_nPreclearanceRequestId					INT,
	@inp_sUserName								VARCHAR(100),
	@inp_nRelationCodeId						INT,
	@inp_sFirstLastName							VARCHAR(55),
	@inp_dtDateApplyingForPreClearance			DATETIME,
	@inp_nTransactionTypeCodeId					INT,
	@inp_nSecurityTypeCodeId					INT,
	@inp_dSecuritiesToBeTradedQty				DECIMAL(15,4),
	@inp_dSecuritiesToBeTradedValue				DECIMAL(15,4),
	@inp_dProposedTradeRateRangeFrom			DECIMAL(15,4),
	@inp_dProposedTradeRateRangeTo				DECIMAL(15,4),
	@inp_sDMATDetailsINo						VARCHAR(50),
	@inp_nPreclearanceStatusCodeId				INT,
	@inp_dtDateForApprovalRejection				DATETIME,
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
	WITH RECOMPILE
	
AS
BEGIN

	DECLARE @RC INT
	DECLARE @inp_nPreclearanceRequestForCodeId	INT,
	@inp_nUserInfoId							INT,
	@inp_nUserInfoIdRelative					INT,
	@inp_nDMATDetailsID							INT,
	@inp_nCompanyId								INT
	
	DECLARE @PRECLEARANCE_FOR_SELF INT = 142001
	DECLARE @PRECLEARANCE_FOR_RELATIVE INT = 142002
	
	DECLARE @ERROR_INVALIDUSERNAME INT = 11025
	DECLARE @ERROR_RELATIVE_IS_INVALID INT = 17094
	DECLARE @ERROR_INVALIDDEMATNUMBER INT = 11037
	
	
	BEGIN TRY
		SET NOCOUNT ON;
		IF NOT EXISTS(SELECT * FROM usr_Authentication WHERE LoginID = @inp_sUserName)
		BEGIN
			SELECT @out_nReturnValue = @ERROR_INVALIDUSERNAME
			RETURN @out_nReturnValue
		END
		
		SELECT @inp_nUserInfoId = UserInfoId FROM usr_Authentication WHERE LoginID = @inp_sUserName
		
		IF @inp_nRelationCodeId = 100000   --For Self
		BEGIN
			SELECT @inp_nUserInfoIdRelative = NULL
			SELECT @inp_nPreclearanceRequestForCodeId = @PRECLEARANCE_FOR_SELF
		END
		ELSE							--For Relatives
		BEGIN
			IF EXISTS  (SELECT RelativesList.UserInfoIdRelative from (
					SELECT UR.UserInfoIdRelative FROM usr_UserInfo UI 
					JOIN usr_UserRelation UR ON UR.UserInfoId = UI.UserInfoId
					WHERE UR.UserInfoId = @inp_nUserInfoId  
					AND UR.RelationTypeCodeId = @inp_nRelationCodeId
					) AS RelativesList
				join usr_UserInfo UI ON UI.UserInfoid = RelativesList.UserInfoIdRelative 
				AND LOWER(ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'')) = LOWER(@inp_sFirstLastName))
			BEGIN
				SELECT @inp_nUserInfoIdRelative = RelativesList.UserInfoIdRelative from (
					SELECT UR.UserInfoIdRelative FROM usr_UserInfo UI 
					JOIN usr_UserRelation UR ON UR.UserInfoId = UI.UserInfoId
					WHERE UR.UserInfoId = @inp_nUserInfoId  
					AND UR.RelationTypeCodeId = @inp_nRelationCodeId
					) AS RelativesList
				join usr_UserInfo UI ON UI.UserInfoid = RelativesList.UserInfoIdRelative 
				AND LOWER(ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'')) = LOWER(@inp_sFirstLastName)
				
				SELECT @inp_nPreclearanceRequestForCodeId = @PRECLEARANCE_FOR_RELATIVE
			END
			ELSE
			BEGIN
				SELECT @out_nReturnValue = @ERROR_RELATIVE_IS_INVALID
				
				RETURN @out_nReturnValue
			END
		END
		--For finding the DEMATDetails id
		IF @inp_nRelationCodeId = 100000
		BEGIN
			SELECT @inp_nDMATDetailsID = DM.DMATDetailsId FROM usr_DMATDetails DM
			JOIN usr_UserInfo UI on UI.UserInfoid = DM.UserInfoId
			WHERE UI.UserInfoId = @inp_nUserInfoId AND DM.DEMATAccountNumber = @inp_sDMATDetailsINo
		END
		ELSE
		BEGIN
			SELECT @inp_nDMATDetailsID = DM.DMATDetailsId FROM usr_DMATDetails DM
			JOIN usr_UserInfo UI on UI.UserInfoid = DM.UserInfoId
			WHERE UI.UserInfoId = @inp_nUserInfoIdRelative  AND DM.DEMATAccountNumber = @inp_sDMATDetailsINo
		END
		IF @inp_nDMATDetailsID IS NULL OR @inp_nDMATDetailsID = 0
		BEGIN
			SELECT @out_nReturnValue = @ERROR_INVALIDDEMATNUMBER
			
			RETURN @out_nReturnValue
		END
		
		SELECT @inp_nCompanyId = CompanyId FROM mst_Company WHERE IsImplementing = 1
		
		INSERT INTO tra_HistoricPreclearanceRequest (PreclearanceRequestForCodeId, UserInfoId, UserInfoIdRelative, TransactionTypeCodeId, SecurityTypeCodeId,CompanyId, SecuritiesToBeTradedQty, SecuritiesToBeTradedValue, PreclearanceStatusCodeId, ProposedTradeRateRangeFrom, ProposedTradeRateRangeTo, DMATDetailsID, DateApplyingForPreClearance, DateForApprovalRejection)
		VALUES(@inp_nPreclearanceRequestForCodeId, @inp_nUserInfoId, @inp_nUserInfoIdRelative, @inp_nTransactionTypeCodeId, @inp_nSecurityTypeCodeId,@inp_nCompanyId, @inp_dSecuritiesToBeTradedQty, @inp_dSecuritiesToBeTradedValue, @inp_nPreclearanceStatusCodeId,@inp_dProposedTradeRateRangeFrom,@inp_dProposedTradeRateRangeTo, @inp_nDMATDetailsID, @inp_dtDateApplyingForPreClearance, @inp_dtDateForApprovalRejection )
		
		SET @inp_nPreclearanceRequestId = SCOPE_IDENTITY()
		
		SELECT @inp_nPreclearanceRequestId AS PreclearanceRequestId
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		SET @out_nReturnValue =  @out_nSQLErrCode
		RETURN @out_nReturnValue
	END CATCH
END