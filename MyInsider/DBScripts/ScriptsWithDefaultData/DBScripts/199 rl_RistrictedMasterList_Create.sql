-- =============================================
--	Author Name		: Santosh Panchal
--	Creation Date	: 09-Sep-2015
--	DESCRIPTION		: RL_RISTRICTEDMASTERLIST TABLE TO Store Restricted List Details
-- =============================================

CREATE TABLE [rl_RistrictedMasterList]
(
	[RlMasterId]			[INT] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[RlCompanyId]			[INT] NOT NULL FOREIGN KEY REFERENCES RL_COMPANYMASTERLIST(RlCompanyId),			
	[ModuleCodeId]			[INT] NOT NULL FOREIGN KEY REFERENCES COM_CODE(CODEID),
	[ApplicableFromDate] 	[DATETIME]NOT NULL,
	[ApplicableToDate]		[DATETIME]NOT NULL,
	[StatusCodeId]			[INT] NOT NULL FOREIGN KEY REFERENCES COM_CODE(CODEID) ,
	[CreatedBy]				[INT] NOT NULL,
	[CreatedOn]				[DATETIME]NOT NULL,
	[ModifiedBy]			[INT] NOT NULL,
	[ModifiedOn]			[DATETIME] NOT NULL,
)
GO
----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (199, '199 rl_RistrictedMasterList_Create', 'rl_RistrictedMasterList_Create', 'KPCS - Santosh Panchal')
