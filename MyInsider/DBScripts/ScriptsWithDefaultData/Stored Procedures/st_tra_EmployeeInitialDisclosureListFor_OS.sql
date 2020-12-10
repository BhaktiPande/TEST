IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_EmployeeInitialDisclosureListFor_OS')
DROP PROCEDURE [dbo].[st_tra_EmployeeInitialDisclosureListFor_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to get Initial Disclosure List for Employee for Other Securities

Returns:		0, if Success.
				
Created by:		Shubhangi
Created on:		09-Feb-2018

Modification History:

Usage:
EXEC st_tra_EmployeeInitialDisclosureListFor_OS
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_EmployeeInitialDisclosureListFor_OS]
	@inp_iPageSize							INT = 10
	,@inp_iPageNo							INT = 1
	,@inp_sSortField						VARCHAR(255)
	,@inp_sSortOrder						VARCHAR(5)	
    ,@inp_sUserInfoId						INT 
    ,@inp_sUserTypeCodeId					INT
	,@out_nReturnValue						INT = 0 OUTPUT
	,@out_nSQLErrCode						INT = 0 OUTPUT			  -- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage					VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_COInitialDisclosure_LIST INT = -1
	DECLARE @PendingStatus VARCHAR(10)
	DECLARE @ViewStatus VARCHAR(10)
	DECLARE @NotReqStatus VARCHAR(100)
	DECLARE @DocumentUploadedStatus VARCHAR(100)
	DECLARE @UserTypeCodeIdforCO INT=101001
	DECLARE @UserTypeCodeIdforAdmin INT=101002
	
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
		

DECLARE @TempEventLog TABLE(Seq INT IDENTITY(1,1), UserInfoId INT, EventType VARCHAR(max), DateOfEvent datetime, TMID INT,
            SoftCopyReq bit,HardCopyReq bit)

DECLARE @UserInfoid TABLE (UsrID int)

INSERT INTO @UserInfoid
SELECT UsrId.UserInfoId FROM
(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId=@inp_sUserInfoId
UNION
SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoId=@inp_sUserInfoId) UsrId             
               
DECLARE @nFirstTrans INT=0 

DECLARE @dtDateofBecomingInsider datetime

SELECT @dtDateofBecomingInsider=DateOfBecomingInsider FROM usr_UserInfo WHERE UserInfoId=@inp_sUserInfoId           

INSERT INTO @TempEventLog   
SELECT      e.UserInfoId,e.EventCodeId,   max(e.EventDate),max(e.MapToId),0,0                   
FROM  eve_EventLog e WHERE       (
e.EventCodeId = 153052 -- Initial Disclosure details entered for OS
OR e.EventCodeId = 153053 -- Initial Disclosure - Uploaded for OS
OR e.EventCodeId = 153054 -- Initial Disclosure submitted - softcopy for OS
OR e.EventCodeId = 153055 -- Initial Disclosure submitted - hardcopy for OS
OR e.EventCodeId = 153043 
)
and MapToId IN(
SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD
ON TM.TransactionMasterId=TD.TransactionMasterId
WHERE TM.UserInfoId=@inp_sUserInfoId AND TD.DateOfAcquisition<@dtDateofBecomingInsider
UNION
SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD
ON TM.TransactionMasterId=TD.TransactionMasterId
WHERE TM.UserInfoId IN(SELECT usr_UserRelation.UserInfoIdRelative AS UserInfoId FROM usr_UserInfo
JOIN usr_UserRelation ON usr_UserInfo.UserInfoId=usr_UserRelation.UserInfoId
WHERE usr_UserInfo.UserInfoId=@inp_sUserInfoId)
AND TD.DateOfAcquisition<@dtDateofBecomingInsider
UNION
SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM JOIN usr_UserInfo UI
on TM.UserInfoId=UI.UserInfoId
WHERE TM.UserInfoId=@inp_sUserInfoId and UI.DateOfBecomingInsider IS NULL
UNION
SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM JOIN usr_UserInfo UI
on TM.UserInfoId=UI.UserInfoId
where TM.UserInfoId IN(SELECT usr_UserRelation.UserInfoIdRelative AS UserInfoId FROM usr_UserInfo
JOIN usr_UserRelation ON usr_UserInfo.UserInfoId=usr_UserRelation.UserInfoId
WHERE usr_UserInfo.UserInfoId=@inp_sUserInfoId AND usr_UserInfo.DateOfBecomingInsider IS NULL)
) 
and UserInfoId in (select UsrID from @UserInfoid)
GROUP BY EventCodeId,UserInfoId


