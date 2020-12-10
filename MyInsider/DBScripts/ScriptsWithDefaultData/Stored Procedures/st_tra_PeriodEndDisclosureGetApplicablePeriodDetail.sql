IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosureGetApplicablePeriodDetail')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosureGetApplicablePeriodDetail]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************************************************
Description:	Procedure to get applicable period end desclosure period details for user 

Returns:		Return 0, if success.
				
Created by:		Parag
Created on:		19-Nov-2015

Modification History:
Modified By		Modified On		Description
Parag			08-Dec-2015		Made chagne to fix last date issue in case of leap year for Feb


******************************************************************************************************************

Usage:

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosureGetApplicablePeriodDetail]
	@inp_iUserInfoId 		INT,
	@inp_nTradingPolicyId	INT,
	@inp_dtCurDate			DATETIME,
	
	@out_nActinFlag		 	INT = 0 OUTPUT,
	@out_nTradingPolicy 	INT = NULL OUTPUT,
	@out_nYearCodeId	 	INT = NULL OUTPUT,
	@out_nPeriodCodeId  	INT = NULL OUTPUT,
	@out_dtPEStartDate 		DATETIME = NULL OUTPUT,
	@out_dtPEEndDate 		DATETIME = NULL OUTPUT,
	@out_bChangePEDate		BIT = 0 OUTPUT,
	@out_dtPEEndDateToUpdate DATETIME OUTPUT,
	
	@out_nReturnValue 		INT = 0 OUTPUT,
	@out_nSQLErrCode 		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_PERIODENDDISCLOSURE_GETDETAIL	INT = -1  -- Error occurred while fetching list of period end disclosure period status.
	
	DECLARE @RC INT
	
	-- flag to indicate what action to be taken
	-- 0: NO ACTION
	-- 1: add records as per current TP for current period, 
	-- 2: record is already added into tra_UserPeriodEndMapping table
	-- 3: add next period records as per previous TP stored in tra_UserPeriodEndMapping table
	DECLARE @bFlagAddPEMappingRecord INT = 0 
	
	DECLARE @nPeriodType	INT = NULL
	DECLARE @nCurrnetYear	INT
	
	DECLARE @nYearCodeId	INT
	DECLARE @nPeriodCodeId	INT = NULL
	DECLARE @dtPEStartDate	DATETIME = NULL
	DECLARE @dtPEEndDate	DATETIME = NULL
	
	DECLARE @nPeriodTypeOld			INT = NULL
	DECLARE @nTradingPolicyIdOld	INT 
	DECLARE @nYearCodeIdOld			INT 
	DECLARE @nPeriodCodeIdOld		INT = NULL
	DECLARE @dtPEStartDateOld		DATETIME
	DECLARE @dtPEEndDateOld			DATETIME = NULL 
	
	DECLARE @nPeriodType_Yearly		INT = 123001
	DECLARE @nPeriodType_HalfYearly INT = 123002
	DECLARE @nPeriodType_Quarterly	INT = 123003
	DECLARE @nPeriodType_Monthly	INT = 123004
	
	DECLARE @nDisclosureType_PeriodEnd INT = 147003
	
	DECLARE @nDisclosureStatus_NotConfirm INT = 148002
	DECLARE @nDisclosureStatus_DocUpload INT = 148001
	
	DECLARE @nCurrPeriodCodeIdOld	INT 
	DECLARE @dtCurrPEEndDateOld		DATETIME

	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		-- This will return flag to indicate if update tra_userperiodendmapping table with new TP or old TP
		-- TP id, year code, period code, start and end date, 
		
		-- get PE dates as per current TP  
		SELECT @nPeriodType = CASE 
							WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
							WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
							WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
							WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
							ELSE TP.DiscloPeriodEndFreq 
						 END 
		FROM rul_TradingPolicy TP WHERE TP.TradingPolicyId = @inp_nTradingPolicyId
		
		SELECT @nCurrnetYear = YEAR(@inp_dtCurDate)
		
		IF MONTH(@inp_dtCurDate) < 4
		BEGIN
			SET @nCurrnetYear = @nCurrnetYear - 1
		END
		
		SELECT @nYearCodeId = CodeID FROM com_Code WHERE CodeGroupId = 125 AND CodeName LIKE CONVERT(VARCHAR(4), @nCurrnetYear) + '%'
		
		-- check if period type is null or not 
		IF (@nPeriodType IS NOT NULL OR @nPeriodType <> '')
		BEGIN
			SELECT TOP(1) @nPeriodCodeId = CodeID FROM com_Code 
			WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType 
			AND CONVERT(date, @inp_dtCurDate) <= DATEADD(DAY, -1, DATEADD(YEAR, @nCurrnetYear - 1970, CONVERT(DATETIME, Description)))
			ORDER BY CONVERT(DATETIME, Description) ASC
		
			-- get PE start end date 
			--print 'get PE start end date'
			EXECUTE @RC = [st_tra_PeriodEndDisclosureStartEndDate2] 
							   @nYearCodeId OUTPUT
							  ,@nPeriodCodeId OUTPUT
							  ,@inp_dtCurDate
							  ,@nPeriodType
							  ,0
							  ,@dtPEStartDate OUTPUT
							  ,@dtPEEndDate OUTPUT
							  ,@out_nReturnValue OUTPUT
							  ,@out_nSQLErrCode OUTPUT
							  ,@out_sSQLErrMessage OUTPUT
		END
		
		--print  'As per currnt TP for PE - UserInfoId '+convert(varchar, @inp_iUserInfoId) + '  TradingPolicy '+convert(varchar, @inp_nTradingPolicyId) 
		--		+ '   YearCodeId '+convert(varchar, @nYearCodeId) + '   PeriodCodeId '+convert(varchar, ISNULL(@nPeriodCodeId,0))
		--		+ '   PeriodType '+convert(varchar, ISNULL(@nPeriodType,0))
		--		+ '   PEStartDate '+case when @dtPEStartDate is null then 'NULL ' else convert(varchar, @dtPEStartDate) end 
		--		+ '   PEEndDate '+case when @dtPEEndDate is null then 'NULL ' else convert(varchar, @dtPEEndDate) end
		
		-- check if records exists for user 
		IF(NOT EXISTS(SELECT UserPeriodEndMappingId FROM tra_UserPeriodEndMapping WHERE UserInfoId = @inp_iUserInfoId))
		BEGIN
			SET @bFlagAddPEMappingRecord = 1 -- add records as per current TP for current period
		END
		ELSE -- Found entry in tra_UserPeriodEndMapping table for user so check earlier period and current period
		BEGIN
			-- get PE dates as per TP in tra_UserPeriodEndMapping table
			SELECT TOP(1) 
				@nYearCodeIdOld = YearCodeId, 
				@nPeriodCodeIdOld =PeriodCodeId, 
				@dtPEStartDateOld = PEStartDate, 
				@dtPEEndDateOld = PEEndDate,
				@nTradingPolicyIdOld = TradingPolicyId
			FROM tra_UserPeriodEndMapping UPEM 
			WHERE UPEM.UserInfoId = @inp_iUserInfoId 
			ORDER BY UserPeriodEndMappingId DESC
			
			-- get period type to compare with current TP
			SELECT @nPeriodTypeOld = CASE 
								WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
								WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
								WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
								WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
								ELSE TP.DiscloPeriodEndFreq 
							 END 
			FROM rul_TradingPolicy TP WHERE TP.TradingPolicyId = @nTradingPolicyIdOld
			
			
			--print  'As per pervious TP for PE - UserInfoId '+convert(varchar, @inp_iUserInfoId) 
			--	+ '  TradingPolicy '+convert(varchar, @nTradingPolicyIdOld) 
			--	+ '  YearCodeId '+convert(varchar, @nYearCodeIdOld) + '  PeriodCodeId '+convert(varchar, ISNULL(@nPeriodCodeIdOld,0)) 
			--	+ '  PeriodType '+convert(varchar, ISNULL(@nPeriodTypeOld,0))
			--	+ '  PEStartDate '+case when @dtPEStartDateOld is null then 'NULL ' else convert(varchar, @dtPEStartDateOld) end
			--	+ '  PEEndDate '+case when @dtPEEndDateOld is null then 'NULL ' else convert(varchar, @dtPEEndDateOld) end
			
			--print 'compare new '+ '   YearCodeId '+convert(varchar, ISNULL(@nYearCodeId,0)) 
			--		+ '   PeriodType '+convert(varchar, ISNULL(@nPeriodType,0))+ '  PeriodCodeId '+convert(varchar, ISNULL(@nPeriodCodeId,0)) 
					
			--print 'compare old '+ '   YearCodeId '+convert(varchar, @nYearCodeIdOld) 
			--		+ '   PeriodType '+convert(varchar, ISNULL(@nPeriodTypeOld,0))+ '  PeriodCodeId '+convert(varchar, ISNULL(@nPeriodCodeIdOld,0)) 
			
			-- Year change
			IF (@nYearCodeIdOld <> @nYearCodeId) -- add new record if year change
			BEGIN
				--print 'condition 1 - year change'
				
				SET @bFlagAddPEMappingRecord = 1 -- add records as per current TP for current period
			END
			-- record found for current period 
			ELSE IF (@nYearCodeId = @nYearCodeIdOld 
						AND ISNULL(@nPeriodType,0) = ISNULL(@nPeriodTypeOld,0) 
						AND ISNULL(@nPeriodCodeId,0) = ISNULL(@nPeriodCodeIdOld,0))
			BEGIN
				--print 'condition 2 - records exists for same period'
				
				SET @bFlagAddPEMappingRecord = 2 -- PE records is already added 
				--Record found for the current period but trading policy is different
				IF(@nTradingPolicyIdOld<>@inp_nTradingPolicyId)
				BEGIN
					--print 'condition 2.1- Record found for the current period but trading policy is different'
					SET @bFlagAddPEMappingRecord=1 -- add records as per current TP for current period
				END
			END
			-- TP does not change however period change 
			ELSE IF (@nYearCodeId = @nYearCodeIdOld 
						AND ISNULL(@nPeriodType,0) = ISNULL(@nPeriodTypeOld,0) 
						AND ISNULL(@nPeriodCodeId,0) <> ISNULL(@nPeriodCodeIdOld,0))
			BEGIN
				--print 'condition 3 - period change - same period type'
				
				SET @bFlagAddPEMappingRecord = 1 -- add records as per current TP for change period
			END
			-- PE period type change 
			ELSE IF (@nYearCodeId = @nYearCodeIdOld AND ISNULL(@nPeriodType,0) <> ISNULL(@nPeriodTypeOld,0))
			BEGIN
				-- TP change from PE to NO PE 
				IF (@nPeriodTypeOld IS NOT NULL AND @nPeriodType IS NULL)
				BEGIN
					--print 'condition 4 - previouslly period end and now not applicable'
					
					SET @bFlagAddPEMappingRecord = 2 -- return alredy set period deails 
					
					-- check if as per old TP period is over then only add records as per new TP for NO PE
					-- current date between PE date then do not apply new TP else apply new TP 
					IF NOT EXISTS(SELECT * FROM tra_TransactionMaster TM 
								WHERE TM.DisclosureTypeCodeId = @nDisclosureType_PeriodEnd 
								AND TM.UserInfoId = @inp_iUserInfoId
								AND TM.PeriodEndDate >= @dtPEStartDateOld 
								AND TM.PeriodEndDate <= @dtPEEndDateOld)
					BEGIN
						--print 'condition 4.1 - previouslly period end and set not applicable period end'
						
						SET @nPeriodCodeId = NULL
						SET @dtPEStartDate = @dtPEStartDateOld
						SET @dtPEEndDate = NULL
						
						SET @out_bChangePEDate = 1 -- set flag to update records in transactiom master period end date
						SET @out_dtPEEndDateToUpdate = @dtPEEndDateOld
						
						SET @bFlagAddPEMappingRecord = 1 -- add records as per current TP for change period
					END
					ELSE IF (@dtPEEndDateOld < @inp_dtCurDate)
					BEGIN
						--print 'condition 4.2 - previouslly period end and set not applicable period end - earlier period is over'
						
						SET @nPeriodCodeId = NULL
						SET @dtPEStartDate = CONVERT(date, DATEADD(DAY, 1, @dtPEEndDateOld))
						SET @dtPEEndDate = NULL
						
						SET @bFlagAddPEMappingRecord = 1 -- add records as per current TP for change period
					END
				END
				-- TP chagne from NO PE to PE
				ELSE IF (@nPeriodTypeOld IS NULL AND @nPeriodType IS NOT NULL)
				BEGIN
					--print 'condition 5 - currenly period end not applicable and now period end applicable'
					
					SET @bFlagAddPEMappingRecord = 2 -- return alredy set period deails 
					
					IF(@nPeriodCodeIdOld IS NULL AND @dtPEStartDateOld IS NULL AND @dtPEEndDateOld IS NULL)
					BEGIN
						SET @bFlagAddPEMappingRecord = 1
					END
					-- check if as per new TP period, is there any transaction made between that period
					-- if there are no transaction is made from start of period then add new period for PE  
					-- if transaction is exists then continue with same TP until period is over
					IF (0 >= (SELECT COUNT(TM.TransactionMasterId) FROM tra_TransactionDetails TD 
									JOIN tra_TransactionMaster TM ON TD.TransactionMasterId = TM.TransactionMasterId
									AND TM.TransactionStatusCodeId NOT IN (@nDisclosureStatus_DocUpload, @nDisclosureStatus_NotConfirm)
									AND TM.UserInfoId = @inp_iUserInfoId
									AND CONVERT(date, TD.DateOfAcquisition) >= CONVERT(date, @dtPEStartDate)
									AND CONVERT(date, TD.DateOfAcquisition) <= CONVERT(date, @dtPEEndDate)) )
						BEGIN
						--print 'condition 5.1 - previous period end not applicable and now set new period end applicable'
						
						SET @bFlagAddPEMappingRecord = 1 -- add records as per current TP for change period
					END
				END
				-- TP change where PE is applicable and chagne from lower to higher
				ELSE IF ((@nPeriodTypeOld = @nPeriodType_Monthly AND 
							(@nPeriodType = @nPeriodType_Quarterly OR @nPeriodType = @nPeriodType_HalfYearly OR @nPeriodType = @nPeriodType_Yearly))
							
						OR (@nPeriodTypeOld = @nPeriodType_Quarterly AND 
								(@nPeriodType = @nPeriodType_HalfYearly OR @nPeriodType = @nPeriodType_Yearly))
								
						OR (@nPeriodTypeOld = @nPeriodType_HalfYearly AND @nPeriodType = @nPeriodType_Yearly))
				BEGIN
					--print 'condition 6 - period change from lower to higher period type'
					
					SET @bFlagAddPEMappingRecord = 2 -- return alredy set period deails 
					
					-- check if is lower period come between higher period then do not add new record,
					-- if lower period come before  higher period then add record for new higher period 
					
					IF (@dtPEEndDateOld < @dtPEStartDate)
					BEGIN
						--print 'condition 6.1 - period change from lower to higher period type -- last PE is before current period'
						
						SET @bFlagAddPEMappingRecord = 1 -- add records as per current TP for change period
					END
					ELSE IF (@dtPEEndDateOld >= @dtPEStartDate AND @dtPEEndDateOld <= @dtPEEndDate)
					BEGIN
						--print 'condition 6.2 - period change from lower to higher period type -- last PE is between current period'
						
						-- check if there is PE submitted between period, PE is submitted then continue with same pervioue TP 
						-- if PE is not submitted then change TP for higher period and set flag to update TM records for new PE 
						-- if PE is submitted then cheeck for current period records exists and if not exists then add record as per pervious TP for current period 
						
						IF EXISTS(SELECT * FROM tra_TransactionMaster TM 
								WHERE TM.DisclosureTypeCodeId = @nDisclosureType_PeriodEnd 
								AND TM.UserInfoId = @inp_iUserInfoId
								AND TM.PeriodEndDate >= @dtPEStartDate 
								AND TM.PeriodEndDate <= @dtPEEndDate)
						BEGIN
							--print 'condition 6.2.1 - period change from lower to higher period type -- continue PE with lower PE period'
							
							-- between higher period, PE is already generated so do not change period until higher period is over
							-- check if for current period, records exists or not 
							
							-- get period current period as per pervious TP
							SELECT TOP(1) @nCurrPeriodCodeIdOld = CodeID FROM com_Code 
							WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodTypeOld 
							AND CONVERT(date, @inp_dtCurDate) <= DATEADD(DAY, -1, DATEADD(YEAR, @nCurrnetYear - 1970, CONVERT(DATETIME, Description)))
							ORDER BY CONVERT(DATETIME, Description) ASC
							
							-- check if for current period record exists or not 
							SELECT @dtCurrPEEndDateOld = PEEndDate FROM tra_UserPeriodEndMapping
							WHERE UserInfoId = @inp_iUserInfoId AND YearCodeId = @nYearCodeIdOld AND PeriodCodeId = @nCurrPeriodCodeIdOld
							
							-- if for current period record does not exist thne add record for current period 
							IF (@dtCurrPEEndDateOld IS NULL OR @dtCurrPEEndDateOld = '')
							BEGIN
								-- get PE start end date for currnet period for which record does not exists
								EXECUTE @RC = [st_tra_PeriodEndDisclosureStartEndDate2] 
												   @nYearCodeIdOld OUTPUT
												  ,@nCurrPeriodCodeIdOld OUTPUT
												  ,@inp_dtCurDate
												  ,@nPeriodTypeOld
												  ,0
												  ,@dtPEStartDate OUTPUT
												  ,@dtPEEndDate OUTPUT
												  ,@out_nReturnValue OUTPUT
												  ,@out_nSQLErrCode OUTPUT
												  ,@out_sSQLErrMessage OUTPUT
								
								SET @bFlagAddPEMappingRecord = 3 -- add records as per pervious TP for current period
							END	
						END
						ELSE
						BEGIN
							--print 'condition 6.2.2 - period change from lower to higher period type -- change PE to higer PE period'
							
							-- period change from lower to higher and PE is not generated so allow change to higher period 
							
							SET @out_bChangePEDate = 1 -- set flag to update records in transactiom master period end date
							SET @out_dtPEEndDateToUpdate = @dtPEEndDateOld
							SET @bFlagAddPEMappingRecord = 1
							
						END
						
					END
					
				END
				-- TP change where PE is applicable and change from higher to lower
				ELSE IF ((@nPeriodTypeOld = @nPeriodType_Quarterly AND @nPeriodType = @nPeriodType_Monthly)
						
						OR (@nPeriodTypeOld = @nPeriodType_HalfYearly AND 
								@nPeriodType = @nPeriodType_Quarterly OR @nPeriodType = @nPeriodType_Monthly)
						
						OR (@nPeriodTypeOld = @nPeriodType_Yearly AND 
								(@nPeriodType = @nPeriodType_HalfYearly OR @nPeriodType = @nPeriodType_Quarterly OR @nPeriodType = @nPeriodType_Monthly)))
				BEGIN
					--print 'condition 7 - period change from higher to lower period type'
					
					SET @bFlagAddPEMappingRecord = 2 -- return alredy set period deails 
					
					-- check if is higer period is not over than do not add new record,
					-- however if higher period is over than  then add record for new lower period 
					
					IF (@dtPEEndDateOld < @dtPEStartDate)
					BEGIN
						--print 'condition 6.1 - period change from lower to higher period type -- last PE is before current period'
						
						SET @bFlagAddPEMappingRecord = 1 -- add records as per current TP for change period
					END
				END
			END
		END
		
		
		--print 'FlagAddPEMappingRecord '+convert(varchar, @bFlagAddPEMappingRecord)
		
		SET @out_nActinFlag = @bFlagAddPEMappingRecord
		
		IF (@bFlagAddPEMappingRecord = 1) -- add records as per current TP for current period
		BEGIN
			SET @out_nTradingPolicy = @inp_nTradingPolicyId
			SET @out_nYearCodeId = @nYearCodeId
			SET @out_nPeriodCodeId = @nPeriodCodeId
			SET @out_dtPEStartDate = @dtPEStartDate
			SET @out_dtPEEndDate = @dtPEEndDate
		END
		ELSE IF (@bFlagAddPEMappingRecord = 2) -- record is already exists so return what is already stored
		BEGIN
			SET @out_nTradingPolicy = @nTradingPolicyIdOld
			SET @out_nYearCodeId = @nYearCodeIdOld
			SET @out_nPeriodCodeId = @nPeriodCodeIdOld
			SET @out_dtPEStartDate = @dtPEStartDateOld
			SET @out_dtPEEndDate = @dtPEEndDateOld
		END
		ELSE IF (@bFlagAddPEMappingRecord = 3) -- add next period (same period type) records as per previous TP applicable
		BEGIN
			SET @out_nTradingPolicy = @nTradingPolicyIdOld
			SET @out_nYearCodeId = @nYearCodeIdOld
			SET @out_nPeriodCodeId = @nCurrPeriodCodeIdOld
			SET @out_dtPEStartDate = @dtPEStartDate
			SET @out_dtPEEndDate = @dtPEEndDate
		END
				
		--print  'UserInfoId '+convert(varchar, @inp_iUserInfoId) + '   TradingPolicy '+convert(varchar, @out_nTradingPolicy) 
		--		+ '   YearCodeId '+convert(varchar, @out_nYearCodeId) + '   PeriodCodeId '+convert(varchar, ISNULL(@out_nPeriodCodeId,0)) 
		--		+ '   PEStartDate '+case when @out_dtPEStartDate is null then 'NULL ' else convert(varchar, @out_dtPEStartDate) end
		--		+ '   PEEndDate '+case when @out_dtPEEndDate is null then 'NULL ' else convert(varchar, @out_dtPEEndDate) end
		--		+ '   ChangePEDate '+convert(varchar, @out_bChangePEDate) 
		--		+ '   PEEndDateToUpdate '+case when @out_dtPEEndDateToUpdate is null then 'NULL ' else convert(varchar, @out_dtPEEndDateToUpdate) end
		
		RETURN 0
			
	END TRY

	BEGIN CATCH
		--print 'inside catch'
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PERIODENDDISCLOSURE_GETDETAIL
	END CATCH
END
