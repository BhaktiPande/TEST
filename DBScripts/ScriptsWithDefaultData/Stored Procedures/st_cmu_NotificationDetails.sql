IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_NotificationDetails')
DROP PROCEDURE [dbo].[st_cmu_NotificationDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the NotificationQueue details

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		04-Jun-2015

Modification History:
Modified By		Modified On	Description

Usage:
EXEC st_cmu_NotificationDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_cmu_NotificationDetails]
	@inp_iNotificationQueueId INT,							-- Id of the NotificationQueue whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_NOTIFICATIONQUEUE_GETDETAILS INT
	DECLARE @ERR_NOTIFICATIONQUEUE_NOTFOUND INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		

		--Initialize variables
		SELECT	@ERR_NOTIFICATIONQUEUE_NOTFOUND = 18035,
				@ERR_NOTIFICATIONQUEUE_GETDETAILS = 18034

		--Check if the NotificationQueue whose details are being fetched exists
		IF (NOT EXISTS(SELECT NotificationQueueId FROM cmu_NotificationQueue WHERE NotificationQueueId = @inp_iNotificationQueueId))
		BEGIN	
				SET @out_nReturnValue = @ERR_NOTIFICATIONQUEUE_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the NotificationQueue details
		Select NQ.NotificationQueueId, NQ.ModeCodeId, CASE WHEN CModeCode.DisplayCode IS NULL THEN CModeCode.CodeName ELSE CModeCode.DisplayCode END  AS ModeCodeName
			, NQ.UserContactInfo, NQ.[Subject], NQ.Contents, NQ.[Signature], NQ.CommunicationFrom --, ResponseStatusCodeId, ResponseMessage
			, NQ.CreatedOn
			From cmu_NotificationQueue NQ
				INNER JOIN com_Code CModeCode ON CModeCode.CodeID = NQ.ModeCodeId
			Where NotificationQueueId = @inp_iNotificationQueueId
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_NOTIFICATIONQUEUE_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

