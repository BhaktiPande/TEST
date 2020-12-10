

/*-------------------------------------------------------------------------------------------------
Description:	Saves the CR User contact details

Returns:		0, if Success.
				
Created by:		Arvind
Created on:		14-Feb-2019

-------------------------------------------------------------------------------------------------*/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_ContactDetails')
	DROP PROCEDURE st_usr_ContactDetails
GO

CREATE PROCEDURE st_usr_ContactDetails
	 @inp_tblContactDetailsType	        ContactDetailsType READONLY,
	 @out_nReturnValue					INT = 0 OUTPUT,
	 @out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	 @out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
	
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

		CREATE TABLE #tmpContactDetails
		(		
		ID							INT IDENTITY(1,1) NOT NULL,
		MobileNumber				Varchar(250),
		UserInfoID                  INT NOT NULL,
		UserRelativeID				INT NOT NULL
		)
		INSERT INTO #tmpContactDetails 
		SELECT MobileNumber,UserInfoID,UserRelativeID FROM @inp_tblContactDetailsType
		
		DECLARE @nCount INT=0
		DECLARE @nTotCount INT=0
		DECLARE @nTopMobileno varchar(250)
		DECLARE @nUserInfoID INT=0
		DECLARE @nUserRelativeID INT=0		
		DECLARE @nDupMobileno varchar(250)=NULL
		DECLARE @nDupMobileNumber varchar(500)		
		DECLARE @nUsrInfoRe INT=0		
						
		SELECT @nUserInfoID= UserInfoID,@nUserRelativeID=UserRelativeID from #tmpContactDetails		
		DELETE FROM usr_ContactDetails WHERE UserRelativeID=@nUserRelativeID
					    
		
		SELECT @nTotCount=COUNT(ID) FROM #tmpContactDetails	
		
		BEGIN   ------ check duplicate mo Number --------------
			WHILE @nCount < @nTotCount
			BEGIN
				DECLARE @MobNumber_WithCountyCode VARCHAR(250)			
				DECLARE @inp_iUserInfoId INT
				DECLARE @inp_iUserRelInfoId INT
				SET @nDupMobileno=null
				
				SELECT @MobNumber_WithCountyCode=MobileNumber,@inp_iUserInfoId=UserInfoID,@inp_iUserRelInfoId=UserRelativeID FROM #tmpContactDetails WHERE ID=@nCount+1
							
				SELECT @nDupMobileno = uc.MobileNumber FROM usr_ContactDetails UC
				join usr_UserInfo U on uc.UserInfoID=u.UserInfoId				
				WHERE uc.MobileNumber =@MobNumber_WithCountyCode and uc.MobileNumber <>'' and (DateOfInactivation IS NULL OR DateOfInactivation IS NOT NULL AND DateOfInactivation >GETDATE())
				
				IF(@nDupMobileno IS NOT NULL )
				BEGIN								
					IF(
					(EXISTS(SELECT UserInfoID FROM usr_ContactDetails WHERE (MobileNumber = @MobNumber_WithCountyCode OR MobileNumber = @MobNumber_WithCountyCode)						
					AND UserInfoID IN (@inp_iUserInfoId))) 
					AND
					NOT EXISTS(
					SELECT u.UserRelativeID FROM usr_ContactDetails u 					
					WHERE (MobileNumber = @MobNumber_WithCountyCode OR MobileNumber = @MobNumber_WithCountyCode) 
					AND  u.UserRelativeID IN (@inp_iUserRelInfoId))
					)
					BEGIN
						INSERT INTO usr_ContactDetails(MobileNumber,UserInfoID,UserRelativeID,CreatedBy,CreatedOn,UpdatedBy,UpdatedOn)
						SELECT MobileNumber,UserInfoID,UserRelativeID,UserInfoID, GETDATE(),UserInfoID, GETDATE() FROM #tmpContactDetails WHERE ID=@nCount+1
					END
					ELSE
					BEGIN
						SET @nDupMobileNumber = COALESCE(isnull(@nDupMobileNumber + ',', ''),'') + CAST(@nDupMobileno AS VARCHAR(250))
					END					
				 END
				 				 
				 ELSE
				 BEGIN
					  INSERT INTO usr_ContactDetails(MobileNumber,UserInfoID,UserRelativeID,CreatedBy,CreatedOn,UpdatedBy,UpdatedOn)
					  SELECT MobileNumber,UserInfoID,UserRelativeID,UserInfoID, GETDATE(),UserInfoID, GETDATE() FROM #tmpContactDetails WHERE ID=@nCount+1
				 END				  
				 				  		  	  			  
				 SET @nCount=@nCount+1
			END						
			SELECT (ISNULL(@nDupMobileNumber,0)) AS DuplicateMobileNo 		
		END			
				
		IF @out_nReturnValue <> 0
		BEGIN
	
			RETURN @out_nReturnValue
		END
		SET @out_nReturnValue = 0	
		RETURN @out_nReturnValue		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_CONTACTDETAILS_SAVE, ERROR_NUMBER())
		
	END CATCH
END
