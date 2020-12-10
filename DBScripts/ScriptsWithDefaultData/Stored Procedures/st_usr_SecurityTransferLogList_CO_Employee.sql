IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_SecurityTransferLogList_CO_Employee')
DROP PROCEDURE [dbo].[st_usr_SecurityTransferLogList_CO_Employee]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure used for getting available qty for demat indivisual for exclude one demat

Returns:		0, if Success.
				
Created by:		GS
Created on:		14-Oct-2016
Modification History:
Modified By		Modified On		Description
Tushar			24-Oct-2016		Search criteria add in procedure.

Usage:
DECLARE @RC int
EXEC st_usr_UserSecuritiesHoldingList 49,
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_SecurityTransferLogList_CO_Employee]
	@inp_iPageSize				INT = 10,
	@inp_iPageNo				INT = 1,
	@inp_sSortField				VARCHAR(255),
	@inp_sSortOrder				VARCHAR(5),
	@inp_sUserInfoID			NVARCHAR(100),
	@inp_sEmployeeID			NVARCHAR(50),-- = 'GS1234'
	@inp_sInsiderName			NVARCHAR(1000), --= 's'
	@inp_sMobileNumber			NVARCHAR(15) = null,
	@inp_sCompanyId				NVARCHAR(1000),	
    @inp_sPAN					NVARCHAR(50) = null,
	@inp_sCategory				NVARCHAR(1000) = null,
    @inp_sGradeId				NVARCHAR(1000) = null,
	@inp_sDesignation			NVARCHAR(1000), --= 's'
	@inp_sLocation				NVARCHAR(500), --= 'pune'
	@inp_sDepartmentId			NVARCHAR(1000), --= 'a'
	@inp_sSecurityTypeCodeID	NVARCHAR(1000),
	@inp_sFromTransferDate		NVARCHAR(1000),
	@inp_sToTransferDate		NVARCHAR(1000),
	@inp_sFromQuantity			NVARCHAR(1000),
	@inp_sToQuantity			NVARCHAR(1000),
	@inp_sDepositoryName		NVARCHAR(1000),--17
	@inp_sDematAccountNumber	NVARCHAR(1000),--18
	@inp_sDPID					NVARCHAR(1000),
	@inp_sTMID					NVARCHAR(1000),
	@inp_sDepositoryParticipantName			NVARCHAR(1000),
	@inp_iGridType				INT,
	@inp_sUserType				NVARCHAR(1000),
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_SECURITYTRANSFERLIST INT = 19369 -- Error occurred while fetching security transfer report.
	DECLARE @nRetValue INT
	DECLARE @sSQL NVARCHAR(MAX) = ''

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		
		DECLARE @nYearPeriod INT =  124001
		
		
		 
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = '' OR @inp_sSortOrder = 'ASC'
		BEGIN 
			SELECT @inp_sSortOrder = 'DESC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'STL.TransferDate '
		END 
		
		
		IF @inp_sSortField = 'rpt_grd_19341'
		BEGIN
			SELECT @inp_sSortField = 'STL.TransferDate '
		END
		
		IF @inp_sSortField = 'rpt_grd_19328'
		BEGIN
			SELECT @inp_sSortField = 'STL.TransferDate '
		END
		
		SELECT @sSQL = @sSQL + ' INSERT INTO #tmpList (RowNumber, EntityID)'		
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',STL.SecurityTransaferID),STL.SecurityTransaferID '
		SELECT @sSQL = @sSQL + ' FROM usr_SecurityTransferLog STL '
		SELECT @sSQL = @sSQL + ' JOIN vw_UserInformation UI ON STL.UserInfoId = UI.UserInfoId '
		SELECT @sSQL = @sSQL + ' JOIN usr_DMATDetails FROMDEMAT ON STL.FromDEMATAcountID = FROMDEMAT.DMATDetailsID '
		SELECT @sSQL = @sSQL + ' JOIN usr_DMATDetails TODEMAT ON STL.ToDEMATAcountID = TODEMAT.DMATDetailsID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code FROMDEMATCode ON FROMDEMAT.DPBankCodeId = FROMDEMATCode.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code TODEMATCode ON TODEMAT.DPBankCodeId = TODEMATCode.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '
		
		IF @inp_sUserInfoID IS NOT NULL AND @inp_sUserInfoID <> ''
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UI.UserInfoId = ' + +  CONVERT(VARCHAR(MAX),@inp_sUserInfoID)
		END
		
		IF @inp_sUserInfoID IS NULL OR @inp_sUserInfoID = ''
		BEGIN
			IF @inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> ''
			BEGIN
				SELECT @sSQL = @sSQL + ' AND UI.EmployeeId LIKE N''%'+ @inp_sEmployeeID +'%'' '
			END
			
			IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')	
			BEGIN
					SELECT @sSQL = @sSQL + ' AND UI.UserFullName LIKE N''%'+ @inp_sInsiderName +'%'' '
				--	SELECT @sSQL = @sSQL + ' OR UF.LastName LIKE N''%'+ @inp_sInsiderName +'%'') '
			END
			
			IF @inp_sMobileNumber IS NOT NULL AND @inp_sMobileNumber <> ''
			BEGIN
				SELECT @sSQL = @sSQL + ' AND UI.MobileNumber LIKE N''%'+ @inp_sMobileNumber +'%'' '
			END
			
			IF (@inp_sCompanyId IS NOT NULL AND @inp_sCompanyId <> '')	
			BEGIN
					SELECT @sSQL = @sSQL + ' AND UI.CompanyId IN( '+ CAST(@inp_sCompanyId AS VARCHAR(1000)) + ' )'
			END

			IF (@inp_sPAN IS NOT NULL AND @inp_sPAN <> '')	
			BEGIN
					SELECT @sSQL = @sSQL + ' AND UI.PAN LIKE N''%'+ @inp_sPAN +'%'' '
			END
			
			IF (@inp_sCategory IS NOT NULL AND @inp_sCategory <> '' )	
			BEGIN
					SELECT @sSQL = @sSQL + ' AND UI.Category = '  + CAST(@inp_sCategory AS VARCHAR(10)) 
			END

			IF (@inp_sGradeId IS NOT NULL AND @inp_sGradeId <> '' )	
			BEGIN
					SELECT @sSQL = @sSQL + ' AND (UI.Grade LIKE  N''%'+ @inp_sGradeId +'%'' '  
					SELECT @sSQL = @sSQL + ' OR UI.GradeText LIKE N''%'  + @inp_sGradeId + '%'') ' 
			END
			
			IF (@inp_sDesignation IS NOT NULL AND @inp_sDesignation <> '' )	
			BEGIN
					SELECT @sSQL = @sSQL + ' AND UI.Designation LIKE  N''%'+ @inp_sDesignation +'%'' '  
					
			END
			
			IF (@inp_sLocation IS NOT NULL AND @inp_sLocation <> '')	
			BEGIN
					SELECT @sSQL = @sSQL + ' AND UI.Location LIKE N''%'+ @inp_sLocation +'%'' '
			END
			
			IF (@inp_sDepartmentId IS NOT NULL AND @inp_sDepartmentId <> '' )	
			BEGIN
					SELECT @sSQL = @sSQL + ' AND (UI.Department  LIKE N''%'  + @inp_sDepartmentId  +'%'' '  
					SELECT @sSQL = @sSQL + ' OR UI.DepartmentText LIKE N''%'  + @inp_sDepartmentId + '%'') ' 
			END
		END
		
		IF (@inp_sSecurityTypeCodeID IS NOT NULL AND @inp_sSecurityTypeCodeID <> '' )	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND STL.SecurityTypeCodeID IN( '  + CAST(@inp_sSecurityTypeCodeID AS VARCHAR(1000))  + ' )'
		END
		
		IF ((@inp_sFromTransferDate IS NOT NULL AND @inp_sFromTransferDate <> '') OR (@inp_sToTransferDate IS NOT NULL AND @inp_sToTransferDate <> ''))
		BEGIN
			SELECT @sSQL = @sSQL + ' AND ( '
			IF (@inp_sFromTransferDate IS NOT NULL AND @inp_sFromTransferDate <> '')
			BEGIN
				SELECT @sSQL = @sSQL + ' (STL.TransferDate >= CAST('''  + CAST(@inp_sFromTransferDate AS VARCHAR(25)) + ''' AS DATETIME))'
			END
			
			IF ((@inp_sFromTransferDate IS NOT NULL AND @inp_sFromTransferDate <> '') AND (@inp_sToTransferDate IS NOT NULL AND @inp_sToTransferDate <> ''))
			BEGIN
				SELECT @sSQL = @sSQL + ' AND '
			END
			
			IF (@inp_sToTransferDate IS NOT NULL AND @inp_sToTransferDate <> '')
			BEGIN
				SELECT @sSQL = @sSQL + '  (STL.TransferDate <= CAST('''  + CAST(@inp_sToTransferDate AS VARCHAR(25)) + ''' AS DATETIME)  )'
			END
			SELECT @sSQL = @sSQL + ' )'
		END
		
		IF ((@inp_sFromQuantity IS NOT NULL AND @inp_sFromQuantity <> '') OR (@inp_sToQuantity IS NOT NULL AND @inp_sToQuantity <> ''))
		BEGIN
			SET @inp_sFromQuantity = REPLACE(@inp_sFromQuantity,',','') 
			SET @inp_sToQuantity = REPLACE(@inp_sToQuantity,',','') 
			SELECT @sSQL = @sSQL + ' AND ( '
			IF (@inp_sFromQuantity IS NOT NULL AND @inp_sFromQuantity <> '')
			BEGIN
				SELECT @sSQL = @sSQL + ' STL.TransferQuantity >= '  + CAST(@inp_sFromQuantity AS VARCHAR(MAX)) 
			END
			
			IF (@inp_sFromQuantity IS NOT NULL AND @inp_sToQuantity IS NOT NULL AND @inp_sFromQuantity <> '' AND @inp_sToQuantity <> '')
			BEGIN
				SELECT @sSQL = @sSQL + ' AND '
			END
			
			IF (@inp_sToQuantity IS NOT NULL AND @inp_sToQuantity <> '')
			BEGIN
				SELECT @sSQL = @sSQL + '  STL.TransferQuantity <= '  + CAST(@inp_sToQuantity AS VARCHAR(MAX)) 
			END
			SELECT @sSQL = @sSQL + ' )'
		END
		--select @inp_sDepositoryName
		IF (@inp_sDepositoryName IS NOT NULL AND @inp_sDepositoryName <> '')
		BEGIN
				SELECT @sSQL = @sSQL + ' AND (FROMDEMAT.DPBank LIKE N''%'+ @inp_sDepositoryName +'%'' '
				SELECT @sSQL = @sSQL + ' OR TODEMAT.DPBank LIKE N''%'+ @inp_sDepositoryName +'%'') '
		END
		
		IF (@inp_sDematAccountNumber IS NOT NULL AND @inp_sDematAccountNumber <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND (FROMDEMAT.DEMATAccountNumber LIKE N''%'+ @inp_sDematAccountNumber +'%'' '
				SELECT @sSQL = @sSQL + ' OR TODEMAT.DEMATAccountNumber LIKE N''%'+ @inp_sDematAccountNumber +'%'') '
		END
		
		IF (@inp_sDPID IS NOT NULL AND @inp_sDPID <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND (FROMDEMAT.DPID LIKE N''%'+ @inp_sDPID +'%'' '
				SELECT @sSQL = @sSQL + ' OR TODEMAT.DPID LIKE N''%'+ @inp_sDPID +'%'') '
		END
		
		IF (@inp_sTMID IS NOT NULL AND @inp_sTMID <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND (FROMDEMAT.TMID LIKE N''%'+ @inp_sTMID +'%'' '
				SELECT @sSQL = @sSQL + ' OR TODEMAT.TMID LIKE N''%'+ @inp_sTMID +'%'') '
		END
		
		IF (@inp_sDepositoryParticipantName IS NOT NULL AND @inp_sDepositoryParticipantName <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND (FROMDEMATCode.CodeName LIKE N''%'+ @inp_sDepositoryParticipantName +'%'' '
				SELECT @sSQL = @sSQL + ' OR TODEMATCode.CodeName LIKE N''%'+ @inp_sDepositoryParticipantName +'%'') '
		END
		
		IF (@inp_sUserType IS NOT NULL AND @inp_sUserType <> '')	
			BEGIN
					SELECT @sSQL = @sSQL + ' AND UI.UserTypeCodeId IN( '+ CAST(@inp_sUserType AS VARCHAR(1000)) + ' )'
			END
		
		--PRINT(@sSQL)
		EXEC(@sSQL)
		
			SELECT STL.SecurityTransaferID,
					UI.EmployeeId AS rpt_grd_19341,
					UI.UserFullName AS rpt_grd_19342,
					UI.PAN AS rpt_grd_19343,
					UI.Designation AS rpt_grd_19344,
					CASE WHEN UI.Grade IS NOT NULL THEN UI.Grade ELSE UI.GradeText END AS rpt_grd_19345,
					UI.Location AS rpt_grd_19346,
					CASE WHEN UI.Department IS NOT NULL THEN  UI.Department ELSE UI.DepartmentText END AS rpt_grd_19347,
					UI.CompanyName AS rpt_grd_19348,
					UI.UserType AS rpt_grd_19349,
				    '' AS rpt_grd_19339,
				   codeSecurity.CodeName AS rpt_grd_19328 , --SecurityTypeCodeID,
				   FROMDEMAT.DEMATAccountNumber AS rpt_grd_19330, --From DEMAT A/c Number
				   ISNULL(FROMDEMAT.DPBank,'') AS rpt_grd_19329, -- FROM Depository Name
				   ISNULL(FROMDEMAT.TMID,''),
				   ISNULL(FROMDEMAT.DPID,'') AS rpt_grd_19331, --Depository Participant ID
				   ISNULL(FROMDEMATCode.CodeName,'') AS rpt_grd_19332, -- Depository Participant Name
				   '' AS rpt_grd_19340,
				   ISNULL(TODEMAT.DPBank,'') AS rpt_grd_19333,
				   ISNULL(TODEMAT.TMID,'') AS TMID,
				   ISNULL(TODEMAT.DEMATAccountNumber,'') AS rpt_grd_19334,
				   ISNULL(TODEMAT.DPID,'') AS rpt_grd_19335,
				   ISNULL(TODEMATCode.CodeName,'') AS rpt_grd_19336, --Depositary_Name,
				   STL.TransferDate AS rpt_grd_19337, --TransferDate,
				   STL.TransferQuantity AS rpt_grd_19338 --TransferQuantity
				   
					
			FROM #tmpList T 
			INNER JOIN usr_SecurityTransferLog STL ON STL.SecurityTransaferID = T.EntityID
			--JOIN usr_UserInfo UF ON STL.UserInfoId = UF.UserInfoId
			JOIN vw_UserInformation UI ON STL.UserInfoID = UI.UserInfoID
			JOIN usr_DMATDetails FROMDEMAT ON STL.FromDEMATAcountID = FROMDEMAT.DMATDetailsID
			JOIN usr_DMATDetails TODEMAT ON STL.ToDEMATAcountID = TODEMAT.DMATDetailsID
			LEFT JOIN com_Code FROMDEMATCode ON FROMDEMAT.DPBankCodeId = FROMDEMATCode.CodeID
			LEFT JOIN com_Code TODEMATCode ON TODEMAT.DPBankCodeId = TODEMATCode.CodeID
			JOIN com_Code codeSecurity ON STL.SecurityTypeCodeID  =codeSecurity.CodeID
			WHERE	STL.SecurityTransaferID IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
			ORDER BY T.RowNumber
		
		
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_SECURITYTRANSFERLIST, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END