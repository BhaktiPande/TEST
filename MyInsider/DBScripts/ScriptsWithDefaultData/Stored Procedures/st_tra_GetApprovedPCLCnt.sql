IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetApprovedPCLCnt')
DROP PROCEDURE [dbo].[st_tra_GetApprovedPCLCnt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- EXEC [st_tra_GetApprovedPCLCnt] 2
CREATE PROCEDURE [dbo].[st_tra_GetApprovedPCLCnt] 
	 @inp_iUserInfoId			INT							
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_GETDETAILS INT = 50440 -- Error occurred while fetching code details.	
		
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT  ISNULL( COUNT(PR.PreclearanceRequestId),0)  AS ApprovedPCLCnt
		FROM		tra_PreclearanceRequest PR
		INNER JOIN	tra_TransactionMaster TM ON TM.PreclearanceRequestId=PR.PreclearanceRequestId
		LEFT JOIN	eve_EventLog EL ON EL.EventCodeId = 153016 AND  EL.MapToId = TM.TransactionMasterId
		WHERE		PR.UserInfoId=@inp_iUserInfoId AND PR.PreclearanceStatusCodeId = 144002 		
		AND PR.ReasonForNotTradingCodeId IS NULL and (IsPartiallyTraded=1 OR TM.TransactionStatusCodeId=148002)
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue	
		
	END CATCH
END
GO


