/*
	Created By  :	Shubhangi Gurude
	Created On  :   15-NOV-2017
	Description :	This stored Procedure is used to get pending CD Transactions DURING PE	
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetContDisStatus')
	DROP PROCEDURE st_tra_GetContDisStatus
GO

CREATE PROCEDURE [dbo].[st_tra_GetContDisStatus] 
	 @inp_iUserInfoId			INT							
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_GROUPVALUES_GETDETAILS INT = 50440 -- Error occurred while fetching code details.
	DECLARE @ERR_GROUPVALUES_NOTFOUND INT = 50435 -- Group details does not exist
	
	--Declare Constant Variable
		DECLARE @nContDisStatusType										INT,
			    @nDisclosureTypeCodeId									INT,
			    @nContDisHardCopyStatusType								INT,
			    @nPreRejected											INT
	
		SET @nContDisStatusType											=148003
		SET @nContDisHardCopyStatusType									=148006
		SET @nDisclosureTypeCodeId										=147003	
		SET @nPreRejected												=144003
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
				COUNT(TM.TransactionMasterId) as ContDisPendingStatus	
			FROM 
				tra_TransactionMaster TM	  		
			WHERE 
				TM.TransactionStatusCodeId NOT IN(@nContDisStatusType,@nContDisHardCopyStatusType) AND TM.UserInfoId=@inp_iUserInfoId AND TM.DisclosureTypeCodeId<>@nDisclosureTypeCodeId
				and TM.PreclearanceRequestId not in(select PreclearanceRequestId from tra_PreclearanceRequest where UserInfoId=@inp_iUserInfoId and PreclearanceStatusCodeId in(@nPreRejected))
				and TM.PreclearanceRequestId not in(select PreclearanceRequestId from tra_PreclearanceRequest where UserInfoId=@inp_iUserInfoId and ReasonForNotTradingCodeId is not null)
			 
	SET @out_nReturnValue = 0
	RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_GROUPVALUES_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END



