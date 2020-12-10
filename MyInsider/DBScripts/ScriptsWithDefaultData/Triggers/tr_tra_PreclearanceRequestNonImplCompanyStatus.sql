IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_tra_PreclearanceRequestNonImplCompanyStatus]'))
DROP TRIGGER [dbo].[tr_tra_PreclearanceRequestNonImplCompanyStatus]
GO

-- =============================================
-- Author:		Parag
-- Create date: 23-Sept-2016
-- Description:	Insert data in event table, when status changes, log the corresponding event

-- Edited By		Edited On			Description

-- =============================================

CREATE TRIGGER [dbo].[tr_tra_PreclearanceRequestNonImplCompanyStatus] ON [dbo].[tra_PreclearanceRequest_NonImplementationCompany]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @nEventCodeID INT
	DECLARE @nEventCodeIDPreClearanceExpiry INT
	DECLARE @nEventCodeID_PreClearanceRequested INT = 153045
	DECLARE @nEventCodeID_PreClearanceApproved INT = 153046
	DECLARE @nEventCodeID_PreClearanceRejected INT = 153047
	DECLARE @nEventCodeID_PreClearanceExpiry INT = 153067
	DECLARE @nExchangeTypeCodeId_NSE INT = 116001
	DECLARE @nMapToTypeCodeId INT = 132015 -- Preclearance - NonImplementing Company
	DECLARE @nMapToId INT
	DECLARE @nUserInfoId INT
	DECLARE @nModifiedBy INT
	
	DECLARE @nPreclearanceStatus_Requested INT = 144001
	DECLARE @nPreclearanceStatus_Approved INT = 144002
	DECLARE @nPreclearanceStatus_Rejected INT = 144003	

	DECLARE @nPreclearanceStatusNew INT, @nPreclearanceStatusOld INT
	DECLARE @nPreclearanceId INT
	DECLARE @nTradingPolicyId INT
	DECLARE @TradingPolicyPreClrApprovalValidityLimit INT
	DECLARE @dtPreClearanceExpiryDate DATETIME

	CREATE TABLE #GetTradingPolicyId_OS (nGetTradingPolicyId_OS INT)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--print 'trigger'
	SELECT * INTO #tmpValues_New FROM inserted
	SELECT * INTO #tmpValues_Old FROM deleted

	SELECT	@nPreclearanceStatusNew = PreclearanceStatusCodeId, 
			@nUserInfoId = UserInfoId,
			@nMapToId = PreclearanceRequestId,
			@nModifiedBy = ModifiedBy
	FROM #tmpValues_New
	
	SELECT	@nPreclearanceStatusOld = PreclearanceStatusCodeId
	FROM #tmpValues_Old

	INSERT INTO #GetTradingPolicyId_OS 
	EXEC st_tra_GetTradingPolicyIDfor_OS @nUserInfoId
	
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
				SELECT @nTradingPolicyId = (SELECT nGetTradingPolicyId_OS FROM #GetTradingPolicyId_OS)
				SELECT @TradingPolicyPreClrApprovalValidityLimit = PreClrApprovalValidityLimit FROM rul_TradingPolicy_OS where TradingPolicyId = ISNULL(@nTradingPolicyId,0)
				SELECT @TradingPolicyPreClrApprovalValidityLimit = ISNULL(@TradingPolicyPreClrApprovalValidityLimit,0)

				SELECT @dtPreClearanceExpiryDate=CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPreClerance_OS(dbo.uf_com_GetServerDate(),@TradingPolicyPreClrApprovalValidityLimit,null,0,1,0,@nExchangeTypeCodeId_NSE)) 
					print @dtPreClearanceExpiryDate
				INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
				VALUES(@nEventCodeIDPreClearanceExpiry, @dtPreClearanceExpiryDate, @nUserInfoId, @nMapToTypeCodeId, @nMapToId, @nModifiedBy)
			END
		END
	END

END
GO
