-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 09-DEC-2015                                                 							=
-- Description : THIS TABLE IS USED TO SAVE R & T REPORT DATA											=
-- SELECT * FROM rnt_MassUploadHistory																	=
-- ======================================================================================================

IF NOT EXISTS(SELECT name FROM SYS.tables WHERE [name]='rnt_MassUploadHistory')
BEGIN	
	CREATE TABLE rnt_MassUploadHistory
	(
		MassUploadHistoryId			INT IDENTITY(1,1),
		UserInfoId					INT, 
		EmployeeId					VARCHAR(300), 
		EmployeeName				VARCHAR(300), 
		Designation					VARCHAR(300), 
		Grade						VARCHAR(300), 
		Location					VARCHAR(300),
		Department					VARCHAR(300),
		CompanyName					VARCHAR(300),
		TypeofInsider				VARCHAR(300),
		RelationWithEmployee		VARCHAR(300),
		ReletiveName				VARCHAR(300),
		PAN							VARCHAR(300),
		SecurityType				VARCHAR(300),
		SecurityTypeCode			VARCHAR(300),
		Quantity					DECIMAL(10,0),
		DPID						VARCHAR(300),
		DEMATAccountNumber			VARCHAR(300),       
		RnT_PAN						VARCHAR(300),
		RnT_SecurityType			VARCHAR(300),
		RnT_SecurityTypeCode		VARCHAR(300),	      	
		RnT_DPID					VARCHAR(300),
		RnT_DEMAT					VARCHAR(300),
		RnT_Quantity				DECIMAL(10,0),
		COMMENT						VARCHAR(300),
		RntUploadDate				DATETIME
	)
END
GO

------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (217, '217 rnt_MassUploadHistory_Create', 'create rnt_MassUploadHistory', 'ED')

