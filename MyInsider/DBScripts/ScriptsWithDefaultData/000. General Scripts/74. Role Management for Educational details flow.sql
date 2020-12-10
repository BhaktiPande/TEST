/*-------------------------------------------------------------------------------------------------
Description:	This script is used for Education Details and Work Details in Edit Permissions for Insider and 
				Mandatory Fields for Insider Screen.
Scenario:       In Role Management Assigning Seperate Validation for Education Details field and Work Details field in Edit Permissions for Insider and 
				Mandatory Fields for Insider Screen.               
			
Created by:		Novitkumar Magare
Created on:		28-Feb-2019

-------------------------------------------------------------------------------------------------*/
-- used for to solved DMATE Undefined Error
ALTER TABLE usr_DMATDetails ALTER COLUMN DPBank NVARCHAR(200) NULL;

--INSERT SCRIPT FOR Educational Details View on usr_Activity	
BEGIN
	DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Educational Details' and UPPER(ActivityName)='View')
	BEGIN
		SELECT @ActivityID = 242 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Educational Details','View','103002',NULL,'View right for Educational details',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR Educational Details Create on usr_Activity	
BEGIN
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Educational Details' and UPPER(ActivityName)='Create')
	BEGIN
		SELECT @ActivityID = 243 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Educational Details','Create','103002',NULL,'Create right for Educational details',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR Educational Details Edit on usr_Activity	
BEGIN
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Educational Details' and UPPER(ActivityName)='Edit')
	BEGIN
		SELECT @ActivityID = 244 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Educational Details','Edit','103002',NULL,'Edit right for Educational details',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR Educational Details Delete on usr_Activity	
BEGIN
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Educational Details' and UPPER(ActivityName)='Delete')
	BEGIN
		SELECT @ActivityID = 245 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Educational Details','Delete','103002',NULL,'Delete right for Educational details',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR Educational Details View on usr_Activity	
BEGIN
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Work Details' and UPPER(ActivityName)='View')
	BEGIN
		SELECT @ActivityID = 246 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Work Details','View','103002',NULL,'View right for Work details',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR Educational Details Create on usr_Activity	
BEGIN
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Work Details' and UPPER(ActivityName)='Create')
	BEGIN
		SELECT @ActivityID = 247 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Work Details','Create','103002',NULL,'Create right for Work details',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR Educational Details Edit on usr_Activity	
BEGIN
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Work Details' and UPPER(ActivityName)='Edit')
	BEGIN
		SELECT @ActivityID = 248 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Work Details','Edit','103002',NULL,'Edit right for Work details',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR Educational Details Delete on usr_Activity	
BEGIN
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Work Details' and UPPER(ActivityName)='Delete')
	BEGIN
		SELECT @ActivityID = 249 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Work Details','Delete','103002',NULL,'Delete right for Work details',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--20-2-19
--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Institute Name')
	BEGIN
		SELECT @ActivityID = 250 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Institute Name','103002',NULL,'Mandatory Field - Institute Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='250')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(250,'usr_lbl_54003','Institute Name')
	END

	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Course Name')
	BEGIN
		SELECT @ActivityID = 251 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Course Name','103002',NULL,'Mandatory Field - Course Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='251')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(251,'usr_lbl_54004','Course Name')
	END

	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Passing Month')
	BEGIN
		SELECT @ActivityID = 252 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Passing Month','103002',NULL,'Mandatory Field - Passing Month',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='252')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(252,'usr_lbl_54005','Passing Month')
	END

	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Passing Year')
	BEGIN
		SELECT @ActivityID = 253 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Passing Year','103002',NULL,'Mandatory Field - Passing Year',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='253')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(253,'usr_lbl_54006','Passing Year')
	END

	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Work Employer')
	BEGIN
		SELECT @ActivityID = 254 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Work Employer','103002',NULL,'Mandatory Field - Work Employer',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='254')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(254,'usr_lbl_54010','Employer')
	END


	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Work Designation')
	BEGIN
		SELECT @ActivityID = 255 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Work Designation','103002',NULL,'Mandatory Field - Work Designation',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='255')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(255,'usr_lbl_54011','Designation')
	END


	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Working From Month')
	BEGIN
		SELECT @ActivityID = 256 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Working From Month','103002',NULL,'Mandatory Field - Working From Month',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='256')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(256,'usr_lbl_54024','From Month')
	END


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Working To Month')
	BEGIN
		SELECT @ActivityID = 257 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Working To Month','103002',NULL,'Mandatory Field - Working To Month',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='257')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(257,'usr_lbl_54026','To Month')
	END

	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Working From Year')
	BEGIN
		SELECT @ActivityID = 258 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Working From Year','103002',NULL,'Mandatory Field - Working From Year',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='258')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(258,'usr_lbl_54025','From Year')
	END


	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Working To Year')
	BEGIN
		SELECT @ActivityID = 259 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Working To Year','103002',NULL,'Mandatory Field - Working To Year',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='259')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(259,'usr_lbl_54027','To Year')
	END


	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- For Edit Permissions for Insider 

