/****** Object:  Table [dbo].[rnt_MassUploadHistory]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rnt_MassUploadHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rnt_MassUploadHistory](
	[MassUploadHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[UserInfoId] [int] NULL,
	[EmployeeId] [varchar](300) NULL,
	[EmployeeName] [varchar](300) NULL,
	[Designation] [varchar](300) NULL,
	[Grade] [varchar](300) NULL,
	[Location] [varchar](300) NULL,
	[Department] [varchar](300) NULL,
	[CompanyName] [varchar](300) NULL,
	[TypeofInsider] [varchar](300) NULL,
	[RelationWithEmployee] [varchar](300) NULL,
	[ReletiveName] [varchar](300) NULL,
	[PAN] [varchar](300) NULL,
	[SecurityType] [varchar](300) NULL,
	[SecurityTypeCode] [varchar](300) NULL,
	[Quantity] [decimal](10, 0) NULL,
	[DPID] [varchar](300) NULL,
	[DEMATAccountNumber] [varchar](300) NULL,
	[RnT_PAN] [varchar](300) NULL,
	[RnT_SecurityType] [varchar](300) NULL,
	[RnT_SecurityTypeCode] [varchar](300) NULL,
	[RnT_DPID] [varchar](300) NULL,
	[RnT_DEMAT] [varchar](300) NULL,
	[RnT_Quantity] [decimal](10, 0) NULL,
	[COMMENT] [varchar](300) NULL,
	[RntUploadDate] [datetime] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
