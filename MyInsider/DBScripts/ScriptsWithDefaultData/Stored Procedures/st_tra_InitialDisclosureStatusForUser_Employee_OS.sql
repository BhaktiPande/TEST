IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_InitialDisclosureStatusForUser_Employee_OS')
DROP PROCEDURE [st_tra_InitialDisclosureStatusForUser_Employee_OS]
GO
/****** Object:  StoredProcedure [dbo].[st_tra_InitialDisclosureStatusForUser]    Script Date: 4/15/2019 2:09:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
THIS PROCDURE IS FOR EMPLOYEE
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_InitialDisclosureStatusForUser_Employee_OS] --522
	@inp_iUserInfoID				INT
	,@inp_iUserTypeID				INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS


CREATE TABLE #tmpUsrInitialdata
(
ID int identity(1,1),
SequenceNumber int,
PolicyDocumentId int,
DocumentId int,
EventName nvarchar(max),
StatusFlag int,
ResourceKey varchar(20),
TransactionMasterId int,
EventCode int,
EventDate datetime,
PolicyDocumentView int,
PolicyDocumentAgree int,
EventType int,
IsEnterAndUploadEvent int,
UserInfoID INT,
UserTypeCodeID INT,
ParentUserInfoID INT
)

create table #tmpUserInfoId
(
ID int identity(1,1),
UserInfoId int
)
		DECLARE @UserInfoid TABLE (UsrID int)

		INSERT INTO @UserInfoid
		SELECT UsrId.UserInfoId FROM
		(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId=@inp_iUserInfoID
		UNION
		SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoId=@inp_iUserInfoID) UsrId        

		DECLARE @dtDateofBecomingInsider datetime
		SELECT @dtDateofBecomingInsider=DateOfBecomingInsider FROM usr_UserInfo WHERE UserInfoId=@inp_iUserInfoID 

		INSERT INTO #tmpUserInfoId(UserInfoId)

		SELECT   DISTINCT   e.UserInfoId                 
		FROM  eve_EventLog e WHERE       (
		 e.EventCodeId = 153052 or e.EventCodeId = 153053 or e.EventCodeId = 153054 
		or e.EventCodeId = 153055 OR e.EventCodeId = 153043) 
		AND (CONVERT(DATETIME,E.EventDate)<=CONVERT(DATETIME,@dtDateofBecomingInsider) OR @dtDateofBecomingInsider IS NULL)
		AND UserInfoId IN (select UsrID from @UserInfoid)
		GROUP BY e.UserInfoId	
		
		IF(@dtDateofBecomingInsider IS NULL)
		BEGIN
			DECLARE @checkTransId INT
			Create table #tmpTrans
			(
			ID int identity(1,1),
			TransMasterId int
			)
			Insert into #tmpTrans
			select TransactionMasterId from tra_TransactionMaster_OS where UserInfoId IN (select UsrID from @UserInfoid)
			and DisclosureTypeCodeId=147001 AND TransactionStatusCodeId IN(148003,148004,148007)

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
				 --JOIN usr_DMATDetails UDMAT ON URI.UserInfoIdRelative=UDMAT.UserInfoID 
				 where URI.UserInfoIdRelative not in(
				select tra_TransactionDetails_OS.ForUserInfoId from tra_TransactionDetails_OS where TransactionMasterId in(select TransMasterId from #tmpTrans)
				) and URI.UserInfoId=@inp_iUserInfoID AND UI.StatusCodeId=102001
			END
			
				INSERT INTO #tmpUserInfoId(UserInfoId)
				SELECT DISTINCT UserInfoIdRelative FROM #tmpExcludedRel WHERE UserInfoIdRelative NOT IN( SELECT UserInfoId FROM #tmpUserInfoId)
			DROP TABLE #tmpExcludedRel
			DROP TABLE #tmpTrans
		END

		DECLARE @nUserCnt INT=0

		SELECT @nUserCnt=COUNT(UserInfoId) FROM #tmpUserInfoId
		IF(@nUserCnt=0 AND @dtDateofBecomingInsider IS NULL)
		BEGIN
		INSERT INTO #tmpUserInfoId(UserInfoId)
		VALUES(@inp_iUserInfoID)
		END
	
		DECLARE @nCount INT=0
		DECLARE @nTotCount INT=0
		SELECT @nTotCount=COUNT(ID) FROM #tmpUserInfoId
		WHILE @nCount<@nTotCount
		BEGIN
		DECLARE @nUserInfoId int=0
		SELECT @nUserInfoId=UserInfoId FROM #tmpUserInfoId WHERE ID=@nCount+1
		INSERT INTO #tmpUsrInitialdata
		EXEC st_tra_InitialDisclosureStatusListFor_Employee_OS @nUserInfoId,@inp_iUserTypeID,@out_nReturnValue OUTPUT		
		SET @nCount=@nCount+1

		END
		SELECT * FROM #tmpUsrInitialdata		
		DROP TABLE #tmpUserInfoId
		drop table #tmpUsrInitialdata	
		IF(@out_nReturnValue IS NULL)
		BEGIN
		SET @out_nReturnValue=0
		END		
		RETURN @out_nReturnValue