IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyFaceValueSave')
DROP PROCEDURE [dbo].[st_com_CompanyFaceValueSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the CompanyFaceValue details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		18-Feb-2015
Modification History:
Modified By		Modified On	Description
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_com_CompanyFaceValueSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanyFaceValueSave] 
	@inp_iCompanyFaceValueID		INT,
	@inp_iCompanyID					INT,
	@inp_dtFaceValueDate			DATETIME,
	@inp_sFaceValue					DECIMAL(15,4),
	@inp_iCurrencyID				INT,
	@inp_iLoggedInUserId			INT,				-- Id of the user inserting/updating the CompanyFaceValue
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_COMPANYFACEVALUE_SAVE INT
	DECLARE @ERR_COMPANYFACEVALUE_NOTFOUND INT

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
		SELECT	@ERR_COMPANYFACEVALUE_NOTFOUND = 13036, -- Face value details does not exist.
				@ERR_COMPANYFACEVALUE_SAVE = 13035 -- Error occurred while saving face value for a company.

		--Save the CompanyFaceValue details
		IF @inp_iCompanyFaceValueID IS NULL OR @inp_iCompanyFaceValueID = 0
		BEGIN
			INSERT INTO com_CompanyFaceValue(
					CompanyID,
					FaceValueDate,
					FaceValue,
					CurrencyID,
					CreatedBy, CreatedOn, ModifiedBy,	ModifiedOn )
			VALUES (
					@inp_iCompanyID,
					@inp_dtFaceValueDate,
					@inp_sFaceValue,
					@inp_iCurrencyID,
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate() )
		
			SET @inp_iCompanyFaceValueID = SCOPE_IDENTITY()
		
		END
		ELSE
		BEGIN
			--Check if the CompanyFaceValue whose details are being updated exists
			IF (NOT EXISTS(SELECT CompanyFaceValueID FROM com_CompanyFaceValue WHERE CompanyFaceValueID = @inp_iCompanyFaceValueID))
			BEGIN			
				SET @out_nReturnValue = @ERR_COMPANYFACEVALUE_NOTFOUND
				RETURN (@out_nReturnValue)
			END
	
			UPDATE com_CompanyFaceValue
			SET 	--CompanyID = @inp_iCompanyID,
					FaceValueDate = @inp_dtFaceValueDate,
					FaceValue = @inp_sFaceValue,
					CurrencyID = @inp_iCurrencyID,
					ModifiedBy	= @inp_iLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE CompanyFaceValueID = @inp_iCompanyFaceValueID	
			
		END
		
		-- in case required to return for partial save case.
		SELECT CompanyFaceValueID, CompanyID, FaceValueDate, FaceValue, CurrencyID
		FROM com_CompanyFaceValue
		WHERE CompanyFaceValueID = @inp_iCompanyFaceValueID
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY

	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_COMPANYFACEVALUE_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
END CATCH
END
