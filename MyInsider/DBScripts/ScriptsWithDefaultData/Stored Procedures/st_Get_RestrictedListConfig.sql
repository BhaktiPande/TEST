IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_Get_RestrictedListConfig')
DROP PROCEDURE [dbo].[st_Get_RestrictedListConfig]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the restrected list setting from trading policy UI 

				
Created by:		Rajashri
Created on:		29-July-2020

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_Get_RestrictedListConfig]
	@inp_iId					INT,
    @inp_iSearchType			INT,
    @inp_iSearchLimit			INT,
	@inp_iApprovalType			INT,	
	@inp_bIsDematAllowed		BIT,	
	@inp_bIsFormFRequired		BIT,					
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	
	DECLARE @ERR_RestrictedListConfig_SAVE INT = 11025 -- Error occuerd while save the settings	
	
	DECLARE @nRetValue INT	

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
				
		--Check ResstrictedList settings already exist or not
		--If it exist then retrun Id	
		
		IF(EXISTS(SELECT Id FROM rl_RestrictedListConfig WHERE SearchType=@inp_iSearchType AND 
				CASE WHEN SearchLimit IS NULL THEN 1  ELSE SearchLimit END=CASE WHEN @inp_iSearchLimit IS NULL THEN 1  ELSE @inp_iSearchLimit END AND
				ApprovalType=@inp_iApprovalType AND 
				IsDematAllowed=@inp_bIsDematAllowed AND
				IsFormFRequired=@inp_bIsFormFRequired))
				
		BEGIN
		
		  SELECT @inp_iId= Id FROM rl_RestrictedListConfig WHERE SearchType=@inp_iSearchType AND 
				CASE WHEN SearchLimit IS NULL THEN 1  ELSE SearchLimit END=CASE WHEN @inp_iSearchLimit IS NULL THEN 1  ELSE @inp_iSearchLimit END AND
				ApprovalType=@inp_iApprovalType AND 
				IsDematAllowed=@inp_bIsDematAllowed AND
				IsFormFRequired=@inp_bIsFormFRequired
			SET @out_nReturnValue = @inp_iId
		RETURN @out_nReturnValue
		END
		ELSE
	
		 ---If ResstrictedList settings not exist then insert new recored and return the Id
		BEGIN
			INSERT INTO rl_RestrictedListConfig(					
					SearchType,
					SearchLimit,
					ApprovalType,
					IsDematAllowed,
					IsFormFRequired
					)
			VALUES (				
					 @inp_iSearchType,
					 @inp_iSearchLimit,
					 @inp_iApprovalType,	
					@inp_bIsDematAllowed,	
					@inp_bIsFormFRequired
					)
					
			SET @inp_iId = SCOPE_IDENTITY()

		END
			
		SET @out_nReturnValue = @inp_iId
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_RestrictedListConfig_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END