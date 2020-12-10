/* Prefix to be used for modules
cmu : Communication Module
*/

/* Prefix to be used for categories
msg : Error Message (104001)
*/

/*
Range to be used for error codes
Communication Module: 10001 - 10999
*/

/* First error code for each module should start at 10001 */

INSERT INTO mst_Resource(ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModifiedOn)
VALUES 
('cmu_msg_10001', 'Company with given CompanyId not found', 'Company with given CompanyId not found', 'en-US', GETDATE())
,('cmu_msg_10002', 'Error occurred while generating the linked server instance for company database', 'Error occurred while generating the linked server instance for company database', 'en-US', GETDATE())

,('cmu_msg_10003', 'Error occurred while fetching company details to send notification', 'Error occurred while fetching company details to send notification', 'en-US', GETDATE())
,('cmu_msg_10004', 'SMTP server is not defined for company', 'SMTP server is not defined for company', 'en-US', GETDATE())

,('cmu_msg_10005', 'Error occurred while fetching list of company IDs', 'Error occurred while fetching list of company IDs', 'en-US', GETDATE())

,('cmu_msg_10006', 'Error occurred while fetching count of companies', 'Error occurred while fetching count of companies', 'en-US', GETDATE())

,('cmu_msg_10007', 'Error occurred while fetching notifications to send', 'Error occurred while fetching notifications to send', 'en-US', GETDATE())
,('cmu_msg_10008', 'Linked server name is not defined for company', 'Linked server name is not defined for company', 'en-US', GETDATE())
,('cmu_msg_10009', 'Database name is not defined for company', 'Database name is not defined for company', 'en-US', GETDATE())

,('cmu_msg_10010', 'Error occurred while updating notification response', 'Error occurred while updating notification response', 'en-US', GETDATE())

,('cmu_msg_10011', 'Database servername is not defined for company', 'Database servername is not defined for company', 'en-US', GETDATE())

,('cmu_msg_10012', 'Connection username is not defined for company database', 'Connection username is not defined for company database', 'en-US', GETDATE())
,('cmu_msg_10013', 'Connection password is not defined for company database', 'Connection password is not defined for company database', 'en-US', GETDATE())




