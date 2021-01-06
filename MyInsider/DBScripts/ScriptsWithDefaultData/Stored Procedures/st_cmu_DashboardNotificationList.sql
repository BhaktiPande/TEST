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
			
			INSERT INTO @tmpNotificationQueue (NotificationQueueId,RuleModeId,ModeCodeId,[Subject],[Contents],CreatedOn,[NotificationTYPE])
				SELECT TOP 10 [NotificationQueueId],
						RuleModeId,ModeCodeId
					  ,[Subject]
					  ,[Contents]
					  ,CreatedOn
					  ,'CMU' AS  NotificationTYPE
				FROM cmu_NotificationQueue 
				WHERE case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else UserId end =case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else @inp_nLoggedInUserId  end
					AND ResponseStatusCodeId IS NULL
					AND ModeCodeId = 156002
					ORDER BY NotificationQueueId DESC
					--GROUP BY [Subject],[Contents]
					
			SELECT @ncount = COUNT(Id) FROM @tmpNotificationQueue
			
			IF @ncount < 10
			BEGIN
				INSERT INTO @tmpNotificationQueue (NotificationQueueId,RuleModeId,ModeCodeId,[Subject],[Contents],CreatedOn,[NotificationTYPE])
				SELECT TOP 10 [NotificationQueueId], 
					 RuleModeId,ModeCodeId
					  ,[Subject]
					  ,[Contents]
					  ,CreatedOn
					  ,'CMU' AS  NotificationTYPE
				FROM cmu_NotificationQueue 
				WHERE case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else UserId end =case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else @inp_nLoggedInUserId  end
					AND ResponseStatusCodeId IS NOT NULL
					AND ModeCodeId = 156002
					ORDER BY NotificationQueueId DESC
					--GROUP BY [Subject],[Contents]
			END
			INSERT INTO @tmpNotificationQueue (NotificationQueueId,RuleModeId,ModeCodeId,[Subject],[Contents],CreatedOn,[NotificationTYPE])
			SELECT TOP 10  [NotificationId]  as NotificationQueueId
						, 0 ,0
					  ,[Subject]
					  ,'' AS [Contents]
					  ,CreatedOn
					  ,'ONTHEFLY' AS  NotificationTYPE
				FROM cmu_NotificationOntheFly 
				WHERE case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else UserId end =case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else @inp_nLoggedInUserId  end
					AND ResponseStatusCodeId IS NOT NULL
					ORDER BY NotificationQueueId DESC
					--GROUP BY [Subject],UserId

			SELECT NotificationQueueId, CASE WHEN [Subject] IS NULL OR [Subject] = '' THEN Contents ELSE [Subject] END AS Contents,
					ModeCodeId,RuleModeId,CreatedOn,NotificationTYPE 
			FROM @tmpNotificationQueue
			ORDER BY CreatedOn DESC

			RETURN 0
			
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_NOTIFICATIONDETAILS_LIST
	END CATCH
END