SELECT @nFirstTrans=COUNT(E.UserInfoId) FROM @TempEventLog E

INSERT INTO @TempEventLog    
SELECT e.UserInfoId,e.EventCodeId, MAX(e.EventDate),MAX(e.MapToId),0,0                   
FROM  eve_EventLog e WHERE   
e.EventCodeId IN (153028) 
and UserInfoId IN(SELECT UserInfoId FROM usr_UserInfo WHERE usr_UserInfo.UserInfoId=@inp_sUserInfoId)
AND E.EventDate <= (SELECT EventDate  FROM eve_EventLog WHERE EventCodeId IN(153003) AND UserInfoId=@inp_sUserInfoId)
GROUP BY e.UserInfoId,e.EventCodeId

INSERT INTO @TempEventLog    
SELECT e.UserInfoId,e.EventCodeId, e.EventDate,e.MapToId,0,0                   
FROM  eve_EventLog e WHERE   
e.EventCodeId IN (153028) 
and UserInfoId IN(SELECT UserInfoId FROM usr_UserInfo WHERE usr_UserInfo.UserInfoId=@inp_sUserInfoId AND usr_UserInfo.DateOfBecomingInsider IS NULL)

IF(@nFirstTrans=0)
BEGIN

INSERT INTO @TempEventLog    
SELECT e.UserInfoId,e.EventCodeId, e.EventDate,e.MapToId,0,0                  
FROM  eve_EventLog e WHERE   
e.EventCodeId IN (153043) 
and UserInfoId IN(SELECT UserInfoId FROM usr_UserInfo WHERE usr_UserInfo.UserInfoId=@inp_sUserInfoId AND usr_UserInfo.DateOfBecomingInsider IS NULL)

INSERT INTO @TempEventLog    
SELECT e.UserInfoId,e.EventCodeId, e.EventDate,e.MapToId,0,0                  
FROM  eve_EventLog e WHERE   
e.EventCodeId IN (153001) 
and UserInfoId IN(SELECT UserInfoId FROM usr_UserInfo WHERE usr_UserInfo.UserInfoId=@inp_sUserInfoId AND usr_UserInfo.DateOfBecomingInsider IS NULL)
END



UPDATE t SET t.SoftCopyReq = tm.SoftCopyReq FROM @TempEventLog t JOIN tra_TransactionMaster_OS tm ON tm.TransactionMasterId = t.TMID where  tm.DisclosureTypeCodeId = 147001    
            
UPDATE t SET t.HardCopyReq = tm.HardCopyReq FROM @TempEventLog t JOIN tra_TransactionMaster_OS tm ON tm.TransactionMasterId = t.TMID where  tm.DisclosureTypeCodeId = 147001


IF(@dtDateofBecomingInsider IS NULL)
BEGIN

DECLARE @checkTransId INT
Create table #tmpTrans
(
ID int identity(1,1),
TransMasterId int
)
Insert into #tmpTrans
select TransactionMasterId from tra_TransactionMaster_OS where UserInfoId=@inp_sUserInfoId and DisclosureTypeCodeId=147001 AND TransactionStatusCodeId IN(148003,148004,148007)
SELECT @checkTransId=TransMasterId FROM #tmpTrans

Create table #tmpExcludedRel
(
ID int identity(1,1),
UserInfoIdRelative int
)

