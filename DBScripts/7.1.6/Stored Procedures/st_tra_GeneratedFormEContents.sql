IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GeneratedFormEContents')
DROP PROCEDURE [dbo].[st_tra_GeneratedFormEContents]
GO
/****** Object:  StoredProcedure [dbo].[st_tra_GenerateFormDetails_NonImplementingCompany]    Script Date: 09/12/2017 15:00:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	save formatted Form E for preclearance for NonImplementing company related preclearances

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		20-Sep-2016

Modification History:
Modified By		Modified On		Description
Tushar			27-Sep-2016		If Sell transaction type then evaluate last buy date else replace not applicable text.
Tushar			28-Sep-2016		Add change for Number format for PCL Qty & value.
Raghvendra		05-Oct-2016		Handling display of previous BUY/EXERCISE date based off the ESOP flag. Including previous preclearance number of BUY/EXERCISE if current transactionType = SELL
Raghvendra		06-Oct-2016		Displaying single "Not Applicable" if previous preclearance-number and date both are to be displayed in single tabular column
Raghvendra		17-Oct-2016		Fetching and using the placeholders stored in table com_PlaceholderMaster, for Form E.
Raghvendra		20-Oct-2016		Adding check that previous approval No and date of Buy/Exercise type of transaftion must be of same employee to whom current Sale transaction belongs (Mantis #9613)
Raghvendra		19-Dec-2016		Uncommented the join condition for user demat account join

Usage:
EXEC st_tra_GenerateFormDetails_NonImplementingCompany <MapToTypeId> <MapToId> <LoggedInUserId>
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE st_tra_GeneratedFormEContents
	@inp_nMapToTypeCodeId					INT,
	@inp_nMapToId							INT,	--Id of Preclearance for which Form E is to be generated
	@inp_nLoggedInUserId					INT,	-- Id of the user inserting the Form E contents
	@sFormContents_FormE                    NVARCHAR(MAX) ='',
    @sGeneratedFormContents_FormE_Final     NVARCHAR(MAX) OUTPUT,
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT

AS
BEGIN
	DECLARE @ERR_FORM_GENERATION_FAIL INT = 17458 -- Error occurred while generating form E details

	DECLARE @nMapTypePreclearance_NonImplementingCompany INT = 132015	--MapToTypeId for type Preclearance of NonImplementing Company
	DECLARE @nPreclearanceRequestForSelfCodeId INT = 142001
	DECLARE @nPreclearanceRequestForRelativeCodeId INT = 142002
	DECLARE @nCommunicationModeCodeId_FormEForSelf INT = 156007 --Form E is applicable for preclearance of implementing and nonimplementing company (template is same)
	DECLARE @nCommunicationModeCodeId_FormEForRelative INT = 156007 --Form E is applicable for preclearance of implementing and nonimplementing company (template is same)
	DECLARE @nPreclearanceTransTypeCodeBuy INT = 143001
	DECLARE @nPreclearanceTransTypeCodeSale INT = 143002
	DECLARE @nPreclearanceStatusCodeApproved INT = 144002
	DECLARE @nPreclearanceTransTypeCodeExercise INT = 143003
	DECLARE @dtLastPreclearanceBuyDate	DATETIME = NULL
	DECLARE @nLastPreclearanceBuyId	INT = NULL
	DECLARE @sLastPreclearanceBuyFormattedId	VARCHAR(300) = NULL
	DECLARE @sPrceclearanceCodePrefixText			VARCHAR(3)
	DECLARE @nPreclearanceTakenCase INT = 176001

	DECLARE @dtCurrentServerDate DATETIME = NULL
	DECLARE @nTemplateMasterId INT
	DECLARE @nPlaceholderCount INT = 0
	DECLARE @nCounter INT = 0
	DECLARE @sPlaceholder VARCHAR(255)

	DECLARE @nPreclearanceTakenForCodeId INT = 0
	DECLARE @bIsAutoApproved BIT = 0

	DECLARE @sNotApplicable VARCHAR(100) = 'Not Applicable'
	DECLARE @sAutoApproved VARCHAR(100) = 'Auto approved'
	DECLARE @sComplianceOfficer VARCHAR(500) = 'Compliance Officer / Authorized Official'

	DECLARE @sImplementingCompanyName NVARCHAR(200) = ''
	DECLARE @FormEContents NVARCHAR(MAX) = ''
	
	
	CREATE TABLE #tblPlaceholders
	(
		ID INT IDENTITY(1,1), 
		Placeholder NVARCHAR(512),
		PlaceholderDisplayName NVARCHAR(1000)
	)
	
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
		----------------------------------------------------
		SELECT @dtCurrentServerDate = dbo.uf_com_GetServerDate() --Get the current serverdate by making single call to function uf_com_GetServerDate()

		SELECT @sImplementingCompanyName = CompanyName FROM mst_Company WHERE IsImplementing = 1 --Fetch the CompanyName of implementing company

		INSERT INTO #tblPlaceholders(Placeholder, PlaceholderDisplayName)
		SELECT PlaceholderTag, PlaceholderDisplayName  FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156007

		--get count of total placeholders strored in placeholder table
		SELECT @nPlaceholderCount = COUNT(ID) FROM #tblPlaceholders
		
            SET @FormEContents = @sFormContents_FormE
         
			---------- For Static Content ---------
			WHILE(@nCounter < @nPlaceholderCount)
			BEGIN
				SELECT @nCounter = @nCounter + 1
				SELECT @sPlaceholder = Placeholder FROM #tblPlaceholders WHERE ID = @nCounter
			
			SELECT @FormEContents =  
					CASE 
						--User related placeholder replacement
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_EMAILID]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.EmailId,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_FIRSTNAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.FirstName,ISNULL(U.ContactPerson,'')) ) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_MIDDLENAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.MiddleName,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_LASTNAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.LastName,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_EMPLOYEEID]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.EmployeeId,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_MOBILE_NUMBER]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.MobileNumber,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_COMPANY]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(Company.CompanyName,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_ADDR1]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.AddressLine1,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_ADDR2]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.AddressLine2,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_COUNTRY]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(CountryCode.CodeName,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_STATE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(StateCode.CodeName,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_CITY]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.City,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_PINCODE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.PinCode,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_JOIN_DATE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UPPER(REPLACE(CONVERT(VARCHAR(20), U.DateOfJoining, 106), ' ', '/')), '-'))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_BECOMEINSIDER_DATE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UPPER(REPLACE(CONVERT(VARCHAR(20), U.DateOfBecomingInsider, 106), ' ', '/')), '-'))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_LANDLINE1]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.LandLine1,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_LANDLINE2]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.LandLine2,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_WEBSITE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.Website,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_PAN]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.PAN,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_TAN]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.[TAN],'')) --using [] because TAN is inbuilt function
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_DESCRIPTN]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.[Description],'')) --using [] because Description is inbuilt keyword
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_CATEGORY]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN U.Category IS NULL THEN ISNULL(U.CategoryText,'') ELSE ISNULL(CatCode.CodeName,'') END) )
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_SUBCATEGORY]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN U.SubCategory IS NULL THEN ISNULL(U.SubCategoryText,'') ELSE ISNULL(SubcatCode.CodeName,'') END) )
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_GRADE]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN U.GradeId IS NULL THEN ISNULL(U.GradeText,'') ELSE ISNULL(GradeCode.CodeName,'') END) )
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_DESIGNATN]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN U.DesignationId IS NULL THEN ISNULL(U.DesignationText,'') ELSE ISNULL(DesigCode.CodeName,'') END) )
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_SUBDESIGNATN]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN U.SubDesignationId IS NULL THEN ISNULL(U.SubDesignationText,'') ELSE ISNULL(SubDesigCode.CodeName,'') END) )
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_DEPT]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN U.DepartmentId IS NULL THEN ISNULL(U.DepartmentText,'') ELSE ISNULL(DeptCode.CodeName,'') END) )
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_LOCATN]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.Location,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_UPSI_ACCESSCOMPANY]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UPSIAccessCompany.CompanyName,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_USERTYPE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UserTypeCode.CodeName,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_STATUS]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UserStatusCode.CodeName,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_SEPARATN_DATE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UPPER(REPLACE(CONVERT(VARCHAR(20), U.DateOfSeparation, 106), ' ', '/')), '-'))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_SEPARATN_REASON]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.ReasonForSeparation,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_CIN]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.CIN,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_DIN]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.DIN,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_DAYTOBEACTIVE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(U.NoOfDaysToBeActive,''))
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_INACTIVATN_DATE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UPPER(REPLACE(CONVERT(VARCHAR(20), U.DateOfInactivation, 106), ' ', '/')), '-'))
						
						--relative related placeholder replacement
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_EMAILID]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.EmailId,'') ELSE '' END) )
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_FIRSTNAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.FirstName,'') ELSE '' END) )
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_MIDDLENAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.MiddleName,'') ELSE '' END) ) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_LASTNAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.LastName,'') ELSE '' END) ) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_MOBILE_NUMBER]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.MobileNumber,'') ELSE '' END) ) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_ADDR1]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.AddressLine1,'') ELSE '' END) ) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_ADDR2]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.AddressLine2,'') ELSE '' END) ) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_COUNTRY]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(RelCountryCode.CodeName,'') ELSE '' END)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_STATE]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(RelStateCode.CodeName,'') ELSE '' END)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_CITY]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.City,'') ELSE '' END)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_PINCODE]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.PinCode,'') ELSE '' END)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_LANDLINE1]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.LandLine1,'') ELSE '' END)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_LANDLINE2]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.LandLine2,'') ELSE '' END)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_PAN]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(URelative.PAN,'') ELSE '' END)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_USERTYPE]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(RelUserTypeCode.CodeName,'') ELSE '' END)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_STATUS]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(RelUserStatusCode.CodeName,'') ELSE '' END)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_RELATNWITHEMP]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId THEN ISNULL(RelationTypeCode.CodeName,'') ELSE '' END)) 

						--DMAT related placeholder replacement for user
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_DMATACCNUMBER]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UDMAT.DEMATAccountNumber,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_DMATDPNAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN UDMAT.DPBankCodeId IS NULL THEN ISNULL(UDMAT.DPBank,'') ELSE ISNULL(UserDPBankCode.CodeName,'') END)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_DMATDPID]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UDMAT.DPID,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_DMATTMID]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UDMAT.TMID,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_DMATDESCRIPTN]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UDMAT.[Description],'')) --[] used because Description is a keyword
						WHEN (LOWER(@sPlaceholder) = LOWER('[USR_DMATACCOUNTTYPE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UserDMATAccTypeCode.CodeName,'')) 

						--DMAT related placeholder replacement for relative
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_DMATACCNUMBER]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(RelDMAT.DEMATAccountNumber,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_DMATDPNAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN RelDMAT.DPBankCodeId IS NULL THEN ISNULL(RelDMAT.DPBank,'') ELSE ISNULL(RelDPBankCode.CodeName,'') END)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_DMATDPID]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(RelDMAT.DPID,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_DMATTMID]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(RelDMAT.TMID,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_DMATDESCRIPTN]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(RelDMAT.[Description],'')) --[] used because Description is a keyword
						WHEN (LOWER(@sPlaceholder) = LOWER('[REL_DMATACCOUNTTYPE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(RelDMATAccTypeCode.CodeName,'')) 

						--User/Relative related common placeholder where value belonging to either User or Relative whichever is available will be replaced for placeholder
						WHEN (LOWER(@sPlaceholder) = LOWER('[UREL_FIRSTNAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN (PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId AND URelative.FirstName IS NOT NULL) THEN URelative.FirstName ELSE ISNULL(U.FirstName,ISNULL(U.ContactPerson,'')) END) )
						WHEN (LOWER(@sPlaceholder) = LOWER('[UREL_MIDDLENAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN (PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId AND URelative.MiddleName IS NOT NULL) THEN URelative.MiddleName ELSE ISNULL(U.MiddleName,'') END) ) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[UREL_LASTNAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN (PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId AND URelative.LastName IS NOT NULL) THEN URelative.LastName ELSE ISNULL(U.LastName,'') END) ) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[UREL_MOBILE_NUMBER]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN (PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId AND URelative.MobileNumber IS NOT NULL) THEN URelative.MobileNumber ELSE ISNULL(U.MobileNumber,'') END) ) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[UREL_PAN]')) THEN REPLACE(@FormEContents, @sPlaceholder, (CASE WHEN (PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId AND URelative.PAN IS NOT NULL) THEN URelative.PAN ELSE ISNULL(U.PAN,'') END) ) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[UREL_DMATACCNUMBER]')) THEN REPLACE(@FormEContents, @sPlaceholder, CASE WHEN (PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId AND RelDMAT.DEMATAccountNumber IS NOT NULL) THEN RelDMAT.DEMATAccountNumber ELSE ISNULL(UDMAT.DEMATAccountNumber,'') END)
						WHEN (LOWER(@sPlaceholder) = LOWER('[UREL_DMATDPNAME]')) THEN REPLACE(@FormEContents, @sPlaceholder, 
																								CASE WHEN (PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId) 
																								THEN (--preclearance taken for relative, replace with relative/ user details whichever are available
																										CASE WHEN RelDMAT.DPBankCodeId IS NULL 
																											 THEN ISNULL(RelDMAT.DPBank,(CASE WHEN UDMAT.DPBankCodeId IS NULL THEN ISNULL(UDMAT.DPBank,'') ELSE ISNULL(UserDPBankCode.CodeName,'') END) ) 
																											 ELSE ISNULL(RelDPBankCode.CodeName,(CASE WHEN UDMAT.DPBankCodeId IS NULL THEN ISNULL(UDMAT.DPBank,'') ELSE ISNULL(UserDPBankCode.CodeName,'') END) ) 
																											 END
																									 )
																								ELSE (--preclearance taken for user him/herself, replace with user details
																										CASE WHEN UDMAT.DPBankCodeId IS NULL THEN ISNULL(UDMAT.DPBank,'') ELSE ISNULL(UserDPBankCode.CodeName,'') END
																									 )
																								END
																							)
						WHEN (LOWER(@sPlaceholder) = LOWER('[UREL_DMATDPID]')) THEN REPLACE(@FormEContents, @sPlaceholder, CASE WHEN (PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId AND RelDMAT.DPID IS NOT NULL) THEN RelDMAT.DPID ELSE ISNULL(UDMAT.DPID,'') END)
						WHEN (LOWER(@sPlaceholder) = LOWER('[UREL_DMATTMID]')) THEN REPLACE(@FormEContents, @sPlaceholder, CASE WHEN (PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId AND RelDMAT.TMID IS NOT NULL) THEN RelDMAT.TMID ELSE ISNULL(UDMAT.TMID,'') END)
						WHEN (LOWER(@sPlaceholder) = LOWER('[UREL_DMATDESCRIPTN]')) THEN REPLACE(@FormEContents, @sPlaceholder, CASE WHEN (PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId AND RelDMAT.[Description] IS NOT NULL) THEN RelDMAT.[Description] ELSE ISNULL(UDMAT.[Description],'') END)
						WHEN (LOWER(@sPlaceholder) = LOWER('[UREL_DMATACCOUNTTYPE]')) THEN REPLACE(@FormEContents, @sPlaceholder, CASE WHEN (PCL.PreclearanceRequestForCodeId = @nPreclearanceRequestForRelativeCodeId AND RelDMAT.AccountTypeCodeId IS NOT NULL) THEN ISNULL(RelDMATAccTypeCode.CodeName,'') ELSE ISNULL(UserDMATAccTypeCode.CodeName,'') END)

						--Preclearance related placeholder replacement
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_REQUESTFOR]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(PCLReqForCode.CodeName,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_TRANSACTNTYPE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(PCLTransTypeCode.CodeName,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_SECURITYTYPE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(PCLSecTypeCode.CodeName,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_SECURITYTRADEQTY]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL((SELECT dbo.uf_com_FormatNumberToCurrency(PCL.SecuritiesToBeTradedQty,'IND')),'0')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_SECURITYTRADEVALUE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL((SELECT dbo.uf_com_FormatNumberToCurrency(PCL.SecuritiesToBeTradedValue,'IND')),'0')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_STATUS]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(PCLStatusCode.CodeName,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_IMPLEMENTCOMPANY]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(@sImplementingCompanyName,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_TRADEDFORCOMPANY]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(PCLRestrictedCompany.CompanyName,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_REJECTREASON]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(PCL.ReasonForRejection,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_PLEDGEOPTNQTY]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(PCL.PledgeOptionQty,'0')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_ACQUISITNMODE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(PCLAccqModeCode.CodeName,'')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_BUYDATE]')) 
							THEN (
								CASE WHEN PCL.TransactionTypeCodeId = @nPreclearanceTransTypeCodeBuy 
								THEN REPLACE(@FormEContents, @sPlaceholder, @sNotApplicable) 
								ELSE (CASE WHEN PCL.TransactionTypeCodeId = @nPreclearanceTransTypeCodeSale 
									  THEN REPLACE(@FormEContents, @sPlaceholder,  ISNULL(UPPER(REPLACE(CONVERT(VARCHAR(20), @dtLastPreclearanceBuyDate, 106), ' ', '/')), @sNotApplicable)) 
									  ELSE REPLACE(@FormEContents, @sPlaceholder, @sNotApplicable)  
									  END) 
								END
								)
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_PREVAPPROVNUMBERANDDATE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(@sLastPreclearanceBuyFormattedId + ' (' + ISNULL(UPPER(REPLACE(CONVERT(VARCHAR(20), @dtLastPreclearanceBuyDate, 106), ' ', '/')), '') +') ', @sNotApplicable)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_PREVAPPROVNUMBER]')) THEN REPLACE(@FormEContents, @sPlaceholder,  ISNULL(@sLastPreclearanceBuyFormattedId, @sNotApplicable)) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_REQUESTDATE]')) THEN REPLACE(@FormEContents, @sPlaceholder,  ISNULL(UPPER(REPLACE(CONVERT(VARCHAR(20), PCL.CreatedOn, 106), ' ', '/')), '-')) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_APPROVEDDATE]')) THEN REPLACE(@FormEContents, @sPlaceholder,  ISNULL(UPPER(REPLACE(CONVERT(VARCHAR(20), PCL.ApprovedOn, 106), ' ', '/')), '-') + ' ' + ISNULL(RIGHT(CONVERT(VARCHAR(50), PCL.ApprovedOn, 100),8),'') ) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_APPROVEDBY]')) 
							THEN ( 
								CASE WHEN PCL.IsAutoApproved = 0 
								THEN REPLACE(@FormEContents, @sPlaceholder, @sComplianceOfficer)
								ELSE REPLACE(@FormEContents, @sPlaceholder, @sComplianceOfficer)
								END
								) 
						--Replace placeholders with "Not Applicable" which are NOT RELEVANT to Non Implementing company
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_TRADERATEFRM]')) THEN REPLACE(@FormEContents, @sPlaceholder, @sNotApplicable) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_TRADERATETO]')) THEN REPLACE(@FormEContents, @sPlaceholder, @sNotApplicable) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_EXERCISEOPTNQTY]')) THEN REPLACE(@FormEContents, @sPlaceholder, @sNotApplicable) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_OTHREXERCISEOPTNQTY]')) THEN REPLACE(@FormEContents, @sPlaceholder, @sNotApplicable) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_NOTTRADEDREASON]')) THEN REPLACE(@FormEContents, @sPlaceholder, @sNotApplicable) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_NOTTRADEDREASONDTL]')) THEN REPLACE(@FormEContents, @sPlaceholder, @sNotApplicable) 
						WHEN (LOWER(@sPlaceholder) = LOWER('[PCL_VALIDITYDAYS]')) THEN REPLACE(@FormEContents, @sPlaceholder, @sNotApplicable) 
						--server date related placeholder replacement
						WHEN (LOWER(@sPlaceholder) = LOWER('[SRV_DATE]')) THEN REPLACE(@FormEContents, @sPlaceholder, ISNULL(UPPER(REPLACE(CONVERT(VARCHAR(20), @dtCurrentServerDate, 106), ' ', '/')), '-'))

						ELSE @FormEContents
						END -- End of CASE statement
		    	FROM tra_PreclearanceRequest_NonImplementationCompany PCL 
				--table JOINs for Preclearance details
				INNER JOIN com_Code PCLReqForCode ON PCL.PreclearanceRequestForCodeId = PCLReqForCode.CodeID
				INNER JOIN com_Code PCLTransTypeCode ON PCL.TransactionTypeCodeId = PCLTransTypeCode.CodeID
				INNER JOIN com_Code PCLSecTypeCode ON PCL.SecurityTypeCodeId = PCLSecTypeCode.CodeID
				INNER JOIN com_Code PCLStatusCode ON PCL.PreclearanceStatusCodeId = PCLStatusCode.CodeID
				INNER JOIN rl_CompanyMasterList PCLRestrictedCompany ON PCL.CompanyId = PCLRestrictedCompany.RlCompanyId
				LEFT JOIN com_Code PCLAccqModeCode ON PCL.ModeOfAcquisitionCodeId = PCLAccqModeCode.CodeID
				LEFT JOIN usr_UserInfo PCLApprover ON PCL.ApprovedBy = PCLApprover.UserInfoId
				--table JOINs for user details
				INNER JOIN usr_UserInfo U ON PCL.UserInfoId = U.UserInfoId AND PCL.DisplaySequenceNo = @inp_nMapToId
				LEFT JOIN mst_Company Company ON U.CompanyId = Company.CompanyId
				LEFT JOIN com_Code CountryCode ON U.CountryId = CountryCode.CodeID
				LEFT JOIN com_Code StateCode ON U.StateId = StateCode.CodeID
				LEFT JOIN com_Code CatCode ON U.Category = CatCode.CodeID
				LEFT JOIN com_Code SubcatCode ON U.SubCategory = SubcatCode.CodeID
				LEFT JOIN com_Code GradeCode ON U.GradeId = GradeCode.CodeID
				LEFT JOIN com_Code DesigCode ON U.DesignationId = DesigCode.CodeID
				LEFT JOIN com_Code SubDesigCode ON U.SubDesignationId = SubDesigCode.CodeID
				LEFT JOIN com_Code DeptCode ON U.DepartmentId = DeptCode.CodeID
				LEFT JOIN mst_Company UPSIAccessCompany ON U.UPSIAccessOfCompanyID = UPSIAccessCompany.CompanyId
				LEFT JOIN com_Code UserTypeCode ON U.UserTypeCodeId = UserTypeCode.CodeID
				LEFT JOIN com_Code UserStatusCode ON U.StatusCodeId = UserStatusCode.CodeID
				--table JOINs for User DMAT details
				LEFT JOIN usr_DMATDetails UDMAT ON U.UserInfoId = UDMAT.UserInfoID AND UDMAT.DMATDetailsID = PCL.DMATDetailsID
				LEFT JOIN com_Code UserDPBankCode ON UDMAT.DPBankCodeId = UserDPBankCode.CodeID
				LEFT JOIN com_Code UserDMATAccTypeCode ON UDMAT.AccountTypeCodeId = UserDMATAccTypeCode.CodeID
				--table JOINS for Relative details
				LEFT JOIN usr_UserRelation UR ON U.UserInfoId = UR.UserInfoId AND PCL.UserInfoIdRelative = UR.UserInfoIdRelative
				LEFT JOIN usr_UserInfo URelative ON UR.UserInfoIdRelative = URelative.UserInfoId AND PCL.UserInfoIdRelative = URelative.UserInfoId --Table for getting user details pertaining to relative
				LEFT JOIN com_Code RelCountryCode ON URelative.CountryId = RelCountryCode.CodeID
				LEFT JOIN com_Code RelStateCode ON URelative.StateId = RelStateCode.CodeID
				LEFT JOIN com_Code RelUserTypeCode ON URelative.UserTypeCodeId = RelUserTypeCode.CodeID
				LEFT JOIN com_Code RelUserStatusCode ON URelative.StatusCodeId = RelUserStatusCode.CodeID
				LEFT JOIN com_Code RelationTypeCode ON UR.RelationTypeCodeId = RelationTypeCode.CodeID
				--table JOINs for Relative DMAT details
				LEFT JOIN usr_DMATDetails RelDMAT ON URelative.UserInfoId = RelDMAT.UserInfoID AND RelDMAT.DMATDetailsID = PCL.DMATDetailsID
				LEFT JOIN com_Code RelDPBankCode ON RelDMAT.DPBankCodeId = RelDPBankCode.CodeID
				LEFT JOIN com_Code RelDMATAccTypeCode ON RelDMAT.AccountTypeCodeId = RelDMATAccTypeCode.CodeID				
		    END		
			
            SET @sGeneratedFormContents_FormE_Final = @FormEContents
      
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_FORM_GENERATION_FAIL, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END