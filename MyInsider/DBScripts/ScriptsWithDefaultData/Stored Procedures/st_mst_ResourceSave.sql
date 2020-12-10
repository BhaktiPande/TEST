IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_mst_ResourceSave')
DROP PROCEDURE [dbo].[st_mst_ResourceSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the Resource details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		05-Mar-2015
Modification History:
Modified By		Modified On			Description
Tushar			11-Mar-2015			Changes for Grid Header Category then is visible and sequence number input
Tushar			04-Jun-2015			Add Column ColumnAlignment,ColumnWidth for save
Amar			29-Jul-2015			Changes for override gridtypcodeid and resourcekey to save changes to respective columns when these columns are not null

Usage:
DECLARE @RC int
EXEC st_mst_ResourceSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_mst_ResourceSave] 
	@inp_sResourceKey				VARCHAR(15),
	@inp_sResourceValue				NVARCHAR(2000),
	@inp_bIsVisible					BIT,
	@inp_nSequenceNumber			INT,
	@inp_nColumnWidth				INT,
	@inp_nColumnAlignment			INT,
	@out_nReturnValue				INT = 0				OUTPUT,
	@out_nSQLErrCode				INT = 0				OUTPUT,	-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = ''	OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_RESOURCE_SAVE INT
	DECLARE @ERR_RESOURCE_NOTFOUND INT
	DECLARE @NGRID_CATEGORY INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		SET @NGRID_CATEGORY = 104003
		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Initialize variables
		SELECT	@ERR_RESOURCE_NOTFOUND = 10026, -- Resource does not exist.
				@ERR_RESOURCE_SAVE = 10027 -- Error occurred while saving resource details.

		--Check if the Resource whose details are being updated exists
		IF (NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceKey = @inp_sResourceKey))	
		BEGIN		
			SET @out_nReturnValue = @ERR_RESOURCE_NOTFOUND
			RETURN (@out_nReturnValue)
		END
	
		UPDATE mst_Resource
		SET ResourceValue = @inp_sResourceValue
		WHERE ResourceKey = @inp_sResourceKey
		
		IF(EXISTS(SELECT ResourceKey FROM mst_Resource WHERE ResourceKey = @inp_sResourceKey AND CategoryCodeId =  @NGRID_CATEGORY))
		BEGIN
			IF (EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE ResourceKey = @inp_sResourceKey AND OverrideResourceKey IS NULL))
			BEGIN
				UPDATE com_GridHeaderSetting
				SET	IsVisible = @inp_bIsVisible,
					SequenceNumber = @inp_nSequenceNumber,
					ColumnWidth = @inp_nColumnWidth,
					ColumnAlignment = @inp_nColumnAlignment
				WHERE ResourceKey = @inp_sResourceKey AND OverrideResourceKey IS NULL
			END
			ELSE IF (EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE  OverrideResourceKey = @inp_sResourceKey ))
			BEGIN
				UPDATE com_GridHeaderSetting
				SET	IsVisible = @inp_bIsVisible,
					SequenceNumber = @inp_nSequenceNumber,
					ColumnWidth = @inp_nColumnWidth,
					ColumnAlignment = @inp_nColumnAlignment
				WHERE OverrideResourceKey = @inp_sResourceKey
			END
		END

		-- in case required to return for partial save case.
		SELECT ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue 
		FROM mst_Resource
		WHERE ResourceKey = @inp_sResourceKey
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_RESOURCE_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END