using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml;

namespace InsiderTradingExcelWriter.ExcelFacade
{
    /* While adding new objects to the collections, ALWAYS append newly created object i.e. always add newly created object at the end of collection. 
     * Do NOT add any new object at any index of the collection. Otherwise, all indices will mismatch and appropriate styles would not be applied.*/
    public class CustomStyleSheet1 : Stylesheet
    {
        /// <summary>
        /// Class CustomStyleSheet is created to define all styles, formats, patterns reqiored to create cells in Excel using OpenXML.
        /// This class contains collections for fonts, formats, borders, numbering formats etc.
        /// </summary>
        public CustomStyleSheet1()
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

            #region Numering formats
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
            objNF2Decimal.FormatCode = StringValue.FromString("#,##0.00_);(#,##0.00)");
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
            objNF0Decimal.FormatCode = StringValue.FromString("0_);(0)");
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
            objNF0DecimalWithComma.FormatCode = StringValue.FromString("#,##0_);(#,##0)");
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
            objNF1Decimal.FormatCode = StringValue.FromString("#,##0.0_);(#,##0.0)");
            objCollectionNumberingFormats.Append(objNF1Decimal);
            #endregion

            #endregion Numering formats

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

            //1
            #region  #,##0.00000000 8 decimal numeric : plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF8Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //2
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //3 
            #region #,##0.00 2 decimal numeric : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //4 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //5 
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 6 
            #region custom gray background, bold with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 7 
            #region custom gray background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 8
            #region  plain background, bold with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 9 
            #region plain background, normal with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 10 
            #region Plain background, normal, gray color text with small size
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 3;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 11 
            #region plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 12 
            #region plain background, normal, underline,  blue color, center align, with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 4;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //13 
            #region #,##0.00 2 decimal numeric, light gray background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //14
            #region  #,##0.00 2 decimal numeric, light gray background , bold,right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //15 
            #region #,##0.00 2 decimal numeric, plain, bold, red color, right align, with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 5;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 16 
            #region custom gray background, bold with all borders, v-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 17 
            #region custom gray background, bold with all borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //18
            #region  numeric without comma: plain , normal, left align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //19
            #region plain background, normal, no underline, no color, center align, with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //20
            #region #,##0 no decimal : plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //21
            #region  #,##0.00#### 6 decimal numeric : plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //22
            #region plain background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //23 
            #region #,##0 no decimal numeric : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //24 
            #region #,##0 no decimal numeric : yellow background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //25 
            #region #,##0 no decimal numeric : yellow background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //26
            #region #,##0 no decimal : light gray background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //27
            #region #,##0 no decimal : light gray background , bold,right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //28
            #region #,##0.00#### 6 decimal : light gray background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //29
            #region #,##0.00#### 6 decimal : light gray background , bold,right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //30 
            #region #,##0.00 2 decimal numeric, plain, bold, red color, right align, with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 5;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //31
            #region #,##0.00 2 decimal numeric : plain , bold, right align with dashed bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 3;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //32
            #region #,##0.00 2 decimal numeric : plain , bold, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //33
            #region plain background, normal with dashed bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 3;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //34
            #region plain background, normal with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //35
            #region  #,##0.00#### 6 decimal numeric : plain , normal, right align with dashed bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 3;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //36
            #region  #,##0.00#### 6 decimal numeric : plain , normal, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //37
            #region  #,##0.00 2 decimal numeric without bracket: plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //38 
            #region #,##0.00 2 decimal numeric without bracket : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //39
            #region no decimal numeric : plain , normal, center align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //40
            #region plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNFDateTime.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //41
            #region  numeric without comma: plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //42
            #region  #,##0.0000 4 decimal numeric without bracket: plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF4DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion


