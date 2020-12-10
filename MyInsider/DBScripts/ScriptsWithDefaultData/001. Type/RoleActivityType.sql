
IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'RoleActivityType')
BEGIN
	DROP TYPE RoleActivityType
END
GO

CREATE TYPE RoleActivityType AS TABLE 
(
    RoleId INT, ActivityId INT
)