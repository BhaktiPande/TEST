SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_QuantityValueDetails_OS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_QuantityValueDetails_OS](
	[DetailsId] [int] IDENTITY(1,1) NOT NULL,
	[Quantity] decimal(10,0) null,
	[Value] decimal(10,0) null,
	[LotSize] int null,
	[ContractSpecification] varchar(50) null,
	[TransactionType]	int null ,
	[DisclouserType] int null,
	[CreatedBy] [int]  NULL,
	[CreatedOn] [datetime]  NULL,
	[ModifiedBy] [int]  NULL,
	[ModifiedOn] [datetime]  NULL,
 CONSTRAINT [PK_tra_QuantityValueDetails_OS] PRIMARY KEY CLUSTERED 
(
	[DetailsId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

