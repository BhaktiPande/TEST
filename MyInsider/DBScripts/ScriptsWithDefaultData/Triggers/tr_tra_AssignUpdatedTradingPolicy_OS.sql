IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_tra_AssignUpdatedTradingPolicy_OS]'))
DROP TRIGGER [dbo].[tr_tra_AssignUpdatedTradingPolicy_OS]
GO

/*
Modified By	Modified On	Description

*/

CREATE TRIGGER [dbo].[tr_tra_AssignUpdatedTradingPolicy_OS] ON [dbo].[rul_TradingPolicy_OS]
AFTER UPDATE,INSERT
AS
BEGIN


DECLARE @nCount int=1
DECLARE @nTotCount int=0
DECLARE @dtCurrentDate DATETIME = dbo.uf_com_GetServerDate()
CREATE TABLE #tmpUpdatePolicyId
(
ID INT IDENTITY(1,1),
TransactionMasterID INT,
UserInfoID INT,
OldTradingPolicyID INT
) 
INSERT INTO #tmpUpdatePolicyId (TransactionMasterID,UserInfoID,OldTradingPolicyID)
SELECT TransactionMasterId,UserInfoId,TradingPolicyId FROM tra_TransactionMaster_OS
WHERE DisclosureTypeCodeId=147001 and TransactionStatusCodeId=148002
union
select 0,UserInfoId,0 from usr_UserInfo where UserTypeCodeId not in(101001,101002) and
UserInfoId not in(
SELECT UserInfoId FROM tra_TransactionMaster_OS 
WHERE DisclosureTypeCodeId=147001 ) 

SELECT @nTotCount=Count(ID) FROM #tmpUpdatePolicyId
WHILE @nCount<=@nTotCount
BEGIN

		DECLARE @OldTradingPolicyId INT
		DECLARE @NewTradingPolicyId INT
		DECLARE @TradingPolicyApplicableFromDate DATETIME
		DECLARE @inp_iUserInfoId INT
		DECLARE @nTransactionMasterId INT
		SELECT @inp_iUserInfoId=UserInfoID,@OldTradingPolicyId=OldTradingPolicyID,@nTransactionMasterId=TransactionMasterID FROM #tmpUpdatePolicyId WHERE ID=@nCount
			
			SELECT @NewTradingPolicyId=MAX(MapToId)  FROM vw_ApplicableTradingPolicyForUser_OS WHERE UserInfoId=@inp_iUserInfoId
			
			SELECT @TradingPolicyApplicableFromDate=ApplicableFromDate FROM rul_TradingPolicy_OS WHERE TradingPolicyId=@NewTradingPolicyId
			IF(@OldTradingPolicyId !=@NewTradingPolicyId and @TradingPolicyApplicableFromDate <= @dtCurrentDate)
			BEGIN
			 UPDATE tra_TransactionMaster_OS SET TradingPolicyId=@NewTradingPolicyId WHERE  UserInfoId=@inp_iUserInfoId and TransactionMasterId=@nTransactionMasterId
			 
					if exists(select DefaulterReportID from rpt_DefaulterReport_OS where UserInfoID=@inp_iUserInfoId)
					begin
						delete from rpt_DefaulterReportComments_OS
						where DefaulterReportID in(select DefaulterReportID  from rpt_DefaulterReport_OS where UserInfoID=@inp_iUserInfoId)

						delete  from rpt_DefaulterReport_OS where UserInfoID=@inp_iUserInfoId
					end
			END
			else if(@nTransactionMasterId=0 and @OldTradingPolicyId=0)
			begin
			
					if exists(select DefaulterReportID from rpt_DefaulterReport_OS where UserInfoID=@inp_iUserInfoId)
					begin
						delete from rpt_DefaulterReportComments_OS
						where DefaulterReportID in(select DefaulterReportID  from rpt_DefaulterReport_OS where UserInfoID=@inp_iUserInfoId)

						delete  from rpt_DefaulterReport_OS where UserInfoID=@inp_iUserInfoId
					end
			end

			SET @nCount=@nCount+1

END

DROP TABLE #tmpUpdatePolicyId

END