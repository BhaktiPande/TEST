IF (OBJECT_ID('st_rl_RestrictedMasterList','P') IS NOT NULL)
DROP PROCEDURE [st_rl_RestrictedMasterList]

GO
/*
Description:	Procedure to list Restricted Companies.

Returns:		0, if Success.
				
Created by:		Santosh Panchal
Created on:		23-Sept-2015

Modification History:

Usage:

DECLARE @P12 INT
SET @P12=0
DECLARE @P13 INT
SET @P13=0
DECLARE @P14 VARCHAR(1000)
SET @P14=''

EXEC ST_RL_RESTRICTEDMASTERLIST 0,1,'USR_GRD_50009','ASC',NULL,NULL,NULL,NULL,NULL,NULL,0,@P12 OUT, @P13 OUT, @P14 OUT
SELECT @P12, @P13, @P14

--exec sp_executesql N'exec st_rl_RestrictedMasterList @1,@2,@3 ,@4,@5,@6,@7 ,@8 ,@9 ,@10,@11,@12 int output,@13 int output,@14 varchar(1000) output',
--				@1=10,@2=1,@3=N'usr_grd_50006',@4=N'asc',@5=NULL,@6=NULL,@7=NULL,@8=NULL,@9=NULL,@10=NULL,@11=0,
--				 @12=@p12 output,@13=@p13 output,@14=@p14 output
--select @p12, @p13, @p14
*/