--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Institute Name')
	BEGIN
		SELECT @ActivityID = 260 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Institute Name','103002',NULL,'Edit Permissions for Institute Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='260')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(260,'usr_lbl_54003','Institute Name')
	END


	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Course Name')
	BEGIN
		SELECT @ActivityID = 261 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Course Name','103002',NULL,'Edit Permissions for Course Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='261')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(261,'usr_lbl_54004','Course Name')
	END


	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Passing Month')
	BEGIN
		SELECT @ActivityID = 262 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Passing Month','103002',NULL,'Edit Permissions for Passing Month',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='262')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(262,'usr_lbl_54005','Passing Month')
	END

	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Passing Year')
	BEGIN
		SELECT @ActivityID = 263 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Passing Year','103002',NULL,'Edit Permissions for Passing Year',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='263')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(263,'usr_lbl_54006','Passing Year')
	END


	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Work Employer')
	BEGIN
		SELECT @ActivityID = 264 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Work Employer','103002',NULL,'Edit Permissions for Work Employer',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='264')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(264,'usr_lbl_54010','Employer')
	END


	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Work Designation')
	BEGIN
		SELECT @ActivityID = 265 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Work Designation','103002',NULL,'Edit Permissions for Work Designation',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='265')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(265,'usr_lbl_54011','Designation')
	END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Working From Month')
	BEGIN
		SELECT @ActivityID = 266 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Working From Month','103002',NULL,'Edit Permissions for Working From Month',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='266')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(266,'usr_lbl_54024','From Month')
	END


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Working To Month')
	BEGIN
		SELECT @ActivityID = 267 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Working To Month','103002',NULL,'Edit Permissions for Working To Month',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='267')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(267,'usr_lbl_54026','To Month')
	END

	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Working From Year')
	BEGIN
		SELECT @ActivityID = 268 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Working From Year','103002',NULL,'Edit Permissions for Working From Year',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='268')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(268,'usr_lbl_54025','From Year')
	END

	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Working To Year')
	BEGIN
		SELECT @ActivityID = 269 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Working To Year','103002',NULL,'Edit Permissions for Working To Year',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='269')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(269,'usr_lbl_54027','To Year')
	END

	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--26/2/2019

--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Resident Type')
	BEGIN
		SELECT @ActivityID = 270 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Resident Type','103002',NULL,'Mandatory Field - Resident Type',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='270')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(270,'usr_lbl_54050','Resident Type')
	END
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Identification Number')
	BEGIN
		SELECT @ActivityID = 271 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Identification Number','103002',NULL,'Mandatory Field - Identification Number',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='271')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(271,'usr_lbl_54051','Identification Number')
	END

	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Resident Type')
	BEGIN
		SELECT @ActivityID = 272 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Resident Type','103002',NULL,'Edit Permissions for Resident Type',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='272')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(272,'usr_lbl_54050','Resident Type')
	END
	
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Identification Number')
	BEGIN
		SELECT @ActivityID = 273 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Identification Number','103002',NULL,'Edit Permissions for Identification Number',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='273')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(273,'usr_lbl_54051','Identification Number')
	END


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--15/04/2019.
-- Role management for  Co-Operate User

