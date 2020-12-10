IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_tra_TransactionMaster_OS_DisclosureStatus]'))
DROP TRIGGER [dbo].[tr_tra_TransactionMaster_OS_DisclosureStatus]
GO

-- =============================================
-- =============================================

CREATE TRIGGER [dbo].[tr_tra_TransactionMaster_OS_DisclosureStatus] ON [dbo].[tra_TransactionMaster_OS]
FOR UPDATE
AS
BEGIN
	DECLARE @nEventCodeID INT
	DECLARE @nMapToTypeCodeId INT = 132005 -- Disclosure Transaction
	DECLARE @nMapToId INT
	DECLARE @nUserInfoId INT
	DECLARE @dtEventDate DATETIME = dbo.uf_com_GetServerDate()
	DECLARE @dtPeriodEndDate DATETIME
	DECLARE @nModifiedBy INT
	
	DECLARE @nMapToTypeCodeIdPreClearance INT = 132004 -- Preclearance
	DECLARE @nMapToIdPreClearance INT	-- MapToId of Pre-Clearance corresponding to the transaction

	DECLARE @nTransactionMasterId INT
	DECLARE @dtDateOfAcq DATETIME
	DECLARE @nPeriodType INT
	DECLARE @nYear INT
	DECLARE @nYearCodeId INT
	DECLARE @nPeriodCodeId INT
	DECLARE @tmpTransactionSummary TABLE(
		UserInfoId INT, UserInfoIdRelative INT, SecurityTypeCodeId INT, ClosingBalance DECIMAL(10), DMATDetailsId INT, Value DECIMAL(25,4),CompanyId INT)
	
	DECLARE @nDisclosureTypeCodeId_Initial INT = 147001
	DECLARE @nDisclosureTypeCodeId_Continuous INT = 147002
	DECLARE @nDisclosureTypeCodeId_PeriodEnd INT = 147003

	DECLARE @nTransactionStatus_DocumentUploaded INT = 148001
	DECLARE @nTransactionStatus_Confirmed INT = 148003
	DECLARE @nTransactionStatus_SoftCopySubmitted INT = 148004
	DECLARE @nTransactionStatus_HardCopySubmitted INT = 148005
	DECLARE @nTransactionStatus_HardCopySubmittedByCO INT = 148006
	DECLARE @nTransactionStatus_Submitted INT = 148007

	DECLARE @nTransactionStatusOld INT, @nTransactionStatusNew INT
	DECLARE @nDisclosureTypeCodeIdOld INT, @nDisclosureTypeCodeIdNew INT,@nInsiderIDFlag INT

	DECLARE @nEventCodeID_InitialDisclosureDetailsEntered INT = 153052
	DECLARE @nEventCodeID_InitialDisclosureUploaded INT = 153053
	DECLARE @nEventCodeID_InitialDisclosureSubmittedSoftcopy INT = 153054
	DECLARE @nEventCodeID_InitialDisclosureSubmittedHardcopy INT = 153055
	--DECLARE @nEventCodeID_InitialDisclosureCOSubmittedHardcopyToStockExchange INT = 153012
	DECLARE @nEventCodeID_InitialDisclosureConfirmed INT = 153056

	DECLARE @nEventCodeID_ContinuousDisclosureDetailsEntered INT = 153057
	DECLARE @nEventCodeID_ContinuousDisclosureUploaded INT = 153058
	DECLARE @nEventCodeID_ContinuousDisclosureSubmittedSoftcopy INT = 153059
	DECLARE @nEventCodeID_ContinuousDisclosureSubmittedHardcopy INT = 153060
	--DECLARE @nEventCodeID_ContinuousDisclosureCOSubmittedHardcopyToStockExchange INT = 153024
	DECLARE @nEventCodeID_ContinuousDisclosureConfirmed INT = 153061

	DECLARE @nEventCodeID_PEDisclosureDetailsEntered INT = 153062
	DECLARE @nEventCodeID_PEDisclosureUploaded INT = 153063
	DECLARE @nEventCodeID_PEDisclosureSubmittedSoftcopy INT = 153064
	DECLARE @nEventCodeID_PEDisclosureSubmittedHardcopy INT = 153065
	--DECLARE @nEventCodeID_PEDisclosureCOSubmittedHardcopyToStockExchange INT = 153034
	DECLARE @nEventCodeID_PEDisclosureConfirmed INT = 153066
	
	DECLARE @nEventCodeIDPreClearanceTradeDetailsSubmit INT 
	DECLARE @nEventCodeID_PreClearanceTradeDetailsSubmitted INT = 153038 --Event to indicate trade details submitted against a pre-clearance request

	DECLARE @nTransactionType_Buy INT = 143001
	DECLARE @nTransactionType_Sell INT = 143002
	DECLARE @nTransactionType_CashExercise INT = 143003
	DECLARE @nTransactionType_CashlessAll INT = 143004
	DECLARE @nTransactionType_CashlessPartial INT = 143005

	DECLARE @tmpTransDetails TABLE(
		ForUserInfoId INT, SecurityTypeCodeId INT, DMATDetailsId INT,CompanyId INT, BuyQuantity INT, SellQuantity2 INT, Value DECIMAL(25,4), PledgeBuyQuantity INT, PledgeSellQuantity INT)

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * INTO #tmpValues_New FROM inserted
	SELECT * INTO #tmpValues_Old FROM deleted

	SELECT	@nTransactionStatusNew = TransactionStatusCodeId, 
			@nDisclosureTypeCodeIdNew = DisclosureTypeCodeId,
			@nMapToId = TransactionMasterId,
			@nUserInfoId = UserInfoId,
			@dtPeriodEndDate = PeriodEndDate,
			@nTransactionMasterId = TransactionMasterId,
			@nModifiedBy = ModifiedBy,
			@nInsiderIDFlag=InsiderIDFlag
	FROM #tmpValues_New
	
	--Get the PreclearanceRequestId corresponding to the Transaction
	SELECT @nMapToIdPreClearance = PreclearanceRequestId
	FROM #tmpValues_New
	
	SELECT	@nTransactionStatusOld = TransactionStatusCodeId,
			@nDisclosureTypeCodeIdOld = DisclosureTypeCodeId
	FROM #tmpValues_Old
	
	-- Initial disclosures
	IF ISNULL(@nTransactionStatusNew, 0) <> ISNULL(@nTransactionStatusOld, 0)
	BEGIN
		If @nDisclosureTypeCodeIdNew = @nDisclosureTypeCodeId_Initial
		BEGIN
			IF @nTransactionStatusNew = @nTransactionStatus_Submitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureDetailsEntered
			END 
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_DocumentUploaded
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureUploaded
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_SoftCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureSubmittedSoftcopy
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureSubmittedHardcopy
			END
			--ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmittedByCO
			--BEGIN
			--	SET @nEventCodeID = @nEventCodeID_InitialDisclosureCOSubmittedHardcopyToStockExchange
			--END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_Confirmed
			BEGIN
				SET @nEventCodeID = @nEventCodeID_InitialDisclosureConfirmed
			END
		END
		
		-- Continuous disclosures
		ELSE IF @nDisclosureTypeCodeIdNew = @nDisclosureTypeCodeId_Continuous
		BEGIN
			IF @nTransactionStatusNew = @nTransactionStatus_Submitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureDetailsEntered
				SET @nEventCodeIDPreClearanceTradeDetailsSubmit = @nEventCodeID_PreClearanceTradeDetailsSubmitted --Also add event to eventlog for Pre-Clearance Trade Details Submitted
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_DocumentUploaded
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureUploaded
				SET @nEventCodeIDPreClearanceTradeDetailsSubmit = @nEventCodeID_PreClearanceTradeDetailsSubmitted --Also add event to eventlog for Pre-Clearance Trade Details Submitted
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_SoftCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureSubmittedSoftcopy
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureSubmittedHardcopy
			END
			--ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmittedByCO
			--BEGIN
			--	SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureCOSubmittedHardcopyToStockExchange
			--END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_Confirmed
			BEGIN
				SET @nEventCodeID = @nEventCodeID_ContinuousDisclosureConfirmed
			END
		END
		-- Period End disclosures
		ELSE IF @nDisclosureTypeCodeIdNew = @nDisclosureTypeCodeId_PeriodEnd
		BEGIN
			--SET @dtEventDate = @dtPeriodEndDate
			IF @nTransactionStatusNew = @nTransactionStatus_Submitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureDetailsEntered
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_DocumentUploaded
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureUploaded
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_SoftCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureSubmittedSoftcopy
			END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmitted
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureSubmittedHardcopy
			END
			--ELSE IF @nTransactionStatusNew = @nTransactionStatus_HardCopySubmittedByCO
			--BEGIN
			--	SET @nEventCodeID = @nEventCodeID_PEDisclosureCOSubmittedHardcopyToStockExchange
			--END
			ELSE IF @nTransactionStatusNew = @nTransactionStatus_Confirmed
			BEGIN
				SET @nEventCodeID = @nEventCodeID_PEDisclosureConfirmed
			END
		END

		-- 
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
		VALUES(@nEventCodeID, @dtEventDate, @nUserInfoId, @nMapToTypeCodeId, @nMapToId, @nModifiedBy)
		
		/*Add "Pre-Clearance Trade Details Submitted" event to event log, if current TransactionMaster record has pre-clearanceId associated with it and eventlog entry for "Pre-Clearance Trade Details Submitted" is not already added for Pre-ClearanceId*/
		IF(@nMapToIdPreClearance IS NOT NULL AND @nEventCodeIDPreClearanceTradeDetailsSubmit IS NOT NULL) --current TransactionMaster record has pre-clearanceId associated with it
		BEGIN 
			--eventlog entry for "Pre-Clearance Trade Details Submitted" is not already added for Pre-ClearanceId
			IF(NOT EXISTS(SELECT EventLogId FROM eve_EventLog WHERE EventCodeId = @nEventCodeID_PreClearanceTradeDetailsSubmitted AND UserInfoId = @nUserInfoId AND MapToTypeCodeId = @nMapToTypeCodeIdPreClearance AND MapToId = @nMapToIdPreClearance))
			BEGIN
				INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
				VALUES(@nEventCodeIDPreClearanceTradeDetailsSubmit, dbo.uf_com_GetServerDate(), @nUserInfoId, @nMapToTypeCodeIdPreClearance, @nMapToIdPreClearance, @nModifiedBy)
			END
		END
		
		
		
		/************************* If TransactionStatus is Confirmed, update Summary table ********************************/
		IF(@nDisclosureTypeCodeIdNew = @nDisclosureTypeCodeId_Initial AND @nInsiderIDFlag=1)
		BEGIN
		PRINT('RECORD IS UPDATED FOR INSIDER')
		END
		ELSE
		BEGIN		
			IF @nTransactionStatusNew = @nTransactionStatus_Submitted
			BEGIN
				
				DECLARE @nUserTypeCodeID INT				
				SELECT @nUserTypeCodeID=UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId=@nUserInfoId
				IF(@nUserTypeCodeID=101007)
				BEGIN
					SELECT @nUserInfoId=UserInfoId FROM usr_UserRelation WHERE UserInfoIdRelative=@nUserInfoId				
				END
				ELSE
				BEGIN
					SET @nUserInfoId=@nUserInfoId
				END				
				
				--print 'Update Summary for each period type'
				
				DECLARE @nTransactionDetailsId INT
				
				-- update summary for each transaction details enter 
				DECLARE TraDetail_Cursor CURSOR FOR 
					SELECT TD.TransactionDetailsId, TD.DateOfAcquisition FROM tra_TransactionDetails_OS TD WHERE TD.TransactionMasterId = @nTransactionMasterId AND TD.SecurityTypeCodeId IS NOT NULL AND TD.DMATDetailsID IS NOT NULL
				
				OPEN TraDetail_Cursor
				
				FETCH NEXT FROM TraDetail_Cursor INTO @nTransactionDetailsId, @dtDateOfAcq
				
				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- get period code for each period type to update summary 
					SELECT @nYear = YEAR(@dtDateOfAcq)
				
					IF MONTH(@dtDateOfAcq) < 4
					BEGIN
						SET @nYear = @nYear - 1
					END
					
					-- find year code to add into summary table
					SELECT @nYearCodeId = CodeID FROM com_Code WHERE CodeGroupId = 125 AND CodeName LIKE CONVERT(VARCHAR(4), @nYear) + '%'
					
					DECLARE PeriodType_Cursor CURSOR FOR SELECT CodeId FROM com_Code WHERE CodeGroupId = 123
					
					OPEN PeriodType_Cursor
					
					FETCH NEXT FROM PeriodType_Cursor INTO @nPeriodType
					
					WHILE @@FETCH_STATUS = 0
					BEGIN
						-- Find PeriodCodeId
						SELECT TOP(1) @nPeriodCodeId = CodeID FROM com_Code 
						WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType AND @dtDateOfAcq <= DATEADD(YEAR, @nYear - 1970, DATEADD(DAY, -1, CONVERT(DATETIME, Description)))
						ORDER BY CONVERT(DATETIME, Description) ASC
						
						-- update temp table for summary 
						--INSERT INTO @tmpTransactionSummary(SecurityTypeCodeId, UserInfoId, UserInfoIdRelative, ClosingBalance, Value)
						--SELECT TS.SecurityTypeCodeId, TS.UserInfoId, TS.UserInfoIdRelative, ClosingBalance, TS.Value
						--FROM tra_TransactionSummary TS JOIN
						--		(SELECT SecurityTypeCodeId, UserInfoId, UserInfoIdRelative, MAX(TransactionSummaryId) TransactionSummaryId
						--			FROM tra_TransactionSummary 
						--			WHERE UserInfoId = @nUserInfoId 
						--			AND PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType)
						--			GROUP BY SecurityTypeCodeId, UserInfoId, UserInfoIdRelative
						--		) TS1 ON TS.TransactionSummaryId = TS1.TransactionSummaryId
						
						-- add new summary for period if not found in summary table
						--INSERT INTO tra_TransactionSummary(
						--	YearCodeId, PeriodCodeId, UserInfoId, UserInfoIdRelative, SecurityTypeCodeId, 
						--	OpeningBalance, SellQuantity, BuyQuantity, ClosingBalance, Value)
						--SELECT 
						--	@nYearCodeId, @nPeriodCodeId, @nUserInfoId, TD.ForUserInfoId, TD.SecurityTypeCodeId, 
						--	ISNULL(TSOld.ClosingBalance, 0), 0, 0, ISNULL(TSOld.ClosingBalance, 0), ISNULL(TSOld.Value, 0)
						--FROM 
						--	tra_TransactionDetails TD 
						--LEFT JOIN tra_TransactionSummary TS ON TS.YearCodeId = @nYearCodeId AND TS.PeriodCodeId = @nPeriodCodeId 
						--				AND TS.UserInfoId = @nUserInfoId AND TD.ForUserInfoId = TS.UserInfoIdRelative	
						--				AND TS.SecurityTypeCodeId = TD.SecurityTypeCodeId
						--LEFT JOIN @tmpTransactionSummary TSOld ON TSOld.SecurityTypeCodeId = TD.SecurityTypeCodeId 
						--				AND TSOld.UserInfoId = @nUserInfoId AND ISNULL(TSOld.UserInfoIdRelative, 0) = ISNULL(TD.ForUserInfoId, 0)
						--WHERE TD.TransactionDetailsId = @nTransactionDetailsId
						--	AND TS.TransactionSummaryId IS NULL

						-- Populate tmp table for buyquantity, sell quantity per user, security combination
						--INSERT INTO @tmpTransDetails(ForUserInfoId, SecurityTypeCodeId, BuyQuantity, SellQuantity2, Value, PledgeBuyQuantity, PledgeSellQuantity)
						--SELECT ForUserInfoId,
						--	TD.SecurityTypeCodeId, 
						--	(select top 1 OtherBuyQuantity from [dbo].[uf_tra_GetBuyORSellQuantity_OS]('OtherBuy',TD.Quantity,TD.Quantity2,TD.ModeOfAcquisitionCodeId,TD.TransactionTypeCodeId,TD.SecurityTypeCodeId,TD.LotSize)) as OtherBuyQuantity,
						--	(select top 1 OtherSellQuantity from [dbo].[uf_tra_GetBuyORSellQuantity_OS]('OtherSell',TD.Quantity,TD.Quantity2,TD.ModeOfAcquisitionCodeId,TD.TransactionTypeCodeId,TD.SecurityTypeCodeId,TD.LotSize)) as OtherSellQuantity,						
						--	Value + Value2,
						--	(select top 1 PledgeBuyQuantity from [dbo].[uf_tra_GetBuyORSellQuantity_OS]('PledgeBuy',TD.Quantity,TD.Quantity2,TD.ModeOfAcquisitionCodeId,TD.TransactionTypeCodeId,TD.SecurityTypeCodeId,TD.LotSize)) as PledgeBuyQuantity,
						--	(select top 1 PledgeSellQuantity from [dbo].[uf_tra_GetBuyORSellQuantity_OS]('PledgeSell',TD.Quantity,TD.Quantity2,TD.ModeOfAcquisitionCodeId,TD.TransactionTypeCodeId,TD.SecurityTypeCodeId,TD.LotSize)) as PledgeSellQuantity
						--FROM tra_TransactionDetails TD WHERE TD.TransactionDetailsId = @nTransactionDetailsId
						
						---- update summary for each period type 
						--UPDATE TS
						--SET BuyQuantity = TS.BuyQuantity + TD.BuyQuantity,
						--	SellQuantity = TS.SellQuantity + TD.SellQuantity2,
						--	ClosingBalance = ClosingBalance + TD.BuyQuantity - TD.SellQuantity2,
						--	Value = TS.Value + TD.Value,						
						--	PledgeBuyQuantity = TS.PledgeBuyQuantity + TD.PledgeBuyQuantity,
						--	PledgeSellQuantity = TS.PledgeSellQuantity + TD.PledgeSellQuantity,
						--	PledgeClosingBalance = PledgeClosingBalance + TD.PledgeBuyQuantity - TD.PledgeSellQuantity
						--FROM tra_TransactionSummary TS 
						--JOIN @tmpTransDetails TD ON TD.ForUserInfoId = TS.UserInfoIdRelative 
						--	AND TD.SecurityTypeCodeId = TS.SecurityTypeCodeId
						--WHERE TS.YearCodeId = @nYearCodeId AND TS.PeriodCodeId = @nPeriodCodeId AND TS.UserInfoId = @nUserInfoId
						
						
						----------------------- Updte TransactionSummaryDMATWise -----------------------
						-- delete records from temp table
						DELETE FROM @tmpTransDetails
						DELETE FROM @tmpTransactionSummary
						
						INSERT INTO @tmpTransactionSummary(SecurityTypeCodeId, UserInfoId, UserInfoIdRelative, DMATDetailsId, ClosingBalance, Value,CompanyId)
						SELECT TS.SecurityTypeCodeId, TS.UserInfoId, TS.UserInfoIdRelative, TS.DMATDetailsID, ClosingBalance, TS.Value,TS.CompanyId
						FROM  tra_TransactionSummaryDMATWise_OS TS JOIN
								(SELECT SecurityTypeCodeId, UserInfoId, UserInfoIdRelative, MAX(TransactionSummaryDMATWiseId) TransactionSummaryDMATWiseId,CompanyId
									FROM tra_TransactionSummaryDMATWise_OS 
									WHERE UserInfoId = @nUserInfoId 
									AND PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType)
									GROUP BY SecurityTypeCodeId, UserInfoId, UserInfoIdRelative, DMATDetailsID,CompanyId
								) TS1 ON TS.TransactionSummaryDMATWiseId = TS1.TransactionSummaryDMATWiseId
						
						
						-- add new summary for period if not found in summary table
						INSERT INTO tra_TransactionSummaryDMATWise_OS(
							YearCodeId, PeriodCodeId, UserInfoId, UserInfoIdRelative, SecurityTypeCodeId, DMATDetailsID,CompanyId, 
							OpeningBalance, SellQuantity, BuyQuantity, ClosingBalance, Value)
						SELECT 
							@nYearCodeId, @nPeriodCodeId, @nUserInfoId, TD.ForUserInfoId, TD.SecurityTypeCodeId, TD.DMATDetailsID, TD.CompanyId,
							ISNULL(TSOld.ClosingBalance, 0), 0, 0, ISNULL(TSOld.ClosingBalance, 0), ISNULL(TSOld.Value, 0)
						FROM tra_TransactionDetails_OS TD 
						LEFT JOIN tra_TransactionSummaryDMATWise_OS TS ON TS.YearCodeId = @nYearCodeId AND TS.PeriodCodeId = @nPeriodCodeId 
									AND @nUserInfoId = TS.UserInfoId AND TD.ForUserInfoId = TS.UserInfoIdRelative 
									AND TS.SecurityTypeCodeId = TD.SecurityTypeCodeId AND TS.DMATDetailsID = TD.DMATDetailsID
									AND TS.CompanyId=TD.CompanyId
						LEFT JOIN @tmpTransactionSummary TSOld ON TSOld.SecurityTypeCodeId = TD.SecurityTypeCodeId 
									AND TSOld.UserInfoId = @nUserInfoId AND ISNULL(TSOld.UserInfoIdRelative, 0) = ISNULL(TD.ForUserInfoId, 0)
									AND ISNULL(TSOld.DMATDetailsId, 0) = ISNULL(TD.DMATDetailsID, 0)
									AND ISNULL(TSOld.CompanyId, 0) = ISNULL(TD.CompanyId, 0)
						WHERE TD.TransactionDetailsId = @nTransactionDetailsId
							AND TS.TransactionSummaryDMATWiseId IS NULL

						-- Populate tmp table for buyquantity, sell quantity per user, security combination
						INSERT INTO @tmpTransDetails(ForUserInfoId, SecurityTypeCodeId, DMATDetailsId,CompanyId, BuyQuantity, SellQuantity2, Value, PledgeBuyQuantity, PledgeSellQuantity)
						SELECT ForUserInfoId,
							TD.SecurityTypeCodeId,
							DMATDetailsID,
							CompanyId,
							(select top 1 OtherBuyQuantity from [dbo].[uf_tra_GetBuyORSellQuantity_OS]('OtherBuy',TD.Quantity,0,TD.ModeOfAcquisitionCodeId,TD.TransactionTypeCodeId,TD.SecurityTypeCodeId,TD.LotSize)) as OtherBuyQuantity,
							(select top 1 OtherSellQuantity from [dbo].[uf_tra_GetBuyORSellQuantity_OS]('OtherSell',TD.Quantity,0,TD.ModeOfAcquisitionCodeId,TD.TransactionTypeCodeId,TD.SecurityTypeCodeId,TD.LotSize)) as OtherSellQuantity,
							TD.Value,
							(select top 1 PledgeBuyQuantity from [dbo].[uf_tra_GetBuyORSellQuantity_OS]('PledgeBuy',TD.Quantity,0,TD.ModeOfAcquisitionCodeId,TD.TransactionTypeCodeId,TD.SecurityTypeCodeId,TD.LotSize)) as PledgeBuyQuantity,
							(select top 1 PledgeSellQuantity from [dbo].[uf_tra_GetBuyORSellQuantity_OS]('PledgeSell',TD.Quantity,0,TD.ModeOfAcquisitionCodeId,TD.TransactionTypeCodeId,TD.SecurityTypeCodeId,TD.LotSize)) as PledgeSellQuantity
						FROM tra_TransactionDetails_OS TD WHERE TD.TransactionDetailsId = @nTransactionDetailsId

						UPDATE TS
						SET BuyQuantity = TS.BuyQuantity + TD.BuyQuantity,
							SellQuantity = TS.SellQuantity + TD.SellQuantity2,
							ClosingBalance = ClosingBalance + TD.BuyQuantity - TD.SellQuantity2,
							Value = TS.Value + TD.Value,
							PledgeBuyQuantity = TS.PledgeBuyQuantity + TD.PledgeBuyQuantity,
							PledgeSellQuantity = TS.PledgeSellQuantity + TD.PledgeSellQuantity,
							PledgeClosingBalance = PledgeClosingBalance + TD.PledgeBuyQuantity - TD.PledgeSellQuantity
						FROM tra_TransactionSummaryDMATWise_OS TS
						JOIN @tmpTransDetails TD ON TD.ForUserInfoId = TS.UserInfoIdRelative 
							AND TD.SecurityTypeCodeId = TS.SecurityTypeCodeId AND TD.DMATDetailsId = TS.DMATDetailsID
							AND TD.CompanyId=TS.CompanyId
						WHERE TS.YearCodeId = @nYearCodeId AND TS.PeriodCodeId = @nPeriodCodeId AND TS.UserInfoId = @nUserInfoId
						
						DELETE FROM @tmpTransDetails
						DELETE FROM @tmpTransactionSummary
						
						FETCH NEXT FROM PeriodType_Cursor INTO @nPeriodType
					END
					
					CLOSE PeriodType_Cursor
					DEALLOCATE PeriodType_Cursor;
				
					FETCH NEXT FROM TraDetail_Cursor INTO @nTransactionDetailsId, @dtDateOfAcq
				END
				
				CLOSE TraDetail_Cursor
				DEALLOCATE TraDetail_Cursor;
				
			END		
		END		
	END	
    -- Insert statements for trigger here

END
GO
