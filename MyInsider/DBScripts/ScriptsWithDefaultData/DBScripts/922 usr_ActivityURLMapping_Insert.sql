
/* 
Modified By		Modified On		Description 
Parag			12-Feb-2016		acid-url mapping for policy doucment and policy document list for CO 
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- Policy Document - List - View right for Policy Document
	(140, 'PolicyDocuments', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(140, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(140, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	
	-- Policy Document - View - View right for Policy Document
	(117, 'PolicyDocuments', 'Edit', NULL, 1, GETDATE(), 1, GETDATE()), 
	(117, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- download document
	(117, 'Applicability', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- view applicability for policy document
	(117, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(117, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	
	-- Policy Document - Create - Create right for Policy Document
	(118, 'PolicyDocuments', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), 
	(118, 'PolicyDocuments', 'SubCategory', NULL, 1, GETDATE(), 1, GETDATE()), -- fetch partial view
	(118, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- upload document
	(118, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- delete document
	(118, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- download document
	(118, 'ComCode', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- create category
	(118, 'ComCode', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()), -- save category 
	(118, 'PolicyDocuments', 'Create', 'Save', 1, GETDATE(), 1, GETDATE()), 
	
	-- Policy Document - Edit - Edit right for Policy Document
	(119, 'PolicyDocuments', 'Edit', NULL, 1, GETDATE(), 1, GETDATE()), 
	(119, 'PolicyDocuments', 'SubCategory', NULL, 1, GETDATE(), 1, GETDATE()), -- fetch partial view
	(119, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- upload document
	(119, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- download document
	(119, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- delete document
	(119, 'PolicyDocuments', 'Create', 'Save', 1, GETDATE(), 1, GETDATE()), 
	(119, 'Applicability', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- define applicability for policy document
	(119, 'Applicability', 'Apply', NULL, 1, GETDATE(), 1, GETDATE()), -- save applicability for policy document
	(119, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(119, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(119, 'ComCode', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- create category 
	(119, 'ComCode', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()), -- save category 
	
	-- Policy Document - Delete - Delete right for Policy Document
	(120, 'PolicyDocuments', 'Delete', NULL, 1, GETDATE(), 1, GETDATE()), 
	
	
	-- Policy Document Status - List - List right for Policy Document under Transaction
	(138, 'PolicyDocuments', '', NULL, 1, GETDATE(), 1, GETDATE()), 
	(138, 'PolicyDocuments', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), 
	
	-- Policy Document Status - View - View right for Policy Document under Transaction
	(139, 'PolicyDocuments', 'View', NULL, 1, GETDATE(), 1, GETDATE()),
	(139, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(139, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(139, 'InsiderInitialDisclosure', 'DisplayPolicy', NULL, 1, GETDATE(), 1, GETDATE()), -- show policy document
	(139, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE()), -- get policy document content
	(139, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE())

/* 
Modified By		Modified On		Description  
Parag			12-Feb-2016		acid-url mapping for Master code for CO 
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- Other Master - View - View right for Other master
	(14, 'ComCode', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(14, 'ComCode', 'PopulateCombo_OnChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(14, 'ComCode', 'ParentPopulateCombo_OnChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(14, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(14, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	
	-- Other Master - Create - Create right for Other master
	(15, 'ComCode', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(15, 'ComCode', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()), -- save category 
	
	-- Other Master - Edit - Edit right for Other master
	(16, 'ComCode', 'Edit', NULL, 1, GETDATE(), 1, GETDATE()),
	(16, 'ComCode', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()), -- update category 
	
	-- Other Master - Delete - Delete
	(17, 'ComCode', 'DeleteFromGrid', NULL, 1, GETDATE(), 1, GETDATE()),
	(17, 'ComCode', 'Create', 'DeleteComCode', 1, GETDATE(), 1, GETDATE())
	
	
/* 
Modified By		Modified On		Description  
Parag			15-Feb-2016		After login user redirect to show respective dashboard
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- to show login user dashboard
	(18, 'CODashboard', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(191, 'InsiderDashboard', 'Index', NULL, 1, GETDATE(), 1, GETDATE())
	
/* 
Modified By		Modified On		Description  
Parag			15-Feb-2016		acid-url mapping for Employee/Insider under User Module 
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- Employee / Insider User - View - View right for the Employee / Insider user -- FOR CO and Insider
	(5, 'Employee', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(5, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(5, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(5, 'Employee', 'ViewDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- view details of employee and non employee user for CO
	(5, 'CorporateUser', 'ViewRecords', NULL, 1, GETDATE(), 1, GETDATE()), -- view details of corporate user for CO
	(81, 'Employee', 'ViewDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- view details of employee for Insider
	(82, 'CorporateUser', 'ViewRecords', NULL, 1, GETDATE(), 1, GETDATE()), -- view details of corporate for Insider
	(83, 'Employee', 'ViewDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- view details of non employee for Insider
	
	-- Employee / Insider User - Create - Create right for the Employee / Insider user
	(6, 'Employee', 'Add', NULL, 1, GETDATE(), 1, GETDATE()),
	(6, 'Employee', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(6, 'Employee', 'GetSubCategories', NULL, 1, GETDATE(), 1, GETDATE()),
	(6, 'Employee', 'GetSubDesignation', NULL, 1, GETDATE(), 1, GETDATE()),
	(6, 'Employee', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()),
	(6, 'NonEmployeeInsider', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(6, 'NonEmployeeInsider', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()),
	(6, 'CorporateUser', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(6, 'CorporateUser', 'CorporateUserCreate', 'Create', 1, GETDATE(), 1, GETDATE()),
	
	-- Employee / Insider User - Edit - Edit right for the Employee / Insider user
	(7, 'Employee', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(7, 'Employee', 'GetSubCategories', NULL, 1, GETDATE(), 1, GETDATE()),
	(7, 'Employee', 'GetSubDesignation', NULL, 1, GETDATE(), 1, GETDATE()),
	(7, 'Employee', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()),
	(7, 'NonEmployeeInsider', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(7, 'NonEmployeeInsider', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()),
	(7, 'CorporateUser', 'Edit', NULL, 1, GETDATE(), 1, GETDATE()),
	(7, 'CorporateUser', 'CorporateUserCreate', 'Create', 1, GETDATE(), 1, GETDATE()),
	(7, 'Employee', 'Create', 'ConfirmDetails', 1, GETDATE(), 1, GETDATE()), -- Confirm personal details for employee
	(7, 'NonEmployeeInsider', 'Create', 'ConfirmDetails', 1, GETDATE(), 1, GETDATE()), -- Confirm personal details for non employee
	(7, 'CorporateUser', 'CorporateUserCreate', 'ConfirmDetails', 1, GETDATE(), 1, GETDATE()), -- Confirm personal details for corporeate insider
	
	-- Employee / Insider User - Delete - Delete right for the Employee / Insider user
	(8, 'Employee', 'DeleteUser', NULL, 1, GETDATE(), 1, GETDATE()),
		
	
	-- DMAT Details - View - View right for DMAT details
	(25, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Demat details list 
	(25, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	
	-- DMAT Details - Create - Create right for DMAT details
	(26, 'Employee', 'EditDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Create Demat Account 
	(26, 'Employee', 'SaveDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Save Demat Account 
	(26, 'CorporateUser', 'EditDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Create Demat Account for corporate insider
	(26, 'CorporateUser', 'SaveDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Save Demat Account for corporate insider
	(26, 'Employee', 'EditRelativeDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Create Demat Account for relative
	(26, 'Employee', 'SaveRelativeDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Save Demat Account for relative
	
	-- DMAT Details - Edit - Edit right for DMAT details
	(27, 'Employee', 'EditDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Edit Demat Account 
	(27, 'Employee', 'SaveDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Save Demat Account 
	(27, 'CorporateUser', 'EditDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Edit Demat Account for corporate insider
	(27, 'CorporateUser', 'SaveDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Save Demat Account for corporate insider
	(27, 'Employee', 'EditRelativeDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Edit Demat Account 
	(27, 'Employee', 'SaveRelativeDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Save Demat Account 
	
	-- DMAT Details - Delete - Delete right for DMAT details
	(28, 'Employee', 'DeleteDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- delete demat detail
	(28, 'CorporateUser', 'DeleteDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- delete demat detail for corporate insider
	(28, 'Employee', 'DeleteRelativeDMATDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- delete demat detail
	
	-- Document Details - View - View right for Document details
	(29, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- User document list
	(29, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(29, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- view uploaded document 
	
	-- Document Details - Create - Create right for Document details
	(30, 'Document', 'EditDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(30, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- upload document
	(30, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- delete document
	(30, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- download document
	(30, 'Document', 'SaveDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- save user document
	
	-- Document Details - Edit - Edit right for Document details
	(31, 'Document', 'EditDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(31, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- upload document
	(31, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- delete document
	(31, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- download document
	(31, 'Document', 'SaveDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- save user document
	
	-- Document Details - Delete - Delete right for Document details
	(32, 'Document', 'DeleteDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- delete document
	
	-- Relatives details - View - View right for Relatives details
	(33, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- User relative list
	(33, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(33, 'Employee', 'ViewDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- view relative details
	
	-- Relatives details - Create - Create right for Relatives details
	(34, 'Employee', 'CreateRelative', NULL, 1, GETDATE(), 1, GETDATE()), -- Create relative
	(34, 'Employee', 'GetParentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- get user address details
	
	-- Relatives details - Edit - Edit right for Relatives details
	(35, 'Employee', 'CreateRelative', NULL, 1, GETDATE(), 1, GETDATE()), -- Edit relative details
	(35, 'Employee', 'GetParentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- get user address details
	
	-- Relatives details - Delete - Delete right for Relatives details
	(36, 'Employee', 'DelateRelative', NULL, 1, GETDATE(), 1, GETDATE()), -- delete relative
	
	
	-- Separation details - View - View right for Separation details
	(37, 'Employee', 'UploadSeparation', NULL, 1, GETDATE(), 1, GETDATE()),
	(37, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- User separation list
	(37, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	
	-- Separation details - Create - Create right for Separation details
	(38, 'Employee', 'EditSepration', NULL, 1, GETDATE(), 1, GETDATE()),
	(38, 'Employee', 'SaveUserSeparation', NULL, 1, GETDATE(), 1, GETDATE()),
	
	-- Separation details - Re-Activate - Re-Activate right for Separation details
	(40, 'Employee', 'ReactivateUser', NULL, 1, GETDATE(), 1, GETDATE())
	


/* 
Modified By		Modified On		Description 
Gaurishankar	15-Feb-2016		acid-url mapping for Communication Rule. 

ActivityID	ScreenName				ActivityName
179			Communication Rules		List
180			Communication Rules		View
181			Communication Rules		Add
182			Communication Rules		Edit
183			Communication Rules		Delete
190			Communication Rules		Personalize
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- Communication Rule - List - View right for Communication Rule
	(179, 'CommunicationRuleMaster', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(179, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 

	(181, 'CommunicationRuleMaster', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(182, 'CommunicationRuleMaster', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(190, 'CommunicationRuleMaster', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(181, 'CommunicationRuleMaster', 'SaveCommunicationRule', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(182, 'CommunicationRuleMaster', 'SaveCommunicationRule', NULL, 1, GETDATE(), 1, GETDATE()),
	(190, 'CommunicationRuleMaster', 'SaveCommunicationRule', NULL, 1, GETDATE(), 1, GETDATE()),
	(181, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(182, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(190, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(181, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
	(182, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
	
	(190, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE())

/* 

TemplateMaster
ActivityID	ScreenName	ActivityName
174	Template	List
175	Template	View
176	Template	Add
177	Template	Edit
178	Template	Delete

*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	(176, 'TemplateMaster', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(177, 'TemplateMaster', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(178, 'TemplateMaster', 'Delete', NULL, 1, GETDATE(), 1, GETDATE()),
	
	(176, 'TemplateMaster', 'SaveAction', 'Save', 1, GETDATE(), 1, GETDATE()), -- 
	(177, 'TemplateMaster', 'SaveAction', 'Save', 1, GETDATE(), 1, GETDATE()),
	(174, 'TemplateMaster', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(174, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(179, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
	(174, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE())


--------------------------------------------------------------------------------------------------
/*
Created By :- Tushar 
Date:- 18-Feb-2016

Module:- CO User
*/
--------------------------------------------------------------------------------------------------
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
--View Activity List
	(1, 'UserDetails', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), 
	(1, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(1, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
-- View CO User Details
	(1, 'UserDetails', 'Edit', NULL, 1, GETDATE(), 1, GETDATE()), 
	
--Create 
	(2, 'UserDetails', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), 
	(2, 'UserDetails', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()), 
	
--Edit
	(3, 'UserDetails', 'Edit', NULL, 1, GETDATE(), 1, GETDATE()), 
	(3, 'UserDetails', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()), 
	
--Delete
	(4, 'UserDetails', 'Create', 'Delete', 1, GETDATE(), 1, GETDATE()), 
	(4, 'UserDetails', 'DeleteFromGrid', NULL, 1, GETDATE(), 1, GETDATE()),
	
--View Details right for the CO user
	(192, 'UserDetails', 'Edit', NULL, 1, GETDATE(), 1, GETDATE())
	

--------------------------------------------------------------------------------------------------
/*
Created By :- Tushar 
Date:- 18-Feb-2016

Module:- Resource (Lables & Titles)
*/
--------------------------------------------------------------------------------------------------
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
--View Activity List
	(23, 'Resource', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(23, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(23, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
	(23, 'Resource', 'ModuleCodeChange', NULL, 1, GETDATE(), 1, GETDATE()),
	
--Edit
	(24, 'Resource', 'Edit', NULL, 1, GETDATE(), 1, GETDATE()),
	(24, 'Resource', 'UpdateResourceValue', NULL, 1, GETDATE(), 1, GETDATE())


--------------------------------------------------------------------------------------------------
/*
Created By :- Tushar 
Date:- 19-Feb-2016

Module:- Company Module
*/
--------------------------------------------------------------------------------------------------
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
--View Activity List
	(10, 'Company', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(10, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(10, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
	(10, 'Company', 'View', NULL, 1, GETDATE(), 1, GETDATE()),
	
--Create
    (11, 'Company', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(11, 'Company', 'SaveCompany', 'SaveCompany', 1, GETDATE(), 1, GETDATE()),
	(11, 'Company', 'SaveCompanyFaceValue', NULL, 1, GETDATE(), 1, GETDATE()),
	
--Edit
	(12, 'Company', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'SaveCompany', 'SaveCompany', 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'SaveImplementingCompanyBasinInfo', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'SaveCompanyFaceValue', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'EditCompanyFaceValueDetails', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'SaveAuthorizedShareCapital', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'EditAuthorisedSharesDetails', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'SavePaidUpAndSubscribedShareCapital', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'EditPaidUpAndSubscribedShareCapital', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'SaveListingDetails', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'EditListingDetails', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'SaveComplianceOfficer', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'EditComplianceOfficer', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'DeleteCompanyFaceValueDetails', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'DeleteCompanyAuthorisedSharesDetails', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'DeletePaidUpAndSubscribedShareCapital', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'DeleteListingDetails', NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Company', 'DeleteComplianceOfficer', NULL, 1, GETDATE(), 1, GETDATE()),

--Delete
	(13, 'Company', 'DeleteFromGrid', NULL, 1, GETDATE(), 1, GETDATE())


/*
Created By :- Gaurishankar 
Date:- 19-Feb-2016

ActivityID	ScreenName	ActivityName
184	Notification	List
185	Notification	View

*/

INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	(184, 'Notification', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(184, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(184, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
	(185, 'Notification', 'View', NULL, 1, GETDATE(), 1, GETDATE())


--------------------------------------------------------------------------------------------------
/*
Created By :- Tushar 
Date:- 18-Feb-2016

Module:- Trading Policy Module
*/
--------------------------------------------------------------------------------------------------
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
--View Activity List
	(121, 'TradingPolicy', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'History', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'ContinousSecurityFlagChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'RadioButtonChangeTransaction', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'PreclearanceSecurityFlagChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'TradingPolicyForCodeType', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'PreClearanceTransactionForTrade', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'PreClrSeekDeclarationForUPSIFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'PreClrPartialTradeNotDoneFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'DiscloInitReqFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'DiscloPeriodEndReqFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'StExMultiTradeFreqURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'ProhibitPreclearanceValueChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'ContinuousDisclosureRequiredURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'ContinuousDisclosureSubmissionStockExchangeURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'PeriodEndDisclosureSubmissionStockExchangeURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'ContinuousLimitsURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'TransactionSecuityMappingChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'TradingPolicy', 'ViewApplicablity', NULL, 1, GETDATE(), 1, GETDATE()),
	(121, 'Applicability', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	
--Create
    (122, 'TradingPolicy', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'ContinousSecurityFlagChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'RadioButtonChangeTransaction', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'PreclearanceSecurityFlagChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'TradingPolicyForCodeType', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'PreClearanceTransactionForTrade', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'PreClrSeekDeclarationForUPSIFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'PreClrPartialTradeNotDoneFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'DiscloInitReqFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'DiscloPeriodEndReqFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'StExMultiTradeFreqURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'ProhibitPreclearanceValueChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'ContinuousDisclosureRequiredURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'ContinuousDisclosureSubmissionStockExchangeURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'PeriodEndDisclosureSubmissionStockExchangeURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'ContinuousLimitsURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'TransactionSecuityMappingChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'BasicInfo', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'TradingPolicy', 'ViewApplicablity', NULL, 1, GETDATE(), 1, GETDATE()),
	(122, 'Applicability', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(122,'Applicability', 'Apply', NULL, 1, GETDATE(), 1, GETDATE()),
	
--Edit
	(123, 'TradingPolicy', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'ContinousSecurityFlagChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'RadioButtonChangeTransaction', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'PreclearanceSecurityFlagChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'TradingPolicyForCodeType', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'PreClearanceTransactionForTrade', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'PreClrSeekDeclarationForUPSIFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'PreClrPartialTradeNotDoneFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'DiscloInitReqFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'DiscloPeriodEndReqFlagURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'StExMultiTradeFreqURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'ProhibitPreclearanceValueChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'ContinuousDisclosureRequiredURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'ContinuousDisclosureSubmissionStockExchangeURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'PeriodEndDisclosureSubmissionStockExchangeURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'ContinuousLimitsURL', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'TransactionSecuityMappingChange', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'BasicInfo', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'TradingPolicy', 'ViewApplicablity', NULL, 1, GETDATE(), 1, GETDATE()),
	(123, 'Applicability', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(123,'Applicability', 'Apply', NULL, 1, GETDATE(), 1, GETDATE()),
--Delete
	(124, 'TradingPolicy', 'DeleteTradingPolicy', NULL, 1, GETDATE(), 1, GETDATE()),
	(124, 'TradingPolicy', 'DeleteFromGrid', NULL, 1, GETDATE(), 1, GETDATE())
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
/*
Created By :- Tushar 
Date:- 22-Feb-2016

Module:- Preclearance Request Module
*/
--------------------------------------------------------------------------------------------------
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
--Insider
	(157, 'PreclearanceRequest', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(157, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(157, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
	(157, 'PreclearanceRequest', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(157, 'PreclearanceRequest', 'Save', NULL, 1, GETDATE(), 1, GETDATE()),
	(157, 'PreclearanceRequest', 'PreClearanceNotTakenAction', NULL, 1, GETDATE(), 1, GETDATE()),
	(157, 'PreclearanceRequest', 'RejectionView', NULL, 1, GETDATE(), 1, GETDATE()),
	(157, 'PreclearanceRequest', 'NotTradedViewView', NULL, 1, GETDATE(), 1, GETDATE()),
---CO 
	(167, 'PreclearanceRequest', 'ListByCO', NULL, 1, GETDATE(), 1, GETDATE()),
	(167, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(167, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
	(167, 'PreclearanceRequest', 'ApproveRejectAction', NULL, 1, GETDATE(), 1, GETDATE()),
	(167, 'PreclearanceRequest', 'ApproveRejectAction', 'ApproveAction', 1, GETDATE(), 1, GETDATE()),
	(167, 'PreclearanceRequest', 'ApproveRejectAction', 'RejectAction', 1, GETDATE(), 1, GETDATE()),
	(167, 'PreclearanceRequest', 'RejectionView', NULL, 1, GETDATE(), 1, GETDATE()),
	(167, 'PreclearanceRequest', 'NotTradedViewView', NULL, 1, GETDATE(), 1, GETDATE()),
	(167, 'PreclearanceRequest', 'Create', NULL, 1, GETDATE(), 1, GETDATE())
	
--------------------------------------------------------------------------------------------------


/* 
Modified By		Modified On		Description 
Raghvendra		19-Feb-2016		acid-url mapping for Mass Upload 
*/

INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- Mass Upload - List of MassUploads screen
	(9, 'MassUpload', 'AllMassUpload', NULL, 1, GETDATE(), 1, GETDATE()), -- Show all the Supported Mass Uploads list
	(9, 'MassUpload', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Redirect to the All Mass Upload List
	(9, 'MassUpload', 'DownloadTemplateExcel', NULL, 1, GETDATE(), 1, GETDATE()), -- donwload template excel
	
	
	-- Mass Upload - Start individual Mass Upload screen
	(9, 'MassUpload', 'OpenFileUploadDialog', NULL, 1, GETDATE(), 1, GETDATE()), -- Show the screen for letting user select the Mass upload excel file
	(9, 'MassUpload', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Let user upload the excel file clicking on Upload button
	(9, 'MassUpload', 'SaveImportedRecordsProc', NULL, 1, GETDATE(), 1, GETDATE()), -- Let user start the MAss Upload process
	(9, 'MassUpload', 'DownloadErrorExcel', NULL, 1, GETDATE(), 1, GETDATE()), -- download error excel
	(9, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Document controller Upload document process
	(9, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Delete the uploaded Mass upload excel
	(9, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()) -- Download uploaded Mass upload excel
	
/* 
Modified By		Modified On		Description 
Raghvendra		21-Feb-2016		acid-url mapping for Reports 
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- Reports Inlitial Disclosure Employee Wise and Employee Individual reports
	(186, 'Reports', 'InitialDisclosureEmployeeWise', NULL, 1, GETDATE(), 1, GETDATE()), -- Report call
	(186, 'Reports', 'InitialDisclosureEmployeeIndividual', NULL, 1, GETDATE(), 1, GETDATE()), -- Report Call

	(186, 'Reports', 'ExportReport', NULL, 1, GETDATE(), 1, GETDATE()), -- Export call
	(186, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- Data Grid Call
	(186, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Data Grid ajax Call

	-- Reports Continuous Disclosure Employee Wise and Employee Individual reports
	(187, 'Reports', 'ContinuousDisclosureEmployeeWise', NULL, 1, GETDATE(), 1, GETDATE()), -- Report call
	(187, 'Reports', 'ContinuousDisclosureEmployeeIndividual', NULL, 1, GETDATE(), 1, GETDATE()), -- Report Call

	(187, 'Reports', 'ExportReport', NULL, 1, GETDATE(), 1, GETDATE()), -- Export call
	(187, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- Data Grid Call
	(187, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Data Grid ajax Call

	-- Reports Period End Disclosure Employee Wise and Employee Individual reports
	(188, 'Reports', 'PeriodEndDisclosureEmployeeWise', NULL, 1, GETDATE(), 1, GETDATE()), -- Report call
	(188, 'Reports', 'PeriodEndDisclosureEmployeeIndividual', NULL, 1, GETDATE(), 1, GETDATE()), -- Report Call
	(188, 'Reports', 'PeriodEndDisclosureEmployeeIndividualDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Report Call

	(188, 'Reports', 'ExportReport', NULL, 1, GETDATE(), 1, GETDATE()), -- Export call
	(188, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- Data Grid Call
	(188, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Data Grid ajax Call

	-- Reports Preclearance Employee Wise and Employee Individual reports
	(189, 'Reports', 'PreclearenceEmployeeWise', NULL, 1, GETDATE(), 1, GETDATE()), -- Report call
	(189, 'Reports', 'PreclearenceEmployeeIndividual', NULL, 1, GETDATE(), 1, GETDATE()), -- Report Call

	(189, 'Reports', 'ExportReport', NULL, 1, GETDATE(), 1, GETDATE()), -- Export call
	(189, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- Data Grid Call
	(189, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Data Grid ajax Call

	-- Reports Defaulter reports
	(196, 'Reports', 'DefaulterReport', NULL, 1, GETDATE(), 1, GETDATE()), -- Report call
	(196, 'Reports', 'MarkOverride', NULL, 1, GETDATE(), 1, GETDATE()), -- Mark Option for Defaulter 

	(196, 'Reports', 'ExportReport', NULL, 1, GETDATE(), 1, GETDATE()), -- Export call
	(196, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- Data Grid Call
	(196, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Data Grid ajax Call
	
	-- Reports Defaulter reports Document upload
   (196, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Report call
   (196, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Mark Option for Defaulter
   (196, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE())




/* 
Modified By		Modified On		Description 
Raghvendra		21-Feb-2016		acid-url mapping for FAQ 
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- Reports Inlitial Disclosure Employee Wise and Employee Individual reports
	(193, 'FAQ', 'COFAQList', NULL, 1, GETDATE(), 1, GETDATE()), -- FAQ List for CO
	(194, 'FAQ', 'InsiderFAQList', NULL, 1, GETDATE(), 1, GETDATE()) -- FAQ List for Insider


/* 
Modified By		Modified On		Description  
Parag			18-Feb-2016		acid-url mapping for Transaction Module (all disclosure ie initial, continuous, period end)
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- FOR CO
	-- Disclosure Details for CO - Initial Disclosure - Disclosure Details for CO - Initial Disclosure Submission
	(165, 'COInitialDisclosure', 'List', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure dashboard
	(165, 'COInitialDisclosure', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure list
	(165, 'TradingTransaction', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure transaction details list
	(165, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(165, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(165, 'TradingTransaction', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure transaction details
	(165, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure upload document
	(165, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure delete document
	(165, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure download document
	(165, 'TradingTransaction', 'Submit', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure submitted
	(165, 'TradingTransaction', 'Delete', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure delete transcation details
	
	-- Disclosure Details for CO - Initial Disclosure Letter - Disclosure Details for CO - Initial Disclosure Letter Submission
	(166, 'TradingTransaction', 'CreateLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure create soft-copy letter
	(166, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(166, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(166, 'TradingTransaction', 'CreateLetter', 'SaveLetter', 1, GETDATE(), 1, GETDATE()), -- initial disclosure save soft-copy letter
	(166, 'TradingTransaction', 'SubmitSoftCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure submit soft-copy letter OR print soft-copy letter
	(166, 'TradingTransaction', 'UploadHardDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure hard-copy letter
	(166, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure hard copy upload document
	(166, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure hard copy delete document
	(166, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure hard copy download document
	(166, 'TradingTransaction', 'SubmitHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure submit hard-copy letter
	(166, 'TradingTransaction', 'ViewLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure view soft-copy letter
	(166, 'TradingTransaction', 'ViewHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure view hard-copy letter
	(166, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure show hard copy document content
	
	-- Disclosure Details for CO - Continuous Disclosure - Disclosure Details for CO - Continuous Disclosure Submission
	(167, 'TradingTransaction', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure transaction details list
	(167, 'TradingTransaction', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure transaction details
	(167, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure upload document
	(167, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure delete document
	(167, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure download document
	(167, 'TradingTransaction', 'Submit', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure submitted
	(167, 'TradingTransaction', 'Delete', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure delete transcation details
	(167, 'TradingTransaction', 'TransactionNotTraded', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure submit not traded reason 
	(167, 'TradingTransaction', 'DeleteMaster', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure delete transaction master id becase no transaction details
	
	-- Disclosure Details for CO - Continuous Disclosure Letter - Disclosure Details for CO - Continuous Disclosure Letter Submission
	(168, 'TradingTransaction', 'CreateLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure create soft-copy letter
	(168, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(168, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(168, 'TradingTransaction', 'CreateLetter', 'SaveLetter', 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure save soft-copy letter
	(168, 'TradingTransaction', 'SubmitSoftCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure submit soft-copy letter OR print soft-copy letter
	(168, 'TradingTransaction', 'UploadHardDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure hard-copy letter
	(168, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure hard copy upload document
	(168, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure hard copy delete document
	(168, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure hard copy download document
	(168, 'TradingTransaction', 'SubmitHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure submit hard-copy letter
	(168, 'TradingTransaction', 'ViewLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure view soft-copy letter
	(168, 'TradingTransaction', 'ViewHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure view hard-copy letter
	(168, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure show hard copy document content
	
	-- Disclosure Details for CO - Period End Disclosure - Disclosure Details for CO - Period End Disclosure Submission
	(169, 'PeriodEndDisclosure', 'UsersStatus', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure list
	(169, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(169, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(169, 'PeriodEndDisclosure', 'PeriodStatus', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure list for user
	(169, 'TradingTransaction', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure transaction details list
	(169, 'TradingTransaction', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure transaction details
	(169, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure upload document
	(169, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure delete document
	(169, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure download document
	(169, 'TradingTransaction', 'Submit', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure submitted
	(169, 'TradingTransaction', 'Delete', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure delete transcation details
	
	-- Disclosure Details for CO - Period End Disclosure Letter - Disclosure Details for CO - Period End Disclosure Letter Submission
	(170, 'TradingTransaction', 'CreateLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure create soft-copy letter
	(170, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(170, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(170, 'TradingTransaction', 'CreateLetter', 'SaveLetter', 1, GETDATE(), 1, GETDATE()), -- Period End disclosure save soft-copy letter
	(170, 'TradingTransaction', 'SubmitSoftCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure submit soft-copy letter OR print soft-copy letter
	(170, 'TradingTransaction', 'UploadHardDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure hard-copy letter
	(170, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure hard copy upload document
	(170, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure hard copy delete document
	(170, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure hard copy download document
	(170, 'TradingTransaction', 'SubmitHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure submit hard-copy letter
	(170, 'TradingTransaction', 'ViewLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure view soft-copy letter
	(170, 'TradingTransaction', 'ViewHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure view hard-copy letter
	(170, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure show hard copy document content
	
	-- Disclosure Details for CO - Initial Disclosure - Submission to Stock Exchange - Disclosure Details for CO - Initial Disclosure - Submission to Stock Exchange
	(171, 'TradingTransaction', 'CreateLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure create stock exchange soft-copy letter
	(171, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(171, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(171, 'TradingTransaction', 'CreateLetter', 'SaveLetter', 1, GETDATE(), 1, GETDATE()), -- initial disclosure save stock exchange soft-copy letter
	(171, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure stock exchange hard copy upload document
	(171, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure stock exchange hard copy delete document
	(171, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure stock exchange hard copy download document
	(171, 'TradingTransaction', 'SubmitLetterToStockExchange', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure stock exchange submit
	(171, 'TradingTransaction', 'ViewLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure view stock exchange letter
	(171, 'TradingTransaction', 'SubmitSoftCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure print stock exchange letter
		
	-- Disclosure Details for CO - Continuous Disclosure - Submission to Stock Exchange - Disclosure Details for CO - Continuous Disclosure - Submission to Stock Exchange
	(172, 'TradingTransaction', 'CreateLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- continuous disclosure create stock exchange soft-copy letter
	(172, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(172, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(172, 'TradingTransaction', 'CreateLetter', 'SaveLetter', 1, GETDATE(), 1, GETDATE()), -- continuous disclosure save stock exchange soft-copy letter
	(172, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- continuous disclosure stock exchange hard copy upload document
	(172, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- continuous disclosure stock exchange hard copy delete document
	(172, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- continuous disclosure stock exchange hard copy download document
	(172, 'TradingTransaction', 'SubmitLetterToStockExchange', NULL, 1, GETDATE(), 1, GETDATE()), -- continuous disclosure stock exchange submit
	(172, 'TradingTransaction', 'ViewLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- continuous disclosure view stock exchange letter
	(172, 'TradingTransaction', 'SubmitSoftCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- continuous disclosure print stock exchange letter
	
	-- Disclosure Details for CO - Period End Disclosure - Submission to Stock Exchange - Disclosure Details for CO -  Period End Disclosure - Submission to Stock Exchange
	(173, 'TradingTransaction', 'CreateLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- period end disclosure create stock exchange soft-copy letter
	(173, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(173, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(173, 'TradingTransaction', 'CreateLetter', 'SaveLetter', 1, GETDATE(), 1, GETDATE()), -- period end disclosure save stock exchange soft-copy letter
	(173, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- period end disclosure stock exchange hard copy upload document
	(173, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- period end disclosure stock exchange hard copy delete document
	(173, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- period end disclosure stock exchange hard copy download document
	(173, 'TradingTransaction', 'SubmitLetterToStockExchange', NULL, 1, GETDATE(), 1, GETDATE()), -- period end disclosure stock exchange submit
	(173, 'TradingTransaction', 'ViewLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- period end disclosure view stock exchange letter
	(173, 'TradingTransaction', 'SubmitSoftCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- period end disclosure print stock exchange letter
	
	
	-- FOR INSIDER
	-- Disclosure Details for Insider - Policy Document List - Disclosure Details for Insider - Policy Document List (Insider)
	(154, 'InsiderInitialDisclosure', 'List', NULL, 1, GETDATE(), 1, GETDATE()), -- policy document applicable list
	(154, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(154, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(154, 'InsiderInitialDisclosure', 'DisplayPolicy', NULL, 1, GETDATE(), 1, GETDATE()), -- show policy document
	(154, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE()), -- get policy document content
	(154, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- download policy document
	
	-- Disclosure Details for Insider - Initial Disclosure - Disclosure Details for Insider - Initial Disclosure
	(155, 'InsiderInitialDisclosure', 'FilterIndex', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(155, 'InsiderInitialDisclosure', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure
	(155, 'InsiderInitialDisclosure', 'DisplayPolicy', NULL, 1, GETDATE(), 1, GETDATE()), -- show policy document
	(155, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE()), -- get policy document content
	(155, 'InsiderInitialDisclosure', 'PartialViewDocument', 'Next', 1, GETDATE(), 1, GETDATE()), -- initial disclosure next policy doc
	(155, 'InsiderInitialDisclosure', 'PartialViewDocument', 'Accept', 1, GETDATE(), 1, GETDATE()), -- initial disclosure accept poliyc doc
	(155, 'TradingTransaction', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure transaction details list
	(155, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(155, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(155, 'TradingTransaction', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure transaction details 
	(155, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure upload document
	(155, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure delete document
	(155, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure download document
	(155, 'TradingTransaction', 'Submit', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure submitted
	(155, 'TradingTransaction', 'Delete', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure delete transcation details
		
	-- Disclosure Details for Insider - Initial Disclosure Letter Submission - Disclosure Details for Insider -  Initial Disclosure Letter Submission
	(156, 'TradingTransaction', 'CreateLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure create soft-copy letter
	(156, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(156, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(156, 'TradingTransaction', 'CreateLetter', 'SaveLetter', 1, GETDATE(), 1, GETDATE()), -- initial disclosure save soft-copy letter
	(156, 'TradingTransaction', 'SubmitSoftCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure submit soft-copy letter OR print soft-copy letter
	(156, 'TradingTransaction', 'UploadHardDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure hard-copy letter
	(156, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure hard copy upload document
	(156, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure hard copy delete document
	(156, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure hard copy download document
	(156, 'TradingTransaction', 'SubmitHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure submit hard-copy letter
	(156, 'TradingTransaction', 'ViewLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure view soft-copy letter
	(156, 'TradingTransaction', 'ViewHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure view hard-copy letter
	(156, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE()), -- initial disclosure show hard copy document content
	
	-- Disclosure Details for Insider - Continuous Disclosure - Disclosure Details for Insider -  Continuous Disclosure
	(157, 'TradingTransaction', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure transaction details list
	(157, 'TradingTransaction', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure transaction details
	(157, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure upload document
	(157, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure delete document
	(157, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure download document
	(157, 'TradingTransaction', 'Submit', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure submitted
	(157, 'TradingTransaction', 'Delete', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure delete transcation details
	(157, 'TradingTransaction', 'TransactionNotTraded', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure submit not traded reason 
	(157, 'TradingTransaction', 'DeleteMaster', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure delete transaction master id becase no transaction details
	
	-- Disclosure Details for Insider - Continuous Disclosure Letter Submission - Disclosure Details for Insider -  Continuous Disclosure Letter Submission
	(158, 'TradingTransaction', 'CreateLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure create soft-copy letter
	(158, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(158, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(158, 'TradingTransaction', 'CreateLetter', 'SaveLetter', 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure save soft-copy letter
	(158, 'TradingTransaction', 'SubmitSoftCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure submit soft-copy letter OR print soft-copy letter
	(158, 'TradingTransaction', 'UploadHardDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure hard-copy letter
	(158, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure hard copy upload document
	(158, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure hard copy delete document
	(158, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure hard copy download document
	(158, 'TradingTransaction', 'SubmitHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure submit hard-copy letter
	(158, 'TradingTransaction', 'ViewLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure view soft-copy letter
	(158, 'TradingTransaction', 'ViewHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure view hard-copy letter
	(158, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure show hard copy document content
	
	-- Disclosure Details for Insider - Period End Disclosure - Disclosure Details for Insider -  Period End Disclosure
	(159, 'PeriodEndDisclosure', 'PeriodStatus', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure list
	(159, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(159, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(159, 'TradingTransaction', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure transaction details list
	(159, 'TradingTransaction', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure transaction details
	(159, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure upload document
	(159, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure delete document
	(159, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure download document
	(159, 'TradingTransaction', 'Submit', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure submitted
	(159, 'TradingTransaction', 'Delete', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure delete transcation details
	
	-- Disclosure Details for Insider - Period End Disclosure Letter Submission - Disclosure Details for Insider -  Period End Disclosure Letter Submission
	(160, 'TradingTransaction', 'CreateLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure create soft-copy letter
	(160, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(160, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(160, 'TradingTransaction', 'CreateLetter', 'SaveLetter', 1, GETDATE(), 1, GETDATE()), -- Period End disclosure save soft-copy letter
	(160, 'TradingTransaction', 'SubmitSoftCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure submit soft-copy letter OR print soft-copy letter
	(160, 'TradingTransaction', 'UploadHardDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure hard-copy letter
	(160, 'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure hard copy upload document
	(160, 'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure hard copy delete document
	(160, 'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure hard copy download document
	(160, 'TradingTransaction', 'SubmitHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure submit hard-copy letter
	(160, 'TradingTransaction', 'ViewLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure view soft-copy letter
	(160, 'TradingTransaction', 'ViewHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure view hard-copy letter
	(160, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE()) -- Period End disclosure show hard copy document content
	

/* 
Modified By		Modified On		Description  
Parag			23-Feb-2016		acid-url mapping for Role Management under Role Module
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- Role Master - View - View right for Role master 
	(19, 'RoleMaster', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Role list
	(19, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(19, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	
	-- Role Master - Create - Create right for Role master 
	(20, 'RoleMaster', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- create role 
	(20, 'RoleMaster', 'Create', 'Save', 1, GETDATE(), 1, GETDATE()), -- save role 
	
	-- Role Master - Edit - Edit right for Role master 
	(21, 'RoleMaster', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- Edit role details
	(21, 'RoleMaster', 'Create', 'Save', 1, GETDATE(), 1, GETDATE()), -- save edited role 
	(21, 'RoleMaster', 'Edit', NULL, 1, GETDATE(), 1, GETDATE()), -- Redirect to add activities for role
	(21, 'RoleActivity', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Add role activities 
	(21, 'RoleActivity', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()), -- Save activities for role
	(21, 'RoleActivity', 'Create', NULL, 1, GETDATE(), 1, GETDATE()), -- Save activities for role (using ajax)
	
	-- Role Master - Delete - Delete right for Role master 
	(22, 'RoleMaster', 'Delete', NULL, 1, GETDATE(), 1, GETDATE()) -- 

	
--------------------------------------------------------------------------------------------------
/*
Created By :- Tushar 
Date:- 23-Feb-2016

Module:- Trading Window event Finanicial Year & Other Module
*/
--------------------------------------------------------------------------------------------------
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
--Trading Window Other event
--View 
(134, 'TradingWindowsOther', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
(134, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
(134, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
(134,'TradingWindowsOther', 'Calender', NULL, 1, GETDATE(), 1, GETDATE()),

--Create
(135, 'TradingWindowsOther', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
(135, 'TradingWindowsOther', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()),

--Edit
(136, 'TradingWindowsOther', 'Edit', NULL, 1, GETDATE(), 1, GETDATE()),
(136, 'TradingWindowsOther', 'Create', 'Create', 1, GETDATE(), 1, GETDATE()),
(136, 'Applicability', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
(136, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
(136, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
(136,'Applicability', 'Apply', NULL, 1, GETDATE(), 1, GETDATE()),

--Delete
(137,'TradingWindowsOther', 'Create', 'DeleteEvent', 1, GETDATE(), 1, GETDATE()),
(137,'TradingWindowsOther', 'DeleteFromGrid', NULL, 1, GETDATE(), 1, GETDATE()),

--Trading Window event Finanicial Year
--View
(125, 'TradingWindowEvent', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
(125, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
(125, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
--Create
(126,'TradingWindowEvent', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
--Edit
(127,'TradingWindowEvent', 'Create', NULL, 1, GETDATE(), 1, GETDATE())


/* 
Modified By		Modified On		Description  
Parag			23-Feb-2016		acid-url mapping for Delegation Management under Role Module
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- Delegation Master - View - View right for Delegation master 
	(41, 'Delegate', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- Delegation list
	(41, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	(41, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()), -- 
	
	-- Delegation Master - Create - Create right for Delegation master 
	(42, 'Delegate', 'Index', NULL, 1, GETDATE(), 1, GETDATE()), -- add Delegation 
	(42, 'Delegate', 'Create', NULL, 1, GETDATE(), 1, GETDATE()),
	(42, 'Delegate', 'Edit', NULL, 1, GETDATE(), 1, GETDATE()), -- save delecation activities
	
	-- Delegation Master - Edit - Edit right for Delegation master 
	(43, 'Delegate', 'Edit', NULL, 1, GETDATE(), 1, GETDATE()), -- Edit Delegation details
	
	-- Delegation Master - Delete - Delete right for v master 
	(44, 'Delegate', 'Delete', NULL, 1, GETDATE(), 1, GETDATE()) -- 
	

/* 
Modified By		Modified On		Description  
Parag			23-Feb-2016		acid-url mapping for CO Dashboard link used on count
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- CO Dashboard link URL
	(165, 'COInitialDisclosure', 'ContinuousDisclosuresCODashnoard', NULL, 1, GETDATE(), 1, GETDATE()), -- Initial disclosure CO Count
	(165, 'COInitialDisclosure', 'InitialDisclosuresInsiderDashnoard', NULL, 1, GETDATE(), 1, GETDATE()), -- Initial disclosure Insider Count
	
	(167, 'PreclearanceRequest', 'PreClearancesCODashboard', NULL, 1, GETDATE(), 1, GETDATE()), -- Pre-clearances CO Count
	
	(167, 'PreclearanceRequest', 'TradeDetailsCO', NULL, 1, GETDATE(), 1, GETDATE()), -- Trade details CO Count
	(167, 'PreclearanceRequest', 'TradeDetailsInsider', NULL, 1, GETDATE(), 1, GETDATE()), -- Trade details Insider Count
	
	(167, 'PreclearanceRequest', 'ContinuousDisclosuresCODashnoard', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous Disclosures CO Count
	(167, 'PreclearanceRequest', 'ContinuousDisclosuresInsiderDashnoard', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous Disclosures Insider Count
	
	(167, 'PreclearanceRequest', 'SubmissionToStockExchangeCODashnoard', NULL, 1, GETDATE(), 1, GETDATE()), -- Submission to Stock Exchange CO Count
	
	(169, 'PeriodEndDisclosure', 'PeriodEndDisclosuresInsiderDashnoard', NULL, 1, GETDATE(), 1, GETDATE()) -- Period End Disclosures Insider Count
	

--------------------------------------------------------------------------------------------------
/*
Created By :- Tushar 
Date:- 23-Feb-2016

Module:- Change Password Module
*/
--------------------------------------------------------------------------------------------------
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
(84,'UserDetails', 'ChangePassword', NULL, 1, GETDATE(), 1, GETDATE()),
(84,'UserDetails', 'ChangePassword', 'Create', 1, GETDATE(), 1, GETDATE())

--------------------------------------------------------------------------------------------------4



/*
Modified By		Modified On		Description 
Gaurishankar	24-Feb-2016		acid-url mapping for Communication Rule. 

ActivityID	ScreenName	ActivityName
181	Communication Rules	Add
182	Communication Rules	Edit

*/

INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	(182, 'Applicability', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
	(182, 'Applicability', 'Apply', NULL, 1, GETDATE(), 1, GETDATE())


--------------------------------------------------------------------------------------------------
/*
Created By :- Tushar 
Date:- 10-Mar-2016

Module:- Trading Policy(Documents Upload missing script) Module
*/
--------------------------------------------------------------------------------------------------
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
(122,'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()),
(122,'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()),
(122,'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()),
(123,'Document', 'UploadDocument', NULL, 1, GETDATE(), 1, GETDATE()),
(123,'Document', 'DeleteSingleDocumentDetails', NULL, 1, GETDATE(), 1, GETDATE()),
(123,'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE()),
(121,'Document', 'Download', NULL, 1, GETDATE(), 1, GETDATE())


	