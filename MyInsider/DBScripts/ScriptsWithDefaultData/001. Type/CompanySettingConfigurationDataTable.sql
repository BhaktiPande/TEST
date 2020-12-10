/*
	Script from Parag on 13 September 2016
	Create Data table to save company configuration
	
	Modification History:
	Modified By		Modified On		Description
	Priyanka,Rutuja 14-Dec-2016		added RLSearchLimit column value 

*/

/****** Object:  UserDefinedTableType [dbo].[CompanySettingConfigurationDataTable]    Script Date: 12/14/2016 16:47:02 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'CompanySettingConfigurationDataTable' AND ss.name = N'dbo')
DROP TYPE [dbo].[CompanySettingConfigurationDataTable]
GO

CREATE TYPE [dbo].[CompanySettingConfigurationDataTable] AS TABLE(
	[ConfigurationTypeCodeId] [int] NOT NULL,
	[ConfigurationCodeId] [int] NOT NULL,
	[ConfigurationValueCodeId] [int] NULL DEFAULT (NULL),
	[ConfigurationValueOptional] [varchar](1000) NULL DEFAULT (NULL),
	[IsMappingCode] [bit] NOT NULL DEFAULT ((0)),
	[ModifiedBy] [int] NOT NULL,
	[RLSearchLimit] [int] NULL
)
GO
