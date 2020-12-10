IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_PendingTransactionforSecurityTransfer')
DROP PROCEDURE [dbo].[st_usr_PendingTransactionforSecurityTransfer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure used for check previous incomplete and pending transactions for transfer balance.

Returns:		0, if Success.
				
Created by:		Tushar
Created on:		7-June-2018
Usage:
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_PendingTransactionforSecurityTransfer]
	@inp_iUserInfoId						    INT,
	@out_PendingPeriodEndCount					INT = 0 OUTPUT,
	@out_PendingTransactionsCountPNT	        INT = 0 OUTPUT,
	@out_PendingTransactionsCountPCL	        INT = 0 OUTPUT,
	@out_nReturnValue						    INT = 0 OUTPUT,
	@out_nSQLErrCode						    INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage						    NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @ERR_PENDINGTRANSACTIONEXISTS INT = 11467		-- You cannot transfer the securities, From and To Demat account number have some incomplete and pending transactions.
    DECLARE @ERR_TransferBalanceLogValidation INT = 11457 -- Error occurred while securities transfer validation.
    DECLARE @ERR_LASTPERIODENDNOTSUBMITTED INT = 11470		-- You cannot transfer the securities, previous period end is not submitted.
    DECLARE @nTransactionStatusNoSubmitted INT = 148002 
	BEGIN TRY
		
		SET NOCOUNT ON;

    	--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
			
		SELECT @out_PendingPeriodEndCount = COUNT(TransactionMasterId)
		FROM tra_TransactionMaster
		WHERE UserInfoId = @inp_iUserInfoID AND DisclosureTypeCodeId = 147003 AND TransactionStatusCodeId <= 148002 
		
			
        SELECT @out_PendingTransactionsCountPNT = COUNT(TM.TransactionMasterId )
						FROM tra_TransactionDetails TD
						JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
						WHERE (ForUserInfoId = @inp_iUserInfoId OR ForUserInfoId IN (SELECT UR.UserInfoIdRelative FROM usr_UserRelation UR JOIN usr_UserInfo UI ON UI.UserInfoId = UR.UserInfoId WHERE UI.UserInfoId = @inp_iUserInfoId))
						AND TM.TransactionStatusCodeId = @nTransactionStatusNoSubmitted 
						AND TD.SecurityTypeCodeId IN(139001,139002,139003,139004,139005) AND TM.PreclearanceRequestId IS NULL
			
			
         SELECT @out_PendingTransactionsCountPCL = COUNT(PreclearanceRequestId) 
					FROM tra_PreclearanceRequest
					WHERE IsPartiallyTraded = 1 AND (UserInfoId = @inp_iUserInfoId OR UserInfoIdRelative IN (SELECT UR.UserInfoIdRelative FROM usr_UserRelation UR JOIN usr_UserInfo UI ON UI.UserInfoId = UR.UserInfoId WHERE UI.UserInfoId = @inp_iUserInfoId)) 
								AND SecurityTypeCodeId IN(139001,139002,139003,139004,139005)
								AND PreclearanceStatusCodeId <> 144003
								AND ReasonForNotTradingCodeId IS NULL
								
	    SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END TRY
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_TransferBalanceLogValidation, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
	
END
			