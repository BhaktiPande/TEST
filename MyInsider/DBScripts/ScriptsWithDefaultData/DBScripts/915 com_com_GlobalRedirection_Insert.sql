-- Populate data to com_GlobalRedirectionControllerAction


INSERT INTO com_GlobalRedirectionControllerActionPair(ID, ControllerActionName, ModifiedBy, ModifiedOn)
VALUES
(1,'HomeIndex',1,GETDATE()),
(2,'InsiderInitialDisclosureIndex',1,GETDATE()),
(3,'PreclearanceRequestIndex',1,GETDATE()),
(4,'PeriodEndDisclosurePeriodStatus',1,GETDATE()),
(5,'PreclearanceRequestPreClearanceNotTakenAction',1,GETDATE()),
(6,'PreclearanceRequestCreate',1,GETDATE()),
(7,'InsiderDashboardIndex',1,GETDATE())
---------------------------------------------------------------------------------------------------------

-- Populate data to com_GlobalRedirectToURL
INSERT INTO com_GlobalRedirectToURL(ID, Controller, Action, Parameter, ModifiedBy, ModifiedOn)
VALUES
(1,'InsiderInitialDisclosure','FilterIndex','acid,155',1,GETDATE()),
(2,'InsiderInitialDisclosure','DisplayPolicy','acid,155,CalledFrom,ViewAgree',1,GETDATE()),
/* Sent by Parag on 16-Sep-2015 */
(3, 'Employee', 'Create', 'acid,7', 1, GETDATE()),
(4, 'CorporateUser', 'Edit', 'acid,7', 1, GETDATE()),
(5, 'NonEmployeeInsider', 'Create', 'acid,7', 1, GETDATE())
