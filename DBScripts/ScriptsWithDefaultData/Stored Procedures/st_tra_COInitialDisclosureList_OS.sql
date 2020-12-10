IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_COInitialDisclosureList_OS')
DROP PROCEDURE [dbo].[st_tra_COInitialDisclosureList_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Usage:
EXEC st_tra_COInitialDisclosureList 
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_COInitialDisclosureList_OS]
	@inp_iPageSize							INT = 10
	,@inp_iPageNo							INT = 1
	,@inp_sSortField						VARCHAR(255)
	,@inp_sSortOrder						VARCHAR(5)	
    ,@inp_sUserInfoId						INT     
    ,@inp_sEmployeeName						VARCHAR(50)  
    ,@inp_sDesignation						VARCHAR(50)  
    ,@inp_dtEmailSentDate					DATETIME    
    ,@inp_dtHodlingDetailsSubmissionFrom	DATETIME
    ,@inp_dtHodlingDetailsSubmissionTo		DATETIME
    ,@inp_sHodlingDetailsSubmissionStatus	INT    
	,@inp_dtSoftCopyFrom					DATETIME
    ,@inp_dtSoftCopyTo						DATETIME
    ,@inp_sSoftCopyStatus					INT    
    ,@inp_dtHardCopyFrom					DATETIME
    ,@inp_dtHardCopyTo						DATETIME
    ,@inp_sHardCopyStatus					INT    
    ,@inp_dtStockExchangeFrom				DATETIME
    ,@inp_dtStockExchangeTo					DATETIME
    ,@inp_sStockExchangeStatus				INT
    ,@inp_sEmployeeID						NVARCHAR(50)	
    ,@inp_sEmployeePAN                      NVARCHAR(50)
    ,@inp_sEmployeeStatus                   INT	
	,@inp_sLoginID							VARCHAR(100) = null
	,@RelativePendingFromDashboard		VARCHAR(100) = null
	,@out_nReturnValue						INT = 0 OUTPUT
	,@out_nSQLErrCode						INT = 0 OUTPUT			  -- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage					VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN


--set @iSRelativePendingFromDashboard=1
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_COInitialDisclosure_LIST INT = -1
	DECLARE @PendingStatus VARCHAR(10)
	DECLARE @NotReqStatus VARCHAR(100)
	DECLARE @DocumentUploadedStatus VARCHAR(100)
	
	DECLARE @nConfirm_Personal_Details_Event	INT = 153043
	
	DECLARE @nEmployeeStatusLive                                                VARCHAR(100),
			@nEmployeeStatusSeparated                                           VARCHAR(100),
			@nEmployeeStatusInactive                                            VARCHAR(100),
			@nEmpStatusLiveCode                                                 INT = 510001,
			@nEmpStatusSeparatedCode                                            INT = 510002,
			@nEmpStatusInactiveCode                                             INT = 510003,
			@nEmployeeActive                                                    INT = 102001,
			@nEmployeeInActive                                                  INT = 102002
	
	BEGIN TRY
		/* Get User whose relative pending code start */
		--DECLARE @iSRelativePendingFromDashboard INT=1
		DECLARE @CODE_DISCLOSURE_TYPE_INITIAL INT = 147001 -- Disclosure Type - Initial 147001
		DECLARE @TRANS_TYPE_NOT_CONFIRMED_CONTINUOUS INT =148002
		DECLARE @IsRelativePendingInitial INT=1
		DECLARE @UserInfoIdForRelative AS TABLE (UserInfoId INT)
		
		INSERT INTO @UserInfoIdForRelative 
			SELECT  tb.UserInfoId
		FROM (

		 select case when count(UserInfoIdRelative)>0 then 1 else 0 end as RelCount,UserInfoId from usr_UserRelation where UserInfoIdRelative not in (
		 select ForUserInfoId from tra_TransactionDetails_OS) 
		 group by UserInfoId
		 union
		 select case when count(UserInfoIdRelative)>0 then 1 else 0 end as RelCount,UserInfoId from usr_UserRelation where UserInfoIdRelative in (
		 select ForUserInfoId from tra_TransactionDetails_OS TD join tra_TransactionMaster_OS TM on
		 TD.transactionmasterid=TM.transactionmasterid where DisclosureTypeCodeId=@CODE_DISCLOSURE_TYPE_INITIAL and TransactionStatusCodeId=@TRANS_TYPE_NOT_CONFIRMED_CONTINUOUS)	
		 group by UserInfoId
				
		 ) tb INNER JOIN vw_ApplicableTradingPolicyForUser_OS AS APTP on tb.UserInfoId=APTP.UserInfoId
		
	  /* Get User whose relative pending code end */


	

	    IF EXISTS (SELECT TransactionMasterId FROM tra_TransactionMaster_OS WHERE DisclosureTypeCodeId = 147001 AND TransactionStatusCodeId = 148002 AND TransactionMasterId NOT IN (SELECT TransactionMasterId FROM tra_TransactionDetails_OS))
        BEGIN
           DELETE FROM tra_TransactionMaster_OS WHERE DisclosureTypeCodeId = 147001 AND TransactionStatusCodeId = 148002 AND TransactionMasterId NOT IN (SELECT TransactionMasterId FROM tra_TransactionDetails_OS)
        END

		SELECT @nEmployeeStatusLive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusLiveCode   
			
		SELECT @nEmployeeStatusSeparated = CodeName FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode  
			
		SELECT @nEmployeeStatusInactive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusInactiveCode
		
		SELECT @PendingStatus =  'Pending'
		SELECT @NotReqStatus =  'Not Required'
		SELECT @DocumentUploadedStatus = 'Document Uploaded'
		DECLARE @TempEventLog TABLE(Seq INT IDENTITY(1,1), UserInfoId INT, EventType VARCHAR(max), DateOfEvent datetime, TMID INT,
		SoftCopyReq bit,HardCopyReq bit)
		
		INSERT INTO @TempEventLog		
		SELECT	e.UserInfoId,
				e.EventCodeId,
				max(e.EventDate),
				max(e.MapToId),
				0,
				0				
		FROM	eve_EventLog e
		WHERE	   e.EventCodeId = 153006 
				or e.EventCodeId = 153052 -- Initial Disclosure details entered for OS
				or e.EventCodeId = 153053 -- Initial Disclosure - Uploaded for OS
				or e.EventCodeId = 153054 -- Initial Disclosure submitted - softcopy for OS
				or e.EventCodeId = 153055 -- Initial Disclosure submitted - hardcopy for OS
				--or e.EventCodeId = 153012 -- Initial Disclosure - CO submitted hardcopy to Stock Exchange
				OR e.EventCodeId = @nConfirm_Personal_Details_Event
		GROUP BY EventCodeId,UserInfoId
		
		
		
		UPDATE t SET t.SoftCopyReq = tm.SoftCopyReq
		FROM @TempEventLog t 
		JOIN tra_TransactionMaster_OS tm ON tm.TransactionMasterId = t.TMID 			
		where  tm.DisclosureTypeCodeId = 147001	
		
		UPDATE t SET t.HardCopyReq = tm.HardCopyReq
		FROM @TempEventLog t 
		JOIN tra_TransactionMaster_OS tm ON tm.TransactionMasterId = t.TMID 	
		where  tm.DisclosureTypeCodeId = 147001
		
		Declare @InsiderList TABLE (sequence INT IDENTITY(1,1),UserId INT)
		INSERT INTO @InsiderList
		SELECT u.UserInfoId 
		FROM usr_UserInfo u 
		where u.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND u.UserInfoId NOT IN (SELECT UserInfoId FROM @TempEventLog)
		--select * from @InsiderList
		
		INSERT INTO @TempEventLog
		SELECT UserId,0,NULL,NULL,0,0 
		FROM @InsiderList 
		
		
		
		CREATE TABLE #tUserData (Seq INT identity(1,1),UserInfoId INT,TMID INT, Name VARCHAR(max),Designation VARCHAR(max),
		TextEmailSentDate VARCHAR(max),EmailSentDate DATETIME,
		TextInitialDisclosureDate VARCHAR(max),InitialDisclosureDate DATETIME ,	InitialDisclosureStatus INT,
		TextSoftCopyDate VARCHAR(max),SoftCopyDate DATETIME ,SoftCopyStatus INT, 
		TextHardCopyDate VARCHAR(max),HardCopyDate DATETIME,HardCopyStatus INT,
		TextSubmitToStockExchange VARCHAR(max),SubmitToStockExchange DATETIME,SubmitToStockExchangeStatus INT,UserPanNumber NVARCHAR(50),EmpStatus INT,EmployeeID NVARCHAR(50),
		IsEnterAndUploadEvent INT DEFAULT 0,DefineSequence INT DEFAULT 0 ,Transactionstatus INT DEFAULT 0)

		IF(@RelativePendingFromDashboard='' or @RelativePendingFromDashboard is null)
		BEGIN
			INSERT INTO #tUserData
		SELECT 		u.UserInfoId														AS USerInfoId,
					CASE	WHEN t1.TMID IS NOT NULL THEN t1.TMID
							WHEN t2.TMID IS NOT NULL THEN t2.TMID
							WHEN t3.TMID IS NOT NULL THEN t3.TMID
							WHEN t4.TMID IS NOT NULL THEN t4.TMID
							--WHEN t5.TMID IS NOT NULL THEN t5.TMID
							WHEN t6.TMID IS NOT NULL THEN t6.TMID
							WHEN t7.TMID IS NOT NULL THEN t7.TMID
					END AS TransactionMasterId,
					CASE WHEN u.UserTypeCodeId = 101004 THEN company.CompanyName ELSE ISNULL(u.FirstName,'') + ' ' + isnull(u.LastName,'') END AS Name,
					CASE WHEN u.UserTypeCodeId = 101004 THEN u.DesignationText ELSE
					  	 CASE WHEN c.DisplayCode IS NULL OR c.DisplayCode = '' 
							THEN CodeName 
							ELSE DisplayCode END END										AS Designation,
					CASE	WHEN t1.DateOfEvent IS NULL THEN @PendingStatus
							WHEN t1.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL 
								 THEN @PendingStatus							 												
							ELSE NULL												END AS TextEmailSentDate,
					CASE	WHEN t1.DateOfEvent IS NULL THEN NULL
							WHEN t1.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL 
								 THEN NULL																	
							ELSE t1.DateOfEvent										END AS EmailSentDate,
												
					CASE	--WHEN t8.DateOfEvent IS NULL THEN 'DONOTSHOW'   
							--ELSE 
								--CASE 
							WHEN t2.DateOfEvent is null THEN @PendingStatus 
							WHEN t2.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL THEN @PendingStatus							
							ELSE NULL 
								--END 
							END AS TextInitialDisclosureDate,
							
					CASE	--WHEN t8.DateOfEvent IS NULL THEN NULL
							--ELSE
								--CASE 
							WHEN t2.DateOfEvent is null THEN NULL 
							WHEN t2.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL THEN NULL							
							ELSE t2.DateOfEvent	
								--END
							END AS InitialDisclosureDate,
							
					CASE	--WHEN t8.DateOfEvent IS NULL THEN 154002   
							--ELSE 
								--CASE 
							WHEN t2.DateOfEvent is null THEN 154002 
							ELSE 154001 
								--END 
							END AS InitialDisclosureStatus,
					
					CASE	WHEN t2.SoftCopyReq = 0	OR t2.SoftCopyReq IS NULL THEN 'DONOTSHOW' 
						--	WHEN t2.DateOfEvent IS NULL THEN 'DONOTSHOW'
							--WHEN t3.DateOfEvent IS NULL THEN @PendingStatus
							WHEN t2.SoftCopyReq = 1 AND t2.DateOfEvent is not null and  t3.DateOfEvent IS NULL THEN @PendingStatus							
							ELSE NULL												END AS TextSoftCopyDate,
							
					CASE	WHEN t3.SoftCopyReq = 0 OR t3.SoftCopyReq IS NULL    THEN NULL 
							WHEN t2.DateOfEvent IS NULL THEN NULL
							WHEN t3.DateOfEvent IS NULL THEN NULL							
							ELSE t3.DateOfEvent										END AS SoftCopyDate,
							
					CASE	WHEN t2.SoftCopyReq = 0 OR t2.SoftCopyReq IS NULL   THEN ''	
							--WHEN t2.DateOfEvent IS NULL THEN ''
							--WHEN t3.DateOfEvent IS NULL THEN 154002	
							WHEN t2.SoftCopyReq = 1 AND t2.DateOfEvent is not null and  t3.DateOfEvent IS NULL THEN 154002						
							ELSE 154001												END AS SoftCopyStatus,
					
					CASE	WHEN t3.HardCopyReq = 0	OR t3.HardCopyReq IS NULL    THEN 'DONOTSHOW'
							--WHEN t2.DateOfEvent IS NULL THEN 'DONOTSHOW'
							--WHEN t3.DateOfEvent IS NULL THEN 'DONOTSHOW'
							WHEN t3.HardCopyReq = 1 AND t3.DateOfEvent is not null and t4.DateOfEvent IS NULL THEN @PendingStatus	
							--WHEN t3.SoftCopyReq = 0 AND t4.HardCopyReq = 1 AND t4.DateOfEvent IS NULL THEN @PendingStatus		
							ELSE NULL												END AS TextHardCopyDate,
							
					CASE	WHEN t4.HardCopyReq = 0 OR t4.HardCopyReq IS NULL    THEN NULL
							WHEN t2.DateOfEvent IS NULL THEN NULL
							WHEN t3.DateOfEvent IS NULL THEN NULL
							WHEN t4.DateOfEvent IS NULL THEN NULL		
							ELSE t4.DateOfEvent										END AS HardCopyDate,	
							
					CASE	WHEN t3.HardCopyReq = 0 OR t3.HardCopyReq IS NULL    THEN ''
							--WHEN t2.DateOfEvent IS NULL THEN ''
							--WHEN t3.DateOfEvent IS NULL THEN ''
							WHEN t3.HardCopyReq = 1 AND t3.DateOfEvent is not null and t4.DateOfEvent IS NULL THEN 154002		
							ELSE 154001												END AS HardCopyStatus,
							
					CASE	WHEN t2.DateOfEvent IS NULL THEN 'DONOTSHOW'
							WHEN t3.DateOfEvent IS NULL THEN 'DONOTSHOW'
							WHEN t4.DateOfEvent IS NULL THEN 'DONOTSHOW'
							--WHEN t5.DateOfEvent IS NULL THEN @PendingStatus						
							ELSE NULL												END AS TextSubmitToStockExchange,
					CASE	WHEN t2.DateOfEvent IS NULL THEN NULL
							WHEN t3.DateOfEvent IS NULL THEN NULL
							WHEN t4.DateOfEvent IS NULL THEN NULL
							--WHEN t5.DateOfEvent IS NULL THEN NULL						
							--ELSE t5.DateOfEvent										END AS SubmitToStockExchange,
							ELSE t4.DateOfEvent									END AS SubmitToStockExchange,
					CASE	WHEN t2.DateOfEvent IS NULL THEN 154002
							WHEN t3.DateOfEvent IS NULL THEN 154002
							WHEN t4.DateOfEvent IS NULL THEN 154002
							--WHEN t5.DateOfEvent IS NULL THEN 154002						
							ELSE 154001												END AS SubmitToStockExchangeStatus,
							u.PAN AS UserPanNumber,
					CASE    WHEN u.StatusCodeId = @nEmployeeActive AND u.DateOfSeparation IS NULL THEN @nEmpStatusLiveCode
				            WHEN u.StatusCodeId = @nEmployeeActive AND u.DateOfSeparation IS NOT NULL THEN @nEmpStatusSeparatedCode
				            WHEN u.StatusCodeId = @nEmployeeInActive THEN @nEmpStatusInactiveCode
				            END AS EmpStatus,
					u.EmployeeId,
					0,
					CASE	WHEN t2.DateOfEvent is null THEN 1 
							WHEN t2.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL THEN 1							
							ELSE 2
								--END 
							END AS DefineSequence,
					0
					
		FROM		usr_UserInfo u 
					LEFT JOIN @TempEventLog t1 ON t1.UserInfoId = u.UserInfoId and t1.EventType = 153006
					LEFT JOIN @TempEventLog t2 ON t2.UserInfoId = u.UserInfoId and t2.EventType = 153052 -- Initial Disclosure details entered for OS153007 -- Initial Disclosure details entered
					LEFT JOIN @TempEventLog t3 ON t3.UserInfoId = u.UserInfoId and t3.EventType = 153054 -- Initial Disclosure submitted - softcopy for OS
					LEFT JOIN @TempEventLog t4 ON t4.UserInfoId = u.UserInfoId and t4.EventType = 153055 -- Initial Disclosure submitted - hardcopy for OS
					--LEFT JOIN @TempEventLog t5 ON t5.UserInfoId = u.UserInfoId and t5.EventType = 153055 -- 
					LEFT JOIN @TempEventLog t6 ON t6.UserInfoId = u.UserInfoId and t6.EventType = 0
					LEFT JOIN @TempEventLog t7 ON t7.UserInfoId = u.UserInfoId and t7.EventType = 153053 -- Initial Disclosure - Uploaded
					--LEFT JOIN @TempEventLog t8 ON t8.UserInfoId = u.UserInfoId and t8.EventType = @nConfirm_Personal_Details_Event
					LEFT JOIN com_Code c ON u.DesignationId = c.CodeID
					LEFT JOIN mst_Company company ON u.CompanyId = company.CompanyId
		where		((DateOfBecomingInsider IS NULL OR DateOfBecomingInsider > dbo.uf_com_GetServerDate()) 
					AND UserTypeCodeId in(101003,101004,101006)) OR u.DateOfBecomingInsider < dbo.uf_com_GetServerDate()
		END
		ELSE
		BEGIN

			INSERT INTO #tUserData
		SELECT 		u.UserInfoId														AS USerInfoId,
					CASE	WHEN t1.TMID IS NOT NULL THEN t1.TMID
							WHEN t2.TMID IS NOT NULL THEN t2.TMID
							WHEN t3.TMID IS NOT NULL THEN t3.TMID
							WHEN t4.TMID IS NOT NULL THEN t4.TMID
							--WHEN t5.TMID IS NOT NULL THEN t5.TMID
							WHEN t6.TMID IS NOT NULL THEN t6.TMID
							WHEN t7.TMID IS NOT NULL THEN t7.TMID
					END AS TransactionMasterId,
					CASE WHEN u.UserTypeCodeId = 101004 THEN company.CompanyName ELSE ISNULL(u.FirstName,'') + ' ' + isnull(u.LastName,'') END AS Name,
					CASE WHEN u.UserTypeCodeId = 101004 THEN u.DesignationText ELSE
					  	 CASE WHEN c.DisplayCode IS NULL OR c.DisplayCode = '' 
							THEN CodeName 
							ELSE DisplayCode END END										AS Designation,
					CASE	WHEN t1.DateOfEvent IS NULL THEN @PendingStatus
							WHEN t1.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL 
								 THEN @PendingStatus							 												
							ELSE NULL												END AS TextEmailSentDate,
					CASE	WHEN t1.DateOfEvent IS NULL THEN NULL
							WHEN t1.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL 
								 THEN NULL																	
							ELSE t1.DateOfEvent										END AS EmailSentDate,
												
					CASE	--WHEN t8.DateOfEvent IS NULL THEN 'DONOTSHOW'   
							--ELSE 
								--CASE 
							WHEN t2.DateOfEvent is null THEN @PendingStatus 
							WHEN t2.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL THEN @PendingStatus							
							ELSE NULL 
								--END 
							END AS TextInitialDisclosureDate,
							
					CASE	--WHEN t8.DateOfEvent IS NULL THEN NULL
							--ELSE
								--CASE 
							WHEN t2.DateOfEvent is null THEN NULL 
							WHEN t2.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL THEN NULL							
							ELSE t2.DateOfEvent	
								--END
							END AS InitialDisclosureDate,
							
					CASE	--WHEN t8.DateOfEvent IS NULL THEN 154002   
							--ELSE 
								--CASE 
							WHEN t2.DateOfEvent is null THEN 154002 
							ELSE 154001 
								--END 
							END AS InitialDisclosureStatus,
					
					CASE	WHEN t2.SoftCopyReq = 0	OR t2.SoftCopyReq IS NULL THEN 'DONOTSHOW' 
						--	WHEN t2.DateOfEvent IS NULL THEN 'DONOTSHOW'
							--WHEN t3.DateOfEvent IS NULL THEN @PendingStatus
							WHEN t2.SoftCopyReq = 1 AND t2.DateOfEvent is not null and  t3.DateOfEvent IS NULL THEN @PendingStatus							
							ELSE NULL												END AS TextSoftCopyDate,
							
					CASE	WHEN t3.SoftCopyReq = 0 OR t3.SoftCopyReq IS NULL    THEN NULL 
							WHEN t2.DateOfEvent IS NULL THEN NULL
							WHEN t3.DateOfEvent IS NULL THEN NULL							
							ELSE t3.DateOfEvent										END AS SoftCopyDate,
							
					CASE	WHEN t2.SoftCopyReq = 0 OR t2.SoftCopyReq IS NULL   THEN ''	
							--WHEN t2.DateOfEvent IS NULL THEN ''
							--WHEN t3.DateOfEvent IS NULL THEN 154002	
							WHEN t2.SoftCopyReq = 1 AND t2.DateOfEvent is not null and  t3.DateOfEvent IS NULL THEN 154002						
							ELSE 154001												END AS SoftCopyStatus,
					
					CASE	WHEN t3.HardCopyReq = 0	OR t3.HardCopyReq IS NULL    THEN 'DONOTSHOW'
							--WHEN t2.DateOfEvent IS NULL THEN 'DONOTSHOW'
							--WHEN t3.DateOfEvent IS NULL THEN 'DONOTSHOW'
							WHEN t3.HardCopyReq = 1 AND t3.DateOfEvent is not null and t4.DateOfEvent IS NULL THEN @PendingStatus	
							--WHEN t3.SoftCopyReq = 0 AND t4.HardCopyReq = 1 AND t4.DateOfEvent IS NULL THEN @PendingStatus		
							ELSE NULL												END AS TextHardCopyDate,
							
					CASE	WHEN t4.HardCopyReq = 0 OR t4.HardCopyReq IS NULL    THEN NULL
							WHEN t2.DateOfEvent IS NULL THEN NULL
							WHEN t3.DateOfEvent IS NULL THEN NULL
							WHEN t4.DateOfEvent IS NULL THEN NULL		
							ELSE t4.DateOfEvent										END AS HardCopyDate,	
							
					CASE	WHEN t3.HardCopyReq = 0 OR t3.HardCopyReq IS NULL    THEN ''
							--WHEN t2.DateOfEvent IS NULL THEN ''
							--WHEN t3.DateOfEvent IS NULL THEN ''
							WHEN t3.HardCopyReq = 1 AND t3.DateOfEvent is not null and t4.DateOfEvent IS NULL THEN 154002		
							ELSE 154001												END AS HardCopyStatus,
							
					CASE	WHEN t2.DateOfEvent IS NULL THEN 'DONOTSHOW'
							WHEN t3.DateOfEvent IS NULL THEN 'DONOTSHOW'
							WHEN t4.DateOfEvent IS NULL THEN 'DONOTSHOW'
							--WHEN t5.DateOfEvent IS NULL THEN @PendingStatus						
							ELSE NULL												END AS TextSubmitToStockExchange,
					CASE	WHEN t2.DateOfEvent IS NULL THEN NULL
							WHEN t3.DateOfEvent IS NULL THEN NULL
							WHEN t4.DateOfEvent IS NULL THEN NULL
							--WHEN t5.DateOfEvent IS NULL THEN NULL						
							--ELSE t5.DateOfEvent										END AS SubmitToStockExchange,
							ELSE t4.DateOfEvent									END AS SubmitToStockExchange,
					CASE	WHEN t2.DateOfEvent IS NULL THEN 154002
							WHEN t3.DateOfEvent IS NULL THEN 154002
							WHEN t4.DateOfEvent IS NULL THEN 154002
							--WHEN t5.DateOfEvent IS NULL THEN 154002						
							ELSE 154001												END AS SubmitToStockExchangeStatus,
							u.PAN AS UserPanNumber,
					CASE    WHEN u.StatusCodeId = @nEmployeeActive AND u.DateOfSeparation IS NULL THEN @nEmpStatusLiveCode
				            WHEN u.StatusCodeId = @nEmployeeActive AND u.DateOfSeparation IS NOT NULL THEN @nEmpStatusSeparatedCode
				            WHEN u.StatusCodeId = @nEmployeeInActive THEN @nEmpStatusInactiveCode
				            END AS EmpStatus,
					u.EmployeeId,
					0,
					CASE	WHEN t2.DateOfEvent is null THEN 1 
							WHEN t2.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL THEN 1							
							ELSE 2
								--END 
							END AS DefineSequence,
					0
					
		FROM		usr_UserInfo u 
					LEFT JOIN @TempEventLog t1 ON t1.UserInfoId = u.UserInfoId and t1.EventType = 153006
					LEFT JOIN @TempEventLog t2 ON t2.UserInfoId = u.UserInfoId and t2.EventType = 153052 -- Initial Disclosure details entered for OS153007 -- Initial Disclosure details entered
					LEFT JOIN @TempEventLog t3 ON t3.UserInfoId = u.UserInfoId and t3.EventType = 153054 -- Initial Disclosure submitted - softcopy for OS
					LEFT JOIN @TempEventLog t4 ON t4.UserInfoId = u.UserInfoId and t4.EventType = 153055 -- Initial Disclosure submitted - hardcopy for OS
					--LEFT JOIN @TempEventLog t5 ON t5.UserInfoId = u.UserInfoId and t5.EventType = 153055 -- 
					LEFT JOIN @TempEventLog t6 ON t6.UserInfoId = u.UserInfoId and t6.EventType = 0
					LEFT JOIN @TempEventLog t7 ON t7.UserInfoId = u.UserInfoId and t7.EventType = 153053 -- Initial Disclosure - Uploaded
					--LEFT JOIN @TempEventLog t8 ON t8.UserInfoId = u.UserInfoId and t8.EventType = @nConfirm_Personal_Details_Event
					LEFT JOIN com_Code c ON u.DesignationId = c.CodeID
					LEFT JOIN mst_Company company ON u.CompanyId = company.CompanyId
		where		 U.UserInfoId IN(SELECT * FROM @UserInfoIdForRelative)
		
		
		END
		

				
		UPDATE tUserData
		SET TextSoftCopyDate = @NotReqStatus
		FROM #tUserData tUserData JOIN tra_TransactionMaster_OS TM ON tUserData.TMID = TM.TransactionMasterId
		WHERE InitialDisclosureDate IS NOT NULL AND TM.SoftCopyReq = 0

		UPDATE tUserData
		SET TextHardCopyDate = @NotReqStatus
		FROM #tUserData tUserData JOIN tra_TransactionMaster_OS TM ON tUserData.TMID = TM.TransactionMasterId
		WHERE InitialDisclosureDate IS NOT NULL 
			AND (SoftCopyDate IS NOT NULL OR TM.SoftCopyReq = 0)
			AND HardCopyReq = 0
			
		UPDATE tUserData
		SET TextSubmitToStockExchange = @NotReqStatus
		FROM #tUserData tUserData JOIN tra_TransactionMaster_OS TM ON tUserData.TMID = TM.TransactionMasterId
		JOIN rul_TradingPolicy_OS TP on TM.TradingPolicyId = TP.TradingPolicyId 
		WHERE TP.DiscloInitSubmitToStExByCOFlag = 0 
		
		--select 'dbg1', * from #tUserData where UserInfoId = @inp_sUserInfoId
		UPDATE tUserData
			SET InitialDisclosureStatus = 154006,
			TextInitialDisclosureDate = @DocumentUploadedStatus
		FROM #tUserData tUserData JOIN tra_TransactionMaster_OS TM ON tUserData.UserInfoId = TM.UserInfoId AND DisclosureTypeCodeId = 147001
			JOIN eve_EventLog EL ON TM.TransactionMasterId = EL.MapToId AND MapToTypeCodeId = 132005 AND EventCodeId = 153008
		WHERE InitialDisclosureStatus = 154002
		
		UPDATE tUserData
			SET IsEnterAndUploadEvent = 1
		FROM #tUserData tUserData 
		JOIN eve_EventLog EL ON EL.MapToId = tUserData.TMID AND EL.MapToTypeCodeId = 132005
		AND EventCodeId = 153008
		WHERE InitialDisclosureStatus = 154001
		
		UPDATE tUserData
		SET Transactionstatus = TM.TransactionStatusCodeId
		FROM #tUserData tUserData JOIN tra_TransactionMaster_OS TM ON tUserData.TMID = TM.TransactionMasterId		
		
		--select 'dbg2', * from #tUserData tUserData JOIN tra_TransactionMaster TM ON tUserData.TMID = TM.TransactionMasterId
		--	JOIN eve_EventLog EL ON TM.TransactionMasterId = EL.MapToId AND MapToTypeCodeId = 132005 AND EventCodeId = 153008
		--WHERE InitialDisclosureStatus = 154002
		
		CREATE TABLE #tmpConfirmEmp
		(
		ID int Identity(1,1),
		UserInfoIdRelative bigint,
		UserInfoId bigint,
		TransPendingFlag int,
		SoftcopyPendingFlag int,
		HardcopyPendingFlag int
		)
		INSERT INTO #tmpConfirmEmp (UserInfoIdRelative,UserInfoId)		
		SELECT usrRelative.UserInfoIdRelative,usrRelative.UserInfoId FROM
		(
		select DISTINCT URI.UserInfoIdRelative,URI.UserInfoId from usr_UserRelation URI
		JOIN usr_DMATDetails UDMAT ON URI.UserInfoIdRelative=UDMAT.UserInfoID
		where URI.UserInfoId in(select UserInfoId from tra_TransactionMaster_OS where DisclosureTypeCodeId=147001 and TransactionStatusCodeId IN(148003,148007,148004))
		and UserInfoIdRelative not in(select distinct ForUserInfoId from tra_TransactionDetails_OS TD join 
		tra_TransactionMaster_OS TM on TM.TransactionMasterId=TD.TransactionMasterId
		where DisclosureTypeCodeId=147001 and TransactionStatusCodeId IN(148003,148007,148004)) 
		)usrRelative  JOIN usr_UserInfo UI ON usrRelative.UserInfoId=UI.UserInfoId WHERE (UI.DateOfSeparation IS NULL OR (UI.DateOfSeparation IS NOT NULL AND UI.DateOfSeparation>=GETDATE()))

		UPDATE  TC  SET TC.TransPendingFlag =1 FROM #tmpConfirmEmp TC		 
		WHERE TC.UserInfoIdRelative NOT IN(SELECT EL.UserInfoId FROM eve_EventLog EL WHERE EventCodeId IN(153052) AND EventCodeId NOT IN(153054))		
		
		UPDATE  TC  SET TC.SoftcopyPendingFlag =1 FROM #tmpConfirmEmp TC		
		WHERE TC.UserInfoIdRelative IN(SELECT EL.UserInfoId FROM eve_EventLog EL where EventCodeId in(153054,153052) group by UserInfoId having count(*)=1)

		UPDATE  TC  SET TC.HardcopyPendingFlag =1 FROM #tmpConfirmEmp TC		 
		WHERE TC.UserInfoIdRelative IN(SELECT EL.UserInfoId FROM eve_EventLog EL where EventCodeId in(153054,153055) group by UserInfoId having count(*)=1)	

		CREATE TABLE #tmpPendingTrans
		(
		ID INT identity(1,1),
		TransPendingFlag INT,
		SoftcopyPendingFlag INT,
		HardcopyPendingFlag INT,
		UserInfoId INT
		)
		INSERT INTO #tmpPendingTrans
		SELECT count(TransPendingFlag) as TransPendingFlag,count(SoftcopyPendingFlag) as SoftcopyPendingFlag,count(HardcopyPendingFlag) as HardcopyPendingFlag,UserInfoId from #tmpConfirmEmp
		GROUP BY UserInfoId
		
		
		CREATE TABLE #tmpTradingPolicy
		(
		ID INT IDENTITY(1,1),
		ApplicabilityMstId INT,
		UserInfoId INT,
		MapToId INT
		)
		INSERT INTO #tmpTradingPolicy(ApplicabilityMstId,UserInfoId,MapToId)
		SELECT * FROM vw_ApplicableTradingPolicyForUser_OS			
		
		UPDATE tUserData
		SET TextSoftCopyDate = @NotReqStatus,TextEmailSentDate=@NotReqStatus,
		TextInitialDisclosureDate=@NotReqStatus,
		TextSubmitToStockExchange=@NotReqStatus,TextHardCopyDate=@NotReqStatus,DefineSequence=3
		FROM #tUserData tUserData 
		WHERE tUserData.UserInfoId NOT IN (SELECT UserInfoId FROM #tmpTradingPolicy)
	
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 			
			SELECT @inp_sSortOrder = 'DESC '
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 	
			SELECT @inp_sSortField = 't.InitialDisclosureDate '
		END 
		
		IF @inp_sSortField  = 'dis_grd_52032'
		BEGIN		
			SELECT @inp_sSortField = 't.EmployeeId '
		END
		
		IF @inp_sSortField  = 'dis_grd_52033'
		BEGIN		
			SELECT @inp_sSortField = 't.Name '
		END
		
		IF @inp_sSortField  = 'dis_grd_52034'
		BEGIN		 
			SELECT @inp_sSortField = 't.Designation '
		END
		
		IF @inp_sSortField  = 'dis_grd_52035'
		BEGIN		
			SELECT @inp_sSortField = 't.EmailSentDate '
		END
		
		IF @inp_sSortField  = 'dis_grd_52036'
		BEGIN		
			SELECT @inp_sSortField = 't.InitialDisclosureDate '
		END
		
		IF @inp_sSortField  = 'dis_grd_52037'
		BEGIN 
			SELECT @inp_sSortField = 't.SoftCopyDate '
		END
		
		IF @inp_sSortField  = 'dis_grd_52038'
		BEGIN 
			SELECT @inp_sSortField = 't.HardCopyDate '
		END
		
		IF @inp_sSortField  = 'dis_grd_52039'
		BEGIN 
			SELECT @inp_sSortField = 't.SubmitToStockExchange '
		END
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY t.DefineSequence ASC,t.UserInfoId DESC),t.UserInfoId'	
		SELECT @sSQL = @sSQL + ' FROM eve_EventLog e RIGHT JOIN #tUserData t ON t.UserInfoId = e.UserInfoId'
		SELECT @sSQL = @sSQL + ' INNER JOIN usr_Authentication A ON t.UserInfoId = A.UserInfoID'
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '

		IF (@inp_sLoginID IS NOT NULL AND @inp_sLoginID <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND A.LoginID LIKE N''%'+ @inp_sLoginID +'%'' '
		END

		IF(@inp_sUserInfoId IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND t.UserInfoID = ' + Convert(varchar(100),@inp_sUserInfoId)	
		END

		IF(@inp_sEmployeeName IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND t.Name like ' + '''%'  + @inp_sEmployeeName  + '%'''
		END
		
		IF(@inp_sEmployeePAN IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND t.UserPanNumber like ' + '''%'  + @inp_sEmployeePAN  + '%'''
		END
		
        IF(@inp_sEmployeeStatus IS NOT NULL OR @inp_sEmployeeStatus <> 0)
		BEGIN
		        IF(@inp_sEmployeeStatus = @nEmpStatusLiveCode)
		        BEGIN
		           SELECT @sSQL = @sSQL + ' AND t.EmpStatus = ' + CONVERT(VARCHAR,@nEmpStatusLiveCode)
		        END
		        
		        ELSE IF(@inp_sEmployeeStatus = @nEmpStatusSeparatedCode)
		        BEGIN
		           SELECT @sSQL = @sSQL + ' AND t.EmpStatus = ' + CONVERT(VARCHAR,@nEmpStatusSeparatedCode)
		        END
		        
		        ELSE IF(@inp_sEmployeeStatus = @nEmpStatusInactiveCode)
		        BEGIN
		           SELECT @sSQL = @sSQL + ' AND t.EmpStatus = ' + CONVERT(VARCHAR,@nEmpStatusInactiveCode)
		        END
		END
		
		IF(@inp_sDesignation IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND t.Designation like ' + '''%'  + @inp_sDesignation  + '%'''
		END
		
		IF(@inp_dtEmailSentDate IS NOT NULL)
		BEGIN
		SELECT @sSQL = @sSQL + ' AND ((t.EmailSentDate IS NOT NULL )'
		SELECT @sSQL = @sSQL + ' AND (DATEDIFF(DAY,t.EmailSentDate,CAST(''' + CAST(@inp_dtEmailSentDate AS VARCHAR(25)) + ''' AS DATETIME)) = 0 ))'
		END
		
		IF(@inp_dtHodlingDetailsSubmissionFrom	IS NOT NULL AND @inp_dtHodlingDetailsSubmissionTo IS NOT NULL )
		BEGIN			
			SELECT @sSQL = @sSQL + ' AND ((t.InitialDisclosureDate IS NOT NULL )'								
			SELECT @sSQL = @sSQL + ' AND  (CONVERT(DATE,t.InitialDisclosureDate) >= CONVERT(DATE,'''  + CONVERT(VARCHAR(25), @inp_dtHodlingDetailsSubmissionFrom ) + '''))'
			SELECT @sSQL = @sSQL + ' AND  (CONVERT(DATE,t.InitialDisclosureDate) <= CONVERT(DATE,'''  + CONVERT(VARCHAR(25), @inp_dtHodlingDetailsSubmissionTo ) + ''')))'
		END
		ELSE IF (@inp_dtHodlingDetailsSubmissionFrom IS NOT NULL AND @inp_dtHodlingDetailsSubmissionTo IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( t.InitialDisclosureDate IS NOT NULL AND CONVERT(DATE,t.InitialDisclosureDate) >= CONVERT(DATE, ''' + CONVERT(VARCHAR(25), @inp_dtHodlingDetailsSubmissionFrom) + '''))'
		END
		ELSE IF (@inp_dtHodlingDetailsSubmissionFrom IS NULL AND @inp_dtHodlingDetailsSubmissionTo IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (t.InitialDisclosureDate IS NOT NULL AND CONVERT(DATE,t.InitialDisclosureDate) <= CONVERT(DATE, ''' + CONVERT(VARCHAR(25), @inp_dtHodlingDetailsSubmissionTo) + '''))'
		END	
		IF(@inp_dtSoftCopyFrom	IS NOT NULL AND @inp_dtSoftCopyTo IS NOT NULL )
		BEGIN
			SELECT @sSQL = @sSQL + ' AND ((t.SoftCopyDate IS NOT NULL )'								
			SELECT @sSQL = @sSQL + ' AND  (CONVERT(DATE,t.SoftCopyDate) >= CONVERT(DATE,'''  + CONVERT(VARCHAR(25), @inp_dtSoftCopyFrom ) + '''))'
			SELECT @sSQL = @sSQL + ' AND  (CONVERT(DATE,t.SoftCopyDate) <= CONVERT(DATE,'''  + CONVERT(VARCHAR(25), @inp_dtSoftCopyTo ) + ''')))'
		END
		ELSE IF (@inp_dtSoftCopyFrom IS NOT NULL AND @inp_dtSoftCopyTo IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( t.SoftCopyDate IS NOT NULL AND CONVERT(DATE,t.SoftCopyDate) >= CONVERT(DATE, ''' + CONVERT(VARCHAR(25), @inp_dtSoftCopyFrom) + '''))'
		END
		ELSE IF (@inp_dtSoftCopyFrom IS NULL AND @inp_dtSoftCopyTo IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (t.SoftCopyDate IS NOT NULL AND CONVERT(DATE,t.SoftCopyDate) <= CONVERT(DATE, ''' + CONVERT(VARCHAR(25), @inp_dtSoftCopyTo) + '''))'
		END	

		IF(@inp_dtHardCopyFrom	IS NOT NULL AND @inp_dtHardCopyTo IS NOT NULL )
		BEGIN
			SELECT @sSQL = @sSQL + ' AND ((t.HardCopyDate IS NOT NULL )'								
			SELECT @sSQL = @sSQL + ' AND  (CONVERT(DATE,t.HardCopyDate) >= CONVERT(DATE,'''  + CONVERT(VARCHAR(25), @inp_dtHardCopyFrom ) + '''))'
			SELECT @sSQL = @sSQL + ' AND  (CONVERT(DATE,t.HardCopyDate) <= CONVERT(DATE,'''  + CONVERT(VARCHAR(25), @inp_dtHardCopyTo ) + ''')))'
		END
		ELSE IF (@inp_dtHardCopyFrom IS NOT NULL AND @inp_dtHardCopyTo IS NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND ( t.HardCopyDate IS NOT NULL AND CONVERT(DATE,t.HardCopyDate) >= CONVERT(DATE, ''' + CONVERT(VARCHAR(25), @inp_dtHardCopyFrom) + '''))'
		END
		ELSE IF (@inp_dtSoftCopyFrom IS NULL AND @inp_dtSoftCopyTo IS NOT NULL)
		BEGIN	
				SELECT @sSQL = @sSQL + ' AND (t.HardCopyDate IS NOT NULL AND CONVERT(DATE,t.HardCopyDate) <= CONVERT(DATE, ''' + CONVERT(VARCHAR(25), @inp_dtHardCopyTo) + '''))'
		END	
		IF(@inp_dtStockExchangeFrom	IS NOT NULL AND @inp_dtStockExchangeTo IS NOT NULL )
		BEGIN
			SELECT @sSQL = @sSQL + ' AND ((t.SubmitToStockExchange IS NOT NULL  )' 
			SELECT @sSQL = @sSQL + ' AND ((t.SubmitToStockExchange >= CAST('''  + CAST(@inp_dtStockExchangeFrom AS VARCHAR(25)) + ''' AS DATETIME))'
			SELECT @sSQL = @sSQL + ' AND ( t.SubmitToStockExchange <= CAST('''  + CAST(@inp_dtStockExchangeTo AS VARCHAR(25)) + '''AS DATETIME))))'
		END
		PRINT @RelativePendingFromDashboard
		
		IF(@RelativePendingFromDashboard<>1 OR @RelativePendingFromDashboard='' OR @RelativePendingFromDashboard IS NULL )
		BEGIN
		PRINT 222
		PRINT @RelativePendingFromDashboard
			IF(@inp_sHodlingDetailsSubmissionStatus IS NOT NULL)
		BEGIN
			IF(@inp_sHodlingDetailsSubmissionStatus=154001)
			BEGIN
				SELECT @sSQL = @sSQL + ' AND t.DefineSequence= 2'
			END
			ELSE IF(@inp_sHodlingDetailsSubmissionStatus=154002)
			BEGIN
				SELECT @sSQL = @sSQL + ' AND t.DefineSequence = 1' 
			END
			ELSE
			BEGIN
				SELECT @sSQL = @sSQL + ' AND t.DefineSequence = 3' 
			END
			
			SELECT @sSQL = @sSQL + ' AND t.InitialDisclosureStatus = ' +  CONVERT(varchar(10),@inp_sHodlingDetailsSubmissionStatus )
		END

		IF(@inp_sSoftCopyStatus IS NOT NULL)
		BEGIN
		
			IF(@inp_sSoftCopyStatus=154001)
			BEGIN
				SELECT @sSQL = @sSQL + ' AND t.DefineSequence= 2'
			END
			ELSE IF(@inp_sSoftCopyStatus=154002)
			BEGIN
				SELECT @sSQL = @sSQL + ' AND t.DefineSequence = 1' 
			END
			ELSE
			BEGIN
				SELECT @sSQL = @sSQL + ' AND t.DefineSequence = 3' 
			END
			
			SELECT @sSQL = @sSQL + ' AND t.SoftCopyStatus = ' + CONVERT(varchar(10),@inp_sSoftCopyStatus)
		END

		IF(@inp_sHardCopyStatus IS NOT NULL)
		BEGIN
			IF(@inp_sHardCopyStatus=154001)
			BEGIN
				SELECT @sSQL = @sSQL + ' AND t.DefineSequence= 2'
			END
			ELSE IF(@inp_sHardCopyStatus=154002)
			BEGIN
				SELECT @sSQL = @sSQL + ' AND t.DefineSequence = 1' 
			END
			ELSE
			BEGIN
				SELECT @sSQL = @sSQL + ' AND t.DefineSequence = 3' 
			END
			SELECT @sSQL = @sSQL + ' AND t.HardCopyStatus = ' +  CONVERT(varchar(10),@inp_sHardCopyStatus)
		END

		END
		

		IF(@inp_sStockExchangeStatus IS NOT NULL)
		BEGIN
		
			SELECT @sSQL = @sSQL + ' AND t.SubmitToStockExchangeStatus = ' +  CONVERT(varchar(10),@inp_sStockExchangeStatus)
		END
		
		
		IF(@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND t.EmployeeID  like ' + '''%'  + @inp_sEmployeeID  + '%'''
		END
		
		DECLARE @WHERE_CLAUSE AS VARCHAR(100)
		SET @WHERE_CLAUSE = ''

		IF @inp_iPageSize = 1
			SET @WHERE_CLAUSE = ' AND tu.TMID IS NOT NULL '	
			
			--SELECT @sSQL = @sSQL + ' order by DefineSequence '
	
		--SELECT DISTINCT DENSE_RANK() OVER(Order BY t.UserInfoId desc, t.InitialDisclosureDate  DESC ),t.UserInfoId
		--FROM eve_EventLog e RIGHT JOIN #tUserData t ON t.UserInfoId = e.UserInfoId
		--select * from #tUserData
		--SELECT DISTINCT DENSE_RANK() OVER(Order BY t.DefineSequence ASC,t.UserInfoId DESC),t.UserInfoId FROM eve_EventLog e RIGHT JOIN #tUserData t ON t.UserInfoId = e.UserInfoId INNER JOIN usr_Authentication A ON t.UserInfoId = A.UserInfoID WHERE 1 = 1  --AND t.DefineSequence = 1 AND t.InitialDisclosureStatus = 154002
		--return
		print @sSQL
		EXEC (@sSQL)
	--SELECT * FROM #tmpList return
	

		EXEC(
		'SELECT 
			tu.TMID						 AS TransactionMasterId,
			tu.UserInfoId				 AS UserInfoId,
			tu.EmployeeID				 AS dis_grd_52032,
			tu.Name						 AS dis_grd_52033,
			tu.UserPanNumber             AS dis_grd_52041,
			CASE WHEN tu.EmpStatus = '+ @nEmpStatusLiveCode +' THEN '''+ @nEmployeeStatusLive +'''  
			     WHEN tu.EmpStatus = '+ @nEmpStatusSeparatedCode +' THEN '''+ @nEmployeeStatusSeparated +''' 
			     WHEN tu.EmpStatus = '+ @nEmpStatusInactiveCode +' THEN '''+ @nEmployeeStatusInactive +'''  
			END  AS dis_grd_52040,
			tu.Designation				 AS dis_grd_52034,
			tu.TextEmailSentDate		 AS TextEmailSentDate,
			tu.EmailSentDate 			 As dis_grd_52035,
			tu.TextInitialDisclosureDate AS TextInitialDisclosureDate,
			tu.InitialDisclosureDate	 As dis_grd_52036,
			tu.TextSoftCopyDate			 AS TextSoftCopyDate,
			tu.SoftCopyDate				 As dis_grd_52037,
			tu.TextHardCopyDate			 As TextHardCopyDate,
			tu.HardCopyDate				 As dis_grd_52038,
			tu.TextSubmitToStockExchange As TextSubmitToStockExchange,
			tu.SubmitToStockExchange	 As dis_grd_52039,
			IsEnterAndUploadEvent AS IsEnterAndUploadEvent,
			tc.TransPendingFlag,
			tc.SoftcopyPendingFlag,
			tc.HardcopyPendingFlag,
			tu.DefineSequence,
			tu.Transactionstatus
		FROM #tmpList t
		JOIN #tUserData tu ON tu.UserInfoId  =  t.EntityID
		LEFT join #tmpPendingTrans tc on tc.UserInfoId= tu.UserInfoId
		 
		WHERE 1 =1 '
		+ @WHERE_CLAUSE +
		'AND (('+@inp_iPageSize+' = 0) OR (T.RowNumber BETWEEN (('+@inp_iPageNo+' - 1) * '+@inp_iPageSize+' + 1) AND ('+@inp_iPageNo+' * '+@inp_iPageSize+')))
		order by t.RowNumber')
		
		DROP TABLE #tUserData		
		DROP TABLE #tmpPendingTrans
		DROP table #tmpConfirmEmp	
		DROP TABLE #tmpTradingPolicy
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COInitialDisclosure_LIST
	END CATCH
END
GO
