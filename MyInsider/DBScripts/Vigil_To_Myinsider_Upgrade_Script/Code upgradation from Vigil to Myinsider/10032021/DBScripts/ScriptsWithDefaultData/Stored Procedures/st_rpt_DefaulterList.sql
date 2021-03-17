IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_DefaulterList')
DROP PROCEDURE [dbo].[st_rpt_DefaulterList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure for deafulter list.

Returns:		0, if Success.
				
Created by:		Tushar
Created on:		21-Sep-2015

Modification History:
Modified By		Modified On		Description
Tushar			06-Oct-2015		Change condition for paging.
Tushar			07-Oct-2015		Change in query.
Tushar			08-Oct-2015		Return PreclearanceID  & filter condition.
Tushar			16-Oct-2015		New filter add 
Tushar			16-Oct-2015		New filter add for Comment search and period end summary data show
Raghvendra		29-Oct-2015		Change to call the date formatting using a DB scalar function
Tushar			30-Oct-2015		Company Multiple select search add.
Tushar			31-Oct-2015		Demat and acount holder details set null in case of period end disclousres.
Raghvendra		6-Nov-2015		Changes for showing NA for the fields specified in excel sheet provided by ED team in Mantis bug no 7889
ED				4-Jan-2016		Code integration done on 4-Jan-2016
Tushar			09=Jan-2016		Changes for showing Employee Insider as separate type
Gaurishankar	14-Jan-2016		Changes for Mantis Bug id=8475 : 	The user who is updated as Separated but is active as per settings made in "Update Separation" details, is not displayed under any report.
								The user who is seperated but as per "DateOfInactivation" still active in application, should be displayed in all the reports.
ED				4-Feb-2016		Code integration done on 4-Feb-2016
Tushar			23-Mar-2016		After submitting the trade details in Continuous Disclosures of Non-Insider Employee, 
								system is giving an ID is "PNR<no.>". 
								& Insider Employee its shows "PNT<no.>". & Preclearance case show "PCL<no.>".
								all text fetch from com code table.
Tushar			29-Mar-2016		Dummy entries remove when preclearance case.
Raghvendra		1-Apr-2016		Fix for mantis issue no 8475 i.e. Sapreated users which are inactive should not be seen in any of the reports.
Tushar			13-May-2016		Mantis Bugs:- Resolved Wrong value is displayed in "Relation with Insider" column.	
Tushar			17-May-2016		1. Add New Column Display Sequential Number for Continuous Disclosure.
								2. For PNT/PNR:-When Transaction Submit Increment Above Column & save in table.
								3.For PCL:- When Pre clearance request raised Increment Above Column & save in table.
								4.For Display Rolling Number logic is as follows:-
									 A) If Pre clearance  Transaction is raised then show dIsplay number as "PCL + <DisplayRollingNumber>".
									 B) For continuous disclosure records for Insider show  "PNT"  before the transaction is submitted & after submission show "PNT +    	<DisplayRollingNumber>".                                                      
									 C) For continuous disclosure for employee non insider show  PNR before transaction is submitted and show "PNR + <DisplayRollingNumber>" after the transaction is submitted.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC 

DECLARE	@return_value int,
		@out_iTotalRecords int,
		@out_nReturnValue int,
		@out_nSQLErrCode int,
		@out_sSQLErrMessage varchar(500)
declare @dt datetime  = DATEADD(day,-17,dbo.uf_com_GetServerDate())
EXEC	@return_value = [dbo].[st_com_PopulateGrid]
		@inp_iGridType = 114078,
		@inp_iPageSize = 1000,
		@inp_iPageNo = 1,
		@inp_sSortField = null,
		@inp_sSortOrder = null,
		@inp_sParam1 = 33,--'2',
		@inp_sParam2 = null,--'612',
		@inp_sParam3 = NULL,
		@inp_sParam4 = NULL,
		@inp_sParam5 = NULL,
		@inp_sParam6 = NULL,
		@inp_sParam7 = NULL,
		@inp_sParam8 = null,
		@inp_sParam9 = NULL,
		@inp_sParam10 = NULL,
		@inp_sParam11 = NULL,
		@inp_sParam12 = null,
		@inp_sParam13 = NULL,
		@inp_sParam14 = null,
		@inp_sParam15 = NULL,
		@inp_sParam16 = NULL,
		@inp_sParam17 = NULL,
		@inp_sParam18 = NULL,
		@inp_sParam19 = null,
		@inp_sParam20 = NULL,
		@inp_sParam21 = NULL,
		@inp_sParam22 = NULL,
		@inp_sParam23 = NULL,
		@inp_sParam24 = NULL,
		@inp_sParam25 = NULL,
		@inp_sParam26 = null,
		@inp_sParam27 = null,
		@inp_sParam28 = NULL,
		@inp_sParam29 = NULL,
		@inp_sParam30 = NULL,
		@inp_sParam31 = NULL,
		@inp_sParam32 = NULL,
		@inp_sParam33 = NULL,
		@inp_sParam34 = NULL,
		@inp_sParam35 = NULL,
		@inp_sParam36 = NULL,
		@inp_sParam37 = NULL,
		@inp_sParam38 = NULL,
		@inp_sParam39 = NULL,
		@inp_sParam40 = NULL,
		@inp_sParam41 = NULL,
		@inp_sParam42 = NULL,
		@inp_sParam43 = null,
		@inp_sParam44 = NULL,
		@inp_sParam45 = NULL,
		@inp_sParam46 = NULL,
		@inp_sParam47 = NULL,
		@inp_sParam48 = NULL,
		@inp_sParam49 = NULL,
		@inp_sParam50 = NULL,
		@out_iTotalRecords = @out_iTotalRecords OUTPUT,
		@out_nReturnValue = @out_nReturnValue OUTPUT,
		@out_nSQLErrCode = @out_nSQLErrCode OUTPUT,
		@out_sSQLErrMessage = @out_sSQLErrMessage OUTPUT

