IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_EulaAcceptanceReport')
DROP PROCEDURE [dbo].[st_rpt_EulaAcceptanceReport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	User EULA acceptance details report

Returns:		0, if Success.
				
Created by:		Priyanka Bhangale
Created on:		17-Feb-2015
-------------------------------------------------------------------------------------------------*/
--EXEC st_rpt_EulaAcceptanceReport 10,2,null,'ASC',0,'',''
CREATE PROCEDURE [dbo].[st_rpt_EulaAcceptanceReport]
	@inp_iPageSize				INT = 10,
	@inp_iPageNo				INT = 1,
	@inp_sSortField			VARCHAR(255),
	@inp_sSortOrder			VARCHAR(5),
	@inp_iUserId			INT,						
	@inp_dFromDate      	DATETIME,						
	@inp_dToDate            DATETIME,													
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @sSQL                           NVARCHAR(MAX)
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN
			SET @inp_sSortOrder = 'ASC'
		END 
		--SELECT @sSQL = 'SELECT U.EmployeeId AS EmployeeID, U.FirstName + '' ''+U.LastName AS EmployeeName, ER.EULAAcceptanceDate AS AcceptanceDate FROM rpt_EULAAcceptanceReport ER '
		SELECT @sSQL = 'SELECT ROW_NUMBER() OVER (ORDER BY ER.EULAReportID), ER.EULAReportID AS UserId FROM rpt_EULAAcceptanceReport ER '
		SELECT @sSQL = @sSQL + 'JOIN usr_UserInfo U ON U.UserInfoId = ER.UserInfoID '
		SELECT @sSQL = @sSQL + 'WHERE ER.EULAAcceptanceFlag=1 '
											
		IF ((@inp_dFromDate IS NOT NULL AND @inp_dFromDate <> '')
			OR (@inp_dToDate IS NOT NULL AND @inp_dToDate <> '')
			OR (@inp_iUserId IS NOT NULL AND @inp_iUserId <> '0'))
		BEGIN 
			IF (@inp_dFromDate IS NOT NULL AND @inp_dFromDate <> '')
			BEGIN 
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATE, ''' + CONVERT(VARCHAR(11), @inp_dFromDate) + ''') <= CONVERT(DATE,ER.EULAAcceptanceDate) '
			END
			
			IF (@inp_dToDate IS NOT NULL AND @inp_dToDate <> '')
			BEGIN			
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATE, ''' + CONVERT(VARCHAR(20), @inp_dToDate) + ''') >= CONVERT(DATE,ER.EULAAcceptanceDate) '
			END

			IF (@inp_iUserId IS NOT NULL AND @inp_iUserId <> '0')
			BEGIN
				SELECT @sSQL = @sSQL + ' AND ER.UserInfoId =' + CONVERT(VARCHAR(11), @inp_iUserId) + ''
			END
		END
		SELECT @sSQL = @sSQL + ' ORDER BY ER.UserInfoId '+ @inp_sSortOrder +''

		PRINT @sSQL

		INSERT INTO #tmpList (RowNumber, EntityID)
		EXEC (@sSQL)
		
		SELECT L.RowNumber AS 'rpt_grd_53110',U.UserInfoId, U.EmployeeId AS 'rpt_grd_53111', U.FirstName + ' '+U.LastName AS 'rpt_grd_53112', R.EULAAcceptanceDate AS 'rpt_grd_53113'
		FROM #tmpList L  
		JOIN rpt_EULAAcceptanceReport R ON R.EULAReportID = L.EntityID
		LEFT JOIN usr_UserInfo U ON U.UserInfoId = R.UserInfoID
		WHERE R.EULAAcceptanceFlag=1
		 AND ((@inp_iPageSize = 0) OR (L.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY L.RowNumber

		SELECT 0

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = ERROR_NUMBER()
		RETURN @out_nReturnValue		
	END CATCH
END

