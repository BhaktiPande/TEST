IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_UpdateTradingPolicyForProhibitPreSetting')
DROP PROCEDURE [dbo].[st_rul_UpdateTradingPolicyForProhibitPreSetting]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	Created By  :	SHUBHANGI GURUDE
	Created On 	:	31-Aug-2018
	Description :	This SP is used to Update the table column values of rul_tradingPolicy (For Airtel Customization)
*/

/*-------UPDATE rul_tradingPolicy-------*/
	CREATE PROCEDURE [dbo].[st_rul_UpdateTradingPolicyForProhibitPreSetting]
	@inp_iTradingPolicyId	INT
	AS
	
	BEGIN	
		UPDATE
			rul_tradingPolicy 
		SET 
			[IsProhibitPreClrFunctionalityApplicable]=1, [ProhibitPreClrPercentageAppFlag]=1 
			, [ProhibitPreClrOnPercentage] =25, [ProhibitPreClrOnQuantityAppFlag]=1
			, [ProhibitPreClrOnQuantity]=50000 , [ProhibitPreClrForPeriod]=137002
			, [ProhibitPreClrForAllSecurityType]=1	
		WHERE 	
			TradingPolicyId=@inp_iTradingPolicyId	
			
			DECLARE @nTotCnt INT=0
			DECLARE @nCount INT=0
			DECLARE @nSecurityTypeCodeid INT=0
						
			CREATE TABLE #tempSecurityType(ID INT IDENTITY(1,1),SecurityTypeCodeId INT)
			INSERT INTO #tempSecurityType
			SELECT CodeID FROM com_Code WHERE CodeGroupId=139
			SELECT @nTotCnt=COUNT(ID) FROM #tempSecurityType
			WHILE @nCount<@nTotCnt
			BEGIN
				SELECT @nSecurityTypeCodeid=SecurityTypeCodeId FROM #tempSecurityType WHERE ID=@nCount+1
				INSERT INTO dbo.rul_TradingPolicyForProhibitSecurityTypes VALUES
				(@inp_iTradingPolicyId,@nSecurityTypeCodeid)
				SET @nCount=@nCount+1
			END	
			DROP TABLE #tempSecurityType	 
	END
	
	
	
	
	

	
	