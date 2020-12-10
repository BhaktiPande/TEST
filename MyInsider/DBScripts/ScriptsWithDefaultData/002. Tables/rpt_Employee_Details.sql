
/****** Object:  Table [dbo].[rpt_EmployeeHoldingDetails ]    Script Date: 26-07-2018 16:14:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_EmployeeHoldingDetails]') AND type in (N'U'))
BEGIN

DROP TABLE rpt_EmployeeHoldingDetails

END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_EmployeeHoldingDetails ]') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[rpt_EmployeeHoldingDetails](

	[ID] [INT] IDENTITY(1,1) NOT NULL,
	[UserInfoId] [nvarchar](25) NULL,
	[UserName] [nvarchar](50) NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[CompanyName] [nvarchar](1000) NULL,
	[RoleName] [nvarchar](200) NULL,
	[AddressLine1] [nvarchar](1000) NULL,
	[PinCode] [nvarchar](50) NULL,
	[CountryName] [nvarchar](500) NULL,
	[EmailId] [nvarchar](250) NULL,
	[MobileNumber] [nvarchar](25) NULL,
	[PAN] [nvarchar](50) NULL,
	[DateOfJoining] [nvarchar](50) NULL,
	[DateOfBecomingInsider] [nvarchar](50) NULL,
	[EmpStatus] [nvarchar](200) NULL,
	[DateOfSeparation] [nvarchar](50) NULL,
	[EmpActiveInactive] [nvarchar](50) NULL,
	[DateOfInactivation] [nvarchar](50) NULL,	
	[Category] [nvarchar](512) NULL,
	[SubCategory] [nvarchar](512) NULL,
	[Designation] [nvarchar](512) NULL,
	[Sub-Designation] [nvarchar](512) NULL,
	[Grade] [nvarchar](512) NULL,
	[Location] [nvarchar](max) NULL,
	[DIN] [nvarchar](200) NULL, 		
	[Department] [nvarchar](512) NULL,
	[TradingPolicyName] [nvarchar](500) NULL,
	[TradePolicyFromDate] [nvarchar](200) NULL ,
	[TradePolicyToDate] [nvarchar](200) NULL,
	[SecurityType] [nvarchar](500) NULL,
	[SelfHoldings] [nvarchar](200) NULL,
	[RelativesHolding] [nvarchar](200) NULL,
	[TotalHoldingsSelfRelatives] [nvarchar](200) NULL
	
)
END

GO




