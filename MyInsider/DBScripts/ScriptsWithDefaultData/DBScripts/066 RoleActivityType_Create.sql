CREATE TYPE RoleActivityType AS TABLE 
(
    RoleId INT, ActivityId INT
)

----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (66, '066 RoleActivityType_Create', 'Create RoleActivityType', 'Arundhati')
