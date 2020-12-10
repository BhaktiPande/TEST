-- =============================================
-- Author:		Aniket Shingate
-- Create date: 09 Sep, 2015
-- Description:	This stored Procedure is used to store data regarding company NSE, BSE and ISIN code
-- =============================================

CREATE TABLE [rl_CompanyMasterList]
(
	[RlCompanyId]	[INT] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[CompanyName]	[VARCHAR](300) NOT NULL,			
	[BSECode]		[VARCHAR](300) NOT NULL,
	[NSECode]		[VARCHAR](300) NOT NULL,
	[ISINCode]		[VARCHAR](300) NOT NULL,							
	[ModuleCodeId]	[INT] NOT NULL FOREIGN KEY REFERENCES COM_CODE(CODEID) ,
	[StatusCodeId]	[INT] NOT NULL FOREIGN KEY REFERENCES COM_CODE(CODEID) ,				
	[CreatedBy]		[INT] NOT NULL,
	[CreatedOn]		[DATETIME]NOT NULL,
	[ModifiedBy]	[INT] NOT NULL,
	[ModifiedOn]	[DATETIME] NOT NULL,		 
)

----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (198, '198 rl_CompanyMasterList_Create', 'rl_CompanyMasterList_Create', 'KPCS - Aniket Shingate')
