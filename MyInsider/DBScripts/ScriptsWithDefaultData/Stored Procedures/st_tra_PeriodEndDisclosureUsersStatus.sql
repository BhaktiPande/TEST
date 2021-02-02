IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosureUsersStatus')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosureUsersStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************
Description:	Procedure to get users details for period end disclosure 

Returns:		Return 0, if success.
				
Created by:		Parag
Created on:		18-May-2015

Modification History:
Modified By		Modified On		Description
Parag			15-Jun-2015		Made change to fix paging issue for grid list
Parag			15-Jun-2015		Made change to allow disclosure after period end submission date is over 
Parag			11-Jul-2015		Made change to show "Not Required" text for soft copy, hard copy and stock exchange button 
								if these event does not required submission as per trading policy 
Parag			10-Aug-2015		Made change to handle uploaded status 
Gaurishankar	30-Sept-2015	Change for Uploaded button text (Line no 79,138 & 377)
Parag			12-Oct-2015		Made change to show period end disclosuer for the period end type define in trading policy 
Parag			13-Oct-2015		Made change for filter (do not consider year and period code) and fix for issue found while testing  
Parag			29-Oct-2015		Made change to show period end disclouser change in trading policy  
Arundhati		31-Oct-2015		Codes (dates) for Period end date are changed. Now that are stored as the 1st of next month.
Parag			04-Dec-2015		Made change to show period end record on 1st day of month instead of last day of month
Parag			22-Jan-2016		Made change to use function for getting calender date or trading date as per configuration
Parag			01-Apr-2016		Made change to fix issue of show pending button if user has made initial disclosure on last date of month
Parag			29-Apr-2016		Made change to show latest transaction record top of list 
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Tushar			16-Sep-2016     Change Initial Disclosure, Continuous Disclosure and Period End Disclosure List pages for showing new icons for Entered/Uploaded.

******************************************************************************************************************

