
/****** Object:  Table [dbo].[rpt_RestrictedListDetails]    Script Date: 27-07-2018 16:14:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_RestrictedListDetails]') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[rpt_RestrictedListDetails](	

	[CompanyName] [nvarchar](100) NULL,	
	[Department] [nvarchar](100) NULL,	
	[BSECode] [nvarchar](100) NULL,	
	[NSECode] [nvarchar](100) NULL,	
	[ISINCode] [nvarchar](100) NULL,	
	[ApplicableFromDate] [nvarchar](100) NULL,	
	[ApplicableToDate] [nvarchar](100) NULL
	
)

END

GO




