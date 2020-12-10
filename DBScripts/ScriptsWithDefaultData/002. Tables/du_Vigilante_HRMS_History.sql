
/****** Object:  Table [dbo].[du_Vigilante_HRMS_History]    Script Date: 16-07-2018 16:14:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[du_Vigilante_HRMS_History]') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[du_Vigilante_HRMS_History](
	[EMPLOYEE_NUMBER] [varchar](max) NULL,
	[FIRST_NAME] [varchar](max) NULL,
	[MIDDLE_NAMES] [varchar](max) NULL,
	[LAST_NAME] [varchar](max) NULL,
	[CITY] [varchar](max) NULL,
	[PINCODE] [varchar](max) NULL,
	[MOBILE_NO] [varchar](max) NULL,
	[OFFICIAL_EMAIL_ID] [varchar](max) NULL,
	[PAN_NUMBER] [varchar](max) NULL,
	[ROLE_NAME] [varchar](max) NULL,
	[DATE_OF_JOINING] [varchar](max) NULL,
	[GRADE_NAME] [varchar](max) NULL,
	[DEPARTMENT] [varchar](max) NULL,
	[DATE_OF_SEPERATION] [varchar](max) NULL,
	[REASON_FOR SEPERATION] [varchar](max) NULL,
	[NO_OF_DAYS_TO_BE_ACTIVE] [varchar](max) NULL,
	[CREATED_ON] DATETIME,
	[ROW_NO] [bigint] IDENTITY(1,1) NOT NULL,	
PRIMARY KEY CLUSTERED 
(
	[ROW_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

END

GO




