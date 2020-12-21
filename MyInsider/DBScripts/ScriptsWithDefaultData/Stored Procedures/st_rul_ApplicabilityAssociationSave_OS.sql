IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_ApplicabilityAssociationSave_OS')
DROP PROCEDURE [dbo].[st_rul_ApplicabilityAssociationSave_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the Applicability association along alnog with version for history maintenance
Valid input combinations will be:
											Combi-1		Combi-2		Combi-3		Combi-4
=======================================================================================
@inp_nAllEmployeeFlag						1			NULL		NULL		NULL						
@inp_nAllInsiderFlag						NULL		1			NULL		NULL
@inp_nAllEmployeeInsiderFlag				NULL		NULL		1			NULL

@inp_tblApplicabilityFilterType				count=0		count=0		count=0		count>=0
@inp_tblApplicabilityIncludeExcludeUsers	count=0		count=0		count>=0	count>=0	
=======================================================================================
Returns:		0, if Success.
				
Created by:		Rajashri

Usage:
DECLARE @RC int
EXEC st_rul_ApplicabilityAssociationSave_OS 132006, 4, 0, 0, 0, @inp_tblApplicabilityFilterType, @inp_tblApplicabilityIncludeExcludeUsers
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_ApplicabilityAssociationSave_OS] 
	@inp_nMapToTypeCodeId									INT,
	@inp_nMapToId											INT,
	@inp_nAllEmployeeFlag									BIT = NULL,
	@inp_nAllInsiderFlag									BIT = NULL,
	@inp_nAllEmployeeInsiderFlag							BIT = NULL,
	@inp_nAllCoFlag											BIT = NULL,
	@inp_nAllCorporateInsiderFlag							BIT = NULL,
	@inp_nAllNonEmployeeInsiderFlag							BIT = NULL,
	@inp_tblApplicabilityFilterType							ApplicabilityFilterType READONLY,
	@inp_tblNonInsEmpApplicabilityFilterType				NonInsEmpApplicabilityFilterType READONLY,
	@inp_tblApplicabilityIncludeExcludeUsers				ApplicabilityUserIncludeExcludeType READONLY,
	@inp_nUserId											INT,						-- Id of the user inserting/updating the Applicability
	@out_nCountUserAndOverlapTradingPolicy					INT = 0 OUTPUT,
	@out_nReturnValue										INT = 0 OUTPUT,
	@out_nSQLErrCode										INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage										NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE	@ERR_APPLICABILITY_ASSOCIATION_SAVE				INT = 15226	--Error occurred when saving applicability association
	DECLARE @ERR_APPLICABILITY_ASSOCIATION_INVALID_INPUT	INT = 15227	--Invalid input given to save applicability
	DECLARE @ERR_POLICYDOCUMENT_NOTFOUND					INT = 15043 --Policy document does not exist.
	DECLARE @ERR_TRADINGPOLICY_NOTFOUND						INT = 15059 --Trading policy does not exist.
	DECLARE @ERR_COMMUNICATIONRULE_NOTFOUND					INT = 18015	--Communication Rule does not exist.
	
	DECLARE @nMapToTypeCodeId_PolicyDocument				INT = 132001
	DECLARE @nMapToTypeCodeId_TradingPolicy					INT = 132002
	DECLARE @nMapToTypeCodeId_CommunicationRule				INT = 132006
	DECLARE @nMapToTypeCodeId_RestrictedList                INT = 132012
	
	DECLARE @nPolicyDocumentIncomplete						INT = 131001 --Policy Document Status = Incomplete
	DECLARE @nTPStatusIncomplete							INT = 141001 --Trading Policy Status = Incomplete
	DECLARE @nPolicyDocumentInactive						INT = 131003 --Policy Document Status = Inactive
	DECLARE @nTPStatusInactive								INT = 141003 --Trading Policy Status = Inactive
	DECLARE @nUserTypeEmployeeCodeId						INT = 101003	--Code for UserType Employee
	
	DECLARE	@nMapType_ExistingStatus						INT
	
	DECLARE @nApplicabilityMasterId							INT
	DECLARE @nApplicabilityVersionNumber					INT
	DECLARE	@bInsertApplicabilityIncludeExcludeRecords		INT = 0
	
	DECLARE @ntblFilterCnt									INT = 0
	DECLARE @ntblIncludeExcludeUsersCnt						INT = 0
	DECLARE @ntblNonInsEmpFilterCnt							INT = 0
	DECLARE @nUserCount										INT = 0  --Count to check user count
	
	DECLARE @nCountUserAndOverlapTradingPolicy				INT = 0 --Count to check for users having overlapping trading policy(s)
	
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
		IF @out_nCountUserAndOverlapTradingPolicy IS NULL
			SET @out_nCountUserAndOverlapTradingPolicy = 0
			
		--Validate that MapToId exists depending upon the MapToTypeCodeId
		IF( (@inp_nMapToTypeCodeId = @nMapToTypeCodeId_PolicyDocument) AND 
			(NOT EXISTS(SELECT PolicyDocumentId FROM rul_PolicyDocument WHERE PolicyDocumentId = @inp_nMapToId)) )
		BEGIN	
			SET @out_nReturnValue = @ERR_POLICYDOCUMENT_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		ELSE IF( (@inp_nMapToTypeCodeId = @nMapToTypeCodeId_TradingPolicy) AND 
			(NOT EXISTS(SELECT TradingPolicyId FROM rul_TradingPolicy_OS WHERE TradingPolicyId = @inp_nMapToId)) )
		BEGIN	
			SET @out_nReturnValue = @ERR_TRADINGPOLICY_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		ELSE IF( (@inp_nMapToTypeCodeId = @nMapToTypeCodeId_CommunicationRule) AND 
			(NOT EXISTS(SELECT RuleId FROM cmu_CommunicationRuleMaster WHERE RuleId = @inp_nMapToId)) )
		BEGIN	
			SET @out_nReturnValue = @ERR_COMMUNICATIONRULE_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		
		--TODO : Start ------- VALIDATE THE INPUTS FOR APPLICABILITY DETAILS
		SELECT @ntblFilterCnt = ISNULL(COUNT(ApplicabilityDtlsId),0) FROM @inp_tblApplicabilityFilterType
		SELECT @ntblNonInsEmpFilterCnt = ISNULL(COUNT(ApplicabilityDtlsId),0) FROM @inp_tblNonInsEmpApplicabilityFilterType
		SELECT @ntblIncludeExcludeUsersCnt = ISNULL(COUNT(UserId),0) FROM @inp_tblApplicabilityIncludeExcludeUsers
		
		--At a given time, ANY ONE of the three flags (@inp_nAllEmployeeFlag, @inp_nAllInsiderFlag, @inp_nAllEmployeeInsiderFlag) can be set to 1
		IF( ( (@inp_nAllInsiderFlag IS NOT NULL AND @inp_nAllInsiderFlag <> 0) AND 
				( (@inp_nAllEmployeeFlag IS NOT NULL AND @inp_nAllEmployeeFlag <> 0) OR 
				(@inp_nAllEmployeeInsiderFlag IS NOT NULL AND @inp_nAllEmployeeInsiderFlag <> 0)  OR 
				(@inp_nAllCoFlag IS NOT NULL AND @inp_nAllCoFlag <> 0) OR 
				(@inp_nAllCorporateInsiderFlag IS NOT NULL AND @inp_nAllCorporateInsiderFlag <> 0) OR 
				(@inp_nAllNonEmployeeInsiderFlag IS NOT NULL AND @inp_nAllNonEmployeeInsiderFlag <> 0)  )) 			
		  )		
		BEGIN
			
			SET @out_nReturnValue = @ERR_APPLICABILITY_ASSOCIATION_INVALID_INPUT
			RETURN (@out_nReturnValue)
		END
		
		--No data provided : neither flags not table data provided
		--IF( (@inp_nAllInsiderFlag IS NULL OR @inp_nAllInsiderFlag = 0) AND 
		--		 (@inp_nAllEmployeeFlag IS NULL OR @inp_nAllEmployeeFlag = 0) AND
		--		 (@inp_nAllCoFlag IS NULL OR @inp_nAllCoFlag = 0) AND
		--		 (@inp_nAllCorporateInsiderFlag IS NULL OR @inp_nAllCorporateInsiderFlag = 0) AND
		--		 (@inp_nAllNonEmployeeInsiderFlag IS NULL OR @inp_nAllNonEmployeeInsiderFlag = 0) AND
		--		 (@inp_nAllEmployeeInsiderFlag IS NULL OR @inp_nAllEmployeeInsiderFlag = 0) 
		--		 AND @ntblFilterCnt = 0 AND @ntblIncludeExcludeUsersCnt = 0 AND @ntblNonInsEmpFilterCnt = 0)
		--BEGIN
		--	print '1.2-- '
		--	SET @out_nReturnValue = @ERR_APPLICABILITY_ASSOCIATION_INVALID_INPUT
		--	RETURN (@out_nReturnValue)
		--END
		
		--If  @inp_nAllInsiderFlag = 1 then both tables @inp_tblApplicabilityFilterType and @inp_tblApplicabilityIncludeExcludeUsers should be empty
		IF(( @inp_nAllInsiderFlag = 1) AND (@ntblFilterCnt > 0 OR @ntblIncludeExcludeUsersCnt > 0))
		BEGIN
			print '1.3.1-- '
			SET @out_nReturnValue = @ERR_APPLICABILITY_ASSOCIATION_INVALID_INPUT
			RETURN (@out_nReturnValue)
		END
		--TODO : End ------- VALIDATE THE INPUTS FOR APPLICABILITY DETAILS
		
		--Initialize flags to 0 if they are sent as NULL
		IF(@inp_nAllEmployeeFlag IS NULL)
			SELECT @inp_nAllEmployeeFlag = 0
		IF(@inp_nAllInsiderFlag IS NULL)
			SELECT @inp_nAllInsiderFlag = 0
		IF(@inp_nAllEmployeeInsiderFlag IS NULL)
			SELECT @inp_nAllEmployeeInsiderFlag = 0	
		IF(@inp_nAllCoFlag IS NULL)
			SELECT @inp_nAllCoFlag = 0
		IF(@inp_nAllCorporateInsiderFlag IS NULL)
			SELECT @inp_nAllCorporateInsiderFlag = 0
		IF(@inp_nAllNonEmployeeInsiderFlag IS NULL)
			SELECT @inp_nAllNonEmployeeInsiderFlag = 0	
		
		--Fetch the status of the MapToId to determine whether records are to be delete-inserted for same version of applicability or inserted for fresh version of applicability
		IF(@inp_nMapToTypeCodeId = @nMapToTypeCodeId_PolicyDocument) 
		BEGIN
			SELECT @nMapType_ExistingStatus = WindowStatusCodeId FROM rul_PolicyDocument WHERE PolicyDocumentId = @inp_nMapToId
		END
		ELSE IF(@inp_nMapToTypeCodeId = @nMapToTypeCodeId_TradingPolicy) 
		BEGIN
			SELECT @nMapType_ExistingStatus = TradingPolicyStatusCodeId FROM rul_TradingPolicy_OS WHERE TradingPolicyId = @inp_nMapToId
		END
		
		--Fetch @nApplicabilityVersionNumber = ISNULL(MAX(version-number),0) for the already existing applicability-master-record for @inp_nMapToTypeCodeId and @inp_nMapToId  	
		SELECT @nApplicabilityVersionNumber = ISNULL(MAX(VersionNumber), 0) 
		FROM rul_ApplicabilityMaster_OS
		WHERE MapToTypeCodeId = @inp_nMapToTypeCodeId AND MapToId = @inp_nMapToId 
		
		--Initialize @nApplicabilityVersionNumber = @nApplicabilityVersionNumber + 1
		SELECT @nApplicabilityVersionNumber = @nApplicabilityVersionNumber + 1
		
		--Insert into rul_ApplicabilityMaster_OS with @inp_nMapToTypeCodeId, @inp_nMapToId and @nApplicabilityVersionNumber 
		INSERT INTO rul_ApplicabilityMaster_OS(MapToTypeCodeId, MapToId, VersionNumber, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		VALUES(@inp_nMapToTypeCodeId, @inp_nMapToId, @nApplicabilityVersionNumber, @inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate())
		
		--Set @nnApplicabilityMasterId = SCOPE_IDENTITY() for the newly inserted applicability-master-record
		SELECT @nApplicabilityMasterId = SCOPE_IDENTITY()
		
		print 'New master record id : ' + CAST(@nApplicabilityMasterId AS VARCHAR)
		
		
		/*
		@inp_nAllCoFlag	,@inp_nAllCorporateInsiderFlag,	@inp_nAllNonEmployeeInsiderFlag	
		*/
		IF(@inp_nAllInsiderFlag IS NOT NULL AND @inp_nAllInsiderFlag = 1)
		BEGIN
			INSERT INTO rul_ApplicabilityDetails_OS(ApplicabilityMstId, AllEmployeeFlag, AllInsiderFlag, AllEmployeeInsiderFlag,AllCo,AllCorporateEmployees,AllNonEmployee, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn) 
			VALUES(@nApplicabilityMasterId, @inp_nAllEmployeeFlag, @inp_nAllInsiderFlag, @inp_nAllEmployeeInsiderFlag,@inp_nAllCoFlag	,@inp_nAllCorporateInsiderFlag,	@inp_nAllNonEmployeeInsiderFlag	, @inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate())
			
		END
		
		ELSE 
		BEGIN
			IF (@inp_nAllEmployeeFlag = 1 OR @inp_nAllEmployeeInsiderFlag = 1 OR @inp_nAllCoFlag = 1 OR @inp_nAllCorporateInsiderFlag = 1 OR @inp_nAllNonEmployeeInsiderFlag = 1)
			BEGIN
				INSERT INTO rul_ApplicabilityDetails_OS(ApplicabilityMstId, AllEmployeeFlag, AllInsiderFlag, AllEmployeeInsiderFlag,AllCo,AllCorporateEmployees,AllNonEmployee, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn) 
				VALUES(@nApplicabilityMasterId, @inp_nAllEmployeeFlag, @inp_nAllInsiderFlag, @inp_nAllEmployeeInsiderFlag,@inp_nAllCoFlag	,@inp_nAllCorporateInsiderFlag,	@inp_nAllNonEmployeeInsiderFlag	, @inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate())
			END
			IF( (@inp_nAllInsiderFlag IS NULL OR @inp_nAllInsiderFlag = 0) AND
					 (@inp_nAllEmployeeInsiderFlag IS NULL OR @inp_nAllEmployeeInsiderFlag = 0) )
			BEGIN
				--Insert filter for InsiderTypeCodeId = 101003 (Employee) from @inp_tblApplicabilityFilterType : build string and execute
				IF(@ntblFilterCnt > 0)
				BEGIN
					INSERT INTO rul_ApplicabilityDetails_OS( 
								ApplicabilityMstId, AllEmployeeFlag, AllInsiderFlag, AllEmployeeInsiderFlag, 
								InsiderTypeCodeId, DepartmentCodeId, GradeCodeId, DesignationCodeId, 
								RoleId, Category, SubCategory,
								CreatedBy, CreatedOn, ModifiedBy, ModifiedOn ) 
					SELECT @nApplicabilityMasterId, 0, 0, 0, 
						   @nUserTypeEmployeeCodeId, INP_TBL_APP_FILTER.DepartmentCodeId, INP_TBL_APP_FILTER.GradeCodeId, INP_TBL_APP_FILTER.DesignationCodeId,
						   INP_TBL_APP_FILTER.RoleId, INP_TBL_APP_FILTER.CategoryCodeId, INP_TBL_APP_FILTER.SubCategoryCodeId,
						   @inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate() 
					FROM @inp_tblApplicabilityFilterType INP_TBL_APP_FILTER 
				END			
			END
			IF( (@inp_nAllEmployeeFlag IS NULL OR @inp_nAllEmployeeFlag = 0) AND 
					 (@inp_nAllInsiderFlag IS NULL OR @inp_nAllInsiderFlag = 0) )
				BEGIN
					--Insert filter for InsiderTypeCodeId = 101003 (Employee) from @inp_tblApplicabilityFilterType : build string and execute
					IF(@ntblNonInsEmpFilterCnt > 0)
					BEGIN
						INSERT INTO rul_ApplicabilityDetails_OS( 
									ApplicabilityMstId, AllEmployeeFlag, AllInsiderFlag, AllEmployeeInsiderFlag, 
									InsiderTypeCodeId, NonInsFltrDepartmentCodeId, NonInsFltrGradeCodeId, NonInsFltrDesignationCodeId, 
									NonInsFltrRoleId, NonInsFltrCategory, NonInsFltrSubCategory,
									CreatedBy, CreatedOn, ModifiedBy, ModifiedOn ) 
						SELECT @nApplicabilityMasterId, 0, 0, 0, 
							   @nUserTypeEmployeeCodeId, INP_TBL_APP_FILTER.DepartmentCodeId, INP_TBL_APP_FILTER.GradeCodeId, INP_TBL_APP_FILTER.DesignationCodeId,
							   INP_TBL_APP_FILTER.RoleId, INP_TBL_APP_FILTER.CategoryCodeId, INP_TBL_APP_FILTER.SubCategoryCodeId,
							   @inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate() 
						FROM @inp_tblNonInsEmpApplicabilityFilterType INP_TBL_APP_FILTER 
					END
				END
			
			--If there are records in @inp_tblApplicabilityIncludeExcludeUsers then, set @bInsertApplicabilityIncludeExcludeRecords = 1 to indicate : Insert records for all include/exclude users from @inp_tblApplicabilityIncludeExcludeUsers
			IF(@ntblIncludeExcludeUsersCnt > 0)
			BEGIN
				SELECT @bInsertApplicabilityIncludeExcludeRecords = 1
			END
		END
		--Insert records for all include/exclude users from @inp_tblApplicabilityIncludeExcludeUsers
		IF(@bInsertApplicabilityIncludeExcludeRecords = 1 AND @ntblIncludeExcludeUsersCnt > 0)
		BEGIN
			IF(@inp_nMapToTypeCodeId = @nMapToTypeCodeId_RestrictedList)
			BEGIN
				INSERT INTO rul_ApplicabilityDetails_OS( 
						ApplicabilityMstId, AllEmployeeFlag, AllInsiderFlag, AllEmployeeInsiderFlag, 
						InsiderTypeCodeId, UserId, IncludeExcludeCodeId, 
						CreatedBy, CreatedOn, ModifiedBy, ModifiedOn ) 
				SELECT @nApplicabilityMasterId, 0, 0, 0,
						INP_INC_EXC_USERS.InsiderTypeCodeId, INP_INC_EXC_USERS.UserId, INP_INC_EXC_USERS.IncludeExcludeCodeId,
						@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate() 
				FROM @inp_tblApplicabilityIncludeExcludeUsers INP_INC_EXC_USERS
				INNER JOIN usr_UserInfo U ON INP_INC_EXC_USERS.UserId = U.UserInfoId
				INNER JOIN usr_UserRole R ON INP_INC_EXC_USERS.UserId = R.UserInfoID
				WHERE U.DepartmentId NOT IN (SELECT DepartmentCodeId FROM @inp_tblApplicabilityFilterType)
				OR U.GradeId NOT IN (SELECT GradeCodeId FROM @inp_tblApplicabilityFilterType)
				OR U.DesignationId NOT IN (SELECT DesignationCodeId FROM @inp_tblApplicabilityFilterType)
				OR U.Category NOT IN (SELECT CategoryCodeId FROM @inp_tblApplicabilityFilterType)
				OR U.SubCategory NOT IN (SELECT SubCategoryCodeId FROM @inp_tblApplicabilityFilterType)
				OR R.RoleID NOT IN (SELECT RoleID FROM @inp_tblApplicabilityFilterType)
				--dumping st_rul_ApplicabilityAssociationList_Employee data into temp table
				CREATE TABLE #Temp_ApplicabilityAssociationList_Employee(UserInfoId INT,EmployeeName VARCHAR(50),EmployeeId VARCHAR(50),Department VARCHAR(50),Grade VARCHAR(50),Designation VARCHAR(50))
				INSERT INTO #Temp_ApplicabilityAssociationList_Employee(UserInfoId,EmployeeName,EmployeeId,Department,Grade, Designation)			
				exec sp_executesql N'exec st_com_PopulateGrid @0,@1,@2,@3 ,@4,@5,@6,@7 ,@8 ,@9 ,@10 ,@11,@12 ,@13 ,@14 ,@15 ,@16 ,@17 ,@18 ,@19 ,@20 ,@21 ,	@22 ,@23 ,@24,@25 ,@26 ,@27 ,@28 ,@29 ,@30 ,@31 ,@32 ,@33 ,@34,@35,@36,@37,@38,@39,@40,@41,@42,@43,@44,@45,@46,@47,@48,@49,@50,@51,@52,@53,@54',N'@0 int,@1 int,@2 int,@3 nvarchar(4000),@4 nvarchar(4000),@5 nvarchar(4000),@6 nvarchar(4000),@7 nvarchar(4000),@8 nvarchar(4000),@9 nvarchar(4000),@10 nvarchar(4000),@11 nvarchar(4000),@12 nvarchar(4000),@13 nvarchar(4000),@14 nvarchar(4000),@15 nvarchar(4000),@16 nvarchar(4000),@17 nvarchar(4000),@18 nvarchar(4000),@19 nvarchar(4000),@20 nvarchar(4000),@21 nvarchar(4000),@22 nvarchar(4000),@23 nvarchar(4000),@24 nvarchar(4000),@25 nvarchar(4000),@26 nvarchar(4000),@27 nvarchar(4000),@28 nvarchar(4000),@29 nvarchar(4000),@30 nvarchar(4000),@31 nvarchar(4000),@32 nvarchar(4000),@33 nvarchar(4000),@34 nvarchar(4000),@35 nvarchar(4000),@36 nvarchar(4000),@37 nvarchar(4000),@38 nvarchar(4000),@39 nvarchar(4000),@40 nvarchar(4000),@41 nvarchar(4000),@42 nvarchar(4000),@43 nvarchar(4000),@44 nvarchar(4000),@45 nvarchar(4000),@46 nvarchar(4000),@47 nvarchar(4000),@48 nvarchar(4000),@49 nvarchar(4000),@50 nvarchar(4000),@51 nvarchar(4000),@52 nvarchar(4000),@53 nvarchar(4000),@54 nvarchar(4000)',
				@0=114133,@1=0,@2=0,@3=NULL,@4=NULL,@5=N'132012',@6=@inp_nMapToId,@7=NULL,@8=NULL,@9=NULL,@10=NULL,@11=NULL,@12=NULL,@13=NULL,@14=NULL,@15=NULL,@16=NULL,@17=NULL,@18=NULL,@19=NULL,@20=NULL,@21=NULL,@22=NULL,@23=NULL,@24=NULL,@25=NULL,@26=NULL,@27=NULL,@28=NULL,@29=NULL,@30=NULL,@31=NULL,@32=NULL,@33=NULL,@34=NULL,@35=NULL,@36=NULL,@37=NULL,@38=NULL,@39=NULL,@40=NULL,@41=NULL,@42=NULL,@43=NULL,@44=NULL,@45=NULL,@46=NULL,@47=NULL,@48=NULL,@49=NULL,@50=NULL,@51=NULL,@52=NULL,@53=NULL,@54=NULL
				
				SELECT @nUserCount=COUNT(USerInfoId) FROM #Temp_ApplicabilityAssociationList_Employee
				
				UPDATE rul_ApplicabilityMaster_OS 
				SET  UserCount=@nUserCount
				Where MapToTypeCodeId=@nMapToTypeCodeId_RestrictedList 
				AND MapToId=@inp_nMapToId AND VersionNumber=@nApplicabilityVersionNumber

				
				
			END
			ELSE
			BEGIN
				INSERT INTO rul_ApplicabilityDetails_OS( 
						ApplicabilityMstId, AllEmployeeFlag, AllInsiderFlag, AllEmployeeInsiderFlag, 
						InsiderTypeCodeId, UserId, IncludeExcludeCodeId, 
						CreatedBy, CreatedOn, ModifiedBy, ModifiedOn ) 
				SELECT @nApplicabilityMasterId, 0, 0, 0,
						INP_INC_EXC_USERS.InsiderTypeCodeId, INP_INC_EXC_USERS.UserId, INP_INC_EXC_USERS.IncludeExcludeCodeId,
						@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate() 
				FROM @inp_tblApplicabilityIncludeExcludeUsers INP_INC_EXC_USERS
			END
			
		END
		--After applicability is saved, if MapToType has status as Incomplete then set its status=Inactive
		
		SELECT @nCountUserAndOverlapTradingPolicy = 0
		IF(@inp_nMapToTypeCodeId = @nMapToTypeCodeId_TradingPolicy)
		BEGIN
			
			EXEC st_rul_UserwiseOverlapTradingPolicyCount @inp_nMapToId, @nCountUserAndOverlapTradingPolicy OUTPUT, @out_nReturnValue OUTPUT ,@out_nSQLErrCode OUTPUT ,@out_sSQLErrMessage OUTPUT 
		
		END
		SELECT @out_nCountUserAndOverlapTradingPolicy = ISNULL(@nCountUserAndOverlapTradingPolicy, 0)
		
	END TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_APPLICABILITY_ASSOCIATION_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
		

END