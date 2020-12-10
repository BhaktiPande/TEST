/*Drop procedure if already exists and then run the CREATE script*/
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_CreateJob_DefaulterGenerator')
DROP PROCEDURE [dbo].[st_rpt_CreateJob_DefaulterGenerator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure when executed creats a job which will run on daily basis. 
				The job created runs daily at 2am and executes procedure "st_rpt_Job_DefaulterGenerator" 
				to generate defaulter entries into table "rpt_DefaulterReport"

Returns:		
				
Created by:		Arundhati
Created on:		05-Oct-2015

Modification History:
Modified By		Modified On		Description
Arundhati		15-Oct-2015		Comments and description changed in the procedure
Parag			13-Apr-2015		Made change job schedule - this job will run on every day on 00:30:00 am 

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE st_rpt_CreateJob_DefaulterGenerator
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
	DECLARE @ERR_JOB_CREATE_DefaulterReport INT = -1

	BEGIN TRY
		--USE [msdb]
		/*--------- CREATE Defaulter report Generator JOB ---------------------*/
		DECLARE @ReturnCode INT
		SET @sJobName = 'DefaulterReport' + CAST(@inp_nMasterDBCompanyId AS VARCHAR(10)) + '_' + @sDBName
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
				@description=N'Job to generate records and populate defaulter report table', 
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

				EXECUTE @RC = [dbo].[st_rpt_Job_DefaulterGenerator] 
				GO', 
				@database_name=@sDBName, 
				@flags=0
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
		IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
		DECLARE @scheduleUid uniqueidentifier
		DECLARE @scheduleId INT
		DECLARE @sScheduleName NVARCHAR(128)
		SET @sScheduleName = N'DefaulterReport'+ CAST(@inp_nMasterDBCompanyId AS VARCHAR(10)) +'_Daily'
		EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, 
				@name= @sScheduleName, 
				@enabled=1, 
				@freq_type=4, 	--Specifies the execution frequency : 1=Once, 4=Daily, 8=Weekly, 16=Monthly etc
				@freq_interval=1, 
				@freq_subday_type=1, --Specifies the units for frequency_subday_interval. 1=At the specified time, 4=Minutes, 8=Hours
				@freq_subday_interval=0,  --Specifies number of frequency_subday_type periods to occur between each execution of the job.
				@freq_relative_interval=0, --Unused for this job creation
				@freq_recurrence_factor=0, --Unused for this job creation
				@active_start_date=20150531, 
				@active_end_date=99991231, 
				@active_start_time=003000, --Start time is set as midnight timing 00:30:00am
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

		RETURN @ERR_JOB_CREATE_DefaulterReport
	END CATCH
END