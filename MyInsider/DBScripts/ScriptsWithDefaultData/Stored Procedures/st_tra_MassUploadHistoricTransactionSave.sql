IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_MassUploadHistoricTransactionSave')
DROP PROCEDURE [dbo].[st_tra_MassUploadHistoricTransactionSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure will be used for inserting the historic preclearance records for past 6 months.
				This is a one time activity for each implementation company setup. 

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		20-Dec-2015
Modification History:
Modified By		Modified On		Description


Usage:
DECLARE @RC int
EXEC st_tra_MassUploadHistoricTransactionSave <parameters>

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_MassUploadHistoricTransactionSave] 
	@inp_nTransactionMasterId			INT
	,@inp_nPreclearanceId				INT
	,@inp_sUserLoginName				NVARCHAR(100) = null			--From Excel
	,@inp_nRelationCodeId				INT							--The relation mentioned in the excel for finding the ForUserId. This is 100000 for Self
	,@inp_sFirstLastName				NVARCHAR(55)			--From Excel, this will be used for finding the ForUserId
	,@inp_dtDateOfAcquisition			DATETIME
	,@inp_nModeOfAcquisitionCodeId		INT		--From Excel
	,@inp_dtDateOfInitimationToCompany	DATETIME		--From Excel
	,@inp_dSecuritiesHeldPriorToAcquisition		decimal
	,@inp_sDEMATAccountNo				VARCHAR(50)
	,@inp_nExchangeCodeId				INT		--From Excel
	,@inp_nTransactionTypeCodeId		INT
	,@inp_nSecurityTypeCodeId			INT			--From Excel, if this is 0 then it will be no holdings and so the flag should be set to true
	,@inp_dPerOfSharesPreTransaction	DECIMAL(5,2)	--Received from Excel -- for shares,debuntires etc
	,@inp_dPerOfSharesPostTransaction	DECIMAL(5,2)	--Received from Excel -- for shares,debuntires etc	
	,@inp_dQuantity						DECIMAL -- From Excel
	,@inp_dValue						DECIMAL	--From Excel 
	,@inp_dQuantity2					DECIMAL -- From Excel
	,@inp_dValue2						DECIMAL	--From Excel 
	,@inp_nLotSize						INT			--From Excel For options and futures
	,@inp_sContractSpecification		VARCHAR(50)
	,@out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	/
	
	WITH RECOMPILE
	
AS 
BEGIN 

	BEGIN TRY
		
		--Error Codes Check these before final commmit
		
		DECLARE @ERROR_INVALIDUSERNAME INT = 11025
		DECLARE @ERROR_RELATIVE_IS_INVALID INT = 17094
		DECLARE @ERROR_INVALIDDEMATNUMBER INT = 11037
		--Error Codes
		
		
		DECLARE @NOHOLDINGS INT = 139000
		DECLARE @RELATION_SELF INT = 100000
		
		
		--For Transaction Master
		DECLARE @nTransactionMasterId		BIGINT = 0		--Will be found if present in the master table else will be 0
		DECLARE @nUserInfoId INT					--Find from given username
		DECLARE @nNoHoldingFlag				bit = null		--Will be set based on the SecurityType value from the Excel
		DECLARE @nDisclosureTypeCodeId		INT = 147002			--For Continuous Disclosure
		
		--For Details
		DECLARE @nDMATDetailsID INT = 0		--DEMAT DETAILS Id found
		DECLARE @nTransactionDetailsId BIGINT		-- 0
		DECLARE @nForUserInfoId INT	 = 0			--Will have to find this based on the Username, FirstNameLastName and the Relation in the excel
		DECLARE @nCompanyId INT					--Find the implementation companyid
		DECLARE @nIsPreClearanceRequest INT
		
		DECLARE @nRC INT		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF EXISTS(SELECT UserInfoID FROM usr_Authentication WHERE LoginID = @inp_sUserLoginName)
		BEGIN
			SELECT @nUserInfoId = UserInfoID FROM usr_Authentication WHERE LoginID = @inp_sUserLoginName
		END
		ELSE
		BEGIN
			SELECT @out_nReturnValue = @ERROR_INVALIDUSERNAME
			
			RETURN @out_nReturnValue
		END
		
		IF @inp_nSecurityTypeCodeId <> @NOHOLDINGS
		BEGIN
			--If the security flag is 0 then consider the case of NOHOLDINGS
			SELECT @nNoHoldingFlag = 0
			--For finding the Relatives id
			IF @inp_nRelationCodeId = @RELATION_SELF   --For Self
			BEGIN
				SELECT @nForUserInfoId = @nUserInfoId
			END
			ELSE							--For Relatives
			BEGIN
				IF EXISTS  (SELECT RelativesList.UserInfoIdRelative from (
						SELECT UR.UserInfoIdRelative FROM usr_UserInfo UI 
						JOIN usr_UserRelation UR ON UR.UserInfoId = UI.UserInfoId
						WHERE UR.UserInfoId = @nUserInfoId  
						AND UR.RelationTypeCodeId = @inp_nRelationCodeId
						) AS RelativesList
					join usr_UserInfo UI ON UI.UserInfoid = RelativesList.UserInfoIdRelative 
					AND LOWER(ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'')) = LOWER(@inp_sFirstLastName))
				BEGIN
					SELECT @nForUserInfoId = RelativesList.UserInfoIdRelative from (
						SELECT UR.UserInfoIdRelative FROM usr_UserInfo UI 
						JOIN usr_UserRelation UR ON UR.UserInfoId = UI.UserInfoId
						WHERE UR.UserInfoId = @nUserInfoId  
						AND UR.RelationTypeCodeId = @inp_nRelationCodeId
						) AS RelativesList
					join usr_UserInfo UI ON UI.UserInfoid = RelativesList.UserInfoIdRelative 
					AND LOWER(ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'')) = LOWER(@inp_sFirstLastName)
				END
				ELSE
				BEGIN
					SELECT @out_nReturnValue = @ERROR_RELATIVE_IS_INVALID
					
					RETURN @out_nReturnValue
				END
			END
			
			--For finding the DEMATDetails id
			IF @inp_nRelationCodeId = @RELATION_SELF
			BEGIN
				SELECT @nDMATDetailsID = DM.DMATDetailsId FROM usr_DMATDetails DM
				JOIN usr_UserInfo UI on UI.UserInfoid = DM.UserInfoId
				WHERE UI.UserInfoId = @nUserInfoId AND DM.DEMATAccountNumber = @inp_sDEMATAccountNo
			END
			ELSE
			BEGIN
				SELECT @nDMATDetailsID = DM.DMATDetailsId FROM usr_DMATDetails DM
				JOIN usr_UserInfo UI on UI.UserInfoid = DM.UserInfoId
				WHERE UI.UserInfoId = @nForUserInfoId  AND DM.DEMATAccountNumber = @inp_sDEMATAccountNo
			END
			IF @nDMATDetailsID IS NULL OR @nDMATDetailsID = 0
			BEGIN
				SELECT @out_nReturnValue = @ERROR_INVALIDDEMATNUMBER
				
				RETURN @out_nReturnValue
			END
		END
		ELSE
		BEGIN
			SELECT @nNoHoldingFlag = 1
		END	
		
		SELECT top 1 @nCompanyId = CompanyId FROM mst_Company WHERE IsImplementing = 1
		
		IF ISNULL(@inp_nPreclearanceId, 0) = 0
		BEGIN
			SELECT @nIsPreClearanceRequest = 0
		END
		ELSE
		BEGIN
			SELECT @nIsPreClearanceRequest = 1
		END
		
		--Add entry in the History Transaction Master
		INSERT INTO [tra_HistoricTransactionMaster]([PreclearanceRequestId] ,[UserInfoId] ,[DisclosureTypeCodeId] ,[NoHoldingFlag] ,[SecurityTypeCodeId])
		VALUES (@inp_nPreclearanceId ,@nUserInfoId ,@nDisclosureTypeCodeId ,@nNoHoldingFlag ,@inp_nSecurityTypeCodeId)
		
		SELECT @nTransactionMasterId = SCOPE_IDENTITY()
		
		--Add entry in the History Transaction Details
		INSERT INTO tra_HistoricTransactionDetails ([TransactionMasterId] ,[SecurityTypeCodeId] ,[ForUserInfoId] ,[DMATDetailsID] ,[CompanyId] ,[SecuritiesPriorToAcquisition] ,[PerOfSharesPreTransaction] ,[DateOfAcquisition] ,[DateOfInitimationToCompany] ,[ModeOfAcquisitionCodeId] ,[PerOfSharesPostTransaction] ,[ExchangeCodeId] ,[TransactionTypeCodeId] ,[Quantity] ,[Value] ,[Quantity2] ,[Value2] ,[LotSize] ,[IsPLCReq] ,[ContractSpecification])
		VALUES (@nTransactionMasterId ,@inp_nSecurityTypeCodeId ,@nForUserInfoId ,@nDMATDetailsID ,@nCompanyId ,@inp_dSecuritiesHeldPriorToAcquisition ,@inp_dPerOfSharesPreTransaction ,@inp_dtDateOfAcquisition,@inp_dtDateOfInitimationToCompany ,@inp_nModeOfAcquisitionCodeId ,@inp_dPerOfSharesPostTransaction ,@inp_nExchangeCodeId ,@inp_nTransactionTypeCodeId ,@inp_dQuantity ,@inp_dValue ,@inp_dQuantity2 ,@inp_dValue2 ,@inp_nLotSize,@nIsPreClearanceRequest ,@inp_sContractSpecification)
		
		
		SELECT @nTransactionMasterId AS TransactionMasterId
		
		SELECT @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = @out_nSQLErrCode
		RETURN @out_nReturnValue
	END CATCH
END
