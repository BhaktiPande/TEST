IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_ClawBackReport')
DROP PROCEDURE [dbo].[st_rpt_ClawBackReport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure for Claw Back list.

Returns:		0, if Success.
				
Created by:		Tushar Wakchaure
Created on:		18-July-2018

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_ClawBackReport]
	@inp_iPageSize									INT = 10
	,@inp_iPageNo									INT = 1
	,@inp_sSortField								VARCHAR(255)
	,@inp_sSortOrder								VARCHAR(5)
	,@inp_sFromDate								    VARCHAR(100)
	,@inp_sToDate								    VARCHAR(100)
	,@inp_sEmployeeID								NVARCHAR(50)
	,@inp_sInsiderName								NVARCHAR(100)
	,@inp_sPAN								        NVARCHAR(100)
	,@inp_sDematAccountNumber						NVARCHAR(50)
	,@out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	
	--Variable Declaration
	DECLARE @ERR_CLAWBACKREPORT			    INT = 50707
	DECLARE @sSQL							NVARCHAR(MAX)
	
	DECLARE @nInitialComplianceType			INT = 170001
	DECLARE @nContinuousComplianceType		INT = 170002
	DECLARE @nPeriodEndComplianceType		INT = 170003
	DECLARE @nPreclearanceComplianceType	INT = 170004
	
	DECLARE @nPreclearanceLevelQtyComment						INT
	DECLARE @nPreclearanceLevelValueComment						INT
	DECLARE @nTradedMoreThanPreClearanceApprovedQuantity		INT		= 169003
	DECLARE @nTradedMoreThanPreClearanceApprovedValue			INT		= 169004
	DECLARE @nTradedAfterPreclearanceDateCommentID				INT		= 169006
	DECLARE @nContraTradeCommentID								INT		= 169007
	DECLARE @nPreclearanceNotTakenCommentID						INT		= 169006
	DECLARE @nTradedDuringBlackoutPeriodCommentID				INT		= 169006
	
	DECLARE @nOccurrenceYearly									INT = 137001
	DECLARE @nOccurrenceQuarterly								INT = 137002
	DECLARE @nOccurrenceMonthly									INT = 137003
	DECLARE @nOccurrenceWeekly									INT = 137004
	
	DECLARE @nFinancialPeriodTypeAnnual							INT = 123001
	DECLARE @nFinancialPeriodTypeHalfYearly						INT = 123002
	DECLARE @nFinancialPeriodTypeQuarterly						INT = 123003
	DECLARE @nFinancialPeriodTypeMonthly						INT = 123004
	
	DECLARE @nInsiderFlag_Insider								INT = 173001
	DECLARE @nInsiderFlag_NonInsider							INT = 173002
	
	DECLARE @nPreclearanceTakenCase INT = 176001
	DECLARE @nInsiderNotPreclearanceTakenCase INT = 176002
	DECLARE @nNonInsiderNotPreclearanceTakenCase INT = 176003
	DECLARE @nPeriodEndCase INT = 176004
	
	DECLARE	@sPrceclearanceCodePrefixText VARCHAR(200) = (SELECT CodeName FROM com_Code Where CodeId = @nPreclearanceTakenCase)
	DECLARE @sNonPrceclearanceCodePrefixText VARCHAR(200) = (SELECT CodeName FROM com_Code Where CodeId = @nInsiderNotPreclearanceTakenCase)
	DECLARE @sPrceclearanceNotRequiredPrefixText VARCHAR(200) = (SELECT CodeName FROM com_Code Where CodeId = @nNonInsiderNotPreclearanceTakenCase)
	DECLARE @sPPeriodEndRecordPrefixText VARCHAR(200) = (SELECT CodeName FROM com_Code Where CodeId = @nPeriodEndCase)

	CREATE TABLE #TempTransactionDetailsForDefaulterReport(PreclearanceRequestId INT, RequestDate DATETIME, RequestedQty DECIMAL(10,0), RequestedValue DECIMAL(10,0),
	PreclearanceApplicabletill DATETIME,PreclearanceStatusDate DATETIME, PreclearanceStatusCodeId INT, PreclearanceStatus VARCHAR(20),SecurityTypeCodeId INT,SecurityType VARCHAR(20),
	TransactionTypeCodeId INT, TransactionType VARCHAR(20),TransactionMasterId INT,DMATDetailsID INT,DEMATAccountNumber VARCHAR(100),AccountHolderName VARCHAR(50),IsPartiallyTraded BIT,ShowAddButton BIT,DisplayRollingNumber INT)
	-- Create Temp Table fpr Insert Unquie Preclearance Request ID
	
	CREATE TABLE #tmpPreclearanceID(PreclearanceID NVARCHAR(MAX))
	BEGIN TRY
	
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

        IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN
			SET @inp_sSortField = 'UserInfoID'
		END
			
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN
			SET @inp_sSortOrder = 'ASC'
		END
		

			INSERT INTO #TempTransactionDetailsForDefaulterReport(PreclearanceRequestId, RequestDate, RequestedQty, RequestedValue,
			PreclearanceApplicabletill,PreclearanceStatusDate, PreclearanceStatusCodeId, PreclearanceStatus,SecurityTypeCodeId, SecurityType,
			TransactionTypeCodeId, TransactionType,TransactionMasterId,DMATDetailsID,DEMATAccountNumber,AccountHolderName,IsPartiallyTraded, ShowAddButton, DisplayRollingNumber)
			SELECT
			PR.PreclearanceRequestId,
			PR.CreatedOn AS RequestDate,
			SecuritiesToBeTradedQty AS RequestedQty,
			SecuritiesToBeTradedValue AS RequestedValue,
			(SELECT EventDate FROM eve_EventLog WHERE MapToId=PR.PreclearanceRequestId and EventCodeId=153018),
			ELApp.EventDate AS PreclearanceStatusDate,
			PreclearanceStatusCodeId,
			CdPRStatus.CodeName AS PreclearanceStatus,
			PR.SecurityTypeCodeId,
			CSecurity.CodeName AS SecurityType,
			PR.TransactionTypeCodeId,
			CTransaction.CodeName AS TransactionType,
			MIN(TransactionMasterId) AS TransactionMasterId,
			PR.DMATDetailsID AS DMATDetailsID,
			DMATD.DEMATAccountNumber AS DEMATAccountNumber,
			UI.UserFullName AS AccountHolderName,
			PR.IsPartiallyTraded AS IsPartiallyTraded,
			PR.ShowAddButton AS ShowAddButton,
			TM.DisplayRollingNumber AS DisplayRollingNumber
			FROM tra_PreclearanceRequest PR
			JOIN tra_TransactionMaster TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId
			JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
			JOIN eve_EventLog ELApp ON ELApp.EventCodeId IN (153016) AND MapToTypeCodeId = 132004 AND ELApp.MapToId = PR.PreclearanceRequestId
			JOIN com_Code CdPRStatus ON PreclearanceStatusCodeId = CdPRStatus.CodeID
			JOIN com_Code CSecurity ON PR.SecurityTypeCodeId = CSecurity.CodeID
			JOIN com_Code CTransaction ON PR.TransactionTypeCodeId = CTransaction.CodeID
			JOIN usr_DMATDetails DMATD ON PR.DMATDetailsID = DMATD.DMATDetailsID
			JOIN vw_UserInformation UI ON DMATD.UserInfoID = UI.UserInfoId
			GROUP BY PR.PreclearanceRequestId,
			PR.CreatedOn,
			SecuritiesToBeTradedQty,
			SecuritiesToBeTradedValue,
			ELApp.EventDate,
			TP.PreClrCOApprovalLimit, 
			ELApp.EventDate,TP.PreClrApprovalValidityLimit,ELApp.EventCodeId,
			PreclearanceStatusCodeId,
			CdPRStatus.CodeName,
			PR.SecurityTypeCodeId,
			CSecurity.CodeName,
			PR.TransactionTypeCodeId,
			CTransaction.CodeName,
			PR.DMATDetailsID,
			DMATD.DEMATAccountNumber,
			UI.UserFullName,
			PR.IsPartiallyTraded,
			PR.ShowAddButton,
			TM.DisplayRollingNumber
						
			DECLARE @tmpPCLIds TABLE(PreclearanceRequestId BIGINT)
			DECLARE @tmpTransactionDetailsIds TABLE(TransactionDetailsID BIGINT)
			
			DECLARE @tmpMapTable TABLE(PeriodCode137 INT, PeriodCode123 INT)

			INSERT INTO @tmpMapTable VALUES(@nOccurrenceYearly, @nFinancialPeriodTypeAnnual), (@nOccurrenceQuarterly, @nFinancialPeriodTypeQuarterly), 
											(@nOccurrenceMonthly, @nFinancialPeriodTypeMonthly), (@nOccurrenceWeekly, @nFinancialPeriodTypeHalfYearly)
			
			INSERT INTO @tmpPCLIds(PreclearanceRequestId)
			SELECT DISTINCT PreclearanceRequestId
			FROM rpt_DefaulterReport
			WHERE PreclearanceRequestId IS NOT NULL
			
			INSERT INTO @tmpTransactionDetailsIds(TransactionDetailsID)
			SELECT DISTINCT TransactionDetailsId
			FROM rpt_DefaulterReport
			WHERE TransactionDetailsId IS NOT NULL
			
			DECLARE @tmpCommentFilter TABLE(CommentID INT)
						

			--Create Temp table
			CREATE TABLE #tmpReport(Id INT IDENTITY(1,1),DefaulterReportID BIGINT,UserInfoID BIGINT,EmployeeID NVARCHAR(50),
			InsiderName NVARCHAR(500),DateOfJoining DATETIME,DateOfInactivation DATETIME,
			CINAndDIN NVARCHAR(50),DesignationCodeID INT,Designation NVARCHAR(100),
			GradeCodeID INT,Grade NVARCHAR(100),DepartmentCodeID INT, Department NVARCHAR(500),Category VARCHAR(50), SubCategory VARCHAR(50), StatusCodeId VARCHAR(50), 
			CompanyID INT,CompanyName NVARCHAR(500),UserTypeCodeID INT,UserType NVARCHAR(200),Location NVARCHAR(500),
			Demat NVARCHAR(100), AccountHolder NVARCHAR(100),RelationWithInsider NVARCHAR(100),PreclearanceId NVARCHAR(500),PCLRequestDate DATETIME,
			PCLReqQty DECIMAL(15,4), PCLReqVal DECIMAL(15,4),PCLStatusID INT,PCLStatus NVARCHAR(100),PCLStatusDate DATETIME,PCLApplicableTill DATETIME,PCLCreated DATETIME DEFAULT NULL,
			ScripName NVARCHAR(500),ISINNumber NVARCHAR(500),
			SecurityType NVARCHAR(500), TransactionType NVARCHAR(500),TradeBuyQty DECIMAL(15,4),TradeSellQty DECIMAL(15,4),Qty DECIMAL(15,4),Value DECIMAL(15,4),
			SecurityTypeCodeId INT, TransactionTypeCodeId INT,
			TransactionDate DATETIME, DetailsSubmitDate DATETIME,DisclosureRequired INT, LastSubmissionDate DATETIME,
			ScpSubmitDate DATETIME, HcpSubmitDate DATETIME,Comments NVARCHAR(1000), HcpByCOSubmitDate DATETIME,TransactionMasterID BIGINT,TransactionDetailsId  BIGINT,
			NonComplianceTypeCodeID INT,NonComplianceType NVARCHAR(100),PreclearanceBlankComment INT,AddOtherDetails INT Default 0,
			ISParentPreclearance INT Default 0,CommentsID NVARCHAR(MAX),IsShowRecord INT,DateOfBecomingInsider DATETIME, UserPAN NVARCHAR(100))
			
		
		/*
			Insert Preclearance Record
		*/	
		
		INSERT INTO #tmpReport(DefaulterReportID,UserInfoId,EmployeeID,InsiderName,DateOfJoining,CINAndDIN,DesignationCodeID,Designation,
						GradeCodeID,Grade,DepartmentCodeID,Department,CompanyID,CompanyName,UserTypeCodeID,UserType,Location,
						Demat,AccountHolder,RelationWithInsider,PreclearanceId,PCLRequestDate,PCLReqQty,
						PCLReqVal,PCLStatusID,PCLStatus,PCLStatusDate,PCLApplicableTill,PCLCreated,ScripName,ISINNumber,
						SecurityType,TransactionType,TradeBuyQty,TradeSellQty,Qty,Value,SecurityTypeCodeId,TransactionTypeCodeId,
						TransactionDate,DetailsSubmitDate,DisclosureRequired,LastSubmissionDate,ScpSubmitDate,HcpSubmitDate,Comments,
						HcpByCOSubmitDate,TransactionMasterID,TransactionDetailsId,
						NonComplianceTypeCodeID,NonComplianceType,PreclearanceBlankComment,AddOtherDetails,ISParentPreclearance,CommentsID,DateOfBecomingInsider, DateOfInactivation, UserPAN)  
			SELECT DR.DefaulterReportID,UI.UserInfoID,UI.EmployeeId,UI.UserFullName,UI.DateofBecomingInsider,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,UI.CompanyId,UI.CompanyName,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,@sPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwPCL.DisplayRollingNumber),vwPCL.RequestDate, 
			vwPCL.RequestedQty,vwPCL.RequestedValue,vwPCL.PreclearanceStatusCodeId, vwPCL.PreclearanceStatus,vwPCL.PreclearanceStatusDate,vwPCL.PreclearanceApplicabletill,vwPCL.RequestDate,
			UI.CompanyName,ISINNumber,
			vwTD.SecurityType, vwTD.TransactionType, vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,vwIN.HcpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName, CASE WHEN DefRptCmt.Comments = '-'  THEN 1 ELSE 0 END,0,0,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation, UI.PAN
			FROM
			tra_TransactionMaster TM
			 JOIN vw_ContinuousDisclosureStatus vwIN ON TM.TransactionMasterId = vwIN.TransactionMasterId
			JOIN @tmpPCLIds PP ON TM.PreclearanceRequestId = PP.PreclearanceRequestId
			JOIN #TempTransactionDetailsForDefaulterReport vwPCL ON PP.PreclearanceRequestId = vwPCL.PreclearanceRequestId
			left join vw_TransactionDetailsForDefaulterReport vwTD ON TM.TransactionMasterId = vwTD.TransactionMasterId 
			join rpt_DefaulterReport DR ON PP.PreclearanceRequestId = DR.PreclearanceRequestId and vwTD.TransactionDetailsId = dr.TransactionDetailsId
			JOIN vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			WHERE DR.TransactionDetailsId IS NOT NULL
			

		--Fetch for PNT
		INSERT INTO #tmpReport(DefaulterReportID,UserInfoId,EmployeeID,InsiderName,DateOfJoining,CINAndDIN,DesignationCodeID,Designation,
						GradeCodeID,Grade,DepartmentCodeID,Department,CompanyID,CompanyName,UserTypeCodeID,UserType,Location,
						Demat,AccountHolder,RelationWithInsider,PreclearanceId,PCLRequestDate,PCLReqQty,
						PCLReqVal,PCLStatus,PCLStatusDate,PCLApplicableTill,PCLCreated,ScripName,ISINNumber,
						SecurityType,TransactionType,TradeBuyQty,TradeSellQty,Qty,Value,SecurityTypeCodeId,TransactionTypeCodeId,
						TransactionDate,DetailsSubmitDate,DisclosureRequired,LastSubmissionDate,ScpSubmitDate,HcpSubmitDate,Comments,
						HcpByCOSubmitDate,TransactionMasterID,TransactionDetailsId,
						NonComplianceTypeCodeID,NonComplianceType,CommentsID,DateOfBecomingInsider, DateOfInactivation, UserPAN) 
		SELECT DR.DefaulterReportID,UI.UserInfoID,UI.EmployeeId,UI.UserFullName,UI.DateofBecomingInsider,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,UI.CompanyId,UI.CompanyName,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,
			CASE WHEN UI.DateOfBecomingInsider IS NOT NULL THEN @sNonPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwIN.DisplayRollingNumber) ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(VARCHAR,vwIN.DisplayRollingNumber) END,NULL,
			NULL,NULL, NULL,NULL,NULL,NULL,
			UI.CompanyName,ISINNumber,
			vwTD.SecurityType, vwTD.TransactionType, vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,vwIN.ScpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation, UI.PAN
			FROM rpt_DefaulterReport DR
			JOIN vw_TransactionDetailsForDefaulterReport vwTD ON DR.TransactionDetailsId = vwTD.TransactionDetailsId
			LEFT JOIN vw_ContinuousDisclosureStatus vwIN ON DR.TransactionMasterId = vwIN.TransactionMasterId
			JOIN vw_UserInformation UI ON vwIN.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			WHERE DR.NonComplainceTypeCodeId = @nPreclearanceComplianceType AND DR.PreclearanceRequestId IS NULL
			

			SELECT @sSQL = ' INSERT INTO #tmpList(RowNumber, EntityID) '
		    SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',Id),Id ' 
		    SELECT @sSQL = @sSQL + ' FROM #tmpReport Temp '
		    SELECT @sSQL = @sSQL + ' LEFT JOIN rpt_DefaulterReportOverride DRO ON Temp.DefaulterReportID = DRO.DefaulterReportID '
		    SELECT @sSQL = @sSQL + ' WHERE 1 = 1  AND (Temp.DateOfInactivation IS NULL OR dbo.uf_com_GetServerDate() < Temp.DateOfInactivation)'
		    
		    SELECT @sSQL = @sSQL + ' AND Temp.Comments LIKE ''%Contra Trade%'''
		    
		    IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
		    BEGIN
			 SELECT @sSQL = @sSQL +  ' AND Temp.InsiderName like ''%' + @inp_sInsiderName + '%'''
		    END
		    
		    IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		    BEGIN
			 SELECT @sSQL = @sSQL + ' AND Temp.EmployeeId LIKE ''%' + @inp_sEmployeeID +  '%'''
		    END
		    
		    IF (@inp_sPAN IS NOT NULL AND @inp_sPAN <> '')
		    BEGIN
			 SELECT @sSQL = @sSQL +  ' AND Temp.UserPAN like ''%' + @inp_sPAN + '%'''
		    END
		    
		    IF (@inp_sDematAccountNumber IS NOT NULL AND @inp_sDematAccountNumber <> '')
		    BEGIN
			 SELECT @sSQL = @sSQL + ' AND Temp.Demat like ''%' + @inp_sDematAccountNumber + '%'''
		    END
		    
		    IF(@inp_sFromDate IS NOT NULL AND @inp_sToDate IS NOT NULL)
		    BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.DetailsSubmitDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.DetailsSubmitDate >= CAST('''  + CAST(@inp_sFromDate AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.DetailsSubmitDate IS NULL OR Temp.DetailsSubmitDate <= CAST('''  + CAST(@inp_sToDate AS VARCHAR(25)) + '''AS DATETIME) ) )'
		    END
		    ELSE IF (@inp_sFromDate IS NOT NULL AND @inp_sToDate IS NULL)
		    BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.DetailsSubmitDate IS NOT NULL AND Temp.DetailsSubmitDate >= CAST('''  + CAST(@inp_sFromDate AS VARCHAR(25)) + ''' AS DATETIME))'
		    END
		    ELSE IF (@inp_sFromDate IS NULL AND @inp_sToDate IS NOT NULL)
		    BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.DetailsSubmitDate IS NOT NULL AND Temp.DetailsSubmitDate <= CAST('''  + CAST(@inp_sToDate AS VARCHAR(25)) + '''AS DATETIME))'
		    END	
		    
		    EXEC (@sSQL)
		
			SELECT 
				Temp.DefaulterReportID,
				Temp.UserInfoID AS UserInfoID,
				Temp.PreclearanceId AS rpt_grd_50675,
				Temp.EmployeeId AS rpt_grd_50656,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.InsiderName) AS rpt_grd_50657,
				UI.DateOfInactivation,
				Temp.UserPAN AS rpt_grd_50658,
				UI.AddressLine1 AS rpt_grd_50659,
				UI.PinCode AS rpt_grd_50660,
				ISNULL(CCountryCodeId.CodeName,'-') AS rpt_grd_50661,
				UI.MobileNumber AS rpt_grd_50662,
				UI.EmailId AS rpt_grd_50663,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.CINAndDIN) AS rpt_grd_50668,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Designation) AS rpt_grd_50669,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Grade) AS rpt_grd_50670,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Location) AS rpt_grd_50671,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Department) AS rpt_grd_50672,
				dbo.uf_rpt_ReplaceSpecialChar(CCategory.CodeName) AS rpt_grd_50666,
				dbo.uf_rpt_ReplaceSpecialChar(CSubCategory.CodeName) AS rpt_grd_50667,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.CompanyName) AS rpt_grd_50664,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.UserType + CASE WHEN Temp.DateOfBecomingInsider IS NOT NULL THEN ' Insider ' ELSE '' END) AS rpt_grd_50665,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Demat) AS rpt_grd_50673,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.AccountHolder) AS rpt_grd_50674,
				dbo.uf_rpt_FormatDateValue(Temp.PCLRequestDate,0) AS rpt_grd_50676,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.SecurityType) AS rpt_grd_50677,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.TransactionType) AS rpt_grd_50678,
				Temp.TransactionMasterID AS TransactionMasterID,
				Temp.SecurityTypeCodeId AS SecurityTypeID,
				Temp.TransactionTypeCodeId AS TransactionTypeID,
				Temp.Qty AS rpt_grd_50680,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Value) AS rpt_grd_50681,
				dbo.uf_rpt_FormatDateValue(Temp.DetailsSubmitDate,0) AS rpt_grd_50679
		FROM	#tmpList T 
		JOIN #tmpReport  Temp ON T.EntityID = Temp.Id
		LEFT JOIN rpt_DefaulterReportOverride DRO ON Temp.DefaulterReportID = DRO.DefaulterReportID
		LEFT JOIN usr_UserInfo UI ON UI.UserInfoId = TEMP.UserInfoID
		LEFT join com_Code CCategory on UI.Category = CCategory.CodeID
		LEFT JOIN com_Code CSubCategory ON UI.SubCategory = CSubCategory.CodeID
		LEFT JOIN com_Code CStatusCodeId ON UI.StatusCodeId = CStatusCodeId.CodeID	
		LEFT JOIN com_Code CCountryCodeId ON UI.CountryId = CCountryCodeId.CodeID		
		WHERE Temp.Id IS NOT NULL 
		AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY NonComplianceTypeCodeID,UserInfoID,PreclearanceId,AddOtherDetails
			
		DROP TABLE #tmpPreclearanceID
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		
		DROP TABLE #tmpPreclearanceID
	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CLAWBACKREPORT
	END CATCH
END
