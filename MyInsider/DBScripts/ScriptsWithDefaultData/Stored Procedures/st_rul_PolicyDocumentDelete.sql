IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_PolicyDocumentDelete')
DROP PROCEDURE [dbo].[st_rul_PolicyDocumentDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Marks the Policy document identified by input ID as Deleted.

Returns:		0, if Success.
				
Created by:		Ashashree
Created on:		5-Apr-2015

Modification History:
Modified By		Modified On			Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.


Usage:
DECLARE @RC int
EXEC st_rul_PolicyDocumentDelete 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_PolicyDocumentDelete]
	-- Add the parameters for the stored procedure here
	@inp_iPolicyDocumentId		INT,							-- Id of the PolicyDocument which is to be deleted.
	@inp_nUserId				INT ,							-- Id of user marking the policy document as deleted.	
	@out_nReturnValue			INT = 0 OUTPUT,		
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_POLICYDOCUMENT_NOTFOUND INT
	DECLARE @ERR_POLICYDOCUMENT_DELETE INT
	DECLARE @ERR_POLICYDOCUMENT_DELETE_ACTIVE_POLICY	INT

	DECLARE @dtCurrentDate	DATETIME
	DECLARE	@dtAppFromDate	DATETIME
	DECLARE	@dtAppToDate	DATETIME
	DECLARE @nExistingWindowStatusCodeId INT
	DECLARE @nPolicyDocumentActive		INT
	
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
				@ERR_POLICYDOCUMENT_DELETE = 15100,		--Error occurred while deleting policy document.
				@ERR_POLICYDOCUMENT_DELETE_ACTIVE_POLICY = 15101,	--Cannot delete policy document because it is active with ongoing applicable date range
				
				@nPolicyDocumentActive = 131002
	
		--Check if the Policy Document being deleted exists
		IF (NOT EXISTS(SELECT PolicyDocumentId FROM rul_PolicyDocument WHERE PolicyDocumentId = @inp_iPolicyDocumentId))
		BEGIN	
				SET @out_nReturnValue = @ERR_POLICYDOCUMENT_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Validate date and then mark as deleted if deletion is possible for applicable date range and current date
		--Fetch the current date of database server 
		SELECT @dtCurrentDate = dbo.uf_com_GetServerDate()
		SELECT @dtCurrentDate = CAST( CAST(@dtCurrentDate AS VARCHAR(11)) AS DATETIME ) --get only the date part and not the timestamp part
		print @dtCurrentDate
		
		--Fetch applicable dates and window status of policy document to compare the dates with current date and delete conditionally
		SELECT @dtAppFromDate = ApplicableFrom, @dtAppToDate = ApplicableTo, @nExistingWindowStatusCodeId = WindowStatusCodeId
		FROM rul_PolicyDocument
		WHERE PolicyDocumentId = @inp_iPolicyDocumentId
	
		IF( (@dtCurrentDate < @dtAppFromDate AND @dtAppFromDate <= @dtAppToDate) OR 
			(@dtCurrentDate > @dtAppToDate AND @dtAppFromDate <= @dtAppToDate) )
		BEGIN
			--If current date < applicable from-to dates OR current date > applicable to-date then policy can be marked deleted when window status is Incomplete/Active/Inactive
			UPDATE rul_PolicyDocument
			SET IsDeleted = 1, ModifiedBy = @inp_nUserId, ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE PolicyDocumentId = @inp_iPolicyDocumentId
		END 
		ELSE IF(@dtAppFromDate <= @dtCurrentDate AND @dtCurrentDate <= @dtAppToDate AND @dtAppFromDate <= @dtAppToDate)
		BEGIN
			IF(@nExistingWindowStatusCodeId = @nPolicyDocumentActive)	--Active policy cannot be marked as Deleted if current date between policy applicable dates
			BEGIN
				SET @out_nReturnValue = @ERR_POLICYDOCUMENT_DELETE_ACTIVE_POLICY
				RETURN (@out_nReturnValue)
			END
			--If current date between applicable dates then policy can be marked deleted only when window status is Incomplete/Inactive
			UPDATE rul_PolicyDocument
			SET IsDeleted = 1, ModifiedBy = @inp_nUserId, ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE PolicyDocumentId = @inp_iPolicyDocumentId
		END

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_POLICYDOCUMENT_DELETE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
