SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_tra_InitialDisclosureLetterList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_tra_InitialDisclosureLetterList]
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list for Initial Disclosure Letter data.

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		25-May-2015

Modification History:
Modified By		Modified On		Description
Arundhati		30-May-2015		Added error code
Swapnil			3-jun-2015		Added condition while getting userinfoid from Transaction MasterId
Swapnil			9-jun-2015		Change in for getting value of share, options and Future contracts.
Arundhati		29-Jun-2015		Case statement is added for CIN/DIN number
Parag			08-Jul-2015		Added transaction master id as parameter to select query to filter record for related transaction only
								Added Check for "no holding" for initial disclosure type
								Added check for coporate user type to show company name 
Raghvendra		27-Jul-2015		Change to remove duplicate values for Name / PAN number etc. from the result set received. 
Tushar			21-Oct-2015		UnComment code for drop table #LetterRecords,#RecordsToBeMergedTo in NoHolding Case								
Raghvendra		24-Nov-2015		Added changes for spliting the Grid used for generating the Form B
Raghvendra		07-Jan-2016		Fix for Mantis bug no 8442, i.e. to show the SubDesignation for the user under the column Category of Person
Raghvendra		13-Jan-2016		Fix for showing - when value is not applicable.
Raghvendra		15-Jan-2016		Fix for showing - when value is not applicable.
Raghvendra		15-Jan-2016		Fix for showing - instead of empty space for corporate type insider for Form B.
Raghvendra		01-Feb-2016		Fix for large relation type name not considered when finding the sub designation for the user
ED				22-Mar-2016		Code integration done with ED code on 22-Mar-2016
Raghvendra		14-Apr-2016		Change to add Pincode and Country in the Address shown on the Form B
Raghvendra		01-May-2016		Change to show 'Immediate Relatives' text instead of the relation in the For Form B. Also to show the Date Of becoming insider 
								relative same as that of the insider.  If date of becoming insider is not available then show Date of Joining.
Parag			10-May-2016		made change to show user details save at time of form submitted
Raghvendra/Parag 01-Jul-2016	Fix for showing DateOfBecoming insider in correct format. Fix for Mantis 9087
Parag			05-Aug-2016		Made change to show negative balance. ie when transaction type is sell then quantity is shown in negative

