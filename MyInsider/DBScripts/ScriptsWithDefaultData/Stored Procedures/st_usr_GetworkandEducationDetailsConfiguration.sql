IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_GetworkandEducationDetailsConfiguration')
DROP PROCEDURE [dbo].[st_usr_GetworkandEducationDetailsConfiguration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to get work and education configuration

Returns:		0, if Success.
				
Created by:		Shubhangi Gurude
Created on:		19-Jan-2021

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_GetworkandEducationDetailsConfiguration]
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

		SELECT WorkandEducationDetailsConfigurationId FROM com_WorkandEducationDetailsConfiguration WHERE CompanyId=@inp_iCompanyId

    RETURN 0
	END	TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PPDReConfirmation_Frequency
	END CATCH
END
