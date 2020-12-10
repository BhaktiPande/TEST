IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_InitialDisclosureDashBoardForCO')
DROP PROCEDURE [dbo].[st_tra_InitialDisclosureDashBoardForCO]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to Insider Count.

Returns:		0, if Success.
				
Created by:		Ashish
Created on:		12-JUNE-2015

Modification History:
Modified By		Modified On		Description
Ashish			13-JUNE-2015	Change the query for fetching count for insiders
Tushar			09-Jul-2015		Change query for fetching count for Disclosure
Arundhati		28-Jul-2015		Do not consider Document uploaded status while counting soft copy count
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
EXEC st_mst_CompanyList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_InitialDisclosureDashBoardForCO]
	@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @nInsiderCount1 INT = 153007
	DECLARE @nInsiderCount2 INT = 153008
	DECLARE @nInsiderSoftCopy_Submitted INT = 153009
	DECLARE @nInsiderHardCopy_Submitted INT = 153010
	
	DECLARE @nInsiderInitialDisclosureCount INT = 0
	DECLARE @nSoftCopyPendingCount INT = 0
	DECLARE @nHardCopyPendingCount INT = 0
	DECLARE @nSoftCopySubmittedCount INT
	DECLARE @nHardCopySubmittedCount INT = 0

	DECLARE @tmpInsiderInitialDisclosureTable TABLE(InsiderCount INT, SoftCopyPendingCount INT, HardCopyPendingCount INT, SoftCopySubmittedCount INT, HardCopySubmittedCount INT)
	
	DECLARE @tmpTra TABLE(TransactionMasterID INT,SoftCOpyRequired BIT,SoftCopySubmissionFlag BIT,HardCopyFlag BIT,
						  HardCopySubmissionflg BIT,DisclosureCompletion BIT)
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		/*
		SELECT @nInsiderInitialDisclosureCount = COUNT(UserInfoId) 
		FROM usr_UserInfo
		WHERE DateOfBecomingInsider IS NOT NULL AND DateOfBecomingInsider <= dbo.uf_com_GetServerDate()

		SELECT @nSoftCopySubmittedCount = COUNT(DISTINCT UserInfoId) 
		FROM eve_eventlog
		WHERE EventCodeId = @nInsiderSoftCopy_Submitted

		SELECT @nHardCopySubmittedCount = COUNT(DISTINCT UserInfoId) 
		FROM eve_eventlog
		WHERE EventCodeId = @nInsiderHardCopy_Submitted
		
		SET @nSoftCopyPendingCount = @nInsiderInitialDisclosureCount - @nSoftCopySubmittedCount
		SET @nHardCopyPendingCount = @nInsiderInitialDisclosureCount - @nHardCopySubmittedCount
		
		INSERT INTO @tmpInsiderInitialDisclosureTable(InsiderCount, SoftCopyPendingCount, HardCopyPendingCount, SoftCopySubmittedCount, HardCopySubmittedCount)
		VALUES(@nInsiderInitialDisclosureCount, @nSoftCopyPendingCount, @nHardCopyPendingCount, @nSoftCopySubmittedCount, @nHardCopySubmittedCount)

		select * from @tmpInsiderInitialDisclosureTable */
		
		
		INSERT INTO @tmpTra (TransactionMasterID,SoftCOpyRequired,HardCopyFlag)
		SELECT TM.TransactionMasterId,TM.SoftCopyReq,TM.HardCopyReq
		FROM tra_TransactionMaster TM
		WHERE DisclosureTypeCodeId = 147001
		
		SELECT @nInsiderInitialDisclosureCount = COUNT(UserInfoId) 
		FROM usr_UserInfo
		WHERE DateOfBecomingInsider IS NOT NULL AND DateOfBecomingInsider <= dbo.uf_com_GetServerDate()
		
		update t
		SET DisclosureCompletion = CASE WHEN EL.EventLogId IS NULL THEN 0 ELSE 1 END
		FROM @tmpTra t 
		JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
		AND EL.EventCodeId IN (153007/*,153008*/) 
		AND MapToTypeCodeId = 132005
		--JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		--WHERE t.SoftCOpyRequired = 1
		
		UPDATE t
		SET SoftCopySubmissionFlag = CASE WHEN EL.EventLogId IS NULL THEN 0 ELSE 1 END
		FROM @tmpTra t 
		LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
		AND EL.EventCodeId IN (153009) 
		AND MapToTypeCodeId = 132005
		--JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		WHERE t.SoftCOpyRequired = 1 AND DisclosureCompletion = 1
		
		UPDATE t
		SET HardCopySubmissionflg = CASE WHEN EL.EventLogId IS NULL THEN 0 ELSE 1 END
		FROM @tmpTra t 
		LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
		AND EL.EventCodeId IN (153010) 
		AND MapToTypeCodeId = 132005
		JOIN tra_TransactionMaster TM ON t.TransactionMasterID = TM.TransactionMasterId
		WHERE TM.HardCopyReq = 1 AND t.SoftCopySubmissionFlag = 1
		
		
		SELECT @nSoftCopySubmittedCount = COUNT(TransactionMasterID) FROM @tmpTra WHERE SoftCopySubmissionFlag = 1
		SELECT @nSoftCopyPendingCount = COUNT(TransactionMasterID) FROM @tmpTra WHERE SoftCopySubmissionFlag = 0
		SELECT @nHardCopySubmittedCount = COUNT(TransactionMasterID) FROM @tmpTra WHERE HardCopySubmissionflg = 1
		SELECT @nHardCopyPendingCount = COUNT(TransactionMasterID) FROM @tmpTra WHERE HardCopySubmissionflg = 0
		
		INSERT INTO @tmpInsiderInitialDisclosureTable(InsiderCount, SoftCopyPendingCount, HardCopyPendingCount, SoftCopySubmittedCount, HardCopySubmittedCount)
		VALUES(@nInsiderInitialDisclosureCount, @nSoftCopyPendingCount, @nHardCopyPendingCount, @nSoftCopySubmittedCount, @nHardCopySubmittedCount)

		SELECT * FROM @tmpInsiderInitialDisclosureTable
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  ''
	END CATCH
END