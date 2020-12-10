IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PolicyDocumentApplicabilityList_Corporate')
DROP PROCEDURE [dbo].[st_tra_PolicyDocumentApplicabilityList_Corporate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list users having applicability associated for Policy Document - Corporate (grid type = 114034).

Returns:		0, if Success.
				
Created by:		Ashashree
Created on:		20-Apr-2015

Modification History:
Modified By		Modified On			Description
Ashashree		22-Apr-2015			Making use of the view which lists all users and all policy documents applicabile to all users
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_tra_PolicyDocumentApplicabilityList_Corporate 10, 1, '','ASC', 2,
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_PolicyDocumentApplicabilityList_Corporate]
	 @inp_iPageSize			INT = 10
	,@inp_iPageNo			INT = 1
	,@inp_sSortField		VARCHAR(255)
	,@inp_sSortOrder		VARCHAR(5)
	,@inp_nPolicyDocumentId	INT			/*This will be Id of the Policy Document*/
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_POLICY_DOCUMENT_APPLICABILITY_LIST_CORPORATE INT = 16044 -- Error occurred while fetching corporate user list associated with policy document.
	
	DECLARE @nActiveUserStatusCodeId INT = 102001
	DECLARE	@nUserTypeCorporateCodeId INT = 101004	--Code for UserType Corporate
	DECLARE @nMapToPolicyTypeCodeId	INT = 132001	--MapToType : Policy Document
	DECLARE @nEventDocumentViewedCodeId	INT = 153027 --Code to denote event that policy document is viewed
	DECLARE @nEventDocumentAgreedCodeId	INT = 153028 --Code to denote event that policy document is agreed 
	
	
	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		/*Define temporary table and add corporate users to temp table for whom policy document is applicable*/
		CREATE TABLE #tmpPolicyUserEvents (ID INT IDENTITY(1,1), 
								  UserInfoId INT NOT NULL, 
								  DocumentViewedDate DATETIME NULL,
								  DocumentAgreedDate DATETIME NULL
								  )
		--Insert users of type corporate to temporary table for whom policy document is applicable and apply filtering based on DateOfBecomingInsider and DateOfSeparation							  
		INSERT INTO #tmpPolicyUserEvents(UserInfoId)
		SELECT UI.UserInfoId 
		FROM usr_UserInfo UI 
		INNER JOIN vw_ApplicablePolicyDocumentForUser PDForUser 
		ON UI.UserInfoId = PDForUser.UserInfoId 
		WHERE 1=1
		AND UI.UserTypeCodeId = @nUserTypeCorporateCodeId
		AND UI.DateOfBecomingInsider IS NOT NULL  
		AND UI.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() 
		AND (UI.DateOfSeparation IS NULL OR  dbo.uf_com_GetServerDate() <= UI.DateOfSeparation)
		AND UI.StatusCodeId = @nActiveUserStatusCodeId
		AND PDForUser.MapToId = @inp_nPolicyDocumentId

		--SELECT * FROM #tmpPolicyUserEvents

		--Update the DocumentView date from event-log if the policy document has DocumentViewFlag=1
		--SELECT tmpPUE.UserInfoId,
		--(CASE WHEN PD.DocumentViewFlag = 1 THEN EL.EventDate ELSE NULL END) AS DocumentViewedDate
		UPDATE #tmpPolicyUserEvents
		SET DocumentViewedDate = (CASE WHEN PD.DocumentViewFlag = 1 THEN EL.EventDate ELSE NULL END) 
		FROM #tmpPolicyUserEvents tmpPUE
		INNER JOIN rul_PolicyDocument PD 
		ON PD.PolicyDocumentId = @inp_nPolicyDocumentId
		LEFT JOIN eve_EventLog EL 
		ON (tmpPUE.UserInfoId = EL.UserInfoId AND EL.MapToTypeCodeId = @nMapToPolicyTypeCodeId AND EL.MapToId = @inp_nPolicyDocumentId AND EL.EventCodeId = @nEventDocumentViewedCodeId) 

		--SELECT * FROM #tmpPolicyUserEvents

		--Update the DocumentAgreed date from event-log if the policy document has DocumentViewAgreeFlag=1
		--SELECT tmpPUE.UserInfoId,
		--(CASE WHEN PD.DocumentViewAgreeFlag = 1 THEN EL.EventDate ELSE NULL END) AS DocumentAgreedDate
		UPDATE #tmpPolicyUserEvents
		SET DocumentAgreedDate = (CASE WHEN PD.DocumentViewAgreeFlag = 1 THEN EL.EventDate ELSE NULL END)
		FROM #tmpPolicyUserEvents tmpPUE
		INNER JOIN rul_PolicyDocument PD 
		ON PD.PolicyDocumentId = @inp_nPolicyDocumentId
		LEFT JOIN eve_EventLog EL 
		ON (tmpPUE.UserInfoId = EL.UserInfoId AND EL.MapToTypeCodeId = @nMapToPolicyTypeCodeId AND EL.MapToId = @inp_nPolicyDocumentId AND EL.EventCodeId = @nEventDocumentAgreedCodeId) 

		--SELECT * FROM #tmpPolicyUserEvents
		
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
				
		IF @inp_sSortField = 'tra_grd_16039' -- Company Name
		BEGIN 
			SELECT @inp_sSortField = 'Company.CompanyName '
		END
		
		IF @inp_sSortField = 'tra_grd_16040' -- Contact Person
		BEGIN 
			SELECT @inp_sSortField = 'UI.ContactPerson '
		END
		
		IF @inp_sSortField = 'tra_grd_16041' -- Designation
		BEGIN 
			SELECT @inp_sSortField = 'UI.DesignationText '
		END
		
		IF @inp_sSortField = 'tra_grd_16042' -- DocumentViewedDate
		BEGIN 
			SELECT @inp_sSortField = 'tmpPUE.DocumentViewedDate '
		END
		
		IF @inp_sSortField = 'tra_grd_16043' -- DocumentAgreedDate
		BEGIN 
			SELECT @inp_sSortField = 'tmpPUE.DocumentAgreedDate '
		END
			
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UI.UserInfoId),UI.UserInfoId '
		SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UI INNER JOIN mst_Company Company ON UI.CompanyId = Company.CompanyId '
		SELECT @sSQL = @sSQL + ' INNER JOIN #tmpPolicyUserEvents tmpPUE ON UI.UserInfoId = tmpPUE.UserInfoId '
		
		PRINT(@sSQL)
		EXEC(@sSQL)
		
		SELECT	
		UI.UserInfoId AS UserInfoId, 
		Company.CompanyName AS tra_grd_16039 /*CompanyName*/,
		UI.ContactPerson AS tra_grd_16040 /*ContactPerson*/,
		UI.DesignationText AS tra_grd_16041 /*Designation*/,
		tmpPUE.DocumentViewedDate AS tra_grd_16042 /*DocumentViewedDate*/,
		tmpPUE.DocumentAgreedDate AS tra_grd_16043 /*DocumentAgreedDate*/,
		PD.DocumentViewFlag AS DocumentViewFlag,
		PD.DocumentViewAgreeFlag AS DocumentViewAgreeFlag
		FROM	#tmpList T 
		INNER JOIN usr_UserInfo UI ON T.EntityID = UI.UserInfoId
		INNER JOIN mst_Company Company ON UI.CompanyId = Company.CompanyId 
		INNER JOIN #tmpPolicyUserEvents tmpPUE ON UI.UserInfoId = tmpPUE.UserInfoId 
		INNER JOIN rul_PolicyDocument PD ON PD.PolicyDocumentId = @inp_nPolicyDocumentId
		WHERE	1=1 
		AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		RETURN 0
		
	END TRY
	
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_POLICY_DOCUMENT_APPLICABILITY_LIST_CORPORATE
	END CATCH
	
	--Delete the temporary table
	DROP TABLE #tmpPolicyUserEvents
END