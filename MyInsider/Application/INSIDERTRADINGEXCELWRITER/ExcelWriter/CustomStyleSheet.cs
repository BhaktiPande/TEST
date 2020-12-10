using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml;

namespace InsiderTradingExcelWriter.ExcelFacade
{
    /* While adding new objects to the collections, ALWAYS append newly created object i.e. always add newly created object at the end of collection. 
    * Do NOT add any new object at any index of the collection. Otherwise, all indices will mismatch and appropriate styles would not be applied.*/
    public class CustomStyleSheet : Stylesheet
    {
        /// <summary>
        /// Class CustomStyleSheet is created to define all styles, formats, patterns reqiored to create cells in Excel using OpenXML.
        /// This class contains collections for fonts, formats, borders, numbering formats etc.
        /// </summary>
        /// <ChangeSummary>
        /// Swapna  31-Mar-2014
        /// Border collection as
        ///     5. Left, bottom top
        ///     6. Right, bottom, Top
        ///     7. Left
        ///     8. Right
        ///     9. Left, bottom
        ///     10. Right, bottom
        ///     11. Bottom
        ///     12. Left, right
        ///     13. Left, right, bottom
        ///     
        /// Styles for amounts using above listed border collection
        /// --------------------------------------------------------------------------------------------------------------
        /// </ChangeSummary>
        public CustomStyleSheet()
        {
            #region Object declarations
            Color objColor;
            Underline objUnderline;
            Fonts objCollectionFonts;
            Font objFont;
            FontName objFontName;
            FontSize objFontSize;
            Bold objFontBold;
            Fills objCollectionFills;
            Fill objFill;
            PatternFill objPatternFill;
            Borders objCollectionBorders;
            Border objBorder;
            CellStyleFormats objCollectionCellStyleFormats;
            CellFormat objCellFormat;
            NumberingFormats objCollectionNumberingFormats;
            CellFormats objCollectionCellFormats;
            Alignment objCellAlignment;
            #endregion

            #region Variables
            uint iExcelIndex = 164;
            #endregion

            #region Fonts collection
            objCollectionFonts = new Fonts();

            // 0 
            #region Arial Narrow 10
            objFont = new Font();
            objFontName = new FontName();// create font name object
            objFontName.Val = StringValue.FromString("Arial Narrow"); //assign font name
            objFontSize = new FontSize(); // create font size object 
            objFontSize.Val = DoubleValue.FromDouble(10); // assign font size
            objFont.FontName = objFontName;//assign font name to font object
            objFont.FontSize = objFontSize; // assign font size to font object 
            objCollectionFonts.Append(objFont); // add font object to the collection of fonts            
            #endregion

            //1
            #region Arial - Normal - 9 size
            objFont = new Font();
            objFontName = new FontName();
            objFontName.Val = StringValue.FromString("Arial");
            objFontSize = new FontSize();
            objFontSize.Val = DoubleValue.FromDouble(9);
            objFont.FontName = objFontName;
            objFont.FontSize = objFontSize;
            objCollectionFonts.Append(objFont);
            #endregion Arial - Normal - 9 size

            //2 
            #region Arial - Bold - 9 size
            objFont = new Font();
            objFontName = new FontName();
            objFontName.Val = StringValue.FromString("Arial");
            objFontSize = new FontSize();
            objFontSize.Val = DoubleValue.FromDouble(9);
            objFont.FontName = objFontName;
            objFont.FontSize = objFontSize;
            objFontBold = new Bold(); // Set font to Bold 
            objFont.Bold = objFontBold;
            objCollectionFonts.Append(objFont);
            #endregion

            //3 
            #region Arial - Normal - 8 size - gray color font
            objFont = new Font();
            objFontName = new FontName();
            objFontName.Val = StringValue.FromString("Arial");
            objFontSize = new FontSize();
            objFontSize.Val = DoubleValue.FromDouble(8);
            objFont.FontName = objFontName;
            objFont.FontSize = objFontSize;
            objColor = new Color() { Rgb = HexBinaryValue.FromString("00808080") }; // assign gray color to font
            objFont.Append(objColor);
            objCollectionFonts.Append(objFont);
            #endregion

            //4 
            #region Arial - bold - 9 size - Blue Colored - Underline
            objFont = new Font();
            objFontName = new FontName();
            objFontName.Val = StringValue.FromString("Arial");
            objFontSize = new FontSize();
            objFontSize.Val = DoubleValue.FromDouble(9);
            objFont.FontName = objFontName;
            objFont.FontSize = objFontSize;
            objUnderline = new Underline();
            objFont.Underline = objUnderline;
            objColor = new Color() { Rgb = HexBinaryValue.FromString("000000ff") };// blue color for hyperlinks
            objFont.Append(objColor);
            objFontBold = new Bold();
            objFont.Bold = objFontBold;
            objCollectionFonts.Append(objFont);
            #endregion

            //5 Arial - bold - 9 size - red
            #region Arial - bold - 9 size - red
            objFont = new Font();
            objFontName = new FontName();
            objFontName.Val = StringValue.FromString("Arial");
            objFontSize = new FontSize();
            objFontSize.Val = DoubleValue.FromDouble(9);
            objFont.FontName = objFontName;
            objFont.FontSize = objFontSize;
            objColor = new Color() { Rgb = HexBinaryValue.FromString("00ff0000") }; // assign red color to text
            objFont.Append(objColor);
            objFontBold = new Bold();
            objFont.Bold = objFontBold;
            objCollectionFonts.Append(objFont);
            #endregion

            //6
            #region Arial Narrow - Normal - 10 size
            objFont = new Font();
            objFontName = new FontName();
            objFontName.Val = StringValue.FromString("Arial Narrow");
            objFontSize = new FontSize();
            objFontSize.Val = DoubleValue.FromDouble(10);
            objFont.FontName = objFontName;
            objFont.FontSize = objFontSize;
            objCollectionFonts.Append(objFont);
            #endregion // Arial - Normal - 10 size

            //7 
            #region Arial Narrow - Bold - 10 size
            objFont = new Font();
            objFontName = new FontName();
            objFontName.Val = StringValue.FromString("Arial Narrow");
            objFontSize = new FontSize();
            objFontSize.Val = DoubleValue.FromDouble(10);
            objFont.FontName = objFontName;
            objFont.FontSize = objFontSize;
            objFontBold = new Bold(); // Set font to Bold 
            objFont.Bold = objFontBold;
            objCollectionFonts.Append(objFont);
            #endregion

            //8 
            #region Arial - Normal - 8 size
            objFont = new Font();
            objFontName = new FontName();
            objFontName.Val = StringValue.FromString("Arial");
            objFontSize = new FontSize();
            objFontSize.Val = DoubleValue.FromDouble(8);
            objFont.FontName = objFontName;
            objFont.FontSize = objFontSize;
            objCollectionFonts.Append(objFont);
            #endregion

            //9
            #region Wingdings - Normal - 14 size - Red
            objFont = new Font();
            objFontName = new FontName();
            objFontName.Val = StringValue.FromString("Wingdings");
            objFontSize = new FontSize();
            objFontSize.Val = DoubleValue.FromDouble(14);
            objFont.FontName = objFontName;
            objFont.FontSize = objFontSize;
            objColor = new Color() { Rgb = HexBinaryValue.FromString("00ff0000") }; // assign red color to text
            objFont.Append(objColor);
            objCollectionFonts.Append(objFont);
            #endregion

            //10
            #region Wingdings - Normal - 14 size - Green
            objFont = new Font();
            objFontName = new FontName();
            objFontName.Val = StringValue.FromString("Wingdings");
            objFontSize = new FontSize();
            objFontSize.Val = DoubleValue.FromDouble(14);
            objFont.FontName = objFontName;
            objFont.FontSize = objFontSize;
            objColor = new Color() { Rgb = HexBinaryValue.FromString("00B050") }; // assign green color to text
            objFont.Append(objColor);
            objCollectionFonts.Append(objFont);
            #endregion

            //11
            #region Wingdings - Normal - 20 size - Orange
            objFont = new Font();
            objFontName = new FontName();
            objFontName.Val = StringValue.FromString("Wingdings 2");
            objFontSize = new FontSize();
            objFontSize.Val = DoubleValue.FromDouble(20);
            objFont.FontName = objFontName;
            objFont.FontSize = objFontSize;
            objColor = new Color() { Rgb = HexBinaryValue.FromString("FF7F27") }; // assign orange color to text
            objFont.Append(objColor);
            objCollectionFonts.Append(objFont);
            #endregion

            //Get count of fonts in the collection
            objCollectionFonts.Count = UInt32Value.FromUInt32((uint)objCollectionFonts.ChildElements.Count);
            #endregion Fonts collection

            #region Fills collection
            objCollectionFills = new Fills();

            //0 
            #region none - No fill
            objFill = new Fill();
            objPatternFill = new PatternFill();
            objPatternFill.PatternType = PatternValues.None;
            objFill.PatternFill = objPatternFill;
            objCollectionFills.Append(objFill);
            #endregion

            //1 
            #region default system gray
            objFill = new Fill();
            objPatternFill = new PatternFill();
            objPatternFill.PatternType = PatternValues.Gray125;
            objFill.PatternFill = objPatternFill;
            objCollectionFills.Append(objFill);
            #endregion

            //2 
            #region custom gray
            objFill = new Fill();
            objPatternFill = new PatternFill();
            objPatternFill.PatternType = PatternValues.Solid;
            objPatternFill.ForegroundColor = new ForegroundColor();
            objPatternFill.ForegroundColor.Rgb = HexBinaryValue.FromString("00b2b2b2"); // custom gray color
            objPatternFill.BackgroundColor = new BackgroundColor();
            objPatternFill.BackgroundColor.Rgb = HexBinaryValue.FromString("00b2b2b2");
            objFill.PatternFill = objPatternFill;
            objCollectionFills.Append(objFill);
            #endregion

            //3 
            #region custom yellow
            objFill = new Fill();
            objPatternFill = new PatternFill();
            objPatternFill.PatternType = PatternValues.Solid;
            objPatternFill.ForegroundColor = new ForegroundColor();
            objPatternFill.ForegroundColor.Rgb = HexBinaryValue.FromString("00ffff99");  //custom yellow color
            objPatternFill.BackgroundColor = new BackgroundColor();
            objPatternFill.BackgroundColor.Rgb = HexBinaryValue.FromString("00ffff99");  //custom yellow color
            objFill.PatternFill = objPatternFill;
            objCollectionFills.Append(objFill);
            #endregion

            //4 
            #region custom light gray
            objFill = new Fill();
            objPatternFill = new PatternFill();
            objPatternFill.PatternType = PatternValues.Solid;
            objPatternFill.ForegroundColor = new ForegroundColor();
            objPatternFill.ForegroundColor.Rgb = HexBinaryValue.FromString("00d8d8d8");// custom light gray
            objPatternFill.BackgroundColor = new BackgroundColor();
            objPatternFill.BackgroundColor.Rgb = HexBinaryValue.FromString("00d8d8d8"); //custom light gray
            objFill.PatternFill = objPatternFill;
            objCollectionFills.Append(objFill);
            #endregion

            //5 
            #region custom light blue
            objFill = new Fill();
            objPatternFill = new PatternFill();
            objPatternFill.PatternType = PatternValues.Solid;
            objPatternFill.ForegroundColor = new ForegroundColor();
            objPatternFill.ForegroundColor.Rgb = HexBinaryValue.FromString("0095b3d7");// custom light gray
            objPatternFill.BackgroundColor = new BackgroundColor();
            objPatternFill.BackgroundColor.Rgb = HexBinaryValue.FromString("0095b3d7"); //custom light gray
            objFill.PatternFill = objPatternFill;
            objCollectionFills.Append(objFill);
            #endregion

            //new additions by Lankesh Begins
            //6
            #region custom light yellow
            objFill = new Fill();
            objPatternFill = new PatternFill();
            objPatternFill.PatternType = PatternValues.Solid;
            objPatternFill.ForegroundColor = new ForegroundColor();
            objPatternFill.ForegroundColor.Rgb = HexBinaryValue.FromString("00ffffC9");  //custom light yellow color
            objPatternFill.BackgroundColor = new BackgroundColor();
            objPatternFill.BackgroundColor.Rgb = HexBinaryValue.FromString("00ffffC9");  //custom light yellow color
            objFill.PatternFill = objPatternFill;
            objCollectionFills.Append(objFill);
            #endregion

            //7
            #region custom green
            objFill = new Fill();
            objPatternFill = new PatternFill();
            objPatternFill.PatternType = PatternValues.Solid;
            objPatternFill.ForegroundColor = new ForegroundColor();
            objPatternFill.ForegroundColor.Rgb = HexBinaryValue.FromString("0076933c");  //custom green color
            objPatternFill.BackgroundColor = new BackgroundColor();
            objPatternFill.BackgroundColor.Rgb = HexBinaryValue.FromString("0076933c");  //custom green color
            objFill.PatternFill = objPatternFill;
            objCollectionFills.Append(objFill);
            #endregion custom green

            //8
            #region custom blue
            objFill = new Fill();
            objPatternFill = new PatternFill();
            objPatternFill.PatternType = PatternValues.Solid;
            objPatternFill.ForegroundColor = new ForegroundColor();
            objPatternFill.ForegroundColor.Rgb = HexBinaryValue.FromString("0000b0f0");  //custom blue color
            objPatternFill.BackgroundColor = new BackgroundColor();
            objPatternFill.BackgroundColor.Rgb = HexBinaryValue.FromString("0000b0f0");  //custom blue color
            objFill.PatternFill = objPatternFill;
            objCollectionFills.Append(objFill);
            #endregion custom blue
            //new additions by Lankesh Ends

            //9
            #region AQUA blue
            objFill = new Fill();
            objPatternFill = new PatternFill();
            objPatternFill.PatternType = PatternValues.Solid;
            objPatternFill.ForegroundColor = new ForegroundColor();
            objPatternFill.ForegroundColor.Rgb = HexBinaryValue.FromString("00DAEEF3");  //custom blue color
            objPatternFill.BackgroundColor = new BackgroundColor();
            objPatternFill.BackgroundColor.Rgb = HexBinaryValue.FromString("00DAEEF3");  //custom blue color
            objFill.PatternFill = objPatternFill;
            objCollectionFills.Append(objFill);
            #endregion custom blue

            //get count of fills in the collection
            objCollectionFills.Count = UInt32Value.FromUInt32((uint)objCollectionFills.ChildElements.Count);
            #endregion Fills collection

            #region Borders collection
            objCollectionBorders = new Borders();
            //0
            #region No border
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.RightBorder = new RightBorder();
            objBorder.TopBorder = new TopBorder();
            objBorder.BottomBorder = new BottomBorder();
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //1 
            #region Left, Right, Top, Bottom Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.LeftBorder.Style = BorderStyleValues.Thin;
            objBorder.RightBorder = new RightBorder();
            objBorder.RightBorder.Style = BorderStyleValues.Thin;
            objBorder.TopBorder = new TopBorder();
            objBorder.TopBorder.Style = BorderStyleValues.Thin;
            objBorder.BottomBorder = new BottomBorder();
            objBorder.BottomBorder.Style = BorderStyleValues.Thin;
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //2 
            #region Top, Bottom thin border
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.RightBorder = new RightBorder();
            objBorder.TopBorder = new TopBorder();
            objBorder.TopBorder.Style = BorderStyleValues.Thin;
            objBorder.BottomBorder = new BottomBorder();
            objBorder.BottomBorder.Style = BorderStyleValues.Thin;
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //3 
            #region Dashed bottom border
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.RightBorder = new RightBorder();
            objBorder.TopBorder = new TopBorder();
            objBorder.BottomBorder = new BottomBorder();
            objBorder.BottomBorder.Style = BorderStyleValues.Dashed;
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //4 
            #region Top thin border
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.RightBorder = new RightBorder();
            objBorder.TopBorder = new TopBorder();
            objBorder.TopBorder.Style = BorderStyleValues.Thin;
            objBorder.BottomBorder = new BottomBorder();
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //5
            #region Left, bootom, top, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.LeftBorder.Style = BorderStyleValues.Thin;
            objBorder.RightBorder = new RightBorder();
            objBorder.TopBorder = new TopBorder();
            objBorder.TopBorder.Style = BorderStyleValues.Thin;
            objBorder.BottomBorder = new BottomBorder();
            objBorder.BottomBorder.Style = BorderStyleValues.Thin;
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //6
            #region Right, bootom, top, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.RightBorder = new RightBorder();
            objBorder.RightBorder.Style = BorderStyleValues.Thin;
            objBorder.TopBorder = new TopBorder();
            objBorder.TopBorder.Style = BorderStyleValues.Thin;
            objBorder.BottomBorder = new BottomBorder();
            objBorder.BottomBorder.Style = BorderStyleValues.Thin;
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //7
            #region Left, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.LeftBorder.Style = BorderStyleValues.Thin;
            objBorder.RightBorder = new RightBorder();
            objBorder.TopBorder = new TopBorder();
            objBorder.BottomBorder = new BottomBorder();
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //8
            #region Right, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.RightBorder = new RightBorder();
            objBorder.RightBorder.Style = BorderStyleValues.Thin;
            objBorder.TopBorder = new TopBorder();
            objBorder.BottomBorder = new BottomBorder();
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //9
            #region Left, Bottom, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.LeftBorder.Style = BorderStyleValues.Thin;
            objBorder.RightBorder = new RightBorder();
            objBorder.TopBorder = new TopBorder();
            objBorder.BottomBorder = new BottomBorder();
            objBorder.BottomBorder.Style = BorderStyleValues.Thin;
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //10
            #region Right, Bottom, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.RightBorder = new RightBorder();
            objBorder.RightBorder.Style = BorderStyleValues.Thin;
            objBorder.TopBorder = new TopBorder();
            objBorder.BottomBorder = new BottomBorder();
            objBorder.BottomBorder.Style = BorderStyleValues.Thin;
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //11
            #region Bottom, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.RightBorder = new RightBorder();
            objBorder.TopBorder = new TopBorder();
            objBorder.BottomBorder = new BottomBorder();
            objBorder.BottomBorder.Style = BorderStyleValues.Thin;
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //12
            #region Left, Right, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.LeftBorder.Style = BorderStyleValues.Thin;
            objBorder.RightBorder = new RightBorder();
            objBorder.RightBorder.Style = BorderStyleValues.Thin;
            objBorder.TopBorder = new TopBorder();
            objBorder.BottomBorder = new BottomBorder();
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //13
            #region Left, Right, Bottom, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.LeftBorder.Style = BorderStyleValues.Thin;
            objBorder.RightBorder = new RightBorder();
            objBorder.RightBorder.Style = BorderStyleValues.Thin;
            objBorder.TopBorder = new TopBorder();
            objBorder.BottomBorder = new BottomBorder();
            objBorder.BottomBorder.Style = BorderStyleValues.Thin;
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //14
            #region Left, Top, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.LeftBorder.Style = BorderStyleValues.Thin;
            objBorder.RightBorder = new RightBorder();
            objBorder.TopBorder = new TopBorder();
            objBorder.TopBorder.Style = BorderStyleValues.Thin;
            objBorder.BottomBorder = new BottomBorder();
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //15
            #region Right, Top, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.RightBorder = new RightBorder();
            objBorder.RightBorder.Style = BorderStyleValues.Thin;
            objBorder.TopBorder = new TopBorder();
            objBorder.TopBorder.Style = BorderStyleValues.Thin;
            objBorder.BottomBorder = new BottomBorder();
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //16
            #region Left, Right, Bottom, Thin borders
            objBorder = new Border();
            objBorder.LeftBorder = new LeftBorder();
            objBorder.LeftBorder.Style = BorderStyleValues.Thin;
            objBorder.RightBorder = new RightBorder();
            objBorder.RightBorder.Style = BorderStyleValues.Thin;
            objBorder.TopBorder = new TopBorder();
            objBorder.TopBorder.Style = BorderStyleValues.Thin;
            objBorder.BottomBorder = new BottomBorder();
            objBorder.DiagonalBorder = new DiagonalBorder();
            objCollectionBorders.Append(objBorder);
            #endregion

            //get count of border objects in the collection
            objCollectionBorders.Count = UInt32Value.FromUInt32((uint)objCollectionBorders.ChildElements.Count);
            #endregion

            #region CellStyleFormats
            objCollectionCellStyleFormats = new CellStyleFormats();
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = 0;
            objCellFormat.FontId = 0;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCollectionCellStyleFormats.Append(objCellFormat);

            //get count of cell style format in the collection
            objCollectionCellStyleFormats.Count = UInt32Value.FromUInt32((uint)objCollectionCellStyleFormats.ChildElements.Count);
            #endregion

            #region Numbering formats
            objCollectionNumberingFormats = new NumberingFormats();

            //0           
            #region  #,##0.00000000 8 decimals
            NumberingFormat objNF8Decimal = new NumberingFormat();
            objNF8Decimal.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            objNF8Decimal.FormatCode = StringValue.FromString("#,##0.00000000");
            objCollectionNumberingFormats.Append(objNF8Decimal);
            #endregion

            //1 
            #region #,##0.00 is also Excel style index 4
            NumberingFormat objNF2Decimal = new NumberingFormat();
            objNF2Decimal.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            objNF2Decimal.FormatCode = StringValue.FromString("#,##0.00_);(#,##0.00);-;");
            objCollectionNumberingFormats.Append(objNF2Decimal);
            #endregion

            //2
            #region  @ is also Excel style index 49
            NumberingFormat nfForcedText = new NumberingFormat();
            nfForcedText.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            nfForcedText.FormatCode = StringValue.FromString("@");
            objCollectionNumberingFormats.Append(nfForcedText);
            #endregion

            //3           
            #region no decimals
            NumberingFormat objNF0Decimal = new NumberingFormat();
            objNF0Decimal.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            objNF0Decimal.FormatCode = StringValue.FromString("0_);(0);-;");
            objCollectionNumberingFormats.Append(objNF0Decimal);
            #endregion

            //4
            #region 6 decimals
            NumberingFormat objNF6Decimal = new NumberingFormat();
            objNF6Decimal.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            objNF6Decimal.FormatCode = StringValue.FromString("#,##0.00####_);(#,##0.00####)");
            objCollectionNumberingFormats.Append(objNF6Decimal);
            #endregion

            //5           
            #region no decimals with thousand separator
            NumberingFormat objNF0DecimalWithComma = new NumberingFormat();
            objNF0DecimalWithComma.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            objNF0DecimalWithComma.FormatCode = StringValue.FromString("#,##0_);(#,##0);-;");
            objCollectionNumberingFormats.Append(objNF0DecimalWithComma);
            #endregion

            //6 
            #region #,##0.00 Without Bracket
            NumberingFormat objNF2DecimalWithoutBracket = new NumberingFormat();
            objNF2DecimalWithoutBracket.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            objNF2DecimalWithoutBracket.FormatCode = StringValue.FromString("#,##0.00");
            objCollectionNumberingFormats.Append(objNF2DecimalWithoutBracket);
            #endregion

            //7
            #region dd.mm.yyyy                      h:mm AM/PM
            NumberingFormat objNFDateTime = new NumberingFormat();
            objNFDateTime.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            objNFDateTime.FormatCode = StringValue.FromString("dd.mm.yyyy                      h:mm AM/PM");
            objCollectionNumberingFormats.Append(objNFDateTime);
            #endregion

            //8
            #region 4 decimals #,##0.0000 Without Bracket
            NumberingFormat objNF4DecimalWithoutBracket = new NumberingFormat();
            objNF4DecimalWithoutBracket.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            objNF4DecimalWithoutBracket.FormatCode = StringValue.FromString("#,##0.0000");
            objCollectionNumberingFormats.Append(objNF4DecimalWithoutBracket);
            #endregion

            //9
            #region  #,##0.0 1 decimal with brackets
            NumberingFormat objNF1Decimal = new NumberingFormat();
            objNF1Decimal.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            objNF1Decimal.FormatCode = StringValue.FromString("#,##0.0_);(#,##0.0);-;");
            objCollectionNumberingFormats.Append(objNF1Decimal);
            #endregion

            //10
            #region dd.mm.yyyy HH:mm (24 hour)
            NumberingFormat objNF24DateTime = new NumberingFormat();
            objNF24DateTime.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            objNF24DateTime.FormatCode = StringValue.FromString("dd-mm-yyyy h:mm");
            objCollectionNumberingFormats.Append(objNF24DateTime);
            #endregion

            //11
            #region  General
            NumberingFormat nfGeneral = new NumberingFormat();
            nfGeneral.NumberFormatId = UInt32Value.FromUInt32(iExcelIndex++);
            nfGeneral.FormatCode = StringValue.FromString("General");
            objCollectionNumberingFormats.Append(nfGeneral);
            #endregion // General
            #endregion Numbering formats

            #region Cellformats for text and numeric cells
            //create object of cell format collection
            objCollectionCellFormats = new CellFormats();

            //0 
            #region default, no style
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = 0;
            objCellFormat.FontId = 0;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #region Primary text styles : 24
            // TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS 
            #region custom gray background, bold with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS 
            #region custom gray background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_V_ALIGN_CENTER_WITH_BORDERS 
            #region custom gray background, bold with all borders, v-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS 
            #region custom gray background, bold with all borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_H_CENTER_V_BOTTOM_WITH_BORDERS 
            #region custom gray background, bold with all borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_CUSTOM_GRAY_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS
            #region custom gray background, normal with borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_CUSTOM_GREEN_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS
            #region custom green background, bold with borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 7; //custom green
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion custom green background, normal with borders, h-align center

            //TEXT_CUSTOM_BLUE_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS
            #region custom blue background, bold with borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 8; //custom blue
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion custom green background, normal with borders, h-align center

            //TEXT_CUSTOM_LIGHT_BLUE_BACKGROUND_BOLD_CENTER_ALIGN
            #region custom blue background, bold with no borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 5; //custom blue
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion custom green background, normal with no borders, h-align center

            //TEXT_CUSTOM_LIGHT_BLUE_BACKGROUND_BOLD_LEFT_ALIGN
            #region custom blue background, bold with no borders, h-align left
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 5; //custom blue
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion custom green background, normal with no borders, h-align left

            //TEXT_CUSTOM_LIGHT_BLUE_BACKGROUND_BOLD_RIGHT_ALIGN
            #region custom blue background, bold with no borders, h-align left
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 5; //custom blue
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion custom green background, normal with no borders, h-align left

            // TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS
            #region  plain background, bold with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS
            #region plain background, bold, no underline, no color, center align, with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS 
            #region plain background, normal with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_GRAY_COLOR_TEXT_WITH_SMALL_SIZE 
            #region Plain background, normal, gray color text with small size
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 3;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_TEXT_WITH_SMALL_SIZE 
            #region Plain background, normal, gray color text with small size
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 8;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS
            #region plain background, normal, no underline, no color, center align, with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region plain background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_NORMAL_WITH_DASHED_BOOTOM_BORDER
            #region plain background, normal with dashed bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 3;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS
            #region plain background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_LIGHT_BLUE_BACKGROUND_BOLD_WITH_BORDERS
            #region  Light blue background, bold with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 5;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLANE_BACKGROUND_WINGDINGS_FONT_RED
            #region TEXT_PLANE_BACKGROUND_WINGDINGS_FONT_RED
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion //TEXT_PLANE_BACKGROUND_WINGDINGS_FONT_RED


            //TEXT_PLANE_BACKGROUND_WINGDINGS_FONT_GREEN
            #region TEXT_PLANE_BACKGROUND_WINGDINGS_FONT_GREEN
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion //TEXT_PLANE_BACKGROUND_WINGDINGS_FONT_GREEN

            //TEXT_PLANE_BACKGROUND_WINGDINGS_FONT_ORANGE
            #region TEXT_PLANE_BACKGROUND_WINGDINGS_FONT_ORANGE
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion //TEXT_PLANE_BACKGROUND_WINGDINGS_FONT_ORANGE
            #endregion // Primary text styles : 24

            #region Text styles with Indentation  : 16
            /* Following styles are meant for indentation*/
            // TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_1
            #region  plain background, bold with all borders, Indent = 1
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 1;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_2
            #region  plain background, bold with all borders, Indent = 2
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 2;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_3
            #region  plain background, bold with all borders, Indent = 3
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 3;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_4
            #region  plain background, bold with all borders, Indent = 4
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 4;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_5
            #region  plain background, bold with all borders, Indent = 5
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 5;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_6
            #region  plain background, bold with all borders, Indent = 6
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 6;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_7
            #region  plain background, bold with all borders, Indent = 7
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 7;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_8
            #region  plain background, bold with all borders, Indent = 8
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 8;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_1 
            #region plain background, normal with all borders , Indent = 1
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 1;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_2 
            #region plain background, normal with all borders , Indent = 2
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 2;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_3
            #region plain background, normal with all borders , Indent = 3
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 3;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_4
            #region plain background, normal with all borders , Indent = 4
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 4;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_5 
            #region plain background, normal with all borders , Indent = 5
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 5;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_6 
            #region plain background, normal with all borders , Indent = 6
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 6;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_7 
            #region plain background, normal with all borders , Indent = 7
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 7;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_8 
            #region plain background, normal with all borders , Indent = 8
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 8;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            /* end of styles are meant for indentation*/
            #endregion // Text styles with Indentation : 16


            #region Text styles with no border with indentation : 22
            // TEXT_PLAIN_BACKGROUND_BOLD_WITH_NO_BORDER_NO_WRAP 
            #region plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_WITH_NO_BORDER 
            #region plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_CENTER_ALIGN_WITH_NO_BORDER 
            #region plain background, bold with no border center align
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_NORMAL_WITH_NO_BORDER
            #region plain background, normal with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_1
            #region  plain background, bold with no borders, Indent = 1
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 1;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_2
            #region  plain background, bold with no borders, Indent = 2
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 2;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_3
            #region  plain background, bold with no borders, Indent = 3
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 3;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_4
            #region  plain background, bold with no borders, Indent = 4
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 4;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_5
            #region  plain background, bold with no borders, Indent = 5
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 5;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_6
            #region  plain background, bold with no borders, Indent = 6
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 6;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_7
            #region  plain background, bold with no borders, Indent = 7
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 7;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_8
            #region  plain background, bold with no borders, Indent = 8
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 8;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_NO_IDENT
            #region  plain background, bold with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_1 
            #region plain background, normal with no borders , Indent = 1
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 1;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_2 
            #region plain background, normal with no borders , Indent = 2
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 2;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_3
            #region plain background, normal with no borders , Indent = 3
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 3;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_4
            #region plain background, normal with no borders , Indent = 4
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 4;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_5 
            #region plain background, normal with no borders , Indent = 5
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 5;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_6 
            #region plain background, normal with no borders , Indent = 6
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 6;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_7 
            #region plain background, normal with no borders , Indent = 7
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 7;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_8 
            #region plain background, normal with no borders , Indent = 8
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 8;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_NO_IDENT 
            #region plain background, normal with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TEXT_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN
            #region plain background, normal, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN
            #region plain background, bold, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BORDER
            #region plain background, bold, right align with left border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 5;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BORDER
            #region plain background, bold, right align with left border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 6;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_NORMAL_CENTER_ALIGN
            #region plain background, normal, no underline, no color, center align, with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_BOLD_CENTER_ALIGN
            #region plain background, bold, center align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_NO_IDENT_GENERAL 
            #region plain background, normal with no borders with number format General
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfGeneral.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Vertical = VerticalAlignmentValues.Top;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region plain background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // Text styles with no border with indentation


            #region Text styles with bottom border : 22
            //TEXT_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_BOTTOM_BORDER
            #region plain background, normal, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_BOTTOM_BORDER
            #region plain background, bold, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_1_BOTTOM_BORDER
            #region  plain background, bold with no borders, Indent = 1
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 1;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_2_BOTTOM_BORDER
            #region  plain background, bold with no borders, Indent = 2
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 2;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_3_BOTTOM_BORDER
            #region  plain background, bold with no borders, Indent = 3
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 3;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_4_BOTTOM_BORDER
            #region  plain background, bold with no borders, Indent = 4
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 4;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_5_BOTTOM_BORDER
            #region  plain background, bold with no borders, Indent = 5
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 5;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_6_BOTTOM_BORDER
            #region  plain background, bold with no borders, Indent = 6
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 6;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_7_BOTTOM_BORDER
            #region  plain background, bold with no borders, Indent = 7
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 7;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_INDENT_8_BOTTOM_BORDER
            #region  plain background, bold with no borders, Indent = 8
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 8;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_BOLD_NO_IDENT_BOTTOM_BORDER
            #region  plain background, bold with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_1_BOTTOM_BORDER 
            #region plain background, normal with no borders , Indent = 1
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 1;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_2_BOTTOM_BORDER 
            #region plain background, normal with no borders , Indent = 2
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 2;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_3_BOTTOM_BORDER
            #region plain background, normal with no borders , Indent = 3
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 3;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_4_BOTTOM_BORDER
            #region plain background, normal with no borders , Indent = 4
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 4;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_5_BOTTOM_BORDER 
            #region plain background, normal with no borders , Indent = 5
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 5;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_6_BOTTOM_BORDER 
            #region plain background, normal with no borders , Indent = 6
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 6;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_7_BOTTOM_BORDER 
            #region plain background, normal with no borders , Indent = 7
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 7;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_8_BOTTOM_BORDER 
            #region plain background, normal with no borders , Indent = 8
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Indent = 8;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // TEXT_PLAIN_BACKGROUND_NORMAL_NO_IDENT_BOTTOM_BORDER 
            #region plain background, normal with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TEXT_PLAIN_BACKGROUND_NORMAL_CENTER_ALIGN_BOTTOM_BORDER
            #region plain background, normal, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_PLAIN_BACKGROUND_BOLD_CENTER_ALIGN_BOTTOM_BORDER
            #region plain background, bold, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // Text styles with bottom border : 22

            
            #region Text style with light and dark yellow background
            //TEXT_LIGHT_YELLOW_BACKGROUND_NORMAL_NO_BORDER
            #region light yellow background, normal, left align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 6;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TEXT_DARK_YELLOW_BACKGROUND_NORMAL_TOP_BORDER
            #region dark yellow background, normal, left align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // Text style with light and dark yellow background

            #region Arial narrow 10 : 11
            //ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS
            #region arial narrow 10, custom gray background, bold with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS 
            #region arial narrow 10, custom gray background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            // ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS
            #region  arial narrow 10, plain background, bold with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS 
            #region arial narrow 10, plain background, normal with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            // ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_NO_BORDER 
            #region arial narrow 10, plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_V_ALIGN_CENTER_WITH_BORDERS
            #region arial narrow 10, custom gray background, bold with all borders, v-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS 
            #region arial narrow 10, custom gray background, bold with all borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS
            #region arial narrow 10, plain background, normal, no underline, no color, center align, with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region arial narrow 10, plain background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS
            #region arial narrow 10, custom gray background, normal with no borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            // ARIAL_NARROW_10_TEXT_AQUA_BACKGROUND_BOLD_WITH_BORDERS
            #region  arial narrow 10, aqua background, bold with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // Arial narrow 10 end : 11

            #region Link for both text and numeric (schedule no) : 2
            // LINK_PLAIN_BACKGROUND_NORMAL_UNDERLINE_BLUE_COLOR_CENTER_ALIGN 
            #region plain background, normal, underline,  blue color, center align, with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 4;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // LINK_PLAIN_BACKGROUND_NORMAL_UNDERLINE_BLUE_COLOR_CENTER_ALIGN_WITH_BORDERS 
            #region plain background, normal, underline,  blue color, center align, with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 4;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // Link for both text and numeric (schedule no) : 2


            #region no decimal with border : 18
            //NO_DECIMAL_NUMERIC_WITHOUT_COMMA_PLAIN_BACKGROUND_NORMAL_LEFT_ALIGN_WITH_BORDERS
            #region  numeric without comma: plain , normal, left align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_WITHOUT_COMMA_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region  numeric without comma: plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0 no decimal numeric : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS
            #region no decimal numeric : plain , normal, center align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0 no decimal numeric : yellow background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0 no decimal numeric : yellow background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0 no decimal numeric : AQUA background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0 no decimal numeric : AQUA background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region #,##0 no decimal : light gray background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS
            #region #,##0 no decimal : light gray background , bold,right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_NUMERIC_WITH_THOUSAND_SEPARATOR_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region #,##0 no decimal : plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_WITH_THOUSAND_SEPARATOR_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS
            #region #,##0 no decimal : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0 no decimal : light yellow background , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0 no decimal : light yellow background , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0 no decimal : aqua background , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0 no decimal : aqua background , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            /* Arial Narrow 10 */
            //ARIAL_NARROW_10_NO_DECIMAL_NUMERIC_WITHOUT_COMMA_PLAIN_BACKGROUND_NORMAL_LEFT_ALIGN_WITH_BORDERS
            #region  numeric without comma: arial narrow 10, plain , normal, left align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0Decimal.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ARIAL_NARROW_10_NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS
            #region no decimal numeric : arial narrow 10, plain , normal, center align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            /* Arial Narrow 10 */
            #endregion // no decimal with border : 18

            #region No decimal with no border : 12
            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN
            #region #,##0 no decimal : plain , normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN 
            #region #,##0 no decimal numeric : plain , bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN 
            #region #,##0 no decimal numeric : yellow background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN 
            #region #,##0 no decimal numeric : yellow background, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN 
            #region #,##0 no decimal numeric : AQUA background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN 
            #region #,##0 no decimal numeric : AQUA background, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN
            #region #,##0 no decimal : light gray background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN
            #region #,##0 no decimal : light gray background , bold,right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN
            #region #,##0 no decimal : light yellow background , normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN
            #region #,##0 no decimal : light yellow background , bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN
            #region #,##0 no decimal : aqua background , normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //aqua
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN
            #region #,##0 no decimal : aqua background , bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //aqua
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // No decimal with no border : 12

            #region No decimal with top border : 12
            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER
            #region #,##0 no decimal : plain , normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER 
            #region #,##0 no decimal numeric : plain , bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER 
            #region #,##0 no decimal numeric : yellow background, bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER 
            #region #,##0 no decimal numeric : yellow background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER 
            #region #,##0 no decimal numeric : AQUA background, bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER 
            #region #,##0 no decimal numeric : AQUA background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER
            #region #,##0 no decimal : light gray background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER
            #region #,##0 no decimal : light gray background , bold,right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER
            #region #,##0 no decimal : light yellow background , normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER
            #region #,##0 no decimal : light yellow background , bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_LIGHT_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER
            #region #,##0 no decimal : aqua background , normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER
            #region #,##0 no decimal : aqua background , bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // No decimal with top border : 12


            #region No decimal with top and bootom border : 12
            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0 no decimal : plain , normal, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : plain , bold, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : yellow background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : yellow background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : AQUA background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : AQUA background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0 no decimal : light gray background, normal, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0 no decimal : light gray background , bold,right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0 no decimal : light yellow background , normal, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0 no decimal : light yellow background , bold, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_LIGHT_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0 no decimal : aqua background , normal, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //aqua
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0 no decimal : aqua background , bold, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //aqua
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // No decimal with top and bootom border : 12


            #region 1 decimal with border : 10
            //ONE_DECIMAL_NUMERIC_PLAIN_NORMAL_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.0 1 decimal : plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.0 1 decimal : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.0 1 decimal : yellow, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.0 1 decimal : AQUA, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region #,##0.0 1 decimal numeric, light gray background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS
            #region  #,##0.0 1 decimal numeric, light gray background , bold,right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.0 1 decimal : light yellow, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.0 1 decimal : light yellow, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.0 1 decimal : aqua, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //light yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.0 1 decimal : aqua, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //normal
            objCellFormat.FillId = 9; //light yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // 1 decimal with border : 10

            #region 1 decimal with no border : 9
            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN
            #region #,##0.0 1 decimal : plain , normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN
            #region #,##0.0 1 decimal : plain , bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN
            #region #,##0.0 1 decimal : yellow, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN
            #region #,##0.0 1 decimal numeric, light gray background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN
            #region  #,##0.0 1 decimal numeric, light gray background , bold,right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN
            #region #,##0.0 1 decimal : light yellow, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN
            #region #,##0.0 1 decimal : light yellow, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN
            #region #,##0.0 1 decimal : aqua, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //aqua
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN
            #region #,##0.0 1 decimal : aqua, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //aqua
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // 1 decimal with no border : 9

            #region 1 decimal with top border : 10
            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER
            #region #,##0.0 1 decimal : plain , normal, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER
            #region #,##0.0 1 decimal : plain , bold, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER
            #region #,##0.0 1 decimal : yellow, bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER
            #region #,##0.0 1 decimal : AQUA, bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER
            #region #,##0.0 1 decimal numeric, light gray background, normal, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER
            #region  #,##0.0 1 decimal numeric, light gray background , bold,right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER
            #region #,##0.0 1 decimal : light yellow, normal, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER
            #region #,##0.0 1 decimal : light yellow, bold, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //ONE_DECIMAL_NUMERIC_LIGHT_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER
            #region #,##0.0 1 decimal : AQUA, normal, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER
            #region #,##0.0 1 decimal : AQUA, bold, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // 1 decimal with top border : 10

            #region 1 decimal with top and bottom border : 10
            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0.0 1 decimal : plain , normal, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0.0 1 decimal : plain , bold, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0.0 1 decimal : yellow, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0.0 1 decimal : AQUA, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0.0 1 decimal numeric, light gray background, normal, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region  #,##0.0 1 decimal numeric, light gray background , bold,right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0.0 1 decimal : light yellow, normal, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0.0 1 decimal : light yellow, bold, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //ONE_DECIMAL_NUMERIC_LIGHT_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0.0 1 decimal : AQUA, normal, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0.0 1 decimal : AQUA, bold, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // 1 decimal with top and bottom border : 10


            #region 2 decimal with border : 19
            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0.00 2 decimal numeric : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0.00 2 decimal numeric : AQUA background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0.00 2 decimal numeric : AQUA background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0.00 2 decimal numeric, light gray background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS
            #region  #,##0.00 2 decimal numeric, light gray background , bold,right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RED_COLOR_RIGHT_ALIGN_WITH_NO_BORDER 
            #region #,##0.00 2 decimal numeric, plain, bold, red color, right align, with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 5;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RED_COLOR_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0.00 2 decimal numeric, plain, bold, red color, right align, with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 5;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TWO_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_DASHED_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : plain , bold, right align with dashed bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 3;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS_WITHOUT_BRACKET
            #region  #,##0.00 2 decimal numeric without bracket: plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS_WITHOUT_BRACKET 
            #region #,##0.00 2 decimal numeric without bracket : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TWO_DECIMAL_NUMERIC_LIGHT_BLUE_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0.00 2 decimal numeric : Light blue , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 5;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.00 2 decimal numeric, light yellow background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.00 2 decimal numeric, light yellow background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            // Arundhati 2-Jul-2014
            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.00 2 decimal numeric, AQUA background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS
            #region #,##0.00 2 decimal numeric, AQUA background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITHOUT_BORDERS_WITH_NO_BRACKET
            #region  #,##0.00 2 decimal numeric without bracket: plain , normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // 2 decimal with border : 19

            #region 2 decimal with no border : 10
            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN
            #region #,##0.00 2 decimal numeric : plain , bold, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN 
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundahti 2-Jul-2014
            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN 
            #region #,##0.00 2 decimal numeric : AQUA background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN 
            #region #,##0.00 2 decimal numeric : AQUA background, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN 
            #region #,##0.00 2 decimal numeric, light gray background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN
            #region  #,##0.00 2 decimal numeric, light gray background , bold,right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN
            #region #,##0.00 2 decimal numeric, light yellow background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN
            #region #,##0.00 2 decimal numeric, light yellow background, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // 2 decimal with no border : 10

            #region 2 decimal with top border : 10
            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER 
            #region #,##0.00 2 decimal numeric : plain , bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER 
            #region #,##0.00 2 decimal numeric : AQUA background, bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER 
            #region #,##0.00 2 decimal numeric : AQUA background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER 
            #region #,##0.00 2 decimal numeric, light gray background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER
            #region  #,##0.00 2 decimal numeric, light gray background , bold,right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER
            #region #,##0.00 2 decimal numeric, light yellow background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER
            #region #,##0.00 2 decimal numeric, light yellow background, bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // 2 decimal with top border : 10

            #region 2 decimal with top and bottom border : 10
            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : plain , bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : AQUA background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : AQUA background, normal, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric, light gray background, normal, right align with top and bottom  border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region  #,##0.00 2 decimal numeric, light gray background , bold,right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric, light yellow background, normal, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric, light yellow background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // 2 decimal with top and bottom border : 10


            #region Arial Narrow 10 with border : 7
            //ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region  #,##0.00 2 decimal numeric : arial narrow 10, plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS 
            #region #,##0.00 2 decimal numeric : arial narrow 10, plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region #,##0.00 2 decimal numeric, arial narrow 10, light gray background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS
            #region  #,##0.00 2 decimal numeric, arial narrow 10, light gray background , bold,right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS_WITHOUT_BRACKET
            #region  #,##0.00 2 decimal numeric without bracket: arial narrow 10, plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS_WITHOUT_BRACKET 
            #region #,##0.00 2 decimal numeric without bracket : arial narrow 10, plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region  #,##0.00 2 decimal numeric : arial narrow 10, aqua , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // Arial Narrow 10 with border : 7


            #region 4 decimal with border : 1
            //FOUR_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS_WITHOUT_BRACKET
            #region  #,##0.0000 4 decimal numeric without bracket: plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF4DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // 4 decimal with border : 1


            #region 6 decimal with border : 6
            //SIX_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region  #,##0.00#### 6 decimal numeric : plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //SIX_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS
            #region  #,##0.00#### 6 decimal numeric : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //SIX_DECIMAL_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region #,##0.00#### 6 decimal : light gray background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //SIX_DECIMAL_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS
            #region #,##0.00#### 6 decimal : light gray background , bold,right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //SIX_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_DASHED_BOTTOM_BORDERS
            #region  #,##0.00#### 6 decimal numeric : plain , normal, right align with dashed bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 3;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //SIX_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_NO_BORDERS
            #region  #,##0.00#### 6 decimal numeric : plain , normal, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // 6 decimal with border : 6


            #region 8 decimal with border : 1
            //EIGHT_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS
            #region  #,##0.00000000 8 decimal numeric : plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF8Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            #endregion // 8 decimal with border : 1


            #region Numeric with left border : 18
            //NO_DECIMAL_NUMERIC_WITH_THOUSAND_SEPARATOR_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BORDER
            #region #,##0 no decimal : plain , normal, right align with left border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BORDER
            #region #,##0 no decimal numeric : plain , bold, right align with left border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //ONE_DECIMAL_NUMERIC_PLAIN_NORMAL_RIGHT_ALIGN_WITH_LEFT_BORDER
            #region #,##0.0 1 decimal : plain , normal, right align with left border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_LEFT_BORDER
            #region #,##0.0 1 decimal : plain , bold, right align with left order
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BORDER
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with left border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BORDER 
            #region #,##0.00 2 decimal numeric : plain , bold, right align with left border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BORDER 
            #region #,##0 no decimal numeric : yellow background, normal, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BORDER
            #region #,##0 no decimal numeric : yellow background, bold, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BORDER
            #region #,##0.0 1 decimal : yellow, normal, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 3; //light yellow
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BORDER
            #region #,##0.0 1 decimal : yellow, bold, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BORDER
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            // Arundhti 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BORDER 
            #region #,##0 no decimal numeric : yellow background, normal, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BORDER
            #region #,##0 no decimal numeric : yellow background, bold, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BORDER
            #region #,##0.0 1 decimal : yellow, normal, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BORDER
            #region #,##0.0 1 decimal : yellow, bold, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //yellow
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BORDER
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with left borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 7;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // Numeric decimal with left border : 18


            #region Numeric with left, bottom border : 18
            //NO_DECIMAL_NUMERIC_WITH_THOUSAND_SEPARATOR_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BOTTOM_BORDER
            #region #,##0 no decimal : plain , normal, right align with left, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BOTTOM_BORDER
            #region #,##0 no decimal numeric : plain , bold, right align with left, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_NORMAL_RIGHT_ALIGN_WITH_LEFT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : plain , normal, right align with left, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_LEFT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : plain , bold, right align with left, bottom order
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BOTTOM_BORDER
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with left, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : plain , bold, right align with left, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : yellow background, normal, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : yellow background, bold, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : yellow, normal, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 3; //light yellow
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : yellow, bold, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : AQUA background, normal, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : AQUA background, bold, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : AQUA, normal, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : AQUA, bold, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : AQUA background, normal, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : AQUA background, bold, right align with left, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 9;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // Numeric decimal with left, bottom border : 18


            #region Numeric with right border : 18
            //NO_DECIMAL_NUMERIC_WITH_THOUSAND_SEPARATOR_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BORDER
            #region #,##0 no decimal : plain , normal, right align with right border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BORDER
            #region #,##0 no decimal numeric : plain , bold, right align with right border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_NORMAL_RIGHT_ALIGN_WITH_RIGHT_BORDER
            #region #,##0.0 1 decimal : plain , normal, right align with right border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_RIGHT_BORDER
            #region #,##0.0 1 decimal : plain , bold, right align with right order
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BORDER
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with right border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BORDER
            #region #,##0.00 2 decimal numeric : plain , bold, right align with right border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BORDER 
            #region #,##0 no decimal numeric : yellow background, normal, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BORDER
            #region #,##0 no decimal numeric : yellow background, bold, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BORDER
            #region #,##0.0 1 decimal : yellow, normal, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 3; //light yellow
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BORDER
            #region #,##0.0 1 decimal : yellow, bold, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BORDER 
            #region #,##0 no decimal numeric : AQUA background, normal, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BORDER
            #region #,##0 no decimal numeric : AQUA background, bold, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BORDER
            #region #,##0.0 1 decimal : AQUA, normal, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //light AQUA
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BORDER
            #region #,##0.0 1 decimal : AQUA, bold, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BORDER 
            #region #,##0.00 2 decimal numeric : AQUA background, normal, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BORDER 
            #region #,##0.00 2 decimal numeric : AQUA background, bold, right align with right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 8;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // Numeric decimal with right border : 18


            #region Numeric with right, bottom border : 18
            //NO_DECIMAL_NUMERIC_WITH_THOUSAND_SEPARATOR_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER
            #region #,##0 no decimal : plain , normal, right align with right, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER
            #region #,##0 no decimal numeric : plain , bold, right align with right, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_NORMAL_RIGHT_ALIGN_WITH_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : plain , normal, right align with right, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : plain , bold, right align with right, bottom order
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with right, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : plain , bold, right align with right, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER
            #region #,##0 no decimal numeric : yellow background, normal, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : yellow background, bold, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : yellow, normal, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 3; //light yellow
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : yellow, bold, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER
            #region #,##0 no decimal numeric : AQUA background, normal, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : AQUA background, bold, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : AQUA, normal, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //light AQUA
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : AQUA, bold, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : AQUA background, normal, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_BOTTOM_BORDER 
            #region #,##0.00 2 decimal numeric : AQUA background, bold, right align with right, bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 10;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // Numeric decimal with right, bottom border : 18


            #region Numeric with bottom border : 18
            //NO_DECIMAL_NUMERIC_WITH_THOUSAND_SEPARATOR_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0 no decimal : plain , normal, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0 no decimal numeric : plain , bold, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_NORMAL_RIGHT_ALIGN_WITH_BOTTOM_BORDER
            #region #,##0.0 1 decimal : plain , normal, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_BOTTOM_BORDER
            #region #,##0.0 1 decimal : plain , bold, right align with bottom order
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_BOTTOM_BORDER
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : plain , bold, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : yellow background, normal, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0 no decimal numeric : yellow background, bold, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0.0 1 decimal : yellow, normal, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 3; //light yellow
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0.0 1 decimal : yellow, bold, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : AQUA background, normal, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0 no decimal numeric : AQUA background, bold, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0.0 1 decimal : AQUA, normal, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0.0 1 decimal : AQUA, bold, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : AQUA background, normal, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : AQUA background, bold, right align with bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 11;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // Numeric decimal with bottom border : 18


            #region Numeric with left, right border : 18
            //NO_DECIMAL_NUMERIC_WITH_THOUSAND_SEPARATOR_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BORDER
            #region #,##0 no decimal : plain , normal, right align with left, right border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BORDER
            #region #,##0 no decimal numeric : plain , bold, right align with left, right border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_NORMAL_RIGHT_ALIGN_WITH_LEFT_RIGHT_BORDER
            #region #,##0.0 1 decimal : plain , normal, right align with left, right border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_LEFT_RIGHT_BORDER
            #region #,##0.0 1 decimal : plain , bold, right align with left, right order
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BORDER
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with left, right border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BORDER
            #region #,##0.00 2 decimal numeric : plain , bold, right align with left, right border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BORDER 
            #region #,##0 no decimal numeric : yellow background, normal, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BORDER 
            #region #,##0 no decimal numeric : yellow background, bold, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BORDER
            #region #,##0.0 1 decimal : yellow, normal, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 3; //light yellow
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BORDER
            #region #,##0.0 1 decimal : yellow, bold, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BORDER 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BORDER
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BORDER 
            #region #,##0 no decimal numeric : AQUA background, normal, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BORDER 
            #region #,##0 no decimal numeric : AQUA background, bold, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BORDER
            #region #,##0.0 1 decimal : AQUA, normal, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //light AQUA
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BORDER
            #region #,##0.0 1 decimal : AQUA, bold, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BORDER 
            #region #,##0.00 2 decimal numeric : AQUA background, normal, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BORDER
            #region #,##0.00 2 decimal numeric : AQUA background, bold, right align with left, right borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 12;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // Numeric decimal with left, right border : 18


            #region Numeric with left, right, bottom border : 18
            //NO_DECIMAL_NUMERIC_WITH_THOUSAND_SEPARATOR_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0 no decimal : plain , normal, right align with left, right, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0 no decimal numeric : plain , bold, right align with left, right, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_NORMAL_RIGHT_ALIGN_WITH_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : plain , normal, right align with left, right, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : plain , bold, right align with left, right, bottom order
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with left, right, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : plain , bold, right align with left, right, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : yellow background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0 no decimal numeric : yellow background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : yellow, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 3; //light yellow
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : yellow, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // Added by Arundhati 2-Jul-2014
            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER 
            #region #,##0 no decimal numeric : AQUA background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //NO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0 no decimal numeric : AQUA background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : AQUA, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 9; //light AQUA
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //ONE_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0.0 1 decimal : AQUA, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 9; //AQUA
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : AQUA background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //TWO_DECIMAL_NUMERIC_AQUA_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_BOTTOM_BORDER
            #region #,##0.00 2 decimal numeric : AQUA background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 9;
            objCellFormat.BorderId = 13;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            #endregion // Numeric decimal with left, right, bottom border : 18


            #region Numeric with left, top border : 6

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_TOP_BORDER
            #region no decimal: plain background, normal, right align with left, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 14;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // no decimal: plain background, normal, right align with left, top border

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_TOP_BORDER
            #region no decimal: plain background, bold, right align with left, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 14;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // no decimal: plain background, bold, right align with left, top border


            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_TOP_BORDER
            #region one decimal : plain background, normal, right align with left, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 14;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // one decimal : plain background, normal, right align with left, top border

            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_TOP_BORDER
            #region one decimal : plain background, bold, right align with left, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 14;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // one decimal : plain background, bold, right align with left, top border


            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_TOP_BORDER
            #region two decimal : numeric, plain background, normal, right align with left, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 14;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // two decimal : numeric, plain background, normal, right align with left, top border

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_TOP_BORDER
            #region two decimal : numeric, plain background, bold, right align with left, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 14;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // two decimal : numeric, plain background, bold, right align with left, top border

            #endregion // Numeric with left, top border : 6


            #region Numeric with left, top, bottom border : 6

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_TOP_BOTTOM_BORDER
            #region no decimal : plain background, normal, right align with left, top, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 5;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // no decimal : plain background, normal, right align with left, top border

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_TOP_BOTTOM_BORDER
            #region no decimal : plain background, bold, right align with left, top, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 5;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // no decimal : plain background, bold, right align with left, top border


            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_TOP_BOTTOM_BORDER
            #region one decimal : numeric, plain background, normal, right align with left, top, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 5;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // one decimal : numeric, plain background, right align with left, top, bottom border

            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_TOP_BOTTOM_BORDER
            #region one decimal : numeric, plain background, bold, right align with left, top, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 5;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // one decimal : numeric, plain background, bold, right align with left, top, bottom border


            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_TOP_BOTTOM_BORDER
            #region 2 decimal numeric, plain, normal, right align with left, top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 5;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // 2 decimal numeric, plain, normal, right align with left, top and bottom border

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_TOP_BOTTOM_BORDER
            #region 2 decimal numeric, plain, bold, right align with left, top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 5;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // 2 decimal numeric, plain, bold, right align with left, top and bottom border

            #endregion // Numeric with left, top, bottom border : 6


            #region Numeric with right, top border : 6

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_TOP_BORDER
            #region no decimal: plain background, normal, right align with right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 15;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // no decimal: plain background, normal, right align with right, top border

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_TOP_BORDER
            #region no decimal: plain background, bold, right align with right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 15;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // no decimal: plain background, bold, right align with right, top border


            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_TOP_BORDER
            #region one decimal : plain background, normal, right align with right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 15;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // one decimal : plain background, normal, right align with right, top border

            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_TOP_BORDER
            #region one decimal : plain background, bold, right align with right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 15;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // one decimal : plain background, bold, right align with right, top border


            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_TOP_BORDER
            #region two decimal : numeric, plain background, normal, right align with right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 15;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // two decimal : numeric, plain background, normal, right align with right, top border

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_TOP_BORDER
            #region two decimal : numeric, plain background, bold, right align with right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 15;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // two decimal : numeric, plain background, bold, right align with right, top border

            #endregion // Numeric with right, top border : 6


            #region Numeric with right, top, bottom border

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_TOP_BOTTOM_BORDER
            #region no decimal : plain background, normal, right align with right, top, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 6;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // no decimal : plain background, normal, right align with left, top, bottom border

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_TOP_BOTTOM_BORDER
            #region no decimal : plain background, bold, right align with right, top, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 6;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // no decimal : plain background, bold, right align with left, top, bottom border


            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_TOP_BOTTOM_BORDER
            #region one decimal : numeric, plain background, normal, right align with right, top, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 6;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // one decimal : numeric, plain background, normal, right align with right, top, bottom border

            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_TOP_BOTTOM_BORDER
            #region one decimal : numeric, plain background, bold, right align with right, top, bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 6;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // one decimal : numeric, plain background, bold, right align with right, top, bottom border


            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_RIGHT_TOP_BOTTOM_BORDER
            #region 2 decimal numeric, plain, normal, right align with right, top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 6;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // 2 decimal numeric, plain, normal, right align with right, top and bottom border

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_RIGHT_TOP_BOTTOM_BORDER
            #region 2 decimal numeric, plain, bold, right align with right, top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 6;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // 2 decimal numeric, plain, bold, right align with right, top and bottom border

            #endregion // Numeric with right, top, bottom border


            #region Numeric with left, right, top border : 6
         
            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_TOP_BORDER
            #region 1 decimal numeric, plain background, normal, right align, left, right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 16;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // 2 decimal numeric, plain background, normal, right align, left, right, top border

            //NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_TOP_BORDER
            #region 1 decimal numeric, plain background, bold, right align, left, right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 16;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // 2 decimal numeric, plain background, bold, right align, left, right, top border


            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_TOP_BORDER
            #region 1 decimal numeric, plain background, normal, right align, left, right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 16;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // 2 decimal numeric, plain background, normal, right align, left, right, top border

            //ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_TOP_BORDER
            #region 1 decimal numeric, plain background, bold, right align, left, right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 16;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // 2 decimal numeric, plain background, bold, right align, left, right, top border


            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_LEFT_RIGHT_TOP_BORDER
            #region 2 decimal numeric, plain background, normal, right align, left, right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 16;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // 2 decimal numeric, plain background, normal, right align, left, right, top border

            //TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_LEFT_RIGHT_TOP_BORDER
            #region 2 decimal numeric, plain background, bold, right align, left, right, top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 16;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = true;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion // 2 decimal numeric, plain background, bold, right align, left, right, top border


            #endregion // Numeric with left, right, top border : 6


            #region DateTime : 6
            // 12-hour : DATETIME_PLAIN_BACKGROUND_BOLD_LEFT_ALIGN_WITH_NO_BORDERS_dd_mm_yyyy_h_mm_AM_PM
            #region plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNFDateTime.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 12-hour : DATETIME_PLAIN_BACKGROUND_BOLD_LEFT_ALIGN_WITH_NO_BORDERS_dd_mm_yyyy_h_mm_AM_PM_RED
            #region plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNFDateTime.NumberFormatId;
            objCellFormat.FontId = 5;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //24-hour : DATETIME_PLAIN_BACKGROUND_NORMAL_LEFT_ALIGN_WITH_NO_BORDERS_dd_mm_yyyy_HH_mm
            #region plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF24DateTime.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //24-hour : DATETIME_PLAIN_BACKGROUND_BOLD_LEFT_ALIGN_WITH_NO_BORDERS_dd_mm_yyyy_HH_mm
            #region plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF24DateTime.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //24-hour : DATETIME_PLAIN_BACKGROUND_BOLD_LEFT_ALIGN_WITH_NO_BORDERS_dd_mm_yyyy_HH_mm_RED
            #region plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF24DateTime.NumberFormatId;
            objCellFormat.FontId = 5;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            /* Arial Narrow 10 */
            //ARIAL_NARROW_10_DATETIME_PLAIN_BACKGROUND_BOLD_LEFT_ALIGN_WITH_NO_BORDERS_dd_mm_yyyy_h_mm_AM_PM
            #region arial narrow 10, plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNFDateTime.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = false;
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = true;
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            /* Arial Narrow 10 */
            #endregion // DateTime : 6

            objCollectionNumberingFormats.Count = UInt32Value.FromUInt32((uint)objCollectionNumberingFormats.ChildElements.Count);
            objCollectionCellFormats.Count = UInt32Value.FromUInt32((uint)objCollectionCellFormats.ChildElements.Count);
            #endregion Cellformats for text and numeric cells

            //Append all collections to the current CustomStyleSheet object 
            this.Append(objCollectionNumberingFormats);
            this.Append(objCollectionFonts);
            this.Append(objCollectionFills);
            this.Append(objCollectionBorders);
            this.Append(objCollectionCellStyleFormats);
            this.Append(objCollectionCellFormats);

            #region The following region is mandatory, but it is not used anywhere.
            CellStyles objCollectionCellStyles = new CellStyles();
            CellStyle objCellStyle = new CellStyle();
            objCellStyle.Name = StringValue.FromString("Normal");
            objCellStyle.FormatId = 0;
            objCellStyle.BuiltinId = 0;
            objCollectionCellStyles.Append(objCellStyle);
            objCollectionCellStyles.Count = UInt32Value.FromUInt32((uint)objCollectionCellStyles.ChildElements.Count);
            this.Append(objCollectionCellStyles);

            DifferentialFormats objCollectiondfDifferentialFormats = new DifferentialFormats();
            objCollectiondfDifferentialFormats.Count = 0;
            this.Append(objCollectiondfDifferentialFormats);

            TableStyles objCollectionTableStyles = new TableStyles();
            objCollectionTableStyles.Count = 0;
            objCollectionTableStyles.DefaultTableStyle = StringValue.FromString("TableStyleMedium9");
            objCollectionTableStyles.DefaultPivotStyle = StringValue.FromString("PivotStyleLight16");
            this.Append(objCollectionTableStyles);
            #endregion
        }
    }
}
