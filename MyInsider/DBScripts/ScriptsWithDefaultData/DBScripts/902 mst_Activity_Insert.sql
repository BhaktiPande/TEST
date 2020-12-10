/*
Add Activities
*/

INSERT INTO usr_Activity
(ActivityID, ScreenName, ActivityName, ModuleCodeID, ControlName, Description, StatusCodeID, 
CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES 
(1, 'CO User', 'View', 103001, NULL, 'View right for the CO user', 105001, 1, GETDATE(), 1, GETDATE()),
(2, 'CO User', 'Create', 103001, NULL, 'Create right for the CO user', 105001, 1, GETDATE(), 1, GETDATE()),
(3, 'CO User', 'Edit', 103001, NULL, 'Edit right for the CO user', 105001, 1, GETDATE(), 1, GETDATE()),
(4, 'CO User', 'Delete', 103001, NULL, 'Delete right for the CO user', 105001, 1, GETDATE(), 1, GETDATE()),
(5, 'Employee / Insider User', 'View', 103002, NULL, 'View right for the Employee / Insider user', 105001, 1, GETDATE(), 1, GETDATE()),
(6, 'Employee / Insider User', 'Create', 103002, NULL, 'Create right for the Employee / Insider user', 105001, 1, GETDATE(), 1, GETDATE()),
(7, 'Employee / Insider User', 'Edit', 103002, NULL, 'Edit right for the Employee / Insider user', 105001, 1, GETDATE(), 1, GETDATE()),
(8, 'Employee / Insider User', 'Delete', 103002, NULL, 'Delete right for the Employee / Insider user', 105001, 1, GETDATE(), 1, GETDATE()),
(9, 'Employee / Insider User', 'Mass Upload', 103002, NULL, 'Mass Upload right for the Employee / Insider user', 105001, 1, GETDATE(), 1, GETDATE()),

(10, 'Company Master', 'View', 103004, NULL, 'View right for company master', 105001, 1, GETDATE(), 1, GETDATE()),
(11, 'Company Master', 'Create', 103004, NULL, 'Create right for company master', 105001, 1, GETDATE(), 1, GETDATE()),
(12, 'Company Master', 'Edit', 103004, NULL, 'Edit right for company master', 105001, 1, GETDATE(), 1, GETDATE()),
(13, 'Company Master', 'Delete', 103004, NULL, 'Delete right for company master', 105001, 1, GETDATE(), 1, GETDATE()),

(14, 'Other Master', 'View', 103004, NULL, 'View right for Other master', 105001, 1, GETDATE(), 1, GETDATE()),
(15, 'Other Master', 'Create', 103004, NULL, 'Create right for Other master', 105001, 1, GETDATE(), 1, GETDATE()),
(16, 'Other Master', 'Edit', 103004, NULL, 'Edit right for Other master', 105001, 1, GETDATE(), 1, GETDATE()),
(17, 'Other Master', 'Delete', 103004, NULL, 'Delete right for Other master', 105001, 1, GETDATE(), 1, GETDATE()),

(18, 'CO User Dashboard', 'Dashboard', 103001, null, 'Dashboard for Co User', 105001, 1, GETDATE(), 1, GETDATE()),
(19, 'Role Master', 'View', 103007, NULL, 'View right for Role master', 105001, 1, GETDATE(), 1, GETDATE()),
(20, 'Role Master', 'Create', 103007, NULL, 'Create right for Role master', 105001, 1, GETDATE(), 1, GETDATE()),
(21, 'Role Master', 'Edit', 103007, NULL, 'Edit right for Role master', 105001, 1, GETDATE(), 1, GETDATE()),
(22, 'Role Master', 'Delete', 103007, NULL, 'Delete right for Role master', 105001, 1, GETDATE(), 1, GETDATE()),

(23, 'Labels and Messages', 'View', 103004, NULL, 'View right for Labels and Messages', 105001, 1, GETDATE(), 1, GETDATE()),
(24, 'Labels and Messages', 'Edit', 103004, NULL, 'Edit right for Labels and Messages', 105001, 1, GETDATE(), 1, GETDATE()),

(25, 'DMAT Details', 'View', 103002, NULL, 'View right for DMAT details', 105001, 1, GETDATE(), 1, GETDATE()),
(26, 'DMAT Details', 'Create', 103002, NULL, 'Create right for DMAT details', 105001, 1, GETDATE(), 1, GETDATE()),
(27, 'DMAT Details', 'Edit', 103002, NULL, 'Edit right for DMAT details', 105001, 1, GETDATE(), 1, GETDATE()),
(28, 'DMAT Details', 'Delete', 103002, NULL, 'Delete right for DMAT details', 105001, 1, GETDATE(), 1, GETDATE()),

(29, 'Document Details', 'View', 103002, NULL, 'View right for Document details', 105001, 1, GETDATE(), 1, GETDATE()),
(30, 'Document Details', 'Create', 103002, NULL, 'Create right for Document details', 105001, 1, GETDATE(), 1, GETDATE()),
(31, 'Document Details', 'Edit', 103002, NULL, 'Edit right for Document details', 105001, 1, GETDATE(), 1, GETDATE()),
(32, 'Document Details', 'Delete', 103002, NULL, 'Delete right for Document details', 105001, 1, GETDATE(), 1, GETDATE()),

(33, 'Relatives details', 'View', 103002, NULL, 'View right for Relatives details', 105001, 1, GETDATE(), 1, GETDATE()),
(34, 'Relatives details', 'Create', 103002, NULL, 'Create right for Relatives details', 105001, 1, GETDATE(), 1, GETDATE()),
(35, 'Relatives details', 'Edit', 103002, NULL, 'Edit right for Relatives details', 105001, 1, GETDATE(), 1, GETDATE()),
(36, 'Relatives details', 'Delete', 103002, NULL, 'Delete right for Relatives details', 105001, 1, GETDATE(), 1, GETDATE()),

(37, 'Separation details', 'View', 103002, NULL, 'View right for Separation details', 105001, 1, GETDATE(), 1, GETDATE()),
(38, 'Separation details', 'Create', 103002, NULL, 'Create right for Separation details', 105001, 1, GETDATE(), 1, GETDATE()),
(39, 'Separation details', 'Edit', 103002, NULL, 'Edit right for Separation details', 105001, 1, GETDATE(), 1, GETDATE()),
(40, 'Separation details', 'Delete', 103002, NULL, 'Delete right for Separation details', 105001, 1, GETDATE(), 1, GETDATE()),

(41, 'Delegation Master', 'View', 103007, NULL, 'View right for Delegation master', 105001, 1, GETDATE(), 1, GETDATE()),
(42, 'Delegation Master', 'Create', 103007, NULL, 'Create right for Delegation master', 105001, 1, GETDATE(), 1, GETDATE()),
(43, 'Delegation Master', 'Edit', 103007, NULL, 'Edit right for Delegation master', 105001, 1, GETDATE(), 1, GETDATE()),
(44, 'Delegation Master', 'Delete', 103007, NULL, 'Delete right for Delegation master', 105001, 1, GETDATE(), 1, GETDATE()),

--- Edit / Mandatory Permissions for Insider
(45, 'Edit Permissions for Insider', 'Email', 103002, NULL, 'Edit permission for Email', 105001, 1, GETDATE(), 1, GETDATE()),
(46, 'Edit Permissions for Insider', 'User Name', 103002, NULL, 'Edit permission for User Name', 105001, 1, GETDATE(), 1, GETDATE()),
--(46, 'Edit Permissions for Insider', 'Password', 103002, NULL, 'Edit permission for ', 105001, 1, GETDATE(), 1, GETDATE()),
--(46, 'Edit Permissions for Insider', 'Status', 103002, NULL, 'Edit permission for ', 105001, 1, GETDATE(), 1, GETDATE()),
(47, 'Edit Permissions for Insider', 'Employee Name', 103002, NULL, 'Edit permission for Employee Name', 105001, 1, GETDATE(), 1, GETDATE()),
--(48, 'Edit Permissions for Insider', 'Middle Name', 103002, NULL, 'Edit permission for Middle Name', 105001, 1, GETDATE(), 1, GETDATE()),
--(49, 'Edit Permissions for Insider', 'Last Name', 103002, NULL, 'Edit permission for Last Name', 105001, 1, GETDATE(), 1, GETDATE()),
(48, 'Edit Permissions for Insider', 'Employee Id', 103002, NULL, 'Edit permission for Employee Id', 105001, 1, GETDATE(), 1, GETDATE()),
(49, 'Edit Permissions for Insider', 'Mobile Number', 103002, NULL, 'Edit permission for Mobile Number', 105001, 1, GETDATE(), 1, GETDATE()),
(50, 'Edit Permissions for Insider', 'Company', 103002, NULL, 'Edit permission for Company', 105001, 1, GETDATE(), 1, GETDATE()),
(51, 'Edit Permissions for Insider', 'Address', 103002, NULL, 'Edit permission for Address', 105001, 1, GETDATE(), 1, GETDATE()),
--(54, 'Edit Permissions for Insider', 'Country', 103002, NULL, 'Edit permission for Country', 105001, 1, GETDATE(), 1, GETDATE()),
--(55, 'Edit Permissions for Insider', 'Pin Code', 103002, NULL, 'Edit permission for Pin Code', 105001, 1, GETDATE(), 1, GETDATE()),
(52, 'Edit Permissions for Insider', 'Date Of Joining', 103002, NULL, 'Edit permission for Date Of Joining', 105001, 1, GETDATE(), 1, GETDATE()),
(53, 'Edit Permissions for Insider', 'Date Of Becoming Insider', 103002, NULL, 'Edit permission for Date Of Becoming Insider', 105001, 1, GETDATE(), 1, GETDATE()),
(54, 'Edit Permissions for Insider', 'PAN', 103002, NULL, 'Edit permission for PAN', 105001, 1, GETDATE(), 1, GETDATE()),
(55, 'Edit Permissions for Insider', 'Category', 103002, NULL, 'Edit permission for Category', 105001, 1, GETDATE(), 1, GETDATE()),
(56, 'Edit Permissions for Insider', 'Sub-Category', 103002, NULL, 'Edit permission for Sub-Category', 105001, 1, GETDATE(), 1, GETDATE()),
(57, 'Edit Permissions for Insider', 'Grade', 103002, NULL, 'Edit permission for Grade', 105001, 1, GETDATE(), 1, GETDATE()),
(58, 'Edit Permissions for Insider', 'Designation', 103002, NULL, 'Edit permission for Designation', 105001, 1, GETDATE(), 1, GETDATE()),
(59, 'Edit Permissions for Insider', 'Sub-Designation', 103002, NULL, 'Edit permission for Sub-Designation', 105001, 1, GETDATE(), 1, GETDATE()),
(60, 'Edit Permissions for Insider', 'Location', 103002, NULL, 'Edit permission for Location', 105001, 1, GETDATE(), 1, GETDATE()),
(61, 'Edit Permissions for Insider', 'Department', 103002, NULL, 'Edit permission for Department', 105001, 1, GETDATE(), 1, GETDATE()),
(62, 'Edit Permissions for Insider', 'UPSI Access To', 103002, NULL, 'Edit permission for UPSI Access To', 105001, 1, GETDATE(), 1, GETDATE()),
------------
(63, 'Mandatory Fields for Insider', 'Email', 103002, NULL, 'Mandatory Field - Email', 105001, 1, GETDATE(), 1, GETDATE()),
(64, 'Mandatory Fields for Insider', 'User Name', 103002, NULL, 'Mandatory Field - User Name', 105001, 1, GETDATE(), 1, GETDATE()),
--(46, 'Mandatory Fields for Insider', 'Password', 103002, NULL, 'Mandatory Field - ', 105001, 1, GETDATE(), 1, GETDATE()),
--(46, 'Mandatory Fields for Insider', 'Status', 103002, NULL, 'Mandatory Field - ', 105001, 1, GETDATE(), 1, GETDATE()),
(65, 'Mandatory Fields for Insider', 'Employee Name', 103002, NULL, 'Mandatory Field - Employee Name', 105001, 1, GETDATE(), 1, GETDATE()),
--(70, 'Mandatory Fields for Insider', 'Middle Name', 103002, NULL, 'Mandatory Field - Middle Name', 105001, 1, GETDATE(), 1, GETDATE()),
--(71, 'Mandatory Fields for Insider', 'Last Name', 103002, NULL, 'Mandatory Field - Last Name', 105001, 1, GETDATE(), 1, GETDATE()),
(66, 'Mandatory Fields for Insider', 'Employee Id', 103002, NULL, 'Mandatory Field - Employee Id', 105001, 1, GETDATE(), 1, GETDATE()),
(67, 'Mandatory Fields for Insider', 'Mobile Number', 103002, NULL, 'Mandatory Field - Mobile Number', 105001, 1, GETDATE(), 1, GETDATE()),
(68, 'Mandatory Fields for Insider', 'Company', 103002, NULL, 'Mandatory Field - Company', 105001, 1, GETDATE(), 1, GETDATE()),
(69, 'Mandatory Fields for Insider', 'Address', 103002, NULL, 'Mandatory Field - Address', 105001, 1, GETDATE(), 1, GETDATE()),
--(76, 'Mandatory Fields for Insider', 'Country', 103002, NULL, 'Mandatory Field - Country', 105001, 1, GETDATE(), 1, GETDATE()),
--(77, 'Mandatory Fields for Insider', 'Pin Code', 103002, NULL, 'Mandatory Field - Pin Code', 105001, 1, GETDATE(), 1, GETDATE()),
(70, 'Mandatory Fields for Insider', 'Date Of Joining', 103002, NULL, 'Mandatory Field - Date Of Joining', 105001, 1, GETDATE(), 1, GETDATE()),
(71, 'Mandatory Fields for Insider', 'Date Of Becoming Insider', 103002, NULL, 'Mandatory Field - Date Of Becoming Insider', 105001, 1, GETDATE(), 1, GETDATE()),
(72, 'Mandatory Fields for Insider', 'PAN', 103002, NULL, 'Mandatory Field - PAN', 105001, 1, GETDATE(), 1, GETDATE()),
(73, 'Mandatory Fields for Insider', 'Category', 103002, NULL, 'Mandatory Field - Category', 105001, 1, GETDATE(), 1, GETDATE()),
(74, 'Mandatory Fields for Insider', 'Sub-Category', 103002, NULL, 'Mandatory Field - Sub-Category', 105001, 1, GETDATE(), 1, GETDATE()),
(75, 'Mandatory Fields for Insider', 'Grade', 103002, NULL, 'Mandatory Field - Grade', 105001, 1, GETDATE(), 1, GETDATE()),
(76, 'Mandatory Fields for Insider', 'Designation', 103002, NULL, 'Mandatory Field - Designation', 105001, 1, GETDATE(), 1, GETDATE()),
(77, 'Mandatory Fields for Insider', 'Sub-Designation', 103002, NULL, 'Mandatory Field - Sub-Designation', 105001, 1, GETDATE(), 1, GETDATE()),
(78, 'Mandatory Fields for Insider', 'Location', 103002, NULL, 'Mandatory Field - Location', 105001, 1, GETDATE(), 1, GETDATE()),
(79, 'Mandatory Fields for Insider', 'Department', 103002, NULL, 'Mandatory Field - Department', 105001, 1, GETDATE(), 1, GETDATE()),
(80, 'Mandatory Fields for Insider', 'UPSI Access To', 103002, NULL, 'Mandatory Field - UPSI Access To', 105001, 1, GETDATE(), 1, GETDATE()),



----------------------
(81, 'Employee / Insider User', 'View Details', 103002, NULL, 'View Details right for the Employee user', 105001, 1, GETDATE(), 1, GETDATE()),
(82, 'Employee / Insider User', 'View Details', 103002, NULL, 'View Details right for the Corporate user', 105001, 1, GETDATE(), 1, GETDATE()),
(83, 'Employee / Insider User', 'View Details', 103002, NULL, 'View Details right for the Non-Employee user', 105001, 1, GETDATE(), 1, GETDATE()),
(84, 'User', 'Change Password', 103003, NULL, 'Change Password for employee', 105001, 1, GETDATE(), 1, GETDATE()),

-- DMAT edit permissions
(85, 'Edit Permissions for Insider', 'DMAT account Number', 103002, NULL, 'Edit permission for DMAT account Number', 105001, 1, GETDATE(), 1, GETDATE()),
(86, 'Edit Permissions for Insider', 'DP Name', 103002, NULL, 'Edit permission for DP Name', 105001, 1, GETDATE(), 1, GETDATE()),
(87, 'Edit Permissions for Insider', 'DP ID', 103002, NULL, 'Edit permission for DP ID', 105001, 1, GETDATE(), 1, GETDATE()),
(88, 'Edit Permissions for Insider', 'TM ID', 103002, NULL, 'Edit permission for TM ID', 105001, 1, GETDATE(), 1, GETDATE()),
(89, 'Edit Permissions for Insider', 'DMAT - Description', 103002, NULL, 'Edit permission for DMAT - Description', 105001, 1, GETDATE(), 1, GETDATE()),
-- Relatives edit permission
(90, 'Edit Permissions for Insider', 'Relative''s Name', 103002, NULL, 'Edit permission for Relative''s Name', 105001, 1, GETDATE(), 1, GETDATE()),
(91, 'Edit Permissions for Insider', 'Relative''s Address', 103002, NULL, 'Edit permission for Relative''s Address', 105001, 1, GETDATE(), 1, GETDATE()),
(92, 'Edit Permissions for Insider', 'Relative''s Contact Number', 103002, NULL, 'Edit permission for Relative''s Contact Number', 105001, 1, GETDATE(), 1, GETDATE()),
(93, 'Edit Permissions for Insider', 'Relative''s Email', 103002, NULL, 'Edit permission for Relative''s Email', 105001, 1, GETDATE(), 1, GETDATE()),
(94, 'Edit Permissions for Insider', 'Relative''s Relation', 103002, NULL, 'Edit permission for Relative''s Relation', 105001, 1, GETDATE(), 1, GETDATE()),
(95, 'Edit Permissions for Insider', 'Relative''s PAN', 103002, NULL, 'Edit permission for Relative''s PAN', 105001, 1, GETDATE(), 1, GETDATE()),
-- Relative's DMAT
(96, 'Edit Permissions for Insider', 'DMAT account Number (Relative)', 103002, NULL, 'Edit permission for DMAT account Number (Relative)', 105001, 1, GETDATE(), 1, GETDATE()),
(97, 'Edit Permissions for Insider', 'DP Name (Relative)', 103002, NULL, 'Edit permission for DP Name (Relative)', 105001, 1, GETDATE(), 1, GETDATE()),
(98, 'Edit Permissions for Insider', 'DP ID (Relative)', 103002, NULL, 'Edit permission for DP ID (Relative)', 105001, 1, GETDATE(), 1, GETDATE()),
(99, 'Edit Permissions for Insider', 'TM ID (Relative)', 103002, NULL, 'Edit permission for TM ID (Relative)', 105001, 1, GETDATE(), 1, GETDATE()),
(100, 'Edit Permissions for Insider', 'DMAT - Description (Relative)', 103002, NULL, 'Edit permission for DMAT - Description (Relative)', 105001, 1, GETDATE(), 1, GETDATE()),


-- DMAT Mandatory permissions
(101, 'Mandatory Fields for Insider', 'DMAT account Number', 103002, NULL, 'Mandatory Field for DMAT account Number', 105001, 1, GETDATE(), 1, GETDATE()),
(102, 'Mandatory Fields for Insider', 'DP Name', 103002, NULL, 'Mandatory Field for DP Name', 105001, 1, GETDATE(), 1, GETDATE()),
(103, 'Mandatory Fields for Insider', 'DP ID', 103002, NULL, 'Mandatory Field for DP ID', 105001, 1, GETDATE(), 1, GETDATE()),
(104, 'Mandatory Fields for Insider', 'TM ID', 103002, NULL, 'Mandatory Field for TM ID', 105001, 1, GETDATE(), 1, GETDATE()),
(105, 'Mandatory Fields for Insider', 'DMAT - Description', 103002, NULL, 'Mandatory Field for DMAT - Description', 105001, 1, GETDATE(), 1, GETDATE()),
-- Relatives Mandatory permission
(106, 'Mandatory Fields for Insider', 'Relative''s Name', 103002, NULL, 'Mandatory Field for Relative''s Name', 105001, 1, GETDATE(), 1, GETDATE()),
(107, 'Mandatory Fields for Insider', 'Relative''s Address', 103002, NULL, 'Mandatory Field for Relative''s Address', 105001, 1, GETDATE(), 1, GETDATE()),
(108, 'Mandatory Fields for Insider', 'Relative''s Contact Number', 103002, NULL, 'Mandatory Field for Relative''s Contact Number', 105001, 1, GETDATE(), 1, GETDATE()),
(109, 'Mandatory Fields for Insider', 'Relative''s Email', 103002, NULL, 'Mandatory Field for Relative''s Email', 105001, 1, GETDATE(), 1, GETDATE()),
(110, 'Mandatory Fields for Insider', 'Relative''s Relation', 103002, NULL, 'Mandatory Field for Relative''s Relation', 105001, 1, GETDATE(), 1, GETDATE()),
(111, 'Mandatory Fields for Insider', 'Relative''s PAN', 103002, NULL, 'Mandatory Field for Relative''s PAN', 105001, 1, GETDATE(), 1, GETDATE()),
-- Relative's DMAT Mandatory
(112, 'Mandatory Fields for Insider', 'DMAT account Number (Relative)', 103002, NULL, 'Mandatory Field for DMAT account Number (Relative)', 105001, 1, GETDATE(), 1, GETDATE()),
(113, 'Mandatory Fields for Insider', 'DP Name (Relative)', 103002, NULL, 'Mandatory Field for DP Name (Relative)', 105001, 1, GETDATE(), 1, GETDATE()),
(114, 'Mandatory Fields for Insider', 'DP ID (Relative)', 103002, NULL, 'Mandatory Field for DP ID (Relative)', 105001, 1, GETDATE(), 1, GETDATE()),
(115, 'Mandatory Fields for Insider', 'TM ID (Relative)', 103002, NULL, 'Mandatory Field for TM ID (Relative)', 105001, 1, GETDATE(), 1, GETDATE()),
(116, 'Mandatory Fields for Insider', 'DMAT - Description (Relative)', 103002, NULL, 'Mandatory Field for DMAT - Description (Relative)', 105001, 1, GETDATE(), 1, GETDATE()),






(117, 'Policy Document', 'View', 103006, NULL, 'View right for Policy Document', 105001, 1, GETDATE(), 1, GETDATE()),
(118, 'Policy Document', 'Create', 103006, NULL, 'Create right for Policy Document', 105001, 1, GETDATE(), 1, GETDATE()),
(119, 'Policy Document', 'Edit', 103006, NULL, 'Edit right for Policy Document', 105001, 1, GETDATE(), 1, GETDATE()),
(120, 'Policy Document', 'Delete', 103006, NULL, 'Delete right for Policy Document', 105001, 1, GETDATE(), 1, GETDATE()),

(121, 'Trading Policy', 'View', 103006, NULL, 'View right for Trading Policy', 105001, 1, GETDATE(), 1, GETDATE()),
(122, 'Trading Policy', 'Create', 103006, NULL, 'Create right for Trading Policy', 105001, 1, GETDATE(), 1, GETDATE()),
(123, 'Trading Policy', 'Edit', 103006, NULL, 'Edit right for Trading Policy', 105001, 1, GETDATE(), 1, GETDATE()),
(124, 'Trading Policy', 'Delete', 103006, NULL, 'Delete right for Trading Policy', 105001, 1, GETDATE(), 1, GETDATE()),

(125, 'Trading Window', 'View', 103006, NULL, 'View right for Trading Window', 105001, 1, GETDATE(), 1, GETDATE()),
(126, 'Trading Window', 'Create', 103006, NULL, 'Create right for Trading Window', 105001, 1, GETDATE(), 1, GETDATE()),
(127, 'Trading Window', 'Edit', 103006, NULL, 'Edit right for Trading Window', 105001, 1, GETDATE(), 1, GETDATE()),
(128, 'Trading Window', 'Delete', 103006, NULL, 'Delete right for Trading Window', 105001, 1, GETDATE(), 1, GETDATE()),

(129, 'Trading Plan', 'View', 103006, NULL, 'View right for Trading Plan', 105001, 1, GETDATE(), 1, GETDATE()),
(130, 'Trading Plan', 'Create', 103006, NULL, 'Create right for Trading Plan', 105001, 1, GETDATE(), 1, GETDATE()),
(131, 'Trading Plan', 'Edit', 103006, NULL, 'Edit right for Trading Plan', 105001, 1, GETDATE(), 1, GETDATE()),
(132, 'Trading Plan', 'Delete', 103006, NULL, 'Delete right for Trading Plan', 105001, 1, GETDATE(), 1, GETDATE()),


(133, 'Edit Permissions for Insider', 'Role', 103002, NULL, 'Edit permission for Role', 105001, 1, GETDATE(), 1, GETDATE()),

(134, 'Trading Window - Other', 'View', 103006, NULL, 'View right for Trading Window - Other', 105001, 1, GETDATE(), 1, GETDATE()),
(135, 'Trading Window - Other', 'Create', 103006, NULL, 'Create right for Trading Window - Other', 105001, 1, GETDATE(), 1, GETDATE()),
(136, 'Trading Window - Other', 'Edit', 103006, NULL, 'Edit right for Trading Window - Other', 105001, 1, GETDATE(), 1, GETDATE()),
(137, 'Trading Window - Other', 'Delete', 103006, NULL, 'Delete right for Trading Window - Other', 105001, 1, GETDATE(), 1, GETDATE()),

(138, 'Policy Document Status', 'List', 103006, NULL, 'List right for Policy Document under Transaction', 105001, 1, GETDATE(), 1, GETDATE()),
(139, 'Policy Document Status', 'View', 103006, NULL, 'View right for Policy Document under Transaction', 105001, 1, GETDATE(), 1, GETDATE()),

(140, 'Policy Document', 'List', 103006, NULL, 'View right for Policy Document', 105001, 1, GETDATE(), 1, GETDATE()),

(141, 'Edit Permissions for Insider', 'Category (Non-Employee)', 103002, NULL, 'Edit permission for Category Text', 105001, 1, GETDATE(), 1, GETDATE()),
(142, 'Edit Permissions for Insider', 'Sub-Category (Non-Employee)', 103002, NULL, 'Edit permission for Sub-Category Text', 105001, 1, GETDATE(), 1, GETDATE()),
(143, 'Edit Permissions for Insider', 'Grade (Non-Employee)', 103002, NULL, 'Edit permission for Grade Text', 105001, 1, GETDATE(), 1, GETDATE()),
(144, 'Edit Permissions for Insider', 'Designation (Non-Employee)', 103002, NULL, 'Edit permission for Designation Text', 105001, 1, GETDATE(), 1, GETDATE()),
(145, 'Edit Permissions for Insider', 'Sub-Designation (Non-Employee)', 103002, NULL, 'Edit permission for Sub-Designation Text', 105001, 1, GETDATE(), 1, GETDATE()),
(146, 'Edit Permissions for Insider', 'Department (Non-Employee)', 103002, NULL, 'Edit permission for Department Text', 105001, 1, GETDATE(), 1, GETDATE()),

(147, 'Mandatory Fields for Insider', 'Category (Non-Employee)', 103002, NULL, 'Mandatory Field - Category (Non-Employee)', 105001, 1, GETDATE(), 1, GETDATE()),
(148, 'Mandatory Fields for Insider', 'Sub-Category (Non-Employee)', 103002, NULL, 'Mandatory Field - Sub-Category (Non-Employee)', 105001, 1, GETDATE(), 1, GETDATE()),
(149, 'Mandatory Fields for Insider', 'Grade (Non-Employee)', 103002, NULL, 'Mandatory Field - Grade (Non-Employee)', 105001, 1, GETDATE(), 1, GETDATE()),
(150, 'Mandatory Fields for Insider', 'Designation (Non-Employee)', 103002, NULL, 'Mandatory Field - Designation (Non-Employee)', 105001, 1, GETDATE(), 1, GETDATE()),
(151, 'Mandatory Fields for Insider', 'Sub-Designation (Non-Employee)', 103002, NULL, 'Mandatory Field - Sub-Designation (Non-Employee)', 105001, 1, GETDATE(), 1, GETDATE()),
(152, 'Mandatory Fields for Insider', 'Department (Non-Employee)', 103002, NULL, 'Mandatory Field - Department (Non-Employee)', 105001, 1, GETDATE(), 1, GETDATE()),


(153, 'Disclosure Details for Insider', 'Preclearance Request', 103008, NULL, 'Disclosure Details for Insider - Preclearance Request', 105001, 1, GETDATE(), 1, GETDATE()),
(154, 'Disclosure Details for Insider', 'Policy Document List', 103008, NULL, 'Disclosure Details for Insider - Policy Document List (Insider)', 105001, 1, GETDATE(), 1, GETDATE()),
(155, 'Disclosure Details for Insider', 'Initial Disclosure', 103008, NULL, 'Disclosure Details for Insider - Initial Disclosure', 105001, 1, GETDATE(), 1, GETDATE()),
(156, 'Disclosure Details for Insider', 'Initial Disclosure Letter Submission', 103008, NULL, 'Disclosure Details for Insider -  Initial Disclosure Letter Submission', 105001, 1, GETDATE(), 1, GETDATE()),
(157, 'Disclosure Details for Insider', 'Continuous Disclosure', 103008, NULL, 'Disclosure Details for Insider -  Continuous Disclosure', 105001, 1, GETDATE(), 1, GETDATE()),
(158, 'Disclosure Details for Insider', 'Continuous Disclosure Letter Submission', 103008, NULL, 'Disclosure Details for Insider -  Continuous Disclosure Letter Submission', 105001, 1, GETDATE(), 1, GETDATE()),
(159, 'Disclosure Details for Insider', 'Period End Disclosure', 103008, NULL, 'Disclosure Details for Insider -  Period End Disclosure', 105001, 1, GETDATE(), 1, GETDATE()),
(160, 'Disclosure Details for Insider', 'Period End Disclosure Letter Submission', 103008, NULL, 'Disclosure Details for Insider -  Period End Disclosure Letter Submission', 105001, 1, GETDATE(), 1, GETDATE()),

(161, 'Edit Permissions for Insider', 'CIN', 103002, NULL, 'Edit permission for CIN', 105001, 1, GETDATE(), 1, GETDATE()),
(162, 'Edit Permissions for Insider', 'DIN', 103002, NULL, 'Edit permission for DIN', 105001, 1, GETDATE(), 1, GETDATE()),
(163, 'Mandatory Fields for Insider', 'CIN', 103002, NULL, 'Mandatory Field - CIN', 105001, 1, GETDATE(), 1, GETDATE()),
(164, 'Mandatory Fields for Insider', 'DIN', 103002, NULL, 'Mandatory Field - DIN', 105001, 1, GETDATE(), 1, GETDATE()),

(165, 'Disclosure Details for CO', 'Initial Disclosure', 103008, NULL, 'Disclosure Details for CO - Initial Disclosure Submission', 105001, 1, GETDATE(), 1, GETDATE()),
(166, 'Disclosure Details for CO', 'Initial Disclosure Letter', 103008, NULL, 'Disclosure Details for CO - Initial Disclosure Letter Submission', 105001, 1, GETDATE(), 1, GETDATE()),
(167, 'Disclosure Details for CO', 'Continuous Disclosure', 103008, NULL, 'Disclosure Details for CO - Continuous Disclosure Submission', 105001, 1, GETDATE(), 1, GETDATE()),
(168, 'Disclosure Details for CO', 'Continuous Disclosure Letter', 103008, NULL, 'Disclosure Details for CO - Continuous Disclosure Letter Submission', 105001, 1, GETDATE(), 1, GETDATE()),
(169, 'Disclosure Details for CO', 'Period End Disclosure', 103008, NULL, 'Disclosure Details for CO - Period End Disclosure Submission', 105001, 1, GETDATE(), 1, GETDATE()),
(170, 'Disclosure Details for CO', 'Period End Disclosure Letter', 103008, NULL, 'Disclosure Details for CO - Period End Disclosure Letter Submission', 105001, 1, GETDATE(), 1, GETDATE()),

(171, 'Disclosure Details for CO', 'Initial Disclosure - Submission to Stock Exchange', 103008, NULL, 'Disclosure Details for CO - Initial Disclosure - Submission to Stock Exchange', 105001, 1, GETDATE(), 1, GETDATE()),
(172, 'Disclosure Details for CO', 'Continuous Disclosure - Submission to Stock Exchange', 103008, NULL, 'Disclosure Details for CO - Continuous Disclosure - Submission to Stock Exchange', 105001, 1, GETDATE(), 1, GETDATE()),
(173, 'Disclosure Details for CO', 'Period End Disclosure - Submission to Stock Exchange', 103008, NULL, 'Disclosure Details for CO -  Period End Disclosure - Submission to Stock Exchange', 105001, 1, GETDATE(), 1, GETDATE()),

(174, 'Template', 'List', 103012, NULL, 'List right for Template', 105001, 1, GETDATE(), 1, GETDATE()),
(175, 'Template', 'View', 103012, NULL, 'View right for Template', 105001, 1, GETDATE(), 1, GETDATE()),
(176, 'Template', 'Add', 103012, NULL, 'Add right for Template', 105001, 1, GETDATE(), 1, GETDATE()),
(177, 'Template', 'Edit', 103012, NULL, 'Edit right for Template', 105001, 1, GETDATE(), 1, GETDATE()),
(178, 'Template', 'Delete', 103012, NULL, 'Delete right for Template', 105001, 1, GETDATE(), 1, GETDATE()),

-- Communication Rules - List / View / Add / Edit / Delete - Only for CO
(179, 'Communication Rules', 'List', 103010, NULL, 'List right for Communication Rules', 105001, 1, GETDATE(), 1, GETDATE()),
(180, 'Communication Rules', 'View', 103010, NULL, 'View right for Communication Rules', 105001, 1, GETDATE(), 1, GETDATE()),
(181, 'Communication Rules', 'Add', 103010, NULL, 'Add right for Communication Rules', 105001, 1, GETDATE(), 1, GETDATE()),
(182, 'Communication Rules', 'Edit', 103010, NULL, 'Edit right for Communication Rules', 105001, 1, GETDATE(), 1, GETDATE()),
(183, 'Communication Rules', 'Delete', 103010, NULL, 'Delete right for Communication Rules', 105001, 1, GETDATE(), 1, GETDATE()),

-- Notification - List / Details
(184, 'Notification', 'List', 103010, NULL, 'List right for Notification', 105001, 1, GETDATE(), 1, GETDATE()),
(185, 'Notification', 'View', 103010, NULL, 'View right for Notification', 105001, 1, GETDATE(), 1, GETDATE()),


-- Notification - List / Details
(186, 'Report', 'Initial Disclousre Report', 103011, NULL, 'View right for Initial Disclousre Report', 105001, 1, GETDATE(), 1, GETDATE()),
(187, 'Report', 'Continuous Disclousre Report', 103011, NULL, 'View right for Continuous Disclousre Report', 105001, 1, GETDATE(), 1, GETDATE()),
(188, 'Report', 'Period End Disclousre Report', 103011, NULL, 'View right for Period End Disclousre Report', 105001, 1, GETDATE(), 1, GETDATE()),
(189, 'Report', 'Preclearance Report', 103011, NULL, 'View right for Preclearance Disclousre Report', 105001, 1, GETDATE(), 1, GETDATE()),

-- Communication - Personalize
(190, 'Communication Rules', 'Personalize', 103010, NULL, 'Personalize right for communication Rules for Insider', 105001, 1, GETDATE(), 1, GETDATE()),

(191, 'DashBoard', 'DashBoard', 103002, NULL, 'Dashboard for Insider', 105001, 1, GETDATE(), 1, GETDATE()),

--View My Details for CO User
(192, 'CO User Details', 'View Details', 103001, NULL, 'View Details right for the CO user', 105001, 1, GETDATE(), 1, GETDATE()),

-- Sent by Raghvendra on 25-Aug-2015
(193 ,'CO FAQ List' ,'List' ,103012 ,NULL ,'View FAQ List for CO user' ,105001, 1,GETDATE(),1 ,GETDATE()),
(194 ,'Insider FAQ List' ,'List' ,103012 ,NULL ,'View FAQ List for Insider user' ,105001, 1, GETDATE(),1 ,GETDATE()),

--Sent by Raghvendra on 01-Oct-2015
(196, 'Report', 'Defaulter Report', 103011, NULL, 'View right for Defaulter Report', 105001, 1, GETDATE(), 1, GETDATE()),

/* Received from KPCS for code merging on 13-Oct-2015 */
(197,'Restricted List','View','103301',NULL,'View right for Restricted List master',105001, 1, GETDATE(),1,GETDATE()),
(198,'Restricted List','Create','103301',NULL,'Create right for Restricted List master',105001, 1,GETDATE(),1,GETDATE() ),
(199,'Restricted List','Edit','103301',NULL,'Edit right for Restricted List master',105001, 1,GETDATE(),1,GETDATE()),
(200,'Restricted List','Delete','103301',NULL,'Delete right for Restricted List master',105001, 1,GETDATE(),1,GETDATE()),
(201,'Report','View','103301',NULL,'View right for Restricted List Report',105001,1,GETDATE(),1,GETDATE()),
(202,'Communication Rules','View','103301',NULL,'View right for Communication Rules',105001,1,GETDATE(),1,GETDATE()),
(203,'Communication Rules','Create','103301',NULL,'Create right for Communication Rules',105001,1,GETDATE(),1,GETDATE() ),
(204,'Communication Rules','Edit','103301',NULL,'Edit right for Communication Rules',105001,1,GETDATE(),1,GETDATE()),
(205,'Communication Rules','Delete','103301',NULL,'Delete right for Communication Rules',105001,1,GETDATE(),1,GETDATE()),
(206,'Communication Rules','Personalize','103301',NULL,'Personalize right for Communication Rules',105001,1,GETDATE(),1,GETDATE()),
(207,'Communication Rules','List','103301',NULL,'List right for Communication Rules',105001,1,GETDATE(),1,GETDATE()),
(208,'Notification','View','103301',NULL,'View right for Notification',105001,1,GETDATE(),1,GETDATE()),
(209,'Notification','List','103301',NULL,'List right for Notification',105001,1,GETDATE(),1,GETDATE()),

(210,'Restricted List','Search','103301',NULL,'View right for Restricted List Search',105001,1,GETDATE(),1,GETDATE()),
(211,'Report','Restricted List Logs','103301',NULL,'View right for Restricted List Logs Report',105001,1,GETDATE(),1,GETDATE()),

/*Script received from KPCS while code merge on 18-Dec */
(212,'R&T Report','View','103011',NULL,'View right for R&T Report',105001,1,GETDATE(),1,GETDATE()),
(213,'Report','View Error Log Report','103011',NULL,'View right for View Error Log Report',105001,1,GETDATE(),1,GETDATE()),

/* CO Role to approve & reject Pre-clearance */
(214,'Disclosure Details for CO','Pre-clearance Approve/Reject',103008,NULL,'Disclosure Details for CO - Pre-clearance Approve/Reject',105001,1,GETDATE(),1,GETDATE())

UPDATE usr_Activity SET ScreenName = 'Policy Document Status', ModuleCodeID = 103006 WHERE ActivityID IN (138, 139)
UPDATE usr_Activity SET ModuleCodeID = 103011 WHERE ActivityID BETWEEN 186 AND 189



UPDATE usr_Activity SET ActivityName = 'Category Text' WHERE ActivityID IN (141, 147)
UPDATE usr_Activity SET ActivityName = 'SubCategory Text' WHERE ActivityID IN (142, 148)
UPDATE usr_Activity SET ActivityName = 'Grade Text' WHERE ActivityID IN (143, 149)
UPDATE usr_Activity SET ActivityName = 'Designation Text' WHERE ActivityID IN (144, 150)
UPDATE usr_Activity SET ActivityName = 'SubDesignation Text' WHERE ActivityID IN (145, 151)
UPDATE usr_Activity SET ActivityName = 'Department Text' WHERE ActivityID IN (146, 152)

-- Script received from Raghvendra on 19-Feb-2016
-- Update the screen code ID for the Mass Upload activity
UPDATE usr_Activity SET ModuleCodeID = 103013, ScreenName='Mass Upload',ActivityName='Perform Mass Upload',Description='Rights to perform Mass Upload' WHERE ActivityId = 9

