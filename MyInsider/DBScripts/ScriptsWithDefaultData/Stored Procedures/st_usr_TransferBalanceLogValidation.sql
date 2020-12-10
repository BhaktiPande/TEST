IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_TransferBalanceLogValidation')
DROP PROCEDURE [dbo].[st_usr_TransferBalanceLogValidation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure used for transfer balance validtion.

Returns:		0, if Success.
				
Created by:		Tushar
Created on:		17-Oct-2016
Modification History:
Modified By		Modified On		Description
Tushar			20-Oct-2014		Add Validation error code for ESOP quantity is not zero.
Tushar			21-Oct-2016		Change Negative balance validation.
Tushar			24-Oct-2016		Change balance validation.
Tushar			25-Oct-2016		Change balance validation for quantity.
Tushar			25-Oct-2016		Change balance validation Partial trade case.
Tushar			26-Oct-2016		Select statement comment.
Usage:
DECLARE @RC int
EXEC st_usr_TransferBalanceLogValidation 49,139001,2,191001
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_TransferBalanceLogValidation]
	@inp_iUserInfoId						INT,
	@inp_iForUserInfoId						INT,
	@inp_iSecurityTransferOption			INT, --191001 get qty for selected demat 191002 cumulative sum of exclude this dmat
	@inp_dTransferQuantity					DECIMAL(15,0),
	@inp_iSecurityTypeCodeID				INT,
	@inp_iFromDEMATAcountID					INT,
	@inp_iToDEMATAcountID					INT,
	@inp_iTransferFor						INT,
	@inp_dTransferESOPQuantity              DECIMAL(15,0),
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TransferBalanceLogValidation INT = 11457 -- Error occurred while securities transfer validation.
	DECLARE @nRetValue INT
	
	DECLARE @ERR_USERINFOMANDATORY INT = 11458				-- User Information is mandatory.
	DECLARE @ERR_USERNRELATIVEIFOMANDATORY INT = 11459		-- User Relative Information is mandatory.
	DECLARE @ERR_TRANSFERQTYGREATERTHANZERO INT = 11460		-- Enter transfer quantity is greater than zero.
	DECLARE @ERR_SECURITYTYPEMANDATORY INT = 11461			-- Security Type is mandatory.
	DECLARE @ERR_FROMDMATIDMANDAOTRY INT = 11462			-- From DEMAT Account is mandatory.
	DECLARE @ERR_TODMATIDMANDAOTRY INT = 11463				-- To DEMAT Account is mandatory.
	DECLARE @ERR_QTYNOTAVAILABLE INT = 11464				-- You cannot transfer the securities, Transfer quantity is greater than the available quantity.
	DECLARE @ERR_FROMDMATPENDINGTRANSACTIONEXISTS INT = 11465 -- You cannot transfer the securities, From Demat account number have some incomplete and pending transactions.
	DECLARE @ERR_TODMATPENDINGTRANSACTIONEXISTS INT = 11466	-- You cannot transfer the securities, To Demat account number have some incomplete and pending transactions.
	DECLARE @ERR_PENDINGTRANSACTIONEXISTS INT = 11467		-- You cannot transfer the securities, From and To Demat account number have some incomplete and pending transactions.
	DECLARE @ERR_FROMANDTODEMATSAME INT = 11468				-- Select From and To Demat account number different.
	DECLARE @ERR_PLEDGEQTYNOTZERO INT = 11469				-- You cannot transfer the securities, Pledge available quantity is greater than zero.
	DECLARE @ERR_LASTPERIODENDNOTSUBMITTED INT = 11470		-- You cannot transfer the securities, previous period end is not submitted.
	DECLARE @ERR_ESOPBALANCENOTZERO INT = 11485				-- You cannot transfer the securities, ESOP quantity is not zero.

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
		
		DECLARE @nSecurityTransferfromselectedDemataccount	INT = 191001
		DECLARE @nSecurityTransferfromAllDemataccount		INT = 191002
		
		DECLARE @nTransactionStatusNoSubmitted INT = 148002
		
		DECLARE @nTransferForSelf INT  = 142001
		DECLARE @nTransferForRelative INT  = 142002
		
		DECLARE @dAvailbaleQty DECIMAL(30,0)
		DECLARE @dAvailbalePledgeQty DECIMAL(30,0)
		DECLARE @dAvailbaleESOPQty DECIMAL(30,0)
		DECLARE @dAvailableOtherQty DECIMAL(30,0)
		DECLARE @RC INT
		
		-- Common Validation
		-- User Info id is passed
		IF @inp_iUserInfoId IS NULL OR @inp_iUserInfoId = 0
		BEGIN
			SET @out_nReturnValue = @ERR_USERINFOMANDATORY
			RETURN @out_nReturnValue
		END
		
		-- Check relative ID enter
		IF @inp_iTransferFor = @nTransferForRelative AND ( @inp_iForUserInfoId IS NULL OR @inp_iForUserInfoId = 0)
		BEGIN
			SET @out_nReturnValue = @ERR_USERNRELATIVEIFOMANDATORY
			RETURN @out_nReturnValue
		END
		
		-- Security Type check
		IF @inp_iSecurityTypeCodeID IS NULL OR @inp_iSecurityTypeCodeID = 0
		BEGIN
			SET @out_nReturnValue = @ERR_SECURITYTYPEMANDATORY
			RETURN @out_nReturnValue
		END
		-- TO demat id mandatory
		IF @inp_iToDEMATAcountID IS NULL OR @inp_iToDEMATAcountID = 0
		BEGIN
			SET @out_nReturnValue = @ERR_TODMATIDMANDAOTRY
			RETURN @out_nReturnValue
		END
		
		-- Check Quantity is available or not
		IF @inp_iTransferFor = @nTransferForSelf
		BEGIN
			IF @inp_iSecurityTransferOption = @nSecurityTransferfromAllDemataccount
			BEGIn
				EXECUTE @RC = st_usr_GetAvailableQuantityForIndividualDematOrAllDemat @inp_iUserInfoId,@inp_iUserInfoId,@inp_iSecurityTypeCodeID,
																			  @inp_iToDEMATAcountID,@inp_iSecurityTransferOption,
																			  @dAvailbaleQty OUTPUT, @dAvailbalePledgeQty OUTPUT,@dAvailbaleESOPQty OUTPUT,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, 
																			  @out_sSQLErrMessage OUTPUT
			
			END
			ELSE
			BEGIN
			
			EXECUTE @RC = st_usr_GetAvailableQuantityForIndividualDematOrAllDemat @inp_iUserInfoId,@inp_iUserInfoId,@inp_iSecurityTypeCodeID,
																			  @inp_iFromDEMATAcountID,@inp_iSecurityTransferOption,
																			  @dAvailbaleQty OUTPUT, @dAvailbalePledgeQty OUTPUT,@dAvailbaleESOPQty OUTPUT, @dAvailableOtherQty OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, 
																			  @out_sSQLErrMessage OUTPUT
			END
		--select @inp_iUserInfoId,@inp_iUserInfoId,@inp_iSecurityTypeCodeID,@inp_iFromDEMATAcountID,@inp_iSecurityTransferOption
		END
		ELSE IF @inp_iTransferFor = @nTransferForRelative
		BEGIN
		IF @inp_iSecurityTransferOption = @nSecurityTransferfromAllDemataccount
			BEGIn
			EXECUTE @RC = st_usr_GetAvailableQuantityForIndividualDematOrAllDemat @inp_iUserInfoId,@inp_iForUserInfoId,@inp_iSecurityTypeCodeID,
																			  @inp_iToDEMATAcountID,@inp_iSecurityTransferOption,
																			  @dAvailbaleQty OUTPUT, @dAvailbalePledgeQty OUTPUT,@dAvailbaleESOPQty OUTPUT,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, 
																			  @out_sSQLErrMessage OUTPUT
			
			END
			ELSE
			BEGIN
			
			EXECUTE @RC = st_usr_GetAvailableQuantityForIndividualDematOrAllDemat @inp_iUserInfoId,@inp_iForUserInfoId,@inp_iSecurityTypeCodeID,
																			  @inp_iFromDEMATAcountID,@inp_iSecurityTransferOption,
																			  @dAvailbaleQty OUTPUT, @dAvailbalePledgeQty OUTPUT,@dAvailbaleESOPQty OUTPUT, @dAvailableOtherQty OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, 
																			  @out_sSQLErrMessage OUTPUT
			END
		END	
		
		
			
		IF EXISTS(SELECT TransactionMasterId 
		FROM tra_TransactionMaster
		WHERE UserInfoId = @inp_iUserInfoID AND DisclosureTypeCodeId = 147003 AND TransactionStatusCodeId <= 148002 )
		BEGIN
			SET @out_nReturnValue = @ERR_LASTPERIODENDNOTSUBMITTED
			RETURN @out_nReturnValue
		END 
		
		-- Validation for Individual demat type
		IF @inp_iSecurityTransferOption = @nSecurityTransferfromselectedDemataccount
		BEGIN
			-- From demat id mandatory
			IF @inp_iFromDEMATAcountID IS NULL OR @inp_iFromDEMATAcountID = 0 
			BEGIN
				SET @out_nReturnValue = @ERR_FROMDMATIDMANDAOTRY
				RETURN @out_nReturnValue
			END
		
			--Check transfer qty greater than zero
			IF ((@inp_dTransferQuantity IS NULL OR @inp_dTransferQuantity = 0 )AND (@inp_dTransferESOPQuantity IS NULL OR @inp_dTransferESOPQuantity = 0))
			BEGIN
				SET @out_nReturnValue = @ERR_TRANSFERQTYGREATERTHANZERO
				RETURN @out_nReturnValue
			END
			
			IF @inp_iFromDEMATAcountID = @inp_iToDEMATAcountID
			BEGIN
				SET @out_nReturnValue = @ERR_FROMANDTODEMATSAME
				RETURN @out_nReturnValue
			END
			
			IF ((@inp_dTransferQuantity < 0 AND @dAvailableOtherQty > 0) OR (@inp_dTransferESOPQuantity < 0 AND @dAvailbaleESOPQty > 0))
			BEGIN
				SET @out_nReturnValue = @ERR_TRANSFERQTYGREATERTHANZERO
				RETURN @out_nReturnValue
			END
																	
			--select @dAvailbaleQty,@inp_dTransferQuantity
			
			IF ((@dAvailableOtherQty > 0 AND @dAvailableOtherQty < @inp_dTransferQuantity) OR (@dAvailbaleESOPQty > 0 AND @dAvailbaleESOPQty < @inp_dTransferESOPQuantity))
			BEGIN
				SET @out_nReturnValue = @ERR_QTYNOTAVAILABLE
				RETURN @out_nReturnValue
			END
			ELSE IF (((@dAvailableOtherQty < 0 AND @dAvailableOtherQty > @inp_dTransferQuantity) 
					OR (@dAvailableOtherQty < 0 AND @inp_dTransferQuantity >= 0))
					
					OR ((@dAvailbaleESOPQty < 0 AND @dAvailbaleESOPQty > @inp_dTransferESOPQuantity) 
					OR (@dAvailbaleESOPQty < 0 AND @inp_dTransferESOPQuantity >= 0)))
			BEGIN
				SET @out_nReturnValue = @ERR_QTYNOTAVAILABLE
				RETURN @out_nReturnValue
			END
			
			
			-- Check PNT is Pending transaction
			IF EXISTS(SELECT TM.TransactionMasterId 
						FROM tra_TransactionDetails TD
						JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
						WHERE ((@inp_iTransferFor = @nTransferForSelf AND ForUserInfoId = @inp_iUserInfoId)
								OR (@inp_iTransferFor = @nTransferForRelative AND ForUserInfoId =  @inp_iForUserInfoId)) 
						AND DMATDetailsID = @inp_iToDEMATAcountID 
						AND TM.TransactionStatusCodeId = @nTransactionStatusNoSubmitted 
						AND TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeID AND TM.PreclearanceRequestId IS NULL)
						
			BEGIN
				SET @out_nReturnValue = @ERR_TODMATPENDINGTRANSACTIONEXISTS
				RETURN @out_nReturnValue
			END
			
			
			IF EXISTS(SELECT PreclearanceRequestId 
					FROM tra_PreclearanceRequest
					WHERE IsPartiallyTraded = 1 AND ((@inp_iTransferFor = @nTransferForSelf AND UserInfoId = @inp_iUserInfoId)
								OR (@inp_iTransferFor = @nTransferForRelative AND UserInfoIdRelative =  @inp_iForUserInfoId)) 
								AND DMATDetailsID = @inp_iToDEMATAcountID AND SecurityTypeCodeId = @inp_iSecurityTypeCodeID
								AND PreclearanceStatusCodeId <> 144003 AND ReasonForNotTradingCodeId IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_TODMATPENDINGTRANSACTIONEXISTS
				RETURN @out_nReturnValue
			END
			
			IF EXISTS(SELECT TM.TransactionMasterId 
						FROM tra_TransactionDetails TD
						JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
						WHERE ((@inp_iTransferFor = @nTransferForSelf AND ForUserInfoId = @inp_iUserInfoId)
								OR (@inp_iTransferFor = @nTransferForRelative AND ForUserInfoId =  @inp_iForUserInfoId)) 
						AND DMATDetailsID = @inp_iFromDEMATAcountID 
						AND TM.TransactionStatusCodeId = @nTransactionStatusNoSubmitted 
						AND TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeID AND TM.PreclearanceRequestId IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_FROMDMATPENDINGTRANSACTIONEXISTS
				RETURN @out_nReturnValue
			END
			
			IF EXISTS(SELECT PreclearanceRequestId 
					FROM tra_PreclearanceRequest
					WHERE IsPartiallyTraded = 1 AND ((@inp_iTransferFor = @nTransferForSelf AND UserInfoId = @inp_iUserInfoId)
								OR (@inp_iTransferFor = @nTransferForRelative AND UserInfoIdRelative =  @inp_iForUserInfoId)) 
								AND DMATDetailsID = @inp_iFromDEMATAcountID AND SecurityTypeCodeId = @inp_iSecurityTypeCodeID
								AND PreclearanceStatusCodeId <> 144003 AND ReasonForNotTradingCodeId IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_FROMDMATPENDINGTRANSACTIONEXISTS
				RETURN @out_nReturnValue
			END
			
		END
		ELSE IF @inp_iSecurityTransferOption = @nSecurityTransferfromAllDemataccount
		BEGIN
			--select @dAvailbaleQty
			IF @dAvailbaleQty = 0
			BEGIN
				SET @out_nReturnValue = @ERR_QTYNOTAVAILABLE
				RETURN @out_nReturnValue
			END
			
			IF EXISTS(SELECT TM.TransactionMasterId 
						FROM tra_TransactionDetails TD
						JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
						WHERE ((@inp_iTransferFor = @nTransferForSelf AND ForUserInfoId = @inp_iUserInfoId)
								OR (@inp_iTransferFor = @nTransferForRelative AND ForUserInfoId =  @inp_iForUserInfoId)) 
						AND TM.TransactionStatusCodeId = @nTransactionStatusNoSubmitted 
						AND TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeID AND TM.PreclearanceRequestId IS NULL)
			BEGIN
				SET @out_nReturnValue = @ERR_PENDINGTRANSACTIONEXISTS
				RETURN @out_nReturnValue
			END
			
			IF EXISTS(SELECT PreclearanceRequestId 
					FROM tra_PreclearanceRequest
					WHERE IsPartiallyTraded = 1 AND ((@inp_iTransferFor = @nTransferForSelf AND UserInfoId = @inp_iUserInfoId)
								OR (@inp_iTransferFor = @nTransferForRelative AND UserInfoIdRelative =  @inp_iForUserInfoId)) 
								AND SecurityTypeCodeId = @inp_iSecurityTypeCodeID
								AND PreclearanceStatusCodeId <> 144003
								AND ReasonForNotTradingCodeId IS NULL)
								
			BEGIN
				SET @out_nReturnValue = @ERR_PENDINGTRANSACTIONEXISTS
				RETURN @out_nReturnValue
			END
			
		END
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_TransferBalanceLogValidation, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END