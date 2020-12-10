IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_EducationList')
DROP PROCEDURE [dbo].[st_usr_EducationList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list education / work.

Returns:		0, if Success.
				
Created by:		Samadhan kadam
Created on:		08-Feb-2019

Usage:
EXEC st_usr_EducationList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_EducationList]
	 @inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)=null
	,@inp_sSortOrder				VARCHAR(5)=null
	,@inp_iUserInfoID				INT=0
	,@inp_iInstituteName			VARCHAR(250)=null
	,@inp_iCourseName		        VARCHAR(100)=null
	,@inp_iPassingMonth				VARCHAR(100)=null
	,@inp_iFlag                     int=0
	,@inp_iPassingYear      		VARCHAR(100)=null	
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_Education_LIST INT =54036 -- Error occurred while fetching list of education details for user.

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
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'usr_grd_54015'
		BEGIN 
			SELECT @inp_sSortField = 'UEWD.InstituteName' 
		END 
		ELSE IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'usr_grd_54016'
		BEGIN 
			SELECT @inp_sSortField = 'UEWD.CourseName' 
		END
	    ELSE IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'usr_grd_54017'
		BEGIN 
			SELECT @inp_sSortField = 'UEWD.PMonth' 
		END
		ELSE   IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'usr_grd_54018'
		BEGIN 
			SELECT @inp_sSortField = 'UEWD.PYear' 
		END
		
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UEWD.UEW_id),UEWD.UEW_id '				
		SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UF JOIN usr_EducationWorkDetails UEWD ON UEWD.UserInfoId = UF.UserInfoId '

		SELECT @sSQL = @sSQL + ' WHERE UEWD.UserInfoID = ' + CAST(@inp_iUserInfoID AS VARCHAR(10)) 

		IF (@inp_iInstituteName IS NOT NULL AND @inp_iInstituteName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UEWD.InstituteName LIKE N''%'+ @inp_iInstituteName +'%'' '
		END
		
		IF (@inp_iCourseName IS NOT NULL AND @inp_iCourseName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (UEWD.CourseName LIKE N''%'+ @inp_iCourseName ++'%'' '
		END
		
		IF (@inp_iPassingMonth IS NOT NULL AND @inp_iPassingMonth <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UEWD.PMonth LIKE N''%'+ @inp_iPassingMonth +'%'' '
		END
		
		IF (@inp_iPassingYear IS NOT NULL AND @inp_iPassingYear <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UEWD.PYear LIKE N''%'+ @inp_iPassingYear +'%'' '
		END
		
		IF (@inp_iFlag IS NOT NULL AND @inp_iFlag <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UEWD.Flag=' + CAST(@inp_iFlag AS VARCHAR(10))             
		END
	
		
		PRINT(@sSQL)
		EXEC(@sSQL)

	
	
          select    
					UEW_id,
					UF.UserInfoID,
				    CASE WHEN Flag=1 THEN 'EDUCATION' ELSE 'WORK' END AS Flag,
					isnull (InstituteName,'-') as usr_grd_54015,-- InstituteName
					isnull (CourseName,'-')   as usr_grd_54016,-- CourseName
					isnull (PMonth ,'-')  as usr_grd_54017 ,--Pasing month
				   case when PYear=0 then '-' else PYear  end  as usr_grd_54018 -- Passing Year

			from #tmpList T inner join usr_EducationWorkDetails  UEWD on UEWD.UEW_id= T.EntityID
			JOIN usr_UserInfo UF ON UEWD.UserInfoID = UF.UserInfoId
			WHERE UEWD.UEW_id IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
			ORDER BY T.RowNumber 

  
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_Education_LIST
	END CATCH
END
