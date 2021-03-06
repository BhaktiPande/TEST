/*	
	Created On:- 08-Sept-2016
	Description:- Create table to store the formatted Form E and other forms wherein placeholders are replaced with actual data
*/

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tra_GeneratedFormDetails'))
BEGIN
	CREATE TABLE tra_GeneratedFormDetails
	(
		GeneratedFormDetailsId BIGINT NOT NULL IDENTITY (1, 1),
		TemplateMasterId INT NOT NULL CONSTRAINT FK_tra_GeneratedFormDetails_TemplateMasterId_tra_TemplateMaster_TemplateMasterId FOREIGN KEY(TemplateMasterId) REFERENCES tra_TemplateMaster(TemplateMasterId),
		MapToTypeCodeId INT NOT NULL CONSTRAINT FK_tra_GeneratedFormDetails_MapToTypeCodeId_com_Code_CodeID FOREIGN KEY(MapToTypeCodeId) REFERENCES com_Code(CodeID),
		MapToId INT NOT NULL,
		GeneratedFormContents NVARCHAR(MAX) NOT NULL,
		CreatedBy INT NOT NULL CONSTRAINT FK_tra_GeneratedFormDetails_CreatedBy_UserInfo_UserInfoId FOREIGN KEY(CreatedBy) REFERENCES usr_UserInfo(UserInfoId),
		CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
		ModifiedBy INT NOT NULL CONSTRAINT FK_tra_GeneratedFormDetails_ModifiedBy_UserInfo_UserInfoId FOREIGN KEY(ModifiedBy) REFERENCES usr_UserInfo(UserInfoId),
		ModifiedOn DATETIME NOT NULL DEFAULT GETDATE(),
		CONSTRAINT [PK_tra_GeneratedFormDetails] PRIMARY KEY CLUSTERED 
		(
			[GeneratedFormDetailsId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO