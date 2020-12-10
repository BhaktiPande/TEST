/*
	Created By  : Arvind	
	Created On  : 25-Apri-2019
	Description : This script is used to create a table with name 'usr_UPSIDocumentMaster'

	Drop Table usr_UPSIDocumentMasters

*/
IF EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'usr_UPSIDocumentMasters')
DROP TABLE usr_UPSIDocumentMasters
GO
	CREATE TABLE dbo.usr_UPSIDocumentMasters
	(
		
		UPSIDocumentId			    INT IDENTITY(1,1)  NOT NULL,
		Category	                INT,
		Reason						INT,
		Comments					NVARCHAR(250),
		ModeOfSharing      	        INT,
		SharingDate					DATETIME,	
		SharingTime					TIME,
		PublishDate					DATETIME,
		UserInfoId					INT,
		DocumentNo					NVARCHAR(250),
		CreatedBy                   INT,
		CreatedOn                   DateTime,
		UpdatedBy                   INT,
		UpdatedOn                   DateTime,
CONSTRAINT [PK_usr_UPSIDocumentMasters] PRIMARY KEY CLUSTERED 
(
	[UPSIDocumentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


