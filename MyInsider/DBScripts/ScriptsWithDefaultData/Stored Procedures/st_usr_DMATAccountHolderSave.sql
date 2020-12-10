IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DMATAccountHolderSave')
DROP PROCEDURE [dbo].[st_usr_DMATAccountHolderSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves demat accoutn holder details for Employee / Non-Employee type user.

Returns:		0, if Success.
				
Created by:		Ashish
Created on:		04-Mar-2010

Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_usr_DMATAccountHolderSave 1, 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DMATAccountHolderSave]
	 @inp_iDMATAccountHolderId		INT
	,@inp_iDMATDetailsID			INT	
	,@inp_sAccountHolderName		NVARCHAR(100)
	,@inp_sPAN						NVARCHAR(50)	
	,@inp_iRelationTypeCodeId		INT
    ,@inp_iLoggedInUserId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_DEMATHOLDER_SAVE INT = 11221 -- Error occurred while saving DMAT account holder''s details.
	DECLARE @ERR_DEMATHOLDERINFO_NOTFOUND INT = 11220	-- Demat holder details does not exist.
	DECLARE @ERR_DMATNOTVALIDFORDEMATHOLDERDETAILS INT = 11060 -- DMAT detail not found
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF NOT EXISTS(SELECT DMATDetailsID FROM usr_DMATDetails 
					WHERE DMATDetailsID = @inp_iDMATDetailsID)
		BEGIN
			SET @out_nReturnValue = @ERR_DMATNOTVALIDFORDEMATHOLDERDETAILS
			RETURN @out_nReturnValue
		END
		
		IF @inp_iDMATAccountHolderId = 0
		BEGIN
			-- Insert new record
			INSERT INTO usr_DMATAccountHolder
				(DMATDetailsID, AccountHolderName, PAN, RelationTypeCodeId,
				CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
			VALUES
				(@inp_iDMATDetailsID, @inp_sAccountHolderName, @inp_sPAN, @inp_iRelationTypeCodeId,
				@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate())			
			
			SET @inp_iDMATAccountHolderId = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			--Check if the UserInfo whose details are being updated exists
			IF (NOT EXISTS(SELECT DMATAccountHolderId FROM usr_DMATAccountHolder WHERE DMATAccountHolderId = @inp_iDMATAccountHolderId))
			BEGIN		
				SET @out_nReturnValue = @ERR_DEMATHOLDERINFO_NOTFOUND
				RETURN (@out_nReturnValue)
			END

			-- Update existing details
			UPDATE usr_DMATAccountHolder
			SET AccountHolderName = @inp_sAccountHolderName,
				PAN = @inp_sPAN,
				RelationTypeCodeId = @inp_iRelationTypeCodeId,
				ModifiedBy = @inp_iLoggedInUserId,
				ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE DMATAccountHolderId = @inp_iDMATAccountHolderId
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_DEMATHOLDER_SAVE,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
