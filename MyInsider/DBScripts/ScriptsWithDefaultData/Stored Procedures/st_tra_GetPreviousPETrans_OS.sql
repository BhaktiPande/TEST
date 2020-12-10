/*
	Created By  :	Novitkumar magare
	Created On  :   14-Aug-2019
	Description :	This stored Procedure is used to get previous period end pending Transactions
	EXEC [dbo].[st_tra_GetPreviousPETrans_OS] 403,'2019-08-31 18:22:27.950'
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetPreviousPETrans_OS')
	DROP PROCEDURE st_tra_GetPreviousPETrans_OS
GO

CREATE PROCEDURE [dbo].[st_tra_GetPreviousPETrans_OS]
	 @inp_iUserInfoId			INT	
	,@inp_dtEndDate				DATETIME						
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_GROUPVALUES_GETDETAILS INT = 50440 -- Error occurred while fetching code details.
	DECLARE @ERR_GROUPVALUES_NOTFOUND INT = 50435 -- Group details does not exist
	
	--Declare Constant Variable
	DECLARE @nPendingTransType										INT,
		    @nDisclosureTypeCodeId									INT,
		    @nTransStatus_DocumentUploaded							INT,
		    @nPeriodEndEntered										INT,
		    @nContDisHardCopyStatusType								INT,
		    @nContDisStatusType										INT		   

	SET @nTransStatus_DocumentUploaded								=148001		
	SET @nDisclosureTypeCodeId										=147003		
	SET @nPendingTransType											=148002
	SET @nPeriodEndEntered											=153062
	SET @nContDisStatusType											=148003
	SET @nContDisHardCopyStatusType									=148006
	
	DECLARE @nRelativeCount INT
		
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

		SELECT @nRelativeCount = COUNT(UR.UserInfoIdRelative) FROM usr_UserRelation UR 
		JOIN usr_UserInfo URel ON URel.UserInfoId = UR.UserInfoIdRelative And CONVERT(date, URel.CreatedOn) < CONVERT(date, @inp_dtEndDate)
		WHERE UR.UserInfoId = @inp_iUserInfoId
		AND UR.UserInfoIdRelative NOT IN 
		(SELECT UR.UserInfoIdRelative FROM usr_UserInfo U
		JOIN usr_UserRelation UR ON UR.UserInfoId = U.UserInfoId
		LEFT JOIN tra_TransactionDetails_OS TD ON TD.ForUserInfoId = UR.UserInfoIdRelative
		LEFT JOIN tra_TransactionMaster_OS TM ON TM.TransactionMasterId = TD.TransactionMasterId
		WHERE U.UserInfoId = @inp_iUserInfoId AND TM.DisclosureTypeCodeId= 147001 AND TM.TransactionStatusCodeId = 148003)
		
		IF(@nRelativeCount = 0)
		BEGIN
			SELECT 
				SUM(traPendinTrans.PEDisPendingStatus) as PEDisPendingStatus 
			FROM
			(			
				SELECT 
					COUNT(TM.TransactionMasterId) AS PEDisPendingStatus FROM tra_TransactionMaster_OS TM 
				WHERE 
					TM.DisclosureTypeCodeId = @nDisclosureTypeCodeId 
					AND TM.TransactionStatusCodeId IN (@nTransStatus_DocumentUploaded, @nPendingTransType) 
					AND CONVERT(date, TM.PeriodEndDate) < CONVERT(date, @inp_dtEndDate)
					AND TM.UserInfoId = @inp_iUserInfoId								
				 UNION				  
				 SELECT 
					 COUNT(TM.TransactionMasterId) as PEDisPendingStatus	
				 FROM 
					 tra_TransactionMaster_OS TM	join eve_EventLog EL
				 ON 
					 TM.TransactionMasterId=EL.MapToId AND TM.UserInfoId=EL.UserInfoId		
				 WHERE 
					 TM.TransactionStatusCodeId NOT IN(@nContDisStatusType,@nContDisHardCopyStatusType) AND TM.UserInfoId=@inp_iUserInfoId AND TM.DisclosureTypeCodeId=@nDisclosureTypeCodeId
					 AND CONVERT(date, TM.PeriodEndDate) < CONVERT(date, @inp_dtEndDate)
					 AND EL.EventCodeId IN(@nPeriodEndEntered)
			)traPendinTrans
		END
		ELSE
		BEGIN
			SELECT @nRelativeCount AS 'IsRelativeFound'
		END
				
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



