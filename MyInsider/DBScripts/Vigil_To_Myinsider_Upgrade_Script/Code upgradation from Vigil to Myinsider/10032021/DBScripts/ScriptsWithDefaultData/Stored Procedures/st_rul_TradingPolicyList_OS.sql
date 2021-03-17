

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicyList_OS')
DROP PROCEDURE [dbo].[st_rul_TradingPolicyList_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list current version of Trading Policies.

Returns:		0, if Success.
				
Created by:		Rajashri Sathe
Created on:		12-Des-2019

Modification History:
Modified By		Modified On		Description


Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rul_TradingPolicyList_OS]
	@inp_iPageSize			INT = 10
	,@inp_iPageNo			INT = 1
	,@inp_sSortField		VARCHAR(255)
	,@inp_sSortOrder		VARCHAR(5)
	,@inp_sTradingPolicyName	NVARCHAR(100)
	,@inp_dtApplicableFrom	VARCHAR(25)
	,@inp_dtApplicableTo	VARCHAR(25)
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN

	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_TRADINGPOLICY_LIST INT = 55146 -- Error occurred while fetching trading policy list. (While fetching list of Current Version of Trading Policies) .
	DECLARE @dtDefault DATETIME = CONVERT(DATETIME, '')
	
	DECLARE @nCurrentHistoryCodeId INTEGER = 134001 /*CodeID to denote records which are Current records and not History records*/

	
	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF (@inp_dtApplicableFrom IS NULL OR @inp_dtApplicableFrom = '' OR CAST(@inp_dtApplicableFrom AS DATETIME) = @dtDefault )
			SET @inp_dtApplicableFrom = NULL
		
		IF (@inp_dtApplicableTo IS NULL OR @inp_dtApplicableTo = '' OR CAST(@inp_dtApplicableTo AS DATETIME) = @dtDefault )
			SET @inp_dtApplicableTo = NULL
			
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'TP.TradingPolicyName '
		END 			
		
		IF @inp_sSortField = 'rul_grd_55089' -- Trading policy name
		BEGIN 
			SELECT @inp_sSortField = 'TP.TradingPolicyName  ' 
		END
		
		IF @inp_sSortField = 'rul_grd_55090' -- Applicable from date
		BEGIN 
			SELECT @inp_sSortField = 'TP.ApplicableFromDate ' 
		END		
		
		IF @inp_sSortField = 'rul_grd_55091' -- Applicable to date
		BEGIN 
			SELECT @inp_sSortField = 'TP.ApplicableToDate ' 
		END	
		
		IF @inp_sSortField = 'rul_grd_55092' -- Applicable To
		BEGIN 
			SELECT @inp_sSortField = 'CdTPFor.CodeName ' 
		END	
		
		IF @inp_sSortField = 'rul_grd_55093' -- Status
		BEGIN 
			SELECT @inp_sSortField = 'CdTPStatus.CodeName ' 
		END	
		
		print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',TP.TradingPolicyId) ,TP.TradingPolicyId '
		SELECT @sSQL = @sSQL + ' FROM rul_TradingPolicy_OS TP INNER JOIN com_Code CdTPStatus ON TP.TradingPolicyStatusCodeId = CdTPStatus.CodeID '
		SELECT @sSQL = @sSQL + ' INNER JOIN com_Code CdTPFor ON TP.TradingPolicyForCodeId = CdTPFor.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE 1=1 '
		SELECT @sSQL = @sSQL + ' AND TP.IsDeletedFlag = 0 '--fetch non-deleted records only
		SELECT @sSQL = @sSQL + ' AND TP.CurrentHistoryCodeId = ' + CAST(@nCurrentHistoryCodeId AS VARCHAR(20)) + ' '
		
		--TradingPolicyName filter
		IF (@inp_sTradingPolicyName IS NOT NULL AND @inp_sTradingPolicyName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND TP.TradingPolicyName LIKE N''%' + @inp_sTradingPolicyName + '%'' '
		END
		
		--@inp_dtApplicableFrom, @inp_dtApplicableTo filters
		IF (@inp_dtApplicableFrom IS NOT NULL OR @inp_dtApplicableTo IS NOT NULL)
		BEGIN
			/*Input from-date should be less than input to-date*/
			--IF (@inp_dtApplicableFrom IS NOT NULL AND @inp_dtApplicableTo IS NOT NULL) 
			--BEGIN
			--	SELECT @sSQL = @sSQL + ' AND  CAST(''' + CAST(@inp_dtApplicableFrom AS VARCHAR(25)) + ''' AS DATETIME) <= '
			--	SELECT @sSQL = @sSQL  + ' CAST(''' + CAST(@inp_dtApplicableTo AS VARCHAR(25)) + ''' AS DATETIME) '
			--END
		
			SELECT @sSQL = @sSQL + ' AND ( '
			IF (@inp_dtApplicableFrom IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' (TP.ApplicableFromDate >= CAST('''  + CAST(@inp_dtApplicableFrom AS VARCHAR(25)) + ''' AS DATETIME))'
				--SELECT @sSQL = @sSQL + ' AND (TP.ApplicableToDate IS NULL OR TP.ApplicableToDate >= CAST('''  + CAST(@inp_dtApplicableFrom AS VARCHAR(25)) + '''AS DATETIME) ) )'
			END
			
			IF (@inp_dtApplicableFrom IS NOT NULL AND @inp_dtApplicableTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' AND '
			END
			
			IF (@inp_dtApplicableTo IS NOT NULL)
			BEGIN
				--SELECT @sSQL = @sSQL + ' (TP.ApplicableFromDate >= CAST('''  + CAST(@inp_dtApplicableTo AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + '  (TP.ApplicableToDate <= CAST('''  + CAST(@inp_dtApplicableTo AS VARCHAR(25)) + ''' AS DATETIME)  )'
			END
			
			IF (@inp_dtApplicableFrom IS NOT NULL AND @inp_dtApplicableTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' OR ( CAST (''' + CAST(@inp_dtApplicableFrom AS VARCHAR(25)) + ''' AS DATETIME) <= TP.ApplicableFromDate '
				SELECT @sSQL = @sSQL + ' AND (CAST ('''  + CAST(@inp_dtApplicableTo AS VARCHAR(25)) + ''' AS DATETIME) >= TP.ApplicableToDate)) '
			END
			
			SELECT @sSQL = @sSQL + ' )'
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)
		
		SELECT	TP.TradingPolicyId AS TradingPolicyId, 
		TP.TradingPolicyName AS rul_grd_55089 /*[Policy Name]*/,
		TP.ApplicableFromDate AS rul_grd_55090 /*[Applicable From Date]*/,
		TP.ApplicableToDate AS rul_grd_55091 /*[Applicable To Date]*/,
		CdTPFor.CodeName AS rul_grd_55092 /*[Applicable To]*/,
		CdTPStatus.CodeName AS rul_grd_55093 /*[Status]*/
		FROM	#tmpList T INNER JOIN rul_TradingPolicy_OS TP ON T.EntityID = TP.TradingPolicyId
				INNER JOIN com_Code CdTPStatus ON TP.TradingPolicyStatusCodeId = CdTPStatus.CodeID
				INNER JOIN com_Code CdTPFor ON TP.TradingPolicyForCodeId = CdTPFor.CodeID
		WHERE	1=1 
		AND TP.CurrentHistoryCodeId = @nCurrentHistoryCodeId /*fetch only the Current record and not the History record*/
		AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TRADINGPOLICY_LIST
	END CATCH
END
GO


