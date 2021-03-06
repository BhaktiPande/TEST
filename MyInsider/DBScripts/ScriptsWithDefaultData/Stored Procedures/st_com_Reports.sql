IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_Reports')
	DROP PROCEDURE st_com_Reports
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to List data for all report based on @REPORT_ID
				
Created by:		Amin/ Aniket S.
Created on:		18-Jun-2015

Modification History:
Modified By	Modified ON	Description
ED		01-Mar-2016	Changes during code merge done on 1-March-2016
--Initial Disclosure Reports
exec st_com_Reports @REPORT_ID=N'122061',@IS_MASTER=N'1',@inp_iUserInfoId=N'12714'
exec st_com_Reports @REPORT_ID=N'122061',@IS_MASTER=N'2',@inp_iUserInfoId=N'12714'

--Continuous Disclosures Report
exec st_com_Reports @REPORT_ID=N'122062',@IS_MASTER=N'1',@inp_iUserInfoId=N'12,19'
exec st_com_Reports @REPORT_ID=N'122062',@IS_MASTER=N'3',@inp_iUserInfoId=N'3,5',@inp_FromDate='2010-01-01',@inp_ToDate='2017-12-12',@inp_PanNumber='ABCDE1253H'

--Period End Disclosure Reports
exec st_com_Reports @REPORT_ID=N'122060',@IS_MASTER=N'1',@inp_iUserInfoId=N'12,19'
exec st_com_Reports @REPORT_ID=N'122060',@IS_MASTER=N'2',@inp_iUserInfoId=N'3,5'

--Pre Clearance Report
exec st_com_Reports @REPORT_ID=N'122063',@IS_MASTER=N'1',@inp_iUserInfoId=N'12,19'
exec st_com_Reports @REPORT_ID=N'122063',@IS_MASTER=N'2',@inp_iUserInfoId=N'3,5'

--Defaulter Report
exec st_com_Reports @REPORT_ID=N'132011',@IS_MASTER=N'1',@inp_iUserInfoId=N'""'

*/



CREATE PROCEDURE st_com_Reports
	@REPORT_ID			VARCHAR(50),
	@IS_MASTER			INT,
	@inp_iUserInfoId	VARCHAR(MAX),
	@inp_PanNumber		VARCHAR (MAX)= NULL,
	@inp_Category       NVARCHAR(MAX)= NULL,
	@inp_EmpStatus      NVARCHAR(MAX)= NULL,
	@inp_EmpSepOrLive   NVARCHAR(MAX)= NULL,
	@inp_FromDate		VARCHAR(500)=NULL,
	@inp_ToDate			VARCHAR(500)=NULL
AS

BEGIN

