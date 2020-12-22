package de.freggers.ui
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public final class IconDropSprite extends Sprite
   {
      
      public static const OUTLINE:GlowFilter = new GlowFilter(16777215,1,6,6,10);
      
      public static const MOVEMENT_BOUNCE:uint = 0;
      
      public static const MOVEMENT_DIRECT:uint = 1;
       
      
      private var _dob:DisplayObject;
      
      private var _t:Number = 0;
      
      private var _destX:Number;
      
      private var _destY:Number;
      
      private var _destinationSprite:Sprite;
      
      private var _motion:uint;
      
      public function IconDropSprite(param1:DisplayObject, param2:Number, param3:Number, param4:Sprite, param5:uint)
      {
         super();
         this._dob = param1;
         this._destX = param2;
         this._destY = param3;
         this._destinationSprite = param4;
         this._motion = param5;
         this.mouseEnabled = false;
         addChild(this._dob);
      }
      
      public function get t() : Number
      {
         return this._t;
      }
      
      public function set t(param1:Number) : void
      {
         this._t = param1;
      }
      
      public function get destX() : Number
      {
         return this._destX;
      }
      
      public function get destY() : Number
      {
         return this._destY;
      }
      
      public function get destinationSprite() : Sprite
      {
         return this._destinationSprite;
      }
      
      public function get motion() : uint
      {
         return this._motion;
      }
   }
}
