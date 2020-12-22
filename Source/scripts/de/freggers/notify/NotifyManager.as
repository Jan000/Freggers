package de.freggers.notify
{
   import caurina.transitions.Tweener;
   import de.freggers.notify.events.CloseEvent;
   import de.freggers.notify.events.RequestActionEvent;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import de.schulterklopfer.interaction.manager.InteractionManager;
   import de.schulterklopfer.interaction.manager.WidgetManager;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public final class NotifyManager extends Sprite
   {
       
      
      private var _iconBox:HorizontalNotifyIconBox;
      
      private var _notifies:Dictionary;
      
      private var _notifyClasses:Dictionary;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _maximizeQueue:Vector.<NotifyElement>;
      
      private var _maximizedNotifyElement:NotifyElement;
      
      private var _animationContainer:Sprite;
      
      public var onAnyOpenCallback:Function;
      
      public var onAllClosedCallback:Function;
      
      public function NotifyManager()
      {
         super();
         this.mouseEnabled = false;
         this.init();
      }
      
      private function init() : void
      {
         this._iconBox = new HorizontalNotifyIconBox(55,10);
         this._notifyClasses = new Dictionary(true);
         this._notifies = new Dictionary(true);
         this._maximizeQueue = new Vector.<NotifyElement>();
         this._animationContainer = new Sprite();
         this._animationContainer.mouseEnabled = false;
         this._animationContainer.visible = false;
         this.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
      }
      
      public function addNotify(param1:InteractiveObject, param2:InteractiveObject = null, param3:String = null, param4:uint = 0) : NotifyElement
      {
         if(param3 != null && this._notifyClasses[param3])
         {
            return null;
         }
         if(param2 == null)
         {
            param4 = uint(param4) || uint(NotifyElement.FLAG_SHOWMAXIMIZED);
         }
         var _loc5_:NotifyElement = new NotifyElement(param1,param2,param4,param3);
         if(param3 != null)
         {
            this._notifyClasses[param3] = _loc5_;
         }
         if(_loc5_.icon != null)
         {
            this._notifies[_loc5_.icon] = _loc5_;
            this._iconBox.add(_loc5_.icon,this._maximizedNotifyElement != null);
            InteractionManager.registerForMouse(_loc5_.icon,this.handleMouseManagerData);
         }
         if((param4 & NotifyElement.FLAG_SHOWMAXIMIZED) != 0)
         {
            this.maximize(_loc5_);
         }
         return _loc5_;
      }
      
      public function removeNotifyByClass(param1:String) : void
      {
         var _loc2_:NotifyElement = this._notifyClasses[param1];
         if(_loc2_)
         {
            this.removeNotify(_loc2_);
         }
      }
      
      public function removeNotify(param1:NotifyElement) : void
      {
         InteractionManager.removeForMouse(param1.icon);
         delete this._notifies[param1.icon];
         this._iconBox.remove(param1.icon);
         if(this._maximizedNotifyElement == param1)
         {
            this._animationContainer.visible = false;
            this._animationContainer.removeChild(param1.view);
            this._maximizedNotifyElement = null;
         }
         if(this._notifyClasses[param1.notifyClass] != null)
         {
            delete this._notifyClasses[param1.notifyClass];
         }
      }
      
      public function hasNotifyForClass(param1:String) : Boolean
      {
         return this._notifyClasses[param1] != null;
      }
      
      private function handleRequestActionEvent(param1:RequestActionEvent) : void
      {
         if(param1 is CloseEvent)
         {
            if(param1.currentTarget == this._maximizedNotifyElement.view)
            {
               param1.currentTarget.removeEventListener(RequestActionEvent.EXECUTE,this.handleRequestActionEvent);
               this.closeOrRemoveCurrent();
            }
         }
      }
      
      private function handleMouseManagerData(param1:MouseManagerData) : void
      {
         var _loc2_:NotifyElement = null;
         if(param1.type == MouseManagerData.CLICK)
         {
            _loc2_ = this._notifies[param1.currentTarget];
            if(_loc2_ != null)
            {
               this.onNotifyElementClick(_loc2_);
            }
         }
      }
      
      private function onNotifyElementClick(param1:NotifyElement) : void
      {
         this.maximize(param1);
      }
      
      private function maximize(param1:NotifyElement) : void
      {
         if(this._maximizeQueue.indexOf(param1) != -1)
         {
            return;
         }
         if(this._maximizedNotifyElement == null && this._maximizeQueue.length == 0)
         {
            this._doMaximize(param1);
         }
         else
         {
            this._maximizeQueue.push(param1);
         }
      }
      
      private function minimizeCurrent() : void
      {
         if(this._maximizedNotifyElement == null)
         {
            return;
         }
         this._iconBox.show(this._maximizedNotifyElement.icon);
         var _loc1_:Rectangle = this._maximizedNotifyElement.icon.getBounds(this);
         var _loc2_:Number = _loc1_.x + _loc1_.width / 2;
         var _loc3_:Number = _loc1_.y + _loc1_.height / 2;
         WidgetManager.deactivateClickthrough();
         Tweener.addTween(this._animationContainer,{
            "x":_loc2_,
            "y":_loc3_,
            "alpha":0,
            "scaleX":0,
            "scaleY":0,
            "time":0.5,
            "onComplete":this.on_minimizeCurrent_Complete
         });
      }
      
      private function closeCurrent() : void
      {
         if(this._maximizedNotifyElement == null)
         {
            return;
         }
         WidgetManager.deactivateClickthrough();
         Tweener.addTween(this._animationContainer,{
            "alpha":0,
            "scaleX":0,
            "scaleY":0,
            "time":0.5,
            "onComplete":this.on_closeCurrent_Complete
         });
      }
      
      private function on_minimizeCurrent_Complete() : void
      {
         this._iconBox.enableAll();
         InteractionManager.enableMouseForAll(true);
         this._animationContainer.visible = false;
         this._animationContainer.removeChild(this._maximizedNotifyElement.view);
         this._maximizedNotifyElement = null;
         this.maximizeNextElementInQueue();
      }
      
      private function on_closeCurrent_Complete() : void
      {
         this.removeNotify(this._maximizedNotifyElement);
         this._iconBox.enableAll();
         InteractionManager.enableMouseForAll(true);
         this._animationContainer.visible = false;
         this.maximizeNextElementInQueue();
      }
      
      private function maximizeNextElementInQueue() : void
      {
         var _loc1_:NotifyElement = null;
         if(this._maximizeQueue.length > 0)
         {
            _loc1_ = this._maximizeQueue.shift();
            this._doMaximize(_loc1_);
         }
      }
      
      private function _doMaximize(param1:NotifyElement) : void
      {
         var _loc5_:Rectangle = null;
         if(this._maximizedNotifyElement != null)
         {
            return;
         }
         this.onAnyOpenCallback();
         this._maximizedNotifyElement = param1;
         this._maximizedNotifyElement.view.addEventListener(RequestActionEvent.EXECUTE,this.handleRequestActionEvent,false,0,true);
         var _loc2_:Rectangle = this._maximizedNotifyElement.view.getBounds(null);
         var _loc3_:Number = this._width / 2;
         var _loc4_:Number = this._height / 2;
         this._animationContainer.scaleX = this._animationContainer.scaleY = 0;
         if(this._maximizedNotifyElement.icon != null)
         {
            _loc5_ = this._maximizedNotifyElement.icon.getBounds(this);
            this._animationContainer.x = _loc5_.x + _loc5_.width / 2;
            this._animationContainer.y = _loc5_.y + _loc5_.height / 2;
         }
         else
         {
            this._animationContainer.x = this._width / 2;
            this._animationContainer.y = this._height / 2;
         }
         this._maximizedNotifyElement.view.x = -_loc2_.width / 2 - _loc2_.x;
         this._maximizedNotifyElement.view.y = -_loc2_.height / 2 - _loc2_.y;
         this._animationContainer.addChild(this._maximizedNotifyElement.view);
         this._iconBox.hide(this._maximizedNotifyElement.icon);
         this._iconBox.disableAll();
         this._animationContainer.alpha = 0;
         this._animationContainer.visible = true;
         Tweener.addTween(this._animationContainer,{
            "x":_loc3_,
            "y":_loc4_,
            "alpha":1,
            "scaleX":1,
            "scaleY":1,
            "time":0.5,
            "transition":"easeOutBack",
            "onComplete":WidgetManager.activateClickthrough,
            "onCompleteParams":[this.handleClickthroughMouseManagerData]
         });
         InteractionManager.disableMouseForAll(true);
      }
      
      private function handleClickthroughMouseManagerData(param1:MouseManagerData) : void
      {
         if(param1.type == MouseManagerData.CLICK)
         {
            this.closeOrRemoveCurrent();
         }
      }
      
      public function closeOrRemoveCurrent() : void
      {
         if(this._maximizedNotifyElement == null)
         {
            return;
         }
         this.onAllClosedCallback();
         if((this._maximizedNotifyElement.flags & NotifyElement.FLAG_PERMANENT) != 0)
         {
            this.minimizeCurrent();
         }
         else
         {
            this.closeCurrent();
         }
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false);
         this._width = stage.stageWidth;
         this._height = stage.stageHeight;
         this._iconBox.y = this._height - this._iconBox.height;
         addChild(this._iconBox);
         addChild(this._animationContainer);
         stage.addEventListener(Event.RESIZE,this.handleResize);
      }
      
      private function handleResize(param1:Event) : void
      {
         this._width = stage.stageWidth;
         this._height = stage.stageHeight;
         Tweener.addTween(this._iconBox,{
            "y":this._height - this._iconBox.height,
            "time":0.5
         });
         if(this._maximizedNotifyElement == null)
         {
            return;
         }
         var _loc2_:Number = this._width / 2;
         var _loc3_:Number = this._height / 2;
         Tweener.addTween(this._animationContainer,{
            "x":_loc2_,
            "y":_loc3_,
            "time":0.5
         });
      }
   }
}
