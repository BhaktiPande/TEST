IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_InitialTransactionDetailsList')
DROP PROCEDURE [dbo].[st_tra_InitialTransactionDetailsList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list transaction data.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		08-Apr-2015

Modification History:
Modified By		Modified On		Description
Amar            19-May-2015     Resolved ambiguous column name Security type code.
Amar			22-May-2015		Changed column names to SecuritiesPriorToAcquisition, PerOfSharesPreTransaction 
								and PerOfSharesPostTransaction
Arundahti		12-Jun-2015		Show TransactionTye = <Empty> for Initial disclosure, instead of Buy
Arundahti		17-Jul-2015		Added one more parameter to know if it is for letter
								If it is called for Letter, ignore parameter @inp_nSecurityTypeCodeId
Parag			11-Dec-2015		Made change to show all transcation made in period when transcation type is period end disclosure
Raghvendra		14-Jan-2016		Fix for showing - instead of empty space for the transaction type in case of initial disclosure.
Raghvendra		15-Jan-2016		Fix for showing - instead of empty space for the transaction type in case of initial disclosure.
Raghvendra		15-Jan-2016		Fix for showing - instead of empty space for corporate type insider.
Raghvendra		10-Mar-2016		Change to show the current date as Date of Intimation to company for insider and employee if the 
								transaction is not submitted, else show the date from database.
Raghvendra		1-Apr-2016		Change for Mantis point 8586 for showing the column security type in the grid shown at the bottom of the CreateLetter screen.
Raghvendra		7-Apr-2016		Change to show the company name in the transaction list on create letter page for corporate user.
Raghvendra		14-Apr-2016     Added condition to show the displaycode for the country and if not available then show the Codename, in the address part.
Raghvendra		1-Mar-2016		Fix for transaction details not seen on the Transaction entry screen when transactions entered by Corporate users.
								Added the missing condition for the sorting based on Security type column.
Parag			10-May-2016		made change to show user details save at time of transaction submitted
Parag			05-Aug-2016		Made change to show negative balance. ie when transaction type is sell then quantity is shown in negative
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Tushar/RW		05-Oct-2016		Change related to hiding Pre & Post transaction percentage values for non share type securities.
Parag			28-Oct-2016		Made change to show calculated pre/post sequrity and precent for continuous disclosure which are not submitted
Tushar          08-May-2017     Modified to replace actual date of intimation with letter creation date on create letter page.
Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_InitialTransactionDetailsList]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iTransactionMasterId	INT
	,@inp_nSecurityTypeCodeId	INT
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
	DECLARE @nTransactionStatus INT

	DECLARE @inp_dtAuthorizedShareCapitalDate DATETIME  = GETDATE()
	DECLARE @dPaidUpShare DECIMAL(30,0)
	DECLARE @nMultiplier INT  = 100


	BEGIN TRY
		
		

	SELECT TOP 1 @dPaidUpShare =  PaidUpShare 
		FROM com_CompanyPaidUpAndSubscribedShareCapital SC
		INNER JOIN mst_Company C ON SC.CompanyID = C.CompanyId
		WHERE C.IsImplementing = 1
		AND PaidUpAndSubscribedShareCapitalDate <= @inp_dtAuthorizedShareCapitalDate
		ORDER BY PaidUpAndSubscribedShareCapitalDate DESC

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
		
		IF @inp_sSortField = 'tra_grd_16190'
		BEGIN 
			SELECT @inp_sSortField = 'TD.TransactionDetailsId '
		END 
			
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',TD.TransactionDetailsId),TD.TransactionDetailsId '
		SELECT @sSQL = @sSQL + ' FROM tra_TransactionDetails TD JOIN tra_TransactionMaster TM ON TD.TransactionMasterId = TM.TransactionMasterId '
		SELECT @sSQL = @sSQL + ' JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId '
		SELECT @sSQL = @sSQL + ' JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CModeOfAcq ON TD.ModeOfAcquisitionCodeId = CModeOfAcq.CodeID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CExchange ON TD.ExchangeCodeId = CExchange.CodeID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CTransactionType ON TD.TransactionTypeCodeId = CTransactionType.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CCountry ON UF.CountryId = CCountry.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE TD.TransactionMasterId = ' + CAST(@inp_iTransactionMasterId AS VARCHAR(15))
		SELECT @sSQL = @sSQL + ' and 1 = 1 '
		IF (@inp_nSecurityTypeCodeId IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND TD.SecurityTypeCodeId = ' + CAST(@inp_nSecurityTypeCodeId AS VARCHAR(15)) + ' '
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)	
		
		CREATE TABLE #tmpEvaluatePercentagePrePostTransaction 
							(TransactionDetailsId BIGINT NOT NULL, SecuritiesPriorToAcquisition DECIMAL(20,0) NOT NULL,
							PerOfSharesPreTransaction DECIMAL(5,2) NOT NULL, PerOfSharesPostTransaction DECIMAL(5,2) NOT NULL,
							SecuritiesPostToAcquisition DECIMAL(20,0) NOT NULL)

		-- in case of continuous disclosure which is not submitted, get securities prior and post to acquisition and percent of share pre and post transcation
		-- and calculation for pre/post sequrity and precent is auto in trading policy
		SELECT @nTradingPolicy = tm.TradingPolicyId  FROM tra_TransactionMaster tm 
		WHERE tm.TransactionMasterId = @inp_iTransactionMasterId AND tm.DisclosureTypeCodeId = @nDisclosureType_Continuous 
		AND tm.TransactionStatusCodeId in (@nTranStatus_NotConfirm, @nTranStatus_DocUpload)

		IF EXISTS (SELECT TradingPolicyId FROM rul_TradingPolicy tp WHERE tp.TradingPolicyId = @nTradingPolicy 
						AND tp.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = 0)
		BEGIN

			EXECUTE st_tra_EvaluatePercentagePrePostTransactionSecuritiesPriorToAcquisition 
						@inp_iTransactionMasterId,
						@out_nReturnValue OUTPUT,
						@out_nSQLErrCode OUTPUT,
						@out_sSQLErrMessage OUTPUT
		END	
		
		DECLARE @dtDateofBecomingInsider datetime
		SELECT @dtDateofBecomingInsider=DateOfBecomingInsider from usr_UserInfo where UserInfoId=@inp_nUserInfoId

		SELECT @nTransactionStatus=TransactionStatusCodeId FROM tra_TransactionMaster WHERE TransactionMasterId=@inp_iTransactionMasterId
	
		DECLARE @nCheckIDforEmpInsider INT=0		
		SELECT @nCheckIDforEmpInsider=COUNT(TM.TransactionMasterId) FROM tra_TransactionMaster TM WHERE TM.UserInfoId=@inp_nUserInfoId AND (TM.InsiderIDFlag in (0,1) OR tm.InsiderIDFlag is null) AND TM.DisclosureTypeCodeId=147001
		PRINT(@nCheckIDforEmpInsider)
		
		DECLARE @nTransactionDetailsCnt INT=0
		
		SELECT @nTransactionDetailsCnt=COUNT(TransactionMasterId) FROM tra_TransactionDetails WHERE TransactionMasterId=@inp_iTransactionMasterId AND SecurityTypeCodeId=@inp_nSecurityTypeCodeId
		

	IF(@inp_nUserTypeCodeId<>101007)
	BEGIN
	
		IF(@inp_isFromView='Insider' AND  @nCheckIDforEmpInsider>1 AND @nTransactionDetailsCnt=0)
		BEGIN
		PRINT(111)
		PRINT(@dtDateofBecomingInsider)
			CREATE TABLE #tmpTransDetails
			(
			ID INT IDENTITY(1,1),DmatId INT,UserInfoId INT,	DEMATAccountNumber NVARCHAR(100),DPBank NVARCHAR(500),
			DPID NVARCHAR(100),TMID NVARCHAR(100),tra_grd_16194 VARCHAR(100),Quantity DECIMAL(18,3),
			ESOPExcerciseOptionQty DECIMAL(18,3),OtherExcerciseOptionQty DECIMAL(18,3),	Value DECIMAL(18,3),
			LotSize INT,tra_grd_16200 VARCHAR(500),SecurityTypeCodeId INT,TransStatusCodeId INT
			)
			INSERT INTO #tmpTransDetails
			SELECT	
			DD.DMATDetailsID AS DmatId,TD.ForUserInfoId AS UserInfoId,DD.DEMATAccountNumber AS tra_grd_16190,
			DD.DPBank AS tra_grd_16191,DD.DPID AS tra_grd_16192,DD.TMID AS tra_grd_16193,NULL AS tra_grd_16194,								
			SUM(TD.Quantity) AS tra_grd_16195,SUM(TD.ESOPExcerciseOptionQty) AS tra_grd_16196,SUM(TD.OtherExcerciseOptionQty) AS tra_grd_16197,
			SUM(TD.Value) AS tra_grd_16198,SUM(TD.LotSize) AS tra_grd_16199,NULL AS tra_grd_16200,TD.SecurityTypeCodeId AS SecurityTypeCodeId,
			TM.TransactionStatusCodeId	AS TransStatusCodeId
			FROM	tra_TransactionDetails TD			
			JOIN tra_TransactionMaster TM ON TD.TransactionMasterId = TM.TransactionMasterId
			JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId
			LEFT JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID
			LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative
			LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID	
			WHERE TD.TransactionMasterId in(
					SELECT TM.TransactionMasterId FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD
					ON TM.TransactionMasterId=TD.TransactionMasterId
					WHERE TM.UserInfoId=@inp_nUserInfoId AND TD.DateOfAcquisition<=@dtDateofBecomingInsider AND TM.TransactionStatusCodeId=148003
					UNION

					SELECT TM.TransactionMasterId FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD
					ON TM.TransactionMasterId=TD.TransactionMasterId
					WHERE TM.UserInfoId IN(SELECT usr_UserRelation.UserInfoIdRelative AS UserInfoId FROM usr_UserInfo
					JOIN usr_UserRelation ON usr_UserInfo.UserInfoId=usr_UserRelation.UserInfoId
					WHERE usr_UserInfo.UserInfoId=@inp_nUserInfoId)
					AND TD.DateOfAcquisition<=@dtDateofBecomingInsider AND TM.TransactionStatusCodeId=148003	
					UNION

					SELECT TM.TransactionMasterId FROM tra_TransactionMaster TM JOIN usr_UserInfo UI
					on TM.UserInfoId=UI.UserInfoId
					WHERE TM.UserInfoId=@inp_nUserInfoId and UI.DateOfBecomingInsider IS NULL AND TM.TransactionStatusCodeId=148003
					UNION

					SELECT TM.TransactionMasterId FROM tra_TransactionMaster TM JOIN usr_UserInfo UI
					on TM.UserInfoId=UI.UserInfoId
					where TM.UserInfoId IN(SELECT usr_UserRelation.UserInfoIdRelative AS UserInfoId FROM usr_UserInfo
					JOIN usr_UserRelation ON usr_UserInfo.UserInfoId=usr_UserRelation.UserInfoId
					WHERE usr_UserInfo.UserInfoId=@inp_nUserInfoId)
					and UI.DateOfBecomingInsider IS NULL AND TM.TransactionStatusCodeId=148003
									
			) AND ForUserInfoId=@inp_nUserInfoId AND TD.SecurityTypeCodeId=@inp_nSecurityTypeCodeId
			GROUP BY DD.DMATDetailsID,DD.DEMATAccountNumber,DD.DPBank,DD.DPID,DD.TMID,
			--TD.TransactionMasterId,
			TD.ForUserInfoId,TD.SecurityTypeCodeId ,TM.TransactionStatusCodeId

			declare @nCount INT=0
			SELECT @nCount=COUNT(ID) FROM #tmpTransDetails
			PRINT(@nCount)
			IF(@nCount=0)
			BEGIN
				SELECT	DISTINCT
				isnull(DD.DMATDetailsID,0) AS DmatId,tm.UserInfoId AS UserInfoId,DD.DEMATAccountNumber AS tra_grd_16190,
				DD.DPBank AS tra_grd_16191,DD.DPID AS tra_grd_16192,DD.TMID AS tra_grd_16193,NULL AS tra_grd_16194,								
				0 AS tra_grd_16195,	0 AS tra_grd_16196,	0 AS tra_grd_16197,0 AS tra_grd_16198,0 AS 	tra_grd_16199,
				NULL AS tra_grd_16200,@inp_nSecurityTypeCodeId AS SecurityTypeCodeId,TM.TransactionStatusCodeId	AS TransStatusCodeId
				FROM	
				 tra_TransactionMaster TM 
				JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
				LEFT JOIN usr_DMATDetails DD ON uf.UserInfoId = DD.UserInfoID
				where tm.UserInfoId=@inp_nUserInfoId and DisclosureTypeCodeId=147001 AND TransactionStatusCodeId=148003
			END
			ELSE
			BEGIN
				SELECT	
				DmatId AS DmatId,UserInfoId AS UserInfoId,DEMATAccountNumber AS tra_grd_16190,
				DPBank AS tra_grd_16191,DPID AS tra_grd_16192,TMID AS tra_grd_16193,tra_grd_16194 AS tra_grd_16194,								
				Quantity AS tra_grd_16195,	ESOPExcerciseOptionQty AS tra_grd_16196,OtherExcerciseOptionQty AS tra_grd_16197,
				Value AS tra_grd_16198,LotSize AS 	tra_grd_16199,NULL AS tra_grd_16200,
				SecurityTypeCodeId AS SecurityTypeCodeId,TransStatusCodeId AS TransStatusCodeId
				FROM 
				#tmpTransDetails
			END
		DROP TABLE #tmpTransDetails



		END
		ELSE
		BEGIN
		print(123)
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
			SELECT @RowNum=TransactionMasterId  from tra_TransactionMaster where UserInfoId=@inp_nUserInfoId and TransactionStatusCodeId IN(148003,148004,148005,148006,148007) and DisclosureTypeCodeId=147001
			IF(@RowNum=0)
			BEGIN
			print(1234)
			
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
			print(12345)
			print('@inp_nUserInfoId')
			print(@inp_nUserInfoId)
				INSERT INTO #tmpUserDmat
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
				AND ((UDMAT.DMATDetailsID IN (select TD.DMATDetailsID from tra_TransactionDetails TD
				join tra_TransactionMaster TM on TD.TransactionMasterId=TM.TransactionMasterId
				where UserInfoId=@inp_nUserInfoId and TM.DisclosureTypeCodeId=147001))
				OR (UI.UserInfoID IN (select TD.ForUserInfoID from tra_TransactionDetails TD
				join tra_TransactionMaster TM on TD.TransactionMasterId=TM.TransactionMasterId
				where UserInfoId=@inp_nUserInfoId and TM.DisclosureTypeCodeId=147001 and TD.DMATDetailsID IS NULL))
				OR (UI.UserInfoID IN (SELECT UserInfoId FROM tra_TransactionMaster TM
				WHERE UserInfoId=@inp_nUserInfoId and TM.DisclosureTypeCodeId=147001 AND TM.NoHoldingFlag=1)))		
				and UDMAT.DmatAccStatusCodeId=102001
				
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
		TransPerHolding NVARCHAR(100),
		TransQuantity decimal(10,2),
		TransESOPExcerciseOptionQty decimal(10,2),
		TransOtherExcerciseOptionQty decimal(10,2),
		TransValue decimal(10,2),
		TransLotSize decimal(10,2),
		TransContractSpecification nvarchar(550),
		TransSecurityTypeCodeId INT,
		TransUserinfoId INT		
		)
			INSERT INTO #tmpTransDmat
			SELECT	
			TD.TransactionDetailsId,
			DD.DMATDetailsID,
			 
			CASE WHEN td.SecurityTypeCodeId = @SECURITY_TYPE_SHARES
			 THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,2),(((TD.SecuritiesPriorToAcquisition + Quantity)*@nMultiplier) / @dPaidUpShare))),'')
			else '-'
			END AS tra_grd_16194,
				
										
			TD.Quantity AS tra_grd_16195,
			TD.ESOPExcerciseOptionQty AS tra_grd_16196,
			TD.OtherExcerciseOptionQty AS tra_grd_16197,
			TD.Value AS tra_grd_16198,
			TD.LotSize AS tra_grd_16199,
			TD.ContractSpecification AS tra_grd_16200,
			TD.SecurityTypeCodeId,
			TD.ForUserInfoId			
			FROM	tra_TransactionDetails TD
			LEFT JOIN #tmpEvaluatePercentagePrePostTransaction tmp ON TD.TransactionDetailsId=tmp.TransactionDetailsId
			JOIN tra_TransactionMaster TM ON TD.TransactionMasterId = TM.TransactionMasterId
			JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId
			LEFT JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID
			LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative
			LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
			WHERE TD.TransactionMasterId =@inp_iTransactionMasterId AND ForUserInfoId=@inp_nUserInfoId AND 	TD.SecurityTypeCodeId=@inp_nSecurityTypeCodeId
		

			--SELECT * FROM #tmpUserDmat
			--SELECT * FROM #tmpTransDmat

			--UPDATE #tmpUserDmat  SET TransId=#tmpTransDmat.TransId
			--FROM #tmpUserDmat
			--JOIN #tmpTransDmat ON #tmpUserDmat.UserInfoId=#tmpTransDmat.TransUserinfoId

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
	
			 
			SELECT 
			TTD.TransId, 
			TUD.DmatId,
			ISNULL(TUD.DmatAccNo,'NA') AS tra_grd_16190,
			ISNULL(TUD.DPBank,'NA') tra_grd_16191,
			ISNULL(TUD.DPID,'NA') AS tra_grd_16192,
			ISNULL(TUD.TMID,'NA') AS tra_grd_16193 ,
			ISNULL(TTD.TransPerHolding,'0') AS tra_grd_16194,
			ISNULL(TTD.TransQuantity,0) AS tra_grd_16195,
			ISNULL(TTD.TransESOPExcerciseOptionQty,0) AS tra_grd_16196,
			ISNULL(TTD.TransOtherExcerciseOptionQty,0) AS tra_grd_16197,
			ISNULL(TTD.TransValue,0) AS tra_grd_16198,
			TUD.UserInfoId, 
			ISNULL(TTD.TransLotSize,0) AS tra_grd_16199, 
			ISNULL(TTD.TransContractSpecification,'') AS tra_grd_16200,			
			TTD.TransSecurityTypeCodeId AS SecurityTypeCodeId,
			@nTransactionStatus AS TransStatusCodeId			
			FROM #tmpUserDmat TUD
			FULL OUTER JOIN #tmpTransDmat TTD ON TTD.TransId=TUD.TransId
			DROP TABLE #tmpUserDmat
			DROP TABLE #tmpTransDmat		
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

