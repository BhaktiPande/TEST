IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_UpdatePeriodendForTransactionMaster_OS')
DROP PROCEDURE [dbo].[st_tra_UpdatePeriodendForTransactionMaster_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sandesh S. Lande.
-- Create date: 16-APR-2021
-- Description:	Hot fixe for period end date with jite and vidyadhar
-- exec st_tra_UpdatePeriodendForTransactionMaster_OS 300
-- =============================================
CREATE PROCEDURE st_tra_UpdatePeriodendForTransactionMaster_OS
	-- Add the parameters for the stored procedure here
	@transactionMasterId									BIGINT, 
	@out_nReturnValue										INT = 0 OUTPUT,
	@out_nSQLErrCode										INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage										NVARCHAR(500) = '' OUTPUT
AS
BEGIN
DECLARE @inp_iUserInfoId INT, 
@TradingPolicyId INT, 
@dtCurrentDate DATETIME,
@nActinFlag INT,
@nApplicableTP INT , 
@nYearCodeId INT , 
@nPeriodCodeId INT , 
@dtPEStartDate DATETIME , 
@dtPEEndDate DATETIME , 
@bChangePEDate BIT , 
@dtPEEndDateToUpdate DATETIME,								
@RC INT

	 IF (EXISTS(SELECT * FROM tra_TransactionDetails_OS where TransactionMasterId = @transactionMasterId))
						BEGIN

						SELECT		@inp_iUserInfoId=UserInfoId, 
									@TradingPolicyId=TradingPolicyId 
									FROM tra_TransactionMaster_OS WHERE TransactionMasterId=@transactionMasterId
									
						SELECT @dtCurrentDate=max(DateOfAcquisition) FROM tra_TransactionDetails_OS where TransactionMasterId = @transactionMasterId

					--set @dtCurrentDate= '10-MAR-2021'
						
					EXECUTE @RC = [st_tra_PeriodEndDisclosureGetApplicablePeriodDetail_OS]
									@inp_iUserInfoId, 
									@TradingPolicyId, 
									@dtCurrentDate,
									@nActinFlag OUTPUT,
									@nApplicableTP OUTPUT, 
									@nYearCodeId OUTPUT, 
									@nPeriodCodeId OUTPUT, 
									@dtPEStartDate OUTPUT, 
									@dtPEEndDate OUTPUT, 
									@bChangePEDate OUTPUT, 
									@dtPEEndDateToUpdate OUTPUT, 									
									@out_nReturnValue OUTPUT,
									@out_nSQLErrCode OUTPUT,
									@out_sSQLErrMessage OUTPUT
				
									
				update tra_TransactionMaster_OS 
				SET PeriodEndDate=@dtPEEndDate
				WHERE TransactionMasterId=@transactionMasterId
				END
				   ---Set @dtPEEndDate =Getdate()
					IF @out_nReturnValue <> 0
					BEGIN												
						RETURN @out_nReturnValue
					END
					
END
GO


