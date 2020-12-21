IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_Check_TradingPolicyName_OS')
DROP PROCEDURE [dbo].[st_Check_TradingPolicyName_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Check the trading Policy name is already exist in table

Returns:		0, if Success.
				
Created by:		Rajashri
Created on:		29-July-2020

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_Check_TradingPolicyName_OS]
	@inp_iTradingPolicyId		INT,
    @inp_iCurrentHistoryCodeId	INT,
    @inp_sTradingPolicyName	NVARCHAR(1024),					
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TRADINGPOLICYNAME_EXISTS												INT	
	DECLARE	@nTPCurrentRecordCode				INT
	DECLARE @nRetValue INT	

	BEGIN 
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		SELECT	@nTPCurrentRecordCode			= 134001				
		
		SELECT @ERR_TRADINGPOLICYNAME_EXISTS	= 55132

		--Initialize variables
		--IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		
		
		
		/*
			Check Wheather Trading Policy is Exists in table
			If Exits then return error message "Trading Policy name is exits."
			else save trading policy
		*/
		IF (((@inp_iTradingPolicyId IS NULL OR @inp_iTradingPolicyId = 0) AND 
			EXISTS(SELECT TradingPolicyId FROM rul_TradingPolicy_OS WHERE TradingPolicyName = @inp_sTradingPolicyName AND CurrentHistoryCodeId = @nTPCurrentRecordCode)) OR
			((@inp_iTradingPolicyId IS NOT NULL OR @inp_iTradingPolicyId > 0) AND 
			EXISTS(SELECT TradingPolicyId FROM rul_TradingPolicy_OS 
			        WHERE TradingPolicyName = @inp_sTradingPolicyName AND
			        TradingPolicyId <> @inp_iTradingPolicyId AND 
					CurrentHistoryCodeId = @nTPCurrentRecordCode)))

			
			BEGIN 		
				SET @out_nReturnValue = @ERR_TRADINGPOLICYNAME_EXISTS
				RETURN (@out_nReturnValue)				
		    END
	
	END	 
END