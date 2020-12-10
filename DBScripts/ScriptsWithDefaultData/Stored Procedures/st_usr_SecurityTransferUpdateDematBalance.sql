IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_SecurityTransferUpdateDematBalance')
DROP PROCEDURE [dbo].[st_usr_SecurityTransferUpdateDematBalance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	transfer security balance between demat accounts in demat wise summay table

Returns:		0, if Success.
				
Created by:		Parag
Created on:		20-Oct-2016

Modification History:
Modified By		Modified On		Description


-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_SecurityTransferUpdateDematBalance]
	@inp_nSecurityTransferOption 			INT,
	@inp_nUserInfoId						INT,
	@inp_nRelativeUserInfoId				INT,
	@inp_nSecurityType						INT,
	@inp_nFromDematAccountId				INT,
	@inp_nToDematAccountId					INT,
	@inp_nQuantity							DECIMAL(10) = NULL,
	@inp_dtCurrent_Date						DATETIME,
	@inp_nESOPQuantity						DECIMAL(10) = NULL,
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT
	
AS
BEGIN
	DECLARE @ERR_SECURITY_TRANSFER_UPDATE_DEMAT_BALANCE INT = 11484 -- Error occured while updating demat quantity

	DECLARE @TransferOption_Selected_Demat INT = 191001
	DECLARE @TransferOption_All_Demat INT = 191002

	DECLARE @YearCodeId INT = NULL
	DECLARE @PeriodCodeId INT = NULL

	DECLARE @nPeriodType INT

	DECLARE @out_dtStartDate DATETIME, @out_dtEndDate DATETIME

	DECLARE @OpeningBalance DECIMAL(10) = 0
	DECLARE @ClosingBalance DECIMAL(10) = 0
	DECLARE @Value DECIMAL(25,4) = 0

	DECLARE @Transfer_Quantity DECIMAL(10)
	DECLARE @Total_Quantity DECIMAL(10)
	DECLARE @Total_Value DECIMAL(25,4) = 0
	DECLARE @Transfer_Value DECIMAL(25,4) = 0
	
	DECLARE @ESOPandOtherTransferQty DECIMAL(20)
	SET @ESOPandOtherTransferQty = @inp_nQuantity + @inp_nESOPQuantity

	
	
	
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
		
		
		-- Demat Quantity Transfer Logic
		/*
			For each period type
				create new record in demat wise summary table if not exists for that period
				take closing balance - this is quantity to be transfer 
				if positive quantity then substract from buy to make closing balance zero and add into buy for to demat account
				if negative quantity then substract from sell to make closing balance zero and add into sell (as negative quantity) for to demat account
					
		*/

		DECLARE PeriodType_Cursor CURSOR FOR SELECT CodeId FROM com_Code WHERE CodeGroupId = 123
				
		OPEN PeriodType_Cursor
				
		FETCH NEXT FROM PeriodType_Cursor INTO @nPeriodType
				
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @YearCodeId = NULL
			SET @PeriodCodeId = NULL
			SET @out_dtStartDate = NULL
			SET @out_dtEndDate = NULL

			EXEC st_tra_PeriodEndDisclosureStartEndDate2 @YearCodeId output, @PeriodCodeId output, @inp_dtCurrent_Date, @nPeriodType, 0, @out_dtStartDate, @out_dtEndDate

			-- check if period record exists for "From Demat Account"
			IF NOT EXISTS(SELECT TransactionSummaryDMATWiseId FROM tra_TransactionSummaryDMATWise 
							WHERE YearCodeId = @YearCodeId AND PeriodCodeId = @PeriodCodeId AND UserInfoId = @inp_nUserInfoId
							AND UserInfoIdRelative = @inp_nRelativeUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType and DMATDetailsID = @inp_nFromDematAccountId)
			BEGIN
				-- check if previous period record exists to add as opening balance
				SELECT TOP 1 @OpeningBalance = ts.ClosingBalance, @ClosingBalance = ts.ClosingBalance, @Value = ts.Value
				FROM tra_TransactionSummaryDMATWise ts
				WHERE PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType)
				AND UserInfoId = @inp_nUserInfoId
				AND UserInfoIdRelative = @inp_nRelativeUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType and DMATDetailsID = @inp_nFromDematAccountId
				ORDER BY TransactionSummaryDMATWiseId DESC

				-- previous period record not exists so add new record with zero opening balance
				IF (@OpeningBalance IS NULL AND @ClosingBalance IS NULL AND @Value IS NULL) 
				BEGIN
					SET @OpeningBalance = 0
					SET @ClosingBalance = 0
					SET @Value = 0
				END

				-- add new record int dmat wise transaction summary table
				INSERT INTO tra_TransactionSummaryDMATWise(
						YearCodeId, PeriodCodeId, UserInfoId, UserInfoIdRelative, SecurityTypeCodeId, DMATDetailsID, 
						OpeningBalance, SellQuantity, BuyQuantity, ClosingBalance, Value)
					VALUES
						(@YearCodeId, @PeriodCodeId, @inp_nUserInfoId, @inp_nRelativeUserInfoId, @inp_nSecurityType, @inp_nFromDematAccountId,
						@OpeningBalance, 0, 0, @ClosingBalance, @Value)
			END

			SET @OpeningBalance = 0
			SET @ClosingBalance = 0
			SET @Value = 0

			-- check if period record exists for "To Demat Account"
			IF NOT EXISTS(SELECT TransactionSummaryDMATWiseId FROM tra_TransactionSummaryDMATWise 
							WHERE YearCodeId = @YearCodeId AND PeriodCodeId = @PeriodCodeId AND UserInfoId = @inp_nUserInfoId
							AND UserInfoIdRelative = @inp_nRelativeUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType and DMATDetailsID = @inp_nToDematAccountId)
			BEGIN
				-- check if previous period record exists to add as opening balance
				SELECT TOP 1 @OpeningBalance = ts.ClosingBalance, @ClosingBalance = ts.ClosingBalance, @Value = ts.Value
				FROM tra_TransactionSummaryDMATWise ts
				WHERE PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType)
				AND UserInfoId = @inp_nUserInfoId
				AND UserInfoIdRelative = @inp_nRelativeUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType and DMATDetailsID = @inp_nToDematAccountId
				ORDER BY TransactionSummaryDMATWiseId DESC
						
				-- previous period record not exists so add new record with zero opening balance
				IF (@OpeningBalance IS NULL AND @ClosingBalance IS NULL AND @Value IS NULL) 
				BEGIN
					SET @OpeningBalance = 0
					SET @ClosingBalance = 0
					SET @Value = 0
				END

				-- add new record int dmat wise transaction summary table
				INSERT INTO tra_TransactionSummaryDMATWise(
						YearCodeId, PeriodCodeId, UserInfoId, UserInfoIdRelative, SecurityTypeCodeId, DMATDetailsID, 
						OpeningBalance, SellQuantity, BuyQuantity, ClosingBalance, Value)
					VALUES
						(@YearCodeId, @PeriodCodeId, @inp_nUserInfoId, @inp_nRelativeUserInfoId, @inp_nSecurityType, @inp_nToDematAccountId,
						@OpeningBalance, 0, 0, @ClosingBalance, @Value)
			END

			-- get quantity and value to be transfer
			SELECT @Total_Quantity = ts.ClosingBalance, @Total_Value = ts.Value FROM tra_TransactionSummaryDMATWise ts
			WHERE YearCodeId = @YearCodeId AND PeriodCodeId = @PeriodCodeId AND UserInfoId = @inp_nUserInfoId
			AND UserInfoIdRelative = @inp_nRelativeUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType and DMATDetailsID = @inp_nFromDematAccountId

			SET @Transfer_Quantity = CASE 
										WHEN @inp_nSecurityTransferOption = @TransferOption_All_Demat THEN @Total_Quantity 
										ELSE @ESOPandOtherTransferQty
									 END

			--select @inp_nSecurityType 'Security', @inp_nFromDematAccountId 'From Demat Account', @nPeriodType 'Period Type', @YearCodeId 'Year', @PeriodCodeId 'Period',
			--		@Transfer_Quantity 'Transfer Quantity', @Transfer_Value  'Transfer Value', @inp_nToDematAccountId 'To Demat Account'

			-- update demat wise summay table 
			IF (@Transfer_Quantity > 0)
			BEGIN
				SELECT @Transfer_Value = CASE 
											WHEN @Total_Quantity = @ESOPandOtherTransferQty THEN @Total_Value 
											ELSE 
												CASE WHEN @Total_Value = 0 THEN 0 ELSE (@Total_Value / @Total_Quantity) * @Transfer_Quantity END
											END

				-- update "To Demat Account"
				UPDATE tra_TransactionSummaryDMATWise 
				SET 
					BuyQuantity = BuyQuantity + @Transfer_Quantity,
					ClosingBalance = ClosingBalance + @Transfer_Quantity,
					Value = Value + @Transfer_Value
				WHERE YearCodeId = @YearCodeId AND PeriodCodeId = @PeriodCodeId AND UserInfoId = @inp_nUserInfoId
				AND UserInfoIdRelative = @inp_nRelativeUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType and DMATDetailsID = @inp_nToDematAccountId

				-- update "From Demat Account"
				UPDATE tra_TransactionSummaryDMATWise 
				SET 
					SellQuantity = SellQuantity + @Transfer_Quantity,
					ClosingBalance = ClosingBalance - @Transfer_Quantity,
					Value = Value - @Transfer_Value
				WHERE YearCodeId = @YearCodeId AND PeriodCodeId = @PeriodCodeId AND UserInfoId = @inp_nUserInfoId
				AND UserInfoIdRelative = @inp_nRelativeUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType and DMATDetailsID = @inp_nFromDematAccountId
			END
			ELSE IF(@Transfer_Quantity < 0)
			BEGIN
				SELECT @Transfer_Value = CASE 
											WHEN @Total_Quantity = @ESOPandOtherTransferQty THEN @Total_Value 
											ELSE 
												CASE WHEN @Total_Value = 0 THEN 0 ELSE (@Total_Value / (@Total_Quantity * -1)) * (@Transfer_Quantity * -1) END
											END

				-- update "To Demat Account"
				UPDATE tra_TransactionSummaryDMATWise 
				SET 
					SellQuantity = SellQuantity - @Transfer_Quantity,
					ClosingBalance = ClosingBalance + @Transfer_Quantity,
					Value = Value + @Transfer_Value
				WHERE YearCodeId = @YearCodeId AND PeriodCodeId = @PeriodCodeId AND UserInfoId = @inp_nUserInfoId
				AND UserInfoIdRelative = @inp_nRelativeUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType and DMATDetailsID = @inp_nToDematAccountId

				-- update "From Demat Account"
				UPDATE tra_TransactionSummaryDMATWise 
				SET 
					BuyQuantity = BuyQuantity - @Transfer_Quantity,
					ClosingBalance = ClosingBalance - @Transfer_Quantity,
					Value = Value - @Transfer_Value
				WHERE YearCodeId = @YearCodeId AND PeriodCodeId = @PeriodCodeId AND UserInfoId = @inp_nUserInfoId
				AND UserInfoIdRelative = @inp_nRelativeUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType and DMATDetailsID = @inp_nFromDematAccountId
			END

					
			FETCH NEXT FROM PeriodType_Cursor INTO @nPeriodType
		END
				
		CLOSE PeriodType_Cursor
		DEALLOCATE PeriodType_Cursor;

		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_SECURITY_TRANSFER_UPDATE_DEMAT_BALANCE, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

