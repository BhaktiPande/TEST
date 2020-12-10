-- Drop the master tables created so far

-- Drop mst_State

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_State_mst_Country_CountryID]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_State]'))
ALTER TABLE [dbo].[mst_State] DROP CONSTRAINT [FK_mst_State_mst_Country_CountryID]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_State_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_State]'))
ALTER TABLE [dbo].[mst_State] DROP CONSTRAINT [FK_mst_State_usr_UserInfo_CreatedBy]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_State_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_State]'))
ALTER TABLE [dbo].[mst_State] DROP CONSTRAINT [FK_mst_State_usr_UserInfo_ModifiedBy]
GO

/****** Object:  Table [dbo].[mst_State]    Script Date: 02/05/2015 14:46:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mst_State]') AND type in (N'U'))
DROP TABLE [dbo].[mst_State]
GO

-------------------------------------------------------------------------------------------------------------

-- Drop mst_Country

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Country_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Country]'))
ALTER TABLE [dbo].[mst_Country] DROP CONSTRAINT [FK_mst_Country_usr_UserInfo_CreatedBy]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Country_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Country]'))
ALTER TABLE [dbo].[mst_Country] DROP CONSTRAINT [FK_mst_Country_usr_UserInfo_ModifiedBy]
GO

/****** Object:  Table [dbo].[mst_Country]    Script Date: 02/05/2015 14:44:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mst_Country]') AND type in (N'U'))
DROP TABLE [dbo].[mst_Country]
GO

-------------------------------------------------------------------------------------------------------------

-- Drop Department

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Department_com_Code_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Department]'))
ALTER TABLE [dbo].[mst_Department] DROP CONSTRAINT [FK_mst_Department_com_Code_Status]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Department_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Department]'))
ALTER TABLE [dbo].[mst_Department] DROP CONSTRAINT [FK_mst_Department_usr_UserInfo_CreatedBy]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Department_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Department]'))
ALTER TABLE [dbo].[mst_Department] DROP CONSTRAINT [FK_mst_Department_usr_UserInfo_ModifiedBy]
GO

/****** Object:  Table [dbo].[mst_Department]    Script Date: 02/05/2015 14:47:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mst_Department]') AND type in (N'U'))
DROP TABLE [dbo].[mst_Department]
GO

-------------------------------------------------------------------

-- Drop Designation

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Designation_com_Code_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Designation]'))
ALTER TABLE [dbo].[mst_Designation] DROP CONSTRAINT [FK_mst_Designation_com_Code_Status]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Designation_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Designation]'))
ALTER TABLE [dbo].[mst_Designation] DROP CONSTRAINT [FK_mst_Designation_usr_UserInfo_CreatedBy]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Designation_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Designation]'))
ALTER TABLE [dbo].[mst_Designation] DROP CONSTRAINT [FK_mst_Designation_usr_UserInfo_ModifiedBy]
GO

/****** Object:  Table [dbo].[mst_Designation]    Script Date: 02/05/2015 14:48:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mst_Designation]') AND type in (N'U'))
DROP TABLE [dbo].[mst_Designation]
GO


-------------------------------------------------------------------

-- Drop Grade

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Grade_com_Code_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Grade]'))
ALTER TABLE [dbo].[mst_Grade] DROP CONSTRAINT [FK_mst_Grade_com_Code_Status]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Grade_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Grade]'))
ALTER TABLE [dbo].[mst_Grade] DROP CONSTRAINT [FK_mst_Grade_usr_UserInfo_CreatedBy]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_mst_Grade_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[mst_Grade]'))
ALTER TABLE [dbo].[mst_Grade] DROP CONSTRAINT [FK_mst_Grade_usr_UserInfo_ModifiedBy]
GO

/****** Object:  Table [dbo].[mst_Grade]    Script Date: 02/05/2015 14:48:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mst_Grade]') AND type in (N'U'))
DROP TABLE [dbo].[mst_Grade]
GO

-------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (41, '041 Drop Country State Grade Dept Designation masters', 'Drop master tables created so far', 'Arundhati')
