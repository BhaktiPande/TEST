
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosurePeriodSummary_OS')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosurePeriodSummary_OS]
GO
/****** Object:  StoredProcedure [dbo].[st_tra_PeriodEndDisclosurePeriodSummary_OS]    Script Date: 19-03-2021 16:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************************************************
Description:	Procedure to get summary details for period end disclosure other securities

Returns:		Return 0, if success.
				
Created by:		Samadhan
Created on:		30-July-2019

Modification History:


******************************************************************************************************************

Usage:
	exec [st_tra_PeriodEndDisclosurePeriodSummary_OS] 599,125006, 124011 

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosurePeriodSummary_OS]
	@inp_iUserInfoId 	 	INT,
	@inp_iYearCodeId 		INT,
	@inp_iPeriodCodeID 		INT,
	@out_nReturnValue 		INT = 0 OUTPUT,
	@out_nSQLErrCode 		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_PERIODENDDISCLOSURE_SUMMARYDETAILS	INT = 54170 -- Error occurred while fetching list of period end disclosure summary details for other securities.
	DECLARE @sCompany NVARCHAR(200)
	DECLARE @nSecurityType INT
	DECLARE @nPeriodType INT
	DECLARE @dtStartDate datetime  
    DECLARE @dtEndDate datetime  
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			EXECUTE st_tra_PeriodEndDisclosureStartEndDate2  
            @inp_iYearCodeId OUTPUT, @inp_iPeriodCodeID OUTPUT,null,123004, 0,   
            @dtStartDate OUTPUT, @dtEndDate OUTPUT,   
            @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		SELECT @sCompany = CompanyName FROM mst_Company WHERE IsImplementing = 1
		SELECT TOP(1) @nSecurityType = CodeId FROM com_Code WHERE CodeGroupId = 139 ORDER BY CodeID ASC
		
		SET @inp_iPeriodCodeID=124001
		
		SELECT @nPeriodType = ParentCodeId FROM com_Code WHERE CodeID = @inp_iPeriodCodeID
		
		-- Define temporary table and add user details for summary 
		Declare @tmpPeriodEndDisclosureSummary_OS Table (Id INT IDENTITY(1,1), CompanyName NVARCHAR(200) DEFAULT '',
			UserId INT, Name VARCHAR(500), UserRelativeCode INT, Relation VARCHAR(500), SecurityTypeCode INT, SecurityType VARCHAR(500), 
			OpeningStock INT, Bought INT, Sold INT, PeriodEndHolding INT)
		
		--select * from @tmpPeriodEndDisclosureSummary_OS
		-- Insert user details for each security type
		INSERT INTO @tmpPeriodEndDisclosureSummary_OS (UserId, Name, UserRelativeCode, Relation, SecurityTypeCode, SecurityType)
		SELECT 
			UI.UserInfoId as UserId,
			CASE WHEN UI.UserTypeCodeId = 101004 THEN Com.CompanyName ELSE UI.FirstName + ISNULL(' ' + UI.LastName, '') END as Name, 
			NULL as UserRelativeCode, 
			CASE WHEN UI.UserTypeCodeId = 101004 THEN NULL ELSE 'Self' END as Relation, 
			CDSecurity.CodeID as SecurityTypeCode, 
			CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as SecurityType
		FROM 
			usr_UserInfo UI 
			RIGHT OUTER JOIN com_Code CDSecurity on CDSecurity.CodeGroupId=139
			LEFT JOIN mst_Company Com ON UI.CompanyId = Com.CompanyId
		WHERE
			UI.UserInfoId = @inp_iUserInfoId 

		-- Insert user's all relative details for each security type
		INSERT INTO @tmpPeriodEndDisclosureSummary_OS (UserId, Name, UserRelativeCode, Relation, SecurityTypeCode, SecurityType)
		SELECT 
			UI.UserInfoId as UserId, UI.FirstName + ISNULL(' ' + UI.LastName, '') as Name, CDURelation.CodeID as UserRelativeCode, 
			CDURelation.CodeName as Relation, CDSecurity.CodeID as SecurityTypeCode, 
			CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as SecurityType
		FROM 
			usr_UserInfo UI JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoIdRelative
			LEFT JOIN com_Code CDURelation ON UR.RelationTypeCodeId = CDURelation.CodeID
			RIGHT OUTER JOIN com_Code CDSecurity on CDSecurity.CodeGroupId=139
		WHERE
			  UR.UserInfoId = @inp_iUserInfoId and ur.UserInfoIdRelative not in( select UserInfoId from usr_UserInfo as u where  u.UserInfoId =UR.UserInfoIdRelative and CreatedOn > @dtEndDate) 

			DECLARE @TV_tra_TransactionSummaryDMATWise_OS AS TABLE --- THIS WILL TABLE VARIABLE FOR STORING DATA FROM tra_TransactionSummaryDMATWise_OS TABLE 
			(
				[TransactionSummaryId] [bigint] IDENTITY(1,1) NOT NULL,
				[YearCodeId] [int] NOT NULL,
				[PeriodCodeId] [int] NOT NULL,
				[UserInfoId] [int] NOT NULL,
				[UserInfoIdRelative] [int] NULL,
				[SecurityTypeCodeId] [int] NOT NULL,
				[OpeningBalance] [decimal](10, 0) NOT NULL,
				[SellQuantity] [decimal](10, 0) NOT NULL,
				[BuyQuantity] [decimal](10, 0) NOT NULL,
				[ClosingBalance] [decimal](10, 0) NOT NULL,
				[Value] [decimal](25, 4) NULL,
				[PledgeBuyQuantity] [decimal](10, 0) NOT NULL DEFAULT ((0)),
				[PledgeSellQuantity] [decimal](10, 0) NOT NULL DEFAULT ((0)),
				[PledgeClosingBalance] [decimal](10, 0) NOT NULL DEFAULT ((0))
			)

			-- THIS WILL INSERT DATA FROM tra_TransactionSummaryDMATWise_OS TABLE   where YearCodeId and	PeriodCodeId and UserInfoId 

			INSERT INTO  @TV_tra_TransactionSummaryDMATWise_OS
			(
				[YearCodeId],
				[PeriodCodeId], 
				[UserInfoId],
				[UserInfoIdRelative],
				[SecurityTypeCodeId],
				[OpeningBalance] ,
				[SellQuantity],
				[BuyQuantity] ,
				[ClosingBalance] ,
				[PledgeBuyQuantity],
				[PledgeSellQuantity],
				[PledgeClosingBalance]
			)
			select  YearCodeId,	
					PeriodCodeId,	
					UserInfoId,	
					UserInfoIdRelative,	
					SecurityTypeCodeId,					
					0,	
					SUM(SellQuantity) AS SellQuantity,	
					SUM(BuyQuantity) AS BuyQuantity,	
					SUM(ClosingBalance) AS ClosingBalance,	
					SUM(PledgeBuyQuantity) AS PledgeBuyQuantity,	
					SUM(PledgeSellQuantity) AS PledgeSellQuantity,	
					SUM(PledgeClosingBalance) AS PledgeClosingBalance
			 from tra_TransactionSummaryDMATWise_OS
			 where UserInfoId=@inp_iUserInfoId 
			 group by  YearCodeId,	
					PeriodCodeId,	
					UserInfoId,	
					UserInfoIdRelative,	
					SecurityTypeCodeId 	

			 DECLARE @nCount1 INT=0
			 DECLARE @nTotCount INT=0

			 CREATE TABLE #tmpUserinfoid
			 (
			 ID int identity(1,1),
			 Userinfoid INT
			 )
			 INSERT INTO #tmpUserinfoid
			 SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoId=@inp_iUserInfoId
			 INSERT INTO #tmpUserinfoid
			 SELECT @inp_iUserInfoId

			 CREATE TABLE #tmpSecTypeYearcodeid
			 (
			 ID INT IDENTITY(1,1),
			 YearCodeID INT,
			 SecurityTypeCodeID INT,
			 UserInfoID INT
			 )
			 INSERT INTO #tmpSecTypeYearcodeid
			 SELECT MAX(YEARCODEID),SecurityTypeCodeId,UserInfoIdRelative FROM tra_TransactionSummaryDMATWise_OS WHERE UserInfoIdRelative in(SELECT Userinfoid FROM #tmpUserinfoid)
			 GROUP BY SecurityTypeCodeId,UserInfoIdRelative

			 SELECT @nTotCount=count(ID) FROM #tmpSecTypeYearcodeid
			 
			 WHILE @nCount1<@nTotCount
			 BEGIN
					 DECLARE @nSecurityTypeCodeID INT=0
					 DECLARE @nYearCodeID INT=0
					 DECLARE @nUserInfoId INT=0
					 SELECT @nSecurityTypeCodeID=SecurityTypeCodeID,@nYearCodeID=YearCodeID,@nUserInfoId=UserInfoID FROM #tmpSecTypeYearcodeid WHERE ID= @nCount1+1

					IF(@nYearCodeID IN(@inp_iYearCodeId-1,@inp_iYearCodeId))
					BEGIN
						Create table #tmpCompID
						 (
						 ID int identity(1,1),
						 CompId int,
						 yearcodeid int
						 )
						 insert #tmpCompID(CompId,yearcodeid)
						 select companyid,min(YearCodeId)  from 
						 (SELECT CompanyId,DMATDetailsID,max(YearCodeId) YearCodeId FROM tra_TransactionSummaryDMATWise_OS WHERE PeriodCodeId=124001 AND UserInfoId=@inp_iUserInfoId and UserInfoIdRelative=@nUserInfoId group by CompanyId,DMATDetailsID)
						 a where  YearCodeId not in(@inp_iYearCodeId-1,@inp_iYearCodeId) group by companyid			 
						 
						 DECLARE @nClosingBalnce INT=0			 
						 SELECT @nClosingBalnce=SUM(CLOSINGBALANCE) FROM tra_TransactionSummaryDMATWise_OS WHERE CompanyId IN(
						 SELECT DISTINCT CompanyId FROM tra_TransactionSummaryDMATWise_OS WHERE UserInfoId=@inp_iUserInfoId and UserInfoIdRelative=@nUserInfoId
						 AND CompanyId NOT IN(
						 SELECT CompanyId FROM tra_TransactionSummaryDMATWise_OS WHERE YearCodeId IN(@inp_iYearCodeId-1,@inp_iYearCodeId) AND PeriodCodeId=124001 AND UserInfoId=@inp_iUserInfoId and UserInfoIdRelative=@nUserInfoId and CompanyId not in(select distinct CompId from #tmpCompID)))
						 AND UserInfoId=@inp_iUserInfoId  and UserInfoIdRelative=@nUserInfoId AND yearcodeid not IN(@inp_iYearCodeId-1) and PeriodCodeId=124001 AND SecurityTypeCodeId=@nSecurityTypeCodeID
						 --print(@nClosingBalnce)
						 drop table #tmpCompID
						IF(@nClosingBalnce is not null and @nClosingBalnce<>'')
						BEGIN
						--print('@inp_iYearCodeId-1')
						--print(@inp_iYearCodeId-1)
						--print('@inp_iYearCodeId')
						--print(@inp_iYearCodeId)
						UPDATE @TV_tra_TransactionSummaryDMATWise_OS SET ClosingBalance=ClosingBalance+@nClosingBalnce WHERE UserInfoId=@inp_iUserInfoId and  UserInfoIdRelative=@nUserInfoId
						and SecurityTypeCodeId= @nSecurityTypeCodeID and PeriodCodeId=124001 and YearCodeId=@inp_iYearCodeId-1
						END

					 END
				SET @nCount1=@nCount1+1

			   END
			   			 
				 DROP TABLE #tmpSecTypeYearcodeid
				 DROP TABLE #tmpUserinfoid						
									
				DECLARE @tmpOpeningbalance table(ID int identity (1,1),ClosingBalance [decimal](10, 0), SecurityTypeCodeId int,UserInfoId int,UserInfoIdRelative int,yearcodeid int,periordcodeid int)
				INSERT INTO @tmpOpeningbalance
				select ClosingBalance,SecurityTypeCodeId,UserInfoId,UserInfoIdRelative,@inp_iYearCodeId,PeriodCodeId from @TV_tra_TransactionSummaryDMATWise_OS where PeriodCodeId=124001 and
				YearCodeId=(@inp_iYearCodeId-1)
				DECLARE @nCount INT=0
				SELECT @nCount=COUNT(ID) FROM @tmpOpeningbalance
				IF(@nCount<>'')
				BEGIN
					UPDATE @TV_tra_TransactionSummaryDMATWise_OS  SET OpeningBalance=OS.ClosingBalance
					FROM @TV_tra_TransactionSummaryDMATWise_OS TOS
					JOIN @tmpOpeningbalance OS ON TOS.UserInfoId=OS.UserInfoId AND TOS.UserInfoIdRelative=OS.UserInfoIdRelative
					AND TOS.SecurityTypeCodeId=OS.SecurityTypeCodeId AND TOS.PeriodCodeId=OS.periordcodeid AND TOS.YearCodeId=OS.yearcodeid
				END
					

		--update temp table with transcation summary details
		UPDATE @tmpPeriodEndDisclosureSummary_OS SET 
			OpeningStock = TranSummary.OpeningBalance, 
			Bought = TranSummary.BuyQuantity, 
			Sold = TranSummary.SellQuantity,
			PeriodEndHolding = (TranSummary.OpeningBalance + TranSummary.BuyQuantity)-TranSummary.SellQuantity
		FROM 
			@tmpPeriodEndDisclosureSummary_OS tmpSummary INNER JOIN @TV_tra_TransactionSummaryDMATWise_OS TranSummary ON 
			tmpSummary.UserId = TranSummary.UserInfoIdRelative AND 
			tmpSummary.SecurityTypeCode = TranSummary.SecurityTypeCodeId AND
			TranSummary.YearCodeId = @inp_iYearCodeId AND
			TranSummary.PeriodCodeId = @inp_iPeriodCodeID
	
			-- made change to show last period closing balance as this period opening balance
			
			UPDATE  TmpTS
		SET 
			OpeningStock =CASE WHEN(YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID)THEN TranSummary.OpeningBalance ELSE ISNULL(TranSummary.ClosingBalance, 0)END,
			Bought = CASE WHEN (YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID) THEN TranSummary.BuyQuantity ELSE 0 END,
			Sold = CASE WHEN (YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID) THEN TranSummarY.SellQuantity ELSE 0 END,
			PeriodEndHolding = ISNULL(TranSummary.ClosingBalance, 0)
		FROM @tmpPeriodEndDisclosureSummary_OS TmpTS
		LEFT JOIN 
		(SELECT t.UserId, t.SecurityTypeCode, OpeningBalance, BuyQuantity, SellQuantity, ClosingBalance,YearCodeId,PeriodCodeId
			 FROM @TV_tra_TransactionSummaryDMATWise_OS TS JOIN
			(
				SELECT t.UserId, t.SecurityTypeCode, MAX(TS.TransactionSummaryId)TransactionSummaryId
				FROM @tmpPeriodEndDisclosureSummary_OS t LEFT JOIN @TV_tra_TransactionSummaryDMATWise_OS TS 
					ON TS.UserInfoIdRelative = t.UserId AND t.SecurityTypeCode = TS.SecurityTypeCodeId 
						AND ((TS.YearCodeId = @inp_iYearCodeId AND PeriodCodeId<@inp_iPeriodCodeID
										AND PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType))
							OR(TS.YearCodeId < @inp_iYearCodeId AND PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType)))
				WHERE t.OpeningStock IS NULL
				GROUP BY t.UserId, t.SecurityTypeCode
			) t ON t.TransactionSummaryId = TS.TransactionSummaryId
		) TranSummary ON TmpTS.UserId = TranSummary.UserId AND TmpTS.SecurityTypeCode = TranSummary.SecurityTypeCode
		WHERE TmpTS.OpeningStock IS NULL
			/***************** Make the columns UserName, Relation Name blank for the repeat rows *****************/
		
		UPDATE @tmpPeriodEndDisclosureSummary_OS
		SET Name = '',
			Relation = ''
		WHERE SecurityTypeCode <> @nSecurityType

			SELECT 
				T.Name AS dis_grd_54160,
				T.Relation AS dis_grd_54161,
				T.SecurityType AS dis_grd_54162,
				T.OpeningStock AS dis_grd_54163,				
				--T.OpeningStock AS dis_grd_54164,
				T.Bought as dis_grd_54164,
				T.Sold AS dis_grd_54165,
				T.PeriodEndHolding AS dis_grd_54166,
				T.SecurityTypeCode,
				T.UserId,
				T.UserRelativeCode
			FROM @tmpPeriodEndDisclosureSummary_OS T
			
end