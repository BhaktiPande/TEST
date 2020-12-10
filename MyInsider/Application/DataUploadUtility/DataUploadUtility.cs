using DataUploadUtility.Generic;
using System;
using System.Linq;

namespace DataUploadUtility
{
    class DataUploadUtility
    {
        static void Main(string[] args)
        {
            if (args.Length > 0)
            {
                foreach (var item in args)
                {
                    switch (item)
                    {
                        case CommonModel.s_AXISDIRECTFEED:
                            CommonModel.HT_Modules.Add(CommonModel.s_AXISDIRECTFEED, CommonModel.s_AXISDIRECTFEED);
                            break;

                        case CommonModel.s_ESOPDIRECTFEED:
                            CommonModel.HT_Modules.Add(CommonModel.s_ESOPDIRECTFEED, CommonModel.s_ESOPDIRECTFEED);
                            break;

                        case CommonModel.s_HRMS:
                            CommonModel.HT_Modules.Add(CommonModel.s_HRMS, CommonModel.s_HRMS);
                            break;

                        case CommonModel.s_KARVY:
                            CommonModel.HT_Modules.Add(CommonModel.s_KARVY, CommonModel.s_KARVY);
                            break;
                    }
                }
            }

            else
            {
                CommonModel.HT_Modules.Add(CommonModel.s_AXISDIRECTFEED, CommonModel.s_AXISDIRECTFEED);
                CommonModel.HT_Modules.Add(CommonModel.s_ESOPDIRECTFEED, CommonModel.s_ESOPDIRECTFEED);
                CommonModel.HT_Modules.Add(CommonModel.s_HRMS, CommonModel.s_HRMS);
                CommonModel.HT_Modules.Add(CommonModel.s_KARVY, CommonModel.s_KARVY);
            }

            if (CommonModel.HT_Modules.Count > 0)
                Facade.Instance().UploadData();
            else
                Console.WriteLine("\nInvalid Arguments Provided");

            Console.WriteLine("\nPlease refer " + (CommonModel.HT_Modules.Count.Equals(4) ? string.Empty : Convert.ToString(CommonModel.HT_Modules.Values.OfType<string>().First()) + "_") + DateTime.Now.ToString("ddMMMyyyy") + "_Log.txt for more details");



        }
    }
}
