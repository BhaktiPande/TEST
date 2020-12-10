IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_InitialTransactionDetailsListForRelative_OS')
DROP PROCEDURE [dbo].[st_tra_InitialTransactionDetailsListForRelative_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_InitialTransactionDetailsListForRelative_OS]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iTransactionMasterId	INT
	,@inp_iIsForLetter			INT
	,@inp_isFromView			VARCHAR(25)
	,@inp_nUserInfoId			INT=0
	,@inp_nUserTypeCodeId		INT=0
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_TRANSACTIONDETAILS_LIST INT = 16016 -- Error occurred while fetching list of transactions.
	
	DECLARE @nDisclosureType_Initial INT = 147001
	DECLARE @nDisclosureType_PeriodEnd INT = 147003
	
	DECLARE @dtPeriodEndDate DATETIME
	DECLARE @nDisclosureTypeCodeId INT
	DECLARE @nUserInfoId INT
	
	DECLARE @nEventCodeID_InitDetailsSubmitted INT = 153007
	DECLARE @nEventCodeID_ContiDetailsSubmitted INT = 153019
	
	DECLARE @nTranStatus_NotConfirm INT = 148002
	DECLARE @nTranStatus_DocUpload INT = 148001
	DECLARE @nTranStatus_Submitted INT = 148007
	DECLARE @nTranStatus_SoftCopySubmit INT = 148004
	DECLARE @nTranStatus_HardCopySubmit INT = 148005
	DECLARE @nTranStatus_StockExSubmit INT = 148006
	DECLARE @nTranStatus_Confirm INT = 148003
	
	DECLARE @SECURITY_TYPE_SHARES INT = 139001
	DECLARE @SECURITY_TYPE_WARRANTS INT = 139002
	DECLARE @SECURITY_TYPE_CONVERTABLEDEBENTURES INT = 139003
	DECLARE @SECURITY_TYPE_FUTURECONTRACTS INT = 139004
	DECLARE @SECURITY_TYPE_OPTIONCONTRACTS INT = 139005
	DECLARE @nUserType_Corporate INT = 101004
	
	DECLARE @TRANSACTION_TYPE_BUY INT = 143001
	DECLARE @TRANSACTION_TYPE_SELL INT = 143002
	
	DECLARE @bShowOriginalUserDetails BIT = 1
	DECLARE @bFormDetailsFlag BIT = 0 -- default flag used to get user details saved for transaction

	DECLARE @nTradingPolicy INT
	DECLARE @nDisclosureType_Continuous INT = 147002

	DECLARE @nSecuritiesPriorToAcquisition DECIMAL(20,0) = NULL
	DECLARE @nSecuritiesPostToAcquisition DECIMAL(20,0) = NULL
	DECLARE @nPerOfSharesPreTransaction DECIMAL(5,2) = NULL
	DECLARE @nPerOfSharesPostTransaction DECIMAL(5,2) = NULL

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
		--SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'

		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField = 'dis_grd_52020'
		BEGIN 
			SELECT @inp_sSortField = 'TD.TransactionDetailsId '
		END 
			
		--print @sSQL
		--SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',TD.TransactionDetailsId),TD.TransactionDetailsId '
		--SELECT @sSQL = @sSQL + ' FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId '
		--SELECT @sSQL = @sSQL + ' JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId '
		--SELECT @sSQL = @sSQL + ' JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID '
		--SELECT @sSQL = @sSQL + ' JOIN com_Code CModeOfAcq ON TD.ModeOfAcquisitionCodeId = CModeOfAcq.CodeID '
		--SELECT @sSQL = @sSQL + ' JOIN com_Code CExchange ON TD.ExchangeCodeId = CExchange.CodeID '
		--SELECT @sSQL = @sSQL + ' JOIN com_Code CTransactionType ON TD.TransactionTypeCodeId = CTransactionType.CodeID '
		--SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CCountry ON UF.CountryId = CCountry.CodeID '
		--SELECT @sSQL = @sSQL + ' LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative '
		--SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID '
		--SELECT @sSQL = @sSQL + ' WHERE TD.TransactionMasterId = ' + CAST(@inp_iTransactionMasterId AS VARCHAR(15))
		--SELECT @sSQL = @sSQL + ' and 1 = 1 '
		
		
		--PRINT(@sSQL)
		--EXEC(@sSQL)
			
		DECLARE @dtDateofBecomingInsider datetime
		SELECT @dtDateofBecomingInsider=DateOfBecomingInsider from usr_UserInfo where UserInfoId=@inp_nUserInfoId
		
			
		DECLARE @nCheckIDforEmpInsider INT=0		
		SELECT @nCheckIDforEmpInsider=COUNT(TM.TransactionMasterId) FROM tra_TransactionMaster_OS TM WHERE TM.UserInfoId=@inp_nUserInfoId AND TM.InsiderIDFlag in (0,1) AND TM.DisclosureTypeCodeId=147001
		
		IF((@inp_isFromView!='Employee') AND @inp_nUserTypeCodeId=101003 and @nCheckIDforEmpInsider>1)
		BEGIN
		print(1)		
		SELECT	
		ISNULL(UF.FirstName,'')+ISNULL(UF.MiddleName,'')+ISNULL(UF.LastName,'') AS dis_grd_52020,
		CRelation.CodeName AS dis_grd_52021,
		UF.PAN AS dis_grd_52022,
		DD.DMATDetailsID AS relDmatId,
		DD.DEMATAccountNumber AS dis_grd_52023,
		DD.DPBank AS dis_grd_52024,
		DD.DPID AS dis_grd_52025,
		DD.TMID AS dis_grd_52026,
		NULL AS dis_grd_52027,								
		SUM(TD.Quantity) AS dis_grd_52028,	
		SUM(TD.Value) AS dis_grd_52029,
		SUM(TD.LotSize) AS dis_grd_52030,
		NULL AS dis_grd_52031,
		TD.SecurityTypeCodeId AS SecurityTypeCodeId,
		--TD.TransactionMasterId AS TransId,
		TD.ForUserInfoId AS RelUserInfoId ,
		CSecurityType.CodeName AS dis_grd_52044,
		RMC.CompanyName AS dis_grd_52045,
		TD.CompanyId AS CompanyId				
		FROM	tra_TransactionDetails_OS TD		
		JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId
		JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId
		LEFT JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID
		LEFT JOIN usr_UserRelation UR ON  TD.ForUserInfoId = UR.UserInfoIdRelative
		LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
		LEFT JOIN rl_CompanyMasterList RMC ON RMC.RlCompanyId=TD.CompanyId
		LEFT JOIN com_Code CSecurityType on TD.SecurityTypeCodeId=CSecurityType.CodeID
		WHERE TD.TransactionMasterId in(
		
				SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD
				ON TM.TransactionMasterId=TD.TransactionMasterId
				WHERE TM.UserInfoId=@inp_nUserInfoId AND TD.DateOfAcquisition<=@dtDateofBecomingInsider
				UNION
				SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD
				ON TM.TransactionMasterId=TD.TransactionMasterId
				WHERE TM.UserInfoId IN(SELECT usr_UserRelation.UserInfoIdRelative AS UserInfoId FROM usr_UserInfo
				JOIN usr_UserRelation ON usr_UserInfo.UserInfoId=usr_UserRelation.UserInfoId
				WHERE usr_UserInfo.UserInfoId=@inp_nUserInfoId)
				AND TD.DateOfAcquisition<=@dtDateofBecomingInsider	
				UNION
				SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM JOIN usr_UserInfo UI
				on TM.UserInfoId=UI.UserInfoId
				WHERE TM.UserInfoId=@inp_nUserInfoId and UI.DateOfBecomingInsider IS NULL
				UNION
				SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM JOIN usr_UserInfo UI
				on TM.UserInfoId=UI.UserInfoId
				where TM.UserInfoId IN(SELECT usr_UserRelation.UserInfoIdRelative AS UserInfoId FROM usr_UserInfo
				JOIN usr_UserRelation ON usr_UserInfo.UserInfoId=usr_UserRelation.UserInfoId
				WHERE usr_UserInfo.UserInfoId=@inp_nUserInfoId)
				and UI.DateOfBecomingInsider IS NULL
				
				) 
		AND ForUserInfoId IN(SELECT usr_UserRelation.UserInfoIdRelative AS UserInfoId FROM usr_UserRelation WHERE UserInfoID=@inp_nUserInfoId)
		GROUP BY DD.DMATDetailsID,DD.DEMATAccountNumber,DD.DPBank,DD.DPID,DD.TMID,UF.FirstName,UF.MiddleName,UF.LastName,CRelation.CodeName,UF.PAN,
		--TD.TransactionMasterId,
		TD.ForUserInfoId,TD.SecurityTypeCodeId,CSecurityType.CodeName,RMC.CompanyName,TD.CompanyId
		END
		ELSE
		BEGIN 
		
		CREATE TABLE #tmpUserRelDmat
		(
		ID int identity(1,1),
		RelativeName nvarchar(500),
		RelativeType varchar(50),
		PAN varchar(20),
		DmatId int,
		DmatAccNo nvarchar(50),
		DPBank nvarchar(200),
		DPID varchar(50),
		TMID varchar(50),
		RelUserInfoId int,
		RelTransID int
		)
		
		DECLARE @whereclause1 NVARCHAR(MAX)
		IF(@inp_nUserTypeCodeId=101003)
		BEGIN		
		SET @whereclause1 = ' UR.UserInfoId= ' + CAST(@inp_nUserInfoId AS VARCHAR(15)) + ' '
		END
		ELSE
		BEGIN		
		SET @whereclause1 = ' UR.UserInfoIdRelative= ' + CAST(@inp_nUserInfoId AS VARCHAR(15)) + ' '
		END
		
		DECLARE @nCheckCount INT=0		
		DECLARE @RowNum INT=0
		SELECT @RowNum=TransactionMasterId  from tra_TransactionMaster_OS where UserInfoId=@inp_nUserInfoId and TransactionStatusCodeId IN(148003,148004,148005,148006,148007) and DisclosureTypeCodeId=147001
		IF(@RowNum=0)
		BEGIN

			INSERT INTO #tmpUserRelDmat
			EXEC('SELECT
			ISNULL(UI.FirstName,'''') + '' '' + ISNULL(UI.MiddleName,'''') + '' '' + ISNULL(UI.LastName,'''') AS RelativeName,
			Code2.CodeName AS RelativeType,
			UI.PAN,UDMAT.DMATDetailsID,UDMAT.DEMATAccountNumber,
			CASE WHEN UDMAT.DPBankCodeId IS NULL THEN UDMAT.DPBank 
			ELSE CASE WHEN Code1.DisplayCode IS NULL OR Code1.DisplayCode = '''' THEN Code1.CodeName ELSE Code1.DisplayCode END
			END AS DPBank, 			
			UDMAT.DPID,UDMAT.TMID,UI.UserInfoId,null			
			FROM 
			usr_UserInfo UI 
			LEFT JOIN usr_DMATDetails UDMAT ON UI.UserInfoID=UDMAT.UserInfoID
			JOIN dbo.usr_UserRelation UR ON UR.UserInfoIdRelative=UI.UserInfoId			
			LEFT JOIN com_Code Code1 ON UDMAT.DPBankCodeId IS NOT NULL AND UDMAT.DPBankCodeId=code1.CodeID
			left JOIN com_Code Code2 ON UR.RelationTypeCodeId=Code2.CodeID
			WHERE (UDMAT.DmatAccStatusCodeId=102001 OR UDMAT.DmatAccStatusCodeId IS NULL) AND
			'+ @whereclause1 +'')
		
		END
		ELSE
		BEGIN
		
			INSERT INTO #tmpUserRelDmat
			EXEC('SELECT
			ISNULL(UI.FirstName,'''') + '' '' + ISNULL(UI.MiddleName,'''') + '' '' + ISNULL(UI.LastName,'''') AS RelativeName,
			Code2.CodeName AS RelativeType,
			UI.PAN,UDMAT.DMATDetailsID,UDMAT.DEMATAccountNumber,
			CASE WHEN UDMAT.DPBankCodeId IS NULL THEN UDMAT.DPBank 
			ELSE CASE WHEN Code1.DisplayCode IS NULL OR Code1.DisplayCode = '''' THEN Code1.CodeName ELSE Code1.DisplayCode END
			END AS DPBank, 
			UDMAT.DPID,UDMAT.TMID,UI.UserInfoId,NULL			
			FROM 
			usr_UserInfo UI 
			LEFT JOIN usr_DMATDetails UDMAT ON UI.UserInfoID=UDMAT.UserInfoID
			JOIN dbo.usr_UserRelation UR ON UR.UserInfoIdRelative=UI.UserInfoId
			LEFT JOIN com_Code Code1 ON UDMAT.DPBankCodeId IS NOT NULL AND UDMAT.DPBankCodeId=code1.CodeID
			left JOIN com_Code Code2 ON UR.RelationTypeCodeId=Code2.CodeID WHERE UDMAT.DmatAccStatusCodeId=102001 AND
			'+ @whereclause1 +'
			AND (UDMAT.DMATDetailsID IN (select TD.DMATDetailsID from tra_TransactionDetails_OS TD
			join tra_TransactionMaster_OS TM on TD.TransactionMasterId=TM.TransactionMasterId
			where UserInfoId='+ @inp_nUserInfoId +'and TM.DisclosureTypeCodeId=147001)
			OR (UI.UserInfoID IN (select TD.ForUserInfoID from tra_TransactionDetails_OS TD
			join tra_TransactionMaster_OS TM on TD.TransactionMasterId=TM.TransactionMasterId
			where UserInfoId='+ @inp_nUserInfoId +'and TM.DisclosureTypeCodeId=147001 and TD.DMATDetailsID IS NULL)))
			')	
		END
	
			SELECT @nCheckCount=ISNULL(COUNT(ID),0) FROM #tmpUserRelDmat		
			IF(@nCheckCount=0 OR @nCheckCount='')
			BEGIN			
				INSERT INTO #tmpUserRelDmat
				EXEC('SELECT
				ISNULL(UI.FirstName,'''') + '' '' + ISNULL(UI.MiddleName,'''') + '' '' + ISNULL(UI.LastName,'''') AS RelativeName,
				Code2.CodeName AS RelativeType,UI.PAN,NULL,NULL,NULL,NULL,NULL,UI.UserInfoId,null			
				FROM 
				usr_UserInfo UI			
				JOIN dbo.usr_UserRelation UR ON UR.UserInfoIdRelative=UI.UserInfoId		
				left JOIN com_Code Code2 ON UR.RelationTypeCodeId=Code2.CodeID
				WHERE 
				'+ @whereclause1 +'')					
			 END

		CREATE TABLE #tmpTransRelDmat
		(
		ID int identity(1,1),
		TransId int,
		TransDmatId int,
		TransPerHolding NVARCHAR(100),
		TransQuantity decimal(10,2),	
		TransValue decimal(10,2),
		TransLotSize decimal(10,2),
		TransContractSpecification nvarchar(max),
		TransSecurityTypeCodeId int,
		Company nvarchar(max),
		TransSecurityName varchar(50),
		CompanyId INT,
		TransUserId INT,
		)
			INSERT INTO #tmpTransRelDmat
			SELECT	
			TD.TransactionDetailsId,
			DD.DMATDetailsID,
			NULL,										
			TD.Quantity,
			TD.Value,
			TD.LotSize,
			TD.ContractSpecification,
			TD.SecurityTypeCodeId ,
			RMC.CompanyName,
			CSecurityType.CodeName,
			TD.CompanyId  AS CompanyId,
			TD.ForUserInfoId					
			FROM	tra_TransactionDetails_OS TD			
			JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId
			JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId
			LEFT JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID	
			LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative
			LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
			LEFT JOIN rl_CompanyMasterList RMC ON RMC.RlCompanyId=TD.CompanyId
			LEFT JOIN com_Code CSecurityType on TD.SecurityTypeCodeId=CSecurityType.CodeID
			WHERE TD.TransactionMasterId=@inp_iTransactionMasterId AND TM.UserInfoId=@inp_nUserInfoId 
		

			UPDATE #tmpUserRelDmat  SET RelTransID=#tmpTransRelDmat.TransId
			FROM #tmpUserRelDmat
			JOIN #tmpTransRelDmat ON #tmpUserRelDmat.RelUserInfoId=#tmpTransRelDmat.TransUserId
			where #tmpUserRelDmat.DmatId is null

			UPDATE #tmpUserRelDmat  SET RelTransID=#tmpTransRelDmat.TransId
			FROM #tmpUserRelDmat
			JOIN #tmpTransRelDmat ON #tmpUserRelDmat.DmatId=#tmpTransRelDmat.TransDmatId

				DECLARE @nUserCount INT=0
				DECLARE @nUserTotCount INT=0
				SELECT @nUserTotCount=COUNT(ID) FROM #tmpUserRelDmat
				WHILE @nUserCount<@nUserTotCount
				BEGIN
					DECLARE @nCheckDmatId INT
					DECLARE @nusrId INT
					SELECT @nusrId=RelUserInfoId FROM #tmpUserRelDmat WHERE ID=@nUserCount+1
					SELECT @nCheckDmatId=DmatId FROM #tmpUserRelDmat WHERE RelUserInfoId=@inp_nUserInfoId
					IF(@nCheckDmatId  IS NOT NULL OR @nCheckDmatId!='')
					BEGIN
						DELETE FROM #tmpTransRelDmat WHERE TransDmatId IS NULL AND TransUserId=@nusrId
					END
					SET @nUserCount=@nUserCount+1
				END	

			--SELECT * FROM #tmpUserRelDmat
			--SELECT * FROM #tmpTransRelDmat

			SELECT TUD.RelativeName AS 'dis_grd_52020',TUD.RelativeType AS 'dis_grd_52021',TUD.PAN AS 'dis_grd_52022',
			TTD.TransId AS TransactionDetailsId, TUD.DmatId AS relDmatId,ISNULL(TUD.DmatAccNo,'NA') AS dis_grd_52023,ISNULL(TUD.DPBank,'NA') AS dis_grd_52024,ISNULL(TUD.DPID,'NA') AS dis_grd_52025,ISNULL(TUD.TMID,'NA') AS dis_grd_52026 ,
			ISNULL(TTD.TransPerHolding,'NA') AS dis_grd_52027,ISNULL(TTD.TransQuantity,0) AS dis_grd_52028,ISNULL(TTD.TransValue,0) AS dis_grd_52029,TUD.RelUserInfoId,ISNULL(TTD.TransLotSize,0) AS dis_grd_52030,ISNULL(TTD.TransContractSpecification,'') AS dis_grd_52031,
			TTD.TransSecurityTypeCodeId AS SecurityTypeCodeId,ISNULL(TTD.TransSecurityName,'NA') AS dis_grd_52044 ,ISNULL(TTD.Company,'NA') AS dis_grd_52045,TTD.CompanyId AS CompanyId
			FROM #tmpUserRelDmat TUD
			JOIN #tmpTransRelDmat TTD ON TTD.TransDmatId=TUD.DmatId AND TTD.TransDmatId IS NOT NULL

			UNION

			SELECT TUD.RelativeName AS 'dis_grd_52020',TUD.RelativeType AS 'dis_grd_52021',TUD.PAN AS 'dis_grd_52022',
			TTD.TransId AS TransactionDetailsId, TUD.DmatId AS relDmatId,isnull(TUD.DmatAccNo,'NA') AS dis_grd_52023,ISNULL(TUD.DPBank,'NA') AS dis_grd_52024,ISNULL(TUD.DPID,'NA') AS dis_grd_52025,ISNULL(TUD.TMID,'NA') AS dis_grd_52026 ,
			ISNULL(TTD.TransPerHolding,'NA') AS dis_grd_52027,ISNULL(TTD.TransQuantity,0) AS dis_grd_52028,ISNULL(TTD.TransValue,0) AS dis_grd_52029,TUD.RelUserInfoId,ISNULL(TTD.TransLotSize,0) AS dis_grd_52030,ISNULL(TTD.TransContractSpecification,'') AS dis_grd_52031,
			TTD.TransSecurityTypeCodeId AS SecurityTypeCodeId,ISNULL(TTD.TransSecurityName,'NA') AS dis_grd_52044 ,ISNULL(TTD.Company,'NA') AS dis_grd_52045,TTD.CompanyId AS CompanyId
			FROM #tmpUserRelDmat TUD
			JOIN #tmpTransRelDmat TTD ON TTD.TransId=TUD.RelTransID AND TTD.TransDmatId IS NULL
					
			DROP TABLE #tmpUserRelDmat
			DROP TABLE #tmpTransRelDmat		
		END
		
	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TRANSACTIONDETAILS_LIST
	END CATCH
END

