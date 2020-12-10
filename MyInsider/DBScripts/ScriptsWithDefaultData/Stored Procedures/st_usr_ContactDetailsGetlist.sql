/*Drop procedure if already exists and then run the CREATE script*/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_ContactDetailsGetlist')
DROP PROCEDURE [dbo].[st_usr_ContactDetailsGetlist]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the CR User contact details Getlist

Returns:		0, if Success.
				
Created by:		Arvind
Created on:		14-Feb-2019


--exec [dbo].[st_usr_ContactDetailsGetlist] 239,0,0,'DELETE',0,0,''

--exec [dbo].[st_usr_ContactDetailsGetlist] 239,0,0,''
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_ContactDetailsGetlist]
	 
	 
	 @inp_iUserInfoID			INT = 0
	
AS
BEGIN

	DECLARE @ERR_Work_LIST INT =0 -- Error occurred while fetching list of Contact Details for user. need to add code in mstresource tm 0

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		--IF @out_nReturnValue IS NULL
		--	SET @out_nReturnValue = 0
		--IF @out_nSQLErrCode IS NULL
		--	SET @out_nSQLErrCode = 0
		--IF @out_sSQLErrMessage IS NULL
		--	SET @out_sSQLErrMessage = ''

		--Get the User Contact details
		
		BEGIN
			
			select 
				 --isnull( MobileNumber,'') as MobileNumber,
					 isnull( case when len(MobileNumber) =3 and MobileNumber like '%+%' then ''else MobileNumber end  ,'') as MobileNumber,
					 UserInfoID  ,
					 UserRelativeID,
					 CreatedBy ,  
					 CreatedOn ,  
					 UpdatedBy,   
					 UpdatedOn 

			from 
					usr_ContactDetails 
			where 
					UserRelativeID=@inp_iUserInfoID
		
		END
		
		
						
		--IF @out_nReturnValue <> 0
		--BEGIN
		--	RETURN @out_nReturnValue
		--END

		--SET @out_nReturnValue = 0
		--RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		--SET @out_nSQLErrCode    =  ERROR_NUMBER()
		--SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		--SET @out_nReturnValue	=  @ERR_Work_LIST
	END CATCH
END
