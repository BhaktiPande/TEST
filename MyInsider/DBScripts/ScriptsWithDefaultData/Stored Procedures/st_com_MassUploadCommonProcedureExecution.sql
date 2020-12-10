IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
DROP PROCEDURE [dbo].[st_com_MassUploadCommonProcedureExecution]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure will be called for mass upload for employee. This procedure
will have input as a datatable of the employee information data to be used for creating employees.
So this procedure will run a cursor on the datatable received and then will execute the procedure 
used for creating the employee record.

Returns:		0, if Success.
				
Created by:		Raghvendra Wagholikar
Created on:		23-Mar-2015

Modification History:
Modified By		Modified On	Description
Raghvendra		6-Sept-2015	Change to give call to procedure rather than using the dynamic query approach 
							for executing the procedure.
Raghvendra		09-Oct-2015	Change to add mass upload for Innitial Disclosure
Raghvendra		4-Dec-2015	Moved the IF EXIST block above Comments
ED				18-Dec-2015	Code margin done on 18-Dec
Raghvendra		22-Dec-2015	Added changes for Past Preclearance Mass Upload
Raghvendra		28-Dec-2015	Added changes for On Going Continuous Disclosure Transaction Mass Upload
ED				4-Jan-2016	Code integration done on 4-Jan-2016
ED				4-Feb-2016	Code integration done on 4-Feb-2016
Raghvendra		11-Sep-2016	Added support for Mass upload for PerformedPeriodEnd for Employee
Raghvendra		27-Oct-2016	Fix for error code variable not getting reset when executing individual record calls.


The calls for temp table for debugging are used. The table structure for the log table is
create table testinglog(VarName VARCHAR(200),VarValue VARCHAR(MAX),LogTime DATETIME)
select * from testinglog
delete from testinglog
Comment out the calls to the debug table when released

Parag			18-Aug-2016		Code merge with ESOP code
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Raghvendra		13-Sep-2016		Added changes for supporting the mass upload for User wise Period End Performed
Raghvendra		4-Oct-2016		Fix for incorrect behavior of Mass Upload after there is server error of invalid record raised on server side. So when there was 
								a server error raised from the calling procedure then same error code was carried forward for next records also.
Usage:
EXEC st_MassUploadCommonProcedureExecution 1
-------------------------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[st_com_MassUploadCommonProcedureExecution]
	@inp_nMassUploadSheetId INT		--The mass upload sheet id based on which the datatable to be taken will be decided
	,@inp_tblBulkEmployeeInsiderImport MassEmployeeInsiderImportDataTable READONLY
	,@inp_tblBulkNonEmployeeInsiderImport MassNonEmployeeInsiderImportDataTable READONLY
	,@inp_tblBulkCorpEmployeeInsiderImport MassCorpEmployeeInsiderImportDataTable READONLY
	,@inp_tblBulkEmpRelativesImport MassRelativesImportDataTable READONLY
	,@inp_tblBulkNonEmpRelativesImport MassRelativesImportDataTable READONLY
	,@inp_tblBulkEmpDMATDetailsImport IndividualDmatDetailsDataTable READONLY
	,@inp_tblBulkNonEmpDMATDetailsImport IndividualDmatDetailsDataTable READONLY
	,@inp_tblBulkCorpEmpDMATDetailsImport IndividualDmatDetailsDataTable READONLY
	,@inp_tblBulkEmpRelativeDMATDetailsImport IndividualDmatDetailsDataTable READONLY
	,@inp_tblBulkNonEmpRelativeDMATDetailsImport IndividualDmatDetailsDataTable READONLY
	,@inp_tblBulkInitialDisclosureDetailsImport MassInitialDisclosureDataTable READONLY
	,@inp_tblBulkRegisterTransferDetailsImport MassRegisterAndTransferDataTable READONLY
	,@inp_tblBulkHistoryPreclearanceRequestImportDataTable	MassHistoryPreclearanceRequestImportDataTable READONLY
	,@inp_tblBulkHistoryTransactionImportDataTable MassHistoryTransactionImportDataTable READONLY
	,@inp_tblBulkTransactionImportDataTable MassTransactionImportDataTable READONLY
	,@inp_tblBulkNonTradingDaysDetailsImport MassNonTradingDaysDataTable READONLY
	,@inp_tblBulkSeparationDataTableImport MassSeparationDataTable READONLY	
	,@inp_tblBulkRestrictedListAppliDetailsDataTableImport MassRestrictedListAppliDataTable READONLY
	,@inp_tblBulkRestrictedLiMasterCompanyDataTableImport MassRistrictedMasterCompanyDataTable READONLY	
	,@inp_tblBulkMassDepartmentWiseRLDataTableImport MassDepartmentWiseRLDataTable READONLY	
	,@inp_tblBulkMassDepartmentWiseRLAppliDataTableImport MassDepartmentWiseRLAppliDataTable READONLY
	,@inp_tblBulkMassEmployeePeriodEndDataTable MassEmployeePeriodEndDataTable READONLY


	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN

