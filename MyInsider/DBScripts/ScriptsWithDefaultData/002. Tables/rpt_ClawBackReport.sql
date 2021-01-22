/****** Object:  Table [dbo].[rpt_ClawBackReport]    Script Date: 08/17/2018 14:46:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_ClawBackReport]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[rpt_ClawBackReport](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UserInfoID] INT NOT NULL,
		[TransactionMasterId] BIGINT NOT NULL,
		[EmployeeID] [nvarchar] (100) NULL,
		[InsiderName] [nvarchar] (250) NULL,
		[PAN] [nvarchar] (50) NULL,
		[UserAddress] [nvarchar] (500) NULL,
		[PinCode] [nvarchar] (50) NULL,
		[Country] [nvarchar] (50) NULL,
		[MobileNumber] [nvarchar] (50) NULL,
		[Email] [nvarchar] (100) NULL,
		[CompanyName] [nvarchar] (100) NULL,
		[TypeOfInsider] [nvarchar] (50) NULL,
		[Category] [nvarchar] (100) NULL,
		[Subcategory] [nvarchar] (100) NULL,
		[CINDIN] [nvarchar] (100) NULL,
		[Designation] [nvarchar] (100) NULL,
		[Grade] [nvarchar] (50) NULL,
		[Location] [nvarchar] (100) NULL,
		[Department] [nvarchar] (100) NULL,
		[DmatAccount] [nvarchar] (100) NULL,
		[AccountHolderName] [nvarchar] (255) NULL,
		[PreclearanceID] [nvarchar] (100) NULL,
		[RequestDate] [datetime] NULL,
		[SecurityType] [nvarchar] (50) NULL,
		[TransactionType] [nvarchar] (50) NULL,
		[TransactionDate] [datetime] NULL,
		[Quantity] [decimal] (10, 0) NULL,
	    [Value] [decimal] (10, 0) NULL,

	CONSTRAINT [PK_rpt_ClawBackReport] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO

IF NOT EXISTS(
SELECT TABLE_CATALOG 
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_NAME = 'rpt_ClawBackReport' 
	AND COLUMN_NAME = 'Currency')
BEGIN
ALTER TABLE rpt_EmpDematwiseDetails
Add  Currency NVARCHAR(50)
END