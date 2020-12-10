IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'PreClearanceIDType')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceRequestApproveRejectSave_OS')
	DROP PROCEDURE [dbo].[st_tra_PreclearanceRequestApproveRejectSave_OS] 
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceRequestNonImplCompanySave')
	DROP PROCEDURE [dbo].[st_tra_PreclearanceRequestNonImplCompanySave]

	DROP TYPE PreClearanceIDType
END
GO

CREATE TYPE [PreClearanceIDType] AS TABLE(
	[PreclearanceRequestId]			[INT] NULL,
	[DisplaySequenceNo]             [INT] NULL
)