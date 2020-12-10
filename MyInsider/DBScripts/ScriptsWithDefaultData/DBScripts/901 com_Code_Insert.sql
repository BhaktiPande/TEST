/****************   
GroupId: 100
Relation with employee 
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(100, 'Relation with employee', 'Relation with employee', 1, 1)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(100001, 'Parent', 100, 'Relation with employee as parent (Mother / Father)', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(100002, 'Spouse', 100, 'Relation with employee as spouse (Husband / Wife)', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(100003, 'Child', 100, 'Relation with employee as children (Son / Daughter)', 1, 1, GETDATE(), 3)


/****************   
GroupId: 101
User Type
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(101, 'User Type', 'Type of user', 1, 0)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(101001, 'Admin', 101, 'User type - Admin', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(101002, 'CO User', 101, 'User type - Compliance Officer', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(101003, 'Employee', 101, 'User type - Employee', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(101004, 'Corporate User', 101, 'User type - Corporate User', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(101005, 'Super Admin', 101, 'User type - Super Admin', 0, 1, GETDATE(), 5)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(101006, 'Non Employee', 101, 'User type - Non Employee', 1, 1, GETDATE(), 6)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(101007, 'Relative', 101, 'User type - Relative', 1, 1, GETDATE(), 7)

/****************   
GroupId: 102
User active status
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(102, 'User Status', 'Status of user', 1, 0)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(102001, 'Active', 102, 'User Status - Active', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(102002, 'Inactive', 102, 'User Status - Inactive', 1, 1, GETDATE(), 2)

/****************   
GroupId: 103
Resource Module
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(103, 'Resource modules', 'Module under which this resource message falls', 1, 0)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103001, 'CR User', 103, 'Resource Module - CR User', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103002, 'Employee / Insider User', 103, 'Resource Module - Employee / Insider User', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103003, 'Common', 103, 'Resource Module - Common', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103004, 'Master', 103, 'Resource Module - Master', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103005, 'Company Master', 103, 'Resource Module - Company', 1, 1, GETDATE(), 5)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103006, 'Rules', 103, 'Resource Module - Rules', 1, 1, GETDATE(), 6)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103007, 'Roles', 103, 'Resource Module - Roles', 1, 1, GETDATE(), 7)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103008, 'Transaction Data', 103, 'Resource Module - Transaction Data', 1, 1, GETDATE(), 8)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103009, 'Disclosures', 103, 'Resource Module - Disclosures', 1, 1, GETDATE(), 9)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103010, 'Communication Module', 103, 'Resource Module - Communication Module', 1, 1, GETDATE(), 10)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103011, 'Reports Module', 103, 'Resource Module - Report Module', 1, 1, GETDATE(), 11)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(103012, 'Template Module', 103, 'Resource Module - Template Module', 1, 1, GETDATE(), 12)

INSERT INTO [dbo].[com_Code]
([CodeID],[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
VALUES (103013 ,'Mass Upload' ,103 ,'Resource Module - Mass Upload' ,1 ,1 ,13 ,NULL ,NULL ,1 ,GETDATE())



INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
VALUES (103301,'Restricted List',103,'Resource Module - Restricted List',1,1,301,NULL,NULL,1,GETDATE())

/****************   
GroupId: 104
Resource category
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(104, 'Resource category', 'Category of the resource message', 1, 0)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(104001, 'Error message', 104, 'Resource Category - Error message', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(104002, 'Label', 104, 'Resource Category - Label', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(104003, 'Grid', 104, 'Resource Category - Grid', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(104004, 'Button', 104, 'Resource Category - Button', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(104005, 'Tooltip', 104, 'Resource Category - Tooltip', 1, 1, GETDATE(), 5)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(104006, 'Page Title', 104, 'Resource Category - Page Title', 1, 1, GETDATE(), 6)

/****************   
GroupId: 105
Activity status code
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(105, 'Activity Status', 'Status of the user activities defined in the system', 1, 0)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(105001, 'Active', 105, 'Activity status - Active', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(105002, 'Inactive', 105, 'Activity status - Inactive', 1, 1, GETDATE(), 2)

/****************   
GroupId: 106
Role status code
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(106, 'Role Status', 'Status of the roles', 1, 0)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(106001, 'Active', 106, 'Role status - Active', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(106002, 'Inactive', 106, 'Role status - Inactive', 1, 1, GETDATE(), 2)


/****************   
GroupId: 107
Country code
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(107, null, 'Country Master', 'Master for Country', 1, 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(107001, null, 'India', 'Ind', 107, 'Country - India', 1, 1, GETDATE(), 1)



/****************   
GroupId: 108
State code
PArent group = 107: Country
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(108, 107, 'State Master', 'Master for States', 1, 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(108001, 107001, 'Maharashtra', 'MH', 108, 'State - Maharashtra', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(108002, 107001, 'Gujrat', 'GJ', 108, 'State - Gujrat', 1, 1, GETDATE(), 2)

/****************   
GroupId: 109
Designation code
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(109, null, 'Designation Master', 'Master for Designations', 1, 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(109001, null, 'Manager', NULL, 109, 'Designation - Manager', 1, 1, GETDATE(), 1)

/****************   
GroupId: 110
Department code
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(110, null, 'Department Master', 'Master for Department', 1, 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(11000001, null, 'HR', NULL, 110, 'Department - HR', 1, 1, GETDATE(), 1)

/****************   
GroupId: 111
Department code
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(111, null, 'Grade Master', 'Master for Grades', 1, 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(111001, null, 'A', NULL, 111, 'Grade - A', 1, 1, GETDATE(), 1)


/****************   
GroupId: 112
Category Master
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(112, null, 'Category Master', 'Master for Category', 1, 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(112001, null, 'Insider', NULL, 112, 'Category - Insider', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(112002, null, 'Non Insider', NULL, 112, 'Category - Non Insider', 1, 1, GETDATE(), 2)

/****************   
GroupId: 113
Category Master
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(113, 112, 'Sub Category Master', 'Master for Sub Category', 1, 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(113001, 112001, 'Sub Category I', NULL, 113, 'Sub Category - Sub Category I', 1, 1, GETDATE(), 1)


/****************   
GroupId: 114
Grid type for configuration
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(114, null, 'Grid type for configuration', 'Grid type defined for configuration of columns visibility', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114001, null, 'Corporate User List', NULL, 114, 'List of Corporate User', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114002, null, 'Employee / Insider List', NULL, 114, 'Employee / Insider List', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114003, null, 'Activities applicable to logged in user List', NULL, 114, 'Activities applicable to logged in user List', 0, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114004, null, 'Menu List', NULL, 114, 'Menu List', 0, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114005, null, 'DMAT Details List', NULL, 114, 'DMAT Details List', 1, 1, GETDATE(), 5)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114006, null, 'Document List', NULL, 114, 'Document List', 1, 1, GETDATE(), 6)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114007, null, 'Company List', NULL, 114, 'Company List', 1, 1, GETDATE(), 7)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114008, null, 'Code List', NULL, 114, 'Code List', 1, 1, GETDATE(), 8)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114009, null, 'Roles List', NULL, 114, 'Roles List', 1, 1, GETDATE(), 9)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114010, null, 'Relatives List', NULL, 114, 'Relatives List', 1, 1, GETDATE(), 10)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114011, null, 'Face Value List', NULL, 114, 'Face Value List', 1, 1, GETDATE(), 11)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114012, null, 'Authorized capital List', NULL, 114, 'Authorized capital List', 1, 1, GETDATE(), 12)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114013, null, 'Paid Up & Subscribed Share Capital List', NULL, 114, 'Paid Up & Subscribed Share Capital List', 1, 1, GETDATE(), 13)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114014, null, 'Listing details List', NULL, 114, 'Listing details List', 1, 1, GETDATE(), 14)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114015, null, 'Compliance officers List', NULL, 114, 'Compliance officers List', 1, 1, GETDATE(), 15)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114016, null, 'Delegations List', NULL, 114, 'Delegations List', 1, 1, GETDATE(), 16)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114017, null, 'DMAT Account Holder List', NULL, 114, 'DMAT Account Holder List', 1, 1, GETDATE(), 17)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114018, null, 'Label List', NULL, 114, 'Label List', 1, 1, GETDATE(), 18)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114019, null, 'Employee Separation List', NULL, 114, 'Label List', 1, 1, GETDATE(), 19)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114020, null, 'Trading Window Event List For Financial Period', NULL, 114, 'Trading Window Event List For Financial Period', 1, 1, GETDATE(), 20)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114021, null, 'Trading window for other List', NULL, 114, 'Trading window for other List', 1, 1, GETDATE(), 21)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114022, null, 'Policy Document List', NULL, 114, 'Policy Document List', 1, 1, GETDATE(), 22)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114023, null, 'Applicability Search List - Employee', NULL, 114, 'Applicability Search List - Employee', 1, 1, GETDATE(), 23)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114024, null, 'Trading Policy List', NULL, 114, 'Trading Policy List', 1, 1, GETDATE(), 24)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114025, null, 'Trading Policy History List', NULL, 114, 'Trading Policy History List', 1, 1, GETDATE(), 25)

--Applicability list - associated employee
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114026, null, 'Applicability Association - Employee List', NULL, 114, 'Applicability Association - Employee List', 1, 1, GETDATE(), 26)

--Applicability search list - non-employee
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114027, null, 'Applicability Search List - Non Employee', NULL, 114, 'Applicability Search List - Non Employee', 1, 1, GETDATE(), 27)

--Applicability list - associated non-employee
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114028, null, 'Applicability Association - Non Employee List', NULL, 114, 'Applicability Association - Non Employee List', 1, 1, GETDATE(), 28)

--Applicability search list - corporate
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114029, null, 'Applicability Search List - Corporate', NULL, 114, 'Applicability Search List - Corporate', 1, 1, GETDATE(), 29)

--Applicability list - associated corporate
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114030, null, 'Applicability Association - Corporate List', NULL, 114, 'Applicability Association - Corporate List', 1, 1, GETDATE(), 30)

--List transaction data for trading
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114031, null, 'Trading transaction details list', NULL, 114, 'Trading transaction details list', 1, 1, GETDATE(), 31)

--Applicability filter list for filter criteria used during applicability association
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114032, null, 'Applicability association filter list', NULL, 114, 'Applicability association filter list', 1, 1, GETDATE(), 32)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114033, null, 'Policy Document Accept/View status', NULL, 114, 'Policy Document Accept/View status', 1, 1, GETDATE(), 33)

--Policy Document Applicability association list for Corporate users
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114034, null, 'Policy Document Applicability List for Corporate', NULL, 114, 'Policy Document Applicability List for Corporate', 1, 1, GETDATE(), 34)

--Policy Document Applicability association list for NonEmployee users
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114035, null, 'Policy Document Applicability List for NonEmployee', NULL, 114, 'Policy Document Applicability List for NonEmployee', 1, 1, GETDATE(), 35)

--Policy Document Applicability association list for Employee users
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114036, null, 'Policy Document Applicability List for Employee', NULL, 114, 'Policy Document Applicability List for Employee', 1, 1, GETDATE(), 36)

--PeriodEnd disclosure list for insider
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114037, null, 'Period end disclosure list for insider', NULL, 114, 'Period end disclosure list for insider', 1, 1, GETDATE(), 37)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114038, NULL, 'PreClearance Request List', NULL, 114, 'PreClearance Request List for Insider', 1, 1,GETDATE(), 38)

--PeriodEnd disclosure summary for insider
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114039, null, 'Period end disclosure summary for insider', NULL, 114, 'Period end disclosure summary for insider', 1, 1, GETDATE(), 39)

--Template Master List
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114040, null, 'Template master list', NULL, 114, 'Template master list', 1, 1, GETDATE(), 40)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114041,NULL,'Trading Policy Securitywise Limits',NULL,114,'Trading Policy Securitywise Limits',1,1,GETDATE(),41)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114042,NULL,'Transaction details list for letter',NULL,114,'Transaction details list for letter',1,1,GETDATE(),42)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114043,NULL,'Communication rule master list',NULL,114,'Communication rule master list',1,1,GETDATE(),43)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114044,NULL,'Communication rule-modes list for a rule',NULL,114,'Communication rule-modes list for a rule',1,1,GETDATE(),44)

--PeriodEnd disclosure list for insider
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114045, null, 'Period end disclosure list for CO', NULL, 114, 'Period end disclosure list for CO', 1, 1, GETDATE(), 45)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114046, null, 'Continuous disclosure data for letter for Employee Insider', NULL, 114, 'Continuous disclosure data for letter for Employee Insider', 1, 1, GETDATE(), 46)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114047, null, 'Continuous disclosure data for letter for Non Employee Insider', NULL, 114, 'Continuous disclosure data for letter for Non Employee Insider', 1, 1, GETDATE(), 47)

--Initial disclosure list for CO
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114048, null, 'Initial disclosure list for CO', NULL, 114, 'Initial disclosure list for CO', 1, 1, GETDATE(), 48)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114049,NULL,'Continuous disclosure list for CO',NULL,114,'Continuous disclosure list for CO',1,1,GETDATE(),49)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114050,NULL,'Report - Initial disclosure employee wise',NULL,114,'Report - Initial disclosure employee wise',1,1,GETDATE(),50)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114051,NULL,'Communication - list of notifications for a user',NULL,114,'Communication - list of notifications for a user',1,1,GETDATE(),51)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114052,NULL,'Report - Initial disclosure employee individual',NULL,114,'Report - Initial disclosure employee individual',1,1,GETDATE(),52)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114053,NULL,'Report - Period End disclosure employee wise',NULL,114,'Report - Period End disclosure employee wise',1,1,GETDATE(),53)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114054,NULL,'Report - Period End disclosure employee individual',NULL,114,'Report - Period End disclosure employee individual',1,1,GETDATE(),54)

--Applicability search list - CO User
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114055, null, 'Applicability Search List - CO User', NULL, 114, 'Applicability Search List - CO User', 1, 1, GETDATE(), 55)

--Applicability list - associated CO User
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114056, null, 'Applicability Association - CO User', NULL, 114, 'Applicability Association - CO User', 1, 1, GETDATE(), 56)

--Communication - List of Notification - Dashboard
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(114057, null, 'List of Notification - Dashboard', NULL, 114, 'List of Notification - Dashboard', 1, 1, GETDATE(), 57)

-- Period End disclosure employee individual detail
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114058,NULL,'Report - Period End disclosure employee individual detail',NULL,114,'Report - Period End disclosure employee individual detail',1,1,GETDATE(),58)

-- Period End disclosure employee individual detail
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114059,NULL,'Report - Continuous disclosure employee wise',NULL,114,'Report - Continuous disclosure employee wise',1,1,GETDATE(),59)

-- Period End disclosure employee individual detail
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114060,NULL,'Report - Continuous disclosure employee individual',NULL,114,'Report - Continuous disclosure employee individual',1,1,GETDATE(),60)

-- Preclearance employee individual detail
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114061,NULL,'Report - Preclearance employee wise',NULL,114,'Report - Preclearance employee wise',1,1,GETDATE(),61)

-- Preclearance employee individual detail
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114062,NULL,'Report - Preclearance employee individual',NULL,114,'Report - Preclearance employee individual',1,1,GETDATE(),62)

-- Trading Window Event List 
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114063,NULL,'Trading Window Event List',NULL,114,'Trading Window Event List',1,1,GETDATE(),63)

--Overlapping Trading Policy list for users applicable to a particular trading policy
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(114064,NULL,'Overlapping trading policy list for users of a trading policy',NULL,114,'Overlapping trading policy list for users of a trading policy',1,1,GETDATE(),64)

Insert into com_Code (CodeID, CodeName, CodeGroupId, "Description", IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
values
(114071, 'Trading transaction details list - Initial Disclosure - Insider', 114, 'Trading transaction details list - Initial Disclosure', 1, 1, 65, null, null, 1, GETDATE())
,(114066, 'Trading transaction details list - Continuous Disclosure - Insider', 114, 'Trading transaction details list - Continuous Disclosure', 1, 1, 66, null, null, 1, GETDATE())
,(114067, 'Trading transaction details list - Period End Disclosure - Insider', 114, 'Trading transaction details list - Period End Disclosure - Insider', 1, 1, 67, null, null, 1, GETDATE())
,(114068, 'Trading transaction details list - Initial Disclosure - CO', 114, 'Trading transaction details list - Initial Disclosure - CO', 1, 1, 68, null, null, 1, GETDATE())
,(114069, 'Trading transaction details list - Continuous Disclosure - CO', 114, 'Trading transaction details list - Continuous Disclosure - CO', 1, 1, 69, null, null, 1, GETDATE())
,(114070, 'Trading transaction details list - Period End Disclosure - CO', 114, 'Trading transaction details list - Period End Disclosure - CO', 1, 1, 70, null, null, 1, GETDATE())

-- Add Grid Type for DMAT to overwrite existing Grid
INSERT INTO com_Code 
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
VALUES 
	(114072, 'Corporate DMAT Details List', 114, 'Corporate DMAT Details List', 1, 1, 72, NULL, NULL, 1, GETDATE()),
	(114073, 'Corporate DMAT Holder Details List', 114, 'Corporate DMAT Holder Details List', 1, 1, 73, NULL, NULL, 1, GETDATE()),
	(114074, 'Relative DMAT Details List', 114, 'Relative DMAT Details List', 1, 1, 74, NULL, NULL, 1, GETDATE()),
	(114075, 'Relative DMAT Holder Details List', 114, 'Relative DMAT Holder Details List', 1, 1, 75, NULL, NULL, 1, GETDATE())

-- Script sent by Parag on 26th Aug 2015
-- Add Grid Type for Pre-clearance 
INSERT INTO com_Code 
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
VALUES 
	(114076, 'Pre-clearance Details CO List', 114, 'Pre-clearance Details CO  List', 1, 1, 76, NULL, NULL, 1, GETDATE()),
	(114077, 'Pre-clearance Details Insider List', 114, 'Pre-clearance Details Insider List', 1, 1, 77, NULL, NULL, 1, GETDATE())

INSERT INTO com_Code (CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES (114078,NULL,'Non Complaince Report',NULL,114,'Non Complaince Report (Defaulter List)',1,1,GETDATE(),78)

-- Added on 13-Oct-2015, received from KPCS for restricted list code merging
-- Code 114076(from KPCS) is changed to 114079, since 114076 was already used by SC
INSERT INTO com_Code (CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
VALUES (114079,'Restricted List Details List',114,'Restricted List Details List',1,1,79,NULL,NULL,1,GETDATE())

/* Script sent on 27-Nov-2015, by Raghvendra */
/*Changes for Form B*/
--Entry in com_Code for New Grid
INSERT INTO com_Code (CodeID ,CodeName ,CodeGroupId ,Description ,IsVisible ,IsActive ,DisplayOrder ,DisplayCode ,ParentCodeId ,ModifiedBy ,ModifiedOn)
VALUES (114080,'Initial Disclosure list for letter Grid2' ,114 ,'Transaction details list for letter Grid2' ,1 ,1 ,80 ,NULL ,NULL ,1 ,GETDATE())