            /* Arial Narrow 10 */
            //43
            #region  #,##0.00 2 decimal numeric : arial narrow 10, plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //44 
            #region #,##0.00 2 decimal numeric : arial narrow 10, plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //45
            #region arial narrow 10, custom gray background, bold with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 46 
            #region arial narrow 10, custom gray background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 47
            #region  arial narrow 10, plain background, bold with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 48 
            #region arial narrow 10, plain background, normal with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 49 
            #region arial narrow 10, plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //50
            #region #,##0.00 2 decimal numeric, arial narrow 10, light gray background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //51
            #region  #,##0.00 2 decimal numeric, arial narrow 10, light gray background , bold,right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //52
            #region arial narrow 10, custom gray background, bold with all borders, v-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 53 
            #region arial narrow 10, custom gray background, bold with all borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //54
            #region  numeric without comma: arial narrow 10, plain , normal, left align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0Decimal.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //55
            #region arial narrow 10, plain background, normal, no underline, no color, center align, with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //56
            #region arial narrow 10, plain background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //57
            #region  #,##0.00 2 decimal numeric without bracket: arial narrow 10, plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //58 
            #region #,##0.00 2 decimal numeric without bracket : arial narrow 10, plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //59
            #region arial narrow 10, plain background, bold with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNFDateTime.NumberFormatId;
            objCellFormat.FontId = 7;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Left;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //60
            #region no decimal numeric : arial narrow 10, plain , normal, center align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //61
            #region arial narrow 10, custom gray background, normal with no borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 6;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            /* end of Arial Narrow 10 */

            /* Following styles are meant for indentation*/
            // 62
            #region  plain background, bold with all borders, Indent = 1
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 1;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 63
            #region  plain background, bold with all borders, Indent = 2
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 2;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 64
            #region  plain background, bold with all borders, Indent = 3
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 3;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 65
            #region  plain background, bold with all borders, Indent = 4
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 4;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 66
            #region  plain background, bold with all borders, Indent = 5
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 5;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 67
            #region  plain background, bold with all borders, Indent = 6
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 6;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 68
            #region  plain background, bold with all borders, Indent = 7
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 7;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 69
            #region  plain background, bold with all borders, Indent = 8
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 8;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 70 
            #region plain background, normal with all borders , Indent = 1
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 1;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 71 
            #region plain background, normal with all borders , Indent = 2
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 2;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 72
            #region plain background, normal with all borders , Indent = 3
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 3;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 73
            #region plain background, normal with all borders , Indent = 4
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 4;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 74 
            #region plain background, normal with all borders , Indent = 5
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 5;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 75 
            #region plain background, normal with all borders , Indent = 6
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 6;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 76 
            #region plain background, normal with all borders , Indent = 7
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 7;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 77 
            #region plain background, normal with all borders , Indent = 8
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 8;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            /* end of styles are meant for indentation*/

            //78
            #region plain background, bold, no underline, no color, center align, with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //79
            #region custom gray background, normal with borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 2;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //80
            #region  #,##0.00#### 6 decimal numeric : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF6Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //81
            #region #,##0 no decimal : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //82
            #region plain background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //83 
            #region #,##0.00 2 decimal numeric : Light blue , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 5;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 84
            #region  Light blue background, bold with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 5;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //new additions by Lankesh Begins
            //85
            #region #,##0.00 2 decimal numeric, light yellow background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //86
            #region #,##0.00 2 decimal numeric, light yellow background, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //87
            #region #,##0 no decimal : light yellow background , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //88
            #region #,##0 no decimal : light yellow background , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //89
            #region #,##0.0 1 decimal : plain , normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //90
            #region #,##0.0 1 decimal : plain , bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //91
            #region #,##0.0 1 decimal : light yellow, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //92
            #region #,##0.0 1 decimal : light yellow, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //93
            #region #,##0.0 1 decimal : yellow, bold, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            //new additions by Lankesh Ends

            //94
            #region #,##0.0 1 decimal numeric, light gray background, normal, right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //95
            #region  #,##0.0 1 decimal numeric, light gray background , bold,right align with all borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //96
            #region  #,##0.00 2 decimal numeric without bracket: plain , normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2DecimalWithoutBracket.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //97
            #region custom green background, bold with borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 7; //custom green
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion custom green background, normal with borders, h-align center

