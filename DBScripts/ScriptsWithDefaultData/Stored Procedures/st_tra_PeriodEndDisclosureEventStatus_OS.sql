IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosureEventStatus_OS')
DROP PROCEDURE st_tra_PeriodEndDisclosureEventStatus_OS
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************
Description:	Procedure to get each period event status for period end disclosure 

Returns:		Return 0, if success.
				
Created by:		Priyanka
Created on:		12-Aug-2019
******************************************************************************************************************/
CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosureEventStatus_OS]
	@out_nReturnValue 		INT = 0 OUTPUT,
	@out_nSQLErrCode 		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_PERIODENDDISCLOSURE_STATUS_LIST INT = 17052
BEGIN TRY
		SET NOCOUNT ON;
	
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			SELECT distinct TransactionMasterId, TM.UserInfoId, TM.PeriodEndDate, TM.SoftCopyReq, TM.HardCopyReq,
			CASE WHEN ELSubmit.MapToId IS NOT NULL THEN (CASE WHEN ELSubmit.EventCode = 153063 THEN 2 ELSE 1 END) ELSE 0 END AS DetailsSubmitStatus,
			CASE WHEN ELSubmit.MapToId IS NOT NULL THEN ELSubmit.EventDate ELSE NULL END AS DetailsSubmitDate,
			CASE WHEN ELSCpSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS ScpSubmitStatus,
			CASE WHEN ELSCpSubmit.MapToId IS NOT NULL THEN ELSCpSubmit.EventDate ELSE NULL END AS ScpSubmitDate,
			CASE WHEN ELHCpSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS HcpSubmitStatus,
			CASE WHEN ELHCpSubmit.MapToId IS NOT NULL THEN ELHCpSubmit.EventDate ELSE NULL END AS HcpSubmitDate
			FROM tra_TransactionMaster_OS TM 
			JOIN tra_UserPeriodEndMapping_OS UPEMap ON UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId
			JOIN rul_TradingPolicy_OS TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
			LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate, MIN(EventCodeId) AS EventCode FROM eve_EventLog WHERE EventCodeId IN (153062, 153063) GROUP BY MapToId) ELSubmit ON TM.TransactionMasterId = ELSubmit.MapToId
			LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId  = 153064 GROUP BY MapToId) ELSCpSubmit ON TM.TransactionMasterId = ELSCpSubmit.MapToId
			LEFT JOIN (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId = 153065 GROUP BY MapToId) ELHCpSubmit ON TM.TransactionMasterId = ELHCpSubmit.MapToId
			WHERE DisclosureTypeCodeId = 147003
END TRY
BEGIN CATCH
	SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PERIODENDDISCLOSURE_STATUS_LIST
END CATCH
END