INSERT INTO com_Code (CodeID ,CodeName ,CodeGroupId ,Description ,IsVisible ,IsActive ,DisplayOrder ,DisplayCode ,ParentCodeId ,ModifiedBy ,ModifiedOn)
VALUES (114081,'Continuous disclosure data for letter for Employee Insider Grid2' ,114 ,'Continuous disclosure data for letter for Employee Insider Grid2' ,1 ,1 ,81 ,NULL ,NULL ,1 ,GETDATE())

INSERT INTO com_Code (CodeID ,CodeName ,CodeGroupId ,Description ,IsVisible ,IsActive ,DisplayOrder ,DisplayCode ,ParentCodeId ,ModifiedBy ,ModifiedOn)
VALUES (114082,'Continuous disclosure data for letter for Non Employee Insider Grid2' ,114 ,'Continuous disclosure data for letter for Non Employee Insider Grid2' ,1 ,1 ,82 ,NULL ,NULL ,1 ,GETDATE())

/*
Added by : Raghvendra Date : 5-Apr-2016
Adding the override grids for Transaction data grids seen on the Create Letter screen.

Enter new grid types for Disclosure letters for CO and Insider
*/
INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
VALUES 
(114083 ,'Trading transaction details for Letter - Continuous Disclosure - Insider' ,114 ,'Trading transaction details for Letter - Continuous Disclosure - Insider' ,1 ,1 ,83 ,NULL ,NULL ,1 ,GETDATE()),
(114084 ,'Trading transaction details for Letter - Period End Disclosure - Insider' ,114 ,'Trading transaction details for Letter - Period End Disclosure - Insider' ,1 ,1 ,84 ,NULL ,NULL ,1 ,GETDATE()),
(114085 ,'Trading transaction details for Letter - Initial Disclosure - CO' ,114,'Trading transaction details for Letter - Initial Disclosure - CO'  ,1 ,1 ,85 ,NULL ,NULL ,1 ,GETDATE()),
(114086 ,'Trading transaction details for Letter - Continuous Disclosure - CO' ,114 ,'Trading transaction details for Letter - Continuous Disclosure - CO'  ,1 ,1 ,86 ,NULL ,NULL ,1 ,GETDATE()),
(114087 ,'Trading transaction details for Letter - Period End Disclosure - CO' ,114 ,'Trading transaction details for Letter - Period End Disclosure - CO'  ,1 ,1 ,87 ,NULL ,NULL ,1 ,GETDATE()),
(114088 ,'Trading transaction details for Letter - Initial Disclosure - Insider' ,114 ,'Trading transaction details for Letter - Initial Disclosure - Insider'  ,1 ,1 ,88 ,NULL ,NULL ,1 ,GETDATE())

