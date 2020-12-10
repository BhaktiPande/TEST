-- ======================================================================================================
-- Author      : Shubhangi Gurude												=
-- CREATED DATE: 15-NOV-2017                                                 							=
-- Description : SCRIPTS TO ENTER CONTINUOUS DISCLOSURE DURING PERIOD END    												=
-- ======================================================================================================

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId='50591')
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50591,'dis_lbl_50591','Please submit previous continuous disclosure transaction','en-US','103009','104001','122048','Please submit previous continuous disclosure transaction',1,GETDATE())
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CDDuringPE' AND OBJECT_ID = OBJECT_ID(N'[tra_TransactionMaster]'))
BEGIN
	ALTER TABLE [dbo].[tra_TransactionMaster] ADD  [CDDuringPE][BIT] null default 0
END 