delete usr_UserTypeActivity where ActivityId in (45,46,50,51,53,54,63,64,68,69,71,72,161,163) and UserTypeCodeId = 101004
delete from usr_ActivityResourceMapping where ActivityId between 280 and 325
delete from USR_USERTYPEACTIVITY where ActivityId between 280 and 325
delete from usr_RoleActivity where ActivityID between 280 and 325
delete from usr_Activity where ActivityID between 280 and 325

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Contact Person (Corporate User)')
	BEGIN
		SELECT @ActivityID = 280 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Contact Person (Corporate User)','103002',NULL,'Edit Permissions for Contact Person (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='280')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(280,'usr_lbl_11290','Contact Person (Corporate User)')
	END	

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	

BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Designation (Corporate User)')
	BEGIN
		SELECT @ActivityID = 281 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Designation (Corporate User)','103002',NULL,'Edit Permissions for Designation (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='281')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(281,'usr_lbl_11291','Designation (Corporate User)')
	END

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	

BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='LandLine1 (Corporate User)')
	BEGIN
		SELECT @ActivityID = 282 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','LandLine1 (Corporate User)','103002',NULL,'Edit Permissions for LandLine1 (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='282')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(282,'usr_lbl_11293','LandLine1 (Corporate User)')
	END

	
		
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='LandLine2 (Corporate User)')
	BEGIN
		SELECT @ActivityID = 283 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','LandLine2 (Corporate User)','103002',NULL,'Edit Permissions for LandLine2 (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='283')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(283,'usr_lbl_11294','LandLine2 (Corporate User)')
	END

	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	

BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Pincode (Corporate User)')
	BEGIN
		SELECT @ActivityID = 284 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Pincode (Corporate User)','103002',NULL,'Edit Permissions for Pincode (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='284')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(284,'usr_lbl_11296','Pincode (Corporate User)')
	END	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Country (Corporate User)')
	BEGIN
		SELECT @ActivityID = 285 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Country (Corporate User)','103002',NULL,'Edit Permissions for Country (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='285')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(285,'usr_lbl_11297','Country (Corporate User)')
	END

	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Website (Corporate User)')
	BEGIN
		SELECT @ActivityID = 286 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Website (Corporate User)','103002',NULL,'Edit Permissions for Website (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='286')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(286,'usr_lbl_11298','Website (Corporate User)')
	END

	
	
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='TAN (Corporate User)')
	BEGIN
		SELECT @ActivityID = 287 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','TAN (Corporate User)','103002',NULL,'Edit Permissions for TAN (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='287')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(287,'usr_lbl_11299','TAN (Corporate User)')
	END

													

	
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Description (Corporate User)')
	BEGIN
		SELECT @ActivityID = 288 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Description (Corporate User)','103002',NULL,'Edit Permissions for Description (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='288')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(288,'usr_lbl_11301','Description (Corporate User)')
	END

	
	
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Category (Corporate User)')
	BEGIN
		SELECT @ActivityID = 289 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Category (Corporate User)','103002',NULL,'Edit Permissions for Category (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='289')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(289,'usr_lbl_11427','Category (Corporate User)')
	END

								

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='SubCategory (Corporate User)')
	BEGIN
		SELECT @ActivityID = 290 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','SubCategory (Corporate User)','103002',NULL,'Edit Permissions for SubCategory (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='290')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(290,'usr_lbl_11428','SubCategory (Corporate User)')
	END

	

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
		
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Contact Person (Corporate User)')
	BEGIN
		SELECT @ActivityID = 291 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Contact Person (Corporate User)','103002',NULL,'Mandatory Field - Contact Person (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='291')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(291,'usr_lbl_11290','Contact Person (Corporate User)')
	END

	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Designation (Corporate User)')
	BEGIN
		SELECT @ActivityID = 292 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Designation (Corporate User)','103002',NULL,'Mandatory Field - Designation (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='292')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(292,'usr_lbl_11291','Designation (Corporate User)')
	END

	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='LandLine1 (Corporate User)')
	BEGIN
		SELECT @ActivityID = 293 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','LandLine1 (Corporate User)','103002',NULL,'Mandatory Field - LandLine1 (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='293')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(293,'usr_lbl_11293','LandLine1 (Corporate User)')
	END

	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='LandLine2 (Corporate User)')
	BEGIN
		SELECT @ActivityID = 294 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','LandLine2 (Corporate User)','103002',NULL,'Mandatory Field - LandLine2 (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='294')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(294,'usr_lbl_11294','LandLine2 (Corporate User)')
	END

	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity		
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Pincode (Corporate User)')
	BEGIN
		SELECT @ActivityID = 295 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Pincode (Corporate User)','103002',NULL,'Mandatory Field - Pincode (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='295')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(295,'usr_lbl_11296','Pincode (Corporate User)')
	END

	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Country (Corporate User)')
	BEGIN
		SELECT @ActivityID = 296 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Country (Corporate User)','103002',NULL,'Mandatory Field - Country (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='296')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(296,'usr_lbl_11297','Country (Corporate User)')
	END

	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Website (Corporate User)')
	BEGIN
		SELECT @ActivityID = 297 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Website (Corporate User)','103002',NULL,'Mandatory Field - Website (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='297')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(297,'usr_lbl_11298','Website (Corporate User)')
	END

	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='TAN (Corporate User)')
	BEGIN
		SELECT @ActivityID = 298 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','TAN (Corporate User)','103002',NULL,'Mandatory Field - TAN (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='298')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(298,'usr_lbl_11299','TAN (Corporate User)')
	END

	
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Description (Corporate User)')
	BEGIN
		SELECT @ActivityID = 299 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Description (Corporate User)','103002',NULL,'Mandatory Field - Description (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='299')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(299,'usr_lbl_11301','Description (Corporate User)')
	END

	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Category (Corporate User)')
	BEGIN
		SELECT @ActivityID = 300 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Category (Corporate User)','103002',NULL,'Mandatory Field - Category (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='300')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(300,'usr_lbl_11427','Category (Corporate User)')
	END


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='SubCategory (Corporate User)')
	BEGIN
		SELECT @ActivityID = 301 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','SubCategory (Corporate User)','103002',NULL,'Mandatory Field - SubCategory (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='301')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(301,'usr_lbl_11428','SubCategory (Corporate User)')
	END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Email (Corporate User)')
	BEGIN
		SELECT @ActivityID = 302 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Email (Corporate User)','103002',NULL,'Edit Permissions for Email (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='302')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(302,'usr_lbl_11292','Email (Corporate User)')
	END

	

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='User Name (Corporate User)')
	BEGIN
		SELECT @ActivityID = 303 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','User Name (Corporate User)','103002',NULL,'Edit Permissions for User Name (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='303')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(303,'usr_lbl_11287','User Name (Corporate User)')
	END

	

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
				
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Company (Corporate User)')
	BEGIN
		SELECT @ActivityID = 304 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Company (Corporate User)','103002',NULL,'Edit Permissions for Company (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='304')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(304,'usr_lbl_11286','Company (Corporate User)')
	END

	

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Address (Corporate User)')
	BEGIN
		SELECT @ActivityID = 305 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Address (Corporate User)','103002',NULL,'Edit Permissions for Address (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='305')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(305,'usr_lbl_11295','Address (Corporate User)')
	END

	

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Date Of Becoming Insider (Corporate User)')
	BEGIN
		SELECT @ActivityID = 306 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Date Of Becoming Insider (Corporate User)','103002',NULL,'Edit Permissions for Date Of Becoming Insider (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='306')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(306,'usr_lbl_11288','Date Of Becoming Insider (Corporate User)')
	END

	

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='PAN (Corporate User)')
	BEGIN
		SELECT @ActivityID = 307 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','PAN (Corporate User)','103002',NULL,'Edit Permissions for PAN (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='307')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(307,'usr_lbl_11300','PAN (Corporate User)')
	END

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='CIN (Corporate User)')
	BEGIN
		SELECT @ActivityID = 308 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','CIN (Corporate User)','103002',NULL,'Edit Permissions for CIN (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='308')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(308,'usr_lbl_11289','CIN (Corporate User)')
	END	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN

	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Email (Corporate User)')
	BEGIN
		SELECT @ActivityID = 309 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Email (Corporate User)','103002',NULL,'Mandatory Field - Email (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='309')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(309,'usr_lbl_11292','Email (Corporate User)')
	END

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='User Name (Corporate User)')
	BEGIN
		SELECT @ActivityID = 310 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','User Name (Corporate User)','103002',NULL,'Mandatory Field - User Name (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='310')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(310,'usr_lbl_11287','User Name (Corporate User)')
	END

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Company (Corporate User)')
	BEGIN
		SELECT @ActivityID = 311 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Company (Corporate User)','103002',NULL,'Mandatory Field - Company (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='311')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(311,'usr_lbl_11286','Company (Corporate User)')
	END	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Address (Corporate User)')
	BEGIN
		SELECT @ActivityID = 312 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Address (Corporate User)','103002',NULL,'Mandatory Field - Address (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='312')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(312,'usr_lbl_11295','Address (Corporate User)')
	END	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Date Of Becoming Insider (Corporate User)')
	BEGIN
		SELECT @ActivityID = 313 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Date Of Becoming Insider (Corporate User)','103002',NULL,'Mandatory Field - Date Of Becoming Insider (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='313')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(313,'usr_lbl_11288','Date Of Becoming Insider (Corporate User)')
	END
	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='PAN (Corporate User)')
	BEGIN
		SELECT @ActivityID = 314 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','PAN (Corporate User)','103002',NULL,'Mandatory Field - PAN (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='314')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(314,'usr_lbl_11300','PAN (Corporate User)')
	END


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='CIN (Corporate User)')
	BEGIN
		SELECT @ActivityID = 315 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','CIN (Corporate User)','103002',NULL,'Mandatory Field - CIN (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='315')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(315,'usr_lbl_11289','CIN (Corporate User)')
	END

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='DMAT account Number (Corporate User)')
	BEGIN
		SELECT @ActivityID = 316 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','DMAT account Number (Corporate User)','103002',NULL,'Edit Permissions for DMAT account Number (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='316')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(316,'usr_lbl_11306','DMAT account Number (Corporate User)')
	END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	

BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='DP Name (Corporate User)')
	BEGIN
		SELECT @ActivityID = 317 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','DP Name (Corporate User)','103002',NULL,'Edit Permissions for DP Name (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='317')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(317,'usr_lbl_11307','DP Name (Corporate User)')
	END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	

BEGIN
				
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='DPID (Corporate User)')
	BEGIN
		SELECT @ActivityID = 318 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','DPID (Corporate User)','103002',NULL,'Edit Permissions for DPID (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='318')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(318,'usr_lbl_11308','DPID (Corporate User)')
	END

	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	

BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='TMID (Corporate User)')
	BEGIN
		SELECT @ActivityID = 319 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','TMID (Corporate User)','103002',NULL,'Edit Permissions for TMID (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='319')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(319,'usr_lbl_52092','TMID (Corporate User)')
	END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR usr_Activity	

BEGIN
		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='DMAT Description (Corporate User)')
	BEGIN
		SELECT @ActivityID = 320 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','DMAT Description (Corporate User)','103002',NULL,'Edit Permissions for DMAT Description (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='320')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(320,'usr_lbl_52093','DMAT Description (Corporate User)')
	END

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='DMAT account Number (Corporate User)')
	BEGIN
		SELECT @ActivityID = 321 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','DMAT account Number (Corporate User)','103002',NULL,'Mandatory Field - DMAT account Number (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='321')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(321,'usr_lbl_11306','DMAT account Number (Corporate User)')
	END

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='DP Name (Corporate User)')
	BEGIN
		SELECT @ActivityID = 322 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','DP Name (Corporate User)','103002',NULL,'Mandatory Field - DP Name (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='322')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(322,'usr_lbl_11307','DP Name (Corporate User)')
	END

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='DPID (Corporate User)')
	BEGIN
		SELECT @ActivityID = 323 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','DPID (Corporate User)','103002',NULL,'Mandatory Field - DPID (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='323')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(323,'usr_lbl_11308','DPID (Corporate User)')
	END

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='TMID (Corporate User)')
	BEGIN
		SELECT @ActivityID = 324 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','TMID (Corporate User)','103002',NULL,'Mandatory Field - TMID (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='324')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(324,'usr_lbl_52092','TMID (Corporate User)')
	END

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT SCRIPT FOR usr_Activity	
BEGIN
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='DMAT Description (Corporate User)')
	BEGIN
		SELECT @ActivityID = 325 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','DMAT Description (Corporate User)','103002',NULL,'Mandatory Field - DMAT Description (Corporate User)',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101004')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='325')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(325,'usr_lbl_52093','DMAT Description (Corporate User)')
	END
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

