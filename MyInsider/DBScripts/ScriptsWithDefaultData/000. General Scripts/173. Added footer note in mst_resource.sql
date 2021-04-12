--Added mst_resource which used in PeriodStatusOS
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource 
                           WHERE ResourceId=64004)
	BEGIN
		INSERT INTO mst_Resource VALUES 
		(64004,'dis_lbl_64004','Please upload your De-mat statements (Transactions and Holdings), if any before clicking on the “Confirm” button.','en-us',103303,104002,122034,
		'Please upload your De-mat statements (Transactions and Holdings), if any before clicking on the “Confirm” button.',1,dbo.uf_com_GetServerDate())
	END