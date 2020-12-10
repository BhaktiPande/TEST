/*
	Created By  :	AKHILESH KAMATE
	Created On 	:	16-JUN-2017
	Description :	This stored Procedure is used to update Demat upload flag
	
	EXEC st_du_UpdateUploadDematFlag 'ESOPDIRECTFEED'
	EXEC st_du_UpdateUploadDematFlag 'AXISDIRECTFEED'
	
*/


IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_du_UpdateUploadDematFlag')
	DROP PROCEDURE st_du_UpdateUploadDematFlag
GO

CREATE PROCEDURE st_du_UpdateUploadDematFlag
	@s_UploadFileFor VARCHAR(100)
AS	
BEGIN
	SET NOCOUNT ON;
		
	IF UPPER(@s_UploadFileFor) = 'ESOPDIRECTFEED'
	BEGIN
		UPDATE du_MappingTables SET Is_UploadDematFromFile = 0 WHERE DisplayName = 'ESOPDIRECTFEED'		
	END
	ELSE IF UPPER(@s_UploadFileFor) = 'AXISDIRECTFEED'
	BEGIN
		UPDATE du_MappingTables SET Is_UploadDematFromFile = 0 WHERE DisplayName = 'AXISDIRECTFEED'
	END
	
	SET NOCOUNT OFF;
END
GO