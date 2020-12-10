/*
101001	Admin
101002	CO User
101003	Employee
101004	Corporate User
101005	Super Admin
101006	Non Employee
101007	Relative
*/
delete from usr_UserTypeActivity --where UserTypeCodeId = 101001 OR UserTypeCodeId = 101002

-- Admin
INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
SELECT 101001, ActivityId FROM usr_Activity 
WHERE ActivityID BETWEEN 1 AND 38 /*Remove activity 39 on 18 feb 2016*/ 
OR ActivityID BETWEEN 40 AND 80 
OR ActivityID = 84
OR ActivityID BETWEEN 85 AND 140
OR ActivityID BETWEEN 141 AND 146
OR ActivityID BETWEEN 161 AND 164
OR ActivityID BETWEEN 165 AND 173
OR ActivityID BETWEEN 174 AND 189--190
OR ActivityID = 193
OR ActivityID = 196
OR ActivityID = 212 /*Script received from KPCS while code merge on 18-Dec */
OR ActivityID = 213 /*Script received from KPCS while code merge on 18-Dec */
OR ActivityID = 214 


-- CO User
INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
SELECT 101002, ActivityId FROM usr_Activity 
WHERE ActivityID BETWEEN 1 AND 38 /*Remove activity 39 on 18 feb 2016*/ 
OR ActivityID BETWEEN 40 AND 80 
OR ActivityID = 84
OR ActivityID BETWEEN 85 AND 140
OR ActivityID BETWEEN 141 AND 152
OR ActivityID BETWEEN 161 AND 164
OR ActivityID BETWEEN 165 AND 173
OR ActivityID BETWEEN 174 AND 189--190
OR ActivityID IN (192, 193)
OR ActivityID = 196
OR ActivityID BETWEEN 197 AND 209 -- Added on 13-Oct-2015, received from KPCS for restricted list code merging
OR ActivityID = 212 /*Script received from KPCS while code merge on 04-Jan-2016 */
OR ActivityID = 213 /*Script received from KPCS while code merge on 04-Jan-2016 */
OR ActivityID = 214 

-- Employee
INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
SELECT 101003, ActivityId FROM usr_Activity 
WHERE 1 = 0
OR ActivityID BETWEEN 45 AND 81
OR ActivityID BETWEEN 25 AND 36
OR ActivityID BETWEEN 84 AND 116
OR ActivityID IN (7/*, 18*/)
OR ActivityID BETWEEN 153 AND 160
OR ActivityID IN (162, 164)
OR ActivityID IN (179, 180, /*182,*/ 184, 185, 190, 191, 194)
OR ActivityID IN (210, 211) -- Added on 13-Oct-2015, received from KPCS for restricted list code merging


-- Corporate User
INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
SELECT 101004, ActivityId FROM usr_Activity 
WHERE 1 = 0
OR ActivityID BETWEEN 45 AND 46
OR ActivityID BETWEEN 50 AND 51
OR ActivityID IN (53, 54, 63, 64, 68, 69, 71, 72)
OR ActivityID BETWEEN 25 AND 36
OR ActivityID IN (7/*, 18*/, 82)
OR ActivityID = 84
OR ActivityID BETWEEN 153 AND 160
OR ActivityID IN (161, 163)
OR ActivityID IN (179, 180, /*182,*/ 184, 185,190, 191, 194)


-- Non-Employee User
INSERT INTO usr_UserTypeActivity(UserTypeCodeId, ActivityId)
SELECT 101006, ActivityId FROM usr_Activity 
WHERE 1 = 0
OR ActivityID BETWEEN 45 AND 54
OR ActivityID = 60
OR ActivityID BETWEEN 62 AND 72
OR ActivityID BETWEEN 25 AND 36
OR ActivityID IN (7/*, 18*/, 78, 80, 83)
OR ActivityID BETWEEN 84 AND 116
OR ActivityID BETWEEN 141 AND 152
OR ActivityID BETWEEN 153 AND 160
OR ActivityID IN (162, 164)
OR ActivityID IN (179, 180, /*182,*/ 184, 185, 190, 191, 194)






----- Insert Activities for RoleId = 1 -- Moved from script 905 to here

DELETE FROM usr_RoleActivity where RoleID = 1

INSERT INTO usr_RoleActivity(RoleID, ActivityID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
SELECT 1, A.ActivityID, 1, GETDATE(), 1, GETDATE()
FROM usr_Activity A JOIN usr_UserTypeActivity UTA ON A.ActivityID = UTA.ActivityId AND UserTypeCodeId = 101001
	LEFT JOIN usr_RoleActivity UR ON A.ActivityID = UR.ActivityID AND UR.RoleID = 1 
WHERE UR.ActivityID IS NULL
