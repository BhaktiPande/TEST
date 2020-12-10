IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_UpsiAutoId')
DROP PROCEDURE [dbo].[st_UpsiAutoId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Upsi Document Id .

Returns:		0, if Success.
				
Created by:		Arvind
Created on:		07-May-2019

Usage:
EXEC st_UpsiAutoId 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_UpsiAutoId]
     @inp_iUserInfoId				                INT
	,@out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT	-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN

	DECLARE @ERR_PPDReConfirmation_Frequency			       INT = 50782	
	
	BEGIN TRY
	
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

	DECLARE @MAXID INT = 0
	select @MAXID= (select DISTINCT ISNULL(MAX(UPSIDocumentId),0) UPSIDocumentId from usr_UPSIDocumentMasters)
	
	
	if(@MAXID=0)
	begin
	
	select  'UPSI001' AS DocumentNo 
	END
	Else
	 BEGIN
	 set @MAXID= @MAXID +1
	 select distinct  'UPSI' + RIGHT('00' + CONVERT(VARCHAR(5), @MAXID), 6) DocumentNo from usr_UPSIDocumentMasters
	END
		
    RETURN 0
	END	TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PPDReConfirmation_Frequency
	END CATCH
END
