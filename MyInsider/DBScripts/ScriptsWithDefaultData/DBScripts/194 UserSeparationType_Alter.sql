IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_usr_UserInfoSeparationSave]') AND type in (N'P', N'PC'))
DROP PROCEDURE st_usr_UserInfoSeparationSave
GO

IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'UserSeparationType' AND ss.name = N'dbo')
DROP TYPE [UserSeparationType]
GO

/****** Object:  UserDefinedTableType [dbo].[UserSeparationType]    Script Date: 10/12/2015 12:03:34 ******/
CREATE TYPE [dbo].[UserSeparationType] AS TABLE(
	[UserInfoId] int NOT NULL,
	[DateOfSeparation] datetime NOT NULL,
	[ReasonForSeparation] nvarchar(200) NOT NULL,
	NoOfDaysToBeActive INT NULL,
	DateOfInactivation DATETIME NULL
)

----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (194, '194 UserSeparationType_Alter', 'UserSeparationType Alter', 'GS')
