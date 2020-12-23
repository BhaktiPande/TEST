IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_DownloadEmployeeDetailsInExcel')
DROP PROCEDURE dbo.st_tra_DownloadEmployeeDetailsInExcel
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[st_tra_DownloadEmployeeDetailsInExcel] 
	 @out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
DECLARE     @nEmployeeStatusLive                                                VARCHAR(100),
			@nEmployeeStatusSeparated                                           VARCHAR(100),
			@nEmployeeStatusInactive                                            VARCHAR(100),
			@nEmpStatusLiveCode                                                 INT = 510001,
			@nEmpStatusSeparatedCode                                            INT = 510002,
			@nEmpStatusInactiveCode                                             INT = 510003,
			@nEmployeeActive                                                    INT = 102001,
			@nEmployeeInActive                                                  INT = 102002,
			@nEmpActive                                                         VARCHAR(100),
			@nEmpInActive                                                       VARCHAR(100),
			@nPeriodCodeId                                                      INT = 124001,
			@nShares                                                            INT = 139001,
			@nWarrants                                                          INT = 139002,
			@nConvertibleDebentures                                             INT = 139003,
			@nFutureContracts                                                   INT = 139004,
			@nOptionContracts                                                   INT = 139005,
			@nAdminUser                                                         INT = 101001, 
			@nCOUser                                                            INT = 101002, 
			@nRelative                                                          INT = 101007,
			@nEmployee	                                                        INT = 101003,
		    @nCorpUser                                                          INT =101004,
			@nNonEmployee                                                       INT =101006
			
			
			CREATE TABLE #TempRelativesHoldings(UserInfoID INT,Holdings INT,SecurityTypeCodeId INT, SecurityType VARCHAR(50))
			
			INSERT INTO #TempRelativesHoldings(UserInfoID,Holdings,SecurityTypeCodeId,SecurityType)
			SELECT A.UserInfoID,SUM(A.Holdings),A.SecurityTypeCodeId,SecType.CodeName FROM
			((SELECT u.UserInfoId,SUM(ts.ClosingBalance) AS 'Holdings',ts.SecurityTypeCodeId FROM usr_UserInfo u
			left join usr_UserRelation r on r.UserInfoId = u.UserInfoId
			INNER JOIN tra_TransactionSummary ts on ts.UserInfoIdRelative = r.UserInfoIdRelative
			where ts.YearCodeId= (SELECT MAX(tsumm.YearCodeId) FROM tra_TransactionSummary tsumm 
			WHERE tsumm.UserInfoId = u.UserInfoId GROUP BY tsumm.UserInfoId) and ts.PeriodCodeId=@nPeriodCodeId
			GROUP BY u.UserInfoId,ts.SecurityTypeCodeId)
			UNION 
			(SELECT u.UserInfoId,0 AS 'Holdings',ts.SecurityTypeCodeId FROM usr_UserInfo u
			INNER JOIN tra_TransactionSummary ts on ts.UserInfoIdRelative = u.UserInfoId
			where ts.YearCodeId= (SELECT MAX(tsumm.YearCodeId) FROM tra_TransactionSummary tsumm 
			WHERE tsumm.UserInfoId = u.UserInfoId GROUP BY tsumm.UserInfoId) and ts.PeriodCodeId=@nPeriodCodeId
			GROUP BY u.UserInfoId,ts.SecurityTypeCodeId)) A
			INNER JOIN com_Code SecType on SecType.CodeID = A.SecurityTypeCodeId
			GROUP BY A.UserInfoID,A.SecurityTypeCodeId,SecType.CodeName
					
			CREATE TABLE #tmpTrading(ApplicabilityMstId INT,UserInfoId INT,MapToId INT)
			
			INSERT INTO #tmpTrading(ApplicabilityMstId,UserInfoId,MapToId)
			
			EXEC st_tra_GetTradingPolicy			
			
            SELECT @nEmployeeStatusLive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusLiveCode
			
			SELECT @nEmployeeStatusSeparated = CodeName FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode
			
			SELECT @nEmployeeStatusInactive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusInactiveCode
			
			SELECT @nEmpActive = CodeName FROM com_Code WHERE CodeID = @nEmployeeActive
			
			SELECT @nEmpInActive = CodeName FROM com_Code WHERE CodeID = @nEmployeeInActive 	 		
				 
			CREATE TABLE #EmployeeWithTransaction(UserID INT,ApplicableTradingPolicyName varchar(50),TradingPolicyFromDate DateTime,TradingPolicyToDate DateTime,
			SecurityType varchar(50),SelfHoldings varchar(50),RelativesHolding varchar(50),TotalHoldingsSelfRelatives varchar(50))
			
			CREATE TABLE #OnlyRelativeTransaction(UserID INT,SecurityType varchar(50),SelfHoldings varchar(50),RelativesHolding varchar(50),TotalHoldingsSelfRelatives varchar(50))
			
			INSERT INTO #EmployeeWithTransaction(UserID, ApplicableTradingPolicyName,TradingPolicyFromDate,TradingPolicyToDate,SecurityType,
			SelfHoldings,RelativesHolding,TotalHoldingsSelfRelatives) 
			
			SELECT 					    
					u.UserInfoId as 'User ID',			    
					tp.TradingPolicyName as 'Applicable Trading Policy Name',					    
					tp.ApplicableFromDate as 'Trading Policy From Date',					    
					tp.ApplicableToDate as 'Trading Policy To Date',
					codeSecurityType.CodeName as 'Security Type',    
					ISNULL(ts.ClosingBalance ,0) as 'Self Holdings',
					CASE WHEN EXISTS (SELECT UserInfoID from #TempRelativesHoldings WHERE  UserInfoID=u.UserInfoId)			    
					THEN 					    
					CASE WHEN ts.SecurityTypeCodeId  = 	@nShares
					   THEN (SELECT ISNULL (Holdings,0) from #TempRelativesHoldings WHERE SecurityTypeCodeId=@nShares and UserInfoID=u.UserInfoId)
					ELSE CASE WHEN ts.SecurityTypeCodeId  = @nWarrants
					   THEN (SELECT ISNULL (Holdings,0) from #TempRelativesHoldings WHERE SecurityTypeCodeId=@nWarrants and UserInfoID=u.UserInfoId)
				    ELSE CASE WHEN ts.SecurityTypeCodeId  = @nConvertibleDebentures 
					   THEN (SELECT ISNULL (Holdings,0) from #TempRelativesHoldings WHERE SecurityTypeCodeId=@nConvertibleDebentures and UserInfoID=u.UserInfoId)
	                ELSE CASE WHEN ts.SecurityTypeCodeId  = @nFutureContracts 
					   THEN (SELECT ISNULL (Holdings,0) from #TempRelativesHoldings WHERE SecurityTypeCodeId=@nFutureContracts and UserInfoID=u.UserInfoId)
					ELSE CASE WHEN ts.SecurityTypeCodeId  = @nOptionContracts  
					   THEN (SELECT ISNULL (Holdings,0) from #TempRelativesHoldings WHERE SecurityTypeCodeId=@nOptionContracts and UserInfoID=u.UserInfoId)
					    END END END END END 
					ELSE 0 END as 'Relatives Holding', 
					CASE WHEN EXISTS (SELECT UserInfoID from #TempRelativesHoldings WHERE UserInfoID=u.UserInfoId)			    
					   THEN			    
					CASE WHEN ts.SecurityTypeCodeId  = @nShares 
					   THEN (ISNULL(ts.ClosingBalance,0) + (SELECT Holdings from #TempRelativesHoldings WHERE SecurityTypeCodeId=@nShares and UserInfoID=u.UserInfoId))
					ELSE CASE WHEN ts.SecurityTypeCodeId  = @nWarrants 
					   THEN (ISNULL(ts.ClosingBalance,0) + (SELECT Holdings from #TempRelativesHoldings WHERE SecurityTypeCodeId=@nWarrants and UserInfoID=u.UserInfoId))
					ELSE CASE WHEN ts.SecurityTypeCodeId  = @nConvertibleDebentures   
					   THEN (ISNULL(ts.ClosingBalance,0) + (SELECT Holdings from #TempRelativesHoldings WHERE SecurityTypeCodeId=@nConvertibleDebentures and UserInfoID=u.UserInfoId))
					ELSE CASE WHEN ts.SecurityTypeCodeId  = @nFutureContracts  
					   THEN (ISNULL(ts.ClosingBalance,0) + (SELECT Holdings from #TempRelativesHoldings WHERE SecurityTypeCodeId=@nFutureContracts and UserInfoID=u.UserInfoId))
					ELSE CASE WHEN ts.SecurityTypeCodeId  = @nOptionContracts 
					   THEN (ISNULL(ts.ClosingBalance,0) + (SELECT Holdings from #TempRelativesHoldings WHERE SecurityTypeCodeId=@nOptionContracts and UserInfoID=u.UserInfoId))
					   END END END END END 
					 ELSE ISNULL(ts.ClosingBalance,0) END as 'Total Holdings (Self & Relatives)'
					 from usr_UserInfo u  
					 JOIN #tmpTrading ap on u.UserInfoId = ap.UserInfoId and ap.MapToId = (SELECT TOP 1 (MapToId) FROM #tmpTrading where UserInfoId = u.UserInfoId ORDER BY MapToId DESC)
					 join rul_TradingPolicy tp on tp.TradingPolicyId = ap.MapToId
					 LEFT join tra_TransactionSummary ts on ts.UserInfoIdRelative = u.UserInfoId --LEFT
					 left join com_Code codeSecurityType on ts.SecurityTypeCodeId = codeSecurityType.CodeID
					 where ts.YearCodeId= (SELECT MAX(tsumm.YearCodeId) FROM tra_TransactionSummary tsumm 
					 WHERE tsumm.UserInfoId = u.UserInfoId GROUP BY tsumm.UserInfoId) and ts.PeriodCodeId=@nPeriodCodeId 
					 OR ts.YearCodeId IS NULL OR ts.PeriodCodeId IS NULL
					 UNION
					 SELECT 					    
						u.UserInfoId as 'User ID',			    
					    tp.TradingPolicyName as 'Applicable Trading Policy Name',					    
					    tp.ApplicableFromDate as 'Trading Policy From Date',					    
					    tp.ApplicableToDate as 'Trading Policy To Date',			
						NULL as 'Security Type',	
						CASE WHEN tm.NoHoldingFlag = 1 THEN 0
						ELSE 0 END as 'Self Holdings', 
						CASE WHEN tm.NoHoldingFlag = 1 THEN 0
						ELSE 0 END as 'Relatives Holding',
						CASE WHEN tm.NoHoldingFlag = 1 THEN 0
						ELSE 0 END 'Total Holdings (Self & Relatives)'
					 from usr_UserInfo u  
					 left JOIN #tmpTrading ap on u.UserInfoId = ap.UserInfoId and ap.MapToId = (SELECT TOP 1 (MapToId) FROM #tmpTrading where UserInfoId = u.UserInfoId ORDER BY MapToId DESC)
					 left join rul_TradingPolicy tp on tp.TradingPolicyId = ap.MapToId
					 left join tra_TransactionMaster tm on u.UserInfoId = tm.UserInfoId
					 where u.UserTypeCodeId not in (@nAdminUser, @nCOUser, @nRelative) and u.UserInfoId not in (select UserInfoId from tra_TransactionSummary)				 
					 
			INSERT INTO #OnlyRelativeTransaction(UserID,SecurityType,SelfHoldings,RelativesHolding,TotalHoldingsSelfRelatives)
			 
			select RH.UserInfoID, 
			   CASE WHEN ET.SecurityType IS NULL THEN RH.SecurityType 
			   ELSE ET.SecurityType END AS SecurityType,
			   ISNULL(ET.SelfHoldings,0) AS SelfHoldings,
			   CASE WHEN ET.RelativesHolding IS NULL 
			   THEN RH.Holdings 
			   ELSE ET.RelativesHolding END AS RelativesHolding,
			   CASE WHEN ET.RelativesHolding IS NULL 
			   THEN ISNULL(ET.SelfHoldings,0) + RH.Holdings 
			   ELSE ISNULL(ET.SelfHoldings,0) + ET.RelativesHolding END AS RelativesHolding
			FROM #TempRelativesHoldings rh
			left JOIN #EmployeeWithTransaction et on et.UserID=rh.UserInfoID and et.SecurityType=rh.SecurityType
			WHERE rh.Holdings <> 0 AND et.SecurityType IS NULL
			
			INSERT INTO #EmployeeWithTransaction(UserID, ApplicableTradingPolicyName,TradingPolicyFromDate,TradingPolicyToDate,
			SecurityType,SelfHoldings,RelativesHolding,TotalHoldingsSelfRelatives)  
			
			select u.UserInfoId,
			tp.TradingPolicyName as 'Applicable Trading Policy Name',					    
			tp.ApplicableFromDate as 'Trading Policy From Date',					    
			tp.ApplicableToDate as 'Trading Policy To Date',
			rt.SecurityType,
			rt.SelfHoldings,
			rt.RelativesHolding,
			rt.TotalHoldingsSelfRelatives
			from usr_UserInfo u 
			JOIN #tmpTrading ap on u.UserInfoId = ap.UserInfoId and ap.MapToId = (SELECT TOP 1 (MapToId) FROM #tmpTrading where UserInfoId = u.UserInfoId ORDER BY MapToId DESC)
			join rul_TradingPolicy tp on tp.TradingPolicyId = ap.MapToId
			inner JOIN #OnlyRelativeTransaction RT on RT.UserID=u.UserInfoId
			
			TRUNCATE TABLE rpt_EmployeeHoldingDetails
			
			INSERT INTO rpt_EmployeeHoldingDetails 
			
			SELECT 
			u.UserInfoId as 'User ID',
			codeUserName.LoginID as 'User Name', 
			ISNULL(u.FirstName,'-')as 'First Name', 		
			ISNULL(NULLIF(u.MiddleName ,''),'-') as 'Middle Name', 	
			ISNULL(NULLIF(u.LastName,''),'-') AS 'Last Name', 
						ISNULL(codeCompany.CompanyName,'-') as 'Company Name',
					    ISNULL(rm.RoleName,'-') as 'Role',
					    ISNULL(u.AddressLine1,'-') as 'Address',
						ISNULL(u.PinCode,'-') as 'Pin Code',
						ISNULL(codeCountry.CodeName,'-') as 'Country',
						ISNULL(u.EmailId,'-') as 'Email Address',
						ISNULL(u.MobileNumber,'-') as 'Mobile Number', ISNULL(u.PAN,'-') as 'Permanent Account Number',
						COALESCE(CONVERT(VARCHAR(25),u.DateOfJoining ,121) ,'-') as 'Date Of Joining', 
						COALESCE(CONVERT(VARCHAR(25),u.DateOfBecomingInsider ,121) ,'-') as 'Date Of Becoming Insider',
					    CASE WHEN u.StatusCodeId = @nEmployeeActive AND u.DateOfSeparation IS NULL THEN @nEmployeeStatusLive
				        WHEN u.StatusCodeId = @nEmployeeActive AND u.DateOfSeparation IS NOT NULL  THEN @nEmployeeStatusSeparated
				        WHEN u.StatusCodeId = @nEmployeeInActive THEN @nEmployeeStatusSeparated
				        END AS 'Live/ Seperated',        
				        COALESCE(CONVERT(VARCHAR(25),u.DateOfSeparation ,121) ,'-') as 'Date of Seperation',						
					    CASE WHEN u.StatusCodeId = @nEmployeeActive THEN @nEmpActive
				        WHEN u.StatusCodeId = @nEmployeeInActive THEN @nEmpInActive
				        END AS 'Status',		
						COALESCE(CONVERT(VARCHAR(25),u.DateOfInactivation  ,121) ,'-') as 'Date of Inactivation', 
							
						CASE WHEN u.UserTypeCodeId=@nEmployee THEN ISNULL(codeCategory.CodeName,'-')
						 ELSE COALESCE(u.CategoryText,'-')
					    END as 'Category',
					    CASE WHEN u.UserTypeCodeId=@nEmployee THEN ISNULL(codeSubCategory.CodeName,'-') 
						 ELSE COALESCE(u.SubCategoryText,'-')			    		  
					    END as 'SubCategory',					    
					    CASE WHEN u.UserTypeCodeId=@nEmployee THEN  ISNULL(codeDesignation.CodeName,'-') 
						 ELSE COALESCE(u.DesignationText,'-')						    
					    END as 'Designation',
					    CASE WHEN u.UserTypeCodeId=@nEmployee THEN  ISNULL(codeSubDesignation.CodeName,'-')  
						 ELSE COALESCE(u.SubDesignationText,'-')		
						END as 'Sub-Designation',
						CASE WHEN u.UserTypeCodeId=@nEmployee THEN  ISNULL(codeGrade.CodeName,'-') 
						 ELSE COALESCE(u.GradeText,'-')						    
					    END as 'Grade',
						ISNULL(u.Location,'-') as 'Location', ISNULL(u.DIN,'-') as 'DIN', 
					    ISNULL(codeDepartment.CodeName,'-') as 'Department',					    
					    ISNULL(tp.TradingPolicyName,'-') as 'Applicable Trading Policy Name',					    
					    COALESCE(CONVERT(VARCHAR(25),tp.ApplicableFromDate ,121) ,'-') as 'Trading Policy From Date',					    
					    COALESCE(CONVERT(VARCHAR(25),tp.ApplicableToDate  ,121) ,'-') as 'Trading Policy To Date',
					    ISNULL(et.SecurityType,'-') as 'Security Type',
					    
					    CASE WHEN EXISTS (SELECT TOP 1 NoHoldingFlag from tra_TransactionMaster WHERE UserInfoID = u.UserInfoId and NoHoldingFlag = 1 AND Et.SecurityType is null)			    
					    THEN '0' ELSE
					    CASE WHEN EXISTS (SELECT UserInfoID FROM usr_UserInfo WHERE UserInfoID NOT IN (SELECT UserInfoID FROM tra_TransactionMaster) and Et.SecurityType is null)
					    THEN '-'
					    ELSE et.SelfHoldings
					    END END as 'Self Holdings',
					   				    
					    CASE WHEN EXISTS (SELECT TOP 1 NoHoldingFlag from tra_TransactionMaster WHERE UserInfoID = u.UserInfoId and NoHoldingFlag = 1 AND Et.SecurityType is null)			    
					    THEN '0' ELSE
					    CASE WHEN EXISTS (SELECT UserInfoID FROM usr_UserInfo WHERE UserInfoID NOT IN (SELECT UserInfoID FROM tra_TransactionMaster) and Et.SecurityType is null)
					    THEN '-'
					    ELSE et.RelativesHolding
					    END END as 'Relatives Holding',
					    					    
					    CASE WHEN EXISTS (SELECT TOP 1 NoHoldingFlag from tra_TransactionMaster WHERE UserInfoID = u.UserInfoId and NoHoldingFlag = 1 AND Et.SecurityType is null)			    
					    THEN '0' ELSE
					    CASE WHEN EXISTS (SELECT UserInfoID FROM usr_UserInfo WHERE UserInfoID NOT IN (SELECT UserInfoID FROM tra_TransactionMaster) and Et.SecurityType is null)
					    THEN '-'
					    ELSE et.TotalHoldingsSelfRelatives
					    END END AS 'Total Holdings (Self & Relatives)',
						u.PersonalAddress
					    
			         from usr_UserInfo u 
					 left join com_Code codeCountry on u.CountryId = codeCountry.CodeID
					 left join com_Code codeCategory on u.Category = codeCategory.CodeID
					 left join com_Code codeSubCategory on u.SubCategory = codeSubCategory.CodeID
					 left join com_Code codeDesignation on u.DesignationId = codeDesignation.CodeID
					 left join com_Code codeSubDesignation on u.SubDesignationId = codeSubDesignation.CodeID
					 left join com_Code codeGrade on u.GradeId = codeGrade.CodeID
					 left join com_Code codeDepartment on u.DepartmentId = codeDepartment.CodeID	 
					 left JOIN #tmpTrading ap on u.UserInfoId = ap.UserInfoId and ap.MapToId = (SELECT TOP 1 (MapToId) FROM #tmpTrading where UserInfoId = u.UserInfoId ORDER BY MapToId DESC)
					 left join usr_Authentication codeUserName on u.UserInfoId = codeUserName.UserInfoID
					 left join rul_TradingPolicy tp on tp.TradingPolicyId = ap.MapToId
					 left join mst_Company codeCompany on u.CompanyId = codeCompany.CompanyId
					 left join usr_UserRole urole on urole.UserInfoID = u.UserInfoId
					 left join usr_RoleMaster rm on rm.RoleId = urole.RoleID 
					 INNER join #EmployeeWithTransaction ET on Et.UserID=u.UserInfoId
		           	 where Et.SecurityType is not null or Et.SecurityType is null and et.RelativesHolding is not null and et.TotalHoldingsSelfRelatives is not null
		           	 and u.UserTypeCodeId not in (@nAdminUser, @nCOUser, @nRelative)
			         order by u.UserInfoID
			
			
			DROP TABLE #TempRelativesHoldings
			DROP TABLE #tmpTrading
			DROP TABLE #EmployeeWithTransaction
			DROP TABLE #OnlyRelativeTransaction
			
END				
					 
					
				
					      

