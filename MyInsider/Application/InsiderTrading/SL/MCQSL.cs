using InsiderTradingDAL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace InsiderTrading
{
    public class MCQSL : IDisposable
    {
        public IEnumerable<MCQDTO> GetMCQDetailsList(string i_sConnectionString, MCQDTO i_objMCQDTO, out int o_nReturnValue, out int o_nErroCode, out string o_sErrorMessage)
        {
            IEnumerable<MCQDTO> MCQDTOList = null;
            o_nReturnValue = 0;
            o_nErroCode = 0;
            o_sErrorMessage = "";
            try
            {

                using (var objMCQDAL = new InsiderTradingDAL.MCQDAL())
                {
                    MCQDTOList = objMCQDAL.GetMCQDetailsList(i_sConnectionString, i_objMCQDTO);
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }

            return MCQDTOList;
        }

        public MCQDTO GetMCQDetails(string i_sConnectionString, int MCQS_ID,string Falg,out string o_sErrorMessage)
        {
            MCQDTO MCQDTO = null;

            o_sErrorMessage = "";
            try
            {

                using (var objMCQDAL = new InsiderTradingDAL.MCQDAL())
                {
                    MCQDTO = objMCQDAL.GetMCQDetails(i_sConnectionString, MCQS_ID, Falg);
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }

            return MCQDTO;
        }

        public MCQDTO InsertUpdateMCQDetails(string i_sConnectionString, MCQDTO i_objMCQDTO,string Flag)
        {
            MCQDTO objMCQDTO = null;
            try
            {
                using (var objMCQDAL = new InsiderTradingDAL.MCQDAL())
                {
                    objMCQDTO = objMCQDAL.InsertUpdateMCQDetails(i_sConnectionString, i_objMCQDTO, Flag);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objMCQDTO;
        }


        public MCQ_QUESTION_DTO GetMCQQuestionDetails(string i_sConnectionString, int QuestionID, string Falg, out string o_sErrorMessage,int userinfoid=0)
        {
            MCQ_QUESTION_DTO objMCQ_QUESTION_DTO = null;

            o_sErrorMessage = "";
            try
            {

                using (var objMCQDAL = new InsiderTradingDAL.MCQDAL())
                {
                    objMCQ_QUESTION_DTO = objMCQDAL.GetMCQQuestionDetails(i_sConnectionString, QuestionID, Falg,userinfoid);
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objMCQ_QUESTION_DTO;
        }
        public IEnumerable<MCQ_QUESTION_DTO> GetMCQQuestionDetailsList(string i_sConnectionString, MCQ_QUESTION_DTO i_objMCQ_QUESTION_DTO, string Falg, out string o_sErrorMessage)
        {
            IEnumerable<MCQ_QUESTION_DTO> objMCQ_QUESTION_DTO = null;

            o_sErrorMessage = "";
            try
            {

                using (var objMCQDAL = new InsiderTradingDAL.MCQDAL())
                {
                    objMCQ_QUESTION_DTO = objMCQDAL.GetMCQQuestionDetailsList(i_sConnectionString, i_objMCQ_QUESTION_DTO, Falg);
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objMCQ_QUESTION_DTO;
        }
        public MCQ_QUESTION_DTO InsertUpdateMCQQuestionDetails(string i_sConnectionString, MCQ_QUESTION_DTO i_objMCQ_QUESTION_DTO, DataTable dt_MCQQuestionList, string Falg)
        {
            MCQ_QUESTION_DTO objMCQ_QUESTION_DTO = null;
            try
            {
                using (var objMCQDAL = new InsiderTradingDAL.MCQDAL())
                {
                    objMCQ_QUESTION_DTO = objMCQDAL.InsertUpdateMCQQuestionDetails(i_sConnectionString, i_objMCQ_QUESTION_DTO, dt_MCQQuestionList, Falg);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objMCQ_QUESTION_DTO;
        }

        public IEnumerable<MCQ_REPORT_DTO> GetMCQReportList(string i_sConnectionString, MCQ_REPORT_DTO i_objMCQ_REPORT_DTO )
        {
            IEnumerable<MCQ_REPORT_DTO> objMCQ_REPORT_DTO = null;

            
            try
            {

                using (var objMCQDAL = new InsiderTradingDAL.MCQDAL())
                {
                    objMCQ_REPORT_DTO = objMCQDAL.GetMCQReportList(i_sConnectionString, i_objMCQ_REPORT_DTO);
                }

            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objMCQ_REPORT_DTO;
        }

        public List<MCQ_REPORT_DTO> AutoCompleteListSL(string i_sConnectionString, Hashtable ht_SearchParam)
        {
            List<MCQ_REPORT_DTO> lstMCQ_REPORT_DTO  = new List<MCQ_REPORT_DTO>();
            try
            {
                using (var objMCQDAL = new MCQDAL())
                {
                    lstMCQ_REPORT_DTO = objMCQDAL.AutoCompleteList(i_sConnectionString, ht_SearchParam);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return lstMCQ_REPORT_DTO;
        }

        public MCQDTO InsertUpdateMCQUserStatus(string i_sConnectionString, MCQDTO i_objMCQDTO)
        {
            MCQDTO objMCQDTO = null;
            try
            {
                using (var objMCQDAL = new InsiderTradingDAL.MCQDAL())
                {
                    objMCQDTO = objMCQDAL.InsertUpdateMCQUserStatus(i_sConnectionString, i_objMCQDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }

            return objMCQDTO;
        }

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