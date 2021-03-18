SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_tra_ContinousDisclosureEmployeeInsiderLetterList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_tra_ContinousDisclosureEmployeeInsiderLetterList]
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list for Countinous Disclosure Employee insider Letter data.

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		30-May-2015

Modification History:
Modified By		Modified On		Description
Arundhati		30-May-2015		Added error code
Swapnil			3-Jun-2015		Change in method while getting UserInfoId
Ashish			25-Jun-2015		Added condition for CIN and DIN 
Parag			08-Jul-2015		Added additional parameter ie disclosure type to allow showing details for period end disclosure
								Added transaction master id as parameter to select query to filter record for related transaction only
								Added Check for "no period end holding" for period end disclosure type
Arundhati		17-Jul-2015		To include Multiple transactions based on the rule
Raghvendra		25-Nov-2015		Added changes for spliting the Grid used for generating the Form C
Raghvendra		29-Nov-2015		Added new columns in the Form C grid 1
Raghvendra		07-Jan-2016		Fix for Mantis bug no 8442, i.e. to show the SubDesignation for the user under the column Category of Person
Raghvendra		13-Jan-2016		Fix for transaction from continuous disclosure not seen in letter for Form B
Raghvendra		01-Feb-2016		Fix for large relation type name not considered when finding the sub designation for the user
Raghvendra		12-Feb-2016		Fix for trade details not seen on form C when user doesnot have either FirstName, Middle Name or Last Name.
ED			22-Mar-2016		Code integration with ED code on 22-Mar-2016
Raghvendra		25-Mar-2015		Fix for showing the Number of shares for pre and post transaction quantity in Form C and D
Raghvendra		14-Apr-2016		Change to add Pincode and Country in the Address shown on the Form D
Raghvendra		20-Apr-2016		Change to show the Stock exchange value in second grid, grid for Options and Futures on Form D
								Also to consider the Buy or Sale of quantity when finding the value for Securities post transaction
Raghvendra		01-May-2016		Change to show 'Immediate Relatives' text instead of the relation in the For Form C. Also to show the Date Of becoming insider 
								relative same as that of the insider. 
Parag			12-May-2016		made change to show user details save at time of form submitted
Parag			25-May-2016		made change to fix issue found while testing 
								- in case of "cashless all" transaction type, the post transaction quantity would be same as pre transaction quantity
