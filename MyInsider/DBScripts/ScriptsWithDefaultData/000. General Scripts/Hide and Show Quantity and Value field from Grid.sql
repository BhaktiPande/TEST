DECLARE @EnableQtyValueSetting INT=0

SELECT @EnableQtyValueSetting=EnableDisableQuantityValue FROM mst_Company WHERE CompanyId=1

IF(@EnableQtyValueSetting=400003)
BEGIN
		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53070')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53070' AND GridTypeCodeId=114120)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='tra_grd_53070' AND GridTypeCodeId=114120
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53069')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53069' AND GridTypeCodeId=114120)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='tra_grd_53069' AND GridTypeCodeId=114120
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53071')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53071' AND GridTypeCodeId=114120)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='tra_grd_53071' AND GridTypeCodeId=114120
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53072')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53072' AND GridTypeCodeId=114120)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='tra_grd_53072' AND GridTypeCodeId=114120
			 END
		END


		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52015')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52015' AND GridTypeCodeId=114109)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_52015' AND GridTypeCodeId=114109
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52016')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52016' AND GridTypeCodeId=114109)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_52016' AND GridTypeCodeId=114109
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52017')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52017' AND GridTypeCodeId=114109)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_52017' AND GridTypeCodeId=114109
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52018')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52018' AND GridTypeCodeId=114109)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_52018' AND GridTypeCodeId=114109
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52019')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52019' AND GridTypeCodeId=114109)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_52019' AND GridTypeCodeId=114109
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52027')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52027' AND GridTypeCodeId=114110)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_52027' AND GridTypeCodeId=114110
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52028')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52028' AND GridTypeCodeId=114110)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_52028' AND GridTypeCodeId=114110
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52029')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52029' AND GridTypeCodeId=114110)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_52029' AND GridTypeCodeId=114110
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52030')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52030' AND GridTypeCodeId=114110)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_52030' AND GridTypeCodeId=114110
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52031')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52031' AND GridTypeCodeId=114110)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_52031' AND GridTypeCodeId=114110
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_53019')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_53019' AND GridTypeCodeId=114118)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_53019' AND GridTypeCodeId=114118
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_53012')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_53012' AND GridTypeCodeId=114118)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_53012' AND GridTypeCodeId=114118
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_53020')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_53020' AND GridTypeCodeId=114118)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='dis_grd_53020' AND GridTypeCodeId=114118
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53085')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53085' AND GridTypeCodeId=114121)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='tra_grd_53085' AND GridTypeCodeId=114121
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53086')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53086' AND GridTypeCodeId=114121)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='tra_grd_53086' AND GridTypeCodeId=114121
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53087')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53087' AND GridTypeCodeId=114121)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='tra_grd_53087' AND GridTypeCodeId=114121
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53088')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53088' AND GridTypeCodeId=114121)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='tra_grd_53088' AND GridTypeCodeId=114121
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='rl_grd_50581')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='rl_grd_50581' AND GridTypeCodeId=507005)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='rl_grd_50581' AND GridTypeCodeId=507005
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='rl_grd_50582')
				BEGIN
					 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='rl_grd_50582' AND GridTypeCodeId=507005)
					 BEGIN
						UPDATE com_GridHeaderSetting SET IsVisible=0 WHERE ResourceKey='rl_grd_50582' AND GridTypeCodeId=507005
					 END
				END
END
ELSE
BEGIN

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53070')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53070' AND GridTypeCodeId=114120)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='tra_grd_53070' AND GridTypeCodeId=114120
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53069')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53069' AND GridTypeCodeId=114120)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='tra_grd_53069' AND GridTypeCodeId=114120
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53071')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53071' AND GridTypeCodeId=114120)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='tra_grd_53071' AND GridTypeCodeId=114120
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53072')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53072' AND GridTypeCodeId=114120)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='tra_grd_53072' AND GridTypeCodeId=114120
			 END
		END


		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52015')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52015' AND GridTypeCodeId=114109)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_52015' AND GridTypeCodeId=114109
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52016')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52016' AND GridTypeCodeId=114109)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_52016' AND GridTypeCodeId=114109
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52017')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52017' AND GridTypeCodeId=114109)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_52017' AND GridTypeCodeId=114109
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52018')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52018' AND GridTypeCodeId=114109)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_52018' AND GridTypeCodeId=114109
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52019')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52019' AND GridTypeCodeId=114109)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_52019' AND GridTypeCodeId=114109
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52027')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52027' AND GridTypeCodeId=114110)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_52027' AND GridTypeCodeId=114110
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52028')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52028' AND GridTypeCodeId=114110)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_52028' AND GridTypeCodeId=114110
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52029')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52029' AND GridTypeCodeId=114110)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_52029' AND GridTypeCodeId=114110
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52030')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52030' AND GridTypeCodeId=114110)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_52030' AND GridTypeCodeId=114110
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_52031')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_52031' AND GridTypeCodeId=114110)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_52031' AND GridTypeCodeId=114110
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_53019')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_53019' AND GridTypeCodeId=114118)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_53019' AND GridTypeCodeId=114118
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_53012')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_53012' AND GridTypeCodeId=114118)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_53012' AND GridTypeCodeId=114118
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='dis_grd_53020')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_53020' AND GridTypeCodeId=114118)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='dis_grd_53020' AND GridTypeCodeId=114118
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53085')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53085' AND GridTypeCodeId=114121)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='tra_grd_53085' AND GridTypeCodeId=114121
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53086')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53086' AND GridTypeCodeId=114121)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='tra_grd_53086' AND GridTypeCodeId=114121
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53087')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53087' AND GridTypeCodeId=114121)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='tra_grd_53087' AND GridTypeCodeId=114121
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='tra_grd_53088')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='tra_grd_53088' AND GridTypeCodeId=114121)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='tra_grd_53088' AND GridTypeCodeId=114121
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='rl_grd_50581')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='rl_grd_50581' AND GridTypeCodeId=507005)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='rl_grd_50581' AND GridTypeCodeId=507005
			 END
		END

		IF EXISTS(SELECT * FROM mst_Resource WHERE ResourceKey='rl_grd_50582')
		BEGIN
			 IF EXISTS(SELECT * FROM com_GridHeaderSetting WHERE ResourceKey='rl_grd_50582' AND GridTypeCodeId=507005)
			 BEGIN
				UPDATE com_GridHeaderSetting SET IsVisible=1 WHERE ResourceKey='rl_grd_50582' AND GridTypeCodeId=507005
			 END
		END
END



