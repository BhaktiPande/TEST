IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreClearanceRequestDetailsPreviousTradeList_CO')
DROP PROCEDURE [dbo].[st_tra_PreClearanceRequestDetailsPreviousTradeList_CO]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list the preclearance, PNT, trade details for the previous N days prior to current date, 
				where N is the #days specified in Trading Policy : "Contra trade not allowed for N days from opposite direction"

Returns:		0, if Success.
				
Created by:		Ashashree
Created on:		26-Aug-2015

Modification History:
Modified By		Modified On		Description
Parag			28-Aug-2015     Made change to show actaully traded quantity and value  
								Also made change to show "Pending" status text when pre clearance status is "Confirmed"
Parag			11-Sep-2015		Made change to get pervious pre-clearance request details base on per-clearance id 
Parag			12-Sep-2015		Made change to include period end disclosure transaction into list 
								Also change to consider contra trade date from and to dates when fetching records
Parag			16-Sep-2015		Made change to show period wise total 
Parag			22-Dec-2015		Made chagne to fix issue of date comparision for contra trade period
Tushar			23-Mar-2016		After submitting the trade details in Continuous Disclosures of Non-Insider Employee, 
								system is giving an ID is "PNR<no.>". 
								& Insider Employee its shows "PNT<no.>". & Preclearance case show "PCL<no.>".
								all text fetch from com code table.
Raghvendra		12-May-2016		Mantis 8560. Changes for showing the No Of Securities requested for preclearance and Preclearance Values on the past preclearance list for preclearances with pending status.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Tushar			13-Sep-2016		Changes for FORM E generation and showing download link on page.

Usage:
EXEC st_tra_PreClearanceRequestDetailsPreviousTradeList_CO 10, 1, '','ASC', 52
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_PreClearanceRequestDetailsPreviousTradeList_CO]
	@inp_iPageSize			INT = 10
	,@inp_iPageNo			INT = 1
	,@inp_sSortField		VARCHAR(255)
	,@inp_sSortOrder		VARCHAR(5)
	,@inp_iPreClearnanceId	INT						--Current pre-clearance request id.
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	

