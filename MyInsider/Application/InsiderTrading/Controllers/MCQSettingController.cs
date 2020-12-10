using InsiderTrading.Common;
using InsiderTrading.Filters;
using InsiderTrading.Models;
using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace InsiderTrading.Controllers
{
    [RolePrivilegeFilter]
    [AuthorizationPrivilegeFilter]
    public class MCQSettingController : Controller
    {
        const string sLookUpPrefix = "usr_msg_";
        string msg = "";
        MCQ_QUESTION_DTO objMCQ_QUESTION_DTO = null;

        LoginUserDetails objLoginUserDetails = null;
        /// <summary>
        /// Get method for MCQSettings
        /// </summary>
        /// <returns></returns>
        public ActionResult MCQSettings()
        {
            PopulateCombo();
            MCQDTO objMCQDTO = null;
            MCQModel objMCQSettingsModel = new MCQModel();
            using (var objMCQSL = new MCQSL())
            {
                objMCQDTO = objMCQSL.GetMCQDetails(objLoginUserDetails.CompanyDBConnectionString, 0, "SELECT", out msg);
            }

            if (objMCQDTO != null)
            {
                ViewBag.MCQAllowCorrectAnswerDropDown = GetDropDownList(objMCQDTO.NoOfQuestionForDisplay);
                ViewBag.MCQ_ID = objMCQDTO.MCQS_ID;
                objMCQSettingsModel.MCQS_ID = objMCQDTO.MCQS_ID;
                objMCQSettingsModel.FirstTimeLogin = objMCQDTO.FirstTimeLogin;
                objMCQSettingsModel.IsSpecificPeriodWise = objMCQDTO.IsSpecificPeriodWise;
                objMCQSettingsModel.FrequencyOfMCQ = objMCQDTO.FrequencyOfMCQ;
                objMCQSettingsModel.IsDatewise = objMCQDTO.IsDatewise;
                objMCQSettingsModel.FrequencyDate = objMCQDTO.FrequencyDate;
                objMCQSettingsModel.FrequencyDuration = objMCQDTO.FrequencyDuration;
                objMCQSettingsModel.BlockUserAfterDuration = objMCQDTO.BlockUserAfterDuration;
                objMCQSettingsModel.NoOfQuestionForDisplay = objMCQDTO.NoOfQuestionForDisplay;
                objMCQSettingsModel.AccessTOApplicationForWriteAnswer = Convert.ToString(objMCQDTO.AccessTOApplicationForWriteAnswer);
                objMCQSettingsModel.NoOfAttempts = objMCQDTO.NoOfAttempts;
                objMCQSettingsModel.BlockuserAfterExceedAtempts = objMCQDTO.BlockuserAfterExceedAtempts;
                objMCQSettingsModel.UnblockForNextFrequency = objMCQDTO.UnblockForNextFrequency;

            }
            else
            {
                ViewBag.MCQ_ID = 0;
            }
            return View(objMCQSettingsModel);
        }
        /// <summary>
        /// bind all dropdwon list
        /// </summary>
        private void PopulateCombo()
        {
            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "Select";
            List<PopulateComboDTO> lstFrequency = new List<PopulateComboDTO>();
            lstFrequency.Add(objPopulateComboDTO);
            lstFrequency.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListOfCode,
                Convert.ToInt32(ConstEnum.CodeGroup.OccurrenceFrequency).ToString(), null, null, null, null, "usr_msg_").OrderByDescending(x => x.Value).ToList<PopulateComboDTO>());
            ViewBag.FrequencyofMCQDropDown = lstFrequency;


            List<PopulateComboDTO> lstMCQ = new List<PopulateComboDTO>();
            lstMCQ.Add(objPopulateComboDTO);
            lstMCQ.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListofMCQ, Convert.ToInt32(0).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.MCQQuestionDropDown = lstMCQ;


            List<PopulateComboDTO> lstNoOfAtempt = new List<PopulateComboDTO>();
            lstNoOfAtempt.Add(objPopulateComboDTO);
            lstNoOfAtempt.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListofMCQAtempts, Convert.ToInt32(0).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());

            ViewBag.NoOfAttemptsDropDown = lstNoOfAtempt;

            List<PopulateComboDTO> lstMCQAllowCorrectAnswer = new List<PopulateComboDTO>();
            lstMCQAllowCorrectAnswer.Add(objPopulateComboDTO);
            ViewBag.MCQAllowCorrectAnswerDropDown = lstMCQAllowCorrectAnswer;

            List<PopulateComboDTO> lstAnswerType = new List<PopulateComboDTO>();
            lstAnswerType.Add(objPopulateComboDTO);
            lstAnswerType.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListofAnswerType, Convert.ToInt32(0).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            ViewBag.Answer_TypeDropDown = lstAnswerType;

            List<PopulateComboDTO> lstNoOfOptionsDropDown = new List<PopulateComboDTO>();
            lstNoOfOptionsDropDown.Add(objPopulateComboDTO);
            lstNoOfOptionsDropDown.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListofMCQAtempts, Convert.ToInt32(0).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());

            ViewBag.NoOfOptionsDropDown = lstNoOfOptionsDropDown;

            lstFrequency = null;
            lstMCQ = null;
            lstNoOfAtempt = null;
            lstAnswerType = null;
            lstNoOfAtempt = null;

        }

        /// <summary>
        /// AllowCorrectAnswer
        /// </summary>
        /// <param name="NoOfQuestionForDisplay"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult AllowCorrectAnswer(int NoOfQuestionForDisplay)
        {
            return Json(GetDropDownList(NoOfQuestionForDisplay), JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// GetDropDownList for no of ans correct
        /// </summary>
        /// <param name="NoOfQuestionForDisplay"></param>
        /// <returns></returns>
        private List<PopulateComboDTO> GetDropDownList(int NoOfQuestionForDisplay)
        {
            LoginUserDetails objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            PopulateComboDTO objPopulateComboDTO = new PopulateComboDTO();
            objPopulateComboDTO.Key = "";
            objPopulateComboDTO.Value = "Select";
            List<PopulateComboDTO> lstMCQ = new List<PopulateComboDTO>();
            lstMCQ.Add(objPopulateComboDTO);
            lstMCQ.AddRange(Common.Common.GetPopulateCombo(objLoginUserDetails.CompanyDBConnectionString, ConstEnum.ComboType.ListofMCQ, Convert.ToInt32(NoOfQuestionForDisplay).ToString(), null, null, null, null, "usr_msg_").ToList<PopulateComboDTO>());
            return lstMCQ;
        }
        /// <summary>
        /// post of MCQSettings
        /// </summary>
        /// <param name="objMCQSettingsModel"></param>
        /// <returns></returns>
        [HttpPost]
        [TokenVerification]
        [AuthorizationPrivilegeFilter]
        public ActionResult MCQSettings(MCQModel objMCQSettingsModel)
        {
            try
            {
                bool isError = false;
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();

                if (objMCQSettingsModel.AccessTOApplicationForWriteAnswer == "undefined")
                {
                    isError = true;
                    ModelState.AddModelError("Error", Common.Common.getResource("usr_lbl_54081") +" field is required");
                }
                else
                {
                    objMCQSettingsModel.AccessTOApplicationForWriteAnswer = Request["hdnAccessTOApplicationForWriteAnswer"];
                }
                objMCQSettingsModel.MCQS_ID = Convert.ToInt32(Request["MCQS_ID"]);
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                MCQDTO objMCQDTO = null;
                using (var objMCQSL = new MCQSL())
                {
                    objMCQDTO = objMCQSL.GetMCQDetails(objLoginUserDetails.CompanyDBConnectionString, objMCQSettingsModel.MCQS_ID, "SELECT", out msg);
                }

                if (objMCQDTO != null)
                {
                    InsiderTrading.Common.Common.CopyObjectPropertyByNameAndActivity(objMCQSettingsModel, objMCQDTO);
                    objMCQSettingsModel.Flag = "UPDATE";
                }
                else
                {
                    objMCQDTO = new MCQDTO();
                    objMCQSettingsModel.Flag = "INSERT";
                }
                if (!objMCQSettingsModel.FirstTimeLogin && (objMCQSettingsModel.FrequencyDate == null && objMCQSettingsModel.FrequencyOfMCQ == null && !(objMCQSettingsModel.IsSpecificPeriodWise) && !(objMCQSettingsModel.IsDatewise)))
                {
                    isError = true;
                    ModelState.AddModelError("Error", Common.Common.getResource("usr_msg_54158"));

                }


                if (objMCQSettingsModel.FrequencyDate != null && !objMCQSettingsModel.IsDatewise)
                {
                    isError = true;
                    ModelState.AddModelError("Error", Common.Common.getResource("usr_msg_54142"));

                }
                if (objMCQSettingsModel.FrequencyDate == null && objMCQSettingsModel.IsDatewise)
                {
                    isError = true;
                    ModelState.AddModelError("Error", Common.Common.getResource("usr_msg_54146"));

                }

                if (objMCQSettingsModel.FrequencyOfMCQ != null && !objMCQSettingsModel.IsSpecificPeriodWise)
                {
                    isError = true;
                    ModelState.AddModelError("Error", Common.Common.getResource("usr_msg_54143"));

                }
                if (objMCQSettingsModel.FrequencyOfMCQ == null && objMCQSettingsModel.IsSpecificPeriodWise)
                {
                    isError = true;
                    ModelState.AddModelError("Error", Common.Common.getResource("usr_msg_54145"));

                }

                if (isError)
                {
                    PopulateCombo();
                    ViewBag.MCQAllowCorrectAnswerDropDown = GetDropDownList(objMCQSettingsModel.NoOfQuestionForDisplay);
                    ViewBag.MCQ_ID = 0;
                    return View(objMCQSettingsModel);
                }
                objMCQDTO.FirstTimeLogin = objMCQSettingsModel.FirstTimeLogin;
                objMCQDTO.IsSpecificPeriodWise = (objMCQSettingsModel.IsSpecificPeriodWise) ? objMCQSettingsModel.IsSpecificPeriodWise : false;
                objMCQDTO.FrequencyOfMCQ = (objMCQSettingsModel.IsSpecificPeriodWise) ? objMCQSettingsModel.FrequencyOfMCQ : 0;
                objMCQDTO.IsDatewise = (objMCQSettingsModel.IsDatewise) ? objMCQSettingsModel.IsDatewise : false;
                objMCQDTO.FrequencyDate = (objMCQSettingsModel.IsDatewise) ? objMCQSettingsModel.FrequencyDate : null;
                objMCQDTO.FrequencyDuration = objMCQSettingsModel.FrequencyDuration;
                objMCQDTO.BlockUserAfterDuration = objMCQSettingsModel.BlockUserAfterDuration;
                objMCQDTO.NoOfQuestionForDisplay = objMCQSettingsModel.NoOfQuestionForDisplay;
                objMCQDTO.AccessTOApplicationForWriteAnswer = Convert.ToInt32(objMCQSettingsModel.AccessTOApplicationForWriteAnswer);
                objMCQDTO.NoOfAttempts = Convert.ToInt32(objMCQSettingsModel.NoOfAttempts);
                objMCQDTO.BlockuserAfterExceedAtempts = objMCQSettingsModel.BlockuserAfterExceedAtempts;
                objMCQDTO.UnblockForNextFrequency = objMCQSettingsModel.UnblockForNextFrequency;
                objMCQDTO.CreatedBy = objLoginUserDetails.LoggedInUserID;
                objMCQDTO.UpdatedBy = objLoginUserDetails.LoggedInUserID;

                using (var objMCQSL = new MCQSL())
                {
                    objMCQDTO = objMCQSL.InsertUpdateMCQDetails(objLoginUserDetails.CompanyDBConnectionString, objMCQDTO, objMCQSettingsModel.Flag);
                }



                PopulateCombo();
                ViewBag.MCQAllowCorrectAnswerDropDown = GetDropDownList(objMCQSettingsModel.NoOfQuestionForDisplay);
                ViewBag.MCQ_ID = objMCQSettingsModel.MCQS_ID;
            }
            catch (Exception ex)
            {

            }
            return RedirectToAction("MCQSettings").Success(HttpUtility.UrlEncode(InsiderTrading.Common.Common.getResource("usr_msg_54094")));


        }

        /// <summary>
        ///Get method MCQQuestions
        /// </summary>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public ActionResult MCQQuestions(int acid = 0, int QuestionID = 0)
        {
            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            MCQModel objMCQSettingsModel = new MCQModel();
            PopulateCombo();
            ViewBag.EditQuestion = 0;
            if (QuestionID != 0)
            {
                objMCQSettingsModel.QuestionID = QuestionID;
                ViewBag.EditQuestion = 1;
                using (var objMCQSL = new MCQSL())
                {
                    objMCQ_QUESTION_DTO = objMCQSL.GetMCQQuestionDetails(objLoginUserDetails.CompanyDBConnectionString, QuestionID, "SELECT", out msg, objLoginUserDetails.LoggedInUserID);
                }

                objMCQSettingsModel.Question = objMCQ_QUESTION_DTO.Question;
                objMCQSettingsModel.Answer_Type = (objMCQ_QUESTION_DTO.AnswerTypes == 1) ? "Radio" : "CheckBox";
                objMCQSettingsModel.Option_number = objMCQ_QUESTION_DTO.OptionNumbers;
                objMCQSettingsModel.QuestionsAnswer = objMCQ_QUESTION_DTO.QuestionAnswer;
                objMCQSettingsModel.objQuestionsAnswerList = new List<string>();
                objMCQSettingsModel.objCorrectAnswerList = new List<string>();
                objMCQSettingsModel.objQuestionBankDetailsIDList = new List<int>();
                for (int i = 0; i < objMCQ_QUESTION_DTO.OptionNumbers; i++)
                {

                    objMCQSettingsModel.objQuestionsAnswerList.Add(objMCQ_QUESTION_DTO.QuestionAnswer.Split('~')[i].Split('.')[1]);
                    objMCQSettingsModel.objQuestionBankDetailsIDList.Add(Convert.ToInt32(objMCQ_QUESTION_DTO.QuestionAnswerWithID.Split('~')[i]));
                    string[] correctAns = objMCQ_QUESTION_DTO.CorrectAnswer.Split('~');
                    foreach (string Ans in correctAns)
                    {
                        if (Ans == objMCQ_QUESTION_DTO.QuestionAnswer.Split('~')[i].Split('.')[1])
                        {
                            objMCQSettingsModel.objCorrectAnswerList.Add(Ans);
                        }
                    }


                }
            }





            return View(objMCQSettingsModel);
        }

        /// <summary>
        /// Post method MCQQuestions
        /// </summary>
        /// <param name="objMCQQuestionModel"></param>
        /// <param name="objMCQModel"></param>
        /// <param name="acid"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        [TokenVerification]
        [HttpPost]
        public ActionResult MCQQuestions(List<MCQQuestionModel> objMCQQuestionModel, MCQModel objMCQModel, int acid = 0, List<int> objOptionIDLIst = null, int formId=0)
        {
            bool statusFlag = true;
            bool EmptyRows = false;
            bool IsAlphaNumeric = false;
            bool IsSpcialCharacter = false;
            var ErrorDictionary = new Dictionary<string, string>();
            System.Text.RegularExpressions.Regex aLphaNumeric = new System.Text.RegularExpressions.Regex(@"^[a-zA-Z0-9_ ]*$");

            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);

            int counter = 0;
            try
            {
                if (objMCQQuestionModel != null)
                {
                    foreach (var questionAnswer in objMCQQuestionModel.Skip(1))
                    {
                        if (counter != 0)
                        {
                            if (questionAnswer.QuestionsAnswer == null)
                            {


                                statusFlag = false;
                                if (ErrorDictionary.ContainsKey("Error"))
                                {
                                    break;
                                }
                                else
                                {
                                    ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54150"));
                                    EmptyRows = true;
                                }

                            }
                        }

                        if (questionAnswer.QuestionsAnswer != null)
                        {

                            if (!aLphaNumeric.IsMatch(questionAnswer.QuestionsAnswer))
                            {
                                if (!IsAlphaNumeric)
                                {
                                  
                                    if (ErrorDictionary.ContainsKey("Error"))
                                    {
                                        ErrorDictionary["Error"] += "<li>" + Common.Common.getResource("usr_msg_54151") + "</li>";
                                    }
                                    else
                                    {
                                        ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54151"));
                                        EmptyRows = true;
                                    }
                                    IsAlphaNumeric = true;
                                }
                            }
                        }
                        
                        counter = counter + 1;

                    }

                    DataTable dt = ConvertListTODataTable(objMCQQuestionModel.GroupBy(i => i.QuestionsAnswer).Select(g => g.First()).ToList(), objOptionIDLIst);
                    DataRow[] rows;

                    rows = dt.Select("CorrectAnswer = 'True'");

                    if (dt.Rows.Count != objMCQModel.Option_number)
                    {
                        statusFlag = false;
                        if (!EmptyRows)
                        {
                            var anyDuplicate = objMCQQuestionModel.Where(x => x.QuestionsAnswer != null).GroupBy(x => x.QuestionsAnswer).Any(g => g.Count() > 1);
                            if (anyDuplicate)
                            {

                                if (ErrorDictionary.ContainsKey("Error"))
                                {
                                    ErrorDictionary["Error"] += "<li>" + Common.Common.getResource("usr_msg_54147") + "</li>";
                                }
                                else
                                {
                                    ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54147"));
                                }
                            }
                        }
                    }
                    if (rows.Length == 0 && dt !=null && dt.Rows.Count>0)
                    {
                        statusFlag = false;
                        if (ErrorDictionary.ContainsKey("Error"))
                        {
                            ErrorDictionary["Error"] += "<li>" + Common.Common.getResource("usr_msg_54148") + "</li>";
                        }
                        else
                        {
                            ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54148"));
                        }


                    }

                    if (string.IsNullOrEmpty(objMCQModel.Question))
                    {

                        statusFlag = false;
                        if (ErrorDictionary.ContainsKey("Error"))
                        {
                            ErrorDictionary["Error"] += "<li>" + Common.Common.getResource("usr_msg_54152") + "</li>";
                        }
                        else
                        {
                            ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54152"));
                        }
                    }
                    if (objMCQModel.Answer_Type == null)
                    {
                        if (ErrorDictionary.ContainsKey("Error"))
                        {
                            ErrorDictionary["Error"] += "<li>" + Common.Common.getResource("usr_msg_54155") + "</li>";
                        }
                        else
                        {
                            ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54155"));
                        }
                    }
                    if (objMCQModel.Option_number == 0)
                    {
                        if (ErrorDictionary.ContainsKey("Error"))
                        {
                            ErrorDictionary["Error"] += "<li>" + Common.Common.getResource("usr_msg_54156") + "</li>";
                        }
                        else
                        {
                            ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54156"));
                        }
                    }
                        if (statusFlag)
                        {
                            if (objMCQModel.QuestionID != 0)
                            {
                                using (var objMCQSL = new MCQSL())
                                {
                                    objMCQ_QUESTION_DTO = objMCQSL.GetMCQQuestionDetails(objLoginUserDetails.CompanyDBConnectionString, objMCQModel.QuestionID, "SELECT", out msg, objLoginUserDetails.LoggedInUserID);
                                }
                            }
                            if (objMCQ_QUESTION_DTO != null)
                            {
                                InsiderTrading.Common.Common.CopyObjectPropertyByNameAndActivity(objMCQModel, objMCQ_QUESTION_DTO);
                                objMCQModel.Flag = "UPDATE";
                            }
                            else
                            {
                                objMCQ_QUESTION_DTO = new MCQ_QUESTION_DTO();
                                objMCQModel.Flag = "INSERT";
                            }
                            objMCQ_QUESTION_DTO.Question = objMCQModel.Question;
                            objMCQ_QUESTION_DTO.AnswerTypes = (objMCQModel.Answer_Type == "Radio") ? 1 : 2;
                            objMCQ_QUESTION_DTO.OptionNumbers = objMCQModel.Option_number;
                            objMCQ_QUESTION_DTO.UserinfoID = objLoginUserDetails.LoggedInUserID;
                            using (var objMCQSL = new MCQSL())
                            {
                                objMCQ_QUESTION_DTO = objMCQSL.InsertUpdateMCQQuestionDetails(objLoginUserDetails.CompanyDBConnectionString, objMCQ_QUESTION_DTO, dt, objMCQModel.Flag);
                            }
                            statusFlag = true;
                            ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_54106"));
                            // PopulateCombo();
                        }
                    
                }
                else
                {
                    statusFlag = false;
                    if (objMCQModel.Answer_Type == null)
                    {
                        if (ErrorDictionary.ContainsKey("Error"))
                        {
                            ErrorDictionary["Error"] += "<li>" + Common.Common.getResource("usr_msg_54155") + "</li>";
                        }
                        else
                        {
                            ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54155"));
                        }
                    }
                    if (objMCQModel.Option_number == 0)
                    {
                        if (ErrorDictionary.ContainsKey("Error"))
                        {
                            ErrorDictionary["Error"] += "<li>" + Common.Common.getResource("usr_msg_54156") + "</li>";
                        }
                        else
                        {
                            ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54156"));
                        }
                    }
                    if (objMCQModel.Question == null)
                    {
                        if (ErrorDictionary.ContainsKey("Error"))
                        {
                            ErrorDictionary["Error"] += "<li>" + Common.Common.getResource("usr_msg_54152") + "</li>";
                        }
                        else
                        {
                            ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54152"));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                statusFlag = false;
                ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54137"));
            }

            return Json(new
            {

                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Delete MCQ Questjion :DeleteMCQ
        /// </summary>
        /// <param name="QuestionID"></param>
        /// <returns></returns>
        [AuthorizationPrivilegeFilter]
        public JsonResult DeleteMCQ(int QuestionID)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            LoginUserDetails objLoginUserDetails = null;
            MCQ_QUESTION_DTO objMCQ_QUESTION_DTO = new MCQ_QUESTION_DTO();

            objMCQ_QUESTION_DTO.QuestionID = QuestionID;
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                using (var objMCQSL = new MCQSL())
                {
                    objMCQ_QUESTION_DTO = objMCQSL.InsertUpdateMCQQuestionDetails(objLoginUserDetails.CompanyDBConnectionString, objMCQ_QUESTION_DTO, null, "DELETE");
                }
                statusFlag = true;
                ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_54105")); // Details Deleted Sucessfully
            }
            catch (Exception exp)
            {
                statusFlag = false;
                ModelState.Remove("KEY");
                ModelState.Add("KEY", new ModelState());
                ModelState.Clear();
                string sErrMessage = Common.Common.getResource(exp.InnerException.Data[0].ToString());
                ModelState.AddModelError("error", sErrMessage);
                ErrorDictionary = GetModelStateErrorsAsString();
            }
            finally
            {
                objLoginUserDetails = null;
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary
            }, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// GetModelStateErrorsAsString
        /// </summary>
        /// <returns></returns>
        private Dictionary<string, string> GetModelStateErrorsAsString()
        {
            return ModelState.Where(x => x.Value.Errors.Any())
                .ToDictionary(x => x.Key, x => x.Value.Errors.First().ErrorMessage);
        }

        /// <summary>
        /// ConvertListTODataTable
        /// </summary>
        /// <param name="objMCQQuestionModelList"></param>
        /// <returns></returns>
        private DataTable ConvertListTODataTable(List<MCQQuestionModel> objMCQQuestionModelList, List<int> objOptionIDLIst)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("QuestionBankDetailsID", typeof(int)));
            dt.Columns.Add(new DataColumn("OptionNo", typeof(int)));
            dt.Columns.Add(new DataColumn("QuestionsAnswer", typeof(string)));
            dt.Columns.Add(new DataColumn("CorrectAnswer", typeof(bool)));
            int rowCount = 1;


            foreach (var objMCQQuestionModel in objMCQQuestionModelList)
            {
                if (objMCQQuestionModel.QuestionsAnswer != null)
                {
                    DataRow dr = dt.NewRow();
                    dt.Rows.Add(dr);
                    dt.Rows[rowCount - 1]["QuestionBankDetailsID"] = (objOptionIDLIst != null) ? (objOptionIDLIst.Count != 0) ? objOptionIDLIst[rowCount - 1] : 0 : objMCQQuestionModel.QuestionID;
                    dt.Rows[rowCount - 1]["OptionNo"] = rowCount;
                    dt.Rows[rowCount - 1]["QuestionsAnswer"] = objMCQQuestionModel.QuestionsAnswer;
                    dt.Rows[rowCount - 1]["CorrectAnswer"] = objMCQQuestionModel.CorrectAnswer;
                    rowCount = rowCount + 1;
                }

            }
            return dt;

        }

        [AuthorizationPrivilegeFilter]
        [HttpGet]
        //public ActionResult ShowTest(int acid)
        public ActionResult MCQ_User(int acid)            
        {
            objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
            MCQModel objMCQSettingsModel = new MCQModel();
            objMCQSettingsModel.objMCQQuestionModel = new MCQQuestionModel();
            objMCQSettingsModel.objMCQUserValidationModel = new MCQUserValidationModel();
            MCQ_QUESTION_DTO objMCQ_QUESTION_DTO = new MCQ_QUESTION_DTO();
            List<MCQ_QUESTION_DTO> objMCQ_QUESTION_DTOList = new List<MCQ_QUESTION_DTO>();
            bool MCQStatus = false;
            MCQDTO objMCQ_DTO = new MCQDTO();
            objMCQ_DTO.UserInfoID = objLoginUserDetails.LoggedInUserID;            
            objMCQ_DTO.MCQPerioEndDate = null;
            using (var objMCQSL = new MCQSL())
            {
                objMCQ_QUESTION_DTOList = objMCQSL.GetMCQQuestionDetailsList(objLoginUserDetails.CompanyDBConnectionString, null, "SELECT_MCQ_QUESTIONS", out msg).ToList();
            }
            using (var objMCQSL = new MCQSL())
            {
                objMCQ_QUESTION_DTO = objMCQSL.GetMCQQuestionDetails(objLoginUserDetails.CompanyDBConnectionString, 0, "ValidateUserSettings", out msg, objLoginUserDetails.LoggedInUserID);
                objMCQSettingsModel.objMCQUserValidationModel.AttemptNos = objMCQ_QUESTION_DTO.AttemptNo;
                objMCQSettingsModel.objMCQUserValidationModel.FrequencyOfMCQs = objMCQ_QUESTION_DTO.FrequencyOfMCQs;
                objMCQSettingsModel.objMCQUserValidationModel.CorrectAnswer = Convert.ToInt16(objMCQ_QUESTION_DTO.CorrectAnswer);
                objMCQSettingsModel.objMCQUserValidationModel.FalseAnswer = objMCQ_QUESTION_DTO.FalseAnswer;
                objMCQSettingsModel.objMCQUserValidationModel.ResultDuringFrequency = objMCQ_QUESTION_DTO.ResultDuringFrequency.Trim();
                objMCQSettingsModel.objMCQUserValidationModel.TotalAttempts = objMCQ_QUESTION_DTO.TotalAttempts;
                objMCQSettingsModel.objMCQUserValidationModel.UserMessage = objMCQ_QUESTION_DTO.UserMessage;
                objMCQSettingsModel.objMCQUserValidationModel.AttemptMessage = objMCQ_QUESTION_DTO.AttemptMessage;
                objMCQSettingsModel.objMCQUserValidationModel.IsBlocked = objMCQ_QUESTION_DTO.IsBlocked;
                if (objMCQ_QUESTION_DTO.TotalAttempts < objMCQ_QUESTION_DTO.AttemptNo)
                {
                    if (objMCQ_QUESTION_DTO.BlockuserAfterExceedAtempts && objMCQ_QUESTION_DTO.IsBlocked)
                        ViewBag.UserMessage = objMCQ_QUESTION_DTO.BlockedUserMessage;
                    else
                    {
                        MCQStatus = true;
                        objMCQ_DTO.MCQStatus = MCQStatus;
                        objMCQ_DTO = objMCQSL.InsertUpdateMCQUserStatus(objLoginUserDetails.CompanyDBConnectionString, objMCQ_DTO);
                        return RedirectToAction("Index", "InsiderDashboard", new { acid = Common.ConstEnum.UserActions.DASHBOARD_INSIDERUSER });
                    }
                }
                else if (!objMCQ_QUESTION_DTO.BlockUserAfterDuration && !objMCQ_QUESTION_DTO.IsBlocked && !objMCQ_QUESTION_DTO.FirstTimeLogin && objMCQ_QUESTION_DTO.FrequencyOfMCQs == "False")
                {
                    MCQStatus = true;
                    objMCQ_DTO.MCQStatus = MCQStatus;
                    objMCQ_DTO = objMCQSL.InsertUpdateMCQUserStatus(objLoginUserDetails.CompanyDBConnectionString, objMCQ_DTO);
                    return RedirectToAction("Index", "InsiderDashboard", new { acid = Common.ConstEnum.UserActions.DASHBOARD_INSIDERUSER });
                }
                else if (!objMCQ_QUESTION_DTO.BlockuserAfterExceedAtempts && !objMCQ_QUESTION_DTO.IsBlocked && !objMCQ_QUESTION_DTO.FirstTimeLogin && objMCQ_QUESTION_DTO.FrequencyOfMCQs == "False")
                {
                    MCQStatus = true;
                    objMCQ_DTO.MCQStatus = MCQStatus;
                    objMCQ_DTO = objMCQSL.InsertUpdateMCQUserStatus(objLoginUserDetails.CompanyDBConnectionString, objMCQ_DTO);
                    return RedirectToAction("Index", "InsiderDashboard", new { acid = Common.ConstEnum.UserActions.DASHBOARD_INSIDERUSER });
                }
                else if (objMCQ_QUESTION_DTO.BlockUserAfterDuration && objMCQ_QUESTION_DTO.IsBlocked && objMCQ_QUESTION_DTO.FirstTimeLogin && objMCQ_QUESTION_DTO.FrequencyOfMCQs != "False")
                {
                    ViewBag.UserMessage = objMCQ_QUESTION_DTO.BlockedUserMessage;
                }
                else
                {
                    ViewBag.UserMessage = objMCQ_QUESTION_DTO.AttemptMessage + " " + objMCQ_QUESTION_DTO.UserMessage;

                }

                ViewBag.AttemptMessage = objMCQ_QUESTION_DTO.AttemptMessage;
                if (objMCQ_QUESTION_DTO.FrequencyOfMCQs == "False" && objMCQ_QUESTION_DTO.ResultDuringFrequency.Trim() != "522002")
                {
                    ViewBag.UserMessage = objMCQ_QUESTION_DTO.AttemptMessage + " " + objMCQ_QUESTION_DTO.BlockedUserMessage;
                }

                if (objMCQ_QUESTION_DTO.ResultDuringFrequency.Trim() == "522002")
                {
                    MCQStatus = true;
                    objMCQ_DTO.MCQStatus = MCQStatus;
                    objMCQ_DTO = objMCQSL.InsertUpdateMCQUserStatus(objLoginUserDetails.CompanyDBConnectionString, objMCQ_DTO);
                    return RedirectToAction("Index", "InsiderDashboard", new { acid = Common.ConstEnum.UserActions.DASHBOARD_INSIDERUSER });
                }
            }

            ViewBag.AttemptNo = objMCQ_QUESTION_DTO.AttemptNo;
            objMCQSettingsModel.objMCQModelList = new List<MCQModel>();

            for (int i = 0; i < objMCQ_QUESTION_DTOList.Count; i++)
            {
                MCQModel objMCQModel = new MCQModel();
                objMCQModel.Question = objMCQ_QUESTION_DTOList[i].Question;
                objMCQModel.Answer_Type = Convert.ToString(objMCQ_QUESTION_DTOList[i].AnswerTypes);
                objMCQModel.objMCQQuestionModelAnswerList = new List<MCQQuestionModel>();

                string[] QuestionOptions = objMCQ_QUESTION_DTOList[i].QuestionAnswer.Split('~');

                foreach (string Ans in QuestionOptions)
                {
                    MCQQuestionModel objMCQQuestionModel = new MCQQuestionModel();
                    string[] QuestionAnswer = Ans.Split('.');

                    if (QuestionAnswer.Length > 1)
                    {
                        objMCQQuestionModel.QuestionID = objMCQ_QUESTION_DTOList[i].QuestionID;
                        objMCQQuestionModel.QuestionBankDetailsID = Convert.ToInt32(QuestionAnswer[0]);
                        objMCQQuestionModel.QuestionsAnswer = QuestionAnswer[1];

                        objMCQModel.objMCQQuestionModelAnswerList.Add(objMCQQuestionModel);
                    }
                }

                objMCQSettingsModel.objMCQModelList.Add(objMCQModel);
            }

            using (MCQSL objMCQSL = new MCQSL())
            {                
                objMCQ_DTO.MCQStatus = MCQStatus;                
                objMCQ_DTO = objMCQSL.InsertUpdateMCQUserStatus(objLoginUserDetails.CompanyDBConnectionString, objMCQ_DTO);
            }
            
            return View(objMCQSettingsModel);
        }


        [AuthorizationPrivilegeFilter]
        [HttpPost]
        public ActionResult MCQ_User(int acid, List<MCQQuestionModel> objMCQQuestionModel, int AttemptNo = 0)
        {
            bool statusFlag = false;
            var ErrorDictionary = new Dictionary<string, string>();
            try
            {
                objLoginUserDetails = (LoginUserDetails)InsiderTrading.Common.Common.GetSessionValue((string)ConstEnum.SessionValue.UserDetails);
                objMCQ_QUESTION_DTO = new MCQ_QUESTION_DTO();
                DataTable dt = ConvertListTODataTable(objMCQQuestionModel, null);
                if (dt != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        objMCQ_QUESTION_DTO.UserinfoID = objLoginUserDetails.LoggedInUserID;
                        objMCQ_QUESTION_DTO.AttemptNo = AttemptNo;
                        using (var objMCQSL = new MCQSL())
                        {
                            objMCQ_QUESTION_DTO = objMCQSL.InsertUpdateMCQQuestionDetails(objLoginUserDetails.CompanyDBConnectionString, objMCQ_QUESTION_DTO, dt, "SAVE_EXAM_RESULT");
                            statusFlag = true;
                            ErrorDictionary.Add("success", Common.Common.getResource("usr_msg_54121"));
                        }
                        using (var objMCQSL = new MCQSL())
                        {
                            objMCQ_QUESTION_DTO = objMCQSL.GetMCQQuestionDetails(objLoginUserDetails.CompanyDBConnectionString, 0, "ValidateUserSettings", out msg, objLoginUserDetails.LoggedInUserID);
                            ViewBag.UserMessage = objMCQ_QUESTION_DTO.UserMessage;
                            ViewBag.AttemptMessage = objMCQ_QUESTION_DTO.AttemptMessage;

                        }
                    }
                    else
                    {
                        statusFlag = false;
                        ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54138"));
                        return Json(new
                        {
                            status = statusFlag,
                            Message = ErrorDictionary,
                            SuccessMessage = "",
                            AttmptMessage = "",
                            NextAttempt = 0,
                            TotalAttempts = 0,
                            ResultDuringFrequency = ""
                        }, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    statusFlag = false;
                    ErrorDictionary.Add("Error", Common.Common.getResource("usr_msg_54138"));
                    return Json(new
                    {
                        status = statusFlag,
                        Message = ErrorDictionary,
                        SuccessMessage = "",
                        AttmptMessage = "",
                        NextAttempt = 0,
                        TotalAttempts = 0,
                        ResultDuringFrequency = ""
                    }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                statusFlag = false;
                ErrorDictionary.Add("Error", ex.ToString());
                return Json(new
                {
                    status = statusFlag,
                    Message = ErrorDictionary,
                    SuccessMessage = "",
                    AttmptMessage = "",
                    NextAttempt = 0,
                    TotalAttempts = 0,
                    ResultDuringFrequency = ""
                }, JsonRequestBehavior.AllowGet);
            }
            return Json(new
            {
                status = statusFlag,
                Message = ErrorDictionary,
                SuccessMessage = objMCQ_QUESTION_DTO.UserMessage,
                AttmptMessage = objMCQ_QUESTION_DTO.AttemptMessage,
                NextAttempt = objMCQ_QUESTION_DTO.AttemptNo,
                TotalAttempts = objMCQ_QUESTION_DTO.TotalAttempts,
                ResultDuringFrequency = objMCQ_QUESTION_DTO.ResultDuringFrequency.Trim()
            }, JsonRequestBehavior.AllowGet);
        }

    }

}