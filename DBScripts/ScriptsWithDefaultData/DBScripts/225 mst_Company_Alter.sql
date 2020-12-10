/* 20-Jan-2016 : Script for Alter table to add new column in table */
ALTER TABLE mst_Company ADD TradingDaysCountType INT NULL

GO
------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (225, '225 mst_Company_Alter', 'mst_Company Alter to add new column for trading days count type', 'Parag')

------------------------------------------------------------------------------------------------------------------------