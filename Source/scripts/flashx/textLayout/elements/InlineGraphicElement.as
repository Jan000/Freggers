package flashx.textLayout.elements
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.Capabilities;
   import flash.text.engine.FontMetrics;
   import flash.text.engine.GraphicElement;
   import flash.text.engine.TextBaseline;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextRotation;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.events.ModelChange;
   import flashx.textLayout.events.StatusChangeEvent;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Float;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.JustificationRule;
   import flashx.textLayout.property.EnumStringProperty;
   import flashx.textLayout.property.NumberOrPercentOrEnumProperty;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public final class InlineGraphicElement extends FlowLeafElement
   {
      
      private static const LOAD_INITIATED:String = "loadInitiated";
      
      private static const OPEN_RECEIVED:String = "openReceived";
      
      private static const LOAD_COMPLETE:String = "loadComplete";
      
      private static const EMBED_LOADED:String = "embedLoaded";
      
      private static const DISPLAY_OBJECT:String = "displayObject";
      
      private static const NULL_GRAPHIC:String = "nullGraphic";
      
      private static var isMac:Boolean = Capabilities.os.search("Mac OS") > -1;
      
      tlf_internal static const heightPropertyDefinition:NumberOrPercentOrEnumProperty = new NumberOrPercentOrEnumProperty("height",FormatValue.AUTO,false,null,0,32000,"0%","1000000%",FormatValue.AUTO);
      
      tlf_internal static const widthPropertyDefinition:NumberOrPercentOrEnumProperty = new NumberOrPercentOrEnumProperty("width",FormatValue.AUTO,false,null,0,32000,"0%","1000000%",FormatValue.AUTO);
      
      tlf_internal static const rotationPropertyDefinition:EnumStringProperty = new EnumStringProperty("rotation",TextRotation.ROTATE_0,false,null,TextRotation.ROTATE_0,TextRotation.ROTATE_90,TextRotation.ROTATE_180,TextRotation.ROTATE_270);
      
      tlf_internal static const floatPropertyDefinition:EnumStringProperty = new EnumStringProperty("float",Float.NONE,false,null,Float.NONE,Float.LEFT,Float.RIGHT);
       
      
      private var _source:Object;
      
      private var _graphic:DisplayObject;
      
      private var _elementWidth:Number;
      
      private var _elementHeight:Number;
      
      private var _graphicStatus:Object;
      
      private var okToUpdateHeightAndWidth:Boolean;
      
      private var _width;
      
      private var _height;
      
      private var _measuredWidth:Number;
      
      private var _measuredHeight:Number;
      
      private var _float;
      
      public function InlineGraphicElement()
      {
         super();
         this.okToUpdateHeightAndWidth = false;
         this._measuredWidth = 0;
         this._measuredHeight = 0;
         this.internalSetWidth(undefined);
         this.internalSetHeight(undefined);
         this._float = floatPropertyDefinition.defaultValue;
         this._graphicStatus = InlineGraphicElementStatus.LOAD_PENDING;
         setTextLength(1);
         _text = String.fromCharCode(65007);
      }
      
      private static function recursiveShutDownGraphic(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         var _loc3_:int = 0;
         if(param1 is Loader)
         {
            Loader(param1).unloadAndStop();
         }
         else if(param1)
         {
            _loc2_ = param1 as DisplayObjectContainer;
            if(_loc2_)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.numChildren)
               {
                  recursiveShutDownGraphic(_loc2_.getChildAt(_loc3_));
                  _loc3_++;
               }
            }
            if(param1 is MovieClip)
            {
               MovieClip(param1).stop();
            }
         }
      }
      
      override tlf_internal function createContentElement() : void
      {
         if(_blockElement)
         {
            return;
         }
         computedFormat;
         var _loc1_:GraphicElement = new GraphicElement();
         _blockElement = _loc1_;
         _blockElement.textRotation = String(rotationPropertyDefinition.defaultValue);
         _loc1_.elementHeight = this._float != Float.NONE?Number(0):Number(this.elementHeight);
         _loc1_.elementWidth = this._float != Float.NONE?Number(0):Number(this.elementWidth);
         _loc1_.graphic = this._float != Float.NONE?new Sprite():this.graphic;
         super.createContentElement();
         _text = null;
      }
      
      override tlf_internal function canReleaseContentElement() : Boolean
      {
         return false;
      }
      
      override tlf_internal function releaseContentElement() : void
      {
         if(_blockElement == null || !this.canReleaseContentElement())
         {
            return;
         }
         _text = String.fromCharCode(65007);
         super.releaseContentElement();
      }
      
      private function getGraphicElement() : GraphicElement
      {
         if(!_blockElement)
         {
            this.createContentElement();
         }
         return GraphicElement(_blockElement);
      }
      
      public function get graphic() : DisplayObject
      {
         return this._graphic;
      }
      
      private function setGraphic(param1:DisplayObject) : void
      {
         if(_blockElement)
         {
            GraphicElement(_blockElement).graphic = this._float != Float.NONE?new Sprite():param1;
         }
         this._graphic = param1;
      }
      
      tlf_internal function get elementWidth() : Number
      {
         return this._elementWidth;
      }
      
      tlf_internal function set elementWidth(param1:Number) : void
      {
         if(_blockElement)
         {
            GraphicElement(_blockElement).elementWidth = this._float != Float.NONE?Number(0):Number(param1);
         }
         this._elementWidth = param1;
         modelChanged(ModelChange.ELEMENT_MODIFIED,0,textLength,true,false);
      }
      
      tlf_internal function get elementHeight() : Number
      {
         return this._elementHeight;
      }
      
      tlf_internal function set elementHeight(param1:Number) : void
      {
         if(_blockElement)
         {
            GraphicElement(_blockElement).elementHeight = this._float != Float.NONE?Number(0):Number(param1);
         }
         this._elementHeight = param1;
         modelChanged(ModelChange.ELEMENT_MODIFIED,0,textLength,true,false);
      }
      
      public function get status() : String
      {
         switch(this._graphicStatus)
         {
            case LOAD_INITIATED:
            case OPEN_RECEIVED:
               return InlineGraphicElementStatus.LOADING;
            case LOAD_COMPLETE:
            case EMBED_LOADED:
            case DISPLAY_OBJECT:
            case NULL_GRAPHIC:
               return InlineGraphicElementStatus.READY;
            case InlineGraphicElementStatus.LOAD_PENDING:
            case InlineGraphicElementStatus.SIZE_PENDING:
               return String(this._graphicStatus);
            default:
               return InlineGraphicElementStatus.ERROR;
         }
      }
      
      private function changeGraphicStatus(param1:Object) : void
      {
         var _loc4_:TextFlow = null;
         var _loc2_:String = this.status;
         this._graphicStatus = param1;
         var _loc3_:String = this.status;
         if(_loc2_ != _loc3_ || param1 is ErrorEvent)
         {
            _loc4_ = getTextFlow();
            if(_loc4_)
            {
               if(_loc3_ == InlineGraphicElementStatus.SIZE_PENDING)
               {
                  _loc4_.processAutoSizeImageLoaded(this);
               }
               _loc4_.dispatchEvent(new StatusChangeEvent(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE,false,false,this,_loc3_,param1 as ErrorEvent));
            }
         }
      }
      
      public function get width() : *
      {
         return this._width;
      }
      
      public function set width(param1:*) : void
      {
         this.internalSetWidth(param1);
         modelChanged(ModelChange.ELEMENT_MODIFIED,0,textLength);
      }
      
      public function get measuredWidth() : Number
      {
         return this._measuredWidth;
      }
      
      public function get actualWidth() : Number
      {
         return this.elementWidth;
      }
      
      private function widthIsComputed() : Boolean
      {
         return this.internalWidth is String;
      }
      
      private function get internalWidth() : Object
      {
         return this._width === undefined?widthPropertyDefinition.defaultValue:this._width;
      }
      
      private function computeWidth() : Number
      {
         var _loc1_:Number = NaN;
         if(this.internalWidth == FormatValue.AUTO)
         {
            if(this.internalHeight == FormatValue.AUTO)
            {
               return this._measuredWidth;
            }
            if(this._measuredHeight == 0 || this._measuredWidth == 0)
            {
               return 0;
            }
            _loc1_ = !!this.heightIsComputed()?Number(this.computeHeight()):Number(Number(this.internalHeight));
            return _loc1_ / this._measuredHeight * this._measuredWidth;
         }
         return widthPropertyDefinition.computeActualPropertyValue(this.internalWidth,this._measuredWidth);
      }
      
      private function internalSetWidth(param1:*) : void
      {
         this._width = widthPropertyDefinition.setHelper(this.width,param1);
         this.elementWidth = !!this.widthIsComputed()?Number(0):Number(Number(this.internalWidth));
         if(this.okToUpdateHeightAndWidth && this.graphic)
         {
            if(this.widthIsComputed())
            {
               this.elementWidth = this.computeWidth();
            }
            this.graphic.width = this.elementWidth;
            if(this.internalHeight == FormatValue.AUTO)
            {
               this.elementHeight = this.computeHeight();
               this.graphic.height = this.elementHeight;
            }
         }
      }
      
      public function get height() : *
      {
         return this._height;
      }
      
      public function set height(param1:*) : void
      {
         this.internalSetHeight(param1);
         modelChanged(ModelChange.ELEMENT_MODIFIED,0,textLength);
      }
      
      private function get internalHeight() : Object
      {
         return this._height === undefined?heightPropertyDefinition.defaultValue:this._height;
      }
      
      tlf_internal function get float() : *
      {
         return this._float;
      }
      
      tlf_internal function set float(param1:*) : *
      {
         var _loc2_:* = false;
         var _loc3_:GraphicElement = null;
         if(param1 === undefined)
         {
            param1 = floatPropertyDefinition.defaultValue;
         }
         param1 = floatPropertyDefinition.setHelper(this.float,param1) as String;
         if(this._float != param1)
         {
            _loc2_ = this._float == Float.NONE;
            this._float = param1;
            if(this._float != Float.NONE)
            {
               if(_loc2_ && _blockElement)
               {
                  _loc3_ = GraphicElement(_blockElement);
                  this.setGraphic(_loc3_.graphic);
                  this.elementWidth = _loc3_.elementWidth;
                  this.elementHeight = _loc3_.elementHeight;
               }
            }
            else
            {
               this._graphic.x = 0;
               this._graphic.y = 0;
               this.setGraphic(this._graphic);
               this.elementWidth = this._elementWidth;
               this.elementHeight = this._elementHeight;
            }
            modelChanged(ModelChange.ELEMENT_MODIFIED,0,textLength);
         }
      }
      
      public function get measuredHeight() : Number
      {
         return this._measuredHeight;
      }
      
      public function get actualHeight() : Number
      {
         return this.elementHeight;
      }
      
      private function heightIsComputed() : Boolean
      {
         return this.internalHeight is String;
      }
      
      private function computeHeight() : Number
      {
         var _loc1_:Number = NaN;
         if(this.internalHeight == FormatValue.AUTO)
         {
            if(this.internalWidth == FormatValue.AUTO)
            {
               return this._measuredHeight;
            }
            if(this._measuredHeight == 0 || this._measuredWidth == 0)
            {
               return 0;
            }
            _loc1_ = !!this.widthIsComputed()?Number(this.computeWidth()):Number(Number(this.internalWidth));
            return _loc1_ / this._measuredWidth * this._measuredHeight;
         }
         return heightPropertyDefinition.computeActualPropertyValue(this.internalHeight,this._measuredHeight);
      }
      
      private function internalSetHeight(param1:*) : void
      {
         this._height = heightPropertyDefinition.setHelper(this.height,param1);
         this.elementHeight = !!this.heightIsComputed()?Number(0):Number(Number(this.internalHeight));
         if(this.okToUpdateHeightAndWidth && this.graphic != null)
         {
            if(this.heightIsComputed())
            {
               this.elementHeight = this.computeHeight();
            }
            this.graphic.height = this.elementHeight;
            if(this.internalWidth == FormatValue.AUTO)
            {
               this.elementWidth = this.computeWidth();
               this.graphic.width = this.elementWidth;
            }
         }
      }
      
      private function loadCompleteHandler(param1:Event) : void
      {
         this.removeDefaultLoadHandlers();
         this.okToUpdateHeightAndWidth = true;
         var _loc2_:DisplayObject = this.graphic;
         this._measuredWidth = _loc2_.width;
         this._measuredHeight = _loc2_.height;
         if(!this.widthIsComputed())
         {
            _loc2_.width = this.elementWidth;
         }
         if(!this.heightIsComputed())
         {
            _loc2_.height = this.elementHeight;
         }
         if(param1 is IOErrorEvent)
         {
            this.changeGraphicStatus(param1);
         }
         else if(this.widthIsComputed() || this.heightIsComputed())
         {
            _loc2_.visible = false;
            this.changeGraphicStatus(InlineGraphicElementStatus.SIZE_PENDING);
         }
         else
         {
            this.changeGraphicStatus(LOAD_COMPLETE);
         }
      }
      
      private function openHandler(param1:Event) : void
      {
         this.changeGraphicStatus(OPEN_RECEIVED);
      }
      
      private function addDefaultLoadHandlers(param1:Loader) : void
      {
         var _loc2_:LoaderInfo = param1.contentLoaderInfo;
         _loc2_.addEventListener(Event.OPEN,this.openHandler,false,0,true);
         _loc2_.addEventListener(Event.COMPLETE,this.loadCompleteHandler,false,0,true);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.loadCompleteHandler,false,0,true);
      }
      
      private function removeDefaultLoadHandlers() : void
      {
         var _loc1_:Loader = Loader(this.graphic);
         _loc1_.contentLoaderInfo.removeEventListener(Event.OPEN,this.openHandler);
         _loc1_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadCompleteHandler);
         _loc1_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.loadCompleteHandler);
      }
      
      public function get source() : Object
      {
         return this._source;
      }
      
      public function set source(param1:Object) : void
      {
         this.stop(true);
         this._source = param1;
         modelChanged(ModelChange.ELEMENT_MODIFIED,0,textLength);
         this.changeGraphicStatus(InlineGraphicElementStatus.LOAD_PENDING);
      }
      
      override tlf_internal function applyDelayedElementUpdate(param1:TextFlow, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:Function = null;
         var _loc7_:Loader = null;
         var _loc8_:RegExp = null;
         var _loc9_:String = null;
         var _loc10_:URLRequest = null;
         var _loc11_:Class = null;
         if(this._graphicStatus == InlineGraphicElementStatus.LOAD_PENDING)
         {
            if(param3)
            {
               _loc4_ = this._source;
               if(_loc4_ is String)
               {
                  _loc6_ = param1.configuration.inlineGraphicResolverFunction;
                  if(_loc6_ != null)
                  {
                     _loc4_ = _loc6_(this);
                  }
               }
               if(_loc4_ is String || _loc4_ is URLRequest)
               {
                  this.okToUpdateHeightAndWidth = false;
                  _loc7_ = new Loader();
                  this.addDefaultLoadHandlers(_loc7_);
                  if(_loc4_ is String)
                  {
                     _loc8_ = /\\/g;
                     _loc9_ = _loc4_ as String;
                     _loc9_ = _loc9_.replace(_loc8_,"/");
                     if(isMac)
                     {
                        _loc10_ = new URLRequest(encodeURI(_loc9_));
                     }
                     else
                     {
                        _loc10_ = new URLRequest(_loc9_);
                     }
                     _loc7_.load(_loc10_);
                  }
                  else
                  {
                     _loc7_.load(URLRequest(_loc4_));
                  }
                  this.setGraphic(_loc7_);
                  this.changeGraphicStatus(LOAD_INITIATED);
               }
               else if(_loc4_ is Class)
               {
                  _loc11_ = _loc4_ as Class;
                  _loc5_ = DisplayObject(new _loc11_());
                  this.changeGraphicStatus(EMBED_LOADED);
               }
               else if(_loc4_ is DisplayObject)
               {
                  _loc5_ = DisplayObject(_loc4_);
                  this.changeGraphicStatus(DISPLAY_OBJECT);
               }
               else
               {
                  _loc5_ = new Shape();
                  this.changeGraphicStatus(NULL_GRAPHIC);
               }
               if(this._graphicStatus != LOAD_INITIATED)
               {
                  this.okToUpdateHeightAndWidth = true;
                  this._measuredWidth = !!_loc5_?Number(_loc5_.width):Number(0);
                  this._measuredHeight = !!_loc5_?Number(_loc5_.height):Number(0);
                  if(this.widthIsComputed())
                  {
                     if(_loc5_)
                     {
                        _loc5_.width = this.elementWidth = this.computeWidth();
                     }
                     else
                     {
                        this.elementWidth = 0;
                     }
                  }
                  else
                  {
                     _loc5_.width = Number(this.width);
                  }
                  if(this.heightIsComputed())
                  {
                     if(_loc5_)
                     {
                        _loc5_.height = this.elementHeight = this.computeHeight();
                     }
                     else
                     {
                        this.elementHeight = 0;
                     }
                  }
                  else
                  {
                     _loc5_.height = Number(this.height);
                  }
                  this.setGraphic(_loc5_);
               }
            }
         }
         else
         {
            if(this._graphicStatus == InlineGraphicElementStatus.SIZE_PENDING)
            {
               this.updateAutoSizes();
               this.graphic.visible = true;
               this.changeGraphicStatus(LOAD_COMPLETE);
            }
            if(!param3)
            {
               this.stop(param2);
            }
         }
      }
      
      override tlf_internal function updateForMustUseComposer(param1:TextFlow) : Boolean
      {
         this.applyDelayedElementUpdate(param1,false,true);
         return this.status != InlineGraphicElementStatus.READY;
      }
      
      private function updateAutoSizes() : void
      {
         if(this.widthIsComputed())
         {
            this.elementWidth = this.computeWidth();
            this.graphic.width = this.elementWidth;
         }
         if(this.heightIsComputed())
         {
            this.elementHeight = this.computeHeight();
            this.graphic.height = this.elementHeight;
         }
      }
      
      private function stop(param1:Boolean) : Boolean
      {
         var okToUnloadGraphics:Boolean = param1;
         if(this._graphicStatus == OPEN_RECEIVED || this._graphicStatus == LOAD_INITIATED)
         {
            try
            {
               Loader(this.graphic).close();
            }
            catch(e:Error)
            {
            }
            this.removeDefaultLoadHandlers();
         }
         if(this._graphicStatus != DISPLAY_OBJECT)
         {
            if(okToUnloadGraphics)
            {
               recursiveShutDownGraphic(this.graphic);
               this.setGraphic(null);
            }
            if(this.widthIsComputed())
            {
               this.elementWidth = 0;
            }
            if(this.heightIsComputed())
            {
               this.elementHeight = 0;
            }
            this.changeGraphicStatus(InlineGraphicElementStatus.LOAD_PENDING);
         }
         return true;
      }
      
      override tlf_internal function getEffectiveFontSize() : Number
      {
         if(this.float != Float.NONE)
         {
            return 0;
         }
         var _loc1_:Number = super.getEffectiveFontSize();
         return Math.max(_loc1_,this.elementHeight);
      }
      
      tlf_internal function getEffectiveAscent() : Number
      {
         if(this.float != Float.NONE)
         {
            return 0;
         }
         return this.elementHeight + GraphicElement(_blockElement).elementFormat.baselineShift;
      }
      
      tlf_internal function getTypographicAscent(param1:TextLine) : Number
      {
         var _loc3_:String = null;
         if(this.float != Float.NONE)
         {
            return 0;
         }
         var _loc2_:Number = this.elementHeight;
         if(this._computedFormat.dominantBaseline != FormatValue.AUTO)
         {
            _loc3_ = this._computedFormat.dominantBaseline;
         }
         else
         {
            _loc3_ = this.getParagraph().getEffectiveDominantBaseline();
         }
         var _loc4_:GraphicElement = GraphicElement(_blockElement);
         var _loc5_:String = _loc4_.elementFormat.alignmentBaseline == TextBaseline.USE_DOMINANT_BASELINE?_loc3_:_loc4_.elementFormat.alignmentBaseline;
         var _loc6_:Number = 0;
         if(_loc3_ == TextBaseline.IDEOGRAPHIC_CENTER)
         {
            _loc6_ = _loc6_ + _loc2_ / 2;
         }
         else if(_loc3_ == TextBaseline.IDEOGRAPHIC_BOTTOM || _loc3_ == TextBaseline.DESCENT || _loc3_ == TextBaseline.ROMAN)
         {
            _loc6_ = _loc6_ + _loc2_;
         }
         _loc6_ = _loc6_ + (param1.getBaselinePosition(TextBaseline.ROMAN) - param1.getBaselinePosition(_loc5_));
         _loc6_ = _loc6_ + _loc4_.elementFormat.baselineShift;
         return _loc6_;
      }
      
      override public function shallowCopy(param1:int = 0, param2:int = -1) : FlowElement
      {
         if(param2 == -1)
         {
            param2 = textLength;
         }
         var _loc3_:InlineGraphicElement = super.shallowCopy(param1,param2) as InlineGraphicElement;
         _loc3_.source = this.source;
         _loc3_.width = this.width;
         _loc3_.height = this.height;
         _loc3_.float = this.float;
         return _loc3_;
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
      
      override tlf_internal function appendElementsForDelayedUpdate(param1:TextFlow) : void
      {
         if(this._graphicStatus == InlineGraphicElementStatus.LOAD_PENDING || this._graphicStatus == InlineGraphicElementStatus.SIZE_PENDING || !param1.flowComposer || param1.flowComposer.numControllers == 0)
         {
            param1.appendOneElementForUpdate(this);
         }
      }
      
      override tlf_internal function calculateStrikeThrough(param1:TextLine, param2:String, param3:FontMetrics) : Number
      {
         var _loc6_:TextFlowLine = null;
         var _loc7_:int = 0;
         if(!this.graphic || this.status != InlineGraphicElementStatus.READY)
         {
            return super.calculateStrikeThrough(param1,param2,param3);
         }
         var _loc4_:Number = 0;
         var _loc5_:Rectangle = this.graphic.getBounds(param1);
         if(param2 != BlockProgression.RL)
         {
            _loc4_ = _loc5_.y + this.elementHeight / 2;
         }
         else
         {
            _loc6_ = param1.userData as TextFlowLine;
            _loc7_ = this.getAbsoluteStart() - _loc6_.absoluteStart;
            if(param1.getAtomTextRotation(_loc7_) != TextRotation.ROTATE_0)
            {
               _loc4_ = _loc5_.x + this.elementHeight / 2;
            }
            else
            {
               _loc4_ = _loc5_.x + this.elementWidth / 2;
            }
         }
         return param2 == BlockProgression.TB?Number(_loc4_):Number(-_loc4_);
      }
      
      override tlf_internal function calculateUnderlineOffset(param1:Number, param2:String, param3:FontMetrics, param4:TextLine) : Number
      {
         if(!this.graphic || this.status != InlineGraphicElementStatus.READY)
         {
            return super.calculateUnderlineOffset(param1,param2,param3,param4);
         }
         var _loc5_:Number = 0;
         if(param2 == BlockProgression.TB)
         {
            _loc5_ = this.graphic.getBounds(param4).bottom;
         }
         else
         {
            _loc5_ = this.graphic.getBounds(param4).right;
         }
         _loc5_ = _loc5_ + (param3.underlineOffset + param3.underlineThickness / 2);
         var _loc6_:ParagraphElement = this.getParagraph();
         var _loc7_:String = _loc6_.getEffectiveJustificationRule();
         if(_loc7_ == JustificationRule.EAST_ASIAN)
         {
            _loc5_ = _loc5_ + 1;
         }
         return _loc5_;
      }
   }
}
