IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_tra_UpdatePreclearanceValidityDate]'))
DROP TRIGGER [dbo].[tr_tra_UpdatePreclearanceValidityDate]
GO

-- =============================================
-- Author:		Priyanka
-- Create date: 10-Jan-2018
-- Description:	Update preclearance validity date in event log table when trading window open and close date changed
-- =============================================

CREATE TRIGGER [dbo].[tr_tra_UpdatePreclearanceValidityDate] ON [dbo].[rul_TradingWindowEvent]
FOR INSERT, UPDATE
AS
BEGIN
		DECLARE @nMapToTypeCodeId INT = 132004
		DECLARE @nEventCodeID_PreClearanceApproved INT = 153016
		DECLARE @dtPreClearanceExpiryDate DATETIME
		DECLARE @nEventCodeIDPreClearanceExpiry DATETIME = 153018
		DECLARE @dtTradingWindowCreatedDateOld DATETIME 
		DECLARE @dtTradingWindowOpenDateOld DATETIME 
		DECLARE @nTradingWindowEventId INT

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
		DECLARE @nExchangeTypeCodeId_NSE INT = 116001
		DECLARE @TradingWindowStatusCodeId_Active INT = 131002
		DECLARE @TradingWindowStatus INT
			
		CREATE TABLE #TempOtherParameters(WindowCloseDate DATETIME,EventType INT,MapToId INT)
		CREATE TABLE #TempFinancialYearParameters(ID INT IDENTITY NOT NULL,WindowCloseDate DATETIME,EventType INT,MapToId INT,EventDate DATETIME,ValidityLimit INT)
		CREATE TABLE #TempParameters(WindowCloseDate DATETIME,EventType INT,MapToId INT)
		CREATE TABLE #TempEventLog(EventLogId INT, EventCodeId INT, EventDate DATETIME, UserInfoId INT, MapToTypeCodeId INT, MapToId INT,PreClrApprovalValidityLimit INT)
			
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * INTO #tmpValues_New FROM inserted
	SELECT * INTO #tmpValues_Old FROM deleted
	
	SELECT	@dtTradingWindowCreatedDateOld = CreatedOn,
			@dtTradingWindowOpenDateOld = WindowOpenDate,
			@nTradingWindowEventId = TradingWindowEventId
	FROM #tmpValues_Old
	
	SELECT @TradingWindowStatus= TradingWindowStatusCodeId
	FROM #tmpValues_New
	
	IF(@TradingWindowStatus = @TradingWindowStatusCodeId_Active)
	BEGIN
			INSERT INTO #TempEventLog(EventLogId, EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId,PreClrApprovalValidityLimit)
			SELECT EL.EventLogId, EL.EventCodeId, EL.EventDate, EL.UserInfoId, EL.MapToTypeCodeId, EL.MapToId,TP.PreClrApprovalValidityLimit FROM eve_EventLog EL
			LEFT JOIN tra_PreclearanceRequest PR ON PR.PreclearanceRequestId = EL.MapToId
			INNER JOIN tra_TransactionMaster TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId
			INNER JOIN rul_TradingPolicy TP ON TP.TradingPolicyId = TM.TradingPolicyId
			WHERE MapToTypeCodeId=132004 AND EventCodeId = 153018
			AND (CONVERT(date, PR.CreatedOn) >= CONVERT(DATE, @dtTradingWindowCreatedDateOld) AND CONVERT(DATE, PR.CreatedOn) <= CONVERT(DATE, @dtTradingWindowOpenDateOld))
										
			--Calculate the pre-clearance expiry date
			--GET WINDOWS CLOSE DATE ACCORDING TO OTHERS
			INSERT INTO #TempOtherParameters(WindowCloseDate,EventType,MapToId)
			SELECT DISTINCT CASE WHEN (CAST(TW.WindowCloseDate AS DATE) >= CAST(EL.EventDate AS DATE) AND CAST(TW.WindowCloseDate AS DATE) <= (select dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(EL.EventDate,tEL.PreClrApprovalValidityLimit,null,0,1,0,116001,NULL,NULL))) THEN TW.WindowCloseDate END AS ValidityDate ,
			TW.EventTypeCodeId, EL.MapToId
			FROM rul_ApplicabilityDetails AD 
			LEFT JOIN rul_ApplicabilityMaster AM ON AD.ApplicabilityMstId=AM.ApplicabilityId
			INNER JOIN rul_TradingWindowEvent TW ON TW.TradingWindowEventId=AM.MapToId
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
			INNER JOIN #TempEventLog tEL ON tEL.MapToId = PR.PreclearanceRequestId
			WHERE AM.MapToTypeCodeId = @TradingWindowOtherMapToId 
					AND EL.MapToTypeCodeId = @nMapToTypeCodeId 
					AND EL.EventCodeId IN (@nEventCodeID_PreClearanceApproved)
					AND TW.TradingWindowEventId = @nTradingWindowEventId
									
				--GET WINDOWS CLOSE DATE ACCORDING TO FINANCIAL YEAR	
				INSERT INTO #TempFinancialYearParameters(MapToId,EventDate,ValidityLimit)
				SELECT DISTINCT EL.MapToId,EL.EventDate,tEL.PreClrApprovalValidityLimit 
				FROM eve_EventLog EL
					JOIN #TempEventLog tEL ON tEL.MapToId = EL.MapToId
					WHERE EL.UserInfoId=tEL.UserInfoId
						 AND EL.MapToTypeCodeId = @nMapToTypeCodeId 
						 AND EL.EventCodeId IN(@nEventCodeIDPreClearanceExpiry)
				
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
								
				UPDATE EEL SET EEL.EventDate = temp.WindowsCloseDate 
				FROM eve_EventLog EEL
				INNER JOIN 
				(SELECT EL.MapToId,CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(El.EventDate,tEL.PreClrApprovalValidityLimit,null,0,1,0,@nExchangeTypeCodeId_NSE,tp.EventType,tp.WindowCloseDate)) AS WindowsCloseDate  
				FROM eve_EventLog EL
				JOIN #TempParameters tp ON tp.MapToId = EL.MapToId
				LEFT JOIN #TempEventLog tEL ON tEL.MapToId= EL.MapToId
				WHERE EL.MapToTypeCodeId = @nMapToTypeCodeId 
				AND EL.EventCodeId = @nEventCodeID_PreClearanceApproved) temp
				ON temp.MapToId = EEL.MapToId 
				WHERE EEL.EventCodeId = @nEventCodeIDPreClearanceExpiry AND EEL.MapToTypeCodeId = @nMapToTypeCodeId
	END
		
	DROP TABLE #TempOtherParameters
	DROP TABLE #TempFinancialYearParameters
	DROP TABLE #TempParameters
	DROP TABLE #TempEventLog
END
GO