Usage:

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosureUsersStatus]
	@inp_iPageSize						INT = 10,
	@inp_iPageNo						INT = 1,
	@inp_sSortField						VARCHAR(255),
	@inp_sSortOrder						VARCHAR(5),
	@inp_iYearCodeId 					INT = null,
	@inp_iPeriodCodeId 					INT = null,
	@inp_sEmployeeId					NVARCHAR(50) = null,
	@inp_sInsiderName					NVARCHAR(50) = null,
	@inp_iDesignation					NVARCHAR(50) = null,
	
	@inp_dtTradingSubmiitedFrom			NVARCHAR(25) = null,
	@inp_dtTradingSubmiitedTo			NVARCHAR(25) = null,
	@inp_iTradingSubmiitedStatus		INT = null,

	@inp_dtSoftCopySubmiitedFrom		NVARCHAR(25) = null,
	@inp_dtSoftCopySubmiitedTo			NVARCHAR(25) = null,
	@inp_iSoftCopySubmiitedStatus		INT = null,
	
	@inp_dtHardCopySubmiitedFrom		NVARCHAR(25) = null,
	@inp_dtHardCopySubmiitedTo			NVARCHAR(25) = null,
	@inp_iHardCopySubmiitedStatus		INT = null,

	@inp_dtStockExchangeSubmiitedFrom	NVARCHAR(25) = null,
	@inp_dtStockExchangeSubmiitedTo		NVARCHAR(25) = null,
	@inp_iStockExchangeSubmiitedStatus	INT = null,
	@inp_sEmployeePAN                   NVARCHAR(50),
	@inp_sEmployeeStatus                INT,
	@inp_isFromDashboard				INT=0,	

	@out_nReturnValue 					INT = 0 OUTPUT,
	@out_nSQLErrCode 					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	PRINT(@inp_isFromDashboard)
	DECLARE @ERR_PERIODENDDISCLOSURE_USERSSTATUS	INT = 17173 -- Error occurred while fetching users list of period end disclosure.
	DECLARE @dtCurrentDate 							DATETIME = CONVERT(date, dbo.uf_com_GetServerDate())
	DECLARE @nPeriodType 							INT
	DECLARE @nPeriodYear 							INT
	DECLARE @dtPeriodStartDate						DATETIME
	
	DECLARE @sSQL									NVARCHAR(MAX) = ''
	
	DECLARE @nStatusFlag_Complete					INT = 154001
	DECLARE @nStatusFlag_Pending					INT = 154002
	DECLARE @nStatusFlag_DoNotShow					INT = 154003
	DECLARE @nStatusFlag_Uploaded					INT = 154006
	DECLARE @nStatusFlag_NotRequired				INT = 154007
	DECLARE @nTradingPolicyId						INT
	DECLARE @nDiscloPeriodEndToCOByInsdrLimit		INT = 0
	DECLARE @nDiscloPeriodEndSubmitToStExByCOLimit	INT = 0
	
	DECLARE @sPeriodEndDisclosure_Pending			VARCHAR(255)
	DECLARE @sPolicyDocumentStatus_NotRequired		VARCHAR(255)
	DECLARE @sUploadedButtonText					VARCHAR(255)
	
	DECLARE @nYear									INT
	DECLARE @nYearCodeId							INT
		
	DECLARE @nExchangeTypeCodeId_NSE				INT = 116001
	
	DECLARE @nEmployeeStatusLive                                                VARCHAR(100),
			@nEmployeeStatusSeparated                                           VARCHAR(100),
			@nEmployeeStatusInactive                                            VARCHAR(100),
			@nEmpStatusLiveCode                                                 INT = 510001,
			@nEmpStatusSeparatedCode                                            INT = 510002,
			@nEmpStatusInactiveCode                                             INT = 510003,
			@nEmployeeActive                                                    INT = 102001,
			@nEmployeeInActive                                                  INT = 102002
	
	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		
		--check return value and if not 0 then return 
		IF (@out_nReturnValue <> 0)
		BEGIN 
			return @out_nReturnValue;
		END
		
		-- Define temporary table and add user details for period end disclosure
		CREATE TABLE #tmpPeriodEndDisclosureUserList
			(Id INT IDENTITY(1,1), UserInfoId INT, EmployeeId NVARCHAR(512), InsiderName NVARCHAR(512), 
			CompanyId INT, CompanyName NVARCHAR(512), UserType INT, DesignationId INT, Designation NVARCHAR(512),UserPanNumber NVARCHAR(50),EmpStatus INT,
			DateOfBecomingInsider DATETIME, DateOfSeparation DATETIME, TradingPolicyId INT, TransactionMasterId INT, 
			
			SubmissionLastDate DATETIME, SubmissionByCOLastDate DATETIME,
			SubmissionEventDate DATETIME, SubmissionButtonText NVARCHAR(255), SubmissionStatusCodeId INT DEFAULT 154003,
			
			ScpReq INT DEFAULT 0, 
			ScpEventDate DATETIME, ScpButtonText NVARCHAR(255), ScpStatusCodeId INT DEFAULT 154003,
			
			HCpReq INT DEFAULT 0, 
			HcpEventDate DATETIME, HcpButtonText NVARCHAR(255), HcpStatusCodeId INT DEFAULT 154003,
			
			HCpByCOReq INT DEFAULT 0,
			HCpByCOEventDate DATETIME, HCpByCOButtonText NVARCHAR(255), HCpByCOStatusCodeId INT DEFAULT 154003,
			
			DiscloPeriodEndToCOByInsdrLimit INT, DiscloPeriodEndSubmitToStExByCOLimit INT,
			SubmissionDaysRemaining INT DEFAULT -1, SubmissionDaysRemainingByCO INT DEFAULT -1,
			YearCodeId INT, PeriodTypeId INT,PeriodType varchar(50), PeriodCodeId INT, PeriodEndDate DATETIME, IsThisCurrentPeriodEnd INT DEFAULT 0, 
			InitialDisclosureDate DATETIME,IsUploadAndEnterEventGenerate INT DEFAULT 0,
			category INT, EmailId nvarchar(500)
			)
		
		-- Get button text
		SELECT @sPeriodEndDisclosure_Pending = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17005'
		SELECT @sPolicyDocumentStatus_NotRequired = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17334'
		--Uploaded Button Text
		SELECT @sUploadedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17075'
		
		SELECT @nEmployeeStatusLive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusLiveCode   
			
		SELECT @nEmployeeStatusSeparated = CodeName FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode  
			
		SELECT @nEmployeeStatusInactive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusInactiveCode
		
		-- Get list of user who are insider between start and end of period and also apply filter if defined
		INSERT INTO #tmpPeriodEndDisclosureUserList 
			(UserInfoId, EmployeeId, InsiderName, CompanyId, CompanyName, UserType, DesignationId, Designation, UserPanNumber, EmpStatus,DateOfBecomingInsider, 
			DateOfSeparation, PeriodEndDate,category, EmailId)
		SELECT 
			UI.UserInfoId, UI.EmployeeId, 
			CASE WHEN UI.UserTypeCodeId = 101004 THEN Com.CompanyName ELSE UI.FirstName + ISNULL(' ' + UI.LastName, '') END as InsiderName, 
			UI.CompanyId, Com.CompanyName, UI.UserTypeCodeId as UserType, UI.DesignationId,
			CASE WHEN UI.DesignationId IS NULL THEN UI.DesignationText ELSE 
				(CASE WHEN CD.DisplayCode IS NULL OR CD.DisplayCode = '' THEN CD.CodeName ELSE CD.DisplayCode END) END as Designation,
			UI.PAN AS UserPanNumber,
			CASE WHEN UI.StatusCodeId = @nEmployeeActive AND UI.DateOfSeparation IS NULL THEN @nEmpStatusLiveCode
				            WHEN UI.StatusCodeId = @nEmployeeActive AND UI.DateOfSeparation IS NOT NULL THEN @nEmpStatusSeparatedCode
				            WHEN UI.StatusCodeId = @nEmployeeInActive THEN @nEmpStatusInactiveCode
				            END AS EmpStatus,
			UI.DateOfBecomingInsider, UI.DateOfSeparation, LastPeriodEndUser.PeriodEndDate,
			UI.Category, UI.EmailId
		From 
			(
				SELECT UserInfoId, MAX(PeriodEndDate) as PeriodEndDate FROM vw_PeriodEndDisclosureStatus vwPEDS
				GROUP BY UserInfoId
			) AS LastPeriodEndUser LEFT JOIN usr_UserInfo UI ON LastPeriodEndUser.UserInfoId = UI.UserInfoId			
			LEFT JOIN mst_Company Com on UI.CompanyId = Com.CompanyId
			LEFT JOIN com_Code CD on UI.DesignationId IS NOT NULL AND UI.DesignationId = CD.CodeID
		WHERE 
			UI.UserTypeCodeId in (101003, 101004, 101006) 
			AND UI.DateOfBecomingInsider IS NOT NULL 
			--AND (UI.DateOfSeparation IS NULL OR @dtPeriodStartDate <= UI.DateOfSeparation) -- tempararilay commneted
			-- check for employee id filter
			AND (@inp_sEmployeeId IS NULL OR (@inp_sEmployeeId <> '' AND UI.EmployeeId LIKE N'%'+@inp_sEmployeeId+'%'))
			-- check for insider name filter
			AND (@inp_sInsiderName IS NULL OR (@inp_sInsiderName <> '' AND 
				CASE WHEN UI.UserTypeCodeId = 101004 THEN Com.CompanyName ELSE UI.FirstName + ISNULL(' ' + UI.LastName, '') END like N'%'+@inp_sInsiderName+'%'))
			-- check for designation filter
			AND (@inp_iDesignation IS NULL OR (@inp_iDesignation <> '' AND 
				CASE WHEN UI.DesignationId IS NULL THEN UI.DesignationText ELSE 
					(CASE WHEN CD.DisplayCode IS NULL OR CD.DisplayCode = '' THEN CD.CodeName ELSE CD.DisplayCode END) END LIKE N'%'+@inp_iDesignation+'%'))
			
		    -- check for pan Number filter
			AND (@inp_sEmployeePAN IS NULL OR (@inp_sEmployeePAN <> '' AND UI.PAN LIKE N'%'+@inp_sEmployeePAN+'%'))
				
		-- Get each user's transaction master id for period end from records from event log
		UPDATE Tmp
		SET 
			TransactionMasterId = vwPEDS.TransactionMasterId,
			
			SubmissionEventDate = vwPEDS.DetailsSubmitDate,
			SubmissionStatusCodeId = CASE 
										WHEN vwPEDS.DetailsSubmitStatus = 1 THEN @nStatusFlag_Complete 
										WHEN vwPEDS.DetailsSubmitStatus = 2 THEN @nStatusFlag_Uploaded 
										ELSE @nStatusFlag_DoNotShow END,
			
			ScpReq = vwPEDS.SoftCopyReq,
			ScpEventDate = vwPEDS.ScpSubmitDate,
			ScpStatusCodeId = CASE 
								WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.DetailsSubmitStatus = 1 THEN -- if soft copy is required 
									(CASE 
										WHEN vwPEDS.ScpSubmitStatus = 0 THEN @nStatusFlag_Pending
										WHEN vwPEDS.ScpSubmitStatus = 1 THEN @nStatusFlag_Complete
										ELSE @nStatusFlag_DoNotShow END)
								-- if soft copy is NOT required 
								WHEN vwPEDS.SoftCopyReq = 0 AND vwPEDS.DetailsSubmitStatus = 1 THEN @nStatusFlag_NotRequired 
								ELSE @nStatusFlag_DoNotShow END,
			
			HCpReq = vwPEDS.HardCopyReq,
			HcpEventDate = vwPEDS.HcpSubmitDate,
			HcpStatusCodeId = CASE 
								WHEN vwPEDS.HardCopyReq = 1 AND vwPEDS.DetailsSubmitStatus = 1 THEN -- if hard copy is required 
									(CASE 
										-- if soft copy is required 
										WHEN vwPEDS.SoftCopyReq = 1 THEN 
											(CASE 
												WHEN vwPEDS.ScpSubmitStatus = 0 THEN  @nStatusFlag_DoNotShow
												WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpSubmitStatus = 0 THEN  @nStatusFlag_Pending
												WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpSubmitStatus = 1 THEN  @nStatusFlag_Complete
												ELSE @nStatusFlag_DoNotShow END)
										-- if soft copy is NOT required 
										ELSE 
											(CASE 
												WHEN vwPEDS.HcpSubmitStatus = 0 THEN @nStatusFlag_Pending 
												WHEN vwPEDS.HcpSubmitStatus = 1 THEN @nStatusFlag_Complete 
												ELSE @nStatusFlag_DoNotShow END)
										END) 
								-- if hard copy is NOT required 
								WHEN vwPEDS.HardCopyReq = 0 AND vwPEDS.DetailsSubmitStatus = 1 THEN
									(CASE 
										-- if soft copy is required 
										WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.ScpSubmitStatus = 1 THEN @nStatusFlag_NotRequired
										-- if soft copy is NOT required 
										WHEN vwPEDS.SoftCopyReq = 0 THEN @nStatusFlag_NotRequired 
										ELSE @nStatusFlag_DoNotShow END)
								ELSE @nStatusFlag_DoNotShow END,
								
			HCpByCOReq = vwPEDS.HCpByCOReq,
			HCpByCOEventDate = vwPEDS.HCpByCOSubmitDate,
			HCpByCOStatusCodeId = CASE 
									WHEN vwPEDS.DetailsSubmitStatus = 1 THEN 
										(CASE 
											WHEN vwPEDS.HcpByCOReq = 1 THEN 
												(CASE 
													-- if soft copy and hard copy both are required 
													WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.HardCopyReq = 1 THEN 
														(CASE 
															WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 0 THEN @nStatusFlag_Pending
															WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 1 THEN @nStatusFlag_Complete
															ELSE @nStatusFlag_DoNotShow END)
													-- if only soft copy is are required 
													WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.HardCopyReq = 0 THEN 
														(CASE 
															WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 0 THEN @nStatusFlag_Pending
															WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 1 THEN @nStatusFlag_Complete
															ELSE @nStatusFlag_DoNotShow END)
													-- if only hard copy is are required 
													WHEN vwPEDS.SoftCopyReq = 0 AND vwPEDS.HardCopyReq = 1 THEN 
														(CASE 
															WHEN vwPEDS.HcpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 0 THEN @nStatusFlag_Pending
															WHEN vwPEDS.HcpSubmitStatus = 1 AND vwPEDS.HcpByCOSubmitStatus = 1 THEN @nStatusFlag_Complete
															ELSE @nStatusFlag_DoNotShow END)
													WHEN vwPEDS.SoftCopyReq = 0 AND vwPEDS.HardCopyReq = 0 THEN @nStatusFlag_Pending
													ELSE @nStatusFlag_DoNotShow END)
											ELSE -- Stock exchange submission not required  
												(CASE 
													-- if soft copy and hard copy both are required 
													WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.HardCopyReq = 1 THEN 
														(CASE 
															WHEN vwPEDS.ScpSubmitStatus = 1 AND vwPEDS.HcpSubmitStatus = 1 THEN @nStatusFlag_DoNotShow
															ELSE @nStatusFlag_DoNotShow END)
													-- if only soft copy is are required 
													WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.HardCopyReq = 0 THEN 
														(CASE 
															WHEN vwPEDS.ScpSubmitStatus = 1 THEN @nStatusFlag_DoNotShow
															ELSE @nStatusFlag_DoNotShow END)
													-- if only hard copy is are required 
													WHEN vwPEDS.SoftCopyReq = 0 AND vwPEDS.HardCopyReq = 1 THEN 
														(CASE 
															WHEN vwPEDS.HcpSubmitStatus = 1 THEN @nStatusFlag_DoNotShow
															ELSE @nStatusFlag_DoNotShow END)
													ELSE @nStatusFlag_NotRequired END)
											END)
									ELSE @nStatusFlag_DoNotShow END
									
		FROM #tmpPeriodEndDisclosureUserList Tmp JOIN vw_PeriodEndDisclosureStatus vwPEDS ON
				Tmp.UserInfoId = vwPEDS.UserInfoId AND CONVERT(date,Tmp.PeriodEndDate) = CONVERT(date,vwPEDS.PeriodEndDate)
		
		-- Update trading policy id and submission last date for those had transaction 
		UPDATE Tmp
		SET
			TradingPolicyId = UPEMap.TradingPolicyId,
			PeriodTypeId = CASE 
							WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
							WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
							WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
							WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
							ELSE TP.DiscloPeriodEndFreq 
						END,
			PeriodType = CASE 
							WHEN TP.DiscloPeriodEndFreq = 137001 THEN (select CodeName from com_code where codeId='123001') -- Yearly
							WHEN TP.DiscloPeriodEndFreq = 137002 THEN (select CodeName from com_code where codeId='123003') -- Quarterly
							WHEN TP.DiscloPeriodEndFreq = 137003 THEN (select CodeName from com_code where codeId='123004') -- Monthly
							WHEN TP.DiscloPeriodEndFreq = 137004 THEN (select CodeName from com_code where codeId='123002') -- half yearly
							ELSE (select CodeName from com_code where codeId=TP.DiscloPeriodEndFreq) 
						END,
			DiscloPeriodEndToCOByInsdrLimit = TP.DiscloPeriodEndToCOByInsdrLimit,
			SubmissionLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(TM.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)),-- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), TM.PeriodEndDate),
			DiscloPeriodEndSubmitToStExByCOLimit = TP.DiscloPeriodEndSubmitToStExByCOLimit,
			SubmissionByCOLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(TM.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) -- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), TM.PeriodEndDate)
		FROM #tmpPeriodEndDisclosureUserList Tmp 
		JOIN tra_TransactionMaster TM ON Tmp.TransactionMasterId = TM.TransactionMasterId
		JOIN tra_UserPeriodEndMapping UPEMap ON CONVERT(date, UPEMap.PEEndDate) = CONVERT(date, TM.PeriodEndDate) AND UPEMap.UserInfoId = TM.UserInfoId
		JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
		WHERE Tmp.TransactionMasterId IS NOT NULL
		
		
		DECLARE @dtLastPeriodEndDate DATETIME
		DECLARE @nTempId INT
	
		DECLARE PE_Cursor CURSOR FOR 
		SELECT Id, PeriodEndDate FROM #tmpPeriodEndDisclosureUserList
		
		OPEN PE_Cursor
		
		FETCH NEXT FROM PE_Cursor INTO @nTempId, @dtLastPeriodEndDate
		
		WHILE @@FETCH_STATUS = 0
		BEGIN 
			SELECT @nYear = YEAR(@dtLastPeriodEndDate)
			
			DECLARE @nYearStartMonth INT = 4
			DECLARE @nDatabaseName VARCHAR(100)
			SELECT @nDatabaseName = db_name()
			IF(@nDatabaseName = 'Vigilante_AccelyaSolutions')
			BEGIN
				SET @nYearStartMonth = 7
			END
			IF MONTH(@dtLastPeriodEndDate) < @nYearStartMonth AND @nDatabaseName <> 'Vigilante_Hexaware'
			BEGIN
				SET @nYear = @nYear - 1
			END
			
			SELECT @nYearCodeId = CodeID FROM com_Code WHERE CodeGroupId = 125 AND CodeName LIKE CONVERT(VARCHAR(4), @nYear) + '%'
			
			-- set period for which period end is done
			UPDATE tmp 
			SET
				YearCodeId = @nYearCodeId,
				PeriodCodeId = CdPeriod.CodeID
			FROM #tmpPeriodEndDisclosureUserList tmp 
			JOIN rul_TradingPolicy TP ON tmp.TradingPolicyId = TP.TradingPolicyId AND tmp.Id = @nTempId
			JOIN com_Code CdPeriod ON CdPeriod.ParentCodeId = tmp.PeriodTypeId and CdPeriod.CodeGroupId = 124 
					and CONVERT(date, tmp.PeriodEndDate) = CONVERT(date, DATEADD(DAY, -1, DATEADD(YEAR, @nYear-1970,convert(datetime, CdPeriod.Description))))
			
			FETCH NEXT FROM PE_Cursor INTO @nTempId, @dtLastPeriodEndDate
		END
		
		CLOSE PE_Cursor;
		DEALLOCATE  PE_Cursor;
		
		
		
		--Update submission date records which does not have Transaction master id
		UPDATE Tmp 
		SET 
			SubmissionLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(Tmp.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)), -- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), Tmp.PeriodEndDate),
			SubmissionByCOLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(Tmp.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) --DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), Tmp.PeriodEndDate)
		FROM #tmpPeriodEndDisclosureUserList Tmp LEFT JOIN rul_TradingPolicy TP ON Tmp.TradingPolicyId = TP.TradingPolicyId 
		WHERE Tmp.TransactionMasterId IS NULL and Tmp.TradingPolicyId <> 0


		-- Update Initial disclosure date
		UPDATE Tmp
		SET
			InitialDisclosureDate = EL.EventDate
		FROM #tmpPeriodEndDisclosureUserList Tmp LEFT JOIN eve_EventLog EL on 
				Tmp.UserInfoId=EL.UserInfoId AND MapToTypeCodeId = 132005 AND EventCodeId = 153035
		
		-- Update Submission text and status
		UPDATE Tmp
		SET
			SubmissionStatusCodeId = @nStatusFlag_Pending,
			SubmissionButtonText = @sPeriodEndDisclosure_Pending
		FROM #tmpPeriodEndDisclosureUserList Tmp 
		WHERE Tmp.TradingPolicyId <> 0 AND Tmp.PeriodEndDate < @dtCurrentDate 
				AND (Tmp.InitialDisclosureDate IS NOT NULL AND CONVERT(date, Tmp.InitialDisclosureDate) <= Tmp.PeriodEndDate)
				AND Tmp.SubmissionEventDate IS NULL
		
		-- update records whos period end date is today ie last day of month 
		UPDATE Tmp
		SET
			SubmissionStatusCodeId = @nStatusFlag_DoNotShow,
			SubmissionButtonText = NULL
		FROM #tmpPeriodEndDisclosureUserList Tmp
		WHERE Tmp.TradingPolicyId <> 0 AND Tmp.PeriodEndDate = @dtCurrentDate 
				AND (Tmp.InitialDisclosureDate IS NOT NULL AND Tmp.InitialDisclosureDate < Tmp.PeriodEndDate)
				AND Tmp.SubmissionEventDate IS NULL
		
		-- Apply trading filter - from date, to date and status
		DELETE FROM #tmpPeriodEndDisclosureUserList 
		WHERE @inp_iTradingSubmiitedStatus IS NOT NULL AND SubmissionStatusCodeId <> @inp_iTradingSubmiitedStatus
		
		DELETE FROM #tmpPeriodEndDisclosureUserList 
		WHERE 
			(@inp_dtTradingSubmiitedFrom IS NOT NULL AND CONVERT(DATETIME,SubmissionEventDate) < CONVERT(DATETIME,@inp_dtTradingSubmiitedFrom)) OR
			(@inp_dtTradingSubmiitedTo IS NOT NULL AND CONVERT(DATETIME,SubmissionEventDate) > CONVERT(DATETIME,@inp_dtTradingSubmiitedTo)+1)
		
		
		-- Apply soft copy filter - from date, to date and status
		DELETE FROM #tmpPeriodEndDisclosureUserList 
		WHERE @inp_iSoftCopySubmiitedStatus IS NOT NULL AND ScpStatusCodeId <> @inp_iSoftCopySubmiitedStatus
		
		DELETE FROM #tmpPeriodEndDisclosureUserList 
		WHERE 
			(@inp_dtSoftCopySubmiitedFrom IS NOT NULL AND CONVERT(DATETIME,ScpEventDate) < CONVERT(DATETIME,@inp_dtSoftCopySubmiitedFrom)) OR
			(@inp_dtSoftCopySubmiitedTo IS NOT NULL AND CONVERT(DATETIME,ScpEventDate) > CONVERT(DATETIME,@inp_dtSoftCopySubmiitedTo)+1)
		
		
		-- Apply hard copy filter - from date, to date and status
		DELETE FROM #tmpPeriodEndDisclosureUserList 
		WHERE @inp_iHardCopySubmiitedStatus IS NOT NULL AND HcpStatusCodeId <> @inp_iHardCopySubmiitedStatus
		
		DELETE FROM #tmpPeriodEndDisclosureUserList 
		WHERE 
			(@inp_dtHardCopySubmiitedFrom IS NOT NULL AND CONVERT(DATETIME,HcpEventDate) < CONVERT(DATETIME,@inp_dtHardCopySubmiitedFrom)) OR
			(@inp_dtHardCopySubmiitedTo IS NOT NULL AND CONVERT(DATETIME,HcpEventDate) > CONVERT(DATETIME,@inp_dtHardCopySubmiitedTo)+1)
		

		-- Apply stock exc filter - from date, to date and status
		DELETE FROM #tmpPeriodEndDisclosureUserList 
		WHERE @inp_iStockExchangeSubmiitedStatus IS NOT NULL AND HCpByCOStatusCodeId <> @inp_iStockExchangeSubmiitedStatus
		
		DELETE FROM #tmpPeriodEndDisclosureUserList 
		WHERE 
			(@inp_dtStockExchangeSubmiitedFrom IS NOT NULL AND CONVERT(DATETIME,HCpByCOEventDate) < CONVERT(DATETIME,@inp_dtStockExchangeSubmiitedFrom)) OR
			(@inp_dtStockExchangeSubmiitedTo IS NOT NULL AND CONVERT(DATETIME,HCpByCOEventDate) > CONVERT(DATETIME,@inp_dtStockExchangeSubmiitedTo)+1)
		
        -- Apply Employee status filter
		DELETE FROM #tmpPeriodEndDisclosureUserList 
		WHERE @inp_sEmployeeStatus IS NOT NULL AND EmpStatus <> @inp_sEmployeeStatus

		-- Update Submission days remaining
		UPDATE #tmpPeriodEndDisclosureUserList
		SET SubmissionDaysRemaining = CASE WHEN SubmissionLastDate >= @dtCurrentDate THEN CONVERT(int, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(@dtCurrentDate, NULL, SubmissionLastDate, 1, 0, 0, @nExchangeTypeCodeId_NSE)) ELSE -1 END, --DATEDIFF(D, @dtCurrentDate, SubmissionLastDate)
			SubmissionDaysRemainingByCO = CASE WHEN SubmissionByCOLastDate >= @dtCurrentDate THEN CONVERT(int, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(@dtCurrentDate, NULL, SubmissionByCOLastDate, 0, 0, 0, @nExchangeTypeCodeId_NSE)) ELSE -1 END -- DATEDIFF(D, @dtCurrentDate, SubmissionByCOLastDate)
		WHERE PeriodEndDate <= @dtCurrentDate
		
		-- Update button text for fields which has pending status
		UPDATE Tmp
		SET
			SubmissionButtonText = CASE WHEN SubmissionStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
									WHEN SubmissionStatusCodeId = @nStatusFlag_NotRequired THEN @sPolicyDocumentStatus_NotRequired 
									WHEN SubmissionStatusCodeId = @nStatusFlag_Uploaded THEN @sUploadedButtonText
									ELSE NULL END,
			ScpButtonText = CASE WHEN ScpStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
							WHEN ScpStatusCodeId = @nStatusFlag_NotRequired THEN @sPolicyDocumentStatus_NotRequired 
							ELSE NULL END,
			HcpButtonText = CASE WHEN HcpStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
							WHEN HcpStatusCodeId = @nStatusFlag_NotRequired THEN @sPolicyDocumentStatus_NotRequired 
							ELSE NULL END,
			HCpByCOButtonText = CASE WHEN HCpByCOStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
								WHEN HCpByCOStatusCodeId = @nStatusFlag_NotRequired THEN @sPolicyDocumentStatus_NotRequired 
								ELSE NULL END
		FROM #tmpPeriodEndDisclosureUserList Tmp 
		WHERE Tmp.TransactionMasterId IS NOT NULL
		
		
		--update IsCurrentPeriodEnd flag 
		UPDATE Tmp 
		SET Tmp.IsThisCurrentPeriodEnd = 1 
		FROM #tmpPeriodEndDisclosureUserList Tmp
		--WHERE Tmp.PeriodEndDate <= @dtCurrentDate AND @dtCurrentDate <= Tmp.SubmissionLastDate
		
		UPDATE Tmp
		SET IsUploadAndEnterEventGenerate = 1
		FROM #tmpPeriodEndDisclosureUserList Tmp
		JOIN eve_EventLog EL ON EL.MapToId = Tmp.TransactionMasterId AND EL.MapToTypeCodeId = 132005
		WHERE SubmissionStatusCodeId = 154001 AND EL.EventCodeId = 153030
		
		
		IF(@inp_isFromDashboard=1)
		BEGIN 
		DELETE FROM #tmpPeriodEndDisclosureUserList
		WHERE UserInfoId NOT IN(
		select distinct EL.UserInfoId from #tmpPeriodEndDisclosureUserList tPE join eve_EventLog EL
		on tPE.UserInfoId=EL.UserInfoId
		 where  EventCodeId in(153030) and EventCodeId not in(153031))
		 END	

		-- Set sort order 
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'DESC'
		END
		
		-- Set default sort field 
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'SubmissionLastDate '
		END
		
		IF @inp_sSortField = 'dis_grd_17162' -- Employee ID
		BEGIN 
			SELECT @inp_sSortField = 'EmployeeId ' 
		END
		
		IF @inp_sSortField = 'dis_grd_17163' -- Employee Name
		BEGIN 
			SELECT @inp_sSortField = 'InsiderName ' 
		END
		
		IF @inp_sSortField = 'dis_grd_17164' -- Designation
		BEGIN 
			SELECT @inp_sSortField = 'Designation ' 
		END
		
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +', Id),Id '
		SELECT @sSQL = @sSQL + ' FROM #tmpPeriodEndDisclosureUserList '
		
		PRINT(@sSQL)
		EXEC(@sSQL)
		
		SELECT
			YearCodeId,
			PeriodTypeId,
			PeriodType,
			PeriodCodeId,
			
			UserInfoId,
			EmployeeId as dis_grd_17162,
			InsiderName as dis_grd_17163,
			CompanyId, 
			CompanyName, 
			UserType, 
			DesignationId, 
			Designation as dis_grd_17164,
			UserPanNumber as dis_grd_50619,
			
			CASE WHEN EmpStatus = @nEmpStatusLiveCode THEN @nEmployeeStatusLive   
			     WHEN EmpStatus = @nEmpStatusSeparatedCode THEN @nEmployeeStatusSeparated 
			     WHEN EmpStatus = @nEmpStatusInactiveCode THEN @nEmployeeStatusInactive
			END  AS dis_grd_50617,
			SubmissionLastDate as dis_grd_17165,
			
			SubmissionEventDate as dis_grd_17166,
			SubmissionButtonText,
			SubmissionStatusCodeId,
			
			ScpEventDate as dis_grd_17167,
			ScpButtonText,
			ScpStatusCodeId,
			
			HcpEventDate as dis_grd_17168,
			HcpButtonText,
			HcpStatusCodeId,
			
			HCpByCOEventDate as dis_grd_17169,
			HCpByCOButtonText,
			HCpByCOStatusCodeId,
			
			PeriodEndDate,
			TradingPolicyId,
			TransactionMasterId, 
			ScpReq, HCpReq, HCpByCOReq,
			DiscloPeriodEndToCOByInsdrLimit,
			DiscloPeriodEndSubmitToStExByCOLimit,
			SubmissionByCOLastDate,
			SubmissionDaysRemaining,
			SubmissionDaysRemainingByCO,
			IsThisCurrentPeriodEnd,
			InitialDisclosureDate,
			IsUploadAndEnterEventGenerate,
			CCatagary.CodeName As dis_grd_54062,
			EmailId as dis_grd_71007
		FROM #tmpList t INNER JOIN #tmpPeriodEndDisclosureUserList tPE ON t.EntityID = tPE.Id 
		LEFT JOIN com_Code CCatagary on tPE.category=CCatagary.CodeID
		WHERE	1=1 AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		
		-- Delete temporary table
		DROP TABLE #tmpPeriodEndDisclosureUserList
			
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PERIODENDDISCLOSURE_USERSSTATUS
	END CATCH
END
