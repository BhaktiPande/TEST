IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyFaceValueDetails')
DROP PROCEDURE [dbo].[st_com_CompanyFaceValueDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the CompanyFaceValue details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		18-Feb-2015

Modification History:
Modified By		Modified On	Description

Usage:
EXEC st_com_CompanyFaceValueDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanyFaceValueDetails]
	@inp_iCompanyFaceValueID			INT,							-- Id of the CompanyFaceValue whose details are to be fetched.
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_COMPANYFACEVALUE_GETDETAILS INT
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
				@ERR_COMPANYFACEVALUE_GETDETAILS = 13037 -- Error occurred while fetching face value details for a company.

		--Check if the CompanyFaceValue whose details are being fetched exists
		IF (NOT EXISTS(SELECT CompanyFaceValueID FROM com_CompanyFaceValue WHERE CompanyFaceValueID = @inp_iCompanyFaceValueID))
		BEGIN
				SET @out_nReturnValue = @ERR_COMPANYFACEVALUE_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the CompanyFaceValue details
		SELECT CompanyFaceValueID,C.CompanyID,C.CompanyName,FaceValueDate, FaceValue, CurrencyID,code.CodeName AS CurrencyName 
		FROM com_CompanyFaceValue CFV
		INNER JOIN mst_Company C ON CFV.CompanyID = C.CompanyId
		INNER JOIN com_Code code ON CFV.CurrencyID = code.CodeID
		WHERE CompanyFaceValueID = @inp_iCompanyFaceValueID
		
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_COMPANYFACEVALUE_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

