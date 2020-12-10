IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_UpdateCODashboardCnt_OS')
DROP PROCEDURE [dbo].[st_tra_UpdateCODashboardCnt_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to update DashBoard Count for CO.

Returns:		0, if Success.
				
Created by:		Samadhan kadam
Created on:		07-Feb-2020

Modification History:
exec st_tra_UpdateCODashboardCnt_OS
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_UpdateCODashboardCnt_OS]
AS
			 DECLARE @nConfirm_Personal_Details_Event		INT = 153043 --Confirm Personal Details
			 DECLARE @PersonalDetailsConfirmationCount		INT = 0
			 DECLARE @PersonalDetailsReConfirmationCount	INT = 0
			 DECLARE @nInsiderInitialDisclosureCount INT = 0
			 DECLARE @nInsiderInitialDisclosureRelativeCount INT = 0
			 DECLARE @nInsiderTradeDetailsCount INT = 0	
			 DECLARE @nCOInitialDisclosureCount INT = 0	
			  DECLARE @nInsiderPeriodEndDisclosureCount INT = 0
			 DECLARE @nCOPreclearanceCount INT = 0	
			 DECLARE @nTradingPolicydueforExpiryCount INT = 0
			 DECLARE @nPolicyDocumentdueforExpiryCount INT = 0
			 DECLARE @nTradingPolicyExpiryDays INT = 30
	         DECLARE @nPolicyDocumentExpiryDays INT = 30
			 DECLARE @TRANS_TYPE_NOT_CONFIRMED_CONTINUOUS INT =148002
			 DECLARE @PRE_MAP_TO_TYPE INT =132015
			 DECLARE @PRE_APPROVED_TYPE INT =153046

			 DECLARE @CODE_USER_TYPE_ADMIN INT = 101001, -- User type - Admin 101001
				@CODE_USER_TYPE_COMPLIANCE_OFFICER INT = 101002,  -- User type - Compliance Officer 101002
				@CODE_USER_TYPE_SUPER_ADMIN INT = 101005, -- User type - Super Admin 101005
				@CODE_USER_TYPE_RELATIVE INT = 101007, -- User type - Relative 101007
				@CODE_DISCLOSURE_TYPE_INITIAL INT = 147001, -- Disclosure Type - Initial 147001
				@nUserStatusInActive INT = 102002,
				@CODE_EVENT_INITIAL_DISCLOSURE_DETAILS_ENTERED				INT = 153052, -- Event - Initial Disclosure details entered  153052
				@CODE_EVENT_INITIAL_DISCLOSURE_UPLOADED						INT = 153053, -- Event - Initial Disclosure - Uploaded  153053
				@CODE_EVENT_INITIAL_DISCLOSURE_SUBMITTED_SOFTCOPY			INT = 153054, -- Event - Initial Disclosure submitted - softcopy   153054
				@CODE_EVENT_INITIAL_DISCLOSURE_SUBMITTED_HARDCOPY			INT = 153055, -- Event - Initial Disclosure submitted - hardcopy   153055
				@CODE_EVENT_INITIAL_DISCLOSURE_CONFIRMED					INT = 153056, -- Event - Initial Disclosure - Confirmed - 153056
				@CODE_EVENT_CONTINUOUS_DISCLOSURE_DETAILS_ENTERED			INT = 153057, -- Event - Continuous Disclosure details entered 153057
				@CODE_EVENT_CONTINUOUS_DISCLOSURE_UPLOADED					INT = 153058, -- Event - Continuous Disclosure - Uploaded      153058
				@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_SOFTCOPY		INT = 153059, -- Event - Continuous Disclosure submitted - softcopy 153059
				@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_HARDCOPY		INT = 153060, -- Event - Continuous Disclosure submitted - hardcopy 153060
				@CODE_EVENT_CONTINUOUS_DISCLOSURE_CONFIRMED_CO				INT = 153061, -- Event - Continuous Disclosure - Confirmed - 153036
				@CODE_EVENT_PERIOD_END_DISCLOSURE_DETAILS_ENTERED			INT = 153062, -- Event - Period End Disclosure details entered 153062
				@CODE_EVENT_PERIOD_END_DISCLOSURE_UPLOADED					INT = 153063, -- Event - Period End Disclosure - Uploaded 153063
				@CODE_EVENT_PERIOD_END_DISCLOSURE_SUBMITTED_SOFTCOPY		INT = 153064, -- Event - Period End Disclosure submitted - softcopy 153064
				@CODE_EVENT_PERIOD_END_DISCLOSURE_SUBMITTED_HARDCOPY		INT = 153065, -- Event - Period End Disclosure submitted - hardcopy 153065
				@CODE_EVENT_PERIOD_END_DISCLOSURE_CONFIRMED					INT = 153066, -- Event - Initial Disclosure - Confirmed - 153056
				@CODE_PRECLEARENCE_PENDING									INT	= 144001,
				@CODE_PRECLEARANCE_STATUS_APPROVED							INT = 144002, --  Preclearance Status - Approved 144002
				@CODE_DISCLOSURE_TYPE_CONTINUOUS							INT = 147002, -- Disclosure Type - Continuous
				@CODE_DISCLOSURE_TYPE_PERIOD_END							INT = 147003, -- Disclosure Type - Period End
				@CODE_TRADING_POLICY_STATUS_ACTIVE							INT = 141002, -- Trading Policy Status - Active 141002
				@CODE_POLICY_DOCUMENT_WINDOW_STATUS_ACTIVE					INT = 131002 -- Policy Document Window Status - Active 131002


			Declare @eve_EventLogTemp AS Table (EventLogId bigint,	EventCodeId int,	EventDate datetime,	UserInfoId int,	MapToTypeCodeId int,	MapToId int	,CreatedBy int)

			 INSERT INTO @eve_EventLogTemp
			 SELECT * FROM eve_EventLog WITH (NOLOCK) 
			 WHERE EventCodeId in(
									@nConfirm_Personal_Details_Event,
									@CODE_EVENT_INITIAL_DISCLOSURE_DETAILS_ENTERED	,		
									@CODE_EVENT_INITIAL_DISCLOSURE_UPLOADED,				
									@CODE_EVENT_INITIAL_DISCLOSURE_SUBMITTED_SOFTCOPY,		
									@CODE_EVENT_INITIAL_DISCLOSURE_SUBMITTED_HARDCOPY,		
									@CODE_EVENT_INITIAL_DISCLOSURE_CONFIRMED,				
									@CODE_EVENT_CONTINUOUS_DISCLOSURE_DETAILS_ENTERED,		
									@CODE_EVENT_CONTINUOUS_DISCLOSURE_UPLOADED,				
									@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_SOFTCOPY,	
									@CODE_EVENT_CONTINUOUS_DISCLOSURE_SUBMITTED_HARDCOPY,	
									@CODE_EVENT_CONTINUOUS_DISCLOSURE_CONFIRMED_CO,			
									@CODE_EVENT_PERIOD_END_DISCLOSURE_DETAILS_ENTERED,		
									@CODE_EVENT_PERIOD_END_DISCLOSURE_UPLOADED,				
									@CODE_EVENT_PERIOD_END_DISCLOSURE_SUBMITTED_SOFTCOPY,	
									@CODE_EVENT_PERIOD_END_DISCLOSURE_SUBMITTED_HARDCOPY,	
									@CODE_EVENT_PERIOD_END_DISCLOSURE_CONFIRMED		,
									@PRE_APPROVED_TYPE
								 )
			 
			-- select * from @eve_EventLogTemp

			 --Personal Details ConfirmationCount
	         SELECT @PersonalDetailsConfirmationCount=count(UI.UserInfoId) from	 usr_UserInfo UI 
			 LEFT JOIN usr_Reconfirmmation RC ON UI.UserInfoId = RC.UserInfoId and   EntryFlag = 1  
			 LEFT JOIN @eve_EventLogTemp ELog ON UI.UserInfoId = ELog.UserInfoId AND ELog.EventCodeId = @nConfirm_Personal_Details_Event
			 where UI.UserTypeCodeId in(101003,101004,101006) and EventCodeId is null

			 --Personal Details ReConfirmation Count
			 SELECT  @PersonalDetailsReConfirmationCount=count(UI.UserInfoId) 
			 FROM	 usr_UserInfo UI 
			 INNER JOIN usr_Reconfirmmation RC ON UI.UserInfoId = RC.UserInfoId and   EntryFlag = 1  
			 INNER JOIN @eve_EventLogTemp ELog ON UI.UserInfoId = ELog.UserInfoId AND ELog.EventCodeId = @nConfirm_Personal_Details_Event
             WHERE   UI.UserTypeCodeId in(101003,101004,101006) and ( GETDATE() > REConfirmationDate)  


			 
			 print '@PersonalDetailsConfirmationCount'
			 print @PersonalDetailsConfirmationCount
			 print '@PersonalDetailsReConfirmationCount'
			 print @PersonalDetailsReConfirmationCount

	---------------------------- Initial Disclosure --------------------------------------------------------

		SELECT @nInsiderInitialDisclosureCount=COUNT(UF.UserInfoId) 
		FROM 
		usr_UserInfo UF 
		INNER JOIN vw_ApplicableTradingPolicyForUser_OS AS APTP on UF.UserInfoId=APTP.UserInfoId
		WHERE 
		UF.UserInfoId NOT IN(SELECT UserInfoId FROM tra_TransactionMaster_OS 
		WHERE DisclosureTypeCodeId=@CODE_DISCLOSURE_TYPE_INITIAL AND TransactionStatusCodeId!=@TRANS_TYPE_NOT_CONFIRMED_CONTINUOUS)
		AND UserTypeCodeId NOT IN (@CODE_USER_TYPE_ADMIN,@CODE_USER_TYPE_COMPLIANCE_OFFICER,@CODE_USER_TYPE_SUPER_ADMIN,@CODE_USER_TYPE_RELATIVE)
		AND StatusCodeId <> @nUserStatusInActive

		
		--SELECT @nInsiderInitialDisclosureRelativeCount=count(tb.UserInfoId)
		--FROM (
		--		SELECT UR.UserInfoId,Count(TM.UserInfoId) As TotalRelative 
		--		from tra_TransactionMaster_OS AS TM
		--		inner join usr_UserRelation AS UR on TM.UserInfoId=UR.UserInfoIdRelative
		--		WHERE DisclosureTypeCodeId=@CODE_DISCLOSURE_TYPE_INITIAL AND TransactionStatusCodeId=@TRANS_TYPE_NOT_CONFIRMED_CONTINUOUS
		--		group by  UR.UserInfoId
		-- ) tb INNER JOIN vw_ApplicableTradingPolicyForUser_OS AS APTP on tb.UserInfoId=APTP.UserInfoId

			SELECT @nInsiderInitialDisclosureRelativeCount =count(tb.UserInfoId)
		FROM (

		 select case when count(UserInfoIdRelative)>0 then 1 else 0 end as RelCount,usr_UserRelation.UserInfoId from usr_UserRelation  where UserInfoIdRelative not in (
		 select ForUserInfoId from tra_TransactionDetails_OS) 
		 group by usr_UserRelation.UserInfoId
		 union
		 select case when count(UserInfoIdRelative)>0 then 1 else 0 end as RelCount,usr_UserRelation.UserInfoId from usr_UserRelation   where UserInfoIdRelative in (
		 select ForUserInfoId from tra_TransactionDetails_OS TD join tra_TransactionMaster_OS TM on
		 TD.transactionmasterid=TM.transactionmasterid where DisclosureTypeCodeId=@CODE_DISCLOSURE_TYPE_INITIAL and TransactionStatusCodeId=@TRANS_TYPE_NOT_CONFIRMED_CONTINUOUS)	
		 group by usr_UserRelation.UserInfoId
				
		 ) tb INNER JOIN vw_ApplicableTradingPolicyForUser_OS AS APTP on tb.UserInfoId=APTP.UserInfoId

	---------------------------- End Initial Disclosure --------------------------------------------------------
	
	print '@nInsiderInitialDisclosureCount'
	print @nInsiderInitialDisclosureCount

	print '@nInsiderInitialDisclosureRelativeCount'
	print @nInsiderInitialDisclosureRelativeCount


	---------------------------- Preclearance --------------------------------------------------------
	 SELECT @nCOPreclearanceCount = Count(p.PreclearanceRequestId) FROM
	  tra_PreclearanceRequest_NonImplementationCompany p 
	  inner join tra_TransactionMaster_OS tm on p.PreclearanceRequestId=tm.PreclearanceRequestId
	  WHERE PreclearanceStatusCodeId = @CODE_PRECLEARENCE_PENDING
	
	
	---------------------------- End Preclearance --------------------------------------------------------
	
	print '@nCOPreclearanceCount'
	print @nCOPreclearanceCount

	---------------------------- Trading Policy due for Expiry   --------------------------------------------------------	

		SELECT @nTradingPolicydueforExpiryCount = COUNT(TradingPolicyId) 
		FROM [rul_TradingPolicy]
		WHERE ApplicableToDate <  DateAdd(day,@nTradingPolicyExpiryDays,dbo.uf_com_GetServerDate()) AND ApplicableToDate >= dbo.uf_com_GetServerDate()
			AND TradingPolicyStatusCodeId = @CODE_TRADING_POLICY_STATUS_ACTIVE -- Active
	---------------------------- END Trading Policy due for Expiry   --------------------------------------------------------	 
	---------------------------- Policy Document due for Expiry  --------------------------------------------------------	 
		SELECT @nPolicyDocumentdueforExpiryCount = COUNT(PolicyDocumentId) 
		FROM rul_PolicyDocument
		WHERE ApplicableTo <  DateAdd(day,@nPolicyDocumentExpiryDays,dbo.uf_com_GetServerDate()) AND ApplicableTo >= dbo.uf_com_GetServerDate()
			AND WindowStatusCodeId = @CODE_POLICY_DOCUMENT_WINDOW_STATUS_ACTIVE-- Active
	---------------------------- END Policy Document due for Expiry  --------------------------------------------------------	
		---------------------------- Trade Details --------------------------------------------------------	
	


		
	DECLARE  @tmpTransaction as TABLE(ID int identity(1,1),TransId int) 
