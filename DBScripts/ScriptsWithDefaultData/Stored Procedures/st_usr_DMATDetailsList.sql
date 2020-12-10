IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DMATDetailsList')
DROP PROCEDURE [dbo].[st_usr_DMATDetailsList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save user info.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		11-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		12-Feb-2015		Added UserINfoId in the output
Arundhati		24-Feb-2015		Sorting and column names for the common functionality are done
Parag			02-Sept-2016	Made change to show DP Bank name from code table if code is saved for DP bank 
Raghvendra		20-Sep-2016		Change to increase the DisplayCode column size from 50 to 1000

Usage:
EXEC st_usr_DMATDetailsList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DMATDetailsList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_iUserInfoID				INT
	,@inp_sDEMATAccountNumber		NVARCHAR(50)
	,@inp_sDPBank					NVARCHAR(1000)
	,@inp_sDPID						VARCHAR(50)
	,@inp_sTMID						VARCHAR(50)
	,@inp_sDescription				VARCHAR(200)
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_DEMAT_LIST INT = 11040 -- Error occurred while fetching list of demat accounts for user.

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'UD.DEMATAccountNumber '
		END 

		IF @inp_sSortField = 'usr_grd_11094' -- DEMATAccountNumber
		BEGIN 
			SELECT @inp_sSortField = 'UD.DEMATAccountNumber '
		END 
		
		IF @inp_sSortField = 'usr_grd_11095' -- DPBank
		BEGIN 
			SELECT @inp_sSortField = 'UD.DPBank '
		END 
		
		IF @inp_sSortField = 'usr_grd_11096' -- DPID
		BEGIN 
			SELECT @inp_sSortField = 'UD.DPID '
		END 
		
		IF @inp_sSortField = 'usr_grd_11097' -- TMID
		BEGIN 
			SELECT @inp_sSortField = 'UD.TMID '
		END 
		
		IF @inp_sSortField = 'usr_grd_11098' -- Description

		BEGIN 
			SELECT @inp_sSortField = 'UD.Description '
		END 
		

		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UD.DMATDetailsID),UD.DMATDetailsID '				
		SELECT @sSQL = @sSQL + ' FROM usr_DMATDetails UD '
		SELECT @sSQL = @sSQL + ' WHERE UserInfoID = ' + CAST(@inp_iUserInfoID AS VARCHAR(10)) + ' '

		IF (@inp_sDEMATAccountNumber IS NOT NULL AND @inp_sDEMATAccountNumber <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.DEMATAccountNumber LIKE N''%'+ @inp_sDEMATAccountNumber +'%'' '
		END
		
		IF (@inp_sDPBank IS NOT NULL AND @inp_sDPBank <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.DPBank LIKE N''%'+ @inp_sDPBank +'%'' '
		END
		
		IF (@inp_sDPID IS NOT NULL AND @inp_sDPID <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.DPID LIKE N''%'+ @inp_sDPID +'%'' '
		END
		
		IF (@inp_sTMID IS NOT NULL AND @inp_sTMID <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.TMID LIKE N''%'+ @inp_sTMID +'%'' '
		END

		IF (@inp_sDescription IS NOT NULL AND @inp_sDescription <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.Description LIKE N''%'+ @inp_sDescription +'%'' '
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	UD.DMATDetailsID AS DMATDetailsID,
				UD.DEMATAccountNumber AS usr_grd_11094, -- DEMATAccountNumber
				CASE 
					WHEN UD.DPBankCodeId IS NULL THEN UD.DPBank 
					ELSE CASE WHEN DPBI.DisplayCode IS NULL OR DPBI.DisplayCode = '' THEN DPBI.CodeName ELSE DPBI.DisplayCode END
				END AS usr_grd_11095, -- DPBank
				UD.DPID AS usr_grd_11096, -- DPID
				UD.TMID AS usr_grd_11097, -- TMID
				UD.Description AS usr_grd_11098, -- Description
			    CUserDmatStatus.CodeName AS usr_grd_50752,
				UD.UserInfoID AS UserInfoID
		FROM	#tmpList T INNER JOIN
				usr_DMATDetails UD ON UD.DMATDetailsID = T.EntityID
				LEFT JOIN com_Code DPBI ON UD.DPBankCodeId IS NOT NULL AND UD.DPBankCodeId = DPBI.CodeID
				LEFT JOIN com_Code CUserDmatStatus ON UD.DmatAccStatusCodeId = CUserDmatStatus.CodeID
		WHERE   UD.DMATDetailsID IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_DEMAT_LIST
	END CATCH
END
