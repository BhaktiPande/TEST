using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsiderTradingDAL
{
    public class MCQDAL : IDisposable
    {
        const string sLookUpPrefix = "tra_msg_";

        #region GetDetails
        public IEnumerable<MCQDTO> GetMCQDetailsList(string i_sConnectionString, MCQDTO i_objMCQDTO)
        {
            #region Paramters
            List<MCQDTO> lstMCQDTOList = null;
            string sErrCode = string.Empty;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters

            try
            {

                #region Output Param
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                #endregion Output Param

                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        lstMCQDTOList = db.Query<MCQDTO>("exec st_MCQSettingSave @MCQS_ID OUTPUT,@inp_FirstTimeLogin,@inp_IsSpecificPeriodWise,@inp_FrequencyOfMCQ,@inp_IsDatewise,@inp_FrequencyDate,@inp_FrequencyDuration"
                            + ",@inp_BlockUserAfterDuration,@inp_NoOfQuestionForDisplay,@inp_AccessTOApplicationForWriteAnswer,@inp_NoOfAttempts,@inp_BlockuserAfterExceedAtempts,@inp_UnblockForNextFrequency,@inp_iOperation,@inp_CreatedBy"
                            + ",@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_FirstTimeLogin = i_objMCQDTO.FirstTimeLogin,
                                inp_IsSpecificPeriodWise = i_objMCQDTO.IsSpecificPeriodWise,
                                inp_FrequencyOfMCQ = i_objMCQDTO.FrequencyOfMCQ,
                                inp_IsDatewise = i_objMCQDTO.IsDatewise,
                                inp_FrequencyDate = i_objMCQDTO.FrequencyDate,
                                inp_FrequencyDuration = i_objMCQDTO.FrequencyDuration,
                                inp_BlockUserAfterDuration = i_objMCQDTO.BlockUserAfterDuration,
                                inp_NoOfQuestionForDisplay = i_objMCQDTO.NoOfQuestionForDisplay,
                                inp_AccessTOApplicationForWriteAnswer = i_objMCQDTO.AccessTOApplicationForWriteAnswer,
                                inp_NoOfAttempts = i_objMCQDTO.NoOfAttempts,
                                inp_BlockuserAfterExceedAtempts = i_objMCQDTO.BlockuserAfterExceedAtempts,
                                inp_UnblockForNextFrequency = i_objMCQDTO.UnblockForNextFrequency,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Return Error Code
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                            #endregion Return Error Code
                        }
                        else
                        {
                            scope.Complete();
                        }
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstMCQDTOList;
        }
        public MCQDTO GetMCQDetails(string i_sConnectionString, int MCQS_ID, string Flag)
        {
            MCQDTO res = null;

            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters
            try
            {
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<MCQDTO>("exec st_MCQSettingSave @MCQS_ID OUTPUT,@inp_FirstTimeLogin,@inp_IsSpecificPeriodWise,@inp_FrequencyOfMCQ,@inp_IsDatewise,@inp_FrequencyDate,@inp_FrequencyDuration"
                            + ",@inp_BlockUserAfterDuration,@inp_NoOfQuestionForDisplay,@inp_AccessTOApplicationForWriteAnswer,@inp_NoOfAttempts,@inp_BlockuserAfterExceedAtempts,@inp_UnblockForNextFrequency,@inp_iOperation,@inp_CreatedBy"
                            + ",@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {

                                MCQS_ID = MCQS_ID,
                                inp_FirstTimeLogin = 0,
                                inp_IsSpecificPeriodWise = 0,
                                inp_FrequencyOfMCQ = 0,
                                inp_IsDatewise = 0,
                                inp_FrequencyDate = DateTime.Now,
                                inp_FrequencyDuration = 0,
                                inp_BlockUserAfterDuration = 0,
                                inp_NoOfQuestionForDisplay = 0,
                                inp_AccessTOApplicationForWriteAnswer = 0,
                                inp_NoOfAttempts = 0,
                                inp_BlockuserAfterExceedAtempts = 0,
                                inp_UnblockForNextFrequency = 0,
                                inp_iOperation = Flag,
                                inp_CreatedBy = 0,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).FirstOrDefault<MCQDTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }

                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                        }
                    }
                }


            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }

        public MCQ_QUESTION_DTO GetMCQQuestionDetails(string i_sConnectionString, int Question_ID, string Flag, int userinfoid = 0)
        {
            MCQ_QUESTION_DTO res = null;

            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters
            try
            {
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                var inp_tblMCQQuestionList = new SqlParameter();
                inp_tblMCQQuestionList.DbType = DbType.Object;
                inp_tblMCQQuestionList.ParameterName = "@inp_tblMCQQuestionType";
                inp_tblMCQQuestionList.TypeName = "dbo.MCQQuestionType";
                inp_tblMCQQuestionList.SqlValue = null;
                inp_tblMCQQuestionList.SqlDbType = SqlDbType.Structured;

                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<MCQ_QUESTION_DTO>("exec st_MCQ_QuestionDetails @inp_tblMCQQuestionType,@QuestionId,@UserInfoID,@Question,@AnswerType,@OptionNumber,@inp_iOperation,@AttemptNo, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {

                                @inp_tblMCQQuestionType = inp_tblMCQQuestionList,
                                @QuestionId = Question_ID,
                                @UserInfoID = userinfoid,
                                @Question = "",
                                @AnswerType = "",
                                @OptionNumber = 1,
                                @inp_iOperation = Flag,
                                @AttemptNo = 0,
                                @out_nReturnValue = nReturnValue,
                                @out_nSQLErrCode = nSQLErrCode,
                                @out_sSQLErrMessage = sSQLErrMessage


                            }).FirstOrDefault<MCQ_QUESTION_DTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }

                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                        }
                    }
                }


            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        public IEnumerable<MCQ_QUESTION_DTO> GetMCQQuestionDetailsList(string i_sConnectionString, MCQ_QUESTION_DTO i_objMCQ_QUESTION_DTO, string Flag)
        {
            IEnumerable<MCQ_QUESTION_DTO> res = null;

            string sErrCode = string.Empty;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters
            try
            {
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                var inp_tblMCQQuestionList = new SqlParameter();
                inp_tblMCQQuestionList.DbType = DbType.Object;
                inp_tblMCQQuestionList.ParameterName = "@inp_tblMCQQuestionType";
                inp_tblMCQQuestionList.TypeName = "dbo.MCQQuestionType";
                inp_tblMCQQuestionList.SqlValue = null;
                inp_tblMCQQuestionList.SqlDbType = SqlDbType.Structured;

                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<MCQ_QUESTION_DTO>("exec st_MCQ_QuestionDetails @inp_tblMCQQuestionType,@QuestionId,@UserInfoID,@Question,@AnswerType,@OptionNumber,@inp_iOperation,@AttemptNo, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {

                                @inp_tblMCQQuestionType = inp_tblMCQQuestionList,
                                @QuestionId = 0,
                                @UserInfoID = 0,
                                @Question = "",
                                @AnswerType = "",
                                @OptionNumber = 1,
                                @inp_iOperation = Flag,
                                @AttemptNo = 0,
                                @out_nReturnValue = nReturnValue,
                                @out_nSQLErrCode = nSQLErrCode,
                                @out_sSQLErrMessage = sSQLErrMessage


                            }).ToList();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }

                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                        }
                    }
                }


            }
            catch (Exception exp)
            {
                throw exp;
            }
            return res;
        }
        #endregion GetDetails
        #region InsertUpdateMCQDetails
        public MCQDTO InsertUpdateMCQDetails(string i_sConnectionString, MCQDTO i_objMCQDTO, string Flag)
        {
            #region Paramters
            List<MCQDTO> res = null;
            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters

            try
            {
                #region Output Param
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";



                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {


                        res = db.Fetch<MCQDTO>("exec st_MCQSettingSave @MCQS_ID OUTPUT,@inp_FirstTimeLogin,@inp_IsSpecificPeriodWise,@inp_FrequencyOfMCQ,@inp_IsDatewise,@inp_FrequencyDate,@inp_FrequencyDuration"
                            + ",@inp_BlockUserAfterDuration,@inp_NoOfQuestionForDisplay,@inp_AccessTOApplicationForWriteAnswer,@inp_NoOfAttempts,@inp_BlockuserAfterExceedAtempts,@inp_UnblockForNextFrequency,@inp_iOperation,@inp_CreatedBy"
                            + ",@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                MCQS_ID = i_objMCQDTO.MCQS_ID,
                                inp_FirstTimeLogin = i_objMCQDTO.FirstTimeLogin,
                                inp_IsSpecificPeriodWise = i_objMCQDTO.IsSpecificPeriodWise,
                                inp_FrequencyOfMCQ = i_objMCQDTO.FrequencyOfMCQ,
                                inp_IsDatewise = i_objMCQDTO.IsDatewise,
                                inp_FrequencyDate = i_objMCQDTO.FrequencyDate,
                                inp_FrequencyDuration = i_objMCQDTO.FrequencyDuration,
                                inp_BlockUserAfterDuration = i_objMCQDTO.BlockUserAfterDuration,
                                inp_NoOfQuestionForDisplay = i_objMCQDTO.NoOfQuestionForDisplay,
                                inp_AccessTOApplicationForWriteAnswer = i_objMCQDTO.AccessTOApplicationForWriteAnswer,
                                inp_NoOfAttempts = i_objMCQDTO.NoOfAttempts,
                                inp_BlockuserAfterExceedAtempts = i_objMCQDTO.BlockuserAfterExceedAtempts,
                                inp_UnblockForNextFrequency = i_objMCQDTO.UnblockForNextFrequency,
                                inp_iOperation = Flag,
                                inp_CreatedBy = 1,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList();


                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                            #endregion  Error Code
                        }

                        else
                        {


                            scope.Complete();
                            return res.FirstOrDefault();
                        }

                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }

        #endregion

        #region MCQ Questions

        public MCQ_QUESTION_DTO InsertUpdateMCQQuestionDetails(string sConnectionString, MCQ_QUESTION_DTO objMCQ_QUESTION_DTO, DataTable dt_MCQQuestionList, string Flag)
        {
            #region Paramters
            MCQ_QUESTION_DTO res = null;

            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters

            try
            {
                #region Out Paramter
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                var inp_tblMCQQuestionList = new SqlParameter();
                inp_tblMCQQuestionList.DbType = DbType.Object;
                inp_tblMCQQuestionList.ParameterName = "@inp_tblMCQQuestionType";
                inp_tblMCQQuestionList.TypeName = "dbo.MCQQuestionType";
                inp_tblMCQQuestionList.SqlValue = dt_MCQQuestionList;
                inp_tblMCQQuestionList.SqlDbType = SqlDbType.Structured;
                #endregion Out Paramter



                using (db = new PetaPoco.Database(sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {


                        res = db.Fetch<MCQ_QUESTION_DTO>("exec st_MCQ_QuestionDetails @inp_tblMCQQuestionType,@QuestionId,@UserInfoID,@Question,@AnswerType,@OptionNumber,@inp_iOperation,@AttemptNo, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                           new
                           {

                               @inp_tblMCQQuestionType = inp_tblMCQQuestionList,
                               @QuestionId = objMCQ_QUESTION_DTO.QuestionID,
                               @UserInfoID = objMCQ_QUESTION_DTO.UserinfoID,
                               @Question = objMCQ_QUESTION_DTO.Question,
                               @AnswerType = objMCQ_QUESTION_DTO.AnswerTypes,
                               @OptionNumber = objMCQ_QUESTION_DTO.OptionNumbers,
                               @inp_iOperation = Flag,
                               @AttemptNo = objMCQ_QUESTION_DTO.AttemptNo,
                               @out_nReturnValue = nReturnValue,
                               @out_nSQLErrCode = nSQLErrCode,
                               @out_sSQLErrMessage = sSQLErrMessage

                           }).SingleOrDefault();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                            #endregion  Error Code
                        }

                        else
                        {


                            scope.Complete();
                            return res;
                        }
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            //return res;
        }

        #endregion

        #region MCQ Report/AutoSearch Result
        public IEnumerable<MCQ_REPORT_DTO> GetMCQReportList(string i_sConnectionString, MCQ_REPORT_DTO i_objMCQ_REPORT_DTO)
        {
            #region Paramters
            List<MCQ_REPORT_DTO> lstMCQ_REPORT_DTOList = null;
            string sErrCode = string.Empty;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters

            try
            {

                #region Output Param
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //  nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";
                sSQLErrMessage.Size = 500;
                #endregion Output Param

                //  db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient");

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {
                    using (var scope = db.GetTransaction())
                    {
                        lstMCQ_REPORT_DTOList = db.Query<MCQ_REPORT_DTO>("exec st_MCQ_Reports @UserInfoId,@EmployeeID,@Name,@Department,@Designation,@MCQ_Status,@StartDate,@EndDate"
                            + ",@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {

                                UserInfoId = i_objMCQ_REPORT_DTO.UserInfoId,
                                EmployeeID = i_objMCQ_REPORT_DTO.EmployeeId,
                                Name = i_objMCQ_REPORT_DTO.Name,
                                Department = i_objMCQ_REPORT_DTO.Department,
                                Designation = i_objMCQ_REPORT_DTO.Designation,
                                MCQ_Status = i_objMCQ_REPORT_DTO.MCQ_Status,
                                StartDate = i_objMCQ_REPORT_DTO.StartDate,
                                EndDate = i_objMCQ_REPORT_DTO.EndDate,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Return Error Code
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                            #endregion Return Error Code
                        }
                        else
                        {
                            scope.Complete();
                        }
                    }
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }
            return lstMCQ_REPORT_DTOList;
        }

        public List<MCQ_REPORT_DTO> AutoCompleteList(string i_sConnectionString, Hashtable HT_SearchParam)
        {
            List<MCQ_REPORT_DTO> res = null;
            #region Paramters
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            PetaPoco.Database db = null;
            #endregion Paramters
            try
            {

                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                //nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Value = "";

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {

                        res = db.Query<MCQ_REPORT_DTO>("exec st_MCQ_AutoSearchList @inp_sAction, @inp_sEmployeeId, @inp_sName,@inp_sDepartment,@inp_sDesignation, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT",
                            new
                            {
                                inp_sAction = HT_SearchParam["Action"],
                                inp_sEmployeeId = HT_SearchParam["EmployeeId"],
                                inp_sName = HT_SearchParam["Name"],
                                inp_sDepartment = HT_SearchParam["Department"],
                                inp_sDesignation = HT_SearchParam["Designation"],
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList<MCQ_REPORT_DTO>();

                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            //string sReturnValue = sLookupPrefix + out_nReturnValue;
                            //e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                        }
                        else
                        {
                            scope.Complete();
                            return res;
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }
        #endregion

        #region InsertUpdateMCQUserStatus
        public MCQDTO InsertUpdateMCQUserStatus(string i_sConnectionString, MCQDTO i_objMCQDTO)
        {
            #region Paramters
            List<MCQDTO> res = null;
            string sErrCode = string.Empty;
            PetaPoco.Database db = null;
            int out_nReturnValue;
            int out_nSQLErrCode;
            string out_sSQLErrMessage;
            #endregion Paramters

            try
            {
                #region Output Param
                var nReturnValue = new SqlParameter("@out_nReturnValue", System.Data.SqlDbType.Int);
                nReturnValue.Direction = System.Data.ParameterDirection.Output;
                nReturnValue.Value = 0;
                var nSQLErrCode = new SqlParameter("@out_nSQLErrCode", System.Data.SqlDbType.Int);
                nSQLErrCode.Direction = System.Data.ParameterDirection.Output;
                nSQLErrCode.Value = 0;
                var sSQLErrMessage = new SqlParameter("@out_sSQLErrMessage", System.Data.SqlDbType.VarChar);
                sSQLErrMessage.Direction = System.Data.ParameterDirection.Output;
                sSQLErrMessage.Size = 500;
                sSQLErrMessage.Value = "";



                #endregion Output Param

                using (db = new PetaPoco.Database(i_sConnectionString, "System.Data.SqlClient") { EnableAutoSelect = false })
                {

                    using (var scope = db.GetTransaction())
                    {


                        res = db.Fetch<MCQDTO>("exec st_MCQ_UsrStatusSave @UserInfoID,@MCQStatus,@MCQPerioEndDate "
                            + ",@out_nReturnValue OUTPUT,@out_nSQLErrCode OUTPUT,@out_sSQLErrMessage OUTPUT",
                            new
                            {
                                UserInfoID=i_objMCQDTO.UserInfoID,
                                MCQStatus=i_objMCQDTO.MCQStatus,
                                MCQPerioEndDate=i_objMCQDTO.MCQPerioEndDate,
                                out_nReturnValue = nReturnValue,
                                out_nSQLErrCode = nSQLErrCode,
                                out_sSQLErrMessage = sSQLErrMessage

                            }).ToList();


                        if (Convert.ToInt32(nReturnValue.Value) != 0)
                        {
                            #region Error Code
                            Exception e = new Exception();
                            out_nReturnValue = Convert.ToInt32(nReturnValue.Value);
                            string sReturnValue = sLookUpPrefix + out_nReturnValue;
                            e.Data[0] = sReturnValue;
                            if (nSQLErrCode.Value != System.DBNull.Value)
                            {
                                out_nSQLErrCode = Convert.ToInt32(nSQLErrCode.Value);
                                e.Data[1] = out_nSQLErrCode;
                            }
                            if (sSQLErrMessage.Value != System.DBNull.Value)
                            {
                                out_sSQLErrMessage = Convert.ToString(sSQLErrMessage.Value);
                                e.Data[2] = out_sSQLErrMessage;
                            }
                            Exception ex = new Exception(db.LastSQL.ToString(), e);
                            throw ex;
                            #endregion  Error Code
                        }

                        else
                        {
                            scope.Complete();
                            return res.FirstOrDefault();
                        }

                    }

                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

        }

        #endregion

        #region IDisposable Members
        /// <summary>
        /// Dispose Method for dispose object
        /// </summary>
        private void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        /// <summary>
        /// Interface for dispose class
        /// </summary>
        void IDisposable.Dispose()
        {
            Dispose(true);
        }


        /// <summary>
        /// virtual dispoase method
        /// </summary>
        /// <param name="disposing"></param>
        protected virtual void Dispose(bool disposing)
        {
            GC.SuppressFinalize(this);
        }

        #endregion
    }
}
