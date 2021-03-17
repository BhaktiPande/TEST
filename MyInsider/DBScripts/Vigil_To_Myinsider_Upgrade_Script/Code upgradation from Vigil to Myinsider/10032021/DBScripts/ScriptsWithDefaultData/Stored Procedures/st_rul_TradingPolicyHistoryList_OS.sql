
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicyHistoryList_OS')
DROP PROCEDURE [dbo].[st_rul_TradingPolicyHistoryList_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list history versions of Trading Policy identified by input ID.

Returns:		0, if Success.
				
Created by:		Rajashri Sathe
Created on:		12-Des-2019

Modification History:
Modified By		Modified On			Description


Usage:
EXEC st_rul_TradingPolicyHistoryList_OS
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rul_TradingPolicyHistoryList_OS]
	@inp_iPageSize			INT = 10
	,@inp_iPageNo			INT = 1
	,@inp_sSortField		VARCHAR(255)
	,@inp_sSortOrder		VARCHAR(5)
	,@inp_iTradingPolicyId	INT							--ID of the current trading policy for which history records are to be viewed.
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.	
AS
BEGIN

	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_TRADINGPOLICY_HISTORY_LIST INT = 55134		-- Error occurred while fetching list of History versions of a Trading Policy .
	DECLARE @ERR_TRADINGPOLICY_NOTFOUND	INT = 55098				-- Trading Policy does not exist.
	DECLARE	@nTradingPolicyParentId INT	= NULL
	
	DECLARE @nTPCurrentCodeId INTEGER = 134001 /*CodeID to denote records which are Current records*/
	DECLARE @nTPHistoryCodeId INTEGER = 134002 /*CodeID to denote records which are History records*/

	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		--Validate : Trading policy's current record exists within database
		IF ( NOT EXISTS(SELECT TradingPolicyId FROM rul_TradingPolicy_OS WHERE TradingPolicyId = @inp_iTradingPolicyId AND CurrentHistoryCodeId = @nTPCurrentCodeId) )
		BEGIN	
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_NOTFOUND
				RETURN (@out_nReturnValue)
		END
		
		--Fetch parent Id of trading policy's current record
		SELECT @nTradingPolicyParentId = TradingPolicyParentId 
		FROM rul_TradingPolicy_OS 
		WHERE TradingPolicyId = @inp_iTradingPolicyId AND CurrentHistoryCodeId = @nTPCurrentCodeId
		print @nTradingPolicyParentId
		
		IF (@nTradingPolicyParentId IS NOT NULL AND @nTradingPolicyParentId > 0)
		BEGIN
			SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


			IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
			BEGIN 
				SELECT @inp_sSortOrder = 'ASC'
			END
		
			IF @inp_sSortField IS NULL OR @inp_sSortField = ''
			BEGIN 
				SELECT @inp_sSortField = 'TP.TradingPolicyName '
			END 			
		
			IF @inp_sSortField = 'rul_grd_55135' -- Trading policy name
			BEGIN 
				SELECT @inp_sSortField = 'TP.TradingPolicyName  ' 
			END
			
			IF @inp_sSortField = 'rul_grd_55136' -- Applicable from date
			BEGIN 
				SELECT @inp_sSortField = 'TP.ApplicableFromDate ' 
			END		
			
			IF @inp_sSortField = 'rul_grd_55137' -- Applicable to date
			BEGIN 
				SELECT @inp_sSortField = 'TP.ApplicableToDate ' 
			END	

			IF @inp_sSortField = 'rul_grd_55138' -- Applicable To
			BEGIN 
				SELECT @inp_sSortField = 'CdTPFor.CodeName ' 
			END	
			
			IF @inp_sSortField = 'rul_grd_55139' -- Status
			BEGIN 
				SELECT @inp_sSortField = 'CdTPStatus.CodeName ' 
			END	
			
			IF @inp_sSortField = 'rul_grd_55140' -- Modified On
			BEGIN 
				SELECT @inp_sSortField = 'TP.ModifiedOn ' 
			END
			
			IF @inp_sSortField = 'rul_grd_55141' -- Modified By
			BEGIN 
				SELECT @inp_sSortField = '(ISNULL(UI.FirstName, '''') + '' '' + ISNULL(UI.LastName, '''')) ' 
			END	
		
			print @sSQL
			SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY TP.ModifiedOn DESC , ' + @inp_sSortField + ' ' + @inp_sSortOrder +', TP.TradingPolicyId) ,TP.TradingPolicyId '
			SELECT @sSQL = @sSQL + ' FROM rul_TradingPolicy_OS TP INNER JOIN com_Code CdTPStatus ON TP.TradingPolicyStatusCodeId = CdTPStatus.CodeID '
			SELECT @sSQL = @sSQL + ' INNER JOIN com_Code CdTPFor ON TP.TradingPolicyForCodeId = CdTPFor.CodeID '
			SELECT @sSQL = @sSQL + ' INNER JOIN usr_UserInfo UI ON TP.ModifiedBy = UI.UserInfoId '
			SELECT @sSQL = @sSQL + ' WHERE 1=1 '
			SELECT @sSQL = @sSQL + ' AND TP.CurrentHistoryCodeId = ' + CAST(@nTPHistoryCodeId AS VARCHAR(20)) + ' '
			SELECT @sSQL = @sSQL + ' AND TP.IsDeletedFlag = 0 '
			SELECT @sSQL = @sSQL + ' AND ( (TP.TradingPolicyParentId IS NULL AND TP.TradingPolicyId = ' + CAST(@nTradingPolicyParentId AS VARCHAR)+ ') '
			SELECT @sSQL = @sSQL + ' OR TP.TradingPolicyParentId = ' + CAST(@nTradingPolicyParentId AS VARCHAR)+' ) '			
			
			PRINT(@sSQL)
			EXEC(@sSQL)
			
			SELECT	TP.TradingPolicyId AS TradingPolicyId, 
			TP.TradingPolicyName AS rul_grd_55135 /*[Policy Name]*/,
			TP.ApplicableFromDate AS rul_grd_55136 /*[Applicable From Date]*/,
			TP.ApplicableToDate AS rul_grd_55137 /*[Applicable To Date]*/,
			CdTPFor.CodeName AS rul_grd_55138 /*[Applicable To]*/,
			CdTPStatus.CodeName AS rul_grd_55139 /*[Status]*/,
			CAST(CAST(TP.ModifiedOn AS VARCHAR(11)) AS DATETIME) AS rul_grd_55140 /*[Modified on]*/,
			(ISNULL(UI.FirstName, '') + ' ' + ISNULL(UI.LastName,'')) AS rul_grd_55141 /*[Modified by]*/
			FROM	#tmpList T INNER JOIN rul_TradingPolicy_OS TP ON T.EntityID = TP.TradingPolicyId
					INNER JOIN com_Code CdTPStatus ON TP.TradingPolicyStatusCodeId = CdTPStatus.CodeID
					INNER JOIN com_Code CdTPFor ON TP.TradingPolicyForCodeId = CdTPFor.CodeID
					INNER JOIN usr_UserInfo UI ON TP.ModifiedBy = UI.UserInfoId
			WHERE	1=1 
			AND TP.CurrentHistoryCodeId = @nTPHistoryCodeId /*fetch only the History record*/
			AND TP.IsDeletedFlag = 0 /*fetch only non-deleted records*/
			AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
			ORDER BY T.RowNumber
		END		
		
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TRADINGPOLICY_HISTORY_LIST
	END CATCH
END
GO


