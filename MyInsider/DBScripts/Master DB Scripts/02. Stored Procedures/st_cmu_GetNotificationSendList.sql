/******************************************************************************************************************
Description:	Routine to get list of notifications to send from table cmu_NotificationQueue which are of type Email/SMS 
				with ResponseStatusCodeId as NULL or Failure.

Returns:		
				
Created by:		Ashashree
Created on:		04-Jun-2015

Modification History:
Modified By		Modified On		Description
Tushar			30-Jul-2015		Email Attachment Change.
Tushar			20-Nov-2015		Failure notification doesnot fetch for sending mails.

****************************************************************************************************************/
/*Drop procedure if already exists and then run the CREATE script*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_cmu_GetNotificationSendList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_cmu_GetNotificationSendList]
GO

CREATE PROCEDURE [dbo].[st_cmu_GetNotificationSendList]
				 @inp_nCompanyId INT = 0,
				 @out_nReturnValue	INT = 0 OUTPUT,
				 @out_nSQLErrCode	INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
				 @out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @sLinkedServerName VARCHAR(50)
	DECLARE @sCatalogName VARCHAR(200)
	DECLARE @nRecordCount INT = 10
	
	DECLARE @sSQL VARCHAR(MAX)
	
	DECLARE @nNotificationStatusFailure INT = 161002
	DECLARE @nModeCodeIdEmail INT = 156002
	DECLARE @nModeCodeIdSMS INT = 156003
	
	DECLARE @ERR_COMPANY_NOT_FOUND INT = 10001
	DECLARE @ERR_COMPANY_LINKED_SERVERNAME_NOT_FOUND INT = 10008
	DECLARE @ERR_COMPANY_DATABASENAME_NOT_FOUND INT = 10009
	DECLARE @ERR_GET_NOTIFICATION_SEND_LIST INT = 10007
		
	BEGIN TRY
	
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF @inp_nCompanyId IS NULL
			SET @inp_nCompanyId = 0
	
		IF(EXISTS(SELECT CompanyName FROM Companies WHERE CompanyId = @inp_nCompanyId ))
		BEGIN

			SELECT @sLinkedServerName = LinkedServerName, @sCatalogName = ConnectionDatabaseName FROM Companies WHERE CompanyId = @inp_nCompanyId
			
			IF(@sLinkedServerName IS NULL OR RTRIM(LTRIM(@sLinkedServerName)) = '') --Linked servername not found for Company within Companies table
			BEGIN
				SET @out_nReturnValue	=  @ERR_COMPANY_LINKED_SERVERNAME_NOT_FOUND
				RETURN @out_nReturnValue
			END
			
			IF(@sCatalogName IS NULL OR LTRIM(RTRIM(@sCatalogName)) = '')
			BEGIN
				SET @out_nReturnValue = @ERR_COMPANY_DATABASENAME_NOT_FOUND
			RETURN @out_nReturnValue
			END
			
			
			SELECT @sSQL = ''
			SELECT @sSQL = 'SELECT TOP ' + CAST(@nRecordCount AS VARCHAR(10)) + ' NQ.NotificationQueueId,NQ.CommunicationFrom,NQ.CompanyIdentifierCodeId,
							NQ.RuleModeId,NQ.ModeCodeId,NQ.EventLogId,NQ.UserContactInfo,NQ.Subject,NQ.UserId,NQ.Contents,NQ.Signature, '
			SELECT @sSQL = @sSQL + 'STUFF((SELECT '','' + NDR.DocumentPath
									FROM [' + @sLinkedServerName +'].[' + @sCatalogName + '].dbo.cmu_NotificationDocReference NDR 
									WHERE NDR.NotificationQueueId = nq.NotificationQueueId
									FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''') AS DocumentPath, '
			SELECT @sSQL = @sSQL + 'STUFF((SELECT '','' + NDR.DocumentName
									FROM [' + @sLinkedServerName +'].[' + @sCatalogName + '].dbo.cmu_NotificationDocReference NDR 
									WHERE NDR.NotificationQueueId = nq.NotificationQueueId
									FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''') AS DocumentName '
			SELECT @sSQL = @sSQL + ' FROM [' + @sLinkedServerName +'].[' + @sCatalogName + '].dbo.cmu_NotificationQueue NQ '
			
			SELECT @sSQL = @sSQL + ' WHERE (NQ.ResponseStatusCodeId IS NULL )' -- OR NQ.ResponseStatusCodeId = ' + CAST(@nNotificationStatusFailure AS VARCHAR(10)) + ') '
			
			--SELECT @sSQL = @sSQL + ' AND (CRMM.ModeCodeId = ' + CAST(@nModeCodeIdEmail AS VARCHAR(10)) + ' OR CRMM.ModeCodeId = ' + CAST(@nModeCodeIdSMS AS VARCHAR(10)) + ') '
			SELECT @sSQL = @sSQL + ' AND (NQ.ModeCodeId = ' + CAST(@nModeCodeIdEmail AS VARCHAR(10)) + ' OR NQ.ModeCodeId = ' + CAST(@nModeCodeIdSMS AS VARCHAR(10)) + ') '
			
			--Start : Add this line when the notification will be pulled onto master database server, because at this time, only the notifications of companyId should get fetched from the common notification queue
			--SELECT @sSQL = @sSQL + ' AND NQ.CompanyIdentifierCodeId = ' + CAST(@inp_nCompanyId AS VARCHAR(10))
			--End : Add this line when the notification will be pulled onto master database server, because at this time, only the notifications of companyId should get fetched from the common notification queue
			
			SELECT @sSQL = @sSQL + ' GROUP BY nq.NotificationQueueId,nq.CommunicationFrom,NQ.CompanyIdentifierCodeId,NQ.RuleModeId, NQ.ModeCodeId,
									NQ.EventLogId,NQ.UserContactInfo,NQ.Subject,NQ.UserId,NQ.Contents,NQ.Signature '
			
			--print @sSQL
			EXEC(@sSQL)
			
			SELECT @out_nReturnValue = 0
			RETURN @out_nReturnValue
			
			
		END
		ELSE --Company record not found for CompanyId
		BEGIN
			SET @out_nReturnValue	=  @ERR_COMPANY_NOT_FOUND
			RETURN @out_nReturnValue
		END
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_GET_NOTIFICATION_SEND_LIST
		RETURN @out_nReturnValue
	END CATCH
END
