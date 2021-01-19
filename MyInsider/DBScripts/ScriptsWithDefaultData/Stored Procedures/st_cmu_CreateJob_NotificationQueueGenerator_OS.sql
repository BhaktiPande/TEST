/*Drop procedure if already exists and then run the CREATE script*/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_cmu_CreateJob_NotificationQueueGenerator_OS')
DROP PROCEDURE [dbo].[st_cmu_CreateJob_NotificationQueueGenerator_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure when executed creats a job which will run on daily basis. 
				The job created runs continuously after every 15 mins and executes procedure "st_cmu_Job_NotificationQueueGenerator_OS" 
				to generate notification entries into table "cmu_NotificationQueue" for notifications to send / display to user

Returns:		
				
Created by:		Hemant kawade
Created on:		11-Dec-2020

Modification History:
Modified By		Modified On		Description

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE st_cmu_CreateJob_NotificationQueueGenerator_OS
(
	@inp_nMasterDBCompanyId INT,			--CompanyId from the master database corresponding to the implementing company for which the job is to be scheduled
	@inp_sCompanyDBName VARCHAR(50),		--Name of the company database
	@out_nSQLErrNo	INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurrs.
	@out_sSQLErrMsg	VARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurrs.
)
AS
BEGIN
	DECLARE @sDBName VARCHAR(50) = @inp_sCompanyDBName
	DECLARE @sJobName VARCHAR(50)
	DECLARE @ERR_JOB_CREATE_NOTIFICATIONQUEUEGENERATOR INT = -1

	BEGIN TRY
		--USE [msdb]
		/*--------- CREATE NotificationQueueGenerator JOB ---------------------*/
		DECLARE @ReturnCode INT
		SET @sJobName = 'KPCSVigilanteComp' + CAST(@inp_nMasterDBCompanyId AS VARCHAR(10)) + '_' + @sDBName
		/****** Object:  Job [Vigilante_QGenerator]    Script Date: 10/06/2015 23:11:00 ******/
		BEGIN TRANSACTION
		SELECT @ReturnCode = 0
		/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 10/06/2015 23:11:00 ******/
		IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
		BEGIN
		EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

		END

		DECLARE @jobId BINARY(16)
		EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@sJobName, 
				@enabled=1, 
				@notify_level_eventlog=2, 
				@notify_level_email=0, 
				@notify_level_netsend=0, 
				@notify_level_page=0, 
				@delete_level=0, 
				@description=N'Job to generate records and populate the notification queue', 
				@category_name=N'[Uncategorized (Local)]', 
				@owner_login_name=N'sa', 
				@job_id = @jobId OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		/****** Object:  Step [Step1]    Script Date: 10/06/2015 23:11:00 ******/
		EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, 
				@step_name=N'Step1', 
				@step_id=1, 
				@subsystem=N'TSQL', 
				@cmdexec_success_code=0, 
				@on_success_action=1, 
				@on_success_step_id=0, 
				@on_fail_action=2, 
				@on_fail_step_id=0, 
				@retry_attempts=0, 
				@retry_interval=0, 
				@os_run_priority=0, 
				
				@command=N'DECLARE @RC int

				-- TODO: Set parameter values here.

				EXECUTE @RC = [dbo].[st_cmu_Job_NotificationQueueGenerator_OS] 
				GO', 
				@database_name=@sDBName, 
				@flags=0
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		DECLARE @scheduleUid uniqueidentifier
		DECLARE @scheduleId INT
		DECLARE @sScheduleName NVARCHAR(128)
		SET @sScheduleName = N'KPCSVigilanteComp'+ CAST(@inp_nMasterDBCompanyId AS VARCHAR(10)) +'_DailyEvery_15min'
		EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, 
				@name= @sScheduleName, 
				@enabled=1, 
				@freq_type=4, 
				@freq_interval=1, 
				@freq_subday_type=4, --Specifies the units for frequency_subday_interval. 1=At the specified time, 4=Minutes, 8=Hours
				@freq_subday_interval=15,  --Specifies number of frequency_subday_type periods to occur between each execution of the job.
				@freq_relative_interval=0, --Unused for this job creation
				@freq_recurrence_factor=0, --Unused for this job creation
				@active_start_date=20150531, 
				@active_end_date=99991231, 
				@active_start_time=000000, --Start time is set as midnight timing 00:00:00am
				@active_end_time=235959, 
				@schedule_id = @scheduleId OUTPUT,
				@schedule_uid = @scheduleUid OUTPUT
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		COMMIT TRANSACTION
		GOTO EndSave	
	
		QuitWithRollback:
			IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
		EndSave:
		
		RETURN 0
	END TRY
	BEGIN CATCH
		--SELECT @@TRANCOUNT
		IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
		
		SET @out_nSQLErrNo = ERROR_NUMBER()
		SET @out_sSQLErrMsg = ERROR_MESSAGE()

		RETURN @ERR_JOB_CREATE_NOTIFICATIONQUEUEGENERATOR
	END CATCH
END