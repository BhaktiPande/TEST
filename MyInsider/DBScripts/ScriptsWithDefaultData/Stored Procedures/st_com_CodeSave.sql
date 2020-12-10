IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CodeSave')
DROP PROCEDURE [dbo].[st_com_CodeSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the Code details

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		16-Feb-2015
Modification History:
Modified By		Modified On		Description
Swapnil			05-mar-2015		change in ParentCodeid to null if is is zero
Gaurishankar	07-Jul-2015		Added UNIQUE check for Display Code name
Gaurishankar	07-Dec-2015		Added IsActive field is select query and Set @inp_iCodeID as newly created CodeId
Raghvendra		07-Mar-2016		Change to allow define code with 5 characters long i.e. upto 99999
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Raghvendra		20-Sep-2016		Change to increase the DisplayCode column size from 50 to 1000

Usage:
DECLARE @RC int
EXEC st_com_CodeSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CodeSave] 
	@inp_iCodeID		INT,
	@inp_sCodeName		NVARCHAR(1024),
	@inp_iCodeGroupId	INT,
	@inp_sDescription	NVARCHAR(510),
	@inp_bIsVisible		bit,
	@inp_bIsActive		bit,
	@inp_sDisplayCode	NVARCHAR(1000),
	@inp_iParentCodeId  INT,
	@inp_nUserId INT,									-- Id of the user inserting/updating the Code
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_CODE_SAVE	   INT = 10008 -- Error occurred while saving code.
	DECLARE @ERR_CODE_NOTFOUND INT = 10009 -- Code does not exist
	DECLARE @ERR_CODE_NOTUNIQUE INT = 10010 -- Code name already exists
	DECLARE @ERR_DISPLAYCODE_NOTUNIQUE INT = 10051 -- Code name already exists
	DECLARE @CURRENTCODEID	   INT,
			@CURRENTDIS		   INT,
			@NEXTCODEID		   INT,
			@NEXTDIS		   INT
	DECLARE @STARTVALUE_FOR_CODE VARCHAR(10)
	DECLARE @CODEGROUP_FOR_DEPARTMENT INT = 110
	 
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
		--Change Done temporarily for DEPARTMENT Group i.e. 110
		IF (@inp_iCodeGroupId = @CODEGROUP_FOR_DEPARTMENT)
		BEGIN
			SELECT @STARTVALUE_FOR_CODE = '00001'
		END
		ELSE
		BEGIN
			SELECT @STARTVALUE_FOR_CODE = '001'
		END
				
		--Set CodeId and DisplayOrder
		SELECT @CURRENTCODEID = MAX(CodeID), @CURRENTDIS = MAX(DisplayOrder) FROM com_Code WHERE CodeGroupId = @inp_iCodeGroupId
		
		IF @CURRENTCODEID IS NOT NULL 		
			SET @NEXTCODEID = @CURRENTCODEID + 1	
		ELSE	
			SET @NEXTCODEID = Convert(varchar(20),@inp_iCodeGroupId) + @STARTVALUE_FOR_CODE
		
		
		IF @CURRENTDIS IS NOT NULL		
			SET @NEXTDIS = @CURRENTDIS + 1
		ELSE
			SET @NEXTDIS = Convert(varchar(20),@inp_iCodeGroupId) + @STARTVALUE_FOR_CODE
		
		IF @inp_iParentCodeId = 0
		BEGIN
			SET @inp_iParentCodeId = NULL
		END
		
		-- Check that the code name is unique within the group
		IF EXISTS (SELECT CodeID FROM com_Code 
					 WHERE CodeGroupId = @inp_iCodeGroupId AND CodeName = @inp_sCodeName
						AND (@inp_iCodeID = 0 OR CodeID <> @inp_iCodeID))
		BEGIN
			SELECT @out_nReturnValue = @ERR_CODE_NOTUNIQUE
			RETURN @out_nReturnValue
		END
		
		-- Check that the display code name is unique within the group
		IF EXISTS (SELECT CodeID FROM com_Code 
					 WHERE CodeGroupId = @inp_iCodeGroupId AND DisplayCode = @inp_sDisplayCode
						AND (@inp_iCodeID = 0 OR CodeID <> @inp_iCodeID))
		BEGIN
			SELECT @out_nReturnValue = @ERR_DISPLAYCODE_NOTUNIQUE
			RETURN @out_nReturnValue
		END
		--Save the Code details
		IF @inp_iCodeID = 0
		BEGIN
			Insert into com_Code(
					CodeID,
					CodeName,
					CodeGroupId,
					Description,
					IsVisible,
					IsActive,	
					DisplayOrder,
					DisplayCode,
					ParentCodeId,				
					ModifiedBy, ModifiedOn )
			Values (
					@NEXTCODEID,
					@inp_sCodeName,
					@inp_iCodeGroupId,
					@inp_sDescription,
					@inp_bIsVisible,
					@inp_bIsActive,
					@NEXTDIS,
					@inp_sDisplayCode,
					@inp_iParentCodeId,
					@inp_nUserId, dbo.uf_com_GetServerDate() )
					
			SET @inp_iCodeID = @NEXTCODEID
		END
		ELSE
		BEGIN
			--Check if the Code whose details are being updated exists
			IF (NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = @inp_iCodeID))
			BEGIN			
				SET @out_nReturnValue = @ERR_CODE_NOTFOUND
				RETURN (@out_nReturnValue)
			END
	
			Update com_Code
			Set 	CodeName = @inp_sCodeName,					
					Description = @inp_sDescription,
					IsVisible = @inp_bIsVisible,
					IsActive = @inp_bIsActive,
					DisplayCode = @inp_sDisplayCode,					
					ModifiedBy	= @inp_nUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()

			Where CodeID = @inp_iCodeID	
			
		END
		
		-- in case required to return for partial save case.
		Select CodeID, CodeName, CodeGroupId, Description, IsVisible,IsActive, DisplayOrder, DisplayCode, ParentCodeId
		From com_Code
		Where CodeID = @inp_iCodeID
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_CODE_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH

END