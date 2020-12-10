IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_tra_PreclearanceRequestStatus]'))
DROP TRIGGER [dbo].[tr_tra_PreclearanceRequestStatus]
GO

-- =============================================
-- Author:		Arundhati
-- Create date: 29-Apr-2015
-- Description:	Insert data in event table, when status changes, log the corresponding event

-- Edited By		Edited On			Description
-- Ashashree		30-Jun-2015			Adding postdated event to event log table, when pre-clearance is approved, the pre-clearance expiry event will get logged as well
-- Raghvendra		07-Sep-2016			Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
-- Tushar           03-May-2017         Updated to correct the pre-clerance expiry date which is coming in notification e-mail. added logic to exclude non-trading days
-- =============================================

CREATE TRIGGER [dbo].[tr_tra_PreclearanceRequestStatus] ON [dbo].[tra_PreclearanceRequest]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @nEventCodeID INT
	DECLARE @nEventCodeIDPreClearanceExpiry INT
	DECLARE @nEventCodeID_PreClearanceRequested INT = 153015
	DECLARE @nEventCodeID_PreClearanceApproved INT = 153016
	DECLARE @nEventCodeID_PreClearanceRejected INT = 153017
	DECLARE @nEventCodeID_PreClearanceExpiry INT = 153018 --Pre-clearance expiry (this will always be a postdated event added to eventlog when any Pre-clearance gets approved)

	DECLARE @nMapToTypeCodeId INT = 132004 -- Preclearance
	DECLARE @nMapToId INT
	DECLARE @nUserInfoId INT
	DECLARE @nModifiedBy INT
	
	DECLARE @PreClearanceApprovaldate DATETIME 
    DECLARE @NonTradingDaysCount INT  
	
	DECLARE @nPreclearanceStatus_Requested INT = 144001
	DECLARE @nPreclearanceStatus_Approved INT = 144002
	DECLARE @nPreclearanceStatus_Rejected INT = 144003	

	DECLARE @nPreclearanceStatusNew INT, @nPreclearanceStatusOld INT
	DECLARE @nPreclearanceId INT

	DECLARE	@nPreclearanceValidityDateUpdatedByCO DATETIME = NULL
	
	DECLARE @dtPreClearanceExpiryDate DATETIME
	DECLARE @nTradingPolicyId INT
	DECLARE @TradingPolicyPreClrApprovalValidityLimit INT
	
	DECLARE @TradingWindowEventTypeFinancialYear INT = 126001
			DECLARE @TradingWindowEventTypeOther INT = 126002
			DECLARE @TradingWindowOtherMapToId INT = 132009
			DECLARE @nEventType INT = NULL
			DECLARE @nWindowCloseDate VARCHAR(50)=NULL
			DECLARE @nEventDate DATETIME
			DECLARE @nPreClrApprovalValidityLimit INT
			DECLARE @FLAG INT=1
			DECLARE @CorporateUserType INT = 101004
			DECLARE @NonEmployeeUserType INT = 101006
			DECLARE @COUserType INT = 101002
			DECLARE @EmployeeUserType int = 101003
			DECLARE @Insider int = 112001
			
			CREATE TABLE #TempOtherParameters(WindowCloseDate DATETIME,EventType INT,MapToId INT)
			CREATE TABLE #TempFinancialYearParameters(ID INT IDENTITY NOT NULL,WindowCloseDate DATETIME,EventType INT,MapToId INT,EventDate DATETIME,ValidityLimit INT)
			CREATE TABLE #TempParameters(WindowCloseDate DATETIME,EventType INT,MapToId INT)
			CREATE TABLE #tmpTrading(ApplicabilityMstId INT,UserInfoId INT,MapToId INT)
			
			DECLARE @nExchangeTypeCodeId_NSE INT = 116001
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * INTO #tmpValues_New FROM inserted
	SELECT * INTO #tmpValues_Old FROM deleted

	SELECT	@nPreclearanceStatusNew = PreclearanceStatusCodeId, 
			@nUserInfoId = UserInfoId,
			@nMapToId = PreclearanceRequestId,
			@nPreclearanceValidityDateUpdatedByCO = PreclearanceValidityDateUpdatedByCO,
			@nModifiedBy = ModifiedBy
	FROM #tmpValues_New
	
	SELECT	@nPreclearanceStatusOld = PreclearanceStatusCodeId
	FROM #tmpValues_Old
	
	INSERT INTO #tmpTrading(ApplicabilityMstId,UserInfoId,MapToId)
	EXEC st_tra_GetTradingPolicy
	
	-- Initial disclosures
	IF ISNULL(@nPreclearanceStatusNew, 0) <> ISNULL(@nPreclearanceStatusOld, 0)
	BEGIN
		IF @nPreclearanceStatusNew = @nPreclearanceStatus_Requested
		BEGIN
			SET @nEventCodeID = @nEventCodeID_PreClearanceRequested
		END
		ELSE IF @nPreclearanceStatusNew = @nPreclearanceStatus_Approved
		BEGIN
			SET @nEventCodeID = @nEventCodeID_PreClearanceApproved
			SET @nEventCodeIDPreClearanceExpiry = @nEventCodeID_PreClearanceExpiry --For postdated "pre-clearance expiry" event
		END
		ELSE IF @nPreclearanceStatusNew = @nPreclearanceStatus_Rejected
		BEGIN
			SET @nEventCodeID = @nEventCodeID_PreClearanceRejected
		END
		
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
		VALUES(@nEventCodeID, dbo.uf_com_GetServerDate(), @nUserInfoId, @nMapToTypeCodeId, @nMapToId, @nModifiedBy)
		
		--Start : When pre-clearance is Approved then, calculate and add a postdated "pre-clearance expiry" event based upon trading policy applicable to user
		IF @nPreclearanceStatusNew = @nPreclearanceStatus_Approved 
		BEGIN
			IF(NOT EXISTS(SELECT EventLogId From eve_EventLog WHERE UserInfoId = @nUserInfoId AND MapToTypeCodeId = @nMapToTypeCodeId AND MapToId = @nMapToId AND EventCodeId = @nEventCodeIDPreClearanceExpiry))
			BEGIN
				SELECT @nTradingPolicyId = ISNULL(MAX(MapToId), 0) FROM #tmpTrading where UserInfoId = @nUserInfoId
				print @nTradingPolicyId
				SELECT @TradingPolicyPreClrApprovalValidityLimit = PreClrApprovalValidityLimit FROM rul_TradingPolicy where TradingPolicyId = ISNULL(@nTradingPolicyId,0)
				SELECT @TradingPolicyPreClrApprovalValidityLimit = ISNULL(@TradingPolicyPreClrApprovalValidityLimit,0)
				print @TradingPolicyPreClrApprovalValidityLimit
				
				--Calculate the pre-clearance expiry date
              	--GET WINDOWS CLOSE DATE ACCORDING TO OTHERS
				INSERT INTO #TempOtherParameters(WindowCloseDate,EventType,MapToId)
				SELECT DISTINCT CASE WHEN (CAST(TW.WindowCloseDate AS DATE) >= CAST(EL.EventDate AS DATE) AND CAST(TW.WindowCloseDate AS DATE) <= (select dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(EL.EventDate,@TradingPolicyPreClrApprovalValidityLimit,null,0,1,0,116001,NULL,NULL))) THEN TW.WindowCloseDate END AS ValidityDate ,
				TW.EventTypeCodeId, EL.MapToId 
				FROM rul_ApplicabilityDetails AD 
					LEFT JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId=AM.ApplicabilityId 
					LEFT JOIN rul_TradingWindowEvent TW ON TW.TradingWindowEventId=AM.MapToId
					INNER JOIN tra_PreclearanceRequest PR ON PR.UserInfoId = AD.UserId
					OR CONVERT(date, PR.CreatedOn) >= CONVERT(date, TW.CreatedOn) AND CONVERT(date, PR.CreatedOn) <= CONVERT(date, TW.WindowOpenDate)
					AND PR.UserInfoId =
					(CASE WHEN AllEmployeeFlag = 1 THEN (SELECT UserInfoId FROM USR_USERINFO WHERE UserInfoId=PR.UserInfoId AND UserTypeCodeId = @EmployeeUserType AND StatusCodeId = 102001)
					ELSE CASE WHEN AllInsiderFlag = 1 THEN 
					(SELECT UserInfoId FROM USR_USERINFO WHERE UserInfoId=PR.UserInfoId AND Category = @Insider AND DateOfBecomingInsider IS NOT NULL AND StatusCodeId = 102001)
					ELSE CASE WHEN AD.AllEmployeeInsiderFlag = 1 THEN 
					(SELECT UserInfoId FROM USR_USERINFO WHERE UserInfoId=PR.UserInfoId AND UserTypeCodeId = @EmployeeUserType AND Category = @Insider AND DateOfBecomingInsider IS NOT NULL AND StatusCodeId = 102001)
					ELSE CASE WHEN AD.AllCorporateEmployees = 1 THEN
					(SELECT UserInfoId FROM USR_USERINFO WHERE UserInfoId=PR.UserInfoId AND UserTypeCodeId = @CorporateUserType AND StatusCodeId = 102001)
					ELSE CASE WHEN AD.AllNonEmployee = 1 THEN
					(SELECT UserInfoId FROM USR_USERINFO WHERE UserInfoId=PR.UserInfoId AND UserTypeCodeId = @NonEmployeeUserType AND DateOfBecomingInsider IS NOT NULL AND StatusCodeId = 102001)
					ELSE CASE WHEN AD.AllCo = 1 THEN
					(SELECT UserInfoId FROM USR_USERINFO WHERE UserInfoId=PR.UserInfoId AND UserTypeCodeId = @COUserType AND StatusCodeId = 102001)
					END END END END END END)
					LEFT JOIN eve_EventLog EL ON EL.MapToId=PR.PreclearanceRequestId  
					WHERE AM.MapToTypeCodeId=@TradingWindowOtherMapToId
						 AND AM.VersionNumber=(SELECT MAX(VersionNumber) FROM rul_ApplicabilityMaster WHERE MapToId = TW.TradingWindowEventId and MapToTypeCodeId=@TradingWindowOtherMapToId) 
						 AND EL.MapToTypeCodeId = @nMapToTypeCodeId 
						 AND EL.EventCodeId IN (@nEventCodeID_PreClearanceApproved)
						 AND PR.UserInfoId= @nUserInfoId
						 AND PR.PreclearanceRequestId = @nMapToId
						
				--GET WINDOWS CLOSE DATE ACCORDING TO FINANCIAL YEAR	
				INSERT INTO #TempFinancialYearParameters(MapToId,EventDate,ValidityLimit)
				SELECT DISTINCT EL.MapToId,EL.EventDate,@TradingPolicyPreClrApprovalValidityLimit 
				FROM eve_EventLog EL
					JOIN tra_PreclearanceRequest PR ON PR.PreclearanceRequestId=@nMapToId
					JOIN rul_TradingPolicy TP ON TP.TradingPolicyId = @nTradingPolicyId
					WHERE EL.UserInfoId=@nUserInfoId
						 AND EL.MapToId = @nMapToId
						 AND EL.MapToTypeCodeId = @nMapToTypeCodeId 
						 AND EL.EventCodeId IN(@nEventCodeID_PreClearanceApproved)
					
					WHILE @FLAG<= (SELECT COUNT(*) FROM #TempFinancialYearParameters)
					BEGIN
						SELECT @nEventDate = EventDate,@nPreClrApprovalValidityLimit = ValidityLimit FROM #TempFinancialYearParameters WHERE ID=@FLAG
						
						SELECT @nWindowCloseDate = WindowCloseDate 
						FROM rul_TradingWindowEvent TW 
						WHERE EventTypeCodeId=@TradingWindowEventTypeFinancialYear
						AND ((MONTH(WindowCloseDate)>=MONTH(@nEventDate) AND YEAR(WindowCloseDate)=YEAR(@nEventDate))
						OR (MONTH(WindowCloseDate)<=MONTH(@nEventDate) AND YEAR(WindowCloseDate)>YEAR(@nEventDate)))
						AND (TW.WindowCloseDate BETWEEN @nEventDate AND (select dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(@nEventDate,@nPreClrApprovalValidityLimit,null,0,1,0,116001,NULL,NULL)))
										
						UPDATE #TempFinancialYearParameters 
						SET WindowCloseDate=@nWindowCloseDate,EventType=@TradingWindowEventTypeFinancialYear
						WHERE ID=@FLAG 
						
						SET @nWindowCloseDate=NULL
						SET @FLAG=@FLAG+1
					END
					
					INSERT INTO #TempParameters(WindowCloseDate,EventType,MapToId)
					SELECT CASE WHEN O.WindowCloseDate IS NULL THEN FY.WindowCloseDate
						ELSE CASE WHEN FY.WindowCloseDate IS NULL THEN O.WindowCloseDate
						ELSE CASE WHEN O.WindowCloseDate < FY.WindowCloseDate THEN O.WindowCloseDate ELSE FY.WindowCloseDate END END END,
						CASE WHEN O.WindowCloseDate IS NULL THEN FY.EventType
						ELSE CASE WHEN FY.WindowCloseDate IS NULL THEN O.EventType
						ELSE CASE WHEN O.WindowCloseDate<FY.WindowCloseDate THEN O.EventType ELSE FY.EventType END END END,
						CASE WHEN O.WindowCloseDate IS NULL THEN FY.MapToId
						ELSE CASE WHEN FY.WindowCloseDate IS NULL THEN O.MapToId
						ELSE CASE WHEN O.WindowCloseDate<FY.WindowCloseDate THEN O.MapToId ELSE FY.MapToId END END END
					FROM #TempFinancialYearParameters FY
					LEFT JOIN #TempOtherParameters O ON O.MapToId=FY.MapToId AND O.WindowCloseDate IS NOT NULL
						
					SELECT @nEventType=EventType,@nWindowCloseDate=WindowCloseDate FROM #TempParameters WHERE MapToId=@nMapToId
					print @nEventType
					print @nWindowCloseDate
					SELECT @dtPreClearanceExpiryDate=CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(dbo.uf_com_GetServerDate(),@TradingPolicyPreClrApprovalValidityLimit,null,0,1,0,@nExchangeTypeCodeId_NSE,@nEventType,@nWindowCloseDate)) 
					print @dtPreClearanceExpiryDate
				INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
				VALUES(@nEventCodeIDPreClearanceExpiry, @dtPreClearanceExpiryDate, @nUserInfoId, @nMapToTypeCodeId, @nMapToId, @nModifiedBy)
			END
		END
		--End : When pre-clearance is Approved then, calculate and add a postdated "pre-clearance expiry" event based upon trading policy applicable to user
	END
	
	IF @nPreclearanceStatusNew = @nPreclearanceStatus_Approved 
    BEGIN
		IF @nPreclearanceValidityDateUpdatedByCO IS NOT NULL
		BEGIN
			UPDATE eve_EventLog SET EventDate = CONVERT(DATE, @nPreclearanceValidityDateUpdatedByCO) WHERE UserInfoId = @nUserInfoId AND MapToId = @nMapToId AND MapToTypeCodeId = @nMapToTypeCodeId AND EventCodeId = @nEventCodeID_PreClearanceExpiry
	    END
    END

	DROP TABLE #TempOtherParameters
	DROP TABLE #TempFinancialYearParameters
	DROP TABLE #TempParameters
END
GO
