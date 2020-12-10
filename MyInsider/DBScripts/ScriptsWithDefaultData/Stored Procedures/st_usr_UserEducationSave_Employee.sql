IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserEducationSave_Employee')
DROP PROCEDURE [dbo].[st_usr_UserEducationSave_Employee]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the CR User Education details

Returns:		0, if Success.
				
Created by:		Samadhan
Created on:		14-Feb-2019

M
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserEducationSave_Employee]
	 @inp_iUserInfoID INT = 0
	,@inp_iInstituteName 	VARCHAR(250) =null
	,@inp_iCourseName		VARCHAR(250) =null
	,@inp_iEmployerName		VARCHAR(250) =null
	,@inp_iDesignation		VARCHAR(100) =null
	,@inp_iPMonth			VARCHAR(20) =null
	,@inp_iPYear			int=0
	,@inp_iToMonth			VARCHAR(20) =null
	,@inp_iToYear			int=0
	,@inp_iFlag				int=0
	,@inp_iOperation		VARCHAR(20) =null
	,@inp_iCreatedBy		int=0
	,@inp_iUEW_id           int=0
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	AS
AS
BEGIN

	DECLARE @ERR_USEREDUCATIONINFO_SAVE INT = 54040 -- Error occurred while saving education details for employee.
	
		DECLARE @nRetValue INT = 0

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

		--Save the UserEducation details
		
		BEGIN
			IF(@inp_iOperation='INSERT')
			BEGIN
			
			  IF @inp_iFlag=1
			  BEGIN
				IF EXISTS(SELECT UEW_ID FROM usr_EducationWorkDetails WHERE USERINFOID=@inp_iUserInfoID AND INSTITUTENAME=@inp_iInstituteName AND COURSENAME=@inp_iCourseName AND PMONTH= @inp_iPMonth AND PYEAR=@inp_iPYear  )
				BEGIN
				 SET @out_nReturnValue=54047
				 RETURN  @out_nReturnValue
				END
			   if( @inp_iInstituteName is null  AND @inp_iCourseName is null  AND @inp_iPMonth is null  AND  @inp_iPYear =0 )
				BEGIN
				 SET @out_nReturnValue=54054
				 RETURN  @out_nReturnValue
				END
			  END
			 ELSE 
			  BEGIN
					IF EXISTS(SELECT UEW_ID FROM usr_EducationWorkDetails WHERE USERINFOID=@inp_iUserInfoID AND EmployerName=@inp_iEmployerName AND Designation=@inp_iDesignation AND PMONTH= @inp_iPMonth AND PYEAR=@inp_iPYear AND ToMonth=@inp_iToMonth and ToYear=@inp_iToYear)
					BEGIN
					 SET @out_nReturnValue=54048
					  RETURN  @out_nReturnValue
					END
					
					IF(@inp_iEmployerName is null AND  @inp_iDesignation  is null AND  @inp_iPMonth is null AND  @inp_iPYear=0 AND @inp_iToMonth is null and  @inp_iToYear=0)
					BEGIN
					SET @out_nReturnValue=54054
					  RETURN  @out_nReturnValue
					END
			  END
			    		
			    update usr_UserInfo set DoYouHaveEduOrWorkDetails=0 where UserInfoID= @inp_iUserInfoID
			    
				Insert into usr_EducationWorkDetails
				(
					UserInfoID		,
					InstituteName	,
					CourseName		,
					EmployerName	,
					Designation		,
					PMonth			,
					PYear			,
					ToMonth			,
					ToYear			,
					Flag			,
					CreatedBy		,	
					CreatedOn		
									 	
					
				)
				Values
				(
					 @inp_iUserInfoID 
					,@inp_iInstituteName
					,@inp_iCourseName	
					,@inp_iEmployerName	
					,@inp_iDesignation	
					,@inp_iPMonth		
					,@inp_iPYear		
					,@inp_iToMonth		
					,@inp_iToYear		
					,@inp_iFlag			
					,@inp_iCreatedBy
					,GETDATE()
				)
				
				 update usr_UserInfo set DoYouHaveEduOrWorkDetails=1 where UserInfoID= @inp_iUserInfoID
			END	
			ELSE IF(@inp_iOperation='UPDATE')
			BEGIN
			  IF @inp_iFlag=1
			  BEGIN
			   if(  @inp_iInstituteName is null AND @inp_iCourseName is null AND  @inp_iPMonth is null AND  @inp_iPYear =0 )
				BEGIN
				
				 SET @out_nReturnValue=54054
				 RETURN  @out_nReturnValue
				END
			  END
			 ELSE 
			  BEGIN
					IF(@inp_iEmployerName is null  AND @inp_iDesignation is null AND  @inp_iPMonth is null AND  @inp_iPYear=0 AND  @inp_iToMonth is null and  @inp_iToYear=0)
					BEGIN
					SET @out_nReturnValue=54054
					  RETURN  @out_nReturnValue
					END
			  END

			  IF @inp_iFlag=1
			  BEGIN
			  	 DECLARE @nUserEducationId INT=0
				 SELECT @nUserEducationId=UEW_id FROM usr_EducationWorkDetails WHERE  INSTITUTENAME=@inp_iInstituteName AND COURSENAME=@inp_iCourseName AND PMONTH= @inp_iPMonth AND PYEAR=@inp_iPYear 
				
				IF(@nUserEducationId<>'' OR @nUserEducationId<>0)
				BEGIN
					 IF (@nUserEducationId<>@inp_iUEW_id )
					 BEGIN				 
						 SET @out_nReturnValue=54047
						 RETURN  @out_nReturnValue
					 END
				 END
				if( @inp_iInstituteName is null  AND @inp_iCourseName is null  AND @inp_iPMonth is null  AND  @inp_iPYear =0 )
				BEGIN
				 SET @out_nReturnValue=54054
				 RETURN  @out_nReturnValue
				END
			  END
			 ELSE 
			  BEGIN

				 DECLARE @nUserWorkId INT=0
				 SELECT @nUserWorkId=UEW_id FROM usr_EducationWorkDetails WHERE EmployerName=@inp_iEmployerName AND Designation=@inp_iDesignation AND PMONTH= @inp_iPMonth AND PYEAR=@inp_iPYear AND ToMonth=@inp_iToMonth and ToYear=@inp_iToYear
				print(@nUserWorkId)
				print(@inp_iUEW_id)
				IF(@nUserWorkId<>'' OR @nUserWorkId<>0)
				BEGIN
					 IF (@nUserWorkId<>@inp_iUEW_id )
					 BEGIN
						 SET @out_nReturnValue=54048
						 RETURN  @out_nReturnValue
					 END
				 END

					IF(@inp_iEmployerName is null AND  @inp_iDesignation  is null AND  @inp_iPMonth is null AND  @inp_iPYear=0 AND @inp_iToMonth is null and  @inp_iToYear=0)
					BEGIN
					SET @out_nReturnValue=54054
					  RETURN  @out_nReturnValue
					END
			  END
			  
				UPDATE usr_EducationWorkDetails SET InstituteName= @inp_iInstituteName	,
					CourseName		=@inp_iCourseName,
					EmployerName	=@inp_iEmployerName,
					Designation		=@inp_iDesignation,
					PMonth			=@inp_iPMonth,
					PYear			=@inp_iPYear,
					ToMonth			=@inp_iToMonth,
					ToYear			=@inp_iToYear,
					UpdatedBy		=@inp_iCreatedBy,
					UpdatedOn      =GETDATE()
					WHERE UEW_id=@inp_iUEW_id 
					
				update usr_UserInfo set DoYouHaveEduOrWorkDetails=1 where UserInfoID= @inp_iUserInfoID
			END
			ELSE IF(@inp_iOperation='DELETE')
			BEGIN
			   Declare @usr_Infoid int =(select UserInfoID from usr_EducationWorkDetails where UEW_id=@inp_iUEW_id)
			
			   DELETE FROM usr_EducationWorkDetails WHERE UEW_id=@inp_iUEW_id
			  
			  
			   if not exists(select UEW_id from usr_EducationWorkDetails where UserInfoID= @usr_Infoid)
			   begin
			    update usr_UserInfo set DoYouHaveEduOrWorkDetails=0 where UserInfoID= @usr_Infoid
			   end
			   
			END
			ELSE IF(@inp_iOperation='UPDATE_NO_EDU_WORK')
			BEGIN
				IF NOT EXISTS(select UserInfoID from usr_EducationWorkDetails WHERE  UserInfoID= @inp_iUserInfoID)
				BEGIN
			    update usr_UserInfo set DoYouHaveEduOrWorkDetails=0 where UserInfoID= @inp_iUserInfoID
			    END
			END
		  
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
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_USEREDUCATIONINFO_SAVE, ERROR_NUMBER())
	END CATCH
END
GO


