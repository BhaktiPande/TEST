
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DMATAccountHolderDetails')
DROP PROCEDURE [dbo].[st_usr_DMATAccountHolderDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get DMAT Holder Details.

Returns:		0, if Success.
				
Created by:		Ashish
Created on:		04-Mar-2015

Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_usr_DMATAccountHolderDetails ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DMATAccountHolderDetails]
	@inp_iDMATAccountHolderId		INT,
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_DMATHOLDERDETAILS_NOTFOUND   INT = 11220 -- DMAT Holder info not found
	DECLARE @ERR_DMATHOLDERDETAILS_GETDETAILS INT = 11222 -- Error occurred while fetching DMAT account holders details
	
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

		--Check if the DMAT whose details are being fetched exists
		IF (NOT EXISTS(SELECT DMATAccountHolderId FROM usr_DMATAccountHolder WHERE DMATAccountHolderId = @inp_iDMATAccountHolderId))
		BEGIN
				SET @out_nReturnValue = @ERR_DMATHOLDERDETAILS_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the Company details
		SELECT * 
		FROM usr_DMATAccountHolder
		WHERE DMATAccountHolderId = @inp_iDMATAccountHolderId

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_DMATHOLDERDETAILS_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END