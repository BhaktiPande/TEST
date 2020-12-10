IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GeneratedFormBContents_OS')
DROP PROCEDURE [dbo].[st_tra_GeneratedFormBContents_OS]
GO
/****** Object:  StoredProcedure [dbo].[st_tra_GenerateFormDetails_OS]    Script Date: 03/06/2019 15:25:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	save formatted Form B for Initial Disclosures Form for Other Securities

Returns:		0, if Success.
				
Created by:		Samadhan kadam
Created on:		07-Mar-2019
EXEC st_tra_GenerateFormDetails_NonImplementingCompany <MapToTypeId> <MapToId> <LoggedInUserId>

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE st_tra_GeneratedFormBContents_OS
	@inp_nMapToTypeCodeId					INT,
	@inp_nMapToId							INT,	--Id of Preclearance for which Form E is to be generated
	@inp_nLoggedInUserId					INT,	-- Id of the user inserting the Form E contents
	@sFormContents_FormB                    NVARCHAR(MAX) ='',
    @sGeneratedFormContents_FormB_Final     NVARCHAR(MAX) OUTPUT,
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT

AS
BEGIN
	DECLARE @ERR_FORM_GENERATION_FAIL INT =  54058 -- Error occurred while generating form b  For OS details 

	DECLARE @nMapTypePreclearance_NonImplementingCompany INT = 132020	--MapToTypeId for type Preclearance of NonImplementing Company
	DECLARE @nInitialDisclosuresRequestForSelfCodeId INT = 142001
	DECLARE @nInitialDisclosuresRequestForRelativeCodeId INT = 142002
	
	DECLARE @nCommunicationModeCodeId_FormBForSelf INT = 156008 --Form B is applicable for preclearance of implementing and nonimplementing company (template is same)
	DECLARE @nCommunicationModeCodeId_FormBForRelative INT = 156008 --Form B is applicable for preclearance of implementing and nonimplementing company (template is same)
	
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
	DECLARE @FormBContents NVARCHAR(MAX) = ''
	
	
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
		SELECT PlaceholderTag, PlaceholderDisplayName  FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 --and PlaceholderTag in('[USROS_FIRSTNAME]','[USROS_MIDDLENAME]','[USROS_LASTNAME]','[USROS_EMPLOYEEID]','[USROS_DEPT]','[USROS_INITIALDISCLOSURESUBMISSIONDATE]','[USROS_DESIGNATION]')

		DECLARE @nUserTypeCodeId INT
		DECLARE @nUserinfoID INT
		DECLARE @nTransUserID INT

		SELECT @nUserTypeCodeId=UserTypeCodeId,@nTransUserID=UserInfoId FROM usr_UserInfo WHERE UserInfoId IN(
		SELECT UserInfoId FROM tra_TransactionMaster_OS WHERE TransactionMasterId=@inp_nMapToId)

		IF(@nUserTypeCodeId=101007)
		BEGIN
			SELECT @nUserinfoID=UR.UserInfoId FROM usr_UserRelation UR JOIN usr_UserInfo UI ON UR.UserInfoId=UI.UserInfoId WHERE UserInfoIdRelative=@nTransUserID
		END
		ELSE
		BEGIN
			SET @nUserinfoID=@nTransUserID
		END

		--get count of total placeholders strored in placeholder table
		SELECT @nPlaceholderCount = COUNT(ID) FROM #tblPlaceholders
		
            SET @FormBContents = @sFormContents_FormB
            PRINT('@inp_nMapToId')
			PRINT @inp_nMapToId
            --print 'Static data'
            --print  @FormBContents
			---------- For Static Content ---------
			WHILE(@nCounter < @nPlaceholderCount)
			BEGIN
			
				SELECT @nCounter = @nCounter + 1
				
				SELECT @sPlaceholder = Placeholder FROM #tblPlaceholders WHERE ID = @nCounter
			  SELECT  @FormBContents =  CASE											
											WHEN (LOWER(@sPlaceholder) = LOWER('[USROS_FIRSTNAME]')) THEN REPLACE(@FormBContents, @sPlaceholder, ISNULL(U.FIRSTNAME,' ')) 
											WHEN (LOWER(@sPlaceholder) = LOWER('[USROS_MIDDLENAME]')) THEN REPLACE(@FormBContents, @sPlaceholder, ISNULL(U.MIDDLENAME,' ')) 
											WHEN (LOWER(@sPlaceholder) = LOWER('[USROS_LASTNAME]')) THEN REPLACE(@FormBContents, @sPlaceholder, ISNULL(U.LASTNAME,' '))									
											WHEN (LOWER(@sPlaceholder) = LOWER('[USROS_INITIALDISCLOSURESUBMISSIONDATE]')) THEN REPLACE(@FormBContents, @sPlaceholder,ISNULL(convert(varchar,GETDATE(),106),' ')) 
											WHEN (LOWER(@sPlaceholder) = LOWER('[USROS_DEPT]')) THEN REPLACE(@FormBContents, @sPlaceholder,ISNULL(DeptCode.CODENAME,'')) 
											WHEN (LOWER(@sPlaceholder) = LOWER('[USROS_EMPLOYEEID]')) THEN REPLACE(@FormBContents, @sPlaceholder,ISNULL(U.EmployeeId,'')) 
											WHEN (LOWER(@sPlaceholder) = LOWER('[USROS_DESIGNATION]')) THEN REPLACE(@FormBContents, @sPlaceholder,ISNULL(CodeDesignaiton.CODENAME,'-')) 
										  ELSE @FormBContents
										END										
						
				 FROM 				
				  USR_USERINFO AS U
				 LEFT JOIN com_Code DeptCode ON U.DepartmentId = DeptCode.CodeID
				 LEFT JOIN mst_Company AS MC ON U.COMPANYID=MC.COMPANYID		
				 LEFT JOIN com_Code CodeDesignaiton ON U.DepartmentId=CodeDesignaiton.CodeID 
				 where  U.UserInfoId=@nUserinfoID
			    
			
		    END		
		     --print @FormBContents		 
            SET @sGeneratedFormContents_FormB_Final = @FormBContents		
           
    --select @sGeneratedFormContents_FormB_Final
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