
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicySecuritywiseLimitsList_OS')
	DROP PROCEDURE [dbo].[st_rul_TradingPolicySecuritywiseLimitsList_OS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Trading Policy Securitywise Limits

Returns:		0, if Success.
				
Created by:		Rajashri Sathe
Created on:		12-Des-2019

Modification History:
Modified By		Modified On		Description

Usage:
EXEC st_rul_TradingPolicySecuritywiseLimitsList_OS 2
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_TradingPolicySecuritywiseLimitsList_OS]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
    ,@inp_iTradingPolicyID			INT
    ,@inp_iMapToTypeCodeID			INT
    ,@inp_iAllSecurityFlag			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_ROLE_LIST INT = 15375 -- Error occurred while fetching list of users.


	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF @inp_iTradingPolicyID IS NULL
		BEGIN
			SET @inp_iTradingPolicyID = 0
		END
		CREATE TABLE #tmpSecurityCode(SecurityCodeID INT)
		
		IF(@inp_iAllSecurityFlag = 1)
		BEGIN
				INSERT INTO #tmpSecurityCode VALUES(0)
		END
		ELSE
		BEGIN
			INSERT INTO #tmpSecurityCode SELECT CodeID FROM com_Code WHERE CodeGroupId = 139
		END
		
			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		
		-- if Called From CreateUser
	
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'code.SecurityCodeID '
		END 
		
		IF @inp_sSortField  = 'rul_grd_55324'
		BEGIN 
			SELECT @inp_sSortField = 'code.SecurityCodeID '
		END 
		IF @inp_sSortField  = 'rul_grd_55325'
		BEGIN 
			SELECT @inp_sSortField = 'TPSL.NoOfShares '
		END 
		IF @inp_sSortField  = 'rul_grd_55326'
		BEGIN 
			SELECT @inp_sSortField = 'TPSL.PercPaidSubscribedCap '
		END 
		IF @inp_sSortField  = 'rul_grd_55327'
		BEGIN 
			SELECT @inp_sSortField = 'TPSL.ValueOfShares '
		END 
		
		--SELECT * FROM #tmpSecurityCode
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',code.SecurityCodeID),code.SecurityCodeID '				
	--	SELECT @sSQL = @sSQL + ' FROM com_Code code '		
		SELECT @sSQL = @sSQL + ' FROM #tmpSecurityCode code '	
		IF(@inp_iAllSecurityFlag = 1)
		BEGIN
			
			SELECT @sSQL = @sSQL + '  LEFT JOIN  rul_TradingPolicySecuritywiseLimits_OS TPSL ON  TPSL.TradingPolicyId = ' + CONVERT(VARCHAR(MAX),@inp_iTradingPolicyID)
			SELECT @sSQL = @sSQL + ' AND TPSL.MapToTypeCodeId = '+ CONVERT(VARCHAR(MAX),@inp_iMapToTypeCodeID)
		END
		ELSE 
		BEGIN
			SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code code1 ON code1.CodeID = code.SecurityCodeID '
			SELECT @sSQL = @sSQL + ' LEFT JOIN  rul_TradingPolicySecuritywiseLimits_OS TPSL ON  code1.CodeID = TPSL.SecurityTypeCodeId AND TPSL.TradingPolicyId = '	+ CONVERT(VARCHAR(MAX),@inp_iTradingPolicyID)			
			SELECT @sSQL = @sSQL + ' AND TPSL.MapToTypeCodeId = '+ CONVERT(VARCHAR(MAX),@inp_iMapToTypeCodeID)
		END
			
		PRINT(@sSQL)
		EXEC(@sSQL)
		IF(@inp_iAllSecurityFlag = 1)
		BEGIN
			SELECT	TPSL.TradingPolicyId,
					NULL AS SecurityCodeID,
					TPSL.MapToTypeCodeId,
					'All' AS rul_grd_55324,
					CASE WHEN TPSL.NoOfShares IS NULL THEN NULL ELSE CONVERT(INT,TPSL.NoOfShares) END AS rul_grd_55325,
					CASE WHEN TPSL.PercPaidSubscribedCap IS NULL THEN NULL ELSE CONVERT(DECIMAL(15,2),TPSL.PercPaidSubscribedCap)  END AS rul_grd_55326,
					CASE WHEN TPSL.ValueOfShares IS NULL THEN NULL ELSE CONVERT(DECIMAL(18,2),TPSL.ValueOfShares) END AS rul_grd_55327
			FROM	 #tmpList T 
			LEFT JOIN  rul_TradingPolicySecuritywiseLimits_OS TPSL ON  TPSL.TradingPolicyId = @inp_iTradingPolicyID 
			AND TPSL.MapToTypeCodeId = @inp_iMapToTypeCodeID AND TPSL.SecurityTypeCodeId IS NULL  
			WHERE   ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		END
		ELSE
		BEGIN
			SELECT	TPSL.TradingPolicyId,
					code.CodeID AS SecurityCodeID,
					TPSL.MapToTypeCodeId,
					code.CodeName AS rul_grd_55324,
					CASE WHEN TPSL.NoOfShares IS NULL THEN NULL ELSE CONVERT(INT,TPSL.NoOfShares) END AS rul_grd_55325,
					CASE WHEN TPSL.PercPaidSubscribedCap IS NULL THEN NULL ELSE CONVERT(DECIMAL(15,2),TPSL.PercPaidSubscribedCap) END AS rul_grd_55326,
					CASE WHEN TPSL.ValueOfShares IS NULL THEN NULL ELSE CONVERT(DECIMAL(18,2),TPSL.ValueOfShares) END AS rul_grd_55327
			FROM	 #tmpList T 
			LEFT JOIN
			com_Code code ON code.CodeID = T.EntityID
			LEFT JOIN  rul_TradingPolicySecuritywiseLimits_OS TPSL ON  code.CodeID = TPSL.SecurityTypeCodeId AND TPSL.TradingPolicyId = @inp_iTradingPolicyID AND TPSL.MapToTypeCodeId = @inp_iMapToTypeCodeID
			WHERE   code.CodeID IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
			ORDER BY T.RowNumber
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_ROLE_LIST
	END CATCH
END
GO


