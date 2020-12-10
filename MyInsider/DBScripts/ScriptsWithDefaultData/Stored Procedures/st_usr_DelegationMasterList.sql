IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DelegationMasterList')
DROP PROCEDURE [dbo].[st_usr_DelegationMasterList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list delegations.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		26-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		10-MAr-2015		Search parameters are reduced. If the Input dates fall between the Start and End date, 
								or the Start, End date falls between the input parameters, the record is included in the output
Usage:
EXEC st_usr_DelegationMasterList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DelegationMasterList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_iUserInfoIdFrom			INT
	,@inp_iUserInfoIdTo				INT
	,@inp_dtDelegationFrom			DATETIME
	,@inp_dtDelegationTo			DATETIME
	--,@inp_dtDelegationFrom_Lower	DATETIME
	--,@inp_dtDelegationFrom_Upper	DATETIME
	--,@inp_dtDelegationTo_Lower		DATETIME
	--,@inp_dtDelegationTo_Upper		DATETIME
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_DELEGATION_LIST INT = 12011 -- Error occurred while fetching list of delegations.
	DECLARE @dtDefault DATETIME = CONVERT(DATETIME, '')
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		IF @inp_dtDelegationFrom = @dtDefault
			SET @inp_dtDelegationFrom = NULL
		
		IF @inp_dtDelegationTo = @dtDefault
			SET @inp_dtDelegationTo = NULL
		
			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'DM.DelegationFrom '
		END 
		

		IF @inp_sSortField = 'usr_grd_12014'  -- DelegationFrom
		BEGIN 
			SELECT @inp_sSortField = 'DM.DelegationFrom '
		END 
		
		IF @inp_sSortField = 'usr_grd_12015'  -- DelegationTo
		BEGIN 
			SELECT @inp_sSortField = 'DM.DelegationTo '
		END 
		
		IF @inp_sSortField = 'usr_grd_12012'  -- FromUser,
		BEGIN 
			SELECT @inp_sSortField = 'UFrom.FirstName ' + @inp_sSortOrder + ', UFrom.LastName '
		END 
		
		IF @inp_sSortField = 'usr_grd_12013'  -- ToUser
		BEGIN 
			SELECT @inp_sSortField = 'UTo.FirstName ' + @inp_sSortOrder + ', UTo.LastName '
		END 
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',DM.DelegationId),DM.DelegationId '
		SELECT @sSQL = @sSQL + ' FROM usr_DelegationMaster DM '
		SELECT @sSQL = @sSQL + ' JOIN usr_UserInfo UFrom ON DM.UserInfoIdFrom = UFrom.UserInfoId '
		SELECT @sSQL = @sSQL + ' JOIN usr_UserInfo UTo ON DM.UserInfoIdTo = UTo.UserInfoId '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '


		IF (@inp_iUserInfoIdFrom IS NOT NULL AND @inp_iUserInfoIdFrom <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND DM.UserInfoIdFrom = '+ CAST(@inp_iUserInfoIdFrom AS VARCHAR(20)) +' '
		END
		
		IF (@inp_iUserInfoIdTo IS NOT NULL AND @inp_iUserInfoIdTo <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND DM.UserInfoIdTo = '+ CAST(@inp_iUserInfoIdTo AS VARCHAR(20)) + ' '
		END
		
		IF (@inp_dtDelegationFrom IS NOT NULL OR @inp_dtDelegationTo IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND ( '
			IF (@inp_dtDelegationFrom IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' (DM.DelegationFrom <= '''  + CAST(@inp_dtDelegationFrom AS VARCHAR(11)) + ''''
				SELECT @sSQL = @sSQL + ' AND DM.DelegationTo >= '''  + CAST(@inp_dtDelegationFrom AS VARCHAR(11)) + ''')'
			END
			
			IF (@inp_dtDelegationFrom IS NOT NULL AND @inp_dtDelegationTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' OR '
			END
			
			IF (@inp_dtDelegationTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' (DM.DelegationFrom <= '''  + CAST(@inp_dtDelegationTo AS VARCHAR(11)) + ''''
				SELECT @sSQL = @sSQL + ' AND DM.DelegationTo >= '''  + CAST(@inp_dtDelegationTo AS VARCHAR(11)) + ''')'
			END
			
			IF (@inp_dtDelegationFrom IS NOT NULL AND @inp_dtDelegationTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' OR (''' + CAST(@inp_dtDelegationFrom AS VARCHAR(11)) + ''' <= DM.DelegationFrom '
				SELECT @sSQL = @sSQL + ' AND '''  + CAST(@inp_dtDelegationTo AS VARCHAR(11)) + ''' >= DM.DelegationFrom )'

				SELECT @sSQL = @sSQL + ' OR (''' + CAST(@inp_dtDelegationFrom AS VARCHAR(11)) + ''' <= DM.DelegationTo '
				SELECT @sSQL = @sSQL + ' AND '''  + CAST(@inp_dtDelegationTo AS VARCHAR(11)) + ''' >= DM.DelegationTo )'
			END
			
			SELECT @sSQL = @sSQL + ' )'
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	DM.DelegationId,
				DM.DelegationFrom AS usr_grd_12014,
				DM.DelegationTo AS usr_grd_12015,
				DM.UserInfoIdFrom,
				DM.UserInfoIdTo,
				UFrom.FirstName + ' ' + UFrom.LastName AS usr_grd_12012,
				UTo.FirstName + ' ' + UTo.LastName AS usr_grd_12013
		FROM	#tmpList T INNER JOIN
				usr_DelegationMaster DM ON DM.DelegationId = T.EntityID
				JOIN usr_UserInfo UFrom ON DM.UserInfoIdFrom = UFrom.UserInfoId
				JOIN usr_UserInfo UTo ON DM.UserInfoIdTo = UTo.UserInfoId
		WHERE	DM.DelegationId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_DELEGATION_LIST
	END CATCH
END
