/* 
Received from Raghvendra: 28-Mar-2016
Missing scripts for the screen related to print letter for continuous disclosure.
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	--Disclosure Details for CO - Continuous Disclosure - Disclosure Details for CO - Continuous Disclosure Submission
	(167, 'TradingTransaction', 'SubmitSoftCopy', NULL, 1, GETDATE(), 1, GETDATE()), -- Continuous disclosure submit soft-copy letter OR print soft-copy letter
	(167, 'TradingTransaction', 'SubmitHardCopy', NULL, 1, GETDATE(), 1, GETDATE()) -- continuous disclosure submit hard-copy letter