DECLARE   @nEmployee                 INT = 101003,
		  @nCorpUser                 INT = 101004,
	      @nNonEmployee              INT = 101006,
	      @nEmpStatusLiveCode        INT = 510001,
          @nEmpStatusSeparatedCode   INT = 510002,
          @nYearCodeId               varchar (500),
          @nPeriodCodeId             varchar (500),
          @nTotalRecordCount         INT = 0,
          @nCounter                  INT = 1

	--Initial Disclosure Reports
	IF @REPORT_ID = '122061' AND @IS_MASTER = 0
		BEGIN
			 SELECT DISTINCT UF.UserInfoId, ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' '+ ISNULL(LastName,'') AS USER_NAME FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee)
		END

	ELSE IF @REPORT_ID = '122061' AND @IS_MASTER = 4
		BEGIN
             SELECT DISTINCT UF.PAN AS PAN FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee)
		END

	ELSE IF @REPORT_ID = '122061' AND @IS_MASTER = 5
		BEGIN
			SELECT DISTINCT ISNULL(CCate.DisplayCode,CCate.CodeName) AS Category FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
			JOIN com_Code CCate ON CCate.CodeID = UF.Category
			AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee)
			UNION 
			SELECT DISTINCT UF.CategoryText AS Category FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
			AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee) AND UF.CategoryText IS NOT NULL
		END

	ELSE IF @REPORT_ID = '122061' AND @IS_MASTER = 6
		BEGIN
			SELECT DISTINCT UF.StatusCodeId,CStatus.CodeName as  CodeName FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
			JOIN com_Code CStatus ON CStatus.CodeID = UF.StatusCodeId
			AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee) 
		END
	ELSE IF @REPORT_ID = '122061' AND @IS_MASTER = 7
		BEGIN
			SELECT CodeName AS LiveOrSeperated FROM com_Code WHERE CodeID = @nEmpStatusLiveCode
	        UNION
	        SELECT CodeName AS LiveOrSeperated FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode
		END

	ELSE IF (@REPORT_ID = '122061' AND @IS_MASTER = 1)
		BEGIN
			EXEC st_com_PopulateGrid 114050, 0, 1, 'rpt_grd_19004', 'ASC',@inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,0,0,'' 
		END
	ELSE IF (@REPORT_ID = '122061' AND @IS_MASTER = 2)
		BEGIN
			EXEC st_com_PopulateGrid 114052, 0, 1, 'rpt_grd_19032', 'ASC',3,@inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,0,0,'' 
		END
	ELSE IF(@REPORT_ID = '122061' AND @IS_MASTER = 3)
		BEGIN
			print @inp_EmpStatus
			EXEC st_com_PopulateGrid 1140592, 0, 1, 'rpt_grd_19004', 'ASC',@inp_iUserInfoId,NULL,NULL,@inp_FromDate,@inp_ToDate,NULL,@inp_PanNumber,@inp_Category,@inp_EmpStatus,@inp_EmpSepOrLive,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,0,0,''

			EXEC st_com_PopulateGrid 1140603, 0, 1, 'rpt_grd_19032', 'ASC',3,@inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,0,0,'' 	
			
			Declare @sql_queryInitialDisClosure VARCHAR (MAX) 
			Declare @Where_ClauseInitialDisClosure VARCHAR (MAX)=''
				
			SET @sql_queryInitialDisClosure= 'SELECT ISNULL(rpt_grd_19004,''-'') as rpt_grd_19004,ISNULL(rpt_grd_19005,''-'') AS rpt_grd_19005,ISNULL(CASE  WHEN tempDetails.rpt_grd_19034=''Self'' THEN (SELECT TOP 1  PAN  FROM usr_UserInfo WHERE UserInfoId =tempDetails.UserInfoId) ELSE (SELECT TOP 1  PAN  FROM usr_UserInfo WHERE UserInfoId =tempDetails.UserInfoIdRelative) END ,''-'') AS UserPANNumber, DateOfSeperation, ISNULL(rpt_grd_19006,''-'') AS rpt_grd_19006, ISNULL(rpt_grd_19007,''-'') AS rpt_grd_19007,
			ISNULL(rpt_grd_19008,''-'') AS rpt_grd_19008, ISNULL(rpt_grd_19009,''-'') AS rpt_grd_19009, ISNULL(rpt_grd_19010,''-'') AS rpt_grd_19010, ISNULL(rpt_grd_19011,''-'') AS rpt_grd_19011,rpt_grd_19012 ,
			rpt_grd_19013,rpt_grd_19072 ,rpt_grd_19073 ,rpt_grd_19015,rpt_grd_19016,rpt_grd_19017,
			tempMaster.UserInfoID as UserInfoID,LetterForCodeId,TransactionMasterId,EmployeeId,TransactionLetterId,DisclosureTypeCodeId,Acid,DateOfInactivation, ISNULL(Category,''-'') AS Category, ISNULL(SubCategory,''-'') AS SubCategory,CodeName,LiveOrSeperated,
			ISNULL(rpt_grd_19032,''-'') AS rpt_grd_19032, ISNULL(rpt_grd_19033,''-'') AS rpt_grd_19033,rpt_grd_19034 ,rpt_grd_19035, ISNULL( rpt_grd_19036,''-'') AS rpt_grd_19036 ,rpt_grd_19037 ,ISNULL( rpt_grd_19038,''-'') AS rpt_grd_19038
			FROM ##TempMaster tempMaster join ##TempDetails tempDetails
			ON tempMaster.UserInfoId=tempDetails.UserInfoId'

			EXEC (@sql_queryInitialDisClosure)
				
			DROP TABLE ##TempMaster	
			DROP TABLE ##TempDetails
	END
		
	--Continuous Disclosures Report
	IF @REPORT_ID = '122062' AND @IS_MASTER = 0
		BEGIN
			SELECT DISTINCT UF.UserInfoId, ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' '+ ISNULL(LastName,'') AS USER_NAME FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID LEFT JOIN com_Code CSubDesignation ON UF.SubDesignationId = CSubDesignation.CodeID LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID INNER JOIN vw_ContinuousDisclosureStatus CDS on CDS.UserInfoId = UF.UserInfoId WHERE 1 = 1 ORDER BY ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' '+ ISNULL(LastName,'')
		END
	ELSE IF (@REPORT_ID = '122062' AND @IS_MASTER = 1)
		BEGIN
			EXEC st_com_PopulateGrid 114059, 0, 1, 'rpt_grd_19074', 'ASC',@inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,0,0,'' 
		END
	ELSE IF (@REPORT_ID = '122062' AND @IS_MASTER = 2)
		BEGIN
			EXEC st_com_PopulateGrid 114060, 0, 1, 'rpt_grd_19090', 'ASC',NULL,@inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,0,0,'' 
		END
	ELSE IF(@REPORT_ID = '122062' AND @IS_MASTER = 3)
		BEGIN			
			EXEC st_com_PopulateGrid 1140591, 0, 1, 'rpt_grd_19074', 'ASC',@inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,@inp_PanNumber,@inp_Category,@inp_EmpStatus,@inp_EmpSepOrLive,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,0,0,''

			EXEC st_com_PopulateGrid 1140602, 0, 1, 'rpt_grd_19090', 'ASC',NULL,@inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,@inp_FromDate,@inp_ToDate,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,0,0,'' 	
			
			Declare @sql_query1 VARCHAR (MAX) 
			Declare @Where_Clause VARCHAR (MAX)=''
			Declare @Where_DateClause VARCHAR (MAX)=''
			
			SET @sql_query1= 'SELECT isnull(EmployeeId,''-'') as EmployeeId ,isnull(InsiderName,''-'') as InsiderName,isnull(tempDetails.PAN,''-'') as pan,JoiningDate,DateOfInactivation,CINNumber,isnull(Designation,''-'') as Designation,isnull(Grade,''-'') as Grade,isnull(Location,''-'') as Location,isnull(Department,''-'') as Department,isnull(Category,''-'') as Category,isnull(SubCategory,''-'') as SubCategory,[status],CompanyName,TypeOfInsider,Dematacc,accHolderName,relWithInsider,isnull(LiveOrSeperated,''-'') as LiveOrSeperated,isnull(CodeName,''-'') as CodeName,
			SecurityType,TransactionType,CASE WHEN BuyQuantity=0 THEN SellQuantity ELSE BuyQuantity END AS Quantity, Value,TransactionDate,DetailsSubmissionDate,ContDisReq,DisTobesubmittedDate,SoftCopyReq,HardCopyReq,Comments,CDToStockExc
			FROM ##TempMaster tempMaster join ##TempDetails tempDetails
			ON tempMaster.UserInfoId=tempDetails.UserInfoId '
			
			EXEC (@sql_query1)
			DROP TABLE ##TempMaster	
			DROP TABLE ##TempDetails
		END
	ELSE IF @REPORT_ID = '122062' AND @IS_MASTER = 4
		BEGIN
		--SELECT DISTINCT UF.UserInfoId, ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' '+ ISNULL(LastName,'') AS USER_NAME FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID LEFT JOIN com_Code CSubDesignation ON UF.SubDesignationId = CSubDesignation.CodeID LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID INNER JOIN vw_ContinuousDisclosureStatus CDS on CDS.UserInfoId = UF.UserInfoId WHERE 1 = 1 ORDER BY ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' '+ ISNULL(LastName,'')

		SELECT DISTINCT ISNULL(CCate.DisplayCode,CCate.CodeName) AS Category FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
		INNER JOIN vw_ContinuousDisclosureStatus CDS on CDS.UserInfoId = UF.UserInfoId
		JOIN com_Code CCate ON CCate.CodeID = UF.Category
		AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee)
		UNION 
		SELECT DISTINCT UF.CategoryText AS Category FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
		INNER JOIN vw_ContinuousDisclosureStatus CDS on CDS.UserInfoId = UF.UserInfoId
		AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee) AND UF.CategoryText IS NOT NULL

		END
	ELSE IF @REPORT_ID = '122062' AND @IS_MASTER = 5
		BEGIN
			
		SELECT DISTINCT UF.StatusCodeId,CStatus.CodeName as  CodeName FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
		JOIN com_Code CStatus ON CStatus.CodeID = UF.StatusCodeId
		AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee) 
		END
	ELSE IF @REPORT_ID = '122062' AND @IS_MASTER = 6
		BEGIN
		SELECT CodeName AS LiveOrSeperated FROM com_Code WHERE CodeID = @nEmpStatusLiveCode
	    UNION
	    SELECT CodeName AS LiveOrSeperated FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode
		END
		
	--Period End Disclosure Reports
	IF (@REPORT_ID = '122060' AND @IS_MASTER = 0)
		BEGIN
			SELECT DISTINCT UF.UserInfoId, ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' '+ ISNULL(LastName,'') AS USER_NAME FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID LEFT JOIN com_Code CSubDesignation ON UF.SubDesignationId = CSubDesignation.CodeID LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID INNER JOIN vw_PeriodEndDisclosureStatus CDS on CDS.UserInfoId = UF.UserInfoId WHERE 1 = 1 ORDER BY ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' '+ ISNULL(LastName,'')
		END
		
	ELSE IF (@REPORT_ID = '122060' AND @IS_MASTER = 4)
		BEGIN
             SELECT DISTINCT UF.PAN AS PAN FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId INNER JOIN vw_PeriodEndDisclosureStatus CDS on CDS.UserInfoId = UF.UserInfoId AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee)
		END

	ELSE IF (@REPORT_ID = '122060' AND @IS_MASTER = 5)
		BEGIN
			SELECT DISTINCT ISNULL(CCate.DisplayCode,CCate.CodeName) AS Category FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
			INNER JOIN vw_PeriodEndDisclosureStatus CDS on CDS.UserInfoId = UF.UserInfoId
			JOIN com_Code CCate ON CCate.CodeID = UF.Category
			AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee)
			UNION 
			SELECT DISTINCT UF.CategoryText AS Category FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
			INNER JOIN vw_PeriodEndDisclosureStatus CDS on CDS.UserInfoId = UF.UserInfoId
			AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee) AND UF.CategoryText IS NOT NULL
		END

	ELSE IF (@REPORT_ID = '122060' AND @IS_MASTER = 6)
		BEGIN
			SELECT DISTINCT UF.StatusCodeId,CStatus.CodeName as  CodeName FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
			JOIN com_Code CStatus ON CStatus.CodeID = UF.StatusCodeId
			AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee) 
		END
	ELSE IF (@REPORT_ID = '122060' AND @IS_MASTER = 7)
		BEGIN
			SELECT CodeName AS LiveOrSeperated FROM com_Code WHERE CodeID = @nEmpStatusLiveCode
	        UNION
	        SELECT CodeName AS LiveOrSeperated FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode
		END
		
	ELSE IF (@REPORT_ID = '122060' AND @IS_MASTER = 1)
		BEGIN
			EXEC st_com_PopulateGrid 114053, 0, 1, 'rpt_grd_19039', 'ASC',NULL,NULL,@inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'' 
		END
	ELSE IF (@REPORT_ID = '122060' AND @IS_MASTER = 2)
		BEGIN
			EXEC st_com_PopulateGrid 114054, 0, 1, 'rpt_grd_19054', 'asc',3,NULL,NULL,@inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,''
		END
		
	ELSE IF(@REPORT_ID = '122060' AND @IS_MASTER = 3)
		BEGIN
			EXEC st_com_PopulateGrid 1140593, 0, 1, 'rpt_grd_19039', 'ASC',NULL,NULL,@inp_iUserInfoId,NULL,NULL,@inp_FromDate,@inp_ToDate,NULL,NULL,@inp_PanNumber,@inp_Category,@inp_EmpStatus,@inp_EmpSepOrLive,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,'' 
			
			select * from ##TempMasterWithDetails
			drop table ##TempMasterWithDetails
		
	END
		
		
	--Pre Clearance Report
	IF (@REPORT_ID = '122063' AND @IS_MASTER = 0)
		BEGIN
			SELECT DISTINCT UF.UserInfoId, ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' '+ ISNULL(LastName,'') AS USER_NAME FROM usr_UserInfo UF INNER JOIN tra_PreclearanceRequest PL ON PL.UserInfoId = UF.UserInfoId JOIN mst_Company C ON UF.CompanyId = C.CompanyId LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID LEFT JOIN com_Code CSubDesignation ON UF.SubDesignationId = CSubDesignation.CodeID LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID WHERE 1 = 1 ORDER BY ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' '+ ISNULL(LastName,'')
		END
	ELSE IF (@REPORT_ID = '122063' AND @IS_MASTER = 1)
		BEGIN			
			EXEC st_com_PopulateGrid 114061, 0, 1, 'rpt_grd_19191', 'ASC', @inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, NULL, 0, 0, ''
		END
	ELSE IF (@REPORT_ID = '122063' AND @IS_MASTER = 2)
		BEGIN
			EXEC st_com_PopulateGrid 114062, 0, 1, 'rpt_grd_19206', 'ASC', 2, @inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, NULL, NULL, NULL, NULL
		END

		ELSE IF(@REPORT_ID = '122063' AND @IS_MASTER = 3)
		BEGIN
			EXEC st_com_PopulateGrid 1140594, 0, 1, 'rpt_grd_19191', 'ASC', @inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,@inp_PanNumber,@inp_Category,@inp_EmpStatus,@inp_EmpSepOrLive,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, NULL, 0, 0, ''

			EXEC st_com_PopulateGrid 1140605, 0, 1, 'rpt_grd_19206', 'ASC', 2, @inp_iUserInfoId,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,@inp_FromDate,@inp_ToDate,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, NULL, NULL, NULL, NULL	
			
			Declare @sql_queryPreClearanceReport VARCHAR (MAX) 			
				
			SET @sql_queryPreClearanceReport= 'SELECT tempMaster.UserInfoId,DateOfInactivation, ISNULL(Category,''-'') as Category,ISNULL(SubCategory,''-'') as SubCategory,StatusCodeId,isnull(rpt_grd_19191,''-'') as rpt_grd_19191 ,isnull(rpt_grd_19192,''-'') as rpt_grd_19192,rpt_grd_19193, isnull(rpt_grd_19194,''-'') as rpt_grd_19194,isnull(rpt_grd_19195,''-'') as rpt_grd_19195,isnull(rpt_grd_19196,''-'') as rpt_grd_19196,isnull(rpt_grd_19197,''-'') as rpt_grd_19197,isnull(rpt_grd_19198,''-'') as rpt_grd_19198,isnull(rpt_grd_19199,''-'') as rpt_grd_19199,rpt_grd_19201,rpt_grd_19202,rpt_grd_19203,rpt_grd_19204,rpt_grd_19205, isnull(UserPANNumber,''-'') as pan,isnull(LiveSeperated,''-'') as LiveSeperated,DateOfSeparation,
			rpt_grd_19206,rpt_grd_19207,rpt_grd_19208,rpt_grd_19209,rpt_grd_19210,rpt_grd_19211,rpt_grd_19212,rpt_grd_19213,rpt_grd_19214,rpt_grd_19215,rpt_grd_19216,rpt_grd_19218,rpt_grd_19219,rpt_grd_19220,rpt_grd_19221,rpt_grd_19222,rpt_grd_19223 ,PreclearanceId,TransactionStatusCodeId,TransactionTypeCodeId,PreclearanceStatusId,TransactionDetailsId,PreclearanceDate
			FROM ##TempMaster tempMaster join ##TempDetails tempDetails
			ON tempMaster.UserInfoId=tempDetails.UserInfoId'

			EXEC (@sql_queryPreClearanceReport)
				
			DROP TABLE ##TempMaster	
			DROP TABLE ##TempDetails
		END
		ELSE IF (@REPORT_ID = '122063' AND @IS_MASTER = 4)
		BEGIN			
				SELECT DISTINCT UF.PAN AS PAN FROM usr_UserInfo UF 
				JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
				INNER JOIN tra_PreclearanceRequest PR on PR.UserInfoId = UF.UserInfoId 
				AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee)
		END
		ELSE IF (@REPORT_ID = '122063' AND @IS_MASTER = 5)
		BEGIN			
				SELECT DISTINCT ISNULL(CCate.DisplayCode,CCate.CodeName) AS Category FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
				INNER JOIN tra_PreclearanceRequest CDS on CDS.UserInfoId = UF.UserInfoId
				JOIN com_Code CCate ON CCate.CodeID = UF.Category
				AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee)
				UNION 
				SELECT DISTINCT UF.CategoryText AS Category FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
				INNER JOIN tra_PreclearanceRequest CDS on CDS.UserInfoId = UF.UserInfoId
				AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee) AND UF.CategoryText IS NOT NULL
		END
		ELSE IF (@REPORT_ID = '122063' AND @IS_MASTER = 6)
		BEGIN			
				SELECT DISTINCT UF.StatusCodeId,CStatus.CodeName as  CodeName FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId 
				JOIN com_Code CStatus ON CStatus.CodeID = UF.StatusCodeId
				AND UF.UserTypeCodeId in (@nEmployee, @nCorpUser, @nNonEmployee)
		END
		ELSE IF (@REPORT_ID = '122063' AND @IS_MASTER = 7)
		BEGIN			
				SELECT CodeName AS LiveOrSeperated FROM com_Code WHERE CodeID = @nEmpStatusLiveCode
				UNION
				SELECT CodeName AS LiveOrSeperated FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode
		END
			
	--Defaulter Report
	IF (@REPORT_ID = '132011' AND @IS_MASTER = 0)
		BEGIN
			SELECT UserInfoId, ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' '+ ISNULL(LastName,'') AS USER_NAME FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID LEFT JOIN com_Code CSubDesignation ON UF.SubDesignationId = CSubDesignation.CodeID LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID WHERE 1 = 1 ORDER BY ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' '+ ISNULL(LastName,'')
		END
	ELSE IF(@REPORT_ID = '132011' AND @IS_MASTER = 1)
		BEGIN
			EXEC st_com_PopulateGrid 114078, 0, 1, 'rpt_grd_19272', 'ASC',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
			NULL,NULL,NULL,NULL,NULL,NULL,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, ''
		END	
END
