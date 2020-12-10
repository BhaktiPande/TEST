IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_SecurityTransfer_TransferDematQuantity')
DROP PROCEDURE [dbo].[st_usr_SecurityTransfer_TransferDematQuantity]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	transfer security balance between demat accounts
				This procedure is use to transfer demat balance from one/more demat account to one specified demat account.

Returns:		0, if Success.
				
Created by:		Parag
Created on:		20-Oct-2016

Modification History:
Modified By		Modified On		Description


-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_SecurityTransfer_TransferDematQuantity]
	@inp_nSecurityTransferOption 			INT,
	@inp_nUserInfoId						INT,
	@inp_nRelativeUserInfoId				INT = NULL,
	@inp_nSecurityType						INT,
	@inp_nFromDematAccountId				INT = NULL,
	@inp_nToDematAccountId					INT,
	@inp_nQuantity							DECIMAL(10) = NULL,
	@inp_nESOPQuantity						DECIMAL(10) = NULL,
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT
	
AS
BEGIN
	DECLARE @ERR_SECURITY_TRANSFER_UPDATE_DEMAT_BALANCE INT = 11483 -- Error occured while updating demat balance while security transfer

	DECLARE @TransferOption_Selected_Demat INT = 191001
	DECLARE @TransferOption_All_Demat INT = 191002

	DECLARE @Current_Date DATETIME = [dbo].[uf_com_GetServerDate]()

	DECLARE @User_Relative_Id INT = CASE WHEN @inp_nRelativeUserInfoId IS NULL THEN @inp_nUserInfoId ELSE @inp_nRelativeUserInfoId END
	
	DECLARE @EP_ESOP_Quantity DECIMAL(15,0) = 0
	DECLARE @EP_Other_Quantity DECIMAL(15,0) = 0
	DECLARE @EP_Pledge_Quantity DECIMAL(15,0) = 0
	DECLARE @EP_NonImpact_Quantity DECIMAL(15,0) = 0
	
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
		
		
		-- Security Transfer Logic
		/*
			check security tranfer is for user or relative, and transfer option
			
			security transfer affect two table - demat wise summay and exercise pool
			for demat wise summary table, also transfer values in proportion of security using formula ie (value/toal no of security) * tranfer security quantity
			in case of pledge, as per discussion with deepak, there will be zero closing balance for pledge before transfer

			get current year and period code id to transfer balances

			if quantity is positive then substract from buy field and if quantity is negative then substract from sell

			if one to one transfer - from one demat account to another demat account 
			if many to one transfer - from all demat account to one demat account
		*/

		IF(@inp_nSecurityTransferOption = @TransferOption_All_Demat)
		BEGIN
			DECLARE @DematId INT

			DECLARE DematAccount_Cursor CURSOR FOR 
				SELECT DMATDetailsID FROM usr_DMATDetails 
				WHERE DMATDetailsID <> @inp_nToDematAccountId 
				AND UserInfoID = CASE WHEN @inp_nRelativeUserInfoId IS NULL THEN @inp_nUserInfoId ELSE @inp_nRelativeUserInfoId END

			OPEN DematAccount_Cursor
			
			FETCH NEXT FROM DematAccount_Cursor INTO @DematId

			WHILE @@FETCH_STATUS = 0
			BEGIN
				
				EXEC st_usr_SecurityTransferUpdateDematBalance 
							@inp_nSecurityTransferOption,
							@inp_nUserInfoId,
							@User_Relative_Id,
							@inp_nSecurityType,
							@DematId,
							@inp_nToDematAccountId,
							NULL,
							@Current_Date,
							NULL,
							@out_nReturnValue output,
							@out_nSQLErrCode output,
							@out_sSQLErrMessage output

				IF @out_nReturnValue <> 0
				BEGIN
					RETURN @out_nReturnValue
				END


				-- check if destination demat account exists
				IF NOT EXISTS (SELECT DMATDetailsID FROM tra_ExerciseBalancePool 
									WHERE UserInfoId = @inp_nUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType AND DMATDetailsID = @inp_nToDematAccountId)
				BEGIN
					INSERT INTO tra_ExerciseBalancePool
						(UserInfoId, DMATDetailsID, SecurityTypeCodeId, ESOPQuantity, OtherQuantity, PledgeQuantity, NotImpactedQuantity)
					VALUES
						(@inp_nUserInfoId, @inp_nToDematAccountId, @inp_nSecurityType, 0, 0, 0, 0)
				END

				SET @EP_ESOP_Quantity = 0
				SET @EP_Other_Quantity = 0
				SET @EP_Pledge_Quantity = 0
				SET @EP_NonImpact_Quantity = 0

				SELECT 
					@EP_ESOP_Quantity = ESOPQuantity, 
					@EP_Other_Quantity = OtherQuantity,
					@EP_Pledge_Quantity = PledgeQuantity,
					@EP_NonImpact_Quantity = NotImpactedQuantity
				FROM tra_ExerciseBalancePool 
				WHERE UserInfoId = @inp_nUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType AND DMATDetailsID = @DematId

				--select @inp_nSecurityType 'Security', @DematId 'From Demat Account', @EP_ESOP_Quantity 'ESOP Quantity', @EP_Other_Quantity 
				--		'Other Quantity', @EP_Pledge_Quantity 'Pledge Quatity', @EP_NonImpact_Quantity 'Not Impacted Quantity',@inp_nToDematAccountId 'To Demat Account'

				-- update exercise pool
				UPDATE tra_ExerciseBalancePool
				SET
					ESOPQuantity = ESOPQuantity + @EP_ESOP_Quantity,
					OtherQuantity = OtherQuantity + @EP_Other_Quantity,
					PledgeQuantity = PledgeQuantity + @EP_Pledge_Quantity,
					NotImpactedQuantity = NotImpactedQuantity + @EP_NonImpact_Quantity
				WHERE 
					UserInfoId = @inp_nUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType AND DMATDetailsID = @inp_nToDematAccountId

				UPDATE tra_ExerciseBalancePool
				SET
					ESOPQuantity = ESOPQuantity - @EP_ESOP_Quantity,
					OtherQuantity = OtherQuantity - @EP_Other_Quantity,
					PledgeQuantity = PledgeQuantity - @EP_Pledge_Quantity,
					NotImpactedQuantity = NotImpactedQuantity - @EP_NonImpact_Quantity
				WHERE 
					UserInfoId = @inp_nUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType AND DMATDetailsID = @DematId


				FETCH NEXT FROM DematAccount_Cursor INTO @DematId
			END
			
			CLOSE DematAccount_Cursor
			DEALLOCATE DematAccount_Cursor;

		END
		ELSE IF(@inp_nSecurityTransferOption = @TransferOption_Selected_Demat)
		BEGIN
			IF (@inp_nFromDematAccountId IS NOT NULL )
			BEGIN
				
				EXEC st_usr_SecurityTransferUpdateDematBalance 
							@inp_nSecurityTransferOption,
							@inp_nUserInfoId,
							@User_Relative_Id,
							@inp_nSecurityType,
							@inp_nFromDematAccountId,
							@inp_nToDematAccountId,
							@inp_nQuantity,
							@Current_Date,
							@inp_nESOPQuantity,
							@out_nReturnValue output,
							@out_nSQLErrCode output,
							@out_sSQLErrMessage output

				IF @out_nReturnValue <> 0
				BEGIN
					RETURN @out_nReturnValue
				END


				IF NOT EXISTS (SELECT DMATDetailsID FROM tra_ExerciseBalancePool 
									WHERE UserInfoId = @inp_nUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType AND DMATDetailsID = @inp_nToDematAccountId)
				BEGIN
					INSERT INTO tra_ExerciseBalancePool
						(UserInfoId, DMATDetailsID, SecurityTypeCodeId, ESOPQuantity, OtherQuantity, PledgeQuantity, NotImpactedQuantity)
					VALUES
						(@inp_nUserInfoId, @inp_nToDematAccountId, @inp_nSecurityType, 0, 0, 0, 0)
				END

				SELECT 
					@EP_Other_Quantity = OtherQuantity
				FROM tra_ExerciseBalancePool 
				WHERE UserInfoId = @inp_nUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType AND DMATDetailsID = @inp_nFromDematAccountId

				--select @inp_nSecurityType 'Security', @DematId 'From Demat Account', @EP_Other_Quantity 'Other Quantity', @inp_nToDematAccountId 'To Demat Account'

				-- update exercise pool
				UPDATE tra_ExerciseBalancePool
				SET
					OtherQuantity = OtherQuantity + @inp_nQuantity,
					ESOPQuantity  = ESOPQuantity + @inp_nESOPQuantity
				WHERE 
					UserInfoId = @inp_nUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType AND DMATDetailsID = @inp_nToDematAccountId

				UPDATE tra_ExerciseBalancePool
				SET
					OtherQuantity = OtherQuantity - @inp_nQuantity,
					ESOPQuantity  = ESOPQuantity - @inp_nESOPQuantity
				WHERE 
					UserInfoId = @inp_nUserInfoId AND SecurityTypeCodeId = @inp_nSecurityType AND DMATDetailsID = @inp_nFromDematAccountId


			END
		END
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_SECURITY_TRANSFER_UPDATE_DEMAT_BALANCE, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

