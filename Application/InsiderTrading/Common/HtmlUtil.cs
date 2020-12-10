using System.Collections.Generic;
using System.Linq;
using HtmlAgilityPack;
using System.Web;

namespace InsiderTrading.Common
{
    public static class HtmlUtil
    {
        //http://htmlagilitypack.codeplex.com/discussions/24346
        public static string SanitizeHtml(string html)
        {

            var doc = new HtmlDocument();
            doc.LoadHtml(html);


            string[] elementWhitelist = {
                                            "u", "b", "i", "br", "br ", "br", "h1", "h2", "h3", "h4", "h5", "h6", 
                                            "span", "strong", "strike", "table","tbody","tr", "td", "hr",
                                            "div", "blockquote", "em", "sub", "sup", "s", "font", "ul", "li", "ol", "p", "#text"
                                        };

            string[] attributeWhiteList = { "class", "style", "src", "color", "size", "border", "cellpadding", "cellspacing" };

            //IList<HtmlNode> hnc = doc.DocumentNode.DescendantNodes().ToList();

            IList<HtmlNode> hnc = doc.DocumentNode.Descendants().ToList();

            //remove non-white list nodes
            for (var i = hnc.Count - 1; i >= 0; i--)
            {
                var htmlNode = hnc[i];
                if (!elementWhitelist.Contains(htmlNode.Name.ToLower()))
                {
                    htmlNode.Remove();
                    continue;
                }

                for (var att = htmlNode.Attributes.Count - 1; att >= 0; att--)
                {
                    var attribute = htmlNode.Attributes[att];
                    //remove any attribute that is not in the white list (such as event handlers)
                    if (!attributeWhiteList.Contains(attribute.Name.ToLower()))
                    {
                        attribute.Remove();
                    }

                    //strip any "style" attributes that contain the word "expression"
                    if (attribute.Value.ToLower().Contains("expression") && attribute.Name.ToLower() == "style")
                    {
                        attribute.Value = string.Empty;
                    }


                    if (attribute.Name.ToLower() == "src" || attribute.Name.ToLower() == "href")
                    {
                        //strip if the link starts with anything other than http (such as jscript, javascript, vbscript, mailto, ftp, etc...)
                        if (!attribute.Value.StartsWith("http")) attribute.Value = "#";
                    }
                }
            }
            return doc.DocumentNode.WriteTo();
        }

        public static string GetLanIPAddress()
        {
            //The X-Forwarded-For (XFF) HTTP header field is a de facto standard for identifying the originating IP address of a 
            //client connecting to a web server through an HTTP proxy or load balancer
            string ip = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (string.IsNullOrEmpty(ip))
            {
                ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            }

            return ip;
        }
    }
}