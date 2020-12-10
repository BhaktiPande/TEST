

IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=141)
BEGIN
UPDATE usr_Activity SET Description='Edit permission for Category (Non-Employee)' WHERE ActivityID=141
END

IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=143)
BEGIN
UPDATE usr_Activity SET Description='Edit permission for Grade (Non-Employee)' WHERE ActivityID=143
END

IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=144)
BEGIN
UPDATE usr_Activity SET Description='Edit permission for Designation (Non-Employee)' WHERE ActivityID=144
END

IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=145)
BEGIN
UPDATE usr_Activity SET Description='Edit permission for Sub-Designation (Non-Employee)' WHERE ActivityID=145
END

IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=146)
BEGIN
UPDATE usr_Activity SET Description='Edit permission for Department (Non-Employee)' WHERE ActivityID=146
END

------------------For Grade Name-------------------------------------------------
IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=143)
BEGIN
UPDATE usr_Activity SET ActivityName='GradeName' WHERE ActivityId =143
END

IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=149)
BEGIN
UPDATE usr_Activity SET ActivityName='GradeName' WHERE ActivityId =149
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=143)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='GradeName' WHERE ActivityId =143
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=149)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='GradeName' WHERE ActivityId =149
END

------------------------For SubCategory------------------------------------
IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=142)
BEGIN
UPDATE usr_Activity SET ActivityName='SubCategoryName' WHERE ActivityId =142
END

IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=148)
BEGIN
UPDATE usr_Activity SET ActivityName='SubCategoryName' WHERE ActivityId =148
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=142)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='SubCategoryName' WHERE ActivityId =142
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=148)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='SubCategoryName' WHERE ActivityId =148
END


-----------------------------for Designation----------------------------------
IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=144)
BEGIN
UPDATE usr_Activity SET ActivityName='DesignationName' WHERE ActivityId =144
END

IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=150)
BEGIN
UPDATE usr_Activity SET ActivityName='DesignationName' WHERE ActivityId =150
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=144)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='DesignationName' WHERE ActivityId =144
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=150)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='DesignationName' WHERE ActivityId =150
END

------------------------for SubDesignation---------------------------------------------
IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=145)
BEGIN
UPDATE usr_Activity SET ActivityName='SubDesignationName' WHERE ActivityId =145
END

IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=151)
BEGIN
UPDATE usr_Activity SET ActivityName='SubDesignationName' WHERE ActivityId =151
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=145)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='SubDesignationName' WHERE ActivityId =145
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=151)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='SubDesignationName' WHERE ActivityId =151
END

-----------------------for Category-------------------------------------------
IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=141)
BEGIN
UPDATE usr_Activity SET ActivityName='CategoryName' WHERE ActivityId =141
END

IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=141)
BEGIN
UPDATE usr_Activity SET ActivityName='CategoryName' WHERE ActivityId =141
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=147)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='CategoryName' WHERE ActivityId =147
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=147)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='CategoryName' WHERE ActivityId =147
END

----------------------for Department----------------------------------------------------
IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=146)
BEGIN
UPDATE usr_Activity SET ActivityName='DepartmentName' WHERE ActivityId =146
END

IF EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID=152)
BEGIN
UPDATE usr_Activity SET ActivityName='DepartmentName' WHERE ActivityId =152
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=146)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='DepartmentName' WHERE ActivityId =146
END

IF EXISTS(SELECT ActivityID FROM usr_ActivityResourceMapping WHERE ActivityId=152)
BEGIN
UPDATE usr_ActivityResourceMapping SET ColumnName='DepartmentName' WHERE ActivityId =152
END






