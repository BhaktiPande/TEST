/*-- ======================================================================================================
	Author      : Priyanka Bhangale
	CREATED DATE: 24-Sept-2019
	Description : Script to insert period end date in tra_transactionMaster table for own and other securities.
-- ======================================================================================================*/

-- Other Security
IF EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster_OS WHERE PeriodEndDate IS NULL)
BEGIN
	DECLARE @nActinFlag		 		INT
	DECLARE @nApplicableTP 			INT
	DECLARE @nYearCodeId	 		INT
	DECLARE @nPeriodCodeId  		INT
	DECLARE @dtPEStartDate 			DATETIME
	DECLARE @dtPEEndDate 			DATETIME
	DECLARE @bChangePEDate			BIT
	DECLARE @dtPEEndDateToUpdate	DATETIME
	DECLARE @out_nReturnValue		INT = 0 
	DECLARE @out_nSQLErrCode		INT = 0 				-- Output SQL Error Number, if error occurred.
	DECLARE @out_sSQLErrMessage		VARCHAR(500) = '' 
	DECLARE @nCount                 INT
	DECLARE @nCounter               INT  = 1
	DECLARE @nUserInfoID            INT
	DECLARE @nTransactionMasterId   INT
	DECLARE @nTradingPolicyId       INT
	DECLARE @RC                     INT
	DECLARE @TempTransactionMaster AS TABLE (ID INT IDENTITY(1,1), TransactionMasterId INT, UserInfoID INT, TradingPolicyId INT, CreatedOn DATETIME)
	DECLARE @dtCurrentDate DATETIME --= dbo.uf_com_GetServerDate()

	INSERT INTO @TempTransactionMaster
	SELECT TransactionMasterId, UserInfoId, TradingPolicyId, CreatedOn FROM tra_TransactionMaster_OS WHERE PeriodEndDate IS NULL
	SELECT @nCount = COUNT(ID) FROM @TempTransactionMaster
	print @nCount
	select * from @TempTransactionMaster
	WHILE(@nCounter <= @nCount)
	BEGIN
	print 'start'
		SELECT @nUserInfoID = UserInfoID, @nTransactionMasterId = TransactionMasterId,@nTradingPolicyId = TradingPolicyId, @dtCurrentDate = CreatedOn FROM @TempTransactionMaster WHERE ID = @nCounter
		
		EXECUTE @RC = [st_tra_PeriodEndDisclosureGetApplicablePeriodDetail_OS]
										@nUserInfoID,  
										@nTradingPolicyId,
										@dtCurrentDate,
										@nActinFlag OUTPUT,
										@nApplicableTP OUTPUT, 
										@nYearCodeId OUTPUT, 
										@nPeriodCodeId OUTPUT, 
										@dtPEStartDate OUTPUT, 
										@dtPEEndDate OUTPUT, 
										@bChangePEDate OUTPUT, 
										@dtPEEndDateToUpdate OUTPUT, 									
										@out_nReturnValue OUTPUT,
										@out_nSQLErrCode OUTPUT,
										@out_sSQLErrMessage OUTPUT
		PRINT '@nTransactionMasterId' PRINT @nTransactionMasterId		
		PRINT '@nUserInfoID' PRINT @nUserInfoID PRINT '@nApplicableTP' PRINT @nApplicableTP PRINT '@nYearCodeId' PRINT @nYearCodeId 
		PRINT '@nPeriodCodeId' PRINT @nPeriodCodeId PRINT '@dtPEEndDate' PRINT @dtPEEndDate	PRINT '@nActinFlag' PRINT @nActinFlag	
		
		IF(@nPeriodCodeId IS NOT NULL AND @dtPEEndDate IS NOT NULL)
		BEGIN		
			-- check flag to update record 
			IF(@nActinFlag = 1 OR @nActinFlag = 3)
			BEGIN	PRINT 'insert'
				INSERT INTO tra_UserPeriodEndMapping_OS 
					(UserInfoId, TradingPolicyId, YearCodeId, PeriodCodeId, PEStartDate, PEEndDate, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
				VALUES
					(@nUserInfoID, @nApplicableTP, @nYearCodeId, @nPeriodCodeId, @dtPEStartDate, @dtPEEndDate, @nUserInfoID, dbo.uf_com_GetServerDate(), @nUserInfoID, dbo.uf_com_GetServerDate())
											
				UPDATE tra_TransactionMaster_OS SET PeriodEndDate = @dtPEEndDate WHERE UserInfoId = @nUserInfoID AND TransactionMasterId = @nTransactionMasterId					
			END
			ELSE IF(@nActinFlag = 2 OR @bChangePEDate = 1)
			BEGIN
				print 'update'
				UPDATE tra_TransactionMaster_OS SET PeriodEndDate = @dtPEEndDate WHERE UserInfoId = @nUserInfoID AND TransactionMasterId = @nTransactionMasterId
			END
		END
		SET @nCounter = @nCounter + 1
		print 'end'
	END
END

--Own Security
IF EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster WHERE PeriodEndDate IS NULL)
BEGIN
	DECLARE @nActinFlag1		 		INT
	DECLARE @nApplicableTP1 			INT
	DECLARE @nYearCodeId1	 		INT
	DECLARE @nPeriodCodeId1  		INT
	DECLARE @dtPEStartDate1 			DATETIME
	DECLARE @dtPEEndDate1 			DATETIME
	DECLARE @bChangePEDate1			BIT
	DECLARE @dtPEEndDateToUpdate1	DATETIME
	DECLARE @out_nReturnValue1		INT = 0 
	DECLARE @out_nSQLErrCode1		INT = 0 				-- Output SQL Error Number, if error occurred.
	DECLARE @out_sSQLErrMessage1		VARCHAR(500) = '' 
	DECLARE @nCount1                INT
	DECLARE @nCounter1               INT  = 1
	DECLARE @nUserInfoID1            INT
	DECLARE @nTransactionMasterId1   INT
	DECLARE @nTradingPolicyId1       INT
	DECLARE @RC1                     INT
	DECLARE @TempTransactionMaster1 AS TABLE (ID INT IDENTITY(1,1), TransactionMasterId INT, UserInfoID INT, TradingPolicyId INT, CreatedOn DATETIME)
	DECLARE @dtCurrentDate1 DATETIME --= dbo.uf_com_GetServerDate()

	INSERT INTO @TempTransactionMaster1
	SELECT TransactionMasterId, UserInfoId, TradingPolicyId, CreatedOn FROM tra_TransactionMaster WHERE PeriodEndDate IS NULL
	SELECT @nCount1 = COUNT(ID) FROM @TempTransactionMaster1
	print @nCount1
	select * from @TempTransactionMaster1
	WHILE(@nCounter1 <= @nCount1)
	BEGIN
	print 'start'
		SELECT @nUserInfoID1 = UserInfoID, @nTransactionMasterId1 = TransactionMasterId,@nTradingPolicyId1 = TradingPolicyId, @dtCurrentDate1 = CreatedOn FROM @TempTransactionMaster1 WHERE ID = @nCounter1
		
		EXECUTE @RC1 = [st_tra_PeriodEndDisclosureGetApplicablePeriodDetail]
										@nUserInfoID1,  
										@nTradingPolicyId1,
										@dtCurrentDate1,
										@nActinFlag1 OUTPUT,
										@nApplicableTP1 OUTPUT, 
										@nYearCodeId1 OUTPUT, 
										@nPeriodCodeId1 OUTPUT, 
										@dtPEStartDate1 OUTPUT, 
										@dtPEEndDate1 OUTPUT, 
										@bChangePEDate1 OUTPUT, 
										@dtPEEndDateToUpdate1 OUTPUT, 									
										@out_nReturnValue1 OUTPUT,
										@out_nSQLErrCode1 OUTPUT,
										@out_sSQLErrMessage1 OUTPUT
		PRINT '@nTransactionMasterId' PRINT @nTransactionMasterId1		
		PRINT '@nUserInfoID' PRINT @nUserInfoID1 PRINT '@nApplicableTP' PRINT @nApplicableTP1 PRINT '@nYearCodeId' PRINT @nYearCodeId1 
		PRINT '@nPeriodCodeId' PRINT @nPeriodCodeId1 PRINT '@dtPEEndDate' PRINT @dtPEEndDate1	PRINT '@nActinFlag' PRINT @nActinFlag1	
		
		IF(@nPeriodCodeId1 IS NOT NULL AND @dtPEEndDate1 IS NOT NULL)
		BEGIN		
			-- check flag to update record 
			IF(@nActinFlag1 = 1 OR @nActinFlag1 = 3)
			BEGIN	PRINT 'insert'
				INSERT INTO tra_UserPeriodEndMapping 
					(UserInfoId, TradingPolicyId, YearCodeId, PeriodCodeId, PEStartDate, PEEndDate, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
				VALUES
					(@nUserInfoID1, @nApplicableTP1, @nYearCodeId1, @nPeriodCodeId1, @dtPEStartDate1, @dtPEEndDate1, @nUserInfoID1, dbo.uf_com_GetServerDate(), @nUserInfoID1, dbo.uf_com_GetServerDate())
											
				UPDATE tra_TransactionMaster SET PeriodEndDate = @dtPEEndDate1 WHERE UserInfoId = @nUserInfoID1 AND TransactionMasterId = @nTransactionMasterId1					
			END
			ELSE IF(@nActinFlag1 = 2 OR @bChangePEDate1 = 1)
			BEGIN
				print 'update'
				UPDATE tra_TransactionMaster SET PeriodEndDate = @dtPEEndDate1 WHERE UserInfoId = @nUserInfoID1 AND TransactionMasterId = @nTransactionMasterId1
			END
		END
		SET @nCounter1 = @nCounter1 + 1
		print 'end'
	END
END