AS
BEGIN
	DECLARE @nContraTradeDays INT
	DECLARE @nUserInfoID INT
	DECLARE @IsNotPeriodWiseTotal BIT
	DECLARE @nPeriodType INT
	DECLARE @dtLastContraTradeDate DATE
	DECLARE @dtCurrentPreclearanceDATE DATE
	
	DECLARE @nContinousDisclosureType	INT = 147002
	DECLARE @nPeriodEndDisclosureType	INT = 147003
	
	DECLARE @nPreClearanceConfirmedCodeId INT = 144001
	DECLARE @nPreClearanceApprovedCodeId INT = 144002
	
	DECLARE @nTotalPreclearanceQuantity DECIMAL(15,4)
	DECLARE @nTotalPreclearanceValue DECIMAL(20,4)
	DECLARE @nTotalTradedQuantity DECIMAL(10,0)
	DECLARE @nTotalTradedValue DECIMAL(10,0)
	
	DECLARE @sAutoApproveText	VARCHAR(20)
	DECLARE @sTotalsText	VARCHAR(20)
	DECLARE @sPendingText	VARCHAR(20)
	
	DECLARE @nTransactionStatus_Document_Uploaded INT = 148001
	DECLARE @nTranscationStatus_Not_Confirmd INT = 148002
	
	DECLARE @nMapToTypeCode_Preclearance INT = 132004
	
	DECLARE @nEvent_Preclearance_Approve INT = 153016
	DECLARE @nEvent_Preclearance_Reject INT = 153017
	
	DECLARE @nCnt INT
	DECLARE @nOffSet INT = 0
	
	DECLARE @dtToDate DATETIME -- This is the date of the current preclearance (preclearance request / approval date)
	DECLARE @dtFromDate DATETIME -- This is the From date, i.e. the current date - no of contra trade or the fixed days

	DECLARE @nYearCodeId INT, @nPeriodCodeId INT, @dtToday DATETIME
	DECLARE @dtPEStartDate DATETIME, @dtPEEndDate DATETIME
	
	DECLARE @ERR_PRECLEARANCE_REQUEST_DETAILS_LIST_CO INT = 17378
	
	DECLARE @nPreclearanceTakenCase INT = 176001
	DECLARE @nInsiderNotPreclearanceTakenCase INT = 176002
	DECLARE @nNonInsiderNotPreclearanceTakenCase INT = 176003
	
	DECLARE	@sPrceclearanceCodePrefixText VARCHAR(200) = (SELECT CodeName FROM com_Code Where CodeId = @nPreclearanceTakenCase)
	DECLARE @sNonPrceclearanceCodePrefixText VARCHAR(200) = (SELECT CodeName FROM com_Code Where CodeId = @nInsiderNotPreclearanceTakenCase)
	DECLARE @sPrceclearanceNotRequiredPrefixText VARCHAR(200) = (SELECT CodeName FROM com_Code Where CodeId = @nNonInsiderNotPreclearanceTakenCase)
	
	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		CREATE TABLE #tmpUsers(Id INT IDENTITY(1,1), 
								DisplayName NVARCHAR(MAX), --Preclearance ID
								PreClearanceDate DATETIME, --Preclearance CreatedOn Date
								DateOfAcquisition DATETIME, -- Date on with security are traded 
								EventDate DATETIME, -- date on which preclearance accepted or rejected
								TransactionTypeCodeID INT, --Transaction Type
								SecuritiesTypeCodeID INT, --Type of Security
								PreclearanceQty DECIMAL(15,4), --No. Of Securities
								PreclearanceValue DECIMAL(20,4), --Pre-clearance value
								TradedQty DECIMAL(10,0), --Trade Qty
								TradeValue DECIMAL(10,0), --Trade Value
								PreclearanceStatus INT,  --Status of Preclearance : Approved / Pending For approval etc.
								IsTotalRow INT DEFAULT 0, -- 1 means PLC/PNT/Preiod end record and 1 means period wise total, 2 means final total
								UserInfoId INT, 
								TransactionMasterID INT,
								TransactionDetailsID INT,
								PreClearanceRequestID INT, 
								DisclosureTypeCodeId INT, -- disclosure type : continuous / period end
								TransactionStatusCodeId INT, -- Transcation status from transaction master
								IsAutoApproved BIT,
								PartiallyTradedFlag BIT,
								TradingPolicyId INT,
								IsAddButtonRow INT DEFAULT 0,
								SortDateField DATETIME)
		
		-- temp table to store period wise total
		DECLARE @tmpPriodWiseFromToDates TABLE(
							PeriodCodeId INT, PeriodStartDate DATETIME, PeriodEndDate DATETIME, PRQty INT DEFAULT 0, PRValue INT DEFAULT 0, 
							TradeQty INT DEFAULT 0, TradeVal INT DEFAULT 0)

		--Approve Button Text
		SELECT @sAutoApproveText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17379' --Auto Approved
		SELECT @sTotalsText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_lbl_17380' --Total :
		SELECT @sPendingText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17005' -- Pending
		
		--Fetch the contra trade days from trading policy applicable for current per-clearance 
		SELECT 
			@nContraTradeDays = TP.GenContraTradeNotAllowedLimit,
			@nUserInfoID = PCR.UserInfoId,
			@IsNotPeriodWiseTotal = TP.PreClrTradesApprovalReqFlag,
			@nPeriodType = TP.PreClrMultipleAboveInCodeId,
			@dtCurrentPreclearanceDATE = PCR.CreatedOn
		FROM tra_PreclearanceRequest PCR
		LEFT JOIN tra_TransactionMaster TM ON PCR.PreclearanceRequestId = TM.PreclearanceRequestId
		LEFT JOIN rul_TradingPolicy TP on TM.TradingPolicyId = TP.TradingPolicyId
		WHERE PCR.PreclearanceRequestId = @inp_iPreClearnanceId

		SELECT @nContraTradeDays = -@nContraTradeDays
		SELECT @dtLastContraTradeDate = DATEADD(day, @nContraTradeDays, @dtCurrentPreclearanceDATE)
		
		print @nContraTradeDays
		--------------------------------
		--SET @nContraTradeDays = -180
		--------------------------------
		--SELECT @nContraTradeDays
		--SELECT dbo.uf_com_GetServerDate(), DATEADD(DAY, @nContraTradeDays, dbo.uf_com_GetServerDate())

		--Add transaction details records 
		INSERT INTO #tmpUsers
			(DisplayName, PreClearanceDate, DateOfAcquisition, EventDate, TransactionTypeCodeID, SecuritiesTypeCodeID, 
				PreclearanceQty, PreclearanceValue, 
				TradedQty, TradeValue, 
				PreclearanceStatus, UserInfoId, TransactionMasterID, TransactionDetailsID, PreClearanceRequestID, DisclosureTypeCodeId, 
				TransactionStatusCodeId, IsAutoApproved, PartiallyTradedFlag, TradingPolicyId, SortDateField)
		SELECT 
			CASE 
				WHEN TM.DisclosureTypeCodeId = @nContinousDisclosureType THEN 
					CASE 
						WHEN TM.PreclearanceRequestId IS NULL THEN
						CASE WHEN UF.DateOfBecomingInsider IS NOT NULL THEN @sNonPrceclearanceCodePrefixText + CONVERT(VARCHAR,TM.DisplayRollingNumber)  
					 ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(VARCHAR,TM.DisplayRollingNumber) END
					ELSE @sPrceclearanceCodePrefixText + CONVERT(VARCHAR,TM.DisplayRollingNumber) END
						-- 'PNT' + CONVERT(VARCHAR,TM.TransactionMasterId) 
						--ELSE 'PCL' + CONVERT(VARCHAR,ISNULL(TM.ParentTransactionMasterId, TM.TransactionMasterId))
					--END
				WHEN TM.DisclosureTypeCodeId = @nPeriodEndDisclosureType THEN 'PE' + CONVERT(VARCHAR,TM.DisplayRollingNumber)
			END AS DisplayName, PCR.CreatedOn AS PreClearanceDate, TD.DateOfAcquisition, CONVERT(date, EL.EventDate),
			CASE 
				WHEN TM.PreclearanceRequestId IS NOT NULL THEN PCR.TransactionTypeCodeId 
				ELSE TD.TransactionTypeCodeId 
			END AS TransactionTypeCodeId, 
			CASE 
				WHEN TM.PreclearanceRequestId IS NOT NULL THEN PCR.SecurityTypeCodeId 
				ELSE TD.SecurityTypeCodeId 
			END AS SecurityTypeCodeId, 
			PCR.SecuritiesToBeTradedQty, PCR.SecuritiesToBeTradedValue, 
			CASE WHEN TD.DateOfAcquisition IS NOT NULL AND TM.TransactionStatusCodeId NOT IN (@nTranscationStatus_Not_Confirmd, @nTransactionStatus_Document_Uploaded) THEN TD.Quantity ELSE NULL END AS TradedQty,
			CASE WHEN TD.DateOfAcquisition IS NOT NULL AND TM.TransactionStatusCodeId NOT IN (@nTranscationStatus_Not_Confirmd, @nTransactionStatus_Document_Uploaded) THEN TD.Value ELSE NULL END AS TradeValue,
			PCR.PreclearanceStatusCodeId, TM.UserInfoId, TM.TransactionMasterId, TD.TransactionDetailsId, TM.PreclearanceRequestId, TM.DisclosureTypeCodeId, 
			TM.TransactionStatusCodeId, PCR.IsAutoApproved, TM.PartiallyTradedFlag, TM.TradingPolicyId, 
			CASE 
				WHEN TD.DateOfAcquisition IS NULL THEN 
					CASE WHEN EL.EventDate IS NULL THEN PCR.CreatedOn ELSE EventDate END
				ELSE DateOfAcquisition 
			END AS SortDateField
		FROM 
			tra_TransactionMaster TM LEFT JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
			LEFT JOIN tra_PreclearanceRequest PCR ON TM.PreclearanceRequestId = PCR.PreclearanceRequestId AND PCR.PreclearanceRequestId <> @inp_iPreClearnanceId
			JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
			LEFT JOIN eve_EventLog EL ON EL.MapToTypeCodeId = @nMapToTypeCode_Preclearance AND EL.EventCodeId in (@nEvent_Preclearance_Approve, @nEvent_Preclearance_Reject) AND EL.MapToId = PCR.PreclearanceRequestId
		WHERE 
			TM.UserInfoId = @nUserInfoID
			AND (TM.PreclearanceRequestId IS NOT NULL OR 
					(TM.PreclearanceRequestId IS NULL AND TM.TransactionStatusCodeId NOT IN (@nTranscationStatus_Not_Confirmd, @nTransactionStatus_Document_Uploaded)))
			AND TM.DisclosureTypeCodeId IN (@nContinousDisclosureType, @nPeriodEndDisclosureType)
			AND ((TD.DateOfAcquisition IS NULL AND (convert(date, PCR.CreatedOn) >= @dtLastContraTradeDate AND convert(date, PCR.CreatedOn) <= @dtCurrentPreclearanceDATE)) OR 
					(TD.DateOfAcquisition IS NOT NULL AND TD.DateOfAcquisition >= @dtLastContraTradeDate AND TD.DateOfAcquisition <= @dtCurrentPreclearanceDATE))
			AND (EL.EventDate IS NULL OR (EL.EventDate IS NOT NULL AND (CONVERT(date, EL.EventDate) >= @dtLastContraTradeDate AND convert(date, EL.EventDate) <= @dtCurrentPreclearanceDATE)))
		ORDER BY SortDateField DESC

		--SELECT * FROM #tmpUsers
		
		--Add total row in the temp table
		IF( (SELECT COUNT(ID) FROM #tmpUsers) > 0 ) 
		BEGIN
			--check if show complete total or period wise total
			IF(@IsNotPeriodWiseTotal = 0 AND @nPeriodType IS NOT NULL)
			BEGIN
				print 'show group total'
				SELECT @dtToDate = @dtCurrentPreclearanceDATE
				SELECT @dtFromDate = @dtLastContraTradeDate
						
				-- Map period type code used for per-clearance with period end type code
				SET @nPeriodType = CASE WHEN @nPeriodType = 137001 THEN 123001 -- Yearly
										WHEN @nPeriodType = 137002 THEN 123003 -- Quarterly
										WHEN @nPeriodType = 137003 THEN 123004 -- Monthly
										WHEN @nPeriodType = 137004 THEN 123002 -- half yearly
										ELSE @nPeriodType END

				-- Set no of months need for period type 
				SELECT @nOffSet = CASE WHEN @nPeriodType = 123001 THEN 12
										WHEN @nPeriodType = 123002 THEN 6
										WHEN @nPeriodType = 123003 THEN 3
										WHEN @nPeriodType = 123004 THEN 1
									ELSE @nOffSet END
				
				--get number of loop count for period 
				SELECT @nCnt = -@nContraTradeDays / (30 * @nOffSet) + 2
				
				SELECT @dtToday = @dtToDate
				
				-- show period wise total
				WHILE @nCnt > 0 AND @nPeriodType IS NOT NULL
				BEGIN				
					SELECT @nYearCodeId = null, @nPeriodCodeId = null
					
					--get start and end date
					EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
					   @nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT, @dtToday, @nPeriodType, 0, @dtPEStartDate OUTPUT, @dtPEEndDate OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT

					SET @dtToday = DATEADD(M, -@nOffSet, @dtToday)
					
					-- add pre-clearance value and quantity 
					UPDATE #tmpUsers SET PreclearanceValue = tmp2.SecuritiesToBeTradedValue, PreclearanceQty = tmp2.SecuritiesToBeTradedQty
					FROM (
						SELECT tmp.mId, PCR.PreclearanceRequestId, PCR.SecuritiesToBeTradedQty, PCR.SecuritiesToBeTradedValue FROM tra_PreclearanceRequest PCR JOIN (
							SELECT MAX(Id) AS mId, t.PreClearanceRequestID FROM #tmpUsers t 
							WHERE 
								t.PreClearanceRequestID IS NOT NULL AND 
								(t.EventDate IS NOT NULL AND t.EventDate >= @dtPEStartDate AND t.EventDate <= @dtPEEndDate OR 
								t.EventDate IS NULL AND t.PreClearanceDate >= @dtPEStartDate AND t.PreClearanceDate <= @dtPEEndDate)
							GROUP BY t.PreClearanceRequestID
						) AS tmp ON PCR.PreclearanceRequestId = tmp.PreClearanceRequestID
					) AS tmp2 WHERE tmp2.mId = Id
					
					-- Take total of preclearance value
					SELECT @nTotalPreclearanceValue = SUM(U.PreclearanceValue), @nTotalPreclearanceQuantity = SUM(U.PreclearanceQty) 
					FROM #tmpUsers U 
					WHERE U.SortDateField >= @dtPEStartDate AND U.SortDateField <= @dtPEEndDate
					
					-- Take total of trade value
					SELECT @nTotalTradedValue = SUM(U.TradeValue), @nTotalTradedQuantity = SUM(U.TradedQty)
					FROM #tmpUsers U 
					WHERE U.DateOfAcquisition >= @dtPEStartDate AND U.DateOfAcquisition <= @dtPEEndDate
					
					-- add data into temp table
					INSERT INTO @tmpPriodWiseFromToDates(PeriodCodeId, PeriodStartDate, PeriodEndDate, PRQty, PRValue, TradeQty, TradeVal) 
					VALUES (@nPeriodCodeId, @dtPEStartDate, @dtPEEndDate, ISNULL(@nTotalPreclearanceQuantity,0), ISNULL(@nTotalPreclearanceValue,0), ISNULL(@nTotalTradedQuantity,0), ISNULL(@nTotalTradedValue,0))
					
					SET @nCnt = @nCnt - 1
				END
				
				-- delete irrelavant records from temp table
				DELETE FROM @tmpPriodWiseFromToDates WHERE PeriodEndDate < @dtFromDate OR PeriodStartDate > @dtToDate
				
				--select * from @tmpPriodWiseFromToDates 
				--select * from #tmpUsers
				
				-- Add total record row
				INSERT	INTO #tmpUsers
					(DisplayName, PreClearanceDate, DateOfAcquisition, TransactionTypeCodeID, SecuritiesTypeCodeID, PreclearanceQty, PreclearanceValue, 
						TradedQty, TradeValue, PreclearanceStatus, IsTotalRow, UserInfoId, TransactionMasterID, TransactionDetailsID, PreClearanceRequestID, 
						DisclosureTypeCodeId, TransactionStatusCodeId, IsAutoApproved, PartiallyTradedFlag, TradingPolicyId, IsAddButtonRow, SortDateField)
				SELECT 
					 cperiod.DisplayCode + ' ' + @sTotalsText AS DisplayName, NULL, NULL, NULL, NULL, tmptotal.PRQty, tmptotal.PRValue, 
					 tmptotal.TradeQty, tmptotal.TradeVal, NULL, 1, NULL, NULL, NULL, NULL, 
					 NULL, NULL, NULL, NULL, NULL, NULL, tmptotal.PeriodStartDate
				FROM @tmpPriodWiseFromToDates tmptotal JOIN com_Code cperiod ON cperiod.CodeID = tmptotal.PeriodCodeId
				ORDER BY PeriodStartDate DESC
				
				-- delete total row which does not have any value
				--DELETE FROM #tmpUsers WHERE IsTotalRow = 1 AND PreclearanceQty = 0 AND PreclearanceValue = 0 AND TradedQty = 0 AND TradeValue = 0
			END
			ELSE
			BEGIN
				print 'show single total'
				
				SELECT @dtPEEndDate = @dtCurrentPreclearanceDATE
				SELECT @dtPEStartDate = @dtLastContraTradeDate
				
				UPDATE #tmpUsers SET PreclearanceValue = tmp2.SecuritiesToBeTradedValue, PreclearanceQty = tmp2.SecuritiesToBeTradedQty
				FROM (
					SELECT tmp.mId, PCR.PreclearanceRequestId, PCR.SecuritiesToBeTradedQty, PCR.SecuritiesToBeTradedValue FROM tra_PreclearanceRequest PCR JOIN (
						SELECT MAX(Id) AS mId, t.PreClearanceRequestID FROM #tmpUsers t 
						WHERE 
							t.PreClearanceRequestID IS NOT NULL AND 
							(t.EventDate IS NOT NULL AND t.EventDate >= @dtPEStartDate AND t.EventDate <= @dtPEEndDate OR 
							t.EventDate IS NULL AND t.PreClearanceDate >= @dtPEStartDate AND t.PreClearanceDate <= @dtPEEndDate)
						GROUP BY t.PreClearanceRequestID
					) AS tmp ON PCR.PreclearanceRequestId = tmp.PreClearanceRequestID
				) AS tmp2 WHERE tmp2.mId = Id
				
				-- Take total of preclearance value
				SELECT @nTotalPreclearanceValue = SUM(U.PreclearanceValue), @nTotalPreclearanceQuantity = SUM(U.PreclearanceQty) 
				FROM #tmpUsers U 
				WHERE U.SortDateField >= @dtPEStartDate AND U.SortDateField <= @dtPEEndDate
				
				-- Take total of trade value
				SELECT @nTotalTradedValue = SUM(U.TradeValue), @nTotalTradedQuantity = SUM(U.TradedQty)
				FROM #tmpUsers U 
				WHERE U.DateOfAcquisition >= @dtPEStartDate AND U.DateOfAcquisition <= @dtPEEndDate
				
				-- add data into temp table
				INSERT INTO @tmpPriodWiseFromToDates(PeriodCodeId, PeriodStartDate, PeriodEndDate, PRQty, PRValue, TradeQty, TradeVal) 
				VALUES (@nPeriodCodeId, @dtPEStartDate, @dtPEEndDate, ISNULL(@nTotalPreclearanceQuantity,0), ISNULL(@nTotalPreclearanceValue,0), ISNULL(@nTotalTradedQuantity,0), ISNULL(@nTotalTradedValue,0))
				
				--select * from @tmpPriodWiseFromToDates
			END
			
			-- Take final total
			SELECT 
				@nTotalPreclearanceQuantity = SUM(PRQty), @nTotalPreclearanceValue = SUM(PRValue),
				@nTotalTradedQuantity = SUM(TradeQty), @nTotalTradedValue = SUM(TradeVal)
			FROM @tmpPriodWiseFromToDates 
			
			-- Add fianl total record row
			INSERT	INTO #tmpUsers
				(DisplayName, PreClearanceDate, DateOfAcquisition, TransactionTypeCodeID, SecuritiesTypeCodeID, PreclearanceQty, PreclearanceValue, 
					TradedQty, TradeValue, PreclearanceStatus, IsTotalRow, UserInfoId, TransactionMasterID, TransactionDetailsID, PreClearanceRequestID, 
					DisclosureTypeCodeId, TransactionStatusCodeId, IsAutoApproved, PartiallyTradedFlag, TradingPolicyId, IsAddButtonRow, SortDateField)
			VALUES 
				 (@sTotalsText, NULL, NULL, NULL, NULL, @nTotalPreclearanceQuantity, @nTotalPreclearanceValue, 
					 @nTotalTradedQuantity, @nTotalTradedValue, NULL, 2, NULL, NULL, NULL, NULL, 
					 NULL, NULL, NULL, NULL, NULL, NULL, NULL)
			
		END
		
		--SELECT * FROM #tmpUsers ORDER BY SortDateField DESC, IsTotalRow ASC
		
		/*SELECT the final output dataset here*/
		SELECT	
			TmpPreClearance.DisplayName AS dis_grd_17360, -- display text , 
			TmpPreClearance.PreClearanceDate AS dis_grd_17361,--Date : PreClearanceDate, 
			TmpPreClearance.DateOfAcquisition AS dis_grd_17387, -- Date of Acquisition
			ccTransactionTypeCode.CodeName AS dis_grd_17362, --Transaction Type : PreClearanceTransactionTypeCode, 
			ccSecuritiesCode.CodeName AS dis_grd_17363, --Type of Security : PreClearanceSecuritiesCode, 
			TmpPreClearance.PreclearanceQty AS dis_grd_17364, --No. of Securities : PreclearanceQty, 
			TmpPreClearance.PreclearanceValue AS dis_grd_17365, --Pre-Clearance Value : PreclearanceValue, 
			TmpPreClearance.TradedQty AS dis_grd_17366, --Traded Qty : TradedQty  
			TmpPreClearance.TradeValue AS dis_grd_17367, --Traded Value : TradeValue
			CASE 
				WHEN (TmpPreClearance.PreclearanceStatus = @nPreClearanceApprovedCodeId AND IsAutoApproved = 1) THEN @sAutoApproveText 
				WHEN TmpPreClearance.PreclearanceStatus = @nPreClearanceConfirmedCodeId THEN @sPendingText
				ELSE ccPreClearStatus.CodeName 
			END AS dis_grd_17368, --PreClearStatus,
			TmpPreClearance.DateOfAcquisition,
			TmpPreClearance.EventDate,
			TmpPreClearance.SortDateField,
			TmpPreClearance.IsTotalRow,
			TmpPreClearance.PreclearanceStatus,
			TmpPreClearance.PreClearanceRequestID,
			TmpPreClearance.TransactionMasterID,
			TmpPreClearance.TransactionStatusCodeId,
			TP.IsPreclearanceFormForImplementingCompany AS IsPreclearanceFormForImplementingCompany
			,CASE WHEN GFD.GeneratedFormDetailsId IS NULL THEN 0 ELSE 1 END AS IsFORMEGenrated
		FROM #tmpUsers TmpPreClearance
		LEFT JOIN com_Code ccTransactionTypeCode ON TmpPreClearance.TransactionTypeCodeID = ccTransactionTypeCode.CodeID
		LEFT JOIN com_Code ccSecuritiesCode ON TmpPreClearance.SecuritiesTypeCodeID = ccSecuritiesCode.CodeID
		LEFT JOIN com_Code ccPreClearStatus ON TmpPreClearance.PreclearanceStatus = ccPreClearStatus.CodeID
		LEFT JOIN rul_TradingPolicy TP ON TmpPreClearance.TradingPolicyId = TP.TradingPolicyId
		LEFT JOIN tra_GeneratedFormDetails GFD ON TmpPreClearance.PreClearanceRequestID = GFD.MapToId AND GFD.MapToTypeCodeId = 132004
		ORDER BY TmpPreClearance.SortDateField DESC, TmpPreClearance.IsTotalRow ASC
		
		DROP TABLE #tmpUsers
		
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PRECLEARANCE_REQUEST_DETAILS_LIST_CO
	END CATCH
	
END