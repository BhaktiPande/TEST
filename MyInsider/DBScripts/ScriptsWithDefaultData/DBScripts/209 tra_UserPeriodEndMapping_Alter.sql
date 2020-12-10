/*27-Nov-2015 : Script to Alter table to make YearCodeId, PeriodCodeId and PEEndDate column nullable */


ALTER TABLE tra_UserPeriodEndMapping ALTER COLUMN PeriodCodeId INTEGER NULL
GO
ALTER TABLE tra_UserPeriodEndMapping ALTER COLUMN PEStartDate DATETIME NULL
GO
ALTER TABLE tra_UserPeriodEndMapping ALTER COLUMN PEEndDate DATETIME NULL
GO
------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (209, '209 tra_UserPeriodEndMapping_Alter', 'tra_UserPeriodEndMapping Alter to make PeriodCodeId, PEStartDate, PEEndDate column nullable', 'Parag')
