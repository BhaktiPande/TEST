IF OBJECT_ID ('dbo.st_com_PopulateCombo') IS NOT NULL
	DROP PROCEDURE dbo.st_com_PopulateCombo
GO

/******************************************************************************************************************
Description:	Common routine to populate combo box.

Returns:		0 if success
				
Created by:		Arundhati
Created on:		02-Feb-2015

Modification History:
Modified By		Modified On		Description
Swapnil			10-02-2015		Added combo type 2 for getting list of Companies on Corporate User details page.
Arundhati		16-02-2015		Alias is added for the column names
Swapnil			17-02-2015		Added Combo Type 3 for getting list of parents from Com_CodeGroup.
Arundhati		17-Feb-2015		Case 4: To fetch grid headers depending on the parameters GridTypeCodeId and Culture code
Arundhati		20-Feb-2015		Fetch only those groups which are editable
Gaurishanakr	03-Mar-2015		Added combo type 5 for getting list of active role from RoleMaster.
Amar			04-Mar-2015		Added combo type 6 for fetching the list of users for delegation from and to user list.
Swapnil			10-Mar-2015		Removed condition from combo type:3 for getting list of code from com_code and also added param2 for getting Code Group name from com_codeGroup.
Arundhati		10-Mar-2015		RoleList for selected usertype, Selected user
Arundhati		12-Mar-2015		If last name of user was null, it was not considered in the list (case 6)
Arundhati		26-Mar-2015		Codes are arranged as per name
Gaurishankar	18-Apr-2015		Added Combo type 7 for List of user and relative PAN No.
Gaurishankar	18-Apr-2015		Added Combo type 8 for List of users DMAT Account No.
Tushar			27-Ar-2015		Change Combo Type 8 return DMAT account no with DP Bank.
								Add Combo Type - 9 for List of User Relative
Arundhati		28-Apr-2015		Added combo type for usertype on Employee/Non-Employee/Corporate users list						
Amar			30-Apr-2015		For Combo type - 4 added width and alignment to the grid header list.
Swapnil			09-May-2015		Added as ID and As Value for Combo type 3
Tushar			12-May-2015		Added Combo Type = 11 for List of Disclosure Status And Trade Details Status.
Tushar			25-May-2015		Added Combo Type = 12 for fetching Assigned trasnactio type for trading policy as per Map To Type.
Gaurishankar	26-May-2015		Added Combo Type = 13 for fetching List Of Template for Communication
Amar			26-May-2015		Changes to ComboType = 7 : Appended first name and last name to PAN number.
										   ComboType = 8 : Added TMID in Width which is associated to each DEMAT account.
Swapnil			28-May-2015		Added new Parameter SequenceNumber in Combotype = 4.										   
Parag			01-Jun-2015		Added Combo Type = 14 for fetching designation combine from desingation master and designation help
Tushar			04-Jun-2015		Change Combo Type = 11 for List of Disclosure Status And Trade Details Status
Tushar			08-Jun-2015		Chagne combo type = 14 for designation list, ID return from list is set to 0 (previously id return same as value)
Amar			08-Jun-2015		Added Combo Type = 15 for getting the list of applicable security type set while creating preclearence
Raghvendra		13-Jun-2015		Add Combo Type =16 List of comments with CodeGroupId 162 to be shown in report search
Tushar			15-Jun-2015		Change in 9- List of User Relative 
Tushar			16-Jun-2015		Add Combo Type - 17 for List of Transaction Type those are applicable for trading policy.
Gaurishankar	18-Jun-2015		Added IsActive Condition for template.
Arundhati		22-Jun-2015		Case 16 is made parameter based. If parameter is null, then it is assumed as 162.
Gaurishankar	23-Jun-2015		Changes in @inp_iComboType = 13 Added OptionAttribute column to populate Template Ids
Ashish			24-Jun-2015		Add Param1 to @inp_iComboType = 2
Amar			06-Jul-2015     Code change to combo type 7 to get company name in case usertypecode id is not Employee
Amar			17-Jul-2015     Change to @inp_iComboType = 15 to fetch only those security type whose transaction details are entered and status is greater than not confirmed.
Arundhati		22-Jul-2015		Query correccted for the fetching only selected security types
Amar            29-Jul-2015     changes in query for @inp_iComboType = 4 for taking into consideration of override resource key and gridtype.
Tushar			01-Sep-2015		19.List of Security Type those are applicable for trading policy while creating preclearance request.
Parag			07-Sep-2015		Change to add IsVisible check before fetching com_code codes (Made change in combo type 1 and 14)
Santosh Panchal	11-Sep-2015		changes in query for @inp_iComboType = 18 for fetching Restricted Company List
Arundhati		14-Oct-2015		While merging ED's code, CodeId 103013 was changed to 103301. So the corresponding changes in this procedure
Gaurishankar	21-Oct-2015		20. List of Events those are viewed for communication trigger Events.
								Update case 11 for showu ploaded status of desclosure if param2 value is "showuploaded" then only populate the Document uploaded status.
Parag			11-Dec-2015		Change to get all security type applicable when disclosure type is period end disclosure is submitted (Made change in combo type 15)
Tushar			12-Jan-2016		Edit ComboType = 8 add query for With Relative demat details
Tushar			14-Jan-2016		Edit ComboType = 8 add query for With Relative demat details
Tushar			01-Feb-2016		Add Combo Type 21 - List of Relationship With Insider values.
ED				4-Feb-2016		Code integration done on 4-Feb-2016
ED				22-Mar-2016		Code integration done on 22-Mar-2016
Tushar			31-Mar-2016		Added Combo Type = 22 Trading Policy For Contra Trade Security Mode
Tushar			14-Jun-2016		All Security type list out from combo Type = 15 
Parag			06-Sept-2016	Made change in combo type = 8, to get demat account base on configuration set 
Raghvendra		20-Oct-2016		List of Placeholders based on the Communication Mode.
Raghvendra		27-Oct-2016		Fix for handling ISNULL condition for User/Relatives FirstName, LastName when appending the both together for to be shown in dropdowns. 
								Fix for Mantis issue 9618
******************************************************************************************************************
Type	Description
-------------------
1. List of codes
2. List of Company
3. List Of parents From Com_CodeGroup and also Parent Code Group Name From Com_CodceGroup.
4. List of Grid headers from resources depending on GridTypeCodeId and CultureCode
5. List of Roles
6. List of CO Users
7. List of user and relative PAN No
8. List of Users DMAT Account no.
9. List of User Relative 
10.List of codes for UserType {Employee / Non-Employee / Corporate}
11.List of Disclosure Status And Trade Details Status
12.List of Transaction Type assigned for Trading Policy as per Map To Type.
13.List Of Template for Communication
14.List of designation combine from desingation master and designation help
15.List of available security type according to the preclearence id 
16.List of comments with CodeGroupId 162 to be shown in report search
17.List of Transaction Type those are applicable for trading policy.
18.List of Restricted Companies List
19.List of Security Type those are applicable for trading policy while creating preclearance request.
20.List of Events those are viewed for communication trigger Events.
21.List of Relationship With Insider values.
22.List of Trading Policy Contra Trade selected security
23.List of Placeholders based on the Communication Mode 
26.List of Restricted List Status-Active/Inactive
Usage:
------
1.	EXEC st_com_PopulateCombo 1, '', '', '', '', '', ''
2.  EXEC st_com_PopulateCombo 2, '', '', '', '', '', ''
3.	Exec st_com_PopulateCombo 3, '', '', '', '', '', ''
4.	Exec st_com_PopulateCombo 4, '114001', 'en-US', '', '', '', ''
5.	Exec st_com_PopulateCombo 5, '', '', '', '', '', ''
6.  Exec st_com_PopulateCombo 6, '', '', '', '', '', ''
7.  Exec st_com_PopulateCombo 7, '1', '', '', '', '', ''
8.  Exec st_com_PopulateCombo 8, '1', '', '', '', '', ''
9.  Exec st_com_PopulateCombo 9, '302', '', '', '', '', ''
10. Exec st_com_PopulateCombo 10, '', '', '', '', '', ''
11. Exec st_com_PopulateCombo 11, '', '', '', '', '', ''
12. Exec st_com_PopulateCombo 12, '132004', '73', '', '', '', ''
13. Exec st_com_PopulateCombo 13, '156002', '', '', '', '', ''
14. Exec st_com_PopulateCombo 14, '', '', '', '', '', ''
15. Exec st_com_PopulateCombo 15, '139', '1', '', '', '', ''
16. Exec st_com_PopulateCombo 16, '', '', '', '', '', ''
17. Exec st_com_PopulateCombo 17, '1', '132004', '', '', '', ''
18. Exec st_com_PopulateCombo 18, '1', '132004', '', '', '', ''
19. Exec st_com_PopulateCombo 19, '269', '143001', '', '', '', ''
20. Exec st_com_PopulateCombo 20, '', '', '', '', '', ''
21. Exec st_com_PopulateCombo 21, '', '', '', '', '', ''
22. Exec st_com_PopulateCombo 22, '132013', '7', '', '', '', ''
23. Exec st_com_PopulateCombo 23, '156007', '', '', '', '', ''
26. Exec st_com_PopulateCombo 26, '', '', '', '', '', ''
******************************************************************************************************************/
CREATE PROCEDURE [dbo].[st_com_PopulateCombo]
	@inp_iComboType			INT,		-- As described above.
	@inp_sParam1			VARCHAR(MAX),
	@inp_sParam2			VARCHAR(MAX),
	@inp_sParam3			VARCHAR(MAX),
	@inp_sParam4			VARCHAR(MAX),
	@inp_sParam5			VARCHAR(MAX),
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
AS
BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- DECLARE variables here
	DECLARE @nTemp INT
	DECLARE @nACTIVE_ROLE_STATUS INT
	DECLARE @nUserTypeCodeID INT
	
	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0
	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0
	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = ''
		
	DECLARE @DBNAME VARCHAR(100) = UPPER((SELECT DB_NAME()))
	DECLARE @FIND_KOTAK VARCHAR(50) = 'Vigilante_Kotak'	

	-- com_code
	IF(@inp_iComboType = 1)
		BEGIN
		-- Param1 = CodeGroupId, Param2 = ParentCodeId	
		
		IF(@inp_sParam1=518)
		BEGIN			
				CREATE TABLE #temp (CodeID INT, CodeName NVARCHAR(255),CodeGroupId int, Description NVARCHAR(200), IsVisible bit,IsActive int, DisplayOrder int, DisplayCode NVARCHAR(MAX),
				 ParentCodeId int) 
				INSERT INTO #temp SELECT CodeID, CodeName, CodeGroupId, Description, IsVisible,IsActive, DisplayOrder, DisplayCode, ParentCodeId
				FROM com_Code
				WHERE CodeGroupId = @inp_sParam1 AND CodeName NOT LIKE 'Other%'	
				INSERT INTO #temp SELECT CodeID, CodeName, CodeGroupId, Description, IsVisible,IsActive, DisplayOrder, DisplayCode, ParentCodeId
				FROM com_Code 
				Where CodeGroupId = @inp_sParam1 AND CodeName LIKE 'Other%'

				SELECT	 CodeID AS ID
					,CASE WHEN DisplayCode IS NULL OR DisplayCode = '' THEN CodeName ELSE DisplayCode END AS Value
				FROM #temp WHERE CodeGroupId=@inp_sParam1
				DROP TABLE #temp
		END	
		ELSE 		
			BEGIN
				SELECT	 CodeID AS ID
						,CASE WHEN DisplayCode IS NULL OR DisplayCode = '' THEN CodeName ELSE DisplayCode END AS Value
				FROM	 com_Code
				WHERE CodeGroupId = @inp_sParam1
					AND (@inp_sParam2 IS NULL OR ParentCodeId = @inp_sParam2)
					AND IsVisible = 1
				--ORDER BY DisplayOrder ASC
				ORDER BY CASE WHEN DisplayCode IS NULL OR DisplayCode = '' THEN CodeName ELSE DisplayCode END
			END
			
		RETURN 0;
	END 
		
	IF(@inp_iComboType = 2)
	BEGIN		
		IF @inp_sParam1 IS NULL
		BEGIN
			SELECT	 C.CompanyId AS ID,C.CompanyName AS Value
			FROM	 mst_Company C
			ORDER BY CompanyName	
		END
		ELSE IF @inp_sParam1 IS NOT NULL
		BEGIN
			SELECT	 C.CompanyId AS ID,C.CompanyName AS Value
			FROM	 mst_Company C
			WHERE C.CompanyId NOT IN(@inp_sParam1)
			ORDER BY CompanyName
		END
		RETURN 0;
	END 
	
	IF(@inp_iComboType = 3)
	BEGIN
		IF @inp_sParam1 IS NULL AND @inp_sParam2 IS NULL	
			BEGIN
			     DECLARE @IsMCQRequired INT
		         DECLARE @IsPreClearanceEditable INT
		         SELECT  @IsMCQRequired = ISNULL(IsMCQRequired,521002), @IsPreClearanceEditable = ISNULL(IsPreClearanceEditable,524002) FROM mst_Company WHERE CompanyId = 1

				SELECT	 Convert(varchar(20),CodeGroupID) + '-' + ISNULL(CONVERT(varchar(20),ParentCodeGroupId),'0') AS ID
						,COdeGroupName AS Value				
				FROM	 com_CodeGroup
				WHERE	 IsEditable = 1
				         AND CodeGroupID NOT IN (CASE WHEN @IsMCQRequired = 521002 THEN '521' ELSE '0' END) 
				         AND CodeGroupID NOT IN (CASE WHEN @IsMCQRequired = 521002 THEN '522' ELSE '0' END) 
				         AND CodeGroupID NOT IN (CASE WHEN @IsPreClearanceEditable =524002 THEN '524' ELSE '0' END) 
				ORDER BY COdeGroupName
			END
		ELSE IF @inp_sParam2 IS NOT NULL --Used to get CodeGroup Name For setting label for parent Combo On Others Masters Page.
			BEGIN
				SELECT	CodeGroupID AS ID
					   ,COdeGroupName AS Value
				FROM    com_CodeGroup  
				WHERE   CodeGroupID = @inp_sParam2
			END		
		RETURN 0;
	END 
		
	IF(@inp_iComboType = 4)
	BEGIN		
		IF (@inp_sParam3 IS NULL or @inp_sParam3 = '') 
		BEGIN
			SELECT R.ResourceKey AS ID, R.ResourceValue AS Value, GH.ColumnWidth AS Width, C.CodeName AS Align, GH.SequenceNumber AS SequenceNumber
			FROM mst_Resource R JOIN com_GridHeaderSetting GH ON R.ResourceKey = GH.ResourceKey JOIN com_Code C ON C.CodeID = GH.ColumnAlignment
			WHERE GridTypeCodeId = @inp_sParam1 and (OverrideGridTypeCodeId IS NULL or OverrideGridTypeCodeId = 0) and ResourceCulture = @inp_sParam2
			AND GH.IsVisible = 1
			ORDER BY GH.SequenceNumber
		END
		ELSE
		BEGIN
			SELECT GH.ResourceKey AS ID, R.ResourceValue AS Value, GH.ColumnWidth AS Width, C.CodeName AS Align, GH.SequenceNumber AS SequenceNumber
			FROM mst_Resource R JOIN com_GridHeaderSetting GH ON R.ResourceKey = GH.OverrideResourceKey JOIN com_Code C ON C.CodeID = GH.ColumnAlignment
			WHERE GridTypeCodeId = @inp_sParam1 and OverrideGridTypeCodeId = @inp_sParam3 and ResourceCulture = @inp_sParam2
			AND GH.IsVisible = 1
			ORDER BY GH.SequenceNumber
		END

		RETURN 0;
	END
	IF(@inp_iComboType = 5)
	BEGIN		
		SET @nACTIVE_ROLE_STATUS = 106001
		IF @inp_sParam1 IS NULL AND @inp_sParam2 IS NULL
		BEGIN
			SELECT R.RoleId AS ID, R.RoleName AS Value
			FROM usr_RoleMaster R 
			WHERE StatusCodeId = @nACTIVE_ROLE_STATUS
			ORDER BY R.RoleName
		END
		ELSE IF @inp_sParam2 IS NULL
		BEGIN
			-- Param1: UserType
			SELECT R.RoleId AS ID, R.RoleName AS Value
			FROM usr_RoleMaster R 
			WHERE StatusCodeId = @nACTIVE_ROLE_STATUS
				AND UserTypeCodeId = @inp_sParam1
			ORDER BY R.RoleName		
		END
		ELSE
		BEGIN
			-- Param1: UserType Param2: UserInfoId
			SELECT R.RoleId AS ID, R.RoleName AS Value
			FROM usr_RoleMaster R JOIN usr_UserRole UR ON R.RoleId = UR.RoleID AND UR.UserInfoID = @inp_sParam2
			WHERE StatusCodeId = @nACTIVE_ROLE_STATUS
				AND UserTypeCodeId = @inp_sParam1
			ORDER BY R.RoleName		
		END

		RETURN 0;
	END
	
	IF(@inp_iComboType = 6)
	BEGIN		
		SET @nUserTypeCodeID = 101002
		SELECT U.UserInfoId AS ID, ISNULL(U.FirstName,'') + ISNULL( ' ' + U.LastName, '') AS Value
		FROM usr_UserInfo U
		WHERE U.UserTypeCodeId = @nUserTypeCodeID 
		ORDER BY U.FirstName + ' ' + ISNULL(U.LastName, '')
		
		RETURN 0;
	END
	IF(@inp_iComboType = 7)
	BEGIN		
			SET @nUserTypeCodeID = 101003
		    SELECT UIRelative.UserInfoId AS ID, ISNULL(UIRelative.FirstName,'') + ISNULL(' '+ UIRelative.LastName,'') + ISNULL(' - '+ UIRelative.PAN, '') +' (' + C.CodeName +')' AS Value  FROM usr_UserInfo UI
			  INNER JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoId
			  INNER JOIN usr_UserInfo UIRelative ON UR.UserInfoIdRelative = UIRelative.UserInfoId
			  INNER JOIN com_Code C ON UR.RelationTypeCodeId = C.CodeID
			  WHERE UI.UserInfoId = @inp_sParam1 
			UNION 
			SELECT UserInfoId AS ID , 
				CASE WHEN UserTypeCodeId = @nUserTypeCodeID then ISNULL(FirstName,'') + ISNULL(' ' + LastName,'') + ' - ' + PAN +' (Self)' 
				ELSE cmp.CompanyName + ' - ' + PAN +' (Self)' END AS Value 
				FROM usr_UserInfo uf left join mst_Company cmp on uf.CompanyId = cmp.CompanyId  WHERE UserInfoId = @inp_sParam1
					
		RETURN 0;
	END
	--List of User DEMAT details
	IF(@inp_iComboType = 8)
	BEGIN
		IF (@inp_sParam3 IS NULL OR @inp_sParam3 = '')
		BEGIN
			EXEC st_com_GetDematAccountList @inp_sParam1, @inp_sParam2
		END
		ELSE 
		BEGIN
			-- fetch all demat account includeing relative account
			EXEC st_com_GetDematAccountList @inp_sParam1, @inp_sParam2, 1 
		END
		
		RETURN 0;
	END
	--List of User Relative  
	IF(@inp_iComboType = 9)
	BEGIN		
		SELECT uf.UserInfoId AS ID,ISNULL(uf.FirstName,'') + ISNULL(' ' + uf.LastName,'') AS Value
		FROM usr_UserRelation UR
		INNER JOIN usr_UserInfo UF  ON UF.UserInfoId = UR.UserInfoIdRelative
		WHERE ur.UserInfoId = @inp_sParam1 and uf.RelativeStatus = 102001
		RETURN 0;
	END
	-- List of UserTypes (Employee / Non-Employee / Corporate)
	IF(@inp_iComboType = 10)
	BEGIN		
		SELECT CodeID AS ID, CodeName AS Value
		FROM com_Code 
		WHERE CodeID IN (101003, 101004, 101006)
		ORDER BY CodeName
		RETURN 0;
	END
	
	
	-- List of Disclosure Status And Trade Details Status
   	IF(@inp_iComboType = 11)
	BEGIN		
		IF(@inp_sParam2 IS NULL)
		BEGIN
			SELECT CodeID AS ID, CASE WHEN CodeName = 'Completed' THEN 'Submitted' ELSE CodeName END AS Value
			FROM com_Code 
			WHERE CodeGroupId = 154 AND CodeID NOT IN (154003,154008)
			ORDER BY CodeName
		END
		ELSE IF (@inp_sParam2 = 'showuploaded')
		BEGIN
			SELECT CodeID AS ID, CASE WHEN CodeName = 'Completed' THEN 'Submitted'
									  WHEN  CodeName = 'Uploaded' THEN 'Document Uploaded'
									  ELSE CodeName END AS Value
			FROM com_Code 
			WHERE CodeGroupId = @inp_sParam1 AND CodeID IN (154001,154002,154006)
			ORDER BY CodeName
		END
		ELSE
		BEGIN
		-- Update By Tushar For In Progress
		    IF(@inp_sParam4='IP'AND @inp_sParam5 ='101001' OR @inp_sParam5 ='101002')
		    BEGIN
		    	SELECT CodeID AS ID, CASE WHEN CodeName = 'Completed' THEN 'Submitted' ELSE CodeName END AS Value
		    	FROM com_Code 
			    WHERE CodeGroupId = @inp_sParam1 AND CodeID IN (154001,154002,154008)
		    	ORDER BY CodeName
			END
			ELSE 
			BEGIN
			    SELECT CodeID AS ID, CASE WHEN CodeName = 'Completed' THEN 'Submitted' ELSE CodeName END AS Value
		    	FROM com_Code 
			    WHERE CodeGroupId = @inp_sParam1 AND CodeID IN (154001,154002)
		    	ORDER BY CodeName
			END
		END
		--
		RETURN 0;
	END 
	
	-- List of Disclosure Status And Trade Details Status
   	--IF(@inp_iComboType = 11)
	--BEGIN		
		--IF(@inp_sParam2 IS NULL)
		--BEGIN
			--SELECT CodeID AS ID, CASE WHEN CodeName = 'Completed' THEN 'Submitted' ELSE CodeName END AS Value
			--FROM com_Code 
			--WHERE CodeGroupId = 154 AND CodeID NOT IN (154003)
			--ORDER BY CodeName
		--END
		--ELSE IF (@inp_sParam2 = 'showuploaded')
		--BEGIN
			--SELECT CodeID AS ID, CASE WHEN CodeName = 'Completed' THEN 'Submitted'
									  --WHEN  CodeName = 'Uploaded' THEN 'Document Uploaded'
									  --ELSE CodeName END AS Value
			--FROM com_Code 
			--WHERE CodeGroupId = @inp_sParam1 AND CodeID IN (154001,154002,154006)
			--ORDER BY CodeName
		--END
		--ELSE
		--BEGIN
			--SELECT CodeID AS ID, CASE WHEN CodeName = 'Completed' THEN 'Submitted' ELSE CodeName END AS Value
			--FROM com_Code 
			--WHERE CodeGroupId = @inp_sParam1 AND CodeID IN (154001,154002,154008)
			--ORDER BY CodeName
		--END
		--RETURN 0;
	--END 
	-- List of UserTypes (Employee / Non-Employee / Corporate)
	IF(@inp_iComboType = 12)
	BEGIN		
		SELECT code.CodeID AS ID, code.CodeName AS Value 
		FROM rul_TradingPolicyForTransactionMode TPFTM 
		JOIN com_Code code ON TPFTM.TransactionModeCodeId = code.CodeID
		WHERE TPFTM.MapToTypeCodeId = @inp_sParam1 AND TradingPolicyId = @inp_sParam2
		RETURN 0;
	END
	-- List of Template
	IF(@inp_iComboType = 13)
	BEGIN		
		IF(@inp_sParam1 IS NOT NULL AND @inp_sParam1 != '')
		BEGIN
			SELECT	TM.TemplateMasterId AS ID, REPLACE( REPLACE( REPLACE(REPLACE( REPLACE(TM.TemplateName,'&lt;','<') 
															  ,'&gt;','>')
															  ,'&quot;','"')
															  ,'&#39;','''')
															  ,'&amp;','&') AS Value, TM.CommunicationModeCodeId AS OptionAttribute
			FROM	tra_TemplateMaster TM
			WHERE	IsActive = 1 
					AND CommunicationModeCodeId = @inp_sParam1
			ORDER BY TM.TemplateName	
		END
		ELSE
		BEGIN
			SELECT	 TM.TemplateMasterId AS ID, REPLACE( REPLACE( REPLACE(REPLACE( REPLACE(TM.TemplateName,'&lt;','<') 
															  ,'&gt;','>')
															  ,'&quot;','"')
															  ,'&#39;','''')
															  ,'&amp;','&') AS Value, TM.CommunicationModeCodeId AS OptionAttribute
			FROM	 tra_TemplateMaster TM
			WHERE	IsActive = 1 
			ORDER BY TM.TemplateName	
		END

		RETURN 0;
	END 
	
	-- List of distict designation combine from desingation master and designation help
	-- NOTE: This can not be used for drop down because ID return is not unique. it can be used for autocomplete only
	IF(@inp_iComboType = 14)
	BEGIN		
		SELECT 
			DISTINCT 0 AS ID, 
			CASE WHEN DisplayCode IS NULL OR DisplayCode = '' THEN CodeName ELSE DisplayCode END AS Value
		FROM com_Code
		WHERE (CodeGroupId = 109 OR CodeGroupId = 119)
			AND IsVisible = 1
		ORDER BY CASE WHEN DisplayCode IS NULL OR DisplayCode = '' THEN CodeName ELSE DisplayCode END
		
		RETURN 0;
	END 
	
	-- List of available security type according to the preclearence id 
	IF(@inp_iComboType = 15)
	BEGIN
	    DECLARE @nSecurityTypeCodeId NVARCHAR(MAX) = ''
	    declare @sSQL NVARCHAR(MAX) 
	    
	    DECLARE @nDisclosureType_PeriodEnd INT = 147003
	    DECLARE	@CDDuringPE bit =null
	    
		DECLARE @dtPeriodEndDate DATETIME
		DECLARE @nDisclosureTypeCodeId INT
		DECLARE @nUserInfoId INT
		DECLARE @nTransactionStatusCodeId INT
	    print @inp_sParam2
	    --If preclearence not set then check for transaction submitted and display only the accessible security grid.
		IF @inp_sParam2 IS NOT NULL AND @inp_sParam2 <> 0
		BEGIN
			SELECT @nSecurityTypeCodeId = CONVERT(varchar(max),SecurityTypeCodeId) FROM tra_PreclearanceRequest WHERE PreclearanceRequestId = @inp_sParam2
        END
        ELSE
        BEGIN
            -- If transaction submitted then display only the security grid records where transaction details are entered.
			IF @inp_sParam3 IS NOT NULL AND @inp_sParam3 <> 0
			BEGIN
				-- check if disclosure type, in case of period end and submitted fetch all the security type which are traded in period
				SELECT 
					@nUserInfoId = UserInfoId, @nDisclosureTypeCodeId = DisclosureTypeCodeId, @dtPeriodEndDate = PeriodEndDate, 
					@nTransactionStatusCodeId = TransactionStatusCodeId
				FROM tra_TransactionMaster WHERE TransactionMasterId = CONVERT(int, @inp_sParam3)
				PRINT(@inp_sParam4)
				-- check if transaction is submitted or not 
				IF (@nTransactionStatusCodeId NOT IN (148001, 148002) OR @inp_sParam4 IS NOT NULL AND @inp_sParam4 <> 0 )
				BEGIN
					
					if(@inp_sParam4 IS NOT NULL AND @inp_sParam4 <> 0)
					BEGIN					
						SELECT @nSecurityTypeCodeId = COALESCE(@nSecurityTypeCodeId + ',', '') + CONVERT(varchar(max), tmp.SecurityTypeCodeId) 
						FROM 
						(
							SELECT distinct TD.SecurityTypeCodeId FROM tra_TransactionMaster TM 
							JOIN tra_TransactionDetails TD on TM.TransactionMasterId = TD.TransactionMasterId 
							WHERE 
							--TM.TransactionStatusCodeId <> 148002 AND TM.TransactionStatusCodeId <> 148001 
							--AND 
								(@nDisclosureTypeCodeId <> @nDisclosureType_PeriodEnd AND TM.TransactionMasterId = CONVERT(int, @inp_sParam3) )
								OR (@nDisclosureTypeCodeId = @nDisclosureType_PeriodEnd AND TM.PeriodEndDate = @dtPeriodEndDate)
							AND UserInfoId = @nUserInfoId AND TD.SecurityTypeCodeId=@inp_sParam4
						) tmp
					END
					ELSE
					BEGIN
						SELECT @nSecurityTypeCodeId = COALESCE(@nSecurityTypeCodeId + ',', '') + CONVERT(varchar(max), tmp.SecurityTypeCodeId) 
						FROM 
						(
							SELECT distinct TD.SecurityTypeCodeId FROM tra_TransactionMaster TM 
							JOIN tra_TransactionDetails TD on TM.TransactionMasterId = TD.TransactionMasterId 
							WHERE TM.TransactionStatusCodeId <> 148002 AND TM.TransactionStatusCodeId <> 148001 
							AND 
								(@nDisclosureTypeCodeId <> @nDisclosureType_PeriodEnd AND TM.TransactionMasterId = CONVERT(int, @inp_sParam3) )
								OR (@nDisclosureTypeCodeId = @nDisclosureType_PeriodEnd AND TM.PeriodEndDate = @dtPeriodEndDate)
							AND UserInfoId = @nUserInfoId
						) tmp
					END
				END
				
				IF(@CDDuringPE=1)
				BEGIN
						select  @nSecurityTypeCodeId = COALESCE(@nSecurityTypeCodeId + ',', '') + CONVERT(varchar(max), tmp.SecurityTypeCodeId) 
					FROM 
					(
						SELECT distinct TD.SecurityTypeCodeId FROM tra_TransactionMaster TM 
						JOIN tra_TransactionDetails TD on TM.TransactionMasterId = TD.TransactionMasterId 
						WHERE (@nDisclosureTypeCodeId <> @nDisclosureType_PeriodEnd AND TM.TransactionMasterId = CONVERT(int, @inp_sParam3) )
							OR (@nDisclosureTypeCodeId = @nDisclosureType_PeriodEnd AND TM.PeriodEndDate = @dtPeriodEndDate)
						AND UserInfoId = @nUserInfoId
					) tmp
				END
				
				IF @nSecurityTypeCodeId != ''
				BEGIN
					SET @nSecurityTypeCodeId = RIGHT(@nSecurityTypeCodeId, LEN(@nSecurityTypeCodeId)-1)
				END
			END
		END
		
		IF(@FIND_KOTAK = @DBNAME)
		BEGIN
			IF @nSecurityTypeCodeId = ''
			BEGIN
				 SELECT @sSQL = 'SELECT CodeID AS ID
							,CASE WHEN DisplayCode IS NULL OR DisplayCode = '''' THEN CodeName ELSE DisplayCode END AS Value
							FROM  com_Code
							WHERE CodeGroupId = CONVERT(int,'+@inp_sParam1+') AND CodeID = 139001
							
							ORDER BY CodeID ASC, CASE WHEN DisplayCode IS NULL OR DisplayCode = '''' THEN CodeName ELSE DisplayCode END' 
			END
			ELSE
			BEGIN	 
			SELECT @sSQL = 'SELECT CodeID AS ID
							,CASE WHEN DisplayCode IS NULL OR DisplayCode = '''' THEN CodeName ELSE DisplayCode END AS Value
							FROM  com_Code
							WHERE CodeGroupId = CONVERT(int,'+@inp_sParam1+') AND CodeID = 139001
							AND ('''+isnull(@nSecurityTypeCodeId,'')+''' = '''' OR CodeID in ('+@nSecurityTypeCodeId+'))
							ORDER BY CodeID ASC, CASE WHEN DisplayCode IS NULL OR DisplayCode = '''' THEN CodeName ELSE DisplayCode END'
			END
		END
		ELSE
		BEGIN
			IF @nSecurityTypeCodeId = '' AND @inp_sParam4=0
			BEGIN
				 SELECT @sSQL = 'SELECT CodeID AS ID
							,CASE WHEN DisplayCode IS NULL OR DisplayCode = '''' THEN CodeName ELSE DisplayCode END AS Value
							FROM  com_Code
							WHERE CodeGroupId = CONVERT(int,'+@inp_sParam1+')
							
							ORDER BY CodeID ASC, CASE WHEN DisplayCode IS NULL OR DisplayCode = '''' THEN CodeName ELSE DisplayCode END' 
			END
			ELSE
			BEGIN
			IF @nSecurityTypeCodeId <> '' 
			--AND @inp_sParam4 <> 0
			BEGIN
			SELECT @sSQL = 'SELECT CodeID AS ID
							,CASE WHEN DisplayCode IS NULL OR DisplayCode = '''' THEN CodeName ELSE DisplayCode END AS Value
							FROM  com_Code
							WHERE CodeGroupId = CONVERT(int,'+@inp_sParam1+')
							AND ('''+isnull(@nSecurityTypeCodeId,'')+''' = '''' OR CodeID in ('+@nSecurityTypeCodeId+'))
							ORDER BY CodeID ASC, CASE WHEN DisplayCode IS NULL OR DisplayCode = '''' THEN CodeName ELSE DisplayCode END'
			END				
			END
		END		
		
		exec(@sSQL)
		RETURN 0;
	END
	-- Comments Dropdown for CodeGroupId 162 / 167
	IF(@inp_iComboType = 16)
	BEGIN
		IF @inp_sParam1 IS NULL
			SET @inp_sParam1 = 162
		
		SELECT	 CodeID AS ID
				,R.ResourceValue AS Value
		FROM	 com_Code CC
		JOIN mst_Resource R ON R.ResourceKey = CC.CodeName
		WHERE CodeGroupId = @inp_sParam1--162
		ORDER BY R.ResourceKey

		RETURN 0;
	END 	
	
	-- List of Transaction Type those are applicable for trading policy.
	IF(@inp_iComboType = 17)
	BEGIN
		SELECT CodeID AS ID,code.CodeName AS VALUE 
		FROM rul_TradingPolicyForTransactionMode TPFM
		JOIN com_Code code ON TPFM.TransactionModeCodeId = code.CodeID 
		WHERE TradingPolicyId = @inp_sParam1 AND MapToTypeCodeId = @inp_sParam2

		RETURN 0;
	END 	
	
	--List of Restricted Companies 
	IF(@inp_iComboType = 18)
	BEGIN		
		SET @inp_sParam2 = 103301--103013
		IF(@inp_sParam1 = 1)
		BEGIN
			SELECT Distinct RL.CompanyName +' '+'-'+'('+RL.ISINCode + ')' AS Value,RlCompanyID AS ID  
			FROM rl_CompanyMasterList RL
			JOIN com_Code code On RL.ModuleCodeId = code.CodeID
			WHERE RL.StatusCodeID = 105001 AND ModuleCodeId = @inp_sParam2			
		END
		IF(@inp_sParam1 = 2)
		BEGIN
			SELECT Distinct RL.BSECode AS Value, RlCompanyID AS ID
			FROM rl_CompanyMasterList RL
			JOIN com_Code code On RL.ModuleCodeId = code.CodeID
			WHERE RL.StatusCodeID = 105001 AND ModuleCodeId = @inp_sParam2			
		END
		IF(@inp_sParam1 = 3)
		BEGIN
			SELECT Distinct RL.NSECode AS Value,RlCompanyID AS ID
			FROM rl_CompanyMasterList RL
			JOIN com_Code code On RL.ModuleCodeId = code.CodeID
			WHERE RL.StatusCodeID = 105001 AND ModuleCodeId = @inp_sParam2			
		END
		IF(@inp_sParam1 = 4)
		BEGIN
			SELECT Distinct RL.ISINCode AS Value,RlCompanyID AS ID
			FROM rl_CompanyMasterList RL
			JOIN com_Code code On RL.ModuleCodeId = code.CodeID
			WHERE RL.StatusCodeID = 105001 AND ModuleCodeId = @inp_sParam2			
		END
		IF(@inp_sParam1 = 5)
		BEGIN
			SELECT Distinct (ISNULL(UI.FirstName,' ') + ' '+ ISNULL(UI.LastName,' ')) AS Value,RL.CreatedBy AS ID
			FROM rl_RistrictedMasterList RL
			JOIN com_Code code On RL.ModuleCodeId = code.CodeID
			JOIN usr_UserInfo UI On RL.CreatedBy = UI.UserInfoId  
			WHERE RL.StatusCodeID = 105001 AND ModuleCodeId = @inp_sParam2			
		END
		RETURN 0;
	END
	
	-- List of Security Type those are applicable for trading policy while creating preclearance request.
	IF(@inp_iComboType = 19)
	BEGIN
		SELECT code.CodeID AS ID,CodeName AS VALUE  
		FROM rul_TradingPolicyForTransactionSecurity TPFTS
		JOIN com_Code code ON TPFTS.SecurityTypeCodeId = code.CodeID
		WHERE MapToTypeCodeId = 132004
		AND TPFTS.TransactionModeCodeId = @inp_sParam2 AND TradingPolicyId = @inp_sParam1

		RETURN 0;
	END 
	-- List of Events those are viewed for communication trigger Events.
	IF(@inp_iComboType = 20)
	BEGIN
	
		SELECT CodeID AS ID
		,'Insider - ' + CodeName AS Value
		,163001  AS OptionAttribute
		FROM com_Code WHERE CodeGroupId = 153 AND [Description] like '%163001%'
		UNION 
		SELECT CodeID AS ID
		,'CO - ' + CodeName  AS Value
		,163002  AS OptionAttribute
		FROM com_Code WHERE CodeGroupId = 153 AND [Description] like '%163002%'
		
		RETURN 0;
	END 
	
	IF(@inp_iComboType = 21)
	BEGIN
		SELECT code.CodeID AS ID,code.CodeName AS Value
		FROM usr_UserRelation UR
		INNER JOIN usr_UserInfo UF  ON UF.UserInfoId = UR.UserInfoIdRelative
		JOIN com_Code code ON code.CodeID = UR.RelationTypeCodeId
		WHERE ur.UserInfoId = @inp_sParam1

		RETURN 0;
	END 
	--Trading Policy For Contra Trade Security Mode
	IF(@inp_iComboType = 22)
	BEGIN
		SELECT code.CodeID AS ID,CASE WHEN TPFSM.SecurityTypeCodeID IS NOT NULL THEN code.CodeName + '-' + CONVERT(VARCHAR(MAX),TPFSM.SecurityTypeCodeID) ELSE code.CodeName + '-' END  AS Value
		FROM com_Code code 
		LEFT JOIN rul_TradingPolicyForSecurityMode TPFSM ON code.CodeID = TPFSM.SecurityTypeCodeID AND TPFSM.MapToTypeCodeID = @inp_sParam1 AND TradingPolicyId = @inp_sParam2
		WHERE CodeGroupId = 139
		
		RETURN 0;
	END
	
	--List of Placeholders based on the Communication Mode
	IF(@inp_iComboType = 23)
	BEGIN
		SELECT REPLACE(REPLACE(PlaceholderTag,'[',''),']','') AS ID, REPLACE(REPLACE(PlaceholderTag,'[',''),']','') AS Value 
		FROM com_PlaceholderMaster 
		WHERE PlaceholderGroupId = @inp_sParam1
		ORDER BY Value
		
		RETURN 0;
	END
	
	--List of NSE Data Download Options
	IF(@inp_iComboType = 24)
	BEGIN
		-- Param1 = CodeGroupId, Param2 = ParentCodeId	
		SELECT	 CodeID AS ID
				,CodeName AS Value
		FROM com_Code 
		WHERE CodeGroupId = @inp_sParam1 AND CodeID IN (508001,508002)
		ORDER BY CodeName

        RETURN 0;
    END 
    
    IF(@inp_iComboType = 25)
	BEGIN
		-- Param1 = CodeGroupId, Param2 = ParentCodeId	
		SELECT GroupId AS ID
		,GroupId AS Value
		FROM tra_NSEGroup 
		ORDER BY GroupId

        RETURN 0;
    END      
   
    
    IF(@inp_iComboType = 30)
	BEGIN
		-- Param1 = CodeGroupId, Param2 = ParentCodeId	
		SELECT CodeID AS ID
		,CodeName AS Value
		FROM com_Code WHERE CodeID IN(508006,508007)
		
        RETURN 0;
	END 
	 
    --List of Restricted List Status-Active/Inactive
    IF(@inp_iComboType = 26)
    BEGIN
		SELECT CodeID AS ID,CodeName AS Value
		FROM com_Code
		WHERE CodeGroupId=511
    END 
    
    -- For Employee Status
    IF(@inp_iComboType = 27)
	BEGIN
		SELECT CodeID AS ID
		,CodeName AS Value
		FROM com_Code 
		WHERE CodeGroupId = @inp_sParam1
		ORDER BY CodeName

        RETURN 0;
    END 
	
	IF(@inp_iComboType = 28)
	BEGIN
	SELECT code.CodeID AS ID,CodeName AS VALUE 
		FROM tra_TransactionTypeSettings TTS 
		JOIN com_Code code ON TTS.MODE_OF_ACQUIS_CODE_ID = code.CodeID
		WHERE MODE_OF_ACQUIS_CODE_ID IN (SELECT MODE_OF_ACQUIS_CODE_ID FROM tra_TransactionTypeSettings WHERE EXEMPT_PRE_FOR_MODE_OF_ACQUISITION=1 GROUP BY MODE_OF_ACQUIS_CODE_ID)
		AND EXEMPT_PRE_FOR_MODE_OF_ACQUISITION = 1 AND TRANS_TYPE_CODE_ID = @inp_sParam2 and SECURITY_TYPE_CODE_ID = @inp_sParam3 GROUP BY CodeID , CodeName
	END	

	IF(@inp_iComboType = 29)
	BEGIN		
			SET @nUserTypeCodeID = 101007
		    SELECT UIRelative.UserInfoId AS ID, ISNULL(UIRelative.FirstName,'') + ISNULL(' '+ UIRelative.LastName,'') + ISNULL(' - '+ UIRelative.PAN, '') +' (' + C.CodeName +')' AS Value  FROM usr_UserInfo UI
			  INNER JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoId
			  INNER JOIN usr_UserInfo UIRelative ON UR.UserInfoIdRelative = UIRelative.UserInfoId
			  INNER JOIN com_Code C ON UR.RelationTypeCodeId = C.CodeID
			  WHERE UIRelative.UserInfoId = @inp_sParam1 		
		RETURN 0;
	END

	IF(@inp_iComboType = 31)
	BEGIN
	SELECT code.CodeID AS ID,CodeName AS VALUE 
		FROM tra_TransactionTypeSettings_OS TTS 
		JOIN com_Code code ON TTS.MODE_OF_ACQUIS_CODE_ID = code.CodeID
		WHERE MODE_OF_ACQUIS_CODE_ID IN (SELECT MODE_OF_ACQUIS_CODE_ID FROM tra_TransactionTypeSettings_OS WHERE EXEMPT_PRE_FOR_MODE_OF_ACQUISITION=1 GROUP BY MODE_OF_ACQUIS_CODE_ID)
		AND EXEMPT_PRE_FOR_MODE_OF_ACQUISITION = 1 AND TRANS_TYPE_CODE_ID = @inp_sParam2 and SECURITY_TYPE_CODE_ID = @inp_sParam3 GROUP BY CodeID , CodeName
	END	

	IF(@inp_iComboType = 32)
	BEGIN
	    SET @nUserTypeCodeID = 101003
		SELECT UIRelative.UserInfoId AS ID, ISNULL(UIRelative.FirstName,'') + ISNULL(' '+ UIRelative.LastName,'') + ISNULL(' - '+ UIRelative.PAN, '') +' (' + C.CodeName +')' AS Value  FROM usr_UserInfo UI
			INNER JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoId
			INNER JOIN usr_UserInfo UIRelative ON UR.UserInfoIdRelative = UIRelative.UserInfoId
			INNER JOIN com_Code C ON UR.RelationTypeCodeId = C.CodeID
			WHERE UI.UserInfoId = @inp_sParam1 
			AND UR.UserInfoIdRelative NOT IN (SELECT UserInfoId FROM tra_TransactionMaster_OS TM WHERE TM.TransactionStatusCodeId <> 148003 AND TM.DisclosureTypeCodeId = 147001 )
		UNION 
		SELECT UserInfoId AS ID , 
			CASE WHEN UserTypeCodeId = @nUserTypeCodeID then ISNULL(FirstName,'') + ISNULL(' ' + LastName,'') + ' - ' + PAN +' (Self)' 
			ELSE cmp.CompanyName + ' - ' + PAN +' (Self)' END AS Value 
			FROM usr_UserInfo uf left join mst_Company cmp on uf.CompanyId = cmp.CompanyId  WHERE UserInfoId = @inp_sParam1
					
	   RETURN 0;
	END	

	IF(@inp_iComboType = 33)
	BEGIN
	    DECLARE @nSecurityTypeCodeId1 NVARCHAR(MAX) = ''
	    
	    DECLARE @nDisclosureType_PeriodEnd1 INT = 147003
	    declare @sSQL1 NVARCHAR(MAX) 
		DECLARE @dtPeriodEndDate1 DATETIME
		DECLARE @nDisclosureTypeCodeId1 INT
		DECLARE @nUserInfoId1 INT
		DECLARE @nTransactionStatusCodeId1 INT
	    print @inp_sParam2
	    --If preclearence not set then check for transaction submitted and display only the accessible security grid.
		IF @inp_sParam2 IS NOT NULL AND @inp_sParam2 <> 0
		BEGIN
			SELECT @nSecurityTypeCodeId1 = CONVERT(varchar(max),SecurityTypeCodeId) FROM tra_PreclearanceRequest_NonImplementationCompany WHERE PreclearanceRequestId = @inp_sParam2
        END
        ELSE
        BEGIN
            -- If transaction submitted then display only the security grid records where transaction details are entered.
			IF @inp_sParam3 IS NOT NULL AND @inp_sParam3 <> 0
			BEGIN
				-- check if disclosure type, in case of period end and submitted fetch all the security type which are traded in period
				SELECT 
					@nUserInfoId1 = UserInfoId, @nDisclosureTypeCodeId1 = DisclosureTypeCodeId, @dtPeriodEndDate1 = PeriodEndDate, 
					@nTransactionStatusCodeId1 = TransactionStatusCodeId
				FROM tra_TransactionMaster_OS WHERE TransactionMasterId = CONVERT(int, @inp_sParam3)
				PRINT(@inp_sParam4)print 'in'
				-- check if transaction is submitted or not 
				IF (@nTransactionStatusCodeId1 NOT IN (148001, 148002) OR @inp_sParam4 IS NOT NULL AND @inp_sParam4 <> 0 )
				BEGIN
					
					if(@inp_sParam4 IS NOT NULL AND @inp_sParam4 <> 0)
					BEGIN					
						SELECT @nSecurityTypeCodeId1 = COALESCE(@nSecurityTypeCodeId1 + ',', '') + CONVERT(varchar(max), tmp.SecurityTypeCodeId) 
						FROM 
						(
							SELECT distinct TD.SecurityTypeCodeId FROM tra_TransactionMaster_OS TM 
							JOIN tra_TransactionDetails_OS TD on TM.TransactionMasterId = TD.TransactionMasterId 
							WHERE 
							--TM.TransactionStatusCodeId <> 148002 AND TM.TransactionStatusCodeId <> 148001 
							--AND 
								(@nDisclosureTypeCodeId1 <> @nDisclosureType_PeriodEnd1 AND TM.TransactionMasterId = CONVERT(int, @inp_sParam3) )
								OR (@nDisclosureTypeCodeId1 = @nDisclosureType_PeriodEnd1 AND TM.PeriodEndDate = @dtPeriodEndDate1)
							AND UserInfoId = @nUserInfoId1 AND TD.SecurityTypeCodeId=@inp_sParam4
						) tmp
					END
					ELSE
					BEGIN
						SELECT @nSecurityTypeCodeId1 = COALESCE(@nSecurityTypeCodeId1 + ',', '') + CONVERT(varchar(max), tmp.SecurityTypeCodeId) 
						FROM 
						(
							SELECT distinct TD.SecurityTypeCodeId FROM tra_TransactionMaster_OS TM 
							JOIN tra_TransactionDetails_OS TD on TM.TransactionMasterId = TD.TransactionMasterId 
							WHERE TM.TransactionStatusCodeId <> 148002 AND TM.TransactionStatusCodeId <> 148001 
							AND 
								(@nDisclosureTypeCodeId1 <> @nDisclosureType_PeriodEnd1 AND TM.TransactionMasterId = CONVERT(int, @inp_sParam3) )
								OR (@nDisclosureTypeCodeId1 = @nDisclosureType_PeriodEnd1 AND TM.PeriodEndDate = @dtPeriodEndDate1)
							AND UserInfoId = @nUserInfoId1
						) tmp
					END
					IF @nSecurityTypeCodeId1 != ''
					BEGIN
							SET @nSecurityTypeCodeId1 = RIGHT(@nSecurityTypeCodeId1, LEN(@nSecurityTypeCodeId1)-1)
					END

				END
			END
			
		END
		print '@nSecurityTypeCodeId1'
		print @nSecurityTypeCodeId1
		if(@nSecurityTypeCodeId1 != '')
		BEGIN
			SET @sSQL1 = 'SELECT CodeID AS ID
								,CASE WHEN DisplayCode IS NULL OR DisplayCode = '''' THEN CodeName ELSE DisplayCode END AS Value
								FROM  com_Code
			      					WHERE CodeGroupId = CONVERT(int,'+@inp_sParam1+')
								AND ('''+isnull(@nSecurityTypeCodeId1,'')+''' = '''' OR CodeID in ('+@nSecurityTypeCodeId1+'))
								ORDER BY CodeID ASC, CASE WHEN DisplayCode IS NULL OR DisplayCode = '''' THEN CodeName ELSE DisplayCode END'
			print @sSQL1
			EXEC (@sSQL1)
			RETURN 0;
		END
	END

	-- List of Transaction Type those are applicable for trading policy.
	IF(@inp_iComboType = 34)
	BEGIN
		SELECT CodeID AS ID,code.CodeName AS VALUE 
		FROM rul_TradingPolicyForTransactionMode_OS TPFM
		JOIN com_Code code ON TPFM.TransactionModeCodeId = code.CodeID 
		WHERE TradingPolicyId = @inp_sParam1 AND MapToTypeCodeId = @inp_sParam2

		RETURN 0;
	END

	-- List of Security Type those are applicable for trading policy while creating preclearance request.
	IF(@inp_iComboType = 35)
	BEGIN
		SELECT code.CodeID AS ID,CodeName AS VALUE  
		FROM rul_TradingPolicyForTransactionSecurity_OS TPFTS
		JOIN com_Code code ON TPFTS.SecurityTypeCodeId = code.CodeID
		WHERE MapToTypeCodeId = 132015
		AND TPFTS.TransactionModeCodeId = @inp_sParam2 AND TradingPolicyId = @inp_sParam1

		RETURN 0;
	END 


		-- List of Security Type those are applicable for trading policy while creating preclearance request.
	IF(@inp_iComboType = 36)
	BEGIN
		
		SELECT	 CodeID AS ID
				,CASE WHEN DisplayCode IS NULL OR DisplayCode = '' THEN CodeName ELSE DisplayCode END AS Value
		FROM	 com_Code
		WHERE CodeGroupId = @inp_sParam1 AND CodeID NOT IN (143003,143004,143005)
			AND (@inp_sParam2 IS NULL OR ParentCodeId = @inp_sParam2)
			AND IsVisible = 1
		--ORDER BY DisplayOrder ASC
		ORDER BY CASE WHEN DisplayCode IS NULL OR DisplayCode = '' THEN CodeName ELSE DisplayCode END

		RETURN 0;
	END 
	
	IF(@inp_iComboType = 40)
	BEGIN	   
		CREATE TABLE #tempUPSI(ID Int, Value NVARCHAR(500))

		INSERT INTO #tempUPSI (ID, Value)
		SELECT UI.UserInfoId AS ID,
		CASE WHEN UI.UserTypeCodeId NOT IN(101007) 
		THEN 
			CASE WHEN UI.FirstName IS NOT NULL 
		THEN 
			CASE WHEN UI.UserTypeCodeId=101001 
		THEN CONCAT(UI.FirstName, ' ',UI.LASTNAME)  
		ELSE
			CONCAT(UI.FirstName, ' ',UI.LASTNAME,' - (', UI.EmployeeId,')') 
		END
			ELSE CONCAT(UI.ContactPerson,' - (',MC.CompanyName,')')
		END 
		ELSE
			CONCAT(UI.FirstName, ' ',UI.LASTNAME,' - (',UI.EmployeeId,')') 
		END AS Value from usr_UserInfo UI INNER JOIN mst_Company MC ON MC.CompanyId=UI.CompanyId 
		WHERE (UI.DateOfSeparation IS NULL OR UI.DateOfSeparation > dbo.uf_com_GetServerDate()) AND UI.StatusCodeId = 102001		
		ORDER BY CASE WHEN FirstName >= 'A' THEN 1 ELSE 0 END DESC,
         FirstName ASC			

		 SELECT ID, Value FROM #tempUPSI ORDER BY CASE WHEN Value >= 'A' THEN 1 ELSE 0 END DESC, Value ASC
		 DROP TABLE #tempUPSI

		RETURN 0;
	END
	IF(@inp_iComboType = 37)
		BEGIN
					Declare @ToQuestion int =0
					Declare @cont int =1
	
					select @ToQuestion=count(*)  from MCQ_QuestionBank

					Create table #tempQestion(countRow  int)
					while (@cont <=@ToQuestion )
					begin
					insert into #tempQestion(countRow)values(@cont)
					if(@inp_sParam1=@cont)
					break;
					  set @cont=@cont+1;
					end

					select countRow as ID,convert(varchar,countRow) As Value from #tempQestion 
					drop table #tempQestion
				
			RETURN 0;
		END 
		IF(@inp_iComboType = 38)
		BEGIN
					Declare @ToalAtempts int =10
					Declare @Tcont int =1

				

					Create table #tempAtempts(countRow  int)
					while (@Tcont <=@ToalAtempts )
					begin
					insert into #tempAtempts(countRow)values(@Tcont)
				
					  set @Tcont=@Tcont+1;
					end

					select countRow as ID,convert(varchar,countRow) As Value from #tempAtempts 
					drop table #tempAtempts
				
			RETURN 0;
		END 
			IF(@inp_iComboType = 39)
		BEGIN
				
					Create table #tempAnswerType(AnswerType  varchar(50))
					insert into #tempAnswerType(AnswerType)
					select 'Radio'
					union
					select 'Checkbox'
					select AnswerType as ID,AnswerType As Value from #tempAnswerType 
					drop table #tempAnswerType
				
			RETURN 0;
		END 
	IF(@inp_iComboType = 41)
	BEGIN	
		SELECT U.UserInfoId AS ID, U.EmployeeId AS Value
		FROM usr_UserInfo U
		WHERE U.UserTypeCodeId IN (101003,101004,101006) AND  U.EmployeeId IS NOT NULL
		ORDER BY  U.UserInfoId
		
		RETURN 0;
	END

	IF(@inp_iComboType = 42)
	BEGIN
		SELECT CodeID AS ID, CodeName AS Value FROM com_Code WHERE CodeGroupId = 531
		RETURN 0;
	END

	IF(@inp_iComboType = 43)
	BEGIN		
		SELECT code.CodeID AS ID, code.CodeName AS Value 
		FROM rul_TradingPolicyForTransactionMode_OS TPFTM 
		JOIN com_Code code ON TPFTM.TransactionModeCodeId = code.CodeID
		WHERE TPFTM.MapToTypeCodeId = @inp_sParam1 AND TradingPolicyId = @inp_sParam2
		RETURN 0;
	END
END
GO