create table #usr_Activity(ID int identity,RoleID int)
insert into #usr_Activity
select RoleID from usr_RoleMaster
Declare @nCount int =0
Declare @nTotCount int=0

select @nTotCount=COUNT(RoleID)  from #usr_Activity

while @nCount<@nTotCount
begin
declare @nRoleId int=0
select @nRoleId =RoleID from #usr_Activity where ID=@nCount+1

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='242' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(242,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='243' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(243,@nRoleId,1,GETDATE(),1,GETDATE())
END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='244' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(244,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='245' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(245,@nRoleId,1,GETDATE(),1,GETDATE())
END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='246' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(246,@nRoleId,1,GETDATE(),1,GETDATE())
END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='247' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(247,@nRoleId,1,GETDATE(),1,GETDATE())
END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='248' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(248,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='249' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(249,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='250' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(250,@nRoleId,1,GETDATE(),1,GETDATE())
	END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='251' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(251,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='252' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(252,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='253' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(253,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='254' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(254,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='255' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(255,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='256' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(256,@nRoleId,1,GETDATE(),1,GETDATE())
	END
	


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='257' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(257,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='258' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(258,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='259' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(259,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='260' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(260,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='261' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(261,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='262' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(262,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='263' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(263,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='264' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(264,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='265' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(265,@nRoleId,1,GETDATE(),1,GETDATE())
	END
	

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='266' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(266,@nRoleId,1,GETDATE(),1,GETDATE())
	END
	


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='267' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(267,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='268' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(268,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='269' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(269,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='270' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(270,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='271' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(271,@nRoleId,1,GETDATE(),1,GETDATE())
	END


IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='272' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(272,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='273' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(273,@nRoleId,1,GETDATE(),1,GETDATE())
	END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='315' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(315,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='314' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(314,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='313' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(313,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='312' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(312,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='311' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(311,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='310' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(310,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='309' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(309,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='308' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(308,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='307' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(307,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='306' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(306,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='305' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(305,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='304' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(304,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='303' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(303,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='302' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(302,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='301' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(301,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='300' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(300,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='299' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(299,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='298' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(298,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='297' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(297,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='296' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(296,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='295' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(295,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='294' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(294,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='293' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(293,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='292' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(292,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='291' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(291,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='290' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(290,@nRoleId,1,GETDATE(),1,GETDATE())
	END		
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='289' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(289,@nRoleId,1,GETDATE(),1,GETDATE())
	END	
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='288' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(288,@nRoleId,1,GETDATE(),1,GETDATE())
	END	
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='287' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(287,@nRoleId,1,GETDATE(),1,GETDATE())
	END		
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='286' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(286,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='285' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(285,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='284' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(284,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='283' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(283,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='282' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(282,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='281' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(281,@nRoleId,1,GETDATE(),1,GETDATE())
	END
IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='280' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(280,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='316' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(316,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='317' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(317,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='318' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(318,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='319' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(319,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='320' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(320,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='321' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(321,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='322' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(322,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='323' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(323,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='324' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(324,@nRoleId,1,GETDATE(),1,GETDATE())
	END

	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='325' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(325,@nRoleId,1,GETDATE(),1,GETDATE())
	END

set @nCount=@nCount+1
END
drop table #usr_Activity
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Script for Add New coloum in Demate list Grid

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51002)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51002,'usr_grd_51002','Total quantity','en-US',103002,104003,122007,'Total quantity',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_51002')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114005,'usr_grd_51002',1,7,0,155001,114074,'usr_grd_51002')
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114005,'usr_grd_51002',1,7,0,155001,NULL,NULL)
END
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Added resourced for error msg
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 51003)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (51003,'usr_lbl_51003','You do not have rights to add DMATE Details','en-US',103002,104002,122072,'You do not have rights to add DMATE Details',1,GETDATE())
END

