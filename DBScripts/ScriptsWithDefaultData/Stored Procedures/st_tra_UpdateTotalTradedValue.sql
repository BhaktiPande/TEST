/*
	Created By  :	Shubhangi Gurude
	Created On  :   23-October-2018
	Description :	This stored Procedure is used to update total trade value of previous records in transaction master table
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_UpdateTotalTradedValue')
	DROP PROCEDURE st_tra_UpdateTotalTradedValue
GO

CREATE PROCEDURE [dbo].[st_tra_UpdateTotalTradedValue]	 						
	 @out_nReturnValue			INT = 0 OUTPUT
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
		
		DECLARE @nCount INT=0
		DECLARE @nTotCount INT=0

		CREATE TABLE #tmpTransMaster
		(
		ID INT IDENTITY(1,1),
		TransId INT
		)
		INSERT #tmpTransMaster(TransId)
		SELECT TransactionMasterID FROM tra_TransactionMaster WHERE SoftCopyReq=1
		SELECT @nTotCount=count(ID) FROM #tmpTransMaster 


		WHILE @nCount<@nTotCount
		BEGIN

			DECLARE @TransactionMasterID	BIGINT=0
			SELECT @TransactionMasterID =TransId FROM #tmpTransMaster WHERE ID= @nCount+1 

			DECLARE @nTotTradeValue DECIMAL(10,0)=0
				
			CREATE TABLE #tmptransactionID
			(
			TMID BIGINT
			)			
			INSERT INTO #tmptransactionID
			EXEC st_tra_TransactionIdsForLetter @TransactionMasterID

			SELECT @nTotTradeValue=SUM(TD.Value) FROM tra_TransactionDetails TD JOIN #tmptransactionID transID
			ON TD.TransactionMasterId=transID.TMID	
			 
			UPDATE tra_TransactionMaster
			SET TotalTradeValue = @nTotTradeValue
			FROM tra_TransactionMaster TM where TM.TransactionMasterID=@TransactionMasterID
			DROP TABLE #tmptransactionID		
			SET @nCount=@nCount+1 

		END
		
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
