/*
	Created By  :	Akhilesh Kamate
	Created On 	:	29-Mar-2016
	Description :	This type is used to stored NSE Details
	
*/

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_du_OnGoingContDiscData_Esop')
BEGIN
	DROP PROCEDURE st_du_OnGoingContDiscData_Esop
END
GO

IF EXISTS (SELECT 1 FROM SYS.TYPES ST JOIN SYS.SCHEMAS SS ON ST.schema_id = SS.schema_id WHERE (ST.name = N'du_type_OnGoingContDiscData_Esop') AND (SS.name = N'dbo'))
BEGIN
	DROP TYPE du_type_OnGoingContDiscData_Esop
END
GO

IF NOT EXISTS (SELECT 1 FROM SYS.TYPES ST JOIN SYS.SCHEMAS SS ON ST.schema_id = SS.schema_id WHERE (ST.name = N'du_type_OnGoingContDiscData_Esop') AND (SS.name = N'dbo'))
BEGIN
	CREATE TYPE du_type_OnGoingContDiscData_Esop AS TABLE 
	(
		[Employee ID]				VARCHAR(500),
		[Employee Name]				VARCHAR(500),
		[Grant Registration Id]		VARCHAR(500),
		[Grant Option Id]			VARCHAR(500),
		[Grant Date]				DATETIME,
		[Options Exercised]			INT,
		[Exercise Date]				DATETIME,
		[Exercise Price]			NUMERIC(18,2),
		[Amount Paid]				NUMERIC(18,2),
		[Date of Allotment]			DATETIME,
		[FMV]						NUMERIC(18,2),
		[Perquisite Value]			NUMERIC(18,2),
		[Perquisite Tax payable]	NUMERIC(18,2),
		[Payment Mode]				VARCHAR(500),
		[Vesting Date]				DATETIME,
		[Grant Vest Period Id]		INT,
		[Exercise No]				INT,
		[Exercise ID]				INT,
		[Client ID]					VARCHAR(500),
		[PAN]						VARCHAR(15),
		[Depository ID]				VARCHAR(100)
	)	
END
GO
