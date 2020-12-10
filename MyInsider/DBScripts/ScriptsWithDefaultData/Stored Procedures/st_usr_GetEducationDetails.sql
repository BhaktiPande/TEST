IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_GetEducationDetails')
DROP PROCEDURE [dbo].[st_usr_GetEducationDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the Education details

Returns:		0, if Success.
				
Created by:		samadhan
Created on:		14-Feb-2019

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_GetEducationDetails]
	@UserInfoId				INT= 0, 
	@UEW_id                 INT=0,						
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	
	
AS
BEGIN
	

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		Select UEW_id,
			UserInfoID,	
			InstituteName,	
			CourseName,	
			EmployerName,	
			Designation,	
			PMonth,	
			PYear,	
			ToMonth,	
			ToYear,	
			Flag FROM usr_EducationWorkDetails WHERE UEW_id=@UEW_id

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		--SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_ROLEMASTER_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

