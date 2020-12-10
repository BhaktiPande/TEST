
/****** Object:  Table [dbo].[du_Insider_Trading_Mis_History]    Script Date: 16-07-2018 16:14:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[du_Insider_Trading_Mis_History]') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[du_Insider_Trading_Mis_History](

	[ENTITY_ID] [varchar](500) NULL,
	[EMP_NO] [varchar](500) NULL,
	[TRD_NO] [varchar](500) NULL,
	[ENT_FULL_NAME] [varchar](500) NULL,
	[ENTITY_DP_AC_NO] [varchar](500) NULL,
	[TRD_DT] DATETIME NULL,
	[SMST_ISIN_CODE] [varchar](500) NULL,
	[SMST_SECURITY_NAME] [varchar](500) NULL,
	[TRD_SEM_ID] [varchar](500) NULL,
	[TRD_BUY_SELL_FLG] [varchar](500) NULL ,
	TRD_QTY    decimal(18,2) NULL,
	TRD_PRICE  DECIMAL(18,2) NULL,
	[ENTITY_PAN] [varchar](20) NULL,	
	[CREATED_ON] DATETIME,
	[ROW_NO] [bigint] IDENTITY(1,1) NOT NULL
	)
		
END

GO


