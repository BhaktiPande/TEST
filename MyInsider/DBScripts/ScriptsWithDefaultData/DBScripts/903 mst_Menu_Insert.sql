/*
Add Menus
*/
INSERT INTO mst_MenuMaster(MenuID, MenuName, Description, MenuURL, DisplayOrder, ParentMenuID, StatusCodeID, ImageURL, ToolTipText, ActivityID, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES 
	-------- USers
	(1, 'User', 'User Menu', NULL, 14, NULL, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(2, 'CO User', 'CO User', NULL, 1401, 1, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(3, 'Employee/Insider', 'Employee / Insider user', null, 1402, 1, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(16, 'View My Details', 'View Employee Details', null, 1403, 1, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(17, 'View My Details', 'View Corporate User Details', null, 1404, 1, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(18, 'View My Details', 'View Non-Employee Details', null, 1405, 1, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(19, 'Change Password', 'Change Password', null, 1499, 1, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	-------- Roles
	(4, 'Roles', 'Roles Menu', null, 17, null, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(13, 'Roles Management', 'Manage roles', null, 1701, 4, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(15, 'Delegation Management', 'Manage Delegations', null, 1702, 4, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	-------- Rules
	(5, 'Rules', 'Manage rules', null, 20, null, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(6, 'Policy Documents', 'Manage rules - Policy Document', null, 2001, 5, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(23, 'Policy Document Status', 'Policy Documents Menu', NULL, 2002, 5, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(7, 'Trading Policy', 'Manage rules - Trading Policy', null, 2003, 5, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(8, 'Trading Window', 'Manage rules - Trading Window', null, 2004, 5, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(20, 'Financial Year', 'Trading window event - Financial year', NULL, 200401, 8, 102001, NULL, null, null, 1, GETDATE(), 1, GETDATE()),
	(21, 'Other', 'Trading window event - Other', NULL, 200402, 8, 102001, NULL, null, null, 1, GETDATE(), 1, GETDATE()),
	(9, 'Trading Plan', 'Manage rules - Trading Plan', null, 2005, 5, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	/* Added on 13-Oct-2015, received from KPCS for restricted list code merging */
	(48 ,'Restricted List','Restricted List',NULL,2006,5,102001,NULL,NULL,NULL,1,GETDATE(),1,GETDATE()),
	
	------- Masters
	(10, 'Master', 'Master Menu', NULL, 23, NULL, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(11, 'Company', 'Company creation', NULL, 2301, 10, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(12, 'Master Codes', 'Master Codes creation', NULL, 2302, 10, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(14, 'Resources (Labels,Titles)', 'Labels and Messages', NULL, 2303, 10, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	------- Transactions
	(22, 'Transactions', 'Transactions Menu', NULL, 26, NULL, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(29, 'Initial Disclosures', 'Initial Disclosures list menu for CO', NULL, 2601, 22, 102001, NULL, NULL, 165, 1, GETDATE(), 1, GETDATE()),
	(30, 'Continuous Disclosures', 'Continuous Disclosures list menu for CO', NULL, 2602, 22, 102001, NULL, NULL, 167, 1, GETDATE(), 1, GETDATE()),
	(31, 'Period End Disclosures', 'Period End Disclosures list menu for CO', NULL, 2603, 22, 102001, NULL, NULL, 169, 1, GETDATE(), 1, GETDATE()),
	
	------- Transactions for Insider
	(24, 'Transactions', 'Transactions Menu for insider', NULL, 29, NULL, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(25, 'Policy Documents', 'Policy Documents Menu for Insider', NULL, 2901, 24, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(26, 'Initial Disclosures', 'Initial Disclosures Menu for Insider', NULL, 2902, 24, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(27, 'Continuous Disclosures', 'Continuous Disclosures Menu for Insider', NULL, 2903, 24, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(28, 'Period End Disclosures', 'Period End Disclosures Menu for Insider', NULL, 2904, 24, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),

	------- Communication module
	(32, 'Communication', 'Communication Menu', NULL, 32, NULL, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(33, 'Templates', 'Templates Menu', NULL, 3201, 32, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(34, 'Communication Rules', 'Communication Rules Menu', NULL, 3202, 32, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(35, 'Notifications', 'Notifications Menu', NULL, 3203, 32, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),

	------- Report Module
	(36, 'Reports', 'Reports', NULL, 35, NULL, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(37, 'Initial Disclosures', 'Initial Disclosures Menu', NULL, 3501, 36, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(38, 'Continuous Disclosures', 'Continuous Disclosures', NULL, 3502, 36, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(39, 'Period End Disclosures', 'Period End Disclosures', NULL, 3503, 36, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(40, 'Pre-Clearance', 'Pre-Clearance Report', NULL, 3504, 36, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(47, 'Defaulter', 'Defaulter Report', NULL, 3505, 36, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	/* Added on 13-Oct-2015, received from KPCS for restricted list code merging */
	(49,'Restricted List Report','Restricted List Report',NULL,3506,36,102001,NULL,NULL,NULL,1,GETDATE(),1,GETDATE()),
	(51,'Restricted List Logs','Restricted List Logs',NULL,3507,36,102001,NULL,NULL,NULL,1,GETDATE(),1,GETDATE()),
	/*Script received from KPCS while code merge on 18-Dec */	
	(52,'R&T Report','R&T Report','/SSRSReport/RnTReport?acid=212',3508,36,102001,NULL,NULL,212,1,GETDATE(),1,GETDATE()),
	/*Script received from KPCS while code merge on 04-Jan-2016 */
	(53,'View Error Log Report','View Error Log Report Menu','/SSRSReports/ViewErrorLogReport?acid=213',3508,36,102001,NULL,NULL,213,1,GETDATE(),1,GETDATE()),
	
	-- Restricted list	Added on 13-Oct-2015, received from KPCS for restricted list code merging 
	(50,'Restricted List','Restricted List Menu',NULL,37,NULL,102001,'icon icon-rules',NULL,NULL,1,GETDATE(),1,GETDATE()),
	
	(41, 'Dashboard', 'Dashboard Menu', null, 10, null, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	
	(42, 'View My Details', 'View CO User Details', null, 1498, 1, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),
	(43, 'Dashboard', 'CO Dashboard Menu', null, 10, null, 102001, NULL, NULL, NULL, 1, GETDATE(), 1, GETDATE()),

	---- FAQ	
	(44 ,'FAQ' ,'CO FAQ List' , 'FAQ/COFAQList?acid=193' ,50 ,NULL ,102001 ,'glyphicon glyphicon-question-sign' ,NULL ,193 ,1 ,GETDATE() ,1 ,GETDATE()),
	(45 ,'FAQ' ,'Insider FAQ List' , 'FAQ/InsiderFAQList?acid=194' ,50 ,NULL ,102001 ,'glyphicon glyphicon-question-sign' ,NULL ,194 ,1 ,GETDATE() ,1 ,GETDATE()),
	-- in menu url acid change to "9" because earlier acid (195) is deleted (Script received from Raghvendra on 19-Feb-2016 )
	(46 ,'MassUpload' ,'Mass Upload' ,'MassUpload/AllMassUpload?acid=9' ,34 ,NULL ,102001 ,'icon icon-reports', NULL , 9, 1 ,GETDATE() ,1 ,GETDATE()) 


GO
-----------------------------------------------------------------------------------------
UPDATE mst_MenuMaster SET ActivityID = 1 WHERE MenuID = 2
UPDATE mst_MenuMaster SET ActivityID = 5 WHERE MenuID = 3

UPDATE mst_MenuMaster SET ActivityID = 117 WHERE MenuID = 6
UPDATE mst_MenuMaster SET ActivityID = 121 WHERE MenuID = 7
UPDATE mst_MenuMaster SET ActivityID = 125 WHERE MenuID = 8
UPDATE mst_MenuMaster SET ActivityID = 129 WHERE MenuID = 9

UPDATE mst_MenuMaster SET ActivityID = 10 WHERE MenuID = 11
UPDATE mst_MenuMaster SET ActivityID = 14 WHERE MenuID = 12
UPDATE mst_MenuMaster SET ActivityID = 19 WHERE MenuID = 13
UPDATE mst_MenuMaster SET ActivityID = 23 WHERE MenuID = 14
UPDATE mst_MenuMaster SET ActivityID = 41 WHERE MenuID = 15
UPDATE mst_MenuMaster SET ActivityID = 81 WHERE MenuID = 16
UPDATE mst_MenuMaster SET ActivityID = 82 WHERE MenuID = 17
UPDATE mst_MenuMaster SET ActivityID = 83 WHERE MenuID = 18
UPDATE mst_MenuMaster SET ActivityID = 84 WHERE MenuID = 19

UPDATE mst_MenuMaster SET ActivityID = 125 WHERE MenuID = 20
UPDATE mst_MenuMaster SET ActivityID = 134 WHERE MenuID = 21

UPDATE mst_MenuMaster SET ActivityID = 138 WHERE MenuID = 23

UPDATE mst_MenuMaster SET ActivityID = 154 WHERE MenuID = 25
UPDATE mst_MenuMaster SET ActivityID = 155 WHERE MenuID = 26
UPDATE mst_MenuMaster SET ActivityID = 157 WHERE MenuID = 27
UPDATE mst_MenuMaster SET ActivityID = 159 WHERE MenuID = 28

UPDATE mst_MenuMaster SET ActivityID = 174 WHERE MenuID = 33
UPDATE mst_MenuMaster SET ActivityID = 179 WHERE MenuID = 34
UPDATE mst_MenuMaster SET ActivityID = 184 WHERE MenuID = 35

UPDATE mst_MenuMaster SET ActivityID = 186 WHERE MenuID = 37
UPDATE mst_MenuMaster SET ActivityID = 187 WHERE MenuID = 38
UPDATE mst_MenuMaster SET ActivityID = 188 WHERE MenuID = 39
UPDATE mst_MenuMaster SET ActivityID = 189 WHERE MenuID = 40
UPDATE mst_MenuMaster SET ActivityID = 196 WHERE MenuID = 47

UPDATE mst_MenuMaster SET ActivityID = 191 WHERE MenuID = 41

UPDATE mst_MenuMaster SET ActivityID = 192 WHERE MenuID = 42
UPDATE mst_MenuMaster SET ActivityID = 18 WHERE MenuID = 43

UPDATE mst_MenuMaster SET ActivityID = 197 WHERE MenuID = 48
UPDATE mst_MenuMaster SET ActivityID = 201 WHERE MenuID = 49
UPDATE mst_MenuMaster SET ActivityID = 210 WHERE MenuID = 50
UPDATE mst_MenuMaster SET ActivityID = 211 WHERE MenuID = 51
UPDATE mst_MenuMaster SET ActivityID = 212 WHERE MenuID = 52

-----------------------------------------------------------------------------------------
UPDATE mst_MenuMaster SET MenuURL = '/UserDetails/Index?acid=1' WHERE MenuID = 2
UPDATE mst_MenuMaster SET MenuURL = '/Employee/Index?acid=5' WHERE MenuID = 3

UPDATE mst_MenuMaster SET MenuURL = '/PolicyDocuments/Index?acid=140' WHERE MenuID = 6
UPDATE mst_MenuMaster SET MenuURL = '/TradingPolicy/Index?acid=121' WHERE MenuID = 7

UPDATE mst_MenuMaster SET MenuURL = '/Company/Index?acid=10' WHERE MenuID = 11
UPDATE mst_MenuMaster SET MenuURL = '/ComCode/Index?acid=14&CodeGroupId=0-0&ParentCodeId=0' where MenuID = 12
UPDATE mst_MenuMaster SET MenuURL = '/RoleMaster/Index?acid=19' WHERE MenuID = 13
UPDATE mst_MenuMaster SET MenuURL = '/Resource/Index?acid=23' WHERE MenuID = 14
UPDATE mst_MenuMaster SET MenuURL = '/Delegate/Index?acid=41' WHERE MenuID = 15
update mst_MenuMaster set MenuURL= '/Employee/ViewDetails?acid=81&nUserInfoID={UserInfoID}' where MenuID = 16
update mst_MenuMaster set MenuURL= '/CorporateUser/ViewRecords?acid=82&nUserInfoID={UserInfoID}' where MenuID = 17
update mst_MenuMaster set MenuURL= '/Employee/ViewDetails?acid=83&nUserInfoID={UserInfoID}' where MenuID = 18
UPDATE mst_MenuMaster SET MenuURL = '/UserDetails/ChangePassword?acid=84' WHERE MenuID = 19
UPDATE mst_MenuMaster SET MenuURL = '/TradingWindowEvent/index?acid=125&FinancialYearId=0' WHERE MenuID = 20
UPDATE mst_MenuMaster SET MenuURL = '/TradingWindowsOther/Index?acid=134' WHERE MenuID = 21
UPDATE mst_MenuMaster SET MenuURL = '/PolicyDocuments/Index?acid=138' WHERE MenuID = 23

UPDATE mst_MenuMaster SET MenuURL = '/InsiderInitialDisclosure/List?acid=154' WHERE MenuID = 25
UPDATE mst_MenuMaster SET MenuURL= '/InsiderInitialDisclosure/Index?acid=155' WHERE MenuID = 26
UPDATE mst_MenuMaster SET MenuURL = '/PreclearanceRequest/Index?acid=157' WHERE MenuID = 27
UPDATE mst_MenuMaster SET MenuURL = '/PeriodEndDisclosure/PeriodStatus?acid=159' WHERE MenuID = 28


UPDATE mst_MenuMaster SET MenuURL = '/COInitialDisclosure/List?acid=165' WHERE MenuID = 29
UPDATE mst_MenuMaster SET MenuURL = '/PreclearanceRequest/ListByCO?acid=167' WHERE MenuID = 30
UPDATE mst_MenuMaster SET MenuURL = '/PeriodEndDisclosure/UsersStatus?acid=169' WHERE MenuID = 31

UPDATE mst_MenuMaster SET MenuURL = '/TemplateMaster/Index?acid=174' WHERE MenuID = 33
UPDATE mst_MenuMaster SET MenuURL = '/CommunicationRuleMaster/Index?acid=179' WHERE MenuID = 34
UPDATE mst_MenuMaster SET MenuURL = '/Notification/index?acid=184&CalledFrom=menu' WHERE MenuID = 35

UPDATE mst_MenuMaster SET MenuURL = '/Reports/InitialDisclosureEmployeeWise?acid=186' WHERE MenuID = 37
UPDATE mst_MenuMaster SET MenuURL = '/Reports/ContinuousDisclosureEmployeeWise?acid=187' WHERE MenuID = 38
UPDATE mst_MenuMaster SET MenuURL = '/Reports/PeriodEndDisclosureEmployeeWise?acid=188' WHERE MenuID = 39
UPDATE mst_MenuMaster SET MenuURL = '/Reports/PreclearenceEmployeeWise?acid=189' WHERE MenuID = 40
UPDATE mst_MenuMaster SET MenuURL = '/Reports/defaulterreport?acid=196' WHERE MenuID = 47

UPDATE mst_MenuMaster SET MenuURL = '/InsiderDashboard/Index?acid=191' WHERE MenuID = 41

UPDATE mst_MenuMaster SET MenuURL = '/UserDetails/Edit?acid=192&CalledFrom=View&UserInfoID={UserInfoID}' WHERE MenuID = 42
UPDATE mst_MenuMaster SET MenuURL = '/CODashboard/Index?acid=18' WHERE MenuID = 43

UPDATE mst_MenuMaster SET MenuURL = '/RestrictedList/Index?acid=197' WHERE MenuID = 48
UPDATE mst_MenuMaster SET MenuURL = '/SSRSReport/RestrictedListSearchReport?acid=201' WHERE MenuID = 49
UPDATE mst_MenuMaster SET MenuURL = '/RestrictedList/RestrictedListSearch?acid=210' WHERE MenuID = 50
UPDATE mst_MenuMaster SET MenuURL = '/SSRSReport/RestrictedListSearchReport?acid=211' WHERE MenuID = 51
UPDATE mst_MenuMaster SET MenuURL = '/SSRSReport/RnTReport?acid=212' WHERE MenuID = 52

---- Update imageURLs
UPDATE mst_MenuMaster SET ImageURL = 'icon icon-users' WHERE MenuID = 1
UPDATE mst_MenuMaster SET ImageURL = 'icon icon-users' WHERE MenuID = 4
UPDATE mst_MenuMaster SET ImageURL = 'icon icon-rules' WHERE MenuID = 5
UPDATE mst_MenuMaster SET ImageURL = 'icon icon-masters' WHERE MenuID = 10
UPDATE mst_MenuMaster SET ImageURL = 'icon icon-transactions' WHERE MenuID = 22
UPDATE mst_MenuMaster SET ImageURL = 'icon icon-transactions' WHERE MenuID = 24
UPDATE mst_MenuMaster SET ImageURL = 'icon icon-communications' WHERE MenuID = 32	
UPDATE mst_MenuMaster SET ImageURL = 'icon icon-reports' WHERE MenuID = 36	
UPDATE mst_MenuMaster SET ImageURL = 'icon icon-dashboard' WHERE MenuID = 41	
UPDATE mst_MenuMaster SET ImageURL = 'icon icon-dashboard' WHERE MenuID = 43	

UPDATE mst_MenuMaster SET MenuName = 'Master Codes', Description = 'Master Codes Creation' where MenuID = 12
UPDATE mst_MenuMaster SET MenuName = 'Resources (Labels,Titles)', Description = 'Resources (Labels,Titles)' where MenuID = 14




---- Menu order changed on 3-Jun-2015
--UPDATE mst_MenuMaster set MenuName = 'Policy Document Status', ParentMenuID = 5, DisplayOrder = 1202 where MenuID = 23
--UPDATE mst_MenuMaster set DisplayOrder = 1203 where MenuID = 7
--UPDATE mst_MenuMaster set DisplayOrder = 1204 where MenuID = 8
--UPDATE mst_MenuMaster set DisplayOrder = 120401 where MenuID = 20
--UPDATE mst_MenuMaster set DisplayOrder = 120402 where MenuID = 21
--UPDATE mst_MenuMaster set DisplayOrder = 1205 where MenuID = 9


UPDATE mst_MenuMaster SET DisplayOrder = 14 WHERE MenuId = 1
UPDATE mst_MenuMaster SET DisplayOrder = 1401 WHERE MenuId = 2
UPDATE mst_MenuMaster SET DisplayOrder = 1402 WHERE MenuId = 3
UPDATE mst_MenuMaster SET DisplayOrder = 1403 WHERE MenuId = 16
UPDATE mst_MenuMaster SET DisplayOrder = 1404 WHERE MenuId = 17
UPDATE mst_MenuMaster SET DisplayOrder = 1405 WHERE MenuId = 18
UPDATE mst_MenuMaster SET DisplayOrder = 1499 WHERE MenuId = 19
UPDATE mst_MenuMaster SET DisplayOrder = 17 WHERE MenuId = 4
UPDATE mst_MenuMaster SET DisplayOrder = 1701 WHERE MenuId = 13
UPDATE mst_MenuMaster SET DisplayOrder = 1702 WHERE MenuId = 15
UPDATE mst_MenuMaster SET DisplayOrder = 20 WHERE MenuId = 5
UPDATE mst_MenuMaster SET DisplayOrder = 2001 WHERE MenuId = 6
UPDATE mst_MenuMaster SET DisplayOrder = 2002 WHERE MenuId = 23
UPDATE mst_MenuMaster SET DisplayOrder = 2003 WHERE MenuId = 7
UPDATE mst_MenuMaster SET DisplayOrder = 2004 WHERE MenuId = 8
UPDATE mst_MenuMaster SET DisplayOrder = 200401 WHERE MenuId = 20
UPDATE mst_MenuMaster SET DisplayOrder = 200402 WHERE MenuId = 21
UPDATE mst_MenuMaster SET DisplayOrder = 2005 WHERE MenuId = 9
UPDATE mst_MenuMaster SET DisplayOrder = 23 WHERE MenuId = 10
UPDATE mst_MenuMaster SET DisplayOrder = 2301 WHERE MenuId = 11
UPDATE mst_MenuMaster SET DisplayOrder = 2302 WHERE MenuId = 12
UPDATE mst_MenuMaster SET DisplayOrder = 2303 WHERE MenuId = 14
UPDATE mst_MenuMaster SET DisplayOrder = 26 WHERE MenuId = 22
UPDATE mst_MenuMaster SET DisplayOrder = 2601 WHERE MenuId = 29
UPDATE mst_MenuMaster SET DisplayOrder = 2602 WHERE MenuId = 30
UPDATE mst_MenuMaster SET DisplayOrder = 2603 WHERE MenuId = 31
UPDATE mst_MenuMaster SET DisplayOrder = 29 WHERE MenuId = 24
UPDATE mst_MenuMaster SET DisplayOrder = 2901 WHERE MenuId = 25
UPDATE mst_MenuMaster SET DisplayOrder = 2902 WHERE MenuId = 26
UPDATE mst_MenuMaster SET DisplayOrder = 2903 WHERE MenuId = 27
UPDATE mst_MenuMaster SET DisplayOrder = 2904 WHERE MenuId = 28
UPDATE mst_MenuMaster SET DisplayOrder = 32 WHERE MenuId = 32
UPDATE mst_MenuMaster SET DisplayOrder = 3201 WHERE MenuId = 33
UPDATE mst_MenuMaster SET DisplayOrder = 3202 WHERE MenuId = 34
UPDATE mst_MenuMaster SET DisplayOrder = 3203 WHERE MenuId = 35
UPDATE mst_MenuMaster SET DisplayOrder = 35 WHERE MenuId = 36
UPDATE mst_MenuMaster SET DisplayOrder = 3501 WHERE MenuId = 37
UPDATE mst_MenuMaster SET DisplayOrder = 3502 WHERE MenuId = 38
UPDATE mst_MenuMaster SET DisplayOrder = 3503 WHERE MenuId = 39
UPDATE mst_MenuMaster SET DisplayOrder = 3504 WHERE MenuId = 40

UPDATE mst_MenuMaster SET MenuURL = '/SSRSReport/ViewErrorLogReport?acid=213' WHERE MenuID = 53

-- Script received from ED on 12-Feb-2016
--Initial Disclosure menu url change 2016-02-12 16:52:32.923
UPDATE mst_MenuMaster SET MenuURL = '/COInitialDisclosure/Index?acid=165' WHERE MenuID = 29


