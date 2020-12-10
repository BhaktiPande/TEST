IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceRequestDetails')
DROP PROCEDURE [dbo].[st_tra_PreclearanceRequestDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the PreclearanceRequest details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		22-Apr-2015

Modification History:
Modified By		Modified On		Description
Tushar			25-Apr-2015		Add Trading Policy ID in Table.
Tushar			14-May-2015		Return New Column with code name and insider name.
Tushar			15-May-2015		Add Error Code Number in procedure.
Tushar			18-May-2015		Add New Colun for Preclearance Approve/Reject case case
Tushar			19-May-2015		Changes for new chnages for Security wise limits.
Tushar			27-May-2015		return new column SecuritiesToBeTradedValue
Tushar			03-Jun-2015		Return ReasonForNotTradingCodeText 
Tushar			14-Jul-2015		Return NotTradedCode.DisplayCode
Tushar			21-Aug-2015		Change  ISNULL(NotTradedCode.DisplayCode,NotTradedCode.CodeName) query
Tushar			07-Sep-2015		After pre-clearance approve or reject, respective date should appear on the page with status.
Parag			11-Sep-2015		Made change to get contra trade period in details fetched
Parag			25-Nov-2015		Made change to get flag indicate which secuirty pool should be use for per-clearance
Parag			30-Nov-2015		Made change to get quantity use for transaction 
Parag			29-Apr-2016		Made change to get quantity remain for trading for pre-clearance
Parag			18-Aug-2016		Code merge with ESOP code

Usage:
EXEC st_tra_PreclearanceRequestDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_PreclearanceRequestDetails]
	@inp_sPreclearanceRequestId							INT,						-- Id of the PreclearanceRequest whose details are to be fetched.
	@out_nReturnValue									INT = 0 OUTPUT,
	@out_nSQLErrCode									INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage									NVARCHAR(500) = '' OUTPUT,	-- Output SQL Error Message, if error occurred.
	@out_PreclearanceValidityDate                       DATETIME = NULL    OUTPUT
	
