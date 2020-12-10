IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DMATDetails')
DROP PROCEDURE [dbo].[st_usr_DMATDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get DMAT Details.

Returns:		0, if Success.
				
Created by:		Ashish
Created on:		25-Feb-2015
Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_usr_DMATDetails ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DMATDetails]
	@inp_iDMATDetailsID		INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_DMATDETAILS_NOTFOUND INT = 11060 -- DMAT info not found
	DECLARE @ERR_DMATDETAILS_GETDETAILS INT = 11203 -- Error occurred while fetching DMAT details
	
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
		IF (NOT EXISTS(SELECT DMATDetailsID FROM usr_DMATDetails WHERE DMATDetailsID = @inp_iDMATDetailsID))
		BEGIN
				SET @out_nReturnValue = @ERR_DMATDETAILS_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the Company details
		SELECT * 
		FROM usr_DMATDetails
		WHERE DMATDetailsID = @inp_iDMATDetailsID

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_DMATDETAILS_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END