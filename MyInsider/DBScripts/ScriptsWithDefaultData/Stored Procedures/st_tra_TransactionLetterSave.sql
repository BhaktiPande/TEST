IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionLetterSave')
DROP PROCEDURE [dbo].[st_tra_TransactionLetterSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save Trading Letter Details

Returns:		0, if Success.
				
Created by:		Ashish
Created on:		23-April-2015

Modification History:
Modified By		Modified On		Description
Arundhati		11-Jul-2015		Check to avoid duplicate entry of letter for the same transaction.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_tra_TransactionLetterSave
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TransactionLetterSave]
	@inp_iTransactionLetterId			BIGINT
	,@inp_iTransactionMasterId			BIGINT 
    ,@inp_iLetterForCodeId				INT
    ,@inp_dtDate						DATETIME
    ,@inp_sToAddress1					NVARCHAR(250)
    ,@inp_sToAddress2					NVARCHAR(250)
    ,@inp_sSubject						NVARCHAR(150)
    ,@inp_sContents						NVARCHAR(2000)
	,@inp_sSignature					NVARCHAR(200)	
    ,@inp_iLoggedInUserId				INT
	,@out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_TRANSACTIONLETTER_SAVE INT = 17339			-- Error occurred while saving details.
	DECLARE @ERR_TRANSACTIONLETTERINFO_NOTFOUND INT = 17340	-- Details does not exist.
	DECLARE @ERR_LETTERALREADYEXISTS INT = 17341
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF @inp_iTransactionLetterId = 0
		BEGIN
			IF EXISTS(SELECT * FROM tra_TransactionLetter WHERE LetterForCodeId = @inp_iLetterForCodeId AND TransactionMasterId = @inp_iTransactionMasterId)
			BEGIN
				SELECT @out_nReturnValue = @ERR_LETTERALREADYEXISTS
				RETURN @out_nReturnValue
			END
			
			-- Insert new record
			INSERT INTO tra_TransactionLetter
				(TransactionMasterId, LetterForCodeId, Date, ToAddress1, ToAddress2, 
				 Subject, Contents, Signature, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
			VALUES
				(@inp_iTransactionMasterId, @inp_iLetterForCodeId, @inp_dtDate, 
				 @inp_sToAddress1, @inp_sToAddress2, @inp_sSubject, @inp_sContents, @inp_sSignature,
				@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate())	
				
				SET @inp_iTransactionLetterId = SCOPE_IDENTITY()	
					
		END
		ELSE
		BEGIN
			--Check if TransactionLetterDetails whose details are being updated exists
			IF (NOT EXISTS(SELECT TransactionLetterId FROM tra_TransactionLetter WHERE TransactionLetterId = @inp_iTransactionLetterId))
			BEGIN		
				SET @out_nReturnValue = @ERR_TRANSACTIONLETTERINFO_NOTFOUND
				RETURN (@out_nReturnValue)
			END

			-- Update existing details
			UPDATE tra_TransactionLetter
			SET 
				TransactionMasterId = @inp_iTransactionMasterId,
				LetterForCodeId = @inp_iLetterForCodeId,
				Date = @inp_dtDate,
				ToAddress1 = @inp_sToAddress1,
				ToAddress2 = @inp_sToAddress2,
				Subject = @inp_sSubject,
				Contents = @inp_sContents,
				Signature = @inp_sSignature,
				ModifiedBy = @inp_iLoggedInUserId,
				ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE TransactionLetterId = @inp_iTransactionLetterId
		END
		
		SELECT *
		FROM tra_TransactionLetter 
		WHERE TransactionLetterId = @inp_iTransactionLetterId
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_TRANSACTIONLETTER_SAVE,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
