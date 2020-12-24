IF(OBJECT_ID('st_rnt_MassUploadDetails','P') IS NOT NULL)
	DROP PROCEDURE [dbo].[st_rnt_MassUploadDetails]
GO

/*-------------------------------------------------------------------------------------------------
Description:	Save Register and Transfer Massupload data into rnt_MassUploadDetails.

Returns:		0, if Success.
				
Created by:		Santosh P
Created on:		04-Nov-2015
ModifiedBy	Modified ON		Comment
ED			04-Jan-2016		Code merging done on 4-Jan-2016
ED			4-Feb-2016	Code integration done on 4-Feb-2016
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rnt_MassUploadDetails]
	 @PANNumber			VARCHAR(50)
	,@SecurityType		VARCHAR(50)
	,@DPID				VARCHAR(50)
	,@ClientId			VARCHAR(50)
	,@DematAccount		VARCHAR(50)
	,@UserInfoId		VARCHAR(50)
	,@EmployeeName		NVARCHAR(200) 
	,@Shares			VARCHAR(50)
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT			  -- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_RNT_SAVE INT = 11036	-- Error occurred while saving demat details.
	DECLARE @ERR_PANINFO_NOTFOUND INT = 11037	-- Demat details does not exist.
	DECLARE @ERR_USERNOTVALIDFORDEMATDETAILS INT = 11038 -- Cannot save Demat details. To save Demat details, user should be of type employee or non-employee.
	DECLARE @DATE DATETIME	
	DECLARE @PAN_ALPHA_PREFIX VARCHAR(10),@PAN_ALPHA_DIGITS VARCHAR(10),@PAN_ALPHA_SUFFIX VARCHAR(10),@RESULT INT
	DECLARE @DBNAME VARCHAR(100) = UPPER((SELECT DB_NAME()))
	DECLARE @FIND_AIRTEL VARCHAR(50) = 'Vigilante_Airtel'

	BEGIN TRY
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
			----print @PANNumber		
			----print @SecurityType	
			----print @DPID			
			----print @ClientId		
			----print @DematAccount	
			----print @UserInfoId	
			----print @EmployeeName	
			----print @Shares
			
		
		IF NOT((ISNUMERIC(@Shares) = 1) OR (@Shares IS NULL) OR (@Shares = ''))
		BEGIN
			SELECT 1
			SET @out_nReturnValue = 50023
			SET @out_nSQLErrCode    =  1
			SET @out_sSQLErrMessage =  'Invalid value provided for holding'
			RETURN (@out_nReturnValue)
		END
		
		/* PAN VALIDATION */
		SELECT @PAN_ALPHA_PREFIX = CASE WHEN (LEFT(@PANNumber, 5)) LIKE '%[0-9]%' THEN 0 ELSE 1 END,
			   @PAN_ALPHA_DIGITS = ISNUMERIC(SUBSTRING(@PANNumber, 6, 4)),
			   @PAN_ALPHA_SUFFIX = ISNUMERIC(RIGHT(@PANNumber, 1))
		 IF NOT (@PAN_ALPHA_PREFIX = 1 AND @PAN_ALPHA_DIGITS = 1 AND @PAN_ALPHA_SUFFIX = 0 AND LEN(@PANNumber) = 10)
		 BEGIN
			SELECT 1
			SET @out_nReturnValue = 50024
			SET @out_nSQLErrCode    =  1
			SET @out_sSQLErrMessage =  'Invalid PAN Card Number.'
			RETURN (@out_nReturnValue)
		 END
		 
		/* DIFFERENT RECORDS WITH SAME SECURITY TYPE AND SAME PAN VALIDATION */		
		IF NOT ((SELECT COUNT(RntInfoId) FROM rnt_MassUploadDetails WHERE PANNumber = @PANNumber AND SecurityType = @SecurityType AND DPID = @DPID AND DematAccountNo = @DematAccount) = 0) 
		BEGIN
			SELECT 1
			SET @out_nReturnValue = 50025
			SET @out_nSQLErrCode    =  1
			SET @out_sSQLErrMessage =  'Multiple time same record are not allowed'
			RETURN (@out_nReturnValue)
		END
		
		/* SECURITY TYPE VALIDATION */		
		SELECT @RESULT = PATINDEX('%[0-9]%', @SecurityType) 
		IF NOT (@RESULT = 0)
		BEGIN
			SELECT 1
			SET @out_nReturnValue = 50035
			SET @out_nSQLErrCode    =  1
			SET @out_sSQLErrMessage =  'Invalid value provided for Security Type'
			RETURN (@out_nReturnValue)
		END

		declare @sSecurityTypeshare varchar(50)=null
		declare @sSecurityTypeWarrants varchar(50)=null

		IF(@DBNAME = @FIND_AIRTEL)
			BEGIN
				set @sSecurityTypeshare='Equity Shares'
				set @sSecurityTypeWarrants='Preference Shares'
			END
		ELSE
			BEGIN
				set @sSecurityTypeshare='Shares'
				set @sSecurityTypeWarrants='Warrants'
			END
		
		
		INSERT INTO rnt_MassUploadDetails
		(RntUploadDate,PANNumber,SecurityType,SecurityTypeCode,DPID,ClientId,DematAccountNo,UserInfoId,
			UserName, Shares ,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		SELECT 
			dbo.uf_com_GetServerDate(),@PANNumber,@SecurityType,
			CASE WHEN @SecurityType = @sSecurityTypeshare THEN 139001
				 WHEN @SecurityType = @sSecurityTypeWarrants THEN 139002
				 WHEN 'Convertible Debentures' like '%'+@SecurityType+'%' THEN 139003
				 WHEN 'Future Contracts' like '%'+@SecurityType+'%' THEN 139004
				 WHEN 'Option Contracts' like '%'+@SecurityType+'%' THEN 139005
			END AS SecurityTypeCode,
			@DPID, @ClientId, @DematAccount,@UserInfoId,
			@EmployeeName,CASE WHEN ((@Shares = null) OR (@Shares = '')) THEN NULL ELSE @Shares END ,1,dbo.uf_com_GetServerDate(),1,dbo.uf_com_GetServerDate()		
			
			SELECT TOP 1 @DATE = CONVERT(DATE,CreatedOn) FROM rnt_MassUploadDetails ORDER BY RntInfoId DESC
			/* INSERT RnT REPORT DATA INTO MassUploadHistory TABLE */
			IF EXISTS (SELECT 1 FROM rnt_MassUploadHistory WHERE CONVERT(DATE,RntUploadDate) = CONVERT(DATE,@DATE))
			BEGIN
				DELETE FROM rnt_MassUploadHistory WHERE CONVERT(DATE,RntUploadDate) = CONVERT(DATE,@DATE)
			END
			
			EXEC st_RnTReport 
			
		SELECT 1 
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END TRY
	BEGIN CATCH
		SELECT 1
		SET @out_nReturnValue = ERROR_NUMBER()
		RETURN @out_nReturnValue
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue = @out_nSQLErrCode
	END CATCH
END