CREATE PROCEDURE [st_rl_RestrictedMasterList]
	@inp_iPageSize					INT = 0
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5) 
	,@inp_sCompanyName				VARCHAR(300) = NULL
	,@inp_sISINCode					VARCHAR(300) = NULL
	,@inp_sBSECode					VARCHAR(300) = NULL
	,@inp_sNSECode					VARCHAR(300) = NULL
	,@inp_dtApplicableFrom			VARCHAR(25) = NULL
	,@inp_dtApplicableTo			VARCHAR(25) = NULL
	,@inp_iCreatedBy				INT = 0	
	,@inp_iStatus                   INT = 0
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN

	DECLARE @sSQL						NVARCHAR(MAX) = ''
	DECLARE @ERR_RESTRICTED_LIST		INT = 50019 -- Error occurred while fetching list of Restricted List
	DECLARE @dtDefault					DATETIME = CONVERT(DATETIME, '')	
	DECLARE @nRestrictedListActive		INT
	DECLARE	@nRestrictedListInActive	INT
	DECLARE @nCompanyStatusActive       VARCHAR(50)
	

	BEGIN TRY
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		IF @inp_dtApplicableFrom = @dtDefault
			SET @inp_dtApplicableFrom = NULL
		
		IF @inp_dtApplicableTo = @dtDefault
			SET @inp_dtApplicableTo = NULL
			

		SELECT	@nRestrictedListActive	= 511001,
				@nRestrictedListInActive= 511002
				
		SELECT @nCompanyStatusActive = 105001
				
		
		IF @inp_iStatus = '' OR @inp_iStatus IS NULL
		BEGIN
			SET @inp_iStatus = @nRestrictedListActive
		END
		
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'

		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'DESC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'RL.CreatedOn '
		END 			
		
		IF @inp_sSortField = 'usr_grd_50005' -- BSE Code
		BEGIN 
			SELECT @inp_sSortField = 'RLCL.BSECode ' 
		END

		IF @inp_sSortField = 'usr_grd_50006' -- NSE Code
		BEGIN 
			SELECT @inp_sSortField = 'RLCL.NSECode ' 
		END
		
		IF @inp_sSortField = 'usr_grd_50007' -- ISINCode
		BEGIN 
			SELECT @inp_sSortField = 'RLCL.ISINCode ' 
		END
		
		IF @inp_sSortField = 'usr_grd_50008' -- Company Name
		BEGIN 
			SELECT @inp_sSortField = 'RLCL.RlCompanyId ' 
		END
		
		IF @inp_sSortField = 'usr_grd_50009' -- Applicable from
		BEGIN 
			SELECT @inp_sSortField = 'RL.ApplicableFromDate' 
		END
			
		IF @inp_sSortField = 'usr_grd_50010' -- Applicable to
		BEGIN 
			SELECT @inp_sSortField = 'RL.ApplicableToDate' 
		END
		
		IF @inp_sSortField = 'usr_grd_50011' -- User Name
		BEGIN 
			SELECT @inp_sSortField = 'RL.CreatedBy' 
		END
		
		SET @inp_sSortOrder='DESC'
		
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',MAX(RL.RlMasterId)),MAX(RL.RlMasterId) '
		SELECT @sSQL = @sSQL + ' FROM rl_RistrictedMasterList RL LEFT JOIN com_Code CdPDCategory ON RL.ModuleCodeId = CdPDCategory.CodeID '
		SELECT @sSQL = @sSQL + ' INNER JOIN rl_CompanyMasterList RLCL ON RLCL.RlCompanyId = RL.RlCompanyId'
		SELECT @sSQL = @sSQL + ' INNER JOIN usr_UserInfo UI ON UI.UserInfoId = RL.CreatedBy '				 
		SELECT @sSQL = @sSQL + ' INNER JOIN COM_CODE CMODULE ON RL.MODULECODEID = CMODULE.CODEID '
		SELECT @sSQL = @sSQL + ' INNER JOIN COM_CODE CSTATUS ON RL.MODULECODEID = CSTATUS.CODEID '
		SELECT @sSQL = @sSQL + ' WHERE 1=1 '
		SELECT @sSQL = @sSQL + ' AND RL.StatusCodeId = ' + @nCompanyStatusActive + ' ' --fetch only the non-deleted records
		
		--CompanyName filter
		IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND RLCL.RlCompanyId = ' + CAST(@inp_sCompanyName AS VARCHAR(10)) + ' '
		END
		
		--BSE Code filter
		IF (@inp_sBSECode IS NOT NULL AND @inp_sBSECode <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND RLCL.BSECode = N'''+ CAST(@inp_sBSECode AS VARCHAR(300)) +''' '
		END
		
		--NSE Code filter
		IF (@inp_sNSECode IS NOT NULL AND @inp_sNSECode <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND RLCL.NSECode = N'''+ CAST(@inp_sNSECode AS VARCHAR(300)) +''' '
		END
		
		--ISIN Code filter
		IF (@inp_sISINCode IS NOT NULL AND @inp_sISINCode <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND RLCL.ISINCode = N'''+ CAST(@inp_sISINCode AS VARCHAR(300)) +''' '
		END
		
		--@inp_dtApplicableFrom, @inp_dtApplicableTo filters
		IF (@inp_dtApplicableFrom IS NOT NULL OR @inp_dtApplicableTo IS NOT NULL)
		BEGIN
			/*Input from-date should be less than input to-date*/
			--IF (@inp_dtApplicableFrom IS NOT NULL AND @inp_dtApplicableTo IS NOT NULL) 
			--BEGIN
			--	SELECT @sSQL = @sSQL + ' AND  CAST(''' + CAST(@inp_dtApplicableFrom AS VARCHAR(25)) + ''' AS DATETIME) <= '
			--	SELECT @sSQL = @sSQL  + ' CAST(''' + CAST(@inp_dtApplicableTo AS VARCHAR(25)) + ''' AS DATETIME) '
			--END
		
			SELECT @sSQL = @sSQL + ' AND ( '
			IF (@inp_dtApplicableFrom IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' (RL.ApplicableFromDate >= CAST('''  + CAST(@inp_dtApplicableFrom AS VARCHAR(25)) + ''' AS DATETIME))'
			END
			
			IF (@inp_dtApplicableFrom IS NOT NULL AND @inp_dtApplicableTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' AND '
			END
			
			IF (@inp_dtApplicableTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' (RL.ApplicableToDate <= CAST('''  + CAST(@inp_dtApplicableTo AS VARCHAR(25)) + ''' AS DATETIME) )'
			END
			
			IF (@inp_dtApplicableFrom IS NOT NULL AND @inp_dtApplicableTo IS NOT NULL)
			BEGIN
				SELECT @sSQL = @sSQL + ' OR ( CAST (''' + CAST(@inp_dtApplicableFrom AS VARCHAR(25)) + ''' AS DATETIME) <= RL.ApplicableFromDate '
				SELECT @sSQL = @sSQL + ' AND (( CAST(''' + CAST(@inp_dtApplicableTo AS VARCHAR(25)) + ''' AS DATETIME) >= RL.ApplicableToDate) ) )'
			END
			
			SELECT @sSQL = @sSQL + ' )'
		END
		
		--Created By filter
		IF (@inp_iCreatedBy IS NOT NULL AND @inp_iCreatedBy <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND RL.CreatedBy = '+ CAST(@inp_iCreatedBy AS VARCHAR(300)) 
		END
		
		--@inp_iStatus filters
		IF (@inp_iStatus IS NOT NULL AND @inp_iStatus <> '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND '
			IF(@inp_iStatus = @nRestrictedListActive)
			BEGIN
				SELECT @sSQL = @sSQL + ' ((RL.ApplicableFromDate <= dbo.uf_com_GetServerDate() AND RL.ApplicableToDate >= dbo.uf_com_GetServerDate()) OR (RL.ApplicableFromDate > dbo.uf_com_GetServerDate())) ' 
			END
			ELSE IF(@inp_iStatus = @nRestrictedListInActive)
			BEGIN
				SELECT @sSQL = @sSQL + ' (RL.ApplicableToDate <= dbo.uf_com_GetServerDate()) '
			END
		END
		
		SELECT @sSQL = @sSQL + ' GROUP BY RL.RlMasterVersionNumber,RLCL.RlCompanyId ' 
		
		PRINT(@sSQL)
		EXEC(@sSQL)
		
		SELECT	rAm.UserCount AS NoOfUserId,RL.RlMasterId AS RlMasterID
		INTO	#temp_NoOfEmpCount
		FROM	RL_RISTRICTEDMASTERLIST RL
		LEFT JOIN rul_ApplicabilityMaster rAM on RL.RlMasterId = rAM.MapToId 
		WHERE RL.StatusCodeId = @nCompanyStatusActive AND rAM.MapToTypeCodeId = 132012
		AND rAM.VersionNumber=(SELECT MAX(VersionNumber) FROM rul_ApplicabilityMaster WHERE MapToTypeCodeId = 132012 AND MapToId=RL.RlMasterId)

		SELECT	RL.RlMasterId AS RlMasterId, 		
		(CASE RLCL.BSECode WHEN '' THEN 'Not Available' ELSE RLCL.BSECode END) AS usr_grd_50005,
		(CASE RLCL.ISINCode WHEN '' THEN 'Not Available' ELSE RLCL.ISINCode END) AS usr_grd_50007,
		(CASE RLCL.NSECode WHEN '' THEN 'Not Available' ELSE RLCL.NSECode END) AS usr_grd_50006,		
		RLCL.CompanyName AS usr_grd_50008, /*CompanyName*/
		CONVERT(DATE,RL.ApplicableFromDate,110) AS usr_grd_50009,
		CONVERT(DATE,RL.ApplicableToDate,110) AS usr_grd_50010,
		(ISNULL(UI.FirstName,'') +' '+ ISNULL(UI.LastName,'')) AS usr_grd_50011		
		--ISNULL(tEmp.NoOfUserId,0) AS usr_grd_50012
		FROM	#tmpList T INNER JOIN rl_RistrictedMasterList RL ON T.EntityID = RL.RlMasterId
				INNER JOIN rl_CompanyMasterList RLCL ON RL.RlCompanyId = RLCL.RlCompanyId
				INNER JOIN usr_UserInfo UI ON UI.UserInfoId = RL.CreatedBy	
				LEFT JOIN #temp_NoOfEmpCount tEmp ON tEmp.RlMasterID = Rl.RlMasterId			
				LEFT JOIN com_Code CModule ON RL.ModuleCodeId = CModule.CodeID
				LEFT JOIN com_Code CStatus ON RL.StatusCodeId = CStatus.CodeID
		WHERE	1=1 AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
		
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_RESTRICTED_LIST
		RETURN @out_nReturnValue
	END CATCH
END
GO
