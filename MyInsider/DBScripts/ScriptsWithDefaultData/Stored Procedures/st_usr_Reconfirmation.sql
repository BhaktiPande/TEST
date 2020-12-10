IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_Reconfirmation')
DROP PROCEDURE [dbo].[st_usr_Reconfirmation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the Reconfirmation details in usr_Reconfirmation

Returns:		0, if Success.
				
Created by:		Novit
Created on:		04-Mar-2019

Usage:
DECLARE @RC int
EXEC st_usr_Reconfirmation 
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_Reconfirmation]
	@inp_nUserId			INT,						-- Id of the user inserting / Loggen In
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_EVENT_SAVE	   INT = -1 -- Error occurred while saving Event.
	
	DECLARE @nConfirmDate                                   DATETIME = NULL
	DECLARE @nReConfirmDate                                 DATETIME = NULL
	DECLARE @nPeriodType									INT
	DECLARE @nPPDConfirmationFrequency                      INT = 0
	
	DECLARE @dtPEStartDate								DATETIME
	DECLARE @dtPEEndDate								DATETIME
	DECLARE @nYearCodeId								INT, 
			@nPeriodCodeId								INT 

	DECLARE @nEnrtyFlag									INT = 1
	DECLARE @nFrequency									INT



	DECLARE @ERR_CONFIRM_PERSONAL_DETAILS_EXISTS	INT = 11416  -- Confirm personal details event already exists
	
	--DECLARE @nConfirm_Personal_Details_Event		INT = 153043	
	--DECLARE @EVENT_PASSWORDCHANGED                  INT = 153049
	--DECLARE @EVENT_PASSWORDEXPIRE					INT = 153048
	--DECLARE @nPasswordValidity						INT = 0
	DECLARE @ValidityDate							DATE
	--DECLARE @LASTEVENTCODEID                        INT = 0
	DECLARE @EventCount							    INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

	SELECT @nPPDConfirmationFrequency = ReConfirmationFreqId FROM com_PersonalDetailsConfirmation 
	IF(@nPPDConfirmationFrequency <> 0 )
	BEGIN
	--IF EXISTS (SELECT * FROM usr_Reconfirmmation where UserInfoID = @inp_nUserId and EntryFlag=1)
	--BEGIN
	--SELECT @nConfirmDate = getdate()
	--END
	--ELSE
	--BEGIN
	SELECT @nConfirmDate = GETDATE()
	--END
	set @nPeriodType =  @nPPDConfirmationFrequency

	SET @nPeriodType = CASE WHEN @nPeriodType = 137001 THEN 123001 -- Yearly
							WHEN @nPeriodType = 137002	THEN 123003 -- Quarterly
							WHEN @nPeriodType = 137003	THEN 123004 -- Monthly
							WHEN @nPeriodType = 137004	THEN 123002 -- Half Year
							ELSE @nPeriodType
						END
		
	EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
		   @nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT,@nConfirmDate, @nPeriodType, 0, @dtPEStartDate OUTPUT, @dtPEEndDate OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
	IF(@nConfirmDate IS NOT NULL)
	BEGIN 
	SET @nReConfirmDate = @dtPEEndDate + 1
	END  

	Select @nFrequency = Frequency, @nConfirmDate = ConfirmationDate from usr_Reconfirmmation  where @inp_nUserId = UserInfoID AND EntryFlag = 1

	IF(@nPeriodType != @nFrequency)
	BEGIN
	--Update the Reconfirmation details
	print('UPDATE')
		UPDATE usr_Reconfirmmation 
		SET UserInfoID = @inp_nUserId,
			ConfirmationDate = @nConfirmDate,
			REConfirmationDate = @nReConfirmDate,
			Frequency = @nPeriodType ,
			EntryFlag = 1
			WHERE  @inp_nUserId = UserInfoID AND EntryFlag = 1
	END
	ELSE
	BEGIN
		--Save the Reconfirmation details
		IF(@inp_nUserId IS NOT NULL)
		BEGIN		
			print('INSERT')
			update usr_Reconfirmmation set EntryFlag = 0 where UserInfoID = @inp_nUserId
			--select EntryFlag from usr_Reconfirmmation
			Insert into usr_Reconfirmmation
				(UserInfoID, ConfirmationDate, REConfirmationDate, Frequency, EntryFlag)
			Values   
				(@inp_nUserId, dbo.uf_com_GetServerDate(), @nReConfirmDate, @nPeriodType, @nEnrtyFlag)
		END
	END
	SET @out_nReturnValue = 0
	RETURN @out_nReturnValue
	END
	SET @out_nReturnValue = 0
	RETURN @out_nReturnValue
END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_EVENT_SAVE, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
	END CATCH

END