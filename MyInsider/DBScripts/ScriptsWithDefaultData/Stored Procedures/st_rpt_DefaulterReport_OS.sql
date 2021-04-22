IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_DefaulterReport_OS')
	DROP PROCEDURE st_rpt_DefaulterReport_OS
GO
GO
/****** Object:  StoredProcedure [dbo].[st_rpt_DefaulterReport_OS]    Script Date: 24-03-2021 10:53:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure for deafulter list other security.

Returns:		0, if Success.
				
Created by:		Sandesh L.
Created on:		09-Mar-2021

Modification History
ModifiedBy		ModifiedOn		Description
Sandesh Lande	30/03/2021		Company Name Added

---*/
CREATE PROCEDURE [dbo].[st_rpt_DefaulterReport_OS]
	 @inp_sEmployeeID								NVARCHAR(50)=''-- = 'GS1234'
	,@inp_sInsiderName								NVARCHAR(MAX)='' --= 's'
	,@inp_sDesignation								NVARCHAR(100) = ''
	,@inp_sCompanyName								NVARCHAR(200) = ''	
	,@out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	
	--Variable Declaration
	DECLARE @ERR_DEFAULTERREPORT			INT = 19316
	DECLARE @sSQL							NVARCHAR(MAX)
	
	DECLARE @nInitialComplianceType			INT = 170001
	DECLARE @nContinuousComplianceType		INT = 170002
	DECLARE @nPeriodEndComplianceType		INT = 170003
	DECLARE @nPreclearanceComplianceType	INT = 170004
	DECLARE @nRestrictedCompanyListComplianceType	INT = 170005
	
	DECLARE @nPreclearanceLevelQtyComment						INT
	DECLARE @nPreclearanceLevelValueComment						INT
	DECLARE @nNotSubmitted										INT		= 169001	--Not Added
	DECLARE @nNotSubmittedInStipulatedTime						INT		= 169002	--Not Added
	DECLARE @nTradedMoreThanPreClearanceApprovedQuantity		INT		= 169003
	DECLARE @nTradedMoreThanPreClearanceApprovedValue			INT		= 169004
	DECLARE @nTradedAfterPreclearanceDateCommentID				INT		= 169006
	DECLARE @nContraTradeCommentID								INT		= 169007
	DECLARE @nPreclearanceNotTakenCommentID						INT		= 169008
	DECLARE @nTradedDuringBlackoutPeriodCommentID				INT		= 169009
	DECLARE @nRestrictedCompanyCommentID						INT		= 169010
	
	--Declare @inp_sCommentsId NVARCHAR(200)='169003,169004,169006,169007,169008,169009,169010'

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

	CREATE TABLE #TempTransactionDetailsForDefaulterReport(PreclearanceRequestId INT, RequestDate DATETIME, RequestedQty DECIMAL(15,4), RequestedValue DECIMAL(15,4),
	PreclearanceApplicabletill DATETIME,PreclearanceStatusDate DATETIME, PreclearanceStatusCodeId INT, PreclearanceStatus VARCHAR(200),SecurityTypeCodeId INT,SecurityType VARCHAR(600),
	TransactionTypeCodeId INT, TransactionType VARCHAR(500),TransactionMasterId INT,DMATDetailsID INT,DEMATAccountNumber VARCHAR(1000),AccountHolderName NVARCHAR(1000),IsPartiallyTraded BIT,ShowAddButton BIT,DisplayRollingNumber INT,CompanyID INT)
	-- Create Temp Table fpr Insert Unquie Preclearance Request ID
	
	CREATE TABLE #tmpPreclearanceID(PreclearanceID NVARCHAR(MAX))
	CREATE TABLE #tmpList(EntityID INT)


	BEGIN TRY
	
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			DECLARE @tmpCommentFilter TABLE(CommentID INT)

			SELECT * INTO #temp_vw_UserInformation
			FROM vw_UserInformation
			
			SELECT * INTO #temp_vw_DefaulterReportComments_OS
			FROM vw_DefaulterReportComments_OS
			
			SELECT * INTO #temp_vw_InitialDisclosureStatus_OS
			FROM vw_InitialDisclosureStatus_OS
			
			SELECT * INTO #temp_vw_TransactionDetailsForDefaulterReport_OS
			FROM vw_TransactionDetailsForDefaulterReport_OS
			
			SELECT * INTO #temp_vw_PeriodEndDisclosureStatus_OS
			FROM vw_PeriodEndDisclosureStatus_OS

			SELECT * INTO #temp_vw_ContinuousDisclosureStatus_OS
			FROM vw_ContinuousDisclosureStatus_OS
			
			DECLARE @CompanyString NVARCHAR(500)
			DECLARE @ISINString NVARCHAR(50)
			CREATE TABLE #tmpISIN
			(
				ID INT IDENTITY(1,1),
				ISINString nvarchar(50)
			)

			INSERT INTO #tmpISIN
			SELECT * FROM FN_VIGILANTE_SPLIT(@inp_sCompanyName,'-(')
			SELECT @CompanyString = ISINString FROM #tmpISIN WHERE ID = 1
			SELECT @ISINString = ISINString FROM #tmpISIN WHERE ID = 2
		
			INSERT INTO #TempTransactionDetailsForDefaulterReport(PreclearanceRequestId, RequestDate ,
			RequestedQty, RequestedValue,
			PreclearanceApplicabletill,PreclearanceStatusDate,
			PreclearanceStatusCodeId, 
			PreclearanceStatus,
			SecurityTypeCodeId, 
			SecurityType,
			TransactionTypeCodeId, 
			TransactionType,TransactionMasterId,DMATDetailsID,DEMATAccountNumber,AccountHolderName,IsPartiallyTraded, ShowAddButton, DisplayRollingNumber,CompanyID
			)
			SELECT
			PR.PreclearanceRequestId,
			PR.CreatedOn AS RequestDate,
			SecuritiesToBeTradedQty AS RequestedQty,
			SecuritiesToBeTradedValue AS RequestedValue,
			(SELECT EventDate FROM eve_EventLog WHERE MapToId=PR.PreclearanceRequestId and EventCodeId=153067),
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
			TM.DisplayRollingNumber AS DisplayRollingNumber,
			PR.CompanyId AS CompanyID
			FROM tra_PreclearanceRequest_NonImplementationCompany PR
			JOIN tra_TransactionMaster_OS TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId
			JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
			JOIN eve_EventLog ELApp ON ELApp.EventCodeId IN (153046) AND MapToTypeCodeId = 132015 AND ELApp.MapToId = PR.PreclearanceRequestId
			JOIN com_Code CdPRStatus ON PreclearanceStatusCodeId = CdPRStatus.CodeID
			JOIN com_Code CSecurity ON PR.SecurityTypeCodeId = CSecurity.CodeID
			JOIN com_Code CTransaction ON PR.TransactionTypeCodeId = CTransaction.CodeID
			JOIN usr_DMATDetails DMATD ON PR.DMATDetailsID = DMATD.DMATDetailsID
			JOIN #temp_vw_UserInformation UI ON DMATD.UserInfoID = UI.UserInfoId
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
			TM.DisplayRollingNumber,
			PR.CompanyId
		
			DECLARE @tmpPCLIds TABLE(PreclearanceRequestId BIGINT)
			DECLARE @tmpTransactionDetailsIds TABLE(TransactionDetailsID BIGINT)
			
			DECLARE @tmpMapTable TABLE(PeriodCode137 INT, PeriodCode123 INT)

			INSERT INTO @tmpMapTable VALUES(@nOccurrenceYearly, @nFinancialPeriodTypeAnnual), (@nOccurrenceQuarterly, @nFinancialPeriodTypeQuarterly), 
											(@nOccurrenceMonthly, @nFinancialPeriodTypeMonthly), (@nOccurrenceWeekly, @nFinancialPeriodTypeHalfYearly)
			
			INSERT INTO @tmpPCLIds(PreclearanceRequestId)
			SELECT DISTINCT PreclearanceRequestId
			FROM rpt_DefaulterReport_OS
			WHERE PreclearanceRequestId IS NOT NULL
			
			INSERT INTO @tmpTransactionDetailsIds(TransactionDetailsID)
			SELECT DISTINCT TransactionDetailsId
			FROM rpt_DefaulterReport_OS
			WHERE TransactionDetailsId IS NOT NULL
			
			
			
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
			ScpSubmitDate DATETIME, HcpSubmitDate NVARCHAR(500),Comments NVARCHAR(1000), HcpByCOSubmitDate DATETIME,TransactionMasterID BIGINT,TransactionDetailsId  BIGINT,
			NonComplianceTypeCodeID INT,NonComplianceType NVARCHAR(100),PreclearanceBlankComment INT,AddOtherDetails INT Default 0,
			ISParentPreclearance INT Default 0,CommentsID NVARCHAR(MAX),IsShowRecord INT,DateOfBecomingInsider DATETIME)
		
			/*
				Insert Initial Disclosure Record
				
			*/
			INSERT INTO #tmpReport(UserInfoId,DefaulterReportID,EmployeeID,InsiderName,DateOfJoining,CINAndDIN,DesignationCodeID,Designation,
						GradeCodeID,Grade,DepartmentCodeID,Department,CompanyID,CompanyName,UserTypeCodeID,UserType,Location,
						Demat,AccountHolder,RelationWithInsider,PreclearanceId,PCLRequestDate,PCLReqQty,
						PCLReqVal,PCLStatus,PCLStatusDate,PCLApplicableTill,ScripName,ISINNumber,
						SecurityType,TransactionType,TradeBuyQty,TradeSellQty,Qty,Value,SecurityTypeCodeId,TransactionTypeCodeId,
						TransactionDate,DetailsSubmitDate,DisclosureRequired,LastSubmissionDate,ScpSubmitDate,HcpSubmitDate,Comments,
						HcpByCOSubmitDate,TransactionMasterID,TransactionDetailsId,
						NonComplianceTypeCodeID,NonComplianceType,CommentsID,DateOfBecomingInsider,DateOfInactivation)  
						
			SELECT DISTINCT UI.UserInfoID,DR.DefaulterReportID,UI.EmployeeId,UI.UserFullName,UI.DateofBecomingInsider,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,vwTD.CompanyId,NULL,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,vwTD.Relation,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			vwTD.SecurityType,'Holding', vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,
			CASE	WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 1 THEN 'Pending'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.ScpSubmitStatus = 0 AND vwIn.SoftCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),' ','/'))) ELSE '-' 
				END,
			--vwIN.HcpSubmitDate,
			DefRptCmt.Comments,Null,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM rpt_DefaulterReport_OS DR
			JOIN #temp_vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN #temp_vw_DefaulterReportComments_OS DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
		    LEFT JOIN #temp_vw_InitialDisclosureStatus_OS vwIN ON DR.UserInfoID = vwIN.UserInfoId AND DetailsSubmitStatus <> 0
			LEFT JOIN #temp_vw_TransactionDetailsForDefaulterReport_OS vwTD ON vwIN.TransactionMasterId = vwTD.TransactionMasterId	
			WHERE DR.NonComplainceTypeCodeId = @nInitialComplianceType
			ORDER BY UI.UserInfoID
			
			
			--Insert Period End Disclosure Record
			INSERT INTO #tmpReport(UserInfoId,DefaulterReportID,EmployeeID,InsiderName,DateOfJoining,CINAndDIN,DesignationCodeID,Designation,
						GradeCodeID,Grade,DepartmentCodeID,Department,CompanyID,CompanyName,UserTypeCodeID,UserType,Location,
						Demat,AccountHolder,RelationWithInsider,PreclearanceId,PCLRequestDate,PCLReqQty,
						PCLReqVal,PCLStatus,PCLStatusDate,PCLApplicableTill,ScripName,ISINNumber,
						SecurityType,TransactionType,TradeBuyQty,TradeSellQty,Qty,Value,SecurityTypeCodeId,TransactionTypeCodeId,
						TransactionDate,DetailsSubmitDate,DisclosureRequired,LastSubmissionDate,ScpSubmitDate,HcpSubmitDate,Comments,
						HcpByCOSubmitDate,
						TransactionMasterId,TransactionDetailsId,
						NonComplianceTypeCodeID,NonComplianceType,CommentsID,DateOfBecomingInsider,DateOfInactivation)  						
		
			SELECT UI.UserInfoID,DR.DefaulterReportID,UI.EmployeeId,UI.UserFullName,UI.DateOfJoining,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,vwTD.CompanyId,NULL,UI.UserTypeCodeId,UI.UserType,
			UI.Location,NULL,NULL,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL, NULL, NULL , NULL, NULL, NULL, 
			NULL, NULL,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,
			CASE	WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 1 THEN 'Pending'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.ScpSubmitStatus = 0 AND vwIn.SoftCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),' ','/'))) ELSE '-' 
				END,
			--vwIN.HcpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM rpt_DefaulterReport_OS DR
			JOIN tra_TransactionMaster_OS TM ON DR.TransactionMasterId = TM.TransactionMasterId
			JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
			JOIN @tmpMapTable tmpMap ON TP.DiscloPeriodEndFreq = tmpMap.PeriodCode137
			JOIN #temp_vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			JOIN #temp_vw_DefaulterReportComments_OS DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID			
			LEFT JOIN #temp_vw_PeriodEndDisclosureStatus_OS vwIN ON DR.TransactionMasterId = vwIN.TransactionMasterId AND DetailsSubmitStatus <> 0
			LEFT JOIN #temp_vw_TransactionDetailsForDefaulterReport_OS vwTD ON vwIN.TransactionMasterId = vwTD.TransactionMasterId	
			WHERE DR.NonComplainceTypeCodeId = @nPeriodEndComplianceType
			ORDER BY UI.UserInfoID
			
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
						NonComplianceTypeCodeID,NonComplianceType,PreclearanceBlankComment,AddOtherDetails,ISParentPreclearance,CommentsID,DateOfBecomingInsider, DateOfInactivation)  
			SELECT DR.DefaulterReportID,UI.UserInfoID,UI.EmployeeId,UI.UserFullName,UI.DateofBecomingInsider,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,vwPCL.CompanyId,NULL,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,@sPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwPCL.PreclearanceRequestId),vwPCL.RequestDate, 
			vwPCL.RequestedQty,vwPCL.RequestedValue,vwPCL.PreclearanceStatusCodeId, vwPCL.PreclearanceStatus,vwPCL.PreclearanceStatusDate,vwPCL.PreclearanceApplicabletill,vwPCL.RequestDate,
			NULL,NULL,
			vwTD.SecurityType, vwTD.TransactionType, vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,
			CASE	WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 1 THEN 'Pending'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.ScpSubmitStatus = 0 AND vwIn.SoftCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),' ','/'))) ELSE '-' 
				END,
			--vwIN.HcpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName, CASE WHEN DefRptCmt.Comments = '-'  THEN 1 ELSE 0 END,0,0,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation
			FROM
			tra_TransactionMaster_OS TM
			 JOIN #temp_vw_ContinuousDisclosureStatus_OS vwIN ON TM.TransactionMasterId = vwIN.TransactionMasterId
			JOIN @tmpPCLIds PP ON TM.PreclearanceRequestId = PP.PreclearanceRequestId
			JOIN #TempTransactionDetailsForDefaulterReport vwPCL ON PP.PreclearanceRequestId = vwPCL.PreclearanceRequestId
			left join #temp_vw_TransactionDetailsForDefaulterReport_OS vwTD ON TM.TransactionMasterId = vwTD.TransactionMasterId 
			join rpt_DefaulterReport_OS DR ON PP.PreclearanceRequestId = DR.PreclearanceRequestId and vwTD.TransactionDetailsId = dr.TransactionDetailsId
			JOIN #temp_vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN #temp_vw_DefaulterReportComments_OS DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID			
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			where DR.TransactionDetailsId is not null
			
			
			UNION
			SELECT NULL,UI.UserInfoID,UI.EmployeeId,UI.UserFullName,UI.DateofBecomingInsider,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,vwPCL.CompanyId,NULL,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,@sPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwPCL.PreclearanceRequestId),vwPCL.RequestDate, 
			vwPCL.RequestedQty,vwPCL.RequestedValue,vwPCL.PreclearanceStatusCodeId, vwPCL.PreclearanceStatus,vwPCL.PreclearanceStatusDate,vwPCL.PreclearanceApplicabletill,vwPCL.RequestDate,
			NULL,NULL,
			vwTD.SecurityType, vwTD.TransactionType, vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,
			CASE	WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 1 THEN 'Pending'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.ScpSubmitStatus = 0 AND vwIn.SoftCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),' ','/'))) ELSE '-' 
				END,
			--vwIN.HcpSubmitDate,
			null,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName, 1,1,0,NULL,UI.DateOfBecomingInsider, UI.DateOfInactivation
			FROM
			tra_TransactionMaster_OS TM
			 JOIN #temp_vw_ContinuousDisclosureStatus_OS vwIN ON TM.TransactionMasterId = vwIN.TransactionMasterId  
			JOIN @tmpPCLIds PP ON TM.PreclearanceRequestId = PP.PreclearanceRequestId
			JOIN #TempTransactionDetailsForDefaulterReport vwPCL ON PP.PreclearanceRequestId = vwPCL.PreclearanceRequestId			
			left join #temp_vw_TransactionDetailsForDefaulterReport_OS vwTD ON TM.TransactionMasterId = vwTD.TransactionMasterId 
			join rpt_DefaulterReport_OS DR ON PP.PreclearanceRequestId = DR.PreclearanceRequestId 
			JOIN #temp_vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID 
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			where DR.TransactionDetailsId IS NULL 
			AND vwPCL.IsPartiallyTraded = 1 
			AND vwPCL.ShowAddButton = 1
			AND vwTD.TransactionDetailsId NOT IN (SELECT TransactionDetailsID FROM @tmpTransactionDetailsIds)
			
			--com
			UNION
			SELECT DR.DefaulterReportID,UI.UserInfoID,UI.EmployeeId,UI.UserFullName,UI.DateofBecomingInsider,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,vwPCL.CompanyId,NULL,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwPCL.DEMATAccountNumber,vwPCL.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,@sPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwPCL.PreclearanceRequestId),vwPCL.RequestDate, 
			vwPCL.RequestedQty,vwPCL.RequestedValue,vwPCL.PreclearanceStatusCodeId, vwPCL.PreclearanceStatus,vwPCL.PreclearanceStatusDate,vwPCL.PreclearanceApplicabletill,vwPCL.RequestDate,
			NULL,NULL,
			NULL, NULL,NULL , NULL, NULL, NULL, 
			NULL, NULL,
			NULL,NULL,
		    NULL,NULL,NULL,'-',
			DefRptCmt.Comments,NULL,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,CASE WHEN DefRptCmt.Comments = '-'  THEN 1 ELSE 0 END,0,1,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM @tmpPCLIds PCLIds 
			JOIN rpt_DefaulterReport_OS DR ON PCLIds.PreclearanceRequestId = DR.PreclearanceRequestId AND DR.TransactionDetailsId IS NULL
			JOIN #temp_vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN #temp_vw_DefaulterReportComments_OS DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID			
			LEFT JOIN #TempTransactionDetailsForDefaulterReport vwPCL ON PCLIds.PreclearanceRequestId = vwPCL.PreclearanceRequestId
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			WHERE DR.NonComplainceTypeCodeId = @nPreclearanceComplianceType
			ORDER BY UI.UserInfoID,@sPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwPCL.PreclearanceRequestId)


	
		--Fetch for PNT
		INSERT INTO #tmpReport(DefaulterReportID,UserInfoId,EmployeeID,InsiderName,DateOfJoining,CINAndDIN,DesignationCodeID,Designation,
						GradeCodeID,Grade,DepartmentCodeID,Department,CompanyID,CompanyName,UserTypeCodeID,UserType,Location,
						Demat,AccountHolder,RelationWithInsider,PreclearanceId,PCLRequestDate,PCLReqQty,
						PCLReqVal,PCLStatus,PCLStatusDate,PCLApplicableTill,PCLCreated,ScripName,ISINNumber,
						SecurityType,TransactionType,TradeBuyQty,TradeSellQty,Qty,Value,SecurityTypeCodeId,TransactionTypeCodeId,
						TransactionDate,DetailsSubmitDate,DisclosureRequired,LastSubmissionDate,ScpSubmitDate,HcpSubmitDate,Comments,
						HcpByCOSubmitDate,TransactionMasterID,TransactionDetailsId,
						NonComplianceTypeCodeID,NonComplianceType,CommentsID,DateOfBecomingInsider, DateOfInactivation) 
		SELECT DR.DefaulterReportID,UI.UserInfoID,UI.EmployeeId,UI.UserFullName,UI.DateofBecomingInsider,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,vwTD.CompanyId,NULL,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,
			CASE WHEN UI.DateOfBecomingInsider IS NOT NULL THEN @sNonPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwIN.DisplayRollingNumber) ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(VARCHAR,vwIN.DisplayRollingNumber) END,NULL,
			NULL,NULL, NULL,NULL,NULL,NULL,
			NULL,NULL,
			vwTD.SecurityType, vwTD.TransactionType, vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,
			CASE	WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 1 THEN 'Pending'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.ScpSubmitStatus = 0 AND vwIn.SoftCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),' ','/'))) ELSE '-' 
				END,
			--vwIN.HcpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM rpt_DefaulterReport_OS DR
			JOIN #temp_vw_TransactionDetailsForDefaulterReport_OS vwTD ON DR.TransactionDetailsId = vwTD.TransactionDetailsId			
			LEFT JOIN #temp_vw_ContinuousDisclosureStatus_OS vwIN ON DR.TransactionMasterId = vwIN.TransactionMasterId
			JOIN #temp_vw_UserInformation UI ON vwIN.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN #temp_vw_DefaulterReportComments_OS DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			WHERE DR.NonComplainceTypeCodeId = @nPreclearanceComplianceType			
			AND DR.PreclearanceRequestId IS NULL
			

			---This UNION ADDED for @nContinuousComplianceType
			UNION
			
			SELECT DR.DefaulterReportID,UI.UserInfoID,UI.EmployeeId,UI.UserFullName,UI.DateofBecomingInsider,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,vwTD.CompanyId,NULL,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,
			CASE WHEN UI.DateOfBecomingInsider IS NOT NULL THEN @sNonPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwIN.DisplayRollingNumber) ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(VARCHAR,vwIN.DisplayRollingNumber) END,NULL,
			NULL,NULL, NULL,NULL,NULL,NULL,
			NULL,NULL,
			vwTD.SecurityType, vwTD.TransactionType, vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,
			CASE	WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 1 THEN 'Pending'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.ScpSubmitStatus = 0 AND vwIn.SoftCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),' ','/'))) ELSE '-' 
				END,
			--vwIN.HcpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM rpt_DefaulterReport_OS DR
			JOIN #temp_vw_TransactionDetailsForDefaulterReport_OS vwTD ON DR.TransactionDetailsId = vwTD.TransactionDetailsId			
			LEFT JOIN #temp_vw_ContinuousDisclosureStatus_OS vwIN ON DR.TransactionMasterId = vwIN.TransactionMasterId
			JOIN #temp_vw_UserInformation UI ON vwIN.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN #temp_vw_DefaulterReportComments_OS DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			WHERE DR.NonComplainceTypeCodeId = @nContinuousComplianceType

			UNION

			SELECT DR.DefaulterReportID,UI.UserInfoID,UI.EmployeeId,UI.UserFullName,UI.DateOfJoining,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,vwTD.CompanyId,NULL,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,@sPPeriodEndRecordPrefixText,NULL,
			NULL,NULL, NULL,NULL,NULL,NULL,
			NULL,NULL,
			vwTD.SecurityType, vwTD.TransactionType, vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,
			CASE	WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 1 THEN 'Pending'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.ScpSubmitStatus = 0 AND vwIn.SoftCopyReq = 0 THEN 'Not Required'
					WHEN vwIn.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),' ','/'))) ELSE '-' 
				END,
			--vwIN.HcpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM rpt_DefaulterReport_OS DR
			 JOIN #temp_vw_PeriodEndDisclosureStatus_OS vwIN ON DR.TransactionMasterId = vwIN.TransactionMasterId
			JOIN #temp_vw_UserInformation UI ON vwIN.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN #temp_vw_DefaulterReportComments_OS DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
			JOIN #temp_vw_TransactionDetailsForDefaulterReport_OS vwTD ON DR.TransactionDetailsId = vwTD.TransactionDetailsId
			
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			WHERE DR.NonComplainceTypeCodeId = @nPreclearanceComplianceType 
			AND DR.PreclearanceRequestId IS NULL
			ORDER BY UI.UserInfoID
		
		---Restricted list
		INSERT INTO #tmpReport(UserInfoId,DefaulterReportID,EmployeeID,InsiderName,DateOfJoining,CINAndDIN,DesignationCodeID,Designation,
						GradeCodeID,Grade,DepartmentCodeID,Department,CompanyID,CompanyName,UserTypeCodeID,UserType,Location,
						Demat,AccountHolder,RelationWithInsider,PreclearanceId,PCLRequestDate,PCLReqQty,
						PCLReqVal,PCLStatus,PCLStatusDate,PCLApplicableTill,ScripName,ISINNumber,
						SecurityType,TransactionType,TradeBuyQty,TradeSellQty,Qty,Value,SecurityTypeCodeId,TransactionTypeCodeId,
						TransactionDate,DetailsSubmitDate,DisclosureRequired,LastSubmissionDate,ScpSubmitDate,HcpSubmitDate,Comments,
						HcpByCOSubmitDate,
						TransactionMasterId,TransactionDetailsId,
						NonComplianceTypeCodeID,NonComplianceType,CommentsID,DateOfBecomingInsider,DateOfInactivation)

		SELECT UI.UserInfoID,DR.DefaulterReportID,UI.EmployeeId,UI.UserFullName,UI.DateOfJoining,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,vwTD.CompanyId,NULL,UI.UserTypeCodeId,UI.UserType,
			UI.Location,NULL,NULL,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,NULL,NULL,NULL,NULL,NULL,NULL,NULL,CM.CompanyName,CM.ISINCode
			,NULL, NULL, NULL , NULL, NULL, NULL, 
			NULL, NULL,
			NULL,NULL,
		    NULL,DR.LastSubmissionDate,NULL,'-',
			DefRptCmt.Comments,NULL,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM rpt_DefaulterReport_OS DR
			JOIN tra_TransactionMaster_OS TM ON DR.TransactionMasterId = TM.TransactionMasterId
			JOIN tra_TransactionDetails_OS TD ON DR.TransactionMasterId = TD.TransactionMasterId
			LEFT JOIN rl_CompanyMasterList CM ON CM.RlCompanyId = TD.CompanyId			
			JOIN #temp_vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			JOIN #temp_vw_DefaulterReportComments_OS DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			LEFT JOIN #temp_vw_TransactionDetailsForDefaulterReport_OS vwTD ON DR.TransactionDetailsId = vwTD.TransactionDetailsId
			WHERE DR.NonComplainceTypeCodeId = @nRestrictedCompanyListComplianceType
			ORDER BY UI.UserInfoID
		
		
		--IF @inp_sCommentsId IS NOT NULL AND @inp_sCommentsId <> ''
		--	BEGIN
				--Insert Comma Separed Comment in 
				--INSERT INTO @tmpCommentFilter(CommentID)
				--SELECT * FROM uf_com_Split(@inp_sCommentsId)
				
				--IF EXISTS(SELECT CommentID FROM @tmpCommentFilter WHERE CommentID IN(@nTradedMoreThanPreClearanceApprovedQuantity,@nTradedMoreThanPreClearanceApprovedValue))
				--BEGIN
				--	SET @nPreclearanceLevelQtyComment = 1
				--END
				
				--IF EXISTS(SELECT CommentID FROM @tmpCommentFilter WHERE CommentID IN(@nTradedAfterPreclearanceDateCommentID,
				--@nContraTradeCommentID,@nPreclearanceNotTakenCommentID,@nTradedDuringBlackoutPeriodCommentID))
				--BEGIN
				--	SET @nPreclearanceLevelValueComment = 1
				--END
				
			--END

			--UPDATE  T
			--SET IsShowRecord = 1
			--FROM #tmpReport T
			--JOIN rpt_DefaulterReportComments_OS DRC ON T.DefaulterReportID = DRC.DefaulterReportID
			--JOIN @tmpCommentFilter TCF ON DRC.CommentCodeId = TCF.CommentID
			
			--SELECT @nPreclearanceLevelQtyComment
			
			--IF(@nPreclearanceLevelQtyComment = 1)
			--BEGIN
			--	UPDATE  T
			--	SET IsShowRecord = 1
			--	FROM #tmpReport T
			--	JOIN (SELECT T1.PreclearanceId AS PreclearanceId FROM #tmpReport T1
			--		JOIN rpt_DefaulterReportComments_OS DRC ON T1.DefaulterReportID = DRC.DefaulterReportID
			--		JOIN @tmpCommentFilter TCF ON DRC.CommentCodeId = TCF.CommentID
			--	) EL ON T.PreclearanceId = EL.PreclearanceId
			--END
			
			--Update precleance comment level row
			--IF(@nPreclearanceLevelValueComment = 1)
			--BEGIN
			--	UPDATE  T
			--	SET IsShowRecord = 1
			--	FROM #tmpReport T
			--	JOIN (SELECT T1.PreclearanceId AS PreclearanceId FROM #tmpReport T1
			--		JOIN rpt_DefaulterReportComments_OS DRC ON T1.DefaulterReportID = DRC.DefaulterReportID
			--		JOIN @tmpCommentFilter TCF ON DRC.CommentCodeId = TCF.CommentID
			--	) EL ON T.PreclearanceId = EL.PreclearanceId 
			--	WHERE T.ISParentPreclearance = 1
			--END

			--select ScripName,TransactionDetailsId,* from #tmpReport

			UPDATE  T
			SET T.ScripName = CM.CompanyName,
			--T.CompanyName=CM.CompanyName,
			T.ISINNumber=CM.ISINCode
			FROM #tmpReport T
			--JOIN tra_TransactionDetails_OS TD ON T.TransactionDetailsId = TD.TransactionDetailsId
			JOIN rl_CompanyMasterList CM ON T.CompanyId= CM.RlCompanyId

			 
			UPDATE  T
			SET T.ScripName = CM.CompanyName,
			T.ISINNumber=CM.ISINCode
			FROM #tmpReport T
			JOIN rpt_DefaulterReport_OS DR ON T.DefaulterReportID=DR.DefaulterReportID
			JOIN #temp_vw_TransactionDetailsForDefaulterReport_OS vwTD ON DR.TransactionMasterId = vwTD.TransactionMasterId 			
			JOIN rl_CompanyMasterList CM ON  vwTD.CompanyId=CM.RlCompanyId
			WHERE T.ScripName IS NULL

		
		SELECT @sSQL = ' INSERT INTO #tmpList(EntityID) '
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT Id ' 
		SELECT @sSQL = @sSQL + ' FROM #tmpReport Temp '
		SELECT @sSQL = @sSQL + ' LEFT JOIN rpt_DefaulterReport_OS DRO ON Temp.DefaulterReportID = DRO.DefaulterReportID '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '
		SELECT @sSQL = @sSQL + 'AND (Temp.DateOfInactivation IS NULL OR dbo.uf_com_GetServerDate() < Temp.DateOfInactivation)'
		
		IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.EmployeeId LIKE ''%' + @inp_sEmployeeID +  '%'''
		END
		
		IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
		BEGIN
			SELECT @sSQL = @sSQL +  ' AND Temp.InsiderName like N''%' + @inp_sInsiderName + '%'''
		END
		
		IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
		BEGIN			
			SET @CompanyString = RTRIM(@CompanyString)
			SET @ISINString = SUBSTRING(@ISINString,2,12)
			
			SELECT @sSQL = @sSQL + ' AND Temp.ScripName like ''%' + @CompanyString + '%'' AND Temp.ISINNumber like ''%'+ @ISINString + '%'' '
		END

		IF (@inp_sDesignation IS NOT NULL AND @inp_sDesignation <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.Designation like N''%'  + @inp_sDesignation + '%'''
		END
				
		EXEC (@sSQL)
				
			SELECT 
				Temp.DefaulterReportID,				
				Temp.UserInfoID AS UserInfoID,
				Temp.PreclearanceId AS PreclearanceId,
				Temp.EmployeeId AS EmployeeId,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.InsiderName) AS InsiderName,
				dbo.uf_rpt_FormatDateValue(Temp.DateOfJoining,0) AS DateOfJoining,
				UI.DateOfInactivation,
				Temp.CINAndDIN AS CINAndDIN,
				Temp.Designation AS Designation,
				Temp.Grade AS Grade,
				Temp.Location AS 'Location',
				Temp.Department AS Department,
				CCategory.CodeName AS Category,
				CSubCategory.CodeName AS SubCategory,
				CStatusCodeId.CodeName AS 'Status',
				Temp.UserType + CASE WHEN Temp.DateOfBecomingInsider IS NOT NULL THEN ' Insider ' ELSE '' END AS UserType,
				Temp.Demat AS Demat,
				Temp.AccountHolder AS AccountHolder,
				Temp.RelationWithInsider AS RelationWithInsider,
				dbo.uf_rpt_FormatDateValue(Temp.PCLRequestDate,0) AS PCLRequestDate,
				Temp.PCLReqQty AS PCLReqQty,
				Temp.PCLReqVal AS PCLReqVal,
				Temp.PCLStatus AS PCLStatus,
				dbo.uf_rpt_FormatDateValue(Temp.PCLStatusDate,0) AS PCLStatusDate,
				dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatDateValue(Temp.PCLApplicableTill,0)) AS PCLApplicableTill,
				Temp.ScripName AS CompanyName,
				Temp.ISINNumber AS ISINNumber,
				Temp.SecurityType AS SecurityType,
				Temp.TransactionType AS TransactionType,
				Temp.TradeBuyQty AS TradeBuyQty,
				Temp.TradeSellQty AS TradeSellQty,
				Temp.Qty AS Qty,
				Temp.Value AS 'Value',
				dbo.uf_rpt_FormatDateValue(Temp.TransactionDate,0) AS TransactionDate,
				dbo.uf_rpt_FormatDateValue(Temp.DetailsSubmitDate,0) AS DetailsSubmitDate,
				Temp.DisclosureRequired AS DisclosureRequired,
				dbo.uf_rpt_FormatDateValue(Temp.LastSubmissionDate,0) AS LastSubmissionDate,
				dbo.uf_rpt_FormatDateValue(Temp.ScpSubmitDate,0) AS SoftCopySubmitDate,
				dbo.uf_rpt_ReplaceSpecialChar(HcpSubmitDate) AS HardCopySubmitDate,
				--dbo.uf_rpt_FormatDateValue(Temp.HcpSubmitDate,0) AS HardCopySubmitDate,
				Temp.Comments AS Comments,
				--dbo.uf_rpt_FormatDateValue(Temp.HcpByCOSubmitDate,0) AS HcpByCOSubmitDate,
				Temp.NonComplianceType AS NonComplianceType,
				--CASE WHEN DRO.IsRemovedFromNonCompliance  = 1 THEN 1 ELSE NULL END  AS ISRemoveFromList,
				Temp.PreclearanceBlankComment AS PreclearanceBlankComment,
				Temp.AddOtherDetails AS AddOtherDetails,
				Temp.ISParentPreclearance As ISParentPreclearance,
				Temp.IsShowRecord As IsShowRecord
		FROM	#tmpList T 
		JOIN #tmpReport  Temp ON T.EntityID = Temp.Id
		LEFT JOIN rpt_DefaulterReport_OS DRO ON Temp.DefaulterReportID = DRO.DefaulterReportID
		LEFT JOIN usr_UserInfo UI ON UI.UserInfoId = TEMP.UserInfoID
		LEFT join com_Code CCategory on UI.Category = CCategory.CodeID
		LEFT JOIN com_Code CSubCategory ON UI.SubCategory = CSubCategory.CodeID
		LEFT JOIN com_Code CStatusCodeId ON UI.StatusCodeId = CStatusCodeId.CodeID	
		WHERE Temp.Id IS NOT NULL		
		ORDER BY NonComplianceTypeCodeID,UserInfoID,PreclearanceId,AddOtherDetails--T.RowNumber	

		DROP TABLE #tmpPreclearanceID
		DROP TABLE #temp_vw_UserInformation
		DROP TABLE #temp_vw_DefaulterReportComments_OS
		DROP TABLE #temp_vw_InitialDisclosureStatus_OS
		DROP TABLE #temp_vw_TransactionDetailsForDefaulterReport_OS
		DROP TABLE #temp_vw_PeriodEndDisclosureStatus_OS
		DROP TABLE #temp_vw_ContinuousDisclosureStatus_OS
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		
		DROP TABLE #tmpPreclearanceID
	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE() + ' occurred at Line_Number: ' + CAST(ERROR_LINE() AS VARCHAR(50))
		SET @out_nReturnValue	=  @ERR_DEFAULTERREPORT
	END CATCH
END
