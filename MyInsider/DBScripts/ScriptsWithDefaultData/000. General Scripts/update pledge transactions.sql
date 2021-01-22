	create table #tmpTradingPolicyID
		(
			ID int identity(1,1),
			TradingPolicyID INT
		)
		insert into #tmpTradingPolicyID
		select TradingPolicyId from rul_TradingPolicy_OS
		
		
		declare @nCount int=0
		declare @nTotCount int=0

		select @nTotCount=COUNT(ID) from #tmpTradingPolicyID
		while @nCount<@nTotCount
		begin
		DECLARE @nTradingPolicyID INT=0
		SELECT @nTradingPolicyID=TradingPolicyID FROM #tmpTradingPolicyID WHERE ID=@nCount+1
		PRINT(@nTradingPolicyID)
			if not exists(select * from rul_TradingPolicyForTransactionSecurity_OS where MapToTypeCodeId=132015 and TransactionModeCodeId=143006 and SecurityTypeCodeId=139001 and TradingPolicyId=@nTradingPolicyID)
			begin
				INSERT INTO rul_TradingPolicyForTransactionSecurity_OS
				VALUES (@nTradingPolicyID,132015,143006,139001)
			end
			if not exists(select * from rul_TradingPolicyForTransactionSecurity_OS where MapToTypeCodeId=132015 and TransactionModeCodeId=143007 and SecurityTypeCodeId=139001 and TradingPolicyId=@nTradingPolicyID)
			begin
				INSERT INTO rul_TradingPolicyForTransactionSecurity_OS
				VALUES (@nTradingPolicyID,132015,143007,139001)
			end
			if not exists(select * from rul_TradingPolicyForTransactionSecurity_OS where MapToTypeCodeId=132015 and TransactionModeCodeId=143008 and SecurityTypeCodeId=139001 and TradingPolicyId=@nTradingPolicyID)
			begin
				INSERT INTO rul_TradingPolicyForTransactionSecurity_OS
				VALUES (@nTradingPolicyID,132015,143008,139001)
			end

			set @nCount=@nCount+1
		end
		drop table #tmpTradingPolicyID
		
		
		

		