--INSERT SCRIPT FOR usr_Activity	
DECLARE @ActivityID INT
BEGIN
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) =UPPER('Edit Permissions for Insider') and UPPER(ActivityName)=UPPER('Address Personal'))
	BEGIN
		SELECT @ActivityID = 342 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Edit Permissions for Insider','Address Personal','103002',NULL,'Edit permission for Address Personal',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')

		
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='342')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(342,'usr_lbl_54227','Address Personal')
	END

--INSERT SCRIPT FOR usr_Activity	
BEGIN
			
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) =UPPER('Mandatory Fields for Insider') and UPPER(ActivityName)='Address Personal')
	BEGIN
		SELECT @ActivityID = 343 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'Mandatory Fields for Insider','Address Personal','103002',NULL,'Mandatory Field - Address Personal',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101003')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101006')
	END
END

--INSERT SCRIPT FOR usr_ActivityResourceMapping
IF NOT EXISTS (SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityID ='343')
	BEGIN
		INSERT INTO usr_ActivityResourceMapping(ActivityID,ResourceKey,ColumnName)
		VALUES(343,'usr_lbl_54227','Address Personal')
	END



create table #usr_Activity(ID int identity,RoleID int)
insert into #usr_Activity
select RoleID from usr_RoleMaster
Declare @nCount int =1
Declare @nTotCount int=0

select @nTotCount=COUNT(RoleID)  from #usr_Activity

while @nCount<@nTotCount
begin
declare @nRoleId int=0
select @nRoleId =RoleID from #usr_Activity where ID=@nCount

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='342' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(342,@nRoleId,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='343' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(343,@nRoleId,1,GETDATE(),1,GETDATE())
END

set @nCount=@nCount+1
end

drop table #usr_Activity

