/*Script By Harish Dated- 15 March 2018 */
/*UPDATE existing Restricted list master table to store the applicability count value*/
IF EXISTS (
		SELECT *
		FROM rul_ApplicabilityMaster am
		WHERE am.UserCount = 0
			AND MapToTypeCodeId = 132012
		)
BEGIN
	DECLARE @n_NCount INT = 0
	DECLARE @COUNTER INT = 1
	DECLARE @inp_ID INT = 1
	DECLARE @n_UpdateApplicabilityId INT = 0;
	DECLARE @inp_nMapToId INT = 0
	DECLARE @nMapToTypeCodeId_RestrictedList INT = 132012
	DECLARE @nUserCount INT = 0

	CREATE TABLE #Temp_Tbl_ApplicabilityMaster (
		ID INT IDENTITY(1, 1)
		,ApplicabilityId INT
		,MapToId INT
		)

	INSERT INTO #Temp_Tbl_ApplicabilityMaster
	SELECT am.ApplicabilityId
		,am.MapToId
	FROM rul_ApplicabilityMaster am
	WHERE am.UserCount = 0

	SELECT @n_NCount = COUNT(*)
	FROM #Temp_Tbl_ApplicabilityMaster

	WHILE (@COUNTER <= @n_NCount)
	BEGIN
		SELECT @n_UpdateApplicabilityId = tAM.ApplicabilityId
			,@inp_nMapToId = tAM.MapToId
		FROM #Temp_Tbl_ApplicabilityMaster AS tAM
		WHERE ID = @inp_ID

		CREATE TABLE #st_rul_ApplicabilityAssociationList_Employee_Update (
			UserInfoId INT
			,EmployeeName VARCHAR(50)
			,EmployeeId VARCHAR(50)
			,Department VARCHAR(50)
			,Grade VARCHAR(50)
			,Designation VARCHAR(50)
			)

		INSERT INTO #st_rul_ApplicabilityAssociationList_Employee_Update (
			UserInfoId
			,EmployeeName
			,EmployeeId
			,Department
			,Grade
			,Designation
			)
		EXEC sp_executesql N'exec st_com_PopulateGrid @0,@1,@2,@3 ,@4,@5,@6,@7 ,@8 ,@9 ,@10 ,@11,@12 ,@13 ,@14 ,@15 ,@16 ,@17 ,@18 ,@19 ,@20 ,@21 ,	@22 ,@23 ,@24,@25 ,@26 ,@27 ,@28 ,@29 ,@30 ,@31 ,@32 ,@33 ,@34,@35,@36,@37,@38,@39,@40,@41,@42,@43,@44,@45,@46,@47,@48,@49,@50,@51,@52,@53,@54',N'@0 int,@1 int,@2 int,@3 nvarchar(4000),@4 nvarchar(4000),@5 nvarchar(4000),@6 nvarchar(4000),@7 nvarchar(4000),@8 nvarchar(4000),@9 nvarchar(4000),@10 nvarchar(4000),@11 nvarchar(4000),@12 nvarchar(4000),@13 nvarchar(4000),@14 nvarchar(4000),@15 nvarchar(4000),@16 nvarchar(4000),@17 nvarchar(4000),@18 nvarchar(4000),@19 nvarchar(4000),@20 nvarchar(4000),@21 nvarchar(4000),@22 nvarchar(4000),@23 nvarchar(4000),@24 nvarchar(4000),@25 nvarchar(4000),@26 nvarchar(4000),@27 nvarchar(4000),@28 nvarchar(4000),@29 nvarchar(4000),@30 nvarchar(4000),@31 nvarchar(4000),@32 nvarchar(4000),@33 nvarchar(4000),@34 nvarchar(4000),@35 nvarchar(4000),@36 nvarchar(4000),@37 nvarchar(4000),@38 nvarchar(4000),@39 nvarchar(4000),@40 nvarchar(4000),@41 nvarchar(4000),@42 nvarchar(4000),@43 nvarchar(4000),@44 nvarchar(4000),@45 nvarchar(4000),@46 nvarchar(4000),@47 nvarchar(4000),@48 nvarchar(4000),@49 nvarchar(4000),@50 nvarchar(4000),@51 nvarchar(4000),@52 nvarchar(4000),@53 nvarchar(4000),@54 nvarchar(4000)',
			@0=114026,@1=0,@2=0,@3=NULL,@4=NULL,@5=N'132012',@6=@inp_nMapToId,@7=NULL,@8=NULL,@9=NULL,@10=NULL,@11=NULL,@12=NULL,@13=NULL,@14=NULL,@15=NULL,@16=NULL,@17=NULL,@18=NULL,@19=NULL,@20=NULL,@21=NULL,@22=NULL,@23=NULL,@24=NULL,@25=NULL,@26=NULL,@27=NULL,@28=NULL,@29=NULL,@30=NULL,@31=NULL,@32=NULL,@33=NULL,@34=NULL,@35=NULL,@36=NULL,@37=NULL,@38=NULL,@39=NULL,@40=NULL,@41=NULL,@42=NULL,@43=NULL,@44=NULL,@45=NULL,@46=NULL,@47=NULL,@48=NULL,@49=NULL,@50=NULL,@51=NULL,@52=NULL,@53=NULL,@54=NULL

		SELECT @nUserCount = COUNT(USerInfoId)
		FROM #st_rul_ApplicabilityAssociationList_Employee_Update

		UPDATE rul_ApplicabilityMaster
		SET UserCount = @nUserCount
		WHERE ApplicabilityId = @n_UpdateApplicabilityId
			AND MapToTypeCodeId = @nMapToTypeCodeId_RestrictedList
			AND MapToId = @inp_nMapToId

		DROP TABLE #st_rul_ApplicabilityAssociationList_Employee_Update

		SET @COUNTER = @COUNTER + 1
		SET @inp_ID = @inp_ID + 1
	END

	DROP TABLE #Temp_Tbl_ApplicabilityMaster
END