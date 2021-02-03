SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_tra_PeriodEndDisclosureEmployeeInsiderLetterList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosureEmployeeInsiderLetterList]
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list for Period End Disclosure Employee insider Letter data i.e. form G

Returns:		0, if Success.
				
Created by:		Priyanka,Rutuja
Created on:		02-Jan-2017

Modification History:
Modified By		Modified On		Description

Usage:
EXEC st_tra_PeriodEndContinousEmployeeInsiderLetterList 1,
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosureEmployeeInsiderLetterList] --1,1,'','asc','1','28','6','125003','124006', 1,1,'1'
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_nGridNumber			NVARCHAR(10)	--1: Top portion of the Grid Shown in Form C, 2:Bottom portion of the Grid shown in the Form C
	,@inp_iTransactionMasterId	NVARCHAR(1000)	
	,@inp_iUserInfoId 	 	    NVARCHAR(1000)
	,@inp_iYearCodeId 		    NVARCHAR(1000)
	,@inp_iPeriodCodeID 		NVARCHAR(1000)
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

	--DECLARE @UserId INT
	DECLARE @RELATIONTYPE_SELF VARCHAR(10) = 'Self'
	
	DECLARE @nTranStatus_Submitted INT = 148007
	
	DECLARE @ERR_PERIODENDDISCLOSURE_SUMMARYDETAILS	INT = 17041 -- Error occurred while fetching list of period end disclosure summary details.
	DECLARE @nSecurityType INT
	DECLARE @nPeriodType INT
	DECLARE @CountryCodeGroupID INT = 107
	DECLARE @SecurityCodeGroupID INT =139
	DECLARE @PESoftCopySubmitedEventID INT = 153031
	DECLARE @DisclosureTransactionID INT = 132005
	
	DECLARE @nUserType_Corporate INT = 101004
	DECLARE @nUserType_Employee INT = 101003
	DECLARE @nUserType_NonEmployee INT = 101006
	DECLARE @nUserTypeCodeId INT
	DECLARE @TEXT_FOR_RELATIVES VARCHAR(100) = 'Immediate Relative'
	DECLARE @nMultipler INT = 100
		
	BEGIN TRY
		SET NOCOUNT ON;
		
	-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		SELECT @nPeriodType = ParentCodeId FROM com_Code WHERE CodeID = @inp_iPeriodCodeID
			
		IF @inp_nGridNumber = 1
		BEGIN
			SET NOCOUNT ON;
		
			SELECT TOP(1) @nSecurityType = CodeId FROM com_Code WHERE CodeGroupId = 139 ORDER BY CodeID ASC
			
			
			SELECT @nUserTypeCodeId = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoid = @inp_iUserInfoId
		
			DECLARE @temp TABLE(UserInfoId INT,relationType VARCHAR(512))
			
			IF @nUserTypeCodeId = @nUserType_Employee
			BEGIN
				
				INSERT INTO @temp (UserInfoId, relationType) 
				SELECT top 1 @inp_iUserInfoId,CASE WHEN ISNULL(CC.CodeName,'') = '' THEN '' ELSE CC.CodeName END FROM usr_UserInfo UN 
				left JOIN com_Code CC ON CC.CodeId = UN.SubCategory
				where UN.UserInfoId = @inp_iUserInfoId
			END
			ELSE IF  @nUserTypeCodeId = @nUserType_Corporate OR @nUserTypeCodeId = @nUserType_NonEmployee
			BEGIN
				INSERT INTO @temp (UserInfoId, relationType) 
				SELECT top 1 @inp_iUserInfoId,CASE WHEN ISNULL(SubCategoryText,'') = '' THEN '' ELSE SubCategoryText END FROM usr_UserInfo 
				where UserInfoId = @inp_iUserInfoId
			END
			
			INSERT INTO @temp
			SELECT	UserInfoIdRelative,@TEXT_FOR_RELATIVES 
			FROM	usr_UserRelation ur
					JOIN com_code cc 
						ON cc.CodeID = ur.RelationTypeCodeId
			WHERE	UserInfoId = @inp_iUserInfoId
			
			--Get Subscribed Capital for % of shareholding calculations
			DECLARE @date date
			SET @date=GETDATE()
			DECLARE @tempShareCapitalDetails TABLE(CompanyPaidUpAndSubscribedShareCapitalID INT,CompanyID int, PaidUpAndSubscribedShareCapitalDate Date, PaidUpShare Decimal(20,2))
			
			INSERT INTO @tempShareCapitalDetails
			EXEC st_com_CompanyAuthorizedShareCapitalDetailsForTransaction @date,0,0,''
			
			DECLARE @SubscribedCapital Decimal(20,2)
			select @SubscribedCapital=PaidUpShare from @tempShareCapitalDetails
			print @SubscribedCapital
			
			DECLARE @PESCSubmited DATETIME
			SET @PESCSubmited = (SELECT e.EventDate FROM eve_EventLog e WHERE e.EventCodeId = @PESoftCopySubmitedEventID AND e.UserInfoId = @inp_iUserInfoId AND e.MapToId = @inp_iTransactionMasterId AND e.MapToTypeCodeId = @DisclosureTransactionID)
			PRINT @PESCSubmited
			
			-- Define temporary table and add user details for summary 
			CREATE TABLE #tmpPeriodEndDisclosureSummary (Id INT IDENTITY(1,1),UserId INT, Name VARCHAR(500), UserRelativeCode INT, Relation VARCHAR(500), 
			BSecurityTypeCode INT, BSecurityType VARCHAR(500), OpeningStock varchar(max), Bought INT, Sold INT,ESecurityTypeCode INT, ESecurityType VARCHAR(500), 
			PeriodEndHolding varchar(max),DateOfIntimation DATE,TotalPledge INT,Pledge INT,Unpledge INT)

			-- Insert user details for each security type
			INSERT INTO #tmpPeriodEndDisclosureSummary (UserId, Name, UserRelativeCode, Relation, BSecurityTypeCode, BSecurityType,ESecurityTypeCode,ESecurityType,DateOfIntimation)
			SELECT 
				UI.UserInfoId as UserId, 
				CASE WHEN ui.UserTypeCodeId = @nUserType_Corporate THEN ISNULL(co.CompanyName,' ') ELSE
				ISNULL(UI.FirstName+' ',' ') + ISNULL(UI.MiddleName+ ' ',' ') + ISNULL(UI.LastName,' ')END + '##' + ISNULL(UI.PAN,'') 
							+ '##' + CASE WHEN UI.UserTypeCodeId = @nUserType_Corporate THEN ISNULL(UI.CIN,' ') ELSE ISNULL(UI.DIN,' ') END + '##' 
							+ ISNULL(UI.AddressLine1,'')+ ' ' + ISNULL(', ' + UI.PinCode,'')  
							+ CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END  
							+ '##' + ISNULL(UI.MobileNumber,'') as Name, 
				'1' as UserRelativeCode,
				CASE WHEN UI.UserTypeCodeId = @nUserType_Corporate OR UI.UserTypeCodeId = @nUserType_NonEmployee THEN UI.SubCategoryText 
					ELSE CASE WHEN UI.SubCategory IS NOT NULL THEN (SELECT code.CodeName FROM com_Code code WHERE CodeID=UI.SubCategory)ELSE '' END END as Relation,
				CDSecurity.CodeID as BSecurityTypeCode, 
				CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as BSecurityType,
				CDSecurity.CodeID as ESecurityTypeCode, 
				CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as ESecurityType,
				CASE WHEN @PESCSubmited IS NULL THEN dbo.uf_com_GetServerDate() ELSE @PESCSubmited END AS DateOfIntimation
			FROM 
				usr_UserInfo UI
				RIGHT OUTER JOIN com_Code CDSecurity on CDSecurity.CodeGroupId = @SecurityCodeGroupID
				and CDSecurity.CodeID NOT IN (@SecuriyType_Futures,@SecuriyType_Options)
				LEFT JOIN com_Code CCountry ON CCountry.CodeGroupId = UI.CountryId and CCountry.CodeGroupId = @CountryCodeGroupID
				LEFT JOIN mst_Company co ON ui.CompanyId = co.CompanyId
			WHERE
				UI.UserInfoId = @inp_iUserInfoId 
		
			-- Insert user's all relative details for each security type
			INSERT INTO #tmpPeriodEndDisclosureSummary (UserId, Name, UserRelativeCode, Relation, BSecurityTypeCode, BSecurityType,ESecurityTypeCode,ESecurityType,DateOfIntimation)
			SELECT 
				UI.UserInfoId as UserId, 
				ISNULL(UI.FirstName+' ',' ') + ISNULL(UI.MiddleName+ ' ',' ') + ISNULL(UI.LastName,' ') + '##' + ISNULL(UI.PAN,'') 
							+ '##' + CASE WHEN UI.UserTypeCodeId = 101004 THEN ISNULL(UI.CIN,' ') ELSE ISNULL(UI.DIN,' ') END + '##' 
							+ ISNULL(UI.AddressLine1,'')+ ' ' + ISNULL(', ' + UI.PinCode,'')  
							+ CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END  
							+ '##' + ISNULL(UI.MobileNumber,'') as Name,
							 t.UserInfoId as UserRelativeCode, 
				case when t.relationType = '' Then t.relationType ELSE t.relationType END AS dis_grd_17188,--CDURelation.CodeName as Relation,
				CDSecurity.CodeID as BSecurityTypeCode, 
				CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as BSecurityType,
				CDSecurity.CodeID as ESecurityTypeCode, 
				CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as ESecurityType,
				CASE WHEN @PESCSubmited IS NULL THEN dbo.uf_com_GetServerDate() ELSE @PESCSubmited END AS DateOfIntimation
		FROM 
			usr_UserInfo UI 
			JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoIdRelative
			join @temp t on t.UserInfoId = UI.UserInfoId
			--LEFT JOIN com_Code CDURelation ON UR.RelationTypeCodeId = CDURelation.CodeID
			RIGHT OUTER JOIN com_Code CDSecurity on CDSecurity.CodeGroupId=@SecurityCodeGroupID
			and CDSecurity.CodeID NOT IN (@SecuriyType_Futures,@SecuriyType_Options)
			LEFT JOIN com_Code CCountry ON CCountry.CodeGroupId = UI.CountryId and CCountry.CodeGroupId = @CountryCodeGroupID
		WHERE
			UR.UserInfoId = @inp_iUserInfoId
			
				
			--update temp table with transcation summary details
			UPDATE #tmpPeriodEndDisclosureSummary SET 
				OpeningStock =case when TranSummary.SecurityTypeCodeId in (@SecuriyType_Share) THEN 
									ISNULL(CONVERT(VARCHAR(MAX),TranSummary.OpeningBalance),'') + '##' 
									+ ISNULL(CONVERT(VARCHAR(MAX),ROUND(CAST(((TranSummary.OpeningBalance*@nMultipler)/@SubscribedCapital)AS DECIMAL(20,2)),2)),'')
									when TranSummary.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN 
									ISNULL(CONVERT(VARCHAR(MAX),TranSummary.OpeningBalance),'') + '##NA'
									ELSE '-' END,
				Bought = TranSummary.BuyQuantity, 
				Sold = TranSummary.SellQuantity,
				PeriodEndHolding = case when TranSummary.SecurityTypeCodeId in (@SecuriyType_Share) THEN 
									ISNULL(CONVERT(VARCHAR(MAX),TranSummary.ClosingBalance),'') + '##' 
									+ ISNULL(CONVERT(VARCHAR(MAX),ROUND(CAST(((TranSummary.ClosingBalance*@nMultipler)/@SubscribedCapital)AS DECIMAL(20,2)),2)),'') 
									when TranSummary.SecurityTypeCodeId in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN 
									ISNULL(CONVERT(VARCHAR(MAX),TranSummary.ClosingBalance),'') + '##NA'
									ELSE '-' END,
				TotalPledge = TranSummary.PledgeBuyQuantity,
				Pledge = TranSummary.PledgeClosingBalance,
				UnPledge = TranSummary.PledgeSellQuantity
			FROM 
				#tmpPeriodEndDisclosureSummary tmpSummary INNER JOIN tra_TransactionSummary TranSummary ON 
				tmpSummary.UserId = TranSummary.UserInfoIdRelative AND 
				tmpSummary.BSecurityTypeCode = TranSummary.SecurityTypeCodeId AND
				tmpSummary.ESecurityTypeCode = TranSummary.SecurityTypeCodeId AND
				TranSummary.YearCodeId = @inp_iYearCodeId AND
				TranSummary.PeriodCodeId = @inp_iPeriodCodeID
				
			-- made change to show last period closing balance as this period opening balance
			UPDATE  TmpTS
			SET 
				OpeningStock =CASE WHEN(YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID)THEN
								  CASE WHEN TmpTS.BSecurityTypeCode in (@SecuriyType_Share) THEN 
										ISNULL(CONVERT(VARCHAR(MAX),TranSummary.OpeningBalance),'0') + '##' 
										+ ISNULL(CONVERT(VARCHAR(MAX),ROUND(CAST(((TranSummary.OpeningBalance*@nMultipler)/@SubscribedCapital)AS DECIMAL(20,2)),2)),'0.00')
									   WHEN TmpTS.BSecurityTypeCode in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN
										ISNULL(CONVERT(VARCHAR(MAX),TranSummary.OpeningBalance),'0') + '##NA'
								  ELSE '0##0.00' END
							  ELSE
								  CASE WHEN TmpTS.BSecurityTypeCode in (@SecuriyType_Share) THEN 
										ISNULL(CONVERT(VARCHAR(MAX),TranSummary.ClosingBalance),'0') + '##' 
										+ ISNULL(CONVERT(VARCHAR(MAX),ROUND(CAST(((TranSummary.ClosingBalance*@nMultipler)/@SubscribedCapital)AS DECIMAL(20,2)),2)),'0.00')
										WHEN TmpTS.BSecurityTypeCode in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN
										ISNULL(CONVERT(VARCHAR(MAX),TranSummary.ClosingBalance),'0') + '##NA'
								  ELSE '0##0.00' END 
							  END,
				Bought = CASE WHEN (YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID) THEN TranSummary.BuyQuantity ELSE 0 END,
				Sold = CASE WHEN (YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID) THEN TranSummarY.SellQuantity ELSE 0 END,
				PeriodEndHolding = CASE WHEN TmpTS.BSecurityTypeCode in (@SecuriyType_Share) THEN 
									ISNULL(CONVERT(VARCHAR(MAX),TranSummary.ClosingBalance),'0') + '##' 
									+ ISNULL(CONVERT(VARCHAR(MAX),ROUND(CAST(((TranSummary.ClosingBalance*@nMultipler)/@SubscribedCapital)AS DECIMAL(20,2)),2)),'0.00')
									WHEN TmpTS.BSecurityTypeCode in (@SecuriyType_WArrants,@SecuriyType_ConDEb) THEN
									ISNULL(CONVERT(VARCHAR(MAX),TranSummary.ClosingBalance),'0') + '##NA'
									ELSE '0##0.00' END,
				TotalPledge = 0,
				Pledge = 0,
				Unpledge = 0
			FROM #tmpPeriodEndDisclosureSummary TmpTS
			LEFT JOIN 
			(SELECT t.UserId, t.BSecurityTypeCode, OpeningBalance, BuyQuantity, SellQuantity, ClosingBalance,t.ESecurityTypeCode,YearCodeId,PeriodCodeId
				 FROM tra_TransactionSummary TS JOIN
				(
					SELECT t.UserId, t.BSecurityTypeCode,t.ESecurityTypeCode, MAX(TS.TransactionSummaryId)TransactionSummaryId
					FROM #tmpPeriodEndDisclosureSummary t LEFT JOIN tra_TransactionSummary TS 
						ON TS.UserInfoIdRelative = t.UserId AND t.BSecurityTypeCode = TS.SecurityTypeCodeId AND t.ESecurityTypeCode = TS.SecurityTypeCodeId
							AND ((TS.YearCodeId = @inp_iYearCodeId AND TS.PeriodCodeId < @inp_iPeriodCodeID
											AND TS.PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType)) 
								OR (TS.YearCodeId < @inp_iYearCodeId AND TS.PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType)))
					WHERE t.OpeningStock IS NULL
					GROUP BY t.UserId, t.BSecurityTypeCode,t.ESecurityTypeCode
				) t ON t.TransactionSummaryId = TS.TransactionSummaryId
			) TranSummary ON TmpTS.UserId = TranSummary.UserId AND TmpTS.BSecurityTypeCode = TranSummary.BSecurityTypeCode AND TmpTS.ESecurityTypeCode = TranSummary.ESecurityTypeCode
			WHERE TmpTS.OpeningStock IS NULL
			
			/***************** Make the columns UserName, Relation Name blank for the repeat rows *****************/
			UPDATE #tmpPeriodEndDisclosureSummary
			SET Name = '',
				Relation = ''
			WHERE BSecurityTypeCode <> @nSecurityType AND ESecurityTypeCode <> @nSecurityType
						
			SELECT
			T.Name as dis_grd_50442,
			T.Relation as dis_grd_50388,
							NULL as dis_grd_50389,
							T.BSecurityType as dis_grd_50390,
							T.OpeningStock as dis_grd_50391,
							NULL as dis_grd_50392,
							T.Bought as dis_grd_50393,
							T.Sold as dis_grd_50394,
							NULL as dis_grd_50395,
							T.ESecurityType as dis_grd_50396,
							T.PeriodEndHolding as dis_grd_50397,
							T.DateOfIntimation as dis_grd_50398,
							T.TotalPledge as dis_grd_50399,
							T.Pledge as dis_grd_50400,
							T.Unpledge as dis_grd_50401 
			FROM #tmpPeriodEndDisclosureSummary T
			
			-- Delete temporary table
			DROP TABLE #tmpPeriodEndDisclosureSummary
		
		END
		
		ELSE IF @inp_nGridNumber = 2
		BEGIN
		-- Define temporary table and add user details for summary 
			CREATE TABLE #tmpPeriodEndDisclosureSummaryGrid2 (Id INT IDENTITY(1,1),UserId INT,TypeOfContractCodeID INT, TypeOfContract VARCHAR(500), OpeningStock INT, Bought INT, Sold INT, 
			PeriodEndHolding INT)
			
			--Insert user details in to #tmpPeriodEndDisclosureSummaryGrid2 table
			INSERT INTO #tmpPeriodEndDisclosureSummaryGrid2(UserId,TypeOfContractCodeID,TypeOfContract)
			SELECT UI.UserInfoId as UserId,
				CASE WHEN CDSecurity.CodeID in (@SecuriyType_Futures,@SecuriyType_Options) THEN CDSecurity.CodeID END,
				CASE WHEN CDSecurity.CodeID in (@SecuriyType_Futures,@SecuriyType_Options) THEN CDSecurity.CodeName END
			FROM usr_UserInfo UI
				RIGHT OUTER JOIN com_Code CDSecurity on CDSecurity.CodeGroupId=@SecurityCodeGroupID
			WHERE UI.UserInfoId=@inp_iUserInfoId
			
			--Insert user's relative details in to #tmpPeriodEndDisclosureSummaryGrid2 table
			INSERT INTO #tmpPeriodEndDisclosureSummaryGrid2(UserId,TypeOfContractCodeID,TypeOfContract)
			SELECT UI.UserInfoId as UserId,
				CASE WHEN CDSecurity.CodeID in (@SecuriyType_Futures,@SecuriyType_Options) THEN CDSecurity.CodeID END,
				CASE WHEN CDSecurity.CodeID in (@SecuriyType_Futures,@SecuriyType_Options) THEN CDSecurity.CodeName END
			FROM 
				usr_UserInfo UI JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoIdRelative
				LEFT JOIN com_Code CDURelation ON UR.RelationTypeCodeId = CDURelation.CodeID
				RIGHT OUTER JOIN com_Code CDSecurity on CDSecurity.CodeGroupId=@SecurityCodeGroupID
				LEFT JOIN com_Code CCountry ON CCountry.CodeGroupId = UI.CountryId and CCountry.CodeGroupId = @CountryCodeGroupID
		WHERE
			UR.UserInfoId = @inp_iUserInfoId
			
			--update temp table with transcation summary details
			UPDATE #tmpPeriodEndDisclosureSummaryGrid2 SET 
				OpeningStock = TranSummary.OpeningBalance, 
				Bought = TranSummary.BuyQuantity, 
				Sold = TranSummary.SellQuantity,
				PeriodEndHolding = TranSummary.ClosingBalance
			FROM 
				#tmpPeriodEndDisclosureSummaryGrid2 tmpSummary INNER JOIN tra_TransactionSummary TranSummary ON 
				tmpSummary.UserId = TranSummary.UserInfoIdRelative AND 
				tmpSummary.TypeOfContractCodeID = TranSummary.SecurityTypeCodeId AND
				TranSummary.YearCodeId = @inp_iYearCodeId AND
				TranSummary.PeriodCodeId = @inp_iPeriodCodeID
			
			UPDATE  TmpTS
			SET 
				OpeningStock = CASE WHEN(YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID)THEN ISNULL(TranSummary.OpeningBalance,0) ELSE TranSummary.ClosingBalance END,
				Bought = CASE WHEN (YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID) THEN TranSummary.BuyQuantity ELSE NULL END,
				Sold = CASE WHEN (YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID) THEN TranSummarY.SellQuantity ELSE NULL END,
				PeriodEndHolding = TranSummary.ClosingBalance
			FROM #tmpPeriodEndDisclosureSummaryGrid2 TmpTS
			LEFT JOIN 
			(SELECT t.UserId, t.TypeOfContractCodeID, OpeningBalance, BuyQuantity, SellQuantity, ClosingBalance,YearCodeId,PeriodCodeId
				 FROM tra_TransactionSummary TS JOIN
				(
					SELECT t.UserId, t.TypeOfContractCodeID,MAX(TS.TransactionSummaryId)TransactionSummaryId
					FROM #tmpPeriodEndDisclosureSummaryGrid2 t LEFT JOIN tra_TransactionSummary TS 
						ON TS.UserInfoIdRelative = t.UserId AND t.TypeOfContractCodeID = TS.SecurityTypeCodeId
							AND ((TS.YearCodeId = @inp_iYearCodeId AND TS.PeriodCodeId < @inp_iPeriodCodeID
											AND TS.PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType)) 
								OR (TS.YearCodeId < @inp_iYearCodeId AND TS.PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType)))
					WHERE t.OpeningStock IS NULL
					GROUP BY t.UserId, t.TypeOfContractCodeID
				) t ON t.TransactionSummaryId = TS.TransactionSummaryId
			) TranSummary ON TmpTS.UserId = TranSummary.UserId AND TmpTS.TypeOfContractCodeID = TranSummary.TypeOfContractCodeID
			WHERE TmpTS.OpeningStock IS NULL
				
			SELECT
							NULL as dis_grd_50402,
							T.TypeOfContract as dis_grd_50403,
							T.OpeningStock as dis_grd_50404,
							NULL as dis_grd_50405,
							T.Bought as dis_grd_50406,
							NULL as dis_grd_50407,
							T.Sold as dis_grd_50422,
							T.PeriodEndHolding as dis_grd_50408
			FROM #tmpPeriodEndDisclosureSummaryGrid2 T
			
			-- Delete temporary table
			DROP TABLE #tmpPeriodEndDisclosureSummaryGrid2
		END
		--RETURN 0
	END	TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CONTINOUSDISCLOSUeMPLOYEEINSIDERRELETTER_LIST
	END CATCH
END