            //98
            #region custom blue background, bold with borders, h-align center
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 8; //custom blue
            objCellFormat.BorderId = 1;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Center;
            objCellAlignment.WrapText = true;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion custom green background, normal with borders, h-align center

            /* Following styles are meant for indentation without border */
            // 99
            #region  plain background, bold with no borders, Indent = 1
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 1;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 100
            #region  plain background, bold with no borders, Indent = 2
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 2;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 101
            #region  plain background, bold with no borders, Indent = 3
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 3;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 102
            #region  plain background, bold with no borders, Indent = 4
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 4;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 103
            #region  plain background, bold with no borders, Indent = 5
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 5;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 104
            #region  plain background, bold with no borders, Indent = 6
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 6;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 105
            #region  plain background, bold with no borders, Indent = 7
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 7;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 106
            #region  plain background, bold with no borders, Indent = 8
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 8;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 107 
            #region plain background, normal with no borders , Indent = 1
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 1;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 108 
            #region plain background, normal with no borders , Indent = 2
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 2;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 109
            #region plain background, normal with no borders , Indent = 3
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 3;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 110
            #region plain background, normal with no borders , Indent = 4
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 4;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 111 
            #region plain background, normal with no borders , Indent = 5
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 5;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 112 
            #region plain background, normal with no borders , Indent = 6
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 6;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 113 
            #region plain background, normal with no borders , Indent = 7
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 7;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 114 
            #region plain background, normal with no borders , Indent = 8
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellAlignment.Indent = 8;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            /* end of styles are meant for indentation without border */

            //115
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //116 
            #region #,##0.00 2 decimal numeric : plain , bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //117 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //118 
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //119 
            #region #,##0.00 2 decimal numeric, light gray background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //120
            #region  #,##0.00 2 decimal numeric, light gray background , bold,right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            
            //121
            #region #,##0.00 2 decimal numeric, light yellow background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //122
            #region #,##0.00 2 decimal numeric, light yellow background, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //123
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //124 
            #region #,##0.00 2 decimal numeric : plain , bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //125 
            #region #,##0.00 2 decimal numeric, light gray background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //126
            #region  #,##0.00 2 decimal numeric, light gray background , bold,right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //127
            #region #,##0.00 2 decimal numeric, light yellow background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //128
            #region #,##0.00 2 decimal numeric, light yellow background, bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //129
            #region  #,##0.00 2 decimal numeric : plain , normal, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //130 
            #region #,##0.00 2 decimal numeric : plain , bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //131 
            #region #,##0.00 2 decimal numeric, light gray background, normal, right align with top and bottom  border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //132
            #region  #,##0.00 2 decimal numeric, light gray background , bold,right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //133
            #region #,##0.00 2 decimal numeric, light yellow background, normal, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //134
            #region #,##0.00 2 decimal numeric, light yellow background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion



            //135
            #region #,##0 no decimal : plain , normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //136 
            #region #,##0 no decimal numeric : plain , bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //137 
            #region #,##0 no decimal numeric : yellow background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //138 
            #region #,##0 no decimal numeric : yellow background, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //139
            #region #,##0 no decimal : light gray background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //140
            #region #,##0 no decimal : light gray background , bold,right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //141
            #region #,##0 no decimal : light yellow background , normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //142
            #region #,##0 no decimal : light yellow background , bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //143
            #region #,##0 no decimal : plain , normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //144 
            #region #,##0 no decimal numeric : plain , bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //145
            #region #,##0 no decimal : light gray background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //146
            #region #,##0 no decimal : light gray background , bold,right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //147
            #region #,##0 no decimal : light yellow background , normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //148
            #region #,##0 no decimal : light yellow background , bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //149
            #region #,##0 no decimal : plain , normal, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //150 
            #region #,##0 no decimal numeric : plain , bold, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //151
            #region #,##0 no decimal : light gray background, normal, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //152
            #region #,##0 no decimal : light gray background , bold,right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //153
            #region #,##0 no decimal : light yellow background , normal, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //154
            #region #,##0 no decimal : light yellow background , bold, right align with top and bootom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion




