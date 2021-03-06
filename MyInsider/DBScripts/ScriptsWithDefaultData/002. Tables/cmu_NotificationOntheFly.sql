/****** Object:  Table [dbo].[cmu_NotificationOntheFly]    Script Date: 11/06/2019 10:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmu_NotificationOntheFly]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cmu_NotificationOntheFly](
	[NotificationId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int]  NULL,
	[To] [nvarchar](250) NULL,
	[CC] [nvarchar](250) NULL,
	[Subject] [nvarchar](150) NULL,
	[Contents] [nvarchar](max) NULL,
	[Signature] [nvarchar](200) NULL,
	[CommunicationFrom] [varchar](100) NULL,
	[ResponseStatusCodeId] [int] NULL,
	[ResponseMessage] [nvarchar](200) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_cmu_NotificationOntheFly] PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
