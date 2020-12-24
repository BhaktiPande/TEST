IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_InitialDisclosureEmployeeIndividual')
DROP PROCEDURE [dbo].[st_rpt_InitialDisclosureEmployeeIndividual]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to List data for ID employee individual

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		03-Jun-2015

Modification History:
Modified By		Modified On		Description
Arundhati		18-Jun-2015		Paging is added
Arundhati		23-Jun-2015		Bug 0007600 is resolved. Details submission date and Last submission date are same but the comment was shown as "Not submitted in stip time"
Raghvendra		18-Jul-2015		Added a field for TransactionMasterId for SoftCopy and HardCopy submission dates. This is for adding a view link to the corresponding letter screen
Raghvendra		21-Jul-2015		Change to add support for multiple element search for dropdown fields
Arundhati		21-Jul-2015		Searching is handled for DMAT, Securities & RelationType
Arundhati		22-Jul-2015		Searching for AccountHolder
Raghvendra		29-Oct-2015		Fix for returning the dates in required format so that it can be seen correctly in Excel download.
Raghvendra		29-Oct-2015		Change to call the date formatting using a DB scalar function
Raghvendra		5-Nov-2015		Changes for showing NA for the fields specified in excel sheet provided by ED team in Mantis bug no 7889
ED				4-Jan-2016		Code integration done on 4-Jan-2016
ED				8-Jan-2016		Code integration done on 8-Jan-2016
Raghvendra		22-Feb-2016		Fix for user summary section not seen in case of employee individual view. Reason was that the transaction master id contains comma so it gives error.
ED				01-Mar-2016		Code merging done on 01-Mar-2016
Tushar			10-Mar-2016		Change Logic for Set Last Submission Date & evaluating Comment on the basis of Last Submission Date		
								1. If User Is Employee (Non Insider)
									If DateOfJoining <= Initial Disclosure before go live Date
									  Then Last Submssion Date =  Initial Disclosure before go live Date
									Else 
										Last Submssion Date = DateOfJoining + add days(Initial Disclosure within days of joining/being 
																				categorised as insider)	
								2. If User Is Employee (Insider)
									If DateOfBecomingInsider <= Initial Disclosure before go live Date
									  Then Last Submssion Date =  Initial Disclosure before go live Date
									Else 
										Last Submssion Date = DateOfBecomingInsider + add days(Initial Disclosure within days of joining/being 
																				categorised as insider)		
