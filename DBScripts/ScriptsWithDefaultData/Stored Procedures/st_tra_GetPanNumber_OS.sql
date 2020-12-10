/*
	Created By  :	Shubhangi Gurude
	Created On  :   26-FEB-2019
	Description :	This stored Procedure is used to get Pan and Date Of Acquisition for Other Securities
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetPanNumber_OS')
	DROP PROCEDURE st_tra_GetPanNumber_OS
GO

CREATE PROCEDURE [dbo].[st_tra_GetPanNumber_OS] --251
	 @inp_iTransactionMasterId			INT							
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_GETDETAILS INT = 50440 -- Error occurred while fetching code details.	
		
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
		
		
		SELECT 
			UI.PAN,
			CASE WHEN TD.DateOfAcquisition IS NULL THEN UPPER(REPLACE(CONVERT(NVARCHAR, GETDATE(), 106), ' ', '/')) 
			ELSE UPPER(REPLACE(CONVERT(NVARCHAR, MAX(DateOfAcquisition), 106), ' ', '/')) END AS DateOfAcquisition,
			UPPER(REPLACE(CONVERT(NVARCHAR, dbo.uf_com_GetServerDate(), 106), ' ', '/')) AS DateOfIntimation
		FROM 
			tra_TransactionMaster_OS TM
			LEFT JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId=TD.TransactionMasterId
			JOIN usr_UserInfo UI ON TM.UserInfoId=UI.UserInfoId
		WHERE 
			TM.TransactionMasterId=@inp_iTransactionMasterId
		GROUP BY 
			UI.PAN,TD.DateOfAcquisition
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END



