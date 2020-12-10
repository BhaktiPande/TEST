IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_DeletePendingPreRequest')
DROP PROCEDURE [dbo].[st_tra_DeletePendingPreRequest]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[st_tra_DeletePendingPreRequest] 	
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS

	DECLARE @nPeriodType INT	
	DECLARE @nYearCodeId INT
	DECLARE @nPeriodCodeId INT
	DECLARE @dtStartDate DATETIME
	DECLARE @dtEndDate DATETIME
	DECLARE @nTradingPolicyID INT
	DECLARE @nPreclearanceRequestId INT
	DECLARE @nIsProhibitPreClrFunctionalityApplicable INT=0
	DECLARE @nCount INT=0
	DECLARE @nTotCount INT=0
	DECLARE @inp_iUserInfoId INT=0
	DECLARE @nPreclearancePendingEvent INT=153015
	DECLARE @nPreclearanceRejectedEvent INT=153017
	
	CREATE TABLE #tmpUser (ID INT IDENTITY(1,1),UserInfoId BIGINT)
	INSERT INTO #tmpUser
	SELECT DISTINCT UserInfoId FROM tra_PreclearanceRequest WHERE PreclearanceStatusCodeId=144001	
	SELECT @nTotCount=COUNT(UserInfoId) FROM #tmpUser

	WHILE @nCount<@nTotCount
	BEGIN 
		SELECT @inp_iUserInfoId=UserInfoId FROM #tmpUser WHERE ID=@nCount+1
	
		CREATE TABLE #tmpTrading(ApplicabilityMstId INT,UserInfoId INT,MapToId INT)
		INSERT INTO #tmpTrading(ApplicabilityMstId,UserInfoId,MapToId)
		EXEC st_tra_GetTradingPolicy
		
		SELECT @nTradingPolicyID= ISNULL(MAX(MapToId), 0) 
		FROM #tmpTrading  
		WHERE UserInfoId = @inp_iUserInfoId
		DROP TABLE #tmpTrading	

		SELECT 
			@nPeriodType = CASE 
			WHEN TP.ProhibitPreClrForPeriod = 137001 THEN 123001 -- Yearly
			WHEN TP.ProhibitPreClrForPeriod = 137002 THEN 123003 -- Quarterly
			WHEN TP.ProhibitPreClrForPeriod = 137003 THEN 123004 -- Monthly
			WHEN TP.ProhibitPreClrForPeriod = 137004 THEN 123002 -- half yearly
			ELSE TP.DiscloPeriodEndFreq 
			END,
			@nIsProhibitPreClrFunctionalityApplicable=IsProhibitPreClrFunctionalityApplicable					  				
		FROM 
			rul_TradingPolicy TP 
		WHERE TP.TradingPolicyId = @nTradingPolicyID

		IF(@nIsProhibitPreClrFunctionalityApplicable=1)
		BEGIN
	
			DECLARE @dtPreclearanceDate DATETIME
			SELECT @dtPreclearanceDate=dbo.uf_com_GetServerDate()
	
			EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
			@nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT,@dtPreclearanceDate,@nPeriodType, 0, 
			@dtStartDate OUTPUT, @dtEndDate OUTPUT, 
			@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
	
			SELECT 
				@nPreclearanceRequestId=MAX(PreclearanceRequestId)
			FROM 
				tra_PreclearanceRequest 
			WHERE 
				UserInfoId=@inp_iUserInfoId AND PreclearanceStatusCodeId=144001 AND CreatedOn<@dtStartDate 
		print(@nPreclearanceRequestId)
			IF(@nPreclearanceRequestId<>0)
			BEGIN
				INSERT INTO tra_PendingPreRequestHistory
				SELECT * FROM tra_PreclearanceRequest 
				WHERE UserInfoId=@inp_iUserInfoId AND PreclearanceStatusCodeId=144001 AND CreatedOn<=@dtStartDate and PreclearanceRequestId=@nPreclearanceRequestId
			
				UPDATE tra_PreclearanceRequest SET PreclearanceStatusCodeId=144003
				WHERE PreclearanceRequestId=@nPreclearanceRequestId	

				EXECUTE st_tra_ExerciseBalancePoolUpdateDetails 
										132004,
										@nPreclearanceRequestId,
										NULL,
										@out_nReturnValue OUTPUT,
										@out_nSQLErrCode OUTPUT,
										@out_sSQLErrMessage OUTPUT
										
				DELETE FROM cmu_NotificationQueue WHERE UserId=@inp_iUserInfoId and EventLogId in(select EventLogId FROM eve_EventLog WHERE UserInfoId=@inp_iUserInfoId AND MapToId=@nPreclearanceRequestId	
				AND EventCodeId IN(@nPreclearancePendingEvent,@nPreclearanceRejectedEvent)AND UserInfoId=@inp_iUserInfoId)
				
				DELETE FROM eve_EventLog WHERE UserInfoId=@inp_iUserInfoId	AND MapToId=@nPreclearanceRequestId	
				AND EventCodeId IN(@nPreclearancePendingEvent,@nPreclearanceRejectedEvent)
				
				DELETE FROM tra_TransactionMaster WHERE PreclearanceRequestId=@nPreclearanceRequestId
				DELETE FROM tra_PreclearanceRequest WHERE PreclearanceRequestId=@nPreclearanceRequestId	
			
			END
		END		
		SET @nCount=@nCount+1
	
	END	
	DROP TABLE #tmpUser
	
	

	
		




