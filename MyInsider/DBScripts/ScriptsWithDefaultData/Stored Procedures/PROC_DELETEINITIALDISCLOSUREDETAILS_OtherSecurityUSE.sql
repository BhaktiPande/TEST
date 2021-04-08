IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'PROC_DELETEINITIALDISCLOSUREDETAILS_OtherSecurityUSE')
DROP PROCEDURE [dbo].[PROC_DELETEINITIALDISCLOSUREDETAILS_OtherSecurityUSE]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================================================================
-- Author			: Aniket Shingate																	=
-- Created date		: 15-JAN-2018                                                 						=
-- Description		: THIS PROCEDURE USED FOR DEPARTMENT, DESIGNATION & GRADE WISE Mass-Upload			=

-- Modified By	  Modified On		Description

-- ======================================================================================================
CREATE PROCEDURE [dbo].[PROC_DELETEINITIALDISCLOSUREDETAILS_OtherSecurityUSE]
@inp_UserinfoID		INT       
AS
BEGIN
		IF EXISTS(SELECT 1 FROM tra_BalancePool_OS WHERE UserInfoId = @inp_UserinfoID)
		BEGIN		
			DELETE tra_BalancePool_OS WHERE UserInfoId = @inp_UserinfoID
		END
		
		IF EXISTS(SELECT 1 FROM tra_TransactionSummaryDMATWise_OS WHERE UserInfoId = @inp_UserinfoID)
		BEGIN		
			DELETE tra_TransactionSummaryDMATWise_OS WHERE UserInfoId = @inp_UserinfoID
		END
		
		IF EXISTS(SELECT 1 FROM tra_TransactionDetails_OS WHERE ForUserInfoId = @inp_UserinfoID)
		BEGIN
			IF EXISTS(SELECT UserInfoIdRelative FROM usr_UserRelation WHERE userinfoid = @inp_UserinfoID)
			BEGIN
			PRINT 'H'
				DECLARE @MIN INT, @MAX INT
				create table #Relativ (Id INT IDENTITY(1,1), RelativId INT)
				insert into #Relativ
				SELECT UserInfoIdRelative FROM usr_UserRelation WHERE userinfoid = @inp_UserinfoID

				SELECT @MIN = MIN(Id), @MAX=MAX(Id) FROM #Relativ
				WHILE @MIN <= @MAX
				BEGIN
					DECLARE @URelationId INT
					SET @URelationId = (SELECT RelativId FROM #Relativ WHERE Id = @MIN)
				
					IF EXISTS(SELECT 1 FROM tra_TransactionDetails_OS WHERE ForUserInfoId = @URelationId)
					BEGIN
					PRINT 'G'
						DELETE tra_TransactionDetails_OS WHERE ForUserInfoId = @URelationId
					END
					SET @MIN = @MIN + 1
				END
				DROP TABLE #Relativ
			END
			DELETE tra_TransactionDetails_OS WHERE ForUserInfoId = @inp_UserinfoID
		END

		IF EXISTS(SELECT 1 FROM rpt_DefaulterReport_OS WHERE UserInfoId = @inp_UserinfoID)
		BEGIN
			DELETE rpt_DefaulterReport_OS WHERE UserInfoId = @inp_UserinfoID
		END

		IF EXISTS(SELECT 1 FROM tra_PreclearanceRequest_NonImplementationCompany WHERE UserInfoId = @inp_UserinfoID)
		BEGIN
			DELETE tra_PreclearanceRequest_NonImplementationCompany WHERE UserInfoId = @inp_UserinfoID
		END

		IF EXISTS(SELECT 1 FROM tra_TransactionMaster_OS WHERE UserInfoId = @inp_UserinfoID)
		BEGIN
			DELETE tra_TransactionMaster_OS WHERE DisclosureTypeCodeId <> 147003 and UserInfoId = @inp_UserinfoID
		END

		IF EXISTS(SELECT 1 FROM tra_TransactionMaster_OS WHERE UserInfoId = @inp_UserinfoID)
		BEGIN
			delete NotificationQue from cmu_NotificationQueue NotificationQue
			INNER JOIN eve_EventLog evnt ON NotificationQue.EventLogId = evnt.EventLogId
			WHERE NotificationQue.UserId = @inp_UserinfoID and evnt.EventCodeId IN (153067,153066,153065,153064,153063,153052,153053,153054,153055,153056,153057,153058,153059,153060,153061,153062)
		END				
		
		IF EXISTS(SELECT 1 FROM eve_EventLog WHERE UserInfoId = @inp_UserinfoID AND EventCodeId IN (153067,153066,153065,153064,153063,153052,153053,153054,153055,153056,153057,153058,153059,153060,153061,153062))
		BEGIN
			delete eve_EventLog WHERE UserInfoId = @inp_UserinfoID AND EventCodeId IN (153067,153066,153065,153064,153063,153052,153053,153054,153055,153056,153057,153058,153059,153060,153061,153062)
		END
END