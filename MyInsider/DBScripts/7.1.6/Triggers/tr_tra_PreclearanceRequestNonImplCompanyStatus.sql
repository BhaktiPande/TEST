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

	DECLARE @nEventCodeID_PreClearanceRequested INT = 153045
	DECLARE @nEventCodeID_PreClearanceApproved INT = 153046
	DECLARE @nEventCodeID_PreClearanceRejected INT = 153047

	DECLARE @nMapToTypeCodeId INT = 132015 -- Preclearance - NonImplementing Company
	DECLARE @nMapToId INT
	DECLARE @nUserInfoId INT
	DECLARE @nModifiedBy INT
	
	DECLARE @nPreclearanceStatus_Requested INT = 144001
	DECLARE @nPreclearanceStatus_Approved INT = 144002
	DECLARE @nPreclearanceStatus_Rejected INT = 144003	

	DECLARE @nPreclearanceStatusNew INT, @nPreclearanceStatusOld INT
	DECLARE @nPreclearanceId INT
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--print 'trigger'
	SELECT * INTO #tmpValues_New FROM inserted
	SELECT * INTO #tmpValues_Old FROM deleted

	SELECT	@nPreclearanceStatusNew = PreclearanceStatusCodeId, 
			@nUserInfoId = UserInfoId,
			@nMapToId = DisplaySequenceNo,
			@nModifiedBy = ModifiedBy
	FROM #tmpValues_New
	
	SELECT	@nPreclearanceStatusOld = PreclearanceStatusCodeId
	FROM #tmpValues_Old
	
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
		END
		ELSE IF @nPreclearanceStatusNew = @nPreclearanceStatus_Rejected
		BEGIN
			SET @nEventCodeID = @nEventCodeID_PreClearanceRejected
		END
		
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
		VALUES(@nEventCodeID, dbo.uf_com_GetServerDate(), @nUserInfoId, @nMapToTypeCodeId, @nMapToId, @nModifiedBy)

	END

END
GO
