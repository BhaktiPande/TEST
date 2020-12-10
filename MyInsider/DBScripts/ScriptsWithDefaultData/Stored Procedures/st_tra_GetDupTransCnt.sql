/*
	Created By  :	Shubhangi Gurude
	Created On  :   06-MAR-2018
	Description :	This stored Procedure is used to get duplicate transaction records exists in System	
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetDupTransCnt')
	DROP PROCEDURE st_tra_GetDupTransCnt
GO

CREATE PROCEDURE [dbo].[st_tra_GetDupTransCnt] 
	 @inp_iUserInfoId			INT							
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
		
		SELECT SecurityTypeCodeIdCnt,TransactionTypeCodeIdCnt,DateOfAcquisitionCnt 
		FROM
		(		
			(SELECT DISTINCT			
				TD.SecurityTypeCodeId,TD.TransactionTypeCodeId,TD.DateOfAcquisition,TM.UserInfoId,TM.TransactionStatusCodeId
			FROM
				tra_TransactionDetails TD join tra_TransactionMaster TM
		    ON 
				TD.TransactionMasterId=TM.TransactionMasterId 
			WHERE 
				TM.TransactionStatusCodeId=148002  AND TM.UserInfoId=@inp_iUserInfoId ) PendTrans		
		JOIN		
			(SELECT 
				COUNT(TD.SecurityTypeCodeId) AS SecurityTypeCodeIdCnt,COUNT(TD.TransactionTypeCodeId) AS TransactionTypeCodeIdCnt,COUNT(TD.DateOfAcquisition) AS DateOfAcquisitionCnt,
				TD.SecurityTypeCodeId,TD.TransactionTypeCodeId,TD.DateOfAcquisition,TM.UserInfoId
			FROM
				tra_TransactionDetails TD JOIN tra_TransactionMaster TM
			ON 
				TD.TransactionMasterId=TM.TransactionMasterId    
			GROUP BY 
				TD.SecurityTypeCodeId,TD.TransactionTypeCodeId,TD.DateOfAcquisition,TM.UserInfoId
			HAVING 
				COUNT(TD.SecurityTypeCodeId)>1 AND COUNT(TD.TransactionTypeCodeId)>1 AND COUNT(TD.DateOfAcquisition)>1 AND TM.UserInfoId=@inp_iUserInfoId)  DupTrans
				
		ON 
			PendTrans.SecurityTypeCodeId=DupTrans.SecurityTypeCodeId AND PendTrans.TransactionTypeCodeId=DupTrans.TransactionTypeCodeId AND PendTrans.DateOfAcquisition=DupTrans.DateOfAcquisition			 
		)
		
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



