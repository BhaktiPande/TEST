IF NOT EXISTS(Select * from mst_Resource where ResourceId=64003)
	 INSERT INTO mst_Resource VALUES(
	 64003,'usr_btn_64003','Download Company Master List','en-US',103301,104004,122076,'Download Company Master List',1,GETDATE())
GO