/*
	Created By  : Arvind	
	Created On  : 25-Apri-2019
	Description : This script is used to create a table with name 'usr_UPSIDocumentDetail'

	Drop Table usr_UPSIDocumentDetail
*/
IF  EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'usr_UPSIDocumentDetail')
Drop Table usr_UPSIDocumentDetail
GO

	CREATE TABLE dbo.usr_UPSIDocumentDetail
	(
		
		UPSIDocumentDtsId			INT IDENTITY(1,1) NOT NULL ,
		UPSIDocumentId              INT ,
		Name						NVARCHAR(250),
		PAN 						NVARCHAR(50),
		CompanyName					NVARCHAR(250),
		CompanyAddress      	    NVARCHAR(250),
		Phone					    NVARCHAR(15),	
		Email						NVARCHAR(250),
		Temp1						NVARCHAR(250),
		Temp2						NVARCHAR(250),
		Temp3						NVARCHAR(250),
		Temp4						NVARCHAR(250),
		Temp5						NVARCHAR(250),
		Sharedby					NVARCHAR(250),
		SharingBy                   INT,
		SharingOn                   DateTime,
		UpdatedBy                   INT,
		UpdatedOn                   DateTime,
		
		CONSTRAINT [PK_usr_UPSIDocumentDetail] PRIMARY KEY CLUSTERED 
		(
		[UPSIDocumentDtsId] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]

		GO
		ALTER TABLE [dbo].[usr_UPSIDocumentDetail]  WITH CHECK ADD  CONSTRAINT [FK_usr_UPSIDocumentDetail_usr_UPSIDocumentMasters] FOREIGN KEY([UPSIDocumentId])
		REFERENCES [dbo].[usr_UPSIDocumentMasters] ([UPSIDocumentId])
		GO
		ALTER TABLE [dbo].[usr_UPSIDocumentDetail] CHECK CONSTRAINT [FK_usr_UPSIDocumentDetail_usr_UPSIDocumentMasters]
		GO





