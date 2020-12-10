IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_MassUploadInitialDisclosure')
DROP PROCEDURE [dbo].[st_usr_MassUploadInitialDisclosure]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save initial disclosure for the employees using the Mass Upload functionality.

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		06-Oct-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		4-Dec-2015		Changes for the Shares type security type, set the value for the quantity to the OtherExerciseOptionQuantity value
								when saving the record. Also the SegragateESOPAndOtherQuantity flag is set false during mass upload.
Raghvendra		22-Dec-2015		Added default values for @bESOPExerciseOptionQuantityFlag and @bOtherExerciseOptionQuantityFlag
Raghvendra		05-04-2016		Change to check the PAN number with the value available in the usr_UserInfo table. 
								So if PAN number is null in both the usr_UserInfo and in the Mass upload then it will allow data for initial 
								disclosure to be added.
Parag			05-May-2016		Made change to set "Date Of Acquisition" as null because now date of acquisition is calculate when transaction details save
Tushar			24-Aug-2016		If negative value comes for security then set Transaction Type is sell & Qty is in Positive form sent.
Tushar			29-Aug-2016		If negative value comes for security qty then set Mode of acquasation is Market Sell
Raghvendra		15-Sep-2016		Changes for adding the validation for allowed DEMAT accounts based on the Configuration.

Usage:
EXEC st_usr_MassUploadInitialDisclosure 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_MassUploadInitialDisclosure] 
	@inp_sUserLoginName				nvarchar(100) = null			--From Excel
	,@inp_sPANNumber					nvarchar(50)					--From Excel
	,@inp_nRelationCodeId				INT							--The relation mentioned in the excel for finding the ForUserId. This is 100000 for Self
	,@inp_sFirstLastName					nvarchar(500)			--From Excel, this will be used for finding the ForUserId
	--Details for the Transaction Details procedure call
	,@inp_iSecurityTypeCodeId INT			--From Excel, if this is 0 then it will be no holdings and so the flag should be set to true
	,@inp_sDMATDetailsINo NVARCHAR(100)				--from Excel
	,@inp_dPerOfSharesPreTransaction decimal	--Received from Excel -- for shares,debuntires etc
	,@inp_dtDateOfInitimationToCompany DATETIME		--From Excel
	,@inp_iModeOfAcquisitionCodeId INT		--From Excel
	,@inp_iExchangeCodeId INT		--From Excel
	,@inp_dQuantity decimal -- From Excel
	,@inp_dValue decimal	--From Excel 
	,@inp_iLotSize INT			--From Excel For options and futures
	,@inp_dDateOfBecomingInsider datetime -- From Excel
	,@inp_iLoggedInUserId	INT		= 1 --default value from mapping table
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	/
	
	WITH RECOMPILE
	
