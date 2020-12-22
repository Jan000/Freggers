package flashx.textLayout.formats
{
   import flash.text.engine.BreakOpportunity;
   import flash.text.engine.CFFHinting;
   import flash.text.engine.DigitCase;
   import flash.text.engine.DigitWidth;
   import flash.text.engine.FontLookup;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.JustificationStyle;
   import flash.text.engine.Kerning;
   import flash.text.engine.LigatureLevel;
   import flash.text.engine.RenderingMode;
   import flash.text.engine.TextBaseline;
   import flash.text.engine.TextRotation;
   import flashx.textLayout.property.BooleanProperty;
   import flashx.textLayout.property.EnumStringProperty;
   import flashx.textLayout.property.IntWithEnumProperty;
   import flashx.textLayout.property.NumberOrPercentOrEnumProperty;
   import flashx.textLayout.property.NumberOrPercentProperty;
   import flashx.textLayout.property.NumberProperty;
   import flashx.textLayout.property.NumberWithEnumProperty;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.property.StringProperty;
   import flashx.textLayout.property.TabStopsProperty;
   import flashx.textLayout.property.UintProperty;
   import flashx.textLayout.property.UintWithEnumProperty;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TextLayoutFormat implements ITextLayoutFormat
   {
      
      private static var _colorProperty:UintProperty = new UintProperty("color",0,true,Category.CHARACTER);
      
      private static var _backgroundColorProperty:UintWithEnumProperty = new UintWithEnumProperty("backgroundColor",BackgroundColor.TRANSPARENT,false,Category.CHARACTER,BackgroundColor.TRANSPARENT);
      
      private static var _lineThroughProperty:BooleanProperty = new BooleanProperty("lineThrough",false,true,Category.CHARACTER);
      
      private static var _textAlphaProperty:NumberProperty = new NumberProperty("textAlpha",1,true,Category.CHARACTER,0,1);
      
      private static var _backgroundAlphaProperty:NumberProperty = new NumberProperty("backgroundAlpha",1,false,Category.CHARACTER,0,1);
      
      private static var _fontSizeProperty:NumberProperty = new NumberProperty("fontSize",12,true,Category.CHARACTER,1,720);
      
      private static var _baselineShiftProperty:NumberOrPercentOrEnumProperty = new NumberOrPercentOrEnumProperty("baselineShift",0,true,Category.CHARACTER,-1000,1000,"-1000%","1000%",BaselineShift.SUPERSCRIPT,BaselineShift.SUBSCRIPT);
      
      private static var _trackingLeftProperty:NumberOrPercentProperty = new NumberOrPercentProperty("trackingLeft",0,true,Category.CHARACTER,-1000,1000,"-1000%","1000%");
      
      private static var _trackingRightProperty:NumberOrPercentProperty = new NumberOrPercentProperty("trackingRight",0,true,Category.CHARACTER,-1000,1000,"-1000%","1000%");
      
      private static var _lineHeightProperty:NumberOrPercentProperty = new NumberOrPercentProperty("lineHeight","120%",true,Category.CHARACTER,-720,720,"-1000%","1000%");
      
      private static var _breakOpportunityProperty:EnumStringProperty = new EnumStringProperty("breakOpportunity",BreakOpportunity.AUTO,true,Category.CHARACTER,BreakOpportunity.ALL,BreakOpportunity.ANY,BreakOpportunity.AUTO,BreakOpportunity.NONE);
      
      private static var _digitCaseProperty:EnumStringProperty = new EnumStringProperty("digitCase",DigitCase.DEFAULT,true,Category.CHARACTER,DigitCase.DEFAULT,DigitCase.LINING,DigitCase.OLD_STYLE);
      
      private static var _digitWidthProperty:EnumStringProperty = new EnumStringProperty("digitWidth",DigitWidth.DEFAULT,true,Category.CHARACTER,DigitWidth.DEFAULT,DigitWidth.PROPORTIONAL,DigitWidth.TABULAR);
      
      private static var _dominantBaselineProperty:EnumStringProperty = new EnumStringProperty("dominantBaseline",FormatValue.AUTO,true,Category.CHARACTER,FormatValue.AUTO,TextBaseline.ROMAN,TextBaseline.ASCENT,TextBaseline.DESCENT,TextBaseline.IDEOGRAPHIC_TOP,TextBaseline.IDEOGRAPHIC_CENTER,TextBaseline.IDEOGRAPHIC_BOTTOM);
      
      private static var _kerningProperty:EnumStringProperty = new EnumStringProperty("kerning",Kerning.AUTO,true,Category.CHARACTER,Kerning.ON,Kerning.OFF,Kerning.AUTO);
      
      private static var _ligatureLevelProperty:EnumStringProperty = new EnumStringProperty("ligatureLevel",LigatureLevel.COMMON,true,Category.CHARACTER,LigatureLevel.MINIMUM,LigatureLevel.COMMON,LigatureLevel.UNCOMMON,LigatureLevel.EXOTIC);
      
      private static var _alignmentBaselineProperty:EnumStringProperty = new EnumStringProperty("alignmentBaseline",TextBaseline.USE_DOMINANT_BASELINE,true,Category.CHARACTER,TextBaseline.ROMAN,TextBaseline.ASCENT,TextBaseline.DESCENT,TextBaseline.IDEOGRAPHIC_TOP,TextBaseline.IDEOGRAPHIC_CENTER,TextBaseline.IDEOGRAPHIC_BOTTOM,TextBaseline.USE_DOMINANT_BASELINE);
      
      private static var _localeProperty:StringProperty = new StringProperty("locale","en",true,Category.CHARACTER);
      
      private static var _typographicCaseProperty:EnumStringProperty = new EnumStringProperty("typographicCase",TLFTypographicCase.DEFAULT,true,Category.CHARACTER,TLFTypographicCase.DEFAULT,TLFTypographicCase.CAPS_TO_SMALL_CAPS,TLFTypographicCase.UPPERCASE,TLFTypographicCase.LOWERCASE,TLFTypographicCase.LOWERCASE_TO_SMALL_CAPS);
      
      private static var _fontFamilyProperty:StringProperty = new StringProperty("fontFamily","Arial",true,Category.CHARACTER);
      
      private static var _textDecorationProperty:EnumStringProperty = new EnumStringProperty("textDecoration",TextDecoration.NONE,true,Category.CHARACTER,TextDecoration.NONE,TextDecoration.UNDERLINE);
      
      private static var _fontWeightProperty:EnumStringProperty = new EnumStringProperty("fontWeight",FontWeight.NORMAL,true,Category.CHARACTER,FontWeight.NORMAL,FontWeight.BOLD);
      
      private static var _fontStyleProperty:EnumStringProperty = new EnumStringProperty("fontStyle",FontPosture.NORMAL,true,Category.CHARACTER,FontPosture.NORMAL,FontPosture.ITALIC);
      
      private static var _whiteSpaceCollapseProperty:EnumStringProperty = new EnumStringProperty("whiteSpaceCollapse",WhiteSpaceCollapse.COLLAPSE,true,Category.CHARACTER,WhiteSpaceCollapse.PRESERVE,WhiteSpaceCollapse.COLLAPSE);
      
      private static var _renderingModeProperty:EnumStringProperty = new EnumStringProperty("renderingMode",RenderingMode.CFF,true,Category.CHARACTER,RenderingMode.NORMAL,RenderingMode.CFF);
      
      private static var _cffHintingProperty:EnumStringProperty = new EnumStringProperty("cffHinting",CFFHinting.HORIZONTAL_STEM,true,Category.CHARACTER,CFFHinting.NONE,CFFHinting.HORIZONTAL_STEM);
      
      private static var _fontLookupProperty:EnumStringProperty = new EnumStringProperty("fontLookup",FontLookup.DEVICE,true,Category.CHARACTER,FontLookup.DEVICE,FontLookup.EMBEDDED_CFF);
      
      private static var _textRotationProperty:EnumStringProperty = new EnumStringProperty("textRotation",TextRotation.AUTO,true,Category.CHARACTER,TextRotation.ROTATE_0,TextRotation.ROTATE_180,TextRotation.ROTATE_270,TextRotation.ROTATE_90,TextRotation.AUTO);
      
      private static var _textIndentProperty:NumberProperty = new NumberProperty("textIndent",0,true,Category.PARAGRAPH,-1000,1000);
      
      private static var _paragraphStartIndentProperty:NumberProperty = new NumberProperty("paragraphStartIndent",0,true,Category.PARAGRAPH,0,1000);
      
      private static var _paragraphEndIndentProperty:NumberProperty = new NumberProperty("paragraphEndIndent",0,true,Category.PARAGRAPH,0,1000);
      
      private static var _paragraphSpaceBeforeProperty:NumberProperty = new NumberProperty("paragraphSpaceBefore",0,true,Category.PARAGRAPH,0,1000);
      
      private static var _paragraphSpaceAfterProperty:NumberProperty = new NumberProperty("paragraphSpaceAfter",0,true,Category.PARAGRAPH,0,1000);
      
      private static var _textAlignProperty:EnumStringProperty = new EnumStringProperty("textAlign",TextAlign.START,true,Category.PARAGRAPH,TextAlign.LEFT,TextAlign.RIGHT,TextAlign.CENTER,TextAlign.JUSTIFY,TextAlign.START,TextAlign.END);
      
      private static var _textAlignLastProperty:EnumStringProperty = new EnumStringProperty("textAlignLast",TextAlign.START,true,Category.PARAGRAPH,TextAlign.LEFT,TextAlign.RIGHT,TextAlign.CENTER,TextAlign.JUSTIFY,TextAlign.START,TextAlign.END);
      
      private static var _textJustifyProperty:EnumStringProperty = new EnumStringProperty("textJustify",TextJustify.INTER_WORD,true,Category.PARAGRAPH,TextJustify.INTER_WORD,TextJustify.DISTRIBUTE);
      
      private static var _justificationRuleProperty:EnumStringProperty = new EnumStringProperty("justificationRule",FormatValue.AUTO,true,Category.PARAGRAPH,JustificationRule.EAST_ASIAN,JustificationRule.SPACE,FormatValue.AUTO);
      
      private static var _justificationStyleProperty:EnumStringProperty = new EnumStringProperty("justificationStyle",FormatValue.AUTO,true,Category.PARAGRAPH,JustificationStyle.PRIORITIZE_LEAST_ADJUSTMENT,JustificationStyle.PUSH_IN_KINSOKU,JustificationStyle.PUSH_OUT_ONLY,FormatValue.AUTO);
      
      private static var _directionProperty:EnumStringProperty = new EnumStringProperty("direction",Direction.LTR,true,Category.PARAGRAPH,Direction.LTR,Direction.RTL);
      
      private static var _tabStopsProperty:TabStopsProperty = new TabStopsProperty("tabStops",null,true,Category.PARAGRAPH);
      
      private static var _leadingModelProperty:EnumStringProperty = new EnumStringProperty("leadingModel",LeadingModel.AUTO,true,Category.PARAGRAPH,LeadingModel.ROMAN_UP,LeadingModel.IDEOGRAPHIC_TOP_UP,LeadingModel.IDEOGRAPHIC_CENTER_UP,LeadingModel.IDEOGRAPHIC_TOP_DOWN,LeadingModel.IDEOGRAPHIC_CENTER_DOWN,LeadingModel.APPROXIMATE_TEXT_FIELD,LeadingModel.ASCENT_DESCENT_UP,LeadingModel.AUTO);
      
      private static var _columnGapProperty:NumberProperty = new NumberProperty("columnGap",20,false,Category.CONTAINER,0,1000);
      
      private static var _paddingLeftProperty:NumberProperty = new NumberProperty("paddingLeft",0,false,Category.CONTAINER,0,1000);
      
      private static var _paddingTopProperty:NumberProperty = new NumberProperty("paddingTop",0,false,Category.CONTAINER,0,1000);
      
      private static var _paddingRightProperty:NumberProperty = new NumberProperty("paddingRight",0,false,Category.CONTAINER,0,1000);
      
      private static var _paddingBottomProperty:NumberProperty = new NumberProperty("paddingBottom",0,false,Category.CONTAINER,0,1000);
      
      private static var _columnCountProperty:IntWithEnumProperty = new IntWithEnumProperty("columnCount",FormatValue.AUTO,false,Category.CONTAINER,1,50,FormatValue.AUTO);
      
      private static var _columnWidthProperty:NumberWithEnumProperty = new NumberWithEnumProperty("columnWidth",FormatValue.AUTO,false,Category.CONTAINER,0,8000,FormatValue.AUTO);
      
      private static var _firstBaselineOffsetProperty:NumberWithEnumProperty = new NumberWithEnumProperty("firstBaselineOffset",BaselineOffset.AUTO,true,Category.CONTAINER,0,1000,BaselineOffset.AUTO,BaselineOffset.ASCENT,BaselineOffset.LINE_HEIGHT);
      
      private static var _verticalAlignProperty:EnumStringProperty = new EnumStringProperty("verticalAlign",VerticalAlign.TOP,false,Category.CONTAINER,VerticalAlign.TOP,VerticalAlign.MIDDLE,VerticalAlign.BOTTOM,VerticalAlign.JUSTIFY);
      
      private static var _blockProgressionProperty:EnumStringProperty = new EnumStringProperty("blockProgression",BlockProgression.TB,true,Category.CONTAINER,BlockProgression.RL,BlockProgression.TB);
      
      private static var _lineBreakProperty:EnumStringProperty = new EnumStringProperty("lineBreak",LineBreak.TO_FIT,false,Category.CONTAINER,LineBreak.EXPLICIT,LineBreak.TO_FIT);
      
      private static var _description:Object = {
         "color":_colorProperty,
         "backgroundColor":_backgroundColorProperty,
         "lineThrough":_lineThroughProperty,
         "textAlpha":_textAlphaProperty,
         "backgroundAlpha":_backgroundAlphaProperty,
         "fontSize":_fontSizeProperty,
         "baselineShift":_baselineShiftProperty,
         "trackingLeft":_trackingLeftProperty,
         "trackingRight":_trackingRightProperty,
         "lineHeight":_lineHeightProperty,
         "breakOpportunity":_breakOpportunityProperty,
         "digitCase":_digitCaseProperty,
         "digitWidth":_digitWidthProperty,
         "dominantBaseline":_dominantBaselineProperty,
         "kerning":_kerningProperty,
         "ligatureLevel":_ligatureLevelProperty,
         "alignmentBaseline":_alignmentBaselineProperty,
         "locale":_localeProperty,
         "typographicCase":_typographicCaseProperty,
         "fontFamily":_fontFamilyProperty,
         "textDecoration":_textDecorationProperty,
         "fontWeight":_fontWeightProperty,
         "fontStyle":_fontStyleProperty,
         "whiteSpaceCollapse":_whiteSpaceCollapseProperty,
         "renderingMode":_renderingModeProperty,
         "cffHinting":_cffHintingProperty,
         "fontLookup":_fontLookupProperty,
         "textRotation":_textRotationProperty,
         "textIndent":_textIndentProperty,
         "paragraphStartIndent":_paragraphStartIndentProperty,
         "paragraphEndIndent":_paragraphEndIndentProperty,
         "paragraphSpaceBefore":_paragraphSpaceBeforeProperty,
         "paragraphSpaceAfter":_paragraphSpaceAfterProperty,
         "textAlign":_textAlignProperty,
         "textAlignLast":_textAlignLastProperty,
         "textJustify":_textJustifyProperty,
         "justificationRule":_justificationRuleProperty,
         "justificationStyle":_justificationStyleProperty,
         "direction":_directionProperty,
         "tabStops":_tabStopsProperty,
         "leadingModel":_leadingModelProperty,
         "columnGap":_columnGapProperty,
         "paddingLeft":_paddingLeftProperty,
         "paddingTop":_paddingTopProperty,
         "paddingRight":_paddingRightProperty,
         "paddingBottom":_paddingBottomProperty,
         "columnCount":_columnCountProperty,
         "columnWidth":_columnWidthProperty,
         "firstBaselineOffset":_firstBaselineOffsetProperty,
         "verticalAlign":_verticalAlignProperty,
         "blockProgression":_blockProgressionProperty,
         "lineBreak":_lineBreakProperty
      };
      
      private static var _emptyTextLayoutFormat:ITextLayoutFormat;
      
      private static var _defaults:TextLayoutFormat;
       
      
      private var _color;
      
      private var _backgroundColor;
      
      private var _lineThrough;
      
      private var _textAlpha;
      
      private var _backgroundAlpha;
      
      private var _fontSize;
      
      private var _baselineShift;
      
      private var _trackingLeft;
      
      private var _trackingRight;
      
      private var _lineHeight;
      
      private var _breakOpportunity;
      
      private var _digitCase;
      
      private var _digitWidth;
      
      private var _dominantBaseline;
      
      private var _kerning;
      
      private var _ligatureLevel;
      
      private var _alignmentBaseline;
      
      private var _locale;
      
      private var _typographicCase;
      
      private var _fontFamily;
      
      private var _textDecoration;
      
      private var _fontWeight;
      
      private var _fontStyle;
      
      private var _whiteSpaceCollapse;
      
      private var _renderingMode;
      
      private var _cffHinting;
      
      private var _fontLookup;
      
      private var _textRotation;
      
      private var _textIndent;
      
      private var _paragraphStartIndent;
      
      private var _paragraphEndIndent;
      
      private var _paragraphSpaceBefore;
      
      private var _paragraphSpaceAfter;
      
      private var _textAlign;
      
      private var _textAlignLast;
      
      private var _textJustify;
      
      private var _justificationRule;
      
      private var _justificationStyle;
      
      private var _direction;
      
      private var _tabStops;
      
      private var _leadingModel;
      
      private var _columnGap;
      
      private var _paddingLeft;
      
      private var _paddingTop;
      
      private var _paddingRight;
      
      private var _paddingBottom;
      
      private var _columnCount;
      
      private var _columnWidth;
      
      private var _firstBaselineOffset;
      
      private var _verticalAlign;
      
      private var _blockProgression;
      
      private var _lineBreak;
      
      public function TextLayoutFormat(param1:ITextLayoutFormat = null)
      {
         super();
         if(param1)
         {
            this.apply(param1);
         }
      }
      
      tlf_internal static function get colorProperty() : UintProperty
      {
         return _colorProperty;
      }
      
      tlf_internal static function get backgroundColorProperty() : UintWithEnumProperty
      {
         return _backgroundColorProperty;
      }
      
      tlf_internal static function get lineThroughProperty() : BooleanProperty
      {
         return _lineThroughProperty;
      }
      
      tlf_internal static function get textAlphaProperty() : NumberProperty
      {
         return _textAlphaProperty;
      }
      
      tlf_internal static function get backgroundAlphaProperty() : NumberProperty
      {
         return _backgroundAlphaProperty;
      }
      
      tlf_internal static function get fontSizeProperty() : NumberProperty
      {
         return _fontSizeProperty;
      }
      
      tlf_internal static function get baselineShiftProperty() : NumberOrPercentOrEnumProperty
      {
         return _baselineShiftProperty;
      }
      
      tlf_internal static function get trackingLeftProperty() : NumberOrPercentProperty
      {
         return _trackingLeftProperty;
      }
      
      tlf_internal static function get trackingRightProperty() : NumberOrPercentProperty
      {
         return _trackingRightProperty;
      }
      
      tlf_internal static function get lineHeightProperty() : NumberOrPercentProperty
      {
         return _lineHeightProperty;
      }
      
      tlf_internal static function get breakOpportunityProperty() : EnumStringProperty
      {
         return _breakOpportunityProperty;
      }
      
      tlf_internal static function get digitCaseProperty() : EnumStringProperty
      {
         return _digitCaseProperty;
      }
      
      tlf_internal static function get digitWidthProperty() : EnumStringProperty
      {
         return _digitWidthProperty;
      }
      
      tlf_internal static function get dominantBaselineProperty() : EnumStringProperty
      {
         return _dominantBaselineProperty;
      }
      
      tlf_internal static function get kerningProperty() : EnumStringProperty
      {
         return _kerningProperty;
      }
      
      tlf_internal static function get ligatureLevelProperty() : EnumStringProperty
      {
         return _ligatureLevelProperty;
      }
      
      tlf_internal static function get alignmentBaselineProperty() : EnumStringProperty
      {
         return _alignmentBaselineProperty;
      }
      
      tlf_internal static function get localeProperty() : StringProperty
      {
         return _localeProperty;
      }
      
      tlf_internal static function get typographicCaseProperty() : EnumStringProperty
      {
         return _typographicCaseProperty;
      }
      
      tlf_internal static function get fontFamilyProperty() : StringProperty
      {
         return _fontFamilyProperty;
      }
      
      tlf_internal static function get textDecorationProperty() : EnumStringProperty
      {
         return _textDecorationProperty;
      }
      
      tlf_internal static function get fontWeightProperty() : EnumStringProperty
      {
         return _fontWeightProperty;
      }
      
      tlf_internal static function get fontStyleProperty() : EnumStringProperty
      {
         return _fontStyleProperty;
      }
      
      tlf_internal static function get whiteSpaceCollapseProperty() : EnumStringProperty
      {
         return _whiteSpaceCollapseProperty;
      }
      
      tlf_internal static function get renderingModeProperty() : EnumStringProperty
      {
         return _renderingModeProperty;
      }
      
      tlf_internal static function get cffHintingProperty() : EnumStringProperty
      {
         return _cffHintingProperty;
      }
      
      tlf_internal static function get fontLookupProperty() : EnumStringProperty
      {
         return _fontLookupProperty;
      }
      
      tlf_internal static function get textRotationProperty() : EnumStringProperty
      {
         return _textRotationProperty;
      }
      
      tlf_internal static function get textIndentProperty() : NumberProperty
      {
         return _textIndentProperty;
      }
      
      tlf_internal static function get paragraphStartIndentProperty() : NumberProperty
      {
         return _paragraphStartIndentProperty;
      }
      
      tlf_internal static function get paragraphEndIndentProperty() : NumberProperty
      {
         return _paragraphEndIndentProperty;
      }
      
      tlf_internal static function get paragraphSpaceBeforeProperty() : NumberProperty
      {
         return _paragraphSpaceBeforeProperty;
      }
      
      tlf_internal static function get paragraphSpaceAfterProperty() : NumberProperty
      {
         return _paragraphSpaceAfterProperty;
      }
      
      tlf_internal static function get textAlignProperty() : EnumStringProperty
      {
         return _textAlignProperty;
      }
      
      tlf_internal static function get textAlignLastProperty() : EnumStringProperty
      {
         return _textAlignLastProperty;
      }
      
      tlf_internal static function get textJustifyProperty() : EnumStringProperty
      {
         return _textJustifyProperty;
      }
      
      tlf_internal static function get justificationRuleProperty() : EnumStringProperty
      {
         return _justificationRuleProperty;
      }
      
      tlf_internal static function get justificationStyleProperty() : EnumStringProperty
      {
         return _justificationStyleProperty;
      }
      
      tlf_internal static function get directionProperty() : EnumStringProperty
      {
         return _directionProperty;
      }
      
      tlf_internal static function get tabStopsProperty() : TabStopsProperty
      {
         return _tabStopsProperty;
      }
      
      tlf_internal static function get leadingModelProperty() : EnumStringProperty
      {
         return _leadingModelProperty;
      }
      
      tlf_internal static function get columnGapProperty() : NumberProperty
      {
         return _columnGapProperty;
      }
      
      tlf_internal static function get paddingLeftProperty() : NumberProperty
      {
         return _paddingLeftProperty;
      }
      
      tlf_internal static function get paddingTopProperty() : NumberProperty
      {
         return _paddingTopProperty;
      }
      
      tlf_internal static function get paddingRightProperty() : NumberProperty
      {
         return _paddingRightProperty;
      }
      
      tlf_internal static function get paddingBottomProperty() : NumberProperty
      {
         return _paddingBottomProperty;
      }
      
      tlf_internal static function get columnCountProperty() : IntWithEnumProperty
      {
         return _columnCountProperty;
      }
      
      tlf_internal static function get columnWidthProperty() : NumberWithEnumProperty
      {
         return _columnWidthProperty;
      }
      
      tlf_internal static function get firstBaselineOffsetProperty() : NumberWithEnumProperty
      {
         return _firstBaselineOffsetProperty;
      }
      
      tlf_internal static function get verticalAlignProperty() : EnumStringProperty
      {
         return _verticalAlignProperty;
      }
      
      tlf_internal static function get blockProgressionProperty() : EnumStringProperty
      {
         return _blockProgressionProperty;
      }
      
      tlf_internal static function get lineBreakProperty() : EnumStringProperty
      {
         return _lineBreakProperty;
      }
      
      tlf_internal static function get description() : Object
      {
         return _description;
      }
      
      tlf_internal static function get emptyTextLayoutFormat() : ITextLayoutFormat
      {
         if(_emptyTextLayoutFormat == null)
         {
            _emptyTextLayoutFormat = new TextLayoutFormatValueHolder();
         }
         return _emptyTextLayoutFormat;
      }
      
      public static function isEqual(param1:ITextLayoutFormat, param2:ITextLayoutFormat) : Boolean
      {
         if(param1 == null)
         {
            param1 = emptyTextLayoutFormat;
         }
         if(param2 == null)
         {
            param2 = emptyTextLayoutFormat;
         }
         if(param1 == param2)
         {
            return true;
         }
         var _loc3_:TextLayoutFormatValueHolder = param1 as TextLayoutFormatValueHolder;
         var _loc4_:TextLayoutFormatValueHolder = param2 as TextLayoutFormatValueHolder;
         if(_loc3_ && _loc4_)
         {
            return Property.equalCoreStyles(_loc3_.coreStyles,_loc4_.coreStyles,TextLayoutFormat.description);
         }
         if(!_colorProperty.equalHelper(param1.color,param2.color))
         {
            return false;
         }
         if(!_backgroundColorProperty.equalHelper(param1.backgroundColor,param2.backgroundColor))
         {
            return false;
         }
         if(!_lineThroughProperty.equalHelper(param1.lineThrough,param2.lineThrough))
         {
            return false;
         }
         if(!_textAlphaProperty.equalHelper(param1.textAlpha,param2.textAlpha))
         {
            return false;
         }
         if(!_backgroundAlphaProperty.equalHelper(param1.backgroundAlpha,param2.backgroundAlpha))
         {
            return false;
         }
         if(!_fontSizeProperty.equalHelper(param1.fontSize,param2.fontSize))
         {
            return false;
         }
         if(!_baselineShiftProperty.equalHelper(param1.baselineShift,param2.baselineShift))
         {
            return false;
         }
         if(!_trackingLeftProperty.equalHelper(param1.trackingLeft,param2.trackingLeft))
         {
            return false;
         }
         if(!_trackingRightProperty.equalHelper(param1.trackingRight,param2.trackingRight))
         {
            return false;
         }
         if(!_lineHeightProperty.equalHelper(param1.lineHeight,param2.lineHeight))
         {
            return false;
         }
         if(!_breakOpportunityProperty.equalHelper(param1.breakOpportunity,param2.breakOpportunity))
         {
            return false;
         }
         if(!_digitCaseProperty.equalHelper(param1.digitCase,param2.digitCase))
         {
            return false;
         }
         if(!_digitWidthProperty.equalHelper(param1.digitWidth,param2.digitWidth))
         {
            return false;
         }
         if(!_dominantBaselineProperty.equalHelper(param1.dominantBaseline,param2.dominantBaseline))
         {
            return false;
         }
         if(!_kerningProperty.equalHelper(param1.kerning,param2.kerning))
         {
            return false;
         }
         if(!_ligatureLevelProperty.equalHelper(param1.ligatureLevel,param2.ligatureLevel))
         {
            return false;
         }
         if(!_alignmentBaselineProperty.equalHelper(param1.alignmentBaseline,param2.alignmentBaseline))
         {
            return false;
         }
         if(!_localeProperty.equalHelper(param1.locale,param2.locale))
         {
            return false;
         }
         if(!_typographicCaseProperty.equalHelper(param1.typographicCase,param2.typographicCase))
         {
            return false;
         }
         if(!_fontFamilyProperty.equalHelper(param1.fontFamily,param2.fontFamily))
         {
            return false;
         }
         if(!_textDecorationProperty.equalHelper(param1.textDecoration,param2.textDecoration))
         {
            return false;
         }
         if(!_fontWeightProperty.equalHelper(param1.fontWeight,param2.fontWeight))
         {
            return false;
         }
         if(!_fontStyleProperty.equalHelper(param1.fontStyle,param2.fontStyle))
         {
            return false;
         }
         if(!_whiteSpaceCollapseProperty.equalHelper(param1.whiteSpaceCollapse,param2.whiteSpaceCollapse))
         {
            return false;
         }
         if(!_renderingModeProperty.equalHelper(param1.renderingMode,param2.renderingMode))
         {
            return false;
         }
         if(!_cffHintingProperty.equalHelper(param1.cffHinting,param2.cffHinting))
         {
            return false;
         }
         if(!_fontLookupProperty.equalHelper(param1.fontLookup,param2.fontLookup))
         {
            return false;
         }
         if(!_textRotationProperty.equalHelper(param1.textRotation,param2.textRotation))
         {
            return false;
         }
         if(!_textIndentProperty.equalHelper(param1.textIndent,param2.textIndent))
         {
            return false;
         }
         if(!_paragraphStartIndentProperty.equalHelper(param1.paragraphStartIndent,param2.paragraphStartIndent))
         {
            return false;
         }
         if(!_paragraphEndIndentProperty.equalHelper(param1.paragraphEndIndent,param2.paragraphEndIndent))
         {
            return false;
         }
         if(!_paragraphSpaceBeforeProperty.equalHelper(param1.paragraphSpaceBefore,param2.paragraphSpaceBefore))
         {
            return false;
         }
         if(!_paragraphSpaceAfterProperty.equalHelper(param1.paragraphSpaceAfter,param2.paragraphSpaceAfter))
         {
            return false;
         }
         if(!_textAlignProperty.equalHelper(param1.textAlign,param2.textAlign))
         {
            return false;
         }
         if(!_textAlignLastProperty.equalHelper(param1.textAlignLast,param2.textAlignLast))
         {
            return false;
         }
         if(!_textJustifyProperty.equalHelper(param1.textJustify,param2.textJustify))
         {
            return false;
         }
         if(!_justificationRuleProperty.equalHelper(param1.justificationRule,param2.justificationRule))
         {
            return false;
         }
         if(!_justificationStyleProperty.equalHelper(param1.justificationStyle,param2.justificationStyle))
         {
            return false;
         }
         if(!_directionProperty.equalHelper(param1.direction,param2.direction))
         {
            return false;
         }
         if(!_tabStopsProperty.equalHelper(param1.tabStops,param2.tabStops))
         {
            return false;
         }
         if(!_leadingModelProperty.equalHelper(param1.leadingModel,param2.leadingModel))
         {
            return false;
         }
         if(!_columnGapProperty.equalHelper(param1.columnGap,param2.columnGap))
         {
            return false;
         }
         if(!_paddingLeftProperty.equalHelper(param1.paddingLeft,param2.paddingLeft))
         {
            return false;
         }
         if(!_paddingTopProperty.equalHelper(param1.paddingTop,param2.paddingTop))
         {
            return false;
         }
         if(!_paddingRightProperty.equalHelper(param1.paddingRight,param2.paddingRight))
         {
            return false;
         }
         if(!_paddingBottomProperty.equalHelper(param1.paddingBottom,param2.paddingBottom))
         {
            return false;
         }
         if(!_columnCountProperty.equalHelper(param1.columnCount,param2.columnCount))
         {
            return false;
         }
         if(!_columnWidthProperty.equalHelper(param1.columnWidth,param2.columnWidth))
         {
            return false;
         }
         if(!_firstBaselineOffsetProperty.equalHelper(param1.firstBaselineOffset,param2.firstBaselineOffset))
         {
            return false;
         }
         if(!_verticalAlignProperty.equalHelper(param1.verticalAlign,param2.verticalAlign))
         {
            return false;
         }
         if(!_blockProgressionProperty.equalHelper(param1.blockProgression,param2.blockProgression))
         {
            return false;
         }
         if(!_lineBreakProperty.equalHelper(param1.lineBreak,param2.lineBreak))
         {
            return false;
         }
         return true;
      }
      
      public static function get defaultFormat() : ITextLayoutFormat
      {
         if(_defaults == null)
         {
            _defaults = new TextLayoutFormat();
            Property.defaultsAllHelper(_description,_defaults);
         }
         return _defaults;
      }
      
      public function get color() : *
      {
         return this._color;
      }
      
      public function set color(param1:*) : void
      {
         this._color = _colorProperty.setHelper(this._color,param1);
      }
      
      public function get backgroundColor() : *
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(param1:*) : void
      {
         this._backgroundColor = _backgroundColorProperty.setHelper(this._backgroundColor,param1);
      }
      
      public function get lineThrough() : *
      {
         return this._lineThrough;
      }
      
      public function set lineThrough(param1:*) : void
      {
         this._lineThrough = _lineThroughProperty.setHelper(this._lineThrough,param1);
      }
      
      public function get textAlpha() : *
      {
         return this._textAlpha;
      }
      
      public function set textAlpha(param1:*) : void
      {
         this._textAlpha = _textAlphaProperty.setHelper(this._textAlpha,param1);
      }
      
      public function get backgroundAlpha() : *
      {
         return this._backgroundAlpha;
      }
      
      public function set backgroundAlpha(param1:*) : void
      {
         this._backgroundAlpha = _backgroundAlphaProperty.setHelper(this._backgroundAlpha,param1);
      }
      
      public function get fontSize() : *
      {
         return this._fontSize;
      }
      
      public function set fontSize(param1:*) : void
      {
         this._fontSize = _fontSizeProperty.setHelper(this._fontSize,param1);
      }
      
      public function get baselineShift() : *
      {
         return this._baselineShift;
      }
      
      public function set baselineShift(param1:*) : void
      {
         this._baselineShift = _baselineShiftProperty.setHelper(this._baselineShift,param1);
      }
      
      public function get trackingLeft() : *
      {
         return this._trackingLeft;
      }
      
      public function set trackingLeft(param1:*) : void
      {
         this._trackingLeft = _trackingLeftProperty.setHelper(this._trackingLeft,param1);
      }
      
      public function get trackingRight() : *
      {
         return this._trackingRight;
      }
      
      public function set trackingRight(param1:*) : void
      {
         this._trackingRight = _trackingRightProperty.setHelper(this._trackingRight,param1);
      }
      
      public function get lineHeight() : *
      {
         return this._lineHeight;
      }
      
      public function set lineHeight(param1:*) : void
      {
         this._lineHeight = _lineHeightProperty.setHelper(this._lineHeight,param1);
      }
      
      public function get breakOpportunity() : *
      {
         return this._breakOpportunity;
      }
      
      public function set breakOpportunity(param1:*) : void
      {
         this._breakOpportunity = _breakOpportunityProperty.setHelper(this._breakOpportunity,param1);
      }
      
      public function get digitCase() : *
      {
         return this._digitCase;
      }
      
      public function set digitCase(param1:*) : void
      {
         this._digitCase = _digitCaseProperty.setHelper(this._digitCase,param1);
      }
      
      public function get digitWidth() : *
      {
         return this._digitWidth;
      }
      
      public function set digitWidth(param1:*) : void
      {
         this._digitWidth = _digitWidthProperty.setHelper(this._digitWidth,param1);
      }
      
      public function get dominantBaseline() : *
      {
         return this._dominantBaseline;
      }
      
      public function set dominantBaseline(param1:*) : void
      {
         this._dominantBaseline = _dominantBaselineProperty.setHelper(this._dominantBaseline,param1);
      }
      
      public function get kerning() : *
      {
         return this._kerning;
      }
      
      public function set kerning(param1:*) : void
      {
         this._kerning = _kerningProperty.setHelper(this._kerning,param1);
      }
      
      public function get ligatureLevel() : *
      {
         return this._ligatureLevel;
      }
      
      public function set ligatureLevel(param1:*) : void
      {
         this._ligatureLevel = _ligatureLevelProperty.setHelper(this._ligatureLevel,param1);
      }
      
      public function get alignmentBaseline() : *
      {
         return this._alignmentBaseline;
      }
      
      public function set alignmentBaseline(param1:*) : void
      {
         this._alignmentBaseline = _alignmentBaselineProperty.setHelper(this._alignmentBaseline,param1);
      }
      
      public function get locale() : *
      {
         return this._locale;
      }
      
      public function set locale(param1:*) : void
      {
         this._locale = _localeProperty.setHelper(this._locale,param1);
      }
      
      public function get typographicCase() : *
      {
         return this._typographicCase;
      }
      
      public function set typographicCase(param1:*) : void
      {
         this._typographicCase = _typographicCaseProperty.setHelper(this._typographicCase,param1);
      }
      
      public function get fontFamily() : *
      {
         return this._fontFamily;
      }
      
      public function set fontFamily(param1:*) : void
      {
         this._fontFamily = _fontFamilyProperty.setHelper(this._fontFamily,param1);
      }
      
      public function get textDecoration() : *
      {
         return this._textDecoration;
      }
      
      public function set textDecoration(param1:*) : void
      {
         this._textDecoration = _textDecorationProperty.setHelper(this._textDecoration,param1);
      }
      
      public function get fontWeight() : *
      {
         return this._fontWeight;
      }
      
      public function set fontWeight(param1:*) : void
      {
         this._fontWeight = _fontWeightProperty.setHelper(this._fontWeight,param1);
      }
      
      public function get fontStyle() : *
      {
         return this._fontStyle;
      }
      
      public function set fontStyle(param1:*) : void
      {
         this._fontStyle = _fontStyleProperty.setHelper(this._fontStyle,param1);
      }
      
      public function get whiteSpaceCollapse() : *
      {
         return this._whiteSpaceCollapse;
      }
      
      public function set whiteSpaceCollapse(param1:*) : void
      {
         this._whiteSpaceCollapse = _whiteSpaceCollapseProperty.setHelper(this._whiteSpaceCollapse,param1);
      }
      
      public function get renderingMode() : *
      {
         return this._renderingMode;
      }
      
      public function set renderingMode(param1:*) : void
      {
         this._renderingMode = _renderingModeProperty.setHelper(this._renderingMode,param1);
      }
      
      public function get cffHinting() : *
      {
         return this._cffHinting;
      }
      
      public function set cffHinting(param1:*) : void
      {
         this._cffHinting = _cffHintingProperty.setHelper(this._cffHinting,param1);
      }
      
      public function get fontLookup() : *
      {
         return this._fontLookup;
      }
      
      public function set fontLookup(param1:*) : void
      {
         this._fontLookup = _fontLookupProperty.setHelper(this._fontLookup,param1);
      }
      
      public function get textRotation() : *
      {
         return this._textRotation;
      }
      
      public function set textRotation(param1:*) : void
      {
         this._textRotation = _textRotationProperty.setHelper(this._textRotation,param1);
      }
      
      public function get textIndent() : *
      {
         return this._textIndent;
      }
      
      public function set textIndent(param1:*) : void
      {
         this._textIndent = _textIndentProperty.setHelper(this._textIndent,param1);
      }
      
      public function get paragraphStartIndent() : *
      {
         return this._paragraphStartIndent;
      }
      
      public function set paragraphStartIndent(param1:*) : void
      {
         this._paragraphStartIndent = _paragraphStartIndentProperty.setHelper(this._paragraphStartIndent,param1);
      }
      
      public function get paragraphEndIndent() : *
      {
         return this._paragraphEndIndent;
      }
      
      public function set paragraphEndIndent(param1:*) : void
      {
         this._paragraphEndIndent = _paragraphEndIndentProperty.setHelper(this._paragraphEndIndent,param1);
      }
      
      public function get paragraphSpaceBefore() : *
      {
         return this._paragraphSpaceBefore;
      }
      
      public function set paragraphSpaceBefore(param1:*) : void
      {
         this._paragraphSpaceBefore = _paragraphSpaceBeforeProperty.setHelper(this._paragraphSpaceBefore,param1);
      }
      
      public function get paragraphSpaceAfter() : *
      {
         return this._paragraphSpaceAfter;
      }
      
      public function set paragraphSpaceAfter(param1:*) : void
      {
         this._paragraphSpaceAfter = _paragraphSpaceAfterProperty.setHelper(this._paragraphSpaceAfter,param1);
      }
      
      public function get textAlign() : *
      {
         return this._textAlign;
      }
      
      public function set textAlign(param1:*) : void
      {
         this._textAlign = _textAlignProperty.setHelper(this._textAlign,param1);
      }
      
      public function get textAlignLast() : *
      {
         return this._textAlignLast;
      }
      
      public function set textAlignLast(param1:*) : void
      {
         this._textAlignLast = _textAlignLastProperty.setHelper(this._textAlignLast,param1);
      }
      
      public function get textJustify() : *
      {
         return this._textJustify;
      }
      
      public function set textJustify(param1:*) : void
      {
         this._textJustify = _textJustifyProperty.setHelper(this._textJustify,param1);
      }
      
      public function get justificationRule() : *
      {
         return this._justificationRule;
      }
      
      public function set justificationRule(param1:*) : void
      {
         this._justificationRule = _justificationRuleProperty.setHelper(this._justificationRule,param1);
      }
      
      public function get justificationStyle() : *
      {
         return this._justificationStyle;
      }
      
      public function set justificationStyle(param1:*) : void
      {
         this._justificationStyle = _justificationStyleProperty.setHelper(this._justificationStyle,param1);
      }
      
      public function get direction() : *
      {
         return this._direction;
      }
      
      public function set direction(param1:*) : void
      {
         this._direction = _directionProperty.setHelper(this._direction,param1);
      }
      
      public function get tabStops() : *
      {
         return this._tabStops;
      }
      
      public function set tabStops(param1:*) : void
      {
         this._tabStops = _tabStopsProperty.setHelper(this._tabStops,param1);
      }
      
      public function get leadingModel() : *
      {
         return this._leadingModel;
      }
      
      public function set leadingModel(param1:*) : void
      {
         this._leadingModel = _leadingModelProperty.setHelper(this._leadingModel,param1);
      }
      
      public function get columnGap() : *
      {
         return this._columnGap;
      }
      
      public function set columnGap(param1:*) : void
      {
         this._columnGap = _columnGapProperty.setHelper(this._columnGap,param1);
      }
      
      public function get paddingLeft() : *
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(param1:*) : void
      {
         this._paddingLeft = _paddingLeftProperty.setHelper(this._paddingLeft,param1);
      }
      
      public function get paddingTop() : *
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(param1:*) : void
      {
         this._paddingTop = _paddingTopProperty.setHelper(this._paddingTop,param1);
      }
      
      public function get paddingRight() : *
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(param1:*) : void
      {
         this._paddingRight = _paddingRightProperty.setHelper(this._paddingRight,param1);
      }
      
      public function get paddingBottom() : *
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(param1:*) : void
      {
         this._paddingBottom = _paddingBottomProperty.setHelper(this._paddingBottom,param1);
      }
      
      public function get columnCount() : *
      {
         return this._columnCount;
      }
      
      public function set columnCount(param1:*) : void
      {
         this._columnCount = _columnCountProperty.setHelper(this._columnCount,param1);
      }
      
      public function get columnWidth() : *
      {
         return this._columnWidth;
      }
      
      public function set columnWidth(param1:*) : void
      {
         this._columnWidth = _columnWidthProperty.setHelper(this._columnWidth,param1);
      }
      
      public function get firstBaselineOffset() : *
      {
         return this._firstBaselineOffset;
      }
      
      public function set firstBaselineOffset(param1:*) : void
      {
         this._firstBaselineOffset = _firstBaselineOffsetProperty.setHelper(this._firstBaselineOffset,param1);
      }
      
      public function get verticalAlign() : *
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(param1:*) : void
      {
         this._verticalAlign = _verticalAlignProperty.setHelper(this._verticalAlign,param1);
      }
      
      public function get blockProgression() : *
      {
         return this._blockProgression;
      }
      
      public function set blockProgression(param1:*) : void
      {
         this._blockProgression = _blockProgressionProperty.setHelper(this._blockProgression,param1);
      }
      
      public function get lineBreak() : *
      {
         return this._lineBreak;
      }
      
      public function set lineBreak(param1:*) : void
      {
         this._lineBreak = _lineBreakProperty.setHelper(this._lineBreak,param1);
      }
      
      public function copy(param1:ITextLayoutFormat) : void
      {
         if(param1 == null)
         {
            param1 = emptyTextLayoutFormat;
         }
         this.color = param1.color;
         this.backgroundColor = param1.backgroundColor;
         this.lineThrough = param1.lineThrough;
         this.textAlpha = param1.textAlpha;
         this.backgroundAlpha = param1.backgroundAlpha;
         this.fontSize = param1.fontSize;
         this.baselineShift = param1.baselineShift;
         this.trackingLeft = param1.trackingLeft;
         this.trackingRight = param1.trackingRight;
         this.lineHeight = param1.lineHeight;
         this.breakOpportunity = param1.breakOpportunity;
         this.digitCase = param1.digitCase;
         this.digitWidth = param1.digitWidth;
         this.dominantBaseline = param1.dominantBaseline;
         this.kerning = param1.kerning;
         this.ligatureLevel = param1.ligatureLevel;
         this.alignmentBaseline = param1.alignmentBaseline;
         this.locale = param1.locale;
         this.typographicCase = param1.typographicCase;
         this.fontFamily = param1.fontFamily;
         this.textDecoration = param1.textDecoration;
         this.fontWeight = param1.fontWeight;
         this.fontStyle = param1.fontStyle;
         this.whiteSpaceCollapse = param1.whiteSpaceCollapse;
         this.renderingMode = param1.renderingMode;
         this.cffHinting = param1.cffHinting;
         this.fontLookup = param1.fontLookup;
         this.textRotation = param1.textRotation;
         this.textIndent = param1.textIndent;
         this.paragraphStartIndent = param1.paragraphStartIndent;
         this.paragraphEndIndent = param1.paragraphEndIndent;
         this.paragraphSpaceBefore = param1.paragraphSpaceBefore;
         this.paragraphSpaceAfter = param1.paragraphSpaceAfter;
         this.textAlign = param1.textAlign;
         this.textAlignLast = param1.textAlignLast;
         this.textJustify = param1.textJustify;
         this.justificationRule = param1.justificationRule;
         this.justificationStyle = param1.justificationStyle;
         this.direction = param1.direction;
         this.tabStops = param1.tabStops;
         this.leadingModel = param1.leadingModel;
         this.columnGap = param1.columnGap;
         this.paddingLeft = param1.paddingLeft;
         this.paddingTop = param1.paddingTop;
         this.paddingRight = param1.paddingRight;
         this.paddingBottom = param1.paddingBottom;
         this.columnCount = param1.columnCount;
         this.columnWidth = param1.columnWidth;
         this.firstBaselineOffset = param1.firstBaselineOffset;
         this.verticalAlign = param1.verticalAlign;
         this.blockProgression = param1.blockProgression;
         this.lineBreak = param1.lineBreak;
      }
      
      public function concat(param1:ITextLayoutFormat) : void
      {
         var _loc3_:* = null;
         var _loc2_:TextLayoutFormatValueHolder = param1 as TextLayoutFormatValueHolder;
         if(_loc2_)
         {
            for(_loc3_ in _loc2_.coreStyles)
            {
               this[_loc3_] = description[_loc3_].concatHelper(this[_loc3_],_loc2_.coreStyles[_loc3_]);
            }
            return;
         }
         this.color = _colorProperty.concatHelper(this.color,param1.color);
         this.backgroundColor = _backgroundColorProperty.concatHelper(this.backgroundColor,param1.backgroundColor);
         this.lineThrough = _lineThroughProperty.concatHelper(this.lineThrough,param1.lineThrough);
         this.textAlpha = _textAlphaProperty.concatHelper(this.textAlpha,param1.textAlpha);
         this.backgroundAlpha = _backgroundAlphaProperty.concatHelper(this.backgroundAlpha,param1.backgroundAlpha);
         this.fontSize = _fontSizeProperty.concatHelper(this.fontSize,param1.fontSize);
         this.baselineShift = _baselineShiftProperty.concatHelper(this.baselineShift,param1.baselineShift);
         this.trackingLeft = _trackingLeftProperty.concatHelper(this.trackingLeft,param1.trackingLeft);
         this.trackingRight = _trackingRightProperty.concatHelper(this.trackingRight,param1.trackingRight);
         this.lineHeight = _lineHeightProperty.concatHelper(this.lineHeight,param1.lineHeight);
         this.breakOpportunity = _breakOpportunityProperty.concatHelper(this.breakOpportunity,param1.breakOpportunity);
         this.digitCase = _digitCaseProperty.concatHelper(this.digitCase,param1.digitCase);
         this.digitWidth = _digitWidthProperty.concatHelper(this.digitWidth,param1.digitWidth);
         this.dominantBaseline = _dominantBaselineProperty.concatHelper(this.dominantBaseline,param1.dominantBaseline);
         this.kerning = _kerningProperty.concatHelper(this.kerning,param1.kerning);
         this.ligatureLevel = _ligatureLevelProperty.concatHelper(this.ligatureLevel,param1.ligatureLevel);
         this.alignmentBaseline = _alignmentBaselineProperty.concatHelper(this.alignmentBaseline,param1.alignmentBaseline);
         this.locale = _localeProperty.concatHelper(this.locale,param1.locale);
         this.typographicCase = _typographicCaseProperty.concatHelper(this.typographicCase,param1.typographicCase);
         this.fontFamily = _fontFamilyProperty.concatHelper(this.fontFamily,param1.fontFamily);
         this.textDecoration = _textDecorationProperty.concatHelper(this.textDecoration,param1.textDecoration);
         this.fontWeight = _fontWeightProperty.concatHelper(this.fontWeight,param1.fontWeight);
         this.fontStyle = _fontStyleProperty.concatHelper(this.fontStyle,param1.fontStyle);
         this.whiteSpaceCollapse = _whiteSpaceCollapseProperty.concatHelper(this.whiteSpaceCollapse,param1.whiteSpaceCollapse);
         this.renderingMode = _renderingModeProperty.concatHelper(this.renderingMode,param1.renderingMode);
         this.cffHinting = _cffHintingProperty.concatHelper(this.cffHinting,param1.cffHinting);
         this.fontLookup = _fontLookupProperty.concatHelper(this.fontLookup,param1.fontLookup);
         this.textRotation = _textRotationProperty.concatHelper(this.textRotation,param1.textRotation);
         this.textIndent = _textIndentProperty.concatHelper(this.textIndent,param1.textIndent);
         this.paragraphStartIndent = _paragraphStartIndentProperty.concatHelper(this.paragraphStartIndent,param1.paragraphStartIndent);
         this.paragraphEndIndent = _paragraphEndIndentProperty.concatHelper(this.paragraphEndIndent,param1.paragraphEndIndent);
         this.paragraphSpaceBefore = _paragraphSpaceBeforeProperty.concatHelper(this.paragraphSpaceBefore,param1.paragraphSpaceBefore);
         this.paragraphSpaceAfter = _paragraphSpaceAfterProperty.concatHelper(this.paragraphSpaceAfter,param1.paragraphSpaceAfter);
         this.textAlign = _textAlignProperty.concatHelper(this.textAlign,param1.textAlign);
         this.textAlignLast = _textAlignLastProperty.concatHelper(this.textAlignLast,param1.textAlignLast);
         this.textJustify = _textJustifyProperty.concatHelper(this.textJustify,param1.textJustify);
         this.justificationRule = _justificationRuleProperty.concatHelper(this.justificationRule,param1.justificationRule);
         this.justificationStyle = _justificationStyleProperty.concatHelper(this.justificationStyle,param1.justificationStyle);
         this.direction = _directionProperty.concatHelper(this.direction,param1.direction);
         this.tabStops = _tabStopsProperty.concatHelper(this.tabStops,param1.tabStops);
         this.leadingModel = _leadingModelProperty.concatHelper(this.leadingModel,param1.leadingModel);
         this.columnGap = _columnGapProperty.concatHelper(this.columnGap,param1.columnGap);
         this.paddingLeft = _paddingLeftProperty.concatHelper(this.paddingLeft,param1.paddingLeft);
         this.paddingTop = _paddingTopProperty.concatHelper(this.paddingTop,param1.paddingTop);
         this.paddingRight = _paddingRightProperty.concatHelper(this.paddingRight,param1.paddingRight);
         this.paddingBottom = _paddingBottomProperty.concatHelper(this.paddingBottom,param1.paddingBottom);
         this.columnCount = _columnCountProperty.concatHelper(this.columnCount,param1.columnCount);
         this.columnWidth = _columnWidthProperty.concatHelper(this.columnWidth,param1.columnWidth);
         this.firstBaselineOffset = _firstBaselineOffsetProperty.concatHelper(this.firstBaselineOffset,param1.firstBaselineOffset);
         this.verticalAlign = _verticalAlignProperty.concatHelper(this.verticalAlign,param1.verticalAlign);
         this.blockProgression = _blockProgressionProperty.concatHelper(this.blockProgression,param1.blockProgression);
         this.lineBreak = _lineBreakProperty.concatHelper(this.lineBreak,param1.lineBreak);
      }
      
      public function concatInheritOnly(param1:ITextLayoutFormat) : void
      {
         var _loc3_:* = null;
         var _loc2_:TextLayoutFormatValueHolder = param1 as TextLayoutFormatValueHolder;
         if(_loc2_)
         {
            for(_loc3_ in _loc2_.coreStyles)
            {
               this[_loc3_] = description[_loc3_].concatInheritOnlyHelper(this[_loc3_],_loc2_.coreStyles[_loc3_]);
            }
            return;
         }
         this.color = _colorProperty.concatInheritOnlyHelper(this.color,param1.color);
         this.backgroundColor = _backgroundColorProperty.concatInheritOnlyHelper(this.backgroundColor,param1.backgroundColor);
         this.lineThrough = _lineThroughProperty.concatInheritOnlyHelper(this.lineThrough,param1.lineThrough);
         this.textAlpha = _textAlphaProperty.concatInheritOnlyHelper(this.textAlpha,param1.textAlpha);
         this.backgroundAlpha = _backgroundAlphaProperty.concatInheritOnlyHelper(this.backgroundAlpha,param1.backgroundAlpha);
         this.fontSize = _fontSizeProperty.concatInheritOnlyHelper(this.fontSize,param1.fontSize);
         this.baselineShift = _baselineShiftProperty.concatInheritOnlyHelper(this.baselineShift,param1.baselineShift);
         this.trackingLeft = _trackingLeftProperty.concatInheritOnlyHelper(this.trackingLeft,param1.trackingLeft);
         this.trackingRight = _trackingRightProperty.concatInheritOnlyHelper(this.trackingRight,param1.trackingRight);
         this.lineHeight = _lineHeightProperty.concatInheritOnlyHelper(this.lineHeight,param1.lineHeight);
         this.breakOpportunity = _breakOpportunityProperty.concatInheritOnlyHelper(this.breakOpportunity,param1.breakOpportunity);
         this.digitCase = _digitCaseProperty.concatInheritOnlyHelper(this.digitCase,param1.digitCase);
         this.digitWidth = _digitWidthProperty.concatInheritOnlyHelper(this.digitWidth,param1.digitWidth);
         this.dominantBaseline = _dominantBaselineProperty.concatInheritOnlyHelper(this.dominantBaseline,param1.dominantBaseline);
         this.kerning = _kerningProperty.concatInheritOnlyHelper(this.kerning,param1.kerning);
         this.ligatureLevel = _ligatureLevelProperty.concatInheritOnlyHelper(this.ligatureLevel,param1.ligatureLevel);
         this.alignmentBaseline = _alignmentBaselineProperty.concatInheritOnlyHelper(this.alignmentBaseline,param1.alignmentBaseline);
         this.locale = _localeProperty.concatInheritOnlyHelper(this.locale,param1.locale);
         this.typographicCase = _typographicCaseProperty.concatInheritOnlyHelper(this.typographicCase,param1.typographicCase);
         this.fontFamily = _fontFamilyProperty.concatInheritOnlyHelper(this.fontFamily,param1.fontFamily);
         this.textDecoration = _textDecorationProperty.concatInheritOnlyHelper(this.textDecoration,param1.textDecoration);
         this.fontWeight = _fontWeightProperty.concatInheritOnlyHelper(this.fontWeight,param1.fontWeight);
         this.fontStyle = _fontStyleProperty.concatInheritOnlyHelper(this.fontStyle,param1.fontStyle);
         this.whiteSpaceCollapse = _whiteSpaceCollapseProperty.concatInheritOnlyHelper(this.whiteSpaceCollapse,param1.whiteSpaceCollapse);
         this.renderingMode = _renderingModeProperty.concatInheritOnlyHelper(this.renderingMode,param1.renderingMode);
         this.cffHinting = _cffHintingProperty.concatInheritOnlyHelper(this.cffHinting,param1.cffHinting);
         this.fontLookup = _fontLookupProperty.concatInheritOnlyHelper(this.fontLookup,param1.fontLookup);
         this.textRotation = _textRotationProperty.concatInheritOnlyHelper(this.textRotation,param1.textRotation);
         this.textIndent = _textIndentProperty.concatInheritOnlyHelper(this.textIndent,param1.textIndent);
         this.paragraphStartIndent = _paragraphStartIndentProperty.concatInheritOnlyHelper(this.paragraphStartIndent,param1.paragraphStartIndent);
         this.paragraphEndIndent = _paragraphEndIndentProperty.concatInheritOnlyHelper(this.paragraphEndIndent,param1.paragraphEndIndent);
         this.paragraphSpaceBefore = _paragraphSpaceBeforeProperty.concatInheritOnlyHelper(this.paragraphSpaceBefore,param1.paragraphSpaceBefore);
         this.paragraphSpaceAfter = _paragraphSpaceAfterProperty.concatInheritOnlyHelper(this.paragraphSpaceAfter,param1.paragraphSpaceAfter);
         this.textAlign = _textAlignProperty.concatInheritOnlyHelper(this.textAlign,param1.textAlign);
         this.textAlignLast = _textAlignLastProperty.concatInheritOnlyHelper(this.textAlignLast,param1.textAlignLast);
         this.textJustify = _textJustifyProperty.concatInheritOnlyHelper(this.textJustify,param1.textJustify);
         this.justificationRule = _justificationRuleProperty.concatInheritOnlyHelper(this.justificationRule,param1.justificationRule);
         this.justificationStyle = _justificationStyleProperty.concatInheritOnlyHelper(this.justificationStyle,param1.justificationStyle);
         this.direction = _directionProperty.concatInheritOnlyHelper(this.direction,param1.direction);
         this.tabStops = _tabStopsProperty.concatInheritOnlyHelper(this.tabStops,param1.tabStops);
         this.leadingModel = _leadingModelProperty.concatInheritOnlyHelper(this.leadingModel,param1.leadingModel);
         this.columnGap = _columnGapProperty.concatInheritOnlyHelper(this.columnGap,param1.columnGap);
         this.paddingLeft = _paddingLeftProperty.concatInheritOnlyHelper(this.paddingLeft,param1.paddingLeft);
         this.paddingTop = _paddingTopProperty.concatInheritOnlyHelper(this.paddingTop,param1.paddingTop);
         this.paddingRight = _paddingRightProperty.concatInheritOnlyHelper(this.paddingRight,param1.paddingRight);
         this.paddingBottom = _paddingBottomProperty.concatInheritOnlyHelper(this.paddingBottom,param1.paddingBottom);
         this.columnCount = _columnCountProperty.concatInheritOnlyHelper(this.columnCount,param1.columnCount);
         this.columnWidth = _columnWidthProperty.concatInheritOnlyHelper(this.columnWidth,param1.columnWidth);
         this.firstBaselineOffset = _firstBaselineOffsetProperty.concatInheritOnlyHelper(this.firstBaselineOffset,param1.firstBaselineOffset);
         this.verticalAlign = _verticalAlignProperty.concatInheritOnlyHelper(this.verticalAlign,param1.verticalAlign);
         this.blockProgression = _blockProgressionProperty.concatInheritOnlyHelper(this.blockProgression,param1.blockProgression);
         this.lineBreak = _lineBreakProperty.concatInheritOnlyHelper(this.lineBreak,param1.lineBreak);
      }
      
      public function apply(param1:ITextLayoutFormat) : void
      {
         var _loc2_:* = undefined;
         var _loc4_:* = null;
         var _loc3_:TextLayoutFormatValueHolder = param1 as TextLayoutFormatValueHolder;
         if(_loc3_)
         {
            for(_loc4_ in _loc3_.coreStyles)
            {
               this[_loc4_] = _loc3_.coreStyles[_loc4_];
            }
            return;
         }
         if((_loc2_ = param1.color) !== undefined)
         {
            this.color = _loc2_;
         }
         if((_loc2_ = param1.backgroundColor) !== undefined)
         {
            this.backgroundColor = _loc2_;
         }
         if((_loc2_ = param1.lineThrough) !== undefined)
         {
            this.lineThrough = _loc2_;
         }
         if((_loc2_ = param1.textAlpha) !== undefined)
         {
            this.textAlpha = _loc2_;
         }
         if((_loc2_ = param1.backgroundAlpha) !== undefined)
         {
            this.backgroundAlpha = _loc2_;
         }
         if((_loc2_ = param1.fontSize) !== undefined)
         {
            this.fontSize = _loc2_;
         }
         if((_loc2_ = param1.baselineShift) !== undefined)
         {
            this.baselineShift = _loc2_;
         }
         if((_loc2_ = param1.trackingLeft) !== undefined)
         {
            this.trackingLeft = _loc2_;
         }
         if((_loc2_ = param1.trackingRight) !== undefined)
         {
            this.trackingRight = _loc2_;
         }
         if((_loc2_ = param1.lineHeight) !== undefined)
         {
            this.lineHeight = _loc2_;
         }
         if((_loc2_ = param1.breakOpportunity) !== undefined)
         {
            this.breakOpportunity = _loc2_;
         }
         if((_loc2_ = param1.digitCase) !== undefined)
         {
            this.digitCase = _loc2_;
         }
         if((_loc2_ = param1.digitWidth) !== undefined)
         {
            this.digitWidth = _loc2_;
         }
         if((_loc2_ = param1.dominantBaseline) !== undefined)
         {
            this.dominantBaseline = _loc2_;
         }
         if((_loc2_ = param1.kerning) !== undefined)
         {
            this.kerning = _loc2_;
         }
         if((_loc2_ = param1.ligatureLevel) !== undefined)
         {
            this.ligatureLevel = _loc2_;
         }
         if((_loc2_ = param1.alignmentBaseline) !== undefined)
         {
            this.alignmentBaseline = _loc2_;
         }
         if((_loc2_ = param1.locale) !== undefined)
         {
            this.locale = _loc2_;
         }
         if((_loc2_ = param1.typographicCase) !== undefined)
         {
            this.typographicCase = _loc2_;
         }
         if((_loc2_ = param1.fontFamily) !== undefined)
         {
            this.fontFamily = _loc2_;
         }
         if((_loc2_ = param1.textDecoration) !== undefined)
         {
            this.textDecoration = _loc2_;
         }
         if((_loc2_ = param1.fontWeight) !== undefined)
         {
            this.fontWeight = _loc2_;
         }
         if((_loc2_ = param1.fontStyle) !== undefined)
         {
            this.fontStyle = _loc2_;
         }
         if((_loc2_ = param1.whiteSpaceCollapse) !== undefined)
         {
            this.whiteSpaceCollapse = _loc2_;
         }
         if((_loc2_ = param1.renderingMode) !== undefined)
         {
            this.renderingMode = _loc2_;
         }
         if((_loc2_ = param1.cffHinting) !== undefined)
         {
            this.cffHinting = _loc2_;
         }
         if((_loc2_ = param1.fontLookup) !== undefined)
         {
            this.fontLookup = _loc2_;
         }
         if((_loc2_ = param1.textRotation) !== undefined)
         {
            this.textRotation = _loc2_;
         }
         if((_loc2_ = param1.textIndent) !== undefined)
         {
            this.textIndent = _loc2_;
         }
         if((_loc2_ = param1.paragraphStartIndent) !== undefined)
         {
            this.paragraphStartIndent = _loc2_;
         }
         if((_loc2_ = param1.paragraphEndIndent) !== undefined)
         {
            this.paragraphEndIndent = _loc2_;
         }
         if((_loc2_ = param1.paragraphSpaceBefore) !== undefined)
         {
            this.paragraphSpaceBefore = _loc2_;
         }
         if((_loc2_ = param1.paragraphSpaceAfter) !== undefined)
         {
            this.paragraphSpaceAfter = _loc2_;
         }
         if((_loc2_ = param1.textAlign) !== undefined)
         {
            this.textAlign = _loc2_;
         }
         if((_loc2_ = param1.textAlignLast) !== undefined)
         {
            this.textAlignLast = _loc2_;
         }
         if((_loc2_ = param1.textJustify) !== undefined)
         {
            this.textJustify = _loc2_;
         }
         if((_loc2_ = param1.justificationRule) !== undefined)
         {
            this.justificationRule = _loc2_;
         }
         if((_loc2_ = param1.justificationStyle) !== undefined)
         {
            this.justificationStyle = _loc2_;
         }
         if((_loc2_ = param1.direction) !== undefined)
         {
            this.direction = _loc2_;
         }
         if((_loc2_ = param1.tabStops) !== undefined)
         {
            this.tabStops = _loc2_;
         }
         if((_loc2_ = param1.leadingModel) !== undefined)
         {
            this.leadingModel = _loc2_;
         }
         if((_loc2_ = param1.columnGap) !== undefined)
         {
            this.columnGap = _loc2_;
         }
         if((_loc2_ = param1.paddingLeft) !== undefined)
         {
            this.paddingLeft = _loc2_;
         }
         if((_loc2_ = param1.paddingTop) !== undefined)
         {
            this.paddingTop = _loc2_;
         }
         if((_loc2_ = param1.paddingRight) !== undefined)
         {
            this.paddingRight = _loc2_;
         }
         if((_loc2_ = param1.paddingBottom) !== undefined)
         {
            this.paddingBottom = _loc2_;
         }
         if((_loc2_ = param1.columnCount) !== undefined)
         {
            this.columnCount = _loc2_;
         }
         if((_loc2_ = param1.columnWidth) !== undefined)
         {
            this.columnWidth = _loc2_;
         }
         if((_loc2_ = param1.firstBaselineOffset) !== undefined)
         {
            this.firstBaselineOffset = _loc2_;
         }
         if((_loc2_ = param1.verticalAlign) !== undefined)
         {
            this.verticalAlign = _loc2_;
         }
         if((_loc2_ = param1.blockProgression) !== undefined)
         {
            this.blockProgression = _loc2_;
         }
         if((_loc2_ = param1.lineBreak) !== undefined)
         {
            this.lineBreak = _loc2_;
         }
      }
      
      public function removeMatching(param1:ITextLayoutFormat) : void
      {
         var _loc3_:* = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:TextLayoutFormatValueHolder = param1 as TextLayoutFormatValueHolder;
         if(_loc2_)
         {
            for(_loc3_ in _loc2_.coreStyles)
            {
               if(description[_loc3_].equalHelper(this[_loc3_],_loc2_.coreStyles[_loc3_]))
               {
                  this[_loc3_] = undefined;
               }
            }
            return;
         }
         if(_colorProperty.equalHelper(this.color,param1.color))
         {
            this.color = undefined;
         }
         if(_backgroundColorProperty.equalHelper(this.backgroundColor,param1.backgroundColor))
         {
            this.backgroundColor = undefined;
         }
         if(_lineThroughProperty.equalHelper(this.lineThrough,param1.lineThrough))
         {
            this.lineThrough = undefined;
         }
         if(_textAlphaProperty.equalHelper(this.textAlpha,param1.textAlpha))
         {
            this.textAlpha = undefined;
         }
         if(_backgroundAlphaProperty.equalHelper(this.backgroundAlpha,param1.backgroundAlpha))
         {
            this.backgroundAlpha = undefined;
         }
         if(_fontSizeProperty.equalHelper(this.fontSize,param1.fontSize))
         {
            this.fontSize = undefined;
         }
         if(_baselineShiftProperty.equalHelper(this.baselineShift,param1.baselineShift))
         {
            this.baselineShift = undefined;
         }
         if(_trackingLeftProperty.equalHelper(this.trackingLeft,param1.trackingLeft))
         {
            this.trackingLeft = undefined;
         }
         if(_trackingRightProperty.equalHelper(this.trackingRight,param1.trackingRight))
         {
            this.trackingRight = undefined;
         }
         if(_lineHeightProperty.equalHelper(this.lineHeight,param1.lineHeight))
         {
            this.lineHeight = undefined;
         }
         if(_breakOpportunityProperty.equalHelper(this.breakOpportunity,param1.breakOpportunity))
         {
            this.breakOpportunity = undefined;
         }
         if(_digitCaseProperty.equalHelper(this.digitCase,param1.digitCase))
         {
            this.digitCase = undefined;
         }
         if(_digitWidthProperty.equalHelper(this.digitWidth,param1.digitWidth))
         {
            this.digitWidth = undefined;
         }
         if(_dominantBaselineProperty.equalHelper(this.dominantBaseline,param1.dominantBaseline))
         {
            this.dominantBaseline = undefined;
         }
         if(_kerningProperty.equalHelper(this.kerning,param1.kerning))
         {
            this.kerning = undefined;
         }
         if(_ligatureLevelProperty.equalHelper(this.ligatureLevel,param1.ligatureLevel))
         {
            this.ligatureLevel = undefined;
         }
         if(_alignmentBaselineProperty.equalHelper(this.alignmentBaseline,param1.alignmentBaseline))
         {
            this.alignmentBaseline = undefined;
         }
         if(_localeProperty.equalHelper(this.locale,param1.locale))
         {
            this.locale = undefined;
         }
         if(_typographicCaseProperty.equalHelper(this.typographicCase,param1.typographicCase))
         {
            this.typographicCase = undefined;
         }
         if(_fontFamilyProperty.equalHelper(this.fontFamily,param1.fontFamily))
         {
            this.fontFamily = undefined;
         }
         if(_textDecorationProperty.equalHelper(this.textDecoration,param1.textDecoration))
         {
            this.textDecoration = undefined;
         }
         if(_fontWeightProperty.equalHelper(this.fontWeight,param1.fontWeight))
         {
            this.fontWeight = undefined;
         }
         if(_fontStyleProperty.equalHelper(this.fontStyle,param1.fontStyle))
         {
            this.fontStyle = undefined;
         }
         if(_whiteSpaceCollapseProperty.equalHelper(this.whiteSpaceCollapse,param1.whiteSpaceCollapse))
         {
            this.whiteSpaceCollapse = undefined;
         }
         if(_renderingModeProperty.equalHelper(this.renderingMode,param1.renderingMode))
         {
            this.renderingMode = undefined;
         }
         if(_cffHintingProperty.equalHelper(this.cffHinting,param1.cffHinting))
         {
            this.cffHinting = undefined;
         }
         if(_fontLookupProperty.equalHelper(this.fontLookup,param1.fontLookup))
         {
            this.fontLookup = undefined;
         }
         if(_textRotationProperty.equalHelper(this.textRotation,param1.textRotation))
         {
            this.textRotation = undefined;
         }
         if(_textIndentProperty.equalHelper(this.textIndent,param1.textIndent))
         {
            this.textIndent = undefined;
         }
         if(_paragraphStartIndentProperty.equalHelper(this.paragraphStartIndent,param1.paragraphStartIndent))
         {
            this.paragraphStartIndent = undefined;
         }
         if(_paragraphEndIndentProperty.equalHelper(this.paragraphEndIndent,param1.paragraphEndIndent))
         {
            this.paragraphEndIndent = undefined;
         }
         if(_paragraphSpaceBeforeProperty.equalHelper(this.paragraphSpaceBefore,param1.paragraphSpaceBefore))
         {
            this.paragraphSpaceBefore = undefined;
         }
         if(_paragraphSpaceAfterProperty.equalHelper(this.paragraphSpaceAfter,param1.paragraphSpaceAfter))
         {
            this.paragraphSpaceAfter = undefined;
         }
         if(_textAlignProperty.equalHelper(this.textAlign,param1.textAlign))
         {
            this.textAlign = undefined;
         }
         if(_textAlignLastProperty.equalHelper(this.textAlignLast,param1.textAlignLast))
         {
            this.textAlignLast = undefined;
         }
         if(_textJustifyProperty.equalHelper(this.textJustify,param1.textJustify))
         {
            this.textJustify = undefined;
         }
         if(_justificationRuleProperty.equalHelper(this.justificationRule,param1.justificationRule))
         {
            this.justificationRule = undefined;
         }
         if(_justificationStyleProperty.equalHelper(this.justificationStyle,param1.justificationStyle))
         {
            this.justificationStyle = undefined;
         }
         if(_directionProperty.equalHelper(this.direction,param1.direction))
         {
            this.direction = undefined;
         }
         if(_tabStopsProperty.equalHelper(this.tabStops,param1.tabStops))
         {
            this.tabStops = undefined;
         }
         if(_leadingModelProperty.equalHelper(this.leadingModel,param1.leadingModel))
         {
            this.leadingModel = undefined;
         }
         if(_columnGapProperty.equalHelper(this.columnGap,param1.columnGap))
         {
            this.columnGap = undefined;
         }
         if(_paddingLeftProperty.equalHelper(this.paddingLeft,param1.paddingLeft))
         {
            this.paddingLeft = undefined;
         }
         if(_paddingTopProperty.equalHelper(this.paddingTop,param1.paddingTop))
         {
            this.paddingTop = undefined;
         }
         if(_paddingRightProperty.equalHelper(this.paddingRight,param1.paddingRight))
         {
            this.paddingRight = undefined;
         }
         if(_paddingBottomProperty.equalHelper(this.paddingBottom,param1.paddingBottom))
         {
            this.paddingBottom = undefined;
         }
         if(_columnCountProperty.equalHelper(this.columnCount,param1.columnCount))
         {
            this.columnCount = undefined;
         }
         if(_columnWidthProperty.equalHelper(this.columnWidth,param1.columnWidth))
         {
            this.columnWidth = undefined;
         }
         if(_firstBaselineOffsetProperty.equalHelper(this.firstBaselineOffset,param1.firstBaselineOffset))
         {
            this.firstBaselineOffset = undefined;
         }
         if(_verticalAlignProperty.equalHelper(this.verticalAlign,param1.verticalAlign))
         {
            this.verticalAlign = undefined;
         }
         if(_blockProgressionProperty.equalHelper(this.blockProgression,param1.blockProgression))
         {
            this.blockProgression = undefined;
         }
         if(_lineBreakProperty.equalHelper(this.lineBreak,param1.lineBreak))
         {
            this.lineBreak = undefined;
         }
      }
      
      public function removeClashing(param1:ITextLayoutFormat) : void
      {
         var _loc3_:* = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:TextLayoutFormatValueHolder = param1 as TextLayoutFormatValueHolder;
         if(_loc2_)
         {
            for(_loc3_ in _loc2_.coreStyles)
            {
               if(!description[_loc3_].equalHelper(this[_loc3_],_loc2_.coreStyles[_loc3_]))
               {
                  this[_loc3_] = undefined;
               }
            }
            return;
         }
         if(!_colorProperty.equalHelper(this.color,param1.color))
         {
            this.color = undefined;
         }
         if(!_backgroundColorProperty.equalHelper(this.backgroundColor,param1.backgroundColor))
         {
            this.backgroundColor = undefined;
         }
         if(!_lineThroughProperty.equalHelper(this.lineThrough,param1.lineThrough))
         {
            this.lineThrough = undefined;
         }
         if(!_textAlphaProperty.equalHelper(this.textAlpha,param1.textAlpha))
         {
            this.textAlpha = undefined;
         }
         if(!_backgroundAlphaProperty.equalHelper(this.backgroundAlpha,param1.backgroundAlpha))
         {
            this.backgroundAlpha = undefined;
         }
         if(!_fontSizeProperty.equalHelper(this.fontSize,param1.fontSize))
         {
            this.fontSize = undefined;
         }
         if(!_baselineShiftProperty.equalHelper(this.baselineShift,param1.baselineShift))
         {
            this.baselineShift = undefined;
         }
         if(!_trackingLeftProperty.equalHelper(this.trackingLeft,param1.trackingLeft))
         {
            this.trackingLeft = undefined;
         }
         if(!_trackingRightProperty.equalHelper(this.trackingRight,param1.trackingRight))
         {
            this.trackingRight = undefined;
         }
         if(!_lineHeightProperty.equalHelper(this.lineHeight,param1.lineHeight))
         {
            this.lineHeight = undefined;
         }
         if(!_breakOpportunityProperty.equalHelper(this.breakOpportunity,param1.breakOpportunity))
         {
            this.breakOpportunity = undefined;
         }
         if(!_digitCaseProperty.equalHelper(this.digitCase,param1.digitCase))
         {
            this.digitCase = undefined;
         }
         if(!_digitWidthProperty.equalHelper(this.digitWidth,param1.digitWidth))
         {
            this.digitWidth = undefined;
         }
         if(!_dominantBaselineProperty.equalHelper(this.dominantBaseline,param1.dominantBaseline))
         {
            this.dominantBaseline = undefined;
         }
         if(!_kerningProperty.equalHelper(this.kerning,param1.kerning))
         {
            this.kerning = undefined;
         }
         if(!_ligatureLevelProperty.equalHelper(this.ligatureLevel,param1.ligatureLevel))
         {
            this.ligatureLevel = undefined;
         }
         if(!_alignmentBaselineProperty.equalHelper(this.alignmentBaseline,param1.alignmentBaseline))
         {
            this.alignmentBaseline = undefined;
         }
         if(!_localeProperty.equalHelper(this.locale,param1.locale))
         {
            this.locale = undefined;
         }
         if(!_typographicCaseProperty.equalHelper(this.typographicCase,param1.typographicCase))
         {
            this.typographicCase = undefined;
         }
         if(!_fontFamilyProperty.equalHelper(this.fontFamily,param1.fontFamily))
         {
            this.fontFamily = undefined;
         }
         if(!_textDecorationProperty.equalHelper(this.textDecoration,param1.textDecoration))
         {
            this.textDecoration = undefined;
         }
         if(!_fontWeightProperty.equalHelper(this.fontWeight,param1.fontWeight))
         {
            this.fontWeight = undefined;
         }
         if(!_fontStyleProperty.equalHelper(this.fontStyle,param1.fontStyle))
         {
            this.fontStyle = undefined;
         }
         if(!_whiteSpaceCollapseProperty.equalHelper(this.whiteSpaceCollapse,param1.whiteSpaceCollapse))
         {
            this.whiteSpaceCollapse = undefined;
         }
         if(!_renderingModeProperty.equalHelper(this.renderingMode,param1.renderingMode))
         {
            this.renderingMode = undefined;
         }
         if(!_cffHintingProperty.equalHelper(this.cffHinting,param1.cffHinting))
         {
            this.cffHinting = undefined;
         }
         if(!_fontLookupProperty.equalHelper(this.fontLookup,param1.fontLookup))
         {
            this.fontLookup = undefined;
         }
         if(!_textRotationProperty.equalHelper(this.textRotation,param1.textRotation))
         {
            this.textRotation = undefined;
         }
         if(!_textIndentProperty.equalHelper(this.textIndent,param1.textIndent))
         {
            this.textIndent = undefined;
         }
         if(!_paragraphStartIndentProperty.equalHelper(this.paragraphStartIndent,param1.paragraphStartIndent))
         {
            this.paragraphStartIndent = undefined;
         }
         if(!_paragraphEndIndentProperty.equalHelper(this.paragraphEndIndent,param1.paragraphEndIndent))
         {
            this.paragraphEndIndent = undefined;
         }
         if(!_paragraphSpaceBeforeProperty.equalHelper(this.paragraphSpaceBefore,param1.paragraphSpaceBefore))
         {
            this.paragraphSpaceBefore = undefined;
         }
         if(!_paragraphSpaceAfterProperty.equalHelper(this.paragraphSpaceAfter,param1.paragraphSpaceAfter))
         {
            this.paragraphSpaceAfter = undefined;
         }
         if(!_textAlignProperty.equalHelper(this.textAlign,param1.textAlign))
         {
            this.textAlign = undefined;
         }
         if(!_textAlignLastProperty.equalHelper(this.textAlignLast,param1.textAlignLast))
         {
            this.textAlignLast = undefined;
         }
         if(!_textJustifyProperty.equalHelper(this.textJustify,param1.textJustify))
         {
            this.textJustify = undefined;
         }
         if(!_justificationRuleProperty.equalHelper(this.justificationRule,param1.justificationRule))
         {
            this.justificationRule = undefined;
         }
         if(!_justificationStyleProperty.equalHelper(this.justificationStyle,param1.justificationStyle))
         {
            this.justificationStyle = undefined;
         }
         if(!_directionProperty.equalHelper(this.direction,param1.direction))
         {
            this.direction = undefined;
         }
         if(!_tabStopsProperty.equalHelper(this.tabStops,param1.tabStops))
         {
            this.tabStops = undefined;
         }
         if(!_leadingModelProperty.equalHelper(this.leadingModel,param1.leadingModel))
         {
            this.leadingModel = undefined;
         }
         if(!_columnGapProperty.equalHelper(this.columnGap,param1.columnGap))
         {
            this.columnGap = undefined;
         }
         if(!_paddingLeftProperty.equalHelper(this.paddingLeft,param1.paddingLeft))
         {
            this.paddingLeft = undefined;
         }
         if(!_paddingTopProperty.equalHelper(this.paddingTop,param1.paddingTop))
         {
            this.paddingTop = undefined;
         }
         if(!_paddingRightProperty.equalHelper(this.paddingRight,param1.paddingRight))
         {
            this.paddingRight = undefined;
         }
         if(!_paddingBottomProperty.equalHelper(this.paddingBottom,param1.paddingBottom))
         {
            this.paddingBottom = undefined;
         }
         if(!_columnCountProperty.equalHelper(this.columnCount,param1.columnCount))
         {
            this.columnCount = undefined;
         }
         if(!_columnWidthProperty.equalHelper(this.columnWidth,param1.columnWidth))
         {
            this.columnWidth = undefined;
         }
         if(!_firstBaselineOffsetProperty.equalHelper(this.firstBaselineOffset,param1.firstBaselineOffset))
         {
            this.firstBaselineOffset = undefined;
         }
         if(!_verticalAlignProperty.equalHelper(this.verticalAlign,param1.verticalAlign))
         {
            this.verticalAlign = undefined;
         }
         if(!_blockProgressionProperty.equalHelper(this.blockProgression,param1.blockProgression))
         {
            this.blockProgression = undefined;
         }
         if(!_lineBreakProperty.equalHelper(this.lineBreak,param1.lineBreak))
         {
            this.lineBreak = undefined;
         }
      }
   }
}
