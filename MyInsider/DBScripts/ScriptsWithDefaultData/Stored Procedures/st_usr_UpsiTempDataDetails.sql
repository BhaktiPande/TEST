
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UpsiTempDataDetails')
	DROP PROCEDURE st_usr_UpsiTempDataDetails
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the Upsi Tempdata 

Returns:		0, if Success.
				
Created by:		Arvind
Created on:		10-April-2019

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE st_usr_UpsiTempDataDetails
	
	 @inp_tblUpsiTempSharingDataType	        UpsiTempSharingDataType READONLY,
	 @out_nReturnValue					        INT = 0 OUTPUT,
	 @out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	 @out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred. 
	
	
AS
BEGIN

	DECLARE @ERR_CONTACTDETAILS_SAVE	INT = 17512 -- Error occured while saving preclearance for non implementing company
		
	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		DECLARE @nCount INT=0
		DECLARE @nTotCount INT=0
		DECLARE @nID INT=1
		DECLARE @CustomerID INT=0
	CREATE TABLE #tmpUpsiDetails
		(		
		ID							INT IDENTITY(1,1) NOT NULL,
		Company_Name                Varchar(500),
		Company_Address				Varchar(500),
		Category_Shared             nvarchar(50),
		Reason_sharing      	    nvarchar(500),
		Comments					nvarchar(500),	
		PAN							nvarchar(50),
		Name						nvarchar(250),
		Phone				        nvarchar(15),	
		E_mail                      nvarchar(250),
		SharingDate                 datetime,
       	UserInfoId					INT,
		ModeOfSharing				INT,
		SharingTime					TIME,
		IsRegisteredUser			NVARCHAR(250),
		Temp2						NVARCHAR(250),
		Temp3						NVARCHAR(250),
		Temp4						NVARCHAR(250),
		Temp5						NVARCHAR(250),
		DocumentNo					NVARCHAR(250),
		Sharedby					NVARCHAR(250),
		PublishDate                 DATETIME

		)
		INSERT INTO #tmpUpsiDetails 
		SELECT Company_Name,Company_Address,Category_Shared,Reason_sharing,Comments,PAN,Name,Phone,E_mail,SharingDate,UserInfoId,ModeOfSharing,SharingTime,IsRegisteredUser,Temp2,Temp3,Temp4,Temp5,DocumentNo,Sharedby,PublishDate FROM @inp_tblUpsiTempSharingDataType

		SELECT @nTotCount=COUNT(ID) FROM #tmpUpsiDetails
		BEGIN
		INSERT INTO usr_UPSIDocumentMasters
				(
					Category,Reason,Comments,ModeOfSharing ,SharingDate	,SharingTime,PublishDate,UserInfoId	,DocumentNo,CreatedBy,CreatedOn,UpdatedBy,UpdatedOn         
				)
		SELECT TOP 1
			      Category_Shared,Reason_sharing,Comments,ModeOfSharing,SharingDate,SharingTime,PublishDate,UserInfoId,DocumentNo,
					UserInfoId, GETDATE() ,UserInfoId ,GETDATE()
		    FROM 
			   #tmpUpsiDetails 
			 SET @CustomerID = SCOPE_IDENTITY()
		    END

		WHILE @nCount<@nTotCount
		BEGIN  -----Save the Usercontact details-------------
			INSERT INTO usr_UPSIDocumentDetail
				(
					
				UPSIDocumentId,Name,PAN ,CompanyName,CompanyAddress,Phone,Email,IsRegisteredUser,Temp2,Temp3,Temp4,Temp5,Sharedby,SharingBy,SharingOn,UpdatedBy,UpdatedOn
				)
		    SELECT 
			    @CustomerID,Name,PAN,Company_Name,Company_Address,Phone,E_mail,IsRegisteredUser,Temp2,Temp3,Temp4,Temp5,Sharedby,UserInfoId, GETDATE() ,UserInfoId ,GETDATE()
				
		    FROM 
			   #tmpUpsiDetails where ID=@nCount+1
			SET @nCount=@nCount+1
		END
					 			  
				 				  		  	  			  
			
		IF @out_nReturnValue <> 0
		BEGIN
	
			RETURN @out_nReturnValue
		END
		SELECT 1
		RETURN @out_nReturnValue		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_CONTACTDETAILS_SAVE, ERROR_NUMBER())
		
	END CATCH
END
