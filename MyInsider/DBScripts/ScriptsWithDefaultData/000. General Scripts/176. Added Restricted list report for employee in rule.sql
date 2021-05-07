
--Report list Activity for 513003 Both module for own=513001 and others=513002
Update usr_Activity set ApplicableFor=513001 where ActivityID=201

--Added select* from usr_UserTypeActivity where ActivityId=201 
--select * from com_Code where CodeGroupId=101
--101001 for Admin 101002 for CO
IF NOT EXISTS(select 1 from usr_UserTypeActivity where ActivityId = 201 and UserTypeCodeId=101001)
BEGIN
	insert into usr_UserTypeActivity values(201,101001)
END

----For Own=513001 
--IF NOT EXISTS(select 1 from usr_Activity where ActivityId = 346)
--BEGIN
--	Insert INTO usr_Activity Values(346,'Report','View',103301,NULL,'View right for Restricted List Report',105001,'',1,GETDATE(),1,GETDATE(),513002)
--END

--IF NOT EXISTS(select 1 from usr_UserTypeActivity where ActivityId = 346 and UserTypeCodeId=101001)
--BEGIN
--	insert into usr_UserTypeActivity values(346,101001)
--END

--IF NOT EXISTS(select 1 from usr_UserTypeActivity where ActivityId = 346 and UserTypeCodeId=101002)
--BEGIN
--	insert into usr_UserTypeActivity values(346,101002)
--END

----For Others=513002
--IF NOT EXISTS(select 1 from usr_Activity where ActivityID = 347)
--BEGIN
--	Insert INTO usr_Activity Values(347,'Report','View',103301,NULL,'View right for Restricted List Report',105001,'',1,GETDATE(),1,GETDATE(),513001)
--END

--IF NOT EXISTS(select 1 from usr_UserTypeActivity where ActivityId = 347 and UserTypeCodeId=101001)
--BEGIN
--	insert into usr_UserTypeActivity values(347,101001)
--END

--IF NOT EXISTS(select 1 from usr_UserTypeActivity where ActivityId = 347 and UserTypeCodeId=101002)
--BEGIN
--	insert into usr_UserTypeActivity values(347,101002)
--END


