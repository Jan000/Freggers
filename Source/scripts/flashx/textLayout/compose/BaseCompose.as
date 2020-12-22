package flashx.textLayout.compose
{
   import flash.geom.Rectangle;
   import flash.text.engine.TextBaseline;
   import flash.text.engine.TextLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.ContainerFormattedElement;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.OverflowPolicy;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.BaselineOffset;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.FlowElementDisplayType;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.TextAlign;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.VerticalAlign;
   import flashx.textLayout.tlf_internal;
   import flashx.textLayout.utils.LocaleUtil;
   
   use namespace tlf_internal;
   
   public class BaseCompose
   {
      
      protected static var _candidateLineSlug:Rectangle = new Rectangle();
      
      protected static var _lineSlug:Rectangle = new Rectangle();
      
      private static var _alignLines:Array;
       
      
      protected var _parcelList:IParcelList;
      
      protected var _curElement:FlowLeafElement;
      
      protected var _curElementStart:int;
      
      protected var _curElementOffset:int;
      
      protected var _curParaElement:ParagraphElement;
      
      protected var _curParaFormat:ITextLayoutFormat;
      
      protected var _curParaStart:int;
      
      private var _curLineLeadingModel:String = "";
      
      private var _curLineLeading:Number;
      
      protected var _lastLineLeadingModel:String = "";
      
      protected var _lastLineLeading:Number;
      
      protected var _lastLineDescent:Number;
      
      protected var _spaceCarried:Number;
      
      protected var _blockProgression:String;
      
      private var _controllerLeft:Number;
      
      private var _controllerTop:Number;
      
      private var _controllerRight:Number;
      
      private var _controllerBottom:Number;
      
      protected var _contentLogicalExtent:Number;
      
      protected var _contentCommittedExtent:Number;
      
      protected var _parcelLeft:Number;
      
      protected var _parcelTop:Number;
      
      protected var _parcelRight:Number;
      
      protected var _parcelBottom:Number;
      
      protected var _textFlow:TextFlow;
      
      private var _releaseLineCreationData:Boolean;
      
      protected var _flowComposer:StandardFlowComposer;
      
      protected var _rootElement:ContainerFormattedElement;
      
      protected var _stopComposePos:int;
      
      protected var _startController:ContainerController;
      
      protected var _startComposePosition:int;
      
      protected var _curParcel:Parcel;
      
      protected var _curParcelStart:int;
      
      public function BaseCompose()
      {
         super();
      }
      
      public static function get globalSWFContext() : ISWFContext
      {
         return GlobalSWFContext.globalSWFContext;
      }
      
      private static function doNothingOnParcelChange(param1:Parcel) : void
      {
      }
      
      public function get parcelList() : IParcelList
      {
         return this._parcelList;
      }
      
      protected function createParcelList() : IParcelList
      {
         return null;
      }
      
      protected function releaseParcelList(param1:IParcelList) : void
      {
      }
      
      public function get startController() : ContainerController
      {
         return this._startController;
      }
      
      tlf_internal function releaseAnyReferences() : void
      {
         this._curElement = null;
         this._curParaElement = null;
         this._curParaFormat = null;
         this._flowComposer = null;
         this._parcelList = null;
         this._rootElement = null;
         this._startController = null;
         this._textFlow = null;
      }
      
      protected function initializeForComposer(param1:IFlowComposer, param2:int, param3:int) : void
      {
         this._parcelList = this.createParcelList();
         this._parcelList.notifyOnParcelChange = this.parcelHasChanged;
         this._spaceCarried = 0;
         this._blockProgression = param1.rootElement.computedFormat.blockProgression;
         this._stopComposePos = param2 >= 0?int(Math.min(this._textFlow.textLength,param2)):int(this._textFlow.textLength);
         this._parcelList.beginCompose(param1,param3,param2 > 0);
         this._contentLogicalExtent = 0;
         this._contentCommittedExtent = 0;
      }
      
      protected function composeFloat(param1:ContainerFormattedElement, param2:ContainerController) : void
      {
      }
      
      protected function startLine() : void
      {
      }
      
      protected function endLine() : void
      {
      }
      
      private function composeBlockElement(param1:FlowGroupElement, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:FlowElement = null;
         var _loc5_:ParagraphElement = null;
         var _loc6_:Boolean = false;
         if(this._startComposePosition != 0)
         {
            _loc3_ = param1.findChildIndexAtPosition(this._startComposePosition - param2);
            param2 = param2 + param1.getChildAt(_loc3_).parentRelativeStart;
         }
         else
         {
            _loc3_ = 0;
         }
         while(_loc3_ < param1.numChildren && (param2 <= this._stopComposePos || !this.parcelList.atLast()))
         {
            _loc4_ = param1.getChildAt(_loc3_);
            _loc5_ = _loc4_ as ParagraphElement;
            if(_loc5_)
            {
               _loc6_ = this.composeParagraphElement(_loc5_,param2);
               if(this.releaseLineCreationData)
               {
                  _loc5_.releaseLineCreationData();
               }
               if(!_loc6_)
               {
                  return false;
               }
            }
            else if(_loc4_.display == FlowElementDisplayType.FLOAT)
            {
               this.composeFloat(ContainerFormattedElement(_loc4_),this._parcelList.controller);
               if(this._parcelList.atEnd())
               {
                  return false;
               }
            }
            else if(!this.composeBlockElement(FlowGroupElement(_loc4_),param2))
            {
               return false;
            }
            param2 = param2 + _loc4_.textLength;
            _loc3_++;
         }
         return true;
      }
      
      public function composeTextFlow(param1:TextFlow, param2:int, param3:int) : int
      {
         var _loc4_:Function = null;
         var _loc5_:FlowLeafElement = null;
         var _loc6_:int = 0;
         var _loc7_:TextFlowLine = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:TextFlowLine = null;
         var _loc12_:Number = NaN;
         var _loc13_:AlignData = null;
         var _loc14_:ITextLayoutFormat = null;
         this._textFlow = param1;
         this._releaseLineCreationData = param1.configuration.releaseLineCreationData && Configuration.playerEnablesArgoFeatures;
         this._flowComposer = this._textFlow.flowComposer as StandardFlowComposer;
         this._rootElement = param1;
         this._curElementOffset = 0;
         this._curElement = this._rootElement.getFirstLeaf();
         this._curElementStart = 0;
         this._curParcel = null;
         this.initializeForComposer(this._flowComposer,param2,param3);
         this.resetControllerBounds();
         if(this._startController != this._flowComposer.getControllerAt(0))
         {
            _loc4_ = this._parcelList.notifyOnParcelChange;
            this._parcelList.notifyOnParcelChange = doNothingOnParcelChange;
            while(this._parcelList.currentParcel.controller != this._startController)
            {
               this._parcelList.next();
            }
            this._parcelList.notifyOnParcelChange = _loc4_;
         }
         if(this._startComposePosition > 0)
         {
            _loc5_ = this._textFlow.findLeaf(this._startComposePosition - 1);
            this._curElement = _loc5_;
            this._curElementStart = _loc5_.getAbsoluteStart();
            this._curElementOffset = this._startComposePosition - this._curElementStart;
            this._curLineLeadingModel = _loc5_.getParagraph().getEffectiveLeadingModel();
            _loc6_ = this._flowComposer.findLineIndexAtPosition(this._startComposePosition - 1);
            _loc7_ = this._flowComposer.getLineAt(_loc6_);
            this._spaceCarried = _loc7_.spaceAfter;
            this.commitLastLineState(_loc7_);
            _loc8_ = _loc7_.columnIndex;
            _loc9_ = 0;
            while(this._parcelList.currentParcel && this._parcelList.columnIndex < _loc8_)
            {
               this._parcelList.next();
               _loc9_++;
            }
            if(this._blockProgression == BlockProgression.TB)
            {
               this._parcelList.addTotalDepth(_loc7_.y + _loc7_.ascent - this._parcelList.top);
            }
            else
            {
               this._parcelList.addTotalDepth(this._parcelList.right - _loc7_.x);
            }
            _loc10_ = this._flowComposer.findLineIndexAtPosition(this._startController.absoluteStart);
            _loc6_ = this._flowComposer.findLineIndexAtPosition(this._startComposePosition);
            while(_loc10_ < _loc6_)
            {
               _loc11_ = this._flowComposer.getLineAt(_loc10_);
               _loc12_ = _loc11_.lineExtent;
               this._contentLogicalExtent = Math.max(this._contentLogicalExtent,_loc12_);
               if(!_loc11_.alignment || !this.startController.measureWidth)
               {
                  this._contentCommittedExtent = Math.max(this._contentCommittedExtent,_loc12_);
               }
               else
               {
                  _loc13_ = new AlignData();
                  _loc13_.textLine = _loc11_.getTextLine();
                  _loc13_.center = _loc11_.alignment == TextAlign.CENTER;
                  _loc14_ = _loc11_.paragraph.computedFormat;
                  _loc13_.rightSideGap = this.getRightSideGap(_loc11_,_loc14_,_loc11_.alignment != null);
                  _loc13_.leftSideGap = this.getLeftSideGap(_loc11_,_loc14_);
                  _loc13_.lineWidth = _loc11_.lineExtent - (_loc13_.rightSideGap + _loc13_.leftSideGap);
                  if(!_alignLines)
                  {
                     _alignLines = [];
                  }
                  _alignLines.push(_loc13_);
               }
               _loc10_++;
            }
         }
         this.parcelHasChanged(this._parcelList.currentParcel);
         this.composeInternal(this._rootElement,0);
         while(!this.parcelList.atEnd())
         {
            this.parcelList.next();
         }
         this.parcelHasChanged(null);
         this.releaseParcelList(this._parcelList);
         this._parcelList = null;
         return this._curElementStart + this._curElementOffset;
      }
      
      private function resetControllerBounds() : void
      {
         this._controllerLeft = TextLine.MAX_LINE_WIDTH;
         this._controllerTop = TextLine.MAX_LINE_WIDTH;
         this._controllerRight = -TextLine.MAX_LINE_WIDTH;
         this._controllerBottom = -TextLine.MAX_LINE_WIDTH;
      }
      
      protected function get releaseLineCreationData() : Boolean
      {
         return this._releaseLineCreationData;
      }
      
      protected function composeInternal(param1:FlowGroupElement, param2:int) : void
      {
         this.composeBlockElement(param1,param2);
      }
      
      protected function composeParagraphElement(param1:ParagraphElement, param2:int) : Boolean
      {
         return false;
      }
      
      protected function composeParagraphElementIntoLines() : Boolean
      {
         var _loc1_:TextFlowLine = null;
         var _loc2_:AlignData = null;
         while(!this._parcelList.atEnd())
         {
            this.startLine();
            _loc1_ = this.composeNextLine();
            if(_loc1_ == null)
            {
               return false;
            }
            _loc2_ = this.calculateTextAlign(_loc1_,_loc1_.getTextLine());
            if((_loc1_.spaceBefore != 0 || this._spaceCarried != 0) && !this._parcelList.isColumnStart())
            {
               this._parcelList.addTotalDepth(Math.max(_loc1_.spaceBefore,this._spaceCarried));
            }
            this._spaceCarried = 0;
            this._parcelList.addTotalDepth(_loc1_.height);
            this._curElementOffset = this._curElementOffset + _loc1_.textLength;
            this.calculateLineAlignmentAndBounds(_loc1_,_loc2_);
            if(this._parcelList.atEnd())
            {
               return false;
            }
            this.endLine();
            if(this._curElementOffset >= this._curElement.textLength)
            {
               do
               {
                  this._curElementOffset = this._curElementOffset - this._curElement.textLength;
                  this._curElementStart = this._curElementStart + this._curElement.textLength;
                  if(this._curElementStart == this._curParaStart + this._curParaElement.textLength)
                  {
                     this._curElement = null;
                     break;
                  }
                  this._curElement = this._curElement.getNextLeaf();
               }
               while(this._curElementOffset >= this._curElement.textLength || this._curElement.textLength == 0);
               
            }
            this._spaceCarried = _loc1_.spaceAfter;
            if(this._curElement == null)
            {
               return true;
            }
         }
         return false;
      }
      
      private function calculateLineWidthExplicit(param1:TextFlowLine) : Number
      {
         var _loc2_:* = this._curParaElement.computedFormat.direction == Direction.RTL;
         var _loc3_:TextLine = param1.getTextLine(true);
         var _loc4_:int = _loc3_.atomCount - 1;
         var _loc5_:* = this._curElementStart + this._curElementOffset == this._curParaStart + this._curParaElement.textLength;
         if(_loc5_ && !_loc2_)
         {
            _loc4_--;
         }
         var _loc6_:Rectangle = _loc3_.getAtomBounds(_loc4_ >= 0?int(_loc4_):0);
         var _loc7_:Number = this._blockProgression == BlockProgression.TB?_loc4_ >= 0?Number(_loc6_.right):Number(_loc6_.left):_loc4_ >= 0?Number(_loc6_.bottom):Number(_loc6_.top);
         if(_loc2_)
         {
            _loc6_ = _loc3_.getAtomBounds(_loc4_ != 0 && _loc5_?1:0);
            _loc7_ = _loc7_ - (this._blockProgression == BlockProgression.TB?_loc6_.left:_loc6_.top);
         }
         _loc3_.flushAtomData();
         return _loc7_;
      }
      
      private function getRightSideGap(param1:TextFlowLine, param2:ITextLayoutFormat, param3:Boolean) : Number
      {
         var _loc4_:Number = param2.direction == Direction.LTR?Number(param2.paragraphEndIndent):Number(param2.paragraphStartIndent);
         if(param2.direction == Direction.RTL && param1.location & TextFlowLineLocation.FIRST)
         {
            if(param3 && (this._blockProgression == BlockProgression.TB && !param1.controller.measureWidth || this._blockProgression == BlockProgression.RL && !param1.controller.measureHeight))
            {
               _loc4_ = _loc4_ + param2.textIndent;
            }
         }
         return _loc4_;
      }
      
      private function getLeftSideGap(param1:TextFlowLine, param2:ITextLayoutFormat) : Number
      {
         var _loc3_:Number = param2.direction == Direction.LTR?Number(param2.paragraphStartIndent):Number(param2.paragraphEndIndent);
         if(param2.direction == Direction.LTR && param1.location & TextFlowLineLocation.FIRST)
         {
            _loc3_ = _loc3_ + param2.textIndent;
         }
         return _loc3_;
      }
      
      private function calculateLineAlignmentAndBounds(param1:TextFlowLine, param2:AlignData) : void
      {
         var _loc3_:TextLine = param1.getTextLine();
         var _loc4_:Number = !!this._parcelList.explicitLineBreaks?Number(this.calculateLineWidthExplicit(param1)):Number(_loc3_.textWidth);
         var _loc5_:Number = this.getRightSideGap(param1,this._curParaFormat,param2 != null);
         var _loc6_:Number = this.getLeftSideGap(param1,this._curParaFormat);
         if(param2)
         {
            param2.rightSideGap = _loc5_;
            param2.leftSideGap = _loc6_;
            param2.lineWidth = _loc4_;
         }
         var _loc7_:Number = _loc4_ + _loc6_ + _loc5_;
         param1.lineExtent = _loc7_;
         this._contentLogicalExtent = Math.max(this._contentLogicalExtent,_loc7_);
         if(!param2)
         {
            this._contentCommittedExtent = Math.max(this._contentCommittedExtent,_loc7_);
         }
      }
      
      protected function composeNextLine() : TextFlowLine
      {
         return null;
      }
      
      protected function fitLineToParcel(param1:TextFlowLine, param2:Boolean) : TextFlowLine
      {
         var _loc3_:Number = NaN;
         while(!this._parcelList.getLineSlug(_candidateLineSlug,0))
         {
            this._parcelList.next();
            if(this._parcelList.atEnd())
            {
               return null;
            }
            this._spaceCarried = 0;
         }
         param1.setController(this._parcelList.controller,this._parcelList.columnIndex);
         _loc3_ = Math.max(param1.spaceBefore,this._spaceCarried);
         loop1:
         while(true)
         {
            this.finishComposeLine(param1,_candidateLineSlug,param2);
            if(this._parcelList.getLineSlug(_lineSlug,_loc3_ + (this._parcelList.atLast() && this._textFlow.configuration.overflowPolicy != OverflowPolicy.FIT_DESCENDERS?param1.height - param1.ascent:param1.height + param1.descent)))
            {
               break;
            }
            _loc3_ = param1.spaceBefore;
            while(true)
            {
               this._parcelList.next();
               if(this._parcelList.atEnd())
               {
                  break;
               }
               if(this._parcelList.getLineSlug(_candidateLineSlug,0))
               {
                  param1.setController(this._parcelList.controller,this._parcelList.columnIndex);
                  continue loop1;
               }
            }
            return null;
         }
         return this._parcelList.getComposeWidth(_lineSlug) == param1.outerTargetWidth?param1:null;
      }
      
      protected function finishComposeLine(param1:TextFlowLine, param2:Rectangle, param3:Boolean) : void
      {
         var _loc10_:String = null;
         var _loc11_:LeadingAdjustment = null;
         var _loc12_:Number = NaN;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:FlowLeafElement = null;
         var _loc16_:LeadingAdjustment = null;
         var _loc4_:TextLine = param1.getTextLine();
         var _loc5_:Number = 0;
         var _loc6_:Number = this._blockProgression != BlockProgression.RL?Number(this.parcelList.getComposeYCoord(param2)):Number(this._parcelList.getComposeXCoord(param2));
         var _loc7_:Number = this._blockProgression != BlockProgression.RL?Number(this.parcelList.getComposeXCoord(param2)):Number(this._parcelList.getComposeYCoord(param2));
         if(this._curParaFormat.direction == Direction.LTR)
         {
            _loc7_ = _loc7_ + param1.lineOffset;
         }
         else
         {
            _loc7_ = _loc7_ + (param1.outerTargetWidth - param1.lineOffset - param1.targetWidth);
            if(param1.outerTargetWidth == TextLine.MAX_LINE_WIDTH && param1.location & TextFlowLineLocation.FIRST)
            {
               _loc7_ = _loc7_ + param1.paragraph.computedFormat.textIndent;
            }
         }
         this._curLineLeading = param1.getLineLeading(this._blockProgression,this._curElement,this._curElementStart);
         this._curLineLeadingModel = this._curParaElement.getEffectiveLeadingModel();
         var _loc8_:ITextLayoutFormat = this._parcelList.controller.computedFormat;
         var _loc9_:Object = BaselineOffset.LINE_HEIGHT;
         if(this._parcelList.isColumnStart())
         {
            if(_loc8_.firstBaselineOffset != BaselineOffset.AUTO && _loc8_.verticalAlign != VerticalAlign.BOTTOM && _loc8_.verticalAlign != VerticalAlign.MIDDLE)
            {
               _loc9_ = _loc8_.firstBaselineOffset;
               _loc10_ = LocaleUtil.leadingModel(_loc8_.locale) == LeadingModel.IDEOGRAPHIC_TOP_DOWN?TextBaseline.IDEOGRAPHIC_BOTTOM:TextBaseline.ROMAN;
               _loc5_ = _loc5_ - _loc4_.getBaselinePosition(_loc10_);
            }
            else if(this._curLineLeadingModel == LeadingModel.APPROXIMATE_TEXT_FIELD)
            {
               _loc5_ = _loc5_ + (Math.round(_loc4_.descent) + Math.round(_loc4_.ascent));
               if(this._blockProgression == BlockProgression.TB)
               {
                  _loc5_ = Math.round(_loc6_ + _loc5_) - _loc6_;
               }
               else
               {
                  _loc5_ = _loc6_ - Math.round(_loc6_ - _loc5_);
               }
               _loc9_ = 0;
            }
            else
            {
               _loc9_ = BaselineOffset.ASCENT;
               if(_loc4_.hasGraphicElement)
               {
                  _loc11_ = this.getLineAdjustmentForInline(param1,this._curLineLeadingModel,true);
                  if(_loc11_ != null)
                  {
                     if(this._blockProgression == BlockProgression.RL)
                     {
                        _loc11_.rise = -_loc11_.rise;
                     }
                     this._curLineLeading = this._curLineLeading + _loc11_.leading;
                     _loc6_ = _loc6_ + _loc11_.rise;
                  }
               }
               _loc5_ = _loc5_ - _loc4_.getBaselinePosition(TextBaseline.ROMAN);
            }
         }
         else if(param1.spaceBefore != 0 || this._spaceCarried != 0)
         {
            _loc12_ = Math.max(param1.spaceBefore,this._spaceCarried);
            _loc6_ = _loc6_ + (this._blockProgression == BlockProgression.RL?-_loc12_:_loc12_);
         }
         if(_loc9_ == BaselineOffset.ASCENT)
         {
            _loc5_ = _loc5_ + param1.getLineTypographicAscent(this._curElement,this._curElementStart);
         }
         else if(_loc9_ == BaselineOffset.LINE_HEIGHT)
         {
            if(this._curLineLeadingModel == LeadingModel.APPROXIMATE_TEXT_FIELD)
            {
               _loc5_ = _loc5_ + (Math.round(this._lastLineDescent) + Math.round(_loc4_.ascent) + Math.round(_loc4_.descent) + Math.round(this._curLineLeading));
            }
            else if(this._curLineLeadingModel == LeadingModel.ASCENT_DESCENT_UP)
            {
               _loc5_ = _loc5_ + (this._lastLineDescent + _loc4_.ascent + this._curLineLeading);
            }
            else
            {
               _loc13_ = !!this._parcelList.isColumnStart()?true:Boolean(ParagraphElement.useUpLeadingDirection(this._curLineLeadingModel));
               _loc14_ = this._parcelList.isColumnStart() || this._lastLineLeadingModel == ""?true:Boolean(ParagraphElement.useUpLeadingDirection(this._lastLineLeadingModel));
               if(_loc13_)
               {
                  _loc5_ = _loc5_ + this._curLineLeading;
               }
               else if(!_loc14_)
               {
                  _loc5_ = _loc5_ + this._lastLineLeading;
               }
               else
               {
                  _loc5_ = _loc5_ + (this._lastLineDescent + _loc4_.ascent);
               }
            }
         }
         else
         {
            _loc5_ = _loc5_ + Number(_loc9_);
         }
         _loc6_ = _loc6_ + (this._blockProgression == BlockProgression.RL?-_loc5_:_loc5_ - _loc4_.ascent);
         if(_loc4_.hasGraphicElement && _loc9_ != BaselineOffset.ASCENT)
         {
            _loc16_ = this.getLineAdjustmentForInline(param1,this._curLineLeadingModel,false);
            if(_loc16_ != null)
            {
               if(this._blockProgression == BlockProgression.RL)
               {
                  _loc16_.rise = -_loc16_.rise;
               }
               this._curLineLeading = this._curLineLeading + _loc16_.leading;
               _loc6_ = _loc6_ + _loc16_.rise;
            }
         }
         if(this._blockProgression == BlockProgression.TB)
         {
            param1.setXYAndHeight(_loc7_,_loc6_,_loc5_);
         }
         else
         {
            param1.setXYAndHeight(_loc6_,_loc7_,_loc5_);
         }
         if(param3)
         {
            param1.createAdornments(this._blockProgression,this._curElement,this._curElementStart);
         }
      }
      
      private function calculateTextAlign(param1:TextFlowLine, param2:TextLine) : AlignData
      {
         var _loc5_:int = 0;
         var _loc6_:AlignData = null;
         var _loc3_:String = this._curParaFormat.textAlign;
         if(_loc3_ == TextAlign.JUSTIFY && this._curParaFormat.textAlignLast != null)
         {
            _loc5_ = param1.location;
            if(_loc5_ == TextFlowLineLocation.LAST || _loc5_ == TextFlowLineLocation.ONLY)
            {
               _loc3_ = this._curParaFormat.textAlignLast;
            }
         }
         switch(_loc3_)
         {
            case TextAlign.START:
               _loc3_ = this._curParaFormat.direction == Direction.LTR?TextAlign.LEFT:TextAlign.RIGHT;
               break;
            case TextAlign.END:
               _loc3_ = this._curParaFormat.direction == Direction.LTR?TextAlign.RIGHT:TextAlign.LEFT;
         }
         var _loc4_:Boolean = _loc3_ == TextAlign.CENTER || _loc3_ == TextAlign.RIGHT;
         if(Configuration.playerEnablesArgoFeatures)
         {
            if(param2["hasTabs"])
            {
               if(this._curParaFormat.direction == Direction.LTR)
               {
                  _loc4_ = false;
               }
               else
               {
                  _loc4_ = true;
                  _loc3_ = TextAlign.RIGHT;
               }
            }
         }
         if(_loc4_)
         {
            _loc6_ = new AlignData();
            _loc6_.textLine = param2;
            _loc6_.center = _loc3_ == TextAlign.CENTER;
            if(!_alignLines)
            {
               _alignLines = [];
            }
            _alignLines.push(_loc6_);
            param1.alignment = _loc3_;
            return _loc6_;
         }
         return null;
      }
      
      private function applyTextAlign(param1:Number) : void
      {
         var _loc2_:TextLine = null;
         var _loc3_:TextFlowLine = null;
         var _loc4_:AlignData = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(this._blockProgression == BlockProgression.TB)
         {
            for each(_loc4_ in _alignLines)
            {
               _loc2_ = _loc4_.textLine;
               _loc10_ = _loc4_.rightSideGap;
               _loc9_ = _loc4_.leftSideGap;
               _loc3_ = _loc2_.userData as TextFlowLine;
               _loc8_ = param1 - _loc9_ - _loc10_ - _loc2_.textWidth;
               _loc6_ = _loc9_ + (!!_loc4_.center?_loc8_ / 2:_loc8_);
               _loc5_ = this._curParcel.left + _loc6_;
               if(_loc3_)
               {
                  _loc3_.x = _loc5_;
               }
               _loc2_.x = _loc5_;
               _loc7_ = _loc4_.lineWidth + _loc5_ + Math.max(_loc10_,0);
               this._parcelRight = Math.max(_loc7_,this._parcelRight);
            }
         }
         else
         {
            for each(_loc4_ in _alignLines)
            {
               _loc2_ = _loc4_.textLine;
               _loc10_ = _loc4_.rightSideGap;
               _loc9_ = _loc4_.leftSideGap;
               _loc3_ = _loc2_.userData as TextFlowLine;
               _loc8_ = param1 - _loc9_ - _loc10_ - _loc2_.textWidth;
               _loc6_ = _loc9_ + (!!_loc4_.center?_loc8_ / 2:_loc8_);
               _loc5_ = this._curParcel.top + _loc6_;
               if(_loc3_)
               {
                  _loc3_.y = _loc5_;
               }
               _loc2_.y = _loc5_;
               _loc7_ = _loc4_.lineWidth + _loc5_ + Math.max(_loc10_,0);
               this._parcelBottom = Math.max(_loc7_,this._parcelBottom);
            }
         }
         _alignLines.length = 0;
      }
      
      protected function commitLastLineState(param1:TextFlowLine) : void
      {
         this._lastLineDescent = param1.descent;
         this._lastLineLeading = this._curLineLeading;
         this._lastLineLeadingModel = this._curLineLeadingModel;
      }
      
      protected function doVerticalAlignment(param1:Boolean, param2:Parcel) : Boolean
      {
         return false;
      }
      
      protected function finalParcelAdjustment(param1:ContainerController) : void
      {
      }
      
      protected function finishParcel(param1:ContainerController, param2:Parcel) : Boolean
      {
         var _loc6_:Number = NaN;
         if(this._curParcelStart == this._curElementStart + this._curElementOffset)
         {
            return false;
         }
         var _loc3_:Boolean = _alignLines && _alignLines.length > 0;
         var _loc4_:Number = this._parcelList.totalDepth;
         if(this._textFlow.configuration.overflowPolicy == OverflowPolicy.FIT_DESCENDERS && !isNaN(this._lastLineDescent))
         {
            _loc4_ = _loc4_ + this._lastLineDescent;
         }
         if(this._blockProgression == BlockProgression.TB)
         {
            this._parcelLeft = this._curParcel.left;
            this._parcelTop = this._curParcel.top;
            this._parcelRight = this._contentCommittedExtent + this._curParcel.left;
            this._parcelBottom = _loc4_ + this._curParcel.top;
         }
         else
         {
            this._parcelLeft = this._curParcel.right - _loc4_;
            this._parcelTop = this._curParcel.top;
            this._parcelRight = this._curParcel.right;
            this._parcelBottom = this._contentCommittedExtent + this._curParcel.top;
         }
         if(_loc3_)
         {
            if(this._blockProgression == BlockProgression.TB)
            {
               _loc6_ = !!param1.measureWidth?Number(this._contentLogicalExtent):Number(this._curParcel.width);
            }
            else
            {
               _loc6_ = !!param1.measureHeight?Number(this._contentLogicalExtent):Number(this._curParcel.height);
            }
            this.applyTextAlign(_loc6_);
         }
         var _loc5_:Boolean = false;
         if(this._blockProgression == BlockProgression.TB)
         {
            if(!param1.measureHeight && (!this._curParcel.fitAny || this._curElementStart + this._curElementOffset >= this._textFlow.textLength))
            {
               _loc5_ = true;
            }
         }
         else if(!param1.measureWidth && (!this._curParcel.fitAny || this._curElementStart + this._curElementOffset >= this._textFlow.textLength))
         {
            _loc5_ = true;
         }
         if(this.doVerticalAlignment(_loc5_,param2))
         {
            _loc3_ = true;
         }
         this.finalParcelAdjustment(param1);
         this._contentLogicalExtent = 0;
         this._contentCommittedExtent = 0;
         return true;
      }
      
      protected function applyVerticalAlignmentToColumn(param1:ContainerController, param2:String, param3:Array, param4:int, param5:int) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc6_:IVerticalJustificationLine = param3[param4];
         var _loc7_:IVerticalJustificationLine = param3[param4 + param5 - 1];
         if(this._blockProgression == BlockProgression.TB)
         {
            _loc8_ = _loc6_.y;
            _loc9_ = _loc7_.y;
         }
         else
         {
            _loc8_ = _loc6_.x;
            _loc9_ = _loc7_.x;
         }
         VerticalJustifier.applyVerticalAlignmentToColumn(param1,param2,param3,param4,param5);
         if(this._blockProgression == BlockProgression.TB)
         {
            this._parcelTop = this._parcelTop + (_loc6_.y - _loc8_);
            this._parcelBottom = this._parcelBottom + (_loc7_.y - _loc9_);
         }
         else
         {
            this._parcelRight = this._parcelRight + (_loc6_.x - _loc8_);
            this._parcelLeft = this._parcelLeft + (_loc7_.x - _loc9_);
         }
      }
      
      private function finishController(param1:ContainerController) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:int = this._curElementStart + this._curElementOffset - param1.absoluteStart;
         if(_loc2_ != 0)
         {
            _loc3_ = param1.effectivePaddingLeft;
            _loc4_ = param1.effectivePaddingTop;
            _loc5_ = param1.effectivePaddingRight;
            _loc6_ = param1.effectivePaddingBottom;
            if(this._blockProgression == BlockProgression.TB)
            {
               if(this._controllerLeft > 0)
               {
                  if(this._controllerLeft < _loc3_)
                  {
                     this._controllerLeft = 0;
                  }
                  else
                  {
                     this._controllerLeft = this._controllerLeft - _loc3_;
                  }
               }
               if(this._controllerTop > 0)
               {
                  if(this._controllerTop < _loc4_)
                  {
                     this._controllerTop = 0;
                  }
                  else
                  {
                     this._controllerTop = this._controllerTop - _loc4_;
                  }
               }
               if(isNaN(param1.compositionWidth))
               {
                  this._controllerRight = this._controllerRight + _loc5_;
               }
               else if(this._controllerRight < param1.compositionWidth)
               {
                  if(this._controllerRight > param1.compositionWidth - _loc5_)
                  {
                     this._controllerRight = param1.compositionWidth;
                  }
                  else
                  {
                     this._controllerRight = this._controllerRight + _loc5_;
                  }
               }
               this._controllerBottom = this._controllerBottom + _loc6_;
            }
            else
            {
               this._controllerLeft = this._controllerLeft - _loc3_;
               if(this._controllerTop > 0)
               {
                  if(this._controllerTop < _loc4_)
                  {
                     this._controllerTop = 0;
                  }
                  else
                  {
                     this._controllerTop = this._controllerTop - _loc4_;
                  }
               }
               if(this._controllerRight < 0)
               {
                  if(this._controllerRight > -_loc5_)
                  {
                     this._controllerRight = 0;
                  }
                  else
                  {
                     this._controllerRight = this._controllerRight + _loc5_;
                  }
               }
               if(isNaN(param1.compositionHeight))
               {
                  this._controllerBottom = this._controllerBottom + _loc6_;
               }
               else if(this._controllerBottom < param1.compositionHeight)
               {
                  if(this._controllerBottom > param1.compositionHeight - _loc6_)
                  {
                     this._controllerBottom = param1.compositionHeight;
                  }
                  else
                  {
                     this._controllerBottom = this._controllerBottom + _loc6_;
                  }
               }
            }
            param1.setContentBounds(this._controllerLeft,this._controllerTop,this._controllerRight - this._controllerLeft,this._controllerBottom - this._controllerTop);
         }
         else
         {
            param1.setContentBounds(0,0,0,0);
         }
         param1.setTextLength(_loc2_);
      }
      
      private function clearControllers(param1:ContainerController, param2:ContainerController) : void
      {
         var _loc5_:ContainerController = null;
         var _loc3_:int = !!param1?int(this._flowComposer.getControllerIndex(param1) + 1):0;
         var _loc4_:int = !!param2?int(this._flowComposer.getControllerIndex(param2)):int(this._flowComposer.numControllers - 1);
         while(_loc3_ <= _loc4_)
         {
            _loc5_ = ContainerController(this._flowComposer.getControllerAt(_loc3_));
            _loc5_.setContentBounds(0,0,0,0);
            _loc5_.setTextLength(0);
            _loc3_++;
         }
      }
      
      protected function parcelHasChanged(param1:Parcel) : void
      {
         var _loc2_:ContainerController = !!this._curParcel?ContainerController(this._curParcel.controller):null;
         var _loc3_:ContainerController = !!param1?ContainerController(param1.controller):null;
         if(this._curParcel != null)
         {
            if(this.finishParcel(_loc2_,param1))
            {
               if(this._parcelLeft < this._controllerLeft)
               {
                  this._controllerLeft = this._parcelLeft;
               }
               if(this._parcelRight > this._controllerRight)
               {
                  this._controllerRight = this._parcelRight;
               }
               if(this._parcelTop < this._controllerTop)
               {
                  this._controllerTop = this._parcelTop;
               }
               if(this._parcelBottom > this._controllerBottom)
               {
                  this._controllerBottom = this._parcelBottom;
               }
            }
         }
         if(_loc2_ != _loc3_)
         {
            if(_loc2_)
            {
               this.finishController(_loc2_);
            }
            this.resetControllerBounds();
            if(this._flowComposer.numControllers > 1)
            {
               if(_loc2_ == null && this._startController)
               {
                  this.clearControllers(this._startController,_loc3_);
               }
               else
               {
                  this.clearControllers(_loc2_,_loc3_);
               }
            }
         }
         this._curParcel = param1;
         this._curParcelStart = this._curElementStart;
      }
      
      private function getLineAdjustmentForInline(param1:TextFlowLine, param2:String, param3:Boolean) : LeadingAdjustment
      {
         var _loc11_:InlineGraphicElement = null;
         var _loc12_:String = null;
         var _loc13_:Number = NaN;
         var _loc14_:LeadingAdjustment = null;
         var _loc15_:Number = NaN;
         var _loc4_:LeadingAdjustment = null;
         var _loc5_:TextLine = param1.getTextLine();
         var _loc6_:ParagraphElement = param1.paragraph;
         var _loc7_:FlowLeafElement = this._curElement;
         var _loc8_:int = _loc7_.getAbsoluteStart();
         var _loc9_:Number = _loc7_.getEffectiveFontSize();
         var _loc10_:Number = 0;
         while(_loc7_ && _loc8_ < param1.absoluteStart + param1.textLength)
         {
            if(_loc8_ >= param1.absoluteStart || _loc8_ + _loc7_.textLength >= param1.absoluteStart)
            {
               if(_loc7_ is InlineGraphicElement)
               {
                  _loc11_ = _loc7_ as InlineGraphicElement;
                  if(!(this._blockProgression == BlockProgression.RL && _loc7_.parent is TCYElement))
                  {
                     if(_loc10_ < _loc11_.getEffectiveFontSize())
                     {
                        _loc10_ = _loc11_.getEffectiveFontSize();
                        if(_loc10_ >= _loc9_)
                        {
                           _loc10_ = _loc10_;
                           _loc12_ = _loc7_.computedFormat.dominantBaseline;
                           if(_loc12_ == FormatValue.AUTO)
                           {
                              _loc12_ = LocaleUtil.dominantBaseline(_loc6_.computedFormat.locale);
                           }
                           if(_loc12_ == TextBaseline.IDEOGRAPHIC_CENTER)
                           {
                              _loc13_ = TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(_loc11_.computedFormat.lineHeight,_loc11_.getEffectiveFontSize());
                              _loc14_ = this.calculateLinePlacementAdjustment(_loc5_,_loc12_,param2,_loc11_,param3);
                              if(!_loc4_ || Math.abs(_loc14_.rise) > Math.abs(_loc4_.rise) || Math.abs(_loc14_.leading) > Math.abs(_loc4_.leading))
                              {
                                 if(_loc4_)
                                 {
                                    _loc4_.rise = _loc14_.rise;
                                    _loc4_.leading = _loc14_.leading;
                                 }
                                 else
                                 {
                                    _loc4_ = _loc14_;
                                 }
                              }
                           }
                        }
                     }
                  }
               }
               else
               {
                  _loc15_ = _loc7_.getEffectiveFontSize();
                  if(_loc9_ <= _loc15_)
                  {
                     _loc9_ = _loc15_;
                  }
                  if(_loc4_ && _loc10_ < _loc9_)
                  {
                     _loc4_.leading = 0;
                     _loc4_.rise = 0;
                  }
               }
            }
            _loc8_ = _loc8_ + _loc7_.textLength;
            _loc7_ = _loc7_.getNextLeaf(_loc6_);
         }
         return _loc4_;
      }
      
      public function get swfContext() : ISWFContext
      {
         var _loc1_:ISWFContext = this._flowComposer.swfContext;
         return !!_loc1_?_loc1_:GlobalSWFContext.globalSWFContext;
      }
      
      private function calculateLinePlacementAdjustment(param1:TextLine, param2:String, param3:String, param4:InlineGraphicElement, param5:Boolean) : LeadingAdjustment
      {
         var _loc6_:LeadingAdjustment = new LeadingAdjustment();
         var _loc7_:Number = TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(param4.computedFormat.lineHeight,param4.getEffectiveFontSize());
         var _loc8_:Number = TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(param4.computedFormat.lineHeight,param1.textHeight);
         if(param2 == TextBaseline.IDEOGRAPHIC_CENTER)
         {
            if(!param5)
            {
               _loc6_.rise = _loc6_.rise + (_loc7_ - _loc8_) / 2;
            }
            else
            {
               _loc6_.leading = _loc6_.leading - (_loc7_ - _loc8_) / 2;
            }
         }
         return _loc6_;
      }
   }
}

import flash.text.engine.TextLine;

class AlignData
{
    
   
   public var textLine:TextLine;
   
   public var lineWidth:Number;
   
   public var center:Boolean;
   
   public var leftSideGap:Number;
   
   public var rightSideGap:Number;
   
   function AlignData()
   {
      super();
   }
}

import flashx.textLayout.compose.ISWFContext;

class GlobalSWFContext implements ISWFContext
{
   
   public static const globalSWFContext:GlobalSWFContext = new GlobalSWFContext();
    
   
   function GlobalSWFContext()
   {
      super();
   }
   
   public function callInContext(param1:Function, param2:Object, param3:Array, param4:Boolean = true) : *
   {
      if(param4)
      {
         return param1.apply(param2,param3);
      }
      param1.apply(param2,param3);
   }
}

class LeadingAdjustment
{
    
   
   public var rise:Number = 0;
   
   public var leading:Number = 0;
   
   public var lineHeight:Number = 0;
   
   function LeadingAdjustment()
   {
      super();
   }
}