Usage:
EXEC st_tra_InitialDisclosureLetterList 1,
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_InitialDisclosureLetterList]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_nGridNumber			INT	--1: Top portion of the Grid Shown in Form B, 2:Bottom portion of the Grid shown in the Form B
	,@inp_iTransactionMasterId	INT	
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_INITIALDISCLOSURELETTER_LIST INT = 17244 -- Error occurred while fetching list of transactions.
	
	DECLARE @SecuriyType_Share INT = 139001
	DECLARE @SecuriyType_WArrants INT = 139002
	DECLARE @SecuriyType_ConDEb INT = 139003
	DECLARE @SecuriyType_Futures INT = 139004
	DECLARE @SecuriyType_Options INT = 139005
	
	DECLARE @nUserType_Corporate INT = 101004
	DECLARE @nUserType_Employee INT = 101003
	DECLARE @nUserType_NonEmployee INT = 101006
	DECLARE @nUserType_Relative INT = 101007
	
	DECLARE @Discclosureype_Initial INT = 147001
	DECLARE @UserId INT
	DECLARE @RELATIONTYPE_SELF VARCHAR(10) = 'Self'
		
	DECLARE @nNoInitialHoldingFlag INT
	DECLARE @NoHolding_Text VARCHAR(12) = 'No Holding'
	DECLARE @nUserTypeCodeId INT
	DECLARE @CountryCodeGroupID INT = 107
	DECLARE @TEXT_FOR_RELATIVES VARCHAR(100) = 'Immediate Relative'
	
	DECLARE @nTranStatus_Submitted INT = 148007
	DECLARE @nTranStatus_SoftCopySubmit INT = 148004
	DECLARE @nTranStatus_HardCopySubmit INT = 148005
	DECLARE @nTranStatus_StockExSubmit INT = 148006
	DECLARE @nTranStatus_Confirm INT = 148003
	
	DECLARE @bShowOriginalUserDetails BIT = 1
	DECLARE @bFormDetailsFlag BIT = 1 -- default flag used to get saved form is submitted
	
	DECLARE @TRANSACTION_TYPE_BUY INT = 143001
	DECLARE @TRANSACTION_TYPE_SELL INT = 143002
	
	DECLARE @inp_dtAuthorizedShareCapitalDate DATETIME  = GETDATE()
	DECLARE @dPaidUpShare DECIMAL(30,0)
	DECLARE @nMultiplier INT  = 100

	SELECT TOP 1 @dPaidUpShare =  PaidUpShare 
		FROM com_CompanyPaidUpAndSubscribedShareCapital SC
		INNER JOIN mst_Company C ON SC.CompanyID = C.CompanyId
		WHERE C.IsImplementing = 1
		AND PaidUpAndSubscribedShareCapitalDate <= @inp_dtAuthorizedShareCapitalDate
		ORDER BY PaidUpAndSubscribedShareCapitalDate DESC
	Select @UserId = UserInfoId, @nNoInitialHoldingFlag=NoHoldingFlag from tra_TransactionMaster where TransactionMasterId = @inp_iTransactionMasterId 
															AND DisclosureTypeCodeId = @Discclosureype_Initial
	
	BEGIN TRY
			
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
			SELECT top 1 @UserId,CASE WHEN ISNULL(SubCategoryText,'') = '' THEN '' ELSE SubCategoryText END  AS SubCategoryText FROM usr_UserInfo 
			where UserInfoId = @UserId
		END
		
		ELSE IF  @nUserTypeCodeId = @nUserType_Relative
		BEGIN
		INSERT INTO @temp
		SELECT	@UserId,@TEXT_FOR_RELATIVES 
		END
		
		--INSERT INTO @temp VALUES(@UserId,@RELATIONTYPE_SELF)

		INSERT INTO @temp
		SELECT	UserInfoIdRelative,@TEXT_FOR_RELATIVES 
		FROM usr_UserRelation ur JOIN com_code cc  ON cc.CodeID = ur.RelationTypeCodeId
		WHERE UserInfoId = @UserId
		
		-- check if form is submitted or not 
		IF EXISTS(SELECT tm.TransactionMasterId FROM tra_TransactionMaster tm
					WHERE tm.TransactionMasterId = @inp_iTransactionMasterId AND tm.TransactionStatusCodeId NOT IN (@nTranStatus_Submitted)
					AND (tm.SoftCopyReq = 1 OR (tm.SoftCopyReq = 0 AND tm.HardCopyByCOSubmissionDate IS NOT NULL)) ) 
		BEGIN
			SET @bShowOriginalUserDetails = 0 -- show saved user details for letter
		END
		
		IF @inp_nGridNumber = 1
		BEGIN
			IF(@nNoInitialHoldingFlag = 1)
			BEGIN 
				CREATE TABLE #LetterRecordsNoHolding (
					UserInfoId INT, dis_grd_17131 NVARCHAR(MAX), dis_grd_17132 NVARCHAR(50), dis_grd_17133 DATETIME, dis_grd_17134 VARCHAR(50),
					dis_grd_17135 VARCHAR(50), dis_grd_17136 VARCHAR(50), dis_grd_17137 VARCHAR(50)
				)
				
				IF (@bShowOriginalUserDetails = 1)
				BEGIN
					INSERT INTO #LetterRecordsNoHolding 
						(UserInfoId, dis_grd_17131, dis_grd_17132, dis_grd_17133, dis_grd_17134,dis_grd_17135, dis_grd_17136, dis_grd_17137)
					SELECT 
						UserInfoId, dis_grd_17131, dis_grd_17132, dis_grd_17133, dis_grd_17134,dis_grd_17135, dis_grd_17136, dis_grd_17137
					FROM (
					SELECT
							ui.UserInfoId,
							CASE WHEN ui.UserTypeCodeId = @nUserType_Corporate THEN ISNULL(co.CompanyName,' ') ELSE 
							ISNULL(ui.FirstName + ' ',' ') + ISNULL(ui.MiddleName + ' ',' ') + ISNULL(ui.LastName,' ') END + '##' + ISNULL(ui.PAN,'') 
							+ '##' + CASE WHEN ui.UserTypeCodeId = @nUserType_Corporate THEN ISNULL(ui.CIN,'') ELSE ISNULL(ui.DIN,'') END + '##' + ISNULL(ui.AddressLine1,'')+ ' ' + ISNULL(', ' + ui.PinCode,'')  + CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END  + '##' + ISNULL(ui.MobileNumber,'')
							as dis_grd_17131,
							CCCategory.CodeName as dis_grd_17132,							
							ui.DateOfBecomingInsider as dis_grd_17133,
							'-' as dis_grd_17134, 
							@NoHolding_Text as dis_grd_17135,
							'-' as dis_grd_17136,
							'-' as dis_grd_17137
					from	usr_UserInfo ui 
					LEFT JOIN mst_Company co ON ui.CompanyId = co.CompanyId
					LEFT JOIN com_Code CCountry ON CCountry.CodeID = ui.CountryId and CCountry.CodeGroupId = @CountryCodeGroupID
					LEFT JOIN com_Code CCCategory on CCCategory.CodeID = ui.Category
					WHERE	ui.UserInfoId = @UserId
					) Letter order	by Letter.UserInfoId asc
				END
				ELSE -- show user details save when letter submitted
				BEGIN
					INSERT INTO #LetterRecordsNoHolding 
						(UserInfoId, dis_grd_17131, dis_grd_17132, dis_grd_17133, dis_grd_17134,dis_grd_17135, dis_grd_17136, dis_grd_17137)
					SELECT 
						UserInfoId, dis_grd_17131, dis_grd_17132, dis_grd_17133, dis_grd_17134,dis_grd_17135, dis_grd_17136, dis_grd_17137
					FROM (
						SELECT
							TUD.UserInfoId,
							CASE 
								WHEN TUD.UserTypeCode = @nUserType_Corporate THEN ISNULL(TUD.CompanyName, ' ') 
								ELSE  ISNULL(TUD.FirstName + ' ', ' ') + ISNULL(TUD.MiddleName + ' ', ' ') + ISNULL(TUD.LastName, ' ') 
							END 
								+ '##' + ISNULL(TUD.PanNumber, '') 
								+ '##' + CASE 
											WHEN TUD.UserTypeCode = @nUserType_Corporate THEN ISNULL(TUD.CINNumber,'') 
											ELSE ISNULL(TUD.DIN, '') 
										END 
								+ '##' + ISNULL(TUD.Address, '')+ ' ' 
								+ ISNULL(', ' + TUD.Pincode, '')  
								+ ISNULL(', ' + TUD.Country, '') 
								+ '##' + ISNULL(TUD.MobileNumber, '') as dis_grd_17131,
							'' as dis_grd_17132,
							'-' as dis_grd_17133,
							'-' as dis_grd_17134, 
							@NoHolding_Text as dis_grd_17135,
							'-' as dis_grd_17136,
							'-' as dis_grd_17137
						FROM tra_TradingTransactionUserDetails TUD 
						WHERE TUD.UserInfoId = @UserId AND TUD.TransactionMasterId = @inp_iTransactionMasterId AND TUD.FormDetails = 1
					) Letter order	by Letter.UserInfoId asc
				END
				
				ALTER TABLE #LetterRecordsNoHolding ADD RollId INT IDENTITY
				
				SELECT * into #RecordsToBeMergedToNoHolding FROM
				(select dis_grd_17131,min(RollId) as MinRollId from #LetterRecordsNoHolding group by dis_grd_17131) B
				
				UPDATE B
				SET B.dis_grd_17131 = ''
				FROM #LetterRecordsNoHolding B
				left join #RecordsToBeMergedToNoHolding D ON D.MinRollId = B.RollId
				WHERE D.MinRollId IS NULL
				
				SELECT * FROM #LetterRecordsNoHolding
				DROP TABLE #LetterRecordsNoHolding
			END
			ELSE 
			BEGIN 
				CREATE TABLE #LetterRecords (
					TransactionDetailsId BIGINT, ForUserInfoId INT, dis_grd_17131 NVARCHAR(MAX), dis_grd_17132 VARCHAR(MAX), 
					dis_grd_17133 datetime, dis_grd_17134 VARCHAR(MAX), dis_grd_17135 VARCHAR(MAX), dis_grd_17136 VARCHAR(MAX), 
					dis_grd_17137 VARCHAR(MAX)
				)
				
				IF (@bShowOriginalUserDetails = 1)
				BEGIN
					INSERT INTO #LetterRecords
						(TransactionDetailsId, ForUserInfoId, dis_grd_17131, dis_grd_17132, dis_grd_17133, dis_grd_17134, 
						dis_grd_17135, dis_grd_17136, dis_grd_17137)
					SELECT 
						TransactionDetailsId, ForUserInfoId, dis_grd_17131, dis_grd_17132, dis_grd_17133, dis_grd_17134, 
						dis_grd_17135, dis_grd_17136, dis_grd_17137
					FROM (
						SELECT
							td.TransactionDetailsId,
							td.ForUserInfoId,
							CASE WHEN u.UserTypeCodeId = @nUserType_Corporate THEN ISNULL(co.CompanyName,' ') ELSE 
							ISNULL(u.FirstName + ' ',' ') + ISNULL(u.MiddleName + ' ',' ') + ISNULL(u.LastName,' ') END + '##' + ISNULL(u.PAN,'') 
							+ '##' + CASE WHEN u.UserTypeCodeId = @nUserType_Corporate THEN ISNULL(u.CIN,'') ELSE ISNULL(u.DIN,'') END + '##' + ISNULL(u.AddressLine1,'')+ ' '  + ISNULL(', ' + u.PinCode,'')  + CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END  + '##' + ISNULL(u.MobileNumber,'')
							as dis_grd_17131,
							--CASE WHEN t.relationType = '' THEN t.relationType ELSE t.relationType + '##' + ISNULL(u.FirstName,'') + ' ' + ISNULL(u.MiddleName,'') + ' ' + ISNULL(u.LastName,'') END  as dis_grd_17132,												
							CASE WHEN t.relationType = '' THEN t.relationType ELSE t.relationType END  as dis_grd_17132,												
							--CASE WHEN td.ForUserInfoId = @UserId THEN (select DateOfBecomingInsider from usr_UserInfo where UserInfoId = @UserId) ELSE NULL END as dis_grd_17133,
							ISNULL((select DateOfBecomingInsider from usr_UserInfo where UserInfoId = @UserId),(select DateOfJoining from usr_UserInfo where UserInfoId = @UserId)) as dis_grd_17133,
							null as dis_grd_17134, 
							CASE WHEN td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN C.CodeName ELSE '-' END as dis_grd_17135,
							CASE 
								WHEN td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN 
									CONVERT(VARCHAR(MAX),
										CASE 
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_SELL THEN (-1 * Quantity)
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_BUY THEN Quantity
										END
									) 
								ELSE '-' 
							END as dis_grd_17136,
							CASE WHEN td.SecurityTypeCodeId = @SecuriyType_Share
									 THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,2),(((TD.SecuritiesPriorToAcquisition + Quantity)*@nMultiplier) / @dPaidUpShare))),'')
								else '-'
							END as dis_grd_17137
					from	tra_TransactionDetails td
							JOIN @temp t ON t.UserInfoId = td.ForUserInfoId
							JOIN usr_UserInfo u on u.UserInfoId = t.UserInfoId 
							LEFT JOIN mst_Company co ON u.CompanyId = co.CompanyId
							JOIN com_Code C ON C.CodeID = td.SecurityTypeCodeId
							JOIN tra_TransactionMaster tm ON tm.TransactionMasterId = td.TransactionMasterId
							LEFT JOIN com_Code CCountry ON CCountry.CodeID = u.CountryId and CCountry.CodeGroupId = @CountryCodeGroupID
					where	td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb,@SecuriyType_Futures,@SecuriyType_Options) 
						and tm.DisclosureTypeCodeId = @Discclosureype_Initial AND td.TransactionMasterId = @inp_iTransactionMasterId
					) Letter order	by Letter.ForUserInfoId asc,Letter.TransactionDetailsId
					
				END
				ELSE -- show user details save when letter submitted
				BEGIN
					INSERT INTO #LetterRecords
						(TransactionDetailsId, ForUserInfoId, dis_grd_17131, dis_grd_17132, dis_grd_17133, dis_grd_17134, 
						dis_grd_17135, dis_grd_17136, dis_grd_17137)
					SELECT 
						TransactionDetailsId, ForUserInfoId, dis_grd_17131, dis_grd_17132, dis_grd_17133, dis_grd_17134, 
						dis_grd_17135, dis_grd_17136, dis_grd_17137
					FROM (
						SELECT
							td.TransactionDetailsId,
							td.ForUserInfoId,
							CASE 
								WHEN TUD.UserTypeCode = @nUserType_Corporate THEN ISNULL(TUD.CompanyName, ' ') 
								ELSE ISNULL(TUD.FirstName + ' ',' ') + ISNULL(TUD.MiddleName + ' ', ' ') + ISNULL(TUD.LastName, ' ') 
							END 
								+ '##' + ISNULL(TUD.PanNumber, '') 
								+ '##' + CASE 
											WHEN TUD.UserTypeCode = @nUserType_Corporate THEN ISNULL(TUD.CINNumber, '') 
											ELSE ISNULL(TUD.DIN, '') 
										 END
								+ '##' + ISNULL(TUD.Address, '') + ' '  
								+ ISNULL(', ' + TUD.Pincode, '') 
								+ ISNULL(', ' + TUD.Country, '') 
								+ '##' + ISNULL(TUD.MobileNumber,'') as dis_grd_17131,
							ISNULL(TUD.FormCategoryPerson, '') as dis_grd_17132,												
							ISNULL(TUD.DateOfBecomingInsider, TUD.DateOfJoining) as dis_grd_17133,
							null as dis_grd_17134, 
							CASE 
								WHEN td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN C.CodeName 
								ELSE '-' 
							END as dis_grd_17135,
							CASE 
								WHEN td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN 
									CONVERT(VARCHAR(MAX),
										CASE 
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_SELL THEN (-1 * Quantity)
											WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_BUY THEN Quantity
										END) 
								ELSE '-' 
							END as dis_grd_17136,
							CASE 
								--WHEN td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN CONVERT(VARCHAR(MAX),PerOfSharesPreTransaction) 
								 WHEN td.SecurityTypeCodeId = @SecuriyType_Share
									 THEN ISNULL(CONVERT(VARCHAR(MAX),CONVERT(DECIMAL(10,2),(((TD.SecuritiesPriorToAcquisition + Quantity)*@nMultiplier) / @dPaidUpShare))),'')
								
								ELSE '-' 
							END as dis_grd_17137
						FROM tra_TransactionDetails td
							LEFT JOIN tra_TradingTransactionUserDetails TUD ON td.TransactionDetailsId = TUD.TransactionDetailsId 
								AND TUD.FormDetails = 1 AND TUD.TransactionMasterId = @inp_iTransactionMasterId 
							JOIN com_Code C ON C.CodeID = td.SecurityTypeCodeId
							JOIN tra_TransactionMaster tm ON tm.TransactionMasterId = td.TransactionMasterId
							
						where
							td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb,@SecuriyType_Futures,@SecuriyType_Options) 
							and tm.DisclosureTypeCodeId = @Discclosureype_Initial AND td.TransactionMasterId = @inp_iTransactionMasterId
					) Letter order	by Letter.ForUserInfoId asc,Letter.TransactionDetailsId
				END
				
				
				ALTER TABLE #LetterRecords ADD RollId INT IDENTITY
				
				SELECT * into #RecordsToBeMergedTo FROM
				(select dis_grd_17131,min(RollId) as MinRollId from #LetterRecords group by dis_grd_17131) B
				
				UPDATE B
				SET B.dis_grd_17131 = ''
				FROM #LetterRecords B
				left join #RecordsToBeMergedTo D ON D.MinRollId = B.RollId
				WHERE D.MinRollId IS NULL
				
				SELECT * FROM #LetterRecords
				DROP TABLE #LetterRecords
				DROP TABLE #RecordsToBeMergedTo
			END
		END	
		ELSE IF(@inp_nGridNumber = 2)
		BEGIN
			IF(@nNoInitialHoldingFlag = 1)
			BEGIN 
				SELECT * into #Grid2LetterRecordsNoHolding
				FROM (
				SELECT
						ui.UserInfoId,
						NULL as dis_grd_17138,
						'-' AS dis_grd_17402,						
						'-' as dis_grd_17139,
						'-' as dis_grd_17140, 
						NULL as dis_grd_17141,
						'-' AS dis_grd_17403,												
						'-' as dis_grd_17142,
						'-' as dis_grd_17143
				from	usr_UserInfo ui LEFT JOIN mst_Company co ON ui.CompanyId = co.CompanyId
				WHERE	ui.UserInfoId = @UserId
				) Letter order	by Letter.UserInfoId asc
				
				SELECT * FROM #Grid2LetterRecordsNoHolding
				DROP TABLE #Grid2LetterRecordsNoHolding
			END
			ELSE 
			BEGIN 
				SELECT * into #LetterRecordsGrid2
				FROM (
					SELECT
						td.TransactionDetailsId,
						td.ForUserInfoId,
						null as dis_grd_17138,
						CASE WHEN td.SecurityTypeCodeId = @SecuriyType_Futures THEN td.ContractSpecification ELSE '-' END AS dis_grd_17402,
						CASE 
							WHEN td.SecurityTypeCodeId = @SecuriyType_Futures THEN 
								CONVERT(VARCHAR(MAX), 
									CASE 
										WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_SELL THEN ((-1 * Quantity) * LotSize)
										WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_BUY THEN (Quantity * LotSize)
									END)
							ELSE '-' 
						END as dis_grd_17139,
						CASE WHEN td.SecurityTypeCodeId = @SecuriyType_Futures THEN CONVERT(VARCHAR(MAX),Value) ELSE '-' END as dis_grd_17140, 
						null as dis_grd_17141,
						CASE WHEN td.SecurityTypeCodeId = @SecuriyType_Options THEN td.ContractSpecification  ELSE '-' END AS dis_grd_17403,
						CASE 
							WHEN td.SecurityTypeCodeId = @SecuriyType_Options THEN 
								CONVERT(VARCHAR(MAX),
									CASE 
										WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_SELL THEN ((-1 * Quantity) * LotSize)
										WHEN td.TransactionTypeCodeId = @TRANSACTION_TYPE_BUY THEN (Quantity * LotSize)
									END) 
							ELSE '-' 
						END as dis_grd_17142,
						CASE WHEN td.SecurityTypeCodeId = @SecuriyType_Options THEN CONVERT(VARCHAR(MAX),Value) ELSE '-' END as dis_grd_17143
				from	tra_TransactionDetails td
						JOIN @temp t ON t.UserInfoId = td.ForUserInfoId
						JOIN usr_UserInfo u on u.UserInfoId = t.UserInfoId 
						LEFT JOIN mst_Company co ON u.CompanyId = co.CompanyId
						JOIN com_Code C ON C.CodeID = td.SecurityTypeCodeId
						JOIN tra_TransactionMaster tm ON tm.TransactionMasterId = td.TransactionMasterId
				where	td.SecurityTypeCodeId in (@SecuriyType_Share,@SecuriyType_WArrants,@SecuriyType_ConDEb,@SecuriyType_Futures,@SecuriyType_Options) 
					and tm.DisclosureTypeCodeId = @Discclosureype_Initial AND td.TransactionMasterId = @inp_iTransactionMasterId /*and
					td.SecurityTypeCodeId in( @SecuriyType_Futures,@SecuriyType_Options)*/
				) Letter order	by Letter.ForUserInfoId asc, Letter.TransactionDetailsId
				
				SELECT * FROM #LetterRecordsGrid2
				DROP TABLE #LetterRecordsGrid2
			END
		END
	
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_INITIALDISCLOSURELETTER_LIST
	END CATCH
END
