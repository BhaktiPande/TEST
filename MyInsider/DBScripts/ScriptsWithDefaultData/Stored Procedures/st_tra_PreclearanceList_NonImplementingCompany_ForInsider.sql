IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceList_NonImplementingCompany_ForInsider')
DROP PROCEDURE [dbo].[st_tra_PreclearanceList_NonImplementingCompany_ForInsider]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Preclearance Request for Non Implementing Company for particular individual user, based on input @inp_iUserInfoID.

Returns:		0, if Success.
				
Created by:		Raghvendra	
Created on:		21-Sep-2016

Modification History:
Modified By		Modified On		Description
Tushar			23-Sep-2016		Return flag from procedure IsFORMEGenrated
Tushar			27-Sep-2016		Change for default sorting on the basis of DisplaySequenceNo. 

Usage:
EXEC st_tra_PreclearanceList_NonImplementingCompany_ForInsider
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_PreclearanceList_NonImplementingCompany_ForInsider]
	@inp_iPageSize							INT = 10
	,@inp_iPageNo							INT = 1
	,@inp_sSortField						VARCHAR(255)
	,@inp_sSortOrder						VARCHAR(5)
	,@inp_iUserInfoID						INT --Loggedin UserInfoId
	,@inp_iPreclearanceCodeID				NVARCHAR(MAX) --Search param
	,@inp_iPreclearanceRequestStatus		INT --Search param
	,@inp_iTransactionType					INT --Search param
	,@out_nReturnValue						INT = 0				OUTPUT
	,@out_nSQLErrCode						INT = 0				OUTPUT	-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage					VARCHAR(500) = ''	OUTPUT	-- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL							NVARCHAR(MAX) = ''
	DECLARE @ERR_PRECLEARANCE_LIST_NON_IMPLEMENTING_COMPANY	INT = 17484 --Error occurred while fetching list of PreClearance Request details of NonImplementing company. 			

	--Preclearance Status Variable
	DECLARE	@nPreclearanceRequested				INT = 144001 
	DECLARE	@nPreclearanceApproved				INT = 144002 
	DECLARE @nPreclearanceRejected				INT = 144003 

	DECLARE @sPrceclearanceCodePrefixText		 VARCHAR(3)
	--DECLARE @sNonPrceclearanceCodePrefixText	 VARCHAR(3)
	DECLARE @sPrceclearanceNotRequiredPrefixText VARCHAR(200)

	DECLARE @nPreclearanceRequestMapToType		INT = 132015 --MapToType of Preclearance for NonImplementing company

	-- Resource Variable
	DECLARE @sPendingButtonText				VARCHAR(10)
	DECLARE @sApproveButtonText					VARCHAR(10)
	DECLARE @sRejectedButtonText				VARCHAR(10)
	

	DECLARE @nPreclearanceTakenCase INT = 176001
	DECLARE @nInsiderNotPreclearanceTakenCase INT = 176002
	DECLARE @nNonInsiderNotPreclearanceTakenCase INT = 176003
			
	--Pending Button Text
	SELECT @sPendingButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17005'
	--Approve Button Text
	SELECT @sApproveButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17023'
	--Reject Button Text
	SELECT @sRejectedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17024'

	--Set the Prefix to display for Preclearance ID
	SET	@sPrceclearanceCodePrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nPreclearanceTakenCase)
	--SET @sNonPrceclearanceCodePrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nInsiderNotPreclearanceTakenCase)
	SET @sPrceclearanceNotRequiredPrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nNonInsiderNotPreclearanceTakenCase)

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
	
		CREATE TABLE #tmpUsers(Id INT IDENTITY(1,1), UserInfoId INT, 
								PreclearanceStatus INT,
								PreClearanceRequestCode NVARCHAR(MAX),
								DisplaySequenceNo BIGINT,
								IdCount INT 
							   )
		
		INSERT INTO #tmpUsers(UserInfoId, PreClearanceRequestCode,DisplaySequenceNo,IdCount)
		SELECT U.UserInfoId, 
				CASE WHEN U.DateOfBecomingInsider IS NOT NULL 
				THEN @sPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),PRNIC.DisplaySequenceNo)
				ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(NVARCHAR(MAX),PRNIC.DisplaySequenceNo) 
				END AS PreClearanceRequestCode,
				MAX(PRNIC.DisplaySequenceNo),
				COUNT(PRNIC.DisplaySequenceNo)
		FROM tra_PreclearanceRequest_NonImplementationCompany PRNIC
		INNER JOIN usr_UserInfo U ON PRNIC.UserInfoId = U.UserInfoId
		WHERE ((@inp_iUserInfoID IS NULL OR @inp_iUserInfoID = 0) OR (PRNIC.UserInfoId = @inp_iUserInfoID))
		GROUP BY PRNIC.DisplaySequenceNo,U.UserInfoId, U.DateOfBecomingInsider
		
		--Set default sort order
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'DESC '
		END
		
		--set default sort field
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'Temp.DisplaySequenceNo '
		END 

		IF @inp_sSortField  = 'dis_grd_17485' --Pre Clearance ID
		BEGIN 
			SELECT @inp_sSortField = 'Temp.PreClearanceRequestCode '
		END

		IF @inp_sSortField  = 'dis_grd_17487' --Request Date
		BEGIN 
			SELECT @inp_sSortField = 'PRNIC.CreatedOn '
		END

		IF @inp_sSortField  = 'dis_grd_17489' --Transaction Type
		BEGIN 
			SELECT @inp_sSortField = 'PRNIC.TransactionTypeCodeId '
		END

		IF @inp_sSortField  = 'dis_grd_17490' --Securities
		BEGIN 
			SELECT @inp_sSortField = 'PRNIC.SecurityTypeCodeId '
		END

		IF @inp_sSortField  = 'dis_grd_17491' --Preclearance Qty
		BEGIN 
			SELECT @inp_sSortField = 'PRNIC.SecuritiesToBeTradedQty '
		END

		-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'

		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +'),Temp.Id '
		SELECT @sSQL = @sSQL + ' FROM #tmpUsers Temp '
		SELECT @sSQL = @sSQL + ' LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PRNIC ON Temp.DisplaySequenceNo = PRNIC.DisplaySequenceNo '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '

		IF(@inp_iPreclearanceCodeID IS NOT NULL AND @inp_iPreclearanceCodeID <> '')
		BEGIN
			--Preclearance code - PCL / PNR with number
			SELECT @sSQL = @sSQL + ' AND Temp.PreClearanceRequestCode like ''%' + CONVERT(VARCHAR,@inp_iPreclearanceCodeID) + '%'''
		END
		
		IF(@inp_iPreclearanceRequestStatus IS NOT NULL AND @inp_iPreclearanceRequestStatus <> 0)
		BEGIN
			--Preclearance Status
			SELECT @sSQL = @sSQL + ' AND PRNIC.PreclearanceStatusCodeId = ' + CONVERT(VARCHAR,@inp_iPreclearanceRequestStatus)
		END

		IF(@inp_iTransactionType IS NOT NULL AND @inp_iTransactionType <> 0)
		BEGIN
			--Preclearance TransactionType
			SELECT @sSQL = @sSQL + ' AND PRNIC.TransactionTypeCodeId = ' + CONVERT(VARCHAR,@inp_iTransactionType)
		END

		
		--PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT DISTINCT T.RowNumber,
		TempTbl.DisplaySequenceNo,
		TempTbl.PreClearanceRequestCode AS dis_grd_17485,--'Pre Clearance ID'
		UPPER(REPLACE(CONVERT(VARCHAR(20), PRNIC.CreatedOn, 106), ' ', '/')) AS dis_grd_17487,--'Request Date'
		CPRNICStatus.CodeID AS PreclearanceStatusCodeId,
		CASE WHEN CPRNICStatus.CodeID  = @nPreclearanceRequested THEN @sPendingButtonText 
			 WHEN CPRNICStatus.CodeID  = @nPreclearanceApproved THEN @sApproveButtonText
			 WHEN CPRNICStatus.CodeID  = @nPreclearanceRejected THEN @sRejectedButtonText 
		END AS dis_grd_17488,--'PreClearance Status',
		CASE WHEN TempTbl.IdCount>1 THEN '' ELSE CPRNICRequestFor.CodeName END AS dis_grd_17486,--'Request For'
		CASE WHEN TempTbl.IdCount>1 THEN '' ELSE CASE WHEN CPRNICTransactnType.CodeName IS NULL THEN '' ELSE CPRNICTransactnType.CodeName END END AS dis_grd_17489,--'Transaction Type',
		CASE WHEN TempTbl.IdCount>1 THEN '' ELSE CASE WHEN CPRNICSecurityType.CodeName IS NULL THEN '' ELSE CPRNICSecurityType.CodeName END END AS dis_grd_17490,--'Securities',
		CASE WHEN TempTbl.IdCount>1 THEN NULL ELSE PRNIC.SecuritiesToBeTradedQty END AS dis_grd_17491,--'Preclearance Qty'
		NULL AS dis_grd_17492,--'Trade Qty',
		NULL AS dis_grd_17493,--'Trading Details Submission',
		NULL AS dis_grd_17494,--'Disclosure Details Submission: Softcopy',
		NULL AS dis_grd_17495,--'Disclosure Details Submission: Hardcopy',
		NULL AS dis_grd_17496,--'Submission to Stock Exchange'
		CASE WHEN GFD.GeneratedFormDetailsId IS NULL THEN 0 ELSE 1 END AS IsFORMEGenrated
		FROM #tmpList T
		INNER JOIN #tmpUsers TempTbl ON TempTbl.Id=T.EntityID
		RIGHT JOIN tra_PreclearanceRequest_NonImplementationCompany PRNIC ON PRNIC.DisplaySequenceNo=TempTbl.DisplaySequenceNo
		LEFT JOIN com_Code CPRNICRequestFor ON PRNIC.PreclearanceRequestForCodeId = CPRNICRequestFor.CodeID
		LEFT JOIN com_Code CPRNICStatus ON PRNIC.PreclearanceStatusCodeId = CPRNICStatus.CodeID
		LEFT JOIN com_Code CPRNICTransactnType ON PRNIC.TransactionTypeCodeId = CPRNICTransactnType.CodeID
		LEFT JOIN com_Code CPRNICSecurityType ON PRNIC.SecurityTypeCodeId = CPRNICSecurityType.CodeID
		LEFT JOIN tra_GeneratedFormDetails GFD ON TempTbl.DisplaySequenceNo = GFD.MapToId AND GFD.MapToTypeCodeId = 132015
		WHERE TempTbl.DisplaySequenceNo IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber


		--SELECT TempTbl.DisplaySequenceNo, 
		--TempTbl.PreClearanceRequestCode AS dis_grd_17485, --'Pre Clearance ID', 
		--CPRNICRequestFor.CodeName AS dis_grd_17486,--'Request For',
		--UPPER(REPLACE(CONVERT(VARCHAR(20), PRNIC.CreatedOn, 106), ' ', '/')) AS dis_grd_17487,--'Request Date',
		--CPRNICStatus.CodeID AS PreclearanceStatusCodeId,
		--CASE WHEN CPRNICStatus.CodeID  = @nPreclearanceRequested THEN @sPendingButtonText 
		--	 WHEN CPRNICStatus.CodeID  = @nPreclearanceApproved THEN @sApproveButtonText
		--	 WHEN CPRNICStatus.CodeID  = @nPreclearanceRejected THEN @sRejectedButtonText 
		--END AS dis_grd_17488,--'PreClearance Status',
		--CASE WHEN CPRNICTransactnType.CodeName IS NULL THEN '' ELSE CPRNICTransactnType.CodeName END AS dis_grd_17489,--'Transaction Type',
		--CASE WHEN CPRNICSecurityType.CodeName IS NULL THEN '' ELSE CPRNICSecurityType.CodeName END AS dis_grd_17490,--'Securities',
		--PRNIC.SecuritiesToBeTradedQty AS dis_grd_17491,--'Preclearance Qty',
		--NULL AS dis_grd_17492,--'Trade Qty',
		--NULL AS dis_grd_17493,--'Trading Details Submission',
		--NULL AS dis_grd_17494,--'Disclosure Details Submission: Softcopy',
		--NULL AS dis_grd_17495,--'Disclosure Details Submission: Hardcopy',
		--NULL AS dis_grd_17496,--'Submission to Stock Exchange'
		--CASE WHEN GFD.GeneratedFormDetailsId IS NULL THEN 0 ELSE 1 END AS IsFORMEGenrated
		--FROM #tmpList T 
		--INNER JOIN #tmpUsers TempTbl ON TempTbl.Id = T.EntityID
		--LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PRNIC 
		--ON TempTbl.DisplaySequenceNo = PRNIC.DisplaySequenceNo
		--LEFT JOIN com_Code CPRNICRequestFor ON PRNIC.PreclearanceRequestForCodeId = CPRNICRequestFor.CodeID
		--LEFT JOIN com_Code CPRNICStatus ON PRNIC.PreclearanceStatusCodeId = CPRNICStatus.CodeID
		--LEFT JOIN com_Code CPRNICTransactnType ON PRNIC.TransactionTypeCodeId = CPRNICTransactnType.CodeID
		--LEFT JOIN com_Code CPRNICSecurityType ON PRNIC.SecurityTypeCodeId = CPRNICSecurityType.CodeID
		--LEFT JOIN tra_GeneratedFormDetails GFD ON TempTbl.DisplaySequenceNo = GFD.MapToId AND GFD.MapToTypeCodeId = 132015
		--WHERE   TempTbl.DisplaySequenceNo IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		--ORDER BY T.RowNumber
		
		
		RETURN 0
	END	 TRY
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PRECLEARANCE_LIST_NON_IMPLEMENTING_COMPANY
	END CATCH
END
