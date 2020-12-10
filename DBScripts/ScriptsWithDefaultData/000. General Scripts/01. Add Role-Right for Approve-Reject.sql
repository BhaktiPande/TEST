/* CO ROLE TO APPROVE & REJECT PRE-CLEARANCE */
IF NOT EXISTS(SELECT ActivityID FROM usr_Activity WHERE ActivityID = 214)
BEGIN
	INSERT INTO usr_Activity 
	(ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, [Description], StatusCodeID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES (214,'Disclosure Details for CO','Pre-clearance Approve/Reject',103008,NULL,'Disclosure Details for CO - Pre-clearance Approve/Reject',105001,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS(SELECT ActivityID FROM USR_USERTYPEACTIVITY WHERE ActivityID = 214)
BEGIN
	/* ADDED ENTRY FOR APPROVE & REJECT PRE-CLEARANCE FOR ADMIN TYPE USER.*/
	INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES  (214,'101001')
	/* Added entry for approve & reject Pre-clearance for CO type user. */
	INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES  (214,'101002')
END