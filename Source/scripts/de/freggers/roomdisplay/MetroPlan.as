package de.freggers.roomdisplay
{
   import caurina.transitions.Tweener;
   import de.freggers.roomdisplay.metroplan.AreaContext;
   import de.freggers.roomdisplay.metroplan.AreaSelector;
   import de.freggers.roomdisplay.ui.PlayerIcon;
   import de.freggers.roomlib.Player;
   import de.freggers.util.GraphicsUtil;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public final class MetroPlan extends MetroPlanGfx
   {
      
      private static const MODE_OVERVIEW:int = 0;
      
      private static const MODE_CONTEXT_DETAIL:int = 1;
      
      private static const ICON_GROUP:String = "icons";
      
      private static const SELECTOR_GROUP:String = "selectors";
      
      private static const CONNECTOR_COLOR:uint = 4294967295;
      
      private static const CONNECTOR_ALPHA:Number = 1;
      
      private static const CONNECTOR_WIDTH:Number = 8;
      
      private static const CONNECTOR_SEGMENT_LENGTH:Number = 1;
      
      private static const CONNECTOR_SEGMENT_SPACING:Number = 14;
       
      
      private var _currentContext:AreaContext = null;
      
      private var _detailedArea:String;
      
      private var _connectionTweenPoint:Point;
      
      private var _contextDict:Dictionary;
      
      private var _mode:int;
      
      private var _selectorLayer:Sprite;
      
      public var onClose:Function;
      
      public var onGoto:Function;
      
      public var walkToLocation:Vector3D;
      
      public function MetroPlan()
      {
         super();
         this.init();
      }
      
      private static function drawConnection(param1:Graphics, param2:Point, param3:Point) : void
      {
         param1.clear();
         GraphicsUtil.drawDashedLine(param1,param2,param3,CONNECTOR_COLOR,CONNECTOR_ALPHA,CONNECTOR_WIDTH,CONNECTOR_SEGMENT_LENGTH,CONNECTOR_SEGMENT_SPACING,CapsStyle.ROUND);
      }
      
      private function init() : void
      {
         this._connectionTweenPoint = new Point();
         this._contextDict = new Dictionary(true);
         this._selectorLayer = new Sprite();
         this.initAreaContexts();
         this.disableAllContextIcons();
         addChild(this._selectorLayer);
         connections.mouseEnabled = connections.mouseChildren = false;
         background.mouseEnabled = background.mouseChildren = false;
         icons.mouseEnabled = false;
         close.buttonMode = true;
         close.mouseChildren = false;
      }
      
      private function initAreaContexts() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:DisplayObjectContainer = null;
         for each(_loc1_ in icons)
         {
            _loc1_.mouseChildren = true;
            _loc2_ = _loc1_.numChildren - 1;
            while(_loc2_ >= 0)
            {
               _loc3_ = _loc1_.getChildAt(_loc2_) as DisplayObjectContainer;
               if(_loc3_ != null)
               {
                  _loc3_.mouseEnabled = false;
                  _loc3_.mouseChildren = false;
               }
               _loc2_--;
            }
            _loc1_["usercount"].mouseEnabled = true;
            this._contextDict[_loc1_.name] = new AreaContext(_loc1_);
         }
      }
      
      private function handleStageClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget is MetroPlan && this._detailedArea != null)
         {
            this.zoomOut();
         }
      }
      
      private function animateConnection(param1:AreaContext, param2:AreaContext) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc3_:Point = new Point(param1.x,param1.y);
         this._connectionTweenPoint.x = _loc3_.x;
         this._connectionTweenPoint.y = _loc3_.y;
         var _loc4_:Point = new Point(param2.x,param2.y);
         var _loc5_:Number = 3;
         var _loc6_:Point = _loc4_.subtract(_loc3_);
         var _loc7_:Number = _loc6_.length * _loc5_ / 1000;
         Tweener.addTween(this._connectionTweenPoint,{
            "x":_loc4_.x,
            "y":_loc4_.y,
            "time":_loc7_,
            "transition":"linear",
            "onUpdate":drawConnection,
            "onUpdateParams":[connections.graphics,_loc3_,this._connectionTweenPoint]
         });
      }
      
      private function disableAllContextIcons() : void
      {
         var _loc1_:AreaContext = null;
         for each(_loc1_ in this._contextDict)
         {
            _loc1_.flags = _loc1_.flags | AreaContext.FLAG_DISABLED;
            _loc1_.gfx.buttonMode = false;
         }
      }
      
      public function handleMouseManagerData(param1:MouseManagerData) : void
      {
         if(param1.target == close)
         {
            if(param1.type == MouseManagerData.CLICK)
            {
               this.onClose();
            }
            return;
         }
         if(this._detailedArea == null)
         {
            if(param1.target.name == "usercount")
            {
               this.handleIconCountMouseManagerData(param1);
            }
            else
            {
               this.handleIconMouseManagerData(param1);
            }
         }
         else
         {
            this.handleSelectorMouseManagerData(param1);
         }
      }
      
      private function handleIconCountMouseManagerData(param1:MouseManagerData) : void
      {
         if(param1.type == MouseManagerData.CLICK)
         {
            this.zoomIn((param1.target.parent as InteractiveObject).name);
         }
      }
      
      private function handleIconMouseManagerData(param1:MouseManagerData) : void
      {
         var _loc2_:InteractiveObject = param1.target as InteractiveObject;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:AreaContext = this._contextDict[_loc2_.name];
         if(_loc3_ == null || !_loc3_.enabled)
         {
            return;
         }
         if(param1.type == MouseManagerData.MOUSE_OVER)
         {
            this.rollOver(_loc2_);
         }
         else if(param1.type == MouseManagerData.MOUSE_OUT)
         {
            this.rollOut(_loc2_);
         }
         else if(param1.type == MouseManagerData.CLICK)
         {
            this.click(_loc2_);
         }
      }
      
      private function addPlayerTween(param1:DisplayObject, param2:Number) : void
      {
         Tweener.addTween(param1,{
            "y":param1.height * (param2 - 1) / 2,
            "_scale":param2,
            "time":0.5
         });
      }
      
      private function handleSelectorMouseManagerData(param1:MouseManagerData) : void
      {
         var _loc2_:AreaSelector = param1.target as AreaSelector;
         if(_loc2_ == null)
         {
            return;
         }
         if(param1.type == MouseManagerData.MOUSE_OVER)
         {
            _loc2_.parent.setChildIndex(_loc2_,_loc2_.parent.numChildren - 1);
            if(_loc2_.isCurrent)
            {
               this.addPlayerTween(_loc2_.playerIcon,1.1);
            }
            else
            {
               Tweener.addTween(_loc2_,{
                  "_scale":1.2,
                  "time":0.5
               });
            }
         }
         else if(param1.type == MouseManagerData.MOUSE_OUT)
         {
            if(_loc2_.isCurrent)
            {
               this.addPlayerTween(_loc2_.playerIcon,1);
            }
            else
            {
               Tweener.addTween(_loc2_,{
                  "_scale":1,
                  "time":0.5
               });
            }
         }
         else if(param1.type == MouseManagerData.CLICK)
         {
            if(_loc2_.isCurrent)
            {
               this.onClose();
            }
            else
            {
               this.onGoto(_loc2_.label,true);
            }
         }
      }
      
      private function rollOver(param1:InteractiveObject) : void
      {
         if(this._contextDict[param1.name].isCurrent)
         {
            this.addPlayerTween(MovieClip(param1).playericon.getChildAt(0),1.1);
         }
         else
         {
            Tweener.addTween(param1,{
               "_scale":1.2,
               "time":0.5
            });
            this.animateConnection(this._currentContext,this._contextDict[param1.name]);
         }
      }
      
      private function rollOut(param1:InteractiveObject) : void
      {
         if(this._contextDict[param1.name].isCurrent)
         {
            this.addPlayerTween(MovieClip(param1).playericon.getChildAt(0),1);
         }
         else
         {
            Tweener.addTween(param1,{
               "_scale":1,
               "time":0.5
            });
            Tweener.removeTweens(this._connectionTweenPoint);
            connections.graphics.clear();
         }
      }
      
      private function click(param1:InteractiveObject) : void
      {
         if(this._contextDict[param1.name].isCurrent)
         {
            this.onClose();
         }
         else
         {
            this.onGoto(this._contextDict[param1.name].areaselectors[0].label,false);
         }
      }
      
      public function addAreaSelector(param1:String, param2:String, param3:String, param4:uint) : void
      {
         var _loc5_:AreaContext = this._contextDict[param1];
         if(_loc5_ == null)
         {
            return;
         }
         var _loc6_:AreaSelector = new AreaSelector(_loc5_,param2,param3,param4);
         if(!_loc5_.addAreaSelector(_loc6_))
         {
            return;
         }
         _loc5_.flags = _loc5_.flags & ~AreaContext.FLAG_DISABLED;
         _loc5_.gfx.buttonMode = true;
         _loc6_.buttonMode = true;
         _loc6_.alpha = 0;
         _loc6_.visible = false;
         for each(_loc6_ in _loc5_.areaselectors)
         {
            _loc6_.updateFilled();
         }
      }
      
      public function setCurrentLocation(param1:Player, param2:String, param3:String) : void
      {
         var _loc4_:AreaSelector = null;
         this._currentContext = this._contextDict[param2];
         if(this._currentContext == null)
         {
            return;
         }
         this._currentContext.playerIcon = new PlayerIcon(param1,6);
         for each(_loc4_ in this._currentContext.areaselectors)
         {
            if(_loc4_.label == param3)
            {
               _loc4_.playerIcon = new PlayerIcon(param1,6);
               break;
            }
         }
      }
      
      private function getContextIcon(param1:String) : MovieClip
      {
         return icons[param1];
      }
      
      public function reset() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:AreaContext = null;
         this._detailedArea = null;
         this.removeEventListener(MouseEvent.CLICK,this.handleStageClick,false);
         this.clearSelectorLayer();
         this._selectorLayer.alpha = 0;
         this._selectorLayer.visible = false;
         this.clearConnectionLayer();
         this.disableAllContextIcons();
         for each(_loc2_ in this._contextDict)
         {
            _loc2_.flags = _loc2_.flags & ~AreaContext.FLAG_INBACKGROUND;
            _loc2_.playerIcon = null;
            _loc2_.removeAllAreaSelectors();
            _loc1_ = this.getContextIcon(_loc2_.label);
            _loc1_.x = _loc2_.x;
            _loc1_.y = _loc2_.y;
            _loc1_.scaleX = 1;
            _loc1_.scaleY = 1;
            _loc1_.alpha = 1;
            _loc1_.visible = true;
            _loc1_["playericon"].visible = true;
            _loc1_["usercount"].visible = true;
            _loc1_["labels"].visible = true;
            _loc1_.mouseEnabled = true;
         }
      }
      
      private function zoomOut() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.handleStageClick,false);
         Tweener.addTween(this._selectorLayer,{
            "_autoAlpha":0,
            "time":0.5,
            "onComplete":function():void
            {
               clearSelectorLayer();
            }
         });
         this.clearConnectionLayer();
         this._selectorLayer.alpha = 0;
         this._selectorLayer.visible = false;
         this.showAllContextIconsExcept(this._detailedArea);
         var detailedContextIcon:MovieClip = this.getContextIcon(this._detailedArea);
         detailedContextIcon["playericon"].visible = true;
         detailedContextIcon["usercount"].visible = true;
         detailedContextIcon["labels"].visible = true;
         detailedContextIcon.mouseEnabled = true;
         icons.setChildIndex(detailedContextIcon,icons.numChildren - 1);
         mouseEnabled = false;
         mouseChildren = false;
         var context:AreaContext = this._contextDict[this._detailedArea];
         Tweener.addTween(detailedContextIcon,{
            "x":context.x,
            "y":context.y,
            "_scale":1,
            "alpha":1,
            "time":0.5,
            "onComplete":function():void
            {
               mouseEnabled = true;
               mouseChildren = true;
            }
         });
         this._detailedArea = null;
      }
      
      private function zoomIn(param1:String) : void
      {
         var detailedContextIcon:MovieClip = null;
         var frame:Rectangle = null;
         var broaderSide:Number = NaN;
         var higherSide:Number = NaN;
         var scaleWidth:Number = NaN;
         var scaleHeight:Number = NaN;
         var contextLabel:String = param1;
         this.clearSelectorLayer();
         this.clearConnectionLayer();
         this._selectorLayer.alpha = 1;
         this._selectorLayer.visible = true;
         this.fillSelectorLayer(contextLabel);
         this._detailedArea = contextLabel;
         this.hideAllContextIconsExcept(this._detailedArea);
         mouseEnabled = false;
         mouseChildren = false;
         detailedContextIcon = this.getContextIcon(this._detailedArea);
         var centerX:Number = background.x + background.width / 2;
         var centerY:Number = background.y + (background.height - detailedContextIcon.height) / 2 + 100;
         frame = detailedContextIcon.getBounds(detailedContextIcon);
         broaderSide = Math.max(Math.abs(frame.x),Math.abs(frame.x + frame.width));
         higherSide = Math.max(Math.abs(frame.y),Math.abs(frame.y + frame.height));
         scaleWidth = background.width / 2 / broaderSide;
         scaleHeight = background.height / 2 / higherSide;
         var scale:Number = 0.95 * Math.min(scaleWidth,scaleHeight);
         Tweener.addTween(detailedContextIcon,{
            "x":centerX,
            "y":centerY,
            "_scale":scale,
            "alpha":0.4,
            "time":0.5,
            "onComplete":function(param1:MetroPlan):void
            {
               mouseEnabled = true;
               mouseChildren = true;
               param1.addEventListener(MouseEvent.CLICK,handleStageClick,false,0,true);
            },
            "onCompleteParams":[this]
         });
         detailedContextIcon["playericon"].visible = false;
         detailedContextIcon["usercount"].visible = false;
         detailedContextIcon["labels"].visible = false;
         detailedContextIcon.mouseEnabled = false;
         icons.setChildIndex(detailedContextIcon,icons.numChildren - 1);
      }
      
      private function hideAllContextIconsExcept(param1:String) : void
      {
         var _loc2_:InteractiveObject = null;
         for each(_loc2_ in icons)
         {
            if(_loc2_.name != param1)
            {
               this._contextDict[_loc2_.name].flags = this._contextDict[_loc2_.name].flags | AreaContext.FLAG_INBACKGROUND;
               _loc2_.mouseEnabled = false;
               Tweener.addTween(_loc2_,{
                  "_autoAlpha":0,
                  "time":0.5
               });
            }
         }
      }
      
      private function showAllContextIconsExcept(param1:String) : void
      {
         var _loc2_:InteractiveObject = null;
         for each(_loc2_ in icons)
         {
            if(_loc2_.name != param1)
            {
               _loc2_.mouseEnabled = true;
               this._contextDict[_loc2_.name].flags = this._contextDict[_loc2_.name].flags & ~AreaContext.FLAG_INBACKGROUND;
               Tweener.addTween(_loc2_,{
                  "_autoAlpha":1,
                  "time":0.5
               });
            }
         }
      }
      
      private function fillSelectorLayer(param1:String) : void
      {
         var _loc2_:AreaContext = null;
         var _loc6_:uint = 0;
         var _loc8_:Array = null;
         var _loc12_:AreaSelector = null;
         var _loc13_:Number = NaN;
         _loc2_ = this._contextDict[param1];
         var _loc3_:MovieClip = this.getContextIcon(param1);
         var _loc4_:Number = background.x + background.width / 2;
         var _loc5_:Number = background.y + (background.height - AreaSelector.SIZE) / 2 + 150;
         _loc6_ = 5;
         var _loc7_:Number = AreaSelector.SIZE * 1.6;
         _loc8_ = _loc2_.areaselectors;
         var _loc9_:uint = int((_loc8_.length - 1) / _loc6_);
         var _loc10_:uint = Math.min(_loc8_.length,_loc6_);
         var _loc11_:uint = 0;
         while(_loc11_ < _loc8_.length)
         {
            _loc12_ = _loc8_[_loc11_];
            _loc12_.x = _loc4_;
            _loc12_.y = _loc5_ + _loc9_ * 20 + (int(_loc11_ / _loc6_) - _loc9_) * _loc7_;
            _loc12_.alpha = 0;
            _loc12_.visible = false;
            _loc13_ = _loc4_ + (_loc11_ % _loc6_ - (_loc10_ - 1) / 2) * _loc7_;
            this._selectorLayer.addChild(_loc12_);
            Tweener.addTween(_loc12_,{
               "_autoAlpha":1,
               "x":_loc13_,
               "time":1
            });
            _loc11_++;
         }
      }
      
      private function clearSelectorLayer() : void
      {
         var _loc1_:int = this._selectorLayer.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._selectorLayer.removeChildAt(0);
            _loc2_++;
         }
      }
      
      private function clearConnectionLayer() : void
      {
         Tweener.removeTweens(this._connectionTweenPoint);
         connections.graphics.clear();
      }
   }
}
