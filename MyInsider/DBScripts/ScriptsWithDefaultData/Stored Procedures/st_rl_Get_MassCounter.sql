
IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rl_Get_MassCounter')
	DROP PROCEDURE st_rl_Get_MassCounter
GO
-- ======================================================================================================
-- Author      : GAURAV UGALE																			=
-- CREATED DATE: 27-JULY-2016                                                 							=
-- Description : THIS PROCEDURE USED TO GET MASSCOUNTER VALUE FOR DEPT WISE RL MASS UPLOAD   			=
-- ======================================================================================================

CREATE PROCEDURE [dbo].[st_rl_Get_MassCounter]
(
	@out_MassCounter			INT OUTPUT, 
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
)
AS 
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		SELECT @out_MassCounter = MAX(MassCounter) + 1  FROM rl_RistrictedMasterList 
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue		
	END TRY
	BEGIN CATCH
		SELECT 1
		SET @out_nReturnValue = ERROR_NUMBER()
		RETURN @out_nReturnValue
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue = @out_nSQLErrCode
	END CATCH
END