IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetPreclearanceValidityDate')
DROP PROCEDURE [dbo].[st_tra_GetPreclearanceValidityDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure for Get Preclearance Validity Date.

Returns:		0, if Success.
				
Created by:		Tushar Wakchaure
Created on:		03-July-2019

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_GetPreclearanceValidityDate]
     @inp_sPreclearanceRequestId					INT
	,@out_PreclearanceValidityDate                  DATETIME = NULL     OUTPUT
	,@out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
    DECLARE @ERR_GetPreclearanceValidityDate  INT = 52119
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


	DECLARE @nTradingWindow_Incomplete   INT = 131001	
	DECLARE @nTradingWindow_Active       INT = 131002	
	DECLARE @nTradingWindow_Inactive     INT = 131003	

	DECLARE @nPreclearanceStatusNew INT, @nPreclearanceStatusOld INT
	DECLARE @nPreclearanceId INT
	
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

    BEGIN TRY
	    SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT	@nPreclearanceStatusNew = PreclearanceStatusCodeId, 
				@nUserInfoId = UserInfoId,
				@nMapToId = PreclearanceRequestId,
				@nModifiedBy = ModifiedBy
		FROM tra_PreclearanceRequest WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId
	
	
		INSERT INTO #tmpTrading(ApplicabilityMstId,UserInfoId,MapToId)
		EXEC st_tra_GetTradingPolicy
	
		----Start : When pre-clearance is Approved then, calculate and add a postdated "pre-clearance expiry" event based upon trading policy applicable to user
			IF(EXISTS(SELECT EventLogId From eve_EventLog WHERE UserInfoId = @nUserInfoId AND MapToTypeCodeId = @nMapToTypeCodeId AND MapToId = @nMapToId AND EventCodeId = @nEventCodeID_PreClearanceRequested))
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
						 AND EL.EventCodeId IN (@nEventCodeID_PreClearanceRequested)
						 AND PR.UserInfoId= @nUserInfoId
						 AND PR.PreclearanceRequestId = @nMapToId
						 AND TW.TradingWindowStatusCodeId = @nTradingWindow_Active
						
				--GET WINDOWS CLOSE DATE ACCORDING TO FINANCIAL YEAR	
			   	INSERT INTO #TempFinancialYearParameters(MapToId,EventDate,ValidityLimit)
				SELECT DISTINCT EL.MapToId,EL.EventDate,@TradingPolicyPreClrApprovalValidityLimit 
				FROM eve_EventLog EL
					JOIN tra_PreclearanceRequest PR ON PR.PreclearanceRequestId=@nMapToId
					JOIN rul_TradingPolicy TP ON TP.TradingPolicyId = @nTradingPolicyId
					WHERE EL.UserInfoId=@nUserInfoId
						 AND EL.MapToId = @nMapToId
						 AND EL.MapToTypeCodeId = @nMapToTypeCodeId 
						 AND EL.EventCodeId IN(@nEventCodeID_PreClearanceRequested)
					
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

					SELECT @dtPreClearanceExpiryDate=CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysWithWinCloseDate(dbo.uf_com_GetServerDate(),@TradingPolicyPreClrApprovalValidityLimit,null,0,1,0,@nExchangeTypeCodeId_NSE,@nEventType,@nWindowCloseDate)) 

					SET @out_PreclearanceValidityDate = @dtPreClearanceExpiryDate
					SET @out_nReturnValue = 0
					
			END

		 	DROP TABLE #TempOtherParameters
	        DROP TABLE #TempFinancialYearParameters
	        DROP TABLE #TempParameters
	        DROP TABLE #tmpTrading
		   RETURN @out_nReturnValue

		END	TRY
	
	   BEGIN CATCH				
		  SET @out_nSQLErrCode    =  ERROR_NUMBER()
		  SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		  SET @out_nReturnValue	=  @ERR_GetPreclearanceValidityDate
	   END CATCH
	END
		
	
