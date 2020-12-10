IF NOT EXISTS (SELECT CodeID from com_Code where CodeID=153068)
BEGIN
		INSERT  INTO com_Code  VALUES(153068,'Not Traded',153,'Not Traded',1,1,68,null,null,1,GETDATE());
END

