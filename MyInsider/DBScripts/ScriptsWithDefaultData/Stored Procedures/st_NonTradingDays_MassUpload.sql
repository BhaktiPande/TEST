IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_NonTradingDays_MassUpload')
	DROP PROCEDURE st_NonTradingDays_MassUpload
GO
-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 04-JAN-2016                                                 							=
-- Description : THIS PROCEDURE IS USED FOR NON-TRADING DAY MASS-UPLOAD									=
-- EXEC st_NonTradingDays_MassUpload																	=
-- ======================================================================================================

CREATE PROCEDURE st_NonTradingDays_MassUpload
(
	@Reason					VARCHAR(200),
	@NonTradDay				VARCHAR(200),	
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
)
AS

BEGIN
	BEGIN TRY
		DECLARE @NSE INT, @BSE INT 
		SET @NSE = 116001
		SET @BSE = 116002
		
		--IF NOT (ISDATE(@NonTradDay) = 1)
		--BEGIN
		--	SELECT 1
		--	SET @out_nReturnValue = 50036
		--	SET @out_nSQLErrCode    =  1
		--	SET @out_sSQLErrMessage =  'Invalid value provided for Non-Trading Day'
		--	RETURN (@out_nReturnValue)
		--END
		
		PRINT 'Reason - ' + @Reason					
		PRINT 'NonTradDay - ' + @NonTradDay				
		
		IF NOT EXISTS (SELECT NonTradDay FROM NonTradingDays WHERE CONVERT(DATE,NonTradDay)= CONVERT(DATE,@NonTradDay))
		BEGIN
			INSERT INTO NonTradingDays (NonTradDay,Exchangetype,Reason)
			VALUES(@NonTradDay,@NSE,@Reason)		
		
			INSERT INTO NonTradingDays (NonTradDay,Exchangetype,Reason)
			VALUES(@NonTradDay,@BSE,@Reason)
		END	
		ELSE
		BEGIN
			UPDATE NonTradingDays SET NonTradDay = @NonTradDay, Reason = @Reason WHERE CONVERT(DATE,NonTradDay) = CONVERT(DATE,@NonTradDay)
		END
		
		SELECT 1 
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END TRY
	BEGIN CATCH
		SELECT 1
		SET @out_nReturnValue = ERROR_NUMBER()
		RETURN @out_nReturnValue
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue = @out_nSQLErrCode
	END CATCH
END