            //155
            #region #,##0.0 1 decimal : plain , normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //156
            #region #,##0.0 1 decimal : plain , bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //157
            #region #,##0.0 1 decimal : light yellow, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //158
            #region #,##0.0 1 decimal : light yellow, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //159
            #region #,##0.0 1 decimal : yellow, bold, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion
            //new additions by Lankesh Ends

            //160
            #region #,##0.0 1 decimal numeric, light gray background, normal, right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //161
            #region  #,##0.0 1 decimal numeric, light gray background , bold,right align with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //162
            #region #,##0.0 1 decimal : plain , normal, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //163
            #region #,##0.0 1 decimal : plain , bold, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //164
            #region #,##0.0 1 decimal : light yellow, normal, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //165
            #region #,##0.0 1 decimal : light yellow, bold, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //166
            #region #,##0.0 1 decimal numeric, light gray background, normal, right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //167
            #region  #,##0.0 1 decimal numeric, light gray background , bold,right align with top borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //168
            #region #,##0.0 1 decimal : plain , normal, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //169
            #region #,##0.0 1 decimal : plain , bold, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 0; //plain
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //170
            #region #,##0.0 1 decimal : light yellow, normal, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1; //normal
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //171
            #region #,##0.0 1 decimal : light yellow, bold, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 6; //light yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //172
            #region #,##0.0 1 decimal numeric, light gray background, normal, right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //173
            #region  #,##0.0 1 decimal numeric, light gray background , bold,right align with top and bottom borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 4;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 174
            #region  plain background, bold with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 175 
            #region plain background, normal with no borders
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.WrapText = BooleanValue.FromBoolean(true);
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //176
            #region plain background, normal, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //177
            #region plain background, bold, right align with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            // 178 
            #region plain background, normal, underline,  blue color, center align, with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 4;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //179
            #region plain background, normal, no underline, no color, center align, with no border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = nfForcedText.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 0;
            objCellFormat.BorderId = 0;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(false);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Center;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //180 
            #region #,##0 no decimal numeric : yellow background, bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //181 
            #region #,##0 no decimal numeric : yellow background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //182 
            #region #,##0 no decimal numeric : yellow background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //183 
            #region #,##0 no decimal numeric : yellow background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF0DecimalWithComma.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //184
            #region #,##0.0 1 decimal : yellow, bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //185
            #region #,##0.0 1 decimal : yellow, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF1Decimal.NumberFormatId;
            objCellFormat.FontId = 2; //bold
            objCellFormat.FillId = 3; //yellow
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //186 
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //187 
            #region #,##0.00 2 decimal numeric : yellow background, bold, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 2;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //188 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with top border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 4;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion

            //189 
            #region #,##0.00 2 decimal numeric : yellow background, normal, right align with top and bottom border
            objCellFormat = new CellFormat();
            objCellFormat.NumberFormatId = objNF2Decimal.NumberFormatId;
            objCellFormat.FontId = 1;
            objCellFormat.FillId = 3;
            objCellFormat.BorderId = 2;
            objCellFormat.FormatId = 0;
            objCellFormat.ApplyNumberFormat = BooleanValue.FromBoolean(true);
            objCellAlignment = new Alignment();
            objCellAlignment.Horizontal = HorizontalAlignmentValues.Right;
            objCellAlignment.Vertical = VerticalAlignmentValues.Bottom;
            objCellFormat.Alignment = objCellAlignment;
            objCellFormat.ApplyAlignment = BooleanValue.FromBoolean(true);
            objCollectionCellFormats.Append(objCellFormat);
            #endregion





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
