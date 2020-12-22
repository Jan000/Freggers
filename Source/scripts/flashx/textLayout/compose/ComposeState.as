package flashx.textLayout.compose
{
   import flash.geom.Rectangle;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.VerticalAlign;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class ComposeState extends BaseCompose
   {
      
      private static var _sharedComposeState:ComposeState;
       
      
      protected var _curLineIndex:int;
      
      protected var vjBeginLineIndex:int;
      
      protected var vjDisableThisParcel:Boolean;
      
      public function ComposeState()
      {
         super();
      }
      
      tlf_internal static function getComposeState() : ComposeState
      {
         var _loc1_:ComposeState = !!_sharedComposeState?_sharedComposeState:new ComposeState();
         _sharedComposeState = null;
         return _loc1_;
      }
      
      tlf_internal static function releaseComposeState(param1:ComposeState) : void
      {
         if(_sharedComposeState == null)
         {
            _sharedComposeState = param1;
            if(_sharedComposeState)
            {
               _sharedComposeState.releaseAnyReferences();
            }
         }
      }
      
      override protected function createParcelList() : IParcelList
      {
         return ParcelList.getParcelList();
      }
      
      override protected function releaseParcelList(param1:IParcelList) : void
      {
         ParcelList.releaseParcelList(param1);
      }
      
      override public function composeTextFlow(param1:TextFlow, param2:int, param3:int) : int
      {
         this._curLineIndex = 0;
         this.vjBeginLineIndex = 0;
         this.vjDisableThisParcel = false;
         return super.composeTextFlow(param1,param2,param3);
      }
      
      override protected function initializeForComposer(param1:IFlowComposer, param2:int, param3:int) : void
      {
         super.initializeForComposer(param1,param2,param3);
         _startComposePosition = param1.damageAbsoluteStart;
         var _loc4_:int = param1.findControllerIndexAtPosition(_startComposePosition);
         if(_loc4_ == -1)
         {
            _loc4_ = param1.numControllers - 1;
            while(_loc4_ != 0 && param1.getControllerAt(_loc4_).textLength == 0)
            {
               _loc4_--;
            }
         }
         _startController = param1.getControllerAt(_loc4_);
         if(_startController.computedFormat.verticalAlign != VerticalAlign.TOP)
         {
            _startComposePosition = _startController.absoluteStart;
         }
      }
      
      override protected function composeInternal(param1:FlowGroupElement, param2:int) : void
      {
         super.composeInternal(param1,param2);
         if(_curElement)
         {
            while(this._curLineIndex < _flowComposer.numLines)
            {
               _flowComposer.getLineAt(this._curLineIndex++).setController(null,-1);
            }
         }
      }
      
      override protected function doVerticalAlignment(param1:Boolean, param2:Parcel) : Boolean
      {
         var _loc4_:ContainerController = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc3_:Boolean = false;
         if(param1 && _curParcel && this.vjBeginLineIndex != this._curLineIndex && !this.vjDisableThisParcel && _curParcel.columnCoverage == Parcel.FULL_COLUMN)
         {
            _loc4_ = _curParcel.controller;
            _loc5_ = _loc4_.computedFormat.verticalAlign;
            if(_loc5_ != VerticalAlign.TOP)
            {
               _loc6_ = _flowComposer.findLineIndexAtPosition(_curElementStart + _curElementOffset);
               if(this.vjBeginLineIndex < _loc6_)
               {
                  applyVerticalAlignmentToColumn(_loc4_,_loc5_,_flowComposer.lines,this.vjBeginLineIndex,_loc6_ - this.vjBeginLineIndex);
                  _loc3_ = true;
               }
            }
         }
         this.vjDisableThisParcel = false;
         this.vjBeginLineIndex = this._curLineIndex;
         return _loc3_;
      }
      
      override protected function finalParcelAdjustment(param1:ContainerController) : void
      {
         var _loc8_:TextFlowLine = null;
         var _loc9_:Number = NaN;
         var _loc10_:ITextLayoutFormat = null;
         var _loc11_:FlowLeafElement = null;
         var _loc12_:Number = NaN;
         var _loc2_:Number = TextLine.MAX_LINE_WIDTH;
         var _loc3_:Number = TextLine.MAX_LINE_WIDTH;
         var _loc4_:Number = -TextLine.MAX_LINE_WIDTH;
         var _loc5_:Number = -TextLine.MAX_LINE_WIDTH;
         var _loc6_:* = _blockProgression == BlockProgression.RL;
         var _loc7_:int = _flowComposer.findLineIndexAtPosition(param1.absoluteStart);
         while(_loc7_ < this._curLineIndex)
         {
            _loc8_ = _flowComposer.getLineAt(_loc7_);
            if(_loc6_)
            {
               _loc4_ = Math.max(_loc8_.x + _loc8_.ascent,_loc4_);
               _loc2_ = Math.min(_loc8_.x,_loc2_);
            }
            else
            {
               _loc3_ = Math.min(_loc8_.y,_loc3_);
            }
            if(_loc8_.hasGraphicElement)
            {
               _loc11_ = _textFlow.findLeaf(_loc8_.absoluteStart);
               _loc12_ = _loc8_.getLineTypographicAscent(_loc11_,_loc11_.getAbsoluteStart());
               if(!_loc6_)
               {
                  _loc3_ = Math.min(_loc8_.y + _loc8_.ascent - _loc12_,_loc3_);
               }
               else
               {
                  _loc4_ = Math.max(_loc8_.x + _loc12_,_loc4_);
               }
            }
            _loc10_ = _loc8_.paragraph.computedFormat;
            if(_loc10_.direction == Direction.LTR)
            {
               _loc9_ = Math.max(_loc8_.lineOffset,0);
            }
            else
            {
               _loc9_ = _loc10_.paragraphEndIndent;
            }
            if(_loc6_)
            {
               _loc3_ = Math.min(_loc8_.y - _loc9_,_loc3_);
            }
            else
            {
               _loc2_ = Math.min(_loc8_.x - _loc9_,_loc2_);
            }
            _loc7_++;
         }
         if(_blockProgression == BlockProgression.RL)
         {
            _loc2_ = _loc2_ - _lastLineDescent;
         }
         if(_loc2_ != TextLine.MAX_LINE_WIDTH && Math.abs(_loc2_ - _parcelLeft) >= 1)
         {
            _parcelLeft = _loc2_;
         }
         if(_loc4_ != -TextLine.MAX_LINE_WIDTH && Math.abs(_loc4_ - _parcelRight) >= 1)
         {
            _parcelRight = _loc4_;
         }
         if(_loc3_ != TextLine.MAX_LINE_WIDTH && Math.abs(_loc3_ - _parcelTop) >= 1)
         {
            _parcelTop = _loc3_;
         }
         if(_loc5_ != -TextLine.MAX_LINE_WIDTH && Math.abs(_loc5_ - _parcelBottom) >= 1)
         {
            _parcelBottom = _loc5_;
         }
      }
      
      private function finalizeLine(param1:Boolean, param2:TextFlowLine) : void
      {
         if(!param1)
         {
            _flowComposer.addLine(param2,this._curLineIndex);
         }
         this._curLineIndex++;
         commitLastLineState(param2);
      }
      
      override protected function composeParagraphElement(param1:ParagraphElement, param2:int) : Boolean
      {
         _curParaElement = param1;
         _curParaStart = param2;
         _curParaFormat = param1.computedFormat;
         if(_startComposePosition == 0)
         {
            _curElement = param1.getFirstLeaf();
            _curElementStart = _curParaStart;
         }
         else
         {
            _curElement = param1.findLeaf(_startComposePosition - param2);
            _curElementStart = _curElement.getAbsoluteStart();
            _curElementOffset = _startComposePosition - _curElementStart;
            this._curLineIndex = _flowComposer.findLineIndexAtPosition(_curElementStart + _curElementOffset);
            _startComposePosition = 0;
         }
         return composeParagraphElementIntoLines();
      }
      
      override protected function composeNextLine() : TextFlowLine
      {
         var _loc5_:TextFlowLine = null;
         var _loc1_:TextFlowLine = this._curLineIndex < _flowComposer.numLines?_flowComposer.lines[this._curLineIndex]:null;
         var _loc2_:Boolean = _loc1_ && (!_loc1_.isDamaged() || _loc1_.validity == FlowDamageType.GEOMETRY);
         var _loc3_:TextFlowLine = !!_loc2_?_loc1_:null;
         var _loc4_:int = _curElementStart + _curElementOffset - _curParaStart;
         if(_loc4_ != 0)
         {
            _loc5_ = _flowComposer.lines[this._curLineIndex - 1];
            if(_loc5_.absoluteStart < _curParaStart)
            {
               _loc5_ = null;
            }
         }
         var _loc6_:Rectangle = _parcelList.currentParcel;
         while(true)
         {
            while(!_loc3_)
            {
               _loc2_ = false;
               _loc3_ = this.createTextLine(_loc5_,_loc4_,_parcelList.getComposeXCoord(_loc6_),_parcelList.getComposeYCoord(_loc6_),_parcelList.getComposeWidth(_loc6_));
               if(_loc3_ != null)
               {
                  break;
               }
               if(!_parcelList.next())
               {
                  return null;
               }
            }
            _loc3_ = fitLineToParcel(_loc3_,!_loc2_);
            if(_loc3_)
            {
               break;
            }
            if(_parcelList.atEnd())
            {
               return null;
            }
            _loc6_ = _lineSlug;
         }
         if(_loc3_.validity == FlowDamageType.GEOMETRY)
         {
            _loc3_.clearDamage();
         }
         this.finalizeLine(_loc2_,_loc3_);
         return _loc3_;
      }
      
      protected function createTextLine(param1:TextFlowLine, param2:int, param3:Number, param4:Number, param5:Number) : TextFlowLine
      {
         var _loc6_:Number = Number(_curParaFormat.paragraphStartIndent);
         if(param1 == null)
         {
            _loc6_ = _loc6_ + Number(_curParaFormat.textIndent);
         }
         var _loc7_:Number = param5;
         param5 = param5 - (Number(_curParaFormat.paragraphEndIndent) + _loc6_);
         if(param5 < 0)
         {
            param5 = 0;
         }
         else if(param5 > TextLine.MAX_LINE_WIDTH)
         {
            param5 = TextLine.MAX_LINE_WIDTH;
         }
         var _loc8_:TextLine = TextLineRecycler.getLineForReuse();
         var _loc9_:TextBlock = _curParaElement.getTextBlock();
         if(_loc8_)
         {
            _loc8_ = swfContext.callInContext(_loc9_["recreateTextLine"],_loc9_,[_loc8_,!!param1?param1.getTextLine(true):null,param5,_loc6_,true]);
         }
         else
         {
            _loc8_ = swfContext.callInContext(_loc9_.createTextLine,_loc9_,[!!param1?param1.getTextLine(true):null,param5,_loc6_,true]);
         }
         if(_loc8_ == null)
         {
            return null;
         }
         var _loc10_:TextFlowLine = new TextFlowLine(_loc8_,_curParaElement,_loc7_,_loc6_,param2 + _curParaStart,_loc8_.rawTextLength);
         _loc8_.doubleClickEnabled = true;
         return _loc10_;
      }
   }
}
