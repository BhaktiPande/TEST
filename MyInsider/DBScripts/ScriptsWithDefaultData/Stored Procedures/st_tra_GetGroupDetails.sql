/*
	Created By  :	Shubhangi Gurude
	Created On  :   06-Feb-2017
	Description :	This stored Procedure is used to get group details	
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetGroupDetails')
	DROP PROCEDURE st_tra_GetGroupDetails
GO

CREATE PROCEDURE [dbo].[st_tra_GetGroupDetails]
	 	 	 
	 @inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1	
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
   	,@inp_iGroupID		            INT
    ,@inp_DownloadFromDate          DATETIME 
    ,@inp_DownloadToDate            DATETIME  
    ,@inp_SubmissionFromDate        DATETIME  
  	,@inp_SubmissionToDate          DATETIME  
   	,@inp_SubmissionStatus		    INT	   				
	,@out_nReturnValue		        INT = 0 OUTPUT
	,@out_nSQLErrCode		        INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		    NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_GROUPVALUES_GETDETAILS INT = 50440 -- Error occurred while fetching code details.
	DECLARE @ERR_GROUPVALUES_NOTFOUND INT = 50435 -- Group details does not exist
	DECLARE @sSQL							NVARCHAR(MAX) = ''
	DECLARE @sPendingButtonText				VARCHAR(10),
	@sSubmittedButtonText					VARCHAR(10),
	@sDeletedButtonText					VARCHAR(10)
	
	BEGIN TRY		
		
	   SELECT @sPendingButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'nse_btn_50499'	   
			
		   
	   SELECT @sDeletedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'nse_btn_50500'
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

	 
  	IF(@inp_DownloadFromDate IS NOT NULL AND @inp_DownloadToDate IS NULL)
    BEGIN
      SET @inp_DownloadToDate = convert(VARCHAR(100), GETDATE())
    END 
    
  
    IF(@inp_DownloadFromDate IS NULL AND @inp_DownloadToDate IS NOT NULL)
    BEGIN    
       SET @inp_DownloadFromDate =(SELECT convert(VARCHAR(100),MIN(DownloadedDate)) FROM tra_NSEGroup)
    END    
    
    IF(@inp_SubmissionFromDate IS NULL AND @inp_SubmissionToDate IS NOT NULL)
    BEGIN
    
       SET @inp_SubmissionFromDate =convert(VARCHAR(100),(SELECT MIN(SubmissionDate) FROM tra_NSEGroup))
       
    END    
    IF(@inp_SubmissionFromDate IS NOT NULL AND @inp_SubmissionToDate IS NULL)
  	BEGIN
        SET @inp_SubmissionToDate = convert(VARCHAR(100), GETDATE())
    END 
    
    CREATE TABLE #tmpUsers(Id INT IDENTITY(1,1),IsAddButtonRow INT DEFAULT 0,GroupId INT,UserInfoId INT,DownloadDate DATETIME,SubmissionDate DATETIME,StatusCode INT)
    
    INSERT INTO #tmpUsers(GroupId,UserInfoId,DownloadDate,SubmissionDate,StatusCode)
    
    (SELECT tra_NSEGroup.GroupId,isnull(count(T.UserInfoId),0) AS 'No of Employees',tra_NSEGroup.DownloadedDate,tra_NSEGroup.SubmissionDate,tra_NSEGroup.StatusCodeId FROM tra_NSEGroup  LEFT JOIN
    (SELECT DISTINCT tra_NSEGroupDetails.GroupId,tra_NSEGroupDetails.UserInfoId FROM tra_NSEGroupDetails)
    AS T ON tra_NSEGroup.GroupId=T.GroupId
    GROUP BY tra_NSEGroup.GroupId,tra_NSEGroup.DownloadedDate,tra_NSEGroup.SubmissionDate,tra_NSEGroup.StatusCodeId)	 
	 
	 
	 SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
	 
	   	IF (@inp_sSortOrder IS NULL OR @inp_sSortOrder = '')
	   	BEGIN 
		   SELECT @inp_sSortOrder = 'DESC'
		END
		
		IF (@inp_sSortField IS NULL OR @inp_sSortField = '')
	   	BEGIN 
		  	SELECT @inp_sSortField = 'Temp.GroupId '
	   	END	 
	 
	 	SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +', IsAddButtonRow DESC,Temp.GroupId),Temp.Id '
		SELECT @sSQL = @sSQL + ' FROM #tmpUsers Temp '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1'
 
	 IF(@inp_iGroupID IS NOT NULL )
     	 BEGIN    
     	 SET @sSQL = @sSQL + ' and Temp.GroupId='+convert(VARCHAR(10),@inp_iGroupID) +''         
     	 END
     
     
     IF(@inp_DownloadFromDate IS NOT	 NULL AND @inp_DownloadToDate IS NOT NULL)
     BEGIN         
         SET @sSQL = @sSQL + ' and convert(DATE,Temp.DownloadDate) >= CAST('''  + CAST(@inp_DownloadFromDate AS VARCHAR(25)) + ''' AS DATE)'
         SET @sSQL = @sSQL + ' and convert(DATE,Temp.DownloadDate) <= CAST('''  + CAST(@inp_DownloadToDate AS VARCHAR(25)) + ''' AS DATE)'    
     END
    
    IF(@inp_SubmissionFromDate IS NOT NULL AND	@inp_SubmissionToDate IS NOT NULL)
    BEGIN
    SET @sSQL = @sSQL +' and convert(DATE,Temp.SubmissionDate) >= CAST('''  + CAST(@inp_SubmissionFromDate AS VARCHAR(25)) + ''' AS DATE)'
    SET @sSQL = @sSQL +' and convert(DATE,Temp.SubmissionDate) <= CAST('''  + CAST(@inp_SubmissionToDate AS VARCHAR(25)) + ''' AS DATE)'    
    END    
    
    IF(@inp_SubmissionStatus IS NOT NULL)
    BEGIN
    SET @sSQL = @sSQL +' and Temp.StatusCode='+convert(VARCHAR(10),@inp_SubmissionStatus) +''
    SET @sSQL = @sSQL +' and Temp.UserInfoId>0' 
    END
    
    	EXEC(@sSQL)
  
	   SELECT 
	   Temp.GroupId,Temp.GroupId AS 'nse_grd_50430',isnull(Temp.UserInfoId,0) AS 'nse_grd_50431',
	   tra_NSEGroup.DownloadedDate AS 'nse_grd_50432',tra_NSEGroup.SubmissionDate AS 'nse_grd_50433',
	 
	   CASE WHEN (tra_NSEGroup.SubmissionDate IS NULL) THEN 
	   CASE WHEN Temp.UserInfoId > 0 THEN 2 ELSE 3 END ELSE 1 END 
	   AS Groupsubmissionflag,
	  		  		
	   CASE WHEN (tra_NSEGroup.SubmissionDate IS  NULL) THEN 
	   CASE WHEN Temp.UserInfoId > 0 THEN @sPendingButtonText ELSE @sDeletedButtonText END END 
	   AS GroupsubmissionStatusText	 
	 
	   FROM #tmpList T INNER JOIN #tmpUsers Temp
	   ON Temp.Id = T.EntityID JOIN tra_NSEGroup ON tra_NSEGroup.GroupId=Temp.GroupId
	   WHERE ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
	   ORDER BY T.RowNumber	
   
	END TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_GROUPVALUES_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END
GO