Parag			18-Aug-2016		Code merge with ESOP code
Tushar/RW		05-Oct-2016		Change related to hiding Pre & Post transaction percentage values for non share type securities.
Tushar          11-May-2016     Modified to replace actual date of intimation with form c submission date. 
Usage:
EXEC st_tra_ContinousDisclosureEmployeeInsiderLetterList 1,
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_ContinousDisclosureEmployeeInsiderLetterList]
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
	DECLARE @FormC_Submitted INT = 153021
	
	--Impact on Post Share quantity  
	DECLARE @nLess INT = 505002
	DECLARE @nBoth INT = 505003
	DECLARE @nNo   INT = 505004 

	DECLARE @inp_dtAuthorizedShareCapitalDate DATETIME  = GETDATE()
	DECLARE @dPaidUpShare DECIMAL(30,0)
	DECLARE @nMultiplier INT  = 100

	Select @UserId = UserInfoId, @nNoPeriodEndHoldingFlag=NoHoldingFlag from tra_TransactionMaster where TransactionMasterId = @inp_iTransactionMasterId 
	--AND DisclosureTypeCodeId = @inp_iDisclosureType
	
	BEGIN TRY
		--print 'st_tra_ContinousDisclosureEmployeeInsiderLetterList'
		SELECT TOP 1 @dPaidUpShare =  PaidUpShare 
		FROM com_CompanyPaidUpAndSubscribedShareCapital SC
		INNER JOIN mst_Company C ON SC.CompanyID = C.CompanyId
		WHERE C.IsImplementing = 1
		AND PaidUpAndSubscribedShareCapitalDate <= @inp_dtAuthorizedShareCapitalDate
		ORDER BY PaidUpAndSubscribedShareCapitalDate DESC
		
		SELECT @nUserTypeCodeId = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoid = @UserId
		
		DECLARE @temp TABLE(UserInfoId INT,relationType VARCHAR(512))
		IF @nUserTypeCodeId = @nUserType_Employee
		BEGIN
			
			INSERT INTO @temp (UserInfoId, relationType) 
			SELECT top 1 @UserId,CASE WHEN ISNULL(CC.CodeName,'') = '' THEN '' ELSE CC.CodeName END FROM usr_UserInfo UN 
			left JOIN com_Code CC ON CC.CodeId = UN.SubCategory
			where UN.UserInfoId = @UserId
		END
		ELSE IF  @nUserTypeCodeId = @nUserType_Corporate OR @nUserTypeCodeId = @nUserType_NonEmployee
		BEGIN
			INSERT INTO @temp (UserInfoId, relationType) 
			SELECT top 1 @UserId,CASE WHEN ISNULL(SubCategoryText,'') = '' THEN '' ELSE SubCategoryText END FROM usr_UserInfo 
			where UserInfoId = @UserId
		END
		
		
		
		--INSERT INTO @temp VALUES(@UserId,@RELATIONTYPE_SELF)

		DECLARE @tmpTransactions TABLE(TransactionMasterId INT)

		INSERT INTO @temp
		--SELECT	UserInfoIdRelative,cc.CodeName 
		SELECT	UserInfoIdRelative,@TEXT_FOR_RELATIVES 
		FROM	usr_UserRelation ur
				JOIN com_code cc 
					ON cc.CodeID = ur.RelationTypeCodeId
		WHERE	UserInfoId = @UserId
		
		SELECT @nUserTypeCodeId = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoid = @UserId
		
		INSERT INTO @tmpTransactions
		--select * from  [dbo].[uf_com_TransactionIdsForLetter](@inp_iTransactionMasterId)
		EXEC st_tra_TransactionIdsForLetter @inp_iTransactionMasterId
		
		-- check if form is submitted or not 
		IF EXISTS(SELECT tm.TransactionMasterId FROM tra_TransactionMaster tm
					WHERE tm.TransactionMasterId = @inp_iTransactionMasterId AND tm.TransactionStatusCodeId NOT IN (@nTranStatus_Submitted)
					AND (tm.SoftCopyReq = 1 OR (tm.SoftCopyReq = 0 AND tm.HardCopyByCOSubmissionDate IS NOT NULL)) ) 
		BEGIN
			SET @bShowOriginalUserDetails = 0 -- show saved user details for letter
		END
		
		IF @inp_nGridNumber = 1
		BEGIN
			--IF (@inp_iDisclosureType = @nDisclosure_PeriodEnd AND @nNoPeriodEndHoldingFlag = 1)
			IF NOT EXISTS(SELECT TransactionMasterId FROM @tmpTransactions)
			BEGIN
				IF (@bShowOriginalUserDetails = 1)
				BEGIN
					SELECT 
						ISNULL(u.FirstName+' ',' ') + ISNULL(u.MiddleName+ ' ',' ') + ISNULL(u.LastName,' ') + '##' + ISNULL(u.PAN,'') 
						+ '##' + CASE WHEN u.UserTypeCodeId = 101004 THEN ISNULL(u.CIN,' ') ELSE ISNULL(u.DIN,' ') END + '##' + ISNULL(u.AddressLine1,'')+ ' ' + ISNULL(', ' + u.PinCode,'')  + CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END  + '##' + ISNULL(u.MobileNumber,'')
						as dis_grd_17187,
						@RELATIONTYPE_SELF as dis_grd_17188,
						NULL as dis_grd_17189,
						@NoHolding_Text as dis_grd_17190,
						NULL as dis_grd_17191,
						NULL as dis_grd_17192,
						NULL as dis_grd_17193,
						NULL as dis_grd_17194,
						NULL as dis_grd_17195,
						NULL as dis_grd_17196,
						NULL as dis_grd_17197,
						null as dis_grd_17198,
						NULL as dis_grd_17199,
						NULL as dis_grd_17200,
						NULL as dis_grd_17201,
						NULL as dis_grd_17202,
						NULL as dis_grd_17424,
						NULL as dis_grd_17425
					FROM usr_UserInfo u 
					LEFT JOIN com_Code CCountry ON CCountry.CodeID = u.CountryId and CCountry.CodeGroupId = @CountryCodeGroupID
					WHERE u.UserInfoId = @UserId
				END
				ELSE
				BEGIN
					SELECT 
						ISNULL(TUD.FirstName+' ', ' ') + ISNULL(TUD.MiddleName+ ' ', ' ') + ISNULL(TUD.LastName, ' ') + '##' 
							+ ISNULL(TUD.PanNumber, '') + '##' 
							+ ISNULL(TUD.DIN, '') + '##' 
							+ ISNULL(TUD.Address, '')+ ' ' 
							+ ISNULL(', ' + TUD.Pincode, '')  
							+ ISNULL(', ' + TUD.Country, '') + '##' 
							+ ISNULL(TUD.MobileNumber,'') as dis_grd_17187,
						@RELATIONTYPE_SELF as dis_grd_17188,
						NULL as dis_grd_17189,
						@NoHolding_Text as dis_grd_17190,
						NULL as dis_grd_17191,
						NULL as dis_grd_17192,
						NULL as dis_grd_17193,
						NULL as dis_grd_17194,
						NULL as dis_grd_17195,
						NULL as dis_grd_17196,
						NULL as dis_grd_17197,
						null as dis_grd_17198,
						NULL as dis_grd_17199,
						NULL as dis_grd_17200,
						NULL as dis_grd_17201,
						NULL as dis_grd_17202,
						NULL as dis_grd_17424,
						NULL as dis_grd_17425
					FROM tra_TradingTransactionUserDetails TUD 
					WHERE TUD.UserInfoId = @UserId AND TUD.TransactionMasterId = @inp_iTransactionMasterId AND TUD.FormDetails = 1
				END
			END
			ELSE
			BEGIN
				IF (@bShowOriginalUserDetails = 1)
				BEGIN print '@bShowOriginalUserDetails'
					DECLARE @Temp_Table_ShowDetailsFromUserDetails AS TABLE 
					(
						dis_grd_17187	VARCHAR(MAX),dis_grd_17188	VARCHAR(250),dis_grd_17189	VARCHAR(50),dis_grd_17190	VARCHAR(50),
						dis_grd_17191	VARCHAR(MAX),dis_grd_17192	VARCHAR(50),dis_grd_17193	VARCHAR(50),dis_grd_17194	VARCHAR(50),
						dis_grd_17195	VARCHAR(50),dis_grd_17196	VARCHAR(50),TransactionType	VARCHAR(50),dis_grd_17197	VARCHAR(50),
						dis_grd_17198	VARCHAR(50),dis_grd_17199	VARCHAR(MAX),dis_grd_17200	VARCHAR(50),dis_grd_17201	DATETIME,
						dis_grd_17202	DATETIME,dis_grd_17424	DATETIME,UserSecurityTypeCode INT,dis_grd_17425	VARCHAR(50),
						TransactionDetailsId INT,ForSort INT
					)
					DECLARE @Temp_TableCashlessTransUserDetails AS TABLE 
					(
						dis_grd_17187	VARCHAR(MAX),dis_grd_17188	VARCHAR(250),dis_grd_17189	VARCHAR(50),dis_grd_17190	VARCHAR(50),
						dis_grd_17191	VARCHAR(MAX),dis_grd_17192	VARCHAR(50),dis_grd_17193	VARCHAR(50),dis_grd_17194	VARCHAR(50),
						dis_grd_17195	VARCHAR(50),dis_grd_17196	VARCHAR(50),TransactionType	VARCHAR(50),dis_grd_17197	VARCHAR(50),
						dis_grd_17198	VARCHAR(50),dis_grd_17199	VARCHAR(MAX),dis_grd_17200	VARCHAR(50),dis_grd_17201	DATETIME,
						dis_grd_17202	DATETIME,dis_grd_17424	DATETIME,UserSecurityTypeCode INT,dis_grd_17425	VARCHAR(50),
						TransactionDetailsId INT,ForSort INT
					)
					INSERT INTO @Temp_Table_ShowDetailsFromUserDetails
					select 
						ISNULL(u.FirstName + ' ',' ') + ISNULL(u.MiddleName + ' ',' ') + ISNULL(u.LastName,' ') + '##' + ISNULL(u.PAN,'') 
						+ '##' + CASE WHEN u.UserTypeCodeId = 101004 THEN ISNULL(u.CIN,' ') ELSE ISNULL(u.DIN,' ') END + '##' + ISNULL(u.AddressLine1,'')+ ' ' + ISNULL(', ' + u.PinCode,'')  + CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END  + '##' + ISNULL(u.MobileNumber,'')
						as dis_grd_17187,					
						case when t.relationType = '' Then t.relationType ELSE t.relationType END AS dis_grd_17188,
						null as dis_grd_17189,
						case when td.SecurityTypeCodeId in(@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName else '-' end as dis_grd_17190,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share) THEN ISNULL(CONVERT(VARCHAR(MAX),SecuritiesPriorToAcquisition),'') + '##' + ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPreTransaction),'') 
							when td.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN ISNULL(CONVERT(VARCHAR(MAX),SecuritiesPriorToAcquisition),'') + '##NA'
							ELSE '-' END as dis_grd_17191,
						null as dis_grd_17192,
						case when td.SecurityTypeCodeId in(@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName else '-' end as dis_grd_17193,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),Quantity) ELSE '-' END as dis_grd_17194,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),Value) ELSE '-' END as dis_grd_17195,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CTransType.CodeName ELSE '-' END as dis_grd_17196,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CTransType.CodeID ELSE '-' END as 'TransactionType',
						null as dis_grd_17197,
						case when td.SecurityTypeCodeId in(@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName else '-' end as dis_grd_17198,
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
										
									END))),'') + '##' 
								+ CASE WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_PARTIAL THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,2),(((TD.SecuritiesPriorToAcquisition + Quantity)*@nMultiplier) / @dPaidUpShare))),'')
										WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_ALL THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,2),(((TD.SecuritiesPriorToAcquisition + Quantity)*@nMultiplier) / @dPaidUpShare))),'') 
										ELSE ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPostTransaction),'') END
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
										
									END))),'') + '##NA' 
							ELSE '-' 
						END as dis_grd_17199,
						null as dis_grd_17200,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN td.DateOfAcquisition ELSE NULL END as dis_grd_17201,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN td.DateOfAcquisition ELSE NULL END as dis_grd_17202,					
					    case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN GETDATE() ELSE NULL END as dis_grd_17424,
						td.SecurityTypeCodeId as UserSecurityTypeCode,
						case when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CAcquisitionType.CodeName ELSE '-' END as dis_grd_17425,
						TD.TransactionDetailsId AS TransactionDetailsId,
						1 as ForSort
					from tra_TransactionDetails td
					join @temp t on t.UserInfoId = td.ForUserInfoId
					join usr_UserInfo u on u.UserInfoId = t.UserInfoId
					join com_Code C on C.CodeID = td.SecurityTypeCodeId
					join tra_TransactionMaster tm on tm.TransactionMasterId = td.TransactionMasterId
					join com_Code CAcquisitionType on CAcquisitionType.CodeID = td.ModeOfAcquisitionCodeId
					join com_Code CTransType on CTransType.CodeID = td.TransactionTypeCodeId
					join com_Code Cexchange on Cexchange.CodeID = td.ExchangeCodeId
					LEFT JOIN com_Code CCountry ON CCountry.CodeID = u.CountryId and CCountry.CodeGroupId = @CountryCodeGroupID
					JOIN @tmpTransactions tmIds ON tm.TransactionMasterId = tmIds.TransactionMasterId
					ORDER BY TD.SecurityTypeCodeId,td.TransactionDetailsId,TD.DateOfAcquisition

					INSERT INTO @Temp_TableCashlessTransUserDetails 
					SELECT 
						dis_grd_17187,
						dis_grd_17188,
						dis_grd_17189,
						dis_grd_17190,
						dis_grd_17199 AS 'dis_grd_17191',
						dis_grd_17192,
						dis_grd_17193,
						dis_grd_17194,
						dis_grd_17195,
						dis_grd_17196,
						TransactionType,
						dis_grd_17197,
						dis_grd_17198,
						dis_grd_17199,
						dis_grd_17200,
						dis_grd_17201,
						dis_grd_17202,
						dis_grd_17424,
						UserSecurityTypeCode,
						dis_grd_17425,
						TransactionDetailsId,
						2 as ForSort 
					FROM @Temp_Table_ShowDetailsFromUserDetails T
					WHERE T.TransactionType IN(143004,143005)
					
					UPDATE @Temp_TableCashlessTransUserDetails 
						SET dis_grd_17194 = TD.Quantity2,
							dis_grd_17195 = TD.Value2, 
							dis_grd_17199 = CASE WHEN TD.SecurityTypeCodeId in (@SecuriyType_Share) THEN ISNULL(CONVERT(VARCHAR(MAX),(CONVERT(DECIMAL(10,0),SUBSTRING(dis_grd_17191, 0,CHARINDEX('#', dis_grd_17191))) - TD.Quantity2)),'')
							+ '##' + CASE WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_PARTIAL
									 THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,2),(((TD.SecuritiesPriorToAcquisition - Quantity2)*@nMultiplier) / @dPaidUpShare))),'')
									WHEN TD.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_ALL 
									THEN ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPostTransaction),'') END
							ELSE CASE WHEN TD.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN ISNULL(CONVERT(VARCHAR(MAX),(CONVERT(DECIMAL(10,0),SUBSTRING(dis_grd_17191, 0,CHARINDEX('#', dis_grd_17191))) - TD.Quantity2)),'')+ '##NA' END END
					FROM @Temp_TableCashlessTransUserDetails Temp 
					JOIN tra_TransactionDetails TD ON Temp.TransactionDetailsId = TD.TransactionDetailsId

					UPDATE @Temp_TableCashlessTransUserDetails
					SET dis_grd_17199 = CASE WHEN (SUBSTRING(dis_grd_17199, CHARINDEX('##', dis_grd_17199)+2,LEN(dis_grd_17199))) < 0 
										THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,0),SUBSTRING(dis_grd_17199, 0,CHARINDEX('#', dis_grd_17199)))),'')+'##0.00'
										ELSE dis_grd_17199 END
					
					INSERT INTO @Temp_Table_ShowDetailsFromUserDetails
					SELECT 
						dis_grd_17187,
						dis_grd_17188,
						dis_grd_17189,
						dis_grd_17190,
						dis_grd_17191,
						dis_grd_17192,
						dis_grd_17193,
						dis_grd_17194,
						dis_grd_17195,
						dis_grd_17196,
						TransactionType,
						dis_grd_17197,
						dis_grd_17198,
						dis_grd_17199,
						dis_grd_17200,
						dis_grd_17201,
						dis_grd_17202,
						dis_grd_17424,
						UserSecurityTypeCode,
						dis_grd_17425,
						TransactionDetailsId ,
						ForSort
					FROM @Temp_TableCashlessTransUserDetails
					
				
					SELECT 
						dis_grd_17187,
						dis_grd_17188,
						dis_grd_17189,
						dis_grd_17190,
						dis_grd_17191,
						dis_grd_17192,
						dis_grd_17193,
						dis_grd_17194,
						dis_grd_17195,
						dis_grd_17196,
						TransactionType,
						dis_grd_17197,
						dis_grd_17198,
						dis_grd_17199,
						dis_grd_17200,
						dis_grd_17201,
						dis_grd_17202,
						dis_grd_17424,
						dis_grd_17425,
						TransactionDetailsId 
					FROM @Temp_Table_ShowDetailsFromUserDetails
					ORDER BY dis_grd_17190,TransactionDetailsId,dis_grd_17201,ForSort
				END
				ELSE
				BEGIN print 'else'
				    --Modified(added @Temp_Table) to handle the date of intimation of the transactions on form c having Soft Copy submission is “Not Required” till the threshold limit (as set in Trading Policy -> Continuous Disclosures Section).  
					DECLARE @Temp_Table AS TABLE 
					(
						dis_grd_17187	VARCHAR(MAX),dis_grd_17188	VARCHAR(250),dis_grd_17189	VARCHAR(50),dis_grd_17190	VARCHAR(50),
						dis_grd_17191	VARCHAR(MAX),dis_grd_17192	VARCHAR(50),dis_grd_17193	VARCHAR(50),dis_grd_17194	VARCHAR(50),
						dis_grd_17195	VARCHAR(50),dis_grd_17196	VARCHAR(50),TransactionType	VARCHAR(50),dis_grd_17197	VARCHAR(50),
						dis_grd_17198	VARCHAR(50),dis_grd_17199	VARCHAR(MAX),dis_grd_17200	VARCHAR(50),dis_grd_17201	DATETIME,
						dis_grd_17202	DATETIME,dis_grd_17424	DATETIME,UserSecurityTypeCode INT,dis_grd_17425	VARCHAR(50),
						TransactionDetailsId INT,dis_grd_55501 VARCHAR(50)
					)
					DECLARE @Temp_TableCashlessTrans AS TABLE 
					(
						dis_grd_17187	VARCHAR(MAX),dis_grd_17188	VARCHAR(250),dis_grd_17189	VARCHAR(50),dis_grd_17190	VARCHAR(50),
						dis_grd_17191	VARCHAR(MAX),dis_grd_17192	VARCHAR(50),dis_grd_17193	VARCHAR(50),dis_grd_17194	VARCHAR(50),
						dis_grd_17195	VARCHAR(50),dis_grd_17196	VARCHAR(50),TransactionType	VARCHAR(50),dis_grd_17197	VARCHAR(50),
						dis_grd_17198	VARCHAR(50),dis_grd_17199	VARCHAR(MAX),dis_grd_17200	VARCHAR(50),dis_grd_17201	DATETIME,
						dis_grd_17202	DATETIME,dis_grd_17424	DATETIME,UserSecurityTypeCode INT,dis_grd_17425	VARCHAR(50),
						TransactionDetailsId INT,dis_grd_55501 VARCHAR(50)
					)
					INSERT INTO @Temp_Table
					SELECT *  from 
					(
					select 
						ISNULL(TUD.FirstName + ' ', ' ') + ISNULL(TUD.MiddleName + ' ', ' ') + ISNULL(TUD.LastName, ' ') + '##' 
							+ ISNULL(TUD.PanNumber, '') + '##' 
							+ ISNULL(TUD.DIN, ' ') + '##' 
							+ ISNULL(TUD.Address, '')+ ' ' 
							+ ISNULL(', ' + TUD.Pincode, '')  
							+ ISNULL(', ' + TUD.Country, '')  + '##' 
							+ ISNULL(TUD.MobileNumber, '') as dis_grd_17187,					
						ISNULL(TUD.FormCategoryPerson, '') AS dis_grd_17188,
						null as dis_grd_17189,
						case 
							when td.SecurityTypeCodeId in(@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName 
							else '-' 
						end as dis_grd_17190,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share) THEN 
								ISNULL(CONVERT(VARCHAR(MAX),SecuritiesPriorToAcquisition),'') + '##' 
								+ ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPreTransaction),'') 
							when td.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN 
								ISNULL(CONVERT(VARCHAR(MAX),SecuritiesPriorToAcquisition),'') + '##NA' 
							ELSE '-' 
						END as dis_grd_17191,
						null as dis_grd_17192,
						case 
							when td.SecurityTypeCodeId in(@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName 
							else '-' 
						end as dis_grd_17193,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),Quantity) 
							ELSE '-' 
						END as dis_grd_17194,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),Value) 
							ELSE '-' 
						END as dis_grd_17195,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CTransType.CodeName 
							ELSE '-' 
						END as dis_grd_17196,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CTransType.CodeID 
							ELSE '-' 
						END as 'TransactionType',
						null as dis_grd_17197,
						case 
							when td.SecurityTypeCodeId in(@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) then C.CodeName 
							else '-' 
						end as dis_grd_17198,
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
										
									END))),'') + '##' 
								+ CASE WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_PARTIAL THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,2),(((TD.SecuritiesPriorToAcquisition + Quantity)*@nMultiplier) / @dPaidUpShare))),'')
										WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_ALL THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,2),(((TD.SecuritiesPriorToAcquisition + Quantity)*@nMultiplier) / @dPaidUpShare))),'') 
										ELSE ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPostTransaction),'') END
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
										
									END))),'') + '##NA' 
							ELSE '-' 
						END as dis_grd_17199,
						null as dis_grd_17200,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN td.DateOfAcquisition
							 ELSE NULL END as dis_grd_17201,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN td.DateOfAcquisition 
							ELSE NULL END as dis_grd_17202,					
						case 
						    when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb)then
				    	    case when(select count(el.EventDate) from eve_EventLog el where el.MapToId=td.TransactionMasterId and el.EventCodeId = @FormC_Submitted) > 0 
								then (select el.EventDate from eve_EventLog el where el.MapToId=td.TransactionMasterId and el.EventCodeId = @FormC_Submitted)
							end
						ELSE NULL end as dis_grd_17424,	
	                    -- Added to update date of intimation on from c if securuty type is future contract or option contract.
						td.SecurityTypeCodeId as UserSecurityTypeCode,
						case 
							when td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CAcquisitionType.CodeName 
							ELSE '-' 
						END as dis_grd_17425,
						TD.TransactionDetailsId AS TransactionDetailsId,
						case 
							when td.SecurityTypeCodeId not in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN '-' 
							ELSE TUD.StockExchange 
						END AS dis_grd_55501
					from tra_TransactionDetails td
					join com_Code C on C.CodeID = td.SecurityTypeCodeId
					join tra_TransactionMaster tm on tm.TransactionMasterId = td.TransactionMasterId
					join com_Code CAcquisitionType on CAcquisitionType.CodeID = td.ModeOfAcquisitionCodeId
					join com_Code CTransType on CTransType.CodeID = td.TransactionTypeCodeId
					JOIN @tmpTransactions tmIds ON tm.TransactionMasterId = tmIds.TransactionMasterId
					LEFT JOIN tra_TradingTransactionUserDetails TUD ON td.TransactionDetailsId = TUD.TransactionDetailsId 
								AND TUD.FormDetails = 1 AND TUD.TransactionMasterId = tmIds.TransactionMasterId
					)as Temp_Table

					update @Temp_Table
						set dis_grd_17424 = (select MAX(dis_grd_17424) from @Temp_Table where dis_grd_17424 is not null)
					where UserSecurityTypeCode in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb)
					
					INSERT INTO @Temp_TableCashlessTrans 
					SELECT 
						dis_grd_17187,
						dis_grd_17188,
						dis_grd_17189,
						dis_grd_17190,
						dis_grd_17199 AS 'dis_grd_17191',
						dis_grd_17192,
						dis_grd_17193,
						dis_grd_17194,
						dis_grd_17195,
						dis_grd_17196,
						TransactionType,
						dis_grd_17197,
						dis_grd_17198,
						dis_grd_17199,
						dis_grd_17200,
						dis_grd_17201,
						dis_grd_17202,
						dis_grd_17424,
						UserSecurityTypeCode,
						dis_grd_17425,
						TransactionDetailsId,
						dis_grd_55501
					FROM @Temp_Table T
					WHERE T.TransactionType IN(143004,143005)
					
					UPDATE @Temp_TableCashlessTrans 
						SET dis_grd_17194 = TD.Quantity2,
							dis_grd_17195 = TD.Value2, 
							dis_grd_17199 = CASE WHEN TD.SecurityTypeCodeId in (@SecuriyType_Share) THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,0),ABS(SUBSTRING(dis_grd_17191, 0,CHARINDEX('#', dis_grd_17191)) - TD.Quantity2))),'')
							+ '##' + CASE WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_PARTIAL
									 THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,2),((ABS(SUBSTRING(dis_grd_17199,0 ,CHARINDEX('##', dis_grd_17199)) - Quantity2)*@nMultiplier) / @dPaidUpShare))),'')
									WHEN TD.TransactionTypeCodeId = @TRANSACTION_TYPE_CASHLESS_ALL 
									THEN ISNULL(CONVERT(VARCHAR(MAX),PerOfSharesPostTransaction),'') END
							ELSE CASE WHEN TD.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN ISNULL(CONVERT(VARCHAR(MAX),(CONVERT(DECIMAL(10,0),SUBSTRING(dis_grd_17191, 0,CHARINDEX('#', dis_grd_17191))) - TD.Quantity2)),'')+ '##NA' END END
					FROM @Temp_TableCashlessTrans Temp 
					JOIN tra_TransactionDetails TD ON Temp.TransactionDetailsId = TD.TransactionDetailsId

					UPDATE @Temp_TableCashlessTransUserDetails
					SET dis_grd_17199 = CASE WHEN (SUBSTRING(dis_grd_17199, CHARINDEX('##', dis_grd_17199)+2,LEN(dis_grd_17199))) < 0 
										THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,0),SUBSTRING(dis_grd_17199, 0,CHARINDEX('#', dis_grd_17199)))),'')+'##0.00'
										ELSE dis_grd_17199 END
					
					INSERT INTO @Temp_Table
					SELECT 
						dis_grd_17187,
						dis_grd_17188,
						dis_grd_17189,
						dis_grd_17190,
						dis_grd_17191,
						dis_grd_17192,
						dis_grd_17193,
						dis_grd_17194,
						dis_grd_17195,
						dis_grd_17196,
						TransactionType,
						dis_grd_17197,
						dis_grd_17198,
						dis_grd_17199,
						dis_grd_17200,
						dis_grd_17201,
						dis_grd_17202,
						dis_grd_17424,
						UserSecurityTypeCode,
						dis_grd_17425,
						TransactionDetailsId ,
						dis_grd_55501
					FROM @Temp_TableCashlessTrans
					
					SELECT 
						dis_grd_17187,
						dis_grd_17188,
						dis_grd_17189,
						dis_grd_17190,
						dis_grd_17191,
						dis_grd_17192,
						dis_grd_17193,
						dis_grd_17194,
						dis_grd_17195,
						dis_grd_17196,
						TransactionType,
						dis_grd_17197,
						dis_grd_17198,
						dis_grd_17199,
						dis_grd_17200,
						dis_grd_17201,
						dis_grd_17202,
						dis_grd_17424,
						dis_grd_17425,
						TransactionDetailsId ,
						dis_grd_55501
					FROM @Temp_Table
					ORDER BY dis_grd_17190,TransactionDetailsId,dis_grd_17201

					
				END
			END
		END
		ELSE IF @inp_nGridNumber = 2
		BEGIN
			IF NOT EXISTS(SELECT TransactionMasterId FROM @tmpTransactions)
			BEGIN
				SELECT 
					NULL as dis_grd_17203,
					NULL as dis_grd_17205,
					NULL as dis_grd_17411,
					NULL as dis_grd_17415,
					NULL as dis_grd_17206,
					NULL as dis_grd_17207,
					NULL as dis_grd_17416,
					NULL as dis_grd_17417,
					NULL as dis_grd_17418,
					NULL as dis_grd_17208
				FROM usr_UserInfo u WHERE u.UserInfoId = @UserId
			END
			ELSE
			BEGIN
				IF (@bShowOriginalUserDetails = 1)
				BEGIN
					SELECT 
					null as dis_grd_17203,
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) THEN C.CodeName ELSE '-' END AS dis_grd_17205,
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) THEN td.ContractSpecification ELSE '-' END AS dis_grd_17411,
					null AS dis_grd_17415,
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_BUY THEN CONVERT(VARCHAR(MAX),td.Value) ELSE '-' END  AS dis_grd_17206,
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_BUY THEN CONVERT(VARCHAR(MAX),(Quantity * LotSize)) ELSE '-' END  AS dis_grd_17207,
					null as dis_grd_17416,
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_SELL THEN CONVERT(VARCHAR(MAX),td.Value) ELSE '-' END  AS dis_grd_17417,
					case when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_SELL THEN CONVERT(VARCHAR(MAX),(Quantity * LotSize)) ELSE '-' END  AS dis_grd_17418,
					case when Cexchange.DisplayCode IS NULL OR Cexchange.DisplayCode = '' then Cexchange.CodeName else Cexchange.DisplayCode end as dis_grd_17208
					
					from tra_TransactionDetails td
					join @temp t on t.UserInfoId = td.ForUserInfoId
					join usr_UserInfo u on u.UserInfoId = t.UserInfoId
					join com_Code C on C.CodeID = td.SecurityTypeCodeId
					join tra_TransactionMaster tm on tm.TransactionMasterId = td.TransactionMasterId
					join com_Code CAcquisitionType on CAcquisitionType.CodeID = td.ModeOfAcquisitionCodeId
					join com_Code CTransType on CTransType.CodeID = td.TransactionTypeCodeId
					join com_Code Cexchange on Cexchange.CodeID = td.ExchangeCodeId
					JOIN @tmpTransactions tmIds ON tm.TransactionMasterId = tmIds.TransactionMasterId
					ORDER BY TD.SecurityTypeCodeId,td.TransactionDetailsId,TD.DateOfAcquisition
				END
				ELSE 
				BEGIN
					SELECT 
					null as dis_grd_17203,
					case 
						when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) THEN C.CodeName 
						ELSE '-' 
					END AS dis_grd_17205,
					case 
						when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) THEN td.ContractSpecification 
						ELSE '-' 
					END AS dis_grd_17411,
					null AS dis_grd_17415,
					case 
						when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_BUY THEN CONVERT(VARCHAR(MAX),td.Value) 
						ELSE '-' 
					END  AS dis_grd_17206,
					case 
						when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_BUY THEN CONVERT(VARCHAR(MAX),(Quantity * LotSize)) 
						ELSE '-' 
					END  AS dis_grd_17207,
					null as dis_grd_17416,
					case 
						when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_SELL THEN CONVERT(VARCHAR(MAX),td.Value) 
						ELSE '-' 
					END  AS dis_grd_17417,
					case 
						when td.SecurityTypeCodeId in (@SecuriyType_Futures,@SecuriyType_Options) AND td.TransactionTypeCodeID = @TRANSACTION_TYPE_SELL THEN CONVERT(VARCHAR(MAX),(Quantity * LotSize)) 
						ELSE '-' 
					END  AS dis_grd_17418,
					case 
						when td.SecurityTypeCodeId not in (@SecuriyType_Futures,@SecuriyType_Options) THEN '-' 
						ELSE TUD.StockExchange 
					END AS dis_grd_17208
					
					from tra_TransactionDetails td
					--join @temp t on t.UserInfoId = td.ForUserInfoId
					--join usr_UserInfo u on u.UserInfoId = t.UserInfoId
					join com_Code C on C.CodeID = td.SecurityTypeCodeId
					join tra_TransactionMaster tm on tm.TransactionMasterId = td.TransactionMasterId
					join com_Code CAcquisitionType on CAcquisitionType.CodeID = td.ModeOfAcquisitionCodeId
					join com_Code CTransType on CTransType.CodeID = td.TransactionTypeCodeId
					--join com_Code Cexchange on Cexchange.CodeID = td.ExchangeCodeId
					JOIN @tmpTransactions tmIds ON tm.TransactionMasterId = tmIds.TransactionMasterId
					LEFT JOIN tra_TradingTransactionUserDetails TUD ON td.TransactionDetailsId = TUD.TransactionDetailsId 
								AND TUD.FormDetails = 1 AND TUD.TransactionMasterId = tmIds.TransactionMasterId
								ORDER BY TD.SecurityTypeCodeId,td.TransactionDetailsId, TD.DateOfAcquisition
				END
				
			END
		END	
			
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CONTINOUSDISCLOSUeMPLOYEEINSIDERRELETTER_LIST
	END CATCH
END