/*
Script received from Gaurishankar on 12 May 2016 -  Code Grid Ids for applicability.
*/
INSERT INTO com_Code(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
VALUES
(114089, 'Applicability Search List - Employee', 114, 'Applicability Search List - Employee', 1, 1, 89, NULL, NULL, 1, GETDATE()),
(114090, 'Applicability association Employee filter list',114,'Applicability association Employee filter list',1,1,90,NULL,NULL,1,GETDATE()),
(114091, 'Applicability Association - Non Insider Employee List', 114, '0Applicability Association - Non Insider Employee List', 1, 1, 91, NULL, NULL, 1, GETDATE())

/*
Script from Parag on 16 May 2016 -  new grid type for employee details for policy document list
*/
INSERT INTO com_Code 
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
VALUES
	(114092, 'Policy Document Applicability List for Employee NOT Insider', 114, 'Policy Document Applicability List for Employee NOT Insider', 1, 1, 92, NULL, NULL, 1, GETDATE())



/****************   
GroupId: 115
Listing Status for companies
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(115, null, 'Listing Status', 'Listing status - Listed / Unlisted', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(115001, null, 'Listed', NULL, 115, 'Listing Status - Listed', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(115002, null, 'Unlisted', NULL, 115, 'Listing Status - Unlisted', 1, 1, GETDATE(), 2)


/****************   
GroupId: 116
Stock Exchange Master
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(116, null, 'Stock Exchange Master', 'Master of Stock Exchanges', 1, 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(116001, null, 'National Stock Exchange of India Ltd.', 'NSE', 116, 'National Stock Exchange of India Ltd.', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(116002, null, 'Bombay Stock Exchange', 'BSE Ltd.', 116, 'Bombay Stock Exchange', 1, 1, GETDATE(), 2)

/****************   
GroupId: 117
Stock Exchange Master
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(117, null, 'Currency Master', 'Master of Currency', 1, 1)

/****************   
GroupId: 118
Sub-Designation Master (PArent group is Designation 109)
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(118, 109, 'Sub-Designation Master', 'Master of Sub-Designation', 1, 1)


/****************   
GroupId: 119
Designation Master (Auto help)
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(119, null, 'Designation Master For Auto Help', 'Designation Master For Auto Help', 1, 1)

/****************   
GroupId: 120
DP Name (Auto help)
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(120, null, 'DP Name Master For Auto Help', 'DP Name Master For Auto Help', 1, 1)

/****************   
GroupId: 121
DMAT account type
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(121, null, 'DMAT account type', 'DMAT account type', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(121001, null, 'Single', null, 121, 'DMAT account type - Single', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(121002, null, 'Joint', null, 121, 'DMAT account type - Joint', 1, 1, GETDATE(), 2)


/****************   
GroupId: 122
Screen Code
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(122, null, 'Screen Code', 'Screen Code', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122001, null, 'CO User List', null, 122, 'Screen - CO User List', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122002, null, 'CO User Details', null, 122, 'Screen - CO User Details', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122003, null, 'Insider User List', null, 122, 'Screen - Insider User List', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122004, null, 'Insider User Details', null, 122, 'Screen - Insider User List', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122005, null, 'Role List', null, 122, 'Screen - Role List', 1, 1, GETDATE(), 5)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122006, null, 'Role Details', null, 122, 'Screen - Role Details', 1, 1, GETDATE(), 6)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122007, null, 'DMAT List', null, 122, 'Screen - DMAT List', 1, 1, GETDATE(), 7)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122008, null, 'DMAT Details', null, 122, 'Screen - DMAT Details', 1, 1, GETDATE(), 8)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122009, null, 'Document List', null, 122, 'Screen - Document List', 1, 1, GETDATE(), 9)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122010, null, 'Document Details', null, 122, 'Screen - Document Details', 1, 1, GETDATE(), 10)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122011, null, 'Company List', null, 122, 'Screen - Company List', 1, 1, GETDATE(), 11)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122012, null, 'Company Details', null, 122, 'Screen - Company Details', 1, 1, GETDATE(), 12)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122013, null, 'Other Masters List', null, 122, 'Screen - Other Masters List', 1, 1, GETDATE(), 13)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122014, null, 'Other Masters Details', null, 122, 'Screen - Other Masters Details', 1, 1, GETDATE(), 14)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122015, null, 'Relatives List', null, 122, 'Screen - Relatives List', 1, 1, GETDATE(), 15)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122016, null, 'Relatives Details', null, 122, 'Screen - Relatives Details', 1, 1, GETDATE(), 16)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122017, null, 'Face Value List', null, 122, 'Screen - Face Value List', 1, 1, GETDATE(), 17)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122018, null, 'Face Value Details', null, 122, 'Screen - Face Value Details', 1, 1, GETDATE(), 18)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122019, null, 'Authorized capital List', null, 122, 'Screen - Authorized capital List', 1, 1, GETDATE(), 19)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122020, null, 'Authorized capital Details', null, 122, 'Screen - Authorized capital Details', 1, 1, GETDATE(), 20)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122021, null, 'Paid Up & Subscribed Share Capital List', null, 122, 'Screen - Paid Up & Subscribed Share Capital List', 1, 1, GETDATE(), 21)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122022, null, 'Paid Up & Subscribed Share Capital Details', null, 122, 'Screen - Paid Up & Subscribed Share Capital Details', 1, 1, GETDATE(), 22)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122023, null, 'Listing Details List', null, 122, 'Screen - Listing Details List', 1, 1, GETDATE(), 23)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122024, null, 'Listing Details Details', null, 122, 'Screen - Listing Details Details', 1, 1, GETDATE(), 24)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122025, null, 'Compliance Officers List', null, 122, 'Screen - Compliance Officers List', 1, 1, GETDATE(), 25)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122026, null, 'Compliance Officers Details', null, 122, 'Screen - Compliance Officers Details', 1, 1, GETDATE(), 26)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122027, null, 'Delegation List', null, 122, 'Screen - Delegation List', 1, 1, GETDATE(), 27)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122028, null, 'Delegation Details', null, 122, 'Screen - Delegation Details', 1, 1, GETDATE(), 28)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122029, null, 'DMAT Account Holder List', null, 122, 'Screen - DMAT Account Holder List', 1, 1, GETDATE(), 29)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122030, null, 'DMAT Account Holder Details', null, 122, 'Screen - DMAT Account Holder Details', 1, 1, GETDATE(), 30)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122031, null, 'Resource Messages List', null, 122, 'Screen - Resource Messages List', 1, 1, GETDATE(), 31)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122032, null, 'Resource Message Details', null, 122, 'Screen - Resource Message Details', 1, 1, GETDATE(), 32)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122033, null, 'Employee Separation List', null, 122, 'Screen - Employee Separation List', 1, 1, GETDATE(), 33)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122034, null, 'Common for application', null, 122, 'Screen - Common for application', 1, 1, GETDATE(), 34)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122035, null, 'Trading Window Event - Financial Period', null, 122, 'Screen - Trading Window Event - Financial Period', 1, 1, GETDATE(), 35)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122036, 103008, 'Transaction Details List', null, 122, 'Screen - Transaction Details List', 1, 1, GETDATE(), 36)

--Screens under module Set Rules(CodeID : 103006)
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122037, 103006, 'Policy Document List', null, 122, 'Screen - Policy Document List', 1, 1, GETDATE(), 37)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122038, 103006, 'Policy Document Details', null, 122, 'Screen - Policy Document Details', 1, 1, GETDATE(), 38)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122039, 103006, 'Trading Policy List', null, 122, 'Screen - Trading Policy List', 1, 1, GETDATE(), 39)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122040, 103006, 'Trading Policy Details', null, 122, 'Screen - Trading Policy Details', 1, 1, GETDATE(), 40)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122041, 103006, 'Applicability', null, 122, 'Screen - Applicability', 1, 1, GETDATE(), 41)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122042, 103006, 'Trading Window Event - Calender', null, 122, 'Screen - Trading Window Event - Calender', 1, 1, GETDATE(), 42)

--Screen code for CO interface: Transaction-->Policy Document
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122043, 103008, 'Policy Document view-agree user status list', null, 122, 'Screen - Policy Document view-agree user status list', 1, 1, GETDATE(), 43)

--Screen code for disclosure statuses
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122044, 103009, 'Disclosre statuses', null, 122, 'Screen - Disclosre statuses', 1, 1, GETDATE(), 44)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122045, null, 'Trading Window Event - Other', null, 122, 'Screen - Trading Window Event - Other', 1, 1, GETDATE(), 45)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, 
IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122046, NULL, 'PreClearance Request List', NULL, 122, 'Screen - PreClearance Request List', 1, 1, GETDATE(), 46)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, 
IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122047, NULL, 'Period End Disclosure Status List', NULL, 122, 'Screen - Period End Disclosure Status List', 1, 1, GETDATE(), 47)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, 
IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122048, NULL, 'Period End Summary', NULL, 122, 'Screen - Period End Summary', 1, 1, GETDATE(), 48)

--Template master list screen
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, 
IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122049, NULL, 'Template master list', NULL, 122, 'Screen - Template master list', 1, 1, GETDATE(), 49)

--Template master details screen
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, 
IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122050, NULL, 'Template master details', NULL, 122, 'Screen - Template master details', 1, 1, GETDATE(), 50)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(122051,NULL,'PreClearance Request Details',NULL,122,'Screen - PreClearance Request Details',1,1,GETDATE(),51)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(122052,NULL,'Transaction Letter',NULL,122,'Screen - Transaction Letter',1,1,GETDATE(),52)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(122053,NULL,'Communication Rule List',NULL,122,'Screen - Communication Rule List',1,1,GETDATE(),53)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(122054,NULL,'Communication Rule Details',NULL,122,'Screen - Communication Rule Details',1,1,GETDATE(),54)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, 
IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122055, NULL, 'Period End Disclosure Status List for CO', NULL, 122, 'Screen - Period End Disclosure Status List for CO', 1, 1, GETDATE(), 55)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, 
IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122056, NULL, 'Initial Disclosure Status List for CO', NULL, 122, 'Screen - Initial Disclosure Status List for CO', 1, 1, GETDATE(), 56)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(122057,NULL,'Continuous Disclosure Status List for CO',NULL,122,'Screen - Continuous Disclosure Status List for CO',1,1,GETDATE(),57)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(122058,NULL,'Reports',NULL,122,'Screen - Reports',1,1,GETDATE(),58)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(122059,NULL,'Communication Notification list',NULL,122,'Screen - Communication Notification list',1,1,GETDATE(),59)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(122060,NULL,'Period End Disclosure Reports',NULL,122,'Screen - Period End Disclosure Reports',1,1,GETDATE(),60)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(122061,NULL,'Initial Disclosure Reports',NULL,122,'Screen - Initial Disclosure Reports',1,1,GETDATE(),61)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(122062,NULL,'Continuous Disclosure Reports',NULL,122,'Screen - Continuous Disclosure Reports',1,1,GETDATE(),62)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(122063,NULL,'Preclearance Reports',NULL,122,'Screen - Preclearance Reports',1,1,GETDATE(),63)

INSERT into com_Code 
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(122064,103001,'User Forgot Password',NULL,122,'User Forgot Password',1,1,GETDATE(),64)



Insert into com_Code (CodeID, CodeName, CodeGroupId, "Description", IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
values
(122071, 'Transaction Details List - Initial Disclosure for Insider', 122, 'Transaction Details List - Initial Disclosure for Insider', 1, 1, 65, null, 103008, 1, GETDATE())
,(122066, 'Transaction Details List - Continuous Disclosure for Insider', 122, 'Transaction Details List - Continuous Disclosure for Insider', 1, 1, 66, null, 103008, 1, GETDATE())
,(122067, 'Transaction Details List - Period End Disclosure for Insider', 122, 'Transaction Details List - Period End Disclosure for Insider', 1, 1, 67, null, 103008, 1, GETDATE())
,(122068, 'Transaction Details List - Initial Disclosure for CO', 122, 'Transaction Details List - Initial Disclosure for CO', 1, 1, 68, null, 103008, 1, GETDATE())
,(122069, 'Transaction Details List - Continuous Disclosure for CO', 122, 'Transaction Details List - Continuous Disclosure for CO', 1, 1, 69, null, 103008, 1, GETDATE())
,(122070, 'Transaction Details List - Period End Disclosure for CO', 122, 'Transaction Details List - Period End Disclosure for CO', 1, 1, 70, null, 103008, 1, GETDATE()) 

-- Script sent by PArag on 31-Jul-2015
INSERT INTO com_Code 
(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
VALUES 
(122065, 'Corporate User Details', 122, 'Screen - Corporate User Details', 1, 1, 71, NULL, 103002, 1, GETDATE()),
(122072, 'Corporate User DMAT Details', 122, 'Screen - Corporate User DMAT Details', 1, 1, 72, NULL, 103002, 1, GETDATE())

--Sent by Parag on 5-Aug-2015
INSERT INTO com_Code (CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
VALUES (122073, 'Relative DMAT Details', 122, 'Screen - Relative DMAT Details', 1, 1, 73, NULL, 103002, 1, GETDATE())

-- Sent by GS on 10-Sep-2015
INSERT INTO com_Code (CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
VALUES (122074, 'CO Dashboard', 122, 'Screen - CO DAshboard', 1, 1, 74, NULL, 103001, 1, GETDATE())      
    

INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,Description,IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
VALUES (122075,'Non Complaince Report',122,'Screen - Non Complaince Report',1,1,75,NULL,103011,1,GETDATE())

INSERT INTO com_Code (CODEID,CODENAME,CODEGROUPID,[DESCRIPTION],ISVISIBLE,ISACTIVE,DISPLAYORDER,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
VALUES (122076,'Restricted List',122,'Rules - Restricted List',1,1,76,NULL,103006,1,GETDATE())

/*
Added by : Raghvendra Date : 5-Apr-2016
Adding the override grids for Transaction data grids seen on the Create Letter screen.

Enter new screen codes for the Transaction Data for Letter screen
*/
INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
VALUES 
(122077 ,'Trading transaction details for Letter - Continuous Disclosure - Insider' ,122 ,'Screen - Trading transaction details for Letter - Continuous Disclosure - Insider' ,1 ,1 ,89 ,NULL ,103008 ,1 ,GETDATE()),
(122078 ,'Trading transaction details for Letter - Period End Disclosure - Insider' ,122 ,'Screen - Trading transaction details for Letter - Period End Disclosure - Insider' ,1 ,1 ,90 ,NULL ,103008 ,1 ,GETDATE()),
(122079 ,'Trading transaction details for Letter - Initial Disclosure - CO' ,122,'Screen - Trading transaction details for Letter - Initial Disclosure - CO'  ,1 ,1 ,91 ,NULL ,103008 ,1 ,GETDATE()),
(122080 ,'Trading transaction details for Letter - Continuous Disclosure - CO' ,122 ,'Screen - Trading transaction details for Letter - Continuous Disclosure - CO'  ,1 ,1 ,92 ,NULL ,103008 ,1 ,GETDATE()),
(122081 ,'Trading transaction details for Letter - Period End Disclosure - CO' ,122 ,'Screen - Trading transaction details for Letter - Period End Disclosure - CO'  ,1 ,1 ,93 ,NULL ,103008 ,1 ,GETDATE()),
(122082 ,'Trading transaction details for Letter - Initial Disclosure - Insider' ,122 ,'Screen - Trading transaction details for Letter - Initial Disclosure - Insider'  ,1 ,1 ,94 ,NULL ,103008 ,1 ,GETDATE())


/*
Scripts received from Raghvendra on 13-Apr-2016
Scripts for adding the resources for the button text, labels and messages seen on Insider Dashboard screen
*/
INSERT INTO com_Code (CodeId, CodeName,CodeGroupId,Description, IsVisible, IsActive, DisplayOrder,DisplayCode,ParentCodeId, ModifiedBy, ModifiedOn)
VALUES
(122083, 'Insider Dashboard',122,'Screen - Insider Dashboard', 1, 1, 95, NULL, 103008, 1, GETDATE())





UPDATE com_CodeGroup SET ParentCodeGroupId = 103 where CodeGroupID = 122
UPDATE com_Code SET ParentCodeId = 103001 where CodeID IN (122001, 122002/*, 122005, 122006, 122027, 122028*/, 122064)
UPDATE com_Code SET ParentCodeId = 103002 where CodeID IN (122003, 122004, 122007, 122008, 122009, 122010, 122015, 122016, 122029, 122030, 122033)
UPDATE com_Code SET ParentCodeId = 103003 where CodeID IN (122034)
UPDATE com_Code SET ParentCodeId = 103004 where CodeID IN (122013, 122014, 122031, 122032)
UPDATE com_Code SET ParentCodeId = 103005 where CodeID IN (122011, 122012, 122017, 122018, 122019, 122020, 122021, 122022, 122023, 122024, 122025, 122026)
UPDATE com_Code SET ParentCodeId = 103006 where CodeID IN (122035, 122045, 122049, 122050)
UPDATE com_Code SET ParentCodeId = 103007 where CodeID IN (122005, 122006, 122027, 122028)
UPDATE com_Code SET ParentCodeId = 103008 where CodeID IN (122036)
UPDATE com_Code SET ParentCodeId = 103009 where CodeID IN (122046, 122047, 122048, 122051, 122052, 122055, 122056, 122057) /*Module: Disclosures*/
UPDATE com_Code SET ParentCodeId = 103010 where CodeID IN (122053, 122054, 122059) /*Module: Communication Module*/  
UPDATE com_Code SET ParentCodeId = 103011 where CodeID IN (122058, 122060, 122061, 122062, 122063)

/****************   
GroupId: 123
Financial Period Type
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(123, null, 'Financial Period Type', 'Financial Period Type', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(123001, null, 'Annual', null, 123, 'Financial Period Type - Annual', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(123002, null, 'Half Yearly', null, 123, 'Financial Period Type - Half Yearly', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(123003, null, 'Quarterly', null, 123, 'Financial Period Type - Quarterly', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(123004, null, 'Monthly', null, 123, 'Financial Period Type - Monthly', 1, 1, GETDATE(), 4)

/****************   
GroupId: 124
Financial Period (ParentCodeGroupId = 123)
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(124, 123, 'Financial Period', 'Financial Period', 1, 0)


INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(124001, 123001, 'A1', 'Year', 124, '1-Apr-1971', 1, 1, GETDATE(), 1),

(124002, 123002, 'H1', 'Half year 1', 124, '1-Oct-1970', 1, 1, GETDATE(), 2),
(124003, 123002, 'H2', 'Half Year 2', 124, '1-Apr-1971', 1, 1, GETDATE(), 3),

(124004, 123003, 'Q1', 'Quater 1', 124, '1-Jul-1970', 1, 1, GETDATE(), 4),
(124005, 123003, 'Q2', 'Quater 2', 124, '1-Oct-1970', 1, 1, GETDATE(), 5),
(124006, 123003, 'Q3', 'Quater 3', 124, '1-Jan-1971', 1, 1, GETDATE(), 6),
(124007, 123003, 'Q4', 'Quater 4', 124, '1-Apr-1971', 1, 1, GETDATE(), 7),

(124008, 123004, 'M1', 'April', 124, '1-May-1970', 1, 1, GETDATE(), 8),
(124009, 123004, 'M2', 'May', 124, '1-Jun-1970', 1, 1, GETDATE(), 9),
(124010, 123004, 'M3', 'June', 124, '1-Jul-1970', 1, 1, GETDATE(), 10),
(124011, 123004, 'M4', 'July', 124, '1-Aug-1970', 1, 1, GETDATE(), 11),
(124012, 123004, 'M5', 'August', 124, '1-Sep-1970', 1, 1, GETDATE(), 12),
(124013, 123004, 'M6', 'September', 124, '1-Oct-1970', 1, 1, GETDATE(), 13),
(124014, 123004, 'M7', 'October', 124, '1-Nov-1970', 1, 1, GETDATE(), 14),
(124015, 123004, 'M8', 'November', 124, '1-Dec-1970', 1, 1, GETDATE(), 15),
(124016, 123004, 'M9', 'December', 124, '1-Jan-1971', 1, 1, GETDATE(), 16),
(124017, 123004, 'M10', 'January', 124, '1-Feb-1971', 1, 1, GETDATE(), 17),
(124018, 123004, 'M11', 'February', 124, '1-Mar-1971', 1, 1, GETDATE(), 18),
(124019, 123004, 'M12', 'March', 124, '1-Apr-1971', 1, 1, GETDATE(), 19)

/****************   
GroupId: 125
Financial Year (ParentCodeGroupId = 123)
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(125, 123, 'Financial Year', 'Financial Year', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(125001, NULL, '2014-15', null, 125, '2014-15',1, 1, GETDATE(), 1),
(125002, NULL, '2015-16', null, 125, '2015-16',1, 1, GETDATE(), 2),
(125003, NULL, '2016-17', null, 125, '2016-17',1, 1, GETDATE(), 3),
(125004, NULL, '2017-18', null, 125, '2017-18',1, 1, GETDATE(), 4),
(125005, NULL, '2018-19', null, 125, '2018-19',1, 1, GETDATE(), 5),
(125006, NULL, '2019-20', null, 125, '2019-20',1, 1, GETDATE(), 6),
(125007, NULL, '2020-21', null, 125, '2020-21',1, 1, GETDATE(), 7),
(125008, NULL, '2021-22', null, 125, '2021-22',1, 1, GETDATE(), 8),
(125009, NULL, '2022-23', null, 125, '2022-23',1, 1, GETDATE(), 9),
(125010, NULL, '2023-24', null, 125, '2023-24',1, 1, GETDATE(), 10),
(125011, NULL, '2024-25', null, 125, '2024-25',1, 1, GETDATE(), 11),
(125012, NULL, '2025-26', null, 125, '2025-26',1, 1, GETDATE(), 12),
(125013, NULL, '2026-27', null, 125, '2026-27',1, 1, GETDATE(), 13),
(125014, NULL, '2027-28', null, 125, '2027-28',1, 1, GETDATE(), 14),
(125015, NULL, '2028-29', null, 125, '2028-29',1, 1, GETDATE(), 15),
(125016, NULL, '2029-30', null, 125, '2029-30',1, 1, GETDATE(), 16),
(125017, NULL, '2030-31', null, 125, '2030-31',1, 1, GETDATE(), 17),
(125018, NULL, '2031-32', null, 125, '2031-32',1, 1, GETDATE(), 18),
(125019, NULL, '2032-33', null, 125, '2032-33',1, 1, GETDATE(), 19),
(125020, NULL, '2033-34', null, 125, '2033-34',1, 1, GETDATE(), 20),
(125021, NULL, '2034-35', null, 125, '2034-35',1, 1, GETDATE(), 21),
(125022, NULL, '2035-36', null, 125, '2035-36',1, 1, GETDATE(), 22),
(125023, NULL, '2036-37', null, 125, '2036-37',1, 1, GETDATE(), 23),
(125024, NULL, '2037-38', null, 125, '2037-38',1, 1, GETDATE(), 24),
(125025, NULL, '2038-39', null, 125, '2038-39',1, 1, GETDATE(), 25),
(125026, NULL, '2039-40', null, 125, '2039-40',1, 1, GETDATE(), 26),
(125027, NULL, '2040-41', null, 125, '2040-41',1, 1, GETDATE(), 27),
(125028, NULL, '2041-42', null, 125, '2041-42',1, 1, GETDATE(), 28),
(125029, NULL, '2042-43', null, 125, '2042-43',1, 1, GETDATE(), 29),
(125030, NULL, '2043-44', null, 125, '2043-44',1, 1, GETDATE(), 30),
(125031, NULL, '2044-45', null, 125, '2044-45',1, 1, GETDATE(), 31),
(125032, NULL, '2045-46', null, 125, '2045-46',1, 1, GETDATE(), 32),
(125033, NULL, '2046-47', null, 125, '2046-47',1, 1, GETDATE(), 33),
(125034, NULL, '2047-48', null, 125, '2047-48',1, 1, GETDATE(), 34),
(125035, NULL, '2048-49', null, 125, '2048-49',1, 1, GETDATE(), 35),
(125036, NULL, '2049-50', null, 125, '2049-50',1, 1, GETDATE(), 36),
(125037, NULL, '2050-51', null, 125, '2050-51',1, 1, GETDATE(), 37),
(125038, NULL, '2051-52', null, 125, '2051-52',1, 1, GETDATE(), 38),
(125039, NULL, '2052-53', null, 125, '2052-53',1, 1, GETDATE(), 39),
(125040, NULL, '2053-54', null, 125, '2053-54',1, 1, GETDATE(), 40),
(125041, NULL, '2054-55', null, 125, '2054-55',1, 1, GETDATE(), 41),
(125042, NULL, '2055-56', null, 125, '2055-56',1, 1, GETDATE(), 42),
(125043, NULL, '2056-57', null, 125, '2056-57',1, 1, GETDATE(), 43),
(125044, NULL, '2057-58', null, 125, '2057-58',1, 1, GETDATE(), 44),
(125045, NULL, '2058-59', null, 125, '2058-59',1, 1, GETDATE(), 45),
(125046, NULL, '2059-60', null, 125, '2059-60',1, 1, GETDATE(), 46),
(125047, NULL, '2060-61', null, 125, '2060-61',1, 1, GETDATE(), 47),
(125048, NULL, '2061-62', null, 125, '2061-62',1, 1, GETDATE(), 48),
(125049, NULL, '2062-63', null, 125, '2062-63',1, 1, GETDATE(), 49),
(125050, NULL, '2063-64', null, 125, '2063-64',1, 1, GETDATE(), 50)

/****************   
GroupId: 126
Trading Window Event Type
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(126, NULL, 'Trading Window Event Type', 'Trading Window Event Type', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(126001, NULL, 'Financial Result', null, 126, 'Trading Window Event Type - Financial Result', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(126002, NULL, 'Other', null, 126, 'Trading Window Event Type - Other', 1, 1, GETDATE(), 2)

/****************   
GroupId: 127
Trading Window Event
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(127, NULL, 'Trading Window Event', 'Trading Window Event', 1, 1)

/****************   
GroupId: 128
Configuration values
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(128, NULL, 'Configuration Values', 'Configuration Values', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(128001, NULL, '24', null, 128, 'No of hours the reset password link is valid for', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(128002, NULL, '123003', null, 128, 'Period type for company', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(128003, NULL, '2015-05-01', null, 128, 'System Implementation date (YYYY-MM-DD)', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(128004, NULL, 'http://emergeboi/InsiderTrading/Account/ForgetPassword', null, 128, 'System startup URL that will replace the placeholder |~|APP_URL|~| used in welcome user email notification', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(128005, NULL, '90', NULL, 128, 'No of days to be Active after date of sepration for the Employee Insider', 1, 1, GETDATE(), 5)


/****************   
GroupId: 129
Policy Document Category
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(129, NULL, 'Policy Document Category', 'Policy Document Category', 1, 1)

/****************   
GroupId: 130
Policy Document SubCategory
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(130, 129, 'Policy Document SubCategory', 'Policy Document SubCategory', 1, 1)

/****************   
GroupId: 131
Policy Document Window Status
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(131, null, 'Policy Document Window Status', 'Policy Document Window Status', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(131001, NULL, 'Incomplete', null, 131, 'Policy Document Window Status - Incomplete', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(131002, NULL, 'Active', null, 131, 'Policy Document Window Status - Active', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(131003, NULL, 'Inactive', null, 131, 'Policy Document Window Status - Inactive', 1, 1, GETDATE(), 3)

/****************   
GroupId: 132
Map to type
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(132, null, 'Map to Type', 'Map To Type for document, applicability', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(132001, NULL, 'Policy Document', null, 132, 'Map To Type - Policy Document', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(132002, NULL, 'Trading Policy', null, 132, 'Map To Type - Trading Policy', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(132003, NULL, 'User', null, 132, 'Map To Type - User', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(132004, NULL, 'Preclearance', null, 132, 'Map To Type - Preclearance', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(132005, NULL, 'Disclosure Transaction', null, 132, 'Map To Type - Disclosure Transaction', 1, 1, GETDATE(), 5)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(132006, NULL, 'Communication Rule', null, 132, 'Map To Type - Communication Rule', 1, 1, GETDATE(), 6)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(132007, NULL, 'Prohibit Preclearance during non-trading', null, 132, 'Map To Type - Prohibit Preclearance during non-trading', 1, 1, GETDATE(), 7)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(132008, NULL, 'Trading policy exception for transaction mode', null, 132, 'Map To Type - Trading policy exception for transaction mode', 1, 1, GETDATE(), 8)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(132009, NULL, 'Trading window other', null, 132, 'Map To Type - Trading window other', 1, 1, GETDATE(), 9)

INSERT INTO com_Code 
([CodeID],[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
VALUES(132010,'Mass Upload XLS',132,'Map To type - Mass Upload XLS Documents',1,1,10,NULL,NULL,1,GETDATE())

INSERT INTO com_Code 
([CodeID],[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
VALUES(132011,'Defaulter Report',132,'Map To type - Defaulter Report',1,1,11,NULL,NULL,1,GETDATE())

-- Added on 13-Oct-2015, received from KPCS for restricted list code merging
-- Code 132010(from KPCS) is changed to 132012, since 132010 was already used by SC
INSERT INTO com_Code (CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
VALUES (132012,'Restricted List',132,'Map To Type - Restricted List',1,1,12,NULL,NULL,1,GETDATE())

/* 
Received from Tushar: 22 Apr 2016
*/
INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
	(132013, 'Contra Trade', 132, 'Contra Trade', 1, 1, GETDATE(), 13)


/****************   
GroupId: 133
Purpose of document
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(133, null, 'Document Purpose', 'Document Purpose', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(133001, NULL, 'Email attachment', null, 133, 'Document Purpose - Email attachment', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(133002, NULL, 'Hard copy by CO to exchange', null, 133, 'Document Purpose - Hard copy by CO to exchange', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(133003, NULL, 'Transaction details uploaded', null, 133, 'Document Purpose - Transaction details uploaded', 1, 1, GETDATE(), 3)

/****************   
GroupId: 134
Current / History record type
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, CodeGroupName, Description, IsVisible, IsEditable)
VALUES
(134, null, 'Record Type', 'Record type as current/history record', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(134001, NULL, 'Current record', null, 134, 'Record within table is current record', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(134002, NULL, 'History record', null, 134, 'Record within table is history record', 1, 1, GETDATE(), 2)

/****************   
GroupId: 135
Policy defined for group
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, CodeGroupName, Description, IsVisible, IsEditable)
VALUES
(135, null, 'Policy for group', 'Policy defined for group', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(135001, NULL, 'Insider', null, 135, 'Trading Policy - Insider type', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(135002, NULL, 'Employee', null, 135, 'Trading Policy - Employee type', 1, 1, GETDATE(), 2)

/****************   
GroupId: 136
Transaction trade type - Single/Multiple transaction trade above
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, CodeGroupName, Description, IsVisible, IsEditable)
VALUES
(136, null, 'Transaction trade single/multiple', 'Transaction trade single/multiple', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(136001, NULL, 'Single transaction trade', null, 136, 'Transaction trade as single transaction trade above', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(136002, NULL, 'Multiple transaction trade', null, 136, 'Transaction trade as multiple transaction trade above', 1, 1, GETDATE(), 2)

/****************   
GroupId: 137
Occurrence frequency as yearly/quarterly/monthly/weekly
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, CodeGroupName, Description, IsVisible, IsEditable)
VALUES
(137, null, 'Occurrence frequency', 'Occurrence frequency as yearly/quarterly/monthly/weekly', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(137001, NULL, 'Yearly', null, 137, 'Occurrence is yearly', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(137002, NULL, 'Quarterly', null, 137, 'Occurrence is quarterly', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(137003, NULL, 'Monthly', null, 137, 'Occurrence is monthly', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(137004, NULL, 'Half Yearly', null, 137, 'Occurrence is half yearly', 1, 1, GETDATE(), 2)

/****************   
GroupId: 138
Year type as calendar/financial
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, CodeGroupName, Description, IsVisible, IsEditable)
VALUES
(138, null, 'Calendar/Financial Year', 'Year to be considered as Calendar/Financial', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(138001, NULL, 'Calendar Year', null, 138, 'Year is considered as calendar year', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(138002, NULL, 'Financial Year', null, 138, 'Year is considered as financial year', 1, 1, GETDATE(), 2)

/****************   
GroupId: 139
Security type - Equity/Derivatives
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, CodeGroupName, Description, IsVisible, IsEditable)
VALUES
(139, null, 'Security type', 'Security type - Equity/Derivatives', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(139001, NULL, 'Shares', null, 139, 'Security type as Shares', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(139002, NULL, 'Warrants', null, 139, 'Security type as Warrants', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(139003, NULL, 'Convertible Debentures', null, 139, 'Security type as Convertible Debentures', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(139004, NULL, 'Future Contracts', null, 139, 'Security type as Future Contracts', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(139005, NULL, 'Option Contracts', null, 139, 'Security type as Option Contracts', 1, 1, GETDATE(), 5)

UPDATE com_Code SET CodeName = 'Shares', Description = 'Security type as Shares' WHERE CodeID = 139001
UPDATE com_Code SET CodeName = 'Warrants', Description = 'Security type as Warrants' WHERE CodeID = 139002

/****************   
GroupId: 140
Trading Policy Exception For
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, CodeGroupName, Description, IsVisible, IsEditable)
VALUES
(140, null, 'Trading Policy Exception For', 'Trading policy Exception For', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(140001, NULL, 'Exercise of Options', null, 140, 'Trading policy exception for - Exercise of Options ', 1, 1, GETDATE(), 1)

/****************   
GroupId: 141
Trading Policy Status
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(141, null, 'Trading Policy Status', 'Trading Policy Status', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(141001, NULL, 'Incomplete', null, 141, 'Trading Policy Status - Incomplete', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(141002, NULL, 'Active', null, 141, 'Trading Policy Status - Active', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(141003, NULL, 'Inactive', null, 141, 'Trading Policy Status - Inactive', 1, 1, GETDATE(), 3)


/****************   
GroupId: 142
Preclearance request for
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(142, null, 'Preclearance request for', 'Preclearance request for user type', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(142001, NULL, 'Self', null, 142, 'Preclearance request for - Self', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(142002, NULL, 'Relative', null, 142, 'Preclearance request for - Relative', 1, 1, GETDATE(), 2)


/****************   
GroupId: 143
Transaction type
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(143, null, 'Transaction type', 'Transaction type', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(143001, NULL, 'Buy', null, 143, 'Transaction type - Buy', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(143002, NULL, 'Sell', null, 143, 'Transaction type - Sell', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(143003, NULL, 'Cash Exercise', null, 143, 'Transaction type - Cash Exercise', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(143004, NULL, 'Cashless All', null, 143, 'Transaction type - Cashless All', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(143005, NULL, 'Cashless Partial', null, 143, 'Transaction type - Cashless Partial', 1, 1, GETDATE(), 5)


/****************   
GroupId: 144
Preclearance Status
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(144, null, 'Preclearance Status', 'Preclearance Status', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(144001, NULL, 'Pending', null, 144, 'Preclearance Status - Pending', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(144002, NULL, 'Approved', null, 144, 'Preclearance Status - Approved', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(144003, NULL, 'Rejected', null, 144, 'Preclearance Status - Rejected', 1, 1, GETDATE(), 3)


/****************   
GroupId: 145
Reason for not trading
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(145, null, 'Reason for not trading', 'Reason for not trading', 1, 1)

/****************   
GroupId: 146
Reason for not trading
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(146, null, 'Security Type', 'Security Type', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(146001, NULL, 'Equity', null, 146, 'Security Type - Equity', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(146002, NULL, 'Derivative', null, 146, 'Security Type - Derivative', 1, 1, GETDATE(), 2)

DELETE FROM com_Code WHERE CodeGroupId = 146
DELETE FROM com_CodeGroup WHERE CodeGroupId = 146
/****************   
GroupId: 147
Disclosure Type
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(147, null, 'Disclosure Type', 'Disclosure Type', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(147001, NULL, 'Initial', null, 147, 'Disclosure Type - Initial', 1, 1, GETDATE(), 1)


INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(147002, NULL, 'Continuous', null, 147, 'Disclosure Type - Continuous', 1, 1, GETDATE(), 2)


INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(147003, NULL, 'Period End', null, 147, 'Disclosure Type - Period End', 1, 1, GETDATE(), 3)


/****************   
GroupId: 148
Disclosure Status
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(148, null, 'Disclosure Status', 'Disclosure Status', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(148001, NULL, 'Document Uploaded', null, 148, 'Disclosure Status - Document Uploaded', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(148002, NULL, 'Not Confirmed', null, 148, 'Disclosure Status - Not Confirmed', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(148003, NULL, 'Confirmed', null, 148, 'Disclosure Status - Confirmed', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(148004, NULL, 'Soft Copy Submitted', null, 148, 'Disclosure Status - Soft Copy Submitted', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(148005, NULL, 'Hard Copy Submitted', null, 148, 'Disclosure Status - Hard Copy Submitted', 1, 1, GETDATE(), 5)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(148006, NULL, 'Hard Copy Submitted By CO', null, 148, 'Disclosure Status - Hard Copy Submitted By CO', 1, 1, GETDATE(), 6)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(148007, NULL, 'Submitted', null, 148, 'Disclosure Status - Submitted', 1, 1, GETDATE(), 7)

/****************   
GroupId: 149
Mode Of Acquisition
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(149, null, 'Mode Of Acquisition', 'Mode Of Acquisition', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(149001, NULL, 'Market Purchase', null, 149, 'Mode Of Acquisition - Market Purchase', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(149002, NULL, 'Public', null, 149, 'Mode Of Acquisition - Public', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(149003, NULL, 'Right preferential', null, 149, 'Mode Of Acquisition - Right preferential', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(149004, NULL, 'Offer', null, 149, 'Mode Of Acquisition - Offer', 1, 1, GETDATE(), 4)

/****************   
GroupId: 150
Applicability association: Insider user to be included/excluded
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(150, null, 'Applicability association: Insider user to be included/excluded', 'Applicability association: Insider user to be included/excluded', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(150001, NULL, 'Include insider for applicability association', null, 150, 'Include insider for applicability association', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(150002, NULL, 'Exclude insider for applicability association', null, 150, 'Exclude insider for applicability association', 1, 1, GETDATE(), 2)

/****************   
GroupId: 151
Disclosure Letter For
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(151, null, 'Disclosure Letter For User Type', 'Disclosure Letter For User Type', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(151001, NULL, 'Insider', null, 151, 'Disclosure Letter For User Type - Insider', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(151002, NULL, 'CO', null, 151, 'Disclosure Letter For User Type - CO', 1, 1, GETDATE(), 2)

INSERT INTO com_Code 
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES 
(151003, null, 'Insider', null, 151, 'FAQ For User Type - Insider', 1, 1, GETDATE(), 3),
(151004, null, 'CO', null, 151, 'FAQ For User Type - CO', 1, 1, GETDATE(), 4)


/****************   
GroupId: 152
Event Set Master
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(152, null, 'Event Set Master', 'Master of event set', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(152001, NULL, 'Initial Disclosure', null, 152, 'Event Set - Initial Disclosure', 1, 1, GETDATE(),1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(152002, NULL, 'Continuous Disclosure', null, 152, 'Event Set - Continuous Disclosure', 1, 1, GETDATE(),2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(152003, NULL, 'Period End Disclosure', null, 152, 'Event Set - Period End Disclosure', 1, 1, GETDATE(),3)


/****************   
GroupId: 153
Event Set
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(153, null, 'Events', 'Events Master', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153001, NULL, 'User Created', null, 153, '163001,163002', 1, 1, GETDATE(),1)

--Remove this event-code since it is UNUSED in application
--INSERT INTO com_Code
--(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
--VALUES(153002, NULL, 'Welcome Email to User', null, 153, '163001,163002', 1, 1, GETDATE(),2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153003, NULL, 'Employee becomes Insider', null, 153, '163001', 1, 1, GETDATE(),3)

--Remove this event-code since it is UNUSED in application
--INSERT INTO com_Code
--(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
--VALUES(153004, NULL, 'Welcome Email to Insider', null, 153, '163001', 1, 1, GETDATE(),4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153005, NULL, 'User Logs in/sets password', null, 153, '163001,163002', 1, 1, GETDATE(),5)

--Remove this event-code since it is UNUSED in application
--INSERT INTO com_Code
--(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
--VALUES(153006, NULL, 'Initial Disclosure reminder sent', null, 153, '163001', 1, 1, GETDATE(),6)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153007, NULL, 'Initial Disclosure details entered', null, 153, '163001', 1, 1, GETDATE(),7)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153008, NULL, 'Initial Disclosure - Uploaded', null, 153, '163001', 1, 1, GETDATE(),8)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153009, NULL, 'Initial Disclosure submitted - softcopy', null, 153, '163001', 1, 1, GETDATE(),9)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153010, NULL, 'Initial Disclosure submitted - hardcopy', null, 153, '163001', 1, 1, GETDATE(),10)

--Remove this event-code since it is UNUSED in application
--INSERT INTO com_Code
--(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
--VALUES(153011, NULL, 'Initial Disclosure - CO Notified', null, 153, '163001', 1, 1, GETDATE(),11)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153012, NULL, 'Initial Disclosure - CO submitted hardcopy to Stock Exchange', null, 153, '163001', 1, 1, GETDATE(),12)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153013, NULL, 'Pre-clearance route opted', null, 153, '163001', 1, 1, GETDATE(),13)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153014, NULL, 'Trading Plan route opted', null, 153, '163001', 1, 1, GETDATE(),14)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153015, NULL, 'Pre-clearance requested', null, 153, '163001', 1, 1, GETDATE(),15)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153016, NULL, 'Pre-clearance approved', null, 153, '163001', 1, 1, GETDATE(),16)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153017, NULL, 'Pre-clearance rejected', null, 153, '163001', 1, 1, GETDATE(),17)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153018, NULL, 'Pre-clearance expiry', null, 153, '163001', 1, 1, GETDATE(),18)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153019, NULL, 'Continuous Disclosure details entered', null, 153, '163001', 1, 1, GETDATE(),19)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153020, NULL, 'Continuous Disclosure - Uploaded', null, 153, '163001', 1, 1, GETDATE(),20)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153021, NULL, 'Continuous Disclosure submitted - softcopy', null, 153, '163001', 1, 1, GETDATE(),21)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153022, NULL, 'Continuous Disclosure submitted - hardcopy', null, 153, '163001', 1, 1, GETDATE(),22)

--Remove this event-code since it is UNUSED in application
--INSERT INTO com_Code
--(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
--VALUES(153023, NULL, 'Continuous Disclosure - CO Notified', null, 153, '163001', 1, 1, GETDATE(),23)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153024, NULL, 'Continuous Disclosure - CO submitted hardcopy to Stock Exchange', null, 153, '163001', 1, 1, GETDATE(),24)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153025, NULL, 'Trading window close date', null, 153, '163001,163002', 1, 1, GETDATE(),25)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153026, NULL, 'Trading window open date', null, 153, '163001,163002', 1, 1, GETDATE(),26)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153027, NULL, 'Policy Document Viewd', null, 153, '163001', 1, 1, GETDATE(),27)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153028, NULL, 'Policy Document Agreed', null, 153, '163001', 1, 1, GETDATE(),28)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153029, NULL, 'Period End Disclosure details entered', null, 153, '163001', 1, 1, GETDATE(),29)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153030, NULL, 'Period End Disclosure - Uploaded', null, 153, '163001', 1, 1, GETDATE(),30)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153031, NULL, 'Period End Disclosure submitted - softcopy', null, 153, '163001', 1, 1, GETDATE(),31)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153032, NULL, 'Period End Disclosure submitted - hardcopy', null, 153, '163001', 1, 1, GETDATE(),32)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153033, NULL, 'Period End Date', null, 153, '163001', 1, 1, GETDATE(),33)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153034, NULL, 'Period End Disclosure - CO submitted hardcopy to Stock Exchange', null, 153, '163001', 1, 1, GETDATE(),34)


INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153035, NULL, 'Initial Disclosure - Confirmed', null, 153, '163001', 1, 1, GETDATE(),35)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153036, NULL, 'Continuous Disclosure - Confirmed', null, 153, '163001', 1, 1, GETDATE(),36)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153037, NULL, 'Period End Disclosure - Confirmed', null, 153, '163001', 1, 1, GETDATE(),37)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153038, NULL, 'Pre-Clearance Trade Details Submitted', null, 153, '163001', 1, 1, GETDATE(),38)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153039, NULL, 'Policy Document Created', null, 153, '163001', 1, 1, GETDATE(),39)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153040, NULL, 'Policy Document Expiry', null, 153, '163002', 1, 1, GETDATE(),40)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153041, NULL, 'Trading Policy Expiry', null, 153, '163002', 1, 1, GETDATE(),41)

/*Added by Ashashree on 6-Aug-2015*/
INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(153042, NULL, 'Invalid Event', null, 153, '163001,163002', 1, 1, GETDATE(),42)


/* Sent by Parag on 16-Sep */
INSERT INTO com_Code 
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES (153043, NULL, 'Confirm Personal Details', NULL, 153, '163001', 1, 1, GETDATE(), 43)


UPDATE com_Code SET CodeName = 'Pre-clearance expiry', Description = '163001' WHERE CodeID = 153018 

UPDATE com_Code SET CodeName = 'Period End Date', Description = '163001' WHERE CodeID = 153033

-- Added on 13-Oct-2015, received from KPCS for restricted list code merging
-- Code 153043(from KPCS) is changed to 153044, since 153043 was already used by SC
-- Description is also changed, since the new code needs description as codeid of EventApplicableTo
INSERT INTO com_Code (CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
VALUES (153044,'Restricted List Expiry',153,'163001',1,1,44,NULL,NULL,1,GETDATE())

/****************   
GroupId: 154
Event Status
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(154, null, 'Event Status Flag', 'Event Status Flag', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(154001, NULL, 'Completed', null, 154, 'Event Status - Completed', 1, 1, GETDATE(),1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(154002, NULL, 'Pending', null, 154, 'Event Status - Pending', 1, 1, GETDATE(),2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(154003, NULL, 'Do Not Show', null, 154, 'Event Status - Do Not Show', 1, 1, GETDATE(),3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(154004, NULL, 'Partially Traded', NULL, 154, 'Event Status - Partially Traded', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(154005, NULL, 'Not Traded', NULL, 154, 'Event Status - Not Traded', 1, 1, GETDATE(), 5)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(154006, NULL, 'Uploaded', NULL, 154, 'Event Status - Uploaded', 1, 1, GETDATE(), 6)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(154007, NULL, 'Not Required', NULL, 154, 'Event Status - Not Required', 1, 1, GETDATE(), 7)

/****************   
GroupId: 155
Grid Column Alignment
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(155, null, 'Grid Column Alignment', 'Grid Column Alignment', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(155001, NULL, 'left', 'Left', 155, 'Grid Column Alignment - left', 1, 1, GETDATE(),1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(155002, NULL, 'right', 'Right', 155, 'Grid Column Alignment - right', 1, 1, GETDATE(),2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(155003, NULL, 'center', 'Center', 155, 'Grid Column Alignment - center', 1, 1, GETDATE(),3)

/****************   
GroupId: 156
Communication modes
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(156, null, 'Communication modes', 'Communication modes', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(156001, NULL, 'Letter', 'Letter', 156, 'Communication mode (Internal) - Letter', 1, 1, GETDATE(),1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(156002, NULL, 'Email', 'Email', 156, 'Communication mode (External) - Email', 1, 1, GETDATE(),2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(156003, NULL, 'SMS', 'SMS', 156, 'Communication mode (External) - SMS', 1, 1, GETDATE(),3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(156004, NULL, 'Text Alert', 'Text Alert', 156, 'Communication mode (Internal) - Text Alert', 1, 1, GETDATE(),4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(156005, NULL, 'Popup Alert', 'Popup Alert', 156, 'Communication mode (Internal) - Popup Alert', 1, 1, GETDATE(),5)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(156006, NULL, 'FAQ', 'FAQ', 156, 'Communication mode (Internal) - Frequently Asked Questions', 1, 1, GETDATE(),6)

UPDATE com_Code SET ParentCodeId = 156001 WHERE CodeID in (151001, 151002)
UPDATE com_Code SET ParentCodeId = 156006 WHERE CodeID in (151003, 151004)

/****************   
GroupId: 157
Communication rule category
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(157, null, 'Communication rule category', 'Communication rule category', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(157001, NULL, 'Auto', 'Auto', 157, 'Communication rule category - Auto', 1, 1, GETDATE(),1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(157002, NULL, 'Manual', 'Manual', 157, 'Communication rule category - Manual', 1, 1, GETDATE(),2)

/****************   
GroupId: 158
Communication execution frequency
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(158, null, 'Communication execution frequency', 'Communication execution frequency', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(158001, NULL, 'Halt execution', 'Halt execution', 158, 'Communication execution frequency - Halt execution', 1, 1, GETDATE(),1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(158002, NULL, 'Once', 'Once', 158, 'Communication execution frequency - Once', 1, 1, GETDATE(),2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES(158003, NULL, 'Daily', 'Daily', 158, 'Communication execution frequency - Daily', 1, 1, GETDATE(),3)

/****************   
GroupId: 159
Communication Rule For 
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(159, null, 'Communication Rule For User Type', 'Communication Rule For User Type', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(159001, NULL, 'Insider', null, 159, 'Communication Rule For User Type - Insider', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(159002, NULL, 'CO', null, 159, 'Communication Rule For User Type - CO', 1, 1, GETDATE(), 2)


/****************   
GroupId: 160
Communication Rule Status 
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(160, null, 'Communication Rule Status', 'Communication Rule Status', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(160001, NULL, 'Active', null, 160, 'Communication Rule Status - Active', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(160002, NULL, 'Inactive', null, 160, 'Communication Rule Status - Inactive', 1, 1, GETDATE(), 2)


/****************   
GroupId: 161
Communication Notification Status 
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(161, null, 'Communication Notification Status', 'Communication Notification Status', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(161001, NULL, 'Success', null, 161, 'Communication Notification Status - Success', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(161002, NULL, 'Failure', null, 161, 'Communication Notification Status - Failure', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(161003, NULL, 'Other', null, 161, 'Communication Notification Status - Other', 1, 1, GETDATE(), 3)

/****************   
GroupId: 162
Report Status 
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(162, null, 'Report Status', 'Report Status', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(162001, NULL, 'rpt_lbl_19001', null, 162, 'Report Status - Ok', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(162002, NULL, 'rpt_lbl_19002', null, 162, 'Report Status - Not submitted within stipulated time', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(162003, NULL, 'rpt_lbl_19003', null, 162, 'Report Status - Not submitted', 1, 1, GETDATE(), 3)

/****************   
GroupId: 163
Communication Rule Events (trigger/offset events) apply to - Insider / CO 
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(163, null, 'Communication Rule Events apply to user type', 'Communication Rule Events apply to user type', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(163001, NULL, 'Insider', null, 163, 'Communication Rule Events apply to user type - Insider', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(163002, NULL, 'CO', null, 163, 'Communication Rule Events apply to user type - CO', 1, 1, GETDATE(), 2)



/****************   
GroupId: 164
Notification Display Type
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(164, null, 'Notification Display Type', 'Notification Display Type', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(164001, NULL, 'Display Alert', null, 164, '156004,156005', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(164002, NULL, 'Display Notification', null, 164, '156002,156003', 1, 1, GETDATE(), 2)


/****************   
GroupId: 165
Continuous disclosure report - Reuired flag
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(165, null, 'Continuous disclosure required flag', 'Continuous disclosure required flag', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(165001, NULL, 'Required', null, 165, 'Required', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(165002, NULL, 'Not Required', null, 165, 'Not Required', 1, 1, GETDATE(), 2)


/****************   
GroupId: 166
Template Category for communication and non-communication related Template entries
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(166, null, 'Template Category for Template Master', 'Template Category for Template Master', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(166001, NULL, 'Communication Category', null, 166, 'Communication Category', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(166002, NULL, 'Non-Communication Category', null, 166, 'Non-Communication Category', 1, 1, GETDATE(), 2)

/*************** UPDATE ParentCodeId for Communication and non-communication related entries for template category ***************/
UPDATE com_Code SET ParentCodeId = 166001 WHERE CodeID in (156002, 156003, 156004, 156005)
UPDATE com_Code SET ParentCodeId = 166002 WHERE CodeID in (156001, 156006)
/*************** UPDATE ParentCodeId for Communication and non-communication related entries for template category ***************/




/****************   
GroupId: 167
Preclearance Report Status 
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(167, null, 'Preclearance Report Status', 'Preclearance Report Status', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167001, NULL, 'rpt_lbl_19227', null, 167, 'Preclearance Report Status - Ok', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167002, NULL, 'rpt_lbl_19228', null, 167, 'Preclearance Report Status - Traded after pre-clearance date', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167003, NULL, 'rpt_lbl_19229', null, 167, 'Preclearance Report Status - Traded without pre-clearance', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167004, NULL, 'rpt_lbl_19230', null, 167, 'Preclearance Report Status - Pre-clearance not required', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167005, NULL, 'rpt_lbl_19231', null, 167, 'Preclearance Report Status - Traded during blackout period', 1, 1, GETDATE(), 5)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167006, NULL, 'rpt_lbl_19232', null, 167, 'Preclearance Report Status - Pending', 1, 1, GETDATE(), 6)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167007, NULL, 'rpt_lbl_19233', null, 167, 'Preclearance Report Status - Traded More Than Pre-Clearance Approved Quantity', 1, 1, GETDATE(), 7)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167008, NULL, 'rpt_lbl_19234', null, 167, 'Preclearance Report Status - Traded More Than Pre-Clearance Approved Value', 1, 1, GETDATE(), 8)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167009, NULL, 'rpt_lbl_19235', null, 167, 'Preclearance Report Status - Traded More Than Pre-Clearance Approved Quantity & Value', 1, 1, GETDATE(), 9)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167010, NULL, 'rpt_lbl_19238', null, 167, 'Preclearance Report Status - Trade details not yet submitted', 1, 1, GETDATE(), 10)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167011, NULL, 'rpt_lbl_19239', null, 167, 'Preclearance Report Status - Contra Trade', 1, 1, GETDATE(), 11)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167012, NULL, 'rpt_lbl_19240', null, 167, 'Preclearance Report Status - Partially Traded', 1, 1, GETDATE(), 11)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(167013, NULL, 'rpt_lbl_19241', null, 167, 'Preclearance Report Status - Balance trade details pending', 1, 1, GETDATE(), 11)


/****************   
GroupId: 168
Preclearance Report Status 
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(168, NULL, 'CO Dashboard Configuration Values', 'CO Dashboard Configuration Values', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(168001, NULL, '30', NULL, 168, 'Trading Policy Days for Expiry', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(168002, NULL, '30', NULL, 168, 'Policy Document Days for Expiry', 1, 1, GETDATE(), 2) 

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(168003, NULL, '020-66441919', NULL, 168, 'CO Dashboard Contact number', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(168004, NULL, 'enquiry@insidertrading.com', NULL, 168, 'CO Dashboard Email', 1, 1, GETDATE(), 4)          


/****************   
GroupId: 169
Preclearance Report Status 
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(169, NULL, 'Defaulter Report Comments', 'Comments for Defaulter Report', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(169001, NULL, 'Not submitted', NULL, 169, 'Defaulter Report Status - Not submitted', 1, 1, GETDATE(), 1)          

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(169002, NULL, 'Not submitted in stipulated time', NULL, 169, 'Defaulter Report Status - Not submitted in stipulated time', 1, 1, GETDATE(), 2)          

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(169003, NULL, 'Traded More Than Pre-Clearance Approved Quantity', null, 169, 'Defaulter Report Status - Traded More Than Pre-Clearance Approved Quantity', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(169004, NULL, 'Traded More Than Pre-Clearance Approved Value', null, 169, 'Defaulter Report Status - Traded More Than Pre-Clearance Approved Value', 1, 1, GETDATE(), 4)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(169005, NULL, '-', null, 169, 'Defaulter Report Status - -', 1, 1, GETDATE(), 5)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(169006, NULL, 'Traded after preclearance date', null, 169, 'Defaulter Report Status - Traded after preclearance date', 1, 1, GETDATE(), 6)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(169007, NULL, 'Contra Trade', null, 169, 'Defaulter Report Status - Contra Trade', 1, 1, GETDATE(), 7)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(169008, NULL, 'Preclearance not taken', null, 169, 'Defaulter Report Status - Preclearance not taken', 1, 1, GETDATE(), 8)


INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(169009, NULL, 'Traded during Blackout Period', null, 169, 'Defaulter Report Status - Traded during Blackout Period', 1, 1, GETDATE(), 9)


/****************   
GroupId: 170
Non-Compliance type for defaulter report
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(170, NULL, 'Defaulter Report Non compliance type', 'Non compliance type for Defaulter Report', 1, 0)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(170001, NULL, 'Initial', null, 170, 'Non Compliance Type - Initial', 1, 1, GETDATE(), 1)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(170002, NULL, 'Continuous', null, 170, 'Non Compliance Type - Continuous', 1, 1, GETDATE(), 2)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(170003, NULL, 'Period End', null, 170, 'Non Compliance Type - Period End', 1, 1, GETDATE(), 3)

INSERT INTO com_Code
(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(170004, NULL, 'Preclearance', null, 170, 'Non Compliance Type - Preclearance', 1, 1, GETDATE(), 4)


/****************   
GroupId: 171
Mass Upload Status
******************/
/*Script sent by Raghvendra on 5-oct-2015*/
INSERT INTO [dbo].[com_CodeGroup] ([CodeGroupID] ,[COdeGroupName] ,[Description] ,[IsVisible] ,[IsEditable] ,[ParentCodeGroupId])
VALUES  (171 ,'Mass Upload Status' ,'Mass Upload Status' ,1 ,0 ,NULL)

INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
VALUES (171001 ,'Mass Upload Started' ,171 ,'Mass Upload Started' ,1 ,1 ,1 ,NULL ,NULL ,1 ,GETDATE())

INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
VALUES (171002 ,'Mass Upload Completed' ,171 ,'Mass Upload Completed' ,1 ,1 ,1 ,NULL ,NULL ,1 ,GETDATE())

INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
VALUES (171003 ,'Mass Upload Failed' ,171 ,'Mass Upload Failed' ,1 ,1 ,1 ,NULL ,NULL ,1 ,GETDATE())

INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
VALUES (171004 ,'Mass Upload Partly Failed' ,171 ,'Mass Upload Partly Failed' ,1 ,1 ,1 ,NULL ,NULL ,1 ,GETDATE())

/****************   
GroupId: 172
Cash and Cashless Partial Excise Option For Contra Trade
******************/
/*Script sent by Tushar on 23-Nov-2015*/
INSERT INTO com_CodeGroup(CodeGroupID,COdeGroupName,Description,IsVisible,IsEditable,ParentCodeGroupId)
VALUES(172,'Cash and Cashless Partial Exercise Option For Contra Trade', 'Cash and Cashless Partial Exercise Option For Contra Trade',1,0,NULL)


INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,Description,IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
VALUES
(172001,'System should consider ESOP exercise(Cash and Cashless Partial exercise) option first and then other shares',172,'System should consider ESOP exercise(Cash and Cashless Partial exercise) option first and then other shares',1,1,1,NULL,NULL,1,GETDATE()),
(172002,'System should consider other share balance first and then ESOP exercise(Cash and Cashless Partial exercise)',172,'System should consider other share balance first and then ESOP exercise(Cash and Cashless Partial exercise)',1,1,2,NULL,NULL,1,GETDATE()),
(172003,'User selection on Pre-Clearance / trade details submission form',172,'User selection on Pre-Clearance / trade details submission form',1,1,3,NULL,NULL,1,GETDATE())

/****************   
GroupId: 173
Insider or Non insider
******************/
/*Script sent by Arundhati 09-Dec-2015*/
INSERT INTO com_CodeGroup(CodeGroupID,COdeGroupName,Description,IsVisible,IsEditable,ParentCodeGroupId)
VALUES(173,'Insider Status', 'Insider Status',1,0,NULL)


INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,Description,IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
VALUES
(173001,'Insider',173,'Insider',1,1,1,NULL,NULL,1,GETDATE()),
(173002,'Non Insider',173,'Non Insider',1,1,1,NULL,NULL,1,GETDATE())


/* 20-Jan-2016 : Script for adding new code group trading days count type and different type */

/****************   
GroupId: 174
Trading Days Count Type 
******************/
INSERT INTO com_CodeGroup
	(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
	(174, 'Trading Days Count Type', 'Trading Days Count Type', 1, 0)

INSERT INTO com_Code
	(CodeID,CodeName,CodeGroupId,Description,IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
VALUES
	(174001, 'TradingDays', 174, 'Consider only trading days and exclude holidays when calculating no of days' , 1, 1, 1, 'Trading Days', NULL, 1, GETDATE()),
	(174002, 'CalendarDays', 174, 'Consider all days including holidays when calculating no of days', 1, 1, 2, 'Calendar Days', NULL, 1, GETDATE())


/* 22-Mar-2016: Script received from Tushar */
/****************   
GroupId: 175
Trading Contra Trade Option
******************/
INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(175, 'Contra Trade Option', 'Contra Trade Without Quantiy(General Option) & Quantity Base', 1, 0)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(175001, 'Contra Trade Without Quantiy(General Option)', 175, 'Contra Trade Without Quantiy(General Option)', 1, 1, GETDATE(), 1),
(175002, 'Contra Trade Quantiy Base', 175, 'Contra Trade Quantiy Base', 1, 1, GETDATE(), 2)

/*Code Integration with ED code on 22-March-2016*/
UPDATE com_Code SET CodeName = 'ESOP' WHERE CodeID = 143003

/* 
Received from Tushar: 23 Mar 2016
Script for Transaction identification code, like PCL,PNT,PNR etc..
*/
INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(176, 'Transaction Identification Code', 'Transaction Identification Code like PCL,PNT,PNR etc.', 1, 0)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(176001, 'PCL', 176, 'This code is Used when Insider taken Preclerance', 1, 1, GETDATE(), 1),
(176002, 'PNT', 176, 'This code is Used when Insider not taken Preclerance', 1, 1, GETDATE(), 2),
(176003, 'PNR', 176, 'This code is Used for employee those are non insider', 1, 1, GETDATE(), 3),
(176004, 'PE', 176, 'This code is Used for Period End Transaction', 1, 1, GETDATE(), 4)


/* 
Code sync with ED 25-Apr-2016 started
*/

UPDATE com_Code set CodeName = 'Public Right', Description = 'Mode Of Acquisition - Public Right' where CodeID = '149002'
UPDATE com_Code set CodeName = 'Preferential Offer', Description = 'Mode Of Acquisition - Preferential Offer' where CodeID = '149003'
UPDATE com_Code set CodeName = 'Gift', Description = 'Mode Of Acquisition - Gift' where CodeID = '149004'

IF NOT EXISTS(SELECT CODENAME FROM com_Code WHERE CodeID = 149005)
BEGIN
	INSERT INTO com_Code VALUES
	(149005, 'Inter-se-Transfer', 149, 'Mode Of Acquisition - Inter-se-Transfer',1,1,5,NULL,NULL,1, GETDATE()),
	(149006, 'Conversion of security', 149, 'Mode Of Acquisition - Conversion of security',1,1,6,NULL,NULL,1, GETDATE()),
	(149007, 'Scheme of Amalgamation/Merger/Demerger/Arrangement', 149, 'Mode Of Acquisition - Scheme of Amalgamation/Merger/Demerger/Arrangement',1,1,7,NULL,NULL,1, GETDATE()),
	(149008, 'Off Market', 149, 'Mode Of Acquisition - Off Market',1,1,8,NULL,NULL,1, GETDATE()),
	(149009, 'ESOP', 149, 'Mode Of Acquisition - ESOP',1,1,9,NULL,NULL,1, GETDATE()),
	(149010, 'Market Sale', 149, 'Mode Of Acquisition - Market Sale',1,1,10,NULL,NULL,1, GETDATE())
END
/* 
Code sync with ED 25-Apr-2016 completed
*/

/* 
Received from Tushar: 22 Apr 2016
*/
INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
	(177, ' Contra Trade Based On', ' Contra Trade Based On', 1, 0)

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
	(177001, 'All Security Type', 177, 'All Security Type', 1, 1, GETDATE(), 1),
	(177002, 'Individual Security Type', 177, 'Individual Security Type', 1, 1, GETDATE(), 2)
	

/*
Script received from Raghvendra on 3-May-2016
Added a new Mode of acquisiton i.e. Bonus. This mode of acquisiton was added as per the request send by Deepak on 2-May-2016 in email.
*/
INSERT INTO com_Code VALUES (149011, 'Bonus', 149, 'Mode Of Acquisition - Bonus',1,1,11,NULL,NULL,1, GETDATE())


/*
Script from Parag on 4-May-2016
Added group and code for auto submit transcation 

GroupId: 178
Auto submit transaction configuration
*/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(178, NULL, 'Auto submit transaction', 'Auto submit transaction', 1, 0)

INSERT INTO com_Code
	(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
	(178001, NULL, 'No Auto Submit', NULL, 178, 'No auto submit transaction', 1, 1, GETDATE(), 1),
	(178002, NULL, 'Auto Submit - Continuous Disclosure from Mass Upload', NULL, 178, 'Auto Submit - Continuous Disclosure from Mass Upload', 1, 1, GETDATE(), 2)


/*
Script from Parag on 4-Aug-2016
Added group and code for allowed negative value or not

GroupId: 179
Security configuration for values 
*/
INSERT INTO com_CodeGroup
(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(179, NULL, 'Security Configuraiton - Security values constraint', 'Security Configuraiton - Security values constraint', 1, 0)

INSERT INTO com_Code
	(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
	(179001, NULL, 'Allowed positive values only', NULL, 179, 'Allowed positive values only', 1, 1, GETDATE(), 1),
	(179002, NULL, 'Allowed positive and negative values', NULL, 179, 'Allowed positive and negative values', 1, 1, GETDATE(), 2)

