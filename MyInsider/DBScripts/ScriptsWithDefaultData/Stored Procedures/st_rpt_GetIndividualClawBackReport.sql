IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_GetIndividualClawBackReport')
DROP PROCEDURE [dbo].[st_rpt_GetIndividualClawBackReport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure for Get Individual ClawBack Report.

Returns:		0, if Success.
				
Created by:		Tushar Wakchaure
Created on:		24-July-2018

Usage:
GO
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_GetIndividualClawBackReport]
	 @inp_iPageSize									INT = 10
	,@inp_iPageNo									INT = 1
	,@inp_sSortField								VARCHAR(255) = NULL
	,@inp_sSortOrder								VARCHAR(5) = NULL
	,@inp_iUserInfoId								INT
	,@inp_sTransactionMasterId						INT
	,@inp_sSecurityTypeCodeID						INT
	,@inp_sTransactionTypeCodeID					INT 
	,@out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT	-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN

  DECLARE @sSQL	NVARCHAR(MAX)
  DECLARE @ERR_CLAWBACKREPORT	INT = 50708
  DECLARE @nTransactionMasterId INT
  DECLARE @nContraTradeTransactionTypeID INT
  DECLARE @nNoContraTradeTransactionTypeID INT
  DECLARE @nTransactionTypeID INT
  
  DECLARE @nDocument_Uploaded    INT = 148001
  DECLARE @nNot_Confirmed        INT = 148002
  DECLARE @nContinuousDisclosure INT = 147002 

 BEGIN TRY

	SET NOCOUNT ON;
		-- Declare variables
	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0
	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0
	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = ''

   
	IF @inp_sSortField IS NULL OR @inp_sSortField = '' OR @inp_sSortField = 'rpt_grd_50692'
	BEGIN
	    SET @inp_sSortField = 'UserInfoID'
	END
		
	IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
	BEGIN
		SET @inp_sSortOrder = 'ASC'
	END

    SET @nTransactionMasterId = @inp_sTransactionMasterId

    SELECT @nContraTradeTransactionTypeID = TransactionTypeCodeId FROM tra_TransactionDetails WHERE  SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionTypeCodeId = @inp_sTransactionTypeCodeID AND TransactionMasterId = @nTransactionMasterId 

    CREATE TABLE #tblClawBackReport(Id INT IDENTITY(1,1), UserInfoID INT, TransactionMasterId INT, SecurityTypeID INT, TransactionTypeID INT, DmatID VARCHAR(100), TransactionDate VARCHAR(100), Qty VARCHAR(100), Value VARCHAR(100), CurrencyId INT, Currency NVARCHAR(50))
    INSERT INTO #tblClawBackReport(UserInfoID, TransactionMasterId, SecurityTypeID, TransactionTypeID, DmatID, TransactionDate, Qty, Value, CurrencyID,Currency)
    SELECT ForUserInfoId, TD.TransactionMasterId, TD.SecurityTypeCodeId, TransactionTypeCodeId, DD.DEMATAccountNumber, DateOfAcquisition, Quantity, Value, CurrencyID, Currency.DisplayCode 
	FROM tra_TransactionDetails TD 
	JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId 
	JOIN usr_DMATDetails DD ON DD.DMATDetailsID = TD.DMATDetailsID
	LEFT JOIN  com_Code currency ON currency.CodeID = TD.CurrencyID
	WHERE TD.TransactionMasterId = @nTransactionMasterId AND TM.DisclosureTypeCodeId = @nContinuousDisclosure AND TM.TransactionStatusCodeId NOT IN (@nDocument_Uploaded, @nNot_Confirmed)

    SELECT @nTransactionMasterId = MAX(TransactionMasterId) FROM tra_TransactionDetails WHERE SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionMasterId < @nTransactionMasterId 
    SELECT @nNoContraTradeTransactionTypeID = TransactionTypeCodeId FROM tra_TransactionDetails WHERE SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionMasterId = @nTransactionMasterId 

	INSERT INTO #tblClawBackReport(UserInfoID, TransactionMasterId, SecurityTypeID, TransactionTypeID, DmatID, TransactionDate, Qty, Value, CurrencyID, Currency )
    SELECT ForUserInfoId, TD.TransactionMasterId, TD.SecurityTypeCodeId, TransactionTypeCodeId, DD.DEMATAccountNumber, DateOfAcquisition, Quantity, Value, CurrencyID, currency.DisplayCode 
	FROM tra_TransactionDetails TD
	JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId  
	JOIN usr_DMATDetails DD ON DD.DMATDetailsID = TD.DMATDetailsID
	LEFT JOIN com_Code currency ON currency.CodeID = TD.CurrencyID
	WHERE TD.TransactionMasterId = @nTransactionMasterId AND TM.DisclosureTypeCodeId = @nContinuousDisclosure AND TM.TransactionStatusCodeId NOT IN (@nDocument_Uploaded, @nNot_Confirmed)
	
    START: 
	IF EXISTS (SELECT * FROM tra_TransactionDetails WHERE SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionMasterId < @nTransactionMasterId AND (ForUserInfoId = @inp_iUserInfoId OR ForUserInfoId IN (SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoId = @inp_iUserInfoId)))
    BEGIN              
         SELECT @nTransactionMasterId = MAX(TransactionMasterId) FROM tra_TransactionDetails WHERE SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionMasterId < @nTransactionMasterId AND (ForUserInfoId = @inp_iUserInfoId OR ForUserInfoId IN (SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoId = @inp_iUserInfoId))
		 SELECT @nTransactionTypeID = TransactionTypeCodeId FROM tra_TransactionDetails WHERE SecurityTypeCodeId = @inp_sSecurityTypeCodeID AND TransactionMasterId = @nTransactionMasterId AND (ForUserInfoId = @inp_iUserInfoId OR ForUserInfoId IN (SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoId = @inp_iUserInfoId))
		 IF NOT (@nTransactionTypeID <> @nNoContraTradeTransactionTypeID)
         BEGIN
           INSERT INTO #tblClawBackReport(UserInfoID,TransactionMasterId, SecurityTypeID, TransactionTypeID, DmatID, TransactionDate, Qty, Value, CurrencyID, Currency)
           SELECT ForUserInfoId, TD.TransactionMasterId, TD.SecurityTypeCodeId, TransactionTypeCodeId, DD.DEMATAccountNumber, DateOfAcquisition, Quantity, Value, CurrencyID, currency.DisplayCode 
		   FROM tra_TransactionDetails TD
		   JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
		   JOIN usr_DMATDetails DD ON DD.DMATDetailsID = TD.DMATDetailsID 
		   LEFT JOIN com_Code currency ON currency.CodeID = TD.CurrencyID
		   WHERE TD.TransactionMasterId = @nTransactionMasterId AND TM.DisclosureTypeCodeId = @nContinuousDisclosure AND TM.TransactionStatusCodeId NOT IN (@nDocument_Uploaded, @nNot_Confirmed)
           GOTO START;
         END
    END

	SELECT @sSQL = ' INSERT INTO #tmpList(RowNumber, EntityID) '
    SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',Id),Id ' 
    SELECT @sSQL = @sSQL + ' FROM #tblClawBackReport Temp '
	EXEC (@sSQL)

    SELECT
	CASE WHEN codeRelation.CodeName IS NULL THEN 'Self' ELSE codeRelation.CodeName END AS rpt_grd_50692,
	UI.PAN AS rpt_grd_50693,
	Temp.DmatID AS rpt_grd_50694,
	sTransactionTypeID.CodeName AS rpt_grd_50695, 
	dbo.uf_rpt_FormatDateValue(Temp.TransactionDate,0) AS rpt_grd_50696,
	Temp.Qty AS rpt_grd_50697,
	Temp.Value AS rpt_grd_50699,
	Temp.Currency as rpt_grd_54229
	FROM	#tmpList T 
	JOIN #tblClawBackReport  Temp ON T.EntityID = Temp.Id
	JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = Temp.TransactionMasterId
	JOIN usr_UserInfo UI ON UI.UserInfoId = TM.UserInfoID
	LEFT JOIN com_Code sTransactionTypeID ON sTransactionTypeID.CodeID = Temp.TransactionTypeID
	LEFT JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoIdRelative
	LEFT JOIN com_Code codeRelation ON UR.RelationTypeCodeId = codeRelation.CodeID
	LEFT JOIN com_Code Currency ON Currency.CodeID = Temp.CurrencyID
	WHERE ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))

 END TRY
	
 BEGIN CATCH		
		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CLAWBACKREPORT
 END CATCH

END