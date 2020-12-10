IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_WorkList')
DROP PROCEDURE [dbo].[st_usr_WorkList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list work.

Returns:		0, if Success.
				
Created by:		Samadhan kadam
Created on:		08-Feb-2019

Usage:
EXEC st_usr_EducationList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_WorkList]
	 @inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)=null
	,@inp_sSortOrder				VARCHAR(5)=null
	,@inp_iUserInfoID				INT=0
	,@inp_iEmployer			       VARCHAR(250)=null
	,@inp_iFlag                     int=0
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_Work_LIST INT =54037 -- Error occurred while fetching list of work details for user. 

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 	
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'usr_grd_54030'
		BEGIN 
			SELECT @inp_sSortField = 'UEWD.EmployerName' 
		END 
		ELSE IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'usr_grd_54023'
		BEGIN 
			SELECT @inp_sSortField = 'UEWD.Designation' 
		END 
		ELSE IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'usr_grd_54019'
		BEGIN 
			SELECT @inp_sSortField = 'UEWD.PMonth' 
		END 
		ELSE IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'usr_grd_54020'
		BEGIN 
			SELECT @inp_sSortField = 'UEWD.PYear' 
		END 
		ELSE IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'usr_grd_54021'
		BEGIN 
			SELECT @inp_sSortField = 'UEWD.ToMonth' 
		END 
		ELSE IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'usr_grd_54022'
		BEGIN 
			SELECT @inp_sSortField = 'UEWD.ToYear' 
		END 

		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UEWD.UEW_id),UEWD.UEW_id '				
		SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UF JOIN usr_EducationWorkDetails UEWD ON UEWD.UserInfoId = UF.UserInfoId '

		SELECT @sSQL = @sSQL + ' WHERE UEWD.Flag=0 and UEWD.UserInfoID = ' + CAST(@inp_iUserInfoID AS VARCHAR(10)) 

		IF (@inp_iEmployer IS NOT NULL AND @inp_iEmployer <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UEWD.Employer LIKE N''%'+ @inp_iEmployer +'%'' '
		END
		
		
	
		
		PRINT(@sSQL)
		EXEC(@sSQL)

          select    
					UEW_id,
					UF.UserInfoID,
					CASE WHEN Flag=1 THEN 'EDUCATION' ELSE 'WORK' END AS Flag,
					isnull (EmployerName ,'-')as usr_grd_54030,-- Employer
					isnull (Designation ,'-') as usr_grd_54023,-- Designation
					isnull (PMonth ,'-') as usr_grd_54019 ,--From Month
					case when PYear=0 then '-' else PYear  end   as usr_grd_54020, -- From Year
                    isnull ( ToMonth,'-') as usr_grd_54021, --To Month,
                    case when ToYear =0 then '-' else convert(varchar,ToYear )  end  as usr_grd_54022--To Year


			from #tmpList T inner join usr_EducationWorkDetails  UEWD on UEWD.UEW_id= T.EntityID
			JOIN usr_UserInfo UF ON UEWD.UserInfoID = UF.UserInfoId
			WHERE UEWD.UEW_id IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
			ORDER BY T.RowNumber 

  
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_Work_LIST
	END CATCH
END
