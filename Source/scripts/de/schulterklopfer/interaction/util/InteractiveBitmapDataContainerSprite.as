package de.schulterklopfer.interaction.util
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class InteractiveBitmapDataContainerSprite extends Sprite
   {
       
      
      protected var bitmap:Bitmap;
      
      private var _threshold:uint = 128;
      
      private var _transparentMode:Boolean = false;
      
      private var _active:Boolean = false;
      
      private var _bitmapHit:Boolean = false;
      
      private var _basePoint:Point;
      
      private var _mousePoint:Point;
      
      private var _buttonModeCache:Number = NaN;
      
      public function InteractiveBitmapDataContainerSprite()
      {
         super();
         this._basePoint = new Point();
         this._mousePoint = new Point();
         this.activateTracking();
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function get alphaTolerance() : uint
      {
         return this._threshold;
      }
      
      public function set alphaTolerance(param1:uint) : void
      {
         this._threshold = Math.min(255,param1);
      }
      
      override public function set hitArea(param1:Sprite) : void
      {
         if(param1 != null && super.hitArea == null)
         {
            this.deactivateTracking();
         }
         else if(param1 == null && super.hitArea != null)
         {
            this.activateTracking();
         }
         super.hitArea = param1;
      }
      
      override public function set mouseEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            this.activateTracking();
         }
         else
         {
            this.deactivateTracking();
         }
         super.mouseEnabled = param1;
      }
      
      private function deactivateTracking() : void
      {
         this.deactivateMouseTrap();
         removeEventListener(Event.ENTER_FRAME,this.trackMouseWhileInBounds);
         super.mouseEnabled = true;
         this._transparentMode = false;
         this.setButtonModeCache(true);
         this._bitmapHit = false;
         this._active = false;
      }
      
      private function activateTracking() : void
      {
         this.deactivateMouseTrap();
         removeEventListener(Event.ENTER_FRAME,this.trackMouseWhileInBounds);
         super.mouseEnabled = true;
         this._transparentMode = false;
         this.setButtonModeCache(true);
         this._bitmapHit = false;
         if(hitArea != null)
         {
            return;
         }
         this.activateMouseTrap();
         this._active = true;
      }
      
      private function activateMouseTrap() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.captureMouseEvent,false,10000);
         addEventListener(MouseEvent.MOUSE_OVER,this.captureMouseEvent,false,10000);
         addEventListener(MouseEvent.ROLL_OUT,this.captureMouseEvent,false,10000);
         addEventListener(MouseEvent.MOUSE_OUT,this.captureMouseEvent,false,10000);
         addEventListener(MouseEvent.MOUSE_MOVE,this.captureMouseEvent,false,10000);
      }
      
      private function deactivateMouseTrap() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.captureMouseEvent);
         removeEventListener(MouseEvent.MOUSE_OVER,this.captureMouseEvent);
         removeEventListener(MouseEvent.ROLL_OUT,this.captureMouseEvent);
         removeEventListener(MouseEvent.MOUSE_OUT,this.captureMouseEvent);
         removeEventListener(MouseEvent.MOUSE_MOVE,this.captureMouseEvent);
      }
      
      private function captureMouseEvent(param1:Event) : void
      {
         if(!this._transparentMode)
         {
            if(param1.type == MouseEvent.MOUSE_OVER || param1.type == MouseEvent.ROLL_OVER)
            {
               this.setButtonModeCache();
               this._transparentMode = true;
               super.mouseEnabled = false;
               addEventListener(Event.ENTER_FRAME,this.trackMouseWhileInBounds,false,10000,true);
               this.trackMouseWhileInBounds();
            }
         }
         if(!this._bitmapHit)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      private function trackMouseWhileInBounds(param1:Event = null) : void
      {
         var _loc5_:Point = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.bitmap != null)
         {
            _loc2_ = int(this.bitmap.mouseX);
            _loc3_ = int(this.bitmap.mouseY);
         }
         if(this._mousePoint.x == _loc2_ && this._mousePoint.y == _loc3_)
         {
            return;
         }
         this._mousePoint.x = _loc2_;
         this._mousePoint.y = _loc3_;
         var _loc4_:Boolean = false;
         if(this.bitmap != null && this.bitmap.bitmapData != null)
         {
            _loc4_ = this.bitmap.bitmapData.hitTest(this._basePoint,this._threshold,this._mousePoint);
         }
         if(_loc4_ != this._bitmapHit)
         {
            this._bitmapHit = !this._bitmapHit;
            if(this._bitmapHit)
            {
               this.deactivateMouseTrap();
               this.setButtonModeCache(true,true);
               this._transparentMode = false;
               super.mouseEnabled = true;
            }
            else if(!this._bitmapHit)
            {
               this._transparentMode = true;
               super.mouseEnabled = false;
            }
         }
         if(this.bitmap != null)
         {
            _loc5_ = this.bitmap.localToGlobal(this._mousePoint);
         }
         if(_loc5_ == null || hitTestPoint(_loc5_.x,_loc5_.y) == false)
         {
            removeEventListener(Event.ENTER_FRAME,this.trackMouseWhileInBounds);
            this._transparentMode = false;
            this.setButtonModeCache(true);
            super.mouseEnabled = true;
            this.activateMouseTrap();
         }
      }
      
      private function setButtonModeCache(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(param1)
         {
            if(this._buttonModeCache == 1)
            {
               buttonMode = true;
            }
            if(!param2)
            {
               this._buttonModeCache = NaN;
            }
            return;
         }
         this._buttonModeCache = buttonMode == true?Number(1):Number(0);
         buttonMode = false;
      }
   }
}
