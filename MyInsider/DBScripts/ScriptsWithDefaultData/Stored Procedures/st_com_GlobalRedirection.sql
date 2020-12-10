IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_GlobalRedirection')
DROP PROCEDURE [dbo].[st_com_GlobalRedirection]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:  Procedure For handling the redirection at global level.

Returns:             0, if Success.
                           
Created by:          Swapnil
Created on:          03-Sept-2015

Modification History:
Modified By          Modified On          Description
Swapnil M            9-Sept-2015          Removed DateOfBecomingInsider condition.
Parag                16-Sep-2015          Made change to add condition before initial disclosure check to check if user has confirm persoanl details or not 
Parag                23-Sep-2015          Change to use proper acid for each type of user when check for personal details confirmation
Raghvendra           31-Oct-2015          Change to not check filter condition if called from initial disclosure screen
Raghvendra           3-Nov-2015           Fix for checking the initial disclosures completion condition only after the personal details filter is confirmed.
Arundhati            4-Nov-2015           While assigning to variable @sPolicyDocument, string + Int was taken, which was giving conversion fail error
Usage:
EXEC st_com_GlobalRedirection '',,
****************************************************************************************************
Redirect To (Returns as a Value of @out_nRedirectionType)
Number - Description.
----------------------
1 - Redirect to Insider Initial Disclosure as It is not disclosed by logged in user
2 - Redirect to Accept new policy if applciable to logged in user and Initial Disclosure is submitted.
3 - Redirect to Insider personal details page (employee and non-employee)
4 - Redirect to Insider personal details page (corporate)
----------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_GlobalRedirection]
       @inp_sControllerAction            VARCHAR(250),                     -- Initial check called from.
       @inp_iUserInfoId                  INT,                                     -- USer Info ID.
       @out_nReturnValue                 INT = 0 OUTPUT,                          -- Output Error number, if Error occured.
       @out_nSQLErrCode                  INT = 0 OUTPUT,                          -- Output SQL Error Number, if error occurred.
       @out_sSQLErrMessage               VARCHAR(500) = '' OUTPUT   -- Output SQL Error Message, if error occurred.
AS
BEGIN
--------------------------------------------------------------------------------
DECLARE 
              @RedirectToInitialDisclosurePage         INT = 1,
              @RedirectToPolicyDisplayPage                    INT = 2,
              @RedirectTo_emp_Personal_Details_Page    INT = 3,
              @RedirectTo_Cor_Personal_Details_Page    INT = 4,
              @RedirectTo_nonemp_Personal_details_page INT = 5,
              @RedirectTo_Change_Password_Page        INT = 6,
              @RedirectTo_EULAAcceptance_Page          INT = 8,
              @RedirectTo_MCQ_Page                            INT=9, 
              @RedirectToInitialDisclosurePage_Redirect INT = 1
