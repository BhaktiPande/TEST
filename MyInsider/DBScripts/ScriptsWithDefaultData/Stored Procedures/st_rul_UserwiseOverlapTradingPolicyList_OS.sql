IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_UserwiseOverlapTradingPolicyList_OS')
DROP PROCEDURE [dbo].[st_rul_UserwiseOverlapTradingPolicyList_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list overlapping Trading Policies if any exist for the users defined for the trading policy being edited(denoted by @inp_nTradingPolicyId) for other securities.

Returns:		0, if Success.
				
Created by:		Shubhangi
Created on:		23-Aug-2020

-------------------------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[st_rul_UserwiseOverlapTradingPolicyList_OS]
	@inp_iPageSize			INT = 10
	,@inp_iPageNo			INT = 1
	,@inp_sSortField		VARCHAR(255)
	,@inp_sSortOrder		VARCHAR(5)
	,@inp_nTradingPolicyId	INT 
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
	
	DECLARE @ERR_USERWISE_OVERLAP_TRADINGPOLICY_LIST INT = 15404

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
		CREATE TABLE #tmpUserwiseOverlapTP (ID INT IDENTITY(1,1), UserInfoId INT, TradingPolicyId INT)

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
		
		INSERT INTO #tmpUserwiseOverlapTP(UserInfoId, TradingPolicyId)
		SELECT CurrTPUsers.UserInfoId, OTP.TradingPolicyId
		FROM @tmpCurrentTradingPolicyUsers CurrTPUsers
		INNER JOIN vw_ApplicableTradingPolicyForUser_OS TPForUser ON CurrTPUsers.UserInfoId = TPForUser.UserInfoId
		INNER JOIN @tmpOverlapTradingPolicies OTP ON TPForUser.MapToId = OTP.TradingPolicyId
		ORDER BY CurrTPUsers.UserInfoId, OTP.TradingPolicyId

		--SELECT 'Overlap TP for users'
		--SELECT * FROM #tmpUserwiseOverlapTP

		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		
		--Set default sort order
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		--Set default sort field
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN UI.UserTypeCodeId = ' + CAST(@nUserTypeCodeIdCorporate AS VARCHAR(20)) + ' THEN UI.ContactPerson ELSE ISNULL(UI.FirstName, '''') + '' '' + ISNULL(UI.LastName, '''') END '
		END
		
		IF @inp_sSortField = 'rul_grd_55374' -- User ID
		BEGIN 
			SELECT @inp_sSortField = 'ISNULL(UI.EmployeeId, '''') ' 
		END
		
		IF @inp_sSortField = 'rul_grd_55375' -- UserType
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN CCUserType.DisplayCode IS NULL OR CCUserType.DisplayCode = '''' THEN CCUserType.CodeName ELSE CCUserType.DisplayCode END ' --CCUserType.CodeName
		END

		IF @inp_sSortField = 'rul_grd_55376' -- Name (Username)
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN UI.UserTypeCodeId = ' + CAST(@nUserTypeCodeIdCorporate AS VARCHAR(20)) + ' THEN Company.CompanyName ELSE ISNULL(UI.FirstName, '''') + '' '' + ISNULL(UI.LastName, '''') END '
		END
		
		IF @inp_sSortField = 'rul_grd_55377' -- TradingPolicyName
		BEGIN 
			SELECT @inp_sSortField = 'TP.TradingPolicyName ' 
		END
		
		IF @inp_sSortField = 'rul_grd_55378' -- ApplicableFromDate
		BEGIN 
			SELECT @inp_sSortField = 'TP.ApplicableFromDate ' 
		END
		
		IF @inp_sSortField = 'rul_grd_55379' -- ApplicableToDate
		BEGIN 
			SELECT @inp_sSortField = 'TP.ApplicableToDate ' 
		END
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UI.UserInfoId), UOTP.ID '
		SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UI '
		SELECT @sSQL = @sSQL + ' INNER JOIN #tmpUserwiseOverlapTP UOTP ON UI.UserInfoId = UOTP.UserInfoId AND UI.UserTypeCodeId <> ' + CAST(@nUserTypeCodeIdRelative AS VARCHAR(20))
		SELECT @sSQL = @sSQL + ' INNER JOIN rul_TradingPolicy_OS TP ON UOTP.TradingPolicyId = TP.TradingPolicyId '
		SELECT @sSQL = @sSQL + ' INNER JOIN com_Code CCUserType ON CCUserType.CodeID = UI.UserTypeCodeId '
		SELECT @sSQL = @sSQL + ' INNER JOIN mst_Company Company ON UI.CompanyId = Company.CompanyId '
		SELECT @sSQL = @sSQL + ' WHERE 1=1 '

		--PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT ISNULL(UI.EmployeeId, '') AS rul_grd_55374 --User ID
		, ISNULL(CCUserType.DisplayCode, CCUserType.CodeName) AS rul_grd_55375 --UserType
		,CASE WHEN UI.UserTypeCodeId = @nUserTypeCodeIdCorporate THEN Company.CompanyName ELSE ISNULL(UI.FirstName, '') + ' ' + ISNULL(UI.LastName, '') END AS rul_grd_55376 --Name (User's name)
		, TP.TradingPolicyName AS rul_grd_55377 --Trading Policy Name
		, TP.ApplicableFromDate AS rul_grd_55378 --Applicable From Date
		, TP.ApplicableToDate AS rul_grd_55379 --Applicable To Date
		FROM #tmpList T 
		INNER JOIN #tmpUserwiseOverlapTP UOTP ON T.EntityID = UOTP.ID
		INNER JOIN usr_UserInfo UI ON UI.UserInfoId = UOTP.UserInfoId AND UI.UserTypeCodeId <> @nUserTypeCodeIdRelative
		INNER JOIN rul_TradingPolicy_OS TP ON UOTP.TradingPolicyId = TP.TradingPolicyId
		INNER JOIN com_Code CCUserType ON CCUserType.CodeID = UI.UserTypeCodeId
		INNER JOIN mst_Company Company ON UI.CompanyId = Company.CompanyId
		WHERE	1=1 
		AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		RETURN 0	

		
		DROP TABLE #tmpUserwiseOverlapTP
		
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_USERWISE_OVERLAP_TRADINGPOLICY_LIST
	END CATCH
END