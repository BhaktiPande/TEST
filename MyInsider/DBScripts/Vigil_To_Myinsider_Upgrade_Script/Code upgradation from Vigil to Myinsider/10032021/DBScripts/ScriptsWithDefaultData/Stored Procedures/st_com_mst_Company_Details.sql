IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_mst_Company_Details')
DROP PROCEDURE [dbo].[st_com_mst_Company_Details]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This Procedure is used to fetch mst_Company table details  .

Returns:		0, if Success.
				
Created by:		Tushar Wakchaure
Created on:		06-Feb-2019

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_mst_Company_Details]

	 @out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT	-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	
	--Variable Declaration
	DECLARE @ERR_PPDReConfirmation_Frequency			        INT = 50782
	BEGIN TRY
	
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
      
	    SELECT CompanyId, RequiredModule,EnableDisableQuantityValue FROM mst_Company WHERE IsImplementing = 1

    RETURN 0
	END	TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PPDReConfirmation_Frequency
	END CATCH
END


