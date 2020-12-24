IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionLetterDetails')
DROP PROCEDURE [dbo].[st_tra_TransactionLetterDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the transaction letter if parameter id is not zero, else fetch the corresponding template

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		16-Apr-2015

Modification History:
Modified By		Modified On	Description
Ashish		    23-Apr-2015 Addd columns while selecting
Ashish			07-May-2015	Change the select query for TrasactionLetterId is not 0
Ashish			11-May-2015 Change the columns as per the new table design for Master
Ashish			16-May-2015	Added the warning condition if template is not defined
Ashish			18-May-2015 Change type of @inp_iTransactionLetterId and @inp_iTransactionMasterId from INT to BIGINT
Raghvendra		24-Mar-2016	Change to show the User designation auto populated in the Disclosure Letter
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Vivek			27-Jan-2017	Changed the select query to get the active template flag value and removed the condition IsActive = 1 from template master table.

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TransactionLetterDetails]
	@inp_iTransactionLetterId	  BIGINT,
	@inp_iTransactionMasterId	  BIGINT,
	@inp_iDisclosureTypeCodeId	  INT,
	@inp_iLetterForCodeId		  INT,
	@inp_iCommunicationModeCodeId INT,
	@out_nWarningNotTemplateFound INT = 0 OUTPUT,
	@out_nReturnValue			  INT = 0 OUTPUT,
	@out_nSQLErrCode			  INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			  NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TRANSACTIONLETTERDETAILS_GETDETAILS INT = -1 -- Error occurred while fetching transaction letter details.
	DECLARE @ERR_TRANSACTIONLETTERDETAILS_NOTFOUND INT = -2 -- Transaction Letter Details does not exist.
	DECLARE @ERR_TEMPLATE_NOTDEFINED INT = -3 -- Reference template is not defined by the CO. Please contact administrator.
	DECLARE @WARN_TEMPLATE_NOTFOUND INT = -4

	DECLARE @sLetterForUserDesignation NVARCHAR(Max) = ''

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Initialize variables

		--Check if the Code whose details are being fetched exists
		IF (@inp_iTransactionLetterId <> 0 
			AND NOT EXISTS(SELECT TransactionLetterId FROM tra_TransactionLetter WHERE TransactionLetterId = @inp_iTransactionLetterId))
		BEGIN
				SET @out_nReturnValue = @ERR_TRANSACTIONLETTERDETAILS_NOTFOUND
				RETURN (@out_nReturnValue)
		END	
		SELECT @sLetterForUserDesignation = ISNULL(CASE WHEN CC.CodeName IS NULL THEN UI.DesignationText ELSE CC.CodeName END,'') FROM tra_transactionMaster TM
		JOIN usr_UserInfo UI ON UI.UserInfoId = TM.UserInfoId
		LEFT JOIN com_Code CC ON CC.CodeID = UI.DesignationId
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		--Print @sLetterForUserDesignation
		--Fetch the Code details
		IF @inp_iTransactionLetterId = 0 
		BEGIN
			IF(EXISTS( SELECT * 
					   FROM tra_TransactionLetter 
					   WHERE TransactionMasterId = @inp_iTransactionMasterId
					         AND LetterForCodeId = @inp_iLetterForCodeId))
			BEGIN
			 	SELECT TL.*,TP.IsActive,@sLetterForUserDesignation AS LetterForUserDesignation 
				FROM tra_TransactionLetter TL, tra_TemplateMaster TP, tra_TransactionMaster TM
				WHERE TL.TransactionMasterId = @inp_iTransactionMasterId
					  AND TL.LetterForCodeId = @inp_iLetterForCodeId
					  AND TP.CommunicationModeCodeId= @inp_iCommunicationModeCodeId
					  AND TM.DisclosureTypeCodeId = @inp_iDisclosureTypeCodeId
					  AND TL.TransactionMasterId = TM.TransactionMasterId
					  AND TL.LetterForCodeId = TP.LetterForCodeId
					  AND TM.DisclosureTypeCodeId = TP.DisclosureTypeCodeId
			END
		
			ELSE 
			BEGIN
				IF NOT EXISTS (SELECT TemplateMasterId FROM tra_TemplateMaster 
								WHERE DisclosureTypeCodeId = @inp_iDisclosureTypeCodeId 
									AND LetterForCodeId = @inp_iLetterForCodeId
									AND CommunicationModeCodeId = @inp_iCommunicationModeCodeId)
				BEGIN
					SET @out_nWarningNotTemplateFound = @WARN_TEMPLATE_NOTFOUND
					SELECT @inp_iTransactionLetterId AS TransactionLetterId, @inp_iDisclosureTypeCodeId AS DisclosureTypeCodeId, @inp_iLetterForCodeId AS LetterForCodeId, dbo.uf_com_GetServerDate() AS Date, '' AS ToAddress1, '' AS ToAddress2, '' AS Subject, '' AS Contents, '' AS Signature, @sLetterForUserDesignation AS LetterForUserDesignation--, '' AS IsActive
					RETURN 0				
				END

				SELECT @inp_iTransactionLetterId AS TransactionLetterId, DisclosureTypeCodeId, LetterForCodeId, Date, ToAddress1, ToAddress2, Subject, Contents, Signature, @sLetterForUserDesignation AS LetterForUserDesignation,IsActive
				FROM tra_TemplateMaster 
				WHERE DisclosureTypeCodeId = @inp_iDisclosureTypeCodeId 
					AND LetterForCodeId = @inp_iLetterForCodeId
					AND CommunicationModeCodeId = @inp_iCommunicationModeCodeId	
			END
		END
		
		ELSE
		BEGIN
			SELECT TL.TransactionLetterId, TL.TransactionMasterId, TM.DisclosureTypeCodeId, 
			TL.LetterForCodeId, TL.Date, TL.ToAddress1, TL.ToAddress2, TL.Subject, TL.Contents, TL.Signature, @sLetterForUserDesignation AS LetterForUserDesignation, TP.IsActive
			FROM tra_TransactionLetter TL,tra_TransactionMaster TM, tra_TemplateMaster TP
			WHERE TL.TransactionMasterId = TM.TransactionMasterId
			AND TL.LetterForCodeId = TP.LetterForCodeId AND TP.DisclosureTypeCodeId = TM.DisclosureTypeCodeId
			AND TL.TransactionLetterId = @inp_iTransactionLetterId
		END
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRANSACTIONLETTERDETAILS_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END
GO