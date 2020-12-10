IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_NotificationAlertList')
DROP PROCEDURE [dbo].[st_cmu_NotificationAlertList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Notification of Alert data.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		11-May-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	16-May-2015		Changes in Join.
Gaurishankar	06-Jul-2015		Added param @inp_sCalledFrom to display the Notification records for popup or ALERT also Update the status of displayed records 
Gaurishankar	06-Jul-2015		Removed the CreatedOn form SELECT Field
Gaurishankar	06-Jul-2015		Aded RuleModeId for select
Gaurishankar	07-Jul-2015		Added Param for Notification count When called from "ALERTCOUNT"
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_cmu_NotificationAlertList]	
	 @inp_nLoggedInUserId			INT
	,@inp_sCalledFrom				VARCHAR(100) = 'ALERT'
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sCode NVARCHAR(100) = ''
	DECLARE @ERR_NOTIFICATIONDETAILS_LIST INT = 18036 -- Error occurred while fetching list of Notification.
	DECLARE @nDisplayAlertCode INT = 164001
	DECLARE @tmpNotificationQueue TABLE (Id INT IDENTITY(1,1),NotificationQueueId INT , RuleModeId INT, ModeCodeId INT, EventLogId INT, UserId INT,[Subject] NVARCHAR(150)
      ,[Contents] NVARCHAR(MAX), ResponseStatusCodeId INT ,CreatedOn DATETIME)
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT @sCode = [Description] FROM com_Code WHERE CodeID = @nDisplayAlertCode
		IF(@inp_sCalledFrom = 'ALERT')
		BEGIN
			
			INSERT INTO @tmpNotificationQueue
				SELECT [NotificationQueueId]
					  ,[RuleModeId]
					  ,[ModeCodeId]
					  ,[EventLogId]
					  ,[UserId]
					  ,[Subject]
					  ,[Contents]
					  ,[ResponseStatusCodeId]
					  ,CreatedOn
				FROM cmu_NotificationQueue 
				WHERE UserId = @inp_nLoggedInUserId 					
					AND ModeCodeId in (SELECT items FROM dbo.uf_com_Split(@sCode))
					ORDER BY CreatedOn DESC
		END
		ELSE IF (@inp_sCalledFrom = 'POPUP')
		BEGIN
			INSERT INTO @tmpNotificationQueue
				SELECT [NotificationQueueId]
					  ,[RuleModeId]
					  ,[ModeCodeId]
					  ,[EventLogId]
					  ,[UserId]
					  ,[Subject]
					  ,[Contents]
					  ,[ResponseStatusCodeId]
					  ,CreatedOn
				FROM cmu_NotificationQueue 
				WHERE UserId = @inp_nLoggedInUserId 
					AND ResponseStatusCodeId IS NULL
					AND ModeCodeId = 156005
					ORDER BY CreatedOn DESC
		END
		ELSE IF (@inp_sCalledFrom = 'ALERTCOUNT')
		BEGIN
			
			SELECT 0 AS NotificationQueueId , Count([NotificationQueueId]) AS AlertCount
					
				FROM cmu_NotificationQueue 
				WHERE UserId = @inp_nLoggedInUserId 
					AND ResponseStatusCodeId IS NULL
					AND ModeCodeId in (SELECT items FROM dbo.uf_com_Split(@sCode))
			RETURN 0
		END
		UPDATE NQ
		SET NQ.ResponseStatusCodeId = 161001
			,NQ.ResponseMessage = ''
			,NQ.ModifiedBy = @inp_nLoggedInUserId
			,NQ.ModifiedOn = dbo.uf_com_GetServerDate()
		FROM cmu_NotificationQueue NQ
		INNER JOIN @tmpNotificationQueue TNQ ON NQ.NotificationQueueId = TNQ.NotificationQueueId
		WHERE NQ.ResponseStatusCodeId IS NULL
		
		SELECT  MAX(NQ.NotificationQueueId) AS NotificationQueueId
				,CASE WHEN NQ.[Subject] IS NULL OR NQ.[Subject] = '' THEN NQ.Contents ELSE NQ.[Subject] END AS Contents
				, NQ.ModeCodeId AS ModeCodeId
				,NQ.RuleModeId
				--,CASE WHEN CModeCode.DisplayCode IS NULL THEN CModeCode.CodeName ELSE CModeCode.DisplayCode END  AS ModeCodeName
				--,NQ.CreatedOn
		FROM @tmpNotificationQueue NQ
				INNER JOIN com_Code CModeCode ON CModeCode.CodeID = NQ.ModeCodeId
		GROUP BY  RuleModeId,ModeCodeId,Contents,[Subject]

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_NOTIFICATIONDETAILS_LIST
	END CATCH
END
