package flashx.textLayout.elements
{
   import flash.text.engine.ContentElement;
   import flash.text.engine.EastAsianJustifier;
   import flash.text.engine.GroupElement;
   import flash.text.engine.LineJustification;
   import flash.text.engine.SpaceJustifier;
   import flash.text.engine.TabStop;
   import flash.text.engine.TextBaseline;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineValidity;
   import flash.text.engine.TextRotation;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.JustificationRule;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TabStopFormat;
   import flashx.textLayout.formats.TextAlign;
   import flashx.textLayout.formats.TextJustify;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   import flashx.textLayout.utils.CharacterUtil;
   import flashx.textLayout.utils.LocaleUtil;
   
   use namespace tlf_internal;
   
   public final class ParagraphElement extends ParagraphFormattedElement
   {
      
      private static var _defaultTabStops:Vector.<TabStop>;
       
      
      private var _textBlock:TextBlock;
      
      private const defaultTabWidth:int = 48;
      
      private const defaultTabCount:int = 20;
      
      public function ParagraphElement()
      {
         super();
      }
      
      tlf_internal static function getLeadingBasis(param1:String) : String
      {
         switch(param1)
         {
            default:
            case LeadingModel.ASCENT_DESCENT_UP:
            case LeadingModel.APPROXIMATE_TEXT_FIELD:
            case LeadingModel.ROMAN_UP:
               return TextBaseline.ROMAN;
            case LeadingModel.IDEOGRAPHIC_TOP_UP:
            case LeadingModel.IDEOGRAPHIC_TOP_DOWN:
               return TextBaseline.IDEOGRAPHIC_TOP;
            case LeadingModel.IDEOGRAPHIC_CENTER_UP:
            case LeadingModel.IDEOGRAPHIC_CENTER_DOWN:
               return TextBaseline.IDEOGRAPHIC_CENTER;
         }
      }
      
      tlf_internal static function useUpLeadingDirection(param1:String) : Boolean
      {
         switch(param1)
         {
            default:
            case LeadingModel.ASCENT_DESCENT_UP:
            case LeadingModel.APPROXIMATE_TEXT_FIELD:
            case LeadingModel.ROMAN_UP:
            case LeadingModel.IDEOGRAPHIC_TOP_UP:
            case LeadingModel.IDEOGRAPHIC_CENTER_UP:
               return true;
            case LeadingModel.IDEOGRAPHIC_TOP_DOWN:
            case LeadingModel.IDEOGRAPHIC_CENTER_DOWN:
               return false;
         }
      }
      
      tlf_internal function createTextBlock() : void
      {
         var _loc2_:FlowElement = null;
         this.computedFormat;
         this._textBlock = new TextBlock();
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            _loc2_.createContentElement();
            _loc1_++;
         }
         this.updateTextBlock();
      }
      
      tlf_internal function releaseTextBlock() : void
      {
         var _loc2_:FlowElement = null;
         var _loc3_:TextLine = null;
         var _loc4_:TextLine = null;
         var _loc5_:TextFlowLine = null;
         if(!this._textBlock)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            if(!_loc2_.canReleaseContentElement())
            {
               return;
            }
            _loc1_++;
         }
         if(this._textBlock.firstLine)
         {
            _loc3_ = this._textBlock.firstLine;
            while(_loc3_ != null)
            {
               if(_loc3_.numChildren != 0)
               {
                  _loc5_ = _loc3_.userData as TextFlowLine;
                  if(_loc5_.adornCount != _loc3_.numChildren)
                  {
                     return;
                  }
               }
               _loc3_ = _loc3_.nextLine;
            }
            _loc4_ = this._textBlock.firstLine;
            while(_loc4_ != null)
            {
               TextFlowLine(_loc4_.userData).markReleased();
               _loc4_ = _loc4_.nextLine;
            }
            this._textBlock.releaseLines(this._textBlock.firstLine,this._textBlock.lastLine);
         }
         this._textBlock.content = null;
         _loc1_ = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            _loc2_.releaseContentElement();
            _loc1_++;
         }
         this._textBlock = null;
         if(_computedFormat)
         {
            _computedFormat = null;
         }
      }
      
      tlf_internal function getTextBlock() : TextBlock
      {
         if(!this._textBlock)
         {
            this.createTextBlock();
         }
         return this._textBlock;
      }
      
      tlf_internal function releaseLineCreationData() : void
      {
         if(this._textBlock)
         {
            this._textBlock["releaseLineCreationData"]();
         }
      }
      
      override tlf_internal function createContentAsGroup() : GroupElement
      {
         var _loc2_:ContentElement = null;
         var _loc3_:Vector.<ContentElement> = null;
         var _loc4_:TextFlow = null;
         var _loc1_:GroupElement = this._textBlock.content as GroupElement;
         if(!_loc1_)
         {
            _loc2_ = this._textBlock.content;
            _loc1_ = new GroupElement();
            this._textBlock.content = _loc1_;
            if(_loc2_)
            {
               _loc3_ = new Vector.<ContentElement>();
               _loc3_.push(_loc2_);
               _loc1_.replaceElements(0,0,_loc3_);
            }
            if(this._textBlock.firstLine && textLength)
            {
               _loc4_ = getTextFlow();
               if(_loc4_)
               {
                  _loc4_.damage(getAbsoluteStart(),textLength,TextLineValidity.INVALID,false);
               }
            }
         }
         return _loc1_;
      }
      
      override tlf_internal function removeBlockElement(param1:FlowElement, param2:ContentElement) : void
      {
         var _loc3_:int = 0;
         var _loc4_:GroupElement = null;
         var _loc5_:ContentElement = null;
         if(numChildren == 1)
         {
            if(param2 is GroupElement)
            {
               GroupElement(this._textBlock.content).replaceElements(0,1,null);
            }
            this._textBlock.content = null;
         }
         else
         {
            _loc3_ = this.getChildIndex(param1);
            _loc4_ = GroupElement(this._textBlock.content);
            _loc4_.replaceElements(_loc3_,_loc3_ + 1,null);
            if(numChildren == 2)
            {
               _loc5_ = _loc4_.getElementAt(0);
               if(!(_loc5_ is GroupElement))
               {
                  _loc4_.replaceElements(0,1,null);
                  this._textBlock.content = _loc5_;
               }
            }
         }
      }
      
      override tlf_internal function hasBlockElement() : Boolean
      {
         return this._textBlock != null;
      }
      
      override tlf_internal function createContentElement() : void
      {
         this.createTextBlock();
      }
      
      override tlf_internal function insertBlockElement(param1:FlowElement, param2:ContentElement) : void
      {
         var _loc3_:Vector.<ContentElement> = null;
         var _loc4_:GroupElement = null;
         var _loc5_:int = 0;
         if(this._textBlock == null)
         {
            param1.releaseContentElement();
            this.createTextBlock();
            return;
         }
         if(numChildren == 1)
         {
            if(param2 is GroupElement)
            {
               _loc3_ = new Vector.<ContentElement>();
               _loc3_.push(param2);
               _loc4_ = new GroupElement(_loc3_);
               this._textBlock.content = _loc4_;
            }
            else
            {
               this._textBlock.content = param2;
            }
         }
         else
         {
            _loc4_ = this.createContentAsGroup();
            _loc5_ = this.getChildIndex(param1);
            _loc3_ = new Vector.<ContentElement>();
            _loc3_.push(param2);
            _loc4_.replaceElements(_loc5_,_loc5_,_loc3_);
         }
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
      
      override public function replaceChildren(param1:int, param2:int, ... rest) : void
      {
         var _loc5_:Array = null;
         var _loc4_:FlowLeafElement = getLastLeaf();
         if(rest.length == 1)
         {
            _loc5_ = [param1,param2,rest[0]];
         }
         else
         {
            _loc5_ = [param1,param2];
            if(rest.length != 0)
            {
               _loc5_ = _loc5_.concat.apply(_loc5_,rest);
            }
         }
         super.replaceChildren.apply(this,_loc5_);
         this.ensureTerminatorAfterReplace(_loc4_);
      }
      
      tlf_internal function ensureTerminatorAfterReplace(param1:FlowLeafElement) : void
      {
         var _loc3_:SpanElement = null;
         var _loc2_:FlowLeafElement = getLastLeaf();
         if(param1 != _loc2_)
         {
            if(param1 && param1 is SpanElement)
            {
               param1.removeParaTerminator();
            }
            if(_loc2_)
            {
               if(_loc2_ is SpanElement)
               {
                  _loc2_.addParaTerminator();
               }
               else
               {
                  _loc3_ = new SpanElement();
                  super.replaceChildren(numChildren,numChildren,_loc3_);
                  _loc3_.format = _loc2_.format;
                  _loc3_.addParaTerminator();
               }
            }
         }
      }
      
      override public function set mxmlChildren(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:SpanElement = null;
         this.replaceChildren(0,numChildren);
         for each(_loc2_ in param1)
         {
            if(_loc2_ is FlowElement)
            {
               if(_loc2_ is SpanElement || _loc2_ is SubParagraphGroupElement)
               {
                  _loc2_.bindableElement = true;
               }
               super.replaceChildren(numChildren,numChildren,_loc2_ as FlowElement);
            }
            else if(_loc2_ is String)
            {
               _loc3_ = new SpanElement();
               _loc3_.text = String(_loc2_);
               _loc3_.bindableElement = true;
               super.replaceChildren(numChildren,numChildren,_loc3_);
            }
            else if(_loc2_ != null)
            {
               throw new TypeError(GlobalSettings.resourceStringFunction("badMXMLChildrenArgument",[getQualifiedClassName(_loc2_)]));
            }
         }
         this.ensureTerminatorAfterReplace(null);
      }
      
      override public function getText(param1:int = 0, param2:int = -1, param3:String = "\n") : String
      {
         var _loc4_:String = null;
         if(param1 == 0 && (param2 == -1 || param2 >= textLength - 1) && this._textBlock)
         {
            if(this._textBlock.content)
            {
               _loc4_ = this._textBlock.content.rawText;
               return _loc4_.substring(0,_loc4_.length - 1);
            }
            return "";
         }
         return super.getText(param1,param2,param3);
      }
      
      public function getNextParagraph() : ParagraphElement
      {
         var _loc1_:FlowLeafElement = getLastLeaf().getNextLeaf();
         return !!_loc1_?_loc1_.getParagraph():null;
      }
      
      public function getPreviousParagraph() : ParagraphElement
      {
         var _loc1_:FlowLeafElement = getFirstLeaf().getPreviousLeaf();
         return !!_loc1_?_loc1_.getParagraph():null;
      }
      
      public function findPreviousAtomBoundary(param1:int) : int
      {
         return this.getTextBlock().findPreviousAtomBoundary(param1);
      }
      
      public function findNextAtomBoundary(param1:int) : int
      {
         return this.getTextBlock().findNextAtomBoundary(param1);
      }
      
      override public function getCharAtPosition(param1:int) : String
      {
         return this.getTextBlock().content.rawText.charAt(param1);
      }
      
      public function findPreviousWordBoundary(param1:int) : int
      {
         if(param1 == 0)
         {
            return 0;
         }
         var _loc2_:int = getCharCodeAtPosition(param1 - 1);
         if(CharacterUtil.isWhitespace(_loc2_))
         {
            while(CharacterUtil.isWhitespace(_loc2_) && param1 - 1 > 0)
            {
               param1--;
               _loc2_ = getCharCodeAtPosition(param1 - 1);
            }
            return param1;
         }
         return this.getTextBlock().findPreviousWordBoundary(param1);
      }
      
      public function findNextWordBoundary(param1:int) : int
      {
         if(param1 == textLength)
         {
            return textLength;
         }
         var _loc2_:int = getCharCodeAtPosition(param1);
         if(CharacterUtil.isWhitespace(_loc2_))
         {
            while(CharacterUtil.isWhitespace(_loc2_) && param1 < textLength - 1)
            {
               param1++;
               _loc2_ = getCharCodeAtPosition(param1);
            }
            return param1;
         }
         return this.getTextBlock().findNextWordBoundary(param1);
      }
      
      private function initializeDefaultTabStops() : void
      {
         var _loc1_:int = this.defaultTabWidth * this.defaultTabCount;
         _defaultTabStops = new Vector.<TabStop>(this.defaultTabCount,true);
         var _loc2_:int = 0;
         while(_loc2_ < this.defaultTabCount)
         {
            _defaultTabStops[_loc2_] = new TabStop(TextAlign.START,this.defaultTabWidth * _loc2_);
            _loc2_++;
         }
      }
      
      private function updateTextBlock() : void
      {
         var _loc3_:String = null;
         var _loc6_:SpaceJustifier = null;
         var _loc7_:EastAsianJustifier = null;
         var _loc8_:Vector.<TabStop> = null;
         var _loc9_:TabStopFormat = null;
         var _loc10_:String = null;
         var _loc11_:TabStop = null;
         var _loc12_:String = null;
         var _loc1_:ContainerFormattedElement = getAncestorWithContainer();
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:ITextLayoutFormat = !!_loc1_?_loc1_.computedFormat:TextLayoutFormat.defaultFormat;
         if(this.computedFormat.textAlign == TextAlign.JUSTIFY)
         {
            _loc3_ = _computedFormat.textAlignLast == TextAlign.JUSTIFY?LineJustification.ALL_INCLUDING_LAST:LineJustification.ALL_BUT_LAST;
            if(_loc2_.lineBreak == LineBreak.EXPLICIT)
            {
               _loc3_ = LineJustification.UNJUSTIFIED;
            }
         }
         else
         {
            _loc3_ = LineJustification.UNJUSTIFIED;
         }
         var _loc4_:String = this.getEffectiveJustificationStyle();
         var _loc5_:String = this.getEffectiveJustificationRule();
         if(_loc5_ == JustificationRule.SPACE)
         {
            _loc6_ = new SpaceJustifier(_computedFormat.locale,_loc3_,false);
            _loc6_.letterSpacing = _computedFormat.textJustify == TextJustify.DISTRIBUTE?true:false;
            this._textBlock.textJustifier = _loc6_;
            this._textBlock.baselineZero = getLeadingBasis(this.getEffectiveLeadingModel());
         }
         else
         {
            _loc7_ = new EastAsianJustifier(_computedFormat.locale,_loc3_,_loc4_);
            this._textBlock.textJustifier = _loc7_;
            this._textBlock.baselineZero = getLeadingBasis(this.getEffectiveLeadingModel());
         }
         this._textBlock.bidiLevel = _computedFormat.direction == Direction.LTR?0:1;
         this._textBlock.lineRotation = _loc2_.blockProgression == BlockProgression.RL?TextRotation.ROTATE_90:TextRotation.ROTATE_0;
         if(_computedFormat.tabStops && _computedFormat.tabStops.length != 0)
         {
            _loc8_ = new Vector.<TabStop>();
            for each(_loc9_ in _computedFormat.tabStops)
            {
               _loc10_ = _loc9_.decimalAlignmentToken == null?"":_loc9_.decimalAlignmentToken;
               _loc11_ = new TabStop(_loc9_.alignment,Number(_loc9_.position),_loc10_);
               if(_loc9_.decimalAlignmentToken != null)
               {
                  _loc12_ = "x" + _loc11_.decimalAlignmentToken;
               }
               _loc8_.push(_loc11_);
            }
            this._textBlock.tabStops = _loc8_;
         }
         else if(GlobalSettings.enableDefaultTabStops && !Configuration.playerEnablesArgoFeatures)
         {
            if(_defaultTabStops == null)
            {
               this.initializeDefaultTabStops();
            }
            this._textBlock.tabStops = _defaultTabStops;
         }
         else
         {
            this._textBlock.tabStops = null;
         }
      }
      
      override public function get computedFormat() : ITextLayoutFormat
      {
         if(!_computedFormat)
         {
            super.computedFormat;
            if(this._textBlock)
            {
               this.updateTextBlock();
            }
         }
         return _computedFormat;
      }
      
      override tlf_internal function canOwnFlowElement(param1:FlowElement) : Boolean
      {
         return param1 is FlowLeafElement || param1 is SubParagraphGroupElement;
      }
      
      override tlf_internal function normalizeRange(param1:uint, param2:uint) : void
      {
         var _loc4_:FlowElement = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:FlowElement = null;
         var _loc8_:FlowElement = null;
         var _loc9_:SpanElement = null;
         var _loc3_:int = findChildIndexAtPosition(param1);
         if(_loc3_ != -1 && _loc3_ < numChildren)
         {
            _loc4_ = getChildAt(_loc3_);
            param1 = param1 - _loc4_.parentRelativeStart;
            while(true)
            {
               _loc5_ = _loc4_.parentRelativeStart + _loc4_.textLength;
               _loc4_.normalizeRange(param1,param2 - _loc4_.parentRelativeStart);
               _loc6_ = _loc4_.parentRelativeStart + _loc4_.textLength;
               param2 = param2 + (_loc6_ - _loc5_);
               if(_loc4_.textLength == 0 && !_loc4_.bindableElement)
               {
                  this.replaceChildren(_loc3_,_loc3_ + 1);
               }
               else if(_loc4_.mergeToPreviousIfPossible())
               {
                  _loc7_ = this.getChildAt(_loc3_ - 1);
                  _loc7_.normalizeRange(0,_loc7_.textLength);
               }
               else
               {
                  _loc3_++;
               }
               if(_loc3_ == numChildren)
               {
                  if(_loc3_ != 0)
                  {
                     _loc8_ = this.getChildAt(_loc3_ - 1);
                     if(_loc8_ is SubParagraphGroupElement && _loc8_.textLength == 1 && !_loc8_.bindableElement)
                     {
                        this.replaceChildren(_loc3_ - 1,_loc3_);
                     }
                  }
                  break;
               }
               _loc4_ = getChildAt(_loc3_);
               if(_loc4_.parentRelativeStart > param2)
               {
                  break;
               }
               param1 = 0;
            }
         }
         if(numChildren == 0 || textLength == 0)
         {
            _loc9_ = new SpanElement();
            this.replaceChildren(0,0,_loc9_);
            _loc9_.normalizeRange(0,_loc9_.textLength);
         }
      }
      
      tlf_internal function getEffectiveLeadingModel() : String
      {
         return this.computedFormat.leadingModel == LeadingModel.AUTO?LocaleUtil.leadingModel(this.computedFormat.locale):this.computedFormat.leadingModel;
      }
      
      tlf_internal function getEffectiveDominantBaseline() : String
      {
         return this.computedFormat.dominantBaseline == FormatValue.AUTO?LocaleUtil.dominantBaseline(this.computedFormat.locale):this.computedFormat.dominantBaseline;
      }
      
      tlf_internal function getEffectiveJustificationRule() : String
      {
         return this.computedFormat.justificationRule == FormatValue.AUTO?LocaleUtil.justificationRule(this.computedFormat.locale):this.computedFormat.justificationRule;
      }
      
      tlf_internal function getEffectiveJustificationStyle() : String
      {
         return this.computedFormat.justificationStyle == FormatValue.AUTO?LocaleUtil.justificationStyle(this.computedFormat.locale):this.computedFormat.justificationStyle;
      }
   }
}
