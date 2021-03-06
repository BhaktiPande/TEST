IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicyDelete_OS')
DROP PROCEDURE [dbo].[st_rul_TradingPolicyDelete_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* ======================================================================================================

--Description:	Marks the Trading Policy identified by input ID as Deleted.

-- Author      :Rajashri Sathe
-- CREATED DATE: 12-Des-2019
-- Description : Script for Trading Policy  Other securitie Delete

--Usage:
--DECLARE @RC int
--EXEC st_rul_TradingPolicyDelete 1

-- ======================================================================================================*/

CREATE PROCEDURE [dbo].[st_rul_TradingPolicyDelete_OS]
	-- Add the parameters for the stored procedure here
	@inp_iTradingPolicyId		INT,							-- Id of the Trading Policy which is to be deleted.
	@inp_nUserId				INT ,							-- Id of user marking the trading policy as deleted.	
	@out_nReturnValue			INT = 0 OUTPUT,		
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TRADINGPOLICY_NOTFOUND INT
	DECLARE @ERR_TRADINGPOLICY_DELETE INT
	DECLARE @ERR_TRADINGPOLICY_DELETE_PRE_TRANSACTION_FOUND	INT
	DECLARE @ERR_TRADINGPOLICY_DELETE_TRANSACTION_FOUND INT
	DECLARE @ERR_TRADINGPOLICY_DELETE_ASSOCIATED_WITH_POLICYDOC INT
		
	DECLARE @nTPStatusInActive					INT
	
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

		--Initialize variables
		SELECT	@ERR_TRADINGPOLICY_NOTFOUND = 55098, --Trading Policy does not exist.
				@ERR_TRADINGPOLICY_DELETE = 55142,		--Error occurred while deleting trading policy.				
				@ERR_TRADINGPOLICY_DELETE_ASSOCIATED_WITH_POLICYDOC = 55144,	--Cannot delete trading policy because employee associated with this trading policy has already started initial disclosure submission process
				@ERR_TRADINGPOLICY_DELETE_TRANSACTION_FOUND = 55145,	--Cannot delete trading policy because some transactions found related to this trading policy
				@ERR_TRADINGPOLICY_DELETE_PRE_TRANSACTION_FOUND=55143, --- Cannot delete trading policy because some transactions found related to previous version of this trading policy
				@nTPStatusInActive = 141001	--Trading policy In Active status codeId
	
	

		--Check if the Trading Policy being deleted exists
		IF (NOT EXISTS(SELECT TradingPolicyId FROM rul_TradingPolicy_OS WHERE TradingPolicyId = @inp_iTradingPolicyId))			
			BEGIN	
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_NOTFOUND
				RETURN (@out_nReturnValue)
			END
		
		CREATE TABLE #tmpUserDetails
		(
		ID INT IDENTITY(1,1),
		ApplicabilityMstId INT,
		Userinfoid INT,
		maptoid INT
		)
		INSERT INTO #tmpUserDetails
		SELECT * FROM [dbo].[vw_ApplicableTradingPolicyForUser_OS] 
		
		CREATE TABLE #tmpUser
		(
			ID INT IDENTITY(1,1),
			UserInfoId INT
		)
		INSERT INTO  #tmpUser
		SELECT Userinfoid FROM #tmpUserDetails WHERE maptoid=@inp_iTradingPolicyId
		
		DECLARE @nCount INT=0
		DECLARE @nTotCount INT=0
		SELECT @nTotCount=COUNT(ID) FROM #tmpUser
		WHILE @nCount<@nTotCount
		BEGIN
			DECLARE @nUserinfiID INT=0
			SELECT @nUserinfiID=UserInfoId FROM #tmpUser WHERE ID=@nCount+1
			IF NOT Exists(SELECT TransactionMasterId FROM tra_TransactionMaster_OS WHERE UserInfoId=@nUserinfiID)
			BEGIN
				IF EXISTS(SELECT EventLogId FROM eve_EventLog WHERE UserInfoId=@nUserinfiID AND EventCodeId IN(153027,153028))
				BEGIN				
					SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_ASSOCIATED_WITH_POLICYDOC
					RETURN (@out_nReturnValue)
					BREAK
				END
			END
			SET @nCount=@nCount+1
		END
		DROP TABLE #tmpUserDetails
		DROP TABLE #tmpUser
		
		DECLARE @nParentTPId INT=0		
		SELECT @nParentTPId=TradingPolicyParentId FROM rul_TradingPolicy_OS WHERE TradingPolicyId=@inp_iTradingPolicyId

		IF EXISTS (SELECT TransactionMasterId FROM tra_TransactionMaster_OS WHERE TradingPolicyId=@inp_iTradingPolicyId)
		BEGIN					
			SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_TRANSACTION_FOUND
			RETURN (@out_nReturnValue)
		END

		IF EXISTS (SELECT TransactionMasterId FROM tra_TransactionMaster_OS WHERE TradingPolicyId=@nParentTPId)
		BEGIN					
			SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_PRE_TRANSACTION_FOUND
			RETURN (@out_nReturnValue)
		END
				
		UPDATE rul_TradingPolicy_OS
		SET IsDeletedFlag = 1,TradingPolicyStatusCodeId=@nTPStatusInActive, ModifiedBy = @inp_nUserId, ModifiedOn = dbo.uf_com_GetServerDate()
		WHERE TradingPolicyId = @inp_iTradingPolicyId	 

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_TRADINGPOLICY_DELETE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
