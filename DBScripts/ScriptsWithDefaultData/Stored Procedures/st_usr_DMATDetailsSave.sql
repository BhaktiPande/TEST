IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DMATDetailsSave')
DROP PROCEDURE [dbo].[st_usr_DMATDetailsSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves demat details for Employee / Non-Employee type user.

Returns:		0, if Success.
				
Created by:		Swapnil M
Created on:		06-Aug-2010

Modification History:
Modified By		Modified On		Description
Ashish			03-Mar-2015		Added AccountTypeCodeId
Ashish			23-Mar-2015		Return DMATDetailID while saving  details
Ashish			26-Jun-2015		Added User Corporate 
AniketS/Gaurav	26-May-2016		Set condition for avoid duplicate DMAT details
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_usr_DMATDetailsSave 1, 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DMATDetailsSave]
	@inp_iUserInfoId				INT
	,@inp_sDEMATAccountNumber		NVARCHAR(50)
	,@inp_sDPBank					NVARCHAR(200)
	,@inp_sDPID						VARCHAR(50)
	,@inp_sTMID						VARCHAR(50)
	,@inp_sDescription				VARCHAR(200)
	,@inp_iAccountTypeCodeId		INT=NULL
    ,@inp_iLoggedInUserId			INT
	,@inp_iDPBankCodeId				INT = NULL
	,@inp_iDmatAccStatusCodeId      INT 
	,@inp_iDMATDetailsID			INT = 0 OUTPUT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_DEMAT_SAVE INT = 11036	-- Error occurred while saving demat details.
	DECLARE @ERR_DEMATINFO_NOTFOUND INT = 11037	-- Demat details does not exist.
	DECLARE @ERR_USERNOTVALIDFORDEMATDETAILS INT = 11038 -- Cannot save Demat details. To save Demat details, user should be of type employee or non-employee.
	
	DECLARE --@nUserType_CO INT = 101002,
			@nUserType_Employee INT = 101003,
			--@nUserType_CorporateUser INT = 101004,
			@nUserType_NonEmployee INT = 101006,
			@nUserType_Relative INT = 101007,
			@nUserType_Corporate INT = 101004
    
	DECLARE @out_PendingPeriodEndCount INT = 0
	DECLARE @out_PendingTransactionsCountPNT INT = 0
	DECLARE @out_PendingTransactionsCountPCL INT = 0
    DECLARE @nTransactionStatusNoSubmitted INT = 148002 



	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF NOT EXISTS(SELECT USER FROM usr_UserInfo 
					WHERE UserInfoId = @inp_iUserInfoId 
						AND UserTypeCodeId IN (@nUserType_Employee, @nUserType_NonEmployee, @nUserType_Relative, @nUserType_Corporate))
		BEGIN
			SET @out_nReturnValue = @ERR_USERNOTVALIDFORDEMATDETAILS
			RETURN @out_nReturnValue
		END
		
		IF (@inp_iDmatAccStatusCodeId = 0 )
		BEGIN
		set @inp_iDmatAccStatusCodeId = 102001
		END
		IF (@inp_iAccountTypeCodeId IS NULL OR @inp_iAccountTypeCodeId = '')
		BEGIN
		set @inp_iAccountTypeCodeId = 121001
		END
		IF (@inp_sDescription IS NULL)
		BEGIN
		set @inp_sDescription = ''
		END
		IF @inp_iDMATDetailsID = 0
		BEGIN
				IF NOT EXISTS(SELECT DEMATAccountNumber FROM usr_DMATDetails WHERE DEMATAccountNumber = @inp_sDEMATAccountNumber AND DPID = @inp_sDPID)
			BEGIN
				-- Insert new record
				INSERT INTO usr_DMATDetails
					(UserInfoID, DEMATAccountNumber, DPBank, DPID, TMID, Description, AccountTypeCodeId,
					CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, DPBankCodeId, DmatAccStatusCodeId)
				VALUES
					(@inp_iUserInfoId, @inp_sDEMATAccountNumber, @inp_sDPBank, @inp_sDPID, @inp_sTMID, @inp_sDescription, @inp_iAccountTypeCodeId,
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iDPBankCodeId, @inp_iDmatAccStatusCodeId)			
							
				SET @inp_iDMATDetailsID = SCOPE_IDENTITY()
				UPDATE usr_UserInfo SET DoYouHaveDMATEAccountFlag = 1 WHERE UserInfoId = @inp_iUserInfoId;
			END
			ELSE
			BEGIN
				SET @inp_iDMATDetailsID = 0
				SELECT @inp_iDMATDetailsID AS DMATDetailsID
				RETURN 0
			END
		END
		ELSE
		BEGIN			
			--Check if the UserInfo whose details are being updated exists
			IF (NOT EXISTS(SELECT DMATDetailsID FROM usr_DMATDetails WHERE DMATDetailsID = @inp_iDMATDetailsID))
			BEGIN		
				SET @out_nReturnValue = @ERR_DEMATINFO_NOTFOUND
				RETURN (@out_nReturnValue)
			END

			SELECT @out_PendingPeriodEndCount = COUNT(TransactionMasterId)
		    FROM tra_TransactionMaster
		    WHERE UserInfoId = @inp_iUserInfoID AND DisclosureTypeCodeId = 147003 AND TransactionStatusCodeId <= 148002 
		
			
            SELECT @out_PendingTransactionsCountPNT = COUNT(TM.TransactionMasterId )
						FROM tra_TransactionDetails TD
						JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
						WHERE (ForUserInfoId = @inp_iUserInfoId OR ForUserInfoId IN (SELECT UR.UserInfoIdRelative FROM usr_UserRelation UR JOIN usr_UserInfo UI ON UI.UserInfoId = UR.UserInfoId WHERE UI.UserInfoId = @inp_iUserInfoId))
						AND TM.TransactionStatusCodeId = @nTransactionStatusNoSubmitted 
						AND TD.SecurityTypeCodeId IN(139001,139002,139003,139004,139005) AND TM.PreclearanceRequestId IS NULL
			
			
            SELECT @out_PendingTransactionsCountPCL = COUNT(PreclearanceRequestId) 
					FROM tra_PreclearanceRequest
					WHERE IsPartiallyTraded = 1 AND (UserInfoId = @inp_iUserInfoId OR UserInfoIdRelative IN (SELECT UR.UserInfoIdRelative FROM usr_UserRelation UR JOIN usr_UserInfo UI ON UI.UserInfoId = UR.UserInfoId WHERE UI.UserInfoId = @inp_iUserInfoId)) 
								AND SecurityTypeCodeId IN(139001,139002,139003,139004,139005)
								AND PreclearanceStatusCodeId <> 144003
								AND ReasonForNotTradingCodeId IS NULL

        IF(@out_PendingTransactionsCountPNT > 0 OR @out_PendingTransactionsCountPCL > 0)
		BEGIN
		   SELECT @out_PendingPeriodEndCount AS PendingPeriodEndCount, @out_PendingTransactionsCountPNT AS PendingTransactionsCountPNT, @out_PendingTransactionsCountPCL AS PendingTransactionsCountPCL
		END
		ELSE
		BEGIN
			-- Update existing details
			IF NOT EXISTS(SELECT DEMATAccountNumber FROM usr_DMATDetails WHERE DEMATAccountNumber = @inp_sDEMATAccountNumber AND DMATDetailsID <> @inp_iDMATDetailsID)
			BEGIN
				UPDATE usr_DMATDetails
				SET DEMATAccountNumber = @inp_sDEMATAccountNumber,
					DPBank = @inp_sDPBank,
					DPID = @inp_sDPID,
					TMID = @inp_sTMID,
					Description = @inp_sDescription,
					AccountTypeCodeId = @inp_iAccountTypeCodeId,
					ModifiedBy = @inp_iLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate(),
					DPBankCodeId = @inp_iDPBankCodeId,
					DmatAccStatusCodeId = @inp_iDmatAccStatusCodeId
				WHERE DMATDetailsID = @inp_iDMATDetailsID
			END
			ELSE
			BEGIN
				SET @inp_iDMATDetailsID = 0
				SELECT @inp_iDMATDetailsID AS DMATDetailsID
				RETURN 0
			END
		 END	
		END
		
		--SELECT @inp_iDMATDetailsID AS DMATDetailsID, @out_PendingPeriodEndCount AS PendingPeriodEndCount, @out_PendingTransactionsCountPNT AS PendingTransactionsCountPNT, @out_PendingTransactionsCountPCL AS PendingTransactionsCountPCL
		SELECT @inp_iDMATDetailsID AS DMATDetailsID	
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_DEMAT_SAVE,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
