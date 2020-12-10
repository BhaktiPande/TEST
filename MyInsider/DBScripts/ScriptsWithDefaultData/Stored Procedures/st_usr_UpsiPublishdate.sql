IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UpsiPublishdate')
	DROP PROCEDURE st_usr_UpsiPublishdate
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the Upsi Publish date 

Returns:		0, if Success.
				
Created by:		Arvind
Created on:		10-April-2019

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE st_usr_UpsiPublishdate
	
	 @inp_iUserInfoId					INT,						
	 @inp_nUpsi_id						INt ,	
	 @inp_nPublishDate				    DATETIME,
	 @out_nReturnValue					INT = 0 OUTPUT,
	 @out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	 @out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred. 
	
	
AS
BEGIN

	DECLARE @ERR_CONTACTDETAILS_SAVE	INT = 17512 -- Error occured while saving preclearance for non implementing company
	DECLARE @ERR_Publishdate INT =55071
	DECLARE @dSharingDate DATETIME
		
	BEGIN TRY		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		BEGIN  -----Update Upsi Publish Date -------------
			select @dSharingDate=SharingDate  from usr_UPSIDocumentMasters WHERE UPSIDocumentId=@inp_nUpsi_id AND UserInfoId=@inp_iUserInfoId
			IF(@dSharingDate > @inp_nPublishDate)
			BEGIN
				SET @out_nReturnValue=@ERR_Publishdate			
			END
			ELSE
			BEGIN
				Update usr_UPSIDocumentMasters SET PublishDate=@inp_nPublishDate WHERE UPSIDocumentId=@inp_nUpsi_id AND UserInfoId=@inp_iUserInfoId
			END		
		END
			
		IF @out_nReturnValue <> 0
		BEGIN	
			RETURN @out_nReturnValue
		END
		select 1
		RETURN @out_nReturnValue		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_CONTACTDETAILS_SAVE, ERROR_NUMBER())
		
	END CATCH
END
