
/*
	Created By  :	Shubhangi Gurude
	Created On  :   15-NOV-2017
	Description :	This stored Procedure is used to get CD Transaction Id DURING PE	
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetCDTransIdduringPE')
	DROP PROCEDURE st_tra_GetCDTransIdduringPE
GO
CREATE PROCEDURE [dbo].[st_tra_GetCDTransIdduringPE] 
   	 @inp_iUserInfoId				INT
	,@inp_sCDDuringPE				BIT	
	,@inp_dPeriodEndDate			DATETIME
	,@inp_iTransactionMasterId		INT							
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_GROUPVALUES_GETDETAILS INT = 50440 -- Error occurred while fetching code details.
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
			
	   SELECT TransactionMasterId FROM tra_TransactionMaster 
	   WHERE PeriodEndDate=convert(DATE,@inp_dPeriodEndDate,103)
	   AND CDDuringPE=@inp_sCDDuringPE AND UserInfoId=@inp_iUserInfoId
	   AND TransactionMasterId=@inp_iTransactionMasterId
	   	   
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_GROUPVALUES_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END
