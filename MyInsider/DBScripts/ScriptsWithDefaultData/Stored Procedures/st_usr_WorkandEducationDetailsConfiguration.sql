IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_WorkandEducationDetailsConfiguration')
DROP PROCEDURE [dbo].[st_usr_WorkandEducationDetailsConfiguration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure for Work and Education Configuration Setting.

Returns:		0, if Success.
				
Created by:		Shubhangi Gurude
Created on:		18-Jan-2021

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_WorkandEducationDetailsConfiguration]
	 @inp_iCompanyId								INT 
	,@inp_iWorkandEducationDetailsConfigurationId	INT
	,@inp_iLoggedInUserId                           INT
	,@out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
		
	BEGIN TRY
	
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = '' 
	  
	  IF EXISTS (SELECT * FROM com_WorkandEducationDetailsConfiguration where CompanyId = @inp_iCompanyId)
	  BEGIN
	     UPDATE com_WorkandEducationDetailsConfiguration 
		 SET 
		 WorkandEducationDetailsConfigurationId = @inp_iWorkandEducationDetailsConfigurationId,
		 ModifiedBy	= @inp_iLoggedInUserId,
		 ModifiedOn = dbo.uf_com_GetServerDate()
		 WHERE CompanyId = @inp_iCompanyId
	  END
	  ELSE
	  BEGIN 
		INSERT INTO com_WorkandEducationDetailsConfiguration(CompanyId, WorkandEducationDetailsConfigurationId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		VALUES(@inp_iCompanyId, @inp_iWorkandEducationDetailsConfigurationId, @inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate())
	  END	 
			
	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  0
	END CATCH
END
