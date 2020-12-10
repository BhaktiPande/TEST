IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceRequestApproveRejectSave_OS')
DROP PROCEDURE [dbo].[st_tra_PreclearanceRequestApproveRejectSave_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[st_tra_PreclearanceRequestApproveRejectSave_OS] 
	@inp_tblPreClearanceList	        PreClearanceListType READONLY,
	@inp_tblPreclearanceRequestId         PreClearanceIDType READONLY,
	@inp_nPreclearanceNotTakenFlag	    BIT,
	@inp_iReasonForNotTradingCodeId		INT,
	@inp_sReasonForNotTradingText		VARCHAR(30),
	@inp_nUserId						INT,
	@inp_iPreclearanceStatusCodeId      INT,
	@inp_sReasonForRejection			VARCHAR(200),
	@inp_sReasonForApproval				VARCHAR(200),
	@inp_iReasonForApprovalCodeId		INT,
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @nCounter INT = 1
	DECLARE @nCount INT
	DECLARE @nPreclearanceRequestID INT
	DECLARE @nDisplaySequenceNo INT 
	CREATE TABLE #tempPreclearanceID(ID INT IDENTITY(1,1),PreclearanceID INT,DisplaySequenceNo INT)
	DECLARE @ERR_PRECLEARANCEREQUEST_SAVE_ERROR	INT = 17512
BEGIN TRY

	INSERT INTO #tempPreclearanceID
	SELECT * FROM @inp_tblPreclearanceRequestId
	
	SET @nCount = (SELECT COUNT(*) FROM #tempPreclearanceID)
	WHILE @nCounter <= @nCount
	BEGIN
		SELECT @nPreclearanceRequestID = PreclearanceID FROM #tempPreclearanceID WHERE ID = @nCounter
		SELECT @nDisplaySequenceNo = DisplaySequenceNo FROM #tempPreclearanceID WHERE ID = @nCounter
		EXEC st_tra_PreclearanceRequestSave_OS @inp_tblPreClearanceList, @nPreclearanceRequestID, @inp_nPreclearanceNotTakenFlag, NULL, NULL, @inp_nUserId, @inp_iPreclearanceStatusCodeId,
		@inp_sReasonForRejection, @inp_sReasonForApproval, @inp_iReasonForApprovalCodeId,@nDisplaySequenceNo, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
	
		SET @nCounter = @nCounter + 1
	END
END TRY
BEGIN CATCH
	SET @out_nSQLErrCode    =  ERROR_NUMBER()
	SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
	SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_PRECLEARANCEREQUEST_SAVE_ERROR, ERROR_NUMBER())
	print @out_sSQLErrMessage
	RETURN @out_nReturnValue
END CATCH
END