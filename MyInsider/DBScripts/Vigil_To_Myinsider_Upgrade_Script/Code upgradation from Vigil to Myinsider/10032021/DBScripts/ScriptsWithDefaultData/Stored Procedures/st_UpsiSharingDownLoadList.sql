IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_UpsiSharingDownLoadList')
DROP PROCEDURE [dbo].[st_UpsiSharingDownLoadList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Upsi Sharing Download List.

Returns:		0, if Success.
				
Created by:		Arvind
Created on:		15-June-2019

Usage:
EXEC st_UpsiSharingDownLoadList 1,'FFFFF1112F'
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_UpsiSharingDownLoadList]
		
	   @inp_iUserInfoId				INT = 0
	  ,@inp_sCategoryShared			NVARCHAR(250)= NUll
	  ,@inp_sReasonsharing          NVARCHAR(250)= NUll
	  ,@inp_sPAN					NVARCHAR(50) = NUll
	  ,@inp_sName					NVARCHAR(250)= NUll
	  ,@inp_sSharingDate            DATETIME = NUll
	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	
		
		SET NOCOUNT ON;		
			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		CREATE TABLE #tmpList(RowNumber INT,EntityID INT)
		SELECT @sSQL = 'INSERT INTO #tmpList(RowNumber, EntityID) '	
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

		INSERT INTO #tmpList
		EXEC(@sSQL)
		SELECT			      
				UD.UPSIDocumentId AS 'Document Id', 
				UD.Name AS 'Name Of Receiver', 
				UD.CompanyName AS 'Company Name',
				UD.PAN AS 'Pan Number',
				CC.CodeName AS 'Category of Information Shared', 
				CD.CodeName AS 'Reson For Sharing Information',
				CASE WHEN UPPER( RTRIM( LTRIM(UI.FirstName)))=UPPER(RTRIM( LTRIM(UD.Sharedby))) THEN ISNULL(UI.FirstName,'') + ' ' +ISNULL(UI.LastName,'')  ELSE UD.Sharedby END  AS 'Information Sent By',				
				ISNULL(UI.FirstName,'') + ' ' +ISNULL(UI.LastName,'') AS 'Information Updated By',					
				UPPER(REPLACE(CONVERT(NVARCHAR, C.SharingDate, 106),' ','/') + ' ' + convert(varchar(5), C.SharingTime)) As 'Date And Time Of Sharing',
				MS.CodeName  AS 'Mode Of Communication',
				UPPER(REPLACE(CONVERT(NVARCHAR, C.PublishDate, 106),' ','/')) AS 'Date Of Publishing',
				--CASE WHEN EXISTS(SELECT 1 FROM  usr_UserInfo WHERE EmailId = UD.Email) THEN 'Registered User' ELSE 'Unregistered User' END AS 'UPSI Recipient'
				CASE WHEN (UD.IsRegisteredUser = 'True') THEN 'Registered User' ELSE 'Unregistered User' END AS 'UPSI Recipient'
							
				
		FROM	#tmpList T INNER JOIN
		        usr_UPSIDocumentDetail UD ON UD.UPSIDocumentDtsId= T.EntityID 
				INNER join usr_UPSIDocumentMasters C ON C.UPSIDocumentId=UD.UPSIDocumentId
				INNER join com_Code CC ON C.Category=CC.CodeID
				INNER join com_Code CD ON C.Reason =CD.CodeID
				INNER join com_Code MS ON C.ModeOfSharing =MS.CodeID
				LEFT join usr_UserInfo UI ON UI.UserInfoId=UD.UpdatedBy
		WHERE  C.UserInfoId IS NOT NULL 
		ORDER BY  UD.UPSIDocumentDtsId DESC

		RETURN 0	
END