AS 
BEGIN 

	BEGIN TRY
		
		--Error Codes Check these before final commmit
		DECLARE @ERR_INITIALDISCLOSURE INT = 11026
		DECLARE @ERROR_INVALIDUSERNAME INT = 11025
		DECLARE @ERROR_PANNOTASSOCIATED_WITH_USERNAME INT = 11325
		DECLARE @ERROR_RELATIVE_IS_INVALID INT = 17094
		DECLARE @ERROR_INITIALDISCLOSURE_SUBMITTED INT = 17174
		DECLARE @ERROR_NO_TRADING_POLICY_ASSOCIATED_WITH_USER INT = 11277
		DECLARE @ERROR_INVALIDDEMATNUMBER INT = 11037
		DECLARE @ERROR_UNCONFIGURED_DP_NAME INT = 11442
		
		DECLARE @SECURITY_TYPE_SHARES_CODEID INT = 139001
		--Error Codes
		
		--For Transaction Master
		DECLARE @inp_dSecuritiesPriorToAcquisition decimal(10, 0) = 0 --Default value o for initial disclosure
		DECLARE @inp_dtDateOfAcquisition DATETIME		= NULL --Default value as current date
		DECLARE @inp_nTransactionMasterId		BIGINT = 0		--Will be found if present in the master table else will be 0
		DECLARE @inp_sPreclearanceRequestId		BIGINT = null	--Default value null
		DECLARE @inp_iUserInfoId INT					--Find from given username
		DECLARE @inp_sNoHoldingFlag				bit = null		--Will be set based on the SecurityType value from the Excel
		DECLARE @inp_iDisclosureTypeCodeId		INT = 147001			--For Initial Disclosure
		DECLARE @inp_iTransactionStatusCodeId	INT = 148002			--Code for Not Confirmed value
		DECLARE @inp_iTradingPolicyId			INT = null			--Will have to find based on the applicable trading policy
			,@inp_dtPeriodEndDate			DATETIME = null		--NULL value
			,@inp_bPartiallyTradedFlag		bit = 0			-- Default value will not change
			,@inp_bSoftCopyReq				bit = 0			--Default Value 0
			,@inp_bHardCopyReq				bit = 0			--default Value 0
			,@inp_dtHCpByCOSubmission		DATETIME = null		-- NULL
			,@out_nDisclosureCompletedFlag	INT = 0 		-- 0 Default value
		
		--For Details
		DECLARE @inp_iDMATDetailsID INT = 0		--DEMAT DETAILS Id found
		DECLARE @inp_iTransactionDetailsId BIGINT		-- 0
		DECLARE @inp_iForUserInfoId INT	 = 0			--Will have to find this based on the Username, FirstNameLastName and the Relation in the excel
		DECLARE @inp_iCompanyId INT					--Find the implementation companyid
		DECLARE @inp_iTransactionTypeCodeId INT = 143001	--Can have default value	143001
		DECLARE @inp_iTransactionTypeSellCodeId INT = 143002	--	143002
		DECLARE @inp_dQuantity2 decimal(10, 0) = 0
				,@inp_dValue2 decimal(10, 0) = 0
				,@inp_iTransactionLetterId BIGINT	= NULL
		DECLARE @inp_dPerOfSharesPostTransaction decimal(5, 2) = 0		--Default value as 0
		
		DECLARE @out_nSavedTransactionMasterID BIGINT, @out_nSavedTransactionDetailsID BIGINT
		
		DECLARE @bSegragateESOPAndOtherExerciseOptionQuantityFlag bit = 0
		DECLARE @iESOPExerciseOptionQuantity INT = 0
		DECLARE @iOtherExerciseOptionQuantity INT =0
		DECLARE @bESOPExerciseOptionQuantityFlag bit = 0
		DECLARE @bOtherExerciseOptionQuantityFlag bit = 1
		DECLARE @sContractSpecification VARCHAR(50) = ''
		DECLARE @nMarketSellModeOfAcquasation INT  = 149010
		DECLARE @AllowedDEMATTable TABLE (DEMATID BIGINT, VALUE VARCHAR(200), Width VARCHAR(200))
		
		 
		DECLARE @nRC INT		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		--Check if userloginname is valid else give error message
		--Check if the PAN number is correct and is of the user else give error message
		--Check if it is for relative and Relativeis valid based on FirstNameLastName, userid, and relation else give error
		--Calculate Percent of the securities check how to calculate this value
		--Check if the details exist and Initial disclosure status is submitted then give error
		--Check if the details exist and Initial disclosure status is not submitted then delete the earlier one and add next.
		--Check the record exist based on login id if relation is Self or 0
		--For relatives check on the combination as discussed above
		
		--Check if the username is given is valid and find the userinfoid to be used further
		
		
		
		IF @inp_dQuantity < 0
		BEGIN
			SET @inp_iTransactionTypeCodeId = @inp_iTransactionTypeSellCodeId
			SET @inp_dQuantity  = @inp_dQuantity * -1
			SET @inp_iModeOfAcquisitionCodeId = @nMarketSellModeOfAcquasation
		END
		
		IF EXISTS(SELECT UserInfoID FROM usr_Authentication WHERE LoginID = @inp_sUserLoginName)
		BEGIN
			SELECT @inp_iUserInfoId = UserInfoID FROM usr_Authentication WHERE LoginID = @inp_sUserLoginName
		END
		ELSE
		BEGIN
			SELECT @out_nReturnValue = @ERROR_INVALIDUSERNAME
			
			RETURN @out_nReturnValue
		END
		--Check if the user has already confirmed the initial disclosure in this case change is not allowed,.
		IF EXISTS (SELECT * FROM tra_TransactionMaster WHERE UserInfoId = @inp_iUserInfoId AND DisclosureTypeCodeId = 147001 AND TransactionStatusCodeId > 148002)
		BEGIN
			SELECT @out_nReturnValue = @ERROR_INITIALDISCLOSURE_SUBMITTED
			
			RETURN @out_nReturnValue
		END
		IF @inp_iSecurityTypeCodeId <> 139000
		BEGIN
			--If the security flag is 0 then consider the case of NOHOLDINGS
			SELECT @inp_sNoHoldingFlag = 0
			--For finding the Relatives id
			IF @inp_nRelationCodeId = 100000   --For Self
			BEGIN
				SELECT @inp_iForUserInfoId = @inp_iUserInfoId
			END
			ELSE							--For Relatives
			BEGIN
				IF EXISTS  (SELECT RelativesList.UserInfoIdRelative from (
						SELECT UR.UserInfoIdRelative FROM usr_UserInfo UI 
						JOIN usr_UserRelation UR ON UR.UserInfoId = UI.UserInfoId
						WHERE UR.UserInfoId = @inp_iUserInfoId  
						AND UR.RelationTypeCodeId = @inp_nRelationCodeId
						AND LOWER(ISNULL(UI.FirstName,'') + ISNULL(UI.LastName,'')) = LOWER(REPLACE(@inp_sFirstLastName,' ',''))
						) AS RelativesList
					join usr_UserInfo UI ON UI.UserInfoid = RelativesList.UserInfoIdRelative)
				BEGIN
					SELECT @inp_iForUserInfoId = RelativesList.UserInfoIdRelative from (
						SELECT UR.UserInfoIdRelative FROM usr_UserInfo UI 
						JOIN usr_UserRelation UR ON UR.UserInfoId = UI.UserInfoId
						WHERE UR.UserInfoId = @inp_iUserInfoId  
						AND UR.RelationTypeCodeId = @inp_nRelationCodeId
						AND LOWER(ISNULL(UI.FirstName,'') + ISNULL(UI.LastName,'')) = LOWER(REPLACE(@inp_sFirstLastName,' ',''))
						) AS RelativesList
					join usr_UserInfo UI ON UI.UserInfoid = RelativesList.UserInfoIdRelative					
				END
				ELSE
				BEGIN
					SELECT @out_nReturnValue = @ERROR_RELATIVE_IS_INVALID
					
					RETURN @out_nReturnValue
				END
			END
			--For finding the DEMATDetails id
			IF @inp_nRelationCodeId = 100000
			BEGIN
				SELECT @inp_iDMATDetailsID = DM.DMATDetailsId FROM usr_DMATDetails DM
				JOIN usr_UserInfo UI on UI.UserInfoid = DM.UserInfoId
				WHERE UI.UserInfoId = @inp_iUserInfoId AND DM.DEMATAccountNumber = @inp_sDMATDetailsINo
			END
			ELSE
			BEGIN
				SELECT @inp_iDMATDetailsID = DM.DMATDetailsId FROM usr_DMATDetails DM
				JOIN usr_UserInfo UI on UI.UserInfoid = DM.UserInfoId
				WHERE UI.UserInfoId = @inp_iForUserInfoId  AND DM.DEMATAccountNumber = @inp_sDMATDetailsINo
			END
			IF @inp_iDMATDetailsID IS NULL OR @inp_iDMATDetailsID = 0
			BEGIN
				SELECT @out_nReturnValue = @ERROR_INVALIDDEMATNUMBER
				
				RETURN @out_nReturnValue
			END

			/*Check if the Provided DEMAT Number is amongst the allowed DEMAT accounts as per the configuration done at Company Level*/

			INSERT INTO @AllowedDEMATTable
			SELECT * from dbo.uf_com_GetApplicableDEMATList(@inp_iForUserInfoId, @inp_iDisclosureTypeCodeId, 0)

			IF(NOT EXISTS(SELECT DEMATID FROM @AllowedDEMATTable WHERE DEMATID = @inp_iDMATDetailsID))
			BEGIN
				SELECT @out_nReturnValue = @ERROR_UNCONFIGURED_DP_NAME
				
				RETURN @out_nReturnValue
			END
			/*Check if the Provided DEMAT Number is amongst the allowed DEMAT accounts as per the configuration done at Company Level*/
		END
		ELSE
		BEGIN
			SELECT @inp_sNoHoldingFlag = 1
			
		END	
		
		
		--Check if the userlogin name and PAN are matching for the same user else give error.
		IF NOT EXISTS(SELECT PAN FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId AND ISNULL(PAN,'') = ISNULL(@inp_sPANNumber,''))
		BEGIN
			SELECT @out_nReturnValue = @ERROR_PANNOTASSOCIATED_WITH_USERNAME
			
			RETURN @out_nReturnValue
		END
		--Find the applicable trading policy for the user. If none found then give corresponding error
		IF EXISTS (SELECT * FROM vw_ApplicableTradingPolicyForUser WHERE UserInfoId = @inp_iUserInfoId)
		BEGIN
			SELECT @inp_iTradingPolicyId = MAX(MaptoId) FROM vw_ApplicableTradingPolicyForUser 
			WHERE UserInfoId = @inp_iUserInfoId
			
			SELECT @out_nReturnValue = 0
		END
		ELSE
		BEGIN
			SELECT @out_nReturnValue = @ERROR_NO_TRADING_POLICY_ASSOCIATED_WITH_USER
			RETURN @out_nReturnValue
		END
		--Find the implementation companyid 
		SELECT @inp_iCompanyId = CompanyId FROM mst_Company WHERE IsImplementing = 1
		--If the transaction already exist then delete the Transaction details for the transaction.
		IF EXISTS(SELECT * FROM tra_TransactionMaster WHERE UserInfoId = @inp_iUserInfoId AND DisclosureTypeCodeId = @inp_iDisclosureTypeCodeId)
		BEGIN
			DELETE FROM tra_TransactionDetails 
			WHERE TransactionMasterId = (SELECT TransactionMasterId FROM tra_TransactionMaster WHERE UserInfoId = @inp_iUserInfoId AND DisclosureTypeCodeId = @inp_iDisclosureTypeCodeId)
			 AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsId = @inp_iDMATDetailsID AND ForUserInfoId = @inp_iForUserInfoId
		END
		 
		EXEC @nRC = dbo.st_tra_TradingTransactionMasterCreate_Override 0,@inp_sPreclearanceRequestId,@inp_iUserInfoId,@inp_iDisclosureTypeCodeId,@inp_iTransactionStatusCodeId	,@inp_sNoHoldingFlag,@inp_iTradingPolicyId,@inp_dtPeriodEndDate,@inp_bPartiallyTradedFlag,@inp_bSoftCopyReq,@inp_bHardCopyReq,@inp_dtHCpByCOSubmission,@inp_iLoggedInUserId,'MASSUPLOAD',NULL,0,0,@out_nSavedTransactionMasterID out, @out_nDisclosureCompletedFlag out,@out_nReturnValue out, @out_nSQLErrCode out, @out_sSQLErrMessage out
		IF (@out_nReturnValue = 0)
		BEGIN
		    IF @inp_sNoHoldingFlag = 0
			BEGIN
				IF @inp_iSecurityTypeCodeId = @SECURITY_TYPE_SHARES_CODEID
				BEGIN
					SELECT @iOtherExerciseOptionQuantity = @inp_dQuantity
				END
				EXEC st_tra_TradingTransactionSave_Override 0, @out_nSavedTransactionMasterID, @inp_iSecurityTypeCodeId,@inp_iForUserInfoId,@inp_iDMATDetailsID,@inp_iCompanyId,@inp_dSecuritiesPriorToAcquisition,@inp_dPerOfSharesPreTransaction,@inp_dtDateOfAcquisition ,@inp_dtDateOfInitimationToCompany ,@inp_iModeOfAcquisitionCodeId ,@inp_dPerOfSharesPostTransaction,@inp_iExchangeCodeId,@inp_iTransactionTypeCodeId,@inp_dQuantity,@inp_dValue,@inp_dQuantity2,@inp_dValue2,@inp_iTransactionLetterId ,@inp_iLotSize,@inp_dDateOfBecomingInsider ,@inp_iLoggedInUserId,'MASSUPLOAD',@bSegragateESOPAndOtherExerciseOptionQuantityFlag,@iESOPExerciseOptionQuantity,@iOtherExerciseOptionQuantity,@bESOPExerciseOptionQuantityFlag,@bOtherExerciseOptionQuantityFlag,@sContractSpecification,@out_nSavedTransactionDetailsID out,@out_nReturnValue out, @out_nSQLErrCode out, @out_sSQLErrMessage out 
			END
		END
		SELECT @out_nSavedTransactionMasterID
		
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = @out_nSQLErrCode --dbo.uf_com_GetErrorCode(@ERR_INITIALDISCLOSURE,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
