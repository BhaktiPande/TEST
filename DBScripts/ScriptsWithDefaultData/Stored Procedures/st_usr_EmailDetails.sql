
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_EmailDetails')
DROP PROCEDURE [dbo].st_usr_EmailDetails
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get email properties

Returns:		0, if Success.
				
Created by:		Samadhan
Created on:		24-Oct-2019

Modification History:
Usage:
EXEC st_usr_EmailDetails 'UPSI','SELECT_EMAIL_PROPERTIES','156012',17
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE st_usr_EmailDetails
	@inp_s_Module			varchar(200) ,
	@inp_s_Flag				varchar(200),
	@inp_s_TemplateCode     INT,
	@inp_s_UniqueID			varchar(100),--COMUN FOR ALL MODULES IT MAY BE DOCUMENT ID,USERINFOID AS PER MODULE
	@out_nReturnValue		int= 0 OUTPUT,
	@out_nSQLErrCode		int= 0 OUTPUT,
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT
As
BEGIN
	---COMMON DECLARATION CODE START
	DECLARE @EmailBody VARCHAR(MAX)=null
	DECLARE @EmailSubject VARCHAR(200)=null
	DECLARE @count INT=1
	DECLARE @TotalCount INT=0
	DECLARE @nPlaceholderCount INT=0
	DECLARE @ConfigurationValueOptionalTo  VARCHAR(MAX)=null
	DECLARE @ConfigurationValueOptionalCC  VARCHAR(MAX)=null
	DECLARE @ConfigurationValueOptionalBCC  VARCHAR(MAX)=null

	DECLARE @SharedWithMail VARCHAR(MAX)
	DECLARE @TableContents VARCHAR(MAX)
	DECLARE @FinalTableRows NVARCHAR(MAX)='';
	DECLARE @TableHeaders NVARCHAR(MAX)='';
    DECLARE @TableFooters NVARCHAR(MAX)='';
	set @TableContents= '<table border="1" cellspacing="0" cellpadding="10" style="max-width: 600px;font-family:inherit;font-size:inherit;">
							<tr><th  width="100" valign="top" style="word-wrap: break-word" >Shared With Name </th><th width="100" valign="top" style="word-wrap: break-word" >Shared With Email ID</th></tr>
							<tr><td  width="100" valign="top" style="word-wrap: break-word">[SharedWithName]</td><td  width="100" valign="top" style="word-wrap: break-word"> [SharedWithEmailID] </td></tr>
						</table>';
	DECLARE	@TableRow NVARCHAR(MAX)='';
	
	SELECT @TableHeaders = SUBSTRING(@TableContents,CHARINDEX('<table',@TableContents),CHARINDEX('</tr',@TableContents)+ 4)
       
    SELECT @TableFooters ='</table>'
	
	--Table Variable declaration code start
	
	DECLARE @tblMailProperty AS TABLE ---for insert mailid's
	(
		ID int identity(1,1),
		UserInfoId int null,
		UPSIDocumentId int,
		MailID varchar(200),
		Type varchar(2)
	)
	DECLARE @tblToType AS TABLE---for insert configuration type for to mail
	(
		ID int identity(1,1),
		TypeID int
	)
	DECLARE @tblCCType AS TABLE ---for insert configuration type for CC mail
	(
		ID int identity(1,1),
		TypeID int
	)
	DECLARE  @tblPlaceholders AS TABLE
	(
		ID INT IDENTITY(1,1), 
		Placeholder NVARCHAR(512),
		PlaceholderDisplayName NVARCHAR(1000)
	)
	DECLARE  @tblFinalEmailProperties AS TABLE
	(
		ID INT IDENTITY(1,1), 
		UserInfoId int null,
		s_MailFrom VARCHAR(200),
		b_IsBodyHtml BIT,
		s_MailTo VARCHAR(200),
		s_MailCC VARCHAR(200),
		s_MailBCC  VARCHAR(200),
		s_MailSubject VARCHAR(200),
		s_MailBody  VARCHAR(MAX)
	)
	DECLARE  @tblusr_UPSIDocumentDetail AS TABLE
	(
		ID INT IDENTITY(1,1), 
		UPSIDocumentDtsId int 
		
	)
	--Table Variable declaration code close
	---COMMON DECLARATION CODE START


