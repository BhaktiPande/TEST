IF NOT EXISTS(Select * from mst_Resource where ResourceId=64001)
	 INSERT INTO mst_Resource VALUES(
	 64001,'rpt_lbl_64001','Defaulter','en-US',103011,104002,122058,'Defaulter',1,GETDATE())
GO
IF NOT EXISTS(Select * from mst_Resource where ResourceId=64002)
	 INSERT INTO mst_Resource VALUES(
	 64002,'rpt_lbl_64002','Designation','en-US',103011,104002,122058,'Designation',1,GETDATE())
GO


