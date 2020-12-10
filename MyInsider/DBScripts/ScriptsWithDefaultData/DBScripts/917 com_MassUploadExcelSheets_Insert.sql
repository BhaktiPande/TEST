-----------------------------Excel Sheets Details entry in com_MassUploadExcelSheets----------------
INSERT INTO com_MassUploadExcelSheets (MassUploadExcelSheetId, MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES(1,1,'EmpInsider',1,NULL,'st_com_MassUploadCommonProcedureExecution',24)
INSERT INTO com_MassUploadExcelSheets (MassUploadExcelSheetId, MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES(2,1,'NonEmpInsider',1,NULL,'st_com_MassUploadCommonProcedureExecution',24)
INSERT INTO com_MassUploadExcelSheets (MassUploadExcelSheetId, MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES(3,1,'CorporateInsider',1,NULL,'st_com_MassUploadCommonProcedureExecution',18)
INSERT INTO com_MassUploadExcelSheets (MassUploadExcelSheetId, MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES(4,1,'EmpRelatives',0,'EmpInsider','st_com_MassUploadCommonProcedureExecution',12)
INSERT INTO com_MassUploadExcelSheets (MassUploadExcelSheetId, MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES(5,1,'NonEmpRelatives',0,'NonEmpInsider','st_com_MassUploadCommonProcedureExecution',12)
INSERT INTO com_MassUploadExcelSheets (MassUploadExcelSheetId, MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES(6,1,'EmpInsiderDEMAT',0,'EmpInsider','st_com_MassUploadCommonProcedureExecution',8)
INSERT INTO com_MassUploadExcelSheets (MassUploadExcelSheetId, MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES(7,1,'NonEmpInsiderDEMAT',1,'NonEmpInsider','st_com_MassUploadCommonProcedureExecution',8)
INSERT INTO com_MassUploadExcelSheets (MassUploadExcelSheetId, MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES(8,1,'CorporateInsiderDEMAT',0,'CorporateInsider','st_com_MassUploadCommonProcedureExecution',8)
INSERT INTO com_MassUploadExcelSheets (MassUploadExcelSheetId, MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES(9,1,'EmpRelativeDEMAT',0,'EmpRelatives','st_com_MassUploadCommonProcedureExecution',8)
INSERT INTO com_MassUploadExcelSheets (MassUploadExcelSheetId, MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES(10,1,'NonEmpRelativeDEMAT',0,'NonEmpRelatives','st_com_MassUploadCommonProcedureExecution',8)

/* Script sent by Raghvendra on 13-Oct-2015 */
INSERT INTO [dbo].[com_MassUploadExcelSheets]
([MassUploadExcelSheetId] ,[MassUploadExcelId] ,[SheetName] ,[IsPrimarySheet] ,[ParentSheetName] ,[ProcedureUsed] ,[ColumnCount])
VALUES (11 ,2 ,'InitialDisclosure' ,1 ,NULL ,'st_com_MassUploadCommonProcedureExecution' , 15)

/* Script sent by Raghvendra on 28-Dec-2015 */
INSERT INTO [dbo].[com_MassUploadExcelSheets] ( [MassUploadExcelSheetId] ,[MassUploadExcelId] ,[SheetName] ,[IsPrimarySheet] ,[ParentSheetName] ,[ProcedureUsed] ,[ColumnCount] )
VALUES( 12,4,'PastPreClearance',1, null,'st_com_MassUploadCommonProcedureExecution',14 )
,( 13,4,'PastContDisc',0, 'PastPreClearance','st_com_MassUploadCommonProcedureExecution',21 )

/* Script sent by Raghvendra on 29-Dec-2015 */
INSERT INTO [dbo].[com_MassUploadExcelSheets] ([MassUploadExcelSheetId] ,[MassUploadExcelId] ,[SheetName] ,[IsPrimarySheet] ,[ParentSheetName] ,[ProcedureUsed] ,[ColumnCount])
VALUES (14 ,5 ,'OnGoingContDisc' ,1 ,NULL ,'st_com_MassUploadCommonProcedureExecution' ,22)


/*Script received from KPCS while code merge on 18-Dec */
INSERT INTO COM_MASSUPLOADEXCELSHEETS(MassUploadExcelSheetId,MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES 	(51,51,'RegisterAndTransfer',1,NULL,'st_com_MassUploadCommonProcedureExecution',10)

  
/*Script received from KPCS while code merge on 04-Jan-2016*/
--Changed the ColumnCount by ED 
UPDATE COM_MASSUPLOADEXCELSHEETS SET ColumnCount = 8 WHERE MassUploadExcelSheetId = 51 

/*Script updated sent by ED during code merging on 4-Feb-2016*/
/* Script for Non Trading Days MASS UPLOAD */
INSERT INTO COM_MASSUPLOADEXCELSHEETS(MassUploadExcelSheetId,MassUploadExcelId,SheetName,IsPrimarySheet,ParentSheetName,ProcedureUsed,ColumnCount)
VALUES 	(52,52,'NonTradingDays',1,NULL,'st_com_MassUploadCommonProcedureExecution',2)