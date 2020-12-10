IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'ContactDetailsType')
BEGIN
	DROP TYPE ContactDetailsType
END
GO

CREATE TYPE [ContactDetailsType] AS TABLE(
       
		MobileNumber				Varchar(250),
		UserInfoID                  INT NOT NULL,
		UserRelativeID				INT NOT NULL
		
)


