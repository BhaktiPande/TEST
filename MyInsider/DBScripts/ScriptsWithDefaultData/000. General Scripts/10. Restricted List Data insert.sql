
-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 07-APR-2016                                                 							=
-- Description : INSERT DATA IN usr_ActivityURLMapping TABLE FOR RESTRICTED LIST						=
-- ======================================================================================================


IF NOT EXISTS (SELECT 1 FROM usr_ActivityURLMapping WHERE ActivityID IN(197,198) AND ControllerName IN ('RestrictedList','DatatableGrid'))
BEGIN
	INSERT INTO usr_ActivityURLMapping
		(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES
		(197, 'RestrictedList', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),		
		(197, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
		(197, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
		(198, 'RestrictedList', 'Create', NULL, 1, GETDATE(), 1, GETDATE())
END
