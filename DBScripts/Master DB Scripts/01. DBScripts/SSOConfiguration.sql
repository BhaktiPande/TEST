USE [Vigilante_Master]
GO

/****** Object:  Table [dbo].[SSOConfiguration]    Script Date: 11/20/2020 04:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SSOConfiguration](
	[SSOId] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [int] NULL,
	[GroupName] [nvarchar](100) NULL,
	[CompanyName] [nvarchar](100) NULL,
	[InsertionType] [nvarchar](50) NULL,
	[IDP_SP_URL] [nvarchar](1000) NULL,
	[DestinationURL] [nvarchar](1000) NULL,
	[AssertionConsumerServiceURL] [nvarchar](1000) NULL,
	[IssuerURL] [nvarchar](1000) NULL,
	[RelayState] [nvarchar](1000) NULL,
	[CertificateName] [nvarchar](200) NULL,
	[Certificate] [nvarchar](max) NULL,
	[Parameters] [nvarchar](1000) NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](100) NULL,
	[UpdatedDate] [datetime] NULL,
	[Status] [bit] NULL,
	[IsSSOLoginActiveForEmployee] [bit] NULL,
	[IsSSOLoginActiveForCO] [bit] NULL,
	[IsSSOLoginActiveForNonEmployee] [bit] NULL,
	[IsSSOLoginActiveForCorporateUser] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[SSOId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


