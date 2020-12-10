IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_NotificationList')
DROP PROCEDURE [dbo].[st_cmu_NotificationList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Notification data.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		11-May-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	16-May-2015		Changes in Join.
Gaurishankar	19-Jun-2015		Changes for Dashboard Notification list
Gaurishankar	15-Oct-2015		Changes for Date compare condition as the toDate is not included in the search result
Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_cmu_NotificationList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_nLoggedInUserId			INT	
	,@inp_nCommunicationModeCodeId	INT
	,@inp_sMessage					NVARCHAR(255)
	,@inp_sContent					NVARCHAR(255)
	,@inp_dtFromDate				DATETIME
	,@inp_dtToDate					DATETIME
	,@inp_nGridType					int = 114051 -- Communication - list of notifications for a user
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_NOTIFICATIONDETAILS_LIST INT = 18036 -- Error occurred while fetching list of Notification.
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		IF @inp_iPageSize < 0
			SELECT @inp_iPageSize = 10

	Declare @UserTypeCodeId int =0
	 select @UserTypeCodeId=UserTypeCodeId from usr_UserInfo where UserInfoId=@inp_nLoggedInUserId
			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
	 SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'

		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'DESC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'NQ.CreatedOn '
		END 
		
		
		IF @inp_sSortField = 'cmu_grd_18012' -- 
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN CModeCode.DisplayCode IS NULL THEN CModeCode.CodeName ELSE CModeCode.DisplayCode END ' 
		END 
		
		IF @inp_sSortField = 'cmu_grd_18013' -- 
		BEGIN 
			SELECT @inp_sSortField = 'NQ.Contents '
		END 

		IF @inp_sSortField = 'cmu_grd_18049' -- 
		BEGIN 
			SELECT @inp_sSortField = 'NQ.[Subject] '
		END 
		
		IF @inp_sSortField = 'cmu_grd_18014' OR @inp_sSortField = 'cmu_grd_18050'  -- 
		BEGIN 
			SELECT @inp_sSortField = 'NQ.CreatedOn ' 
		END 

		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',NQ.NotificationQueueId),NQ.NotificationQueueId '
		SELECT @sSQL = @sSQL + ' FROM cmu_NotificationQueue NQ'
		SELECT @sSQL = @sSQL + ' INNER JOIN com_Code CModeCode ON CModeCode.CodeID = NQ.ModeCodeId '
		--SELECT @sSQL = @sSQL + ' WHERE NQ.UserId =  '+ CAST(@inp_nLoggedInUserId AS VARCHAR(10)) + ' '
		SELECT @sSQL = @sSQL + ' WHERE   ' + case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then   '1 ='  else ' NQ.UserId = ' end+ case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then  '1' else CAST(@inp_nLoggedInUserId AS VARCHAR(10))end + ' '
		IF (@inp_sMessage IS NOT NULL AND @inp_sMessage <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND NQ.[Subject] LIKE N''%'+ @inp_sMessage +'%'' '
		END
		
		IF (@inp_sContent IS NOT NULL AND @inp_sContent <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND NQ.Contents LIKE N''%'+ @inp_sContent +'%'' '
		END
		
		IF (@inp_nCommunicationModeCodeId IS NOT NULL AND @inp_nCommunicationModeCodeId <> 0)	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND NQ.ModeCodeId = '+ CAST(@inp_nCommunicationModeCodeId AS VARCHAR(10)) + ' '
		END
		
		IF (@inp_dtFromDate IS NOT NULL AND @inp_dtFromDate != '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND NQ.CreatedOn >= '''  + CAST(@inp_dtFromDate AS VARCHAR(11)) + ''''
		END
		
		IF (@inp_dtToDate IS NOT NULL AND @inp_dtToDate != '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CAST(NQ.CreatedOn AS date) <= '''  + CAST(@inp_dtToDate AS VARCHAR(11)) + ''''
		END
		
		EXEC(@sSQL)
		IF(@inp_nGridType = 114057)
		BEGIN
			SELECT @inp_iPageSize = 10
			SELECT	NQ.NotificationQueueId
				  ,NQ.ModeCodeId
				  ,CASE WHEN CModeCode.DisplayCode IS NULL THEN CModeCode.CodeName ELSE CModeCode.DisplayCode END  AS ModeCodeName
				  --,NQ.UserId
				  --,NQ.UserContactInfo
				  ,CASE WHEN NQ.[Subject] IS NULL OR NQ.[Subject] = '' THEN NQ.Contents ELSE NQ.[Subject] END AS cmu_grd_18049
				  --,NQ.Contents
				  ,NQ.CreatedOn AS cmu_grd_18050
			FROM	#tmpList T INNER JOIN cmu_NotificationQueue NQ ON T.EntityID = NQ.NotificationQueueId
					INNER JOIN com_Code CModeCode ON CModeCode.CodeID = NQ.ModeCodeId						
			WHERE	NQ.NotificationQueueId IS NOT NULL 
			AND --@inp_nLoggedInUserId = NQ.UserId
			 case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else @inp_nLoggedInUserId end =case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else NQ.UserId  end
			AND((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
			ORDER BY T.RowNumber
		END 
		ELSE
		BEGIN
		if(@inp_sContent='OS')
		begin
		delete from #tmpList 
		end
			SELECT	NQ.NotificationQueueId
				  ,NQ.ModeCodeId
				  ,CASE WHEN CModeCode.DisplayCode IS NULL THEN CModeCode.CodeName ELSE CModeCode.DisplayCode END  AS cmu_grd_18012
				  --,NQ.UserId
				  --,NQ.UserContactInfo
				  ,CASE WHEN NQ.[Subject] IS NULL OR NQ.[Subject] = '' THEN NQ.Contents ELSE NQ.[Subject] END AS cmu_grd_18013
				  --,NQ.Contents
				  ,NQ.CreatedOn AS cmu_grd_18014
			FROM	#tmpList T INNER JOIN cmu_NotificationQueue NQ ON T.EntityID = NQ.NotificationQueueId
					INNER JOIN com_Code CModeCode ON CModeCode.CodeID = NQ.ModeCodeId						
			WHERE	NQ.NotificationQueueId IS NOT NULL 
			AND --@inp_nLoggedInUserId = NQ.UserId
			 case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else @inp_nLoggedInUserId end =case when @UserTypeCodeId =101001 or @UserTypeCodeId= 101002 then 1 else NQ.UserId  end
			AND((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
			ORDER BY T.RowNumber
		END
			

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_NOTIFICATIONDETAILS_LIST
	END CATCH
END
