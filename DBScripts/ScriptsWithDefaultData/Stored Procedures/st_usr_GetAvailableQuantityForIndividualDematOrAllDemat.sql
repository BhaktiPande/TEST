IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_GetAvailableQuantityForIndividualDematOrAllDemat')
DROP PROCEDURE [dbo].[st_usr_GetAvailableQuantityForIndividualDematOrAllDemat]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure used for getting available qty for demat indivisual for exclude one demat

Returns:		0, if Success.
				
Created by:		Tushar
Created on:		14-Oct-2016
Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_usr_GetAvailableQuantityForIndividualDematOrAllDemat 49,139001,2,191001
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_GetAvailableQuantityForIndividualDematOrAllDemat]
	@inp_iUserInfoID						INT,
	@inp_iUserInfoRelativeID				INT,
	@inp_iSecurityTypeCodeID				INT,
	@inp_iDEMATdetailsID					INT,
	@inp_iSecurityTransferOption			INT, --191001 get qty for selected demat 191002 cumulative sum of exclude this dmat
	@out_dAvailableQuantity					DECIMAL(30,0) = 0 OUTPUT,
	@out_dAvailablePledgeQuantity			DECIMAL(30,0) = 0 OUTPUT,
	@out_dAvailableESOPQuantity				DECIMAL(30,0) = 0 OUTPUT,
	@out_dAvailableOtherQuantity		    DECIMAL(30,0) = 0 OUTPUT,
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_GETAVAILABLEQTY INT = 11455 -- Error occurred while fetching available quantity.
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
		
		DECLARE @nSecurityTransferfromselectedDemataccount	INT = 191001
		DECLARE @nSecurityTransferfromAllDemataccount		INT = 191002
		
		DECLARE @nYearPeriod INT =  124001	
		
		DECLARE @nYearCodeId								INT
		
		DECLARE @nCounter INT  = 1
        DECLARE @nTotalCount INT = 0
        DECLARE @nTotalQuantity INT = 0
        DECLARE @nQuantity INT = 0
        DECLARE @nDmatID INT = 0

		IF @inp_iSecurityTransferOption = @nSecurityTransferfromselectedDemataccount
		BEGIN
		    SELECT @nYearCodeId = MAX(YearCodeId) 
		    FROM tra_TransactionSummaryDMATWise WHERE UserInfoIdRelative = @inp_iUserInfoRelativeID	
		    AND SecurityTypeCodeId = @inp_iSecurityTypeCodeID AND DMATDetailsID = @inp_iDEMATdetailsID AND PeriodCodeId = @nYearPeriod
		   		
			SELECT @out_dAvailableQuantity = ClosingBalance,
				   @out_dAvailablePledgeQuantity = PledgeClosingBalance 
			FROM tra_TransactionSummaryDMATWise 
			WHERE UserInfoId = @inp_iUserInfoID AND SecurityTypeCodeId = @inp_iSecurityTypeCodeID 
				  AND DMATDetailsID = @inp_iDEMATdetailsID and PeriodCodeId = @nYearPeriod 
				  AND YearCodeId = @nYearCodeId
				  AND UserInfoIdRelative = @inp_iUserInfoRelativeID
				  
		    SELECT @out_dAvailableOtherQuantity = OtherQuantity,
				   @out_dAvailablePledgeQuantity = PledgeQuantity 
			FROM tra_ExerciseBalancePool EB
			JOIN tra_TransactionSummaryDMATWise TSD ON EB.UserInfoId = TSD.UserInfoId
			WHERE EB.UserInfoId = @inp_iUserInfoID AND EB.SecurityTypeCodeId = @inp_iSecurityTypeCodeID 
				  AND EB.DMATDetailsID = @inp_iDEMATdetailsID and PeriodCodeId = @nYearPeriod 
				  AND YearCodeId = @nYearCodeId
				  AND UserInfoIdRelative = @inp_iUserInfoRelativeID
				  
			SELECT @out_dAvailableESOPQuantity = ESOPQuantity FROM tra_ExerciseBalancePool EB
			JOIN tra_TransactionSummaryDMATWise TSD ON EB.UserInfoId = TSD.UserInfoId
			WHERE EB.UserInfoId = @inp_iUserInfoID AND EB.SecurityTypeCodeId = @inp_iSecurityTypeCodeID 
					AND EB.DMATDetailsID = @inp_iDEMATdetailsID and PeriodCodeId = @nYearPeriod 
					AND YearCodeId = @nYearCodeId
					AND UserInfoIdRelative = @inp_iUserInfoRelativeID
		
			
		END
		ELSE IF @inp_iSecurityTransferOption = @nSecurityTransferfromAllDemataccount
		BEGIN
		  CREATE TABLE #tbl_Year_CodeID(ID INT IDENTITY(1,1),YearCode INT,DmatID INT)
          INSERT INTO #tbl_Year_CodeID(YearCode,DmatID)   
          SELECT MAX(YearCodeId) AS YearCodeId,DMATDetailsID FROM tra_TransactionSummaryDMATWise 
		  WHERE UserInfoIdRelative = @inp_iUserInfoRelativeID AND SecurityTypeCodeId = @inp_iSecurityTypeCodeID AND DMATDetailsID <> @inp_iDEMATdetailsID AND PeriodCodeId = @nYearPeriod 
		  GROUP BY DMATDetailsID
		  SELECT @nTotalCount = COUNT(*) FROM #tbl_Year_CodeID
          WHILE (@nCounter <= @nTotalCount)
          BEGIN   
	        SELECT @nYearCodeId = YearCode, @nDmatID = DmatID FROM #tbl_Year_CodeID WHERE ID = @nCounter
		   --@out_dAvailableQuantity
			
			SELECT @nQuantity = ClosingBalance
				   --@out_dAvailablePledgeQuantity = SUM(PledgeClosingBalance)
			FROM tra_TransactionSummaryDMATWise 
			WHERE UserInfoId = @inp_iUserInfoID AND SecurityTypeCodeId = @inp_iSecurityTypeCodeID 
				  AND DMATDetailsID <> @inp_iDEMATdetailsID and PeriodCodeId = @nYearPeriod 
				  AND YearCodeId = @nYearCodeId AND DMATDetailsID = @nDmatID 
				  AND UserInfoIdRelative = @inp_iUserInfoRelativeID
			--GROUP BY UserInfoId
			--SELECT @out_dAvailableESOPQuantity = SUM(ESOPQuantity) FROM tra_ExerciseBalancePool 
			--WHERE UserInfoId = @inp_iUserInfoID AND SecurityTypeCodeId = @inp_iSecurityTypeCodeID
			--AND DMATDetailsID <> @inp_iDEMATdetailsID
		   SET @nTotalQuantity = @nTotalQuantity + @nQuantity
           SET @nCounter = @nCounter + 1         
		  END
		     SET @out_dAvailableQuantity = @nTotalQuantity	
			 SELECT @out_dAvailableQuantity
		END
		SET @out_dAvailableQuantity = ISNULL(@out_dAvailableQuantity,0)
		SET @out_dAvailablePledgeQuantity = ISNULL(@out_dAvailablePledgeQuantity,0)
		SET @out_dAvailableESOPQuantity = ISNULL(@out_dAvailableESOPQuantity,0)
		SET @out_dAvailableOtherQuantity = ISNULL(@out_dAvailableOtherQuantity,0)
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_GETAVAILABLEQTY, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END