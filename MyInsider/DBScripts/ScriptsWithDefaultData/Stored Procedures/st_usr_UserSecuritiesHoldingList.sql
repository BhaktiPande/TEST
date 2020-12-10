IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserSecuritiesHoldingList')
DROP PROCEDURE [dbo].[st_usr_UserSecuritiesHoldingList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure used for getting available qty for demat indivisual for exclude one demat

Returns:		0, if Success.
				
Created by:		GS
Created on:		14-Oct-2016
Modification History:
Modified By		Modified On		Description
Tushar			24-Oct-2016		All Demat list show balance with zero if entry not found in summary.
Tushar			25-Oct-2016		Add error code
Tushar			26-Oct-2016		Search parameter add in procedure.

Usage:
DECLARE @RC int
EXEC st_usr_UserSecuritiesHoldingList 49,
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserSecuritiesHoldingList]
	@inp_iPageSize				INT = 10,
	@inp_iPageNo				INT = 1,
	@inp_sSortField				VARCHAR(255),
	@inp_sSortOrder				VARCHAR(5),
	@inp_iUserInfoID			INT,
	@inp_iOnlySelf				INT,
	@inp_iOnlyRelative			INT,
	@inp_sSecurityType			NVARCHAR(1000),
	@inp_sDematAccountNumber	NVARCHAR(1000),
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_HOLDINGLIST INT = 11486 -- Error occurred while fetching security holding list.
	DECLARE @nRetValue INT
	DECLARE @sSQL NVARCHAR(MAX) = ''

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
	    DECLARE @nCounter INT  = 1
        DECLARE @nTotalCount INT = 0
       	DECLARE @nYearCodeId INT  = 0 
       	DECLARE @nYearPeriod INT =  124001
		DECLARE @nDMATDetailsID INT  = 0 
		DECLARE @nSecurityTypeCodeId INT  = 0

		CREATE TABLE #tmpUserRelativeID(UserID INT,UserInfoIDRelative INT)
		
		CREATE TABLE #tmpDematSecurityBalance(Id INT IDENTITY(1,1),UserID INT,UserInfoIDRelative INT,Dematid int,SecurityType INT,Balance DECIMAL(30,0))
		
		INSERT INTO #tmpUserRelativeID
		SELECT @inp_iUserInfoID,@inp_iUserInfoID
		
		
		INSERT INTO #tmpUserRelativeID
		SELECT @inp_iUserInfoID,UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoId = @inp_iUserInfoID
		
		--select * from #tmpUserRelativeID
		
			
		INSERT INTO #tmpDematSecurityBalance(UserID,UserInfoIDRelative,Dematid,SecurityType,Balance)
		SELECT UR.UserID,UserInfoIDRelative,DMATDetailsID,139001,0 
		FROM usr_DMATDetails DD
		JOIN #tmpUserRelativeID UR ON DD.UserInfoID = UR.UserInfoIDRelative
		
		INSERT INTO #tmpDematSecurityBalance(UserID,UserInfoIDRelative,Dematid,SecurityType,Balance)
		SELECT UR.UserID,UserInfoIDRelative,DMATDetailsID,139002,0 FROM usr_DMATDetails DD
		JOIN #tmpUserRelativeID UR ON DD.UserInfoID = UR.UserInfoIDRelative
		
		INSERT INTO #tmpDematSecurityBalance(UserID,UserInfoIDRelative,Dematid,SecurityType,Balance)
		SELECT UR.UserID,UserInfoIDRelative,DMATDetailsID,139003,0 FROM usr_DMATDetails DD
		JOIN #tmpUserRelativeID UR ON DD.UserInfoID = UR.UserInfoIDRelative
		
		INSERT INTO #tmpDematSecurityBalance(UserID,UserInfoIDRelative,Dematid,SecurityType,Balance)
		SELECT UR.UserID,UserInfoIDRelative,DMATDetailsID,139004,0 FROM usr_DMATDetails DD
		JOIN #tmpUserRelativeID UR ON DD.UserInfoID = UR.UserInfoIDRelative
		
		INSERT INTO #tmpDematSecurityBalance(UserID,UserInfoIDRelative,Dematid,SecurityType,Balance)
		SELECT UR.UserID,UserInfoIDRelative,DMATDetailsID,139005,0 FROM usr_DMATDetails DD
		JOIN #tmpUserRelativeID UR ON DD.UserInfoID = UR.UserInfoIDRelative
		
		CREATE TABLE #tbl_Year_CodeID(ID INT IDENTITY(1,1),Year_CodeID INT,DmatID INT,SecurityTypeID INT, ClosingBal INT)
        INSERT INTO #tbl_Year_CodeID(Year_CodeID, DmatID, SecurityTypeID, ClosingBal)
        SELECT YearCodeId, DMATDetailsID, SecurityTypeCodeId, ClosingBalance FROM tra_TransactionSummaryDMATWise 
        WHERE UserInfoId = @inp_iUserInfoID AND PeriodCodeId = @nYearPeriod
        
        DELETE FROM #tbl_Year_CodeID WHERE Year_CodeID < ( SELECT MAX(Year_CodeID) FROM #tbl_Year_CodeID AS tyc
        WHERE tyc.DmatID = #tbl_Year_CodeID.DmatID AND tyc.SecurityTypeID = #tbl_Year_CodeID.SecurityTypeID)
        
        SELECT @nTotalCount = COUNT(*) FROM #tbl_Year_CodeID
		
		WHILE(@nCounter <= @nTotalCount)
		BEGIN   
	      SELECT @nYearCodeId = Year_CodeID, @nDMATDetailsID = DmatID, @nSecurityTypeCodeId = SecurityTypeID FROM #tbl_Year_CodeID WHERE ID = @nCounter
	    
	 	  UPDATE TDSB
		  SET Balance = ClosingBal 
		  FROM #tmpDematSecurityBalance TDSB
		  INNER JOIN tra_TransactionSummaryDMATWise TSDW ON TSDW.DMATDetailsID = TDSB.Dematid
		  AND TSDW.UserInfoId = TDSB.UserID AND TSDW.SecurityTypeCodeId = TDSB.SecurityType AND TSDW.UserInfoIdRelative = TDSB.UserInfoIDRelative
		  INNER JOIN #tbl_Year_CodeID YC ON TDSB.Dematid = YC.DmatID AND TDSB.SecurityType = YC.SecurityTypeID
		
		  SET @nCounter = @nCounter + 1
		END  
				
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		SELECT @inp_sSortOrder = 'ASC'
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'A.UserID,A.Dematid,A.SecurityType '
		END 
		SELECT @inp_sSortField = 'A.UserID,A.Dematid,A.SecurityType '
		SELECT @sSQL = @sSQL + ' INSERT INTO #tmpList (RowNumber, EntityID)'		
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',A.Id),A.Id '
		SELECT @sSQL = @sSQL + ' FROM #tmpDematSecurityBalance A'
		SELECT @sSQL = @sSQL + ' JOin usr_DMATDetails DD ON A.Dematid = DD.DMATDetailsID'
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '
		
		IF @inp_iOnlySelf IS NOT NULL AND @inp_iOnlySelf <> '' 
		BEGIN
			IF @inp_iOnlySelf  = '142001'
			BEGIN
				SELECT @sSQL = @sSQL + ' AND A.UserID = A.UserInfoIDRelative ' 
			END
			ELSE IF @inp_iOnlySelf  = '142002'
			BEGIN
				SELECT @sSQL = @sSQL + ' AND A.UserID <> A.UserInfoIDRelative ' 
			END
		END
		
		IF @inp_sSecurityType IS NOT NULL AND @inp_sSecurityType <> ''
		BEGIN
			SELECT @sSQL = @sSQL + ' AND A.SecurityType IN( '  + CAST(@inp_sSecurityType AS VARCHAR(1000))  + ' )'
		END
		
		IF @inp_sDematAccountNumber IS NOT NULL AND @inp_sDematAccountNumber <> ''
		BEGIN
			SELECT @sSQL = @sSQL + ' AND DD.DEMATAccountNumber LIKE N''%'+ @inp_sDematAccountNumber +'%'' '
		END
		
		--PRINT(@sSQL)
		EXEC(@sSQL)
		
		SELECT DSB.Dematid ,
		DSB.UserID,
		DSB.UserInfoIDRelative,
			   UF.FirstName + '   ' + UF.LastName AS Name,
			   CASE WHEN DSB.UserID = DSB.UserInfoIdRelative THEN 'Self' ELSE UserRelation.CodeName END AS usr_grd_11480, --Relation,
			   DD.DPBank AS usr_grd_11474,-- Depository_Name, 
			   DD.DEMATAccountNumber AS usr_grd_11475,
			   DD.DPID AS usr_grd_11476,-- Depository_Participant_ID,
			   DD.TMID AS usr_grd_11478, --TMID,
			   AcountType.CodeName AS usr_grd_11479, --Demat_Account_Type,
			   SecurityTypeCode.CodeName AS usr_grd_11481, --SecurityType,
			   DSB.Balance AS usr_grd_11482,
			   DPName.CodeName AS usr_grd_11477
		FROM #tmpList T 
		INNER JOIN #tmpDematSecurityBalance DSB ON DSB.Id = T.EntityID
		JOIN usr_DMATDetails DD  ON DD.DMATDetailsID = DSB.Dematid
		JOIN usr_UserInfo UF ON DSB.UserID = UF.UserInfoId
		JOIN com_Code SecurityTypeCode ON DSB.SecurityType = SecurityTypeCode.CodeID 
		JOIN com_Code AcountType ON DD.AccountTypeCodeId = AcountType.CodeID
		LEFT JOIN usr_UserRelation UR ON DSB.UserInfoIdRelative = UR.UserInfoIdRelative
		LEFT JOIN com_Code UserRelation ON UR.RelationTypeCodeId = UserRelation.CodeID
		LEFT JOIN com_Code DPName ON DD.DPBankCodeId = DPName.CodeID
		WHERE	DSB.Id IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_HOLDINGLIST, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END