AS
BEGIN
	DECLARE @ERR_PRECLEARANCEREQUEST_GETDETAILS			INT
	DECLARE @ERR_PRECLEARANCEREQUEST_NOTFOUND			INT
	
	DECLARE @nTotalQtyTraded							INT
	DECLARE @dPreclearanceValidityDateChanged           DATETIME = NULL

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		
		
		--Initialize variables
		SELECT	@ERR_PRECLEARANCEREQUEST_NOTFOUND		= 17096,
				@ERR_PRECLEARANCEREQUEST_GETDETAILS		= -17098

		--Check if the PreclearanceRequest whose details are being fetched exists
		IF (NOT EXISTS(SELECT PreclearanceRequestId FROM tra_PreclearanceRequest WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId))
		BEGIN	
				SET @out_nReturnValue = @ERR_PRECLEARANCEREQUEST_NOTFOUND
				RETURN (@out_nReturnValue)
		END


		IF (EXISTS(SELECT PreclearanceRequestId FROM tra_PreclearanceRequest WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId))
		BEGIN	
			    EXEC st_tra_GetPreclearanceValidityDate @inp_sPreclearanceRequestId, @out_PreclearanceValidityDate OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT

		END
		
		-- get total quantity for which trading details are enter irrespective of transcation master status
		SELECT @nTotalQtyTraded = SUM(td.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)) - SUM(td.Quantity2 * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)) FROM tra_TransactionMaster tm 
		JOIN tra_TransactionDetails td on tm.TransactionMasterId = td.TransactionMasterId
		WHERE tm.PreclearanceRequestId = @inp_sPreclearanceRequestId
		--For getting Preclearance date Updated by CO/Trading Window. 
		IF EXISTS(SELECT eve.EventDate FROM eve_EventLog eve WHERE eve.EventCodeId = 153018 AND eve.MapToId = @inp_sPreclearanceRequestId)
		BEGIN
		  SELECT @dPreclearanceValidityDateChanged = eve.EventDate FROM eve_EventLog eve WHERE eve.EventCodeId = 153018 AND eve.MapToId = @inp_sPreclearanceRequestId
		END

		--Fetch the PreclearanceRequest details
		SELECT PR.PreclearanceRequestId, PreclearanceRequestForCodeId, PR.UserInfoId,
			  CASE WHEN TM.PreclearanceRequestId IS NULL THEN 'PNT' + CONVERT(VARCHAR,TM.TransactionMasterId)  ELSE 'PCL' + CONVERT(VARCHAR,TM.TransactionMasterId) END AS  PreclearanceRequestDisplayCode,
			  UserInfoIdRelative, TransactionTypeCodeId, PR.SecurityTypeCodeId, SecuritiesToBeTradedQty, 
			  PreclearanceStatusCodeId, PR.CompanyId, ProposedTradeRateRangeFrom, ProposedTradeRateRangeTo, 
			  DMATDetailsID, ReasonForNotTradingCodeId, ReasonForNotTradingText,PR.CreatedBy,PR.CreatedOn,TM.TransactionMasterId,
			  TM.TradingPolicyId,
			  UF.EmployeeId,
			  UF.FirstName + ' ' + UF.LastName AS UserName,
			  secutirycode.CodeName AS SecurityTypeText,
			  transactioncode.CodeName AS TransactionTypeText,
			  PR.ReasonForRejection,
			  C.CompanyName,
			  RelativeTypeCode.CodeName AS PreClearanceFor,
			  UF1.FirstName + ' ' + UF1.LastName AS RelativeName,
			  SecuritiesToBeTradedValue,
			  ISNULL(NotTradedCode.DisplayCode,NotTradedCode.CodeName) AS ReasonForNotTradingCodeText
			   ,PreStatusCode.CodeName AS PreclearanceStatusName
			  ,StatusCode.EventDate AS EventDate
			  , TP.GenContraTradeNotAllowedLimit AS ContraTradePeriod
			  , PR.ESOPExcerciseOptionQtyFlag
			  , PR.OtherESOPExcerciseOptionQtyFlag
			  , PR.ESOPExcerciseOptionQty
			  , PR.OtherExcerciseOptionQty
			  , CASE WHEN (SecuritiesToBeTradedQty - @nTotalQtyTraded) <= 0 THEN 0 ELSE (SecuritiesToBeTradedQty - @nTotalQtyTraded) END AS QtyRemainForTrade
			  , PR.ModeOfAcquisitionCodeId
			  ,TP.PreClrUPSIDeclaration
			  ,PR.ReasonForApproval
			  ,ReasonForApproval.CodeName AS ReasonForApprovalText
			  ,TP.PreClrApprovalReasonReqFlag
			  ,@out_PreclearanceValidityDate AS PreclearanceValidityDate
			  ,PR.SecuritiesToBeTradedQtyOld AS PreclearanceTakenQtyOld
			  ,@dPreclearanceValidityDateChanged AS PreclearanceValidityDateChanged
		FROM tra_PreclearanceRequest PR
		LEFT JOIN tra_TransactionMaster TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId
		JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
		LEFT JOIN com_Code transactioncode ON PR.TransactionTypeCodeId = transactioncode.CodeID
		LEFT JOIN com_Code secutirycode ON PR.SecurityTypeCodeId = secutirycode.CodeID
		JOIN mst_Company C ON PR.CompanyId = C.CompanyId
		JOIN com_Code RelativeTypeCode ON PR.PreclearanceRequestForCodeId = RelativeTypeCode.CodeID
		LEFT JOIN usr_UserInfo UF1 ON PR.UserInfoIdRelative = UF1.UserInfoId
		LEFT JOIN com_Code NotTradedCode ON PR.ReasonForNotTradingCodeId = NotTradedCode.CodeID
		LEFT JOIN eve_EventLog StatusCode ON PR.PreclearanceRequestId = StatusCode.MapToId 
		AND MapToTypeCodeId = 132004 AND EventCodeId  in (153016,153017)
		LEFT JOIN com_Code PreStatusCode ON PR.PreclearanceStatusCodeId = PreStatusCode.CodeID
		LEFT JOIN com_Code ReasonForApproval ON PR.ReasonForApprovalCodeId=ReasonForApproval.CodeID
		LEFT JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
		WHERE PR.PreclearanceRequestId = @inp_sPreclearanceRequestId
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_PRECLEARANCEREQUEST_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

