package flashx.textLayout.formats
{
   import flashx.textLayout.property.Property;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TextLayoutFormatValueHolder implements ITextLayoutFormat
   {
      
      private static const emptyCoreStyles:Object = new Object();
       
      
      private var _coreStyles:Object;
      
      public function TextLayoutFormatValueHolder(param1:ITextLayoutFormat = null)
      {
         super();
         this._coreStyles = emptyCoreStyles;
         this.initialize(param1);
      }
      
      public static function resetModifiedNoninheritedStyles(param1:Object) : void
      {
         if(param1.backgroundColor != TextLayoutFormat.backgroundColorProperty.defaultValue)
         {
            param1.backgroundColor = TextLayoutFormat.backgroundColorProperty.defaultValue;
         }
         if(param1.backgroundAlpha != TextLayoutFormat.backgroundAlphaProperty.defaultValue)
         {
            param1.backgroundAlpha = TextLayoutFormat.backgroundAlphaProperty.defaultValue;
         }
         if(param1.columnGap != TextLayoutFormat.columnGapProperty.defaultValue)
         {
            param1.columnGap = TextLayoutFormat.columnGapProperty.defaultValue;
         }
         if(param1.paddingLeft != TextLayoutFormat.paddingLeftProperty.defaultValue)
         {
            param1.paddingLeft = TextLayoutFormat.paddingLeftProperty.defaultValue;
         }
         if(param1.paddingTop != TextLayoutFormat.paddingTopProperty.defaultValue)
         {
            param1.paddingTop = TextLayoutFormat.paddingTopProperty.defaultValue;
         }
         if(param1.paddingRight != TextLayoutFormat.paddingRightProperty.defaultValue)
         {
            param1.paddingRight = TextLayoutFormat.paddingRightProperty.defaultValue;
         }
         if(param1.paddingBottom != TextLayoutFormat.paddingBottomProperty.defaultValue)
         {
            param1.paddingBottom = TextLayoutFormat.paddingBottomProperty.defaultValue;
         }
         if(param1.columnCount != TextLayoutFormat.columnCountProperty.defaultValue)
         {
            param1.columnCount = TextLayoutFormat.columnCountProperty.defaultValue;
         }
         if(param1.columnWidth != TextLayoutFormat.columnWidthProperty.defaultValue)
         {
            param1.columnWidth = TextLayoutFormat.columnWidthProperty.defaultValue;
         }
         if(param1.verticalAlign != TextLayoutFormat.verticalAlignProperty.defaultValue)
         {
            param1.verticalAlign = TextLayoutFormat.verticalAlignProperty.defaultValue;
         }
         if(param1.lineBreak != TextLayoutFormat.lineBreakProperty.defaultValue)
         {
            param1.lineBreak = TextLayoutFormat.lineBreakProperty.defaultValue;
         }
      }
      
      private function initialize(param1:ITextLayoutFormat) : void
      {
         var _loc2_:Property = null;
         var _loc3_:* = undefined;
         var _loc4_:TextLayoutFormatValueHolder = null;
         var _loc5_:Object = null;
         var _loc6_:* = null;
         if(param1)
         {
            _loc4_ = param1 as TextLayoutFormatValueHolder;
            if(_loc4_)
            {
               _loc5_ = _loc4_._coreStyles;
               for(_loc6_ in _loc5_)
               {
                  this.writableCoreStyles()[_loc6_] = _loc5_[_loc6_];
               }
            }
            else if(param1 is TextLayoutFormat)
            {
               for each(_loc2_ in TextLayoutFormat.description)
               {
                  _loc3_ = param1[_loc2_.name];
                  if(_loc3_ !== undefined)
                  {
                     this.writableCoreStyles()[_loc2_.name] = _loc3_;
                  }
               }
            }
            else
            {
               for each(_loc2_ in TextLayoutFormat.description)
               {
                  _loc3_ = param1[_loc2_.name];
                  if(_loc3_ !== undefined)
                  {
                     this[_loc2_.name] = _loc3_;
                  }
               }
            }
         }
      }
      
      private function writableCoreStyles() : Object
      {
         if(this._coreStyles == emptyCoreStyles)
         {
            this._coreStyles = new Object();
         }
         return this._coreStyles;
      }
      
      public function get coreStyles() : Object
      {
         return this._coreStyles == emptyCoreStyles?null:this._coreStyles;
      }
      
      public function set coreStyles(param1:Object) : void
      {
         this._coreStyles = !!param1?param1:emptyCoreStyles;
      }
      
      private function getCoreStyle(param1:String) : *
      {
         return this._coreStyles[param1];
      }
      
      private function setCoreStyle(param1:Property, param2:*, param3:*) : void
      {
         param3 = param1.setHelper(param2,param3);
         if(param3 !== undefined)
         {
            this.writableCoreStyles()[param1.name] = param3;
         }
         else
         {
            delete this._coreStyles[param1.name];
         }
      }
      
      public function set format(param1:ITextLayoutFormat) : void
      {
         var _loc3_:* = undefined;
         if(param1 == null)
         {
            this._coreStyles = emptyCoreStyles;
            return;
         }
         var _loc2_:TextLayoutFormatValueHolder = param1 as TextLayoutFormatValueHolder;
         if(_loc2_)
         {
            this._coreStyles = _loc2_._coreStyles == emptyCoreStyles?emptyCoreStyles:Property.shallowCopy(_loc2_._coreStyles);
            return;
         }
         this._coreStyles = emptyCoreStyles;
         if((_loc3_ = param1.color) !== undefined)
         {
            this.color = _loc3_;
         }
         if((_loc3_ = param1.backgroundColor) !== undefined)
         {
            this.backgroundColor = _loc3_;
         }
         if((_loc3_ = param1.lineThrough) !== undefined)
         {
            this.lineThrough = _loc3_;
         }
         if((_loc3_ = param1.textAlpha) !== undefined)
         {
            this.textAlpha = _loc3_;
         }
         if((_loc3_ = param1.backgroundAlpha) !== undefined)
         {
            this.backgroundAlpha = _loc3_;
         }
         if((_loc3_ = param1.fontSize) !== undefined)
         {
            this.fontSize = _loc3_;
         }
         if((_loc3_ = param1.baselineShift) !== undefined)
         {
            this.baselineShift = _loc3_;
         }
         if((_loc3_ = param1.trackingLeft) !== undefined)
         {
            this.trackingLeft = _loc3_;
         }
         if((_loc3_ = param1.trackingRight) !== undefined)
         {
            this.trackingRight = _loc3_;
         }
         if((_loc3_ = param1.lineHeight) !== undefined)
         {
            this.lineHeight = _loc3_;
         }
         if((_loc3_ = param1.breakOpportunity) !== undefined)
         {
            this.breakOpportunity = _loc3_;
         }
         if((_loc3_ = param1.digitCase) !== undefined)
         {
            this.digitCase = _loc3_;
         }
         if((_loc3_ = param1.digitWidth) !== undefined)
         {
            this.digitWidth = _loc3_;
         }
         if((_loc3_ = param1.dominantBaseline) !== undefined)
         {
            this.dominantBaseline = _loc3_;
         }
         if((_loc3_ = param1.kerning) !== undefined)
         {
            this.kerning = _loc3_;
         }
         if((_loc3_ = param1.ligatureLevel) !== undefined)
         {
            this.ligatureLevel = _loc3_;
         }
         if((_loc3_ = param1.alignmentBaseline) !== undefined)
         {
            this.alignmentBaseline = _loc3_;
         }
         if((_loc3_ = param1.locale) !== undefined)
         {
            this.locale = _loc3_;
         }
         if((_loc3_ = param1.typographicCase) !== undefined)
         {
            this.typographicCase = _loc3_;
         }
         if((_loc3_ = param1.fontFamily) !== undefined)
         {
            this.fontFamily = _loc3_;
         }
         if((_loc3_ = param1.textDecoration) !== undefined)
         {
            this.textDecoration = _loc3_;
         }
         if((_loc3_ = param1.fontWeight) !== undefined)
         {
            this.fontWeight = _loc3_;
         }
         if((_loc3_ = param1.fontStyle) !== undefined)
         {
            this.fontStyle = _loc3_;
         }
         if((_loc3_ = param1.whiteSpaceCollapse) !== undefined)
         {
            this.whiteSpaceCollapse = _loc3_;
         }
         if((_loc3_ = param1.renderingMode) !== undefined)
         {
            this.renderingMode = _loc3_;
         }
         if((_loc3_ = param1.cffHinting) !== undefined)
         {
            this.cffHinting = _loc3_;
         }
         if((_loc3_ = param1.fontLookup) !== undefined)
         {
            this.fontLookup = _loc3_;
         }
         if((_loc3_ = param1.textRotation) !== undefined)
         {
            this.textRotation = _loc3_;
         }
         if((_loc3_ = param1.textIndent) !== undefined)
         {
            this.textIndent = _loc3_;
         }
         if((_loc3_ = param1.paragraphStartIndent) !== undefined)
         {
            this.paragraphStartIndent = _loc3_;
         }
         if((_loc3_ = param1.paragraphEndIndent) !== undefined)
         {
            this.paragraphEndIndent = _loc3_;
         }
         if((_loc3_ = param1.paragraphSpaceBefore) !== undefined)
         {
            this.paragraphSpaceBefore = _loc3_;
         }
         if((_loc3_ = param1.paragraphSpaceAfter) !== undefined)
         {
            this.paragraphSpaceAfter = _loc3_;
         }
         if((_loc3_ = param1.textAlign) !== undefined)
         {
            this.textAlign = _loc3_;
         }
         if((_loc3_ = param1.textAlignLast) !== undefined)
         {
            this.textAlignLast = _loc3_;
         }
         if((_loc3_ = param1.textJustify) !== undefined)
         {
            this.textJustify = _loc3_;
         }
         if((_loc3_ = param1.justificationRule) !== undefined)
         {
            this.justificationRule = _loc3_;
         }
         if((_loc3_ = param1.justificationStyle) !== undefined)
         {
            this.justificationStyle = _loc3_;
         }
         if((_loc3_ = param1.direction) !== undefined)
         {
            this.direction = _loc3_;
         }
         if((_loc3_ = param1.tabStops) !== undefined)
         {
            this.tabStops = _loc3_;
         }
         if((_loc3_ = param1.leadingModel) !== undefined)
         {
            this.leadingModel = _loc3_;
         }
         if((_loc3_ = param1.columnGap) !== undefined)
         {
            this.columnGap = _loc3_;
         }
         if((_loc3_ = param1.paddingLeft) !== undefined)
         {
            this.paddingLeft = _loc3_;
         }
         if((_loc3_ = param1.paddingTop) !== undefined)
         {
            this.paddingTop = _loc3_;
         }
         if((_loc3_ = param1.paddingRight) !== undefined)
         {
            this.paddingRight = _loc3_;
         }
         if((_loc3_ = param1.paddingBottom) !== undefined)
         {
            this.paddingBottom = _loc3_;
         }
         if((_loc3_ = param1.columnCount) !== undefined)
         {
            this.columnCount = _loc3_;
         }
         if((_loc3_ = param1.columnWidth) !== undefined)
         {
            this.columnWidth = _loc3_;
         }
         if((_loc3_ = param1.firstBaselineOffset) !== undefined)
         {
            this.firstBaselineOffset = _loc3_;
         }
         if((_loc3_ = param1.verticalAlign) !== undefined)
         {
            this.verticalAlign = _loc3_;
         }
         if((_loc3_ = param1.blockProgression) !== undefined)
         {
            this.blockProgression = _loc3_;
         }
         if((_loc3_ = param1.lineBreak) !== undefined)
         {
            this.lineBreak = _loc3_;
         }
      }
      
      public function concat(param1:ITextLayoutFormat) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = null;
         var _loc2_:TextLayoutFormatValueHolder = param1 as TextLayoutFormatValueHolder;
         if(_loc2_)
         {
            _loc3_ = _loc2_._coreStyles;
            for(_loc4_ in _loc3_)
            {
               this[_loc4_] = TextLayoutFormat.description[_loc4_].concatHelper(this[_loc4_],_loc3_[_loc4_]);
            }
            return;
         }
         this.color = TextLayoutFormat.colorProperty.concatHelper(this.color,param1.color);
         this.backgroundColor = TextLayoutFormat.backgroundColorProperty.concatHelper(this.backgroundColor,param1.backgroundColor);
         this.lineThrough = TextLayoutFormat.lineThroughProperty.concatHelper(this.lineThrough,param1.lineThrough);
         this.textAlpha = TextLayoutFormat.textAlphaProperty.concatHelper(this.textAlpha,param1.textAlpha);
         this.backgroundAlpha = TextLayoutFormat.backgroundAlphaProperty.concatHelper(this.backgroundAlpha,param1.backgroundAlpha);
         this.fontSize = TextLayoutFormat.fontSizeProperty.concatHelper(this.fontSize,param1.fontSize);
         this.baselineShift = TextLayoutFormat.baselineShiftProperty.concatHelper(this.baselineShift,param1.baselineShift);
         this.trackingLeft = TextLayoutFormat.trackingLeftProperty.concatHelper(this.trackingLeft,param1.trackingLeft);
         this.trackingRight = TextLayoutFormat.trackingRightProperty.concatHelper(this.trackingRight,param1.trackingRight);
         this.lineHeight = TextLayoutFormat.lineHeightProperty.concatHelper(this.lineHeight,param1.lineHeight);
         this.breakOpportunity = TextLayoutFormat.breakOpportunityProperty.concatHelper(this.breakOpportunity,param1.breakOpportunity);
         this.digitCase = TextLayoutFormat.digitCaseProperty.concatHelper(this.digitCase,param1.digitCase);
         this.digitWidth = TextLayoutFormat.digitWidthProperty.concatHelper(this.digitWidth,param1.digitWidth);
         this.dominantBaseline = TextLayoutFormat.dominantBaselineProperty.concatHelper(this.dominantBaseline,param1.dominantBaseline);
         this.kerning = TextLayoutFormat.kerningProperty.concatHelper(this.kerning,param1.kerning);
         this.ligatureLevel = TextLayoutFormat.ligatureLevelProperty.concatHelper(this.ligatureLevel,param1.ligatureLevel);
         this.alignmentBaseline = TextLayoutFormat.alignmentBaselineProperty.concatHelper(this.alignmentBaseline,param1.alignmentBaseline);
         this.locale = TextLayoutFormat.localeProperty.concatHelper(this.locale,param1.locale);
         this.typographicCase = TextLayoutFormat.typographicCaseProperty.concatHelper(this.typographicCase,param1.typographicCase);
         this.fontFamily = TextLayoutFormat.fontFamilyProperty.concatHelper(this.fontFamily,param1.fontFamily);
         this.textDecoration = TextLayoutFormat.textDecorationProperty.concatHelper(this.textDecoration,param1.textDecoration);
         this.fontWeight = TextLayoutFormat.fontWeightProperty.concatHelper(this.fontWeight,param1.fontWeight);
         this.fontStyle = TextLayoutFormat.fontStyleProperty.concatHelper(this.fontStyle,param1.fontStyle);
         this.whiteSpaceCollapse = TextLayoutFormat.whiteSpaceCollapseProperty.concatHelper(this.whiteSpaceCollapse,param1.whiteSpaceCollapse);
         this.renderingMode = TextLayoutFormat.renderingModeProperty.concatHelper(this.renderingMode,param1.renderingMode);
         this.cffHinting = TextLayoutFormat.cffHintingProperty.concatHelper(this.cffHinting,param1.cffHinting);
         this.fontLookup = TextLayoutFormat.fontLookupProperty.concatHelper(this.fontLookup,param1.fontLookup);
         this.textRotation = TextLayoutFormat.textRotationProperty.concatHelper(this.textRotation,param1.textRotation);
         this.textIndent = TextLayoutFormat.textIndentProperty.concatHelper(this.textIndent,param1.textIndent);
         this.paragraphStartIndent = TextLayoutFormat.paragraphStartIndentProperty.concatHelper(this.paragraphStartIndent,param1.paragraphStartIndent);
         this.paragraphEndIndent = TextLayoutFormat.paragraphEndIndentProperty.concatHelper(this.paragraphEndIndent,param1.paragraphEndIndent);
         this.paragraphSpaceBefore = TextLayoutFormat.paragraphSpaceBeforeProperty.concatHelper(this.paragraphSpaceBefore,param1.paragraphSpaceBefore);
         this.paragraphSpaceAfter = TextLayoutFormat.paragraphSpaceAfterProperty.concatHelper(this.paragraphSpaceAfter,param1.paragraphSpaceAfter);
         this.textAlign = TextLayoutFormat.textAlignProperty.concatHelper(this.textAlign,param1.textAlign);
         this.textAlignLast = TextLayoutFormat.textAlignLastProperty.concatHelper(this.textAlignLast,param1.textAlignLast);
         this.textJustify = TextLayoutFormat.textJustifyProperty.concatHelper(this.textJustify,param1.textJustify);
         this.justificationRule = TextLayoutFormat.justificationRuleProperty.concatHelper(this.justificationRule,param1.justificationRule);
         this.justificationStyle = TextLayoutFormat.justificationStyleProperty.concatHelper(this.justificationStyle,param1.justificationStyle);
         this.direction = TextLayoutFormat.directionProperty.concatHelper(this.direction,param1.direction);
         this.tabStops = TextLayoutFormat.tabStopsProperty.concatHelper(this.tabStops,param1.tabStops);
         this.leadingModel = TextLayoutFormat.leadingModelProperty.concatHelper(this.leadingModel,param1.leadingModel);
         this.columnGap = TextLayoutFormat.columnGapProperty.concatHelper(this.columnGap,param1.columnGap);
         this.paddingLeft = TextLayoutFormat.paddingLeftProperty.concatHelper(this.paddingLeft,param1.paddingLeft);
         this.paddingTop = TextLayoutFormat.paddingTopProperty.concatHelper(this.paddingTop,param1.paddingTop);
         this.paddingRight = TextLayoutFormat.paddingRightProperty.concatHelper(this.paddingRight,param1.paddingRight);
         this.paddingBottom = TextLayoutFormat.paddingBottomProperty.concatHelper(this.paddingBottom,param1.paddingBottom);
         this.columnCount = TextLayoutFormat.columnCountProperty.concatHelper(this.columnCount,param1.columnCount);
         this.columnWidth = TextLayoutFormat.columnWidthProperty.concatHelper(this.columnWidth,param1.columnWidth);
         this.firstBaselineOffset = TextLayoutFormat.firstBaselineOffsetProperty.concatHelper(this.firstBaselineOffset,param1.firstBaselineOffset);
         this.verticalAlign = TextLayoutFormat.verticalAlignProperty.concatHelper(this.verticalAlign,param1.verticalAlign);
         this.blockProgression = TextLayoutFormat.blockProgressionProperty.concatHelper(this.blockProgression,param1.blockProgression);
         this.lineBreak = TextLayoutFormat.lineBreakProperty.concatHelper(this.lineBreak,param1.lineBreak);
      }
      
      public function concatInheritOnly(param1:ITextLayoutFormat) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = null;
         var _loc2_:TextLayoutFormatValueHolder = param1 as TextLayoutFormatValueHolder;
         if(_loc2_)
         {
            _loc3_ = _loc2_._coreStyles;
            for(_loc4_ in _loc3_)
            {
               this[_loc4_] = TextLayoutFormat.description[_loc4_].concatInheritOnlyHelper(this[_loc4_],_loc3_[_loc4_]);
            }
            return;
         }
         this.color = TextLayoutFormat.colorProperty.concatInheritOnlyHelper(this.color,param1.color);
         this.backgroundColor = TextLayoutFormat.backgroundColorProperty.concatInheritOnlyHelper(this.backgroundColor,param1.backgroundColor);
         this.lineThrough = TextLayoutFormat.lineThroughProperty.concatInheritOnlyHelper(this.lineThrough,param1.lineThrough);
         this.textAlpha = TextLayoutFormat.textAlphaProperty.concatInheritOnlyHelper(this.textAlpha,param1.textAlpha);
         this.backgroundAlpha = TextLayoutFormat.backgroundAlphaProperty.concatInheritOnlyHelper(this.backgroundAlpha,param1.backgroundAlpha);
         this.fontSize = TextLayoutFormat.fontSizeProperty.concatInheritOnlyHelper(this.fontSize,param1.fontSize);
         this.baselineShift = TextLayoutFormat.baselineShiftProperty.concatInheritOnlyHelper(this.baselineShift,param1.baselineShift);
         this.trackingLeft = TextLayoutFormat.trackingLeftProperty.concatInheritOnlyHelper(this.trackingLeft,param1.trackingLeft);
         this.trackingRight = TextLayoutFormat.trackingRightProperty.concatInheritOnlyHelper(this.trackingRight,param1.trackingRight);
         this.lineHeight = TextLayoutFormat.lineHeightProperty.concatInheritOnlyHelper(this.lineHeight,param1.lineHeight);
         this.breakOpportunity = TextLayoutFormat.breakOpportunityProperty.concatInheritOnlyHelper(this.breakOpportunity,param1.breakOpportunity);
         this.digitCase = TextLayoutFormat.digitCaseProperty.concatInheritOnlyHelper(this.digitCase,param1.digitCase);
         this.digitWidth = TextLayoutFormat.digitWidthProperty.concatInheritOnlyHelper(this.digitWidth,param1.digitWidth);
         this.dominantBaseline = TextLayoutFormat.dominantBaselineProperty.concatInheritOnlyHelper(this.dominantBaseline,param1.dominantBaseline);
         this.kerning = TextLayoutFormat.kerningProperty.concatInheritOnlyHelper(this.kerning,param1.kerning);
         this.ligatureLevel = TextLayoutFormat.ligatureLevelProperty.concatInheritOnlyHelper(this.ligatureLevel,param1.ligatureLevel);
         this.alignmentBaseline = TextLayoutFormat.alignmentBaselineProperty.concatInheritOnlyHelper(this.alignmentBaseline,param1.alignmentBaseline);
         this.locale = TextLayoutFormat.localeProperty.concatInheritOnlyHelper(this.locale,param1.locale);
         this.typographicCase = TextLayoutFormat.typographicCaseProperty.concatInheritOnlyHelper(this.typographicCase,param1.typographicCase);
         this.fontFamily = TextLayoutFormat.fontFamilyProperty.concatInheritOnlyHelper(this.fontFamily,param1.fontFamily);
         this.textDecoration = TextLayoutFormat.textDecorationProperty.concatInheritOnlyHelper(this.textDecoration,param1.textDecoration);
         this.fontWeight = TextLayoutFormat.fontWeightProperty.concatInheritOnlyHelper(this.fontWeight,param1.fontWeight);
         this.fontStyle = TextLayoutFormat.fontStyleProperty.concatInheritOnlyHelper(this.fontStyle,param1.fontStyle);
         this.whiteSpaceCollapse = TextLayoutFormat.whiteSpaceCollapseProperty.concatInheritOnlyHelper(this.whiteSpaceCollapse,param1.whiteSpaceCollapse);
         this.renderingMode = TextLayoutFormat.renderingModeProperty.concatInheritOnlyHelper(this.renderingMode,param1.renderingMode);
         this.cffHinting = TextLayoutFormat.cffHintingProperty.concatInheritOnlyHelper(this.cffHinting,param1.cffHinting);
         this.fontLookup = TextLayoutFormat.fontLookupProperty.concatInheritOnlyHelper(this.fontLookup,param1.fontLookup);
         this.textRotation = TextLayoutFormat.textRotationProperty.concatInheritOnlyHelper(this.textRotation,param1.textRotation);
         this.textIndent = TextLayoutFormat.textIndentProperty.concatInheritOnlyHelper(this.textIndent,param1.textIndent);
         this.paragraphStartIndent = TextLayoutFormat.paragraphStartIndentProperty.concatInheritOnlyHelper(this.paragraphStartIndent,param1.paragraphStartIndent);
         this.paragraphEndIndent = TextLayoutFormat.paragraphEndIndentProperty.concatInheritOnlyHelper(this.paragraphEndIndent,param1.paragraphEndIndent);
         this.paragraphSpaceBefore = TextLayoutFormat.paragraphSpaceBeforeProperty.concatInheritOnlyHelper(this.paragraphSpaceBefore,param1.paragraphSpaceBefore);
         this.paragraphSpaceAfter = TextLayoutFormat.paragraphSpaceAfterProperty.concatInheritOnlyHelper(this.paragraphSpaceAfter,param1.paragraphSpaceAfter);
         this.textAlign = TextLayoutFormat.textAlignProperty.concatInheritOnlyHelper(this.textAlign,param1.textAlign);
         this.textAlignLast = TextLayoutFormat.textAlignLastProperty.concatInheritOnlyHelper(this.textAlignLast,param1.textAlignLast);
         this.textJustify = TextLayoutFormat.textJustifyProperty.concatInheritOnlyHelper(this.textJustify,param1.textJustify);
         this.justificationRule = TextLayoutFormat.justificationRuleProperty.concatInheritOnlyHelper(this.justificationRule,param1.justificationRule);
         this.justificationStyle = TextLayoutFormat.justificationStyleProperty.concatInheritOnlyHelper(this.justificationStyle,param1.justificationStyle);
         this.direction = TextLayoutFormat.directionProperty.concatInheritOnlyHelper(this.direction,param1.direction);
         this.tabStops = TextLayoutFormat.tabStopsProperty.concatInheritOnlyHelper(this.tabStops,param1.tabStops);
         this.leadingModel = TextLayoutFormat.leadingModelProperty.concatInheritOnlyHelper(this.leadingModel,param1.leadingModel);
         this.columnGap = TextLayoutFormat.columnGapProperty.concatInheritOnlyHelper(this.columnGap,param1.columnGap);
         this.paddingLeft = TextLayoutFormat.paddingLeftProperty.concatInheritOnlyHelper(this.paddingLeft,param1.paddingLeft);
         this.paddingTop = TextLayoutFormat.paddingTopProperty.concatInheritOnlyHelper(this.paddingTop,param1.paddingTop);
         this.paddingRight = TextLayoutFormat.paddingRightProperty.concatInheritOnlyHelper(this.paddingRight,param1.paddingRight);
         this.paddingBottom = TextLayoutFormat.paddingBottomProperty.concatInheritOnlyHelper(this.paddingBottom,param1.paddingBottom);
         this.columnCount = TextLayoutFormat.columnCountProperty.concatInheritOnlyHelper(this.columnCount,param1.columnCount);
         this.columnWidth = TextLayoutFormat.columnWidthProperty.concatInheritOnlyHelper(this.columnWidth,param1.columnWidth);
         this.firstBaselineOffset = TextLayoutFormat.firstBaselineOffsetProperty.concatInheritOnlyHelper(this.firstBaselineOffset,param1.firstBaselineOffset);
         this.verticalAlign = TextLayoutFormat.verticalAlignProperty.concatInheritOnlyHelper(this.verticalAlign,param1.verticalAlign);
         this.blockProgression = TextLayoutFormat.blockProgressionProperty.concatInheritOnlyHelper(this.blockProgression,param1.blockProgression);
         this.lineBreak = TextLayoutFormat.lineBreakProperty.concatInheritOnlyHelper(this.lineBreak,param1.lineBreak);
      }
      
      public function apply(param1:ITextLayoutFormat) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         var _loc2_:TextLayoutFormatValueHolder = param1 as TextLayoutFormatValueHolder;
         if(_loc2_)
         {
            _loc4_ = _loc2_._coreStyles;
            for(_loc5_ in _loc4_)
            {
               this[_loc5_] = _loc4_[_loc5_];
            }
            return;
         }
         if((_loc3_ = param1.color) !== undefined)
         {
            this.color = _loc3_;
         }
         if((_loc3_ = param1.backgroundColor) !== undefined)
         {
            this.backgroundColor = _loc3_;
         }
         if((_loc3_ = param1.lineThrough) !== undefined)
         {
            this.lineThrough = _loc3_;
         }
         if((_loc3_ = param1.textAlpha) !== undefined)
         {
            this.textAlpha = _loc3_;
         }
         if((_loc3_ = param1.backgroundAlpha) !== undefined)
         {
            this.backgroundAlpha = _loc3_;
         }
         if((_loc3_ = param1.fontSize) !== undefined)
         {
            this.fontSize = _loc3_;
         }
         if((_loc3_ = param1.baselineShift) !== undefined)
         {
            this.baselineShift = _loc3_;
         }
         if((_loc3_ = param1.trackingLeft) !== undefined)
         {
            this.trackingLeft = _loc3_;
         }
         if((_loc3_ = param1.trackingRight) !== undefined)
         {
            this.trackingRight = _loc3_;
         }
         if((_loc3_ = param1.lineHeight) !== undefined)
         {
            this.lineHeight = _loc3_;
         }
         if((_loc3_ = param1.breakOpportunity) !== undefined)
         {
            this.breakOpportunity = _loc3_;
         }
         if((_loc3_ = param1.digitCase) !== undefined)
         {
            this.digitCase = _loc3_;
         }
         if((_loc3_ = param1.digitWidth) !== undefined)
         {
            this.digitWidth = _loc3_;
         }
         if((_loc3_ = param1.dominantBaseline) !== undefined)
         {
            this.dominantBaseline = _loc3_;
         }
         if((_loc3_ = param1.kerning) !== undefined)
         {
            this.kerning = _loc3_;
         }
         if((_loc3_ = param1.ligatureLevel) !== undefined)
         {
            this.ligatureLevel = _loc3_;
         }
         if((_loc3_ = param1.alignmentBaseline) !== undefined)
         {
            this.alignmentBaseline = _loc3_;
         }
         if((_loc3_ = param1.locale) !== undefined)
         {
            this.locale = _loc3_;
         }
         if((_loc3_ = param1.typographicCase) !== undefined)
         {
            this.typographicCase = _loc3_;
         }
         if((_loc3_ = param1.fontFamily) !== undefined)
         {
            this.fontFamily = _loc3_;
         }
         if((_loc3_ = param1.textDecoration) !== undefined)
         {
            this.textDecoration = _loc3_;
         }
         if((_loc3_ = param1.fontWeight) !== undefined)
         {
            this.fontWeight = _loc3_;
         }
         if((_loc3_ = param1.fontStyle) !== undefined)
         {
            this.fontStyle = _loc3_;
         }
         if((_loc3_ = param1.whiteSpaceCollapse) !== undefined)
         {
            this.whiteSpaceCollapse = _loc3_;
         }
         if((_loc3_ = param1.renderingMode) !== undefined)
         {
            this.renderingMode = _loc3_;
         }
         if((_loc3_ = param1.cffHinting) !== undefined)
         {
            this.cffHinting = _loc3_;
         }
         if((_loc3_ = param1.fontLookup) !== undefined)
         {
            this.fontLookup = _loc3_;
         }
         if((_loc3_ = param1.textRotation) !== undefined)
         {
            this.textRotation = _loc3_;
         }
         if((_loc3_ = param1.textIndent) !== undefined)
         {
            this.textIndent = _loc3_;
         }
         if((_loc3_ = param1.paragraphStartIndent) !== undefined)
         {
            this.paragraphStartIndent = _loc3_;
         }
         if((_loc3_ = param1.paragraphEndIndent) !== undefined)
         {
            this.paragraphEndIndent = _loc3_;
         }
         if((_loc3_ = param1.paragraphSpaceBefore) !== undefined)
         {
            this.paragraphSpaceBefore = _loc3_;
         }
         if((_loc3_ = param1.paragraphSpaceAfter) !== undefined)
         {
            this.paragraphSpaceAfter = _loc3_;
         }
         if((_loc3_ = param1.textAlign) !== undefined)
         {
            this.textAlign = _loc3_;
         }
         if((_loc3_ = param1.textAlignLast) !== undefined)
         {
            this.textAlignLast = _loc3_;
         }
         if((_loc3_ = param1.textJustify) !== undefined)
         {
            this.textJustify = _loc3_;
         }
         if((_loc3_ = param1.justificationRule) !== undefined)
         {
            this.justificationRule = _loc3_;
         }
         if((_loc3_ = param1.justificationStyle) !== undefined)
         {
            this.justificationStyle = _loc3_;
         }
         if((_loc3_ = param1.direction) !== undefined)
         {
            this.direction = _loc3_;
         }
         if((_loc3_ = param1.tabStops) !== undefined)
         {
            this.tabStops = _loc3_;
         }
         if((_loc3_ = param1.leadingModel) !== undefined)
         {
            this.leadingModel = _loc3_;
         }
         if((_loc3_ = param1.columnGap) !== undefined)
         {
            this.columnGap = _loc3_;
         }
         if((_loc3_ = param1.paddingLeft) !== undefined)
         {
            this.paddingLeft = _loc3_;
         }
         if((_loc3_ = param1.paddingTop) !== undefined)
         {
            this.paddingTop = _loc3_;
         }
         if((_loc3_ = param1.paddingRight) !== undefined)
         {
            this.paddingRight = _loc3_;
         }
         if((_loc3_ = param1.paddingBottom) !== undefined)
         {
            this.paddingBottom = _loc3_;
         }
         if((_loc3_ = param1.columnCount) !== undefined)
         {
            this.columnCount = _loc3_;
         }
         if((_loc3_ = param1.columnWidth) !== undefined)
         {
            this.columnWidth = _loc3_;
         }
         if((_loc3_ = param1.firstBaselineOffset) !== undefined)
         {
            this.firstBaselineOffset = _loc3_;
         }
         if((_loc3_ = param1.verticalAlign) !== undefined)
         {
            this.verticalAlign = _loc3_;
         }
         if((_loc3_ = param1.blockProgression) !== undefined)
         {
            this.blockProgression = _loc3_;
         }
         if((_loc3_ = param1.lineBreak) !== undefined)
         {
            this.lineBreak = _loc3_;
         }
      }
      
      public function get color() : *
      {
         return this._coreStyles.color;
      }
      
      public function set color(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.colorProperty,this.color,param1);
      }
      
      public function get backgroundColor() : *
      {
         return this._coreStyles.backgroundColor;
      }
      
      public function set backgroundColor(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.backgroundColorProperty,this.backgroundColor,param1);
      }
      
      public function get lineThrough() : *
      {
         return this._coreStyles.lineThrough;
      }
      
      public function set lineThrough(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.lineThroughProperty,this.lineThrough,param1);
      }
      
      public function get textAlpha() : *
      {
         return this._coreStyles.textAlpha;
      }
      
      public function set textAlpha(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.textAlphaProperty,this.textAlpha,param1);
      }
      
      public function get backgroundAlpha() : *
      {
         return this._coreStyles.backgroundAlpha;
      }
      
      public function set backgroundAlpha(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.backgroundAlphaProperty,this.backgroundAlpha,param1);
      }
      
      public function get fontSize() : *
      {
         return this._coreStyles.fontSize;
      }
      
      public function set fontSize(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.fontSizeProperty,this.fontSize,param1);
      }
      
      public function get baselineShift() : *
      {
         return this._coreStyles.baselineShift;
      }
      
      public function set baselineShift(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.baselineShiftProperty,this.baselineShift,param1);
      }
      
      public function get trackingLeft() : *
      {
         return this._coreStyles.trackingLeft;
      }
      
      public function set trackingLeft(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.trackingLeftProperty,this.trackingLeft,param1);
      }
      
      public function get trackingRight() : *
      {
         return this._coreStyles.trackingRight;
      }
      
      public function set trackingRight(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.trackingRightProperty,this.trackingRight,param1);
      }
      
      public function get lineHeight() : *
      {
         return this._coreStyles.lineHeight;
      }
      
      public function set lineHeight(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.lineHeightProperty,this.lineHeight,param1);
      }
      
      public function get breakOpportunity() : *
      {
         return this._coreStyles.breakOpportunity;
      }
      
      public function set breakOpportunity(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.breakOpportunityProperty,this.breakOpportunity,param1);
      }
      
      public function get digitCase() : *
      {
         return this._coreStyles.digitCase;
      }
      
      public function set digitCase(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.digitCaseProperty,this.digitCase,param1);
      }
      
      public function get digitWidth() : *
      {
         return this._coreStyles.digitWidth;
      }
      
      public function set digitWidth(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.digitWidthProperty,this.digitWidth,param1);
      }
      
      public function get dominantBaseline() : *
      {
         return this._coreStyles.dominantBaseline;
      }
      
      public function set dominantBaseline(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.dominantBaselineProperty,this.dominantBaseline,param1);
      }
      
      public function get kerning() : *
      {
         return this._coreStyles.kerning;
      }
      
      public function set kerning(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.kerningProperty,this.kerning,param1);
      }
      
      public function get ligatureLevel() : *
      {
         return this._coreStyles.ligatureLevel;
      }
      
      public function set ligatureLevel(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.ligatureLevelProperty,this.ligatureLevel,param1);
      }
      
      public function get alignmentBaseline() : *
      {
         return this._coreStyles.alignmentBaseline;
      }
      
      public function set alignmentBaseline(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.alignmentBaselineProperty,this.alignmentBaseline,param1);
      }
      
      public function get locale() : *
      {
         return this._coreStyles.locale;
      }
      
      public function set locale(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.localeProperty,this.locale,param1);
      }
      
      public function get typographicCase() : *
      {
         return this._coreStyles.typographicCase;
      }
      
      public function set typographicCase(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.typographicCaseProperty,this.typographicCase,param1);
      }
      
      public function get fontFamily() : *
      {
         return this._coreStyles.fontFamily;
      }
      
      public function set fontFamily(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.fontFamilyProperty,this.fontFamily,param1);
      }
      
      public function get textDecoration() : *
      {
         return this._coreStyles.textDecoration;
      }
      
      public function set textDecoration(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.textDecorationProperty,this.textDecoration,param1);
      }
      
      public function get fontWeight() : *
      {
         return this._coreStyles.fontWeight;
      }
      
      public function set fontWeight(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.fontWeightProperty,this.fontWeight,param1);
      }
      
      public function get fontStyle() : *
      {
         return this._coreStyles.fontStyle;
      }
      
      public function set fontStyle(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.fontStyleProperty,this.fontStyle,param1);
      }
      
      public function get whiteSpaceCollapse() : *
      {
         return this._coreStyles.whiteSpaceCollapse;
      }
      
      public function set whiteSpaceCollapse(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.whiteSpaceCollapseProperty,this.whiteSpaceCollapse,param1);
      }
      
      public function get renderingMode() : *
      {
         return this._coreStyles.renderingMode;
      }
      
      public function set renderingMode(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.renderingModeProperty,this.renderingMode,param1);
      }
      
      public function get cffHinting() : *
      {
         return this._coreStyles.cffHinting;
      }
      
      public function set cffHinting(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.cffHintingProperty,this.cffHinting,param1);
      }
      
      public function get fontLookup() : *
      {
         return this._coreStyles.fontLookup;
      }
      
      public function set fontLookup(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.fontLookupProperty,this.fontLookup,param1);
      }
      
      public function get textRotation() : *
      {
         return this._coreStyles.textRotation;
      }
      
      public function set textRotation(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.textRotationProperty,this.textRotation,param1);
      }
      
      public function get textIndent() : *
      {
         return this._coreStyles.textIndent;
      }
      
      public function set textIndent(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.textIndentProperty,this.textIndent,param1);
      }
      
      public function get paragraphStartIndent() : *
      {
         return this._coreStyles.paragraphStartIndent;
      }
      
      public function set paragraphStartIndent(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.paragraphStartIndentProperty,this.paragraphStartIndent,param1);
      }
      
      public function get paragraphEndIndent() : *
      {
         return this._coreStyles.paragraphEndIndent;
      }
      
      public function set paragraphEndIndent(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.paragraphEndIndentProperty,this.paragraphEndIndent,param1);
      }
      
      public function get paragraphSpaceBefore() : *
      {
         return this._coreStyles.paragraphSpaceBefore;
      }
      
      public function set paragraphSpaceBefore(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.paragraphSpaceBeforeProperty,this.paragraphSpaceBefore,param1);
      }
      
      public function get paragraphSpaceAfter() : *
      {
         return this._coreStyles.paragraphSpaceAfter;
      }
      
      public function set paragraphSpaceAfter(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.paragraphSpaceAfterProperty,this.paragraphSpaceAfter,param1);
      }
      
      public function get textAlign() : *
      {
         return this._coreStyles.textAlign;
      }
      
      public function set textAlign(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.textAlignProperty,this.textAlign,param1);
      }
      
      public function get textAlignLast() : *
      {
         return this._coreStyles.textAlignLast;
      }
      
      public function set textAlignLast(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.textAlignLastProperty,this.textAlignLast,param1);
      }
      
      public function get textJustify() : *
      {
         return this._coreStyles.textJustify;
      }
      
      public function set textJustify(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.textJustifyProperty,this.textJustify,param1);
      }
      
      public function get justificationRule() : *
      {
         return this._coreStyles.justificationRule;
      }
      
      public function set justificationRule(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.justificationRuleProperty,this.justificationRule,param1);
      }
      
      public function get justificationStyle() : *
      {
         return this._coreStyles.justificationStyle;
      }
      
      public function set justificationStyle(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.justificationStyleProperty,this.justificationStyle,param1);
      }
      
      public function get direction() : *
      {
         return this._coreStyles.direction;
      }
      
      public function set direction(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.directionProperty,this.direction,param1);
      }
      
      public function get tabStops() : *
      {
         return this._coreStyles.tabStops;
      }
      
      public function set tabStops(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.tabStopsProperty,this.tabStops,param1);
      }
      
      public function get leadingModel() : *
      {
         return this._coreStyles.leadingModel;
      }
      
      public function set leadingModel(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.leadingModelProperty,this.leadingModel,param1);
      }
      
      public function get columnGap() : *
      {
         return this._coreStyles.columnGap;
      }
      
      public function set columnGap(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.columnGapProperty,this.columnGap,param1);
      }
      
      public function get paddingLeft() : *
      {
         return this._coreStyles.paddingLeft;
      }
      
      public function set paddingLeft(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.paddingLeftProperty,this.paddingLeft,param1);
      }
      
      public function get paddingTop() : *
      {
         return this._coreStyles.paddingTop;
      }
      
      public function set paddingTop(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.paddingTopProperty,this.paddingTop,param1);
      }
      
      public function get paddingRight() : *
      {
         return this._coreStyles.paddingRight;
      }
      
      public function set paddingRight(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.paddingRightProperty,this.paddingRight,param1);
      }
      
      public function get paddingBottom() : *
      {
         return this._coreStyles.paddingBottom;
      }
      
      public function set paddingBottom(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.paddingBottomProperty,this.paddingBottom,param1);
      }
      
      public function get columnCount() : *
      {
         return this._coreStyles.columnCount;
      }
      
      public function set columnCount(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.columnCountProperty,this.columnCount,param1);
      }
      
      public function get columnWidth() : *
      {
         return this._coreStyles.columnWidth;
      }
      
      public function set columnWidth(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.columnWidthProperty,this.columnWidth,param1);
      }
      
      public function get firstBaselineOffset() : *
      {
         return this._coreStyles.firstBaselineOffset;
      }
      
      public function set firstBaselineOffset(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.firstBaselineOffsetProperty,this.firstBaselineOffset,param1);
      }
      
      public function get verticalAlign() : *
      {
         return this._coreStyles.verticalAlign;
      }
      
      public function set verticalAlign(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.verticalAlignProperty,this.verticalAlign,param1);
      }
      
      public function get blockProgression() : *
      {
         return this._coreStyles.blockProgression;
      }
      
      public function set blockProgression(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.blockProgressionProperty,this.blockProgression,param1);
      }
      
      public function get lineBreak() : *
      {
         return this._coreStyles.lineBreak;
      }
      
      public function set lineBreak(param1:*) : void
      {
         this.setCoreStyle(TextLayoutFormat.lineBreakProperty,this.lineBreak,param1);
      }
   }
}