---------------------------------------------------------------------------------

       DECLARE @MapToTypePolicyDocument                INT = 132001
       DECLARE @EventInitialDisclosureEntered          INT = 153035

       
       DECLARE @POLICYDOCUMENTACTIVE                          INT = 131002
       DECLARE @DISCLOSURETRANSACTION                         INT = 132005
       DECLARE @CountForFinalResultTable               INT = 0       
       DECLARE @USERTYPE                                             INT
       DECLARE @PolicyDocumentViewed                          INT = 153027
       DECLARE @PolicyDocumentAgreed                          INT = 153028
       DECLARE @USERTYPE_ADMIN                                       INT = 101001,
                     @USERTYPE_COUSER                                INT = 101002,
                     @USERTYPE_EMPLOYEE                              INT = 101003,
                     @USERTYPE_CORPORATEUSER                         INT = 101004,
                     @USERTYPE_SUPERADMIN                     INT = 101005,
                     @USERTYPE_NONEMPLOYEE                           INT = 101006
                     
       DECLARE @nConfirm_Personal_Details_Event INT = 153043
       DECLARE @INITIALDISCLOSURECONTROLLERACTION VARCHAR(50) = 'InsiderInitialDisclosureIndex'
       DECLARE @MapToTypeChangePassword                INT = 132019
       DECLARE @nPasswordValidity INT
       DECLARE @nExpiryDate     DATETIME

       DECLARE @nOccurrenceYearly                                                        INT = 137001
       DECLARE @nOccurrenceQuarterly                                                     INT = 137002
       DECLARE @nOccurrenceMonthly                                                       INT = 137003
       DECLARE @nOccurrenceHalfYearly                                                 INT = 137004

       DECLARE @nPPDConfirmed_Date                                 DATETIME = NULL
       DECLARE @Next_PPDConfirmation_Date                          DATETIME = NULL
       DECLARE @nCurrentDateTime                                   DATETIME = NULL
       DECLARE @nReconfirmationDate                                     DATETIME = NULL
       DECLARE @nPPDConfirmationFrequency                          INT = 0

       DECLARE @nRequiredModuleID                                  INT = 0
       DECLARE @EventInitialDisclosureEntered_OS                   INT = 153056
       DECLARE @nGetTradingPolicyId_OS                                  INT = 0

       DECLARE @nRequiredModule_OWN                                  INT = 513001
       DECLARE @nRequiredModule_OS                                   INT = 513002
       DECLARE @nRequiredModule_BOTH                                    INT = 513003

       DECLARE @nConfigurationType_EULAAcceptance                  INT
       DECLARE @nConfigurationType_RequiredConfirmation            INT
       DECLARE @nConfigurationType_MCQRequired                                    INT

       DECLARE @nMapToTypeCodeID                                   INT = 132021  
       DECLARE @nMapToID                                           INT = 1 
       DECLARE @nDocumentID                                        INT

       
       BEGIN TRY            
              SELECT @USERTYPE = u.UserTypeCodeId FROM usr_UserInfo u WHERE u.UserInfoId = @inp_iUserInfoId
              
              IF(@USERTYPE = @USERTYPE_EMPLOYEE OR @USERTYPE = @USERTYPE_CORPORATEUSER OR @USERTYPE = @USERTYPE_NONEMPLOYEE)
              BEGIN
                     
                     IF(EXISTS(SELECT ID FROM com_GlobalRedirectionControllerActionPair WHERE ControllerActionName = @inp_sControllerAction))
                     BEGIN
                           -- before checking initial disclosure first check if user has confirm personal details or not
                           -- If personal details are confirm then continue with check for initial disclosure and policy document accepted or not 
                           -- else redirect user to personal details page
                           SELECT @nPasswordValidity = PassValidity FROM usr_PasswordConfig
                                         SELECT @nExpiryDate = DATEADD(DAY, @nPasswordValidity, (SELECT ModifiedOn FROM usr_authentication WHERE userinfoid=@inp_iUserInfoId))
                           
                           --SELECT FrequencyOfMCQ FROM MCQ_MasterSettings

                           
                           SELECT @nConfigurationType_EULAAcceptance = ConfigurationValueCodeId FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180005
                           SELECT @nConfigurationType_RequiredConfirmation = ConfigurationValueCodeId, @nDocumentID = ConfigurationValueOptional FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId = 180006
                           SELECT @nConfigurationType_MCQRequired=IsMCQRequired FROM mst_Company where CompanyId=1
                           
						   -----------------This setting is used for MCQ
                           IF(@nConfigurationType_MCQRequired = 521001 and @USERTYPE=101003)
                           BEGIN

                                  DECLARE @nCheckUserStatus INT
                                  DECLARE @dPeriodEndDate DATETIME
                                  DECLARE @dFrequencyDate DATETIME
                                  DECLARE @dCurrentDate DATETIME=dbo.uf_com_GetServerDate()
								  DECLARE @dFrequencySavedDate DATETIME

                                  SELECT @dFrequencyDate=FrequencyDate FROM [dbo].[MCQ_MasterSettings]

                                  SELECT @nCheckUserStatus=MCQStatus, @dPeriodEndDate=MCQPerioEndDate , @dFrequencySavedDate=ISNULL(FrequencyDate,' ') FROM MCQ_CheckUsrStatus WHERE UserInfoId=@inp_iUserInfoId
                                  
                                  IF(@dPeriodEndDate IS NOT NULL)
								  BEGIN
									  IF(@nCheckUserStatus=1 AND @dCurrentDate>@dPeriodEndDate)
									  BEGIN
											 UPDATE MCQ_CheckUsrStatus SET MCQStatus=0 WHERE UserInfoId=@inp_iUserInfoId 
									  END
								  END
								  IF(@dFrequencyDate IS NOT NULL)
								  BEGIN
									  IF(@nCheckUserStatus=1 AND @dFrequencySavedDate<>@dFrequencyDate AND @dCurrentDate>=@dFrequencyDate)
									  BEGIN
											 UPDATE MCQ_CheckUsrStatus SET MCQStatus=0 WHERE UserInfoId=@inp_iUserInfoId 
									  END
								  END
                              END


						  IF(@nExpiryDate<GETDATE())
                           BEGIN                      
                                  SELECT Controller,Action,Parameter as Parameter FROM com_GlobalRedirectToURL g WHERE g.ID = @RedirectTo_Change_Password_Page
                           END
                           ELSE IF @nConfigurationType_EULAAcceptance = 186001 AND NOT EXISTS(SELECT EULAReportID FROM rpt_EULAAcceptanceReport WHERE UserInfoID = @inp_iUserInfoId)
                           BEGIN                                     
                                  IF @nConfigurationType_RequiredConfirmation = 523001
                                  BEGIN                      
                                         SELECT Controller,Action,Parameter+ ',DocumentID,'+ CONVERT(VARCHAR, @nDocumentID) as Parameter FROM com_GlobalRedirectToURL WHERE ID = @RedirectTo_EULAAcceptance_Page
                                  END
                                  ELSE IF @nConfigurationType_RequiredConfirmation = 523002
                                  BEGIN                      
                                         SELECT Controller,Action,Parameter+ ',DocumentID,'+ CONVERT(VARCHAR, @nDocumentID) as Parameter FROM com_GlobalRedirectToURL WHERE ID = @RedirectTo_EULAAcceptance_Page
                                  END
                           END
                           ELSE IF @nConfigurationType_EULAAcceptance = 186001 AND EXISTS(SELECT EULAReportID FROM rpt_EULAAcceptanceReport WHERE UserInfoID = @inp_iUserInfoId) 
                                  AND @nDocumentID <> (SELECT top 1 DocumentID FROM rpt_EULAAcceptanceReport WHERE UserInfoID = @inp_iUserInfoId order by DocumentID desc) AND @nConfigurationType_RequiredConfirmation = 523001
                           BEGIN                                          
                                  SELECT Controller,Action,Parameter+ ',DocumentID,'+ CONVERT(VARCHAR, @nDocumentID) as Parameter FROM com_GlobalRedirectToURL WHERE ID = @RedirectTo_EULAAcceptance_Page
                           END                           
                           
                           ELSE IF (@nConfigurationType_MCQRequired = 521001 and @USERTYPE=101003 and NOT EXISTS(select * from MCQ_CheckUsrStatus where UserInfoId=@inp_iUserInfoId and MCQStatus=1 ))    ---MCQ Required and @USERTYPE =101003, @nConfigurationType_EULAAcceptance 'Yes'
                           BEGIN                     
                                   SELECT Controller,Action,Parameter FROM com_GlobalRedirectToURL WHERE ID = @RedirectTo_MCQ_Page  
                                  
                           END --mcq end              
                           
                           ELSE
                           BEGIN
                           
                                  IF(NOT EXISTS(SELECT * FROM eve_EventLog WHERE EventCodeId = @nConfirm_Personal_Details_Event AND UserInfoId = @inp_iUserInfoId))
                                  BEGIN
                                  -- Redirect to personal details page base on user type
                                         IF (@USERTYPE = @USERTYPE_CORPORATEUSER)
                                         BEGIN
                                                SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_Cor_Personal_Details_Page
                                         END
                                         ELSE IF (@USERTYPE = @USERTYPE_NONEMPLOYEE)
                                         BEGIN
                                                SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_nonemp_Personal_details_page
                                         END
                                         ELSE
                                         BEGIN
                                                SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_emp_Personal_Details_Page
                                         END
                                  END
                                  ELSE
                                  BEGIN        
                                  -----------------Reconfirmation Block-----------------------------------------------------------------------------------------------
                                         IF EXISTS(SELECT UserInfoId FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoId AND EventCodeId = @nConfirm_Personal_Details_Event)
                                         BEGIN
                                                IF EXISTS(SELECT ReConfirmationFreqId FROM com_PersonalDetailsConfirmation WHERE ReConfirmationFreqId != 0)
                                                BEGIN
                                                       SELECT @nPPDConfirmationFrequency = ReConfirmationFreqId FROM com_PersonalDetailsConfirmation 
                                                       SELECT @nCurrentDateTime = GETDATE() 
                                                       SELECT @nPPDConfirmed_Date = EventDate FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoId AND EventCodeId = @nConfirm_Personal_Details_Event
                                                       --NOVIT
                                                       IF @nPPDConfirmationFrequency = @nOccurrenceYearly
                                                       BEGIN
                                                             select @nReconfirmationDate = REConfirmationDate from usr_Reconfirmmation where UserInfoID = @inp_iUserInfoId and EntryFlag = 1
                                                              IF(@nReconfirmationDate < @nCurrentDateTime)
                                                              BEGIN
                                                              IF (@USERTYPE = @USERTYPE_CORPORATEUSER)
                                                                           BEGIN
                                                                                  SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_Cor_Personal_Details_Page
                                                                           END
                                                                           ELSE IF (@USERTYPE = @USERTYPE_NONEMPLOYEE)
                                                                           BEGIN
                                                                                  SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_nonemp_Personal_details_page
                                                                           END
                                                                           ELSE                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                                                                           BEGIN
                                                                                  SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_emp_Personal_Details_Page
                                                                           END
                                                             END    
                                                       END
                                         IF @nPPDConfirmationFrequency = @nOccurrenceQuarterly
                                  BEGIN
                                          select @nReconfirmationDate = REConfirmationDate from usr_Reconfirmmation where UserInfoID = @inp_iUserInfoId and EntryFlag = 1
                                                IF(@nReconfirmationDate < @nCurrentDateTime)
                                          BEGIN
                                            --  DELETE FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoId AND EventCodeId = @nConfirm_Personal_Details_Event

                                                       IF (@USERTYPE = @USERTYPE_CORPORATEUSER)
                                                       BEGIN
                                                              SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_Cor_Personal_Details_Page
                                                       END
                                                       ELSE IF (@USERTYPE = @USERTYPE_NONEMPLOYEE)
                                                       BEGIN
                                                              SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_nonemp_Personal_details_page
                                                       END
                                                       ELSE
                                                       BEGIN
                                                              SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_emp_Personal_Details_Page
                                                       END
                                          END
                                      END

                                         IF @nPPDConfirmationFrequency = @nOccurrenceMonthly
                                      BEGIN
                                           select @nReconfirmationDate = REConfirmationDate from usr_Reconfirmmation where UserInfoID = @inp_iUserInfoId and EntryFlag = 1
                                                IF(@nReconfirmationDate < @nCurrentDateTime)
                                           BEGIN
                                             -- DELETE FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoId AND EventCodeId = @nConfirm_Personal_Details_Event

                                                       IF (@USERTYPE = @USERTYPE_CORPORATEUSER)
                                                       BEGIN
                                                              SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_Cor_Personal_Details_Page
                                                       END
                                                       ELSE IF (@USERTYPE = @USERTYPE_NONEMPLOYEE)
                                                       BEGIN
                                                              SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_nonemp_Personal_details_page
                                                       END
                                                       ELSE
                                                       BEGIN
                                                              SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_emp_Personal_Details_Page
                                                       END
                                          END
                                     END

                                                       IF @nPPDConfirmationFrequency = @nOccurrenceHalfYearly
                                                       BEGIN
                                                       select @nReconfirmationDate = REConfirmationDate from usr_Reconfirmmation where UserInfoID = @inp_iUserInfoId and EntryFlag = 1
                                                     IF(@nReconfirmationDate < @nCurrentDateTime)
                                                              BEGIN
                                                                     --DELETE FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoId AND EventCodeId = @nConfirm_Personal_Details_Event

                                                                     IF (@USERTYPE = @USERTYPE_CORPORATEUSER)
                                                                     BEGIN
                                                                           SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_Cor_Personal_Details_Page
                                                                     END
                                                                     ELSE IF (@USERTYPE = @USERTYPE_NONEMPLOYEE)
                                                                     BEGIN
                                                                           SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_nonemp_Personal_details_page
                                                                     END
                                                                     ELSE
                                                                     BEGIN
                                                                           SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_emp_Personal_Details_Page
                                                                     END
                                                              END
                                                       END
                                                END
                                         END           
                                      IF EXISTS(SELECT RequiredModule FROM mst_Company WHERE IsImplementing = 1)
                                      BEGIN                                       
                                                CREATE TABLE #GetTradingPolicyId_OS (nGetTradingPolicyId_OS INT)
                                                INSERT INTO #GetTradingPolicyId_OS EXEC st_tra_GetTradingPolicyIDfor_OS @inp_iUserInfoId
                                                SET @nGetTradingPolicyId_OS = (SELECT nGetTradingPolicyId_OS FROM #GetTradingPolicyId_OS)

                                                SELECT @nRequiredModuleID = RequiredModule FROM mst_Company WHERE IsImplementing = 1

                                                IF(@nRequiredModuleID = @nRequiredModule_OWN)
                                                BEGIN
                                                       IF(NOT EXISTS(SELECT EventLogId FROM eve_EventLog WHERE EventCodeId = @EventInitialDisclosureEntered and UserInfoId = @inp_iUserInfoId AND MapToTypeCodeId = @DISCLOSURETRANSACTION ))
                                                       BEGIN
                                                              DECLARE @RedirectionResult_OS_OWN TABLE (SequenceNumber INT IDENTITY(1,1),ReqModuleId INT,UserInfoId INT)
                                                                     
                                                              INSERT INTO @RedirectionResult_OS_OWN(ReqModuleId,UserInfoId)
                                                              SELECT       comp.RequiredModule,@inp_iUserInfoId
                                                              FROM mst_Company comp             
                                                                           
                                                              DECLARE @sRedirect_OS_OWN VARCHAR(100) 
                                                              SELECT TOP 1 @sRedirect_OS_OWN = ',ReqModuleId,' + CONVERT(VARCHAR(15), ReqModuleId) + ',UserInfoId,' + CONVERT(VARCHAR(15), UserInfoId) FROM @RedirectionResult_OS_OWN 
                                                              SELECT Controller,Action,Parameter + @sRedirect_OS_OWN as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectToInitialDisclosurePage_Redirect
                                                       END
                                                END                               
                                                ELSE IF(@nRequiredModuleID = @nRequiredModule_OS)
                                                BEGIN
                                                       IF(NOT EXISTS(SELECT EventLogId FROM eve_EventLog WHERE EventCodeId = @EventInitialDisclosureEntered_OS and UserInfoId = @inp_iUserInfoId AND MapToTypeCodeId = @DISCLOSURETRANSACTION ))
                                                       BEGIN

                                                              DECLARE @RedirectionResult_Others TABLE (SequenceNumber INT IDENTITY(1,1),ReqModuleId INT,UserInfoId INT)
                                                                     
                                                              INSERT INTO @RedirectionResult_Others(ReqModuleId,UserInfoId)
                                                              SELECT       comp.RequiredModule,@inp_iUserInfoId
                                                              FROM    mst_Company comp

                                                              DECLARE @sRedirect_OS_Others VARCHAR(100) 
                                                              SELECT TOP 1 @sRedirect_OS_Others = ',ReqModuleId,' + CONVERT(VARCHAR(15), ReqModuleId) + ',UserInfoId,' + CONVERT(VARCHAR(15), UserInfoId) FROM @RedirectionResult_Others 
                                                              SELECT Controller,Action,Parameter + @sRedirect_OS_Others as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectToInitialDisclosurePage_Redirect
                                                       END
                                                END
                                                ELSE IF(@nRequiredModuleID = @nRequiredModule_BOTH)
                                                BEGIN
                                                    DECLARE @IDConfirmFlag INT =0;
                                                       IF(NOT EXISTS(SELECT EventLogId FROM eve_EventLog WHERE EventCodeId = @EventInitialDisclosureEntered and UserInfoId = @inp_iUserInfoId AND MapToTypeCodeId = @DISCLOSURETRANSACTION ))
                                                       BEGIN
                                                          
                                                              SET @IDConfirmFlag=1
                                                              DECLARE @RedirectionResult_OWN TABLE (SequenceNumber INT IDENTITY(1,1),ReqModuleId INT,UserInfoId INT)
                                                                     
                                                              DECLARE @ModuleID_Own int =513001
                                                              INSERT INTO @RedirectionResult_OWN(ReqModuleId,UserInfoId)                                                         
                                                              values (@ModuleID_Own,@inp_iUserInfoId)       

                                                              DECLARE @sRedirect_OWN VARCHAR(100) 
                                                              SELECT TOP 1 @sRedirect_OWN = ',UserInfoId,' + CONVERT(VARCHAR(15), UserInfoId) + ',ReqModuleId,' + CONVERT(VARCHAR(15), ReqModuleId) FROM @RedirectionResult_OWN 
                                                              SELECT TOP 1 @sRedirect_OWN = ',ReqModuleId,' + CONVERT(VARCHAR(15), ReqModuleId) FROM @RedirectionResult_OWN 
                                                              SELECT Controller,Action,Parameter + @sRedirect_OWN as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectToInitialDisclosurePage_Redirect
                                                              --SELECT Controller,Action,Parameter  FROM com_GlobalRedirectToURL g where g.ID = @RedirectToInitialDisclosurePage_Redirect
                                                       END

                                                    IF(@IDConfirmFlag!=1)
                                                       BEGIN
                                                              IF(@nGetTradingPolicyId_OS != 0)
                                                              BEGIN                                                      
                                                                     IF(NOT EXISTS(SELECT EventLogId FROM eve_EventLog WHERE EventCodeId = @EventInitialDisclosureEntered_OS and UserInfoId = @inp_iUserInfoId AND MapToTypeCodeId = @DISCLOSURETRANSACTION ))
                                                                     BEGIN                                                        
                                                                           DECLARE @RedirectionResult TABLE (SequenceNumber INT IDENTITY(1,1),ReqModuleId INT,UserInfoId INT)
                                                                           DECLARE @ModuleID int =513002
                                                                           INSERT INTO @RedirectionResult(ReqModuleId,UserInfoId)
                                                                           values (@ModuleID,@inp_iUserInfoId)                                                                    

                                                                           DECLARE @sRedirect_OS VARCHAR(100) 
                                                                           SELECT TOP 1 @sRedirect_OS =  ',UserInfoId,' + CONVERT(VARCHAR(15), UserInfoId) + ',ReqModuleId,' + CONVERT(VARCHAR(15), ReqModuleId) FROM @RedirectionResult 
                                                                           SELECT Controller,Action,Parameter + @sRedirect_OS as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectToInitialDisclosurePage_Redirect
                                                                     END
                                                              END
                                                       END
                                                       
                                                  END                             
                                             END                           
                                                --ELSE -- After submission of ID , if any policy is left to View/Agree
                                  DECLARE @nIDOwnConfirm INT=0
                                  DECLARE @nIDOtherConfirm INT=0

                                  IF(EXISTS(SELECT EventLogId FROM eve_EventLog WHERE EventCodeId = @EventInitialDisclosureEntered and UserInfoId = @inp_iUserInfoId AND MapToTypeCodeId = @DISCLOSURETRANSACTION ))
                                  BEGIN
                                  SET @nIDOwnConfirm=1                                   
                                  END

                                  IF(EXISTS(SELECT EventLogId FROM eve_EventLog WHERE EventCodeId = @EventInitialDisclosureEntered_OS and UserInfoId = @inp_iUserInfoId AND MapToTypeCodeId = @DISCLOSURETRANSACTION ))
                                  BEGIN
                                  SET @nIDOtherConfirm=1                                        
                                  END
                                  
                                  IF(@nIDOwnConfirm=1 AND @nIDOtherConfirm=1)
                                                BEGIN                      
                                                       SELECT @nPasswordValidity = PassValidity FROM usr_PasswordConfig
                                                       select @nExpiryDate = DATEADD(DAY, @nPasswordValidity, (select ModifiedOn from usr_authentication where userinfoid=@inp_iUserInfoId))
                                                       IF(@nExpiryDate<GETDATE())
                                                       BEGIN
                                                              SELECT Controller,Action,Parameter as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_Change_Password_Page
                                                       END
                                                       ELSE
                                                       BEGIN
                                                              DECLARE @FinalResult TABLE (SequenceNumber INT IDENTITY(1,1),PolicyDocumentId INT,DocumentId INT)
                                                                     
                                                              INSERT INTO @FinalResult(PolicyDocumentId,DocumentId)
                                                              SELECT VW.MapToId,d.DocumentId
                                                              FROM       vw_ApplicablePolicyDocumentForUser VW                         
                                                                           JOIN com_DocumentObjectMapping d ON VW.MapToId = d.MapToId 
                                                                           JOIN rul_PolicyDocument p1 ON p1.PolicyDocumentId = d.MapToId
                                                              WHERE  VW.UserInfoId = @inp_iUserInfoId 
                                                                           AND d.MapToTypeCodeId = @MapToTypePolicyDocument AND p1.WindowStatusCodeId = @POLICYDOCUMENTACTIVE AND P1.DocumentViewAgreeFlag = 1                                  
                                                                           AND VW.MapToId NOT IN(
                                                                                                                     SELECT DISTINCT e.MapToId 
                                                                                                                     FROM   eve_EventLog e 
                                                                                                                                  JOIN vw_ApplicablePolicyDocumentForUser v ON v.MapToId = e.MapToId 
                                                                                                                                  JOIN rul_PolicyDocument p ON v.MapToId = p.PolicyDocumentId  
                                                                                                                     WHERE  e.UserInfoId = @inp_iUserInfoId AND e.MapToTypeCodeId = @MapToTypePolicyDocument 
                                                                                                                                  AND p.IsDeleted = 0 AND p.WindowStatusCodeId = @POLICYDOCUMENTACTIVE  AND p.DocumentViewAgreeFlag = 1
                                                                                                                                  AND (e.EventCodeId = @PolicyDocumentViewed OR e.EventCodeId = @PolicyDocumentAgreed)
                                                                                                              )

                                                              SELECT @CountForFinalResultTable = COUNT(*) from @FinalResult                             
                                                              IF(@CountForFinalResultTable > 0)
                                                              BEGIN
                                                                     DECLARE @sPolicyDocument VARCHAR(100) 
                                                                     SELECT TOP 1 @sPolicyDocument = ',PolicyDocumentId,' + CONVERT(VARCHAR(15), PolicyDocumentId) + ',DocumentId,' + CONVERT(VARCHAR(15), DocumentId) FROM @FinalResult 
                                                                     SELECT Controller,Action,Parameter + @sPolicyDocument as Parameter FROM com_GlobalRedirectToURL where ID = @RedirectToPolicyDisplayPage 
                                                              END    
                                                       END                        
                                                END    
                                         
                                  END
                         END
                     END
                     ELSE
                     BEGIN
                           SET @out_nReturnValue = 0
                           RETURN @out_nReturnValue
                     END    
              END
              ELSE IF (@USERTYPE = @USERTYPE_COUSER OR @USERTYPE = @USERTYPE_ADMIN OR @USERTYPE = @USERTYPE_SUPERADMIN)
              BEGIN
                     SET @out_nReturnValue = 0
                     RETURN @out_nReturnValue
              END
              
              SET @out_nReturnValue = 0
              RETURN @out_nReturnValue
                           
              
       
       END TRY
       BEGIN CATCH
              SET @out_nSQLErrCode    =  ERROR_NUMBER()
              SET @out_sSQLErrMessage =   ERROR_MESSAGE()     
              
              -- Return common error if required, otherwise specific error.        
              SET @out_nReturnValue =  0
              RETURN @out_nReturnValue
       END CATCH
END
