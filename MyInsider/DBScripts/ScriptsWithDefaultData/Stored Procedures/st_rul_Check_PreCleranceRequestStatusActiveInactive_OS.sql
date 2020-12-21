IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_Check_PreCleranceRequestStatusActiveInactive_OS')
DROP PROCEDURE [dbo].[st_rul_Check_PreCleranceRequestStatusActiveInactive_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Check the PreClearance Request in case of status is active or inactive

Returns:		0, if Success.
				
Created by:		Rajashri
Created on:		05-Aug-2020
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_Check_PreCleranceRequestStatusActiveInactive_OS]
	@inp_iTradingPolicyId		INT,
	@inp_bStExSubmitTradeDiscloAllTradeFlag BIT,
    @inp_bPreClrTradesApprovalReqFlag	BIT, 
	@inp_sGenExceptionFor												VARCHAR(1024), 
	@inp_tblPreClearanceSecuritywise SecuritywiseLimitsType				READONLY,
	@inp_tblContinousSecuritywise SecuritywiseLimitsType				READONLY,	
	@inp_tblPreclearanceTransactionSecurityMap TradingPolicyForTransactionSecurityMap   READONLY,
	@inp_sSelectedPreClearancerequiredforTransactionValue				VARCHAR(1024),
	@inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue	VARCHAR(1024),
	@inp_sSelectedContraTradeSecuirtyType								VARCHAR(1024),
					
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	
	DECLARE @ERR_INPRECLERANCEREQUEST INT = 11025 -- Error occuerd while Preclerance Request the Name		
	DECLARE @nRetValue INT	

	DECLARE @nMapToTypePreclearance								INT = 132015
	DECLARE @nMapToTypeContinous								INT = 132005
	DECLARE @nMapToTypeProhibitPreclearanceDuringNonTrading		INT = 132007
	DECLARE @nMapToTypeTradingPolicyExceptionforTransactionMode	INT = 132008
	DECLARE @nPrevTradingPolicyId								INT	

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

				  INSERT INTO com_DocumentObjectMapping 	
				  SELECT  DocumentId,MapToTypeCodeId,@inp_iTradingPolicyId,NULL FROM com_DocumentObjectMapping
				  WHERE MapToId = @nPrevTradingPolicyId AND MapToTypeCodeId = 132002
				
				IF(@inp_bPreClrTradesApprovalReqFlag = 0)
				BEGIN
					INSERT INTO rul_TradingPolicySecuritywiseLimits_OS 
					SELECT @inp_iTradingPolicyId,SecurityTypeCodeId,@nMapToTypePreclearance,NoOfShares,PercPaidSubscribedCap,ValueOfShares
					FROM @inp_tblPreClearanceSecuritywise
				END
					
				IF(@inp_bStExSubmitTradeDiscloAllTradeFlag = 0)
				BEGIN
					INSERT INTO rul_TradingPolicySecuritywiseLimits_OS 
					SELECT @inp_iTradingPolicyId,SecurityTypeCodeId,@nMapToTypeContinous,NoOfShares,PercPaidSubscribedCap,ValueOfShares
					FROM @inp_tblContinousSecuritywise
				END
					
					DELETE rul_TradingPolicyForTransactionMode_OS WHERE TradingPolicyId = @inp_iTradingPolicyId 
					
					-- Insert Value PreClearance required for Transaction  
					IF @inp_sSelectedPreClearancerequiredforTransactionValue IS NOT NULL OR @inp_sSelectedPreClearancerequiredforTransactionValue <> '' 
					BEGIN
						INSERT INTO rul_TradingPolicyForTransactionMode_OS 
									SELECT @inp_iTradingPolicyId,@nMapToTypePreclearance,Items 
									FROM uf_com_Split(@inp_sSelectedPreClearancerequiredforTransactionValue)
					END
					-- Insert Value  PreClearance Prohibit forNon Trading for Transaction 
					IF @inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue IS NOT NULL 
						OR @inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue <> ''
					BEGIN
						INSERT INTO rul_TradingPolicyForTransactionMode_OS 
									SELECT @inp_iTradingPolicyId,@nMapToTypeProhibitPreclearanceDuringNonTrading,Items 
									FROM uf_com_Split(@inp_sSelectedPreClearanceProhibitforNonTradingforTransactionValue)
					END
					-- Insert Value General Exception For
					IF @inp_sGenExceptionFor IS NOT NULL OR @inp_sGenExceptionFor <> ''
					BEGIN
						INSERT INTO rul_TradingPolicyForTransactionMode_OS 
									SELECT @inp_iTradingPolicyId,@nMapToTypeTradingPolicyExceptionforTransactionMode,Items 
									FROM uf_com_Split(@inp_sGenExceptionFor)
					END
				
				INSERT INTO rul_TradingPolicyForTransactionSecurity_OS 
				SELECT @inp_iTradingPolicyId,MapToTypeCodeID,TransactionModeCodeId,SecurityTypeCodeId
				FROM @inp_tblPreclearanceTransactionSecurityMap
				
				set @inp_sSelectedContraTradeSecuirtyType= '139001,139002,139003,139004,139005'
				IF(@inp_sSelectedContraTradeSecuirtyType IS NOT NULL OR @inp_sSelectedContraTradeSecuirtyType <> '')
				BEGIN	
				 DELETE FROM rul_TradingPolicyForSecurityMode_OS
			     WHERE TradingPolicyId = @inp_iTradingPolicyId AND MapToTypeCodeId = 132013
				INSERT INTO rul_TradingPolicyForSecurityMode_OS
								SELECT @inp_iTradingPolicyId,132013,Items 
								FROM uf_com_Split(@inp_sSelectedContraTradeSecuirtyType)	
			    END

				SET @out_nReturnValue=0
				RETURN @out_nReturnValue 
	END	 TRY	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_INPRECLERANCEREQUEST, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END