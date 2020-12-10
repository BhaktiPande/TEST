using InsiderTradingDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.SL
{
    public class EmailPropertiesSL
    {

        public List<EmailPropertiesDTO> GetEmailPropertiesDetailsForMail(string i_sConnectionString, EmailPropertiesDTO emailPropertiesDTO)
        {
            List<EmailPropertiesDTO> objEmailPropertiesDTO = new List<EmailPropertiesDTO>();
            try
            {
                using (var objEmailPropertiesDAL = new EmailPropertiesDAL())
                {
                    objEmailPropertiesDTO = (List<EmailPropertiesDTO>)objEmailPropertiesDAL.GetEmailPropertiesDetailsForMail(i_sConnectionString, emailPropertiesDTO);
                }
            }
            catch (Exception exp)
            {
                throw exp;
            }
          //  return objEmailPropertiesDTO.Count > 0 ? objEmailPropertiesDTO[1] : null;
            return  objEmailPropertiesDTO ;
        }
    }
}