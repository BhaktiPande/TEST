IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_SaveInitialDisclosureList_OS')
DROP PROCEDURE [dbo].st_tra_SaveInitialDisclosureList_OS
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the Initial discloasure list in DB for Other Securities(No Holding)

Returns:		0, if Success.
				
Created by:		Shubhangi
Created on:		09-Mar-2019

Modification History:
Modified By		Modified On		Description

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_SaveInitialDisclosureList_OS] 
	@inp_tblInitialDisList_OS	        InitialDisListType_OS READONLY,
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_PRECLEARANCEREQUEST_SAVE_ERROR	INT = 17512 -- Error occured while saving preclearance for non implementing company
	
	
	
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

		
		CREATE TABLE #tmpTrans
		(
		[ID] [INT] IDENTITY(1,1) NOT NULL,
		[TransactionMasterId] [INT]  NULL,
		[SecurityTypeCodeId] [INT]  NULL,
		[UserInfoId] [INT]  NULL,
		[DMATDetailsID] [INT]  NULL,
		[CompanyId] [INT]  NULL,	
		[ModeOfAcquisitionCodeId] [INT]  NULL,
		[ExchangeCodeId] [INT]  NULL,
		[TransactionTypeCodeId] [INT]  NULL,
		[SecuritiesToBeTradedQty]	[decimal](15, 4) NULL,
		[SecuritiesToBeTradedValue]	[decimal](20, 4)  NULL,
		[LotSize]	[INT]  NULL,
		[ContractSpecification]	VARCHAR(200)  NULL
		)
		--select * from #tmpTrans
		INSERT INTO #tmpTrans 
		--SELECT * FROM @inp_tblInitialDisList_OS
		--select * from #tmpTrans


		SELECT TransactionMasterId,SecurityTypeCodeId,UserInfoId,		
		CASE WHEN DMATDetailsID=0 THEN NULL ELSE DMATDetailsID END,
		CompanyId,ModeOfAcquisitionCodeId,ExchangeCodeId,
		TransactionTypeCodeId,SecuritiesToBeTradedQty,SecuritiesToBeTradedValue,	
		LotSize,ContractSpecification
		FROM @inp_tblInitialDisList_OS
	

		
		DECLARE @nCount INT=0
		DECLARE @nTotCount INT=0
		DECLARE @nTransMasterId INT=0
		DECLARE @nSecurityTypeCodeId INT=0
		--SELECT @nTransMasterId =TransactionMasterId,@nSecurityTypeCodeId=SecurityTypeCodeId FROM #tmpTrans
		
		--DELETE FROM tra_TransactionDetails WHERE TransactionMasterId=@nTransMasterId and SecurityTypeCodeId=@nSecurityTypeCodeId
		
		SELECT @nTotCount=COUNT(ID) FROM #tmpTrans		
		
		WHILE @nCount<@nTotCount
		BEGIN
		DECLARE @iTransactionMasterId INT=0
		DECLARE @iSecurityTypeCodeId INT=0
		DECLARE @iForUserInfoId INT=0
		DECLARE @iDMATDetailsID INT=0
		DECLARE @iCompanyId INT=0
		DECLARE @dtDateOfInitimationToCompany DATETIME=GETDATE()
		DECLARE @iModeOfAcquisitionCodeId INT=0
		DECLARE @iExchangeCodeId INT=0
		DECLARE @iTransactionTypeCodeId INT=0
		DECLARE @dQuantity DECIMAL(15,4)=0
		DECLARE @dValue DECIMAL(20,4)=0	
		DECLARE @iLotSize INT=0
		DECLARE @sContractSpecification VARCHAR(200)
		
		SELECT @iTransactionMasterId=TransactionMasterId,@iSecurityTypeCodeId=SecurityTypeCodeId,
		@iForUserInfoId=UserInfoId,@iDMATDetailsID=DMATDetailsID,@iCompanyId=CompanyId,
		@iModeOfAcquisitionCodeId=ModeOfAcquisitionCodeId,@iExchangeCodeId=ExchangeCodeId,
		@iTransactionTypeCodeId=TransactionTypeCodeId,@dQuantity=SecuritiesToBeTradedQty,
		@dValue=SecuritiesToBeTradedValue,
		@iLotSize=LotSize,@sContractSpecification=NULL
		FROM #tmpTrans WHERE ID=@nCount+1	
		
		
		EXEC st_tra_TradingTransactionSave_OS
		0,@iTransactionMasterId ,
		@iSecurityTypeCodeId ,@iForUserInfoId,
		@iDMATDetailsID ,@iCompanyId ,
		null ,@dtDateOfInitimationToCompany ,
		@iModeOfAcquisitionCodeId,@iExchangeCodeId,
		@iTransactionTypeCodeId ,@dQuantity ,
		@dValue ,@iLotSize,@sContractSpecification,
		null,@iForUserInfoId,@dQuantity,		
		@out_nReturnValue OUTPUT,
		@out_nSQLErrCode  OUTPUT,
		@out_sSQLErrMessage  OUTPUT	

		IF(@out_nReturnValue !=0)
		BEGIN
			BREAK;
		END

		SET @nCount=@nCount+1
		END
		DROP TABLE #tmpTrans	
		
		--SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END TRY

	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_PRECLEARANCEREQUEST_SAVE_ERROR, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
	END CATCH
END