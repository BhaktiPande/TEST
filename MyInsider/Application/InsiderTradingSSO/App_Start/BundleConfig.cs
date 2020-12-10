using System.Web;
using System.Web.Optimization;

namespace InsiderTradingSSO
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.IgnoreList.Clear();

            System.Web.Optimization.BundleTable.EnableOptimizations = false;

            bundles.Add(new ScriptBundle("~/bundles/jquerynew").Include(
                "~/Scripts/jQuery/jquery-3.5.0.min.js"));
            
            bundles.Add(new ScriptBundle("~/bundles/jqueryold").Include(
                "~/Scripts/jquery-1.10.2.min.js"));             

            bundles.Add(new StyleBundle("~/content/SW360").Include(
                "~/Scripts/bootstrap/css/bootstrap.min.css",                
                "~/Scripts/dist/css/AdminLTE.min.css",
                "~/Scripts/dist/css/skins/_all-skins.min.css",
                "~/Scripts/dist/css/custom.css",
                "~/Scripts/dist/css/insider-icons.css"                
                ));

            bundles.Add(new ScriptBundle("~/bundles/crypto").Include(
                "~/Scripts/crypto/core-min.js",
                "~/Scripts/crypto/aes.js",
                "~/Scripts/crypto/enc-base64-min.js",
                "~/Scripts/crypto/enc-utf16-min.js"
            ));                                 
        }
    }
}
