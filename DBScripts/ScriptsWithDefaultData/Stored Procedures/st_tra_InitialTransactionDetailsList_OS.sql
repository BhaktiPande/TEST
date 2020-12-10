IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_InitialTransactionDetailsList_OS')
DROP PROCEDURE [dbo].[st_tra_InitialTransactionDetailsList_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_InitialTransactionDetailsList_OS]
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
		
		IF @inp_sSortField = 'dis_grd_52011'
		BEGIN 
			SELECT @inp_sSortField = 'TD.TransactionDetailsId '
		END 
			
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
		--EXEC(@sSQL)		-- in case of continuous disclosure which is not submitted, get securities prior and post to acquisition and percent of share pre and post transcation
				
		DECLARE @dtDateofBecomingInsider datetime
		SELECT @dtDateofBecomingInsider=DateOfBecomingInsider from usr_UserInfo where UserInfoId=@inp_nUserInfoId
	
		DECLARE @nCheckIDforEmpInsider INT=0		
		SELECT @nCheckIDforEmpInsider=COUNT(TM.TransactionMasterId) FROM tra_TransactionMaster_OS TM WHERE TM.UserInfoId=@inp_nUserInfoId AND TM.InsiderIDFlag in (0,1) AND TM.DisclosureTypeCodeId=147001
		PRINT(@nCheckIDforEmpInsider)
	
		IF(@inp_nUserTypeCodeId=101003)
		BEGIN		
			IF((@inp_isFromView='Employee' OR @inp_isFromView='Insider') AND @nCheckIDforEmpInsider=1)		
			BEGIN
			PRINT(12)			
				CREATE TABLE #tmpUserDmat
				(
				ID int identity(1,1),
				DmatId int,
				DmatAccNo nvarchar(50),
				DPBank nvarchar(200),
				DPID varchar(50),
				TMID varchar(50),
				UserInfoId int,
				TransId int,
				)		
				
				DECLARE @nCheckCount INT=0
				DECLARE @RowNum INT=0
				SELECT @RowNum=TransactionMasterId  from tra_TransactionMaster_OS where UserInfoId=@inp_nUserInfoId and TransactionStatusCodeId IN(148003,148004,148005,148006,148007) and DisclosureTypeCodeId=147001
				IF(@RowNum=0)
				BEGIN
				PRINT(123)			
					
					INSERT INTO #tmpUserDmat
					SELECT
					UDMAT.DMATDetailsID,UDMAT.DEMATAccountNumber,								
					CASE 
					WHEN UDMAT.DPBankCodeId IS NULL THEN UDMAT.DPBank 
					ELSE CASE WHEN Code1.DisplayCode IS NULL OR Code1.DisplayCode = '' THEN Code1.CodeName ELSE Code1.DisplayCode END
					END AS DPBank, -- DPBank				
					UDMAT.DPID,
					UDMAT.TMID,UI.UserInfoID,null
					FROM 
					usr_UserInfo UI 
					Left JOIN usr_DMATDetails UDMAT ON UI.UserInfoID=UDMAT.UserInfoID
					LEFT JOIN com_Code Code1 ON UDMAT.DPBankCodeId IS NOT NULL AND UDMAT.DPBankCodeId=code1.CodeID
					WHERE UI.UserInfoId =@inp_nUserInfoId 
					AND UDMAT.DmatAccStatusCodeId=102001				
				  END
				  ELSE
				  BEGIN			
						PRINT(1234)
						INSERT INTO #tmpUserDmat
						--SELECT
						--UDMAT.DMATDetailsID,UDMAT.DEMATAccountNumber,						
						--CASE 
						--WHEN UDMAT.DPBankCodeId IS NULL THEN UDMAT.DPBank 
						--ELSE CASE WHEN Code1.DisplayCode IS NULL OR Code1.DisplayCode = '' THEN Code1.CodeName ELSE Code1.DisplayCode END
						--END AS DPBank, -- DPBank
						--UDMAT.DPID,
						--UDMAT.TMID,UI.UserInfoID,null
						--FROM 
						--usr_UserInfo UI 
						--LEFT JOIN usr_DMATDetails UDMAT ON UI.UserInfoID=UDMAT.UserInfoID
						--LEFT JOIN com_Code Code1 ON UDMAT.DPBankCodeId IS NOT NULL AND UDMAT.DPBankCodeId=code1.CodeID
						--WHERE UI.UserInfoId =@inp_nUserInfoId 
						--and UDMAT.DMATDetailsID IN (select TD.DMATDetailsID from tra_TransactionDetails_OS TD
						--join tra_TransactionMaster_OS TM on TD.TransactionMasterId=TM.TransactionMasterId
						--where UserInfoId=@inp_nUserInfoId and TM.DisclosureTypeCodeId=147001)
						
						SELECT
						UDMAT.DMATDetailsID,UDMAT.DEMATAccountNumber,						
						CASE 
							WHEN UDMAT.DPBankCodeId IS NULL THEN UDMAT.DPBank 
							ELSE CASE WHEN Code1.DisplayCode IS NULL OR Code1.DisplayCode = '' THEN Code1.CodeName ELSE Code1.DisplayCode END
						END AS DPBank, 
						UDMAT.DPID,
						UDMAT.TMID,UI.UserInfoID,null
						FROM 
						usr_UserInfo UI 
						LEFT JOIN usr_DMATDetails UDMAT ON UI.UserInfoID=UDMAT.UserInfoID
						LEFT JOIN com_Code Code1 ON UDMAT.DPBankCodeId IS NOT NULL AND UDMAT.DPBankCodeId=code1.CodeID
						WHERE UI.UserInfoId =@inp_nUserInfoId 
						AND ((UDMAT.DMATDetailsID IN (select TD.DMATDetailsID from tra_TransactionDetails_OS TD
						join tra_TransactionMaster_OS TM on TD.TransactionMasterId=TM.TransactionMasterId
						where UserInfoId=@inp_nUserInfoId and TM.DisclosureTypeCodeId=147001))
						OR (UI.UserInfoID IN (select TD.ForUserInfoID from tra_TransactionDetails_OS TD
						join tra_TransactionMaster_OS TM on TD.TransactionMasterId=TM.TransactionMasterId
						where UserInfoId=@inp_nUserInfoId and TM.DisclosureTypeCodeId=147001 and TD.DMATDetailsID IS NULL))
						)	AND UDMAT.DmatAccStatusCodeId=102001
						
														
				   END	
				   
					SELECT @nCheckCount=ISNULL(COUNT(ID),0) FROM #tmpUserDmat
					IF(@nCheckCount=0 OR @nCheckCount='')
					BEGIN
						INSERT INTO #tmpUserDmat
						SELECT
						NULL,NULL,NULL,NULL,
						NULL,UI.UserInfoID,null
						FROM 
						usr_UserInfo UI 					
						WHERE UI.UserInfoId =@inp_nUserInfoId 
					END					
							

				CREATE TABLE #tmpTransDmat
				(
				ID int identity(1,1),
				TransId int,
				TransDmatId int,		
				TransQuantity decimal(10,2),	
				TransValue decimal(10,2),
				TransLotSize decimal(10,2),
				TransContractSpecification nvarchar(550),
				TransSecurityTypeCodeId INT,
				Company nvarchar(max),
				TransSecurityName varchar(50),
				CompanyId int,
				TransUserinfoId INT,
				)
				INSERT INTO #tmpTransDmat
				SELECT	
				TD.TransactionDetailsId,
				DD.DMATDetailsID,
				TD.Quantity ,		
				TD.Value ,
				TD.LotSize ,
				TD.ContractSpecification ,
				TD.SecurityTypeCodeId,
				RMC.CompanyName,
				CSecurityType.CodeName,  
			    TD.CompanyId,
				TD.ForUserInfoId		
				FROM	tra_TransactionDetails_OS TD
				JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId
				JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId
				LEFT JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID
				LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative
				LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
				LEFT JOIN rl_CompanyMasterList RMC ON RMC.RlCompanyId=TD.CompanyId
				LEFT JOIN com_Code CSecurityType on TD.SecurityTypeCodeId=CSecurityType.CodeID
				WHERE TD.TransactionMasterId =@inp_iTransactionMasterId AND ForUserInfoId=@inp_nUserInfoId 


				UPDATE #tmpUserDmat  SET TransId=#tmpTransDmat.TransId
				FROM #tmpUserDmat
				JOIN #tmpTransDmat ON #tmpUserDmat.UserInfoId=#tmpTransDmat.TransUserinfoId
				where #tmpUserDmat.DmatId is null
				
				UPDATE #tmpUserDmat  SET TransId=#tmpTransDmat.TransId
				FROM #tmpUserDmat
				JOIN #tmpTransDmat ON #tmpUserDmat.DmatId=#tmpTransDmat.TransDmatId

				DECLARE @nCheckDmatId INT
				SELECT @nCheckDmatId=DmatId FROM #tmpUserDmat WHERE UserInfoId=@inp_nUserInfoId
				IF(@nCheckDmatId  IS NOT NULL OR @nCheckDmatId!='')
				BEGIN
					DELETE FROM #tmpTransDmat WHERE TransDmatId IS NULL AND TransUserinfoId=@inp_nUserInfoId
				END

											
				SELECT TTD.TransId, TUD.DmatId,ISNULL(TUD.DmatAccNo,'NA') AS dis_grd_52011,ISNULL(TUD.DPBank,'NA') AS dis_grd_52012,ISNULL(TUD.DPID,'NA') AS dis_grd_52013,ISNULL(TUD.TMID,'NA') AS dis_grd_52014 ,
				ISNULL(TTD.TransQuantity,0) AS dis_grd_52016,
				ISNULL(TTD.TransValue,0) AS dis_grd_52017,TUD.UserInfoId, ISNULL(TTD.TransLotSize,0) AS dis_grd_52018, ISNULL(TTD.TransContractSpecification,'') AS dis_grd_52019,TTD.TransSecurityTypeCodeId AS SecurityTypeCodeId,
				'NA' AS dis_grd_52015, TTD.TransId AS TransactionDetailsId,ISNULL(TTD.Company,'NA') AS dis_grd_52043,ISNULL(TTD.TransSecurityName,'NA') AS dis_grd_52042,TTD.CompanyId AS CompanyId
				FROM #tmpUserDmat TUD
				JOIN #tmpTransDmat TTD ON 				
				TTD.TransDmatId=TUD.DmatId and TTD.TransDmatId IS NOT NULL
				UNION

				SELECT TTD.TransId, TUD.DmatId,ISNULL(TUD.DmatAccNo,'NA') AS dis_grd_52011,ISNULL(TUD.DPBank,'NA') AS dis_grd_52012,ISNULL(TUD.DPID,'NA') AS dis_grd_52013,ISNULL(TUD.TMID,'NA') AS dis_grd_52014 ,
				ISNULL(TTD.TransQuantity,0) AS dis_grd_52016,
				ISNULL(TTD.TransValue,0) AS dis_grd_52017,TUD.UserInfoId, ISNULL(TTD.TransLotSize,0) AS dis_grd_52018, ISNULL(TTD.TransContractSpecification,'') AS dis_grd_52019,TTD.TransSecurityTypeCodeId AS SecurityTypeCodeId,
				'NA' AS dis_grd_52015, TTD.TransId AS TransactionDetailsId,ISNULL(TTD.Company,'NA') AS dis_grd_52043,ISNULL(TTD.TransSecurityName,'NA') AS dis_grd_52042,TTD.CompanyId AS CompanyId
				FROM #tmpUserDmat TUD
				JOIN #tmpTransDmat TTD ON 
				TTD.TransId=TUD.TransId AND TTD.TransDmatId IS NULL			


				DROP TABLE #tmpUserDmat
				DROP TABLE #tmpTransDmat		
			 END
			 ELSE
			 BEGIN				
				SELECT	
				DD.DMATDetailsID AS DmatId,
				--TD.TransactionMasterId AS TransId,
				TD.ForUserInfoId AS UserInfoId,
				DD.DEMATAccountNumber AS dis_grd_52011,				
				DD.DPBank AS dis_grd_52012,
				DD.DPID AS dis_grd_52013,
				DD.TMID AS dis_grd_52014,
				NULL AS dis_grd_52015,								
				SUM(TD.Quantity) AS dis_grd_52016,		
				SUM(TD.Value) AS dis_grd_52017,
				SUM(TD.LotSize) AS 	dis_grd_52018,
				NULL AS dis_grd_52019,
				TD.SecurityTypeCodeId AS SecurityTypeCodeId,
				CSecurityType.CodeName AS dis_grd_52042,
				RMC.CompanyName AS dis_grd_52043,
				TD.CompanyId AS CompanyId		
				FROM	tra_TransactionDetails_OS TD
				--LEFT JOIN #tmpEvaluatePercentagePrePostTransaction tmp ON TD.TransactionDetailsId=tmp.TransactionDetailsId
				JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId
				JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId
				LEFT JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID
				LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative
				LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
				LEFT JOIN rl_CompanyMasterList RMC ON RMC.RlCompanyId=TD.CompanyId
				LEFT JOIN com_Code CSecurityType on TD.SecurityTypeCodeId=CSecurityType.CodeID
				--LEFT JOIN com_Code Code1 ON DD.DPBankCodeId IS NOT NULL AND DD.DPBankCodeId=code1.CodeID
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
				) AND ForUserInfoId=@inp_nUserInfoId 
				GROUP BY DD.DMATDetailsID,DD.DEMATAccountNumber,DD.DPBank,DD.DPID,DD.TMID,
				--TD.TransactionMasterId,
				TD.ForUserInfoId,TD.SecurityTypeCodeId,CSecurityType.CodeName,RMC.CompanyName,TD.CompanyId	
		     END		
		END
							
	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TRANSACTIONDETAILS_LIST
	END CATCH
END

