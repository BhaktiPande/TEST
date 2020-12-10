IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_PolicyDocumentDetails')
DROP PROCEDURE [dbo].[st_rul_PolicyDocumentDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the PolicyDocument details

Returns:		0, if Success.
				
Created by:		Ashashree
Created on:		26-Mar-2015

Modification History:
Modified By		Modified On	Description
Parag			10-Apr-2015		Made change to fetch values for code ie company, category, subcategory by adding join on related table
Parag			30-Apr-2015		Made change to add CASE condition to fetch display code or code name from com_Code table
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_rul_PolicyDocumentDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_PolicyDocumentDetails]
	@inp_iPolicyDocumentId INT,							-- Id of the PolicyDocument whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_POLICYDOCUMENT_GETDETAILS INT
	DECLARE @ERR_POLICYDOCUMENT_NOTFOUND INT
	DECLARE @dtCurrentDate			DATETIME

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
		SELECT	@ERR_POLICYDOCUMENT_NOTFOUND = 15043, --Policy document does not exist.
				@ERR_POLICYDOCUMENT_GETDETAILS = 15042 --Error occurred while fetching policy document details.

		--Check if the PolicyDocument whose details are being fetched exists
		IF (NOT EXISTS(SELECT PolicyDocumentId FROM rul_PolicyDocument WHERE PolicyDocumentId = @inp_iPolicyDocumentId))
		BEGIN	
				SET @out_nReturnValue = @ERR_POLICYDOCUMENT_NOTFOUND
				RETURN (@out_nReturnValue)
		END
		
		--Fetch the current date of database server 
		SELECT @dtCurrentDate = dbo.uf_com_GetServerDate()
		SELECT @dtCurrentDate = CAST( CAST(@dtCurrentDate AS VARCHAR(11)) AS DATETIME ) --get only the date part and not the timestamp part
		print @dtCurrentDate
		--Fetch the PolicyDocument details
		SELECT PolicyDocumentId, PolicyDocumentName, DocumentCategoryCodeId, DocumentSubCategoryCodeId, 
			   ApplicableFrom, ApplicableTo, PD.CompanyId, DisplayInPolicyDocumentFlag, SendEmailUpdateFlag, 
			   DocumentViewFlag, DocumentViewAgreeFlag, WindowStatusCodeId, @dtCurrentDate AS DBCurrentDate, 
			   (CASE WHEN CdPDCategory.DisplayCode IS NULL OR CdPDCategory.DisplayCode = '' THEN CdPDCategory.CodeName ELSE CdPDCategory.DisplayCode END) as DocumentCategoryName, 
			   (CASE WHEN CdPDSubCategory.DisplayCode IS NULL OR CdPDSubCategory.DisplayCode = '' THEN CdPDSubCategory.CodeName ELSE CdPDSubCategory.DisplayCode END) as DocumentSubCategoryName, 
			   CompanyName
			FROM rul_PolicyDocument PD 
				LEFT JOIN com_Code CdPDCategory ON PD.DocumentCategoryCodeId = CdPDCategory.CodeID 
				LEFT JOIN com_Code CdPDSubCategory ON PD.DocumentSubCategoryCodeId = CdPDSubCategory.CodeID 
				LEFT JOIN mst_Company Company ON PD.CompanyId = Company.CompanyId
			WHERE PolicyDocumentId = @inp_iPolicyDocumentId
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_POLICYDOCUMENT_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

