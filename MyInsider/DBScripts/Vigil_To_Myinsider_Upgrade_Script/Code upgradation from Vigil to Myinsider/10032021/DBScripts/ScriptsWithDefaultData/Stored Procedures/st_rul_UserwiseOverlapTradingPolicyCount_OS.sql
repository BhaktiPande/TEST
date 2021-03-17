IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_UserwiseOverlapTradingPolicyCount_OS')
DROP PROCEDURE [dbo].[st_rul_UserwiseOverlapTradingPolicyCount_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to check if any overlapping Trading Policies exist for the users defined for the trading policy being edited(denoted by @inp_nTradingPolicyId).

Returns:		0, if Success.
				
Created by:		Rajashri
Created on:		12-Des-2019


Usage:
EXEC st_rul_UserwiseOverlapTradingPolicyCount_OS 10, 1, '','ASC', 4
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rul_UserwiseOverlapTradingPolicyCount_OS]
	 @inp_nTradingPolicyId	INT 
	,@out_nCountUserAndOverlapTradingPolicy INT = 0 OUTPUT
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	

AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @dtApplicableFromDate DATETIME
	DECLARE @dtApplicabltToDate DATETIME
	DECLARE @nUserTypeCodeIdRelative INT = 101007
	DECLARE @nUserTypeCodeIdCorporate INT = 101004
	
	DECLARE @nTradingPolicyCurrentCodeId INT = 134001
	DECLARE @nTradingPolicyStatusActiveCodeId INT = 141002
	
	DECLARE @nCountUserAndOverlapTradingPolicy INT = 0
	
	DECLARE @ERR_COUNT_USERWISE_OVERLAP_TRADINGPOLICY INT = 15406

	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		DECLARE @tmpCurrentTradingPolicyUsers TABLE (ID INT IDENTITY(1,1), UserInfoId INT)
		DECLARE @tmpOverlapTradingPolicies TABLE (ID INT IDENTITY(1,1), TradingPolicyId INT)
		DECLARE @tmpUserwiseOverlapTP TABLE (ID INT IDENTITY(1,1), UserInfoId INT, TradingPolicyId INT)
		
		--Fetch the applicable dates for current traing policy
		SELECT @dtApplicableFromDate = ApplicableFromDate, @dtApplicabltToDate = ApplicableToDate 
		FROM rul_TradingPolicy_OS WHERE TradingPolicyId = @inp_nTradingPolicyId

		--SELECT @dtApplicableFromDate, @dtApplicabltToDate
		
		--Get users for trading policy denoted by @inp_nTradingPolicyId 
		INSERT INTO @tmpCurrentTradingPolicyUsers(UserInfoId)
		SELECT UserInfoId from vw_ApplicableTradingPolicyForUser_OS 
		WHERE MapToId = @inp_nTradingPolicyId
		ORDER BY UserInfoId

		--SELECT 'Users for trading policy # ' + CAST(@inp_nTradingPolicyId AS VARCHAR(20))
		--SELECT * FROM @tmpCurrentTradingPolicyUsers

		
		--Get trading policies which have overlapping dates with dates of input trading policy
		INSERT INTO @tmpOverlapTradingPolicies(TradingPolicyId)
		SELECT TradingPolicyId
		FROM rul_TradingPolicy_OS TP
		WHERE IsDeletedFlag = 0 
		AND TP.CurrentHistoryCodeId = @nTradingPolicyCurrentCodeId
		AND TP.TradingPolicyStatusCodeId = @nTradingPolicyStatusActiveCodeId
		AND TP.ApplicableFromDate <= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))
		AND TP.ApplicableToDate >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))
		AND 
		(
			(TP.ApplicableFromDate <= @dtApplicableFromDate AND TP.ApplicableToDate >= @dtApplicableFromDate) OR
			(TP.ApplicableFromDate <= @dtApplicabltToDate AND TP.ApplicableToDate >= @dtApplicabltToDate) OR
			(@dtApplicableFromDate <= TP.ApplicableFromDate AND @dtApplicabltToDate >= TP.ApplicableToDate)
		) 
		AND TP.TradingPolicyId <> @inp_nTradingPolicyId
	
		--SELECT * FROM @tmpOverlapTradingPolicies
		/*Change done to first fint the employees in the overlapping policies and then use the temptable in the below query for optimising the query performance.*/
		SELECT * into #OverlappingUsers FROM @tmpOverlapTradingPolicies OTP  --TPForUser.MapToId = OTP.TradingPolicyId
		inner JOIN vw_ApplicableTradingPolicyForUser_OS TPForUser ON TPForUser.MapToId = OTP.TradingPolicyId 

		INSERT INTO @tmpUserwiseOverlapTP(UserInfoId, TradingPolicyId)
		SELECT CurrTPUsers.UserInfoId,1
		FROM @tmpCurrentTradingPolicyUsers CurrTPUsers
		INNER JOIN #OverlappingUsers OV on OV.UserInfoId = CurrTPUsers.UserInfoId
		INNER JOIN usr_UserInfo UI ON UI.UserInfoId = CurrTPUsers.UserInfoId AND UI.UserTypeCodeId <> @nUserTypeCodeIdRelative
		ORDER BY CurrTPUsers.UserInfoId

		--SELECT 'Overlap TP for users'
		--SELECT * FROM @tmpUserwiseOverlapTP
		
		SELECT @nCountUserAndOverlapTradingPolicy = COUNT(ISNULL(ID,0)) FROM @tmpUserwiseOverlapTP
		
		SELECT @out_nCountUserAndOverlapTradingPolicy = @nCountUserAndOverlapTradingPolicy
		
		--SELECT @nCountUserAndOverlapTradingPolicy
		
		RETURN 0	
		
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COUNT_USERWISE_OVERLAP_TRADINGPOLICY
	END CATCH
END