package de.freggers.ui
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public final class Scrollbar extends Sprite
   {
       
      
      private var _skin:DisplayObjectContainer;
      
      private var _scroller:Sprite;
      
      private var _bg:Sprite;
      
      private var _length:Number;
      
      private var _scrollerlength:Number;
      
      private var _lastMousePosition:Point;
      
      public function Scrollbar(param1:DisplayObjectContainer, param2:Number, param3:Number, param4:Boolean = false)
      {
         super();
         this._skin = param1;
         this._length = param2;
         this._scrollerlength = param3;
         this.init();
      }
      
      private function init() : void
      {
         if(this._skin == null)
         {
            return;
         }
         if(!this._skin.hasOwnProperty("bg") || !this._skin.hasOwnProperty("scroller"))
         {
            return;
         }
         this._bg = this._skin["bg"];
         this._scroller = this._skin["scroller"];
         this._bg.height = this._length;
         this._scroller.height = this._scrollerlength;
         this._scroller.buttonMode = true;
         this.addChild(this._skin);
         this.addEventListener(Event.ADDED_TO_STAGE,this.handleAdded);
      }
      
      private function handleAdded(param1:Event) : void
      {
         if(this.root == null || this.root.stage == null)
         {
            return;
         }
         this.root.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouse,false,0,true);
         this.root.stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouse,false,0,true);
         this.root.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouse,false,0,true);
         this.root.stage.addEventListener(MouseEvent.CLICK,this.handleMouse,false,0,true);
      }
      
      private function handleMouse(param1:MouseEvent) : void
      {
         var _loc2_:Number = this._scroller.y;
         if(param1.type == MouseEvent.MOUSE_DOWN && param1.target == this._scroller)
         {
            this._lastMousePosition = new Point(this._skin.mouseX,this._skin.mouseY);
         }
         else if(param1.type == MouseEvent.MOUSE_UP)
         {
            this._lastMousePosition = null;
         }
         else if(param1.type == MouseEvent.MOUSE_MOVE && this._lastMousePosition)
         {
            this._scroller.y = this._scroller.y + (this._skin.mouseY - this._lastMousePosition.y);
            if(this._scroller.y < 0)
            {
               this._scroller.y = 0;
            }
            if(this._scroller.y + this._scroller.height > this._bg.height)
            {
               this._scroller.y = this._bg.height - this._scroller.height;
            }
            this._lastMousePosition.x = this._skin.mouseX;
            this._lastMousePosition.y = this._skin.mouseY;
         }
         else if(param1.type == MouseEvent.CLICK && param1.target == this._bg)
         {
            this._scroller.y = this._skin.mouseY - this._scroller.height / 2;
            if(this._scroller.y < 0)
            {
               this._scroller.y = 0;
            }
            if(this._scroller.y + this._scroller.height > this._bg.height)
            {
               this._scroller.y = this._bg.height - this._scroller.height;
            }
         }
         if(_loc2_ != this._scroller.y)
         {
            this.dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get position() : Number
      {
         return this._scroller.y / (this._bg.height - this._scroller.height);
      }
      
      public function set position(param1:Number) : void
      {
         if(param1 < 0 || param1 > 1)
         {
            return;
         }
         var _loc2_:Number = (this._bg.height - this._scroller.height) * param1;
         if(this._scroller.y == _loc2_)
         {
            return;
         }
         this._scroller.y = _loc2_;
         this.dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
