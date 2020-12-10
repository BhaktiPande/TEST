IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceRequestNonImplCompanySave')
DROP PROCEDURE [dbo].[st_tra_PreclearanceRequestNonImplCompanySave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the PreclearanceRequest details for non implementing company

Returns:		0, if Success.
				
Created by:		Parag
Created on:		22-Sept-2016

Modification History:
Modified By		Modified On		Description

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_PreclearanceRequestNonImplCompanySave] 
	@inp_tblPreClearanceList	        PreClearanceListType READONLY,
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_PRECLEARANCEREQUEST_SAVE_ERROR	INT = 17512 -- Error occured while saving preclearance for non implementing company
	
	DECLARE @DisplaySequenceNo INT = 0
	DECLARE @PledgeOptionQty DECIMAL(15, 4) = 0

	DECLARE @TranscationType_Pledge INT = 143006
	DECLARE @TranscationType_PledgeInvoke INT = 143008
	DECLARE @TranscationType_PledgeRevoke INT = 143007

	DECLARE @PledgeImpact INT

	--Pledge impact on Post quantity
	DECLARE @PledgeImpactOnPostQuantity_Add INT = 505001
    DECLARE @PledgeImpactOnPostQuantity_Less INT = 505002    
    DECLARE @PledgeImpactOnPostQuantity_No INT = 505004 

	DECLARE @ConfigurationType_RestrictedListSetting INT = 180003

	DECLARE @ConfigurationCode_PreclearanceApproval INT = 185002
	DECLARE @ConfigurationCode_PreclearanceAllowZero INT = 185003

	DECLARE @ApprovalType INT = 0
	DECLARE @PreclearanceApproval_AutoApprove INT = 187001
	DECLARE @PreclearanceApproval_Mannual INT = 187002

	DECLARE @PreclearanceStatus_Approve INT = 144002

    DECLARE @MapToTypeCodeId_PreClearance_NonImplementationCompany INT = 132015
    
    DECLARE @UserInfoId INT
	
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

		-- get next display sequence number
		SELECT @DisplaySequenceNo = MAX(DisplaySequenceNo) FROM tra_PreclearanceRequest_NonImplementationCompany 
		IF @DisplaySequenceNo IS NOT NULL 
		BEGIN
			SET @DisplaySequenceNo = @DisplaySequenceNo + 1
		END
		ELSE
		BEGIN
			SET @DisplaySequenceNo = 1
		END	
		
		-- check if pre-clearance is auto approve or not, if auto approve then change status to approve
		SELECT @ApprovalType = ISNULL(ConfigurationValueCodeId,0) FROM com_CompanySettingConfiguration 
		WHERE ConfigurationTypeCodeId = @ConfigurationType_RestrictedListSetting AND ConfigurationCodeId = @ConfigurationCode_PreclearanceApproval
			
		-- add record into table
		INSERT INTO tra_PreclearanceRequest_NonImplementationCompany
		(RlSearchAuditId, DisplaySequenceNo, PreclearanceRequestForCodeId, UserInfoId, UserInfoIdRelative, TransactionTypeCodeId, SecurityTypeCodeId,
		SecuritiesToBeTradedQty, SecuritiesToBeTradedValue, PreclearanceStatusCodeId, CompanyId, DMATDetailsID, ModeOfAcquisitionCodeId, PledgeOptionQty, 
		CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,IsAutoApproved,ApprovedBy,ApprovedOn)
		
		SELECT PL.RlSearchAuditId, @DisplaySequenceNo,PL.PreclearanceRequestForCodeId,PL.UserInfoId,PL.UserInfoIdRelative,
		PL.TransactionTypeCodeId,PL.SecurityTypeCodeId,PL.SecuritiesToBeTradedQty,PL.SecuritiesToBeTradedValue,
		CASE WHEN @ApprovalType = @PreclearanceApproval_AutoApprove THEN @PreclearanceStatus_Approve ELSE PL.PreclearanceStatusCodeId END,
		PL.COMPANYID,PL.DMATDetailsID,PL.ModeOfAcquisitionCodeId,
		CASE WHEN (TransactionTypeCodeId = @TranscationType_Pledge OR TransactionTypeCodeId = @TranscationType_PledgeInvoke OR TransactionTypeCodeId = @TranscationType_PledgeRevoke)
		THEN CASE WHEN(SELECT IMPT_POST_SHARE_QTY_CODE_ID FROM tra_TransactionTypeSettings 
				WHERE SECURITY_TYPE_CODE_ID = PL.SecurityTypeCodeId AND TRANS_TYPE_CODE_ID = PL.TransactionTypeCodeId 
				AND MODE_OF_ACQUIS_CODE_ID = PL.ModeOfAcquisitionCodeId)=@PledgeImpactOnPostQuantity_No
		THEN PL.SecuritiesToBeTradedQty ELSE 0.0000 END ELSE 0.0000 END,
		PL.UserInfoId,dbo.uf_com_GetServerDate(),1,dbo.uf_com_GetServerDate(),
		CASE WHEN @ApprovalType = @PreclearanceApproval_AutoApprove THEN 1 ELSE 0 END,
		CASE WHEN @ApprovalType = @PreclearanceApproval_AutoApprove THEN 1 ELSE NULL END,
		CASE WHEN @ApprovalType = @PreclearanceApproval_AutoApprove THEN dbo.uf_com_GetServerDate() ELSE NULL END 
		FROM @inp_tblPreClearanceList PL
		
		--Generate FORM E on auto approval
		IF @ApprovalType = @PreclearanceApproval_AutoApprove
		BEGIN
		EXEC @out_nReturnValue = st_tra_GenerateFormDetails 
												@MapToTypeCodeId_PreClearance_NonImplementationCompany,
												@DisplaySequenceNo,
												@UserInfoId,
												@out_nReturnValue = @out_nReturnValue OUTPUT,
												@out_nSQLErrCode = @out_nSQLErrCode OUTPUT,
												@out_sSQLErrMessage = @out_sSQLErrMessage OUTPUT
		END
		SELECT 1 -- this select statement is for PetaPoco

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END TRY

	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_PRECLEARANCEREQUEST_SAVE_ERROR, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
	END CATCH
END