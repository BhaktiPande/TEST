IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_UpsiSharingList')
DROP PROCEDURE [dbo].[st_UpsiSharingList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Upsi List.

Returns:		0, if Success.
				
Created by:		Arvind
Created on:		08-Apri-2019

Usage:
EXEC st_UpsiSharingList 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_UpsiSharingList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	,@inp_iUserInfoId				INT = 0	
	,@inp_sCategoryShared			NVARCHAR(250)
	,@inp_sReasonsharing            NVARCHAR(250)
	,@inp_sPAN						NVARCHAR(50)
	,@inp_sName						NVARCHAR(250)	
	,@inp_sSharingDate              DATETIME
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_COMPANY_LIST INT = 13005 -- Error occurred while fetching list of documents for user.
	SET @inp_sSortField ='dis_grd_55004'
	SET @inp_sSortOrder='DESC'
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'DESC'
		END
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'UD.UPSIDocumentDtsId'
		END
			
		IF @inp_sSortField = 'dis_grd_55002'  -- Name,
		BEGIN 
			SELECT @inp_sSortField = 'UD.Name '
		END 
			IF @inp_sSortField = 'dis_grd_55003'  -- CompanyName,
		BEGIN 
			SELECT @inp_sSortField = 'UD.CompanyName '
		END 
		
		
		IF @inp_sSortField = 'dis_grd_55004'  -- CompanyName,
		BEGIN 
			SELECT @inp_sSortField = 'UD.PAN '
		END 
		
		IF @inp_sSortField = 'dis_grd_55005'  -- Reason_sharing
		BEGIN 
			SELECT @inp_sSortField = 'CC.CodeName '
		END 
		
		IF @inp_sSortField = 'dis_grd_55006'  -- Comments
		BEGIN 
			SELECT @inp_sSortField = 'CD.CodeName '
		END 
		
		IF @inp_sSortField = 'dis_grd_55007'  -- Name
		BEGIN 
			SELECT @inp_sSortField = 'UD.Name '
		END 
		IF @inp_sSortField = 'dis_grd_55008'  -- Phone
		BEGIN 
			SELECT @inp_sSortField = 'UD.Phone '
		END 

		IF @inp_sSortField = 'dis_grd_55009'  -- E_mail
		BEGIN 
			SELECT @inp_sSortField = 'UD.Email '
		END 
		IF @inp_sSortField = 'dis_grd_55010'  -- SharingDate
		BEGIN 
			SELECT @inp_sSortField = 'MS.CodeName '
		END 
		IF @inp_sSortField = 'dis_grd_55011'  -- PublishDate
		BEGIN 
			SELECT @inp_sSortField = 'C.PublishDate '
		END 
		
		
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY UD.UPSIDocumentDtsId desc),UD.UPSIDocumentDtsId '
		
		SELECT @sSQL = @sSQL + ' FROM usr_UPSIDocumentDetail UD JOIN usr_UPSIDocumentMasters C ON UD.UPSIDocumentId = C.UPSIDocumentId '
		SELECT @sSQL = @sSQL + ' WHERE 1=1 '

		DECLARE @nUserTypeCodeID INT=0
		SELECT @nUserTypeCodeID=UF.UserTypeCodeId FROM usr_UserInfo UF WHERE UF.UserInfoId=@inp_iUserInfoId

		IF(@nUserTypeCodeID<>101001 AND @nUserTypeCodeID<>101002)
		BEGIN
		SELECT @sSQL = @sSQL + ' AND C.UserInfoId=' + Convert(VARCHAR,@inp_iUserInfoId)
		END
		
		IF (@inp_sCategoryShared IS NOT NULL AND @inp_sCategoryShared <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND C.Category LIKE N''%'+ @inp_sCategoryShared +'%'' '
		END

		IF (@inp_sReasonsharing IS NOT NULL AND @inp_sReasonsharing <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND C.Reason LIKE N''%'+ @inp_sReasonsharing +'%'' '			
		END
		
		IF (@inp_sPAN IS NOT NULL AND @inp_sPAN <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.PAN LIKE N''%'+ @inp_sPAN +'%'' '
			
		END
		IF (@inp_sName IS NOT NULL AND @inp_sName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UD.Name LIKE N''%'+ @inp_sName +'%'' '
		END		
		
		IF (@inp_sSharingDate IS NOT NULL AND @inp_sSharingDate <> '')	
		BEGIN
			
			SELECT @sSQL = @sSQL + ' AND (C.SharingDate >= CAST('''  + CAST(@inp_sSharingDate AS VARCHAR(25)) + ''' AS DATETIME)'
			SELECT @sSQL = @sSQL + ' AND (C.SharingDate IS NULL OR C.SharingDate <= CAST('''  + CAST(@inp_sSharingDate AS VARCHAR(25)) + '''AS DATETIME) ) )'
		END	
		
		EXEC(@sSQL)

		SELECT	
		UD.UPSIDocumentDtsId  ,
		        C.UPSIDocumentId ,
				UD.UPSIDocumentId AS dis_grd_55001, 
				UD.Name AS dis_grd_55002, 
				UD.CompanyName AS dis_grd_55003,
				UD.PAN AS dis_grd_55004,
				CC.CodeName AS dis_grd_55005, 
				CD.CodeName AS dis_grd_55006,
				CASE WHEN UPPER( RTRIM( LTRIM(UI.FirstName)))=UPPER(RTRIM( LTRIM(UD.Sharedby))) THEN ISNULL(UI.FirstName,'') + ' ' +ISNULL(UI.LastName,'')  ELSE UD.Sharedby END   AS dis_grd_55007,	
				ISNULL(UI.FirstName,'')  + ' ' +ISNULL(UI.LastName,'') AS dis_grd_55008,
				UPPER(REPLACE(CONVERT(NVARCHAR, C.SharingDate, 106),' ','/') + ' ' + convert(varchar(5), C.SharingTime)) As dis_grd_55009,				
				MS.CodeName  AS dis_grd_55010,
				C.PublishDate AS dis_grd_55011,
				C.UserInfoId
				
		FROM	#tmpList T INNER JOIN
		        usr_UPSIDocumentDetail UD ON UD.UPSIDocumentDtsId= T.EntityID 
				INNER join usr_UPSIDocumentMasters C ON C.UPSIDocumentId=UD.UPSIDocumentId
				INNER join com_Code CC ON C.Category=CC.CodeID
				INNER join com_Code CD ON C.Reason =CD.CodeID
				INNER join com_Code MS ON C.ModeOfSharing =MS.CodeID
				LEFT join usr_UserInfo UI ON UI.UserInfoId=UD.UpdatedBy
		WHERE  C.UserInfoId IS NOT NULL  AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		 ORDER BY  UD.UPSIDocumentDtsId DESC

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COMPANY_LIST
	END CATCH
END