Raghvendra		28-Mar-2016		Corrected the ACID sent to the View link seen in the individual employee report top header section
Parag			13-May-2016		made change to show user details save at time of transaction submitted
Raghvendra/Parag  01-Jul-2016		Fix for transaction details not seen on the report.
Parag			05-Aug-2016		Made change to show negative balance. ie when transaction type is sell then quantity is shown in negative

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_InitialDisclosureEmployeeIndividual]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iOutputSeq			INT -- 1: User details, 2: Transaction status details, 3: Transaction Details
	,@inp_iUserInfoId			VARCHAR(MAX) -- = 339
	,@inp_sDMATDEtailsId		VARCHAR(200) -- Comma separated DematDetailsId 1,3,4 etc
	,@inp_sAccountHolder		NVARCHAR(100)
	,@inp_sRelationTypeCodeId	VARCHAR(200) -- Null: Filter not applicable, 0: Self, NonZero: Actual relation id (Comma separated ids)
	,@inp_sSecurityTypeCodeID	VARCHAR(200) -- Comma separated SecurityCodeIds 139001, 139002 etc
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEINDIV INT = -1

	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @dtImplementation DATETIME = '2015-01-01'

	DECLARE @nTransactionMasterId NVARCHAR(MAX)
	DECLARE @iCommentId INT = 162003
	DECLARE @sComment VARCHAR(100)
	DECLARE @iCommentsId_Ok INT = 162001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 162002
	DECLARE @iCommentsId_NotSubmitted INT = 162003

	DECLARE @sEmployeeID NVARCHAR(50)
	DECLARE @sInsiderName NVARCHAR(100)
	DECLARE @sDesignation NVARCHAR(100)
	DECLARE @sGrade NVARCHAR(100)
	DECLARE @sLocation NVARCHAR(100)
	DECLARE @sDepartment NVARCHAR(100)
	DECLARE @sCompanyName NVARCHAR(100)
	DECLARE @sTypeOfInsider NVARCHAR(100)
	DECLARE @sCINDIN NVARCHAR(100)
	
	DECLARE @dtDateOfBecomingInsider DATETIME
	DECLARE @dtDetailsSubmitLastDate DATETIME
	DECLARE @dtScpSubmitDate DATETIME
	DECLARE @dtHcpSubmitDate DATETIME
	DECLARE @sStatusOfSubmission VARCHAR(100)

	DECLARE @nDataType_String INT = 1
	DECLARE @nDataType_Int INT = 2
	DECLARE @nDataType_Date INT = 3

	DECLARE @tmpUserDetails TABLE(Id INT IDENTITY(1,1), RKey VARCHAR(20), Value NVARCHAR(50), DataType INT, TransactionMasterId VARCHAR(500) DEFAULT 0, DisclosureTypeCodeId INT DEFAULT 0, LetterForCodeId INT DEFAULT 0, Acid INT DEFAULT 0, LetterType char DEFAULT '')
	DECLARE @tmpUserTable TABLE(Id INT IDENTITY(1,1), UserInfoId INT, UserInfoIdRelative INT, SecurityTypeCodeId INT, DMATDetailsID INT, Relation VARCHAR(100))
	DECLARE @tmpDMATIds TABLE(DMATDetailsID INT)
	DECLARE @tmpSecurities TABLE(SecurityTypeCodeId INT)
	DECLARE @tmpRelatives TABLE(RelativeTypeCodeId INT)
	
	DECLARE @TRANSACTION_TYPE_BUY INT = 143001
	DECLARE @TRANSACTION_TYPE_SELL INT = 143002
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		/*
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN
			SET @inp_sSortField = ''
		END
		
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN
			SET @inp_sSortOrder = 'ASC'
		END
		*/
		
		CREATE TABLE #TEMP_UserID 
			(
				UserInfoId BIGINT
			)
		
		INSERT INTO #TEMP_UserID
		SELECT [PARAM] FROM FN_VIGILANTE_SPLIT(@inp_iUserInfoId, ',')
		
		IF EXISTS(SELECT CodeName FROM com_Code WHERE CodeId = 128003)
		BEGIN
			SELECT @dtImplementation = CodeName FROM com_Code WHERE CodeId = 128003
		END

		IF @inp_sDMATDEtailsId IS NOT NULL AND @inp_sDMATDEtailsId <> ''
		BEGIN
			INSERT INTO @tmpDMATIds SELECT * FROM uf_com_Split(@inp_sDMATDEtailsId)
		END
		ELSE
		BEGIN
			INSERT INTO @tmpDMATIds
			SELECT DMATDetailsID
			FROM usr_UserInfo UF JOIN usr_DMATDetails DD ON UF.UserInfoId = DD.UserInfoID
			INNER JOIN #TEMP_UserID TU ON TU.UserInfoID = UF.UserInfoId
			UNION
			SELECT DMATDetailsID
			FROM usr_UserInfo UF
				JOIN usr_UserRelation UR ON UR.UserInfoId = UF.UserInfoId
				--JOIN com_Code CSecurity ON CSecurity.CodeGroupId = 139
				--JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
				JOIN usr_DMATDetails DD ON UR.UserInfoIdRelative = DD.UserInfoID
				INNER JOIN #TEMP_UserID TU ON TU.UserInfoID = UF.UserInfoId
		END
		
		IF @inp_sSecurityTypeCodeID IS NOT NULL AND @inp_sSecurityTypeCodeID <> ''
		BEGIN
			INSERT INTO @tmpSecurities SELECT * FROM uf_com_Split(@inp_sSecurityTypeCodeID)
		END
		ELSE
		BEGIN
			INSERT INTO @tmpSecurities
			SELECT CodeID
			FROM com_Code CSecurity 
			WHERE CSecurity.CodeGroupId = 139
		END
		
		IF @inp_sRelationTypeCodeId IS NOT NULL AND @inp_sRelationTypeCodeId <> ''
		BEGIN
			INSERT INTO @tmpRelatives SELECT * FROM uf_com_Split(@inp_sRelationTypeCodeId)
		END
		ELSE
		BEGIN
			INSERT INTO @tmpRelatives
			SELECT 0
			UNION
			SELECT CodeID
			FROM com_Code CSecurity 
			WHERE CSecurity.CodeGroupId = 100
		END
		
		IF @inp_iOutputSeq = 1
		BEGIN
		
			-- Output #1 : USer details
			SELECT @sEmployeeID = EmployeeId, 
					@sInsiderName = CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') END,
					@sDesignation = CASE WHEN UserTypeCodeId = 101003 THEN CDesignation.CodeName ELSE DesignationText END,
					@sGrade = CASE WHEN UserTypeCodeId = 101003 THEN CGrade.CodeName ELSE GradeText END,
					@sLocation = UF.Location,
					@sDepartment = CASE WHEN UserTypeCodeId = 101003 THEN CDepartment.CodeName ELSE DepartmentText END,
					@sCompanyName = C.CompanyName,
					@sTypeOfInsider = CUserType.CodeName,
					@sCINDIN = CASE WHEN UserTypeCodeId = 101004 THEN CIN ELSE DIN END
			--, *
			FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId
			JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID
			LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID 
			LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
			LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
			INNER JOIN #TEMP_UserID TU ON TU.UserInfoID = UF.UserInfoId
			
			INSERT INTO @tmpUserDetails(RKey, Value, DataType, TransactionMasterId)
			VALUES ('rpt_lbl_19018', @sEmployeeID, @nDataType_String,0),
				('rpt_lbl_19019', CONVERT(NVARCHAR(max), @sInsiderName) , @nDataType_String,0),
				('rpt_lbl_19020', CONVERT(NVARCHAR(max), @sDesignation) , @nDataType_String,0),
				('rpt_lbl_19021', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sGrade),1)), @nDataType_String,0),
				('rpt_lbl_19022', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sLocation),1)), @nDataType_String,0),
				('rpt_lbl_19023', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sDepartment),1)), @nDataType_String,0),
				('rpt_lbl_19024', @sCompanyName, @nDataType_String,0),
				('rpt_lbl_19025', @sTypeOfInsider, @nDataType_String,0),
				('rpt_lbl_19026', @sCINDIN, @nDataType_String,0)
			INSERT INTO #tmpList(RowNumber, EntityID)
			VALUES (1,1)
				
			SELECT * FROM @tmpUserDetails ORDER BY ID
		END
		ELSE
		BEGIN
			BEGIN -- This is the replica of view vw_InitialDisclosureStatus
				SELECT * INTO #ELSubmit
				FROM (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId IN (153007, 153008) GROUP BY MapToId) AS ELSubmit
				
				SELECT * INTO #ELSCpSubmit
				FROM (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId  = 153009 GROUP BY MapToId) AS ELSCpSubmit
				
				SELECT * INTO #ELHCpSubmit
				FROM (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId = 153010 GROUP BY MapToId) AS ELHCpSubmit
				
				SELECT * INTO #ELHCpByCOSubmit
				FROM (SELECT MapToId, MAX(EventDate) AS EventDate FROM eve_EventLog WHERE EventCodeId = 153012 GROUP BY MapToId) AS ELHCpByCOSubmit
				
				SELECT * INTO #vw_InitialDisclosureStatus
				FROM 
				(
				SELECT distinct TransactionMasterId, TM.UserInfoId, TM.PeriodEndDate, TM.SoftCopyReq, TM.HardCopyReq,TP.DiscloInitSubmitToStExByCOHardcopyFlag AS HcpByCOReq,  
				CASE WHEN ELSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS DetailsSubmitStatus,  
				CASE WHEN ELSubmit.MapToId IS NOT NULL THEN ELSubmit.EventDate ELSE NULL END AS DetailsSubmitDate,  
				  
				CASE WHEN ELSCpSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS ScpSubmitStatus,  
				CASE WHEN ELSCpSubmit.MapToId IS NOT NULL THEN ELSCpSubmit.EventDate ELSE NULL END AS ScpSubmitDate,  
				  
				CASE WHEN ELHCpSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS HcpSubmitStatus,  
				CASE WHEN ELHCpSubmit.MapToId IS NOT NULL THEN ELHCpSubmit.EventDate ELSE NULL END AS HcpSubmitDate,  
				  
				CASE WHEN ELHCpByCOSubmit.MapToId IS NOT NULL THEN 1 ELSE 0 END AS HcpByCOSubmitStatus,  
				CASE WHEN ELHCpByCOSubmit.MapToId IS NOT NULL THEN ELHCpByCOSubmit.EventDate ELSE NULL END AS HcpByCOSubmitDate  
				FROM tra_TransactionMaster TM  
				JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId  
				LEFT JOIN #ELSubmit ELSubmit ON TM.TransactionMasterId = ELSubmit.MapToId  
				LEFT JOIN #ELSCpSubmit ELSCpSubmit ON TM.TransactionMasterId = ELSCpSubmit.MapToId  
				LEFT JOIN #ELHCpSubmit ELHCpSubmit ON TM.TransactionMasterId = ELHCpSubmit.MapToId  
				LEFT JOIN #ELHCpByCOSubmit ELHCpByCOSubmit ON TM.TransactionMasterId = ELHCpByCOSubmit.MapToId  
				WHERE DisclosureTypeCodeId = 147001 
				) AS OUT_PUT
			END
			
			SELECT @nTransactionMasterId = 	
					COALESCE(@nTransactionMasterId,'') + CAST(VW.TransactionMasterId AS VARCHAR(200)) + ','
					FROM #vw_InitialDisclosureStatus VW
					INNER JOIN #TEMP_UserID TU ON TU.UserInfoID = VW.UserInfoId
			
			
			IF ((SELECT COUNT(PARAM) FROM FN_VIGILANTE_SPLIT(@nTransactionMasterId ,',')) = 1)
			BEGIN
				SET @nTransactionMasterId = REPLACE(@nTransactionMasterId, ',','')
			END
					
			CREATE TABLE #TEMP_VW_TransactionMasterId 
			(
				TransactionMasterId BIGINT
			)
			
			
			INSERT INTO #TEMP_VW_TransactionMasterId(TransactionMasterId)
			select VW.TransactionMasterId FROM #vw_InitialDisclosureStatus VW
			INNER JOIN #TEMP_UserID TU ON TU.UserInfoID = VW.UserInfoId
					
			SELECT @iCommentId = 
			CASE WHEN UF.DateOfBecomingInsider IS NULL THEN
			   CASE WHEN DateOfJoining <= TP.DiscloInitDateLimit THEN 
									CASE WHEN vwIn.DetailsSubmitDate IS NULL THEN @iCommentsId_NotSubmitted
										WHEN vwIn.DetailsSubmitDate < DATEADD(D, 1, DiscloInitDateLimit) THEN @iCommentsId_Ok 
										ELSE @iCommentsId_NotSubmittedInTime 
									END
								 WHEN DateOfJoining > TP.DiscloInitDateLimit THEN 
									CASE WHEN vwIn.DetailsSubmitDate IS NULL THEN @iCommentsId_NotSubmitted
										WHEN vwIn.DetailsSubmitDate < DATEADD(D, DiscloInitLimit + 1, DateOfJoining) THEN @iCommentsId_Ok 
										ELSE @iCommentsId_NotSubmittedInTime 
									END
							END
			ELSE 
			 CASE WHEN DateOfBecomingInsider <= TP.DiscloInitDateLimit THEN 
									CASE WHEN vwIn.DetailsSubmitDate IS NULL THEN @iCommentsId_NotSubmitted
										WHEN vwIn.DetailsSubmitDate < DATEADD(D, 1, DiscloInitDateLimit) THEN @iCommentsId_Ok 
										ELSE @iCommentsId_NotSubmittedInTime 
									END
								 WHEN DateOfBecomingInsider > TP.DiscloInitDateLimit THEN 
									CASE WHEN vwIn.DetailsSubmitDate IS NULL THEN @iCommentsId_NotSubmitted
										WHEN vwIn.DetailsSubmitDate < DATEADD(D, DiscloInitLimit + 1, DateOfBecomingInsider) THEN @iCommentsId_Ok 
										ELSE @iCommentsId_NotSubmittedInTime 
									END
							END END,
					@dtDetailsSubmitLastDate = CASE WHEN UF.DateOfBecomingInsider IS NULL THEN
													CASE WHEN UF.DateOfJoining <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
															ELSE DATEADD(D, DiscloInitLimit, UF.DateOfJoining) END
											  ELSE CASE WHEN UF.DateOfBecomingInsider <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
													ELSE DATEADD(D, DiscloInitLimit, UF.DateOfBecomingInsider) END END
			FROM usr_UserInfo UF JOIN #vw_InitialDisclosureStatus vwIn ON UF.UserInfoId = vwIn.UserInfoId
			JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = vwIn.TransactionMasterId
			JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
			INNER JOIN #TEMP_UserID TU ON TU.UserInfoID = UF.UserInfoId
			
			SELECT @sComment = R.resourcevalue
			FROM com_Code C JOIN mst_Resource R ON C.CodeName = R.ResourceKey
			WHERE C.CodeID = @iCommentId

			IF @inp_iOutputSeq = 2 
			BEGIN
				-- Output #2 : Transaction status details

				SELECT @dtDateOfBecomingInsider = UF.DateOfBecomingInsider,
					@dtScpSubmitDate = vwIn.ScpSubmitDate, @dtHcpSubmitDate = vwIn.HcpSubmitDate, @sStatusOfSubmission = @sComment
				FROM usr_UserInfo UF LEFT JOIN vw_InitialDisclosureStatus vwIn ON UF.UserInfoId = vwIn.UserInfoId
				INNER JOIN #TEMP_UserID TU ON TU.UserInfoID = UF.UserInfoId
				--PRINT dbo.uf_rpt_FormatDateValue('Feb 18 2016  5:15PM',0)
				--PRINT dbo.uf_rpt_FormatDateValue('Feb 18 2016  5:16PM',0)
				
				INSERT INTO @tmpUserDetails(RKey, Value, DataType,TransactionMasterId,DisclosureTypeCodeId, LetterForCodeId, Acid , LetterType)
				VALUES ('rpt_lbl_19027', dbo.uf_rpt_FormatDateValue(@dtDateOfBecomingInsider,0), @nDataType_String,0,0,0,0,''),
						('rpt_lbl_19028',dbo.uf_rpt_FormatDateValue(@dtScpSubmitDate,0),@nDataType_String,(SELECT top 1 [PARAM] FROM FN_VIGILANTE_SPLIT(@nTransactionMasterId, ',')),147001,151002,166,'S'),
						('rpt_lbl_19029',dbo.uf_rpt_FormatDateValue(@dtHcpSubmitDate,0), @nDataType_String,(SELECT top 1 [PARAM] FROM FN_VIGILANTE_SPLIT(@nTransactionMasterId, ',')),147001,151002,166,'H'),
						('rpt_lbl_19030', @sStatusOfSubmission, @nDataType_String,0,0,0,0,''),
						('rpt_lbl_19031',dbo.uf_rpt_FormatDateValue(@dtDetailsSubmitLastDate,0) , @nDataType_Date,0,0,0,0,'')


