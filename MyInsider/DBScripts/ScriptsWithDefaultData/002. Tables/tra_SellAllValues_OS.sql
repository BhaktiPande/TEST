SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_SellAllValues_OS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_SellAllValues_OS](
	[SellAllDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[TransactionMasterId] bigint not null,
	[SellAllFlag] BIT,	
	[ForUserInfoId] int  null,
	[CompanyId]	int null,
	[DMATDetailsId] int null,
	[CreatedOn] [datetime]  NULL,	
	[ModifiedOn] [datetime]  NULL,
 CONSTRAINT [PK_tra_SellAllValues_OS] PRIMARY KEY CLUSTERED 
(
	[SellAllDetailsId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

--drop table tra_SellAllValues_OS