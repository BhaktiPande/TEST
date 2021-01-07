IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_ClawBackReportGenerator')
DROP PROCEDURE [dbo].[st_rpt_ClawBackReportGenerator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This stored procedure will save the data in "rpt_ClawBackReport" SQL Table For Download Excel Purpose.
                
Returns:		0, if Success.
				
Created by:		Tushar Wakchaure
Created on:		17-Aug-2018

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_ClawBackReportGenerator]
	 @out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT	-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	
	--Variable Declaration
	DECLARE @ERR_CLAWBACKREPORT			    INT = 50705
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

	DECLARE @nTotalRecordCount			    INT 
	DECLARE @nCounter                  	    INT = 1
	DECLARE @nTransactionMasterId INT
    DECLARE @nContraTradeTransactionTypeID INT
    DECLARE @nNoContraTradeTransactionTypeID INT
    DECLARE @nTransactionTypeID INT 
	DECLARE @inp_sTransactionMasterId INT 
	DECLARE @inp_sSecurityTypeCodeID INT 
	DECLARE @inp_iUserInfoId INT
	DECLARE @inp_sTransactionTypeCodeID INT

	DECLARE @nDocument_Uploaded    INT = 148001
	DECLARE @nNot_Confirmed        INT = 148002
	DECLARE @nContinuousDisclosure INT = 147002

	DECLARE @inp_iRelativeInfoId    INT
	DECLARE @inp_iUserInfoId_User   INT
	DECLARE @nTotalRecCount		    INT 
	DECLARE @nRecCounter            INT = 1
	 
	
	
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
			where DR.TransactionDetailsId is not null
			
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

		 -- For Download Claw Back Excel 

		CREATE TABLE #tmpClawBack_Excel(Id INT IDENTITY(1,1), UserInfoID INT, TransactionMasterId BIGINT, EmployeeID NVARCHAR(100), InsiderName NVARCHAR(250), PAN NVARCHAR(50), 
        UserAddress NVARCHAR(500), PinCode NVARCHAR(50), Country NVARCHAR(50), MobileNumber NVARCHAR(50), Email NVARCHAR(100), CompanyName NVARCHAR(100), 
        TypeOfInsider NVARCHAR(50), Category NVARCHAR(100), Subcategory NVARCHAR(100), CINDIN NVARCHAR(100), Designation NVARCHAR(100), Grade NVARCHAR(50),
        Location NVARCHAR(100), Department NVARCHAR(100), DmatAccount NVARCHAR(100), AccountHolderName NVARCHAR(255), PreclearanceID NVARCHAR(100), 
        RequestDate DATETIME, SecurityType NVARCHAR(50), TransactionType NVARCHAR(50), TransactionDate DATETIME, Quantity DECIMAL(10,0), Value DECIMAL(10,0),Currency NVARCHAR(50))

		CREATE TABLE #tmpContraTradeReport(Id INT IDENTITY(1,1), UserInfoID BIGINT, TransactionMasterID BIGINT, SecurityTypeCodeId INT, TransactionTypeCodeId INT)

		INSERT INTO #tmpContraTradeReport(UserInfoID, TransactionMasterID, SecurityTypeCodeId, TransactionTypeCodeId)
        SELECT Temp.UserInfoID, Temp.TransactionMasterID, Temp.SecurityTypeCodeId, Temp.TransactionTypeCodeId
		FROM #tmpReport Temp
		LEFT JOIN rpt_DefaulterReportOverride DRO ON Temp.DefaulterReportID = DRO.DefaulterReportID
		LEFT JOIN usr_UserInfo UI ON UI.UserInfoId = Temp.UserInfoID
		LEFT join com_Code CCategory ON UI.Category = CCategory.CodeID
		LEFT JOIN com_Code CSubCategory ON UI.SubCategory = CSubCategory.CodeID
		LEFT JOIN com_Code CStatusCodeId ON UI.StatusCodeId = CStatusCodeId.CodeID	
		LEFT JOIN com_Code CCountryCodeId ON UI.CountryId = CCountryCodeId.CodeID		
		WHERE Temp.Id IS NOT NULL 
		AND (Temp.DateOfInactivation IS NULL OR dbo.uf_com_GetServerDate() < Temp.DateOfInactivation)
		AND Temp.Comments LIKE '%Contra Trade%'

		SELECT @nTotalRecordCount = COUNT(*) FROM #tmpContraTradeReport 
		
		WHILE(@nCounter <= @nTotalRecordCount)
		BEGIN
		    SELECT @inp_iUserInfoId = Temp.UserInfoID ,@inp_sTransactionMasterId = TransactionMasterID, @inp_sSecurityTypeCodeID = SecurityTypeCodeId, @inp_sTransactionTypeCodeID = TransactionTypeCodeId 
			FROM #tmpContraTradeReport Temp WHERE Temp.Id = @nCounter

			SET @nTransactionMasterId = @inp_sTransactionMasterId

            SELECT @nContraTradeTransactionTypeID = TransactionTypeCodeId FROM tra_TransactionDetails WHERE  SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionTypeCodeId = @inp_sTransactionTypeCodeID AND TransactionMasterId = @nTransactionMasterId 

             CREATE TABLE #tblClawBack_Report(Id INT IDENTITY(1,1), UserInfoID INT, TransactionMasterId BIGINT, EmployeeID NVARCHAR(100), InsiderName NVARCHAR(250), PAN NVARCHAR(50), 
             UserAddress NVARCHAR(500), PinCode NVARCHAR(50), Country NVARCHAR(50), MobileNumber NVARCHAR(50), Email NVARCHAR(100), CompanyName NVARCHAR(100), 
             TypeOfInsider NVARCHAR(50), Category NVARCHAR(100), Subcategory NVARCHAR(100), CINDIN NVARCHAR(100), Designation NVARCHAR(100), Grade NVARCHAR(50),
             Location NVARCHAR(100), Department NVARCHAR(100), DmatAccount NVARCHAR(100), AccountHolderName NVARCHAR(255), PreclearanceID NVARCHAR(100), 
             RequestDate DATETIME, SecurityType NVARCHAR(50), TransactionType NVARCHAR(50), TransactionDate DATETIME, Quantity DECIMAL(10,0), Value DECIMAL(10,0),CurrencyId INT)

             INSERT INTO #tblClawBack_Report(UserInfoID, TransactionMasterId, EmployeeID, InsiderName, PAN, UserAddress, PinCode, Country, MobileNumber, Email, CompanyName, TypeOfInsider, 
             Category, Subcategory, CINDIN, Designation, Grade, Location, Department, DmatAccount, AccountHolderName, PreclearanceID, RequestDate, SecurityType, TransactionType, 
             TransactionDate, Quantity, Value, CurrencyId)
             SELECT TD.ForUserInfoId, TD.TransactionMasterId, UI.EmployeeId, UI.FirstName + ' ' + UI.LastName, UI.PAN, UI.AddressLine1, UI.PinCode, UI.CountryId, UI.MobileNumber, UI.EmailId, UI.CompanyId,
             UI.UserTypeCodeId, UI.Category, UI.SubCategory, UI.CIN, UI.DesignationId, UI.GradeId, UI.Location, UI.DepartmentId, DD.DEMATAccountNumber, UI.FirstName + ' ' + UI.LastName, '-', NULL, 
             TD.SecurityTypeCodeId, TD.TransactionTypeCodeId, TD.DateOfAcquisition, TD.Quantity, TD.Value ,TD.CurrencyId
             FROM tra_TransactionDetails TD
             JOIN usr_UserInfo UI ON UI.UserInfoId = TD.ForUserInfoId

			 JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId 
			 JOIN usr_DMATDetails DD ON DD.DMATDetailsID = TD.DMATDetailsID
             WHERE TD.TransactionMasterId = @nTransactionMasterId AND TM.DisclosureTypeCodeId = @nContinuousDisclosure AND TM.TransactionStatusCodeId NOT IN (@nDocument_Uploaded, @nNot_Confirmed)

             SELECT @nTransactionMasterId = MAX(TransactionMasterId) FROM tra_TransactionDetails WHERE SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionMasterId < @nTransactionMasterId 
             SELECT @nNoContraTradeTransactionTypeID = TransactionTypeCodeId FROM tra_TransactionDetails WHERE SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionMasterId = @nTransactionMasterId 

			 INSERT INTO #tblClawBack_Report(UserInfoID, TransactionMasterId, EmployeeID, InsiderName, PAN, UserAddress, PinCode, Country, MobileNumber, Email, CompanyName, TypeOfInsider, 
             Category, Subcategory, CINDIN, Designation, Grade, Location, Department, DmatAccount, AccountHolderName, PreclearanceID, RequestDate, SecurityType, TransactionType, 
             TransactionDate, Quantity, Value, CurrencyId )
             SELECT TD.ForUserInfoId, TD.TransactionMasterId, UI.EmployeeId, UI.FirstName + ' ' + UI.LastName, UI.PAN, UI.AddressLine1, UI.PinCode, UI.CountryId, UI.MobileNumber, UI.EmailId, UI.CompanyId,
             UI.UserTypeCodeId, UI.Category, UI.SubCategory, UI.CIN, UI.DesignationId, UI.GradeId, UI.Location, UI.DepartmentId, DD.DEMATAccountNumber, UI.FirstName + ' ' + UI.LastName, '-', NULL, 
             TD.SecurityTypeCodeId, TD.TransactionTypeCodeId, TD.DateOfAcquisition, TD.Quantity, TD.Value ,TD.CurrencyId
             FROM tra_TransactionDetails TD
             JOIN usr_UserInfo UI ON UI.UserInfoId = TD.ForUserInfoId
			 JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId 
			 JOIN usr_DMATDetails DD ON DD.DMATDetailsID = TD.DMATDetailsID
             WHERE TD.TransactionMasterId = @nTransactionMasterId AND TM.DisclosureTypeCodeId = @nContinuousDisclosure AND TM.TransactionStatusCodeId NOT IN (@nDocument_Uploaded, @nNot_Confirmed)
	
             START: 
	         IF EXISTS (SELECT * FROM tra_TransactionDetails WHERE SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionMasterId < @nTransactionMasterId AND (ForUserInfoId = @inp_iUserInfoId OR ForUserInfoId IN (SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoId = @inp_iUserInfoId)))
             BEGIN              
               SELECT @nTransactionMasterId = MAX(TransactionMasterId) FROM tra_TransactionDetails WHERE SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionMasterId < @nTransactionMasterId AND (ForUserInfoId = @inp_iUserInfoId OR ForUserInfoId IN (SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoId = @inp_iUserInfoId))
		       SELECT @nTransactionTypeID = TransactionTypeCodeId FROM tra_TransactionDetails WHERE SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionMasterId = @nTransactionMasterId AND (ForUserInfoId = @inp_iUserInfoId OR ForUserInfoId IN (SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoId = @inp_iUserInfoId))
		       IF NOT (@nTransactionTypeID <> @nNoContraTradeTransactionTypeID)
               BEGIN
			     INSERT INTO #tblClawBack_Report(UserInfoID, TransactionMasterId, EmployeeID, InsiderName, PAN, UserAddress, PinCode, Country, MobileNumber, Email, CompanyName, TypeOfInsider, 
                 Category, Subcategory, CINDIN, Designation, Grade, Location, Department, DmatAccount, AccountHolderName, PreclearanceID, RequestDate, SecurityType, TransactionType, 
                 TransactionDate, Quantity, Value,CurrencyId)
                 SELECT TD.ForUserInfoId, TD.TransactionMasterId, UI.EmployeeId, UI.FirstName + ' ' + UI.LastName, UI.PAN, UI.AddressLine1, UI.PinCode, UI.CountryId, UI.MobileNumber, UI.EmailId, UI.CompanyId,
                 UI.UserTypeCodeId, UI.Category, UI.SubCategory, UI.CIN, UI.DesignationId, UI.GradeId, UI.Location, UI.DepartmentId, DD.DEMATAccountNumber, UI.FirstName + ' ' + UI.LastName, '-', NULL, 
                 TD.SecurityTypeCodeId, TD.TransactionTypeCodeId, TD.DateOfAcquisition, TD.Quantity, TD.Value ,TD.CurrencyId
                 FROM tra_TransactionDetails TD
                 JOIN usr_UserInfo UI ON UI.UserInfoId = TD.ForUserInfoId
				 JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId 
				 JOIN usr_DMATDetails DD ON DD.DMATDetailsID = TD.DMATDetailsID
                 WHERE TD.TransactionMasterId = @nTransactionMasterId AND TM.DisclosureTypeCodeId = @nContinuousDisclosure AND TM.TransactionStatusCodeId NOT IN (@nDocument_Uploaded, @nNot_Confirmed)
                 GOTO START;
               END
			
             END

			 INSERT INTO #tmpClawBack_Excel(UserInfoID, TransactionMasterId, EmployeeID, InsiderName, PAN, UserAddress, PinCode, Country, MobileNumber, Email, CompanyName, TypeOfInsider, 
             Category, Subcategory, CINDIN, Designation, Grade, Location, Department, DmatAccount, AccountHolderName, PreclearanceID, RequestDate, SecurityType, TransactionType, 
             TransactionDate, Quantity, Value, Currency )		  
             SELECT Temp.UserInfoID, Temp.TransactionMasterId, Temp.EmployeeID, Temp.InsiderName, Temp.PAN,Temp.UserAddress, Temp.PinCode, sCountryCodeID.CodeName,
			 Temp.MobileNumber, Temp.Email, sCompanyID.CompanyName, sTypeOfInsiderCodeID.CodeName, ISNULL(sCategoryCodeID.CodeName, UI.CategoryText),
             ISNULL(sSubcategoryCodeID.CodeName, UI.SubCategoryText), Temp.CINDIN, ISNULL(sDesignationCodeID.CodeName, UI.DesignationText), ISNULL(sGradeCodeID.CodeName, UI.GradeText),
			 Temp.Location, ISNULL(sDepartmentID.CodeName, UI.DepartmentText), Temp.DmatAccount, Temp.AccountHolderName, Temp.PreclearanceID, Temp.RequestDate,
			 sSecurityTypeID.CodeName, sTransactionTypeID.CodeName, Temp.TransactionDate, Temp.Quantity, Temp.Value,Currency.DisplayCode as Currency
	         FROM #tblClawBack_Report Temp
			  LEFT JOIN com_Code sCountryCodeID ON sCountryCodeID.CodeID = Temp.Country
			  LEFT JOIN mst_Company sCompanyID ON sCompanyID.CompanyId = Temp.CompanyName
			  LEFT JOIN com_Code sTypeOfInsiderCodeID ON sTypeOfInsiderCodeID.CodeID = Temp.TypeOfInsider
			  LEFT JOIN com_Code sSecurityTypeID ON sSecurityTypeID.CodeID = Temp.SecurityType
	          LEFT JOIN com_Code sTransactionTypeID ON sTransactionTypeID.CodeID = Temp.TransactionType
			  LEFT JOIN com_Code sCategoryCodeID ON sCategoryCodeID.CodeID = Temp.Category
			  LEFT JOIN com_Code sSubcategoryCodeID ON sSubcategoryCodeID.CodeID = Temp.Subcategory
			  LEFT JOIN com_Code sDesignationCodeID ON sDesignationCodeID.CodeID = Temp.Designation
			  LEFT JOIN com_Code sGradeCodeID ON sGradeCodeID.CodeID = Temp.Grade
			  LEFT JOIN com_Code sDepartmentID ON sDepartmentID.CodeID = Temp.Department
			  LEFT JOIN usr_UserInfo UI ON UI.UserInfoId = Temp.UserInfoID
			  LEFT JOIN com_Code Currency ON Currency.CodeID = Temp.CurrencyId
			  

		   DROP TABLE #tblClawBack_Report
		   SET @nCounter = @nCounter + 1	 
	END

	SELECT @nTotalRecCount = COUNT(*) FROM #tmpClawBack_Excel 

	WHILE(@nRecCounter <= @nTotalRecCount)
    BEGIN
	 SELECT @inp_iRelativeInfoId = UserInfoId FROM #tmpClawBack_Excel WHERE Id = @nRecCounter
	 IF EXISTS(SELECT UserInfoId FROM usr_UserRelation WHERE UserInfoIdRelative = @inp_iRelativeInfoId)
	 BEGIN
	 SELECT @inp_iUserInfoId_User = UserInfoId FROM usr_UserRelation WHERE UserInfoIdRelative = @inp_iRelativeInfoId
	
	 UPDATE #tmpClawBack_Excel SET EmployeeID = UI.EmployeeId ,InsiderName = UI.FirstName + ' ' + UI.LastName, PAN = UI.PAN,
	 UserAddress = UI.AddressLine1, PinCode = UI.PinCode, Country = sCountryCodeID.CodeName, MobileNumber = UI.MobileNumber,
	 Email = UI.EmailId, CompanyName = sCompanyID.CompanyName, TypeOfInsider = sTypeOfInsiderCodeID.CodeName, Category = ISNULL(sCategoryCodeID.CodeName, UI.CategoryText),
	 Subcategory = ISNULL(sSubcategoryCodeID.CodeName, UI.SubCategoryText), CINDIN = UI.CIN, Designation =  ISNULL(sDesignationCodeID.CodeName, UI.DesignationText),
	 Grade =  ISNULL(sGradeCodeID.CodeName, UI.GradeText), Location = UI.Location, Department = ISNULL(sDepartmentID.CodeName, UI.DepartmentText)
	 FROM usr_UserInfo UI
	  LEFT JOIN com_Code sCountryCodeID ON sCountryCodeID.CodeID = UI.CountryId
	  LEFT JOIN mst_Company sCompanyID ON sCompanyID.CompanyId = UI.CompanyId
	  LEFT JOIN com_Code sTypeOfInsiderCodeID ON sTypeOfInsiderCodeID.CodeID = UI.UserTypeCodeId
	  LEFT JOIN com_Code sCategoryCodeID ON sCategoryCodeID.CodeID = UI.Category
	  LEFT JOIN com_Code sSubcategoryCodeID ON sSubcategoryCodeID.CodeID = UI.Subcategory
	  LEFT JOIN com_Code sDesignationCodeID ON sDesignationCodeID.CodeID = UI.DesignationId
	  LEFT JOIN com_Code sGradeCodeID ON sGradeCodeID.CodeID = UI.GradeId
	  LEFT JOIN com_Code sDepartmentID ON sDepartmentID.CodeID = UI.DepartmentId
     WHERE UI.UserInfoId = @inp_iUserInfoId_User AND Id = @nRecCounter
	 END

     SET @nRecCounter = @nRecCounter + 1
	END

	TRUNCATE TABLE rpt_ClawBackReport

	INSERT INTO rpt_ClawBackReport(UserInfoID, TransactionMasterId, EmployeeID, InsiderName, PAN, UserAddress, PinCode, Country, MobileNumber,
	Email, CompanyName, TypeOfInsider, Category, Subcategory, CINDIN, Designation, Grade, Location, Department, DmatAccount, AccountHolderName,
	PreclearanceID, RequestDate, SecurityType, TransactionType, TransactionDate, Quantity, Value,Currency)
	SELECT DISTINCT
	         Temp.UserInfoID,
	         Temp.TransactionMasterId,
	         Temp.EmployeeID,
			 Temp.InsiderName,
			 Temp.PAN,
			 Temp.UserAddress,
			 Temp.PinCode,
			 Temp.Country,
			 Temp.MobileNumber,
			 Temp.Email,
			 Temp.CompanyName,
			 Temp.TypeOfInsider,
			 Temp.Category,
             Temp.Subcategory,
			 Temp.CINDIN,
			 Temp.Designation,
			 Temp.Grade,
			 Temp.Location,
			 Temp.Department,
			 Temp.DmatAccount,
			 Temp.AccountHolderName,
		     Temp.PreclearanceID,
			 Temp.RequestDate,
			 Temp.SecurityType,
			 Temp.TransactionType,
			 Temp.TransactionDate,
		     Temp.Quantity,
			 Temp.Value,
			 Temp.Currency
	         FROM #tmpClawBack_Excel Temp 
			 ORDER BY InsiderName 
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		
		DROP TABLE #tmpPreclearanceID
	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CLAWBACKREPORT
	END CATCH
END
