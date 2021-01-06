IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_PopulateGrid')
	DROP PROCEDURE [dbo].[st_com_PopulateGrid]
GO

/******************************************************************************************************************
Description:	Common routine to populate grid.
				Returns a recordset based on given search parameters sParam1 to sParam15
				The recordset is ordered by sSortField field and in the order @inp_sSortOrder
				If iPageSize is provided, the records of that page size for iPageNo is returned.

Returns:		Total number of records based on given search parameters.
				
Created by:		Arundhati
Created on:		02-Feb-2015
Modification History:
Modified By		Modified On		Description
Arundhati		11-Feb-2014		Added case for DMAT list
Arundhati		12-Feb-2014		Added case for Document list
Arundhati		18-Feb-2015		GridTypeCodeId changed. New cases for CompanyList, Codelist are added,
								Total Records variable is set.
								List type for Roles is added
Arundhati		19-Feb-2015		Case for list of relatives is added
Arundhati		23-Feb-2015		Added cases for Listing details and Compliance officer list for a company
Swapnil			03-Mar-2015		Added Param2 while Calling st_com_CodeList.
Arundhati		04-Mar-2015		Added case for resource list
								Parameter added in st_usr_RoleList, call changed
Arundhati		10-Mar-2015		Parameters reduced in the delegation list call		
Arundhati		23-Mar-2015		Trading window other list call is added / List of Trading Window Event for Other
Ashashree		23-Mar-2015		Policy Document list call is added
Arundhati		26-Mar-2015		Call to list documents is changed
Ashashree		30-Mar-2015		Applicability Search List - Employee / Trading policy list call is added
Gaurishankar	01-Apr-2015		Changes for Type 114020 - Added parameter FinancialPeriodTypeCodeId and change sorting. 
Ashashree		07-Apr-2015		Call to fetch list of history records of a Trading policy
Ashashree		08-Apr-2015		Applicability association list - Employee / 
								Applicability Search List - Non Employee / Applicability association list - Non Employee
								Applicability Search List - Corporate / Applicability association list - Corporate
Arundhati		08-Apr-2015		Transaction details list
Ashashree		09-Apr-2015		Added extra parameters to PolicyDocument List(grid type=114022) for include/exclude the input comma separated list of WindowStatusCodeId
								Added correct call for applicability association list : non-employee
								Added extra parameters to grid type 114026 to handle calling frm different modules: Applicability association list - Employee
Gaurishankar	10-Apr-2015		For No Pagination reset page Size to 0 if negative no.
Ashashree		14-Apr-2015		Adding call for Applicability Filter List for combination of department-grade-designation
Swapnil			17-Apr-2015		Addeed case for getting list document that are agreed or viewed by user.
Ashashree		20-Apr-2015		Adding calls for Policy Document related applicability list
Arundhati		28-Apr-2015		Employee list based on UserTypeCodeId
Arundhati		05-May-2015		Grid type 114037 - Period End disclosure for insider
Tushar			08-May-2015		Grid type 114038 - PreClearance Request List
Arundhati		11-May-2015		Added parameter in call to PeriodEnd disclosure list procedure
								Added case for period end summary list (114039)
Tushar			13-May-2015		Grid type 114038 pass new one Paramater.
Gaurishankar	13-May-2015		Grid type 114040 - Template Master List.
Tushar			20-May-2015		Grid type 114041 - Trading Policy Securitywise Value List
Gaurishankar	22-May-2015		Grid type 114044 - Communication rule-modes list for a rule
Parag			26-May-2015		Grid type 114045 - Period end disclosure users list for CO
Sawpnil			27-May-2015		Grid Type 114042 - Initial Disclosure letter List.
Gaurishankar	27-May-2015		Chenge for Procedure name from [st_tra_CommunicationRuleModeMasterList] to [st_cmu_CommunicationRuleModeMasterList] (Grid type 114044 )
Gaurishankar	28-May-2015		Grid type 114043 - Communication rule-Master list 
Swapnil			30-May-2015		Added GridType= 114046 and 114047 for getting Employee and non employee insider letter list.
Tushar			02-Jun-2015		Grid type 114049 - Continuous disclosure users list for CO
Swapnil			02-Jun-2015		Grid type 114048 - Initial disclosure users list for CO
Gaurishankar	04-Jun-2015		Grid type 114051 - Notification list
Raghvendra		04-Jun-2015		Grid type 114050 - Report Initial Disclosure Employee Wise 
Arundhati		05-Jun-2015		Grid Type 114052 - Report Initial Disclosure Employee Individual
Arundhati		08-Jun-2015		Grid Type 114053 - Report PE Disclosure Employee wise
Arundhati		08-Jun-2015		Grid Type 114054 - Report PE Disclosure Employee individual summary
Tushar			10-Jun-2015		Grid type 114049 And Grid type 114038 and new search param for Continuous Disclosure Required.
Ashashree		11-Jun-2015		Applicability association list - CO User(Grid type = 114056) / Applicability Search List - CO User(Grid type = 114055)
Arundhati		12-Jun-2015		Grid type 114058 - Report - Period End disclosure employee individual detail
Arundhati		13-Jun-2015		Grid type 114059 - Report - Continuous disclosure employee wise
Arundhati		18-Jun-2015		Grid type 114061 - Report - Preclearance employee wise
Gaurishankar	19-Jun-2015		Grid type 114057 - List of Notification - Dashboard
Tushar			19-Jun-2015		Grid Type - 114063 Get EventsFor Month List
Arundhati		19-Jun-2015		Grid type 114062 - Report - Preclearance individual
Gaurishankar	19-Jun-2015		Changes in Parameter list for st_cmu_NotificationList procedure.
Arundhati		19-Jun-2015		Added one more parameter to Preclearance individual report
Tushar			23-Jun-2015		Add Param17 in GridType 114048 
Parag			08-Jul-2015		Additional Param2 for grid type - 114046 and 114047
Ashashree		11-Jul-2015		Grid Type 114064 - Overlapping trading policy list for users of a trading policy
Arundhati		17-Jul-2015		Parameter is added to procedure for Gridtype 114031 -- Transaction details list disclosures
Parag			10-Aug-2015		Made change to add grid type as parameter for Grid Type = 114019 (upload sepration)
Ashashree		27-Aug-2015		Grid Type 114076 and 114077 - Grid for Previous Pre-clearance, PNT, trade details list for CO and Insider on Pre-clearance details page
Tushar			23-Sep-2015		Grid Type 114078 Add for Defaulter List
KPCS			12-Oct-2015		Restricted list GridtypeCodeId = 114079
Tushar			16-Oct-2015		Input parameter increases form 30 to 50
Gaurishankar	23-Nov-2015		Employee/Insider List should not display seprated users and added search parameters for User Separation.(@inp_iGridType = 114019)
Gaurishankar	26-Nov-2015		Added parameter list for CO list 114001
Raghvendra		25-Nov-2015		Changes for splitting the grid shown on disclosures Form B,C and D in two grids.Modifications done for Grid 114042,114046,114047 
								and added new grid 114080, 114081, 114082
Arundhati		10-Dec-2015		Changes for showing Employee Insider as separate type, st_usr_UserInfoList procedures changed, so call to this procedure is changed
Tushar			09-Jan-2016		Add Param for Defaulter report,Initial,Continuous,Period end disclosure report for showing 
								Employee Insider as separate type
ED				01-March-2016	Changes during code merge done on 1-March-2016								
Tushar			17-Mar-2016		GridType = 114063 change- Listed Event by User ID.
Parag			16-May-2016		Added new GridType = 114092 - Policy Document Applicability List for Employee NOT Insider
Gaurishankar	10-Apr-2016		Grid type 114089 - Applicability Search List - Employee
								Grid type 114090 - Applicability association Employee filter list
								Grid type 114091 - Applicability Association - Non Insider Employee List
								Changes for AllCo, AllCorporateInsider, AllNonEmployeeInsider and Non Insider Employee Applicability.
								Added new filter Category, SubCategory & Role for applicability. 
Raghvendra		15-Sep-2016		Getting list of uploaded documents corresponding to a transaction
Raghvendra		22-Sep-2016		Preclearance List (Non Implementing Company) - For Insider
Raghvendra		22-Sep-2016		Preclearance List (Non Implementing Company) - For CO
Raghvendra		26-Sep-2016		Restricted List Report 
GS/Tushar		24-Oct-2016		Add Grid Type 114098:- Holding List & 114099:- Security Transfer Report.
Tushar			25-Oct-2015		In Grid Type 114099 add new search param.
Tushar			26-Oct-2015		In Grid Type 114098 Search parameter add in procedure.
******************************************************************************************************************
Type	Description
-------------------
114003. List of all Activities applicable to a user
114004. List of Menus applicable to the logged in user depending on the activities assigned to her.
114001. List of CO Users
114002. List of Employee/Insider Users
114005. List of dmat accounts for a user
114006. List of documents for a user
114007. List of companies
114008. List of Codes from Com_code.
114009. List of roles
114010. List of relatives
114011. List of face values for a company
114012. List of authorized capital for a company
114013. List of paid up shares for a company
114014. List of listing details for a company
114015. List of compliance officers for a company
114016. List of delegations
114017. List of DMAT account holders
114018. List of Resources
114019. List of separation
114020. List of Trading Window Events for Financial Period
114021. List of Trading Window Event for Other
114022. List of Policy Documents under Set Rules section
114023. Applicability Search List - Employee
114024. List of Trading Policy under Set Rules section
114025. List of history records of a Trading Policy under Set Rules section
114026. Applicability association list - Employee
114027. Applicability Search List - Non Employee
114028. Applicability association list - Non Employee
114029. Applicability Search List - Corporate
114030. Applicability association list - Corporate
114031. Transaction details list
114032. Applicability Filter List for combination of department-grade-designation
114033. List of document that are agreed by the logged in user.
114034. Policy Document Applicability association list for Corporate users
114035. Policy Document Applicability association list for NonEmployee users
114036. Policy Document Applicability association list for Employee users 
114037. Period end disclosure status for insider
114038. PreClearance Request List for insider
114039.	Period End Summary
114040. Template Master List.
114041.	Trading Policy Securitywise Value List
114042. Initial Disclosure letter List.
114043. Communication rule-Master list.
114044. Communication rule-modes list for a rule
114045. Period end disclosure users list for CO
114046. Continous Disclosure Employee Insider Letter List
114047. Continous Disclosure Non Employee Insider Letter List\
114048.	Initial disclosure users list for CO
114049. Continuous disclosure users list for CO
114050. Report - Initial disclosure Employee Wise
114051. Notification list. 
114052. Report - Initial disclosure Employee Individual
114053. Report - PE disclosure Employee Wise
114054. Report PE Disclosure Employee individual summary
114055. Applicability Search List - CO User
114056. Applicability association list - CO User
114057. List of Notification - Dashboard
114058. Report - Period End disclosure employee individual detail
114059. Report - Continuous disclosure employee wise
114060. Report - Continuous disclosure employee Individual
114061. Report - Preclearance employee wise
114062. Report - Preclearance employee individual
114063. Get Events For Month List
114064. Overlapping trading policy list for users of a trading policy
114066 to 114075 : Used as overriding grid types for separation of grids related to Trading transaction details list and DMAT Details List
114076. Previous Pre-clearance, PNT, trade details list on Preclearnce Details page for CO
114077. Previous Pre-clearance, PNT, trade details list on Preclearnce Details page for Insider
114078. Defaulter List
114079. Restricted list (done by KPCS)
114080. Second grid shown on Initial Disclosure Letter, form B
114081. Second grid shown on Continuous Disclosure Letter for Employee, form C
114082. Second grid shown on Continuous Disclosure Letter for Non Employee, form D
114089. Applicability Search List - Employee
114090. Applicability association Employee filter list
114091. Applicability Association - Non Insider Employee List
114092. Policy Document Applicability List for Employee (Employee which are NOT Insider)
114093. Transaction Details - Uploaded Document list corresponding to a transaction
114094. Preclearance List (Non Implementing Company) - For Insider
114095. Preclearance List (Non Implementing Company) - For CO
114096. Restricted List Report.
114097.
114098. Securities Holding List
114099. Security Transfer Report CO
507004. Procedure to list for Period End Disclosure Employee insider Letter data i.e. form G
Usage:
------
DECLARE @iTotalRecords INT, @iRetVal INT
114003.  EXEC @iRetVal = st_com_PopulateGrid 114003,10,1,'EMPLOYEE_NO','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114004.  EXEC @iRetVal = st_com_PopulateGrid 114004,10,1,'ActivityID','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114001.  EXEC @iRetVal = st_com_PopulateGrid 114001,10,1,'FirstName','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114002.  EXEC @iRetVal = st_com_PopulateGrid 114002,10,1,'FirstName','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114005.  EXEC @iRetVal = st_com_PopulateGrid 114005,10,1,'DEMATAccountNumber','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114006.  EXEC @iRetVal = st_com_PopulateGrid 114006,10,1,'DocumentName','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114007.  EXEC @iRetVal = st_com_PopulateGrid 114007,10,1,'CompanyName','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114008.  EXEC @iRetVal = st_com_PopulateGrid 114008,10,1,'C.CodeGroupId','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114009.  EXEC @iRetVal = st_com_PopulateGrid 114009,10,1,'RM.RoleName','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114010.  EXEC @iRetVal = st_com_PopulateGrid 114010,10,1,'UF.FirstName','ASC','1','','','','','','','','','','','','','','',@iTotalRecords output
114011.  EXEC @iRetVal = st_com_PopulateGrid 114011,10,1,'CF.FaceValueDate','ASC','1','','','','','','','','','','','','','','',@iTotalRecords output
114012.  EXEC @iRetVal = st_com_PopulateGrid 114012,10,1,'CA.AuthorizedShareCapitalDate','ASC','1','','','','','','','','','','','','','','',@iTotalRecords output
114013.  EXEC @iRetVal = st_com_PopulateGrid 114013,10,1,'CP.PaidUpAndSubscribedShareCapitalDate','ASC','1','','','','','','','','','','','','','','',@iTotalRecords output
114014.  EXEC @iRetVal = st_com_PopulateGrid 114014,10,1,'CStockEx.CodeName','ASC','1','','','','','','','','','','','','','','',@iTotalRecords output
114015.  EXEC @iRetVal = st_com_PopulateGrid 114015,10,1,'CC.ComplianceOfficerName','ASC','1','','','','','','','','','','','','','','',@iTotalRecords output
114016.  EXEC @iRetVal = st_com_PopulateGrid 114016,10,1,'DM.DelegationFrom','ASC','1','','','','','','','','','','','','','','',@iTotalRecords output
114017.  EXEC @iRetVal = st_com_PopulateGrid 114017,10,1,'DA.AccountHolderName','ASC','1','','','','','','','','','','','','','','',@iTotalRecords output
114018.  EXEC @iRetVal = st_com_PopulateGrid 114017,10,1,'R.ResourceValue','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114019.  EXEC @iRetVal = st_com_PopulateGrid 114019,10,1,'FirstName','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114020.  EXEC @iRetVal = st_com_PopulateGrid 114020,10,1,'','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114021.  EXEC @iRetVal = st_com_PopulateGrid 114021,10,1,'','ASC','','','','','','','','','','','','','','','',@iTotalRecords output
114022.	 EXEC @iRetVal = st_com_PopulateGrid 114022,10,1,'PolicyDocumentName','ASC','','','','','','131001,131002,131003',1,@iTotalRecords output
114023.	 EXEC @iRetVal = st_com_PopulateGrid 114023,0,1,'EmployeeId','ASC','132001','1','','','',@iTotalRecords output
114024.	 EXEC @iRetVal = st_com_PopulateGrid 114024,10,1,'TradingPolicyName','ASC','','','','','',@iTotalRecords output
114025.	 EXEC @iRetVal = st_com_PopulateGrid 114025,10,1,'TradingPolicyName','ASC','','','','','',@iTotalRecords output
114026.	 EXEC @iRetVal = st_com_PopulateGrid 114026,0,1,'EmployeeId','ASC','132001','1','','','',@iTotalRecords output
114027.	 EXEC @iRetVal = st_com_PopulateGrid 114027,0,1,'','ASC','132001','1',@iTotalRecords output
114028.	 EXEC @iRetVal = st_com_PopulateGrid 114028,0,1,'','ASC','132001','1',@iTotalRecords output
114029.	 EXEC @iRetVal = st_com_PopulateGrid 114029,0,1,'','ASC','132001','1',@iTotalRecords output
114030.	 EXEC @iRetVal = st_com_PopulateGrid 114030,0,1,'','ASC','132001','1',@iTotalRecords output
114031.  EXEC @iRetVal = st_com_PopulateGrid 114031,10,1,'TD.TransactionDetailsId','ASC','1','139001','','','','','','','','','','','','','',@iTotalRecords output
114032.	 EXEC @iRetVal = st_com_PopulateGrid 114032,0,1,'','ASC','132001','1',@iTotalRecords output
114033.  EXEC @iRetVal = st_com_PopulateGrid 114033,10,1,'','ASC','52',@iTotalRecords output
114034.  EXEC @iRetVal = st_com_PopulateGrid 114034,10,1,'','ASC','2',@iTotalRecords output
114035.  EXEC @iRetVal = st_com_PopulateGrid 114035,10,1,'','ASC','2',@iTotalRecords output
114036.  EXEC @iRetVal = st_com_PopulateGrid 114036,10,1,'','ASC','2','','',@iTotalRecords output
114037.	 EXEC @iRetVal = st_com_PopulateGrid 114037,0,1,'','ASC','1','','',@iTotalRecords output
114038.	 EXEC @iRetVal = st_com_PopulateGrid 114038,0,1,'','ASC','1','','',@iTotalRecords output
114039.  EXEC @iRetVal = st_com_PopulateGrid 114039,0,1,'','ASC','1','','',@iTotalRecords output
114040.  EXEC @iRetVal = st_com_PopulateGrid 114040,0,1,'','ASC','1','','',@iTotalRecords output
114041.  EXEC @iRetVal = st_com_PopulateGrid 114041,0,1,'','ASC','1','132004','','','',@iTotalRecords output
114042.  EXEC @iRetVal = st_com_PopulateGrid 114042,0,1,'','ASC','1','302','','','',@iTotalRecords output
114043.  EXEC @iRetVal = st_com_PopulateGrid 114043,0,1,'','ASC','','','','164','','','','','','','','','','','','','','','','',@iTotalRecords output
114044.  EXEC @iRetVal = st_com_PopulateGrid 114044,0,1,'','ASC','1','1','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114045.  EXEC @iRetVal = st_com_PopulateGrid 114045,0,1,'','ASC','YEARCODE','PERIODCODE','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114046.  EXEC @iRetVal = st_com_PopulateGrid 114046,0,1,'','ASC','1','1','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114047.  EXEC @iRetVal = st_com_PopulateGrid 114047,0,1,'','ASC',''1','1','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114048.  EXEC @iRetVal = st_com_PopulateGrid 114048,0,1,'','ASC','1','1','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114049.	 EXEC @iRetVal = st_com_PopulateGrid 114049,0,1,'','ASC','1','1','','','','','','','','','','','','','','','','','','',@iTotalRecords output

114051.  EXEC @iRetVal = st_com_PopulateGrid 114051,0,1,'','ASC','1','','','','','',@iTotalRecords output
114052.  EXEC @iRetVal = st_com_PopulateGrid 114052,0,1,'','ASC','1','','','','','',@iTotalRecords output
114053.  EXEC @iRetVal = st_com_PopulateGrid 114053,0,1,'','ASC','1','','','','','',@iTotalRecords output
114054.  EXEC @iRetVal = st_com_PopulateGrid 114054,0,1,'','ASC','1','','','','','',@iTotalRecords output
114055.	 EXEC @iRetVal = st_com_PopulateGrid 114055,0,1,'','ASC','132006','1',@iTotalRecords output
114056.	 EXEC @iRetVal = st_com_PopulateGrid 114056,0,1,'','ASC','132006','1',@iTotalRecords output
114057.  EXEC @iRetVal = st_com_PopulateGrid 114051,0,1,'','ASC','1','156002','','','','',@iTotalRecords output
114058.	 EXEC @iRetVal = st_com_PopulateGrid 114058,0,1,'','ASC','132006','1',@iTotalRecords output
114059.	 EXEC @iRetVal = st_com_PopulateGrid 114059,0,1,'','ASC','132006','1',@iTotalRecords output
114060.	 EXEC @iRetVal = st_com_PopulateGrid 114060,0,1,'','ASC','','1',@iTotalRecords output
114061.	 EXEC @iRetVal = st_com_PopulateGrid 114061,0,1,'','ASC','','1',@iTotalRecords output

114063.	 EXEC @iRetVal = st_com_PopulateGrid 114063,0,1,'','ASC','','1',@iTotalRecords output
114064.	 EXEC @iRetVal = st_com_PopulateGrid 114064,10,1,'','ASC','<TradingPolicyId of TP being edited>',,@iTotalRecords output
114076.	 EXEC @iRetVal = st_com_PopulateGrid 114076,0,1,'','ASC','<UserID for whom preclearance details are to be listed>',,@iTotalRecords output
114077.	 EXEC @iRetVal = st_com_PopulateGrid 114077,0,1,'','ASC','<UserID for whom preclearance details are to be listed>',,@iTotalRecords output
114078.	 EXEC @iRetVal = st_com_PopulateGrid 114078,0,1,'','ASC','<UserID for whom preclearance details are to be listed>',,@iTotalRecords output

114080. EXEC @iRetVal = st_com_PopulateGrid 114080,0,1,'','ASC','<1 or 2 based on grid to call>','<TransactionMasterID>','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114081. EXEC @iRetVal = st_com_PopulateGrid 114081,0,1,'','ASC','<1 or 2 based on grid to call>','<TransactionMasterID>','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114082. EXEC @iRetVal = st_com_PopulateGrid 114082,0,1,'','ASC','<1 or 2 based on grid to call>','<TransactionMasterID>','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114092. Policy Document Applicability List for Employee (Employee which are NOT Insider)
114093. EXEC @iRetVal = st_com_PopulateGrid 114093,0,0,'','ASC','MapToTypeCode = 132005','<TransactionMasterID>','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114094. EXEC @iRetVal = st_com_PopulateGrid 114094,0,0,'','ASC','@inp_iUserInfoID','@inp_iPreclearanceCodeID','@inp_iPreclearanceRequestStatus','@inp_iTransactionType','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114095. EXEC @iRetVal = st_com_PopulateGrid 114095,0,0,'','ASC','@inp_sEmployeeID','@inp_sEmployeeName','@inp_sDesignation','@inp_iPreclearanceCodeID','@inp_iPreclearanceRequestStatus','@inp_iTransactionType','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114096. EXEC @iRetVal = st_com_PopulateGrid 114095,0,0,'','ASC','@inp_iLoggedInUserId','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114098. EXEC @iRetVal = st_com_PopulateGrid 114095,0,0,'','ASC','@inp_iLoggedInUserId','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',@iTotalRecords output
114099. EXEC @iRetVal = st_com_PopulateGrid 114095,0,0,'','ASC','@inp_iLoggedInUserId','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',@iTotalRecords output
507004. EXEC @iRetVal = st_com_PopulateGrid 507004,0,1,'','ASC','1','1','@inp_iUserInfoId','@inp_iYearCodeId','@inp_iPeriodCodeID','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',@iTotalRecords output 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_com_PopulateGrid]
	@inp_iGridType INT,					-- As described above.
	@inp_iPageSize INT = 10,			-- 0 For all records
	@inp_iPageNo INT = 1,				-- If PageSize = 0, then this parameter is ignored.
	@inp_sSortField VARCHAR(255),		-- Field name in recordset to sort data.
	@inp_sSortOrder	VARCHAR(5) = 'ASC',	-- ASC / DESC
	@inp_sParam1 NVARCHAR(MAX),
	@inp_sParam2 NVARCHAR(MAX),
	@inp_sParam3 NVARCHAR(MAX),
	@inp_sParam4 NVARCHAR(255),
	@inp_sParam5 NVARCHAR(255),
	@inp_sParam6 NVARCHAR(MAX),
	@inp_sParam7 NVARCHAR(MAX),
	@inp_sParam8 NVARCHAR(MAX),
	@inp_sParam9 NVARCHAR(MAX),
	@inp_sParam10 NVARCHAR(MAX),
	@inp_sParam11 NVARCHAR(MAX),			
	@inp_sParam12 NVARCHAR(MAX),			
	@inp_sParam13 NVARCHAR(MAX),			
	@inp_sParam14 NVARCHAR(255),			
	@inp_sParam15 NVARCHAR(MAX),			
	@inp_sParam16 NVARCHAR(MAX),			
	@inp_sParam17 NVARCHAR(MAX),			
	@inp_sParam18 NVARCHAR(MAX),
	@inp_sParam19 NVARCHAR(255),			
	@inp_sParam20 NVARCHAR(255),			
	@inp_sParam21 NVARCHAR(255),			
	@inp_sParam22 NVARCHAR(255),			
	@inp_sParam23 NVARCHAR(255),			
	@inp_sParam24 NVARCHAR(255),			
	@inp_sParam25 NVARCHAR(255),			
	@inp_sParam26 NVARCHAR(255),			
	@inp_sParam27 NVARCHAR(255),			
	@inp_sParam28 NVARCHAR(255),			
	@inp_sParam29 NVARCHAR(255),			
	@inp_sParam30 NVARCHAR(255),
	@inp_sParam31 NVARCHAR(255),
	@inp_sParam32 NVARCHAR(255),
	@inp_sParam33 NVARCHAR(255),	
	@inp_sParam34 NVARCHAR(255),
	@inp_sParam35 NVARCHAR(255),
	@inp_sParam36 NVARCHAR(255),
	@inp_sParam37 NVARCHAR(255),
	@inp_sParam38 NVARCHAR(255),
	@inp_sParam39 NVARCHAR(255),
	@inp_sParam40 NVARCHAR(255),
	@inp_sParam41 NVARCHAR(255),
	@inp_sParam42 NVARCHAR(255),	
	@inp_sParam43 NVARCHAR(255),	
	@inp_sParam44 NVARCHAR(255),	
	@inp_sParam45 NVARCHAR(255),	
	@inp_sParam46 NVARCHAR(255),	
	@inp_sParam47 NVARCHAR(255),	
	@inp_sParam48 NVARCHAR(255),	
	@inp_sParam49 NVARCHAR(255),	
	@inp_sParam50 NVARCHAR(255),	
	@out_iTotalRecords INT = 0 OUTPUT,
	@out_nReturnValue	INT = 0 OUTPUT,
	@out_nSQLErrCode	INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	-- Declare variables
	DECLARE @iRetVal INT 
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Init variables.
	SELECT	@iRetVal = 0
	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0
	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0
	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = ''
	
	IF @inp_iPageSize < 0
	BEGIN
		SET @inp_iPageSize = 0
	END
	-- In case the search parameters have quote in it, replace it with two quotes.
	-- This is added to handle special characters.
	SELECT	@inp_sParam1 = REPLACE(@inp_sParam1, '''', ''''''),
			@inp_sParam2 = REPLACE(@inp_sParam2, '''', ''''''),
			@inp_sParam3 = REPLACE(@inp_sParam3, '''', ''''''),
			@inp_sParam4 = REPLACE(@inp_sParam4, '''', ''''''),
			@inp_sParam5 = REPLACE(@inp_sParam5, '''', ''''''),
			@inp_sParam6 = REPLACE(@inp_sParam6, '''', ''''''),
			@inp_sParam7 = REPLACE(@inp_sParam7, '''', ''''''),
			@inp_sParam8 = REPLACE(@inp_sParam8, '''', ''''''),
			@inp_sParam9 = REPLACE(@inp_sParam9, '''', ''''''),
			@inp_sParam10 = REPLACE(@inp_sParam10, '''', ''''''),
			@inp_sParam11 = REPLACE(@inp_sParam11, '''', ''''''),
			@inp_sParam12 = REPLACE(@inp_sParam12, '''', ''''''),
			@inp_sParam13 = REPLACE(@inp_sParam13, '''', ''''''),
			@inp_sParam14 = REPLACE(@inp_sParam14, '''', ''''''),
			@inp_sParam15 = REPLACE(@inp_sParam15, '''', ''''''),
			@inp_sParam16 = REPLACE(@inp_sParam16, '''', ''''''),
			@inp_sParam17 = REPLACE(@inp_sParam17, '''', ''''''),
			@inp_sParam18 = REPLACE(@inp_sParam18, '''', ''''''),
			@inp_sParam19 = REPLACE(@inp_sParam19, '''', ''''''),
			@inp_sParam20 = REPLACE(@inp_sParam20, '''', '''''')

	SELECT	@inp_sParam1 = REPLACE(@inp_sParam1, '%', '[%]'),
			@inp_sParam2 = REPLACE(@inp_sParam2, '%', '[%]'),
			@inp_sParam3 = REPLACE(@inp_sParam3, '%', '[%]'),
			@inp_sParam4 = REPLACE(@inp_sParam4, '%', '[%]'),
			@inp_sParam5 = REPLACE(@inp_sParam5, '%', '[%]'),
			@inp_sParam6 = REPLACE(@inp_sParam6, '%', '[%]'),
			@inp_sParam7 = REPLACE(@inp_sParam7, '%', '[%]'),
			@inp_sParam8 = REPLACE(@inp_sParam8, '%', '[%]'),
			@inp_sParam9 = REPLACE(@inp_sParam9, '%', '[%]'),
			@inp_sParam10 = REPLACE(@inp_sParam10, '%', '[%]'),
			@inp_sParam11 = REPLACE(@inp_sParam11, '%', '[%]'),
			@inp_sParam12 = REPLACE(@inp_sParam12, '%', '[%]'),
			@inp_sParam13 = REPLACE(@inp_sParam13, '%', '[%]'),
			@inp_sParam14 = REPLACE(@inp_sParam14, '%', '[%]'),
			@inp_sParam15 = REPLACE(@inp_sParam15, '%', '[%]'),
			@inp_sParam16 = REPLACE(@inp_sParam16, '%', '[%]'),
			@inp_sParam17 = REPLACE(@inp_sParam17, '%', '[%]'),
			@inp_sParam18 = REPLACE(@inp_sParam18, '%', '[%]'),
			@inp_sParam19 = REPLACE(@inp_sParam19, '%', '[%]'),
			@inp_sParam20 = REPLACE(@inp_sParam20, '%', '[%]')

	-- Create temporary table to hold the Row numbers and the Primary Key ID.
	CREATE TABLE #tmpList (RowNumber INT NOT NULL, EntityID INT NOT NULL)
	CREATE UNIQUE CLUSTERED INDEX [ix_tmpList] ON #tmpList (RowNumber, EntityID)	

	------------------------------------------------------------------------------------------------------------
	IF(@inp_iGridType = 114003) -- 1 : 114003
	BEGIN 
			-- List of all Activities applicable to logged in user
			EXEC @iRetVal = st_usr_ActivityList	@inp_iPageSize, @inp_iPageNo ,@inp_sSortField, @inp_sSortOrder, @inp_sParam1, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114004) -- 2 : 114004
	BEGIN 
			-- List of all menus applicable to logged in user
			EXEC @iRetVal = st_mst_MenuMasterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder, @inp_sParam1, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114001) -- 3 : 114001
	BEGIN 
			-- List of CO users
			EXEC @iRetVal = st_usr_UserInfoList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder, 
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5, @inp_sParam6, @inp_sParam7, @inp_sParam8, @inp_sParam9, @inp_sParam10,
					@inp_sParam11, @inp_sParam12, @inp_sParam13, @inp_sParam14, @inp_sParam15, @inp_sParam16, @inp_sParam17, @inp_sParam18, @inp_sParam19, @inp_sParam20,
					@inp_sParam21, @inp_sParam22, @inp_sParam23, @inp_sParam24,
					@inp_iGridType, @inp_sParam25, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114002 OR @inp_iGridType = 114019) -- 3 : 114002
	BEGIN 
			-- List of Employee users
			EXEC @iRetVal = st_usr_UserInfoList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder, 
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5, @inp_sParam6, @inp_sParam7, @inp_sParam8, @inp_sParam9, @inp_sParam10,
					@inp_sParam11, @inp_sParam12, @inp_sParam13, @inp_sParam14, @inp_sParam15, @inp_sParam16, @inp_sParam17, @inp_sParam18, @inp_sParam19, @inp_sParam20,
					@inp_sParam21, @inp_sParam22, @inp_sParam23, @inp_sParam24,
					@inp_iGridType, @inp_sParam25, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114005) -- 4 : 114005
	BEGIN 
			-- List of DMATDetails
			EXEC @iRetVal = st_usr_DMATDetailsList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5, @inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114006) -- 5 : 114006
	BEGIN 
			-- List of Document
			--EXEC @iRetVal = st_usr_DocumentDetailsList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
			--		@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5, @inp_sParam6, @inp_sParam7, @inp_sParam8,
			--		@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
			EXEC @iRetVal = st_com_DocumentList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5, @inp_sParam6, @inp_sParam7, @inp_sParam8, @inp_sParam9, @inp_sParam10,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114007)
	BEGIN 
			-- List of Companies
			EXEC @iRetVal = st_mst_CompanyList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114008)
	BEGIN 
			-- List of Codes
			EXEC @iRetVal = st_com_CodeList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114009)
	BEGIN 
			-- List of Roles
			EXEC @iRetVal = st_usr_RoleList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114010)
	BEGIN 
			-- List of relatives of user
			EXEC @iRetVal = st_usr_RelativesList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5, @inp_sParam6, @inp_sParam7,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114011)
	BEGIN
			-- List of face values for a company
			EXEC @iRetVal = st_com_CompanyFaceValueList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5, @inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114012)
	BEGIN
			-- List of face values for a company
			EXEC @iRetVal = st_com_CompanyAuthorizedShareCapitalList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114013)
	BEGIN
			-- List of face values for a company
			EXEC @iRetVal = st_com_CompanyPaidUpAndSubscribedShareCapitalList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114014)
	BEGIN
			-- List of Listing details for a company
			EXEC @iRetVal = st_com_CompanyListingDetailsList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5, @inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114015)
	BEGIN
			-- List of Compliance officers for a company
			EXEC @iRetVal = st_com_CompanyComplianceOfficerList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5,
					@inp_sParam6, @inp_sParam7, @inp_sParam8, @inp_sParam9, @inp_sParam10, @inp_sParam11,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114016)
	BEGIN
			-- List of Delegation Master
			EXEC @iRetVal = st_usr_DelegationMasterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, --@inp_sParam5, @inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114017)
	BEGIN
			-- List of DMAT account holders.
			EXEC @iRetVal = st_usr_DMATAccountHolderList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114018)
	BEGIN
			-- List of labels
			EXEC @iRetVal = st_mst_ResourceList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	-- Refer Case 114002 for GridTypeCodeId = 114019
	ELSE IF(@inp_iGridType = 114020)
	BEGIN
			-- List of Trading Window Event for Financial Period
			EXEC @iRetVal = st_rul_TradingWindowFinancialYearList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114021)
	BEGIN
			-- List of Trading Window Event for Other
			EXEC @iRetVal = st_rul_TradingWindowOtherList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END 
	ELSE IF(@inp_iGridType = 114022)
	BEGIN
			-- List of Policy Document under Set Rules section
			EXEC @iRetVal = st_rul_PolicyDocumentList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END	
	ELSE IF(@inp_iGridType = 114023)
	BEGIN
			-- Applicability Search List - Employee
			EXEC @iRetVal = st_rul_ApplicabilitySearchList_Employee @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,@inp_iGridType,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END	
	ELSE IF(@inp_iGridType = 114024)
	BEGIN
			-- Trading policy list
			EXEC @iRetVal = st_rul_TradingPolicyList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114025)
	BEGIN
			-- Trading policy list of history records
			EXEC @iRetVal = st_rul_TradingPolicyHistoryList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END	
	ELSE IF(@inp_iGridType = 114026)
	BEGIN
			-- Applicability Association List - Employee
			EXEC @iRetVal = st_rul_ApplicabilityAssociationList_Employee @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,@inp_iGridType,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114027)
	BEGIN
			-- Applicability Search List - Non Employee
			EXEC @iRetVal = st_rul_ApplicabilitySearchList_NonEmployee @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114028)
	BEGIN
			-- Applicability Association List - Non Employee
			EXEC @iRetVal = st_rul_ApplicabilityAssociationList_NonEmployee @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114029)
	BEGIN
			-- Applicability Search List - Corporate
			EXEC @iRetVal = st_rul_ApplicabilitySearchList_Corporate @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114030)
	BEGIN
			-- Applicability Association List - Corporate
			EXEC @iRetVal = st_rul_ApplicabilityAssociationList_Corporate @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114031)
	BEGIN
			-- Transaction details list disclosures
			EXEC @iRetVal = st_tra_TransactionDetailsList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114032)
	BEGIN
			-- Applicability Filter List for combination of department-grade-designation
			EXEC @iRetVal = st_rul_ApplicabilityFilterList_Employee @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,@inp_iGridType,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114033)
	BEGIN
			-- Applicability Filter List for combination of department-grade-designation
			EXEC @iRetVal = st_rul_PolicyAgreedByUserList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114034)
	BEGIN
			-- Policy Document Applicability association list for Corporate users
			EXEC @iRetVal = st_tra_PolicyDocumentApplicabilityList_Corporate @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114035)
	BEGIN
			-- Policy Document Applicability association list for NonEmployee users
			EXEC @iRetVal = st_tra_PolicyDocumentApplicabilityList_NonEmployee @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114036)
	BEGIN
			-- Policy Document Applicability association list for Employee users
			EXEC @iRetVal = st_tra_PolicyDocumentApplicabilityList_Employee @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114037)
	BEGIN
			-- Period End disclosure for insider
			EXEC @iRetVal = st_tra_PeriodEndDisclosurePeriodStatus
			        @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	ELSE IF(@inp_iGridType = 114038)
	BEGIN
			-- Continous disclosure for insider
			EXEC @iRetVal = st_tra_ContinuousDisclosureList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@inp_sParam8,@inp_sParam9,@inp_sParam10,@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114039)
	BEGIN
			-- Period End disclosure summary for insider
			EXEC @iRetVal = st_tra_PeriodEndDisclosurePeriodSummary
					@inp_sParam1, @inp_sParam2, @inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114040)
	BEGIN
			-- Template Master List
			EXEC @iRetVal = st_tra_TemplateMasterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3,@inp_sParam4,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114041)
	BEGIN
			-- Trading Policy Securitywise Value List
			EXEC @iRetVal = st_rul_TradingPolicySecuritywiseLimitsList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114042)
	BEGIN
			-- Initial Disclosure letter List
			EXEC @iRetVal = st_tra_InitialDisclosureLetterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114043)
	BEGIN
			-- Communication rule master list
			EXEC @iRetVal = st_cmu_CommunicationRuleMasterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114044)
	BEGIN
			-- Communication rule-modes list for a rule
			EXEC @iRetVal = st_cmu_CommunicationRuleModeMasterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114045)
	BEGIN
			-- Period end disclosure users list for CO
			EXEC @iRetVal = st_tra_PeriodEndDisclosureUsersStatus @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5, @inp_sParam6, @inp_sParam7, @inp_sParam8,
					@inp_sParam9, @inp_sParam10, @inp_sParam11, @inp_sParam12, @inp_sParam13, @inp_sParam14, @inp_sParam15, @inp_sParam16, 
					@inp_sParam17,@inp_sParam18,@inp_sParam19,@inp_sParam20, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114046)
	BEGIN
			-- Continous Disclosure Employee Insider Letter List
			EXEC @iRetVal = st_tra_ContinousDisclosureEmployeeInsiderLetterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3, 
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114047)
	BEGIN
			-- Continous Disclosure Non Employee Insider Letter List
			EXEC @iRetVal = st_tra_ContinousDisclosureNonEmployeeInsiderLetterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3, 
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114048)
	BEGIN
			-- Initial Disclosure Status List for CO
			EXEC @iRetVal = st_tra_COInitialDisclosureList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@inp_sParam8,@inp_sParam9,@inp_sParam10,@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,@inp_sParam16,@inp_sParam17,@inp_sParam18,@inp_sParam19,					
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	ELSE IF(@inp_iGridType = 114117)
	BEGIN
			-- Initial Disclosure Status List for CO
			EXEC @iRetVal = st_tra_COInitialDisclosureList_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@inp_sParam8,@inp_sParam9,@inp_sParam10,@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,@inp_sParam16,@inp_sParam17,@inp_sParam18,@inp_sParam19,@inp_sParam20,@inp_sParam21,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	ELSE IF(@inp_iGridType = 114103)
	BEGIN
			EXEC @iRetVal = st_tra_EmployeeInitialDisclosureList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
			@inp_sParam1,@inp_sParam2,			
			@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT			
	END
	
	ELSE IF(@inp_iGridType = 114104)
	BEGIN			
			EXEC @iRetVal = st_tra_InsiderInitialDisclosureList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
			@inp_sParam1,@inp_sParam2,			
			@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT			
	END
	
	ELSE IF(@inp_iGridType = 114107)
	BEGIN
			EXEC @iRetVal = st_tra_EmployeeInitialDisclosureListFor_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
			@inp_sParam1,@inp_sParam2,			
			@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT			
	END
	
	ELSE IF(@inp_iGridType = 114108)
	BEGIN			
			EXEC @iRetVal = st_tra_InsiderInitialDisclosureListFor_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
			@inp_sParam1,@inp_sParam2,			
			@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT			
	END
	
	ELSE IF(@inp_iGridType = 114049)
	BEGIN
			-- Continous Disclosure Status List for CO
			--EXEC @iRetVal = st_tra_ContinuousDisclosureListByCO @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
			EXEC @iRetVal = st_tra_ContinuousDisclosureListByCOUpdated @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@inp_sParam8,@inp_sParam9,@inp_sParam10,@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,@inp_sParam16,
					@inp_sParam17,@inp_sParam18,@inp_sParam19,@inp_sParam20,@inp_sParam21,@inp_sParam23,@inp_sParam24,@inp_sParam25,@inp_sParam26,@inp_sParam27,@inp_sParam28,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
					
	END	
	
	ELSE IF(@inp_iGridType = 114050)
	BEGIN
			-- Report - ID employeewise
			EXEC @iRetVal = st_rpt_InitialDisclosureEmployeeWise @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@inp_sParam8,@inp_sParam9,@inp_sParam10,@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,@inp_sParam16,
					@inp_sParam17,@inp_sParam18,@inp_sParam19,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114051)
	BEGIN
			-- Notification List
			EXEC @iRetVal = st_cmu_NotificationList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6, @inp_iGridType,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114052)
	BEGIN
			-- Report - ID employee individual
			EXEC @iRetVal = st_rpt_InitialDisclosureEmployeeIndividual @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114053)
	BEGIN
			-- Report - PE employee wise
			EXEC @iRetVal = st_rpt_PeriodEndDisclosureEmployeeWise @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,@inp_sParam16,@inp_sParam17,@inp_sParam18,@inp_sParam19,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114054)
	BEGIN
			-- Report - PE employee wise
			EXEC @iRetVal = st_rpt_PeriodEndEmployeeIndividualSummary @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,/*@inp_sParam9,@inp_sParam10,
					@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,@inp_sParam16,@inp_sParam17,@inp_sParam18,*/
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END

	ELSE IF(@inp_iGridType = 1140593)
	BEGIN
			-- Report - PE employee wise
			EXEC @iRetVal = st_rpt_PeriodEndDisclosureEmployeeWiseSSRS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@inp_sParam11,@inp_sParam12,@inp_sParam13,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 1140604)
	BEGIN
			-- Report - PE employee wise
			EXEC @iRetVal = st_rpt_PeriodEndEmployeeIndividualSummarySSRS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,/*@inp_sParam9,@inp_sParam10,
					@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,@inp_sParam16,@inp_sParam17,@inp_sParam18,*/
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	
	
	ELSE IF(@inp_iGridType = 114055)
	BEGIN
			-- Applicability Search List - Co user
			EXEC @iRetVal = st_rul_ApplicabilitySearchList_COUser @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114056)
	BEGIN
			-- Applicability Association List - Co user
			EXEC @iRetVal = st_rul_ApplicabilityAssociationList_COUser @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END		
	ELSE IF(@inp_iGridType = 114057)
	BEGIN
			-- Notification List for DashBoard
			EXEC @iRetVal = st_cmu_NotificationList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6, @inp_iGridType,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114058)
	BEGIN
			-- Report - Period End disclosure employee individual detail
			EXEC @iRetVal = st_rpt_PeriodEndEmployeeIndividualDetails @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114059)
	BEGIN
			-- Report - Continuous disclosure employee wise
			EXEC @iRetVal = st_rpt_ContinuousDisclosureEmployeeWise @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114060)
	BEGIN
			--print 'not implemented yet'
			-- Report - Continuous disclosure employee individual
			EXEC @iRetVal = st_rpt_ContinuousDisclosureEmployeeIndividual @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,@inp_sParam16,@inp_sParam17,@inp_sParam18,@inp_sParam19,@inp_sParam20,
					@inp_sParam21,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114061)
	BEGIN
			--print 'not implemented yet'
			-- Report - Preclearance employee
			EXEC @iRetVal = st_rpt_PreclearanceEmployeeWise @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114062)
	BEGIN
			print 'not implemented yet'
			-- Report - Preclearance employee individual
			EXEC @iRetVal = st_rpt_PreclearanceEmployeeIndividual @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@inp_sParam11,@inp_sParam12,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114063)
	BEGIN
			--Get EventsFor Month List
			EXEC @iRetVal = st_rul_GetEventsForMonthList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114064)
	BEGIN
			-- Overlapping trading policy list for users of a trading policy
			EXEC @iRetVal = st_rul_UserwiseOverlapTradingPolicyList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END	
	ELSE IF(@inp_iGridType = 114076)
	BEGIN
			--Previous preclearance, PNT, trade details list on preclearance details page for CO
			EXEC @iRetVal = st_tra_PreClearanceRequestDetailsPreviousTradeList_CO @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114077)
	BEGIN
			--Previous preclearance, PNT, trade details list on preclearance details page for Insider
			EXEC @iRetVal = st_tra_PreClearanceRequestDetailsPreviousTradeList_Insider @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114078)
	BEGIN	
	
			SET @inp_sParam30 = REPLACE(@inp_sParam30, ',', '');
			SET @inp_sParam31 = REPLACE(@inp_sParam31, ',', '');
			SET @inp_sParam32 = REPLACE(@inp_sParam32, ',', '');
			SET @inp_sParam33 = REPLACE(@inp_sParam33, ',', '');
			
			--Defaulter List
			EXEC @iRetVal = st_rpt_DefaulterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,@inp_sParam16,@inp_sParam17,@inp_sParam18,@inp_sParam19,
					@inp_sParam20,@inp_sParam21,@inp_sParam22,@inp_sParam23,@inp_sParam24,@inp_sParam25,@inp_sParam26,@inp_sParam27,@inp_sParam28,
					@inp_sParam29,@inp_sParam30,@inp_sParam31,@inp_sParam32,@inp_sParam33,@inp_sParam34,@inp_sParam35,@inp_sParam36,@inp_sParam37,
					@inp_sParam38,@inp_sParam39,@inp_sParam40,@inp_sParam41,@inp_sParam42,@inp_sParam43,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	
	ELSE IF(@inp_iGridType = 114079)
	BEGIN
			--SET @inp_sSortOrder ='DESC'
			IF(@inp_sParam9 = 'MainPage')
			BEGIN
			-- Grid for Restricted List
			EXEC @iRetVal = st_rl_RestrictedMasterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
			END
			ELSE IF(@inp_sParam9 = 'History')
			BEGIN
				EXEC @iRetVal = st_rl_RestrictedCompanyHistoryList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
			END
			
	END
	ELSE IF(@inp_iGridType = 114080)
	BEGIN
			-- Initial Disclosure letter List
			--First Parameter is 2 i.e. for the second grid shown in the Initial Disclosure Letter
			EXEC @iRetVal = st_tra_InitialDisclosureLetterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2, 
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114081)
	BEGIN
			-- Continous Disclosure Employee Insider Letter List
			EXEC @iRetVal = st_tra_ContinousDisclosureEmployeeInsiderLetterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3, 
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114082)
	BEGIN
			-- Continous Disclosure Non Employee Insider Letter List
			EXEC @iRetVal = st_tra_ContinousDisclosureNonEmployeeInsiderLetterList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3, 
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114089)
	BEGIN
			-- Applicability Search List - Employee
			EXEC @iRetVal = st_rul_ApplicabilitySearchList_Employee @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,@inp_iGridType,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END	
	ELSE IF(@inp_iGridType = 114090)
	BEGIN
			-- Applicability Filter List for combination of department-grade-designation
			EXEC @iRetVal = st_rul_ApplicabilityFilterList_Employee @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,@inp_iGridType,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114091)
	BEGIN
			-- Applicability Association List - Employee
			EXEC @iRetVal = st_rul_ApplicabilityAssociationList_Employee @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,@inp_iGridType,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114092)
	BEGIN
			-- Policy Document Applicability association list for Employee users
			EXEC @iRetVal = st_tra_PolicyDocumentApplicabilityList_EmployeeNotInsider @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114093)
	BEGIN
			-- Transaction Details - uploaded documents list corresponding to a transaction
			EXEC @iRetVal = st_tra_TransactionUploadedDocumentList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114094)
	BEGIN
			-- Preclearance List (Non Implementing Company) - For Insider
			EXEC @iRetVal = st_tra_PreclearanceList_NonImplementingCompany_ForInsider @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114095)
	BEGIN
			-- Preclearance List (Non Implementing Company) - For Insider
			EXEC @iRetVal = st_tra_PreclearanceList_NonImplementingCompany_ForCO @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114096)
	BEGIN
			-- Preclearance List (Non Implementing Company) - For Insider
			EXEC @iRetVal = st_rl_RestrictedList_Report @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@inp_sParam8,@inp_sParam9,@inp_sParam10,@inp_sParam11,@inp_sParam12,@inp_sParam13,
					@inp_sParam14,@inp_sParam15,@inp_sParam16,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114098)
	BEGIN
			-- Preclearance List (Non Implementing Company) - For Insider
			EXEC @iRetVal = st_usr_UserSecuritiesHoldingList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114099)
	BEGIN
			-- Preclearance List (Non Implementing Company) - For Insider
			EXEC @iRetVal = st_usr_SecurityTransferLogList_CO_Employee @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@inp_sParam8,@inp_sParam9,@inp_sParam10,@inp_sParam11,@inp_sParam12,@inp_sParam13,
					@inp_sParam14,@inp_sParam15,@inp_sParam16,@inp_sParam17,@inp_sParam18,@inp_sParam19,
					@inp_sParam20,@inp_sParam21,@inp_iGridType,@inp_sParam23,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 507004)
	BEGIN
			-- Continous Disclosure Employee Insider Letter List
			EXEC @iRetVal = [st_tra_PeriodEndDisclosureEmployeeInsiderLetterList] @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4, @inp_sParam5, 
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 507003)
	BEGIN
			EXEC @iRetVal = [st_tra_PeriodEndDisclosureEmployeeInsiderLetterList] @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4, @inp_sParam5, 
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 508005)
	BEGIN
			-- Nse download functionality grid
			EXEC @iRetVal = st_tra_GetGroupDetails @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,						
						@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,
							@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 508008)
	BEGIN
			-- delete user deatails from Specific Group
		   
			EXEC @iRetVal = st_tra_ContinuousDisclosureListByCOForGroupDetailsDelete @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@inp_sParam8,@inp_sParam9,@inp_sParam10,@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,@inp_sParam16,
					@inp_sParam17,@inp_sParam18,@inp_sParam19,@inp_sParam20,@inp_sParam21,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	ELSE IF(@inp_iGridType = 122098)
	BEGIN
			-- Claw Back Report
			EXEC @iRetVal = st_rpt_ClawBackReport
			        @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	ELSE IF(@inp_iGridType = 122100)
	BEGIN
			-- Claw Back Report Individual
			EXEC @iRetVal = st_rpt_GetIndividualClawBackReport
			        @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	
	ELSE IF(@inp_iGridType = 1140591)
	BEGIN
			-- Report - Continuous disclosure employee wise
			EXEC @iRetVal = st_rpt_ContinuousDisclosureEmployeeWiseforSSRS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,
					@inp_sParam15,@inp_sParam16,@inp_sParam17,@inp_sParam18,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 1140602)
	BEGIN
			--print 'not implemented yet'
			-- Report - Continuous disclosure employee individual
			EXEC @iRetVal = st_rpt_ContinuousDisclosureEmployeeIndividualforSSRS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,@inp_sParam15,@inp_sParam16,@inp_sParam17,@inp_sParam18,@inp_sParam19,@inp_sParam20,
					@inp_sParam21,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	------------------------------------------------------------------------------------------------------------

	ELSE IF(@inp_iGridType = 1140592)
	BEGIN
			-- Report - Initial disclosure employee wise
		EXEC @iRetVal = st_rpt_InitialDisclosureEmployeeWiseSSRS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 1140603)
	BEGIN
			
			-- Report - Initial disclosure employee individual
			EXEC @iRetVal = st_rpt_InitialDisclosureEmployeeIndividualforSSRS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT				
		
	END

	------------------------------------------------------------------------------------------------------------
	ELSE IF(@inp_iGridType = 1140594)
	BEGIN
		-- Report - Preclearance employee
		EXEC @iRetVal = st_rpt_PreclearanceEmployeeWiseForSSRS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
		@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,@inp_sParam11,@inp_sParam12,@inp_sParam13,
		@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 1140605)
	BEGIN
		-- Report - Preclearance employee individual
		EXEC @iRetVal = st_rpt_PreclearanceEmployeeIndividualForSSRS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
		@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
		@inp_sParam11,@inp_sParam12,@inp_sParam13,@inp_sParam14,
		@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	------------------------------------------------------------------------------------------------------------

	-- For PPD
	ELSE IF(@inp_iGridType = 114071)
	BEGIN
	
		 EXEC @iRetVal = st_tra_InitialTransactionDetailsList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	-- For Relative PPD
	ELSE IF(@inp_iGridType = 114102)
	BEGIN
			-- delete user deatails from Specific Group
	
		EXEC @iRetVal = st_tra_InitialTransactionDetailsListForRelative @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	-- For PPD
	ELSE IF(@inp_iGridType = 114109)
	BEGIN
	
		 EXEC @iRetVal = st_tra_InitialTransactionDetailsList_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	-- For Relative PPD
	ELSE IF(@inp_iGridType = 114110)
	BEGIN
			-- delete user deatails from Specific Group
	
		EXEC @iRetVal = st_tra_InitialTransactionDetailsListForRelative_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
