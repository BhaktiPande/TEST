IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UpsiTempDataDetails')
	DROP PROCEDURE st_usr_UpsiTempDataDetails
GO

IF EXISTS(SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'UpsiTempSharingDataType')
BEGIN
	DROP TYPE [dbo].[UpsiTempSharingDataType];
END


CREATE TYPE [dbo].[UpsiTempSharingDataType] AS TABLE(
	[Company_Name] [varchar](500) NULL,
	[Company_Address] [varchar](500) NULL,
	[Category_Shared] [nvarchar](50) NULL,
	[Reason_sharing] [nvarchar](500) NULL,
	[Comments] [nvarchar](500) NULL,
	[PAN] [nvarchar](50) NULL,
	[Name] [nvarchar](250) NULL,
	[Phone] [nvarchar](15) NULL,
	[E_mail] [nvarchar](250) NULL,
	[SharingDate] [datetime] NULL,
	[UserInfoId] [int] NOT NULL,
	[ModeOfSharing] [int] NULL,
	[SharingTime] [time](7) NULL,
	[IsRegisteredUser] [nvarchar](250) NULL,
	[Temp2] [nvarchar](250) NULL,
	[Temp3] [nvarchar](250) NULL,
	[Temp4] [nvarchar](250) NULL,
	[Temp5] [nvarchar](250) NULL,
	[DocumentNo] [nvarchar](250) NULL,
	[Sharedby] [nvarchar](250) NULL,
	[PublishDate] [datetime] NULL
)
GO