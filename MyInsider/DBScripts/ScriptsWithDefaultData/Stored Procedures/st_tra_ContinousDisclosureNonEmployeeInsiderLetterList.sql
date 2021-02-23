IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_ContinousDisclosureNonEmployeeInsiderLetterList')
DROP PROCEDURE [dbo].[st_tra_ContinousDisclosureNonEmployeeInsiderLetterList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list for Countinous Disclosure Non Employee insider Letter data.

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		30-May-2015

Modification History:
Modified By		Modified On		Description
Arundhati		30-May-2015		Added error code
Swapnil			3-Jun-2015		Change in column name while taking the values.
Swapnil			3-Jun-2015		Change in method while getting UserInfoId
Ashish			25-Jun-2015		Added condition for CIN and DIN 
Parag			08-Jul-2015		Added additional parameter ie disclosure type to allow showing details for period end disclosure
								Added transaction master id as parameter to select query to filter record for related transaction only
								Added Check for "no period end holding" for period end disclosure type
								Added check for coporate user type to show company name 
Arundhati		17-Jul-2015		To include Multiple transactions based on the rule
Raghvendra		26-Nov-2015		Added changes for spliting the Grid used for generating the Form D
Raghvendra		29-Nov-2015		Added new columns in the Form D grid 1
Raghvendra		15-Jan-2016		Fix for showing designation for corporate type insider for Form D.
Raghvendra		01-Feb-2016		Fix for large relation type name not considered when finding the sub designation for the user
ED			    22-Mar-2016		Code integration done with ED code on 22-Mar-2016
Raghvendra		25-Mar-2015		Fix for showing the Number of shares for pre and post transaction quantity in Form C and D
Raghvendra		14-Apr-2016		Change to add Pincode and Country in the Address shown on the Form C
Raghvendra		20-Apr-2016		Change to show the Stock exchange value in second grid, grid for Options and Futures on Form C
								Also to consider the Buy or Sale of quantity when finding the value for Securities post transaction
Raghvendra		01-May-2016		Change to show 'Immediate Relatives' text instead of the relation in the For Form D. 
Parag			12-May-2016		made change to show user details save at time of form submitted
Parag			25-May-2016		made change to fix issue found while testing 
								- in case of "cashless all" transaction type, the post transaction quantity would be same as pre transaction quantity
Parag			18-Aug-2016		Code merge with ESOP code
Tushar/RW		05-Oct-2016		Change related to hiding Pre & Post transaction percentage values for non share type securities.
Tushar          23-May-2016     Modified to replace actual date of intimation with form c submission date. 

Usage:
EXEC st_tra_ContinousDisclosureNonEmployeeInsiderLetterList 1,
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_ContinousDisclosureNonEmployeeInsiderLetterList]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_nGridNumber			INT	--1: Top portion of the Grid Shown in Form C, 2:Bottom portion of the Grid shown in the Form C
	,@inp_iTransactionMasterId	INT	
	,@inp_iDisclosureType		INT	
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_CONTINOUSDISCLOSUNONEMPLOYEEINSIDERRELETTER_LIST INT = 17245 -- Error occurred while fetching list of transactions.
	
	DECLARE @SecuriyType_Share INT = 139001
	DECLARE @SecuriyType_WArrants INT = 139002
	DECLARE @SecuriyType_ConDEb INT = 139003
	DECLARE @SecuriyType_Futures INT = 139004
	DECLARE @SecuriyType_Options INT = 139005
	DECLARE @UserTYpe_NonEmployee INT = 101006
	DECLARE @UserTYpe_Corporate INT = 101004
	
	DECLARE @UserId INT
	DECLARE @RELATIONTYPE_SELF VARCHAR(10) = 'Self'
	
	DECLARE @nNoPeriodEndHoldingFlag INT
	DECLARE @nDisclosure_PeriodEnd INT = 147003
	DECLARE @NoHolding_Text VARCHAR(12) = 'No Holding'
	DECLARE @TRANSACTION_TYPE_BUY INT = 143001
	DECLARE @TRANSACTION_TYPE_SELL INT = 143002
	DECLARE @TRANSACTION_TYPE_CASHLESS_PARTIAL INT = 143005
	DECLARE @TRANSACTION_TYPE_CASHLESS_ALL INT = 143004
	
	DECLARE @CountryCodeGroupID INT = 107
	DECLARE @TEXT_FOR_RELATIVES VARCHAR(100) = 'Immediate Relative'

	DECLARE @bShowOriginalUserDetails BIT = 1
	DECLARE @bFormDetailsFlag BIT = 1 -- default flag used to get saved form is submitted
	
	DECLARE @nTranStatus_Submitted INT = 148007
	DECLARE @FormC_Submitted INT = 153021
	--Impact on Post Share quantity  
	DECLARE @nLess INT = 505002
	DECLARE @nBoth INT = 505003
	DECLARE @nNo   INT = 505004 

	Select @UserId = UserInfoId, @nNoPeriodEndHoldingFlag=NoHoldingFlag from tra_TransactionMaster where TransactionMasterId = @inp_iTransactionMasterId 
	--AND DisclosureTypeCodeId = @inp_iDisclosureType

	DECLARE @tmpTransactions TABLE(TransactionMasterId INT)
	
	BEGIN TRY
	
		DECLARE @temp TABLE(UserInfoId INT,relationType VARCHAR(512))
		INSERT INTO @temp(UserInfoId,relationType)
		SELECT TOP 1 @UserId,CASE WHEN ISNULL(SubCategoryText,'') = '' THEN '' ELSE SubCategoryText END  AS SubCategoryText FROM usr_UserInfo 
			WHERE UserInfoId = @UserId

		INSERT INTO @tmpTransactions
		EXEC st_tra_TransactionIdsForLetter @inp_iTransactionMasterId

		INSERT INTO @temp
		--SELECT	UserInfoIdRelative,cc.CodeName 
		SELECT	UserInfoIdRelative,@TEXT_FOR_RELATIVES 
		FROM	usr_UserRelation ur
				JOIN com_code cc 
					ON cc.CodeID = ur.RelationTypeCodeId
		WHERE	UserInfoId = @UserId
		
		-- check if form is submitted or not 
		IF EXISTS(SELECT tm.TransactionMasterId FROM tra_TransactionMaster tm
					WHERE tm.TransactionMasterId = @inp_iTransactionMasterId AND tm.TransactionStatusCodeId NOT IN (@nTranStatus_Submitted)
					AND (tm.SoftCopyReq = 1 OR (tm.SoftCopyReq = 0 AND tm.HardCopyByCOSubmissionDate IS NOT NULL)) ) 
		BEGIN
			SET @bShowOriginalUserDetails = 0 -- show saved user details for letter
		END
		
		IF @inp_nGridNumber = 1
		BEGIN
			IF NOT EXISTS(SELECT TransactionMasterId FROM @tmpTransactions)
			BEGIN
				IF (@bShowOriginalUserDetails = 1)
				BEGIN
					SELECT 
						CASE WHEN ui.UserTypeCodeId = @UserTYpe_Corporate THEN ISNULL(co.CompanyName,' ') ELSE 
						ISNULL(ui.FirstName + ' ',' ') + ISNULL(ui.MiddleName + ' ',' ') + ISNULL(ui.LastName,' ') END + '##' + ISNULL(ui.PAN,'') 
						+ '##' + CASE WHEN ui.UserTypeCodeId = 101004 THEN ISNULL(ui.CIN,' ') ELSE ISNULL(ui.DIN,' ') END + '##' + ISNULL(ui.AddressLine1,'')+ ' ' + ISNULL(', ' + ui.PinCode ,'')  + CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END  + '##' + ISNULL(ui.MobileNumber,'')
						as dis_grd_17209,
						CASE WHEN ui.UserTypeCodeId = @UserTYpe_NonEmployee THEN ui.SubCategoryText ELSE '-' END as dis_grd_17210,
						NULL as dis_grd_17211,
						@NoHolding_Text as dis_grd_17212,
						'-' as dis_grd_17213,
						NULL as dis_grd_17214,
						'-' as dis_grd_17215,
						'-' as dis_grd_17216,
						'-' as dis_grd_17217,
						'-' as dis_grd_17218,
						NULL as dis_grd_17219,
						'-' as dis_grd_17220,
						'-' as dis_grd_17221,
						NULL as dis_grd_17222,
						NULL as dis_grd_17223,
						NULL as dis_grd_17224,
						NULL as dis_grd_17426,
						'-' as dis_grd_17427/*,
						NULL as dis_grd_17225,
						NULL as dis_grd_17226,
						NULL as dis_grd_17227,
						NULL as dis_grd_17228,
						NULL as dis_grd_17229,
						NULL as dis_grd_17230*/
					FROM usr_UserInfo ui LEFT JOIN mst_Company co ON ui.CompanyId = co.CompanyId
					LEFT JOIN com_Code CCountry ON CCountry.CodeID = ui.CountryId and CCountry.CodeGroupId = @CountryCodeGroupID
					WHERE ui.UserInfoId = @UserId
				END
				ELSE
				BEGIN
					SELECT 
						CASE 
							WHEN TUD.UserTypeCode = @UserTYpe_Corporate THEN ISNULL(TUD.CompanyName, ' ') 
							ELSE  ISNULL(TUD.FirstName + ' ', ' ') + ISNULL(TUD.MiddleName + ' ', ' ') + ISNULL(TUD.LastName, ' ') 
						END + '##' 
							+ ISNULL(TUD.PanNumber, '') + '##' 
							+ CASE 
								WHEN TUD.UserTypeCode = @UserTYpe_Corporate THEN ISNULL(TUD.CINNumber, ' ') 
								ELSE ISNULL(TUD.DIN, ' ') 
							  END + '##' 
							+ ISNULL(TUD.Address, '')+ ' ' 
							+ ISNULL(', ' + TUD.Pincode , '')  
							+ ISNULL(', ' + TUD.Country, '') + '##' 
							+ ISNULL(TUD.MobileNumber, '') as dis_grd_17209,
						CASE 
							WHEN TUD.UserTypeCode = @UserTYpe_NonEmployee THEN TUD.Subcategory 
							ELSE '-' 
						END as dis_grd_17210,
						NULL as dis_grd_17211,
						@NoHolding_Text as dis_grd_17212,
						'-' as dis_grd_17213,
						NULL as dis_grd_17214,
						'-' as dis_grd_17215,
						'-' as dis_grd_17216,
						'-' as dis_grd_17217,
						'-' as dis_grd_17218,
						NULL as dis_grd_17219,
						'-' as dis_grd_17220,
						'-' as dis_grd_17221,
						NULL as dis_grd_17222,
						NULL as dis_grd_17223,
						NULL as dis_grd_17224,
						NULL as dis_grd_17426,
						'-' as dis_grd_17427/*,
						NULL as dis_grd_17225,
						NULL as dis_grd_17226,
						NULL as dis_grd_17227,
						NULL as dis_grd_17228,
						NULL as dis_grd_17229,
						NULL as dis_grd_17230*/
					FROM tra_TradingTransactionUserDetails TUD 
					WHERE TUD.UserInfoId = @UserId AND TUD.TransactionMasterId = @inp_iTransactionMasterId AND TUD.FormDetails = 1
				END
				
				
			END
			ELSE
			BEGIN
				IF (@bShowOriginalUserDetails = 1)
				BEGIN
					select 
						CASE WHEN u.UserTypeCodeId = @UserTYpe_Corporate THEN ISNULL(co.CompanyName,' ') ELSE 
						ISNULL(u.FirstName + ' ',' ') + ISNULL(u.MiddleName + ' ',' ') + ISNULL(u.LastName,' ') END + '##' + ISNULL(u.PAN,'') 
						+ '##' + CASE WHEN u.UserTypeCodeId = 101004 THEN ISNULL(u.CIN,' ') ELSE ISNULL(u.DIN,' ') END + '##' + ISNULL(u.AddressLine1,'')+ ' ' + ISNULL(', ' + u.PinCode,'')  + CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END  + '##' + ISNULL(u.MobileNumber,'')
						as dis_grd_17209,
						CASE WHEN ISNULL(t.relationType,'') = '' THEN '-' ELSE t.relationType END as dis_grd_17210,
						null as dis_grd_17211,
						case when td.SecurityTypeCodeId in(@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName else '-' end as dis_grd_17212,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share) THEN ISNULL(CONVERT(VARCHAR(MAX),SecuritiesPriorToAcquisition),'') + '##' + ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPreTransaction),'') 
							when td.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN ISNULL(CONVERT(VARCHAR(MAX),SecuritiesPriorToAcquisition),'') + '##NA'
							ELSE '-' END as dis_grd_17213,
						null as dis_grd_17214,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN C.CodeName ELSE '-' END as dis_grd_17215,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),Quantity) ELSE '-' END as dis_grd_17216,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),Value) ELSE '-' END as dis_grd_17217,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CTransType.CodeName ELSE '-' END as dis_grd_17218,
						null as dis_grd_17219,
						case when td.SecurityTypeCodeId in(@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName else '-' end as dis_grd_17220,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share) THEN 
								ISNULL(CONVERT(VARCHAR(MAX),(SecuritiesPriorToAcquisition + (
										CASE 											
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_PARTIAL THEN (Quantity-Quantity2) 
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_ALL THEN (Quantity-Quantity2) 
											ELSE CASE WHEN @nLess = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN (-1 * Quantity)
												 WHEN @nBoth = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
												 WHEN @nNo = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
												 ELSE Quantity END
										END))),'') + '##' 
								+ ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPostTransaction),'') 
							when td.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN 
								ISNULL(CONVERT(VARCHAR(MAX),(SecuritiesPriorToAcquisition + (
										CASE 											
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_PARTIAL THEN (Quantity-Quantity2) 
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_ALL THEN (Quantity-Quantity2) 
											ELSE CASE WHEN @nLess = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN (-1 * Quantity)
												 WHEN @nBoth = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
												 WHEN @nNo = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
												 ELSE Quantity END
										END))),'') + '##NA' 
							ELSE '-' 
						END as dis_grd_17221,
						null as dis_grd_17222,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN td.DateOfAcquisition ELSE NULL END as dis_grd_17223,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN td.DateOfAcquisition ELSE NULL END as dis_grd_17224,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN GETDATE() ELSE NULL END as dis_grd_17426,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CAcquisitionType.CodeName ELSE '-' END as dis_grd_17427
					from tra_TransactionDetails td
					join @temp t on t.UserInfoId = td.ForUserInfoId
					join usr_UserInfo u on u.UserInfoId = t.UserInfoId
					LEFT JOIN mst_Company co ON u.CompanyId = co.CompanyId
					join com_Code C on C.CodeID = td.SecurityTypeCodeId
					join tra_TransactionMaster tm on tm.TransactionMasterId = td.TransactionMasterId
					join com_Code CAcquisitionType on CAcquisitionType.CodeID = td.ModeOfAcquisitionCodeId
					join com_Code CTransType on CTransType.CodeID = td.TransactionTypeCodeId
					join com_Code Cexchange on Cexchange.CodeID = td.ExchangeCodeId
					LEFT JOIN com_Code CCountry ON CCountry.CodeID = u.CountryId and CCountry.CodeGroupId = @CountryCodeGroupID
					JOIN @tmpTransactions tmIds ON tm.TransactionMasterId = tmIds.TransactionMasterId
				END
				ELSE
				BEGIN
				--Modified(added #Temp_Table) to handle the date of intimation of the transactions on form c having Soft Copy submission is “Not Required” till the threshold limit (as set in Trading Policy -> Continuous Disclosures Section).  
					select * into #Temp_Table from 
					(
					select 
						CASE 
							WHEN TUD.UserTypeCode = @UserTYpe_Corporate THEN ISNULL(TUD.CompanyName,' ') 
							ELSE ISNULL(TUD.FirstName + ' ',' ') + ISNULL(TUD.MiddleName + ' ',' ') + ISNULL(TUD.LastName,' ') 
						END + '##' 
							+ ISNULL(TUD.PanNumber, '') + '##' 
							+ CASE 
								WHEN TUD.UserTypeCode = @UserTYpe_Corporate THEN ISNULL(TUD.CINNumber, ' ') 
								ELSE ISNULL(TUD.DIN, ' ') 
							  END + '##' 
							+ ISNULL(TUD.Address, '')+ ' ' 
							+ ISNULL(', ' + TUD.Pincode, '')  
							+ ISNULL(', ' + TUD.Country, '') + '##' 
							+ ISNULL(TUD.MobileNumber, '') as dis_grd_17209,
						TUD.FormCategoryPerson as dis_grd_17210,
						null as dis_grd_17211,
						case 
							when td.SecurityTypeCodeId in(@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName 
							else '-' 
						end as dis_grd_17212,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share) THEN 
								ISNULL(CONVERT(VARCHAR(MAX),SecuritiesPriorToAcquisition),'') + '##' + ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPreTransaction),'') 
							when td.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN 
								ISNULL(CONVERT(VARCHAR(MAX),SecuritiesPriorToAcquisition),'') + '##NA'
							ELSE '-' 
						END as dis_grd_17213,
						null as dis_grd_17214,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN C.CodeName 
							ELSE '-' 
						END as dis_grd_17215,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),Quantity) 
							ELSE '-' 
						END as dis_grd_17216,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),Value) 
							ELSE '-' 
						END as dis_grd_17217,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CTransType.CodeName 
							ELSE '-'
						END as dis_grd_17218,
						null as dis_grd_17219,
						case 
							when td.SecurityTypeCodeId in(@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName 
							else '-' 
						end as dis_grd_17220,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share) THEN 
								ISNULL(CONVERT(VARCHAR(MAX),(SecuritiesPriorToAcquisition + (
										CASE 											
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_PARTIAL THEN (Quantity-Quantity2) 
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_ALL THEN (Quantity-Quantity2) 
											ELSE CASE WHEN @nLess = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN (-1 * Quantity)
												 WHEN @nBoth = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
												 WHEN @nNo = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
												 ELSE Quantity END
										END))),'') + '##' 
								+ ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPostTransaction),'') 
							when td.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN 
								ISNULL(CONVERT(VARCHAR(MAX),(SecuritiesPriorToAcquisition + (
										CASE 											
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_PARTIAL THEN (Quantity-Quantity2) 
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_ALL THEN (Quantity-Quantity2) 
											ELSE CASE WHEN @nLess = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN (-1 * Quantity)
												 WHEN @nBoth = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
												 WHEN @nNo = (SELECT dbo.uf_tra_GetImpactOnPostQuantity(td.TransactionTypeCodeId, td.ModeOfAcquisitionCodeId, td.SecurityTypeCodeId)) THEN 0
												 ELSE Quantity END
										END))),'') + '##NA' 
							ELSE '-' 
						END as dis_grd_17221,
						null as dis_grd_17222,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN td.DateOfAcquisition 
							ELSE NULL 
						END as dis_grd_17223,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN td.DateOfAcquisition 
							ELSE NULL 
						END as dis_grd_17224,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN
							case when(select count(el.EventDate) from eve_EventLog el where el.MapToId=td.TransactionMasterId and el.EventCodeId = @FormC_Submitted) > 0 
								then (select el.EventDate from eve_EventLog el where el.MapToId=td.TransactionMasterId and el.EventCodeId = @FormC_Submitted)
							end
							
							ELSE NULL 
						END as dis_grd_17426,
						-- Added to update date of intimation on from c if securuty type is future contract or option contract
						td.SecurityTypeCodeId as UserSecurityTypeCode,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CAcquisitionType.CodeName 
							ELSE '-' 
						END as dis_grd_17427
					from tra_TransactionDetails td
					join com_Code C on C.CodeID = td.SecurityTypeCodeId
					join tra_TransactionMaster tm on tm.TransactionMasterId = td.TransactionMasterId
					join com_Code CAcquisitionType on CAcquisitionType.CodeID = td.ModeOfAcquisitionCodeId
					join com_Code CTransType on CTransType.CodeID = td.TransactionTypeCodeId
					JOIN @tmpTransactions tmIds ON tm.TransactionMasterId = tmIds.TransactionMasterId
					LEFT JOIN tra_TradingTransactionUserDetails TUD ON td.TransactionDetailsId = TUD.TransactionDetailsId 
								AND TUD.FormDetails = 1 AND TUD.TransactionMasterId = tmIds.TransactionMasterId 
				    )as Temp_Table
					update #Temp_Table set dis_grd_17426 = (select MAX(dis_grd_17426) from #Temp_Table where dis_grd_17426 is not null)
					where UserSecurityTypeCode in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb)
					select dis_grd_17209,dis_grd_17210,dis_grd_17211,dis_grd_17212,dis_grd_17213,dis_grd_17214,dis_grd_17215,dis_grd_17216,dis_grd_17217,dis_grd_17218,dis_grd_17219,dis_grd_17220,dis_grd_17221,dis_grd_17222,dis_grd_17223,dis_grd_17224,dis_grd_17426,dis_grd_17427 from #Temp_Table
				END
			END
		END
		ELSE IF @inp_nGridNumber = 2
		BEGIN
			IF NOT EXISTS(SELECT TransactionMasterId FROM @tmpTransactions)
			BEGIN
				SELECT 
					NULL as dis_grd_17225,
					'-' as dis_grd_17227,
					'-' as dis_grd_17413,
					NULL as dis_grd_17419,
					'-' as dis_grd_17228,
					'-' as dis_grd_17229,
					NULL as dis_grd_17420,
					'-' as dis_grd_17421,
					'-' as dis_grd_17422,
					'-' as dis_grd_17230
				FROM usr_UserInfo ui LEFT JOIN mst_Company co ON ui.CompanyId = co.CompanyId
				WHERE ui.UserInfoId = @UserId
			END
			ELSE
			BEGIN
				IF (@bShowOriginalUserDetails = 1)
				BEGIN
					select 
						null as dis_grd_17225,
						case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) THEN C.CodeName ELSE '-' END as dis_grd_17227,
						case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) THEN td.ContractSpecification ELSE '-' END as dis_grd_17413,
						null AS dis_grd_17419, --For Buy
						case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_BUY THEN CONVERT(VARCHAR(MAX),td.Value) ELSE '-' END as dis_grd_17228,
						case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options)  AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_BUY THEN CONVERT(VARCHAR(MAX),(Quantity * LotSize)) ELSE '-' END as dis_grd_17229,
						null AS dis_grd_17420, --For Sell
						case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_SELL THEN CONVERT(VARCHAR(MAX),td.Value) ELSE '-' END as dis_grd_17421,
						case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options)  AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_SELL THEN CONVERT(VARCHAR(MAX),(Quantity * LotSize)) ELSE '-' END as dis_grd_17422,
						case when Cexchange.DisplayCode IS NULL OR Cexchange.DisplayCode = '' then Cexchange.CodeName else Cexchange.DisplayCode end as dis_grd_17230
					from tra_TransactionDetails td
					join @temp t on t.UserInfoId = td.ForUserInfoId
					join usr_UserInfo u on u.UserInfoId = t.UserInfoId
					LEFT JOIN mst_Company co ON u.CompanyId = co.CompanyId
					join com_Code C on C.CodeID = td.SecurityTypeCodeId
					join tra_TransactionMaster tm on tm.TransactionMasterId = td.TransactionMasterId
					join com_Code CAcquisitionType on CAcquisitionType.CodeID = td.ModeOfAcquisitionCodeId
					join com_Code CTransType on CTransType.CodeID = td.TransactionTypeCodeId
					join com_Code Cexchange on Cexchange.CodeID = td.ExchangeCodeId
					JOIN @tmpTransactions tmIds ON tm.TransactionMasterId = tmIds.TransactionMasterId
				END
				ELSE
				BEGIN
					select 
						null as dis_grd_17225,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) THEN C.CodeName 
							ELSE '-' 
						END as dis_grd_17227,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) THEN td.ContractSpecification 
							ELSE '-' 
						END as dis_grd_17413,
						null AS dis_grd_17419, --For Buy
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_BUY THEN CONVERT(VARCHAR(MAX),td.Value) 
							ELSE '-' 
						END as dis_grd_17228,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options)  AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_BUY THEN CONVERT(VARCHAR(MAX),(Quantity * LotSize)) 
							ELSE '-' 
						END as dis_grd_17229,
						null AS dis_grd_17420, --For Sell
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_SELL THEN CONVERT(VARCHAR(MAX),td.Value) 
							ELSE '-' 
						END as dis_grd_17421,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options)  AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_SELL THEN CONVERT(VARCHAR(MAX),(Quantity * LotSize)) 
							ELSE '-' 
						END as dis_grd_17422,
						TUD.StockExchange as dis_grd_17230
					from tra_TransactionDetails td
					--join @temp t on t.UserInfoId = td.ForUserInfoId
					--join usr_UserInfo u on u.UserInfoId = t.UserInfoId
					--LEFT JOIN mst_Company co ON u.CompanyId = co.CompanyId
					join com_Code C on C.CodeID = td.SecurityTypeCodeId
					join tra_TransactionMaster tm on tm.TransactionMasterId = td.TransactionMasterId
					join com_Code CAcquisitionType on CAcquisitionType.CodeID = td.ModeOfAcquisitionCodeId
					join com_Code CTransType on CTransType.CodeID = td.TransactionTypeCodeId
					--join com_Code Cexchange on Cexchange.CodeID = td.ExchangeCodeId
					JOIN @tmpTransactions tmIds ON tm.TransactionMasterId = tmIds.TransactionMasterId
					LEFT JOIN tra_TradingTransactionUserDetails TUD ON td.TransactionDetailsId = TUD.TransactionDetailsId 
								AND TUD.FormDetails = 1 AND TUD.TransactionMasterId = tmIds.TransactionMasterId
				END
				
				
			END
		END
			
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CONTINOUSDISCLOSUNONEMPLOYEEINSIDERRELETTER_LIST
	END CATCH
END
