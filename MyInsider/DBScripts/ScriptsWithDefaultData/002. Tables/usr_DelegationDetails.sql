/****** Object:  Table [dbo].[usr_DelegationDetails]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_DelegationDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_DelegationDetails](
	[DelegationId] [bigint] NOT NULL,
	[ActivityId] [int] NOT NULL,
 CONSTRAINT [PK_usr_DelegationDetails] PRIMARY KEY CLUSTERED 
(
	[DelegationId] ASC,
	[ActivityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationDetails_usr_Activity_ActivityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationDetails]'))
ALTER TABLE [dbo].[usr_DelegationDetails]  WITH CHECK ADD  CONSTRAINT [FK_usr_DelegationDetails_usr_Activity_ActivityId] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[usr_Activity] ([ActivityID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationDetails_usr_Activity_ActivityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationDetails]'))
ALTER TABLE [dbo].[usr_DelegationDetails] CHECK CONSTRAINT [FK_usr_DelegationDetails_usr_Activity_ActivityId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationDetails_usr_DelegationMaster_DelegationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationDetails]'))
ALTER TABLE [dbo].[usr_DelegationDetails]  WITH CHECK ADD  CONSTRAINT [FK_usr_DelegationDetails_usr_DelegationMaster_DelegationId] FOREIGN KEY([DelegationId])
REFERENCES [dbo].[usr_DelegationMaster] ([DelegationId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationDetails_usr_DelegationMaster_DelegationId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationDetails]'))
ALTER TABLE [dbo].[usr_DelegationDetails] CHECK CONSTRAINT [FK_usr_DelegationDetails_usr_DelegationMaster_DelegationId]
GO
