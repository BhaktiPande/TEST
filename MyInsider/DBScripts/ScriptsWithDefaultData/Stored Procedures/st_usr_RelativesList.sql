IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_RelativesList')
DROP PROCEDURE [dbo].[st_usr_RelativesList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list relatives of a user.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		19-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		23-Feb-2015		Added column UserInfoId in the output
Parag			01-Sept-2015	Made change to show address field (add check for ISNULL on address2 field)

Usage:
EXEC st_usr_RelativesList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_RelativesList]
	 @inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_iUserInfoID				INT
	,@inp_sUserName					VARCHAR(50)
	,@inp_iRelationTypeCodeId		INT
	,@inp_sAddress					NVARCHAR(100)
	,@inp_sContactNumber			VARCHAR(15)
	,@inp_sEmailId					VARCHAR(100)
	,@inp_sPAN						VARCHAR(50)
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_DEMAT_LIST INT = 11040 -- Error occurred while fetching list of demat accounts for user.

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
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'usr_grd_11086'
		BEGIN 
			SELECT @inp_sSortField = 'UF.FirstName ' + @inp_sSortOrder + ', UF.LastName '
		END 
		
		IF @inp_sSortField = 'usr_grd_11087'
		BEGIN 
			SELECT @inp_sSortField = 'CRelation.CodeName '
		END 

		IF @inp_sSortField = 'usr_grd_11088'
		BEGIN 
			SELECT @inp_sSortField = 'UF.AddressLine1 ' + @inp_sSortOrder + ', UF.AddressLine2 '
		END 
		IF @inp_sSortField = 'usr_grd_11089'
		BEGIN 
			SELECT @inp_sSortField = 'UF.MobileNumber '
		END 
		IF @inp_sSortField = 'usr_grd_11090'
		BEGIN 
			SELECT @inp_sSortField = 'UF.EmailId '
		END 
		IF @inp_sSortField = 'usr_grd_11091'
		BEGIN 
			SELECT @inp_sSortField = 'UF.PAN '
		END 

		
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UR.UserRelationId),UR.UserRelationId '				
		SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UF JOIN usr_UserRelation UR ON UR.UserInfoIdRelative = UF.UserInfoId '
		SELECT @sSQL = @sSQL + 'JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE UR.UserInfoID = ' + CAST(@inp_iUserInfoID AS VARCHAR(10)) + ' '

		IF (@inp_sUserName IS NOT NULL AND @inp_sUserName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.FirstName LIKE N''%'+ @inp_sUserName +'%'' '
		END
		
		IF (@inp_sAddress IS NOT NULL AND @inp_sAddress <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND (UF.AddressLine1 LIKE N''%'+ @inp_sAddress +'%'' OR UF.AddressLine2 LIKE N''%'+ @inp_sAddress +'%'') '
		END
		
		IF (@inp_sContactNumber IS NOT NULL AND @inp_sContactNumber <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.MobileNumber LIKE N''%'+ @inp_sContactNumber +'%'' '
		END
		
		IF (@inp_sEmailId IS NOT NULL AND @inp_sEmailId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.EmailId LIKE N''%'+ @inp_sEmailId +'%'' '
		END
		
		IF (@inp_sPAN IS NOT NULL AND @inp_sPAN <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.PAN LIKE N''%'+ @inp_sPAN +'%'' '
		END
		
		IF (@inp_iRelationTypeCodeId IS NOT NULL AND @inp_iRelationTypeCodeId <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UR.RelationTypeCodeId = '  + CAST(@inp_iRelationTypeCodeId AS VARCHAR(10)) 
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT UR.UserRelationId AS UserRelationId,
			UR.UserInfoIdRelative AS UserInfoId,
			dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),ISNULL(UF.FirstName,'') + ' ' + ISNULL(UF.LastName,'')),1) AS usr_grd_11086, -- DependentName,
			dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),CRelation.CodeName),1) AS usr_grd_11087, --Relation,
			dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),ISNULL(UF.AddressLine1,'') + ' ' + ISNULL(UF.AddressLine2, '')),1) AS usr_grd_11088, --Address,
			dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),UF.MobileNumber),1) AS usr_grd_11089, --ContactNumber,
			dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),UF.EmailId),1) AS usr_grd_11090, --EmailId,
			dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),UF.PAN),1) AS usr_grd_11091, --PAN,			
			UF.RelativeStatus AS usr_grd_50739, -- Status
			(select Count(DD.DMATDetailsID) from usr_DMATDetails DD where DD.UserInfoId = UF.UserInfoId ) AS usr_grd_50740

		FROM #tmpList T INNER JOIN usr_UserRelation UR ON UR.UserRelationId = T.EntityID
			JOIN usr_UserInfo UF ON UR.UserInfoIdRelative = UF.UserInfoId
			JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
		WHERE UR.UserRelationId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_DEMAT_LIST
	END CATCH
END
