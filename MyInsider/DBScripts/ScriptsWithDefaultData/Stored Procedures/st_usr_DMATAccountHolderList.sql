IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DMATAccountHolderList')
DROP PROCEDURE [dbo].[st_usr_DMATAccountHolderList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list DMATAccountHolderList

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		03-Mar-2015

Modification History:
Modified By		Modified On		Description

Usage:
EXEC st_usr_DMATAccountHolderList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DMATAccountHolderList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_iDMATDetailsID			INT
	,@inp_sAccountHolderName		NVARCHAR(100)
	,@inp_sPAN						NVARCHAR(50)
	,@inp_iRelationTypeCodeId		INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_DMATACCOUNTHOLDER_LIST INT = 11216 -- Error occurred while fetching list of DMAT account holder names for dmat account.

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
			SELECT @inp_sSortField = 'DA.AccountHolderName '
		END 

		IF @inp_sSortField = 'usr_grd_11213' -- Account Holder Name
		BEGIN 
			SELECT @inp_sSortField = 'DA.AccountHolderName '
		END 
				
		IF @inp_sSortField = 'usr_grd_11214' -- PAN
		BEGIN 
			SELECT @inp_sSortField = 'DA.PAN '
		END 
				
		IF @inp_sSortField = 'usr_grd_11215' -- Relation with Primary A/C Holder
		BEGIN 
			SELECT @inp_sSortField = 'CRelation.CodeName '
		END 
				

		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',DA.DMATAccountHolderId),DA.DMATAccountHolderId'				
		SELECT @sSQL = @sSQL + ' FROM usr_DMATAccountHolder DA '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CRelation ON DA.RelationTypeCodeId = CRelation.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE DA.DMATDetailsID = ' + CAST(@inp_iDMATDetailsID AS VARCHAR(10)) + ' '

		IF (@inp_sAccountHolderName IS NOT NULL AND @inp_sAccountHolderName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND DA.AccountHolderName LIKE N''%'+ @inp_sAccountHolderName +'%'' '
		END
		
		IF (@inp_sPAN IS NOT NULL AND @inp_sPAN <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND DA.PAN LIKE N''%'+ @inp_sPAN +'%'' '
		END
		
		IF (@inp_iRelationTypeCodeId IS NOT NULL AND @inp_iRelationTypeCodeId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND DA.RelationTypeCodeId = '+ CAST(@inp_iRelationTypeCodeId AS VARCHAR(10)) +' '
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	DA.DMATAccountHolderId AS DMATAccountHolderId,
				DA.DMATDetailsID AS DMATDetailsID,
				DA.AccountHolderName AS usr_grd_11213,
				DA.PAN AS usr_grd_11214,
				DA.RelationTypeCodeId AS RelationTypeCodeId,
				CRelation.CodeName AS usr_grd_11215				
		FROM	#tmpList T INNER JOIN
				usr_DMATAccountHolder DA ON DA.DMATAccountHolderId = T.EntityID
				JOIN com_Code CRelation ON DA.RelationTypeCodeId = CRelation.CodeID
		WHERE   DA.DMATAccountHolderId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_DMATACCOUNTHOLDER_LIST
	END CATCH
END
