IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_ApplicabilityAssociationList_Corporate')
DROP PROCEDURE [dbo].[st_rul_ApplicabilityAssociationList_Corporate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Applicability association list for applicability allocation - Corporate.

Returns:		0, if Success.
				
Created by:		Ashashree
Created on:		08-Apr-2015

Modification History:
Modified By		Modified On			Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_rul_ApplicabilityAssociationList_Corporate 10, 1, '','ASC', 132001, 2,
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rul_ApplicabilityAssociationList_Corporate]
	@inp_iPageSize			INT = 10
	,@inp_iPageNo			INT = 1
	,@inp_sSortField		VARCHAR(255)
	,@inp_sSortOrder		VARCHAR(5)
	,@inp_nMapToTypeCodeId	INT			/*Map to type code : 132001=Policy Document, 132002=Trading Policy in case of Applicability*/
	,@inp_nMapToId			INT			/*This will be Id of the object identified by @inp_nMapToTypeCodeId*/
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN

	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_APPLICABILITY_ASSOCIATION_LIST_CORPORATE INT = 15138 -- Error occurred while fetching corporate list with associated applicability.
	
	DECLARE @nActiveUserStatusCodeId INT = 102001
	DECLARE @nInactiveUserStatusCodeId INT = 102002
	DECLARE	@nUserTypeCorporateCodeId INT = 101004	--Code for UserType Corporate
	DECLARE @nIncludeCodeId	INT = 150001	--150001 : IncludeEmployee, 150002: ExcludeEmployee
	
	DECLARE @nAppMaxVersionNumber	INT = 0
	

	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		--Fetch the maximum version number for the applicability associated with @inp_nMapToTypeCodeId + @inp_nMapToId
		SELECT @nAppMaxVersionNumber =  ISNULL(MAX(VersionNumber), 0) FROM rul_ApplicabilityMaster WHERE MapToTypeCodeId = @inp_nMapToTypeCodeId AND MapToId = @inp_nMapToId
			
		/*Fetch corporates which have applicability associated with @inp_nMapToTypeCodeId + @inp_nMapToId */	
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		
		--Set default sorting order
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		--Set default sorting field
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'Company.CompanyName '
		END
				
		IF @inp_sSortField = 'rul_grd_15134' -- Company Name
		BEGIN 
			SELECT @inp_sSortField = 'Company.CompanyName '
		END
		
		IF @inp_sSortField = 'rul_grd_15135' -- Contact Person
		BEGIN 
			SELECT @inp_sSortField = 'UI.ContactPerson '
		END
		
		IF @inp_sSortField = 'rul_grd_15136' -- Landline number(s) as comma separated list
		BEGIN 
			SELECT @inp_sSortField = '(CASE WHEN UI.LandLine1 IS NULL THEN (CASE WHEN UI.LandLine2 IS NULL THEN '''' ELSE UI.LandLine2 END) 
											ELSE UI.LandLine1 + (CASE WHEN UI.LandLine2 IS NULL THEN '''' ELSE '', '' + UI.LandLine2 END)
										END) '
		END
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UI.UserInfoId),UI.UserInfoId '
		SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UI INNER JOIN mst_Company Company ON UI.CompanyId = Company.CompanyId '
		SELECT @sSQL = @sSQL + ' INNER JOIN rul_ApplicabilityDetails AD on UI.UserInfoId = AD.UserId '
		SELECT @sSQL = @sSQL + ' INNER JOIN rul_ApplicabilityMaster AM on AD.ApplicabilityMstId = AM.ApplicabilityId '
		SELECT @sSQL = @sSQL + ' WHERE 1=1 ' 
		SELECT @sSQL = @sSQL + ' AND UI.UserTypeCodeId = ' + CAST(@nUserTypeCorporateCodeId AS VARCHAR) /*Fetch corporate users only*/
		--SELECT @sSQL = @sSQL + ' AND UI.IsInsider = 1 '
		SELECT @sSQL = @sSQL + ' AND UI.DateOfBecomingInsider IS NOT NULL '
		SELECT @sSQL = @sSQL + ' AND (UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation) '
		SELECT @sSQL = @sSQL + ' AND UI.StatusCodeId = ' + CAST(@nActiveUserStatusCodeId AS VARCHAR(20)) + ' '  /*Fetch only Active employees*/
		SELECT @sSQL = @sSQL + ' AND AD.AllEmployeeFlag = 0 AND AD.AllInsiderFlag = 0 AND AD.AllEmployeeInsiderFlag = 0 '
		SELECT @sSQL = @sSQL + ' AND AD.InsiderTypeCodeId = ' + CAST(@nUserTypeCorporateCodeId AS VARCHAR) 
		SELECT @sSQL = @sSQL + ' AND AD.IncludeExcludeCodeId = ' + CAST(@nIncludeCodeId AS VARCHAR)
		SELECT @sSQL = @sSQL + ' AND AM.MapToTypeCodeId = ' + CAST(@inp_nMapToTypeCodeId AS VARCHAR)
		SELECT @sSQL = @sSQL + ' AND AM.MapToId = ' + CAST(@inp_nMapToId AS VARCHAR)
		SELECT @sSQL = @sSQL + ' AND AM.VersionNumber = ' + CAST(@nAppMaxVersionNumber AS VARCHAR) 

		PRINT(@sSQL)
		EXEC(@sSQL)
		
		SELECT	UI.UserInfoId AS UserInfoId, 
		Company.CompanyName AS rul_grd_15134 /*Company Name*/,
		UI.ContactPerson AS rul_grd_15135 /*Contact Person*/,
		(CASE WHEN UI.LandLine1 IS NULL THEN (CASE WHEN UI.LandLine2 IS NULL THEN '' ELSE UI.LandLine2 END) 
										ELSE UI.LandLine1 + (CASE WHEN UI.LandLine2 IS NULL THEN '' ELSE ', ' + UI.LandLine2 END)
		  END) AS rul_grd_15136 /*Landline No.*/
		FROM	#tmpList T INNER JOIN usr_UserInfo UI ON T.EntityID = UI.UserInfoId
				INNER JOIN mst_Company Company ON UI.CompanyId = Company.CompanyId 
		WHERE	1=1 
		AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		RETURN 0
		
	END TRY
		
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_APPLICABILITY_ASSOCIATION_LIST_CORPORATE
	END CATCH
END
