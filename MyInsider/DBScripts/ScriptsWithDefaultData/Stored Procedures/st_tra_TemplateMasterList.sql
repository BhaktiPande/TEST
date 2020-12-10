IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TemplateMasterList')
DROP PROCEDURE [dbo].[st_tra_TemplateMasterList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Template data.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		11-May-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	16-May-2015		Changes in Join.
Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TemplateMasterList]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_sTemplateName			NVARCHAR(255)
	,@inp_nCommunicationModeCodeId	INT
	,@inp_nDisclosureTypeCodeId	INT
	,@inp_bIsActive				BIT
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_TEMPLATEDETAILS_LIST INT = 16074 -- Error occurred while fetching list of Template.
	
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
			SELECT @inp_sSortField = 'TM.TemplateName '
		END 
		
		
		IF @inp_sSortField = 'tra_grd_16070' -- 
		BEGIN 
			SELECT @inp_sSortField = 'TM.TemplateName' 
		END 
		
		IF @inp_sSortField = 'tra_grd_16071' -- 
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN CCommMode.DisplayCode IS NULL THEN CCommMode.CodeName ELSE CCommMode.DisplayCode END '
		END 

		IF @inp_sSortField = 'tra_grd_16072' -- 
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN CDisclosureType.DisplayCode IS NULL THEN CDisclosureType.CodeName ELSE CDisclosureType.DisplayCode END ' 
		END 

		IF @inp_sSortField = 'tra_grd_16073' -- 
		BEGIN 
			SELECT @inp_sSortField = 'TM.IsActive ' 
		END 

		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',TM.TemplateMasterId),TM.TemplateMasterId '
		SELECT @sSQL = @sSQL + ' FROM tra_TemplateMaster TM '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CCommMode ON TM.CommunicationModeCodeId = CCommMode.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CDisclosureType ON TM.DisclosureTypeCodeId = CDisclosureType.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CLetterFor ON TM.LetterForCodeId = CLetterFor.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE 1= 1 '
		
		IF (@inp_sTemplateName IS NOT NULL AND @inp_sTemplateName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND TM.TemplateName LIKE N''%'+ @inp_sTemplateName +'%'' '
		END
		
		IF (@inp_nCommunicationModeCodeId IS NOT NULL AND @inp_nCommunicationModeCodeId <> 0)	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND TM.CommunicationModeCodeId = '+ CAST(@inp_nCommunicationModeCodeId AS VARCHAR(10)) + ' '
		END
		IF (@inp_nDisclosureTypeCodeId IS NOT NULL AND @inp_nDisclosureTypeCodeId <> 0)	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND TM.DisclosureTypeCodeId = '+ CAST(@inp_nDisclosureTypeCodeId AS VARCHAR(10)) + ' '
		END
		IF (@inp_bIsActive IS NOT NULL )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND TM.IsActive = '+ CAST(@inp_bIsActive AS VARCHAR(1)) + ' '
		END
		--print(@sSQL)
		EXEC(@sSQL)

		SELECT	TM.TemplateMasterId
				,TM.TemplateName AS tra_grd_16070
				,CASE WHEN CCommMode.DisplayCode IS NULL THEN CCommMode.CodeName ELSE CCommMode.DisplayCode END  AS tra_grd_16071
				,CASE WHEN CDisclosureType.DisplayCode IS NULL THEN CDisclosureType.CodeName ELSE CDisclosureType.DisplayCode END AS tra_grd_16072 
				,TM.IsActive AS tra_grd_16073
		FROM	#tmpList T INNER JOIN tra_TemplateMaster TM ON T.EntityID = TM.TemplateMasterId				
				JOIN com_Code CCommMode ON TM.CommunicationModeCodeId = CCommMode.CodeID 
				LEFT JOIN com_Code CDisclosureType ON TM.DisclosureTypeCodeId = CDisclosureType.CodeID 
				LEFT JOIN com_Code CLetterFor ON TM.LetterForCodeId = CLetterFor.CodeID 				
		WHERE	TM.TemplateMasterId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TEMPLATEDETAILS_LIST
	END CATCH
END