IF(@inp_s_Module='UPSI')
BEGIN
				
	IF(@inp_s_Flag='SELECT_EMAIL_PROPERTIES')
	BEGIN
						IF NOT EXISTS (SELECT 1 WHERE  @inp_s_UniqueID NOT LIKE '%[^0-9]%' )---IF DOCUMENT ID CONTAINS STRING THEN GET UPSIdocumentid AS PER DocumentNo AND SET TO @inp_s_UniqueID
						BEGIN
							SET @inp_s_UniqueID=(SELECT UPSIDocumentId FROM usr_UPSIDocumentMasters WHERE DocumentNo=@inp_s_UniqueID)
						END
	
					--GET TEMPLATE FROM tra_TemplateMaster
						SELECT	@EmailBody=Contents,
								@EmailSubject=Subject 
						 FROM tra_TemplateMaster 
						 WHERE CommunicationModeCodeId=@inp_s_TemplateCode--156011

						SELECT
								@ConfigurationValueOptionalTo=ConfigurationValueOptional 
						FROM com_CompanySettingConfiguration WHERE ConfigurationCodeId=180009-- configuration setting for Email Settings To

						SELECT 
								@ConfigurationValueOptionalCC=ConfigurationValueOptional 
						FROM com_CompanySettingConfiguration WHERE ConfigurationCodeId=180010 -- configuration setting for Email Settings CC

						--insert types into @tblToType
						INSERT INTO @tblToType
						SELECT * FROM (
								  SELECT [Param] AS ID FROM dbo.FN_VIGILANTE_SPLIT( @ConfigurationValueOptionalTo,',') ) Tb1  ORDER BY ID
						
						SELECT @TotalCount= count(*) FROM @tblToType

						--As per type selection for "To" section email id retrive and insert into @tblMailProperty code start
						WHILE (@count<=@TotalCount)
						BEGIN
						DECLARE @TypeID INT
							SELECT @TypeID= TypeID FROM @tblToType WHERE ID=@count
							IF(@TypeID=525001)--Updated by
							BEGIN
								INSERT INTO @tblMailProperty
								 SELECT distinct ur.UserInfoId,m.UPSIDocumentId,ur.EmailId,'TO' 
								 FROM usr_UPSIDocumentMasters m inner join usr_UserInfo ur ON m.UpdatedBy=ur.UserInfoId 
								 WHERE m.UPSIDocumentId=@inp_s_UniqueID
							END
							ELSE IF(@TypeID=525002)--Information shared with
							BEGIN
								INSERT INTO @tblMailProperty
								SELECT distinct ur.UserInfoId, m.UPSIDocumentId,d.Email ,'TO' 
								FROM usr_UPSIDocumentMasters m inner join usr_UPSIDocumentDetail d ON m.UPSIDocumentId=d.UPSIDocumentId
								LEFT join usr_UserInfo ur ON d.PAN=ur.PAN
								WHERE m.UPSIDocumentId=@inp_s_UniqueID
							END
							ELSE IF(@TypeID=525003)--Information shared by
							BEGIN
								INSERT INTO @tblMailProperty
								SELECT distinct ur.UserInfoId,m.UPSIDocumentId,ur.EmailId ,'TO'
								FROM usr_UPSIDocumentMasters m  inner join usr_UPSIDocumentDetail d ON m.UPSIDocumentId=d.UPSIDocumentId
								INNER JOIN usr_UserInfo ur ON LOWER(ur.FirstName)=LOWER(d.Sharedby) WHERE m.UPSIDocumentId=@inp_s_UniqueID
							END
							SET @count=@count+1
						END
						--As per type selection for "To" section email id retrive and insert into @tblMailProperty code close

						SET @count=1 --counter reset
						SET @TotalCount=0 --counter reset

						INSERT INTO @tblCCType
						SELECT * FROM dbo.FN_VIGILANTE_SPLIT( @ConfigurationValueOptionalCC,',')
		
						SELECT @TotalCount= count(*) FROM @tblCCType

						--As per type selection for "CC" section email id retrive and insert into @tblMailProperty code start
						WHILE (@count<=@TotalCount)
						begin
						DECLARE @TypeIDForCC INT
							SELECT @TypeIDForCC= TypeID FROM @tblCCType WHERE ID=@count
							IF(@TypeIDForCC=525001)--Updated by
							BEGIN
								
									INSERT INTO @tblMailProperty
									 SELECT null, m.UPSIDocumentId,ur.EmailId,'CC'  
									 FROM usr_UPSIDocumentMasters m inner join usr_UserInfo ur ON m.CreatedBy=ur.UserInfoId 
									 WHERE m.UPSIDocumentId=@inp_s_UniqueID
		 
							END
							ELSE IF(@TypeIDForCC=525002)--Information shared with
							BEGIN
									INSERT INTO @tblMailProperty
									SELECT null, m.UPSIDocumentId,d.Email ,'CC' FROM usr_UPSIDocumentMasters m inner join usr_UPSIDocumentDetail d ON m.UPSIDocumentId=d.UPSIDocumentId
									WHERE m.UPSIDocumentId=@inp_s_UniqueID
		
							END
							ELSE IF(@TypeIDForCC=525003)--Information shared by
							BEGIN
		
										INSERT INTO @tblMailProperty
										SELECT  null, m.UPSIDocumentId,ur.EmailId ,'CC'
										FROM usr_UPSIDocumentMasters m inner join usr_UserInfo ur ON m.CreatedBy=ur.UserInfoId WHERE m.UPSIDocumentId=@inp_s_UniqueID
		
							END
							SET @count=@count+1
						END
						--As per type selection for "CC" section email id retrive and insert into @tblMailProperty code close



						SET @count=1 --counter reset
						SET @TotalCount=(SELECT  count(*) FROM @tblMailProperty WHERE [Type]='TO' ) --counter reset
						DECLARE @CCEmailId VARCHAR(200)
						SELECT @CCEmailId  = COALESCE(@CCEmailId + ', ', '') + MailID FROM @tblMailProperty WHERE  [TYPE]='CC'


					---GET PLACEHOLDER FROM com_PlaceholderMaster AND INSERT INTO TABLE VARIABLE @tblPlaceholders

					INSERT INTO @tblPlaceholders(Placeholder, PlaceholderDisplayName)
					SELECT PlaceholderTag, PlaceholderDisplayName  FROM com_PlaceholderMaster WHERE PlaceholderGroupId = @inp_s_TemplateCode

					--get count of total placeholders strored in placeholder table
					SELECT @nPlaceholderCount = COUNT(ID) FROM @tblPlaceholders
					DECLARE @EmailBodyForEachEmail VARCHAR(MAX)

										     INSERT @tblusr_UPSIDocumentDetail
											 SELECT UPSIDocumentDtsId FROM usr_UPSIDocumentDetail d WHERE d.UPSIDocumentId=@inp_s_UniqueID 
					While(@count<=@TotalCount)
					BEGIN
						DECLARE @ToEmailId VARCHAR(200)
						DECLARE @UserInfoId VARCHAR(200)
						DECLARE @nCounter INT =1
						DECLARE @sPlaceholder VARCHAR(255)

  						SELECT @ToEmailId= MailID,@UserInfoId=UserInfoId FROM @tblMailProperty WHERE ID=@count 

						
									SET @EmailBodyForEachEmail=@EmailBody
									IF EXISTS(SELECT UPSIDocumentId FROM usr_UPSIDocumentDetail WHERE UPSIDocumentId=@inp_s_UniqueID AND Email=@ToEmailId)--IF 'TO' MAIL ID EXIST INTO DOCUMENT DETAILS OTHER WISE ELSE BLOCK WILL BE EXECUTED FOR PLACEHOLDER REPLACEMENT
									BEGIN
									 ---------REPLACE PLACE HOLDERS IN EMAIL BODY
										While(@nCounter<=@nPlaceholderCount) 
											BEGIN
												SELECT @sPlaceholder = Placeholder FROM @tblPlaceholders WHERE ID = @nCounter
							
								
												select
														@EmailBodyForEachEmail =CASE											
																				WHEN (LOWER(@sPlaceholder) = LOWER('[UPSIInformationOf]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(m.DocumentNo,' ')) 
																				WHEN (LOWER(@sPlaceholder) = LOWER('[CategoryOfInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(Category .CodeName,' ')) 
																				WHEN (LOWER(@sPlaceholder) = LOWER('[ModeOfSharingInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(c.CodeName,' ')) 
																				WHEN (LOWER(@sPlaceholder) = LOWER('[ReasonForSharingInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(cr.CodeName,' ')) 
																				WHEN (LOWER(@sPlaceholder) = LOWER('[DateOfSharingInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL( convert(varchar, SharingDate,106),' ')) 
																				WHEN (LOWER(@sPlaceholder) = LOWER('[TimeOfSharingInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(convert(char(5),SharingTime),' ')) 
																				WHEN (LOWER(@sPlaceholder) = LOWER('[SharedWithName]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(ISNULL(uf.FirstName,'')  +' '+ ISNULL(uf.MiddleName ,'') +' '+ ISNULL(uf.LastName,''),' ')) 
																				WHEN (LOWER(@sPlaceholder) = LOWER('[SharedWithEmailID]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(uf.EmailId,' ')) 
																				WHEN (LOWER(@sPlaceholder) = LOWER('[SharedByName]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(ISNULL(ub.FirstName,d.Sharedby) +' ' + ISNULL(ub.MiddleName,'') +' ' + ISNULL(ub.LastName,''),' ')) 
																				WHEN (LOWER(@sPlaceholder) = LOWER('[SharedByEmailID]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(ub.EmailId,' ')) 
																				WHEN (LOWER(@sPlaceholder) = LOWER('[NameOfTheUserWhoUpdatedThisInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(ISNULL(UsrLogedIn.FirstName,'') +' ' + ISNULL(UsrLogedIn.MiddleName,'') +' ' + ISNULL(UsrLogedIn.LastName,'') ,' ')) 
																				WHEN (LOWER(@sPlaceholder) = LOWER('[DateOfPublishing]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL( convert(varchar, m.PublishDate,106) ,' ')) 
																			  ELSE @EmailBodyForEachEmail
																			END		
												from usr_UPSIDocumentMasters m inner join usr_UPSIDocumentDetail d on m.UPSIDocumentId=d.UPSIDocumentId
													  inner join com_Code c on c.CodeID=m.ModeOfSharing
													  inner join com_Code Category  on Category .CodeID=m.Category 
													  inner join com_Code cr on cr.CodeID=m.Reason
													  inner join usr_UserInfo UsrLogedIn on UsrLogedIn.UserInfoId=m.UserInfoId
													  left join usr_UserInfo uf on d.PAN=uf.PAN
													  left join usr_UserInfo ub on ub.FirstName=d.Sharedby
													 where m.UPSIDocumentId=@inp_s_UniqueID AND D.Email=@ToEmailId

									set @EmailBodyForEachEmail= REPLACE(@EmailBodyForEachEmail, '<table>', '');
										 SET @nCounter=@nCounter+1
									 END
									 ---------REPLACE PLACE HOLDERS IN EMAIL BODY end
									END
									ELSE --other than send with email send block start
									BEGIN
											 -----REPLACE PLACE HOLDERS IN EMAIL BODY without table data
												While(@nCounter<=@nPlaceholderCount) 
												 BEGIN
														SELECT @sPlaceholder = Placeholder FROM @tblPlaceholders WHERE ID = @nCounter
													
														select 
																@EmailBodyForEachEmail =CASE											
																						WHEN (LOWER(@sPlaceholder) = LOWER('[UPSIInformationOf]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(m.DocumentNo,' ')) 
																						WHEN (LOWER(@sPlaceholder) = LOWER('[CategoryOfInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(Category .CodeName,' ')) 
																						WHEN (LOWER(@sPlaceholder) = LOWER('[ModeOfSharingInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(c.CodeName,' ')) 
																						WHEN (LOWER(@sPlaceholder) = LOWER('[ReasonForSharingInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(cr.CodeName,' ')) 
																						WHEN (LOWER(@sPlaceholder) = LOWER('[DateOfSharingInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL( convert(varchar, SharingDate,106),' ')) 
																						WHEN (LOWER(@sPlaceholder) = LOWER('[TimeOfSharingInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(convert(char(5),SharingTime),' ')) 
																						WHEN (LOWER(@sPlaceholder) = LOWER('[SharedByName]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(ISNULL(ub.FirstName,d.Sharedby) +' ' + ISNULL(ub.MiddleName,'') +' ' + ISNULL(ub.LastName,''),' ')) 
																						WHEN (LOWER(@sPlaceholder) = LOWER('[SharedByEmailID]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(ub.EmailId,' ')) 
																						WHEN (LOWER(@sPlaceholder) = LOWER('[NameOfTheUserWhoUpdatedThisInformation]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL(ISNULL(UsrLogedIn.FirstName,'') +' ' + ISNULL(UsrLogedIn.MiddleName,'') +' ' + ISNULL(UsrLogedIn.LastName,'') ,' ')) 
																						WHEN (LOWER(@sPlaceholder) = LOWER('[DateOfPublishing]')) THEN REPLACE(@EmailBodyForEachEmail, @sPlaceholder, ISNULL( convert(varchar, m.PublishDate,106) ,' ')) 
																					ELSE @EmailBodyForEachEmail
																					END		
														from usr_UPSIDocumentMasters m inner join usr_UPSIDocumentDetail d on m.UPSIDocumentId=d.UPSIDocumentId
															  inner join com_Code c on c.CodeID=m.ModeOfSharing
															  inner join com_Code Category  on Category .CodeID=m.Category 
															  inner join com_Code cr on cr.CodeID=m.Reason
															  inner join usr_UserInfo UsrLogedIn on UsrLogedIn.UserInfoId=m.UserInfoId
															  left join usr_UserInfo uf on d.PAN=uf.PAN
															  left join usr_UserInfo ub on ub.FirstName=d.Sharedby
															 where m.UPSIDocumentId=@inp_s_UniqueID

														 
													 SET @nCounter=@nCounter+1
												 END
											 -----REPLACE PLACE HOLDERS IN EMAIL BODY without table data end

											 --------code for replace table data
												 DECLARE @nCounterForPlaceholder int=1
												 DECLARE @nCounterForTableRow int=1
												 DECLARE @UPSIDocumentDtsId INT=0
												 DECLARE @TotalRowCounter INT =(SELECT COUNT(*)  FROM usr_UPSIDocumentDetail d WHERE d.UPSIDocumentId=@inp_s_UniqueID)
													While(@nCounterForTableRow <=@TotalRowCounter)
													BEGIN		

														SELECT @TableRow = SUBSTRING(@TableContents,CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1)),CHARINDEX('</tr',@TableContents,(CHARINDEX('</tr',@TableContents)+1)) - CHARINDEX('<tr',@TableContents,(CHARINDEX('<tr',@TableContents)+1))+5)
											
															 select @UPSIDocumentDtsId=UPSIDocumentDtsId from 	@tblusr_UPSIDocumentDetail where ID=@nCounterForTableRow  
															  
																While(@nCounterForPlaceholder <=@nPlaceholderCount)
																BEGIN
																	SELECT @sPlaceholder = Placeholder FROM @tblPlaceholders WHERE ID = @nCounterForPlaceholder
																			SELECT @TableRow=			CASE			
																											WHEN (LOWER(@sPlaceholder) = LOWER('[SharedWithName]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(d.Name,' ')) 
																											WHEN (LOWER(@sPlaceholder) = LOWER('[SharedWithEmailID]')) THEN REPLACE(@TableRow, @sPlaceholder, ISNULL(d.Email,' ')) 
																					
																										ELSE @TableRow
																										END	
																			FROM usr_UPSIDocumentDetail d WHERE  UPSIDocumentDtsId=@UPSIDocumentDtsId
																			 
																			SET  @nCounterForPlaceholder=@nCounterForPlaceholder+1
																END
																
																 SET @FinalTableRows = @FinalTableRows + @TableRow
															SET @nCounterForTableRow=@nCounterForTableRow+1
															set @nCounterForPlaceholder=1
													END
											 --------code for replace table data	end
									END
									
											set @EmailBodyForEachEmail= REPLACE(@EmailBodyForEachEmail, '<table>', @TableHeaders+@FinalTableRows+@TableFooters);
											
						   INSERT INTO @tblFinalEmailProperties(UserInfoId,s_MailFrom, b_IsBodyHtml ,s_MailTo ,s_MailCC,s_MailBCC ,s_MailSubject,s_MailBody)
						   VALUES(@UserInfoId,'noreply@esopdirect.com',1,@ToEmailId,@CCEmailId,'',@EmailSubject,@EmailBodyForEachEmail)
						
						SET @FinalTableRows=''
						   SET @count=@count+1

					END
						set @out_nReturnValue=0
				 --	DELETE FROM @tblFinalEmailProperties WHERE s_MailTo=s_MailCC-- delete record if To mail and cc mail id same
					SELECT * FROM @tblFinalEmailProperties
				
	END --SELECT_EMAIL_PROPERTIES IF CONDITION END
END --UPSI IF CONDITION END
END-- MAIN BIGN END
