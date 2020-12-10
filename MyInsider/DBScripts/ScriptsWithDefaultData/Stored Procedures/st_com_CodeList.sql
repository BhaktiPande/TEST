IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CodeList')
DROP PROCEDURE [dbo].[st_com_CodeList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to Com_code List.

Returns:		0, if Success.
				
Created by:		Swapnil M
Created on:		17-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		19-Feb-2015		Column aliases changed
Arundhati		28-Feb-2015		Fetch codes for the editable groups only
Swapnil			03-Mar-2015		ParentCodeId is added in the search
Swapnil			11-May-2015		Removed CodeGroupName Column.
Raghvendra		16-Jul-2015		Added parent column value where child value is seen e.g. Sub Designation. So the final format will be 
								Parent Code value - Child Code Value when child is not selected. When child is selected, it will be 
								only Child Value
Usage:
EXEC  
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_CodeList]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_sCodeGroupID			VARCHAR(25)
	,@inp_sParentCodeID			VARCHAR(25)
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
as
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_CODE_LIST INT = 10007
	DECLARE @nCodeGroupID INT
	DECLARE @nParentGroupID INT
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		SELECT  @inp_sSortField = 'C.CodeName ',
				@inp_sSortOrder = 'ASC'		
				
		IF @inp_sSortField = 'mst_grd_10002'
		BEGIN 
			SELECT @inp_sSortField = 'c.CodeName '
		END 

		IF @inp_sSortField = 'mst_grd_10003'
		BEGIN 
			SELECT @inp_sSortField = 'c.DisplayCode '
		END 

		IF @inp_sSortField = 'mst_grd_10004'
		BEGIN 
			SELECT @inp_sSortField = 'cg.CodeGroupName '
		END 

		IF @inp_sSortField = 'mst_grd_10005'
		BEGIN 
			SELECT @inp_sSortField = 'c.IsActive '
		END 

		IF @inp_sSortField = 'mst_grd_10006'
		BEGIN 
			SELECT @inp_sSortField = 'c.Description '
		END 

		-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + ' INSERT INTO #tmpList (RowNumber, EntityID)'		
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',C.CodeId),C.CodeId '
		SELECT @sSQL = @sSQL + ' FROM Com_Code C'
		SELECT @sSQL = @sSQL + ' JOIN Com_CodeGroup CG ON C.CodeGroupID = CG.CodeGroupID '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 AND CG.IsEditable = 1 '			
		IF(	@inp_sCodeGroupID IS NOT NULL AND @inp_sCodeGroupID <> '')
		BEGIN
			SELECT @nCodeGroupID = SUBSTRING(@inp_sCodeGroupID, 1, (CHARINDEX('-', @inp_sCodeGroupID, 1) - 1))	
			SELECT @sSQL = @sSQL + 'AND C.CodeGroupID = '+  Convert(nvarchar(100), @nCodeGroupID) 	
		END 		
		IF(	@inp_sParentCodeID IS NOT NULL AND  @inp_sParentCodeID <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND C.ParentCodeId = '+  Convert(nvarchar(100), @inp_sParentCodeID) 	
		END 			
		
		--select @sSQL as SSql						
		EXEC (@sSQL)
		
		SELECT	 c.CodeID
				--, c.CodeName AS mst_grd_10002
				,((CASE WHEN (c.ParentCodeId IS NULL OR @inp_sParentCodeID IS NOT NULL) THEN '' ELSE (SELECT ISNULL(DisplayCode, CodeName) FROM com_Code WHERE CodeID = c.ParentCodeId) + ' - ' END)) + c.CodeName AS mst_grd_10002
				,c.DisplayCode AS mst_grd_10003
				,cg.CodeGroupID as  ParentID		
				,c.IsActive AS mst_grd_10005
				,c.Description AS mst_grd_10006
		FROM	#tmpList t 
				JOIN
					com_Code c ON t.EntityID = c.CodeId
				JOIN 
					com_CodeGroup cg on c.CodeGroupID = cg.CodeGroupID
		WHERE	1 = 1
				AND	((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize))) 
		ORDER BY  T.RowNumber
	
	END TRY	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CODE_LIST
	END CATCH

END
	