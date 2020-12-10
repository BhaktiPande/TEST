-----------------------------Data Table Details entry in com_MassUploadDataTable-------------------

INSERT INTO com_MassUploadDataTable (MassUploadDataTableId, MassUploadDataTableName)
VALUES(1,'MassEmployeeInsiderImportDataTable')
INSERT INTO com_MassUploadDataTable (MassUploadDataTableId, MassUploadDataTableName)
VALUES(2,'MassNonEmployeeInsiderImportDataTable')
INSERT INTO com_MassUploadDataTable (MassUploadDataTableId, MassUploadDataTableName)
VALUES(3,'MassCorpEmployeeInsiderImportDataTable')
INSERT INTO com_MassUploadDataTable (MassUploadDataTableId, MassUploadDataTableName)
VALUES(4,'MassRelativesImportDataTable')
INSERT INTO com_MassUploadDataTable (MassUploadDataTableId, MassUploadDataTableName)
VALUES(5,'MassDmatDetailsImportDataTable')

/* Script sent on 13-Oct-2015 by Raghvendra */
--Add DataTable
INSERT INTO [com_MassUploadDataTable] ([MassUploadDataTableId] ,[MassUploadDataTableName])
VALUES (6 ,'MassInitialDisclosureDataTable')

/* Script sent by Raghvendra on 28-Dec-2015 */
INSERT INTO [dbo].[com_MassUploadDataTable] ([MassUploadDataTableId] ,[MassUploadDataTableName])
VALUES (8,'MassHistoryPreclearanceRequestImportDataTable')
INSERT INTO [dbo].[com_MassUploadDataTable] ([MassUploadDataTableId] ,[MassUploadDataTableName])
VALUES (9,'MassHistoryTransactionImportDataTable') 

/* Script sent by Raghvendra on 29-Dec-2015 */
INSERT INTO [dbo].[com_MassUploadDataTable] ([MassUploadDataTableId] ,[MassUploadDataTableName])
VALUES (10 ,'MassTransactionImportDataTable')


/*Script received from KPCS while code merge on 18-Dec */
/*Add new entry for Register and Transfer Mass Upload table entry*/
INSERT INTO com_MassUploadDataTable(MassUploadDataTableId,MassUploadDataTableName) 
VALUES (51,'MassRegisterAndTransferDataTable')


/*Script updated sent by ED during code merging on 4-Feb-2016*/
/* SCRIPT FOR NON TRADING DAYS MASS */
INSERT INTO com_MassUploadDataTable(MassUploadDataTableId,MassUploadDataTableName) 
VALUES (52,'MassNonTradingDaysDataTable')
