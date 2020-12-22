package flashx.textLayout.compose
{
   import flash.display.DisplayObject;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsPathWinding;
   import flash.display.Shape;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.engine.TextBaseline;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineValidity;
   import flash.text.engine.TextRotation;
   import flash.utils.Dictionary;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.edit.ISelectionManager;
   import flashx.textLayout.edit.SelectionFormat;
   import flashx.textLayout.elements.ContainerFormattedElement;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.FlowValueHolder;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.SubParagraphGroupElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.external.WeakRef;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.Float;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.JustificationRule;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   import flashx.textLayout.utils.CharacterUtil;
   
   use namespace tlf_internal;
   
   public final class TextFlowLine implements IVerticalJustificationLine
   {
      
      private static var _selectionBlockCache:Dictionary = new Dictionary(true);
      
      private static const EMPTY_LINE_WIDTH:Number = 2;
       
      
      private var _absoluteStart:int;
      
      private var _textLength:int;
      
      private var _height:Number = 0;
      
      private var _x:Number = 0;
      
      private var _y:Number = 0;
      
      private var _outerTargetWidth:Number = 0;
      
      private var _boundsLeftTW:int = 2;
      
      private var _boundsRightTW:int = 1;
      
      private var _boundsTopTW:int;
      
      private var _boundsBottomTW:int;
      
      private var _para:ParagraphElement;
      
      private var _controller:ContainerController;
      
      private var _columnIndex:int;
      
      private var _adornCount:int = 0;
      
      private var _ascent:Number;
      
      private var _descent:Number;
      
      private var _targetWidth:Number;
      
      private var _validity:String;
      
      private var _textHeight:Number;
      
      private var _lineOffset:Number;
      
      private var _lineExtent:Number;
      
      private var _released:Boolean;
      
      private var _alignment:String;
      
      private var _hasGraphicElement:Boolean;
      
      private var _textLineCache:WeakRef;
      
      public function TextFlowLine(param1:TextLine, param2:ParagraphElement, param3:Number = 0, param4:Number = 0, param5:int = 0, param6:int = 0)
      {
         super();
         this.initialize(param2,param3,param4,param5,param6,param1);
      }
      
      tlf_internal static function getTextLineTypographicAscent(param1:TextLine, param2:FlowLeafElement, param3:int, param4:int, param5:ParagraphElement) : Number
      {
         var _loc6_:Number = param1.getBaselinePosition(TextBaseline.ROMAN) - param1.getBaselinePosition(TextBaseline.ASCENT);
         while(true)
         {
            if(param2 is InlineGraphicElement)
            {
               _loc6_ = Math.max(_loc6_,InlineGraphicElement(param2).getTypographicAscent(param1));
            }
            param3 = param3 + param2.textLength;
            if(param3 >= param4)
            {
               break;
            }
            param2 = param2.getNextLeaf(param5);
         }
         return _loc6_;
      }
      
      private static function createSelectionRect(param1:Shape, param2:uint, param3:Number, param4:Number, param5:Number, param6:Number) : DisplayObject
      {
         param1.graphics.beginFill(param2);
         var _loc7_:Vector.<int> = new Vector.<int>();
         var _loc8_:Vector.<Number> = new Vector.<Number>();
         _loc7_.push(GraphicsPathCommand.MOVE_TO);
         _loc8_.push(param3);
         _loc8_.push(param4);
         _loc7_.push(GraphicsPathCommand.LINE_TO);
         _loc8_.push(param3 + param5);
         _loc8_.push(param4);
         _loc7_.push(GraphicsPathCommand.LINE_TO);
         _loc8_.push(param3 + param5);
         _loc8_.push(param4 + param6);
         _loc7_.push(GraphicsPathCommand.LINE_TO);
         _loc8_.push(param3);
         _loc8_.push(param4 + param6);
         _loc7_.push(GraphicsPathCommand.LINE_TO);
         _loc8_.push(param3);
         _loc8_.push(param4);
         param1.graphics.drawPath(_loc7_,_loc8_,GraphicsPathWinding.NON_ZERO);
         return param1;
      }
      
      tlf_internal static function constrainRectToColumn(param1:TextFlow, param2:Rectangle, param3:Rectangle, param4:Number, param5:Number, param6:Number, param7:Number) : void
      {
         if(param1.computedFormat.lineBreak == LineBreak.EXPLICIT)
         {
            return;
         }
         var _loc8_:String = param1.computedFormat.blockProgression;
         var _loc9_:String = param1.computedFormat.direction;
         if(_loc8_ == BlockProgression.TB && !isNaN(param6))
         {
            if(_loc9_ == Direction.LTR)
            {
               if(param2.left > param3.x + param3.width + param4)
               {
                  param2.left = param3.x + param3.width + param4;
               }
               if(param2.right > param3.x + param3.width + param4)
               {
                  param2.right = param3.x + param3.width + param4;
               }
            }
            else
            {
               if(param2.right < param3.x + param4)
               {
                  param2.right = param3.x + param4;
               }
               if(param2.left < param3.x + param4)
               {
                  param2.left = param3.x + param4;
               }
            }
         }
         else if(_loc8_ == BlockProgression.RL && !isNaN(param7))
         {
            if(_loc9_ == Direction.LTR)
            {
               if(param2.top > param3.y + param3.height + param5)
               {
                  param2.top = param3.y + param3.height + param5;
               }
               if(param2.bottom > param3.y + param3.height + param5)
               {
                  param2.bottom = param3.y + param3.height + param5;
               }
            }
            else
            {
               if(param2.bottom < param3.y + param5)
               {
                  param2.bottom = param3.y + param5;
               }
               if(param2.top < param3.y + param5)
               {
                  param2.top = param3.y + param5;
               }
            }
         }
      }
      
      private static function setRectangleValues(param1:Rectangle, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         param1.x = param2;
         param1.y = param3;
         param1.width = param4;
         param1.height = param5;
      }
      
      tlf_internal function get hasGraphicElement() : Boolean
      {
         return this._hasGraphicElement;
      }
      
      public function get textHeight() : Number
      {
         return this._textHeight;
      }
      
      tlf_internal function isLineVisible(param1:String, param2:int, param3:int, param4:int, param5:int) : Boolean
      {
         if(this._boundsLeftTW > this._boundsRightTW)
         {
            return false;
         }
         if(param1 == BlockProgression.RL)
         {
            return this._boundsRightTW >= param2 && this._boundsLeftTW < param2 + param4;
         }
         return this._boundsBottomTW >= param3 && this._boundsTopTW < param3 + param5;
      }
      
      tlf_internal function setLineBounds(param1:int, param2:int, param3:int, param4:int) : void
      {
         this._boundsLeftTW = param1;
         this._boundsRightTW = param1 + param3;
         this._boundsTopTW = param2;
         this._boundsBottomTW = param2 + param4;
      }
      
      tlf_internal function hasLineBounds() : Boolean
      {
         return this._boundsLeftTW <= this._boundsRightTW;
      }
      
      tlf_internal function initialize(param1:ParagraphElement, param2:Number = 0, param3:Number = 0, param4:int = 0, param5:int = 0, param6:TextLine = null) : void
      {
         this._para = param1;
         this._outerTargetWidth = param2;
         this._absoluteStart = param4;
         this._textLength = param5;
         this._released = param6 == null;
         if(param6)
         {
            this._textLineCache = new WeakRef(param6);
            param6.userData = this;
            this._targetWidth = param6.specifiedWidth;
            this._ascent = param6.ascent;
            this._descent = param6.descent;
            this._textHeight = param6.textHeight;
            this._lineOffset = param3;
            this._validity = TextLineValidity.VALID;
            this._hasGraphicElement = param6.hasGraphicElement;
         }
         else
         {
            this._validity = TextLineValidity.INVALID;
         }
      }
      
      tlf_internal function releaseTextLine() : void
      {
         this._textLineCache = null;
      }
      
      tlf_internal function peekTextLine() : TextLine
      {
         return !!this._textLineCache?this._textLineCache.get():null;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set x(param1:Number) : void
      {
         this._x = param1;
         this._boundsLeftTW = 2;
         this._boundsRightTW = 1;
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set y(param1:Number) : void
      {
         this._y = param1;
         this._boundsLeftTW = 2;
         this._boundsRightTW = 1;
      }
      
      tlf_internal function setXYAndHeight(param1:Number, param2:Number, param3:Number) : void
      {
         this._x = param1;
         this._y = param2;
         this._height = param3;
         this._boundsLeftTW = 2;
         this._boundsRightTW = 1;
      }
      
      public function get location() : int
      {
         var _loc1_:int = 0;
         if(this._para)
         {
            _loc1_ = this._absoluteStart - this._para.getAbsoluteStart();
            if(_loc1_ == 0)
            {
               return this._textLength == this._para.textLength?int(TextFlowLineLocation.ONLY):int(TextFlowLineLocation.FIRST);
            }
            if(_loc1_ + this._textLength == this._para.textLength)
            {
               return TextFlowLineLocation.LAST;
            }
         }
         return TextFlowLineLocation.MIDDLE;
      }
      
      public function get controller() : ContainerController
      {
         return this._controller;
      }
      
      public function get columnIndex() : int
      {
         return this._columnIndex;
      }
      
      tlf_internal function setController(param1:ContainerController, param2:int) : void
      {
         this._controller = param1 as ContainerController;
         this._columnIndex = param2;
      }
      
      public function get height() : Number
      {
         return this._height;
      }
      
      public function get ascent() : Number
      {
         return this._ascent;
      }
      
      public function get descent() : Number
      {
         return this._descent;
      }
      
      public function get lineOffset() : Number
      {
         return this._lineOffset;
      }
      
      public function get paragraph() : ParagraphElement
      {
         return this._para;
      }
      
      public function get absoluteStart() : int
      {
         return this._absoluteStart;
      }
      
      tlf_internal function setAbsoluteStart(param1:int) : void
      {
         this._absoluteStart = param1;
      }
      
      public function get textLength() : int
      {
         return this._textLength;
      }
      
      tlf_internal function setTextLength(param1:int) : void
      {
         this._textLength = param1;
         this.damage(TextLineValidity.INVALID);
      }
      
      public function get spaceBefore() : Number
      {
         return !!(this.location & TextFlowLineLocation.FIRST)?Number(this._para.computedFormat.paragraphSpaceBefore):Number(0);
      }
      
      public function get spaceAfter() : Number
      {
         return !!(this.location & TextFlowLineLocation.LAST)?Number(this._para.computedFormat.paragraphSpaceAfter):Number(0);
      }
      
      tlf_internal function get outerTargetWidth() : Number
      {
         return this._outerTargetWidth;
      }
      
      tlf_internal function set outerTargetWidth(param1:Number) : void
      {
         this._outerTargetWidth = param1;
      }
      
      tlf_internal function get targetWidth() : Number
      {
         return this._targetWidth;
      }
      
      public function getBounds() : Rectangle
      {
         var _loc1_:TextLine = this.getTextLine(true);
         if(!_loc1_)
         {
            return new Rectangle();
         }
         var _loc2_:String = this.paragraph.getAncestorWithContainer().computedFormat.blockProgression;
         var _loc3_:Number = this.createShapeX();
         var _loc4_:Number = this.createShapeY(_loc2_);
         if(_loc2_ == BlockProgression.TB)
         {
            _loc4_ = _loc4_ + (this.descent - _loc1_.height);
         }
         return new Rectangle(_loc3_,_loc4_,_loc1_.width,_loc1_.height);
      }
      
      public function get validity() : String
      {
         var _loc1_:TextLine = null;
         if(!this._released)
         {
            _loc1_ = this.peekTextLine();
            if(_loc1_ && (this._validity == FlowDamageType.GEOMETRY || this._validity == TextLineValidity.VALID) && _loc1_.validity != TextLineValidity.VALID)
            {
               this._validity = _loc1_.validity;
            }
         }
         return this._validity;
      }
      
      public function get unjustifiedTextWidth() : Number
      {
         var _loc1_:TextLine = this.getTextLine(true);
         return _loc1_.unjustifiedTextWidth + (this._outerTargetWidth - this.targetWidth);
      }
      
      tlf_internal function get lineExtent() : Number
      {
         return this._lineExtent;
      }
      
      tlf_internal function set lineExtent(param1:Number) : void
      {
         this._lineExtent = param1;
      }
      
      tlf_internal function get alignment() : String
      {
         return this._alignment;
      }
      
      tlf_internal function set alignment(param1:String) : void
      {
         this._alignment = param1;
      }
      
      tlf_internal function isDamaged() : Boolean
      {
         var _loc1_:TextLine = null;
         if(this._validity != TextLineValidity.VALID)
         {
            return true;
         }
         if(!this._released)
         {
            _loc1_ = this.peekTextLine();
            if(_loc1_ && _loc1_.validity != TextLineValidity.VALID)
            {
               return true;
            }
         }
         return false;
      }
      
      tlf_internal function clearDamage() : void
      {
         if(this._validity == TextLineValidity.VALID)
         {
            return;
         }
         this._validity = TextLineValidity.VALID;
         var _loc1_:TextLine = this.peekTextLine();
         if(_loc1_ && !this._released)
         {
            _loc1_.validity = TextLineValidity.VALID;
         }
      }
      
      tlf_internal function damage(param1:String) : void
      {
         if(this._validity == param1 || this._validity == TextLineValidity.INVALID)
         {
            return;
         }
         this._validity = param1;
         var _loc2_:TextLine = this.peekTextLine();
         if(_loc2_ && _loc2_.validity != TextLineValidity.INVALID)
         {
            _loc2_.validity = this._validity;
         }
      }
      
      public function get textLineExists() : Boolean
      {
         return this.peekTextLine() != null;
      }
      
      public function getTextLine(param1:Boolean = false) : TextLine
      {
         var _loc3_:TextBlock = null;
         var _loc4_:TextLine = null;
         var _loc5_:TextLine = null;
         var _loc6_:IFlowComposer = null;
         var _loc7_:int = 0;
         var _loc8_:TextFlowLine = null;
         var _loc9_:ParagraphElement = null;
         var _loc10_:int = 0;
         var _loc11_:FlowLeafElement = null;
         var _loc12_:int = 0;
         var _loc2_:TextLine = this.peekTextLine();
         if(!_loc2_ || _loc2_.validity != TextLineValidity.VALID && param1)
         {
            if(this.isDamaged() && this.validity != FlowDamageType.GEOMETRY)
            {
               return null;
            }
            _loc3_ = this.paragraph.getTextBlock();
            _loc5_ = _loc3_.firstLine;
            _loc6_ = this.paragraph.getTextFlow().flowComposer;
            _loc7_ = _loc6_.findLineIndexAtPosition(this.paragraph.getAbsoluteStart());
            do
            {
               _loc8_ = _loc6_.getLineAt(_loc7_);
               if(_loc5_ != null && _loc5_.validity == TextLineValidity.VALID)
               {
                  _loc2_ = _loc5_;
                  _loc5_ = _loc5_.nextLine;
                  _loc8_.updateTextLineCache(_loc2_);
               }
               else
               {
                  _loc2_ = _loc8_.recreateTextLine(_loc3_,_loc4_);
                  _loc5_ = null;
               }
               _loc4_ = _loc2_;
               _loc7_++;
            }
            while(_loc8_ != this);
            
         }
         if(_loc2_ != null && _loc2_.numChildren == 0 && this._adornCount > 0)
         {
            _loc9_ = this.paragraph;
            _loc10_ = _loc9_.getAbsoluteStart();
            _loc11_ = _loc9_.findLeaf(this.absoluteStart - _loc10_);
            _loc12_ = _loc11_.getAbsoluteStart();
            this.createAdornments(_loc9_.getAncestorWithContainer().computedFormat.blockProgression,_loc11_,_loc12_);
         }
         return _loc2_;
      }
      
      tlf_internal function recreateTextLine(param1:TextBlock, param2:TextLine) : TextLine
      {
         var _loc3_:TextLine = null;
         if(!this._released)
         {
            _loc3_ = this.peekTextLine();
            if(_loc3_)
            {
               return _loc3_;
            }
         }
         var _loc4_:TextFlow = this.paragraph.getTextFlow();
         var _loc5_:IFlowComposer = _loc4_.flowComposer;
         var _loc6_:ISWFContext = !!_loc5_.swfContext?_loc5_.swfContext:BaseCompose.globalSWFContext;
         _loc3_ = TextLineRecycler.getLineForReuse();
         if(_loc3_)
         {
            _loc3_ = _loc6_.callInContext(param1["recreateTextLine"],param1,[_loc3_,param2,this._targetWidth,this._lineOffset,true]);
         }
         else
         {
            _loc3_ = _loc6_.callInContext(param1.createTextLine,param1,[param2,this._targetWidth,this._lineOffset,true]);
         }
         _loc3_.x = this.createShapeX();
         _loc3_.y = this.createShapeY(_loc4_.computedFormat.blockProgression);
         _loc3_.doubleClickEnabled = true;
         this.updateTextLineCache(_loc3_);
         return _loc3_;
      }
      
      private function updateTextLineCache(param1:TextLine) : void
      {
         param1.userData = this;
         var _loc2_:TextLine = this.peekTextLine();
         if(!_loc2_ || _loc2_.parent == null)
         {
            if(_loc2_ != param1)
            {
               this._textLineCache = new WeakRef(param1);
            }
            this._released = false;
         }
      }
      
      tlf_internal function markReleased() : void
      {
         this._released = true;
      }
      
      tlf_internal function createShape(param1:String) : TextLine
      {
         var _loc2_:TextLine = this.getTextLine();
         var _loc3_:Number = this.createShapeX();
         _loc2_.x = _loc3_;
         var _loc4_:Number = this.createShapeY(param1);
         _loc2_.y = _loc4_;
         return _loc2_;
      }
      
      private function createShapeX() : Number
      {
         return this.x;
      }
      
      private function createShapeY(param1:String) : Number
      {
         return param1 == BlockProgression.RL?Number(this.y):Number(this.y + this._ascent);
      }
      
      tlf_internal function createAdornments(param1:String, param2:FlowLeafElement, param3:int) : void
      {
         var _loc5_:ITextLayoutFormat = null;
         var _loc6_:FlowValueHolder = null;
         var _loc4_:int = this._absoluteStart + this._textLength;
         this._adornCount = 0;
         while(true)
         {
            _loc5_ = param2.computedFormat;
            this._adornCount = this._adornCount + param2.updateAdornments(this,param1);
            _loc6_ = param2.format as FlowValueHolder;
            if(_loc6_ && _loc6_.userStyles && _loc6_.userStyles.imeStatus)
            {
               param2.updateIMEAdornments(this,param1,_loc6_.userStyles.imeStatus as String);
            }
            param3 = param3 + param2.textLength;
            if(param3 >= _loc4_)
            {
               break;
            }
            param2 = param2.getNextLeaf(this._para);
         }
      }
      
      tlf_internal function getLineLeading(param1:String, param2:FlowLeafElement, param3:int) : Number
      {
         var _loc6_:Number = NaN;
         var _loc4_:int = this._absoluteStart + this._textLength;
         var _loc5_:Number = 0;
         while(true)
         {
            if(!(param1 == BlockProgression.RL && param2.parent is TCYElement && (!isNaN(_loc5_) || param2.textLength != this.textLength)))
            {
               _loc6_ = TextLayoutFormat.lineHeightProperty.computeActualPropertyValue(param2.computedFormat.lineHeight,param2.getEffectiveFontSize());
               _loc5_ = Math.max(_loc5_,_loc6_);
            }
            param3 = param3 + param2.textLength;
            if(param3 >= _loc4_)
            {
               break;
            }
            param2 = param2.getNextLeaf(this._para);
         }
         return _loc5_;
      }
      
      tlf_internal function getLineTypographicAscent(param1:FlowLeafElement, param2:int) : Number
      {
         return getTextLineTypographicAscent(this.getTextLine(),param1,param2,this.absoluteStart + this.textLength,this._para);
      }
      
      private function isTextlineSubsetOfSpan(param1:FlowLeafElement) : Boolean
      {
         var _loc2_:int = param1.getAbsoluteStart();
         var _loc3_:int = _loc2_ + param1.textLength;
         var _loc4_:int = this.absoluteStart;
         var _loc5_:int = this.absoluteStart + this._textLength;
         return _loc2_ <= _loc4_ && _loc3_ >= _loc5_;
      }
      
      private function getSelectionShapesCacheEntry(param1:int, param2:int, param3:TextFlowLine, param4:TextFlowLine, param5:String) : SelectionCache
      {
         var _loc12_:Rectangle = null;
         if(this.isDamaged())
         {
            return null;
         }
         var _loc6_:int = this._para.getAbsoluteStart();
         if(param1 == param2 && _loc6_ + param1 == this.absoluteStart)
         {
            if(this.absoluteStart != this._para.getTextFlow().textLength - 1)
            {
               return null;
            }
            param2++;
         }
         var _loc7_:SelectionCache = _selectionBlockCache[this];
         if(_loc7_ && _loc7_.begIdx == param1 && _loc7_.endIdx == param2)
         {
            return _loc7_;
         }
         var _loc8_:Array = new Array();
         var _loc9_:Array = new Array();
         if(_loc7_ == null)
         {
            _loc7_ = new SelectionCache();
            _selectionBlockCache[this] = _loc7_;
         }
         else
         {
            _loc7_.clear();
         }
         _loc7_.begIdx = param1;
         _loc7_.endIdx = param2;
         var _loc10_:TextLine = this.getTextLine();
         var _loc11_:Array = this.getRomanSelectionHeightAndVerticalAdjustment(param3,param4);
         this.calculateSelectionBounds(_loc10_,_loc8_,param1,param2,param5,_loc11_);
         for each(_loc12_ in _loc8_)
         {
            _loc7_.pushSelectionBlock(_loc12_);
         }
         if(_loc10_)
         {
            _loc10_.flushAtomData();
         }
         return _loc7_;
      }
      
      tlf_internal function calculateSelectionBounds(param1:TextLine, param2:Array, param3:int, param4:int, param5:String, param6:Array) : void
      {
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Array = null;
         var _loc18_:Array = null;
         var _loc19_:int = 0;
         var _loc20_:FlowElement = null;
         var _loc21_:int = 0;
         var _loc22_:SubParagraphGroupElement = null;
         var _loc23_:Number = NaN;
         var _loc24_:int = 0;
         var _loc25_:Array = null;
         var _loc26_:Array = null;
         var _loc27_:int = 0;
         var _loc28_:Rectangle = null;
         var _loc29_:int = 0;
         var _loc30_:Array = null;
         var _loc31_:Rectangle = null;
         var _loc32_:Rectangle = null;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc7_:String = this._para.computedFormat.direction;
         var _loc8_:int = this._para.getAbsoluteStart();
         var _loc9_:int = param3;
         var _loc10_:FlowLeafElement = null;
         var _loc11_:Number = 0;
         var _loc12_:Array = new Array();
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         while(_loc9_ < param4)
         {
            _loc10_ = this._para.findLeaf(_loc9_);
            if(_loc10_.textLength == 0)
            {
               _loc9_++;
            }
            else if(_loc10_ is InlineGraphicElement && (_loc10_ as InlineGraphicElement).float != Float.NONE)
            {
               if(_loc13_ == null)
               {
                  _loc13_ = new Array();
               }
               _loc17_ = this.makeSelectionBlocks(_loc9_,_loc9_ + 1,_loc8_,param5,_loc7_,param6);
               _loc13_.push(_loc17_[0]);
               _loc9_++;
            }
            else
            {
               _loc15_ = _loc10_.textLength + _loc10_.getElementRelativeStart(this._para) - _loc9_;
               _loc16_ = _loc15_ + _loc9_ > param4?int(param4):int(_loc15_ + _loc9_);
               if(param5 != BlockProgression.RL || param1.getAtomTextRotation(param1.getAtomIndexAtCharIndex(_loc9_)) != TextRotation.ROTATE_0)
               {
                  _loc18_ = this.makeSelectionBlocks(_loc9_,_loc16_,_loc8_,param5,_loc7_,param6);
                  _loc19_ = 0;
                  while(_loc19_ < _loc18_.length)
                  {
                     _loc12_.push(_loc18_[_loc19_]);
                     _loc19_++;
                  }
                  _loc9_ = _loc16_;
               }
               else
               {
                  _loc20_ = _loc10_.getParentByType(TCYElement);
                  _loc21_ = _loc20_.parentRelativeEnd;
                  _loc22_ = _loc20_.getParentByType(SubParagraphGroupElement) as SubParagraphGroupElement;
                  while(_loc22_)
                  {
                     _loc21_ = _loc21_ + _loc22_.parentRelativeStart;
                     _loc22_ = _loc22_.getParentByType(SubParagraphGroupElement) as SubParagraphGroupElement;
                  }
                  _loc23_ = 0;
                  _loc24_ = param4 < _loc21_?int(param4):int(_loc21_);
                  _loc25_ = new Array();
                  while(_loc9_ < _loc24_)
                  {
                     _loc10_ = this._para.findLeaf(_loc9_);
                     _loc15_ = _loc10_.textLength + _loc10_.getElementRelativeStart(this._para) - _loc9_;
                     _loc16_ = _loc15_ + _loc9_ > param4?int(param4):int(_loc15_ + _loc9_);
                     _loc26_ = this.makeSelectionBlocks(_loc9_,_loc16_,_loc8_,param5,_loc7_,param6);
                     _loc27_ = 0;
                     while(_loc27_ < _loc26_.length)
                     {
                        _loc28_ = _loc26_[_loc27_];
                        if(_loc28_.height > _loc23_)
                        {
                           _loc23_ = _loc28_.height;
                        }
                        _loc25_.push(_loc28_);
                        _loc27_++;
                     }
                     _loc9_ = _loc16_;
                  }
                  if(!_loc14_)
                  {
                     _loc14_ = new Array();
                  }
                  this.normalizeRects(_loc25_,_loc14_,_loc23_,BlockProgression.TB,_loc7_);
               }
            }
         }
         if(_loc12_.length > 0 && _loc8_ + param3 == this.absoluteStart && _loc8_ + param4 == this.absoluteStart + this.textLength)
         {
            _loc10_ = this._para.findLeaf(param3);
            if(_loc10_.getAbsoluteStart() + _loc10_.textLength < this.absoluteStart + this.textLength && _loc16_ >= 2)
            {
               _loc29_ = this._para.getCharCodeAtPosition(_loc16_ - 1);
               if(_loc29_ != SpanElement.kParagraphTerminator.charCodeAt(0) && CharacterUtil.isWhitespace(_loc29_))
               {
                  _loc30_ = this.makeSelectionBlocks(_loc16_ - 1,_loc16_ - 1,_loc8_,param5,_loc7_,param6);
                  _loc31_ = _loc30_[_loc30_.length - 1];
                  _loc32_ = _loc12_[_loc12_.length - 1] as Rectangle;
                  if(param5 != BlockProgression.RL)
                  {
                     if(_loc32_.width == _loc31_.width)
                     {
                        _loc12_.pop();
                     }
                     else
                     {
                        _loc32_.width = _loc32_.width - _loc31_.width;
                        if(_loc7_ == Direction.RTL)
                        {
                           _loc32_.left = _loc32_.left - _loc31_.width;
                        }
                     }
                  }
                  else if(_loc32_.height == _loc31_.height)
                  {
                     _loc12_.pop();
                  }
                  else
                  {
                     _loc32_.height = _loc32_.height - _loc31_.height;
                     if(_loc7_ == Direction.RTL)
                     {
                        _loc32_.top = _loc32_.top + _loc31_.height;
                     }
                  }
               }
            }
         }
         this.normalizeRects(_loc12_,param2,_loc11_,param5,_loc7_);
         if(_loc14_ && _loc14_.length > 0)
         {
            _loc33_ = 0;
            while(_loc33_ < _loc14_.length)
            {
               param2.push(_loc14_[_loc33_]);
               _loc33_++;
            }
         }
         if(_loc13_)
         {
            _loc34_ = 0;
            while(_loc34_ < _loc13_.length)
            {
               param2.push(_loc13_[_loc34_]);
               _loc34_++;
            }
         }
      }
      
      private function createSelectionShapes(param1:Shape, param2:SelectionFormat, param3:DisplayObject, param4:int, param5:int, param6:TextFlowLine, param7:TextFlowLine) : void
      {
         var _loc11_:Rectangle = null;
         var _loc13_:ISelectionManager = null;
         var _loc8_:ContainerFormattedElement = this._para.getAncestorWithContainer();
         var _loc9_:String = _loc8_.computedFormat.blockProgression;
         var _loc10_:SelectionCache = this.getSelectionShapesCacheEntry(param4,param5,param6,param7,_loc9_);
         if(!_loc10_)
         {
            return;
         }
         var _loc12_:uint = param2.rangeColor;
         if(this._para && this._para.getTextFlow())
         {
            _loc13_ = this._para.getTextFlow().interactionManager;
            if(_loc13_ && _loc13_.anchorPosition == _loc13_.activePosition)
            {
               _loc12_ = param2.pointColor;
            }
         }
         for each(_loc11_ in _loc10_.selectionBlocks)
         {
            _loc11_ = _loc11_.clone();
            this.convertLineRectToContainer(_loc11_,true);
            createSelectionRect(param1,_loc12_,_loc11_.x,_loc11_.y,_loc11_.width,_loc11_.height);
         }
      }
      
      tlf_internal function getRomanSelectionHeightAndVerticalAdjustment(param1:TextFlowLine, param2:TextFlowLine) : Array
      {
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(ParagraphElement.useUpLeadingDirection(this._para.getEffectiveLeadingModel()))
         {
            _loc3_ = this.height > this._textHeight?Number(this.height):Number(this._textHeight);
         }
         else
         {
            _loc5_ = !param1 || param1.controller != this.controller || param1.columnIndex != this.columnIndex;
            _loc6_ = !param2 || param2.controller != this.controller || param2.columnIndex != this.columnIndex || param2.paragraph.getEffectiveLeadingModel() == LeadingModel.ROMAN_UP;
            if(_loc6_)
            {
               if(!_loc5_)
               {
                  _loc3_ = this._textHeight;
               }
               else
               {
                  _loc3_ = this.height > this._textHeight?Number(this.height):Number(this._textHeight);
               }
            }
            else if(!_loc5_)
            {
               _loc3_ = param2.height > this._textHeight?Number(param2.height):Number(this._textHeight);
               _loc4_ = _loc3_ - this._textHeight;
            }
            else
            {
               _loc7_ = this._descent - (this.height > this._textHeight?this.height:this._textHeight);
               _loc8_ = (param2.height > this._textHeight?param2.height:this._textHeight) - this._ascent;
               _loc3_ = _loc8_ - _loc7_;
               _loc4_ = _loc8_ - this._descent;
            }
         }
         if(!param1 || param1.columnIndex != this.columnIndex || param1.controller != this.controller)
         {
            _loc3_ = _loc3_ + this.descent;
            _loc4_ = Math.floor(this.descent / 2);
         }
         return [_loc3_,_loc4_];
      }
      
      private function makeSelectionBlocks(param1:int, param2:int, param3:int, param4:String, param5:String, param6:Array) : Array
      {
         var _loc12_:Point = null;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:Rectangle = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:Array = null;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:Boolean = false;
         var _loc28_:Boolean = false;
         var _loc29_:InlineGraphicElement = null;
         var _loc7_:Array = new Array();
         var _loc8_:Rectangle = new Rectangle();
         var _loc9_:FlowLeafElement = this._para.findLeaf(param1);
         var _loc10_:Rectangle = _loc9_.getComputedFontMetrics().emBox;
         var _loc11_:TextLine = this.getTextLine(true);
         if(param3 + param1 == this.absoluteStart && param3 + param2 == this.absoluteStart + this.textLength)
         {
            _loc12_ = new Point(0,0);
            _loc13_ = this._para.getEffectiveJustificationRule();
            if(_loc13_ != JustificationRule.EAST_ASIAN)
            {
               if(param4 == BlockProgression.RL)
               {
                  _loc12_.x = _loc12_.x - param6[1];
                  _loc8_.width = param6[0];
                  _loc8_.height = _loc11_.textWidth == 0?Number(EMPTY_LINE_WIDTH):Number(_loc11_.textWidth);
               }
               else
               {
                  _loc12_.y = _loc12_.y + param6[1];
                  _loc8_.height = param6[0];
                  _loc8_.width = _loc11_.textWidth == 0?Number(EMPTY_LINE_WIDTH):Number(_loc11_.textWidth);
               }
            }
            else
            {
               _loc14_ = _loc11_.getAtomIndexAtCharIndex(param1);
               _loc15_ = _loc11_.getAtomBounds(_loc14_);
               if(param4 == BlockProgression.RL)
               {
                  _loc8_.width = _loc15_.width;
                  _loc8_.height = _loc11_.textWidth;
               }
               else
               {
                  _loc8_.height = _loc15_.height;
                  _loc8_.width = _loc11_.textWidth;
               }
            }
            _loc8_.x = _loc12_.x;
            _loc8_.y = _loc12_.y;
            if(param4 == BlockProgression.RL)
            {
               _loc8_.x = _loc8_.x - _loc11_.descent;
            }
            else
            {
               _loc8_.y = _loc8_.y + (_loc11_.descent - _loc8_.height);
            }
            if(_loc9_.computedFormat.textRotation == TextRotation.ROTATE_180 || _loc9_.computedFormat.textRotation == TextRotation.ROTATE_90)
            {
               if(param4 != BlockProgression.RL)
               {
                  _loc8_.y = _loc8_.y + _loc8_.height / 2;
               }
               else
               {
                  _loc8_.x = _loc8_.x - _loc8_.width;
               }
            }
            _loc7_.push(_loc8_);
         }
         else
         {
            _loc16_ = _loc11_.getAtomIndexAtCharIndex(param1);
            _loc17_ = this.adjustEndElementForBidi(param1,param2,_loc16_,param5);
            if(param5 == Direction.RTL && _loc11_.getAtomBidiLevel(_loc17_) % 2 != 0)
            {
               if(_loc17_ == 0 && param1 < param2 - 1)
               {
                  _loc7_ = this.makeSelectionBlocks(param1,param2 - 1,param3,param4,param5,param6);
                  _loc20_ = this.makeSelectionBlocks(param2 - 1,param2 - 1,param3,param4,param5,param6);
                  _loc21_ = 0;
                  while(_loc21_ < _loc20_.length)
                  {
                     _loc7_.push(_loc20_[_loc21_]);
                     _loc21_++;
                  }
                  return _loc7_;
               }
            }
            _loc18_ = _loc16_ != -1?Boolean(this.isAtomBidi(_loc16_,param5)):false;
            _loc19_ = _loc17_ != -1?Boolean(this.isAtomBidi(_loc17_,param5)):false;
            if(_loc18_ || _loc19_)
            {
               _loc22_ = param1;
               _loc23_ = param1 != param2?1:0;
               _loc24_ = _loc16_;
               _loc25_ = _loc16_;
               _loc26_ = _loc16_;
               _loc27_ = _loc18_;
               do
               {
                  _loc22_ = _loc22_ + _loc23_;
                  _loc26_ = _loc11_.getAtomIndexAtCharIndex(_loc22_);
                  _loc28_ = _loc26_ != -1?Boolean(this.isAtomBidi(_loc26_,param5)):false;
                  if(_loc26_ != -1 && _loc28_ != _loc27_)
                  {
                     _loc8_ = this.makeBlock(_loc24_,_loc25_,_loc10_,param4,param5,param6);
                     _loc7_.push(_loc8_);
                     _loc24_ = _loc26_;
                     _loc25_ = _loc26_;
                     _loc27_ = _loc28_;
                  }
                  else
                  {
                     if(_loc22_ == param2)
                     {
                        _loc8_ = this.makeBlock(_loc24_,_loc25_,_loc10_,param4,param5,param6);
                        _loc7_.push(_loc8_);
                     }
                     _loc25_ = _loc26_;
                  }
               }
               while(_loc22_ < param2);
               
            }
            else
            {
               _loc29_ = _loc9_ as InlineGraphicElement;
               if(!_loc29_ || _loc29_.float == Float.NONE)
               {
                  _loc8_ = this.makeBlock(_loc16_,_loc17_,_loc10_,param4,param5,param6);
               }
               else
               {
                  _loc8_ = _loc29_.graphic.getBounds(_loc11_);
               }
               _loc7_.push(_loc8_);
            }
         }
         return _loc7_;
      }
      
      private function makeBlock(param1:int, param2:int, param3:Rectangle, param4:String, param5:String, param6:Array) : Rectangle
      {
         var _loc16_:int = 0;
         var _loc7_:Rectangle = new Rectangle();
         var _loc8_:Point = new Point(0,0);
         if(param1 > param2)
         {
            _loc16_ = param2;
            param2 = param1;
            param1 = _loc16_;
         }
         var _loc9_:TextLine = this.getTextLine(true);
         var _loc10_:Rectangle = _loc9_.getAtomBounds(param1);
         var _loc11_:Rectangle = _loc9_.getAtomBounds(param2);
         var _loc12_:String = this._para.getEffectiveJustificationRule();
         if(param4 == BlockProgression.RL && _loc9_.getAtomTextRotation(param1) != TextRotation.ROTATE_0)
         {
            _loc8_.y = _loc10_.y;
            _loc7_.height = param1 != param2?Number(_loc11_.bottom - _loc10_.top):Number(_loc10_.height);
            if(_loc12_ == JustificationRule.EAST_ASIAN)
            {
               _loc7_.width = _loc10_.width;
            }
            else
            {
               _loc7_.width = param6[0];
               _loc8_.x = _loc8_.x - param6[1];
            }
         }
         else
         {
            _loc8_.x = _loc10_.x < _loc11_.x?Number(_loc10_.x):Number(_loc11_.x);
            if(param4 == BlockProgression.RL)
            {
               _loc8_.y = _loc10_.y + param3.width / 2;
            }
            if(_loc12_ != JustificationRule.EAST_ASIAN)
            {
               _loc7_.height = param6[0];
               if(param4 == BlockProgression.RL)
               {
                  _loc8_.x = _loc8_.x - param6[1];
               }
               else
               {
                  _loc8_.y = _loc8_.y + param6[1];
               }
               _loc7_.width = param1 != param2?Number(Math.abs(_loc11_.right - _loc10_.left)):Number(_loc10_.width);
            }
            else
            {
               _loc7_.height = _loc10_.height;
               _loc7_.width = param1 != param2?Number(Math.abs(_loc11_.right - _loc10_.left)):Number(_loc10_.width);
            }
         }
         _loc7_.x = _loc8_.x;
         _loc7_.y = _loc8_.y;
         if(param4 == BlockProgression.RL)
         {
            if(_loc9_.getAtomTextRotation(param1) != TextRotation.ROTATE_0)
            {
               _loc7_.x = _loc7_.x - _loc9_.descent;
            }
            else
            {
               _loc7_.y = _loc7_.y - _loc7_.height / 2;
            }
         }
         else
         {
            _loc7_.y = _loc7_.y + (_loc9_.descent - _loc7_.height);
         }
         var _loc13_:TextFlowLine = _loc9_.userData as TextFlowLine;
         var _loc14_:FlowLeafElement = this._para.findLeaf(_loc9_.textBlockBeginIndex + param1);
         var _loc15_:String = _loc14_.computedFormat.textRotation;
         if(_loc15_ == TextRotation.ROTATE_180 || _loc15_ == TextRotation.ROTATE_90)
         {
            if(param4 != BlockProgression.RL)
            {
               _loc7_.y = _loc7_.y + _loc7_.height / 2;
            }
            else if(_loc14_.getParentByType(TCYElement) == null)
            {
               if(_loc15_ == TextRotation.ROTATE_90)
               {
                  _loc7_.x = _loc7_.x - _loc7_.width;
               }
               else
               {
                  _loc7_.x = _loc7_.x - _loc7_.width * 0.75;
               }
            }
            else if(_loc15_ == TextRotation.ROTATE_90)
            {
               _loc7_.y = _loc7_.y + _loc7_.height;
            }
            else
            {
               _loc7_.y = _loc7_.y + _loc7_.height * 0.75;
            }
         }
         return _loc7_;
      }
      
      tlf_internal function convertLineRectToContainer(param1:Rectangle, param2:Boolean) : void
      {
         var _loc4_:TextFlow = null;
         var _loc5_:Rectangle = null;
         var _loc3_:TextLine = this.getTextLine();
         param1.x = param1.x + _loc3_.x;
         param1.y = param1.y + _loc3_.y;
         if(param2)
         {
            _loc4_ = this._para.getTextFlow();
            _loc5_ = this.controller.columnState.getColumnAt(this.columnIndex);
            constrainRectToColumn(_loc4_,param1,_loc5_,this.controller.horizontalScrollPosition,this.controller.verticalScrollPosition,this.controller.compositionWidth,this.controller.compositionHeight);
         }
      }
      
      tlf_internal function hiliteBlockSelection(param1:Shape, param2:SelectionFormat, param3:DisplayObject, param4:int, param5:int, param6:TextFlowLine, param7:TextFlowLine) : void
      {
         if(this.isDamaged() || !this._controller)
         {
            return;
         }
         var _loc8_:TextLine = this.peekTextLine();
         if(!_loc8_ || !_loc8_.parent)
         {
            return;
         }
         var _loc9_:int = this._para.getAbsoluteStart();
         param4 = param4 - _loc9_;
         param5 = param5 - _loc9_;
         this.createSelectionShapes(param1,param2,param3,param4,param5,param6,param7);
      }
      
      tlf_internal function hilitePointSelection(param1:SelectionFormat, param2:int, param3:DisplayObject, param4:TextFlowLine, param5:TextFlowLine) : void
      {
         var _loc6_:Rectangle = this.computePointSelectionRectangle(param2,param3,param4,param5,true);
         if(_loc6_)
         {
            this._controller.drawPointSelection(param1,_loc6_.x,_loc6_.y,_loc6_.width,_loc6_.height);
         }
      }
      
      tlf_internal function computePointSelectionRectangle(param1:int, param2:DisplayObject, param3:TextFlowLine, param4:TextFlowLine, param5:Boolean) : Rectangle
      {
         var _loc18_:int = 0;
         if(this.isDamaged() || !this._controller)
         {
            return null;
         }
         var _loc6_:TextLine = this.peekTextLine();
         if(!_loc6_ || !_loc6_.parent)
         {
            return null;
         }
         param1 = param1 - this._para.getAbsoluteStart();
         _loc6_ = this.getTextLine(true);
         var _loc7_:int = param1;
         var _loc8_:int = _loc6_.getAtomIndexAtCharIndex(param1);
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:ContainerFormattedElement = this._para.getAncestorWithContainer();
         var _loc12_:String = _loc11_.computedFormat.blockProgression;
         var _loc13_:String = this._para.computedFormat.direction;
         if(_loc12_ == BlockProgression.RL)
         {
            if(param1 == 0)
            {
               if(_loc6_.getAtomTextRotation(0) == TextRotation.ROTATE_0)
               {
                  _loc10_ = true;
               }
            }
            else
            {
               _loc18_ = _loc6_.getAtomIndexAtCharIndex(param1 - 1);
               if(_loc18_ != -1)
               {
                  if(_loc6_.getAtomTextRotation(_loc8_) == TextRotation.ROTATE_0 && _loc6_.getAtomTextRotation(_loc18_) != TextRotation.ROTATE_0)
                  {
                     _loc8_ = _loc18_;
                     param1--;
                     _loc9_ = true;
                  }
                  else if(_loc6_.getAtomTextRotation(_loc18_) == TextRotation.ROTATE_0)
                  {
                     _loc8_ = _loc18_;
                     param1--;
                     _loc9_ = true;
                  }
               }
            }
         }
         var _loc14_:Array = this.getRomanSelectionHeightAndVerticalAdjustment(param3,param4);
         var _loc15_:Array = this.makeSelectionBlocks(param1,_loc7_,this._para.getAbsoluteStart(),_loc12_,_loc13_,_loc14_);
         var _loc16_:Rectangle = _loc15_[0];
         this.convertLineRectToContainer(_loc16_,param5);
         var _loc17_:* = _loc13_ == Direction.RTL;
         if(_loc17_ && _loc6_.getAtomBidiLevel(_loc8_) % 2 == 0 || !_loc17_ && _loc6_.getAtomBidiLevel(_loc8_) % 2 != 0)
         {
            _loc17_ = !_loc17_;
         }
         if(_loc12_ == BlockProgression.RL && _loc6_.getAtomTextRotation(_loc8_) != TextRotation.ROTATE_0)
         {
            if(!_loc17_)
            {
               setRectangleValues(_loc16_,_loc16_.x,!_loc9_?Number(_loc16_.y):Number(_loc16_.y + _loc16_.height),_loc16_.width,1);
            }
            else
            {
               setRectangleValues(_loc16_,_loc16_.x,!_loc9_?Number(_loc16_.y + _loc16_.height):Number(_loc16_.y),_loc16_.width,1);
            }
         }
         else if(!_loc17_)
         {
            setRectangleValues(_loc16_,!_loc9_?Number(_loc16_.x):Number(_loc16_.x + _loc16_.width),_loc16_.y,1,_loc16_.height);
         }
         else
         {
            setRectangleValues(_loc16_,!_loc9_?Number(_loc16_.x + _loc16_.width):Number(_loc16_.x),_loc16_.y,1,_loc16_.height);
         }
         _loc6_.flushAtomData();
         return _loc16_;
      }
      
      tlf_internal function selectionWillIntersectScrollRect(param1:Rectangle, param2:int, param3:int, param4:TextFlowLine, param5:TextFlowLine) : int
      {
         var _loc9_:Rectangle = null;
         var _loc10_:int = 0;
         var _loc11_:SelectionCache = null;
         var _loc12_:Rectangle = null;
         var _loc6_:ContainerFormattedElement = this._para.getAncestorWithContainer();
         var _loc7_:String = _loc6_.computedFormat.blockProgression;
         var _loc8_:TextLine = this.getTextLine(true);
         if(param2 == param3)
         {
            _loc9_ = this.computePointSelectionRectangle(param2,DisplayObject(this.controller.container),param4,param5,false);
            if(_loc9_)
            {
               if(param1.containsRect(_loc9_))
               {
                  return 2;
               }
               if(param1.intersects(_loc9_))
               {
                  return 1;
               }
            }
         }
         else
         {
            _loc10_ = this._para.getAbsoluteStart();
            _loc11_ = this.getSelectionShapesCacheEntry(param2 - _loc10_,param3 - _loc10_,param4,param5,_loc7_);
            if(_loc11_)
            {
               for each(_loc12_ in _loc11_.selectionBlocks)
               {
                  _loc12_ = _loc12_.clone();
                  _loc12_.x = _loc12_.x + _loc8_.x;
                  _loc12_.y = _loc12_.y + _loc8_.y;
                  if(param1.intersects(_loc12_))
                  {
                     if(_loc7_ == BlockProgression.RL)
                     {
                        if(_loc12_.left >= param1.left && _loc12_.right <= param1.right)
                        {
                           return 2;
                        }
                     }
                     else if(_loc12_.top >= param1.top && _loc12_.bottom <= param1.bottom)
                     {
                        return 2;
                     }
                     return 1;
                  }
               }
            }
         }
         return 0;
      }
      
      private function normalizeRects(param1:Array, param2:Array, param3:Number, param4:String, param5:String) : void
      {
         var _loc8_:Rectangle = null;
         var _loc6_:Rectangle = null;
         var _loc7_:int = 0;
         while(_loc7_ < param1.length)
         {
            _loc8_ = param1[_loc7_++];
            if(param4 == BlockProgression.RL)
            {
               if(_loc8_.width < param3)
               {
                  _loc8_.width = param3;
               }
            }
            else if(_loc8_.height < param3)
            {
               _loc8_.height = param3;
            }
            if(_loc6_ == null)
            {
               _loc6_ = _loc8_;
            }
            else if(param4 == BlockProgression.RL)
            {
               if(_loc6_.y < _loc8_.y && _loc6_.y + _loc6_.height >= _loc8_.top && _loc6_.x == _loc8_.x)
               {
                  _loc6_.height = _loc6_.height + _loc8_.height;
               }
               else if(_loc8_.y < _loc6_.y && _loc6_.y <= _loc8_.bottom && _loc6_.x == _loc8_.x)
               {
                  _loc6_.height = _loc6_.height + _loc8_.height;
                  _loc6_.y = _loc8_.y;
               }
               else
               {
                  param2.push(_loc6_);
                  _loc6_ = _loc8_;
               }
            }
            else if(_loc6_.x < _loc8_.x && _loc6_.x + _loc6_.width >= _loc8_.left && _loc6_.y == _loc8_.y)
            {
               _loc6_.width = _loc6_.width + _loc8_.width;
            }
            else if(_loc8_.x < _loc6_.x && _loc6_.x <= _loc8_.right && _loc6_.y == _loc8_.y)
            {
               _loc6_.width = _loc6_.width + _loc8_.width;
               _loc6_.x = _loc8_.x;
            }
            else
            {
               param2.push(_loc6_);
               _loc6_ = _loc8_;
            }
            if(_loc7_ == param1.length)
            {
               param2.push(_loc6_);
            }
         }
      }
      
      private function adjustEndElementForBidi(param1:int, param2:int, param3:int, param4:String) : int
      {
         var _loc5_:int = param3;
         var _loc6_:TextLine = this.getTextLine(true);
         if(param2 != param1)
         {
            if((param4 == Direction.LTR && _loc6_.getAtomBidiLevel(param3) % 2 != 0 || param4 == Direction.RTL && _loc6_.getAtomBidiLevel(param3) % 2 == 0) && _loc6_.getAtomTextRotation(param3) != TextRotation.ROTATE_0)
            {
               _loc5_ = _loc6_.getAtomIndexAtCharIndex(param2);
            }
            else
            {
               _loc5_ = _loc6_.getAtomIndexAtCharIndex(param2 - 1);
            }
         }
         if(_loc5_ == -1 && param2 > 0)
         {
            return this.adjustEndElementForBidi(param1,param2 - 1,param3,param4);
         }
         return _loc5_;
      }
      
      private function isAtomBidi(param1:int, param2:String) : Boolean
      {
         var _loc3_:TextLine = this.getTextLine(true);
         return _loc3_.getAtomBidiLevel(param1) % 2 != 0 && param2 == Direction.LTR || _loc3_.getAtomBidiLevel(param1) % 2 == 0 && param2 == Direction.RTL;
      }
      
      tlf_internal function get adornCount() : int
      {
         return this._adornCount;
      }
   }
}

import flash.geom.Rectangle;

final class SelectionCache
{
    
   
   private var _begIdx:int = -1;
   
   private var _endIdx:int = -1;
   
   private var _selectionBlocks:Array = null;
   
   function SelectionCache()
   {
      super();
   }
   
   public function get begIdx() : int
   {
      return this._begIdx;
   }
   
   public function set begIdx(param1:int) : void
   {
      this._begIdx = param1;
   }
   
   public function get endIdx() : int
   {
      return this._endIdx;
   }
   
   public function set endIdx(param1:int) : void
   {
      this._endIdx = param1;
   }
   
   public function pushSelectionBlock(param1:Rectangle) : void
   {
      if(!this._selectionBlocks)
      {
         this._selectionBlocks = new Array();
      }
      this._selectionBlocks.push(param1.clone());
   }
   
   public function get selectionBlocks() : Array
   {
      return this._selectionBlocks;
   }
   
   public function clear() : void
   {
      this._selectionBlocks = null;
      this._begIdx = -1;
      this._endIdx = -1;
   }
}
