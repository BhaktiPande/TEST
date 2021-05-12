
--Report list Activity for 513003 Both module for own=513001 and others=513002
Update usr_Activity set ApplicableFor=513003 where ActivityID=201

--Added select* from usr_UserTypeActivity where ActivityId=201 
--select * from com_Code where CodeGroupId=101
--101001 for Admin 101002 for CO
IF NOT EXISTS(select 1 from usr_UserTypeActivity where ActivityId = 201 and UserTypeCodeId=101001)
BEGIN
	insert into usr_UserTypeActivity values(201,101001)
END



