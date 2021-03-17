IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosureGetLetterContent_OS')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosureGetLetterContent_OS]
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to get letter content to generate Form G for other security

Returns:		0, if Success.
				
Created by:		Priyanka Bhangale
Created on:		13-Aug-2019

Usage:
EXEC st_tra_PeriodEndDisclosureGetLetterContent_OS 132020,511, 558,125006,124002,558
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosureGetLetterContent_OS]
	 @inp_nMapToTypeCodeId		INT
	,@inp_nMapToId				INT	
	,@inp_iUserInfoId 	 	    NVARCHAR(1000)
	,@inp_iYearCodeId 		    NVARCHAR(1000)
	,@inp_iPeriodCodeID 		NVARCHAR(1000)
	,@inp_nLoggedInUserId		INT=0
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_PeriodEndFormGLetterContent INT = 53135
	DECLARE @dtStartDate DATETIME
	DECLARE @dtEndDate DATETIME
	DECLARE @nPeriodTypeText VARCHAR(20)
	DECLARE @nImpementCompany VARCHAR(100)
	DECLARE @nISINNo VARCHAR(50)
	DECLARE @inp_iPeriodType NVARCHAR(1000)=(SELECT ParentCodeId FROM com_Code WHERE CodeID  = @inp_iPeriodCodeID)
	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		
		DECLARE @nMapToTypeId INT = 132020	--MapToTypeId 

		DECLARE @nCommunicationModeCodeId_FormG  INT = 156010 --Form G  
		DECLARE @nCommunicationModeCodeId_FormGHideQuantity  INT = 156019
	

		DECLARE @dtCurrentServerDate DATETIME =  dbo.uf_com_GetServerDate()
		DECLARE @sGeneratedFormContents_FormG NVARCHAR(MAX) = ''
		DECLARE @sGeneratedFormContents_FormG_Final NVARCHAR(MAX)
		DECLARE @nTemplateMasterId INT
		DECLARE @nPlaceholderCount INT = 0
		DECLARE @nCounter INT = 0
		DECLARE @RowCount int=0
		DECLARE @RowCounter int=1
		DECLARE @sPlaceholder VARCHAR(255)

		DECLARE @bIsAutoApproved BIT = 0

		DECLARE @sImplementingCompanyName NVARCHAR(200) = ''
	
		DECLARE @BeforeTableContents NVARCHAR(MAX)='';
		DECLARE @AfterTableContents NVARCHAR(MAX)='';
            
		DECLARE @BeforeTableContentsData NVARCHAR(MAX)='';
		DECLARE @AfterTableContentsData NVARCHAR(MAX)='';
		DECLARE @sGeneratedFormContents_FormG_Data NVARCHAR(MAX) = ''

		DECLARE @TableContents NVARCHAR(MAX)='';
		DECLARE @TableRow NVARCHAR(MAX)='';
		DECLARE @FinalTableRows NVARCHAR(MAX)='';
		DECLARE @RecordCount INT=0;
		DECLARE @TableHeaders NVARCHAR(MAX)='';
		DECLARE @TableFooters NVARCHAR(MAX)='';
		DECLARE @FormGContents NVARCHAR(MAX) = ''
		DECLARE @EnableDisableQuantity int;
		DECLARE  @tblPlaceholders AS TABLE
		(
			ID INT IDENTITY(1,1), 
			Placeholder NVARCHAR(512),
			PlaceholderDisplayName NVARCHAR(1000)
		)
		DECLARE  @tblConstantDataContent AS TABLE
		(
			ID							INT IDENTITY(1,1), 
			FirstName					NVARCHAR(50)NULL,
			MiddleName					NVARCHAR(50)NULL,
			LastName					NVARCHAR(50)NULL,
			EmployeeId					NVARCHAR(50)NULL,
			PAN							NVARCHAR(50)NULL,
			CIN							NVARCHAR(50)NULL,
			DIN							NVARCHAR(50)NULL,
			AddressLine1				NVARCHAR(500)NULL,
			PinCode						NVARCHAR(50)NULL,
			Country						NVARCHAR(512)NULL,
			MobileNumber				NVARCHAR(512)NULL,
			Department					NVARCHAR(512)NULL,
			Designation					NVARCHAR(512)NULL,
			PeriodType					NVARCHAR(50)NULL,
			PeriodStartDate				DATETIME NULL,
			PeriodEndDate				DATETIME NULL,
			ImplementingCompanyName		NVARCHAR(200)NULL, 
			ISINNo						NVARCHAR(50)NULL
		)
		DECLARE @tblPeriodEndDisclosureSummary AS TABLE
		(
			Id					INT IDENTITY(1,1),
			UserId				INT, 
			Name				NVARCHAR(500), 
			PAN					NVARCHAR(50), 
			CIN					NVARCHAR(50), 
			DIN					NVARCHAR(50), 
			Address				NVARCHAR(500), 
			Pincode				NVARCHAR(50), 
			Country				NVARCHAR(20),
			MobileNo			NVARCHAR(50),
			EmployeeID			NVARCHAR(50), 
			Department			NVARCHAR(100), 
			Designation			NVARCHAR(100), 
			Relation			VARCHAR(500),
			DematAccountNo		NVARCHAR(50), 
			DP_ID				VARCHAR(50), 
			CompanyName			NVARCHAR(200),
			SecurityType		VARCHAR(500), 
			OpeningStock		varchar(max), 
			Bought				INT, 
			Sold				INT,
			PeriodEndHolding	varchar(max),
			TotalPledge			INT,
			Pledge				INT,
			Unpledge			INT
		)

		INSERT INTO @tblPlaceholders(Placeholder, PlaceholderDisplayName)
		SELECT PlaceholderTag, PlaceholderDisplayName  FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156010 
		--get count of total placeholders strored in placeholder table
		SELECT @nPlaceholderCount = COUNT(ID) FROM @tblPlaceholders
	 
		
		EXEC st_tra_PeriodEndDisclosureStartEndDate2 @inp_iYearCodeId, @inp_iPeriodCodeID, NULL, @inp_iPeriodType, 0,
		@dtStartDate OUTPUT, @dtEndDate OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		IF(@out_nReturnValue > 0)
		BEGIN
			RETURN @out_nReturnValue
		END
		
		SELECT @nPeriodTypeText = CodeName FROM com_Code WHERE CodeID = @inp_iPeriodType
		SELECT @nImpementCompany= CompanyName, @nISINNo = ISINNumber FROM mst_Company WHERE IsImplementing = 1

		select @EnableDisableQuantity=EnableDisableQuantityValue from mst_Company where IsImplementing=1
		
	--insert constant data of from into table variable for replacement purpose 
		INSERT INTO @tblConstantDataContent
		(
			FirstName	,			
			MiddleName	,			
			LastName	,			
			EmployeeId	,			
			PAN			,			
			CIN			,			
			DIN			,			
			AddressLine1,			
			PinCode		,			
			Country		,			
			MobileNumber,			
			Department	,			
			Designation	,			
			PeriodType	,			
			PeriodStartDate,			
			PeriodEndDate,			
			ImplementingCompanyName	,
			ISINNo					
		)
		SELECT  UI.FirstName,
				UI.MiddleName,
				UI.LastName,
				UI.EmployeeId,
				UI.PAN,
				UI.CIN,
				UI.DIN,
				UI.AddressLine1,
				UI.PinCode,
				cCountry.CodeName AS Country,
				UI.MobileNumber, 
				cDepart.CodeName AS Department,
				cDesign.CodeName AS Designation,
				@nPeriodTypeText AS PeriodType,
				@dtStartDate AS PeriodStartDate,
				@dtEndDate AS PeriodEndDate,
				@nImpementCompany AS ImplementingCompanyName,
				@nISINNo AS ISINNo 
		FROM usr_UserInfo UI
		LEFT JOIN com_Code cCountry ON cCountry.CodeID = UI.CountryId
		JOIN com_Code cDepart ON cDepart.CodeID = UI.DepartmentId
		JOIN com_Code cDesign ON cDesign.CodeID = UI.DesignationId
		WHERE UserInfoId = @inp_iUserInfoId


			IF(@inp_nMapToTypeCodeId = @nMapToTypeId) --Perform processing for generation of formatted Form G
			BEGIN
			
			IF(@EnableDisableQuantity <> 400003)	
			BEGIN
				SELECT @sGeneratedFormContents_FormG = Contents, @nTemplateMasterId = TemplateMasterId FROM tra_TemplateMaster WHERE CommunicationModeCodeId = @nCommunicationModeCodeId_FormG
			END
			ELSE
			BEGIN
				SELECT @sGeneratedFormContents_FormG = Contents, @nTemplateMasterId = TemplateMasterId FROM tra_TemplateMaster WHERE CommunicationModeCodeId = @nCommunicationModeCodeId_FormGHideQuantity
			END
				IF CHARINDEX('<table', @sGeneratedFormContents_FormG ) > 0 
				BEGIN 
				   DECLARE @FindParaBeforeTable NVARCHAR(MAX)
				   SELECT @FindParaBeforeTable= SUBSTRING(@sGeneratedFormContents_FormG,1,CHARINDEX('<table',@sGeneratedFormContents_FormG))  
			
				   SELECT @BeforeTableContents= CHARINDEX('<p',@FindParaBeforeTable,CHARINDEX('<table', @sGeneratedFormContents_FormG))
				   SELECT @BeforeTableContents=(CHARINDEX('<p',@FindParaBeforeTable))          
		       
				   IF(@BeforeTableContents>0)
				   BEGIN  
					 SELECT @BeforeTableContents = SUBSTRING(@sGeneratedFormContents_FormG,CHARINDEX('<div',@sGeneratedFormContents_FormG),CHARINDEX('<table',@sGeneratedFormContents_FormG)-5)
				 		SELECT @FormGContents=@BeforeTableContents
				 		WHILE(@nCounter < @nPlaceholderCount)
						BEGIN
			
							SELECT @nCounter = @nCounter + 1
							SELECT @sPlaceholder = Placeholder FROM @tblPlaceholders WHERE ID = @nCounter
					
						  SELECT  @FormGContents =  CASE											
														WHEN (LOWER(@sPlaceholder) = LOWER('[PERIODEND_FREQUENCY]')) THEN REPLACE(@FormGContents, @sPlaceholder, ISNULL(PeriodType,' ')) 
														WHEN (LOWER(@sPlaceholder) = LOWER('[FROM_DATEOF_PERIODEND_DISCLOSURES]')) THEN REPLACE(@FormGContents, @sPlaceholder, ISNULL(Convert(varchar,PeriodStartDate,106),' ')) 
														WHEN (LOWER(@sPlaceholder) = LOWER('[TO_DATEOF_PERIODEND_DISCLOSURES]')) THEN REPLACE(@FormGContents, @sPlaceholder, ISNULL(Convert(varchar,PeriodEndDate,106),' '))									
														WHEN (LOWER(@sPlaceholder) = LOWER('[DATEOF_SUBMISSION]')) THEN REPLACE(@FormGContents, @sPlaceholder,ISNULL(convert(varchar,GETDATE(),106),' ')) 
														WHEN (LOWER(@sPlaceholder) = LOWER('[NAMEOF_COMPLIANCE_OFFICER]')) THEN REPLACE(@FormGContents, @sPlaceholder,'') 
														WHEN (LOWER(@sPlaceholder) = LOWER('[NAMEOF_IMPLEMENTING_COMPANY]')) THEN REPLACE(@FormGContents, @sPlaceholder,ISNULL(ImplementingCompanyName,' ')) 
														WHEN (LOWER(@sPlaceholder) = LOWER('[ISIN_NUMBER]')) THEN REPLACE(@FormGContents, @sPlaceholder,ISNULL(ISINNo,'-')) 
														WHEN (LOWER(@sPlaceholder) = LOWER('[EMPLOYEE_NAME]')) THEN REPLACE(@FormGContents, @sPlaceholder,ISNULL(FirstName,'-')+' ' +ISNULL(MiddleName,'-')+' ' +ISNULL(LastName,'-'))
														WHEN (LOWER(@sPlaceholder) = LOWER('[EMPLOYEE_CODE]')) THEN REPLACE(@FormGContents, @sPlaceholder,ISNULL(EmployeeId,'-'))
														WHEN (LOWER(@sPlaceholder) = LOWER('[DEPARTMENT]')) THEN REPLACE(@FormGContents, @sPlaceholder,ISNULL(Department,'-'))
														WHEN (LOWER(@sPlaceholder) = LOWER('[DESIGNATION]')) THEN REPLACE(@FormGContents, @sPlaceholder,ISNULL(Designation,'-'))
													  ELSE @FormGContents
													END										
						
							 FROM 	@tblConstantDataContent
			  
				
						END	
					   SET @BeforeTableContentsData = @FormGContents
					
				   END
				 
				 SELECT @AfterTableContents = SUBSTRING(@sGeneratedFormContents_FormG,CHARINDEX('</table',@sGeneratedFormContents_FormG)+8,99999)
				 SET @nCounter=0;
				 SET @FormGContents=''
				 SET @FormGContents=@AfterTableContents
				
				  		WHILE(@nCounter < @nPlaceholderCount)
						BEGIN
			
							SELECT @nCounter = @nCounter + 1
							SELECT @sPlaceholder = Placeholder FROM @tblPlaceholders WHERE ID = @nCounter
					
						  SELECT  @FormGContents =  CASE											
														WHEN (LOWER(@sPlaceholder) = LOWER('[CONFIGURABLE_TEXT]')) THEN REPLACE(@FormGContents, @sPlaceholder, Isnull((select ResourceValue from mst_Resource where ResourceKey='dis_msg_54174') ,'')) 
														WHEN (LOWER(@sPlaceholder) = LOWER('[EMPLOYEE_NAME]')) THEN REPLACE(@FormGContents, @sPlaceholder,ISNULL(FirstName,'-')+' ' +ISNULL(MiddleName,'-')+' ' +ISNULL(LastName,'-'))
														WHEN (LOWER(@sPlaceholder) = LOWER('[EMPLOYEE_CODE]')) THEN REPLACE(@FormGContents, @sPlaceholder,ISNULL(EmployeeId,'-'))
														WHEN (LOWER(@sPlaceholder) = LOWER('[DESIGNATION]')) THEN REPLACE(@FormGContents, @sPlaceholder,ISNULL(Designation,'-'))
														WHEN (LOWER(@sPlaceholder) = LOWER('[DEPARTMENT]')) THEN REPLACE(@FormGContents, @sPlaceholder,ISNULL(Department,'-'))
													  ELSE @FormGContents
													END										
						
							 FROM 	@tblConstantDataContent
			 
				
						END	
				 SET @AfterTableContentsData = @FormGContents
				
				END
				 
			
			
				
           SELECT @TableContents = SUBSTRING(@sGeneratedFormContents_FormG,CHARINDEX('<table',@sGeneratedFormContents_FormG),CHARINDEX('</table',@sGeneratedFormContents_FormG)-CHARINDEX('<table',@sGeneratedFormContents_FormG)+8)
          --PRINT @TableContents

           SELECT @TableRow = SUBSTRING(@TableContents,CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1)),CHARINDEX('</tr',@TableContents,(CHARINDEX('</tr',@TableContents)+1)) - CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1))+5)
          --PRINT @TableRow
                      
           SELECT @TableHeaders = SUBSTRING(@TableContents,CHARINDEX('<table',@TableContents),CHARINDEX('</tr',@TableContents)+ 4)
           --PRINT @TableHeaders
                    
           SELECT @TableFooters = SUBSTRING(@TableContents,CHARINDEX('</tbody',@TableContents),CHARINDEX('</table',@TableContents))
		--Get user transaction details
			INSERT INTO @tblPeriodEndDisclosureSummary
		(
			UserId	,		
			Name	,		
			PAN		,		
			CIN		,		
			DIN		,		
			Address	,		
			Pincode	,		
			Country	,		
			MobileNo	,	
			EmployeeID	,	
			Department	,	
			Designation	,	
			Relation		,
			DematAccountNo	,
			DP_ID			,
			CompanyName		,
			SecurityType	,
			OpeningStock	,
			Bought			,
			Sold			,
			PeriodEndHolding,
			TotalPledge		,
			Pledge			,
			Unpledge	
		)
		EXEC st_tra_PeriodEndDisclosureTransactionDetailsFormG_OS @inp_iUserInfoId,@inp_iYearCodeId,@inp_iPeriodCodeID,
			@out_nReturnValue = @out_nReturnValue OUTPUT, @out_nSQLErrCode = @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage = @out_sSQLErrMessage OUTPUT
    
			delete  from   @tblPeriodEndDisclosureSummary  where OpeningStock=0 and Bought=0 and Sold=0 and PeriodEndHolding=0
				
			SELECT @RowCount = COUNT(Id) from @tblPeriodEndDisclosureSummary			
			declare @ID int=0
			
			WHILE(@RowCounter <= @RowCount)
			BEGIN
			
				  SET @nCounter = 1;
				  SELECT @TableRow = SUBSTRING(@TableContents,CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1)),CHARINDEX('</tr',@TableContents,(CHARINDEX('</tr',@TableContents)+1)) - CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1))+5)
				  
				  SELECT @ID = Id from @tblPeriodEndDisclosureSummary WHERE ID = @RowCounter	
					
							WHILE(@nCounter <= @nPlaceholderCount)
							BEGIN		
            					SELECT @sPlaceholder = Placeholder FROM @tblPlaceholders WHERE ID = @nCounter
										IF(@EnableDisableQuantity <> 400003)
										BEGIN
										SELECT 
												@TableRow = CASE 
															WHEN (LOWER(@sPlaceholder) = LOWER('[NAME]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(Name,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[PAN]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(PAN,' ')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[CIN]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(CIN,' ')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[DIN]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(DIN,' ')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[ADDRESS]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(ADDRESS,'Self')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[SUB_CATEGORYOF_PERSONS]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(Relation,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[DEMAT_ACCOUNT_NUMBER]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(DematAccountNo,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[SECURITY_TYPE]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(SecurityType,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[NAMEOF_TRADING_COMPANY]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(CompanyName,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[HOLDINGON_FROM_DATE]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL( OpeningStock,'0')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[BOUGHT_DURING_PERIOD]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(Bought,'-'))
															WHEN (LOWER(@sPlaceholder) = LOWER('[SOLD_DURING_PERIOD]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(Sold,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[HOLDINGON_TO_DATE]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(PeriodEndHolding,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[SECURITIES_PLEDGED_DURINGTHE_PERIOD]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(Pledge,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[SECURITIES_UNPLEDGED_DURINGTHE_PERIOD]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(Unpledge,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[SECURITIES_PLEDGED_AT_THE_END_OFTHE_PERIOD]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(TotalPledge,'-'))
															else @TableRow 
					 					END FROM  @tblPeriodEndDisclosureSummary WHERE Id=@ID
										END
										ELSE
										BEGIN
										
											SELECT 
												@TableRow = CASE 
															WHEN (LOWER(@sPlaceholder) = LOWER('[NAME]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(Name,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[PAN]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(PAN,' ')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[CIN]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(CIN,' ')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[DIN]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(DIN,' ')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[ADDRESS]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(ADDRESS,'Self')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[SUB_CATEGORYOF_PERSONS]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(Relation,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[DEMAT_ACCOUNT_NUMBER]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(DematAccountNo,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[SECURITY_TYPE]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(SecurityType,'-')) 
															WHEN (LOWER(@sPlaceholder) = LOWER('[NAMEOF_TRADING_COMPANY]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(CompanyName,'-')) 
															--WHEN (LOWER(@sPlaceholder) = LOWER('[HOLDINGON_FROM_DATE]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL( OpeningStock,'0')) 
															--WHEN (LOWER(@sPlaceholder) = LOWER('[BOUGHT_DURING_PERIOD]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(Bought,'-'))
															--WHEN (LOWER(@sPlaceholder) = LOWER('[SOLD_DURING_PERIOD]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(Sold,'-')) 
															--WHEN (LOWER(@sPlaceholder) = LOWER('[HOLDINGON_TO_DATE]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(PeriodEndHolding,'-')) 
															--WHEN (LOWER(@sPlaceholder) = LOWER('[SECURITIES_PLEDGED_DURINGTHE_PERIOD]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(Pledge,'-')) 
															--WHEN (LOWER(@sPlaceholder) = LOWER('[SECURITIES_UNPLEDGED_DURINGTHE_PERIOD]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(Unpledge,'-')) 
															--WHEN (LOWER(@sPlaceholder) = LOWER('[SECURITIES_PLEDGED_AT_THE_END_OFTHE_PERIOD]')) THEN REPLACE(@TableRow, @sPlaceholder,ISNULL(TotalPledge,'-'))
															else @TableRow 
					 					END FROM  @tblPeriodEndDisclosureSummary WHERE Id=@ID
										END
								 set @nCounter = @nCounter +1					
							END 	
			
		   		   SET @FinalTableRows = @FinalTableRows + @TableRow	   	
		   	  	
				   SET @RowCounter = @RowCounter + 1			   
			END	
		
			IF(@RowCounter=1)-- if record not found 
			BEGIN
			
			IF(@EnableDisableQuantity <> 400003)
			BEGIN
			SET @TableContents='<table border="1" cellspacing="0" cellpadding="6" style="max-width: 600px;font-family:inherit;font-size:inherit;">
									<tbody>
										<tr height="100">
											<td   style="word-wrap: break-word;width=80;valign:top"><b>Name, PAN,<br /> CIN/DIN, Address  </b></td>
											<td   style="word-wrap: break-word;width=50;valign:top"><b>Category of Person<br /> (Promoter/ KMP/Director/<br /> Immediate relative to etc) </b></td>
											<td   style="word-wrap: break-word;width=50;valign:top"><b>Demat<br /> Account<br /> Number </b></td>
											<td   style="word-wrap: break-word;width=50;valign:top"><b>Type of Security </b></td>
											<td   style="word-wrap: break-word;width=50;valign:top"><b>Name of company </b></td>
											<td   style="word-wrap: break-word;width=30;valign:top"><b>Holding at the <br />beginning <br />of the <br />period </b></td>
											<td   style="word-wrap: break-word;width=30;valign:top"><b>No. of <br />securities <br />purchased <br />during <br />the period </b></td>
											<td   style="word-wrap: break-word;width=30;valign:top"><b>No. of <br />securities <br />sold <br />during <br />the period </b></td>
											<td   style="word-wrap: break-word;width=30;valign:top"><b>No. of <br />securities <br />at the end<br /> of the period </b></td>
											<td   style="word-wrap: break-word;width=25;valign:top"><b>No. of <br />securities <br />pledged <br />during<br /> the period </b></td>
											<td   style="word-wrap: break-word;width=25;valign:top"><b>No. of <br />securities <br />unpledged <br />during<br /> the period </b></td>
											<td   style="word-wrap: break-word;width=25;valign:top"><b>No. of <br />securities <br />pledged at the end <br />of the period </b></td>
										</tr>
										<tr height="50">
											 <td colspan="12" style="word-wrap: break-word;width=25;valign:middle;text-align:center"> [Message] </td>
										 </tr>
									</tbody>
								</table>'
			END
			ELSE
			BEGIN
			SET @TableContents='<table border="1" cellspacing="0" cellpadding="6" style="max-width: 600px;font-family:inherit;font-size:inherit;">
									<tbody>
										<tr height="100">
											<td   style="word-wrap: break-word;width=80;valign:top"><b>Name, PAN,<br /> CIN/DIN, Address  </b></td>
											<td   style="word-wrap: break-word;width=50;valign:top"><b>Category of Person<br /> (Promoter/ KMP/Director/<br /> Immediate relative to etc) </b></td>
											<td   style="word-wrap: break-word;width=50;valign:top"><b>Demat<br /> Account<br /> Number </b></td>
											<td   style="word-wrap: break-word;width=50;valign:top"><b>Type of Security </b></td>
											<td   style="word-wrap: break-word;width=50;valign:top"><b>Name of company </b></td>
											
										</tr>
										<tr height="50">
											 <td colspan="12" style="word-wrap: break-word;width=25;valign:middle;text-align:center"> [Message] </td>
										 </tr>
									</tbody>
								</table>'
						END
			 		  SELECT @TableHeaders = SUBSTRING(@TableContents,CHARINDEX('<table',@TableContents),CHARINDEX('</tr',@TableContents)+ 4)
				      SELECT @TableRow = SUBSTRING(@TableContents,CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1)),CHARINDEX('</tr',@TableContents,(CHARINDEX('</tr',@TableContents)+1)) - CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1))+5)
            		  SET @TableRow= REPLACE(@TableRow, '[Message]',(SELECT ResourceValue FROM mst_Resource WHERE ResourceKey='dis_msg_54175')) 
					  SET @FinalTableRows = @FinalTableRows + @TableRow	   	
							
							  
			END

		  SET @sGeneratedFormContents_FormG_Data = @BeforeTableContentsData + @TableHeaders + @FinalTableRows + @TableFooters + @AfterTableContentsData	
	
			
			--print @sGeneratedFormContents_FormG_Data
			----------------For Save Generated Form B-------------
			IF NOT EXISTS (SELECT GeneratedFormDetailsId FROM tra_GeneratedFormDetails WHERE TemplateMasterId = @nTemplateMasterId AND MapToTypeCodeId = @inp_nMapToTypeCodeId and MapToId = @inp_nMapToId)
			BEGIN
				--print @sGeneratedFormContents_FormG_Data

			    INSERT INTO tra_GeneratedFormDetails(TemplateMasterId, MapToTypeCodeId, MapToId, GeneratedFormContents, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
				SELECT @nTemplateMasterId AS TemplateMasterId, @inp_nMapToTypeCodeId AS MapToTypeCodeId, @inp_nMapToId AS MapToId, 
					   @sGeneratedFormContents_FormG_Data AS GeneratedFormContents, 
					   CASE WHEN @bIsAutoApproved = 1 THEN 1 ELSE @inp_nLoggedInUserId END AS CreatedBy, --CreatedBy will be 1 if the preclearance is auto-approved
					   @dtCurrentServerDate AS CreatedOn, 
					   CASE WHEN @bIsAutoApproved = 1 THEN 1 ELSE @inp_nLoggedInUserId END AS ModifiedBy, --ModifiedBy will be 1 if the preclearance is auto-approved
					   @dtCurrentServerDate AS ModifiedOn

			END
			ELSE
			BEGIN
				UPDATE tra_GeneratedFormDetails
				SET GeneratedFormContents = @sGeneratedFormContents_FormG_Data,
				ModifiedBy = CASE WHEN @bIsAutoApproved = 1 THEN 1 ELSE @inp_nLoggedInUserId END , 
				ModifiedOn = @dtCurrentServerDate
				WHERE TemplateMasterId = @nTemplateMasterId AND MapToTypeCodeId = @inp_nMapToTypeCodeId and MapToId = @inp_nMapToId 
			END	
			
			SELECT @nTemplateMasterId AS TemplateMasterId, @inp_nMapToTypeCodeId AS MapToTypeCodeId, @inp_nMapToId AS MapToId, 
					   @sGeneratedFormContents_FormG_Data AS GeneratedFormContents, 
					   CASE WHEN @bIsAutoApproved = 1 THEN 1 ELSE @inp_nLoggedInUserId END AS CreatedBy, --CreatedBy will be 1 if the preclearance is auto-approved
					   @dtCurrentServerDate AS CreatedOn, 
					   CASE WHEN @bIsAutoApproved = 1 THEN 1 ELSE @inp_nLoggedInUserId END AS ModifiedBy, --ModifiedBy will be 1 if the preclearance is auto-approved
					   @dtCurrentServerDate AS ModifiedOn
				
				
				

		END

	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PeriodEndFormGLetterContent
	END CATCH
END