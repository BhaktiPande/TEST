/******************************************************************************************************************
Description:	Routine to update the response status for each notification sent by webservice of type Email / SMS notifications.
				This procedure currently performs the update to the 'cmu_NotificationQueue' table by using linked server within the UPDATE query and by using OPENQUERY for linked server update.
				This is a remote server UPDATE query execution wherein this procedure gets called from master database and the UPDATE within this procedure is executed onto the company database on remote server.
Returns:		
				
Created by:		Ashashree
Created on:		05-Jun-2015

Modification History:
Modified By			Modified On			Description
Raghvendra/Tushar	13-July-2016		Change to increase the size when converting the notificationqueueid from bigint to varchar 
Tushar				20-Oct-2016			Update ModifiedBy & ModifiedOn Date when response update.
****************************************************************************************************************/
/*Drop procedure if already exists and then run the CREATE script*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_cmu_UpdateNotificationResponse]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_cmu_UpdateNotificationResponse]
GO

CREATE PROCEDURE [dbo].[st_cmu_UpdateNotificationResponse]
				 @inp_nCompanyId INT = 0,
				 @inp_tblNotificationQueueResponse NotificationQueueResponse READONLY,
				 @out_nReturnValue	INT = 0 OUTPUT,
				 @out_nSQLErrCode	INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
				 @out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @ERR_UPDATE_NOTIFICATION_RESPONSE INT = 10010
	DECLARE @ERR_COMPANY_NOT_FOUND INT = 10001
	DECLARE @ERR_COMPANY_LINKED_SERVERNAME_NOT_FOUND INT = 10008
	DECLARE @ERR_COMPANY_DATABASENAME_NOT_FOUND INT = 10009
	
	DECLARE @ntblNotificationQueueResponseCount INT = 0
	DECLARE @nCounter INT = 0
	
	DECLARE @nRowId INT
	DECLARE @nNotificationQueueId INT
	DECLARE @nCompanyIdentifierCodeId INT
	DECLARE @nResponseStatusCodeId INT
	DECLARE @sResponseMessage NVARCHAR(200)
	
	DECLARE @sLinkedServerName VARCHAR(50)
	DECLARE @sCatalogName VARCHAR(200)
	DECLARE @bIsDatabaseServerRemote BIT
	DECLARE @sConnectionUserName VARCHAR(200) 
	
	DECLARE @sSQL VARCHAR(MAX)
	
	BEGIN TRY

		IF(@inp_nCompanyId IS NOT NULL AND @inp_nCompanyId > 0) --Update the NotificationQueue on specific company identified by CompanyId
		BEGIN
			IF(NOT EXISTS(SELECT CompanyName FROM Companies WHERE CompanyId = @inp_nCompanyId )) --Company for CompanyId not found within Companies table
			BEGIN
				SET @out_nReturnValue = @ERR_COMPANY_NOT_FOUND
				RETURN @out_nReturnValue
			END
			ELSE
			BEGIN
				--Fetch the linked server name and database name for the company identified by @inp_nCompanyId
				SELECT @sLinkedServerName = LinkedServerName, @sCatalogName = ConnectionDatabaseName, 
					   @bIsDatabaseServerRemote = IsDatabaseServerRemote, @sConnectionUserName = ConnectionUserName
				FROM Companies 
				WHERE CompanyId = @inp_nCompanyId
				
				--SELECT @bIsDatabaseServerRemote AS IsDatabaseServerRemote
				
				IF(@sLinkedServerName IS NULL OR LTRIM(RTRIM(@sLinkedServerName)) = '')
				BEGIN
					SET @out_nReturnValue = @ERR_COMPANY_LINKED_SERVERNAME_NOT_FOUND
					RETURN @out_nReturnValue
				END
				
				IF(@sCatalogName IS NULL OR LTRIM(RTRIM(@sCatalogName)) = '')
				BEGIN
					SET @out_nReturnValue = @ERR_COMPANY_DATABASENAME_NOT_FOUND
					RETURN @out_nReturnValue
				END
				
				
				IF(@bIsDatabaseServerRemote = 1) --If company database is remotely stored then perform update by using distributed transaction coordinator
				BEGIN
					print 'update notification status to remote database using distributed transaction UPDATE query'
					SELECT @ntblNotificationQueueResponseCount = ISNULL(COUNT(NotificationQueueId),0) FROM @inp_tblNotificationQueueResponse
					--For each combination of NotificationQueueId--CompanyIdentifierCodeId, update the ResponseStatusCodeId and ResponseMessage for that corresponding record
					WHILE(@nCounter < @ntblNotificationQueueResponseCount)
					BEGIN
						SELECT @nCounter = @nCounter + 1
						--Fetch a record for response status update from the input table type
						SELECT @nRowId = RowId, @nNotificationQueueId = NotificationQueueId, 
						@nCompanyIdentifierCodeId = CompanyIdentifierCodeId, @nResponseStatusCodeId = ResponseStatusCodeId,
						@sResponseMessage = ResponseMessage
						FROM @inp_tblNotificationQueueResponse WHERE RowId = @nCounter
						
						--Variable XACT_ABORT is OFF by default. 
						--Set this variable to ON so that if any SQL error occurrs then the SQL server rollbacks the batch transaction. 
						--If this variable is kept as OFF and UPDATE query is executed then, 
						--the remote UPDATE via linked server usage does not take place.
						--Error is thrown as "Unable to start a nested transaction for OLE DB provider "SQLNCLI10" for linked server "LNKSRV_KPCS_FOR_COMPANY_ID_1". A nested transaction was required because the XACT_ABORT option was set to OFF."
						SET XACT_ABORT ON
						--Update query here to update ResponseStatuscode and ResponseMessage - use LinkedServerName for update
						SELECT @sSQL = ''
						SELECT @sSQL = 'UPDATE '
						SELECT @sSQL = @sSQL + ' OPENQUERY ([' + @sLinkedServerName + '], ''SELECT ResponseStatusCodeId, ResponseMessage FROM [' + @sCatalogName + '].dbo.cmu_NotificationQueue NQ '
						SELECT @sSQL = @sSQL + ' WHERE NQ.NotificationQueueId = '+ CAST(@nNotificationQueueId AS VARCHAR(MAX)) 
						SELECT @sSQL = @sSQL + CASE WHEN @nCompanyIdentifierCodeId IS NULL THEN ' AND CompanyIdentifierCodeId IS NULL ' ELSE ' AND CompanyIdentifierCodeId = ' + CAST(@nCompanyIdentifierCodeId AS VARCHAR(10)) + ' ' END
						SELECT @sSQL = @sSQL + ' '') ' --End of OPENQUERY
						SELECT @sSQL = @sSQL + ' SET ResponseStatusCodeId = '+ CAST(@nResponseStatusCodeId AS VARCHAR(10)) 
						SELECT @sSQL = @sSQL + '   ,ModifiedBy = 1 '
						SELECT @sSQL = @sSQL + '   ,ModifiedOn = GETDATE() '
						SELECT @sSQL = @sSQL + CASE WHEN @sResponseMessage IS NOT NULL THEN ' , ResponseMessage = '''+ REPLACE(@sResponseMessage, '''', '''''') +''' ' ELSE ' , ResponseMessage = NULL ' END
						
						--print @sSQL
						EXEC(@sSQL)
						
						--Reset the variable XACT_ABORT back to its default value
						SET XACT_ABORT OFF
					END
				END --If company database is remotely stored then perform update by using distributed transaction coordinator
				ELSE
				BEGIN
					print 'update notification status to local database using normal UPDATE query'
					
					SELECT @ntblNotificationQueueResponseCount = ISNULL(COUNT(NotificationQueueId),0) FROM @inp_tblNotificationQueueResponse
					--For each combination of NotificationQueueId--CompanyIdentifierCodeId, update the ResponseStatusCodeId and ResponseMessage for that corresponding record
					WHILE(@nCounter < @ntblNotificationQueueResponseCount)
					BEGIN
						SELECT @nCounter = @nCounter + 1
						--Fetch a record for response status update from the input table type
						SELECT @nRowId = RowId, @nNotificationQueueId = NotificationQueueId, 
						@nCompanyIdentifierCodeId = CompanyIdentifierCodeId, @nResponseStatusCodeId = ResponseStatusCodeId,
						@sResponseMessage = ResponseMessage
						FROM @inp_tblNotificationQueueResponse WHERE RowId = @nCounter
						
						--Update query here to update ResponseStatuscode and ResponseMessage - use LinkedServerName for update
						SELECT @sSQL = ''
						SELECT @sSQL = 'UPDATE [' + @sCatalogName + '].dbo.cmu_NotificationQueue ' 
						SELECT @sSQL = @sSQL + ' SET ResponseStatusCodeId = ' + CAST(@nResponseStatusCodeId AS VARCHAR(10))  
						SELECT @sSQL = @sSQL + '   ,ModifiedBy = 1 '
						SELECT @sSQL = @sSQL + '   ,ModifiedOn = GETDATE() '
						SELECT @sSQL = @sSQL + CASE WHEN @sResponseMessage IS NOT NULL THEN ' , ResponseMessage = '''+ REPLACE(@sResponseMessage, '''', '''''') +''' ' ELSE ' , ResponseMessage = NULL ' END
						SELECT @sSQL = @sSQL + ' WHERE NotificationQueueId = '+ CAST(@nNotificationQueueId AS VARCHAR(MAX)) 
						SELECT @sSQL = @sSQL + CASE WHEN @nCompanyIdentifierCodeId IS NULL THEN ' AND CompanyIdentifierCodeId IS NULL ' ELSE ' AND CompanyIdentifierCodeId = ' + CAST(@nCompanyIdentifierCodeId AS VARCHAR(10)) + ' ' END		
											
						--print @sSQL
						
						SELECT @sSQL = 'EXEC( '' ' + REPLACE(@sSQL, '''', '''''') + ' '' ) AS LOGIN = ''' + @sConnectionUserName + ''' '
						print @sSQL
						EXEC(@sSQL)

					END --WHILE(@nCounter < @ntblNotificationQueueResponseCount)
				END --IF(@bIsDatabaseServerRemote = 0)
			END
		END
		ELSE
		BEGIN
			SET @out_nReturnValue = @ERR_COMPANY_NOT_FOUND
			RETURN @out_nReturnValue
		END
		
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_UPDATE_NOTIFICATION_RESPONSE
		RETURN @out_nReturnValue
	END CATCH
END