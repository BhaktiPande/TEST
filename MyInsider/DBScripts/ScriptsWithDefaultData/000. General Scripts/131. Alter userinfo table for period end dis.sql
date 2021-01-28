Declare @DatabaseName varchar(100)
Declare @CompanyName varchar(100)

SELECT @DatabaseName = DB_NAME()
SELECT @CompanyName = CompanyName from Vigilante_Master..Companies where ConnectionDatabaseName = @DatabaseName

IF(@CompanyName = 'Kotak')
BEGIN
	print 'This is kotak database'
END
ELSE
BEGIN

	--Drop existing default constraint
	DECLARE @sql NVARCHAR(MAX)

    SELECT TOP 1 @sql = N'alter table usr_UserInfo drop constraint ['+dc.NAME+N']'
    from sys.default_constraints dc
    JOIN sys.columns c
        ON c.default_object_id = dc.object_id
    WHERE 
        dc.parent_object_id = OBJECT_ID('usr_UserInfo')
    AND c.name = N'PeriodEndDisclosureUploaded'
    --IF @@ROWCOUNT = 0 BREAK
	--print @sql
	EXEC (@sql)
	--return

	--add default constraint with value
	ALTER TABLE usr_UserInfo
	ADD DEFAULT 186001 FOR [PeriodEndDisclosureUploaded]
	
END

