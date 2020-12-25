IF OBJECT_ID ('dbo.st_tra_NSEDownloadGroupWiseExcel') IS NOT NULL
	DROP PROCEDURE dbo.st_tra_NSEDownloadGroupWiseExcel
GO

CREATE PROCEDURE [dbo].[st_tra_NSEDownloadGroupWiseExcel] 
	 @inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1  	
	,@GroupId					INT
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_CONTINOUSDISCLOSUeMPLOYEEINSIDERRELETTER_LIST INT = 17246 -- Error occurred while fetching list of transactions.
	
	DECLARE @SecuriyType_Share INT = 139001
	DECLARE @SecuriyType_WArrants INT = 139002
	DECLARE @SecuriyType_ConDEb INT = 139003
	DECLARE @SecuriyType_Futures INT = 139004
	DECLARE @SecuriyType_Options INT = 139005
	DECLARE @ModeOfAcquisition_ESOP INT = 149009

	DECLARE @UserId INT
	DECLARE @RELATIONTYPE_SELF VARCHAR(10) = 'Self'
	
	DECLARE @nNoPeriodEndHoldingFlag INT
	DECLARE @nDisclosure_PeriodEnd INT = 147003
	DECLARE @NoHolding_Text VARCHAR(12) = 'No Holding'
	DECLARE @TRANSACTION_TYPE_BUY INT = 143001
	DECLARE @TRANSACTION_TYPE_SELL INT = 143002
	DECLARE @TRANSACTION_TYPE_CASHLESS_PARTIAL INT = 143005
	DECLARE @TRANSACTION_TYPE_CASHLESS_ALL INT = 143004

	DECLARE @nUserType_Corporate INT = 101004
	
	DECLARE @nUserType_Employee INT = 101003
	DECLARE @nUserType_NonEmployee INT = 101006
	DECLARE @nUserTypeCodeId INT
	DECLARE @CountryCodeGroupID INT = 107
	DECLARE @TEXT_FOR_RELATIVES VARCHAR(100) = 'Immediate Relative'
	
	DECLARE @bShowOriginalUserDetails BIT = 1
	DECLARE @bFormDetailsFlag BIT = 1 -- default flag used to get saved form is submitted
	
	DECLARE @nTranStatus_Submitted INT = 148007
	
	--Impact on Post Share quantity  
	DECLARE @nLess INT = 505002
	DECLARE @nBoth INT = 505003
	DECLARE @nNo   INT = 505004   
	DECLARE @MIN INT, @MAX INT, @TransactionMasterId INT

	BEGIN TRY	   
			
			CREATE TABLE #tempNSE_TRA_MST(Id INT IDENTITY(1,1), TransactionMasterId INT)
			INSERT INTO #tempNSE_TRA_MST
			SELECT TransactionMasterId from tra_NSEGroupDetails WHERE TransactionMasterId IS NOT NULL
			
			CREATE TABLE #tempTRA_MST(TransactionMasterId INT)
									
			SET @MIN = (SELECT MIN(Id) FROM #tempNSE_TRA_MST)
			SET @MAX = (SELECT MAX(Id) FROM #tempNSE_TRA_MST)						

			WHILE(@MIN<@MAX)
			BEGIN
				
				SET @TransactionMasterId = (SELECT TransactionMasterId FROM #tempNSE_TRA_MST WHERE Id = @MIN)
				
				INSERT INTO #tempTRA_MST
				EXEC st_tra_TransactionIdsForLetter @TransactionMasterId

				SET @MIN = @MIN + 1
			END
				
					select 
					    case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN 'Equity'
						when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) THEN 'F&O' 
						ELSE '-' END as 'Type',
				
						ISNULL(u.FirstName + ' ',' ') + ISNULL(u.MiddleName + ' ',' ') + ISNULL(u.LastName,' ') AS Name, ISNULL(u.PAN,'') AS 'PAN Details',
						CASE WHEN u.UserTypeCodeId = 101004 THEN ISNULL(u.CIN,' ') ELSE ISNULL(u.DIN,' ') END AS 'CIN/DIN' , ISNULL(u.AddressLine1,'')+ ' ' + ISNULL(', ' + u.PinCode,'')  + CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END  + ISNULL(u.MobileNumber,'')
						as 'Address and contact no',
						
						CASE WHEN u.UserTypeCodeId = @nUserType_Corporate OR u.UserTypeCodeId = @nUserType_NonEmployee THEN u.SubCategoryText 
						ELSE CASE WHEN u.SubCategory IS NOT NULL THEN (SELECT code.CodeName FROM com_Code code WHERE CodeID=u.SubCategory)
						ELSE CASE WHEN u.UserInfoId IN(SELECT u.UserInfoId FROM usr_UserRelation ur JOIN  usr_UserInfo u ON ur.UserInfoIdRelative=u.UserInfoId) THEN @TEXT_FOR_RELATIVES	
						ELSE '' END END END  as 'Category of person*',					
						
						case when td.SecurityTypeCodeId in(@SecuriyType_Share) then 'Equity Shares' 
						     when td.SecurityTypeCodeId in(@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName 
						else '-' end as 'Type of Security',
						
						case when td.SecurityTypeCodeId in (@SecuriyType_Share) THEN ISNULL(CONVERT(VARCHAR(MAX),SecuritiesPriorToAcquisition),'')  
							when td.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN ISNULL(CONVERT(VARCHAR(MAX),SecuritiesPriorToAcquisition),'') 
							ELSE '-' END as 'No. of Security',
							
						case when td.SecurityTypeCodeId in (@SecuriyType_Share) THEN ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPreTransaction),'') ELSE '-' END AS '% of Shareholding',						 
						
						case when td.SecurityTypeCodeId in(@SecuriyType_Share) then 'Equity Shares' 
						     when td.SecurityTypeCodeId in(@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName 
						else '-' end as 'Type of security ',
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),Quantity) ELSE '-' END as 'No. of Security ',
						--case when td.SecurityTypeCodeId in (@SecuriyType_Share) THEN ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPreTransaction),'') ELSE '-' END AS '% of Shareholding ',	
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),Value) ELSE '-' END as 'Value of Security',
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CTransType.CodeName ELSE '-' END as 'Acquisition/Disposal',
						
						case when td.SecurityTypeCodeId in(@SecuriyType_Share) then 'Equity Shares' 
						     when td.SecurityTypeCodeId in(@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName 
						else '-' end as 'Type of security  ',
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share) THEN 
								ISNULL(CONVERT(VARCHAR(MAX),(SecuritiesPriorToAcquisition + (
									CASE 										
										WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_PARTIAL THEN (Quantity-Quantity2) 
										WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_ALL THEN (Quantity-Quantity2) 
										ELSE CASE WHEN @nLess = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN (-1 * Quantity)
										     WHEN @nBoth = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
										     WHEN @nNo = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
										     ELSE Quantity 
										 END				
										
									END))),'')  
								
							when td.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN 
								ISNULL(CONVERT(VARCHAR(MAX),(SecuritiesPriorToAcquisition + (
									CASE 										
										WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_PARTIAL THEN (Quantity-Quantity2) 
										WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_ALL THEN (Quantity-Quantity2) 
										ELSE CASE WHEN @nLess = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN (-1 * Quantity)
										     WHEN @nBoth = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
										     WHEN @nNo = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
										     ELSE Quantity 
										 END				
										
									END))),'') 
							ELSE '-' 
						END as 'No.of Security ',
						
					case when td.SecurityTypeCodeId in (@SecuriyType_Share) THEN ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPreTransaction),'') ELSE '-' END AS '% of Shareholding  ',					   
					case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN  REPLACE(CONVERT(VARCHAR(50),td.DateOfAcquisition,106), ' ','-') ELSE '-' END as 'From Date',
					case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN  REPLACE(CONVERT(VARCHAR(50),td.DateOfAcquisition,106), ' ','-') ELSE '-' END as 'To Date',					
						
					case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN  ISNULL(REPLACE(CONVERT(VARCHAR(50),td.DateOfInitimationToCompany,106), ' ','-'),GETDATE())ELSE '-' END as '  ',
					    
					case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CAcquisitionType.CodeName ELSE '-' END as ' ',						
					
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) THEN C.CodeName ELSE '-' END AS '   ',
					
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) THEN td.ContractSpecification ELSE '-' END AS '     ',
					
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_BUY THEN CONVERT(VARCHAR(MAX),td.Value) ELSE '-' END  AS 'Notional Value',
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_BUY THEN CONVERT(VARCHAR(MAX),(Quantity * LotSize)) ELSE '-' END  AS 'Number of units (contracts * lot size)',
					
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_SELL THEN CONVERT(VARCHAR(MAX),td.Value) ELSE '-' END  AS 'Notional Value ',
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_SELL THEN CONVERT(VARCHAR(MAX),(Quantity * LotSize)) ELSE '-' END  AS 'Number of units (contracts * lot size) ',
					case when Cexchange.DisplayCode IS NULL OR Cexchange.DisplayCode = '' then Cexchange.CodeName else Cexchange.DisplayCode end as '    ',
					
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_BUY THEN CONVERT(VARCHAR(MAX),td.Value) ELSE 0 END  + 
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_SELL THEN CONVERT(VARCHAR(MAX),td.Value) ELSE 0 END  +
					case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),Value) ELSE 0 END as '(Calculate aggregate value of total sell and buy share value)'			
					,currency.DisplayCode as Currency
					from tra_TransactionDetails td					
					join usr_UserInfo u on u.UserInfoId = td.ForUserInfoId
					join com_Code C on C.CodeID = td.SecurityTypeCodeId
					join tra_TransactionMaster tm on tm.TransactionMasterId = td.TransactionMasterId
					join com_Code CAcquisitionType on CAcquisitionType.CodeID = td.ModeOfAcquisitionCodeId
					join com_Code CTransType on CTransType.CodeID = td.TransactionTypeCodeId
					join com_Code Cexchange on Cexchange.CodeID = td.ExchangeCodeId
					LEFT JOIN com_Code CCountry ON CCountry.CodeID = u.CountryId 
					RIGHT JOIN tra_NSEGroupDetails NSEGr ON tm.UserInfoId=NSEGr.UserInfoId		   
				   	AND tm.TransactionMasterId = NSEGr.TransactionMasterId
					join #tempTRA_MST tmid on tmid.TransactionMasterId = tm.TransactionMasterId
					LEFT JOIN com_Code currency ON currency.CodeID = td.CurrencyID
					WHERE NSEGr.GroupId=@GroupId AND tm.DisclosureTypeCodeId=147002 
				   	AND tm.TransactionStatusCodeId NOT IN (@nTranStatus_Submitted)
				   	AND (tm.SoftCopyReq = 1 OR (tm.SoftCopyReq = 0 AND tm.HardCopyByCOSubmissionDate IS NOT NULL))			
			
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CONTINOUSDISCLOSUeMPLOYEEINSIDERRELETTER_LIST
	END CATCH
END
GO