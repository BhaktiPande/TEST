IF EXISTS(select * from mst_MenuMaster where MenuID in(44,45) )
BEGIN
		Update mst_MenuMaster set ImageURL='fa fa-question-circle' where  MenuID in(44,45)
END