-- PNT Transaction not confirmed
			insert into @tmpTransaction (TransId)
			SELECT 
					TM.TransactionMasterId FROM tra_TransactionMaster_OS AS  TM			
					WHERE TransactionStatusCodeId<>148003 
					AND DisclosureTypeCodeId=147002 AND PreclearanceRequestId IS NULL	
			
			insert into @tmpTransaction (TransId)
			SELECT 
				TM.TransactionMasterId
				FROM  tra_TransactionMaster_OS AS TM
				JOIN tra_PreclearanceRequest_NonImplementationCompany AS PR ON PR.PreclearanceRequestId=TM.PreclearanceRequestId 
				JOIN eve_EventLog AS evLog ON evLog.MapToId=PR.PreclearanceRequestId
			WHERE
			TransactionStatusCodeId<>148003 AND DisclosureTypeCodeId=147002  
			AND MapToTypeCodeId = 132015 AND EventCodeId IN (153046) AND PreclearanceStatusCodeId=144002
		    AND IsPartiallyTraded !=2
			
			insert into @tmpTransaction (TransId) 
			SELECT 
				PR.PreclearanceRequestId
				FROM tra_PreclearanceRequest_NonImplementationCompany PR 	
				JOIN tra_TransactionMaster_OS TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId AND ParentTransactionMasterId IS NULL
				JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId
			WHERE 
			IsPartiallyTraded = 1  AND PreclearanceStatusCodeId = 144002 AND ShowAddButton = 1
	
	SELECT @nInsiderTradeDetailsCount=count(ID) from @tmpTransaction

	--exec st_tra_UpdateCODashboardCnt_OS
