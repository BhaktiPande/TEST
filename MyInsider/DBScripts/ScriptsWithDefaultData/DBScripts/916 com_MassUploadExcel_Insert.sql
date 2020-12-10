------------------------------Excel Import entry in com_MassUploadExcel-----------------------
INSERT INTO com_MassUploadExcel (MassUploadExcelId, MassUploadName, HasMultipleSheets,TemplateFileName)
values (1, 'Employee Bulk Import',1,'EmployeeMassUploadTemplate')

/*Script sent by Raghvendra on 13-Oct-2015 */

--Add Mass upload Excel Entry
INSERT INTO com_MassUploadExcel (MassUploadExcelId, MassUploadName, HasMultipleSheets,TemplateFileName)
VALUES(2, 'Innitial Disclosure',0, 'InitialDisclosureMassUploadTemplate')

/*Raghvendra on 14-Oct-2015 */
/*Updated the names for the Mass Upload as same will be seen on the screens*/
UPDATE com_MassUploadExcel SET MassUploadName = 'Insider Mass Upload' WHERE MassUploadExcelId = 1

UPDATE com_MassUploadExcel SET MassUploadName = 'Initial Disclosure Mass Upload' WHERE MassUploadExcelId = 2

/*Script received from KPCS while code merge on 18-Dec */
INSERT INTO com_MassUploadExcel (MassUploadExcelId, MassUploadName,HasMultipleSheets)
VALUES (51,'Register and Transfer Mass Upload',0)

/* Script received by Raghvendra on 28-Dec-2015*/
--Add   Mass Upload Configurations for Past 6 Months Historic Preclearance and Transactions data
INSERT INTO [dbo].[com_MassUploadExcel] ( [MassUploadExcelId] ,[MassUploadName] ,[HasMultipleSheets],TemplateFileName )
VALUES (4,'Past Pre-Clearance and Transactions Mass Upload',0,'PastPreClearanceAndTransactions')

/* Script received by Raghvendra on 29-Dec-2015*/
-- Add mass upload for ongoing disclosure data
INSERT INTO com_MassUploadExcel (MassUploadExcelId,MassUploadName,HasMultipleSheets,TemplateFileName)
VALUES(5, 'On Going Continuous Disclosure Mass Upload',0,'OnGoingContinuousDisclosuretransactions')

/*Script updated sent by ED during code merging on 4-Jan-2016*/
--Updated the TemplateName for the Mass Upload
UPDATE com_MassUploadExcel SET TemplateFileName = 'RegisterandTransferUploadTemplate' WHERE MassUploadExcelId = 51

/*Script updated sent by ED during code merging on 4-Feb-2016*/
/* Script for Non Trading Days MASS UPLOAD  */
INSERT INTO com_MassUploadExcel (MassUploadExcelId, MassUploadName,HasMultipleSheets,TemplateFileName)
VALUES (52,'Non Trading Days/Holiday',0,'NonTradingDaysTemplate')