DECLARE @ProcStr VARCHAR(max)
DECLARE @sProcedureName VARCHAR(200) = ''
DECLARE @DeclareStmt VARCHAR(max) = ''
DECLARE @CursorSelect VARCHAR(MAX) = ''
DECLARE @ProcedureCall VARCHAR(max) = ''
--DECLARE @tblReturnValues TABLE (Id INT IDENTITY,ResponseId VARCHAR(50),ErrorCode INT)
DECLARE @sDataTableTypeToConsider VARCHAR(200)
DECLARE @sResourcePrefix VARCHAR(10)

DECLARE @CheckItemWhereClause VARCHAR(500) = ''--This will be used for checking if the given item exist and should be updated or not.
DECLARE @PrimaryColumnToGetID VARCHAR(100)=''
DECLARE @TableNameToGETID VARCHAR(200) = ''

DECLARE @UpdatePrimaryKeyIdQuery VARCHAR(max) = ''

DECLARE @GETPRIMARYKEYQUERY VARCHAR(MAX) = ''

CREATE TABLE #tblReturnValues (Id INT IDENTITY,
								ResponseId VARCHAR(250),
								ErrorCode INT DEFAULT 0,
								ReturnValue INT DEFAULT 0, 
								ErrorMessage VARCHAR(1000) DEFAULT '',
								ResourcePrefix VARCHAR(10) DEFAULT ''
								)
