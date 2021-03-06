/****** Object:  Table [dbo].[rnt_MassUploadDetails_bak]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rnt_MassUploadDetails_bak]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rnt_MassUploadDetails_bak](
	[RntBackupId] [int] IDENTITY(1,1) NOT NULL,
	[LotNumber] [varchar](50) NULL,
	[BackUpDate] [datetime] NULL,
	[RntInfoId] [int] NULL,
	[RntUploadDate] [datetime] NULL,
	[PANNumber] [varchar](50) NULL,
	[SecurityType] [varchar](50) NULL,
	[SecurityTypeCode] [varchar](50) NULL,
	[DPID] [varchar](50) NULL,
	[ClientId] [varchar](50) NULL,
	[DematAccountNo] [varchar](50) NULL,
	[UserInfoId] [varchar](50) NULL,
	[UserName] [varchar](200) NULL,
	[Shares] [decimal](10, 0) NULL,
	[Equity] [decimal](10, 2) NULL,
	[Category] [varchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
