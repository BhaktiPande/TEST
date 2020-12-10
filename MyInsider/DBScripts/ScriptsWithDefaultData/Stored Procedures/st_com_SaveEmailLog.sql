
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_SaveEmailLog')
	DROP PROCEDURE [dbo].st_com_SaveEmailLog
	GO
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	/*-------------------------------------------------------------------------------------------------
	Description:	Save Email log
	Returns:		0, if Success.
				
	Created by:		Samadhan
	Created on:		24-Oct-2019

	Modification History:
	Usage:
	EXEC st_com_SaveEmailLog 

	declare @p3 dbo.EmailLogDataTable
	insert into @p3 values(1,N'622',N'samadhan_kadam1@yahoo.com',N'samadhan@esopdirect.com',NULL,N'Published Mail',N'<div style="margin: 30px; width: 1080px;font-family: ''Roboto'', sans-serif;font-size:12px; padding-left:10px;">
				<div>
					<div>
						Hi,
						<p>Please note that the following unpublished price sensitive information (UPSI) that was shared has now been published:</p>
						<br />
						Category of Information: Financials<br />
						Reason for sharing information: Board Meeting<br />
						Mode of sharing information: Email<br />
						Date and Time of sharing information:  05 Nov 2019: 14:00<br />
						Date of publishing: 06 Nov 2019<br /><br />
						Information shared by : <br />
						Name: Novit magre  <br />
						Email: <br /><br />
							

						Information updated on Vigilante by:<br />
						Name: Administrator  
					</div>
				</div>
			</div>',NULL,N'noreply@esopdirect.com',N'Success',N'Success',N'1','2019-11-06 16:36:05.0380974',N'1','2019-11-06 16:36:05.0380974')
	insert into @p3 values(2,N'1627',N'shubhangi@esopdirect.com',N'samadhan@esopdirect.com',NULL,N'Published Mail',N'<div style="margin: 30px; width: 1080px;font-family: ''Roboto'', sans-serif;font-size:12px; padding-left:10px;">
				<div>
					<div>
						Hi,
						<p>Please note that the following unpublished price sensitive information (UPSI) that was shared has now been published:</p>
						<br />
						Category of Information: Financials<br />
						Reason for sharing information: Board Meeting<br />
						Mode of sharing information: Email<br />
						Date and Time of sharing information:  05 Nov 2019: 14:00<br />
						Date of publishing: 06 Nov 2019<br /><br />
						Information shared by : <br />
						Name: Novit magre  <br />
						Email: <br /><br />
							

						Information updated on Vigilante by:<br />
						Name: Administrator  
					</div>
				</div>
			</div>',NULL,N'noreply@esopdirect.com',N'Success',N'Success',N'1','2019-11-06 16:36:05.9302723',N'1','2019-11-06 16:36:05.9302723')

	declare @p4 int
	set @p4=0
	declare @p5 int
	set @p5=NULL
	declare @p6 varchar(1)
	set @p6=NULL
	exec sp_executesql N'exec st_com_SaveEmailLog @0, @1 OUTPUT, @2 OUTPUT, @3 OUTPUT',N'@0 [dbo].[EmailLogDataTable] READONLY,@1 int output,@2 int output,@3 varchar(8000) output',@0=@p3,@1=@p4 output,@2=@p5 output,@3=@p6 output
	select @p4, @p5, @p6
	-------------------------------------------------------------------------------------------------*/
	CREATE PROCEDURE st_com_SaveEmailLog
	@inp_tblEamilProperties AS EmailLogDataTable READONLY,
	@out_nReturnValue		int= 0 OUTPUT,
	@out_nSQLErrCode		int= 0 OUTPUT,
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT
	As
	BEGIN
	DECLARE @ResponseStatusCodeIdSuccess INT
	DECLARE @ResponseMessageSuccess VARCHAR(MAX)
	DECLARE @ResponseStatusCodeIdFail INT
	DECLARE @ResponseMessageFail VARCHAR(MAX)
	SELECT @ResponseStatusCodeIdSuccess=ResourceId,@ResponseMessageSuccess=ResourceValue FROM mst_Resource WHERE ResourceId=54182 
	
	SELECT @ResponseStatusCodeIdFail=ResourceId,@ResponseMessageFail=ResourceValue FROM mst_Resource WHERE ResourceId=54183
		INSERT INTO cmu_NotificationOntheFly
		(
				UserId ,
				[To],
				CC,
				[Subject],
				Contents,
				[Signature],
				CommunicationFrom,
				ResponseStatusCodeId,
				ResponseMessage,
				CreatedBy,
				CreatedOn,
				ModifiedBy,
				ModifiedOn 
		)
		SELECT UserInfoId ,
				[To],
				CC,
				[Subject],
				Contents,
				[Signature],
				CommunicationFrom,
				CASE WHEN ResponseStatusCodeId ='Success' THEN @ResponseStatusCodeIdSuccess ELSE @ResponseStatusCodeIdFail END AS ResponseStatusCodeId,
				CASE WHEN ResponseMessage ='Success' THEN @ResponseMessageSuccess ELSE @ResponseMessageFail END AS ResponseMessage ,
				CreatedBy,
				convert(datetime, convert(varchar(23),CreatedOn,106)),
				ModifiedBy,
			    convert(datetime, convert(varchar(23),ModifiedOn,106))
			FROM @inp_tblEamilProperties

				set @out_nReturnValue=0

	END-- MAIN BIGN END
