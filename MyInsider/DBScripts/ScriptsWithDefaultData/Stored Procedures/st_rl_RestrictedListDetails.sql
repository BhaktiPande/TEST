IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rl_RestrictedListDetails')
	DROP PROCEDURE st_rl_RestrictedListDetails
GO
-- ======================================================================================
-- Author      : Gaurav Ugale															=
-- CREATED DATE: 10-SEP-2015                                                 			=
-- Description : THIS PROCEDURE FETCH THE RESTRICTED COMPANY LIST DETAILS				=
--																						=		
--				 EXEC st_rl_RestrictedListDetails 'DETAILS'								=
-- ======================================================================================



CREATE PROCEDURE [dbo].[st_rl_RestrictedListDetails]
(
	@inp_sAction			VARCHAR(50),
	@inp_sDetails			VARCHAR(300) = NULL ,
	@inp_sCompanyName		VARCHAR(300) = '' ,
	@inp_sISINCode			VARCHAR(300) = '' ,
	@inp_sBSECode			VARCHAR(300) = '' ,
	@inp_sNSECode			VARCHAR(300) = '' ,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT    -- Output SQL Error Message, if error occurred.	
)
AS
BEGIN
	
	DECLARE @ERR_NOTIFICATIONQUEUE_GETDETAILS INT

	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0

	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0

	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = ''

		DECLARE @inp_sDetails1 NVARCHAR(50)
		DECLARE @iISINCode nvarchar(50)
		
		create table #tmpTable
		(
		ID int identity(1,1),
		nCompString Varchar(Max)
		)
		insert into #tmpTable
		select * from FN_VIGILANTE_SPLIT(@inp_sDetails,'-(')

		--SELECT * FROM #tmpTable;
		
		--SELECT TOP 1 * FROM #tmpTable;
		
		SELECT TOP 1 @inp_sDetails = nCompString FROM #tmpTable
		SELECT TOP 1 @inp_sDetails1 = nCompString FROM #tmpTable ORDER BY ID DESC

		PRINT('@inp_sDetails1')
		PRINT(@inp_sDetails1)
		

		DECLARE @ISINString NVARCHAR(50)
		CREATE TABLE #tmpISIN
		(
		ID INT IDENTITY(1,1),
		ISINString nvarchar(50)
		)
		Insert into #tmpISIN
		select * from FN_VIGILANTE_SPLIT(@inp_sDetails1,'(')
		select @ISINString=ISINString from #tmpISIN where ISINString<>'' and ISINString is not null
		drop table #tmpISIN

		DECLARE @ISINString1 NVARCHAR(50)
		CREATE TABLE #tmpISIN1
		(
		ID INT IDENTITY(1,1),
		ISINString1 nvarchar(50)
		)
		Insert into #tmpISIN1
		select * from FN_VIGILANTE_SPLIT(@ISINString,')')
		select @iISINCode=ISINString1 from #tmpISIN1 where ISINString1<>'' and ISINString1 is not null
		drop table #tmpISIN1
		drop table #tmpTable
	
	IF(@inp_sAction = 'AUTOCOMPLETE')
	BEGIN	
		IF(LEN(@inp_sCompanyName) = 0)
			SET @inp_sCompanyName = NULL
		ELSE 
			SET @inp_sISINCode = @inp_sCompanyName + '%'
			SET @inp_sCompanyName = @inp_sCompanyName + '%'
			
		--IF(LEN(@inp_sISINCode) = 0)
		--	SET @inp_sISINCode = NULL
		--ELSE 
		--	SET @inp_sISINCode = @inp_sISINCode + '%'
		
			
		IF(LEN(@inp_sBSECode) = 0)
			SET @inp_sBSECode = NULL
		ELSE 
			SET @inp_sBSECode = @inp_sBSECode + '%'	
			
		IF(LEN(@inp_sNSECode) = 0)
			SET @inp_sNSECode = NULL
		ELSE 
			SET @inp_sNSECode = @inp_sNSECode + '%'		
		
		BEGIN TRY	
			SELECT CML.RlCompanyId, CompanyName +' '+'-'+'('+ ISINCode + ')' AS
				CompanyName, BSECode, NSECode,ISINCode
			FROM rl_CompanyMasterList CML
			--LEFT OUTER JOIN rl_RistrictedMasterList RML ON RML.RlCompanyId = CML.RlCompanyId
			WHERE (CML.CompanyName LIKE @inp_sCompanyName OR CML.ISINCode LIKE @inp_sISINCode OR CML.BSECode LIKE @inp_sBSECode OR CML.NSECode LIKE @inp_sNSECode)
			AND StatusCodeId = 105001
			--AND (CONVERT(DATE,dbo.uf_com_GetServerDate()) BETWEEN CONVERT(DATE,ApplicableFromDate) AND CONVERT(DATE,ApplicableToDate))
			print (@out_nReturnValue)
		END TRY
		BEGIN CATCH
			SET @out_nSQLErrCode    =  ERROR_NUMBER()
			SET @out_sSQLErrMessage =   ERROR_MESSAGE()
			
			-- Return common error if required, otherwise specific error.		
			SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_NOTIFICATIONQUEUE_GETDETAILS, ERROR_NUMBER())
			
			RETURN @out_nReturnValue		
		END CATCH
	END
	
	ELSE IF(@inp_sAction = 'DETAILS')
	BEGIN

		
		BEGIN TRY
			IF(@inp_sISINCode IS NOT NULL OR @inp_sISINCode<>'')
			BEGIN
				SELECT RlCompanyId,CompanyName +' '+'-'+'('+ ISINCode + ')' AS 
						CompanyName, BSECode, NSECode,ISINCode
				FROM rl_CompanyMasterList
				WHERE CompanyName = @inp_sDetails OR ISINCode = @inp_sDetails OR BSECode = @inp_sDetails OR NSECode = @inp_sDetails
			END
			ELSE
			BEGIN
				SELECT RlCompanyId,CompanyName +' '+'-'+'('+ ISINCode + ')' AS 
						CompanyName, BSECode, NSECode,ISINCode
				FROM rl_CompanyMasterList
				WHERE  ISINCode = @iISINCode
			END
		END TRY
		BEGIN CATCH
			SET @out_nSQLErrCode    =  ERROR_NUMBER()
			SET @out_sSQLErrMessage =   ERROR_MESSAGE()
			
			-- Return common error if required, otherwise specific error.		
			SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_NOTIFICATIONQUEUE_GETDETAILS, ERROR_NUMBER())
			
			RETURN @out_nReturnValue		
		END CATCH
	END
	
END