SELECT	@out_iTotalRecords as N'@out_iTotalRecords',
		@out_nReturnValue as N'@out_nReturnValue',
		@out_nSQLErrCode as N'@out_nSQLErrCode',
		@out_sSQLErrMessage as N'@out_sSQLErrMessage'

SELECT	'Return Value' = @return_value

GO
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_DefaulterList]
	@inp_iPageSize									INT = 10
	,@inp_iPageNo									INT = 1
	,@inp_sSortField								VARCHAR(255)
	,@inp_sSortOrder								VARCHAR(5)
	,@inp_iUserInfoId								INT
	,@inp_sEmployeeID								NVARCHAR(50)-- = 'GS1234'
	,@inp_sInsiderName								NVARCHAR(100) --= 's'
	,@inp_sDesignation								NVARCHAR(100) --= 's'
	,@inp_sGrade									NVARCHAR(100) --= 'a'
	,@inp_sLocation									NVARCHAR(50) --= 'pune'
	,@inp_sDepartment								NVARCHAR(100) --= 'a'
	,@inp_sCompanyName								NVARCHAR(200) --= 'k'
	,@inp_sTypeOfInsider							NVARCHAR(200) --= 101003,101002
	,@inp_sDematAccountNumber						NVARCHAR(50)
	,@inp_sAccountHolder							NVARCHAR(100)
	,@inp_sPreClearanceID							NVARCHAR(100)
	,@inp_sRequestStatus							NVARCHAR(500)
	,@inp_sTransactionType							NVARCHAR(500)
	,@inp_sSecurityType								NVARCHAR(500)
	,@inp_dtSubmissionDateFrom						DATETIME --= '2015-05-15'
	,@inp_dtSubmissionDateTo						DATETIME --= '2015-05-19'
	,@inp_dtSoftCopySubmissionDateFrom				DATETIME --= '2015-05-14'
	,@inp_dtSoftCopySubmissionDateTo				DATETIME --= '2015-05-15'
	,@inp_dtHardCopySubmissionDateFrom				DATETIME
	,@inp_dtHardCopySubmissionDateTo				DATETIME
	,@inp_dtLastSubmissionDateFrom					DATETIME --= '2015-05-15'
	,@inp_dtLastSubmissionDateTo					DATETIME --= '2015-05-19'
	,@inp_dtStockExchangesubmissionDateFrom			DATETIME --= '2015-05-14'
	,@inp_dtStockExchangeSubmissionDateTo			DATETIME --= '2015-05-15'
	,@inp_sNonComplainceType						NVARCHAR(100)
	,@inp_sCommentsId								NVARCHAR(200) -- = 162002,162001

	,@inp_dtPreStatusFromDate						DATETIME
	,@inp_dtPreStatusToDate							DATETIME
	,@inp_iPreclearanceFromQty						INT
	,@inp_iPreclearanceToQty						INT
	,@inp_iTradeFromQty								INT
	,@inp_iTradeToQty								INT
	,@inp_iPreclearanceFromValue					INT
	,@inp_iPreclearanceToValue						INT
	,@inp_iTradeFromValue							INT
	,@inp_iTradeToValue								INT
	,@inp_dtTransactionFromDate						DATETIME
	,@inp_dtTransactionToDate						DATETIME
	,@inp_dtLastSubmissionFromDate					DATETIME
	,@inp_dtLastSubmissionToDate					DATETIME
	,@inp_iIsMarkOverride							INT
	,@inp_sIsInsiderFlag							NVARCHAR(200) -- 173001 : Insider, 173002 : Non Insider
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
			SET @inp_sSortField = 'NonComplianceTypeCodeID,UserInfoID,PreclearanceId,AddOtherDetails'
		END
		
		IF @inp_sSortField  = 'rpt_grd_19272'
		BEGIN
			SET @inp_sSortField = 'NonComplianceTypeCodeID,UserInfoID,PreclearanceId,AddOtherDetails'
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
						
			--SELECT * FROM @tmpCommentFilter
			
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
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,UI.CompanyId,UI.CompanyName,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,vwTD.Relation,NULL,NULL,NULL,NULL,NULL,NULL,NULL,UI.CompanyName,ISINNumber,
			vwTD.SecurityType,'Holding', vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,vwIN.ScpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM rpt_DefaulterReport DR
			JOIN vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
		    LEFT JOIN vw_InitialDisclosureStatus vwIN ON DR.UserInfoID = vwIN.UserInfoId AND DetailsSubmitStatus <> 0
			LEFT JOIN vw_TransactionDetailsForDefaulterReport vwTD ON vwIN.TransactionMasterId = vwTD.TransactionMasterId
			--LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			--LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			WHERE DR.NonComplainceTypeCodeId = 170001
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
						
		/*	SELECT DISTINCT UI.UserInfoID,DR.DefaulterReportID,UI.EmployeeId,UI.UserFullName,UI.DateofBecomingInsider,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,UI.CompanyId,UI.CompanyName,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,NULL,NULL,NULL,NULL,NULL,NULL,NULL,UI.CompanyName,ISINNumber,
			vwTD.SecurityType, vwTD.TransactionType, vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,vwIN.ScpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID 
			FROM rpt_DefaulterReport DR
			JOIN vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
		    LEFT JOIN vw_PeriodEndDisclosureStatus vwIN ON DR.TransactionMasterId = vwIN.TransactionMasterId AND DetailsSubmitStatus <> 0
			LEFT JOIN vw_TransactionDetailsForDefaulterReport vwTD ON vwIN.TransactionMasterId = vwTD.TransactionMasterId
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			WHERE DR.NonComplainceTypeCodeId = @nPeriodEndComplianceType*/
			SELECT UI.UserInfoID,DR.DefaulterReportID,UI.EmployeeId,UI.UserFullName,UI.DateOfJoining,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,UI.CompanyId,UI.CompanyName,UI.UserTypeCodeId,UI.UserType,
			UI.Location,NULL,NULL,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,NULL,NULL,NULL,NULL,NULL,NULL,NULL,UI.CompanyName,ISINNumber
			,securityCode.CodeName, NULL, TS.BuyQuantity , TS.SellQuantity, TS.ClosingBalance, TS.Value, 
			securityCode.CodeID, NULL,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,vwIN.ScpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM rpt_DefaulterReport DR
			JOIN tra_TransactionMaster TM ON DR.TransactionMasterId = TM.TransactionMasterId
			JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
			JOIN @tmpMapTable tmpMap ON TP.DiscloPeriodEndFreq = tmpMap.PeriodCode137
			JOIN vw_TransactionSummaryPeriodEndDate vwPEDate ON TM.PeriodEndDate = vwPEDate.PeriodEndDate
			JOIN tra_TransactionSummary TS ON vwPEDate.TransactionSummaryId= TS.TransactionSummaryId AND TS.UserInfoId = TM.UserInfoId
			jOIN com_Code cc ON TS.PeriodCodeId = cc.CodeID and cc.ParentCodeId = tmpMap.PeriodCode123  
			JOIN vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			JOIN com_Code securityCode ON TS.SecurityTypeCodeId = securityCode.CodeID
			JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			LEFT JOIN vw_PeriodEndDisclosureStatus vwIN ON DR.TransactionMasterId = vwIN.TransactionMasterId AND DetailsSubmitStatus <> 0
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
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,UI.CompanyId,UI.CompanyName,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,@sPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwPCL.DisplayRollingNumber),vwPCL.RequestDate, 
			vwPCL.RequestedQty,vwPCL.RequestedValue,vwPCL.PreclearanceStatusCodeId, vwPCL.PreclearanceStatus,vwPCL.PreclearanceStatusDate,vwPCL.PreclearanceApplicabletill,vwPCL.RequestDate,
			UI.CompanyName,ISINNumber,
			vwTD.SecurityType, vwTD.TransactionType, vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,vwIN.HcpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName, CASE WHEN DefRptCmt.Comments = '-'  THEN 1 ELSE 0 END,0,0,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation
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
			where DR.TransactionDetailsId is not null
			
			UNION
			SELECT NULL,UI.UserInfoID,UI.EmployeeId,UI.UserFullName,UI.DateofBecomingInsider,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,UI.CompanyId,UI.CompanyName,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,@sPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwPCL.DisplayRollingNumber),vwPCL.RequestDate, 
			vwPCL.RequestedQty,vwPCL.RequestedValue,vwPCL.PreclearanceStatusCodeId, vwPCL.PreclearanceStatus,vwPCL.PreclearanceStatusDate,vwPCL.PreclearanceApplicabletill,vwPCL.RequestDate,
			UI.CompanyName,ISINNumber,
			vwTD.SecurityType, vwTD.TransactionType, vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,vwIN.HcpSubmitDate,
			null,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName, 1,1,0,NULL,UI.DateOfBecomingInsider, UI.DateOfInactivation
			FROM
			tra_TransactionMaster TM
			 JOIN vw_ContinuousDisclosureStatus vwIN ON TM.TransactionMasterId = vwIN.TransactionMasterId  
			JOIN @tmpPCLIds PP ON TM.PreclearanceRequestId = PP.PreclearanceRequestId
			JOIN #TempTransactionDetailsForDefaulterReport vwPCL ON PP.PreclearanceRequestId = vwPCL.PreclearanceRequestId
			left join vw_TransactionDetailsForDefaulterReport vwTD ON TM.TransactionMasterId = vwTD.TransactionMasterId 
			join rpt_DefaulterReport DR ON PP.PreclearanceRequestId = DR.PreclearanceRequestId 
			     --AND vwTD.TransactionDetailsId <> dr.TransactionDetailsId 
			JOIN vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			--JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID 
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			where DR.TransactionDetailsId is null and vwPCL.IsPartiallyTraded = 1 AND vwPCL.ShowAddButton = 1
			AND vwTD.TransactionDetailsId NOT IN (SELECT TransactionDetailsID FROM @tmpTransactionDetailsIds)
			
			UNION
			SELECT DR.DefaulterReportID,UI.UserInfoID,UI.EmployeeId,UI.UserFullName,UI.DateofBecomingInsider,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,UI.CompanyId,UI.CompanyName,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwPCL.DEMATAccountNumber,vwPCL.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,@sPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwPCL.TransactionMasterId),vwPCL.RequestDate, 
			vwPCL.RequestedQty,vwPCL.RequestedValue,vwPCL.PreclearanceStatusCodeId, vwPCL.PreclearanceStatus,vwPCL.PreclearanceStatusDate,vwPCL.PreclearanceApplicabletill,vwPCL.RequestDate,
			UI.CompanyName,ISINNumber,
			NULL, NULL,NULL , NULL, NULL, NULL, 
			NULL, NULL,
			NULL,NULL,
		    NULL,NULL,NULL,NULL,
			DefRptCmt.Comments,NULL,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,CASE WHEN DefRptCmt.Comments = '-'  THEN 1 ELSE 0 END,0,1,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM @tmpPCLIds PCLIds 
			JOIN rpt_DefaulterReport DR ON PCLIds.PreclearanceRequestId = DR.PreclearanceRequestId AND DR.TransactionDetailsId IS NULL
			JOIN vw_UserInformation UI ON DR.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
			LEFT JOIN #TempTransactionDetailsForDefaulterReport vwPCL ON PCLIds.PreclearanceRequestId = vwPCL.PreclearanceRequestId
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			WHERE DR.NonComplainceTypeCodeId = @nPreclearanceComplianceType
			ORDER BY UI.UserInfoID,@sPrceclearanceCodePrefixText + CONVERT(VARCHAR,vwPCL.DisplayRollingNumber)
		
	
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
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM rpt_DefaulterReport DR
			JOIN vw_TransactionDetailsForDefaulterReport vwTD ON DR.TransactionDetailsId = vwTD.TransactionDetailsId
			LEFT JOIN vw_ContinuousDisclosureStatus vwIN ON DR.TransactionMasterId = vwIN.TransactionMasterId
			JOIN vw_UserInformation UI ON vwIN.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			WHERE DR.NonComplainceTypeCodeId = @nPreclearanceComplianceType AND DR.PreclearanceRequestId IS NULL
			UNION
			SELECT DR.DefaulterReportID,UI.UserInfoID,UI.EmployeeId,UI.UserFullName,UI.DateOfJoining,UI.CINAndDIN,
			UI.DesignationId,UI.Designation,UI.GradeId,UI.Grade,UI.DepartmentId,UI.Department,UI.CompanyId,UI.CompanyName,UI.UserTypeCodeId,UI.UserType,
			UI.Location,vwTD.DEMATAccountNumber,vwTD.AccountHolderName,CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END,@sPPeriodEndRecordPrefixText,NULL,
			NULL,NULL, NULL,NULL,NULL,NULL,
			UI.CompanyName,ISINNumber,
			vwTD.SecurityType, vwTD.TransactionType, vwTD.TradeBuyQty , vwTD.TradeSellQty, vwTD.Qty, vwTD.Value, 
			vwTD.SecurityTypeCodeId, vwTD.TransactionTypeCodeId,
			NULL,vwIN.DetailsSubmitDate,
		    CASE WHEN vwIN.SoftCopyReq = 0 AND vwIN.HardCopyReq = 0 THEN 0 ELSE 1 END,DR.LastSubmissionDate,vwIN.ScpSubmitDate,vwIN.ScpSubmitDate,
			DefRptCmt.Comments,vwIN.HcpByCOSubmitDate,DR.TransactionMasterId,DR.TransactionDetailsId,
			DR.NonComplainceTypeCodeId,CNCT.CodeName,DefRptCmt.CommentsID,UI.DateOfBecomingInsider, UI.DateOfInactivation 
			FROM rpt_DefaulterReport DR
			 JOIN vw_PeriodEndDisclosureStatus vwIN ON DR.TransactionMasterId = vwIN.TransactionMasterId
			JOIN vw_UserInformation UI ON vwIN.UserInfoID = UI.UserInfoID
			JOIN com_Code CNCT ON DR.NonComplainceTypeCodeId = CNCT.CodeID
			JOIN vw_DefaulterReportComments DefRptCmt ON DR.DefaulterReportID = DefRptCmt.DefaulterReportID
			JOIN vw_TransactionDetailsForDefaulterReport vwTD ON DR.TransactionDetailsId = vwTD.TransactionDetailsId
			LEFT JOIN usr_UserRelation UR ON DR.UserInfoIdRelative = UR.UserInfoIdRelative
			LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
			WHERE DR.NonComplainceTypeCodeId = @nPreclearanceComplianceType AND DR.PreclearanceRequestId IS NULL
			ORDER BY UI.UserInfoID
		
		
		
		IF @inp_sCommentsId IS NOT NULL AND @inp_sCommentsId <> ''
			BEGIN
				--Insert Comma Separed Comment in 
				INSERT INTO @tmpCommentFilter(CommentID)
				SELECT * FROM uf_com_Split(@inp_sCommentsId)
				
				IF EXISTS(SELECT CommentID FROM @tmpCommentFilter WHERE CommentID IN(@nTradedMoreThanPreClearanceApprovedQuantity,@nTradedMoreThanPreClearanceApprovedValue))
				BEGIN
					SET @nPreclearanceLevelQtyComment = 1
				END
				
				IF EXISTS(SELECT CommentID FROM @tmpCommentFilter WHERE CommentID IN(@nTradedAfterPreclearanceDateCommentID,
				@nContraTradeCommentID,@nPreclearanceNotTakenCommentID,@nTradedDuringBlackoutPeriodCommentID))
				BEGIN
					SET @nPreclearanceLevelValueComment = 1
				END
				
			END

				
			UPDATE  T
			SET IsShowRecord = 1
			FROM #tmpReport T
			JOIN rpt_DefaulterReportComments DRC ON T.DefaulterReportID = DRC.DefaulterReportID
			JOIN @tmpCommentFilter TCF ON DRC.CommentCodeId = TCF.CommentID
			
			--SELECT @nPreclearanceLevelQtyComment
			
			IF(@nPreclearanceLevelQtyComment = 1)
			BEGIN
				UPDATE  T
				SET IsShowRecord = 1
				FROM #tmpReport T
				JOIN (SELECT T1.PreclearanceId AS PreclearanceId FROM #tmpReport T1
					JOIN rpt_DefaulterReportComments DRC ON T1.DefaulterReportID = DRC.DefaulterReportID
					JOIN @tmpCommentFilter TCF ON DRC.CommentCodeId = TCF.CommentID
				) EL ON T.PreclearanceId = EL.PreclearanceId
			END
			
			--Update precleance comment level row
			IF(@nPreclearanceLevelValueComment = 1)
			BEGIN
				UPDATE  T
				SET IsShowRecord = 1
				FROM #tmpReport T
				JOIN (SELECT T1.PreclearanceId AS PreclearanceId FROM #tmpReport T1
					JOIN rpt_DefaulterReportComments DRC ON T1.DefaulterReportID = DRC.DefaulterReportID
					JOIN @tmpCommentFilter TCF ON DRC.CommentCodeId = TCF.CommentID
				) EL ON T.PreclearanceId = EL.PreclearanceId 
				WHERE T.ISParentPreclearance = 1
			END
			
		SELECT @sSQL = ' INSERT INTO #tmpList(RowNumber, EntityID) '
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',Id),Id ' 
		SELECT @sSQL = @sSQL + ' FROM #tmpReport Temp '
		SELECT @sSQL = @sSQL + ' LEFT JOIN rpt_DefaulterReportOverride DRO ON Temp.DefaulterReportID = DRO.DefaulterReportID '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1  AND (Temp.DateOfInactivation IS NULL OR dbo.uf_com_GetServerDate() < Temp.DateOfInactivation)'
		
		IF (@inp_iUserInfoId IS NOT NULL AND @inp_iUserInfoId <> 0)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.UserInfoId = ' + CONVERT(VARCHAR(10), @inp_iUserInfoId)
		END
		
		IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.EmployeeId LIKE ''%' + @inp_sEmployeeID +  '%'''
		END
		
		IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
		BEGIN
			SELECT @sSQL = @sSQL +  ' AND Temp.InsiderName like ''%' + @inp_sInsiderName + '%'''
		END
		
		IF (@inp_sDesignation IS NOT NULL AND @inp_sDesignation <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.Designation ''%' + @inp_sDesignation + '%'')'
		
		END
		IF (@inp_sGrade IS NOT NULL AND @inp_sGrade <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.GradeCodeID IN (' + @inp_sGrade + ')'
		END
		IF (@inp_sLocation IS NOT NULL AND @inp_sLocation <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.Location like ''%' + @inp_sLocation + '%'''
		
		END
		IF (@inp_sDepartment IS NOT NULL AND @inp_sDepartment <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.DepartmentCodeID IN (' + @inp_sDepartment + ')'
		END
		
		IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.CompanyID IN(' + @inp_sCompanyName + ')'
		END
		
		IF (@inp_sTypeOfInsider IS NOT NULL AND @inp_sTypeOfInsider <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.UserTypeCodeId IN (' + @inp_sTypeOfInsider + ') '
		END
		
		IF (@inp_sDematAccountNumber IS NOT NULL AND @inp_sDematAccountNumber <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.Demat like ''%' + @inp_sDematAccountNumber + '%'''
		END
		
		IF (@inp_sAccountHolder IS NOT NULL AND @inp_sAccountHolder <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.AccountHolder like ''%' + @inp_sAccountHolder + '%'''
		END
		
		IF (@inp_sPreClearanceID IS NOT NULL AND @inp_sPreClearanceID <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.PreclearanceId like ''%' + @inp_sPreClearanceID + '%'''
		END
		
		IF (@inp_sRequestStatus IS NOT NULL AND @inp_sRequestStatus <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.PCLStatusID IN (' + @inp_sRequestStatus + ') '
		END
		
		IF (@inp_sTransactionType IS NOT NULL AND @inp_sTransactionType <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.TransactionTypeCodeId IN (' + @inp_sTransactionType + ') '
		END
		
		IF (@inp_sSecurityType IS NOT NULL AND @inp_sSecurityType <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.SecurityTypeCodeId IN (' + @inp_sSecurityType + ') '
		END
		
		IF (@inp_sNonComplainceType IS NOT NULL AND @inp_sNonComplainceType <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.NonComplianceTypeCodeID IN (' + @inp_sNonComplainceType + ') '
		END
		
		
		IF(@inp_dtSubmissionDateFrom IS NOT NULL AND @inp_dtSubmissionDateTo IS NOT NULL)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.DetailsSubmitDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.DetailsSubmitDate >= CAST('''  + CAST(@inp_dtSubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.DetailsSubmitDate IS NULL OR Temp.DetailsSubmitDate <= CAST('''  + CAST(@inp_dtSubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtSubmissionDateFrom IS NOT NULL AND @inp_dtSubmissionDateTo IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.DetailsSubmitDate IS NOT NULL AND Temp.DetailsSubmitDate >= CAST('''  + CAST(@inp_dtSubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtSubmissionDateFrom IS NULL AND @inp_dtSubmissionDateTo IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.DetailsSubmitDate IS NOT NULL AND Temp.DetailsSubmitDate <= CAST('''  + CAST(@inp_dtSubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME))'
		END		
		
		
		IF(@inp_dtSoftCopySubmissionDateFrom IS NOT NULL AND @inp_dtSoftCopySubmissionDateTo IS NOT NULL)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.ScpSubmitDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.ScpSubmitDate >= CAST('''  + CAST(@inp_dtSoftCopySubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.ScpSubmitDate IS NULL OR Temp.ScpSubmitDate <= CAST('''  + CAST(@inp_dtSoftCopySubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtSoftCopySubmissionDateFrom IS NOT NULL AND @inp_dtSoftCopySubmissionDateTo IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.ScpSubmitDate IS NOT NULL AND Temp.ScpSubmitDate >= CAST('''  + CAST(@inp_dtSoftCopySubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtSoftCopySubmissionDateFrom IS NULL AND @inp_dtSoftCopySubmissionDateTo IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.ScpSubmitDate IS NOT NULL AND Temp.ScpSubmitDate <= CAST('''  + CAST(@inp_dtSoftCopySubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME))'
		END	
		
		--Hard Copy Submission Date
		IF(@inp_dtHardCopySubmissionDateFrom IS NOT NULL AND @inp_dtHardCopySubmissionDateTo IS NOT NULL)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.HcpSubmitDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.HcpSubmitDate >= CAST('''  + CAST(@inp_dtHardCopySubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.HcpSubmitDate IS NULL OR Temp.HcpSubmitDate <= CAST('''  + CAST(@inp_dtHardCopySubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtHardCopySubmissionDateFrom IS NOT NULL AND @inp_dtHardCopySubmissionDateTo IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.HcpSubmitDate IS NOT NULL AND Temp.HcpSubmitDate >= CAST('''  + CAST(@inp_dtHardCopySubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtHardCopySubmissionDateFrom IS NULL AND @inp_dtHardCopySubmissionDateTo IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.HcpSubmitDate IS NOT NULL AND Temp.HcpSubmitDate <= CAST('''  + CAST(@inp_dtHardCopySubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME))'
		END	
		
		--Stock Exchange Submission Date
		IF(@inp_dtStockExchangesubmissionDateFrom IS NOT NULL AND @inp_dtStockExchangeSubmissionDateTo IS NOT NULL)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.HcpByCOSubmitDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.HcpByCOSubmitDate >= CAST('''  + CAST(@inp_dtStockExchangesubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.HcpByCOSubmitDate IS NULL OR Temp.HcpByCOSubmitDate <= CAST('''  + CAST(@inp_dtStockExchangeSubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtStockExchangesubmissionDateFrom IS NOT NULL AND @inp_dtStockExchangeSubmissionDateTo IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.HcpByCOSubmitDate IS NOT NULL AND Temp.HcpByCOSubmitDate >= CAST('''  + CAST(@inp_dtStockExchangesubmissionDateFrom AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtStockExchangesubmissionDateFrom IS NULL AND @inp_dtStockExchangeSubmissionDateTo IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.HcpByCOSubmitDate IS NOT NULL AND Temp.HcpByCOSubmitDate <= CAST('''  + CAST(@inp_dtStockExchangeSubmissionDateTo AS VARCHAR(25)) + '''AS DATETIME))'
		END	
		
		--Preclearance Status Date
		IF(@inp_dtPreStatusFromDate IS NOT NULL AND @inp_dtPreStatusToDate IS NOT NULL)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.PCLStatusDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.PCLStatusDate >= CAST('''  + CAST(@inp_dtPreStatusFromDate AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.PCLStatusDate IS NULL OR Temp.PCLStatusDate <= CAST('''  + CAST(@inp_dtPreStatusToDate AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtPreStatusFromDate IS NOT NULL AND @inp_dtPreStatusToDate IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.PCLStatusDate IS NOT NULL AND Temp.PCLStatusDate >= CAST('''  + CAST(@inp_dtPreStatusFromDate AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtPreStatusFromDate IS NULL AND @inp_dtPreStatusToDate IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.PCLStatusDate IS NOT NULL AND Temp.PCLStatusDate <= CAST('''  + CAST(@inp_dtPreStatusToDate AS VARCHAR(25)) + '''AS DATETIME))'
		END	
		
		--Transaction Date
		IF(@inp_dtTransactionFromDate IS NOT NULL AND @inp_dtTransactionToDate IS NOT NULL)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.TransactionDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.TransactionDate >= CAST('''  + CAST(@inp_dtTransactionFromDate AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.TransactionDate IS NULL OR Temp.TransactionDate <= CAST('''  + CAST(@inp_dtTransactionToDate AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtTransactionFromDate IS NOT NULL AND @inp_dtTransactionToDate IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.TransactionDate IS NOT NULL AND Temp.TransactionDate >= CAST('''  + CAST(@inp_dtTransactionFromDate AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtTransactionFromDate IS NULL AND @inp_dtTransactionToDate IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.TransactionDate IS NOT NULL AND Temp.TransactionDate <= CAST('''  + CAST(@inp_dtTransactionToDate AS VARCHAR(25)) + '''AS DATETIME))'
		END	
		
		--LastSubmissionDate
		IF(@inp_dtLastSubmissionFromDate IS NOT NULL AND @inp_dtLastSubmissionToDate IS NOT NULL)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.LastSubmissionDate IS NOT NULL ' 
				SELECT @sSQL = @sSQL + ' AND (Temp.LastSubmissionDate >= CAST('''  + CAST(@inp_dtLastSubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME)'
				SELECT @sSQL = @sSQL + ' AND (Temp.LastSubmissionDate IS NULL OR Temp.LastSubmissionDate <= CAST('''  + CAST(@inp_dtLastSubmissionToDate AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END
		ELSE IF (@inp_dtLastSubmissionFromDate IS NOT NULL AND @inp_dtLastSubmissionToDate IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( Temp.LastSubmissionDate IS NOT NULL AND Temp.LastSubmissionDate >= CAST('''  + CAST(@inp_dtLastSubmissionFromDate AS VARCHAR(25)) + ''' AS DATETIME))'
		END
		ELSE IF (@inp_dtLastSubmissionFromDate IS NULL AND @inp_dtLastSubmissionToDate IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (Temp.LastSubmissionDate IS NOT NULL AND Temp.LastSubmissionDate <= CAST('''  + CAST(@inp_dtLastSubmissionToDate AS VARCHAR(25)) + '''AS DATETIME))'
		END	
		
		IF(@inp_iPreclearanceFromQty IS NOT NULL AND @inp_iPreclearanceToQty IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqQty IS NOT NULL ' 
			SELECT @sSQL = @sSQL + ' AND (Temp.PCLReqQty >= ' + CONVERT(VARCHAR(MAX), @inp_iPreclearanceFromQty) 
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqQty <= ' + CONVERT(VARCHAR(MAX), @inp_iPreclearanceToQty) + ')'
		END
		ELSE IF(@inp_iPreclearanceFromQty IS NOT NULL AND @inp_iPreclearanceToQty IS NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqQty IS NOT NULL ' 
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqQty >= ' + CONVERT(VARCHAR(MAX), @inp_iPreclearanceFromQty) 
		END
		ELSE IF(@inp_iPreclearanceFromQty IS NULL AND @inp_iPreclearanceToQty IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqQty IS NOT NULL ' 
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqQty <= ' + CONVERT(VARCHAR(MAX), @inp_iPreclearanceToQty) 
		END
		
		-- Precleanrace Value
		IF(@inp_iPreclearanceFromValue IS NOT NULL AND @inp_iPreclearanceToValue IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqVal IS NOT NULL ' 
			SELECT @sSQL = @sSQL + ' AND (Temp.PCLReqVal >= ' + CONVERT(VARCHAR(MAX), @inp_iPreclearanceFromValue) 
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqVal <= ' + CONVERT(VARCHAR(MAX), @inp_iPreclearanceToValue) + ')'
		END
		ELSE IF(@inp_iPreclearanceFromValue IS NOT NULL AND @inp_iPreclearanceToValue IS NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqVal IS NOT NULL ' 
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqVal >= ' + CONVERT(VARCHAR(MAX), @inp_iPreclearanceFromValue) 
		END
		ELSE IF(@inp_iPreclearanceFromValue IS NULL AND @inp_iPreclearanceToValue IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqVal IS NOT NULL ' 
			SELECT @sSQL = @sSQL + ' AND Temp.PCLReqVal <= ' + CONVERT(VARCHAR(MAX), @inp_iPreclearanceToValue) 
		END
		
		IF(@inp_iTradeFromQty IS NOT NULL AND @inp_iTradeToQty IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.Qty IS NOT NULL ' 
			SELECT @sSQL = @sSQL + ' AND (Temp.Qty >= ' + CONVERT(VARCHAR(MAX), @inp_iTradeFromQty) 
			SELECT @sSQL = @sSQL + ' AND Temp.Qty <= ' + CONVERT(VARCHAR(MAX), @inp_iTradeToQty) + ')'
		END
		ELSE IF(@inp_iTradeFromQty IS NOT NULL AND @inp_iTradeToQty IS NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.Qty IS NOT NULL ' 
			SELECT @sSQL = @sSQL + ' AND  Temp.Qty >= ' + CONVERT(VARCHAR(MAX), @inp_iTradeFromQty) 
			--SELECT @sSQL = @sSQL + ' OR (Temp.ISParentPreclearance = 1 AND  ))'
		END
		ELSE IF(@inp_iTradeFromQty IS NULL AND @inp_iTradeToQty IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.Qty IS NOT NULL ' 
			SELECT @sSQL = @sSQL + ' AND Temp.Qty <= ' + CONVERT(VARCHAR(MAX), @inp_iTradeToQty) 
		END
		
		-- Insider Flag
		IF (@inp_sIsInsiderFlag IS NOT NULL AND @inp_sIsInsiderFlag <> '')
		BEGIN
			IF CHARINDEX(',',@inp_sIsInsiderFlag) <= 0
			BEGIN
				IF @inp_sIsInsiderFlag = @nInsiderFlag_Insider
				BEGIN
					-- When the flag is one, records with date of becoming insider not null to be taken
					SELECT @sSQL = @sSQL + ' AND Temp.DateOfBecomingInsider IS '
					SELECT @sSQL = @sSQL + ' NOT'			
				END
				ELSE IF @inp_sIsInsiderFlag = @nInsiderFlag_NonInsider
				BEGIN
					-- When the flag is one, records with date of becoming insider not null to be taken
					SELECT @sSQL = @sSQL + ' AND Temp.DateOfBecomingInsider IS '
					SELECT @sSQL = @sSQL + ''			
				END
				SELECT @sSQL = @sSQL + ' NULL'
			END
		END
		
		-- Mark Override
		IF (@inp_iIsMarkOverride IS NOT NULL AND @inp_iIsMarkOverride <> 0)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND DRO.IsRemovedFromNonCompliance IS NOT NULL '
		END
		
		IF @inp_sCommentsId IS NOT NULL AND @inp_sCommentsId <> ''
		BEGIN
			SELECT @sSQL = @sSQL + ' AND Temp.IsShowRecord = 1 '
		END
		
		
		
		EXEC (@sSQL)
		IF (@inp_iTradeFromQty IS NOT NULL OR @inp_iTradeToQty <> 0)
		BEGIN
			
			DECLARE @sSQL1 NVARCHAR(MAX) = ''
			
			 SELECT @sSQL1 = @sSQL1 + ' SELECT  DISTINCT PreclearanceId FROM #tmpList T JOIN #tmpReport  Temp ON T.EntityID = Temp.Id'
			
			 INSERT INTO #tmpPreclearanceID(PreclearanceID)
			 EXEC (@sSQL1)
		
			SELECT @sSQL = ' INSERT INTO #tmpList(RowNumber, EntityID) '
				SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',Id),Id ' 
				SELECT @sSQL = @sSQL + ' FROM #tmpReport Temp '
				SELECT @sSQL = @sSQL + ' WHERE 1 = 1 AND Temp.ISParentPreclearance = 1 AND Temp.PreclearanceId IN ( SELECT PreclearanceID FROM  #tmpPreclearanceID) '
				
				EXEC (@sSQL)
	  	END
				
		
		
			SELECT 
				Temp.DefaulterReportID,
				CASE WHEN DRO.IsRemovedFromNonCompliance  = 1 THEN 1 ELSE NULL END  AS rpt_grd_19272,
				Temp.UserInfoID AS UserInfoID,
				Temp.PreclearanceId AS rpt_grd_19286,
				Temp.EmployeeId AS rpt_grd_19273,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.InsiderName) AS rpt_grd_19274,
				dbo.uf_rpt_FormatDateValue(Temp.DateOfJoining,0) AS rpt_grd_19275,
				UI.DateOfInactivation,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.CINAndDIN) AS rpt_grd_19276,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Designation) AS rpt_grd_19277,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Grade) AS rpt_grd_19278,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Location) AS rpt_grd_19279,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Department) AS rpt_grd_19280,
				dbo.uf_rpt_ReplaceSpecialChar(CCategory.CodeName) AS Category,
				dbo.uf_rpt_ReplaceSpecialChar(CSubCategory.CodeName) AS SubCategory,
				dbo.uf_rpt_ReplaceSpecialChar(CStatusCodeId.CodeName) AS 'Status',
				dbo.uf_rpt_ReplaceSpecialChar(Temp.CompanyName) AS rpt_grd_19281,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.UserType + CASE WHEN Temp.DateOfBecomingInsider IS NOT NULL THEN ' Insider ' ELSE '' END) AS rpt_grd_19282,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Demat) AS rpt_grd_19283,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.AccountHolder) AS rpt_grd_19284,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.RelationWithInsider) AS rpt_grd_19285,
				dbo.uf_rpt_FormatDateValue(Temp.PCLRequestDate,0) AS rpt_grd_19287,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.PCLReqQty) AS rpt_grd_19288,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.PCLReqVal) AS rpt_grd_19289,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.PCLStatus) AS rpt_grd_19290,
				dbo.uf_rpt_FormatDateValue(Temp.PCLStatusDate,0) AS rpt_grd_19291,
				dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatDateValue(Temp.PCLApplicableTill,0)) AS rpt_grd_19292,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.CompanyName) AS rpt_grd_19293,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.ISINNumber) AS rpt_grd_19294,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.SecurityType) AS rpt_grd_19295,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.TransactionType) AS rpt_grd_19296,
				Temp.TradeBuyQty AS rpt_grd_19298,
				Temp.TradeSellQty AS rpt_grd_19299,
				Temp.Qty AS rpt_grd_19300,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Value) AS rpt_grd_19301,
				dbo.uf_rpt_FormatDateValue(Temp.TransactionDate,0) AS rpt_grd_19302,
				dbo.uf_rpt_FormatDateValue(Temp.DetailsSubmitDate,0) AS rpt_grd_19303,
				Temp.DisclosureRequired AS rpt_grd_19304,
				dbo.uf_rpt_FormatDateValue(Temp.LastSubmissionDate,0) AS rpt_grd_19305,
				dbo.uf_rpt_FormatDateValue(Temp.ScpSubmitDate,0) AS rpt_grd_19307,
				dbo.uf_rpt_FormatDateValue(Temp.ScpSubmitDate,0) AS rpt_grd_19308,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.Comments) AS rpt_grd_19309,
				dbo.uf_rpt_FormatDateValue(Temp.HcpByCOSubmitDate,0) AS rpt_grd_19310,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.NonComplianceType) AS rpt_grd_19311,
				CASE WHEN DRO.IsRemovedFromNonCompliance  = 1 THEN 1 ELSE NULL END  AS ISRemoveFromList,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.PreclearanceBlankComment) AS PreclearanceBlankComment,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.AddOtherDetails) AS AddOtherDetails,
				dbo.uf_rpt_ReplaceSpecialChar(Temp.ISParentPreclearance) As ISParentPreclearance,
				Temp.IsShowRecord As IsShowRecord,
				DRO.Reason AS rpt_grd_61009
		FROM	#tmpList T 
		JOIN #tmpReport  Temp ON T.EntityID = Temp.Id
		LEFT JOIN rpt_DefaulterReportOverride DRO ON Temp.DefaulterReportID = DRO.DefaulterReportID
		LEFT JOIN usr_UserInfo UI ON UI.UserInfoId = TEMP.UserInfoID
		LEFT join com_Code CCategory on UI.Category = CCategory.CodeID
		LEFT JOIN com_Code CSubCategory ON UI.SubCategory = CSubCategory.CodeID
		LEFT JOIN com_Code CStatusCodeId ON UI.StatusCodeId = CStatusCodeId.CodeID		
		WHERE Temp.Id IS NOT NULL
		--AND (Temp.DateOfInactivation IS NULL OR dbo.uf_com_GetServerDate() < Temp.DateOfInactivation)
		AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY NonComplianceTypeCodeID,UserInfoID,PreclearanceId,AddOtherDetails--T.RowNumber	
			
		DROP TABLE #tmpPreclearanceID
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		
		DROP TABLE #tmpPreclearanceID
	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_DEFAULTERREPORT
	END CATCH
END
