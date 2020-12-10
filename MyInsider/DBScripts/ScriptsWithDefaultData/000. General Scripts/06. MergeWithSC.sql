--------------------------------------------------------------------------------------------------
/*
Script received from Tushar on 17-Mar-2016
Module:- Trading Window event Calendar display for Insider
*/
--------------------------------------------------------------------------------------------------
INSERT INTO usr_Activity
(ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, 
CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES 
(215, 'Trading Window Calender', 'Calender', 103006, NULL, 'View Calender for Insider', 105001, 1, GETDATE(), 1, GETDATE())
GO

INSERT INTO usr_UserTypeActivity(ActivityId,UserTypeCodeId)
VALUES(215,101003)
,(215,101004)
,(215,101006)
GO

INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
--Trading Window Other event
--View 
(215, 'DatatableGrid', 'Index', NULL, 1, GETDATE(), 1, GETDATE()),
(215, 'DatatableGrid', 'AjaxHandler', NULL, 1, GETDATE(), 1, GETDATE()),
(215,'TradingWindowsOther', 'Calender', NULL, 1, GETDATE(), 1, GETDATE())
GO
 --------------------------------------------------------------------------------------------------

/*
Received from Raghvendra: 21-Mar-2016
Corrected the screen code and module code for the policy document list seen by insiders i.e. not co users
*/
UPDATE mst_Resource SET ModuleCodeId = 103008, ScreenCodeId = 122043 WHERE ResourceId in (15344,15345,15346,15347,15415,15348)
GO

/* Received from Tushar: 22-Mar-2016 */

INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(175, 'Contra Trade Option', 'Contra Trade Without Quantiy(General Option) & Quantity Base', 1, 0)
GO

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(175001, 'Contra Trade Without Quantiy(General Option)', 175, 'Contra Trade Without Quantiy(General Option)', 1, 1, GETDATE(), 1),
(175002, 'Contra Trade Quantiy Base', 175, 'Contra Trade Quantiy Base', 1, 1, GETDATE(), 2)
GO

INSERT INTO mst_Resource(ResourceId,ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
VALUES 
(15447,'rul_msg_15447', 'Set the Contra Trade Option for Selection of QTY Yes/No configuration. Please contact the Administrator', 'Set the Contra Trade Option for Selection of QTY Yes/No configuration. Please contact the Administrator', 'en-US', 103006, 104001,122040, 1, GETDATE())
GO

/*Start changes from ED during Code MErge on 22-Mar-2016*/

ALTER TABLE mst_Company ADD ContraTradeOption INT NULL 
GO


---175001 - Contra Trade without quantity
---175002 - Contra Trade with quantity
UPDATE mst_Company SET ContraTradeOption = 175001 WHERE CompanyId  = 1 AND IsImplementing = 1
GO


INSERT INTO com_CodeGroup
(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable)
VALUES
(176, 'Transaction Identification Code', 'Transaction Identification Code like PCL,PNT,PNR etc.', 1, 0)
GO

INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
VALUES
(176001, 'PCL', 176, 'This code is Used when Insider taken Preclerance', 1, 1, GETDATE(), 1),
(176002, 'PNT', 176, 'This code is Used when Insider not taken Preclerance', 1, 1, GETDATE(), 2),
(176003, 'PNR', 176, 'This code is Used for employee those are non insider', 1, 1, GETDATE(), 3),
(176004, 'PE', 176, 'This code is Used for Period End Transaction', 1, 1, GETDATE(), 4)
GO


INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	(166, 'TradingTransaction', 'ViewLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- Initial disclosure to Letter
	(167, 'TradingTransaction', 'ViewLetter', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure to Letter
	(166, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE()), -- Initial Disclosure Display Hard Copy
	(167, 'InsiderInitialDisclosure', 'Generate', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous Disclosure Display Hard Copy	
	(166, 'TradingTransaction', 'ViewHardCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Initial disclosure to Letter
	(167, 'TradingTransaction', 'ViewHardCopy', NULL, 1, GETDATE(), 1, GETDATE()) -- Continuous disclosure to Letter
GO