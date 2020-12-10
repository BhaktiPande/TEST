IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_CheckDuplicateTransaction')
DROP PROCEDURE [dbo].[st_tra_CheckDuplicateTransaction]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to check whether transactions are duplicate or not according to Security type, transaction type and transaction date.

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		23-Jan-2018
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_CheckDuplicateTransaction]
	@inp_iUserInfoId            INT 
	,@inp_iSecurityType         INT 
	,@inp_iTransactionType      INT 
	,@inp_iTransactionDate      DATETIME 
	,@inp_iTransactionId        INT--On 1.submit:transactionMasterId  2.save:0 3.edit:transactionDetailsId
	,@out_nReturnValue		    INT = 0 OUTPUT
	,@out_nSQLErrCode		    INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage        NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @DisclosureType_Continuous INT = 147002
	DECLARE @SecurityTypeCodeId INT
	DECLARE @TransactionTypeCodeId INT
	DECLARE @TransactionDate DATE
	DECLARE @FLAG INT = 1
	DECLARE @UserInfoId INT
	DECLARE @TransactionDetailId INT
	DECLARE @UserTypeID INT
	DECLARE @UserType_Relative INT = 101007
	DECLARE @UserID INT
	
	CREATE TABLE #TempRelatives(UserInfoId INT)
	CREATE TABLE #TempDetails(Id INT IDENTITY(1,1),TransactionDetailsID INT, UserInfoID INT, SecurityType INT, TransactionType INT,DateOfAcquisition DATETIME)
	CREATE TABLE #TempDuplicateRecords(TransactionStatus INT, TransactionType INT, SecurityType INT, DateOfAcquisition DATE, Quantity DECIMAL(10,0), Value DECIMAL(10,0)
						,DMATAccountNo NVARCHAR(50),DPID VARCHAR(50),DPName NVARCHAR(200),TMID VARCHAR(50), TransactionID INT, ModeOfAcquisition INT, ExchangeCode INT,Relation VARCHAR(50),transactionDetailId INT)
	CREATE TABLE #FinalDuplicateRecords(TransactionStatus INT, TransactionType INT, SecurityType INT, DateOfAcquisition DATE, Quantity DECIMAL(10,0), Value DECIMAL(10,0)
						,DMATAccountNo NVARCHAR(50),DPID VARCHAR(50),DPName NVARCHAR(200),TMID VARCHAR(50), TransactionID INT, ModeOfAcquisition INT, ExchangeCode INT,Relation VARCHAR(50),transactionDetailId INT)
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		SELECT @UserTypeID = UserTypeCodeId FROM usr_UserInfo 
		WHERE UserInfoId = (CASE WHEN @inp_iUserInfoId = 0 
		THEN (SELECT UserInfoId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionId)
		ELSE @inp_iUserInfoId END)
		print @UserTypeID
		IF(@UserTypeID <> @UserType_Relative)
		BEGIN
			INSERT INTO #TempRelatives(UserInfoId)
			SELECT UR.UserInfoIdRelative FROM usr_UserInfo U
			LEFT JOIN usr_UserRelation UR ON U.UserInfoId = UR.UserInfoId 
			WHERE U.UserInfoId = (CASE WHEN @inp_iUserInfoId = 0 
			THEN (SELECT UserInfoId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionId)
			ELSE @inp_iUserInfoId END)
			
			SELECT @UserID = (CASE WHEN @inp_iUserInfoId = 0 
			THEN (SELECT UserInfoId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionId)
			ELSE @inp_iUserInfoId END)
			
			INSERT INTO #TempRelatives(UserInfoId) VALUES (@UserID)
		END
		ELSE
		BEGIN
			INSERT INTO #TempRelatives(UserInfoId)		
			SELECT UR.UserInfoIdRelative FROM usr_UserInfo U
			LEFT JOIN usr_UserRelation UR ON U.UserInfoId = UR.UserInfoId 
			WHERE U.UserInfoId=(SELECT UserInfoId FROM usr_UserRelation where UserInfoIdRelative = @inp_iUserInfoId)
			
			SELECT @UserID = UserInfoId FROM usr_UserRelation where UserInfoIdRelative = (CASE WHEN @inp_iUserInfoId = 0 
			THEN (SELECT UserInfoId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionId)
			ELSE @inp_iUserInfoId END)
			
			INSERT INTO #TempRelatives(UserInfoId) VALUES (@UserID)
		END
		SET @UserID = NULL
				
		IF @inp_iSecurityType <> 0 AND @inp_iTransactionType <> 0
		BEGIN
			IF EXISTS(SELECT TM.TransactionStatusCodeId FROM tra_TransactionDetails TD
							 JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
							 WHERE TM.DisclosureTypeCodeId = @DisclosureType_Continuous
							 AND TD.SecurityTypeCodeId = @inp_iSecurityType
							 AND TD.TransactionTypeCodeId = @inp_iTransactionType
							 AND CONVERT(DATE,TD.DateOfAcquisition) =  CONVERT(DATE,@inp_iTransactionDate)
							 AND TD.ForUserInfoId IN (SELECT * FROM #TempRelatives))
			BEGIN
				SELECT TM.TransactionStatusCodeId AS TransactionStatus,TD.TransactionTypeCodeId AS TransactionType,
				TD.SecurityTypeCodeId AS SecurityType,TD.DateOfAcquisition AS DateOfAcquisition,TD.Quantity AS Quantity,
				TD.Value AS Value,UD.DEMATAccountNumber AS DMATAccountNo,UD.DPID AS DPID,UD.DPBank AS DPName,UD.TMID AS TMID
				,TM.TransactionMasterID AS TransactionMasterID,TD.ModeOfAcquisitionCodeId AS ModeOfAcquisition,
				TD.ExchangeCodeId AS ExchangeCode, CASE WHEN TM.UserInfoId = TD.ForUserInfoId THEN 'Self' ELSE CRelation.CodeName END AS Relation
				FROM tra_TransactionDetails TD
							 JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
							 JOIN usr_DMATDetails UD ON UD.DMATDetailsID=TD.DMATDetailsID
							 LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative
							 LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
							 WHERE TM.DisclosureTypeCodeId = @DisclosureType_Continuous
							 AND TD.SecurityTypeCodeId = @inp_iSecurityType
							 AND TD.TransactionTypeCodeId = @inp_iTransactionType
							 AND CONVERT(DATE,TD.DateOfAcquisition) =  CONVERT(DATE,@inp_iTransactionDate)
							 AND TD.ForUserInfoId IN (SELECT * FROM #TempRelatives)
							 AND TD.TransactionDetailsId NOT IN (@inp_iTransactionId)
							 ORDER BY TD.TransactionDetailsId DESC
			END
		END
		ELSE
		BEGIN
			INSERT INTO #TempDetails(TransactionDetailsID, UserInfoID, SecurityType, TransactionType,DateOfAcquisition)
			SELECT TD.TransactionDetailsId, TD.ForUserInfoId, TD.SecurityTypeCodeId, TD.TransactionTypeCodeId,TD.DateOfAcquisition FROM tra_TransactionMaster TM
			JOIN tra_TransactionDetails TD ON TD.TransactionMasterId = TM.TransactionMasterId 
			WHERE TM.TransactionMasterId=@inp_iTransactionId AND TM.DisclosureTypeCodeId = @DisclosureType_Continuous
						
			DECLARE @COUNT INT
			SELECT @COUNT=COUNT(Id) FROM #TempDetails
			
			WHILE @FLAG <=@COUNT
			BEGIN
				SELECT @TransactionDetailId=TransactionDetailsID, @UserInfoId=UserInfoID , @SecurityTypeCodeId=SecurityType,@TransactionTypeCodeId = TransactionType,@TransactionDate=DateOfAcquisition FROM #TempDetails WHERE Id= @FLAG 
								
				INSERT INTO #TempDuplicateRecords(TransactionStatus, TransactionType, SecurityType, DateOfAcquisition, Quantity, Value, DMATAccountNo, DPID, DPName, TMID, TransactionID, ModeOfAcquisition, ExchangeCode,Relation,transactionDetailId)
				SELECT TM.TransactionStatusCodeId,TD.TransactionTypeCodeId,TD.SecurityTypeCodeId,CONVERT(DATE,TD.DateOfAcquisition),TD.Quantity,
				TD.Value,UD.DEMATAccountNumber,UD.DPID,UD.DPBank,UD.TMID,TM.TransactionMasterId,TD.ModeOfAcquisitionCodeId,TD.ExchangeCodeId,
				CASE WHEN TM.UserInfoId = TD.ForUserInfoId THEN 'Self' ELSE CRelation.CodeName END AS Relation,td.TransactionDetailsId
				FROM tra_TransactionDetails TD
							 JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
							 JOIN usr_DMATDetails UD ON UD.DMATDetailsID=TD.DMATDetailsID
							 LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative
							 LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
							 WHERE TM.DisclosureTypeCodeId = @DisclosureType_Continuous
							 AND TD.SecurityTypeCodeId = @SecurityTypeCodeId
							 AND TD.TransactionTypeCodeId = @TransactionTypeCodeId
							 AND CONVERT(DATE,TD.DateOfAcquisition) =  CONVERT(DATE,@TransactionDate)
							 AND TD.ForUserInfoId IN (SELECT * FROM #TempRelatives)
							 AND TD.TransactionDetailsId <> @TransactionDetailId
							 ORDER BY TD.TransactionDetailsId DESC
							 
				SET @FLAG = @FLAG +1
			END
			INSERT INTO #FinalDuplicateRecords(TransactionStatus, TransactionType, SecurityType, DateOfAcquisition, Quantity, Value, DMATAccountNo, DPID, DPName, TMID, TransactionID, ModeOfAcquisition, ExchangeCode,Relation,transactionDetailId)
			SELECT  DISTINCT * FROM #TempDuplicateRecords
				
			SELECT TransactionStatus, TransactionType, SecurityType, DateOfAcquisition, Quantity, Value, DMATAccountNo, DPID, DPName, TMID, TransactionID, ModeOfAcquisition, ExchangeCode,Relation FROM #FinalDuplicateRecords
						
			DROP TABLE #TempDetails
			DROP TABLE #TempDuplicateRecords
			DROP TABLE #FinalDuplicateRecords
			DROP TABLE #TempRelatives
		END
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  0
	END CATCH
END