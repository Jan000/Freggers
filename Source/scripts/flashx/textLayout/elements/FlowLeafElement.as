package flashx.textLayout.elements
{
   import flash.display.Shape;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import flash.text.engine.ContentElement;
   import flash.text.engine.ElementFormat;
   import flash.text.engine.FontDescription;
   import flash.text.engine.FontMetrics;
   import flash.text.engine.TextBaseline;
   import flash.text.engine.TextElement;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextRotation;
   import flash.text.engine.TypographicCase;
   import flashx.textLayout.compose.FlowComposerBase;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.compose.ISWFContext;
   import flashx.textLayout.compose.StandardFlowComposer;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.formats.BackgroundColor;
   import flashx.textLayout.formats.BaselineShift;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.IMEStatus;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TLFTypographicCase;
   import flashx.textLayout.formats.TextDecoration;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   import flashx.textLayout.utils.CharacterUtil;
   import flashx.textLayout.utils.LocaleUtil;
   
   use namespace tlf_internal;
   
   public class FlowLeafElement extends FlowElement
   {
       
      
      protected var _blockElement:ContentElement;
      
      protected var _text:String;
      
      private var _hasAttachedListeners:Boolean;
      
      public function FlowLeafElement()
      {
         this._hasAttachedListeners = false;
         super();
      }
      
      override tlf_internal function createContentElement() : void
      {
         if(_computedFormat)
         {
            this._blockElement.elementFormat = this.computeElementFormat();
         }
         if(parent)
         {
            parent.insertBlockElement(this,this._blockElement);
         }
      }
      
      override tlf_internal function releaseContentElement() : void
      {
         if(!this.canReleaseContentElement() || this._blockElement == null)
         {
            return;
         }
         this._blockElement = null;
         if(_computedFormat)
         {
            _computedFormat = null;
         }
      }
      
      override tlf_internal function canReleaseContentElement() : Boolean
      {
         return !this._hasAttachedListeners;
      }
      
      private function blockElementExists() : Boolean
      {
         return this._blockElement != null;
      }
      
      tlf_internal function getBlockElement() : ContentElement
      {
         if(!this._blockElement)
         {
            this.createContentElement();
         }
         return this._blockElement;
      }
      
      public function get text() : String
      {
         return !!this._blockElement?this._blockElement.rawText:this._text;
      }
      
      tlf_internal function getElementFormat() : ElementFormat
      {
         if(!this._blockElement)
         {
            this.createContentElement();
         }
         return this._blockElement.elementFormat;
      }
      
      override tlf_internal function setParentAndRelativeStart(param1:FlowGroupElement, param2:int) : void
      {
         if(param1 == parent)
         {
            return;
         }
         var _loc3_:* = this._blockElement != null;
         if(this._blockElement && parent && parent.hasBlockElement())
         {
            parent.removeBlockElement(this,this._blockElement);
         }
         if(param1 && !param1.hasBlockElement() && this._blockElement)
         {
            param1.createContentElement();
         }
         super.setParentAndRelativeStart(param1,param2);
         if(parent)
         {
            if(parent.hasBlockElement())
            {
               if(!this._blockElement)
               {
                  this.createContentElement();
               }
               else if(_loc3_)
               {
                  parent.insertBlockElement(this,this._blockElement);
               }
            }
            else if(this._blockElement)
            {
               this.releaseContentElement();
            }
         }
      }
      
      protected function quickInitializeForSplit(param1:FlowLeafElement, param2:int, param3:TextElement) : void
      {
         setTextLength(param2);
         this._blockElement = param3;
         quickCloneTextLayoutFormat(param1);
         var _loc4_:TextFlow = param1.getTextFlow();
         if(_loc4_ == null || _loc4_.formatResolver == null)
         {
            _computedFormat = param1._computedFormat;
            if(this._blockElement)
            {
               this._blockElement.elementFormat = param1.getElementFormat();
            }
         }
      }
      
      tlf_internal function addParaTerminator() : void
      {
      }
      
      tlf_internal function removeParaTerminator() : void
      {
      }
      
      public function getNextLeaf(param1:FlowGroupElement = null) : FlowLeafElement
      {
         if(!parent)
         {
            return null;
         }
         return parent.getNextLeafHelper(param1,this);
      }
      
      public function getPreviousLeaf(param1:FlowGroupElement = null) : FlowLeafElement
      {
         if(!parent)
         {
            return null;
         }
         return parent.getPreviousLeafHelper(param1,this);
      }
      
      override public function getCharAtPosition(param1:int) : String
      {
         var _loc2_:String = !!this._blockElement?this._blockElement.rawText:this._text;
         if(_loc2_)
         {
            return _loc2_.charAt(param1);
         }
         return String("");
      }
      
      override tlf_internal function normalizeRange(param1:uint, param2:uint) : void
      {
         if(this._blockElement)
         {
            this.computedFormat;
         }
      }
      
      public function getComputedFontMetrics() : FontMetrics
      {
         if(!this._blockElement)
         {
            this.createContentElement();
         }
         var _loc1_:ElementFormat = this._blockElement.elementFormat;
         if(!_loc1_)
         {
            return null;
         }
         var _loc2_:TextFlow = getTextFlow();
         if(_loc2_ && _loc2_.flowComposer && _loc2_.flowComposer.swfContext)
         {
            return _loc2_.flowComposer.swfContext.callInContext(_loc1_.getFontMetrics,_loc1_,null,true);
         }
         return _loc1_.getFontMetrics();
      }
      
      private function resolveDomBaseline() : String
      {
         var _loc2_:ParagraphElement = null;
         var _loc1_:String = _computedFormat.dominantBaseline;
         if(_loc1_ == FormatValue.AUTO)
         {
            if(this.computedFormat.textRotation == TextRotation.ROTATE_270)
            {
               _loc1_ = TextBaseline.IDEOGRAPHIC_CENTER;
            }
            else
            {
               _loc2_ = getParagraph();
               if(_loc2_ != null)
               {
                  _loc1_ = _loc2_.getEffectiveDominantBaseline();
               }
               else
               {
                  _loc1_ = LocaleUtil.dominantBaseline(_computedFormat.locale);
               }
            }
         }
         return _loc1_;
      }
      
      private function computeElementFormat() : ElementFormat
      {
         var _loc4_:TextFlow = null;
         var _loc5_:IFlowComposer = null;
         var _loc6_:FontMetrics = null;
         var _loc7_:TextFlow = null;
         var _loc8_:ISWFContext = null;
         var _loc1_:ElementFormat = new ElementFormat();
         _loc1_.alignmentBaseline = _computedFormat.alignmentBaseline;
         _loc1_.alpha = Number(_computedFormat.textAlpha);
         _loc1_.breakOpportunity = _computedFormat.breakOpportunity;
         _loc1_.color = uint(_computedFormat.color);
         _loc1_.dominantBaseline = this.resolveDomBaseline();
         _loc1_.digitCase = _computedFormat.digitCase;
         _loc1_.digitWidth = _computedFormat.digitWidth;
         _loc1_.ligatureLevel = _computedFormat.ligatureLevel;
         _loc1_.fontSize = Number(_computedFormat.fontSize);
         _loc1_.kerning = _computedFormat.kerning;
         _loc1_.locale = _computedFormat.locale;
         _loc1_.trackingLeft = TextLayoutFormat.trackingLeftProperty.computeActualPropertyValue(_computedFormat.trackingLeft,_loc1_.fontSize);
         _loc1_.trackingRight = TextLayoutFormat.trackingRightProperty.computeActualPropertyValue(_computedFormat.trackingRight,_loc1_.fontSize);
         _loc1_.textRotation = _computedFormat.textRotation;
         _loc1_.baselineShift = -TextLayoutFormat.baselineShiftProperty.computeActualPropertyValue(_computedFormat.baselineShift,_loc1_.fontSize);
         switch(_computedFormat.typographicCase)
         {
            case TLFTypographicCase.LOWERCASE_TO_SMALL_CAPS:
               _loc1_.typographicCase = TypographicCase.CAPS_AND_SMALL_CAPS;
               break;
            case TLFTypographicCase.CAPS_TO_SMALL_CAPS:
               _loc1_.typographicCase = TypographicCase.SMALL_CAPS;
               break;
            default:
               _loc1_.typographicCase = _computedFormat.typographicCase;
         }
         var _loc2_:FontDescription = new FontDescription();
         _loc2_.fontWeight = _computedFormat.fontWeight;
         _loc2_.fontPosture = _computedFormat.fontStyle;
         _loc2_.fontName = _computedFormat.fontFamily;
         _loc2_.renderingMode = _computedFormat.renderingMode;
         _loc2_.cffHinting = _computedFormat.cffHinting;
         if(GlobalSettings.resolveFontLookupFunction != null)
         {
            _loc4_ = getTextFlow();
            if(_loc4_)
            {
               _loc5_ = _loc4_.flowComposer;
               _loc2_.fontLookup = GlobalSettings.resolveFontLookupFunction(!!_loc5_?FlowComposerBase.computeBaseSWFContext(_loc5_.swfContext):null,_computedFormat);
            }
            else
            {
               _loc2_.fontLookup = _computedFormat.fontLookup;
            }
         }
         else
         {
            _loc2_.fontLookup = _computedFormat.fontLookup;
         }
         var _loc3_:Function = GlobalSettings.fontMapperFunction;
         if(_loc3_ != null)
         {
            _loc3_(_loc2_);
         }
         _loc1_.fontDescription = _loc2_;
         if(_computedFormat.baselineShift == BaselineShift.SUPERSCRIPT || _computedFormat.baselineShift == BaselineShift.SUBSCRIPT)
         {
            _loc7_ = getTextFlow();
            _loc8_ = _loc7_ && _loc7_.flowComposer?_loc7_.flowComposer.swfContext:null;
            if(_loc8_)
            {
               _loc6_ = _loc8_.callInContext(_loc1_.getFontMetrics,_loc1_,null,true);
            }
            else
            {
               _loc6_ = _loc1_.getFontMetrics();
            }
            if(_computedFormat.baselineShift == BaselineShift.SUPERSCRIPT)
            {
               _loc1_.baselineShift = _loc6_.superscriptOffset * _loc1_.fontSize;
               _loc1_.fontSize = _loc6_.superscriptScale * _loc1_.fontSize;
            }
            else
            {
               _loc1_.baselineShift = _loc6_.subscriptOffset * _loc1_.fontSize;
               _loc1_.fontSize = _loc6_.subscriptScale * _loc1_.fontSize;
            }
         }
         return _loc1_;
      }
      
      override public function get computedFormat() : ITextLayoutFormat
      {
         if(!_computedFormat)
         {
            _computedFormat = doComputeTextLayoutFormat();
            if(this._blockElement)
            {
               this._blockElement.elementFormat = this.computeElementFormat();
            }
         }
         return _computedFormat;
      }
      
      tlf_internal function getEffectiveFontSize() : Number
      {
         return Number(this.computedFormat.fontSize);
      }
      
      tlf_internal function getSpanBoundsOnLine(param1:TextLine, param2:String) : Array
      {
         var _loc10_:String = null;
         var _loc3_:TextFlowLine = TextFlowLine(param1.userData);
         var _loc4_:int = _loc3_.paragraph.getAbsoluteStart();
         var _loc5_:int = _loc3_.absoluteStart + _loc3_.textLength - _loc4_;
         var _loc6_:int = getAbsoluteStart() - _loc4_;
         var _loc7_:int = _loc6_ + this.text.length;
         var _loc8_:int = Math.max(_loc6_,_loc3_.absoluteStart - _loc4_);
         if(_loc7_ >= _loc5_)
         {
            _loc7_ = _loc5_;
            _loc10_ = this.text;
            while(_loc7_ > _loc8_ && CharacterUtil.isWhitespace(_loc10_.charCodeAt(_loc7_ - _loc6_ - 1)))
            {
               _loc7_--;
            }
         }
         var _loc9_:Array = [];
         _loc3_.calculateSelectionBounds(param1,_loc9_,_loc8_,_loc7_,param2,[_loc3_.textHeight,0]);
         return _loc9_;
      }
      
      tlf_internal function updateIMEAdornments(param1:TextFlowLine, param2:String, param3:String) : void
      {
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Rectangle = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Shape = null;
         var _loc18_:int = 0;
         var _loc19_:TCYElement = null;
         var _loc20_:Rectangle = null;
         var _loc21_:Number = NaN;
         var _loc4_:TextLine = param1.getTextLine();
         var _loc5_:FontMetrics = this.getComputedFontMetrics();
         var _loc6_:Array = this.getSpanBoundsOnLine(_loc4_,param2);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc8_ = 1;
            _loc9_ = 0;
            _loc10_ = 0;
            _loc11_ = 0;
            _loc12_ = 0;
            _loc13_ = 0;
            if(param3 == IMEStatus.SELECTED_CONVERTED || param3 == IMEStatus.SELECTED_RAW)
            {
               _loc8_ = 2;
            }
            if(param3 == IMEStatus.SELECTED_RAW || param3 == IMEStatus.NOT_SELECTED_RAW || param3 == IMEStatus.DEAD_KEY_INPUT_STATE)
            {
               _loc9_ = 10921638;
            }
            _loc14_ = _loc6_[_loc7_] as Rectangle;
            _loc15_ = this.calculateStrikeThrough(_loc4_,param2,_loc5_);
            _loc16_ = this.calculateUnderlineOffset(_loc15_,param2,_loc5_,_loc4_);
            if(param2 != BlockProgression.RL)
            {
               _loc10_ = _loc14_.topLeft.x + 1;
               _loc12_ = _loc14_.topLeft.x + _loc14_.width - 1;
               _loc11_ = _loc16_;
               _loc13_ = _loc16_;
            }
            else
            {
               _loc18_ = this.getAbsoluteStart() - param1.absoluteStart;
               _loc11_ = _loc14_.topLeft.y + 1;
               _loc13_ = _loc14_.topLeft.y + _loc14_.height - 1;
               if(_loc18_ < 0 || _loc4_.atomCount <= _loc18_ || _loc4_.getAtomTextRotation(_loc18_) != TextRotation.ROTATE_0)
               {
                  _loc10_ = _loc16_;
                  _loc12_ = _loc16_;
               }
               else
               {
                  _loc19_ = this.getParentByType(TCYElement) as TCYElement;
                  if(this.getAbsoluteStart() + this.textLength == _loc19_.getAbsoluteStart() + _loc19_.textLength)
                  {
                     _loc20_ = new Rectangle();
                     _loc19_.calculateAdornmentBounds(_loc19_,_loc4_,param2,_loc20_);
                     _loc21_ = _loc5_.underlineOffset + _loc5_.underlineThickness / 2;
                     _loc11_ = _loc20_.top + 1;
                     _loc13_ = _loc20_.bottom - 1;
                     _loc10_ = _loc14_.bottomRight.x + _loc21_;
                     _loc12_ = _loc14_.bottomRight.x + _loc21_;
                  }
               }
            }
            _loc17_ = new Shape();
            _loc17_.alpha = 1;
            _loc17_.graphics.beginFill(_loc9_);
            _loc17_.graphics.lineStyle(_loc8_,_loc9_,_loc17_.alpha);
            _loc17_.graphics.moveTo(_loc10_,_loc11_);
            _loc17_.graphics.lineTo(_loc12_,_loc13_);
            _loc17_.graphics.endFill();
            _loc4_.addChild(_loc17_);
            _loc7_++;
         }
      }
      
      tlf_internal function updateAdornments(param1:TextFlowLine, param2:String) : int
      {
         var _loc3_:TextLine = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(_computedFormat.textDecoration == TextDecoration.UNDERLINE || _computedFormat.lineThrough || _computedFormat.backgroundAlpha > 0 && _computedFormat.backgroundColor != BackgroundColor.TRANSPARENT)
         {
            _loc3_ = param1.getTextLine(true);
            _loc4_ = this.getSpanBoundsOnLine(_loc3_,param2);
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               this.updateAdornmentsOnBounds(param1,_loc3_,param2,_loc4_[_loc5_]);
               _loc5_++;
            }
            return _loc4_.length;
         }
         return 0;
      }
      
      private function updateAdornmentsOnBounds(param1:TextFlowLine, param2:TextLine, param3:String, param4:Rectangle) : void
      {
         var _loc9_:int = 0;
         var _loc10_:TCYElement = null;
         var _loc11_:ParagraphElement = null;
         var _loc12_:String = null;
         var _loc13_:* = false;
         var _loc14_:Rectangle = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc5_:Shape = new Shape();
         var _loc6_:FontMetrics = this.getComputedFontMetrics();
         _loc5_.alpha = Number(_computedFormat.textAlpha);
         _loc5_.graphics.beginFill(uint(_computedFormat.color));
         var _loc7_:Number = this.calculateStrikeThrough(param2,param3,_loc6_);
         var _loc8_:Number = this.calculateUnderlineOffset(_loc7_,param3,_loc6_,param2);
         if(param3 != BlockProgression.RL)
         {
            if(_computedFormat.textDecoration == TextDecoration.UNDERLINE)
            {
               _loc5_.graphics.lineStyle(_loc6_.underlineThickness,_computedFormat.color as uint,_loc5_.alpha);
               _loc5_.graphics.moveTo(param4.topLeft.x,_loc8_);
               _loc5_.graphics.lineTo(param4.topLeft.x + param4.width,_loc8_);
            }
            if(_computedFormat.lineThrough)
            {
               _loc5_.graphics.lineStyle(_loc6_.strikethroughThickness,_computedFormat.color as uint,_loc5_.alpha);
               _loc5_.graphics.moveTo(param4.topLeft.x,_loc7_);
               _loc5_.graphics.lineTo(param4.topLeft.x + param4.width,_loc7_);
            }
            this.addBackgroundRect(param1,param2,_loc6_,param4,true);
         }
         else
         {
            _loc9_ = this.getAbsoluteStart() - param1.absoluteStart;
            if(_loc9_ < 0 || param2.atomCount <= _loc9_ || param2.getAtomTextRotation(_loc9_) != TextRotation.ROTATE_0)
            {
               if(_computedFormat.textDecoration == TextDecoration.UNDERLINE)
               {
                  _loc5_.graphics.lineStyle(_loc6_.underlineThickness,_computedFormat.color as uint,_loc5_.alpha);
                  _loc5_.graphics.moveTo(_loc8_,param4.topLeft.y);
                  _loc5_.graphics.lineTo(_loc8_,param4.topLeft.y + param4.height);
               }
               if(_computedFormat.lineThrough == true)
               {
                  _loc5_.graphics.lineStyle(_loc6_.strikethroughThickness,_computedFormat.color as uint,_loc5_.alpha);
                  _loc5_.graphics.moveTo(-_loc7_,param4.topLeft.y);
                  _loc5_.graphics.lineTo(-_loc7_,param4.topLeft.y + param4.height);
               }
               this.addBackgroundRect(param1,param2,_loc6_,param4,false);
            }
            else
            {
               _loc10_ = this.getParentByType(TCYElement) as TCYElement;
               _loc11_ = this.getParentByType(ParagraphElement) as ParagraphElement;
               _loc12_ = _loc11_.computedFormat.locale.toLowerCase();
               _loc13_ = _loc12_.indexOf("zh") != 0;
               this.addBackgroundRect(param1,param2,_loc6_,param4,true,true);
               if(this.getAbsoluteStart() + this.textLength == _loc10_.getAbsoluteStart() + _loc10_.textLength)
               {
                  _loc14_ = new Rectangle();
                  _loc10_.calculateAdornmentBounds(_loc10_,param2,param3,_loc14_);
                  if(_computedFormat.textDecoration == TextDecoration.UNDERLINE)
                  {
                     _loc5_.graphics.lineStyle(_loc6_.underlineThickness,_computedFormat.color as uint,_loc5_.alpha);
                     _loc15_ = _loc6_.underlineOffset + _loc6_.underlineThickness / 2;
                     _loc16_ = !!_loc13_?Number(param4.right):Number(param4.left);
                     if(!_loc13_)
                     {
                        _loc15_ = -_loc15_;
                     }
                     _loc5_.graphics.moveTo(_loc16_ + _loc15_,_loc14_.top);
                     _loc5_.graphics.lineTo(_loc16_ + _loc15_,_loc14_.bottom);
                  }
                  if(_computedFormat.lineThrough == true)
                  {
                     _loc17_ = param4.bottomRight.x - _loc14_.x;
                     _loc17_ = _loc17_ / 2;
                     _loc17_ = _loc17_ + _loc14_.x;
                     _loc5_.graphics.lineStyle(_loc6_.strikethroughThickness,_computedFormat.color as uint,_loc5_.alpha);
                     _loc5_.graphics.moveTo(_loc17_,_loc14_.top);
                     _loc5_.graphics.lineTo(_loc17_,_loc14_.bottom);
                  }
               }
            }
         }
         _loc5_.graphics.endFill();
         param2.addChild(_loc5_);
      }
      
      private function addBackgroundRect(param1:TextFlowLine, param2:TextLine, param3:FontMetrics, param4:Rectangle, param5:Boolean, param6:Boolean = false) : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         if(_computedFormat.backgroundAlpha == 0 || _computedFormat.backgroundColor == BackgroundColor.TRANSPARENT)
         {
            return;
         }
         var _loc7_:TextFlow = this.getTextFlow();
         if(!_loc7_.backgroundManager && _loc7_.flowComposer is StandardFlowComposer)
         {
            _loc7_.backgroundManager = StandardFlowComposer(_loc7_.flowComposer).createBackgroundManager();
         }
         if(!_loc7_.backgroundManager)
         {
            return;
         }
         var _loc8_:Rectangle = param4.clone();
         if(!param6 && (_computedFormat.baselineShift == BaselineShift.SUPERSCRIPT || _computedFormat.baselineShift == BaselineShift.SUBSCRIPT))
         {
            _loc11_ = this.getEffectiveFontSize();
            _loc12_ = param3.strikethroughOffset + param3.strikethroughThickness / 2;
            if(_computedFormat.baselineShift == BaselineShift.SUPERSCRIPT)
            {
               _loc13_ = -3 * _loc12_;
               _loc10_ = -param3.superscriptOffset * _loc11_;
               _loc14_ = param2.getBaselinePosition(TextBaseline.DESCENT) - param2.getBaselinePosition(TextBaseline.ROMAN);
               _loc9_ = _loc13_ + _loc10_ + _loc14_;
               if(param5)
               {
                  if(_loc9_ > _loc8_.height)
                  {
                     _loc8_.y = _loc8_.y - (_loc9_ - _loc8_.height);
                     _loc8_.height = _loc9_;
                  }
               }
               else if(_loc9_ > _loc8_.width)
               {
                  _loc8_.width = _loc9_;
               }
            }
            else
            {
               _loc15_ = -_loc12_;
               _loc10_ = param3.subscriptOffset * _loc11_;
               _loc16_ = param2.getBaselinePosition(TextBaseline.ROMAN) - param2.getBaselinePosition(TextBaseline.ASCENT);
               _loc9_ = _loc16_ + _loc10_ + _loc15_;
               if(param5)
               {
                  if(_loc9_ > _loc8_.height)
                  {
                     _loc8_.height = _loc9_;
                  }
               }
               else if(_loc9_ > _loc8_.width)
               {
                  _loc8_.x = _loc8_.x - (_loc9_ - _loc8_.width);
                  _loc8_.width = _loc9_;
               }
            }
         }
         _loc7_.backgroundManager.addRect(param1,this,_loc8_,_computedFormat.backgroundColor,_computedFormat.backgroundAlpha);
      }
      
      tlf_internal function getEventMirror() : EventDispatcher
      {
         var _loc1_:ParagraphElement = null;
         if(!this._blockElement)
         {
            _loc1_ = getParagraph();
            if(_loc1_)
            {
               _loc1_.getTextBlock();
            }
            else
            {
               this.createContentElement();
            }
         }
         if(this._blockElement.eventMirror == null)
         {
            this._blockElement.eventMirror = new EventDispatcher();
         }
         this._hasAttachedListeners = true;
         return this._blockElement.eventMirror;
      }
      
      tlf_internal function calculateStrikeThrough(param1:TextLine, param2:String, param3:FontMetrics) : Number
      {
         var _loc4_:int = 0;
         var _loc5_:Number = this.getEffectiveFontSize();
         if(_computedFormat.baselineShift == BaselineShift.SUPERSCRIPT)
         {
            _loc4_ = -(param3.superscriptOffset * _loc5_);
         }
         else if(_computedFormat.baselineShift == BaselineShift.SUBSCRIPT)
         {
            _loc4_ = -(param3.subscriptOffset * (_loc5_ / param3.subscriptScale));
         }
         else
         {
            _loc4_ = TextLayoutFormat.baselineShiftProperty.computeActualPropertyValue(_computedFormat.baselineShift,_loc5_);
         }
         var _loc6_:String = this.resolveDomBaseline();
         var _loc7_:String = this.computedFormat.alignmentBaseline;
         var _loc8_:Number = param1.getBaselinePosition(_loc6_);
         if(_loc7_ != TextBaseline.USE_DOMINANT_BASELINE && _loc7_ != _loc6_)
         {
            _loc8_ = param1.getBaselinePosition(_loc7_);
         }
         var _loc9_:Number = param3.strikethroughOffset;
         if(_loc6_ == TextBaseline.IDEOGRAPHIC_CENTER)
         {
            _loc9_ = 0;
         }
         else if(_loc6_ == TextBaseline.IDEOGRAPHIC_TOP || _loc6_ == TextBaseline.ASCENT)
         {
            _loc9_ = _loc9_ * -2;
            _loc9_ = _loc9_ - 2 * param3.strikethroughThickness;
         }
         else if(_loc6_ == TextBaseline.IDEOGRAPHIC_BOTTOM || _loc6_ == TextBaseline.DESCENT)
         {
            _loc9_ = _loc9_ * 2;
            _loc9_ = _loc9_ + 2 * param3.strikethroughThickness;
         }
         else
         {
            _loc9_ = _loc9_ - param3.strikethroughThickness;
         }
         _loc9_ = _loc9_ + (_loc8_ - _loc4_);
         return _loc9_;
      }
      
      tlf_internal function calculateUnderlineOffset(param1:Number, param2:String, param3:FontMetrics, param4:TextLine) : Number
      {
         var _loc7_:FlowElement = null;
         var _loc8_:String = null;
         var _loc5_:Number = param3.underlineOffset + param3.underlineThickness;
         var _loc6_:Number = param3.strikethroughOffset;
         if(param2 != BlockProgression.RL)
         {
            _loc5_ = _loc5_ + (param1 - _loc6_ + param3.underlineThickness / 2);
         }
         else
         {
            _loc7_ = this.parent;
            while(!(_loc7_ is ParagraphElement))
            {
               _loc7_ = _loc7_.parent;
            }
            _loc8_ = _loc7_.computedFormat.locale.toLowerCase();
            if(_loc8_.indexOf("zh") == 0)
            {
               _loc5_ = -_loc5_;
               _loc5_ = _loc5_ - (param1 - _loc6_ + param3.underlineThickness * 2);
            }
            else
            {
               _loc5_ = _loc5_ - (-_loc5_ + param1 + _loc6_ + param3.underlineThickness / 2);
            }
         }
         return _loc5_;
      }
   }
}
