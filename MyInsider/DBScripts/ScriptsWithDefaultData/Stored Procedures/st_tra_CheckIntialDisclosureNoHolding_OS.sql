
/*
	Created By  :	Shubhangi Gurude
	Created On  :   09-Mar-2019
	Description :	This stored Procedure is used to get no holding Demat account 
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_CheckIntialDisclosureNoHolding_OS')
	DROP PROCEDURE st_tra_CheckIntialDisclosureNoHolding_OS
GO
CREATE PROCEDURE [dbo].[st_tra_CheckIntialDisclosureNoHolding_OS]
  	 @inp_iTransactionMasterId		INT							
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_GROUPVALUES_GETDETAILS INT = 50440 -- Error occurred while fetching code details.
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
			
	  
		DECLARE @inp_UserInfoID INT=0
		SELECT @inp_UserInfoID=UserInfoId FROM tra_TransactionMaster_OS WHERE TransactionMasterId=@inp_iTransactionMasterId

		CREATE TABLE #tmpUserId
		(
		ID INT IDENTITY(1,1),
		nUserInfoId INT
		)

		INSERT INTO #tmpUserId
		SELECT @inp_UserInfoID
		UNION
		SELECT UserInfoIdRelative FROM usr_UserRelation WHERE UserInfoId=@inp_UserInfoID
				
		SELECT 
			DMATDetailsID,ISNULL(DEMATAccountNumber,'NA') AS DMATAccountNo,	
			ISNULL(CASE WHEN DPBankCodeId IS NULL THEN DPBank ELSE codeDPBank.CodeName END,'NA') AS DPName,
			ISNULL(DPID,'NA') AS DPID,UI.UserInfoID, 
			CASE WHEN UI.UserTypeCodeId <> 101007 THEN 'Self' ELSE 'Relative' END AS UserType,
			ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.MiddleName,'') + ' ' + ISNULL(UI.LastName,'') AS UserName
		FROM 
			usr_DMATDetails UDMAT
			LEFT JOIN com_Code codeDPBank on codeDPBank.CodeID=UDMAT.DPBankCodeId
			RIGHT JOIN usr_UserInfo UI ON UI.UserInfoId=UDMAT.UserInfoID	
			WHERE UDMAT.UserInfoID IN(SELECT nUserInfoId FROM #tmpUserId)
			AND DMATDetailsID NOT IN(SELECT DMATDetailsID FROM tra_TransactionDetails_OS TD_OS WHERE TD_OS.TransactionMasterId=@inp_iTransactionMasterId)
			AND UDMAT.DmatAccStatusCodeId=102001	
		UNION
			
		SELECT 
			NULL AS DMATDetailsID,'NA' AS DMATAccountNo,	
			'NA' AS DPName,
			'NA' AS DPID,
			UI.UserInfoID, 
			CASE WHEN UI.UserTypeCodeId <> 101007 THEN 'Self' ELSE 'Relative' END AS UserType,
			ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.MiddleName,'') + ' ' + ISNULL(UI.LastName,'') AS UserName
		FROM 		
			usr_UserInfo UI
			LEFT JOIN usr_DMATDetails UDMAT
			ON UI.UserInfoId=UDMAT.UserInfoID
			WHERE UI.UserInfoID IN(SELECT nUserInfoId FROM #tmpUserId)
			AND UI.UserInfoId NOT IN(SELECT ForUserInfoId FROM tra_TransactionDetails_OS TD_OS)
			AND (UDMAT.DMATDetailsID IS NULL OR UDMAT.DmatAccStatusCodeId=102002)
	
		DROP TABLE #tmpUserId
	   	   
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_GROUPVALUES_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END
