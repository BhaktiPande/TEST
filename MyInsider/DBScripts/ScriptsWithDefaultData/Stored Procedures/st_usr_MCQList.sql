IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_MCQList')
DROP PROCEDURE [dbo].[st_usr_MCQList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list MCQ 

Returns:		0, if Success.
				
Created by:		Samadhan kadam
Created on:		02-May-2019

Usage:
EXEC st_usr_MCQList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_MCQList]
	 @inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)=null
	,@inp_sSortOrder				VARCHAR(5)=null
	,@inp_iUserInfoID				INT=0
	,@inp_iFlag                     int=0
	,@inp_iQuestion					VARCHAR(max)=null
	,@inp_iAnswerTypes				int=2
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_Question_LIST INT =54140 -- Error occurred while fetching list of questions details.

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'

	   SELECT @inp_sSortOrder = 'DESC'
	 SELECT @inp_sSortField = 'MQB.QuestionId' 
		
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',MQB.QuestionID),MQB.QuestionID '				
		SELECT @sSQL = @sSQL + ' FROM MCQ_QuestionBank MQB'

	
		
		PRINT(@sSQL)
		EXEC(@sSQL)

				select MQB.QuestionID,MQB.Question as usr_grd_54101,
				case when AnswerTypes=1 then 'Radio button' else 'Check box'end as usr_grd_54102 ,
				OptionNumbers as OptionNumbers,
				LEFT(STUFF((select  CHAR(10) + OptionNo+'.'+QuestionsAnswer +' ,' from MCQ_QuestionBankDetails as MQBD where MQB.QuestionID=MQBD.QuestionID  FOR XML PATH('')), 1, 1, ''),len(STUFF((select  CHAR(10) + OptionNo+'.'+QuestionsAnswer +' ,' from MCQ_QuestionBankDetails as MQBD where MQB.QuestionID=MQBD.QuestionID  FOR XML PATH('')), 1, 1, ''))-1) as usr_grd_54103 ,
				(select case when CorrectAnswer=1 then OptionNo+'.'+ QuestionsAnswer else '' end  from MCQ_QuestionBankDetails as MQBD where MQB.QuestionID=MQBD.QuestionID FOR XML PATH('')) as usr_grd_54104
				from MCQ_QuestionBank as MQB  inner join  #tmpList T on MQB.QuestionID= T.EntityID
				WHERE MQB.QuestionID IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
				ORDER BY T.RowNumber 

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_Question_LIST
	END CATCH
END
