IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosurePeriodStatus')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosurePeriodStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************
Description:	Procedure to get each period status for period end disclosure 

Returns:		Return 0, if success.
				
Created by:		Parag
Created on:		04-May-2015
Modification History:
Modified By		Modified On		Description
Arundhati		11-May-2015		Default value changed for submission days remaining to -1
Arundhati		14-May-2015		Renamed output column from TradingMasterId to TransactionMasterId
Parag			16-May-2015		Added flag to know which period end is allowed to be view only and which allowed add/edit 
Parag			05-Jun-2015		Check to do not show pending status for submission if user has not made initial disclousure till that date
Parag			15-Jun-2015		Made change to allow disclosure after period end submission date is over 
Parag			11-Jul-2015		Made change to show "Not Required" text for soft copy, hard copy and stock exchange button 
								if these event does not required submission as per trading policy 
Parag			10-Aug-2015		Made change to handle uploaded status 
Gaurishankar	30-Sept-2015	Change for Uploaded button text (Line no 56,119 & 136)
Parag			06-Oct-2015		Made change to show period end disclouser for the period end type define in trading policy 
Parag			29-Oct-2015		Made change to show period end disclouser change in trading policy 
Arundhati		31-Oct-2015		Codes (dates) for Period end date are changed. Now that are stored as the 1st of next month.
Parag			17-Nov-2015		Made change to fix issue found while testing - user id condition is missing when fetch records from tra_UserPeriodEndMapping Table 
Parag			01-Dec-2015		Made change to handle condition when period end disclosure is not applicable for user
Parag			04-Dec-2015		Made change to show period end record on 1st day of month instead of last day of month
Parag			22-Jan-2016		Made change to use function for getting calender date or trading date as per configuration
Parag			01-Apr-2016		Made change to fix issue of show pending button if user has made initial disclosure on last date of month
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Tushar			16-Sep-2016     Change Initial Disclosure, Continuous Disclosure and Period End Disclosure List pages for showing new icons for Entered/Uploaded.

******************************************************************************************************************

