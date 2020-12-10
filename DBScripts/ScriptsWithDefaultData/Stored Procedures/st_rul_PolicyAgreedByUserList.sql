IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_PolicyAgreedByUserList')
DROP PROCEDURE [dbo].[st_rul_PolicyAgreedByUserList]
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
Swapnil / Tushar 25-apr-2015	Aded condition to remove the incomplete policies from List.
Swapnil			13-May-2015		Change in conditions .
Swapnil			15-May-2015		Change in query removed join on USerInfo.
Parag			30-Jun-2015		Made change to fix issue of showing multiple agreed policy document into list
Parag			09-Jul-2015		Made change to show not agreed policy document into list along with viewed/agreed policy document
								For this change use temp table and added data into temp table also added other column name for sorting filter
Parag			20-Jul-2015		Made change to show acceptance date for view/agree policy
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC  
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rul_PolicyAgreedByUserList]
	 @inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iUserInfoId			INT
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
as
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_POLICYAGREEDBYUSER_LIST INT = -1
	DECLARE @nCodeGroupID INT
	DECLARE @nParentGroupID INT
	
	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		-- Declare variables
		DECLARE @nWindowStatusCodeId_Active INT = 131002
		
		-- Define temporary table and add policy document list into table
		CREATE TABLE #tmpPolicyDocumentList
			(Id INT IDENTITY(1,1), PolicyDocumentId INT, DocumentId INT, EventLogId INT, PolicyDocumentName VARCHAR(225),
			ApplicableFrom DATETIME, ApplicableTo DATETIME, ViewAgreeStatus INT, PolicyDocumentStatus VARCHAR(100), ViewAgreeEventDate DATETIME)
		
		
		INSERT INTO #tmpPolicyDocumentList 
			(PolicyDocumentId, DocumentId, EventLogId, PolicyDocumentName, ApplicableFrom, ApplicableTo, ViewAgreeStatus, PolicyDocumentStatus,
			ViewAgreeEventDate)
		SELECT 
			PD.PolicyDocumentId ,D.DocumentId,EL.EventLogId as EventLogId,PD.PolicyDocumentName ,PD.ApplicableFrom, PD.ApplicableTo, 
			CASE WHEN EL.EventCodeId IS NULL THEN 0 WHEN EL.EventCodeId = 153027 THEN 1 WHEN EL.EventCodeId = 153028 THEN 2 END, C1.CodeName,
			EL.EventDate
		FROM 
			vw_ApplicablePolicyDocumentForUser APD JOIN rul_ApplicabilityMaster AM ON AM.ApplicabilityId = APD.ApplicabilityMstId
			JOIN rul_PolicyDocument PD ON AM.MapToId = PD.PolicyDocumentId
			JOIN com_Code C1 ON PD.WindowStatusCodeId = C1.CodeID
			LEFT JOIN com_DocumentObjectMapping DOM ON DOM.MapToTypeCodeId = AM.MapToTypeCodeId AND AM.MapToId = DOM.MapToId AND PurposeCodeId IS NULL
			LEFT JOIN com_Document D ON D.DocumentId = DOM.DocumentId
			LEFT JOIN eve_EventLog EL ON EL.UserInfoId = @inp_iUserInfoID AND EL.MapToTypeCodeId = AM.MapToTypeCodeId AND EL.MapToId = AM.MapToId
				AND ((PD.DocumentViewAgreeFlag = 1 AND EL.EventCodeId = 153028) OR (PD.DocumentViewAgreeFlag = 0 AND PD.DocumentViewFlag = 1 AND EL.EventCodeId = 153027))
		WHERE APD.UserInfoId = @inp_iUserInfoID
			AND WindowStatusCodeId = @nWindowStatusCodeId_Active
			AND (dbo.uf_com_GetServerDate() >= PD.ApplicableFrom AND (PD.ApplicableTo IS NULL OR PD.ApplicableTo >= dbo.uf_com_GetServerDate()))
		UNION
		SELECT 
			P.PolicyDocumentId, DO.DocumentId, E.EventLogId, P.PolicyDocumentName, P.ApplicableFrom, P.ApplicableTo, 
			CASE WHEN E.EventCodeId IS NULL THEN 0 WHEN E.EventCodeId = 153027 THEN 1 WHEN E.EventCodeId = 153028 THEN 2 END, C1.CodeName,
			E.EventDate 
		FROM 
			eve_EventLog E 
			JOIN Com_Code C ON C.CodeID = E.EventCodeId 
			JOIN rul_PolicyDocument P ON E.MapToId = P.PolicyDocumentId 
			JOIN Com_Code C1 ON P.WindowStatusCodeId = C1.CodeID	
			JOIN  com_DocumentObjectMapping DO ON DO.MapToId = P.PolicyDocumentId	AND DO.PurposeCodeId IS NULL AND DO.MapToTypeCodeId = 132001
		WHERE 1 = 1 AND E.MapToTypeCodeId = 132001 AND P.WindowStatusCodeId <> 131001  AND (E.EventCodeId = 153027 OR E.EventCodeId = 153028 )
				AND E.UserInfoId = @inp_iUserInfoId
		
		-- Set sort order 
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		-- Set default sort field 
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'PolicyDocumentName '
		END
		
		IF @inp_sSortField = 'rul_grd_15344' -- Policy document name
		BEGIN 
			SELECT @inp_sSortField = 'PolicyDocumentName ' 
		END
		
		IF @inp_sSortField = 'rul_grd_15345' -- Applicable From
		BEGIN 
			SELECT @inp_sSortField = 'ApplicableFrom ' 
		END
		
		IF @inp_sSortField = 'rul_grd_15346' -- Applicable To
		BEGIN 
			SELECT @inp_sSortField = 'ApplicableTo ' 
		END
		
		IF @inp_sSortField = 'rul_grd_15347' -- View Agree Status
		BEGIN 
			SELECT @inp_sSortField = 'ViewAgreeStatus ' 
		END
		
		IF @inp_sSortField = 'rul_grd_15348' -- Policy Document Status
		BEGIN 
			SELECT @inp_sSortField = 'PolicyDocumentStatus ' 
		END
		
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +', Id),Id '
		SELECT @sSQL = @sSQL + ' FROM #tmpPolicyDocumentList '
		
		--PRINT(@sSQL)
		EXEC(@sSQL)
		
		SELECT
			PolicyDocumentId, 
			DocumentId, 
			EventLogId, 
			PolicyDocumentName as rul_grd_15344, 
			ApplicableFrom as rul_grd_15345, 
			ApplicableTo as rul_grd_15346, 
			ViewAgreeStatus as rul_grd_15347, 
			PolicyDocumentStatus as rul_grd_15348,
			ViewAgreeEventDate as rul_grd_15415
		FROM #tmpList t INNER JOIN #tmpPolicyDocumentList tPDL ON t.EntityID = tPDL.Id 
		WHERE	1=1 AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	
	END TRY	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_POLICYAGREEDBYUSER_LIST
	END CATCH

END
	