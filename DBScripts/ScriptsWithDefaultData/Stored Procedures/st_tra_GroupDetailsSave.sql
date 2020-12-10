-- ======================================================================================================
-- Author      : Shubhangi Gurude,Tushar Wakchaure												=
-- CREATED DATE: 04-Feb-2017                                                 							=
-- Description : SCRIPT used for Group Creation  												=
-- ======================================================================================================

IF OBJECT_ID ('dbo.st_tra_GroupDetailsSave') IS NOT NULL
	DROP PROCEDURE dbo.st_tra_GroupDetailsSave
GO

CREATE PROCEDURE [dbo].[st_tra_GroupDetailsSave] 

	 @GroupId INT 
	,@UserInfoId INT
	,@TransactionMasterId INT
	,@inp_iLoggedInUserId INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred. 
		
AS
BEGIN

	DECLARE @ERR_GROUPDETAILVALUES_SAVE INT
	DECLARE @ERR_GROUPDETAILVALUES_NOTFOUND INT

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
		SELECT	@ERR_GROUPDETAILVALUES_NOTFOUND = 50437, -- Group details does not exist.
				@ERR_GROUPDETAILVALUES_SAVE = 50438 -- Error occurred while saving group details
		 
		 
		IF @GroupId IS NOT NULL OR @GroupId != 0
		BEGIN
			INSERT INTO tra_NSEGroupDetails(GroupId,UserInfoId,TransactionMasterId,
			CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)

			VALUES(@GroupId,@UserInfoId,@TransactionMasterId,
			@inp_iLoggedInUserId,dbo.uf_com_GetServerDate(),
			@inp_iLoggedInUserId,dbo.uf_com_GetServerDate())  
			SELECT DISTINCT(SCOPE_IDENTITY()) AS NSEGroupDetailsId FROM tra_NSEGroupDetails		
		
		END
	   
				
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	TRY

	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_GROUPDETAILVALUES_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
END CATCH
END
GO
