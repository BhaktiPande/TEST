IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GeneratedFormTradeContents_OS')
DROP PROCEDURE [dbo].[st_tra_GeneratedFormTradeContents_OS]
GO
/****** Object:  StoredProcedure [dbo].[st_tra_GenerateFormDetails_OS]    Script Date: 03/06/2019 15:25:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	save formatted Form C for Continuous Disclosures Form for Other Securities

Returns:		0, if Success.
				
Created by:		Shubhangi Gurude
Created on:		07-Mar-2019
EXEC st_tra_GeneratedFormTradeContents_OS 132020,46,370,null,null

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE st_tra_GeneratedFormTradeContents_OS --132020,46,370,null
	@inp_nMapToTypeCodeId					INT,
	@inp_nMapToId							INT,	--Id of Preclearance for which Form E is to be generated
	@inp_nLoggedInUserId					INT,	-- Id of the user inserting the Form E contents
	@sFormContents_FormC                   NVARCHAR(MAX) ='',
    @sGeneratedFormContents_FormC_Final     NVARCHAR(MAX) OUTPUT,
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT

AS
BEGIN
	DECLARE @ERR_FORM_GENERATION_FAIL INT =  54058 -- Error occurred while generating form b  For OS details 
	print(@sFormContents_FormC)
	DECLARE @nMapTypePreclearance_NonImplementingCompany INT = 132020	--MapToTypeId for type Preclearance of NonImplementing Company
	DECLARE @nInitialDisclosuresRequestForSelfCodeId INT = 142001
	DECLARE @nInitialDisclosuresRequestForRelativeCodeId INT = 142002
	
	DECLARE @nCommunicationModeCodeId_FormCForSelf INT = 156009 --Form C is applicable for preclearance of implementing and nonimplementing company (template is same)
	DECLARE @nCommunicationModeCodeId_FormCForRelative INT = 156009 --Form C is applicable for preclearance of implementing and nonimplementing company (template is same)
	
	DECLARE @dtLastInitialDisclosuresBuyDate	DATETIME = NULL
	DECLARE @nLastInitialDisclosuresBuyId	INT = NULL
	DECLARE @sLastInitialDisclosuresBuyFormattedId	VARCHAR(300) = NULL
	DECLARE @sInitialDisclosuresCodePrefixText			VARCHAR(3)
	DECLARE @nInitialDisclosuresTakenCase INT = 176001

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
	DECLARE @FormCContents NVARCHAR(MAX) = ''

	
	DECLARE @sPNT VARCHAR(10) = 'PNT No. '
	DECLARE @sPCL VARCHAR(10) = 'PCL No. '
	
	
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
		SELECT PlaceholderTag, PlaceholderDisplayName  FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 --and PlaceholderTag in('[USROS_FIRSTNAME]','[USROS_MIDDLENAME]','[USROS_LASTNAME]','[USROS_EMPLOYEEID]','[USROS_DEPT]','[USROS_INITIALDISCLOSURESUBMISSIONDATE]','[USROS_DESIGNATION]')

		--get count of total placeholders strored in placeholder table
		SELECT @nPlaceholderCount = COUNT(ID) FROM #tblPlaceholders 
			
			SET @FormCContents = @sFormContents_FormC            
            --print 'Static data'            
			
			---------- For Static Content ---------
			WHILE(@nCounter < @nPlaceholderCount)
			BEGIN
			
				SELECT @nCounter = @nCounter + 1
				
				SELECT @sPlaceholder = Placeholder FROM #tblPlaceholders WHERE ID = @nCounter
			 
			  SELECT  @FormCContents =  CASE 											
											WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_FIRSTNAME]')) THEN REPLACE(@FormCContents, @sPlaceholder, ISNULL(U.FIRSTNAME,'')) 
											WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_MIDDLENAME]')) THEN REPLACE(@FormCContents, @sPlaceholder, ISNULL(U.MIDDLENAME,'')) 
											WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_LASTNAME]')) THEN REPLACE(@FormCContents, @sPlaceholder, ISNULL(U.LASTNAME,'')) 
											WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_DEPT]')) THEN REPLACE(@FormCContents, @sPlaceholder,ISNULL(DeptCode.CODENAME,DeptCodeRelative.CODENAME)) 
											WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_EMPLOYEEID]')) THEN REPLACE(@FormCContents, @sPlaceholder,ISNULL(U.EmployeeId,URelative.EmployeeId)) 
											WHEN (LOWER(@sPlaceholder) = LOWER('[PCLOS_NO]')) THEN REPLACE(@FormCContents, @sPlaceholder,CASE WHEN PCNL.DisplaySequenceNo IS NULL THEN @sPNT + CONVERT(VARCHAR,TM.DisplayRollingNumber) ELSE @sPCL + CONVERT(VARCHAR,PCNL.DisplaySequenceNo)  END) 
											WHEN (LOWER(@sPlaceholder) = LOWER('[PCLOS_DATE]')) THEN REPLACE(@FormCContents, @sPlaceholder,CASE WHEN PCNL.CreatedOn IS NULL THEN CONVERT(VARCHAR,TD.DateOfAcquisition,106) ELSE CONVERT(VARCHAR,PCNL.CreatedOn,106) END)
											WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_INTIMATIONDATE]')) THEN REPLACE(@FormCContents, @sPlaceholder,CASE WHEN TD.DateOfInitimationToCompany IS NULL THEN NULL ELSE CONVERT(VARCHAR,TD.DateOfInitimationToCompany,106) END)
										  			  
										  ELSE @FormCContents
										END											
						
				 FROM tra_TransactionMaster_OS AS TM INNER JOIN 
				 tra_TransactionDetails_OS AS TD ON TM.TransactionMasterId =TD.TransactionMasterId	
				 LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PCNL ON TM.PreclearanceRequestId=PCNL.PreclearanceRequestId	
				 LEFT JOIN  USR_USERINFO AS U ON TD.ForUserInfoId = U.UserInfoId
				 LEFT JOIN com_Code DeptCode ON U.DepartmentId = DeptCode.CodeID				
				 --LEFT JOIN usr_DMATDetails AS UDMAT ON U.UserInfoId=UDMAT.UserInfoId AND UDMAT.DMATDetailsID = TD.DMATDetailsID
				 LEFT JOIN usr_UserRelation AS  UR ON  TD.ForUserinfoid=UR.UserInfoIdRelative
				 LEFT JOIN usr_UserInfo AS  URelative ON URelative.UserInfoId = UR.UserInfoId
				 --LEFT JOIN mst_Company AS MCRELATIVE ON URelative.COMPANYID=MCRELATIVE.COMPANYID
				 LEFT JOIN com_Code DeptCodeRelative ON URelative.DepartmentId = DeptCodeRelative.CodeID
				 --LEFT JOIN com_Code CodeDesignaiton ON CASE WHEN URelative.DesignationId IS NULL THEN U.DesignationId else URelative.DesignationId  END = CodeDesignaiton.CodeID
				 --LEFT JOIN usr_DMATDetails AS UDMATRelative ON UR.UserInfoIdRelative=UDMATRelative.UserInfoId AND UDMATRelative.DMATDetailsID = TD.DMATDetailsID
				 LEFT JOIN COM_CODE AS RELATION_WITH_INSIDER ON RELATION_WITH_INSIDER.CODEID=ur.RelationTypeCodeId
				 where  TM.TransactionMasterId=@inp_nMapToId   
			
		    END		 
            SET @sGeneratedFormContents_FormC_Final = @FormCContents 
			
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