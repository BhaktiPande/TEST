-- ======================================================================================================
-- Author      : Gaurav Ugale (ED Team)																			=
-- CREATED DATE: 04-JAN-2016                                                 							=
-- Description : THIS TABLE TYPE IS USED FOR Non-Trading Day Mass-Upload								=
-- ======================================================================================================
CREATE TABLE NonTradingDays
(	
	NonTradDay		DATETIME NOT NULL,
	Exchangetype	INT NOT NULL,
	Reason			VARCHAR(200) NOT NULL	
)

ALTER TABLE [dbo].[NonTradingDays]  WITH CHECK ADD  CONSTRAINT [FK_NonTradingDays_com_Code_Exchangetype] FOREIGN KEY([Exchangetype])
REFERENCES [dbo].[com_Code] ([CodeID])

------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (226, '226 NonTradingDays_Create', 'NonTradingDays Added new table for maintaining the Trading Holidays', 'ED Team')

------------------------------------------------------------------------------------------------------------------------