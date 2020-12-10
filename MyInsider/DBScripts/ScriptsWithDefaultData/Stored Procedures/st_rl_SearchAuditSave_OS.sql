IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rl_SearchAuditSave_OS')
	DROP PROCEDURE st_rl_SearchAuditSave_OS
GO
-- ======================================================================================
-- Author      : Priyanka Bhangale															            =
-- CREATED DATE: 29-Mar-2019                                                 			                =
-- Description : THIS PROCEDURE SAVE SEARCH RESTRICTED COMPANY LIST DETAILS	OF OTHER SECURITY			=
--	exec st_rl_SearchAuditSave_OS '13','HCL INFOSYSTEMS LTD.'								            =
-- ======================================================================================

CREATE PROCEDURE [dbo].[st_rl_SearchAuditSave_OS]
(
	
	@inp_iLoggedInUserId		INT,
	@inp_sCompanyName			VARCHAR(300),
	@out_nCount					INT = 0 OUTPUT,
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT    -- Output SQL Error Message, if error occurred.	
)
AS
BEGIN
	DECLARE @ERR_NOTIFICATIONQUEUE_GETDETAILS INT 
	DECLARE @COMPANYID INT 
	DECLARE @MAPTOTYPECODEID INT = 132012--132010
	DECLARE @MODULECODEID INT = 103301--103013
	DECLARE @INCLUDEEXCLUDECODEID INT = 150001
	DECLARE @STATUSCODEID INT = 105001
	DECLARE @COUNT INT 
	DECLARE @ALLOW_RESKEY INT = 50015
	DECLARE @NOTALLOW_RESKEY INT = 50016
	DECLARE @ISEMPLOYEE BIT = 0
	DECLARE @ISINSIDER BIT = 0
	DECLARE @CHECK INT = 0
	
	DECLARE @ALLEMPLOYEEINSIDERFLAG BIT = 0
	DECLARE @ALLEMPLOYEEFLAG BIT = 0
	--Check the Department, Grade & Designation for the loggedIdUser
	DECLARE @DepartmentCodeID INT
	DECLARE @GradeCodeID INT
	DECLARE @DesignationCodeID INT
	DECLARE @CategoryID INT
	DECLARE @SubCategoryID INT
	DECLARE @RlMasterId INT
	DECLARE @ApplicableFromDate DATE
	DECLARE @ApplicableToDate DATE
	DECLARE @RoleID INT
	DECLARE @Cnt INT
	Declare @rlCount int 
 	Declare @rlFlag int=1
 	DECLARE @Where_Condition varchar(MAX)=' '
 	DECLARE @SQL VARCHAR(MAX) = ''
 	DECLARE @FOUND INT
	
	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0

	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0

	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = ''
	
	BEGIN TRY	
	
		CREATE TABLE #TEMP_TABLE
		(
			RlMasterId			INT, 
			RlCompanyId			INT, 
			CompanyName			VARCHAR(500), 
			ModuleCodeId		INT, 
			UserId				INT,
			ApplicableFromDate	DATETIME, 
			ApplicableToDate	DATETIME, 
			StatusCodeId		INT
		)
		
		CREATE TABLE #TEMP_CHECK
		(			
			AllEmployeeInsiderFlag		BIT,
			AllEmployeeFlag				BIT
		) 
		create table #tmpDep
		(
		ID int Identity,
		DepartmentCodeId int,
		GradeCodeId int,
		DesignationCodeId int,
		Category int,
		SubCategory int,
		RlMasterId int,
		ModuleCodeId int,
		ApplicableFromDate datetime,
		ApplicableToDate datetime,
		StatusCodeId int,
		RoleId int
		)

		create table #tmpMatchDetails
		(
		ID int Identity,
		UserInfoID int,
		DepartmentCodeId int,
		GradeCodeId int,
		DesignationCodeId int,
		Category int,
		SubCategory int,
		RlMasterId int,
		ModuleCodeId int,
		ApplicableFromDate datetime,
		ApplicableToDate datetime,
		StatusCodeId int,
		RoleId int
		)
	
		SELECT @COMPANYID = RlCompanyId FROM  rl_CompanyMasterList WHERE CompanyName = @inp_sCompanyName

		SELECT @CHECK = COUNT(UserInfoId)FROM usr_UserInfo WHERE DateOfBecomingInsider IS NOT NULL AND DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND StatusCodeId = 102001 AND UserInfoId = @inp_iLoggedInUserId
		IF (@CHECK <> 0)
		BEGIN 
			SET @ISINSIDER = 1
		END
		ELSE
		BEGIN 
			SET @ISEMPLOYEE = 1
		END


		INSERT INTO #TEMP_CHECK
		SELECT TOP 1 AllEmployeeInsiderFlag, AllEmployeeFlag FROM rl_RistrictedMasterList RML
					INNER JOIN rl_CompanyMasterList RCL ON RCL.RlCompanyId = RML.RlCompanyId
					INNER JOIN rul_ApplicabilityMaster_OS AM ON AM.MapToId = RML.RlMasterId
					INNER JOIN rul_ApplicabilityDetails_OS AD ON AD.ApplicabilityMstId = AM.ApplicabilityId
					WHERE RML.RlCompanyId = @COMPANYID AND AM.MapToTypeCodeId = @MAPTOTYPECODEID
					AND (CONVERT(DATE,dbo.uf_com_GetServerDate()) BETWEEN CONVERT(DATE,RML.ApplicableFromDate) AND CONVERT(DATE,RML.ApplicableToDate))
					ORDER BY AD.ApplicabilityDtlsId DESC	
					
		SELECT @ALLEMPLOYEEINSIDERFLAG = AllEmployeeInsiderFlag, @ALLEMPLOYEEFLAG = AllEmployeeFlag FROM #TEMP_CHECK
		
		SET @CHECK = (SELECT TOP 1 AD.UserId FROM rl_RistrictedMasterList RML
					INNER JOIN rl_CompanyMasterList RCL ON RCL.RlCompanyId = RML.RlCompanyId
					INNER JOIN rul_ApplicabilityMaster_OS AM ON AM.MapToId = RML.RlMasterId
					INNER JOIN rul_ApplicabilityDetails_OS AD ON AD.ApplicabilityMstId = AM.ApplicabilityId
					WHERE RML.RlCompanyId = @COMPANYID AND AM.MapToTypeCodeId = @MAPTOTYPECODEID
					AND (CONVERT(DATE,dbo.uf_com_GetServerDate()) BETWEEN CONVERT(DATE,RML.ApplicableFromDate) AND CONVERT(DATE,RML.ApplicableToDate))
					ORDER BY AD.ApplicabilityDtlsId DESC)

		IF(@CHECK IS NOT NULL)
		BEGIN
			INSERT INTO #TEMP_TABLE			
			SELECT	RlMasterId, RML.RlCompanyId, RCL.CompanyName, RML.ModuleCodeId, AD.UserId,
				ApplicableFromDate, ApplicableToDate, RML.StatusCodeId 			
			FROM rl_RistrictedMasterList RML
					INNER JOIN rl_CompanyMasterList RCL ON RCL.RlCompanyId = RML.RlCompanyId
					INNER JOIN rul_ApplicabilityMaster_OS AM ON AM.MapToId = RML.RlMasterId
					AND AM.VersionNumber=(SELECT MAX(VersionNumber) FROM rul_ApplicabilityMaster_OS WHERE MapToId = RML.RlMasterId and MapToTypeCodeId=@MAPTOTYPECODEID)
					INNER JOIN rul_ApplicabilityDetails_OS AD ON AD.ApplicabilityMstId = AM.ApplicabilityId
			WHERE RML.RlCompanyId = @COMPANYID AND AM.MapToTypeCodeId = @MAPTOTYPECODEID
			AND (CONVERT(DATE,dbo.uf_com_GetServerDate()) BETWEEN CONVERT(DATE,RML.ApplicableFromDate) AND CONVERT(DATE,RML.ApplicableToDate))
			AND AD.UserId = @inp_iLoggedInUserId AND AD.IncludeExcludeCodeId = @IncludeExcludeCodeId AND RML.StatusCodeId = @STATUSCODEID
		END
		ELSE
		BEGIN
			IF (@ISINSIDER = 1 )--AND @ALLEMPLOYEEINSIDERFLAG = 1)
			BEGIN 
				if @ALLEMPLOYEEINSIDERFLAG = 1
				begin
					INSERT INTO #TEMP_TABLE			
					SELECT	RlMasterId, RML.RlCompanyId, RCL.CompanyName, RML.ModuleCodeId, ISNULL(AD.UserId,0) AS UserId,
						ApplicableFromDate, ApplicableToDate, RML.StatusCodeId 			
					FROM rl_RistrictedMasterList RML
							INNER JOIN rl_CompanyMasterList RCL ON RCL.RlCompanyId = RML.RlCompanyId
							INNER JOIN rul_ApplicabilityMaster AM ON AM.MapToId = RML.RlMasterId
							AND AM.VersionNumber=(SELECT MAX(VersionNumber) FROM rul_ApplicabilityMaster_OS WHERE MapToId = RML.RlMasterId and MapToTypeCodeId=@MAPTOTYPECODEID)
							INNER JOIN rul_ApplicabilityDetails_OS AD ON AD.ApplicabilityMstId = AM.ApplicabilityId					
					WHERE RML.RlCompanyId = @COMPANYID AND AM.MapToTypeCodeId = @MAPTOTYPECODEID
					AND (CONVERT(DATE,dbo.uf_com_GetServerDate()) BETWEEN CONVERT(DATE,RML.ApplicableFromDate) AND CONVERT(DATE,RML.ApplicableToDate))	
					AND AllEmployeeInsiderFlag =@ISINSIDER
				end 
				else
				begin
					INSERT INTO #TEMP_TABLE			
					SELECT	RlMasterId, RML.RlCompanyId, RCL.CompanyName, RML.ModuleCodeId, ISNULL(AD.UserId,0) AS UserId,
						ApplicableFromDate, ApplicableToDate, RML.StatusCodeId 			
					FROM rl_RistrictedMasterList RML
							INNER JOIN rl_CompanyMasterList RCL ON RCL.RlCompanyId = RML.RlCompanyId
							INNER JOIN rul_ApplicabilityMaster_OS AM ON AM.MapToId = RML.RlMasterId
							AND AM.VersionNumber=(SELECT MAX(VersionNumber) FROM rul_ApplicabilityMaster_OS WHERE MapToId = RML.RlMasterId and MapToTypeCodeId=@MAPTOTYPECODEID)
							INNER JOIN rul_ApplicabilityDetails_OS AD ON AD.ApplicabilityMstId = AM.ApplicabilityId					
					WHERE RML.RlCompanyId = @COMPANYID AND AM.MapToTypeCodeId = @MAPTOTYPECODEID
					AND (CONVERT(DATE,dbo.uf_com_GetServerDate()) BETWEEN CONVERT(DATE,RML.ApplicableFromDate) AND CONVERT(DATE,RML.ApplicableToDate))	
					AND UserId = @inp_iLoggedInUserId
				end
			END
			ELSE IF (@ISEMPLOYEE = 1 )--AND @ALLEMPLOYEEFLAG = 1)
			BEGIN
				if @ALLEMPLOYEEFLAG = 1
				begin
					INSERT INTO #TEMP_TABLE			
					SELECT	RlMasterId, RML.RlCompanyId, RCL.CompanyName, RML.ModuleCodeId, ISNULL(AD.UserId,0) AS UserId,
						ApplicableFromDate, ApplicableToDate, RML.StatusCodeId 			
					FROM rl_RistrictedMasterList RML
							INNER JOIN rl_CompanyMasterList RCL ON RCL.RlCompanyId = RML.RlCompanyId
							INNER JOIN rul_ApplicabilityMaster_OS AM ON AM.MapToId = RML.RlMasterId
							AND AM.VersionNumber=(SELECT MAX(VersionNumber) FROM rul_ApplicabilityMaster_OS WHERE MapToId = RML.RlMasterId and MapToTypeCodeId=@MAPTOTYPECODEID)
							INNER JOIN rul_ApplicabilityDetails_OS AD ON AD.ApplicabilityMstId = AM.ApplicabilityId					
					WHERE RML.RlCompanyId = @COMPANYID AND AM.MapToTypeCodeId = @MAPTOTYPECODEID
					AND (CONVERT(DATE,dbo.uf_com_GetServerDate()) BETWEEN CONVERT(DATE,RML.ApplicableFromDate) AND CONVERT(DATE,RML.ApplicableToDate))	
					AND AllEmployeeFlag = @ISEMPLOYEE
				end
				else
				begin
					INSERT INTO #TEMP_TABLE			
					SELECT	RlMasterId, RML.RlCompanyId, RCL.CompanyName, RML.ModuleCodeId, ISNULL(AD.UserId,0) AS UserId,
						ApplicableFromDate, ApplicableToDate, RML.StatusCodeId 			
					FROM rl_RistrictedMasterList RML
							INNER JOIN rl_CompanyMasterList RCL ON RCL.RlCompanyId = RML.RlCompanyId
							INNER JOIN rul_ApplicabilityMaster_OS AM ON AM.MapToId = RML.RlMasterId
							AND AM.VersionNumber=(SELECT MAX(VersionNumber) FROM rul_ApplicabilityMaster_OS WHERE MapToId = RML.RlMasterId and MapToTypeCodeId=@MAPTOTYPECODEID)
							INNER JOIN rul_ApplicabilityDetails_OS AD ON AD.ApplicabilityMstId = AM.ApplicabilityId					
					WHERE RML.RlCompanyId = @COMPANYID AND AM.MapToTypeCodeId = @MAPTOTYPECODEID
					AND (CONVERT(DATE,dbo.uf_com_GetServerDate()) BETWEEN CONVERT(DATE,RML.ApplicableFromDate) AND CONVERT(DATE,RML.ApplicableToDate))	
					AND UserId = @inp_iLoggedInUserId
				end
			END
		END		
		
			
		SELECT @COUNT = COUNT(RlMasterId) FROM #TEMP_TABLE
		IF (@COUNT = 0)
		BEGIN
			INSERT INTO #tmpDep (DepartmentCodeId,GradeCodeId,DesignationCodeId,Category,SubCategory,RlMasterId,ModuleCodeId,ApplicableFromDate,ApplicableToDate,StatusCodeId,RoleId)
			SELECT  AD.DepartmentCodeId, AD.GradeCodeId, AD.DesignationCodeId, AD.Category, AD.SubCategory
			, RML.RlMasterId, RML.ModuleCodeId, RML.ApplicableFromDate, RML.ApplicableToDate, RML.StatusCodeId, AD.RoleId
 			FROM rl_RistrictedMasterList RML
 			INNER JOIN rl_CompanyMasterList RCL ON RCL.RlCompanyId = RML.RlCompanyId
 			INNER JOIN rul_ApplicabilityMaster_OS AM ON AM.MapToId = RML.RlMasterId 
 			and AM.VersionNumber=(SELECT MAX(VersionNumber) FROM rul_ApplicabilityMaster_OS WHERE MapToId = RML.RlMasterId and MapToTypeCodeId=@MAPTOTYPECODEID)
 			INNER JOIN rul_ApplicabilityDetails_OS AD ON AD.ApplicabilityMstId = AM.ApplicabilityId
 			WHERE RML.RlCompanyId = @COMPANYID AND AM.MapToTypeCodeId = @MAPTOTYPECODEID
 			AND (CONVERT(DATE,dbo.uf_com_GetServerDate()) BETWEEN CONVERT(DATE,RML.ApplicableFromDate) 
 			AND CONVERT(DATE,RML.ApplicableToDate))	
 			AND AD.UserId IS NULL
 			 			
 			SET @rlCount = (select COUNT(ID) from #tmpDep)
 			WHILE(@rlFlag<=@rlCount)
 			BEGIN
 				SELECT 
 				@DepartmentCodeID =DepartmentCodeId, @GradeCodeID = GradeCodeId, @DesignationCodeID = DesignationCodeId,
 				@CategoryID = Category, @SubCategoryID = SubCategory,
 				@RlMasterId = RlMasterId, @ModuleCodeId = ModuleCodeId, 
 				@ApplicableFromDate = ApplicableFromDate, @ApplicableToDate = ApplicableToDate,
 				@StatusCodeID = StatusCodeId,@RoleID = RoleId 			
 				from #tmpDep where ID=@rlFlag
 				
 				IF(@DepartmentCodeID IS NOT NULL)
 				BEGIN
 					SET @Where_Condition= @Where_Condition + ' and U.DepartmentId= ' + CONVERT(VARCHAR(50),@DepartmentCodeID) +' '
 				END
 				IF(@GradeCodeID IS NOT NULL)
 				BEGIN
 					SET @Where_Condition= @Where_Condition +' and U.GradeId='+ CONVERT(VARCHAR(50),@GradeCodeID) +''
 				END
 				IF(@DesignationCodeID IS NOT NULL)
 				BEGIN
 					SET @Where_Condition= @Where_Condition+ ' and U.DesignationId='+ CONVERT(VARCHAR(50),@DesignationCodeID) +' '
 				END
 				IF(@CategoryID IS NOT NULL)
 					BEGIN
 				SET @Where_Condition= @Where_Condition+ ' and U.Category='+ CONVERT(VARCHAR(50),@CategoryID) +' '
 				END
 				IF(@SubCategoryID IS NOT NULL)
 				BEGIN
 					SET @Where_Condition= @Where_Condition+ ' and U.SubCategory='+ CONVERT(VARCHAR(50),@SubCategoryID) +' ' 			
 				END
 				IF(@RoleID IS NOT NULL)
 				BEGIN
 					SET @Where_Condition= @Where_Condition +' and R.RoleId='+ CONVERT(VARCHAR(50),@RoleId) +'' 			
 				END
 				
 				SET @SQL = 'INSERT INTO #tmpMatchDetails(UserInfoID) select U.UserInfoId from usr_UserInfo U INNER JOIN usr_UserRole R ON U.UserInfoId=R.UserInfoID where U.UserInfoId= '+ CONVERT(VARCHAR(50),@inp_iLoggedInUserId)+ @Where_Condition
 				EXEC (@SQL)
 				IF EXISTS(SELECT UserInfoID FROM #tmpMatchDetails)
 				BEGIN
 					UPDATE #tmpMatchDetails 
 					SET DepartmentCodeID= @DepartmentCodeID,GradeCodeId=@GradeCodeID,
 					DesignationCodeId=@DesignationCodeId,Category=@CategoryID,
 					SubCategory=@SubCategoryID,RoleId=@RoleID,RlMasterId=@RlMasterId
 				END
 				SET @rlFlag = @rlFlag + 1
 				SET @Where_Condition=''
 			End
 			
 			SELECT @Cnt = COUNT(*) FROM #tmpMatchDetails
 			IF @Cnt > 0
 			BEGIN
 				INSERT INTO #TEMP_TABLE
 				(
 					RlMasterId,RlCompanyId,CompanyName,ModuleCodeId,UserId,
 					ApplicableFromDate,ApplicableToDate,StatusCodeId
 				)
 				SELECT RlMasterId,@COMPANYID,@inp_sCompanyName,ModuleCodeId,
 				UserInfoID,ApplicableFromDate,ApplicableToDate,StatusCodeId
 				FROM #tmpMatchDetails 
 				WHERE ID = (Select MAX(ID) from #tmpMatchDetails)
 			END
		
		END
		SELECT @COUNT = COUNT(RlMasterId) FROM #TEMP_TABLE
		
		IF (@COUNT = 0)
		BEGIN
			INSERT INTO rl_SearchAudit_OS
			(
				UserInfoId, ResourceKey, RlCompanyId, 
				RlMasterId, ModuleCodeId, CreatedBy, 
				CreatedOn, ModifiedBy, ModifiedOn
			)	
			VALUES
			(
				@inp_iLoggedInUserId, @ALLOW_RESKEY, @COMPANYID, 
				NULL, @MODULECODEID, 
				@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate()   
			)
		END
		ELSE
		BEGIN
			INSERT INTO rl_SearchAudit_OS
			(
				UserInfoId, ResourceKey, RlCompanyId, 
				RlMasterId, ModuleCodeId, CreatedBy, 
				CreatedOn, ModifiedBy, ModifiedOn
			)	
			VALUES
			(
				@inp_iLoggedInUserId, @NOTALLOW_RESKEY, @COMPANYID, 
				(SELECT TOP 1 RlMasterId FROM #TEMP_TABLE), @MODULECODEID, @inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), 
				@inp_iLoggedInUserId, dbo.uf_com_GetServerDate()   
			)
		END		
		SET @out_nReturnValue = 0
		SELECT  [RlSearchAuditId]
			  ,[UserInfoId]
			  ,[ResourceKey]
			  ,[RlCompanyId]
			  ,[RlMasterId]
			  ,[ModuleCodeId]
			  ,[CreatedBy]
			  ,[CreatedOn] 
		FROM rl_SearchAudit_OS
		WHERE RlSearchAuditId = SCOPE_IDENTITY();
		
		SELECT @out_nCount = @COUNT
		DROP TABLE #TEMP_TABLE	
		DROP TABLE #tmpDep
		DROP TABLE #tmpMatchDetails
	END TRY
	
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_NOTIFICATIONQUEUE_GETDETAILS, ERROR_NUMBER())
		
		RETURN @out_nReturnValue	
	END CATCH
END