Usage:

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosurePeriodStatus]
    @inp_iPageSize				INT = 10,
	@inp_iPageNo				INT = 1,
	@inp_sSortField			VARCHAR(255),
	@inp_sSortOrder			VARCHAR(5),
	@inp_iUserInfoId 		INT,
	@inp_iYearCodeId		INT = 0,
	@out_nReturnValue 		INT = 0 OUTPUT,
	@out_nSQLErrCode 		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	--DECLARE 	@inp_iYearCodeId		INT = 125002
	DECLARE @ERR_PERIODENDDISCLOSURE_STATUS_LIST	INT = 17052  -- Error occurred while fetching list of period end disclosure period status.
	DECLARE @nPeriodYear 							INT
	DECLARE @nYearStartMonth 						INT
	DECLARE @dtYearStartDate						DATETIME
	DECLARE @dtYearEndDate							DATETIME
	DECLARE @dtCurrentDate 							DATETIME = CONVERT(date, dbo.uf_com_GetServerDate())
	DECLARE @bIsCurrentYearPeiod					BIT = 0 --flag use to check if list is shown for current year or past years record
	
	DECLARE @nTradingPolicyId						INT
	DECLARE @nPeriodTypeByTradingPolicy 			INT
	DECLARE @nPeriodTypeByTradingPolicyText			VARCHAR(50)
	
	DECLARE @nStatusFlag_Complete					INT = 154001
	DECLARE @nStatusFlag_Pending					INT = 154002
	DECLARE @nStatusFlag_DoNotShow					INT = 154003
	DECLARE @nStatusFlag_Uploaded					INT = 154006
	DECLARE @nStatusFlag_NotRequired				INT = 154007
	
	DECLARE @nEvent_InitialDisclosureConfirm		INT = 153035
	DECLARE @nMapToType_DisclosureTransaction		INT = 132005
	
	DECLARE @sPeriodEndDisclosure_Pending			VARCHAR(255)
	DECLARE @sPeriodEndDisclosure_NotRequired		VARCHAR(255)
	DECLARE @sUploadedButtonText					VARCHAR(255)
	
	DECLARE @sSQL									NVARCHAR(MAX) = ''
	
	DECLARE @RC INT
	
	-- flag to indicate what action to be taken
	-- 0: NO ACTION
	-- 1: add records as per current TP for current period, 
	-- 2: record is already added into tra_UserPeriodEndMapping table
	-- 3: add next period records as per previous TP stored in tra_UserPeriodEndMapping table
	DECLARE @nActinFlag		 		INT
	
	DECLARE @nApplicableTP 			INT
	DECLARE @nYearCodeId	 		INT
	DECLARE @nPeriodCodeId  		INT
	DECLARE @dtPEStartDate 			DATETIME
	DECLARE @dtPEEndDate 			DATETIME
	DECLARE @bChangePEDate			BIT
	DECLARE @dtPEEndDateToUpdate	DATETIME
	
	DECLARE @dtLastPE_CreatedDate DATETIME = NULL
	
	DECLARE @dtInitial_DisclosureDate DATETIME = NULL
	
	DECLARE @nExchangeTypeCodeId_NSE INT = 116001
	
	DECLARE @Counter INT = 1
	DECLARE @TotalYearCount INT = 0 
	DECLARE @YearCodeID INT = 0 
	
	DECLARE @dtStartYearDate DATETIME 
	DECLARE @PDYear INT
	
	SELECT @dtStartYearDate = DateOfBecomingInsider FROM usr_userinfo WHERE UserInfoId = @inp_iUserInfoId
	IF(DATEPART(MONTH,@dtStartYearDate)<=3)
	BEGIN
		SET @PDYear = DATEPART(YEAR,@dtStartYearDate)-1
		END
	ELSE
	BEGIN
		SET @PDYear = DATEPART(YEAR,@dtStartYearDate)
	END;
	WITH YearTable AS
    (
     SELECT @PDYear AS PDYear
     UNION ALL 
	 SELECT PDYear + 1
	 FROM YearTable 
	 WHERE PDYear < DATEPART(YEAR,GETDATE())
	)
	SELECT PDYear INTO #TEMP_PDYEAR 
	FROM YearTable
	CREATE TABLE #TEMP_PDYEAR_FINAL(ID INT IDENTITY (1,1),PDYear INT)
	INSERT INTO #TEMP_PDYEAR_FINAL
	SELECT * FROM #TEMP_PDYEAR
	
	CREATE TABLE #tmp_All_Year_PeriodEndDisclosureList
		(Id INT IDENTITY(1,1), YearCodeId INT, PeriodTypeId INT,PeriodType VARCHAR(50), PeriodCodeId INT, Period NVARCHAR(512), PeriodEndDate DATETIME, 
		TransactionMasterId INT, TradingPolicyId INT,  
		--SubmissionReqTillDate DATETIME,
		
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
		IsCurrentPeriodEnd INT DEFAULT 0, InitialDisclosureDate DATETIME,
		IsUploadAndEnterEventGenerate INT DEFAULT 0,
		IsDetailsSubmitted INT,
		IsSoftCopySubmitted INT,
		IsHardCopySubmitted INT
		)

	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT @sPeriodEndDisclosure_Pending = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17005'
		SELECT @sPeriodEndDisclosure_NotRequired = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17334'
		SELECT @sUploadedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17075' --Uploaded Button Text
		
		SELECT @TotalYearCount = COUNT(PDYear) FROM #TEMP_PDYEAR_FINAL

		WHILE(@Counter <= @TotalYearCount)
		BEGIN
		CREATE TABLE #tmpPeriodEndDisclosureList
		(Id INT IDENTITY(1,1), YearCodeId INT, PeriodTypeId INT,PeriodType VARCHAR(50), PeriodCodeId INT, Period NVARCHAR(512), PeriodEndDate DATETIME, 
		TransactionMasterId INT, TradingPolicyId INT,  
		--SubmissionReqTillDate DATETIME,
		
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
		IsCurrentPeriodEnd INT DEFAULT 0, InitialDisclosureDate DATETIME,
		IsUploadAndEnterEventGenerate INT DEFAULT 0
		)
		
		SELECT @YearCodeID = CodeID FROM com_Code WHERE CodeGroupId = 125 AND CodeName LIKE CONVERT(VARCHAR(4), (SELECT PDYear FROM #TEMP_PDYEAR_FINAL WHERE #TEMP_PDYEAR_FINAL.ID = @Counter)) + '%'
		
		
		SELECT @nPeriodYear = SUBSTRING(CodeName, 1, 4) FROM com_Code WHERE CodeID = @YearCodeID -- year for which record are shown 
		
		SELECT @nYearStartMonth = 4 -- month from which year start
			DECLARE @nDatabaseName VARCHAR(100)
			SELECT @nDatabaseName = db_name()
			IF(@nDatabaseName = 'Vigilante_AccelyaSolutions')
			BEGIN
				SET @nYearStartMonth = 7
			END
			ELSE IF (@nDatabaseName = 'Vigilante_Hexaware')
			BEGIN
				SET @nYearStartMonth = 1
			END		
		-- get start and end date of year from where period records to be display
		SELECT @dtYearStartDate = CONVERT(date, CONVERT(varchar, @nPeriodYear)+'-'+CONVERT(varchar,@nYearStartMonth)+ '-01') --get start date of year
		
		select @dtYearEndDate = DATEADD(DAY, -1, DATEADD(YEAR, 1, @dtYearStartDate)) --get end date of year
		
		-- set flag to know if records are shown for current year or pervious year
		SELECT @bIsCurrentYearPeiod = CASE 
										WHEN CONVERT(date, @dtCurrentDate) >= CONVERT(date, @dtYearStartDate) 
											AND CONVERT(date, @dtCurrentDate) <= CONVERT(date, @dtYearEndDate) 
										THEN 1 
										ELSE 0 
									END 

		
		-- add previous period end disclosure records from view 
		INSERT INTO #tmpPeriodEndDisclosureList(
			TransactionMasterId, SubmissionEventDate, SubmissionStatusCodeId, ScpReq, ScpEventDate, ScpStatusCodeId, 
			HCpReq, HcpEventDate, HcpStatusCodeId, HCpByCOReq, HCpByCOEventDate, HCpByCOStatusCodeId, 
			PeriodEndDate)
		SELECT 
			vwPEDS.TransactionMasterId AS TransactionMasterId,
			
			vwPEDS.DetailsSubmitDate AS SubmissionEventDate,
			CASE 
				WHEN vwPEDS.DetailsSubmitStatus = 1 THEN @nStatusFlag_Complete 
				WHEN vwPEDS.DetailsSubmitStatus = 2 THEN @nStatusFlag_Uploaded 
				ELSE @nStatusFlag_DoNotShow 
			END AS SubmissionStatusCodeId,
			
			vwPEDS.SoftCopyReq AS ScpReq,
			vwPEDS.ScpSubmitDate AS ScpEventDate,
			CASE 
				WHEN vwPEDS.SoftCopyReq = 1 AND vwPEDS.DetailsSubmitStatus = 1 THEN -- if soft copy is required 
					(CASE 
						WHEN vwPEDS.ScpSubmitStatus = 0 THEN @nStatusFlag_Pending
						WHEN vwPEDS.ScpSubmitStatus = 1 THEN @nStatusFlag_Complete
						ELSE @nStatusFlag_DoNotShow END)
				-- if soft copy is NOT required 
				WHEN vwPEDS.SoftCopyReq = 0 AND vwPEDS.DetailsSubmitStatus = 1 THEN @nStatusFlag_NotRequired 
				ELSE @nStatusFlag_DoNotShow 
			END AS ScpStatusCodeId,
			
			vwPEDS.HardCopyReq AS HCpReq,
			vwPEDS.HcpSubmitDate AS HcpEventDate,
			CASE 
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
				ELSE @nStatusFlag_DoNotShow 
			END AS HcpStatusCodeId,
								
			vwPEDS.HCpByCOReq AS HCpByCOReq,
			vwPEDS.HCpByCOSubmitDate AS HCpByCOEventDate,
			CASE 
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
				ELSE @nStatusFlag_DoNotShow 
			END AS HCpByCOStatusCodeId,
			vwPEDS.PeriodEndDate
		FROM vw_PeriodEndDisclosureStatus vwPEDS 
		WHERE 
			vwPEDS.UserInfoId = @inp_iUserInfoId AND 
			(CONVERT(date, vwPEDS.PeriodEndDate) >= CONVERT(date, @dtYearStartDate) 
				AND CONVERT(date, vwPEDS.PeriodEndDate) <= CONVERT(date, @dtYearEndDate))
		
		--select * from #tmpPeriodEndDisclosureList
		-- Update trading policy id and submission last date for those had transaction
		UPDATE tmp 
		SET
			TradingPolicyId = UPEMap.TradingPolicyId, 
			YearCodeId = @YearCodeID,
			PeriodTypeId = CASE 
								WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
								WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
								WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
								WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
								ELSE TP.DiscloPeriodEndFreq 
							END,		
			PeriodType = CASE 
								WHEN TP.DiscloPeriodEndFreq = 137001 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123001) -- Yearly
								WHEN TP.DiscloPeriodEndFreq = 137002 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123003) -- Quarterly
								WHEN TP.DiscloPeriodEndFreq = 137003 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123004) -- Monthly
								WHEN TP.DiscloPeriodEndFreq = 137004 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123002) -- half yearly
								ELSE (SELECT CodeName FROM COM_CODE WHERE CodeID=TP.DiscloPeriodEndFreq)
							END,
			DiscloPeriodEndToCOByInsdrLimit = TP.DiscloPeriodEndToCOByInsdrLimit,
			SubmissionLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(TM.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)),-- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), TM.PeriodEndDate),
			DiscloPeriodEndSubmitToStExByCOLimit = TP.DiscloPeriodEndSubmitToStExByCOLimit,
			SubmissionByCOLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(TM.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) -- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), TM.PeriodEndDate)
		FROM #tmpPeriodEndDisclosureList tmp 
		JOIN tra_TransactionMaster TM ON tmp.TransactionMasterId = TM.TransactionMasterId 
		JOIN tra_UserPeriodEndMapping UPEMap ON CONVERT(date, UPEMap.PEEndDate) = CONVERT(date, TM.PeriodEndDate) AND UPEMap.UserInfoId = TM.UserInfoId
		JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId 
		
		-- set period for which period end is done
		UPDATE tmp 
		SET
			PeriodCodeId = CdPeriod.CodeID,
			Period = (CASE WHEN CdPeriod.DisplayCode IS NULL OR CdPeriod.DisplayCode = '' THEN CdPeriod.CodeName ELSE CdPeriod.DisplayCode END)
		FROM #tmpPeriodEndDisclosureList tmp 
		JOIN rul_TradingPolicy TP ON tmp.TradingPolicyId = TP.TradingPolicyId 
		JOIN com_Code CdPeriod ON CdPeriod.ParentCodeId = tmp.PeriodTypeId and CdPeriod.CodeGroupId = 124 
				and CONVERT(date, tmp.PeriodEndDate) = CONVERT(date, DATEADD(DAY, -1, DATEADD(YEAR, @nPeriodYear-1970,convert(datetime, CdPeriod.Description))))
		
		-- check if records for current year or previous year
		-- if previous year then use records fetch from view
		-- if current year then get records from view and for future period add records base on current trading policy apply
		IF (@bIsCurrentYearPeiod = 1)
		BEGIN
			-- get applied trading policy 
			SELECT @nTradingPolicyId = ISNULL(MAX(vwTP.MapToId), 0) FROM vw_ApplicableTradingPolicyForUser vwTP WHERE UserInfoId = @inp_iUserInfoId
			
			-- base on current trading policy get period end for year which are greater than current date and into temp table 
			-- if trading policy is not applicable then do noting 
			IF(@nTradingPolicyId > 0)
			BEGIN
				-- fetch initial disclosure date
				SELECT @dtInitial_DisclosureDate = EventDate FROM eve_EventLog EL 
				WHERE EventCodeId = 153035 AND MapToTypeCodeId = 132005 AND EL.UserInfoId = @inp_iUserInfoId AND EventCodeId IS NOT NULL
				
				-- check initial disclousre for user is done or not
				IF (@dtInitial_DisclosureDate IS NOT NULL OR @dtInitial_DisclosureDate <> '' )
				BEGIN
					SELECT TOP(1) @dtLastPE_CreatedDate = vwPEDS.PeriodEndDate FROM vw_PeriodEndDisclosureStatus vwPEDS
					WHERE vwPEDS.UserInfoId = @inp_iUserInfoId ORDER BY TransactionMasterId DESC
					
					-- if no last PE records is found, use year start date or inital disclosure date which is latest
					-- use year start date if initial discloure is done before 
					SELECT @dtLastPE_CreatedDate = CASE WHEN @dtLastPE_CreatedDate IS NULL THEN 
														CASE WHEN CONVERT(date,@dtYearStartDate) > CONVERT(date, @dtInitial_DisclosureDate)  
															THEN CONVERT(date,@dtYearStartDate)
															ELSE CONVERT(date, @dtInitial_DisclosureDate)
														END
													ELSE @dtLastPE_CreatedDate END
					
					-- fetch applicable PE date for user
					EXECUTE @RC = [st_tra_PeriodEndDisclosureGetApplicablePeriodDetail]
									@inp_iUserInfoId, 
									@nTradingPolicyId, 
									@dtCurrentDate,
									@nActinFlag OUTPUT,
									@nApplicableTP OUTPUT, 
									@nYearCodeId OUTPUT, 
									@nPeriodCodeId OUTPUT, 
									@dtPEStartDate OUTPUT, 
									@dtPEEndDate OUTPUT, 
									@bChangePEDate OUTPUT, 
									@dtPEEndDateToUpdate OUTPUT,
									@out_nReturnValue OUTPUT,
									@out_nSQLErrCode OUTPUT,
									@out_sSQLErrMessage OUTPUT
									
					-- check period end date, if period end date is null and do not add any records because period end is not applicable
					IF (@dtPEEndDate IS NOT NULL)
					BEGIN
						--get period type by applicable trading policy
						SELECT @nPeriodTypeByTradingPolicy = CASE 
																WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
																WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
																WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
																WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
																ELSE TP.DiscloPeriodEndFreq 
															END
						FROM rul_TradingPolicy TP 
						WHERE TP.TradingPolicyId = @nApplicableTP
						
						SELECT @nPeriodTypeByTradingPolicyText = CASE 
																WHEN TP.DiscloPeriodEndFreq = 137001 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123001) -- Yearly
																WHEN TP.DiscloPeriodEndFreq = 137002 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123003)-- Quarterly
																WHEN TP.DiscloPeriodEndFreq = 137003 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123004) -- Monthly
																WHEN TP.DiscloPeriodEndFreq = 137004 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123002) -- half yearly
																ELSE (SELECT CodeName FROM COM_CODE WHERE CodeID=TP.DiscloPeriodEndFreq) 
															END
						FROM rul_TradingPolicy TP 
						WHERE TP.TradingPolicyId = @nApplicableTP
						
						-- add records upto PE applicable as per record fetch from user period end mapping 
						INSERT INTO #tmpPeriodEndDisclosureList(
							TradingPolicyId, YearCodeId, PeriodTypeId, PeriodType, PeriodCodeId, PeriodEndDate, Period)
						SELECT
							@nApplicableTP as TradingPolicyId,
							@nYearCodeId as YearCodeId, 
							@nPeriodTypeByTradingPolicy as PeriodTypeId,
							@nPeriodTypeByTradingPolicyText as PeriodType, 
							CdPeriod.CodeID as PeriodCodeId,
							DATEADD(DAY, -1, DATEADD(YEAR, @nPeriodYear-1970,convert(datetime, CdPeriod.Description))) AS PeriodEndDate, 
							(CASE WHEN CdPeriod.DisplayCode IS NULL OR CdPeriod.DisplayCode = '' THEN CdPeriod.CodeName ELSE CdPeriod.DisplayCode END) as Period
						FROM com_Code CdPeriod 
						WHERE 
							CdPeriod.ParentCodeId = @nPeriodTypeByTradingPolicy and CdPeriod.CodeGroupId = 124 
							AND DATEADD(DAY, -1, DATEADD(YEAR, @nPeriodYear-1970,convert(datetime, CdPeriod.Description))) > @dtLastPE_CreatedDate 
							AND DATEADD(DAY, -1, DATEADD(YEAR, @nPeriodYear-1970,convert(datetime, CdPeriod.Description))) <= @dtPEEndDate
						
						
						-- add records after PE applicable as per record fetch from user period end mapping and as per current trading policy
						--get period type by current applicable trading policy
						SELECT @nPeriodTypeByTradingPolicy = CASE 
																WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
																WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
																WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
																WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
																ELSE TP.DiscloPeriodEndFreq 
															END
						FROM rul_TradingPolicy TP 
						WHERE TP.TradingPolicyId = @nTradingPolicyId
						
						SELECT @nPeriodTypeByTradingPolicyText =CASE 
																WHEN TP.DiscloPeriodEndFreq = 137001 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123001) -- Yearly
																WHEN TP.DiscloPeriodEndFreq = 137002 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123003)-- Quarterly
																WHEN TP.DiscloPeriodEndFreq = 137003 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123004) -- Monthly
																WHEN TP.DiscloPeriodEndFreq = 137004 THEN (SELECT CodeName FROM COM_CODE WHERE codeId=123002) -- half yearly
																ELSE (SELECT CodeName FROM COM_CODE WHERE CodeID=TP.DiscloPeriodEndFreq)
															END
						FROM rul_TradingPolicy TP 
						WHERE TP.TradingPolicyId = @nApplicableTP
						
						
						
						INSERT INTO #tmpPeriodEndDisclosureList(
							TradingPolicyId, YearCodeId, PeriodTypeId, PeriodType, PeriodCodeId, PeriodEndDate, Period)
						SELECT
							@nTradingPolicyId as TradingPolicyId,
							@YearCodeID as YearCodeId, 
							@nPeriodTypeByTradingPolicy as PeriodTypeId, 
							@nPeriodTypeByTradingPolicyText as PeriodType, 
							CdPeriod.CodeID as PeriodCodeId,
							DATEADD(DAY, -1, DATEADD(YEAR, @nPeriodYear-1970,convert(datetime, CdPeriod.Description))) AS PeriodEndDate, 
							(CASE WHEN CdPeriod.DisplayCode IS NULL OR CdPeriod.DisplayCode = '' THEN CdPeriod.CodeName ELSE CdPeriod.DisplayCode END) as Period
						FROM com_Code CdPeriod 
						WHERE 
							CdPeriod.ParentCodeId = @nPeriodTypeByTradingPolicy and CdPeriod.CodeGroupId = 124 
							AND DATEADD(DAY, -1, DATEADD(YEAR, @nPeriodYear-1970,convert(datetime, CdPeriod.Description))) > @dtPEEndDate
					END
				END
				
				-- Update details from trading policy and submission last date for those had transaction
				UPDATE tmp 
				SET
					ScpReq = TP.DiscloPeriodEndReqSoftcopyFlag, 
					HCpReq = TP.DiscloPeriodEndReqHardcopyFlag, 
					HCpByCOReq = TP.DiscloPeriodEndSubmitToStExByCOHardcopyFlag,
					DiscloPeriodEndToCOByInsdrLimit = TP.DiscloPeriodEndToCOByInsdrLimit,
					SubmissionLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(tmp.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)),-- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), tmp.PeriodEndDate),
					DiscloPeriodEndSubmitToStExByCOLimit = TP.DiscloPeriodEndSubmitToStExByCOLimit,
					SubmissionByCOLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(tmp.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) -- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), tmp.PeriodEndDate)
				FROM #tmpPeriodEndDisclosureList tmp 
				JOIN rul_TradingPolicy TP ON tmp.TradingPolicyId = TP.TradingPolicyId AND tmp.TransactionMasterId IS NULL
			END
		END
		
		
		--Update submission date records which does not have Transaction master id
		UPDATE Tmp 
		SET 
			SubmissionLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(Tmp.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)), -- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0), Tmp.PeriodEndDate),
			SubmissionByCOLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(Tmp.PeriodEndDate, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) -- DATEADD(D, ISNULL(TP.DiscloPeriodEndToCOByInsdrLimit, 0) + ISNULL(TP.DiscloPeriodEndSubmitToStExByCOLimit, 0), Tmp.PeriodEndDate)
		FROM #tmpPeriodEndDisclosureList Tmp LEFT JOIN rul_TradingPolicy TP ON Tmp.TradingPolicyId = TP.TradingPolicyId 
		WHERE Tmp.TransactionMasterId IS NULL and Tmp.TradingPolicyId <> 0
		
		
		-- Update Initial disclosure date
		UPDATE Tmp
		SET
			InitialDisclosureDate = EL.EventDate
		FROM #tmpPeriodEndDisclosureList Tmp LEFT JOIN eve_EventLog EL on 
				EL.UserInfoId = @inp_iUserInfoId AND MapToTypeCodeId = @nMapToType_DisclosureTransaction AND EventCodeId = @nEvent_InitialDisclosureConfirm
		
		
		-- Update Submission days remaining
		UPDATE #tmpPeriodEndDisclosureList
		SET SubmissionDaysRemaining = CASE WHEN SubmissionLastDate >= @dtCurrentDate THEN CONVERT(int, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(@dtCurrentDate, NULL, SubmissionLastDate, 1, 0, 0, @nExchangeTypeCodeId_NSE)) ELSE -1 END, -- DATEDIFF(D, @dtCurrentDate, SubmissionLastDate)
			SubmissionDaysRemainingByCO = CASE WHEN SubmissionByCOLastDate >= @dtCurrentDate THEN CONVERT(int, dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPeriodEnd(@dtCurrentDate, NULL, SubmissionByCOLastDate, 0, 0, 0, @nExchangeTypeCodeId_NSE)) ELSE -1 END -- DATEDIFF(D, @dtCurrentDate, SubmissionByCOLastDate)
		WHERE PeriodEndDate <= @dtCurrentDate
		
		-- Update Submission text and status -- This will change to pending because by default status is do not show for pervious period end
		UPDATE Tmp
		SET
			SubmissionStatusCodeId = @nStatusFlag_Pending
		FROM #tmpPeriodEndDisclosureList Tmp 
		WHERE Tmp.TradingPolicyId <> 0 AND Tmp.PeriodEndDate < @dtCurrentDate 
				AND (Tmp.InitialDisclosureDate IS NOT NULL AND CONVERT(date,Tmp.InitialDisclosureDate) <= Tmp.PeriodEndDate)
				AND Tmp.SubmissionEventDate IS NULL
		
		
		-- Update button text for fields which has pending status
		UPDATE Tmp
		SET
			SubmissionButtonText = CASE WHEN SubmissionStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
									WHEN SubmissionStatusCodeId = @nStatusFlag_NotRequired THEN @sPeriodEndDisclosure_NotRequired 
									WHEN SubmissionStatusCodeId = @nStatusFlag_Uploaded THEN @sUploadedButtonText
									ELSE NULL END,
			ScpButtonText = CASE WHEN ScpStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
							WHEN ScpStatusCodeId = @nStatusFlag_NotRequired THEN @sPeriodEndDisclosure_NotRequired 
							ELSE NULL END,
			HcpButtonText = CASE WHEN HcpStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
							WHEN HcpStatusCodeId = @nStatusFlag_NotRequired THEN @sPeriodEndDisclosure_NotRequired 
							ELSE NULL END,
			HCpByCOButtonText = CASE WHEN HCpByCOStatusCodeId = @nStatusFlag_Pending THEN @sPeriodEndDisclosure_Pending 
								WHEN HCpByCOStatusCodeId = @nStatusFlag_NotRequired THEN @sPeriodEndDisclosure_NotRequired 
								ELSE NULL END,
			IsCurrentPeriodEnd = 1
		FROM #tmpPeriodEndDisclosureList Tmp 
		WHERE Tmp.TransactionMasterId IS NOT NULL
		
		UPDATE Tmp
		SET IsUploadAndEnterEventGenerate = 1
		FROM #tmpPeriodEndDisclosureList Tmp
		JOIN eve_EventLog EL ON EL.MapToId = Tmp.TransactionMasterId AND EL.MapToTypeCodeId = @nMapToType_DisclosureTransaction
		WHERE SubmissionStatusCodeId = 154001 AND EL.EventCodeId = 153030
		
		INSERT INTO #tmp_All_Year_PeriodEndDisclosureList
		(YearCodeId,PeriodTypeId,PeriodType,PeriodCodeId,Period,SubmissionLastDate,SubmissionEventDate,SubmissionButtonText,
		SubmissionStatusCodeId,ScpEventDate,ScpButtonText,ScpStatusCodeId,HcpEventDate,HcpButtonText,HcpStatusCodeId,
		HCpByCOEventDate,HCpByCOButtonText,HCpByCOStatusCodeId,PeriodEndDate,TransactionMasterId,TradingPolicyId,
		--SubmissionReqTillDate,
		ScpReq, HCpReq, HCpByCOReq,DiscloPeriodEndToCOByInsdrLimit,DiscloPeriodEndSubmitToStExByCOLimit,SubmissionByCOLastDate,
		SubmissionDaysRemaining,SubmissionDaysRemainingByCO,IsCurrentPeriodEnd,InitialDisclosureDate,IsUploadAndEnterEventGenerate,
		IsDetailsSubmitted ,
		IsSoftCopySubmitted ,
		IsHardCopySubmitted 
		)
				
		SELECT 
			YearCodeId,PeriodTypeId,PeriodType,PeriodCodeId,
			Period AS dis_grd_17010,
			SubmissionLastDate AS dis_grd_17011,
			SubmissionEventDate AS dis_grd_17012,
			SubmissionButtonText,SubmissionStatusCodeId,
			ScpEventDate AS dis_grd_17030,
			ScpButtonText,ScpStatusCodeId,
			HcpEventDate AS dis_grd_17031,
			HcpButtonText,HcpStatusCodeId,
			HCpByCOEventDate AS dis_grd_17032,
			HCpByCOButtonText,HCpByCOStatusCodeId,
			PeriodEndDate,TransactionMasterId,TradingPolicyId,
			--SubmissionReqTillDate,
			ScpReq, HCpReq, HCpByCOReq,
			DiscloPeriodEndToCOByInsdrLimit,
			DiscloPeriodEndSubmitToStExByCOLimit,
			SubmissionByCOLastDate,SubmissionDaysRemaining,
			SubmissionDaysRemainingByCO,IsCurrentPeriodEnd, 
			InitialDisclosureDate,IsUploadAndEnterEventGenerate,
			CASE WHEN SubmissionEventDate IS NULL THEN 0 ELSE 1 END AS IsDetailsSubmitted,
			CASE WHEN ScpEventDate IS NULL AND ScpStatusCodeId <> @nStatusFlag_NotRequired THEN CASE WHEN ScpEventDate IS NULL AND SubmissionEventDate IS NOT NULL THEN -1 ELSE 0 END ELSE 1 END AS IsSoftCopySubmitted,
			CASE WHEN HcpEventDate IS NULL AND HcpStatusCodeId <> @nStatusFlag_NotRequired THEN CASE WHEN HcpEventDate IS NULL AND SubmissionEventDate IS NOT NULL THEN -1 ELSE 0 END ELSE 1 END AS IsHardCopySubmitted
		FROM #tmpPeriodEndDisclosureList t
		
		DROP TABLE #tmpPeriodEndDisclosureList
			
		SET @Counter = @Counter + 1
		END
		IF(@inp_iYearCodeId IS NULL)
		BEGIN
		  SET @inp_iYearCodeId = 0
		END
		
	    DELETE FROM #tmp_All_Year_PeriodEndDisclosureList WHERE TransactionMasterId IS NULL
	   -- SELECT @sSQL = @sSQL + 'CREATE TABLE #tmpList(RowNumber INT, EntityID INT) '	
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID) '
		SELECT @sSQL = @sSQL + 'SELECT DISTINCT DENSE_RANK() OVER(Order BY Id ASC ,Id),Id '
		SELECT @sSQL = @sSQL + 'FROM #tmp_All_Year_PeriodEndDisclosureList '
		SELECT @sSQL = @sSQL + 'WHERE (YearCodeId = ' + CONVERT(NVARCHAR(255), @inp_iYearCodeId) + ' AND ' + CONVERT(NVARCHAR(255), @inp_iYearCodeId) + ' <> 0) OR (YearCodeId <> ' + CONVERT(NVARCHAR(255), @inp_iYearCodeId) + ' AND ' + CONVERT(NVARCHAR(255), @inp_iYearCodeId) + ' = 0) '		
				
		EXEC(@sSQL)
	  SELECT    
	        YearCodeId,
			PeriodTypeId,
			PeriodType,
			PeriodCodeId,
			Period AS dis_grd_17010,
			SubmissionLastDate AS dis_grd_17011,
			
			SubmissionEventDate AS dis_grd_17012,
			SubmissionButtonText,
			SubmissionStatusCodeId,
			
			ScpEventDate AS dis_grd_17030,
			ScpButtonText,
			ScpStatusCodeId,
			
			HcpEventDate AS dis_grd_17031,
			HcpButtonText,
			HcpStatusCodeId,
			
			HCpByCOEventDate AS dis_grd_17032,
			HCpByCOButtonText,
			HCpByCOStatusCodeId,
			
			PeriodEndDate,
			TransactionMasterId, 
			TradingPolicyId,
			--SubmissionReqTillDate,
			ScpReq, HCpReq, HCpByCOReq,
			DiscloPeriodEndToCOByInsdrLimit,
			DiscloPeriodEndSubmitToStExByCOLimit,
			SubmissionByCOLastDate,
			SubmissionDaysRemaining,
			SubmissionDaysRemainingByCO,
			IsCurrentPeriodEnd, 
			InitialDisclosureDate,
			IsUploadAndEnterEventGenerate,
			IsDetailsSubmitted ,
		    IsSoftCopySubmitted ,
		    IsHardCopySubmitted 
	   
	   FROM #tmpList T INNER JOIN #tmp_All_Year_PeriodEndDisclosureList Temp
	   ON Temp.Id = T.EntityID 
	   WHERE 
	   ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
	   ORDER BY IsHardCopySubmitted, IsSoftCopySubmitted DESC
	   RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PERIODENDDISCLOSURE_STATUS_LIST
	END CATCH
END
