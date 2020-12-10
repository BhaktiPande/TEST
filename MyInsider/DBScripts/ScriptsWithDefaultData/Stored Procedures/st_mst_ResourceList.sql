IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_mst_ResourceList')
DROP PROCEDURE [dbo].[st_mst_ResourceList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list resources.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		04-Mar-2015

Modification History:
Modified By		Modified On		Description
Arundhati		09-MAr-2015		Original resource value added in the output
Usage:
EXEC st_usr_DelegationMasterList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_mst_ResourceList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_iModuleCodeId				INT
	,@inp_iCategoryCodeId			INT
	,@inp_iScreenCodeId				INT
	,@inp_sResourceValue			VARCHAR(255)
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_RESOURCE_LIST INT = 10014 -- Error occurred while fetching list of resources.

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
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'R.ResourceValue '
		END 
		

		IF @inp_sSortField = 'mst_grd_10015'  -- Module
		BEGIN 
			SELECT @inp_sSortField = 'R.ModuleCodeId '
		END 
		
		IF @inp_sSortField = 'mst_grd_10016'  -- Category
		BEGIN 
			SELECT @inp_sSortField = 'R.CategoryCodeId '
		END 
		
		IF @inp_sSortField = 'mst_grd_10017'  -- Screen,
		BEGIN 
			SELECT @inp_sSortField = 'R.ScreenCodeId '
		END 
		
		IF @inp_sSortField = 'mst_grd_10018'  -- Label
		BEGIN 
			SELECT @inp_sSortField = 'R.ResourceValue '
		END 
		
		IF @inp_sSortField = 'mst_grd_10028'  -- Label
		BEGIN 
			SELECT @inp_sSortField = 'R.OriginalResourceValue '
		END 
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',R.ResourceId),R.ResourceId '
		SELECT @sSQL = @sSQL + ' FROM mst_Resource R '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CModule ON R.ModuleCodeId = CModule.CodeID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CCategory ON R.CategoryCodeId = CCategory.CodeID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CScreen ON R.ScreenCodeId = CScreen.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE ResourceCulture = ''en-US'' '


		IF (@inp_iModuleCodeId IS NOT NULL AND @inp_iModuleCodeId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND R.ModuleCodeId = '+ CAST(@inp_iModuleCodeId AS VARCHAR(20)) +' '
		END
		
		IF (@inp_iCategoryCodeId IS NOT NULL AND @inp_iCategoryCodeId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND R.CategoryCodeId = '+ CAST(@inp_iCategoryCodeId AS VARCHAR(20)) + ' '
		END

		IF (@inp_iScreenCodeId IS NOT NULL AND @inp_iScreenCodeId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND R.ScreenCodeId = '+ CAST(@inp_iScreenCodeId AS VARCHAR(20)) + ' '
		END

		IF (@inp_sResourceValue IS NOT NULL AND @inp_sResourceValue <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND R.ResourceValue LIKE N''%'+ @inp_sResourceValue + '%'' '
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	ResourceId,
				ResourceKey,
				ResourceCulture,
				CModule.CodeName AS mst_grd_10015, --Module,
				CCategory.CodeName AS mst_grd_10016, --Category,
				CScreen.CodeName AS mst_grd_10017, --Screnn,
				ResourceValue AS mst_grd_10018, --ResourceValue
				OriginalResourceValue AS mst_grd_10028 --ResourceValue
		FROM	#tmpList T INNER JOIN
				mst_Resource R ON R.ResourceId = T.EntityID
				JOIN com_Code CModule ON R.ModuleCodeId = CModule.CodeID
				JOIN com_Code CCategory ON R.CategoryCodeId = CCategory.CodeID
				JOIN com_Code CScreen ON R.ScreenCodeId = CScreen.CodeID
		WHERE	R.ResourceId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_RESOURCE_LIST
	END CATCH
END
