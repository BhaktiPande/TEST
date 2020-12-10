IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_PersonalDetailsConfirmation')
DROP PROCEDURE [dbo].[st_usr_PersonalDetailsConfirmation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure for Personal Details Confirmation Setting.

Returns:		0, if Success.
				
Created by:		Tushar Wakchaure
Created on:		10-Oct-2018

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_PersonalDetailsConfirmation]
	 @inp_iCompanyId								INT 
	,@inp_iReConfirmationFreqId						INT
	,@inp_iLoggedInUserId                           INT
	,@out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	
	--Variable Declaration
	DECLARE @ERR_PPDReConfirmation_Frequency_Saved		    INT = 50738
	DECLARE @nPeriodType									INT
	DECLARE @nConfirmDate                                   DATETIME = NULL
	DECLARE @nReConfirmDate                                 DATETIME = NULL
	DECLARE @dtPEStartDate									DATETIME
	DECLARE @dtPEEndDate									DATETIME
	DECLARE @nYearCodeId									INT, 
			@nPeriodCodeId									INT 
	DECLARE @Count											INT
	DECLARE @ReConfirmationFreqIdFroUpdate					INT
	DECLARE @Frequency										INT
	
	BEGIN TRY
	
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		set @nPeriodType =  @inp_iReConfirmationFreqId

		SET @nPeriodType = CASE WHEN @nPeriodType = 137001 THEN 123001 -- Yearly
							WHEN @nPeriodType = 137002	THEN 123003 -- Quarterly
							WHEN @nPeriodType = 137003	THEN 123004 -- Monthly
							WHEN @nPeriodType = 137004	THEN 123002 -- Half Year
							ELSE @nPeriodType
						END

      IF  EXISTS (SELECT * FROM com_PersonalDetailsConfirmation where CompanyId = @inp_iCompanyId AND ReConfirmationFreqId != 0 )
	  BEGIN
	     UPDATE com_PersonalDetailsConfirmation 
		 SET 
		 ReConfirmationFreqId = @inp_iReConfirmationFreqId,
		 ModifiedBy	= @inp_iLoggedInUserId,
		 ModifiedOn = dbo.uf_com_GetServerDate()
		 WHERE CompanyId = @inp_iCompanyId
	  END
	  ELSE 
	  BEGIN
	  IF EXISTS (SELECT * FROM com_PersonalDetailsConfirmation where CompanyId = @inp_iCompanyId)
	  BEGIN
	     UPDATE com_PersonalDetailsConfirmation 
		 SET 
		 ReConfirmationFreqId = @inp_iReConfirmationFreqId,
		 ModifiedBy	= @inp_iLoggedInUserId,
		 ModifiedOn = dbo.uf_com_GetServerDate()
		 WHERE CompanyId = @inp_iCompanyId
	  END
	  ELSE
	  BEGIN 
	   INSERT INTO com_PersonalDetailsConfirmation(CompanyId, ReConfirmationFreqId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		VALUES(@inp_iCompanyId, @inp_iReConfirmationFreqId, @inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate())
	  END
	   
	
		DECLARE @nCount  INT = 0
		DECLARE @nTotCount  INT =0
		create table #tempUSERID 
		(
		ID INT IDENTITY(1,1),
		nUserInfoId INT
		)
		insert into #tempUSERID 
		select distinct UserInfoId from eve_EventLog  where EventCodeId = 153043
		select @nTotCount = count(ID) from #tempUSERID
		
		while @nCount < @nTotCount
			BEGIN
			DECLARE @nUserInfoId								INT = 0
			DECLARE @nEnrtyFlag									INT = 1
			DECLARE @nPPDConfirmationFrequency                  INT = 0
			DECLARE @nPeriodType1								INT
			DECLARE @nConfirmDate1                              DATETIME = NULL
			DECLARE @nReConfirmDate1                            DATETIME = NULL
			DECLARE @dtPEStartDate1								DATETIME=null
			DECLARE @dtPEEndDate1								DATETIME=null
			DECLARE @nYearCodeId1								INT=null, 
					@nPeriodCodeId1								INT=null
			select  @nUserInfoId = nUserInfoId from #tempUSERID where ID= @nCount + 1
			SELECT  @nConfirmDate1 = EventDate from eve_EventLog where UserInfoId=@nUserInfoId and EventCodeId=153043
			set @nPeriodType1 = @inp_iReConfirmationFreqId
			SET @nPeriodType1 = CASE WHEN @nPeriodType1 = 137001 THEN 123001 -- Yearly
								WHEN @nPeriodType1 = 137002	THEN 123003 -- Quarterly
								WHEN @nPeriodType1 = 137003	THEN 123004 -- Monthly
								WHEN @nPeriodType1 = 137004	THEN 123002 -- Half Year
								ELSE @nPeriodType1
							END
			
			EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
				@nYearCodeId1 OUTPUT, @nPeriodCodeId1 OUTPUT,@nConfirmDate1, @nPeriodType1, 0, @dtPEStartDate1 OUTPUT, @dtPEEndDate1 OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
			SET @nReConfirmDate1 = @dtPEEndDate1 + 1

				Insert into usr_Reconfirmmation
				(UserInfoID, ConfirmationDate, REConfirmationDate, Frequency, EntryFlag)
				Values   
				(@nUserInfoId, @nConfirmDate1, @nReConfirmDate1, @nPeriodType1, @nEnrtyFlag)

			SET @ncount = @nCount + 1
			END
			drop table #tempUSERID				
	  END
	  	  
	  select @Frequency = Frequency from usr_Reconfirmmation where EntryFlag = 1
	  
	  IF EXISTS(SELECT ReConfirmationFreqId FROM com_PersonalDetailsConfirmation WHERE ReConfirmationFreqId != 0)
	  BEGIN
	  IF(@nPeriodType <> @Frequency )
	  --IF EXISTS(SELECT * FROM usr_Reconfirmmation where EntryFlag = 1 )
	  BEGIN
	  set @ReConfirmationFreqIdFroUpdate = @inp_iReConfirmationFreqId
		DECLARE @nCnt  INT = 0
		DECLARE @nTotCnt  INT =0
		create table #tempConfirmDate 
		(
		Id INT IDENTITY(1,1),
		nConfirmationDate DATETIME 
		)
		insert into #tempConfirmDate 
		select ConfirmationDate from usr_Reconfirmmation  where EntryFlag = 1
		--select * from #tempConfirmDate
		select @nTotCnt = count(Id) from #tempConfirmDate

		--IF(@inp_iReConfirmationFreqId = 0)
		--BEGIN 
		--UPDATE usr_Reconfirmmation 
		--SET REConfirmationDate = '' 
		--WHERE EntryFlag = 1
		--END
		--Else
		--BEGIN
		while @nCnt < @nTotCnt
			BEGIN
				DECLARE @nCFDate							DATETIME = NULL
				DECLARE @nPeriodType2						INT
				--DECLARE @nEnrtyFlag					INT = 1
				DECLARE @nPPDConfirmFrequency1               INT = 0
				select @nCFDate = nConfirmationDate from #tempConfirmDate where ID= @nCnt + 1

				SELECT @nPPDConfirmFrequency1 = ReConfirmationFreqId FROM com_PersonalDetailsConfirmation 
				--SELECT @nConfirmDate = EventDate from eve_EventLog where UserInfoId=@nUserInfoId and EventCodeId=153043

				DECLARE @nReConfirmDate2                            DATETIME = NULL
				DECLARE @dtPEStartDate2								DATETIME=null
				DECLARE @dtPEEndDate2								DATETIME=null
				DECLARE @nYearCodeId2								INT=null, 
						@nPeriodCodeId2								INT=null

				set @nPeriodType2 =  @nPPDConfirmFrequency1
				SET @nPeriodType2 = CASE WHEN @nPeriodType2 = 137001 THEN 123001 -- Yearly
									WHEN @nPeriodType2 = 137002	THEN 123003 -- Quarterly
									WHEN @nPeriodType2 = 137003	THEN 123004 -- Monthly
									WHEN @nPeriodType2 = 137004	THEN 123002 -- Half Year
									ELSE @nPeriodType2
								END

					
				EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
					@nYearCodeId2 OUTPUT, @nPeriodCodeId2 OUTPUT,@nCFDate, @nPeriodType2, 0, @dtPEStartDate2 OUTPUT, @dtPEEndDate2 OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
				--IF(@nCFDate IS NOT NULL)
				--BEGIN 
					SET @nReConfirmDate2 = @dtPEEndDate2 + 1
				--END
				--select * from usr_Reconfirmmation 	WHERE  EntryFlag = 1
					UPDATE usr_Reconfirmmation 
						SET REConfirmationDate = @nReConfirmDate2,--convert(datetime, @nReConfirmDate2, 21),
						Frequency = @nPeriodType2 
						WHERE  EntryFlag = 1 and ConfirmationDate = @nCFDate

					--select convert(varchar, @nReConfirmDate2, 21)
					--select * from usr_Reconfirmmation 	WHERE  EntryFlag = 1
				--select REConfirmationDate from usr_Reconfirmmation where EntryFlag = 1
				SET @nCnt = @nCnt + 1
			END  
			drop table #tempConfirmDate
				
		END
		END	
			
	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PPDReConfirmation_Frequency_Saved
	END CATCH
END
