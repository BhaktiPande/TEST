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
	,@inp_dtEndDate		DATETIME						
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
			    @nPreRejected											INT,
			    @nPendingTransType										INT,
			    @nContinousDisclosureType								INT
			    
	
		SET @nContDisStatusType											=148003
		SET @nContDisHardCopyStatusType									=148006
		SET @nDisclosureTypeCodeId										=147003	
		SET @nPreRejected												=144003
		SET @nPendingTransType											=148002
		SET	@nContinousDisclosureType									=147002
		
		
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
		
			/*
			Delete PNT transaction not added in transaction details
			*/
			DELETE TM
			FROM tra_TransactionMaster TM LEFT JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
			LEFT JOIN com_DocumentObjectMapping DOM ON DOM.MapToId = TM.TransactionMasterId AND PurposeCodeId = 133003 AND MapToTypeCodeId = 132005
			WHERE DisclosureTypeCodeId = @nContinousDisclosureType AND TransactionStatusCodeId = @nPendingTransType 
			AND PreclearanceRequestId IS NULL AND TD.TransactionMasterId IS NULL AND DOM.DocumentObjectMapId IS NULL
			
			SELECT sum(tmpPendingTrans.ContDisPendingStatus) as ContDisPendingStatus
			FROM
			(			
			SELECT 
				COUNT(TM.TransactionMasterId) as ContDisPendingStatus	
			FROM 
				tra_TransactionMaster TM 
			JOIN
				tra_TransactionDetails TD ON TM.TransactionMasterId=TD.TransactionMasterId	  		
			WHERE 
				TM.TransactionStatusCodeId NOT IN(@nContDisStatusType,@nContDisHardCopyStatusType) AND TM.UserInfoId=@inp_iUserInfoId
				AND TM.DisclosureTypeCodeId<>@nDisclosureTypeCodeId	AND TD.DateOfAcquisition<=@inp_dtEndDate
				AND PreclearanceRequestId IS NULL AND TM.PeriodEndDate=@inp_dtEndDate

			UNION

			SELECT 
				COUNT(TM.TransactionMasterId) as ContDisPendingStatus	
			FROM 
				tra_TransactionMaster TM join tra_TransactionDetails TD ON TM.TransactionMasterId=TD.TransactionMasterId	  		
			WHERE 
				TM.TransactionStatusCodeId NOT IN(@nContDisStatusType,@nContDisHardCopyStatusType) AND TM.UserInfoId=@inp_iUserInfoId 
				AND TM.DisclosureTypeCodeId<>@nDisclosureTypeCodeId
				AND TM.PreclearanceRequestId NOT IN(select PreclearanceRequestId from tra_PreclearanceRequest where UserInfoId=@inp_iUserInfoId and PreclearanceStatusCodeId IN(@nPreRejected))
				AND TM.PreclearanceRequestId NOT IN(select PreclearanceRequestId from tra_PreclearanceRequest where UserInfoId=@inp_iUserInfoId and ReasonForNotTradingCodeId IS NOT NULL)
				AND TD.DateOfAcquisition<=@inp_dtEndDate
				AND TM.PreclearanceRequestId IS NOT NULL AND TM.PeriodEndDate=@inp_dtEndDate
			)	tmpPendingTrans		
			 
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



