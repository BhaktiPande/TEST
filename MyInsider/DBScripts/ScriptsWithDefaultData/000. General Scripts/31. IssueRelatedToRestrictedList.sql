-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 15-JUL-2016                                                 							=
-- Description : THIS Script IS USED FOR RESTRICTED LIST												=
--																										=
-- ======================================================================================================


IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 197 AND ControllerName = 'RestrictedList' AND ActionName = 'Create')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(197, 'RestrictedList', 'Create', NULL, 1, GETDATE(), 1 , GETDATE())	
END

IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 197 AND ControllerName = 'Applicability' AND ActionName = 'Index')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(197, 'Applicability', 'Index', NULL, 1, GETDATE(), 1 , GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 198 AND ControllerName = 'Applicability' AND ActionName = 'Index')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(198, 'Applicability', 'Index', NULL, 1, GETDATE(), 1 , GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 198 AND ControllerName = 'DatatableGrid' AND ActionName = 'Index')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(198, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1 , GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 198 AND ControllerName = 'DatatableGrid' AND ActionName = 'AjaxHandler')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(198, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1 , GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 198 AND ControllerName = 'Applicability' AND ActionName = 'Apply')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(198, 'Applicability', 'Apply', NULL, 1, GETDATE(), 1 , GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 199 AND ControllerName = 'RestrictedList' AND ActionName = 'Create')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(199, 'RestrictedList', 'Create', NULL, 1, GETDATE(), 1 , GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 199 AND ControllerName = 'Applicability' AND ActionName = 'Index')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(199, 'Applicability', 'Index', NULL, 1, GETDATE(), 1 , GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 199 AND ControllerName = 'DatatableGrid' AND ActionName = 'Index')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(199, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1 , GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 199 AND ControllerName = 'DatatableGrid' AND ActionName = 'AjaxHandler')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(199, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1 , GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 199 AND ControllerName = 'Applicability' AND ActionName = 'Apply')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(199, 'Applicability', 'Apply', NULL, 1, GETDATE(), 1 , GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 200 AND ControllerName = 'RestrictedList' AND ActionName = 'DeleteFromGrid')
BEGIN 
	INSERT INTO usr_ActivityURLMapping (ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
	(200, 'RestrictedList', 'DeleteFromGrid', NULL, 1, GETDATE(), 1 , GETDATE())
END