--CASE  WHEN LastSubmissionDate IS NULL THEN '' ELSE UPPER(REPLACE(CONVERT(NVARCHAR, LastSubmissionDate, 106),' ','/')) END

				INSERT INTO #tmpList(RowNumber, EntityID)
				VALUES (1,1)

				SELECT * FROM @tmpUserDetails ORDER BY ID
			END
			ELSE IF @inp_iOutputSeq = 3
			BEGIN
				INSERT INTO @tmpUserTable(UserInfoId, UserInfoIdRelative, SecurityTypeCodeId, DMATDetailsID, Relation)
				SELECT UF.UserInfoId UserInfoID, UF.UserInfoId UserInfoIdRelative, CodeID SecurityTypeCodeId, DD.DMATDetailsID DMATDetailsID, 'Self'
				FROM usr_UserInfo UF JOIN com_Code CSecurity ON CSecurity.CodeGroupId = 139
					JOIN usr_DMATDetails DD ON UF.UserInfoId = DD.UserInfoID
					JOIN @tmpDMATIds tmpDD ON tmpDD.DMATDetailsID = DD.DMATDetailsID
					JOIN @tmpSecurities tmpSecurity ON tmpSecurity.SecurityTypeCodeId = CSecurity.CodeID
					JOIN @tmpRelatives tRelative ON tRelative.RelativeTypeCodeId = 0
					INNER JOIN #TEMP_UserID TU ON TU.UserInfoID = UF.UserInfoId				
				UNION
				SELECT UF.UserInfoId, UR.UserInfoIdRelative, CSecurity.CodeID, DD.DMATDetailsID, CRelation.CodeName
				FROM usr_UserInfo UF
					JOIN usr_UserRelation UR ON UR.UserInfoId = UF.UserInfoId
					JOIN com_Code CSecurity ON CSecurity.CodeGroupId = 139
					JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
					JOIN usr_DMATDetails DD ON UR.UserInfoIdRelative = DD.UserInfoID
					JOIN @tmpDMATIds tmpDD ON tmpDD.DMATDetailsID = DD.DMATDetailsID
					JOIN @tmpSecurities tmpSecurity ON tmpSecurity.SecurityTypeCodeId = CSecurity.CodeID
					JOIN @tmpRelatives tRelative ON tRelative.RelativeTypeCodeId = CRelation.CodeID
					INNER JOIN #TEMP_UserID TU ON TU.UserInfoID = UF.UserInfoId
				ORDER BY UserInfoID, UserInfoIdRelative, DMATDetailsID, SecurityTypeCodeId

				IF @inp_sAccountHolder IS NOT NULL AND @inp_sAccountHolder <> ''
				BEGIN
					DELETE tmpUser
					FROM @tmpUserTable tmpUser
						JOIN usr_UserInfo UF ON tmpUser.UserInfoId = UF.UserInfoId
						JOIN mst_Company C ON UF.CompanyId = C.CompanyId
						JOIN usr_UserInfo UFRelative ON tmpUser.UserInfoIdRelative = UFRelative.UserInfoId
					WHERE CASE WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(UFRelative.FirstName, '') + ' ' + ISNULL(UFRelative.LastName, '') END NOT LIKE '%' + @inp_sAccountHolder + '%'
					
				END
				
				INSERT INTO #tmpList(RowNumber, EntityID)
				SELECT DISTINCT DENSE_RANK() OVER(Order BY t.Id asc, t.Id), t.Id from @tmpUserTable t
				--SELECT ID, ID FROM @tmpUserTable t

				-- Output #3 : Transaction details

				create table #tempFinal( RowNo int identity(1,1) ,UserInfoId	int, 
											rpt_grd_19032 Nvarchar(max),	
											rpt_grd_19033 Nvarchar(max),	
											rpt_grd_19034 Nvarchar(max),	
											rpt_grd_19035 Nvarchar(max),
											rpt_grd_19036 Nvarchar(max),
											rpt_grd_19037 Nvarchar(max),
											rpt_grd_19038 int)
			insert into #tempFinal
				SELECT 
					UF.UserInfoId,
					CASE 
						WHEN TUD.TransactionDetailsId IS NULL THEN DMat.DEMATAccountNumber
						ELSE TUD.DematAccountNumber
					END AS rpt_grd_19032, 
					CASE 
						WHEN TUD.TransactionDetailsId IS NULL THEN 
								CASE 
									WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName 
									ELSE ISNULL(UFRelative.FirstName, '') + ' ' + ISNULL(UFRelative.LastName, '') 
								END 
						ELSE 
							CASE 
								WHEN UF.UserTypeCodeId = 101004 THEN TUD.CompanyName 
								ELSE ISNULL(TUD.FirstName, '') + ' ' + ISNULL(TUD.LastName, '') 
							END 
					END AS rpt_grd_19033,
					CASE 
						WHEN TUD.TransactionDetailsId IS NULL THEN tmpUser.Relation 
						ELSE TUD.Relation
					END AS rpt_grd_19034,
					C.CompanyName AS rpt_grd_19035,
					C.ISINNumber AS rpt_grd_19036,
					CSecurityType.CodeName AS rpt_grd_19037,
					SUM(ISNULL(
						CASE 
							WHEN TD.TransactionTypeCodeId = @TRANSACTION_TYPE_SELL THEN (-1 * (TD.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)))
							WHEN TD.TransactionTypeCodeId = @TRANSACTION_TYPE_BUY THEN TD.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)
						END, 0)
						) AS rpt_grd_19038
				FROM #tmpList t JOIN @tmpUserTable tmpUser ON t.EntityId = tmpUser.Id
					JOIN usr_UserInfo UF ON tmpUser.UserInfoId = UF.UserInfoId
					JOIN mst_Company C ON UF.CompanyId = C.CompanyId
					JOIN usr_UserInfo UFRelative ON tmpUser.UserInfoIdRelative = UFRelative.UserInfoId
					JOIN com_Code CSecurityType ON tmpUser.SecurityTypeCodeId = CSecurityType.CodeID
					LEFT JOIN tra_TransactionMaster TM ON TM.UserInfoId = UF.UserInfoId 
					INNER JOIN #TEMP_VW_TransactionMasterId TVWT ON TVWT.TransactionMasterId = TM.TransactionMasterId
					INNER JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId AND TD.ForUserInfoId = UFRelative.UserInfoId
							AND td.SecurityTypeCodeId = CSecurityType.CodeID AND tmpUser.DMATDetailsID = TD.DMATDetailsID
					LEFT JOIN usr_DMATDetails DMat ON tmpUser.DMATDetailsID = DMat.DMATDetailsID
					LEFT JOIN tra_TradingTransactionUserDetails TUD ON TD.TransactionDetailsId = TUD.TransactionDetailsId AND TUD.FormDetails = 0
				GROUP BY UF.UserInfoId, Id, DMat.DEMATAccountNumber, UF.UserTypeCodeId, C.CompanyName, UFRelative.FirstName, UFRelative.LastName,
					tmpUser.Relation, C.CompanyName, C.ISINNumber, CSecurityType.CodeName, 
					TUD.DematAccountNumber,TUD.CompanyName,TUD.FirstName,TUD.LastName,
					TUD.Relation,TUD.TransactionDetailsId,
					T.RowNumber
				ORDER BY T.RowNumber
			
				insert into #TEMP_VW_TransactionMasterId(TransactionMasterId)
				select TransactionMasterId from tra_TransactionMaster tm where UserInfoId in(
				select UserInfoIdRelative from usr_UserRelation where UserInfoId=@inp_iUserInfoId)

				DECLARE @CompName Nvarchar(max)
				DECLARE @ISNNo varchar(max)
				select @CompName=c.CompanyName,@ISNNo=c.ISINNumber from usr_UserInfo u inner join mst_Company c on u.CompanyId=c.CompanyId where UserInfoId= @inp_iUserInfoId
				insert into #tempFinal
							SELECT 
								UF.UserInfoId,
								CASE 
									WHEN TUD.TransactionDetailsId IS NULL THEN DMat.DEMATAccountNumber
									ELSE TUD.DematAccountNumber
								END AS rpt_grd_19032, 
								CASE 
									WHEN TUD.TransactionDetailsId IS NULL THEN 
											CASE 
												WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName 
												ELSE ISNULL(UFRelative.FirstName, '') + ' ' + ISNULL(UFRelative.LastName, '') 
											END 
									ELSE 
										CASE 
											WHEN UF.UserTypeCodeId = 101004 THEN TUD.CompanyName 
											ELSE ISNULL(TUD.FirstName, '') + ' ' + ISNULL(TUD.LastName, '') 
										END 
								END AS rpt_grd_19033,
								CASE 
									WHEN TUD.TransactionDetailsId IS NULL THEN tmpUser.Relation 
									ELSE TUD.Relation
								END AS rpt_grd_19034,
								C.CompanyName AS rpt_grd_19035,
								C.ISINNumber AS rpt_grd_19036,
								CSecurityType.CodeName AS rpt_grd_19037,
								SUM(ISNULL(
									CASE 
										WHEN TD.TransactionTypeCodeId = @TRANSACTION_TYPE_SELL THEN (-1 * (TD.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)))
										WHEN TD.TransactionTypeCodeId = @TRANSACTION_TYPE_BUY THEN TD.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)
									END, 0)
									) AS rpt_grd_19038 
							FROM #tmpList t JOIN @tmpUserTable tmpUser ON t.EntityId = tmpUser.Id
								JOIN usr_UserInfo UF ON tmpUser.UserInfoIdRelative = UF.UserInfoId and tmpUser.UserInfoIdRelative != @inp_iUserInfoId
								left join mst_Company C ON UF.CompanyId = C.CompanyId
								JOIN usr_UserInfo UFRelative ON tmpUser.UserInfoIdRelative = UFRelative.UserInfoId
								JOIN com_Code CSecurityType ON tmpUser.SecurityTypeCodeId = CSecurityType.CodeID
								LEFT JOIN tra_TransactionMaster TM ON TM.UserInfoId = UF.UserInfoId 
								INNER JOIN #TEMP_VW_TransactionMasterId TVWT ON TVWT.TransactionMasterId = TM.TransactionMasterId
								LEFT JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId AND TD.ForUserInfoId = UFRelative.UserInfoId
										AND td.SecurityTypeCodeId = CSecurityType.CodeID AND tmpUser.DMATDetailsID = TD.DMATDetailsID
								LEFT JOIN usr_DMATDetails DMat ON tmpUser.DMATDetailsID = DMat.DMATDetailsID
								LEFT JOIN tra_TradingTransactionUserDetails TUD ON TD.TransactionDetailsId = TUD.TransactionDetailsId AND TUD.FormDetails = 0
						
							GROUP BY UF.UserInfoId, Id, DMat.DEMATAccountNumber, UF.UserTypeCodeId, C.CompanyName, UFRelative.FirstName, UFRelative.LastName,
								tmpUser.Relation, C.CompanyName, C.ISINNumber, CSecurityType.CodeName, 
								TUD.DematAccountNumber,TUD.CompanyName,TUD.FirstName,TUD.LastName,
								TUD.Relation,TUD.TransactionDetailsId,
								T.RowNumber
							
						ORDER BY T.RowNumber-- this code only for relative data
				
				select UserInfoId,	rpt_grd_19032,	rpt_grd_19033,	rpt_grd_19034,	CASE WHEN rpt_grd_19035 is null THEN @CompName ELSE rpt_grd_19035 END AS rpt_grd_19035,		CASE WHEN rpt_grd_19036 is null THEN @ISNNo ELSE rpt_grd_19036 END AS rpt_grd_19036	,rpt_grd_19037,	rpt_grd_19038
						from #tempFinal
						WHERE ((@inp_iPageSize = 0)
										OR (RowNo BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1)
									AND (@inp_iPageNo * @inp_iPageSize)))
								ORDER BY RowNo

	 
			END
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEINDIV
	END CATCH
END