IF(@checkTransId IS NOT NULL)
BEGIN 
 insert into #tmpExcludedRel 
 select URI.UserInfoIdRelative from usr_UserRelation URI 
 JOIN usr_UserInfo UI ON URI.UserInfoId=UI.UserInfoId
 JOIN usr_DMATDetails UDMAT ON URI.UserInfoIdRelative=UDMAT.UserInfoID 
 where URI.UserInfoIdRelative not in(
select tra_TransactionDetails_OS.ForUserInfoId from tra_TransactionDetails_OS where TransactionMasterId in(select TransMasterId from #tmpTrans)
) and URI.UserInfoId=@inp_sUserInfoId AND UI.StatusCodeId=102001
END

INSERT INTO @TempEventLog
SELECT UserInfoIdRelative,0,NULL,NULL,0,0 
FROM #tmpExcludedRel

DROP TABLE #tmpExcludedRel
DROP TABLE #tmpTrans
END


DECLARE @dtDateofEvent DATETIME
SELECT @dtDateofEvent=EventDate FROM eve_EventLog WHERE UserInfoId=@inp_sUserInfoId and EventCodeId=153028
DECLARE @nTotCnt INT=0
DECLARE @nRowCnt INT=0
CREATE TABLE #tmpAddrel
(
ID INT IDENTITY(1,1),
UsrInfoId INT
)
INSERT INTO #tmpAddrel
SELECT DISTINCT UserInfoId FROM @TempEventLog WHERE UserInfoId IN(select UserInfoIdRelative from usr_UserRelation WHERE UserInfoId=@inp_sUserInfoId)
SELECT @nTotCnt=UsrInfoId FROM #tmpAddrel 

WHILE @nRowCnt< @nTotCnt
BEGIN
INSERT INTO @TempEventLog
SELECT UsrInfoId,153028,@dtDateofEvent,NULL,0,0 
FROM #tmpAddrel WHERE ID=@nRowCnt+1
SET @nRowCnt=@nRowCnt+1
END

DROP TABLE #tmpAddrel


SELECT @PendingStatus =  'Pending'
		SELECT @NotReqStatus =  'Not Required'
		SELECT @DocumentUploadedStatus = 'Document Uploaded'
		SELECT @ViewStatus='Viewed'

CREATE TABLE #tUserData (Seq INT identity(1,1),UserInfoId INT,TMID INT, Name VARCHAR(max),Designation VARCHAR(max),
		TextEmailSentDate VARCHAR(max),EmailSentDate DATETIME,DocumentUploadStatus varchar(max),
		TextInitialDisclosureDate VARCHAR(max),InitialDisclosureDate DATETIME ,	InitialDisclosureStatus INT,
		TextSoftCopyDate VARCHAR(max),SoftCopyDate DATETIME ,SoftCopyStatus INT, 
		TextHardCopyDate VARCHAR(max),HardCopyDate DATETIME,HardCopyStatus INT,
		TextSubmitToStockExchange VARCHAR(max),SubmitToStockExchange DATETIME,SubmitToStockExchangeStatus INT,UserPanNumber NVARCHAR(50),
		--EmpStatus INT,
		EmployeeID NVARCHAR(50),
		IsEnterAndUploadEvent INT DEFAULT 0,
		UserTypeCodeId INT,
		FrmView varchar(50),PolicyDocumentId INT,DocumentId INT,ParentUserInfoID INT)

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
											
					CASE WHEN (@UserTypeCodeIdforAdmin=@inp_sUserTypeCodeId OR @UserTypeCodeIdforCO=@inp_sUserTypeCodeId) AND t8.DateOfEvent IS NULL THEN NULL
					ELSE
					CASE 
					WHEN t8.DateOfEvent is null THEN @PendingStatus 
					ELSE @ViewStatus
						END
					END	AS DocumentUploadStatus,
					
					
					CASE WHEN (@UserTypeCodeIdforAdmin=@inp_sUserTypeCodeId OR @UserTypeCodeIdforCO=@inp_sUserTypeCodeId) AND t2.DateOfEvent IS NULL THEN @PendingStatus
					ELSE
						CASE WHEN (@UserTypeCodeIdforAdmin=@inp_sUserTypeCodeId OR @UserTypeCodeIdforCO=@inp_sUserTypeCodeId) AND t2.DateOfEvent IS NOT NULL THEN NULL
						ELSE
						CASE WHEN t8.DateOfEvent IS NULL THEN 'DONOTSHOW'   
							ELSE 
								CASE 
							WHEN t2.DateOfEvent is null THEN @PendingStatus 
							WHEN t2.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL THEN @PendingStatus							
							ELSE NULL 
								END 								
							END
						END
					END					
					AS TextInitialDisclosureDate,
						
					CASE WHEN (@UserTypeCodeIdforAdmin=@inp_sUserTypeCodeId OR @UserTypeCodeIdforCO=@inp_sUserTypeCodeId) AND t2.DateOfEvent IS NULL THEN NULL
					ELSE
					CASE WHEN (@UserTypeCodeIdforAdmin=@inp_sUserTypeCodeId OR @UserTypeCodeIdforCO=@inp_sUserTypeCodeId) AND t2.DateOfEvent IS NOT NULL THEN t2.DateOfEvent
					ELSE
					CASE	WHEN t8.DateOfEvent IS NULL THEN NULL
							ELSE
								CASE 
							WHEN t2.DateOfEvent is null THEN NULL 
							WHEN t2.DateOfEvent IS NULL AND t6.DateOfEvent IS NULL THEN NULL							
							ELSE t2.DateOfEvent	
							END
							END 
					END
					END		AS InitialDisclosureDate,	
						
					CASE	WHEN t8.DateOfEvent IS NULL THEN 154002   
							ELSE 
								CASE 
							WHEN t2.DateOfEvent is null THEN 154002 
							ELSE 154001 
							END 
							END AS InitialDisclosureStatus,
							
					CASE WHEN (@UserTypeCodeIdforAdmin=@inp_sUserTypeCodeId OR @UserTypeCodeIdforCO=@inp_sUserTypeCodeId) THEN 
								CASE WHEN t2.SoftCopyReq = 0	OR t2.SoftCopyReq IS NULL THEN 'DONOTSHOW' 						
								WHEN t2.SoftCopyReq = 1 AND t2.DateOfEvent is not null and  t3.DateOfEvent IS NULL THEN @PendingStatus							
								ELSE NULL END 
					ELSE						
							CASE WHEN t8.DateOfEvent IS NULL THEN 'DONOTSHOW'   
							ELSE								
								CASE WHEN t2.SoftCopyReq = 0	OR t2.SoftCopyReq IS NULL THEN 'DONOTSHOW' 						
								WHEN t2.SoftCopyReq = 1 AND t2.DateOfEvent is not null and  t3.DateOfEvent IS NULL THEN @PendingStatus							
								ELSE NULL END 								
							END						
					END					
					AS TextSoftCopyDate,
					
					CASE WHEN (@UserTypeCodeIdforAdmin=@inp_sUserTypeCodeId OR @UserTypeCodeIdforCO=@inp_sUserTypeCodeId) THEN 
								CASE WHEN t3.SoftCopyReq = 0 OR t3.SoftCopyReq IS NULL    THEN NULL 
								WHEN t2.DateOfEvent IS NULL THEN NULL
								WHEN t3.DateOfEvent IS NULL THEN NULL							
								ELSE t3.DateOfEvent	END
					ELSE
						CASE WHEN t8.DateOfEvent IS NULL THEN NULL  
							ELSE								
								CASE	WHEN t3.SoftCopyReq = 0 OR t3.SoftCopyReq IS NULL    THEN NULL 
								WHEN t2.DateOfEvent IS NULL THEN NULL
								WHEN t3.DateOfEvent IS NULL THEN NULL							
								ELSE t3.DateOfEvent	END				
							END						
					END					
					AS SoftCopyDate,
					
					CASE WHEN (@UserTypeCodeIdforAdmin=@inp_sUserTypeCodeId OR @UserTypeCodeIdforCO=@inp_sUserTypeCodeId) THEN 
					CASE	WHEN t2.SoftCopyReq = 0 OR t2.SoftCopyReq IS NULL   THEN ''								
							WHEN t2.SoftCopyReq = 1 AND t2.DateOfEvent is not null and  t3.DateOfEvent IS NULL THEN 154002						
							ELSE 154001	END
					ELSE
						CASE WHEN t8.DateOfEvent IS NULL THEN NULL  
							ELSE								
						CASE	WHEN t2.SoftCopyReq = 0 OR t2.SoftCopyReq IS NULL   THEN ''								
							WHEN t2.SoftCopyReq = 1 AND t2.DateOfEvent is not null and  t3.DateOfEvent IS NULL THEN 154002						
							ELSE 154001	END			
							END						
					END					
					AS SoftCopyStatus,
					
					CASE WHEN (@UserTypeCodeIdforAdmin=@inp_sUserTypeCodeId OR @UserTypeCodeIdforCO=@inp_sUserTypeCodeId) THEN 
						CASE WHEN t3.HardCopyReq = 0	OR t3.HardCopyReq IS NULL    THEN 'DONOTSHOW'
							WHEN t3.HardCopyReq = 1 AND t3.DateOfEvent is not null and t4.DateOfEvent IS NULL THEN @PendingStatus	
							ELSE NULL END
					ELSE
						CASE WHEN t8.DateOfEvent IS NULL THEN 'DONOTSHOW'  
							ELSE								
								CASE WHEN t3.HardCopyReq = 0	OR t3.HardCopyReq IS NULL    THEN 'DONOTSHOW'
								WHEN t3.HardCopyReq = 1 AND t3.DateOfEvent is not null and t4.DateOfEvent IS NULL THEN @PendingStatus	
								ELSE NULL END		
							END						
					END					
					AS TextHardCopyDate,
					
				   CASE WHEN (@UserTypeCodeIdforAdmin=@inp_sUserTypeCodeId OR @UserTypeCodeIdforCO=@inp_sUserTypeCodeId) THEN 
						CASE WHEN t4.HardCopyReq = 0 OR t4.HardCopyReq IS NULL THEN NULL
							WHEN t2.DateOfEvent IS NULL THEN NULL
							WHEN t3.DateOfEvent IS NULL THEN NULL
							WHEN t4.DateOfEvent IS NULL THEN NULL		
							ELSE t4.DateOfEvent	END 
					ELSE
						CASE WHEN t8.DateOfEvent IS NULL THEN NULL 
							ELSE								
								CASE WHEN t4.HardCopyReq = 0 OR t4.HardCopyReq IS NULL THEN NULL
								WHEN t2.DateOfEvent IS NULL THEN NULL
								WHEN t3.DateOfEvent IS NULL THEN NULL
								WHEN t4.DateOfEvent IS NULL THEN NULL		
								ELSE t4.DateOfEvent	END		
							END						
					END					
					AS HardCopyDate,		
					
					CASE WHEN (@UserTypeCodeIdforAdmin=@inp_sUserTypeCodeId OR @UserTypeCodeIdforCO=@inp_sUserTypeCodeId) THEN 
									CASE WHEN t3.HardCopyReq = 0 OR t3.HardCopyReq IS NULL    THEN ''							
									WHEN t3.HardCopyReq = 1 AND t3.DateOfEvent is not null and t4.DateOfEvent IS NULL THEN 154002		
									ELSE 154001	END
					ELSE
						CASE WHEN t8.DateOfEvent IS NULL THEN NULL 
							ELSE								
									CASE WHEN t3.HardCopyReq = 0 OR t3.HardCopyReq IS NULL    THEN ''							
									WHEN t3.HardCopyReq = 1 AND t3.DateOfEvent is not null and t4.DateOfEvent IS NULL THEN 154002		
									ELSE 154001	END	
							END						
						END					
					AS HardCopyStatus,
						
					CASE	WHEN t2.DateOfEvent IS NULL THEN 'DONOTSHOW'
							WHEN t3.DateOfEvent IS NULL THEN 'DONOTSHOW'
							WHEN t4.DateOfEvent IS NULL THEN 'DONOTSHOW'												
							ELSE NULL												END AS TextSubmitToStockExchange,
					CASE	WHEN t2.DateOfEvent IS NULL THEN NULL
							WHEN t3.DateOfEvent IS NULL THEN NULL
							WHEN t4.DateOfEvent IS NULL THEN NULL												
							ELSE t4.DateOfEvent										END AS SubmitToStockExchange,
					CASE	WHEN t2.DateOfEvent IS NULL THEN 154002
							WHEN t3.DateOfEvent IS NULL THEN 154002
							WHEN t4.DateOfEvent IS NULL THEN 154002												
							ELSE 154001												END AS SubmitToStockExchangeStatus,
							u.PAN AS UserPanNumber,				
					u.EmployeeId,
					0,
					U.UserTypeCodeId,
					'Employee',
					0,0,0
		FROM		usr_UserInfo u 
					LEFT JOIN @TempEventLog t1 ON t1.UserInfoId = u.UserInfoId and t1.EventType = 153006
					LEFT JOIN @TempEventLog t2 ON t2.UserInfoId = u.UserInfoId and t2.EventType = 153052 -- Initial Disclosure details entered
					LEFT JOIN @TempEventLog t3 ON t3.UserInfoId = u.UserInfoId and t3.EventType = 153054 -- Initial Disclosure submitted - softcopy
					LEFT JOIN @TempEventLog t4 ON t4.UserInfoId = u.UserInfoId and t4.EventType = 153055 -- Initial Disclosure submitted - hardcopy
					--LEFT JOIN @TempEventLog t5 ON t5.UserInfoId = u.UserInfoId and t5.EventType = 153012 -- Initial Disclosure - CO submitted hardcopy to Stock Exchange
					LEFT JOIN @TempEventLog t6 ON t6.UserInfoId = u.UserInfoId and t6.EventType = 0
					LEFT JOIN @TempEventLog t7 ON t7.UserInfoId = u.UserInfoId and t7.EventType = 153053 -- Initial Disclosure - Uploaded
					LEFT JOIN @TempEventLog t8 ON t8.UserInfoId = u.UserInfoId and t8.EventType = 153028 -- Initial Disclosure - Uploaded
					--LEFT JOIN @TempEventLog t8 ON t8.UserInfoId = u.UserInfoId and t8.EventType = @nConfirm_Personal_Details_Event
					LEFT JOIN com_Code c ON u.DesignationId = c.CodeID
					LEFT JOIN mst_Company company ON u.CompanyId = company.CompanyId
		where u.UserInfoId in(select DISTINCT UserInfoId from @TempEventLog)
		--where		((DateOfBecomingInsider IS NULL OR DateOfBecomingInsider > dbo.uf_com_GetServerDate()) AND UserTypeCodeId = 101003 and u.UserInfoId=8) OR u.DateOfBecomingInsider < dbo.uf_com_GetServerDate()
	
		
		
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
			JOIN eve_EventLog EL ON TM.TransactionMasterId = EL.MapToId AND MapToTypeCodeId = 132005 AND EventCodeId = 153053
		WHERE InitialDisclosureStatus = 154002
		
		UPDATE tUserData
			SET IsEnterAndUploadEvent = 1
		FROM #tUserData tUserData 
		JOIN eve_EventLog EL ON EL.MapToId = tUserData.TMID AND EL.MapToTypeCodeId = 132005
		AND EventCodeId = 153053
		WHERE InitialDisclosureStatus = 154001
		UPDATE tUserData SET ParentUserInfoID=@inp_sUserInfoId FROM #tUserData tUserData
		
		DECLARE @nDocumentCnt INT=0
		DECLARE @nWindowStatusCodeId_Active INT = 131002
		DECLARE @nEventTypeDocument INT = 0
		DECLARE @nTransactionMasterID INT = 0

		DECLARE @dtTodayDate	DATETIME = CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))	

		DECLARE @tmpInitialDisclosureTable TABLE(SequenceNumber INT identity(1,1), PolicyDocumentId INT, DocumentId INT,UserInfoId INT)

		INSERT INTO @tmpInitialDisclosureTable (
			PolicyDocumentId, DocumentId,UserInfoId )
		SELECT PD.PolicyDocumentId, D.DocumentId,apd.UserInfoId 
		FROM vw_ApplicablePolicyDocumentForUser APD JOIN rul_ApplicabilityMaster AM ON AM.ApplicabilityId = APD.ApplicabilityMstId
			JOIN rul_PolicyDocument PD ON AM.MapToId = PD.PolicyDocumentId
			LEFT JOIN com_DocumentObjectMapping DOM ON DOM.MapToTypeCodeId = AM.MapToTypeCodeId AND AM.MapToId = DOM.MapToId AND PurposeCodeId IS NULL
			LEFT JOIN com_Document D ON D.DocumentId = DOM.DocumentId
			LEFT JOIN eve_EventLog EL ON EL.UserInfoId = @inp_sUserInfoId AND EL.MapToTypeCodeId = AM.MapToTypeCodeId AND EL.MapToId = AM.MapToId
				AND ((PD.DocumentViewAgreeFlag = 1 AND EL.EventCodeId = 153028) OR (PD.DocumentViewAgreeFlag = 0 AND PD.DocumentViewFlag = 1 AND EL.EventCodeId = 153027))
		WHERE APD.UserInfoId = @inp_sUserInfoId
			AND WindowStatusCodeId = @nWindowStatusCodeId_Active
			AND (@dtTodayDate >= PD.ApplicableFrom AND (PD.ApplicableTo IS NULL OR PD.ApplicableTo >= @dtTodayDate))
			
			
		SELECT @nDocumentCnt=PolicyDocumentId FROM @tmpInitialDisclosureTable
		IF(@nDocumentCnt>0)
		BEGIN 
			DECLARE @nPolicyDocumentId INT=0
			DECLARE @nDocumentId INT=0
			SELECT @nPolicyDocumentId=PolicyDocumentId,@nDocumentId=DocumentId FROM @tmpInitialDisclosureTable
			UPDATE #tUserData SET PolicyDocumentId=@nPolicyDocumentId,DocumentId=@nDocumentId
		END
		
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'DESC '
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 't.InitialDisclosureDate '
		END 
		
		IF (@inp_sSortField  = 'dis_grd_52001' OR @inp_sSortField  = 'dis_grd_52002' OR @inp_sSortField  = 'dis_grd_52003' OR @inp_sSortField  = 'dis_grd_52004' OR @inp_sSortField  = 'dis_grd_52005')
		BEGIN 
			SELECT @inp_sSortField = 't.UserInfoId'
		END
		
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +', t.UserInfoId desc),t.UserInfoId'
		SELECT @sSQL = @sSQL + ' FROM eve_EventLog e RIGHT JOIN #tUserData t ON t.UserInfoId = e.UserInfoId'
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '
		
		EXEC (@sSQL)
		
		SELECT 
			tu.TMID						 AS TransactionMasterId,
			tu.UserInfoId				 AS UserInfoId,
			TU.UserTypeCodeId			 AS UserTypeCodeId,	
			CASE WHEN TU.UserTypeCodeId=101003 THEN 'Self & Relative' ELSE 'Relative' END AS dis_grd_52001,			 
			DocumentUploadStatus as dis_grd_52002,
			DocumentUploadStatus as DocumentUploadStatus,
			tu.InitialDisclosureDate	 As dis_grd_52003,			
			tu.TextEmailSentDate		 AS TextEmailSentDate,			
			tu.TextInitialDisclosureDate AS TextInitialDisclosureDate,			
			tu.TextSoftCopyDate			 AS TextSoftCopyDate,
			tu.SoftCopyDate				 As dis_grd_52004,
			tu.TextHardCopyDate			 As TextHardCopyDate,
			tu.HardCopyDate				 As dis_grd_52005,
			tu.TextSubmitToStockExchange As TextSubmitToStockExchange,			
			IsEnterAndUploadEvent AS IsEnterAndUploadEvent,
			FrmView,
			tu.PolicyDocumentId,
			tu.DocumentId,
			tu.ParentUserInfoID
		FROM #tmpList t
		JOIN #tUserData tu ON tu.UserInfoId  =  t.EntityID		
		WHERE 1 =1		
		AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		order by t.RowNumber
			
		DROP TABLE #tUserData
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COInitialDisclosure_LIST
	END CATCH
END
