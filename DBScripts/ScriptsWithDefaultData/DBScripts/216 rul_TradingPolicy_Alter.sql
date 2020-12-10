/* 21-Dec-2015 : Script for Alter table to add new column in table */

ALTER TABLE rul_TradingPolicy ADD TradingThresholdLimtResetFlag BIT NULL

GO
------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (216, '216 rul_TradingPolicy_Alter', 'rul_TradingPolicy Alter to add new column for trading threshold limit reset flag', 'Parag')


