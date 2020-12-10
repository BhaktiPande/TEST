IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GenerateFormDetails')
DROP PROCEDURE [dbo].[st_tra_GenerateFormDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	save formatted Form E for preclearance

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		12-Sep-2016

Modification History:
Modified By		Modified On		Description
Raghvendra		20-Sep-2-16		Changing to a wrapper procedure and creating new inbound procedures - st_tra_GenerateFormDetails_ImplementingCompany, st_tra_GenerateFormDetails_NonImplementingCompany 		

Usage:
EXEC st_tra_GenerateFormDetails <MapToTypeId> <MapToId> <LoggedInUserId>
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_GenerateFormDetails] 
	@inp_nMapToTypeCodeId					INT,
	@inp_nMapToId							INT,	--Id of Preclearance for which Form E is to be generated
	@inp_nLoggedInUserId					INT,	-- Id of the user inserting the Form E contents
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT

AS
BEGIN
	DECLARE @ERR_FORM_GENERATION_FAIL INT = 17458 -- Error occurred while generating form E details

	DECLARE @nMapTypePreclearance_ImplementingCompany INT = 132004	--MapToTypeId for type Preclearance
	DECLARE @nMapTypePreclearance_NonImplementingCompany INT = 132015	--MapToTypeId for type Preclearance of NonImplementing Company
	
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
		
		SET @out_nReturnValue = 0

		IF(@inp_nMapToTypeCodeId = @nMapTypePreclearance_ImplementingCompany) --Perform processing for generation of formatted Form E for Implementing company
		BEGIN
			EXEC @out_nReturnValue = st_tra_GenerateFormDetails_ImplementingCompany @inp_nMapToTypeCodeId, @inp_nMapToId, @inp_nLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT ,@out_sSQLErrMessage OUTPUT
		END --End of IF(@inp_nMapToTypeCodeId = @nMapTypePreclearance_ImplementingCompany)
		ELSE IF(@inp_nMapToTypeCodeId = @nMapTypePreclearance_NonImplementingCompany) --Perform processing for generation of formatted Form E for NonImplementing company
		BEGIN
			EXEC @out_nReturnValue = st_tra_GenerateFormDetails_NonImplementingCompany @inp_nMapToTypeCodeId, @inp_nMapToId, @inp_nLoggedInUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT ,@out_sSQLErrMessage OUTPUT
		END --End of IF(@inp_nMapToTypeCodeId = @nMapTypePreclearance_ImplementingCompany)

		RETURN @out_nReturnValue
	END	 TRY
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_FORM_GENERATION_FAIL, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END