--CREATE TABLE #ProcedureParams (Id INT IDENTITY,
--								ParameterString VARCHAR(max))								
--drop table BulkInsertTable
BEGIN TRY
	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0
	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0
	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = ''''
		
	IF OBJECT_ID(N'dbo.BulkInsertTable', N'U') IS NOT NULL
	BEGIN
		DROP TABLE dbo.BulkInsertTable
	END 
			
	--Copy the data from the DataTable to a Table which will be used in the procedure below.
	IF @inp_nMassUploadSheetId = 1	--For employee insider
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkEmployeeInsiderImport
		SELECT @sProcedureName = 'st_usr_MassUploadUserInfoSaveWithRole'
		SELECT @sDataTableTypeToConsider = 'MassEmployeeInsiderImportDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		SELECT @PrimaryColumnToGetID = 'UserInfoId'
		SELECT @TableNameToGetID = 'usr_Authentication'
		SELECT @GETPRIMARYKEYQUERY = 'SELECT UserInfoId FROM usr_Authentication WHERE LoginId = @LoginId';
	END	
	ELSE IF @inp_nMassUploadSheetId = 2	--For non employee insider
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkNonEmployeeInsiderImport
		SELECT @sProcedureName = 'st_usr_MassUploadUserInfoSaveWithRole'
		SELECT @sDataTableTypeToConsider = 'MassNonEmployeeInsiderImportDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		SELECT @PrimaryColumnToGetID = 'UserInfoId'
		SELECT @TableNameToGetID = 'usr_Authentication'
		SELECT @GETPRIMARYKEYQUERY = 'SELECT UserInfoId FROM usr_Authentication WHERE LoginId = @LoginId';
	END	
	ELSE IF @inp_nMassUploadSheetId = 3	--For corporate employee insider
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkCorpEmployeeInsiderImport
		SELECT @sProcedureName = 'st_usr_MassUploadUserInfoSaveWithRole'
		SELECT @sDataTableTypeToConsider = 'MassCorpEmployeeInsiderImportDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		SELECT @PrimaryColumnToGetID = 'UserInfoId'
		SELECT @TableNameToGetID = 'usr_Authentication'
		SELECT @GETPRIMARYKEYQUERY = 'SELECT UserInfoId FROM usr_Authentication WHERE LoginId = @LoginId';
	END	
	ELSE IF @inp_nMassUploadSheetId = 4 -- Employee insider relatives
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkEmpRelativesImport
		SELECT @sProcedureName = 'st_usr_UserInfoSave'
		SELECT @sDataTableTypeToConsider = 'MassRelativesImportDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		SELECT @PrimaryColumnToGetID = 'UserInfoIdRelative'
		SELECT @TableNameToGetID = 'usr_UserInfo'
		SELECT @GETPRIMARYKEYQUERY = 'SELECT UserInfoIdRelative FROM [usr_UserRelation] R join usr_UserInfo U ON U.UserInfoId = R.UserInfoIdRelative Where R.UserInfoId = @UserInfoId and U.FirstName = @FirstName AND U.LastName = @LastName AND R.RelationTypeCodeId = @RelationTypeCodeId';
	END
	ELSE IF @inp_nMassUploadSheetId = 5 -- Non Employee relatives
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkNonEmpRelativesImport
		SELECT @sProcedureName = 'st_usr_UserInfoSave'
		SELECT @sDataTableTypeToConsider = 'MassRelativesImportDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		SELECT @PrimaryColumnToGetID = 'UserInfoIdRelative'
		SELECT @TableNameToGetID = 'usr_UserInfo'
		SELECT @GETPRIMARYKEYQUERY = 'SELECT UserInfoIdRelative FROM [usr_UserRelation] R join usr_UserInfo U ON U.UserInfoId = R.UserInfoIdRelative Where R.UserInfoId = @UserInfoId and U.FirstName = @FirstName AND U.LastName = @LastName AND R.RelationTypeCodeId = @RelationTypeCodeId';
	END
	ELSE IF @inp_nMassUploadSheetId = 6 -- Employee DEMAT details
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkEmpDMATDetailsImport
		SELECT @sProcedureName = 'st_usr_MassUploadDMATDetailsSave'
		SELECT @sDataTableTypeToConsider = 'IndividualDmatDetailsDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		SELECT @PrimaryColumnToGetID = 'DEMATDetailsID'
		SELECT @TableNameToGetID = 'usr_DMATDetails'
		SELECT @GETPRIMARYKEYQUERY = 'SELECT DMATDetailsID FROM usr_DMATDetails WHERE UserInfoId = @UserInfoId AND DEMATAccountNumber = @DEMATAccountNumber';
	END
	ELSE IF @inp_nMassUploadSheetId = 7 -- Non Employee DEMAT details
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkNonEmpDMATDetailsImport
		SELECT @sProcedureName = 'st_usr_MassUploadDMATDetailsSave'
		SELECT @sDataTableTypeToConsider = 'IndividualDmatDetailsDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		SELECT @PrimaryColumnToGetID = 'DEMATDetailsID'
		SELECT @TableNameToGetID = 'usr_DMATDetails'
		SELECT @GETPRIMARYKEYQUERY = 'SELECT DMATDetailsID FROM usr_DMATDetails WHERE UserInfoId = @UserInfoId AND DEMATAccountNumber = @DEMATAccountNumber';
	END
	ELSE IF @inp_nMassUploadSheetId = 8 -- Corporate Employee DEMAT details
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkCorpEmpDMATDetailsImport
		SELECT @sProcedureName = 'st_usr_MassUploadDMATDetailsSave'
		SELECT @sDataTableTypeToConsider = 'IndividualDmatDetailsDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		SELECT @PrimaryColumnToGetID = 'DEMATDetailsID'
		SELECT @TableNameToGetID = 'usr_DMATDetails'
		SELECT @GETPRIMARYKEYQUERY = 'SELECT DMATDetailsID FROM usr_DMATDetails WHERE UserInfoId = @UserInfoId AND DEMATAccountNumber = @DEMATAccountNumber';
	END
	ELSE IF @inp_nMassUploadSheetId = 9 -- Employee relative DEMAT details
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkEmpRelativeDMATDetailsImport
		SELECT @sProcedureName = 'st_usr_MassUploadDMATDetailsSave'
		SELECT @sDataTableTypeToConsider = 'IndividualDmatDetailsDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		SELECT @PrimaryColumnToGetID = 'DEMATDetailsID'
		SELECT @TableNameToGetID = 'usr_DMATDetails'
		SELECT @GETPRIMARYKEYQUERY = 'SELECT DMATDetailsID FROM usr_DMATDetails WHERE UserInfoId = @UserInfoId AND DEMATAccountNumber = @DEMATAccountNumber';
	END
	ELSE IF @inp_nMassUploadSheetId = 10 -- Non Employee relative DEMAT details
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkNonEmpRelativeDMATDetailsImport
		SELECT @sProcedureName = 'st_usr_MassUploadDMATDetailsSave'
		SELECT @sDataTableTypeToConsider = 'IndividualDmatDetailsDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		SELECT @PrimaryColumnToGetID = 'DEMATDetailsID'
		SELECT @TableNameToGetID = 'usr_DMATDetails'
		SELECT @GETPRIMARYKEYQUERY = 'SELECT DMATDetailsID FROM usr_DMATDetails WHERE UserInfoId = @UserInfoId AND DEMATAccountNumber = @DEMATAccountNumber';
	END
	ELSE IF @inp_nMassUploadSheetId = 11 -- Initial Disclosure Mass Upload
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkInitialDisclosureDetailsImport
		SELECT @sProcedureName = 'st_usr_MassUploadInitialDisclosure'
		SELECT @sDataTableTypeToConsider = 'MassInitialDisclosureDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		--SELECT @PrimaryColumnToGetID = 'DEMATDetailsID'
		--SELECT @TableNameToGetID = 'usr_DMATDetails'
		--SELECT @GETPRIMARYKEYQUERY = 'SELECT DMATDetailsID FROM usr_DMATDetails WHERE UserInfoId = @UserInfoId AND DEMATAccountNumber = @DEMATAccountNumber';
	END
	ELSE IF @inp_nMassUploadSheetId = 12 -- Historic Preclearance
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkHistoryPreclearanceRequestImportDataTable
		SELECT @sProcedureName = 'st_tra_MassUploadHistoricPreclearanceRequestSave'
		SELECT @sDataTableTypeToConsider = 'MassHistoryPreclearanceRequestImportDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		DELETE FROM tra_HistoricTransactionDetails
		DELETE FROM tra_HistoricTransactionMaster
		DELETE FROM tra_HistoricPreclearanceRequest
		--SELECT @PrimaryColumnToGetID = 'DEMATDetailsID'
		--SELECT @TableNameToGetID = 'usr_DMATDetails'
		--SELECT @GETPRIMARYKEYQUERY = 'SELECT DMATDetailsID FROM usr_DMATDetails WHERE UserInfoId = @UserInfoId AND DEMATAccountNumber = @DEMATAccountNumber';
	END
	ELSE IF @inp_nMassUploadSheetId = 13 -- Historic Transactions
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkHistoryTransactionImportDataTable
		SELECT @sProcedureName = 'st_tra_MassUploadHistoricTransactionSave'
		SELECT @sDataTableTypeToConsider = 'MassHistoryTransactionImportDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		DELETE FROM tra_HistoricTransactionDetails
		DELETE FROM tra_HistoricTransactionMaster
		--SELECT @PrimaryColumnToGetID = 'DEMATDetailsID'
		--SELECT @TableNameToGetID = 'usr_DMATDetails'
		--SELECT @GETPRIMARYKEYQUERY = 'SELECT DMATDetailsID FROM usr_DMATDetails WHERE UserInfoId = @UserInfoId AND DEMATAccountNumber = @DEMATAccountNumber';
	END
	ELSE IF @inp_nMassUploadSheetId = 14 -- On Going Continuous Transactions
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkTransactionImportDataTable
		SELECT @sProcedureName = 'st_tra_MassUploadOnGoingContinuousDisclosure'
		SELECT @sDataTableTypeToConsider = 'MassTransactionImportDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
		--SELECT @PrimaryColumnToGetID = 'DEMATDetailsID'
		--SELECT @TableNameToGetID = 'usr_DMATDetails'
		--SELECT @GETPRIMARYKEYQUERY = 'SELECT DMATDetailsID FROM usr_DMATDetails WHERE UserInfoId = @UserInfoId AND DEMATAccountNumber = @DEMATAccountNumber';
	END
	ELSE IF @inp_nMassUploadSheetId = 15 -- Employee Period End Performed
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkMassEmployeePeriodEndDataTable
		SELECT @sProcedureName = 'st_usr_MassUploadUserPeriodEndSave'
		SELECT @sDataTableTypeToConsider = 'MassEmployeePeriodEndDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
	END
	--CODE WRITTEN BY KPCS
	ELSE IF @inp_nMassUploadSheetId = 51 -- Register & Transfer Mass Upload
	BEGIN
		IF ((SELECT COUNT(RntInfoId) FROM rnt_MassUploadDetails WHERE CONVERT(DATE, CreatedOn) <= CONVERT(DATE, dbo.uf_com_GetServerDate())) > 0)
		BEGIN
			TRUNCATE TABLE rnt_MassUploadDetails
		END
		
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkRegisterTransferDetailsImport
		SELECT @sProcedureName = 'st_rnt_MassUploadDetails'
		SELECT @sDataTableTypeToConsider = 'MassRegisterAndTransferDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
	END
	
	ELSE IF @inp_nMassUploadSheetId = 52 -- Non - Trading Day Mass Upload
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkNonTradingDaysDetailsImport
		SELECT @sProcedureName = 'st_NonTradingDays_MassUpload'
		SELECT @sDataTableTypeToConsider = 'MassNonTradingDaysDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
	END	
	
	ELSE IF @inp_nMassUploadSheetId = 53 -- Separation Mass Upload
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkSeparationDataTableImport
		SELECT @sProcedureName = 'SP_Separation_MassUpload'
		SELECT @sDataTableTypeToConsider = 'MassSeparationDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
	END	
	
	ELSE IF @inp_nMassUploadSheetId = 54 -- Restricted List Applicability Mass Upload
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkRestrictedListAppliDetailsDataTableImport
		SELECT @sProcedureName = 'st_RestrictedList_MassUpload'
		SELECT @sDataTableTypeToConsider = 'MassRestrictedListAppliDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
	END	
	
	ELSE IF @inp_nMassUploadSheetId = 55 -- Restricted List Master Company Mass Upload
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkRestrictedLiMasterCompanyDataTableImport
		SELECT @sProcedureName = 'st_RLMasterCompany_MassUpload'
		SELECT @sDataTableTypeToConsider = 'MassRistrictedMasterCompanyDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
	END	
	
	ELSE IF @inp_nMassUploadSheetId = 56 -- Department Wise Restricted List Mass Upload
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkMassDepartmentWiseRLDataTableImport
		SELECT @sProcedureName = 'st_DepartmentWiseRL_MassUpload'
		SELECT @sDataTableTypeToConsider = 'MassDepartmentWiseRLDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
	END	
	
	ELSE IF @inp_nMassUploadSheetId = 57 -- Department Wise Restricted List Applicability Mass Upload
	BEGIN
		SELECT * INTO dbo.BulkInsertTable FROM @inp_tblBulkMassDepartmentWiseRLAppliDataTableImport
		SELECT @sProcedureName = 'st_DepartmentWiseRLAppli_MassUpload'
		SELECT @sDataTableTypeToConsider = 'MassDepartmentWiseRLAppliDataTable'
		SELECT @sResourcePrefix = 'usr_msg_'
	END	
	
	select @CheckItemWhereClause=(CASE WHEN @CheckItemWhereClause = '' THEN '' ELSE @CheckItemWhereClause + ' and ' END)+ MassUploadDataTablePropertyName + ' = @' + MassUploadDataTablePropertyName 
	from com_MassUploadExcelDataTableColumnMapping where MassUploadExcelSheetId = @inp_nMassUploadSheetId
	/*This section will be used where we want to update the details based on the Selection Column given*/
	IF @inp_nMassUploadSheetId != 11 AND @inp_nMassUploadSheetId != 51 AND @inp_nMassUploadSheetId != 12 AND @inp_nMassUploadSheetId != 13 
			AND @inp_nMassUploadSheetId != 14 AND @inp_nMassUploadSheetId != 52 AND @inp_nMassUploadSheetId != 53 AND @inp_nMassUploadSheetId != 54 
			AND @inp_nMassUploadSheetId != 55 AND @inp_nMassUploadSheetId != 56 AND @inp_nMassUploadSheetId != 57 AND @inp_nMassUploadSheetId != 15
	BEGIN
		SELECT @UpdatePrimaryKeyIdQuery += ' IF EXISTS ('+@GETPRIMARYKEYQUERY+') BEGIN '
		SELECT @UpdatePrimaryKeyIdQuery += ' SELECT @' + @PrimaryColumnToGetID + ' = ('+@GETPRIMARYKEYQUERY+')'
		SELECT @UpdatePrimaryKeyIdQuery += ' END ELSE BEGIN SELECT @' + @PrimaryColumnToGetID + ' = 0  END ' 
	END
	
	--Create the Declare Statement and the Cursor variables delimitted string
	SELECT @DeclareStmt = (CASE WHEN @DeclareStmt = '' THEN '' ELSE @DeclareStmt + ',' END) + '@' + c.name + ' ' + st.name + 
	(CASE WHEN st.name = 'nvarchar' then '(' + CONVERT(VARCHAR,c.max_length) + ')' ELSE '' END) ,
	@CursorSelect = (CASE when @CursorSelect = '' THEN '' ELSE @CursorSelect + ',' END) + '@' + c.name 
	from sys.table_types tt
	INNER JOIN sys.columns c ON c.object_id = tt.type_table_object_id
	INNER JOIN sys.systypes AS ST  ON ST.xtype = c.system_type_id
	WHERE tt.name = @sDataTableTypeToConsider AND st.name !='sysname'
	ORDER BY object_id DESC
	SELECT @DeclareStmt = 'DECLARE ' + @DeclareStmt
	
	SELECT @ProcedureCall = (CASE when @ProcedureCall = '' then '' ELSE @ProcedureCall + ',' END) + CASE WHEN MUEDTCM.MassUploadDataTablePropertyName IS NULL 
	THEN ISNULL('''' + MUPPD.MassUploadProcedureParameterValue + '''','NULL') 
	ELSE '@' + MUEDTCM.MassUploadDataTablePropertyName END
	from com_MassUploadExcelSheets MUES

	JOIN com_MassUploadProcedureParameterDetails MUPPD ON MUES.MassUploadExcelSheetId = MUPPD.MassUploadSheetId
	LEFT JOIN com_MassUploadExcelDataTableColumnMapping MUEDTCM ON MUES.MassUploadExcelSheetId = MUEDTCM.MassUploadExcelSheetId 
			AND MUEDTCM.MassUploadExcelDataTableColumnMappingId = MUPPD.MassUploadExcelDataTableColumnMappingId
	WHERE MUES.MassUploadExcelSheetId =@inp_nMassUploadSheetId order by MUPPD.MassUploadProcedureParameterNumber asc
	
	--print @ProcedureCall
	
	SELECT @ProcStr = ' DECLARE @out_nReturnValue	INT = 0 
	,@out_nSQLErrCode			INT = 0 				
	,@out_sSQLErrMessage		VARCHAR(500) = ''''''''     
	 DECLARE @sSQL NVARCHAR(MAX)  
	 
	 DECLARE @sValueSET VARCHAR(max) '
	SELECT @ProcStr = @ProcStr + @DeclareStmt + ' '
	
	SELECT @ProcStr = @ProcStr + ' 
	BEGIN TRY
		declare @trancount int;
		set @trancount = @@trancount;
    
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''''
		
		
		IF CURSOR_STATUS(''global'',''User_Cursor'')>=-1
		BEGIN
		 DEALLOCATE User_Cursor
		END
		
		DECLARE User_Cursor CURSOR LOCAL FOR
		
		SELECT * FROM BulkInsertTable

		OPEN User_Cursor 
		
		FETCH NEXT FROM User_Cursor INTO ' + @CursorSelect
		+ ' '
		+' WHILE @@FETCH_STATUS = 0
		BEGIN
			 SET @out_nReturnValue = 0
			 SET @out_nSQLErrCode = 0
			 SET @out_sSQLErrMessage = ''''

			 if @trancount = 0
				begin transaction
			else
				save transaction usp_my_procedure_name
			 
			 ' + @UpdatePrimaryKeyIdQuery + ' 
			 
		    INSERT INTO #tblReturnValues (ResponseId)
			EXEC ' + @sProcedureName + '  ' + @ProcedureCall + ', @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT 
			'
	--print @ProcedureCall		
	SELECT @ProcStr = @ProcStr + '	
		
	    IF @out_nReturnValue <> 0
		BEGIN
			ROLLBACK TRANSACTION
			INSERT INTO #tblReturnValues Values(0,@out_nSQLErrCode,@out_nReturnValue,@out_sSQLErrMessage,''' + @sResourcePrefix + ''')
		END 
		ELSE
		BEGIN
			COMMIT TRANSACTION
		END		
		
		FETCH NEXT FROM User_Cursor INTO ' + @CursorSelect
		+ ' '
		+ 'END  
		CLOSE User_Cursor
		DEALLOCATE User_Cursor
		
	END	 TRY
	
	BEGIN CATCH		
		DECLARE @xstate int
		SELECT @xstate = XACT_STATE()
		if @xstate = -1
            rollback;
        if @xstate = 1 and @trancount = 0
            rollback
        if @xstate = 1 and @trancount > 0
            rollback transaction usp_my_procedure_name;
        select  ERROR_MESSAGE()
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = @out_nSQLErrCode
	END CATCH '	
	print @ProcStr
	exec (@ProcStr)
	
	SELECT * FROM #tblReturnValues
	
	IF OBJECT_ID(N'dbo.BulkInsertTable', N'U') IS NOT NULL
	BEGIN
		DROP TABLE dbo.BulkInsertTable
	END 
	DROP tABLE #tblReturnValues
	
	RETURN 0
	
END TRY

BEGIN CATCH
	SET @out_nSQLErrCode    =  ERROR_NUMBER()
	SET @out_sSQLErrMessage =   ERROR_MESSAGE()
	SET @out_nReturnValue = @out_nSQLErrCode
	RETURN @out_nReturnValue
END CATCH

END
