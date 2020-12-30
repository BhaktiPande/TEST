IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_DashboardNotificationList')
DROP PROCEDURE [dbo].[st_cmu_DashboardNotificationList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to view Notification data on Dashboard.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		11-May-2015

Modification History:
Modified By		Modified On		Description
Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_cmu_DashboardNotificationList]	
	 @inp_nLoggedInUserId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	BEGIN TRY
		DECLARE @ncount INT = 0
		DECLARE @ERR_NOTIFICATIONDETAILS_LIST INT = 18036 -- Error occurred while fetching list of Notification.
		DECLARE @nDisplayAlertCode INT = 164001
		DECLARE @tmpNotificationQueue TABLE (Id INT IDENTITY(1,1),NotificationQueueId INT , RuleModeId INT, ModeCodeId INT, EventLogId INT, UserId INT,[Subject] NVARCHAR(MAX)
			,[Contents] NVARCHAR(MAX), ResponseStatusCodeId INT ,CreatedOn DATETIME,[NotificationTYPE] VARCHAR(50))
     
	 Declare @UserTypeCodeId int =0
	 select @UserTypeCodeId=UserTypeCodeId from usr_UserInfo where UserInfoId=@inp_nLoggedInUserId
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
			INSERT INTO @tmpNotificationQueue (NotificationQueueId,[Subject],[Contents],[NotificationTYPE])
				SELECT TOP 10 MAX ([NotificationQueueId] )
					  ,[Subject]
					  ,[Contents]
					  ,'CMU' AS  NotificationTYPE
				FROM cmu_NotificationQueue 
				WHERE case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else UserId end =case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else @inp_nLoggedInUserId  end
					AND ResponseStatusCodeId IS NULL
					AND ModeCodeId = 156002
					GROUP BY [Subject],[Contents]
					
			SELECT @ncount = COUNT(Id) FROM @tmpNotificationQueue
			
			IF @ncount < 10
			BEGIN
				INSERT INTO @tmpNotificationQueue (NotificationQueueId,[Subject],[Contents],[NotificationTYPE])
				SELECT TOP 10 MAX ([NotificationQueueId] )
					 
					  ,[Subject]
					  ,[Contents]
					  ,'CMU' AS  NotificationTYPE
				FROM cmu_NotificationQueue 
				WHERE case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else UserId end =case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else @inp_nLoggedInUserId  end
					AND ResponseStatusCodeId IS NOT NULL
					AND ModeCodeId = 156002
					GROUP BY [Subject],[Contents]
					UNION

					SELECT TOP 10  MAX ([NotificationId])  as NotificationQueueId
					  ,[Subject]
					  ,'' AS [Contents]
					  ,'ONTHEFLY' AS  NotificationTYPE
				FROM cmu_NotificationOntheFly 
				WHERE case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else UserId end =case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else @inp_nLoggedInUserId  end
					AND ResponseStatusCodeId IS NOT NULL
					GROUP BY [Subject],UserId
			END
			INSERT INTO @tmpNotificationQueue (NotificationQueueId,[Subject],[Contents],[NotificationTYPE])
			SELECT TOP 10  MAX ([NotificationId])  as NotificationQueueId
					  ,[Subject]
					  ,'' AS [Contents]
					  ,'ONTHEFLY' AS  NotificationTYPE
				FROM cmu_NotificationOntheFly 
				WHERE case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else UserId end =case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else @inp_nLoggedInUserId  end
					AND ResponseStatusCodeId IS NOT NULL
					GROUP BY [Subject],UserId

			SELECT * FROM 
				(
					SELECT  TOP 10 NQ.NotificationQueueId AS NotificationQueueId
						,CASE WHEN NQ.[Subject] IS NULL OR NQ.[Subject] = '' THEN NQ.Contents ELSE NQ.[Subject] END AS Contents
						, CNQ.ModeCodeId AS ModeCodeId
						,CNQ.RuleModeId
						,CNQ.CreatedOn
						,NotificationTYPE
					FROM @tmpNotificationQueue NQ
					INNER JOIN cmu_NotificationQueue CNQ ON NQ.NotificationQueueId = CNQ.NotificationQueueId  and NQ.NotificationTYPE='CMU'
					order by CNQ.CreatedOn desc
				)tb1

				UNION
			SELECT * FROM 
				(
					SELECT  TOP 10 NQ.NotificationQueueId AS NotificationQueueId
						,CASE WHEN NQ.[Subject] IS NULL OR NQ.[Subject] = '' THEN NQ.Contents ELSE NQ.[Subject] END AS Contents
						, 0 AS ModeCodeId
						,0 AS RuleModeId
						,CNQ.CreatedOn
						,NotificationTYPE
					FROM @tmpNotificationQueue NQ
					INNER JOIN cmu_NotificationOntheFly CNQ ON NQ.NotificationQueueId = CNQ.NotificationId and NQ.NotificationTYPE='ONTHEFLY'
						order by CNQ.CreatedOn desc
				)tb2 order by CreatedOn desc

			RETURN 0
			
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_NOTIFICATIONDETAILS_LIST
	END CATCH
END
