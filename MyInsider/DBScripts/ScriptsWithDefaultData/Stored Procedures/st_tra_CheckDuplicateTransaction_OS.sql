IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_CheckDuplicateTransaction_OS')
DROP PROCEDURE [dbo].[st_tra_CheckDuplicateTransaction_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to check whether transactions are duplicate

Returns:		0, if Success.
				
Created by:		Tushar Wakchaure
Created on:		05-Mar-2019
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_CheckDuplicateTransaction_OS]
	@inp_iUserInfoId            INT
	,@inp_iDMATDetailsID        INT
	,@inp_iSecurityType         INT
	,@inp_iCompanyId            VARCHAR(250) 
	,@inp_iTransactionDetailsId INT
	,@out_nReturnValue		    INT = 0 OUTPUT
	,@out_nSQLErrCode		    INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage        NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
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

        IF @inp_iTransactionDetailsId <> 0
		BEGIN	
		  SELECT ForUserInfoId AS UserInfoID FROM tra_TransactionDetails_OS WHERE ForUserInfoId = @inp_iUserInfoId AND DMATDetailsID = @inp_iDMATDetailsID AND SecurityTypeCodeId = @inp_iSecurityType AND CompanyId =  @inp_iCompanyId AND TransactionDetailsId <> @inp_iTransactionDetailsId
		END
		ELSE
		BEGIN
		  SELECT ForUserInfoId AS UserInfoID FROM tra_TransactionDetails_OS WHERE ForUserInfoId = @inp_iUserInfoId AND DMATDetailsID = @inp_iDMATDetailsID AND SecurityTypeCodeId = @inp_iSecurityType AND CompanyId =  @inp_iCompanyId 
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  0
	END CATCH
END