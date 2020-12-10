IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_mst_ResourceDetails')
DROP PROCEDURE [dbo].[st_mst_ResourceDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the Resource details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		04-Mar-2015

Modification History:
Modified By		Modified On			Description
Tushar			11-Mar-2015			Changes for Grid Header Category then is visible and sequence number input
Tushar			04-Jun-2015			Return Column ColumnAlignment,ColumnWidth
Amar			29-Jul-2015         changes for OverrideGridTypeCodeId and resourcekey to display the value from override columns if not null.

Usage:
EXEC st_mst_ResourceDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_mst_ResourceDetails]
	@inp_sResourceKey		VARCHAR(15),							-- Id of the Resource whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_RESOURCE_GETDETAILS INT
	DECLARE @ERR_RESOURCE_NOTFOUND INT

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
		SELECT	@ERR_RESOURCE_NOTFOUND = 10026, -- Resource does not exist
				@ERR_RESOURCE_GETDETAILS = 10025 -- Error occurred while fetching resource details.

		--Check if the Resource whose details are being fetched exists
		IF (NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceKey = @inp_sResourceKey))
		BEGIN
				SET @out_nReturnValue = @ERR_RESOURCE_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the Resource details
		SELECT ResourceId, R.ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, 
			   CategoryCodeId, ScreenCodeId, OriginalResourceValue,ModuleCode.CodeName AS ModuleCodeName,
			   Categorycode.CodeName AS CategoryCodeName,ScreenCode.CodeName AS ScreenName,
			   GHS.GridTypeCodeId,GridTypeCode.CodeName AS GridHeaderListName,GHS.IsVisible,GHS.SequenceNumber,
			   GHS.ColumnAlignment,GHS.ColumnWidth, GHS.OverrideGridTypeCodeId
		FROM mst_Resource R
		JOIN com_Code ModuleCode ON R.ModuleCodeId = ModuleCode.CodeID
		JOIN com_Code Categorycode ON R.CategoryCodeId = Categorycode.CodeID
		JOIN com_Code ScreenCode ON R.ScreenCodeId = ScreenCode.CodeID
		LEFT JOIN com_GridHeaderSetting GHS ON 
		  ((R.ResourceKey = GHS.ResourceKey and GHS.OverrideResourceKey IS NULL)  or
		  (R.ResourceKey = GHS.OverrideResourceKey and GHS.OverrideResourceKey IS NOT NULL))
    	LEFT JOIN com_Code GridTypeCode ON 
		  (( GHS.GridTypeCodeId = GridTypeCode.CodeID and  GHS.OverrideGridTypeCodeId = 0) or
		  ( GHS.OverrideGridTypeCodeId = GridTypeCode.CodeID and  GHS.OverrideGridTypeCodeId > 0))
		WHERE R.ResourceKey = @inp_sResourceKey ;
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_RESOURCE_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

