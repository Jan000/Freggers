package flashx.textLayout.elements
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.engine.GroupElement;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineMirrorRegion;
   import flash.text.engine.TextLineValidity;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.events.FlowElementMouseEvent;
   import flashx.textLayout.events.ModelChange;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormatValueHolder;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public final class LinkElement extends SubParagraphGroupElement implements IEventDispatcher
   {
      
      private static var _mouseInLinkElement:LinkElement;
      
      tlf_internal static const LINK_NORMAL_FORMAT_NAME:String = "linkNormalFormat";
      
      tlf_internal static const LINK_ACTIVE_FORMAT_NAME:String = "linkActiveFormat";
      
      tlf_internal static const LINK_HOVER_FORMAT_NAME:String = "linkHoverFormat";
       
      
      private var _uriString:String;
      
      private var _targetString:String;
      
      private var _linkState:String;
      
      private var _ignoreNextMouseOut:Boolean = false;
      
      private var _mouseInLink:Boolean = false;
      
      private var _isSelecting:Boolean = false;
      
      private var _keyEventsAdded:Boolean = false;
      
      private var eventDispatcher:EventDispatcher;
      
      private var _mouseDownInLink:Boolean = false;
      
      public function LinkElement()
      {
         super();
         this.eventDispatcher = new EventDispatcher();
         this._linkState = LinkState.LINK;
         this._mouseDownInLink = false;
         this._isSelecting = false;
      }
      
      private static function addLinkToMouseInArray(param1:LinkElement) : void
      {
         _mouseInLinkElement = param1;
         attachContainerEventHandlers(param1);
      }
      
      private static function removeLinkFromMouseInArray(param1:LinkElement) : void
      {
         _mouseInLinkElement = null;
         detachContainerEventHandlers(param1);
      }
      
      private static function stageMouseMoveHandler(param1:MouseEvent) : void
      {
         var textLine:TextLine = null;
         var mirrorRegions:Vector.<TextLineMirrorRegion> = null;
         var found:Boolean = false;
         var i:int = 0;
         var evt:MouseEvent = param1;
         var target:DisplayObject = evt.target as DisplayObject;
         try
         {
            while(target && !(target is TextLine))
            {
               target = target.parent;
            }
         }
         catch(e:Error)
         {
            target = null;
         }
         if(target)
         {
            textLine = target as TextLine;
            if(textLine.validity != TextLineValidity.INVALID)
            {
               mirrorRegions = textLine.mirrorRegions;
               found = false;
               if(mirrorRegions)
               {
                  i = 0;
                  while(i < mirrorRegions.length)
                  {
                     if(_mouseInLinkElement.groupElement == mirrorRegions[i].element as GroupElement)
                     {
                        found = true;
                     }
                     i++;
                  }
               }
               if(!found)
               {
                  target = null;
               }
            }
         }
         if(!target)
         {
            LinkElement.setLinksToDefaultState(evt);
            Mouse.cursor = MouseCursor.AUTO;
         }
      }
      
      private static function setLinksToDefaultState(param1:MouseEvent, param2:LinkElement = null) : void
      {
         var _loc3_:LinkElement = null;
         var _loc4_:MouseEvent = null;
         var _loc5_:FlowElementMouseEvent = null;
         if(_mouseInLinkElement && param2 != _mouseInLinkElement)
         {
            _loc3_ = _mouseInLinkElement;
            removeLinkFromMouseInArray(_loc3_);
            _loc3_._mouseInLink = false;
            _loc3_._isSelecting = false;
            _loc3_._mouseDownInLink = false;
            _loc4_ = new MouseEvent(MouseEvent.MOUSE_OUT,param1.bubbles,param1.cancelable,param1.localX,param1.localY,param1.relatedObject,param1.ctrlKey,param1.altKey,param1.shiftKey,param1.buttonDown,param1.delta);
            _loc5_ = new FlowElementMouseEvent(MouseEvent.ROLL_OUT,false,true,_loc3_,_loc4_);
            if(_loc3_.handleEvent(_loc5_))
            {
               return;
            }
            _loc3_.setHandCursor(false);
            _loc3_.setToState(LinkState.LINK);
            _loc3_._ignoreNextMouseOut = false;
         }
      }
      
      private static function findRootForEventHandlers(param1:LinkElement) : DisplayObject
      {
         var _loc3_:IFlowComposer = null;
         var _loc2_:TextFlow = param1.getTextFlow();
         if(_loc2_)
         {
            _loc3_ = _loc2_.flowComposer;
            if(_loc3_ && _loc3_.numControllers != 0)
            {
               return _loc3_.getControllerAt(0).getContainerRoot();
            }
         }
         return null;
      }
      
      private static function attachContainerEventHandlers(param1:LinkElement) : void
      {
         var _loc2_:DisplayObject = findRootForEventHandlers(param1);
         if(_loc2_)
         {
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,stageMouseMoveHandler,false,0,true);
         }
      }
      
      private static function detachContainerEventHandlers(param1:LinkElement) : void
      {
         var _loc2_:DisplayObject = findRootForEventHandlers(param1);
         if(_loc2_)
         {
            _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,stageMouseMoveHandler);
         }
      }
      
      override tlf_internal function createContentElement() : void
      {
         super.createContentElement();
         var _loc1_:EventDispatcher = getEventMirror(SubParagraphGroupElement.INTERNAL_ATTACHED_LISTENERS);
         _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler,false,0,true);
         _loc1_.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,false,0,true);
         _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler,false,0,true);
         _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler,false,0,true);
         _loc1_.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
      }
      
      override tlf_internal function get precedence() : uint
      {
         return 800;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this.eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this.eventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this.eventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this.eventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this.eventDispatcher.willTrigger(param1);
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
      
      public function get href() : String
      {
         return this._uriString;
      }
      
      public function set href(param1:String) : void
      {
         this._uriString = param1;
         modelChanged(ModelChange.ELEMENT_MODIFIED,0,textLength);
      }
      
      public function get target() : String
      {
         return this._targetString;
      }
      
      public function set target(param1:String) : void
      {
         this._targetString = param1;
         modelChanged(ModelChange.ELEMENT_MODIFIED,0,textLength);
      }
      
      public function get linkState() : String
      {
         return this._linkState;
      }
      
      override public function shallowCopy(param1:int = 0, param2:int = -1) : FlowElement
      {
         if(param2 == -1)
         {
            param2 = textLength;
         }
         var _loc3_:LinkElement = super.shallowCopy(param1,param2) as LinkElement;
         _loc3_.href = this.href;
         _loc3_.target = this.target;
         return _loc3_;
      }
      
      override tlf_internal function mergeToPreviousIfPossible() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:LinkElement = null;
         var _loc4_:FlowElement = null;
         var _loc1_:FlowGroupElement = parent;
         if(_loc1_ && !bindableElement)
         {
            _loc2_ = _loc1_.getChildIndex(this);
            if(textLength == 0)
            {
               _loc1_.replaceChildren(_loc2_,_loc2_ + 1,null);
               return true;
            }
            if(_loc2_ != 0 && (attachedListenerStatus & SubParagraphGroupElement.CLIENT_ATTACHED_LISTENERS) == 0)
            {
               _loc3_ = _loc1_.getChildAt(_loc2_ - 1) as LinkElement;
               if(_loc3_ != null && (_loc3_.attachedListenerStatus & SubParagraphGroupElement.CLIENT_ATTACHED_LISTENERS) == 0)
               {
                  if(this.href == _loc3_.href && this.target == _loc3_.target && equalStylesForMerge(_loc3_))
                  {
                     _loc4_ = null;
                     if(numChildren > 0)
                     {
                        while(numChildren > 0)
                        {
                           _loc4_ = getChildAt(0);
                           replaceChildren(0,1);
                           _loc3_.replaceChildren(_loc3_.numChildren,_loc3_.numChildren,_loc4_);
                        }
                     }
                     _loc1_.replaceChildren(_loc2_,_loc2_ + 1,null);
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      private function computeLinkFormat(param1:String) : TextLayoutFormatValueHolder
      {
         var _loc5_:* = null;
         var _loc6_:TextFlow = null;
         var _loc7_:String = null;
         var _loc2_:Object = getStyle(param1);
         if(_loc2_ == null)
         {
            _loc6_ = getTextFlow();
            _loc7_ = param1.substr(1);
            return _loc6_ == null?null:_loc6_.configuration["defaultL" + _loc7_];
         }
         if(_loc2_ is TextLayoutFormatValueHolder)
         {
            return TextLayoutFormatValueHolder(_loc2_);
         }
         var _loc3_:TextLayoutFormatValueHolder = new TextLayoutFormatValueHolder();
         var _loc4_:Object = TextLayoutFormat.description;
         for(_loc5_ in _loc4_)
         {
            if(_loc2_[_loc5_] != undefined)
            {
               _loc3_[_loc5_] = _loc2_[_loc5_];
            }
         }
         return _loc3_;
      }
      
      tlf_internal function get effectiveLinkElementTextLayoutFormat() : TextLayoutFormatValueHolder
      {
         var _loc1_:TextLayoutFormatValueHolder = null;
         if(this._linkState == LinkState.ACTIVE)
         {
            _loc1_ = this.computeLinkFormat(LINK_ACTIVE_FORMAT_NAME);
            if(_loc1_)
            {
               return _loc1_;
            }
         }
         if(this._linkState == LinkState.HOVER)
         {
            _loc1_ = this.computeLinkFormat(LINK_HOVER_FORMAT_NAME);
            if(_loc1_)
            {
               return _loc1_;
            }
         }
         return this.computeLinkFormat(LINK_NORMAL_FORMAT_NAME);
      }
      
      override tlf_internal function get formatForCascade() : TextLayoutFormatValueHolder
      {
         var _loc3_:TextLayoutFormatValueHolder = null;
         var _loc1_:TextLayoutFormatValueHolder = _formatValueHolder;
         var _loc2_:TextLayoutFormatValueHolder = this.effectiveLinkElementTextLayoutFormat;
         if(_loc2_ || _loc1_)
         {
            if(_loc2_ && _loc1_)
            {
               _loc3_ = new TextLayoutFormatValueHolder(_loc2_);
               if(_loc1_)
               {
                  _loc3_.concatInheritOnly(_loc1_);
               }
               return _loc3_;
            }
            return !!_loc1_?_loc1_:_loc2_;
         }
         return null;
      }
      
      private function redrawLink(param1:Boolean = true) : void
      {
         parent.formatChanged(true);
         var _loc2_:TextFlow = getTextFlow();
         if(_loc2_ && _loc2_.flowComposer)
         {
            _loc2_.flowComposer.updateAllControllers();
            if(this._linkState != LinkState.HOVER)
            {
               this._ignoreNextMouseOut = param1;
            }
         }
      }
      
      private function setToState(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:ITextLayoutFormat = null;
         var _loc4_:ITextLayoutFormat = null;
         if(this._linkState != param1)
         {
            _loc3_ = this.effectiveLinkElementTextLayoutFormat;
            this._linkState = param1;
            _loc4_ = this.effectiveLinkElementTextLayoutFormat;
            if(!TextLayoutFormat.isEqual(_loc3_,_loc4_))
            {
               this.redrawLink(param2);
            }
         }
      }
      
      private function setHandCursor(param1:Boolean = true) : void
      {
         var setContainerHandCursor:Function = null;
         var wmode:String = null;
         var state:Boolean = param1;
         setContainerHandCursor = function(param1:ContainerController):void
         {
            var _loc2_:Sprite = param1.container as Sprite;
            if(_loc2_)
            {
               _loc2_.buttonMode = state;
               _loc2_.useHandCursor = state;
            }
         };
         var tf:TextFlow = getTextFlow();
         if(tf != null && tf.flowComposer && tf.flowComposer.numControllers)
         {
            this.doToAllControllers(setContainerHandCursor);
            if(state)
            {
               Mouse.cursor = MouseCursor.AUTO;
            }
            else
            {
               wmode = tf.computedFormat.blockProgression;
               if(tf.interactionManager && wmode != BlockProgression.RL)
               {
                  Mouse.cursor = MouseCursor.IBEAM;
               }
               else
               {
                  Mouse.cursor = MouseCursor.AUTO;
               }
            }
         }
      }
      
      private function handleEvent(param1:FlowElementMouseEvent) : Boolean
      {
         this.eventDispatcher.dispatchEvent(param1);
         if(param1.isDefaultPrevented())
         {
            return true;
         }
         var _loc2_:TextFlow = getTextFlow();
         if(_loc2_)
         {
            _loc2_.dispatchEvent(param1);
            if(param1.isDefaultPrevented())
            {
               return true;
            }
         }
         return false;
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:FlowElementMouseEvent = null;
         if(param1.ctrlKey || getTextFlow().interactionManager == null || getTextFlow().interactionManager.editingMode == EditingMode.READ_SELECT)
         {
            if(this._mouseInLink)
            {
               this._mouseDownInLink = true;
               _loc2_ = new FlowElementMouseEvent("mouseDown",false,true,this,param1);
               if(this.handleEvent(_loc2_))
               {
                  return;
               }
               this.setHandCursor(true);
               this.setToState(LinkState.ACTIVE,false);
            }
            param1.stopImmediatePropagation();
         }
         else
         {
            this.setHandCursor(false);
            this.setToState(LinkState.LINK);
         }
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         var _loc2_:FlowElementMouseEvent = null;
         if(this._isSelecting)
         {
            return;
         }
         if(param1.ctrlKey || getTextFlow().interactionManager == null || getTextFlow().interactionManager.editingMode == EditingMode.READ_SELECT)
         {
            if(this._mouseInLink)
            {
               _loc2_ = new FlowElementMouseEvent("mouseMove",false,true,this,param1);
               if(this.handleEvent(_loc2_))
               {
                  return;
               }
               this.setHandCursor(true);
               if(param1.buttonDown)
               {
                  this.setToState(LinkState.ACTIVE,false);
               }
               else
               {
                  this.setToState(LinkState.HOVER);
               }
            }
         }
         else
         {
            this._mouseInLink = true;
            this.setHandCursor(false);
            this.setToState(LinkState.LINK);
         }
      }
      
      private function mouseOutHandler(param1:MouseEvent) : void
      {
         var _loc2_:FlowElementMouseEvent = null;
         if(!this._ignoreNextMouseOut)
         {
            this._mouseInLink = false;
            LinkElement.removeLinkFromMouseInArray(this);
            this._isSelecting = false;
            this._mouseDownInLink = false;
            _loc2_ = new FlowElementMouseEvent(MouseEvent.ROLL_OUT,false,true,this,param1);
            if(this.handleEvent(_loc2_))
            {
               return;
            }
            this.setHandCursor(false);
            this.setToState(LinkState.LINK);
         }
         this._ignoreNextMouseOut = false;
      }
      
      private function doToAllControllers(param1:Function) : void
      {
         var _loc2_:TextFlow = getTextFlow();
         var _loc3_:IFlowComposer = _loc2_.flowComposer;
         var _loc4_:int = getAbsoluteStart();
         var _loc5_:int = _loc3_.findControllerIndexAtPosition(_loc4_);
         var _loc6_:int = _loc3_.findControllerIndexAtPosition(_loc4_ + textLength - 1);
         while(_loc5_ <= _loc6_)
         {
            param1(_loc3_.getControllerAt(_loc5_));
            _loc5_++;
         }
      }
      
      private function mouseOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:FlowElementMouseEvent = null;
         if(this._mouseInLink)
         {
            return;
         }
         if(param1.buttonDown)
         {
            this._isSelecting = true;
         }
         if(this._isSelecting)
         {
            return;
         }
         this._mouseInLink = true;
         LinkElement.setLinksToDefaultState(param1,this);
         LinkElement.addLinkToMouseInArray(this);
         if(param1.ctrlKey || getTextFlow().interactionManager == null || getTextFlow().interactionManager.editingMode == EditingMode.READ_SELECT)
         {
            _loc2_ = new FlowElementMouseEvent(MouseEvent.ROLL_OVER,false,true,this,param1);
            if(this.handleEvent(_loc2_))
            {
               return;
            }
            this.setHandCursor(true);
            if(param1.buttonDown)
            {
               this.setToState(LinkState.ACTIVE,false);
            }
            else
            {
               this.setToState(LinkState.HOVER,false);
            }
         }
         else
         {
            this.setHandCursor(false);
            this.setToState(LinkState.LINK);
         }
      }
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
         var _loc2_:FlowElementMouseEvent = null;
         if(this._isSelecting)
         {
            this._isSelecting = false;
            return;
         }
         if(this._mouseInLink && (param1.ctrlKey || getTextFlow().interactionManager == null || getTextFlow().interactionManager.editingMode == EditingMode.READ_SELECT))
         {
            _loc2_ = new FlowElementMouseEvent("mouseUp",false,true,this,param1);
            if(!this.handleEvent(_loc2_))
            {
               this.setHandCursor(true);
               this.setToState(LinkState.HOVER);
               param1.stopImmediatePropagation();
            }
            if(this._mouseDownInLink)
            {
               this.mouseClickHandler(param1);
            }
         }
         else
         {
            this.setHandCursor(false);
            this.setToState(LinkState.LINK);
         }
         this._mouseDownInLink = false;
      }
      
      private function mouseClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:FlowElementMouseEvent = null;
         var _loc3_:URLRequest = null;
         if(this._isSelecting)
         {
            return;
         }
         if(param1.ctrlKey || getTextFlow().interactionManager == null || getTextFlow().interactionManager.editingMode == EditingMode.READ_SELECT)
         {
            if(this._mouseInLink)
            {
               _loc2_ = new FlowElementMouseEvent("click",false,true,this,param1);
               if(this.handleEvent(_loc2_))
               {
                  return;
               }
               if(this._uriString != null)
               {
                  if(this._uriString.length > 6 && this._uriString.substr(0,6) == "event:")
                  {
                     _loc2_ = new FlowElementMouseEvent(this._uriString.substring(6,this._uriString.length),false,true,this,param1);
                     this.handleEvent(_loc2_);
                  }
                  else
                  {
                     _loc3_ = new URLRequest(encodeURI(this._uriString));
                     navigateToURL(_loc3_,this.target);
                  }
               }
            }
            param1.stopImmediatePropagation();
         }
      }
      
      override tlf_internal function acceptTextBefore() : Boolean
      {
         return false;
      }
      
      override tlf_internal function acceptTextAfter() : Boolean
      {
         return false;
      }
      
      override tlf_internal function appendElementsForDelayedUpdate(param1:TextFlow) : void
      {
         param1.appendOneElementForUpdate(this);
         super.appendElementsForDelayedUpdate(param1);
      }
      
      override tlf_internal function updateForMustUseComposer(param1:TextFlow) : Boolean
      {
         return true;
      }
   }
}
