IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_MassUploadDMATDetailsSave')
DROP PROCEDURE [dbo].[st_usr_MassUploadDMATDetailsSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves demat details from mass upload.

Returns:		0, if Success.
				
Created by:		Parag
Created on:		06-Sept-2016

Modification History:
Modified By		Modified On		Description
Raghvendra		20-Sep-2016		Change to increase the DisplayCode column size from 50 to 1000
Usage:
EXEC st_usr_DMATDetailsSave 1, 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_MassUploadDMATDetailsSave]
	@inp_iUserInfoId				INT
	,@inp_iDMATDetailsID			INT OUTPUT
	,@inp_sDEMATAccountNumber		NVARCHAR(50)
	,@inp_sDPBank					NVARCHAR(200)
	,@inp_sDPID						VARCHAR(50)
	,@inp_sTMID						VARCHAR(50) 
	,@inp_sDescription				VARCHAR(200)
	,@inp_iAccountTypeCodeId		INT
    ,@inp_iLoggedInUserId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
IF(@inp_sDPBank IS NULL)
SET @inp_sDPBank = ''
IF(@inp_sDPID IS NULL)
SET @inp_sDPID = ''
IF(@inp_sTMID IS NULL)
SET @inp_sTMID = ''
	DECLARE @inp_iDPBankCodeId INT = NULL	-- set default value
	DECLARE @inp_iDmatAccStatusCodeId INT = 0

	DECLARE @DPBankNameList TABLE (DPBankCodeId INT, DPBank NVARCHAR(1000))
	
	DECLARE @ERR_PAN_NUMBER_FOR_DEMAT INT = 50593

	SET NOCOUNT ON;
	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0
	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0
	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = ''

	-- get list of DP bank name with code id
	INSERT INTO @DPBankNameList
	select CodeID as 'DPBankCodeId', lower(case when DisplayCode is null or DisplayCode = '' then CodeName else DisplayCode end) as 'DPBank' 
	from com_Code where CodeGroupId = 120

	-- get dp bank code id
	SELECT @inp_iDPBankCodeId = DPBankCodeId FROM @DPBankNameList WHERE DPBank = LOWER(@inp_sDPBank)

	-- check if DP bank code id is exists for bank name 
	IF (@inp_iDPBankCodeId IS NULL OR @inp_iDPBankCodeId = '')
	BEGIN
		SET @inp_iDPBankCodeId = NULL --set code to null
	END
	ELSE
	BEGIN
		SET @inp_sDPBank = ''
		SET @inp_iDPBankCodeId = @inp_iDPBankCodeId --set code to null
	END
	
	--Check PAN Number Entered or not for demat
	IF(@inp_sDEMATAccountNumber IS NOT NULL)
	BEGIN
		IF  (EXISTS(SELECT PAN FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId AND PAN IS NULL))
		  BEGIN
			   SET @out_nReturnValue = @ERR_PAN_NUMBER_FOR_DEMAT
			   RETURN (@out_nReturnValue)
		  END
	END
	
	-- save demat account details
	EXEC st_usr_DMATDetailsSave @inp_iUserInfoId, @inp_sDEMATAccountNumber, @inp_sDPBank, @inp_sDPID, @inp_sTMID, 
				@inp_sDescription, @inp_iAccountTypeCodeId, @inp_iLoggedInUserId, @inp_iDPBankCodeId, @inp_iDmatAccStatusCodeId, @inp_iDMATDetailsID, @out_nReturnValue, @out_nSQLErrCode, @out_sSQLErrMessage
		
END
