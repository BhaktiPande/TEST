IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GenerateFormDetails_ForTrade_OS')
DROP PROCEDURE [dbo].[st_tra_GenerateFormDetails_ForTrade_OS]
GO
/****** Object:  StoredProcedure [dbo].[st_tra_GenerateFormDetails_OS]    Script Date: 03/06/2019 15:25:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	save formatted Form B for Initial Disclosures Form for Other Securities

Returns:		0, if Success.
				
Created by:		Shubhangi Gurude
Created on:		06-Mar-2019
EXEC [dbo].[st_tra_GenerateFormDetails_ForTrade_OS] 132020,46,370
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_GenerateFormDetails_ForTrade_OS] 
	@inp_nMapToTypeCodeId					INT,
	@inp_nMapToId							INT,	--Id of Preclearance for which Form E is to be generated
	@inp_nLoggedInUserId					INT,	-- Id of the user inserting the Form B contents
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT

AS
BEGIN

	DECLARE @ERR_FORM_GENERATION_FAIL INT = 54058 -- Error occurred while generating form b  For OS details 

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
	DECLARE @sGeneratedFormContents_FormC NVARCHAR(MAX) = ''
	DECLARE @sGeneratedFormContents_FormC_Final NVARCHAR(MAX)
	DECLARE @nTemplateMasterId INT
	DECLARE @nPlaceholderCount INT = 0
	DECLARE @nCounter INT = 0
	DECLARE @RowCount int=0
	DECLARE @RowCounter int=1
	DECLARE @sPlaceholder VARCHAR(255)

	DECLARE @nPreclearanceTakenForCodeId INT = 0
	DECLARE @bIsAutoApproved BIT = 0

	DECLARE @sNotApplicable VARCHAR(100) = 'Not Applicable'
	DECLARE @sAutoApproved VARCHAR(100) = 'Auto approved'
	DECLARE @sComplianceOfficer VARCHAR(500) = 'Compliance Officer / Authorized Official'

	DECLARE @sImplementingCompanyName NVARCHAR(200) = ''
	
    DECLARE @BeforeTableContents NVARCHAR(MAX)='';
    DECLARE @AfterTableContents NVARCHAR(MAX)='';
            
    DECLARE @BeforeTableContentsData NVARCHAR(MAX)='';
    DECLARE @AfterTableContentsData NVARCHAR(MAX)='';
    DECLARE @sGeneratedFormContents_FormB_Data NVARCHAR(MAX) = ''

    DECLARE @TableContents NVARCHAR(MAX)='';
    DECLARE @TableRow NVARCHAR(MAX)='';
    DECLARE @FinalTableRows NVARCHAR(MAX)='';
    DECLARE @RecordCount INT=0;
    DECLARE @TableHeaders NVARCHAR(MAX)='';
    DECLARE @TableFooters NVARCHAR(MAX)='';
   
    DECLARE @PreReqId VARCHAR(MAX)

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
		----------------------------------
		SELECT @dtCurrentServerDate = dbo.uf_com_GetServerDate() --Get the current serverdate by making single call to function uf_com_GetServerDate()

		SELECT @sImplementingCompanyName = CompanyName FROM mst_Company WHERE IsImplementing = 1 --Fetch the CompanyName of implementing company

		INSERT INTO #tblPlaceholders(Placeholder, PlaceholderDisplayName)
		SELECT PlaceholderTag, PlaceholderDisplayName  FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 --and PlaceholderTag in('[USROS_DEMATACCOUNT]','[USROS_FIRSTNAME]','[USROS_MIDDLENAME]','[USROS_LASTNAME]','[USROS_RELATIONWITHINSIDER]','[USROS_PAN]','[USROS_SCRIP_NAME]','[USROS_ISIN]','[USROS_SECURITYTYPE]','[USROS_HOLDINGS]','[USROS_DEPT]')
		
		--get count of total placeholders strored in placeholder table
		SELECT @nPlaceholderCount = COUNT(ID) FROM #tblPlaceholders
		
		IF(@inp_nMapToTypeCodeId = @nMapTypePreclearance_NonImplementingCompany) --Perform processing for generation of formatted Form B
		BEGIN
					
			SELECT @sGeneratedFormContents_FormC = Contents, @nTemplateMasterId = TemplateMasterId FROM tra_TemplateMaster WHERE CommunicationModeCodeId = @nCommunicationModeCodeId_FormCForRelative
			
           ----------------- For Multiple Preclearance Request -------------
           IF CHARINDEX('<table', @sGeneratedFormContents_FormC ) > 0 
           BEGIN 
           DECLARE @FindParaBeforeTable NVARCHAR(MAX)
           SELECT @FindParaBeforeTable= SUBSTRING(@sGeneratedFormContents_FormC,1,CHARINDEX('<table',@sGeneratedFormContents_FormC))  
           
           SELECT @BeforeTableContents= CHARINDEX('<p',@FindParaBeforeTable,CHARINDEX('<table', @sGeneratedFormContents_FormC))
           SELECT @BeforeTableContents=(CHARINDEX('<p',@FindParaBeforeTable))     
       
		  
		   IF(@BeforeTableContents>0)
           BEGIN              
			   SELECT @BeforeTableContents = SUBSTRING(@sGeneratedFormContents_FormC,CHARINDEX('<div',@sGeneratedFormContents_FormC),CHARINDEX('<table',@sGeneratedFormContents_FormC)-5)
				EXEC st_tra_GeneratedFormTradeContents_OS @inp_nMapToTypeCodeId,@inp_nMapToId,@inp_nLoggedInUserId,@BeforeTableContents ,@sGeneratedFormContents_FormC_Final OUTPUT
	        
			   SET @BeforeTableContentsData = @sGeneratedFormContents_FormC_Final	         		 
           END
           
           SELECT @AfterTableContents = SUBSTRING(@sGeneratedFormContents_FormC,CHARINDEX('</table',@sGeneratedFormContents_FormC)+8,99999)
        
           exec st_tra_GeneratedFormTradeContents_OS @inp_nMapToTypeCodeId,@inp_nMapToId,@inp_nLoggedInUserId,@AfterTableContents ,@sGeneratedFormContents_FormC_Final OUTPUT
           SET @AfterTableContentsData = @sGeneratedFormContents_FormC_Final
                    
           SELECT @TableContents = SUBSTRING(@sGeneratedFormContents_FormC,CHARINDEX('<table',@sGeneratedFormContents_FormC),CHARINDEX('</table',@sGeneratedFormContents_FormC)-CHARINDEX('<table',@sGeneratedFormContents_FormC)+8)
          
           SELECT @TableRow = SUBSTRING(@TableContents,CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1)),CHARINDEX('</tr',@TableContents,(CHARINDEX('</tr',@TableContents)+1)) - CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1))+5)
                                
           SELECT @TableHeaders = SUBSTRING(@TableContents,CHARINDEX('<table',@TableContents),CHARINDEX('</tr',@TableContents)+ 4)
                                
           SELECT @TableFooters = SUBSTRING(@TableContents,CHARINDEX('</tbody',@TableContents),CHARINDEX('</table',@TableContents))
                          	    
		    CREATE TABLE #Temp
			(
				tempID int identity(1,1), 
				TransactionDetailsId bigint
			)
		    INSERT INTO #Temp(TransactionDetailsId)		     
		   --  select PreclearanceRequestId from tra_PreclearanceRequest_NonImplementationCompany where DisplaySequenceNo = @inp_nMapToId
	        select TransactionDetailsId from tra_TransactionMaster_OS as TM inner join tra_TransactionDetails_OS as TD on TM.TransactionMasterid= TD.TransactionMasterid where TM.TransactionMasterid=@inp_nMapToId
		
	
			SELECT @RowCount = COUNT(TransactionDetailsId) from #Temp
			DECLARE @TransactionDetailsId int=0
			
			
			WHILE(@RowCounter <= @RowCount)
			BEGIN
			
			SET @nCounter = 1;
				SELECT @TableRow = SUBSTRING(@TableContents,CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1)),CHARINDEX('</tr',@TableContents,(CHARINDEX('</tr',@TableContents)+1)) - CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1))+5)
				 SELECT @TransactionDetailsId = TransactionDetailsId from #Temp WHERE tempID = @RowCounter	
					
			WHILE(@nCounter <= @nPlaceholderCount)
			BEGIN          
				
				SELECT @sPlaceholder = Placeholder FROM #tblPlaceholders WHERE ID = @nCounter				
				
				SELECT  @TableRow =CASE 
										WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_ACCOUNTHOLDERNAME]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(U.FIRSTNAME,'') +' ' +ISNULL(U.MIDDLENAME,'') +' '+ ISNULL(U.LASTNAME,'')) 
										WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_RELATIONWITHINSIDER]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(RELATION_WITH_INSIDER.CODENAME,'Self')) 
										WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_PAN]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(U.PAN,''))
										WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_COMPANYNAME]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(RCM.CompanyName,''))  
										WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_SECURITYTYPE]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(OS_SECURITYTYPE.CODENAME,''))										
										WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_TRANSACTIONTYPE]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(OS_TransType.CodeName,''))										
										WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_DEMATACCOUNTNO]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(UDMAT.DEMATAccountNumber,''))
										WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_HOLDINGS]')) THEN REPLACE(@TableRow, @sPlaceholder,CASE WHEN TD.SecurityTypeCodeId = 139004 OR TD.SecurityTypeCodeId = 139005 THEN ISNULL(TD.Quantity * TD.LotSize,'0') ELSE ISNULL(TD.Quantity,'0') END)										
										WHEN (LOWER(@sPlaceholder) = LOWER('[CDOS_NAMEOFEXCHANGE]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(OS_ExchangeCodeId.CodeName,'0')) 										
										ELSE @TableRow 
					 			  END						
						
				 FROM tra_TransactionMaster_OS AS TM INNER JOIN 
				 tra_TransactionDetails_OS AS TD ON TM.TransactionMasterId =TD.TransactionMasterId
				 LEFT JOIN COM_CODE AS OS_SECURITYTYPE ON TD.SecurityTypeCodeId=OS_SECURITYTYPE.CODEID
				 LEFT JOIN  USR_USERINFO AS U ON TD.ForUserInfoId = U.UserInfoId 
				 LEFT JOIN com_Code OS_TransType ON TD.TransactionTypeCodeId = OS_TransType.CodeID
				 LEFT JOIN COM_CODE OS_ExchangeCodeId ON TD.ExchangeCodeId=OS_ExchangeCodeId.CodeID
				 LEFT JOIN rl_CompanyMasterList RCM ON RCM.RlCompanyId=TD.CompanyId
				 LEFT JOIN usr_DMATDetails AS UDMAT ON U.UserInfoId=UDMAT.UserInfoId AND UDMAT.DMATDetailsID = TD.DMATDetailsID
				 LEFT JOIN usr_UserRelation AS  UR ON  TD.ForUserinfoid=UR.UserInfoIdRelative
				 LEFT JOIN usr_UserInfo AS  URelative ON URelative.UserInfoId = UR.UserInfoId
				 LEFT JOIN mst_Company AS MCRELATIVE ON case when  URelative.COMPANYID is null then u.COMPANYID else  URelative.COMPANYID end =MCRELATIVE.COMPANYID
				 LEFT JOIN usr_DMATDetails AS UDMATRelative ON UR.UserInfoIdRelative=UDMATRelative.UserInfoId
				 LEFT JOIN COM_CODE AS RELATION_WITH_INSIDER ON RELATION_WITH_INSIDER.CODEID=ur.RelationTypeCodeId
			     where  TD.TransactionDetailsId= @TransactionDetailsId
				 set @nCounter = @nCounter +1	
			END 			
		   	   SET @FinalTableRows = @FinalTableRows + @TableRow  	
			   SET @RowCounter = @RowCounter + 1			   
			END			
			   SET @sGeneratedFormContents_FormB_Data = @BeforeTableContentsData + @TableHeaders + @FinalTableRows + @TableFooters + @AfterTableContentsData	
			END			
		--print @sGeneratedFormContents_FormB_Data
			----------------For Save Generated Form B-------------
			IF NOT EXISTS (SELECT GeneratedFormDetailsId FROM tra_GeneratedFormDetails WHERE TemplateMasterId = @nTemplateMasterId AND MapToTypeCodeId = @inp_nMapToTypeCodeId and MapToId = @inp_nMapToId)
			BEGIN			    
			    INSERT INTO tra_GeneratedFormDetails(TemplateMasterId, MapToTypeCodeId, MapToId, GeneratedFormContents, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
				SELECT @nTemplateMasterId AS TemplateMasterId, @inp_nMapToTypeCodeId AS MapToTypeCodeId, @inp_nMapToId AS MapToId, 
					   @sGeneratedFormContents_FormB_Data AS GeneratedFormContents, 
					   CASE WHEN @bIsAutoApproved = 1 THEN 1 ELSE @inp_nLoggedInUserId END AS CreatedBy, --CreatedBy will be 1 if the preclearance is auto-approved
					   @dtCurrentServerDate AS CreatedOn, 
					   CASE WHEN @bIsAutoApproved = 1 THEN 1 ELSE @inp_nLoggedInUserId END AS ModifiedBy, --ModifiedBy will be 1 if the preclearance is auto-approved
					   @dtCurrentServerDate AS ModifiedOn
			END
			ELSE
			BEGIN
				UPDATE tra_GeneratedFormDetails
				SET GeneratedFormContents = @sGeneratedFormContents_FormB_Data,
				ModifiedBy = CASE WHEN @bIsAutoApproved = 1 THEN 1 ELSE @inp_nLoggedInUserId END , 
				ModifiedOn = @dtCurrentServerDate
				WHERE TemplateMasterId = @nTemplateMasterId AND MapToTypeCodeId = @inp_nMapToTypeCodeId and MapToId = @inp_nMapToId 
			END		 
			
			SELECT @nTemplateMasterId AS TemplateMasterId, @inp_nMapToTypeCodeId AS MapToTypeCodeId, @inp_nMapToId AS MapToId, 
					   @sGeneratedFormContents_FormB_Data AS GeneratedFormContents, 
					   CASE WHEN @bIsAutoApproved = 1 THEN 1 ELSE @inp_nLoggedInUserId END AS CreatedBy, --CreatedBy will be 1 if the preclearance is auto-approved
					   @dtCurrentServerDate AS CreatedOn, 
					   CASE WHEN @bIsAutoApproved = 1 THEN 1 ELSE @inp_nLoggedInUserId END AS ModifiedBy, --ModifiedBy will be 1 if the preclearance is auto-approved
					   @dtCurrentServerDate AS ModifiedOn
		END            
		
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