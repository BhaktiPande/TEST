
/****** Object:  Table [dbo].[rpt_EmpDematwiseDetails]    Script Date: 27-07-2018 16:14:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_EmpDematwiseDetails]') AND type in (N'U'))
BEGIN

DROP TABLE rpt_EmpDematwiseDetails

END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_EmpDematwiseDetails]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[rpt_EmpDematwiseDetails](
	
	[ID] [INT] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](200) NULL,
	[EmployeeId][nvarchar](100) NULL,
	[SelfOrRelative][nvarchar](100) NULL,
	[Relation][nvarchar](100) NULL,
	[FirstName] [nvarchar](100) NULL,
	[MiddleName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[AddressLine1] [nvarchar](1000) NULL,
	[PinCode] [nvarchar](100) NULL,
	[CountryName] [nvarchar](100) NULL,
	[EmailId] [nvarchar](100) NULL,
	[MobileNumber] [nvarchar](100) NULL,
	[PAN] [nvarchar](100) NULL,	
	[RoleName] [nvarchar](100) NULL,
	[CompanyName] [nvarchar](1000) NULL,
	[DateOfBecomingInsider] [nvarchar](100) NULL,
	[EmpStatus] [nvarchar](100) NULL,
	[DateOfSeparation] [nvarchar](100) NULL,
	[EmpActiveInactive] [nvarchar](100) NULL,
	[DateOfInactivation] [nvarchar](100) NULL,
	[Category] [nvarchar](512) NULL,
	[SubCategory] [nvarchar](512) NULL,
	[Designation] [nvarchar](512) NULL,
	[Sub-Designation] [nvarchar](512) NULL,
	[Grade] [nvarchar](512) NULL,
	[Location] [nvarchar](max) NULL,
	[DIN] [nvarchar](100) NULL, 		
	[Department] [nvarchar](512) NULL,
	[SecurityType] [nvarchar](100) NULL,
	[DMATAccNumber] [nvarchar](100) NULL,
	[DepositParticipantName] [nvarchar](512) NULL,
	[DepositParticipantID] [nvarchar](100) NULL,
	[TMID] [nvarchar](100) NULL,
	[Holdings] [nvarchar](100) NULL	
)

END

GO




