using System.Web;
using System.Web.Optimization;

namespace InsiderTrading
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.IgnoreList.Clear();
            System.Web.Optimization.BundleTable.EnableOptimizations = false;
            bundles.Add(new ScriptBundle("~/bundles/jquerynew").Include(
                "~/Scripts/jQuery/jquery-3.5.0.min.js" ,
                "~/Scripts/jQuery/jQuery-Migrate.js",
                "~/Scripts/jquery-1.10.2.min.js"
                ));
            bundles.Add(new ScriptBundle("~/bundles/jqueryold").Include(
               "~/Scripts/jQuery/jquery-3.5.0.min.js",
               "~/Scripts/jQuery/jQuery-Migrate.js",
                "~/Scripts/jquery-1.10.2.min.js"));
            bundles.Add(new ScriptBundle("~/bundles/jqueryold1").Include(
              "~/LoginScript/jQuery/jquery-3.5.0.min.js",
              "~/Scripts/jQuery/jQuery-Migrate.js",
               "~/Scripts/jquery-1.10.2.min.js"));
            bundles.Add(new ScriptBundle("~/bundles/SW360").Include(
                "~/Scripts/jQueryjquery-3.5.0.min.js",
                "~/Scripts/jQuery/jQuery-Migrate.js",
                 "~/Scripts/jquery-1.10.2.min.js",
                 //"~/Scripts/jQueryUI/jquery-ui-1.11.2.min.js",
                "~/Scripts/jQueryUI/jquery-ui-1.12.1.min.js",
                "~/Scripts/bootstrap/js/bootstrap.min.js",
                "~/Scripts/daterangepicker/daterangepicker.js",
                "~/Scripts/datepicker/bootstrap-datepicker.js",
                "~/Scripts/iCheck/icheck.min.js",
                "~/Scripts/slimScroll/jquery.slimscroll.min.js",
                "~/Scripts/fastclick/fastclick.min.js",
                "~/Scripts/dist/js/app.min.js",
                "~/Scripts/dist/js/custom.js",
                "~/Scripts/jasny-bootstrap/js/jasny-bootstrap.min.js",
                "~/Scripts/bootstrap-wizard/jquery.bootstrap.wizard.min.js",
                "~/Scripts/datatables/jquery.dataTables.js",
                "~/Scripts/datatables/dataTables.bootstrap.js",
                "~/Scripts/jQueryCurrencyFormat/jquery.formatCurrency.js"
                //    "~/Scripts/barChart/js/jquery.horizBarChart.min.js"
                ));

            bundles.Add(new StyleBundle("~/content/SW360").Include(
                "~/Scripts/bootstrap/css/bootstrap.min.css",
                "~/Scripts/font-awesome-4.3.0/css/font-awesome.min.css",
                "~/Scripts/ionicons-2.0.1/css/ionicons.min.css",
                "~/Scripts/checkbox-master/checkbox-master.css",
                "~/Scripts/dist/css/AdminLTE.min.css",
                "~/Scripts/dist/css/skins/_all-skins.min.css",
                "~/Scripts/dist/css/custom.css",
                "~/Scripts/dist/css/insider-icons.css",
                "~/Scripts/iCheck/flat/blue.css",
                "~/Scripts/datepicker/datepicker3.css",
                "~/Scripts/daterangepicker/daterangepicker-bs3.css",
                "~/Scripts/jasny-bootstrap/css/jasny-bootstrap.css",
                "~/Scripts/datatables/dataTables.bootstrap.css",
                "~/Scripts/barChart/css/horizBarChart.css"
                //"~/Scripts/fullcalendar/fullcalendar.print.css"
                ));
            bundles.Add(new StyleBundle("~/content/NSEDownload").Include(
                "~/Content/NSEDownload/NSEDownload.css"));

            bundles.Add(new ScriptBundle("~/bundles/fullCalender").Include(
                "~/Scripts/fullcalendar/fullcalendar.min.js"
            ));
            bundles.Add(new StyleBundle("~/content/fullCalender").Include(
                "~/Scripts/fullcalendar/fullcalendar.min.css"
            ));

            bundles.Add(new ScriptBundle("~/bundles/jqueryfileupload").Include(
                "~/Scripts/jQueryFileUpload/tmpl.min.js",
                "~/Scripts/jQueryFileUpload/load-image.all.min.js",
                "~/Scripts/jQueryFileUpload/canvas-to-blob.min.js",
                "~/Scripts/jQueryFileUpload/jquery.blueimp-gallery.min.js",
                "~/Scripts/jQueryFileUpload/jquery.iframe-transport.js",
                "~/Scripts/jQueryFileUpload/jquery.fileupload.js",
                "~/Scripts/jQueryFileUpload/jquery.fileupload-process.js",
                "~/Scripts/jQueryFileUpload/jquery.fileupload-image.js",
                "~/Scripts/jQueryFileUpload/jquery.fileupload-audio.js",
                "~/Scripts/jQueryFileUpload/jquery.fileupload-video.js",
                "~/Scripts/jQueryFileUpload/jquery.fileupload-validate.js",
                "~/Scripts/jQueryFileUpload/jquery.fileupload-jquery-ui.js"
                ));

            bundles.Add(new StyleBundle("~/content/jqueryfileupload").Include(
                "~/Content/jquery/blueimp-gallery.min.css",
                "~/Content/jquery/jquery.fileupload.css",
                "~/Content/jquery/jquery.fileupload-ui.css"
                ));

            bundles.Add(new ScriptBundle("~/bundles/jqueryform").Include(
                        "~/Scripts/jquery.form.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            bundles.Add(new ScriptBundle("~/bundles/jQueryFixes").Include(
                    "~/Scripts/jQueryFixes.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryprint").Include(
                        "~/Scripts/jQueryPrint/jQuery.print.js"));


            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/moment").Include(
                        "~/Scripts/moment.js"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap-datetimepicker.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new ScriptBundle("~/bundles/dataTable").Include(
                //"~/Scripts/jquery.dataTables.min.js",
                     "~/Scripts/DatatableGrid.js",
                     "~/Scripts/GenerateHeader.js",
                     "~/Scripts/fnAddTr.js",
                     "~/Scripts/fnAddDataAndDisplay.js"));

            //bundles.Add(new StyleBundle("~/content/dataTable").Include(
            //"~/Content/jquery.dataTables.min.css"
            //        ));

            bundles.Add(new ScriptBundle("~/bundles/customannotation").Include(
                      "~/Scripts/customannotation.js"));

            bundles.Add(new ScriptBundle("~/bundles/JqueryConfirm").Include(
                      "~/Scripts/jquery.confirm.js"));
            // "~/Scripts/jquery.confirm.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/Messages").Include(
                      "~/Scripts/jQuery.flashMessage.js",
                      "~/Scripts/jquery.cookie.js",
                      "~/Scripts/base64.js"));


            bundles.Add(new StyleBundle("~/content/css").Include(
                      "~/Content/site.css",
                      "~/Content/CaptchaDesign.css"
                     ));

            bundles.Add(new StyleBundle("~/bundles/accounting").Include(
                    "~/Scripts/accounting.js"));

            bundles.Add(new ScriptBundle("~/bundles/userDetails").Include(
          "~/Scripts/userDetails.js"));

            bundles.Add(new ScriptBundle("~/bundles/employee").Include(
                        "~/Scripts/employee.js"));

            bundles.Add(new ScriptBundle("~/bundles/employeeInsider").Include(
                        "~/Scripts/employeeInsider.js"));

            bundles.Add(new ScriptBundle("~/bundles/nonEmployeeInsider").Include(
                        "~/Scripts/nonEmployeeInsider.js"));

            bundles.Add(new ScriptBundle("~/bundles/DMATDetails").Include(
                        "~/Scripts/DMATDetails.js"));

            bundles.Add(new ScriptBundle("~/bundles/RelativeDMATDetails").Include(
                        "~/Scripts/RelativeDMATDetails.js"));

            bundles.Add(new ScriptBundle("~/bundles/Company").Include(
                       "~/Scripts/Company.js"));

            bundles.Add(new ScriptBundle("~/bundles/documentDetails").Include(
                        "~/Scripts/documentDetails.js"));

            bundles.Add(new ScriptBundle("~/bundles/common").Include(
                        "~/Scripts/common.js"));

            bundles.Add(new ScriptBundle("~/bundles/ComCode").Include(
                       "~/Scripts/ComCode.js"));

            bundles.Add(new ScriptBundle("~/bundles/relativeDetails").Include(
                       "~/Scripts/relativeDetails.js"));

            bundles.Add(new ScriptBundle("~/bundles/Resource").Include(
                      "~/Scripts/Resource.js"));

            bundles.Add(new ScriptBundle("~/bundles/PasswordManagement").Include(
                      "~/Scripts/PasswordManagement.js"));

            bundles.Add(new ScriptBundle("~/bundles/CorporateUser").Include(
                    "~/Scripts/CorporateUser.js"));

            bundles.Add(new ScriptBundle("~/bundles/TradingWindowsEventOther").Include(
                "~/Scripts/TradingWindowsEventOther.js"));

            bundles.Add(new ScriptBundle("~/bundles/TradingWindowEventFinancialYear").Include(
                  "~/Scripts/TradingWindowEventFinancialYear.js"));

            bundles.Add(new ScriptBundle("~/bundles/TradingPolicy").Include(
                "~/Scripts/TradingPolicy.js"));

            bundles.Add(new ScriptBundle("~/bundles/PolicyDocuments").Include(
                "~/Scripts/PolicyDocuments.js"));

            bundles.Add(new ScriptBundle("~/bundles/CompareDateAnnotation").Include(
                "~/Scripts/CompareDateAnnotation.js"));

            bundles.Add(new ScriptBundle("~/bundles/PreclearanceRequest").Include(
                "~/Scripts/PreclearanceRequest.js"));

            bundles.Add(new ScriptBundle("~/bundles/NSEDownload").Include(
               "~/Scripts/NSEDownload.js"));

            bundles.Add(new ScriptBundle("~/bundles/PeriodEndDisclosure").Include(
                "~/Scripts/PeriodEndDisclosure.js"));

            bundles.Add(new ScriptBundle("~/bundles/InsiderInitialDisclosure").Include(
                      "~/Scripts/InsiderInitialDisclosure.js"));

            bundles.Add(new ScriptBundle("~/bundles/CoInitialDisclosure").Include(
                        "~/Scripts/CoInitialDisclosure.js"));

            bundles.Add(new ScriptBundle("~/bundles/BootStrapSelect")
                .Include("~/Scripts/bootstrap-select.js"
                        ));
            bundles.Add(new StyleBundle("~/bundles/BootStrapSelectStyles").Include(
                 "~/Content/bootstrap-select.css"
                     ));
            bundles.Add(new ScriptBundle("~/bundles/TemplateMaster").Include(
                      "~/Scripts/TemplateMaster.js"));
            bundles.Add(new ScriptBundle("~/bundles/employeeSeparation").Include(
                "~/Scripts/employeeSeparation.js"));
            bundles.Add(new ScriptBundle("~/bundles/RestrictedList").Include(
                "~/Scripts/RestrictedSearch.js"
                ));
            bundles.Add(new ScriptBundle("~/bundles/OnlyCookie").Include(
                      "~/Scripts/jquery.cookie.js"));
            bundles.Add(new ScriptBundle("~/bundles/crypto").Include(
                "~/Scripts/crypto/core-min.js",
                "~/Scripts/crypto/aes.js",
                "~/Scripts/crypto/enc-base64-min.js",
                "~/Scripts/crypto/enc-utf16-min.js"
            ));

            bundles.Add(new ScriptBundle("~/bundles/Login").Include(
              "~/Scripts/Login/Login.js"     
           ));

            bundles.Add(new ScriptBundle("~/bundles/PreclearanceRequestNonImplCompany").Include(
                "~/Scripts/PreclearanceRequestNonImplCompany.js",
                "~/Scripts/DMATDetails.js"
            ));
            bundles.Add(new ScriptBundle("~/bundles/RestrictedListSetting").Include(
                "~/Scripts/RestrictedListSetting.js"
            ));

            bundles.Add(new ScriptBundle("~/bundles/SecurityTransfer").Include(
                "~/Scripts/SecurityTransfer.js"));

            bundles.Add(new ScriptBundle("~/bundles/TemplateMasterCKEditor").Include(
                      "~/Scripts/ckeditor/ckeditor.js"
            ));

            bundles.Add(new ScriptBundle("~/bundles/SearchResult").Include(
                "~/Scripts/SearchFilterHistory.js"
            ));

            bundles.Add(new ScriptBundle("~/bundles/BrowserClose").Include(
                "~/Scripts/BrowserClose/Decrypted/BrowserClose.js"
            ));
        }

    }
}
