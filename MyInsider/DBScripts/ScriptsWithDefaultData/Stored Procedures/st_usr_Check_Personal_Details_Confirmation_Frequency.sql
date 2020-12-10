IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_Check_Personal_Details_Confirmation_Frequency')
DROP PROCEDURE [dbo].[st_usr_Check_Personal_Details_Confirmation_Frequency]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure for Check Personal & Professional Details Confirmation Frequency.

Returns:		0, if Success.
				
Created by:		Tushar Wakchaure
Created on:		21-Jan-2019

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_Check_Personal_Details_Confirmation_Frequency]
     @inp_iCompanyId				                INT
	,@out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT	-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	
	--Variable Declaration
	DECLARE @ERR_PPDReConfirmation_Frequency			        INT = 50782

	DECLARE @nReConfirmation_FrequencyId			            INT = 0
	DECLARE @nCompanyId			                                INT = 0
	
	BEGIN TRY
	
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
      
	    SELECT @nReConfirmation_FrequencyId = ReConfirmationFreqId, @nCompanyId = CompanyId FROM com_PersonalDetailsConfirmation WHERE CompanyId = @inp_iCompanyId
	    SELECT @nReConfirmation_FrequencyId AS ReConfirmationFreqId, @nCompanyId AS CompanyId 

    RETURN 0
	END	TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PPDReConfirmation_Frequency
	END CATCH
END
