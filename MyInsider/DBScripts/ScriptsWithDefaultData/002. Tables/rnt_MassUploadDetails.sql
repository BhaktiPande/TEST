/****** Object:  Table [dbo].[rnt_MassUploadDetails]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rnt_MassUploadDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rnt_MassUploadDetails](
	[RntInfoId] [int] IDENTITY(1,1) NOT NULL,
	[RntUploadDate] [datetime] NOT NULL,
	[PANNumber] [varchar](20) NULL,
	[SecurityType] [varchar](50) NULL,
	[SecurityTypeCode] [varchar](50) NULL,
	[DPID] [varchar](50) NULL,
	[ClientId] [varchar](50) NULL,
	[DematAccountNo] [varchar](50) NULL,
	[UserInfoId] [varchar](50) NULL,
	[UserName] [varchar](200) NULL,
	[Shares] [varchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RntInfoId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
