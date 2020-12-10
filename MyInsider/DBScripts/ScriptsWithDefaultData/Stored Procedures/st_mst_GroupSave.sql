-- ======================================================================================================
-- Author      : Shubhangi Gurude,Tushar Wakchaure												=
-- CREATED DATE: 04-Feb-2017                                                 							=
-- Description : SCRIPT used for Group Creation  												=
-- ======================================================================================================
IF OBJECT_ID ('dbo.st_mst_GroupSave') IS NOT NULL
	DROP PROCEDURE dbo.st_mst_GroupSave
GO

CREATE PROCEDURE [dbo].[st_mst_GroupSave] 

	@GroupId INT OUTPUT,
	@DownloadedDate DATETIME,
	@SubmissionDate DATETIME,
	@StatusCodeId INT,
	@TypeOfDownload INT,
	@DownloadStatus BIT,
	@inp_iLoggedInUserId INT,
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred. 
		
AS
BEGIN

	DECLARE @ERR_GROUPVALUE_SAVE INT
	DECLARE @ERR_GROUPVALUE_NOTFOUND INT

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
		SELECT	@ERR_GROUPVALUE_NOTFOUND = 50435, -- Group value does not exist.
				@ERR_GROUPVALUE_SAVE = 50436 -- Error occurred while Group master creation.

		--Save the CompanyFaceValue details
		IF @GroupId IS NULL OR @GroupId = 0
		BEGIN
			INSERT INTO tra_NSEGroup(DownloadedDate,SubmissionDate,
			StatusCodeId,TypeOfDownload,
			DownloadStatus,CreatedBy,
			CreatedOn,ModifiedBy,ModifiedOn)

			VALUES(@DownloadedDate,@SubmissionDate,
			@StatusCodeId,@TypeOfDownload,
			@DownloadStatus,@inp_iLoggedInUserId,
			dbo.uf_com_GetServerDate(),@inp_iLoggedInUserId,dbo.uf_com_GetServerDate())
			
			SELECT DISTINCT(SCOPE_IDENTITY()) AS GroupId FROM tra_NSEGroup
		
		END
		ELSE
		BEGIN
			--Check if the CompanyFaceValue whose details are being updated exists
			IF (NOT EXISTS(SELECT GroupId FROM tra_NSEGroup WHERE GroupId = @GroupId))
			BEGIN			
				SET @out_nReturnValue = @ERR_GROUPVALUE_NOTFOUND
				RETURN (@out_nReturnValue)
			END
	
			
			UPDATE tra_NSEGroup
			SET SubmissionDate=@SubmissionDate
			,StatusCodeId=@StatusCodeId
			,TypeOfDownload=@TypeOfDownload
			,DownloadStatus=@DownloadStatus
			,ModifiedBy=@inp_iLoggedInUserId
			,ModifiedOn=dbo.uf_com_GetServerDate()
			WHERE GroupId=@GroupId
					
		END
				
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY

	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_GROUPVALUE_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
END CATCH
END
GO
