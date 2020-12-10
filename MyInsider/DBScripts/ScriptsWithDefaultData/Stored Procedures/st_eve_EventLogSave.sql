IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_eve_EventLogSave')
DROP PROCEDURE [dbo].[st_eve_EventLogSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the Event details in Event Log

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		23-Apr-2015

Modification History:
Modified By		Modified On		Description
Swapnil			25-Apr-2015		Added condition to remove Duplicate entries.
Swapnil			30-May-2015		Added CreatedBy column.
Parag			08-Sep-2015		Made change to show Error for confirm personal details event 
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.								Also made change to check event type ie confirm personal details and show error message related to that event type

Usage:
DECLARE @RC int
EXEC st_eve_EventLogSave 153027
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_eve_EventLogSave]
	@inp_iEventCodeId		INT,						-- Event Type
	@inp_iMapToTypeCodeId	INT,						-- Mapped to the type of event
	@inp_iMapToid			INT,						-- Id of the mapped event.
	@inp_nUserId			INT,						-- Id of the user inserting / Loggen In
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_EVENT_SAVE	   INT = -1 -- Error occurred while saving Event.
	
	DECLARE @ERR_CONFIRM_PERSONAL_DETAILS_EXISTS	INT = 11416  -- Confirm personal details event already exists
	
	DECLARE @nConfirm_Personal_Details_Event		INT = 153043	
	DECLARE @EVENT_PASSWORDCHANGED                  INT = 153049
	DECLARE @EVENT_PASSWORDEXPIRE					INT = 153048
	DECLARE @nPasswordValidity						INT = 0
	DECLARE @ValidityDate							DATETIME
	DECLARE @LASTEVENTCODEID                        INT = 0
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
			
		-- Check if event already exists 
		IF(EXISTS(SELECT E.EventLogId FROM eve_EventLog E WHERE E.EventCodeId = @inp_iEventCodeId AND E.MapToTypeCodeId = @inp_iMapToTypeCodeId AND E.MapToId = @inp_iMapToid AND E.UserInfoId = @inp_nUserId AND @inp_iEventCodeId <> @EVENT_PASSWORDEXPIRE AND @inp_iEventCodeId <> @EVENT_PASSWORDCHANGED))
		BEGIN
			IF (@inp_iEventCodeId != @nConfirm_Personal_Details_Event)
			BEGIN 
				SET @out_nReturnValue = 0
				RETURN @out_nReturnValue
			END 				
		END
		ELSE
		BEGIN
			--Save the Event details
			IF(@inp_iEventCodeId <> @EVENT_PASSWORDEXPIRE AND @inp_iEventCodeId <> @EVENT_PASSWORDCHANGED)
			BEGIN		
				Insert into eve_EventLog
					(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
				Values   
					(@inp_iEventCodeId, dbo.uf_com_GetServerDate(), @inp_nUserId, @inp_iMapToTypeCodeId, @inp_iMapToid, @inp_nUserId)
			END
			ELSE 
			BEGIN
				SELECT @nPasswordValidity = PassValidity FROM usr_PasswordConfig
				SELECT @ValidityDate=DATEADD(DAY, @nPasswordValidity, ModifiedOn) FROM usr_Authentication WHERE UserInfoID=@inp_iMapToid
				SELECT TOP 1 @LASTEVENTCODEID = EventCodeId FROM eve_EventLog WHERE UserInfoId=@inp_nUserId AND EventCodeId IN (@EVENT_PASSWORDEXPIRE,@EVENT_PASSWORDCHANGED) ORDER BY EventLogId DESC
				select @EventCount = COUNT(*) from eve_EventLog where UserInfoId=@inp_nUserId and EventCodeId in (@EVENT_PASSWORDEXPIRE,@EVENT_PASSWORDCHANGED)
				
				IF(@ValidityDate < GETDATE() OR @LASTEVENTCODEID = @EVENT_PASSWORDEXPIRE OR @EventCount = 0)
				BEGIN
					Insert into eve_EventLog
					(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
					Values   
					(@inp_iEventCodeId, dbo.uf_com_GetServerDate(), @inp_nUserId, @inp_iMapToTypeCodeId, @inp_iMapToid, @inp_nUserId)
				END
				ELSE
				BEGIN
					IF(@inp_iEventCodeId = @EVENT_PASSWORDCHANGED AND @LASTEVENTCODEID = @EVENT_PASSWORDCHANGED)
					BEGIN
						UPDATE eve_EventLog SET EventDate=dbo.uf_com_GetServerDate() 
						WHERE EventCodeId = @inp_iEventCodeId 
						AND MapToTypeCodeId = @inp_iMapToTypeCodeId 
						AND MapToId = @inp_iMapToid 
						AND UserInfoId = @inp_nUserId
					END 
				END
			END
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