-- For Employee Education Information
   ELSE IF(@inp_iGridType = 114115)
	BEGIN
			
		EXEC @iRetVal = st_usr_EducationList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	-- For Employee Work Information
   ELSE IF(@inp_iGridType = 114116)
	BEGIN
			
	
		EXEC @iRetVal = st_usr_WorkList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114118)
	BEGIN
		-- Preclearance List (Other Security) - For Insider
			EXEC @iRetVal = st_tra_PreclearanceList_OS_ForInsider @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114119)
	BEGIN
			-- Preclearance List (Non Implementing Company) - For Insider
			EXEC @iRetVal = st_tra_PreclearanceListForCO_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114120)
	BEGIN
			-- Transaction details list disclosures for other securities-self
			EXEC @iRetVal = st_tra_TransactionDetailsListSelf_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114121)
	BEGIN
			-- Transaction details list disclosures for other securities-relative
			EXEC @iRetVal = st_tra_TransactionDetailsListRelative_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END

	ELSE IF(@inp_iGridType = 114122)
	BEGIN
			-- Upsi details list 
			EXEC @iRetVal = st_UpsiSharingList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam4,@inp_sParam5,@inp_sParam7,@inp_sParam8,@inp_sParam11,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114124)
	BEGIN
			EXEC @iRetVal = st_usr_MCQList @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114125)
	BEGIN
			EXEC @iRetVal = st_rpt_EulaAcceptanceReport @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114126)
	BEGIN
			-- Period End disclosure for insider
			EXEC @iRetVal = st_tra_PeriodEndDisclosurePeriodStatus_OS
			        @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114127)
	BEGIN
			-- Period End disclosure summary of user
			EXEC @iRetVal = st_tra_PeriodEndDisclosurePeriodSummary_OS
					@inp_sParam1, @inp_sParam2, @inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114128)
	BEGIN
			-- Period end disclosure for OS users list for CO
			EXEC @iRetVal = st_tra_PeriodEndDisclosureUsersStatus_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2, @inp_sParam3, @inp_sParam4, @inp_sParam5, @inp_sParam6, @inp_sParam7, @inp_sParam8,
					@inp_sParam9, @inp_sParam10, @inp_sParam11, @inp_sParam12, @inp_sParam13, @inp_sParam14, @inp_sParam15, @inp_sParam16, 
					@inp_sParam17,@inp_sParam18,@inp_sParam19,@inp_sParam20, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END

	ELSE IF(@inp_iGridType = 114129)
	BEGIN
			-- Trading policy Other Security list
			EXEC @iRetVal = st_rul_TradingPolicyList_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END

		ELSE IF(@inp_iGridType = 114130)
	BEGIN
			-- Trading policy other securities list of history records
			EXEC @iRetVal = st_rul_TradingPolicyHistoryList_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END	

	ELSE IF(@inp_iGridType = 114131)
	BEGIN
			-- Trading Policy Other Securitywise Value List
			EXEC @iRetVal = st_rul_TradingPolicySecuritywiseLimitsList_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1, @inp_sParam2,@inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	
	ELSE IF(@inp_iGridType = 114132)
	BEGIN
			-- Applicability Search List - Employee
			EXEC @iRetVal = st_rul_ApplicabilitySearchList_Employee_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,@inp_iGridType,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,@inp_sParam7,@inp_sParam8,@inp_sParam9,@inp_sParam10,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END	
	ELSE IF(@inp_iGridType = 114133)
	BEGIN
			-- Applicability Association List - Employee OS
			EXEC @iRetVal = st_rul_ApplicabilityAssociationList_Employee_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,@inp_iGridType,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,@inp_sParam4,@inp_sParam5,@inp_sParam6,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END

	ELSE IF(@inp_iGridType = 114139)
	BEGIN
			-- Applicability Filter List for combination of department-grade-designation in OS
			EXEC @iRetVal = st_rul_ApplicabilityFilterList_Employee_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,@inp_iGridType,
					@inp_sParam1,@inp_sParam2,@inp_sParam3,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END
	ELSE IF(@inp_iGridType = 114150)
	BEGIN
			-- Overlapping trading policy list for users of a trading policy
			EXEC @iRetVal = st_rul_UserwiseOverlapTradingPolicyList_OS @inp_iPageSize, @inp_iPageNo, @inp_sSortField, @inp_sSortOrder,
					@inp_sParam1,
					@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT
	END

	-- In case the Specific List Procedure returned Error, then return it back.
	IF (@iRetVal = 0)
	BEGIN
		-- Get count of records from temporary table
		SELECT	@out_iTotalRecords = COUNT(*)
		FROM	#tmpList
	END

	-- Delete temporary table.
	DROP TABLE #tmpList

	RETURN (@iRetVal)
END

GO
