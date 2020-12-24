using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiderTrading.Common
{
    /// <summary>
    ///  If you are using True Type fonts, you can declare the paths of the different
    //     ttf- and ttc-files to this class first and then create fonts in your code using
    //     one of the getFont method without having to enter a path as parameter.
    /// </summary>
    public class ApplyArebicFont : FontFactoryImp
    {
        private readonly BaseFont baseFont;

        /// <summary>
        /// Create a new font factory that always uses the provided font.
        /// </summary>
        /// <param name="fullPathToFontFileToUse">The full path to the font file to use.</param>
        /// <param name="encoding">The type of encoding to use. Default BaseFont.IDENTITY_H. for details.</param>
        /// <param name="embedded">Whether or not to embed the entire font. Default True.for details.</param>
        public ApplyArebicFont(string fullPathToFontFileToUse, string encoding = BaseFont.IDENTITY_H, bool embedded = BaseFont.EMBEDDED)
        {
            //If you are using this class then this font is required and a missing font should be a fatal error
            if (!System.IO.File.Exists(fullPathToFontFileToUse))
            {
                throw new System.IO.FileNotFoundException("Could not find the supplied font file", fullPathToFontFileToUse);
                Common.WriteLogToFile("Could not find the supplied font file");
            }

            //Create our embedded base font
            baseFont = BaseFont.CreateFont(fullPathToFontFileToUse, encoding, embedded);

        }
        /// <summary>
        /// GetFont
        /// </summary>
        /// <param name="fontname"></param>
        /// <param name="encoding"></param>
        /// <param name="embedded"></param>
        /// <param name="size"></param>
        /// <param name="style"></param>
        /// <param name="color"></param>
        /// <param name="cached"></param>
        /// <returns></returns>
        public override iTextSharp.text.Font GetFont(string fontname, string encoding, bool embedded, float size, int style, BaseColor color, bool cached)
        {
            return new iTextSharp.text.Font(baseFont, size, style, color);
        }
    }
}