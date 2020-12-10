IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceListForCO_OS')
DROP PROCEDURE dbo.st_tra_PreclearanceListForCO_OS
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Preclearance Request/Continuous Disclosure list for CO.

Returns:		0, if Success.
				
Created by:		Priyanka	
Created on:		06-Mar-2019

Usage:
EXEC st_tra_ContinuousDisclosureListByCO
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_PreclearanceListForCO_OS]
	@inp_iPageSize							INT = 10
	,@inp_iPageNo							INT = 1
	,@inp_sSortField						VARCHAR(255)
	,@inp_sSortOrder						VARCHAR(5)
	,@inp_sEmployeeID						NVARCHAR(50)
	,@inp_sCompanyID						NVARCHAR(MAX)
	,@inp_sDesignation						NVARCHAR(MAX)
	,@inp_iPreclearanceCodeID				NVARCHAR(MAX) --Search param
	,@inp_iPreclearanceRequestStatus		INT --Search param
	,@inp_iTransactionType					INT --Search param
	,@inp_iTransactionTradeStatus			INT --Search param
	,@out_nReturnValue						INT = 0				OUTPUT
	,@out_nSQLErrCode						INT = 0				OUTPUT	-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage					VARCHAR(500) = ''	OUTPUT	-- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL							NVARCHAR(MAX) = ''
	DECLARE @ERR_PRECLEARANCE_LIST_NON_IMPLEMENTING_COMPANY	INT = 17484 --Error occurred while fetching list of PreClearance Request details of NonImplementing company. 			
	
	DECLARE @sPrceclearanceCodePrefixText		 VARCHAR(3)
	DECLARE @sNonPrceclearanceCodePrefixText	 VARCHAR(3)
	DECLARE @sPrceclearanceNotRequiredPrefixText VARCHAR(200)

	DECLARE @nPreclearanceRequestMapToType		INT = 132015 --MapToType of Preclearance for NonImplementing company
	DECLARE @nDisclosureMapToType INT= 132005

	-- Resource Variable
	DECLARE @sPendingButtonText				    VARCHAR(10)
	DECLARE @sApproveButtonText					VARCHAR(10)
	DECLARE @sRejectedButtonText				VARCHAR(10)
	DECLARE @sPartiallyTradedButtonText         VARCHAR(20)
	DECLARE @sNotTradedButtonText               VARCHAR(10)
	DECLARE @sUploadedButtonText               VARCHAR(10)
	DECLARE @sNotRequiredText	VARCHAR(30)

	DECLARE @nPreclearanceTakenCase INT = 176001
	DECLARE @nInsiderNotPreclearanceTakenCase INT = 176002
	DECLARE @nNonInsiderNotPreclearanceTakenCase INT = 176003
		
	DECLARE	@nContinousDisclosureType INT = 147002	
	DECLARE @nEventPreclearanceApproved INT = 153046
	DECLARE @nEventPreclearanceRequested INT = 153045
	DECLARE @nEventPreclearanceRejected	INT = 153047
	DECLARE @nEventPreclearanceExpire INT = 153067
	DECLARE @nEventContinuousDisclosureDetailsEntered INT = 153057
	DECLARE	@nEventContinuousDisclosureUploaded INT = 153058
	DECLARE @nEventContinuousDisclosureSubmittedSoftcopy INT= 153059
	DECLARE @nEventContinuousDisclosureSubmittedHardcopy INT = 153060

	DECLARE @nUploadedStatus INT = 154006
	DECLARE @nApproveStatus	INT = 154001
	DECLARE @nPendingStatus	INT = 154002
	DECLARE @nPartiallyTradedStatus	INT = 154004
	DECLARE @nNotTradedStatus INT = 154005

	DECLARE @nEmployeeStatusLive            VARCHAR(100),
			@nEmployeeStatusSeparated       VARCHAR(100),
			@nEmployeeStatusInactive        VARCHAR(100),
			@nEmpStatusLiveCode             INT = 510001,
			@nEmpStatusSeparatedCode        INT = 510002,
			@nEmpStatusInactiveCode         INT = 510003,
			@nEmployeeActive                INT = 102001,
			@nEmployeeInActive              INT = 102002
	DECLARE @nPendingTransType INT = 148002		

	--Pending Button Text
	SELECT @sPendingButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17005'
	--Approve Button Text
	SELECT @sApproveButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17023'
	--Reject Button Text
	SELECT @sRejectedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17024'

	SELECT @sPartiallyTradedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17073'

	SELECT @sNotTradedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17074'

	SELECT @sUploadedButtonText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17075'

	SELECT @sNotRequiredText = ResourceValue FROM mst_Resource WHERE ResourceKey = 'dis_btn_17334'

	--Set the Prefix to display for Preclearance ID
	SET	@sPrceclearanceCodePrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nPreclearanceTakenCase)
	SET @sNonPrceclearanceCodePrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nInsiderNotPreclearanceTakenCase)
	SET @sPrceclearanceNotRequiredPrefixText = (SELECT CodeName FROM com_Code Where CodeId = @nNonInsiderNotPreclearanceTakenCase)

	SELECT @nEmployeeStatusLive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusLiveCode	
	SELECT @nEmployeeStatusSeparated = CodeName FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode		
	SELECT @nEmployeeStatusInactive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusInactiveCode
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
	
		CREATE TABLE #tmpUsers(Id INT IDENTITY(1,1), IsAddButtonRow INT DEFAULT 0, UserId INT, UserInfoId INT, TransactionMasterID INT,TradingPolicyId INT, PreClearanceRequestID INT,PreclearanceStatus INT,
							   PreclearanceValidTill DATETIME,PreClearanceRequestCode NVARCHAR(MAX),
							   ContinuousDisclousureToBeSubmit INT,ContinuousDisclousureCompletion INT DEFAULT 0,
						       ContinuousDisclosureSubmissionDate DATETIME, ContinuousDisclosureStatus INT,
						       SoftCopyToBeSubmitFlag INT, SoftCopySubmissionFlag INT DEFAULT NULL, SoftcopySubmissionDate DATETIME,
						       HardCopyToBeSubmitFlag INT, HardCopySubmissionFlag INT DEFAULT NULL,HardcopySubmissionDate DATETIME,
						       HardcopySubmissionwithin INT DEFAULT NULL,
						       HardCopySubmitCOToExchangeFlag INT,HardCopySubmissionCOToExchangeFlag INT DEFAULT NULL,
						       HardCopySubmitCOToExchangeDate DATETIME NULL,HardCopySubmitCOToExchangeWithin INT DEFAULT NULL,
						       TradedQty DECIMAL(10,0),DisplaySequenceNo INT, IdCount BIGINT,IsEnterAndUploadEvent INT DEFAULT 0, IndividualTradedValue INT,ReasonForNotTradingCodeId INT
							   ,EmployeeID VARCHAR(50) NULL,CompanyID INT,DEMATID INT,DisplayNumber INT)
		
		DELETE TM
		FROM tra_TransactionMaster_OS TM LEFT JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
		WHERE DisclosureTypeCodeId = @nContinousDisclosureType AND TransactionStatusCodeId = @nPendingTransType 
		AND (TM.PreclearanceRequestId IS NULL OR (TM.PreclearanceRequestId IS NOT NULL AND TM.ParentTransactionMasterId IS NOT NULL)) AND TD.TransactionMasterId IS NULL

		INSERT INTO #tmpUsers(UserInfoId,UserId,TransactionMasterID,TradingPolicyId,PreClearanceRequestID,PreClearanceRequestCode,IdCount,EmployeeID,CompanyID ,DEMATID) 
		SELECT TM.UserInfoId,TM.UserInfoId,TransactionMasterId,TradingPolicyId,PR.PreclearanceRequestId,
					CASE WHEN TM.PreclearanceRequestId IS NULL THEN 
					CASE WHEN UF.DateOfBecomingInsider IS NOT NULL THEN
					   CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sNonPrceclearanceCodePrefixText ELSE @sNonPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END  
					 ELSE
						CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sPrceclearanceNotRequiredPrefixText ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END END
					ELSE 
					  CASE WHEN PR.DisplaySequenceNo IS NULL THEN @sPrceclearanceCodePrefixText ELSE  @sPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),PR.DisplaySequenceNo) END END,
					ISNULL(TM.ParentTransactionMasterId, TM.TransactionMasterId),
					UF.EmployeeId,
					PR.CompanyId,
					PR.DMATDetailsID
			FROM tra_TransactionMaster_OS TM
			LEFT JOIN	tra_PreclearanceRequest_NonImplementationCompany PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
			JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
			WHERE DisclosureTypeCodeId = @nContinousDisclosureType

		UPDATE tmpUser
		SET CompanyID = TD.CompanyId,DEMATID = TD.DMATDetailsID,UserInfoId = TD.ForUserInfoId
		FROM #tmpUsers tmpUser 
		JOIN tra_TransactionMaster_OS TM ON tmpUser.TransactionMasterID = TM.TransactionMasterId
		JOIN tra_TransactionDetails_OS TD ON TD.TransactionMasterId= TM.TransactionMasterId

		UPDATE tmpUser
		SET TradedQty = TD.Qty
		FROM #tmpUsers tmpUser JOIN 
			(SELECT TM.TransactionMasterId, SUM(TD.Quantity * (CASE WHEN LotSize = 0 or LotSize IS NULL THEN 1 ELSE LotSize END)) Qty
				FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
				JOIN usr_UserInfo U ON U.UserInfoId = TM.UserInfoId
				GROUP BY TM.TransactionMasterId) TD ON tmpUser.TransactionMasterID = TD.TransactionMasterId
			
		UPDATE tmpUser
		SET IndividualTradedValue = TD.TradedValue
		FROM #tmpUsers tmpUser JOIN 
			(SELECT TM.TransactionMasterId, SUM(TD.Value) TradedValue
				FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
				JOIN usr_UserInfo U ON U.UserInfoId = TM.UserInfoId
				GROUP BY TM.TransactionMasterId) TD ON tmpUser.TransactionMasterID = TD.TransactionMasterId
		
		UPDATE T
		SET PreclearanceStatus = CASE WHEN EL.EventLogId IS NULL THEN 0 ELSE EL.EventCodeId END
		FROM #tmpUsers T JOIN 
			(SELECT MapToId, MAX(EventLogId) AS EventLogId
			FROM #tmpUsers t1 JOIN eve_EventLog EL ON t1.PreClearanceRequestID = EL.MapToId AND MapToTypeCodeId = @nPreclearanceRequestMapToType
			WHERE EventCodeId in (@nEventPreclearanceRequested, @nEventPreclearanceApproved, @nEventPreclearanceRejected)
			GROUP BY MapToId
			) ELI ON t.PreClearanceRequestID = ELI.MapToId
			JOIN eve_EventLog EL ON ELI.EventLogId = EL.EventLogId

		UPDATE T
		SET PreclearanceValidTill = EL.EventDate
		FROM #tmpUsers T 
		JOIN eve_EventLog EL ON t.UserInfoId = EL.UserInfoId 
		JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON T.PreClearanceRequestID = PR.PreclearanceRequestId
		JOIN rul_TradingPolicy_OS TP ON T.TradingPolicyId = TP.TradingPolicyId
		WHERE   t.PreClearanceRequestID = EL.MapToId 
			AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType 
			AND EL.EventCodeId IN(@nEventPreclearanceExpire)

		UPDATE T
		SET PreclearanceValidTill = (select dbo.uf_tra_GetNextTradingDateOrNoOfDaysforPreClerance_OS(EL.EventDate,PreClrCOApprovalLimit,null,1,1,0,116001))
		FROM #tmpUsers T 
		JOIN eve_EventLog EL ON t.UserInfoId = EL.UserInfoId 
		JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON T.PreClearanceRequestID = PR.PreclearanceRequestId
		JOIN rul_TradingPolicy_OS TP ON T.TradingPolicyId = TP.TradingPolicyId 
		WHERE t.PreClearanceRequestID = EL.MapToId 
		    AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType 
		    AND EL.EventCodeId IN(@nEventPreclearanceRequested)
		    AND EL.EventCodeId NOT IN(@nEventPreclearanceApproved,@nEventPreclearanceRejected)
		    AND PR.PreclearanceStatusCodeId = 144001

		UPDATE T
		SET ContinuousDisclousureToBeSubmit = 1
		FROM #tmpUsers T 
		JOIN eve_EventLog EL ON t.UserId = EL.UserInfoId 
		     AND ((T.PreClearanceRequestID IS NULL) OR t.PreClearanceRequestID = EL.MapToId 
		     AND EL.MapToTypeCodeId = @nPreclearanceRequestMapToType 
		     AND EL.EventCodeId IN (@nEventPreclearanceApproved))

		--UPDATE t
		--SET ContinuousDisclousureCompletion = 2,
		--	ContinuousDisclosureSubmissionDate = EL.EventDate,
		--	ContinuousDisclosureStatus =  @nUploadedStatus,
		--	IsEnterAndUploadEvent = 1
		--FROM #tmpUsers t 
		--JOIN eve_EventLog EL ON EL.MapToId = t.TransactionMasterID AND EL.MapToTypeCodeId  = @nDisclosureMapToType 
		--WHERE EL.EventCodeId = @nEventContinuousDisclosureUploaded   
		
		UPDATE t
		SET ContinuousDisclousureCompletion = 1,
			ContinuousDisclosureSubmissionDate = EL.EventDate,
			ContinuousDisclosureStatus = @nApproveStatus,
			IsEnterAndUploadEvent = IsEnterAndUploadEvent + 1
		FROM #tmpUsers t 
		JOIN eve_EventLog EL ON EL.MapToId = t.TransactionMasterID AND EL.MapToTypeCodeId  = @nDisclosureMapToType 
		WHERE EL.EventCodeId = @nEventContinuousDisclosureDetailsEntered

		--/*
		--	1. ContinuousDisclosureStatus :- update status if Trading details entered must and insider doesnot entered trade details
		--										then set status Pending
		--*/	
		UPDATE t
		SET ContinuousDisclosureStatus =  @nPendingStatus
		FROM #tmpUsers t 
		WHERE ContinuousDisclousureToBeSubmit = 1 AND ContinuousDisclousureCompletion = 0

		-- Update flag for soft copy to be submitted as per set in the trading policy applicable to user
		update t
		SET SoftCopyToBeSubmitFlag = TP.StExSubmitDiscloToCOByInsdrSoftcopyFlag
		FROM #tmpUsers t JOIN rul_TradingPolicy_OS TP ON t.TradingPolicyId = TP.TradingPolicyId

		-- Update Soft Copy submission status flag based on Event Log
		update t
		SET SoftCopySubmissionFlag = CASE WHEN EL.EventLogId IS NULL 
		                          THEN CASE  WHEN tm.SoftCopyReq  = 0 THEN 2 ELSE 0 END ELSE 1 END,
			SoftcopySubmissionDate = EL.EventDate
		FROM #tmpUsers t 
		LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
		AND EL.EventCodeId IN (@nEventContinuousDisclosureSubmittedSoftcopy) 
		AND MapToTypeCodeId = @nDisclosureMapToType
		JOIN tra_TransactionMaster_OS TM ON t.TransactionMasterID = TM.TransactionMasterId
		 WHERE ((ContinuousDisclousureCompletion = 1 AND TM.SoftCopyReq = 1) 
		      OR (ContinuousDisclousureCompletion = 1 AND TM.SoftCopyReq = 0))
		
		-- Update Flag If HardCopy is required as per the policy applicable
		-- for user
		update t
		SET HardCopyToBeSubmitFlag = TP.StExSubmitDiscloToCOByInsdrHardcopyFlag
		FROM #tmpUsers t JOIN rul_TradingPolicy_OS TP ON t.TradingPolicyId = TP.TradingPolicyId
		
		-- Update Hard Copy submission status flag based on Event Log	
		update t
		SET HardCopySubmissionFlag = CASE WHEN EL.EventLogId IS NULL THEN CASE WHEN TM.HardCopyReq = 0 THEN 2 ELSE 0 END ELSE 1 END,
			HardcopySubmissionDate = EL.EventDate
		FROM #tmpUsers t 
		LEFT JOIN eve_EventLog EL ON t.TransactionMasterID = EL.MapToId 
		AND EL.EventCodeId IN (@nEventContinuousDisclosureSubmittedHardcopy) AND MapToTypeCodeId = @nDisclosureMapToType
		JOIN tra_TransactionMaster_OS TM ON t.TransactionMasterID = TM.TransactionMasterId
		WHERE (SoftCopySubmissionFlag = 1 AND TM.HardCopyReq = 1) 
		OR (TM.HardCopyReq = 1 AND (SoftCopyToBeSubmitFlag IS NULL OR SoftCopyToBeSubmitFlag = 0) 
		AND ContinuousDisclousureCompletion = 1)
		OR (TM.HardCopyReq = 0 AND SoftCopySubmissionFlag = 1)
		OR (TM.HardCopyReq = 0 AND (SoftCopyToBeSubmitFlag IS NULL OR SoftCopyToBeSubmitFlag = 0) 
		AND ContinuousDisclousureCompletion = 1)
		OR (TM.HardCopyReq = 0 AND SoftCopySubmissionFlag = 2 
		AND ContinuousDisclousureCompletion = 1)
		--/*
		--	1. ContinuousDisclosureStatus :- In case Insider Not Traded Then set status @nNotTradedStatus
		--*/	
		UPDATE T
		SET	ContinuousDisclosureStatus = @nNotTradedStatus
		FROM #tmpUsers T
		LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON t.PreClearanceRequestID = PR.PreclearanceRequestId
		WHERE PR.IsPartiallyTraded = 2

		INSERT INTO #tmpUsers(UserInfoId,UserId,PreClearanceRequestID, PreClearanceRequestCode,TransactionMasterID,TradingPolicyId, IsAddButtonRow,PreclearanceStatus,ContinuousDisclosureStatus,IdCount,EmployeeID,CompanyID,DEMATID)
		SELECT  PR.UserInfoId,PR.UserInfoId
		        ,PR.PreclearanceRequestId,
			CASE WHEN TM.PreclearanceRequestId IS NULL THEN 
					CASE WHEN UF.DateOfBecomingInsider IS NOT NULL THEN
					   CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sNonPrceclearanceCodePrefixText ELSE @sNonPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END  
					 ELSE
						CASE WHEN TM.DisplayRollingNumber IS NULL THEN @sPrceclearanceNotRequiredPrefixText ELSE @sPrceclearanceNotRequiredPrefixText + CONVERT(NVARCHAR(MAX),TM.DisplayRollingNumber) END END
					ELSE 
					  CASE WHEN PR.DisplaySequenceNo IS NULL THEN @sPrceclearanceCodePrefixText ELSE  @sPrceclearanceCodePrefixText + CONVERT(NVARCHAR(MAX),PR.DisplaySequenceNo) END END,
				0,
				TM.TradingPolicyId,
				1,
				153046,
				154004,TM.TransactionMasterId,
				UF.EmployeeID,
				PR.CompanyId,
				PR.DMATDetailsID
		FROM tra_PreclearanceRequest_NonImplementationCompany PR 
		JOIN tra_TransactionMaster_OS TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId AND ParentTransactionMasterId IS NULL
		JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
		WHERE IsPartiallyTraded = 1  AND PreclearanceStatusCodeId = 144002 AND (ShowAddButton = 1 OR ReasonForNotTradingCodeId IS NOT NULL) 

		UPDATE  #tmpUsers
		SET DisplayNumber = 1	
		FROM #tmpUsers t
		WHERE t.Id = ( select TOP 1 Id from #tmpUsers t1 
		JOIN tra_TransactionMaster_OS TM ON TM.TransactionMasterId = t1.TransactionMasterID
		WHERE t1.TransactionMasterID = t.TransactionMasterID AND IsAddButtonRow = 0 AND TM.ParentTransactionMasterId IS NULL
		      AND t.PreClearanceRequestID IS NOT NULL ORDER BY IsAddButtonRow DESC,Id ASC)

		UPDATE  #tmpUsers
		SET DisplayNumber = 1 
		FROM #tmpUsers t
		WHERE t.Id = ( select TOP 1 Id from #tmpUsers t1 
		      WHERE t1.TransactionMasterID = t.TransactionMasterID 
		      AND t.PreClearanceRequestID IS NULL ORDER BY IsAddButtonRow DESC,Id ASC)

		----Set default sort order
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'DESC '
		END
		
		--set default sort field
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'Temp.IdCount '
		END
		---- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT ROW_NUMBER() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +'),Temp.Id '
		SELECT @sSQL = @sSQL + ' FROM #tmpUsers Temp '
		SELECT @sSQL = @sSQL + ' LEFT JOIN tra_TransactionMaster_OS TM ON Temp.TransactionMasterID = TM.TransactionMasterID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON Temp.PreClearanceRequestID = PR.PreclearanceRequestId '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '

		IF(@inp_sEmployeeID IS NOT NULL OR @inp_sEmployeeID <> 0)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.EmployeeID like ''%' + CONVERT(VARCHAR,@inp_sEmployeeID) + '%'''
		END

		IF(@inp_sCompanyID IS NOT NULL OR @inp_sCompanyID <> 0)
		BEGIN
				--SELECT @sSQL = @sSQL + ' AND PR.CompanyID like ''%' + CONVERT(VARCHAR,@inp_sCompanyID) + '%'''
				SELECT @sSQL = @sSQL + ' AND PR.CompanyID = ' + CONVERT(VARCHAR,@inp_sCompanyID) + ''
		END

		IF(@inp_iPreclearanceCodeID IS NOT NULL OR @inp_iPreclearanceCodeID <> 0)
		BEGIN
				SELECT @sSQL = @sSQL + ' AND Temp.PreClearanceRequestCode like ''%' + CONVERT(VARCHAR,@inp_iPreclearanceCodeID) + '%'''
		END
		
		IF(@inp_iPreclearanceRequestStatus IS NOT NULL OR @inp_iPreclearanceRequestStatus <> 0)
		BEGIN
			--PreclearanceStatus
			DECLARE @nPreclearanceRequestStatus varchar(100)
			SELECT @nPreclearanceRequestStatus =  CASE WHEN CONVERT(VARCHAR,@inp_iPreclearanceRequestStatus) = 144001 THEN @nEventPreclearanceRequested
				 WHEN CONVERT(VARCHAR,@inp_iPreclearanceRequestStatus) = 144002 THEN @nEventPreclearanceApproved 
				 WHEN CONVERT(VARCHAR,@inp_iPreclearanceRequestStatus) = 144003 THEN @nEventPreclearanceRejected END

			SELECT @sSQL = @sSQL + ' AND Temp.PreclearanceStatus = ' + CONVERT(VARCHAR,@nPreclearanceRequestStatus)
		END

		IF(@inp_iTransactionType IS NOT NULL OR @inp_iTransactionType <> 0)
		BEGIN
			--PreclearanceStatus
			SELECT @sSQL = @sSQL + ' AND PR.TransactionTypeCodeId = ' + CONVERT(VARCHAR,@inp_iTransactionType)
		END
		IF(@inp_iTransactionTradeStatus IS NOT NULL OR @inp_iTransactionTradeStatus <> 0)
		BEGIN
		
			 SELECT @sSQL = @sSQL + ' AND (Temp.ContinuousDisclosureStatus in(154004) AND ShowAddButton=1) or (TransactionStatusCodeId <> 148003 and Temp.ContinuousDisclosureStatus <>154005) '
			
		END
	
		PRINT(@sSQL)
		EXEC(@sSQL)
		--SELECT DISTINCT * FROM #tmpUsers Temp
		--LEFT JOIN tra_TransactionMaster_OS TM ON Temp.TransactionMasterID = TM.TransactionMasterID
		--LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON Temp.PreClearanceRequestID = PR.PreclearanceRequestId  WHERE 1 = 1 
		--and ContinuousDisclosureStatus=154002

		SELECT TempTbl.DisplaySequenceNo AS DisplayCode,
		CASE WHEN URel.UserInfoId IS NULL THEN 
		CASE WHEN U.UserTypeCodeId=101007 THEN ISNULL(U.FirstName,'') + ' '+ISNULL(U.LastName,'')+' (Relative)' ELSE ISNULL(U.FirstName,'') + ' '+ISNULL(U.LastName,'')+' (Self)' END
		 ELSE ISNULL(URel.FirstName,'') +' '+ISNULL(URel.LastName,'')+' ('+CPRNICRequestFor.CodeName+')' END AS dis_grd_53041,--'Request For'
		CASE WHEN URel.UserInfoId IS NULL THEN U.EmployeeId ELSE URel.EmployeeId END AS dis_grd_53034,--'EmployeeID'
		PRNIC.PreclearanceRequestId AS PreclearanceRequestId, 
		CASE WHEN  URel.UserInfoId IS NULL THEN
			CASE WHEN U.StatusCodeId = @nEmployeeActive AND U.DateOfSeparation IS NULL THEN @nEmployeeStatusLive
				        WHEN U.StatusCodeId = @nEmployeeActive AND U.DateOfSeparation IS NOT NULL  THEN @nEmployeeStatusSeparated
				        WHEN U.StatusCodeId = @nEmployeeInActive THEN @nEmployeeStatusSeparated
				        END
			ELSE CASE WHEN URel.StatusCodeId = @nEmployeeActive AND URel.DateOfSeparation IS NULL THEN @nEmployeeStatusLive
				        WHEN URel.StatusCodeId = @nEmployeeActive AND URel.DateOfSeparation IS NOT NULL  THEN @nEmployeeStatusSeparated
				        WHEN URel.StatusCodeId = @nEmployeeInActive THEN @nEmployeeStatusSeparated
			END END AS dis_grd_53035,--Employee Status
		TempTbl.PreClearanceRequestCode AS dis_grd_53040, --'Pre Clearance ID', 
		TempTbl.CompanyId AS CompanyID,--Security Name
		--C.CompanyName   AS dis_grd_53036,--Security Name
		C.CompanyName +' '+'-'+'('+ C.ISINCode + ')' AS dis_grd_53036,--Security Name
		UPPER(REPLACE(CONVERT(VARCHAR(20), PRNIC.CreatedOn, 106), ' ', '/')) AS dis_grd_53042,--'Request Date',
		UD.DEMATAccountNumber AS dis_grd_53037,--Dmat no
		CASE WHEN URel.UserInfoId IS NULL THEN U.PAN ELSE URel.PAN END AS dis_grd_53038,--PAN 
		TempTbl.PreclearanceStatus AS PreclearanceStatusCodeId,
		CASE WHEN TempTbl.PreclearanceStatus  = @nEventPreclearanceRequested THEN @sPendingButtonText 
			 WHEN TempTbl.PreclearanceStatus  = @nEventPreclearanceApproved THEN @sApproveButtonText
			 WHEN TempTbl.PreclearanceStatus  = @nEventPreclearanceRejected THEN @sRejectedButtonText 
		END AS dis_grd_53043,--'PreClearance Status',
		TempTbl.PreclearanceValidTill AS PreclearanceValidTill,
		CASE WHEN PRNIC.PreclearanceRequestId IS NULL 
			     THEN (SELECT CodeName from com_Code where CodeID in(SELECT TOP 1 SecurityTypeCodeId FROM tra_TransactionDetails_OS WHERE TransactionMasterId = TM.TransactionMasterId)) 
			     ELSE CPRNICSecurityType.CodeName END AS dis_grd_53045, --'Securities',
		CASE WHEN PRNIC.PreclearanceRequestId IS NULL 
			     THEN (SELECT TOP 1 SecurityTypeCodeId FROM tra_TransactionDetails_OS WHERE TransactionMasterId = TM.TransactionMasterId) 
			     ELSE CPRNICSecurityType.CodeID END AS SecurityType,
		CASE WHEN PRNIC.PreclearanceRequestId IS NULL 
				THEN 
				 CASE WHEN (SELECT COUNT(TransactionDetailsId) FROM tra_TransactionDetails_OS WHERE TransactionMasterId = TM.TransactionMasterId) = 1  
					THEN (SELECT CodeName FROM com_Code WHERE CodeID IN(SELECT TransactionTypeCodeId FROM tra_TransactionDetails_OS WHERE TransactionMasterId = TM.TransactionMasterId)) 
					ELSE '-' END
				ELSE CPRNICTransactnType.CodeName END AS dis_grd_53044, --'Transaction Type',
		CASE WHEN DisplayNumber = 1  THEN PRNIC.SecuritiesToBeTradedQty ELSE null END AS dis_grd_53046,--'Preclearance Qty' 
		TempTbl.TradedQty AS dis_grd_53047,--'Trade Qty',
		TempTbl.IndividualTradedValue AS dis_grd_53039,--Trade Value
		CASE WHEN TempTbl.ContinuousDisclosureStatus = 154001 THEN CONVERT(VARCHAR,TempTbl.ContinuousDisclosureSubmissionDate)
					  WHEN TempTbl.ContinuousDisclosureStatus = 154002 THEN @sPendingButtonText
					  WHEN TempTbl.ContinuousDisclosureStatus = 154004 THEN @sPartiallyTradedButtonText
					  WHEN TempTbl.ContinuousDisclosureStatus = 154005 THEN @sNotTradedButtonText
					  WHEN TempTbl.ContinuousDisclosureStatus = 154006 THEN @sUploadedButtonText END AS dis_grd_53048,--'Trading Details Submission',
		TempTbl.ContinuousDisclosureStatus AS ContinuousDisclosureStatus,
		TempTbl.ContinuousDisclosureSubmissionDate,
		TempTbl.IsAddButtonRow, 
		CASE WHEN URel.UserInfoId IS NULL THEN U.UserInfoId ELSE URel.UserInfoId END AS UserInfoId,--TempTbl.UserInfoId,
		PRNIC.IsPartiallyTraded,
		PRNIC.ShowAddButton,
		PRNIC.ReasonForNotTradingCodeId,
		TempTbl.SoftcopySubmissionDate,
		TempTbl.HardcopySubmissionDate,
		TempTbl.SoftCopySubmissionFlag AS dis_grd_53049,--'Disclosure Details Submission: Softcopy',
		TempTbl.HardCopySubmissionFlag AS dis_grd_53050 ,--'Disclosure Details Submission: Hardcopy',
		CASE WHEN TempTbl.HardCopySubmissionFlag = 0 THEN @sPendingButtonText 
					  WHEN TempTbl.HardCopySubmissionFlag = 1 THEN CONVERT(VARCHAR,HardcopySubmissionDate) 
					  WHEN TempTbl.HardCopySubmissionFlag = 2 THEN @sNotRequiredText
					  END AS HardcopySubmissionButtonText,
		CASE WHEN TempTbl.SoftCopySubmissionFlag = 0 THEN @sPendingButtonText 
					  WHEN TempTbl.SoftCopySubmissionFlag = 1 THEN CONVERT(VARCHAR,SoftcopySubmissionDate) 
					  WHEN TempTbl.SoftCopySubmissionFlag = 2 THEN @sNotRequiredText
					  END AS SoftcopySubmissionButtonText,
		NULL AS dis_grd_53051,--'Submission to Stock Exchange'
		CASE WHEN GFD.GeneratedFormDetailsId IS NULL THEN 0 ELSE 1 END AS IsFORMEGenrated,
		TP.IsPreclearanceFormForImplementingCompany AS IsPreclearanceFormForImplementingCompany,
		PRNIC.DisplaySequenceNo AS DisplaySequenceNo,
		TempTbl.TransactionMasterID AS TransactionMasterID,
		CASE WHEN URel.UserInfoId IS NULL THEN U.UserTypeCodeId ELSE URel.UserTypeCodeId END AS UserType
		FROM #tmpList T 
		LEFT JOIN #tmpUsers TempTbl ON TempTbl.Id = T.EntityID
		LEFT JOIN tra_TransactionMaster_OS TM ON TM.TransactionMasterId = TempTbl.TransactionMasterID
		LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PRNIC ON TempTbl.PreClearanceRequestID = PRNIC.PreclearanceRequestId
		LEFT JOIN usr_UserInfo U ON U.UserInfoId = TempTbl.UserInfoId
		LEFT JOIN usr_UserRelation UR ON UR.UserInfoIdRelative = PRNIC.UserInfoIdRelative
		LEFT JOIN usr_UserInfo URel ON URel.UserInfoId = UR.UserInfoIdRelative	
		LEFT JOIN com_Code coderelation ON UR.RelationTypeCodeId = coderelation.CodeID
		LEFT JOIN com_Code CPRNICRequestFor ON PRNIC.PreclearanceRequestForCodeId = CPRNICRequestFor.CodeID
		LEFT JOIN usr_DMATDetails UD ON UD.DMATDetailsID = TempTbl.DEMATID
		LEFT JOIN rl_CompanyMasterList C ON C.RlCompanyId = TempTbl.CompanyID
		LEFT JOIN com_Code CPRNICTransactnType ON PRNIC.TransactionTypeCodeId = CPRNICTransactnType.CodeID
		LEFT JOIN com_Code CPRNICSecurityType ON PRNIC.SecurityTypeCodeId = CPRNICSecurityType.CodeID
		JOIN rul_TradingPolicy_OS TP ON TempTbl.TradingPolicyId = TP.TradingPolicyId
		LEFT JOIN tra_GeneratedFormDetails GFD ON PRNIC.DisplaySequenceNo = GFD.MapToId AND GFD.MapToTypeCodeId = 132015
		WHERE ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		RETURN 0
	END	 TRY
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PRECLEARANCE_LIST_NON_IMPLEMENTING_COMPANY
	END CATCH
END
