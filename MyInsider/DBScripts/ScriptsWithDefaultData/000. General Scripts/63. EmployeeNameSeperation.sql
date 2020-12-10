/*-------------------------------------------------------------------------------------------------
Description:	This script is used for seperation of Employee Name and Employee Relative Name with Middle Name , Last Name in Edit Permissions for Insider and 
				Mandatory Fields for Insider Screen.
Scenario:       In Role Management Assigning Seperate Validation for Employee Name , Middle Name and Last Name in Edit Permissions for Insider and 
				Mandatory Fields for Insider Screen.               
			
Created by:		Novitkumar Magare
Created on:		08-August-2018

-------------------------------------------------------------------------------------------------*/

--INSERT SCRIPT FOR EMP Middle Name usr_Activity	
BEGIN
	DECLARE @ActivityID BIGINT

	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Claw Back Report' and UPPER(ActivityName)='VIEW')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Claw Back Report','View','103011',NULL,'Claw Back Report Details',105001,' ',1,GETDATE(),1,GETDATE())
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
	END
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Employee Middle Name')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Employee Middle Name','103002',NULL,'Edit permission for Employee Middle Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END
--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='231')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(231,'usr_lbl_11332','MiddleName')
		DELETE FROM usr_ActivityResourceMapping WHERE ResourceKey in ('usr_lbl_11332') and ActivityId = 47

	END
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--INSERT SCRIPT FOR EMP LAST NAME on usr_Activity	
BEGIN
	--DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Employee Last Name')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Employee Last Name','103002',NULL,'Edit permission for Employee Last Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='232')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(232,'usr_lbl_11333','LastName')
		DELETE FROM usr_ActivityResourceMapping WHERE ResourceKey in ('usr_lbl_11333') and ActivityId = 47

	END


----------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR EMP Middle Name usr_Activity	
BEGIN
	--DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Relative Middle Name')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Relative Middle Name','103002',NULL,'Edit permission for Relative Middle Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END


--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='233')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(233,'usr_lbl_11358','MiddleName')
		DELETE FROM usr_ActivityResourceMapping WHERE ResourceKey in ('usr_lbl_11358') and ActivityId = 90

	END

----------------------------------------------------------------------------------------------------------------------------------------------------------


--INSERT SCRIPT FOR EMP Middle Name usr_Activity	
BEGIN
	--DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Edit Permissions for Insider' and UPPER(ActivityName)='Relative Last Name')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Relative Last Name','103002',NULL,'Edit permission for Relative Last Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='234')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(234,'usr_lbl_11359','LastName')
		DELETE FROM usr_ActivityResourceMapping WHERE ResourceKey in ('usr_lbl_11359') and ActivityId = 90

	END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT SCRIPT FOR EMP Middle Name usr_Activity	
BEGIN
	--DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Employee Middle Name')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Employee Middle Name','103002',NULL,'Mandatory Field - Employee Middle Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='235')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(235,'usr_lbl_11332','MiddleName')
		DELETE FROM usr_ActivityResourceMapping WHERE ResourceKey in ('usr_lbl_11332') and ActivityId = 65

	END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--INSERT SCRIPT FOR EMP Middle Name usr_Activity	
BEGIN
	--DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Employee Last Name')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Employee Last Name','103002',NULL,'Mandatory Field - Employee Last Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='236')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(236,'usr_lbl_11333','LastName')
		DELETE FROM usr_ActivityResourceMapping WHERE ResourceKey in ('usr_lbl_11333') and ActivityId = 65

	END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--INSERT SCRIPT FOR Relative Middle Name usr_Activity	
BEGIN
	--DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Relative Middle Name')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Relative Middle Name','103002',NULL,'Mandatory Field - Relative Middle Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='237')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(237,'usr_lbl_11358','MiddleName')
		DELETE FROM usr_ActivityResourceMapping WHERE ResourceKey in ('usr_lbl_11358') and ActivityId = 106

	END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--INSERT SCRIPT FOR Relative Last Name usr_Activity	
BEGIN
	--DECLARE @ActivityID BIGINT		
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='Mandatory Fields for Insider' and UPPER(ActivityName)='Relative Last Name')
	BEGIN
		SELECT @ActivityID = MAX(ActivityID) + 1 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Relative Last Name','103002',NULL,'Mandatory Field - Relative Last Name',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='238')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(238,'usr_lbl_11359','LastName')
		DELETE FROM usr_ActivityResourceMapping WHERE ResourceKey in ('usr_lbl_11359') and ActivityId = 106

	END

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

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='231' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(231,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='232' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(232,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='233' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(233,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='234' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(234,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='235' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(235,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='236' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(236,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='237' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(237,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='238' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(238,@nRoleId,1,GETDATE(),1,GETDATE())
END

set @nCount=@nCount+1
end
drop table #usr_Activity
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE usr_Activity
set ActivityName='Relative First Name'
WHERE ActivityId=106 and ScreenName='Mandatory Fields for Insider';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE usr_Activity
set ActivityName='Employee First Name'
WHERE ActivityId=65 and ScreenName='Mandatory Fields for Insider';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE usr_Activity
set ActivityName='Relative First Name'
WHERE ActivityId=90 and ScreenName='Edit Permissions for Insider';


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE usr_Activity
set ActivityName='Employee First Name'
WHERE ActivityId=47 and ScreenName='Edit Permissions for Insider';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE usr_Activity
SET DisplayOrder = '1'
WHERE ActivityName='Employee First Name' and ScreenName='Edit Permissions for Insider'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE usr_Activity
SET DisplayOrder = '2'
WHERE ActivityName='Employee Middle Name' and ScreenName='Edit Permissions for Insider'


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE usr_Activity
SET DisplayOrder = '3'
WHERE ActivityName='Employee Last Name' and ScreenName='Edit Permissions for Insider'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE usr_Activity
SET DisplayOrder = '4'
WHERE ActivityName='Relative First Name' and ScreenName='Edit Permissions for Insider'


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE usr_Activity
SET DisplayOrder = '5'
WHERE ActivityName='Relative Middle Name' and ScreenName='Edit Permissions for Insider'


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE usr_Activity
SET DisplayOrder = '6'
WHERE ActivityName='Relative Last Name' and ScreenName='Edit Permissions for Insider'


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE usr_Activity
SET DisplayOrder = '7'
WHERE ActivityName='Employee First Name' and ScreenName='Mandatory Fields for Insider'


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE usr_Activity
SET DisplayOrder = '8'
WHERE ActivityName='Employee Middle Name' and ScreenName='Mandatory Fields for Insider'


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE usr_Activity
SET DisplayOrder = '9'
WHERE ActivityName='Employee Last Name' and ScreenName='Mandatory Fields for Insider'


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE usr_Activity
SET DisplayOrder = '10'
WHERE ActivityName='Relative First Name' and ScreenName='Mandatory Fields for Insider'


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE usr_Activity
SET DisplayOrder = '11'
WHERE ActivityName='Relative Middle Name' and ScreenName='Mandatory Fields for Insider'


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE usr_Activity
SET DisplayOrder = '12'
WHERE ActivityName='Relative Last Name' and ScreenName='Mandatory Fields for Insider'


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





