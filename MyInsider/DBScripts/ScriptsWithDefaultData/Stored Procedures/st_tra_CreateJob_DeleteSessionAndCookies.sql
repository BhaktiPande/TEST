/*Drop procedure if already exists and then run the CREATE script*/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_CreateJob_DeleteSessionAndCookies')
DROP PROCEDURE [dbo].[st_tra_CreateJob_DeleteSessionAndCookies]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure is used to Delete session and cookie values
Returns:		
				
Created by:		Shubhangi
Created on:		10-Sept-2019
-------------------------------------------------------------------------------------------------*/
--exec st_tra_CreateJob_DeleteSessionAndCookies 8,AnandGlobalPeriodEnd
CREATE PROCEDURE [dbo].[st_tra_CreateJob_DeleteSessionAndCookies]
(
	@inp_nMasterDBCompanyId INT,			--CompanyId from the master database corresponding to the implementing company for which the job is to be scheduled
	@inp_sCompanyDBName VARCHAR(50),		--Name of the company database
	@out_nSQLErrNo	INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurrs.
	@out_sSQLErrMsg	VARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurrs.
)
AS
/****** Object:  Job [KPCSDelteSessionandCookieValues]    Script Date: 10/09/2019 17:42:03 ******/
DECLARE @sJobName VARCHAR(50)
SET @sJobName = 'KPCSDelteSessionandCookieValues' + CAST(@inp_nMasterDBCompanyId AS VARCHAR(10)) + '_' + @inp_sCompanyDBName

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 23/10/2018 17:42:03 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@sJobName, 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'This job is created to Delete user session', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 1]    Script Date: 23/10/2018 17:42:04 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec st_usr_DeleteExpiredSessions', 
		@database_name=@inp_sCompanyDBName, 
		@flags=0		
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=@sJobName, 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20181023, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'07f25454-cc2a-4bc4-a931-ce87861332ed'	
		
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

