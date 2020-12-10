using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace InsiderTradingExcelWriter.ExcelFacade
{
    public class ConstantEnum1
    {
        #region OpenXMLStyleIndex
        public sealed class OpenXMLStyleIndex
        {
            public const int DEFAULT_NO_STYLE = 0;

            #region Text Styles
            public const int TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS = 6;
            public const int TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 7;
            public const int TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_V_ALIGN_CENTER_WITH_BORDERS = 16;

            public const int TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS = 17;
            public const int TEXT_CUSTOM_GRAY_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS = 79;

            public const int TEXT_CUSTOM_GREEN_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS = 97;

            public const int TEXT_CUSTOM_BLUE_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS = 98;

            public const int TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS = 8;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS = 78;

            public const int TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS = 9;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_GRAY_COLOR_TEXT_WITH_SMALL_SIZE = 10;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS = 19;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 22;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_WITH_DASHED_BOOTOM_BORDER = 33;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 82;

            public const int TEXT_LIGHT_BLUE_BACKGROUND_BOLD_WITH_BORDERS = 84;

            #region Text styles with Indentation
            public const int TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_1 = 62;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_2 = 63;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_3 = 64;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_4 = 65;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_5 = 66;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_6 = 67;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_7 = 68;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS_INDENT_8 = 69;

            public const int TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_1 = 70;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_2 = 71;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_3 = 72;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_4 = 73;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_5 = 74;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_6 = 75;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_7 = 76;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS_INDENT_8 = 77;
            #endregion // Text styles with Indentation

            public const int TEXT_PLAIN_BACKGROUND_BOLD_WITH_NO_BORDER = 11;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_WITH_NO_BORDER = 34;

            #region Text styles with no border with indentation
            public const int TEXT_PLAIN_BACKGROUND_BOLD_INDENT_1 = 99;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_INDENT_2 = 100;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_INDENT_3 = 101;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_INDENT_4 = 102;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_INDENT_5 = 103;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_INDENT_6 = 104;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_INDENT_7 = 105;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_INDENT_8 = 106;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_NO_IDENT = 174;

            public const int TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_1 = 107;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_2 = 108;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_3 = 109;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_4 = 110;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_5 = 111;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_6 = 112;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_7 = 113;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_INDENT_8 = 114;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_NO_IDENT = 175;
            #endregion // Text styles with no border with indentation

            public const int TEXT_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN = 176;
            public const int TEXT_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN = 177;
            public const int TEXT_PLAIN_BACKGROUND_NORMAL_CENTER_ALIGN = 179;

            #region Arial Narrow 10
            public const int ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_WITH_BORDERS = 45;
            public const int ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 46;
            public const int ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_BORDERS = 47;
            public const int ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_WITH_BORDERS = 48;
            public const int ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_BOLD_WITH_NO_BORDER = 49;
            public const int ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_V_ALIGN_CENTER_WITH_BORDERS = 52;
            public const int ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_BOLD_CENTER_ALIGN_WITH_BORDERS = 53;
            public const int ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS = 55;
            public const int ARIAL_NARROW_10_TEXT_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 56;
            public const int ARIAL_NARROW_10_TEXT_CUSTOM_GRAY_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS = 61;
            #endregion // Arial Narrow 10

            /*Link for both text and numeric*/
            public const int LINK_PLAIN_BACKGROUND_NORMAL_UNDERLINE_BLUE_COLOR_CENTER_ALIGN_WITH_BORDERS = 12;
            public const int LINK_PLAIN_BACKGROUND_NORMAL_UNDERLINE_BLUE_COLOR_CENTER_ALIGN = 178;
            #endregion // Text Styles

            #region Numeric styles
            #region no decimal with border
            public const int NO_DECIMAL_NUMERIC_WITHOUT_COMMA_PLAIN_BACKGROUND_NORMAL_LEFT_ALIGN_WITH_BORDERS = 18;
            public const int NO_DECIMAL_NUMERIC_WITHOUT_COMMA_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 41;

            public const int NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 23;
            public const int NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS = 39;

            public const int NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 24;
            public const int NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 25;

            public const int NO_DECIMAL_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 26;
            public const int NO_DECIMAL_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 27;

            public const int NO_DECIMAL_NUMERIC_WITH_THOUSAND_SEPARATOR_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 20;
            public const int NO_DECIMAL_NUMERIC_WITH_THOUSAND_SEPARATOR_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 81;

            //new additions by Lankesh Begins
            public const int NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_ALL_BORDERS = 87;
            public const int NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS = 88;
            //new additions by Lankesh Ends

            /* Arial Narrow 10 */
            public const int ARIAL_NARROW_10_NO_DECIMAL_NUMERIC_WITHOUT_COMMA_PLAIN_BACKGROUND_NORMAL_LEFT_ALIGN_WITH_BORDERS = 54;
            public const int ARIAL_NARROW_10_NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_CENTER_ALIGN_WITH_BORDERS = 60;
            /* Arial Narrow 10 */
            #endregion // no decimal with border

            #region No decimal with no border
            public const int NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN = 135;
            public const int NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN = 136;

            public const int NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN = 137;
            public const int NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN = 138;

            public const int NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN = 139;
            public const int NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN = 140;

            public const int NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN = 141;
            public const int NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN = 142;
            #endregion // No decimal with no border

            #region No decimal with top border
            public const int NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER = 143;
            public const int NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 144;

            public const int NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 180;
            public const int NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER = 182;

            public const int NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER = 145;
            public const int NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 146;

            public const int NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER = 147;
            public const int NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 148;
            #endregion // No decimal with top border

            #region No decimal with top and bootom border
            public const int NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 149;
            public const int NO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 150;

            public const int NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 181;
            public const int NO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 183;

            public const int NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 151;
            public const int NO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 152;

            public const int NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 153;
            public const int NO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 154;
            #endregion // No decimal with top and bootom border


            #region 1 decimal with border
            //new additions by Lankesh Begins
            public const int ONE_DECIMAL_NUMERIC_PLAIN_NORMAL_RIGHT_ALIGN_WITH_ALL_BORDERS = 89;
            public const int ONE_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS = 90;

            public const int ONE_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS = 93;

            public const int ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 94;
            public const int ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 95;

            public const int ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_ALL_BORDERS = 91;
            public const int ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS = 92;
            //new additions by Lankesh Ends
            #endregion // 1 decimal with border

            #region 1 decimal with no border
            public const int ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN = 155;
            public const int ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN = 156;

            public const int ONE_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN = 159;

            public const int ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN = 160;
            public const int ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN = 161;

            public const int ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN = 157;
            public const int ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN = 158;
            #endregion // 1 decimal with no border

            #region 1 decimal with top border
            public const int ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER = 162;
            public const int ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 163;

            public const int ONE_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 184;

            public const int ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER = 166;
            public const int ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 167;

            public const int ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER = 164;
            public const int ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 165;
            #endregion // 1 decimal with top border

            #region 1 decimal with top and bottom border
            public const int ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 168;
            public const int ONE_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 169;

            public const int ONE_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 185;

            public const int ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 172;
            public const int ONE_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 173;

            public const int ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 170;
            public const int ONE_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 171;
            #endregion // 1 decimal with top and bottom border


            #region 2 decimal with border
            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 2;
            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 3;

            public const int TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 4;
            public const int TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 5;

            public const int TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 13;
            public const int TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 14;

            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RED_COLOR_RIGHT_ALIGN_WITH_NO_BORDER = 15;
            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RED_COLOR_RIGHT_ALIGN_WITH_BORDERS = 30;

            public const int TWO_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_DASHED_BOTTOM_BORDER = 31;


            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS_WITHOUT_BRACKET = 37;
            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS_WITHOUT_BRACKET = 38;

            public const int TWO_DECIMAL_NUMERIC_LIGHT_BLUE_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 83;

            //new additions by Lankesh Begins
            public const int TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_ALL_BORDERS = 85;
            public const int TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_ALL_BORDERS = 86;

            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITHOUT_BORDERS_WITH_NO_BRACKET = 96;
            //new additions by Lankesh Ends
            #endregion // 2 decimal with border

            #region 2 decimal with no border
            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN = 115;
            public const int TWO_DECIMAL_NUMERIC_PLAIN_BOLD_RIGHT_ALIGN_WITH_NO_BORDER = 32;

            //check for this
            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN = 116;

            public const int TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN = 117;
            public const int TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN = 118;

            public const int TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN = 119;
            public const int TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN = 120;

            public const int TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN = 121;
            public const int TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN = 122;
            #endregion // 2 decimal with no border

            #region 2 decimal with top border
            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER = 123;
            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 124;

            public const int TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 186;
            public const int TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER = 188;

            public const int TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER = 125;
            public const int TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 126;

            public const int TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BORDER = 127;
            public const int TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BORDER = 128;
            #endregion // 2 decimal with top border

            #region 2 decimal with top and bottom border
            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 129;
            public const int TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 130;

            public const int TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 187;
            public const int TWO_DECIMAL_NUMERIC_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 189;

            public const int TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 131;
            public const int TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 132;

            public const int TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_NORMAL_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 133;
            public const int TWO_DECIMAL_NUMERIC_LIGHT_YELLOW_BACKGROUND_BOLD_RIGHT_ALIGN_TOP_BOTTOM_BORDER = 134;
            #endregion // 2 decimal with top and bottom border

            #region Arial Narrow 10 with border
            public const int ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 43;
            public const int ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 44;

            public const int ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 50;
            public const int ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 51;

            public const int ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS_WITHOUT_BRACKET = 57;
            public const int ARIAL_NARROW_10_TWO_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS_WITHOUT_BRACKET = 58;
            #endregion // Arial Narrow 10 with border

            //4 decimal with border
            public const int FOUR_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS_WITHOUT_BRACKET = 42;

            #region 6 decimal with border
            public const int SIX_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 21;
            public const int SIX_DECIMAL_NUMERIC_PLAIN_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 80;

            public const int SIX_DECIMAL_LIGHT_GRAY_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 28;
            public const int SIX_DECIMAL_LIGHT_GRAY_BACKGROUND_BOLD_RIGHT_ALIGN_WITH_BORDERS = 29;

            public const int SIX_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_DASHED_BOTTOM_BORDERS = 35;
            public const int SIX_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_NO_BORDERS = 36;
            #endregion // 6 decimal with border

            //8 decimal with border
            public const int EIGHT_DECIMAL_NUMERIC_PLAIN_BACKGROUND_NORMAL_RIGHT_ALIGN_WITH_BORDERS = 1;
            #endregion // Numeric styles

            //DateTime
            public const int DATETIME_PLAIN_BACKGROUND_BOLD_LEFT_ALIGN_WITH_NO_BORDERS_dd_mm_yyyy_h_mm_AM_PM = 40;

            /* Arial Narrow 10 */
            public const int ARIAL_NARROW_10_DATETIME_PLAIN_BACKGROUND_BOLD_LEFT_ALIGN_WITH_NO_BORDERS_dd_mm_yyyy_h_mm_AM_PM = 59;
            /* Arial Narrow 10 */
        }
        #endregion // OpenXMLStyleIndex

        #region PaperSize
        public sealed class PaperSize
        {
            public const uint LETTER_PAPER = 1; //Letter paper (8.5 in. by 11 in.)
            public const uint LETTER_SMALL_PAPER = 2;// = Letter small paper (8.5 in. by 11 in.)
            public const uint TABLOID_PAPER = 3;// = Tabloid paper (11 in. by 17 in.)
            public const uint LEDGER_PAPER = 4;// = Ledger paper (17 in. by 11 in.)
            public const uint LEGAL_PAPER = 5;// = Legal paper (8.5 in. by 14 in.)
            public const uint STATEMENT_PAPER = 6;// = Statement paper (5.5 in. by 8.5 in.)
            public const uint EXECUTIVE_PAPER = 7;// = Executive paper (7.25 in. by 10.5 in.)
            public const uint A3_PAPER = 8;// = A3 paper (297 mm by 420 mm)
            public const uint A4_PAPER = 9;// = A4 paper (210 mm by 297 mm)
            public const uint A4_SMALL_PAPER = 10;// = A4 small paper (210 mm by 297 mm)
            public const uint A5_PAPER = 11;// = A5 paper (148 mm by 210 mm)
            public const uint B4_PAPER = 12;// = B4 paper (250 mm by 353 mm)
            public const uint B5_PAPER = 13;// = B5 paper (176 mm by 250 mm)
            public const uint FOLIO_PAPER = 14;// = Folio paper (8.5 in. by 13 in.)
            public const uint QUARTO_PAPER = 15;// = Quarto paper (215 mm by 275 mm)
            public const uint STANDARD_PAPER_10_14 = 16;// = Standard paper (10 in. by 14 in.)
            public const uint STANDARD_PAPER_11_17 = 17;// = Standard paper (11 in. by 17 in.)
            public const uint NOTE_PAPER = 18;// = Note paper (8.5 in. by 11 in.)
            public const uint ENVELOPE_3_8 = 19;// = #9 envelope (3.875 in. by 8.875 in.)
            public const uint ENVELOPE_4_9 = 20;// = #10 envelope (4.125 in. by 9.5 in.)
            public const uint ENVELOPE_4_10 = 21;// = #11 envelope (4.5 in. by 10.375 in.)
            public const uint ENVELOPE_4_11_8 = 22;// = #12 envelope (4.75 in. by 11 in.)
            public const uint ENVELOPE_5_11 = 23;// = #14 envelope (5 in. by 11.5 in.)
            public const uint C_PAPER = 24;// = C paper (17 in. by 22 in.)
            public const uint D_PAPER = 25;// = D paper (22 in. by 34 in.)
            public const uint E_PAPER = 26;// = E paper (34 in. by 44 in.)
            public const uint DL_ENVELOPE = 27;// = DL envelope (110 mm by 220 mm)
            public const uint C5_ENVELOPE = 28;// = C5 envelope (162 mm by 229 mm)
            public const uint C3_ENVELOPE = 29;// = C3 envelope (324 mm by 458 mm)
            public const uint C4_ENVELOPE = 30;// = C4 envelope (229 mm by 324 mm)
            public const uint C6_ENVELOPE = 31;// = C6 envelope (114 mm by 162 mm)
            public const uint C65_ENVELOPE = 32;// = C65 envelope (114 mm by 229 mm)
            public const uint B4_ENVELOPE = 33;// = B4 envelope (250 mm by 353 mm)
            public const uint B5_ENVELOPE = 34;// = B5 envelope (176 mm by 250 mm)
            public const uint B6_ENVELOPE = 35;// = B6 envelope (176 mm by 125 mm)
            public const uint ITALY_ENVELOPE = 36;// = Italy envelope (110 mm by 230 mm)
            public const uint MONARCH_ENVELOPE = 37;// = Monarch envelope (3.875 in. by 7.5 in.).
            public const uint ENVELOPE_6_3_BY_4 = 38;// = 6 3/4 envelope (3.625 in. by 6.5 in.)
            public const uint US_STANDARD_FANFOLD = 39;// = US standard fanfold (14.875 in. by 11 in.)
            public const uint GERMAN_STANDARD_FANFOLD = 40;// = German standard fanfold (8.5 in. by 12 in.)
            public const uint US_LEGAL_FANFOLD = 41;// = German legal fanfold (8.5 in. by 13 in.)
            public const uint ISO_B4 = 42;// = ISO B4 (250 mm by 353 mm)
            public const uint JAPANESE_DOUBLE_POSTCARD = 43;// = Japanese double postcard (200 mm by 148 mm)
            public const uint STANDARD_PAPER_9_11 = 44;// = Standard paper (9 in. by 11 in.)
            public const uint STANDARD_PAPER_10_11 = 45;// = Standard paper (10 in. by 11 in.)
            public const uint STANDARD_PAPER_15_11 = 46;// = Standard paper (15 in. by 11 in.)
            public const uint INVITE_ENVELOPE = 47;// = Invite envelope (220 mm by 220 mm)
            public const uint LETTER_EXTRA_PAPER = 50;// = Letter extra paper (9.275 in. by 12 in.)
            public const uint LEGAL_EXTRA_PAPER = 51;// = Legal extra paper (9.275 in. by 15 in.)
            public const uint TABLOID_EXTRA_PAPER = 52;// = Tabloid extra paper (11.69 in. by 18 in.)
            public const uint A4_EXTRA_PAPER = 53;// = A4 extra paper (236 mm by 322 mm)
            public const uint LETTER_TRANSVERSE_PAPER = 54;// = Letter transverse paper (8.275 in. by 11 in.)
            public const uint A4_TRANSVERSE_PAPER = 55;// = A4 transverse paper (210 mm by 297 mm)
            public const uint LETTER_EXTRA_TRANSVERSE_PAPER = 56;// = Letter extra transverse paper (9.275 in. by 12 in.)
            public const uint SUPERA_A4_PAPER = 57;// = SuperA/SuperA/A4 paper (227 mm by 356 mm)
            public const uint SUPERB_A3_PAPER = 58;// = SuperB/SuperB/A3 paper (305 mm by 487 mm)
            public const uint LETTER_PLUS_PAPER = 59;// = Letter plus paper (8.5 in. by 12.69 in.)
            public const uint A4_PLUS_PAPER = 60;// = A4 plus paper (210 mm by 330 mm)
            public const uint A5_TRANSVERSE_PAPER = 61;// = A5 transverse paper (148 mm by 210 mm)
            public const uint JIS_B5_TRANSVERSE_PAPER = 62;// = JIS B5 transverse paper (182 mm by 257 mm)
            public const uint A3_EXTRA_PAPER = 63;// = A3 extra paper (322 mm by 445 mm)
            public const uint A5_EXTRA_PAPER = 64;// = A5 extra paper (174 mm by 235 mm)
            public const uint ISO_B5_EXTRA_PAPER = 65;// = ISO B5 extra paper (201 mm by 276 mm)
            public const uint A2_PAPER = 66;// = A2 paper (420 mm by 594 mm)
            public const uint A3_TRANSVERSE_PAPER = 67;// = A3 transverse paper (297 mm by 420 mm)
            public const uint A3_EXTRA_TRANSVERSE_PAPER = 68;// = A3 extra transverse paper (322 mm by 445 mm)
        }
        #endregion// PaperSize
    }
}
