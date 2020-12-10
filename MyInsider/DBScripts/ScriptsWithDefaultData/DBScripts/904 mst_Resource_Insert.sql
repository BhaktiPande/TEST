/* Prefix to be used for modules
usr : CR user (103001)
usr : Employee / Insider User (103002)
com : Common (103003)
mst : Master (103004)
cmp : Company Master (103005)
rul : Rules (103006)
usr : Roles (103007)
tra : Transaction data (103008)
dis : Disclosures (103009)
cmu : Communication Module (103010)
rpt : Reports (103011)
*/

/* Prefix to be used for categories
msg : Error Message (104001
lbl : Label (104002)
grd : Grid (104003)
btn : Button (104004)
ttp : Tooltip (104005)
ttl : Title (104006)
*/

/*
Range to be used for error codes
Common:			10001 - 10999
User creation:	11001 - 11999
Roles Creation:	12001 - 12999
Company creation: 13001 - 13999
Master List :	 14001 - 14999
Rules :	15000 - 15999
Transaction data : 16000 - 16999
Disclosure status data : 17000 - 17999
Communication Module : 18000 - 18999
Reprots module : 19000 - 19999
*/

/* First error code for each module should start at 10001 */

INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(10000,'com_msg_10000','Error occurred while fetching menus applicable to the user.','Error occurred while fetching menus applicable to the user.','en-US',103003,104001,122001,1 , GETDATE()),
(10001,'com_msg_10001','Error occurred while fetching activities applicable to the user.','Error occurred while fetching activities applicable to the user.','en-US',103003,104001,122001,1 , GETDATE()),
(10002, 'mst_grd_10002', 'Code', 'Code', 'en-Us', 103004, 104003, 122013, 1 , GETDATE()),
(10003, 'mst_grd_10003', 'Display Code', 'Display Code', 'en-Us', 103004, 104003, 122013, 1 , GETDATE()),
(10004, 'mst_grd_10004', 'Code Group', 'Code Group', 'en-Us', 103004, 104003, 122013, 1 , GETDATE()),
(10005, 'mst_grd_10005', 'IS Active', 'IS Active', 'en-Us', 103004, 104003, 122013, 1 , GETDATE()),
(10006, 'mst_grd_10006', 'Description', 'Description', 'en-Us', 103004, 104003, 122013, 1 , GETDATE()),
(10007, 'mst_msg_10007', 'Error occurred while fetching list of codes.', 'Error occurred while fetching list of codes.', 'en-US', 103004, 104001, 122013, 1 , GETDATE()),
(10008, 'mst_msg_10008', 'Error occurred while saving code.', 'Error occurred while saving code.', 'en-US', 103004, 104001, 122014, 1 , GETDATE()),
(10009, 'mst_msg_10009', 'Code does not exist.', 'Code does not exist.', 'en-US', 103004, 104001, 122014, 1 , GETDATE()),
(10010, 'mst_msg_10010', 'Code name already exists.', 'Code name already exists.', 'en-US', 103004, 104001, 122014, 1 , GETDATE()),
(10011, 'mst_msg_10011', 'Cannot delete the code, as some dependent information exists on it.', 'Cannot delete the code, as some dependent information exists on it.', 'en-US', 103004, 104001, 122014, 1 , GETDATE()),
(10012, 'mst_msg_10012', 'Error occurred while deleting code.', 'Error occurred while deleting code.', 'en-US', 103004, 104001, 122014, 1 , GETDATE()),
(10013, 'mst_msg_10013', 'Error occurred while fetching code details.', 'Error occurred while fetching code details.', 'en-US', 103004, 104001, 122014, 1 , GETDATE()),
(10014, 'mst_msg_10014', 'Error occurred while fetching resource list.', 'Error occurred while fetching resource list.', 'en-US', 103004, 104001, 122031, 1 , GETDATE()),
(10015, 'mst_grd_10015', 'Module', 'Module', 'en-Us', 103004, 104003, 122031, 1 , GETDATE()),
(10016, 'mst_grd_10016', 'Category', 'Category', 'en-Us', 103004, 104003, 122031, 1 , GETDATE()),
(10017, 'mst_grd_10017', 'Screen', 'Screen', 'en-Us', 103004, 104003, 122031, 1 , GETDATE()),
(10018, 'mst_grd_10018', 'Label', 'Label', 'en-Us', 103004, 104003, 122031, 1 , GETDATE()),
(10019, 'mst_lbl_10019', 'Code', 'Code Name', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10020, 'mst_lbl_10020', 'Display Code', 'Display Code', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10021, 'mst_lbl_10021', 'Code Group', 'Code Group', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10022, 'mst_lbl_10022', 'Is Active', 'Is Active', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10023, 'mst_lbl_10023', 'Is Visible', 'Is Visible', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10024, 'mst_lbl_10024', 'Description', 'Description', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10025, 'mst_msg_10025', 'Error occurred while fetching resource details.', 'Error occurred while fetching resource details.', 'en-US', 103004, 104001, 122032, 1 , GETDATE()),
(10026, 'mst_msg_10026', 'Resource does not exist.', 'Resource does not exist.', 'en-US', 103004, 104001, 122032, 1 , GETDATE()),
(10027, 'mst_msg_10027', 'Error occurred while saving resource details.', 'Error occurred while fetching resource details.', 'en-US', 103004, 104001, 122032, 1 , GETDATE()),
(10028, 'mst_grd_10028', 'Original Label', 'Original Label', 'en-Us', 103004, 104003, 122031, 1 , GETDATE()),
(10029, 'mst_lbl_10029', 'Resource Key', 'Resource Key', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10030, 'mst_lbl_10030', 'Label', 'Label', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10031, 'mst_lbl_10031', 'Resource Culture', 'Resource Culture', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10032, 'mst_lbl_10032', 'Module', 'Module', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10033, 'mst_lbl_10033', 'Category', 'Category', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10034, 'mst_lbl_10034', 'Screen', 'Screen', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10035, 'mst_lbl_10035', 'Original Resource Value', 'Original Resource Value', 'en-US', 103004, 104002, 122014, 1 , GETDATE()),
(10036, 'mst_btn_10036', 'Add Code', 'Add Code', 'en-US', 103004, 104004, 122014, 1 , GETDATE()),
(10037, 'mst_ttl_10037', 'Resource List', 'Resource List', 'en-US', 103004, 104006, 122031, 1 , GETDATE()),
(10038, 'mst_ttl_10038', 'Resource Details', 'Resource Details', 'en-US', 103004, 104006, 122032, 1 , GETDATE()),
(10039, 'mst_lbl_10039', 'Grid Type', 'Grid Type', 'en-US', 103004, 104002, 122032, 1 , GETDATE()),
(10040, 'mst_lbl_10040', 'Is Visible', 'Is Visible', 'en-US', 103004, 104002, 122032, 1 , GETDATE()),
(10041, 'mst_lbl_10041', 'Sequence Number', 'Sequence Number', 'en-US', 103004, 104002, 122032, 1 , GETDATE()),
(10042, 'mst_msg_10042', 'Enter valid Sequence Number.', 'Enter valid Sequence Number.', 'en-US', 103004, 104001, 122032, 1 , GETDATE()),
(10043, 'mst_ttl_10043', 'Master Codes List', 'Master Codes List', 'en-US', 103004, 104006, 122014, 1 , GETDATE()),
(10044, 'mst_ttl_10044', 'Master Code Details', 'Master Code Details', 'en-US', 103004, 104006, 122014, 1 , GETDATE()),
(10045, 'mst_lbl_10045', 'Column Width', 'Column Width', 'en-US', 103004, 104002, 122032, 1 , GETDATE()),
(10046, 'mst_lbl_10046', 'Column Alignment', 'Column Alignment', 'en-US', 103004, 104002, 122032, 1 , GETDATE()),
(10047, 'mst_msg_10047', 'Saved Successfully', 'saved Successfully', 'en-US', 103004, 104001, 122014, 1 , GETDATE()),
(10048, 'mst_msg_10048', 'Code deleted Successfully', 'Code deleted Successfully', 'en-US', 103004, 104001, 122014, 1 , GETDATE()),
(10049, 'mst_msg_10049', 'Resource Updated Successfully.', 'Resource Updated Successfully.', 'en-US', 103004, 104001, 122032, 1 , GETDATE()),
(10050, 'mst_lbl_10050', 'Parent Code', 'Parent Code', 'en-US', 103004, 104002, 122032, 1 , GETDATE()),
(10051, 'mst_msg_10051', 'Display code name already exists.', 'Display code name already exists.', 'en-US', 103004, 104001, 122014, 1 , GETDATE()),
(10052, 'mst_msg_10052', 'Cannot set code to invisible because code is already in use', 'Cannot set code to invisible because code is already in use', 'en-US', 103004, 104001, 122014, 1, GETDATE())

INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(11001, 'usr_lbl_11001', 'Email Address', 'Email Address', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11002, 'usr_lbl_11002', 'First Name', 'First Name', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11003, 'usr_lbl_11003', 'Middle Name', 'Middle Name', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11004, 'usr_lbl_11004', 'Last Name', 'Last Name', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11005, 'usr_lbl_11005', 'Mobile Number', 'Mobile Number', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11006, 'usr_lbl_11006', 'Company Name', 'Company Name', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11007, 'usr_lbl_11007', 'Address', 'Address', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11008, 'usr_lbl_11008', 'Address Line 2', 'Address Line 2', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11009, 'usr_lbl_11009', 'Country', 'Country', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11010, 'usr_lbl_11010', 'Status', 'Status', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11011, 'usr_lbl_11011', 'City', 'City', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11012, 'usr_lbl_11012', 'Pin Code', 'Pin Code', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11013, 'usr_lbl_11013', 'Contact Person', 'Contact Person', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11014, 'usr_lbl_11014', 'Date Of Joining', 'Date Of Joining', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11015, 'usr_lbl_11015', 'Date Of Becoming Insider', 'Date Of Becoming Insider', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11016, 'usr_lbl_11016', 'Phone Landline 1', 'Phone Landline 1', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11017, 'usr_lbl_11017', 'Phone Landline 2', 'Phone Landline 2', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11018, 'usr_lbl_11018', 'Website', 'Website', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11019, 'usr_lbl_11019', 'PAN Number', 'PAN', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11020, 'usr_lbl_11020', 'TAN Number', 'TAN', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11021, 'usr_lbl_11021', 'Description', 'Description', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11022, 'usr_lbl_11022', 'UPSI Access of Company', 'UPSI Access of Company', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11023, 'usr_lbl_11023', 'Relation With Employee', 'Relation With Employee', 'en-US', 103002, 104002, 122016, 1 , GETDATE()),
(11024, 'usr_msg_11024', 'Error occurred while saving details for employee.', 'Error occurred while saving details for employee.', 'en-US', 103002, 104001, 122004, 1 , GETDATE()),
(11025, 'usr_msg_11025', 'User does not exist.', 'User does not exist.', 'en-US', 103002, 104001, 122001, 1 , GETDATE()),
(11026, 'usr_msg_11026', 'Error occurred while saving login details for user.', 'Error occurred while saving login details for user.', 'en-US', 103002, 104001, 122001, 1 , GETDATE()),
(11027, 'usr_msg_11027', 'User Name exists for another user.', 'User Name exists for another user.', 'en-US', 103002, 104001, 122001, 1 , GETDATE()),
(11028, 'usr_msg_11028', 'Error occurred while saving login details for employee.', 'Error occurred while saving login details for employee.', 'en-US', 103002, 104001, 122004, 1 , GETDATE()),
(11029, 'usr_msg_11029', 'Error occurred while saving user details.', 'Error occurred while saving user details.', 'en-US', 103002, 104001, 122001, 1 , GETDATE()),
(11030, 'usr_msg_11030', 'Error occurred while saving CO user details.', 'Error occurred while saving CO user details.', 'en-US', 103001, 104001, 122002, 1 , GETDATE()),
(11031, 'usr_msg_11031', 'Error occurred while saving login details for CO User.', 'Error occurred while saving login details for CO User.', 'en-US', 103001, 104001, 122002, 1 , GETDATE()),
(11032, 'usr_msg_11032', 'Error occurred while saving Corporate user details.', 'Error occurred while saving Corporate user details.', 'en-US', 103001, 104001, 122004, 1 , GETDATE()),
(11033, 'usr_msg_11033', 'Error occurred while deleting user.', 'Error occurred while deleting user.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11034, 'usr_msg_11034', 'Error occurred while fetching user details.', 'Error occurred while fetching user details.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11035, 'usr_msg_11035', 'Error occurred while fetching authentication details.', 'Error occurred while fetching authentication details.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11036, 'usr_msg_11036', 'Error occurred while saving demat details.', 'Error occurred while saving demat details.', 'en-US', 103001, 104001, 122008, 1 , GETDATE()),
(11037, 'usr_msg_11037', 'Demat details do not exist', 'Demat details does not exist.', 'en-US', 103001, 104001, 122008, 1 , GETDATE()),
(11038, 'usr_msg_11038', 'Cannot save Demat details. To save Demat details, user should be of type employee or non-employee.', 'Cannot save Demat details. To save Demat details, user should be of type employee or non-employee.', 'en-US', 103001, 104001, 122008, 1 , GETDATE()),
(11039, 'usr_msg_11039', 'Error occurred while fetching list of users.', 'Error occurred while fetching list of users.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11040, 'usr_msg_11040', 'Error occurred while fetching list of demat accounts for user.', 'Error occurred while fetching list of demat accounts for user.', 'en-US', 103001, 104001, 122007, 1 , GETDATE()),
(11041, 'usr_msg_11041', 'Cannot save document details. To save Document details, user should be of type employee or non-employee.', 'Cannot save Document details. To save document details, user should be of type employee or non-employee.', 'en-US', 103001, 104001, 122010, 1 , GETDATE()),
(11042, 'usr_msg_11042', 'Error occurred while fetching list of documents for user.', 'Error occurred while fetching list of documents for user.', 'en-US', 103001, 104001, 122009, 1 , GETDATE()),
(11043, 'usr_msg_11043', 'Document details do not exist.', 'Document details does not exist.', 'en-US', 103001, 104001, 122010, 1 , GETDATE()),
(11044, 'usr_msg_11044', 'Error occurred while saving document details.', 'Error occurred while saving document details.', 'en-US', 103001, 104001, 122010, 1 , GETDATE()),
(11045, 'usr_msg_11045', 'Cannot delete the user, as some dependent information exists.', 'Cannot delete the user, as some dependent information exists.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11046, 'usr_msg_11046', 'Please enter a valid e-mail address.', 'Please enter a valid e-mail address.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11047, 'usr_lbl_11047', 'Login ID', 'User Name', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11048, 'usr_msg_11048', 'Entered mobile format is not valid.', 'Entered mobile format is not valid.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11049, 'usr_msg_11049', 'Select Company.', 'Select Company.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11050, 'usr_lbl_11050', 'Category', 'Category', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11051, 'usr_lbl_11051', 'SubCategory', 'SubCategory', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11052, 'usr_lbl_11052', 'Grade', 'Grade', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11053, 'usr_lbl_11053', 'Designation', 'Designation', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11054, 'usr_lbl_11054', 'Location', 'Location', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11055, 'usr_lbl_11055', 'Department', 'Department', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11056, 'usr_lbl_11056', 'State', 'State', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11057, 'usr_lbl_11057', 'Password', 'Password', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11058, 'usr_lbl_11058', 'Employee ID', 'User ID', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11059, 'usr_msg_11059', 'Error occurred while deleting Demat details', 'Error occurred while deleting DMAT details', 'en-US', 103001, 104001, 122008, 1 , GETDATE()),
(11060, 'usr_msg_11060', 'Demat information not found', 'DMAT info not found', 'en-US', 103001, 104001, 122008, 1 , GETDATE()),
(11061, 'usr_msg_11061', 'Cannot delete these Demat details, as some dependent information is linked to it. ', 'Cannot delete this DMAT details, as some dependent information is dependent on this it.', 'en-US', 103001, 104001, 122008, 1 , GETDATE()),
(11062, 'usr_msg_11062', 'Error occurred while deleting document details', 'Error occurred while deleting document details', 'en-US', 103001, 104001, 122010, 1 , GETDATE()),
(11063, 'usr_msg_11063', 'Document information not found', 'Document info not found', 'en-US', 103001, 104001, 122010, 1 , GETDATE()),
(11064, 'usr_msg_11064', 'Cannot delete this document details, as some dependent information is dependent on this it.', 'Cannot delete this document details, as some dependent information is dependent on this it.', 'en-US', 103001, 104001, 122010, 1 , GETDATE()),
(11065, 'usr_grd_11065', 'Name', 'Name', 'en-US', 103001, 104003, 122001, 1 , GETDATE()),
(11066, 'usr_grd_11066', 'User ID', 'User ID', 'en-US', 103001, 104003, 122001, 1 , GETDATE()),
(11067, 'usr_grd_11067', 'User Name', 'User Name', 'en-US', 103001, 104003, 122001, 1 , GETDATE()),
(11068, 'usr_grd_11068', 'Company Name', 'Company Name', 'en-US', 103001, 104003, 122001, 1 , GETDATE()),
(11069, 'usr_grd_11069', 'Mobile No.', 'Mobile No.', 'en-US', 103001, 104003, 122001, 1 , GETDATE()),
(11070, 'usr_grd_11070', 'Email Id', 'Email Id', 'en-US', 103001, 104003, 122001, 1 , GETDATE()),
(11071, 'usr_grd_11071', 'Role', 'Role', 'en-US', 103001, 104003, 122001, 1 , GETDATE()),
(11072, 'usr_grd_11072', 'Status', 'Status', 'en-US', 103001, 104003, 122001, 1 , GETDATE()),
(11073, 'usr_grd_11073', 'Action', 'Action', 'en-US', 103001, 104003, 122001, 1 , GETDATE()),
(11074, 'usr_grd_11074', 'Name', 'Name', 'en-US', 103001, 104003, 122003, 1 , GETDATE()),
(11075, 'usr_grd_11075', 'Employee ID', 'Employee ID', 'en-US', 103001, 104003, 122003, 1 , GETDATE()),
(11076, 'usr_grd_11076', 'Company Name', 'Company Name', 'en-US', 103001, 104003, 122003, 1 , GETDATE()),
(11077, 'usr_grd_11077', 'Mobile No.', 'Mobile No.', 'en-US', 103001, 104003, 122003, 1 , GETDATE()),
(11078, 'usr_grd_11078', 'Email Id', 'Email Id', 'en-US', 103001, 104003, 122003, 1 , GETDATE()),
(11079, 'usr_grd_11079', 'Status', 'Status', 'en-US', 103001, 104003, 122003, 1 , GETDATE()),
(11080, 'usr_grd_11080', 'User Type', 'User Type', 'en-US', 103001, 104003, 122003, 1 , GETDATE()),
(11081, 'usr_grd_11081', 'Grade', 'Grade', 'en-US', 103001, 104003, 122003, 1 , GETDATE()),
(11082, 'usr_grd_11082', 'Designation', 'Designation', 'en-US', 103001, 104003, 122003, 1 , GETDATE()),
(11083, 'usr_grd_11083', 'Location', 'Location', 'en-US', 103001, 104003, 122003, 1 , GETDATE()),
(11084, 'usr_grd_11084', 'Department', 'Department', 'en-US', 103001, 104003, 122003, 1 , GETDATE()),
(11085, 'usr_grd_11085', 'Action', 'Action', 'en-US', 103001, 104003, 122001, 1 , GETDATE()),
(11086, 'usr_grd_11086', 'Name of Dependent', 'Name of Dependent', 'en-US', 103002, 104003, 122015, 1 , GETDATE()),
(11087, 'usr_grd_11087', 'Relation', 'Relation', 'en-US', 103002, 104003, 122015, 1 , GETDATE()),
(11088, 'usr_grd_11088', 'Address', 'Address', 'en-US', 103002, 104003, 122015, 1 , GETDATE()),
(11089, 'usr_grd_11089', 'Contact Number', 'Contact No.', 'en-US', 103002, 104003, 122015, 1 , GETDATE()),
(11090, 'usr_grd_11090', 'Email ID', 'Email ID', 'en-US', 103002, 104003, 122015, 1 , GETDATE()),
(11091, 'usr_grd_11091', 'PAN Number', 'PAN', 'en-US', 103002, 104003, 122015, 1 , GETDATE()),
(11092, 'usr_msg_11092', 'Error occurred while saving relative''s details.', 'Error occurred while saving relative''s details.', 'en-US', 103002, 104001, 122016, 1 , GETDATE()),
(11093, 'usr_msg_11093', 'Cannot add relative''s information for this user. User must be of type Employee / Non-employee, to add a relative''s data.', 'Cannot add relative''s information for this user. User must be of type Employee / Non-employee, to add a relative''s data.', 'en-US', 103002, 104001, 122016, 1 , GETDATE()),
(11094, 'usr_grd_11094', 'Demat A/c Number', 'Demat Ac/No.', 'en-US', 103002, 104003, 122007, 1 , GETDATE()),
(11095, 'usr_grd_11095', 'Depository Participant Name', 'DP Name', 'en-US', 103002, 104003, 122007, 1 , GETDATE()),
(11096, 'usr_grd_11096', 'Depository Participant ID', 'DP ID', 'en-US', 103002, 104003, 122007, 1 , GETDATE()),
(11097, 'usr_grd_11097', 'Trading Member ID', 'Trading Member Id', 'en-US', 103002, 104003, 122007, 1 , GETDATE()),
(11098, 'usr_grd_11098', 'Description', 'Description', 'en-US', 103002, 104003, 122007, 1 , GETDATE()),
(11099, 'usr_grd_11099', 'Name of Document', 'Name of Document', 'en-US', 103002, 104003, 122009, 1 , GETDATE()),
(11200, 'usr_grd_11200', 'Description', 'Description', 'en-US', 103002, 104003, 122009, 1 , GETDATE()),
(11201, 'usr_grd_11201', 'Path', 'Path', 'en-US', 103002, 104003, 122009, 1 , GETDATE()),
(11202, 'usr_msg_11202', 'Error occurred while saving Non-Employee user details.', 'Error occurred while saving Non-Employee user details.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11203, 'usr_msg_11203', 'Error occurred while fetching DMAT details.', 'Error occurred while fetching DMAT details.', 'en-US', 103001, 104001, 122008, 1 , GETDATE()),
(11204, 'usr_msg_11204', 'Error occurred while fetching document details.', 'Error occurred while fetching document details.', 'en-US', 103001, 104001, 122010, 1 , GETDATE()),
(11205, 'usr_lbl_11205', 'Demat A/c Number', 'Demat Ac/No.', 'en-US', 103002, 104002, 122008, 1 , GETDATE()),
(11206, 'usr_lbl_11206', 'Depository Participant Name', 'DP Name', 'en-US', 103002, 104002, 122008, 1 , GETDATE()),
(11207, 'usr_lbl_11207', 'Depository Participant ID', 'DP ID', 'en-US', 103002, 104002, 122008, 1 , GETDATE()),
(11208, 'usr_lbl_11208', 'Trading Member ID', 'Trading Member Id', 'en-US', 103002, 104002, 122008, 1 , GETDATE()),
(11209, 'usr_lbl_11209', 'Description', 'Description', 'en-US', 103002, 104002, 122008, 1 , GETDATE()),
(11210, 'usr_lbl_11210', 'Name of Document', 'Name of Document', 'en-US', 103002, 104002, 122010, 1 , GETDATE()),
(11211, 'usr_lbl_11211', 'Description', 'Description', 'en-US', 103002, 104002, 122001, 1 , GETDATE()),
(11212, 'usr_lbl_11212', 'Path', 'Path', 'en-US', 103002, 104002, 122001, 1 , GETDATE()),
(11213, 'usr_grd_11213', 'Account Holder Name', 'Account Holder Name', 'en-US', 103002, 104003, 122029, 1 , GETDATE()),
(11214, 'usr_grd_11214', 'PAN Number', 'PAN', 'en-US', 103002, 104003, 122029, 1 , GETDATE()),
(11215, 'usr_grd_11215', 'Relation with Primary A/C Holder', 'Relation with Primary A/C Holder', 'en-US', 103002, 104003, 122029, 1 , GETDATE()),
(11216, 'usr_msg_11216', 'Error occurred while fetching list of DMAT account holders.', 'Error occurred while fetching list of DMAT account holders.', 'en-US', 103001, 104001, 122029, 1 , GETDATE()),
(11217, 'usr_msg_11217', 'Enter Valid PAN Card Number.', 'Enter Valid PAN Card Number.', 'en-US', 103002, 104001, 122030, 1 , GETDATE()),
(11218, 'usr_msg_11218', 'Error occurred while deleting DMAT account holder''s details.', 'Error occurred while deleting DMAT account holder''s details.', 'en-US', 103002, 104001, 122030, 1 , GETDATE()),
(11219, 'usr_msg_11219', 'Cannot delete this DMAT account holder''s details, as some dependent information is dependent on it.', 'Cannot delete this DMAT account holder''s details, as some dependent information is dependent on it.', 'en-US', 103002, 104001, 122030, 1 , GETDATE()),
(11220, 'usr_msg_11220', 'DMAT account holder''s details does not exist.', 'DMAT account holder''s details does not exist.', 'en-US', 103002, 104001, 122030, 1 , GETDATE()),
(11221, 'usr_msg_11221', 'Error occurred while saving DMAT account holder''s details.', 'Error occurred while saving DMAT account holder''s details.', 'en-US', 103002, 104001, 122030, 1 , GETDATE()),
(11222, 'usr_msg_11222', 'Error occurred while fetching DMAT account holder''s details.', 'Error occurred while fetching DMAT account holder''s details.', 'en-US', 103002, 104001, 122030, 1 , GETDATE()),
(11223, 'usr_lbl_11223', 'Account Holder Name', 'Account Holder Name', 'en-US', 103002, 104002, 122030, 1 , GETDATE()),
(11224, 'usr_lbl_11224', 'PAN Number', 'PAN', 'en-US', 103002, 104002, 122030, 1 , GETDATE()),
(11225, 'usr_lbl_11225', 'Relation with Primary A/C Holder', 'Relation with Primary A/C Holder', 'en-US', 103002, 104002, 122030, 1 , GETDATE()),
(11226, 'usr_msg_11226', 'Error occurred while saving roles for user.', 'Error occurred while saving roles for user.', 'en-US', 103002, 104001, 122001, 1 , GETDATE()),
(11227, 'usr_msg_11227', 'Cannot save role(s) for this user, as the type of the user and type of user for which role is defined are different.', 'Cannot save role(s) for this user, as the type of the user and type of user for which role is defined are different.', 'en-US', 103002, 104001, 122001, 1 , GETDATE()),
(11228, 'usr_grd_11228', '', 'Empty text for grid column of checkbox', 'en-US', 103002, 104003, 122033, 1 , GETDATE()),
(11229, 'usr_grd_11229', 'Date of Separation', 'Date of Separation', 'en-US', 103002, 104003, 122033, 1 , GETDATE()),
(11230, 'usr_grd_11230', 'Reason for Separation', 'Reason for Separation', 'en-US', 103002, 104003, 122033, 1 , GETDATE()),
(11231, 'usr_msg_11231', 'Error occurred while saving user separation details.', 'Error occurred while saving user separation details.', 'en-US', 103002, 104001, 122001, 1 , GETDATE()),
(11232, 'usr_btn_11232', 'Add CO User', 'Add CO User', 'en-US', 103001, 104004, 122001, 1 , GETDATE()),
(11233, 'usr_ttl_11233', 'CO User List', 'CO User List', 'en-US', 103001, 104006, 122001, 1 , GETDATE()),
(11234, 'usr_ttl_11234', 'CO User Details', 'CO User Details', 'en-US', 103001, 104006, 122002, 1 , GETDATE()),
(11235, 'usr_ttl_11235', 'Insider List', 'Insider List', 'en-US', 103002, 104006, 122003, 1 , GETDATE()),
(11236, 'usr_btn_11236', 'Add Insider', 'Add Insider', 'en-US', 103002, 104004, 122003, 1 , GETDATE()),
(11237, 'usr_btn_11237', 'Update Separation', 'Update Separation', 'en-US', 103002, 104004, 122003, 1 , GETDATE()),
(11238, 'usr_ttl_11238', 'My Details', 'Employee Insider Details', 'en-US', 103002, 104006, 122004, 1 , GETDATE()),
(11239, 'usr_ttl_11239', 'Personal Details', 'Personal Details', 'en-US', 103002, 104006, 122004, 1 , GETDATE()),
(11240, 'usr_ttl_11240', 'Professional Details', 'Professional Details', 'en-US', 103002, 104006, 122004, 1 , GETDATE()),
(11241, 'usr_btn_11241', 'Add Demat Account', 'Add DMAT', 'en-US', 103002, 104004, 122007, 1 , GETDATE()),
(11242, 'usr_ttl_11242', 'Demat Details', 'DMAT Details', 'en-US', 103002, 104006, 122008, 1 , GETDATE()),
(11243, 'usr_btn_11243', 'Add Demat Account Holder', 'Add DMAT Account Holder', 'en-US', 103002, 104004, 122029, 1 , GETDATE()),
(11244, 'usr_btn_11244', 'Add Document', 'Add Document', 'en-US', 103002, 104004, 122009, 1 , GETDATE()),
(11245, 'usr_ttl_11245', 'Document Details', 'Document Details', 'en-US', 103002, 104006, 122010, 1 , GETDATE()),
(11246, 'usr_btn_11246', 'Edit Details', 'Edit Details', 'en-US', 103001, 104004, 122001, 1 , GETDATE()),
(11247, 'usr_btn_11247', 'Add Relative', 'Add Relative', 'en-US', 103002, 104004, 122015, 1 , GETDATE()),
(11248, 'usr_ttl_11248', 'Relative Details', 'Relative Details', 'en-US', 103002, 104006, 122016, 1 , GETDATE()),
(11249, 'usr_lbl_11249', 'Same address as Insider', 'Same address as Insider', 'en-US', 103002, 104002, 122016, 1 , GETDATE()),
(11250, 'usr_ttl_11250', 'Non-Employee Details', 'Non-Employee Details', 'en-US', 103002, 104006, 122004, 1 , GETDATE()),
(11251, 'usr_ttl_11251', 'Corporate Details', 'Corporate Details', 'en-US', 103002, 104006, 122004, 1 , GETDATE()),
(11252, 'usr_lbl_11252', 'Role', 'Role', 'en-US', 103002, 104002, 122001, 1 , GETDATE()),
(11253, 'usr_lbl_11253', 'Sub-Designation', 'Sub-Designation', 'en-US', 103002, 104002, 122001, 1 , GETDATE()),
(11254, 'usr_lbl_11254', 'Demat Account Type', 'DMAT Account Type', 'en-US', 103002, 104002, 122008, 1 , GETDATE()),
(11255, 'usr_msg_11255', 'Error occurred while saving user reset password information.', 'Error occurred while saving user reset password information.', 'en-US', 103002, 104001, 122001, 1 , GETDATE()),
(11256, 'usr_msg_11256', 'Email id provided does not match for the user.', 'Email id provided does not match for the user.', 'en-US', 103002, 104001, 122001, 1 , GETDATE()),
(11257, 'usr_msg_11257', 'The link provided is invalid.', 'The link provided is invalid.', 'en-US', 103002, 104001, 122001, 1 , GETDATE()),
(11258, 'usr_btn_11258', 'New Corporate User', 'New Corporate User', 'en-US', 103001, 104004, 122001, 1 , GETDATE()),
(11259, 'usr_lbl_11259', 'CIN', 'CIN', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11260, 'usr_lbl_11260', 'DIN', 'DIN', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11261, 'usr_msg_11261', 'User ID already exists.', 'User ID already exists.', 'en-US', 103002, 104001, 122001, 1 , GETDATE()),
(11262, 'usr_msg_11262', 'User Name already exists.', 'User Name already exists.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11263, 'usr_msg_11263', 'Date of becoming an Insider should be before today''s date', 'Date of Becoming Insider should be less than today''s date', 'en-US', 103002, 104001, 122004, 1 , GETDATE()),
(11264, 'usr_msg_11264', 'Corporate user records Saved Successfully', 'Corporate user records Saved Successfully', 'en-US', 103001, 104001, 122004, 1 , GETDATE()),
(11265, 'usr_msg_11265', 'Corporate user records deleted Successfully', 'Corporate user records deleted Successfully', 'en-US', 103001, 104001, 122004, 1 , GETDATE()),
(11266, 'usr_msg_11266', 'User :- $1 saved Successfully.', 'User :- $1 Save Successfully.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11267, 'usr_msg_11267', 'CO User deleted Successfully.', 'CO User deleted Successfully.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11268, 'usr_msg_11268', 'Email Address already exists.', 'Email Address already exists.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11269, 'usr_msg_11269', 'Mobile Number already exists.', 'Mobile Number already exists.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11270, 'usr_msg_11270', 'Changed password has been sent to your registered email address. Please check your inbox and proceed as per the instructions specified in the email.', 'Details regarding the changing of the password has been sent to your registered email address. Please check your inbox and proceed as per the instructions', 'en-US', 103001, 104001, 122064, 1 , GETDATE()),
(11271, 'usr_msg_11271', 'Password changed successfully.', 'Password changed successfully.', 'en-US', 103001, 104001, 122064, 1 , GETDATE()),
(11272, 'usr_msg_11272', 'Invalid details provided, please try again with correct details.', 'Invalid details provided, please try again with correct details.', 'en-US', 103001, 104001, 122064, 1 , GETDATE()),
(11273, 'usr_msg_11273', 'Cannot change the Password as User is Inactive.', 'Cannot change the Password as User is Inactive.', 'en-US', 103001, 104001, 122064, 1 , GETDATE()),
(11274, 'usr_msg_11274', 'Your account has been inactivated. Please contact the Administrator.', 'Your account has been inactivated. Please contact the Administrator.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11275, 'usr_ttl_11275', 'Update Separation', 'Update Separation', 'en-US', 103001, 104006, 122003, 1 , GETDATE()),
(11276, 'usr_msg_11276', 'Please assign Policy Document to the user', 'Please assign Policy Document to the user', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11277, 'usr_msg_11277', 'Please assign Trading Policy to the user', 'Please assign Trading Policy to the user', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(11278, 'usr_msg_11278', 'Old password added is not correct.', 'Old password added is not correct.', 'en-US', 103001, 104001, 122064, 1 , GETDATE()),
(11279, 'usr_ttl_11279', 'Change Password', 'Change Password', 'en-US', 103001, 104006, 122064, 1 , GETDATE()),
(11280, 'usr_msg_11280', 'User relative details saved successfully.', 'User relative details saved successfully.', 'en-US', 103002, 104001, 122016, 1 , GETDATE()),
(11281, 'usr_lbl_11281', 'Name', 'Name', 'en-US', 103001, 104002, 122001, 1 , GETDATE()),
(11282, 'usr_msg_11282', 'Forgot Password Email', 'Forgot Password Email', 'en-US', 103001, 104001, 122064, 1 , GETDATE()),
(11283, 'usr_msg_11283', 'Dear User,    You have requested for a forgot password request. If you have not done then ignore the email.    For changing the password click on following link $1 and follow the instructions provided.    If you cannot click on the provided link then copy paste the following URL in browser,  $2    Regards,  Admin', 'Dear User,    You have requested for a forgot password request. If you have not done then ignore the email.    For changing the password click on following link $1 and follow the instructions provided.    If you cannot click on the provided link then copy paste the following URL in browser,  $2    Regards,  Admin', 'en-US', 103001, 104001, 122064, 1 , GETDATE()),
(11284, 'usr_lbl_11284', 'DP Bank Name', 'DP Bank Name', 'en-US', 103002, 104002, 122008, 1 , GETDATE()),
(11285, 'usr_lbl_11285', 'Create New Role', 'Create New Role', 'en-US', 103002, 104002, 122001, 1 , GETDATE())


-- Script sent by Parag on 31-Jul-2015
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
-- Resources related to screen - Corporate User Details
('11286', 'usr_lbl_11286','Company', 'Company', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11287', 'usr_lbl_11287','User Name', 'User Name', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11288', 'usr_lbl_11288','Date Of Becoming Insider', 'Date Of Becoming Insider', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11289', 'usr_lbl_11289','CIN', 'CIN', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11290', 'usr_lbl_11290','Contact Person', 'Contact Person', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11291', 'usr_lbl_11291','Designation', 'Designation', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11292', 'usr_lbl_11292','Email Address', 'Email Address', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11293', 'usr_lbl_11293','Landline 1', 'Landline 1', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11294', 'usr_lbl_11294','Landline 2', 'Landline 2', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11295', 'usr_lbl_11295','Address', 'Address', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11296', 'usr_lbl_11296','Pin Code', 'Pin Code', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11297', 'usr_lbl_11297','Country', 'Country', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11298', 'usr_lbl_11298','Website', 'Website', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11299', 'usr_lbl_11299','TAN', 'TAN', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11300', 'usr_lbl_11300','PAN', 'PAN', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11301', 'usr_lbl_11301','Description', 'Description', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11302', 'usr_lbl_11302','Role', 'Role', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11303', 'usr_lbl_11303','Create New Role', 'Create New Role', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11304', 'usr_lbl_11304','Personal Details ', 'Personal Details ', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11305', 'usr_lbl_11305','Demat Details', 'Demat Details', 'en-US', 103002, 104002, 122065, 1, GETDATE()),
('11317', 'usr_btn_11317','Add DMAT', 'Add DMAT', 'en-US', 103002, 104004, 122065, 1, GETDATE()),
('11322', 'usr_msg_11322','Please enter a valid e-mail address.', 'Please enter a valid e-mail address.', 'en-US', 103002, 104001, 122065, 1, GETDATE()),
('11323', 'usr_msg_11323','Select Company.', 'Select Company.', 'en-US', 103002, 104001, 122065, 1, GETDATE()),
('11324', 'usr_msg_11324','Enter valid website name.', 'Enter valid website name.', 'en-US', 103002, 104001, 122065, 1, GETDATE()),
('11325', 'usr_msg_11325','Enter Valid PAN Card Number.', 'Enter Valid PAN Card Number.', 'en-US', 103002, 104001, 122065, 1, GETDATE()),

-- Resources related to screen - Corporate User DMAT Details
('11306', 'usr_lbl_11306','Demat Ac/No.', 'Demat Ac/No.', 'en-US', 103002, 104002, 122072, 1, GETDATE()),
('11307', 'usr_lbl_11307','DP Name', 'DP Name', 'en-US', 103002, 104002, 122072, 1, GETDATE()),
('11308', 'usr_lbl_11308','DP ID', 'DP ID', 'en-US', 103002, 104002, 122072, 1, GETDATE()),
('11309', 'usr_lbl_11309','Trading Member Id', 'Trading Member Id', 'en-US', 103002, 104002, 122072, 1, GETDATE()),
('11310', 'usr_lbl_11310','Description', 'Description', 'en-US', 103002, 104002, 122072, 1, GETDATE()),
('11311', 'usr_lbl_11311','DMAT Account Type', 'DMAT Account Type', 'en-US', 103002, 104002, 122072, 1, GETDATE()),
('11312', 'usr_lbl_11312','DP Bank Name', 'DP Bank Name', 'en-US', 103002, 104002, 122072, 1, GETDATE()),
('11313', 'usr_lbl_11313','Account Holder Name', 'Account Holder Name', 'en-US', 103002, 104002, 122072, 1, GETDATE()),
('11314', 'usr_lbl_11314','PAN', 'PAN', 'en-US', 103002, 104002, 122072, 1, GETDATE()),
('11315', 'usr_lbl_11315','Relation with Primary A/C Holder', 'Relation with Primary A/C Holder', 'en-US', 103002, 104002, 122072, 1, GETDATE()),
('11316', 'usr_msg_11316','DMAT Details Save Successfully', 'DMAT Details Save Successfully', 'en-US', 103002, 104001, 122072, 1, GETDATE()),
('11318', 'usr_ttl_11318','DMAT Details', 'DMAT Details', 'en-US', 103002, 104006, 122072, 1, GETDATE()),
('11319', 'usr_msg_11319','DMAT Joint Account Holder Details Save Successfully', 'DMAT Joint Account Holder Details Save Successfully', 'en-US', 103002, 104001, 122072, 1, GETDATE()),
('11320', 'usr_msg_11320','DMAT Details Deleted Successfully', 'DMAT Details Deleted Successfully', 'en-US', 103002, 104001, 122072, 1, GETDATE()),
('11321', 'usr_msg_11321','DMAT Joint Account Holder Details Deleted Successfully', 'DMAT Joint Account Holder Details Deleted Successfully', 'en-US', 103002, 104001, 122072, 1, GETDATE()),
('11326', 'usr_msg_11326','Enter Bank Name.', 'Enter Bank Name.', 'en-US', 103002, 104001, 122072, 1, GETDATE()),

-- Sent by Parag on 3-Aug-2015
('11327', 'usr_lbl_11327', 'Employee', 'Employee', 'en-US', 103002, 104002, 122003, 1, GETDATE()),
('11328', 'usr_lbl_11328', 'Corporate', 'Corporate', 'en-US', 103002, 104002, 122003, 1, GETDATE()),
('11329', 'usr_lbl_11329', 'Non-Employee', 'Non-Employee', 'en-US', 103002, 104002, 122003, 1, GETDATE()),

-- Insider Details Screen (New resources)
('11330', 'usr_lbl_11330', 'Email Address', 'Email Address', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11331', 'usr_lbl_11331', 'First Name', 'First Name', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11332', 'usr_lbl_11332', 'Middle Name', 'Middle Name', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11333', 'usr_lbl_11333', 'Last Name', 'Last Name', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11334', 'usr_lbl_11334', 'Mobile Number', 'Mobile Number', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11335', 'usr_lbl_11335', 'Company Name', 'Company Name', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11336', 'usr_lbl_11336', 'User Name', 'User Name', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11337', 'usr_lbl_11337', 'User ID', 'User ID', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11338', 'usr_lbl_11338', 'Role', 'Role', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11339', 'usr_lbl_11339', 'Create New Role', 'Create New Role', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11340', 'usr_msg_11340', 'Enter valid website name.', 'Enter valid website name.', 'en-US', 103002, 104001, 122004, 1, GETDATE()),
('11341', 'usr_msg_11341', 'Please enter a valid e-mail address.', 'Please enter a valid e-mail address.', 'en-US', 103002, 104001, 122004, 1, GETDATE()),
('11342', 'usr_msg_11342', 'Entered mobile format is not valid.', 'Entered mobile format is not valid.', 'en-US', 103002, 104001, 122004, 1, GETDATE()),
('11343', 'usr_msg_11343', 'Enter Valid PAN Card Number.', 'Enter Valid PAN Card Number.', 'en-US', 103002, 104001, 122004, 1, GETDATE()),
('11348', 'usr_lbl_11348', 'Demat Details', 'Demat Details', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11349', 'usr_lbl_11349', 'Documents', 'Documents', 'en-US', 103002, 104002, 122004, 1, GETDATE()),
('11350', 'usr_lbl_11350', 'User Relative Details', 'User Relative Details', 'en-US', 103002, 104002, 122004, 1, GETDATE()),

-- DMAT Details screeen (Success message)
('11344', 'usr_msg_11344', 'DMAT Details Save Successfully', 'DMAT Details Save Successfully', 'en-US', 103002, 104001, 122008, 1, GETDATE()),
('11345', 'usr_msg_11345', 'DMAT Joint Account Holder Details Save Successfully', 'DMAT Joint Account Holder Details Save Successfully', 'en-US', 103002, 104001, 122008, 1, GETDATE()),
('11346', 'usr_msg_11346', 'DMAT Details Deleted Successfully', 'DMAT Details Deleted Successfully', 'en-US', 103002, 104001, 122008, 1, GETDATE()),
('11347', 'usr_msg_11347', 'DMAT Joint Account Holder Details Deleted Successfully', 'DMAT Joint Account Holder Details Deleted Successfully', 'en-US', 103002, 104001, 122008, 1, GETDATE())

--Start : Sent by Parag on 5-Aug-2015
INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
-- Relative Details Screen (New resources)
('11351', 'usr_lbl_11351', 'Demat Details', 'Demat Details', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11352', 'usr_lbl_11352', 'Documents', 'Documents', 'en-US', 103002, 104002, 122016, 1, GETDATE()),

('11353', 'usr_lbl_11353', 'User ID', 'User ID', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11354', 'usr_lbl_11354', 'User Name', 'User Name', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11355', 'usr_lbl_11355', 'Company Name', 'Company Name', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11356', 'usr_lbl_11356', 'Category', 'Category', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11357', 'usr_lbl_11357', 'First Name', 'First Name', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11358', 'usr_lbl_11358', 'Middle Name', 'Middle Name', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11359', 'usr_lbl_11359', 'Last Name', 'Last Name', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11360', 'usr_lbl_11360', 'Address', 'Address', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11361', 'usr_lbl_11361', 'Pin Code', 'Pin Code', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11362', 'usr_lbl_11362', 'Country', 'Country', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11363', 'usr_lbl_11363', 'Email Address', 'Email Address', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11364', 'usr_lbl_11364', 'Mobile Number', 'Mobile Number', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11365', 'usr_lbl_11365', 'PAN', 'PAN', 'en-US', 103002, 104002, 122016, 1, GETDATE()),
('11366', 'usr_msg_11366', 'Relation with Employee field is required', 'Relation with Employee field is required', 'en-US', 103002, 104001, 122016, 1, GETDATE()),
('11367', 'usr_msg_11367', 'Relation Details Deleted Sucessfully', 'Relation Details Deleted Sucessfully', 'en-US', 103002, 104001, 122016, 1, GETDATE()),

-- Relative DMAT Details Screen (New resources)
('11368', 'usr_lbl_11368', 'Demat Ac/No.', 'Demat Ac/No.', 'en-US', 103002, 104002, 122073, 1, GETDATE()),
('11369', 'usr_lbl_11369', 'DP Name', 'DP Name', 'en-US', 103002, 104002, 122073, 1, GETDATE()),
('11370', 'usr_lbl_11370', 'DP Bank Name', 'DP Bank Name', 'en-US', 103002, 104002, 122073, 1, GETDATE()),
('11371', 'usr_lbl_11371', 'DP ID', 'DP ID', 'en-US', 103002, 104002, 122073, 1, GETDATE()),
('11372', 'usr_lbl_11372', 'Trading Member Id', 'Trading Member Id', 'en-US', 103002, 104002, 122073, 1, GETDATE()),
('11373', 'usr_lbl_11373', 'Description', 'Description', 'en-US', 103002, 104002, 122073, 1, GETDATE()),
('11374', 'usr_lbl_11374', 'DMAT Account Type', 'DMAT Account Type', 'en-US', 103002, 104002, 122073, 1, GETDATE()),

('11375', 'usr_lbl_11375','Account Holder Name', 'Account Holder Name', 'en-US', 103002, 104002, 122073, 1, GETDATE()),
('11376', 'usr_lbl_11376','PAN', 'PAN', 'en-US', 103002, 104002, 122073, 1, GETDATE()),
('11377', 'usr_lbl_11377','Relation with Primary A/C Holder', 'Relation with Primary A/C Holder', 'en-US', 103002, 104002, 122073, 1, GETDATE()),
('11378', 'usr_msg_11378','DMAT Details Save Successfully', 'DMAT Details Save Successfully', 'en-US', 103002, 104001, 122073, 1, GETDATE()),
('11379', 'usr_ttl_11379','DMAT Details', 'DMAT Details', 'en-US', 103002, 104006, 122073, 1, GETDATE()),
('11380', 'usr_msg_11380','DMAT Joint Account Holder Details Save Successfully', 'DMAT Joint Account Holder Details Save Successfully', 'en-US', 103002, 104001, 122073, 1, GETDATE()),
('11381', 'usr_msg_11381','DMAT Details Deleted Successfully', 'DMAT Details Deleted Successfully', 'en-US', 103002, 104001, 122073, 1, GETDATE()),
('11382', 'usr_msg_11382','DMAT Joint Account Holder Details Deleted Successfully', 'DMAT Joint Account Holder Details Deleted Successfully', 'en-US', 103002, 104001, 122073, 1, GETDATE()),
('11383', 'usr_msg_11383','Enter Bank Name.', 'Enter Bank Name.', 'en-US', 103002, 104001, 122073, 1, GETDATE()),
('11385', 'usr_msg_11385','Enter Valid PAN Card Number.', 'Enter Valid PAN Card Number.', 'en-US', 103002, 104001, 122073, 1, GETDATE()),

-- For corporate user (dmat screen resource)
('11384', 'usr_msg_11384','Enter Valid PAN Card Number.', 'Enter Valid PAN Card Number.', 'en-US', 103002, 104001, 122073, 1, GETDATE())
--End : Sent by Parag on 5-Aug-2015

	
-- Add Grid header for corporate and relative - DMAT details, Upload sepration list
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES	
	-- Corporate DMAT Details header
	('11386', 'usr_grd_11386','Demat Ac/No.', 'Demat Ac/No.', 'en-US', 103002, 104003, 122072, 1, GETDATE()),
	('11387', 'usr_grd_11387','DP Name', 'DP Name', 'en-US', 103002, 104003, 122072, 1, GETDATE()),
	('11388', 'usr_grd_11388','DP ID', 'DP ID', 'en-US', 103002, 104003, 122072, 1, GETDATE()),
	('11389', 'usr_grd_11389','Trading Member Id', 'Trading Member Id', 'en-US', 103002, 104003, 122072, 1, GETDATE()),
	('11390', 'usr_grd_11390','Description', 'Description', 'en-US', 103002, 104003, 122072, 1, GETDATE()),
	
	-- Corporate DMAT Holder Details header
	('11391', 'usr_grd_11391','Account Holder Name', 'Account Holder Name', 'en-US', 103002, 104003, 122072, 1, GETDATE()),
	('11392', 'usr_grd_11392','PAN', 'PAN', 'en-US', 103002, 104003, 122072, 1, GETDATE()),
	('11393', 'usr_grd_11393','Relation with Primary A/C Holder', 'Relation with Primary A/C Holder', 'en-US', 103002, 104003, 122072, 1, GETDATE()),
	
	-- Relative DMAT Details header
	('11394', 'usr_grd_11394','Demat Ac/No.', 'Demat Ac/No.', 'en-US', 103002, 104003, 122073, 1, GETDATE()),
	('11395', 'usr_grd_11395','DP Name', 'DP Name', 'en-US', 103002, 104003, 122073, 1, GETDATE()),
	('11396', 'usr_grd_11396','DP ID', 'DP ID', 'en-US', 103002, 104003, 122073, 1, GETDATE()),
	('11397', 'usr_grd_11397','Trading Member Id', 'Trading Member Id', 'en-US', 103002, 104003, 122073, 1, GETDATE()),
	('11398', 'usr_grd_11398','Description', 'Description', 'en-US', 103002, 104003, 122073, 1, GETDATE()),
	
	-- Relative DMAT Holder Details header
	('11399', 'usr_grd_11399','Account Holder Name', 'Account Holder Name', 'en-US', 103002, 104003, 122073, 1, GETDATE()),
	('11400', 'usr_grd_11400','PAN', 'PAN', 'en-US', 103002, 104003, 122073, 1, GETDATE()),
	('11401', 'usr_grd_11401','Relation with Primary A/C Holder', 'Relation with Primary A/C Holder', 'en-US', 103002, 104003, 122073, 1, GETDATE()),
	
	-- Upload Sepration list header
	('11402', 'usr_grd_11402','Name', 'Name', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
	('11403', 'usr_grd_11403','Employee ID', 'Employee ID', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
	('11404', 'usr_grd_11404','Company Name', 'Company Name', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
	('11405', 'usr_grd_11405','Mobile No.', 'Mobile No.', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
	('11406', 'usr_grd_11406','Email Id', 'Email Id', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
	('11407', 'usr_grd_11407','Status', 'Status', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
	('11408', 'usr_grd_11408','User Type', 'User Type', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
	('11409', 'usr_grd_11409','Grade', 'Grade', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
	('11410', 'usr_grd_11410','Designation', 'Designation', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
	('11411', 'usr_grd_11411','Location', 'Location', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
	('11412', 'usr_grd_11412','Department', 'Department', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
(11413, 'usr_msg_11413', 'Date of Joining should be less than today''s date', 'Date of Joining should be less than today''s date', 'en-US', 103002, 104001, 122004, 1, GETDATE()),
(11414, 'usr_msg_11414', 'Date of Becoming Insider should be less than today''s date', 'Date of Becoming Insider should be less than today''s date', 'en-US', 103002, 104001, 122004, 1, GETDATE()),
(11415, 'usr_msg_11415', 'Date of Becoming Insider should not be less than Date of Joining', 'Date of Becoming Insider should not be less than Date of Joining', 'en-US', 103002, 104001, 122004, 1, GETDATE()),

(11416, 'usr_msg_11416', 'Personal Details are already confirm.', 'Personal Details are already confirm.', 'en-US', 103002, 104001, 122004, 1, GETDATE()),
(11417, 'usr_msg_11417', 'Please confirm personal details.', 'Please confirm personal details.', 'en-US', 103002, 104001, 122004, 1, GETDATE()),
(11418, 'usr_btn_11418', 'Confirm Personal Details', 'Confirm Personal Details', 'en-US', 103002, 104004, 122004, 1, GETDATE()),
(11419, 'usr_btn_11419', 'Confirm Personal Details', 'Confirm Personal Details', 'en-US', 103002, 104004, 122065, 1, GETDATE()),
(11420, 'usr_msg_11420', 'Personal Details confirm successfully.', 'Personal Details confirm successfully.', 'en-US', 103002, 104001, 122004, 1, GETDATE()),
(11421, 'usr_msg_11421', 'Personal Details confirm successfully.', 'Personal Details confirm successfully.', 'en-US', 103002, 104001, 122065, 1, GETDATE()),
(11422, 'usr_msg_11422', 'CIN should contain characters and numbers only.', 'CIN should contain characters and numbers only.', 'en-US', 103002, 104001, 122065, 1, GETDATE()),
(11423, 'usr_msg_11423','The field CIN must be of length 21 characters only.', 'The field CIN must be of length 21 characters only.', 'en-US', 103002, 104001, 122065, 1, GETDATE()),

-- This script is add required resource keys, GridColumns, UserDefined Table Type for Upadate Separation. Gaurishankar 12-Oct-2015
(11424,'usr_grd_11424','No of days to be Active', 'No of days to be Active', 'en-US', 103002, 104003, 122033, 1, GETDATE()),
(11425,'usr_grd_11425','Date of Inactivation', 'Date of Inactivation', 'en-US', 103002, 104003, 122033, 1, GETDATE()),

(11426,'usr_lbl_11426', 'Name', 'User Full Name (Used for View User Details Page)', 'en-US', 103002, 104002,122004, 1, GETDATE()),

(11427, 'usr_lbl_11427', 'Category', 'Category', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11428, 'usr_lbl_11428', 'SubCategory', 'SubCategory', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11429, 'usr_lbl_11429', 'Sub-Designation', 'Sub-Designation', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11430, 'usr_lbl_11430', 'Designation', 'Designation', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11431, 'usr_lbl_11431', 'Grade', 'Grade', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),
(11432, 'usr_lbl_11432', 'Department', 'Department', 'en-US', 103002, 104002, 122004, 1 , GETDATE()),

/* Sent by GS 10-Dec-2015 */
('11433','usr_btn_11433','Re-Activate', 'Re-Activate', 'en-US', 103002, 104004, 122033, 1, GETDATE()),
('11434','usr_msg_11434','Are you sure you want to save User Separation details?', 'Are you sure you want to save User Separation details?', 'en-US', 103002, 104001, 122033, 1, GETDATE()),
('11435','usr_msg_11435','Are you sure you want to Re-Activate the User?', 'Are you sure you want to Re-Activate the User?', 'en-US', 103002, 104001, 122033, 1, GETDATE()),
/* Sent by Tushar on 10-Dec-2015 */
(11436,'usr_lbl_11436', 'Insider Status', 'Insider Status', 'en-US', 103002, 104002,122003, 1, GETDATE()),

/* Sent by GS 02-Mar-2016 */
(11437, 'usr_ttl_11437', 'Employee/Insider Details', 'Employee/Insider Details', 'en-US', 103002, 104006, 122004, 1, GETDATE())

/*
Script from Raghvendra on 25-Apr-2016 -- 
Resource for the tooltip to be shown on mouse over of the Tabs seen on Personal details confirmation screen when personal details are not confirmed.
*/
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(11438,'usr_ttl_11438','You are required to confirm the personal details by clicking on "Confirm Personla Details" to open these details.','You are required to confirm the personal details by clicking on "Confirm Personla Details" to open these details.','en-US',103002,104005,122004,1, GETDATE())

/*
Script received from Tushar on 2 May 2016 -- 
Change for:- Tool tip to be provided for informing user to click on "Action" button to view his Demat details
*/

INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(11439,'usr_ttl_11439','View DEMAT Details','View DEMAT Details','en-US',103002,104005,122015,1 , GETDATE())

/*
Script received from Raghvendra on 4-May-2016
Added the new resource message to be shown when user tries to add duplicate PAN number when creating/editing Employee/insider details
*/
INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
VALUES 
(11440,'usr_msg_11440','The entered PAN number is used by another user, change the PAN number and try again.','en-US','103013','104001','122076','The entered PAN number is used by another user, change the PAN number and try again.',1,GETDATE())




INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(12001, 'usr_msg_12001', 'Error occurred while fetching role details.', 'Error occurred while fetching role details.', 'en-US', 103007, 104001, 122006, 1 , GETDATE()),
(12002, 'usr_msg_12002', 'Role does not exists.', 'Role does not exists.', 'en-US', 103007, 104001, 122006, 1 , GETDATE()),
(12003, 'usr_msg_12003', 'Error occurred while fetching list of roles.', 'Error occurred while fetching list of roles.', 'en-US', 103007, 104001, 122005, 1 , GETDATE()),
(12004, 'usr_grd_12004', 'Role Name', 'Role Name', 'en-US', 103007, 104003, 122005, 1 , GETDATE()),
(12005, 'usr_grd_12005', 'Description', 'Description', 'en-US', 103007, 104003, 122005, 1 , GETDATE()),
(12006, 'usr_grd_12006', 'Status', 'Status', 'en-US', 103007, 104003, 122005, 1 , GETDATE()),
(12007, 'usr_grd_12007', 'User Type', 'User Type', 'en-US', 103007, 104003, 122005, 1 , GETDATE()),
(12008, 'usr_msg_12008', 'Error occurred while saving role.', 'Error occurred while saving role.', 'en-US', 103007, 104001, 122006, 1 , GETDATE()),
(12009, 'usr_msg_12009', 'Error occurred while deleting role.', 'Error occurred while deleting role.', 'en-US', 103007, 104001, 122006, 1 , GETDATE()),
(12010, 'usr_msg_12010', 'Error occurred while fetching list activities for a role.', 'Error occurred while fetching list activities for a role.', 'en-US', 103007, 104001, 122006, 1 , GETDATE()),
(12011, 'usr_msg_12011', 'Error occurred while fetching list of delegations.', 'Error occurred while fetching list of delegations.', 'en-US', 103007, 104001, 122027, 1 , GETDATE()),
(12012, 'usr_grd_12012', 'From User', 'From User', 'en-US', 103007, 104003, 122027, 1 , GETDATE()),
(12013, 'usr_grd_12013', 'To User', 'To User', 'en-US', 103007, 104003, 122027, 1 , GETDATE()),
(12014, 'usr_grd_12014', 'From Date', 'From Date', 'en-US', 103007, 104003, 122027, 1 , GETDATE()),
(12015, 'usr_grd_12015', 'To Date', 'To Date', 'en-US', 103007, 104003, 122027, 1 , GETDATE()),
(12016, 'usr_msg_12016', 'Error occurred while saving activities for the role.', 'Error occurred while saving activities for the role.', 'en-US', 103007, 104001, 122006, 1 , GETDATE()),
(12017, 'usr_msg_12017', 'Error occurred while saving delegations.', 'Error occurred while saving delegations.', 'en-US', 103007, 104001, 122028, 1 , GETDATE()),
(12018, 'usr_msg_12018', 'Delegation does not exist.', 'Delegation does not exist.', 'en-US', 103007, 104001, 122028, 1 , GETDATE()),
(12019, 'usr_msg_12019', 'Delegations from the delegating user to delegated user for overlapping/same period exists.', 'Delegations from the delegating user to delegated user for overlapping/same period exists.', 'en-US', 103007, 104001, 122028, 1 , GETDATE()),
(12020, 'usr_msg_12020', 'Delegation is already defined by the delegated user for the same/overlapping period.', 'Delegation is already defined by the delegated user for the same/overlapping period.', 'en-US', 103007, 104001, 122028, 1 , GETDATE()),
(12021, 'usr_msg_12021', 'Delegation is already defined to the delegating user for the same/overlapping period.', 'Delegation is already defined to the delegating user for the same/overlapping period.', 'en-US', 103007, 104001, 122028, 1 , GETDATE()),
(12022, 'usr_msg_12022', 'Error occurred while deleting delegation.', 'Error occurred while deleting delegation.', 'en-US', 103007, 104001, 122028, 1 , GETDATE()),
(12023, 'usr_msg_12023', 'Cannot delete or change delegation. To delete or change delegation record, Start date must be greater than today.', 'Cannot delete or change delegation. To delete or change delegation record, Start date must be greater than today.', 'en-US', 103007, 104001, 122028, 1 , GETDATE()),
(12024, 'usr_msg_12024', 'Error occurred while assigning activities to delegation.', 'Error occurred while assigning activities to delegation.', 'en-US', 103007, 104001, 122028, 1 , GETDATE()),
(12025, 'usr_grd_12025', 'Is Default', 'Is Default', 'en-US', 103007, 104003, 122005, 1 , GETDATE()),
(12026, 'usr_msg_12026', 'Cannot set IsDefault property to false, since no other role is default for the selected user type.', 'Cannot set IsDefault property to false, since no other role is default for the selected user type.', 'en-US', 103007, 104001, 122006, 1 , GETDATE()),
(12027, 'usr_msg_12027', 'Cannot delete this role, since this is default role for the selected user type. Please mark some other role as default to delete this role.', 'Cannot delete this role, since this is default role for the selected user type. Please mark some other role as default to delete this role.', 'en-US', 103007, 104001, 122006, 1 , GETDATE()),
(12028, 'usr_msg_12028', 'From Date should be on or after today''s date', 'From Date should be greater than or equal to Today.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12029, 'usr_msg_12029', 'To Date should be on or after the From Date.', 'To Date should be greater than or equal to From Date.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12030, 'usr_msg_12030', 'To Date should be on or after today''s date', 'To Date should be greater than or equal to Today.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12031, 'usr_msg_12031', 'Error occurred while fetching delegation details.', 'Error occurred while fetching delegation details.', 'en-US', 103007, 104001, 122028, 1 , GETDATE()),
(12032, 'usr_msg_12032', 'Error occurred while fetching list of roles for selected delegation.', 'Error occurred while fetching list of roles for selected delegation.', 'en-US', 103007, 104001, 122028, 1 , GETDATE()),
(12033, 'usr_ttl_12033', 'Roles Management List', 'Roles Management List', 'en-US', 103007, 104006, 122005, 1 , GETDATE()),
(12034, 'usr_btn_12034', 'Role Access', 'Role Access', 'en-US', 103007, 104004, 122005, 1 , GETDATE()),
(12035, 'usr_btn_12035', 'Add Role', 'Add Role', 'en-US', 103007, 104004, 122005, 1 , GETDATE()),
(12036, 'usr_ttl_12036', 'Role Management Details', 'Role Management Details', 'en-US', 103007, 104006, 122006, 1 , GETDATE()),
(12037, 'usr_ttl_12037', 'Role Activity Details', 'Role Activity Details', 'en-US', 103007, 104006, 122006, 1 , GETDATE()),
(12038, 'usr_lbl_12038', 'Role Name', 'Role Name', 'en-US', 103007, 104002, 122006, 1 , GETDATE()),
(12039, 'usr_lbl_12039', 'Description', 'Description', 'en-US', 103007, 104002, 122006, 1 , GETDATE()),
(12040, 'usr_lbl_12040', 'Status', 'Status', 'en-US', 103007, 104002, 122006, 1 , GETDATE()),
(12041, 'usr_lbl_12041', 'User Type', 'User Type', 'en-US', 103007, 104002, 122006, 1 , GETDATE()),
(12042, 'usr_lbl_12042', 'Is Default?', 'Is Default?', 'en-US', 103007, 104002, 122006, 1 , GETDATE()),
(12043, 'usr_msg_12043', 'Cannot remove the activities from role, as some of the activities are delegated by the user.', 'Cannot remove the activities, as some of the activities are delegated by the user.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12044, 'usr_msg_12044', 'The Login or Password you entered is incorrect.', 'The Login or password you entered is incorrect.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12045, 'usr_msg_12045', 'Error occurred while changing password.', 'Error occurred while changing password.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12046, 'usr_msg_12046', 'New password should not be same as old password.', 'New password should not be same as old password.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12047, 'usr_msg_12047', 'Old password entered is not correct.', 'Old password entered is not correct.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12048, 'usr_msg_12048', 'Cannot delete this role, as some dependent information exists for this role.', 'Cannot delete this role, as some dependent information exists for this role.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12049, 'usr_msg_12049', 'From and To users should not be same while defining delegation.', 'From and To users should not be same while defining delegation.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12050, 'usr_ttl_12050', 'Delegation Management', 'Delegation Management', 'en-US', 103007, 104006, 122027, 1 , GETDATE()),
(12051, 'usr_ttl_12051', 'Delegation Details', 'Delegation Details', 'en-US', 103007, 104006, 122028, 1 , GETDATE()),
(12052, 'usr_msg_12052', 'Role Name Already exists.', 'Role Name Already exists.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12053, 'usr_msg_12053', 'Role saved successfully.', 'Role saved successfully.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12054, 'usr_msg_12054', 'Role deleted successfully.', 'Role deleted successfully.', 'en-US', 103001, 104001, 122001, 1 , GETDATE()),
(12055, 'usr_msg_12055', 'Successfully updated activities for {0} role.', 'Successfully updated activities for {0} role.', 'en-US', 103001, 104001, 122001, 1 , GETDATE())

INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(13001, 'cmp_grd_13001', 'Company Name', 'Company Name', 'en-US', 103005, 104003, 122011, 1 , GETDATE()),
(13002, 'cmp_grd_13002', 'Website', 'Website', 'en-US', 103005, 104003, 122011, 1 , GETDATE()),
(13003, 'cmp_grd_13003', 'Email Id', 'Email Id', 'en-US', 103005, 104003, 122011, 1 , GETDATE()),
(13004, 'cmp_grd_13004', 'Implementing Company', 'Is Implementing', 'en-US', 103005, 104003, 122011, 1 , GETDATE()),
(13005, 'cmp_msg_13005', 'Error occurred while fetching list of companies.', 'Error occurred while fetching list of companies.', 'en-US', 103005, 104001, 122011, 1 , GETDATE()),
(13006, 'cmp_grd_13006', 'Address', 'Address', 'en-US', 103005, 104003, 122011, 1 , GETDATE()),
(13007, 'cmp_msg_13007', 'Cannot delete this company, as some dependent information exists for this company.', 'Cannot delete this company, as some dependent information exists for this company.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13008, 'cmp_msg_13008', 'Error occurred while saving company details.', 'Error occurred while saving company details.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13009, 'cmp_msg_13009', 'Company details do not exist.', 'Company details does not exist.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13010, 'cmp_msg_13010', 'Error occurred while deleting company details.', 'Error occurred while deleting company details.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13011, 'cmp_msg_13011', 'Cannot delete this company, as some dependent information exists for this company.', 'Cannot delete this company, as some dependent information exists for this company.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13012, 'cmp_msg_13012', 'Error occurred while fetching list of face values of the company.', 'Error occurred while fetching list of face values of the company.', 'en-US', 103005, 104001, 122017, 1 , GETDATE()),
(13013, 'cmp_grd_13013', 'Date', 'Date', 'en-US', 103005, 104003, 122017, 1 , GETDATE()),
(13014, 'cmp_grd_13014', 'Face Value', 'Face Value', 'en-US', 103005, 104003, 122017, 1 , GETDATE()),
(13015, 'cmp_grd_13015', 'Currency', 'Currency', 'en-US', 103005, 104003, 122017, 1 , GETDATE()),
(13016, 'cmp_msg_13016', 'Error occurred while fetching list of authorized capital of the company.', 'Error occurred while fetching list of authorized capital of the company.', 'en-US', 103005, 104001, 122019, 1 , GETDATE()),
(13017, 'cmp_grd_13017', 'Date', 'Date', 'en-US', 103005, 104003, 122019, 1 , GETDATE()),
(13018, 'cmp_grd_13018', 'Shares', 'Shares', 'en-US', 103005, 104003, 122019, 1 , GETDATE()),
(13019, 'cmp_msg_13019', 'Error occurred while fetching list of Paid Up & Subscribed Share Capital of the company.', 'Error occurred while fetching list of Paid Up & Subscribed Share Capital of the company.', 'en-US', 103005, 104001, 122021, 1 , GETDATE()),
(13020, 'cmp_grd_13020', 'Date', 'Date', 'en-US', 103005, 104003, 122021, 1 , GETDATE()),
(13021, 'cmp_grd_13021', 'Shares', 'Shares', 'en-US', 103005, 104003, 122021, 1 , GETDATE()),
(13022, 'cmp_msg_13022', 'Error occurred while fetching list of listing details for a company.', 'Error occurred while fetching list of listing details for a company.', 'en-US', 103005, 104001, 122023, 1 , GETDATE()),
(13023, 'cmp_grd_13023', 'Stock Exchange Name', 'Stock Exchange Name', 'en-US', 103005, 104003, 122023, 1 , GETDATE()),
(13024, 'cmp_grd_13024', 'Stock Exchange Code', 'Stock Exchange Code', 'en-US', 103005, 104003, 122023, 1 , GETDATE()),
(13025, 'cmp_grd_13025', 'Date of Listing', 'Date of Listing', 'en-US', 103005, 104003, 122023, 1 , GETDATE()),
(13026, 'cmp_msg_13026', 'Error occurred while fetching list of compliance officers for a company.', 'Error occurred while fetching list of compliance officers for a company.', 'en-US', 103005, 104001, 122025, 1 , GETDATE()),
(13027, 'cmp_grd_13027', 'Name', 'Name', 'en-US', 103005, 104003, 122025, 1 , GETDATE()),
(13028, 'cmp_grd_13028', 'Designation', 'Designation', 'en-US', 103005, 104003, 122025, 1 , GETDATE()),
(13029, 'cmp_grd_13029', 'Phone', 'Phone', 'en-US', 103005, 104003, 122025, 1 , GETDATE()),
(13030, 'cmp_grd_13030', 'Email ID', 'Email ID', 'en-US', 103005, 104003, 122025, 1 , GETDATE()),
(13031, 'cmp_grd_13031', 'Address', 'Address', 'en-US', 103005, 104003, 122025, 1 , GETDATE()),
(13032, 'cmp_grd_13032', 'Status', 'Status', 'en-US', 103005, 104003, 122025, 1 , GETDATE()),
(13033, 'cmp_grd_13033', 'Applicable From', 'Applicable From', 'en-US', 103005, 104003, 122025, 1 , GETDATE()),
(13034, 'cmp_grd_13034', 'Applicable To', 'Applicable To', 'en-US', 103005, 104003, 122025, 1 , GETDATE()),
(13035, 'cmp_msg_13035', 'Error occurred while saving face value for a company.', 'Error occurred while saving face value for a company.', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13036, 'cmp_msg_13036', 'Face value details does not exist.', 'Face value details does not exist.', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13037, 'cmp_msg_13037', 'Error occurred while fetching face value details for a company.', 'Error occurred while fetching face value details for a company.', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13038, 'cmp_msg_13038', 'Error occurred while deleting face value details for a company.', 'Error occurred while deleting face value details for a company.', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13039, 'cmp_msg_13039', 'Cannot delete this face value for a company, as some dependent information exists for this face value.', 'Cannot delete this face value for a company, as some dependent information exists for this face value.', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13040, 'cmp_msg_13040', 'Error occurred while deleting authorized share capital details for a company.', 'Error occurred while deleting authorized share capital details for a company.', 'en-US', 103005, 104001, 122020, 1 , GETDATE()),
(13041, 'cmp_msg_13041', 'Authorized share capital details do not exist.', 'Authorized share capital details does not exist.', 'en-US', 103005, 104001, 122020, 1 , GETDATE()),
(13042, 'cmp_msg_13042', 'Error occurred while saving compliance officer for a company.', 'Error occurred while saving compliance officer for a company.', 'en-US', 103005, 104001, 122026, 1 , GETDATE()),
(13043, 'cmp_msg_13043', 'Compliance officer for a company does not exist.', 'Compliance officer for a company does not exist.', 'en-US', 103005, 104001, 122026, 1 , GETDATE()),
(13044, 'cmp_msg_13044', 'Error occurred while deleting compliance officer for a company.', 'Error occurred while deleting compliance officer for a company.', 'en-US', 103005, 104001, 122026, 1 , GETDATE()),
(13045, 'cmp_msg_13045', 'Cannot delete compliance officer for a company, as some dependent information exists for this compliance officer.', 'Cannot delete compliance officer for a company, as some dependent information exists for this compliance officer.', 'en-US', 103005, 104001, 122026, 1 , GETDATE()),
(13046, 'cmp_msg_13046', 'Error occurred while fetching details for compliance officer for a company.', 'Error occurred while fetching details for compliance officer for a company.', 'en-US', 103005, 104001, 122026, 1 , GETDATE()),
(13047, 'cmp_msg_13047', 'Error occurred while saving listing details for a company.', 'Error occurred while saving listing details for a company.', 'en-US', 103005, 104001, 122024, 1 , GETDATE()),
(13048, 'cmp_msg_13048', 'Listing details for a company does not exist.', 'Listing details for a company does not exist.', 'en-US', 103005, 104001, 122024, 1 , GETDATE()),
(13049, 'cmp_msg_13049', 'Error occurred while deleting listing details for a company.', 'Error occurred while deleting listing details for a company.', 'en-US', 103005, 104001, 122024, 1 , GETDATE()),
(13050, 'cmp_msg_13050', 'Error occurred while fetching listing details for a company.', 'Error occurred while fetching listing details for a company.', 'en-US', 103005, 104001, 122024, 1 , GETDATE()),
(13051, 'cmp_msg_13051', 'Cannot delete listing details for a company, as some dependent information exists for this listing details.', 'Cannot delete listing details for a company, as some dependent information exists for this listing details.', 'en-US', 103005, 104001, 122024, 1 , GETDATE()),
(13052, 'cmp_msg_13052', 'Error occurred while fetching authorized share capital details for a company.', 'Error occurred while fetching authorized share capital details for a company.', 'en-US', 103005, 104001, 122020, 1 , GETDATE()),
(13053, 'cmp_msg_13053', 'Error occurred while saving authorized share capital details for a company.', 'Error occurred while saving authorized share capital details for a company.', 'en-US', 103005, 104001, 122020, 1 , GETDATE()),
(13054, 'cmp_msg_13054', 'Cannot delete authorized share capital details for a company, as some dependent information exists for this authorized share capital details.', 'Cannot delete authorized share capital details for a company, as some dependent information exists for this authorized share capital details.', 'en-US', 103005, 104001, 122020, 1 , GETDATE()),
(13055, 'cmp_msg_13055', 'Error occurred while deleting Paid Up & Subscribed Share Capital of the company.', 'Error occurred while deleting Paid Up & Subscribed Share Capital of the company.', 'en-US', 103005, 104001, 122022, 1 , GETDATE()),
(13056, 'cmp_msg_13056', 'Cannot delete Paid Up & Subscribed Share Capital details for a company, as some dependent information exists on it.', 'Cannot delete Paid Up & Subscribed Share Capital details for a company, as some dependent information exists on it.', 'en-US', 103005, 104001, 122022, 1 , GETDATE()),
(13057, 'cmp_msg_13057', 'Paid Up & Subscribed Share Capital details for a company does not exist.', 'Paid Up & Subscribed Share Capital details for a company does not exist.', 'en-US', 103005, 104001, 122022, 1 , GETDATE()),
(13058, 'cmp_msg_13058', 'Error occurred while fetching Paid Up & Subscribed Share Capital details of the company.', 'Error occurred while fetching Paid Up & Subscribed Share Capital details of the company.', 'en-US', 103005, 104001, 122022, 1 , GETDATE()),
(13059, 'cmp_msg_13059', 'Error occurred while saving Paid Up & Subscribed Share Capital details of the company.', 'Error occurred while saving Paid Up & Subscribed Share Capital details of the company.', 'en-US', 103005, 104001, 122022, 1 , GETDATE()),
(13060, 'cmp_lbl_13060', 'Company Name', 'Company Name', 'en-US', 103005, 104002, 122012, 1 , GETDATE()),
(13061, 'cmp_lbl_13061', 'Address', 'Address', 'en-US', 103005, 104002, 122012, 1 , GETDATE()),
(13062, 'cmp_lbl_13062', 'Website', 'Website', 'en-US', 103005, 104002, 122012, 1 , GETDATE()),
(13063, 'cmp_lbl_13063', 'Email Id', 'Email Id', 'en-US', 103005, 104002, 122012, 1 , GETDATE()),
(13064, 'cmp_msg_13064', 'Enter valid Email Id.', 'Enter valid Email Id.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13065, 'cmp_lbl_13065', 'Date', 'Date', 'en-US', 103005, 104002, 122018, 1 , GETDATE()),
(13066, 'cmp_lbl_13066', 'Face Value', 'Face Value', 'en-US', 103005, 104002, 122018, 1 , GETDATE()),
(13067, 'cmp_lbl_13067', 'Currency', 'Currency', 'en-US', 103005, 104002, 122018, 1 , GETDATE()),
(13068, 'cmp_msg_13068', 'Select Currency', 'Select Currency', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13069, 'cmp_msg_13069', 'Enter valid amount.', 'Enter valid amount.', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13070, 'cmp_lbl_13070', 'Shares', 'Shares', 'en-US', 103005, 104002, 122020, 1 , GETDATE()),
(13071, 'cmp_lbl_13071', 'Stock Exchange Name', 'Stock Exchange Name', 'en-US', 103005, 104002, 122024, 1 , GETDATE()),
(13072, 'cmp_msg_13072', 'Select Stock Exchange Name', 'Select Stock Exchange Name', 'en-US', 103005, 104001, 122024, 1 , GETDATE()),
(13073, 'cmp_lbl_13073', 'Date Of Listing From', 'Date Of Listing From', 'en-US', 103005, 104002, 122024, 1 , GETDATE()),
(13074, 'cmp_lbl_13074', 'Date Of Listing To', 'Date Of Listing To', 'en-US', 103005, 104002, 122024, 1 , GETDATE()),
(13075, 'cmp_lbl_13075', 'Name', 'Name', 'en-US', 103005, 104002, 122026, 1 , GETDATE()),
(13076, 'cmp_lbl_13076', 'Designation', 'Designation', 'en-US', 103005, 104002, 122026, 1 , GETDATE()),
(13077, 'cmp_lbl_13077', 'Phone No.', 'Phone No.', 'en-US', 103005, 104002, 122026, 1 , GETDATE()),
(13078, 'cmp_lbl_13078', 'Applicable To Date', 'Applicable To Date', 'en-US', 103005, 104002, 122026, 1 , GETDATE()),
(13079, 'cmp_lbl_13079', 'Applicable From Date', 'Applicable From Date', 'en-US', 103005, 104002, 122026, 1 , GETDATE()),
(13080, 'cmp_lbl_13080', 'Status', 'Status', 'en-US', 103005, 104002, 122026, 1 , GETDATE()),
(13081, 'cmp_msg_13081', 'Select Status', 'Select Status', 'en-US', 103005, 104001, 122026, 1 , GETDATE()),
(13082, 'cmp_msg_13082', 'Error occurred while fetching details for a company.', 'Error occurred while fetching details for a company.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13083, 'cmp_msg_13083', 'Enter valid Phone Number.', 'Enter valid Phone Number.', 'en-US', 103005, 104001, 122026, 1 , GETDATE()),
(13084, 'cmp_ttl_13084', 'Company List', 'Company List', 'en-US', 103005, 104006, 122011, 1 , GETDATE()),
(13085, 'cmp_btn_13085', 'Add Company', 'Add Company', 'en-US', 103001, 104004, 122011, 1 , GETDATE()),
(13086, 'cmp_ttl_13086', 'Company Information', 'Company Information', 'en-US', 103005, 104006, 122012, 1 , GETDATE()),
(13087, 'cmp_ttl_13087', 'Face Value', 'Face Value', 'en-US', 103005, 104006, 122018, 1 , GETDATE()),
(13088, 'cmp_ttl_13088', 'Authorized Capital', 'Authorized Capital', 'en-US', 103005, 104006, 122020, 1 , GETDATE()),
(13089, 'cmp_ttl_13089', 'Paid Up & Subscribed Share Capital', 'Paid Up & Subscribed Share Capital', 'en-US', 103005, 104006, 122022, 1 , GETDATE()),
(13090, 'cmp_ttl_13090', 'Listing Details', 'Listing Details', 'en-US', 103005, 104006, 122024, 1 , GETDATE()),
(13091, 'cmp_ttl_13091', 'Compliance Officer', 'Compliance Officer', 'en-US', 103005, 104006, 122026, 1 , GETDATE()),
(13092, 'cmp_msg_13092', 'To Date should be on or after the From Date. ', 'To Date should be greater than or equal to From Date.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13093, 'cmp_msg_13093', 'Applicable from date should be before applicable to date.', 'Applicable From date should be less than Applicable To date.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13094, 'cmp_msg_13094', 'Date Of Listing-  To Date should be on or after the From Date.', 'To Date should be greater than or equal to From Date.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13095, 'cmp_msg_13095', 'Date Of Listing- From Date should be before the To Date.', 'Applicable From date should be less than Applicable To date.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13096, 'cmp_ttl_13096', 'Add/Edit Company Information', 'Add/Edit Company Information', 'en-US', 103005, 104006, 122012, 1 , GETDATE()),
(13097, 'cmp_msg_13097', 'Enter valid website address.', 'Enter valid website name.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13098, 'cmp_msg_13098', 'Face Value Date must be on or before today''s date.', 'Face Value Date must be less than or equal current date.', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13099, 'cmp_msg_13099', 'Authorized Share Capital Date must be on or before today''s date.', 'Authorized Share Capital Date must be less than or equal current date.', 'en-US', 103005, 104001, 122020, 1 , GETDATE()),
(13100, 'cmp_msg_13100', 'Enter Authorized Shares value max 15 digit number', 'Enter Authorized Shares value max 15 digit number', 'en-US', 103005, 104001, 122020, 1 , GETDATE()),
(13101, 'cmp_msg_13101', 'Enter Authorized Shares value max 15 digit number.', 'Enter Authorized Shares value max 15 digit number.', 'en-US', 103005, 104001, 122020, 1 , GETDATE()),
(13102, 'cmp_msg_13102', 'Please enter a valid decimal Number with 2 decimal places', 'Please enter a valid decimal Number with 2 decimal places', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13103, 'cmp_msg_13103', 'Date Of Listing- From must be on or before today''s date.', 'Date Of Listing From must be less than or equal current date.', 'en-US', 103005, 104001, 122024, 1 , GETDATE()),
(13104, 'cmp_msg_13104', 'Date of Listing -To must be on or before today''s date.', 'Date Of Listing To must be less than or equal current date.', 'en-US', 103005, 104001, 122024, 1 , GETDATE()),
(13105, 'cmp_lbl_13105', 'ISIN', 'ISIN', 'en-US', 103005, 104002, 122001, 1 , GETDATE()),
(13106, 'cmp_msg_13106', 'Enter face value max 6 digit number', 'Enter face value max 6 digit number', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13107, 'cmp_msg_13107', 'Company Name :- $1 Saved Successfully.', 'Company Name :- $1 Save Successfully.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13108, 'cmp_msg_13108', 'Company Name :- deleted Successfully.', 'Company Name :- deleted Successfully.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13109, 'cmp_msg_13109', 'Are you sure want to delete this Company.?', 'Are you sure want to delete this Company.?', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13110, 'cmp_msg_13110', 'Face Value Saved Successfully.', 'Face Value Save Successfully.', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13111, 'cmp_msg_13111', 'Face Value deleted Successfully.', 'Face Value deleted Successfully.', 'en-US', 103005, 104001, 122018, 1 , GETDATE()),
(13112, 'cmp_msg_13112', 'Authorized Share Saved Successfully.', 'Authorized Share Save Successfully.', 'en-US', 103005, 104001, 122020, 1 , GETDATE()),
(13113, 'cmp_msg_13113', 'Authorized Share deleted Successfully.', 'Authorized Share deleted Successfully.', 'en-US', 103005, 104001, 122020, 1 , GETDATE()),
(13114, 'cmp_msg_13114', 'Company Paid Up And Subscribed Share Capital Saved Successfully.', 'Company Paid Up And Subscribed Share Capital Save Successfully.', 'en-US', 103005, 104001, 122022, 1 , GETDATE()),
(13115, 'cmp_msg_13115', 'Company Paid Up And Subscribed Share Capital deleted Successfully.', 'Company Paid Up And Subscribed Share Capital deleted Successfully.', 'en-US', 103005, 104001, 122022, 1 , GETDATE()),
(13116, 'cmp_msg_13116', 'Listing Details Saved Successfully.', 'Listing Details Save Successfully.', 'en-US', 103005, 104001, 122024, 1 , GETDATE()),
(13117, 'cmp_msg_13117', 'Listing Details deleted Successfully.', 'Listing Details deleted Successfully.', 'en-US', 103005, 104001, 122024, 1 , GETDATE()),
(13118, 'cmp_msg_13118', 'Company Compliance Officer deleted Successfully.', 'Company Compliance Officer deleted Successfully.', 'en-US', 103005, 104001, 122026, 1 , GETDATE()),
(13119, 'cmp_msg_13119', 'Company Compliance Officer Saved Successfully.', 'Company Compliance Officer Save Successfully.', 'en-US', 103005, 104001, 122026, 1 , GETDATE()),
(13120, 'cmp_msg_13120', 'Company Name already exists.', 'Company Name already exists.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13121, 'cmp_msg_13121', 'Email ID already exists.', 'Email ID already exists.', 'en-US', 103005, 104001, 122012, 1 , GETDATE()),
(13122, 'cmp_msg_13122', 'You cannot delete implementing company.', 'You cannot delete implementing company.', 'en-US', 103005, 104001,122011, 1, GETDATE())

INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(14001, 'com_btn_14001', 'Home', 'Home', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14002, 'com_btn_14002', 'Logout', 'Logout', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14003, 'com_lbl_14003', 'Welcome', 'Welcome', 'en-US', 103003, 104002, 122034, 1 , GETDATE()),
(14004, 'com_lbl_14004', 'Insider Trading', 'Insider Trading', 'en-US', 103003, 104002, 122034, 1 , GETDATE()),
(14005, 'com_btn_14005', 'Search', 'Search', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14006, 'com_btn_14006', 'Reset', 'Reset', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14007, 'com_btn_14007', 'Edit', 'Edit', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14008, 'com_btn_14008', 'View', 'View', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14009, 'com_btn_14009', 'Delete', 'Delete', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14010, 'com_btn_14010', 'Cancel', 'Cancel', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14011, 'com_btn_14011', 'Back', 'Back', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14012, 'com_lbl_14012', 'Select', 'Select', 'en-US', 103003, 104002, 122034, 1 , GETDATE()),
(14013, 'com_btn_14013', 'Previous', 'Previous', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14014, 'com_btn_14014', 'Next', 'Next', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14015, 'com_btn_14015', 'First', 'First', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14016, 'com_btn_14016', 'Last', 'Last', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14017, 'com_btn_14017', 'Save', 'Save', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14018, 'com_btn_14018', 'Continue', 'Continue', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14019, 'com_btn_14019', 'Add/Save', 'Add/Save', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14020, 'com_msg_14020', 'Error occurred while fetching current date of database server.', 'Error occurred while fetching current date of database server.', 'en-US', 103003, 104001, 122034, 1 , GETDATE()),
(14021, 'com_lbl_14021', 'Yes', 'Yes', 'en-US', 103003, 104002, 122034, 1 , GETDATE()),
(14022, 'com_lbl_14022', 'No', 'No', 'en-US', 103003, 104002, 122034, 1 , GETDATE()),
(14023, 'com_btn_14023', 'Show', 'Show', 'en-us', 103003, 104004, 122034, 1 , GETDATE()),
(14024, 'com_msg_14024', 'Error occurred while fetching current year code.', 'Error occurred while fetching current year code.', 'en-US', 103003, 104001, 122034, 1 , GETDATE()),
(14025, 'com_btn_14025', 'Submit', 'Submit', 'en-US', 103003, 104004, 122034, 1 , GETDATE()),
(14026, 'com_msg_14026', 'Error occurred while fetching configuration code.', 'Error occurred while fetching configuration code.', 'en-US', 103003, 104001, 122034, 1 , GETDATE())

INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(15001, 'rul_grd_15001', 'Financial Period', 'Financial Period', 'en-Us', 103006, 104003, 122035, 1 , GETDATE()),
(15002, 'rul_grd_15002', 'Trading Window Id', 'Trading Window Id', 'en-Us', 103006, 104003, 122035, 1 , GETDATE()),
(15003, 'rul_grd_15003', 'Result Declaration Date', 'Result Declaration Date', 'en-Us', 103006, 104003, 122035, 1 , GETDATE()),
(15004, 'rul_grd_15004', 'Window Close Date', 'Window Close Date', 'en-Us', 103006, 104003, 122035, 1 , GETDATE()),
(15005, 'rul_grd_15005', 'Window Open Date', 'Window Open Date', 'en-Us', 103006, 104003, 122035, 1 , GETDATE()),
(15006, 'rul_grd_15006', 'Days Prior To Result Declaration', 'Days Prior To Result Declaration', 'en-Us', 103006, 104003, 122035, 1 , GETDATE()),
(15007, 'rul_grd_15007', 'Days Post To Result Declaration', 'Days Post To Result Declaration', 'en-Us', 103006, 104003, 122035, 1 , GETDATE()),
(15008, 'rul_msg_15008', 'Error occurred while fetching trading windows event details.', 'Error occurred while fetching trading windows event details.', 'en-US', 103006, 104001, 122035, 1 , GETDATE()),
(15009, 'rul_grd_15009', 'Trading Window ID', 'Trading Window ID', 'en-Us', 103006, 104003, 122045, 1 , GETDATE()),
(15010, 'rul_grd_15010', 'Trading Window Event', 'Trading Window Event', 'en-Us', 103006, 104003, 122045, 1 , GETDATE()),
(15011, 'rul_grd_15011', 'Likely Declaration Date', 'Likely Declaration Date', 'en-Us', 103006, 104003, 122045, 1 , GETDATE()),
(15012, 'rul_grd_15012', 'Window Closes On', 'Window Closes On', 'en-Us', 103006, 104003, 122045, 1 , GETDATE()),
(15013, 'rul_grd_15013', 'Window Opens On', 'Window Opens On', 'en-Us', 103006, 104003, 122045, 1 , GETDATE()),
(15014, 'rul_grd_15014', 'Status', 'Status', 'en-Us', 103006, 104003, 122045, 1 , GETDATE()),
(15015, 'rul_msg_15015', 'Error occurred while fetching trading windows event list for type other.', 'Error occurred while fetching trading windows event list for type other.', 'en-US', 103006, 104001, 122045, 1 , GETDATE()),
(15016, 'rul_msg_15016', 'Error occurred while saving trading windows event for type other.', 'Error occurred while saving trading windows event for type other.', 'en-US', 103006, 104001, 122045, 1 , GETDATE()),
(15017, 'rul_msg_15017', 'Trading windows event does not exist.', 'Trading windows event does not exist.', 'en-US', 103006, 104001, 122045, 1 , GETDATE()),
(15018, 'rul_msg_15018', 'Error occurred while saving trading windows event for financial year.', 'Error occurred while saving trading windows event for financial year.', 'en-US', 103006, 104001, 122035, 1 , GETDATE()),
(15019, 'rul_lbl_15019', 'Trading Window Event Id', 'Trading Window Event Id', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15020, 'rul_lbl_15020', 'Result Declaration Date', 'Result Declaration Date', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15021, 'rul_lbl_15021', 'Result Declaration Time', 'Result Declaration Time', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15022, 'rul_lbl_15022', 'Hrs', 'Hrs', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15023, 'rul_lbl_15023', 'Mins', 'Mins', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15024, 'rul_lbl_15024', 'Days', 'Days', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15025, 'rul_lbl_15025', 'Window Closes before', 'Window Closes before', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15026, 'rul_lbl_15026', 'Window Opens After', 'Window Opens After', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15027, 'rul_btn_15027', 'Calculate', 'Calculate', 'en-US', 103006, 104004, 122045, 1 , GETDATE()),
(15028, 'rul_msg_15028', 'Error occurred while deleting trading windows event for type other.', 'Error occurred while deleting trading windows event for type other.', 'en-US', 103006, 104001, 122045, 1 , GETDATE()),
(15029, 'rul_msg_15029', 'Error occurred while fetching trading windows event for type other.', 'Error occurred while fetching trading windows event for type other.', 'en-US', 103006, 104001, 122045, 1 , GETDATE()),
(15030, 'rul_lbl_15030', 'Financial Year', 'Financial Year', 'en-US', 103006, 104002, 122035, 1 , GETDATE()),
(15031, 'rul_ttl_15031', 'Trading Window: Financial Result Declaration', 'Financial Result Declaration Trading Window', 'en-US', 103006, 104006, 122035, 1 , GETDATE()),
(15032, 'rul_grd_15032', 'Document Name', 'Document Name', 'en-Us', 103006, 104003, 122037, 1 , GETDATE()),
(15033, 'rul_grd_15033', 'Category', 'Category', 'en-Us', 103006, 104003, 122037, 1 , GETDATE()),
(15034, 'rul_grd_15034', 'Sub-category', 'Sub-category', 'en-Us', 103006, 104003, 122037, 1 , GETDATE()),
(15035, 'rul_grd_15035', 'Applicable from', 'Applicable from', 'en-Us', 103006, 104003, 122037, 1 , GETDATE()),
(15036, 'rul_grd_15036', 'Applicable to', 'Applicable to', 'en-Us', 103006, 104003, 122037, 1 , GETDATE()),
(15037, 'rul_grd_15037', 'View', 'View', 'en-Us', 103006, 104003, 122037, 1 , GETDATE()),
(15038, 'rul_grd_15038', 'Mandatory agree', 'Mandatory agree', 'en-Us', 103006, 104003, 122037, 1 , GETDATE()),
(15039, 'rul_grd_15039', 'Status', 'Status', 'en-Us', 103006, 104003, 122037, 1 , GETDATE()),
(15040, 'rul_msg_15040', 'Error occurred while fetching policy document list.', 'Error occurred while fetching policy document list.', 'en-US', 103006, 104001, 122037, 1 , GETDATE()),
(15041, 'rul_msg_15041', 'Error occurred while saving policy document details.', 'Error occurred while saving policy document details.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15042, 'rul_msg_15042', 'Error occurred while fetching policy document details.', 'Error occurred while fetching policy document details.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15043, 'rul_msg_15043', 'Policy document does not exist.', 'Policy document does not exist.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15044, 'rul_msg_15044', 'Applicable to date should be on or after applicable from date.', 'Applicable to date should be greater than or equal to applicable from date.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15045, 'rul_msg_15045', 'Policy document having same category and sub-category and with overlapping applicable from-to dates already exists.', 'Policy document having same category and sub-category and with overlapping applicable from-to dates already exists.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15046, 'rul_grd_15046', 'Employee Name', 'Employee Name', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15047, 'rul_grd_15047', 'Employee Id', 'Employee Id', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15048, 'rul_grd_15048', 'Department', 'Department', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15049, 'rul_grd_15049', 'Grade', 'Grade', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15050, 'rul_grd_15050', 'Designation', 'Designation', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15051, 'rul_msg_15051', 'Error occurred while fetching employee list during applicability search.', 'Error occurred while fetching employee list during applicability search.', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15052, 'rul_grd_15052', 'Policy Name', 'Policy Name', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15053, 'rul_grd_15053', 'Applicable from date', 'Applicable from date', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15054, 'rul_grd_15054', 'Applicable to date', 'Applicable to date', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15055, 'rul_grd_15055', 'Applicable to', 'Applicable to', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15056, 'rul_grd_15056', 'Status', 'Status', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15057, 'rul_msg_15057', 'Error occurred while fetching trading policy list.', 'Error occurred while fetching trading policy list.', 'en-US', 103006, 104001, 122039, 1 , GETDATE()),
(15058, 'rul_msg_15058', 'Error occurred while fetching trading policy details.', 'Error occurred while fetching trading policy details.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15059, 'rul_msg_15059', 'Trading Policy does not exist.', 'Trading Policy does not exist.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15060, 'rul_msg_15060', 'Error occurred while saving trading policy details.', 'Error occurred while saving trading policy details.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15061, 'rul_msg_15061', 'Invalid change of status for trading policy.', 'Invalid change of status for trading policy.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15062, 'rul_msg_15062', 'Please select a sub-category for the category of this policy document.', 'Please select a sub-category for the category of this policy document.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15063, 'rul_msg_15063', 'Policy document name is mandatory.', 'Policy document name is mandatory.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15064, 'rul_msg_15064', 'Policy document category is mandatory.', 'Policy document category is mandatory.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15065, 'rul_msg_15065', 'Applicable from and to dates are mandatory for policy document.', 'Applicable from and to dates are mandatory for policy document.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15066, 'rul_msg_15066', 'Specifying a company is mandatory for policy document.', 'Specifying a company is mandatory for policy document.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15067, 'rul_msg_15067', 'Invalid change of status for policy document.', 'Invalid change of status for policy document.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15068, 'rul_msg_15068', 'Applicable from and to dates are mandatory for trading policy.', 'Applicable from and to dates are mandatory for trading policy.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15069, 'rul_msg_15069', 'Applicable to date should be on or after applicable from date.', 'Applicable to date should be greater than or equal to applicable from date.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15070, 'rul_msg_15070', 'Mandatory : Trading policy for Insider/Employee.', 'Mandatory : Trading policy for Insider/Employee.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15071, 'rul_msg_15071', 'Mandatory : Trading policy name.', 'Mandatory : Trading policy name.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15072, 'rul_msg_15072', 'Mandatory : Trading policy description.', 'Mandatory : Trading policy description.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15073, 'rul_msg_15073', 'Mandatory : Approval required for all trades.', 'Mandatory : Approval required for all trades.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15074, 'rul_msg_15074', 'Mandatory : Any one/both of - No of shares / % of paid up & subscribed capital.', 'Mandatory : Any one/both of - No of shares / % of paid up & subscribed capital.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15075, 'rul_msg_15075', 'Mandatory : Prohibit preclearance during non-trading period.', 'Mandatory : Prohibit preclearance during non-trading period.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15076, 'rul_msg_15076', 'Mandatory : Preclearance approval to be given within X days by CO.', 'Mandatory : Preclearance approval to be given within X days by CO.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15077, 'rul_msg_15077', 'Mandatory : Preclearance approval validity X days (after approval is given excluding approval day).', 'Mandatory : Preclearance approval validity X days (after approval is given excluding approval day).', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15078, 'rul_msg_15078', 'Mandatory : Declaration for possession of UPSI to be sought from insider during preclearance.', 'Mandatory : Declaration for possession of UPSI to be sought from insider during preclearance.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15079, 'rul_msg_15079', 'Mandatory : Any one/both of - Complete trade not done for preclearance taken / Partial trade not done for preclearance taken.', 'Mandatory : Any one/both of - Complete trade not done for preclearance taken / Partial trade not done for preclearance taken.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15080, 'rul_msg_15080', 'Mandatory : Initial disclosure to be submitted by Insider/Employee to Company.', 'Mandatory : Initial disclosure to be submitted by Insider/Employee to Company.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15081, 'rul_msg_15081', 'Mandatory : Initial disclosure within X days of joining/being categorized as insider.', 'Mandatory : Initial disclosure within X days of joining/being categorized as insider.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15082, 'rul_msg_15082', 'Mandatory : Initial disclosure before X date of application go live.', 'Mandatory : Initial disclosure before X date of application go live.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15083, 'rul_msg_15083', 'Mandatory : Initial disclosure to be submitted by CO to stock exchange.', 'Mandatory : Initial disclosure to be submitted by CO to stock exchange.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15084, 'rul_msg_15084', 'Mandatory : Trade (continuous) disclosure to be submitted by Insider/Employee to CO after preclearance approval transactions within X days.', 'Mandatory : Trade (continuous) disclosure to be submitted by Insider/Employee to CO after preclearance approval transactions within X days.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15085, 'rul_msg_15085', 'Mandatory : Trade (continuous) disclosure to be submitted by Insider to CO for all trades.', 'Mandatory : Trade (continuous) disclosure to be submitted by Insider to CO for all trades.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15086, 'rul_msg_15086', 'Mandatory : Any one of - Single / Multiple transaction trade above.', 'Mandatory : Any one of - Single / Multiple transaction trade above.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15087, 'rul_msg_15087', 'Mandatory : Any one/all of - No of shares/% of paid up & subscribed capital/Value of share.', 'Mandatory : Any one/all of - No of shares/% of paid up & subscribed capital/Value of share.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15088, 'rul_msg_15088', 'Mandatory : Any one/all of - Transaction frequency-calendar or financial year/ No of shares/% of paid up & subscribed capital/Value of share.', 'Mandatory : Any one/all of - Transaction frequency-calendar or financial year/ No of shares/% of paid up & subscribed capital/Value of share.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15089, 'rul_msg_15089', 'Mandatory : Calendar/Financial year type.', 'Mandatory : Calendar/Financial year type.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15090, 'rul_msg_15090', 'Mandatory : Trade (continuous) disclosure to be submitted to stock exchange by CO.', 'Mandatory : Trade (continuous) disclosure to be submitted to stock exchange by CO.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15091, 'rul_msg_15091', 'Mandatory : Trade (continuous) disclosure submission to stock exchange by CO within X days of submission by insider/employee.', 'Mandatory : Trade (continuous) disclosure submission to stock exchange by CO within X days of submission by insider/employee.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15092, 'rul_msg_15092', 'Mandatory : Period end disclosure to be submitted by Insider/Employee to company.', 'Mandatory : Period end disclosure to be submitted by Insider/Employee to company.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15093, 'rul_msg_15093', 'Mandatory : Period end disclosure frequency.', 'Mandatory : Period end disclosure frequency.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15094, 'rul_msg_15094', 'Mandatory : Period end disclosure to be submitted by insider to CO within X days after period end.', 'Mandatory : Period end disclosure to be submitted by insider to CO within X days after period end.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15095, 'rul_msg_15095', 'Mandatory : Period end disclosure to be submitted to stock exchange by CO.', 'Mandatory : Period end disclosure to be submitted to stock exchange by CO.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15096, 'rul_msg_15096', 'Mandatory : Period end disclosure to be submitted to stock exchange by CO within X days after insider last day submission.', 'Mandatory : Period end disclosure to be submitted to stock exchange by CO within X days after insider last day submission.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15097, 'rul_msg_15097', 'Mandatory : Minimum holding period X days.', 'Mandatory : Minimum holding period X days.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15098, 'rul_msg_15098', 'Mandatory : Contra trade not allowed for X days from opposite transaction.', 'Mandatory : Contra trade not allowed for X days from opposite transaction.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15099, 'rul_lbl_15099', 'Period Type', 'Period Type', 'en-US', 103006, 104002, 122035, 1 , GETDATE()),
(15100, 'rul_msg_15100', 'Error occurred while deleting policy document.', 'Error occurred while deleting policy document.', 'en-US', 103006, 104001, 122037, 1 , GETDATE()),
(15101, 'rul_msg_15101', 'Cannot delete policy document because it is active with ongoing applicable date range.', 'Cannot delete policy document because it is active with ongoing applicable date range.', 'en-US', 103006, 104001, 122037, 1 , GETDATE()),
(15102, 'rul_msg_15102', 'Error occurred while deleting trading policy.', 'Error occurred while deleting trading policy.', 'en-US', 103006, 104001, 122039, 1 , GETDATE()),
(15103, 'rul_msg_15103', 'Cannot delete trading policy because it is active with ongoing applicable date range.', 'Cannot delete trading policy because it is active with ongoing applicable date range.', 'en-US', 103006, 104001, 122039, 1 , GETDATE()),
(15104, 'rul_msg_15104', 'Error occurred while fetching list of history records of trading policy.', 'Error occurred while fetching list of history records of trading policy.', 'en-US', 103006, 104001, 122039, 1 , GETDATE()),
(15105, 'rul_grd_15105', 'Modified on', 'Modified on', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15106, 'rul_grd_15106', 'Modified by', 'Modified by', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15107, 'rul_lbl_15107', 'Policy Document Name', 'Policy Document Name', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15108, 'rul_lbl_15108', 'Category', 'Category', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15109, 'rul_lbl_15109', 'Sub Category', 'Sub Category', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15110, 'rul_lbl_15110', 'Applicable From', 'Applicable From', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15111, 'rul_lbl_15111', 'Applicable To', 'Applicable To', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15112, 'rul_lbl_15112', 'Company', 'Company', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15113, 'rul_lbl_15113', 'Display in Policy Documents', 'Display in Policy Documents', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15114, 'rul_lbl_15114', 'Send E-mail Update', 'Send E-mail Update', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15115, 'rul_lbl_15115', 'Window Status', 'Window Status', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15116, 'rul_lbl_15116', 'View', 'View', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15117, 'rul_lbl_15117', 'Agree', 'Agree', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15118, 'rul_lbl_15118', 'ACTIVATE', 'ACTIVATE', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15119, 'rul_lbl_15119', 'DEACTIVATE', 'DEACTIVATE', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15120, 'rul_ttl_15120', 'Policy Documents', 'Policy Documents', 'en-US', 103006, 104006, 122038, 1 , GETDATE()),
(15121, 'rul_ttl_15121', 'Add / Edit Policy Documents', 'Add / Edit Policy Documents', 'en-US', 103006, 104006, 122038, 1 , GETDATE()),
(15122, 'rul_btn_15122', 'Add Policy Document', 'Add Policy Document', 'en-US', 103006, 104004, 122038, 1 , GETDATE()),
(15123, 'rul_btn_15123', 'Save', 'Save', 'en-US', 103006, 104004, 122038, 1 , GETDATE()),
(15124, 'rul_btn_15124', 'Back', 'Back', 'en-US', 103006, 104004, 122038, 1 , GETDATE()),
(15125, 'rul_msg_15125', 'Document name cannot be more than 50 character.', 'Document name cannot be more than 50 character.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15126, 'rul_msg_15126', 'Applicable from date should be before the applicable to date.', 'Applicable From date should be less than Applicable To date.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15127, 'rul_msg_15127', 'Applicable To date should be after the applicable from date.', 'Applicable To date should be greater than Applicable From date.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15128, 'rul_msg_15128', 'Applicable To date should be greater than today''s date.', 'Applicable To date should be greater than today\''s date.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15129, 'rul_msg_15129', 'Error occurred while fetching employee list with associated applicability.', 'Error occurred while fetching employee list with associated applicability.', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15130, 'rul_grd_15130', 'Name', 'Name', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15131, 'rul_grd_15131', 'Designation', 'Designation', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15132, 'rul_msg_15132', 'Error occurred while fetching non employee list during applicability search.', 'Error occurred while fetching non employee list during applicability search.', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15133, 'rul_msg_15133', 'Error occurred while fetching non employee list with associated applicability.', 'Error occurred while fetching non employee list with associated applicability.', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15134, 'rul_grd_15134', 'Company Name', 'Company Name', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15135, 'rul_grd_15135', 'Contact Person', 'Contact Person', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15136, 'rul_grd_15136', 'Landline No.', 'Landline No.', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15137, 'rul_msg_15137', 'Error occurred while fetching corporate list during applicability search.', 'Error occurred while fetching corporate list during applicability search.', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15138, 'rul_msg_15138', 'Error occurred while fetching corporate list with associated applicability.', 'Error occurred while fetching corporate list with associated applicability.', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15139, 'rul_ttl_15139', 'Trading Policy', 'Trading Policy', 'en-US', 103006, 104006, 122040, 1 , GETDATE()),
(15140, 'rul_lbl_15140', 'Insider', 'Insider', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15141, 'rul_ttl_15141', 'Trading Policy Details', 'Trading Policy Details', 'en-US', 103006, 104006, 122040, 1 , GETDATE()),
(15142, 'rul_ttl_15142', 'Trading Policy Information', 'Trading Policy Information', 'en-US', 103006, 104006, 122040, 1 , GETDATE()),
(15143, 'rul_ttl_15143', 'Pre-Clearance Requirement', 'Pre-Clearance Requirement', 'en-US', 103006, 104006, 122040, 1 , GETDATE()),
(15144, 'rul_ttl_15144', 'Disclosure Frequency - Initial Disclosures :', 'Disclosure Frequency - Initial Disclosures :', 'en-US', 103006, 104006, 122040, 1 , GETDATE()),
(15145, 'rul_ttl_15145', 'Disclosure Frequency - Trade (Continous) Disclosures :', 'Disclosure Frequency - Trade (Continous) Disclosures :', 'en-US', 103006, 104006, 122040, 1 , GETDATE()),
(15146, 'rul_ttl_15146', 'Disclosure Frequency - Period End Disclosures :', 'Disclosure Frequency - Period End Disclosures :', 'en-US', 103006, 104006, 122040, 1 , GETDATE()),
(15147, 'rul_ttl_15147', 'General', 'General', 'en-US', 103006, 104006, 122040, 1 , GETDATE()),
(15148, 'rul_ttl_15148', 'Applicability', 'Applicability', 'en-US', 103006, 104006, 122040, 1 , GETDATE()),
(15149, 'rul_ttl_15149', 'Trading Policy', 'Trading Policy', 'en-US', 103006, 104006, 122040, 1 , GETDATE()),
(15150, 'rul_lbl_15150', 'Trading Policy', 'Trading Policy', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15151, 'rul_lbl_15151', 'Policy Name', 'Policy Name', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15152, 'rul_lbl_15152', 'Description', 'Description', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15153, 'rul_lbl_15153', 'Applicable From', 'Applicable From', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15154, 'rul_lbl_15154', 'Applicable To', 'Applicable To', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15155, 'rul_lbl_15155', 'Approval Required for All Trades', 'Approval Required for All Trades', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15156, 'rul_lbl_15156', 'Continuous Disclosure required  for trade above:', 'Continuous Disclosure required  for trade above:', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15157, 'rul_lbl_15157', 'No. of Shares', 'No. of Shares', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15158, 'rul_lbl_15158', '% of paid up & subscribed capital', '% of paid up & subscribed capital', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15159, 'rul_lbl_15159', 'Prohibit pre clearance during non-trading period:', 'Prohibit pre clearance during non-trading period:', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15160, 'rul_lbl_15160', 'Pre-clearance approval to be given within', 'Pre-clearance approval to be give within', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15161, 'rul_lbl_15161', 'days by Compliance Officer', 'days by Compliance Officer', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15162, 'rul_lbl_15162', 'Pre-clearance approval validity', 'Pre-clearance approval validity', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15163, 'rul_lbl_15163', 'days (after approval is given excluding approval day)', 'days (after approval is given excluding approval day)', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15164, 'rul_lbl_15164', 'Seek declaration from employee ragrding possession of UPSI', 'Seek declaration from employee ragrding possession of UPSI', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15165, 'rul_lbl_15165', 'If Yes, Enter the declration sought from the insider at the time of preclearance', 'If Yes, Enter the declration sought from the insider at the time of preclearance', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15166, 'rul_lbl_15166', 'Reason for non trade to be provided', 'Reason for non trade to be provided', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15167, 'rul_lbl_15167', 'Complete trade not done for Pre-clearance taken', 'Complete trade not done for Pre-clearance taken', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15168, 'rul_lbl_15168', 'Partial trade not done for Pre-clearance taken', 'Partial trade not done for Pre-clearance taken', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15169, 'rul_lbl_15169', 'Yes', 'Yes', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15170, 'rul_lbl_15170', 'No', 'No', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15171, 'rul_lbl_15171', 'Initial Disclosure to be submitted by the Insider/Employee to company', 'Initial Disclosure to be submitted by the Insider/Employee to company', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15172, 'rul_lbl_15172', 'Initial Disclosure within', 'Initial Disclosure within', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15173, 'rul_lbl_15173', 'days of joining/being categorised as insider', 'days of joining/being categorised as insider', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15174, 'rul_lbl_15174', 'Initial Disclosure before', 'Initial Disclosure before', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15175, 'rul_lbl_15175', 'of application go live', 'of application go live', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15176, 'rul_lbl_15176', 'Required', 'Required', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15177, 'rul_lbl_15177', 'Not Required', 'Not Required', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15178, 'rul_lbl_15178', 'If Required,', 'If Required,', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15179, 'rul_lbl_15179', 'Softcopy', 'Softcopy', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15180, 'rul_lbl_15180', 'HardCopy', 'HardCopy', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15181, 'rul_lbl_15181', 'Initial Disclosure to be submitted by the CO to Stock Exchange', 'Initial Disclosure to be submitted by the CO to Stock Exchange', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15182, 'rul_lbl_15182', 'Trading Details to be submitted by Insider/Employee to CO within', 'Trading Details to be submitted by Insider/Employee to CO within', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15183, 'rul_lbl_15183', 'days after trade is performed', 'days after trade is performed', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15184, 'rul_lbl_15184', 'Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within', 'Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15185, 'rul_lbl_15185', 'days', 'days', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15186, 'rul_lbl_15186', 'Timeframe:', 'Timeframe:', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15187, 'rul_lbl_15187', 'Trade (Continous) Disclosure to be submitted by Insider to CO all trades', 'Trade (Continous) Disclosure to be submitted by Insider to CO all trades', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15188, 'rul_lbl_15188', 'Single Transaction Trade above', 'Single Transaction Trade above', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15189, 'rul_lbl_15189', 'Multiple Transaction Trade above', 'Multiple Transaction Trade above', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15190, 'rul_lbl_15190', 'Multiple Transaction Trade Above for', 'Multiple Transaction Trade Above for', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15191, 'rul_lbl_15191', 'in', 'in', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15192, 'rul_lbl_15192', 'Value of Share', 'Value of Share', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15193, 'rul_lbl_15193', 'Trade (Continous) Disclosure to be submitted to Stock Exchange by CO', 'Trade (Continous) Disclosure to be submitted to Stock Exchange by CO', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15194, 'rul_lbl_15194', 'Trade (Continous) Disclosure submission to Stock Exchange by CO within - ', 'Trade (Continous) Disclosure submission to Stock Exchange by CO within - ', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15195, 'rul_lbl_15195', 'days of submission by the Insider/Employee', 'days of submission by the Insider/Employee', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15196, 'rul_lbl_15196', 'Trading Policy', 'Trading Policy', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15197, 'rul_lbl_15197', 'Period End Disclosures to be submitted by the Insider/Employee to Company : ', 'Period End Disclosures to be submitted by the Insider/Employee to Company : ', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15198, 'rul_lbl_15198', 'Period End Disclosures', 'Period End Disclosures', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15199, 'rul_lbl_15199', 'Period End Disclosure to be submitted by Insider to CO within', 'Period End Disclosure to be submitted by Insider to CO within', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15200, 'rul_lbl_15200', 'days after the period end', 'days after the period end', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15201, 'rul_lbl_15201', 'Period End Disclosure to be submitted to Stock Exchanges by CO', 'Period End Disclosure to be submitted to Stock Exchanges by CO', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15202, 'rul_lbl_15202', 'Period End Disclosure to be submitted to Stock Exchanges by within', 'Period End Disclosure to be submitted to Stock Exchanges by within', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15203, 'rul_lbl_15203', 'days after Insider''s last day submission', 'days after Insider''s last day submission', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15204, 'rul_lbl_15204', 'Security Type', 'Security Type', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15205, 'rul_lbl_15205', 'Trading Plan', 'Trading Plan', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15206, 'rul_lbl_15206', 'Applies To Transaction under trading plan', 'Applies To Transaction under trading plan', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15207, 'rul_lbl_15207', 'Transaction under trading plan are exempted', 'Transaction under trading plan are exempted', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15208, 'rul_lbl_15208', 'Minimum holding period', 'Minimum holding period', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15209, 'rul_lbl_15209', 'days', 'days', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15210, 'rul_lbl_15210', 'Contra trade not allowed for', 'Contra trade not allowed for', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15211, 'rul_lbl_15211', 'days from opposite direction', 'days from opposite direction', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15212, 'rul_lbl_15212', 'Exception for', 'Exception for', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15213, 'rul_lbl_15213', 'Policy Status', 'Policy Status', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15214, 'rul_lbl_15214', 'DEACTIVATE', 'DEACTIVATE', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15215, 'rul_lbl_15215', 'ACTIVATE', 'ACTIVATE', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15216, 'rul_lbl_15216', 'Employee', 'Employee ', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15217, 'rul_btn_15217', 'Add Trading Policy', 'Add Trading Policy', 'en-US', 103006, 104004, 122039, 1 , GETDATE()),
(15218, 'rul_lbl_15218', 'Policy Name', 'Policy Name', 'en-US', 103006, 104002, 122039, 1 , GETDATE()),
(15219, 'rul_lbl_15219', 'Applicable From', 'Applicable From', 'en-US', 103006, 104002, 122039, 1 , GETDATE()),
(15220, 'rul_lbl_15220', 'Applicable To', 'Applicable To', 'en-US', 103006, 104002, 122039, 1 , GETDATE()),
(15221, 'rul_grd_15221', 'Policy Name', 'Policy Name', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15222, 'rul_grd_15222', 'Applicable from date', 'Applicable from date', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15223, 'rul_grd_15223', 'Applicable to date', 'Applicable to date', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15224, 'rul_grd_15224', 'Applicable to', 'Applicable to', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15225, 'rul_grd_15225', 'Status', 'Status', 'en-Us', 103006, 104003, 122039, 1 , GETDATE()),
(15226, 'rul_msg_15226', 'Error occurred while saving applicability.', 'Error occurred while saving applicability.', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15227, 'rul_msg_15227', 'Invalid/Conflicting input combination given while saving applicability.', 'Invalid/Conflicting input combination given while saving applicability.', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15228, 'rul_msg_15228', 'Enter No. of Share max 8 digit number', 'Enter No. of Share max 8 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15229, 'rul_msg_15229', 'Enter Prelearance CO approval limit Max 2 digit number', 'Enter Prelearance CO approval limit Max 2 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15230, 'rul_msg_15230', 'Enter Prelearance approval limit Max 2 digit number', 'Enter Prelearance approval limit Max 2 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15231, 'rul_msg_15231', 'Enter Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within- Max 2 digit number', 'Enter Trade (Continous) Disclosure to be submitted by Insider/Employee to CO after preclearance approval transaction within- Max 2 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15232, 'rul_msg_15232', 'Enter Trade Disclosure Within - Max 2 digit number', 'Enter Trade Disclosure Within - Max 2 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15233, 'rul_msg_15233', 'Enter No. of Share max 8 digit number', 'Enter No. of Share max 8 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15234, 'rul_msg_15234', 'Enter Value of Share max 10 digit number', 'Enter Value of Share max 10 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15235, 'rul_msg_15235', 'Enter Trade (Continous) Disclosure submission to Stock Exchange by CO within -  Max 2 digit number', 'Enter Trade (Continous) Disclosure submission to Stock Exchange by CO within -  Max 2 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15236, 'rul_lbl_15236', 'Initial Disclosure  be submitted by the Insider/Employee to company', 'Initial Disclosure  be submitted by the Insider/Employee to company', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15237, 'rul_msg_15237', 'Enter Initial Disclosure within Max 2 digit number', 'Enter Initial Disclosure within Max 2 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15238, 'rul_msg_15238', 'Enter Minimum holding period Max 2 digit number', 'Enter Minimum holding period Max 2 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15239, 'rul_msg_15239', 'Enter Contra trade not allowed for Max 3 digit number', 'Enter Contra trade not allowed for Max 3 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15240, 'rul_msg_15240', 'Enter Period End Disclosure to be submitted by Insider to CO within Max 2 digit number', 'Enter Period End Disclosure to be submitted by Insider to CO within Max 2 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15241, 'rul_msg_15241', 'Enter Period End Disclosure to be submitted to Stock Exchanges by CO within Max 2 digit number', 'Enter Period End Disclosure to be submitted to Stock Exchanges by CO within Max 2 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15242, 'rul_msg_15242', 'Enter Trading Details to be submitted by Insider/Employee to CO within Max 2 digit number', 'Enter Trading Details to be submitted by Insider/Employee to CO within Max 2 digit number', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15243, 'rul_lbl_15243', 'Trade (Continous) Disclosure to be submitted by Insider/Employee to Company', 'Trade (Continous) Disclosure to be submitted by Insider/Employee to Company', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15244, 'rul_msg_15244', 'Enter valid % of paid up & subscribed capital', 'Enter valid % of paid up & subscribed capital', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15245, 'rul_lbl_15245', 'Files to Upload', 'Files to Upload', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15246, 'rul_lbl_15246', 'Files Uploaded', 'Files Uploaded', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15247, 'rul_lbl_15247', 'Files to send with email', 'Files to send with email', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15248, 'rul_lbl_15248', 'Files uploaded for email', 'Files uploaded for email', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15249, 'rul_lbl_15249', 'Insider should', 'Insider should', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15250, 'rul_lbl_15250', 'this document', 'this document', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15251, 'rul_btn_15251', 'Define Applicability', 'Define Applicability', 'en-US', 103006, 104004, 122038, 1 , GETDATE()),
(15252, 'rul_msg_15252', 'Warning : Applicability is not defined for this policy document. Activating this policy document will not make it applicable to users until applicability is defined.', 'Warning : Applicability is not defined for this policy document. Activating this policy document will not make it applicable to users until applicability is defined.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15253, 'rul_msg_15253', 'Please upload policy document file.', 'Please upload policy document file.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15254, 'rul_msg_15254', 'Policy document details saved. However document file upload failed.', 'Policy document details saved. However document file upload failed.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15255, 'rul_grd_15255', 'Name', 'Name', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15256, 'rul_grd_15256', 'Company Name', 'Company Name', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15257, 'rul_grd_15257', 'Mobile No.', 'Mobile No.', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15258, 'rul_msg_15258', 'Error occurred while fetching CO user list during applicability search.', 'Error occurred while fetching CO user list during applicability search.', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15259, 'rul_msg_15259', 'Error occurred while fetching CO user list with associated applicability.', 'Error occurred while fetching CO user list with associated applicability.', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15260, 'rul_msg_15260', 'Trading Window Event Saved Successfully', 'Trading Window Event Saved Successfully', 'en-US', 103006, 104001, 122045, 1 , GETDATE()),
(15261, 'rul_msg_15261', 'Trading Window Event Deleted Successfully', 'Trading Window Event Deleted Successfully', 'en-US', 103006, 104001, 122045, 1 , GETDATE()),
(15339, 'rul_grd_15339', 'Department', 'Department', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15340, 'rul_grd_15340', 'Grade', 'Grade', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15341, 'rul_grd_15341', 'Designation', 'Designation', 'en-Us', 103006, 104003, 122041, 1 , GETDATE()),
(15342, 'rul_msg_15342', 'Error occurred while fetching applicability filter list: department-grade-designation combination.', 'Error occurred while fetching applicability filter list: department-grade-designation combination.', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15343, 'rul_msg_15343', 'Error occurred while fetching blocked dates for calender.', 'Error occurred while fetching blocked dates for calender.', 'en-US', 103006, 104001, 122042, 1 , GETDATE()),
(15344, 'rul_grd_15344', 'Policy Document Name', 'Policy Document Name', 'en-Us', 103006, 104003, 122001, 1 , GETDATE()),
(15345, 'rul_grd_15345', 'Applicable From', 'Applicable From', 'en-Us', 103006, 104003, 122001, 1 , GETDATE()),
(15346, 'rul_grd_15346', 'Applicable To', 'Applicable To', 'en-Us', 103006, 104003, 122001, 1 , GETDATE()),
(15347, 'rul_grd_15347', 'Status', 'Status Flag', 'en-Us', 103006, 104003, 122001, 1 , GETDATE()),
(15348, 'rul_grd_15348', 'Policy Status', 'Policy Status', 'en-Us', 103006, 104003, 122001, 1 , GETDATE()),
(15349, 'rul_ttl_15349', 'Trading Window: Other Events', 'Trading Window Other List', 'en-US', 103006, 104006, 122045, 1 , GETDATE()),
(15350, 'rul_ttl_15350', 'Trading Window: Other Events', 'Trading Window Other Details', 'en-US', 103006, 104006, 122045, 1 , GETDATE()),
(15351, 'rul_btn_15351', 'View Calender', 'View Calender', 'en-US', 103006, 104004, 122045, 1 , GETDATE()),
(15352, 'rul_lbl_15352', 'Select Month and Year', 'Select Month and Year', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15353, 'rul_lbl_15353', 'Sun', 'Sun', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15354, 'rul_lbl_15354', 'Mon', 'Mon', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15355, 'rul_lbl_15355', 'Tue', 'Tue', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15356, 'rul_lbl_15356', 'Wed', 'Wed', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15357, 'rul_lbl_15357', 'Thu', 'Thu', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15358, 'rul_lbl_15358', 'Fri', 'Fri', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15359, 'rul_lbl_15359', 'Sat', 'Sat', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15360, 'rul_lbl_15360', 'Events', 'Events', 'en-US', 103006, 104002, 122045, 1 , GETDATE()),
(15361, 'rul_grd_15361', 'Type Of Security', 'Type Of Security', 'en-US', 103006, 104003, 122040, 1 , GETDATE()),
(15362, 'rul_grd_15362', 'No. Of Share', 'No. Of Share', 'en-US', 103006, 104003, 122040, 1 , GETDATE()),
(15363, 'rul_grd_15363', '% Of Paid & Subscribed Capital', '% Of Paid & Subscribed Capital', 'en-US', 103006, 104003, 122040, 1 , GETDATE()),
(15364, 'rul_grd_15364', 'Value Of Share', 'Value Of Share', 'en-US', 103006, 104003, 122040, 1 , GETDATE()),
(15365, 'rul_ttl_15365', 'Policy Documents', 'Agreed Policy List', 'en-US', 103006, 104006, 122001, 1 , GETDATE()),
(15366, 'rul_lbl_15366', 'For All Security Type', 'For All Security Type', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15367, 'rul_lbl_15367', 'For Selected Security type', 'For Selected Security type', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15368, 'rul_msg_15368', 'Mandatory : Trading Policy Type.', 'Mandatory : Trading Policy Type.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15369, 'rul_msg_15369', 'Mandatory : Enter at least one entry for Preclearance Required security type.', 'Mandatory : Enter at least one entry for Preclearance Required security type', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15370, 'rul_msg_15370', 'Mandatory : Enter at least one entry for Continous discosure security type.', 'Mandatory : Enter at least one entry for Continous discosure security type.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15371, 'rul_msg_15371', 'Mandatory : Trade (Continous) Disclosure to be submitted by Insider/Employee to Company.', 'Mandatory : Trade (Continous) Disclosure to be submitted by Insider/Employee to Company.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15372, 'rul_msg_15372', 'Mandatory : Mandatory : Trading Details to be submitted by Insider/Employee to CO within.', 'Mandatory : Trading Details to be submitted by Insider/Employee to CO within.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15373, 'rul_msg_15373', 'Trading Policy deleted successfully.', 'Trading Policy deleted successfully.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15374, 'rul_msg_15374', 'Policy Name :- $1 saved successfully.', 'Policy Name :- $1 Save Successfully.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15375, 'rul_msg_15375', 'Error occurred while fetching list for trading policy secuitywise limits.', 'Error occurred while fetching list for trading policy secuitywise limits.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15376, 'rul_lbl_15376', 'Pre-Clearance required for', 'Pre-Clearance required for', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15377, 'rul_msg_15377', 'Error occurred while fetching details for Applicable Trading Policy.', 'Error occurred while fetching details for Applicable Trading Policy.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15378, 'rul_msg_15378', 'Mandatory :- Continous Disclosure please select secuity type flag.', 'Mandatory :- Continous Disclosure please select secuity type flag.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15379, 'rul_msg_15379', 'Mandatory :- Preclearance Requirement,please select security flag.', 'Mandatory :- Preclearance Requirement,please select security flag.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15380, 'rul_msg_15380', 'Trading windows event for financial year saved successfully.', 'Error occurred while saving trading windows event for financial year.', 'en-US', 103006, 104001, 122035, 1 , GETDATE()),
(15381, 'rul_msg_15381', 'Trading policy name already exists.', 'Trading policy name already exists.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15382, 'rul_grd_15382', 'Name', 'Name', 'en-US', 103006, 104003, 122042, 1 , GETDATE()),
(15383, 'rul_grd_15383', 'Description', 'Description', 'en-US', 103006, 104003, 122042, 1 , GETDATE()),
(15384, 'rul_grd_15384', 'Window Close Date', 'Window Close Date', 'en-US', 103006, 104003, 122042, 1 , GETDATE()),
(15385, 'rul_grd_15385', 'Window Open Date', 'Window Open Date', 'en-US', 103006, 104003, 122042, 1 , GETDATE()),
(15386, 'rul_msg_15386', 'Error occurred while fetching list of trading window event list.', 'Error occurred while fetching list of trading window event list.', 'en-US', 103006, 104001, 122042, 1 , GETDATE()),
(15387, 'rul_msg_15387', 'Save Trading policy section to upload the documents.', 'Save Trading policy section to upload the documents.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15388, 'rul_msg_15388', 'Mandatory : At least one disclosure(Initial,Continous and Period End) is required for saving trading policy.', 'Mandatory : At least one disclosure(Initial,Continous and Period End) is required for saving trading policy.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15389, 'rul_lbl_15389', 'Approval Required for Transaction Trade above:', 'Approval Required for Single Trade above:', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15390, 'rul_lbl_15390', 'Applicable from date cannot be before today''s date.', 'Applicable From Date cannot be less than Current Date.', 'en-US', 103006, 104002, 122040, 1 , GETDATE()),
(15391, 'rul_btn_15391', 'View All', 'View All', 'en-US', 103006, 104004, 122042, 1 , GETDATE()),
(15392, 'rul_msg_15392', 'Mandatory: Applicability is not defined in this trading policy.', 'Mandatory: Applicability is not defined in this trading policy.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15393, 'rul_btn_15393', 'Define Applicability', 'Define Applicability', 'en-US', 103006, 104004, 122040, 1 , GETDATE()),
(15394, 'rul_btn_15394', 'View Applicability', 'View Applicability', 'en-US', 103006, 104004, 122040, 1 , GETDATE()),
(15395, 'rul_msg_15395', 'This change may affect applicability. Please check Applicability screen for this policy.', 'This change may affect applicability. Please check Applicability screen for this policy.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15396, 'rul_msg_15396', 'Cannot delete this policy as old version exists.', 'Cannot delete this policy as old version exists.', 'en-US', 103006, 104001, 122039, 1 , GETDATE()),
(15397, 'rul_msg_15397', 'Cannot delete this policy as the applicability period has started and it is applicable to one or more users.', 'Cannot delete this policy as the applicability period has started and it is applicable to one or more users.', 'en-US', 103006, 104001, 122039, 1 , GETDATE()),
(15398, 'rul_grd_15398', 'User Id', 'User Id', 'en-Us', 103006, 104003, 122040, 1 , GETDATE()),
(15399, 'rul_grd_15399', 'User Type', 'User Type', 'en-Us', 103006, 104003, 122040, 1 , GETDATE()),
(15400, 'rul_grd_15400', 'Name', 'Name', 'en-Us', 103006, 104003, 122040, 1 , GETDATE()),
(15401, 'rul_grd_15401', 'Trading Policy Name', 'Trading Policy Name', 'en-Us', 103006, 104003, 122040, 1 , GETDATE()),
(15402, 'rul_grd_15402', 'Applicable From Date ', 'Applicable From Date', 'en-Us', 103006, 104003, 122040, 1 , GETDATE()),
(15403, 'rul_grd_15403', 'Applicable To Date ', 'Applicable To Date', 'en-Us', 103006, 104003, 122040, 1 , GETDATE()),
(15404, 'rul_msg_15404', 'Error occurred while fetching overlapping trading policy list.', 'Error occurred while fetching overlapping trading policy list.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15405, 'rul_ttl_15405', 'Trading policy users with overlapping trading policy(s)', 'Trading policy users with overlapping trading policy(s)', 'en-US', 103006, 104006, 122040, 1 , GETDATE()),
(15406, 'rul_msg_15406', 'Error occurred while fetching count of users and their overlapping trading policy(s).', 'Error occurred while fetching count of users and their overlapping trading policy(s).', 'en-US', 103006, 104001, 122041, 1 , GETDATE()),
(15407, 'rul_msg_15407', 'Trading Window Event activated successfully.', 'Trading Window Event activate successfully.', 'en-US', 103006, 104001, 122045, 1 , GETDATE()),
(15408, 'rul_msg_15408', 'Trading Window Event deactivated successfully.', 'Trading Window Event deactivate successfully.', 'en-US', 103006, 104001, 122045, 1 , GETDATE()),
(15409, 'rul_msg_15409', 'Policy Name :- $1 activate Successfully.', 'Policy Name :- $1 activate Successfully.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15410, 'rul_msg_15410', 'Policy Name :- $1 deactivate Successfully.', 'Policy Name :- $1 deactivate Successfully.', 'en-US', 103006, 104001, 122040, 1 , GETDATE()),
(15411, 'rul_lbl_15411', 'Create Category', 'Create Category', 'en-US', 103006, 104002, 122038, 1 , GETDATE()),
(15412, 'rul_msg_15412', 'Policy Document : $1 saved Sucessfully.', 'Policy Document : $1 saved Sucessfully.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15413, 'rul_msg_15413', 'Policy Document : $1 activated Successfully.', 'Policy Document : $1 activated Successfully.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15414, 'rul_msg_15414', 'Policy Document : $1 deactivated Successfully.', 'Policy Document : $1 deactivated Successfully.', 'en-US', 103006, 104001, 122038, 1 , GETDATE()),
(15415, 'rul_grd_15415', 'Acceptance Date', 'Acceptance Date', 'en-Us', 103006, 104003, 122001, 1 , GETDATE()),

(15416,'rul_lbl_15416', 'Allow new pre clearance to be created when eariler preclearance is open', 'Allow new pre clearance to be created when eariler preclearance is open', 'en-US', 103006, 104002, 122040, 1, GETDATE()),
(15417,'rul_lbl_15417', 'Auto Approval Required below entered value:', 'Auto Approval Required below entered value:', 'en-US', 103006, 104002, 122040, 1, GETDATE()),
(15418,'rul_lbl_15418', 'Single Pre-Clearance Request', 'Single Pre-Clearance Request', 'en-US', 103006, 104002, 122040, 1, GETDATE()),
(15419,'rul_lbl_15419', 'Multiple Pre-Clearance Request', 'Multiple Pre-Clearance Request', 'en-US', 103006, 104002, 122040, 1, GETDATE()),
(15420,'rul_lbl_15420', 'Multiple Pre-Clearance above in a:', 'Multiple Pre-Clearance above in a:', 'en-US', 103006, 104002, 122040, 1, GETDATE()),
(15421,'rul_lbl_15421', 'Pre-Clearance approval based on limit exceeding of only:', 'Pre-Clearance approval based on limit exceeding of only:', 'en-US', 103006, 104002, 122040, 1, GETDATE()),
(15422,'rul_msg_15422', 'Mandatory : Enter at least one entry for Preclearance Required security type :', 'Mandatory : Enter at least one entry for Preclearance Required security type :', 'en-US', 103006, 104001, 122040, 1, GETDATE()),
(15423,'rul_msg_15423', ' Error occurred while fetching list for trading policy transaction security.', ' Error occurred while fetching list for trading policy transaction security.', 'en-US', 103006, 104001, 122040, 1, GETDATE()),
(15424,'rul_msg_15424', 'Error occurred while fetching list for transaction security map config.', 'Error occurred while fetching list for transaction security map config.', 'en-US', 103006, 104001, 122040, 1, GETDATE()),
(15425,'rul_msg_15425', 'The TradingWindowEventCodeId field is required.', 'The TradingWindowEventCodeId field is required.', 'en-US', 103006, 104001,122045, 1, GETDATE()),

/* Sent by Tushar on 3-Nov-2015 */
(15426,'rul_lbl_15426', 'Window Status', 'Window Status', 'en-US', 103006, 104002,122045, 1, GETDATE()),
(15427,'rul_lbl_15427', 'ACTIVATE', 'ACTIVATE', 'en-US', 103006, 104002,122045, 1, GETDATE()),
(15428,'rul_lbl_15428', 'DEACTIVATE', 'DEACTIVATE', 'en-US', 103006, 104002,122045, 1, GETDATE()),
(15429,'rul_msg_15429', 'Warning : Applicability is not defined for this trading window, you cannot activate the window till applicability is defined.', 'Warning : Applicability is not defined for this trading window, you cannot activate the window till applicability is defined.', 'en-US', 103006, 104002,122045, 1, GETDATE()),
(15430,'rul_lbl_15430', 'Windows Closes at', 'Windows Closes at', 'en-US', 103006, 104002,122045, 1, GETDATE()),
(15431,'rul_lbl_15431', 'Windows Close Date', 'Windows Close Date', 'en-US', 103006, 104002,122045, 1, GETDATE()),
(15432,'rul_lbl_15432', 'Windows Open Date', 'Windows Open Date', 'en-US', 103006, 104002,122045, 1, GETDATE()),
(15433,'rul_lbl_15433', 'Windows Open at', 'Windows Open at', 'en-US', 103006, 104002,122045, 1, GETDATE()),

/* Sent by Tushar on 4-Nov-2015 */
(15434,'rul_msg_15434', 'Windows Open Date must be equal or greater than todays date.', 'Windows Open Date must be equal or greater than todays date.', 'en-US', 103006, 104001,122045,1, GETDATE()),
(15435,'rul_msg_15435', 'Enter Days Prior To Result Declaration limit Max 3 digit number.', 'Enter DaysPriorToResultDeclaration limit Max 3 digit number.', 'en-US', 103006, 104001,122045,1, GETDATE()),
(15436,'rul_msg_15436', 'Enter Days Post Result Declaration limit Max 3 digit number.', 'Enter Days Post Result Declaration limit Max 3 digit number.', 'en-US', 103006, 104001,122045,1, GETDATE()),

/* Sent by Tushar on 23-Nov-2015 */
(15437,'rul_lbl_15437', 'System should consider ESOP Exercise(Cash and Cashless Partial Exercise) option first and then other shares', 'System should consider ESOP Exercise(Cash and Cashless Partial Exercise) option first and then other shares', 'en-US', 103006, 104002,122040, 1, GETDATE()),
(15438,'rul_lbl_15438', 'System should consider other share balance first and then ESOP Exercise(Cash and Cashless Partial Exercise)', 'System should consider other share balance first and then ESOP Exercise(Cash and Cashless Partial Exercise)', 'en-US', 103006, 104002,122040, 1, GETDATE()),
(15439,'rul_lbl_15439', 'User selection on Pre-Clearance / trade details submission form', 'User selection on Pre-Clearance / trade details submission form', 'en-US', 103006, 104002,122040, 1, GETDATE()),
(15440,'rul_lbl_15440', 'Securities prior to acquisition, Percentage of shares pre transaction & Percentage of shares post transaction', 'Securities prior to acquisition, Percentage of shares pre transaction & Percentage of shares post transaction', 'en-US', 103006, 104002,122040, 1, GETDATE()),
(15441,'rul_lbl_15441', 'Manual Input', 'Manual Input', 'en-US', 103006, 104002,122040, 1, GETDATE()),
(15442,'rul_lbl_15442', 'Auto Calculate', 'Auto Calculate', 'en-US', 103006, 104002,122040, 1, GETDATE()),
(15443,'rul_msg_15443', 'Mandatory: Select value for Securities prior to acquisition, Percentage of shares pre transaction & Percentage of shares post transaction.', 'Mandatory: Select value for Securities prior to acquisition, Percentage of shares pre transaction & Percentage of shares post transaction.', 'en-US', 103006, 104001,122040, 1, GETDATE()),
(15444,'rul_msg_15444', 'Mandatory: Select Cash and Cashless Partial Exercise Option(EOSP & Other).', 'Mandatory: Select Cash and Cashless Partial Exercise Option(EOSP & Other).', 'en-US', 103006, 104001,122040, 1, GETDATE()),
(15445,'rul_lbl_15445', 'Mandatory: Select value for Single Pre-Clearance Request & Multiple Pre-Clearance Request.', 'Mandatory: Select value for Single Pre-Clearance Request & Multiple Pre-Clearance Request.', 'en-US', 103006, 104002,122040, 1, GETDATE()),

/* Sent by Parag on 21-Dec-2015 */
(15446, 'rul_lbl_15446','Threshold Limit Reset', 'Threshold Limit Reset', 'en-US', 103006, 104002, 122040, 1, GETDATE()),
/* Send by Tushar on 22-Mar-2015 */
(15447,'rul_msg_15447', 'Set the Contra Trade Option for Selection of QTY Yes/No configuration. Please contact the Administrator', 'Set the Contra Trade Option for Selection of QTY Yes/No configuration. Please contact the Administrator', 'en-US', 103006, 104001,122040, 1, GETDATE())

/*
Script received from Gaurishankar on 12 May 2016 - Resources & Grid Header Settings for applicability.
*/
INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
VALUES
	(15448, 'rul_grd_15448', 'Category', 'Category', 'en-US', 103006, 104003, 122041, 1	,GETDATE()),
	(15449, 'rul_grd_15449', 'Sub Category', 'Sub Category', 'en-US', 103006 , 104003 , 122041 , 1, GETDATE()),
	(15450, 'rul_grd_15450', 'Role', 'Role', 'en-US', 103006, 104003 , 122041, 1, GETDATE()),
	(15451, 'rul_grd_15451', 'Category', 'Category', 'en-US', 103006, 104003, 122041, 1, GETDATE()),
	(15452, 'rul_grd_15452', 'Sub Category', 'Sub Category','en-US', 103006, 104003, 122041, 1, GETDATE()),
	(15453, 'rul_grd_15453', 'Role', 'Role', 'en-US', 103006, 104003, 122041, 1, GETDATE())
	
/* Send by Tushar on 22-Apr-2015 */
INSERT INTO mst_Resource(ResourceId,ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
VALUES 
	(15454,'rul_ttl_15454', 'Contra Trade', 'Contra Trade', 'en-US', 103006, 104006,122040,1, GETDATE()),
	(15455,'rul_lbl_15455', 'Contra Trade Based On', 'Contra Trade Based On', 'en-US', 103006, 104002,122040,1, GETDATE()),
	(15456,'rul_lbl_15456', 'All Security Type', 'All Security Type', 'en-US', 103006, 104002,122040,1, GETDATE()),
	(15457,'rul_lbl_15457', 'Individual Security Type', 'Individual Security Type', 'en-US', 103006, 104002,122040,1, GETDATE()),
	(15458,'rul_msg_15458', 'Mandatory:Please select at least on Security Type for Contra Trade based on.', 'Mandatory:Please select at least on Security Type for Contra Trade based on.', 'en-US', 103006, 104001,122040,1, GETDATE())


INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(16001, 'tra_grd_16001', 'Name, Address, Mobile Number', 'Name, Address, Mobile Number', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16002, 'tra_grd_16002', 'PAN Number', 'PAN', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16003, 'tra_grd_16003', 'Relation with Insider', 'Relation with insider', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16004, 'tra_grd_16004', 'Demat A/c Number', 'Demat A/c No.', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16005, 'tra_grd_16005', 'Securities held prior to acquisition/ disposal', 'No of Shares/Voting rights acquired', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16006, 'tra_grd_16006', '% of Shareholding - Pre transaction', '% of Shares/Voting rights acquired', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16007, 'tra_grd_16007', 'Date of Acquisition', 'Date of Acquisition', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16008, 'tra_grd_16008', 'Date of Intimation to Company', 'Date of Intimation to Company', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16009, 'tra_grd_16009', 'Mode of Acquisition', 'Mode of Acquisition', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16010, 'tra_grd_16010', '% of Shareholding - Post transaction', 'Shareholding Subsequent to Acqusition', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16011, 'tra_grd_16011', 'Registration number of TM', 'Registration number of TM', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16012, 'tra_grd_16012', 'Stock Exchange', 'Exchange', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16013, 'tra_grd_16013', 'Transaction Type', 'Transaction Type', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16014, 'tra_grd_16014', 'Securities', 'Qty', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16015, 'tra_grd_16015', 'Value', 'Value', 'en-Us', 103008, 104003, 122036, 1 , GETDATE()),
(16016, 'tra_msg_16016', 'Error occurred while fetching list of transactions', 'Error occurred while fetching list of transactions', 'en-Us', 103008, 104001, 122036, 1 , GETDATE()),
(16017, 'tra_msg_16017', 'Trading transaction details not found.', 'Trading transaction details not found.', 'en-Us', 103008, 104001, 122036, 1 , GETDATE()),
(16018, 'tra_msg_16018', 'Error occurred while deleting transactions data.', 'Error occurred while deleting transactions data', 'en-Us', 103008, 104001, 122036, 1 , GETDATE()),
(16019, 'tra_msg_16019', 'Cannot delete transaction data, as some dependent information exists on it.', 'Cannot delete transaction data, as some dependent information exists on it.', 'en-Us', 103008, 104001, 122036, 1 , GETDATE()),
(16020, 'tra_msg_16020', 'Error occurred while fetching transactions data.', 'Error occurred while fetching transactions data.', 'en-Us', 103008, 104001, 122036, 1 , GETDATE()),
(16021, 'tra_msg_16021', 'Error occurred while saving transactions data.', 'Error occurred while saving transactions data.', 'en-Us', 103008, 104001, 122036, 1 , GETDATE()),
(16022, 'tra_lbl_16022', 'Name, Address & Mobile Number', 'Name, Address & Mob No.', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16023, 'tra_lbl_16023', 'Trading for', 'Trading for', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16024, 'tra_lbl_16024', 'Relation with Insider', 'Relation with Employee', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16025, 'tra_lbl_16025', 'Demat A/c Number', 'Demat A/c No', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16026, 'tra_lbl_16026', 'Securities held prior to acquisition/disposal', 'Securities prior to acquisition', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16027, 'tra_lbl_16027', '% of Shareholding - Pre transaction', 'Percentage of shares pre transaction', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16028, 'tra_lbl_16028', 'Shareholding prior to acquisition', 'Shareholding prior to acquisition', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16029, 'tra_lbl_16029', 'Number of securities acquired/ disposed', 'No of share acquisition', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16030, 'tra_lbl_16030', 'Date of acquisition', 'Date of Acquisition', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16031, 'tra_lbl_16031', 'Date of Intimation to company', 'Date of Intimation to company', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16032, 'tra_lbl_16032', 'Mode of acquisition', 'Mode of acquisition', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16033, 'tra_lbl_16033', '% of Shareholding - Post transaction', 'Percentage of shares post transaction', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16034, 'tra_lbl_16034', 'Registration No of the TM', 'Registration No of the TM', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16035, 'tra_lbl_16035', 'Stock Exchange', 'Exchange', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16036, 'tra_lbl_16036', 'Transaction type', 'Transaction type', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16037, 'tra_lbl_16037', 'Number of Securities', 'Number of shares or Units', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16038, 'tra_lbl_16038', 'Value of Securities', 'Value of shares', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16039, 'tra_grd_16039', 'Company Name', 'Company Name', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16040, 'tra_grd_16040', 'Contact Person', 'Contact Person', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16041, 'tra_grd_16041', 'Designation', 'Designation', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16042, 'tra_grd_16042', 'Document Viewed', 'Document Viewed', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16043, 'tra_grd_16043', 'Document Accepted', 'Document Agreed', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16044, 'tra_msg_16044', 'Error occurred while fetching corporate user list associated with policy document.', 'Error occurred while fetching corporate user list associated with policy document.', 'en-Us', 103008, 104001, 122043, 1 , GETDATE()),
(16045, 'tra_grd_16045', 'Name', 'Name', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16046, 'tra_grd_16046', 'Designation', 'Designation', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16047, 'tra_grd_16047', 'Document Viewed', 'Document Viewed', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16048, 'tra_grd_16048', 'Document Accepted', 'Document Agreed', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16049, 'tra_msg_16049', 'Error occurred while fetching non-employee user list associated with policy document.', 'Error occurred while fetching non-employee user list associated with policy document.', 'en-Us', 103008, 104001, 122043, 1 , GETDATE()),
(16050, 'tra_grd_16050', 'Employee Id', 'Employee Id', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16051, 'tra_grd_16051', 'Name', 'Employee Name', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16052, 'tra_grd_16052', 'Designation', 'Designation', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16053, 'tra_grd_16053', 'Document Viewed', 'Document Viewed', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16054, 'tra_grd_16054', 'Document Accepted', 'Document Agreed', 'en-Us', 103008, 104003, 122043, 1 , GETDATE()),
(16055, 'tra_msg_16055', 'Error occurred while fetching employee user list associated with policy document.', 'Error occurred while fetching employee user list associated with policy document.', 'en-Us', 103008, 104001, 122043, 1 , GETDATE()),
(16056, 'tra_lbl_16056', 'Policy Document :', 'Policy Document :', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16057, 'tra_lbl_16057', 'Category Name', 'Category Name', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16058, 'tra_lbl_16058', 'Sub-Category', 'Sub-Category', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16059, 'tra_lbl_16059', 'Applicable From', 'Applicable From', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16060, 'tra_lbl_16060', 'Applicable To', 'Applicable To', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16061, 'tra_lbl_16061', 'View', 'View', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16062, 'tra_lbl_16062', 'Mandatory Agree', 'Mandatory Agree', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16063, 'tra_lbl_16063', 'Status', 'Status', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16064, 'tra_lbl_16064', 'Action', 'Action', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16065, 'tra_lbl_16065', 'Employee Insider', 'Employee Insider', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16066, 'tra_lbl_16066', 'Corporate Insider', 'Corporate Insider', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16067, 'tra_lbl_16067', 'Non-Employee Insider', 'Non-Employee Insider', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16068, 'tra_lbl_16068', 'Employee ID', 'Employee ID', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16069, 'tra_lbl_16069', 'Name', 'Employee Name', 'en-US', 103008, 104002, 122043, 1 , GETDATE()),
(16070, 'tra_grd_16070', 'Template name', 'Template name', 'en-Us', 103008, 104003, 122049, 1 , GETDATE()),
(16071, 'tra_grd_16071', 'Communication mode', 'Communication mode', 'en-Us', 103008, 104003, 122049, 1 , GETDATE()),
(16072, 'tra_grd_16072', 'Disclosure type', 'Disclosure type', 'en-Us', 103008, 104003, 122049, 1 , GETDATE()),
(16073, 'tra_grd_16073', 'Status', 'Status', 'en-Us', 103008, 104003, 122049, 1 , GETDATE()),
(16074, 'tra_msg_16074', 'Error occurred while fetching list of templates.', 'Error occurred while fetching list of templates.', 'en-Us', 103008, 104001, 122049, 1 , GETDATE()),
(16075, 'tra_msg_16075', 'Template does not exist.', 'Template does not exist.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16076, 'tra_msg_16076', 'Error occurred while deleting template.', 'Error occurred while deleting template.', 'en-Us', 103008, 104001, 122049, 1 , GETDATE()),
(16077, 'tra_msg_16077', 'Error occurred while fetching template details.', 'Error occurred while fetching template details.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16078, 'tra_msg_16078', 'Cannot delete template because it is used in communication rule.', 'Cannot delete template because it is used in communication rule.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16079, 'tra_msg_16079', 'Error occurred while saving template.', 'Error occurred while saving template.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16080, 'tra_msg_16080', 'Template name is mandatory.', 'Template name is mandatory.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16081, 'tra_msg_16081', 'Communication mode is mandatory.', 'Communication mode is mandatory.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16082, 'tra_msg_16082', 'Disclosure type is mandatory.', 'Disclosure type is mandatory.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16083, 'tra_msg_16083', 'Letter for is mandatory.', 'Letter for is mandatory.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16084, 'tra_msg_16084', 'Date is mandatory.', 'Date is mandatory.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16085, 'tra_msg_16085', 'ToAddress1 is mandatory.', 'ToAddress1 is mandatory.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16086, 'tra_msg_16086', 'ToAddress2 is mandatory.', 'ToAddress2 is mandatory.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16087, 'tra_msg_16087', 'Subject is mandatory.', 'Subject is mandatory.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16088, 'tra_msg_16088', 'Content is mandatory.', 'Content is mandatory.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16089, 'tra_msg_16089', 'Signature is mandatory.', 'Signature is mandatory.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16090, 'tra_msg_16090', 'Notification from is mandatory.', 'Notification from is mandatory.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16091, 'tra_msg_16091', 'Transactions data does not exist.', 'Transactions data does not exist.', 'en-Us', 103008, 104001, 122036, 1 , GETDATE()),
(16092, 'tra_msg_16092', 'Error occurred while saving transaction.', 'Error occurred while saving transaction.', 'en-Us', 103008, 104001, 122036, 1 , GETDATE()),
(16093, 'tra_msg_16093', 'Trading policy is not defined for the user for which transaction is being entered. Please contact administrator.', 'Trading policy is not defined for the user for which transaction is being entered. Please contact administrator.', 'en-Us', 103008, 104001, 122036, 1 , GETDATE()),
(16094, 'tra_lbl_16094', 'Percentage of Securities', 'Percentage of shares', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16095, 'tra_lbl_16095', 'Buy quantity', 'Buy quantity', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16096, 'tra_lbl_16096', 'Buy value', 'Buy value', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16097, 'tra_lbl_16097', 'Sell quantity', 'Sell quantity', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16098, 'tra_lbl_16098', 'Sell value', 'Sell value', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16099, 'tra_lbl_16099', 'Lot size', 'Lot size', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16100, 'tra_lbl_16100', 'Registration no. of the TM', 'Registration no. of the TM', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16101, 'tra_lbl_16101', 'Reason for not trading', 'Reason for Not Traded', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16102, 'tra_lbl_16102', 'Security Type', 'Security Type', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16103, 'tra_msg_16103', 'Please confirm and proceed to submit details. You will not be able to update details after submission.', 'Please confirm and proceed to submit details. You will not be able to update details after submission.', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16104, 'tra_msg_16104', 'Are you sure you and your dependents do not have any holding in the securities of the Company?', 'Are you sure you and your dependents do not have any holding in the securities of the Company?', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16105, 'tra_msg_16105', 'Are you sure you do not have any period end disclosure to submit?', 'Are you sure you do not have any period end disclosure to submit?', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16106, 'tra_msg_16106', 'Are you sure you do not want to submit the trading details?', 'Are you sure you do not want to submit the trading details?', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16107, 'tra_msg_16107', 'Date of becoming insider field is required', 'Date of becoming insider field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16108, 'tra_msg_16108', 'Date of becoming insider cannot be a future date', 'Date of becoming insider cannot be greater than todays date', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16109, 'tra_msg_16109', 'Securities Prior To Acquisition field is required', 'Securities Prior To Acquisition field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16110, 'tra_msg_16110', 'Date of acquisition field is required', 'Date of acquisition field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16111, 'tra_msg_16111', 'Date of acquisition cannot be greater than todays date', 'Date of acquisition cannot be greater than todays date', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16112, 'tra_msg_16112', 'Mode of acquisition field is required', 'Mode of acquisition field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16113, 'tra_msg_16113', 'Date of initimation to company field is required', 'Date of initimation to company field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16114, 'tra_msg_16114', 'Date of initimation to company cannot be greater than today''s date', 'Date of initimation to company cannot be greater than today''s date', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16115, 'tra_msg_16115', 'Trading for field is required', 'Trading for field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16116, 'tra_msg_16116', 'Number of securities field is required', 'Number of shares or units field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16117, 'tra_msg_16117', 'Number of values field is required', 'Number of values field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16118, 'tra_msg_16118', 'Exchange field is required', 'Exchange field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16119, 'tra_msg_16119', 'Transaction Type field is required', 'Transaction Type field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16120, 'tra_msg_16120', 'Demat account field is required', 'Demat account field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16121, 'tra_msg_16121', 'Lot size field is required', 'Lot size field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16122, 'tra_msg_16122', 'Percentage Of Shares Pre Transaction field is required', 'Percentage Of Shares Pre Transaction field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16123, 'tra_msg_16123', 'Percentage Of Shares Post Transaction field is required', 'Percentage Of Shares Post Transaction field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16124, 'tra_msg_16124', 'Sell quantity field is required', 'Sell quantity field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16125, 'tra_msg_16125', 'Sell value field is required', 'Sell value field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16126, 'tra_msg_16126', 'Transaction Saved Successfully.', 'Trading transaction submitted.', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16127, 'tra_msg_16127', 'Not traded submitted.', 'Not traded submitted.', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16128, 'tra_msg_16128', 'Trading transaction details deleted successfully', 'Trading transaction details deleted successfully', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16129, 'tra_msg_16129', 'Are you sure you do not want to submit the trading details?', 'Are you sure you do not want to submit the trading details?', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16130, 'tra_ttl_16130', 'Add/Edit details for', 'Add/Edit details for', 'en-US', 103008, 104006, 122036, 1 , GETDATE()),
(16131, 'tra_btn_16131', 'Create Letter', 'Create Letter', 'en-US', 103008, 104004, 122036, 1 , GETDATE()),
(16132, 'tra_btn_16132', 'Not Traded', 'Not Traded', 'en-US', 103008, 104004, 122036, 1 , GETDATE()),
(16133, 'tra_btn_16133', 'No Holdings', 'No Holdings', 'en-US', 103008, 104004, 122036, 1 , GETDATE()),
(16134, 'tra_btn_16134', 'No Period-end', 'No Period-end', 'en-US', 103008, 104004, 122036, 1 , GETDATE()),
(16135, 'tra_btn_16135', 'Enter Details', 'Enter Details', 'en-US', 103008, 104004, 122036, 1 , GETDATE()),
(16136, 'tra_msg_16136', 'Securities prior to acquisition should not exceed beyond 5 digits', 'Securities prior to acquisition should not exceed beyond 5 digits', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16137, 'tra_msg_16137', 'Enter valid percentage of shares pre transaction', 'Enter valid percentage of shares pre transaction', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16138, 'tra_msg_16138', 'Enter valid percentage of shares post transaction', 'Enter valid percentage of shares post transaction', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16139, 'tra_msg_16139', 'Quantity should not exceed beyond 10 digits', 'Quantity should not exceed beyond 10 digits', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16140, 'tra_msg_16140', 'Number of values should not exceed beyond 10 digits', 'Number of values should not exceed beyond 10 digits', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16141, 'tra_msg_16141', 'Sell quantity should not exceed beyond 10 digits', 'Sell quantity should not exceed beyond 10 digits', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16142, 'tra_msg_16142', 'Sell Value should not exceed beyond 10 digits', 'Sell Value should not exceed beyond 10 digits', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16143, 'tra_lbl_16143', 'Name', 'Name', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16144, 'tra_lbl_16144', 'Address', 'Address', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16145, 'tra_lbl_16145', 'Mobile Number', 'Mobile no.', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16146, 'tra_lbl_16146', 'PAN Number', 'PAN no.', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16147, 'tra_lbl_16147', 'Date of becoming insider', 'Date of becoming insider', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16148, 'tra_msg_16148', 'Please select reason for not trading', 'Please select reason for not trading', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16149, 'tra_lbl_16149', 'Sell quantity must be equal to buy quantity', 'Sell quantity must be equal to buy quantity', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16150, 'tra_lbl_16150', 'Sell quantity must be less than buy quantity', 'Sell quantity must be less than buy quantity', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16151, 'tra_lbl_16151', 'Sell value must be equal to buy value', 'Sell value must be equal to buy value', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16152, 'tra_lbl_16152', 'Sell value must be less than buy value', 'Sell value must be less than buy value', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16153, 'tra_msg_16153', 'Template saved successfully.', 'Template saved successfully.', 'en-Us', 103008, 104001, 122050, 1 , GETDATE()),
(16154, 'tra_lbl_16154', 'Name', 'Name', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16155, 'tra_lbl_16155', 'Communication Mode', 'Communication Mode', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16156, 'tra_lbl_16156', 'Is Active?', 'Is Active?', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16157, 'tra_lbl_16157', 'Disclosure Type', 'Disclosure Type', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16158, 'tra_lbl_16158', 'Letter For', 'Letter For', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16159, 'tra_lbl_16159', 'Date', 'Date', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16160, 'tra_lbl_16160', 'To Address 1', 'To Address 1', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16161, 'tra_lbl_16161', 'To Address 2', 'To Address 2', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16162, 'tra_lbl_16162', 'Subject', 'Subject', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16163, 'tra_lbl_16163', 'Content', 'Content', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16164, 'tra_lbl_16164', 'Signature', 'Signature', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16165, 'tra_lbl_16165', 'From', 'From', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16166, 'tra_ttl_16166', 'Template Master', 'Template Master', 'en-US', 103008, 104006, 122050, 1 , GETDATE()),
(16167, 'tra_ttl_16167', 'Template Details', 'Template Details', 'en-US', 103008, 104006, 122050, 1 , GETDATE()),
(16168, 'tra_btn_16168', 'Add Template', 'Add Template', 'en-US', 103008, 104004, 122050, 1 , GETDATE()),
(16169, 'tra_lbl_16169', 'Question', 'Question', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16170, 'tra_lbl_16170', 'Answer', 'Answer', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16171, 'tra_lbl_16171', 'Sequence No', 'Sequence No', 'en-US', 103008, 104002, 122050, 1 , GETDATE()),
(16172, 'tra_msg_16172', 'The Question field is required.', 'The Question field is required.', 'en-US', 103008, 104001, 122050, 1 , GETDATE()),
(16173, 'tra_msg_16173', 'The Answer field is required.', 'The Answer field is required.', 'en-US', 103008, 104001, 122050, 1 , GETDATE()),
(16174, 'tra_msg_16174', 'Sequence No is mandatory.', 'Sequence No is mandatory.', 'en-US', 103008, 104001, 122050, 1 , GETDATE()),
(16175, 'tra_msg_16175', 'Template deleted successfully', 'Template deleted successfully', 'en-US', 103008, 104001, 122050, 1 , GETDATE()),
(16176, 'tra_msg_16176', 'Template with same name already exists.', 'Template with same name already exists.', 'en-US', 103008, 104001, 122050, 1 , GETDATE()),
(16177, 'tra_msg_16177', 'Enter valid Sequence Number.', 'Enter valid Sequence Number.', 'en-US', 103008, 104001, 122050, 1 , GETDATE()),
(16178, 'tra_msg_16178', 'The field {0} cannot contain the < and > characters.', 'The field {0} cannot contain the < and > characters.', 'en-US', 103008, 104001, 122050, 1 , GETDATE()),
(16179, 'tra_msg_16179', 'You cannot submit the transaction as no trade details were entered.', 'You cannot submit the transaction as no trade details were entered.', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16180, 'tra_lbl_16180', 'Number of securities', 'Number of securities', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16181, 'tra_lbl_16181', 'Value of securities', 'Value of securities', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16182, 'tra_msg_16182', 'Number of securities field is required', 'Number of securities field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16183, 'tra_msg_16183', 'Value of securities field is required', 'Value of securities field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16184, 'tra_msg_16184', 'Buy quantity field is required', 'Buy quantity securities field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16185, 'tra_msg_16185', 'Buy value field is required', 'Buy value securities field is required', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16186, 'tra_msg_16186', 'Transaction saved successfully', 'Trading transaction saved successfully', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16187, 'tra_msg_16187', 'Error occurred while deleting the trading transaction master.', 'Error occurred while deleting the trading transaction master.', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16188, 'tra_msg_16188', 'Transaction details document not uploaded.', 'Transaction details document not uploaded.', 'en-US', 103008, 104001, 122036, 1 , GETDATE()),
(16189, 'tra_msg_16189', 'Are you sure you want to submit the uploaded document?', 'Are you sure you want to submit the uploaded document?', 'en-US', 103008, 104001, 122036, 1 , GETDATE())

/* Script sent by Amar on 29th Jul 2015 */
INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId,OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES 
(16190, 'tra_grd_16190','Name, Address, Mobile Number','en-Us',103008,104003,122071,'Name, Address, Mobile Number',1,GETDATE())
,(16191, 'tra_grd_16191','PAN','en-Us',103008,104003,122071,'PAN',1,GETDATE())
,(16192, 'tra_grd_16192','Relation with insider','en-Us',103008,104003,122071,'Relation with insider',1,GETDATE())
,(16193, 'tra_grd_16193','Demat A/c No.','en-Us',103008,104003,122071,'Demat A/c No.',1,GETDATE())
,(16194, 'tra_grd_16194','No of Shares/Voting rights acquired','en-Us',103008,104003,122071,'No of Shares/Voting rights acquired',1,GETDATE())
,(16195, 'tra_grd_16195','% of Shares/Voting rights acquired','en-Us',103008,104003,122071,'% of Shares/Voting rights acquired',1,GETDATE())
,(16196, 'tra_grd_16196','Date of Acquisition','en-Us',103008,104003,122071,'Date of Acquisition',1,GETDATE())
,(16197, 'tra_grd_16197','Date of Intimation to Company','en-Us',103008,104003,122071,'Date of Intimation to Company',1,GETDATE())
,(16198, 'tra_grd_16198','Mode of Acquisition','en-Us',103008,104003,122071,'Mode of Acquisition',1,GETDATE())
,(16199, 'tra_grd_16199','Shareholding Subsequent to Acqusition','en-Us',103008,104003,122071,'Shareholding Subsequent to Acqusition',1,GETDATE())
,(16200, 'tra_grd_16200','Registration number of TM','en-Us',103008,104003,122071,'Registration number of TM',1,GETDATE())
,(16201, 'tra_grd_16201','Exchange','en-Us',103008,104003,122071,'Exchange',1,GETDATE())
,(16202, 'tra_grd_16202','Transaction Type','en-Us',103008,104003,122071,'Transaction Type',1,GETDATE())
,(16203, 'tra_grd_16203','Qty','en-Us',103008,104003,122071,'Qty',1,GETDATE())
,(16204, 'tra_grd_16204','Value','en-Us',103008,104003,122071,'Value',1,GETDATE())
,(16205, 'tra_grd_16205','Action','en-Us',103008,104003,122071,'Action',1,GETDATE())
,(16206, 'tra_grd_16206','Name, Address, Mobile Number','en-Us',103008,104003,122066,'Name, Address, Mobile Number',1,GETDATE())
,(16207, 'tra_grd_16207','PAN','en-Us',103008,104003,122066,'PAN',1,GETDATE())
,(16208, 'tra_grd_16208','Relation with insider','en-Us',103008,104003,122066,'Relation with insider',1,GETDATE())
,(16209, 'tra_grd_16209','Demat A/c No.','en-Us',103008,104003,122066,'Demat A/c No.',1,GETDATE())
,(16210, 'tra_grd_16210','No of Shares/Voting rights acquired','en-Us',103008,104003,122066,'No of Shares/Voting rights acquired',1,GETDATE())
,(16211, 'tra_grd_16211','% of Shares/Voting rights acquired','en-Us',103008,104003,122066,'% of Shares/Voting rights acquired',1,GETDATE())
,(16212, 'tra_grd_16212','Date of Acquisition','en-Us',103008,104003,122066,'Date of Acquisition',1,GETDATE())
,(16213, 'tra_grd_16213','Date of Intimation to Company','en-Us',103008,104003,122066,'Date of Intimation to Company',1,GETDATE())
,(16214, 'tra_grd_16214','Mode of Acquisition','en-Us',103008,104003,122066,'Mode of Acquisition',1,GETDATE())
,(16215, 'tra_grd_16215','Shareholding Subsequent to Acqusition','en-Us',103008,104003,122066,'Shareholding Subsequent to Acqusition',1,GETDATE())
,(16216, 'tra_grd_16216','Registration number of TM','en-Us',103008,104003,122066,'Registration number of TM',1,GETDATE())
,(16217, 'tra_grd_16217','Exchange','en-Us',103008,104003,122066,'Exchange',1,GETDATE())
,(16218, 'tra_grd_16218','Transaction Type','en-Us',103008,104003,122066,'Transaction Type',1,GETDATE())
,(16219, 'tra_grd_16219','Qty','en-Us',103008,104003,122066,'Qty',1,GETDATE())
,(16220, 'tra_grd_16220','Value','en-Us',103008,104003,122066,'Value',1,GETDATE())
,(16221, 'tra_grd_16221','Action','en-Us',103008,104003,122066,'Action',1,GETDATE())
,(16222, 'tra_grd_16222','Name, Address, Mobile Number','en-Us',103008,104003,122067,'Name, Address, Mobile Number',1,GETDATE())
,(16223, 'tra_grd_16223','PAN','en-Us',103008,104003,122067,'PAN',1,GETDATE())
,(16224, 'tra_grd_16224','Relation with insider','en-Us',103008,104003,122067,'Relation with insider',1,GETDATE())
,(16225, 'tra_grd_16225','Demat A/c No.','en-Us',103008,104003,122067,'Demat A/c No.',1,GETDATE())
,(16226, 'tra_grd_16226','No of Shares/Voting rights acquired','en-Us',103008,104003,122067,'No of Shares/Voting rights acquired',1,GETDATE())
,(16227, 'tra_grd_16227','% of Shares/Voting rights acquired','en-Us',103008,104003,122067,'% of Shares/Voting rights acquired',1,GETDATE())
,(16228, 'tra_grd_16228','Date of Acquisition','en-Us',103008,104003,122067,'Date of Acquisition',1,GETDATE())
,(16229, 'tra_grd_16229','Date of Intimation to Company','en-Us',103008,104003,122067,'Date of Intimation to Company',1,GETDATE())
,(16230, 'tra_grd_16230','Mode of Acquisition','en-Us',103008,104003,122067,'Mode of Acquisition',1,GETDATE())
,(16231, 'tra_grd_16231','Shareholding Subsequent to Acqusition','en-Us',103008,104003,122067,'Shareholding Subsequent to Acqusition',1,GETDATE())
,(16232, 'tra_grd_16232','Registration number of TM','en-Us',103008,104003,122067,'Registration number of TM',1,GETDATE())
,(16233, 'tra_grd_16233','Exchange','en-Us',103008,104003,122067,'Exchange',1,GETDATE())
,(16234, 'tra_grd_16234','Transaction Type','en-Us',103008,104003,122067,'Transaction Type',1,GETDATE())
,(16235, 'tra_grd_16235','Qty','en-Us',103008,104003,122067,'Qty',1,GETDATE())
,(16236, 'tra_grd_16236','Value','en-Us',103008,104003,122067,'Value',1,GETDATE())
,(16237, 'tra_grd_16237','Action','en-Us',103008,104003,122067,'Action',1,GETDATE())
,(16238, 'tra_grd_16238','Name, Address, Mobile Number','en-Us',103008,104003,122068,'Name, Address, Mobile Number',1,GETDATE())
,(16239, 'tra_grd_16239','PAN','en-Us',103008,104003,122068,'PAN',1,GETDATE())
,(16240, 'tra_grd_16240','Relation with insider','en-Us',103008,104003,122068,'Relation with insider',1,GETDATE())
,(16241, 'tra_grd_16241','Demat A/c No.','en-Us',103008,104003,122068,'Demat A/c No.',1,GETDATE())
,(16242, 'tra_grd_16242','No of Shares/Voting rights acquired','en-Us',103008,104003,122068,'No of Shares/Voting rights acquired',1,GETDATE())
,(16243, 'tra_grd_16243','% of Shares/Voting rights acquired','en-Us',103008,104003,122068,'% of Shares/Voting rights acquired',1,GETDATE())
,(16244, 'tra_grd_16244','Date of Acquisition','en-Us',103008,104003,122068,'Date of Acquisition',1,GETDATE())
,(16245, 'tra_grd_16245','Date of Intimation to Company','en-Us',103008,104003,122068,'Date of Intimation to Company',1,GETDATE())
,(16246, 'tra_grd_16246','Mode of Acquisition','en-Us',103008,104003,122068,'Mode of Acquisition',1,GETDATE())
,(16247, 'tra_grd_16247','Shareholding Subsequent to Acqusition','en-Us',103008,104003,122068,'Shareholding Subsequent to Acqusition',1,GETDATE())
,(16248, 'tra_grd_16248','Registration number of TM','en-Us',103008,104003,122068,'Registration number of TM',1,GETDATE())
,(16249, 'tra_grd_16249','Exchange','en-Us',103008,104003,122068,'Exchange',1,GETDATE())
,(16250, 'tra_grd_16250','Transaction Type','en-Us',103008,104003,122068,'Transaction Type',1,GETDATE())
,(16251, 'tra_grd_16251','Qty','en-Us',103008,104003,122068,'Qty',1,GETDATE())
,(16252, 'tra_grd_16252','Value','en-Us',103008,104003,122068,'Value',1,GETDATE())
,(16253, 'tra_grd_16253','Action','en-Us',103008,104003,122068,'Action',1,GETDATE())
,(16254, 'tra_grd_16254','Name, Address, Mobile Number','en-Us',103008,104003,122069,'Name, Address, Mobile Number',1,GETDATE())
,(16255, 'tra_grd_16255','PAN','en-Us',103008,104003,122069,'PAN',1,GETDATE())
,(16256, 'tra_grd_16256','Relation with insider','en-Us',103008,104003,122069,'Relation with insider',1,GETDATE())
,(16257, 'tra_grd_16257','Demat A/c No.','en-Us',103008,104003,122069,'Demat A/c No.',1,GETDATE())
,(16258, 'tra_grd_16258','No of Shares/Voting rights acquired','en-Us',103008,104003,122069,'No of Shares/Voting rights acquired',1,GETDATE())
,(16259, 'tra_grd_16259','% of Shares/Voting rights acquired','en-Us',103008,104003,122069,'% of Shares/Voting rights acquired',1,GETDATE())
,(16260, 'tra_grd_16260','Date of Acquisition','en-Us',103008,104003,122069,'Date of Acquisition',1,GETDATE())
,(16261, 'tra_grd_16261','Date of Intimation to Company','en-Us',103008,104003,122069,'Date of Intimation to Company',1,GETDATE())
,(16262, 'tra_grd_16262','Mode of Acquisition','en-Us',103008,104003,122069,'Mode of Acquisition',1,GETDATE())
,(16263, 'tra_grd_16263','Shareholding Subsequent to Acqusition','en-Us',103008,104003,122069,'Shareholding Subsequent to Acqusition',1,GETDATE())
,(16264, 'tra_grd_16264','Registration number of TM','en-Us',103008,104003,122069,'Registration number of TM',1,GETDATE())
,(16265, 'tra_grd_16265','Exchange','en-Us',103008,104003,122069,'Exchange',1,GETDATE())
,(16266, 'tra_grd_16266','Transaction Type','en-Us',103008,104003,122069,'Transaction Type',1,GETDATE())
,(16267, 'tra_grd_16267','Qty','en-Us',103008,104003,122069,'Qty',1,GETDATE())
,(16268, 'tra_grd_16268','Value','en-Us',103008,104003,122069,'Value',1,GETDATE())
,(16269, 'tra_grd_16269','Action','en-Us',103008,104003,122069,'Action',1,GETDATE())
,(16270, 'tra_grd_16270','Name, Address, Mobile Number','en-Us',103008,104003,122070,'Name, Address, Mobile Number',1,GETDATE())
,(16271, 'tra_grd_16271','PAN','en-Us',103008,104003,122070,'PAN',1,GETDATE())
,(16272, 'tra_grd_16272','Relation with insider','en-Us',103008,104003,122070,'Relation with insider',1,GETDATE())
,(16273, 'tra_grd_16273','Demat A/c No.','en-Us',103008,104003,122070,'Demat A/c No.',1,GETDATE())
,(16274, 'tra_grd_16274','No of Shares/Voting rights acquired','en-Us',103008,104003,122070,'No of Shares/Voting rights acquired',1,GETDATE())
,(16275, 'tra_grd_16275','% of Shares/Voting rights acquired','en-Us',103008,104003,122070,'% of Shares/Voting rights acquired',1,GETDATE())
,(16276, 'tra_grd_16276','Date of Acquisition','en-Us',103008,104003,122070,'Date of Acquisition',1,GETDATE())
,(16277, 'tra_grd_16277','Date of Intimation to Company','en-Us',103008,104003,122070,'Date of Intimation to Company',1,GETDATE())
,(16278, 'tra_grd_16278','Mode of Acquisition','en-Us',103008,104003,122070,'Mode of Acquisition',1,GETDATE())
,(16279, 'tra_grd_16279','Shareholding Subsequent to Acqusition','en-Us',103008,104003,122070,'Shareholding Subsequent to Acqusition',1,GETDATE())
,(16280, 'tra_grd_16280','Registration number of TM','en-Us',103008,104003,122070,'Registration number of TM',1,GETDATE())
,(16281, 'tra_grd_16281','Exchange','en-Us',103008,104003,122070,'Exchange',1,GETDATE())
,(16282, 'tra_grd_16282','Trnsaction Type','en-Us',103008,104003,122070,'Transaction Type',1,GETDATE())
,(16283, 'tra_grd_16283','Qty','en-Us',103008,104003,122070,'Qty',1,GETDATE())
,(16284, 'tra_grd_16284','Value','en-Us',103008,104003,122070,'Value',1,GETDATE())
,(16285, 'tra_grd_16285','Action','en-Us',103008,104003,122070,'Action',1,GETDATE())

INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(16286, 'tra_lbl_16286', 'Pre-Clearance Approved Qty:', 'Pre-Clearance Approved Qty:', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16287, 'tra_lbl_16287', 'Traded Qty:', 'Traded Qty:', 'en-US', 103008, 104002, 122036, 1 , GETDATE()),
(16288, 'tra_lbl_16288', 'Pending Qty:', 'Pending Qty:', 'en-US', 103008, 104002, 122036, 1 , GETDATE())

-- Add Resouce for template
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES	
-- communication mode - FAQ
(16289, 'tra_lbl_16289','FAQ For', 'FAQ For', 'en-US', 103008, 104002, 122050, 1, GETDATE()),
-- communication mode - Letter
(16290, 'tra_lbl_16290','Required', 'Required', 'en-US', 103008, 104002, 122050, 1, GETDATE()),
(16291, 'tra_lbl_16291','Optional', 'Optional', 'en-US', 103008, 104002, 122050, 1, GETDATE()),

(16292, 'tra_msg_16292', 'Error occurred while deciding preclearance required value.', 'Error occurred while deciding preclearance required value.', 'en-Us', 103008, 104001, 122036, 1 , GETDATE()),

-- Sent by GS on 10-Sep-2015
(16293, 'tra_lbl_16293', 'Pending Transactions', 'Pending Transactions', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16294, 'tra_lbl_16294', 'CO', 'CO', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16295, 'tra_lbl_16295', 'Insider', 'Insider', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16296, 'tra_lbl_16296', 'Initial Disclosures', 'Initial Disclosures', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16297, 'tra_lbl_16297', 'Pre-clearances', 'Pre-clearances', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16298, 'tra_lbl_16298', 'Trade details', 'Trade details', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16299, 'tra_lbl_16299', 'Continuous Disclosures', 'Continuous Disclosures', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16300, 'tra_lbl_16300', 'Submission to Stock Exchange', 'Submission to Stock Exchange', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16301, 'tra_lbl_16301', 'Period End Disclosures', 'Period End Disclosures', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16302, 'tra_lbl_16302', 'Pending Activities', 'Pending Activities', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16303, 'tra_lbl_16303', 'Policy Document Association to User', 'Policy Document Association to User', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16304, 'tra_lbl_16304', 'Trading Policy Association to User', 'Trading Policy Association to User', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16305, 'tra_lbl_16305', 'Login Credentials Mail to New User', 'Login Credentials Mail to New User', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16306, 'tra_lbl_16306', 'Defaulters', 'Defaulters', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16307, 'tra_lbl_16307', 'Trading Policy due for Expiry', 'Trading Policy due for Expiry', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16308, 'tra_lbl_16308', 'Policy Document due for Expiry', 'Policy Document due for Expiry', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16309, 'tra_lbl_16309', 'Trading Window Setting for Financial Result Declaration', 'Trading Window Setting for Financial Result Declaration ', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16310, 'tra_btn_16310', 'View Reports', 'View Reports', 'en-US', 103008, 104004, 122074, 1, GETDATE()),

/* Arundhati 19-Oct-2015 
resources for Defaulter count ON CO Dashboard */
(16311, 'tra_lbl_16311', 'Initial Disclosures', 'Initial Disclosures', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16312, 'tra_lbl_16312', 'Continuous Disclosures', 'Continuous Disclosures', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16313, 'tra_lbl_16313', 'Period End Disclosures', 'Period End Disclosures', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16314, 'tra_lbl_16314', 'Pre-clearances', 'Pre-clearances', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16315, 'tra_lbl_16315', 'Trading Plan', 'Trading Plan', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16316, 'tra_lbl_16316', 'Contra Trade', 'Contra Trade', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16317, 'tra_lbl_16317', 'Traded with Non designated demat account', 'Traded with Non designated demat account', 'en-US', 103008, 104002, 122074, 1, GETDATE()),
(16318, 'tra_lbl_16318', 'Defaulters', 'Defaulters', 'en-US', 103008, 104002, 122074, 1, GETDATE()),

(16319, 'tra_lbl_16319', 'Contract Specification', 'Contract Specification', 'en-US', 103008, 104002, 122036, 1, GETDATE()),
(16320,'tra_lbl_16320','Segregate ESOPs and Other than ESOPs Qty', 'Segregate ESOPs and Other than ESOPs Qty', 'en-US', 103008, 104002, 122036, 1, GETDATE()),
(16321,'tra_lbl_16321','ESOP Excercise Qty', 'ESOP Excercise Qty', 'en-US', 103008, 104002, 122036, 1, GETDATE()),
(16322,'tra_lbl_16322','Other than ESOP Excercise Qty', 'Other than ESOP Excercise Qty', 'en-US', 103008, 104002, 122036, 1, GETDATE()),
(16323,'tra_lbl_16323','ESOP Excercise Qty', 'ESOP Excercise Qty Flag', 'en-US', 103008, 104002, 122036, 1, GETDATE()),
(16324,'tra_lbl_16324','Other than ESOP Excercise Qty', 'Other than ESOP Excercise Qty Flag', 'en-US', 103008, 104002, 122036, 1, GETDATE()),
(16325,'tra_msg_16325','Enter maximum 50 character', 'Enter maximum 50 character', 'en-US', 103008, 104001, 122036, 1, GETDATE()),
(16326,'tra_msg_16326','Contract Specification field is required', 'Contract Specification field is required', 'en-US', 103008, 104001, 122036, 1, GETDATE()),

/*03-Dec-2015 Tushar */
(16327,'tra_msg_16327', 'Insufficient data in Exercise balance pool.', 'Insufficient data in Exercise balance pool.', 'en-US', 103008, 104001,122036, 1, GETDATE()),
(16328,'tra_msg_16328', 'Number of shares or Units must be sum of ESOP Excercise Qty and Other than ESOP Excercise Qty.', 'Number of shares or Units must be sum of ESOP Excercise Qty and Other than ESOP Excercise Qty.', 'en-US', 103008, 104001,122036, 1, GETDATE()),
(16329,'tra_msg_16329', 'Enter valid data for ESOP Excercise Qty and Other than ESOP Excercise Qty.', 'Enter valid data for ESOP Excercise Qty and Other than ESOP Excercise Qty.', 'en-US', 103008, 104001,122036, 1, GETDATE()),
(16330,'tra_msg_16330', 'Please select at least one option of exercise pool.', 'Please select at least one option of exercise pool.', 'en-US', 103008, 104001,122036, 1, GETDATE()),
(16331, 'tra_msg_16331','Transcation details entered should be for the applicable period.', 'Transcation details entered should be for the applicable period.', 'en-US', 103008, 104001, 122036, 1, GETDATE()),
/*
Script from Raghvendra on 11-03-2016
Resource added for showing the error message on the Transaction screen when DateOfIntemetion to company is greater than DateOfAcquisition, this is seen only by CO user when saving the transaction details for the insider
*/
(16332 ,'tra_msg_16332' ,'Date of intimation to company should be greater than or equal to Date of Acquisition','Date of intimation to company should be greater than or equal to Date of Acquisition' ,'en-US' ,103008 ,104001 ,122043 ,1 ,GETDATE())

/*
Added by : Raghvendra Date : 5-Apr-2016
Adding the override grids for Transaction data grids seen on the Create Letter screen.

Add column resources for each of the new grids added

Resources for grid type codeid 114083
*/
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES 
(16333 ,'tra_grd_16333' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16334 ,'tra_grd_16334' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16335 ,'tra_grd_16335' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16336 ,'tra_grd_16336' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16337 ,'tra_grd_16337' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16338 ,'tra_grd_16338' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16339 ,'tra_grd_16339' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16340 ,'tra_grd_16340' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16341 ,'tra_grd_16341' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16342 ,'tra_grd_16342' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16343 ,'tra_grd_16343' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16344 ,'tra_grd_16344' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16345 ,'tra_grd_16345' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16346 ,'tra_grd_16346' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16347 ,'tra_grd_16347' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16348 ,'tra_grd_16348' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),

/*
Resources for grid type codeid 114084
*/
(16349 ,'tra_grd_16349' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16350 ,'tra_grd_16350' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16351 ,'tra_grd_16351' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16352 ,'tra_grd_16352' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16353 ,'tra_grd_16353' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16354 ,'tra_grd_16354' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16355 ,'tra_grd_16355' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16356 ,'tra_grd_16356' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16357 ,'tra_grd_16357' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16358 ,'tra_grd_16358' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16359 ,'tra_grd_16359' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16360 ,'tra_grd_16360' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16361 ,'tra_grd_16361' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16362 ,'tra_grd_16362' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16363 ,'tra_grd_16363' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16364 ,'tra_grd_16364' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),

/*
Resources for grid type codeid 114085
*/
(16365 ,'tra_grd_16365' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16366 ,'tra_grd_16366' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16367 ,'tra_grd_16367' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16368 ,'tra_grd_16368' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16369 ,'tra_grd_16369' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16370 ,'tra_grd_16370' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16371 ,'tra_grd_16371' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16372 ,'tra_grd_16372' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16373 ,'tra_grd_16373' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16374 ,'tra_grd_16374' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16375 ,'tra_grd_16375' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16376 ,'tra_grd_16376' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16377 ,'tra_grd_16377' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16378 ,'tra_grd_16378' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16379 ,'tra_grd_16379' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16380 ,'tra_grd_16380' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),

/*
Resources for grid type codeid 114086
*/
(16381 ,'tra_grd_16381' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16382 ,'tra_grd_16382' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16383 ,'tra_grd_16383' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16384 ,'tra_grd_16384' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16385 ,'tra_grd_16385' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16386 ,'tra_grd_16386' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16387 ,'tra_grd_16387' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16388 ,'tra_grd_16388' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16389 ,'tra_grd_16389' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16390 ,'tra_grd_16390' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16391 ,'tra_grd_16391' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16392 ,'tra_grd_16392' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16393 ,'tra_grd_16393' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16394 ,'tra_grd_16394' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16395 ,'tra_grd_16395' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16396 ,'tra_grd_16396' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),

/*
Resources for grid type codeid 114087
*/
(16397 ,'tra_grd_16397' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16398 ,'tra_grd_16398' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16399 ,'tra_grd_16399' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16400 ,'tra_grd_16400' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16401 ,'tra_grd_16401' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16402 ,'tra_grd_16402' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16403 ,'tra_grd_16403' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16404 ,'tra_grd_16404' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16405 ,'tra_grd_16405' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16406 ,'tra_grd_16406' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16407 ,'tra_grd_16407' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16408 ,'tra_grd_16408' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16409 ,'tra_grd_16409' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16410 ,'tra_grd_16410' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16411 ,'tra_grd_16411' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16412 ,'tra_grd_16412' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),

/*
Resources for grid type codeid 114088
*/
(16413 ,'tra_grd_16413' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16414 ,'tra_grd_16414' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16415 ,'tra_grd_16415' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16416 ,'tra_grd_16416' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16417 ,'tra_grd_16417' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16418 ,'tra_grd_16418' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16419 ,'tra_grd_16419' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16420 ,'tra_grd_16420' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16421 ,'tra_grd_16421' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16422 ,'tra_grd_16422' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16423 ,'tra_grd_16423' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16424 ,'tra_grd_16424' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16425 ,'tra_grd_16425' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16426 ,'tra_grd_16426' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16427 ,'tra_grd_16427' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16428 ,'tra_grd_16428' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
/*
Add resource for default Trading Transaction grid
*/
(16429 ,'tra_grd_16429' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122036 ,1 ,GETDATE())

/*
Script from Tushar on 21 Apr 2016 -- for showing error message on validation negative balance
*/
INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
VALUES 
(16430,'tra_msg_16430', 'You cannot proceed these transaction quantity does not exist in the pool, you are missing some transaction or you enter more quantity than traded', 'You cannot proceed these transaction quantity does not exist in the pool, you are missing some transaction or you enter more quantity than traded', 'en-US', 103008, 104001,122036,1, GETDATE())


/*
Script from Parag on 4 May 2016 -- 
Add resource for auto submit transaction error messages
*/
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES 
(16431 ,'tra_msg_16431' ,'Error occured while auto submitting transaction' ,'Error occured while auto submitting transaction' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE()),
(16432 ,'tra_msg_16432' ,'Error occured while auto submitting transaction initial disclosure' ,'Error occured while auto submitting transaction initial disclosure' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE()),
/*
Script received from Parag on 12 May 2016 - Add resource for error messages when save user details on transaction details save
*/
(16433 ,'tra_msg_16433' ,'Error occured while saving user details for transaction details submitted' ,'Error occured while saving user details for transaction details submitted' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE()),
(16434 ,'tra_msg_16434' ,'Error occured while saving user details for form submitted' ,'Error occured while saving user details for form submitted' , 'en-US',103008 ,104001 ,122036 ,1 ,GETDATE()),
/*
Script from Parag on 16 May 2016 -  resources for grid type for employee details for policy document list
*/
(16435, 'tra_lbl_16435' ,'Employee' ,'Employee' , 'en-US', 103008, 104002, 122043, 1, GETDATE()),
(16436, 'tra_lbl_16436' ,'Employee ID' ,'Employee ID' , 'en-US', 103008, 104002, 122043, 1, GETDATE()),
(16437, 'tra_lbl_16437' ,'Name' ,'Name' , 'en-US', 103008, 104002, 122043, 1, GETDATE()),
(16438, 'tra_grd_16438' ,'Employee Id' ,'Employee Id' , 'en-US', 103008, 104002, 122043, 1, GETDATE()),
(16439, 'tra_grd_16439' ,'Name' ,'Name' , 'en-US', 103008, 104002, 122043, 1, GETDATE()),
(16440, 'tra_grd_16440' ,'Designation' ,'Designation' , 'en-US', 103008, 104002, 122043, 1, GETDATE()),
(16441, 'tra_grd_16441' ,'Document Viewed' ,'Document Viewed' , 'en-US', 103008, 104002, 122043, 1, GETDATE()),
(16442, 'tra_grd_16442' ,'Document Accepted' ,'Document Accepted' , 'en-US', 103008, 104002, 122043, 1, GETDATE()),
/*
Script from Parag on 25 May 2016 -  resources for error message for security post acquisition on transcation details page
*/
(16443, 'tra_msg_16443' ,'Can not trade more then security held' ,'Can not trade more then security held' , 'en-US', 103008, 104001, 122036, 1, GETDATE()),
/*
	Script received from Tushar 9 Aug 2016
*/
(16444, 'tra_msg_16444', 'Error occurred while checking negative balance for secuirty.', 'Error occurred while checking negative balance for secuirty.', 'en-US', 103008, 104001, 122036, 1, GETDATE())



INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(17001, 'dis_lbl_17001', 'Initial Disclosures', 'Initial Disclosure', 'en-Us', 103009, 104002, 122044, 1 , GETDATE()),
(17002, 'dis_lbl_17002', 'Create Letter and Submit Soft Copy', 'Soft Copy Submission Status', 'en-Us', 103009, 104002, 122044, 1 , GETDATE()),
(17003, 'dis_lbl_17003', 'Upload and Submit Scanned Copy', 'Hard Copy Submission Status', 'en-Us', 103009, 104002, 122044, 1 , GETDATE()),
(17004, 'dis_lbl_17004', 'Submission to Exchange Status', 'Submission to Exchange Status', 'en-Us', 103009, 104002, 122044, 1 , GETDATE()),
(17005, 'dis_btn_17005', 'Pending', 'Pending', 'en-Us', 103009, 104004, 122044, 1 , GETDATE()),
(17006, 'dis_btn_17006', 'Viewed', 'Viewed', 'en-Us', 103009, 104004, 122044, 1 , GETDATE()),
(17007, 'dis_btn_17007', 'Accepted', 'Agreed', 'en-Us', 103009, 104004, 122044, 1 , GETDATE()),
(17008, 'dis_msg_17008', 'Error occurred while fetching initial disclosure statuses.', 'Error occurred while fetching initial disclosure statuses.', 'en-Us', 103009, 104001, 122044, 1 , GETDATE()),
(17009, 'dis_btn_17009', 'Done', 'Done', 'en-Us', 103009, 104004, 122044, 1 , GETDATE()),
(17010, 'dis_grd_17010', 'Submission Period', 'Period', 'en-Us', 103009, 104003, 122047, 1 , GETDATE()),
(17011, 'dis_grd_17011', 'Submission required till Date', 'Submission required till Date', 'en-Us', 103009, 104003, 122047, 1 , GETDATE()),
(17012, 'dis_grd_17012', 'Submission Details', 'Submitted Details', 'en-Us', 103009, 104003, 122047, 1 , GETDATE()),
(17013, 'dis_msg_17013', 'You cannot submit Initial Disclosures since Policy Document has not been associated. Please contact the Administrator.   ', 'No Policy document is applicable, please contact administrator. Initial disclosures cannot be done without it.', 'en-Us', 103009, 104001, 122044, 1 , GETDATE()),
(17014, 'dis_grd_17014', 'Pre Clearance ID', 'ID', 'en-US', 103009, 104003, 122046, 1 , GETDATE()),
(17015, 'dis_grd_17015', 'Request For', 'Request For', 'en-US', 103009, 104003, 122046, 1 , GETDATE()),
(17016, 'dis_grd_17016', 'Request Date', 'Request Date', 'en-US', 103009, 104003, 122046, 1 , GETDATE()),
(17017, 'dis_grd_17017', 'PreClearance Status', 'Status', 'en-US', 103009, 104003, 122046, 1 , GETDATE()),
(17018, 'dis_grd_17018', 'Transaction Type', 'Transaction', 'en-US', 103009, 104003, 122046, 1 , GETDATE()),
(17019, 'dis_grd_17019', 'Securities', 'Securities', 'en-US', 103009, 104003, 122046, 1 , GETDATE()),
(17020, 'dis_grd_17020', 'Trading Details Submission', 'Trading Details Submitted', 'en-US', 103009, 104003, 122046, 1 , GETDATE()),
(17021, 'dis_grd_17021', 'Disclosure Details Submission:  Softcopy', 'Disclosure Details Submitted Softcopy', 'en-US', 103009, 104003, 122046, 1 , GETDATE()),
(17022, 'dis_grd_17022', 'Disclosure Details Submission: Hardcopy', 'Disclosure Details Submitted Hardcopy', 'en-US', 103009, 104003, 122046, 1 , GETDATE()),
(17023, 'dis_btn_17023', 'Approved', 'Approved', 'en-US', 103009, 104004, 122046, 1 , GETDATE()),
(17024, 'dis_btn_17024', 'Rejected', 'Rejected', 'en-US', 103009, 104004, 122046, 1 , GETDATE()),
(17025, 'dis_btn_17025', 'Partially Traded', 'Partially Traded', 'en-US', 103009, 104004, 122046, 1 , GETDATE()),
(17026, 'dis_btn_17026', 'Uploaded', 'Uploaded', 'en-US', 103009, 104004, 122046, 1 , GETDATE()),
(17027, 'dis_lbl_17027', 'days remaining for submission', 'days remaining for submission', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17028, 'dis_lbl_17028', 'Valid till', 'valid till', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17029, 'dis_lbl_17029', 'Error occurred while fetching PreClearance list', 'Error occurred while fetching PreClearance list', 'en-US', 103009, 104001, 122046, 1 , GETDATE()),
(17030, 'dis_grd_17030', 'Submission: Softcopy', 'Submitted Softcopy', 'en-US', 103009, 104003, 122047, 1 , GETDATE()),
(17031, 'dis_grd_17031', 'Submission: Hardcopy', 'Submitted Hardcopy', 'en-US', 103009, 104003, 122047, 1 , GETDATE()),
(17032, 'dis_grd_17032', 'Submitted to Stock Exchange', 'Submitted to Stock Exchange', 'en-US', 103009, 104003, 122047, 1 , GETDATE()),
(17033, 'dis_grd_17033', 'Company', 'Company', 'en-US', 103009, 104003, 122048, 1 , GETDATE()),
(17034, 'dis_grd_17034', 'Insider Name', 'Insider Name', 'en-US', 103009, 104003, 122048, 1 , GETDATE()),
(17035, 'dis_grd_17035', 'Relation', 'Relation', 'en-US', 103009, 104003, 122048, 1 , GETDATE()),
(17036, 'dis_grd_17036', 'Security Type', 'Security Type', 'en-US', 103009, 104003, 122048, 1 , GETDATE()),
(17037, 'dis_grd_17037', 'Holdings at beginning of the period', 'Opening Stock', 'en-US', 103009, 104003, 122048, 1 , GETDATE()),
(17038, 'dis_grd_17038', 'Bought during the period', 'Bought', 'en-US', 103009, 104003, 122048, 1 , GETDATE()),
(17039, 'dis_grd_17039', 'Sold during the period', 'Sold', 'en-US', 103009, 104003, 122048, 1 , GETDATE()),
(17040, 'dis_grd_17040', 'Holdings at end of the period', 'Holding at Period End', 'en-US', 103009, 104003, 122048, 1 , GETDATE()),
(17041, 'dis_msg_17041', 'Error occurred while fetching Period End Disclosure summary.', 'Error occurred while fetching Period End Disclosure summary.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17042, 'dis_msg_17042', 'Error occurred while validating transaction details entry.', 'Error occurred while validating transaction entry.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17043, 'dis_msg_17043', 'Error occurred while validating transaction master entry.', 'Error occurred while validating transaction entry.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17044, 'dis_msg_17044', 'Transaction mode can only be Buy for initial disclosure.', 'Transaction mode can only be Buy for initial disclosure.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17045, 'dis_msg_17045', 'Security Type, User and transaction should be same as that defined in preclearance request.', 'Security Type, User and transaction should be same as that defined in preclearance request.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17046, 'dis_msg_17046', 'Total number of trading quantity should not exceed the proposed trade quantity specified in the preclearance request.', 'Total number of trading quantity should not exceed the proposed trade quantity specified in the preclearance request.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17047, 'dis_msg_17047', 'All the transactions entered together should be for the same period.', 'All the transactions entered together should be for the same period.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17048, 'dis_msg_17048', 'Cannot save details for continuous disclosure, since period end disclosure for the future period is entered.', 'Cannot save details for continuous disclosure, since period end disclosure for the future period is entered.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17049, 'dis_msg_17049', 'Cannot save/submit Period End disclosure, since continuous disclosure is made for the date after period end date.', 'Cannot save/submit Period End disclosure, since continuous disclosure is made for the date after period end date.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17050, 'dis_msg_17050', 'Cannot save/submit Period End disclosure, since period end disclosure for the same or future period is already entered.', 'Cannot save/submit Period End disclosure, since period end disclosure for the same or future period is already entered.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17051, 'dis_msg_17051', 'Cannot save continuous or period end disclosure, as Initial disclsure is not submitted.', 'Cannot save continuous or period end disclosure, as Initial disclsure is not submitted.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17052, 'dis_msg_17052', 'Error occurred while fetching list of period end disclosure period status.', 'Error occurred while fetching list of period end disclosure period status.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17053, 'dis_msg_17053', 'Error occurred while fetching current disclosure year code.', 'Error occurred while fetching current disclosure year code.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17054, 'dis_msg_17054', 'Error occurred while calculating start and end date of the period.', 'Error occurred while calculating start and end date of the period.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17055, 'dis_ttl_17055', 'Period End Disclosuress', 'Period End Disclosures', 'en-US', 103009, 104006, 122047, 1 , GETDATE()),
(17056, 'dis_lbl_17056', 'Financial Year', 'Financial Year', 'en-US', 103009, 104001, 122047, 1 , GETDATE()),
(17057, 'dis_ttl_17057', 'Period End Disclosuress', 'Period End Disclosures', 'en-US', 103009, 104006, 122048, 1 , GETDATE()),
(17058, 'dis_lbl_17058', 'Period:', 'Period:', 'en-US', 103009, 104001, 122048, 1 , GETDATE()),
(17059, 'dis_btn_17059', 'Add More Transactions', 'View and Add More Transaction', 'en-US', 103009, 104004, 122001, 1 , GETDATE()),
(17060, 'dis_msg_17060', 'Cannot save/submit transaction details, as preclearance request is rejected.', 'Cannot save/submit transaction details, as preclearance request is rejected.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17061, 'dis_lbl_17061', 'I have read and understood the terms and conditions of the Code of Conduct and undertake to comply with the provisions of the Insider Trading Regulations', 'I hereby accept terms and conditions', 'en-US', 103009, 104002, 122048, 1 , GETDATE()),
(17062, 'dis_btn_17062', 'Accept', 'Accept', 'en-US', 103009, 104004, 122048, 1 , GETDATE()),
(17063, 'dis_lbl_17063', 'Pre-Clearance ID', 'Pre-Clearance ID', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17064, 'dis_lbl_17064', 'Request Status', 'Request Status', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17065, 'dis_lbl_17065', 'Transaction Type', 'Transaction Type', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17066, 'dis_lbl_17066', 'Trade Details', 'Trade Details', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17067, 'dis_lbl_17067', 'Submission Date From', 'Submission Date From', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17068, 'dis_lbl_17068', 'Submission Date To', 'Submission Date To', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17069, 'dis_lbl_17069', 'Disclosure Details Softcopy', 'Disclosure Details Softcopy', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17070, 'dis_lbl_17070', 'Disclosure Details Hardcopy', 'Disclosure Details Hardcopy', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17071, 'dis_btn_17071', 'Create Pre-Clearance Request', 'Create Pre-Clearance Request', 'en-US', 103009, 104004, 122046, 1 , GETDATE()),
(17072, 'dis_btn_17072', 'Pre-Clearance not taken? Submit your Disclosures', 'Pre-Clearance Not taken? Submit your Disclosure', 'en-US', 103009, 104004, 122046, 1 , GETDATE()),
(17073, 'dis_btn_17073', 'Partially Traded', 'Partially Traded', 'en-US', 103009, 104004, 122046, 1 , GETDATE()),
(17074, 'dis_btn_17074', 'Not Traded', 'Not Traded', 'en-US', 103009, 104004, 122046, 1 , GETDATE()),
(17075, 'dis_btn_17075', 'Uploaded', 'Uploaded', 'en-US', 103009, 104004, 122046, 1 , GETDATE()),
(17076, 'dis_ttl_17076', 'Preclearance Request', 'PRECLEARANCE REQUEST', 'en-US', 103009, 104006, 122046, 1 , GETDATE()),
(17077, 'dis_lbl_17077', 'Self', 'Self', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17078, 'dis_lbl_17078', 'Relative', 'Relative', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17079, 'dis_lbl_17079', 'If Relatives', 'If Relatives', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17080, 'dis_lbl_17080', 'Date of Pre-Clearance ', 'Date of Pre-Clearance : ', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17081, 'dis_lbl_17081', 'Transaction', 'Transaction', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17082, 'dis_lbl_17082', 'Type of secuity to be traded', 'Type of secuity to be traded', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17083, 'dis_lbl_17083', 'Securities proposed to be traded', 'Securities proposed to be traded', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17084, 'dis_lbl_17084', 'For Company', 'For Company', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17085, 'dis_lbl_17085', 'Proposed trade rate range: From', 'Proposed trade rate range from', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17086, 'dis_lbl_17086', 'To', 'To', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17087, 'dis_lbl_17087', 'Demat Account Number', 'Demat Account Number', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17088, 'dis_lbl_17088', 'I hereby certify that :- I do not have any access or have not unpublished price sensitive information up to the time of signing this letter. - The proposed Trade(s) do not violate the Securities and Exchange Board of India (Prohibition of Insider Trading) Regulation, 1992; - In case if, I have Access to or receive any unpublished price sensitive information after The signing of this letter, but before the execution of the transaction, I shall Inform the Compliance officer accordingly and would completely refrain From dealing in the shares of the Company till the time such information becomes public . - I have not contravened the code of conduct for prevention of Insider Trading as notified by the Company from time to time. - The disclosure Made above is full and true disclosure.', 'I hereby certify that :- I do not have any access or have not unpublished price sensitive information up to the time of signing this letter. - The proposed Trade(s) do not violate the Securities and Exchange Board of India (Prohibition of Insider Trading) Regulation, 1992; - In case if, I have Access to or receive any unpublished price sensitive information after The signing of this letter, but before the execution of the transaction, I shall Inform the Compliance officer accordingly and would completely refrain From dealing in the shares of the Company till the time such information becomes public . - I have not contravened the code of conduct for prevention of Insider Trading as notified by the Company from time to time. - The disclosure Made above is full and true disclosure.', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17089, 'dis_btn_17089', 'Confirm', 'Confirm', 'en-US', 103009, 104004, 122051, 1 , GETDATE()),
(17090, 'dis_btn_17090', 'Proceed', 'Proceed', 'en-US', 103009, 104004, 122051, 1 , GETDATE()),
(17091, 'dis_btn_17091', 'Add New Demat Account ', 'New Demat Account - ADD', 'en-US', 103009, 104004, 122051, 1 , GETDATE()),
(17092, 'dis_msg_17092', 'Are you sure want to submit the Pre-Clearance request?', 'Are you sure want to confirm PRE-CLEARANCE Request?', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17093, 'dis_msg_17093', 'You have to submit trading details and disclosures within $1 days after preclearance request approval is received.    If you do not trade, please submit the reason for not trading  within the same time period.', 'You have to submit the trading details and disclosure within $1 days after preclearance request approval is received.  If NOT TRADED, submit the reason for not trading within the same time period.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17094, 'dis_msg_17094', 'Please Select User Relative field', 'Please Select User Relative field', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17095, 'dis_msg_17095', 'Please accept the terms and conditions to submit your Pre Clearance request.', 'Please agree the terms and conditions', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17096, 'dis_msg_17096', 'PreClearance Request ID not found.', 'PreClearance Request ID not found.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17097, 'dis_msg_17097', 'Error occurred while fetching list of PreClearance Request/Disclosure details.', 'Error occurred while fetching list of PreClearance Request/Disclosure details.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17098, 'dis_msg_17098', 'Error occurred while fetching PreClearance Request details.', 'Error occurred while fetching PreClearance Request details.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17099, 'dis_msg_17099', 'Error occurred while saving PreClearance Request', 'Error occurred while saving PreClearance Request', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17100, 'dis_btn_17100', 'Preclearance Request Saved Successfully', 'Preclearance Request Save Successfully', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17101, 'dis_ttl_17101', 'Create Letter', 'Create Letter', 'en-US', 103009, 104006, 122052, 1 , GETDATE()),
(17102, 'dis_ttl_17102', 'Soft copy of letter', 'Soft Copy', 'en-US', 103009, 104006, 122052, 1 , GETDATE()),
(17103, 'dis_ttl_17103', 'Upload signed scanned copy', 'Hard Copy', 'en-US', 103009, 104006, 122052, 1 , GETDATE()),
(17104, 'dis_lbl_17104', 'Company Logo', 'Company Logo', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17105, 'dis_lbl_17105', 'Date', 'Date', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17106, 'dis_lbl_17106', 'To Address1', 'To Address1', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17107, 'dis_lbl_17107', 'To Address2', 'To Address2', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17108, 'dis_lbl_17108', 'Subject', 'Subject', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17109, 'dis_lbl_17109', 'Content', 'Content', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17110, 'dis_lbl_17110', 'Signature', 'Signature', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17111, 'dis_btn_17111', 'Print', 'Print', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17112, 'dis_msg_17112', 'Error occurred while fetching transaction letter details.', 'Error occurred while fetching transaction letter details.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17113, 'dis_msg_17113', 'Transaction Letter Details does not exist.', 'Transaction Letter Details does not exist.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17114, 'dis_msg_17114', 'Reference template is not defined by the CO. Please contact administrator.', 'Reference template is not defined by the CO. Please contact administrator.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17115, 'dis_msg_17115', 'Error occurred while saving letter for the disclosure.', 'Error occurred while saving letter for the disclosure', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17116, 'dis_msg_17116', 'Transaction letter details does not exist.', 'Transaction letter details does not exist.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17117, 'dis_lbl_17117', 'Are you sure you want to submit the soft copy of the letter and disclosures?', 'Are you sure you want to submit the soft copy of the letter and disclosures?', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17118, 'dis_lbl_17118', 'Are you sure you want to submit the hard copy of the letter and disclosures?', 'Are you sure you want to submit the hard copy of the letter and disclosures?', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17119, 'dis_lbl_17119', 'Hard Copy document has not been uploaded', 'No Hard Copy document is uploaded', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17120, 'dis_lbl_17120', 'FORM B', 'FORM B', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17121, 'dis_lbl_17121', 'SEBI (Prohibition of Insider Trading) Regulations, 2015', 'SEBI (Prohibition of Insider Trading) Regulations, 2015', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17122, 'dis_lbl_17122', '[Regulation 7 (1) (b) read with Regulation 6(2) - Disclosure on becoming a director/KMP/Promoter]', '[Regulation 7 (1) (b) read with Regulation 6(2) - Disclosure on becoming a director/KMP/Promoter]', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17123, 'dis_lbl_17123', 'Name of the Company', 'Name of the Company', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17124, 'dis_lbl_17124', 'ISIN of the Company', 'ISIN of the Company', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17125, 'dis_lbl_17125', 'Details of Securities held on appointment of Key Managerial Personnel (KMP) or Director or upon becoming a Promoter of a listed company and other such persons as mentioned in Regulation 6(2).', 'Details of Securities held on appointment of Key Managerial Personnel (KMP) or Director or upon becoming a Promoter of a listed company and other such persons as mentioned in Regulation 6(2).', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17126, 'dis_lbl_17126', 'Note: "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.', 'Note: "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17127, 'dis_lbl_17127', 'Signature:', 'Signature:', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17128, 'dis_lbl_17128', 'Designation:', 'Designation:', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17129, 'dis_lbl_17129', 'Date:', 'Date:', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17130, 'dis_lbl_17130', 'Place:', 'Place:', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17131, 'dis_grd_17131', 'Name, PAN, CIN/DIN & Address with contact nos.', 'Name, PAN, CIN/DIN & Address with contact nos.', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17132, 'dis_grd_17132', 'Category of Person (Promoters/KMP/Directors/immediate relative to/others etc.)', 'Category of Person (Promoters/KMP/Directors/immediate relative to/others etc.)', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17133, 'dis_grd_17133', 'Date of appointment of Director/ KMP OR Date of becoming Promoter', 'Date of appointment of Director/ KMP OR Date of becoming Promoter', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17134, 'dis_grd_17134', 'Securities held at the time of becoming Promoter/ appointment of Director/ KMP', 'Securities held at the time of becoming Promoter/ appointment of Director/ KMP', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17135, 'dis_grd_17135', 'Type of security (For e.g. ñ Shares, Warrants, Convertible Debentures etc.)', 'Type of security (For e.g. ñ Shares, Warrants, Convertible Debentures etc.)', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17136, 'dis_grd_17136', 'Number', 'No.', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17137, 'dis_grd_17137', '% of Shareholding', '% of Shareholding', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17138, 'dis_grd_17138', 'Open Interest of the Future contracts held at the time of becoming Promoter/appointment of Director/ KMP', 'Open Interest of the Future contracts held at the time of becoming Promoter/appointment of Director/ KMP', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17139, 'dis_grd_17139', 'Number of units (contracts * lot size)', 'Number of units (contracts * lot size)', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17140, 'dis_grd_17140', 'Notional value in Rupee terms', 'Notional value in Rupee terms', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17141, 'dis_grd_17141', 'Open Interest of the Option contracts held at the time of becoming Promoter/appointment of Director/ KMP', 'Open Interest of the Option contracts held at the time of becoming Promoter/appointment of Director/ KMP', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17142, 'dis_grd_17142', 'Number of units (contracts * lot size)', 'Number of units (contracts * lot size)', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17143, 'dis_grd_17143', 'Notional value in Rupee terms', 'Notional value in Rupee terms', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17144, 'dis_ttl_17144', 'Period End Disclosuress', 'Period End Disclosures', 'en-US', 103009, 104006, 122055, 1 , GETDATE()),
(17145, 'dis_lbl_17145', 'Financial year', 'Financial year', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17146, 'dis_lbl_17146', 'Period', 'Period', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17147, 'dis_lbl_17147', 'Employee Id', 'Employee Id', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17148, 'dis_lbl_17148', 'Name', 'Insider Name', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17149, 'dis_lbl_17149', 'Designation', 'Designation', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17150, 'dis_lbl_17150', 'Trading Submission From', 'Trading Submission From', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17151, 'dis_lbl_17151', 'Trading Submission To', 'Trading Submission To', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17152, 'dis_lbl_17152', 'Trading Submission Status', 'Trading Submission Status', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17153, 'dis_lbl_17153', 'Soft Copy Submission From', 'Soft Copy Submission From', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17154, 'dis_lbl_17154', 'Soft Copy Submission To', 'Soft Copy Submission To', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17155, 'dis_lbl_17155', 'Soft Copy Submission Status', 'Soft Copy Submission Status', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17156, 'dis_lbl_17156', 'Hard Copy Submission From', 'Hard Copy Submission From', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17157, 'dis_lbl_17157', 'Hard Copy Submission To', 'Hard Copy Submission To', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17158, 'dis_lbl_17158', 'Hard Copy Submission Status', 'Hard Copy Submission Status', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17159, 'dis_lbl_17159', 'Stock Exchange Submission From', 'Stock Exchange Submission From', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17160, 'dis_lbl_17160', 'Stock Exchange Submission To', 'Stock Exchange Submission To', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17161, 'dis_lbl_17161', 'Stock Exchange Submission Status', 'Stock Exchange Submission Status', 'en-US', 103009, 104002, 122055, 1 , GETDATE()),
(17162, 'dis_grd_17162', 'Employee Id', 'Employee Id', 'en-US', 103009, 104003, 122055, 1 , GETDATE()),
(17163, 'dis_grd_17163', 'Name', 'Insider Name', 'en-US', 103009, 104003, 122055, 1 , GETDATE()),
(17164, 'dis_grd_17164', 'Designation', 'Designation', 'en-US', 103009, 104003, 122055, 1 , GETDATE()),
(17165, 'dis_grd_17165', 'Submission required till Date', 'Submission required till Date', 'en-US', 103009, 104003, 122055, 1 , GETDATE()),
(17166, 'dis_grd_17166', 'Submission Details', 'Submitted Details', 'en-US', 103009, 104003, 122055, 1 , GETDATE()),
(17167, 'dis_grd_17167', 'Submission Details: Softcopy', 'Submitted Softcopy', 'en-US', 103009, 104003, 122055, 1 , GETDATE()),
(17168, 'dis_grd_17168', 'Submission Details:Hardcopy', 'Submitted Hardcopy', 'en-US', 103009, 104003, 122055, 1 , GETDATE()),
(17169, 'dis_grd_17169', 'Submission to Stock Exchange', 'Submitted to Stock Exchange', 'en-US', 103009, 104003, 122055, 1 , GETDATE()),
(17170, 'dis_lbl_17170', 'Employee Id', 'Employee Id', 'en-US', 103009, 104002, 122048, 1 , GETDATE()),
(17171, 'dis_lbl_17171', 'Name', 'Insider Name', 'en-US', 103009, 104002, 122048, 1 , GETDATE()),
(17172, 'dis_msg_17172', 'Error occurred while fetching current disclosure period code.', 'Error occurred while fetching current disclosure period code.', 'en-US', 103009, 104001, 122055, 1 , GETDATE()),
(17173, 'dis_msg_17173', 'Error occurred while fetching users list of period end disclosure.', 'Error occurred while fetching users list of period end disclosure.', 'en-US', 103009, 104001, 122055, 1 , GETDATE()),
(17174, 'dis_msg_17174', 'Cannot save/submit transaction details, as it is already submitted.', 'Cannot save/submit transaction details, as it is already submitted.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17175, 'dis_lbl_17175', 'FORM C', 'FORM C', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17176, 'dis_lbl_17176', 'SEBI (Prohibition of Insider Trading) Regulations, 2015', 'SEBI (Prohibition of Insider Trading) Regulations, 2015', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17177, 'dis_lbl_17177', '[Regulation 7 (2) read with Regulation 6(2) - Continual disclosure]', '[Regulation 7 (2) read with Regulation 6(2) - Continual disclosure]', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17178, 'dis_lbl_17178', 'Name of the Company', 'Name of the Company', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17179, 'dis_lbl_17179', 'ISIN of the Company', 'ISIN of the Company', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17180, 'dis_lbl_17180', 'Details of change in holding of Securities of Promoter, Employee or Director of a listed company and other such persons as mentioned in Regulation 6(2).', 'Details of change in holding of Securities of Promoter, Employee or Director of a listed company and other such persons as mentioned in Regulation 6(2).', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17181, 'dis_lbl_17181', 'Note: "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.', 'Note: "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17182, 'dis_lbl_17182', 'FORM D (Indicative format)', 'FORM D (Indicative format)', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17183, 'dis_lbl_17183', 'SEBI (Prohibition of Insider Trading) Regulations, 2015', 'SEBI (Prohibition of Insider Trading) Regulations, 2015', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17184, 'dis_lbl_17184', 'Regulation 7(3) - Transactions by Other connected persons as identified by the company', 'Regulation 7(3) - Transactions by Other connected persons as identified by the company', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17185, 'dis_lbl_17185', 'Note: "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.', 'Note: "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17186, 'dis_lbl_17186', 'Name', 'Name', 'en-US', 103009, 104002, 122052, 1 , GETDATE()),
(17187,'dis_grd_17187','Name,PAN,CIN/DIN,& address with contact nos.','Name,PAN,CIN/DIN,& address with contact nos.','en-US',103009,104002,122052,1,GETDATE()),
(17188,'dis_grd_17188','Category of Person (Promoters/ KMP/ Directors/ immediate relative to/ others etc.)','Category of Person (Promoters/ KMP/ Directors/ immediate relative to/ others etc.)','en-US',103009,104002,122052,1,GETDATE()),
(17189,'dis_grd_17189','Securities held prior to acquisition/ disposal','Securities held prior to acquisition/ disposal','en-US',103009,104002,122052,1,GETDATE()),
(17190,'dis_grd_17190','Type of security (For eg. ñ Shares, Warrants, Convertible Debentures etc.)','Type of security (For eg. ñ Shares, Warrants, Convertible Debentures etc.)','en-US',103009,104002,122052,1,GETDATE()),
(17191,'dis_grd_17191','No. and % of shareholding','No. and % of shareholding','en-US',103009,104002,122052,1,GETDATE()),
(17192,'dis_grd_17192','Securities acquired/ Disposed','Securities acquired/ Disposed','en-US',103009,104002,122052,1,GETDATE()),
(17193,'dis_grd_17193','Type of security (For eg. ñ Shares, Warrants, Convertible Debentures etc.)','Type of security (For eg. ñ Shares, Warrants, Convertible Debentures etc.)','en-US',103009,104002,122052,1,GETDATE()),
(17194,'dis_grd_17194','No.','No.','en-US',103009,104002,122052,1,GETDATE()),
(17195,'dis_grd_17195','Value','Value','en-US',103009,104002,122052,1,GETDATE()),
(17196,'dis_grd_17196','Transaction Type (Buy/ Sale/ Pledge/ Revoke/ Invoke)','Transaction Type (Buy/ Sale/ Pledge/ Revoke/ Invoke)','en-US',103009,104002,122052,1,GETDATE()),
(17197,'dis_grd_17197','Securities held post acquisition/ disposal','Securities held post acquisition/ disposal','en-US',103009,104002,122052,1,GETDATE()),
(17198,'dis_grd_17198','Type of security (For eg. ñ Shares, Warrants, Convertible Debentures etc.)','Type of security (For eg. ñ Shares, Warrants, Convertible Debentures etc.)','en-US',103009,104002,122052,1,GETDATE()),
(17199,'dis_grd_17199','No. and % of shareholding','No. and % of shareholding','en-US',103009,104002,122052,1,GETDATE()),
(17200,'dis_grd_17200','Date of allotment advice/ acquisition of shares/ sale of shares specify','Date of allotment advice/ acquisition of shares/ sale of shares specify','en-US',103009,104002,122052,1,GETDATE()),
(17201,'dis_grd_17201','From','From','en-US',103009,104002,122052,1,GETDATE()),
(17202,'dis_grd_17202','To','To','en-US',103009,104002,122052,1,GETDATE()),
(17203, 'dis_grd_17203', 'Trading in derivatives (Specify type of contract, Futures or Options etc)', 'Trading in derivatives (Specify type of contract, Futures or Options etc)', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17204, 'dis_grd_17204', 'Transaction Type', 'Transaction Type', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17205, 'dis_grd_17205', 'Type of contract', 'Type of contract', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17206, 'dis_grd_17206', 'Notional Value', 'Notional Value', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17207, 'dis_grd_17207', 'Number of units (contracts * lot size)', 'Number of units (contracts * lot size)', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17208, 'dis_grd_17208', 'Exchange on which the trade was executed', 'Exchange on which the trade was executed', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17209,'dis_grd_17209','Name,PAN,CIN/DIN,& address with contact nos. of other connected persons as identified by the company','Name,PAN,CIN/DIN,& address with contact nos. of other connected persons as identified by the company','en-US',103009,104002,122052,1,GETDATE()),
(17210,'dis_grd_17210','Connection with company','Connection with company','en-US',103009,104002,122052,1,GETDATE()),
(17211,'dis_grd_17211','Securities held prior to acquisition/ disposal','Securities held prior to acquisition/ disposal','en-US',103009,104002,122052,1,GETDATE()),
(17212,'dis_grd_17212','Type of security (For eg.ñ Shares,Warrants, Convertible Debentures etc.)','Type of security (For eg.ñ Shares,Warrants, Convertible Debentures etc.)','en-US',103009,104002,122052,1,GETDATE()),
(17213,'dis_grd_17213','No. and % of shareholding','No. and % of shareholding','en-US',103009,104002,122052,1,GETDATE()),
(17214,'dis_grd_17214','Securities acquired/ Disposed','Securities acquired/ Disposed','en-US',103009,104002,122052,1,GETDATE()),
(17215,'dis_grd_17215','Type of security (For eg.ñ Shares, Warrants, Convertible Debentures etc.)','Type of security (For eg.ñ Shares, Warrants, Convertible Debentures etc.)','en-US',103009,104002,122052,1,GETDATE()),
(17216,'dis_grd_17216','No','No','en-US',103009,104002,122052,1,GETDATE()),
(17217,'dis_grd_17217','Value','Value','en-US',103009,104002,122052,1,GETDATE()),
(17218,'dis_grd_17218','Transaction Type (Buy/ Sale/ Pledge/ Revoke/ Invoke)','Transaction Type (Buy/ Sale/ Pledge/ Revoke/ Invoke)','en-US',103009,104002,122052,1,GETDATE()),
(17219,'dis_grd_17219','Securities held post acquisition/ disposal','Securities held post acquisition/ disposal','en-US',103009,104002,122052,1,GETDATE()),
(17220,'dis_grd_17220','Type of security (For eg. ñ Shares, Warrants, Convertible Debentures etc.)','Type of security (For eg. ñ Shares, Warrants, Convertible Debentures etc.)','en-US',103009,104002,122052,1,GETDATE()),
(17221,'dis_grd_17221','No. and % of shareholding','No. and % of shareholding','en-US',103009,104002,122052,1,GETDATE()),
(17222,'dis_grd_17222','Date of allotment advice/ acquisition of shares/ sale of shares specify','Date of allotment advice/ acquisition of shares/ sale of shares specify','en-US',103009,104002,122052,1,GETDATE()),
(17223,'dis_grd_17223','From','From','en-US',103009,104002,122052,1,GETDATE()),
(17224,'dis_grd_17224','To','To','en-US',103009,104002,122052,1,GETDATE()),
(17225, 'dis_grd_17225', 'Trading in derivatives (Specify type of contract, Futures or Options etc)', 'Trading in derivatives (Specify type of contract, Futures or Options etc)', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17226, 'dis_grd_17226', 'Transaction Type', 'Transaction Type', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17227, 'dis_grd_17227', 'Type of Contract', 'Type of Contract', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17228, 'dis_grd_17228', 'Notional Value', 'Notional Value', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17229, 'dis_grd_17229', 'Number of units (contracts * lot size)', 'Number of units (contracts * lot size)', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17230, 'dis_grd_17230', 'Exchange on which the trade was executed', 'Exchange on which the trade was executed', 'en-US', 103009, 104003, 122052, 1 , GETDATE()),
(17231, 'dis_msg_17231', 'Select Transaction type', 'Select Transaction type', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17232, 'dis_msg_17232', 'Select Security type', 'Select Security type', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17233, 'dis_msg_17233', 'Select Demat details', 'Select DMAT details', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17234, 'dis_msg_17234', 'Enter value greater than zero.', 'Enter value greater than zero.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17235, 'dis_lbl_17235', 'Employee ID', 'Insider ID', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17236, 'dis_lbl_17236', 'Name', 'Insider Name', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17237, 'dis_lbl_17237', 'Security', 'Security', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17238, 'dis_lbl_17238', 'Reason For Rejection', 'Reason For Rejection', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17239, 'dis_lbl_17239', 'Pre Clearance For', 'Pre Clearance For', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17240, 'dis_lbl_17240', 'Relative Name', 'Relative Name', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17241, 'dis_lbl_17241', 'Value proposed to be traded', 'Value proposed to be traded', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17242, 'dis_btn_17242', 'Approve', 'Approve', 'en-US', 103009, 104004, 122051, 1 , GETDATE()),
(17243, 'dis_btn_17243', 'Reject', 'Reject', 'en-US', 103009, 104004, 122051, 1 , GETDATE()),
(17244, 'dis_msg_17244', 'Error occurred while fetching transaction details for letter for initial disclosure.', 'Error occurred while fetching transaction details for letter for initial disclosure.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17245, 'dis_msg_17245', 'Error occurred while fetching transaction details for letter for continuous disclosure.', 'Error occurred while fetching transaction details for letter for continuous disclosure.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17246, 'dis_msg_17246', 'Error occurred while fetching transaction details for letter for Countinous Disclosure for Employee insider.', 'Error occurred while fetching transaction details for letter for Countinous Disclosure for Employee insider.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17247, 'dis_grd_17247', 'Employee ID', 'User ID', 'en-Us', 103009, 104003, 122056, 1 , GETDATE()),
(17248, 'dis_grd_17248', 'Name', 'Insider Name', 'en-Us', 103009, 104003, 122056, 1 , GETDATE()),
(17249, 'dis_grd_17249', 'Designation', 'Designation', 'en-Us', 103009, 104003, 122056, 1 , GETDATE()),
(17250, 'dis_grd_17250', 'E-Mail sent Date', 'E-Mail sent Date', 'en-Us', 103009, 104003, 122056, 1 , GETDATE()),
(17251, 'dis_grd_17251', 'Disclosures Submission Date', 'Disclosure Received Date', 'en-Us', 103009, 104003, 122056, 1 , GETDATE()),
(17252, 'dis_grd_17252', 'HardCopy Submission Date', 'HardCopy Received Date', 'en-Us', 103009, 104003, 122056, 1 , GETDATE()),
(17253, 'dis_grd_17253', 'Submission to Exchange', 'Submission to Exchange', 'en-Us', 103009, 104003, 122056, 1 , GETDATE()),
(17254, 'dis_grd_17254', 'Name', 'Insider Name', 'en-US', 103009, 104003, 122057, 1 , GETDATE()),
(17255, 'dis_grd_17255', 'Employee ID', 'Insider ID', 'en-US', 103009, 104003, 122057, 1 , GETDATE()),
(17256, 'dis_grd_17256', 'Pre-Clearance ID', 'Pre-Clearance ID', 'en-US', 103009, 104003, 122057, 1 , GETDATE()),
(17257, 'dis_grd_17257', 'Pre-Clearance Request Date', 'Submisssion Date', 'en-US', 103009, 104003, 122057, 1 , GETDATE()),
(17258, 'dis_grd_17258', 'Pre-Clearance Status', 'Pre-Clearance Status', 'en-US', 103009, 104003, 122057, 1 , GETDATE()),
(17259, 'dis_grd_17259', 'Transaction Type', 'Transaction', 'en-US', 103009, 104003, 122057, 1 , GETDATE()),
(17260, 'dis_grd_17260', 'Securities', 'Securities', 'en-US', 103009, 104003, 122057, 1 , GETDATE()),
(17261, 'dis_grd_17261', 'Trading Details Submission', 'Trading Details Submitted', 'en-US', 103009, 104003, 122057, 1 , GETDATE()),
(17262, 'dis_grd_17262', 'Disclosure Details: SoftCopy', 'Disclosure Details (SoftCopy)', 'en-US', 103009, 104003, 122057, 1 , GETDATE()),
(17263, 'dis_grd_17263', 'Disclosure Details: HardCopy', 'Disclosure Details (HardCopy)', 'en-US', 103009, 104003, 122057, 1 , GETDATE()),
(17264, 'dis_grd_17264', 'Submission to Stock Exchange', 'Submission to Stock Exchange', 'en-US', 103009, 104003, 122057, 1 , GETDATE()),
(17265, 'dis_msg_17265', 'Enter Securities proposed to be traded max 11 digit number', 'Enter Securities proposed to be traded max 11 digit number', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17266, 'dis_msg_17266', 'Enter Proposed Trade Rate Range From max 11 digit number', 'Enter Proposed Trade Rate Range From max 11 digit number', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17267, 'dis_msg_17267', 'Enter Proposed Trade Rate Range To max 11 digit number', 'Enter Proposed Trade Rate Range To max 11 digit number', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17268, 'dis_msg_17268', 'Enter Value proposed to be traded max 11 digit number', 'Enter Value proposed to be traded max 11 digit number', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17269, 'dis_grd_17269', 'Soft Copy Submission Date', 'Soft Copy Submission Date', 'en-Us', 103009, 104003, 122056, 1 , GETDATE()),
(17270, 'dis_grd_17270', 'Submission to Stock Exchange', 'Submission to Stock Exchange', 'en-US', 103009, 104003, 122046, 1 , GETDATE()),
(17271, 'dis_lbl_17271', 'Reason for Non Trading', 'Reason for Not Traded', 'en-US', 103009, 104002, 122051, 1 , GETDATE()),
(17272, 'dis_lbl_17272', 'Employee ID', 'Employee ID', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17273, 'dis_lbl_17273', 'Name', 'Employee Name', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17274, 'dis_lbl_17274', 'Designation', 'Designation', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17275, 'dis_lbl_17275', 'Pre-Clearance ID', 'Pre-Clearance ID', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17276, 'dis_lbl_17276', 'Request Status', 'Request Status', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17277, 'dis_lbl_17277', 'Transaction Type', 'Transaction Type', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17278, 'dis_lbl_17278', 'Trade Details Status', 'Trade Details Status', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17279, 'dis_lbl_17279', 'Disclosure Details Softcopy Status', 'Disclosure Details Softcopy Status', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17280, 'dis_lbl_17280', 'Trade details submission From', 'Trade details submission From', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17281, 'dis_lbl_17281', 'Trade details submission To', 'Trade details submission To', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17282, 'dis_lbl_17282', 'Soft copy Submission From', 'Soft copy Submission From', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17283, 'dis_lbl_17283', 'Soft copy Submission To', 'Soft copy Submission To', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17284, 'dis_lbl_17284', 'Disclosure Details Hardcopy Status', 'Disclosure Details Hardcopy Status', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17285, 'dis_lbl_17285', 'Hard copy Submission From', 'Hard copy Submission From', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17286, 'dis_lbl_17286', 'Hard copy Submission To', 'Hard copy Submission To', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17287, 'dis_lbl_17287', 'Stock Exchange Status', 'Stock Exchange Status', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17288, 'dis_lbl_17288', 'Stock Exchange submission From', 'Stock Exchange submission From', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17289, 'dis_lbl_17289', 'Stock Exchange submission To', 'Stock Exchange submission To', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17290, 'dis_ttl_17290', 'Continuous Disclosures', 'Continuous Disclosures', 'en-US', 103009, 104006, 122057, 1 , GETDATE()),
(17291, 'dis_lbl_17291', 'Employee Id', 'Employee Id', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17292, 'dis_lbl_17292', 'Name', 'Employee Name', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17293, 'dis_lbl_17293', 'Designation', 'Designation', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17294, 'dis_lbl_17294', 'Email Sent Date', 'Email Sent Date', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17295, 'dis_lbl_17295', 'Disclosures Submission Date', 'Disclosure Receive Date', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17296, 'dis_lbl_17296', 'Holding Detail Submission', 'Holding Detail Submission', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17297, 'dis_lbl_17297', 'Soft Copy Submission', 'Soft Copy Submission', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17298, 'dis_lbl_17298', 'Hard Copy Submission', 'Hard Copy Submission', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17299, 'dis_lbl_17299', 'Stock Exchange Submission', 'Stock Exchange Submission', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17300, 'dis_lbl_17300', 'From', 'From', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17301, 'dis_lbl_17301', 'To', 'To', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17302, 'dis_lbl_17302', 'Status', 'Status', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17303, 'dis_lbl_17303', 'Days Overdue', 'Days Overdue', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17304, 'dis_lbl_17304', 'Days Left', 'Days Left', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17305, 'dis_lbl_17305', 'Days Overdue', 'Days Overdue', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17306, 'dis_lbl_17306', 'Days Left', 'Days Left', 'en-US', 103009, 104002, 122057, 1 , GETDATE()),
(17307, 'dis_msg_17307', 'Proposed Trade Rate Range To is Greater than Proposed Trade Rate Range From', 'Proposed Trade Rate Range To is Greater than Proposed Trade Rate Range From', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17308, 'dis_lbl_17308', 'Policy Document', 'Policy Document', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17309, 'dis_ttl_17309', 'Preclearances/Continuous Disclosuress', 'Preclearance/Continuous Disclosures', 'en-US', 103009, 104006, 122046, 1 , GETDATE()),
(17310, 'dis_lbl_17310', 'Continuous Disclosure Required', 'Continuous Disclosure Required', 'en-US', 103009, 104002, 122046, 1 , GETDATE()),
(17311, 'dis_lbl_17311', 'Insiders', 'Insiders', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17312, 'dis_lbl_17312', 'Disclosures Received', 'Disclosure Received', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17313, 'dis_lbl_17313', 'Soft Copy', 'Soft Copy', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17314, 'dis_lbl_17314', 'Hard Copy', 'Hard Copy', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17315, 'dis_lbl_17315', 'Disclosures Pending', 'Disclosure Received', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17316, 'dis_lbl_17316', 'Soft Copy', 'Soft Copy', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17317, 'dis_lbl_17317', 'Hard Copy', 'Hard Copy', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17318, 'dis_lbl_17318', 'View', 'View', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17319, 'dis_msg_17319', 'You can''t create Preclearance Request, Tranaction Type(s) are not set in trading policy. Please contact system administrator.', 'You can''t create Preclearance Request, Tranaction Type(s) are not set in trading policy. Please contact system administrator.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17320, 'dis_msg_17320', 'Great! The next step is to enter holdings in the securities of the Company for yourself and your relatives ', 'Fill up your Personal and Shareholding details along with relative details and complete your initial disclosure.', 'en-US', 103009, 104001, 122044, 1 , GETDATE()),
(17321, 'dis_msg_17321', 'Excellent !! Now, submit the letter and soft copy of Initial Disclosures. ', 'Excellent !! Download the initial disclosure. Take a print and sign it.', 'en-US', 103009, 104001, 122044, 1 , GETDATE()),
(17322, 'dis_msg_17322', 'That''s done!!! Now upload the signed scanned copy and submit the original signed hard copy to the Compliance Officer. ', 'Upload the signed scan copy to the system and submit the original signed hard copy to Compliance Officer. Thats done !!!', 'en-US', 103009, 104001, 122044, 1 , GETDATE()),
(17323, 'dis_msg_17323', 'Welcome ! Click to read and accept the Code of Fair Policies and Disclosures and proceed to enter holding details in securities of the Company', 'Good ! Now accept the responsibilities and policies.', 'en-US', 103009, 104001, 122044, 1 , GETDATE()),
(17324, 'dis_msg_17324', ' Excellent! You have successfully completed submission of the initial disclosures. As the next step, signed copy of the disclosures may be sent to the following address:  Demonstration Company Limited  Compliance Officer  Pune.', 'Upload the signed scan copy to the system and submit the original signed hard copy to Stock Exchange Thats done !!!', 'en-US', 103009, 104001, 122044, 1 , GETDATE()),
(17325, 'dis_lbl_17325', 'If you cannot view the document in the window below, you may open the downloaded document or click the link below to download and open.', 'If you cannot view the document in the window below, you may open the downloaded document or click the link below to download and open.', 'en-US', 103009, 104002, 122056, 1 , GETDATE()),
(17326, 'dis_msg_17326', 'You cannot create Pre-Clearance Request for selected transaction type because this transaction type is prohibited during non-trading period', 'You cannot create Pre-Clearance Request for selected transaction type because this transaction type is prohibited during non-trading period', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17327, 'dis_msg_17327', 'Security type cannot be different for transactions of continuous disclosure.', 'Security type cannot be different for transactions of continuous disclosure.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17328, 'dis_msg_17328', 'Error occurred while saving transaction details.', 'Error occurred while saving transaction details.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17329, 'dis_msg_17329', 'Transaction details do not exist.', 'Transaction details does not exist.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17330, 'dis_msg_17330', 'You cannot take Pre-Clearance for $1 transaction(s), since the trading window is closed from $2 to $3', 'You cannot take Pre-Clearance for $1 transaction(s), since the trading window is closed from $2 to $3', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17331, 'dis_msg_17331', 'Date of acquisition should be between the Period Start and Period End date, for selected Period End Disclosure.', 'Date of acquisition should be between the Period Start and Period End date, for selected Period End Disclosure.', 'en-US', 103009, 104001, 122048, 1 , GETDATE()),
(17332, 'dis_msg_17332', 'Please note that the trading window shall be closed from $1 to $2. You cannot trade during this period. Please refer to "Trading Window Calendar" for more details.', 'Please note that the trading window shall be closed from $1 to $2 You can not trade during this period. Please refer to "Trading Window Calendar" for more details.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17333, 'dis_btn_17333', 'Not Required', 'Not Required', 'en-US', 103009, 104004, 122046, 1 , GETDATE()),
(17334, 'dis_btn_17334', 'Not Required', 'Not Required', 'en-US', 103009, 104004, 122057, 1 , GETDATE()),
(17335, 'dis_msg_17335', 'Transaction details are already submitted and cannot be submitted again.', 'Transaction details are already submitted. Cannot submit it again.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17336, 'dis_msg_17336', 'Soft copy is already submitted for this transaction and cannot be submitted again.', 'Soft copy is already submitted for this transaction. Cannot submit it again.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17337, 'dis_msg_17337', 'Hard copy is already submitted for this transaction and cannot be submitted again.', 'Hard copy is already submitted for this transaction. Cannot submit it again.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17338, 'dis_msg_17338', 'Hard copy to stock exchange is already submitted for this transaction and cannot be submitted again.', 'Hard copy to stock exchange is already submitted for this transaction. Cannot submit it again.', 'en-Us', 103009, 104001, 122048, 1 , GETDATE()),
(17339, 'dis_msg_17339', 'Error occurred while saving letter.', 'Error occurred while saving letter.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17340, 'dis_msg_17340', 'Letter details do not exist.', 'Letter details does not exist.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17341, 'dis_msg_17341', 'Letter has alredy been created.', 'Letter has alredy been created.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17342, 'dis_msg_17342', 'Error occurred while checking contra trade condition.', 'Error occurred while checking contra trade condition.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17343, 'dis_msg_17343', 'This Pre-clearance request violates Contra Trade rules.  Contra trading is not allowed for $1 days for $2 transation types.', 'This Pre-clearance request violates Contra Trade rules.  Contra trading is not allowed for $1 days for $2 transation types.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17344, 'dis_msg_17344', 'Initial Disclosure process completed successfully.', 'Initial Disclosure process completed successfully.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17345, 'dis_msg_17345', 'Hard copy submitted successfully.', 'Hard copy submitted successfully.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17346, 'dis_msg_17346', 'Soft copy submitted successfully.', 'Soft copy submitted successfully.', 'en-US', 103009, 104001, 122052, 1 , GETDATE()),
(17347, 'dis_btn_17347', 'Document Uploaded', 'Document Uploaded', 'en-Us', 103009, 104004, 122044, 1 , GETDATE()),
(17348, 'dis_btn_17348', 'View Policy Documents', 'View Policy Documents', 'en-US', 103009, 104004, 122044, 1, GETDATE()),

(17349,'dis_btn_17349', 'Not Traded', 'Not Traded', 'en-US', 103009, 104004, 122046, 1, GETDATE()),
(17350,'dis_grd_17350', 'Preclearance Qty', 'Preclearance Qty', 'en-US', 103009, 104003, 122046, 1, GETDATE()),
(17351,'dis_grd_17351', 'Trade Qty', 'Trade Qty', 'en-US', 103009, 104003, 122046, 1, GETDATE()),
(17352,'dis_btn_17352', 'Partially Traded', 'Partially Traded', 'en-US', 103009, 104004, 122046, 1, GETDATE()),

(17353,'dis_btn_17353', 'Not Traded', 'Not Traded', 'en-US', 103009, 104004, 122057, 1, GETDATE()),
(17354,'dis_grd_17354', 'Preclearance Qty', 'Preclearance Qty', 'en-US', 103009, 104003, 122057, 1, GETDATE()),
(17355,'dis_grd_17355', 'Trade Qty', 'Trade Qty', 'en-US', 103009, 104003, 122057, 1, GETDATE()),
(17356,'dis_btn_17356', 'Partially Traded', 'Partially Traded', 'en-US', 103009, 104004, 122057, 1, GETDATE()),

(17357, 'dis_msg_17357', 'Cannot submit reason for not trading, as details are not yet submitted for a transaction for which document is uploaded.', 'Cannot submit reason for not trading, as details are not yet submitted for a transaction for which document is uploaded.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17358, 'dis_msg_17358', 'Cannot submit reason for not trading, as details are entered but not yet submitted for a transaction.', 'Cannot submit reason for not trading, as details are entered but not yet submitted for a transaction.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17359, 'dis_msg_17359', 'Error occurred while calculating summary of preclearance and trading quantities.', 'Error occurred while calculating summary of preclearance and trading quantities.', 'en-US', 103009, 104001, 122051, 1 , GETDATE())

-- Script sent by Parag on 26th Aug 2015
-- Add Grid header for Pre-clearance Details List
INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES	
	-- Pre-clearance Details CO List header
	('17360', 'dis_grd_17360', 'Pre-clearance ID', 'Pre-clearance ID', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17361', 'dis_grd_17361', 'Date', 'Date', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17362', 'dis_grd_17362', 'Transaction Type', 'Transaction Type', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17363', 'dis_grd_17363', 'Type of Security', 'Type of Security', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17364', 'dis_grd_17364', 'No. of Securities', 'No. of Securities', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17365', 'dis_grd_17365', 'Pre-Clearance Value', 'Pre-Clearance Value', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17366', 'dis_grd_17366', 'Traded Qty', 'Traded Qty', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17367', 'dis_grd_17367', 'Traded Value', 'Traded Value', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17368', 'dis_grd_17368', 'Status', 'Status', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	
	-- Pre-clearance Details Insider List header
	('17369', 'dis_grd_17369', 'Pre-clearance ID', 'Pre-clearance ID', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17370', 'dis_grd_17370', 'Date', 'Date', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17371', 'dis_grd_17371', 'Transaction Type', 'Transaction Type', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17372', 'dis_grd_17372', 'Type of Security', 'Type of Security', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17373', 'dis_grd_17373', 'No. of Securities', 'No. of Securities', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17374', 'dis_grd_17374', 'Pre-Clearance Value', 'Pre-Clearance Value', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17375', 'dis_grd_17375', 'Traded Qty', 'Traded Qty', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17376', 'dis_grd_17376', 'Traded Value', 'Traded Value', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
	('17377', 'dis_grd_17377', 'Status', 'Status', 'en-US', 103009, 104003, 122051, 1, GETDATE())
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES	
(17378, 'dis_msg_17378', 'Error occurred while fetching previous preclearance details.', 'Error occurred while fetching previous preclearance details.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17379,'dis_btn_17379', 'Auto Approved', 'Auto Approved', 'en-US', 103009, 104004, 122051, 1, GETDATE()),
(17380,'dis_lbl_17380', 'Total : ', 'Total : ', 'en-US', 103009, 104002, 122051, 1, GETDATE()),

(17381, 'dis_lbl_17381', 'Details of last $1 days', 'Details of last $1 days', 'en-US', 103009, 104002, 122051, 1, GETDATE()),
	
(17382, 'dis_msg_17382', 'Pre-clearance for the selected transation and security is not needed.', 'Pre-clearance for the selected transation and security is not needed.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17383, 'dis_msg_17383', 'Cannot save new preclearance request, as a preclearance is already requested and not yet approved.', 'Cannot save new preclearance request, as a preclearance is already requested and not yet approved.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17384, 'dis_msg_17384', 'Some preclearance requests are not yet closed. Close the preclearance request by providing all details or reason for Not/partial trading.', 'Some preclearance requests are not yet closed. Close the preclearance request by providing all details or reason for Not/partial trading.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
(17385, 'dis_msg_17385', 'Preclearance is not needed, since the values provided are within limit. you can directly submit trade details.', 'Preclearance is not needed, since the values provided are within limit. you can directly submit trade details.', 'en-US', 103009, 104001, 122051, 1 , GETDATE()),
	
(17386,'dis_btn_17386', 'Auto Approved', 'Auto Approved', 'en-US', 103009, 104004,122057, 1, GETDATE()),
 
-- Pre-clearance Details CO List header
(17387, 'dis_grd_17387', 'Date Of Acquisition', 'Date Of Acquisition', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
-- Pre-clearance Details Insider List header
(17388, 'dis_grd_17388', 'Date Of Acquisition', 'Date Of Acquisition', 'en-US', 103009, 104003, 122051, 1, GETDATE()),
(17389, 'dis_msg_17389', 'Date Of acquisition must be greater than date of approval.', 'Date Of acquisition must be greater than date of approval.', 'en-US', 103009, 104001, 122048, 1, GETDATE()),

/* Sent by Parag on 14-Oct-2015 */
(17390, 'dis_msg_17390','Cannot submit Continuous disclosure, since period end disclosure for the past period is not submitted.', 'Cannot submit Continuous disclosure, since period end disclosure for the past period is not submitted.', 'en-US', 103009, 104001, 122048, 1, GETDATE()),
(17391, 'dis_msg_17391','Cannot submit Period End disclosure, since period end disclosure for the past period is not submitted.', 'Cannot submit Period End disclosure, since period end disclosure for the past period is not submitted.', 'en-US', 103009, 104001, 122048, 1, GETDATE()),
(17392, 'dis_msg_17392','Cannot submit Period End disclosure, since pre-clearances are open.', 'Cannot submit Period End disclosure, since pre-clearances are open.', 'en-US', 103009, 104001, 122048, 1, GETDATE()),

-- Resources related to pre-clearance request validation 
(17393, 'dis_msg_17393','Cannot create new preclearance request, as a period end disclosure is not yet submiited.', 'Cannot create new preclearance request, as a period end disclosure is not yet submiited.', 'en-US', 103009, 104001, 122051, 1, GETDATE()),

-- Resources related to period end disclosure list shown to CO
(17394, 'dis_grd_17394','History', 'History', 'en-US', 103009, 104003, 122055, 1, GETDATE()),
/* Sent by Parag ON 31-Oct-2015 */
(17395, 'dis_msg_17395','Date Of acquisition must be greater than date of initial disclosure.', 'Date Of acquisition must be greater than date of initial disclosure.', 'en-US', 103009, 104001, 122051, 1, GETDATE()),
/* Sent by Raghvendra on 31-Oct-2015 */
(17396 ,'dis_msg_17396' ,'Please Complete your Initial Disclosures to get access to other screens','Please Complete your Initial Disclosures to get access to other screens' ,'en-US' ,103009 ,104001 ,122044 ,1 ,GETDATE()),

/* Sent by Parag, 03-Dec-2015 */
(17397, 'dis_lbl_17397','ESOP Exercise qty:', 'ESOP Exercise qty:', 'en-US', 103009, 104002, 122051, 1, GETDATE()),
(17398, 'dis_lbl_17398','Other than ESOP Exercise qty:', 'Other than ESOP Exercise qty:', 'en-US', 103009, 104002, 122051, 1, GETDATE()),
	
(17399, 'dis_msg_17399','Exercise security balance not found for user', 'Exercise security balance not found for user', 'en-US', 103009, 104001, 122051, 1, GETDATE()),
(17400, 'dis_msg_17400','Exercise security pool does not sufficient quantity', 'Exercise security pool does not sufficient quantity', 'en-US', 103009, 104001, 122051, 1, GETDATE()),
(17401, 'dis_msg_17401','Error occured while updating exercise pool', 'Error occured while updating exercise pool', 'en-US', 103009, 104001, 122051, 1, GETDATE()),	

/* Sent by Raghvendra on 27-Nov-2015 */
--Entry in Resource for Contract Sepcification 
(17402 ,'dis_grd_17402' ,'Contract specifications','Contract specifications' ,'en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
(17403 ,'dis_grd_17403' ,'Contract specifications' ,'Contract specifications','en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
--Table Header for grid one for Form D i.e. continuous disclosure for non employee insider
(17404 ,'dis_lbl_17404' ,'Details of trading in securities by other connected persons as identified by the company','Details of trading in securities by other connected persons as identified by the company' ,'en-US' ,103009 ,104002 ,122052  ,1 ,GETDATE()),
--Table Header and footer for grid 2 for Form B
(17405 ,'dis_lbl_17405' ,'Details of Open Interest (OI) in derivatives of the company held on appointment of Key Managerial Personnel (KMP) or Director or upon becoming a Promoter of a listed company and other such persons as mentioned in Regulation 6(2).','Details of Open Interest (OI) in derivatives of the company held on appointment of Key Managerial Personnel (KMP) or Director or upon becoming a Promoter of a listed company and other such persons as mentioned in Regulation 6(2).' ,'en-US' ,103009 ,104002 ,122052  ,1 ,GETDATE()),
(17406 ,'dis_lbl_17406' ,'Note: In case of Options, notional value shall be calculated based on premium plus strike price of options','Note: In case of Options, notional value shall be calculated based on premium plus strike price of options' ,'en-US' ,103009 ,104002 ,122052  ,1 ,GETDATE()),
--Table header and footer for form C for Grid 2
(17407 ,'dis_lbl_17407' ,'Details of trading in derivatives of the company by Promoter, Employee or Director of a listed company and other such persons as mentioned in Regulation 6(2).','Details of trading in derivatives of the company by Promoter, Employee or Director of a listed company and other such persons as mentioned in Regulation 6(2).' ,'en-US' ,103009 ,104002 ,122052  ,1 ,GETDATE()),
(17408 ,'dis_lbl_17408' ,'Note: In case of Options, notional value shall be calculated based on Premium plus strike price of options.','Note: In case of Options, notional value shall be calculated based on Premium plus strike price of options.' ,'en-US' ,103009 ,104002 ,122052  ,1 ,GETDATE()),
--Table header and footer for form D for Grid 2
(17409 ,'dis_lbl_17409' ,'Details of trading in derivatives by other connected persons as identified by the company','Details of trading in derivatives by other connected persons as identified by the company' ,'en-US' ,103009 ,104002 ,122052  ,1 ,GETDATE()),
(17410 ,'dis_lbl_17410' ,'Note: In case of Options, notional value shall be calculated based on premium plus strike price of options.','Note: In case of Options, notional value shall be calculated based on premium plus strike price of options.' ,'en-US' ,103009 ,104002 ,122052  ,1 ,GETDATE()),

(17411 ,'dis_grd_17411' ,'Contract specifications','Contract specifications' ,'en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
(17412 ,'dis_grd_17412' ,'Contract specifications' ,'Contract specifications','en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
(17413 ,'dis_grd_17413' ,'Contract specifications','Contract specifications' ,'en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
(17414 ,'dis_grd_17414' ,'Contract specifications' ,'Contract specifications','en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
--New other column added for Form C
(17415 ,'dis_grd_17415' ,'Buy','Buy' ,'en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
(17416 ,'dis_grd_17416' ,'Sell','Sell' ,'en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
(17417 ,'dis_grd_17417' ,'Notional Value','Notional Value' ,'en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
(17418 ,'dis_grd_17418' ,'Number of units (contracts * lot size)','Number of units (contracts * lot size)' ,'en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
--New other column added for Form D
(17419 ,'dis_grd_17419' ,'Buy','Buy' ,'en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
(17420 ,'dis_grd_17420' ,'Sell','Sell' ,'en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
(17421 ,'dis_grd_17421' ,'Notional Value','Notional Value' ,'en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
(17422 ,'dis_grd_17422' ,'Number of units (contracts * lot size)','Number of units (contracts * lot size)' ,'en-US' ,103009 ,104003 ,122052  ,1 ,GETDATE()),
/* Sent by Parag, 03-Dec-2015 */
(17423, 'dis_msg_17423','Please select at least one option of exercise pool', 'Please select at least one option of  exercise pool', 'en-US', 103009, 104001, 122051, 1, GETDATE()),
/* Added on 3-Dec-2015, Raghvendra */
(17424,'dis_grd_17424','Date of intimation to company','Date of intimation to company','en-US',103009,104002,122052,1,GETDATE()),
(17425,'dis_grd_17425','Mode of acquisition / disposal (on market/ public/ rights/ preferential offer/ off  market/ Inter-setransfer, ESOPs etc.)','Mode of acquisition / disposal (on market/ public/ rights/ preferential offer/ off  market/ Inter-setransfer, ESOPs etc.)','en-US',103009,104002,122052,1,GETDATE()),
(17426,'dis_grd_17426','Date of intimation to company','Date of intimation to company','en-US',103009,104002,122052,1,GETDATE()),
(17427,'dis_grd_17427','Mode of acquisition/ disposal (on market/ public/ rights/ Preferential offer/ off market/ Interse transfer, ESOPs etc. )','Mode of acquisition/ disposal (on market/ public/ rights/ Preferential offer/ off market/ Interse transfer, ESOPs etc. )','en-US',103009,104002,122052,1,GETDATE()),
/*Added 14-Jan-2016 Send by Parag added by Raghvendra*/
-- Resources related to previous pre-clearance list on per-clearance approve reject page
(17428, 'dis_lbl_17428','Pre-Clearance Summary', 'Pre-Clearance Summary', 'en-US', 103009, 104002, 122051, 1, GETDATE())


/*
Scripts received from Raghvendra on 13-Apr-2016
Scripts for adding the resources for the button text, labels and messages seen on Insider Dashboard screen
*/
INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
VALUES 
(17429,'dis_btn_17429','New Pre-clearance Request','en-US',103008,104004,122083,'New Pre-clearance Request',1,GETDATE()),
(17430,'dis_btn_17430','Submit Disclosure','en-US',103008,104004,122083,'Submit Disclosure',1,GETDATE()),
(17431,'dis_btn_17431','Preclearance Requests','en-US',103008,104004,122083,'Preclearance Requests',1,GETDATE()),
(17432,'dis_btn_17432','Trade Details','en-US',103008,104004,122083,'Trade Details',1,GETDATE()),
(17433,'dis_btn_17433','Holding On ','en-US',103008,104004,122083,'Holding On ',1,GETDATE()),
(17434,'dis_btn_17434','Disclosures','en-US',103008,104004,122083,'Disclosures',1,GETDATE()),
(17435,'dis_btn_17435','Trading Window','en-US',103008,104004,122083,'Trading Window',1,GETDATE()),
(17436,'dis_lbl_17436','Initial','en-US',103008,104002,122083,'Initial',1,GETDATE()),
(17437,'dis_lbl_17437','Continuous','en-US',103008,104002,122083,'Continuous',1,GETDATE()),
(17438,'dis_lbl_17438','Period End','en-US',103008,104002,122083,'Period End',1,GETDATE()),
(17439,'dis_lbl_17439','Initial Disclosures submitted on ','en-US',103008,104002,122083,'Initial Disclosures submitted on ',1,GETDATE()),
(17440,'dis_lbl_17440','Last date of submitting the Initial Disclosures was ','en-US',103008,104002,122083,'Last date of submitting the Initial Disclosures was ',1,GETDATE()),
(17441,'dis_lbl_17441','Last date of submitting the Initial Disclosures is ','en-US',103008,104002,122083,'Last date of submitting the Initial Disclosures is ',1,GETDATE()),
(17442,'dis_lbl_17442','Trading policy not found for the user.','en-US',103008,104002,122083,'Trading policy not found for the user.',1,GETDATE()),
(17443,'dis_lbl_17443','Continuous Disclosure(s) pending for submission','en-US',103008,104002,122083,'Continuous Disclosure(s) pending for submission',1,GETDATE()),
(17444,'dis_lbl_17444','Next submission of Period End Disclosure is from ','en-US',103008,104002,122083,'Next submission of Period End Disclosure is from ',1,GETDATE()),
(17445,'dis_lbl_17445','Last date of submitting Period End Disclosure is ','en-US',103008,104002,122083,'Last date of submitting Period End Disclosure is ',1,GETDATE()),
(17446,'dis_lbl_17446','Last date of submitting Period End Disclosure was ','en-US',103008,104002,122083,'Last date of submitting Period End Disclosure was ',1,GETDATE()),
(17447,'dis_lbl_17447','Period End Disclosure is not required','en-US',103008,104002,122083,'Period End Disclosure is not required',1,GETDATE())


/*
Script received from Tushar on 2 May 2016 -- Change for show Total Traded Quantity (Stock Exchange Submission)
*/
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(17448,'dis_grd_17448','Total Traded Quantity','Total Traded Quantity','en-US',103008,104003,122057,1 , GETDATE())

/*
Script received from Raghvendra on 11-May-2016 -- 
Added resource for the error message to be shown on the Stock Exchange Submission page. 
The resource can be seen under (Module)Disclosures>(Screen)TransactionLetter on the Resources screen.
*/
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(17449, 'dis_msg_17449', 'Submission Date can not be after today''s date', 'Submission Date can not be after today''s date', 'en-Us', 103009, 104001, 122052, 1 , GETDATE()),
(17450, 'dis_msg_17450', 'Please Upload Document', 'Please Upload Document', 'en-Us', 103009, 104001, 122052, 1 , GETDATE()),
(17451, 'dis_msg_17451', 'Enter Submission Date', 'Enter Submission Date', 'en-Us', 103009, 104001, 122052, 1 , GETDATE())

/*
Script received from Tushar on 16 May 2016 - 
*/
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(17452,'dis_grd_17452','Policy is accepted','Policy is accepted','en-US',103009,104001,122048,1 , GETDATE()),
(17453,'dis_grd_17453','Error occurred while fetching initial disclosure details.','Error occurred while fetching initial disclosure details.','en-US',103009,104001,122048,1 , GETDATE())



INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(18001, 'cmu_grd_18001', 'Rulename', 'Rulename', 'en-US', 103010, 104003, 122053, 1 , GETDATE()),
(18002, 'cmu_grd_18002', 'Category', 'Category', 'en-US', 103010, 104003, 122053, 1 , GETDATE()),
(18003, 'cmu_grd_18003', 'Rule defined for', 'Rule defined for', 'en-US', 103010, 104003, 122053, 1 , GETDATE()),
(18004, 'cmu_grd_18004', 'Modes of communication', 'Modes of communication', 'en-US', 103010, 104003, 122053, 1 , GETDATE()),
(18005, 'cmu_grd_18005', 'Is Personalizable', 'Is Personalizable', 'en-US', 103010, 104003, 122053, 1 , GETDATE()),
(18006, 'cmu_grd_18006', 'Status', 'Status', 'en-US', 103010, 104003, 122053, 1 , GETDATE()),
(18007, 'cmu_grd_18007', 'Mode', 'Mode', 'en-US', 103010, 104003, 122054, 1 , GETDATE()),
(18008, 'cmu_grd_18008', 'Template', 'Template', 'en-US', 103010, 104003, 122054, 1 , GETDATE()),
(18009, 'cmu_grd_18009', 'Wait days after trigger', 'Wait days after trigger', 'en-US', 103010, 104003, 122054, 1 , GETDATE()),
(18010, 'cmu_grd_18010', 'Frequency', 'Frequency', 'en-US', 103010, 104003, 122054, 1 , GETDATE()),
(18011, 'cmu_grd_18011', 'Max notifications', 'Max notifications', 'en-US', 103010, 104003, 122054, 1 , GETDATE()),
(18012, 'cmu_grd_18012', 'Type', 'Type', 'en-US', 103010, 104003, 122059, 1 , GETDATE()),
(18013, 'cmu_grd_18013', 'Message', 'Message', 'en-US', 103010, 104003, 122059, 1 , GETDATE()),
(18014, 'cmu_grd_18014', 'Date', 'Date', 'en-US', 103010, 104003, 122059, 1 , GETDATE()),
(18015, 'cmu_msg_18015', 'Communication rule does not exist.', 'Communication rule does not exist.', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18016, 'cmu_msg_18016', 'Error occurred while fetching communication rule details.', 'Error occurred while fetching communication rule details.', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18017, 'cmu_msg_18017', 'Error occurred while fetching communication rule list.', 'Error occurred while fetching communication rule list.', 'en-US', 103010, 104001, 122053, 1 , GETDATE()),
(18018, 'cmu_msg_18018', 'Error occurred while saving communication rule.', 'Error occurred while saving communication rule.', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18019, 'cmu_msg_18019', 'Communication rule with same name already exists.', 'Communication rule with same name already exists.', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18020, 'cmu_msg_18020', 'Communication rule saved successfully.', 'Communication rule saved successfully.', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18021, 'cmu_lbl_18021', 'Name', 'Name', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18022, 'cmu_lbl_18022', 'Mode', 'Mode', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18023, 'cmu_lbl_18023', 'Description', 'Description', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18024, 'cmu_lbl_18024', 'Trigger Event', 'Trigger Event', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18025, 'cmu_lbl_18025', 'Offset Event', 'Offset Event', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18026, 'cmu_lbl_18026', 'Events triggered by', 'Events triggered by', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18027, 'cmu_lbl_18027', 'Communication sent to', 'Communication sent to', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18028, 'cmu_lbl_18028', 'Allow Insider Personalize ?', 'Allow Insider Personalize ?', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18029, 'cmu_lbl_18029', 'Rule Status', 'Rule Status', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18030, 'cmu_ttl_18030', 'Communication Rule Master', 'Communication Rule Master', 'en-US', 103010, 104006, 122053, 1 , GETDATE()),
(18031, 'cmu_ttl_18031', 'Communication Rule Details', 'Communication Rule Details', 'en-US', 103010, 104006, 122054, 1 , GETDATE()),
(18032, 'cmu_btn_18032', 'Add Rule', 'Add Rule', 'en-US', 103010, 104004, 122053, 1 , GETDATE()),
(18033, 'cmu_btn_18033', 'Add Row', 'Add Row', 'en-US', 103010, 104004, 122054, 1 , GETDATE()),
(18034, 'cmu_msg_18034', 'Error occurred while fetching notification details.', 'Error occurred while fetching notification details.', 'en-US', 103010, 104001, 122059, 1 , GETDATE()),
(18035, 'cmu_msg_18035', 'Notification does not exist.', 'Notification does not exist.', 'en-US', 103010, 104001, 122059, 1 , GETDATE()),
(18036, 'cmu_msg_18036', 'Error occurred while fetching notification list.', 'Error occurred while fetching notification list.', 'en-US', 103010, 104001, 122059, 1 , GETDATE()),
(18037, 'cmu_lbl_18037', 'Subject', 'Subject', 'en-US', 103010, 104002, 122059, 1 , GETDATE()),
(18038, 'cmu_lbl_18038', 'Content', 'Content', 'en-US', 103010, 104002, 122059, 1 , GETDATE()),
(18039, 'cmu_lbl_18039', 'From Date', 'From Date', 'en-US', 103010, 104002, 122059, 1 , GETDATE()),
(18040, 'cmu_lbl_18040', 'To Date', 'To Date', 'en-US', 103010, 104002, 122059, 1 , GETDATE()),
(18041, 'cmu_lbl_18041', 'Type', 'Type', 'en-US', 103010, 104002, 122059, 1 , GETDATE()),
(18042, 'cmu_lbl_18042', 'Contact Info', 'Contact Info', 'en-US', 103010, 104002, 122059, 1 , GETDATE()),
(18043, 'cmu_lbl_18043', 'Signature', 'Signature', 'en-US', 103010, 104002, 122059, 1 , GETDATE()),
(18044, 'cmu_lbl_18044', 'Date', 'Date', 'en-US', 103010, 104002, 122059, 1 , GETDATE()),
(18045, 'cmu_lbl_18045', 'Notifications & Alerts', 'Notifications & Alerts', 'en-US', 103010, 104002, 122059, 1 , GETDATE()),
(18046, 'cmu_ttl_18046', 'Notifications', 'Notifications', 'en-US', 103010, 104006, 122059, 1 , GETDATE()),
(18047, 'cmu_ttl_18047', 'Notification Details', 'Notification Details', 'en-US', 103010, 104006, 122059, 1 , GETDATE()),
(18048, 'cmu_btn_18048', 'View All', 'View All', 'en-US', 103010, 104004, 122059, 1 , GETDATE()),
(18049, 'cmu_grd_18049', 'Subject', 'Subject', 'en-US', 103010, 104003, 122059, 1 , GETDATE()),
(18050, 'cmu_grd_18050', 'Date', 'Date', 'en-US', 103010, 104003, 122059, 1 , GETDATE()),
(18051, 'cmu_msg_18051', 'Select Communication Mode', 'Select Communication Mode', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18052, 'cmu_msg_18052', 'Select Template', 'Select Template', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18053, 'cmu_msg_18053', 'Enter Wait Days After Trigger Event', 'Enter Wait Days After Trigger Event', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18054, 'cmu_msg_18054', 'Select Frequency', 'Select Frequency', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18055, 'cmu_msg_18055', 'Enter Notification Limit', 'Enter Notification Limit', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18056, 'cmu_lbl_18056', 'No Record found!', 'No Record found!', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18057, 'cmu_lbl_18057', 'Employee / Insider', 'Employee / Insider', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18058, 'cmu_lbl_18058', 'Compliance Officer', 'Compliance Officer', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18059, 'cmu_lbl_18059', 'Select Mode', 'Select Mode', 'en-US', 103010, 104002, 122054, 1 , GETDATE()),
(18060, 'cmu_lbl_18060', 'Mails', 'Mails', 'en-US', 103010, 104002, 122059, 1 , GETDATE()),
(18061, 'cmu_msg_18061', 'Duplicate entry for communication mode.', 'Duplicate entry for communication mode.', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18062, 'cmu_msg_18062', 'Select at least one Event', 'Select at least one Event', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18063, 'cmu_lbl_18063', 'Attention', 'Attention', 'en-US', 103010, 104002, 122059, 1 , GETDATE()),
(18064, 'cmu_btn_18064', 'Close', 'Close', 'en-US', 103010, 104004, 122059, 1 , GETDATE()),
(18065, 'cmu_msg_18065', 'Communication rule activated successfully.', 'Communication rule activated successfully.', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18066, 'cmu_msg_18066', 'Communication rule deactivated successfully.', 'Communication rule deactivated successfully.', 'en-US', 103010, 104001, 122054, 1 , GETDATE()),
(18067, 'cmu_msg_18067', 'Please select Trigger Events for Same Usertype.', 'Please select Trigger Events for Same Usertype.', 'en-US', 103010, 104001, 122054, 1, GETDATE()),
--Scripts sent by GS on 21-Jan-2016, for error messages on Communication Rules screen
(18068 ,'cmu_msg_18068' ,'Cannot delete the Communication mode, as some dependent information exists on it.','Cannot delete the Communication mode, as some dependent information exists on it.' ,'en-US' ,103010 ,104001 ,122054 ,1 ,GETDATE()),
(18069 ,'cmu_msg_18069','Personalized records also get deleted, Are you sure you want to delete this Communication mode?','Personalized records also get deleted, Are you sure you want to delete this Communication mode?','en-US',103010,104001,122054,1,GETDATE()),
(18070,'cmu_msg_18070'	,'Cannot delete the first record.','Cannot delete the first record.','en-US',103010,104001,122054,1,GETDATE()),
(18071,'cmu_msg_18071','Please Select Template.','Please Select Template.','en-US',103010,104001,122054,1,GETDATE())

INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES
(19001, 'rpt_lbl_19001', 'Submitted within stipulated time', 'Submitted within stipulated time', 'en-US', 103011, 104002, 122058, 1 , GETDATE()),
(19002, 'rpt_lbl_19002', 'Not submitted in stipulated time', 'Not submitted in stipulated time', 'en-US', 103011, 104002, 122058, 1 , GETDATE()),
(19003, 'rpt_lbl_19003', 'Not submitted', 'Not submitted', 'en-US', 103011, 104002, 122058, 1 , GETDATE()),
(19004, 'rpt_grd_19004', 'Employee Id', 'Employee Id', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19005, 'rpt_grd_19005', 'Name', 'Insider Name', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19006, 'rpt_grd_19006', 'Insider from', 'Date of becoming insider', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19007, 'rpt_grd_19007', 'CIN/DIN Number', 'CIN/DIN Number', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19008, 'rpt_grd_19008', 'Designation', 'Designation', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19009, 'rpt_grd_19009', 'Grade', 'Grade', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19010, 'rpt_grd_19010', 'Location', 'Location', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19011, 'rpt_grd_19011', 'Department', 'Department', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19012, 'rpt_grd_19012', 'Company Name', 'Company Name', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19013, 'rpt_grd_19013', 'Type Of Insider', 'Type Of Insider', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19014, 'rpt_grd_19014', 'Submission Date', 'Submission Date', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19015, 'rpt_grd_19015', 'Soft Copy ', 'Soft copy Submission Date', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19016, 'rpt_grd_19016', 'Hard Copy ', 'Hard Copy Submission date', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19017, 'rpt_grd_19017', 'Comment', 'Comment', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19018, 'rpt_lbl_19018', 'Employee ID:', 'Employee ID:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19019, 'rpt_lbl_19019', 'Insider Name:', 'Insider Name:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19020, 'rpt_lbl_19020', 'Designation:', 'Designation:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19021, 'rpt_lbl_19021', 'Grade:', 'Grade:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19022, 'rpt_lbl_19022', 'Location:', 'Location:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19023, 'rpt_lbl_19023', 'Dept:', 'Dept:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19024, 'rpt_lbl_19024', 'Company Name:', 'Company Name:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19025, 'rpt_lbl_19025', 'Type of Insider:', 'Type of Insider:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19026, 'rpt_lbl_19026', 'CIN/DIN No.:', 'CIN/DIN No.:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19027, 'rpt_lbl_19027', 'Date of becoming Insider', 'Date of becoming Insider', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19028, 'rpt_lbl_19028', 'Initial Disclosure Softcopy Submission Date', 'Initial Disclosure Softcopy Submission Date', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19029, 'rpt_lbl_19029', 'Initial Disclosure Hardcopy Submission Date', 'Initial Disclosure Hardcopy Submission Date', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19030, 'rpt_lbl_19030', 'Status of Submission', 'Status of Submission', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19031, 'rpt_lbl_19031', 'Last Date of Submission(Softcopy)', 'Last Date of Submission(Softcopy)', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19032, 'rpt_grd_19032', 'Demat Account', 'Demat Account', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19033, 'rpt_grd_19033', 'A/c holder name', 'A/c holder name', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19034, 'rpt_grd_19034', 'Relation with Insider', 'Relation with Insider', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19035, 'rpt_grd_19035', 'Scrip Name', 'Script Name', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19036, 'rpt_grd_19036', 'ISIN', 'ISIN', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19037, 'rpt_grd_19037', 'Security Type', 'Security Type', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19038, 'rpt_grd_19038', 'Holdings', 'Holding', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19039, 'rpt_grd_19039', 'Employee Id', 'Employee Id', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19040, 'rpt_grd_19040', 'Insider Name', 'Insider Name', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19041, 'rpt_grd_19041', 'Date of becoming insider', 'Date of becoming insider', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19042, 'rpt_grd_19042', 'CIN/DIN Number', 'CIN/DIN Number', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19043, 'rpt_grd_19043', 'Designation', 'Designation', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19044, 'rpt_grd_19044', 'Grade', 'Grade', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19045, 'rpt_grd_19045', 'Location', 'Location', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19046, 'rpt_grd_19046', 'Department', 'Department', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19047, 'rpt_grd_19047', 'Company Name', 'Company Name', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19048, 'rpt_grd_19048', 'Type Of Insider', 'Type Of Insider', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19049, 'rpt_grd_19049', 'Last Submission Date', 'Last Submission Date', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19050, 'rpt_grd_19050', 'Submission Date', 'Submission Date', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19051, 'rpt_grd_19051', 'Soft Copy', 'Soft copy Submission Date', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19052, 'rpt_grd_19052', 'Hard Copy', 'Hard Copy Submission date', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19053, 'rpt_grd_19053', 'Comment', 'Comment', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19054, 'rpt_grd_19054', 'A/c holder name', 'A/c holder name', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19055, 'rpt_grd_19055', 'Relation with Insider', 'Relation with Insider', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19056, 'rpt_grd_19056', 'Demat Account', 'Demat Account', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19057, 'rpt_grd_19057', 'Scrip Name', 'Scrip Name', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19058, 'rpt_grd_19058', 'ISIN', 'ISIN', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19059, 'rpt_grd_19059', 'Security Type', 'Security Type', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19060, 'rpt_grd_19060', 'Holding', 'Holding', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19061, 'rpt_grd_19061', 'Value', 'Value', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19062, 'rpt_grd_19062', 'Scrip Name', 'Scrip Name', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19063, 'rpt_grd_19063', 'ISIN', 'ISIN', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19064, 'rpt_grd_19064', 'Security Type', 'Security Type', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19065, 'rpt_grd_19065', 'Transaction Type', 'Transaction Type', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19066, 'rpt_grd_19066', '', '', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19067, 'rpt_grd_19067', 'Trade', 'Trade', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19068, 'rpt_grd_19068', 'Buy', 'Buy', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19069, 'rpt_grd_19069', 'Sell', 'Sell', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19070, 'rpt_grd_19070', 'Value', 'Value', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19071, 'rpt_grd_19071', 'Date of Transaction', 'Date of Transaction', 'en-US', 103011, 104003, 122060, 1 , GETDATE()),
(19072, 'rpt_grd_19072', 'Last Submission Date', 'Last Submission Date', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19073, 'rpt_grd_19073', 'Holdings', 'Details Submission Date', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19074, 'rpt_grd_19074', 'Employee Id', 'Employee Id', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19075, 'rpt_grd_19075', 'Insider Name', 'Insider Name', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19076, 'rpt_grd_19076', 'Date of becoming insider', 'Date of becoming insider', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19077, 'rpt_grd_19077', 'CIN/DIN Number', 'CIN/DIN Number', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19078, 'rpt_grd_19078', 'Designation', 'Designation', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19079, 'rpt_grd_19079', 'Grade', 'Grade', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19080, 'rpt_grd_19080', 'Location', 'Location', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19081, 'rpt_grd_19081', 'Department', 'Department', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19082, 'rpt_grd_19082', 'Company Name', 'Company Name', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19083, 'rpt_grd_19083', 'Type Of Insider', 'Type Of Insider', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19084, 'rpt_grd_19084', 'Security Type', 'Security Type', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19085, 'rpt_grd_19085', 'Transaction Type', 'Transaction Type', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19086, 'rpt_grd_19086', 'Trades', 'Trades', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19087, 'rpt_grd_19087', 'Buy', 'Buy', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19088, 'rpt_grd_19088', 'Sell', 'Sell', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19089, 'rpt_grd_19089', 'Value', 'Value', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19090, 'rpt_grd_19090', 'Demat Account', 'Demat Account', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19091, 'rpt_grd_19091', 'A/c holder name', 'A/c holder name', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19092, 'rpt_grd_19092', 'Relation with Insider', 'Relation with Insider', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19093, 'rpt_grd_19093', 'Scrip Name', 'Scrip Name', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19094, 'rpt_grd_19094', 'ISIN', 'ISIN', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19095, 'rpt_grd_19095', 'Security Type', 'Security Type', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19096, 'rpt_grd_19096', 'Transaction Type', 'Transaction Type', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19097, 'rpt_grd_19097', 'Trades', 'Trades', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19098, 'rpt_grd_19098', 'Buy', 'Buy', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19099, 'rpt_grd_19099', 'Sell', 'Sell', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19100, 'rpt_grd_19100', 'Value', 'Value', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19101, 'rpt_grd_19101', 'Transaction Date', 'Transaction Date', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19102, 'rpt_grd_19102', 'Trading Details Submission Date', 'Trading Details Submission Date', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19103, 'rpt_grd_19103', 'Continuous Disclosure', 'Continuous Disclosure', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19104, 'rpt_grd_19104', 'Disclosures to be submitted by', 'Last Submission Date', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19105, 'rpt_grd_19105', 'Continuous Disclosure Submission Date', 'Continuous Disclosure Submission Date', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19106, 'rpt_grd_19106', 'Soft Copy', 'Soft Copy', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19107, 'rpt_grd_19107', 'Hard Copy', 'Hard Copy', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19108, 'rpt_grd_19108', 'Comments', 'Comments', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19109, 'rpt_grd_19109', 'Continuous Disclosure to stock exchange submission date', 'Continuous Disclosure to stock exchange submission date', 'en-US', 103011, 104003, 122062, 1 , GETDATE()),
(19110, 'rpt_lbl_19110', 'A/c holder name', 'A/c holder name', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19111, 'rpt_lbl_19111', 'Employee ID:', 'Employee ID:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19112, 'rpt_lbl_19112', 'Insider Name:', 'Insider Name:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19113, 'rpt_lbl_19113', 'Designation:', 'Designation:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19114, 'rpt_lbl_19114', 'Grade:', 'Grade:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19115, 'rpt_lbl_19115', 'Location:', 'Location:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19116, 'rpt_lbl_19116', 'Dept:', 'Dept:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19117, 'rpt_lbl_19117', 'Company Name:', 'Company Name:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19118, 'rpt_lbl_19118', 'Type of Insider:', 'Type of Insider:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19119, 'rpt_lbl_19119', 'Security Type:', 'Security Type:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19120, 'rpt_lbl_19120', 'Transaction Type:', 'Transaction Type:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19121, 'rpt_lbl_19121', 'From:', 'From:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19122, 'rpt_lbl_19122', 'To:', 'To:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19123, 'rpt_lbl_19123', 'CIN/DIN No.:', 'CIN/DIN No.:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19124, 'rpt_lbl_19124', 'Demat ID:', 'Demat ID:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19125, 'rpt_lbl_19125', 'A/c holder name:', 'A/c holder name:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19126, 'rpt_lbl_19126', 'Relationship with Insider:', 'Relationship with Insider:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19127, 'rpt_lbl_19127', 'ISIN:', 'ISIN:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19128, 'rpt_lbl_19128', 'Transaction Date:', 'Transaction Date:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19129, 'rpt_lbl_19129', 'Trading Details Submission date:', 'Trading Details Submission date:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19130, 'rpt_lbl_19130', 'Continous Disclosure:', 'Continous Disclosure:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19131, 'rpt_lbl_19131', 'Continous Disclosure Submission Date (Soft copy):', 'Continous Disclosure Submission Date (Soft copy):', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19132, 'rpt_lbl_19132', 'Continous Disclosure Submission Date (Hard copy):', 'Continous Disclosure Submission Date (Hard copy):', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19133, 'rpt_lbl_19133', 'Comments:', 'Comments:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19134, 'rpt_lbl_19134', 'Continous Disclosure to stock exchange submission date:', 'Continous Disclosure to stock exchange submission date:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19135, 'rpt_lbl_19135', 'Employee ID:', 'Employee ID:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19136, 'rpt_lbl_19136', 'Insider Name:', 'Insider Name:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19137, 'rpt_lbl_19137', 'Designation:', 'Designation:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19138, 'rpt_lbl_19138', 'Grade:', 'Grade:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19139, 'rpt_lbl_19139', 'Location:', 'Location:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19140, 'rpt_lbl_19140', 'Dept:', 'Dept:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19141, 'rpt_lbl_19141', 'Company Name:', 'Company Name:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19142, 'rpt_lbl_19142', 'Type of Insider:', 'Type of Insider:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19143, 'rpt_lbl_19143', 'Submission Date (Soft copy):', 'Submission Date (Soft copy):', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19144, 'rpt_lbl_19144', 'Submission Date (Hard copy):', 'Submission Date (Hard copy):', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19145, 'rpt_lbl_19145', 'Comments:', 'Comments:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19146, 'rpt_lbl_19146', 'Continous Disclosure to stock exchange submission date:', 'Continous Disclosure to stock exchange submission date:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19147, 'rpt_lbl_19147', 'CIN/DIN No.:', 'CIN/DIN No.:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19148, 'rpt_lbl_19148', 'Period From:', 'Period From:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19149, 'rpt_lbl_19149', 'Period End Disclosure Soft copy Submission Date.:', 'Period End Disclosure Soft copy Submission Date.:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19150, 'rpt_lbl_19150', 'Period End Disclosure Hard copy Submission Date.:', 'Period End Disclosure Hard copy Submission Date.:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19151, 'rpt_lbl_19151', 'Status of Submission.:', 'Status of Submission.:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19152, 'rpt_lbl_19152', 'Last Submission date.:', 'Last Submission date.:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19153, 'rpt_ttl_19153', 'Initial Disclosures: Employee Wise', 'Initial Disclosures Employee Wise', 'en-US', 103011, 104006, 122061, 1 , GETDATE()),
(19154, 'rpt_ttl_19154', 'Initial Disclosures: Individual Employee', 'Initial Disclosures Individual Employee', 'en-US', 103011, 104006, 122061, 1 , GETDATE()),
(19155, 'rpt_ttl_19155', 'Continuous Disclosures Employee Wise', 'Continuous Disclosures Employee Wise', 'en-US', 103011, 104006, 122062, 1 , GETDATE()),
(19156, 'rpt_ttl_19156', 'Continuous Disclosures Individual Employee', 'Continuous Disclosures Individual Employee', 'en-US', 103011, 104006, 122062, 1 , GETDATE()),
(19157, 'rpt_ttl_19157', 'Period End Disclosures Employee Wise', 'Period End Disclosures Employee Wise', 'en-US', 103011, 104006, 122060, 1 , GETDATE()),
(19158, 'rpt_ttl_19158', 'Period End Disclosures Individual Employee', 'Period End Disclosures Individual Employee', 'en-US', 103011, 104006, 122060, 1 , GETDATE()),
(19159, 'rpt_ttl_19159', 'Period End Disclosures Individual Employee Details', 'Period End Disclosures Individual Employee Details', 'en-US', 103011, 104006, 122060, 1 , GETDATE()),
(19160, 'rpt_lbl_19160', 'Period To:', 'Period To:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19161, 'rpt_lbl_19161', 'Trading Details Submission date:', 'Trading Details Submission date:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19162, 'rpt_grd_19162', 'Comment', 'Comment', 'en-US', 103011, 104003, 122061, 1 , GETDATE()),
(19163, 'rpt_lbl_19163', 'Demat ID:', 'Demat ID:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19164, 'rpt_lbl_19164', 'Relationship with Insider:', 'Relationship with Insider:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19165, 'rpt_lbl_19165', 'Security Type:', 'Security Type:', 'en-US', 103011, 104002, 122061, 1 , GETDATE()),
(19166, 'rpt_lbl_19166', 'Submission Date:', 'Submission Date:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19167, 'rpt_lbl_19167', 'Year:', 'Year:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19168, 'rpt_lbl_19168', 'Period:', 'Period:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19169, 'rpt_lbl_19169', 'Scrip Name:', 'Scrip Name:', 'en-US', 103011, 104002, 122062, 1 , GETDATE()),
(19170, 'rpt_lbl_19170', 'Demat ID:', 'Demat ID:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19171, 'rpt_lbl_19171', 'Relationship with Insider:', 'Relationship with Insider:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19172, 'rpt_lbl_19172', 'Security Type:', 'Security Type:', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19173, 'rpt_lbl_19173', 'Employee ID:', 'Employee ID:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19174, 'rpt_lbl_19174', 'Name:', 'Insider Name:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19175, 'rpt_lbl_19175', 'Designation:', 'Designation:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19176, 'rpt_lbl_19176', 'Grade:', 'Grade:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19177, 'rpt_lbl_19177', 'Location:', 'Location:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19178, 'rpt_lbl_19178', 'Department:', 'Dept:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19179, 'rpt_lbl_19179', 'Company Name:', 'Company Name:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19180, 'rpt_lbl_19180', 'Type of Insider:', 'Type of Insider:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19181, 'rpt_lbl_19181', 'Pre-clearance ID:', 'Pre-clearance ID:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19182, 'rpt_lbl_19182', 'Request date:', 'Request date:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19183, 'rpt_lbl_19183', 'Transaction Type:', 'Transaction Type:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19184, 'rpt_lbl_19184', 'Security Type:', 'Security Type:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19185, 'rpt_lbl_19185', 'Pre-Clearance Status:', 'Pre-Clearance Status:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19186, 'rpt_lbl_19186', 'Applicable till:', 'Applicable till:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19187, 'rpt_lbl_19187', 'Date of Transaction:', 'Date of Transaction:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19188, 'rpt_lbl_19188', 'Comments:', 'Comments:', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19189, 'rpt_ttl_19189', 'Preclearance Employee Wise', 'Preclearance Employee Wise', 'en-US', 103011, 104006, 122063, 1 , GETDATE()),
(19190, 'rpt_ttl_19190', 'Preclearance Individual Employee', 'Preclearance Individual Employee', 'en-US', 103011, 104006, 122063, 1 , GETDATE()),
(19191, 'rpt_grd_19191', 'Employee Id', 'Employee Id', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19192, 'rpt_grd_19192', 'Insider Name', 'Insider Name', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19193, 'rpt_grd_19193', 'Date of becoming insider', 'Date of becoming insider', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19194, 'rpt_grd_19194', 'Designation', 'Designation', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19195, 'rpt_grd_19195', 'Grade', 'Grade', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19196, 'rpt_grd_19196', 'Location', 'Location', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19197, 'rpt_grd_19197', 'Department', 'Department', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19198, 'rpt_grd_19198', 'Company Name', 'Company Name', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19199, 'rpt_grd_19199', 'Type Of Insider', 'Type Of Insider', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19200, 'rpt_grd_19200', 'Preclearance', 'Preclearance', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19201, 'rpt_grd_19201', 'Request', 'Request', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19202, 'rpt_grd_19202', 'Approved', 'Approved', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19203, 'rpt_grd_19203', 'Rejected', 'Rejected', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19204, 'rpt_grd_19204', 'Pending', 'Pending', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19205, 'rpt_grd_19205', 'Traded', 'Traded', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19206, 'rpt_grd_19206', 'Pre-clearance ID ', 'Pre-clearance ID ', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19207, 'rpt_grd_19207', 'Request date', 'Request date', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19208, 'rpt_grd_19208', 'Scrip name', 'Scrip name', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19209, 'rpt_grd_19209', 'ISIN', 'ISIN', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19210, 'rpt_grd_19210', 'Transaction Type', 'Transaction Type', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19211, 'rpt_grd_19211', 'Security Type', 'Security Type', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19212, 'rpt_grd_19212', 'Number of Securities', 'Qty', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19213, 'rpt_grd_19213', 'Value', 'Value', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19214, 'rpt_grd_19214', 'Pre-Clearance Status', 'Pre-Clearance Status', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19215, 'rpt_grd_19215', 'Status date', 'Status date', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19216, 'rpt_grd_19216', 'Applicable till', 'Applicable till', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19217, 'rpt_grd_19217', 'Trade', 'Trade', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19218, 'rpt_grd_19218', 'Buy ', 'Buy ', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19219, 'rpt_grd_19219', 'Sell', 'Sell', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19220, 'rpt_grd_19220', 'Date of Transaction', 'Date of Transaction', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19221, 'rpt_grd_19221', 'Value', 'Value', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19222, 'rpt_grd_19222', 'Reason for Not Traded', 'Reason for Not Traded', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19223, 'rpt_grd_19223', 'Comments', 'Comments', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19224, 'rpt_grd_19224', 'Preclearance', 'Preclearance', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19225, 'rpt_grd_19225', '', 'Empty heading for Trade Details', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19226, 'rpt_grd_19226', '', 'Empty heading for comment', 'en-US', 103011, 104003, 122063, 1 , GETDATE()),
(19227, 'rpt_lbl_19227', 'Pre-clearance taken', 'Preclearance report comment : Pre-clearance taken', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19228, 'rpt_lbl_19228', 'Traded after pre clearance validity date', 'Preclearance report comment : Traded after pre-clearance date', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19229, 'rpt_lbl_19229', 'Traded without pre-clearance', 'Preclearance report comment : Traded without pre-clearance', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19230, 'rpt_lbl_19230', 'Pre-clearance not required', 'Preclearance report comment : Pre-clearance not required', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19231, 'rpt_lbl_19231', 'Traded during blackout period', 'Preclearance report comment : Traded during blackout period', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19232, 'rpt_lbl_19232', 'Pending', 'Preclearance report comment : Pending', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19233, 'rpt_lbl_19233', 'Traded More Than Pre-Clearance Approved Quantity', 'Preclearance report comment : Traded More Than Pre-Clearance Approved Quantity', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19234, 'rpt_lbl_19234', 'Traded More Than Pre-Clearance Approved Value', 'Preclearance report comment : Traded More Than Pre-Clearance Approved Value', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19235, 'rpt_lbl_19235', 'Traded More Than Pre-Clearance Approved Quantity & Value', 'Preclearance report comment : Traded More Than Pre-Clearance Approved Quantity & Value', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19236, 'rpt_lbl_19236', 'Previous Period Holdings', 'Period End Report Details Report: Previous Period Holding', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19237, 'rpt_lbl_19237', 'Current Period Holdings', 'Period End Report Details Report: Current Period Holdings', 'en-US', 103011, 104002, 122060, 1 , GETDATE()),
(19238, 'rpt_lbl_19238', 'Trade details not yet submitted', 'Preclearance report comment : Trade details not yet submitted', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19239, 'rpt_lbl_19239', 'Contra Trade', 'Preclearance report comment : Contra Trade', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19240, 'rpt_lbl_19240', 'Partially Traded', 'Preclearance report comment : Partially Traded', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),
(19241, 'rpt_lbl_19241', 'Balance trade details pending', 'Preclearance report comment : Balance trade details pending', 'en-US', 103011, 104002, 122063, 1 , GETDATE()),


(19242,'rpt_lbl_19242', 'Employee ID', 'Employee ID', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19243,'rpt_lbl_19243', 'Insider Name', 'Insider Name', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19244,'rpt_lbl_19244', 'Designation', 'Designation', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19245,'rpt_lbl_19245', 'Grade', 'Grade', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19246,'rpt_lbl_19246', 'Location', 'Location', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19247,'rpt_lbl_19247', 'Department', 'Department', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19248,'rpt_lbl_19248', 'Company', 'Company', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19249,'rpt_lbl_19249', 'User Type', 'User Type', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19250,'rpt_lbl_19250', 'Demat Account Number', 'Demat Account Number', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19251,'rpt_lbl_19251', 'Account Holder', 'Account Holder', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19252,'rpt_lbl_19252', 'Pre-Clearance ID', 'Pre-Clearance ID', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19253,'rpt_lbl_19253', 'Pre-Clearance Status', 'Pre-Clearance Status', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19254,'rpt_lbl_19254', 'Transaction Type', 'Transaction Type', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19255,'rpt_lbl_19255', 'Security', 'Security', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19256,'rpt_lbl_19256', 'Trading Details Submission From', 'Trading Details Submission From', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19257,'rpt_lbl_19257', 'Trading Details Submission To', 'Trading Details Submission To', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19258,'rpt_lbl_19258', 'Disclosure Required', 'Disclosure Required', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19259,'rpt_lbl_19259', 'Soft copy Submission From', 'Soft copy Submission From', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19260,'rpt_lbl_19260', 'Soft copy Submission To', 'Soft copy Submission To', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19261,'rpt_lbl_19261', 'Hard copy Submission From', 'Hard copy Submission From', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19262,'rpt_lbl_19262', 'Hard copy Submission To', 'Hard copy Submission To', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19263,'rpt_lbl_19263', 'Stock Exchange submission From', 'Stock Exchange submission From', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19264,'rpt_lbl_19264', 'Stock Exchange submission To', 'Stock Exchange submission To', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19265,'rpt_lbl_19265', 'Non Complaince Type', 'Non Complaince Type', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19266,'rpt_lbl_19266', 'Comments', 'Comments', 'en-US', 103011, 104002, 122075,1, GETDATE()),


(19267,'rpt_ttl_19267', 'Non Complaince Report', 'Non Complaince Report', 'en-US', 103011, 104006,122075, 1, GETDATE()),
(19268,'rpt_lbl_19268', 'Remove From Non-Compliance List', 'Remove From Non-Compliance List', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19269,'rpt_lbl_19269', 'Reason', 'Reason', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19270,'rpt_lbl_19270', 'Upload File', 'Upload File', 'en-US', 103011, 104002, 122075,1, GETDATE()),
(19271,'rpt_ttl_19271', 'Override Non Compliance', 'Override Non Compliance', 'en-US', 103011, 104006, 122075,1, GETDATE()),


(19272,'rpt_grd_19272', '', 'Non Complaince overided', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19273,'rpt_grd_19273', 'Employee ID', 'Employee ID', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19274,'rpt_grd_19274', 'Insider Name', 'Insider Name', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19275,'rpt_grd_19275', 'Joining/becoming insider', 'Joining/becoming insider', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19276,'rpt_grd_19276', 'CIN/DIN no.', 'CIN/DIN no.', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19277,'rpt_grd_19277', 'Designation', 'Designation', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19278,'rpt_grd_19278', 'Grade', 'Grade', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19279,'rpt_grd_19279', 'Location', 'Location', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19280,'rpt_grd_19280', 'Dept', 'Dept', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19281,'rpt_grd_19281', 'Company Name', 'Company Name', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19282,'rpt_grd_19282', 'Type of Insider', 'Type of Insider', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19283,'rpt_grd_19283', 'Demat Account', 'Demat Account', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19284,'rpt_grd_19284', 'A/c holder name', 'A/c holder name', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19285,'rpt_grd_19285', 'Relation with Insider', 'Relation with Insider', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19286,'rpt_grd_19286', 'Pre-clearance ID', 'Pre-clearance ID', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19287,'rpt_grd_19287', 'Request date', 'Request date', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19288,'rpt_grd_19288', 'Requested Qty', 'Requested Qty', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19289,'rpt_grd_19289', 'Requested Value', 'Requested Value', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19290,'rpt_grd_19290', 'Pre-Clearance Status', 'Pre-Clearance Status', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19291,'rpt_grd_19291', 'Status date', 'Status date', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19292,'rpt_grd_19292', 'Pre-clearance Applicable till', 'Pre-clearance Applicable till', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19293,'rpt_grd_19293', 'Scrip Name', 'Scrip Name', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19294,'rpt_grd_19294', 'ISIN', 'ISIN', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19295,'rpt_grd_19295', 'Security Type', 'Security Type', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19296,'rpt_grd_19296', 'Transaction Type', 'Transaction Type', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19297,'rpt_grd_19297', 'Trade', 'Trade', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19298,'rpt_grd_19298', 'Buy', 'Buy', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19299,'rpt_grd_19299', 'Sell', 'Sell', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19300,'rpt_grd_19300', 'Qty', 'Qty', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19301,'rpt_grd_19301', 'Value', 'Value', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19302,'rpt_grd_19302', 'Transaction Date', 'Transaction Date', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19303,'rpt_grd_19303', 'Trading Details Submission date', 'Trading Details Submission date', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19304,'rpt_grd_19304', 'Initial/Continous/Period end Disclosure Required', 'Initial/Continous/Period end Disclosure Required', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19305,'rpt_grd_19305', 'Last Submission date', 'Last Submission date', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19306,'rpt_grd_19306', 'Disclosure Submission Date ', 'Disclosure Submission Date ', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19307,'rpt_grd_19307', 'Soft copy', 'Soft copy', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19308,'rpt_grd_19308', 'Hard copy', 'Hard copy', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19309,'rpt_grd_19309', 'Comments', 'Comments', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19310,'rpt_grd_19310', 'Disclosure to stock exchange  submission date', 'Disclosure to stock exchange  submission date', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19311,'rpt_grd_19311', 'Non Complaince Type', 'Non Complaince Type', 'en-US', 103011, 104003,122075, 1, GETDATE()),
(19312,'rpt_grd_19312', 'Action', 'Action', 'en-US', 103011, 104003,122075, 1, GETDATE()),

(19313,'rpt_msg_19313', 'Defaulter Report ID doesnot found.', 'Defaulter Report ID doesnot found.', 'en-US', 103011, 104001,122075, 1, GETDATE()),
(19314,'rpt_msg_19314', 'Error occurred while mark defaulter report Override.', 'Error occurred while mark defaulter report Override.', 'en-US', 103011, 104001,122075, 1, GETDATE()),
(19315,'rpt_msg_19315', 'Error occurred while fetching defaulter report Override deatils.', 'Error occurred while fetching defaulter report Override deatils.', 'en-US', 103011, 104001,122075, 1, GETDATE()),
(19316,'rpt_msg_19316', 'Error occurred while fetching list defaulter report.', 'Error occurred while fetching list defaulter report.', 'en-US', 103011, 104001,122075, 1, GETDATE()),
(19317,'rpt_msg_19317', 'Mark Override Successfully.', 'Mark Override Successfully.', 'en-US', 103011, 104001,122075, 1, GETDATE()),

/* Script sent by Tushar on 30-Oct-2015 */
(19318,'rpt_lbl_19318', 'Status from Date', 'Status from Date', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19319,'rpt_lbl_19319', 'Status To Date', 'Status To Date', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19320,'rpt_lbl_19320', 'Requested Qty From', 'Requested Qty From', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19321,'rpt_lbl_19321', 'Requested Qty To', 'Requested Qty To', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19322,'rpt_lbl_19322', 'Transaction Date From', 'Transaction Date From', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19323,'rpt_lbl_19323', 'Transaction Date To', 'Transaction Date To', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19324,'rpt_lbl_19324', 'Trade Qty From', 'Trade Qty From', 'en-US', 103011, 104002,122075, 1, GETDATE()),
(19325,'rpt_lbl_19325', 'Trade Qty To', 'Trade Qty To', 'en-US', 103011, 104002,122075, 1, GETDATE()),
/*Added on 14-Jan-2016 Sent by Parag, Added by Raghvendra*/
-- Resources related to period end disclosure report - year and period validation 
(19326, 'rpt_msg_19326','Please select Period', 'Please select Period', 'en-US', 103011, 104001, 122060, 1, GETDATE()),
(19327, 'rpt_msg_19327','Please select Year', 'Please select Year', 'en-US', 103011, 104001, 122060, 1, GETDATE())

-- Added on 13-Oct-2015, received from KPCS for restricted list code merging
-- File # 03. Resource_Master_Labels
INSERT INTO mst_Resource(ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
VALUES 
(50000,'rl_lbl_50000','BSE Code','en-US','103013','104002','122076','BSE Code',1,GETDATE()),
(50001,'rl_lbl_50001','NSE Code','en-US','103013','104002','122076','NSE Code',1,GETDATE()),
(50002,'rl_ttl_50002','Restricted List Search','en-US','103013','104006','122076','Restricted List Search',1,GETDATE()),
(50003,'rl_ttl_50003','Restricted List','en-US','103013','104006','122076','Restricted List',1,GETDATE()),
(50004,'rl_lbl_50004','Created By','en-US','103013','104002','122076','Created By',1,GETDATE()),

-- from file # 05. Com_GridHeaderSettings
(50005,'usr_grd_50005','BSE Code','en-US',103001,104003,122076,'BSE Code',1,GETDATE()),
(50006,'usr_grd_50006','NSE Code','en-US',103001,104003,122076,'NSE Code',1,GETDATE()),
(50007,'usr_grd_50007','ISIN Code','en-US',103001,104003,122076,'ISIN Code',1,GETDATE()),
(50008,'usr_grd_50008','Company Name','en-US',103001,104003,122076,'Company Name',1,GETDATE()),
(50009,'usr_grd_50009','From Date','en-US',103001,104003,122076,'From Date',1,GETDATE()),
(50010,'usr_grd_50010','To Date','en-US',103001,104003,122076,'To Date',1,GETDATE()),
(50011,'usr_grd_50011','Created By','en-US',103001,104003,122076,'Created By',1,GETDATE()),
(50012,'usr_grd_50012','No Of Employee','en-US',103001,104003,122076,'No Of Employee',1,GETDATE()),
(50013,'rl_btn_50013','Download','en-US',103013,104004,122076,'Download',1,GETDATE()),
(50014,'dis_grd_50014','Restricted List Details','en-US',103013,104003,122076,'Restricted List Details',1,GETDATE()),

-- from file # 06. Resource_Master_Messages
(50015,'rl_msg_50015','Trading Allowed for $1 company','en-US','103013','104001','122076','Trading Allowed for $1 company',1,GETDATE()),
(50016,'rl_msg_50016','Trading not Allowed for $1 company','en-US','103013','104001','122076','Trading not Allowed for $1 company',1,GETDATE()),
(50017,'rl_msg_50017','Error occurred while saving code.','en-US','103013','104001','122076','Error occurred while saving code.',1,GETDATE()),
(50018,'rl_btn_50018','Add Restricted List','en-US','103013','104004','122076','Add Restricted List',1,GETDATE()),
(50019,'rl_msg_50019','Error occurred while fetching restricted list data.','en-US','103013','104001','122076','Error occurred while fetching restricted list data.',1,GETDATE()),

-- from file # 07. Resource_Master_Buttons
(50020,'rl_btn_50020','Generate Report','en-US','103013','104004','122076','Generate Report',1,GETDATE()),

/*Script received from KPCS while code merge on 18-Dec */
(50021,'R&T_lbl_50021','R&T Report','en-US','103011','104002','122076','R&T Report',1,GETDATE()),
/*Script received from KPCS while code merge on 4-Feb-2016 */
(50022, 'VwEL_lbl_50022', 'View Error Log Report', 'en-US', '103011', '104002', '122076', 'View Error Log Report', 1, GETDATE()),
(50023,'mst_lbl_50023','Invalid value provided for Holding','en-US','103004','104002','122032','Invalid value provided for Holding', 1, GETDATE()),
(50024,'mst_lbl_50024','Invalid PAN Card Number','en-US','103004','104002','122032','Invalid PAN Card Number', 1, GETDATE()),
(50025,'mst_lbl_50025','Multiple time same record are not allowed','en-US','103004','104002','122032','Multiple time same record are not allowed', 1, GETDATE()),
(50035,'mst_lbl_50035','Invalid value provided for Security Type','en-US','103004','104002','122032','Invalid value provided for Security Type',1, GETDATE()),

/* Script From ED (Gaurav Ugale) on 05-APR-2016  - SCRIPTS FOR SEPARATION MASS-UPLOAD */
(50056,'mst_lbl_50056','Invalid value provided for LoginId','en-US',103004,104002,122032,'Invalid value provided for LoginId',1,GETDATE())

-- Update Existing CR Module Resources For Employee/Insider List (Change grid column header resource module)
UPDATE mst_Resource 
SET 
	ModuleCodeId = 103002,
	ScreenCodeId = 122003
WHERE ResourceId in (11074, 11075, 11076, 11077, 11078, 11079, 11080, 11081, 11082, 11083, 11084, 11085)


-- Update Existing CR Module Resources For Correct Screen code
UPDATE mst_Resource 
SET 
	ModuleCodeId = 103001,
	ScreenCodeId = 122002
WHERE ResourceId in (11001, 11047, 11010, 11002, 11003, 11004, 11058, 11005, 11006, 11252)


/*
Received from Raghvendra: 21-Mar-2016
Corrected the screen code and module code for the policy document list seen by insiders i.e. not co users
*/
UPDATE mst_Resource SET ModuleCodeId = 103008, ScreenCodeId = 122043 WHERE ResourceId in (15344,15345,15346,15347,15415,15348)




/*
Code sync with ED 25-Apr-2016
*/


IF NOT EXISTS (SELECT * FROM mst_Resource WHERE ResourceId = 50057)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50057,'usr_lbl_50057','Depository Name ', 'en-US', 103002, 104002, 122072, 'Depository Name ', 1, GETDATE())	
END

--Demat account note
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50058)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50058,'usr_lbl_50058','1. Under Depository Name, please enter NSDL, CDSL or others, but we have not provided option to update Depository name.', 'en-US', 103002, 104002, 122072, '1. In note we have mentioned: Under Depository Name, please enter NSDL, CDSL or others, but we have not provided option to update Depository name.', 1, GETDATE())	
END
ELSE
	UPDATE mst_Resource SET ResourceValue = '1. Under Depository Name: If you have a demat account, please select NSDL, CDSL. If you have physical shares, select Others' WHERE ResourceId = 50058
	

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50059)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50059,'usr_lbl_50059','2. If you have a Demat account with NSDL, please update your 8 digit Client ID number and DP id No. (DP id Start with "IN").', 'en-US', 103002, 104002, 122072, '2. Working should be: If you have a Demat account with NSDL, please update your 8 digit Client ID number and DP id No. (DP id Start with "IN")', 1, GETDATE())	
END
ELSE
	UPDATE mst_Resource SET ResourceValue = '2. If you have a Demat account with NSDL, please update your 8 digit Client ID number and DP ID Number (DP ID Start with "IN").' WHERE ResourceId = 50059

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50060)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50060,'usr_lbl_50060','3. Please update your 16 digit Client id Number (starting 8 digit will be your DP ID number)', 'en-US', 103002, 104002, 122072, '3. If you have a Demate account with CDSL, Please update your 16 digit Client id Number (starting 8 digit will be your DP ID number)', 1, GETDATE())	
END
ELSE
	UPDATE mst_Resource SET ResourceValue = '3. If you have a Demat account with CDSL, please update your 16 digit Client ID Number (starting 8 digits will be your DP ID number)' WHERE ResourceId = 50060
	
	
IF NOT EXISTS (SELECT * FROM mst_Resource WHERE ResourceId = 50061)
BEGIN	
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50061,'usr_lbl_50061','4. If you have physical shares, select ‚ÄúPhysical Shares‚Äù under Depository Participant name and enter your folio number under Client ID (this will be auto populated under Depository Participant ID)', 'en-US', 103002, 104002, 122072, '4. If you have physical shares, select "Physical Shares" under Depository Participant name and enter your folio number under Client ID (this will be auto populated under Depository Participant ID) ', 1, GETDATE())	
END	

IF NOT EXISTS (SELECT * FROM mst_Resource where ResourceId = '16430')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId,ScreenCodeId,ModifiedBy, ModifiedOn)
	VALUES 
	(16430,'tra_msg_16430', 'You cannot proceed these transaction quantity does not exist in the pool, you are missing some transaction or you enter more quantity than traded', 'You cannot proceed these transaction quantity does not exist in the pool, you are missing some transaction or you enter more quantity than traded', 'en-US', 103008, 104001,122036,1, GETDATE())
END

/* 
Code sync with ED 25-Apr-2016 completed
*/

/* 
Script received from from ED on 11-May-2016
*/
INSERT INTO mst_Resource 
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES
	(50062, 'tra_lbl_50062', 
	'Note: The number of shares displayed under ìSecuritiesî is your balance of shares as on 1st April, 2016. Please note that transactions post 1st April, 2016 can be viewed on the ìPreclearances / Continuous Disclosuresî webpage. Please update shareholding of your relatives as on 1st April, 2016 by clicking on "Add Shares" link on this screen.', 
	'en-US', '103008', '104002', '122036', 
	'Note: The number of shares displayed under ìSecuritiesî is your balance of shares as on 1st April, 2016. Please note that transactions post 1st April, 2016 can be viewed on the ìPreclearances / Continuous Disclosuresî webpage. Please update shareholding of your relatives as on 1st April, 2016 by clicking on "Add Shares" link on this screen.', 1, 
	GETDATE() )


/*
	Script ED on 07-June-2016
	by ANIKET SHINGATE (24-MAY-2016) - THIS SCRIPT IS USED TO SAVE VALUES IN mst_Resource TABLES FOR VALIDATION MASSAGE.
*/
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES 
(50063, 'usr_msg_50063', 'The Demat Account Type is required.', 'en-US', 103001, 104001, 122001, 'The Demat Account Type is required.', 1, GETDATE()),
(50064, 'usr_msg_50064', 'CDSL, Please update your 16 digit Demat Account number.', 'en-US', 103001, 104001, 122001, 'CDSL, Please update your 16 digit Demat Account number.', 1, GETDATE()),
(50065, 'usr_msg_50065', 'NSDL, please update your 8 digit Demat account number.', 'en-US', 103001, 104001, 122001, 'NSDL, please update your 8 digit Demat account number.', 1, GETDATE()),
(50066, 'usr_msg_50066', 'DP ID number should start with IN followed by 6 digits.', 'en-US', 103001, 104001, 122001, 'DP ID number should start with IN followed by 6 digits.', 1, GETDATE()),
(50067, 'usr_msg_50067', 'Client ID Number already exists..', 'en-US', 103001, 104001, 122001, 'Client ID Number already exists.', 1, GETDATE()),
(50068, 'usr_msg_50068', 'The Depository Participant Name is required.', 'en-US', 103001, 104001, 122001, 'The Depository Participant Name is required.', 1, GETDATE()),
(50073, 'usr_msg_50073', 'The DP Name is required.', 'en-US', 103001, 104001, 122001, 'The DP Name is required.', 1, GETDATE())

/*
	Script ED on 04-Aug-2016
	Code Merge from SVN "From ED" branch
*/
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
VALUES 
(50069, 'rul_lbl_50069', 'Seek declaration from employee regarding possession of UPSI', 'en-US', 103006, 104002, 122040, 'Seek declaration from employee regarding possession of UPSI', 1, GETDATE()),
(50070, 'rul_lbl_50070', 'If Yes, Enter the declaration sought from the insider at the time of continuous disclosures', 'en-US', 103006, 104002, 122040, 'If Yes, Enter the declaration sought from the insider at the time of continuous disclosures', 1, GETDATE()),
(50071, 'rul_lbl_50071', 'Declaration to be Mandatory', 'en-US', 103006, 104002, 122040, 'Declaration to be Mandatory', 1, GETDATE()),
(50072, 'rul_lbl_50072', 'Display the declaration post submission of Continuouse Disclosure', 'en-US', 103006, 104002, 122040, 'Display the declaration post submission of Continuouse Disclosure', 1, GETDATE()),
(50074, 'tra_msg_50074', 'Please select the confirmation checkbox to submit your trade details.', 'en-US', 103008, 104001, 122036, 'Please select the confirmation checkbox to submit your trade details.', 1, GETDATE())


/*
Script received from Tushar on 2 May 2016 --  Change for show date in contra trade message
*/
UPDATE mst_Resource
SET ResourceValue = 'This Pre-clearance request violates Contra Trade rules.  Contra trading is not allowed till $1 for $2 transaction types.',
    OriginalResourceValue = 'This Pre-clearance request violates Contra Trade rules.  Contra trading is not allowed till $1 for $2 transaction types.'
WHERE ResourceId = 17343

/*
Script received from Tushar on 2 May 2016 --  
*/
UPDATE mst_Resource SET ResourceValue = 'Total Traded Value', OriginalResourceValue = 'Total Traded Value'
WHERE ResourceId = 17448