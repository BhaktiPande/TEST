/*DROP old table : rul_ApplicabilityDetails*/

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_com_Code_ApplyToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails] DROP CONSTRAINT [FK_rul_ApplicabilityDetails_com_Code_ApplyToTypeCodeId]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityDetails_rul_ApplicabilityFlags_ApplicabilityFlagId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]'))
ALTER TABLE [dbo].[rul_ApplicabilityDetails] DROP CONSTRAINT [FK_rul_ApplicabilityDetails_rul_ApplicabilityFlags_ApplicabilityFlagId]
GO

/****** Object:  Table [dbo].[rul_ApplicabilityDetails]    Script Date: 04/09/2015 14:45:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityDetails]') AND type in (N'U'))
DROP TABLE [dbo].[rul_ApplicabilityDetails]
GO

--------------------------------------------------------------------------------------------------
/*DROP old table : rul_ApplicabilityMaster*/

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityMaster_rul_ApplicabilityFlags_ApplicabilityFlagId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityMaster]'))
ALTER TABLE [dbo].[rul_ApplicabilityMaster] DROP CONSTRAINT [FK_rul_ApplicabilityMaster_rul_ApplicabilityFlags_ApplicabilityFlagId]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_ApplicabilityMaster_Flag1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_ApplicabilityMaster] DROP CONSTRAINT [DF_rul_ApplicabilityMaster_Flag1]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_ApplicabilityMaster_Flag2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_ApplicabilityMaster] DROP CONSTRAINT [DF_rul_ApplicabilityMaster_Flag2]
END

GO



/****** Object:  Table [dbo].[rul_ApplicabilityMaster]    Script Date: 04/09/2015 14:48:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityMaster]') AND type in (N'U'))
DROP TABLE [dbo].[rul_ApplicabilityMaster]
GO
--------------------------------------------------------------------------------------------------
/*DROP old table : rul_ApplicabilityFlags*/



IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_ApplicabilityFlags_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityFlags]'))
ALTER TABLE [dbo].[rul_ApplicabilityFlags] DROP CONSTRAINT [FK_rul_ApplicabilityFlags_com_Code_MapToTypeCodeId]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_ApplicabilityFlags_AllEmployeeFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_ApplicabilityFlags] DROP CONSTRAINT [DF_rul_ApplicabilityFlags_AllEmployeeFlag]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_ApplicabilityFlags_AllInsiderFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_ApplicabilityFlags] DROP CONSTRAINT [DF_rul_ApplicabilityFlags_AllInsiderFlag]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_ApplicabilityFlags_AllEmployeeInsidersFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_ApplicabilityFlags] DROP CONSTRAINT [DF_rul_ApplicabilityFlags_AllEmployeeInsidersFlag]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Table_1_AllCorporateFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_ApplicabilityFlags] DROP CONSTRAINT [DF_Table_1_AllCorporateFlag]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Table_1_AllNonEmployeeFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_ApplicabilityFlags] DROP CONSTRAINT [DF_Table_1_AllNonEmployeeFlag]
END

GO


/****** Object:  Table [dbo].[rul_ApplicabilityFlags]    Script Date: 04/09/2015 14:44:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_ApplicabilityFlags]') AND type in (N'U'))
DROP TABLE [dbo].[rul_ApplicabilityFlags]
GO
--------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (94, '094 rul_Applicability_Old_Tables_Drop', 'Drop applicability related old tables - rul_ApplicabilityFlags, rul_ApplicabilityMaster, rul_ApplicabilityDetails', 'Ashashree')





