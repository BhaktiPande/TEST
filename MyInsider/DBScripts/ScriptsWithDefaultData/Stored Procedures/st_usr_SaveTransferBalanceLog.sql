IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_SaveTransferBalanceLog')
DROP PROCEDURE [dbo].[st_usr_SaveTransferBalanceLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure used for save transfer balance log.

Returns:		0, if Success.
				
Created by:		Tushar
Created on:		17-Oct-2016
Modification History:
Modified By		Modified On		Description
Tushar			20-Oct-2016		Call Procedure Update Excercise pool and summary.
Tushar			26-Oct-2016		If Transfer for self then foruserinfoid set user id.

Usage:
DECLARE @RC int
EXEC st_usr_SaveTransferBalanceLog 49,139001,2,191001
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_SaveTransferBalanceLog]
	@inp_iUserInfoId						INT,
	@inp_iForUserInfoId						INT,
	@inp_iSecurityTransferOption			INT, --191001 get qty for selected demat 191002 cumulative sum of exclude this dmat
	@inp_dTransferQuantity					DECIMAL(15,0),
	@inp_iSecurityTypeCodeID				INT,
	@inp_iFromDEMATAcountID					INT,
	@inp_iToDEMATAcountID					INT,
	@inp_iTransferFor						INT,
	@inp_dTransferESOPQuantity				DECIMAL(15,0),
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TRANSFER_BALANCE INT = 11456 -- Error occurred while securities transfer.
	DECLARE @nRetValue INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		DECLARE @RC INT
		
		DECLARE @nSecurityTransferfromselectedDemataccount	INT = 191001
		DECLARE @nSecurityTransferfromAllDemataccount		INT = 191002
		
		DECLARE @nTransferForSelf INT  = 142001
		DECLARE @nTransferForRelative INT  = 142002
		
		DECLARE @dtToday DATETIME = dbo.uf_com_GetServerDate()
		
		DECLARE @tmpDMATTable TABLE(DMATID int,Balance DECIMAL(20,0))
		
		DECLARE @ESOPandOtherThanEsopQty DECIMAL(15,0)
		
		DECLARE @nYearPeriod INT =  124001
		DECLARE @nPeriodType								INT
		DECLARE @nYearCodeId								INT
		DECLARE	@nPeriodCodeId								INT 
		DECLARE @dtPEStartDate								DATETIME
		DECLARE @dtPEEndDate								DATETIME
		
		IF @inp_iTransferFor = @nTransferForSelf  
		BEGIN
			SET @inp_iForUserInfoId = @inp_iUserInfoId
		END
		
		EXEC @RC = st_usr_TransferBalanceLogValidation @inp_iUserInfoId,@inp_iForUserInfoId,@inp_iSecurityTransferOption,@inp_dTransferQuantity,
						@inp_iSecurityTypeCodeID,@inp_iFromDEMATAcountID,@inp_iToDEMATAcountID,@inp_iTransferFor,@inp_dTransferESOPQuantity,
						@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT

		IF @out_nReturnValue <> 0
		BEGIN
			SET @out_nReturnValue = @out_nReturnValue --VALIDATION
			RETURN @out_nReturnValue
		END
		
		IF @inp_iSecurityTransferOption = @nSecurityTransferfromselectedDemataccount
		BEGIN
		    SET @ESOPandOtherThanEsopQty = @inp_dTransferQuantity + @inp_dTransferESOPQuantity
		    
			IF @inp_iTransferFor = @nTransferForSelf
			BEGIN
				SET @inp_iForUserInfoId = @inp_iUserInfoId
			END
			INSERT INTO usr_SecurityTransferLog(UserInfoId,ForUserInfoId,FromDEMATAcountID,SecurityTypeCodeID,ToDEMATAcountID,TransferDate
												,TransferQuantity,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,SecurityTransferOption)
			VALUES(@inp_iUserInfoId,@inp_iForUserInfoId,@inp_iFromDEMATAcountID,@inp_iSecurityTypeCodeID,@inp_iToDEMATAcountID,
					@dtToday,@ESOPandOtherThanEsopQty,@inp_iUserInfoId,@dtToday,@inp_iUserInfoId,@dtToday,@inp_iSecurityTransferOption)
		END
		ELSE IF @inp_iSecurityTransferOption = @nSecurityTransferfromAllDemataccount
		BEGIN
		
		SET @nPeriodType = CASE WHEN @nPeriodType = 137001 THEN 123001 -- Yearly
								WHEN @nPeriodType = 137002	THEN 123003 -- Quarterly
								WHEN @nPeriodType = 137003	THEN 123004 -- Monthly
								WHEN @nPeriodType = 137004	THEN 123002 -- Weekly
								ELSE @nPeriodType
								END

			EXECUTE @RC = st_tra_PeriodEndDisclosureStartEndDate2
			   @nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT, @dtToday, @nPeriodType, 0, @dtPEStartDate OUTPUT, @dtPEEndDate OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			  
		
			IF @inp_iTransferFor = @nTransferForSelf
			BEGIN
				INSERT INTO @tmpDMATTable
				SELECT DMATDetailsID,0 FROM usr_DMATDetails WHERE UserInfoID = @inp_iUserInfoId
				AND DMATDetailsID <> @inp_iToDEMATAcountID
				
				UPDATE DT
				SET balance = ClosingBalance 
				 FROM @tmpDMATTable DT
				 JOIN(
					SELECT ClosingBalance AS ClosingBalance, DMATDetailsID AS DMATDetailsID
					FROM tra_TransactionSummaryDMATWise 
					WHERE UserInfoId = @inp_iUserInfoID AND SecurityTypeCodeId = @inp_iSecurityTypeCodeID 
							 AND PeriodCodeId = @nYearPeriod 
					  AND YearCodeId = @nYearCodeId) TSDW ON TSDW.DMATDetailsID = DT.DMATID
				
			END
			ELSE IF @inp_iTransferFor = @nTransferForRelative
			BEGIN
				INSERT INTO @tmpDMATTable
				SELECT DMATDetailsID,0 FROM usr_DMATDetails WHERE UserInfoID = @inp_iForUserInfoId
				AND DMATDetailsID <> @inp_iToDEMATAcountID
				
				UPDATE DT
				SET balance = ClosingBalance 
				 FROM @tmpDMATTable DT
				 JOIN(
					SELECT ClosingBalance AS ClosingBalance, DMATDetailsID AS DMATDetailsID
					FROM tra_TransactionSummaryDMATWise 
					WHERE UserInfoIdRelative = @inp_iForUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeID 
							 AND PeriodCodeId = @nYearPeriod 
					  AND YearCodeId = @nYearCodeId) TSDW ON TSDW.DMATDetailsID = DT.DMATID
			END
			SELECT * FROM @tmpDMATTable
			INSERT INTO usr_SecurityTransferLog(UserInfoId,ForUserInfoId,FromDEMATAcountID,SecurityTypeCodeID,ToDEMATAcountID,TransferDate
												,TransferQuantity,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,SecurityTransferOption)
			SELECT @inp_iUserInfoId,@inp_iUserInfoId,DMATID,@inp_iSecurityTypeCodeID,@inp_iToDEMATAcountID,
					@dtToday,Balance,@inp_iUserInfoId,@dtToday,@inp_iUserInfoId,@dtToday,@inp_iSecurityTransferOption
			FROM @tmpDMATTable
			WHERE Balance <> 0
			--SELECT * FROM @tmpDMATTable
			
		
			
		END
		
			--select @inp_iSecurityTransferOption,@inp_iUserInfoId,@inp_iForUserInfoId,@inp_iSecurityTypeCodeID
				--			,@inp_iFromDEMATAcountID,@inp_iToDEMATAcountID,@inp_dTransferQuantity
			EXEC @RC = st_usr_SecurityTransfer_TransferDematQuantity @inp_iSecurityTransferOption,@inp_iUserInfoId,@inp_iForUserInfoId,@inp_iSecurityTypeCodeID
							,@inp_iFromDEMATAcountID,@inp_iToDEMATAcountID,@inp_dTransferQuantity,@inp_dTransferESOPQuantity,
							@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
			select @out_nReturnValue
			IF @out_nReturnValue <> 0
			BEGIN
				SET @out_nReturnValue = @out_nReturnValue --VALIDATION
				RETURN @out_nReturnValue
			END
		
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_TRANSFER_BALANCE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END