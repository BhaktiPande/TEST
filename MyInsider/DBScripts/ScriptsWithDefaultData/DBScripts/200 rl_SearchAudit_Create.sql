CREATE TABLE rl_SearchAudit
(
	[RlSearchAuditId]	[INT] IDENTITY NOT NULL PRIMARY KEY,
	[UserInfoId]		[INT] NOT NULL FOREIGN KEY REFERENCES USR_USERINFO(USERINFOID),			
	[ResourceKey]		VARCHAR(15) NOT NULL,
	[RlCompanyId]		[INT] NOT NULL FOREIGN KEY REFERENCES RL_COMPANYMASTERLIST(RlCompanyId),
	[RlMasterId]		[INT] NULL FOREIGN KEY REFERENCES RL_RISTRICTEDMASTERLIST(RlMasterId) ,
	[ModuleCodeId]		[INT] NOT NULL FOREIGN KEY REFERENCES COM_CODE(CODEID),
	[CreatedBy]			[INT] NOT NULL,
	[CreatedOn]			[DATETIME]NOT NULL,
	[ModifiedBy]		[INT] NOT NULL,
	[ModifiedOn]		[DATETIME] NOT NULL,	
)
----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (200, '200 rl_SearchAudit_Create', 'rl_SearchAudit_Create', 'KPCS - Gaurav Ugale')