-------------------------------- END Trade Details --------------------------------------------------------		
print '@nInsiderTradeDetailsCount'
print @nInsiderTradeDetailsCount

--------------------------------Period END Details --------------------------------------------------------		

SELECT @nInsiderPeriodEndDisclosureCount= count(UserInfoId) FROM 
(
SELECT UserInfoId,TransactionStatusCodeId, count(TransactionMasterId) AS PendingPeriodEnd
FROM tra_TransactionMaster_OS  WHERE 
DisclosureTypeCodeId=147003 and TransactionStatusCodeId=148002 
GROUP BY UserInfoId,TransactionStatusCodeId
)tb1

--------------------------------Period END Details --------------------------------------------------------		

print '@nInsiderPeriodEndDisclosureCount'
print @nInsiderPeriodEndDisclosureCount



	


	--select * from tra_CoDashboardCount

--SELECT * FROM tra_TransactionMaster_OS WHERE DisclosureTypeCodeId=147001


  --select * from tra_CoDashboardCount


  --------------------------  Update Count in tra_CoDashboardCount table   --------------------------------------------------------			

		UPDATE tra_CoDashboardCount
		SET [Count] = @PersonalDetailsConfirmationCount	,[Status] = 0
		WHERE DashboardCountId = 26	AND [Count] != @PersonalDetailsConfirmationCount

		UPDATE tra_CoDashboardCount
		SET [Count] = @PersonalDetailsReConfirmationCount	,[Status] = 0
		WHERE DashboardCountId = 27	AND [Count] != @PersonalDetailsReConfirmationCount

		UPDATE tra_CoDashboardCount
		SET [Count] = @nInsiderInitialDisclosureCount	,[Status] = 0
		WHERE DashboardCountId = 28	AND [Count] != @nInsiderInitialDisclosureCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nInsiderInitialDisclosureRelativeCount	,[Status] = 0
		WHERE DashboardCountId = 29	AND [Count] != @nInsiderInitialDisclosureRelativeCount

		UPDATE tra_CoDashboardCount
		SET [Count] = @nInsiderTradeDetailsCount	,[Status] = 0
		WHERE DashboardCountId = 30	AND [Count] != @nInsiderTradeDetailsCount
	  
		UPDATE tra_CoDashboardCount
		SET [Count] = @nInsiderPeriodEndDisclosureCount	,[Status] = 0
		WHERE DashboardCountId = 31	AND [Count] != @nInsiderPeriodEndDisclosureCount

		UPDATE tra_CoDashboardCount
		SET [Count] = @nCOPreclearanceCount	,[Status] = 0
		WHERE DashboardCountId = 32	AND [Count] != @nCOPreclearanceCount

		UPDATE tra_CoDashboardCount
		SET [Count] = @nTradingPolicydueforExpiryCount	,[Status] = 0
		WHERE DashboardCountId = 33	AND [Count] != @nTradingPolicydueforExpiryCount
		
		UPDATE tra_CoDashboardCount
		SET [Count] = @nPolicyDocumentdueforExpiryCount	,[Status] = 0
		WHERE DashboardCountId = 34	AND [Count] != @nPolicyDocumentdueforExpiryCount	
	 


			
  GO