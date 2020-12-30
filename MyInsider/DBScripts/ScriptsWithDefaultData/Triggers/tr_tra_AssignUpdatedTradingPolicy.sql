IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_tra_AssignUpdatedTradingPolicy]'))
DROP TRIGGER [dbo].[tr_tra_AssignUpdatedTradingPolicy]
GO

/*
Modified By	Modified On	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/

CREATE TRIGGER [dbo].[tr_tra_AssignUpdatedTradingPolicy] ON [dbo].[rul_TradingPolicy]
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
SELECT TransactionMasterId,UserInfoId,TradingPolicyId FROM tra_TransactionMaster
WHERE DisclosureTypeCodeId=147001 and TransactionStatusCodeId=148002
union
select 0,UserInfoId,0 from usr_UserInfo where UserTypeCodeId not in(101001,101002) and
UserInfoId not in(
SELECT UserInfoId FROM tra_TransactionMaster 
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
			
			SELECT @NewTradingPolicyId=MAX(MapToId)  FROM vw_ApplicableTradingPolicyForUser WHERE UserInfoId=@inp_iUserInfoId
			
			SELECT @TradingPolicyApplicableFromDate=ApplicableFromDate FROM rul_TradingPolicy WHERE TradingPolicyId=@NewTradingPolicyId
			IF(@OldTradingPolicyId !=@NewTradingPolicyId and @TradingPolicyApplicableFromDate <= @dtCurrentDate)
			BEGIN
			 UPDATE tra_TransactionMaster SET TradingPolicyId=@NewTradingPolicyId WHERE  UserInfoId=@inp_iUserInfoId and TransactionMasterId=@nTransactionMasterId
			 
					if exists(select DefaulterReportID from rpt_DefaulterReport where UserInfoID=@inp_iUserInfoId)
					begin
						delete from rpt_DefaulterReportComments
						where DefaulterReportID in(select DefaulterReportID  from rpt_DefaulterReport where UserInfoID=@inp_iUserInfoId)

						delete  from rpt_DefaulterReport where UserInfoID=@inp_iUserInfoId
					end
			END
			else if(@nTransactionMasterId=0 and @OldTradingPolicyId=0)
			begin
			
					if exists(select DefaulterReportID from rpt_DefaulterReport where UserInfoID=@inp_iUserInfoId)
					begin
						delete from rpt_DefaulterReportComments
						where DefaulterReportID in(select DefaulterReportID  from rpt_DefaulterReport where UserInfoID=@inp_iUserInfoId)

						delete  from rpt_DefaulterReport where UserInfoID=@inp_iUserInfoId
					end
			end

			SET @nCount=@nCount+1

END

DROP TABLE #tmpUpdatePolicyId

END